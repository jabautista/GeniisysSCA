CREATE OR REPLACE PACKAGE BODY CPI.GIISS071_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   11.28.2013\
     ** Referenced By:  GIISS071 - Signatory Name Maintenance
     **/
     
    FUNCTION get_rec_list(
        p_signatory           GIIS_SIGNATORY_NAMES.SIGNATORY%type
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM GIIS_SIGNATORY_NAMES
                   WHERE UPPER(signatory) LIKE UPPER(NVL(p_signatory, '%'))
                   ORDER BY signatory_id)
        LOOP
            rec.signatory_id    := i.signatory_id;
            rec.signatory       := i.signatory;
            rec.designation     := i.designation;
            rec.res_cert_no     := i.res_cert_no;
            rec.res_cert_date   := TO_CHAR(i.res_cert_date, 'MM-DD-YYYY');
            rec.res_cert_place  := i.res_cert_place;
            rec.status          := i.status;
            rec.file_name       := i.file_name;
            rec.remarks         := i.remarks;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM');    
            
            BEGIN
                SELECT RV_MEANING 
                  INTO rec.status_mean
                  FROM CG_REF_CODES
                 WHERE RV_DOMAIN = 'GIIS_SIGNATORY_NAMES.STATUS'
                   AND RV_LOW_VALUE = i.STATUS;
            EXCEPTION   
                WHEN NO_DATA_FOUND THEN
                    rec.status_mean := null;
            END;
        
            PIPE ROW(rec);
        END LOOP;
        
    END get_rec_list;
    
    
    PROCEDURE set_rec (p_rec GIIS_SIGNATORY_NAMES%ROWTYPE)
    IS
    BEGIN
        MERGE INTO GIIS_SIGNATORY_NAMES
        USING DUAL
           ON (signatory_id = p_rec.signatory_id)
         WHEN NOT MATCHED THEN
            INSERT (signatory_id, signatory, designation, status, res_cert_no, res_cert_place, res_cert_date, remarks, user_id, last_update)
            VALUES (p_rec.signatory_id, p_rec.signatory, p_rec.designation, p_rec.status, p_rec.res_cert_no, p_rec.res_cert_place, p_rec.res_cert_date, 
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET signatory        = p_rec.signatory,
                   designation      = p_rec.designation,
                   status           = p_rec.status,
                   res_cert_no      = p_rec.res_cert_no,
                   res_cert_date    = p_rec.res_cert_date,
                   res_cert_place   = p_rec.res_cert_place,
                   remarks          = p_rec.remarks, 
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
            ;
    END set_rec;
    

    PROCEDURE del_rec (p_signatory_id   GIIS_SIGNATORY_NAMES.signatory_id%type)
    AS
    BEGIN
        DELETE FROM GIIS_SIGNATORY_NAMES
         WHERE signatory_id = p_signatory_id;
    END del_rec;
    

    PROCEDURE val_del_rec (p_signatory_id   GIIS_SIGNATORY_NAMES.signatory_id%type)
    AS
        v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_SIGNATORY a
                   WHERE a.signatory_id = p_signatory_id)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Cannot delete record from GIIS_SIGNATORY_NAMES while dependent record(s) in GIIS_SIGNATORY exists.'
                                     );
        END IF;
    END val_del_rec;
    

    PROCEDURE val_add_rec(
        p_signatory_id  GIIS_SIGNATORY_NAMES.signatory_id%type,
        p_signatory     GIIS_SIGNATORY_NAMES.SIGNATORY%type,
        p_res_cert_no   GIIS_SIGNATORY_NAMES.RES_CERT_NO%type
    )
    AS
        v_exists   VARCHAR2 (1);
        v_exists2  VARCHAR2 (1);
        v_exists3  VARCHAR2 (1);
    BEGIN
        /*FOR i IN (SELECT '1'
                    FROM GIIS_SIGNATORY_NAMES a
                   WHERE a.signatory_id = p_signatory_id)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same Code.'
                                     );
        END IF;*/
        
        
        FOR i IN (SELECT '1'
                    FROM GIIS_SIGNATORY_NAMES a
                   WHERE UPPER(a.signatory) = UPPER(p_signatory))
        LOOP
            v_exists2 := 'Y';
            EXIT;
        END LOOP;

        IF v_exists2 = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same signatory.'
                                     );
        END IF;
        
        
        FOR i IN (SELECT '1'
                    FROM GIIS_SIGNATORY_NAMES a
                   WHERE UPPER(a.res_cert_no) = UPPER(p_res_cert_no))
        LOOP
            v_exists3 := 'Y';
            EXIT;
        END LOOP;

        IF v_exists3 = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same res_cert_no.'
                                     );
        END IF;
    END val_add_rec;
   
    
    PROCEDURE val_update_rec(
        p_signatory_id  GIIS_SIGNATORY_NAMES.signatory_id%type,
        p_signatory     GIIS_SIGNATORY_NAMES.SIGNATORY%type,
        p_res_cert_no   GIIS_SIGNATORY_NAMES.RES_CERT_NO%type
    )
    AS
        v_exists   VARCHAR2 (1);
        v_exists2  VARCHAR2 (1);    
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_SIGNATORY_NAMES a
                   WHERE signatory_id <> p_signatory_id
                     AND UPPER(a.signatory) = UPPER(p_signatory))
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same signatory.'
                                     );
        END IF;
        
        
        FOR i IN (SELECT '1'
                    FROM GIIS_SIGNATORY_NAMES a
                   WHERE signatory_id <> p_signatory_id
                     AND UPPER(a.res_cert_no) = UPPER(p_res_cert_no))
        LOOP
            v_exists2 := 'Y';
            EXIT;
        END LOOP;

        IF v_exists2 = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same res_cert_no.'
                                     );
        END IF;
    END val_update_rec;
    
    
    PROCEDURE set_signatory_file_name (
      p_signatory_id   giis_signatory_names.signatory_id%TYPE,
      p_file_name      giis_signatory_names.file_name%TYPE
    )
    IS
    BEGIN
        UPDATE giis_signatory_names
           SET file_name = p_file_name
         WHERE signatory_id = p_signatory_id;
    END set_signatory_file_name;

END GIISS071_PKG;
/


