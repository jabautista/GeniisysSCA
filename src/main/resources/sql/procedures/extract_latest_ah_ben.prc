DROP PROCEDURE CPI.EXTRACT_LATEST_AH_BEN;

CREATE OR REPLACE PROCEDURE CPI.extract_latest_ah_ben (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
IS
  v_endt_seq_no		GIPI_POLBASIC.endt_seq_no%TYPE;
  v_beneficiary_no      gipi_beneficiary.beneficiary_no%TYPE;
  v_beneficiary_name    gipi_beneficiary.beneficiary_name%TYPE;
  v_beneficiary_addr    gipi_beneficiary.beneficiary_addr%TYPE;
  v_position_cd         gipi_beneficiary.position_cd%TYPE;
  v_position            giis_position.position%TYPE;
  v_date_of_birth       gipi_beneficiary.date_of_birth%TYPE;
  v_age                 gipi_beneficiary.age%TYPE;
  v_civil_status        gipi_beneficiary.civil_status%TYPE;
  v_sex                 gipi_beneficiary.sex%TYPE;
  v_relation            gipi_beneficiary.relation%TYPE;
BEGIN
  FOR rec IN (SELECT beneficiary_no
                FROM gicl_beneficiary_dtl
               WHERE claim_id = p_claim_id
                 AND item_no = p_item_no)
  LOOP
    FOR get_info IN(SELECT c.endt_seq_no endt_seq_no,
                           f.beneficiary_name beneficiary_name,
                           f.beneficiary_addr beneficiary_addr,
                           f.position_cd position_cd,
                           f.date_of_birth date_of_birth,
                           f.civil_status civil_status,
                           f.age age,
                           f.sex sex,
                           f.relation relation
                      FROM gipi_polbasic c,
                           gipi_beneficiary f,
                           gipi_item g
                     WHERE c.line_cd            = p_line_cd
                       AND c.subline_cd         = p_subline_cd
                       AND c.iss_cd             = p_pol_iss_cd
                       AND c.issue_yy           = p_issue_yy
                       AND c.pol_seq_no         = p_pol_seq_no
                       AND c.renew_no           = p_renew_no
                       AND g.item_no            = f.item_no
                       AND c.policy_id          = g.policy_id
                       AND g.policy_id          = f.policy_id
                       AND c.pol_flag           IN ('1','2','3','X')
                       AND c.endt_seq_no > p_clm_endt_seq_no
                       AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date),                            NVL(g.from_date,p_incept_date), NVL(g.from_date,c.eff_date) ))
                           <= p_loss_date
                       AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
                           c.expiry_date,NVL(g.to_date,p_expiry_date),
                           NVL(g.to_date,c.endt_expiry_date))) >= p_loss_date
                       AND f.beneficiary_no     = rec.beneficiary_no
                       AND f.item_no            = p_item_no
                     ORDER BY c.eff_date DESC, c.endt_seq_no DESC)
    LOOP
      v_beneficiary_name	:= NVL(get_info.beneficiary_name,v_beneficiary_name);
      v_beneficiary_addr	:= NVL(get_info.beneficiary_addr,v_beneficiary_addr);
      v_position_cd	        := NVL(get_info.position_cd,v_position_cd);
      v_date_of_birth	        := NVL(get_info.date_of_birth,v_date_of_birth);
      v_age	                := NVL(get_info.age,v_age);
      v_civil_status	        := NVL(get_info.civil_status,v_civil_status);
      v_sex           	        := NVL(get_info.sex,v_sex);
      v_relation	        := NVL(get_info.relation,v_relation);
      v_endt_seq_no             := get_info.endt_seq_no;
      EXIT;
    END LOOP;
    FOR get_info2 IN(SELECT c.endt_seq_no endt_seq_no,
                            f.beneficiary_name beneficiary_name,
                            f.beneficiary_addr beneficiary_addr,
                            f.position_cd position_cd,
                            f.date_of_birth date_of_birth,
                            f.civil_status civil_status,
                            f.age age,
                            f.sex sex,
                            f.relation relation
                       FROM gipi_polbasic c,
                            gipi_beneficiary f,
                            gipi_item g
                      WHERE c.line_cd            = p_line_cd
                        AND c.subline_cd         = p_subline_cd
                        AND c.iss_cd             = p_pol_iss_cd
                        AND c.issue_yy           = p_issue_yy
                        AND c.pol_seq_no         = p_pol_seq_no
                        AND c.renew_no           = p_renew_no
                        AND g.item_no            = f.item_no
                        AND c.policy_id          = g.policy_id
                        AND g.policy_id          = f.policy_id
                        AND c.pol_flag           IN ('1','2','3','X')
                        AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date),                             NVL(g.from_date,p_incept_date), NVL(g.from_date,c.eff_date)))                                    <= p_loss_date
                        AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
                            c.expiry_date,NVL(g.to_date,p_expiry_date),
                            NVL(g.to_date,c.endt_expiry_date)))
                            >= p_loss_date
                        AND f.beneficiary_no     = rec.beneficiary_no
                        AND f.item_no            = p_item_no
                        AND nvl(c.back_stat, 5)  = 2
                        AND c.endt_seq_no        > v_endt_seq_no
                      ORDER BY c.endt_seq_no DESC)
    LOOP
      v_beneficiary_name	:= NVL(get_info2.beneficiary_name,v_beneficiary_name);
      v_beneficiary_addr	:= NVL(get_info2.beneficiary_addr,v_beneficiary_addr);
      v_position_cd	        := NVL(get_info2.position_cd,v_position_cd);
      v_date_of_birth	        := NVL(get_info2.date_of_birth,v_date_of_birth);
      v_age	                := NVL(get_info2.age,v_age);
      v_civil_status	        := NVL(get_info2.civil_status,v_civil_status);
      v_sex           	        := NVL(get_info2.sex,v_sex);
      v_relation	        := NVL(get_info2.relation,v_relation);
      EXIT;
    END LOOP;
    UPDATE gicl_beneficiary_dtl
       SET beneficiary_name = NVL(v_beneficiary_name,beneficiary_name),
           beneficiary_addr = NVL(v_beneficiary_addr,beneficiary_addr),
           position_cd = NVL(v_position_cd,position_cd),
           age = NVL(v_age,age),
           civil_status = NVL(v_civil_status,civil_status),
           sex = NVL(v_sex,sex),
           relation = NVL(v_relation,relation)
     WHERE claim_id = p_claim_id
       AND item_no = p_item_no
       AND beneficiary_no = rec.beneficiary_no;
  END LOOP;
END;
/


