DROP FUNCTION CPI.CF_GIOT_FST;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_FST(  --Added by Alfred 03/09/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE,
       p_curr_cd    GIAC_OP_TEXT.CURRENCY_CD%TYPE
       )  
      RETURN Number IS
           v_fst number(16,2);
           v_ffst number(16,2);
     BEGIN
          SELECT SUM(item_amt), sum(foreign_curr_amt)
             INTO v_fst, v_ffst
            FROM giac_op_text
          WHERE gacc_tran_id = p_tran_id
              AND item_text LIKE '%FIRE SERVICE TAX%';
              
                  IF p_curr_cd = 1 THEN
         RETURN nvl(v_fst,0);
              ELSE
         RETURN nvl(v_ffst,0);
         END IF;
     END;
/


