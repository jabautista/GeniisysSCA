CREATE OR REPLACE PACKAGE BODY CPI.giis_genin_info_Pkg AS    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    01.10.2011    Jerome Orio     INITIAL_INFO record group for initial information 
    **                                Reference By  : (GIPIS002 - Basic Information)
    **    01.05.2012    mark jm            added escape_value_clob
    **    11.08.2012    andrew          removed escape_value_clob, special characters will be handled in java
    **
    */
    FUNCTION get_initial_info_list (p_keyword        VARCHAR2)
    RETURN giis_genin_info_tab PIPELINED IS
      v_list   giis_genin_info_type;
    BEGIN
        FOR i IN (
             SELECT genin_info_cd,  genin_info_title, initial_info01, 
                    initial_info02, initial_info03,   initial_info04, initial_info05,
                    initial_info06, initial_info07,   initial_info08, initial_info09,
                    initial_info10, initial_info11,   initial_info12, initial_info13,
                    initial_info14, initial_info15,   initial_info16, initial_info17
               FROM giis_genin_info
              WHERE initial_info01 IS NOT NULL
              	AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
                AND (genin_info_cd LIKE NVL(UPPER(p_keyword),'%')
                 OR genin_info_title LIKE NVL(UPPER(p_keyword),'%')
                 OR initial_info01 LIKE NVL(UPPER(p_keyword),'%')))
        LOOP
            v_list.genin_info_cd         := i.genin_info_cd;
            v_list.genin_info_title      := i.genin_info_title;                          
            v_list.initial_info01        := i.initial_info01;
            v_list.initial_info02        := i.initial_info02;
            v_list.initial_info03        := i.initial_info03;
            v_list.initial_info04        := i.initial_info04;
            v_list.initial_info05        := i.initial_info05;
            v_list.initial_info06        := i.initial_info06;
            v_list.initial_info07        := i.initial_info07;
            v_list.initial_info08        := i.initial_info08;
            v_list.initial_info09        := i.initial_info09;
            v_list.initial_info10        := i.initial_info10;
            v_list.initial_info11        := i.initial_info11;
            v_list.initial_info12        := i.initial_info12;
            v_list.initial_info13        := i.initial_info13;
            v_list.initial_info14        := i.initial_info14;
            v_list.initial_info15        := i.initial_info15;
            v_list.initial_info16        := i.initial_info16;
            v_list.initial_info17        := i.initial_info17;
          PIPE ROW(v_list);
        END LOOP;
    END;   
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    01.10.2011    Jerome Orio     GEN_INFO record group for initial information 
    **                                Reference By  : (GIPIS002 - Basic Information)
    **    01.05.2012    mark jm            added escape_value_clob
    **    11.08.2012    andrew          removed escape_value_clob, special characters will be handled in java
    */
    FUNCTION get_general_info_list (p_keyword        VARCHAR2)
    RETURN giis_genin_info_tab PIPELINED IS
      v_list   giis_genin_info_type;
    BEGIN
        FOR i IN (
             SELECT genin_info_cd, genin_info_title, gen_info01, gen_info02,
                    gen_info03, gen_info04, gen_info05, gen_info06, gen_info07, gen_info08,
                    gen_info09, gen_info10, gen_info11, gen_info12, gen_info13, gen_info14,
                    gen_info15, gen_info16, gen_info17
               FROM giis_genin_info
              WHERE gen_info01 IS NOT NULL
                AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
                AND (genin_info_cd LIKE NVL(UPPER(p_keyword),'%')
                 OR genin_info_title LIKE NVL(UPPER(p_keyword),'%')
                 OR gen_info01 LIKE NVL(UPPER(p_keyword),'%')))
        LOOP
            v_list.genin_info_cd        := i.genin_info_cd;
            v_list.genin_info_title     := i.genin_info_title;                          
            v_list.gen_info01           := i.gen_info01;
            v_list.gen_info02           := i.gen_info02;
            v_list.gen_info03           := i.gen_info03;
            v_list.gen_info04           := i.gen_info04;
            v_list.gen_info05           := i.gen_info05;
            v_list.gen_info06           := i.gen_info06;
            v_list.gen_info07           := i.gen_info07;
            v_list.gen_info08           := i.gen_info08;
            v_list.gen_info09           := i.gen_info09;
            v_list.gen_info10           := i.gen_info10;
            v_list.gen_info11           := i.gen_info11;
            v_list.gen_info12           := i.gen_info12;
            v_list.gen_info13           := i.gen_info13;
            v_list.gen_info14           := i.gen_info14;
            v_list.gen_info15           := i.gen_info15;
            v_list.gen_info16           := i.gen_info16;
            v_list.gen_info17           := i.gen_info17;
          PIPE ROW(v_list);
        END LOOP;
    END;   
    
END giis_genin_info_Pkg;
/


