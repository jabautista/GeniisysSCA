CREATE OR REPLACE PACKAGE CPI.GIRIS015_PKG AS

    TYPE policy_frps_type IS RECORD(
        line_cd                 GIPI_POLBASIC.line_cd%TYPE,
        subline_cd              GIPI_POLBASIC.subline_cd%TYPE,
        iss_cd                  GIPI_POLBASIC.iss_cd%TYPE,
        issue_yy                GIPI_POLBASIC.issue_yy%TYPE,
        pol_seq_no              GIPI_POLBASIC.pol_seq_no%TYPE,
        renew_no                GIPI_POLBASIC.renew_no%TYPE,
        assured                 GIRI_DISTFRPS_V.assured%TYPE,
        eff_date                VARCHAR2(20),
        tot_fac_spct            GIRI_DISTFRPS_V.tot_fac_spct%TYPE,
        tot_fac_spct2           GIRI_DISTFRPS_V.tot_fac_spct2%TYPE,
        tot_fac_tsi             GIRI_DISTFRPS_V.tot_fac_tsi%TYPE,
        tot_fac_prem            GIRI_DISTFRPS_V.tot_fac_prem%TYPE,
        endt_iss_cd             GIRI_DISTFRPS_V.endt_iss_cd%TYPE,
        endt_yy                 GIRI_DISTFRPS_V.endt_yy%TYPE,
        endt_seq_no             GIRI_DISTFRPS_V.endt_seq_no%TYPE,
        frps_yy                 GIRI_DISTFRPS_V.frps_yy%TYPE,
        frps_seq_no             GIRI_DISTFRPS_V.frps_seq_no%TYPE,
        expiry_date             VARCHAR2(20),
        tsi_amt2                GIRI_DISTFRPS_V.tsi_amt2%TYPE,
        prem_amt                GIRI_DISTFRPS_V.prem_amt%TYPE,
        facul_prem_vat          NUMBER(16, 2),
        facul_net_due           NUMBER(16, 2),
        facul_comm              NUMBER(16, 2),
        facul_comm_vat          NUMBER(16, 2),
        facul_wholding_vat      NUMBER(16, 2),
        policy_number           VARCHAR2(50),
        frps_number             VARCHAR2(50),
        dist_no                 GIRI_DISTFRPS_V.dist_no%TYPE,    -- benjo 07.20.2015 UCPBGEN-SR-19626
        dist_seq_no             GIRI_DISTFRPS_V.dist_seq_no%TYPE -- benjo 07.20.2015 UCPBGEN-SR-19626
    );
    TYPE policy_frps_tab IS TABLE OF policy_frps_type;

    TYPE ri_placements_type IS RECORD(
        line_cd                 GIRI_BINDER.line_cd%TYPE,
        frps_yy                 GIRI_DISTFRPS.frps_yy%TYPE,
        frps_seq_no             GIRI_DISTFRPS.frps_seq_no%TYPE,
        binder_number           VARCHAR2(20),
        ri_sname                GIIS_REINSURER.ri_sname%TYPE,
        ri_shr_pct              GIRI_BINDER.ri_shr_pct%TYPE,
        ri_tsi_amt              GIRI_BINDER.ri_tsi_amt%TYPE,
        ri_prem_amt             GIRI_BINDER.ri_prem_amt%TYPE,
        ri_prem_vat             GIRI_BINDER.ri_prem_vat%TYPE,
        prem_tax                GIRI_BINDER_V.prem_tax%TYPE,
        ri_comm_amt             GIRI_BINDER.ri_comm_amt%TYPE,
        ri_comm_vat             GIRI_BINDER.ri_comm_vat%TYPE,
        ri_wholding_vat         GIRI_BINDER.ri_wholding_vat%TYPE,
        ri_comm_rt              GIRI_BINDER.ri_comm_rt%TYPE,
        net_due                 NUMBER(16, 2),
        reverse_sw              VARCHAR2(20),
        binder_yy               GIRI_BINDER.binder_yy%TYPE,
        binder_seq_no           GIRI_BINDER.binder_seq_no%TYPE,
        fnl_binder_id           GIRI_BINDER.fnl_binder_id%TYPE
    );
    TYPE ri_placements_tab IS TABLE OF ri_placements_type;
    
    FUNCTION get_policy_frps(
        p_line_cd               GIRI_DISTFRPS_V.line_cd%TYPE,
        p_subline_cd            GIRI_DISTFRPS_V.subline_cd%TYPE,
        p_iss_cd                GIRI_DISTFRPS_V.iss_cd%TYPE,
        p_issue_yy              GIRI_DISTFRPS_V.issue_yy%TYPE,
        p_pol_seq_no            GIRI_DISTFRPS_V.pol_seq_no%TYPE,
        p_renew_no              GIRI_DISTFRPS_V.renew_no%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
    )
      RETURN policy_frps_tab PIPELINED;
    
    FUNCTION get_ri_placements(
        p_line_cd               GIRI_BINDER.line_cd%TYPE,
        p_frps_yy               GIRI_DISTFRPS.frps_yy%TYPE,
        p_frps_seq_no           GIRI_DISTFRPS.frps_seq_no%TYPE
    )
      RETURN ri_placements_tab PIPELINED;
      
   FUNCTION check_binder_access(
      p_line_cd                  GIRI_BINDER.line_cd%TYPE,
      p_binder_yy                GIRI_BINDER.binder_yy%TYPE,
      p_binder_seq_no            GIRI_BINDER.binder_seq_no%TYPE,
      p_user_id                  GIIS_USERS.user_id%TYPE
   )
     RETURN VARCHAR2;
    
    /* benjo 07.20.2015 UCPBGEN-SR-19626 */
    PROCEDURE check_ri_placements_access (
       p_line_cd      IN   VARCHAR2,
       p_iss_cd       IN   VARCHAR2,
       p_user_id      IN   VARCHAR2
    );
END GIRIS015_PKG;
/


