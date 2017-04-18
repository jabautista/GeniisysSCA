CREATE OR REPLACE PACKAGE CPI.GIUW_POL_DIST_POLBASIC_V_PKG AS

    TYPE giuw_pol_dist_polbasic_v_type IS RECORD(
        policy_id           GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE, 
        line_cd             GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
        subline_cd          GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
        iss_cd              GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
        issue_yy            GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE, 
        par_id              GIUW_POL_DIST_POLBASIC_V.par_id%TYPE, 
        pol_seq_no          GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
        policy_no           VARCHAR2(50),
        assd_no             GIUW_POL_DIST_POLBASIC_V.assd_no%TYPE,
        endt_iss_cd         GIUW_POL_DIST_POLBASIC_V.endt_iss_cd%TYPE, 
        spld_flag           GIUW_POL_DIST_POLBASIC_V.spld_flag%TYPE, 
        dist_flag           GIUW_POL_DIST_POLBASIC_V.dist_flag%TYPE, 
        dist_no             GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE, 
        eff_date            GIUW_POL_DIST_POLBASIC_V.eff_date%TYPE, 
        eff_date_polbas     GIUW_POL_DIST_POLBASIC_V.eff_date_polbas%TYPE, 
        issue_date          GIUW_POL_DIST_POLBASIC_V.issue_date%TYPE, 
        expiry_date_polbas  GIUW_POL_DIST_POLBASIC_V.expiry_date_polbas%TYPE, 
        endt_expiry_date    GIUW_POL_DIST_POLBASIC_V.endt_expiry_date%TYPE, 
        expiry_date_poldist GIUW_POL_DIST_POLBASIC_V.expiry_date_poldist%TYPE, 
        endt_yy             GIUW_POL_DIST_POLBASIC_V.endt_yy%TYPE, 
        dist_type           GIUW_POL_DIST_POLBASIC_V.dist_type%TYPE, 
        acct_ent_date       GIUW_POL_DIST_POLBASIC_V.acct_ent_date%TYPE, 
        endt_seq_no         GIUW_POL_DIST_POLBASIC_V.endt_seq_no%TYPE,
        endt_no             VARCHAR2(50), 
        renew_no            GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE, 
        pol_flag            GIUW_POL_DIST_POLBASIC_V.pol_flag%TYPE, 
        negate_date         GIUW_POL_DIST_POLBASIC_V.negate_date%TYPE, 
        acct_neg_date       GIUW_POL_DIST_POLBASIC_V.acct_neg_date%TYPE, 
        incept_date         GIUW_POL_DIST_POLBASIC_V.incept_date%TYPE, 
        last_upd_date       GIUW_POL_DIST_POLBASIC_V.last_upd_date%TYPE, 
        user_id             GIUW_POL_DIST_POLBASIC_V.user_id%TYPE, 
        batch_id            GIUW_POL_DIST_POLBASIC_V.batch_id%TYPE, 
        tsi_amt             GIUW_POL_DIST_POLBASIC_V.tsi_amt%TYPE, 
        prem_amt            GIUW_POL_DIST_POLBASIC_V.prem_amt%TYPE, 
        user_id2            GIUW_POL_DIST_POLBASIC_V.user_id2%TYPE 
    );
    
    TYPE giuw_pol_dist_polbasic_v_tab IS TABLE OF giuw_pol_dist_polbasic_v_type;
    
    FUNCTION get_giuw_pol_dist_polbasic_v 
        (p_module_id            GIIS_USER_GRP_MODULES.module_id%TYPE,
         p_line_cd              GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
         p_iss_cd               GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
         p_subline_cd           GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
         p_issue_yy             GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE,
         p_pol_seq_no           GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
         p_renew_no             GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE,
         p_endt_iss_cd          GIUW_POL_DIST_POLBASIC_V.endt_iss_cd%TYPE,
         p_endt_yy              GIUW_POL_DIST_POLBASIC_V.endt_yy%TYPE,
         p_endt_seq_no          GIUW_POL_DIST_POLBASIC_V.endt_seq_no%TYPE,
         p_dist_no              GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
         p_user_id              GIIS_USER_GRP_MODULES.user_id%TYPE
         )
    RETURN giuw_pol_dist_polbasic_v_tab PIPELINED;
    
    FUNCTION get_giuw_pol_dist_polbasic_v_2 (p_batch_id          GIUW_POL_DIST_POLBASIC_V.batch_id%TYPE,
                                             p_dist_no           GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE)
    RETURN giuw_pol_dist_polbasic_v_tab PIPELINED;
	
	
	FUNCTION get_giuw_pol_dist_polbasic_v_3(    -- shan 08.28.2014
         p_module_id            GIIS_USER_GRP_MODULES.module_id%TYPE,         
         p_user_id              GIIS_USER_GRP_MODULES.user_id%TYPE,
         p_batch_id             GIUW_POL_DIST_POLBASIC_V.BATCH_ID%type
    )
    RETURN giuw_pol_dist_polbasic_v_tab PIPELINED;
    
END GIUW_POL_DIST_POLBASIC_V_PKG;
/


