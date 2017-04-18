DROP PROCEDURE CPI.UPDATE_GIAC_DV_TEXT;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIAC_DV_TEXT
(p_gacc_tran_id          GIAC_ACCTRANS.tran_id%TYPE)

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  Procedure updates the GIAC_DV_TEXT table. 
**                   
*/  

IS
  CURSOR C IS
    SELECT DISTINCT A.gacc_tran_id, A.user_id, A.last_update, A.item_no,
           DECODE(A.transaction_type,2,A.collection_amt * -1,1, A.collection_amt * -1) ITEM_AMT,
           A.gibr_gfun_fund_cd || '-' || A.gibr_branch_cd || '-' ||
           LTRIM(TO_CHAR(A.item_no,'09')) ||
           DECODE(A.gofc_item_no,NULL,NULL,' / ' ||
           LTRIM(TO_CHAR(A.gofc_gacc_tran_id,'09999999')) || '-' ||
           A.gofc_gibr_gfun_fund_cd || '-' || A.gofc_gibr_branch_cd || '-' ||
           LTRIM(TO_CHAR(A.gofc_item_no,'09')) ) ITEM_TEXT
      FROM GIAC_OTH_FUND_OFF_COLLNS A
     WHERE A.gacc_tran_id = p_gacc_tran_id
     ORDER BY A.item_no;
    
    ws_seq_no      GIAC_OP_TEXT.ITEM_SEQ_NO%TYPE := 1;
    ws_gen_type    VARCHAR2(1) := 'F';
    
BEGIN
  DELETE FROM GIAC_DV_TEXT
   WHERE gacc_tran_id  = p_gacc_tran_id
     AND item_gen_type = ws_gen_type;
     
  FOR C_REC IN C LOOP
    INSERT INTO GIAC_DV_TEXT
       (gacc_tran_id, item_seq_no, item_gen_type, item_text,
        item_amt, user_id, last_update)
       VALUES(C_REC.gacc_tran_id, ws_seq_no, ws_gen_type, C_REC.item_text,
        C_REC.item_amt, C_REC.user_id, C_REC.last_update);
    ws_seq_no := ws_seq_no + 1;
  END LOOP;
  
END;
/


