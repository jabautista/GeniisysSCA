CREATE OR REPLACE PACKAGE BODY CPI.flt_amountcalc_pkg IS

FUNCTION CF_TSIFormula_009 (V_POL GIPI_INVOICE.POLICY_ID%TYPE
                                     ,V_ISS gipi_invoice.iss_cd%TYPE
                                  ,V_PREM gipi_invoice.prem_seq_no%TYPE)RETURN NUMBER IS
V_TSI       GIPI_ITEM.TSI_AMT%TYPE;


BEGIN

  FOR A IN (SELECT ITEM_GRP
              FROM GIPI_INVOICE
             WHERE POLICY_ID = V_POL
               AND ISS_CD = V_ISS
               AND PREM_SEQ_NO = V_PREM)
  LOOP
    FOR B IN (SELECT SUM(TSI_AMT) AMT
                FROM GIPI_ITEM
               WHERE POLICY_ID = V_POL
                 AND ITEM_GRP = A.ITEM_GRP)
    LOOP
      V_TSI  := B.AMT;
      EXIT;
    END LOOP;
  END LOOP;
  RETURN V_TSI;
END CF_TSIFormula_009;          --end of CF_TSIFormula_009

FUNCTION flt_ricommvat_formula(v_pol GIPI_INVOICE.policy_id%TYPE) RETURN NUMBER IS
  v_ri_comm_vat        NUMBER := 0;
BEGIN
     FOR a IN ( SELECT comm_vat, currency_rt
                  FROM gipi_invoice a,
                       giac_aging_ri_soa_details b
                 WHERE a.iss_cd      = 'RI'
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.policy_id   = v_pol)
     LOOP
         v_ri_comm_vat := ROUND(NVL(a.comm_vat, 0)/NVL(a.currency_rt,1),2);
         EXIT;
     END LOOP;
  RETURN(v_ri_comm_vat);
END flt_ricommvat_formula;      --end of flt_ricommvat_formula


FUNCTION flt_vattotal_formula(v_pol GIPI_INVOICE.POLICY_ID%TYPE)
   RETURN NUMBER IS
  v_vat_total    NUMBER  := 0;
  v_ri_comm_vat    NUMBER  := 0;
  v_prem_vat    NUMBER  := 0;
BEGIN
       FOR a IN ( SELECT comm_vat, currency_rt
                  FROM gipi_invoice a,
                       giac_aging_ri_soa_details b
                 WHERE a.iss_cd      = 'RI'
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.policy_id   = v_pol)
     LOOP
         v_ri_comm_vat := ROUND(NVL(a.comm_vat, 0)/NVL(a.currency_rt,1),2);
         EXIT;
     END LOOP;
     FOR b IN (SELECT b.tax_amt tax
                 FROM gipi_invoice a,
                      gipi_inv_tax b
                WHERE a.iss_cd = b.iss_cd
                  AND a.prem_seq_no = b.prem_seq_no
                  AND a.policy_id   = v_pol)
     LOOP
      v_prem_vat := ROUND(NVL(b.tax,0),2);
      EXIT;
     END LOOP;
     v_vat_total := NVL(v_prem_vat,0) - NVL(v_ri_comm_vat,0);
  RETURN(v_vat_total);
END flt_vattotal_formula;     --end of flt_vattotal_formula


FUNCTION flt_vat(p_isscd GIPI_INVOICE.ISS_CD%TYPE, p_prem GIPI_INVOICE.PREM_SEQ_NO%TYPE)
 RETURN NUMBER IS
 v_taxtotal NUMBER := 0;
BEGIN
    BEGIN
        SELECT a.tax_amt into v_taxtotal
           FROM GIPI_INV_TAX a
            , GIIS_TAX_CHARGES b
        WHERE a.line_cd = b.line_cd
              AND a.iss_cd = b.iss_cd
              AND a.tax_cd = b.tax_cd
              AND a.tax_id = b.tax_id
              AND a.prem_seq_no= p_prem
              AND a.iss_cd = p_isscd;
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                v_taxtotal := NULL;
            WHEN no_data_found THEN NULL;
    END;
    RETURN(v_taxtotal);
END flt_vat;

END flt_amountcalc_pkg; --package end
/


