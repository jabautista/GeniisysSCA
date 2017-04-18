CREATE OR REPLACE PACKAGE CPI.giris027_pkg
AS
   TYPE ri_lov_type IS RECORD (
      ri_cd   giis_reinsurer.ri_cd%TYPE,
      ri_name giis_reinsurer.ri_name%TYPE
   );
   
   TYPE ri_lov_tab IS TABLE OF ri_lov_type;
   
   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED;
      
   TYPE giris027_type IS RECORD (
      line_cd        giis_line.line_cd%TYPE,
      iss_cd         giis_issource.iss_cd%TYPE,
      par_yy         gipi_parlist.par_yy%TYPE,
      par_seq_no     gipi_parlist.par_seq_no%TYPE,
      quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      par_status     gipi_parlist.par_status%TYPE,
      policy_no      VARCHAR2(100),       
      accept_date    giri_inpolbas.accept_date%TYPE,
      accept_no      giri_inpolbas.accept_no%TYPE,
      assd_no        giis_assured.assd_no%TYPE,
      assd_name      giis_assured.assd_name%TYPE,
      accept_by      giri_inpolbas.accept_by%TYPE,
      ri_cd          giis_reinsurer.ri_cd%TYPE,
      ref_accept_no  giri_inpolbas.ref_accept_no%TYPE,
      writer_cd      giri_inpolbas.writer_cd%TYPE,
      ri_name        giis_reinsurer.ri_name%TYPE,
      ri_policy_no   giri_inpolbas.ri_policy_no%TYPE,
      ri_binder_no   giri_inpolbas.ri_binder_no%TYPE,
      ri_endt_no     giri_inpolbas.ri_endt_no%TYPE,
      offer_date     giri_inpolbas.offer_date%TYPE,
      offered_by     giri_inpolbas.offered_by%TYPE,
      amount_offered giri_inpolbas.amount_offered%TYPE,
      orig_tsi_amt   giri_inpolbas.orig_tsi_amt%TYPE,
      orig_prem_amt  giri_inpolbas.orig_prem_amt%TYPE,
      remarks        giri_inpolbas.remarks%TYPE
   );      
   
   TYPE giris027_tab IS TABLE OF giris027_type;
   
   FUNCTION populate_giris027 (
      p_ri_cd VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN giris027_tab PIPELINED;
   
END;
/


