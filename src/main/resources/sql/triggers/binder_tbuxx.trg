DROP TRIGGER CPI.BINDER_TBUXX;

CREATE OR REPLACE TRIGGER CPI.BINDER_TBUXX
BEFORE UPDATE OF acc_ent_date, acc_rev_date ON CPI.GIRI_BINDER FOR EACH ROW
BEGIN
/*
MODIFIED BY  : Michaell
DATE MODIFIED: Oct. 21, 2002
REMARKS      : To make a history of the changes that takes place in the table
              GIRI_BINDER. Created for Lepanto.
*/
INSERT INTO binder_history(
   fnl_binder_id,old_acc_ent,old_acc_rev, new_acc_ent,new_acc_rev,
   upd_user,upd_date)
VALUES(
   :NEW.fnl_binder_id,:OLD.acc_ent_date, :OLD.acc_rev_date,
   :NEW.acc_ent_date, :NEW.acc_rev_date,
   NVL (giis_users_pkg.app_user, USER), SYSDATE);
 /* purpose is to prevent updating of the acc_ent_date or acc_rev_date
    of binders that were previously taken up */

 /* modified by judyann 02242005
    added checking of reverse_date and of OLD and NEW acc_ent_date
    to handle the case of re-run of Batch Outward Facultative
    when a new binder is issued) */

     /*
     IF (:OLD.acc_ent_date IS NOT NULL
         AND :NEW.reverse_date IS NOT NULL
         AND :OLD.acc_ent_date = :NEW.acc_ent_date) THEN
        :NEW.acc_ent_date := NULL;
     ELSIF (:OLD.acc_ent_date IS NOT NULL
         AND :NEW.reverse_date IS NOT NULL
         AND :OLD.acc_ent_date <> :NEW.acc_ent_date) THEN
        :NEW.acc_ent_date := :OLD.acc_ent_date;
     END IF;
     */
     IF :OLD.acc_ent_date IS NOT NULL THEN
        :NEW.acc_ent_date := :OLD.acc_ent_date;
     END IF;
     IF :OLD.acc_rev_date IS NOT NULL THEN
        :NEW.acc_rev_date := :OLD.acc_rev_date;
     END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001,'ERROR IN TRIGGER BINDER_TBUXX ON GIRI_BINDER');
END;
/


