DROP PROCEDURE CPI.LRATIO_EXTRACT_BY_ASSURED;

CREATE OR REPLACE PROCEDURE CPI.Lratio_Extract_By_Assured
                      (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
					   p_peril_cd           giis_peril.peril_cd%TYPE,
                       p_intm_no            giis_intermediary.intm_no%TYPE,
                       p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
			     p_loss_date          gicl_claims.loss_date%TYPE,
                       p_counter       OUT  NUMBER,
                       p_ext_proc           VARCHAR2) AS
  /*BETH 03/0382003
  **     this procedure summarized all data from loss rstio extract tables
  **     for insert on final table of loss ratio gicl_loss_ratio_ext
  **JEROME 08/03/2005
  **	   added conditions for handling computation of premium amounts for Mn
  */
  v_exists      VARCHAR2(1);
  v_line_cd		giis_line.line_cd%TYPE; --Jerom 08032005
  v_ast			VARCHAR2(1) :='*'; --Jerome 08042005
  v_prev_prem_res  gicl_loss_ratio_ext.prev_prem_amt%TYPE;
  v_curr_prem_res  gicl_loss_ratio_ext.prev_prem_amt%TYPE;
BEGIN
  p_counter :=0;
    FOR curr_prem IN(
      SELECT assd_no, NVL(SUM(prem_amt),0) prem
        FROM gicl_lratio_curr_prem_ext
       WHERE session_id = p_session_id
        AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
       GROUP BY assd_no)
    LOOP
      INSERT INTO gicl_loss_ratio_ext
        (session_id,    line_cd,	        subline_cd,
         iss_cd,        peril_cd,           loss_ratio_date,
		 assd_no,       intm_no,            curr_prem_amt,
		 user_id)
      VALUES
        (p_session_id,      p_line_cd,      p_subline_cd,
         p_iss_cd,          p_peril_cd,     p_loss_date,
		 curr_prem.assd_no, p_intm_no,      curr_prem.prem,
		 USER);
	  p_counter  := p_counter + 1;
    END LOOP;
    --previous pemium
    FOR prev_prem IN(
      SELECT assd_no, NVL(SUM(prem_amt),0) prem
        FROM gicl_lratio_prev_prem_ext
       WHERE session_id = p_session_id
        AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
       GROUP BY assd_no)
    LOOP
      v_exists := 'N';
      FOR chk_exists IN(
        SELECT '1'
          FROM gicl_loss_ratio_ext
         WHERE session_id = p_session_id
           AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
           AND assd_no = prev_prem.assd_no)
      LOOP
        UPDATE gicl_loss_ratio_ext
           SET prev_prem_amt = NVL(prev_prem_amt,0) + prev_prem.prem
         WHERE session_id = p_session_id
           AND assd_no = prev_prem.assd_no;
        v_exists := 'Y';
      END LOOP;
      IF v_exists = 'N' THEN
	     p_counter  := p_counter + 1;
	  INSERT INTO gicl_loss_ratio_ext
          (session_id,    line_cd,	      subline_cd,
           iss_cd,        peril_cd,       loss_ratio_date,
		   assd_no,       intm_no,        prev_prem_amt,
		   user_id)
        VALUES
          (p_session_id,      p_line_cd,      p_subline_cd,
           p_iss_cd,          p_peril_cd,     p_loss_date,
		   prev_prem.assd_no, p_intm_no,      prev_prem.prem,
		   USER);
      END IF;
    END LOOP;
  --current loss
  FOR curr_loss IN(
    SELECT assd_no, NVL(SUM(os_amt),0) loss
      FROM gicl_lratio_curr_os_ext
     WHERE session_id = p_session_id
      AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND assd_no = curr_loss.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET curr_loss_res = NVL(curr_loss_res,0) + curr_loss.loss
       WHERE session_id = p_session_id
         AND assd_no = curr_loss.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
  	   p_counter  := p_counter + 1;
       INSERT INTO gicl_loss_ratio_ext
         (session_id,      line_cd,	          subline_cd,
          iss_cd,          peril_cd,          loss_ratio_date,
		  assd_no,         intm_no,           curr_loss_res,
		  user_id)
       VALUES
         (p_session_id,      p_line_cd,         p_subline_cd,
          p_iss_cd,          p_peril_cd,        p_loss_date,
		  curr_loss.assd_no, p_intm_no,         curr_loss.loss,
		  USER);
    END IF;
  END LOOP;
  --previous loss
  FOR prev_loss IN(
    SELECT assd_no, NVL(SUM(os_amt),0) loss
      FROM gicl_lratio_prev_os_ext
     WHERE session_id = p_session_id
      AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND assd_no = prev_loss.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET prev_loss_res = NVL(prev_loss_res,0) + prev_loss.loss
       WHERE session_id = p_session_id
         AND assd_no = prev_loss.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
	   p_counter  := p_counter + 1;
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	      subline_cd,
          iss_cd,        peril_cd,        loss_ratio_date,
		  assd_no,       intm_no,         prev_loss_res,
		  user_id)
       VALUES
         (p_session_id,       p_line_cd,       p_subline_cd,
          p_iss_cd,           p_peril_cd,      p_loss_date,
		  prev_loss.assd_no,  p_intm_no,       prev_loss.loss,
		  USER);
    END IF;
  END LOOP;
  --losses paid
  FOR losses IN(
    SELECT assd_no, NVL(SUM(loss_paid),0) loss_paid
      FROM gicl_lratio_loss_paid_ext
     WHERE session_id = p_session_id
      AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND assd_no = losses.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET loss_paid_amt = NVL(loss_paid_amt,0) + losses.loss_paid
       WHERE session_id = p_session_id
         AND assd_no = losses.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
   	   p_counter  := p_counter + 1;
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	        subline_cd,
          iss_cd,        peril_cd,          loss_ratio_date,
		  assd_no,       intm_no,           loss_paid_amt,
		  user_id)
       VALUES
         (p_session_id,    p_line_cd,         p_subline_cd,
          p_iss_cd,        p_peril_cd,        p_loss_date,
		  losses.assd_no,  p_intm_no,         losses.loss_paid,
		  USER);
    END IF;
  END LOOP;
  --current recovery
  FOR curr_rec IN(
    SELECT assd_no, NVL(SUM(recovered_amt),0) recovery
      FROM gicl_lratio_curr_recovery_ext
     WHERE session_id = p_session_id
      AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND assd_no = curr_rec.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET curr_loss_res = NVL(curr_loss_res,0) - curr_rec.recovery
       WHERE session_id = p_session_id
         AND assd_no = curr_rec.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
       p_counter  := p_counter + 1;
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	         subline_cd,
          iss_cd,        peril_cd,           loss_ratio_date,
		  assd_no,       intm_no,            curr_loss_res,
		  user_id)
       VALUES
         (p_session_id,      p_line_cd,          p_subline_cd,
          p_iss_cd,          p_peril_cd,         p_loss_date,
		  curr_rec.assd_no,  p_intm_no,          -curr_rec.recovery,
		  USER);
    END IF;
  END LOOP;
  --current recovery
  FOR prev_rec IN(
    SELECT assd_no, NVL(SUM(recovered_amt),0) recovery
      FROM gicl_lratio_prev_recovery_ext
     WHERE session_id = p_session_id
      AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
    GROUP BY assd_no)
  LOOP
    v_exists := 'N';
    FOR chk_exists IN(
      SELECT '1'
        FROM gicl_loss_ratio_ext
       WHERE session_id = p_session_id
         AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND assd_no = prev_rec.assd_no)
    LOOP
      UPDATE gicl_loss_ratio_ext
         SET prev_loss_res = NVL(prev_loss_res,0) - prev_rec.recovery
       WHERE session_id = p_session_id
         AND assd_no = prev_rec.assd_no;
      v_exists := 'Y';
    END LOOP;
    IF v_exists = 'N' THEN
	   p_counter  := p_counter + 1;
       INSERT INTO gicl_loss_ratio_ext
         (session_id,    line_cd,	         subline_cd,
          iss_cd,        peril_cd,           loss_ratio_date,
		  assd_no,       intm_no,            prev_loss_res,
		  user_id)
       VALUES
         (p_session_id,      p_line_cd,          p_subline_cd,
          p_iss_cd,          p_peril_cd,         p_loss_date,
		  prev_rec.assd_no,  p_intm_no,          -prev_rec.recovery,
		  USER);
    END IF;
  END LOOP;
  FOR prem_res IN (SELECT assd_no, prev_prem_amt,curr_prem_amt
            	     FROM gicl_loss_ratio_ext
                    WHERE session_id = p_session_id
                     AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS204',USER) = 1 --angelo092507
                  )
  LOOP
    v_prev_prem_res := 0;
    v_curr_prem_res := 0;
    IF p_ext_proc = 'S' THEN
       v_prev_prem_res := NVL(prem_res.prev_prem_amt,0) *.4;
       v_curr_prem_res := NVL(prem_res.curr_prem_amt,0) *.4;
    ELSE
		FOR c IN (SELECT param_value_v
			  	  FROM giis_parameters
				  WHERE param_name = 'LINE_CODE_MN')
		LOOP
			v_line_cd := c.param_value_v;
		EXIT;
		END LOOP;
       IF NVL(prem_res.curr_prem_amt,0) <> 0 THEN
	   	  IF NVL(p_line_cd,v_line_cd) = v_line_cd THEN --Jerome 08052005 handling current years premium for MN
          FOR curr_prem IN (SELECT assd_no, ROUND(SUM(prem*factor),2) prem
                              FROM (SELECT assd_no, NVL(SUM(prem_amt),0) prem, factor
                                      FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b
                                     WHERE 1=1
                                       AND col_mm = TO_NUMBER(TO_CHAR(date_for_24th,'MM'),99)
                                       AND a.session_id = p_session_id
									   AND a.session_id = b.session_id
                                                                           AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
									   AND b.line_cd = v_line_cd
			   	       AND assd_no = prem_res.assd_no
                                     GROUP BY assd_no, factor)
                              GROUP BY assd_no)
	      LOOP
	        v_curr_prem_res := v_curr_prem_res + NVL(curr_prem.prem,0);
          END LOOP;
		END IF;
	  IF NVL(p_line_cd,v_ast) <> v_line_cd THEN
	     FOR curr_prem IN (SELECT assd_no, ROUND(SUM(prem*factor),2) prem
					  	 	FROM (SELECT assd_no, NVL(SUM(prem_amt),0) prem, factor
								 	FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b
								   WHERE 1=1
								     AND col_mm = TO_NUMBER(TO_CHAR(date_for_24th,'MM'),99)
									 AND a.session_id = p_session_id
									   AND a.session_id = b.session_id
                                                                           AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
									   AND b.line_cd <> v_line_cd
 			   	                        AND assd_no = prem_res.assd_no
                                     GROUP BY assd_no, factor)
                              GROUP BY assd_no)
	  LOOP
		    v_curr_prem_res := v_curr_prem_res + NVL(curr_prem.prem,0);
		END LOOP;
	   END IF;
	  END IF;
	 END IF;
      IF NVL(prem_res.prev_prem_amt,0) <> 0 THEN
	   	  IF NVL(p_line_cd,v_line_cd) = v_line_cd THEN --Jerome 08052005 handling current years premium for MN
          FOR prev_prem IN (SELECT assd_no, ROUND(SUM(prem*factor),2) prem
                              FROM (SELECT assd_no, NVL(SUM(prem_amt),0) prem, factor
                                      FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                     WHERE 1=1
                                       AND col_mm = TO_NUMBER(TO_CHAR(date_for_24th,'MM'),99)
                                       AND a.session_id = p_session_id
									   AND a.session_id = b.session_id
                                                                           AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
									   AND b.line_cd = v_line_cd
                 			   	       AND assd_no = prem_res.assd_no
                                     GROUP BY assd_no, factor)
                              GROUP BY assd_no)
	      LOOP
	        v_prev_prem_res := v_prev_prem_res + NVL(prev_prem.prem,0);
          END LOOP;
	   END IF;
	   IF NVL(p_line_cd,v_ast) <> v_line_cd THEN
	      FOR prev_prem IN (SELECT assd_no, ROUND(SUM(prem*factor),2) prem
					  	 	FROM (SELECT assd_no, NVL(SUM(prem_amt),0) prem, factor
								 	FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
								   WHERE 1=1
								     AND col_mm = TO_NUMBER(TO_CHAR(date_for_24th,'MM'),99)
									 AND a.session_id = p_session_id
									   AND a.session_id = b.session_id
                                                                           AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
									   AND b.line_cd <> v_line_cd
			   	       AND assd_no = prem_res.assd_no
                                     GROUP BY assd_no, factor)
                              GROUP BY assd_no)
	  LOOP
		    v_prev_prem_res := v_prev_prem_res + NVL(prev_prem.prem,0);
		END LOOP;
	   END IF;
    END IF;
    UPDATE gicl_loss_ratio_ext
       SET prev_prem_res = v_prev_prem_res,
	   curr_prem_res = v_curr_prem_res
     WHERE session_id = p_session_id
       AND assd_no = prem_res.assd_no;
  END LOOP;
  COMMIT;
END;
/


