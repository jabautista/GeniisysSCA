CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wendttext_Pkg
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.21.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This function returns the endt_text of a particular par_id
    */
    FUNCTION get_endt_text (p_par_id IN GIPI_WENDTTEXT.par_id%TYPE)
    RETURN CLOB
    IS
        v_endt_text CLOB;
    BEGIN
        FOR i IN (
            SELECT endt_text
              FROM GIPI_WENDTTEXT
             WHERE par_id = p_par_id)
        LOOP
            v_endt_text := TO_CLOB(i.endt_text);
            EXIT;
        END LOOP;

        RETURN v_endt_text;
    END get_endt_text;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.21.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This function returns the endt_cd of a particular par_id
    */
    FUNCTION get_endt_cd (p_par_id IN GIPI_WENDTTEXT.par_id%TYPE)
    RETURN VARCHAR2
    IS
        v_endt_cd GIPI_WENDTTEXT.endt_cd%TYPE;
    BEGIN
        FOR i IN (
            SELECT endt_cd
              FROM GIPI_WENDTTEXT
             WHERE par_id = p_par_id)
        LOOP
            v_endt_cd := i.endt_cd;
            EXIT;
        END LOOP;

        RETURN v_endt_cd;
    END get_endt_cd;

    /*
    **  Created by        : Menandro G.C. Robes
    **  Date Created     : June 29, 2010
    **  Reference By     : (GIPIS097 - Endt Item Peril Information)
    **  Description     : This function returns the endt_tax of a particular par_id
    */
    FUNCTION get_endt_tax (p_par_id IN GIPI_WENDTTEXT.par_id%TYPE)
    RETURN VARCHAR2 IS
        v_endt_tax GIPI_WENDTTEXT.endt_tax%TYPE;
    BEGIN
        FOR i IN (
            SELECT endt_tax
              FROM GIPI_WENDTTEXT
             WHERE par_id = p_par_id)
        LOOP
            v_endt_tax := i.endt_tax;
            EXIT;
        END LOOP;

        RETURN v_endt_tax;
    END get_endt_tax;


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
        p_user_id IN GIPI_WENDTTEXT.user_id%TYPE)
    IS
        /*
        **  Created by        : Mark JM
        **  Date Created     : 07.26.2010
        **  Reference By     : (GIPIS031 - Endt Basic Information)
        **  Description     : This procedures inserts/updates record on GIPI_WENDTTEXT
        **                    : based on given parameters
        */
    BEGIN
        DBMS_OUTPUT.PUT_LINE(p_endt_text);
        MERGE INTO GIPI_WENDTTEXT
        USING DUAL ON (par_id = p_par_id )
            WHEN NOT MATCHED THEN
                INSERT (
                    par_id,         endt_text,        endt_cd,         endt_tax,
                    endt_text01,     endt_text02,     endt_text03,     endt_text04,
                    endt_text05,     endt_text06,     endt_text07,     endt_text08,
                    endt_text09,     endt_text10,     endt_text11,     endt_text12,
                    endt_text13,     endt_text14,     endt_text15,     endt_text16,
                    endt_text17,    last_update,    user_id)
                VALUES (
                    p_par_id,         p_endt_text,    p_endt_cd,         p_endt_tax,
                    p_endt_text01,    p_endt_text02,    p_endt_text03,    p_endt_text04,
                    p_endt_text05,    p_endt_text06,    p_endt_text07,    p_endt_text08,
                    p_endt_text09,    p_endt_text10,    p_endt_text11,    p_endt_text12,
                    p_endt_text13,    p_endt_text14,    p_endt_text15,    p_endt_text16,
                    p_endt_text17,    SYSDATE,         p_user_id)
            WHEN MATCHED THEN
                UPDATE SET
                    endt_text    = p_endt_text,
                    endt_cd        = p_endt_cd,
                    endt_tax    = p_endt_tax,
                    endt_text01    = p_endt_text01,
                    endt_text02    = p_endt_text02,
                    endt_text03    = p_endt_text03,
                    endt_text04    = p_endt_text04,
                    endt_text05    = p_endt_text05,
                    endt_text06    = p_endt_text06,
                    endt_text07    = p_endt_text07,
                    endt_text08    = p_endt_text08,
                    endt_text09    = p_endt_text09,
                    endt_text10    = p_endt_text10,
                    endt_text11    = p_endt_text11,
                    endt_text12    = p_endt_text12,
                    endt_text13    = p_endt_text13,
                    endt_text14    = p_endt_text14,
                    endt_text15    = p_endt_text15,
                    endt_text16    = p_endt_text16,
                    endt_text17    = p_endt_text17,
                    last_update    = SYSDATE,
                    user_id        = p_user_id;
    END set_gipi_wendttext;

    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    01.04.2011    mark jm            retrieve records from gipi_wendttext based on given parameter
    **    01.24.2012    mark jm            added escape_value_clob to handle html characters
    */

    FUNCTION get_gipi_wendttext(p_par_id IN gipi_wendttext.par_id%TYPE)
    RETURN gipi_wendttext_tab PIPELINED
    IS
        v_wendttext gipi_wendttext_type;
    BEGIN
        FOR i IN (
            SELECT par_id,         endt_text,         user_id,         last_update,     endt_tax,
                   endt_text01,    endt_text02,    endt_text03,     endt_text04,    endt_text05,
                   endt_text06,    endt_text07,    endt_text08,    endt_text09,    endt_text10,
                   endt_text11,    endt_text12,    endt_text13,    endt_text14,    endt_text15,
                   endt_text16,    endt_text17,    endt_cd
              FROM gipi_wendttext
             WHERE par_id = p_par_id)
        LOOP
            v_wendttext.par_id        := i.par_id;
            v_wendttext.endt_text    := i.endt_text;
            v_wendttext.user_id        := i.user_id;
            v_wendttext.last_update    := i.last_update;
            v_wendttext.endt_tax    := i.endt_tax;
            v_wendttext.endt_text01    := i.endt_text01;
            v_wendttext.endt_text02    := i.endt_text02;
            v_wendttext.endt_text03    := i.endt_text03;
            v_wendttext.endt_text04    := i.endt_text04;
            v_wendttext.endt_text05    := i.endt_text05;
            v_wendttext.endt_text06    := i.endt_text06;
            v_wendttext.endt_text07    := i.endt_text07;
            v_wendttext.endt_text08    := i.endt_text08;
            v_wendttext.endt_text09    := i.endt_text09;
            v_wendttext.endt_text10    := i.endt_text10;
            v_wendttext.endt_text11    := i.endt_text11;
            v_wendttext.endt_text12    := i.endt_text12;
            v_wendttext.endt_text13    := i.endt_text13;
            v_wendttext.endt_text14    := i.endt_text14;
            v_wendttext.endt_text15    := i.endt_text15;
            v_wendttext.endt_text16    := i.endt_text16;
            v_wendttext.endt_text17    := i.endt_text17;
            v_wendttext.endt_cd        := i.endt_cd;

            PIPE ROW(v_wendttext);
        END LOOP;

        RETURN;
    END get_gipi_wendttext;

END Gipi_Wendttext_Pkg;
/


