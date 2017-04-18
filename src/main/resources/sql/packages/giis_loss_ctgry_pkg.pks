CREATE OR REPLACE PACKAGE CPI.giis_loss_ctgry_pkg
AS
    TYPE giis_loss_ctgry_type IS RECORD (
        line_cd          giis_loss_ctgry.line_cd%TYPE,
        loss_cat_cd      giis_loss_ctgry.loss_cat_cd%TYPE,
        loss_cat_des     giis_loss_ctgry.loss_cat_des%TYPE,
        loss_cat_group   giis_loss_ctgry.loss_cat_group%TYPE,
        remarks          giis_loss_ctgry.remarks%TYPE,
        total_tag        giis_loss_ctgry.total_tag%TYPE,
        peril_cd         giis_loss_ctgry.peril_cd%TYPE
    );
    

    TYPE giis_loss_ctgry_tab IS TABLE OF giis_loss_ctgry_type;
    
    TYPE giis_loss_cd_type IS RECORD (
        line_cd          giis_loss_ctgry.line_cd%TYPE,
        loss_cat_cd      giis_loss_ctgry.loss_cat_cd%TYPE,
        loss_cat_des     giis_loss_ctgry.loss_cat_des%TYPE,
        loss_cat_group   giis_loss_ctgry.loss_cat_group%TYPE,
        remarks          giis_loss_ctgry.remarks%TYPE,
        total_tag        giis_loss_ctgry.total_tag%TYPE,
        peril_cd         giis_loss_ctgry.peril_cd%TYPE
    );

    TYPE giis_loss_cd_tab IS TABLE OF giis_loss_cd_type;

    FUNCTION get_loss_cat (p_line_cd giis_loss_ctgry.line_cd%TYPE)
    RETURN giis_loss_ctgry_tab PIPELINED;
      
    FUNCTION get_loss_cat(
        p_line_cd       giis_loss_ctgry.line_cd%TYPE,
        p_peril_cd      giis_loss_ctgry.peril_cd%TYPE
        )
    RETURN giis_loss_ctgry_tab PIPELINED;
    
    FUNCTION get_loss_cat_cd (
        p_line_cd       giis_loss_ctgry.line_cd%TYPE
    )
    RETURN giis_loss_cd_tab PIPELINED;
          
END giis_loss_ctgry_pkg;
/


