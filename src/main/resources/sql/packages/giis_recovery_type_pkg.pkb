CREATE OR REPLACE PACKAGE BODY CPI.giis_recovery_type_pkg
AS
    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.13.2012  
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  getting recovery type LOV 
    */
    FUNCTION get_giis_recovery_type 
    RETURN giis_recovery_type_tab PIPELINED IS
      v_list            giis_recovery_type_type;
    BEGIN
        FOR i IN (SELECT rec_type_cd, rec_type_desc
                    FROM giis_recovery_type
                ORDER BY rec_type_desc)
        LOOP
            v_list.rec_type_cd      := i.rec_type_cd;
            v_list.rec_type_desc    := i.rec_type_desc;
        PIPE ROW(v_list);  
        END LOOP;
      RETURN;    
    END;    

    --shan 03.15.2013 for GICLS201 - Claims Recovery Register
    PROCEDURE get_rec_type_desc_gicls201(
        p_rec_type_cd   IN  GIIS_RECOVERY_TYPE.REC_TYPE_CD%TYPE,
        p_rec_type_desc OUT GIIS_RECOVERY_TYPE.REC_TYPE_DESC%TYPE,
        p_found         OUT VARCHAR2
    )
    IS
        v_rec_type_desc   GIIS_RECOVERY_TYPE.REC_TYPE_DESC%TYPE;
    BEGIN
        SELECT rec_type_desc
          INTO v_rec_type_desc
          FROM GIIS_RECOVERY_TYPE
         WHERE rec_type_cd = p_rec_type_cd;
         
        p_rec_type_desc := v_rec_type_desc;
        
        IF v_rec_type_desc IS NULL THEN
            p_found := 'N';
        ELSE
            p_found := 'Y';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_found := 'N';
            
    END get_rec_type_desc_gicls201;  
    
END giis_recovery_type_pkg;
/


