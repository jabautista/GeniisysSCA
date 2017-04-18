CREATE OR REPLACE PACKAGE BODY CPI.GIACR235A_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 03.11.2013
    **  Reference By : GIACR235A_PKG - EXCEPTION REPORT FOR PRINTED OFFICIAL RECEIPTS
    */
   FUNCTION get_details (
        P_FROM_DATE         DATE,
        P_TO_DATE           DATE,
        P_ISS_CD            giis_issource.iss_cd%TYPE,
        P_USER_ID       giis_users.user_id%TYPE
   )
      RETURN get_details_tab PIPELINED
   IS
      v_detail   get_details_type;
      v_print  BOOLEAN := TRUE;   --added by Gzelle 08122014
   BEGIN
      v_detail.company_name      := giisp.v ('COMPANY_NAME');       --moved here by Gzelle 08122014
      v_detail.company_address   := giisp.v ('COMPANY_ADDRESS');
      
      FOR i IN (SELECT   a.gacc_tran_id tran_id, a.or_date or_date,
                                 a.gibr_branch_cd branch_cd,
                                 a.cashier_cd cashier_cd,
                                 or_pref_suf || '-' || or_no or_no,
                                 a.payor payor, a.particulars particulars,
                                 SUM (c.debit_amt) debit_amt,
                                 SUM (c.credit_amt) credit_amt
                            FROM giac_acct_entries c,
                                 giac_acctrans b,
                                 giac_order_of_payts a
                           WHERE a.gacc_tran_id = b.tran_id
                             AND b.tran_id = c.gacc_tran_id
                             AND b.tran_flag = 'O'
                             AND a.or_flag = 'P'
                             AND a.gibr_branch_cd =
                                              NVL (p_iss_cd, a.gibr_branch_cd)
                             AND TRUNC (tran_date) BETWEEN p_from_date
                                                       AND p_to_date
                             AND check_user_per_iss_cd_acctg2(NULL, a.gibr_branch_cd, 'GIACS235', p_user_id) = 1
                        GROUP BY a.gacc_tran_id,
                                 a.or_date,
                                 a.gibr_branch_cd,
                                 a.cashier_cd,
                                 or_pref_suf,
                                 or_no,
                                 a.payor,
                                 a.particulars
                          HAVING SUM (debit_amt) <> SUM (credit_amt)
                        ORDER BY or_no)
      LOOP
         v_print                    := FALSE;     --added by Gzelle 08122014
         v_detail.tran_id           := i.tran_id;
         v_detail.or_no             := i.or_no;
         v_detail.or_no_2           := i.or_no;
         v_detail.or_date           := TO_CHAR (i.or_date, 'MM-DD-RRRR');
         v_detail.payor             := i.payor;
         v_detail.particulars       := i.particulars;
         v_detail.debit_amt         := i.debit_amt;
         v_detail.credit_amt        := i.credit_amt;
         PIPE ROW (v_detail);
      END LOOP;

      IF v_print        --added by Gzelle 08122014
      THEN
         v_detail.dummy := 'T';
         PIPE ROW (v_detail);
      END IF;      

      RETURN;
   END get_details;
   
   FUNCTION get_gl_account (
        P_TRAN_ID       giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN get_gl_account_tab PIPELINED
   IS
      v_detail   get_gl_account_type;
   BEGIN
      FOR i IN (SELECT   c.gacc_tran_id tran_id,
                                    d.gl_acct_category
                                 || '-'
                                 || LTRIM (d.gl_control_acct)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_1)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_2)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_3)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_4)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_5)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_6)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_7) gl_acct,
                                 d.gl_acct_name gl_acct_name,
                                 SUM (c.debit_amt) debit_amt,
                                 SUM (c.credit_amt) credit_amt
                            FROM giac_acct_entries c, giac_chart_of_accts d
                           WHERE c.gl_acct_id = d.gl_acct_id
                             AND c.gacc_tran_id = p_tran_id
                        GROUP BY c.gacc_tran_id,
                                    d.gl_acct_category
                                 || '-'
                                 || LTRIM (d.gl_control_acct)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_1)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_2)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_3)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_4)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_5)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_6)
                                 || '-'
                                 || LTRIM (d.gl_sub_acct_7),
                                 d.gl_acct_name)
      LOOP
         v_detail.tran_id           := i.tran_id;
         v_detail.gl_acct           := i.gl_acct;
         v_detail.gl_acct_name      := i.gl_acct_name;
         v_detail.debit_amt         := i.debit_amt;
         v_detail.credit_amt        := i.credit_amt;
         PIPE ROW (v_detail);
      END LOOP;

      

      RETURN;
   END get_gl_account;
   
END GIACR235A_PKG;
/


