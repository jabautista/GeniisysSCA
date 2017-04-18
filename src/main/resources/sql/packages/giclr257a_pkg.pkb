CREATE OR REPLACE PACKAGE BODY CPI.giclr257a_pkg
AS
   FUNCTION get_giclr_257_a_report (
      p_user_id         VARCHAR2,
      p_payee_no        VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_date      VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_as_of_ldate     VARCHAR2,
      p_from_adate      VARCHAR2,
      p_to_adate        VARCHAR2,
      p_as_of_adate     VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
      v_exist  VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT    b.payee_no
       || ' - '
       || DECODE (b.payee_first_name,
                  '-', b.payee_last_name,
                     b.payee_first_name
                  || ' '
                  || b.payee_middle_name
                  || ' '
                  || b.payee_last_name
                 ) payee_name,
       b.payee_class_cd, f.clm_stat_desc, d.assign_date,
          a.line_cd
       || '-'
       || a.subline_cd
       || '-'
       || a.iss_cd
       || '-'
       || LTRIM (TO_CHAR (a.clm_yy, '09'))
       || '-'
       || LTRIM (TO_CHAR (a.clm_seq_no, '0000009')) claim_no,
          a.line_cd
       || '-'
       || a.subline_cd
       || '-'
       || a.pol_iss_cd
       || '-'
       || LTRIM (TO_CHAR (a.issue_yy, '09'))
       || '-'
       || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
       || '-'
       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
       a.assured_name, a.loss_date, a.clm_file_date, d.adj_company_cd, a.clm_stat_cd, b.payee_no,
       d.priv_adj_cd, d.claim_id, d.complt_date, trunc(NVL(d.complt_date, sysdate)-d.assign_date) days_outstanding
  FROM giis_payees b, gicl_claims a, giis_clm_stat f, gicl_clm_adjuster d
  WHERE b.payee_class_cd = (SELECT param_value_v
                             FROM giac_parameters
                            WHERE param_name = 'ADJP_CLASS_CD')
--   AND UPPER(a.user_id) = UPPER(p_user_id)
   AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS257', UPPER(p_user_id)) = 1
   AND f.clm_stat_cd = a.clm_stat_cd
   AND a.claim_id = d.claim_id
   AND b.payee_no = d.adj_company_cd
   AND check_user_per_line2 (a.line_cd, a.iss_cd, 'GICLS257', UPPER(p_user_id)) = 1
   AND b.payee_no = NVL (p_payee_no, b.payee_no)
   AND d.complt_date IS NULL
   AND d.cancel_tag IS NULL
AND ((trunc(a.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY')
AND trunc(a.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY')
OR trunc(a.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
OR (trunc(a.loss_date) >= TO_DATE (p_from_ldate, 'MM-DD-YYYY')
AND trunc(a.loss_date) <= TO_DATE (p_to_ldate, 'MM-DD-YYYY')
OR trunc(a.loss_date) <= TO_DATE (p_as_of_ldate, 'MM-DD-YYYY'))
OR (trunc(d.assign_date) >= TO_DATE (p_from_adate, 'MM-DD-YYYY')
AND trunc(d.assign_date) <= TO_DATE (p_to_adate, 'MM-DD-YYYY')
OR trunc(d.assign_date) <= TO_DATE (p_as_of_adate, 'MM-DD-YYYY')))
    )
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.assured_name := i.assured_name;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.loss_date := TO_CHAR(i.loss_date,'MM-DD-YYYY');
         v_list.clm_file_date := TO_CHAR(i.clm_file_date,'MM-DD-YYYY');
         v_list.assign_date := TO_CHAR(i.assign_date,'MM-DD-YYYY');
         v_list.priv_adj_cd := i.priv_adj_cd;
         v_list.complt_date := i.complt_date;
         v_list.payee_no := i.payee_no;
         v_list.payee_name := i.payee_name;
         v_list.days_outstanding := i.days_outstanding;
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS'); 
         v_exist := 'Y';        
    
         BEGIN
               SELECT payee_name
                  INTO v_list.private_adjuster
                  FROM giis_adjuster
                 WHERE adj_company_cd = i.adj_company_cd
                   AND priv_adj_cd = i.priv_adj_cd;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   v_list.private_adjuster := NULL;
            END;
            
         BEGIN
               SELECT SUM(paid_amt)paid_amt
                  INTO v_list.paid_amt
                  FROM gicl_clm_loss_exp
                 WHERE payee_cd = i.adj_company_cd
                   AND payee_class_cd = (SELECT param_value_v
                                           FROM giac_parameters
                                           WHERE param_name = 'ADJP_CLASS_CD')
                   AND tran_id is not null
                   AND claim_id = i.claim_id;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   v_list.paid_amt := NULL;
            END;
         
         IF p_as_of_date IS NOT NULL THEN
                v_list.date_type :='Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                v_list.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_as_of_ldate IS NOT NULL THEN    
                v_list.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                v_list.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_as_of_adate IS NOT NULL THEN    
                v_list.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_adate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_from_adate IS NOT NULL AND p_to_adate IS NOT NULL THEN
                v_list.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_adate, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_adate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            END IF;

         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;

         PIPE ROW (v_list);         
         
      END LOOP;
      
      IF v_exist = 'N' THEN
        v_list.company_name := giisp.v ('COMPANY_NAME');
        v_list.company_address := giisp.v ('COMPANY_ADDRESS');
        
        IF p_as_of_date IS NOT NULL THEN
            v_list.date_type :='Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
            v_list.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        ELSIF p_as_of_ldate IS NOT NULL THEN    
            v_list.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
            v_list.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        ELSIF p_as_of_adate IS NOT NULL THEN    
            v_list.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_adate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        ELSIF p_from_adate IS NOT NULL AND p_to_adate IS NOT NULL THEN
            v_list.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_adate, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_adate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
        END IF;
    
        PIPE ROW (v_list);
      
      END IF;
   END get_giclr_257_a_report;
END;
/


