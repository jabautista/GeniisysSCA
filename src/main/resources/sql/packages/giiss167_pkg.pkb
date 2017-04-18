CREATE OR REPLACE PACKAGE BODY CPI.giiss167_pkg
AS
   FUNCTION get_giisdspcolumn_list (
      p_dsp_col_id    giis_dsp_column.dsp_col_id%TYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   )
      RETURN giisdspcolumn_tab PIPELINED
   IS
      v_rec   giisdspcolumn_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_dsp_column a
                   WHERE dsp_col_id = p_dsp_col_id
                     AND UPPER (a.table_name) LIKE UPPER (NVL (p_table_name, '%'))
                     AND UPPER (a.column_name) LIKE UPPER (NVL (p_column_name, '%'))
                ORDER BY 1)
      LOOP
         v_rec.dsp_col_id := i.dsp_col_id;
         v_rec.table_name := i.table_name;
         v_rec.old_table_name := i.table_name;
         v_rec.column_name := i.column_name;
         v_rec.old_column_name := i.column_name;
         v_rec.user_id := i.user_id;
         v_rec.database_tag := 'Y';
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_column_lov (p_keyword VARCHAR2)
      RETURN columnlov_tab PIPELINED
   IS
      v_list   columnlov_type;
   BEGIN
      FOR i IN (SELECT rv_low_value, rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIIS_DSP_COLUMN.DSP_COL_ID'
                   AND (TO_CHAR(rv_low_value) LIKE NVL(p_keyword, '%')
                    OR  rv_meaning LIKE NVL(p_keyword, '%'))
                 ORDER BY 1)
      LOOP
         v_list.col_id := i.rv_low_value;
         v_list.col_name := i.rv_meaning;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_tablename_lov (
      p_keyword       VARCHAR2,
      p_column_name   all_tab_cols.column_name%TYPE
   )
      RETURN tablename_tab PIPELINED
   IS
      v_list   tablename_type;
   BEGIN
      FOR i IN (SELECT DISTINCT table_name
                  FROM all_tab_cols
                 WHERE owner = 'CPI'
                   AND hidden_column = 'NO'
                   AND UPPER(table_name) LIKE UPPER(NVL(p_keyword, '%'))
                   AND column_name = NVL(p_column_name, column_name)
                 ORDER BY table_name)
      LOOP
         v_list.table_name := i.table_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_columnname_lov (
      p_keyword      VARCHAR2,
      p_table_name   all_tab_cols.table_name%TYPE,
      p_dsp_col_id   giis_dsp_column.dsp_col_id%TYPE
   )
      RETURN columnname_tab PIPELINED
   IS
      v_list   columnname_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.column_name
                  FROM all_tab_cols b
                 WHERE owner = 'CPI'
                   AND hidden_column = 'NO'
                   AND table_name = NVL(p_table_name, table_name)
                   AND UPPER(column_name) LIKE UPPER(NVL(p_keyword, '%'))
                   /*AND NOT EXISTS (
                                   SELECT 1
                                     FROM giis_dsp_column a
                                    WHERE 1 = 1
                                      AND a.table_name = b.table_name
                                      AND a.column_name = b.column_name
                                      AND dsp_col_id = p_dsp_col_id
                                  )*/
                 ORDER BY b.column_name)
      LOOP
         v_list.column_name := i.column_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (
      p_dsp_col_id    giis_dsp_column.dsp_col_id%TYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   )
   AS
      v_check   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_dsp_column a
                 WHERE a.dsp_col_id = p_dsp_col_id
                   AND a.table_name = p_table_name
                   AND a.column_name = p_column_name)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same table_name and column_name.'
            );
      END LOOP;

      FOR a IN (SELECT 1
                  FROM all_tab_columns
                 WHERE table_name = p_table_name
                   AND column_name = p_column_name)
      LOOP
         v_check := 'Y';
         EXIT;
      END LOOP;

      IF v_check = 'N'
      THEN
         raise_application_error (-20001,
                                     'Geniisys Exception#E#Column '
                                  || p_column_name
                                  || ' does not exists in '
                                  || p_table_name
                                  || '.'
                                 );
      END IF;
   END;

   PROCEDURE set_rec (
      p_rec           giis_dsp_column%ROWTYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   )
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_dsp_column
                 WHERE dsp_col_id = p_rec.dsp_col_id
                   AND table_name = p_table_name
                   AND column_name = p_column_name)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_dsp_column
            SET table_name = p_rec.table_name,
                column_name = p_rec.column_name,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE dsp_col_id = p_rec.dsp_col_id
            AND table_name = p_table_name
            AND column_name = p_column_name;
      ELSE
         INSERT INTO giis_dsp_column
                     (dsp_col_id, table_name, column_name,
                      user_id, last_update
                     )
              VALUES (p_rec.dsp_col_id, p_rec.table_name, p_rec.column_name,
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_dsp_col_id    giis_dsp_column.dsp_col_id%TYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_dsp_column
            WHERE dsp_col_id = p_dsp_col_id
              AND table_name = p_table_name
              AND column_name = p_column_name;
   END;
END;
/


