DROP PROCEDURE CPI.COPY_POL_WPOLGENIN;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpolgenin(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id			IN  GIPI_POLBASIC.policy_id%TYPE,
				  p_msg_alert			OUT VARCHAR2
	   	  		  )
	    IS
  v_first_info      GIPI_WPOLGENIN.first_info%TYPE;
  v_user_id         GIPI_WPOLGENIN.user_id%TYPE;
  v_last_update     GIPI_WPOLGENIN.last_update%TYPE;
  v_genin_info_cd	GIPI_WPOLGENIN.genin_info_cd%TYPE;
  
  v_ws_long_var		GIPI_WPOLGENIN.gen_info%TYPE;
  v_ws_long_var1	GIPI_WPOLGENIN.gen_info01%TYPE;
  v_ws_long_var2	GIPI_WPOLGENIN.gen_info02%TYPE;
  v_ws_long_var3	GIPI_WPOLGENIN.gen_info03%TYPE;
  v_ws_long_var4	GIPI_WPOLGENIN.gen_info04%TYPE; 
  v_ws_long_var5	GIPI_WPOLGENIN.gen_info05%TYPE;
  v_ws_long_var6	GIPI_WPOLGENIN.gen_info06%TYPE;
  v_ws_long_var7    GIPI_WPOLGENIN.gen_info07%TYPE;
  v_ws_long_var8	GIPI_WPOLGENIN.gen_info08%TYPE;
  v_ws_long_var9	GIPI_WPOLGENIN.gen_info09%TYPE;
  v_ws_long_var10	GIPI_WPOLGENIN.gen_info10%TYPE;
  v_ws_long_var11	GIPI_WPOLGENIN.gen_info11%TYPE;
  v_ws_long_var12	GIPI_WPOLGENIN.gen_info12%TYPE;
  v_ws_long_var13	GIPI_WPOLGENIN.gen_info13%TYPE;
  v_ws_long_var14	GIPI_WPOLGENIN.gen_info14%TYPE;
  v_ws_long_var15	GIPI_WPOLGENIN.gen_info15%TYPE;
  v_ws_long_var16	GIPI_WPOLGENIN.gen_info16%TYPE;
  v_ws_long_var17	GIPI_WPOLGENIN.gen_info17%TYPE; 
  v_ws_initial		GIPI_WPOLGENIN.initial_info01%TYPE; 
  v_ws_initial02	GIPI_WPOLGENIN.initial_info02%TYPE;
  v_ws_initial03	GIPI_WPOLGENIN.initial_info03%TYPE;
  v_ws_initial04	GIPI_WPOLGENIN.initial_info04%TYPE;
  v_ws_initial05	GIPI_WPOLGENIN.initial_info05%TYPE;
  v_ws_initial06	GIPI_WPOLGENIN.initial_info06%TYPE;
  v_ws_initial07	GIPI_WPOLGENIN.initial_info07%TYPE;
  v_ws_initial08	GIPI_WPOLGENIN.initial_info08%TYPE;
  v_ws_initial09	GIPI_WPOLGENIN.initial_info09%TYPE;
  v_ws_initial10	GIPI_WPOLGENIN.initial_info10%TYPE;
  v_ws_initial11	GIPI_WPOLGENIN.initial_info11%TYPE;
  v_ws_initial12	GIPI_WPOLGENIN.initial_info12%TYPE;
  v_ws_initial13	GIPI_WPOLGENIN.initial_info13%TYPE;
  v_ws_initial14	GIPI_WPOLGENIN.initial_info14%TYPE;
  v_ws_initial15	GIPI_WPOLGENIN.initial_info15%TYPE;
  v_ws_initial16	GIPI_WPOLGENIN.initial_info16%TYPE;
  v_ws_initial17	GIPI_WPOLGENIN.initial_info17%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wpolbas program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising General info..';
  ELSE
    :gauge.FILE := 'passing copy policy WPOLGENIN';
  END IF;
  vbx_counter;  */
   BEGIN
    SELECT  gen_info,gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,gen_info06,
            gen_info07,gen_info08,gen_info09,gen_info10,gen_info11,gen_info12,
            gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
            initial_info01,initial_info02,initial_info03,
            initial_info04,initial_info05,initial_info06,initial_info07,initial_info08,
            initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
            initial_info14,initial_info15,initial_info16,initial_info17,
            first_info, user_id,last_update, genin_info_cd
      INTO  v_ws_long_var,v_ws_long_var1,v_ws_long_var2,
      			v_ws_long_var3,v_ws_long_var4,v_ws_long_var5,
      			v_ws_long_var6,v_ws_long_var7,v_ws_long_var8,
      			v_ws_long_var9,v_ws_long_var10,v_ws_long_var11,
      			v_ws_long_var12,v_ws_long_var13,v_ws_long_var14,
      			v_ws_long_var15,v_ws_long_var16,v_ws_long_var17, 
      			v_ws_initial,v_ws_initial02,
      			v_ws_initial03,v_ws_initial04,v_ws_initial05,
      			v_ws_initial06,v_ws_initial07,v_ws_initial08,
      			v_ws_initial09,v_ws_initial10,v_ws_initial11,
      			v_ws_initial12,v_ws_initial13,v_ws_initial14,
      			v_ws_initial15,v_ws_initial16,v_ws_initial17,
      			v_first_info,v_user_id, v_last_update, v_genin_info_cd
      FROM GIPI_WPOLGENIN
     WHERE par_id = p_par_id;
     INSERT INTO GIPI_POLGENIN(policy_id,gen_info01,gen_info02,gen_info03,gen_info04,
                 gen_info05,gen_info06,gen_info07,gen_info08,gen_info09,gen_info10,
                 gen_info11,gen_info12,gen_info13,gen_info14,gen_info15,gen_info16,
                 gen_info17,gen_info, initial_info01,initial_info02,initial_info03,
                 initial_info04,initial_info05,initial_info06,initial_info07,initial_info08,
                 initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
                 initial_info14,initial_info15,initial_info16,initial_info17, first_info,
                 user_id,last_update, genin_info_cd)
          VALUES (p_policy_id,v_ws_long_var1,v_ws_long_var2,
                 v_ws_long_var3,v_ws_long_var4,v_ws_long_var5,
                 v_ws_long_var6,v_ws_long_var7,v_ws_long_var8,
                 v_ws_long_var9,v_ws_long_var10,v_ws_long_var11,
                 v_ws_long_var12,v_ws_long_var13,v_ws_long_var14,
                 v_ws_long_var15,v_ws_long_var16,v_ws_long_var17,
                 v_ws_long_var,v_ws_initial,v_ws_initial02,
      			 v_ws_initial03,v_ws_initial04,v_ws_initial05,
      			 v_ws_initial06,v_ws_initial07,v_ws_initial08,
      			 v_ws_initial09,v_ws_initial10,v_ws_initial11,
      			 v_ws_initial12,v_ws_initial13,v_ws_initial14,
      			 v_ws_initial15,v_ws_initial16,v_ws_initial17, 
                 v_first_info,v_user_id,v_last_update, v_genin_info_cd);
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN TOO_MANY_ROWS THEN
     p_MSG_ALERT := 'General information has more than one record for a single PAR, '||
               'cannot proceed.';
   END;
END;
/


