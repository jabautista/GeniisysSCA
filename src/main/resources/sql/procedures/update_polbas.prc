DROP PROCEDURE CPI.UPDATE_POLBAS;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_POLBAS as
  CURSOR POLBASIC(v_line_cd		gicl_claims.line_cd%type,
                  v_subline_cd		gicl_claims.subline_cd%type,
                  v_iss_cd		gicl_claims.iss_cd%type,
                  v_issue_yy		gicl_claims.issue_yy%type,
                  v_pol_seq_no		gicl_claims.pol_seq_no%type,
                  v_renew_no		gicl_claims.renew_no%type) IS
    SELECT POLICY_ID,
           EFF_DATE,
           EXPIRY_DATE,
           ENDT_TYPE,
           ENDT_YY,
           ENDT_SEQ_NO
      FROM GIPI_POLBASIC
     WHERE POL_FLAG NOT IN ('4','5')
       AND DIST_FLAG    = DECODE(NVL(ENDT_TYPE,'A'), 'N', DIST_FLAG, '3')
       AND RENEW_NO     = V_RENEW_NO
       AND POL_SEQ_NO   = V_POL_SEQ_NO
       AND ISSUE_YY     = V_ISSUE_YY
       AND ISS_CD       = V_ISS_CD
       AND SUBLINE_CD   = V_SUBLINE_CD
       AND LINE_CD      = V_LINE_CD;
BEGIN
  FOR CLAIMS in (SELECT claim_id, line_cd, subline_cd, pol_iss_cd, issue_yy,
                        pol_seq_no, renew_no, loss_date
                   FROM gicl_claims
                  WHERE claim_id not in (SELECT claim_id
                                           FROM gicl_clm_polbas)) LOOP

    FOR POLBASIC_REC IN POLBASIC(claims.line_cd, claims.subline_cd,
                                 claims.pol_iss_cd, claims.issue_yy, claims.pol_seq_no,
                                 claims.renew_no) LOOP
      INSERT INTO GICL_CLM_POLBAS(CLAIM_ID,
                                  LOSS_DATE,
                                  POLICY_ID,
                                  EFF_DATE,
                                  EXPIRY_DATE,
                                  ENDT_TYPE,
                                  ENDT_YY,
                                  ENDT_SEQ_NO)
                           VALUES(claims.CLAIM_ID,
                                  claims.LOSS_DATE,
                                  POLBASIC_REC.POLICY_ID,
                                  POLBASIC_REC.EFF_DATE,
	                          POLBASIC_REC.EXPIRY_DATE,
                                  POLBASIC_REC.ENDT_TYPE,
                                  POLBASIC_REC.ENDT_YY,
                                  POLBASIC_REC.ENDT_SEQ_NO);
    END LOOP;
  END LOOP;
  commit;
END;
/


