CREATE OR REPLACE PACKAGE BODY CPI.giac_dcb_users_pkg
AS
   FUNCTION get_cashier_cd (
      p_fund_cd     giac_dcb_users.gibr_fund_cd%TYPE,
      p_branch_cd   giac_dcb_users.gibr_branch_cd%TYPE,
	  p_user_id     giac_dcb_users.user_id%TYPE
   )
      RETURN giac_dcb_users_tab PIPELINED
   IS
      v_cashier   giac_dcb_users_type;
   BEGIN
      FOR i IN (SELECT cashier_cd
                  FROM giac_dcb_users
                 WHERE gibr_fund_cd = p_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND dcb_user_id = p_user_id)
      LOOP
         v_cashier.cashier_cd := i.cashier_cd;
         PIPE ROW (v_cashier);
         EXIT;
      END LOOP;

      RETURN;
   END get_cashier_cd;
   
   
   FUNCTION get_valid_user_info(
        p_fund_cd     giac_dcb_users.gibr_fund_cd%TYPE,
        p_branch_cd   giac_dcb_users.gibr_branch_cd%TYPE,
        p_user_id     giac_dcb_users.user_id%TYPE
   ) RETURN giac_dcb_users_tab PIPELINED
   IS
    /*
    **  Created by   :  D. Alcantara
    **  Date Created :  01/27/2011
    **  Reference By :  GIACS156 - Branch O.R.
    **  Description  :  get row to be used for validating the user
    */
        v_user      giac_dcb_users_type;
--        v_fund_cd   GIAC_DCB_userS.gibr_fund_cd%TYPE;
--        v_branch_cd GIAC_DCB_userS.gibr_branch_cd%TYPE;
   BEGIN
--        v_fund_cd := get_main_co;
 --       v_branch_cd := get_branch_cd_ho;
        FOR i IN(
            SELECT valid_tag, effectivity_dt, expiry_dt
              FROM giac_dcb_users
              WHERE gibr_fund_cd = p_fund_cd
              AND gibr_branch_cd = p_branch_cd
              AND dcb_user_id = NVL (p_user_id, USER))
        LOOP
            v_user.valid_tag := i.valid_tag;
            v_user.effectivity_dt := i.effectivity_dt;
            v_user.expiry_dt      := i.expiry_dt;
            PIPE ROW (v_user);
        END LOOP;
        RETURN;
   END get_valid_user_info;
   
   /*
    **  Created by   :  Bryan Joseph G. Abuluyan
    **  Date Created :  03.10.2011
    **  Description  :  checks if user exists in table
    */
   FUNCTION check_if_user_exists(p_user_id  GIAC_DCB_USERS.user_id%TYPE)
     RETURN VARCHAR2 IS
     v_exist    	 VARCHAR2(1) := 'N';
	 v_branch_cd	 giis_user_grp_hdr.grp_iss_cd%TYPE := '';
	 v_fund_cd		 GIAC_PARAMETERS.param_value_v%TYPE := '';
	 v_count		 NUMBER(1) := 0;
   BEGIN
     FOR i IN (SELECT GIIS_USERS_PKG.get_grp_iss_cd(p_user_id) grp_iss_cd
	 	   	     FROM DUAL)
	 LOOP
	 	 v_branch_cd := i.grp_iss_cd;
	 END LOOP;
	 
	 FOR i IN (SELECT GIAC_PARAMETERS_PKG.v('FUND_CD') PARAM_VALUE_V
	 	   	     FROM DUAL)
	 LOOP
	 	 v_fund_cd := i.param_value_v;
	 END LOOP;
	 
     FOR i IN (SELECT 'Y' exist
                 FROM GIAC_DCB_USERS
                WHERE gibr_fund_cd = v_fund_cd
			      AND gibr_branch_cd = v_branch_cd
			      AND dcb_user_id = p_user_id)
     LOOP
     	 v_exist := i.exist;
		 v_count := v_count + 1;
		 
		 IF (v_count > 1) THEN
		 	EXIT;
		 END IF;
     END LOOP;
	 
	 -- to check if rows returned more than one
	 IF v_count > 1 THEN
	 	RETURN 'N';
	 END IF;
	 
     RETURN v_exist;
   END check_if_user_exists;
   
END giac_dcb_users_pkg;
/


