CREATE OR REPLACE PACKAGE CPI.GIAC_DV_TEXT_PKG
AS

  PROCEDURE update_giac_dv_text(p_gacc_tran_id		GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
  			                    p_item_gen_type		GIAC_MODULES.generation_type%TYPE);
								
  PROCEDURE update_giac_dv_text_giacs022(p_gacc_tran_id		GIAC_DV_TEXT.gacc_tran_id%TYPE);
  
END GIAC_DV_TEXT_PKG;
/


