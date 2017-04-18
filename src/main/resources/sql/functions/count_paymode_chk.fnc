DROP FUNCTION CPI.COUNT_PAYMODE_CHK;

CREATE OR REPLACE FUNCTION CPI.COUNT_PAYMODE_CHK(  --Added by Alfred 03/09/2011
       p_tran_id     giac_collection_dtl.GACC_TRAN_ID%TYPE
       ) 
     RETURN CHAR IS
          v_count number(3);

    BEGIN
        BEGIN
             SELECT nvl(count(*),0)
                INTO v_count
              FROM giac_collection_dtl
            WHERE pay_mode LIKE 'CHK'
                AND gacc_tran_id = p_tran_id;
        END;
  
          IF v_count > 3 THEN
              RETURN ('Y');
          ELSE
              RETURN ('N');
          END IF;
    END;
/


