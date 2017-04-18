CREATE OR REPLACE PACKAGE CPI.GIIS_INTM_TYPE_PKG AS

    TYPE intm_type_rec IS RECORD(
        intm_type           GIIS_INTM_TYPE.intm_type%TYPE,
        intm_desc           GIIS_INTM_TYPE.intm_desc%TYPE,
        acct_intm_cd        GIIS_INTM_TYPE.acct_intm_cd%TYPE,
        user_id             GIIS_INTM_TYPE.user_id%TYPE,
        last_update         GIIS_INTM_TYPE.last_update%TYPE,
        remarks             GIIS_INTM_TYPE.remarks%TYPE,
        cpi_rec_no          GIIS_INTM_TYPE.cpi_rec_no%TYPE,
        cpi_branch_cd       GIIS_INTM_TYPE.cpi_branch_cd%TYPE
    );
    TYPE intm_type_tab IS TABLE OF intm_type_rec;
    
    TYPE intm_type_listing_type IS RECORD(
        intm_type           GIIS_INTM_TYPE.intm_type%TYPE,
        intm_desc           GIIS_INTM_TYPE.intm_desc%TYPE
    );
    TYPE intm_type_listing_tab IS TABLE OF intm_type_listing_type;
    
    FUNCTION get_intm_type_listing
      RETURN intm_type_listing_tab PIPELINED;
      
    PROCEDURE validate_intm_type(
        p_intm_type     IN      GIIS_INTM_TYPE.intm_TYPE%TYPE,
        p_intm_desc     OUT     GIIS_INTM_TYPE.intm_desc%TYPE
    );
    
    FUNCTION get_intm_type_lov
        RETURN intm_type_listing_tab PIPELINED;
        
    FUNCTION get_giacs288_intm_type_lov(
        p_find_text             GIIS_INTM_TYPE.intm_type%TYPE
    )
      RETURN intm_type_listing_tab PIPELINED;
    

END GIIS_INTM_TYPE_PKG;
/


