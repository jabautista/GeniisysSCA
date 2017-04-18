CREATE OR REPLACE PACKAGE CPI.giiss168_pkg
AS
   TYPE events_lov_type IS RECORD (
      event_cd       giis_events.event_cd%TYPE,
      event_desc     giis_events.event_desc%TYPE,
      receiver_tag   giis_events.receiver_tag%TYPE
   );

   TYPE events_lov_tab IS TABLE OF events_lov_type;

   FUNCTION get_events_lov
      RETURN events_lov_tab PIPELINED;

   TYPE event_module_type IS RECORD (
      event_mod_cd     giis_event_modules.event_mod_cd%TYPE,
      event_cd         giis_event_modules.event_cd%TYPE,
      module_id        giis_event_modules.module_id%TYPE,
      module_desc      giis_modules.module_desc%TYPE,
      user_id          giis_event_modules.user_id%TYPE,
      last_update      VARCHAR2 (50),
      accpt_mod_id     giis_event_modules.accpt_mod_id%TYPE,
      accpt_mod_desc   giis_modules.module_desc%TYPE
   );

   TYPE event_module_tab IS TABLE OF event_module_type;

   FUNCTION get_giis_event_modules (p_event_cd VARCHAR2)
      RETURN event_module_tab PIPELINED;

   TYPE module_type IS RECORD (
      module_id     giis_modules.module_id%TYPE,
      module_desc   giis_modules.module_desc%TYPE
   );

   TYPE module_tab IS TABLE OF module_type;

   FUNCTION get_module_lov
      RETURN module_tab PIPELINED;

   FUNCTION get_selected_modules (p_event_cd VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE save_event_modules (p_rec giis_event_modules%ROWTYPE);

   TYPE passing_user_type IS RECORD (
      event_mod_cd     giis_event_mod_users.event_mod_cd%TYPE,
      passing_userid   giis_event_mod_users.passing_userid%TYPE,
      user_name        giis_users.user_name%TYPE
   );

   TYPE passing_user_tab IS TABLE OF passing_user_type;

   FUNCTION get_passing_user (p_event_mod_cd VARCHAR2)
      RETURN passing_user_tab PIPELINED;

   TYPE receiving_user_type IS RECORD (
      passing_userid   giis_event_mod_users.passing_userid%TYPE,
      userid           giis_event_mod_users.userid%TYPE,
      user_name        giis_users.user_name%TYPE,
      active_tag       giis_event_mod_users.active_tag%TYPE,
      event_user_mod   giis_event_mod_users.event_user_mod%TYPE
   );

   TYPE receiving_user_tab IS TABLE OF receiving_user_type;

   FUNCTION get_receiving_user (p_event_cd VARCHAR2, p_passing_userid VARCHAR2)
      RETURN receiving_user_tab PIPELINED;

   TYPE passing_user_lov_type IS RECORD (
      user_id     giis_users.user_id%TYPE,
      user_name   giis_users.user_name%TYPE
   );

   TYPE passing_user_lov_tab IS TABLE OF passing_user_lov_type;

   FUNCTION get_passing_user_lov (p_event_cd VARCHAR2)
      RETURN passing_user_lov_tab PIPELINED;

   FUNCTION get_event_user_lov (p_event_cd VARCHAR2, p_passing_userid VARCHAR2)
      RETURN passing_user_lov_tab PIPELINED;

   FUNCTION get_selected_passing_users (
      p_event_mod_cd     VARCHAR2,
      p_passing_userid   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_selected_receiving_users (
      p_event_cd         VARCHAR2,
      p_passing_userid   VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE set_passing_users (
      p_event_user_mod   IN OUT   VARCHAR2,
      p_event_mod_cd     IN       VARCHAR2,
      p_user_id          IN       VARCHAR2,
      p_passing_userid   IN       VARCHAR2
   );

   PROCEDURE val_del_passing_users (
      p_event_mod_cd     IN   VARCHAR2,
      p_passing_userid   IN   VARCHAR2
   );

   PROCEDURE set_receiving_users (
      p_event_user_mod   IN   VARCHAR2,
      p_event_mod_cd     IN   VARCHAR2,
      p_userid           IN   VARCHAR2,
      p_user_id          IN   VARCHAR2,
      p_passing_userid   IN   VARCHAR2
   );

   PROCEDURE delete_receiving_users (p_event_user_mod IN VARCHAR2);
END;
/


