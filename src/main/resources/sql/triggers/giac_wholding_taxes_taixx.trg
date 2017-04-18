DROP TRIGGER CPI.GIAC_WHOLDING_TAXES_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_WHOLDING_TAXES_TAIXX
-- by jayr 12172003
-- this will insert to giis_loss_taxes after insert
   AFTER INSERT
   ON CPI.GIAC_WHOLDING_TAXES    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   v_tax_id   giis_loss_taxes.loss_tax_id%TYPE;
BEGIN
   SELECT NVL (MAX (loss_tax_id), 0)
     INTO v_tax_id
     FROM giis_loss_taxes;

   v_tax_id := v_tax_id + 1;

   INSERT INTO giis_loss_taxes
               (loss_tax_id, tax_type, tax_cd, tax_name, branch_cd,
                tax_rate,
                start_date, gl_acct_id,
                sl_type_cd, remarks,
                user_id, last_update
               )
        VALUES (v_tax_id, 'W', :NEW.whtax_id, :NEW.whtax_desc, :NEW.gibr_branch_cd,
                --0, -- removed by Jayson 08.08.2011
                :NEW.percent_rate, -- added by Jayson 08.08.2011
                SYSDATE, :NEW.gl_acct_id,
                :NEW.sl_type_cd, :NEW.remarks,
                NVL (giis_users_pkg.app_user, USER), SYSDATE
               );
END;
/


