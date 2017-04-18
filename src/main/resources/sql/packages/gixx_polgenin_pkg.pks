CREATE OR REPLACE PACKAGE CPI.GIXX_POLGENIN_PKG AS

    TYPE pol_doc_polgenin_type IS RECORD (
        extract_id5             GIXX_POLGENIN.extract_id%TYPE,
        polgenin_gen_info       CLOB, --GIXX_POLGENIN.gen_info%TYPE,
        polgenin_gen_info01     GIXX_POLGENIN.gen_info01%TYPE,
        polgenin_gen_info02     GIXX_POLGENIN.gen_info02%TYPE,
        polgenin_gen_info03     GIXX_POLGENIN.gen_info03%TYPE,
        polgenin_gen_info04     GIXX_POLGENIN.gen_info04%TYPE,
        polgenin_gen_info05     GIXX_POLGENIN.gen_info05%TYPE,
        polgenin_gen_info06     GIXX_POLGENIN.gen_info06%TYPE,
        polgenin_gen_info07     GIXX_POLGENIN.gen_info07%TYPE,
        polgenin_gen_info08     GIXX_POLGENIN.gen_info08%TYPE,
        polgenin_gen_info09     GIXX_POLGENIN.gen_info09%TYPE,
        polgenin_gen_info10     GIXX_POLGENIN.gen_info10%TYPE,
        polgenin_gen_info11     GIXX_POLGENIN.gen_info11%TYPE,
        polgenin_gen_info12     GIXX_POLGENIN.gen_info12%TYPE,
        polgenin_gen_info13     GIXX_POLGENIN.gen_info13%TYPE,
        polgenin_gen_info14     GIXX_POLGENIN.gen_info14%TYPE,
        polgenin_gen_info15     GIXX_POLGENIN.gen_info15%TYPE,
        polgenin_gen_info16     GIXX_POLGENIN.gen_info16%TYPE,
        polgenin_gen_info17     GIXX_POLGENIN.gen_info17%TYPE,
        polgenin_initial_info   GIXX_POLGENIN.first_info%TYPE,
        polgenin_initial_info01 GIXX_POLGENIN.initial_info01%TYPE,
        polgenin_initial_info02 GIXX_POLGENIN.initial_info02%TYPE,
        polgenin_initial_info03 GIXX_POLGENIN.initial_info03%TYPE,
        polgenin_initial_info04 GIXX_POLGENIN.initial_info04%TYPE,
        polgenin_initial_info05 GIXX_POLGENIN.initial_info05%TYPE,
        polgenin_initial_info06 GIXX_POLGENIN.initial_info06%TYPE,
        polgenin_initial_info07 GIXX_POLGENIN.initial_info07%TYPE,
        polgenin_initial_info08 GIXX_POLGENIN.initial_info08%TYPE,
        polgenin_initial_info09 GIXX_POLGENIN.initial_info09%TYPE,
        polgenin_initial_info10 GIXX_POLGENIN.initial_info10%TYPE,
        polgenin_initial_info11 GIXX_POLGENIN.initial_info11%TYPE,
        polgenin_initial_info12 GIXX_POLGENIN.initial_info12%TYPE,
        polgenin_initial_info13 GIXX_POLGENIN.initial_info13%TYPE,
        polgenin_initial_info14 GIXX_POLGENIN.initial_info14%TYPE,
        polgenin_initial_info15 GIXX_POLGENIN.initial_info15%TYPE,
        polgenin_initial_info16 GIXX_POLGENIN.initial_info16%TYPE,
        polgenin_initial_info17 GIXX_POLGENIN.initial_info17%TYPE
        );
    
    TYPE pol_doc_polgenin_tab IS TABLE OF pol_doc_polgenin_type;
    
    FUNCTION get_pol_doc_polgenin RETURN pol_doc_polgenin_tab PIPELINED;

END GIXX_POLGENIN_PKG;
/


