CREATE OR REPLACE PACKAGE CPI.giiss030_pkg
AS
   TYPE rec_type IS RECORD (
      ri_cd              VARCHAR2 (6),
      local_foreign_sw   giis_reinsurer.local_foreign_sw%TYPE,
      ri_status_cd       giis_reinsurer.ri_status_cd%TYPE,
      ri_sname           giis_reinsurer.ri_sname%TYPE,
      ri_name            giis_reinsurer.ri_name%TYPE,
      mail_address1      giis_reinsurer.mail_address1%TYPE,
      mail_address2      giis_reinsurer.mail_address2%TYPE,
      mail_address3      giis_reinsurer.mail_address3%TYPE,
      bill_address1      giis_reinsurer.bill_address1%TYPE,
      bill_address2      giis_reinsurer.bill_address2%TYPE,
      bill_address3      giis_reinsurer.bill_address3%TYPE,
      phone_no           giis_reinsurer.phone_no%TYPE,
      fax_no             giis_reinsurer.fax_no%TYPE,
      telex_no           giis_reinsurer.telex_no%TYPE,
      contact_pers       giis_reinsurer.contact_pers%TYPE,
      attention          giis_reinsurer.attention%TYPE,
      int_tax_rt         giis_reinsurer.int_tax_rt%TYPE,
      pres_and_xos       giis_reinsurer.pres_and_xos%TYPE,
      liscence_no        giis_reinsurer.liscence_no%TYPE,
      max_line_net_ret   giis_reinsurer.max_line_net_ret%TYPE,
      max_net_ret        giis_reinsurer.max_net_ret%TYPE,
      tot_asset          giis_reinsurer.tot_asset%TYPE,
      tot_liab           giis_reinsurer.tot_liab%TYPE,
      tot_net_worth      giis_reinsurer.tot_net_worth%TYPE,
      capital_struc      giis_reinsurer.capital_struc%TYPE,
      ri_type            giis_reinsurer.ri_type%TYPE,
      eff_date           VARCHAR2 (50),
      expiry_date        VARCHAR2 (50),
      user_id            giis_reinsurer.user_id%TYPE,
      last_update        VARCHAR2 (50),
      remarks            giis_reinsurer.remarks%TYPE,
      cp_no              giis_reinsurer.cp_no%TYPE,
      sun_no             giis_reinsurer.sun_no%TYPE,
      smart_no           giis_reinsurer.smart_no%TYPE,
      globe_no           giis_reinsurer.globe_no%TYPE,
      input_vat_rate     giis_reinsurer.input_vat_rate%TYPE,
      ri_tin             giis_reinsurer.ri_tin%TYPE,
      facilities         VARCHAR2 (32000),
      ri_status_desc     giis_ri_status.status_desc%TYPE,
      ri_type_desc       giis_reinsurer_type.ri_type_desc%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE mobile_no_type IS RECORD (
      MESSAGE     VARCHAR2 (200),
      def_check   NUMBER (1)
   );

   TYPE mobile_no_tab IS TABLE OF mobile_no_type;

   FUNCTION get_rec_list (
      p_ri_cd      giis_reinsurer.ri_cd%TYPE,
      p_ri_sname   giis_reinsurer.ri_sname%TYPE,
      p_ri_name    giis_reinsurer.ri_name%TYPE
   )
      RETURN rec_tab PIPELINED;

   FUNCTION validate_mobile_prefix (p_field VARCHAR2)
      RETURN NUMBER;

   FUNCTION validate_mobile_no (
      p_param   IN   VARCHAR2,
      p_field   IN   VARCHAR2,
      p_ctype   IN   VARCHAR2
   )
      RETURN mobile_no_tab PIPELINED;

   FUNCTION get_max_ri_cd
      RETURN NUMBER;

   PROCEDURE val_add_rec (p_ri_name giis_reinsurer.ri_name%TYPE);

   PROCEDURE set_rec (p_rec giis_reinsurer%ROWTYPE);
END;
/


