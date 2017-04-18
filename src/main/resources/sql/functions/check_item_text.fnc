DROP FUNCTION CPI.CHECK_ITEM_TEXT;

CREATE OR REPLACE FUNCTION CPI.CHECK_ITEM_TEXT(  --Added by Alfred 03/09/2011
       p_tran_id     GIAC_OP_TEXT.GACC_TRAN_ID%TYPE
       ) 
      RETURN CHAR IS
            v_exist     varchar2(1);
     BEGIN
         FOR A IN (SELECT '1' exist
                           FROM giac_direct_prem_collns
                         WHERE gacc_tran_id = p_tran_id
                          UNION
                         SELECT '1' exist
                           FROM giac_op_text
                         WHERE gacc_tran_id = p_tran_id
                             AND (item_text LIKE '%FIRE SERVICE TAX%' 
                               OR item_text LIKE '%DOCUMENTARY STAMPS%'
                               OR ITEM_TEXT LIKE '%LOCAL GOVERNMENT TAX%'
                                     )
                         )
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


