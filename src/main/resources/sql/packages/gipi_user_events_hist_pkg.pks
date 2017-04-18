CREATE OR REPLACE PACKAGE CPI.GIPI_USER_EVENTS_HIST_PKG AS

  PROCEDURE get_old_userid_date_received(p_tran_id           GIPI_USER_EVENTS_HIST.tran_id%TYPE,
                                         p_old_userid    OUT GIPI_USER_EVENTS_HIST.old_userid%TYPE,
                                         p_date_received OUT GIPI_USER_EVENTS_HIST.date_received%TYPE);

  TYPE gipi_user_events_hist_type IS RECORD (
    tran_dtl        VARCHAR2(300),
    event_cd        GIIS_EVENTS.event_cd%TYPE,
    event_desc      GIIS_EVENTS.event_desc%TYPE,
    date_received   VARCHAR2(100),
    new_userid      GIPI_USER_EVENTS_HIST.new_userid%TYPE,
    old_userid      GIPI_USER_EVENTS_HIST.old_userid%TYPE,
    remarks         GIPI_USER_EVENTS_HIST.remarks%TYPE,
    tran_id         GIPI_USER_EVENTS_HIST.tran_id%TYPE
  );
  
  TYPE gipi_user_events_hist_tab IS TABLE OF gipi_user_events_hist_type;
  
  FUNCTION get_user_events_hist_listing 
    RETURN gipi_user_events_hist_tab PIPELINED;
    
  FUNCTION get_user_events_hist_list(p_tran_id GIPI_USER_EVENTS_HIST.tran_id%TYPE)
    RETURN gipi_user_events_hist_tab PIPELINED;
    
  FUNCTION get_events_hist_by_date_sent(p_user_id    GIIS_USERS.user_id%TYPE,
                                        p_event_cd   GIIS_EVENTS.event_cd%TYPE,
                                        p_date       VARCHAR2,
                                        p_new_userid    GIPI_USER_EVENTS_HIST.new_userid%TYPE,
                                        p_date_received VARCHAR2,
                                        p_remarks       GIPI_USER_EVENTS_HIST.remarks%TYPE,
                                        p_tran_id       GIPI_USER_EVENTS_HIST.tran_id%TYPE)
    RETURN gipi_user_events_hist_tab PIPELINED;

  FUNCTION get_events_hist_by_date_range(p_user_id    GIIS_USERS.user_id%TYPE,
                                        p_event_cd    GIIS_EVENTS.event_cd%TYPE,
                                        p_date_from   VARCHAR2,
                                        p_date_to     VARCHAR2,
                                        p_new_userid    GIPI_USER_EVENTS_HIST.new_userid%TYPE,
                                        p_date_received VARCHAR2,
                                        p_remarks       GIPI_USER_EVENTS_HIST.remarks%TYPE,
                                        p_tran_id       GIPI_USER_EVENTS_HIST.tran_id%TYPE)
    RETURN gipi_user_events_hist_tab PIPELINED;

END GIPI_USER_EVENTS_HIST_PKG;
/


