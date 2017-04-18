CREATE OR REPLACE PACKAGE CPI.giac_cpc
/*
|| Author: GIACS162 programmers
||
|| Overview: Profit Commissions Extraction (primarily used in GIACS162)
||
|| Major Modifications (who, when, what):
|| 10/18/2000 - RLU - Create package (this procedures used to be a program unit in Forms)
||
*/
IS
  PROCEDURE loss_pd_ext  (v_tran_year IN giac_loss_pd_ext.tran_year%TYPE);
  PROCEDURE prem_pd_ext  (v_tran_year IN giac_prem_pd_ext.tran_year%TYPE);
  PROCEDURE loss_res_ext (v_tran_year IN giac_loss_res_ext.tran_year%TYPE);
END giac_cpc;
/


DROP PACKAGE CPI.GIAC_CPC;

