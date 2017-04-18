CREATE OR REPLACE PACKAGE BODY CPI.giis_reinsurer_type_pkg
AS
   FUNCTION get_ri_type_lov
      RETURN get_ri_type_lov_tab PIPELINED
   IS
      v_list   get_ri_type_lov_type;
   BEGIN
      FOR i IN (SELECT ri_type, ri_type_desc
                  FROM giis_reinsurer_type)
      LOOP
         v_list.ri_type := i.ri_type;
         v_list.ri_type_desc := i.ri_type_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_ri_type_lov;
END giis_reinsurer_type_pkg;
/


