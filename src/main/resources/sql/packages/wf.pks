CREATE OR REPLACE PACKAGE CPI.Wf IS
/*
--  Created By: A.R.C.
--  Created On: 11/08/2004
--  Remarks   : This package was created to contain all procedures, functions used
--              in WORKFLOW.
*/
  FUNCTION get_workflow_disp_column(p_disp_column IN VARCHAR2,p_table IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_workflow_tran_list(p_event_cd IN NUMBER) RETURN VARCHAR2;
  FUNCTION workflow_update_user(p_event_cd IN NUMBER, p_user IN VARCHAR2, p_col_value IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_popup_dir RETURN VARCHAR2;
  FUNCTION get_display_value(p_input IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION check_wf_user(p_event_mod_cd IN NUMBER, p_passing_userid IN VARCHAR2,p_userid IN VARCHAR2) RETURN BOOLEAN;
  
  PROCEDURE save_created_event(p_create        VARCHAR2,
                               p_event_cd      IN GIIS_EVENTS.event_cd%TYPE,
                               p_event_type    IN GIIS_EVENTS.event_type%TYPE,
                               p_user_id       IN GIIS_USERS.user_id%TYPE,
                               p_remarks       IN GIPI_USER_EVENTS.remarks%TYPE,
                               p_status        IN GIPI_USER_EVENTS.status%TYPE,
                               p_date_due      IN VARCHAR2,
                               p_col_value     IN VARCHAR2,
                               p_tran_dtl      IN VARCHAR2,
                               p_message_type  OUT VARCHAR2,
                               p_message       OUT VARCHAR2);
  
  PROCEDURE transfer_event (
       p_tran_id          IN       gipi_user_events.tran_id%TYPE,
       p_event_mod_cd     IN       gipi_user_events.event_mod_cd%TYPE,
       p_event_col_cd     IN       gipi_user_events.event_col_cd%TYPE,
       p_event_user_mod   IN       gipi_user_events.event_user_mod%TYPE,
       p_user_id          IN       giis_users.user_id%TYPE,
       p_remarks          IN       gipi_user_events.remarks%TYPE,
       p_status           IN       gipi_user_events.status%TYPE,
       p_date_due         IN       VARCHAR2,--gipi_user_events.date_due%TYPE,
       p_event_cd           IN     gipi_user_events.event_cd%TYPE,
       p_event_type         IN     giis_events.event_type%TYPE,       
       p_multiple_assign_sw IN     giis_events.multiple_assign_sw%TYPE,       
       p_receiver_tag     IN       giis_events.receiver_tag%TYPE,
       p_message_type     OUT      VARCHAR2,
       p_message          OUT      VARCHAR2
    );
  
  PROCEDURE del_gipi_user_event(
    p_event_user_mod GIPI_USER_EVENTS.event_user_mod%TYPE,
    p_event_col_cd   GIPI_USER_EVENTS.event_col_cd%TYPE,
    p_tran_id        GIPI_USER_EVENTS.tran_id%TYPE);  
  
  PROCEDURE del_event(p_event_user_mod GIPI_USER_EVENTS.event_user_mod%TYPE,
                      p_event_col_cd   GIPI_USER_EVENTS.event_col_cd%TYPE,
                      p_tran_id        GIPI_USER_EVENTS.tran_id%TYPE,
                      p_user_id        GIIS_USERS.user_id%TYPE);

  PROCEDURE update_event_status(p_event_user_mod GIPI_USER_EVENTS.event_user_mod%TYPE,
                                p_event_col_cd   GIPI_USER_EVENTS.event_col_cd%TYPE,
                                p_tran_id        GIPI_USER_EVENTS.tran_id%TYPE,
                                p_status         GIPI_USER_EVENTS.status%TYPE);                      
  
END;
/


