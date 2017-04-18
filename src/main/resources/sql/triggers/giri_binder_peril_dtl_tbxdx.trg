DROP TRIGGER CPI.GIRI_BINDER_PERIL_DTL_TBXDX;

CREATE OR REPLACE TRIGGER CPI.GIRI_BINDER_PERIL_DTL_TBXDX 
 BEFORE DELETE ON CPI.GIRI_BINDER_PERIL 
 FOR EACH ROW
DECLARE
    v_exists        VARCHAR2(1) := 'N';
BEGIN 
    /* 
    Gelo 12.18.2012. To insert the affected values to GIRI_BINDER_PERIL_DTL. 
    */
    
    --marco - 05.22.2013 - added to prevent referential key exception
    FOR i in(SELECT 1
               FROM GIRI_WFRPS_RI 
              WHERE pre_binder_id = :OLD.fnl_binder_id ) 
    LOOP 
        v_exists := 'Y' ; 
        EXIT;
    END LOOP;
    
    IF v_exists = 'N' THEN
        INSERT INTO GIRI_BINDER_PERIL_DTL 
                    (fnl_binder_id, peril_seq_no, ri_tsi_amt, ri_shr_pct, ri_prem_amt, ri_comm_rt, ri_comm_amt,
                     cpi_rec_no, cpi_branch_cd, ri_prem_vat, ri_comm_vat, ri_wholding_vat, prem_tax, arc_ext_data) 
        VALUES( 
            :OLD.fnl_binder_id, :OLD.peril_seq_no, :OLD.ri_tsi_amt, :OLD.ri_shr_pct, :OLD.ri_prem_amt, :OLD.ri_comm_rt, 
            :OLD.ri_comm_amt, :OLD.cpi_rec_no, :OLD.cpi_branch_cd, :OLD.ri_prem_vat, :OLD.ri_comm_vat, :OLD.ri_wholding_vat, 
            :OLD.prem_tax, :OLD.arc_ext_data);
    END IF;
EXCEPTION    
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20002,'ERROR IN TRIGGER GIRI_BINDER_PERIL_DTL_TBXDX ON GIRI_BINDER_PERIL');    
END;
/


