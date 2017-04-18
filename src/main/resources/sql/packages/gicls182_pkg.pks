CREATE OR REPLACE PACKAGE CPI.GICLS182_PKG
AS

    TYPE user_lov_type IS RECORD(
        user_id     GIIS_USERS.USER_ID%type,
        user_name   GIIS_USERS.USER_NAME%type
    );
    
    TYPE user_lov_tab IS TABLE OF user_lov_type;
    
    FUNCTION get_user_lov
        RETURN user_lov_tab PIPELINED;
        
        
    TYPE iss_lov_type IS RECORD(
        iss_cd      GIIS_ISSOURCE.ISS_CD%type,
        iss_name    GIIS_ISSOURCE.ISS_NAME%type
    );
    
    TYPE iss_lov_tab IS TABLE OF iss_lov_type;
    
    FUNCTION get_iss_lov(
        p_user_id   VARCHAR2
    ) RETURN iss_lov_tab PIPELINED;
    
    
    TYPE rec_type IS RECORD(
        adv_user        GICL_ADV_LINE_AMT.ADV_USER%type,
        iss_cd          GICL_ADV_LINE_AMT.ISS_CD%type,
        line_cd         GICL_ADV_LINE_AMT.LINE_CD%type,
        line_name       GIIS_LINE.LINE_NAME%type,
        all_amt_sw      GICL_ADV_LINE_AMT.ALL_AMT_SW%type,
        range_to        GICL_ADV_LINE_AMT.RANGE_TO%type,
        all_res_amt_sw  GICL_ADV_LINE_AMT.ALL_RES_AMT_SW%type,
        res_range_to    GICL_ADV_LINE_AMT.RES_RANGE_TO%type,
        user_id         GICL_ADV_LINE_AMT.USER_ID%type,
        last_update     VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    FUNCTION get_rec_list(
        p_adv_user          GICL_ADV_LINE_AMT.ADV_USER%type,
        p_iss_cd            GICL_ADV_LINE_AMT.ISS_CD%type,
        p_app_user          VARCHAR2
    ) RETURN rec_tab PIPELINED;
    
    
    PROCEDURE set_rec (p_rec GICL_ADV_LINE_AMT%ROWTYPE);

END GICLS182_PKG;
/


