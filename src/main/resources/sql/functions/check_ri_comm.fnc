DROP FUNCTION CPI.CHECK_RI_COMM;

CREATE OR REPLACE FUNCTION CPI.CHECK_RI_COMM(  --Added by Alfred 03/09/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE
       ) 
      RETURN CHAR IS
             v_exist     varchar2(1);
      BEGIN
           FOR A IN (SELECT '1' exist
                             FROM giac_inwfacul_prem_collns
                           WHERE gacc_tran_id = p_tran_id
                            UNION
                           SELECT '1' exist
                             FROM giac_op_text
                           WHERE gacc_tran_id = p_tran_id
                               AND item_text LIKE '%RI COMMISSION%')
          LOOP
              v_exist := A.exist;
          END LOOP;
  
                 IF v_exist IS NOT NULL THEN
        RETURN ('Y');
             ELSE             
        RETURN ('N');
        END IF;       

      END;
/


