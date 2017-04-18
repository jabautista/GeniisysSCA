CREATE OR REPLACE PACKAGE BODY CPI.giclr267_pkg
AS
   FUNCTION get_giclr_267_report (
      p_user_id         VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_date      VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_as_of_ldate     VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, 
               a.line_cd, 
               a.subline_cd, 
               a.pol_iss_cd, 
               a.issue_yy, 
               a.pol_seq_no, 
               a.renew_no,
a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LPAD(a.issue_yy,2,'0')||'-'||LPAD(a.pol_seq_no,7,'0')||'-'||LPAD(a.renew_no,2,'0') AS policy_no,         
      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LPAD(a.clm_yy,2,'0')||'-'||LPAD(a.clm_seq_no,7,'0') AS claim_no,  
                              a.assured_name, 
               a.dsp_loss_date, 
               a.clm_file_date,
               a.clm_stat_cd AS clm_stat_cd, 
               c.clm_stat_desc AS clm_stat_desc,
               NVL (loss_res_amt, 0) loss_res_amt,
               NVL (exp_res_amt, 0) exp_res_amt,
               NVL (loss_pd_amt, 0) loss_pd_amt,
               NVL (exp_pd_amt, 0) exp_pd_amt,
               b.ri_cd AS ri_cd,
               b.ri_name
   FROM  gicl_claims a, giis_reinsurer b, giis_clm_stat c
   WHERE  a.ri_cd = b.ri_cd
   --AND UPPER(a.user_id) = UPPER(p_user_id)
   AND  a.clm_stat_cd = c.clm_stat_cd (+)
   AND check_user_per_line2 (a.line_cd,a.ISS_CD,'GICLS267', UPPER(p_user_id))=1
   AND a.ri_cd = p_ri_cd
   AND ((TRUNC(a.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY')
   AND TRUNC(a.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY')
   OR TRUNC(a.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
   OR (TRUNC(a.loss_date) >= TO_DATE (p_from_ldate, 'MM-DD-YYYY')
   AND TRUNC(a.loss_date) <= TO_DATE (p_to_ldate, 'MM-DD-YYYY')
   OR TRUNC(a.loss_date) <= TO_DATE (p_as_of_ldate, 'MM-DD-YYYY'))) 
    )
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.assured_name := i.assured_name;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_res_amt := i.loss_res_amt;
         v_list.exp_res_amt := i.exp_res_amt;
         v_list.loss_pd_amt := i.loss_pd_amt;
         v_list.exp_pd_amt := i.exp_pd_amt;
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.ri_cd := i.ri_cd;
         v_list.ri_name := i.ri_name;
         v_list.clm_stat_desc := i.clm_stat_desc;
              
         
         IF p_as_of_date IS NOT NULL THEN
                v_list.date_type :='Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                v_list.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_as_of_ldate IS NOT NULL THEN    
                v_list.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                v_list.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
            END IF;
    
         PIPE ROW (v_list);

--         BEGIN
--            SELECT clm_stat_desc
--              INTO v_list.clm_stat_desc
--              FROM giis_clm_stat
--             WHERE clm_stat_cd = i.clm_stat_cd;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               v_list.clm_stat_desc := NULL;
--         END;
         
      END LOOP;

      RETURN;
   END get_giclr_267_report;
END;
/


