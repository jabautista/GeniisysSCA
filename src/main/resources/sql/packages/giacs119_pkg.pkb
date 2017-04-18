CREATE OR REPLACE PACKAGE BODY CPI.giacs119_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.08.2013
   **  Reference By : GIACS119 - Losses Recoverable from Facultative Reinsurer
   **  Description  :
   */
   FUNCTION get_line_lov
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT (l.line_cd) line_code, l.line_name line_name
                           FROM giis_line l, gipi_polbasic b
                          WHERE l.line_cd = b.line_cd)
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
      FOR i IN (SELECT DISTINCT (r.ri_cd) ri_cd, r.ri_sname ri_sname,
                                r.ri_name ri_name
                           FROM gicl_advs_fla f, giis_reinsurer r
                          WHERE f.ri_cd = r.ri_cd)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.ri_sname := i.ri_sname;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


