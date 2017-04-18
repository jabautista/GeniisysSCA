DROP PROCEDURE CPI.UPDATE_GIOP_GIACS050;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIOP_GIACS050 (
	p_or_no				 IN OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
	p_or_pref            IN     GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
    p_edit_or_no         IN     VARCHAR2,
    p_gacc_tran_id       IN     GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
    p_fund_cd            IN     GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
    p_branch_cd          IN     GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE
) IS
  v_or_pref GIAC_ORDER_OF_PAYTS.OR_PREF_SUF%TYPE;
  v_or_no   GIAC_ORDER_OF_PAYTS.OR_NO%TYPE;
  no_of_rec NUMBER; --added by Jayson 12.23.2011
  rand      NUMBER; --added by Jayson 12.23.2011
  
  v_or_flag_sw  NUMBER(1) := 0;
BEGIN                                                 
    /*rand := ROUND(dbms_random.value(3000000,10000000),0); --random delay aprox 1~3 secs
    FOR a IN 1..rand LOOP
        NULL;
    END LOOP;*/
   rand := ROUND(dbms_random.value(3000000,10000000),0); 
   FOR a IN 1..rand LOOP
        NULL;
   END LOOP; 
    
   LOOP
      IF NVL (giacp.n ('OR_FLAG_SW'), 0) = 0 THEN
                UPDATE giac_parameters
                   SET param_value_n = 1
                 WHERE param_name = 'OR_FLAG_SW';
                 
                --commit;
                --forms_ddl('COMMIT');
      /*IF v_or_flag_sw = 0 THEN
         v_or_flag_sw := 1;*/
         LOOP
            BEGIN
               SELECT or_no
                 INTO p_or_no
                 FROM giac_order_of_payts
                WHERE or_pref_suf = p_or_pref
                  AND or_no = p_or_no
                  AND gibr_gfun_fund_cd = p_fund_cd
                  AND gibr_branch_cd = p_branch_cd;

               p_or_no := p_or_no + 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  EXIT;
            END;
         END LOOP;
         
         	UPDATE giac_parameters
				   SET param_value_n = 0
				 WHERE param_name = 'OR_FLAG_SW';
                 
            --commit;
         --v_or_flag_sw := 0;
         EXIT;
      END IF;
   END LOOP;
--end reymon

    v_or_pref   := p_or_pref;
    v_or_no     := p_or_no;
  
  IF    p_edit_or_no = 'N' THEN         
        UPDATE GIAC_ORDER_OF_PAYTS
         SET or_pref_suf  = v_or_pref,
                 or_no        = v_or_no
       WHERE gacc_tran_id = p_gacc_tran_id;
       --commit;
       
        --forms_ddl('COMMIT');
        -- START added to check for duplicate values by Jayson 12.23.2011 --
        SELECT COUNT(1)
          INTO no_of_rec
          FROM giac_order_of_payts
         WHERE or_pref_suf  = v_or_pref
             AND or_no        = v_or_no;
      IF no_of_rec > 1 THEN
          /*rand := ROUND(dbms_random.value(3000000,10000000),0); --random delay aprox 1~3 secs
          FOR a IN 1..rand LOOP
              NULL;
          END LOOP;*/   
          rand := ROUND(dbms_random.value(3000000,10000000),0); 
          FOR a IN 1..rand LOOP
                NULL;
          END LOOP; 
                 
          SELECT COUNT(1)
              INTO no_of_rec
              FROM giac_order_of_payts
             WHERE or_pref_suf  = v_or_pref
                 AND or_no        = v_or_no;
             IF no_of_rec > 1 THEN
                p_or_no := p_or_no + 1;
                v_or_no     := p_or_no;
                UPDATE GIAC_ORDER_OF_PAYTS
                 SET or_pref_suf  = v_or_pref,
                         or_no        = v_or_no
               WHERE gacc_tran_id = p_gacc_tran_id;
                
               --commit;
                --forms_ddl('COMMIT');
            END IF;
        --forms_ddl('COMMIT');
        --commit;
      END IF;
        -- END added to check for duplicate values by Jayson 12.23.2011 --
  END IF;                                
END UPDATE_GIOP_GIACS050;
/


