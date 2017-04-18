DROP PROCEDURE CPI.DELETE_DISTRIBUTION_PACKAGE2;

CREATE OR REPLACE PROCEDURE CPI.delete_distribution_package2 (
   p_par_id        IN   gipi_parlist.par_id%TYPE,
   p_pack_par_id   IN   NUMBER
)
AS
/*
   **  Created by      : Steven Ramirez
    **  Date Created    : 06.06.2013
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Create invoice and delete distribution based on certain conditions
    */
   v_par_status   gipi_parlist.par_status%TYPE;
   v_not_exist    BOOLEAN                        := TRUE;
BEGIN
   FOR a IN (SELECT dist_no
               FROM giuw_pol_dist a
              WHERE a.par_id = p_par_id)
   LOOP
      SELECT par_status
        INTO v_par_status
        FROM gipi_pack_parlist
       WHERE pack_par_id = p_pack_par_id;

      create_invoice_item_package2 (p_par_id, p_pack_par_id);
      create_distribution_item_pkg2 (p_par_id, a.dist_no, p_pack_par_id);

      IF v_par_status = 6
      THEN
         UPDATE gipi_parlist
            SET par_status = 5
          WHERE pack_par_id = p_pack_par_id AND par_id = p_par_id;
      END IF;

      IF v_par_status = 6 OR v_par_status = 5
      THEN
         FOR b IN (SELECT '1' exist
                     FROM gipi_witem
                    WHERE par_id = p_par_id)
         LOOP
            v_not_exist := FALSE;
            EXIT;
         END LOOP;

         IF v_not_exist
         THEN
            UPDATE gipi_pack_parlist
               SET par_status = 3
             WHERE pack_par_id = p_pack_par_id;

            UPDATE gipi_parlist
               SET par_status = 3
             WHERE pack_par_id = p_pack_par_id AND par_id = p_par_id;
         END IF;
      END IF;

      EXIT;
   END LOOP;
END delete_distribution_package2;
/


