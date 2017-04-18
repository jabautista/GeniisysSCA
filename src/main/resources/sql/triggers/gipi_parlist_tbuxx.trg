DROP TRIGGER CPI.GIPI_PARLIST_TBUXX;

CREATE OR REPLACE TRIGGER CPI.GIPI_PARLIST_TBUXX
BEFORE UPDATE OF par_status ON CPI.GIPI_PARLIST FOR EACH ROW
BEGIN

IF :old.par_status='10' and :new.par_status<>'10' then
RAISE_APPLICATION_ERROR(-20018, 'This PAR was already used. Please contact CPI');
end if;

/*INSERT INTO GIPI_PARLIST_DEL_REC
( par_id, line_cd,  iss_cd,
 par_yy, par_seq_no,  quote_seq_no,
 par_type,  par_status,  assd_no,
 underwriter,  old_par_status,  pack_par_id)
VALUES(
 :OLD.par_id, :OLD.line_cd,  :OLD.iss_cd,
 :OLD.par_yy, :OLD.par_seq_no,  :OLD.quote_seq_no,
 :OLD.par_type,  :NEW.par_status,  :OLD.assd_no,
 :OLD.underwriter,  :OLD.old_par_status,  :OLD.pack_par_id);
*/
/*EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001,'ERROR IN TRIGGER BINDER_TBUXX ON GIRI_BINDER');*/
END;
/


