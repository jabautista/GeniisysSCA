CREATE OR REPLACE PACKAGE BODY CPI.giiss083_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.30.2013
**  Reference By    : (GIISS083 - Underwriting - File Maintenance - Intermediary - Intermediary Type)
**  Description  : Populate Intermediary Type List
*/
   FUNCTION show_intm_type
      RETURN intermediary_tab PIPELINED
   IS
      v_list   intermediary_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_intm_type
                ORDER BY intm_type)
      LOOP
         v_list.intm_type := i.intm_type;
         v_list.intm_desc := i.intm_desc;
         v_list.acct_intm_cd := i.acct_intm_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_intm_type;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.30.2013
**  Reference By    : (GIISS083 - Underwriting - File Maintenance - Intermediary - Intermediary Type)
**  Description     : validate intermediary type before deletion
*/
   PROCEDURE val_del_rec (p_intm_type giis_intm_type.intm_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_intermediary a
                 WHERE a.intm_type = p_intm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_INTM_TYPE while dependent record(s) in GIIS_INTERMEDIARY exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_intmdry_type_rt a
                 WHERE a.intm_type = p_intm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_INTM_TYPE while dependent record(s) in GIIS_INTMDRY_TYPE_RT exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_banc_type_dtl a
                 WHERE a.intm_type = p_intm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_INTM_TYPE while dependent record(s) in GIIS_BANC_TYPE_DTL exists.#'
            );
         RETURN;
      END IF;
   END;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.30.2013
**  Reference By    : (GIISS083 - Underwriting - File Maintenance - Intermediary - Intermediary Type)
**  Description     : Insert or update record in giis_intm_type
*/
   PROCEDURE set_intm_type (
      p_intm_type      giis_intm_type.intm_type%TYPE,
      p_acct_intm_cd   giis_intm_type.acct_intm_cd%TYPE,
      p_intm_desc      giis_intm_type.intm_desc%TYPE,
      p_remarks        giis_intm_type.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_intm_type
         USING DUAL
         ON (intm_type = p_intm_type)
         WHEN NOT MATCHED THEN
            INSERT (intm_type, acct_intm_cd, intm_desc, remarks)
            VALUES (p_intm_type, p_acct_intm_cd, p_intm_desc, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET remarks = p_remarks
               ,intm_desc = p_intm_desc -- Added by Jerome 08.11.2016 SR 5583
            ;
   END set_intm_type;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.30.2013
**  Reference By    : (GIISS083 - Underwriting - File Maintenance - Intermediary - Intermediary Type)
**  Description     : Delete record in giis_intm_type
*/
   PROCEDURE delete_in_intm_type (p_intm_type giis_intm_type.intm_type%TYPE)
   IS
   BEGIN
      DELETE FROM giis_intm_type
            WHERE intm_type = p_intm_type;
   END delete_in_intm_type;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 05.02.2013
**  Reference By    : (GIISS083 - Underwriting - File Maintenance - Intermediary - Intermediary Type)
**  Description     : Validate added and updated record in giis_intm_type
*/
   PROCEDURE val_add_rec (p_inm_type giis_intm_type.intm_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_intm_type a
                 WHERE a.intm_type = p_inm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same intm_type.#'
            );
         RETURN;
      END IF;
   END;
   FUNCTION chk_giis_intm_type(p_intm_type giis_intm_type.intm_type%TYPE) -- Added by Jerome 08.11.2016 SR 5583
   RETURN VARCHAR2
   IS
   v_exists VARCHAR(1) := 'N';
   BEGIN
    
     FOR a IN (SELECT * 
                 FROM giis_intermediary
                WHERE intm_type = p_intm_type)
     LOOP
       v_exists := 'Y';
       EXIT;
     END LOOP;
   
   RETURN v_exists || 'GIIS_INTERMEDIARY';
   END;
END giiss083_pkg;
/


