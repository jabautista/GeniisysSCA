CREATE OR REPLACE PACKAGE BODY CPI.gipis201_pkg
AS
/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 10.10.2013
**  Reference By  : (GIPIS201 - Underwriting - Policy Inquiries - View Production)
**  Description   : View Production Policy Details
*/
   FUNCTION get_prod_policy_details (
      p_line_cd1      gipi_polbasic.line_cd%TYPE,
      p_subline_cd1   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd1       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy1     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no1   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no1     gipi_polbasic.renew_no%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_param_date    NUMBER,
      p_from_date     DATE,
      p_to_date       DATE,
      p_month         VARCHAR2,
      p_year          NUMBER,
      p_dist_flag     VARCHAR2,
      p_user          gipi_prod_ext.user_id%TYPE
   )
      RETURN get_prod_policy_details_tab PIPELINED
   IS
      v_list     get_prod_policy_details_type;
      curr_rt    NUMBER                       := 0;
      prem_seq   NUMBER;
      v_iss_cd   VARCHAR2 (5);
   BEGIN
      FOR i IN (SELECT   *
                    FROM gipi_prod_ext
                   WHERE line_cd = p_line_cd1
                     AND subline_cd = p_subline_cd1
                     AND iss_cd = p_iss_cd1
                     AND issue_yy = p_issue_yy1
                     AND pol_seq_no = p_pol_seq_no1
                     AND renew_no = p_renew_no1
                     AND pol_flag != '5'
                     AND user_id = p_user
                ORDER BY line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         endt_seq_no)
      LOOP
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
         v_list.tsi_amt := i.total_tsi;
         v_list.pol_flag := i.pol_flag;
         v_list.assured := i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.issue_date := TO_CHAR (i.issue_date, 'MM-DD-RRRR');
         v_list.prem_amt := i.total_prem;
         v_list.tax_amt := i.evatprem + i.fst + i.lgt + i.doc_stamps;
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
            || LPAD (LTRIM (TO_CHAR (i.renew_no, '99')), 2, '0');

         IF i.endt_seq_no = 0
         THEN
            v_list.endt_iss_cd := i.endt_iss_cd;
            v_list.endt_yy := 0;
            v_list.endt_seq_no := 0;
         ELSE
            v_list.endt_iss_cd := i.endt_iss_cd;
            v_list.endt_yy := i.endt_yy;
            v_list.endt_seq_no := i.endt_seq_no;
         END IF;

         FOR b IN (SELECT NVL (commission_amt, 0) comm, b.currency_rt
                     FROM gipi_comm_invoice a, gipi_invoice b
                    WHERE a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND b.policy_id = i.policy_id)
         LOOP
            v_list.commission := b.comm * b.currency_rt;
         END LOOP;

         IF v_list.endt_yy = 0 AND v_list.endt_seq_no = 0
         THEN
            v_list.endorsement_no := NULL;
         ELSIF     v_list.endt_iss_cd IS NOT NULL
               AND v_list.endt_yy IS NOT NULL
               AND v_list.endt_seq_no IS NOT NULL
         THEN
            v_list.endorsement_no :=
                  LTRIM (v_list.endt_iss_cd)
               || '-'
               || LPAD (LTRIM (TO_CHAR (v_list.endt_yy, '99')), 2, '0')
               || '-'
               || LPAD (LTRIM (TO_CHAR (v_list.endt_seq_no, '999999')), 6,
                        '0');
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_prod_policy_details;

   FUNCTION val_gipis201_disp_orc
      RETURN VARCHAR2
   IS
      v_param_value_v   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR i IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'DISPLAY_OVERRIDING_COMM')
      LOOP
         v_param_value_v := i.param_value_v;
      END LOOP;

      RETURN (v_param_value_v);
   END val_gipis201_disp_orc;

   FUNCTION get_comm_dtls (
      p_iss_cd      giac_parent_comm_invprl.iss_cd%TYPE,
      p_line_cd     giis_peril.line_cd%TYPE,
      p_policy_id   gipi_comm_inv_peril.policy_id%TYPE,
      p_intm_no     gipi_comm_inv_peril.intrmdry_intm_no%TYPE
   )
      RETURN get_comm_dtls_tab PIPELINED
   IS
      v_list   get_comm_dtls_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gipi_comm_inv_peril
                 WHERE policy_id = p_policy_id)
      LOOP
         FOR a IN (SELECT   SUM (NVL (a.commission_rt, 0)) a1,
                            SUM (NVL (a.commission_amt, 0)) a2,
                            SUM (NVL (b.commission_rt, 0)) b1,
                            SUM (NVL (b.commission_amt, 0)) b2, c.peril_name
                       FROM giac_parent_comm_invprl a,
                            gipi_comm_inv_peril b,
                            giis_peril c
                      WHERE 1 = 1
                        AND a.iss_cd(+) = b.iss_cd
                        AND a.prem_seq_no(+) = b.prem_seq_no
                        AND a.chld_intm_no(+) = b.intrmdry_intm_no
                        AND a.peril_cd(+) = b.peril_cd
                        AND a.iss_cd(+) = p_iss_cd
                        AND c.peril_cd = i.peril_cd
                        AND c.line_cd = p_line_cd
                        AND b.peril_cd = c.peril_cd
                        AND b.policy_id = p_policy_id
                        AND b.intrmdry_intm_no =
                                           NVL (p_intm_no, b.intrmdry_intm_no)
                   GROUP BY c.peril_name)
         LOOP
            v_list.parent_comm_rt := NVL (a.a1, 0.00);
            v_list.parent_comm_amt := NVL (a.a2, 0.00);
            v_list.child_comm_rt := NVL (a.b1 - a.a1, 0.00);
            v_list.child_comm_amt := NVL (a.b2 - a.a2, 0.00);
            v_list.peril_name := a.peril_name;
            PIPE ROW (v_list);
         END LOOP;
      END LOOP;

      RETURN;
   END get_comm_dtls;
END gipis201_pkg;
/


