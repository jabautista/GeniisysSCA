DROP TRIGGER CPI.BINDER_TBXDX;

CREATE OR REPLACE TRIGGER CPI.BINDER_TBXDX 
/*Modified by: Gelo
 **Date: 12/20/2012
 **Description: Modified trigger to include the insertion of affected values to GIRI_BINDER_DTL
                and created an AUTONOMOUS_TRANSACTION procedure inside the DECLARE block to prevent 
                the rollback being done when raising application error.*/
 BEFORE DELETE ON CPI.GIRI_BINDER 
 FOR EACH ROW
DECLARE
 PROCEDURE BINDER_DTL_TBXDX (P_FNL_BINDER_ID NUMBER,P_LINE_CD VARCHAR2,P_BINDER_YY NUMBER,P_BINDER_SEQ_NO NUMBER,P_RI_CD NUMBER, P_RI_TSI_AMT NUMBER, P_RI_SHR_PCT NUMBER,
    P_RI_PREM_AMT NUMBER,P_RI_COMM_RT NUMBER,P_RI_COMM_AMT NUMBER,P_PREM_TAX NUMBER,P_EFF_DATE DATE,P_EXPIRY_DATE DATE,P_BINDER_DATE DATE,P_ATTENTION VARCHAR2,
    P_CONFIRM_NO VARCHAR2,P_CONFIRM_DATE DATE,P_REVERSE_DATE DATE,P_ACC_ENT_DATE DATE,P_ACC_REV_DATE DATE,P_USER_ID VARCHAR2,P_LAST_UPDATE DATE,
    P_CPI_REC_NO NUMBER,P_CPI_BRANCH_CD VARCHAR2,P_REPLACED_FLAG VARCHAR2,P_BNDR_PRINT_DATE DATE,P_BNDR_PRINTED_CNT NUMBER,P_CREATE_BINDER_DATE DATE,
    P_ENDT_TEXT VARCHAR2,P_REF_BINDER_NO VARCHAR2,P_POLICY_ID NUMBER,P_ISS_CD VARCHAR2,P_RI_PREM_VAT NUMBER,P_RI_COMM_VAT NUMBER,P_RI_WHOLDING_VAT NUMBER,
    P_BNDR_STAT_CD VARCHAR2,P_RELEASE_DATE DATE,P_RELEASED_BY VARCHAR2,P_ARC_EXT_DATA VARCHAR2)
 IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
    INSERT INTO GIRI_BINDER_DTL
            (fnl_binder_id, line_cd, binder_yy, binder_seq_no, ri_cd, ri_tsi_amt, ri_shr_pct,
                 ri_prem_amt, ri_comm_rt, ri_comm_amt, prem_tax, eff_date, expiry_date, binder_date,
                 attention, confirm_no, confirm_date, reverse_date, acc_ent_date, acc_rev_date, 
                 user_id, last_update, cpi_rec_no, cpi_branch_cd, replaced_flag, bndr_print_date,
                 bndr_printed_cnt, create_binder_date, endt_text, ref_binder_no, policy_id, iss_cd,
                 ri_prem_vat, ri_comm_vat, ri_wholding_vat, bndr_stat_cd, release_date, released_by,
                 arc_ext_data)
    VALUES (P_FNL_BINDER_ID,P_LINE_CD,P_BINDER_YY,P_BINDER_SEQ_NO,P_RI_CD,P_RI_TSI_AMT,P_RI_SHR_PCT,P_RI_PREM_AMT,P_RI_COMM_RT,
            P_RI_COMM_AMT,P_PREM_TAX,P_EFF_DATE,P_EXPIRY_DATE,P_BINDER_DATE,P_ATTENTION,P_CONFIRM_NO,P_CONFIRM_DATE,P_REVERSE_DATE,
            P_ACC_ENT_DATE,P_ACC_REV_DATE,P_USER_ID,P_LAST_UPDATE,P_CPI_REC_NO,P_CPI_BRANCH_CD,P_REPLACED_FLAG,P_BNDR_PRINT_DATE,
            P_BNDR_PRINTED_CNT,P_CREATE_BINDER_DATE,P_ENDT_TEXT,P_REF_BINDER_NO,P_POLICY_ID,P_ISS_CD,P_RI_PREM_VAT,P_RI_COMM_VAT,
            P_RI_WHOLDING_VAT,P_BNDR_STAT_CD,P_RELEASE_DATE,P_RELEASED_BY,P_ARC_EXT_DATA);
    COMMIT;
 END BINDER_DTL_TBXDX;

 PROCEDURE BINDER_HIST_TBXDX (P_FNL_BINDER_ID NUMBER,P_LINE_CD VARCHAR2,P_BINDER_YY NUMBER,
    P_BINDER_SEQ_NO NUMBER,P_USER_ID VARCHAR2,P_LAST_UPDATE DATE)
 IS
    PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    INSERT INTO GIRI_BINDER_HIST
            (fnl_binder_id, line_cd, binder_yy, binder_seq_no, user_id, last_update)
    VALUES (P_FNL_BINDER_ID,P_LINE_CD,P_BINDER_YY,
            P_BINDER_SEQ_NO,P_USER_ID,P_LAST_UPDATE);
    COMMIT;
 END BINDER_HIST_TBXDX;

BEGIN
    /*Commented by Gelo 12/20/2012
issa 06.25.2007 to monitor if a module deletes on giri_binder 
    
INSERT INTO GIRI_BINDER_HIST 
            (fnl_binder_id, line_cd, binder_yy, binder_seq_no, user_id, last_update) 
VALUES( 
   :OLD.fnl_binder_id,:OLD.line_cd, :OLD.binder_yy, :OLD.binder_seq_no, 
   NVL (giis_users_pkg.app_user, USER), SYSDATE); 
    */   
    /* 
    Gelo 12.20.2012. To insert the affected values to giri_binder_hist. 
    */ 
    BINDER_HIST_TBXDX(:OLD.fnl_binder_id,:OLD.line_cd, :OLD.binder_yy, :OLD.binder_seq_no,
       NVL (giis_users_pkg.app_user, USER), SYSDATE);
    /* 
    Gelo 12.20.2012. To insert the affected values to giri_binder_dtl. 
    */  
    BINDER_DTL_TBXDX(:OLD.fnl_binder_id,:OLD.line_cd, :OLD.binder_yy, :OLD.binder_seq_no, :OLD.ri_cd, :OLD.ri_tsi_amt, :OLD.ri_shr_pct,
       :OLD.ri_prem_amt, :OLD.ri_comm_rt, :OLD.ri_comm_amt, :OLD.prem_tax, :OLD.eff_date, :OLD.expiry_date, :OLD.binder_date,
       :OLD.attention, :OLD.confirm_no, :OLD.confirm_date, :OLD.reverse_date, :OLD.acc_ent_date, :OLD.acc_rev_date, 
        NVL (giis_users_pkg.app_user, USER), SYSDATE, :OLD.cpi_rec_no, :OLD.cpi_branch_cd, :OLD.replaced_flag, :OLD.bndr_print_date,
       :OLD.bndr_printed_cnt, :OLD.create_binder_date, :OLD.endt_text, :OLD.ref_binder_no, :OLD.policy_id, :OLD.iss_cd,
       :OLD.ri_prem_vat, :OLD.ri_comm_vat, :OLD.ri_wholding_vat, :OLD.bndr_stat_cd, :OLD.release_date, :OLD.released_by,
       :OLD.arc_ext_data); 
	
	RAISE_APPLICATION_ERROR(-20002,'ERROR IN TRIGGER BINDER_TBXDX ON GIRI_BINDER');    
END;
/


