DROP FUNCTION CPI.CF_GIOT_LGT;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_LGT( --Added by Alfred 03/08/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE,
       p_curr_cd    GIAC_OP_TEXT.CURRENCY_CD%TYPE
       ) 
       RETURN Number IS
           v_lgt number (16,2);
           v_flgt number (16,2);

       BEGIN
            SELECT SUM(item_amt), sum(foreign_curr_amt)
               INTO v_lgt, v_flgt
              FROM giac_op_text
            WHERE gacc_tran_id = p_tran_id
                AND item_text IN ('LOCAL GOVERNMENT TAX','LOCAL TAX','5')
                AND nvl(or_print_tag,'Y') = 'Y';
     
                    IF p_curr_cd = 1 THEN
           RETURN nvl(v_lgt,0);  
                ELSE 
           RETURN nvl( v_flgt,0);
           END IF;
         END;
/


