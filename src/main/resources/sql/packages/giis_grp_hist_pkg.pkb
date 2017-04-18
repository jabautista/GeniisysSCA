CREATE OR REPLACE PACKAGE BODY CPI.giis_grp_hist_pkg
AS
   FUNCTION get_user_history (
      p_user_id        giis_user_grp_hist.userid%TYPE,
      p_hist_id        giis_user_grp_hist.hist_id%TYPE,
      p_old_user_grp   giis_user_grp_hist.old_user_grp%TYPE,
      p_new_user_grp   giis_user_grp_hist.new_user_grp%TYPE
   )
      RETURN grp_hist_tab PIPELINED
   IS
      v_row   grp_hist;
   BEGIN
      FOR user_grp_hist IN (SELECT   a.hist_id, a.old_user_grp, b.user_grp_desc old_user_desc,
                                     a.new_user_grp, c.user_grp_desc new_user_desc, a.last_update
                                FROM giis_user_grp_hist a, giis_user_grp_hdr b,
                                     giis_user_grp_hdr c
                               WHERE a.hist_id = NVL(p_hist_id, a.hist_id)
                                 AND a.old_user_grp = NVL(p_old_user_grp, a.old_user_grp)
                                 AND a.new_user_grp = NVL(p_new_user_grp, a.new_user_grp)
                                 AND a.old_user_grp = b.user_grp
                                 AND a.new_user_grp = c.user_grp
                                 AND a.userid = p_user_id
                            ORDER BY hist_id)
      LOOP
         v_row.hist_id := user_grp_hist.hist_id;
         v_row.old_user_grp := user_grp_hist.old_user_grp;
         v_row.old_user_desc := user_grp_hist.old_user_desc;
         v_row.new_user_grp := user_grp_hist.new_user_grp;
         v_row.new_user_desc := user_grp_hist.new_user_desc;
         v_row.last_update := user_grp_hist.last_update;
         v_row.last_update_char := TO_CHAR (user_grp_hist.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_row);
      END LOOP;

      RETURN;
   END;
END;
/


