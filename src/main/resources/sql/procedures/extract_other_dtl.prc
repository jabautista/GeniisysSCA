DROP PROCEDURE CPI.EXTRACT_OTHER_DTL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Other_Dtl (p_expiry_date        gicl_claims.expiry_date%TYPE,
                             p_incept_date        gicl_claims.expiry_date%TYPE,
                             p_loss_date          gicl_claims.loss_date%TYPE,
                             p_clm_endt_seq_no    gicl_claims.max_endt_seq_no%TYPE,
                             p_line_cd            gicl_claims.line_cd%TYPE,
                             p_subline_cd         gicl_claims.subline_cd%TYPE,
                             p_pol_iss_cd         gicl_claims.iss_cd%TYPE,
                             p_issue_yy           gicl_claims.issue_yy%TYPE,
                             p_pol_seq_no         gicl_claims.pol_seq_no%TYPE,
                             p_renew_no       gicl_claims.renew_no%TYPE,
                             p_claim_id           gicl_claims.claim_id%TYPE,
                             p_item_no            gicl_clm_item.item_no%TYPE)
/** Created by : Hardy Teng
    Date Created : 09/22/03
**/
IS
  v_endt_seq_no		gipi_polbasic.endt_seq_no%TYPE;
  v_item_title          gicl_clm_item.item_title%TYPE;
  v_currency_cd         gicl_clm_item.currency_cd%TYPE;
  v_other_info          gicl_clm_item.other_info%TYPE;
  v_currency_rate       gicl_clm_item.currency_rate%TYPE;
  v_clm_currency_cd     gicl_clm_item.clm_currency_cd%TYPE;
  v_clm_currency_rate   gicl_clm_item.clm_currency_rate%TYPE;
BEGIN
  FOR v1 IN (SELECT a.endt_seq_no, c.currency_cd, c.currency_rt,
                    c.other_info, c.item_title
               FROM gipi_polbasic a, giis_currency b, gipi_item c
              WHERE a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
    	        AND c.item_no = p_item_no
                AND a.endt_seq_no > p_clm_endt_seq_no
                AND c.currency_cd = b.main_currency_cd
 	        AND a.policy_id = c.policy_id
                AND a.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),
                    p_incept_date, a.eff_date))
                    <= p_loss_date
                AND DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date, p_expiry_date, a.endt_expiry_date)
                    >= p_loss_date
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_endt_seq_no 	        := v1.endt_seq_no;
    v_item_title                := v1.item_title;
    v_currency_cd 	        := v1.currency_cd;
    v_currency_rate             := v1.currency_rt;
    v_clm_currency_cd 	        := v1.currency_cd;
    v_clm_currency_rate	        := v1.currency_rt;
    v_other_info 	        := v1.other_info;
    EXIT;
  END LOOP;
  FOR v2 IN (SELECT c.currency_cd, c.currency_rt,
                    c.other_info, c.item_title
               FROM gipi_polbasic a, giis_currency b, gipi_item c
              WHERE a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND c.currency_cd = b.main_currency_cd
	        AND c.item_no = p_item_no
                AND a.policy_id = c.policy_id
                AND a.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),
                    p_incept_date, a.eff_date))
                    <= p_loss_date
                AND DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date, p_expiry_date, a.endt_expiry_date)
                    >= p_loss_date
 	        AND NVL(a.back_stat, 5) = 2
 	        AND a.endt_seq_no > v_endt_seq_no
              ORDER BY endt_seq_no DESC)
  LOOP
    v_item_title        := v2.item_title;
    v_currency_cd       := v2.currency_cd;
    v_currency_rate     := v2.currency_rt;
    v_clm_currency_cd 	:= v2.currency_cd;
    v_clm_currency_rate	:= v2.currency_rt;
    v_other_info 	:= v2.other_info;
    EXIT;
  END LOOP;
  UPDATE gicl_clm_item
     SET item_title = NVL(v_item_title,item_title),
         currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rate,currency_rate),
         clm_currency_cd = NVL(v_clm_currency_cd,clm_currency_cd),
         clm_currency_rate = NVL(v_clm_currency_rate,clm_currency_rate),
         other_info = NVL(v_other_info,other_info)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/


