CREATE OR REPLACE PACKAGE CPI.GIACS309_PKG
AS
    
    TYPE sl_type_type IS RECORD(
        sl_type_cd          GIAC_SL_TYPES.SL_TYPE_CD%type,
        sl_type_name        GIAC_SL_TYPES.SL_TYPE_NAME%type,
        sl_tag              GIAC_SL_TYPES.SL_TAG%type,
        sl_tag_desc         VARCHAR2(30)
    );
    
    TYPE sl_type_tab IS TABLE OF sl_type_type;
    
    
    FUNCTION get_sl_type_lov
        RETURN sl_type_tab PIPELINED;
        
    
    TYPE rec_type IS RECORD(
        fund_cd         GIAC_SL_LISTS.FUND_CD%type,
        sl_type_cd      GIAC_SL_LISTS.SL_TYPE_CD%type,
        sl_cd           GIAC_SL_LISTS.SL_CD%type,
        sl_name         GIAC_SL_LISTS.SL_NAME%type,
        active_tag      GIAC_SL_LISTS.ACTIVE_TAG%type,
        sl_tag          GIAC_SL_TYPES.SL_TAG%type,
        remarks         GIAC_SL_LISTS.REMARKS%type,
        user_id         GIAC_SL_LISTS.USER_ID%type,
        last_update     VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    FUNCTION get_rec_list(
        p_sl_type_cd    GIAC_SL_LISTS.SL_TYPE_CD%type
    ) RETURN rec_tab PIPELINED;
    
    
    PROCEDURE set_rec (p_rec  GIAC_SL_LISTS%ROWTYPE);
    
    
    PROCEDURE del_rec (
        p_fund_cd       GIAC_SL_LISTS.FUND_CD%type,
        p_sl_type_cd    GIAC_SL_LISTS.SL_TYPE_CD%type,
        p_sl_cd         GIAC_SL_LISTS.SL_CD%type
    );
    
    
    PROCEDURE val_add_rec(
        p_fund_cd       GIAC_SL_LISTS.FUND_CD%type,
        p_sl_type_cd    GIAC_SL_LISTS.SL_TYPE_CD%type,
        p_sl_cd         GIAC_SL_LISTS.SL_CD%type    
    );

END GIACS309_PKG;
/


