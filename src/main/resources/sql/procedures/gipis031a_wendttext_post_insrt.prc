DROP PROCEDURE CPI.GIPIS031A_WENDTTEXT_POST_INSRT;

CREATE OR REPLACE PROCEDURE CPI.gipis031A_wendttext_post_insrt(p_par_id		GIPI_PACK_WENDTTEXT.pack_par_id%TYPE)
IS
    /*
	**  Created by		: Emman
	**  Date Created 	: 11.26.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: Executes POST-INSERT-ITEM trigger of B360 (GIPI_PACK_WENDTTEXT) block 
	*/
BEGIN
	INSERT INTO gipi_wendttext(par_id, endt_tax, endt_text01, 
							   endt_text02, endt_text03, endt_text04, 
							   endt_text05, endt_text06, endt_text07, 
							   endt_text08, endt_text09, endt_text10, 
							   endt_text11, endt_text12, endt_text13, 
							   endt_text14, endt_text15, endt_text16, 
							   endt_text17, endt_cd)
	SELECT a.par_id, b.endt_tax, b.endt_text01, 
	       b.endt_text02, b.endt_text03, b.endt_text04, 
		   b.endt_text05, b.endt_text06, b.endt_text07, 
		   b.endt_text08, b.endt_text09, b.endt_text10, 
		   b.endt_text11, b.endt_text12, b.endt_text13, 
		   b.endt_text14, b.endt_text15, b.endt_text16, 
		   b.endt_text17, b.endt_cd						   
	FROM gipi_parlist a,
	     gipi_pack_wendttext b
	WHERE a.pack_par_id = b.pack_par_id
	  AND a.par_status NOT IN (98,99)
	  AND b.pack_par_id = p_par_id
	  AND NOT EXISTS (SELECT 1
	                    FROM gipi_wendttext z
	                   WHERE z.par_id = a.par_id);
END gipis031A_wendttext_post_insrt;
/


