CREATE OR REPLACE PACKAGE CPI.GIISS180_PKG
AS

    TYPE rec_type IS RECORD(
        genin_info_cd           GIIS_GENIN_INFO.GENIN_INFO_CD%type,
        genin_info_title        GIIS_GENIN_INFO.GENIN_INFO_TITLE%type,
        nbt_info                VARCHAR2(1),
        nbt_initial_gen_info    CLOB,
        gen_info01              GIIS_GENIN_INFO.GEN_INFO01%type,
        gen_info02              GIIS_GENIN_INFO.GEN_INFO02%type,
        gen_info03              GIIS_GENIN_INFO.GEN_INFO03%type,
        gen_info04              GIIS_GENIN_INFO.GEN_INFO04%type,
        gen_info05              GIIS_GENIN_INFO.GEN_INFO05%type,
        gen_info06              GIIS_GENIN_INFO.GEN_INFO06%type,
        gen_info07              GIIS_GENIN_INFO.GEN_INFO07%type,
        gen_info08              GIIS_GENIN_INFO.GEN_INFO08%type,
        gen_info09              GIIS_GENIN_INFO.GEN_INFO09%type,
        gen_info10              GIIS_GENIN_INFO.GEN_INFO10%type,
        gen_info11              GIIS_GENIN_INFO.GEN_INFO11%type,
        gen_info12              GIIS_GENIN_INFO.GEN_INFO12%type,
        gen_info13              GIIS_GENIN_INFO.GEN_INFO13%type,
        gen_info14              GIIS_GENIN_INFO.GEN_INFO14%type,
        gen_info15              GIIS_GENIN_INFO.GEN_INFO15%type,
        gen_info16              GIIS_GENIN_INFO.GEN_INFO16%type,
        gen_info17              GIIS_GENIN_INFO.GEN_INFO17%type,
        initial_info01          GIIS_GENIN_INFO.INITIAL_INFO01%type,
        initial_info02          GIIS_GENIN_INFO.INITIAL_INFO02%type,
        initial_info03          GIIS_GENIN_INFO.INITIAL_INFO03%type,
        initial_info04          GIIS_GENIN_INFO.INITIAL_INFO04%type,
        initial_info05          GIIS_GENIN_INFO.INITIAL_INFO05%type,
        initial_info06          GIIS_GENIN_INFO.INITIAL_INFO06%type,
        initial_info07          GIIS_GENIN_INFO.INITIAL_INFO07%type,
        initial_info08          GIIS_GENIN_INFO.INITIAL_INFO08%type,
        initial_info09          GIIS_GENIN_INFO.INITIAL_INFO09%type,
        initial_info10          GIIS_GENIN_INFO.INITIAL_INFO10%type,
        initial_info11          GIIS_GENIN_INFO.INITIAL_INFO11%type,
        initial_info12          GIIS_GENIN_INFO.INITIAL_INFO12%type,
        initial_info13          GIIS_GENIN_INFO.INITIAL_INFO13%type,
        initial_info14          GIIS_GENIN_INFO.INITIAL_INFO14%type,
        initial_info15          GIIS_GENIN_INFO.INITIAL_INFO15%type,
        initial_info16          GIIS_GENIN_INFO.INITIAL_INFO16%type,
        initial_info17          GIIS_GENIN_INFO.INITIAL_INFO17%type,
        remarks                 GIIS_GENIN_INFO.REMARKS%type,
        user_id                 GIIS_GENIN_INFO.USER_ID%type,
        last_update             VARCHAR2(30),
        active_tag              GIIS_GENIN_INFO.ACTIVE_TAG%type --carlo 01-26-2016 SR 5915
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    
    FUNCTION get_rec_list
        RETURN rec_tab PIPELINED;
        

    FUNCTION allow_update(
        p_genin_info_cd     GIIS_GENIN_INFO.GENIN_INFO_CD%type
    ) RETURN VARCHAR2;
    
    
    PROCEDURE set_rec (p_rec  GIIS_GENIN_INFO%ROWTYPE);

    PROCEDURE del_rec (p_genin_info_cd  GIIS_GENIN_INFO.GENIN_INFO_CD%type);

    PROCEDURE val_del_rec (p_genin_info_cd  GIIS_GENIN_INFO.GENIN_INFO_CD%type);
   
    PROCEDURE val_add_rec(p_genin_info_cd  GIIS_GENIN_INFO.GENIN_INFO_CD%type);
    
    
END GIISS180_PKG;
/


