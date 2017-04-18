DROP PROCEDURE CPI.UPDATE_GIPI_WPACK_LINE_SUBLINE;

CREATE OR REPLACE PROCEDURE CPI.update_gipi_wpack_line_subline (
   p_par_id            gipi_wpolbas.par_id%TYPE,
   p_pack_line_cd      gipi_witem.pack_line_cd%TYPE,
   p_pack_subline_cd   gipi_witem.pack_subline_cd%TYPE
)
IS
   p_count_a   NUMBER := 0;
   p_count_b   NUMBER := 0;

   CURSOR a
   IS
      SELECT item_no
        FROM gipi_witem
       WHERE par_id = p_par_id
         AND pack_line_cd = p_pack_line_cd
         AND pack_subline_cd = p_pack_subline_cd;

   CURSOR b (p_item_no NUMBER)
   IS
      SELECT '1'
        FROM gipi_witem_ves
       WHERE par_id = p_par_id AND item_no = p_item_no;
BEGIN
  FOR a1 IN a LOOP
       p_count_a := p_count_a + 1;
       FOR b1 IN b(a1.item_no) LOOP 
           p_count_b := p_count_b + 1;    
       END LOOP;
   END LOOP;
     IF p_count_a = p_count_b THEN
       UPDATE gipi_wpack_line_subline
       SET item_tag = 'Y'
       WHERE par_id = p_par_id
       AND pack_line_cd = p_pack_line_cd
       AND pack_subline_cd = p_pack_subline_cd;
     ELSE
       UPDATE gipi_wpack_line_subline
       SET item_tag = 'N'
       WHERE par_id = p_par_id
       AND pack_line_cd = p_pack_line_cd
       AND pack_subline_cd = p_pack_subline_cd;
     END IF;
END update_gipi_wpack_line_subline;
/


