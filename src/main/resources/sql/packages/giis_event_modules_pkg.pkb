CREATE OR REPLACE PACKAGE BODY CPI.GIIS_EVENT_MODULES_PKG AS

/**
* Created by: Andrew Robes
* Date Created : 07.27.2011
* Referenced By : (WORKFLOW - Workflow)
* Description : Retrieves the giis_event_modules records
*/
    FUNCTION get_giis_event_modules_listing(p_event_cd GIIS_EVENTS.event_cd%TYPE)
      RETURN giis_event_modules_tab PIPELINED
    IS
      v_mod giis_event_modules_type;
    BEGIN
      FOR i IN (
        SELECT a.event_cd, a.module_id, b.module_desc, a.accpt_mod_id, c.module_desc accpt_mod_desc
          FROM giis_event_modules a
              ,giis_modules b
              ,giis_modules c
         WHERE a.event_cd = p_event_cd 
           AND a.module_id = b.module_id
           AND a.accpt_mod_id = c.module_id)
      LOOP
        v_mod.event_cd := i.event_cd;
        v_mod.module_id := i.module_id;
        v_mod.accpt_mod_id := i.accpt_mod_id;
        v_mod.module_desc := i.module_desc;
        v_mod.accpt_mod_desc := i.accpt_mod_desc;
        
        PIPE ROW(v_mod);
      END LOOP;
      RETURN;
    END get_giis_event_modules_listing;


    FUNCTION get_event_mod_cd (p_event_cd giis_event_modules.event_mod_cd%TYPE,
                               p_event_type giis_events.event_type%TYPE)
       RETURN NUMBER
    IS
      v_event_mod_cd NUMBER; 
    BEGIN
       IF p_event_type = 5
          AND wf.get_workflow_tran_list(p_event_cd) IS NULL
       THEN
          BEGIN
             SELECT b.event_mod_cd
               INTO v_event_mod_cd
               FROM giis_event_modules b
              WHERE b.event_cd = p_event_cd;
          EXCEPTION
             WHEN OTHERS
             THEN
                v_event_mod_cd := NULL;
          END;          
       ELSE
          BEGIN
             SELECT a.event_mod_cd
               INTO v_event_mod_cd
               FROM giis_events_column a, giis_event_modules b
              WHERE a.event_cd = p_event_cd
                AND a.event_cd = b.event_cd
                AND a.event_mod_cd = b.event_mod_cd;
          EXCEPTION
             WHEN OTHERS
             THEN
                v_event_mod_cd := NULL;
          END;
       END IF;
       
       RETURN v_event_mod_cd;
    END get_event_mod_cd;

END GIIS_EVENT_MODULES_PKG;
/


