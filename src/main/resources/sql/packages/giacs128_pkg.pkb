CREATE OR REPLACE PACKAGE BODY CPI.giacs128_pkg
AS
   PROCEDURE extract_records (
      p_from_date    DATE,
      p_to_date      DATE,
      p_module_id    VARCHAR,
      p_per_branch   VARCHAR,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
   
   /************************************
   ** MJ Fabroa 2014-11-04
   ** Removed redundant DML deletes
   ** There are also DML deletes inside
   ** prodrep_dist_ext2 and prodrep_peril_ext2
   
     DELETE FROM giac_prodrep_dist_ext
            WHERE user_id = p_user_id;

      DELETE FROM giac_prodrep_peril_ext
            WHERE user_id = p_user_id;
   
   ************************************/
    
      prodrep_dist_ext2 (p_from_date,
                         p_to_date,
                         p_module_id,
                         p_per_branch,
                         p_user_id
                        );
    
      prodrep_peril_ext2 (p_from_date, p_to_date, p_user_id);
      
   END extract_records;

   FUNCTION check_prev_ext (p_user_id giis_users.user_id%TYPE)
      RETURN check_prev_ext_tab PIPELINED
   IS
      v_ext   check_prev_ext_type;
   BEGIN
      FOR i IN (SELECT from_date1, to_date1, user_id
                  FROM giac_prodrep_peril_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_ext.v_from_date := TO_CHAR (i.from_date1, 'MM-DD-RRRR');
         v_ext.v_to_date := TO_CHAR (i.to_date1, 'MM-DD-RRRR');
         PIPE ROW (v_ext);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_list   branch_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, iss_name
                           FROM giis_issource
                          WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                              iss_cd,
                                                              'GIACS128',
                                                              p_user_id
                                                             ) = 1
                            AND UPPER (iss_cd) LIKE
                                         UPPER (NVL (p_keyword, iss_cd))
                                         || '%'
                       ORDER BY 2)
      LOOP
         v_list.branch_cd := i.iss_cd;
         v_list.branch_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_line_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_list   line_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT line_cd, line_name
                           FROM giis_line
                          WHERE (   UPPER (line_cd) LIKE
                                          '%'
                                       || UPPER (NVL (p_keyword, line_cd))
                                       || '%'
                                 OR UPPER (line_name) LIKE
                                          '%'
                                       || UPPER (NVL (p_keyword, line_name))
                                       || '%'
                                )
                       ORDER BY 2)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
END;
/


