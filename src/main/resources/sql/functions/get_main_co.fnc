DROP FUNCTION CPI.GET_MAIN_CO;

CREATE OR REPLACE FUNCTION CPI.get_main_co RETURN VARCHAR2 IS
  v_fund_cd   GIIS_FUNDS.fund_cd%TYPE;
     
  CURSOR co IS
    SELECT param_value_v
      FROM giac_parameters
      WHERE UPPER(param_name) = 'MAIN_FUND_CD';
BEGIN
  	/*
	**  Created by		: D.Alcantara
	**  Date Created 	: 01.27.2011
	**  Reference By 	: (GIACS156 - Branch O.R.)
	**  Description 	: Get the v_fund_cd fron giis_funds
	*/

  OPEN co;
  FETCH co INTO v_fund_cd;
    IF co%NOTFOUND THEN
      v_fund_cd := null;
    END IF;
  CLOSE co;
     
  RETURN(v_fund_cd);
    EXCEPTION
      WHEN OTHERS THEN
        v_fund_cd := null;
       -- CGTE$OTHER_EXCEPTIONS;
    RETURN NULL;    
END get_main_co;
/


