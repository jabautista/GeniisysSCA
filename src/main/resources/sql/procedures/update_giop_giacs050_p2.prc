DROP PROCEDURE CPI.UPDATE_GIOP_GIACS050_P2;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIOP_GIACS050_P2 (
    p_or_no              IN OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
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
  
  --v_or_existing  GIAC_ORDER_OF_PAYTS.OR_NO%TYPE;
  --v_user         GIAC_ORDER_OF_PAYTS.user_id%TYPE;
BEGIN                                                 
    v_or_pref   := p_or_pref;
    v_or_no     := p_or_no;
  
    IF p_edit_or_no = 'N' THEN         
        /*FOR i IN (
          SELECT or_no, user_id FROM giac_order_of_payts
           WHERE gacc_tran_id = p_gacc_tran_id
        ) LOOP
            v_or_existing := i.or_no;
            v_user := i.user_id;
            EXIT;
        END LOOP;
        IF v_or_existing IS NOT NULL THEN
            raise_application_error
                            (-20005,
                             'Geniisys Exception#E#This O.R. has been printed by '||v_user
                            );
        END IF;*/  --transferred to UPDATE_GIOP_GIACS050_P1
        
        UPDATE GIAC_ORDER_OF_PAYTS
           SET or_pref_suf  = v_or_pref,
                 or_no      = v_or_no,
                 user_id    = nvl(giis_users_pkg.app_user, USER)
         WHERE gacc_tran_id = p_gacc_tran_id;

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
                
            END IF;
      
      END IF;
      
  END IF;                                
END UPDATE_GIOP_GIACS050_P2;
/


