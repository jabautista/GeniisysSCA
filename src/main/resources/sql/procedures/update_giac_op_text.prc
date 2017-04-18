DROP PROCEDURE CPI.UPDATE_GIAC_OP_TEXT;

CREATE OR REPLACE PROCEDURE CPI.update_giac_op_text(
	   p_gacc_tran_id  			giac_order_of_payts.gacc_tran_id%TYPE
)
 IS
  CURSOR c IS
    SELECT DISTINCT gfpp.gacc_tran_id, 
                    (-1 * gfpp.disbursement_amt) item_amt,
                    (b.line_cd || '-' || 
                     LTRIM(TO_CHAR(b.binder_yy,'09')) || '-' ||
                     LTRIM(TO_CHAR(b.binder_seq_no,'09999')) || ' / ' ||
                     TO_CHAR(b.binder_date,'DD-MON-YYYY') ) item_text,
                    gfpp.user_id, 
                    gfpp.last_update, 
                    b.line_cd,
		    GFPP.CURRENCY_CD,
		    -1*(GFPP.FOREIGN_CURR_AMT)  "FOR_CURR_AMT"
      FROM giac_outfacul_prem_payts gfpp,
           giri_binder b
      WHERE gfpp.gacc_tran_id = p_gacc_tran_id
      AND gfpp.d010_fnl_binder_id = b.fnl_binder_id
      AND gfpp.a180_ri_cd = b.ri_cd;

    ws_seq_no      giac_op_text.item_seq_no%TYPE := 1;
    ws_gen_type    VARCHAR2(1) := 'M';
BEGIN
  DELETE FROM giac_op_text
    WHERE gacc_tran_id  = p_gacc_tran_id
    AND item_gen_type = ws_gen_type;

  FOR c_rec IN c LOOP
    INSERT INTO giac_op_text (gacc_tran_id, item_seq_no, 
                              print_seq_no, item_amt, 
                              item_gen_type, item_text,
                              user_id, last_update,
                              line,CURRENCY_CD, FOREIGN_CURR_AMT)
      VALUES(c_rec.gacc_tran_id, ws_seq_no,
             ws_seq_no, c_rec.item_amt,
             ws_gen_type, c_rec.item_text,
             c_rec.user_id, c_rec.last_update,   
             c_rec.line_cd, C_REC.CURRENCY_CD, C_REC.FOR_CURR_AMT);

    ws_seq_no := ws_seq_no + 1;
  END LOOP;
END update_giac_op_text;
/


