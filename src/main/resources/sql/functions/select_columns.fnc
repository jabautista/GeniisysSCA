DROP FUNCTION CPI.SELECT_COLUMNS;

CREATE OR REPLACE FUNCTION CPI.select_columns (p_col_no NUMBER)
   RETURN VARCHAR
AS
   v_select_cols   VARCHAR2 (4000);
BEGIN
   IF p_col_no = 1 THEN
      v_select_cols := ',col_no1 ' || csv_soa.get_col_title (1);
   ELSIF p_col_no = 2 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2);
   ELSIF p_col_no = 3 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3);                
   ELSIF p_col_no = 4 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4);
   ELSIF p_col_no = 5 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5);
   ELSIF p_col_no = 6 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6);
   ELSIF p_col_no = 7 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no4 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7);   
   ELSIF p_col_no = 8 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8);
   ELSIF p_col_no = 9 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8)||'
             ,col_no9 '|| csv_soa.get_col_title (9);
   ELSIF p_col_no = 10 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8)||'
             ,col_no9 '|| csv_soa.get_col_title (9)|| ',col_no10 '|| csv_soa.get_col_title (10);
   ELSIF p_col_no = 11 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8)||'
             ,col_no9 '|| csv_soa.get_col_title (9)|| ',col_no10 '|| csv_soa.get_col_title (10)||'
             ,col_no11 '|| csv_soa.get_col_title (11);
   ELSIF p_col_no = 12 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8)||'
             ,col_no9 '|| csv_soa.get_col_title (9)|| ',col_no10 '|| csv_soa.get_col_title (10)||'
             ,col_no11 '|| csv_soa.get_col_title (11)|| ',col_no12 '|| csv_soa.get_col_title (12);
   ELSIF p_col_no = 13 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8)||'
             ,col_no9 '|| csv_soa.get_col_title (9)|| ',col_no10 '|| csv_soa.get_col_title (10)||'
             ,col_no11 '|| csv_soa.get_col_title (11)|| ',col_no12 '|| csv_soa.get_col_title (12)||'
             ,col_no13 '|| csv_soa.get_col_title (13);                                                                              
   ELSIF p_col_no = 14 THEN
      v_select_cols :=
            ',col_no1 '|| csv_soa.get_col_title (1)|| ',col_no2 '|| csv_soa.get_col_title (2)||'
             ,col_no3 '|| csv_soa.get_col_title (3)|| ',col_no4 '|| csv_soa.get_col_title (4)||'
             ,col_no5 '|| csv_soa.get_col_title (5)|| ',col_no6 '|| csv_soa.get_col_title (6)||'
             ,col_no7 '|| csv_soa.get_col_title (7)|| ',col_no8 '|| csv_soa.get_col_title (8)||'
             ,col_no9 '|| csv_soa.get_col_title (9)|| ',col_no10 '|| csv_soa.get_col_title (10)||'
             ,col_no11 '|| csv_soa.get_col_title (11)|| ',col_no12 '|| csv_soa.get_col_title (12)||'
             ,col_no13 '|| csv_soa.get_col_title (13)|| ',col_no14 '|| csv_soa.get_col_title (14);                                                
   END IF;

   RETURN (v_select_cols);
END;
/


