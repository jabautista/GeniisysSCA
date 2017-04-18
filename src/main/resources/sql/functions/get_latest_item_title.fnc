DROP FUNCTION CPI.GET_LATEST_ITEM_TITLE;

CREATE OR REPLACE FUNCTION CPI.Get_Latest_Item_Title (p_line_cd      gipi_polbasic.line_cd%TYPE,
                                                  --p_subline_cd   gipi_polbasic.line_cd%TYPE, 		--Commented out by MJ Fabroa 03/08/2013. Confirmed by Ms Jen.
												  p_subline_cd   gipi_polbasic.subline_cd%TYPE,
                                                  p_iss_cd       gipi_polbasic.iss_cd%TYPE,
                                                  p_issue_yy     gipi_polbasic.issue_yy%TYPE,
                                                  p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
                                                  p_renew_no     gipi_polbasic.renew_no%TYPE,
												  p_item_no      gipi_item.item_no%TYPE,
                                                  p_loss_date    DATE,
                                                  p_eff_date     DATE,
												  p_expiry_date  DATE) RETURN CHARACTER IS
												  
  /* MJ Fabroa 03/08/2013
  ** Modified p_subline_cd data type from 
  ** gipi_polbasic.line_cd%TYPE to gipi_polbasic.subline_cd%TYPE to
  */  
  
  v_item_title    gipi_item.item_title%TYPE;
BEGIN
  FOR get_title  IN (
   SELECT y.item_title
     FROM gipi_polbasic x,
          gipi_item  y
    WHERE 1=1
      AND x.policy_id     = y.policy_id
      AND x.line_cd    = p_line_cd
      AND x.subline_cd = p_subline_cd
      AND x.iss_cd     = p_iss_cd
      AND x.issue_yy   = p_issue_yy
      AND x.pol_seq_no = p_pol_seq_no
      AND x.renew_no   = p_renew_no
      AND x.pol_flag IN ('1','2','3','X')
	  AND y.item_no    = p_item_no
      AND trunc(DECODE(TRUNC(x.eff_date),TRUNC(x.incept_date),
          p_eff_date, x.eff_date ))   <= p_loss_date
      AND TRUNC(DECODE(NVL(x.endt_expiry_date, x.expiry_date),
          x.expiry_date,p_expiry_date,x.endt_expiry_date))
          >= p_loss_date
      AND NOT EXISTS(SELECT 'X'
                       FROM gipi_polbasic m,
                            gipi_item  n
                      WHERE m.line_cd    = p_line_cd
                        AND m.subline_cd = p_subline_cd
                        AND m.iss_cd     = p_iss_cd
                        AND m.issue_yy   = p_issue_yy
                        AND m.pol_seq_no = p_pol_seq_no
                        AND m.renew_no   = p_renew_no
                        AND m.pol_flag IN ('1','2','3','X')
                        AND m.endt_seq_no > x.endt_seq_no
                        AND NVL(m.back_stat,5) = 2
                        AND m.policy_id  = n.policy_id
                        AND n.item_no    = p_item_no
                        AND trunc(DECODE(TRUNC(m.eff_date),TRUNC(m.incept_date),
                            p_eff_date, m.eff_date ))   <= p_loss_date
                        AND TRUNC(DECODE(NVL(m.endt_expiry_date, m.expiry_date),
                            m.expiry_date,p_expiry_date,m.endt_expiry_date))
                        >= p_loss_date)
      ORDER BY x.eff_date DESC)
  LOOP
    v_item_title   := get_title.item_title;
    EXIT;
  END LOOP;
  RETURN v_item_title;
END Get_Latest_Item_Title;
/


