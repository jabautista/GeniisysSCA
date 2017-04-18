CREATE OR REPLACE PACKAGE BODY CPI.giiss220_pkg
AS
   FUNCTION get_line_lov (
      p_find_text   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_row   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE (   UPPER (line_cd) LIKE
                                            UPPER (NVL (p_find_text, line_cd))
                          OR     UPPER (line_name) LIKE
                                          UPPER (NVL (p_find_text, line_name))
                             AND check_user_per_line2 (line_cd,
                                                       NULL,
                                                       'GIISS220',
                                                       p_user_id
                                                      ) = 1
                         )
                ORDER BY line_cd)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW (v_row);
      END LOOP;
   END;

   FUNCTION get_subline_lov (
      p_line_cd     giis_subline.line_cd%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN subline_lov_tab PIPELINED
   IS
      v_row   subline_lov_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                     AND (   UPPER (subline_cd) LIKE
                                         UPPER (NVL (p_find_text, subline_cd))
                          OR UPPER (subline_name) LIKE
                                       UPPER (NVL (p_find_text, subline_name))
                         )
                ORDER BY subline_cd)
      LOOP
         v_row.subline_cd := i.subline_cd;
         v_row.subline_name := i.subline_name;
         PIPE ROW (v_row);
      END LOOP;
   END;

   FUNCTION get_peril_listing (
      p_line_cd        giis_peril.line_cd%TYPE,
      p_peril_cd       giis_peril.peril_cd%TYPE,
      p_peril_sname    giis_peril.peril_sname%TYPE,
      p_peril_name     giis_peril.peril_name%TYPE,
      p_default_rate   giis_peril.default_rate%TYPE
   )
      RETURN peril_tab PIPELINED
   IS
      v_row   peril_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_peril
                   WHERE line_cd = p_line_cd
                     AND peril_cd = NVL (p_peril_cd, peril_cd)
                     AND UPPER (peril_sname) LIKE
                                      UPPER (NVL (p_peril_sname, peril_sname))
                     AND UPPER (peril_name) LIKE
                                        UPPER (NVL (p_peril_name, peril_name))
                     AND NVL (default_rate, -1) LIKE
                                   NVL (p_default_rate, NVL (default_rate, -1))
                ORDER BY peril_cd)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.peril_cd := i.peril_cd;
         v_row.peril_sname := i.peril_sname;
         v_row.peril_name := i.peril_name;
         v_row.default_rate := i.default_rate;
         PIPE ROW (v_row);
      END LOOP;
   END;

   FUNCTION get_slid_comm_listing (
      p_line_cd        giis_slid_comm.line_cd%TYPE,
      p_subline_cd     giis_slid_comm.subline_cd%TYPE,
      p_peril_cd       giis_slid_comm.peril_cd%TYPE,
      p_lo_prem_lim    giis_slid_comm.lo_prem_lim%TYPE,
      p_hi_prem_lim    giis_slid_comm.hi_prem_lim%TYPE,
      p_slid_comm_rt   giis_slid_comm.slid_comm_rt%TYPE
   )
      RETURN slid_comm_tab PIPELINED
   IS
      v_row   slid_comm_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_slid_comm
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND peril_cd = p_peril_cd
                   AND lo_prem_lim = NVL (p_lo_prem_lim, lo_prem_lim)
                   AND hi_prem_lim = NVL (p_hi_prem_lim, hi_prem_lim)
                   AND slid_comm_rt = NVL (p_slid_comm_rt, slid_comm_rt))
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.peril_cd := i.peril_cd;
         v_row.lo_prem_lim := i.lo_prem_lim;
         v_row.hi_prem_lim := i.hi_prem_lim;
         v_row.slid_comm_rt := i.slid_comm_rt;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_row.old_lo_prem_lim := i.lo_prem_lim;
         v_row.old_hi_prem_lim := i.hi_prem_lim;
         PIPE ROW (v_row);
      END LOOP;
   END;

   FUNCTION get_history_listing (
      p_line_cd            giis_slid_comm_hist.line_cd%TYPE,
      p_subline_cd         giis_slid_comm_hist.subline_cd%TYPE,
      p_peril_cd           giis_slid_comm_hist.peril_cd%TYPE,
      p_old_lo_prem_lim    giis_slid_comm_hist.old_lo_prem_lim%TYPE,
      p_lo_prem_lim        giis_slid_comm_hist.lo_prem_lim%TYPE,
      p_old_hi_prem_lim    giis_slid_comm_hist.old_hi_prem_lim%TYPE,
      p_hi_prem_lim        giis_slid_comm_hist.hi_prem_lim%TYPE,
      p_old_slid_comm_rt   giis_slid_comm_hist.old_slid_comm_rt%TYPE,
      p_slid_comm_rt       giis_slid_comm_hist.slid_comm_rt%TYPE
   )
      RETURN history_tab PIPELINED
   IS
      v_row   history_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_slid_comm_hist
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND peril_cd = p_peril_cd
                     AND old_lo_prem_lim =
                                      NVL (p_old_lo_prem_lim, old_lo_prem_lim)
                     AND lo_prem_lim = NVL (p_lo_prem_lim, lo_prem_lim)
                     AND old_hi_prem_lim =
                                      NVL (p_old_hi_prem_lim, old_hi_prem_lim)
                     AND hi_prem_lim = NVL (p_hi_prem_lim, hi_prem_lim)
                     AND old_slid_comm_rt =
                                    NVL (p_old_slid_comm_rt, old_slid_comm_rt)
                     AND slid_comm_rt = NVL (p_slid_comm_rt, slid_comm_rt)
                ORDER BY last_update)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.peril_cd := i.peril_cd;
         v_row.old_lo_prem_lim := i.old_lo_prem_lim;
         v_row.lo_prem_lim := i.lo_prem_lim;
         v_row.old_hi_prem_lim := i.old_hi_prem_lim;
         v_row.hi_prem_lim := i.hi_prem_lim;
         v_row.old_slid_comm_rt := i.old_slid_comm_rt;
         v_row.slid_comm_rt := i.slid_comm_rt;
         v_row.user_id := i.user_id;
         v_row.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_row);
      END LOOP;
   END;

   PROCEDURE check_rate (
      p_line_cd           giis_slid_comm.line_cd%TYPE,
      p_subline_cd        giis_slid_comm.subline_cd%TYPE,
      p_peril_cd          giis_slid_comm.peril_cd%TYPE,
      p_lo_prem_lim       giis_slid_comm.lo_prem_lim%TYPE,
      p_hi_prem_lim       giis_slid_comm.hi_prem_lim%TYPE,
      p_old_lo_prem_lim   giis_slid_comm.lo_prem_lim%TYPE,
      p_old_hi_prem_lim   giis_slid_comm.hi_prem_lim%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT lo_prem_lim, hi_prem_lim
                  FROM giis_slid_comm
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND peril_cd = p_peril_cd)
      LOOP
         IF     i.lo_prem_lim <> p_old_lo_prem_lim
            AND i.hi_prem_lim <> p_old_hi_prem_lim
         THEN
            IF p_lo_prem_lim BETWEEN i.lo_prem_lim AND i.hi_prem_lim
            THEN
               raise_application_error
                                     (-20001,
                                         'Geniisys Exception#I#Prem Rate of '
                                      || p_lo_prem_lim
                                      || ' is already maintained'
                                     );
            ELSIF p_hi_prem_lim BETWEEN i.lo_prem_lim AND i.hi_prem_lim
            THEN
               raise_application_error
                                     (-20001,
                                         'Geniisys Exception#I#Prem Rate of '
                                      || p_hi_prem_lim
                                      || ' is already maintained'
                                     );
            END IF;
         END IF;
      END LOOP;
   END;

   PROCEDURE set_rec (
      p_rec               giis_slid_comm%ROWTYPE,
      p_old_lo_prem_lim   giis_slid_comm.lo_prem_lim%TYPE,
      p_old_hi_prem_lim   giis_slid_comm.hi_prem_lim%TYPE
   )
   IS
      v_exists   BOOLEAN := FALSE;
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_slid_comm
                 WHERE line_cd = p_rec.line_cd
                   AND subline_cd = p_rec.subline_cd
                   AND peril_cd = p_rec.peril_cd
                   AND hi_prem_lim = p_rec.hi_prem_lim
                   AND lo_prem_lim = p_rec.lo_prem_lim)
      LOOP
         v_exists := TRUE;
         EXIT;
      END LOOP;

      IF v_exists
      THEN
         UPDATE giis_slid_comm
            SET slid_comm_rt = p_rec.slid_comm_rt,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE line_cd = p_rec.line_cd
            AND subline_cd = p_rec.subline_cd
            AND peril_cd = p_rec.peril_cd
            AND hi_prem_lim = p_rec.hi_prem_lim
            AND lo_prem_lim = p_rec.lo_prem_lim;
      ELSE
         INSERT INTO giis_slid_comm
                     (line_cd, subline_cd, peril_cd,
                      hi_prem_lim, lo_prem_lim,
                      slid_comm_rt, user_id, last_update,
                      remarks
                     )
              VALUES (p_rec.line_cd, p_rec.subline_cd, p_rec.peril_cd,
                      p_rec.hi_prem_lim, p_rec.lo_prem_lim,
                      p_rec.slid_comm_rt, p_rec.user_id, SYSDATE,
                      p_rec.remarks
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_line_cd       giis_slid_comm.line_cd%TYPE,
      p_subline_cd    giis_slid_comm.subline_cd%TYPE,
      p_peril_cd      giis_slid_comm.peril_cd%TYPE,
      p_lo_prem_lim   giis_slid_comm.lo_prem_lim%TYPE,
      p_hi_prem_lim   giis_slid_comm.hi_prem_lim%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_slid_comm_hist
            WHERE line_cd = p_line_cd
              AND subline_cd = p_subline_cd
              AND peril_cd = p_peril_cd
              AND hi_prem_lim = p_hi_prem_lim
              AND lo_prem_lim = p_lo_prem_lim;

      DELETE FROM giis_slid_comm
            WHERE line_cd = p_line_cd
              AND subline_cd = p_subline_cd
              AND peril_cd = p_peril_cd
              AND hi_prem_lim = p_hi_prem_lim
              AND lo_prem_lim = p_lo_prem_lim;
   END;

   FUNCTION get_rate_list (
      p_line_cd      giis_slid_comm.line_cd%TYPE,
      p_subline_cd   giis_slid_comm.subline_cd%TYPE,
      p_peril_cd     giis_slid_comm.peril_cd%TYPE
   )
      RETURN rate_tab PIPELINED
   IS
      v_row   rate_type;
   BEGIN
      FOR i IN (SELECT lo_prem_lim, hi_prem_lim
                  FROM giis_slid_comm
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND peril_cd = p_peril_cd)
      LOOP
         v_row.lo_prem_lim := i.lo_prem_lim;
         v_row.hi_prem_lim := i.hi_prem_lim;
         PIPE ROW (v_row);
      END LOOP;
   END;
END;
/


