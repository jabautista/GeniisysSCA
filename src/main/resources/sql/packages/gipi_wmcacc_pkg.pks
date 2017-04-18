CREATE OR REPLACE PACKAGE CPI.Gipi_Wmcacc_Pkg 
AS   
    TYPE get_Gipi_WMcAcc_type IS RECORD (
        par_id                GIPI_WMCACC.par_id%TYPE,
        item_no                GIPI_WMCACC.item_no%TYPE,
        accessory_cd        GIPI_WMCACC.accessory_cd%TYPE,
        acc_amt                GIPI_WMCACC.acc_amt%TYPE,
        delete_sw             GIPI_WMCACC.delete_sw%TYPE,
        accessory_desc        GIIS_ACCESSORY.accessory_desc%TYPE,
        user_id                GIPI_WMCACC.user_id%TYPE);
        
    TYPE get_Gipi_WMcAcc_tab IS TABLE OF get_Gipi_WMcAcc_type;

    FUNCTION get_Gipi_WMcAcc (p_par_id         GIPI_WMCACC.par_id%TYPE,
        p_item_no         GIPI_WMCACC.item_no%TYPE)
    RETURN get_Gipi_WMcAcc_tab PIPELINED;
    
    FUNCTION get_Gipi_WMcAcc_1 (p_par_id         GIPI_WMCACC.par_id%TYPE)
    RETURN get_Gipi_WMcAcc_tab PIPELINED;

    Procedure set_Gipi_WMcAcc (p_acc IN GIPI_WMCACC%ROWTYPE);

    Procedure set_Gipi_WMcAcc_1 (
        p_par_id         IN GIPI_WMCACC.par_id%TYPE,
        p_item_no        IN GIPI_WMCACC.item_no%TYPE,
        p_accessory_cd    IN GIPI_WMCACC.accessory_cd%TYPE,
        p_acc_amt        IN GIPI_WMCACC.acc_amt%TYPE,
        p_user_id        IN GIPI_WMCACC.user_id%TYPE,
        p_delete_sw        IN GIPI_WMCACC.delete_sw%TYPE);
    
    Procedure delete_all_GipiWMcAcc (p_par_id     GIPI_WMCACC.par_id%TYPE,
        p_item_no     GIPI_WMCACC.item_no%TYPE);

    Procedure del_gipi_wmcacc (p_par_id        GIPI_WMCACC.par_id%TYPE,
        p_item_no    GIPI_WMCACC.item_no%TYPE);
    
    Procedure del_gipi_wmcacc_1 (
        p_par_id        IN GIPI_WMCACC.par_id%TYPE,
        p_item_no        IN GIPI_WMCACC.item_no%TYPE,
        p_accessory_cd    IN GIPI_WMCACC.accessory_cd%TYPE);
    
    Procedure del_gipi_wmcacc (p_par_id IN GIPI_WMCACC.par_id%TYPE);
    
    FUNCTION get_gipi_wmcacc_pack_pol (
        p_par_id IN GIPI_WMCACC.par_id%TYPE,
        p_item_no IN GIPI_WMCACC.item_no%TYPE)
    RETURN get_Gipi_WMcAcc_tab PIPELINED;
    
    FUNCTION get_gipi_wmcacc_tg (
        p_par_id IN gipi_wmcacc.par_id%TYPE,
        p_item_no IN gipi_wmcacc.item_no%TYPE,
        p_find_text IN VARCHAR2)
    RETURN get_Gipi_WMcAcc_tab PIPELINED;
END Gipi_Wmcacc_Pkg;
/


