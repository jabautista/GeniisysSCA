CREATE OR REPLACE PACKAGE BODY CPI.giiss216_pkg
AS
   FUNCTION get_branch
      RETURN branch_tab PIPELINED
   IS
      v_list branch_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_banc_branch
              ORDER BY branch_cd)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_desc := i.branch_desc;
         v_list.area_cd := i.area_cd;
--         v_list.area_desc := i.area_desc;
         v_list.eff_date := i.eff_date;
         v_list.manager_cd := i.manager_cd;
         v_list.bank_acct_cd := i.bank_acct_cd;
         v_list.mgr_eff_date := i.mgr_eff_date;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         BEGIN
            SELECT area_desc
              INTO v_list.area_desc
              FROM giis_banc_area
             WHERE area_cd = i.area_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.area_desc := NULL;      
         END;
         
         BEGIN
            SELECT payee_last_name || ', ' || payee_first_name || ', ' || payee_middle_name
              INTO v_list.manager_name
              FROM giis_payees
             WHERE  payee_no = i.manager_cd
               AND payee_class_cd = giisp.v('BANK_MANAGER_PAYEE_CLASS');
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.manager_name := NULL;                    
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_branch;
   
   FUNCTION get_manager_lov
      RETURN manager_tab PIPELINED
   IS
      v_list manager_type;
   BEGIN
      FOR i IN (SELECT   payee_no,
                         payee_last_name
                      || ','
                      || payee_first_name
                      || ','
                      || ' '
                      || payee_middle_name payee
                 FROM giis_payees
                WHERE payee_class_cd = giisp.v ('BANK_MANAGER_PAYEE_CLASS')
             ORDER BY payee_no)
      LOOP
         v_list.manager_cd := i.payee_no;
         v_list.manager_name := i.payee;
         PIPE ROW(v_list);
      END LOOP;
   END get_manager_lov;
   
   PROCEDURE save_record (p_rec giis_banc_branch%ROWTYPE)
   IS
   BEGIN
   
      MERGE INTO giis_banc_branch
         USING DUAL
         ON (branch_cd = p_rec.branch_cd)
         WHEN NOT MATCHED THEN
            INSERT (branch_cd, branch_desc, area_cd, 
                    eff_date, remarks, user_id, last_update,
                    manager_cd, bank_acct_cd, mgr_eff_date)
            VALUES (p_rec.branch_cd, p_rec.branch_desc, p_rec.area_cd, 
                    p_rec.eff_date, p_rec.remarks, p_rec.user_id, SYSDATE,
                    p_rec.manager_cd, p_rec.bank_acct_cd, p_rec.mgr_eff_date)
         WHEN MATCHED THEN
            UPDATE
               SET branch_desc = p_rec.branch_desc,
                   area_cd = p_rec.area_cd,
                   eff_date = p_rec.eff_date,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE,
                   manager_cd = p_rec.manager_cd,
                   bank_acct_cd = p_rec.bank_acct_cd,
                   mgr_eff_date = p_rec.mgr_eff_date;                   
   
   END save_record;
   
   FUNCTION get_history (p_branch_cd VARCHAR2)
      RETURN hist_tab PIPELINED
   IS
      v_list hist_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_banc_branch_hist
                 WHERE branch_cd = p_branch_cd
              ORDER BY last_update DESC)
      LOOP
         v_list.old_area_cd := i.old_area_cd;
         v_list.new_area_cd := i.new_area_cd;
         v_list.old_eff_date := i.old_eff_date;
         v_list.new_eff_date := i.new_eff_date;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.old_manager_cd := i.old_manager_cd;
         v_list.new_manager_cd := i.new_manager_cd;
         v_list.old_bank_acct_cd := i.old_bank_acct_cd;
         v_list.new_bank_acct_cd := i.new_bank_acct_cd;
         v_list.old_mgr_eff_date := i.old_mgr_eff_date;
         v_list.new_mgr_eff_date := i.new_mgr_eff_date;
         v_list.branch_cd := i.branch_cd;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_history;
   
   PROCEDURE val_add_rec (
      p_branch_cd     VARCHAR2,
      p_branch_desc   VARCHAR2,
      p_area_cd       VARCHAR2,
      p_stat          VARCHAR2
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
      v_exists2   VARCHAR2 (1) := 'N';
   BEGIN
   
      IF UPPER(p_stat) = 'ADD' THEN
         FOR i IN (SELECT '1'
                  FROM giis_banc_branch a
                 WHERE a.branch_cd = p_branch_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
         
         
         FOR i IN (SELECT '1'
                     FROM giis_banc_branch a
                    WHERE a.branch_desc = p_branch_desc
                      AND a.area_cd = p_area_cd)
         LOOP
            v_exists2 := 'Y';
            EXIT;
         END LOOP;
      ELSE
         FOR i IN (SELECT '1'
                     FROM giis_banc_branch a
                    WHERE a.branch_desc = p_branch_desc
                      AND a.area_cd = p_area_cd
                      AND a.branch_cd != p_branch_cd)
         LOOP
            v_exists2 := 'Y';
            EXIT;
         END LOOP;         
      END IF;
      

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same branch_cd.');
      END IF;
      
      IF v_exists2 = 'Y'
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same branch_desc and area_cd.');
      END IF;
      
   END;   
         
END;
/


