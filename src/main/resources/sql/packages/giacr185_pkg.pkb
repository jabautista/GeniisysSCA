CREATE OR REPLACE PACKAGE BODY CPI.giacr185_pkg
AS
    /*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.09.2013
    **  Reference By : GIACR185 -  Unreleased Checks
    */
   FUNCTION get_details (
      p_bank_cd        VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_branch_cd      VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_count   NUMBER := 0;  -- added by Kris 10.11.2013 to return company name and address when no records found.
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
         v_list.cut_off_date := 'As of ' ||
            TO_CHAR (TO_DATE (p_cut_off_date, 'MM-DD-YYYY'),
                     'fmMonth DD, YYYY'
                    );
      END;

      FOR i IN
         (SELECT   a.posting_date date_posted, b.branch_name "BRANCH",
                   b.branch_cd, e.check_pref_suf, LPAD (e.check_no, 10, '0') check_no2, c.dv_pref, LPAD (c.dv_no, 10, '0') dv_no2, --Dren Niebres 05.03.2016 SR-5355            
                   c.dv_pref || '-' || LPAD (c.dv_no, 10, '0') dv_no,
                   c.dv_date dv_date, d.bank_name "BANK",
                   e.check_date check_date,
                   e.check_pref_suf || '-' || e.check_no check_no,
                   e.amount check_amount, e.payee payee,
                   f.bank_acct_no "BANK_ACCOUNT_NO", 
                   g.rv_meaning --SR19642 Lara 07092015
              FROM giac_acctrans a,
                   giac_branches b,
                   giac_disb_vouchers c,
                   giac_banks d,
                   giac_chk_disbursement e,
                   giac_bank_accounts f,
                   cg_ref_codes g --SR19642 Lara 07092015
             WHERE a.tran_id = c.gacc_tran_id
               AND b.branch_cd = c.gibr_branch_cd
               AND c.gacc_tran_id = e.gacc_tran_id
               AND d.bank_cd = f.bank_cd
               AND f.bank_cd = e.bank_cd
               AND f.bank_acct_cd = e.bank_acct_cd
               AND a.gfun_fund_cd = b.gfun_fund_cd
               --AND e.check_stat = 2 --SR19642 Lara 07092015
               AND g.rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT'   
               AND e.check_stat LIKE g.rv_low_value 
               AND e.check_stat IN (2, 3)  --end SR19642
               AND e.bank_cd = NVL (p_bank_cd, e.bank_cd)
               AND e.bank_acct_cd = NVL (p_bank_acct_cd, e.bank_acct_cd)
               AND TRUNC (e.check_date) <=
                                        TO_DATE (p_cut_off_date, 'MM-DD-YYYY')
               AND b.branch_cd =
                      DECODE
                          (p_branch_cd,
                           NULL, DECODE
                                   (check_user_per_iss_cd_acctg (NULL,
                                                                 b.branch_cd,
                                                                 'GIACS184'
                                                                ),
                                    1, b.branch_cd,
                                    NULL
                                   ),
                           p_branch_cd
                          )
               AND (   NOT EXISTS (
                          SELECT 'x'
                            FROM giac_chk_release_info g
                           WHERE e.gacc_tran_id = g.gacc_tran_id
                             AND e.item_no = g.item_no)
                    OR EXISTS (
                          SELECT 'x'
                            FROM giac_chk_release_info h
                           WHERE e.gacc_tran_id = h.gacc_tran_id
                             AND e.item_no = h.item_no
                             AND TRUNC (h.check_release_date) >
                                        TO_DATE (p_cut_off_date, 'MM-DD-YYYY'))
                   )
          ORDER BY b.branch_name,
                   d.bank_name,
                   f.bank_acct_no,
                   e.check_pref_suf,
                   e.check_date,
                   e.check_no)
      LOOP
         v_count := 1;
         v_list.branch_cd := i.branch_cd; --Dren Niebres 05.03.2016 SR-5355
         v_list.branch := i.branch;
         v_list.bank := i.bank;
         v_list.bank_account_no := i.bank_account_no;
         v_list.date_posted := i.date_posted;
         v_list.dv_no := i.dv_no;
         v_list.dv_prefix := i.dv_pref; --Dren Niebres 05.03.2016 SR-5355
         v_list.dv_no2 := i.dv_no2; --Dren Niebres 05.03.2016 SR-5355                  
         v_list.dv_date := i.dv_date;
         v_list.check_date := i.check_date;
         v_list.check_no := i.check_no;
         v_list.check_prefix := i.check_pref_suf; --Dren Niebres 05.03.2016 SR-5355
         v_list.check_no2 := i.check_no2; --Dren Niebres 05.03.2016 SR-5355         
         v_list.payee := i.payee;
         v_list.check_amount := i.check_amount;
         v_list.check_status := i.rv_meaning; --SR19642 Lara 07092015
         PIPE ROW (v_list);
      END LOOP;

      IF v_count = 0 THEN
        PIPE ROW (v_list);
      END IF;
      
      RETURN;
   END get_details;
END giacr185_pkg;
/
