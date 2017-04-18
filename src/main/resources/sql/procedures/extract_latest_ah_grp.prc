DROP PROCEDURE CPI.EXTRACT_LATEST_AH_GRP;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Ah_Grp  (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
                                  p_item_no          gicl_clm_item.item_no%TYPE,
                                  p_grouped_item_no  gicl_casualty_dtl.grouped_item_no%TYPE)

/** Created by : Hardy Teng
    Date Created : 09/22/03
**/

IS
  v_item_no                        gipi_item.item_no%TYPE;
  v_item_title                     gipi_item.item_title%TYPE;
  v_grouped_item_no                gipi_grouped_items.grouped_item_no%TYPE;
  v_grouped_item_title             gipi_grouped_items.grouped_item_title%TYPE;
  v_currency_cd                    gipi_item.currency_cd%TYPE;
  v_currency_rt                    gipi_item.currency_rt%TYPE;
  v_currency_desc                  giis_currency.currency_desc%TYPE;
  v_position_cd                    gipi_accident_item.position_cd%TYPE;
  v_position                       giis_position.position%TYPE;
  v_level_cd                       gipi_accident_item.level_cd%TYPE;
  v_monthly_salary                 gipi_accident_item.monthly_salary%TYPE;
  v_salary_grade                   gipi_accident_item.salary_grade%TYPE;
  v_amount_coverage                gipi_grouped_items.amount_coverage%TYPE;
  v_date_of_birth                  gipi_accident_item.date_of_birth%TYPE;
  v_age                            gipi_accident_item.age%TYPE;
  v_civil_status                   gipi_accident_item.civil_status%TYPE;
  v_sex                            gipi_accident_item.sex%TYPE;
  v_endt_seq_no			   gipi_polbasic.endt_seq_no%TYPE;
BEGIN
  FOR get_item_dtl IN (SELECT c.endt_seq_no endt_seq_no, b.item_title item_title,
                   	      e.grouped_item_title grouped_item_title,
                    	      b.currency_cd currency_cd,
                 	      b.currency_rt currency_rt,
                  	      e.position_cd position_cd,
                  	      a.level_cd level_cd,
                 	      e.salary monthly_salary,
                  	      e.salary_grade salary_grade,
                   	      e.amount_coverage amount_coverage,
                  	      e.date_of_birth date_of_birth,
                  	      e.age age,
                 	      e.civil_status civil_status,
                  	      e.sex sex
                    	 FROM gipi_polbasic c,
                  	      gipi_grouped_items e,
                    	      gipi_item b,
                              gipi_accident_item a
                        WHERE c.line_cd            = p_line_cd
                          AND c.subline_cd         = p_subline_cd
                          AND c.iss_cd             = p_pol_iss_cd
                          AND c.issue_yy           = p_issue_yy
                  	  AND c.pol_seq_no         = p_pol_seq_no
                  	  AND c.renew_no           = p_renew_no
                          AND c.policy_id          = b.policy_id
                          AND b.policy_id          = a.policy_id(+)
                   	  AND b.item_no            = a.item_no(+)
                  	  AND b.policy_id          = e.policy_id (+)
                   	  AND b.item_no            = e.item_no (+)
                          AND c.pol_flag       IN ('1','2','3','X')
                   	  AND e.grouped_item_no    = p_grouped_item_no
                  	  AND b.item_no            = p_item_no
                          AND c.endt_seq_no > p_clm_endt_seq_no
                          AND TRUNC(DECODE(TRUNC(NVL(b.from_date,c.eff_date)),
                              TRUNC(c.incept_date), NVL(b.from_date,p_incept_date),
                              NVL(b.from_date,c.eff_date))) <= p_loss_date
                          AND TRUNC(DECODE(NVL(b.TO_DATE,NVL(c.endt_expiry_date, c.expiry_date)),
                              c.expiry_date,NVL(b.TO_DATE,p_expiry_date),
                              NVL(b.TO_DATE,c.endt_expiry_date))) >= p_loss_date
                        ORDER BY c.eff_date DESC, c.endt_seq_no DESC)
  LOOP
    v_item_title                  := NVL(get_item_dtl.item_title,v_item_title);
    v_currency_cd                 := NVL(get_item_dtl.currency_cd,v_currency_cd);
    v_currency_rt                 := NVL(get_item_dtl.currency_rt,v_currency_rt);
    v_position_cd                 := NVL(get_item_dtl.position_cd,v_position_cd);
    v_level_cd                    := NVL(get_item_dtl.level_cd,v_level_cd);
    v_monthly_salary              := NVL(get_item_dtl.monthly_salary,v_monthly_salary);
    v_salary_grade                := NVL(get_item_dtl.salary_grade,v_salary_grade);
    v_date_of_birth               := NVL(get_item_dtl.date_of_birth,v_date_of_birth);
    v_age                         := NVL(get_item_dtl.age,v_age);
    v_civil_status                := NVL(get_item_dtl.civil_status,v_civil_status);
    v_sex                         := NVL(get_item_dtl.sex,v_sex);
    v_amount_coverage             := NVL(get_item_dtl.amount_coverage,v_amount_coverage);
    v_grouped_item_title          := NVL(get_item_dtl.grouped_item_title,v_grouped_item_title);
    v_endt_seq_no                 := get_item_dtl.endt_seq_no;
    EXIT;
  END LOOP;
  FOR get_item_dtl2 IN (SELECT b.item_title item_title,
                      	       e.grouped_item_title grouped_item_title,
                       	       b.currency_cd currency_cd,
                     	       b.currency_rt currency_rt,
                   	       e.position_cd position_cd,
                   	       a.level_cd level_cd,
                      	       e.salary monthly_salary,
                     	       e.salary_grade salary_grade,
                    	       e.amount_coverage amount_coverage,
                     	       e.date_of_birth date_of_birth,
                       	       e.age age,
                               e.civil_status civil_status,
                               e.sex sex
                      	  FROM gipi_polbasic c,
                               gipi_grouped_items e,
                               gipi_item b,
                               gipi_accident_item a
                         WHERE c.line_cd            = p_line_cd
                           AND c.subline_cd         = p_subline_cd
                           AND c.iss_cd             = p_pol_iss_cd
                           AND c.issue_yy           = p_issue_yy
                     	   AND c.pol_seq_no         = p_pol_seq_no
                   	   AND c.renew_no           = p_renew_no
                           AND c.policy_id          = b.policy_id
                           AND b.policy_id          = a.policy_id(+)
                    	   AND b.item_no            = a.item_no(+)
                   	   AND b.policy_id          = e.policy_id (+)
                    	   AND b.item_no            = e.item_no (+)
                           AND c.pol_flag           IN ('1','2','3','X')
                    	   AND e.grouped_item_no    = p_grouped_item_no
                           AND b.item_no            = p_item_no
                           AND TRUNC(DECODE(TRUNC(NVL(b.from_date,c.eff_date)),
                               TRUNC(c.incept_date), NVL(b.from_date,p_incept_date),
                               NVL(b.from_date,c.eff_date))) <= p_loss_date
                           AND TRUNC(DECODE(NVL(b.TO_DATE,NVL(c.endt_expiry_date,                                               c.expiry_date)),c.expiry_date,NVL(b.TO_DATE,p_expiry_date),
                               NVL(b.TO_DATE,c.endt_expiry_date))) >= p_loss_date
                           AND NVL(c.back_stat,5) = 2
                           AND c.endt_seq_no > v_endt_seq_no
                         ORDER BY c.endt_seq_no DESC)
  LOOP
    v_item_title                  := NVL(get_item_dtl2.item_title,v_item_title);
    v_currency_cd                 := NVL(get_item_dtl2.currency_cd,v_currency_cd);
    v_currency_rt                 := NVL(get_item_dtl2.currency_rt,v_currency_rt);
    v_position_cd                 := NVL(get_item_dtl2.position_cd,v_position_cd);
    v_level_cd                    := NVL(get_item_dtl2.level_cd,v_level_cd);
    v_monthly_salary              := NVL(get_item_dtl2.monthly_salary,v_monthly_salary);
    v_salary_grade                := NVL(get_item_dtl2.salary_grade,v_salary_grade);
    v_date_of_birth               := NVL(get_item_dtl2.date_of_birth,v_date_of_birth);
    v_age                         := NVL(get_item_dtl2.age,v_age);
    v_civil_status                := NVL(get_item_dtl2.civil_status,v_civil_status);
    v_sex                         := NVL(get_item_dtl2.sex,v_sex);
    v_amount_coverage             := NVL(get_item_dtl2.amount_coverage,v_amount_coverage);
    v_grouped_item_title          := NVL(get_item_dtl2.grouped_item_title,v_grouped_item_title);
    EXIT;
  END LOOP;
  UPDATE gicl_accident_dtl
     SET item_title = NVL(v_item_title,item_title),
         currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rt,currency_rate),
         position_cd = NVL(v_position_cd,position_cd),
         level_cd = NVL(v_level_cd,level_cd),
         monthly_salary = NVL(v_monthly_salary,monthly_salary),
         salary_grade = NVL(v_salary_grade,salary_grade),
         date_of_birth = NVL(v_date_of_birth,date_of_birth),
         age = NVL(v_age,age),
         civil_status = NVL(v_civil_status,civil_status),
         sex = NVL(v_sex,sex),
         amount_coverage = NVL(v_amount_coverage,amount_coverage),
         grouped_item_title = NVL(v_grouped_item_title,grouped_item_title)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no
     AND grouped_item_no = p_grouped_item_no;
END;
/


