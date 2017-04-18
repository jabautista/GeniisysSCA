CREATE OR REPLACE PACKAGE BODY CPI.giiss068_pkg
AS
   FUNCTION get_rec_list (
      p_principal_id            giis_eng_principal.principal_id%TYPE,
      p_principal_cd            giis_eng_principal.principal_cd%TYPE,
      p_principal_name          giis_eng_principal.principal_name%TYPE,
      p_principal_type          giis_eng_principal.principal_type%TYPE,
      p_subline_cd              giis_eng_principal.subline_cd%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.principal_id, a.principal_cd, a.principal_name, a.principal_type,
                   a.subline_cd, a.address1, a.address2, a.address3,
                   a.remarks, a.user_id, a.last_update
              FROM giis_eng_principal a
             WHERE a.principal_id = NVL(p_principal_id, a.principal_id)
               AND a.principal_cd = NVL(p_principal_cd, a.principal_cd)
               AND UPPER (a.principal_name) LIKE UPPER (NVL (p_principal_name, '%'))
               AND UPPER (a.principal_type) LIKE UPPER (NVL (p_principal_type, '%'))
               AND UPPER (a.subline_cd) LIKE UPPER (NVL (p_subline_cd, '%'))
          ORDER BY a.principal_cd)
      LOOP
         v_rec.principal_id := i.principal_id;
         v_rec.principal_cd := i.principal_cd;
         v_rec.principal_name := i.principal_name;
         v_rec.principal_type := i.principal_type;
         v_rec.subline_cd := i.subline_cd;
         v_rec.address1 := i.address1;
         v_rec.address2 := i.address2;
         v_rec.address3 := i.address3;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         BEGIN
           SELECT UPPER(RV_MEANING)
             INTO v_rec.principal_type_mean
             FROM CG_REF_CODES
            WHERE ( (RV_HIGH_VALUE IS NULL AND i.principal_type IN (RV_LOW_VALUE, RV_ABBREVIATION) ) 
                        OR 
                     (i.principal_type BETWEEN  RV_LOW_VALUE AND RV_HIGH_VALUE)
                   )
              AND ROWNUM = 1
              AND RV_DOMAIN = 'GIIS_ENG_PRINCIPAL.PRINCIPAL_TYPE';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_rec.principal_type_mean := NULL;
         END;

         BEGIN
            SELECT s.subline_name
              INTO v_rec.subline_name
              FROM giis_subline s,
                   giis_line l
             WHERE s.subline_cd = i.subline_cd
               AND s.line_cd = l.line_cd
               AND l.menu_line_cd = 'EN';      -- shan 08.19.2014
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_rec.subline_name := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_eng_principal%ROWTYPE)
   IS
      v_next_principal_id       GIIS_ENG_PRINCIPAL.PRINCIPAL_ID%TYPE;
   BEGIN
   
      IF p_rec.principal_id IS NULL THEN
          
          BEGIN
            SELECT giiss068_pkg.get_next_id
              INTO v_next_principal_id
              FROM dual;
          END;
      
      ELSE
         
         v_next_principal_id := p_rec.principal_id;
         
      END IF;
      
      MERGE INTO giis_eng_principal
         USING DUAL
         ON (       principal_id   = v_next_principal_id
                AND principal_cd   = p_rec.principal_cd 
                AND principal_type = p_rec.principal_type 
                AND subline_cd     = p_rec.subline_cd)
         WHEN NOT MATCHED THEN
            INSERT (principal_id,           principal_cd,       principal_name, 
                    principal_type,         subline_cd, 
                    address1,               address2,           address3, 
                    remarks,                user_id,            last_update)
            VALUES (v_next_principal_id,    p_rec.principal_cd, p_rec.principal_name,
                    p_rec.principal_type,   p_rec.subline_cd,   
                    p_rec.address1,         p_rec.address2,     p_rec.address3,   
                    p_rec.remarks,          p_rec.user_id,      SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET principal_name   = p_rec.principal_name, 
                   address1         = p_rec.address1,
                   address2         = p_rec.address2,
                   address3         = p_rec.address3,
                   remarks          = p_rec.remarks,
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_principal_cd       giis_eng_principal.principal_cd%TYPE)
   AS
   BEGIN
   
      DELETE 
        FROM giis_eng_principal
       WHERE principal_cd = p_principal_cd;
   
   END;

   PROCEDURE val_del_rec (p_principal_cd       giis_eng_principal.principal_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1) := 'N';
      
      CURSOR C IS
            SELECT '1'
              FROM gipi_principal B575
             WHERE B575.principal_cd = p_principal_cd;
   BEGIN
   
      OPEN C;
   
      FETCH C
       INTO v_exists;
      
      IF C%FOUND THEN
        raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ENG_PRINCIPAL while dependent record(s) in GIPI_PRINCIPAL exists.');
      END IF;
      
      CLOSE C;
      
   END;

   PROCEDURE val_add_rec (p_principal_cd       giis_eng_principal.principal_cd%TYPE)
   AS
      v_exists    VARCHAR2 (1);
   BEGIN

      FOR i IN (SELECT '1'
                  FROM giis_eng_principal a
                 WHERE a.principal_cd = p_principal_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Row already exists with same principal_cd.');
      END IF;
      
   END;
   
   FUNCTION get_next_id RETURN NUMBER
   IS
        v_max_value             NUMBER(13);
        v_counter               NUMBER(13);
        v_exist                 VARCHAR2(1):= 'Y';
        v_parameter_counter     NUMBER(13) := 0;
        v_next_principal_id     giis_eng_principal.principal_id%TYPE;
   BEGIN
          SELECT max_value
            INTO v_max_value
            FROM ALL_SEQUENCES
           WHERE SEQUENCE_NAME = 'ENG_PRINCIPAL_ID_S';   
   
        WHILE v_exist = 'Y' AND v_parameter_counter < v_max_value 
        LOOP
		    v_parameter_counter := v_parameter_counter + 1;
		
            IF v_parameter_counter = v_max_value THEN
              raise_application_error (-20001,'Geniisys Exception#I#You have used up all available industry codes in the sequence.');
            END IF;
		
    
            SELECT eng_principal_id_s.NEXTVAL
              INTO v_next_principal_id
              FROM dual;

            v_exist := 'N';

            FOR a IN (SELECT 1
                        FROM giis_eng_principal
                       WHERE principal_id = v_next_principal_id)
            LOOP	
                v_exist := 'Y';
                EXIT;
            END LOOP;

        END LOOP;
        
        RETURN (v_next_principal_id);
   END;
   
   FUNCTION get_giiss068_subline_lov 
        RETURN giis068_subline_tab PIPELINED
   IS
        v_subline       giiss068_subline_type;
   BEGIN
   
        FOR i IN (SELECT subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = 'EN')
        LOOP
            v_subline.subline_cd := i.subline_cd;
            v_subline.subline_name := i.subline_name;
            PIPE ROW(v_subline);
        END LOOP;
   
   END;
   
END;
/


