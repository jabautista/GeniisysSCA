DROP FUNCTION CPI.GET_ANN_TSI_OC;

CREATE OR REPLACE FUNCTION CPI.Get_Ann_Tsi_OC
  /*  THIS FUNCTION GETS THE ANN_TSI AMOUNT OF THE LATEST ENDT OF THE POLICY
  */
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
     p_from       DATE,
     p_to         DATE,
  p_basis   VARCHAR2)
  RETURN NUMBER IS
    TYPE cur1_type IS REF CURSOR;
    cur1           cur1_type;
    v_ann_tsi      GIPI_POLBASIC.ann_tsi_amt%TYPE;
  BEGIN
    FOR cur1 IN
      (SELECT SUM(y.tsi_amt) tsi_amt
        FROM GIPI_POLBASIC x, GIPI_ITEM y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
         AND x.renew_no   = p_renew_no
   AND x.policy_id = y.policy_id 
         --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
      --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
         /*AND X.POL_FLAG IN ('1','2','3','4','x')
   AND DATE_RISK(X.ACCT_ENT_DATE, X.EFF_DATE, X.ISSUE_DATE, P_BASIS, P_FROM, P_TO) = 1*/
   --AND Date_Risk(x.acct_ent_date, x.eff_date, x.issue_date,x.booking_mth,x.booking_year,
       --x.spld_acct_ent_date, x.pol_flag, p_basis, p_from, p_to) = 1
         --AND DIST_FLAG = '3'
         AND dist_flag = DECODE(x.pol_flag,'5','4','3')--IF POL_FLAG IS 5, DIST_FLAG SHLD BE 4, ELSE DIST_FLAG SHLD BE 3
         AND (x.endt_seq_no = 0 OR
             (x.endt_seq_no <> 0
              AND EXISTS (SELECT 1
                            FROM GIPI_POLBASIC c
                     WHERE c.line_cd     = x.line_cd
                         AND c.subline_cd  = x.subline_cd
                       AND c.iss_cd      = x.iss_cd
                       AND c.issue_yy    = x.issue_yy
                         AND c.pol_seq_no  = x.pol_seq_no
                          AND c.renew_no    = x.renew_no
                          AND c.endt_seq_no = 0
        --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
        --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
                   /*AND DATE_RISK(C.ACCT_ENT_DATE, C.EFF_DATE,
          C.ISSUE_DATE, P_BASIS, P_FROM, P_TO) = 1*/
                   AND Date_Risk(c.acct_ent_date, c.eff_date,
          c.issue_date,c.booking_mth, c.booking_year, c.spld_acct_ent_date, c.pol_flag,
          p_basis, p_from, p_to) = 1
        ))))
    LOOP
      v_ann_tsi := cur1.tsi_amt;
      EXIT;
    END LOOP;
    RETURN v_ann_tsi;
  END;
/


