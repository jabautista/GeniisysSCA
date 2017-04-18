DROP TRIGGER CPI.GIRI_FRPERIL_DTL_TBXDX;

CREATE OR REPLACE TRIGGER CPI.GIRI_FRPERIL_DTL_TBXDX 
 BEFORE DELETE ON CPI.GIRI_FRPERIL 
 FOR EACH ROW
DECLARE
    v_exists        VARCHAR2(1) := 'N';
BEGIN 
    /* 
    Gelo 12.18.2012. To insert the affected values to GIRI_FRPERIL_DTL. 
    */ 
    
    --marco - 05.22.2013 - added to prevent referential key exception
    FOR i IN (SELECT 1
                FROM GIRI_WFRPS_RI
               WHERE line_cd = :OLD.line_cd
                 AND frps_yy = :OLD.frps_yy
                 AND frps_seq_no = :OLD.frps_seq_no
                 AND ri_seq_no = :OLD.ri_seq_no)
    LOOP
        v_exists := 'Y';
        EXIT;
    END LOOP;
    
    IF v_exists = 'N' THEN
        INSERT INTO GIRI_FRPERIL_DTL 
                    (line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd, peril_cd, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                     ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt, cpi_rec_no, cpi_branch_cd, ri_prem_vat,
                     ri_comm_vat, ri_wholding_vat, prem_tax, ri_comm_amt2, arc_ext_data) 
        VALUES( 
            :OLD.line_cd, :OLD.frps_yy, :OLD.frps_seq_no, :OLD.ri_seq_no, :OLD.ri_cd, :OLD.peril_cd, :OLD.ri_shr_pct, 
            :OLD.ri_tsi_amt, :OLD.ri_prem_amt, :OLD.ann_ri_s_amt, :OLD.ann_ri_pct, :OLD.ri_comm_rt, :OLD.ri_comm_amt, 
            :OLD.cpi_rec_no, :OLD.cpi_branch_cd, :OLD.ri_prem_vat, :OLD.ri_comm_vat, :OLD.ri_wholding_vat, :OLD.prem_tax, 
            :OLD.ri_comm_amt2, :OLD.arc_ext_data);
    END IF;
EXCEPTION
    WHEN OTHERS THEN  
        RAISE_APPLICATION_ERROR(-20002,'ERROR IN TRIGGER GIRI_FRPERIL_DTL_TBXDX ON GIRI_FRPERIL');    
END;
/


