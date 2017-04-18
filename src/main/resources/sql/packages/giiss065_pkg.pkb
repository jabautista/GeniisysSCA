CREATE OR REPLACE PACKAGE BODY CPI.giiss065_pkg
AS
   FUNCTION get_giisdefaultdist_list (
      p_line_cd        giis_default_dist.line_cd%TYPE,
      p_subline_cd     giis_default_dist.subline_cd%TYPE,
      p_iss_cd         giis_default_dist.iss_cd%TYPE,
      p_dist_type      giis_default_dist.dist_type%TYPE,
      p_default_type   giis_default_dist.default_type%TYPE,
      p_default_no     giis_default_dist.default_no%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN giisdefaultdist_tab PIPELINED
   IS
      v_rec   giisdefaultdist_type;
   BEGIN
      FOR i IN (SELECT   a.*, b.line_name, c.subline_name, d.iss_name
                    FROM giis_default_dist a,
                         giis_line b,
                         giis_subline c,
                         giis_issource d
                   WHERE a.line_cd = b.line_cd
                     AND a.subline_cd = c.subline_cd
                     AND a.iss_cd = d.iss_cd
                     AND c.line_cd = a.line_cd -- Added by Jerome 10.17.2016 SR 5552
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       a.iss_cd,
                                                       'GIISS065',
                                                       p_user_id
                                                      ) = 1
                     AND a.default_no = NVL (p_default_no, a.default_no)
                     AND UPPER (a.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                     AND a.default_type = NVL (p_default_type, a.default_type)
                     AND UPPER (a.dist_type) LIKE
                                                UPPER (NVL (p_dist_type, '%'))
                     AND UPPER (a.subline_cd) LIKE
                                               UPPER (NVL (p_subline_cd, '%'))
                     AND UPPER (a.iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
                ORDER BY a.default_no)
      LOOP
         v_rec.default_no := i.default_no;
         v_rec.line_cd := i.line_cd;
         v_rec.dsp_line_name := i.line_name;
         v_rec.default_type := i.default_type;
         v_rec.dist_type := i.dist_type;
         v_rec.subline_cd := i.subline_cd;
         v_rec.dsp_subline_name := i.subline_name;
         v_rec.iss_cd := i.iss_cd;
         v_rec.dsp_iss_name := i.iss_name;

         BEGIN
            SELECT rv_meaning
              INTO v_rec.dsp_default_name
              FROM cg_ref_codes
             WHERE rv_domain = 'GIIS_DEFAULT_DIST.DEFAULT_TYPE'
               AND rv_low_value = i.default_type;
         END;

         BEGIN
            SELECT rv_meaning
              INTO v_rec.dsp_dist_name
              FROM cg_ref_codes
             WHERE rv_domain = 'GIIS_DEFAULT_DIST.DIST_TYPE'
               AND rv_low_value = i.dist_type;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giiss065_line_lov (
      p_iss_cd    VARCHAR2,
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2
   )
      RETURN linelov_tab PIPELINED
   IS
      v_list   linelov_type;
   BEGIN
      FOR i IN
         (SELECT a150.line_cd, a150.line_name
            FROM giis_line a150
           WHERE check_user_per_line2 (line_cd,
                                       p_iss_cd,
                                       'GIISS065',
                                       p_user_id
                                      ) = 1
             AND (   UPPER (a150.line_cd) LIKE UPPER (NVL (p_keyword, a150.line_cd))
                  OR UPPER (a150.line_name) LIKE UPPER (NVL (p_keyword, a150.line_name))
                  ))
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_giiss065_subline_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN sublinelov_tab PIPELINED
   IS
      v_list   sublinelov_type;
   BEGIN
      FOR i IN
         (SELECT a210.subline_name subline_name, a210.subline_cd subline_cd
            FROM giis_subline a210
           WHERE line_cd = p_line_cd
             AND (   UPPER (a210.subline_cd) LIKE UPPER (NVL (p_keyword, a210.subline_cd))
                  OR UPPER (a210.subline_name) LIKE UPPER (NVL (p_keyword, a210.subline_name))
                 ))
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_giiss065_iss_lov (
      p_line_cd   VARCHAR2,
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2
   )
      RETURN isslov_tab PIPELINED
   IS
      v_list   isslov_type;
   BEGIN
      FOR i IN (SELECT a130.iss_name iss_name, a130.iss_cd iss_cd
                  FROM giis_issource a130
                 WHERE check_user_per_iss_cd2 (p_line_cd,
                                                     iss_cd,
                                                     'GIISS065',
                                                     p_user_id
                                                    ) = 1
                   AND (   UPPER (a130.iss_cd) LIKE UPPER (NVL (p_keyword, a130.iss_cd))
                        OR UPPER (a130.iss_name) LIKE UPPER (NVL (p_keyword, a130.iss_name))
                       ))
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_giiss065_disttype_lov (p_keyword VARCHAR2)
      RETURN disttypelov_tab PIPELINED
   IS
      v_list   disttypelov_type;
   BEGIN
      FOR i IN
         (SELECT rv_low_value dist_type, rv_meaning dist_name
            FROM cg_ref_codes
           WHERE rv_domain = 'GIIS_DEFAULT_DIST.DIST_TYPE'
             AND (   UPPER (rv_low_value) LIKE UPPER (NVL (p_keyword, rv_low_value))
                  OR UPPER (rv_meaning) LIKE UPPER (NVL (p_keyword, rv_meaning))
                 ))
      LOOP
         v_list.dist_type := i.dist_type;
         v_list.dist_name := i.dist_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_giiss065_defaulttype_lov (p_keyword VARCHAR2)
      RETURN defaulttypelov_tab PIPELINED
   IS
      v_list   defaulttypelov_type;
   BEGIN
      FOR i IN
         (SELECT rv_low_value default_type, rv_meaning default_name
            FROM cg_ref_codes
           WHERE rv_domain = 'GIIS_DEFAULT_DIST.DEFAULT_TYPE'
             AND (   UPPER (rv_low_value) LIKE UPPER (NVL (p_keyword, rv_low_value))
                  OR UPPER (rv_meaning) LIKE UPPER (NVL (p_keyword, rv_meaning))
                 ))
      LOOP
         v_list.default_type := i.default_type;
         v_list.default_name := i.default_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_adddefaultdist_rec (
      p_line_cd      giis_default_dist.line_cd%TYPE,
      p_subline_cd   giis_default_dist.subline_cd%TYPE,
      p_iss_cd       giis_default_dist.iss_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_default_dist a
                 WHERE a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same line_cd, subline_cd and iss_cd.'
            );
      END IF;
   END;

   PROCEDURE val_deldefaultdist_rec (
      p_default_no   giis_default_dist.default_no%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'gddg'
                  FROM giis_default_dist_group a
                 WHERE a.default_no = p_default_no)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_DEFAULT_DIST while dependent record(s) in GIIS_DEFAULT_DIST_GROUP exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 'gddp'
                  FROM giis_default_dist_peril a
                 WHERE a.default_no = p_default_no)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_DEFAULT_DIST while dependent record(s) in GIIS_DEFAULT_DIST_PERIL exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 'gddd'
                  FROM giis_default_dist_dtl a
                 WHERE a.default_no = p_default_no)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_DEFAULT_DIST while dependent record(s) in GIIS_DEFAULT_DIST_DTL exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE set_giisdefaultdist_rec (p_rec giis_default_dist%ROWTYPE)
   IS
      v_exists       VARCHAR2 (1);
      v_default_no   giis_default_dist.default_no%TYPE;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_default_dist
                 WHERE default_no = p_rec.default_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_default_dist
            SET --line_cd = p_rec.line_cd,
                --subline_cd = p_rec.subline_cd,
                iss_cd = p_rec.iss_cd,
                dist_type = p_rec.dist_type,
                default_type = p_rec.default_type,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE default_no = p_rec.default_no;
      ELSE
         INSERT INTO giis_default_dist
                     (default_no, line_cd, subline_cd,
                      iss_cd, dist_type, default_type,
                      user_id, last_update
                     )
              VALUES (p_rec.default_no, p_rec.line_cd, p_rec.subline_cd,
                      p_rec.iss_cd, p_rec.dist_type, p_rec.default_type,
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_giisdefaultdist_rec (
      p_default_no   giis_default_dist.default_no%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_default_dist
            WHERE default_no = p_default_no;
      COMMIT;
   END;

   FUNCTION get_giisdefaultdistgroup_list (
      p_default_no        giis_default_dist_dtl.default_no%TYPE,
      p_sequence          giis_default_dist_group.SEQUENCE%TYPE,
      p_dsp_treaty_name   giis_dist_share.trty_name%TYPE,
      p_share_pct         giis_default_dist_group.share_pct%TYPE,
      p_share_amt1        giis_default_dist_group.share_amt1%TYPE
   )
      RETURN giisdefaultdistgroup_tab PIPELINED
   IS
      v_rec   giisdefaultdistgroup_type;
      v_exists VARCHAR2(1) := 'N';
   BEGIN
       FOR i IN
         (SELECT   a.*, b.trty_name
            FROM giis_default_dist_group a, giis_dist_share b
           WHERE default_no = p_default_no
             AND a.line_cd = b.line_cd
             AND a.share_cd = b.share_cd
             AND a.SEQUENCE = NVL (p_sequence, a.SEQUENCE)
             AND UPPER (b.trty_name) LIKE
                             UPPER (NVL (p_dsp_treaty_name, '%'))
             AND NVL (a.share_pct, 0) =
                             NVL (p_share_pct, NVL (a.share_pct, 0))
             AND NVL (a.share_amt1, 0) =
                             NVL (p_share_amt1, NVL (a.share_amt1, 0))
             AND NOT EXISTS (SELECT * 
                               FROM giis_default_dist_dtl b
                              WHERE a.share_cd = b.share_cd
                                AND a.default_no = b.default_no)
             ORDER BY a.SEQUENCE)
        LOOP
            v_rec.default_no := i.default_no;
            v_rec.line_cd := i.line_cd;
            v_rec.share_cd := i.share_cd;
            v_rec.dsp_treaty_name := i.trty_name;
            v_rec.SEQUENCE := i.SEQUENCE;
            v_rec.share_pct := i.share_pct;
            v_rec.share_amt1 := i.share_amt1;
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                               TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
        END LOOP;
      RETURN;
   END;

   FUNCTION get_giiss065_share01_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN sharelov_tab PIPELINED
   IS
      v_list   sharelov_type;
   BEGIN
      FOR i IN (SELECT trty_name, share_cd
                  FROM giis_dist_share
                 WHERE share_cd <> 999
                   AND line_cd = p_line_cd
                   AND share_type <> 4
                   AND (   UPPER (share_cd) LIKE UPPER (NVL (p_keyword, share_cd))
                        OR UPPER (trty_name) LIKE UPPER (NVL (p_keyword, trty_name))
                       ))
      LOOP
         v_list.share_cd := i.share_cd;
         v_list.share_name := i.trty_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_giiss065_share999_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN sharelov_tab PIPELINED
   IS
      v_list   sharelov_type;
   BEGIN
      FOR i IN (SELECT trty_name, share_cd
                  FROM giis_dist_share
                 WHERE line_cd = p_line_cd
                   AND share_type <> 4
                   AND (   UPPER (share_cd) LIKE UPPER (NVL (p_keyword, share_cd))
                        OR UPPER (trty_name) LIKE UPPER (NVL (p_keyword, trty_name))
                       ))
      LOOP
         v_list.share_cd := i.share_cd;
         v_list.share_name := i.trty_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_existingperilrecord_rec (
      p_default_no   giis_default_dist.default_no%TYPE,
      p_line_cd      giis_default_dist.line_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'gddp'
                  FROM giis_default_dist_peril a
                 WHERE a.default_no = p_default_no AND a.line_cd = p_line_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#I#You cannot change the default type if there are already existing detail default distribution records in default distribution by peril.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE val_adddefaultdistgroup_rec (
      p_default_no   giis_default_dist_group.default_no%TYPE,
      p_share_cd     giis_default_dist_group.share_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'gddg'
                  FROM giis_default_dist_group a
                 WHERE a.default_no = p_default_no
                       AND a.share_cd = p_share_cd)
      LOOP
         raise_application_error
            (-20001,
              'Geniisys Exception#I#Record already exists with the same default_no, line_cd and share_cd.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE set_giisdefaultdistgroup_rec (
      p_rec   giis_default_dist_group%ROWTYPE
   )
   IS
      v_exists   VARCHAR2 (1);
      v_exists_dtl VARCHAR (1);
      v_range_from NUMBER;
      v_range_to NUMBER;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_default_dist_group
                 WHERE default_no = p_rec.default_no
                   AND share_cd = p_rec.share_cd
                   AND SEQUENCE = p_rec.SEQUENCE)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

--      FOR a IN (SELECT *
--                  FROM giis_default_dist_dtl
--                 WHERE default_no = p_rec.default_no)
--      LOOP
--         v_exists_dtl := 'Y';
--         v_range_from := a.range_from;
--         v_range_to := a.range_to;
--         EXIT;
--      END LOOP;
      IF v_exists = 'Y'
      THEN
         UPDATE giis_default_dist_group
            SET line_cd = p_rec.line_cd,
                share_cd = p_rec.share_cd,
                share_pct = p_rec.share_pct,
                share_amt1 = p_rec.share_amt1,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE default_no = p_rec.default_no AND SEQUENCE = p_rec.SEQUENCE;
      ELSE
--         IF v_exists_dtl = 'Y' THEN
--            FOR x IN (SELECT line_cd, share_cd
--                        FROM giis_default_dist_group
--                       WHERE default_no = p_rec.default_no)
--            LOOP
--                INSERT INTO giis_default_dist_dtl
--                     (default_no, line_cd, share_cd,
--                      share_pct, range_from, range_to, 
--                      user_id, last_update
--                     )
--              VALUES (p_rec.default_no, p_rec.line_cd, p_rec.share_cd,
--                      p_rec.share_pct, v_range_from,
--                      v_range_to, p_rec.user_id, SYSDATE
--                     );
--            END LOOP;
--         END IF;
         INSERT INTO giis_default_dist_group
                     (default_no, line_cd, share_cd,
                      SEQUENCE, share_pct, share_amt1,
                      remarks, user_id, last_update
                     )
              VALUES (p_rec.default_no, p_rec.line_cd, p_rec.share_cd,
                      p_rec.SEQUENCE, p_rec.share_pct, p_rec.share_amt1,
                      p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_giisdefaultdistgroup_rec (
      p_default_no   giis_default_dist_group.default_no%TYPE,
      p_sequence     giis_default_dist_group.SEQUENCE%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_default_dist_group
            WHERE default_no = p_default_no AND SEQUENCE = p_sequence;
      COMMIT;
   END;

   FUNCTION get_giisdefaultdistdtl_list (
      p_default_no   giis_default_dist_dtl.default_no%TYPE
   )
      RETURN giisdefaultdistdtl_tab PIPELINED
   IS
      v_rec   giisdefaultdistdtl_type;
   BEGIN
      FOR i IN (SELECT default_no, range_from, range_to, SUM(share_pct)
                  FROM giis_default_dist_dtl
                 WHERE default_no = p_default_no
              GROUP BY default_no, range_from, range_to
              ORDER BY range_from)
      LOOP
         v_rec.default_no := i.default_no;
         v_rec.range_from := i.range_from;
         v_rec.range_to := i.range_to;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION validate_save_exist (
      p_line_cd        giis_default_dist.line_cd%TYPE,
      p_subline_cd     giis_default_dist.subline_cd%TYPE,
      p_iss_cd         giis_default_dist.iss_cd%TYPE,
      p_dist_type      giis_default_dist.dist_type%TYPE,
      p_default_type   giis_default_dist.default_type%TYPE
   )
      RETURN validate_save_exist_tab PIPELINED
   IS
      v_rec   validate_save_exist_type;
   BEGIN
      FOR i IN (SELECT dist_type, default_no
                  FROM giis_default_dist
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND dist_type = p_dist_type
                   AND default_type = p_default_type)
      LOOP
         v_rec.v_exists := 'Y';
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   PROCEDURE set_giisdefaultdistdtl_rec (
      p_rec   giis_default_dist_dtl%ROWTYPE
   )
   IS
      v_exists_dtl   VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_default_dist_dtl
                 WHERE default_no = p_rec.default_no
                   AND range_from = p_rec.range_from
                   AND range_to = p_rec.range_to
                   AND share_cd = p_rec.share_cd)
      LOOP
         v_exists_dtl := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_dtl = 'Y'
      THEN
         UPDATE giis_default_dist_dtl
            SET range_from = p_rec.range_from,
                range_to = p_rec.range_to,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE default_no = p_rec.default_no;
      ELSE
         INSERT INTO giis_default_dist_dtl
                     (default_no, line_cd, share_cd,
                      share_pct, range_from, range_to, 
                      user_id, last_update
                     )
              VALUES (p_rec.default_no, p_rec.line_cd, p_rec.share_cd,
                      p_rec.share_pct, p_rec.range_from,
                      p_rec.range_to, p_rec.user_id, SYSDATE
                     );
      END IF;
      COMMIT;
   END;
   PROCEDURE del_giisdefaultdistdtl_rec (
     p_default_no   giis_default_dist_dtl.default_no%TYPE,
     p_range_from   giis_default_dist_dtl.range_from%TYPE,
     p_range_to     giis_default_dist_dtl.range_to%TYPE
   )
   AS
   
   BEGIN
   
      FOR a IN (SELECT  b.line_cd, b.share_cd
                  FROM giis_default_dist_group a, giis_dist_share b, giis_default_dist_dtl c
                 WHERE a.default_no = p_default_no
                   AND a.default_no = c.default_no
                   AND c.range_from = p_range_from
                   AND c.range_to = p_range_to
                   AND a.line_cd = b.line_cd
                   AND a.share_cd = b.share_cd
                   AND a.share_cd = c.share_cd
              ORDER BY a.SEQUENCE)
      LOOP        
        DELETE FROM giis_default_dist_group
            WHERE default_no = p_default_no
              AND share_cd = a.share_cd
              AND line_cd = a.line_cd;
      END LOOP;
   
      DELETE FROM giis_default_dist_dtl
            WHERE default_no = p_default_no
              AND range_from = p_range_from
              AND range_to = p_range_to;

      COMMIT;
   END;
    
   FUNCTION get_giisdefaultdistgroup_list2 (
      p_default_no        giis_default_dist_dtl.default_no%TYPE,
      p_sequence          giis_default_dist_group.SEQUENCE%TYPE,
      p_dsp_treaty_name   giis_dist_share.trty_name%TYPE,
      p_share_pct         giis_default_dist_group.share_pct%TYPE,
      p_share_amt1        giis_default_dist_group.share_amt1%TYPE,
      p_range_from        giis_default_dist_dtl.range_from%TYPE,
      p_range_to          giis_default_dist_dtl.range_to%TYPE
   )
      RETURN giisdefaultdistgroup_tab PIPELINED
   IS
      v_rec   giisdefaultdistgroup_type;
      v_exists VARCHAR2(1) := 'N';
      v_sequence_no NUMBER;
   BEGIN
      FOR a IN 
          (SELECT 1
             FROM giis_default_dist_dtl a, giis_default_dist_group b
            WHERE a.default_no = p_default_no
              AND a.default_no = b.default_no
              AND a.range_from = p_range_from
              AND a.range_to = p_range_to)
      LOOP
        v_exists := 'Y';
        EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
          FOR i IN
             (SELECT DISTINCT a.*, b.trty_name
                  FROM giis_default_dist_group a, giis_dist_share b, giis_default_dist_dtl c
                 WHERE a.default_no = p_default_no
                   AND a.default_no = c.default_no
                   AND c.range_from = p_range_from
                   AND c.range_to = p_range_to
                   AND a.line_cd = b.line_cd
                   AND a.share_cd = b.share_cd
                   AND a.share_cd = c.share_cd
                   AND a.SEQUENCE = NVL (p_sequence, a.SEQUENCE)
                   AND UPPER (b.trty_name) LIKE
                                              UPPER (NVL (p_dsp_treaty_name, '%'))
                   AND NVL (a.share_pct, 0) =
                                           NVL (p_share_pct, NVL (a.share_pct, 0))
                   AND NVL (a.share_amt1, 0) =
                                         NVL (p_share_amt1, NVL (a.share_amt1, 0))
              ORDER BY a.SEQUENCE)
          LOOP
             v_rec.default_no := i.default_no;
             v_rec.line_cd := i.line_cd;
             v_rec.share_cd := i.share_cd;
             v_rec.dsp_treaty_name := i.trty_name;
             v_rec.SEQUENCE := i.SEQUENCE;
             v_rec.share_pct := i.share_pct;
             v_rec.share_amt1 := i.share_amt1;
             v_rec.remarks := i.remarks;
             v_rec.user_id := i.user_id;
             v_rec.last_update :=
                                TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
             PIPE ROW (v_rec);
          END LOOP;
      END IF;
      RETURN;
   END;
   
   PROCEDURE get_max_sequence_no (
     p_default_no   IN    giis_default_dist_group.default_no%TYPE,
     p_sequence     OUT   giis_default_dist_group.sequence%TYPE
    )
    
    AS
    BEGIN
        SELECT NVL(MAX(sequence),0)
          INTO p_sequence
          FROM giis_default_dist_group
         WHERE default_no = p_default_no;
    END;
END;
/


