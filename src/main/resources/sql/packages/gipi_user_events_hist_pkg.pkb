CREATE OR REPLACE PACKAGE BODY CPI.GIPI_USER_EVENTS_HIST_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 27, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Procedure to get the old_userid and date received by tran_id
*/
  PROCEDURE get_old_userid_date_received(p_tran_id           GIPI_USER_EVENTS_HIST.tran_id%TYPE,
                                         p_old_userid    OUT GIPI_USER_EVENTS_HIST.old_userid%TYPE,
                                         p_date_received OUT GIPI_USER_EVENTS_HIST.date_received%TYPE)
  IS
  BEGIN
    FOR C2 IN (
      SELECT old_userid, date_received
       FROM gipi_user_events_hist
      WHERE tran_id = p_tran_id
      ORDER BY date_received DESC)
    LOOP
      p_old_userid    := c2.old_userid;
      p_date_received := TRUNC(c2.date_received);
      EXIT;
    END LOOP;
  END get_old_userid_date_received;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 21, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Procedure to get the user events history listing
*/
  FUNCTION get_user_events_hist_listing
    RETURN gipi_user_events_hist_tab PIPELINED IS

    v_hist gipi_user_events_hist_type;

  BEGIN
    FOR i IN (
      SELECT a.event_cd, a.event_desc, b.date_received, b.new_userid, b.remarks, b.tran_id
        FROM GIIS_EVENTS a
            ,GIPI_USER_EVENTS_HIST b
       WHERE a.event_cd = b.event_cd
         AND TRUNC(b.date_received) = TRUNC(sysdate))
    LOOP
      v_hist.event_cd        := i.event_cd;
      v_hist.event_desc      := i.event_desc;
      v_hist.date_received   := i.date_received;
      v_hist.new_userid      := i.new_userid;
      v_hist.remarks         := i.remarks;
      v_hist.tran_id         := i.tran_id;
      PIPE ROW(v_hist);
    END LOOP;
    RETURN;
  END get_user_events_hist_listing;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  September 7, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Procedure to get the user events history listing
*/
  FUNCTION get_user_events_hist_list(p_tran_id GIPI_USER_EVENTS_HIST.tran_id%TYPE)
    RETURN gipi_user_events_hist_tab PIPELINED IS

    v_hist gipi_user_events_hist_type;

  BEGIN
    FOR i IN (
      SELECT a.event_cd, TO_CHAR(a.date_received, 'MM-DD-YYYY HH:MM:SS AM') date_received, a.new_userid, ESCAPE_VALUE(a.remarks) remarks, a.tran_id, a.old_userid
        FROM GIPI_USER_EVENTS_HIST a
       WHERE a.tran_id = p_tran_id)
    LOOP
      v_hist.event_cd        := i.event_cd;
      v_hist.date_received   := i.date_received;
      v_hist.new_userid      := i.new_userid;
      v_hist.old_userid      := i.old_userid;
      v_hist.remarks         := i.remarks;
      v_hist.tran_id         := i.tran_id;
      PIPE ROW(v_hist);
    END LOOP;
    RETURN;
  END get_user_events_hist_list;

/*
**  Created by   :  Andrew. Robes
**  Date Created :  09.22.2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get workflow event hist listing by date sent
*/
  FUNCTION get_events_hist_by_date_sent(p_user_id    GIIS_USERS.user_id%TYPE,
                                        p_event_cd   GIIS_EVENTS.event_cd%TYPE,
                                        p_date       VARCHAR2,
                                        p_new_userid    GIPI_USER_EVENTS_HIST.new_userid%TYPE,
                                        p_date_received VARCHAR2,
                                        p_remarks       GIPI_USER_EVENTS_HIST.remarks%TYPE,
                                        p_tran_id       GIPI_USER_EVENTS_HIST.tran_id%TYPE)
    RETURN gipi_user_events_hist_tab PIPELINED
  IS
    v_hist gipi_user_events_hist_type;
  BEGIN
    FOR i IN (
      SELECT a.event_cd, a.new_userid, a.tran_id, TO_CHAR(a.date_received, 'MM-DD-YYYY HH:MM:SS AM') date_received, a.remarks
        FROM gipi_user_events_hist a
            ,giis_events b
       WHERE a.event_cd = p_event_cd
         AND b.event_cd = a.event_cd
         AND a.old_userid = p_user_id
         AND TRUNC (a.date_received) = TO_DATE(p_date, 'MM-DD-YYYY')
         AND UPPER (a.new_userid) LIKE UPPER (NVL(p_new_userid, a.new_userid))
         AND TRUNC (a.date_received) = NVL(TO_DATE(p_date_received, 'MM-DD-YYYY'),TRUNC(a.date_received))
         AND UPPER (NVL(a.remarks, '*')) LIKE UPPER(NVL(p_remarks, NVL(a.remarks, '*')))
         AND a.tran_id = NVL(p_tran_id, a.tran_id))
    LOOP
      v_hist.event_cd := i.event_cd;
      v_hist.new_userid := i.new_userid;
      v_hist.tran_id := i.tran_id;
      v_hist.date_received := i.date_received;
      v_hist.remarks := i.remarks;

      PIPE ROW(v_hist);
    END LOOP;
    RETURN;
  END get_events_hist_by_date_sent;

/*
**  Created by   :  Andrew. Robes
**  Date Created :  09.22.2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get workflow event hist listing by date range
*/
  FUNCTION get_events_hist_by_date_range(p_user_id    GIIS_USERS.user_id%TYPE,
                                        p_event_cd    GIIS_EVENTS.event_cd%TYPE,
                                        p_date_from   VARCHAR2,
                                        p_date_to     VARCHAR2,
                                        p_new_userid    GIPI_USER_EVENTS_HIST.new_userid%TYPE,
                                        p_date_received VARCHAR2,
                                        p_remarks       GIPI_USER_EVENTS_HIST.remarks%TYPE,
                                        p_tran_id       GIPI_USER_EVENTS_HIST.tran_id%TYPE)
    RETURN gipi_user_events_hist_tab PIPELINED
  IS
    v_hist gipi_user_events_hist_type;
  BEGIN
    FOR i IN (
      SELECT a.event_cd, c.event_mod_cd, a.event_col_cd, a.col_value,
             a.new_userid, a.tran_id, TO_CHAR(a.date_received, 'MM-DD-YYYY HH:MM:SS AM') date_received, a.remarks
        FROM gipi_user_events_hist a
            ,giis_events b
            ,giis_event_mod_users c
       WHERE a.event_cd = p_event_cd
         AND a.event_cd = b.event_cd
         AND a.event_user_mod = c.event_user_mod
         AND a.old_userid = p_user_id
         AND TRUNC(a.date_received)
             BETWEEN TO_DATE(p_date_from, 'MM-DD-YYYY')
                 AND TO_DATE(p_date_to, 'MM-DD-YYYY')
         AND UPPER (a.new_userid) LIKE UPPER (NVL(p_new_userid, a.new_userid))
         AND TRUNC (a.date_received) = NVL(TO_DATE(p_date_received, 'MM-DD-YYYY'),TRUNC(a.date_received))
         AND UPPER (NVL(a.remarks, '*')) LIKE UPPER(NVL(p_remarks, NVL(a.remarks, '*')))
         AND a.tran_id = NVL(p_tran_id, a.tran_id)
         )
    LOOP
      v_hist.event_cd := i.event_cd;
      v_hist.new_userid := i.new_userid;
      v_hist.tran_id := i.tran_id;
      v_hist.date_received := i.date_received;
      v_hist.remarks := i.remarks;
      get_tran_dtl (i.event_cd,
                    i.event_mod_cd,
                    i.event_col_cd,
                    i.col_value,
                    v_hist.tran_dtl);
      PIPE ROW(v_hist);
    END LOOP;
    RETURN;
  END get_events_hist_by_date_range;

END GIPI_USER_EVENTS_HIST_PKG;
/


