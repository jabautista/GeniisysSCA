CREATE OR REPLACE PACKAGE BODY CPI.giacr121_pkg
AS
   FUNCTION cf_2formula
      RETURN CHAR
   IS
      v_title   VARCHAR2 (100);
   BEGIN
      v_title := giacp.v ('GIACR121_TITLE');
      RETURN (v_title);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
      WHEN TOO_MANY_ROWS
      THEN
         v_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
   END;

   FUNCTION cf_2formula0007
      RETURN CHAR
   IS
      v_date_label   VARCHAR2 (100);
   BEGIN
      v_date_label := giacp.v ('GIACR121_DATE_LABEL');
      RETURN (v_date_label);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_date_label := '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
      WHEN TOO_MANY_ROWS
      THEN
         v_date_label :=
                        '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
   END;

   FUNCTION populate_giacr121 (
      p_user        VARCHAR2,
      p_ri_cd       VARCHAR2,
      p_line_cd     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_cut_off     VARCHAR2
   )
      RETURN giacr121_tab PIPELINED
   AS
      v_rec         giacr121_type;
      v_from_date   DATE          := TO_DATE (p_from_date, 'MM/DD/YYYY');
      v_to_date     DATE          := TO_DATE (p_to_date, 'MM/DD/YYYY');
      v_cut_off     DATE          := TO_DATE (p_cut_off, 'MM/DD/YYYY');
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      FOR f IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
        v_rec.company_name := f.param_value_v;
        EXIT;
      END LOOP;

      FOR h IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_ADDRESS')
      LOOP
        v_rec.company_address := h.param_value_v;
        EXIT;
      END LOOP;

      v_rec.title := cf_2formula;
      v_rec.date_from := TO_CHAR (v_from_date, 'fmMonth DD, YYYY');
      v_rec.date_to := TO_CHAR (v_to_date, 'fmMonth DD, YYYY');
      v_rec.cut_off := TO_CHAR (v_cut_off, 'fmMonth DD, YYYY');
      v_rec.date_label := cf_2formula0007;
   
      FOR i IN (SELECT   ri_cd, ri_name, bill_address address,
                         line_name || ':' line_name, incept_date,
                         policy_no POLICY, line_cd, assd_no, assd_name,
                         ri_policy_no, ri_binder_no,
                         (  (gross_prem_amt + NVL (prem_vat, 0))
                          - (ri_comm_exp + NVL (comm_vat, 0))
                         ) net_premium,
                         iss_cd || '-' || prem_seq_no invoice_no, policy_id
                    FROM giac_ri_stmt_ext
                   WHERE user_id = p_user
                     AND (gross_prem_amt - ri_comm_exp) <> 0
                     AND ri_cd = NVL (p_ri_cd, ri_cd)
                     AND line_cd = NVL (p_line_cd, line_cd)
--                     AND check_user_per_line2(NVL(p_line_cd,line_cd), iss_cd, 'GIACS121', p_user) = 1             --commented out by gab 09.24.2015
--                     AND check_user_per_iss_cd_acctg2(p_line_cd, iss_cd, 'GIACS121', p_user) = 1
                     AND iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user)))-- added by gab 09.24.2015
                ORDER BY ri_cd, ri_name, policy_no)
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_cd := i.ri_cd; --CarloR SR-5346 06.28.2016
         v_rec.ri_name := i.ri_name;
         v_rec.ri_address := i.address;
         v_rec.line_cd := i.line_cd; --CarloR SR-5346 06.28.2016
         v_rec.line_name := i.line_name;
         v_rec.POLICY := i.POLICY;
         v_rec.incept_date := i.incept_date;
         v_rec.invoice_no := i.invoice_no;
         v_rec.assd_no := i.assd_no; --CarloR SR-5346 06.28.2016
         v_rec.assd_name := i.assd_name;
         v_rec.ri_policy_no := i.ri_policy_no;
         v_rec.ri_binder_no := i.ri_binder_no;
         v_rec.net_premium := i.net_premium;

         FOR n IN (SELECT param_value_v
                     FROM giac_parameters
                    WHERE param_name = 'RI_SOA_PWARR_TEXT')
         LOOP
            v_rec.ri_soa_text := n.param_value_v;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
      
      IF v_not_exist
      THEN
         v_rec.v_not_exist := 'TRUE';
         PIPE ROW (v_rec);
      END IF;
   END populate_giacr121;

   FUNCTION giacr121_footer1
      RETURN giacr121_footer_tab1 PIPELINED
   AS
      v_rec   giacr121_footer_type1;
   BEGIN
      FOR z IN (SELECT c.signatory, c.designation, b.label
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND b.signatory_id = c.signatory_id
                   AND a.report_id = 'GIACR121')
      LOOP
         v_rec.signatory := z.signatory;
         v_rec.designation := z.designation;
         v_rec.v_label := z.label;
         PIPE ROW (v_rec);
      END LOOP;
   END giacr121_footer1;

   FUNCTION giacr121_footer2
      RETURN giacr121_footer_tab2 PIPELINED
   AS
      v_rec   giacr121_footer_type2;
   BEGIN
      FOR abc IN (SELECT c.signatory SIGN, c.designation desig,
                         b.label label
                    FROM giac_documents a,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = 'GIACR121'
                     AND b.signatory_id = c.signatory_id
                     AND a.line_cd IS NULL)
      LOOP
         v_rec.signtry := abc.SIGN;
         v_rec.dsgnation := abc.desig;
         v_rec.text := abc.label;
         EXIT;
      END LOOP;

      v_rec.flag := giacp.v ('MULTIPLE_SIGNATORY');
      PIPE ROW (v_rec);
   END giacr121_footer2;
END giacr121_pkg;
/


