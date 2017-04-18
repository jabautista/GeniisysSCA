CREATE OR REPLACE PACKAGE CPI.Gipi_Wendttext_Pkg
AS
	/*	Date        Author			Description
    **	==========	===============	============================ 
    **	06.21.2010	mark jm			created package
	  **	01.24.2012	mark jm			change data types to clob to handle html characters
    **  09.03.2012  andrew      replaced the clob, handling of html characters will be done in java           
    */
	TYPE gipi_wendttext_type IS RECORD (
		par_id		gipi_wendttext.par_id%TYPE,
		endt_text	CLOB,
		user_id		gipi_wendttext.user_id%TYPE,
		last_update	gipi_wendttext.last_update%TYPE,
		endt_tax	gipi_wendttext.endt_tax%TYPE,
		endt_text01	gipi_wendttext.endt_text01%TYPE,
		endt_text02	gipi_wendttext.endt_text02%TYPE,
		endt_text03	gipi_wendttext.endt_text03%TYPE,
    endt_text04 gipi_wendttext.endt_text04%TYPE,
    endt_text05 gipi_wendttext.endt_text05%TYPE,
    endt_text06 gipi_wendttext.endt_text06%TYPE,
    endt_text07 gipi_wendttext.endt_text07%TYPE,
    endt_text08 gipi_wendttext.endt_text08%TYPE,
    endt_text09 gipi_wendttext.endt_text09%TYPE,
    endt_text10 gipi_wendttext.endt_text10%TYPE,
    endt_text11 gipi_wendttext.endt_text11%TYPE,
    endt_text12 gipi_wendttext.endt_text12%TYPE,
    endt_text13 gipi_wendttext.endt_text13%TYPE,
    endt_text14 gipi_wendttext.endt_text14%TYPE,
    endt_text15 gipi_wendttext.endt_text15%TYPE,
    endt_text16 gipi_wendttext.endt_text16%TYPE,
    endt_text17 gipi_wendttext.endt_text17%TYPE,
    endt_cd gipi_wendttext.endt_cd%TYPE);
    
    TYPE gipi_wendttext_tab IS TABLE OF gipi_wendttext_type;
    
    FUNCTION get_gipi_wendttext(p_par_id gipi_wendttext.par_id%TYPE)
      RETURN gipi_wendttext_tab PIPELINED;
    
    FUNCTION get_endt_text (p_par_id IN GIPI_WENDTTEXT.par_id%TYPE) RETURN CLOB;
    FUNCTION get_endt_cd (p_par_id IN GIPI_WENDTTEXT.par_id%TYPE) RETURN VARCHAR2;
    FUNCTION get_endt_tax (p_par_id IN GIPI_WENDTTEXT.par_id%TYPE) RETURN VARCHAR2;
    
    Procedure SET_GIPI_WENDTTEXT (
        p_par_id IN GIPI_WENDTTEXT.par_id%TYPE,
        p_endt_text IN GIPI_WENDTTEXT.endt_text%TYPE,
        p_endt_cd IN GIPI_WENDTTEXT.endt_cd%TYPE,
        p_endt_tax IN GIPI_WENDTTEXT.endt_tax%TYPE,
        p_endt_text01 IN GIPI_WENDTTEXT.endt_text01%TYPE,
        p_endt_text02 IN GIPI_WENDTTEXT.endt_text02%TYPE,
        p_endt_text03 IN GIPI_WENDTTEXT.endt_text03%TYPE,
        p_endt_text04 IN GIPI_WENDTTEXT.endt_text04%TYPE,
        p_endt_text05 IN GIPI_WENDTTEXT.endt_text05%TYPE,
        p_endt_text06 IN GIPI_WENDTTEXT.endt_text06%TYPE,
        p_endt_text07 IN GIPI_WENDTTEXT.endt_text07%TYPE, 
        p_endt_text08 IN GIPI_WENDTTEXT.endt_text08%TYPE,
        p_endt_text09 IN GIPI_WENDTTEXT.endt_text09%TYPE,
        p_endt_text10 IN GIPI_WENDTTEXT.endt_text10%TYPE,
        p_endt_text11 IN GIPI_WENDTTEXT.endt_text11%TYPE,
        p_endt_text12 IN GIPI_WENDTTEXT.endt_text12%TYPE,
        p_endt_text13 IN GIPI_WENDTTEXT.endt_text13%TYPE,
        p_endt_text14 IN GIPI_WENDTTEXT.endt_text14%TYPE,
        p_endt_text15 IN GIPI_WENDTTEXT.endt_text15%TYPE,
        p_endt_text16 IN GIPI_WENDTTEXT.endt_text16%TYPE,
        p_endt_text17 IN GIPI_WENDTTEXT.endt_text17%TYPE,
        p_user_id IN GIPI_WENDTTEXT.user_id%TYPE);    
          
END Gipi_Wendttext_Pkg;
/


