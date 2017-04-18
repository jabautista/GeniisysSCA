DROP FUNCTION CPI.CF_GIOT_PREM_TAX;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_PREM_TAX(  --Added by Alfred 03/08/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE,
       p_curr_cd    GIAC_OP_TEXT.CURRENCY_CD%TYPE
       ) 
      RETURN Number IS
            v_prem_tax number (16,2);
            v_fprem_tax number (16,2);
     BEGIN
          SELECT SUM(item_amt), sum (foreign_curr_amt)
             INTO v_prem_tax, v_fprem_tax
            FROM giac_op_text
          WHERE gacc_tran_id = p_tran_id
              AND (item_text LIKE 'PREMIUM TAX%'
                OR item_text IN ('7','PREMIUM TAX'))
              AND nvl(or_print_tag,'Y') = 'Y'; 

            v_prem_tax := nvl(v_prem_tax,0);
            
                  IF p_curr_cd = 1 THEN
         RETURN nvl(v_prem_tax,0); 
              ELSE 
         RETURN nvl(v_fprem_tax,0); 
         END IF;
     END;
/


