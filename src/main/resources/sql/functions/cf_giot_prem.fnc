DROP FUNCTION CPI.CF_GIOT_PREM;

CREATE OR REPLACE FUNCTION CPI.CF_GIOT_PREM(  --Added by Alfred 03/08/2011
p_tran_id giac_op_text.gacc_tran_id%TYPE,
cf_curr_cd giac_op_text.currency_cd%TYPE) RETURN Number IS
v_prem_vat number(16,2);
v_prem_nvat number(16,2);
v_prem_exempt number(16,2);
v_tot_prem number(16,2);
v_fprem_vat number(16,2);
v_fprem_nvat number(16,2);
v_fprem_exempt number(16,2);
v_ftot_prem number(16,2);

BEGIN
   SELECT SUM(item_amt), sum(foreign_curr_amt)
    INTO v_prem_vat,
         v_fprem_vat
    FROM giac_op_text
   WHERE gacc_tran_id = p_tran_id
     AND item_text IN ('PREMIUM (VATABLE)','1')
     AND nvl(or_print_tag,'Y') = 'Y';

  SELECT SUM(item_amt), sum(foreign_curr_amt)
    INTO v_prem_nvat,
         v_fprem_nvat
    FROM giac_op_text
   WHERE gacc_tran_id = p_tran_id
     AND item_text LIKE 'PREMIUM (ZERO-RATED)'
     AND nvl(or_print_tag,'Y') = 'Y';

   SELECT SUM(item_amt), sum(foreign_curr_amt)
    INTO v_prem_exempt,
         v_fprem_exempt
    FROM giac_op_text
   WHERE gacc_tran_id = p_tran_id
     AND item_text IN ('PREMIUM (VAT-EXEMPT)','2')
     AND nvl(or_print_tag,'Y') = 'Y';
     
  IF cf_curr_cd = 1 THEN
    v_tot_prem := nvl(v_PREM_VAT,0) + nvl(v_prem_nvat,0) + nvl (v_prem_exempt,0);
  ELSE 
      v_tot_prem := nvl(v_fPREM_VAT,0) + nvl(v_fprem_nvat,0) + nvl (v_fprem_exempt,0);
  END IF;
RETURN(v_tot_prem);


END;
/


