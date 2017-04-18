CREATE OR REPLACE PACKAGE CPI.GICL_LE_STAT_PKG AS

    TYPE gicl_le_stat_type IS RECORD(
        le_stat_cd          GICL_LE_STAT.le_stat_cd%TYPE,           
        le_stat_desc        GICL_LE_STAT.le_stat_desc%TYPE,
        remarks             GICL_LE_STAT.remarks%TYPE,
        user_id             GICL_LE_STAT.user_id%TYPE,
        last_update         GICL_LE_STAT.last_update%TYPE 
    );
    
    TYPE gicl_le_stat_tab IS TABLE OF gicl_le_stat_type;
    
    FUNCTION get_all_gicl_le_stat(p_keyword IN VARCHAR)
    RETURN gicl_le_stat_tab PIPELINED;


END GICL_LE_STAT_PKG;
/


