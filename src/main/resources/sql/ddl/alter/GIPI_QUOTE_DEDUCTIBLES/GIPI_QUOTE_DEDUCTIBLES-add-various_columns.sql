/* Formatted on 2015/12/09 13:30 (Formatter Plus v4.8.8) */
SET SERVEROUTPUT ON;

DECLARE
   TYPE col_type IS RECORD (
      column_name   all_tab_cols.column_name%TYPE,
      data_type     all_tab_cols.data_type%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   rec_tab        col_tab  := col_tab ();
   rec_type       col_type;
   v_col_exists   NUMBER   := 0;
BEGIN
   BEGIN
      rec_tab.EXTEND (9);
      rec_type.column_name := 'DED_LINE_CD';
      rec_type.data_type := 'VARCHAR2(2 BYTE)';
      rec_tab (1) := rec_type;
      rec_type.column_name := 'DED_SUBLINE_CD';
      rec_type.data_type := 'VARCHAR2(7 BYTE)';
      rec_tab (2) := rec_type;
      rec_type.column_name := 'AGGREGATE_SW';
      rec_type.data_type := 'VARCHAR2(1 BYTE)';
      rec_tab (3) := rec_type;
      rec_type.column_name := 'CEILING_SW';
      rec_type.data_type := 'VARCHAR2(1 BYTE)';
      rec_tab (4) := rec_type;
      rec_type.column_name := 'CREATE_DATE';
      rec_type.data_type := 'DATE';
      rec_tab (5) := rec_type;
      rec_type.column_name := 'CREATE_USER';
      rec_type.data_type := 'VARCHAR2(8 BYTE)';
      rec_tab (6) := rec_type;
      rec_type.column_name := 'MAX_AMT';
      rec_type.data_type := 'NUMBER(12,2)';
      rec_tab (7) := rec_type;
      rec_type.column_name := 'MIN_AMT';
      rec_type.data_type := 'NUMBER(12,2)';
      rec_tab (8) := rec_type;
      rec_type.column_name := 'RANGE_SW';
      rec_type.data_type := 'VARCHAR2(8BYTE)';
      rec_tab (9) := rec_type;
   END;

   FOR i IN 1 .. rec_tab.COUNT
   LOOP
      v_col_exists := 0;

      BEGIN
         SELECT 1
           INTO v_col_exists
           FROM all_tab_cols
          WHERE table_name = 'GIPI_QUOTE_DEDUCTIBLES'
            AND owner = 'CPI'
            AND column_name = rec_tab (i).column_name;

         IF v_col_exists = 1
         THEN
            DBMS_OUTPUT.put_line (   rec_tab (i).column_name
                                  || ' already exists in GIPI_QUOTE_DEDUCTIBLES'
                                 );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXECUTE IMMEDIATE (   'ALTER TABLE CPI.GIPI_QUOTE_DEDUCTIBLES ADD '
                               || rec_tab (i).column_name
                               || ' '
                               || rec_tab (i).data_type
                              );

            DBMS_OUTPUT.put_line (   rec_tab (i).column_name
                                  || ' has been added to GIPI_QUOTE_DEDUCTIBLES'
                                 );
      END;
   END LOOP;
END;