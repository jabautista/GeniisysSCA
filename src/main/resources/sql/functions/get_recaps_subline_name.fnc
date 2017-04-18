DROP FUNCTION CPI.GET_RECAPS_SUBLINE_NAME;

CREATE OR REPLACE FUNCTION CPI.get_recaps_subline_name (
   p_rowtitle   giac_recap_summ_ext.rowtitle%TYPE,
   p_line_cd    giis_line.line_cd%TYPE
)
/* Created by : Mikel
** Date Created : 04.11.2014
** Description : For RECAPS purposes only. Display subline name if rowtitle is found in giis_subline else display rowtitle
*/
   RETURN VARCHAR2
AS
   CURSOR sub
   IS
      SELECT subline_name
        FROM giis_subline
       WHERE line_cd = p_line_cd AND subline_cd = p_rowtitle;

   v_subline_name   VARCHAR2 (100);
   v_rowtitle       VARCHAR2 (100) := p_rowtitle;
BEGIN
   OPEN sub;

   FETCH sub
    INTO v_subline_name;

   IF sub%FOUND
   THEN
      CLOSE sub;

      RETURN v_subline_name;
   ELSE
      CLOSE sub;

      RETURN v_rowtitle;
   END IF;
END;
/


