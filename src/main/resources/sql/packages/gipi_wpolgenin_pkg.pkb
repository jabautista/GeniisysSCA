CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wpolgenin_Pkg AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    02.03.2010    Jerome Orio        This retrieves the Initial and General Information in other details.
    **                                Reference By : (GIPIS002 - Basic Information for other details)
    **    01.24.2012    mark jm            added escape_value_clob to handle html characters
    */
  FUNCTION get_gipi_wpolgenin (p_par_id        GIPI_WPOLGENIN.par_id%TYPE)
    RETURN gipi_wpolgenin_tab PIPELINED IS

      v_wpolgenin            gipi_wpolgenin_type;

  BEGIN
    FOR i IN (
        SELECT par_id,         first_info,     agreed_tag,     genin_info_cd,
               gen_info01,        gen_info02,        gen_info03,        gen_info04,
               gen_info05,        gen_info06,        gen_info07,        gen_info08,
               gen_info09,        gen_info10,        gen_info11,        gen_info12,
               gen_info13,        gen_info14,        gen_info15,        gen_info16,
               gen_info17,        initial_info01, initial_info02, initial_info03,
               initial_info04, initial_info05, initial_info06, initial_info07,
               initial_info08, initial_info09, initial_info10, initial_info11,
               initial_info12, initial_info13, initial_info14, initial_info15,
               initial_info16, initial_info17, gen_info/*,
               (INITIAL_INFO01 ||
                  INITIAL_INFO02 ||
                 INITIAL_INFO03 ||
                 INITIAL_INFO04 ||
                 INITIAL_INFO05 ||
                 INITIAL_INFO06 ||
                 INITIAL_INFO07 ||
                 INITIAL_INFO08 ||
                 INITIAL_INFO09 ||
                 INITIAL_INFO10 ||
                 INITIAL_INFO11 ||
                 INITIAL_INFO12 ||
                  INITIAL_INFO13 ||
                 INITIAL_INFO14 ||
                 INITIAL_INFO15 ||
                 INITIAL_INFO16 ||
                 INITIAL_INFO17) dsp_init_info,
                (GEN_INFO01 ||
                 GEN_INFO02 ||
                 GEN_INFO03 ||
                 GEN_INFO04 ||
                 GEN_INFO05 ||
                 GEN_INFO06 ||
                 GEN_INFO07 ||
                 GEN_INFO08 ||
                 GEN_INFO09 ||
                 GEN_INFO10 ||
                 GEN_INFO11 ||
                 GEN_INFO12 ||
                 GEN_INFO13 ||
                 GEN_INFO14 ||
                 GEN_INFO15 ||
                 GEN_INFO16 ||
                 GEN_INFO17) dsp_gen_info*/
          FROM GIPI_WPOLGENIN
          WHERE par_id = p_par_id)
    LOOP
        v_wpolgenin.par_id                := i.par_id;
        v_wpolgenin.first_info            := i.first_info;
        v_wpolgenin.agreed_tag            := i.agreed_tag;
        v_wpolgenin.genin_info_cd         := i.genin_info_cd; -- Nica 09.13.2012 - removed escape_value_clob for it is already handled in java
        v_wpolgenin.gen_info              := i.gen_info;  --escape_value_clob(i.gen_info);
        v_wpolgenin.gen_info01            := i.gen_info01;--escape_value_clob(i.gen_info01);
        v_wpolgenin.gen_info02            := i.gen_info02;--escape_value_clob(i.gen_info02);
        v_wpolgenin.gen_info03            := i.gen_info03;--escape_value_clob(i.gen_info03);
        v_wpolgenin.gen_info04            := i.gen_info04;--escape_value_clob(i.gen_info04);
        v_wpolgenin.gen_info05            := i.gen_info05;--escape_value_clob(i.gen_info05);
        v_wpolgenin.gen_info06            := i.gen_info06;--escape_value_clob(i.gen_info06);
        v_wpolgenin.gen_info07            := i.gen_info07;--escape_value_clob(i.gen_info07);
        v_wpolgenin.gen_info08            := i.gen_info08;--escape_value_clob(i.gen_info08);
        v_wpolgenin.gen_info09            := i.gen_info09;--escape_value_clob(i.gen_info09);
        v_wpolgenin.gen_info10            := i.gen_info10;--escape_value_clob(i.gen_info10);
        v_wpolgenin.gen_info11            := i.gen_info11;--escape_value_clob(i.gen_info11);
        v_wpolgenin.gen_info12            := i.gen_info12;--escape_value_clob(i.gen_info12);
        v_wpolgenin.gen_info13            := i.gen_info13;--escape_value_clob(i.gen_info13);
        v_wpolgenin.gen_info14            := i.gen_info14;--escape_value_clob(i.gen_info14);
        v_wpolgenin.gen_info15            := i.gen_info15;--escape_value_clob(i.gen_info15);
        v_wpolgenin.gen_info16            := i.gen_info16;--escape_value_clob(i.gen_info16);
        v_wpolgenin.gen_info17            := i.gen_info17;--escape_value_clob(i.gen_info17);
        v_wpolgenin.initial_info01        := i.initial_info01;--escape_value_clob(i.initial_info01);
        v_wpolgenin.initial_info02        := i.initial_info02;--escape_value_clob(i.initial_info02);
        v_wpolgenin.initial_info03        := i.initial_info03;--escape_value_clob(i.initial_info03);
        v_wpolgenin.initial_info04        := i.initial_info04;--escape_value_clob(i.initial_info04);
        v_wpolgenin.initial_info05        := i.initial_info05;--escape_value_clob(i.initial_info05);
        v_wpolgenin.initial_info06        := i.initial_info06;--escape_value_clob(i.initial_info06);
        v_wpolgenin.initial_info07        := i.initial_info07;--escape_value_clob(i.initial_info07);
        v_wpolgenin.initial_info08        := i.initial_info08;--escape_value_clob(i.initial_info08);
        v_wpolgenin.initial_info09        := i.initial_info09;--escape_value_clob(i.initial_info09);
        v_wpolgenin.initial_info10        := i.initial_info10;--escape_value_clob(i.initial_info10);
        v_wpolgenin.initial_info11        := i.initial_info11;--escape_value_clob(i.initial_info11);
        v_wpolgenin.initial_info12        := i.initial_info12;--escape_value_clob(i.initial_info12);
        v_wpolgenin.initial_info13        := i.initial_info13;--escape_value_clob(i.initial_info13);
        v_wpolgenin.initial_info14        := i.initial_info14;--escape_value_clob(i.initial_info14);
        v_wpolgenin.initial_info15        := i.initial_info15;--escape_value_clob(i.initial_info15);
        v_wpolgenin.initial_info16        := i.initial_info16;--escape_value_clob(i.initial_info16);
        v_wpolgenin.initial_info17        := i.initial_info17;--escape_value_clob(i.initial_info17);

        --v_wpolgenin.dsp_initial_info         := i.dsp_init_info;
        --v_wpolgenin.dsp_gen_info             := i.dsp_gen_info;

      PIPE ROW(v_wpolgenin);
    END LOOP;

  END get_gipi_wpolgenin;

  /*
  **  Created by   :  Jerome Orio
  **  Date Created :  February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information for other details)
  **  Description  : This Insert/Update the Initial and General Information in other details.
  */
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
     v_user_id            IN  VARCHAR2) IS

  BEGIN

      MERGE INTO GIPI_WPOLGENIN
     USING DUAL ON ( par_id = v_par_id )
       WHEN NOT MATCHED THEN
         INSERT ( par_id,       first_info,      agreed_tag,   genin_info_cd,
                  gen_info01, gen_info02, gen_info03, gen_info04,
                   gen_info05, gen_info06, gen_info07, gen_info08,
                  gen_info09, gen_info10, gen_info11, gen_info12,
                  gen_info13, gen_info14, gen_info15, gen_info16,
                  gen_info17,
                  initial_info01, initial_info02, initial_info03,
                  initial_info04, initial_info05, initial_info06,
                  initial_info07, initial_info08, initial_info09,
                  initial_info10, initial_info11, initial_info12,
                  initial_info13, initial_info14, initial_info15,
                  initial_info16, initial_info17,
                  last_update,       user_id)
         VALUES    ( v_par_id,     v_first_info,    v_agreed_tag, v_genin_info_cd,
                    v_gen_info01,
                   v_gen_info02,
                  v_gen_info03,
                  v_gen_info04,
                  v_gen_info05,
                  v_gen_info06,
                  v_gen_info07,
                  v_gen_info08,
                  v_gen_info09,
                  v_gen_info10,
                  v_gen_info11,
                  v_gen_info12,
                  v_gen_info13,
                  v_gen_info14,
                  v_gen_info15,
                  v_gen_info16,
                  v_gen_info17,
                  v_init_info01,
                  v_init_info02,
                  v_init_info03,
                  v_init_info04,
                  v_init_info05,
                  v_init_info06,
                  v_init_info07,
                  v_init_info08,
                  v_init_info09,
                  v_init_info10,
                  v_init_info11,
                  v_init_info12,
                  v_init_info13,
                  v_init_info14,
                  v_init_info15,
                  v_init_info16,
                  v_init_info17,
                  SYSDATE, v_user_id)
       WHEN MATCHED THEN
         UPDATE SET first_info            = v_first_info,
                    agreed_tag            = v_agreed_tag,
                    genin_info_cd          = v_genin_info_cd,
                    gen_info01            = v_gen_info01,
                    gen_info02            = v_gen_info02,
                    gen_info03            = v_gen_info03,
                    gen_info04            = v_gen_info04,
                    gen_info05            = v_gen_info05,
                    gen_info06            = v_gen_info06,
                    gen_info07            = v_gen_info07,
                    gen_info08            = v_gen_info08,
                    gen_info09            = v_gen_info09,
                    gen_info10            = v_gen_info10,
                    gen_info11            = v_gen_info11,
                    gen_info12            = v_gen_info12,
                    gen_info13            = v_gen_info13,
                    gen_info14            = v_gen_info14,
                    gen_info15            = v_gen_info15,
                    gen_info16            = v_gen_info16,
                    gen_info17              = v_gen_info17,
                    initial_info01        = v_init_info01,
                    initial_info02        = v_init_info02,
                    initial_info03        = v_init_info03,
                    initial_info04        = v_init_info04,
                    initial_info05        = v_init_info05,
                    initial_info06        = v_init_info06,
                    initial_info07        = v_init_info07,
                    initial_info08        = v_init_info08,
                    initial_info09        = v_init_info09,
                    initial_info10        = v_init_info10,
                    initial_info11        = v_init_info11,
                    initial_info12        = v_init_info12,
                    initial_info13        = v_init_info13,
                    initial_info14        = v_init_info14,
                    initial_info15        = v_init_info15,
                    initial_info16        = v_init_info16,
                    initial_info17        = v_init_info17,
                    last_update            = SYSDATE,
                    user_id                = v_user_id;

    --COMMIT;
  END set_gipi_wpolgenin;

  /*
  **  Created by   :  Jerome Orio
  **  Date Created :  February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information for other details)
  **  Description  : This Idelete the Initial and General Information in other details.
  */
  Procedure del_gipi_wpolgenin (p_par_id        GIPI_WPOLGENIN.par_id%TYPE)
  IS
  BEGIN
    FOR a IN (SELECT 1
                FROM GIPI_WPOLGENIN
               WHERE par_id = p_par_id)
    LOOP
        DELETE FROM GIPI_WPOLGENIN
               WHERE par_id = p_par_id;
    END LOOP;
    COMMIT;
  END del_gipi_wpolgenin;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.21.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This function returns the gen_info of a particular par_id
    */
    FUNCTION get_gen_info(p_par_id IN GIPI_WPOLGENIN.par_id%TYPE)
    RETURN VARCHAR2
    IS
        v_gen_info GIPI_WPOLGENIN.gen_info%TYPE;
    BEGIN
        FOR i IN (
            SELECT gen_info
              FROM GIPI_WPOLGENIN
             WHERE par_id = p_par_id)
        LOOP
            v_gen_info := i.gen_info;
            EXIT;
        END LOOP;

        RETURN v_gen_info;
    END get_gen_info;

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
        p_user_id            IN GIPI_WPOLGENIN.user_id%TYPE)
    IS
        /*
        **  Created by        : Mark JM
        **  Date Created     : 07.26.2010
        **  Reference By     : (GIPIS031 - Endt Basic Information)
        **  Description     : This procedure inserts/updates record on GIPI_WPOLGENIN
        **                    : based on the given parameters
        */
    BEGIN
        MERGE INTO GIPI_WPOLGENIN
        USING DUAL ON (par_id = p_par_id )
            WHEN NOT MATCHED THEN
                INSERT (
                    par_id,     gen_info,    genin_info_cd,
                    gen_info01, gen_info02, gen_info03, gen_info04,
                    gen_info05, gen_info06, gen_info07, gen_info08,
                    gen_info09, gen_info10, gen_info11, gen_info12,
                    gen_info13, gen_info14, gen_info15, gen_info16,
                    gen_info17,
                    last_update,       user_id)
                VALUES    (
                    p_par_id,         p_gen_info,        p_genin_info_cd,
                    p_gen_info01,    p_gen_info02,    p_gen_info03,    p_gen_info04,
                    p_gen_info05,    p_gen_info06,    p_gen_info07,    p_gen_info08,
                    p_gen_info09,    p_gen_info10,    p_gen_info11,    p_gen_info12,
                    p_gen_info13,    p_gen_info14,    p_gen_info15,    p_gen_info16,
                    p_gen_info17,
                    SYSDATE,         p_user_id)
            WHEN MATCHED THEN
                UPDATE SET
                    gen_info            = p_gen_info,
                    genin_info_cd          = p_genin_info_cd,
                    gen_info01            = p_gen_info01,
                    gen_info02            = p_gen_info02,
                    gen_info03            = p_gen_info03,
                    gen_info04            = p_gen_info04,
                    gen_info05            = p_gen_info05,
                    gen_info06            = p_gen_info06,
                    gen_info07            = p_gen_info07,
                    gen_info08            = p_gen_info08,
                    gen_info09            = p_gen_info09,
                    gen_info10            = p_gen_info10,
                    gen_info11            = p_gen_info11,
                    gen_info12            = p_gen_info12,
                    gen_info13            = p_gen_info13,
                    gen_info14            = p_gen_info14,
                    gen_info15            = p_gen_info15,
                    gen_info16            = p_gen_info16,
                    gen_info17              = p_gen_info17,
                    last_update            = SYSDATE,
                    user_id                = p_user_id;
    END set_gipi_wpolgenin;

END Gipi_Wpolgenin_Pkg;
/


