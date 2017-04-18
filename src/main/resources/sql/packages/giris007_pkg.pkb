CREATE OR REPLACE PACKAGE BODY CPI.giris007_pkg
AS
   FUNCTION get_distshare_list (
      p_line_cd         giis_dist_share.line_cd%TYPE,
      p_trty_yy         giis_dist_share.trty_yy%TYPE,
      p_share_cd        giis_dist_share.share_cd%TYPE,
      p_trty_name       giis_dist_share.trty_name%TYPE,
      p_user_id         VARCHAR2,
      p_eff_date        VARCHAR2,
      p_expiry_date     VARCHAR2
   )
      RETURN giis_dist_share_tab PIPELINED
   IS
      v_rec   giis_dist_share_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_dist_share
                   WHERE share_type = 2
                     AND UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                     AND trty_yy = NVL (p_trty_yy, trty_yy)
                     AND share_cd = NVL (p_share_cd, share_cd)
                     AND UPPER (trty_name) LIKE UPPER (NVL (p_trty_name, '%'))
                     AND check_user_per_line2 (line_cd, NULL, 'GIRIS007', p_user_id) = 1
                     AND TRUNC (eff_date) = NVL (TO_DATE (p_eff_date, 'mm-dd-yyyy'), TRUNC (eff_date))
                     AND TRUNC (expiry_date) = NVL (TO_DATE (p_expiry_date, 'mm-dd-yyyy'), TRUNC (expiry_date))
                ORDER BY line_cd, trty_cd, share_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.trty_yy := i.trty_yy;
         v_rec.share_cd := i.share_cd;
         v_rec.trty_name := i.trty_name;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_xol_list (
      p_line_cd         giis_xol.line_cd%TYPE,
      p_xol_yy          giis_xol.xol_yy%TYPE,
      p_xol_seq_no      giis_xol.xol_seq_no%TYPE,
      p_layer_no        giis_dist_share.layer_no%TYPE,
      p_xol_trty_name   giis_xol.xol_trty_name%TYPE,
      p_trty_name       giis_dist_share.trty_name%TYPE,
      p_user_id         VARCHAR2,
      p_eff_date        VARCHAR2,
      p_expiry_date     VARCHAR2
   )
      RETURN giis_xol_tab PIPELINED
   IS
      v_rec   giis_xol_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.xol_id, b.line_cd, b.xol_yy, b.xol_seq_no,
                          b.xol_trty_name, A.share_cd, A.layer_no,
                          A.trty_name, A.eff_date, A.expiry_date,
                             b.line_cd
                          || '-'
                          || LTRIM (TO_CHAR (b.xol_yy))
                          || '-'
                          || LTRIM (TO_CHAR (b.xol_seq_no, '009'))
                                                                  xol_treaty
                     FROM giis_dist_share A, giis_xol b, giis_trty_peril c
                    WHERE A.xol_id(+) = b.xol_id
                      AND A.share_cd = c.trty_seq_no(+)
                      AND A.line_cd = c.line_cd(+)
                      AND A.share_type = '4'
                      AND check_user_per_line2 (A.line_cd, NULL, 'GIRIS007', p_user_id) = 1
                      AND UPPER (b.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                      AND b.xol_yy = NVL (p_xol_yy, b.xol_yy)
                      AND b.xol_seq_no = NVL (p_xol_seq_no, b.xol_seq_no)
                      AND UPPER (NVL (A.trty_name, '%')) LIKE UPPER (NVL (p_trty_name, '%'))
                      AND NVL (A.layer_no, 99) = NVL (p_layer_no, NVL (A.layer_no, 99))
                      AND UPPER (NVL (A.trty_name, '%')) LIKE UPPER (NVL (p_trty_name, '%'))
                      AND TRUNC (A.eff_date) = NVL (TO_DATE (p_eff_date, 'mm-dd-yyyy'), TRUNC (A.eff_date))
                      AND TRUNC (A.expiry_date) = NVL (TO_DATE (p_expiry_date, 'mm-dd-yyyy'), TRUNC (A.expiry_date))
                      AND UPPER(b.xol_trty_name) LIKE UPPER(NVL(p_xol_trty_name, '%'))
                 ORDER BY line_cd, xol_seq_no)
      LOOP
         v_rec.xol_id := i.xol_id;
         v_rec.line_cd := i.line_cd;
         v_rec.xol_yy := i.xol_yy;
         v_rec.xol_seq_no := i.xol_seq_no;
         v_rec.xol_trty_name := i.xol_trty_name;
         v_rec.share_cd := i.share_cd;
         v_rec.layer_no := i.layer_no;
         v_rec.trty_name := i.trty_name;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_rec.xol_treaty := i.xol_treaty;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_a6401_list (
      p_line_cd          giis_dist_share.line_cd%TYPE,
      p_trty_yy          giis_dist_share.trty_yy%TYPE,
      p_share_cd         giis_dist_share.share_cd%TYPE,
      p_peril_cd         giis_trty_peril.peril_cd%TYPE,
      p_peril_name       giis_peril.peril_name%TYPE,
      p_trty_com_rt      giis_trty_peril.trty_com_rt%TYPE,
      p_prof_comm_rt     giis_trty_peril.prof_comm_rt%TYPE
   )
      RETURN a6401_tab PIPELINED
   IS
      v_rec   a6401_type;
   BEGIN
      FOR i IN (SELECT b.*, c.peril_name
                  FROM giis_dist_share A, giis_trty_peril b, giis_peril c
                 WHERE A.line_cd = b.line_cd
                   AND b.peril_cd = c.peril_cd
                   AND b.line_cd = c.line_cd
                   AND A.share_cd = b.trty_seq_no
                   AND A.line_cd = p_line_cd
                   AND A.trty_yy = p_trty_yy
                   AND A.share_cd = p_share_cd
                   AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                   AND UPPER (c.peril_name) LIKE UPPER (NVL (p_peril_name, '%'))
                   AND NVL(b.trty_com_rt, 9999) = NVL(p_trty_com_rt, NVL(b.trty_com_rt, 9999))
                   AND NVL(b.prof_comm_rt, 9999) = NVL(p_prof_comm_rt, NVL(b.prof_comm_rt, 9999))
                   )
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.trty_seq_no := i.trty_seq_no;
         v_rec.peril_cd := i.peril_cd;
         v_rec.dsp_peril_name := i.peril_name;
         v_rec.trty_com_rt := i.trty_com_rt;
         v_rec.prof_comm_rt := i.prof_comm_rt;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_a6401_peril_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN a6401_peril_tab PIPELINED
   IS
      v_list   a6401_peril_type;
   BEGIN
      FOR i IN
         (SELECT a170.peril_cd, a170.peril_sname, a170.peril_name,
                 a170.peril_type
            FROM giis_peril a170
           WHERE a170.line_cd = p_line_cd
             AND (UPPER(a170.peril_cd) LIKE UPPER(NVL(p_keyword, a170.peril_cd))
              OR UPPER(a170.peril_sname) LIKE UPPER(NVL(p_keyword, a170.peril_sname))                        
              OR UPPER(a170.peril_name) LIKE UPPER(NVL(p_keyword, a170.peril_name))
              OR UPPER(a170.peril_type) LIKE UPPER(NVL(p_keyword, a170.peril_type))))
      LOOP
         v_list.peril_cd := i.peril_cd;
         v_list.peril_sname := i.peril_sname;
         v_list.peril_name := i.peril_name;
         v_list.peril_type := i.peril_type;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_add_a6401_rec (
      p_line_cd    giis_trty_peril.line_cd%TYPE,
      p_trty_yy    giis_dist_share.trty_yy%TYPE,
      p_share_cd   giis_dist_share.share_cd%TYPE,
      p_peril_cd   giis_trty_peril.peril_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'Y'
                  FROM giis_dist_share A, giis_trty_peril b, giis_peril c
                 WHERE A.line_cd = b.line_cd
                   AND b.peril_cd = c.peril_cd
                   AND b.line_cd = c.line_cd
                   AND A.share_cd = b.trty_seq_no
                   AND A.line_cd = p_line_cd
                   AND A.trty_yy = p_trty_yy
                   AND A.share_cd = p_share_cd
                   AND b.peril_cd = p_peril_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same line_cd, trty_seq_no and peril_cd.'
            );
      END LOOP;
   END;

   PROCEDURE set_a6401_rec (p_rec giis_trty_peril%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_trty_peril
                 WHERE line_cd = p_rec.line_cd
                   AND trty_seq_no = p_rec.trty_seq_no
                   AND peril_cd = p_rec.peril_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_trty_peril
            SET trty_com_rt = p_rec.trty_com_rt,
                prof_comm_rt = p_rec.prof_comm_rt,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE line_cd = p_rec.line_cd
            AND trty_seq_no = p_rec.trty_seq_no
            AND peril_cd = p_rec.peril_cd;
      ELSE
         INSERT INTO giis_trty_peril
                     (line_cd, trty_seq_no, peril_cd,
                      trty_com_rt, prof_comm_rt, remarks,
                      user_id, last_update
                     )
              VALUES (p_rec.line_cd, p_rec.trty_seq_no, p_rec.peril_cd,
                      p_rec.trty_com_rt, p_rec.prof_comm_rt, p_rec.remarks,
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_a6401_rec (
      p_line_cd       giis_trty_peril.line_cd%TYPE,
      p_trty_seq_no   giis_trty_peril.trty_seq_no%TYPE,
      p_peril_cd      giis_trty_peril.peril_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_trty_peril
            WHERE line_cd = p_line_cd
              AND trty_seq_no = p_trty_seq_no
              AND peril_cd = p_peril_cd;
   END;

   FUNCTION get_a6401incall_list (
      p_line_cd    giis_dist_share.line_cd%TYPE,
      p_trty_yy    giis_dist_share.trty_yy%TYPE,
      p_share_cd   giis_dist_share.share_cd%TYPE,
      p_peril_cd   giis_trty_peril.peril_cd%TYPE,
      p_user_id    giis_users.user_id%TYPE
   )
      RETURN a6401_tab PIPELINED
   IS
      v_rec   a6401_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_peril
                 WHERE line_cd = p_line_cd)
      LOOP
         v_rec.line_cd := p_line_cd;
         v_rec.trty_seq_no := p_share_cd;
         v_rec.peril_cd := i.peril_cd;
         v_rec.dsp_peril_name := i.peril_name;
         v_rec.trty_com_rt := 0;
         v_rec.remarks := i.remarks;
         v_rec.user_id := p_user_id;
         v_rec.last_update := TO_CHAR (SYSDATE, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_trtyperilxol_list (
      p_line_cd          giis_xol.line_cd%TYPE,
      p_xol_yy           giis_xol.xol_yy%TYPE,
      p_xol_seq_no       giis_xol.xol_seq_no%TYPE,
      p_share_cd         giis_trty_peril.trty_seq_no%TYPE,
      p_peril_cd         giis_trty_peril.peril_cd%TYPE,
      p_peril_name       giis_peril.peril_name%TYPE,
      p_trty_com_rt      giis_trty_peril.trty_com_rt%TYPE,
      p_prof_comm_rt     giis_trty_peril.prof_comm_rt%TYPE
   )
      RETURN trtyperilxol_tab PIPELINED
   IS
      v_rec   trtyperilxol_type;
   BEGIN
      FOR i IN (SELECT b.*, c.peril_name
                  FROM giis_dist_share A,
                       giis_trty_peril b,
                       giis_peril c,
                       giis_xol d
                 WHERE A.line_cd = b.line_cd
                   AND b.peril_cd = c.peril_cd
                   AND b.line_cd = c.line_cd
                   AND A.share_cd = b.trty_seq_no
                   AND A.xol_id(+) = d.xol_id
                   --AND NVL (A.share_cd, '99999') != '2' nieko 02142017, SR 23828
                   AND d.line_cd = p_line_cd
                   AND d.xol_yy = p_xol_yy
                   AND d.xol_seq_no = p_xol_seq_no
                   AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                   AND A.share_cd = NVL(p_share_cd, A.share_cd)
                   AND UPPER (c.peril_name) LIKE UPPER (NVL (p_peril_name, '%'))
                   AND NVL(b.trty_com_rt, 9999) = NVL(p_trty_com_rt, NVL(b.trty_com_rt, 9999))
                   AND NVL(b.prof_comm_rt, 9999) = NVL(p_prof_comm_rt, NVL(b.prof_comm_rt, 9999))   
                   )
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.trty_seq_no := i.trty_seq_no;
         v_rec.peril_cd := i.peril_cd;
         v_rec.dsp_peril_name := i.peril_name;
         v_rec.trty_com_rt := i.trty_com_rt;
         v_rec.prof_comm_rt := i.prof_comm_rt;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_trtyperilxol_rec (
      p_line_cd      giis_xol.line_cd%TYPE,
      p_xol_yy       giis_xol.xol_yy%TYPE,
      p_xol_seq_no   giis_xol.xol_seq_no%TYPE,
      p_peril_cd     giis_trty_peril.peril_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'Y'
                  FROM giis_dist_share A,
                       giis_trty_peril b,
                       giis_peril c,
                       giis_xol d
                 WHERE A.line_cd = b.line_cd
                   AND b.peril_cd = c.peril_cd
                   AND b.line_cd = c.line_cd
                   AND A.share_cd = b.trty_seq_no
                   AND A.xol_id(+) = d.xol_id
                   AND NVL (A.share_cd, '99999') != '2'
                   AND d.line_cd = p_line_cd
                   AND d.xol_yy = p_xol_yy
                   AND d.xol_seq_no = p_xol_seq_no
                   AND b.peril_cd = p_peril_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same line_cd, trty_seq_no and peril_cd.'
            );
      END LOOP;
   END;
   
   --nieko 02142017, SR 23828
   PROCEDURE val_add_trtyperilxol_rec2 (
      p_line_cd      giis_xol.line_cd%TYPE,
      p_xol_yy       giis_xol.xol_yy%TYPE,
      p_xol_seq_no   giis_xol.xol_seq_no%TYPE,
      p_peril_cd     giis_trty_peril.peril_cd%TYPE,
      p_share_cd     giis_dist_share.share_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'Y'
                  FROM giis_dist_share A,
                       giis_trty_peril b,
                       giis_peril c,
                       giis_xol d
                 WHERE A.line_cd = b.line_cd
                   AND b.peril_cd = c.peril_cd
                   AND b.line_cd = c.line_cd
                   AND A.share_cd = b.trty_seq_no
                   AND A.xol_id(+) = d.xol_id
                   AND NVL (A.share_cd, '99999') = p_share_cd
                   AND d.line_cd = p_line_cd
                   AND d.xol_yy = p_xol_yy
                   AND d.xol_seq_no = p_xol_seq_no
                   AND b.peril_cd = p_peril_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same line_cd, trty_seq_no and peril_cd.'
            );
      END LOOP;
   END;
   --nieko 02142017 end
END;
/
