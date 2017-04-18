CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_WENDTTEXT_PKG AS

   /*
    **  Created by   :  Emman
    **  Date Created :  11.23.2010
    **  Reference By : (GIACS031A - Package Endt Basic Info)
    **  Description  :  Save (Insert/Update) GIPI_PACK_WENDTTEXT record
    */
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
   			 						 )
   IS
   BEGIN
   		MERGE INTO GIPI_PACK_WENDTTEXT
		USING DUAL ON (pack_par_id = p_par_id)
	    WHEN NOT MATCHED THEN
			 INSERT(pack_par_id,   	 		  endt_cd,			   endt_tax,
					endt_text01,			  endt_text02,		   endt_text03,
					endt_text04,			  endt_text05,		   endt_text06,
					endt_text07,			  endt_text08,		   endt_text09,
					endt_text10,			  endt_text11,		   endt_text12,
					endt_text13,			  endt_text14,		   endt_text15,
					endt_text16,			  endt_text17,		   user_id)
			 VALUES(p_par_id,   	 	  	  p_endt_cd,		   p_endt_tax,
					p_endt_text01,			  p_endt_text02,	   p_endt_text03,
					p_endt_text04,			  p_endt_text05,	   p_endt_text06,
					p_endt_text07,			  p_endt_text08,	   p_endt_text09,
					p_endt_text10,			  p_endt_text11,	   p_endt_text12,
					p_endt_text13,			  p_endt_text14,	   p_endt_text15,
					p_endt_text16,			  p_endt_text17,	   p_user_id)
		WHEN MATCHED THEN
			 UPDATE SET endt_cd 	= p_endt_cd,
						endt_tax 	= p_endt_tax,
						endt_text01 = p_endt_text01,
						endt_text02 = p_endt_text02,
						endt_text03 = p_endt_text03,
						endt_text04 = p_endt_text04,
						endt_text05 = p_endt_text05,
						endt_text06 = p_endt_text06,
						endt_text07 = p_endt_text07,
						endt_text08 = p_endt_text08,
						endt_text09 = p_endt_text09,
						endt_text10 = p_endt_text10,
						endt_text11 = p_endt_text11,
						endt_text12 = p_endt_text12,
						endt_text13 = p_endt_text13,
						endt_text14 = p_endt_text14,
						endt_text15 = p_endt_text15,
						endt_text16 = p_endt_text16,
						endt_text17 = p_endt_text17,
						user_id		= p_user_id;
   END set_gipi_pack_wendttext;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-13-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  :
  */
    PROCEDURE del_GIPI_PACK_WENDTTEXT(p_pack_par_id         GIPI_PACK_WENDTTEXT.pack_par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_PACK_WENDTTEXT
              WHERE pack_par_id      = p_pack_par_id;
    END;

END GIPI_PACK_WENDTTEXT_PKG;
/


