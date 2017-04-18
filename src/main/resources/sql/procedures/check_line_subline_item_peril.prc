DROP PROCEDURE CPI.CHECK_LINE_SUBLINE_ITEM_PERIL;

CREATE OR REPLACE PROCEDURE CPI.check_line_subline_item_peril (
   p_par_id            IN       gipi_wpack_line_subline.par_id%TYPE,
   p_pack_line_cd      IN       gipi_wpack_line_subline.pack_line_cd%TYPE,
   p_pack_subline_cd   IN       gipi_wpack_line_subline.pack_subline_cd%TYPE,
   p_item              OUT      NUMBER,
   p_peril             OUT      NUMBER
)
AS
/*
**  Created by        : Irwin
**  Date Created     : 03.21.2011
**  Reference By     : (GIPIS093 - Pack Line Subline Coverages)
**  Description     : This procedure returns the no of item and peril of the given par_id, pack_line_cd, pack_subline_cd
*/
BEGIN
   p_item := 0;
   p_peril := 0;

   -- check if PAR already have existing items
   FOR item IN (SELECT '1'
                  FROM gipi_witem
                 WHERE par_id = p_par_id
                   AND pack_line_cd = p_pack_line_cd
                   AND pack_subline_cd = p_pack_subline_cd)
   LOOP
      p_item := p_item + 1;
   END LOOP;

   FOR a1 IN (SELECT item_no
                FROM gipi_witem
               WHERE par_id = p_par_id
                 AND pack_line_cd = p_pack_line_cd
                 AND pack_subline_cd = p_pack_subline_cd)
   LOOP
      SELECT COUNT (*)
        INTO p_peril
        FROM gipi_witmperl
       WHERE par_id = p_par_id AND item_no = a1.item_no;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END check_line_subline_item_peril;
/


