CREATE OR REPLACE PACKAGE BODY CPI.giis_nationality_pkg
AS
   FUNCTION get_nationality_list (p_find_text IN VARCHAR2)
      RETURN nationality_lov_tab PIPELINED
   IS
      v_nat   nationality_lov_type;
   BEGIN
      FOR i IN
         (SELECT nationality_cd, nationality_desc
            FROM giis_nationality
           WHERE 1 = 1
             AND (   UPPER (nationality_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%')
                  OR UPPER (nationality_cd) LIKE
                                               NVL (UPPER (p_find_text), '%%')
                 ))
      LOOP
         v_nat.nationality_cd := i.nationality_cd;
         v_nat.nationality_desc := i.nationality_desc;
         PIPE ROW (v_nat);
      END LOOP;
   END;
END;
/


