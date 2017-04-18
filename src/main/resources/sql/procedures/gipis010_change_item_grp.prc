DROP PROCEDURE CPI.GIPIS010_CHANGE_ITEM_GRP;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_CHANGE_ITEM_GRP (
   p_par_id          IN   gipi_parlist.par_id%TYPE,
   p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE)
IS
   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.17.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Updates the item grouping of the items inserted
   **                  based on the currency rate selected.
   **                  Since the addition of the columns pack_line_cd
   **                  and pack_subline_cd, then the item grouping for
   **               packaged policy must be done accordingly, items
   **               for package policy must be grouped not only by
   **               currency_cd and currency_rt but by pack_line_cd
   **               and pack_subline_cd as well (from module).
   */
   v_item_grp   gipi_witem.item_grp%TYPE   := 1;
BEGIN
   UPDATE gipi_witem
      SET item_grp = NULL
    WHERE par_id = p_par_id;

   IF p_pack_pol_flag = 'Y' THEN
        FOR c1 IN (
            SELECT currency_cd, currency_rt, pack_line_cd,
                   pack_subline_cd
              FROM gipi_witem
             WHERE par_id = p_par_id
          GROUP BY currency_cd, currency_rt, pack_line_cd, pack_subline_cd
          ORDER BY currency_cd, currency_rt, pack_line_cd, pack_subline_cd)
        LOOP
            UPDATE gipi_witem
               SET item_grp = v_item_grp
             WHERE currency_rt = c1.currency_rt
               AND currency_cd = c1.currency_cd
               AND pack_line_cd = c1.pack_line_cd
               AND pack_subline_cd = c1.pack_subline_cd
               AND par_id = p_par_id;

            v_item_grp := v_item_grp + 1;
        END LOOP;
    ELSE
        FOR c2 IN (
            SELECT currency_cd, currency_rt
              FROM gipi_witem
             WHERE par_id = p_par_id
          GROUP BY currency_cd, currency_rt
          ORDER BY currency_cd, currency_rt)
        LOOP
            UPDATE gipi_witem
               SET item_grp = v_item_grp
             WHERE currency_rt = c2.currency_rt
               AND currency_cd = c2.currency_cd
               AND par_id = p_par_id;

            v_item_grp := v_item_grp + 1;
        END LOOP;
    END IF;
END GIPIS010_CHANGE_ITEM_GRP;
/


