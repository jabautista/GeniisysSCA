DROP PROCEDURE CPI.GIPIS093_DEL_TABLES;

CREATE OR REPLACE PROCEDURE CPI.gipis093_del_tables (
   p_par_id            gipi_wpack_line_subline.par_id%TYPE,
   p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
   p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE
)
IS
BEGIN
   FOR a1 IN (SELECT item_no
                FROM gipi_witem
               WHERE par_id = p_par_id
                 AND pack_line_cd = p_pack_line_cd
                 AND pack_subline_cd = p_pack_subline_cd)
   LOOP
      DELETE      gipi_wfireitm
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_waviation_item
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_witem_ves
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wcasualty_item
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wcasualty_personnel
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wgrouped_items
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wdeductibles
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wlocation
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_waccident_item
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wcargo_carrier
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wcargo
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wvehicle
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wmcacc
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wmortgagee
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wbeneficiary
            WHERE par_id = p_par_id AND item_no = a1.item_no;

      DELETE      gipi_wgrp_items_beneficiary
            WHERE par_id = p_par_id AND item_no = a1.item_no;
   END LOOP;
END;
/


