DROP PROCEDURE CPI.VALIDATE_PREMIUM_AMOUNT;

CREATE OR REPLACE PROCEDURE CPI.Validate_Premium_Amount (
   p_par_id       IN       NUMBER,
   p_line_cd      IN       VARCHAR2,
   v_indicator    OUT      NUMBER,
   v_prem         OUT      NUMBER,
   v_total_prem   OUT      NUMBER
)
IS
   v_subline_cd             GIIS_SUBLINE.subline_cd%TYPE;
   v_min_prem_amt_line      GIIS_LINE.min_prem_amt%TYPE;
   v_min_prem_amt_subline   GIIS_SUBLINE.min_prem_amt%TYPE;
BEGIN
   SELECT subline_cd
     INTO v_subline_cd
     FROM GIPI_WPOLBAS
    WHERE par_id = p_par_id;

   SELECT NVL (min_prem_amt, 0)
     INTO v_min_prem_amt_line
     FROM GIIS_LINE
    WHERE line_cd = p_line_cd;

   SELECT NVL (min_prem_amt, 0)
     INTO v_min_prem_amt_subline
     FROM GIIS_SUBLINE
    WHERE line_cd = p_line_cd AND subline_cd = v_subline_cd;

   /*IF v_min_prem_amt_line > v_min_prem_amt_subline
   THEN
      v_prem := v_min_prem_amt_line;
   ELSIF v_min_prem_amt_subline > v_min_prem_amt_line
   THEN
      v_prem := v_min_prem_amt_subline;
   ELSE
      v_prem := v_min_prem_amt_line;
   END IF; */ -- analyn 03.22.2010

   IF v_min_prem_amt_subline != 0 THEN
   	  v_prem := v_min_prem_amt_subline;
   ELSE
   	  v_prem := v_min_prem_amt_line;
   END IF;

   v_total_prem := 0;

   FOR i IN (SELECT a.prem_amt * b.currency_rt prem_amt
               FROM GIPI_WITMPERL a, GIPI_WITEM b
              WHERE a.par_id = b.par_id
                AND a.item_no = b.item_no
                AND a.par_id = p_par_id)
   LOOP
      v_total_prem := v_total_prem + i.prem_amt;
   END LOOP;

   IF v_total_prem < v_prem
   THEN
      v_indicator := 0;
   ELSE
      v_indicator := 1;
   END IF;
END;
/


