CREATE OR REPLACE PACKAGE BODY CPI.flt_risks_pkg IS

FUNCTION flt_riskformula(p_isscd GIPI_INVOICE.ISS_CD%TYPE, p_prem GIPI_INVOICE.PREM_SEQ_NO%TYPE)
return VARCHAR2 is
  v_peril        VARCHAR2(50);
begin
  BEGIN
    SELECT peril_name
      INTO v_peril
      FROM giis_peril T1, gipi_itmperil T2, gipi_item T3, gipi_invoice T4
     WHERE T1.peril_cd    = T2.peril_cd
       AND T1.line_cd     = T2.line_cd
       AND T2.policy_id   = T3.policy_id
       AND T2.item_no     = T3.item_no
       AND T3.policy_id   = T4.policy_id
       AND T3.item_grp    = T4.item_grp
       AND T4.iss_cd      = p_isscd
       AND T4.prem_seq_no = P_prem;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_peril := 'various risks';
      WHEN NO_DATA_FOUND THEN
        v_peril := NULL;
  END;
  RETURN v_peril;
end flt_riskformula;   --end of flt_riskformula


function PREM_RTFormula(p_isscd GIPI_INVOICE.ISS_CD%TYPE, p_prem GIPI_INVOICE.PREM_SEQ_NO%TYPE)
return VARCHAR2 is
  v_prem_rt        VARCHAR2(25);
begin
  BEGIN
    SELECT LTRIM(TO_CHAR(prem_rt,'990.999999999')) || '%'
      INTO v_prem_Rt
      FROM giis_peril T1, gipi_itmperil T2, gipi_item T3, gipi_invoice T4
     WHERE T1.peril_cd    = T2.peril_cd
       AND T1.line_cd     = T2.line_cd
       AND T2.policy_id   = T3.policy_id
       AND T2.item_no     = T3.item_no
       AND T3.policy_id   = T4.policy_id
       AND T3.item_grp    = T4.item_grp
       AND T4.iss_cd      = p_isscd
       AND T4.prem_seq_no = p_prem;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_prem_rt := 'various rates';
      WHEN NO_DATA_FOUND THEN NULL;
  END;
  RETURN v_prem_rt;
end PREM_RTFormula;     --end of prem_rtformula

END flt_risks_pkg;
/


