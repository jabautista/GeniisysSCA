CREATE OR REPLACE PACKAGE CPI.Gipi_Wpolgenin_Pkg AS

	/*	Date        Author			Description
    **	==========	===============	============================
    **	02.03.2010	Jerome Orio		created package
	**	01.24.2012	mark jm			change data types to clob to handle html characters
    */
	TYPE gipi_wpolgenin_type IS RECORD (
		par_id                GIPI_WPOLGENIN.par_id%TYPE,
		gen_info            CLOB,--GIPI_WPOLGENIN.gen_info%TYPE,   /* data type not supported by pipelined function*/  
		first_info            GIPI_WPOLGENIN.first_info%TYPE,
		agreed_tag            GIPI_WPOLGENIN.agreed_tag%TYPE,
		genin_info_cd          GIPI_WPOLGENIN.genin_info_cd%TYPE,
		gen_info01            CLOB,--GIPI_WPOLGENIN.gen_info01%TYPE,
        gen_info02            CLOB,--GIPI_WPOLGENIN.gen_info02%TYPE,
        gen_info03            CLOB,--GIPI_WPOLGENIN.gen_info03%TYPE,
        gen_info04            CLOB,--GIPI_WPOLGENIN.gen_info04%TYPE,
        gen_info05            CLOB,--GIPI_WPOLGENIN.gen_info05%TYPE,
        gen_info06            CLOB,--GIPI_WPOLGENIN.gen_info06%TYPE,
        gen_info07            CLOB,--GIPI_WPOLGENIN.gen_info07%TYPE,
        gen_info08            CLOB,--GIPI_WPOLGENIN.gen_info08%TYPE,
        gen_info09            CLOB,--GIPI_WPOLGENIN.gen_info09%TYPE,
        gen_info10            CLOB,--GIPI_WPOLGENIN.gen_info10%TYPE,
        gen_info11            CLOB,--GIPI_WPOLGENIN.gen_info11%TYPE,
        gen_info12            CLOB,--GIPI_WPOLGENIN.gen_info12%TYPE,
        gen_info13            CLOB,--GIPI_WPOLGENIN.gen_info13%TYPE,
        gen_info14            CLOB,--GIPI_WPOLGENIN.gen_info14%TYPE,
        gen_info15            CLOB,--GIPI_WPOLGENIN.gen_info15%TYPE,
        gen_info16            CLOB,--GIPI_WPOLGENIN.gen_info16%TYPE,
        gen_info17            CLOB,--GIPI_WPOLGENIN.gen_info17%TYPE,
        initial_info01        CLOB,--GIPI_WPOLGENIN.initial_info01%TYPE,
        initial_info02        CLOB,--GIPI_WPOLGENIN.initial_info02%TYPE,
        initial_info03        CLOB,--GIPI_WPOLGENIN.initial_info03%TYPE,
        initial_info04        CLOB,--GIPI_WPOLGENIN.initial_info04%TYPE,
        initial_info05        CLOB,--GIPI_WPOLGENIN.initial_info05%TYPE,
        initial_info06        CLOB,--GIPI_WPOLGENIN.initial_info06%TYPE,
        initial_info07        CLOB,--GIPI_WPOLGENIN.initial_info07%TYPE,
        initial_info08        CLOB,--GIPI_WPOLGENIN.initial_info08%TYPE,
        initial_info09        CLOB,--GIPI_WPOLGENIN.initial_info09%TYPE,
        initial_info10        CLOB,--GIPI_WPOLGENIN.initial_info10%TYPE,
        initial_info11        CLOB,--GIPI_WPOLGENIN.initial_info11%TYPE,
        initial_info12        CLOB,--GIPI_WPOLGENIN.initial_info12%TYPE,
        initial_info13        CLOB,--GIPI_WPOLGENIN.initial_info13%TYPE,
        initial_info14        CLOB,--GIPI_WPOLGENIN.initial_info14%TYPE,
        initial_info15        CLOB,--GIPI_WPOLGENIN.initial_info15%TYPE,
        initial_info16        CLOB,--GIPI_WPOLGENIN.initial_info16%TYPE,
        initial_info17        CLOB,--GIPI_WPOLGENIN.initial_info17%TYPE,
        dsp_initial_info              VARCHAR2(32767),
        dsp_gen_info                   VARCHAR2(32767));
     
  TYPE gipi_wpolgenin_tab IS TABLE OF gipi_wpolgenin_type;

  
  FUNCTION get_gipi_wpolgenin (p_par_id        GIPI_WPOLGENIN.par_id%TYPE)
    RETURN gipi_wpolgenin_tab PIPELINED;

  Procedure set_gipi_wpolgenin (
     v_par_id            IN  GIPI_WPOLGENIN.par_id%TYPE,
     v_first_info        IN  GIPI_WPOLGENIN.first_info%TYPE,
     v_agreed_tag        IN  GIPI_WPOLGENIN.agreed_tag%TYPE,
     v_genin_info_cd      IN  GIPI_WPOLGENIN.genin_info_cd%TYPE,
     v_init_info01        IN  VARCHAR2,
     v_init_info02        IN  VARCHAR2,
     v_init_info03        IN  VARCHAR2,
     v_init_info04        IN  VARCHAR2,
     v_init_info05        IN  VARCHAR2,
     v_init_info06        IN  VARCHAR2,
     v_init_info07        IN  VARCHAR2,
     v_init_info08        IN  VARCHAR2,
     v_init_info09        IN  VARCHAR2,
     v_init_info10        IN  VARCHAR2,
     v_init_info11        IN  VARCHAR2,
     v_init_info12        IN  VARCHAR2,
     v_init_info13        IN  VARCHAR2,
     v_init_info14        IN  VARCHAR2,
     v_init_info15        IN  VARCHAR2,
     v_init_info16        IN  VARCHAR2,
     v_init_info17        IN  VARCHAR2,
     v_gen_info01         IN  VARCHAR2,
     v_gen_info02         IN  VARCHAR2,
     v_gen_info03         IN  VARCHAR2,
     v_gen_info04         IN  VARCHAR2,
     v_gen_info05         IN  VARCHAR2,
     v_gen_info06         IN  VARCHAR2,
     v_gen_info07         IN  VARCHAR2,
     v_gen_info08         IN  VARCHAR2,
     v_gen_info09         IN  VARCHAR2,
     v_gen_info10         IN  VARCHAR2,
     v_gen_info11         IN  VARCHAR2,
     v_gen_info12         IN  VARCHAR2,
     v_gen_info13         IN  VARCHAR2,
     v_gen_info14         IN  VARCHAR2,
     v_gen_info15         IN  VARCHAR2,
     v_gen_info16         IN  VARCHAR2,
     v_gen_info17         IN  VARCHAR2,
     v_user_id            IN  VARCHAR2);    
  
  Procedure del_gipi_wpolgenin (p_par_id   GIPI_WPOLGENIN.par_id%TYPE); 
  
    FUNCTION get_gen_info(p_par_id IN GIPI_WPOLGENIN.par_id%TYPE) RETURN VARCHAR2;
    
    Procedure set_gipi_wpolgenin (
        p_par_id            IN GIPI_WPOLGENIN.par_id%TYPE,
        p_gen_info            IN GIPI_WPOLGENIN.gen_info%TYPE,        
        p_genin_info_cd        IN GIPI_WPOLGENIN.genin_info_cd%TYPE,        
        p_gen_info01         IN GIPI_WPOLGENIN.gen_info01%TYPE,
        p_gen_info02         IN GIPI_WPOLGENIN.gen_info02%TYPE,
        p_gen_info03         IN GIPI_WPOLGENIN.gen_info03%TYPE,
        p_gen_info04         IN GIPI_WPOLGENIN.gen_info04%TYPE,
        p_gen_info05         IN GIPI_WPOLGENIN.gen_info05%TYPE,
        p_gen_info06         IN GIPI_WPOLGENIN.gen_info06%TYPE,
        p_gen_info07         IN GIPI_WPOLGENIN.gen_info07%TYPE,
        p_gen_info08         IN GIPI_WPOLGENIN.gen_info08%TYPE,
        p_gen_info09         IN GIPI_WPOLGENIN.gen_info09%TYPE,
        p_gen_info10         IN GIPI_WPOLGENIN.gen_info10%TYPE,
        p_gen_info11         IN GIPI_WPOLGENIN.gen_info11%TYPE,
        p_gen_info12         IN GIPI_WPOLGENIN.gen_info12%TYPE,
        p_gen_info13         IN GIPI_WPOLGENIN.gen_info13%TYPE,
        p_gen_info14         IN GIPI_WPOLGENIN.gen_info14%TYPE,
        p_gen_info15         IN GIPI_WPOLGENIN.gen_info15%TYPE,
        p_gen_info16         IN GIPI_WPOLGENIN.gen_info16%TYPE,
        p_gen_info17         IN GIPI_WPOLGENIN.gen_info17%TYPE,
        p_user_id            IN GIPI_WPOLGENIN.user_id%TYPE);    
        
END Gipi_Wpolgenin_Pkg;
/


