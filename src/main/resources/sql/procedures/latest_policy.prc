DROP PROCEDURE CPI.LATEST_POLICY;

CREATE OR REPLACE PROCEDURE CPI.latest_policy(P_DATE  IN OUT  DATE,
                           P_POLICY_ID            IN OUT  NUMBER,
                           P_LINE_CD              IN VARCHAR2,
                           P_SUBLINE_CD           IN VARCHAR2,
                           P_ISS_CD               IN VARCHAR2,
                           P_ISSUE_YY             IN NUMBER,
                           P_POL_SEQ_NO           IN NUMBER,
                           P_ENDT_EXPIRY_DATE     IN DATE) IS
    v_date           DATE;
    v_expiry_date    DATE;
    CURSOR  A IS
      SELECT   expiry_date
        FROM   gipi_wpolbas
       WHERE   line_cd      =  P_LINE_CD
         AND   subline_cd   =  P_SUBLINE_CD
         AND   iss_cd       =  P_ISS_CD
         AND   issue_yy     =  P_ISSUE_YY
         AND   pol_seq_no   =  P_POL_SEQ_NO
         AND   expiry_date  <= p_endt_expiry_date;
    CURSOR  B(p_expiry_date   gipi_wpolbas.expiry_date%TYPE) IS
      SELECT   eff_date, policy_id
        FROM   gipi_polbasic
       WHERE   line_cd      =  P_LINE_CD
         AND   subline_cd   =  P_SUBLINE_CD
         AND   iss_cd       =  P_ISS_CD
         AND   issue_yy     =  P_ISSUE_YY
         AND   pol_seq_no   =  P_POL_SEQ_NO
         AND   expiry_date  =  p_EXPIRY_DATE;
BEGIN
    FOR A1 IN A LOOP
     IF v_expiry_date IS NULL THEN
        v_expiry_date := A1.expiry_date;
        FOR B1 IN B(v_expiry_date) LOOP
         IF v_date IS NULL THEN
            v_date      :=  B1.eff_date;
            p_policy_id :=  B1.policy_id;
         END IF;
         IF v_date < B1.eff_date THEN
            v_date      :=  B1.eff_date;
            p_policy_id :=  B1.policy_id;
         END IF;
        END LOOP;
     END IF;
     IF v_expiry_date > A1.expiry_date THEN
        v_expiry_date := A1.expiry_date;
        FOR B1 IN B(v_expiry_date) LOOP
         IF v_date IS NULL THEN
            v_date      :=  B1.eff_date;
            p_policy_id :=  B1.policy_id;
         END IF;
         IF v_date < B1.eff_date THEN
            v_date      :=  B1.eff_date;
            p_policy_id :=  B1.policy_id;
         END IF;
        END LOOP;
     END IF;
    END LOOP;
    p_date  :=  v_date;
END;
/


