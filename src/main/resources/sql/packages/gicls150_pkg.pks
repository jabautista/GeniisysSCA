CREATE OR REPLACE PACKAGE CPI.gicls150_pkg
AS
   TYPE clm_payee_class_type IS RECORD (
      payee_class_cd         giis_payee_class.payee_class_cd%TYPE,
      class_desc             giis_payee_class.class_desc%TYPE,
      payee_class_tag        giis_payee_class.payee_class_tag%TYPE,
      payee_class_tag_desc   VARCHAR2 (20)
   );

   TYPE clm_payee_class_tab IS TABLE OF clm_payee_class_type;

   TYPE clm_payee_info_type IS RECORD (
      payee_class_cd       giis_payees.payee_class_cd%TYPE,
      payee_no             giis_payees.payee_no%TYPE,
      payee_last_name      giis_payees.payee_last_name%TYPE,
      payee_first_name     giis_payees.payee_first_name%TYPE,
      payee_middle_name    giis_payees.payee_middle_name%TYPE,
      tin                  giis_payees.tin%TYPE,
      mail_addr1           giis_payees.mail_addr1%TYPE,
      mail_addr2           giis_payees.mail_addr2%TYPE,
      mail_addr3           giis_payees.mail_addr3%TYPE,
      mailing_address      VARCHAR (200),
      remarks              giis_payees.remarks%TYPE,
      user_id              giis_payees.user_id%TYPE,
      ref_payee_cd         giis_payees.ref_payee_cd%TYPE,
      contact_pers         giis_payees.contact_pers%TYPE,
      designation          giis_payees.designation%TYPE,
      cp_no                giis_payees.cp_no%TYPE,
      sun_no               giis_payees.sun_no%TYPE,
      globe_no             giis_payees.globe_no%TYPE,
      smart_no             giis_payees.smart_no%TYPE,
      phone_no             giis_payees.phone_no%TYPE,
      fax_no               giis_payees.fax_no%TYPE,
      master_payee_no      giis_payees.master_payee_no%TYPE,
      master_payee_name    giis_payees.payee_last_name%TYPE,
      bank_cd              giac_banks.bank_cd%TYPE,
      bank_name            giac_banks.bank_name%TYPE,
      bank_branch          giis_payees.bank_branch%TYPE,
      bank_acct_typ        cg_ref_codes.rv_meaning%TYPE,
      bank_acct_type       giis_payees.bank_acct_type%TYPE,
      bank_acct_name       giis_payees.bank_acct_name%TYPE,
      bank_acct_no         giis_payees.bank_acct_no%TYPE,
      bank_acct_app_date   VARCHAR (200),
      bank_acct_app_tag    giis_payees.bank_acct_app_tag%TYPE,
      bank_acct_app_user   giis_payees.bank_acct_app_user%TYPE,
      allow_tag            giis_payees.allow_tag%TYPE,
      last_update          VARCHAR (200)
   );

   TYPE clm_payee_info_tab IS TABLE OF clm_payee_info_type;

   TYPE clm_master_payee_lov_type IS RECORD (
      payee_no   giis_payees.payee_no%TYPE,
      payee      giis_payees.payee_last_name%TYPE
   );

   TYPE clm_master_payee_lov_tab IS TABLE OF clm_master_payee_lov_type;

   TYPE clm_bank_acct_hstry_field_type IS RECORD (
      FIELD   giis_payee_bank_acct_hist.FIELD%TYPE
   );

   TYPE clm_bank_acct_hstry_field_tab IS TABLE OF clm_bank_acct_hstry_field_type;

   TYPE clm_bank_acct_hstry_value_type IS RECORD (
      FIELD         giis_payee_bank_acct_hist.FIELD%TYPE,
      old_value     giis_payee_bank_acct_hist.old_value%TYPE,
      new_value     giis_payee_bank_acct_hist.new_value%TYPE,
      user_id       giis_payee_bank_acct_hist.user_id%TYPE,
      last_update   VARCHAR2 (200)
   );

   TYPE clm_bank_acct_hstry_value_tab IS TABLE OF clm_bank_acct_hstry_value_type;

   TYPE validate_mobile_no_type IS RECORD (
      MESSAGE     VARCHAR2 (200),
      def_check   NUMBER (1)
   );

   TYPE validate_mobile_no_tab IS TABLE OF validate_mobile_no_type;
   
   TYPE bank_acct_dtls_type IS RECORD (
      bank_cd              giac_banks.bank_cd%TYPE,
      bank_name            giac_banks.bank_name%TYPE,
      bank_branch          giis_payees.bank_branch%TYPE,
      bank_acct_typ        cg_ref_codes.rv_meaning%TYPE,
      bank_acct_type       giis_payees.bank_acct_type%TYPE,
      bank_acct_name       giis_payees.bank_acct_name%TYPE,
      bank_acct_no         giis_payees.bank_acct_no%TYPE,
      bank_acct_app_date   VARCHAR (200),
      bank_acct_app_tag    giis_payees.bank_acct_app_tag%TYPE,
      bank_acct_app_user   giis_payees.bank_acct_app_user%TYPE
   );

   TYPE bank_acct_dtls_tab IS TABLE OF bank_acct_dtls_type;

   FUNCTION get_clm_payee_class (
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE,
      p_class_desc       giis_payee_class.class_desc%TYPE
   )
      RETURN clm_payee_class_tab PIPELINED;

   FUNCTION get_clm_payee_info (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE
   )
      RETURN clm_payee_info_tab PIPELINED;

   FUNCTION get_master_payee_lov_list (
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   )
      RETURN clm_master_payee_lov_tab PIPELINED;

   FUNCTION get_bank_acct_hstry_field (
      p_payee_class_cd   giis_payee_bank_acct_hist.payee_class_cd%TYPE,
      p_payee_no         giis_payee_bank_acct_hist.payee_no%TYPE
   )
      RETURN clm_bank_acct_hstry_field_tab PIPELINED;

   FUNCTION get_bank_acct_hstry_value (
      p_payee_class_cd   giis_payee_bank_acct_hist.payee_class_cd%TYPE,
      p_payee_no         giis_payee_bank_acct_hist.payee_no%TYPE,
      p_field            giis_payee_bank_acct_hist.FIELD%TYPE
   )
      RETURN clm_bank_acct_hstry_value_tab PIPELINED;

   FUNCTION get_bank_acct_approvals (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE
   )
      RETURN clm_payee_info_tab PIPELINED;

   FUNCTION validate_mobile_no_prefix (p_field VARCHAR2)
      RETURN NUMBER;

   FUNCTION validate_mobile_number (
      p_param   IN   VARCHAR2,
      p_field   IN   VARCHAR2,
      p_ctype   IN   VARCHAR2
   )
      RETURN validate_mobile_no_tab PIPELINED;

   PROCEDURE set_gicls150_claim_payee (p_rec giis_payees%ROWTYPE);

   PROCEDURE update_bank_acct_dtls (p_payees giis_payees%ROWTYPE);

   PROCEDURE approve_bank_acct_dtls (
      p_payee_class_cd      giis_payees.payee_class_cd%TYPE,
      p_payee_no            giis_payees.payee_no%TYPE,
      p_bank_acct_app_tag   giis_payees.bank_acct_app_tag%TYPE,
      p_user_id             giis_payees.user_id%TYPE
   );

   FUNCTION get_bank_acct_dtls (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_no         giis_payees.payee_no%TYPE
   )
      RETURN bank_acct_dtls_tab PIPELINED;
END;
/


