CREATE OR REPLACE PACKAGE BODY CPI.giis_motortype_pkg
AS
   FUNCTION get_motortype_list (
      p_subline          giis_subline.subline_cd%TYPE,
      p_find_text   IN   VARCHAR2
   )
      RETURN motortype_list_tab PIPELINED
   IS
      v_motortype   motortype_list_type;
   BEGIN
      FOR i IN
         (SELECT   type_cd, motor_type_desc, subline_cd, unladen_wt
              FROM giis_motortype
             WHERE subline_cd = p_subline
               AND (   UPPER (motor_type_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%')
                    OR UPPER (type_cd) LIKE NVL (UPPER (p_find_text), '%%')
                   )
          ORDER BY motor_type_desc)
      LOOP
         v_motortype.type_cd := i.type_cd;
         v_motortype.motor_type_desc := i.motor_type_desc;
         v_motortype.subline_cd := i.subline_cd;
         v_motortype.unladen_wt := i.unladen_wt;
         PIPE ROW (v_motortype);
      END LOOP;

      RETURN;
   END get_motortype_list;

   FUNCTION get_all_motortype_list
      RETURN motortype_list_tab PIPELINED
   IS
      v_motortype   motortype_list_type;
   BEGIN
      FOR i IN (SELECT   type_cd, motor_type_desc, subline_cd, unladen_wt
                    FROM giis_motortype
                ORDER BY motor_type_desc)
      LOOP
         v_motortype.type_cd := i.type_cd;
         v_motortype.motor_type_desc := i.motor_type_desc;
         v_motortype.subline_cd := i.subline_cd;
         v_motortype.unladen_wt := i.unladen_wt;
         PIPE ROW (v_motortype);
      END LOOP;

      RETURN;
   END get_all_motortype_list;
END giis_motortype_pkg;
/


