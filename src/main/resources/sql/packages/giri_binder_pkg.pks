CREATE OR REPLACE PACKAGE CPI.giri_binder_pkg
AS 
   TYPE giri_binder_amts_type IS RECORD (
      ri_prem_amt       giri_binder.ri_prem_amt%TYPE,
      ri_prem_vat       giri_binder.ri_prem_vat%TYPE,
      ri_comm_amt       giri_binder.ri_comm_amt%TYPE,
      ri_comm_vat       giri_binder.ri_comm_vat%TYPE,
      ri_wholding_vat   giri_binder.ri_wholding_vat%TYPE,
      MESSAGE           VARCHAR2 (32767)
   );

   TYPE giri_binder_amts_tab IS TABLE OF giri_binder_amts_type;

   FUNCTION get_breakdown_amts (
      p_ri_cd              giri_binder.ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE,
      p_disbursement_amt   giac_outfacul_prem_payts.disbursement_amt%TYPE
   )
      RETURN giri_binder_amts_tab PIPELINED;

   PROCEDURE create_binders_giris002 (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   );

   TYPE giri_binder_posted_dtls_type IS RECORD (
      ri_name         giis_reinsurer.ri_name%TYPE,
      binder_no       VARCHAR2 (100),
      binder_date     giri_binder.binder_date%TYPE,
      ref_binder_no   giri_binder.ref_binder_no%TYPE,
      fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   );

   TYPE giri_binder_posted_dtls_tab IS TABLE OF giri_binder_posted_dtls_type;

   FUNCTION get_posted_dtls_giris026 (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE
   )
      RETURN giri_binder_posted_dtls_tab PIPELINED;

   PROCEDURE update_giri_binder_giris026 (
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE,
      p_binder_date     giri_binder.binder_date%TYPE,
      p_ref_binder_no   giri_binder.ref_binder_no%TYPE
   );

   PROCEDURE update_reverse_date_giuws013 (
      p_dist_no_old   IN   giuw_wpolicyds.dist_no%TYPE,
      p_dist_seq_no   IN   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   );
   
   PROCEDURE update_binder_flag_sw(
                p_dist_no_old   IN   giuw_wpolicyds.dist_no%TYPE,
             p_dist_seq_no   IN   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   );
   
   FUNCTION check_binder_exists (p_par_id    GIPI_WPOLBAS.par_id%TYPE)
    RETURN VARCHAR2;
    
   PROCEDURE UPDATE_REV_SWITCH_REV_DATE (p_par_id    GIPI_WPOLBAS.par_id%TYPE);
   
   PROCEDURE UPDATE_GIRI_BINDER_GIUWS016 (p_dist_no IN  GIUW_POL_DIST.dist_no%TYPE,
                                          p_par_id  IN  GIUW_POL_DIST.par_id%TYPE);
                                          
   PROCEDURE UPDATE_REVERSE_DATE_GIUTS021(p_dist_no_old    IN giuw_wpolicyds.dist_no%TYPE,
                                  p_dist_seq_no    IN giuw_wpolicyds_dtl.dist_seq_no%TYPE);
   PROCEDURE UPDATE_PRINTED_BINDER_DATE_CNT(p_fnl_binder_id IN giri_binder.fnl_binder_id%TYPE);
 
   TYPE get_fnl_binder_id_type IS RECORD (
      fnl_binder_id   giri_frps_ri.fnl_binder_id%TYPE
   );

   TYPE get_fnl_binder_id_tab IS TABLE OF get_fnl_binder_id_type;

   FUNCTION get_fnl_binder_id (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE
   )
      RETURN get_fnl_binder_id_tab PIPELINED;
      
   TYPE get_binder_details_type IS RECORD (
      line_cd        giri_binder.line_cd%TYPE,
      binder_yy      giri_binder.binder_yy%TYPE,
      binder_seq_no  giri_binder.binder_seq_no%TYPE,
      fnl_binder_id  giri_binder.fnl_binder_id%TYPE
   );

   TYPE get_binder_details_tab IS TABLE OF get_binder_details_type;

   FUNCTION get_binder_details (
      p_dist_no      giri_distfrps.dist_no%TYPE
   )
      RETURN get_binder_details_tab PIPELINED;
      
   FUNCTION get_binders(
      p_policy_id   GIRI_BINDER.policy_id%TYPE
   )
     RETURN get_binder_details_tab PIPELINED;
   
   FUNCTION check_binder_exist (
      p_policy_id     NUMBER,
      p_dist_no       NUMBER
   )
      RETURN VARCHAR;
  
END giri_binder_pkg;
/


