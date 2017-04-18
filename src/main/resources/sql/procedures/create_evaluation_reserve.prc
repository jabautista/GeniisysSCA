DROP PROCEDURE CPI.CREATE_EVALUATION_RESERVE;

CREATE OR REPLACE PROCEDURE CPI.Create_Evaluation_Reserve(p_claim_id     	NUMBER,
	   	  		  									  p_item_no			NUMBER,
													  p_grouped_item_no	NUMBER,
													  p_peril_cd		NUMBER,
													  p_evaluation_amt  NUMBER,
													  p_currency_cd     NUMBER,
													  p_convert_rate    NUMBER) IS
  -- variable to be use for storing hist_seq_no to be used by new reserve record
  v_hist_seq_no  	GICL_CLM_RES_HIST.hist_seq_no%TYPE := 1;     
  -- variable to be use for storing old hist_seq_no to be used for update of prev reserve and payments
  v_hist_seq_no_old  	GICL_CLM_RES_HIST.hist_seq_no%TYPE := 0;
  -- variable to be use for storing clm_res_hist_id to be used by new reserve record
  v_clm_res_hist	GICL_CLM_RES_HIST.clm_res_hist_id%TYPE := 1;
  -- variable to be use for storing previous loss reseve to be used by new reserve record  
  v_prev_loss_res       GICL_CLM_RES_HIST.prev_loss_res%TYPE :=0;
  -- variable to be use for storing previous exp. reseve to be used by new reserve record  
  v_prev_exp_res        GICL_CLM_RES_HIST.prev_loss_res%TYPE :=0;
  -- variable to be use for storing previous loss paid to be used by new reserve record  
  v_prev_loss_paid      GICL_CLM_RES_HIST.prev_loss_res%TYPE :=0;
  -- variable to be use for storing previous exp.paid to be used by new reserve record  
  v_prev_exp_paid       GICL_CLM_RES_HIST.prev_loss_res%TYPE :=0;
  -- variable to be use for storing reserve currency
  v_currency_cd         GICL_CLM_RES_HIST.currency_cd%TYPE;
    -- variable to be use for storing reserve currency rate
  v_currency_rt         GICL_CLM_RES_HIST.convert_rate%TYPE;
  -- variable to be use for storing amount cfMC evaluation for reserve creation  
  v_evaluation_amt      GICL_CLM_RES_HIST.prev_loss_res%TYPE :=0;
  -- variable to be use for storing policy's line_cd
  v_line_cd	  	 		gipi_polbasic.line_cd%TYPE;
  -- variable to be use for storing policy's subline_cd
  v_subline_cd	  	 		gipi_polbasic.subline_cd%TYPE;
  -- variable to be use for storing policy's iss_cd
  v_iss_cd	  	 		gipi_polbasic.iss_cd%TYPE;
  -- variable to be use for storing claim's iss_cd
  v_clm_iss_cd			gipi_polbasic.iss_cd%TYPE;
  -- variable to be use for storing policy's issue_yy
  v_issue_yy  	 		gipi_polbasic.issue_yy%TYPE;
  -- variable to be use for storing policy's pol_seq_no
  v_pol_seq_no	  	    gipi_polbasic.pol_seq_no%TYPE;
  -- variable to be use for storing policy's renew_no
  v_renew_no	  	 	gipi_polbasic.renew_no%TYPE;
  -- variable to be use for storing policy's effectivity date
  v_pol_eff_date	  	gicl_claims.pol_eff_date%TYPE;
  -- variable to be use for storing policy's expiry date
  v_expiry_date	  	gicl_claims.expiry_date%TYPE;
  -- variable to be use for storing claims's loss date
  v_loss_date	  	gicl_claims.loss_date%TYPE;    
  -- variable to be use for storing claims's file date
  v_file_date	  	gicl_claims.clm_file_date%TYPE;            
  -- variable to be use for storing maximum accounting date
  v_max_acct_date	  	gicl_claims.clm_file_date%TYPE;
  -- variable to be use for storing maximum accounting date
  v_max_post_date	  	gicl_claims.clm_file_date%TYPE;
  --this variable will be used to store the type of reseve booking from giis_parameters
  v_book_param          giac_parameters.param_value_v%TYPE := Giacp.v('RESERVE BOOKING');
  --this variable will be used to store the reserve record's booking year
  v_booking_year       GICL_CLM_RES_HIST.booking_year%TYPE;
  --this variable will be used to store the reserve record's booking month
  v_booking_month      GICL_CLM_RES_HIST.booking_month%TYPE;
  -- variable to be use for storing policy's catastrophic_cd
  v_cat_cd             gicl_claims.catastrophic_cd%TYPE;  
  v_flag               NUMBER;
BEGIN
  -- retrieve policy and claim information
  FOR get_info IN
    (SELECT line_cd, 	   subline_cd,	  pol_iss_cd,
			issue_yy, 	   pol_seq_no,    renew_no,
			expiry_date,   pol_eff_date,  loss_date,
			clm_file_date, iss_cd,        catastrophic_cd	 
	   FROM gicl_claims
	  WHERE claim_id = p_claim_id)
  LOOP
    v_line_cd	   := get_info.line_cd;
    v_subline_cd   := get_info.subline_cd;
    v_iss_cd	   := get_info.pol_iss_cd;
    v_clm_iss_cd   := get_info.iss_cd;
    v_issue_yy     := get_info.issue_yy;
    v_pol_seq_no   := get_info.pol_seq_no;
    v_renew_no	   := get_info.renew_no;
    v_pol_eff_date := get_info.pol_eff_date;
    v_expiry_date  := get_info.expiry_date;
    v_loss_date	   := get_info.loss_date;    
    v_file_date	   := get_info.clm_file_date;
	v_cat_cd       := get_info.catastrophic_cd;
    EXIT;
  END LOOP;	   	 
  -- get max hist_seq_no from gicl_clm_res_hist for insert of new reserve record
  FOR hist IN
    (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) + 1 seq_no
       FROM GICL_CLM_RES_HIST
       WHERE claim_id = p_claim_id
         AND item_no  = p_item_no
         AND peril_cd = p_peril_cd) 
  LOOP
    v_hist_seq_no := hist.seq_no;
    EXIT;
  END LOOP; --end hist loop
  -- get prev hist_seq_no from gicl_clm_res_hist for update of previous amounts
  FOR old_hist IN
    (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) seq_no
       FROM GICL_CLM_RES_HIST
       WHERE claim_id = p_claim_id
         AND item_no  = p_item_no
         AND peril_cd = p_peril_cd
         AND NVL(dist_sw,'N') = 'Y')
  LOOP
    v_hist_seq_no_old := old_hist.seq_no;
    EXIT;
  END LOOP; --end old_hist loop
  -- get max clm_res_hist_id from gicl_clm_res_hist for insert of new reserve record
  FOR hist_id IN
    (SELECT NVL(MAX(NVL(clm_res_hist_id,0)),0) + 1 hist_id
       FROM GICL_CLM_RES_HIST
       WHERE claim_id = p_claim_id)
  LOOP
    v_clm_res_hist := hist_id.hist_id;
    EXIT;
  END LOOP; --end hist_id loop
  -- get prev amounts from gicl_clm_res_hist using old hist_seq_no 
  -- for insert of new reserve record
  FOR prev_amt IN
    (SELECT NVL(loss_reserve,0) loss_reserve, 
            NVL(expense_reserve,0) expense_reserve,
            NVL(losses_paid,0)  losses_paid, 
            NVL(expenses_paid,0) expenses_paid
       FROM GICL_CLM_RES_HIST
      WHERE claim_id    = p_claim_id
        AND item_no     = p_item_no
        AND peril_cd    = p_peril_cd
        AND hist_seq_no = v_hist_seq_no_old)
  LOOP
    v_prev_loss_res  := prev_amt.loss_reserve;
    v_prev_exp_res   := prev_amt.expense_reserve;
    v_prev_loss_paid := prev_amt.losses_paid;
    v_prev_exp_paid  := prev_amt.expenses_paid;
  END LOOP;  -- end prev_amt loop
  -- retrieve valid booking date for this record
  -- extract values from giac_tran_mm
  -- with validation on tables giac_acctrans, gicl_take_up_hist
  -- which is not later than the maximum acct_date for OL transactions
  -- and which is not yet closed in giac_tran_mm 
  -- retrieve maximum acct_date from giac_acctrans for outstanding loss
  -- transactions
  FOR MAX_ACCT_DATE  IN
    (SELECT TRUNC(MAX(acct_date), 'MONTH') acct_date
       FROM gicl_take_up_hist d, giac_acctrans e
      WHERE d.acct_tran_id = e.tran_id 
        AND e.tran_class = 'OL'
        AND e.tran_flag NOT IN ('D','P'))
  LOOP
    v_max_acct_date   := max_acct_date.acct_date;
  END LOOP;   
  -- retrieve maximum acct_date from giac_acctrans for outstanding loss
  -- transactions
  FOR MAX_POST_DATE  IN
    (SELECT TRUNC(MAX(acct_date), 'MONTH') acct_date
       FROM gicl_take_up_hist d, giac_acctrans e
      WHERE d.acct_tran_id = e.tran_id 
        AND e.tran_class = 'OL'
        AND e.tran_flag = 'P')
  LOOP
    v_max_post_date   := max_post_date.acct_date;
  END LOOP;
  IF v_max_post_date IS NOT NULL THEN
     FOR booking_date IN 
       (SELECT DECODE(A.tran_mm,1,'JANUARY',     2,'FEBRUARY',
                                3,'MARCH',       4,'APRIL',
                                5, 'MAY',        6,'JUNE',
                                7, 'JULY',       8,'AUGUST',
                                9, 'SEPTEMBER', 10, 'OCTOBER',
                               11, 'NOVEMBER',  12,'DECEMBER') booking_month,
               A.tran_yr booking_year, A.tran_mm
          FROM giac_tran_mm A, gicl_claims b
         WHERE ROWNUM <= 1
           AND A.closed_tag = 'N'
           AND A.branch_cd = v_clm_iss_cd
           AND TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY') >=
               TRUNC(DECODE(v_book_param,'L',v_loss_date,v_file_date), 'MONTH')
           AND TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY')
               >= NVL( v_max_acct_date,
                 TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY'))
          AND TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY')
              >  v_max_post_date
        ORDER BY A.tran_yr ASC, A.tran_mm ASC)
     LOOP
        v_booking_month := booking_date.booking_month;
        v_booking_year  := booking_date.booking_year;
		EXIT; 
     END LOOP; -- end loop booking_date
  ELSE
     FOR booking_date IN 
       (SELECT DECODE(A.tran_mm,1,'JANUARY',     2,'FEBRUARY',
                                3,'MARCH',       4,'APRIL',
                                5, 'MAY',        6,'JUNE',
                                7, 'JULY',       8,'AUGUST',
                                9, 'SEPTEMBER', 10, 'OCTOBER',
                                11, 'NOVEMBER', 12,'DECEMBER') booking_month,
               A.tran_yr booking_year, A.tran_mm
          FROM giac_tran_mm A, gicl_claims b
         WHERE ROWNUM <= 1
           AND A.closed_tag = 'N'
           AND A.branch_cd = v_clm_iss_cd
           AND TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY') >=
               TRUNC(DECODE(v_book_param,'L',v_loss_date,v_file_date), 'MONTH')
           AND TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY')
               >= NVL( v_max_acct_date,
                  TO_DATE('01-'||TO_CHAR(A.tran_mm)||'-'||TO_CHAR(A.tran_yr),'DD-MM-YYYY'))
         ORDER BY A.tran_yr ASC, A.tran_mm ASC)
      LOOP
        v_booking_month := booking_date.booking_month;
        v_booking_year  := booking_date.booking_year;   
        EXIT; 
      END LOOP; -- end loop booking_date  
  END IF;
  IF v_booking_month IS NULL OR v_booking_year IS NULL THEN 
     RAISE_APPLICATION_ERROR(-20631,'CANNOT GENERATE BOOKING DATE.');
  END IF;
  -- insert record into table gicl_clm_res_hist
  INSERT INTO GICL_CLM_RES_HIST
    (claim_id,		     clm_res_hist_id,	hist_seq_no,
     item_no,		     peril_cd,		    grouped_item_no,
     user_id,            last_update,	    loss_reserve,		
	 expense_reserve,    dist_sw,           booking_month,   
	 booking_year,       currency_cd,  	    convert_rate,
	 prev_loss_res,      prev_loss_paid,    prev_exp_res,		
	 prev_exp_paid,      distribution_date)
  VALUES
    (p_claim_id,	     v_clm_res_hist,	v_hist_seq_no,
     p_item_no,          p_peril_cd,        0,
     USER,               SYSDATE,           p_evaluation_amt, 
	 v_prev_exp_res,     'Y',		        v_booking_month,
	 v_booking_year,     p_currency_cd,	    p_convert_rate,	
	 v_prev_loss_res,    v_prev_loss_paid,	v_prev_exp_res,		  
	 v_prev_exp_paid,    SYSDATE);
  --update claim status after first reserve set-up   
  IF v_clm_res_hist = 1 THEN 
     UPDATE gicl_claims
        SET clm_stat_cd = 'OP'
      WHERE claim_id = p_claim_id;
  END IF;    
  -- update previous distributed record in gicl_clm_res_hist
  -- set its dist_sw = N and negate date = sysdate
  UPDATE GICL_CLM_RES_HIST
     SET dist_sw     = 'N',
	       negate_date = SYSDATE
   WHERE claim_id = p_claim_id
     AND item_no  = p_item_no
     AND peril_cd = p_peril_cd
     AND NVL(dist_sw, 'N') = 'Y'
     AND hist_seq_no <> v_hist_seq_no;
 BEGIN
  SELECT 1
    INTO v_flag
    FROM gicl_clm_reserve
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no
	 AND peril_cd = p_peril_cd;
  -- update gicl_clm_reserve table for new loss reserve amount
  UPDATE gicl_clm_reserve
     SET loss_reserve = p_evaluation_amt 
   WHERE claim_id = p_claim_id
     AND item_no  = p_item_no
     AND peril_cd = p_peril_cd;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN	 
   		INSERT INTO gicl_clm_reserve(claim_Id, item_no, peril_cd, grouped_item_no, loss_reserve, currency_cd, convert_rate)
		 VALUES(p_claim_id, p_item_no, p_peril_cd, p_grouped_item_no, p_evaluation_amt, p_currency_cd, p_convert_rate);
 END;	 
  -- call procedure which will generate records in claims distribution tables
  -- gicl_reserve_ds and gicl_reserve_rids
  Process_Reserve_Distribution(p_claim_id,		p_item_no,			   p_grouped_item_no,
							   p_peril_cd,      p_evaluation_amt,      v_prev_exp_res,													  
                               v_clm_res_hist,  v_hist_seq_no,  	   v_line_cd,
						  	   v_subline_cd,    v_iss_cd,		  	   v_issue_yy,
                               v_pol_seq_no,    v_renew_no,            v_pol_eff_date,
							   v_expiry_date,   v_loss_date,           v_file_date,
							   v_cat_cd);
END; -- end create evaluation resevr
/


