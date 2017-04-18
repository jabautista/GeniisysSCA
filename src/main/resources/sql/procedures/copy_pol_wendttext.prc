DROP PROCEDURE CPI.COPY_POL_WENDTTEXT;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wendttext(
	   	  		  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE,
				  p_msg_alert	OUT VARCHAR2
				  )
 	    IS
  --p_endt_tax        gipi_endtttext.endt_tax%TYPE;
  p_endt_tax        VARCHAR2(1);
  p_endt_cd					VARCHAR2(4);
  p_user_id         gipi_endttext.user_id%TYPE;
  p_last_update     gipi_endttext.last_update%TYPE;
  
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  /* beth 02132001 add transfering of field endt_tax from work to final table*/
  /* loreen 04012005 add transfering of field endt_cd from work to final table*/
--  v_ws_long_var   gipi_wendttext.endt_text%TYPE;
--  v_ws_long_var1  gipi_wendttext.endt_text01%TYPE;
--  v_ws_long_var2  gipi_wendttext.endt_text02%TYPE;
--  v_ws_long_var3  gipi_wendttext.endt_text03%TYPE;
--  v_ws_long_var4  gipi_wendttext.endt_text04%TYPE;
--  v_ws_long_var5  gipi_wendttext.endt_text05%TYPE;
--  v_ws_long_var6  gipi_wendttext.endt_text06%TYPE;
--  v_ws_long_var7  gipi_wendttext.endt_text07%TYPE;
--  v_ws_long_var8  gipi_wendttext.endt_text08%TYPE;
--  v_ws_long_var9  gipi_wendttext.endt_text09%TYPE;
--  v_ws_long_var10  gipi_wendttext.endt_text10%TYPE;
--  v_ws_long_var11  gipi_wendttext.endt_text11%TYPE;
--  v_ws_long_var12  gipi_wendttext.endt_text12%TYPE;
--  v_ws_long_var13  gipi_wendttext.endt_text13%TYPE;
--  v_ws_long_var14  gipi_wendttext.endt_text14%TYPE;
--  v_ws_long_var15  gipi_wendttext.endt_text15%TYPE;
--  v_ws_long_var16  gipi_wendttext.endt_text16%TYPE;
--  v_ws_long_var17  gipi_wendttext.endt_text17%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wendttext program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Finalising Policy text info..';
  ELSE
    :gauge.file := 'passing copy policy WENDTTEXT';
  END IF;
  vbx_counter;
  :gauge.file := 'passing copy policy ENDT TEXT';
  vbx_counter;*/
  
/*********
** Modified by Andrew Robes
** Date : 5.22.2013
** Modification : Changed the way of copying gipi_wendttext to gipi_endttext to handle the endt_text column with LONG datatype, error occurs when the max length of the column is used  
************/ 

    INSERT INTO gipi_endttext
                (policy_id, endt_text01, endt_text02, endt_text03, endt_text04, endt_text05,
                 endt_text06, endt_text07, endt_text08, endt_text09, endt_text10, endt_text11,
                 endt_text12, endt_text13, endt_text14, endt_text15, endt_text16, endt_text17,
                 endt_text, user_id, last_update, endt_tax, endt_cd)
           SELECT p_policy_id, endt_text01, endt_text02, endt_text03, endt_text04, endt_text05, 
                  endt_text06, endt_text07, endt_text08, endt_text09, endt_text10, endt_text11, 
                  endt_text12, endt_text13, endt_text14, endt_text15, endt_text16, endt_text17, 
                  TO_LOB(endt_text), p_user_id, p_last_update, endt_tax, endt_cd   -- changed p_endt_cd to endt_cd by robert 04.24.14 -loreen  --p_endt_tax to endt_tax Halley 11.25.13 
             FROM gipi_wendttext
            WHERE par_id = p_par_id;  
 
--  SELECT endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,endt_text06,
--         endt_text07,endt_text08,endt_text09,endt_text10,endt_text11,endt_text12,
--         endt_text13,endt_text14,endt_text15,endt_text16,endt_text17,
--         endt_text, user_id, last_update, endt_tax, endt_cd												--loreen					
--	INTO v_ws_long_var1, v_ws_long_var2, v_ws_long_var3,
--		 v_ws_long_var4, v_ws_long_var5, v_ws_long_var6,
--		 v_ws_long_var7, v_ws_long_var8, v_ws_long_var9,
--		 v_ws_long_var10,v_ws_long_var11,v_ws_long_var12,
--		 v_ws_long_var13,v_ws_long_var14,v_ws_long_var15,
--		 v_ws_long_var16,v_ws_long_var17,
--		 v_ws_long_var, p_user_id,p_last_update, p_endt_tax, p_endt_cd
--    FROM gipi_wendttext
--   WHERE par_id = p_par_id;
--  INSERT INTO gipi_endttext
--              (policy_id,endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,
--               endt_text06,endt_text07,endt_text08,endt_text09,endt_text10,
--               endt_text11,endt_text12,endt_text13,endt_text14,endt_text15,
--               endt_text16,endt_text17, endt_text, user_id,last_update, 
--               endt_tax, endt_cd)
--       VALUES (p_policy_id,v_ws_long_var1, v_ws_long_var2, v_ws_long_var3,
--		 	   v_ws_long_var4, v_ws_long_var5, v_ws_long_var6,
--		 	   v_ws_long_var7, v_ws_long_var8, v_ws_long_var9,
--		 	   v_ws_long_var10,v_ws_long_var11,v_ws_long_var12,
--		 	   v_ws_long_var13,v_ws_long_var14,v_ws_long_var15,
--		 	   v_ws_long_var16,v_ws_long_var17,
--		 	   v_ws_long_var, p_user_id,p_last_update, p_endt_tax, p_endt_cd);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_msg_alert := 'PAR must have an endorsement text existing.';
  WHEN TOO_MANY_ROWS THEN
       p_msg_alert := 'PAR must have only one Policy/Endorsement text.';
END;
/


