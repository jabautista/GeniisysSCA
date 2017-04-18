CREATE OR REPLACE PACKAGE BODY CPI.GIISS010_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   10.23.2013
     ** Referenced By:  GIISS010 - Deductible Maintenance
     **/
     
    FUNCTION get_line_lov(
        p_user_id       GIIS_SUBLINE.USER_ID%type
    ) RETURN line_tab PIPELINED
    AS
        lov     line_type;
    BEGIN
        FOR i IN (SELECT DISTINCT line_cd
                    FROM GIIS_SUBLINE
                   WHERE check_user_per_line2 (line_cd, null,'GIISS010', p_user_id)= 1
                   ORDER BY line_cd)
        LOOP
            lov.line_cd := i.line_cd;
            
            BEGIN
                SELECT line_name
                  INTO lov.line_name
                  FROM GIIS_LINE
                 WHERE line_cd = i.line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    lov.line_name   := null;
            END;
            
            PIPE ROW(lov);
        END LOOP;
    END get_line_lov;
    
    
    FUNCTION get_subline_lov(
        p_line_cd       GIIS_SUBLINE.LINE_CD%type
    ) RETURN subline_tab PIPELINED
    AS
        lov     subline_type;
    BEGIN
        FOR i IN (SELECT subline_cd, subline_name
                    FROM GIIS_SUBLINE
                   WHERE line_cd = p_line_cd
                   ORDER BY subline_cd)
        LOOP
            lov.subline_cd      := i.subline_cd;
            lov.subline_name    := i.subline_name;            
            
            PIPE ROW(lov);
        END LOOP;
    END get_subline_lov;
    
    
    FUNCTION get_rec_list (
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type,
        p_ded_type          GIIS_DEDUCTIBLE_DESC.DED_TYPE%type,
        p_deductible_title  GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_TITLE%type,
        p_user_id           GIIS_DEDUCTIBLE_DESC.USER_ID%type
    ) RETURN rec_tab PIPELINED
    AS
        v_rec   rec_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIIS_DEDUCTIBLE_DESC
                  WHERE UPPER(line_cd) = UPPER(p_line_cd)
                    AND UPPER(subline_cd) = UPPER(p_subline_cd)
                    AND UPPER(deductible_cd) LIKE UPPER(NVL(p_deductible_cd, '%'))
                    AND UPPER(ded_type) LIKE UPPER(NVL(p_ded_type, '%'))
                    AND UPPER(deductible_title) LIKE UPPER(NVL(p_deductible_title, '%'))
                    AND check_user_per_line2 (line_cd, null,'GIISS010', p_user_id)= 1
                  ORDER BY deductible_cd, deductible_title)
        LOOP
            v_rec.line_cd           := i.line_cd;
            v_rec.subline_cd        := i.subline_cd;
            v_rec.deductible_cd     := i.deductible_cd;
            v_rec.ded_type          := i.ded_type;
            v_rec.deductible_title  := i.deductible_title;
            v_rec.deductible_text   := i.deductible_text;
            v_rec.deductible_rt     := i.deductible_rt;
            v_rec.deductible_amt    := i.deductible_amt;
            v_rec.min_amt           := i.min_amt;
            v_rec.max_amt           := i.max_amt;
            v_rec.range_sw          := i.range_sw;
            v_rec.remarks           := i.remarks;
            v_rec.user_id           := i.user_id;
            v_rec.last_update       := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            PIPE ROW (v_rec);
        END LOOP;
    END get_rec_list;


    PROCEDURE set_rec (p_rec GIIS_DEDUCTIBLE_DESC%ROWTYPE)
    AS    
    BEGIN
        MERGE INTO GIIS_DEDUCTIBLE_DESC
         USING DUAL
         ON (line_cd = p_rec.line_cd
             AND subline_cd = p_rec.subline_cd
             AND deductible_cd = p_rec.deductible_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, subline_cd, deductible_cd, ded_type, deductible_title, deductible_text, 
                    deductible_rt, deductible_amt, min_amt, max_amt, range_sw, remarks, user_id, last_update)
            VALUES (p_rec.line_cd, p_rec.subline_cd, p_rec.deductible_cd, p_rec.ded_type, p_rec.deductible_title, p_rec.deductible_text, 
                    p_rec.deductible_rt, p_rec.deductible_amt, p_rec.min_amt, p_rec.max_amt, p_rec.range_sw, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET ded_type = p_rec.ded_type,
                   deductible_title = p_rec.deductible_title,
                   deductible_text = p_rec.deductible_text,
                   deductible_rt = p_rec.deductible_rt,
                   deductible_amt = p_rec.deductible_amt,
                   min_amt = p_rec.min_amt,
                   max_amt = p_rec.max_amt,
                   range_sw = p_rec.range_sw, 
                   remarks = p_rec.remarks, 
				   user_id = p_rec.user_id, 
				   last_update = SYSDATE;
    END set_rec;

    PROCEDURE del_rec (
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type
    )
    AS    
    BEGIN
        DELETE FROM GIIS_DEDUCTIBLE_DESC
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd
           AND deductible_cd = p_deductible_cd;
    END del_rec;

    /* CGRI$CHK_GIIS_DEDUCTIBLE_DESC   program unit */
    PROCEDURE val_del_rec (
        p_check_both        VARCHAR2,
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type
    )
    AS
        v_exists    VARCHAR2 (1);
        CG$DUMMY    VARCHAR2(1); 
    BEGIN
        /*IF p_check_both = 'Y' THEN
            DECLARE
                CURSOR C IS
                    SELECT '1'
                      FROM GIPI_WDEDUCTIBLES B350
                     WHERE B350.DED_DEDUCTIBLE_CD = P_DEDUCTIBLE_CD
                       AND DED_LINE_CD = p_line_cd
                       AND DED_SUBLINE_CD = P_SUBLINE_CD;
            BEGIN
                OPEN C;
                FETCH C
                INTO    CG$DUMMY;
                IF C%FOUND THEN
                    --msg_alert('Cannot delete DEDUCTIBLE Record while the same record exists in transaction tables.', 'E', TRUE);
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_DEDUCTIBLE_DESC while dependent record(s) in GIPI_WDEDUCTIBLES exists.');
                END IF;
                CLOSE C;
            END;
        ELSE
            DECLARE
                CURSOR C IS
                    SELECT '1'
                      FROM GIPI_DEDUCTIBLES B030
                     WHERE B030.DED_LINE_CD = P_LINE_CD
                       AND B030.DED_SUBLINE_CD = P_SUBLINE_CD
                       AND B030.DED_DEDUCTIBLE_CD = P_DEDUCTIBLE_CD;
            BEGIN
                OPEN C;
                FETCH C
                INTO    CG$DUMMY;
                IF C%FOUND THEN
                    --msg_alert('Cannot delete DEDUCTIBLE Record while the same record exists in transaction tables.', 'E', TRUE);
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_DEDUCTIBLE_DESC while dependent record(s) in GIPI_DEDUCTIBLES exists.');
                END IF;
                CLOSE C;
            END;
        END IF;*/
        
        FOR i IN (SELECT '1'
                    FROM GIPI_WDEDUCTIBLES B350
                   WHERE B350.DED_DEDUCTIBLE_CD = P_DEDUCTIBLE_CD
                     AND DED_LINE_CD = p_line_cd
                     AND DED_SUBLINE_CD = P_SUBLINE_CD)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_DEDUCTIBLE_DESC while dependent record(s) in GIPI_WDEDUCTIBLES exists.'
                                    );
        END IF;
        
        FOR i IN (SELECT '1'
                    FROM GIPI_DEDUCTIBLES B030
                   WHERE B030.DED_LINE_CD = P_LINE_CD
                     AND B030.DED_SUBLINE_CD = P_SUBLINE_CD
                     AND B030.DED_DEDUCTIBLE_CD = P_DEDUCTIBLE_CD)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record from GIIS_DEDUCTIBLE_DESC while dependent record(s) in GIPI_DEDUCTIBLES exists.'
                                    );
        END IF;
    END val_del_rec;
       
    PROCEDURE val_add_rec(
        p_line_cd           GIIS_DEDUCTIBLE_DESC.LINE_CD%type,
        p_subline_cd        GIIS_DEDUCTIBLE_DESC.SUBLINE_CD%type,
        p_deductible_cd     GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_CD%type,
        p_deductible_title  GIIS_DEDUCTIBLE_DESC.DEDUCTIBLE_TITLE%type
    )
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_DEDUCTIBLE_DESC a
                   WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.deductible_cd = p_deductible_cd)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Record already exists with the same line_cd, subline_cd and deductible_cd.'
                                    );
        END IF;
        
        FOR i IN (SELECT '1'
                    FROM GIIS_DEDUCTIBLE_DESC a
                   WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.deductible_title = p_deductible_title)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Record already exists with the deductible_title.'
                                    );
        END IF;
    END val_add_rec;

END GIISS010_PKG;
/


