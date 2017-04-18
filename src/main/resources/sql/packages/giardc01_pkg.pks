CREATE OR REPLACE PACKAGE CPI.GIARDC01_PKG
AS
   TYPE daily_collection_type IS RECORD (
      dcb_no       giac_colln_batch.dcb_no%TYPE,
      dcb_year     giac_colln_batch.dcb_year%TYPE,
      fund_cd      giac_colln_batch.fund_cd%TYPE,
      branch_cd    giac_colln_batch.branch_cd%TYPE,
      tran_date    giac_colln_batch.tran_date%TYPE,
      sdf_tran_date VARCHAR2(20),
      dcb_flag     giac_colln_batch.dcb_flag%TYPE,
      remarks      giac_colln_batch.remarks%TYPE,
      user_id      giac_colln_batch.user_id%TYPE,
      cashier_cd   giac_dcb_users.cashier_cd%TYPE,
      print_name   giac_dcb_users.print_name%TYPE
   );

   TYPE daily_collection_tab IS TABLE OF daily_collection_type;

   TYPE cashier_lov_type IS RECORD (
      cashier_cd   giac_dcb_users.cashier_cd%TYPE,
      print_name   giac_dcb_users.print_name%TYPE
   );

   TYPE cashier_lov_tab IS TABLE OF cashier_lov_type;

   FUNCTION get_cashier_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_dcb_no      giac_order_of_payts.dcb_no%TYPE,
      p_dcb_date    giac_colln_batch.tran_date%TYPE, --Added by Jerome Bautista 09.16.2015 SR 20162
      p_dcb_year    giac_colln_batch.dcb_year%TYPE --Added by Jerome Bautista 09.16.2015 SR 20162
   )
      RETURN cashier_lov_tab PIPELINED;
      
  FUNCTION get_daily_collection_record (
      p_dsp_date   DATE,
      p_dcb_no     giac_order_of_payts.dcb_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN daily_collection_tab PIPELINED;
  
  TYPE dcb_lov_type IS RECORD (
      fund_cd       giac_colln_batch.fund_cd%TYPE,
      branch_cd     giac_colln_batch.branch_cd%TYPE,
      dcb_year      giac_colln_batch.dcb_year%TYPE,
      dcb_no        giac_colln_batch.dcb_no%TYPE,
      tran_date     giac_colln_batch.tran_date%TYPE,
      cashier_cd    giac_dcb_users.cashier_cd%TYPE,
      print_name    giac_dcb_users.print_name%TYPE
  );
  
  TYPE dcb_lov_tab IS TABLE OF dcb_lov_type;
  
  FUNCTION get_dcb_lov(
     p_user_id      VARCHAR2,
     p_fund_cd      VARCHAR2,
     p_branch_cd    VARCHAR2,
     p_dcb_year     VARCHAR2,
     p_dcb_no       VARCHAR2,
     p_dcb_date     DATE,
     p_cashier_cd   VARCHAR2,
     p_cashier_name VARCHAR2
  )
     RETURN dcb_lov_tab PIPELINED;
END;
/


