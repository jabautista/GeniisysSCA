DROP TRIGGER CPI.GIRI_BINDER_PERIL_TBXDX;

CREATE OR REPLACE TRIGGER CPI.GIRI_BINDER_PERIL_TBXDX 
/*Modified by:    Jhing 
**Date Modified:  05.18.2012
**Modification:   Added checking if the record exists in giri_wfrps_ri. Original trigger raises ORA-20002 
                  when there is an attempt to delete record in this table. However for instances wherein 
                  there are two binders or more and user reverses one or more (but not all binders), the unreversed
                  binder is stored in giri_wfrps_ri. GIRIS026 (Program unit: DELETE_MRECORDS) deletes this record before inserting 
                  the records binder records. This should be an exemption in the deletion of binder-related data.
**              
*/
 BEFORE DELETE ON CPI.GIRI_BINDER_PERIL  FOR EACH ROW
DECLARE
    v_exists varchar(1) := 'N' ;  -- jhing 05.18.2012
BEGIN 
    
    /* added by jhing 05.18.2012 */ 
    FOR cur1 in ( 
        SELECT 1 FROM giri_wfrps_ri 
            WHERE pre_binder_id = :OLD.fnl_binder_id ) 
    LOOP 
        v_exists := 'Y' ; 
        EXIT;    
    END LOOP; 
    
       -- RAISE_APPLICATION_ERROR(-20002,''ERROR IN TRIGGER GIRI_BINDER_PERIL_TBXDX ON GIRI_BINDER_PERIL'); -- jhing 05.18.2012 original code (the only code in the trigger)
    /* jhing 05.18.2012 */ 
    IF v_exists = 'N' THEN 
        RAISE_APPLICATION_ERROR(-20002,'ERROR IN TRIGGER GIRI_BINDER_PERIL_TBXDX ON GIRI_BINDER_PERIL');     
    END IF; 
END;
/


