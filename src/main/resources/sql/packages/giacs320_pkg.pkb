CREATE OR REPLACE PACKAGE BODY CPI.GIACS320_PKG
AS

   FUNCTION get_tax_list(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE,
      p_tax_name              giac_taxes.tax_name%TYPE,
      p_tax_type              giac_taxes.tax_type%TYPE,
      p_priority_cd           giac_taxes.priority_cd%TYPE,
      p_gl_acct_category      giac_taxes.gl_acct_category%TYPE,
      p_gl_control_acct       giac_taxes.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_taxes.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_taxes.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_taxes.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_taxes.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_taxes.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_taxes.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_taxes.gl_sub_acct_7%TYPE
   )
     RETURN tax_tab PIPELINED
   IS
      v_row                   tax_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giac_taxes
                WHERE UPPER(fund_cd) LIKE UPPER(NVL(p_fund_cd, fund_cd))
                  AND tax_cd = NVL(p_tax_cd, tax_cd)
                  AND UPPER(tax_name) LIKE UPPER(NVL(p_tax_name, tax_name))
                  AND UPPER(tax_type) LIKE UPPER(NVL(p_tax_type, tax_type))
                  AND priority_cd = NVL(p_priority_cd, priority_cd)
                  AND gl_acct_category = NVL(p_gl_acct_category, gl_acct_category)
                  AND gl_control_acct = NVL(p_gl_control_acct, gl_control_acct)
                  AND gl_sub_acct_1 = NVL(p_gl_sub_acct_1, gl_sub_acct_1)
                  AND gl_sub_acct_2 = NVL(p_gl_sub_acct_2, gl_sub_acct_2)
                  AND gl_sub_acct_3 = NVL(p_gl_sub_acct_3, gl_sub_acct_3)
                  AND gl_sub_acct_4 = NVL(p_gl_sub_acct_4, gl_sub_acct_4)
                  AND gl_sub_acct_5 = NVL(p_gl_sub_acct_5, gl_sub_acct_5)
                  AND gl_sub_acct_6 = NVL(p_gl_sub_acct_6, gl_sub_acct_6)
                  AND gl_sub_acct_7 = NVL(p_gl_sub_acct_7, gl_sub_acct_7)
                ORDER BY fund_cd, tax_cd)
      LOOP
         v_row.fund_cd := i.fund_cd;
         v_row.tax_cd := i.tax_cd;
         v_row.tax_name := i.tax_name;
         v_row.tax_type := i.tax_type;
         v_row.priority_cd := i.priority_cd;
         v_row.gl_acct_id := i.gl_acct_id;
         v_row.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_row.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_row.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_row.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_row.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_row.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_row.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_row.gl_acct_category := i.gl_acct_category;
         v_row.gl_control_acct := i.gl_control_acct;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         v_row.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_tax_type_lov(
      p_find_text             VARCHAR2
   )
     RETURN tax_type_lov_tab PIPELINED
   IS
      v_row                   tax_type_lov_type;
   BEGIN
      FOR i IN(SELECT SUBSTR(rv_low_value,1,1) rv_low_value,
                      SUBSTR(rv_meaning,1,8) rv_meaning
                 FROM cg_ref_codes
                WHERE rv_domain = 'GIAC_TAXES.TAX_TYPE'
                  AND (UPPER(rv_low_value) LIKE NVL(UPPER(p_find_text), '%') OR UPPER(rv_meaning) LIKE NVL(UPPER(p_find_text), '%'))
                ORDER BY rv_low_value)
      LOOP
         v_row.rv_low_value := i.rv_low_value;
         v_row.rv_meaning := i.rv_meaning;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_gl_lov(
      p_find_text             VARCHAR2
   )
     RETURN gl_tab PIPELINED
   IS
      v_row                   gl_type;
   BEGIN
      FOR i IN(SELECT gl_acct_name, gl_acct_id, gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7
                  FROM giac_chart_of_accts a
                 WHERE leaf_tag = 'Y'
                   AND UPPER(gl_acct_name) LIKE UPPER(NVL(p_find_text, '%'))
                 ORDER BY a.gl_acct_category, a.gl_control_acct, a.gl_sub_acct_1,
                       a.gl_sub_acct_2, a.gl_sub_acct_3, a.gl_sub_acct_4,
                       a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7)
      LOOP
         v_row.gl_acct_name := i.gl_acct_name;
         v_row.gl_acct_id := i.gl_acct_id;
         v_row.gl_acct_category := i.gl_acct_category;
         v_row.gl_control_acct := i.gl_control_acct;
         v_row.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_row.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_row.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_row.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_row.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_row.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_row.gl_sub_acct_7 := i.gl_sub_acct_7;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_add_rec(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT 1
                 FROM giac_taxes a
                WHERE a.fund_cd = p_fund_cd
                  AND a.tax_cd = p_tax_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same fund_cd and tax_cd.');
      END IF;
      
      FOR i IN(SELECT 1
                 FROM giis_loss_taxes b
                WHERE b.tax_cd = p_tax_cd
                  AND b.tax_type = 'O')
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with same tax_type, tax_cd and branch_cd in table GIIS_LOSS_TAXES.');
      END IF;
   END;
   
   PROCEDURE set_tax(
      p_rec                   giac_taxes%ROWTYPE
   )
   IS
      v_branch                giac_parameters.param_value_v%TYPE;
      v_loss_tax_id           giis_loss_taxes.loss_tax_id%TYPE;
      v_tax_name              giis_loss_taxes.tax_name%TYPE;
   BEGIN
      FOR b IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'BRANCH_CD')
      LOOP
         v_branch := b.param_value_v;
         EXIT;
      END LOOP;
      
      FOR b IN (SELECT loss_tax_id, tax_name
                  FROM giis_loss_taxes
                 WHERE tax_type = 'O'
                   AND tax_cd = p_rec.tax_cd
                   AND branch_cd = v_branch)
      LOOP
         v_loss_tax_id := b.loss_tax_id;
         v_tax_name := b.tax_name;
         EXIT;
      END LOOP;
      
      IF v_tax_name <> p_rec.tax_name THEN
         UPDATE giis_loss_taxes
            SET tax_name = p_rec.tax_name
          WHERE loss_tax_id = v_loss_tax_id;
      END IF;
      
      MERGE INTO giac_taxes
      USING DUAL
         ON (fund_cd = p_rec.fund_cd
        AND tax_cd = p_rec.tax_cd)
       WHEN NOT MATCHED THEN
            INSERT (fund_cd, tax_cd, tax_name, tax_type, priority_cd,
                    gl_acct_id, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                    gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                    gl_acct_category, gl_control_acct, remarks, user_id, last_update)
            VALUES (p_rec.fund_cd, p_rec.tax_cd, p_rec.tax_name, p_rec.tax_type, p_rec.priority_cd,
                    p_rec.gl_acct_id, p_rec.gl_sub_acct_1, p_rec.gl_sub_acct_2, p_rec.gl_sub_acct_3,
                    p_rec.gl_sub_acct_4, p_rec.gl_sub_acct_5, p_rec.gl_sub_acct_6, p_rec.gl_sub_acct_7,
                    p_rec.gl_acct_category, p_rec.gl_control_acct, p_rec.remarks, p_rec.user_id, SYSDATE)
       WHEN MATCHED THEN
            UPDATE SET tax_name = p_rec.tax_name,
                       tax_type = p_rec.tax_type,
                       priority_cd = p_rec.priority_cd,
                       gl_acct_id = p_rec.gl_acct_id,
                       gl_sub_acct_1 = p_rec.gl_sub_acct_1,
                       gl_sub_acct_2 = p_rec.gl_sub_acct_2,
                       gl_sub_acct_3 = p_rec.gl_sub_acct_3,
                       gl_sub_acct_4 = p_rec.gl_sub_acct_4,
                       gl_sub_acct_5 = p_rec.gl_sub_acct_5,
                       gl_sub_acct_6 = p_rec.gl_sub_acct_6,
                       gl_sub_acct_7 = p_rec.gl_sub_acct_7,
                       gl_acct_category = p_rec.gl_acct_category,
                       gl_control_acct = p_rec.gl_control_acct,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;
   
   PROCEDURE val_del_rec(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE
   )
   AS
      v_exists             VARCHAR2(1);
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_tax_charges a
                WHERE a.tax_cd = p_tax_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIAC_TAXES while dependent record(s) in GIIS_TAX_CHARGES exists.');
      END IF;
      
      FOR i IN(SELECT 1
                 FROM giac_tax_collns a
                WHERE a.fund_cd = p_fund_cd
                  AND a.b160_tax_cd = p_tax_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIAC_TAXES while dependent record(s) in GIAC_TAX_COLLNS exists.');
      END IF;
      
      FOR i IN(SELECT 1
                 FROM giac_tax_payments a
                WHERE a.fund_cd = p_fund_cd
                  AND a.tax_cd = p_tax_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIAC_TAXES while dependent record(s) in GIAC_TAX_PAYMENTS exists.');
      END LOOP;
   END;
   
   PROCEDURE del_tax(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE
   )
   IS
      v_branch                giac_parameters.param_value_v%TYPE;
      v_loss_tax_id           giis_loss_taxes.loss_tax_id%TYPE;
   BEGIN
      FOR b IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'BRANCH_CD')
      LOOP
         v_branch := b.param_value_v;
         EXIT;
      END LOOP;
      
      FOR b IN (SELECT loss_tax_id
                  FROM giis_loss_taxes
                 WHERE tax_type = 'O'
                   AND tax_cd = p_tax_cd
                   AND branch_cd = v_branch)
      LOOP
         v_loss_tax_id := b.loss_tax_id;
         EXIT;
      END LOOP;
   
      DELETE
        FROM giis_loss_tax_hist
       WHERE loss_tax_id = v_loss_tax_id;
   
      DELETE
        FROM giis_loss_taxes
       WHERE loss_tax_id = v_loss_tax_id;
   
      DELETE
        FROM giac_taxes
       WHERE fund_cd = p_fund_cd
         AND tax_cd = p_tax_cd;
   END;
   
   FUNCTION check_account_code(
      p_gl_acct_category      giac_taxes.gl_acct_category%TYPE,
      p_gl_control_acct       giac_taxes.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_taxes.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_taxes.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_taxes.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_taxes.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_taxes.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_taxes.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_taxes.gl_sub_acct_7%TYPE
   )
     RETURN NUMBER
   IS
   BEGIN
      FOR i IN(SELECT gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = p_gl_acct_category
	               AND gl_control_acct = p_gl_control_acct
	               AND gl_sub_acct_1 = p_gl_sub_acct_1
                  AND gl_sub_acct_2 = p_gl_sub_acct_2
                  AND gl_sub_acct_3 = p_gl_sub_acct_3
                  AND gl_sub_acct_4 = p_gl_sub_acct_4
                  AND gl_sub_acct_5 = p_gl_sub_acct_5
                  AND gl_sub_acct_6 = p_gl_sub_acct_6
                  AND gl_sub_acct_7 = p_gl_sub_acct_7
	               AND leaf_tag = 'Y')
      LOOP
         RETURN i.gl_acct_id;
      END LOOP;
      
      raise_application_error (-20001, 'Geniisys Exception#E#The Account Code you have entered is not valid.');
   END;
   
   FUNCTION get_fund_lov(
      p_find_text             VARCHAR2
   )
     RETURN fund_tab PIPELINED
   IS
      v_row                   fund_type;
   BEGIN
      FOR i IN(SELECT fund_cd, fund_desc
                 FROM giis_funds
                WHERE UPPER(fund_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(fund_desc) LIKE UPPER(NVL(p_find_text, '%')))
      LOOP
         v_row.fund_cd := i.fund_cd;
         v_row.fund_desc := i.fund_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;

END GIACS320_PKG;
/


