CREATE OR REPLACE PACKAGE BODY CPI.GIAC_FILE_SOURCE_PKG
AS
   FUNCTION get_file_source_lov
      RETURN file_source_lov_tab PIPELINED
   IS
      v_list   file_source_lov_type;
   BEGIN
      FOR i IN (SELECT source_cd, source_name, atm_tag
                  FROM giac_file_source
              ORDER BY 1)
      LOOP
         v_list.source_cd := i.source_cd;
         v_list.source_name := i.source_name;
         v_list.atm_tag := i.atm_tag;
         PIPE ROW (v_list);
      END LOOP;
   END get_file_source_lov;

   FUNCTION check_file_name (
      p_file_name VARCHAR2,
      p_transaction_type VARCHAR2,
      p_source_cd VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_length           NUMBER;
      v_file_name        VARCHAR2 (15);
      v_source_cd        VARCHAR2 (15);
      v_year             VARCHAR2 (15);
      v_mm               VARCHAR2 (15);
      v_dd               VARCHAR2 (15);
      v_fileparameter1   giac_parameters.param_value_v%TYPE;
      v_fileparameter2   giac_parameters.param_value_v%TYPE;
      v_dummy            DATE;
      v_exists           BOOLEAN                              := FALSE;
      v_message          VARCHAR2(500) := 'GOOD';
   BEGIN
--      :upload.records_converted := NULL;
--      :upload.total_records := NULL;

      IF p_file_name = '$'
      THEN
--         :upload.file_name := NULL;
         v_message := 'Filename must be in the form SOURCE_CD-YEAR-MM-DD.';
      END IF;
      
      IF INSTR(p_file_name, '.xls') = 0 THEN
         v_message := 'Invalid filename. File to be converted should be in .XLS format.';
         raise_application_error (-20001, 'Geniisys Exception#E#Invalid filename. File to be converted should be in .XLS format.');
      END IF;

      v_length :=
         LENGTH (SUBSTR (REPLACE (p_file_name, '.xls', NULL),
                         INSTR (p_file_name, '\', -1, 1) + 1,
                         100
                        )
                );

      IF p_transaction_type IN ('1', '2', '3', '4')
      THEN
         IF v_length > 15 OR v_length < 12
         THEN
            v_message := 'Filename must be in the form SOURCE_CD-YEAR-MM-DD.';
         END IF;

         v_file_name := SUBSTR (REPLACE (p_file_name, '.xls', NULL), INSTR (p_file_name, '\', -1, 1) + 1, 15);

         IF    INSTR (v_file_name, '-', 1, 4) <> 0
            OR INSTR (v_file_name, '-', 1, 3) = 0
         THEN
           v_message := 'Filename must be in the form SOURCE_CD-YEAR-MM-DD.';
         END IF;

         v_source_cd := SUBSTR (v_file_name, 1, INSTR (v_file_name, '-', -1, 3) - 1);
         v_year := SUBSTR (v_file_name, INSTR (v_file_name, '-', -1, 3) + 1, INSTR (v_file_name, '-', -1, 2) - INSTR (v_file_name, '-', -1, 3) - 1);
         v_mm := SUBSTR (v_file_name, INSTR (v_file_name, '-', -1, 2) + 1, INSTR (v_file_name, '-', -1, 1) - INSTR (v_file_name, '-', -1, 2) - 1);
         v_dd := LTRIM (RTRIM (SUBSTR (v_file_name, INSTR (v_file_name, '-', -1, 1) + 1, 3 )));

         IF    LENGTH (v_source_cd) > 4
            OR LENGTH (v_source_cd) = 0
            OR LENGTH (v_year) <> 4
            OR LENGTH (v_mm) <> 2
            OR LENGTH (v_dd) <> 2
         THEN
            v_message := 'Filename must be in the form SOURCE_CD-YEAR-MM-DD.';
         ELSE
            BEGIN
               SELECT TO_DATE (v_year || '-' || v_mm || '-' || v_dd, 'RRRR-MM-DD')
                 INTO v_dummy
                 FROM DUAL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_message := 'Filename must be in the form SOURCE_CD-YEAR-MM-DD.';
            END;
         END IF;

         FOR i IN (SELECT 'X'
                     FROM giac_file_source
                    WHERE source_cd = v_source_cd)
         LOOP
            v_exists := TRUE;
            EXIT;
         END LOOP;

         IF NOT v_exists
         THEN
--            p_file_name := NULL;
            --go_item('upload.file_name');
            v_message := 'Invalid source code in filename.';
         END IF;

         IF p_source_cd <> v_source_cd
         THEN
--            p_file_name := NULL;
            --go_item('upload.file_name');
            v_message := 'Source code in filename must be the same as the selected source.';
         END IF;
      -- rad 05/13/2010: added because tran type 5 has diff file format. --
      ELSIF p_transaction_type = 5
      THEN
         v_file_name :=
            SUBSTR (REPLACE (p_file_name, '.xls', NULL),
                    INSTR (p_file_name, '\', -1, 1) + 1,
                    15
                   );

         SELECT param_value_v
           INTO v_fileparameter1
           FROM giac_parameters
          WHERE param_name = 'PAYMENT_UPLOAD_FILENAME';

         v_fileparameter2 :=
                    SUBSTR (v_file_name, 1, INSTR (v_file_name, '_', 1, 1) - 1);

         IF v_fileparameter1 <> v_fileparameter2
         THEN
            v_message := 'Filename must be in the form '|| v_fileparameter1|| '_YYYYMMDD.';
         ELSIF v_fileparameter2 IS NULL
         THEN
            v_message := 'Filename must be in the form '|| v_fileparameter1|| '_YYYYMMDD.';
         END IF;

         IF LENGTH (SUBSTR (v_file_name, INSTR (v_file_name, '_', 1, 1) + 1)) >
                                                                             8
         THEN
            v_message := 'Filename must be in the form '|| v_fileparameter1|| '_YYYYMMDD.';
         END IF;
      END IF;

      FOR i IN (SELECT 'X'
                  FROM giac_upload_file
                 WHERE file_name = v_file_name AND file_status <> 'C')
      --Vincent 08192006: added condition
      LOOP
--         p_file_name := NULL;
         --go_item('upload.file_name');
         v_message := 'This file was already converted.';
      END LOOP;

      <<invalid>>
--        v_message := 'Filename must be in the form SOURCE_CD-YEAR-MM-DD.';

      <<invalid_type5>>
--        v_message := 'Filename must be in the form '|| v_fileparameter1|| '_YYYYMMDD.';
        
      RETURN v_message;     
   END check_file_name;
   
   FUNCTION get_amt_tag (p_source_cd VARCHAR2)
      RETURN VARCHAR2
   IS 
      v_atm_tag VARCHAR2(1);     
   BEGIN
      BEGIN
          SELECT NVL(atm_tag,'N')
            INTO v_atm_tag
            FROM giac_file_source
           WHERE source_cd = p_source_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                v_atm_tag := 'X';
      END;          
      RETURN v_atm_tag;
   END get_amt_tag;
   
   FUNCTION get_or_tag  (p_source_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_or_tag giac_file_source.or_tag%TYPE;
   BEGIN
      BEGIN
         SELECT or_tag
           INTO v_or_tag
           FROM giac_file_source
          WHERE source_cd = p_source_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_or_tag := 'ERROR';
      END;
      RETURN v_or_tag;
   END;
   
   PROCEDURE insert_giac_upload_file (
      p_source_cd           IN  VARCHAR2,
      p_file_name           IN  VARCHAR2,
      p_convert_date        IN  VARCHAR2,
      p_transaction_type    IN  VARCHAR2,
      p_remarks             IN  VARCHAR2,
      p_user_id             IN  VARCHAR2,
      p_file_no             OUT VARCHAR2    
   )
   IS
   BEGIN
      --Deo [11.29.2016]: add start
      IF p_transaction_type = 5
      THEN
         IF get_amt_tag (p_source_cd) = 'Y'
         THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Error in converting file. '
            || 'ATM tag of file source should be equal to N.');
         END IF;
      END IF;
      --Deo [11.29.2016]: add ends
      
      BEGIN
        SELECT NVL(MAX(file_no),0) + 1
          INTO p_file_no
          FROM giac_upload_file
         WHERE source_cd = p_source_cd;
      END;
      
      BEGIN
        INSERT INTO giac_upload_file
                    (source_cd, file_no, file_name, convert_date,
                     transaction_type, remarks, user_id, last_update
                    )
             VALUES (p_source_cd, p_file_no, p_file_name, TO_DATE(p_convert_date, 'mm-dd-yyyy'),
                     p_transaction_type, p_remarks, p_user_id, SYSDATE
                    );
      END;
   END insert_giac_upload_file;
   
   FUNCTION get_file_source_lov2
      RETURN file_source_lov_tab2 PIPELINED
   IS
      v_list file_source_lov_type2; 
   BEGIN
      FOR i IN (SELECT source_cd, source_name, atm_tag
                  FROM giac_file_source)
      LOOP
         v_list.source_cd := i.source_cd;
         v_list.source_name := i.source_name;
         v_list.atm_tag := i.atm_tag;
         PIPE ROW (v_list);
      END LOOP;            
   END get_file_source_lov2;   
   FUNCTION GET_GIACS605_SOURCE_LOV( -- Dren Niebres 10.03.2016 SR-4572 : Added LOV for GIACS605 Source
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS605_SOURCE_LOV_TAB PIPELINED
   IS
      V_LIST GIACS605_SOURCE_LOV_TYPE;
   BEGIN
        FOR I IN (
                SELECT SOURCE_CD, SOURCE_NAME 
                  FROM GIAC_FILE_SOURCE
                 WHERE SOURCE_CD LIKE UPPER(P_SEARCH)                    
                 ORDER BY SOURCE_CD
        )
        LOOP
            V_LIST.SOURCE_CD        := I.SOURCE_CD;
            V_LIST.SOURCE_NAME      := I.SOURCE_NAME;   
        
            PIPE ROW(V_LIST);
        END LOOP;
        
        RETURN;   
   END;    
   FUNCTION GET_GIACS606_SOURCE_LOV( -- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Source
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS606_SOURCE_LOV_TAB PIPELINED
   IS
      V_LIST GIACS606_SOURCE_LOV_TYPE;
   BEGIN
        FOR I IN (
                SELECT SOURCE_CD, SOURCE_NAME 
                  FROM GIAC_FILE_SOURCE
                 WHERE SOURCE_CD LIKE UPPER(P_SEARCH)                    
                 ORDER BY SOURCE_CD
        )
        LOOP
            V_LIST.SOURCE_CD        := I.SOURCE_CD;
            V_LIST.SOURCE_NAME      := I.SOURCE_NAME;   
        
            PIPE ROW(V_LIST);
        END LOOP;
        
        RETURN;   
   END;      
   
END;
/
