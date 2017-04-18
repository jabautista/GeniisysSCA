SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_dtl_ext ADD eff_date DATE';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added eff_date column to giac_recap_dtl_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_dtl_ext ADD exp_date DATE';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added exp_date column to giac_recap_dtl_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_dtl_ext ADD prev_def_prem_amt NUMBER(16,2)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added prev_def_prem_amt column to giac_recap_dtl_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_recap_dtl_ext ADD def_prem_amt NUMBER(16,2)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added def_prem_amt column to giac_recap_dtl_ext table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/