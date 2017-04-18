CREATE OR REPLACE PACKAGE BODY CPI.GIAC_DV_TEXT_PKG
AS

   /*
  **  Created by   :  Emman
  **  Date Created :  08.20.2010
  **  Reference By : (GIACS026 - Premium Deposit)
  **  Description  : Executes procedure UPDATE_GIAC_DV_TEXT on GIACS026
  */ 
   PROCEDURE update_giac_dv_text(p_gacc_tran_id		GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
  			                    p_item_gen_type		GIAC_MODULES.generation_type%TYPE)
   IS
   	 CURSOR C IS
	    SELECT DISTINCT 
	           A.gacc_tran_id
	          ,A.collection_amt ITEM_AMT
	          ,A.b140_iss_cd||'-'||LTRIM(TO_CHAR(A.b140_prem_seq_no,'09999999')) BILL_NO
	          ,A.user_id
	          ,A.last_update,
			  'Premium Deposit' ITEM_TEXT
	      FROM giac_prem_deposit A
	       where gacc_tran_id       = p_gacc_tran_id;
	
	    v_seq_no      giac_dv_text.item_seq_no%TYPE := 1;
   BEGIN
   		/* Remove first whatever records in giac_op_text. */
		  DELETE 
		    FROM giac_dv_text
		   WHERE gacc_tran_id = p_gacc_tran_id
		     AND item_gen_type = p_item_gen_type;
		
		  FOR c_rec IN C LOOP
		    INSERT 
		      INTO giac_dv_text
		       (gacc_tran_id, item_gen_type, item_seq_no, 
		        item_amt, user_id, last_update,
		        bill_no, item_text)
		       VALUES(c_rec.gacc_tran_id, p_item_gen_type, v_seq_no, 
		        (c_rec.item_amt*-1), c_rec.user_id, c_rec.last_update,
		        c_rec.bill_no, c_rec.item_text);
		    v_seq_no := v_seq_no + 1;
		
		  END LOOP;
   END update_giac_dv_text;
   
   /*
   **  Created by   :  Emman
   **  Date Created :  12.06.2010
   **  Reference By : (GIACS022 - Other Trans Withholding Tax)
   **  Description  : Executes procedure UPDATE_GIAC_DV_TEXT on GIACS022
   */ 
   PROCEDURE update_giac_dv_text_giacs022(p_gacc_tran_id		GIAC_DV_TEXT.gacc_tran_id%TYPE)
   IS
   	 CURSOR C IS
	    SELECT A.GACC_TRAN_ID, A.USER_ID, A.LAST_UPDATE, A.ITEM_NO,
	           A.WHOLDING_TAX_AMT ITEM_AMT, 
	           NVL(A.REMARKS,(LTRIM(TO_CHAR(B.WHTAX_CODE,'09')) || '-' ||
	             RTRIM(B.WHTAX_DESC) || ' / ' || LTRIM(TO_CHAR(C.PAYEE_CD,'099999'))
	             || '-' || RTRIM(C.TAXPAYER) ) ) ITEM_TEXT
	      FROM GIAC_TAXES_WHELD A, GIAC_WHOLDING_TAXES B, GIAC_PAYEES C
	     WHERE A.GWTX_WHTAX_ID = B.WHTAX_ID
	       AND A.PAYEE_CD = C.PAYEE_CD
	       AND GACC_TRAN_ID    = P_GACC_TRAN_ID
	     ORDER BY A.ITEM_NO;
	    WS_SEQ_NO      GIAC_OP_TEXT.ITEM_SEQ_NO%TYPE := 1;
	    WS_GEN_TYPE    VARCHAR2(1) := 'P';
   BEGIN
     DELETE FROM GIAC_DV_TEXT
   	 	   WHERE GACC_TRAN_ID  = P_GACC_TRAN_ID
     		 AND ITEM_GEN_TYPE = WS_GEN_TYPE;
			 
	 FOR C_REC IN C LOOP
	   INSERT INTO GIAC_DV_TEXT
	      (GACC_TRAN_ID, ITEM_SEQ_NO, ITEM_GEN_TYPE, ITEM_TEXT,
	       ITEM_AMT, USER_ID, LAST_UPDATE)
	      VALUES(C_REC.GACC_TRAN_ID, WS_SEQ_NO, WS_GEN_TYPE, C_REC.ITEM_TEXT,
	       C_REC.ITEM_AMT, C_REC.USER_ID, C_REC.LAST_UPDATE);
	   WS_SEQ_NO := WS_SEQ_NO + 1;
	 END LOOP;
   END update_giac_dv_text_giacs022;

END GIAC_DV_TEXT_PKG;
/


