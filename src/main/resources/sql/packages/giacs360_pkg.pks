CREATE OR REPLACE PACKAGE CPI.giacs360_pkg
AS
   TYPE rec_type IS RECORD (
      year        giac_prod_budget.year%TYPE,
      month       giac_prod_budget.month%TYPE,
      iss_cd      giac_prod_budget.iss_cd%TYPE,
      iss_name    giis_issource.iss_name%TYPE,
      line_cd     giac_prod_budget.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE,
      budget      giac_prod_budget.budget%TYPE,
      user_id     giac_prod_budget.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE iss_type IS RECORD (
      iss_cd      giac_prod_budget.iss_cd%TYPE,
      iss_name    giis_issource.iss_name%TYPE
   ); 

   TYPE iss_tab IS TABLE OF iss_type;

   TYPE line_type IS RECORD (
      line_cd     giac_prod_budget.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   ); 

   TYPE line_tab IS TABLE OF line_type;   
   
   FUNCTION get_year_rec_list
      RETURN rec_tab PIPELINED;

   FUNCTION get_month_rec_list
      RETURN rec_tab PIPELINED; 

   FUNCTION get_iss_rec_list (
      p_user_id   giac_prod_budget.user_id%TYPE
   )
      RETURN iss_tab PIPELINED;

   FUNCTION get_line_rec_list (
      p_user_id   giac_prod_budget.user_id%TYPE,
      p_iss_cd     giis_issource.iss_cd%TYPE
   )
      RETURN line_tab PIPELINED;

   FUNCTION get_year_month_rec_list (
      p_user_id   giac_prod_budget.user_id%TYPE
   )
      RETURN rec_tab PIPELINED;
            
   FUNCTION get_rec_list (
      p_year      giac_prod_budget.year%TYPE,
      p_month     giac_prod_budget.month%TYPE,
      p_user_id   giac_prod_budget.user_id%TYPE
   )
      RETURN rec_tab PIPELINED;           

   PROCEDURE set_rec (p_rec giac_prod_budget%ROWTYPE);

   PROCEDURE del_rec (
      p_year    giac_prod_budget.year%TYPE,
      p_month   giac_prod_budget.month%TYPE,
      p_iss_cd  giac_prod_budget.iss_cd%TYPE,
      p_line_cd giac_prod_budget.line_cd%TYPE
   );

   PROCEDURE val_del_rec (p_iss_cd giac_prod_budget.iss_cd%TYPE);

   PROCEDURE val_add_year_rec (
      p_year    giac_prod_budget.year%TYPE,
      p_month   giac_prod_budget.month%TYPE
   );
      
   PROCEDURE val_add_rec (
      p_year    giac_prod_budget.year%TYPE,
      p_month   giac_prod_budget.month%TYPE,
      p_iss_cd  giac_prod_budget.iss_cd%TYPE,
      p_line_cd giac_prod_budget.line_cd%TYPE
   );
   
END;
/


