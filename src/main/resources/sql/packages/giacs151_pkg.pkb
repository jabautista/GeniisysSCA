CREATE OR REPLACE PACKAGE BODY CPI.giacs151_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.08.2013
   **  Reference By : GIACS151- Special Reports
   **  Description  :
   */
   FUNCTION get_report_lov
      RETURN report_lov_tab PIPELINED
   IS
      v_rec   report_lov_type;
   BEGIN
      FOR i IN (SELECT rep_cd, rep_title
                  FROM giac_eom_rep)
      LOOP
         v_rec.rep_cd := i.rep_cd;
         v_rec.rep_title := i.rep_title;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


