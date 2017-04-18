DROP PROCEDURE CPI.EXTRACT_LATEST_CA_BENF;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Ca_Benf (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
   v_beneficiary_no		gicl_beneficiary_dtl.beneficiary_no%TYPE;
   v_beneficiary_name		gicl_beneficiary_dtl.beneficiary_name%TYPE;
   v_beneficiary_addr		gicl_beneficiary_dtl.beneficiary_addr%TYPE;
   v_position_cd		gicl_beneficiary_dtl.position_cd%TYPE;
   v_date_of_birth		gicl_beneficiary_dtl.date_of_birth%TYPE;
   v_civil_status		gicl_beneficiary_dtl.civil_status%TYPE;
   v_age			gicl_beneficiary_dtl.age%TYPE;
   v_sex			gicl_beneficiary_dtl.sex%TYPE;
   v_relation			gicl_beneficiary_dtl.relation%TYPE;
BEGIN
  FOR rec IN (SELECT beneficiary_no
                FROM gicl_beneficiary_dtl
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no)
  LOOP
    FOR v1 IN (SELECT a.endt_seq_no,c.beneficiary_no, c.beneficiary_name,
                      c.beneficiary_addr, c.position_cd, c.date_of_birth,
                      c.civil_status, c.age, c.sex, c.relation
                 FROM gipi_polbasic a, gipi_item b, gipi_beneficiary c
                WHERE a.line_cd    = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd     = p_pol_iss_cd
                  AND a.issue_yy   = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no   = p_renew_no
                  AND a.pol_flag IN ('1','2','3','X')
                  AND a.endt_seq_no > p_clm_endt_seq_no
                  AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                              a.eff_date)) <= p_loss_date
                  AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                      a.expiry_date,p_expiry_date,a.endt_expiry_date))
                      >= p_loss_date
                  AND b.item_no    = p_item_no
	  	  AND c.beneficiary_no = rec.beneficiary_no
                  AND a.policy_id  = b.policy_id
                  AND b.policy_id  = c.policy_id
                  AND b.item_no    = c.item_no
                ORDER BY eff_date DESC, endt_seq_no DESC)
    LOOP
      v_endt_seq_no := v1.endt_seq_no;
      v_beneficiary_name := v1.beneficiary_name;
      v_beneficiary_addr := v1.beneficiary_addr;
      v_position_cd := v1.position_cd;
      v_date_of_birth := v1.date_of_birth;
      v_civil_status := v1.civil_status;
      v_age := v1.age;
      v_sex := v1.sex;
      v_relation := v1.relation;
      EXIT;
    END LOOP;
    FOR v2 IN (SELECT a.endt_seq_no, c.beneficiary_no, c.beneficiary_name,
                      c.beneficiary_addr, c.position_cd, c.date_of_birth,
                      c.civil_status, c.age, c.sex, c.relation
                 FROM gipi_polbasic a, gipi_item b, gipi_beneficiary c
                WHERE a.line_cd    = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd     = p_pol_iss_cd
                  AND a.issue_yy   = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no   = p_renew_no
                  AND a.pol_flag IN ('1','2','3','X')
                  AND NVL(a.back_stat,5) = 2
                  AND endt_seq_no > v_endt_seq_no
                  AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                              a.eff_date )) <= p_loss_date
                  AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                      a.expiry_date,p_expiry_date,a.endt_expiry_date))
                      >= p_loss_date
                  AND b.item_no    = p_item_no
	 	  AND c.beneficiary_no = rec.beneficiary_no
                  AND a.policy_id  = b.policy_id
                  AND b.policy_id  = c.policy_id
                  AND b.item_no    = c.item_no
                ORDER BY endt_seq_no DESC)
     LOOP
       v_beneficiary_name := NVL(v2.beneficiary_name,v_beneficiary_name);
       v_beneficiary_addr := NVL(v2.beneficiary_addr,v_beneficiary_addr);
       v_position_cd := NVL(v2.position_cd,v_position_cd);
       v_date_of_birth := NVL(v2.date_of_birth,v_date_of_birth);
       v_civil_status := NVL(v2.civil_status,v_civil_status);
       v_age := NVL(v2.age,v_age);
       v_sex := NVL(v2.sex,v_sex);
       v_relation := NVL(v2.relation,v_relation);
       EXIT;
    END LOOP;
    UPDATE gicl_beneficiary_dtl
       SET beneficiary_name = NVL(v_beneficiary_name,beneficiary_name),
           beneficiary_addr = NVL(v_beneficiary_addr,beneficiary_addr),
           position_cd = NVL(v_position_cd,position_cd),
           date_of_birth = NVL(v_date_of_birth,date_of_birth),
           civil_status = NVL(v_civil_status,civil_status),
           age = NVL(v_age,age),
           sex = NVL(v_sex,sex),
           relation = NVL(v_relation,relation)
     WHERE claim_id = p_claim_id
       AND item_no = p_item_no
       AND beneficiary_no = rec.beneficiary_no;
  END LOOP;
END;
/


