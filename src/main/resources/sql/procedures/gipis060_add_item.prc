DROP PROCEDURE CPI.GIPIS060_ADD_ITEM;

CREATE OR REPLACE PROCEDURE CPI.gipis060_add_item(
	   p_par_id	    gipi_wpolbas.par_id%TYPE,
	   p_item_no    gipi_witem.item_no%TYPE,
	   p_message	OUT VARCHAR2)
 IS
   v_new_item           VARCHAR2(1) := 'Y';
   expired_sw           VARCHAR2(1) := 'N';
   amt_sw               VARCHAR2(1) := 'N';
   v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE; 
   v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE; 
   v_ann_tsi            gipi_witem.ann_tsi_amt%TYPE;    
   v_ann_prem           gipi_witem.ann_prem_amt%TYPE;

   CURSOR A IS
       SELECT    a.policy_id
         FROM    gipi_polbasic a, gipi_wpolbas b540
        WHERE    a.line_cd     =  b540.line_cd
          AND    a.iss_cd      =  b540.iss_cd
          AND    a.subline_cd  =  b540.subline_cd
          AND    a.issue_yy    =  b540.issue_yy
          AND    a.pol_seq_no  =  b540.pol_seq_no
          AND    a.renew_no    =  b540.renew_no
          AND    a.pol_flag    IN( '1','2','3','X')
          AND    TRUNC(a.eff_date)  <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540.eff_date))
          AND    TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >= TRUNC(b540.eff_date)
          AND    EXISTS (SELECT '1'
                           FROM gipi_item b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id) 	
		  AND	 b540.par_id = p_par_id 
     ORDER BY   a.eff_date DESC;
    CURSOR B(p_policy_id  gipi_item.policy_id%TYPE) IS
       SELECT    currency_cd,
                 currency_rt,
                 item_title,
                 ann_tsi_amt,
                 ann_prem_amt,
                 coverage_cd,
                 group_cd
         FROM    gipi_item
        WHERE    item_no   =    p_item_no
          AND    policy_id =    p_policy_id;
    CURSOR C(p_currency_cd giis_currency.main_currency_cd%TYPE) IS
       SELECT    currency_desc
         FROM    giis_currency
        WHERE    main_currency_cd  =  p_currency_cd;

    CURSOR D(p_policy_id gipi_polbasic.policy_id%TYPE) IS
       SELECT  subline_cd,
               motor_no,
               plate_no,
               serial_no,
               coc_type,coc_yy,
               mot_type,           --gmi
               unladen_wt,         --gmi
               subline_type_cd,    --gmi
               motor_coverage,      --gmi
               assignee,
               ctv_tag
         FROM  gipi_vehicle
         WHERE policy_id = p_policy_id
          AND item_no = p_item_no;
   
     CURSOR E IS
       SELECT    a.policy_id
         FROM    gipi_polbasic a, gipi_wpolbas b540
        WHERE    a.line_cd     =  b540.line_cd
          AND    a.iss_cd      =  b540.iss_cd
          AND    a.subline_cd  =  b540.subline_cd
          AND    a.issue_yy    =  b540.issue_yy
          AND    a.pol_seq_no  =  b540.pol_seq_no
          AND    a.renew_no    =  b540.renew_no
          AND    a.pol_flag    IN( '1','2','3','X')AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540.eff_date))
          AND    NVL(a.endt_expiry_date,a.expiry_date) >=  b540.eff_date
          AND    NVL(a.back_stat,5) = 2
          AND    EXISTS (SELECT '1'
                           FROM gipi_item b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id) 	 
          AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                    FROM gipi_polbasic c
                                   WHERE line_cd     =  b540.line_cd
                                     AND iss_cd      =  b540.iss_cd
                                     AND subline_cd  =  b540.subline_cd
                                     AND issue_yy    =  b540.issue_yy
                                     AND pol_seq_no  =  b540.pol_seq_no
                                     AND renew_no    =  b540.renew_no
                                     AND pol_flag  IN( '1','2','3','X')
                                     AND TRUNC(eff_date) <= DECODE(nvl(c.endt_seq_no,0),0,TRUNC(c.eff_date), TRUNC(b540.eff_date))
                                     AND NVL(endt_expiry_date,expiry_date) >=  b540.eff_date
                                     AND NVL(c.back_stat,5) = 2
                                     AND EXISTS (SELECT '1'
                                                   FROM gipi_item d
                                                  WHERE d.item_no = p_item_no
                                                    AND c.policy_id = d.policy_id))
		  AND	 b540.par_id = p_par_id 	                   
     ORDER BY   a.eff_date desc;
     
BEGIN
  p_message := 'SUCCESS';
  FOR b540 IN (SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no, eff_date
  	  	      FROM gipi_wpolbas
			 WHERE par_id = p_par_id)
  LOOP
	FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
		              FROM gipi_polbasic a
		             WHERE line_cd     =  b540.line_cd
		               AND iss_cd      =  b540.iss_cd
		               AND subline_cd  =  b540.subline_cd
		               AND issue_yy    =  b540.issue_yy
		               AND pol_seq_no  =  b540.pol_seq_no
		               AND renew_no    =  b540.renew_no
		               AND pol_flag  IN( '1','2','3','X')
		               AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540.eff_date))
		               AND NVL(endt_expiry_date,expiry_date) >=  b540.eff_date
		               AND EXISTS (SELECT '1'
		                             FROM gipi_item b
		                            WHERE b.item_no = p_item_no
		                              AND a.policy_id = b.policy_id)) LOOP
		      v_max_endt_seq_no := z.endt_seq_no;
		      EXIT;
		  END LOOP;                            	
		  FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
		              FROM gipi_polbasic a
		             WHERE line_cd     =  b540.line_cd
		               AND iss_cd      =  b540.iss_cd
		               AND subline_cd  =  b540.subline_cd
		               AND issue_yy    =  b540.issue_yy
		               AND pol_seq_no  =  b540.pol_seq_no
		               AND renew_no    =  b540.renew_no
		               AND pol_flag  IN( '1','2','3','X')
		               AND TRUNC(eff_date) <= TRUNC(b540.eff_date)
		               AND NVL(endt_expiry_date,expiry_date) >=  b540.eff_date
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
		               WHERE B.line_cd      =  b540.line_cd
		                 AND B.subline_cd   =  b540.subline_cd
		                 AND B.iss_cd       =  b540.iss_cd
		                 AND B.issue_yy     =  b540.issue_yy
		                 AND B.pol_seq_no   =  b540.pol_seq_no
		                 AND B.renew_no     =  b540.renew_no
		                 AND B.policy_id    =  A.policy_id
		                 AND B.pol_flag     in('1','2','3','X')
		                 AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
		                 AND A.item_no = p_item_no
		                 AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(b540.eff_date))
		                 AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(b540.eff_date)
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
		                   WHERE B.line_cd      =  b540.line_cd
		                     AND B.subline_cd   =  b540.subline_cd
		                     AND B.iss_cd       =  b540.iss_cd
		                     AND B.issue_yy     =  b540.issue_yy
		                     AND B.pol_seq_no   =  b540.pol_seq_no
		                     AND B.renew_no     =  b540.renew_no
		                     AND B.policy_id    =  A.policy_id
		                     AND B.pol_flag     in('1','2','3','X')                      
		                     AND A.item_no = p_item_no
		                     AND TRUNC(B.eff_date)    <=  TRUNC(b540.eff_date)
		                     AND NVL(B.endt_expiry_date,B.expiry_date) >= b540.eff_date
		                     AND NVL(b.endt_seq_no, 0) > 0  -- to query records from endt. only
		                ORDER BY B.eff_date DESC)
		     LOOP
		     	 v_ann_tsi  := endt.ann_tsi_amt;
		       v_ann_prem := endt.ann_prem_amt; 
		       amt_sw := 'Y';
		       EXIT;
		     END LOOP;
		     --no endt. records found, retrieved amounts from the policy
		     IF amt_sw = 'N' THEN
		     	  FOR POL IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
		                    FROM gipi_item a,
		                         gipi_polbasic b
		                   WHERE B.line_cd      =  b540.line_cd
		                     AND B.subline_cd   =  b540.subline_cd
		                     AND B.iss_cd       =  b540.iss_cd
		                     AND B.issue_yy     =  b540.issue_yy
		                     AND B.pol_seq_no   =  b540.pol_seq_no
		                     AND B.renew_no     =  b540.renew_no
		                     AND B.policy_id    =  A.policy_id
		                     AND B.pol_flag     in('1','2','3','X')                      
		                     AND A.item_no = p_item_no
		                     AND NVL(b.endt_seq_no, 0) = 0)
		        LOOP
		     	    v_ann_tsi  := pol.ann_tsi_amt;
		          v_ann_prem := pol.ann_prem_amt; 
		          EXIT;
		        END LOOP;
		     END IF;   
		  ELSE   
		     p_message := GIPIS060_EXTRACT_ANN_AMT2(p_par_id, p_item_no, v_ann_prem,  v_ann_tsi);
			 IF (p_message <> 'SUCCESS') THEN
			 	RETURN; --v_message;
			 END IF;
		  END IF;
		    
		  IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                             	
		     FOR E1 IN E LOOP
		       FOR B1 IN B(e1.policy_id) LOOP
		           INSERT INTO gipi_witem
		       	          (par_id,         item_no,        item_title,       rec_flag,
		       	           currency_cd,    currency_rt,    coverage_cd,      group_cd,
		       	           ann_tsi_amt,    ann_prem_amt)
		       	   VALUES (p_par_id,   p_item_no,         B1.item_title,    'C',
		       	           B1.currency_cd, B1.currency_rt, B1.coverage_cd,   B1.group_cd,
		       	           v_ann_tsi,      v_ann_prem);       	           
		       END LOOP;
		       --forms_ddl('commit');
		       FOR D1 IN D(E1.policy_id) LOOP
		         INSERT INTO gipi_wvehicle
		                (par_id,       item_no,         subline_cd,          motor_no,
		                 plate_no,     serial_no,       coc_type,            coc_yy,
		                 /* added codes below 
		                 ** gmi 04/27/07 */
		                 mot_type,     unladen_wt,      subline_type_cd,     motor_coverage
		                 /*,    assignee*/, ctv_tag)
		          VALUES(p_par_id, p_item_no,          d1.subline_cd,       d1.motor_no,
		                 d1.plate_no,  d1.serial_no,    d1.coc_type,         d1.coc_yy,
		                 /* added codes below 
		                 ** gmi 04/27/07 */
		                 d1.mot_type,  d1.unladen_wt,   d1.subline_type_cd,  d1.motor_coverage 
		                 /*, d1.assignee*/, d1.ctv_tag);                 
		       END LOOP;       
		       --forms_ddl('commit');
		       EXIT;
		     END LOOP;
		  ELSE   
		     FOR A1 IN A LOOP
		       FOR B1 IN B(A1.policy_id) LOOP
		       	   INSERT INTO gipi_witem
		       	          (par_id,         item_no,        item_title,       rec_flag,
		       	           currency_cd,    currency_rt,    coverage_cd,      group_cd,
		       	           ann_tsi_amt,    ann_prem_amt)
		       	   VALUES (p_par_id,   p_item_no,         B1.item_title,    'C',
		       	           B1.currency_cd, B1.currency_rt, B1.coverage_cd,   B1.group_cd,
		       	           v_ann_tsi,      v_ann_prem);       	   
		       END LOOP;
		       --forms_ddl('commit');
		       FOR D1 IN D(A1.policy_id) LOOP
		         INSERT INTO gipi_wvehicle
		                (par_id,       item_no,         subline_cd,          motor_no,
		                 plate_no,     serial_no,       coc_type,            coc_yy,
		                 /* added codes below 
		                 ** gmi 04/27/07 */
		                 mot_type,     unladen_wt,      subline_type_cd,     motor_coverage
		                 /*,    assignee*/, ctv_tag)
		          VALUES(p_par_id, p_item_no,          d1.subline_cd,       d1.motor_no,
		                 d1.plate_no,  d1.serial_no,    d1.coc_type,         d1.coc_yy,
		                 /* added codes below 
		                 ** gmi 04/27/07 */
		                 d1.mot_type,  d1.unladen_wt,   d1.subline_type_cd,  d1.motor_coverage
		                 /*, d1.assignee*/, d1.ctv_tag);          
		       END LOOP;
		       --forms_ddl('commit');
		       EXIT;
		     END LOOP;
		  END IF;
  END LOOP;
END;
/


