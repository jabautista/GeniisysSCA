DROP FUNCTION CPI.CHK_CLAIM;

CREATE OR REPLACE FUNCTION CPI.chk_claim (
   p_prem_seq_no   IN   gipi_invoice.prem_seq_no%TYPE,
   p_iss_cd        IN   gipi_invoice.iss_cd%TYPE
)
   RETURN VARCHAR2
IS
   v_temp   VARCHAR2(1);
   v_exists           VARCHAR2 (1) := 'N';--VARCHAR2(5) := 'TRUE';
   v_existing_claim   VARCHAR2(2000) := '';
BEGIN
   -- edited by d.alcantara, 11/13/2012, to return list of claim nos. if a bill has an existing claim
    FOR i IN (
        SELECT rownum, c.line_cd||' - '||c.subline_cd||' - '||c.iss_cd||' -'||
                TO_CHAR(c.clm_yy,'09')||' -'||TO_CHAR(clm_seq_no, '0000009') claim_no
           FROM gicl_claims c, gipi_polbasic b, gipi_invoice a
          WHERE 1 = 1
            AND clm_stat_cd NOT IN ('CD', 'CC', 'DN', 'WD')
            AND b.line_cd = c.line_cd
            AND b.subline_cd = c.subline_cd
            AND b.iss_cd = c.pol_iss_cd
            AND b.issue_yy = c.issue_yy
            AND b.pol_seq_no = c.pol_seq_no
            AND b.renew_no = c.renew_no
            AND a.policy_id = b.policy_id
            AND a.prem_seq_no = p_prem_seq_no
            AND a.iss_cd = p_iss_cd  
    ) LOOP
        v_exists := 'Y';
        IF i.rownum > 1 THEN
            v_existing_claim := v_existing_claim||', '||i.claim_no;
        ELSE
            v_existing_claim := i.claim_no;
        END IF;
    END LOOP;
    
    IF v_exists = 'N' THEN
        v_existing_claim := 'FALSE';
    END IF;
/*    
   DECLARE
      CURSOR c
      IS
         --SELECT 'X'* --editted by MJ for consolidation 01032013
         SELECT c.line_cd||' - '||c.subline_cd||' - '||c.iss_cd||' -'||
                TO_CHAR(c.clm_yy,'09')||' -'||TO_CHAR(clm_seq_no, '0000009') claim_no
           FROM gicl_claims c, gipi_polbasic b, gipi_invoice a
          WHERE 1 = 1
            AND clm_stat_cd NOT IN ('CD', 'CC', 'DN', 'WD')
            AND b.line_cd = c.line_cd
            AND b.subline_cd = c.subline_cd
            AND b.iss_cd = c.pol_iss_cd
            AND b.issue_yy = c.issue_yy
            AND b.pol_seq_no = c.pol_seq_no
            AND b.renew_no = c.renew_no
            AND a.policy_id = b.policy_id
            AND a.prem_seq_no = p_prem_seq_no
            AND a.iss_cd = p_iss_cd;
   BEGIN
      OPEN c;
      FETCH c
       INTO v_temp;
      IF c%NOTFOUND
      THEN
         v_exists := 'FALSE';
      END IF;
      CLOSE c;
   END;*/
    RETURN v_existing_claim;
END;
/


