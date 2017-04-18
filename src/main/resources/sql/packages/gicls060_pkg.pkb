CREATE OR REPLACE PACKAGE BODY CPI.GICLS060_PKG
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
      SELECT a.le_stat_cd, a.le_stat_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM gicl_le_stat a
                 ORDER BY a.le_stat_cd
                   )                   
      LOOP
         v_rec.le_stat_cd     := i.le_stat_cd;  
         v_rec.le_stat_desc   := i.le_stat_desc;
         v_rec.remarks        := i.remarks;
         v_rec.user_id        := i.user_id;
         v_rec.last_update    := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec gicl_le_stat%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GICL_LE_STAT
         USING DUAL
         ON (le_stat_cd = p_rec.le_stat_cd)
         WHEN NOT MATCHED THEN
            INSERT (le_stat_cd, le_stat_desc, remarks, user_id, last_update)
            VALUES (p_rec.le_stat_cd, p_rec.le_stat_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET le_stat_desc = p_rec.le_stat_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_le_stat_cd gicl_le_stat.le_stat_cd%TYPE)
   AS
   BEGIN
      DELETE FROM GICL_LE_STAT
            WHERE le_stat_cd = p_le_stat_cd;
   END;

   FUNCTION val_del_rec (p_le_stat_cd gicl_le_stat.le_stat_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
          FOR a IN (
              SELECT 1
                FROM gicl_clm_loss_exp
               WHERE item_stat_cd = p_le_stat_cd
        )
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (p_le_stat_cd gicl_le_stat.le_stat_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GICL_LE_STAT a
                 WHERE a.le_stat_cd = p_le_stat_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same le_stat_cd.'
                                 );
      END IF;
   END;
END;
/


