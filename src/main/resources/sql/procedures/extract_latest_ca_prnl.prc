DROP PROCEDURE CPI.EXTRACT_LATEST_CA_PRNL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Ca_Prnl (p_expiry_date      gicl_claims.expiry_date%TYPE,
                             p_incept_date      gicl_claims.expiry_date%TYPE,
                             p_loss_date        gicl_claims.loss_date%TYPE,
                             p_clm_endt_seq_no  gicl_claims.max_endt_seq_no%TYPE,
                             p_line_cd          gicl_claims.line_cd%TYPE,
                             p_subline_cd       gicl_claims.subline_cd%TYPE,
                             p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
                             p_issue_yy         gicl_claims.issue_yy%TYPE,
                             p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                             p_renew_no     gicl_claims.renew_no%TYPE,
                             p_claim_id         gicl_claims.claim_id%TYPE,
                             p_item_no          gicl_clm_item.item_no%TYPE)

/** Created by : Hardy Teng
    Date Created : 09/22/03
**/

IS
   v_endt_seq_no		gipi_polbasic.endt_seq_no%TYPE;
   v_name			gicl_casualty_personnel.name%TYPE;
   v_capacity_cd		gicl_casualty_personnel.capacity_cd%TYPE;
   v_include_tag		gicl_casualty_personnel.include_tag%TYPE;
   v_amount_covered		gicl_casualty_personnel.amount_covered%TYPE;
BEGIN
  FOR rec IN (SELECT personnel_no
                FROM gicl_casualty_personnel
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no)
  LOOP
    FOR v1 IN (SELECT a.endt_seq_no, c.name, c.capacity_cd, c.include_tag,
		      c.amount_covered
	         FROM gipi_polbasic a,
		      gipi_item b,
	 	      gipi_casualty_personnel c
                WHERE a.line_cd    = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd     = p_pol_iss_cd
                  AND a.issue_yy   = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no   = p_renew_no
                  AND a.endt_seq_no > p_clm_endt_seq_no
                  AND a.pol_flag IN ('1','2','3','X')
                  AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                              a.eff_date)) <= p_loss_date
                  AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                      a.expiry_date,p_expiry_date,a.endt_expiry_date))
                      >= p_loss_date
                  AND b.item_no    = p_item_no
   		  AND c.personnel_no = rec.personnel_no
                  AND a.policy_id  = b.policy_id
 		  AND b.policy_id  = c.policy_id
                  AND b.item_no    = c.item_no
                ORDER BY eff_date DESC, endt_seq_no DESC)
     LOOP
	v_endt_seq_no := v1.endt_seq_no;
	v_name := v1.name;
   	v_capacity_cd := v1.capacity_cd;
        v_include_tag := v1.include_tag;
	v_amount_covered := v1.amount_covered;
        EXIT;
     END LOOP;
     FOR v2 IN (SELECT c.name, c.capacity_cd, c.include_tag, c.amount_covered
	          FROM gipi_polbasic a, gipi_item b, gipi_casualty_personnel c
                 WHERE a.line_cd    = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd     = p_pol_iss_cd
                   AND a.issue_yy   = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no   = p_renew_no
                   AND a.pol_flag IN ('1','2','3','X')
                   AND NVL(a.back_stat,5) = 2
                   AND endt_seq_no > v_endt_seq_no
                   AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),                                             p_incept_date, a.eff_date ))
                       <= p_loss_date
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                       a.expiry_date,p_expiry_date,a.endt_expiry_date))
                       >= p_loss_date
                 AND b.item_no    = p_item_no
  		 AND c.personnel_no = rec.personnel_no
                 AND a.policy_id  = b.policy_id
		 AND b.policy_id  = c.policy_id
                 AND b.item_no    = c.item_no
               ORDER BY endt_seq_no DESC)
     LOOP
	v_name := NVL(v2.name,v_name);
   	v_capacity_cd := NVL(v2.capacity_cd,v_capacity_cd);
	v_include_tag := NVL(v2.include_tag,v_include_tag);
	v_amount_covered := NVL(v2.amount_covered,v_amount_covered);
        EXIT;
    END LOOP;
    UPDATE gicl_casualty_personnel
       SET name = NVL(v_name,name),
   	   capacity_cd = NVL(v_capacity_cd,capacity_cd),
           include_tag = NVL(v_include_tag,include_tag),
           amount_covered = NVL(v_amount_covered,amount_covered)
     WHERE claim_id = p_claim_id
       AND item_no = p_item_no
       AND personnel_no = rec.personnel_no;
  END LOOP;
END;
/


