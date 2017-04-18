CREATE OR REPLACE PACKAGE BODY CPI.GIIS_EVENT_MOD_USERS_PKG AS

  /*
  **  Created by   : Andrew Robes 
  **  Date Created : 09.29.2011 
  **  Reference By : (WOFLO01 - Workflow)  
  **  Description  : Function to validate if passing user is authorized to transfer transactions 
  */ 
    FUNCTION validate_passing_user(p_passing_userid GIIS_EVENT_MOD_USERS.passing_userid%TYPE,
                                   p_event_cd   GIIS_EVENTS.event_cd%TYPE,
                                   p_event_type   GIIS_EVENTS.event_type%TYPE)
      RETURN VARCHAR2
    IS
      v_tag VARCHAR2(1) := 'N';
      v_event_mod_cd GIIS_EVENT_MOD_USERS.event_mod_cd%TYPE;
    BEGIN
      v_event_mod_cd := GIIS_EVENT_MODULES_PKG.get_event_mod_cd(p_event_cd, p_event_type);
      
      FOR A IN ( 
        SELECT 1 
          FROM giis_event_mod_users a
         WHERE a.passing_userid = p_passing_userid 
           AND a.event_mod_cd = v_event_mod_cd) 
      LOOP	
        v_tag := 'Y';
      END LOOP;
      RETURN(v_tag);
    END validate_passing_user; 
    
END GIIS_EVENT_MOD_USERS_PKG;
/


