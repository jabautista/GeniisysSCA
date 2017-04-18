CREATE OR REPLACE PACKAGE BODY CPI.GIXX_POLGENIN_PKG AS

   FUNCTION get_pol_doc_polgenin
     RETURN pol_doc_polgenin_tab PIPELINED IS

     v_polgenin pol_doc_polgenin_type;

   BEGIN
     FOR i IN (
        SELECT ALL polgenin.extract_id extract_id5,
                   polgenin.gen_info polgenin_gen_info,
                   polgenin.gen_info01 polgenin_gen_info01,
                   polgenin.gen_info02 polgenin_gen_info02,
                   polgenin.gen_info03 polgenin_gen_info03,
                   polgenin.gen_info04 polgenin_gen_info04,
                   polgenin.gen_info05 polgenin_gen_info05,
                   polgenin.gen_info06 polgenin_gen_info06,
                   polgenin.gen_info07 polgenin_gen_info07,
                   polgenin.gen_info08 polgenin_gen_info08,
                   polgenin.gen_info09 polgenin_gen_info09,
                   polgenin.gen_info10 polgenin_gen_info10,
                   polgenin.gen_info11 polgenin_gen_info11,
                   polgenin.gen_info12 polgenin_gen_info12,
                   polgenin.gen_info13 polgenin_gen_info13,
                   polgenin.gen_info14 polgenin_gen_info14,
                   polgenin.gen_info15 polgenin_gen_info15,
                   polgenin.gen_info16 polgenin_gen_info16,
                   polgenin.gen_info17 polgenin_gen_info17,
                   polgenin.first_info polgenin_initial_info,
                   polgenin.initial_info01 polgenin_initial_info01,
                   polgenin.initial_info02 polgenin_initial_info02,
                   polgenin.initial_info03 polgenin_initial_info03,
                   polgenin.initial_info04 polgenin_initial_info04,
                   polgenin.initial_info05 polgenin_initial_info05,
                   polgenin.initial_info06 polgenin_initial_info06,
                   polgenin.initial_info07 polgenin_initial_info07,
                   polgenin.initial_info08 polgenin_initial_info08,
                   polgenin.initial_info09 polgenin_initial_info09,
                   polgenin.initial_info10 polgenin_initial_info10,
                   polgenin.initial_info11 polgenin_initial_info11,
                   polgenin.initial_info12 polgenin_initial_info12,
                   polgenin.initial_info13 polgenin_initial_info13,
                   polgenin.initial_info14 polgenin_initial_info14,
                   polgenin.initial_info15 polgenin_initial_info15,
                   polgenin.initial_info16 polgenin_initial_info16,
                   polgenin.initial_info17 polgenin_initial_info17
              FROM GIXX_POLGENIN polgenin)
     LOOP
       PIPE ROW(v_polgenin);
     END LOOP;
     RETURN;
   END get_pol_doc_polgenin;

END GIXX_POLGENIN_PKG;
/


