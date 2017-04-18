CREATE OR REPLACE PACKAGE CPI.GIISS028_PKG
AS
   TYPE iss_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE,
      fund_cd    giac_parameters.param_value_v%TYPE
   );

   TYPE iss_tab IS TABLE OF iss_type;

   TYPE line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_tab IS TABLE OF line_type;

   TYPE tax_type IS RECORD (
      tax_cd     giac_taxes.tax_cd%TYPE,
      tax_name   giac_taxes.tax_name%TYPE,
      tax_type   giac_taxes.tax_type%TYPE
   );

   TYPE tax_tab IS TABLE OF tax_type;

   TYPE peril_type IS RECORD (
      peril_cd     giis_peril.peril_cd%TYPE,
      peril_name   giis_peril.peril_name%TYPE,
      line_cd      giis_peril.line_cd%TYPE,
      subline_cd   giis_peril.subline_cd%TYPE
   );

   TYPE peril_tab IS TABLE OF peril_type;

   TYPE place_type IS RECORD (
      place_cd   giis_issource_place.place_cd%TYPE,
      place      giis_issource_place.place%TYPE
   );

   TYPE place_tab IS TABLE OF place_type;

   TYPE tax_charges_type IS RECORD (
      iss_cd             giis_tax_charges.iss_cd%TYPE,
      line_cd            giis_tax_charges.line_cd%TYPE,
      tax_cd             giis_tax_charges.tax_cd%TYPE,
      tax_desc           giis_tax_charges.tax_desc%TYPE,
      function_name      giis_tax_charges.function_name%TYPE,
      SEQUENCE           giis_tax_charges.SEQUENCE%TYPE,
      rate               giis_tax_charges.rate%TYPE,
      tax_amount         giis_tax_charges.tax_amount%TYPE,
      eff_start_date     VARCHAR2 (50),
      eff_end_date       VARCHAR2 (50),
      dr_gl_cd           giis_tax_charges.dr_gl_cd%TYPE,
      cr_gl_cd           giis_tax_charges.cr_gl_cd%TYPE,
      dr_sub1            giis_tax_charges.dr_sub1%TYPE,
      cr_sub1            giis_tax_charges.cr_sub1%TYPE,
      tax_type           giis_tax_charges.tax_type%TYPE,
      no_rate_tag        giis_tax_charges.no_rate_tag%TYPE,
      include_tag        giis_tax_charges.include_tag%TYPE,
      incept_sw          giis_tax_charges.incept_sw%TYPE,
      primary_sw         giis_tax_charges.primary_sw%TYPE,
      expired_sw         giis_tax_charges.expired_sw%TYPE,
      peril_sw           giis_tax_charges.peril_sw%TYPE,
      pol_endt_sw        giis_tax_charges.pol_endt_sw%TYPE,
      takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE,
      tax_id             giis_tax_charges.tax_id%TYPE,
      allocation_tag     giis_tax_charges.allocation_tag%TYPE,
      remarks            giis_tax_charges.remarks%TYPE,
      user_id            giis_tax_charges.user_id%TYPE,
      last_update        VARCHAR2 (50),
      issue_date_tag     giis_tax_charges.issue_date_tag%TYPE,
      coc_charge         giis_tax_charges.coc_charge%TYPE,
	  refund_sw          giis_tax_charges.refund_sw%TYPE, --added by robert GENQA 4844 08.10.15
      max_tax_id         giis_tax_charges.tax_id%TYPE,
      max_sequence       NUMBER (5),
      v_exists           VARCHAR2 (1)
   );

   TYPE tax_charges_tab IS TABLE OF tax_charges_type;

   TYPE tax_peril_type IS RECORD (
      not_in        VARCHAR2(2000),
      iss_cd        giis_tax_charges.iss_cd%TYPE,
      line_cd       giis_tax_charges.line_cd%TYPE,
      tax_cd        giis_tax_charges.tax_cd%TYPE,
      tax_id        giis_tax_charges.tax_id%TYPE,
      peril_cd      giis_tax_peril.peril_cd%TYPE,
      peril_sw      giis_tax_peril.peril_sw%TYPE,
      peril_name    giis_peril.peril_name%TYPE,
      remarks       giis_tax_charges.remarks%TYPE,
      user_id       giis_tax_charges.user_id%TYPE,
      last_update   VARCHAR2 (50)
   );

   TYPE tax_peril_tab IS TABLE OF tax_peril_type;

   TYPE tax_issue_place_type IS RECORD (
      not_in        VARCHAR2(2000),
      iss_cd        giis_tax_charges.iss_cd%TYPE,
      line_cd       giis_tax_charges.line_cd%TYPE,
      tax_cd        giis_tax_charges.tax_cd%TYPE,
      tax_id        giis_tax_charges.tax_id%TYPE,
      place_cd      giis_tax_issue_place.place_cd%TYPE,
      rate          giis_tax_issue_place.rate%TYPE,
      user_id       giis_tax_charges.user_id%TYPE,
      last_update   VARCHAR2 (50),
      place         giis_issource_place.place%TYPE
   );

   TYPE tax_issue_place_tab IS TABLE OF tax_issue_place_type;

   TYPE tax_range_type IS RECORD (
      iss_cd          giis_tax_charges.iss_cd%TYPE,
      line_cd         giis_tax_charges.line_cd%TYPE,
      tax_cd          giis_tax_charges.tax_cd%TYPE,
      tax_id          giis_tax_charges.tax_id%TYPE,
      min_value       giis_tax_range.min_value%TYPE,
      max_value       giis_tax_range.max_value%TYPE,
      tax_amount      giis_tax_range.tax_amount%TYPE,
      user_id         giis_tax_charges.user_id%TYPE,
      min_min_value   giis_tax_range.min_value%TYPE,
      max_max_value   giis_tax_range.max_value%TYPE,
      rec_count       NUMBER (30),
      last_update     VARCHAR2 (50)
   );

   TYPE tax_range_tab IS TABLE OF tax_range_type;

   FUNCTION get_iss_list (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_line_cd     giis_line.line_cd%TYPE
   )
      RETURN iss_tab PIPELINED;

   FUNCTION get_line_list (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE
   )
      RETURN line_tab PIPELINED;

   FUNCTION get_tax_list (p_fund_cd VARCHAR2)
      RETURN tax_tab PIPELINED;

   FUNCTION get_peril_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN peril_tab PIPELINED;

   FUNCTION get_place_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN place_tab PIPELINED;

   FUNCTION get_tax_charges_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   )
      RETURN tax_charges_tab PIPELINED;

   FUNCTION get_tax_peril_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN tax_peril_tab PIPELINED;

   FUNCTION get_tax_issue_place_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN tax_issue_place_tab PIPELINED;

   FUNCTION get_tax_range_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN tax_range_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_tax_charges%ROWTYPE);

   PROCEDURE del_rec (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   );

   PROCEDURE val_del_rec (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   );

   PROCEDURE set_tax_peril_rec (p_rec giis_tax_peril%ROWTYPE);

   PROCEDURE del_tax_peril_rec (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_tax_cd     giis_tax_peril.tax_cd%TYPE,
      p_tax_id     giis_tax_peril.tax_id%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   );

   PROCEDURE set_tax_place_rec (p_rec giis_tax_issue_place%ROWTYPE);

   PROCEDURE del_tax_place_rec (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_tax_cd     giis_tax_peril.tax_cd%TYPE,
      p_tax_id     giis_tax_peril.tax_id%TYPE,
      p_place_cd   giis_tax_issue_place.place_cd%TYPE
   );

   PROCEDURE val_del_place_rec (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_place_cd   giis_tax_issue_place.place_cd%TYPE
   );

   PROCEDURE set_tax_range_rec (p_rec giis_tax_range%ROWTYPE);

   PROCEDURE del_tax_range_rec (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_tax_cd      giis_tax_peril.tax_cd%TYPE,
      p_tax_id      giis_tax_peril.tax_id%TYPE,
      p_min_value   giis_tax_range.min_value%TYPE
   );

   FUNCTION val_add_tax (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE
   )
      RETURN VARCHAR;

   FUNCTION val_date_on_add (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_start_date  VARCHAR2,
      p_end_date    VARCHAR2,
      p_tax_id      giis_tax_peril.tax_id%TYPE,
      p_tran        VARCHAR2
   )
      RETURN VARCHAR;

   PROCEDURE val_seq_on_add (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_sequence   NUMBER
   );
END GIISS028_PKG;
/


