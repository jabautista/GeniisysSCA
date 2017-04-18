DROP FUNCTION CPI.GET_CLAIM_INFO;

CREATE OR REPLACE FUNCTION CPI.get_claim_info (p_claim_id IN gicl_claims.claim_id%TYPE)
RETURN VARCHAR2 AS
/* Beth 11032006
** Get claim information
*/
 CURSOR c1 (p_claim_id IN gicl_claims.claim_id%TYPE) IS

   SELECT 'Policy No. : '|| line_cd||'-'||subline_cd||'-'||pol_iss_cd||'-'||LTRIM(TO_CHAR(issue_yy, '09'))||'-'||LTRIM(TO_CHAR(pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(renew_no, '09')) ||chr(10)||
          'Claim no. : '||   line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0999999')) ||chr(10)||
          'Assured : '|| assured_name ||chr(10)|| 
          'Loss Date : '|| TO_CHAR(loss_date, 'DD fmMONTH, RRRR') loss_date
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

     p_claim_dtl  VARCHAR2(700);

 BEGIN
   OPEN c1 (p_claim_id);
   FETCH c1 INTO p_claim_dtl;
   IF c1%FOUND THEN
     CLOSE c1;
     RETURN p_claim_dtl;
   ELSE
     CLOSE c1;
     RETURN NULL;
   END IF;
 END;
/


