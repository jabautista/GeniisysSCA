CREATE OR REPLACE PACKAGE CPI.GIIS_EVENT_MOD_USERS_PKG AS

    FUNCTION validate_passing_user(p_passing_userid GIIS_EVENT_MOD_USERS.passing_userid%TYPE,
                                   p_event_cd   GIIS_EVENTS.event_cd%TYPE,
                                   p_event_type   GIIS_EVENTS.event_type%TYPE)
      RETURN VARCHAR2;
    
END GIIS_EVENT_MOD_USERS_PKG;
/


