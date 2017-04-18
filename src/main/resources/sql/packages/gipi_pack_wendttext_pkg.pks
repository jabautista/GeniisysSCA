CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_WENDTTEXT_PKG AS

	TYPE gipis031A_pack_wendttext_type IS RECORD (
		 pack_par_id				   GIPI_PACK_WENDTTEXT.pack_par_id%TYPE,
		 endt_cd					   GIPI_PACK_WENDTTEXT.endt_cd%TYPE,
		 endt_tax					   GIPI_PACK_WENDTTEXT.endt_tax%TYPE,
		 endt_text01				   GIPI_PACK_WENDTTEXT.endt_text01%TYPE,
		 endt_text02				   GIPI_PACK_WENDTTEXT.endt_text02%TYPE,
		 endt_text03				   GIPI_PACK_WENDTTEXT.endt_text03%TYPE,
		 endt_text04				   GIPI_PACK_WENDTTEXT.endt_text04%TYPE,
		 endt_text05				   GIPI_PACK_WENDTTEXT.endt_text05%TYPE,
		 endt_text06				   GIPI_PACK_WENDTTEXT.endt_text06%TYPE,
		 endt_text07				   GIPI_PACK_WENDTTEXT.endt_text07%TYPE,
		 endt_text08				   GIPI_PACK_WENDTTEXT.endt_text08%TYPE,
		 endt_text09				   GIPI_PACK_WENDTTEXT.endt_text09%TYPE,
		 endt_text10				   GIPI_PACK_WENDTTEXT.endt_text10%TYPE,
		 endt_text11				   GIPI_PACK_WENDTTEXT.endt_text11%TYPE,
		 endt_text12				   GIPI_PACK_WENDTTEXT.endt_text12%TYPE,
		 endt_text13				   GIPI_PACK_WENDTTEXT.endt_text13%TYPE,
		 endt_text14				   GIPI_PACK_WENDTTEXT.endt_text14%TYPE,
		 endt_text15				   GIPI_PACK_WENDTTEXT.endt_text15%TYPE,
		 endt_text16				   GIPI_PACK_WENDTTEXT.endt_text16%TYPE,
		 endt_text17				   GIPI_PACK_WENDTTEXT.endt_text17%TYPE,
		 dsp_endt_text				   GIPI_PACK_WENDTTEXT.endt_text01%TYPE
	);
	
	TYPE rc_gipi_pack_wendttext_cur IS REF CURSOR RETURN gipis031A_pack_wendttext_type;
	
	PROCEDURE set_gipi_pack_wendttext(p_par_id				       GIPI_PACK_WENDTTEXT.pack_par_id%TYPE,
									 p_endt_cd					   GIPI_PACK_WENDTTEXT.endt_cd%TYPE,
									 p_endt_tax					   GIPI_PACK_WENDTTEXT.endt_tax%TYPE,
									 p_endt_text01				   GIPI_PACK_WENDTTEXT.endt_text01%TYPE,
									 p_endt_text02				   GIPI_PACK_WENDTTEXT.endt_text02%TYPE,
									 p_endt_text03				   GIPI_PACK_WENDTTEXT.endt_text03%TYPE,
									 p_endt_text04				   GIPI_PACK_WENDTTEXT.endt_text04%TYPE,
									 p_endt_text05				   GIPI_PACK_WENDTTEXT.endt_text05%TYPE,
									 p_endt_text06				   GIPI_PACK_WENDTTEXT.endt_text06%TYPE,
									 p_endt_text07				   GIPI_PACK_WENDTTEXT.endt_text07%TYPE,
									 p_endt_text08				   GIPI_PACK_WENDTTEXT.endt_text08%TYPE,
									 p_endt_text09				   GIPI_PACK_WENDTTEXT.endt_text09%TYPE,
									 p_endt_text10				   GIPI_PACK_WENDTTEXT.endt_text10%TYPE,
									 p_endt_text11				   GIPI_PACK_WENDTTEXT.endt_text11%TYPE,
									 p_endt_text12				   GIPI_PACK_WENDTTEXT.endt_text12%TYPE,
									 p_endt_text13				   GIPI_PACK_WENDTTEXT.endt_text13%TYPE,
									 p_endt_text14				   GIPI_PACK_WENDTTEXT.endt_text14%TYPE,
									 p_endt_text15				   GIPI_PACK_WENDTTEXT.endt_text15%TYPE,
									 p_endt_text16				   GIPI_PACK_WENDTTEXT.endt_text16%TYPE,
									 p_endt_text17				   GIPI_PACK_WENDTTEXT.endt_text17%TYPE,
									 p_user_id					   GIPI_PACK_WENDTTEXT.user_id%TYPE
   			 						 );
	
    PROCEDURE del_GIPI_PACK_WENDTTEXT(p_pack_par_id         GIPI_PACK_WENDTTEXT.pack_par_id%TYPE);
    
END GIPI_PACK_WENDTTEXT_PKG;
/


