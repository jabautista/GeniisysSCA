CREATE OR REPLACE PACKAGE CPI.GIISS010_PKG
AS
    TYPE line_type IS RECORD(
        line_cd         GIIS_SUBLINE.LINE_CD%type,
        line_name       GIIS_LINE.LINE_NAME%type
    );
    
    TYPE line_tab IS TABLE OF line_type;
    
    
    FUNCTION get_line_lov(
        p_user_id       GIIS_SUBLINE.USER_ID%type
    ) RETURN line_tab PIPELINED;
    
    
    TYPE subline_type IS RECORD(
        subline_cd      GIIS_SUBLINE.SUBLINE_CD%type,
        subline_name    GIIS_SUBLINE.SUBLINE_NAME%type
    );
    
    TYPE subline_tab IS TABLE OF subline_type;
    
    
    FUNCTION get_subline_lov(
        p_line_cd       GIIS_SUBLINE.LINE_CD%type
    ) RETURN subline_tab PIPELINED;
    

    TYPE rec_type IS RECORD (
        line_cd             GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        subline_cd          GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        deductible_cd       GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type,
        ded_type            GIIS_DEDUCTIBLE_DESC.DED_TYPE%type,
        deductible_title    GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_TITLE%type,
        deductible_text     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_TEXT%type,
        deductible_rt       GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_RT%type,
        deductible_amt      GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_AMT%type,
        min_amt             GIIS_DEDUCTIBLE_DESC.MIN_AMT%type,
        max_amt             GIIS_DEDUCTIBLE_DESC.MAX_AMT%type,
        range_sw            GIIS_DEDUCTIBLE_DESC.RANGE_SW%type,
        remarks             GIIS_DEDUCTIBLE_DESC.REMARKS%type,
        user_id             GIIS_DEDUCTIBLE_DESC.USER_ID%type,
        last_update         VARCHAR2 (30)
    ); 

    TYPE rec_tab IS TABLE OF rec_type;

    FUNCTION get_rec_list (
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type,
        p_ded_type          GIIS_DEDUCTIBLE_DESC.DED_TYPE%type,
        p_deductible_title  GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_TITLE%type,
        p_user_id           GIIS_DEDUCTIBLE_DESC.USER_ID%type
    ) RETURN rec_tab PIPELINED;


    PROCEDURE set_rec (p_rec GIIS_DEDUCTIBLE_DESC%ROWTYPE);

    PROCEDURE del_rec (
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type
    );

    PROCEDURE val_del_rec (
        p_check_both        VARCHAR2,
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type
    );
       
    PROCEDURE val_add_rec(
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type,
        p_deductible_title  GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_TITLE%type
    );

END GIISS010_PKG;
/


