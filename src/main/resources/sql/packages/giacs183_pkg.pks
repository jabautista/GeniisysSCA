CREATE OR REPLACE PACKAGE CPI.giacs183_pkg
AS
   TYPE line_lov_type IS RECORD (
      line_cd     giri_binder.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   TYPE ri_lov_type IS RECORD (
      ri_cd     giri_binder.ri_cd%TYPE,
      ri_name   giis_reinsurer.ri_name%TYPE
   );

   TYPE ri_lov_tab IS TABLE OF ri_lov_type;

   TYPE date_type IS RECORD (
      from_date      VARCHAR2 (20),
      TO_DATE        VARCHAR2 (20),
      cut_off_date   VARCHAR2 (20)
   );

   TYPE date_tab IS TABLE OF date_type;

   FUNCTION get_line_lov
      RETURN line_lov_tab PIPELINED;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED;

   FUNCTION validate_print (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_cut_off_date   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_date (p_user_id giis_users.user_id%TYPE)
      RETURN date_tab PIPELINED;

   PROCEDURE extract_to_table (
      p_from_date            VARCHAR2,
      p_to_date              VARCHAR2,
      p_cut_off_date         VARCHAR2,
      p_ri_cd                giis_reinsurer.ri_cd%TYPE,
      p_line_cd              giis_line.line_cd%TYPE,
      p_exist          OUT   VARCHAR2,
      p_fund_cd        OUT   giac_parameters.param_value_v%TYPE,
      p_branch_cd      OUT   giac_parameters.param_value_v%TYPE,
      p_usetran_date   OUT   giac_acctrans.tran_date%TYPE,
      p_colln_amt      OUT   giac_inwfacul_prem_collns.collection_amt%TYPE
   );

   PROCEDURE main_loop (
      p_from_date               VARCHAR2,
      p_to_date                 VARCHAR2,
      p_cut_off_date            VARCHAR2,
      p_fund_cd                 giac_parameters.param_value_v%TYPE,
      p_branch_cd               giac_parameters.param_value_v%TYPE,
      p_usetran_date   IN OUT   giac_acctrans.tran_date%TYPE,
      p_colln_amt      IN OUT   giac_inwfacul_prem_collns.collection_amt%TYPE
   );

   PROCEDURE find_all_neg (
      p_usefnl_binder   OUT   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      OUT   giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     OUT   giuw_pol_dist.negate_date%TYPE,
      p_from_date             DATE,
      p_to_date               DATE,
      p_cut_off_date          DATE,
      p_fnl_binder            giri_frps_ri.fnl_binder_id%TYPE
   );

   PROCEDURE all_neg_insert (
      p_from_date            DATE,
      p_to_date              DATE,
      p_cut_off_date         DATE,
      p_fund_cd              giac_parameters.param_value_v%TYPE,
      p_branch_cd            giac_parameters.param_value_v%TYPE,
      p_usetran_date   OUT   DATE,
      p_disb_amt       OUT   NUMBER
   );

   PROCEDURE find_one_val (
      p_usefnl_binder   OUT   giri_binder.fnl_binder_id%TYPE,
      p_usedist_no      OUT   giuw_pol_dist.dist_no%TYPE,
      p_useneg_date     OUT   giuw_pol_dist.negate_date%TYPE,
      p_from_date             DATE,
      p_to_date               DATE,
      p_cut_off_date          DATE,
      p_fnl_binder            giri_frps_ri.fnl_binder_id%TYPE
   );

   PROCEDURE one_val_insert (
      p_from_date             DATE,
      p_to_date               DATE,
      p_cut_off_date          DATE,
      p_fund_cd               giac_parameters.param_value_v%TYPE,
      p_branch_cd             giac_parameters.param_value_v%TYPE,
      p_usefnl_binder         giri_binder.fnl_binder_id%TYPE,
      p_usetran_date    OUT   DATE,
      p_disb_amt        OUT   NUMBER
   );
END;
/


