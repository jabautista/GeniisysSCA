CREATE OR REPLACE PACKAGE BODY CPI.gipis202_pkg
AS
/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.10.2013
**  Reference By  : (GIPIS202 - Underwriting - Policy Inquiries - View Production)
**  Description   : View Production Details
*/
   FUNCTION get_production_details (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_intm_no         giis_intermediary.intm_no%TYPE,
      p_cred_iss        gipi_polbasic.cred_branch%TYPE,
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE,
      p_month           gipi_polbasic.booking_mth%TYPE,
      p_year            gipi_polbasic.booking_year%TYPE,
      p_dist_flag       VARCHAR2,
      p_reg_policy_sw   VARCHAR2,
      p_user            gipi_prod_ext.user_id%TYPE
   )
      RETURN get_production_details_tab PIPELINED
   IS
      v_list     get_production_details_type;
      curr_rt    NUMBER                      := 0;
      prem_seq   NUMBER;
      v_iss_cd   VARCHAR2 (5);
   BEGIN
      FOR i IN (SELECT   a.*
                    FROM gipi_prod_ext a
                   WHERE user_id = p_user
                ORDER BY a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no,
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no)
      LOOP
         v_list.tsi_amt := NULL;
         v_list.prem_amt := NULL;
         v_list.policy_id := i.policy_id;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.par_id := i.par_id;
         v_list.eff_date := i.eff_date;
         v_list.assd_no := i.assd_no;
         v_list.assured := i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.issue_date := TO_CHAR (i.issue_date, 'MM-DD-RRRR');
         v_list.tsi_amt := i.total_tsi;
         v_list.prem_amt := i.total_prem;
         v_list.policy_no :=
               LTRIM (i.line_cd)
            || '-'
            || LTRIM (i.subline_cd)
            || '-'
            || LTRIM (i.iss_cd)
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '99'))
            || '-'
            || LPAD (LTRIM (TO_CHAR (i.pol_seq_no, '9999999')), 7, '0')
            || '-'
            || LPAD (LTRIM (TO_CHAR (i.renew_no, '99')), 2, '0')
            || '-'
            || LTRIM (v_list.endt_iss_cd)
            || '-'
            || LPAD (LTRIM (TO_CHAR (v_list.endt_yy, '99')), 2, '0')
            || '-'
            || LPAD (LTRIM (TO_CHAR (v_list.endt_seq_no, '999999')), 3, '0');
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_production_details;
END gipis202_pkg;
/


