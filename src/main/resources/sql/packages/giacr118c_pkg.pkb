CREATE OR REPLACE PACKAGE BODY CPI.giacr118c_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.04.2013
    **  Reference By : GIACR118B -  DISBURSEMENT/PURCHASE REGISTER
    */
   FUNCTION get_details (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_count  NUMBER := 0;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      BEGIN
         IF p_post_tran_toggle = 'P'
         THEN
            v_list.post_tran := 'Based on Posting Date';
         ELSE
            IF p_dv_check_toggle = 'D'
            THEN
               v_list.post_tran := 'Based on Transaction Date (DV Date)';
            ELSIF p_dv_check_toggle = 'P'
            THEN
               v_list.post_tran :=
                               'Based on Transaction Date (Check Print Date)';
            ELSE
               v_list.post_tran := 'Based on Transaction Date (Check Date)';
            END IF;
         END IF;
      END;

      BEGIN
         IF p_date = p_date2
         THEN
            v_list.top_date :=
                 TO_CHAR (TO_DATE (p_date, 'MM/DD/YYYY'), 'fmMonth DD, YYYY');
         ELSE
            v_list.top_date :=
                  'From '
               || TO_CHAR (TO_DATE (p_date, 'MM/DD/YYYY'), 'fmMonth DD, YYYY')
               || ' to '
               || TO_CHAR (TO_DATE (p_date2, 'MM/DD/YYYY'),
                           'fmMonth DD, YYYY');
         END IF;
      END;

      FOR i IN
         (SELECT   TRUNC (DECODE (p_post_tran_toggle,
                                  'P', b.posting_date,
                                  'T', DECODE (p_dv_check_toggle,
                                               'D', a.dv_date,
                                               'C', g.check_date,
                                               'P', g.check_print_date
                                              )
                                 )
                         ) pdc_date,
                   a.gacc_tran_id, a.gibr_branch_cd,
                   a.dv_pref || '-' || LPAD (a.dv_no, 10, '0') ref_no, f.tin,
                   a.payee vendor, a.particulars,
                   SUM (e.debit_amt - e.credit_amt) amount, 0 discount
              FROM giac_disb_vouchers a,
                   giac_acctrans b,
                   giac_payt_requests_dtl c,
                   giac_payt_requests d,
                   giac_acct_entries e,
                   giis_payees f,
                   giac_chk_disbursement g
             WHERE a.gacc_tran_id = b.tran_id
               AND a.gacc_tran_id = c.tran_id
               AND c.gprq_ref_id = d.ref_id
               AND a.gacc_tran_id = e.gacc_tran_id
               AND c.payee_class_cd = f.payee_class_cd
               AND c.payee_cd = f.payee_no
               AND a.gacc_tran_id = g.gacc_tran_id
               AND b.tran_flag <> 'D'
               AND a.gibr_branch_cd = NVL (p_branch, a.gibr_branch_cd)
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                a.gibr_branch_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1 */--replaced by codes below by pjsantos 11/14/2016 for optimization. -- function added by Kris 01.07.2014
                AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = a.gibr_branch_cd)  
                --pjsantos end
               AND TRUNC (DECODE (p_post_tran_toggle,
                                  'P', b.posting_date,
                                  'T', DECODE (p_dv_check_toggle,
                                               'D', a.dv_date,
                                               'C', g.check_date,
                                               'P', g.check_print_date
                                              )
                                 )
                         ) BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                               AND TO_DATE (p_date2, 'MM/DD/YYYY')
               AND EXISTS (
                      SELECT 1
                        FROM giac_eom_rep_dtl z
                       WHERE z.rep_cd = 'GIACR118C'
                         AND z.gl_acct_id = e.gl_acct_id)
               AND EXISTS (
                      SELECT 1
                        FROM giac_payt_req_docs x
                       WHERE x.document_cd = d.document_cd
                         AND x.gibr_branch_cd = d.branch_cd
                         AND x.purchase_tag = 'Y')
          GROUP BY TRUNC (DECODE (p_post_tran_toggle,
                                  'P', b.posting_date,
                                  'T', DECODE (p_dv_check_toggle,
                                               'D', a.dv_date,
                                               'C', g.check_date,
                                               'P', g.check_print_date
                                              )
                                 )
                         ),
                   a.gacc_tran_id,
                   a.gibr_branch_cd,
                   a.dv_pref || '-' || LPAD (a.dv_no, 10, '0'),
                   f.tin,
                   a.payee,
                   a.particulars
          ORDER BY 3, 1)
      LOOP
         v_count := 1;
         v_list.pdc_date := i.pdc_date;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.ref_no := i.ref_no;
         v_list.tin := i.tin;
         v_list.vendor := i.vendor;
         v_list.particulars := i.particulars;
         v_list.amount := i.amount;
         v_list.discount := i.discount;
         v_list.net_amount := 0.00;

         BEGIN
            SELECT iss_name
              INTO v_list.branch
              FROM giis_issource
             WHERE iss_cd = i.gibr_branch_cd;
         END;

         BEGIN
            FOR rec1 IN (SELECT   SUM (debit_amt - credit_amt) input_vat
                             FROM giac_modules a,
                                  giac_module_entries b,
                                  giac_acct_entries c
                            WHERE a.module_id = b.module_id
                              AND a.module_name = 'GIACS039'
                              AND b.gl_acct_category = c.gl_acct_category
                              AND b.gl_control_acct = c.gl_control_acct
                              AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                              AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                              AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                              AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                              AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                              AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                              AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                              AND c.gacc_tran_id = i.gacc_tran_id
                         GROUP BY c.gacc_tran_id)
            LOOP
               v_list.input_vat := rec1.input_vat;
            END LOOP;
         END;         
         v_list.net_amount := i.amount + v_list.input_vat;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_count = 0 THEN
        PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_details;
END giacr118c_pkg;
/


