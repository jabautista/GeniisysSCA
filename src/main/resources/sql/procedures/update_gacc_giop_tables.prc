DROP PROCEDURE CPI.UPDATE_GACC_GIOP_TABLES;

CREATE OR REPLACE PROCEDURE CPI.update_gacc_giop_tables(
	   	  p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
		  p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
		  p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   		  p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
		  p_or_date                      varchar2
)
 IS
  v_dcb_tran_date   giac_order_of_payts.cancel_date%TYPE;
  tran_for_update   giac_acctrans.tran_id%TYPE;

BEGIN

  v_dcb_tran_date  := get_or_dcb_tran_date(p_or_date, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_dcb_no);
  tran_for_update := p_gacc_tran_id;
                                
  UPDATE giac_acctrans
    SET tran_flag = 'D'
    WHERE tran_id = tran_for_update;

  UPDATE giac_order_of_payts
    SET or_flag = 'C',
        user_id = NVL (giis_users_pkg.app_user,USER),
        last_update = SYSDATE,
        cancel_date = v_dcb_tran_date,
        cancel_dcb_no = p_dcb_no
    WHERE gacc_tran_id = tran_for_update;
    
  delete_workflow_rec('CANCEL OR','GIACS001',NVL (giis_users_pkg.app_user,USER),tran_for_update);
      
END;
/


