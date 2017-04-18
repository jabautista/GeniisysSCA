CREATE OR REPLACE PACKAGE BODY CPI.GICLS276_PKG
AS

    FUNCTION get_lawyer_list_lov
                RETURN lawyer_list_lov_tab PIPELINED
    IS
        v_list lawyer_list_lov_type;
    BEGIN
        FOR i IN(  
        SELECT DISTINCT a.lawyer_cd, b.payee_first_name||' '|| b.payee_middle_name ||' '||b.payee_last_name lawyer_name
              FROM gicl_clm_recovery a, giis_payees b
             WHERE b.payee_no = a.lawyer_cd
               AND b.payee_class_cd = a.lawyer_class_cd)
        LOOP
            v_list.lawyer_cd := i.lawyer_cd;
            v_list.lawyer_name := i.lawyer_name;
            
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
     
    END get_lawyer_list_lov;
    
                
                
    FUNCTION get_clm_list_per_lawyer ( 
                p_user_id                 GIIS_USERS.user_id%TYPE,
                p_lawyer_cd               GICL_CLM_RECOVERY.lawyer_cd%TYPE,
                p_search_by               VARCHAR2,
                p_as_of_date              VARCHAR2,
                p_from_date               VARCHAR2,   
                p_to_date                 VARCHAR2
           )
                RETURN clm_list_per_lawyer_tab PIPELINED

    IS
        v_list  clm_list_per_lawyer_type;
        p_line_cd    GIIS_LINE.line_cd%TYPE := NULL;
        p_iss_cd    GIIS_ISSOURCE.iss_cd%TYPE := NULL;

    BEGIN
        FOR i IN(
            SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no, a.issue_yy, a.pol_seq_no, a.renew_no, a.pol_iss_cd, a.loss_date, a.clm_stat_cd, a.assured_name, a.clm_file_date, 
                    b.lawyer_cd, b.lawyer_class_cd, b.recovery_id, b.rec_year, b.rec_seq_no, b.recoverable_amt, b.recovered_amt, b.cancel_tag, b.case_no, b.court, 
                    c.payor_cd, c.payor_class_cd, e.class_desc , f.clm_stat_desc,
                    d.payee_last_name||' '||d.payee_first_name||' '||d.payee_middle_name AS payee_full_name,
                    get_recovery_no(b.recovery_id) AS recovery_no, 
                    get_claim_number(a.claim_id) AS claim_no,
                    a.line_cd ||'-'|| a.subline_cd ||'-'|| a.pol_iss_cd ||'-'|| 
                    LTRIM(TO_CHAR(a.issue_yy,'09')) ||'-'|| LTRIM(TO_CHAR(a.pol_seq_no,'0999999')) ||'-'|| LTRIM(TO_CHAR(a.renew_no,'09')) AS policy_no

            FROM GICL_CLAIMS a, GICL_CLM_RECOVERY b, GICL_RECOVERY_PAYOR c, GIIS_PAYEES d, GIIS_PAYEE_CLASS e, GIIS_CLM_STAT f
    
            WHERE a.claim_id = b.claim_id 
            AND a.claim_id = c.claim_id
            AND b.recovery_id = c.recovery_id
            AND c.payor_cd = d.payee_no
            AND c.payor_class_cd = d.payee_class_cd
            AND d.payee_class_cd = e.payee_class_cd
            AND a.clm_stat_cd = f.clm_stat_cd
            AND b.lawyer_cd = p_lawyer_cd
            AND ((DECODE (p_search_by,
                           'lossDate', TO_DATE(a.loss_date),
                           'claimFileDate', TO_DATE(a.clm_file_date)) >= TO_DATE(p_from_date, 'MM-DD-YYYY'))
                   AND (DECODE (p_search_by,
                                'lossDate', TO_DATE(a.loss_date),
                                'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                   OR (DECODE (p_search_by,
                                'lossDate', TO_DATE(a.loss_date),
                                'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                 )                                   
    )

    LOOP
        v_list.claim_id := i.claim_id;
        v_list.line_cd	:= i.line_cd;
        v_list.subline_cd := i.subline_cd;
        v_list.iss_cd := i.iss_cd;
        v_list.clm_yy := i.clm_yy ;
        v_list.clm_seq_no := i.clm_seq_no;
        v_list.issue_yy := i.issue_yy;
        v_list.pol_seq_no := i.pol_seq_no;
        v_list.renew_no := i.renew_no;
        v_list.pol_iss_cd := i.pol_iss_cd;
        v_list.loss_date := i.loss_date;
        v_list.clm_stat_cd := i.clm_stat_cd;
        v_list.assured_name := i.assured_name;
        v_list.clm_file_date := i.clm_file_date;
        v_list.lawyer_cd := i.lawyer_cd;
        v_list.lawyer_class_cd := i.lawyer_class_cd;
        v_list.recovery_id := i.recovery_id;
        v_list.rec_year := i.rec_year;
        v_list.rec_seq_no := i.rec_seq_no;
        v_list.recoverable_amt := i.recoverable_amt;
        v_list.recovered_amt := i.recovered_amt;
        v_list.cancel_tag := i.cancel_tag;
        v_list.case_no := i.case_no;
        v_list.court := i.court;
        v_list.payor_cd := i.payor_cd;
        v_list.payor_class_cd := i.payor_class_cd;
        v_list.payee_full_name := i.payee_full_name;
        v_list.class_desc := i.class_desc;
        v_list.recovery_no := i.recovery_no;
        v_list.claim_no := i.claim_no;
        v_list.policy_no := i.policy_no;
        v_list.clm_stat_desc := i.clm_stat_desc;


        PIPE ROW(v_list);
    END LOOP;
    RETURN;
    
    END get_clm_list_per_lawyer;
    
    FUNCTION validate_lawyer(
        p_lawyer    VARCHAR2
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
        BEGIN   
        
        SELECT(SELECT DISTINCT 'X'
                FROM giis_payees a
                WHERE a.payee_class_cd IN (SELECT param_value_v  
                                           FROM giac_parameters
                                           WHERE param_name = 'LAWYER_CLASS_CD')
                AND (UPPER(a.payee_first_name||' '|| a.payee_middle_name ||' '||a.payee_last_name) LIKE NVL(UPPER(p_lawyer),'%')
                         OR a.payee_no LIKE NVL(p_lawyer,'%'))
              )
       INTO v_temp_x
       FROM DUAL;
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;
       END;
       
    FUNCTION get_per_lawyer( 
                p_user_id                 VARCHAR2,
                p_lawyer_cd               VARCHAR2,
                p_search_by               VARCHAR2,
                p_as_of_date              VARCHAR2,
                p_from_date               VARCHAR2,   
                p_to_date                 VARCHAR2
           )
        RETURN per_lawyer_tab PIPELINED
    IS
        v_list  per_lawyer_type;
    BEGIN
        FOR i IN(
            SELECT b.recovery_id, b.case_no, a.claim_id,
                   a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                   b.court, a.assd_no, b.recoverable_amt, b.recovered_amt,b.cancel_tag, a.assured_name,
                   a.clm_file_date, a.loss_date, c.payor_cd, c.payor_class_cd, a.clm_stat_cd, lawyer_cd
              FROM gicl_claims a, gicl_clm_recovery b, gicl_recovery_payor c
             WHERE a.claim_id = b.claim_id
               AND a.claim_id = c.claim_id
               AND b.recovery_id = c.recovery_id
               AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS276',p_user_id) = 1
               AND b.lawyer_cd = p_lawyer_cd
               AND ((DECODE (p_search_by,
                           'lossDate', TO_DATE(a.loss_date),
                           'claimFileDate', TO_DATE(a.clm_file_date)) >= TO_DATE(p_from_date, 'MM-DD-YYYY'))
                   AND (DECODE (p_search_by,
                                'lossDate', TO_DATE(a.loss_date),
                                'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                   OR (DECODE (p_search_by,
                                'lossDate', TO_DATE(a.loss_date),
                                'claimFileDate', TO_DATE(a.clm_file_date)) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                 ) 
                                                 
    )

    LOOP
        v_list.lawyer_cd        := i.lawyer_cd;
        v_list.claim_id         := i.claim_id;
        v_list.recovery_id      := i.recovery_id;
        v_list.recovery_no      := get_recovery_no(i.recovery_id);
        v_list.case_no          := i.case_no;
        v_list.claim_no         := get_claim_number(i.claim_id);
        v_list.policy_no        := get_policy_no(get_policy_id(i.line_cd,i.subline_cd,i.pol_iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no));
        v_list.court            := UPPER(i.court);
        v_list.assd_name        := i.assured_name;
        v_list.recoverable_amt  := i.recoverable_amt;
        v_list.recovered_amt    := i.recovered_amt;
        v_list.clm_file_date    := i.clm_file_date;
        v_list.loss_date        := i.loss_date;
        
        v_list.class_desc   := '';
        v_list.payee_name   := '';
        
        IF i.payor_class_cd IS NOT NULL THEN
            FOR j IN(
                SELECT class_desc
                  FROM giis_payee_class
                 WHERE payee_class_cd = i.payor_class_cd
            )
            LOOP
                v_list.class_desc := j.class_desc;
            
            END LOOP;
        
        END IF;
        
        
        IF i.payor_cd IS NOT NULL THEN
            FOR k IN(
                SELECT payee_last_name||' '||payee_first_name||' '||payee_middle_name payee_name
                  FROM giis_payees
                 WHERE payee_no = i.payor_cd
                   AND payee_class_cd = i.payor_class_cd
            )
            LOOP
                v_list.payee_name := UPPER(k.payee_name);
            
            END LOOP;
        
        END IF;
        
        IF i.cancel_tag IS NULL THEN
             v_list.rec_stat_desc := 'IN PROGRESS';
        ELSIF i.cancel_tag = 'CD' THEN
             v_list.rec_stat_desc := 'CLOSED';
        ELSIF i.cancel_tag = 'CC' THEN
             v_list.rec_stat_desc := 'CANCELLED';
        ELSIF i.cancel_tag = 'WO' THEN
             v_list.rec_stat_desc := 'WRITTEN OFF';
        END IF;
        
        IF i.clm_stat_cd IS NOT NULL THEN
            FOR l IN(
                SELECT clm_stat_desc
                  FROM giis_clm_stat
                 WHERE clm_stat_cd = i.clm_stat_cd
            )
            LOOP
                v_list.clm_stat_desc := l.clm_stat_desc;
            
            END LOOP;
        
        END IF;
        
        PIPE ROW(v_list);
    END LOOP;
    RETURN;
    
    END get_per_lawyer;
    
   FUNCTION get_recovery_details (p_claim_id gicl_clm_recovery.claim_id%TYPE, p_recovery_id gicl_clm_recovery.recovery_id%TYPE)
      RETURN recovery_details_tab PIPELINED
   IS
      v_list   recovery_details_type;
   BEGIN
      FOR i IN (SELECT   a.recovery_id, a.claim_id, a.line_cd, a.rec_year,
                         a.rec_seq_no, a.rec_type_cd, a.recoverable_amt,
                         a.recovered_amt, a.tp_item_desc, a.plate_no,
                         a.currency_cd, a.convert_rate, a.lawyer_class_cd,
                         a.lawyer_cd, a.cpi_rec_no, a.cpi_branch_cd,
                         a.user_id, a.last_update, a.cancel_tag, a.iss_cd,
                         a.rec_file_date, a.demand_letter_date,
                         a.demand_letter_date2, a.demand_letter_date3,
                         a.tp_driver_name, a.tp_drvr_add, a.tp_plate_no,
                         a.case_no, a.court
                    FROM gicl_clm_recovery a
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id
                ORDER BY line_cd, rec_year, rec_seq_no)
      LOOP
         v_list.recovery_id := i.recovery_id;
         v_list.recovery_no := get_recovery_no (i.recovery_id);
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt := i.recovered_amt;
         v_list.plate_no := i.plate_no;
         v_list.tp_item_desc := i.tp_item_desc;

         BEGIN
            SELECT    payee_first_name
                   || ' '
                   || payee_middle_name
                   || ' '
                   || payee_last_name
              INTO v_list.lawyer
              FROM giis_payees
             WHERE payee_no = i.lawyer_cd
               AND payee_class_cd = i.lawyer_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.lawyer := NULL;
         END;

         BEGIN
            IF i.cancel_tag IS NULL
            THEN
               v_list.status := 'IN PROGRESS';
            ELSIF i.cancel_tag = 'CD'
            THEN
               v_list.status := 'CLOSED';
            ELSIF i.cancel_tag = 'CC'
            THEN
               v_list.status := 'CANCELLED';
            ELSIF i.cancel_tag = 'WO'
            THEN
               v_list.status := 'WRITTEN OFF';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_recovery_details;

        
END;
/


