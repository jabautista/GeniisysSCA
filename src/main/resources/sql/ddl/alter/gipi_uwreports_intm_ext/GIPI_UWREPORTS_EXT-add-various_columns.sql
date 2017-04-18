SET SERVEROUTPUT ON

DECLARE
   TYPE col_type IS RECORD (
      column_name   all_tab_cols.column_name%TYPE,
      data_type     all_tab_cols.data_type%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   rec_tab        col_tab          := col_tab ();
   rec_type       col_type;
   v_col_exists   NUMBER           := 0;
BEGIN
   BEGIN
      rec_tab.EXTEND (16);
      rec_type.column_name := 'WHOLDING_TAX';
      rec_type.data_type := 'NUMBER(12,2)';
      rec_tab (1) := rec_type;
      rec_type.column_name := 'ENDT_TYPE';
      rec_type.data_type := 'VARCHAR2(1 BYTE)';
      rec_tab (2) := rec_type;
      rec_type.column_name := 'PREM_TAX';
      rec_type.data_type := 'NUMBER(12,2)';
      rec_tab (3) := rec_type;
      rec_type.column_name := 'REC_TYPE';
      rec_type.data_type := 'VARCHAR2(1 BYTE)';
      rec_tab (4) := rec_type;
      rec_type.column_name := 'REINSTATE_TAG';
      rec_type.data_type := 'VARCHAR2(1 BYTE)';
      rec_tab (5) := rec_type;
      rec_type.column_name := 'TAB_NUMBER';
      rec_type.data_type := 'NUMBER(1)';
      rec_tab (6) := rec_type;
      rec_type.column_name := 'PREM_SEQ_NO';
      rec_type.data_type := 'NUMBER(12)';
      rec_tab (7) := rec_type;
      rec_type.column_name := 'REF_INV_NO';
      rec_type.data_type := 'VARCHAR2(30 BYTE)';
      rec_tab (8) := rec_type;
      rec_type.column_name := 'VAT';
      rec_type.data_type := 'NUMBER(12,2)';
      rec_tab (9) := rec_type;
      rec_type.column_name := 'MULTI_BOOKING_MM';
      rec_type.data_type := 'VARCHAR2(10 BYTE)';
      rec_tab (10) := rec_type;
      rec_type.column_name := 'MULTI_BOOKING_YY';
      rec_type.data_type := 'NUMBER(4)';
      rec_tab (11) := rec_type;
      rec_type.column_name := 'REG_POLICY_SW';
      rec_type.data_type := 'VARCHAR2(1)';
      rec_tab (12) := rec_type;
      rec_type.column_name := 'ITEM_GRP';
      rec_type.data_type := 'NUMBER(5)';
      rec_tab (13) := rec_type;
      rec_type.column_name := 'TAKEUP_SEQ_NO';
      rec_type.data_type := 'NUMBER (3)';
      rec_tab (14) := rec_type;
      rec_type.column_name := 'EFF_DATE';
      rec_type.data_type := 'DATE';
      rec_tab (15) := rec_type;
      rec_type.column_name := 'CURRENCY_RT';
      rec_type.data_type := 'NUMBER (12,9)';
      rec_tab (16) := rec_type;
   END;

   FOR i IN 1 .. rec_tab.COUNT
   LOOP
      v_col_exists := 0;

      BEGIN
         SELECT 1
           INTO v_col_exists
           FROM all_tab_cols
          WHERE table_name = 'GIPI_UWREPORTS_EXT'
            AND owner = 'CPI'
            AND column_name = rec_tab (i).column_name;

         IF v_col_exists = 1
         THEN
            DBMS_OUTPUT.put_line (   rec_tab (i).column_name
                                  || ' already exists in GIPI_UWREPORTS_EXT'
                                 );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXECUTE IMMEDIATE (   'ALTER TABLE CPI.GIPI_UWREPORTS_EXT ADD '
                               || rec_tab (i).column_name
                               || ' '
                               || rec_tab (i).data_type
                              );

            DBMS_OUTPUT.put_line (   rec_tab (i).column_name
                                  || ' has been added to GIPI_UWREPORTS_EXT'
                                 );
      END;
   END LOOP;
END;