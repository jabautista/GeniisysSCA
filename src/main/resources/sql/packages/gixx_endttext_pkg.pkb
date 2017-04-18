CREATE OR REPLACE PACKAGE BODY CPI.GIXX_ENDTTEXT_PKG AS

   FUNCTION get_pol_doc_endttext
     RETURN pol_doc_endttext_tab PIPELINED IS

     v_endttext pol_doc_endttext_type;

   BEGIN
     FOR i IN (
        SELECT extract_id      extract_id6,
            -- endt_text    endttext_endt_text
               endt_text01    endttext_endt_text
          FROM GIXX_ENDTTEXT)
     LOOP
        v_endttext.extract_id6         := i.extract_id6;
        v_endttext.endttext_endt_text  := i.endttext_endt_text;
       PIPE ROW(v_endttext);
     END LOOP;
     RETURN;
   END get_pol_doc_endttext;

END GIXX_ENDTTEXT_PKG;
/


