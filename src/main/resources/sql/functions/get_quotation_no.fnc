DROP FUNCTION CPI.GET_QUOTATION_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Quotation_No (
   v_quote_id   gipi_quote.quote_id%TYPE
)
   RETURN VARCHAR2
IS
   v_quotation_no   VARCHAR2 (50) := NULL;

   CURSOR quo (v_quote_id gipi_quote.quote_id%TYPE)
   IS
      SELECT    line_cd
             || '-'
             || subline_cd
             || '-'
             || iss_cd
             || '-'
             || LTRIM (TO_CHAR (quotation_yy, '0999'))
             || '-'
             || LTRIM (TO_CHAR (quotation_no, '0999999'))
             || '-'
             || LTRIM (TO_CHAR (proposal_no, '09')) 
             || '-'
             || status quotation            
        FROM gipi_quote
       WHERE quote_id = v_quote_id;
BEGIN
   FOR rec IN quo (v_quote_id)
   LOOP
      v_quotation_no := rec.quotation;
      EXIT;
   END LOOP rec;

   RETURN (v_quotation_no);
END Get_Quotation_No;
/


