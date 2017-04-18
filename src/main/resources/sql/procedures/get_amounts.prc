DROP PROCEDURE CPI.GET_AMOUNTS;

CREATE OR REPLACE PROCEDURE CPI.GET_AMOUNTS (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
	p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
	p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
	p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
	p_renew_no IN gipi_wpolbas.renew_no%TYPE,
	p_eff_date IN gipi_wpolbas.eff_date%TYPE,
	p_ann_tsi_amt OUT gipi_wpolbas.ann_tsi_amt%TYPE,
	p_ann_prem_amt OUT gipi_wpolbas.ann_prem_amt%TYPE,
	p_msg_alert OUT VARCHAR2)
AS
	/*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : For events that will delete existing records amounts must be reset and 
    **                     : latest annualized amounts must be retrieved from the LATEST ENDT,
    **                     : for policy without endt yet latest annualized amount will be the amounts of 
    **                     : POLICY RECORD. For cases with short-term endt. annualized amount should be recomputed
    **                     : by adding up all policy/endt that is not yet expired
    */
    v_prorate        gipi_itmperil.prem_rt%TYPE := 0;   
    v_amt_sw        VARCHAR2(1);                           -- switch that will determine if amount is already         
    v_comp_prem        gipi_polbasic.prem_amt%TYPE  := 0;    -- variable that will store computed prem
    v_expired_sw    VARCHAR2(1);                           -- switch that is used to determine if policy have short term endt.
    -- fields that will be use in storing computed amounts when computing for the amount
    -- of records with short term endorsement    
    v_ann_tsi2        gipi_polbasic.ann_tsi_amt%TYPE :=0; 
    v_ann_prem2        gipi_polbasic.ann_prem_amt%TYPE :=0;
    --determines if a particular peril is an allied or basic peril
    --used in populating amounts on gipi_witem.
    
    --temp
    v_prem_amt                gipi_wpolbas.prem_amt%TYPE;
    v_tsi_amt                 gipi_wpolbas.tsi_amt%TYPE;    
    v_success                 BOOLEAN := FALSE;
    v_end_of_transaction      BOOLEAN := FALSE;
	v_expiry_date			  gipi_polbasic.expiry_date%TYPE;
BEGIN
	v_expiry_date := extract_expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no); -- marco 09.05.2012
    v_prem_amt := 0;
    v_tsi_amt := 0;
    
    --to reset amounts on gipi_witem
    --reset amounts of additional items
    UPDATE gipi_witem
       SET tsi_amt = NULL,
           prem_amt = NULL,
           ann_tsi_amt = NULL,
           ann_prem_amt = NULL
     WHERE par_id = p_par_id
       AND rec_flag = 'A';
       
    --check first for the existance of short term endt. 
    v_expired_sw := 'N';
    
    FOR SW IN(
        SELECT '1'
          FROM gipi_itmperil A,
               gipi_polbasic B
         WHERE B.line_cd =  p_line_cd
           AND B.subline_cd =  p_subline_cd
           AND B.iss_cd =  p_iss_cd
           AND B.issue_yy =  p_issue_yy
           AND B.pol_seq_no =  p_pol_seq_no
           AND B.renew_no =  p_renew_no
           AND B.policy_id =  A.policy_id
           AND B.pol_flag IN ('1','2','3')
           AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
           AND TRUNC(b.eff_date) <= TRUNC(p_eff_date)
           AND TRUNC(NVL(b.endt_expiry_date, b.expiry_date)) <TRUNC(p_eff_date)
      ORDER BY B.eff_date DESC)
    LOOP
        v_expired_sw := 'Y';
        EXIT;
    END LOOP;
    
    --for policy with no expired_sw
    IF v_expired_sw = 'N' THEN
        --get the amount from the latest endt
        v_amt_sw := 'N';
        FOR AMT IN (SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                   FROM gipi_polbasic b250
                  WHERE b250.line_cd = p_line_cd
                    AND b250.subline_cd = p_subline_cd
                    AND b250.iss_cd = p_iss_cd
                    AND b250.issue_yy = p_issue_yy
                    AND b250.pol_seq_no = p_pol_seq_no
                    AND b250.renew_no = p_renew_no
                    AND b250.pol_flag IN ('1','2','3') 
                    AND NVL(b250.endt_seq_no, 0) > 0
                    AND b250.eff_date  <= NVL(p_eff_date,SYSDATE)
               ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
        LOOP
            p_ann_tsi_amt := amt.ann_tsi_amt; 
            p_ann_prem_amt := amt.ann_prem_amt; 
            v_amt_sw := 'Y';
            EXIT;
        END LOOP;
        
        --for policy without endt., get amounts from policy
        IF v_amt_sw = 'N' THEN
            FOR AMT IN (
                SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                  FROM gipi_polbasic b250
                 WHERE b250.line_cd = p_line_cd
                   AND b250.subline_cd = p_subline_cd
                   AND b250.iss_cd = p_iss_cd
                   AND b250.issue_yy = p_issue_yy
                   AND b250.pol_seq_no = p_pol_seq_no
                   AND b250.renew_no = p_renew_no
                   AND b250.pol_flag IN ('1','2','3') 
                   AND NVL(b250.endt_seq_no, 0) = 0)
            LOOP
                p_ann_tsi_amt := amt.ann_tsi_amt; 
                p_ann_prem_amt := amt.ann_prem_amt;           
                EXIT;
            END LOOP;
        END IF;
        
        --to reset amounts on gipi_witem (for items existing from prev. endt or policy record).
        FOR par_item IN (
            SELECT item_no
              FROM gipi_witem
             WHERE par_id = p_par_id
               AND rec_flag <> 'A')
        LOOP
            FOR item_amt IN (
                SELECT b.ann_tsi_amt, b.ann_prem_amt
                  FROM gipi_polbasic b250,
                       gipi_item     b
                 WHERE b250.line_cd = p_line_cd
                   AND b250.subline_cd = p_subline_cd
                   AND b250.iss_cd = p_iss_cd
                   AND b250.issue_yy = p_issue_yy
                   AND b250.pol_seq_no = p_pol_seq_no
                   AND b250.renew_no = p_renew_no
                   AND b250.pol_flag IN ('1','2','3') 
                   AND b250.eff_date <= NVL(p_eff_date,SYSDATE)
                   AND b250.policy_id  = b.policy_id
                   AND b.item_no = par_item.item_no
             ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
            LOOP
                UPDATE gipi_witem
                   SET tsi_amt = NULL,
                       prem_amt = NULL,
                       ann_tsi_amt = item_amt.ann_tsi_amt,
                       ann_prem_amt = item_amt.ann_prem_amt
                 WHERE par_id  = p_par_id
                   AND item_no = par_item.item_no;
                EXIT;
            END LOOP;           
        END LOOP;           
    ELSE     
        --for policy with short term endt. amounts should be recomputed by adding up 
        --all policy and endt. that is not yet expired.
        FOR A2 IN(
            SELECT (C.tsi_amt * A.currency_rt) tsi,
                   (C.prem_amt * a.currency_rt) prem,       
                   B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                   NVL(B.prorate_flag,'2') prorate_flag,      NVL(B.comp_sw,'N') comp_sw, --benjo 01.18.2016 AFPGEN-SR-20044 added nvl in prorate_flag
                   B.short_rt_percent   short_rt,
                   C.peril_cd, b.incept_date
              FROM gipi_item     A,
                   gipi_polbasic B,  
                   gipi_itmperil C
             WHERE B.line_cd =  p_line_cd
               AND B.subline_cd =  p_subline_cd
               AND B.iss_cd =  p_iss_cd
               AND B.issue_yy =  p_issue_yy
               AND B.pol_seq_no =  p_pol_seq_no
               AND B.renew_no =  p_renew_no
               AND B.policy_id =  A.policy_id
               AND B.policy_id =  C.policy_id
               AND A.item_no =  C.item_no
               AND B.pol_flag IN ('1','2','3') 
               AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
               --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(p_eff_date)) -- marco 09.05.2012
			   AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
			   		v_expiry_date, b.endt_expiry_date,TRUNC(b.endt_expiry_date))) >= TRUNC(p_eff_date))

        LOOP
            v_comp_prem := 0;
            IF A2.prorate_flag = 1 THEN
                IF A2.endt_expiry_date <= A2.eff_date THEN
                    p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
                    RAISE_APPLICATION_ERROR(-20001, 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.');
                    --GOTO RAISE_FORM_TRIGGER_FAILURE;
                ELSE              
                    IF A2.comp_sw = 'Y' THEN
                        v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                                        check_duration(A2.incept_date, A2.expiry_date);
                                        --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                    ELSIF A2.comp_sw = 'M' THEN
                        v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                                        check_duration(A2.incept_date, A2.expiry_date);
                                        --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                    ELSE 
                        v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                                        check_duration(A2.incept_date, A2.expiry_date);
                                        --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                    END IF;
                END IF;
                v_comp_prem  := A2.prem/v_prorate;
            ELSIF A2.prorate_flag = 2 THEN
                v_comp_prem  :=  A2.prem;
            ELSE
                v_comp_prem :=  A2.prem/(A2.short_rt/100);  
            END IF;
            --accumulate premium for ann_prem_amt
            v_ann_prem2 := v_ann_prem2 + v_comp_prem;
            FOR TYPE IN (
                SELECT peril_type
                  FROM giis_peril
                 WHERE line_cd  = p_line_cd
                   AND peril_cd = A2.peril_cd)
            LOOP
                IF TYPE.peril_type = 'B' THEN
                    v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
                END IF;
            END LOOP;        
        END LOOP;
        
        p_ann_tsi_amt  := v_ann_tsi2;
        p_ann_prem_amt := v_ann_prem2;
     
        --reset variables before computing
        v_comp_prem := 0;
        v_ann_tsi2  := 0;
        v_ann_prem2 := 0;
        FOR par_item IN (
            SELECT item_no
              FROM gipi_witem
             WHERE par_id = p_par_id
               AND rec_flag <> 'A')
        LOOP
            v_ann_tsi2  := 0;
            v_ann_prem2 := 0;
            FOR A2 IN (
                SELECT (C.tsi_amt * A.currency_rt) tsi,
                       (C.prem_amt * a.currency_rt) prem,       
                       B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                       B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                       B.short_rt_percent   short_rt,
                       C.peril_cd, b.incept_date
                  FROM gipi_item     A,
                       gipi_polbasic B,  
                       gipi_itmperil C
                 WHERE B.line_cd =  p_line_cd
                   AND B.subline_cd =  p_subline_cd
                   AND B.iss_cd =  p_iss_cd
                   AND B.issue_yy =  p_issue_yy
                   AND B.pol_seq_no =  p_pol_seq_no
                   AND B.renew_no =  p_renew_no
                   AND B.policy_id =  A.policy_id
                   AND B.policy_id =  C.policy_id
                   AND A.item_no =  C.item_no
                   AND a.item_no =  par_item.item_no
                   AND B.pol_flag IN ('1','2','3') 
                   AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                   --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(p_eff_date)) -- marco 09.05.2012
				   AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
			   		v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= TRUNC(p_eff_date)) 
            LOOP
                v_comp_prem := 0;
                IF A2.prorate_flag = 1 THEN
                    IF A2.endt_expiry_date <= A2.eff_date THEN
                        p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
                        RAISE_APPLICATION_ERROR(-20001, 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.');
                        --GOTO RAISE_FORM_TRIGGER_FAILURE;
                    ELSE                
                        IF A2.comp_sw = 'Y' THEN
                            v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                                            check_duration(A2.incept_date, A2.expiry_date);
                                            --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                        ELSIF A2.comp_sw = 'M' THEN
                            v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                                            check_duration(A2.incept_date, A2.expiry_date);
                                            --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                        ELSE 
                            v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                                            check_duration(A2.incept_date, A2.expiry_date);
                                            --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
                        END IF;
                    END IF;
                    v_comp_prem  := A2.prem/v_prorate;
                ELSIF A2.prorate_flag = 2 THEN
                    v_comp_prem  :=  A2.prem;
                ELSE
                    v_comp_prem :=  A2.prem/(A2.short_rt/100);  
                END IF;
                --accumulate premium for ann_prem_amt
                v_ann_prem2 := v_ann_prem2 + v_comp_prem;
                FOR TYPE IN (
                    SELECT peril_type
                      FROM giis_peril
                     WHERE line_cd  = p_line_cd
                       AND peril_cd = A2.peril_cd)
                LOOP
                    IF TYPE.peril_type = 'B' THEN
                        v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
                    END IF;
                END LOOP;   
            END LOOP; --end of A2 FOR-LOOP (per item-peril)
       
            UPDATE gipi_witem
               SET tsi_amt = NULL,
                   prem_amt = NULL,
                   ann_prem_amt = v_ann_prem2,
                   ann_tsi_amt  = v_ann_tsi2
             WHERE par_id = p_par_id
               AND item_no = par_item.item_no;
        END LOOP; --end of par_item FOR-LOOP
    END IF;
    
    v_end_of_transaction := TRUE;
    <<RAISE_FORM_TRIGGER_FAILURE>>
    IF v_end_of_transaction THEN
        v_success := TRUE;
    END IF;
    
END GET_AMOUNTS;
/


