DROP PROCEDURE CPI.GIPIS031A_WPOLGENIN_POST_INSRT;

CREATE OR REPLACE PROCEDURE CPI.gipis031A_wpolgenin_post_insrt(p_par_id		GIPI_PACK_WPOLGENIN.pack_par_id%TYPE)
IS
    /*
	**  Created by		: Emman
	**  Date Created 	: 11.26.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: Executes POST-INSERT-ITEM trigger of B550 (GIPI_PACK_WPOLGENIN) block 
	*/
BEGIN
	INSERT INTO gipi_wpolgenin(par_id, gen_info01, gen_info02, gen_info03, 
		   gen_info04, gen_info05, gen_info06, 
		   gen_info07, gen_info08, gen_info09, 
		   gen_info10, gen_info11, gen_info12, 
		   gen_info13, gen_info14, gen_info15, 
		   gen_info16, gen_info17, genin_info_cd, 
		   initial_info01, initial_info02, initial_info03, 
		   initial_info04, initial_info05, initial_info06, 
		   initial_info07, initial_info08, initial_info09, 
		   initial_info10, initial_info11, initial_info12, 
		   initial_info13, initial_info14, initial_info15, 
		   initial_info16, initial_info17, agreed_tag)
	SELECT a.par_id, 
		   b.gen_info01, b.gen_info02, b.gen_info03, 
		   b.gen_info04, b.gen_info05, b.gen_info06, 
		   b.gen_info07, b.gen_info08, b.gen_info09, 
		   b.gen_info10, b.gen_info11, b.gen_info12, 
		   b.gen_info13, b.gen_info14, b.gen_info15, 
		   b.gen_info16, b.gen_info17, b.genin_info_cd, 
		   b.initial_info01, b.initial_info02, b.initial_info03, 
		   b.initial_info04, b.initial_info05, b.initial_info06, 
		   b.initial_info07, b.initial_info08, b.initial_info09, 
		   b.initial_info10, b.initial_info11, b.initial_info12, 
		   b.initial_info13, b.initial_info14, b.initial_info15, 
		   b.initial_info16, b.initial_info17, b.agreed_tag					   
	FROM gipi_parlist a,
	     gipi_pack_wpolgenin b
	WHERE a.pack_par_id = b.pack_par_id
	  AND a.par_status NOT IN (98,99)
	  AND b.pack_par_id = p_par_id
	  AND NOT EXISTS (SELECT 1
	                    FROM gipi_wpolgenin z
	                   WHERE z.par_id = a.par_id);
END gipis031A_wpolgenin_post_insrt;
/


