CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wmcacc_Pkg AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    02.03.2010    Jerome Orio        created get_Gipi_WMcAcc
    **    03.12.2010    mark jm            created get_Gipi_WMcAcc_1
    **    03.12.2010    mark jm            created set_Gipi_WMcAcc_1
    **    03.04.2010    mark jm            created del_gipi_wmcacc
    **    03.12.2010    mark jm            created del_gipi_wmcacc_1
    **    06.01.2010    mark jm            created del_gipi_wmcacc
    **    03.21.2011    mark jm            created get_gipi_wmcacc_pack_pol
    **    09.02.2011    mark jm            created get_gipi_wmcacc_tg
    */

    FUNCTION get_Gipi_WMcAcc (p_par_id         GIPI_WMCACC.par_id%TYPE,
        p_item_no         GIPI_WMCACC.item_no%TYPE)
    RETURN get_Gipi_WMcAcc_tab PIPELINED IS
        v_Gipi_WMcAcc                   get_Gipi_WMcAcc_type;
    BEGIN
        FOR a IN (
            SELECT par_id,  item_no, accessory_cd,
                   acc_amt, delete_sw, user_id
              FROM GIPI_WMCACC
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_Gipi_WMcAcc.par_id        := a.par_id;
            v_Gipi_WMcAcc.item_no        := a.item_no;
            v_Gipi_WMcAcc.accessory_cd    := a.accessory_cd;
            v_Gipi_WMcAcc.acc_amt        := a.acc_amt;
            v_Gipi_WMcAcc.delete_sw        := a.delete_sw;
            v_Gipi_WMcAcc.user_id        := a.user_id;

            B520_Post_Query_Gipis010(a.accessory_cd, v_Gipi_WMcAcc.accessory_desc);

            PIPE ROW(v_Gipi_WMcAcc);
        END LOOP;
        RETURN;
    END get_Gipi_WMcAcc;

    FUNCTION get_Gipi_WMcAcc_1 (p_par_id         GIPI_WMCACC.par_id%TYPE)
    RETURN get_Gipi_WMcAcc_tab PIPELINED IS
        v_Gipi_WMcAcc                   get_Gipi_WMcAcc_type;
    BEGIN
        FOR a IN (
            SELECT par_id,  item_no, accessory_cd,
                   acc_amt, delete_sw, user_id
              FROM GIPI_WMCACC
             WHERE par_id = p_par_id)
        LOOP
            v_Gipi_WMcAcc.par_id        := a.par_id;
            v_Gipi_WMcAcc.item_no        := a.item_no;
            v_Gipi_WMcAcc.accessory_cd    := a.accessory_cd;
            v_Gipi_WMcAcc.acc_amt        := a.acc_amt;
            v_Gipi_WMcAcc.delete_sw        := a.delete_sw;
            v_Gipi_WMcAcc.user_id        := a.user_id;

            B520_Post_Query_Gipis010(a.accessory_cd, v_Gipi_WMcAcc.accessory_desc);

            PIPE ROW(v_Gipi_WMcAcc);
        END LOOP;
        RETURN;
    END get_Gipi_WMcAcc_1;

    Procedure set_Gipi_WMcAcc (p_acc IN GIPI_WMCACC%ROWTYPE) IS
    BEGIN

        MERGE INTO GIPI_WMCACC
        USING DUAL ON (par_id = p_acc.par_id
            AND item_no = p_acc.item_no
            AND accessory_cd = p_acc.accessory_cd )
        WHEN NOT MATCHED THEN
            INSERT (par_id,   item_no, accessory_cd, acc_amt, user_id, last_update)
            VALUES (p_acc.par_id, p_acc.item_no, p_acc.accessory_cd, p_acc.acc_amt, p_acc.user_id, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET
                acc_amt = p_acc.acc_amt,
                user_id = p_acc.user_id,
                last_update = SYSDATE;

        COMMIT;
    END;

    Procedure set_Gipi_WMcAcc_1 (
        p_par_id         IN GIPI_WMCACC.par_id%TYPE,
        p_item_no        IN GIPI_WMCACC.item_no%TYPE,
        p_accessory_cd    IN GIPI_WMCACC.accessory_cd%TYPE,
        p_acc_amt        IN GIPI_WMCACC.acc_amt%TYPE,
        p_user_id        IN GIPI_WMCACC.user_id%TYPE,
        p_delete_sw        IN GIPI_WMCACC.delete_sw%TYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WMCACC
        USING DUAL ON (par_id = p_par_id
            AND item_no = p_item_no
            AND accessory_cd = p_accessory_cd )
        WHEN NOT MATCHED THEN
            INSERT (par_id,   item_no, accessory_cd, acc_amt, user_id, last_update)
            VALUES (p_par_id, p_item_no, p_accessory_cd, p_acc_amt, p_user_id, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET
                acc_amt = p_acc_amt,
                user_id = p_user_id,
                last_update = SYSDATE;
    END set_Gipi_WMcAcc_1;

    Procedure delete_all_GipiWMcAcc (p_par_id     GIPI_WMCACC.par_id%TYPE,
        p_item_no     GIPI_WMCACC.item_no%TYPE) IS
        v_exist    NUMBER;
    BEGIN
        FOR a IN (
            SELECT DISTINCT 1
              FROM GIPI_WMCACC
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_exist := 1;
        END LOOP;

        IF v_exist IS NOT NULL THEN
            DELETE FROM GIPI_WMCACC
               WHERE par_id = p_par_id
                 AND item_no = p_item_no;
            COMMIT;
        END IF;
    END;

    Procedure del_gipi_wmcacc (p_par_id        GIPI_WMCACC.par_id%TYPE,
        p_item_no    GIPI_WMCACC.item_no%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WMCACC
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
    END del_gipi_wmcacc;

    Procedure del_gipi_wmcacc_1 (
        p_par_id        IN GIPI_WMCACC.par_id%TYPE,
        p_item_no        IN GIPI_WMCACC.item_no%TYPE,
        p_accessory_cd    IN GIPI_WMCACC.accessory_cd%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WMCACC
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND accessory_cd = p_accessory_cd;
    END del_gipi_wmcacc_1;

    Procedure del_gipi_wmcacc (p_par_id IN GIPI_WMCACC.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WMCACC
         WHERE par_id = p_par_id;
    END del_gipi_wmcacc;

    FUNCTION get_gipi_wmcacc_pack_pol (
        p_par_id IN gipi_wmcacc.par_id%TYPE,
        p_item_no IN gipi_wmcacc.item_no%TYPE)
    RETURN get_Gipi_WMcAcc_tab PIPELINED
    IS
        v_mcacc get_Gipi_WMcAcc_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wmcacc
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_mcacc.par_id    := i.par_id;
            v_mcacc.item_no    := i.item_no;

            PIPE ROW(v_mcacc);
        END LOOP;

        RETURN;
    END get_gipi_wmcacc_pack_pol;

    FUNCTION get_gipi_wmcacc_tg (
        p_par_id IN gipi_wmcacc.par_id%TYPE,
        p_item_no IN gipi_wmcacc.item_no%TYPE,
        p_find_text IN VARCHAR2)
    RETURN get_Gipi_WMcAcc_tab PIPELINED
    IS
        v_gipi_wmcacc get_Gipi_WMcAcc_type;
    BEGIN
        FOR a IN (
            SELECT a.par_id,  a.item_no,     a.accessory_cd,
                   a.acc_amt, a.delete_sw,     a.user_id,
                   b.accessory_desc
              FROM gipi_wmcacc a,
                   giis_accessory b
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.accessory_cd = b.accessory_cd
               AND UPPER(b.accessory_desc) LIKE NVL(UPPER(p_find_text), '%%')
          ORDER BY b.accessory_desc)
        LOOP
            v_gipi_wmcacc.par_id            := a.par_id;
            v_gipi_wmcacc.item_no            := a.item_no;
            v_gipi_wmcacc.accessory_cd        := a.accessory_cd;
            v_gipi_wmcacc.acc_amt            := a.acc_amt;
            v_gipi_wmcacc.delete_sw            := a.delete_sw;
            v_gipi_wmcacc.user_id            := a.user_id;
            v_gipi_wmcacc.accessory_desc    := a.accessory_desc;

            PIPE ROW(v_gipi_wmcacc);
        END LOOP;
        RETURN;
    END get_gipi_wmcacc_tg;
END Gipi_Wmcacc_Pkg;
/


