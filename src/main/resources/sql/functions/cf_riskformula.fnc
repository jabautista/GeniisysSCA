DROP FUNCTION CPI.CF_RISKFORMULA;

CREATE OR REPLACE FUNCTION CPI.CF_RiskFormula(P_ISSCD IN GIPI_INVOICE.iss_cd%type, P_PREMSEQ IN GIPI_INVOICE.prem_seq_no%type) return VARCHAR2 is
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
       AND T4.iss_cd      = P_ISSCD
       AND T4.prem_seq_no = P_PREMSEQ;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        v_peril := 'various risks';
      WHEN NO_DATA_FOUND THEN NULL;
  END;
  RETURN v_peril;
end;
/


