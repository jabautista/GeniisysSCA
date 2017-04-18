CREATE OR REPLACE PACKAGE CPI.giuts026_pkg
AS
   TYPE giri_inpolbas_type IS RECORD (
      policy_id        gipi_polbasic.policy_id%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      endt_iss_cd      gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy          gipi_polbasic.endt_yy%TYPE,
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      assd_no          gipi_polbasic.assd_no%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      ri_cd            giri_inpolbas.ri_cd%TYPE,
      writer_cd        giri_inpolbas.writer_cd%TYPE,
      accept_date      giri_inpolbas.accept_date%TYPE,
      accept_no        giri_inpolbas.accept_no%TYPE,
      ref_accept_no    giri_inpolbas.ref_accept_no%TYPE,
      cpi_rec_no       giri_inpolbas.cpi_rec_no%TYPE,
      cpi_branch_cd    giri_inpolbas.cpi_branch_cd%TYPE,
      oar_print_date   giri_inpolbas.oar_print_date%TYPE,
      offer_date       giri_inpolbas.offer_date%TYPE,
      accept_by        giri_inpolbas.accept_by%TYPE,
      ri_policy_no     giri_inpolbas.ri_policy_no%TYPE,
      ri_endt_no       giri_inpolbas.ri_endt_no%TYPE,
      ri_binder_no     giri_inpolbas.ri_binder_no%TYPE,
      orig_tsi_amt     giri_inpolbas.orig_tsi_amt%TYPE,
      orig_prem_amt    giri_inpolbas.orig_prem_amt%TYPE,
      remarks          giri_inpolbas.remarks%TYPE,
      pack_accept_no   giri_inpolbas.pack_accept_no%TYPE,
      pack_policy_id   giri_inpolbas.pack_policy_id%TYPE,
      offered_by       giri_inpolbas.offered_by%TYPE,
      amount_offered   giri_inpolbas.amount_offered%TYPE,
      arc_ext_data     giri_inpolbas.arc_ext_data%TYPE,
      ri_sname         giis_reinsurer.ri_sname%TYPE,
      ri_sname2        giis_reinsurer.ri_sname%TYPE,
      policy_no        VARCHAR2 (50),
      endt_no          VARCHAR2 (100)
   );

   TYPE giri_inpolbas_tab IS TABLE OF giri_inpolbas_type;

   FUNCTION get_giri_inpolbas (
      p_user_id      giis_users.user_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN giri_inpolbas_tab PIPELINED;

   PROCEDURE update_acceptance_no (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_ri_endt_no      giri_inpolbas.ri_endt_no%TYPE,
      p_ri_policy_no    giri_inpolbas.ri_policy_no%TYPE,
      p_ri_binder_no    giri_inpolbas.ri_binder_no%TYPE,
      p_orig_tsi_amt    giri_inpolbas.orig_tsi_amt%TYPE,
      p_orig_prem_amt   giri_inpolbas.orig_prem_amt%TYPE,
      p_remarks         giri_inpolbas.remarks%TYPE,
      p_user_id         giis_users.user_id%TYPE
   );
END;
/


