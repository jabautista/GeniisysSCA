CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WMORTGAGEE_PKG
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for getting all the records in GIPI_WMORTGAGEE specified by the par_id
    */
	--added delete_sw kenneth SR 5483 05.26.2016
    FUNCTION get_gipi_wmortgagee (p_par_id IN gipi_wmortgagee.par_id%TYPE)
    RETURN gipi_wmortgagee_tab PIPELINED
    IS
        v_gipi_par_mort      gipi_wmortgagee_type;
    BEGIN
        FOR i IN (
            SELECT A.par_id,    A.iss_cd,        A.item_no,
                   A.mortg_cd,    b.mortg_name,    A.amount,    A.delete_sw
              FROM GIPI_WMORTGAGEE A,
                   GIIS_MORTGAGEE b
             WHERE A.mortg_cd = b.mortg_cd
               AND a.iss_cd   = b.iss_cd
               AND a.par_id = p_par_id
               AND a.item_no > 0)
        LOOP
            v_gipi_par_mort.par_id        := i.par_id;
            v_gipi_par_mort.iss_cd        := i.iss_cd;
            v_gipi_par_mort.item_no        := i.item_no;
            v_gipi_par_mort.mortg_cd    := i.mortg_cd;
            v_gipi_par_mort.mortg_name    := i.mortg_name;
            v_gipi_par_mort.amount        := i.amount;
            v_gipi_par_mort.delete_sw     := i.delete_sw;
            PIPE ROW (v_gipi_par_mort);
        END LOOP;
        RETURN;
    END get_gipi_wmortgagee;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.14.2011
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for getting all the records in GIPI_WMORTGAGEE specified by the par_id
    */
    --added delete_sw kenneth SR 5483 05.26.2016
    FUNCTION get_all_gipi_wmortgagee (p_par_id IN gipi_wmortgagee.par_id%TYPE)
    RETURN gipi_wmortgagee_tab PIPELINED
    IS
        v_gipi_par_mort      gipi_wmortgagee_type;
    BEGIN
        FOR i IN (
            SELECT A.par_id,        A.iss_cd,       A.item_no,
                   A.mortg_cd,        b.mortg_name,    A.amount,
                   A.remarks,        A.last_update,    A.user_id,   A.delete_sw
              FROM gipi_wmortgagee A,
                   giis_mortgagee b
             WHERE A.mortg_cd = b.mortg_cd
               AND a.iss_cd   = b.iss_cd
               AND a.par_id = p_par_id)
        LOOP
            v_gipi_par_mort.par_id        := i.par_id;
            v_gipi_par_mort.iss_cd        := i.iss_cd;
            v_gipi_par_mort.item_no        := i.item_no;
            v_gipi_par_mort.mortg_cd    := i.mortg_cd;
            v_gipi_par_mort.mortg_name    := i.mortg_name;
            v_gipi_par_mort.amount        := i.amount;
            v_gipi_par_mort.remarks        := i.remarks;
            v_gipi_par_mort.last_update    := i.last_update;
            v_gipi_par_mort.user_id        := i.user_id;
            v_gipi_par_mort.delete_sw      := i.delete_sw;

            PIPE ROW (v_gipi_par_mort);
        END LOOP;
        RETURN;
    END get_all_gipi_wmortgagee;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 11.22.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for getting the records in GIPI_WMORTGAGEE specified by the par_id and item_no
    */
    --added delete_sw kenneth SR 5483 05.26.2016
    FUNCTION get_gipi_wmortgagee(
        p_par_id     IN gipi_wmortgagee.par_id%TYPE,
        p_item_no    IN gipi_wmortgagee.item_no%TYPE)
    RETURN gipi_wmortgagee_tab PIPELINED
    IS
        v_gipi_par_mort      gipi_wmortgagee_type;
    BEGIN
        FOR i IN (
            SELECT A.par_id,    A.iss_cd,        A.item_no,
                   A.mortg_cd,    b.mortg_name,    A.amount,
                   A.remarks,    A.delete_sw
              FROM GIPI_WMORTGAGEE A,
                   GIIS_MORTGAGEE b
             WHERE A.mortg_cd = b.mortg_cd
               AND a.iss_cd   = b.iss_cd
               AND a.par_id = p_par_id
               AND a.item_no = p_item_no)
        LOOP
            v_gipi_par_mort.par_id        := i.par_id;
            v_gipi_par_mort.iss_cd        := i.iss_cd;
            v_gipi_par_mort.item_no        := i.item_no;
            v_gipi_par_mort.mortg_cd    := i.mortg_cd;
            v_gipi_par_mort.mortg_name    := i.mortg_name;
            v_gipi_par_mort.amount        := i.amount;
            v_gipi_par_mort.remarks            := i.remarks;
            v_gipi_par_mort.delete_sw     := i.delete_sw;
            PIPE ROW (v_gipi_par_mort);
        END LOOP;
        RETURN;
    END get_gipi_wmortgagee;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for inserting and updating records in GIPI_WMORTGAGEE
    */
    PROCEDURE set_gipi_wmortgagee (p_gipi_par_mort   IN       GIPI_WMORTGAGEE%ROWTYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WMORTGAGEE
        USING dual ON (par_id = p_gipi_par_mort.par_id
                    AND item_no = p_gipi_par_mort.item_no
                    AND mortg_cd = p_gipi_par_mort.mortg_cd)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                        iss_cd,                        item_no,                        mortg_cd,
                    amount,                        remarks,                    last_update,                    user_id   )
            VALUES (p_gipi_par_mort.par_id,        p_gipi_par_mort.iss_cd,        p_gipi_par_mort.item_no,        p_gipi_par_mort.mortg_cd,
                    p_gipi_par_mort.amount,        p_gipi_par_mort.remarks,    p_gipi_par_mort.last_update,    p_gipi_par_mort.user_id  )
        WHEN MATCHED THEN
            UPDATE SET  iss_cd        = p_gipi_par_mort.iss_cd,
                        amount        = p_gipi_par_mort.amount,
                        remarks        = p_gipi_par_mort.remarks,
                        last_update    = p_gipi_par_mort.last_update,
                        user_id        = p_gipi_par_mort.user_id;
    END set_gipi_wmortgagee;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for getting all the records in GIPI_WMORTGAGEE
    */
    --added delete_sw kenneth SR 5483 05.26.2016
    PROCEDURE set_gipi_wmortgagee_1 (
        p_par_id        GIPI_WMORTGAGEE.par_id%TYPE,
        p_iss_cd        GIPI_WMORTGAGEE.iss_cd%TYPE,
        p_item_no        GIPI_WMORTGAGEE.item_no%TYPE,
        p_mortg_cd        GIPI_WMORTGAGEE.mortg_cd%TYPE,
        p_amount        GIPI_WMORTGAGEE.amount%TYPE,
        p_remarks        GIPI_WMORTGAGEE.remarks%TYPE,
        p_last_update    GIPI_WMORTGAGEE.last_update%TYPE,
        p_user_id        GIPI_WMORTGAGEE.user_id%TYPE,
        p_delete_sw      GIPI_WMORTGAGEE.delete_sw%TYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WMORTGAGEE
        USING dual ON (par_id = p_par_id
                    AND item_no = p_item_no
                    AND mortg_cd = p_mortg_cd)
        WHEN NOT MATCHED THEN
            INSERT (par_id,        iss_cd,        item_no,        mortg_cd,
                    amount,        remarks,    last_update,    user_id,     delete_sw)
            VALUES (p_par_id,    p_iss_cd,    p_item_no,    p_mortg_cd,
                    p_amount,    p_remarks,    SYSDATE,    p_user_id,   p_delete_sw)
        WHEN MATCHED THEN
            UPDATE SET  iss_cd        = p_iss_cd,
                        amount        = p_amount,
                        remarks        = p_remarks,
                        last_update    = SYSDATE,
                        user_id        = p_user_id;
    END set_gipi_wmortgagee_1;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for deleting records in GIPI_WMORTGAGEE
    **                      specified by the par_id and item_no
    */
    PROCEDURE del_gipi_wmortgagee_item (
        p_par_id        GIPI_WMORTGAGEE.par_id%TYPE,
        p_item_no        GIPI_WMORTGAGEE.item_no%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WMORTGAGEE
         WHERE par_id = p_par_id
           AND item_no  = p_item_no;
    END del_gipi_wmortgagee_item;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for deleting records in GIPI_WMORTGAGEE
    **                      specified by the par_id, item_no, and mortg_cd
    */
    PROCEDURE del_gipi_wmortgagee_1 (
        p_par_id        GIPI_WMORTGAGEE.par_id%TYPE,
        p_item_no        GIPI_WMORTGAGEE.item_no%TYPE,
        p_mortg_cd        GIPI_WMORTGAGEE.mortg_cd%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WMORTGAGEE
         WHERE par_id = p_par_id
           AND item_no  = p_item_no
           AND mortg_cd = p_mortg_cd;
    END del_gipi_wmortgagee_1;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.26.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for deleting records in GIPI_WMORTGAGEE specified by the par_id
    */
    PROCEDURE del_gipi_wmortgagee (p_par_id     GIPI_WMORTGAGEE.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WMORTGAGEE
         WHERE par_id = p_par_id;
    END del_gipi_wmortgagee;

	/*	Date		Author			Description
	*	==========	===============	============================
	*	08.25.2011	mark jm			retrieve records on gipi_wmortgagee based on given parameters
	*/
	FUNCTION get_gipi_wmortgagee_tg(
        p_par_id IN gipi_wmortgagee.par_id%TYPE,
        p_item_no IN gipi_wmortgagee.item_no%TYPE,
		p_mortg_name IN VARCHAR2,
		p_remarks IN VARCHAR2)
    RETURN gipi_wmortgagee_tab PIPELINED
	IS
        v_gipi_par_mort      gipi_wmortgagee_type;
    BEGIN
        FOR i IN (
            SELECT A.par_id,    A.iss_cd,        A.item_no,
                   A.mortg_cd,    b.mortg_name,    A.amount,
                   A.remarks, A.delete_sw   --added delete_sw kenneth SR-5483,2743,3708 05.12.16
              FROM GIPI_WMORTGAGEE A,
                   GIIS_MORTGAGEE b
             WHERE A.mortg_cd = b.mortg_cd
               AND a.iss_cd   = b.iss_cd
               AND a.par_id = p_par_id
               AND a.item_no = p_item_no
			   AND UPPER(b.mortg_name) LIKE NVL(UPPER(p_mortg_name), '%%')
			   AND UPPER(NVL(A.remarks, '***')) LIKE NVL(UPPER(p_remarks), '%%')
		  ORDER BY b.mortg_name)
        LOOP
            v_gipi_par_mort.par_id		:= i.par_id;
            v_gipi_par_mort.iss_cd		:= i.iss_cd;
            v_gipi_par_mort.item_no		:= i.item_no;
            v_gipi_par_mort.mortg_cd    := i.mortg_cd;
            v_gipi_par_mort.mortg_name	:= i.mortg_name;
            v_gipi_par_mort.amount		:= i.amount;
            v_gipi_par_mort.remarks		:= i.remarks;
            v_gipi_par_mort.delete_sw	:= i.delete_sw; --kenneth SR-5483,2743,3708 05.12.16
            PIPE ROW (v_gipi_par_mort);
        END LOOP;
        RETURN;
    END get_gipi_wmortgagee_tg;
END GIPI_WMORTGAGEE_PKG;
/


