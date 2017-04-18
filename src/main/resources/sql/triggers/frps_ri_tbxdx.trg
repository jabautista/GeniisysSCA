DROP TRIGGER CPI.FRPS_RI_TBXDX;

CREATE OR REPLACE TRIGGER CPI.FRPS_RI_TBXDX
/*Modified by:    Jhing
**Date Modified:  05.18.2012
**Modification:   Added checking if the record exists in giri_wfrps_ri. Original trigger raises ORA-20002
                  when there is an attempt to delete record in this table (this is the only code in the original trigger) However for instances wherein
                  there are two binders or more and user reverses one or more (but not all binders), the unreversed
                  binder is stored in giri_wfrps_ri. GIRIS026 (Program unit: DELETE_MRECORDS) deletes this record before inserting
                  the records binder records. This should be an exemption in the deletion of binder-related data.
**
*/
 BEFORE DELETE ON CPI.GIRI_FRPS_RI  FOR EACH ROW
DECLARE
    v_exists varchar2(1) := 'N' ;  
BEGIN 
      
    -- RAISE_APPLICATION_ERROR(-20002,'ERROR IN TRIGGER frps_ri_TBXDX ON GIRI_frps_ri');    -- jhing 05.18.2012 the only code prior to modification 

 /* added by jhing 05.18.2012 */
   FOR cur1 IN (SELECT 1
                  FROM giri_wfrps_ri
                 WHERE line_cd = :OLD.line_cd
                   AND frps_yy = :OLD.frps_yy
                   AND frps_seq_no = :OLD.frps_seq_no
                   AND pre_binder_id = :OLD.fnl_binder_id )
   LOOP
      v_exists := 'Y';
      EXIT;
   END LOOP;

   IF v_exists = 'N' THEN 
        RAISE_APPLICATION_ERROR(-20004,'ERROR IN TRIGGER frps_ri_TBXDX ON GIRI_frps_ri');  
   END IF ; 


END;
/


