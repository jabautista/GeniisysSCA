DROP FUNCTION CPI.GET_ITEM_ANN_TSI;

CREATE OR REPLACE FUNCTION CPI.get_item_ann_tsi
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
  p_item_no    NUMBER,
     p_from       DATE,
     p_to         DATE,
  p_basis   VARCHAR2)
RETURN NUMBER IS
  v_item_ann_tsi   gipi_item.ann_tsi_amt%TYPE := 0;
BEGIN
  FOR tsi IN (SELECT SUM(y.tsi_amt) tsi_amt
                FROM gipi_polbasic x,
               gipi_item     y
               WHERE 1=1
                AND x.policy_id  = y.policy_id
              AND y.item_no    = p_item_no
                 AND x.line_cd    = p_line_cd
                 AND x.subline_cd = p_subline_cd
                 AND x.iss_cd     = p_iss_cd
                 AND x.issue_yy   = p_issue_yy
                 AND x.pol_seq_no = p_pol_seq_no
                 AND x.renew_no   = p_renew_no
      --> modified by bdarusin 11222002 to include spoiled policies
         --  if policy is spoiled, check the spld_acct_ent_date
           AND P_Risk_Profile.Date_Risk(x.acct_ent_date, x.eff_date, x.issue_date,x.booking_mth,x.booking_year,
                                        x.spld_acct_ent_date, x.pol_flag, p_basis, p_from, p_to, null) = 1
                 --if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
           AND dist_flag = DECODE(x.pol_flag,'5','4','3')
                 AND (x.endt_seq_no = 0 OR
                     (x.endt_seq_no <> 0
                     AND EXISTS (SELECT 1 --check if orginal policy exists
                                FROM gipi_polbasic c
                            WHERE c.line_cd     = x.line_cd
                                AND c.subline_cd  = x.subline_cd
                              AND c.iss_cd      = x.iss_cd
                              AND c.issue_yy    = x.issue_yy
                                AND c.pol_seq_no  = x.pol_seq_no
                                 AND c.renew_no    = x.renew_no
                                 AND c.endt_seq_no = 0
               --> modified by bdarusin 11222002 to include spoiled policies
               --  if policy is spoiled, check the spld_acct_ent_date
                          AND P_Risk_Profile.Date_Risk(c.acct_ent_date, c.eff_date,
                                            c.issue_date,c.booking_mth, c.booking_year,
                 c.spld_acct_ent_date, c.pol_flag,
                                            p_basis, p_from, p_to, null) = 1)
      )))
  LOOP
    v_item_ann_tsi := tsi.tsi_amt;
 EXIT;
  END LOOP;
  RETURN(v_item_ann_tsi);
END;
/


