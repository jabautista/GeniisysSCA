CREATE OR REPLACE PACKAGE cpi.girir001d_pkg
AS
   binder_line                giis_document.text%TYPE;
   binder_note                giis_document.text%TYPE;
   binder_hdr                 giis_document.text%TYPE;
   binder_ftr                 giis_document.text%TYPE;
   binder_for                 giis_document.text%TYPE;
   binder_confirmation        giis_document.text%TYPE;
   frps_ret                   giis_document.text%TYPE;
   user_id                    giis_document.text%TYPE;
   hide                       giis_document.text%TYPE;
   addressee                  giis_document.text%TYPE;
   addressee_confirmation     giis_document.text%TYPE;
   print_line_name            giis_document.text%TYPE;
   print_auth_sig_above       giis_document.text%TYPE;
   print_sig_refdate_across   giis_document.text%TYPE;
   binder_hdr_endt            giis_document.text%TYPE;
   binder_hdr_ren             giis_document.text%TYPE;

   PROCEDURE initialize_report_variables;

   TYPE main_type IS RECORD (
      line_name                     giis_line.line_name%TYPE,
      rv_binder_line                giis_document.text%TYPE,
      rv_print_line_name            giis_document.text%TYPE,
      rv_addressee                  giis_document.text%TYPE,
      ri_name                       giis_reinsurer.ri_name%TYPE,
      bill_address1                 giri_wfrps_ri.address1%TYPE,
      bill_address2                 giri_wfrps_ri.address2%TYPE,
      bill_address3                 giri_wfrps_ri.address3%TYPE,
      binder_date                   giri_binder.binder_date%TYPE   := SYSDATE,
      rv_binder_ftr                 giis_document.text%TYPE,
      rv_frps_ret                   giis_document.text%TYPE,
      ds_no                         VARCHAR2 (50),
      frps_no                       VARCHAR2 (50),
      user_id                       VARCHAR2 (20),
      rv_addressee_confirmation     giis_document.text%TYPE,
      company_name                  giis_parameters.param_value_v%TYPE
                                                  := giisp.v ('COMPANY_NAME'),
      rv_binder_confirmation        giis_document.text%TYPE,
      rv_print_sig_refdate_across   giis_document.text%TYPE,
      cf_for                        VARCHAR2 (2500),
      rv_binder_for                 giis_document.text%TYPE,
      rv_binder_note                giis_document.text%TYPE,
      rv_user_id                    giis_document.text%TYPE,
      signatory                     giis_signatory_names.signatory%TYPE,
      signatories                   giis_signatory_names.file_name%TYPE,
      signatory_label               giac_rep_signatory.label%TYPE,
      designation                   giis_signatory_names.designation%TYPE,
      iss_cd                        giis_issource.iss_cd%TYPE,
      rv_print_auth_sig_above       giis_document.text%TYPE,
      ri_accept_date                giri_frps_ri.ri_accept_date%TYPE,
      bndr_remarks1                 giri_frps_ri.bndr_remarks1%TYPE,
      bndr_remarks2                 giri_frps_ri.bndr_remarks2%TYPE,
      bndr_remarks3                 giri_frps_ri.bndr_remarks3%TYPE,
      remarks                       giri_frps_ri.remarks%TYPE,
      show_binder_as_no             VARCHAR2 (1)  := giisp.v ('BINDER_AS_NO'),
      ri_as_no                      giri_frps_ri.ri_as_no%TYPE,
      ri_accept_by                  giri_frps_ri.ri_accept_by%TYPE,
      frps_seq_no                   giri_frps_ri.frps_seq_no%TYPE,
      frps_yy                       giri_frps_ri.frps_yy%TYPE,
      show_vat                      VARCHAR2 (1),
      show_tax                      VARCHAR2 (1),
      other_charges                 giri_frps_ri.other_charges%TYPE,
      local_foreign_sw              giis_reinsurer.local_foreign_sw%TYPE,
      line_cd                       giis_line.line_cd%TYPE,
      menu_line_cd                  giis_line.menu_line_cd%TYPE,
      short_name                    giis_currency.short_name%TYPE,
      show_whold_vat                VARCHAR2 (1),
      ri_cd                         giis_reinsurer.ri_cd%TYPE,
      prem_tax                      giri_binder.prem_tax%TYPE,
      reverse_sw                    giri_frps_ri.reverse_sw%TYPE,
      vat_title                     giis_parameters.param_value_v%TYPE
                                        := NVL (giisp.v ('VAT_TITLE'), 'VAT'),
      prem_tax_title                giis_parameters.param_value_v%TYPE
                              := NVL (giisp.v ('PREM_TAX_TITLE'), 'PREM TAX'),
      policy_no                     VARCHAR2 (100),
      par_no                        VARCHAR2 (100),
      attention                     giis_reinsurer.attention%TYPE,
      rv_binder_hdr                 giis_document.text%TYPE,
      cf_class                      VARCHAR2 (100),
      assd_name                     giis_assured.assd_name%TYPE,
      mop_number                    VARCHAR2 (100),
      cf_property                   VARCHAR2 (100),
      show_sailing_date             VARCHAR2 (1),
      sailing_date                  VARCHAR2 (100),
      ri_term                       VARCHAR2 (50),
      endt_seq_no                   gipi_polbasic.endt_seq_no%TYPE,
      endt_no                       VARCHAR2 (100),
      sum_insured                   VARCHAR2 (100),
      your_share                    VARCHAR2 (100),
      pol_flag                      gipi_polbasic.pol_flag%TYPE,
      subline_name                  giis_subline.subline_name%TYPE,
      par_id                        gipi_parlist.par_id%TYPE
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main (p_pre_binder_id VARCHAR2, p_user_id VARCHAR2)
      RETURN main_tab PIPELINED;

   TYPE detail_type IS RECORD (
      gross_prem         NUMBER,
      ri_prem_amt        NUMBER,
      ri_comm_rt         NUMBER,
      ri_comm_amt        NUMBER,
      less_ri_comm_amt   NUMBER,
      pre_binder_id      giri_wfrps_ri.pre_binder_id%TYPE,
      line_cd            giri_frps_ri.line_cd%TYPE,
      frps_yy            giri_frps_ri.frps_yy%TYPE,
      frps_seq_no        giri_frps_ri.frps_seq_no%TYPE,
      peril_title        giri_frps_peril_grp.peril_title%TYPE,
      ri_prem_vat        giri_binder.ri_prem_vat%TYPE,
      ri_comm_vat        giri_binder.ri_comm_vat%TYPE,
      peril_comm_vat     giri_binder_peril.ri_comm_vat%TYPE,
      less_comm_vat      NUMBER,
      v_sequence         NUMBER,
      prt_flag           VARCHAR2 (2),
      ri_wholding_vat    NUMBER,
      display_peril               VARCHAR2(1),  -- jhing 03.30.2016 REPUBLICFULLWEB SR# 21773 
      cnt_disp_peril              NUMBER ,
      peril_rowno                 NUMBER 
   );

   TYPE detail_tab IS TABLE OF detail_type;

   FUNCTION get_report_details (
      p_pre_binder_id   giri_wfrps_ri.pre_binder_id%TYPE,
      p_line_cd         giri_frps_ri.line_cd%TYPE,
      p_frps_yy         giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no     giri_frps_ri.frps_seq_no%TYPE,
      p_reverse_sw      giri_frps_ri.reverse_sw%TYPE,
      p_ri_cd           giis_reinsurer.ri_cd%TYPE
   )
      RETURN detail_tab PIPELINED;
END;