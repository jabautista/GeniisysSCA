DROP PROCEDURE CPI.UPDATE_GIOP_GIACS050_P1;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIOP_GIACS050_P1 (
    p_or_no                 IN OUT GIAC_ORDER_OF_PAYTS.or_no%TYPE,
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
  v_or_assigned	NUMBER(1) := 0;
  
  v_or_existing  GIAC_ORDER_OF_PAYTS.OR_NO%TYPE;
  v_user         GIAC_ORDER_OF_PAYTS.user_id%TYPE;
BEGIN    
	FOR i IN (
	  SELECT or_no, user_id FROM giac_order_of_payts
	   WHERE gacc_tran_id = p_gacc_tran_id
	) LOOP
		v_or_existing := i.or_no;
		v_user := i.user_id;
		EXIT;
	END LOOP;
	IF v_or_existing IS NOT NULL THEN
		UPDATE giac_parameters
            SET param_value_n = 0
          WHERE param_name = 'OR_FLAG_SW';
		  
		raise_application_error
						(-20005,
						 'Geniisys Exception#E#This O.R. has been printed by '||v_user
						);
	END IF;
	                                              
   --LOOP
      --IF NVL (giacp.n ('OR_FLAG_SW'), 0) = 0 THEN
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
         --EXIT;
      --END IF;
   --END LOOP;
--end reymon
END UPDATE_GIOP_GIACS050_P1;
/


