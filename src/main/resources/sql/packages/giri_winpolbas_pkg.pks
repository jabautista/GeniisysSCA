CREATE OR REPLACE PACKAGE CPI.GIRI_WINPOLBAS_PKG AS

    TYPE giri_winpolbas_type IS RECORD (
        par_id            GIRI_WINPOLBAS.par_id%TYPE,
        accept_no         GIRI_WINPOLBAS.accept_no%TYPE,
        ri_cd             GIRI_WINPOLBAS.ri_cd%TYPE,
        accept_date       GIRI_WINPOLBAS.accept_date%TYPE,
        ri_policy_no      GIRI_WINPOLBAS.ri_policy_no%TYPE,
        ri_endt_no        GIRI_WINPOLBAS.ri_endt_no%TYPE,
        ri_binder_no      GIRI_WINPOLBAS.ri_binder_no%TYPE,
        writer_cd         GIRI_WINPOLBAS.writer_cd%TYPE,
        offer_date        GIRI_WINPOLBAS.offer_date%TYPE,
        accept_by         GIRI_WINPOLBAS.accept_by%TYPE,
        orig_tsi_amt      GIRI_WINPOLBAS.orig_tsi_amt%TYPE,
        orig_prem_amt     GIRI_WINPOLBAS.orig_prem_amt%TYPE,
        remarks           GIRI_WINPOLBAS.remarks%TYPE,
        ref_accept_no     GIRI_WINPOLBAS.ref_accept_no%TYPE,
        offered_by        GIRI_WINPOLBAS.offered_by%TYPE,
        amount_offered    GIRI_WINPOLBAS.amount_offered%TYPE,
        writer_cd_sname   GIIS_REINSURER.ri_sname%TYPE,
        ri_cd_sname       GIIS_REINSURER.ri_sname%TYPE 
    );
    
    TYPE giri_winpolbas_tab IS TABLE OF giri_winpolbas_type;
    
    PROCEDURE set_giri_winpolbas (
        p_par_id            GIRI_WINPOLBAS.par_id%TYPE,
        p_accept_no         GIRI_WINPOLBAS.accept_no%TYPE,
        p_ri_cd             GIRI_WINPOLBAS.ri_cd%TYPE,
        p_accept_date       GIRI_WINPOLBAS.accept_date%TYPE,
        p_ri_policy_no      GIRI_WINPOLBAS.ri_policy_no%TYPE,
        p_ri_endt_no        GIRI_WINPOLBAS.ri_endt_no%TYPE,
        p_ri_binder_no      GIRI_WINPOLBAS.ri_binder_no%TYPE,
        p_writer_cd         GIRI_WINPOLBAS.writer_cd%TYPE,
        p_offer_date        GIRI_WINPOLBAS.accept_date%TYPE,
        p_accept_by         GIRI_WINPOLBAS.accept_by%TYPE,
        p_orig_tsi_amt      GIRI_WINPOLBAS.orig_tsi_amt%TYPE,
        p_orig_prem_amt     GIRI_WINPOLBAS.orig_prem_amt%TYPE,
        p_remarks           GIRI_WINPOLBAS.remarks%TYPE,
        p_ref_accept_no     GIRI_WINPOLBAS.ref_accept_no%TYPE,
        p_offered_by        GIRI_WINPOLBAS.offered_by%TYPE,
        p_amount_offered    GIRI_WINPOLBAS.amount_offered%TYPE,
        p_cedant_update     VARCHAR2 -- bonok :: 10.03.2014
    );
    
    FUNCTION get_giri_winpolbas (p_par_id  GIRI_WINPOLBAS.par_id%TYPE)
        RETURN giri_winpolbas_tab PIPELINED;
        
    FUNCTION get_last_accept_no RETURN NUMBER;
    
    FUNCTION check_posted_binder(p_par_id gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2;
    
    FUNCTION check_invoice_exists(p_par_id gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2;
    
    PROCEDURE recreate_winvoice(
      p_par_id   gipi_parlist.par_id%TYPE
    );
      
END GIRI_WINPOLBAS_PKG;
/


