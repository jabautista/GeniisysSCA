DROP FUNCTION CPI.CF_GIOT_VAT_COMM;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_VAT_COMM(  --Added by Alfred 03/08/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE,
       p_curr_cd    GIAC_OP_TEXT.CURRENCY_CD%TYPE
       ) 
      RETURN Number IS
           v_ri_vat_comm number(16,2);
           v_fri_vat_comm number(16,2);
     BEGIN
          SELECT SUM (ABS(item_amt)), SUM (ABS(foreign_curr_amt))
             INTO v_ri_vat_comm, v_fri_vat_comm
           FROM giac_op_text
         WHERE gacc_tran_id = p_tran_id
             AND item_text LIKE '%RI VAT ON COMMISSION%';
             
                 IF p_curr_cd = 1 THEN
        RETURN nvl(v_ri_vat_comm,0);
             ELSE
        RETURN nvl(v_fri_vat_comm,0);
        END IF;
     END;
/


