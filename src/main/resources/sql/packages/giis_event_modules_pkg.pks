CREATE OR REPLACE PACKAGE CPI.GIIS_EVENT_MODULES_PKG AS

    TYPE giis_event_modules_type IS RECORD (
      event_cd          GIIS_EVENT_MODULES.event_cd%TYPE,
      module_id         GIIS_MODULES.module_id%TYPE,
      module_desc       GIIS_MODULES.module_desc%TYPE,     
      accpt_mod_id      GIIS_MODULES.module_id%TYPE,
      accpt_mod_desc    GIIS_MODULES.module_desc%TYPE
    );
    
    TYPE giis_event_modules_tab IS TABLE OF giis_event_modules_type;
    
    FUNCTION get_giis_event_modules_listing(p_event_cd GIIS_EVENTS.event_cd%TYPE) 
      RETURN giis_event_modules_tab PIPELINED;

    FUNCTION get_event_mod_cd (p_event_cd giis_event_modules.event_mod_cd%TYPE,
                               p_event_type giis_events.event_type%TYPE)
       RETURN NUMBER;

END GIIS_EVENT_MODULES_PKG;
/


