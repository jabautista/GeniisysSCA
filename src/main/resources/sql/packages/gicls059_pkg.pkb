CREATE OR REPLACE PACKAGE BODY CPI.gicls059_pkg
AS
   FUNCTION get_giis_subline_list (p_keyword VARCHAR2)
      RETURN subline_listing_tab PIPELINED
   IS
      v_rec   subline_listing_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = 'MC'
                     AND (   UPPER (subline_cd) LIKE
                                           UPPER (NVL (p_keyword, subline_cd))
                          OR UPPER (subline_name) LIKE
                                         UPPER (NVL (p_keyword, subline_name))
                         )
                ORDER BY subline_cd)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_loss_exp_list (p_keyword VARCHAR2)
      RETURN loss_exp_listing_tab PIPELINED
   IS
      v_rec   loss_exp_listing_type;
   BEGIN
      FOR i IN
         (SELECT a.loss_exp_cd, a.loss_exp_desc
            FROM giis_loss_exp a
           WHERE line_cd = 'MC'
             AND NVL (comp_sw, '+') = '+'
             AND subline_cd IS NULL
             AND loss_exp_type = 'L'
             AND part_sw = 'Y'
             AND (   UPPER (a.loss_exp_cd) LIKE
                                        UPPER (NVL (p_keyword, a.loss_exp_cd))
                  OR UPPER (a.loss_exp_desc) LIKE
                                      UPPER (NVL (p_keyword, a.loss_exp_desc))
                 ))
      LOOP
         v_rec.loss_exp_cd := i.loss_exp_cd;
         v_rec.loss_exp_desc := i.loss_exp_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_rec_list (p_subline_cd giis_subline.subline_cd%TYPE)
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_mc_depreciation
                 WHERE subline_cd = p_subline_cd)
      LOOP
         v_rec.special_part_cd := i.special_part_cd;
         v_rec.mc_year_fr := i.mc_year_fr;
         v_rec.orig_mc_year_fr := i.mc_year_fr;
         v_rec.rate := i.rate;
         v_rec.subline_cd := i.subline_cd;
         v_rec.loss_exp_desc := NULL;

         FOR mc_desc IN (SELECT loss_exp_desc
                           FROM giis_loss_exp
                          WHERE loss_exp_cd = i.special_part_cd
                            AND line_cd = 'MC'
                            AND subline_cd IS NULL
                            AND loss_exp_type = 'L')
         LOOP
            v_rec.loss_exp_desc := mc_desc.loss_exp_desc;
            EXIT;
         END LOOP;

         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                             TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (
      p_rec               gicl_mc_depreciation%ROWTYPE,
      p_orig_mc_year_fr   gicl_mc_depreciation.mc_year_fr%TYPE
   )
   IS
      v_exist   BOOLEAN := FALSE;
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gicl_mc_depreciation
                 WHERE NVL (special_part_cd, '$@%') =
                                           NVL (p_rec.special_part_cd, '$@%')
                   AND mc_year_fr = p_orig_mc_year_fr
                   AND subline_cd = p_rec.subline_cd)
      LOOP
         v_exist := TRUE;
         EXIT;
      END LOOP;

      IF v_exist
      THEN
         UPDATE gicl_mc_depreciation
            SET rate = p_rec.rate,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE,
                mc_year_fr = p_rec.mc_year_fr
          WHERE NVL (special_part_cd, '$@%') =
                                            NVL (p_rec.special_part_cd, '$@%')
            AND mc_year_fr = p_orig_mc_year_fr
            AND subline_cd = p_rec.subline_cd;
      ELSE
         INSERT INTO gicl_mc_depreciation
                     (special_part_cd, mc_year_fr, rate,
                      subline_cd, remarks, user_id, last_update
                     )
              VALUES (p_rec.special_part_cd, p_rec.mc_year_fr, p_rec.rate,
                      p_rec.subline_cd, p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_subline_cd        gicl_mc_depreciation.subline_cd%TYPE,
      p_special_part_cd   gicl_mc_depreciation.special_part_cd%TYPE,
      p_orig_mc_year_fr   gicl_mc_depreciation.mc_year_fr%TYPE
   )
   AS
   BEGIN
      DELETE FROM gicl_mc_depreciation
            WHERE subline_cd = p_subline_cd
              AND NVL (special_part_cd, '$@%') =
                                                NVL (p_special_part_cd, '$@%')
              AND mc_year_fr = p_orig_mc_year_fr;
   END;

   PROCEDURE val_add_rec (
      p_subline_cd        gicl_mc_depreciation.subline_cd%TYPE,
      p_special_part_cd   gicl_mc_depreciation.special_part_cd%TYPE,
      p_mc_year_fr        gicl_mc_depreciation.mc_year_fr%TYPE
   )
   AS
   BEGIN
      FOR chk IN (SELECT '1'
                    FROM gicl_mc_depreciation
                   WHERE NVL (special_part_cd, '$@%') =
                                               NVL (p_special_part_cd, '$@%')
                     AND mc_year_fr = p_mc_year_fr
                     AND subline_cd = p_subline_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same subline_cd, mc_year_fr and special_part_cd.'
            );
         EXIT;
      END LOOP;
   END;
END;
/


