CREATE OR REPLACE PACKAGE CPI.girir035_pkg
AS
   TYPE report_details_type IS RECORD (
      company_name       giis_parameters.param_value_v%TYPE,
      company_address    giis_parameters.param_value_v%TYPE,
      line_name          giis_line.line_name%TYPE,
      binder_no          VARCHAR2 (500),
      binder_number      VARCHAR2 (500),
      your_share         VARCHAR2 (500),
      prem_tax4          giri_group_binder.prem_tax%TYPE,
      binder_date5       giri_group_binder.binder_date%TYPE,
      ri_name            giis_reinsurer.ri_name%TYPE,
      bill_address11     giis_reinsurer.bill_address1%TYPE,
      bill_address22     giis_reinsurer.bill_address2%TYPE,
      bill_address33     giis_reinsurer.bill_address3%TYPE,
      attention          giis_reinsurer.attention%TYPE,
      first_paragraph    VARCHAR2 (2000),
      assd_no            gipi_parlist.assd_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      policy_no          VARCHAR2 (100),
      mop_policy_no      VARCHAR2 (100),
      endt_no            VARCHAR2 (100),
      endt_no_2          VARCHAR2 (100),
      ri_term            VARCHAR2 (100),
      sum_insured        VARCHAR2 (100),
      property           gipi_invoice.property%TYPE,
      endt_seq_no2       gipi_polbasic.endt_seq_no%TYPE,
      bndr_remarks1      giri_group_binder.bndr_remarks1%TYPE,
      bndr_remarks2      giri_group_binder.bndr_remarks2%TYPE,
      bndr_remarks3      giri_group_binder.bndr_remarks3%TYPE,
      master_bndr_id2    giri_group_binder.master_bndr_id%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      par_id             gipi_polbasic.par_id%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      dist_no            giuw_pol_dist.dist_no%TYPE,
      dsp_dist_no        VARCHAR2(100),
      dsp_frps_no        VARCHAR2(100),
      reverse_sw         giri_frps_ri.reverse_sw%TYPE,
      other_charges      giri_frps_ri.other_charges%TYPE,
      user_id            VARCHAR2 (500),
      local_foreign_sw   giis_reinsurer.local_foreign_sw%TYPE,
      reverse_date       giri_group_binder.reverse_date%TYPE,
      peril_seq_no       giri_group_binder_peril.peril_seq_no%TYPE,
      ri_prem_amt        giri_group_binder_peril.ri_prem_amt%TYPE,
      ri_comm_rt         NUMBER (5, 2),
      ri_comm_amt        giri_group_binder_peril.ri_comm_amt%TYPE,
      less_ri_comm_amt   NUMBER (12, 2),
      less_ri_comm_vat   NUMBER (12, 2),
      master_bndr_id3    giri_group_binder_peril.master_bndr_id%TYPE,
      ri_prem_vat        giri_group_binder.ri_prem_vat%TYPE,
      ri_comm_vat        giri_group_binder.ri_comm_vat%TYPE,
      ri_wholding_vat    giri_group_binder.ri_wholding_vat%TYPE,
      master_bndr_id     giri_frps_ri.master_bndr_id%TYPE,
      peril_seq_no2      giri_frps_peril_grp.peril_seq_no%TYPE,
      peril_title        giri_frps_peril_grp.peril_title%TYPE,
      gross_prem         NUMBER (18, 2),
      net_due            NUMBER (18, 2)
      ,peril_cd          giri_group_binder_peril.peril_cd%TYPE --edgar 12/02/2014
      ,total_gross_prem  giri_group_binder_peril.RI_PREM_AMT%TYPE  --edgar 12/02/2014
   );

   TYPE report_details_tab IS TABLE OF report_details_type;

   FUNCTION get_report_header (
      p_line_cd         giri_group_binder.line_cd%TYPE,
      p_binder_yy       giri_group_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_group_binder.binder_seq_no%TYPE
   )
      RETURN report_details_tab PIPELINED;

   FUNCTION get_report_dtl (
      p_master_bndr_id   giri_group_binder.master_bndr_id%TYPE,
      p_peril_seq_no     giri_frps_peril_grp.peril_seq_no%TYPE,
      p_peril_cd         giri_group_binder_peril.peril_cd%TYPE, --edgar 12/02/2014
      p_reverse_sw       giri_frps_ri.reverse_sw%TYPE
   )
      RETURN report_details_tab PIPELINED;
END girir035_pkg;
/


