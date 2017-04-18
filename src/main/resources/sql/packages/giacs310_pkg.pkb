CREATE OR REPLACE PACKAGE BODY CPI.GIACS310_PKG
AS
   FUNCTION get_rec_list(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN rec_tab PIPELINED AS
      v_list                  rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_aging_parameters
                 WHERE check_user_per_iss_cd_acctg2(NULL, gibr_branch_cd, p_module_id, p_user_id) = 1
                 ORDER BY gibr_gfun_fund_cd, gibr_branch_cd, over_due_tag, column_no)
      LOOP
         v_list.aging_id := i.aging_id;
         v_list.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.column_no := i.column_no;
         v_list.column_heading := i.column_heading;
         v_list.min_no_days := i.min_no_days;
         v_list.max_no_days := i.max_no_days;
         v_list.over_due_tag := i.over_due_tag;
         v_list.rep_col_no := i.rep_col_no;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR(i.last_update, 'mm-dd-yyyy HH:MI:ss AM');
         v_list.remarks := i.remarks;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         
         FOR f IN (SELECT fund_desc
                     FROM giis_funds
                    WHERE fund_cd = i.gibr_gfun_fund_cd)
         LOOP
            v_list.fund_desc := f.fund_desc;
         END LOOP; 
         
         FOR b IN (SELECT branch_name
                     FROM giac_branches
                    WHERE branch_cd = i.gibr_branch_cd)
         LOOP
            v_list.branch_name := b.branch_name;
         END LOOP; 
         
         PIPE ROW(v_list);
      END LOOP;
   END;

   FUNCTION get_fund_cd_lov(
      p_keyword         VARCHAR2
   ) RETURN fund_lov_tab PIPELINED AS
      v_list            fund_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.fund_cd, a.fund_desc
                  FROM giis_funds a, giac_branches b
                 WHERE a.fund_cd = b.gfun_fund_cd
                   AND (UPPER(fund_cd) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%'
				            OR UPPER(fund_desc) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%')
                 ORDER BY a.fund_desc, a.fund_cd)
      LOOP
         v_list.gibr_gfun_fund_cd := i.fund_cd;
         v_list.fund_desc := i.fund_desc;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION get_branch_cd_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,  
      p_keyword         VARCHAR2
   ) RETURN branch_lov_tab PIPELINED AS
      v_list            branch_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM giac_branches
                 WHERE (UPPER(branch_cd) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%'
				            OR UPPER(branch_name) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%')
                   AND check_user_per_iss_cd_acctg2(NULL, branch_cd, p_module_id, p_user_id) = 1
                 ORDER BY branch_name, branch_cd)
      LOOP
         v_list.gibr_branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END; 
   
   FUNCTION get_branch_cd_to_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,  
      p_keyword         VARCHAR2
   ) RETURN branch_lov_tab PIPELINED AS
      v_list            branch_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name 
                  FROM giis_issource 
                 WHERE iss_cd NOT IN (SELECT gibr_branch_cd 
                                        FROM giac_aging_parameters)
                   AND check_user_per_iss_cd_acctg2(NULL, iss_cd, p_module_id, p_user_id) = 1
                   AND (UPPER(iss_cd) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%'
				            OR UPPER(iss_name) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%'))
      LOOP
         v_list.gibr_branch_cd := i.iss_cd;
         v_list.branch_name := i.iss_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION get_branch_cd_from_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,  
      p_keyword         VARCHAR2
   ) RETURN branch_lov_tab PIPELINED AS
      v_list            branch_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.gibr_branch_cd, b.iss_name 
                  FROM giac_aging_parameters a, giis_issource b 
                 WHERE a.gibr_branch_cd = b.iss_cd
                   AND (UPPER(a.gibr_branch_cd) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%'
				            OR UPPER(b.iss_name) LIKE '%' || UPPER(NVL(p_keyword, '')) || '%'))
      LOOP
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.branch_name := i.iss_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   PROCEDURE set_rec (p_rec giac_aging_parameters%ROWTYPE)
   IS
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
   BEGIN
      IF p_rec.aging_id IS NULL THEN
         SELECT MAX(NVL(aging_id,0)) + 1
           INTO v_aging_id
           FROM giac_aging_parameters;
      END IF;
   
      MERGE INTO giac_aging_parameters
         USING DUAL
         ON (aging_id = p_rec.aging_id)
         WHEN NOT MATCHED THEN
            INSERT (aging_id, gibr_gfun_fund_cd, gibr_branch_cd, column_no, column_heading, min_no_days,
                    max_no_days, over_due_tag, rep_col_no, user_id, last_update, remarks)
            VALUES (v_aging_id, p_rec.gibr_gfun_fund_cd, p_rec.gibr_branch_cd, p_rec.column_no, p_rec.column_heading, p_rec.min_no_days,
                    p_rec.max_no_days, p_rec.over_due_tag, p_rec.rep_col_no, p_rec.user_id, SYSDATE, p_rec.remarks)
         WHEN MATCHED THEN
            UPDATE
               SET gibr_gfun_fund_cd = p_rec.gibr_gfun_fund_cd, 
                   gibr_branch_cd = p_rec.gibr_branch_cd, 
                   column_no = p_rec.column_no, 
                   column_heading = p_rec.column_heading, 
                   min_no_days = p_rec.min_no_days,
                   max_no_days = p_rec.max_no_days, 
                   over_due_tag = p_rec.over_due_tag, 
                   rep_col_no = p_rec.rep_col_no, 
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE, 
                   remarks  = p_rec.remarks;
   END;
   
   PROCEDURE del_rec (p_rec giac_aging_parameters%ROWTYPE)
   IS
   BEGIN
      DELETE FROM giac_aging_parameters
       WHERE aging_id = p_rec.aging_id; 
   END;
   
   PROCEDURE copy_records(
      p_fund_cd_from    giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      p_branch_cd_from  giac_aging_parameters.gibr_branch_cd%TYPE,
      p_fund_cd_to      giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      p_branch_cd_to    giac_aging_parameters.gibr_branch_cd%TYPE,
      p_user_id         giac_aging_parameters.user_id%TYPE
   ) AS
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
   BEGIN
      SELECT MAX(NVL(aging_id,0))
        INTO v_aging_id
        FROM giac_aging_parameters;
   
      FOR i IN (SELECT column_no, column_heading, rep_col_no,
                       min_no_days, max_no_days, over_due_tag, remarks
                  FROM giac_aging_parameters
                 WHERE gibr_gfun_fund_cd = p_fund_cd_from
                   AND gibr_branch_cd = p_branch_cd_from
                 ORDER BY rep_col_no)
      LOOP
         v_aging_id := v_aging_id + 1;
           
         INSERT INTO giac_aging_parameters
                (aging_id, gibr_gfun_fund_cd, gibr_branch_cd, column_no, column_heading, min_no_days,
                 max_no_days, over_due_tag, rep_col_no, user_id, last_update, remarks)
         VALUES (v_aging_id, p_fund_cd_to, p_branch_cd_to, i.column_no, i.column_heading, i.min_no_days,
                 i.max_no_days, i.over_due_tag, i.rep_col_no, p_user_id, SYSDATE, i.remarks);
      END LOOP;                 
   END; 
END;
/


