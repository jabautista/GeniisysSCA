CREATE OR REPLACE PACKAGE BODY CPI.giacs105_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.08.2013
   **  Reference By : GIACS105- Inward Business
   **  Description  :
   */
   FUNCTION get_line_lov 
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd line_code, line_name
                    FROM giis_line
                ORDER BY 1)
      LOOP
         v_rec.line_cd := i.line_code;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED
   IS
      v_rec   ri_lov_type;
   BEGIN
      FOR i IN (SELECT   garsd.a180_ri_cd ri_cd, gr.ri_name ri_name
                    FROM giac_aging_ri_soa_details garsd, giis_reinsurer gr
                   WHERE garsd.a180_ri_cd = gr.ri_cd
                GROUP BY garsd.a180_ri_cd, gr.ri_name)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


