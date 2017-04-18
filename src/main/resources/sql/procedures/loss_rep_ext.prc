DROP PROCEDURE CPI.LOSS_REP_EXT;

CREATE OR REPLACE PROCEDURE CPI.LOSS_REP_EXT
     (v_line_cd  gicl_claims.line_cd%type,
      v_subline_cd gicl_claims.subline_cd%type,
      v_claim_id gicl_claims.claim_id%type) AS
begin
  for i in (SELECT TO_NUMBER(A.CLM_DOC_CD) CLM_DOC_CD, A.LINE_CD,
                   A.SUBLINE_CD, A.CLM_DOC_DESC
              FROM GICL_CLM_DOCS A
             WHERE A.PRIORITY_CD IS NOT NULL
               AND A.LINE_CD =  V_LINE_CD
               AND A.SUBLINE_CD = V_SUBLINE_CD
             UNION
            SELECT A.CLM_DOC_CD, A.LINE_CD,
                   A.SUBLINE_CD, B.CLM_DOC_DESC
              FROM GICL_REQD_DOCS A, GICL_CLM_DOCS B
             WHERE A.DOC_CMPLTD_DT IS NOT NULL
               AND A.LINE_CD = B.LINE_CD
               AND A.SUBLINE_CD = B.SUBLINE_CD
               AND A.CLM_DOC_CD = B.CLM_DOC_CD
               AND B.LINE_CD =  V_LINE_CD
               AND B.SUBLINE_CD = V_SUBLINE_CD
               AND A.CLAIM_ID = v_claim_id) LOOP
    insert into GICL_LOSS_REP_EXT
           (CLM_DOC_CD, LINE_CD, SUBLINE_CD, CLM_DOC_DESC)
    values (i.CLM_DOC_CD, i.LINE_CD, i.SUBLINE_CD, i.CLM_DOC_DESC);
  end loop;
  commit;
end;
/


