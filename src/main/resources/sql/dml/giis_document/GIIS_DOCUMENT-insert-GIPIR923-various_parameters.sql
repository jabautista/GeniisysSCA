SET SERVEROUTPUT ON

DECLARE
   TYPE col_type IS RECORD (
      title       giis_document.title%TYPE,
      text        giis_document.text%TYPE,
      remarks     giis_document.remarks%TYPE,
      report_id   giis_document.report_id%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   rec_tab    col_tab  := col_tab ();
   rec_type   col_type;
   v_exists   NUMBER   := 0;
BEGIN
   BEGIN
      rec_tab.EXTEND (4);
      rec_type.text := 'N';
      rec_type.report_id := 'GIPIR923';
      rec_type.title := 'DISPLAY_SEPARATE_PREMTAX_VAT';
      rec_type.remarks :=
         'Parameter to control the display of EVATPREM into separate fields or into a single field. Y = Print VAT separate from Premium Tax, N = Print the sum of VAT and Prem Tax into VAT/Premium Tax column (single column).';
      rec_tab (1) := rec_type;
      rec_type.title := 'DISPLAY_WHOLDING_TAX';
      rec_type.remarks :=
         'Parameter to control the display of Withholding Tax in the Production Report for Policy/Endorsement (TAB1). Y = Print Withholding Tax, N = Do not print the Wholding Tax.';
      rec_tab (2) := rec_type;
      rec_type.title := 'PRINT_REF_INV';
      rec_type.remarks :=
         'Parameter to include the Reference Invoice in the Invoice No. field.';
      rec_tab (3) := rec_type;
      rec_type.title := 'SHOW_TOTAL_TAXES';
      rec_type.remarks :=
         'Parameter to Print Total Taxes. Y = Print Total Taxes, N = Do not print the Total Taxes.';
      rec_tab (4) := rec_type;
   END;

   FOR i IN 1 .. rec_tab.COUNT
   LOOP
      v_exists := 0;

      BEGIN
         SELECT 1
           INTO v_exists
           FROM cpi.giis_document
          WHERE title = rec_tab (i).title
                AND report_id = rec_tab (i).report_id;

         IF v_exists = 1
         THEN
            DBMS_OUTPUT.put_line (   'Title '
                                  || rec_tab (i).title
                                  || ' with report_id '
                                  || rec_tab (i).report_id
                                  || ' already exists in GIIS_DOCUMENT'
                                 );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXECUTE IMMEDIATE (   'INSERT INTO CPI.GIIS_DOCUMENT (TITLE, TEXT, REMARKS, REPORT_ID) '
                               || 'VALUES ('''
                               || rec_tab (i).title
                               || ''', '''
                               || rec_tab (i).text
                               || ''', '''
                               || rec_tab (i).remarks
                               || ''', '''
                               || rec_tab (i).report_id
                               || ''')'
                              );

            DBMS_OUTPUT.put_line (   'Title '
                                  || rec_tab (i).title
                                  || ' with report_id '
                                  || rec_tab (i).report_id
                                  || ' added in GIIS_DOCUMENT'
                                 );
      END;
   END LOOP;
END;