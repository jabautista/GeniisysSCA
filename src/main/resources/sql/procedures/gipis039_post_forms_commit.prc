DROP PROCEDURE CPI.GIPIS039_POST_FORMS_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.gipis039_post_forms_commit (
   p_par_id                     gipi_parlist.par_id%TYPE,
   p_pack_par_id                gipi_parlist.pack_par_id%TYPE,
   p_var_post                   VARCHAR2,
   p_var_post2                  VARCHAR2,
   p_nbt_invoice_sw             VARCHAR2,
   --p_var_endt_tax_sw   IN OUT VARCHAR2,
   p_var_group_sw               VARCHAR2,
   p_var_negate_item   IN OUT   VARCHAR2,
   p_button_id1                 NUMBER,
   p_button_id2                 NUMBER
)
IS
   p_par_status      gipi_parlist.par_status%TYPE;
   v_pack_pol_flag   gipi_wpolbas.pack_pol_flag%TYPE;
   v_line_cd         gipi_wpolbas.line_cd%TYPE;
   v_subline_cd      gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd          gipi_wpolbas.iss_cd%TYPE;
   p_exist1          VARCHAR2 (1)                      := 'N';
   p_exist2          VARCHAR2 (1)                      := 'N';
   p_dist_no         NUMBER                            := 0;
   v_counter         NUMBER                            := 0;
   v_counter1        NUMBER                            := 0;
   v_exist           VARCHAR2 (1)                      := 'N';
   v_endt_tax_sw     VARCHAR2(1);

   CURSOR c1
   IS
      SELECT item_no
        FROM gipi_witem
       WHERE par_id = p_par_id;
BEGIN
   IF p_var_post2 = 'N'
   THEN
      RETURN;
   END IF;

   FOR a IN (SELECT endt_tax
               FROM gipi_wendttext
              WHERE par_id = p_par_id)
   LOOP
      v_endt_tax_sw := a.endt_tax;
      EXIT;
   END LOOP;

/* Created by   : Daphne                          */
/* Updated date : 07/22/97                        */
/* Updated by   : Gazzel                          */
/* Add additional validations prior to commit.    */
   BEGIN
      FOR wpolbas IN (SELECT line_cd, subline_cd, pack_pol_flag, iss_cd
                        FROM gipi_wpolbas
                       WHERE par_id = p_par_id)
      LOOP
         v_line_cd := wpolbas.line_cd;
         v_subline_cd := wpolbas.subline_cd;
         v_iss_cd := wpolbas.iss_cd;
         v_pack_pol_flag := wpolbas.pack_pol_flag;
         EXIT;
      END LOOP;

      FOR a1 IN (SELECT dist_no
                   FROM giuw_pol_dist
                  WHERE par_id = p_par_id)
      LOOP
         p_dist_no := a1.dist_no;
         EXIT;
      END LOOP;

      BEGIN
         SELECT DISTINCT 1
                    INTO v_counter
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id;
      --AND     line_cd =  :b240.line_cd
      --AND     item_no =  C1_rec.item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --BETH 031899 insert record in gipi_parhist everytime there are changes made
      IF p_var_post IS NULL
      THEN
         insert_parhist (p_par_id, NVL (giis_users_pkg.app_user, USER));
      END IF;

      IF p_nbt_invoice_sw = 'Y' AND p_var_post IS NULL
      THEN
         BEGIN
            FOR a IN (SELECT par_status
                        FROM gipi_pack_parlist
                       WHERE pack_par_id = p_pack_par_id)
            LOOP
               p_par_status := a.par_status;
               EXIT;
            END LOOP;
            
            IF v_line_cd = 'FI' THEN
                check_addtl_info (p_par_id, v_pack_pol_flag);
            END IF;
            
            /* Check fire information for every new items */
            change_item_grp (p_par_id, v_pack_pol_flag);

            /* Change item grouping based on currency code   */

            --IF (nvl(variables.endt_tax_sw,'N') = 'Y' AND v_counter > 0) OR
            IF NVL (v_endt_tax_sw, 'N') != 'Y'
            THEN
               delete_bill (p_par_id);
            END IF;

            update_gipi_wpolbas2 (p_par_id, p_var_negate_item);

            /* Updates amounts and no of items in gipi_wpolbas */
            FOR a2 IN (SELECT DISTINCT 1
                                  FROM gipi_witem
                                 WHERE par_id = p_par_id)
            LOOP
               gipis039_create_distribution (p_par_id,
                                             p_dist_no,
                                             p_button_id1,
                                             p_button_id2
                                            );
               p_exist1 := 'Y';
               EXIT;
            END LOOP;

            IF NVL (v_endt_tax_sw, 'N') != 'Y'
            THEN
               FOR a3 IN (SELECT DISTINCT 1
                                     FROM gipi_witmperl
                                    WHERE par_id = p_par_id)
               LOOP
                  gipis039_populate_orig_itmperl (p_par_id);
                  create_winvoice (0, 0, 0, p_par_id, v_line_cd, v_iss_cd);
                  -- modified by aivhie 120601
                  p_exist2 := 'Y';
                  EXIT;
               END LOOP;
            END IF;

            FOR a4 IN (SELECT item_no
                         FROM gipi_witem
                        WHERE par_id = p_par_id)
            LOOP
               v_exist := 'Y';
               EXIT;
            END LOOP;

            IF p_exist1 = 'N'
            THEN                                         /* No items found  */
               FOR z IN (SELECT dist_no
                           FROM giuw_pol_dist
                          WHERE par_id = p_par_id)
               LOOP
                  gipis039_delete_distribution (p_dist_no);
               END LOOP;
            END IF;

            IF (p_exist2 = 'N' AND NVL (v_endt_tax_sw, 'N') != 'Y')
            THEN                                         /* No perils found */
               BEGIN
                  DELETE      gipi_winvperl
                        WHERE par_id = p_par_id;

                  DELETE      gipi_winv_tax
                        WHERE par_id = p_par_id;

                  DELETE      gipi_winvoice
                        WHERE par_id = p_par_id;
               END;
            END IF;
         END;

         gipis039_add_par_status_no (p_par_id,
                                     v_line_cd,
                                     p_par_status,
                                     v_iss_cd,
                                     v_endt_tax_sw,
                                     p_var_negate_item,
                                     p_button_id1,
                                     p_button_id2
                                    );
      --validate_par_status (p_par_id);
      END IF;

      IF p_var_group_sw = 'Y'
      THEN
         change_item_grp (p_par_id, v_pack_pol_flag);
      END IF;

      --A.R.C. 09.04.2006
      --to update the menu items for the packages
      --check_pack_pol_flag;
      update_gipi_wpack_line_subline (p_par_id, v_line_cd, v_subline_cd);
      --set_package_menu;
      p_var_negate_item := 'N';
   END;
END gipis039_post_forms_commit;
/


