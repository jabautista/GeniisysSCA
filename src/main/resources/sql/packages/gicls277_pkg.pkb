CREATE OR REPLACE PACKAGE BODY CPI.gicls277_pkg
AS
   FUNCTION populate_gicls277_main2 (
      P_USER_ID             VARCHAR2,
      P_PAYEE_CLASS_CD      VARCHAR2,
      P_PAYEE_NO            VARCHAR2,
      P_FROM_DATE           VARCHAR2,
      P_TO_DATE             VARCHAR2,
      P_AS_OF_DATE          VARCHAR2,
      P_SEARCH_BY           VARCHAR2,
      P_TP_TYPE             VARCHAR2
   )
      RETURN gicls277_details_tab PIPELINED
   IS
      ntt       gicls277_details_type;
      v_exist   VARCHAR2(3);
   BEGIN
      FOR i IN(
           SELECT DISTINCT payee_class_cd, payee_no, claim_id, tp_type
                      FROM gicl_mc_tp_dtl
                     WHERE claim_id IN (
                              SELECT a.claim_id
                                FROM gicl_claims a--, gicl_clm_reserve b
                               WHERE check_user_per_line2 (line_cd,iss_cd,'GICLS277', P_USER_ID) = 1
                                 AND clm_stat_cd NOT IN ('CD', 'DN', 'WD', 'CC')
                                 --AND a.claim_id = b.claim_id
                                 AND (
                                    (DECODE (P_SEARCH_BY,'lossDate', TO_DATE(a.loss_date),'claimFileDate', TO_DATE(a.clm_file_date)) >= TO_DATE (P_FROM_DATE, 'MM-DD-YYYY') )
                                        AND (DECODE (P_SEARCH_BY,'lossDate', TO_DATE(a.loss_date),'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE (P_TO_DATE, 'MM-DD-YYYY'))
                                         OR (DECODE (P_SEARCH_BY,'lossDate', TO_DATE(a.loss_date),'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE (P_AS_OF_DATE, 'MM-DD-YYYY'))
                                 )
                       )
                       AND UPPER(payee_class_cd) LIKE UPPER(P_PAYEE_CLASS_CD)
                       AND UPPER(payee_no) LIKE UPPER(P_PAYEE_NO)
                       AND UPPER(tp_type) LIKE UPPER(NVL(P_TP_TYPE,'%'))
      )
      
      LOOP
        
        ntt.payee_class_cd      := i.payee_class_cd;
        ntt.payee_no            := i.payee_no;
        ntt.claim_id            := i.claim_id;
        ntt.tp_type             := i.tp_type;
        
        BEGIN
            FOR x IN (
                SELECT class_desc
                  FROM giis_payee_class
                 WHERE payee_class_cd = i.payee_class_cd
            )
            LOOP
                    ntt.class_desc := x.class_desc;
            END LOOP;
        END;
      
        BEGIN
            FOR x IN (
                SELECT payee_last_name||', '||payee_first_name||' '||payee_middle_name payee
                  FROM giis_payees
                 WHERE payee_class_cd = i.payee_class_cd
                   AND payee_no = i.payee_no
            )
            LOOP
                ntt.payee_name := x.payee;
            END LOOP;
            
        END;
        
        BEGIN
            FOR j IN(
                SELECT a.peril_cd, a.item_no, b.line_cd, b.subline_cd, b.iss_cd, 
                       b.clm_yy, b.clm_seq_no, b.pol_iss_cd, 
                       b.issue_yy, b.pol_seq_no, b.renew_no,
                       b.assd_no, b.assured_name, b.dsp_loss_date, 
                       b.clm_file_date, b.intm_no, c.loss_cat_des, d.clm_stat_desc
                  FROM gicl_clm_loss_exp a, gicl_claims b, giis_loss_ctgry c, giis_clm_stat d
                 WHERE b.claim_id = i.claim_id
                   AND b.claim_id = a.claim_id
                   AND b.loss_cat_cd = c.loss_cat_cd
                   AND b.line_cd     = c.line_cd
                   AND b.clm_stat_cd = d.clm_stat_cd
            )
            
            LOOP
                ntt.clm_stat_desc   := NVL(j.clm_stat_desc, null);
                ntt.peril_cd        := NVL(j.peril_cd, null);
                ntt.item_no         := NVL(j.item_no, null);
                ntt.loss_cat_des    := NVL(j.loss_cat_des, null);
                ntt.line_cd         := NVL(j.line_cd,null);
                ntt.subline_cd      := NVL(j.subline_cd,null);
                ntt.iss_cd          := NVL(j.iss_cd,null);
                ntt.clm_yy          := NVL(TO_CHAR(j.clm_yy, '09'),null);
                ntt.clm_seq_no      := NVL(TO_CHAR(j.clm_seq_no, '0000009'),null);
                ntt.pol_iss_cd      := NVL(j.pol_iss_cd,null);
                ntt.issue_yy        := NVL(TO_CHAR(j.issue_yy,'09'),null);
                ntt.pol_seq_no      := NVL(TO_CHAR(j.pol_seq_no,'0999999'),null);
                ntt.renew_no        := NVL(TO_CHAR(j.renew_no,'09'),null);
                ntt.assured_name    := NVL(j.assured_name,null);
                ntt.loss_date       := NVL(TO_CHAR(j.dsp_loss_date, 'MM-DD-RRRR'),null);
                ntt.claim_date      := NVL(TO_CHAR(j.clm_file_date, 'MM-DD-RRRR'),null);
                ntt.intm_no         := NVL(j.intm_no,null);
                ntt.claim_number    := NVL(j.line_cd,null)||'-'||NVL(j.subline_cd,null)||'-'||NVL(j.iss_cd,null)||'-'||NVL(TO_CHAR(j.clm_yy, '09'),null)||'-'||NVL(TO_CHAR(j.clm_seq_no, '0000009'),null);
                ntt.policy_number   := NVL(j.line_cd,null)||'-'||NVL(j.subline_cd,null)||'-'||NVL(j.pol_iss_cd,null)||'-'||NVL(TO_CHAR(j.issue_yy,'09'),null)||'-'||NVL(TO_CHAR(j.pol_seq_no,'0999999'),null)||'-'||NVL(TO_CHAR(j.renew_no,'09'),null);
                
                BEGIN
                
                    FOR rec IN (
                        SELECT '1'
                          FROM gicl_clm_recovery a
                         WHERE a.claim_id = i.claim_id
                    )
                    
                    LOOP
                      v_exist := 'Y';      
                    END LOOP;
                                                  
                    IF v_exist = 'Y' THEN
                       ntt.recovery_details := 'Y';
                    ELSE
                       ntt.recovery_details := 'N';
                    END IF;
                
                END;
            END LOOP;
        END;
        
         PIPE ROW (ntt);
      END LOOP;
      RETURN;
   END populate_gicls277_main2;
   
   FUNCTION populate_gicls277_main (
      P_USER_ID             VARCHAR2,
      P_PAYEE_CLASS_CD      VARCHAR2,
      P_PAYEE_NO            VARCHAR2,
      P_FROM_DATE           VARCHAR2,
      P_TO_DATE             VARCHAR2,
      P_AS_OF_DATE          VARCHAR2,
      P_SEARCH_BY           VARCHAR2,
      P_TP_TYPE             VARCHAR2
   )
      RETURN gicls277_details_tab PIPELINED
   IS
      ntt       gicls277_details_type;
      v_exist   VARCHAR2(3);
   BEGIN
      FOR i IN(
           SELECT DISTINCT payee_class_cd, payee_no, claim_id, tp_type
                      FROM gicl_mc_tp_dtl
                     WHERE claim_id IN (
                              SELECT a.claim_id
                                FROM gicl_claims a--, gicl_clm_reserve b
                               WHERE check_user_per_line2 (line_cd,iss_cd,'GICLS277', P_USER_ID) = 1
                                 AND clm_stat_cd NOT IN ('CD', 'DN', 'WD', 'CC')
                                 --AND a.claim_id = b.claim_id
                                 AND (
                                    (DECODE (P_SEARCH_BY,'lossDate', TO_DATE(a.loss_date),'claimFileDate', TO_DATE(a.clm_file_date)) >= TO_DATE (P_FROM_DATE, 'MM-DD-YYYY') )
                                        AND (DECODE (P_SEARCH_BY,'lossDate', TO_DATE(a.loss_date),'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE (P_TO_DATE, 'MM-DD-YYYY'))
                                         OR (DECODE (P_SEARCH_BY,'lossDate', TO_DATE(a.loss_date),'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE (P_AS_OF_DATE, 'MM-DD-YYYY'))
                                 )
                       )
                       AND UPPER(payee_class_cd) LIKE UPPER(P_PAYEE_CLASS_CD)
                       AND UPPER(payee_no) LIKE UPPER(P_PAYEE_NO)
                       AND UPPER(tp_type) LIKE UPPER(NVL(P_TP_TYPE,'%'))
      )
      
      LOOP
        
        ntt.payee_class_cd      := i.payee_class_cd;
        ntt.payee_no            := i.payee_no;
        ntt.claim_id            := i.claim_id;
        ntt.tp_type             := i.tp_type;
        
        BEGIN
            FOR x IN (
                SELECT class_desc
                  FROM giis_payee_class
                 WHERE payee_class_cd = i.payee_class_cd
            )
            LOOP
                    ntt.class_desc := x.class_desc;
            END LOOP;
        END;
      
        BEGIN
            FOR x IN (
                SELECT payee_last_name||', '||payee_first_name||' '||payee_middle_name payee
                  FROM giis_payees
                 WHERE payee_class_cd = i.payee_class_cd
                   AND payee_no = i.payee_no
            )
            LOOP
                ntt.payee_name := x.payee;
            END LOOP;
            
        END;
        
        BEGIN
            FOR j IN(
                SELECT /*a.peril_cd, a.item_no, */b.line_cd, b.subline_cd, b.iss_cd, 
                       b.clm_yy, b.clm_seq_no, b.pol_iss_cd, 
                       b.issue_yy, b.pol_seq_no, b.renew_no,
                       b.assd_no, b.assured_name, b.dsp_loss_date, 
                       b.clm_file_date, b.intm_no, c.loss_cat_des, d.clm_stat_desc
                  FROM gicl_claims b, giis_loss_ctgry c, giis_clm_stat d
                 WHERE b.claim_id = i.claim_id
                   AND b.loss_cat_cd = c.loss_cat_cd
                   AND b.line_cd     = c.line_cd
                   AND b.clm_stat_cd = d.clm_stat_cd
            )
            LOOP
                ntt.clm_stat_desc   := NVL(j.clm_stat_desc, null);
                --ntt.peril_cd        := NVL(j.peril_cd, null);
                --ntt.item_no         := NVL(j.item_no, null);
                ntt.loss_cat_des    := NVL(j.loss_cat_des, null);
                ntt.line_cd         := NVL(j.line_cd,null);
                ntt.subline_cd      := NVL(j.subline_cd,null);
                ntt.iss_cd          := NVL(j.iss_cd,null);
                ntt.clm_yy          := NVL(TO_CHAR(j.clm_yy, '09'),null);
                ntt.clm_seq_no      := NVL(TO_CHAR(j.clm_seq_no, '0000009'),null);
                ntt.pol_iss_cd      := NVL(j.pol_iss_cd,null);
                ntt.issue_yy        := NVL(TO_CHAR(j.issue_yy,'09'),null);
                ntt.pol_seq_no      := NVL(TO_CHAR(j.pol_seq_no,'0999999'),null);
                ntt.renew_no        := NVL(TO_CHAR(j.renew_no,'09'),null);
                ntt.assured_name    := NVL(j.assured_name,null);
                ntt.loss_date       := NVL(TO_CHAR(j.dsp_loss_date, 'MM-DD-RRRR'),null);
                ntt.claim_date      := NVL(TO_CHAR(j.clm_file_date, 'MM-DD-RRRR'),null);
                ntt.intm_no         := NVL(j.intm_no,null);
                ntt.claim_number    := NVL(j.line_cd,null)||'-'||NVL(j.subline_cd,null)||'-'||NVL(j.iss_cd,null)||'-'||NVL(TO_CHAR(j.clm_yy, '09'),null)||'-'||NVL(TO_CHAR(j.clm_seq_no, '0000009'),null);
                ntt.policy_number   := NVL(j.line_cd,null)||'-'||NVL(j.subline_cd,null)||'-'||NVL(j.pol_iss_cd,null)||'-'||NVL(TO_CHAR(j.issue_yy,'09'),null)||'-'||NVL(TO_CHAR(j.pol_seq_no,'0999999'),null)||'-'||NVL(TO_CHAR(j.renew_no,'09'),null);
                
                FOR clm IN (
                        SELECT a.peril_cd, a.item_no 
                          FROM gicl_clm_loss_exp a
                         WHERE a.claim_id = i.claim_id
                )
                LOOP
                   ntt.peril_cd        := NVL(clm.peril_cd, null);
                   ntt.item_no         := NVL(clm.item_no, null); 
                   
                END LOOP;
                
                ntt.recovery_details := 'N';
                
                BEGIN
                    FOR rec IN (
                        SELECT '1'
                          FROM gicl_clm_recovery a
                         WHERE a.claim_id = i.claim_id
                    )
                    
                    LOOP
                      v_exist := 'Y';      
                    END LOOP;
                                                  
                    IF v_exist = 'Y' THEN
                       ntt.recovery_details := 'Y';
                    ELSE
                       ntt.recovery_details := 'N';
                    END IF;
                
                END;
            END LOOP;
        END;
        
         PIPE ROW (ntt);
      END LOOP;
      RETURN;
   END populate_gicls277_main;
   
   FUNCTION fetch_valid_third_party(
      P_USER_ID          VARCHAR2
   )
      RETURN valid_third_party_tab PIPELINED
   IS
      ntt       valid_third_party_type;
   BEGIN
   
      FOR i IN(
           SELECT DISTINCT payee_class_cd, payee_no, claim_id
                      FROM gicl_mc_tp_dtl
                     WHERE claim_id IN (
                              SELECT claim_id
                                FROM gicl_claims
                               WHERE check_user_per_line2 (line_cd,iss_cd,'GICLS277', P_USER_ID) = 1
                                AND clm_stat_cd NOT IN ('CD', 'DN', 'WD', 'CC')
                                )
      )
      
      LOOP
        ntt.payee_class_cd      := i.payee_class_cd;
        ntt.payee_no            := i.payee_no;
      PIPE ROW(ntt);
      END LOOP;
      RETURN;
   END fetch_valid_third_party;
   
   PROCEDURE validate_gicls277_name(
      p_payee_no         OUT VARCHAR2,
      p_payee_name       OUT VARCHAR2,
      p_search        IN     VARCHAR2,
      p_payee_class   IN     VARCHAR2
   )
    IS
    BEGIN
        SELECT    payee_last_name
               || ' '
               || payee_first_name
               || ' '
               || payee_middle_name payee,
               payee_no
          INTO p_payee_name, p_payee_no
          FROM giis_payees
         WHERE UPPER (payee_class_cd) = UPPER (NVL (p_payee_class, '%'))
           AND (payee_no LIKE p_search
            OR UPPER(payee_last_name||payee_first_name || payee_middle_name) LIKE UPPER(regexp_replace(p_search, '[[:space:]]', '')));
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_payee_no     := '---';
            p_payee_name   := '---';
        WHEN OTHERS THEN
            p_payee_no   := NULL;
            p_payee_name := NULL;
    END;
END;
/


