CREATE OR REPLACE PACKAGE CPI.giis_genin_info_Pkg AS

    TYPE giis_genin_info_type IS RECORD (
		genin_info_cd         giis_genin_info.genin_info_cd%TYPE,
		gen_info01            giis_genin_info.gen_info01%TYPE,
		gen_info02            giis_genin_info.gen_info02%TYPE,
		gen_info03            giis_genin_info.gen_info03%TYPE,
		gen_info04            giis_genin_info.gen_info04%TYPE,
		gen_info05            giis_genin_info.gen_info05%TYPE,
		gen_info06            giis_genin_info.gen_info06%TYPE,
		gen_info07            giis_genin_info.gen_info07%TYPE,
		gen_info08            giis_genin_info.gen_info08%TYPE,
		gen_info09            giis_genin_info.gen_info09%TYPE,
		gen_info10            giis_genin_info.gen_info10%TYPE,
		gen_info11            giis_genin_info.gen_info11%TYPE,
        gen_info12            giis_genin_info.gen_info12%TYPE,
        gen_info13            giis_genin_info.gen_info13%TYPE,
        gen_info14            giis_genin_info.gen_info14%TYPE,
        gen_info15            giis_genin_info.gen_info15%TYPE,
        gen_info16            giis_genin_info.gen_info16%TYPE,
        gen_info17            giis_genin_info.gen_info17%TYPE,
        initial_info01        giis_genin_info.initial_info01%TYPE,
        initial_info02        giis_genin_info.initial_info02%TYPE,
        initial_info03        giis_genin_info.initial_info03%TYPE,
        initial_info04        giis_genin_info.initial_info04%TYPE,
        initial_info05        giis_genin_info.initial_info05%TYPE,
        initial_info06        giis_genin_info.initial_info06%TYPE,
        initial_info07        giis_genin_info.initial_info07%TYPE,
        initial_info08        giis_genin_info.initial_info08%TYPE,
        initial_info09        giis_genin_info.initial_info09%TYPE,
        initial_info10        giis_genin_info.initial_info10%TYPE,
        initial_info11        giis_genin_info.initial_info11%TYPE,
        initial_info12        giis_genin_info.initial_info12%TYPE,
        initial_info13        giis_genin_info.initial_info13%TYPE,
        initial_info14        giis_genin_info.initial_info14%TYPE,
        initial_info15        giis_genin_info.initial_info15%TYPE,
        initial_info16        giis_genin_info.initial_info16%TYPE,
        initial_info17        giis_genin_info.initial_info17%TYPE,
        remarks               giis_genin_info.remarks%TYPE,
        user_id               giis_genin_info.user_id%TYPE,
        last_update           giis_genin_info.last_update%TYPE,
        genin_info_title      giis_genin_info.genin_info_title%TYPE
        );
     
    TYPE giis_genin_info_tab IS TABLE OF giis_genin_info_type; 
     
    FUNCTION get_initial_info_list (p_keyword        VARCHAR2)
    RETURN giis_genin_info_tab PIPELINED;
         
    FUNCTION get_general_info_list (p_keyword        VARCHAR2)
    RETURN giis_genin_info_tab PIPELINED;
     
END giis_genin_info_Pkg;
/


