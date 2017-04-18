CREATE OR REPLACE PACKAGE CPI.giacr185_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company        VARCHAR2 (50),
      cf_com_address    VARCHAR2 (200),
      branch_cd         giac_branches.branch_cd%TYPE, --Dren Niebres 05.03.2016 SR-5355
      branch            giac_branches.branch_name%TYPE, 
      bank              giac_banks.bank_name%TYPE,
      bank_account_no   giac_bank_accounts.bank_acct_no%TYPE,
      date_posted       giac_acctrans.posting_date%TYPE,
      dv_no             VARCHAR2 (16),
      dv_prefix         giac_disb_vouchers.dv_pref%TYPE, --Dren Niebres 05.03.2016 SR-5355
      dv_no2            VARCHAR2 (10), --Dren 05.03.2016 SR-5355      
      dv_date           giac_disb_vouchers.dv_date%TYPE,
      check_date        giac_chk_disbursement.check_date%TYPE,
      check_no          VARCHAR2 (46),
      check_prefix      giac_chk_disbursement.check_pref_suf%TYPE, --Dren Niebres 05.03.2016 SR-5355
      check_no2         VARCHAR2 (10), --Dren Niebres 05.03.2016 SR-5355  
      payee             giac_chk_disbursement.payee%TYPE,
      check_amount      giac_chk_disbursement.amount%TYPE,
      cut_off_date      VARCHAR2(50),
      check_status      cg_ref_codes.rv_meaning%TYPE --SR19642 Lara 07092015
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_bank_cd        VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_branch_cd      VARCHAR2
   ) RETURN get_details_tab PIPELINED;
   
END;
/
