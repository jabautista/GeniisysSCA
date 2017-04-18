CREATE OR REPLACE PACKAGE BODY CPI.gipi_user_events_pkg
AS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 12, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get the count of new transactions.
*/
   FUNCTION get_new_tran_count (
      p_userid     gipi_user_events.userid%TYPE,
      p_event_cd   gipi_user_events.event_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_new_tran_cnt   NUMBER := 0;
   BEGIN
      SELECT COUNT (*)
        INTO v_new_tran_cnt
        FROM gipi_user_events z
       WHERE NVL (z.SWITCH, 'N') <> 'Y'
         AND z.userid = NVL (p_userid, z.userid)
         AND z.event_cd = p_event_cd;

      RETURN v_new_tran_cnt;
   END get_new_tran_count;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 12, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get workflow event listing
*/
   FUNCTION get_gipi_user_events_listing (
      p_userid       gipi_user_events.userid%TYPE,
      p_event_desc   giis_events.event_desc%TYPE
   )
      RETURN gipi_user_events_tab PIPELINED
   IS
      v_event   gipi_user_events_type;
   BEGIN
      FOR i IN (SELECT   a.event_cd, b.event_desc, b.event_type,
                         COUNT (*) tran_cnt, b.multiple_assign_sw,
                         b.receiver_tag
                    FROM gipi_user_events a, giis_events b
                   WHERE a.userid = NVL (p_userid, a.userid)
                     AND a.event_cd = b.event_cd
                     AND UPPER (b.event_desc) LIKE
                                            UPPER ('%' || p_event_desc || '%')
                GROUP BY a.event_cd,
                         b.event_desc,
                         b.event_type,
                         b.multiple_assign_sw,
                         b.receiver_tag
                ORDER BY b.event_desc)
      LOOP
         v_event.event_cd := i.event_cd;
         v_event.event_desc := i.event_desc;
         v_event.event_type := i.event_type;
         v_event.tran_cnt := i.tran_cnt;
         v_event.new_tran_cnt := get_new_tran_count (p_userid, i.event_cd);
         v_event.tran_cnt_display :=
               TO_CHAR (i.tran_cnt)
            || ' ('
            || TO_CHAR (v_event.new_tran_cnt)
            || ')';
         v_event.multiple_assign_sw := i.multiple_assign_sw;
         v_event.receiver_tag := i.receiver_tag;
         PIPE ROW (v_event);
      END LOOP;

      RETURN;
   END get_gipi_user_events_listing;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 21, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get workflow event with details listing
*/
   FUNCTION get_event_detail_listing (
      p_event_cd        gipi_user_events.event_cd%TYPE,
      p_user_id         gipi_user_events.user_id%TYPE
   )
      RETURN event_detail_tab PIPELINED
   IS
      v_event_dtl   event_detail_type;
   BEGIN
      FOR i IN (SELECT   a.event_user_mod, a.event_col_cd, a.tran_id,
                         a.col_value, a.SWITCH, ESCAPE_VALUE(a.remarks) remarks, a.event_cd,
                         a.event_mod_cd, a.userid recipient, a.status, b.rv_meaning status_desc,
                         a.date_due
                    FROM gipi_user_events a
                        ,cg_ref_codes b
                   WHERE a.event_cd = p_event_cd
                     AND b.rv_domain (+) = 'GIPI_USER_EVENTS.STATUS'
                     AND b.rv_low_value (+) = a.status
                     AND a.userid = NVL (p_user_id, a.userid)
                ORDER BY a.last_update DESC)
      LOOP
         v_event_dtl.event_user_mod := i.event_user_mod;
         v_event_dtl.event_col_cd := i.event_col_cd;
         v_event_dtl.tran_id := i.tran_id;
         v_event_dtl.col_value := i.col_value;
         v_event_dtl.SWITCH := i.SWITCH;
         v_event_dtl.remarks := i.remarks;
         v_event_dtl.event_cd := i.event_cd;
         v_event_dtl.event_mod_cd := i.event_mod_cd;
         v_event_dtl.recipient := i.recipient;
         v_event_dtl.status := i.status;
         v_event_dtl.status_desc := i.status_desc;
         v_event_dtl.date_due := TRUNC(i.date_due);
         gipi_user_events_hist_pkg.get_old_userid_date_received
                                                   (i.tran_id,
                                                    v_event_dtl.sender,
                                                    v_event_dtl.date_received
                                                   );
         get_tran_dtl (i.event_cd,
                       i.event_mod_cd,
                       i.event_col_cd,
                       i.col_value,
                       v_event_dtl.tran_dtl
                      );
         PIPE ROW (v_event_dtl);
      END LOOP;

      RETURN;
   END get_event_detail_listing;

   FUNCTION get_tran_list (p_event_cd gipi_user_events.event_cd%TYPE)
      RETURN tran_list_tab PIPELINED
   IS
      v_tran    tran_list_type;
      v_query   VARCHAR2 (32000);

      TYPE v_cur_type IS REF CURSOR;

      v_cur     v_cur_type;
   BEGIN
      v_query := wf.get_workflow_tran_list (p_event_cd);

      OPEN v_cur FOR v_query;

      LOOP
         FETCH v_cur
          INTO v_tran.col_value, v_tran.tran_dtl;

         PIPE ROW (v_tran);
         EXIT WHEN v_cur%NOTFOUND;
      END LOOP;

      CLOSE v_cur;

      RETURN;
   END get_tran_list;

   PROCEDURE set_workflow_gicls010 (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
   IS
   v_count number:=0;
   v_message varchar2(1000);
   v_workflow_msg varchar2(1000);
   BEGIN
      FOR c1 IN (SELECT b.userid, d.event_desc
	               FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
	              WHERE 1=1
	                AND c.event_cd = a.event_cd
	                AND c.event_mod_cd = a.event_mod_cd
	                AND b.event_mod_cd = a.event_mod_cd
	                AND b.passing_userid = USER
	                AND a.module_id = 'GICLS010'
	                AND a.event_cd = d.event_cd
	                AND UPPER(d.event_desc) = 'UNPAID PREMIUMS WITH CLAIMS')
	  LOOP
	    BEGIN
	      SELECT 1
	        INTO v_count
	        FROM gicl_claims
	       WHERE claim_id = p_claim_id
	         AND clm_stat_cd = 'NO';
	    EXCEPTION
	    	WHEN NO_DATA_FOUND THEN
	    	   NULL;
	    END;
        IF v_count <> 0 AND p_clm_stat_cd = 'Y' THEN
	       CREATE_TRANSFER_WORKFLOW_REC('UNPAID PREMIUMS WITH CLAIMS','GICLS010', c1.userid, p_claim_id, c1.event_desc||' '||get_clm_no(p_claim_id), v_message, v_workflow_msg, NVL(giis_users_pkg.app_user,USER));
	    END IF;
      END LOOP;
   END;


/*
**  Created by   :  Andrew. Robes
**  Date Created :  09.22.2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get workflow events listing by date sent
*/
   FUNCTION get_sent_events_by_date_sent (p_user_id      GIIS_USERS.user_id%TYPE,
                                          p_date         VARCHAR2,
                                          p_event_desc   GIIS_EVENTS.event_desc%TYPE)
     RETURN gipi_user_events_tab PIPELINED
   IS
      v_event   gipi_user_events_type;
   BEGIN
      FOR i IN (SELECT a.event_cd, a.event_desc
                  FROM giis_events a
                 WHERE EXISTS (
                               SELECT 1
                                 FROM gipi_user_events_hist z
                                WHERE 1 = 1
                                  AND z.event_cd = a.event_cd
                                  AND z.old_userid = p_user_id
                                  AND TRUNC(z.date_received) = TO_DATE(p_date, 'MM-DD-YYYY'))
                   AND UPPER (a.event_desc) LIKE UPPER ('%' || p_event_desc || '%'))
      LOOP
         v_event.event_cd := i.event_cd;
         v_event.event_desc := i.event_desc;

         PIPE ROW (v_event);
      END LOOP;

      RETURN;
   END get_sent_events_by_date_sent;

/*
**  Created by   :  Andrew. Robes
**  Date Created :  09.22.2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get workflow events listing by date range
--*/
   FUNCTION get_sent_events_by_date_range (p_user_id      GIIS_USERS.user_id%TYPE,
                                           p_date_from    VARCHAR2,
                                           p_date_to      VARCHAR2,
                                           p_event_desc   GIIS_EVENTS.event_desc%TYPE)
     RETURN gipi_user_events_tab PIPELINED
   IS
      v_event   gipi_user_events_type;
   BEGIN
      FOR i IN (SELECT a.event_cd, a.event_desc
                  FROM giis_events a
                 WHERE EXISTS (
                               SELECT 1
                                 FROM gipi_user_events_hist z
                                WHERE 1 = 1
                                  AND z.event_cd = a.event_cd
                                  AND z.old_userid = p_user_id
                                  AND TRUNC(z.date_received)
                                        BETWEEN TO_DATE(p_date_from, 'MM-DD-YYYY')
                                            AND TO_DATE(p_date_to, 'MM-DD-YYYY'))
                   AND UPPER (a.event_desc) LIKE UPPER ('%' || p_event_desc || '%'))
      LOOP
         v_event.event_cd := i.event_cd;
         v_event.event_desc := i.event_desc;

         PIPE ROW (v_event);
      END LOOP;

      RETURN;
   END get_sent_events_by_date_range;

END gipi_user_events_pkg;
/


