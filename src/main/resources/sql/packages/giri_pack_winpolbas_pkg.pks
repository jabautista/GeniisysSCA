CREATE OR REPLACE PACKAGE CPI.giri_pack_winpolbas_pkg
AS
   PROCEDURE copy_pack_pol_winpolbas (
      p_pack_par_id       gipi_parlist.pack_par_id%TYPE,
      p_pack_policy_id    gipi_pack_polgenin.pack_policy_id%TYPE);

   PROCEDURE copy_pack_pol_winpolbas (
      p_pack_par_id       gipi_parlist.pack_par_id%TYPE,
      p_pack_policy_id    gipi_pack_polgenin.pack_policy_id%TYPE,
      p_iss_cd            gipi_parlist.iss_cd%TYPE);

   PROCEDURE del_giri_pack_winpolbas (
      p_pack_par_id giri_pack_winpolbas.pack_par_id%TYPE);

   PROCEDURE save_pack_winpolbas (
      p_giri_pack_winpolbas IN giri_pack_winpolbas%ROWTYPE);

   PROCEDURE giris005a_post_insert (
      p_pack_par_id gipi_parlist.pack_par_id%TYPE);

   PROCEDURE giris005a_post_update (
      p_pack_par_id      GIRI_WINPOLBAS.par_id%TYPE,
      p_ri_cd            GIRI_WINPOLBAS.ri_cd%TYPE,
      p_accept_date      GIRI_WINPOLBAS.accept_date%TYPE,
      p_ri_policy_no     GIRI_WINPOLBAS.ri_policy_no%TYPE,
      p_ri_endt_no       GIRI_WINPOLBAS.ri_endt_no%TYPE,
      p_ri_binder_no     GIRI_WINPOLBAS.ri_binder_no%TYPE,
      p_writer_cd        GIRI_WINPOLBAS.writer_cd%TYPE,
      p_offer_date       GIRI_WINPOLBAS.accept_date%TYPE,
      p_accept_by        GIRI_WINPOLBAS.accept_by%TYPE,
      p_orig_tsi_amt     GIRI_WINPOLBAS.orig_tsi_amt%TYPE,
      p_orig_prem_amt    GIRI_WINPOLBAS.orig_prem_amt%TYPE,
      p_remarks          GIRI_WINPOLBAS.remarks%TYPE,
      p_ref_accept_no    GIRI_WINPOLBAS.ref_accept_no%TYPE);

   TYPE giri_pack_winpolbas_type IS RECORD
   (
      pack_par_id       GIRI_WINPOLBAS.par_id%TYPE,
      pack_accept_no   GIRI_WINPOLBAS.accept_no%TYPE,
      ri_cd            GIRI_WINPOLBAS.ri_cd%TYPE,
      accept_date      VARCHAR2(10),
      ri_policy_no     GIRI_WINPOLBAS.ri_policy_no%TYPE,
      ri_endt_no       GIRI_WINPOLBAS.ri_endt_no%TYPE,
      ri_binder_no     GIRI_WINPOLBAS.ri_binder_no%TYPE,
      writer_cd        GIRI_WINPOLBAS.writer_cd%TYPE,
      offer_date       VARCHAR2(10),
      accept_by        GIRI_WINPOLBAS.accept_by%TYPE,
      orig_tsi_amt     GIRI_WINPOLBAS.orig_tsi_amt%TYPE,
      orig_prem_amt    GIRI_WINPOLBAS.orig_prem_amt%TYPE,
      remarks          GIRI_WINPOLBAS.remarks%TYPE,
      ref_accept_no    GIRI_WINPOLBAS.ref_accept_no%TYPE,
      ri_sname         GIIS_REINSURER.ri_sname%TYPE,
      ri_sname2        GIIS_REINSURER.ri_sname%TYPE
   );

   TYPE giri_pack_winpolbas_tab IS TABLE OF giri_pack_winpolbas_type;

   FUNCTION get_giri_pack_winpolbas (
      p_pack_par_id giri_pack_winpolbas.pack_par_id%TYPE)
      RETURN giri_pack_winpolbas_tab
      PIPELINED;
END;
/


