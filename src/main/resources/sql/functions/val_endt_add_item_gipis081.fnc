DROP FUNCTION CPI.VAL_ENDT_ADD_ITEM_GIPIS081;

CREATE OR REPLACE FUNCTION CPI.VAL_ENDT_ADD_ITEM_GIPIS081(
	   	  		  		       p_par_id			 	  GIPI_WITEM.par_id%TYPE,
							   p_item_no			  GIPI_WITEM.item_no%TYPE,
							   p_line_cd			  GIPI_WPOLBAS.line_cd%TYPE,
							   p_subline_cd			  GIPI_WPOLBAS.subline_cd%TYPE,
							   p_iss_cd				  GIPI_WPOLBAS.iss_cd%TYPE,
							   p_issue_yy			  GIPI_WPOLBAS.issue_yy%TYPE,
							   p_pol_seq_no			  GIPI_WPOLBAS.pol_seq_no%TYPE,
							   p_renew_no			  GIPI_WPOLBAS.renew_no%TYPE,
							   p_eff_date			  GIPI_WPOLBAS.eff_date%TYPE) 
  RETURN VARCHAR2 IS
	  v_msg VARCHAR2(200) := 'SUCCESS';
	  v_new_item           VARCHAR2(1) := 'Y';
	  expired_sw           VARCHAR2(1) := 'N';
	  amt_sw               VARCHAR2(1) := 'N';
	  v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE; 
	  v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE; 
	  v_ann_tsi            gipi_witem.ann_tsi_amt%TYPE;    
	  v_ann_prem           gipi_witem.ann_prem_amt%TYPE;
	  CURSOR A IS
       SELECT    a.policy_id
         FROM    gipi_polbasic a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          AND    a.pol_flag    IN( '1','2','3','X')
          --ASI 081299 add this validation so that data that will be retrieved
          --           is only those from endorsement prior to the current endorsement
          --           this was consider because of the backward endorsement
          AND    TRUNC(a.eff_date)  <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
          AND    TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  TRUNC(p_eff_date)
          AND    EXISTS (SELECT '1'
                           FROM gipi_item b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id) 	 
     ORDER BY   eff_date DESC;
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
       SELECT item_no,district_no,eq_zone,tarf_cd,block_no,block_id,fr_item_type
	       ,loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd
	       ,construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks
	       ,flood_zone
         FROM gipi_fireitem
        WHERE policy_id = p_policy_id
          AND item_no = p_item_no;
   
     CURSOR E IS
       SELECT    a.policy_id
         FROM    gipi_polbasic a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          AND    a.pol_flag    IN( '1','2','3','X')
          AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
          AND    NVL(a.endt_expiry_date,a.expiry_date) >=  p_eff_date
          AND    NVL(a.back_stat,5) = 2
          AND    EXISTS (SELECT '1'
                           FROM gipi_item b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id) 	 
          AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                    FROM gipi_polbasic c
                                   WHERE line_cd     =  p_line_cd
                                     AND iss_cd      =  p_iss_cd
                                     AND subline_cd  =  p_subline_cd
                                     AND issue_yy    =  p_issue_yy
                                     AND pol_seq_no  =  p_pol_seq_no
                                     AND renew_no    =  p_renew_no
                                     AND pol_flag  IN( '1','2','3','X')
                                     AND TRUNC(eff_date) <= DECODE(nvl(c.endt_seq_no,0),0,TRUNC(c.eff_date), TRUNC(p_eff_date))
                                     AND NVL(endt_expiry_date,expiry_date) >=  p_eff_date
                                     AND NVL(c.back_stat,5) = 2
                                     AND EXISTS (SELECT '1'
                                                   FROM gipi_item d
                                                  WHERE d.item_no = p_item_no
                                                    AND c.policy_id = d.policy_id)) 	                   
     ORDER BY   eff_date desc;
BEGIN
  FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
              FROM gipi_polbasic a
             WHERE line_cd     =  p_line_cd
               AND iss_cd      =  p_iss_cd
               AND subline_cd  =  p_subline_cd
               AND issue_yy    =  p_issue_yy
               AND pol_seq_no  =  p_pol_seq_no
               AND renew_no    =  p_renew_no
               AND pol_flag  IN( '1','2','3','X')
               AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
               AND NVL(endt_expiry_date,expiry_date) >=  p_eff_date
               AND EXISTS (SELECT '1'
                             FROM gipi_item b
                            WHERE b.item_no = p_item_no
                              AND a.policy_id = b.policy_id)) LOOP
      v_max_endt_seq_no := z.endt_seq_no;
      EXIT;
  END LOOP;                            	
  FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
              FROM gipi_polbasic a
             WHERE line_cd     =  p_line_cd
               AND iss_cd      =  p_iss_cd
               AND subline_cd  =  p_subline_cd
               AND issue_yy    =  p_issue_yy
               AND pol_seq_no  =  p_pol_seq_no
               AND renew_no    =  p_renew_no
               AND pol_flag  IN( '1','2','3','X')
               AND TRUNC(eff_date) <= TRUNC(p_eff_date)
               AND NVL(endt_expiry_date,expiry_date) >=  p_eff_date
               AND NVL(a.back_stat,5) = 2
               AND EXISTS (SELECT '1'
                             FROM gipi_item b
                            WHERE b.item_no = p_item_no
                              AND a.policy_id = b.policy_id)) LOOP
      v_max_endt_seq_no1 := x.endt_seq_no;
      EXIT;
  END LOOP;                            	
    expired_sw := 'N';
  FOR SW IN ( SELECT '1'
                FROM GIPI_ITMPERIL A,
                     GIPI_POLBASIC B
               WHERE B.line_cd      =  p_line_cd
                 AND B.subline_cd   =  p_subline_cd
                 AND B.iss_cd       =  p_iss_cd
                 AND B.issue_yy     =  p_issue_yy
                 AND B.pol_seq_no   =  p_pol_seq_no
                 AND B.renew_no     =  p_renew_no
                 AND B.policy_id    =  A.policy_id
                 AND B.pol_flag     in('1','2','3','X')
                 AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
                 AND A.item_no = p_item_no
                 AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                 AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(p_eff_date)
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
                   WHERE B.line_cd      =  p_line_cd
	                 AND B.subline_cd   =  p_subline_cd
	                 AND B.iss_cd       =  p_iss_cd
	                 AND B.issue_yy     =  p_issue_yy
	                 AND B.pol_seq_no   =  p_pol_seq_no
	                 AND B.renew_no     =  p_renew_no
                     AND B.policy_id    =  A.policy_id
                     AND B.pol_flag     in('1','2','3','X')                      
                     AND A.item_no = p_item_no
                     AND TRUNC(B.eff_date)    <=  TRUNC(p_eff_date)
                     AND NVL(B.endt_expiry_date,B.expiry_date) >= p_eff_date
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
                   WHERE B.line_cd      =  p_line_cd
	                 AND B.subline_cd   =  p_subline_cd
	                 AND B.iss_cd       =  p_iss_cd
	                 AND B.issue_yy     =  p_issue_yy
	                 AND B.pol_seq_no   =  p_pol_seq_no
	                 AND B.renew_no     =  p_renew_no
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
     v_msg := GIPIS060_EXTRACT_ANN_AMT2(p_par_id, p_item_no, v_ann_prem,  v_ann_tsi);
  END IF;
  RETURN v_msg;
END VAL_ENDT_ADD_ITEM_GIPIS081;
/


