DROP PROCEDURE CPI.GIPIS060_VALIDATE_INTM_NO;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_VALIDATE_INTM_NO(
	   p_par_id IN GIPI_WPOLBAS.par_id%TYPE,
	   p_item_no IN GIPI_WITEM.item_no%TYPE,
	   p_dflt_coverage IN GIIS_COVERAGE.coverage_cd%TYPE,
	   p_expiry_date IN VARCHAR2,
	   p_message	 OUT VARCHAR2
) IS  
  	   b540_line_cd			GIPI_WPOLBAS.line_cd%TYPE;
	   b540_subline_cd		GIPI_WPOLBAS.subline_cd%TYPE;
	   b540_iss_cd			GIPI_WPOLBAS.iss_cd%TYPE;
	   b540_issue_yy		GIPI_WPOLBAS.issue_yy%TYPE;
	   b540_pol_seq_no		GIPI_WPOLBAS.pol_seq_no%TYPE;
	   b540_renew_no		GIPI_WPOLBAS.renew_no%TYPE;
	   b540_eff_date		GIPI_WPOLBAS.eff_date%TYPE;
	   b540_expiry_date		GIPI_WPOLBAS.expiry_date%TYPE;
	   b540_nbt_policy_id   GIPI_POLBASIC.policy_id%TYPE;
	   b480_ann_tsi_amt		GIPI_WITEM.ann_tsi_amt%TYPE;
	   b480_ann_prem_amt	GIPI_WITEM.ann_prem_amt%TYPE;
	   b480_currency_cd		GIPI_WITEM.currency_cd%TYPE;
	   b480_currency_rt		GIPI_WITEM.currency_rt%TYPE;
	   b480_item_title		GIPI_WITEM.item_title%TYPE;
	   b480_coverage_cd		GIPI_WITEM.coverage_cd%TYPE;
	   b480_group_cd		GIPI_WITEM.group_cd%TYPE;
	   b480_pack_line_cd	GIPI_WITEM.pack_line_cd%TYPE;
	   b480_pack_subline_cd	GIPI_WITEM.pack_subline_cd%TYPE;
	   b480_rec_flag		GIPI_WITEM.rec_flag%TYPE;
	   b480_dsp_group_desc	VARCHAR2(50);
	   b480_dsp_coverage_desc	VARCHAR2(35);
	   b240_nbt_subline_cd  GIPI_WPOLBAS.subline_cd%TYPE;
	   b580_towing			GIPI_WVEHICLE.towing%TYPE;
	   b580_repair_lim		GIPI_WVEHICLE.repair_lim%TYPE;
	   b580_subline_cd		GIPI_WVEHICLE.subline_cd%TYPE;
	   b580_motor_no		GIPI_WVEHICLE.motor_no%TYPE;
	   b580_serial_no		GIPI_WVEHICLE.serial_no%TYPE;
	   b580_plate_no		GIPI_WVEHICLE.plate_no%TYPE;
	   v_subline_commercial GIIS_PARAMETERS.param_value_v%TYPE;
	   v_subline_lto 		GIIS_PARAMETERS.param_value_v%TYPE;
	   v_subline_motorcycle GIIS_PARAMETERS.param_value_v%TYPE;
	   v_subline_private	GIIS_PARAMETERS.param_value_v%TYPE;
	   v_expiry_date		GIPI_POLBASIC.expiry_date%TYPE;
BEGIN
   	   SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no, eff_date, expiry_date
	      INTO b540_line_cd, b540_iss_cd, b540_subline_cd, b540_issue_yy, b540_pol_seq_no,
		       b540_renew_no, b540_eff_date, b540_expiry_date
		  FROM GIPI_WPOLBAS
		 WHERE par_id = p_par_id;
		   
	    SELECT subline_cd
	      INTO b240_nbt_subline_cd
		  FROM GIPI_WPOLBAS
		 WHERE par_id = p_par_id;
		   
		v_subline_commercial := GIIS_PARAMETERS_PKG.v('COMMERCIAL VEHICLE');
		v_subline_lto 		 := GIIS_PARAMETERS_PKG.v('LAND TRANS. OFFICE');
		v_subline_motorcycle := GIIS_PARAMETERS_PKG.v('MOTORCYCLE');
		v_subline_private	 := GIIS_PARAMETERS_PKG.v('PRIVATE CAR');
		p_message			 := 'SUCCESS';
		v_expiry_date		 := TO_DATE(v_expiry_date, 'MM-DD-YYYY');
   DECLARE
	   p_eff_date           GIPI_POLBASIC.eff_date%TYPE;
	   v_max_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE;
	   v_max_endt_seq_no1   GIPI_POLBASIC.endt_seq_no%TYPE;
	   	   
	   CURSOR A IS
	      SELECT      a.policy_id policy_id, a.eff_date eff_date
	        FROM      gipi_polbasic a
	       WHERE      a.line_cd                 =  b540_line_cd
	         AND      a.iss_cd                  =  b540_iss_cd
	         AND      a.subline_cd              =  b540_subline_cd
	         AND      a.issue_yy                =  b540_issue_yy
	         AND      a.pol_seq_no              =  b540_pol_seq_no
	         AND      a.renew_no                =  b540_renew_no
	         -- lian 111501 added pol_flag = 'X'
	         AND      a.pol_flag                IN ('1','2','3','X')
	         AND    TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  TRUNC(b540_eff_date)
	         --ASI 081299 add this validation so that data that will be retrieved
	         --           is only those from endorsement prior to the current endorsement
	         --           this was consider because of the backward endorsement
	         AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540_eff_date))
	         AND    EXISTS (SELECT '1'
	                          FROM gipi_item b
	                         WHERE b.item_no = p_item_no
	                           AND b.policy_id = a.policy_id) 	 
	    ORDER BY     eff_date DESC;
	   CURSOR B(p_policy_id  gipi_item.policy_id%TYPE) IS
	      SELECT      currency_cd,
	                  currency_rt,
	                  item_title,
	                  ann_tsi_amt,
	                  ann_prem_amt,
	                  coverage_cd,
	                  group_cd
	        FROM      gipi_item
	       WHERE      policy_id   =  p_policy_id
	         AND      item_no     =  p_item_no;
	    CURSOR C(p_currency_cd giis_currency.main_currency_cd%TYPE) IS
	       SELECT    currency_desc,
	                 currency_rt,
	                 short_name
	         FROM    giis_currency
	        WHERE    main_currency_cd  =  p_currency_cd;
	        
	    CURSOR D IS
	       SELECT    a.policy_id policy_id, a.eff_date eff_date
	         FROM    gipi_polbasic a
	        WHERE    a.line_cd     =  b540_line_cd
	          AND    a.iss_cd      =  b540_iss_cd
	          AND    a.subline_cd  =  b540_subline_cd
	          AND    a.issue_yy    =  b540_issue_yy
	          AND    a.pol_seq_no  =  b540_pol_seq_no
	          AND    a.renew_no    =  b540_renew_no
	          -- lian 111501 added pol_flag = 'X'
	          AND    a.pol_flag    IN( '1','2','3','X')
	          --ASI 081299 add this validation so that data that will be retrieved
	          --           is only those from endorsement prior to the current endorsement
	          --           this was consider because of the backward endorsement
	          AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540_eff_date))
	          --AND    NVL(a.endt_expiry_date,a.expiry_date) >=  b540_eff_date
	          AND    TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
	                    a.expiry_date,b540_expiry_date,a.endt_expiry_date)) 
	                    >= TRUNC(b540_eff_date)
	          AND    NVL(a.back_stat,5) = 2
	          AND    EXISTS (SELECT '1'
	                           FROM gipi_item b
	                          WHERE b.item_no = p_item_no
	                            AND a.policy_id = b.policy_id) 	 
	          AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
	                                    FROM gipi_polbasic c
	                                   WHERE line_cd     =  b540_line_cd
	                                     AND iss_cd      =  b540_iss_cd
	                                     AND subline_cd  =  b540_subline_cd
	                                     AND issue_yy    =  b540_issue_yy
	                                     AND pol_seq_no  =  b540_pol_seq_no
	                                     AND renew_no    =  b540_renew_no
	                                     -- lian 111501 added pol_flag = 'X'
	                                     AND pol_flag  IN( '1','2','3','X')
	                                     AND TRUNC(eff_date) <= DECODE(nvl(c.endt_seq_no,0),0,TRUNC(c.eff_date), TRUNC(b540_eff_date))
	                                     --AND NVL(endt_expiry_date,expiry_date) >=  b540_eff_date
	                                     AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date),
	                                          c.expiry_date,b540_expiry_date,c.endt_expiry_date)) 
	                                          >= TRUNC(b540_eff_date)
	                                     AND NVL(c.back_stat,5) = 2
	                                     AND EXISTS (SELECT '1'
	                                                   FROM gipi_item d
	                                                  WHERE d.item_no = p_item_no
	                                                    AND c.policy_id = d.policy_id)) 	                   
	     ORDER BY   eff_date DESC;    
	    
	  v_new_item   VARCHAR2(1) := 'Y'; 
	  expired_sw   VARCHAR2(1) := 'N';
	  amt_sw       VARCHAR2(1) := 'N';
	BEGIN
	   FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
	              FROM gipi_polbasic a
	             WHERE line_cd     =  b540_line_cd
	               AND iss_cd      =  b540_iss_cd
	               AND subline_cd  =  b540_subline_cd
	               AND issue_yy    =  b540_issue_yy
	               AND pol_seq_no  =  b540_pol_seq_no
	               AND renew_no    =  b540_renew_no
	               -- lian 111501 added pol_flag = 'X'
	               AND pol_flag  IN( '1','2','3','X')
	               AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540_eff_date))
	              -- AND NVL(endt_expiry_date,expiry_date) >=  b540_eff_date
	               AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
	                    a.expiry_date,b540_expiry_date,a.endt_expiry_date)) 
	                    >= TRUNC(b540_eff_date)
	               AND EXISTS (SELECT '1'
	                             FROM gipi_item b
	                            WHERE b.item_no = p_item_no
	                              AND a.policy_id = b.policy_id)) LOOP
	      v_max_endt_seq_no := z.endt_seq_no;
	      EXIT;
	  END LOOP;                            	
	  FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
	              FROM gipi_polbasic a
	             WHERE line_cd     =  b540_line_cd
	               AND iss_cd      =  b540_iss_cd
	               AND subline_cd  =  b540_subline_cd
	               AND issue_yy    =  b540_issue_yy
	               AND pol_seq_no  =  b540_pol_seq_no
	               AND renew_no    =  b540_renew_no
	               -- lian 111501 added pol_flag = 'X'
	               AND pol_flag  IN( '1','2','3','X')
	               AND TRUNC(eff_date) <= TRUNC(b540_eff_date)
	               --AND NVL(endt_expiry_date,expiry_date) >=  b540_eff_date
	               AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
	                    a.expiry_date,b540_expiry_date,a.endt_expiry_date)) 
	                    >= TRUNC(b540_eff_date)
	               AND NVL(a.back_stat,5) = 2
	               AND EXISTS (SELECT '1'
	                             FROM gipi_item b
	                            WHERE b.item_no = p_item_no
	                              AND a.policy_id = b.policy_id)) LOOP
	      v_max_endt_seq_no1 := x.endt_seq_no;
	      EXIT;
	  END LOOP;                            	
	  --BETH 02192001 latest amount for item should be retrieved from the latest endt record
	  --     (depending on PAR eff_date).For policy w/out endt. yet then amounts will be the 
	  --     amount of policy. For policy with short term endt. amount should be recomputed by 
	  --     adding all amounts of policy and endt. that is not yet reversed
	  expired_sw := 'N';
	  -- check for the existance of short-term endt
	  FOR SW IN ( SELECT '1'
	                FROM GIPI_ITMPERIL A,
	                     GIPI_POLBASIC B
	               WHERE B.line_cd      =  b540_line_cd
	                 AND B.subline_cd   =  b540_subline_cd
	                 AND B.iss_cd       =  b540_iss_cd
	                 AND B.issue_yy     =  b540_issue_yy
	                 AND B.pol_seq_no   =  b540_pol_seq_no
	                 AND B.renew_no     =  b540_renew_no
	                 AND B.policy_id    =  A.policy_id
	                 -- lian 111501 added pol_flag = 'X'
	                 AND B.pol_flag     in('1','2','3','X')
	                 AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
	                 AND A.item_no = p_item_no
	                 AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(b540_eff_date))
	                 --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(b540_eff_date)
	                 --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
	                 --      b.expiry_date,b540_expiry_date,b.endt_expiry_date)) 
	                 --      < TRUNC(b540_eff_date)
	                 AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
	                     v_expiry_date, b.expiry_date,b.endt_expiry_date)) < TRUNC(b540_eff_date)
	            ORDER BY B.eff_date DESC)
	  LOOP
	    expired_sw := 'Y';
	    EXIT;
	  END LOOP;
	  amt_sw := 'N';
	  IF expired_sw = 'N' THEN
	  	 --get amount from the latest endt
	  	 FOR ENDT IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
	                    FROM gipi_item a,
	                         gipi_polbasic b
	                   WHERE B.line_cd      =  b540_line_cd
	                     AND B.subline_cd   =  b540_subline_cd
	                     AND B.iss_cd       =  b540_iss_cd
	                     AND B.issue_yy     =  b540_issue_yy
	                     AND B.pol_seq_no   =  b540_pol_seq_no
	                     AND B.renew_no     =  b540_renew_no
	                     AND B.policy_id    =  A.policy_id
	                     -- lian 111501 added pol_flag = 'X'
	                     AND B.pol_flag     in('1','2','3','X')                      
	                     AND A.item_no = p_item_no
	                     AND TRUNC(B.eff_date)    <=  TRUNC(b540_eff_date)
	                     --AND NVL(B.endt_expiry_date,B.expiry_date) >= b540_eff_date
	                     --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
	                     --      b.expiry_date,b540_expiry_date,b.endt_expiry_date)) 
	                     --     >= b540_eff_date
	                     AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
	              					 v_expiry_date, b.expiry_date,b.endt_expiry_date)) >= b540_eff_date      
	                     AND NVL(b.endt_seq_no, 0) > 0  -- to query records from endt. only
	                ORDER BY B.eff_date DESC)
	     LOOP
	     	 b480_ann_tsi_amt := endt.ann_tsi_amt;
	         b480_ann_prem_amt:= endt.ann_prem_amt; 
	         amt_sw := 'Y';
	       EXIT;
	     END LOOP;
	     --no endt. records found, retrieved amounts from the policy
	     IF amt_sw = 'N' THEN
	     	  FOR POL IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
	                    FROM gipi_item a,
	                         gipi_polbasic b
	                   WHERE B.line_cd      =  b540_line_cd
	                     AND B.subline_cd   =  b540_subline_cd
	                     AND B.iss_cd       =  b540_iss_cd
	                     AND B.issue_yy     =  b540_issue_yy
	                     AND B.pol_seq_no   =  b540_pol_seq_no
	                     AND B.renew_no     =  b540_renew_no
	                     AND B.policy_id    =  A.policy_id
	                     -- lian 111501 added pol_flag = 'X'
	                     AND B.pol_flag     in('1','2','3','X')                      
	                     AND A.item_no = p_item_no
	                     AND NVL(b.endt_seq_no, 0) = 0)
	        LOOP
	     	    b480_ann_tsi_amt := pol.ann_tsi_amt;
	          b480_ann_prem_amt:= pol.ann_prem_amt; 
	          EXIT;
	        END LOOP;
	     END IF;   
	  ELSE   
	     p_message := GIPIS060_EXTRACT_ANN_AMT2(p_par_id, p_item_no, b480_ann_prem_amt,  b480_ann_tsi_amt);
		 IF p_message <> 'SUCCESS' THEN
		 	RETURN;
		 END IF;
	  END IF;
	  
	  IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                             	
	    FOR D1 IN D LOOP
	     b540_nbt_policy_id := d1.policy_id;    /* To store the policy id of the policy */
	     FOR B1 IN B(D1.policy_id) LOOP
	       IF p_eff_date  IS NULL THEN
	         p_eff_date  :=  D1.eff_date;
	         b480_currency_cd  :=  B1.currency_cd;
	         b480_currency_rt  :=  B1.currency_rt;
	         b480_item_title   :=  B1.item_title;
	         --b480_ann_tsi_amt  :=  B1.ann_tsi_amt;
	         --b480_ann_prem_amt :=  B1.ann_prem_amt;
	         b480_coverage_cd  :=  B1.coverage_cd;
	         b480_group_cd     :=  B1.group_cd;
	         v_new_item := 'N';
	         --GET_GIPI_WVEHICLE_INFO;
	       END IF;
	       IF D1.eff_date > p_eff_date THEN
	         p_eff_date  :=  D1.eff_date;
	         b480_currency_cd  :=  B1.currency_cd;
	         b480_currency_rt  :=  B1.currency_rt;
	         b480_item_title   :=  B1.item_title;
	         b480_coverage_cd  :=  B1.coverage_cd;
	         v_new_item := 'N';	         
	         --GET_GIPI_WVEHICLE_INFO;
	       END IF;
	     END LOOP;
	     FOR C1 IN C(b480_currency_cd) LOOP
	         --b480_dsp_currency_desc  :=  c1.currency_desc;
	         b480_currency_rt        :=  c1.currency_rt;
	         --b480_dsp_short_name     :=  c1.short_name;
	     END LOOP;
	     exit;
	   END LOOP;
	 ELSE
	   FOR A1 IN A LOOP
	     b540_nbt_policy_id := a1.policy_id;    /* To store the policy id of the policy */
	     FOR B1 IN B(A1.policy_id) LOOP
	       IF p_eff_date  IS NULL THEN
	         p_eff_date  :=  A1.eff_date;
	         b480_currency_cd  :=  B1.currency_cd;
	         b480_currency_rt  :=  B1.currency_rt;
	         b480_item_title   :=  B1.item_title;
	         b480_coverage_cd  :=  B1.coverage_cd;
	         b480_group_cd     :=  B1.group_cd;
	         v_new_item := 'N';
	         --GET_GIPI_WVEHICLE_INFO;
	       END IF;
	       IF A1.eff_date > p_eff_date THEN
	         p_eff_date  :=  A1.eff_date;
	         b480_currency_cd  :=  B1.currency_cd;
	         b480_currency_rt  :=  B1.currency_rt;
	         b480_item_title   :=  B1.item_title;
	         b480_coverage_cd  :=  B1.coverage_cd;
	         v_new_item := 'N';
	         --GET_GIPI_WVEHICLE_INFO;
	       END IF;
	     END LOOP;
	     FOR C1 IN C(b480_currency_cd) LOOP
	         --b480_dsp_currency_desc  :=  c1.currency_desc;
	         b480_currency_rt        :=  c1.currency_rt;
	         --b480_dsp_short_name     :=  c1.short_name;
	     END LOOP;
	     exit;
	   END LOOP;
	 END IF;	    	
	   IF v_new_item = 'Y' THEN
	      FOR A1 IN (SELECT  main_currency_cd,
	                         currency_desc,
	                         currency_rt
	                   FROM  giis_currency
	                  WHERE  currency_rt = 1) LOOP
	         b480_item_title          := null;
	         b480_currency_cd         := a1.main_currency_cd;
	         --b480_dsp_currency_desc   := a1.currency_desc;
	         b480_currency_rt         := a1.currency_rt;
	         EXIT;
	       END LOOP;
	  --BETH 121699 initialize default coverage
	  FOR cov IN 
	      ( SELECT coverage_cd, coverage_desc
	          FROM giis_coverage
	         WHERE coverage_cd = p_dflt_coverage
	       ) LOOP
	       b480_coverage_cd   := cov.coverage_cd;
	       --b480_dsp_coverage_desc := cov.coverage_desc;
	  END LOOP;     
	/* Default DEDUCTIBLE AMOUNT, TOWING LIMIT, LOADING FACTOR   */
	/* DEDUCTIBLE DISCOUNT, COMPREHENSIVE DISCOUNT, PLATE NUMBER */
	/* from those specified in the giis_parameters table         */
	
	DECLARE
	  CURSOR B  IS   
	        SELECT  param_name, param_value_n
	          FROM  giis_parameters
	         WHERE  param_name LIKE 'TOWING%';
	                  
	  CURSOR F  IS   
	        SELECT  param_name, param_value_v
	          FROM  giis_parameters
	         WHERE  param_name LIKE 'PLATE NUMBER%';
	
	BEGIN
	   FOR B_REC IN B LOOP   /* For Towing */
	      IF b_rec.param_name = 'TOWING LIMIT - CV' 
	        AND b240_nbt_subline_cd = v_subline_commercial THEN
	          b580_towing := b_rec.param_value_n;
	      ELSIF b_rec.param_name = 'TOWING LIMIT - LTO' 
	        AND b240_nbt_subline_cd = v_subline_lto THEN
	          b580_towing := b_rec.param_value_n;
	      ELSIF b_rec.param_name = 'TOWING LIMIT - MCL' 
	        AND b240_nbt_subline_cd = v_subline_motorcycle THEN
	          b580_towing := b_rec.param_value_n;
	      ELSIF b_rec.param_name = 'TOWING LIMIT - PC' 
	        AND b240_nbt_subline_cd = v_subline_private THEN
	          b580_towing := b_rec.param_value_n;
	
	      /* Created by: Charie
	                     Aug. 18, 1998
	         the default value for towing limit for package policy
	      */
	      ELSIF b_rec.param_name = 'TOWING LIMIT - CV'
	         OR b_rec.param_name = 'TOWING LIMIT - LTO'
	         OR b_rec.param_name = 'TOWING LIMIT - MCL'
	         OR b_rec.param_name = 'TOWING LIMIT - PC'
	        AND b480_pack_line_cd IS NOT NULL
	        AND b480_pack_subline_cd IS NOT NULL THEN
	          b580_towing := b_rec.param_value_n;
	      END IF;
	   END LOOP;
	END ;	      
	      b480_rec_flag     := 'A';
	      b480_ann_tsi_amt  := NULL;
	      b480_ann_prem_amt := NULL;
	      b580_subline_cd   := NULL;
	      b580_motor_no     := NULL;
	      b580_serial_no    := NULL;
	      b580_plate_no     := NULL;
	      b480_group_cd     := NULL;
	      b480_dsp_group_desc  := NULL;
	      b480_coverage_cd     := NULL;
	      b480_dsp_coverage_desc := NULL;
	      --SET_ITEM_PROPERTY('b580_DSP_MOTOR_TYPE_DESC',REQUIRED,PROPERTY_TRUE);
		  --SET_ITEM_PROPERTY('b580_DSP_SUBLINE_TYPE_DESC',REQUIRED,PROPERTY_TRUE);
	   ELSE
	      --SET_ITEM_PROPERTY('b580_DSP_MOTOR_TYPE_DESC',REQUIRED,PROPERTY_FALSE);
		  --SET_ITEM_PROPERTY('b580_DSP_SUBLINE_TYPE_DESC',REQUIRED,PROPERTY_FALSE);
	      b480_rec_flag   := 'C';
	   END IF;
	   FOR A1 IN 
	       ( SELECT coverage_desc 
	           FROM giis_coverage
	          WHERE coverage_cd = b480_coverage_cd
	        ) LOOP
	        b480_dsp_coverage_desc := a1.coverage_desc;
	        END LOOP;  
	   FOR A2 IN 
	       ( SELECT group_desc 
	           FROM giis_group
	          WHERE group_cd = b480_group_cd
	        ) LOOP
	        b480_dsp_group_desc := a2.group_desc;
	   END LOOP;
	   IF NVL(b480_currency_cd,0) = 0 THEN
	            p_message := 'Philippine Peso not found in the maintenance table of currency. '||
	                      'Please contact your database administrator.';
	   END IF;             
   END;
END;
/


