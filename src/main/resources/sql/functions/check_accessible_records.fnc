DROP FUNCTION CPI.CHECK_ACCESSIBLE_RECORDS;

CREATE OR REPLACE FUNCTION CPI.check_accessible_records RETURN VARCHAR2 IS
    v_users     GIPI_PARLIST.underwriter%TYPE;
    v_user_sw   GIIS_USERS.all_user_sw%TYPE;
    
    /*
    **  Created by    : D. Alcantara
    **  Date Created  : Nov. 12, 2010
    **  Reference By  : 
    **  Description   : Used for determining which par is accessible for the user currently logged in
    */ 
   BEGIN
        SELECT all_user_sw INTO v_user_sw FROM GIIS_USERS where user_id = user;
        IF v_user_sw = 'Y'
        THEN
            v_users := '%';      
        ELSE
            v_users := user;
        END IF;
   RETURN v_users; 
END check_accessible_records;
/


