CREATE OR REPLACE PACKAGE BODY CPI.GIACS309_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.18.2013
     ** Referenced By:  GIACS309 - Subsidiary Ledger Maintenance
     **/
     
    FUNCTION get_sl_type_lov
        RETURN sl_type_tab PIPELINED
    AS
        lov     sl_type_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_SL_TYPES)
        LOOP
            lov.sl_type_cd      := i.sl_type_cd;
            lov.sl_type_name    := i.sl_type_name;
            lov.sl_tag          := i.sl_tag;
            
            IF i.sl_tag = 'S' THEN
                lov.sl_tag_desc := 'SYSTEM';
            ELSIF i.sl_tag = 'M' THEN
                lov.sl_tag_desc := 'MANUAL';
            END IF;
            
            PIPE ROW(lov);
        END LOOP;
    END get_sl_type_lov;
    
    
    FUNCTION get_rec_list(
        p_sl_type_cd    GIAC_SL_LISTS.SL_TYPE_CD%type
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_SL_LISTS
                   WHERE UPPER(sl_type_cd) = UPPER(p_sl_type_cd))
        LOOP
            rec.fund_cd         := i.fund_cd;
            rec.sl_type_cd      := i.sl_type_cd;
            rec.sl_cd           := i.sl_cd;
            rec.sl_name         := i.sl_name;
            rec.active_tag      := i.active_tag;
            rec.remarks         := i.remarks;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
            
            SELECT sl_tag
              INTO rec.sl_tag
              FROM GIAC_SL_TYPES
             WHERE sl_type_cd = p_sl_type_cd;
            PIPE ROW(rec);
        END LOOP;
    END get_rec_list;
    
    
    PROCEDURE set_rec (p_rec  GIAC_SL_LISTS%ROWTYPE)
    AS
    BEGIN
        MERGE INTO GIAC_SL_LISTS
        USING DUAL
           ON (fund_cd = p_rec.fund_cd
               AND sl_type_cd = p_rec.sl_type_cd
               AND sl_cd = p_rec.sl_cd)
         WHEN NOT MATCHED THEN
            INSERT (fund_cd, sl_type_cd, sl_cd, sl_name, active_tag,
                    remarks, user_id, last_update)
            VALUES (p_rec.fund_cd, p_rec.sl_type_cd, p_rec.sl_cd, p_rec.sl_name, p_rec.active_tag,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET  sl_name     = p_rec.sl_name,
                    active_tag  = p_rec.active_tag,
                    remarks     = p_rec.remarks,
                    user_id     = p_rec.user_id,
                    last_update = SYSDATE
         ;
    END set_rec;
    
    
    PROCEDURE del_rec (
        p_fund_cd       GIAC_SL_LISTS.FUND_CD%type,
        p_sl_type_cd    GIAC_SL_LISTS.SL_TYPE_CD%type,
        p_sl_cd         GIAC_SL_LISTS.SL_CD%type
    )
    AS
    BEGIN
        DELETE FROM GIAC_SL_LISTS
         WHERE fund_cd = p_fund_cd
           AND sl_type_cd = p_sl_type_cd
           AND sl_cd = p_sl_cd;
    END del_rec;
    
    
    PROCEDURE val_add_rec(
        p_fund_cd       GIAC_SL_LISTS.FUND_CD%type,
        p_sl_type_cd    GIAC_SL_LISTS.SL_TYPE_CD%type,
        p_sl_cd         GIAC_SL_LISTS.SL_CD%type    
    )
    AS
        v_exists    VARCHAR2(1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIAC_SL_LISTS
                   WHERE fund_cd = p_fund_cd
                     AND sl_type_cd = p_sl_type_cd
                     AND sl_cd = p_sl_cd)
        LOOP
            v_exists    := 'Y';
            EXIT;
        END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Record already exists with the same fund_cd, sl_type_cd and sl_cd.'
                                    );
        END IF;
    END val_add_rec;

END GIACS309_PKG;
/


