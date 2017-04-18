CREATE OR REPLACE PACKAGE BODY CPI.security_access
AS
   FUNCTION get_branch_line (
      p_module_type   VARCHAR2,
      --p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN branch_list_tab PIPELINED
   IS
/* Created by: Mikel 12.12.2014
** Description: Optimize use of check user functions of accounting, underwriting and claims.
** 
** Modified by: vondanix 10.06.2015
** Remarks : Added condition for module type Claims.
*/
      v_string    VARCHAR2 (32767);
      v_string2   VARCHAR2 (32767);
      v_branch    VARCHAR2 (10);
      v_list      branch_line_list_type;
   BEGIN
      IF p_module_type = 'AC' --accounting
      THEN
         FOR rec IN (SELECT branch_cd
                       FROM giac_branches
                      WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                          branch_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ) = 1)
         LOOP
            v_list.branch_cd := rec.branch_cd;
            PIPE ROW (v_list);
         END LOOP;
      ELSIF p_module_type = 'UW' --underwriting
      THEN
         FOR rec IN (SELECT branch_cd, line_cd
                       FROM giac_branches a, giis_line b --cartesian product
                      WHERE check_user_per_iss_cd2 (line_cd,
                                                    branch_cd,
                                                    p_module_id,
                                                    p_user_id
                                                   ) = 1)
         LOOP
            v_list.branch_cd := rec.branch_cd;
            v_list.line_cd := rec.line_cd;
            PIPE ROW (v_list);
         END LOOP;
      ELSIF p_module_type = 'CL' --claims
      THEN
         FOR rec IN (SELECT branch_cd, line_cd
                       FROM giac_branches a, giis_line b --cartesian product
                      WHERE check_user_per_iss_cd2 (line_cd,
                                                    branch_cd,
                                                    p_module_id,
                                                    p_user_id
                                                   ) = 1)
         LOOP
            v_list.branch_cd := rec.branch_cd;
            v_list.line_cd := rec.line_cd;
            PIPE ROW (v_list);
         END LOOP;
      END IF;
   END;
END;
/
