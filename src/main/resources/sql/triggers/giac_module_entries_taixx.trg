DROP TRIGGER CPI.GIAC_MODULE_ENTRIES_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_MODULE_ENTRIES_TAIXX
-- by jayr 12172003
-- this will insert to giis_loss_taxes after insert
AFTER INSERT
ON CPI.GIAC_MODULE_ENTRIES REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  v_tax_id      giis_loss_taxes.loss_tax_id%TYPE;
  v_branch      VARCHAR2(2);
  v_gl_acct_id  giac_chart_of_accts.gl_acct_id%TYPE;
  v_module      giac_module_entries.module_id%TYPE;
  v_acct_name   giac_chart_of_accts.gl_acct_name%TYPE;
BEGIN
  FOR d IN (SELECT module_id
              FROM giac_modules
             WHERE module_name = 'GIACS039')
  LOOP
    v_module := d.module_id;
  END LOOP;
  IF :NEW.module_id = v_module THEN
     SELECT NVL(MAX(loss_tax_id),0)
       INTO v_tax_id
       FROM giis_loss_taxes;
     v_tax_id := v_tax_id + 1;
     FOR b IN (SELECT param_value_v
                 FROM giac_parameters
                WHERE param_name = 'BRANCH_CD')
     LOOP
       v_branch := b.param_value_v;
     END LOOP;
     FOR c IN (SELECT a.gl_acct_id,a.gl_acct_name
                 FROM giac_chart_of_accts a
                WHERE a.gl_acct_category  = :NEW.gl_acct_category
                  AND a.gl_control_acct   = :NEW.gl_control_acct
                  AND a.gl_sub_acct_1     = :NEW.gl_sub_acct_1
                  AND a.gl_sub_acct_2     = :NEW.gl_sub_acct_2
                  AND a.gl_sub_acct_3     = :NEW.gl_sub_acct_3
                  AND a.gl_sub_acct_4     = :NEW.gl_sub_acct_4
                  AND a.gl_sub_acct_5     = :NEW.gl_sub_acct_5
                  AND a.gl_sub_acct_6     = :NEW.gl_sub_acct_6
                  AND a.gl_sub_acct_7     = :NEW.gl_sub_acct_7)
     LOOP
       v_gl_acct_id := c.gl_acct_id;
       v_acct_name  := c.gl_acct_name;
     END LOOP;
     INSERT INTO giis_loss_taxes (loss_tax_id,tax_type,tax_cd, tax_name, branch_cd,tax_rate,
                                   start_date,gl_acct_id,sl_type_cd,remarks,user_id,last_update)
     VALUES (v_tax_id,'I',:NEW.item_no,v_acct_name, v_branch,0,SYSDATE,
                                   v_gl_acct_id,:NEW.sl_type_cd,:NEW.description,NVL (giis_users_pkg.app_user, USER),SYSDATE);
  END IF;
END;
/


