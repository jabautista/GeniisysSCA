CREATE OR REPLACE PACKAGE BODY CPI.giacs111_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.08.2013
   **  Reference By : GIACS111- Production Register with Peril Breakdown
   **  Description  :
   */
   FUNCTION get_line_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_iss_cd    giis_issource.iss_cd%TYPE
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               'GIACS111',
                                               p_user_id
                                              ) = 1
                ORDER BY 2)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_lov_tab PIPELINED
   IS
      v_rec   branch_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                     iss_cd,
                                                     'GIACS111',
                                                     p_user_id
                                                    ) = 1)
      LOOP
         v_rec.branch_cd := i.iss_cd;
         v_rec.branch_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


