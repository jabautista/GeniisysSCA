DROP FUNCTION CPI.GET_CLM_POLICY_NO;

CREATE OR REPLACE FUNCTION CPI.get_clm_policy_no (p_intm_no  IN gicl_intm_itmperil.intm_no%TYPE,
                                              p_claim_id IN gicl_claims.claim_id%TYPE)
RETURN VARCHAR2 AS

 /* Created by MON 10.25.02.
 ** To sort by policy number, using intm_no and claim_id.
 ** Used in GICLS266
 */
 CURSOR c1 (p_intm_no IN gicl_intm_itmperil.intm_no%TYPE,
              p_claim_id IN gicl_claims.claim_id%TYPE) IS

     SELECT a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy
       FROM gicl_claims a, gicl_intm_itmperil b
      WHERE a.claim_id = b.claim_id
        AND b.intm_no = p_intm_no
		AND a.claim_id = p_claim_id;

     p_policy_no  VARCHAR2(100);

 BEGIN
   OPEN c1 (p_intm_no, p_claim_id);
   FETCH c1 INTO p_policy_no;
   IF c1%FOUND THEN
     CLOSE c1;
     RETURN p_policy_no;
   ELSE
     CLOSE c1;
     RETURN NULL;
   END IF;
 END;
/


