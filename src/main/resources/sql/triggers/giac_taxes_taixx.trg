DROP TRIGGER CPI.GIAC_TAXES_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_TAXES_TAIXX
-- by jayr 12172003
-- this will insert to giis_loss_taxes after insert
AFTER INSERT
ON CPI.GIAC_TAXES REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  v_tax_id      giis_loss_taxes.loss_tax_id%TYPE;
  v_branch      VARCHAR2(2);
  v_sl_type_cd  giis_loss_taxes.sl_type_cd%TYPE;
BEGIN
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
  FOR rec IN (SELECT a.gslt_sl_type_cd
                FROM giac_chart_of_accts a
               WHERE a.gl_acct_id = :NEW.gl_acct_id)
  LOOP
    v_sl_type_cd := rec.gslt_sl_type_cd;
  END LOOP;
  INSERT INTO giis_loss_taxes (loss_tax_id,tax_type,tax_cd, tax_name, branch_cd,tax_rate,
                               start_date,gl_acct_id,sl_type_cd,remarks,user_id,last_update)
  VALUES (v_tax_id,'O',:NEW.tax_cd, :NEW.tax_name, v_branch,0,SYSDATE,
                              :NEW.gl_acct_id,v_sl_type_cd,:NEW.remarks,NVL (giis_users_pkg.app_user, USER),SYSDATE);
END;
/


