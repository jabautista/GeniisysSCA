CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_WPOLGENIN_PKG AS

   /*
    **  Created by   :  Emman
    **  Date Created :  11.23.2010
    **  Reference By : (GIACS031A - Package Endt Basic Info)
    **  Description  :  Save (Insert/Update) GIPI_PACK_WPOLGENIN record
    */
   PROCEDURE set_gipi_pack_wpolgenin(p_par_id				 	        GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
									 p_genin_info_cd					GIPI_PACK_WPOLGENIN.genin_info_cd%TYPE,
									 p_gen_info01						GIPI_PACK_WPOLGENIN.gen_info01%TYPE,
									 p_gen_info02						GIPI_PACK_WPOLGENIN.gen_info02%TYPE,
									 p_gen_info03						GIPI_PACK_WPOLGENIN.gen_info03%TYPE,
									 p_gen_info04						GIPI_PACK_WPOLGENIN.gen_info04%TYPE,
									 p_gen_info05						GIPI_PACK_WPOLGENIN.gen_info05%TYPE,
									 p_gen_info06						GIPI_PACK_WPOLGENIN.gen_info06%TYPE,
									 p_gen_info07						GIPI_PACK_WPOLGENIN.gen_info07%TYPE,
									 p_gen_info08						GIPI_PACK_WPOLGENIN.gen_info08%TYPE,
									 p_gen_info09						GIPI_PACK_WPOLGENIN.gen_info09%TYPE,
									 p_gen_info10						GIPI_PACK_WPOLGENIN.gen_info10%TYPE,
									 p_gen_info11						GIPI_PACK_WPOLGENIN.gen_info11%TYPE,
									 p_gen_info12						GIPI_PACK_WPOLGENIN.gen_info12%TYPE,
									 p_gen_info13						GIPI_PACK_WPOLGENIN.gen_info13%TYPE,
									 p_gen_info14						GIPI_PACK_WPOLGENIN.gen_info14%TYPE,
									 p_gen_info15						GIPI_PACK_WPOLGENIN.gen_info15%TYPE,
									 p_gen_info16						GIPI_PACK_WPOLGENIN.gen_info16%TYPE,
									 p_gen_info17						GIPI_PACK_WPOLGENIN.gen_info17%TYPE,
									 p_user_id							GIPI_PACK_WPOLGENIN.user_id%TYPE
   			 						 )
   IS
   BEGIN
   		MERGE INTO GIPI_PACK_WPOLGENIN
		USING DUAL ON (pack_par_id = p_par_id)
	    WHEN NOT MATCHED THEN
			 INSERT(pack_par_id,  genin_info_cd, gen_info01,
			 		gen_info02,   gen_info03,    gen_info04,
					gen_info05,   gen_info06,    gen_info07,
					gen_info08,   gen_info09,    gen_info10,
					gen_info11,   gen_info12,    gen_info13,
					gen_info14,   gen_info15,    gen_info16,
					gen_info17,	  user_id)
			 VALUES(p_par_id,  	  p_genin_info_cd, p_gen_info01,
			 		p_gen_info02, p_gen_info03,    p_gen_info04,
					p_gen_info05, p_gen_info06,    p_gen_info07,
					p_gen_info08, p_gen_info09,    p_gen_info10,
					p_gen_info11, p_gen_info12,    p_gen_info13,
					p_gen_info14, p_gen_info15,    p_gen_info16,
					p_gen_info17, p_user_id)
		WHEN MATCHED THEN
			 UPDATE SET genin_info_cd = p_genin_info_cd,
						gen_info01 	  = p_gen_info01,
			 			gen_info02 	  = p_gen_info02,
						gen_info03 	  = p_gen_info03,
						gen_info04 	  = p_gen_info04,
						gen_info05 	  = p_gen_info05,
						gen_info06 	  = p_gen_info06,
						gen_info07 	  = p_gen_info07,
						gen_info08 	  = p_gen_info08,
						gen_info09 	  = p_gen_info09,
						gen_info10 	  = p_gen_info10,
						gen_info11 	  = p_gen_info11,
						gen_info12 	  = p_gen_info12,
						gen_info13 	  = p_gen_info13,
						gen_info14 	  = p_gen_info14,
						gen_info15 	  = p_gen_info15,
						gen_info16 	  = p_gen_info16,
						gen_info17 	  = p_gen_info17,
						user_id		  = p_user_id;
   END set_gipi_pack_wpolgenin;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 02, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This retrieves record from GIPI_PACK_WPOLGENIN with the given pack_par_id.
*/
FUNCTION get_gipi_pack_wpolgenin (p_pack_par_id		GIPI_PACK_WPOLGENIN.pack_par_id%TYPE)
    RETURN gipi_pack_wpolgenin_tab PIPELINED IS

  	v_pack_wpolgenin			gipi_pack_wpolgenin_type;

  BEGIN
    FOR i IN (
		SELECT pack_par_id,    agreed_tag,     genin_info_cd,
			   gen_info01, 	   gen_info02, 	   gen_info03, 	   gen_info04,
			   gen_info05, 	   gen_info06, 	   gen_info07, 	   gen_info08,
			   gen_info09, 	   gen_info10, 	   gen_info11, 	   gen_info12,
			   gen_info13, 	   gen_info14, 	   gen_info15, 	   gen_info16,
			   gen_info17, 	   initial_info01, initial_info02, initial_info03,
			   initial_info04, initial_info05, initial_info06, initial_info07,
			   initial_info08, initial_info09, initial_info10, initial_info11,
			   initial_info12, initial_info13, initial_info14, initial_info15,
			   initial_info16, initial_info17
		FROM GIPI_PACK_WPOLGENIN
	 	WHERE pack_par_id = p_pack_par_id)
	LOOP
	    v_pack_wpolgenin.pack_par_id		:= i.pack_par_id;
		v_pack_wpolgenin.agreed_tag			:= i.agreed_tag;
		v_pack_wpolgenin.genin_info_cd   	:= i.genin_info_cd;
		v_pack_wpolgenin.gen_info01			:= i.gen_info01;
		v_pack_wpolgenin.gen_info02			:= i.gen_info02;
		v_pack_wpolgenin.gen_info03			:= i.gen_info03;
		v_pack_wpolgenin.gen_info04			:= i.gen_info04;
		v_pack_wpolgenin.gen_info05			:= i.gen_info05;
		v_pack_wpolgenin.gen_info06			:= i.gen_info06;
		v_pack_wpolgenin.gen_info07			:= i.gen_info07;
		v_pack_wpolgenin.gen_info08			:= i.gen_info08;
		v_pack_wpolgenin.gen_info09			:= i.gen_info09;
		v_pack_wpolgenin.gen_info10			:= i.gen_info10;
		v_pack_wpolgenin.gen_info11			:= i.gen_info11;
		v_pack_wpolgenin.gen_info12			:= i.gen_info12;
		v_pack_wpolgenin.gen_info13			:= i.gen_info13;
		v_pack_wpolgenin.gen_info14			:= i.gen_info14;
		v_pack_wpolgenin.gen_info15			:= i.gen_info15;
		v_pack_wpolgenin.gen_info16			:= i.gen_info16;
		v_pack_wpolgenin.gen_info17			:= i.gen_info17;
		v_pack_wpolgenin.initial_info01		:= i.initial_info01;
		v_pack_wpolgenin.initial_info02		:= i.initial_info02;
		v_pack_wpolgenin.initial_info03		:= i.initial_info03;
		v_pack_wpolgenin.initial_info04		:= i.initial_info04;
		v_pack_wpolgenin.initial_info05		:= i.initial_info05;
		v_pack_wpolgenin.initial_info06		:= i.initial_info06;
		v_pack_wpolgenin.initial_info07		:= i.initial_info07;
		v_pack_wpolgenin.initial_info08		:= i.initial_info08;
		v_pack_wpolgenin.initial_info09		:= i.initial_info09;
		v_pack_wpolgenin.initial_info10		:= i.initial_info10;
		v_pack_wpolgenin.initial_info11		:= i.initial_info11;
		v_pack_wpolgenin.initial_info12		:= i.initial_info12;
		v_pack_wpolgenin.initial_info13		:= i.initial_info13;
		v_pack_wpolgenin.initial_info14		:= i.initial_info14;
		v_pack_wpolgenin.initial_info15		:= i.initial_info15;
		v_pack_wpolgenin.initial_info16		:= i.initial_info16;
		v_pack_wpolgenin.initial_info17		:= i.initial_info17;

	  PIPE ROW(v_pack_wpolgenin);
	END LOOP;

  END get_gipi_pack_wpolgenin;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 02, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This inserts or updates record to GIPI_PACK_WPOLGENIN.
*/
  PROCEDURE set_gipi_pack_wpolgenin2 (
     p_pack_par_id		IN  GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
	 p_agreed_tag		IN  GIPI_PACK_WPOLGENIN.agreed_tag%TYPE,
	 p_genin_info_cd  	IN  GIPI_PACK_WPOLGENIN.genin_info_cd%TYPE,
	 p_init_info01	    IN  VARCHAR2,
	 p_init_info02	    IN  VARCHAR2,
	 p_init_info03	    IN  VARCHAR2,
	 p_init_info04	    IN  VARCHAR2,
	 p_init_info05	    IN  VARCHAR2,
	 p_init_info06	    IN  VARCHAR2,
	 p_init_info07	    IN  VARCHAR2,
	 p_init_info08	    IN  VARCHAR2,
	 p_init_info09	    IN  VARCHAR2,
	 p_init_info10	    IN  VARCHAR2,
	 p_init_info11	    IN  VARCHAR2,
	 p_init_info12	    IN  VARCHAR2,
	 p_init_info13	    IN  VARCHAR2,
	 p_init_info14	    IN  VARCHAR2,
	 p_init_info15	    IN  VARCHAR2,
	 p_init_info16	    IN  VARCHAR2,
	 p_init_info17	    IN  VARCHAR2,
	 p_gen_info01 		IN  VARCHAR2,
	 p_gen_info02 		IN  VARCHAR2,
	 p_gen_info03 		IN  VARCHAR2,
	 p_gen_info04 		IN  VARCHAR2,
	 p_gen_info05 		IN  VARCHAR2,
	 p_gen_info06 		IN  VARCHAR2,
	 p_gen_info07 		IN  VARCHAR2,
	 p_gen_info08 		IN  VARCHAR2,
	 p_gen_info09 		IN  VARCHAR2,
	 p_gen_info10 		IN  VARCHAR2,
	 p_gen_info11 		IN  VARCHAR2,
	 p_gen_info12 		IN  VARCHAR2,
	 p_gen_info13 		IN  VARCHAR2,
	 p_gen_info14 		IN  VARCHAR2,
	 p_gen_info15 		IN  VARCHAR2,
	 p_gen_info16 		IN  VARCHAR2,
	 p_gen_info17 		IN  VARCHAR2,
	 p_user_id			IN  VARCHAR2) IS

  BEGIN

 	 MERGE INTO GIPI_PACK_WPOLGENIN
	 USING DUAL ON ( pack_par_id = p_pack_par_id )
	   WHEN NOT MATCHED THEN
	     INSERT ( pack_par_id, agreed_tag,   genin_info_cd,
				  gen_info01, gen_info02, gen_info03, gen_info04,
		 		  gen_info05, gen_info06, gen_info07, gen_info08,
				  gen_info09, gen_info10, gen_info11, gen_info12,
				  gen_info13, gen_info14, gen_info15, gen_info16,
				  gen_info17,
				  initial_info01, initial_info02, initial_info03,
				  initial_info04, initial_info05, initial_info06,
				  initial_info07, initial_info08, initial_info09,
				  initial_info10, initial_info11, initial_info12,
				  initial_info13, initial_info14, initial_info15,
				  initial_info16, initial_info17,
				  last_update, 	  user_id)
		 VALUES	( p_pack_par_id,  p_agreed_tag, p_genin_info_cd,
	 	 		  p_gen_info01,
		 		  p_gen_info02,
				  p_gen_info03,
				  p_gen_info04,
				  p_gen_info05,
				  p_gen_info06,
				  p_gen_info07,
				  p_gen_info08,
				  p_gen_info09,
				  p_gen_info10,
				  p_gen_info11,
				  p_gen_info12,
				  p_gen_info13,
				  p_gen_info14,
				  p_gen_info15,
				  p_gen_info16,
				  p_gen_info17,
				  p_init_info01,
				  p_init_info02,
				  p_init_info03,
				  p_init_info04,
				  p_init_info05,
				  p_init_info06,
				  p_init_info07,
				  p_init_info08,
				  p_init_info09,
				  p_init_info10,
				  p_init_info11,
				  p_init_info12,
				  p_init_info13,
				  p_init_info14,
				  p_init_info15,
				  p_init_info16,
				  p_init_info17,
				  SYSDATE, p_user_id)
	   WHEN MATCHED THEN
	     UPDATE SET agreed_tag			= p_agreed_tag,
					genin_info_cd  		= p_genin_info_cd,
					gen_info01			= p_gen_info01,
					gen_info02			= p_gen_info02,
					gen_info03			= p_gen_info03,
					gen_info04			= p_gen_info04,
					gen_info05			= p_gen_info05,
					gen_info06			= p_gen_info06,
					gen_info07			= p_gen_info07,
					gen_info08			= p_gen_info08,
					gen_info09			= p_gen_info09,
					gen_info10			= p_gen_info10,
					gen_info11			= p_gen_info11,
					gen_info12			= p_gen_info12,
					gen_info13			= p_gen_info13,
					gen_info14			= p_gen_info14,
					gen_info15			= p_gen_info15,
					gen_info16			= p_gen_info16,
					gen_info17		  	= p_gen_info17,
					initial_info01		= p_init_info01,
					initial_info02		= p_init_info02,
					initial_info03		= p_init_info03,
					initial_info04		= p_init_info04,
					initial_info05		= p_init_info05,
					initial_info06		= p_init_info06,
					initial_info07		= p_init_info07,
					initial_info08		= p_init_info08,
					initial_info09		= p_init_info09,
					initial_info10		= p_init_info10,
					initial_info11		= p_init_info11,
					initial_info12		= p_init_info12,
					initial_info13		= p_init_info13,
					initial_info14		= p_init_info14,
					initial_info15		= p_init_info15,
					initial_info16		= p_init_info16,
					initial_info17		= p_init_info17,
					last_update			= SYSDATE,
					user_id				= p_user_id;


  END set_gipi_pack_wpolgenin2;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  :  This delete records in GIPI_PACK_WPOLGENIN
**				    with the given pack_par_id.
*/

PROCEDURE del_gipi_pack_wpolgenin (p_pack_par_id        GIPI_PACK_WPOLGENIN.pack_par_id%TYPE)
  IS
  BEGIN
    FOR a IN (SELECT 1
	            FROM GIPI_PACK_WPOLGENIN
			   WHERE pack_par_id = p_pack_par_id)
	LOOP
    	DELETE FROM GIPI_PACK_WPOLGENIN
     		  WHERE pack_par_id = p_pack_par_id;
    END LOOP;

  END del_gipi_pack_wpolgenin;

/*
**  Created by	  : Veronica V. Raymundo
**  Date Created  : March 17, 2011
**  Reference By  : (GIPIS002A- Package PAR Basic Information)
**  Description   : Procedure checks whether a record exist in GIPI_PACK_WPOLGENIN with
**                  the given pack_par_id.
*/

    PROCEDURE chk_gipi_pack_wpolgenin_exist (p_pack_par_id  IN      GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
											 p_exist        OUT     NUMBER)
    IS
        v_exist                    NUMBER := 0;
    BEGIN
        FOR a IN (SELECT 1
                  FROM GIPI_PACK_WPOLGENIN
                  WHERE pack_par_id = p_pack_par_id)
        LOOP
          v_exist := 1;
        END LOOP;
        p_exist := v_exist;
    END chk_gipi_pack_wpolgenin_exist;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : COPY_PACK_POL_WPOLGENIN program unit
  */
    PROCEDURE COPY_PACK_POL_WPOLGENIN(
        p_pack_par_id           gipi_parlist.pack_par_id%TYPE,
        p_pack_policy_id        gipi_pack_polgenin.pack_policy_id%TYPE,
        p_msg_alert         OUT VARCHAR2
        ) IS
        v_user_id           gipi_pack_wpolgenin.user_id%TYPE;
        v_last_update       gipi_pack_wpolgenin.last_update%TYPE;
        v_ws_long_var1      gipi_pack_wpolgenin.gen_info01%TYPE;
        v_ws_long_var2      gipi_pack_wpolgenin.gen_info02%TYPE;
        v_ws_long_var3      gipi_pack_wpolgenin.gen_info03%TYPE;
        v_ws_long_var4      gipi_pack_wpolgenin.gen_info04%TYPE;
        v_ws_long_var5      gipi_pack_wpolgenin.gen_info05%TYPE;
        v_ws_long_var6      gipi_pack_wpolgenin.gen_info06%TYPE;
        v_ws_long_var7      gipi_pack_wpolgenin.gen_info07%TYPE;
        v_ws_long_var8      gipi_pack_wpolgenin.gen_info08%TYPE;
        v_ws_long_var9      gipi_pack_wpolgenin.gen_info09%TYPE;
        v_ws_long_var10     gipi_pack_wpolgenin.gen_info10%TYPE;
        v_ws_long_var11     gipi_pack_wpolgenin.gen_info11%TYPE;
        v_ws_long_var12     gipi_pack_wpolgenin.gen_info12%TYPE;
        v_ws_long_var13     gipi_pack_wpolgenin.gen_info13%TYPE;
        v_ws_long_var14     gipi_pack_wpolgenin.gen_info14%TYPE;
        v_ws_long_var15     gipi_pack_wpolgenin.gen_info15%TYPE;
        v_ws_long_var16     gipi_pack_wpolgenin.gen_info16%TYPE;
        v_ws_long_var17     gipi_pack_wpolgenin.gen_info17%TYPE;
        v_ws_initial        gipi_pack_wpolgenin.initial_info01%TYPE;
        v_ws_initial02      gipi_pack_wpolgenin.initial_info02%TYPE;
        v_ws_initial03      gipi_pack_wpolgenin.initial_info03%TYPE;
        v_ws_initial04      gipi_pack_wpolgenin.initial_info04%TYPE;
        v_ws_initial05      gipi_pack_wpolgenin.initial_info05%TYPE;
        v_ws_initial06      gipi_pack_wpolgenin.initial_info06%TYPE;
        v_ws_initial07      gipi_pack_wpolgenin.initial_info07%TYPE;
        v_ws_initial08      gipi_pack_wpolgenin.initial_info08%TYPE;
        v_ws_initial09      gipi_pack_wpolgenin.initial_info09%TYPE;
        v_ws_initial10      gipi_pack_wpolgenin.initial_info10%TYPE;
        v_ws_initial11      gipi_pack_wpolgenin.initial_info11%TYPE;
        v_ws_initial12      gipi_pack_wpolgenin.initial_info12%TYPE;
        v_ws_initial13      gipi_pack_wpolgenin.initial_info13%TYPE;
        v_ws_initial14      gipi_pack_wpolgenin.initial_info14%TYPE;
        v_ws_initial15      gipi_pack_wpolgenin.initial_info15%TYPE;
        v_ws_initial16      gipi_pack_wpolgenin.initial_info16%TYPE;
        v_ws_initial17      gipi_pack_wpolgenin.initial_info17%TYPE;
    BEGIN
       BEGIN
        SELECT  gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,gen_info06,
                gen_info07,gen_info08,gen_info09,gen_info10,gen_info11,gen_info12,
                gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
                initial_info01,initial_info02,initial_info03,
                initial_info04,initial_info05,initial_info06,initial_info07,initial_info08,
                initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
                initial_info14,initial_info15,initial_info16,initial_info17,
                user_id,last_update
          INTO  v_ws_long_var1,v_ws_long_var2,
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
                v_user_id, v_last_update
          FROM gipi_pack_wpolgenin
         WHERE pack_par_id = p_pack_par_id;
         INSERT INTO gipi_pack_polgenin(pack_policy_id,gen_info01,gen_info02,gen_info03,gen_info04,
                     gen_info05,gen_info06,gen_info07,gen_info08,gen_info09,gen_info10,
                     gen_info11,gen_info12,gen_info13,gen_info14,gen_info15,gen_info16,
                     gen_info17,initial_info01,initial_info02,initial_info03,
                     initial_info04,initial_info05,initial_info06,initial_info07,initial_info08,
                     initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
                     initial_info14,initial_info15,initial_info16,initial_info17,
                     user_id,last_update)
              VALUES (p_pack_policy_id,v_ws_long_var1,v_ws_long_var2,
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
                      v_user_id,v_last_update);
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
        WHEN TOO_MANY_ROWS THEN
         p_msg_alert := 'General information has more than one record for a single PAR, cannot proceed.';
       END;
    END;

	PROCEDURE copy_pack_wpolgenin_giuts008a (
		p_policy_id   IN gipi_pack_wpolgenin.pack_par_id%TYPE,
		p_pack_par_id IN gipi_pack_wpolgenin.pack_par_id%TYPE,
		p_user_id     IN giis_users.user_id%TYPE
	) IS
		v_first_info       gipi_polgenin.first_info%TYPE;
	BEGIN
		INSERT INTO gipi_pack_wpolgenin
					(pack_par_id,gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,gen_info06,gen_info07,gen_info08,
					gen_info09,gen_info10,gen_info11,gen_info12,gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
					genin_info_cd,initial_info01,initial_info02,initial_info03,initial_info04,initial_info05,initial_info06,
					initial_info07,initial_info08,initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
					initial_info14,initial_info15,initial_info16,initial_info17,user_id,last_update)
			 SELECT p_pack_par_id,gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,gen_info06,gen_info07,gen_info08,
			 		gen_info09,gen_info10,gen_info11,gen_info12,gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
					genin_info_cd,initial_info01,initial_info02,initial_info03,initial_info04,initial_info05,initial_info06,
					initial_info07,initial_info08,initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
					initial_info14,initial_info15,initial_info16,initial_info17,p_user_id,SYSDATE
			   FROM gipi_pack_polgenin
			  WHERE pack_policy_id = p_policy_id;
		  EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    NULL;
	END;

END GIPI_PACK_WPOLGENIN_PKG;
/


