CREATE OR REPLACE PACKAGE BODY CPI.giiss205_pkg
AS
   FUNCTION get_rec_list (
      p_ind_grp_cd   giis_industry_group.ind_grp_cd%TYPE,
      p_ind_grp_nm   giis_industry_group.ind_grp_nm%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_industry_group a
                   WHERE a.ind_grp_cd = NVL (p_ind_grp_cd, a.ind_grp_cd)
                     AND UPPER (a.ind_grp_nm) LIKE UPPER (NVL (p_ind_grp_nm, '%'))
                ORDER BY 1)
      LOOP
         v_rec.ind_grp_cd := i.ind_grp_cd;
         v_rec.ind_grp_nm := i.ind_grp_nm;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (
      p_ind_grp_cd   giis_industry_group.ind_grp_cd%TYPE,
      p_ind_grp_nm   giis_industry_group.ind_grp_nm%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_industry_group a
                 WHERE a.ind_grp_cd = p_ind_grp_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same ind_grp_cd.'
            );
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giis_industry_group a
                 WHERE a.ind_grp_nm = p_ind_grp_nm)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same ind_grp_nm.'
            );
      END LOOP;
   END;

   PROCEDURE val_del_rec (p_ind_grp_cd giis_industry_group.ind_grp_cd%TYPE)
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_industry a
                 WHERE a.ind_grp_cd = p_ind_grp_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_INDUSTRY_GROUP while dependent record(s) in GIIS_INDUSTRY exists.'
            );
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giis_industry_group%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_industry_group
                 WHERE ind_grp_cd = p_rec.ind_grp_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_industry_group
            SET ind_grp_cd = p_rec.ind_grp_cd,
                ind_grp_nm = p_rec.ind_grp_nm,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE ind_grp_cd = p_rec.ind_grp_cd;
      ELSE
         INSERT INTO giis_industry_group
                     (ind_grp_cd, ind_grp_nm, remarks,
                      user_id, last_update
                     )
              VALUES (p_rec.ind_grp_cd, p_rec.ind_grp_nm, p_rec.remarks,
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (p_ind_grp_cd giis_industry_group.ind_grp_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_industry_group
            WHERE ind_grp_cd = p_ind_grp_cd;
   END;
END;
/


