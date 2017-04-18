CREATE OR REPLACE PACKAGE CPI.GICLS105_PKG
AS
    TYPE rec_type IS RECORD (
        line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type,
        loss_cat_desc   GIIS_LOSS_CTGRY.LOSS_CAT_DES%type,
        loss_cat_group  GIIS_LOSS_CTGRY.LOSS_CAT_GROUP%type,
        total_tag       GIIS_LOSS_CTGRY.TOTAL_TAG%type,
        peril_cd        GIIS_LOSS_CTGRY.PERIL_CD%type,
        peril_name      GIIS_PERIL.PERIL_NAME%type,
        remarks         GIIS_COLLATERAL_TYPE.REMARKS%type,
        user_id         GIIS_COLLATERAL_TYPE.USER_ID%type,
        last_update     VARCHAR2 (30)
    ); 

    TYPE rec_tab IS TABLE OF rec_type;

    FUNCTION get_rec_list (
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type,
        p_loss_cat_des    GIIS_LOSS_CTGRY.LOSS_CAT_DES%type,
        p_total_tag       GIIS_LOSS_CTGRY.TOTAL_TAG%type
    ) RETURN rec_tab PIPELINED;


    PROCEDURE set_rec (p_rec GIIS_LOSS_CTGRY%ROWTYPE);

    PROCEDURE del_rec (
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    );

    PROCEDURE val_del_rec (
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    );
       
    PROCEDURE val_add_rec(
        p_line_cd         GIIS_LOSS_CTGRY.LINE_CD%type,
        p_loss_cat_cd     GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    );

END GICLS105_PKG;
/


