CREATE OR REPLACE PACKAGE CPI.GIPIR928F_PKG
AS

     TYPE report_type IS RECORD(
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            iss_cd_header       VARCHAR2(100),
            iss_name            GIIS_ISSOURCE.iss_name%TYPE,
            line_cd             GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
            line_name           GIIS_LINE.line_name%TYPE,
            subline_cd          GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
            subline_name        GIIS_SUBLINE.subline_name%TYPE,
            policy_no           GIPI_UWREPORTS_DIST_PERIL_EXT.policy_no%TYPE,
            policy_id           GIPI_UWREPORTS_DIST_PERIL_EXT.policy_id%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            prem_amt            NUMBER(20,2),
            tsi_amt             NUMBER(20,2),
            company_name        VARCHAR2(100),
            company_address     giis_parameters.param_value_v%TYPE, -- VARCHAR2(100), changed by robert 01.02.14 
            iss_header          VARCHAR2(100),
            toggle              VARCHAR2(25),
            date_to             GIPI_UWREPORTS_DIST_PERIL_EXT.to_date1%TYPE,
            date_from           GIPI_UWREPORTS_DIST_PERIL_EXT.from_date1%TYPE,
            based_on            VARCHAR2(50),
            reportnm            VARCHAR2(75)

    );
    TYPE report_tab IS TABLE OF report_type;

    TYPE report_detail_type IS RECORD (
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            line_cd             GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
            subline_cd          GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            share_type          GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
            peril_sname         VARCHAR2(5),
            trty_name           GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE,
            policy_no           GIPI_UWREPORTS_DIST_PERIL_EXT.policy_no%TYPE,
            policy_id           GIPI_UWREPORTS_DIST_PERIL_EXT.policy_id%TYPE,
            f_tr_dist_tsi       NUMBER(20,2),
            nr_peril_tsi        NUMBER(20,2),
            nr_peril_prem       NUMBER(20,2)
    );
    TYPE report_detail_tab IS TABLE OF report_detail_type;
    
    TYPE report_trty_name_type IS RECORD (
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            line_cd             GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            share_type          GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
            trty_name           GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE
    );
    TYPE report_trty_name_tab IS TABLE OF report_trty_name_type;  

    TYPE report_subline_recap_type IS RECORD (
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            line_cd             GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
            subline_cd          GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
            share_type          GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            peril_sname         VARCHAR2(5),
            trty_name           GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE,
            f_tr_dist_tsi       NUMBER(20,2),
            nr_peril_prem       NUMBER(20,2),
            nr_peril_ts         NUMBER(20,2)
    );
    TYPE report_subline_recap_tab IS TABLE OF report_subline_recap_type;
    

    TYPE report_line_recap_type IS RECORD (
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            line_cd             GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
            share_type          GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            peril_sname         VARCHAR2(5),
            trty_name           GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE,
            f_tr_dist_tsi       NUMBER(20,2),
            nr_peril_prem       NUMBER(20,2),
            nr_peril_ts         NUMBER(20,2),
            sr_peril_ts         NUMBER(20,2),
            sr_peril_prem       NUMBER(20,2),
            fr_peril_ts         NUMBER(20,2),
            fr_peril_prem       NUMBER(20,2)
    );
    TYPE report_line_recap_tab IS TABLE OF report_line_recap_type;

    TYPE report_branch_recap_type IS RECORD (
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            share_type          GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            peril_sname         VARCHAR2(5),
            trty_name           GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE,
            f_tr_dist_tsi       NUMBER(20,2),
            total_tsi              NUMBER(20,2),
            nr_peril_prem       NUMBER(20,2),
            nr_peril_ts         NUMBER(20,2)
    );
    TYPE report_branch_recap_tab IS TABLE OF report_branch_recap_type;

    TYPE report_grand_total_type IS RECORD (
            iss_cd              GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
            share_type          GIPI_UWREPORTS_DIST_PERIL_EXT.share_type%TYPE,
            share_cd            GIPI_UWREPORTS_DIST_PERIL_EXT.share_cd%TYPE,
            peril_sname         VARCHAR2(5),
            trty_name           GIPI_UWREPORTS_DIST_PERIL_EXT.trty_name%TYPE,
            f_tr_dist_tsi       NUMBER(20,2),
            nr_peril_prem       NUMBER(20,2),
            nr_peril_ts         NUMBER(20,2),
            sr_peril_ts         NUMBER(20,2),
            sr_peril_prem       NUMBER(20,2),
            fr_peril_ts         NUMBER(20,2),
            fr_peril_prem       NUMBER(20,2),
            total_tsi              NUMBER(20,2),
            total_prem             NUMBER(20,2),
            total_sr_tsi              NUMBER(20,2),
            total_sr_prem             NUMBER(20,2),
             total_fr_tsi              NUMBER(20,2),
            total_fr_prem             NUMBER(20,2)
    );
    TYPE report_grand_total_tab IS TABLE OF report_grand_total_type;                       

    FUNCTION get_page_header(     p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_tab PIPELINED;

    FUNCTION get_policy_detail(   p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_detail_tab PIPELINED;

    FUNCTION get_trty_name_header(p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_trty_name_tab PIPELINED;   
         
    FUNCTION get_subline_recap(   p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_subline_recap_tab PIPELINED;


    FUNCTION get_line_recap(      p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_line_recap_tab PIPELINED;                                   

    FUNCTION get_branch_recap(    p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_branch_recap_tab PIPELINED;

    FUNCTION get_grand_total(     p_iss_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.iss_cd%TYPE,
                                  p_iss_param     NUMBER,
                                  p_line_cd       GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
                                  p_scope         NUMBER,
                                  p_subline_cd    GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
                                  p_user_id       GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE)
        RETURN report_grand_total_tab PIPELINED;
                     
END gipir928f_pkg;
/


