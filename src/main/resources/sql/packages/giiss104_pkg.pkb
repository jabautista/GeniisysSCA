CREATE OR REPLACE PACKAGE BODY CPI.giiss104_pkg
AS
   FUNCTION get_rec_list (
      p_endt_id      giis_endttext.endt_id%TYPE,
      p_endt_cd      giis_endttext.endt_cd%TYPE,
      p_endt_title   giis_endttext.endt_title%TYPE,
      p_endt_text    giis_endttext.endt_text%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_endttext a
                   WHERE a.endt_id = NVL (p_endt_id, a.endt_id)
                     AND UPPER (a.endt_cd) LIKE UPPER (NVL (p_endt_cd, '%'))
                     AND UPPER (a.endt_title) LIKE UPPER (NVL (p_endt_title, '%'))
                     AND UPPER (NVL(a.endt_text, '%')) LIKE UPPER (NVL (p_endt_text, '%'))
                ORDER BY a.endt_id)
      LOOP
         v_rec.endt_id := i.endt_id;
         v_rec.endt_cd := i.endt_cd;
         v_rec.endt_title := i.endt_title;
         v_rec.endt_text := i.endt_text;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.active_tag := i.active_tag; --carlo 01-26-2017 SR 5915
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (p_endt_cd giis_endttext.endt_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_endttext a
                 WHERE a.endt_cd = p_endt_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same endt_cd.'
            );
      END IF;
   END;

   PROCEDURE set_rec (p_rec giis_endttext%ROWTYPE)
   IS
      v_exists    VARCHAR2 (1);
      v_endt_id   giis_endttext.endt_id%TYPE;
   BEGIN
      SELECT endttext_id_s.NEXTVAL
        INTO v_endt_id
        FROM DUAL;

      FOR i IN (SELECT *
                  FROM giis_endttext
                 WHERE endt_id = p_rec.endt_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_endttext
            SET endt_cd = p_rec.endt_cd,
                endt_title = p_rec.endt_title,
                endt_text = p_rec.endt_text,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE,
                active_tag = p_rec.active_tag --carlo 01-26-2017 SR 5915
          WHERE endt_id = p_rec.endt_id;
      ELSE
         INSERT INTO giis_endttext
                     (endt_id, endt_cd, endt_title, 
                      endt_text, remarks, user_id, last_update, active_tag --carlo 01-26-2017 SR 5915
                     )
              VALUES (v_endt_id, p_rec.endt_cd, p_rec.endt_title,
                      p_rec.endt_text, p_rec.remarks, p_rec.user_id, SYSDATE,
                      p_rec.active_tag
                     );
      END IF;
   END;

   PROCEDURE del_rec (p_endt_id giis_endttext.endt_id%TYPE)
   AS
   BEGIN
      DELETE FROM giis_endttext
            WHERE endt_id = p_endt_id;
   END;

   /*Gzelle 02052015*/
   PROCEDURE val_del_rec (p_endt_cd giis_endttext.endt_cd%TYPE)
   AS
      v_output  VARCHAR2(50);
   BEGIN
       FOR i IN (SELECT endt_cd
                   FROM gipi_endttext
                  WHERE endt_cd = p_endt_cd
                    AND ROWNUM = 1)
       LOOP
        v_output := i.endt_cd;
        EXIT;
       END LOOP;
       
       IF v_output IS NULL
       THEN
           FOR i IN (SELECT endt_cd
                       FROM gipi_pack_wendttext
                      WHERE endt_cd = p_endt_cd
                        AND ROWNUM = 1)
           LOOP
            v_output := i.endt_cd;
            EXIT;
           END LOOP;
           
           IF v_output IS NULL
           THEN
               FOR i IN (SELECT endt_cd
                           FROM gipi_wendttext
                          WHERE endt_cd = p_endt_cd
                            AND ROWNUM = 1)
               LOOP
                v_output := i.endt_cd;
                EXIT;
               END LOOP;
               
               IF v_output IS NOT NULL
               THEN
                  raise_application_error
                     (-20001,
                         'Geniisys Exception#E#Cannot delete record from GIIS_ENDTTEXT while dependent record(s) in GIPI_WENDTTEXT exists.'
                     );               
               END IF;           
           ELSE
              raise_application_error
                 (-20001,
                     'Geniisys Exception#E#Cannot delete record from GIIS_ENDTTEXT while dependent record(s) in GIPI_PACK_WENDTTEXT exists.'
                 );               
           END IF;
       ELSE
          raise_application_error
             (-20001,
                 'Geniisys Exception#E#Cannot delete record from GIIS_ENDTTEXT while dependent record(s) in GIPI_ENDTTEXT exists.'
             );                  
       END IF;    
   END;
      
END;
/


