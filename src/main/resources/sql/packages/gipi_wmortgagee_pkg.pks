CREATE OR REPLACE PACKAGE CPI.GIPI_WMORTGAGEE_PKG AS  
    TYPE gipi_wmortgagee_type IS RECORD (
        par_id        gipi_wmortgagee.par_id%TYPE,       
        iss_cd        gipi_wmortgagee.iss_cd%TYPE,
        item_no        gipi_wmortgagee.item_no%TYPE,
        mortg_cd    gipi_wmortgagee.mortg_cd%TYPE,
        mortg_name    giis_mortgagee.mortg_name%TYPE,
        amount        gipi_wmortgagee.amount%TYPE,
        remarks        gipi_wmortgagee.remarks%TYPE,
        last_update    gipi_wmortgagee.last_update%TYPE,
        user_id        gipi_wmortgagee.user_id%TYPE,
        delete_sw      gipi_wmortgagee.delete_sw%TYPE);  --kenneth SR-5483,2743,3708 05.12.16

    TYPE gipi_wmortgagee_tab IS TABLE OF gipi_wmortgagee_type;
  
    FUNCTION get_gipi_wmortgagee (p_par_id IN gipi_wmortgagee.par_id%TYPE)
    RETURN gipi_wmortgagee_tab PIPELINED;
    
    FUNCTION get_all_gipi_wmortgagee (p_par_id IN gipi_wmortgagee.par_id%TYPE)
    RETURN gipi_wmortgagee_tab PIPELINED;
    
    FUNCTION get_gipi_wmortgagee(
        p_par_id     IN gipi_wmortgagee.par_id%TYPE,
        p_item_no    IN gipi_wmortgagee.item_no%TYPE)
    RETURN gipi_wmortgagee_tab PIPELINED;
    
    PROCEDURE set_gipi_wmortgagee (p_gipi_par_mort IN GIPI_WMORTGAGEE%ROWTYPE );
    
    PROCEDURE set_gipi_wmortgagee_1 (
        p_par_id        GIPI_WMORTGAGEE.par_id%TYPE,
        p_iss_cd        GIPI_WMORTGAGEE.iss_cd%TYPE,
        p_item_no        GIPI_WMORTGAGEE.item_no%TYPE,
        p_mortg_cd        GIPI_WMORTGAGEE.mortg_cd%TYPE,
        p_amount        GIPI_WMORTGAGEE.amount%TYPE,
        p_remarks        GIPI_WMORTGAGEE.remarks%TYPE,
        p_last_update    GIPI_WMORTGAGEE.last_update%TYPE,
        p_user_id        GIPI_WMORTGAGEE.user_id%TYPE,
        p_delete_sw      GIPI_WMORTGAGEE.delete_sw%TYPE);	--added delete_sw kenneth SR 5483 05.26.2016
    
    PROCEDURE del_gipi_wmortgagee_item (
        p_par_id    GIPI_WMORTGAGEE.par_id%TYPE,
        p_item_no    GIPI_WMORTGAGEE.item_no%TYPE);
        
    PROCEDURE del_gipi_wmortgagee_1 (
        p_par_id    GIPI_WMORTGAGEE.par_id%TYPE,
        p_item_no    GIPI_WMORTGAGEE.item_no%TYPE,
        p_mortg_cd    GIPI_WMORTGAGEE.mortg_cd%TYPE);
        
    PROCEDURE del_gipi_wmortgagee (p_par_id        GIPI_WMORTGAGEE.par_id%TYPE);
	
	FUNCTION get_gipi_wmortgagee_tg(
        p_par_id IN gipi_wmortgagee.par_id%TYPE,
        p_item_no IN gipi_wmortgagee.item_no%TYPE,
		p_mortg_name IN VARCHAR2,
		p_remarks IN VARCHAR2)
    RETURN gipi_wmortgagee_tab PIPELINED;
    
END GIPI_WMORTGAGEE_PKG;
/


