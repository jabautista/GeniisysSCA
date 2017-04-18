CREATE OR REPLACE PACKAGE BODY CPI.GIISS211_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   10.22.2013
     ** Referenced By:  GIISS211 - Take-Up Term Maintenance
     **/
     
   FUNCTION get_rec_list (
      p_takeup_term         GIIS_TAKEUP_TERM.TAKEUP_TERM%type,
      p_takeup_term_desc    GIIS_TAKEUP_TERM.TAKEUP_TERM_DESC%type,
      p_yearly_tag          GIIS_TAKEUP_TERM.YEARLY_TAG%type
   ) RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM GIIS_TAKEUP_TERM a
                 WHERE UPPER (a.takeup_term) LIKE UPPER (NVL (p_takeup_term, '%'))
                   AND UPPER (a.takeup_term_desc) LIKE UPPER (NVL (p_takeup_term_desc, '%'))
                   AND UPPER (NVL(a.yearly_tag, 'N')) LIKE UPPER (NVL (p_yearly_tag, NVL(a.yearly_tag, 'N')))
                 )                   
      LOOP
         v_rec.takeup_term      := i.takeup_term;
         v_rec.takeup_term_desc := i.takeup_term_desc;
         v_rec.no_of_takeup     := i.no_of_takeup;
         v_rec.yearly_tag       := i.yearly_tag;
         v_rec.remarks          := i.remarks;
         v_rec.user_id          := i.user_id;
         v_rec.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec GIIS_TAKEUP_TERM%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_TAKEUP_TERM
         USING DUAL
         ON (takeup_term = p_rec.takeup_term)
         WHEN NOT MATCHED THEN
            INSERT (takeup_term, takeup_term_desc, no_of_takeup, yearly_tag, remarks, user_id, last_update)
            VALUES (p_rec.takeup_term, p_rec.takeup_term_desc, p_rec.no_of_takeup, p_rec.yearly_tag, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET takeup_term_desc = p_rec.takeup_term_desc,
                   no_of_takeup = p_rec.no_of_takeup,
                   yearly_tag = p_rec.yearly_tag, 
                   remarks = p_rec.remarks, 
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_takeup_term     GIIS_TAKEUP_TERM.TAKEUP_TERM%type)
   AS
   BEGIN
      DELETE FROM GIIS_TAKEUP_TERM
            WHERE takeup_term = p_takeup_term;
   END;

   PROCEDURE val_del_rec (p_takeup_term     GIIS_TAKEUP_TERM.TAKEUP_TERM%type)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      NULL;
   END;

   PROCEDURE val_add_rec(
        p_takeup_term           GIIS_TAKEUP_TERM.TAKEUP_TERM%type,
        p_takeup_term_desc      GIIS_TAKEUP_TERM.TAKEUP_TERM_DESC%type
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_TAKEUP_TERM a
                 WHERE a.takeup_term = p_takeup_term)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same takeup_term.'
                                 );
      END IF;
      
      v_exists := 'N'; 
      
      FOR i IN (SELECT '1'
                  FROM GIIS_TAKEUP_TERM a
                 WHERE a.takeup_term_desc = p_takeup_term_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same takeup_term_desc.'
                                 );
      END IF;
   END;
   
END GIISS211_PKG;
/


