CREATE OR REPLACE PACKAGE BODY CPI.giacs308_pkg
AS
   FUNCTION get_sl_type_list(
      p_sl_type_cd           giac_sl_types.sl_type_cd%TYPE,
      p_sl_type_name         giac_sl_types.sl_type_name%TYPE,
      p_dsp_sl_tag_meaning   cg_ref_codes.rv_meaning%TYPE
   )
      RETURN sl_type_tab PIPELINED
   IS
      v_rec   sl_type_type; 
   BEGIN
      FOR i IN (SELECT a.sl_type_cd, a.sl_type_name, a.sl_tag, b.rv_meaning dsp_sl_tag_meaning,
                       a.remarks, a.user_id, a.last_update
                  FROM giac_sl_types a, cg_ref_codes b
                 WHERE a.sl_tag = b.rv_low_value 
                   AND b.rv_domain = 'GIAC_SL_TYPES.SL_TAG'
                   AND UPPER(a.sl_type_cd) LIKE UPPER(NVL(p_sl_type_cd, '%'))
                   AND UPPER(a.sl_type_name) LIKE UPPER(NVL(p_sl_type_name, '%'))
                   AND UPPER(b.rv_meaning) LIKE UPPER(NVL(p_dsp_sl_tag_meaning, '%'))
                   )
      LOOP
         v_rec.sl_type_cd := i.sl_type_cd;
         v_rec.sl_type_name := i.sl_type_name;
         v_rec.sl_tag := i.sl_tag; 
         v_rec.dsp_sl_tag_meaning := i.dsp_sl_tag_meaning;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_sl_type (p_rec giac_sl_types%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_sl_types
         USING DUAL
         ON (sl_type_cd = p_rec.sl_type_cd)
         WHEN NOT MATCHED THEN
            INSERT (sl_type_cd, sl_type_name, user_id, last_update, sl_tag, remarks)
            VALUES (p_rec.sl_type_cd, p_rec.sl_type_name, p_rec.user_id, SYSDATE, p_rec.sl_tag,
                    p_rec.remarks)
         WHEN MATCHED THEN
            UPDATE
               SET sl_type_name = p_rec.sl_type_name, user_id = p_rec.user_id,
                   last_update = SYSDATE, sl_tag = p_rec.sl_tag, remarks = p_rec.remarks
            ;
   END;

   PROCEDURE val_delete_sl_type (p_sl_type_cd giac_sl_types.sl_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_chart_of_accts
                 WHERE gslt_sl_type_cd = p_sl_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete GIAC_SL_TYPES while dependent GIAC_CHART_OF_ACCTS exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_sl_lists
                 WHERE sl_type_cd = p_sl_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete GIAC_SL_TYPES while dependent GIAC_SL_LISTS exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_sl_type_cd giac_sl_types.sl_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_sl_types a
                 WHERE a.sl_type_cd = p_sl_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#There is already an existing record with SL Type Code of ' || p_sl_type_cd || '. Please re-enter.'
                                 );
      END IF;
   END;

   PROCEDURE del_sl_type (p_sl_type_cd giac_sl_types.sl_type_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giac_sl_types
            WHERE sl_type_cd = p_sl_type_cd;
   END;
END;
/


