DROP FUNCTION CPI.CF_GIOT_EVAT;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_EVAT(  --Added by Alfred 03/08/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE,
       p_curr_cd    GIAC_OP_TEXT.CURRENCY_CD%TYPE
       ) 
      RETURN Number IS
           v_evat number(16,2);
           v_fevat number(16,2);
      BEGIN
           SELECT SUM(item_amt), sum(foreign_curr_amt)
              INTO v_evat, v_fevat
             FROM giac_op_text
           WHERE gacc_tran_id = p_tran_id
               AND item_text IN ('VALUE ADDED TAX', 'EXPANDED VAT','3', 'VALUE-ADDED TAX')
               AND nvl(or_print_tag,'Y') = 'Y';
               
                   IF p_curr_cd = 1 THEN   
          RETURN (v_evat);
               ELSE
          RETURN (v_fevat);
          END IF;
      END;
/


