CREATE OR REPLACE PACKAGE CPI.GIIS_MV_PREM_TYPE_PKG AS

    TYPE giis_mv_prem_type_type IS RECORD(
        mv_type_cd          GIIS_MV_PREM_TYPE.mv_type_cd%TYPE,
        mv_prem_type_cd     GIIS_MV_PREM_TYPE.mv_prem_type_cd%TYPE,
        mv_prem_type_desc   GIIS_MV_PREM_TYPE.mv_prem_type_desc%TYPE,
        remarks             GIIS_MV_PREM_TYPE.remarks%TYPE,
        user_id             GIIS_MV_PREM_TYPE.user_id%TYPE,
        last_update         GIIS_MV_PREM_TYPE.last_update%TYPE
    );
    
    TYPE giis_mv_prem_type_tab IS TABLE OF giis_mv_prem_type_type;
    
    FUNCTION get_giis_mv_prem_type_list(p_mv_type_cd IN GIIS_MV_PREM_TYPE.mv_type_cd%TYPE,
                                        p_find_text  IN VARCHAR2)
        RETURN giis_mv_prem_type_tab PIPELINED;
        
        
    FUNCTION get_mv_prem_type_desc(p_mv_type_cd      IN GIIS_MV_PREM_TYPE.mv_type_cd%TYPE,
                                   p_mv_prem_type_cd IN GIIS_MV_PREM_TYPE.mv_prem_type_cd%TYPE
                                   )
        RETURN VARCHAR2;

END GIIS_MV_PREM_TYPE_PKG; 
/

