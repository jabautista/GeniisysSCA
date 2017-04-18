DROP TRIGGER CPI.FRPS_RI_DTL_TBXDX;

CREATE OR REPLACE TRIGGER CPI.FRPS_RI_DTL_TBXDX 
 BEFORE DELETE ON CPI.GIRI_FRPS_RI 
 FOR EACH ROW
DECLARE
    v_exists        VARCHAR2(1) := 'N';
BEGIN 
    /* 
    Gelo 12.18.2012. To insert the affected values to FRPS_RI_DTL. 
    */ 
    
    --marco - 05.22.2013 - added to prevent referential key exception
    FOR i IN (SELECT 1
                FROM GIRI_WFRPS_RI
                WHERE line_cd = :OLD.line_cd
                  AND frps_yy = :OLD.frps_yy
                  AND frps_seq_no = :OLD.frps_seq_no
                  AND pre_binder_id = :OLD.fnl_binder_id)
    LOOP
        v_exists := 'Y';
        EXIT;
    END LOOP;
    
    IF v_exists = 'N' THEN
        INSERT INTO GIRI_FRPS_RI_DTL 
                    (line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd, fnl_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt, reverse_sw,
                    ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt, prem_tax, other_charges, renew_sw, facoblig_sw, bndr_remarks1,
                    bndr_remarks2, bndr_remarks3, remarks, delete_sw, revrs_bndr_print_date, last_update, master_bndr_id, cpi_rec_no,
                    cpi_branch_cd, bndr_printed_cnt, revrs_bndr_printed_cnt, ri_as_no, ri_accept_by, ri_accept_date, ri_shr_pct2,
                    ri_prem_vat, ri_comm_vat, ri_wholding_vat, address1, address2, address3, prem_warr_days, prem_warr_tag, pack_binder_id,
                    arc_ext_data) 
        VALUES( 
            :OLD.line_cd, :OLD.frps_yy, :OLD.frps_seq_no, :OLD.ri_seq_no, :OLD.ri_cd, :OLD.fnl_binder_id, :OLD.ri_shr_pct, :OLD.ri_tsi_amt, 
            :OLD.ri_prem_amt, :OLD.reverse_sw, :OLD.ann_ri_s_amt, :OLD.ann_ri_pct, :OLD.ri_comm_rt, :OLD.ri_comm_amt, :OLD.prem_tax, :OLD.other_charges, 
            :OLD.renew_sw, :OLD.facoblig_sw, :OLD.bndr_remarks1, :OLD.bndr_remarks2, :OLD.bndr_remarks3, :OLD.remarks, :OLD.delete_sw, :OLD.revrs_bndr_print_date, 
            SYSDATE, :OLD.master_bndr_id, :OLD.cpi_rec_no, :OLD.cpi_branch_cd, :OLD.bndr_printed_cnt, :OLD.revrs_bndr_printed_cnt, :OLD.ri_as_no, :OLD.ri_accept_by,
            :OLD.ri_accept_date, :OLD.ri_shr_pct2, :OLD.ri_prem_vat, :OLD.ri_comm_vat, :OLD.ri_wholding_vat, :OLD.address1, :OLD.address2, :OLD.address3, 
            :OLD.prem_warr_days, :OLD.prem_warr_tag, :OLD.pack_binder_id,:OLD.arc_ext_data);
    END IF;
EXCEPTION
    WHEN OTHERS THEN   
        RAISE_APPLICATION_ERROR(-20002,'ERROR IN TRIGGER FRPS_RI_DTL_TBXDX ON GIRI_FRPS_RI');    
END;
/


