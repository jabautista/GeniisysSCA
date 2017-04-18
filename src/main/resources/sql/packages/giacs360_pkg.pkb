CREATE OR REPLACE PACKAGE BODY CPI.giacs360_pkg
AS
   FUNCTION get_year_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.year, a.month
                  FROM giac_prod_budget a
              ORDER BY a.year,TO_DATE(a.month,'MONTH')
                   )                   
      LOOP
         v_rec.year         := i.year;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;      

   FUNCTION get_month_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT 'JANUARY' months
                  FROM DUAL
                UNION ALL
                SELECT 'FEBRUARY' months
                  FROM DUAL
                UNION ALL
                SELECT 'MARCH' months
                  FROM DUAL
                UNION ALL
                SELECT 'APRIL' months
                  FROM DUAL
                UNION ALL
                SELECT 'MAY' months
                  FROM DUAL
                UNION ALL
                SELECT 'JUNE' months
                  FROM DUAL
                UNION ALL
                SELECT 'JULY' months
                  FROM DUAL
                UNION ALL
                SELECT 'AUGUST' months
                  FROM DUAL
                UNION ALL
                SELECT 'SEPTEMBER' months
                  FROM DUAL
                UNION ALL
                SELECT 'OCTOBER' months
                  FROM DUAL
                UNION ALL
                SELECT 'NOVEMBER' months
                  FROM DUAL
                UNION ALL
                SELECT 'DECEMBER' months
                  FROM DUAL
                   )                   
      LOOP
         v_rec.month        := i.months;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;      

   FUNCTION get_iss_rec_list (
      p_user_id     giac_prod_budget.user_id%TYPE
   )
      RETURN iss_tab PIPELINED
   IS 
      v_rec  iss_type;
   BEGIN
      FOR i IN (SELECT a.iss_cd, a.iss_name
                  FROM giis_issource a
                 WHERE check_user_per_iss_cd_acctg2(NULL, iss_cd, 'GIACS360', p_user_id) = 1
               )                   
      LOOP
		 v_rec.iss_cd   := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;   

   FUNCTION get_line_rec_list (
      p_user_id    giac_prod_budget.user_id%TYPE,
      p_iss_cd     giis_issource.iss_cd%TYPE
   )
      RETURN line_tab PIPELINED
   IS 
      v_rec  line_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.line_name
                  FROM giis_line a
                 WHERE check_user_per_line2(line_cd, p_iss_cd, 'GIACS360', p_user_id) = 1 
               )                   
      LOOP
		 v_rec.line_cd   := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;     

   FUNCTION get_year_month_rec_list (
      p_user_id    giac_prod_budget.user_id%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.year, a.month
                  FROM giac_prod_budget a
                 --WHERE check_user_per_line2(a.line_cd, a.iss_cd, 'GIACS360', p_user_id) = 1 
                   --AND check_user_per_iss_cd_acctg2(a.line_cd, a.iss_cd, 'GIACS360', p_user_id) = 1
               )                   
      LOOP
         v_rec.year         := i.year;
         v_rec.month        := i.month;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
       
   FUNCTION get_rec_list (
      p_year      giac_prod_budget.year%TYPE,
      p_month     giac_prod_budget.month%TYPE,
      p_user_id   giac_prod_budget.user_id%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.year, a.month, a.iss_cd, a.line_cd, 
                       a.budget, a.user_id, a.last_update
                  FROM giac_prod_budget a
                 WHERE a.year = p_year
                   AND a.month = p_month
                   AND check_user_per_line2(line_cd, iss_cd, 'GIACS360', p_user_id) = 1 
                   AND check_user_per_iss_cd_acctg2(line_cd, iss_cd, 'GIACS360', p_user_id) = 1
                 ORDER BY a.iss_cd
                   )                   
      LOOP
         v_rec.year         := i.year;
         v_rec.month        := i.month;
         v_rec.iss_cd       := i.iss_cd;
         v_rec.line_cd      := i.line_cd;
         v_rec.budget       := i.budget;
         v_rec.user_id      := i.user_id;
         v_rec.last_update  := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         BEGIN
            SELECT iss_name
              INTO v_rec.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         END;
         
         BEGIN
            SELECT line_name
              INTO v_rec.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         END;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_prod_budget%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_prod_budget
         USING DUAL
         ON (year = p_rec.year
         AND month = p_rec.month
         AND iss_cd = p_rec.iss_cd
         AND line_cd = p_rec.line_cd)
         WHEN NOT MATCHED THEN
            INSERT (year, month, iss_cd, line_cd, budget, user_id, last_update)
            VALUES (p_rec.year, p_rec.month, p_rec.iss_cd, p_rec.line_cd, 
                    p_rec.budget, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET budget = p_rec.budget, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
      p_year    giac_prod_budget.year%TYPE,
      p_month   giac_prod_budget.month%TYPE,
      p_iss_cd  giac_prod_budget.iss_cd%TYPE,
      p_line_cd giac_prod_budget.line_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_prod_budget
            WHERE year = p_year
              AND month = p_month
              AND iss_cd = p_iss_cd
              AND line_cd = p_line_cd;
   END;

   PROCEDURE val_del_rec (p_iss_cd giac_prod_budget.iss_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
    NULL;
   END;

   PROCEDURE val_add_year_rec (
      p_year    giac_prod_budget.year%TYPE,
      p_month   giac_prod_budget.month%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_prod_budget a
                 WHERE year = p_year
                   AND month = p_month)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same year and month.'
                                 );
      END IF;
   END;
      
   PROCEDURE val_add_rec (
      p_year    giac_prod_budget.year%TYPE,
      p_month   giac_prod_budget.month%TYPE,
      p_iss_cd  giac_prod_budget.iss_cd%TYPE,
      p_line_cd giac_prod_budget.line_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_prod_budget a
                 WHERE year = p_year
                   AND month = p_month
                   AND iss_cd = p_iss_cd
                   AND line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same year, month, iss_cd, and line_cd.'
                                 );
      END IF;
   END;
END;
/


