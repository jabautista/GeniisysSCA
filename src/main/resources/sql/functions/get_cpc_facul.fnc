DROP FUNCTION CPI.GET_CPC_FACUL;

CREATE OR REPLACE FUNCTION CPI.Get_Cpc_Facul (p_policy_id   IN GIPI_POLBASIC.policy_id%TYPE,
                                          p_iss_cd      IN GIPI_INVOICE.iss_cd%TYPE,
            p_prem_seq_no IN GIPI_INVOICE.prem_seq_no%TYPE,
            p_peril_cd    IN GIIS_PERIL.peril_cd%TYPE)
RETURN NUMBER AS
/* beth
** return peril facul_share
*/
 p_shr_intm_pct  NUMBER;
BEGIN
  FOR A IN (
    SELECT SUM(DECODE(E.SHARE_CD, 999, E.DIST_PREM,0))/--SUM(DECODE(E.DIST_PREM,0,1, E.DIST_PREM)) facul_shr --EMCY da042806te: replaced with:
        DECODE(SUM(E.DIST_PREM),0,1,SUM(E.DIST_PREM)) facul_shr
       FROM GIUW_ITEMPERILDS_DTL E,
            GIPI_INVOICE C,
         GIPI_ITEM A,
         GIUW_POL_DIST D
      --WHERE ISS_CD = p_iss_cd
      --  AND PREM_SEQ_NO = p_prem_seq_no
   WHERE c.ISS_CD = p_iss_cd             -- modified by aaron to avoid ambiguous column
        AND c.PREM_SEQ_NO = p_prem_seq_no   -- modified by aaron
        AND D.POLICY_ID = p_policy_id
        AND A.ITEM_GRP = C.ITEM_GRP
        AND A.POLICY_ID = C.POLICY_ID
        AND D.DIST_FLAG = 3
        AND A.POLICY_ID = D.POLICY_ID
        AND E.DIST_NO = D.DIST_NO
        AND E.ITEM_NO = A.ITEM_NO
        AND E.PERIL_CD = p_peril_cd)
  LOOP
    p_shr_intm_pct := ROUND(A.facul_shr,9);
  END LOOP;
  RETURN p_shr_intm_pct;
END;
/


