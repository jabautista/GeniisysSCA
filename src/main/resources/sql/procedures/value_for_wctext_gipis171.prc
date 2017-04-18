DROP PROCEDURE CPI.VALUE_FOR_WCTEXT_GIPIS171;

CREATE OR REPLACE PROCEDURE CPI.Value_For_Wctext_gipis171 (GIPI_POLWC_wc_cd      IN VARCHAR2,
	   	  		  									   GIPI_POLWC_change_tag IN VARCHAR2,
	   	  		  									   GIPI_POLWC_text_nb    IN VARCHAR2,
													   GIPI_POLWC_wc_text01 OUT VARCHAR2,
													   GIPI_POLWC_wc_text02 OUT VARCHAR2,
													   GIPI_POLWC_wc_text03 OUT VARCHAR2,
													   GIPI_POLWC_wc_text04 OUT VARCHAR2,
													   GIPI_POLWC_wc_text05 OUT VARCHAR2,
													   GIPI_POLWC_wc_text06 OUT VARCHAR2,
													   GIPI_POLWC_wc_text07 OUT VARCHAR2,
													   GIPI_POLWC_wc_text08 OUT VARCHAR2,
													   GIPI_POLWC_wc_text09 OUT VARCHAR2,
													   GIPI_POLWC_wc_text10 OUT VARCHAR2,
													   GIPI_POLWC_wc_text11 OUT VARCHAR2,
													   GIPI_POLWC_wc_text12 OUT VARCHAR2,
													   GIPI_POLWC_wc_text13 OUT VARCHAR2,
													   GIPI_POLWC_wc_text14 OUT VARCHAR2,
													   GIPI_POLWC_wc_text15 OUT VARCHAR2,
													   GIPI_POLWC_wc_text16 OUT VARCHAR2,
													   GIPI_POLWC_wc_text17 OUT VARCHAR2)
 IS
BEGIN
   IF GIPI_POLWC_wc_cd IS NOT NULL AND 
      GIPI_POLWC_change_tag = 'Y' THEN
      GIPI_POLWC_wc_text01 := SUBSTR(GIPI_POLWC_text_nb, 1,     2000);
      GIPI_POLWC_wc_text02 := SUBSTR(GIPI_POLWC_text_nb, 2001,  2000);
      GIPI_POLWC_wc_text03 := SUBSTR(GIPI_POLWC_text_nb, 4001,  2000);
      GIPI_POLWC_wc_text04 := SUBSTR(GIPI_POLWC_text_nb, 6001,  2000);
      GIPI_POLWC_wc_text05 := SUBSTR(GIPI_POLWC_text_nb, 8001,  2000);
      GIPI_POLWC_wc_text06 := SUBSTR(GIPI_POLWC_text_nb, 10001, 2000);
      GIPI_POLWC_wc_text07 := SUBSTR(GIPI_POLWC_text_nb, 12001, 2000);
      GIPI_POLWC_wc_text08 := SUBSTR(GIPI_POLWC_text_nb, 14001, 2000);
      GIPI_POLWC_wc_text09 := SUBSTR(GIPI_POLWC_text_nb, 16001, 2000);
      GIPI_POLWC_wc_text10 := SUBSTR(GIPI_POLWC_text_nb, 18001, 2000);
      GIPI_POLWC_wc_text11 := SUBSTR(GIPI_POLWC_text_nb, 20001, 2000);
      GIPI_POLWC_wc_text12 := SUBSTR(GIPI_POLWC_text_nb, 22001, 2000);
      GIPI_POLWC_wc_text13 := SUBSTR(GIPI_POLWC_text_nb, 24001, 2000);
      GIPI_POLWC_wc_text14 := SUBSTR(GIPI_POLWC_text_nb, 26001, 2000);
      GIPI_POLWC_wc_text15 := SUBSTR(GIPI_POLWC_text_nb, 28001, 2000);
      GIPI_POLWC_wc_text16 := SUBSTR(GIPI_POLWC_text_nb, 30001, 2000);
      GIPI_POLWC_wc_text17 := SUBSTR(GIPI_POLWC_text_nb, 32001, 2000);
   ELSE
      GIPI_POLWC_wc_text01 := NULL;
      GIPI_POLWC_wc_text02 := NULL;
      GIPI_POLWC_wc_text03 := NULL;
      GIPI_POLWC_wc_text04 := NULL;
      GIPI_POLWC_wc_text05 := NULL;
      GIPI_POLWC_wc_text06 := NULL;
      GIPI_POLWC_wc_text07 := NULL;
      GIPI_POLWC_wc_text08 := NULL;
      GIPI_POLWC_wc_text09 := NULL;
      GIPI_POLWC_wc_text10 := NULL;
      GIPI_POLWC_wc_text11 := NULL;
      GIPI_POLWC_wc_text12 := NULL;
      GIPI_POLWC_wc_text13 := NULL;
      GIPI_POLWC_wc_text14 := NULL;
      GIPI_POLWC_wc_text15 := NULL;
      GIPI_POLWC_wc_text16 := NULL;
      GIPI_POLWC_wc_text17 := NULL;
   END IF;
END;
/


