CREATE OR REPLACE PACKAGE BODY CPI.giacs101_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.25.2013
   **  Reference By : GIACS101- Production Register with Tax Details
   **  Description  :
   */
   FUNCTION get_subline_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_lov_tab PIPELINED
   IS
      v_rec   subline_lov_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                ORDER BY 2)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_line_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   giis_issource.iss_cd%TYPE
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE line_cd =
                            DECODE (check_user_per_line2 (line_cd,
                                                          p_branch_cd,
                                                          'GIACS101',
                                                          p_user_id
                                                         ),
                                    1, line_cd,
                                    NULL
                                   )
                ORDER BY 2)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_branch_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_rec   branch_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, iss_name
                           FROM giis_issource
                          WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                              iss_cd,
                                                              p_module_id,
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


