CREATE OR REPLACE PACKAGE CPI.GIPIR928G_PKG AS

    TYPE gipir928g_type IS RECORD (
        company         VARCHAR2(500),
        company_address VARCHAR2(500),
        report_title    VARCHAR2(100),
        based_on        VARCHAR2(100),
        toggle          VARCHAR2(100),
        date_from       DATE,
        date_to         DATE,
        date_from_to    VARCHAR2(100),
        iss_header      VARCHAR2(100),
        iss_cd          GIIS_ISSOURCE.iss_cd%TYPE,
        iss_cd1         GIIS_ISSOURCE.iss_cd%TYPE,
        iss_name        GIIS_ISSOURCE.iss_name%TYPE,
        line_cd         GIIS_LINE.line_cd%TYPE,
        line_name       GIIS_LINE.line_name%TYPE,
        subline_cd      GIIS_SUBLINE.subline_cd%TYPE,
        subline_name    GIIS_SUBLINE.subline_name%TYPE,
        policy_no       GIPI_UWREPORTS_DIST_PERIL_EXT.policy_no%TYPE, 
        policy_id       GIPI_UWREPORTS_DIST_PERIL_EXT.policy_id%TYPE,
        share_cd         GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        prem_amt        NUMBER(20,2),   --GIPI_UWREPORTS_DIST_PERIL_EXT.fa_dist_prem%TYPE,
        tsi_amt         NUMBER(20,2)    --GIPI_UWREPORTS_DIST_PERIL_EXT.fa_dist_tsi%TYPE        
    );
    
    TYPE gipir928g_tab IS TABLE OF gipir928g_type;
    
    --------------
    TYPE gipir928g_dtl_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE.iss_cd%TYPE,
        line_cd                 GIIS_LINE.line_cd%TYPE,
        policy_no               GIPI_UWREPORTS_DIST_PERIL_EXT.policy_no%TYPE, 
        policy_id               GIPI_UWREPORTS_DIST_PERIL_EXT.policy_id%TYPE,
        subline_cd              GIIS_SUBLINE.subline_cd%TYPE,
        subline_name            GIIS_SUBLINE.subline_name%TYPE,
        peril_sname             VARCHAR2(10), --GIIS_PERIL.peril_sname%TYPE,
        f_tr_dist_tsi           NUMBER(20,2),
        nr_peril_ts             GIPI_UWREPORTS_DIST_PERIL_EXT.nr_dist_tsi%TYPE,
        nr_peril_prem           GIPI_UWREPORTS_DIST_PERIL_EXT.nr_dist_prem%TYPE,
        share_cd                GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        share_type              GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
        trty_name               GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE 
    );
    
    TYPE gipir928g_dtl_tab IS TABLE OF gipir928g_dtl_type;
    
    -------------
    TYPE treaty_name_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE.iss_cd%TYPE,
        line_cd                 GIIS_LINE.line_cd%TYPE,
        share_cd                GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        share_type              GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
        trty_name               GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE
    );
    
    TYPE treaty_name_tab IS TABLE OF treaty_name_type;
    
    -------------
    TYPE subline_recap_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE.iss_cd%TYPE,
        line_cd                 GIIS_LINE.line_cd%TYPE,
        subline_cd              GIIS_SUBLINE.subline_cd%TYPE,
        peril_sname             VARCHAR2(10), 
        trty_name               GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE, 
        share_cd                GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        share_type              GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
        f_tr_dist_tsi           NUMBER(20,2),
        tr_peril_tsi            NUMBER(20,2),
        tr_peril_prem           NUMBER(20,2),
        prem_amt                NUMBER(20,2),
        tsi_amt                 NUMBER(20,2)
    );
    
    TYPE subline_recap_tab IS TABLE OF subline_recap_type;
    
    -------------
    TYPE line_recap_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE.iss_cd%TYPE,
        line_cd                 GIIS_LINE.line_cd%TYPE,
        peril_sname             VARCHAR2(10), 
        trty_name               GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE, 
        share_cd                GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        share_type              GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
        f_tr_dist_tsi           NUMBER(20,2),
        nr_peril_prem           NUMBER(20,2),
        nr_peril_tsi            NUMBER(20,2),
        cp_sr_tsi               NUMBER(20,2),
        cp_sr_prem              NUMBER(20,2),
        cp_fr_tsi               NUMBER(20,2),
        cp_fr_prem              NUMBER(20,2),
        special_risk_tag        VARCHAR2(1) 
    );
    
    TYPE line_recap_tab IS TABLE OF line_recap_type;

    -------------
    TYPE branch_recap_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE.iss_cd%TYPE,
        line_cd                 GIIS_LINE.line_cd%TYPE,
        peril_sname             VARCHAR2(10), 
        trty_name               GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE, 
        share_cd                GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        share_type              GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
        f_tr_dist_tsi           NUMBER(20,2),
--        tr_peril_tsi            NUMBER(20,2),
--        tr_peril_prem           NUMBER(20,2),
--        tsi_amt                 NUMBER(20,2),
--        prem_amt                NUMBER(20,2),
        nr_peril_tsi            NUMBER(20,2),
        nr_peril_prem           NUMBER(20,2)
    );
    
    TYPE branch_recap_tab IS TABLE OF branch_recap_type;
    
    --------------
    TYPE grand_total_type IS RECORD (
        iss_cd                  GIIS_ISSOURCE.iss_cd%TYPE,
--        line_cd                 GIIS_LINE.line_cd%TYPE,
        trty_name               GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE, 
        share_cd                GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
        share_type              GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
        peril_sname             VARCHAR2(10),
        f_tr_dist_tsi           NUMBER(20,2),
        nr_peril_prem           NUMBER(20,2),
        nr_peril_tsi            NUMBER(20,2),
        sr_peril_prem           NUMBER(20,2),
        sr_peril_tsi            NUMBER(20,2),
        fr_peril_prem           NUMBER(20,2),
        fr_peril_tsi            NUMBER(20,2)
    );
    
    TYPE grand_total_tab IS TABLE OF grand_total_type;
    
    FUNCTION populate_gipir928g(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER,
        p_user_id       IN      GIPI_UWREPORTS_DIST_PERIL_EXT.USER_ID%TYPE  --Halley 01.29.14
    ) RETURN gipir928g_tab PIPELINED;
    
    
    FUNCTION get_details(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER 
    ) RETURN gipir928g_dtl_tab PIPELINED;
    
    FUNCTION get_treaty_names(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN treaty_name_tab PIPELINED;
    
    FUNCTION get_subline_recap(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN subline_recap_tab PIPELINED;
    
    FUNCTION get_line_recap(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN line_recap_tab PIPELINED;
    
    FUNCTION get_branch_recap(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN branch_recap_tab PIPELINED;
    
     FUNCTION get_grand_total(
        p_iss_cd        IN      GIIS_ISSOURCE.iss_cd%TYPE,
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_scope         IN      NUMBER,
        p_iss_param     IN      NUMBER
    ) RETURN grand_total_tab PIPELINED;
    
    FUNCTION get_special_risk_tag(p_line_cd GIIS_LINE.line_cd%TYPE) RETURN VARCHAR2;
    
    FUNCTION CF_companyFormula RETURN VARCHAR2;
    
    FUNCTION CF_comaddressFormula RETURN VARCHAR2;
    
    FUNCTION CF_report_titleFormula RETURN VARCHAR2;
    
    FUNCTION CF_based_onFormula RETURN VARCHAR2;
    
    FUNCTION CF_toggleFormula(p_scope   IN  NUMBER) RETURN VARCHAR2;
    
    FUNCTION CF_from_dateFormula(p_user_id GIPI_UWREPORTS_DIST_PERIL_EXT.USER_ID%TYPE) RETURN DATE;
    
    FUNCTION CF_to_dateFormula(p_user_id GIPI_UWREPORTS_DIST_PERIL_EXT.USER_ID%TYPE) RETURN DATE;
    
    FUNCTION CF_iss_headerFormula(p_iss_param   IN  NUMBER) RETURN VARCHAR2;

END GIPIR928G_PKG;
/


