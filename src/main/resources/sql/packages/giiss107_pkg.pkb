CREATE OR REPLACE PACKAGE BODY CPI.giiss107_pkg
AS
   FUNCTION get_rec_list (
      p_accessory_cd     giis_accessory.accessory_cd%TYPE,
      p_accessory_desc   giis_accessory.accessory_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.accessory_cd, a.accessory_desc, a.acc_amt, a.remarks,
                   a.user_id, a.last_update
              FROM giis_accessory a
             WHERE UPPER (a.accessory_cd) =
                                         NVL (p_accessory_cd, a.accessory_cd)
               AND UPPER (a.accessory_desc) LIKE
                                           UPPER (NVL (p_accessory_desc, '%'))
          ORDER BY a.accessory_cd)
      LOOP
         v_rec.accessory_cd := i.accessory_cd;
         v_rec.accessory_desc := i.accessory_desc;
         v_rec.acc_amt := i.acc_amt;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_accessory%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_accessory
         USING DUAL
         ON (accessory_cd = p_rec.accessory_cd)
         WHEN NOT MATCHED THEN
            INSERT (accessory_cd, accessory_desc, acc_amt, remarks, user_id,
                    last_update)
            VALUES (seq_nextval_on_demand ('accessory_accessory_cd_s'),
                    p_rec.accessory_desc, p_rec.acc_amt, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET accessory_desc = p_rec.accessory_desc,
                   acc_amt = p_rec.acc_amt, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_accessory_cd giis_accessory.accessory_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_accessory
            WHERE accessory_cd = p_accessory_cd;
   END;

   PROCEDURE val_del_rec (p_accessory_cd giis_accessory.accessory_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_mcacc a
                 WHERE a.accessory_cd = p_accessory_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_ACCESSORY while dependent record(s) in GIPI_MCACC exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wmcacc a
                 WHERE a.accessory_cd = p_accessory_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_ACCESSORY while dependent record(s) in GIPI_WMCACC exists.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec (p_accessory_desc giis_accessory.accessory_desc%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_accessory a
                 WHERE a.accessory_desc = p_accessory_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same accessory_desc.'
            );
         RETURN;
      END IF;
   END;
END;
/


