CREATE OR REPLACE PACKAGE BODY CPI.GIACS321_PKG
AS
   FUNCTION get_giac_modules(
      p_keyword         VARCHAR2
   ) RETURN giac_modules_tab PIPELINED AS
      v_list            giac_modules_type;
   BEGIN
      FOR i IN (SELECT module_id, module_name, scrn_rep_name
                  FROM giac_modules
                 WHERE mod_entries_tag = 'Y'
                   AND (UPPER(module_name) LIKE UPPER(NVL(p_keyword, '%'))
				            OR UPPER(scrn_rep_name) LIKE UPPER(NVL(p_keyword, '%'))))
      LOOP
         v_list.module_id := i.module_id;
         v_list.module_name := i.module_name;
         v_list.scrn_rep_name := i.scrn_rep_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;            
   FUNCTION get_rec_list (
      p_module_id             giac_module_entries.module_id%TYPE,
      p_item_no               giac_module_entries.item_no%TYPE,
      p_gl_acct_category      giac_module_entries.gl_acct_category%TYPE,
      p_gl_control_acct       giac_module_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_module_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_module_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_module_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_module_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_module_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_module_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_module_entries.gl_sub_acct_7%TYPE,
      p_sl_type_cd            giac_module_entries.sl_type_cd%TYPE,
      p_line_dependency_level giac_module_entries.line_dependency_level%TYPE,
      p_subline_level         giac_module_entries.subline_level%TYPE,
      p_branch_level          giac_module_entries.branch_level%TYPE,
      p_intm_type_level       giac_module_entries.intm_type_level%TYPE,
      p_ca_treaty_type_level  giac_module_entries.ca_treaty_type_level%TYPE,
      p_old_new_acct_level    giac_module_entries.old_new_acct_level%TYPE,
      p_dr_cr_tag             giac_module_entries.dr_cr_tag%TYPE,
      p_pol_type_tag          giac_module_entries.pol_type_tag%TYPE
   ) RETURN rec_tab PIPELINED AS
      v_list                  rec_type;
   BEGIN
      SELECT MAX(item_no)
        INTO v_list.max_item_no
        FROM giac_module_entries
       WHERE module_id = p_module_id;
       
      IF v_list.max_item_no IS NULL THEN
         v_list.max_item_no := 0;
      END IF;
   
      FOR i IN (SELECT *
                  FROM giac_module_entries
                 WHERE module_id = p_module_id
                   AND item_no = NVL(p_item_no, item_no)
                   AND gl_acct_category = NVL(p_gl_acct_category, gl_acct_category)
                   AND gl_control_acct = NVL(p_gl_control_acct, gl_control_acct)
                   AND gl_sub_acct_1 = NVL(p_gl_sub_acct_1, gl_sub_acct_1)
                   AND gl_sub_acct_2 = NVL(p_gl_sub_acct_2, gl_sub_acct_2)
                   AND NVL(TO_CHAR(gl_sub_acct_3), '%') LIKE NVL(TO_CHAR(p_gl_sub_acct_3), '%')
                   AND NVL(TO_CHAR(gl_sub_acct_4), '%') LIKE NVL(TO_CHAR(p_gl_sub_acct_4), '%')
                   AND NVL(TO_CHAR(gl_sub_acct_5), '%') LIKE NVL(TO_CHAR(p_gl_sub_acct_5), '%')
                   AND NVL(TO_CHAR(gl_sub_acct_6), '%') LIKE NVL(TO_CHAR(p_gl_sub_acct_6), '%')
                   AND NVL(TO_CHAR(gl_sub_acct_7), '%') LIKE NVL(TO_CHAR(p_gl_sub_acct_7), '%')
                   AND NVL(UPPER(sl_type_cd), '%') LIKE NVL(UPPER(p_sl_type_cd), '%')
                   AND NVL(TO_CHAR(line_dependency_level), '%') LIKE NVL(TO_CHAR(p_line_dependency_level), '%')
                   AND NVL(TO_CHAR(subline_level), '%') LIKE NVL(TO_CHAR(p_subline_level), '%')
                   AND NVL(TO_CHAR(branch_level), '%') LIKE NVL(TO_CHAR(p_branch_level), '%')
                   AND NVL(TO_CHAR(intm_type_level), '%') LIKE NVL(TO_CHAR(p_intm_type_level), '%')
                   AND NVL(TO_CHAR(ca_treaty_type_level), '%') LIKE NVL(TO_CHAR(p_ca_treaty_type_level), '%')
                   AND NVL(TO_CHAR(old_new_acct_level), '%') LIKE NVL(TO_CHAR(p_old_new_acct_level), '%')
                   AND NVL(dr_cr_tag, '%') LIKE NVL(UPPER(p_dr_cr_tag), '%')
                   AND NVL(pol_type_tag, '%') LIKE NVL(UPPER(p_pol_type_tag), '%')
                 ORDER BY item_no)
      LOOP
         v_list.module_id := i.module_id;
         v_list.item_no := i.item_no;
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.pol_type_tag := i.pol_type_tag;
         v_list.dr_cr_tag := i.dr_cr_tag;
         v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_list.sl_type_cd := i.sl_type_cd;
         v_list.description := i.description;
         v_list.line_dependency_level := i.line_dependency_level;
         v_list.intm_type_level := i.intm_type_level;
         v_list.old_new_acct_level := i.old_new_acct_level;
         v_list.ca_treaty_type_level := i.ca_treaty_type_level;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.subline_level := i.subline_level;
         v_list.neg_item_no := i.neg_item_no;
         v_list.branch_level := i.branch_level;
         
         PIPE ROW(v_list);
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giac_module_entries%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_module_entries
         USING DUAL
         ON (module_id = p_rec.module_id
             AND item_no = p_rec.item_no)
         WHEN NOT MATCHED THEN
            INSERT (module_id, item_no, gl_acct_category, gl_control_acct, pol_type_tag, dr_cr_tag,
                    gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                    gl_sub_acct_7, sl_type_cd, description, line_dependency_level, intm_type_level,
                    old_new_acct_level, ca_treaty_type_level, user_id, last_update, cpi_rec_no,
                    cpi_branch_cd, subline_level, neg_item_no, branch_level)
            VALUES (p_rec.module_id, p_rec.item_no, p_rec.gl_acct_category, p_rec.gl_control_acct, p_rec.pol_type_tag, p_rec.dr_cr_tag,
                    p_rec.gl_sub_acct_1, p_rec.gl_sub_acct_2, p_rec.gl_sub_acct_3, p_rec.gl_sub_acct_4, p_rec.gl_sub_acct_5, p_rec.gl_sub_acct_6,
                    p_rec.gl_sub_acct_7, p_rec.sl_type_cd, p_rec.description, p_rec.line_dependency_level, p_rec.intm_type_level,
                    p_rec.old_new_acct_level, p_rec.ca_treaty_type_level, p_rec.user_id, SYSDATE, p_rec.cpi_rec_no,
                    p_rec.cpi_branch_cd, p_rec.subline_level, p_rec.neg_item_no, p_rec.branch_level)
         WHEN MATCHED THEN
            UPDATE
               SET gl_acct_category = p_rec.gl_acct_category, 
                   gl_control_acct = p_rec.gl_control_acct, 
                   pol_type_tag = p_rec.pol_type_tag, 
                   dr_cr_tag = p_rec.dr_cr_tag,
                   gl_sub_acct_1 = p_rec.gl_sub_acct_1, 
                   gl_sub_acct_2 = p_rec.gl_sub_acct_2, 
                   gl_sub_acct_3 = p_rec.gl_sub_acct_3, 
                   gl_sub_acct_4 = p_rec.gl_sub_acct_4, 
                   gl_sub_acct_5 = p_rec.gl_sub_acct_5, 
                   gl_sub_acct_6 = p_rec.gl_sub_acct_6,
                   gl_sub_acct_7 = p_rec.gl_sub_acct_7, 
                   sl_type_cd = p_rec.sl_type_cd, 
                   description = p_rec.description, 
                   line_dependency_level = p_rec.line_dependency_level, 
                   intm_type_level = p_rec.intm_type_level,
                   old_new_acct_level = p_rec.old_new_acct_level, 
                   ca_treaty_type_level = p_rec.ca_treaty_type_level, 
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE, 
                   cpi_rec_no = p_rec.cpi_rec_no,
                   cpi_branch_cd = p_rec.cpi_branch_cd, 
                   subline_level = p_rec.subline_level, 
                   neg_item_no = p_rec.neg_item_no, 
                   branch_level = p_rec.branch_level;
   END;
   
   PROCEDURE val_add_rec(
      p_module_id             giac_module_entries.module_id%TYPE,
      p_item_no               giac_module_entries.item_no%TYPE
   ) AS
      v_exists                VARCHAR2(1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM giac_module_entries
                   WHERE module_id = p_module_id
                     AND item_no = p_item_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same module_id and item_no.'
            );
      END IF;
      
      
   END;
END;
/


