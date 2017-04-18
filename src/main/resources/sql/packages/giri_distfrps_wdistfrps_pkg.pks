CREATE OR REPLACE PACKAGE CPI.giri_distfrps_wdistfrps_pkg
AS 
    TYPE giri_distfrps_wdistfrps_type IS RECORD (
        par_id                 gipi_parlist.par_id%TYPE,
        frps_no                VARCHAR(50),
        par_no                 VARCHAR(50), 
        par_type               gipi_parlist.par_type%TYPE,  ------------------k
        policy_no              VARCHAR2(50), ----------------------k
        endorsement_no         VARCHAR2(50),
        assd_name              giis_assured.assd_name%TYPE,
        pack_policy_no         VARCHAR2(50), -----------------k
        eff_date               gipi_polbasic.eff_date%TYPE,
        expiry_date            gipi_polbasic.expiry_date%TYPE,
        dist_no                giri_distfrps.dist_no%TYPE,
        dist_seq_no            giri_distfrps.dist_seq_no%TYPE,
        tsi_amt                giri_distfrps.tsi_amt%TYPE,
        tot_fac_tsi            giri_distfrps.tot_fac_tsi%TYPE,
        ref_policy_no          gipi_polbasic.ref_pol_no%TYPE, --------------------------- k
        currency_desc          giis_currency.currency_desc%TYPE, 
        dist_flag              giuw_pol_dist.dist_flag%TYPE,
        dist_desc              VARCHAR2(50), -----------------------k
        prem_amt               giri_distfrps.prem_amt%TYPE, 
        tot_fac_prem           giri_distfrps.tot_fac_prem%TYPE
        --------spolied flag
        --------dist by tsi
    );
    
    TYPE giri_distfrps_wdistfrps_tab IS TABLE OF giri_distfrps_wdistfrps_type;

    FUNCTION get_giri_frpslist (
        p_policy_id gipi_polbasic.policy_id%TYPE
    )
        RETURN giri_distfrps_wdistfrps_tab PIPELINED;
        
END;
/


