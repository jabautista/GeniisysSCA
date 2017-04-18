CREATE OR REPLACE PACKAGE BODY CPI.giacr224_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 06.13.2013
    **  Reference By : GIACR224 - STATEMENT OF ACCOUNTS
    */
   FUNCTION get_details (p_user VARCHAR2, p_ri_cd NUMBER, p_line_cd VARCHAR2)
      RETURN get_details_tab PIPELINED
   IS
      v_list     get_details_type;
      v_header   giac_parameters.param_value_v%TYPE := giacp.v ('GIACR121_HEADER');
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      v_list.mult_signatory := giacp.v ('MULTIPLE_SIGNATORY');

      IF v_header = 'Y'
      THEN
         BEGIN
            SELECT param_value_v
              INTO v_list.cf_company
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.cf_com_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         END;
      ELSE
         v_list.cf_company := NULL;
         v_list.cf_com_address := NULL;
      END IF;

      BEGIN
         v_list.report_title := giacp.v ('GIACR224_TITLE');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.report_title :=
                              '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.report_title :=
                      '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
      END;

      BEGIN
         v_list.report_subtitle := giacp.v ('GIACR224_SUBTITLE');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.report_subtitle :=
                           '(NO EXISTING REPORT SUBTITLE IN GIAC_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.report_subtitle :=
                   '(TOO MANY VALUES FOR REPORT SUBTITLE IN GIAC_PARAMETERS)';
      END;

      BEGIN
         FOR abc IN (SELECT c.signatory SIGN, c.designation desig,
                            b.label label
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GIACR224'
                        AND a.line_cd IS NULL)
         LOOP
            v_list.signatory := abc.SIGN;
            v_list.designation := abc.desig;
            v_list.label := abc.label;
            EXIT;
         END LOOP;
      END;

      BEGIN
         FOR i IN (SELECT c.signatory, c.designation, b.label
                     FROM giac_documents a,
                          giac_rep_signatory b,
                          giis_signatory_names c
                    WHERE a.report_no = b.report_no
                      AND b.signatory_id = c.signatory_id
                      AND a.report_id = 'GIACR224')
         LOOP
            v_list.signatory := i.signatory;
            v_list.designation := i.designation;
            v_list.label := i.label;
         END LOOP;
      END;

      FOR i IN (SELECT   a.ri_cd, a.ri_name, a.bill_address address,
                         a.line_name || ':' line_name, a.incept_date,
                         a.policy_no POLICY, a.line_cd, a.assd_no,
                         a.assd_name, a.ri_policy_no, a.ri_binder_no,
                         c.prem_amt * c.currency_rt prem_amt,
                         c.tax_amt * c.currency_rt tax_amt,
                         c.ri_comm_amt * c.currency_rt ri_comm_amt,
                         c.ri_comm_vat * c.currency_rt ri_comm_vat,
                           (  (c.prem_amt + NVL (c.tax_amt, 0))
                            - (c.ri_comm_amt + NVL (c.ri_comm_vat, 0))
                           )
                         * c.currency_rt net_premium,
                         a.iss_cd || '-' || a.prem_seq_no invoice_no,
                         b.collection_amt,
                           (  (  (c.prem_amt + NVL (c.tax_amt, 0))
                               - (c.ri_comm_amt + NVL (c.ri_comm_vat, 0))
                              )
                            - (NVL (b.collection_amt, 0) / c.currency_rt)
                           )
                         * c.currency_rt balance
                    FROM giac_ri_stmt_ext a,
                         gipi_invoice c,
                         (SELECT   v.b140_iss_cd, v.a180_ri_cd,
                                   v.b140_prem_seq_no, v.inst_no,
                                   SUM (v.collection_amt) collection_amt
                              FROM giac_inwfacul_prem_collns v,
                                   giac_acctrans w
                             WHERE v.gacc_tran_id + 0 = w.tran_id
                               AND w.tran_flag <> 'D'
                               AND v.gacc_tran_id > 0
                               AND NOT EXISTS (
                                      SELECT x.gacc_tran_id
                                        FROM giac_reversals x,
                                             giac_acctrans y
                                       WHERE x.reversing_tran_id = y.tran_id
                                         AND y.tran_flag <> 'D'
                                         AND x.gacc_tran_id = v.gacc_tran_id)
                          GROUP BY v.b140_iss_cd,
                                   v.a180_ri_cd,
                                   v.b140_prem_seq_no,
                                   v.inst_no) b
                   WHERE a.ri_cd = b.a180_ri_cd(+)
                     AND a.iss_cd = b.b140_iss_cd(+)
                     AND a.prem_seq_no = b.b140_prem_seq_no(+)
                     AND a.inst_no = b.inst_no(+)
                     AND a.user_id = p_user
                     AND (a.gross_prem_amt - a.ri_comm_exp) <> 0
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.iss_cd = c.iss_cd(+)
                     AND a.prem_seq_no = c.prem_seq_no(+)
--                     AND check_user_per_line2(NVL(p_line_cd,line_cd), a.iss_cd, 'GIACS121', p_user) = 1 --commented out by gab 09.24.2015
--                     AND check_user_per_iss_cd_acctg2(p_line_cd, a.iss_cd, 'GIACS121', p_user) = 1
                     AND a.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user)))-- added by gab 09.24.2015
                ORDER BY a.ri_cd, a.line_cd)
      LOOP
         v_not_exist := FALSE;
         v_list.ri_cd := i.ri_cd;
         v_list.ri_name := i.ri_name;
         v_list.address := i.address;
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.assd_no := i.assd_no; -- added by Daniel Marasigan SR 5347 07.05.2016
         v_list.assd_name := i.assd_name;
         v_list.ri_binder_no := i.ri_binder_no;
         v_list.POLICY := i.POLICY;
         v_list.ri_policy_no := i.ri_policy_no;
         v_list.prem_amt := i.prem_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.ri_comm_amt := i.ri_comm_amt;
         v_list.ri_comm_vat := i.ri_comm_vat;
         v_list.net_premium := i.net_premium;
         v_list.collection_amt := i.collection_amt;
         v_list.balance := i.balance;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.v_not_exist := 'TRUE';
         PIPE ROW (v_list);
      END IF;
      RETURN;
   END get_details;

   FUNCTION get_multiple_signatory
      RETURN get_multiple_signatory_tab PIPELINED
   IS
      v_list   get_multiple_signatory_type;
   BEGIN
      v_list.mult_signatory := giacp.v ('MULTIPLE_SIGNATORY');

      FOR i IN (SELECT c.signatory, c.designation, b.label
                  FROM giac_documents a,
                       giac_rep_signatory b,
                       giis_signatory_names c
                 WHERE a.report_no = b.report_no
                   AND b.signatory_id = c.signatory_id
                   AND a.report_id = 'GIACR224')
      LOOP
         v_list.signatory := i.signatory;
         v_list.designation := i.designation;
         v_list.label := i.label;
          PIPE ROW (v_list);
      END LOOP;
   END get_multiple_signatory;
END giacr224_pkg;
/
