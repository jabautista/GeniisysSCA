CREATE OR REPLACE PACKAGE CPI.giac_reinstated_or_pkg
IS
   PROCEDURE reinstate_or (
      p_or_pref          giac_reinstated_or.or_pref%TYPE,
      p_or_no            giac_reinstated_or.or_no%TYPE,
      p_fund_cd          giac_reinstated_or.fund_cd%TYPE,
      p_branch_cd        giac_reinstated_or.branch_cd%TYPE,
      p_reinstate_date   giac_reinstated_or.reinstate_date%TYPE,
      p_spoil_date       giac_reinstated_or.spoil_date%TYPE,
      p_prev_or_date     giac_reinstated_or.prev_or_date%TYPE,
      p_prev_tran_id     giac_reinstated_or.prev_tran_id%TYPE,
	  p_module_id		 giis_modules_tran.MODULE_ID%TYPE,
	  p_message		OUT  varchar2
   );
   
   PROCEDURE insert_reinstated_or (
   	  p_or_pref          giac_reinstated_or.or_pref%TYPE,
      p_or_no            giac_reinstated_or.or_no%TYPE,
      p_fund_cd          giac_reinstated_or.fund_cd%TYPE,
      p_branch_cd        giac_reinstated_or.branch_cd%TYPE,
      p_spoil_date       giac_reinstated_or.spoil_date%TYPE,
      p_prev_or_date     giac_reinstated_or.prev_or_date%TYPE,
      p_prev_tran_id     giac_reinstated_or.prev_tran_id%TYPE,
	  p_message		OUT	 varchar2
   );
END giac_reinstated_or_pkg;
/


