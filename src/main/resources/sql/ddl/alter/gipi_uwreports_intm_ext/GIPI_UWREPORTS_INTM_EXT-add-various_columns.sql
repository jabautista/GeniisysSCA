SET SERVEROUTPUT ON

DECLARE
   TYPE addtl_cols IS RECORD
   (
      column_name   VARCHAR2 (100),
      data_type     VARCHAR2 (100)
   );

   TYPE addtlcol_tbl IS TABLE OF addtl_cols;

   v_exists   VARCHAR2 (1);
   v_addtl    addtlcol_tbl;
BEGIN
   v_addtl := addtlcol_tbl ();
   v_addtl.EXTEND (6);
   v_addtl (1).column_name := 'REC_TYPE';
   v_addtl (1).data_type := 'VARCHAR2 (1)';
   v_addtl (2).column_name := 'WHOLDING_TAX';
   v_addtl (2).data_type := 'NUMBER(12,2)';
   v_addtl (3).column_name := 'VAT';
   v_addtl (3).data_type := 'NUMBER(12,2)';
   v_addtl (4).column_name := 'PREM_TAX';
   v_addtl (4).data_type := 'NUMBER(12,2)';
   v_addtl (5).column_name := 'PREM_SEQ_NO';
   v_addtl (5).data_type := 'NUMBER(12)';
   v_addtl (6).column_name := 'REF_INV_NO';
   v_addtl (6).data_type := 'VARCHAR2 (30)';

   FOR idx IN v_addtl.FIRST .. v_addtl.LAST
   LOOP
      v_exists := 'Y';

      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM all_tab_cols
          WHERE     1 = 1
                AND column_name = v_addtl (idx).column_name
                AND owner = 'CPI'
                AND table_name = 'GIPI_UWREPORTS_INTM_EXT';

         DBMS_OUTPUT.put_line (
               'The column '
            || v_addtl (idx).column_name
            || ' already exists in GIPI_UWREPORTS_INTM_EXT ');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exists := 'N';
      END;

      IF v_exists = 'N'
      THEN
         EXECUTE IMMEDIATE
            (   'ALTER TABLE CPI.GIPI_UWREPORTS_INTM_EXT ADD '
             || v_addtl (idx).column_name
             || ' '
             || v_addtl (idx).data_type);

         DBMS_OUTPUT.put_line (
               v_addtl (idx).column_name
            || ' has been added to GIPI_UWREPORTS_INTM_EXT');
      END IF;
   END LOOP;
END;