CREATE OR REPLACE PACKAGE BODY CPI.giacs323_pkg
AS
   FUNCTION get_rec_list (
      p_jv_tran_cd     giac_jv_trans.jv_tran_cd%TYPE,
      p_jv_tran_desc   giac_jv_trans.jv_tran_desc%TYPE,
      p_jv_tran_tag    giac_jv_trans.jv_tran_tag%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.jv_tran_cd, a.jv_tran_desc, a.jv_tran_tag, a.remarks, a.user_id,
                       a.last_update
                  FROM giac_jv_trans a
                 WHERE UPPER (a.jv_tran_cd) LIKE UPPER (NVL (p_jv_tran_cd, '%'))
                   AND UPPER (a.jv_tran_desc) LIKE UPPER (NVL (p_jv_tran_desc, '%'))
                   AND DECODE(a.jv_tran_tag, 'C', 'CASH', 'NON-CASH') LIKE UPPER (NVL (p_jv_tran_tag, '%'))
                 ORDER BY a.jv_tran_cd
                   )                   
      LOOP
         v_rec.jv_tran_cd := i.jv_tran_cd;
         v_rec.jv_tran_desc := i.jv_tran_desc;
         v_rec.jv_tran_tag := i.jv_tran_tag;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_jv_trans%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_jv_trans
         USING DUAL
         ON (jv_tran_cd = p_rec.jv_tran_cd)
         WHEN NOT MATCHED THEN
            INSERT (jv_tran_cd, jv_tran_desc, jv_tran_tag, remarks, user_id, last_update)
            VALUES (p_rec.jv_tran_cd, p_rec.jv_tran_desc, p_rec.jv_tran_tag, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET jv_tran_desc = p_rec.jv_tran_desc, jv_tran_tag = p_rec.jv_tran_tag,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_jv_tran_cd giac_jv_trans.jv_tran_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giac_jv_trans
            WHERE jv_tran_cd = p_jv_tran_cd;
   END;

   PROCEDURE val_del_rec (p_jv_tran_cd giac_jv_trans.jv_tran_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      NULL;
   END;

   PROCEDURE val_add_rec (p_jv_tran_cd giac_jv_trans.jv_tran_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_jv_trans a
                 WHERE a.jv_tran_cd = p_jv_tran_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Row exists already with same Tran Code.'
                                 );
      END IF;
   END;
END;
/


