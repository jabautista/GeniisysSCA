DROP PROCEDURE CPI.LOSS_RATIO_EXT_BY_ASSURED;

CREATE OR REPLACE PROCEDURE CPI.Loss_Ratio_Ext_By_Assured (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
                       p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
                       p_loss_date          gipi_polbasic.issue_date%TYPE,
                       p_date_param         NUMBER,
                       p_issue_param        NUMBER,
                       p_counter       OUT  NUMBER) AS
  v_curr1_date         gipi_polbasic.issue_date%TYPE;
  v_curr2_date         gipi_polbasic.issue_date%TYPE;
  v_prev1_date         gipi_polbasic.issue_date%TYPE;
  v_prev2_date         gipi_polbasic.issue_date%TYPE;
  v_prev_year          VARCHAR2(4);
  v_exists             VARCHAR2(1);
  /*BETH 03/03/2003
  **     this procedure extract amounts to be used in loss ratio(per line) reports
  **     parameters for line, subline, iss_cd are available
  **     parameter for policy date(p_date_param) will have the following values
  **                1 -   issue date
  **                2 -   effectivity date
  **                3 -   accounting entry date
  **                4 -   booking month
  **     parameter for policy date(p_issue_param) will have the following values
  **                1 -  issue code of policy
  **                2 -  issue code of claim record
  */
BEGIN
  --initialize dates
  --current dates are from beginning of the year for p_loss_date and
  --until the given loss date (p_loss_date)
  --previous dates are the whole of the previous year of loss date
  --(if loss date is January 23, 1999, prev. year will be the whole of 1999)
  v_curr1_date     := TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY');
  v_curr2_date     := TRUNC(p_loss_date);
  v_prev_year      := TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1);
  v_prev1_date    := TO_DATE('01-01-'||v_prev_year,'MM-DD-YYYY');
  v_prev2_date     := TO_DATE('12-31-'||v_prev_year,'MM-DD-YYYY');

  -- extract premium
  IF p_date_param = 3 THEN
     Lratio_Extract_Premium2
       (p_line_cd,         p_subline_cd,     p_iss_cd,
        p_session_id,      p_date_param,     p_issue_param,
	    v_curr1_date,      v_curr2_date,     v_prev1_date,
	    v_prev2_date,      v_prev_year);
  ELSE
     Lratio_Extract_Premium
       (p_line_cd,         p_subline_cd,     p_iss_cd,
        p_session_id,      p_date_param,     p_issue_param,
	    v_curr1_date,      v_curr2_date,     v_prev1_date,
    	v_prev2_date,      v_prev_year);
  END IF;

  -- extract outstanding loss
  Lratio_Extract_Os
    (p_line_cd,         p_subline_cd,     p_iss_cd,
     p_session_id,      p_date_param,     p_issue_param,
	 v_curr1_date,      v_curr2_date,     v_prev2_date,
	 v_prev_year);

  -- extract losses paid
  Lratio_Extract_Losses_Paid
    (p_line_cd,         p_subline_cd,     p_iss_cd,
     p_session_id,      p_date_param,     p_issue_param,
	 v_curr1_date,      v_curr2_date);

  -- extract los  recovery
  Lratio_Extract_Recovery
    (p_line_cd,         p_subline_cd,     p_iss_cd,
     p_session_id,      p_date_param,     p_issue_param,
	 v_curr1_date,     v_curr2_date,      v_prev_year);

  --insert record in table gicl_loss_ratio_ext
  --current pemium
  FOR curr_prem IN(
    SELECT assd_no, NVL(SUM(prem_amt),0) prem
      FROM gicl_lratio_curr_prem_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    INSERT INTO gicl_loss_ratio_ext
      (session_id,    line_cd,	        subline_cd,
       iss_cd,        loss_ratio_date,  assd_no,
       curr_prem_amt, user_id)
    VALUES
      (p_session_id,    p_line_cd,      p_subline_cd,
       p_iss_cd,        p_loss_date,    curr_prem.assd_no,
       curr_prem.prem,  USER);
  END LOOP;
  --previous pemium
  FOR prev_prem IN(
    SELECT assd_no, NVL(SUM(prem_amt),0) prem
      FROM gicl_lratio_prev_prem_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND assd_no = prev_prem.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET prev_prem_amt = NVL(prev_prem_amt,0) + prev_prem.prem
       WHERE session_id = p_session_id
         AND assd_no = prev_prem.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        loss_ratio_date,       assd_no,
          prev_prem_amt, user_id)
       VALUES
         (p_session_id,    p_line_cd,      p_subline_cd,
          p_iss_cd,        p_loss_date,    prev_prem.assd_no,
          prev_prem.prem,  USER);
    END IF;
  END LOOP;
  --current loss
  FOR curr_loss IN(
    SELECT assd_no, NVL(SUM(os_amt),0) loss
      FROM gicl_lratio_curr_os_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND assd_no = curr_loss.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET curr_loss_res = NVL(curr_loss_res,0) + curr_loss.loss
       WHERE session_id = p_session_id
         AND assd_no = curr_loss.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        loss_ratio_date,       assd_no,
          curr_loss_res, user_id)
       VALUES
         (p_session_id,    p_line_cd,      p_subline_cd,
          p_iss_cd,        p_loss_date,    curr_loss.assd_no,
          curr_loss.loss,  USER);
    END IF;
  END LOOP;
  --previous loss
  FOR prev_loss IN(
    SELECT assd_no, NVL(SUM(os_amt),0) loss
      FROM gicl_lratio_prev_os_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND assd_no = prev_loss.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET prev_loss_res = NVL(prev_loss_res,0) + prev_loss.loss
       WHERE session_id = p_session_id
         AND assd_no = prev_loss.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        loss_ratio_date,       assd_no,
          prev_loss_res, user_id)
       VALUES
         (p_session_id,    p_line_cd,      p_subline_cd,
          p_iss_cd,        p_loss_date,    prev_loss.assd_no,
          prev_loss.loss,  USER);
    END IF;
  END LOOP;
  --losses paid
  FOR losses IN(
    SELECT assd_no, NVL(SUM(loss_paid),0) loss_paid
      FROM gicl_lratio_loss_paid_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND assd_no = losses.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET loss_paid_amt = NVL(loss_paid_amt,0) + losses.loss_paid
       WHERE session_id = p_session_id
         AND assd_no = losses.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        loss_ratio_date,       assd_no,
          loss_paid_amt, user_id)
       VALUES
         (p_session_id,    p_line_cd,      p_subline_cd,
          p_iss_cd,        p_loss_date,    losses.assd_no,
          losses.loss_paid,  USER);
    END IF;
  END LOOP;
  --current recovery
  FOR curr_rec IN(
    SELECT assd_no, NVL(SUM(recovered_amt),0) recovery
      FROM gicl_lratio_curr_recovery_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND assd_no = curr_rec.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET curr_loss_res = NVL(curr_loss_res,0) - curr_rec.recovery
       WHERE session_id = p_session_id
         AND assd_no = curr_rec.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        loss_ratio_date,       assd_no,
          curr_loss_res, user_id)
       VALUES
         (p_session_id,    p_line_cd,      p_subline_cd,
          p_iss_cd,        p_loss_date,    curr_rec.assd_no,
          -curr_rec.recovery,  USER);
    END IF;
  END LOOP;
  --current recovery
  FOR prev_rec IN(
    SELECT assd_no, NVL(SUM(recovered_amt),0) recovery
      FROM gicl_lratio_prev_recovery_ext
     WHERE session_id = p_session_id
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND assd_no = prev_rec.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET prev_loss_res = NVL(prev_loss_res,0) - prev_rec.recovery
       WHERE session_id = p_session_id
         AND assd_no = prev_rec.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        loss_ratio_date,       assd_no,
          prev_loss_res, user_id)
       VALUES
         (p_session_id,    p_line_cd,      p_subline_cd,
          p_iss_cd,        p_loss_date,    prev_rec.assd_no,
          -prev_rec.recovery,  USER);
    END IF;
  END LOOP;
  COMMIT;
END;
/

DROP PROCEDURE CPI.LOSS_RATIO_EXT_BY_ASSURED;
