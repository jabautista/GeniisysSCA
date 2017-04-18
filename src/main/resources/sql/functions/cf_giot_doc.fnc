DROP FUNCTION CPI.CF_GIOT_DOC;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_DOC(  --Added by Alfred 03/08/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE,
       p_curr_cd    GIAC_OP_TEXT.CURRENCY_CD%TYPE
       ) 
      RETURN Number IS
           v_doc_stamp number (16,2);
           v_fdoc_stamp number (16,2);
      BEGIN
          SELECT SUM(item_amt), sum(foreign_curr_amt)
              INTO v_doc_stamp, v_fdoc_stamp
            FROM giac_op_text
          WHERE gacc_tran_id = p_tran_id
              AND (item_text IN ('DOCUMENTARY STAMPS','4')
                OR item_text LIKE '%DOCUMENTARY STAMPS%')
              AND nvl(or_print_tag,'Y') = 'Y';
                 IF p_curr_cd = 1 THEN    
         RETURN nvl(v_doc_stamp,0);
             ELSE 
         RETURN nvl(v_fdoc_stamp,0);
           END IF;
   END;
/


