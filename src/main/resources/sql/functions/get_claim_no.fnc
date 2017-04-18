DROP FUNCTION CPI.GET_CLAIM_NO;

CREATE OR REPLACE FUNCTION CPI.get_claim_no (p_intm_no IN gicl_intm_itmperil.intm_no%TYPE,
                                         p_claim_id IN gicl_claims.claim_id%TYPE)
RETURN VARCHAR2 AS
/* Created by Pia 06.25.02.
** To sort by claim number, using intm_no.
** Used in GICLS266 */

/* Modified by Mon 102502
** added claim_id in the parameters to be entered
*/
 CURSOR c1 (p_intm_no IN gicl_intm_itmperil.intm_no%TYPE,
              p_claim_id IN gicl_claims.claim_id%TYPE) IS

     SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no, '0000009')) claim
       FROM gicl_claims a, gicl_intm_itmperil b
      WHERE a.claim_id = b.claim_id
        AND b.intm_no = p_intm_no
		AND a.claim_id = p_claim_id;

     p_claim_no  VARCHAR2(100);

 BEGIN
   OPEN c1 (p_intm_no, p_claim_id);
   FETCH c1 INTO p_claim_no;
   IF c1%FOUND THEN
     CLOSE c1;
     RETURN p_claim_no;
   ELSE
     CLOSE c1;
     RETURN NULL;
   END IF;
 END;
/


