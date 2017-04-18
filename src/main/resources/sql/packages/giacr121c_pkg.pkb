CREATE OR REPLACE PACKAGE BODY CPI.giacr121c_pkg
AS
   FUNCTION populate_giacr121c (
      p_date_from   VARCHAR2,
      p_date_to     VARCHAR2,
      p_cut_off     VARCHAR2,
      p_line_cd     VARCHAR2,
      p_ri_cd       VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr121c_tab PIPELINED
   AS
      v_rec         giacr121c_type;
      v_from_date   DATE           := TO_DATE (p_date_from, 'MM/DD/YYYY');
      v_to_date     DATE           := TO_DATE (p_date_to, 'MM/DD/YYYY');
      v_cut_off     DATE           := TO_DATE (p_cut_off, 'MM/DD/YYYY');
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      FOR b IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_rec.company_name := b.param_value_v;
         EXIT;
      END LOOP;

      FOR c IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'COMPANY_ADDRESS')
      LOOP
         v_rec.company_address := c.param_value_v;
         EXIT;
      END LOOP;

      v_rec.title := giacp.v ('GIACR121_TITLE');
      v_rec.date_label := giacp.v ('GIACR121_DATE_LABEL');
      v_rec.date_from := TO_CHAR (v_from_date, 'fmMonth DD, YYYY');
      v_rec.date_to := TO_CHAR (v_to_date, 'fmMonth DD, YYYY');
      v_rec.cut_off := TO_CHAR (v_cut_off, 'fmMonth DD, YYYY');

      FOR i IN (SELECT   r.ri_cd, r.ri_name, r.bill_address address,
                         r.line_name || ':' line_name, r.incept_date,
                         r.policy_no POLICY, r.line_cd, r.assd_no,
                         r.assd_name, r.ri_policy_no, r.ri_binder_no,
                         (  (  (r.gross_prem_amt + NVL (r.prem_vat, 0))
                             - (r.ri_comm_exp + NVL (r.comm_vat, 0))
                            )
                          / r.currency_rt
                         ) net_premium,
                         r.iss_cd || '-' || r.prem_seq_no invoice_no,
                         r.policy_id, r.currency_rt, c.currency_desc
                    FROM giac_ri_stmt_ext r, giis_currency c
                   WHERE r.user_id = p_user
                     AND (r.gross_prem_amt - r.ri_comm_exp) <> 0
                     AND r.ri_cd = NVL (p_ri_cd, r.ri_cd)
                     AND r.line_cd = NVL (p_line_cd, r.line_cd)
                     AND r.currency_cd = c.main_currency_cd
--                     AND check_user_per_line2(NVL(p_line_cd,r.line_cd), r.iss_cd, 'GIACS121', p_user) = 1             --commented out by gab 09.24.2015
--                     AND check_user_per_iss_cd_acctg2(p_line_cd, r.iss_cd, 'GIACS121', p_user) = 1
                     AND r.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user)))  -- added by gab 09.24.2015
                ORDER BY r.ri_cd, r.ri_name, r.policy_no)
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_name := i.ri_name;
         v_rec.address := i.address;
         v_rec.currency_desc := i.currency_desc;
         v_rec.currency_rt := i.currency_rt;
         v_rec.line_name := i.line_name;
         v_rec.POLICY := i.POLICY;
         v_rec.incept_date := i.incept_date;
         v_rec.invoice_no := i.invoice_no;
         v_rec.assd_name := i.assd_name;
         v_rec.ri_policy_no := i.ri_policy_no;
         v_rec.ri_binder_no := i.ri_binder_no;
         v_rec.net_premium := i.net_premium;

         FOR z IN (SELECT prem_warr_tag
                     FROM gipi_polbasic
                    WHERE policy_id = i.policy_id)
         LOOP
            v_rec.prem_warr_tag := z.prem_warr_tag;
            EXIT;
         END LOOP;

         FOR y IN (SELECT param_value_v
                     FROM giac_parameters
                    WHERE param_name = 'RI_SOA_PWARR_TEXT')
         LOOP
            v_rec.ri_soa_text := y.param_value_v;
            EXIT;
         END LOOP;

         v_rec.multiple_sign := giacp.v ('MULTIPLE_SIGNATORY');
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.v_not_exist := 'T';
         PIPE ROW (v_rec);
      END IF;
   END populate_giacr121c;

   FUNCTION populate_giacr121c_signatory
      RETURN giacr121c_signatory_tab PIPELINED
   AS
      v_rec   giacr121c_signatory_type;
   BEGIN
      FOR i IN (SELECT c.signatory, c.designation, b.label
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND b.signatory_id = c.signatory_id
                   AND a.report_id = 'GIACR121')
      LOOP
         v_rec.signatory := i.signatory;
         v_rec.designation := i.designation;
         v_rec.label := i.label;
         PIPE ROW (v_rec);
      END LOOP;
   END populate_giacr121c_signatory;

   FUNCTION populate_giacr121c_variables
      RETURN giacr121c_variables_tab PIPELINED
   AS
      v_rec   giacr121c_variables_type;
   BEGIN
      FOR i IN (SELECT c.signatory, c.designation, b.label
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND b.signatory_id = c.signatory_id
                   AND a.report_id = 'GIACR121')
      LOOP
         v_rec.signatory := i.signatory;
         v_rec.designation := i.designation;
         v_rec.label := i.label;
         EXIT;
      END LOOP;

      PIPE ROW (v_rec);
   END populate_giacr121c_variables;
END giacr121c_pkg;
/


