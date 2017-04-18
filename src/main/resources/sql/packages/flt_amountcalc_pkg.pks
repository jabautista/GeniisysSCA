CREATE OR REPLACE PACKAGE CPI.flt_amountcalc_pkg AS
       FUNCTION CF_TSIFormula_009 (V_POL GIPI_INVOICE.POLICY_ID%TYPE
                                     ,V_ISS gipi_invoice.iss_cd%TYPE
                                  ,V_PREM gipi_invoice.prem_seq_no%TYPE)RETURN NUMBER;
       FUNCTION flt_ricommvat_formula(v_pol GIPI_INVOICE.policy_id%TYPE) RETURN NUMBER;
       FUNCTION flt_vattotal_formula(v_pol GIPI_INVOICE.POLICY_ID%TYPE) RETURN NUMBER;
       FUNCTION flt_vat(p_isscd GIPI_INVOICE.ISS_CD%TYPE, p_prem GIPI_INVOICE.PREM_SEQ_NO%TYPE) RETURN NUMBER;
END flt_amountcalc_pkg;
/


