CREATE OR REPLACE PACKAGE CPI.giis_recovery_type_pkg
AS

    TYPE giis_recovery_type_type IS RECORD(
        rec_type_cd             giis_recovery_type.rec_type_cd%TYPE,
        rec_type_desc           giis_recovery_type.rec_type_desc%TYPE,
        remarks                 giis_recovery_type.remarks%TYPE,
        cpi_rec_no              giis_recovery_type.cpi_rec_no%TYPE,
        cpi_branch_cd           giis_recovery_type.cpi_branch_cd%TYPE,
        user_id        		    giis_recovery_type.user_id%TYPE,
        last_update    		    giis_recovery_type.last_update%TYPE
        );
        
    TYPE giis_recovery_type_tab IS TABLE OF giis_recovery_type_type;
    
    FUNCTION get_giis_recovery_type 
    RETURN giis_recovery_type_tab PIPELINED;
    
    --shan 03.15.2013
    PROCEDURE get_rec_type_desc_gicls201(
        p_rec_type_cd   IN  GIIS_RECOVERY_TYPE.REC_TYPE_CD%TYPE,
        p_rec_type_desc OUT GIIS_RECOVERY_TYPE.REC_TYPE_DESC%TYPE,
        p_found         OUT VARCHAR2
    ) ;    

END giis_recovery_type_pkg;
/


