CREATE OR REPLACE PACKAGE CPI.GIPIS901_PKG
AS

    TYPE subline_type IS RECORD(
        line_cd         GIIS_SUBLINE.LINE_CD%type,
        subline_cd      GIIS_SUBLINE.SUBLINE_CD%type,
        subline_name    GIIS_SUBLINE.SUBLINE_NAME%type
    );  
    
    TYPE subline_tab IS TABLE OF subline_type;
    
    FUNCTION get_mn_subline_lov
        RETURN subline_tab PIPELINED;
        
    
    TYPE vessel_type IS RECORD(
        vessel_cd      GIIS_VESSEL.VESSEL_CD%type,
        vessel_name    GIIS_VESSEL.VESSEL_NAME%type
    );  
    
    TYPE vessel_tab IS TABLE OF vessel_type;
    
    FUNCTION get_mn_vessel_lov
        RETURN vessel_tab PIPELINED;
        
    
    FUNCTION populate_gixx071(
        p_subline           GIIS_SUBLINE.SUBLINE_NAME%type,
        p_vessel            GIIS_VESSEL.VESSEL_NAME%type,
        p_from_date         DATE,
        p_to_date           DATE,
        p_user_id           VARCHAR2
    ) RETURN NUMBER;
    
    
    FUNCTION populate_gixx072(
        p_subline           GIIS_SUBLINE.SUBLINE_NAME%type,
        p_cargo_class_cd    GIIS_CARGO_CLASS.CARGO_CLASS_CD%type,
        p_from_date         DATE,
        p_to_date           DATE,
        p_user_id           VARCHAR2
    ) RETURN NUMBER;
    
        
    PROCEDURE GET_REC_CNT_STAT_TAB(
        p_stat_choice    IN  VARCHAR2,
        p_subline        IN  GIIS_SUBLINE.SUBLINE_NAME%type,
        p_vessel         IN  GIIS_VESSEL.VESSEL_NAME%type,
        p_cargo_class_cd IN  GIIS_CARGO_CLASS.CARGO_CLASS_CD%type,
        p_from_date      IN  VARCHAR2,
        p_to_date        IN  VARCHAR2,
        p_user_id        IN  VARCHAR2,
        p_extract_id    OUT  NUMBER,
        p_rec_cnt       OUT  NUMBER
    ); 
    
    
    PROCEDURE extract_records_motor_stat(
        p_motor_stat_type   IN  VARCHAR2,
        p_zone_type         IN  VARCHAR2,
        p_date_param        IN  VARCHAR2,
        p_print_type        IN  VARCHAR2,
        p_date_type         IN  VARCHAR2,
        p_v_iss_cd          IN  VARCHAR2,
        p_date_from         IN  VARCHAR2,
        p_date_to           IN  VARCHAR2,
        p_year              IN  VARCHAR2,
        p_user              IN  VARCHAR2,
        p_msg               OUT VARCHAR2
    );
    
    FUNCTION chk_existing_record_motor_stat(
        p_motor_stat_type   VARCHAR2,
        p_print_type        VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN VARCHAR2;
    

    PROCEDURE extract_fire_stat(
        p_fire_stat     IN  VARCHAR2,
        p_date_rb       IN  VARCHAR2,    
        p_date          IN  VARCHAR2,
        p_date_from     IN  VARCHAR2,
        p_date_to       IN  VARCHAR2,
        p_as_of_date    IN  VARCHAR2,
        p_bus_cd        IN  NUMBER,
        p_zone          IN  VARCHAR2,
        p_zone_type     IN  VARCHAR2,
        p_risk_cnt      IN  VARCHAR2,
        p_incl_endt     IN  VARCHAR2,
        p_incl_exp      IN  VARCHAR2,
        p_peril_type    IN  VARCHAR2,
        p_user          IN  VARCHAR2,
        p_cnt           OUT NUMBER
    );
    
    
    TYPE fire_tariff_master_type IS RECORD(
        tarf_cd     GIIS_TARIFF.TARF_CD%type,
        tarf_desc   GIIS_TARIFF.TARF_DESC%type
    );
    
    TYPE fire_tariff_master_tab IS TABLE OF fire_tariff_master_type;
    
    
    FUNCTION populate_fire_tariff_master(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_zone_type     gipi_firestat_extract_dtl.ZONE_TYPE%TYPE --VARCHAR2 
    ) RETURN fire_tariff_master_tab PIPELINED;
    
    
    TYPE fire_tariff_detail_type IS RECORD(
        policy_no           VARCHAR2(100),
        assd_no             GIXX_FIRESTAT_SUMMARY_DTL.ASSD_NO%type,
        assd_name           VARCHAR2(1000),                              -- jhing 03.19.2015 modified from 520 to 1000 to handle possible increase in field 
        tarf_cd             GIXX_FIRESTAT_SUMMARY_DTL.TARF_CD%type,
        tsi_amt             NUMBER(18,2),
        prem_amt            NUMBER(18,2),
        user_id             GIXX_FIRESTAT_SUMMARY_DTL.USER_ID%type
    );
    
    TYPE fire_tariff_detail_tab IS TABLE OF fire_tariff_detail_type;
    
    
    FUNCTION populate_fire_tariff_detail(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_tarf_cd       gixx_firestat_summary_dtl.TARF_CD%type,
        p_zone_type     gipi_firestat_extract_dtl.ZONE_TYPE%TYPE--VARCHAR2       -- jhing 03.19.2015 
    ) RETURN fire_tariff_detail_tab PIPELINED;
    
    
    TYPE fire_zone_master_type IS RECORD(
        line_cd             GIPI_FIRESTAT_EXTRACT_DTL.LINE_CD%type , -- jhing 03.19.2015 
        line_name           GIIS_LINE.LINE_NAME%type, --edgar 03/20/2015
        share_cd            GIPI_FIRESTAT_EXTRACT_DTL.SHARE_CD%type,
        share_name          GIIS_DIST_SHARE.TRTY_NAME%type,
        share_tsi_amt       GIPI_FIRESTAT_EXTRACT_DTL.SHARE_TSI_AMT%type,
        share_prem_amt      GIPI_FIRESTAT_EXTRACT_DTL.SHARE_PREM_AMT%type,
        as_of_sw            GIPI_FIRESTAT_EXTRACT_DTL.AS_OF_SW%type
    );
    
    TYPE fire_zone_master_tab IS TABLE OF fire_zone_master_type;
    
    
    FUNCTION populate_fire_zone_master(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_line_cd_fi    VARCHAR2 ,
        p_zone_type     VARCHAR2
    ) RETURN fire_zone_master_tab PIPELINED;
    
    
    TYPE fire_zone_detail_type IS RECORD(
        share_cd            gipi_firestat_zone_dtl_v.SHARE_CD%type,
        share_name          GIIS_DIST_SHARE.TRTY_NAME%type,
        assd_name           gipi_firestat_zone_dtl_v.assd_name%type,
        policy_no           gipi_firestat_zone_dtl_v.POLICY_NO%type,
        share_tsi_amt       gipi_firestat_zone_dtl_v.SHARE_TSI_AMT%type,
        share_prem_amt      gipi_firestat_zone_dtl_v.SHARE_PREM_AMT%type,
        as_of_sw            gipi_firestat_zone_dtl_v.AS_OF_SW%type,
        user_id             gipi_firestat_zone_dtl_v.USER_ID%type,
        line_cd             gipi_firestat_extract_dtl.line_cd%type
    );
    
    TYPE fire_zone_detail_tab IS TABLE OF fire_zone_detail_type;
    
    
    FUNCTION populate_fire_zone_detail(
        p_user_id       gixx_firestat_summary_dtl.USER_ID%type,
        p_as_of_sw      gixx_firestat_summary_dtl.AS_OF_SW%type,
        p_line_cd_fi    VARCHAR2,
        p_share_cd      gipi_firestat_zone_dtl_v.SHARE_CD%type,
        p_line_cd       gipi_firestat_extract_dtl.line_cd%type ,
        p_zone_type     gipi_firestat_extract_dtl.zone_type%TYPE--VARCHAR2 
    ) RETURN fire_zone_detail_tab PIPELINED;
    
    
    TYPE fire_com_accum_master_type IS RECORD(
        zone_group      giis_flood_zone.ZONE_GRP%type,
        nbt_zone_grp    VARCHAR2(5),
        share_cd        giis_dist_share.SHARE_CD%type,
        dist_share      CG_REF_CODES.RV_MEANING%type,
        share_type      CG_REF_CODES.RV_LOW_VALUE%type, --added edgar 03/20/2015
        acct_trty_type  CG_REF_CODES.RV_LOW_VALUE%type --added edgar 03/20/2015
    );
    
    TYPE fire_com_accum_master_tab IS TABLE OF fire_com_accum_master_type;
    
    
    FUNCTION populate_fire_com_accum_master
        RETURN fire_com_accum_master_tab PIPELINED;
    
    
    TYPE fire_com_accum_detail_type IS RECORD(
       zone_group       giis_flood_zone.ZONE_GRP%type, 
       zone_type        gipi_firestat_extract_dtl.ZONE_TYPE%type,
       zone_no          gipi_firestat_extract_dtl.ZONE_NO%type,
       share_cd         gipi_firestat_extract_dtl.SHARE_CD%type,
       as_of_sw         gipi_firestat_extract_dtl.AS_OF_SW%type,
       policy_no        VARCHAR2(100),
       line_cd          gipi_polbasic.LINE_CD%type,
       subline_cd       gipi_polbasic.SUBLINE_CD%type,
       iss_cd           gipi_polbasic.ISS_CD%type,
       issue_yy         gipi_polbasic.ISSUE_YY%type,
       pol_seq_no       gipi_polbasic.POL_SEQ_NO%type,
       renew_no         gipi_polbasic.RENEW_NO%type,
       tsi_amt_b        NUMBER(18,2),
       prem_amt_b       NUMBER(18,2),
       tsi_amt_c        NUMBER(18,2),
       prem_amt_c       NUMBER(18,2),
       tsi_amt_l        NUMBER(18,2),
       prem_amt_l       NUMBER(18,2)
    );
    
    TYPE fire_com_accum_detail_tab IS TABLE OF fire_com_accum_detail_type;
    
    
    FUNCTION populate_fire_com_accum_detail(
        p_zone          VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_zone_grp      giis_eqzone.ZONE_GRP%type,
        p_nbt_zone_grp  VARCHAR2,
        p_zone_type     gipi_firestat_extract_dtl.ZONE_TYPE%type,
        p_share_cd      gipi_firestat_extract_dtl.SHARE_CD%type,
        p_user_id       gipi_firestat_extract_dtl.USER_ID%type
    ) RETURN fire_com_accum_detail_tab PIPELINED;
    
    
    PROCEDURE fire_com_accum_dtl_post_query(
        p_zone              IN  VARCHAR2,
        p_as_of_sw          IN  VARCHAR2,
        p_nbt_zone_grp      IN  VARCHAR2,
        p_zone_no           IN  gipi_firestat_extract_dtl.ZONE_NO%type,
        p_share_cd          IN  gipi_firestat_extract_dtl.SHARE_CD%type,
        p_line_cd           IN  gipi_polbasic.LINE_CD%type,
        p_subline_cd        IN  gipi_polbasic.SUBLINE_CD%type,
        p_iss_cd            IN  gipi_polbasic.ISS_CD%type,
        p_issue_yy          IN  gipi_polbasic.ISSUE_YY%type,
        p_pol_seq_no        IN  gipi_polbasic.POL_SEQ_NO%type,
        p_renew_no          IN  gipi_polbasic.RENEW_NO%type, 
        p_user_id           IN  VARCHAR2, 
        p_sum_tsi_amt_b     OUT NUMBER,  
        p_sum_prem_amt_b    OUT NUMBER,  
        p_sum_tsi_amt_c     OUT NUMBER,  
        p_sum_prem_amt_c    OUT NUMBER,  
        p_sum_tsi_amt_l     OUT NUMBER,  
        p_sum_prem_amt_l    OUT NUMBER
    );
    
    
    TYPE risk_line_lov_type IS RECORD(
        line_cd         giis_line.LINE_CD%type,
        line_name       giis_line.LINE_NAME%type,	--Gzelle 07292015 SR4136,4196,4285,4271
        menu_line_cd    giis_line.MENU_LINE_CD%TYPE --Gzelle 07292015 SR4136,4196,4285,4271
    );
    
    TYPE risk_line_lov_tab IS TABLE OF risk_line_lov_type;
    
    
    FUNCTION get_risk_line_lov(
        p_cred_branch       giis_issource.ISS_CD%type,
        p_user_id           giis_line.USER_ID%type
    ) RETURN risk_line_lov_tab PIPELINED;
    
    
    TYPE risk_iss_lov_type IS RECORD(
        iss_cd         giis_issource.ISS_CD%type,
        iss_name       giis_issource.ISS_NAME%type
    );
    
    TYPE risk_iss_lov_tab IS TABLE OF risk_iss_lov_type;
    
    
    FUNCTION get_risk_iss_lov(
        p_line_cd       giis_line.LINE_CD%type,
        p_user_id       giis_line.USER_ID%type
    ) RETURN risk_iss_lov_tab PIPELINED;
    
    
    TYPE risk_profile_master_type IS RECORD(
        line_cd         gipi_risk_profile.LINE_CD%type,
        line_name       giis_line.LINE_NAME%type,
        subline_cd      gipi_risk_profile.SUBLINE_CD%type,
        subline_name    giis_subline.SUBLINE_NAME%type,
        iss_cd          giis_issource.ISS_CD%type,
        iss_name        giis_issource.ISS_NAME%type,
        date_from       gipi_risk_profile.DATE_FROM%type,
        date_to         gipi_risk_profile.DATE_TO%type,
        all_line_tag    gipi_risk_profile.ALL_LINE_TAG%type,
        user_id         gipi_risk_profile.USER_ID%type,
        param_date        gipi_risk_profile.PARAM_DATE%type,    --start - Gzelle 03252015
        inc_endt          gipi_risk_profile.INC_ENDT%type,
        inc_expired       gipi_risk_profile.INC_EXPIRED%type,
        cred_branch_param  gipi_risk_profile.CRED_BRANCH_PARAM%type,	--Gzelle 07292015 SR4136,4196,4285,4271
        menu_line_cd       giis_line.MENU_LINE_CD%type          --end - Gzelle 07292015 SR4136,4196,4285,4271
    );
    
    TYPE risk_profile_master_tab IS TABLE OF risk_profile_master_type;
    
    
    FUNCTION populate_risk_profile_master(
        p_ctrl_line_cd  gipi_risk_profile.LINE_CD%type,
        p_iss_cd        giis_issource.ISS_CD%type,
        p_user_id       gipi_risk_profile.USER_ID%type
    ) RETURN risk_profile_master_tab PIPELINED;
    
    
    TYPE risk_profile_detail_type IS RECORD(
        line_cd         gipi_risk_profile.LINE_CD%type,
        subline_cd      gipi_risk_profile.SUBLINE_CD%type,
        date_from       gipi_risk_profile.DATE_FROM%type,
        date_to         gipi_risk_profile.DATE_TO%type,
        range_from      gipi_risk_profile.RANGE_FROM%type,
        range_to        gipi_risk_profile.RANGE_TO%type,
        policy_cnt      gipi_risk_profile.POLICY_COUNT%type,
        net_retention   gipi_risk_profile.NET_RETENTION%type,
        quota_share     gipi_risk_profile.QUOTA_SHARE%type,
        treaty          gipi_risk_profile.TREATY%type,
        facultative     gipi_risk_profile.FACULTATIVE%type,
        all_line_tag    gipi_risk_profile.ALL_LINE_TAG%type,
        user_id         gipi_risk_profile.USER_ID%type,
        min_range_from  gipi_risk_profile.RANGE_FROM%type,	--Gzelle 03302015
        max_range_to    gipi_risk_profile.RANGE_TO%type,	--Gzelle 03302015
        rec_count		NUMBER(30)							--Gzelle 03302015
    );
    
    TYPE risk_profile_detail_tab IS TABLE OF risk_profile_detail_type;
    
    
    FUNCTION populate_risk_profile_detail(
        p_line_cd         gipi_risk_profile.LINE_CD%type,
        p_subline_cd      gipi_risk_profile.SUBLINE_CD%type,
        p_date_from       VARCHAR2,
        p_date_to         VARCHAR2,
        p_all_line_tag    gipi_risk_profile.ALL_LINE_TAG%type,
        p_user_id         gipi_risk_profile.USER_ID%type
    ) RETURN risk_profile_detail_tab PIPELINED;
           
    
    FUNCTION GET_TREATY_COUNT(
        P_LINE           gipi_risk_profile.line_cd%TYPE,
        P_STARTING_DATE  gipi_risk_profile.date_from%TYPE,
        P_ENDING_DATE    gipi_risk_profile.date_to%TYPE, 
        P_BY_TARF        gipi_risk_profile.tarf_cd%TYPE,
        P_USER           gipi_risk_profile.user_id%TYPE
    ) RETURN NUMBER;
    
    
    PROCEDURE extract_risk_profile(
        p_line_cd         IN    gipi_risk_profile.LINE_CD%type,
        p_subline_cd      IN    gipi_risk_profile.SUBLINE_CD%type,
        p_date_from       IN    gipi_risk_profile.DATE_FROM%type,
        p_date_to         IN    gipi_risk_profile.DATE_TO%type,
        p_all_line_tag    IN    gipi_risk_profile.ALL_LINE_TAG%type,
        p_paramdate       IN    VARCHAR2,
        p_by_tarf         IN    VARCHAR2,
        p_cred_branch     IN    VARCHAR2,
        p_incl_endt       IN    VARCHAR2,
        p_incl_exp        IN    VARCHAR2,
        p_user_id         IN    gipi_risk_profile.USER_ID%type
    );
    
    PROCEDURE risk_save(
        p_line_cd           IN  gipi_risk_profile.LINE_CD%type,
        p_line_name         IN  VARCHAR2,
        p_subline_cd        IN  gipi_risk_profile.SUBLINE_CD%type,
        p_subline_name      IN  VARCHAR2,
        p_date_from         IN  gipi_risk_profile.DATE_FROM%type,
        p_date_to           IN  gipi_risk_profile.DATE_TO%type,
        p_range_from        IN  gipi_risk_profile.RANGE_FROM%type,
        p_range_to          IN  gipi_risk_profile.RANGE_TO%type,
        p_all_line_tag      IN  gipi_risk_profile.ALL_LINE_TAG%type,
        p_user_id           IN  gipi_risk_profile.USER_ID%type,
        p_record_status     IN  NUMBER,
        p_prev_line_cd      IN  gipi_risk_profile.LINE_CD%type,
        p_prev_subline_cd   IN  gipi_risk_profile.SUBLINE_CD%type,
        p_param_date        IN  gipi_risk_profile.PARAM_DATE%type,    -- start Gzelle 03232015
        p_inc_endt          IN  gipi_risk_profile.INC_ENDT%type,
        p_inc_expired       IN  gipi_risk_profile.INC_EXPIRED%type,
        p_cred_branch_param IN  gipi_risk_profile.CRED_BRANCH_PARAM%type, --end Gzelle 03232015
        p_user_response     IN  VARCHAR2,    --Gzelle 04012015
        p_prev_all_line_tag IN  VARCHAR2,     --Gzelle 04072015
        p_is_add_from_update   IN  VARCHAR2
    );
    
    --Apollo Cruz 10.21.2014
    PROCEDURE delete_risk_profile_prev_recs (
       p_all_line_tag   VARCHAR2,
       p_user_id        VARCHAR2
    );
    
    PROCEDURE check_fire_stat(
        p_fire_stat     IN  VARCHAR2,
        p_date_rb       IN  VARCHAR2,    
        p_date          IN  VARCHAR2,
        p_date_from     IN  VARCHAR2,
        p_date_to       IN  VARCHAR2,
        p_as_of_date    IN  VARCHAR2,
        p_bus_cd        IN  NUMBER,
        p_zone          IN  VARCHAR2,
        p_zone_type     IN  VARCHAR2,
        p_risk_cnt      IN  VARCHAR2,
        p_incl_endt     IN  VARCHAR2,
        p_incl_exp      IN  VARCHAR2,
        p_peril_type    IN  VARCHAR2,
        p_user          IN  VARCHAR2,
        p_cnt           OUT NUMBER
    );    
    
    --Gzelle 03262015
    PROCEDURE val_before_save(
        p_line_cd           IN  gipi_risk_profile.line_cd%TYPE,
        p_subline_cd        IN  gipi_risk_profile.subline_cd%TYPE,
        p_all_line_tag      IN  gipi_risk_profile.all_line_tag%TYPE,
        p_user_id           IN  gipi_risk_profile.user_id%TYPE,
        p_msg               OUT VARCHAR2
    );

    --Gzelle 04072015
    PROCEDURE val_add_upd_rec(
        p_line_cd           IN  gipi_risk_profile.line_cd%TYPE,
        p_subline_cd        IN  gipi_risk_profile.subline_cd%TYPE,
        p_all_line_tag      IN  gipi_risk_profile.all_line_tag%TYPE,
        p_user_id           IN  gipi_risk_profile.user_id%TYPE,
        p_msg               OUT VARCHAR2
    );        
    
    
END GIPIS901_PKG;
/


