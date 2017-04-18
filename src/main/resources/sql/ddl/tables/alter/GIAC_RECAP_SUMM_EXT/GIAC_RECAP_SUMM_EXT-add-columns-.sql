/* Formatted on 3/1/2016 11:20:28 AM (QP5 v5.227.12220.39754) */
SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_summ_ext ADD eff_date DATE';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added eff_date column to giac_recap_summ_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_summ_ext ADD exp_date DATE';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added exp_date column to giac_recap_summ_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_summ_ext ADD curr_def_prem_amt NUMBER(16,2)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added def_prem_amt column to giac_recap_summ_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_summ_ext ADD prev_def_prem_amt NUMBER(16,2)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added prev_def_prem_amt column to giac_recap_summ_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/