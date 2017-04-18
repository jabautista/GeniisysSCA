CREATE OR REPLACE PACKAGE CPI.GIPIS170_PKG
AS
   TYPE get_doc_list_type IS RECORD (
      doc_type    giis_reports.doc_type%TYPE,
      doc_type1   giis_reports.doc_type%TYPE
   );

   TYPE get_doc_list_tab IS TABLE OF get_doc_list_type;

   TYPE get_iss_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,         
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE get_iss_lov_tab IS TABLE OF get_iss_lov_type;

   TYPE get_subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE get_subline_lov_tab IS TABLE OF get_subline_lov_type;

   TYPE get_line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE get_line_lov_tab IS TABLE OF get_line_lov_type;

   TYPE get_user_lov_type IS RECORD (
      user_id     giis_users.user_id%TYPE,
      user_name   giis_users.user_name%TYPE
   );

   TYPE get_user_lov_tab IS TABLE OF get_user_lov_type;

   TYPE get_policy_endt_id_type IS RECORD (
      policy_id    gipi_polbasic.policy_id%TYPE,
      line_cd      giis_line.line_cd%TYPE,
      report_id    giis_reports.report_id%TYPE,
      extract_id   gixx_polbasic.extract_id%TYPE
   );

   TYPE get_policy_endt_id_tab IS TABLE OF get_policy_endt_id_type;

   TYPE get_binder_fnl_bndr_id_type IS RECORD (
      fnl_binder_id   giri_binder_polbasic_v.fnl_binder_id%TYPE,
      line_cd         giri_binder_polbasic_v.line_cd%TYPE,
      binder_yy       giri_binder_polbasic_v.binder_yy%TYPE,
      binder_seq_no   giri_binder_polbasic_v.binder_seq_no%TYPE,
      report_id       giis_reports.report_id%TYPE
   );

   TYPE get_binder_fnl_bndr_id_tab IS TABLE OF get_binder_fnl_bndr_id_type;

   TYPE get_marketing_quote_id_type IS RECORD (
      quote_id    gipi_quote.quote_id%TYPE,
      line_cd     gipi_quote.line_cd%TYPE,
      report_id   giis_reports.report_id%TYPE
   );

   TYPE get_marketing_quote_id_tab IS TABLE OF get_marketing_quote_id_type;

   TYPE get_quotation_quote_id_type IS RECORD (
      par_id      gipi_wpolbas.par_id%TYPE,
      line_cd     gipi_wpolbas.line_cd%TYPE,
      report_id   giis_reports.report_id%TYPE
   );

   TYPE get_quotation_quote_id_tab IS TABLE OF get_quotation_quote_id_type;

   TYPE get_covernote_par_id_type IS RECORD (
      par_id      gipi_wpolbas.par_id%TYPE,
      line_cd     gipi_wpolbas.line_cd%TYPE,
      report_id   giis_reports.report_id%TYPE
   );

   TYPE get_covernote_par_id_tab IS TABLE OF get_covernote_par_id_type;

   TYPE get_coc_serial_no_type IS RECORD (
      coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      policy_id       gipi_polbasic.policy_id%TYPE,
      item_no         gipi_item.item_no%TYPE,
      report_id       giis_reports.report_id%TYPE
   );

   TYPE get_coc_serial_no_tab IS TABLE OF get_coc_serial_no_type;

   TYPE get_invoice_ri_pol_id_type IS RECORD (
      policy_id       gipi_polbasic.policy_id%TYPE,
      line_cd         gipi_polbasic.line_cd%TYPE,
      endt_type       gipi_polbasic.endt_type%TYPE,
      pack_pol_flag   gipi_polbasic.pack_pol_flag%TYPE,
      takeup_term     gipi_polbasic.takeup_term%TYPE,
      report_id       giis_reports.report_id%TYPE
   );

   TYPE get_invoice_ri_pol_id_tab IS TABLE OF get_invoice_ri_pol_id_type;

   TYPE get_invoice_ri_type IS RECORD (
      policy_id   gipi_polbasic.policy_id%TYPE,
      line_cd     gipi_polbasic.line_cd%TYPE,
      report_id   giis_reports.report_id%TYPE
   );

   TYPE get_invoice_ri_tab IS TABLE OF get_invoice_ri_type;

   TYPE get_bonds_renewal_pol_id_type IS RECORD (
      policy_id    gipi_polbasic.policy_id%TYPE,
      line_cd      gipi_polbasic.line_cd%TYPE,
      issue_yy     gipi_polbasic.issue_yy%TYPE,
      iss_cd       gipi_polbasic.iss_cd%TYPE,
      pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      renew_no     gipi_polbasic.renew_no%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      report_id    giis_reports.report_id%TYPE
   );

   TYPE get_bonds_renewal_pol_id_tab IS TABLE OF get_bonds_renewal_pol_id_type;

   TYPE get_renewal_policy_id_type IS RECORD (
      policy_id    gipi_polbasic.policy_id%TYPE,
      line_cd      gipi_polbasic.line_cd%TYPE,
      assd_no      giis_assured.assd_no%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      par_id       gipi_polbasic.par_id%TYPE,
      report_id    giis_reports.report_id%TYPE
   );

   TYPE get_renewal_policy_id_tab IS TABLE OF get_renewal_policy_id_type;

   TYPE get_bonds_policy_pol_id_type IS RECORD (
      policy_id    gipi_polbasic.policy_id%TYPE,
      par_id       gipi_polbasic.par_id%TYPE,
      par_type     gipi_parlist.par_type%TYPE,
      line_cd      gipi_polbasic.line_cd%TYPE,
      iss_cd       gipi_polbasic.iss_cd%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      report_id    giis_reports.report_id%TYPE
   );

   TYPE get_bonds_policy_pol_id_tab IS TABLE OF get_bonds_policy_pol_id_type;

   FUNCTION populate_doc_list
      RETURN get_doc_list_tab PIPELINED;

   FUNCTION get_gipis170_iss_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN get_iss_lov_tab PIPELINED;

   FUNCTION get_gipis170_line_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN get_line_lov_tab PIPELINED;

   FUNCTION get_gipis170_su_subline_lov
      RETURN get_subline_lov_tab PIPELINED;

   FUNCTION get_gipis170_mc_subline_lov
      RETURN get_subline_lov_tab PIPELINED;

   FUNCTION get_gipis170_line_filtered_lov (
      p_iss_cd      giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_doc_type    giis_reports.doc_type%TYPE
   )
      RETURN get_line_lov_tab PIPELINED;

   FUNCTION get_gipis170_line_su_lov (
      p_iss_cd      giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_doc_type    giis_reports.doc_type%TYPE
   )
      RETURN get_line_lov_tab PIPELINED;

   FUNCTION get_gipis170_posting_user_lov
      RETURN get_user_lov_tab PIPELINED;

   PROCEDURE initialize_variables (
      p_ri       OUT   giis_parameters.param_value_v%TYPE,
      p_lc_mc    OUT   giis_parameters.param_value_v%TYPE,
      p_sc_lto   OUT   giis_parameters.param_value_v%TYPE,
      p_lc_su    OUT   giis_parameters.param_value_v%TYPE,
      p_bond     OUT   giis_line.line_name%TYPE,
      p_motor    OUT   giis_line.line_name%TYPE
   );

   FUNCTION get_policy_endt_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_p_ri          giis_parameters.param_value_v%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_user          giis_users.user_id%TYPE,
      p_date_list     VARCHAR2,
      p_pol_endt      VARCHAR2,
      p_bond          VARCHAR2,
      p_lc_su         VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_policy_endt_id_tab PIPELINED;

   FUNCTION get_binder_fnl_bndr_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_cedant        giis_reinsurer.ri_sname%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_binder_fnl_bndr_id_tab PIPELINED;

   FUNCTION get_marketing_quote_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2
   )
      RETURN get_marketing_quote_id_tab PIPELINED;

   FUNCTION get_quotation_quote_id (
      p_doc_list     giis_reports.doc_type%TYPE,
      p_assured      giis_assured.assd_name%TYPE,
      p_line         giis_line.line_name%TYPE,
      p_subline      giis_subline.subline_name%TYPE,
      p_issue        giis_issource.iss_name%TYPE,
      p_start_seq    gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq      gipi_polbasic.pol_seq_no%TYPE,
      p_start_date   VARCHAR2,
      p_end_date     VARCHAR2
   )
      RETURN get_quotation_quote_id_tab PIPELINED;

   FUNCTION get_covernote_par_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_covernote_par_id_tab PIPELINED;

   FUNCTION get_coc_serial_no (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_lc_mc         VARCHAR2,
      p_sc_lto        VARCHAR2,
      p_lto           VARCHAR2,
      p_user          VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_coc_serial_no_tab PIPELINED;

   FUNCTION get_invoice_ri_pol_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_user          giis_users.user_id%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_lc_su         VARCHAR2,
      p_bond_pol      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_invoice_ri_pol_id_tab PIPELINED;

   FUNCTION get_invoice_ri (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_cedant        giis_reinsurer.ri_sname%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_user          giis_users.user_id%TYPE,
      p_user_id       VARCHAR2
   )
      RETURN get_invoice_ri_tab PIPELINED;

   FUNCTION get_bonds_renewal_pol_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_lc_su         VARCHAR2
   )
      RETURN get_bonds_renewal_pol_id_tab PIPELINED;

   FUNCTION get_renewal_policy_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2
   )
      RETURN get_renewal_policy_id_tab PIPELINED;

   FUNCTION get_bonds_policy_pol_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_p_ri          VARCHAR2,
      p_lc_su         VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_bonds_policy_pol_id_tab PIPELINED;

   PROCEDURE delete_extract_tables (p_extract_id NUMBER);

   PROCEDURE update_pol_rec (p_policy_id gipi_polbasic.policy_id%TYPE);

   PROCEDURE update_binder (p_binder_id giri_binder.fnl_binder_id%TYPE);

   PROCEDURE update_frps (p_binder_id giri_binder.fnl_binder_id%TYPE);

   PROCEDURE update_gipi_quote (p_quote_id gipi_quote.quote_id%TYPE);

   PROCEDURE update_wpolbas (p_par_id gipi_wpolbas.par_id%TYPE);

   PROCEDURE update_item (p_policy_id gipi_item.policy_id%TYPE);

   PROCEDURE update_invoice (p_policy_id gipi_invoice.policy_id%TYPE);
END GIPIS170_PKG;
/


