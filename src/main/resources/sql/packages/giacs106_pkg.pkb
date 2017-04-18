CREATE OR REPLACE PACKAGE BODY CPI.GIACS106_PKG
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.08.2013
   **  Reference By : GIACS106- Schedule of Due to RI Facultative
   **  Description  :
   */
   FUNCTION get_line_lov (p_ri_cd giri_binder.ri_cd%TYPE)
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd line_cd, b.line_name line_name
                           FROM giri_binder a, giis_line b
                          WHERE a.line_cd = b.line_cd
                            AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                       /*DECODE (p_ri_cd,
                               NULL, a.ri_cd,
                               p_ri_cd
                              )*/
                ORDER BY        b.line_name)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED
   IS
      v_rec   ri_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.ri_cd, b.ri_name
                           FROM giri_binder a, giis_reinsurer b
                          WHERE a.ri_cd = b.ri_cd)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


