DROP PROCEDURE CPI.COPY_POL_WPOLBAS_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpolbas_2(
    p_new_policy_id     OUT     NUMBER,
    p_msg               OUT     VARCHAR2,
    p_message_box    IN OUT     VARCHAR2,
    p_old_pol_id         IN     NUMBER,
    p_policy_id         OUT     NUMBER,
    p_proc_expiry_date   IN     DATE,
    p_proc_incept_date   IN     DATE,
    p_proc_assd_no       IN     NUMBER,
    p_pack_sw           OUT     VARCHAR2,
    p_proc_same_polno_sw IN     VARCHAR2,
    p_new_par_id        OUT     NUMBER,
    p_new_pack_par_id    IN     NUMBER,
    p_new_pack_policy_id IN     NUMBER,
    p_proc_renew_flag    IN     NUMBER,
    p_user               IN     VARCHAR2,
    p_is_subpolicy       IN     VARCHAR2
)
IS
  --rg_id                      RECORDGROUP;
  rg_name                    VARCHAR2(30) := 'GROUP_POLICY';
  rg_count                   NUMBER;
  rg_count2                  NUMBER;
  rg_col                     VARCHAR2(50) := rg_name || '.policy_id';
  rg_col2                    VARCHAR2(50) := rg_name || '.endt_seq_no';
  rg_col3                    VARCHAR2(50) := rg_name || '.pol_flag';
  rg_policy_id               gipi_polbasic.policy_id%TYPE;
  rg_endt_id                 gipi_polbasic.policy_id%TYPE;
  rg_pol_flag                gipi_wpolbas.pol_flag%TYPE;
  rg_endt_seq_no             gipi_wpolbas.endt_seq_no%TYPE;
  v_line_cd1                 gipi_wpolbas.line_cd%TYPE;
  v_iss_cd1                  gipi_wpolbas.iss_cd%TYPE;
  v_eff_date                 gipi_wpolbas.eff_date%TYPE;
  v_incept_date              gipi_wpolbas.incept_date%TYPE;
  v_expiry_date              gipi_wpolbas.expiry_date%TYPE;
  v_assd_no                  gipi_wpolbas.assd_no%TYPE;
  v_subline_cd               gipi_wpolbas.subline_cd%TYPE;
  v_seq                      NUMBER; 
  v_line                     gipi_wpolbas.line_cd%TYPE;
  v_iss_cd                   gipi_wpolbas.iss_cd%TYPE;
  v_start_date               gipi_wpolbas.incept_date%TYPE;
  v_par_yy                   gipi_wpolbas.issue_yy%TYPE;   
  v_issue_yy1                gipi_polbasic.issue_yy%TYPE;   
  v_pol_seq_no               gipi_wpolbas.pol_seq_no%TYPE;
  v_renew_no                 gipi_wpolbas.renew_no%TYPE;
  v_address1                 gipi_wpolbas.address1%TYPE;
  v_address2                 gipi_wpolbas.address2%TYPE;
  v_address3                 gipi_wpolbas.address3%TYPE;
  v_cred_branch                           gipi_wpolbas.cred_branch%TYPE;
  v_region_cd                gipi_wpolbas.region_cd%TYPE;
  v_industry_cd              gipi_wpolbas.industry_cd%TYPE;
  v_risk_tag                 gipi_wpolbas.risk_tag%TYPE;
  var_vdate                  NUMBER;
  var_idate                  DATE;
  v_issue_date               DATE  := SYSDATE;
  v_booking_mth              gipi_wpolbas.booking_mth%TYPE;
  v_booking_year             gipi_wpolbas.booking_year%TYPE;
  v_book_flag                VARCHAR2(1) := 'N';              
  v_same_polno_sw            gipi_wpolbas.same_polno_sw%TYPE;
  
  v_ACCT_OF_CD               gipi_wpolbas.ACCT_OF_CD%TYPE; 
  v_ACCT_OF_CD_SW            gipi_wpolbas.ACCT_OF_CD_SW%TYPE;
  v_LABEL_TAG                                 gipi_wpolbas.LABEL_TAG%TYPE;
  
  --BETH 04-16-2001
  v_actual_renew_no     gipi_polbasic.actual_renew_no%TYPE;
  v_count_id            gipi_polbasic.policy_id%TYPE; --store policy_id of renewed policy
  v_exit_sw             VARCHAR2(1); --switch that will be use in counting actual_renew_n
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wpolbas program unit 
  */
  BEGIN
    SELECT polbasic_policy_id_s.NEXTVAL
      INTO p_new_policy_id 
      FROM DUAL;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
     --CLEAR_MESSAGE;
     p_msg := 'Cannot generate new POLICY ID.';
     --SYNCHRONIZE; 
  END;
  FOR pol IN 
    ( SELECT line_cd,         subline_cd,   iss_cd,          issue_yy,      pol_seq_no,                     
             assd_no,         type_cd,      acct_of_cd,      designation ,  mortg_name,
             address1,        address2,     address3,        pool_pol_no,   subline_type_cd,
             auto_renew_flag, renew_flag,   pack_pol_flag,   prov_prem_tag, expiry_tag,
             foreign_acc_sw,  invoice_sw,   ref_pol_no,      prem_warr_tag, co_insurance_sw,
             reg_policy_sw,   incept_tag,   fleet_print_tag, prorate_flag,
             endt_expiry_tag, incept_date,  renew_no,        no_of_items,   short_rt_percent,
             discount_sw,     comp_sw,      tsi_amt,         prem_amt,      prov_prem_pct,   endt_iss_cd, 
             manual_renew_no, ann_prem_amt, ann_tsi_amt,     place_cd,      with_tariff_sw,
             actual_renew_no, cred_branch,  region_cd,       industry_cd,   risk_tag,
             ACCT_OF_CD_SW, LABEL_TAG
        FROM gipi_polbasic
       WHERE policy_id = p_old_pol_id)
  LOOP 
    v_line_cd1           :=    pol.line_cd;
    v_iss_cd1            :=    pol.iss_cd;
    p_policy_id          :=    p_old_pol_id;
    v_subline_cd         :=    pol.subline_cd;
    v_eff_date           :=    p_proc_expiry_date;
    v_incept_date        :=    p_proc_expiry_date;        
    v_start_date         :=    p_proc_incept_date;
    v_assd_no            :=    p_proc_assd_no;            
    p_pack_sw            :=    NVL(pol.pack_pol_flag,'N');
    v_par_yy             :=    TO_NUMBER(SUBSTR(TO_CHAR(v_eff_date,'MM-DD-YYYY'),9,2));
    v_address1           :=    pol.address1;
    v_address1           :=    pol.address1;
    v_address1           :=    pol.address1;
    v_cred_branch        :=    pol.cred_branch;
    v_region_cd          :=    pol.region_cd;
    v_industry_cd        :=    pol.industry_cd;
    v_risk_tag               :=    pol.risk_tag;
    /*v_ACCT_OF_CD         :=    pol.ACCT_OF_CD; 
    v_ACCT_OF_CD_SW      :=    pol.ACCT_OF_CD_SW;
    v_LABEL_TAG          :=    pol.LABEL_TAG;*/
    --v_renew_no           :=    NVL(pol.renew_no,0) + 1 + NVL(pol.manual_renew_no,0);
    IF NVL(p_proc_same_polno_sw,'N') = 'Y' THEN
       v_same_polno_sw   := 'Y';             
       v_pol_seq_no      :=  pol.pol_seq_no;           
       v_issue_yy1       :=  pol.issue_yy ;
	ELSE
       v_same_polno_sw   := 'N';                --nieko 07212016 SR 22730, KB 3722, from Y to N        
       v_issue_yy1       :=  v_par_yy;   
         BEGIN
             SELECT MAX(NVL(pol_seq_no,0)) + 1 pol_seq_no
               INTO v_pol_seq_no
                   FROM giis_pol_seq
                  WHERE line_cd    = v_line_cd1
                    AND iss_cd     = v_iss_cd1
                    AND issue_yy   = v_issue_yy1
                    AND subline_cd = v_subline_cd;
         EXCEPTION 
             WHEN no_data_found THEN
                 v_pol_seq_no := 0;
                 --INSERT INTO giis_pol_seq (LINE_CD, SUBLINE_CD, ISS_CD, ISSUE_YY, POL_SEQ_NO, RENEW_NO)
                 --                  VALUES (v_line_cd1, v_subline_cd, v_iss_cd1, v_issue_yy1, v_pol_seq_no, 0);
         END;
		 -- marco - 08.23.2012 - to prevent sql exception when inserting null value
		 IF v_pol_seq_no IS NULL THEN
		 	v_pol_seq_no := 1;
			INSERT INTO giis_pol_seq (LINE_CD, SUBLINE_CD, ISS_CD, ISSUE_YY, POL_SEQ_NO, RENEW_NO)
                   VALUES (v_line_cd1, v_subline_cd, v_iss_cd1, v_issue_yy1, v_pol_seq_no, 0);
	     END IF;
    END IF;
    
    --BETH 04162001
    --     get max renew_no for the policy to be renewed 
    --     so that error for unique constraints will be eliminated 
    FOR  MAX_REN IN (SELECT renew_no, 
                            DECODE(policy_id, p_old_pol_id, manual_renew_no, 0) manual_renew_no
                       FROM gipi_polbasic
                      WHERE line_cd    = pol.line_cd       
                        AND subline_cd = pol.subline_cd
                        AND iss_cd     = pol.iss_cd
                        AND issue_yy   = pol.issue_yy
                        AND pol_seq_no = pol.pol_seq_no--v_pol_seq_no--pol.pol_seq_no --vin 9.22.2010 returned to pol.pol_seq_no to remove error ora-1407
                   ORDER BY renew_no desc)
    LOOP                    
      --if old policy has an existing manual_renew_no the renew no of the 
      --new policy will be the manual_renew_no + 1 else the renew_no is the 
      --old renew_no + 1
      IF NVL(max_ren.manual_renew_no,0) > 0 THEN
         v_renew_no   := nvl(max_ren.manual_renew_no,0) + 1;
      ELSE      
         v_renew_no   := nvl(max_ren.renew_no,0) + 1;
      END IF;   
      EXIT;
    END LOOP;    
    IF NVL(p_proc_same_polno_sw,'N') = 'N' THEN
        UPDATE giis_pol_seq
           SET pol_seq_no = v_pol_seq_no,
               renew_no   = v_renew_no
         WHERE line_cd    = v_line_cd1
           AND subline_cd = v_subline_cd
           AND iss_cd     = v_iss_cd1
           AND issue_yy   = v_issue_yy1;
      END IF;    
    
    --BETH 04162001 for renewal populate field actual_renew_no if actual_renew_no
    --     is already existing in policy being renewd just accumulate it by 1 but if it is not yet 
    --     existing retrieved it by counting no. of renewals for the policy in gipi_polnrep for policy
    --     that is not spoiled                 
   IF NVL(pol.actual_renew_no,0) > 0 THEN
         v_actual_renew_no := pol.actual_renew_no + 1;                    
   ELSE
         --if actual_renew_no of the policy being renew is null then
      --actual_renew_no would be 1 + manual_renew_no    
      v_actual_renew_no := NVL(pol.manual_renew_no,0) +1;
      v_count_id := p_old_pol_id;
      v_exit_sw := 'Y';
      --check history of renewal of policy and for every renewal that is 
      --not spoiled add 1 to actual_renew_no
      WHILE v_exit_sw = 'Y'
      LOOP
        v_exit_sw := 'N';   
        FOR A IN (SELECT b610.old_policy_id, 
                         b250a.manual_renew_no
                    FROM gipi_polbasic b250, gipi_polbasic b250a,
                         gipi_polnrep b610
                   WHERE b250.policy_id = b610.new_policy_id
                     AND b250a.policy_id = b610.old_policy_id
                     AND b250.pol_flag NOT IN( '4','5')
                     AND b610.new_policy_id = v_count_id)
        LOOP
             v_actual_renew_no := v_actual_renew_no + NVL(a.manual_renew_no,0) + 1;
             v_count_id := a.old_policy_id;              
             v_exit_sw := 'Y'; 
             EXIT;
        END LOOP;
        IF v_exit_sw = 'N' THEN
              EXIT;
        END IF;
      END LOOP;                  
    END IF;
    -- added by mgc to get the correct address if policy has backward endt
    -- from here
    -- get the last endorsement sequence of the latest backward endt
    FOR Z IN (SELECT address1, address2, address3, eff_date
                FROM gipi_polbasic b2501
               WHERE b2501.line_cd    = pol.line_cd
                 AND b2501.subline_cd = pol.subline_cd
                 AND b2501.iss_cd     = pol.iss_cd
                 AND b2501.issue_yy   = pol.issue_yy
                 AND b2501.pol_seq_no = pol.pol_seq_no
                 AND b2501.renew_no   = pol.renew_no
                 AND NVL(b2501.spld_flag,'1') <> '2'
                 AND b2501.pol_flag   IN ('1','2','3')
                 AND (address1 IS NOT NULL
                  OR address2 IS NOT NULL
                  OR address3 IS NOT NULL)
               ORDER BY eff_date DESC ) LOOP
           v_address1  := Z.address1;
           v_address2  := Z.address2;
           v_address3  := Z.address3;
           FOR Z1 IN (SELECT endt_seq_no, address1, address2, address3
                         FROM gipi_polbasic b2501
                        WHERE b2501.line_cd    = pol.line_cd
                          AND b2501.subline_cd = pol.subline_cd
                          AND b2501.iss_cd     = pol.iss_cd
                          AND b2501.issue_yy   = pol.issue_yy
                          AND b2501.pol_seq_no = pol.pol_seq_no
                          AND b2501.renew_no   = pol.renew_no
                          AND b2501.pol_flag   IN ('1','2','3')
                          AND nvl(b2501.back_stat,5) = 2
                          AND (address1 IS NOT NULL
                           OR address2 IS NOT NULL
                           OR address3 IS NOT NULL)
                        ORDER BY endt_seq_no DESC) 
           LOOP
               -- get the last endorsement sequence of the policy
               FOR Z1A IN (SELECT endt_seq_no, eff_date, address1, address2, address3
                             FROM gipi_polbasic b2501
                            WHERE b2501.line_cd    = pol.line_cd
                              AND b2501.subline_cd = pol.subline_cd
                              AND b2501.iss_cd     = pol.iss_cd
                              AND b2501.issue_yy   = pol.issue_yy
                              AND b2501.pol_seq_no = pol.pol_seq_no
                              AND b2501.renew_no   = pol.renew_no
                              AND b2501.pol_flag   IN ('1','2','3')
                              AND (address1 IS NOT NULL
                               OR address2 IS NOT NULL
                               OR address3 IS NOT NULL)
                            ORDER BY endt_seq_no DESC) 
               LOOP
                  IF Z1.endt_seq_no = Z1a.endt_seq_no THEN
                     v_address1  := Z1.address1;
                     v_address2  := Z1.address2;
                     v_address3  := Z1.address3;
                  ELSE
                      IF Z1A.eff_date > Z.eff_date THEN
                         v_address1  := Z1A.address1;
                         v_address2  := Z1A.address2;
                         v_address3  := Z1A.address3;
                     ELSE
                         v_address1  := Z1.address1;
                         v_address2  := Z1.address2;
                         v_address3  := Z1.address3;
                     END IF;
                  END IF;
                  EXIT;
               END LOOP;
               EXIT;
           END LOOP;
           EXIT;
    END LOOP;
    -- to here             
    --insert_into_parlist(p_policy_id, v_assd_no, v_par_yy);
    insert_into_parlist (p_policy_id, v_assd_no, v_par_yy, p_new_par_id, p_msg, p_proc_renew_flag, p_new_pack_par_id, p_user, v_same_polno_sw); --nieko 07212016 SR 22730, KB 3722, same_polno added
    --CLEAR_MESSAGE;    
    --MESSAGE('Copying policy''s basic info ...',NO_ACKNOWLEDGE);
    --SYNCHRONIZE; 
        --IF pol.prorate_flag = 2 THEN
     /* commented by gmi     
     ** all renewals should be on annual term basis
     ** all premium amounts are then recomputed to be on annual basis too
     ** as what missj, and mam grace approved.. 
     ** requested by fpac
     */    
     v_expiry_date := ADD_MONTHS(v_eff_date,12);
     /*ELSE 
        v_expiry_date := v_eff_date + (variables.proc_expiry_date - v_start_date);       
     END IF;*/
    FOR C IN (SELECT PARAM_VALUE_N
                    FROM GIAC_PARAMETERS
                   WHERE PARAM_NAME = 'PROD_TAKE_UP')
    LOOP
      VAR_VDATE := C.PARAM_VALUE_N;
    END LOOP;                        
    IF VAR_VDATE = 1 OR 
         (VAR_VDATE = 3 AND V_ISSUE_DATE > V_INCEPT_DATE) THEN
        var_idate  := v_issue_date;
    ELSIF VAR_VDATE = 2 OR 
         (VAR_VDATE = 3 AND V_ISSUE_DATE <= V_INCEPT_DATE) THEN
        var_idate  := v_incept_date;
    END IF;
    FOR C IN (SELECT BOOKING_YEAR, 
                     TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| to_char(BOOKING_YEAR,'0999'),'DD-MON-YYYY'), 'MM'), 
                       BOOKING_MTH 
                  FROM GIIS_BOOKING_MONTH
                 WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
                   AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(VAR_IDATE, 'YYYY'))
                    OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(VAR_IDATE, 'YYYY'))
                   AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)||'-'|| TO_CHAR(BOOKING_YEAR, '0999'), 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(VAR_IDATE, 'MM'))))
              ORDER BY 1, 2 ) 
    LOOP
      v_booking_year := C.BOOKING_YEAR;       
      v_booking_mth  := C.BOOKING_MTH;              
      v_book_flag    := 'Y';
      EXIT;
    END LOOP;                     
    IF v_book_flag = 'N' THEN
       FOR E IN (SELECT nvl(param_value_v, 'Y') advance_booking
                   FROM giis_parameters
                  WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE')
       LOOP
           IF e.advance_booking = 'Y' THEN
            FOR C IN (SELECT BOOKING_YEAR,
                             TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| to_char(BOOKING_YEAR,'0999'),'DD-MON-YYYY'), 'MM'),  
                               BOOKING_MTH 
                          FROM GIIS_BOOKING_MONTH
                          WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
                           AND (BOOKING_YEAR < TO_NUMBER(TO_CHAR(var_idate, 'YYYY'))
                             OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(var_idate, 'YYYY'))
                         AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)||'-'|| TO_CHAR(BOOKING_YEAR, '0999'), 'DD-MON-YYYY'), 'MM'))< TO_NUMBER(TO_CHAR(VAR_IDATE, 'MM'))))
                      ORDER BY 1, 2 ) 
            LOOP
              v_booking_year := C.BOOKING_YEAR;       
              v_booking_mth  := C.BOOKING_MTH;              
              EXIT;
            END LOOP;                     
         END IF;                     
       END LOOP;
    END IF;
    INSERT INTO gipi_wpolbas (
                par_id,                line_cd,               iss_cd,     
                foreign_acc_sw,        invoice_sw,            auto_renew_flag,
                prov_prem_tag,         same_polno_sw,         quotation_printed_sw,
                covernote_printed_sw,  pack_pol_flag,         pol_flag,
                reg_policy_sw,         co_insurance_sw,       cred_branch,
                region_cd,             industry_cd,           risk_tag,
                pack_par_id)                                
       VALUES ( p_new_par_id,          pol.line_cd,           pol.iss_cd,         
                pol.foreign_acc_sw,    pol.invoice_sw,        pol.auto_renew_flag,   
                pol.prov_prem_tag,     v_same_polno_sw,       'N',
                'N',                   pol.pack_pol_flag,     '2',
                pol.reg_policy_sw,     pol.co_insurance_sw,   pol.cred_branch,
                pol.region_cd,         pol.industry_cd,       pol.risk_tag,
                p_new_pack_par_id);
    INSERT INTO gipi_polbasic (
                par_id,                line_cd,               subline_cd,         iss_cd,     
                issue_yy,              pol_seq_no,            renew_no,           endt_yy,
                pol_flag,              eff_date,              incept_date,        endt_seq_no,
                expiry_date,           assd_no,               type_cd,            issue_date,    
                acct_of_cd,            designation,           mortg_name,         address1, 
                address2,              address3,              tsi_amt,            prem_amt,     
                pool_pol_no,           prov_prem_pct,         subline_type_cd,    short_rt_percent,
                prorate_flag,          auto_renew_flag,       pack_pol_flag,      prov_prem_tag, 
                expiry_tag,            foreign_acc_sw,        invoice_sw,         discount_sw,  
                reg_policy_sw,         prem_warr_tag,         co_insurance_sw,    user_id, 
                fleet_print_tag,       endt_expiry_tag,       comp_sw,            policy_id ,
                no_of_items,           last_upd_date,         endt_iss_cd,        ann_tsi_amt,
                ann_prem_amt,          booking_mth,           booking_year,       place_cd,
                with_tariff_sw,        actual_renew_no,          cred_branch,        region_cd,
                industry_cd,           spld_flag,             dist_flag,          risk_tag,
                pack_policy_id,
                ACCT_OF_CD_SW, LABEL_TAG)
       VALUES ( p_new_par_id,          pol.line_cd,           pol.subline_cd,     pol.iss_cd,           
                v_issue_yy1,           v_pol_seq_no,          v_renew_no,         0,            
                '2',                   v_incept_date,         v_incept_date,      0,     
                v_expiry_date,         v_assd_no,             pol.type_cd,        SYSDATE,      
                pol.acct_of_cd,        pol.designation,       pol.mortg_name,     pol.address1,        
                pol.address2,          pol.address3,          pol.tsi_amt,        pol.prem_amt,
                pol.pool_pol_no,       pol.prov_prem_pct,     pol.subline_type_cd,pol.short_rt_percent,
                /*pol.prorate_flag*/ '2',      pol.auto_renew_flag,   pol.pack_pol_flag,  pol.prov_prem_tag,   
                pol.expiry_tag,        pol.foreign_acc_sw,    pol.invoice_sw,     pol.discount_sw,                  
                pol.reg_policy_sw,     pol.prem_warr_tag,     pol.co_insurance_sw,USER ,              
                pol.fleet_print_tag,   pol.endt_expiry_tag,   pol.comp_sw,        p_new_policy_id, 
                pol.no_of_items,       SYSDATE,               pol.endt_iss_cd,    pol.ann_tsi_amt,        
                pol.ann_prem_amt,      v_booking_mth,         v_booking_year,     pol.place_cd,
                pol.with_tariff_sw,    v_actual_renew_no,     v_cred_branch,      v_region_cd,
                v_industry_cd,         '1',                   '1',                v_risk_tag,
                p_new_pack_policy_id,
                pol.ACCT_OF_CD_SW,     pol.LABEL_TAG);
    DELETE gipi_wpolbas
     WHERE par_id = p_new_par_id;               
  END LOOP;
   IF p_is_subpolicy = 'N' THEN
      FOR B IN (SELECT line_cd, subline_cd,iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_polbasic
                 WHERE policy_id =p_new_policy_id)
      LOOP
           /*recgrp_row('DISPLAY_RENEWALS',variables.old_pol_id,
                      p_ren=>b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                            to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09'),
                    p_auto=>'Y'); */
          p_message_box  := p_message_box 
                            || '     Auto renewed to  Policy No. '|| b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                            to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09');
      END LOOP;
   END IF; 
END;
/


