CREATE OR REPLACE PACKAGE CPI.GIACS147_PKG
AS
   TYPE brach_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE
   );

   TYPE brach_lov_tab IS TABLE OF brach_lov_type;

   TYPE assd_lov_type IS RECORD (
      assd_no     giis_assured.assd_no%TYPE,
      assd_name   giis_assured.assd_name%TYPE
   );

   TYPE assd_lov_tab IS TABLE OF assd_lov_type;

   TYPE dep_flag_lov_type IS RECORD (
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE
   );

   TYPE dep_flag_lov_tab IS TABLE OF dep_flag_lov_type;

   TYPE last_extract_type IS RECORD (
      cut_off_date_dep   giac_premdeposit_ext.cutoff_date%TYPE,
      from_date_dep      giac_premdeposit_ext.from_date%TYPE,
      to_date_dep        giac_premdeposit_ext.from_date%TYPE,
      transaction_dep    giac_premdeposit_ext.date_flag%TYPE,
      posting_dep        giac_premdeposit_ext.date_flag%TYPE,
      param_branch_cd    giac_premdeposit_ext.param_branch_cd%TYPE,
      param_assd_no      giac_premdeposit_ext.param_assd_no%TYPE,  
      param_dep_flag     giac_premdeposit_ext.param_dep_flag%TYPE, 
      param_rdo_dep      giac_premdeposit_ext.param_rdo_dep%TYPE,
      param_branch_name  VARCHAR2(50),
      param_assd_name    VARCHAR2(500),
      param_dep_desc     VARCHAR2(100)
   );

   TYPE last_extract_tab IS TABLE OF last_extract_type;

   FUNCTION get_last_extract (p_user_id giis_users.user_id%TYPE)
      RETURN last_extract_tab PIPELINED;

   PROCEDURE extract_premium_deposit (p_user_id giis_users.user_id%TYPE);

   PROCEDURE extract_wid_no_reversal (
      p_user_id             giis_users.user_id%TYPE,
      p_posting             VARCHAR2,
      p_transaction         VARCHAR2,
      p_from_date           DATE,
      p_to_date             DATE,
      p_branch_cd           VARCHAR2,
      p_reversal            VARCHAR2,
      p_cut_off             DATE,
      p_dep_flag            VARCHAR2,
      p_assd_no             VARCHAR2,
      p_rdo_dep             VARCHAR2,
      p_row_count     OUT   VARCHAR2
   );

   PROCEDURE extract_wid_reversal (
      p_user_id             giis_users.user_id%TYPE,
      p_posting             VARCHAR2,
      p_transaction         VARCHAR2,
      p_from_date           DATE,
      p_to_date             DATE,
      p_branch_cd           VARCHAR2,
      p_reversal            VARCHAR2,
      p_cut_off             DATE,
      p_dep_flag            VARCHAR2,
      p_assd_no             VARCHAR2,
      p_rdo_dep             VARCHAR2,
      p_row_count     OUT   NUMBER
   );

   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN brach_lov_tab PIPELINED;

   FUNCTION get_assd_lov
      RETURN assd_lov_tab PIPELINED;

   FUNCTION get_dep_flag_lov
      RETURN dep_flag_lov_tab PIPELINED;

   PROCEDURE main_ext (
      p_user_id       giis_users.user_id%TYPE,
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_from_date     DATE,
      p_to_date       DATE,
      p_main_tran     NUMBER,
      p_branch_cd     VARCHAR2,
      p_reversal      VARCHAR2,
      p_cut_off       DATE,
      p_dep_flag      VARCHAR2,
      p_assd_no       VARCHAR2
   );

   PROCEDURE find_rev2 (
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_cut_off       DATE,
      p_user_id       giis_users.user_id%TYPE,
      p_from_date     DATE,
      p_to_date       DATE
   );

   PROCEDURE insert_d_values (
      p_user_id     giis_users.user_id%TYPE,
      p_from_date   DATE,
      p_to_date     DATE,
      p_cut_off     DATE
   );

   PROCEDURE find_rev_yescan (
      p_user_id       giis_users.user_id%TYPE,
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_from_date     DATE,
      p_to_date       DATE,
      p_cut_off       DATE
   );

   PROCEDURE find_rev_nocan (
      p_user_id       giis_users.user_id%TYPE,
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_from_date     DATE,
      p_to_date       DATE,
      p_cut_off       DATE
   );
END GIACS147_PKG;
/


