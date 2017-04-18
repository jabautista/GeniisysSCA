CREATE OR REPLACE PACKAGE BODY CSV_CLM_PER_CEDING_GICLR267 AS 
/*
**  Created by   : Bernadette Quitain
**  Date Created : 03.28.2016
**  Reference By : GICLR267 - Claim Listing per Ceding Company
*/
   FUNCTION CSV_GICLR267 (
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
      FOR i IN (SELECT 
      a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LPAD(a.issue_yy,2,'0')||'-'||LPAD(a.pol_seq_no,7,'0')||'-'||LPAD(a.renew_no,2,'0') AS policy_no,         
      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LPAD(a.clm_yy,2,'0')||'-'||LPAD(a.clm_seq_no,7,'0') AS claim_no,  
               a.assured_name, 
               TO_CHAR(a.dsp_loss_date,'MM-DD-RRRR') AS dsp_loss_date, 
               TO_CHAR(a.clm_file_date,'MM-DD-RRRR') AS clm_file_date,  
               c.clm_stat_desc AS clm_stat_desc,
               TO_CHAR(NVL (loss_res_amt, 0),'999,999,999,990.99') loss_res_amt, --modified amount format by carlo rubenecia 04.27.2016 SR 5405
               TO_CHAR(NVL (exp_res_amt, 0),'999,999,999,990.99') exp_res_amt, --modify amount format by carlo rubenecia 04.27.2016 SR 5405
               TO_CHAR(NVL (loss_pd_amt, 0),'999,999,999,990.99') loss_pd_amt, --modify amount format by carlo rubenecia 04.27.2016 SR 5405
               TO_CHAR(NVL (exp_pd_amt, 0),'999,999,999,990.99') exp_pd_amt,   --modify amount format by carlo rubenecia 04.27.2016 SR 5405
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
         v_list.claim_number := i.claim_no;
         v_list.policy_number := i.policy_no;
         v_list.assured := i.assured_name;
         v_list.loss_date := i.dsp_loss_date;
         v_list.file_date := i.clm_file_date;
         v_list.loss_reserve := trim(i.loss_res_amt); --modify by carlo rubenecia 04.27.2016 SR 5405
         v_list.expense_reserve := trim(i.exp_res_amt); --modify by carlo rubenecia 04.27.2016 SR 5405
         v_list.losses_paid := trim(i.loss_pd_amt); --modify by carlo rubenecia 04.27.2016 SR 5405
         v_list.expenses_paid := trim(i.exp_pd_amt); --modify by carlo rubenecia 04.27.2016 SR 5405
         v_list.ceding_company := i.ri_name;
         v_list.claim_status := i.clm_stat_desc;       
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END CSV_GICLR267;
END;
/
