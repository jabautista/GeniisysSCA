DROP FUNCTION CPI.CHECK_DCB_USER;

CREATE OR REPLACE FUNCTION CPI.check_dcb_user (
   p_fund_cd    giac_dcb_users.gibr_fund_cd%TYPE
  ,p_branch_cd  giac_dcb_users.gibr_branch_cd%TYPE
  ) RETURN NUMBER AS

/*Created by:   Vincent
**Date Created: 04032006
**Description:  Checks if the USER is a DCB user. Used by GIACS053.
*/

  CURSOR C IS
    SELECT cashier_cd, valid_tag
      FROM giac_dcb_users
     WHERE gibr_fund_cd = p_fund_cd
       AND gibr_branch_cd = p_branch_cd
       AND dcb_user_id = USER;

 	v_cashier_cd    giac_dcb_users.cashier_cd%TYPE;
 	v_valid_tag    	giac_dcb_users.valid_tag%TYPE;
  v_valid_user    NUMBER := 1;

BEGIN
  OPEN C;
	FETCH C
	INTO v_cashier_cd, v_valid_tag;
	IF C%NOTFOUND THEN
    v_valid_user := 0;
  END IF;
  CLOSE C;

  --check first if you're a valid user
  IF v_valid_tag = 'N' THEN
    v_valid_user := 0;
  END IF;

  RETURN(v_valid_user);
END check_dcb_user;
/


