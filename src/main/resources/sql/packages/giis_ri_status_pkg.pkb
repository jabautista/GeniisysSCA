CREATE OR REPLACE PACKAGE BODY CPI.giis_ri_status_pkg
AS
   FUNCTION get_ri_status_lov
      RETURN get_ri_status_lov_tab PIPELINED
   IS
      v_list   get_ri_status_lov_type;
   BEGIN
      FOR i IN (SELECT status_cd, status_desc
                  FROM giis_ri_status)
      LOOP
         v_list.status_cd := i.status_cd;
         v_list.status_desc := i.status_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_ri_status_lov;
END giis_ri_status_pkg;
/


