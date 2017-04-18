CREATE OR REPLACE PACKAGE CPI.giacs182_pkg
AS
   FUNCTION validate_date_params (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE extract_giacs182 (
      p_from_date            DATE,
      p_to_date              DATE,
      p_cut_off_date         DATE,
      p_ri_cd                NUMBER,
      p_line_cd              VARCHAR2,
      p_user_id              giis_users.user_id%TYPE,
      p_exist          OUT   VARCHAR2
   );

   PROCEDURE main_loop (p_from_date DATE, p_to_date DATE, p_cut_off_date DATE);

   PROCEDURE find_all_neg (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   );

   PROCEDURE all_neg_insert (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_usefnl_binder   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     giuw_pol_dist.negate_date%TYPE
   );

   PROCEDURE find_one_val (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   );

   PROCEDURE one_val_insert (
      p_from_date       DATE,
      p_to_date         DATE,
      p_cut_off_date    DATE,
      p_usefnl_binder   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     giuw_pol_dist.negate_date%TYPE
   );

   TYPE ri_lov_type IS RECORD (
      ri_cd     giis_reinsurer.ri_cd%TYPE,
      ri_name   giis_reinsurer.ri_name%TYPE
   );

   TYPE ri_lov_tab IS TABLE OF ri_lov_type;

   FUNCTION get_ri_lov (p_keyword VARCHAR2)
      RETURN ri_lov_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED;
      
   TYPE giacs182_variables_type IS RECORD(
      cut_off_date         VARCHAR2(50),
      from_date            VARCHAR2(50),
      to_date              VARCHAR2(50)
   );
   TYPE giacs182_variables_tab IS TABLE OF giacs182_variables_type;
   
   FUNCTION get_giacs182_variables(
      p_user_id            GIAC_DUETO_ASOF_EXT.user_id%TYPE
   )
     RETURN giacs182_variables_tab PIPELINED;
END;
/


