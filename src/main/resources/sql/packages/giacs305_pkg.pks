CREATE OR REPLACE PACKAGE CPI.giacs305_pkg
AS
   TYPE dept_type IS RECORD (
      ouc_id              giac_oucs.ouc_id%TYPE,
      gibr_gfun_fund_cd   giac_oucs.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_oucs.gibr_branch_cd%TYPE, 
      ouc_cd              giac_oucs.ouc_cd%TYPE,
      ouc_name            giac_oucs.ouc_name%TYPE,
      claim_tag           giac_oucs.claim_tag%TYPE,
      remarks             giac_oucs.remarks%TYPE,
      user_id             giac_oucs.user_id%TYPE,
      last_update         VARCHAR2(30)
   ); 

   TYPE dept_tab IS TABLE OF dept_type;

   FUNCTION get_dept_list (
      p_fund_cd     giac_oucs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_oucs.gibr_branch_cd%TYPE,
      p_claim_tag   giac_oucs.claim_tag%TYPE,
      p_ouc_cd      giac_oucs.ouc_cd%TYPE,
      p_ouc_name    giac_oucs.ouc_name%TYPE
   )
      RETURN dept_tab PIPELINED;
      
   PROCEDURE set_oucs(p_rec giac_oucs%ROWTYPE);   
   
   PROCEDURE del_ouc(p_ouc_id giac_oucs.ouc_id%TYPE);
   
   PROCEDURE val_delete_ouc(p_ouc_id giac_oucs.ouc_id%TYPE);

END;
/


