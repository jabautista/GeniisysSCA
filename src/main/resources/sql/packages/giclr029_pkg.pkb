CREATE OR REPLACE PACKAGE BODY CPI.giclr029_pkg
AS

    /*
    **  Created by    : Robert Virrey
    **  Date Created  : January 24, 2012
    **  Reference By  : GICLR029 - PRELIMINARY LOSS REPORT
    */
    FUNCTION get_claim_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_claim_tab PIPELINED 
    AS  
        v_report                giclr029_claim_type;
        v_policy_id1            gipi_polbasic.policy_id%TYPE;
    BEGIN
                      
      FOR i IN (SELECT  claim_id,  line_cd, subline_cd, pol_iss_cd,  issue_yy, pol_seq_no, renew_no, 
                        line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy,'09'))||'-'||LTRIM(TO_CHAR(clm_seq_no,'0999999')) claim_number,  
                        line_cd||'-'||subline_cd||'-'||pol_iss_cd||'-'||LTRIM(TO_CHAR(issue_yy,'09'))||'-'||LTRIM(TO_CHAR(pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(renew_no,'09')) policy_number, 
                        LTRIM(TO_CHAR(issue_yy,'09')) uw_year, assd_no, assured_name, dsp_loss_date, loss_date, UPPER(loss_loc1)||' '||UPPER(loss_loc2)||' '||UPPER(loss_loc3) loss_location, 
                        clm_file_date,  pol_eff_date, expiry_date, in_hou_adj, recovery_sw, remarks, clm_stat_cd, UPPER(loss_dtls) loss_dtls, province_cd, city_cd, acct_of_cd, ri_cd
                   FROM gicl_claims
                  WHERE claim_id = p_claim_id)
      LOOP
        v_report.policy_no          := i.policy_number;
        v_report.assured            := i.assured_name;
        v_report.eff_date           := i.pol_eff_date;
        v_report.expiry_date        := i.expiry_date;
        
        v_report.claim_no           := i.claim_number;
        v_report.uw_year            := i.uw_year;
        v_report.loss_dtls          := i.loss_dtls;
        v_report.clm_file_date      := i.clm_file_date;
        v_report.loss_date          := i.dsp_loss_date;
        v_report.loss_location      := i.loss_location;
        v_report.recovery_sw        := i.recovery_sw;
        v_report.assured_name       := i.assured_name;
        v_report.remarks            := i.remarks;    
        v_report.acct_of_cd            := i.acct_of_cd;
        
        --CF_address
        BEGIN
            FOR a IN 
            (SELECT RTRIM(UPPER(address1)||' '||UPPER(address2)||' '||UPPER(address3)) address
              FROM gipi_polbasic a, gicl_claims b
             WHERE a.assd_no = i.assd_no
               AND a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.iss_cd    = b.pol_iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND b.claim_id = i.claim_id
               AND a.pol_flag IN ('1','2','3','X')
               AND TRUNC(a.eff_date) <= TRUNC(b.loss_date) 
               AND TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >= TRUNC(b.loss_date) 
         ORDER BY a.eff_date DESC, a.endt_seq_no DESC)
          LOOP
            v_report.address := a.address;
            EXIT;
          END LOOP;

        
        --CF_issue_date
        BEGIN
            SELECT issue_date
              INTO v_report.issue_date
              FROM gipi_polbasic
             WHERE line_cd = i.line_cd
               AND subline_cd = i.subline_cd
               AND iss_cd = i.pol_iss_cd
               AND issue_yy = i.issue_yy
               AND pol_seq_no = i.pol_seq_no
               AND renew_no = i.renew_no
               AND endt_seq_no = 0;
        END; 
        
        --CF_oldest_os_prem
        BEGIN
          FOR x IN (SELECT decode(a.balance_amt_due,0,NULL,TO_CHAR(b.due_date, 'MM-DD-RRRR'))  due_date,
                                       a.policy_id policy_id
                            FROM gipi_installment b, giac_aging_soa_details a
                             WHERE b.iss_cd = a.iss_cd
                               AND b.iss_cd <> 'RI'
                               AND b.prem_seq_no = a.prem_seq_no
                               AND b.inst_no = a.inst_no
                               AND a.policy_id = v_policy_id1
                            UNION
                            SELECT decode(a.balance_due,0,NULL,TO_CHAR(b.due_date, 'MM-DD-RRRR'))  due_date,
                                        c.policy_id policy_id
                            FROM gipi_installment b, giac_aging_ri_soa_details a, gipi_invoice c
                             WHERE b.iss_cd = 'RI'
                               AND b.prem_seq_no = a.prem_seq_no
                               AND b.inst_no = a.inst_no
                               and c.prem_seq_no = a.prem_seq_no
                       and c.policy_id = v_policy_id1
                       and c.iss_cd = b.iss_cd
                     order by 2 asc)
            LOOP
             /* IF x.balance = 0 THEN
                v_oldest_os_prem := NULL;
              ELSE   */   
              v_report.oldest_os_prem1 := x.due_date;
              exit;
             -- END IF;
            END LOOP;
        END;
        
        --CF_contact_no
        BEGIN
            SELECT phone_no
              INTO v_report.contact_no
              FROM giis_assured
             WHERE assd_no = i.assd_no;
        END;
        
        --f_endorsement_no
        BEGIN
          FOR x IN (SELECT MAX(a.endt_seq_no) endt_seq_no
                      FROM gipi_polbasic a, gicl_claims b
                     WHERE a.line_cd = b.line_cd
                       AND a.subline_cd = b.subline_cd
                       AND a.iss_cd = b.POL_ISS_CD
                       AND a.issue_yy = b.ISSUE_YY
                       AND a.pol_seq_no = b.POL_SEQ_NO
                       AND a.renew_no = b.renew_no
                       AND b.claim_id = i.claim_id)
         LOOP
            v_report.f_endorsement_no := x.endt_seq_no;
         END LOOP;
        END;
        
        --R_2
        DECLARE
          v_r2_line        giis_line.line_cd%type; 
          v_r2_line_mc     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_r2_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MC')
            LOOP   
              v_r2_line_mc := p.param_value_v;
              IF v_r2_line = v_r2_line_mc THEN
                v_report.f_mc_subreport := 'TRUE';
              ELSE
                v_report.f_mc_subreport := 'FALSE';    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --R_10
        DECLARE
          v_line        giis_line.line_cd%type; 
          v_line_fi     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_FI')
            LOOP   
              v_line_fi := p.param_value_v;
              IF v_line = v_line_fi THEN
                v_report.f_dist_subreport := 'TRUE';
              ELSE
                v_report.f_dist_subreport := 'FALSE';    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --R_7
        DECLARE
          v_line        giis_line.line_cd%type; 
          v_line_mn     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP   
              v_line_mn := p.param_value_v;
              IF v_line = v_line_mn THEN
                v_report.f_voy_subreport := 'TRUE';
              ELSE
                v_report.f_voy_subreport := 'FALSE';    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --R_12
        DECLARE
          v_line        giis_line.line_cd%type; 
          v_line_ca     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_CA')
            LOOP   
              v_line_ca := p.param_value_v;
              IF v_line = v_line_ca THEN
                v_report.f_ca_subreport := 'TRUE';
              ELSE
                v_report.f_ca_subreport := 'FALSE';    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --R_17
        DECLARE
          v_line        giis_line.line_cd%type; 
          v_line_ac     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_AC')
            LOOP   
              v_line_ac := p.param_value_v;
              IF v_line = v_line_ac THEN
                v_report.f_ac_subreport := 'TRUE';
              ELSE
                v_report.f_ac_subreport := 'FALSE';    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --R_3
        DECLARE
          v_line        giis_line.line_cd%type; 
          v_line_mc     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MC')
            LOOP   
              v_line_mc := p.param_value_v;
              IF v_line = v_line_mc THEN
                v_report.f_drvr_subreport := 'TRUE';
              ELSE
                v_report.f_drvr_subreport := 'FALSE';    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --M_15
        DECLARE
          v_line        giis_line.line_cd%type; 
          v_line_mc     giis_parameters.param_value_v%type;         
        BEGIN
          FOR m IN (SELECT NVL(menu_line_cd, line_cd) line
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
          LOOP
            v_line := m.line;
            FOR p IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MC')
            LOOP   
              v_line_mc := p.param_value_v;
              IF v_line = v_line_mc THEN
                v_report.f_mtrshp_subreport := 'TRUE';
              ELSE
                v_report.f_mtrshp_subreport := 'FALSE' ;    
              END IF;
            END LOOP;
          END LOOP; 
        END;
        
        --M_4
        DECLARE
         v_adjuster    varchar2(2);
        begin
          FOR rec IN (SELECT 'X' tag
               FROM giis_payees b ,gicl_clm_adjuster a
               WHERE payee_class_cd = giacp.v('ADJP_CLASS_CD')
               AND NVL(cancel_tag, 'N') <> 'Y'
               AND NVL(delete_tag, 'N') <> 'Y'
               AND payee_no  = a.adj_company_cd
               and a.claim_id = p_claim_id)
             LOOP
                 v_adjuster := rec.tag;
             END LOOP;  
         IF v_adjuster IS NOT NULL THEN      
          v_report.f_adjster_subreport := 'TRUE';
         ELSE
          v_report.f_adjster_subreport := 'FALSE';     
         END IF;
         EXCEPTION
            when no_data_found then 
           v_report.f_adjster_subreport := 'false';
        end;
        
        --CF_motorshop
        BEGIN    
          FOR a IN (   
            SELECT DECODE (payee_first_name, null, payee_last_name,
                           payee_last_name||', '||payee_first_name||' '||
                           payee_middle_name) payee
              FROM gicl_clm_claimant a, giis_payees b
             WHERE claim_id = p_claim_id
               AND a.payee_class_cd = b.payee_class_cd
               AND a.clmnt_no = b.payee_no
               AND a.payee_class_cd = (SELECT param_value_v
                                       FROM giac_parameters
                                      WHERE param_name = 'MC_PAYEE_CLASS')
            UNION
            SELECT DECODE (payee_first_name, null, payee_last_name,
                                             payee_last_name||', '||payee_first_name||' '||
                                             payee_middle_name) payee
              FROM gicl_clm_claimant a, giis_payees b
             WHERE claim_id = p_claim_id
               AND b.payee_class_cd = (SELECT param_value_v
                                       FROM giac_parameters
                                      WHERE param_name = 'MC_PAYEE_CLASS')
               AND a.mc_payee_cd = b.payee_no
               AND mc_payee_cd IS NOT NULL) 
          LOOP
            v_report.motorshop := a.payee||chr(10)||v_report.motorshop;
          END LOOP;
          
          --CF_clm_stat_desc
           BEGIN
                FOR x IN (SELECT a.clm_stat_desc
                            FROM giis_clm_stat a
                           WHERE a.clm_stat_cd = i.clm_stat_cd)
              LOOP
                v_report.clm_stat_desc := x.clm_stat_desc;
                EXIT;
              END LOOP;
           END;
        END;
        
        --CF_line
        BEGIN
          BEGIN
            SELECT line_name
              INTO v_report.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
          EXCEPTION
            WHEN OTHERS THEN
              v_report.line_name := NULL;
          END;
        END;
        
        --function CF_1
        BEGIN
          BEGIN
            SELECT user_name
              INTO v_report.in_hou_adj
              FROM giis_users
             WHERE user_id = i.in_hou_adj;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_report.in_hou_adj := null;
          END;
        END; 
        
        --function cf_group_itemformula
        DECLARE
        v_menu_line_cd          giis_line.menu_line_cd%TYPE;
        BEGIN             
            SELECT menu_line_cd
                INTO  v_menu_line_cd
                    FROM giis_line
                WHERE line_cd = i.line_cd; 
                     
          IF ( i.line_cd = giisp.v('LINE_CODE_CA') ) OR (  v_menu_line_cd = giisp.v('LINE_CODE_CA') ) THEN --added condition to separate CASUALTY from PERSONAL ACCIDENT
            SELECT grouped_item_no, UPPER (grouped_item_title)
                INTO v_report.gitem_no, v_report.gitem_title
                FROM gicl_casualty_dtl --table for CA
               WHERE claim_id = i.claim_id;
          ELSIF ( i.line_cd = giisp.v('LINE_CODE_AH') ) OR (  v_menu_line_cd = giisp.v('LINE_CODE_AH') ) THEN --for PERSONAL ACCIDENT
              SELECT grouped_item_no, UPPER (grouped_item_title)
                INTO v_report.gitem_no, v_report.gitem_title
                FROM gicl_accident_dtl --table for PA
               WHERE claim_id = i.claim_id;
            END IF; 
        
          IF v_report.gitem_no IS NOT NULL AND v_report.gitem_title IS NOT NULL THEN --check if both field are not empty
             v_report.gitem := 'GROUPED ITEM ' || v_report.gitem_no || ' - ' || v_report.gitem_title; --modified GROUP ITEM label to GROUPED ITEM
          ELSE
             v_report.gitem := NULL;
          END IF;
         
       EXCEPTION
          WHEN OTHERS
          THEN
             v_report.gitem := NULL;
             
           END;
        
        --cf_leased_toformula
        BEGIN
          SELECT UPPER (assd_name)
            INTO v_report.lease_to
            FROM giis_assured
           WHERE assd_no = i.acct_of_cd;
                   EXCEPTION
            WHEN OTHERS THEN
             v_report.lease_to := NULL;
        END;
    
        --cf_lease_to_labelformula
        BEGIN
           FOR x IN(SELECT label_tag
                      FROM gipi_polbasic
                     WHERE line_cd    = i.line_cd
                       AND subline_cd = i.subline_cd
                       AND iss_cd     = i.pol_iss_cd
                       AND issue_yy   = i.issue_yy
                       AND pol_seq_no = i.pol_seq_no
                       AND renew_no   = i.renew_no
                       AND pol_flag  IN ('1','2','3','X')
                       AND TRUNC(eff_date) <= TRUNC(i.loss_date) --retrieves only those records with effectivity date not later than the loss date
                       AND TRUNC(NVL(endt_expiry_date,expiry_date)) >= TRUNC(i.loss_date) --retrieves only those records with expiry date not earlier than the loss date
                     ORDER BY eff_date DESC, endt_seq_no DESC) --ORDER BY eff_date to consider first the effectivity date of the endorsement, endt_seq_no DESC to consider endt_seq_no if effectivity_date is the same.
           LOOP
               v_report.label_tag := x.label_tag;
               EXIT; --exit after the first record, if there is an existing endorsement it will consider only value of label_tag field of the latest endorsement.
           END LOOP; 
          END;
        END;
        
        IF i.pol_iss_cd = giacp.v('RI_ISS_CD') THEN
            BEGIN
               SELECT ri_name
                 INTO v_report.ri_name
                 FROM giis_reinsurer
                WHERE ri_cd = i.ri_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_report.ri_name := '';
            END;
        END IF;
        
      END LOOP;
      PIPE ROW (v_report);
    END;
    
    FUNCTION get_endt_no(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_endt_tab PIPELINED 
    AS  
        v_report                giclr029_endt_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_subline_cd            GICL_CLAIMS.subline_cd%TYPE;
        v_pol_iss_cd            GICL_CLAIMS.pol_iss_cd%TYPE;
        v_issue_yy              GICL_CLAIMS.issue_yy%TYPE;
        v_pol_seq_no            GICL_CLAIMS.pol_seq_no%TYPE;
        v_renew_no              GICL_CLAIMS.renew_no%TYPE;
        v_loss_date             GICL_CLAIMS.loss_date%TYPE;
    BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd,  issue_yy, renew_no, pol_seq_no, loss_date
        INTO v_line_cd, v_subline_cd, v_pol_iss_cd,  v_issue_yy, v_renew_no, v_pol_seq_no, v_loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;
                      
      FOR i IN (SELECT a.endt_iss_cd || '-' || LTRIM(TO_CHAR(a.endt_yy, '09')) || '-' || LTRIM(TO_CHAR(a.endt_seq_no, '099999')) ENDT_NO,
                       a.issue_date, 
                       a.eff_date,
                       a.endt_seq_no endt_seq_no
                  FROM gipi_polbasic a, 
                       gipi_item b, 
                       gicl_clm_item c --Added by Marlo 1119009  
                 WHERE c.claim_id = p_claim_id
                   AND a.line_cd = v_line_cd        -- added by danny 4/16/2010    
                   AND a.subline_cd = v_subline_cd  -- added by danny 4/16/2010
                   AND a.iss_cd = v_pol_iss_cd      -- added by danny 4/16/2010
                   AND a.issue_yy = v_issue_yy      -- added by danny 4/16/2010
                   AND a.renew_no = v_renew_no      -- added by danny 4/16/2010
                   AND a.pol_seq_no = v_pol_seq_no  -- added by danny 4/16/2010
                   AND a.endt_seq_no <> 0 
                   AND a.eff_date <= decode(a.endt_type, 'A', v_loss_date, 'N', a.eff_date) -- modified by Marlo 02252010 
                   AND a.endt_expiry_date >= decode(a.endt_type, 'A', v_loss_date, 'N', a.endt_expiry_date) -- modified by Marlo 02252010 
                   AND a.pol_flag in ('1', '2', '3', 'X') /* Added by Marlo 
                ** 11192009 
                ** To only display endt with the same affected item with the claim*/ 
                   AND a.policy_id = b.policy_id 
                   AND b.item_no = c.item_no  
                UNION /* Added by Marlo 
                ** 11192009 
                ** To also display items with no items affected.*/ 
                SELECT a.endt_iss_cd || '-' || LTRIM(TO_CHAR(a.endt_yy, '09')) || '-' || LTRIM(TO_CHAR(a.endt_seq_no, '099999')) ENDT_NO,
                       a.issue_date, 
                       a.eff_date,
                       a.endt_seq_no endt_seq_no
                  FROM gipi_polbasic a 
                 WHERE a.endt_seq_no <> 0
                   AND a.line_cd = v_line_cd        -- added by danny 4/16/2010    
                   AND a.subline_cd = v_subline_cd  -- added by danny 4/16/2010
                   AND a.iss_cd = v_pol_iss_cd      -- added by danny 4/16/2010
                   AND a.issue_yy = v_issue_yy      -- added by danny 4/16/2010
                   AND a.renew_no = v_renew_no      -- added by danny 4/16/2010
                   AND a.pol_seq_no = v_pol_seq_no  -- added by danny 4/16/2010 
                   AND a.eff_date <= decode(a.endt_type, 'A', v_loss_date, 'N', a.eff_date) -- modified by Marlo 02252010 
                   AND a.endt_expiry_date >= decode(a.endt_type, 'A', v_loss_date, 'N', a.endt_expiry_date) -- modified by Marlo 02252010 
                   AND a.pol_flag in ('1', '2', '3', 'X') 
                   AND NOT EXISTS (SELECT 1 
                                     FROM gipi_item b 
                                    WHERE a.policy_id = b.policy_id) 
                 ORDER BY endt_seq_no DESC)
      LOOP
        v_report.endt_no       := i.endt_no;
        v_report.issue_date    := i.issue_date;
        v_report.eff_date      := i.eff_date;
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_mc_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_mc_tab PIPELINED 
    AS  
        v_report                giclr029_mc_type;
    BEGIN
                      
      FOR i IN (SELECT a.claim_id, a.item_no, UPPER(a.item_title) item_title, 
                                a.plate_no, a.motor_no, a.serial_no, a.model_year, a.color,
                                a.drvr_name, a.drvr_age, b.car_company, d.subline_cd, d.subline_type_desc, make_cd, b.car_company_cd
                           FROM gicl_motor_car_dtl a, giis_mc_car_company b, 
                                giis_mc_subline_type d, 
                                gicl_claims  e  -- added by nante  9.13.2013
                          WHERE a.claim_id = p_claim_id -- added by danny 4/16/2010
                            AND a.motcar_comp_cd = b.car_company_cd (+) --(+) added by roset, 8/6/2010
                            AND a.subline_type_cd = d.subline_type_cd
                            AND a.claim_id = e.claim_id   --added by nante  9.13.2013
                            AND d.subline_cd = e.subline_cd)  --added by nante  9.13.2013
      LOOP
        v_report.item_title            := i.item_title;
        v_report.model_year            := i.model_year;
        v_report.subline_type          := i.subline_type_desc;
        v_report.serial_no             := i.serial_no;
        v_report.motor_no              := i.motor_no;
        v_report.plate_no              := i.plate_no;
        v_report.color                 := i.color;
        v_report.driver                := i.drvr_name;
        v_report.drvr_age              := i.drvr_age;
        
        --CF_make
         BEGIN
            SELECT make
              INTO v_report.make
              FROM giis_mc_make
             WHERE make_cd = i.make_cd 
               AND car_company_cd = i.car_company_cd;
         EXCEPTION
            WHEN no_data_found THEN
             v_report.make := NULL;
         END;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_fire_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_fire_tab PIPELINED 
    AS  
        v_report                giclr029_fire_type;
    BEGIN
                      
      FOR i IN (SELECT a.claim_id, a.item_no, UPPER(a.item_title) item_title, a.district_no, a.block_no, a.currency_cd, a.block_id, SUM(b.ann_tsi_amt) ann_tsi_amt --, c.district_desc, c.block_desc
                 FROM gicl_fire_dtl a, gicl_item_peril b --, giis_block c
                WHERE a.claim_id = p_claim_id -- added by danny 4/16/2010
                  AND a.claim_id = b.claim_id
                  AND a.item_no = b.item_no
                --AND a.district_no = c.district_no
                --AND a.block_no = c.block_no
                GROUP BY a.claim_id, a.item_no, a.item_title, a.district_no, a.block_no, a.block_id, a.currency_cd)
      LOOP
        v_report.district_no   := i.district_no;
        v_report.block_no      := i.block_no;
        v_report.fire_item     := i.item_title;
        v_report.amt_insured   := i.ann_tsi_amt;
        
        --CF_district_desc
        BEGIN
            SELECT district_desc
              INTO v_report.district_desc
              FROM giis_block
             WHERE block_id = i.block_id;
        END; 
        
         --CF_block_desc
        BEGIN
            SELECT block_desc
              INTO v_report.block_desc
              FROM giis_block
             WHERE district_no = i.district_no
               AND block_id = i.block_id;
        END;
        
         --CF_curr10
        BEGIN
          SELECT short_name
            INTO v_report.curr12
            FROM giis_currency
           WHERE main_currency_cd = i.currency_cd;
        END;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_cargo_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_cargo_tab PIPELINED 
    AS  
        v_report                giclr029_cargo_type;
    BEGIN
                      
      FOR i IN (SELECT claim_id, item_no, vessel_cd, cargo_type, origin, destn
                  FROM gicl_cargo_dtl
                 WHERE claim_id = p_claim_id)
      LOOP
        v_report.voyage_from       := i.origin;
        v_report.voyage_to         := i.destn;
        
        --CF_vessel
        BEGIN
            SELECT vessel_name 
              INTO v_report.vessel
              FROM giis_vessel
             WHERE vessel_cd = i.vessel_cd;
        END;
        
        --CF_cargo
        BEGIN
            SELECT cargo_type_desc
              INTO v_report.cargo_type
              FROM giis_cargo_type
             WHERE cargo_type = i.cargo_type;
        END;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_cslty_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_cslty_tab PIPELINED 
    AS  
        v_report                giclr029_cslty_type;
    BEGIN
                      
      FOR i IN (SELECT a.claim_id, a.item_no, UPPER(item_title) item_title, LTRIM(TO_CHAR(ann_tsi_amt,'999,999,999,990.99')) ann_tsi_amt, a.currency_cd
                  FROM gicl_casualty_dtl a, gicl_item_peril b
                 WHERE a.claim_id = p_claim_id -- added by danny 4/16/2010
                   AND a.claim_id = b.claim_id)
      LOOP
        v_report.casualty_item     := i.item_title;
        v_report.amt_insured2      := i.ann_tsi_amt;
        
        --CF_curr9
        BEGIN
          SELECT short_name
            INTO v_report.curr11
            FROM giis_currency
           WHERE main_currency_cd = i.currency_cd;
        END;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_acdnt_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_acdnt_tab PIPELINED 
    AS  
        v_report                giclr029_acdnt_type;
    BEGIN
                      
      FOR i IN (SELECT a.claim_id, a.item_no, beneficiary_name, b.date_of_birth, b.age, relation
                  FROM gicl_accident_dtl a, gicl_beneficiary_dtl b
                 WHERE a.claim_id = p_claim_id -- added by danny 4/16/2010
                   AND a.claim_id = b.claim_id (+)
                   AND a.item_no = b.item_no (+))
      LOOP
        v_report.beneficiary       := i.beneficiary_name;
        v_report.date_of_birth     := i.date_of_birth;
        v_report.age               := i.age;
        v_report.relation          := i.relation;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_q1_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_q1_tab PIPELINED 
    AS  
        v_report                giclr029_q1_type;
    BEGIN
                      
      FOR i IN (SELECT a.adj_company_cd, a.claim_id,payee_last_name||
                                 DECODE(payee_first_name, NULL, NULL, ', '||payee_first_name)||
                                 DECODE(payee_middle_name, NULL, NULL, ' '||payee_middle_name) adjuster
                            FROM giis_payees b ,gicl_clm_adjuster a
                           WHERE a.claim_id = p_claim_id --added by danny 4/16/2010
                             AND payee_class_cd = giacp.v('ADJP_CLASS_CD')
                             AND NVL(cancel_tag, 'N') <> 'Y'
                             AND NVL(delete_tag, 'N') <> 'Y'
                             AND payee_no  = a.adj_company_cd)
      LOOP
        v_report.adjuster          := i.adjuster;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_loss_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_loss_tab PIPELINED 
    AS  
        v_report                giclr029_loss_type;
        v_item_no               gicl_clm_res_hist.item_no%TYPE;
    BEGIN
                      
      FOR i IN (SELECT claim_id, item_no, peril_cd,  user_id, TO_CHAR(last_update, 'MM-DD-RR HH:MI:SS AM') last_update, 
                      NVL(loss_reserve,0) loss_reserve, NVL(expense_reserve,0) expense_reserve, SUM(NVL(loss_reserve,0) + NVL(expense_reserve,0)) reserve, 
                      remarks,  grouped_item_no, currency_cd
                 FROM gicl_clm_res_hist
                WHERE claim_id = p_claim_id --added by danny 04/16/2010
                  AND tran_id IS NULL
                GROUP BY claim_id, item_no, peril_cd, user_id, last_update, loss_reserve, expense_reserve, remarks, grouped_item_no, currency_cd, HIST_SEQ_NO
                ORDER BY HIST_SEQ_NO DESC,last_update DESC)
      LOOP
--        v_report.remarks1              := i.remarks;
        v_report.item_no               := i.item_no;
        v_report.peril_cd              := i.peril_cd;
        
        BEGIN
          SELECT line_cd
            INTO v_report.line_cd
            FROM gicl_claims
           WHERE claim_id = p_claim_id;
        END;
        
        PIPE ROW (v_report);
        
        
      END LOOP;
    END;
    
    FUNCTION get_peril_name(
        p_line_cd       giis_peril.line_cd%TYPE,
        p_peril_cd      giis_peril.peril_cd%TYPE
    )
    RETURN giclr029_peril_tab PIPELINED 
    AS  
        v_report                giclr029_peril_type;
    BEGIN
                      
      FOR i IN (SELECT peril_name
                  FROM giis_peril
                 WHERE line_cd = p_line_cd /*IN (SELECT line_cd
                                 FROM gicl_item_peril
                                WHERE claim_id = :claim_id14
                                  AND item_no = :item_no12)
                                 -- AND grouped_item_no = :grouped_item_no1)*/
                   AND peril_cd = p_peril_cd)
      LOOP
        v_report.peril      := i.peril_name;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_loss_dtls2(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_peril_cd      giis_peril.peril_cd%TYPE,
        p_item_no       gicl_clm_res_hist.item_no%TYPE  -- bonok :: 10.08.2014
    )
    RETURN giclr029_loss2_tab PIPELINED 
    AS  
        v_report                giclr029_loss2_type;
    BEGIN
                      
      FOR i IN (SELECT user_id, TO_CHAR(setup_date, 'MM-DD-RR HH:MI:SS AM') setup_date, 
                       NVL(loss_reserve,0) loss_reserve, NVL(expense_reserve,0) expense_reserve, SUM(NVL(loss_reserve,0) + NVL(expense_reserve,0)) reserve, 
                       currency_cd, setup_by
                 FROM gicl_clm_res_hist
                WHERE claim_id = p_claim_id --added by danny 04/16/2010
                  AND peril_cd = p_peril_cd
                  AND item_no = p_item_no
                  AND tran_id IS NULL
                GROUP BY claim_id, item_no, peril_cd, user_id, setup_date, loss_reserve, expense_reserve, remarks, grouped_item_no, currency_cd, HIST_SEQ_NO, setup_by
                ORDER BY HIST_SEQ_NO DESC,setup_date DESC)
      LOOP
        v_report.loss_reserve       := i.loss_reserve;
        v_report.expense_reserve    := i.expense_reserve;
        v_report.setup_date         := i.setup_date;
        v_report.user_id            := i.user_id;
        v_report.setup_by			:= i.setup_by;
        
        --CF_curr6
        begin
         FOR x IN (SELECT short_name
                     FROM giis_currency
                    WHERE main_currency_cd = i.currency_cd)
         LOOP
            v_report.curr14 := x.short_name;
         END LOOP;
        end;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_q2_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_item_tab PIPELINED 
    AS  
        v_report                giclr029_item_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_claim_id              GICL_CLAIMS.claim_id%TYPE;
    BEGIN
      SELECT line_cd, claim_id
        INTO v_line_cd, v_claim_id
        FROM gicl_claims
       WHERE claim_id = p_claim_id;
                      
      FOR i IN (SELECT a.claim_id, a.item_no, a.grouped_item_no, 
                       'ITEM '||a.item_no||' - '||UPPER(Get_Gpa_Item_Title(v_claim_id, NVL(menu_line_cd,v_line_cd), a.item_no, a.grouped_item_no)) item
                 FROM gicl_clm_item a, giis_line b, gicl_claims c
                WHERE a.claim_id = p_claim_id -- added by Danny 4/16/2010
                  AND c.line_Cd = b.line_cd
                  AND a.claim_id = c.claim_id)
      LOOP
        v_report.item              := i.item;
        v_report.item_no           := i.item_no; --return Item Number by MAC 11/12/2013.
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_peril_dtls(p_claim_id      gicl_claims.claim_id%TYPE,
                            p_item_no       gicl_clm_item.item_no%TYPE)--added Item Number to retrieve Peril details per Item by MAC 11/12/2013.
    RETURN giclr029_peril_tab PIPELINED 
    AS  
        v_report                giclr029_peril_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_subline_cd            GICL_CLAIMS.subline_cd%TYPE;
        v_pol_iss_cd            GICL_CLAIMS.pol_iss_cd%TYPE;
        v_issue_yy              GICL_CLAIMS.issue_yy%TYPE;
        v_pol_seq_no            GICL_CLAIMS.pol_seq_no%TYPE;
        v_renew_no              GICL_CLAIMS.renew_no%TYPE;
        v_claim_id              GICL_CLAIMS.claim_id%TYPE;
    BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd,  issue_yy, renew_no, pol_seq_no, claim_id
        INTO v_line_cd, v_subline_cd, v_pol_iss_cd,  v_issue_yy, v_renew_no, v_pol_seq_no, v_claim_id
        FROM gicl_claims
       WHERE claim_id = p_claim_id;
                      
      FOR i IN (SELECT b.line_cd, 
                       b.subline_cd, 
                       b.iss_cd, 
                       b.issue_yy, 
                       b.pol_seq_no, 
                       b.renew_no, 
                       a.item_no, 
                       a.peril_cd, 
                       c.peril_name, 
                       SUM(a.tsi_amt) tsi 
                  FROM gipi_itmperil a, 
                       gipi_polbasic b, 
                       giis_peril c, 
                       gipi_item d 
                 WHERE a.policy_id = b.policy_id 
                   AND b.line_cd = v_line_cd        -- added by danny 4/16/2010    
                   AND b.subline_cd = v_subline_cd  -- added by danny 4/16/2010
                   AND b.iss_cd = v_pol_iss_cd      -- added by danny 4/16/2010
                   AND b.issue_yy = v_issue_yy      -- added by danny 4/16/2010
                   AND b.renew_no = v_renew_no      -- added by danny 4/16/2010
                   AND b.pol_seq_no = v_pol_seq_no  -- added by danny 4/16/2010
                   AND b.line_cd = c.line_cd
                   AND b.pol_flag <> '5'  --added by reymon 11112010 add filter to dont include the spoiled endorsements
                   AND a.peril_cd = c.peril_cd 
                   AND c.peril_type = 'B' 
                  -- AND nvl(d.from_date, b.eff_date) <= :loss_date  --comment out by jess 01.03.2011 to display correct TSI amount
                  -- AND nvl(d.to_date, b.expiry_date) >= :loss_date --comment out by jess 01.03.2011 to display correct TSI amount
                   AND a.item_no IN (SELECT item_no 
                                       FROM gicl_item_peril 
                                      WHERE claim_id = v_claim_id) 
                   and d.item_no = a.item_no 
                   and d.policy_id = a.policy_id 
                   AND d.item_no = p_item_no --added Item Number to retrieve Peril details per Item by MAC 11/12/2013.
                 GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no, a.item_no, a.peril_cd, c.peril_name)
      LOOP
        v_report.peril             := i.peril_name;
        v_report.tsi               := i.tsi;
        
        --CF_curr11
        begin
         FOR x IN (SELECT a.short_name
                     FROM giis_currency a, gicl_clm_item b
                    WHERE b.claim_id = v_claim_id
                      AND a.main_currency_cd = b.currency_cd)
         LOOP
            v_report.curr15 := x.short_name;
         END LOOP;
        end;
          
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_q4_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_q4_tab PIPELINED 
    AS  
        v_report                giclr029_q4_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_claim_id              GICL_CLAIMS.claim_id%TYPE;
        v_cf_peril_cd           giis_peril.peril_cd%type;
    BEGIN
      SELECT line_cd, claim_id
        INTO v_line_cd, v_claim_id
        FROM gicl_claims
       WHERE claim_id = p_claim_id;
                      
      FOR i IN (SELECT claim_id, a.line_cd, peril_cd, loss_cat_cd, 
                                   item_no, grouped_item_no, 
                                   'ITEM '||item_no||' - '||UPPER(get_gpa_item_title(claim_id, nvl(menu_line_cd,a.line_cd), item_no, grouped_item_no)) item2
                             FROM gicl_item_peril a, giis_line b
                            WHERE claim_id = p_claim_id --added by danny 4/16/2010
                              AND a.line_cd = v_line_cd
                              AND a.line_cd = b.line_cd)
      LOOP
        v_report.item              := i.item2;
        
        --CF_peril2
        BEGIN
          FOR q IN ( SELECT a.peril_cd
                       FROM gicl_item_peril a, gicl_clm_item b
                      WHERE a.claim_id = v_claim_id
                        AND a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.grouped_item_no = b.grouped_item_no )
          LOOP
            v_cf_peril_cd := q.peril_cd;      
            FOR r IN (
                     SELECT peril_name
                       FROM giis_peril
                      WHERE line_cd = NVL(i.line_cd, v_line_cd)
                        AND peril_cd = i.peril_cd
                        AND peril_cd = q.peril_cd)
            LOOP
              v_report.peril := r.peril_name;
            END LOOP;
          END LOOP;
        END;
        
        --CF_loss_cat_des
        BEGIN
            FOR x IN ( SELECT loss_cat_des
                         FROM giis_loss_ctgry
                        WHERE loss_cat_cd = i.loss_cat_cd
                          AND line_cd = NVL(i.line_cd, v_line_cd))
            LOOP
                v_report.loss_cat_des := x.loss_cat_des;
            END LOOP;
        END;
        
        --CF_loss_reserve2 and CF_expense_reserve2
        BEGIN
            FOR x IN (SELECT NVL(a.loss_reserve,0) loss_reserve,  NVL(a.expense_reserve,0) expense_reserve, b.short_name
                        FROM gicl_clm_reserve a, giis_currency b
                       WHERE claim_id = i.claim_id
                         AND item_no = i.item_no
                         AND grouped_item_no = i.grouped_item_no
                         AND peril_cd = i.peril_cd
                         AND a.currency_cd = b.main_currency_cd)
            LOOP
                v_report.loss_reserve := x.loss_reserve;
				v_report.expense_reserve := x.expense_reserve;
                v_report.curr5 := x.short_name;
                v_report.curr6 := x.short_name;
            END LOOP;
        END;
        PIPE ROW (v_report);
      END LOOP;
    END;
    
    FUNCTION get_m29_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_m29_tab PIPELINED 
    AS  
        v_report                giclr029_m29_type;
        v_claim_id              GICL_CLAIMS.claim_id%TYPE;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_subline_cd            GICL_CLAIMS.subline_cd%TYPE;
        v_pol_iss_cd            GICL_CLAIMS.pol_iss_cd%TYPE;
        v_issue_yy              GICL_CLAIMS.issue_yy%TYPE;
        v_pol_seq_no            GICL_CLAIMS.pol_seq_no%TYPE;
        v_renew_no              GICL_CLAIMS.renew_no%TYPE;
        v_loss_date             GICL_CLAIMS.loss_date%TYPE;
        v_mortgagee             VARCHAR2(1000) := '';
        v_count                 NUMBER(1) := 0;
    BEGIN
        FOR i IN (SELECT claim_id,  line_cd, subline_cd, pol_iss_cd,  
                         issue_yy, pol_seq_no, renew_no, loss_date
                    FROM gicl_claims
                   WHERE claim_id = p_claim_id)
       LOOP
            v_claim_id           := i.claim_id;
            v_line_cd            := i.line_cd;
            v_subline_cd         := i.subline_cd;
            v_pol_iss_cd         := i.pol_iss_cd;
            v_issue_yy           := i.issue_yy;
            v_pol_seq_no         := i.pol_seq_no;
            v_renew_no           := i.renew_no;
            v_loss_date          := i.loss_date;
       END LOOP;
        
        --CF_deductible
        BEGIN
          FOR i IN (
            SELECT item_no, peril_cd
              FROM gicl_item_peril
             WHERE claim_id = v_claim_id)
          LOOP
                FOR d IN (
                  SELECT SUM(b.deductible_amt) ded_amt 
                    FROM giis_loss_exp a, gipi_deductibles b, gipi_polbasic c 
                   WHERE a.line_cd = c.line_cd
                     AND a.line_cd = b.ded_line_cd
                     AND a.subline_cd = b.ded_subline_cd 
                     AND a.loss_exp_cd = b.ded_deductible_cd
                     AND a.loss_exp_type = 'L'
                     AND a.line_cd = v_line_cd
                     AND a.subline_cd = v_subline_cd
                     AND b.policy_id = c.policy_id
                     AND c.line_cd = v_line_cd 
                     AND c.subline_cd = v_subline_cd
                     AND c.iss_cd = v_pol_iss_cd 
                     AND c.issue_yy = v_issue_yy 
                     AND c.pol_seq_no = v_pol_seq_no 
                     AND c.renew_no = v_renew_no
                     AND c.expiry_date >= v_loss_date
                     AND c.eff_date <= v_loss_date --edison 12.15.2011 to accept only deductibles
                                    --if the loss date is in the eff_date of policy
                     AND c.dist_flag = '3'
                     AND c.pol_flag IN ('1','2','3','X') 
                     AND b.item_no = i.item_no 
                     AND b.peril_cd IN (i.peril_cd,0))
                     --AND NVL(b.deductible_amt,0) > 0) --edison 12.15.2011
                                               --to accept negative deductibles
            LOOP 
              v_report.deductible := d.ded_amt;
            END LOOP;
          END LOOP;
        END;
        
        --CF_curr13
        begin
         FOR x IN (SELECT DISTINCT a.short_name
                     FROM giis_currency a, gicl_clm_item b
                    WHERE a.main_currency_cd = b.currency_cd
                      AND b.claim_id = v_claim_id)
         LOOP
            v_report.curr18 := x.short_name;
            IF v_report.deductible IS NULL THEN
                  v_report.curr21 := ' ';
            ELSE
                  v_report.curr21 := x.short_name;
            END IF;
         END LOOP;
        end;
        
        --CF_mortgagee
        BEGIN
        /* instead of referencing the view, gicl_mortgagee_v1,
        ** the query in view is used; query is modified in this
        ** program unit by adding 2 add'l links for optimization.
        ** Pia, 04.06.04 */
          /* FOR m IN
            (SELECT DISTINCT mortg_name
               FROM gicl_mortgagee_v1
              WHERE claim_id = :claim_id)
          LOOP
            v_mortgagee := m.mortg_name;
          END LOOP; */
          
          FOR m IN
            (SELECT distinct(d.mortg_name)mortg_name
               FROM gipi_mortgagee a, gipi_polbasic b,
                    gicl_claims c, giis_mortgagee d
              WHERE a.policy_id  = b.policy_id
                AND b.renew_no   = c.renew_no
                AND b.pol_seq_no = c.pol_seq_no
                AND b.issue_yy   = c.issue_yy
                --AND b.iss_cd     = c.iss_cd
                AND b.iss_cd     = c.pol_iss_cd --modified by jess 08.25.2010
                AND b.subline_cd = c.subline_cd
                AND b.line_cd    = c.line_cd
                AND b.eff_date   <= c.loss_date
                AND a.mortg_cd   = d.mortg_cd
                --AND d.iss_cd     = c.iss_cd -- add'l link, use index of giis_mortgagee
                AND d.iss_cd     = c.pol_iss_cd --modified by jess 08.25.2010
                AND c.claim_id   = v_claim_id)-- add'l link
          LOOP
            v_report.mortgagee := m.mortg_name; -- remove line from being commented ou. For function to return m.mortg_name rai 08/02/2016
            IF v_count = 0 THEN --if there is only one mortgagee
                v_mortgagee := m.mortg_name;
                v_count := 1;
            ELSE --if there is more than 1 mortgagee
                v_mortgagee := v_mortgagee ||CHR(10)|| m.mortg_name;
            END IF; 
            
            EXIT;
          END LOOP;
        END;
        
        --CF_intm
        BEGIN
          FOR i IN (
            SELECT DISTINCT intm_name
              FROM gicl_basic_intm_v1
             WHERE claim_id = v_claim_id)
          LOOP
            v_report.intm := i.intm_name;
          END LOOP;
        END;
        
        --CF_no_of_claims
        BEGIN
          BEGIN
            SELECT COUNT(claim_id)
              INTO v_report.no_of_claims
              FROM gicl_claims
             WHERE renew_no       = v_renew_no
               AND pol_seq_no     = v_pol_seq_no
               AND issue_yy       = v_issue_yy
               AND pol_iss_cd     = v_pol_iss_cd
               AND subline_cd     = v_subline_cd
               AND line_cd        = v_line_cd
               AND claim_id       <> v_claim_id;  
          EXCEPTION
            WHEN OTHERS THEN
              v_report.no_of_claims  := NULL;
          END;
        END;
        
        --CF_tot_pd_amt
        BEGIN
          BEGIN
            SELECT NVL(SUM(loss_pd_amt),0) + NVL(SUM(exp_pd_amt),0)
              INTO v_report.tot_pd_amt
              FROM gicl_claims
             WHERE renew_no       = v_renew_no
               AND pol_seq_no     = v_pol_seq_no
               AND issue_yy       = v_issue_yy
               AND pol_iss_cd     = v_pol_iss_cd
               AND subline_cd     = v_subline_cd
               AND line_cd        = v_line_cd
               AND claim_id       <> v_claim_id;
          EXCEPTION
            WHEN OTHERS THEN
              v_report.tot_pd_amt  := 0;
          END;
        END;
        
        --CF_tot_res_amt
        BEGIN
          BEGIN
            SELECT NVL(SUM(loss_res_amt),0) + NVL(SUM(exp_res_amt),0)
              INTO v_report.tot_res_amt
              FROM gicl_claims
             WHERE renew_no       = v_renew_no
               AND pol_seq_no     = v_pol_seq_no
               AND issue_yy       = v_issue_yy
               AND pol_iss_cd     = v_pol_iss_cd
               AND subline_cd     = v_subline_cd
               AND line_cd        = v_line_cd
               AND clm_stat_cd    IN ('CC','DN','WD')
               AND claim_id       <> v_claim_id;
          EXCEPTION
            WHEN OTHERS THEN
              v_report.tot_res_amt  := 0;
          END;
        END;
        
        --CF_tot_os
        BEGIN
          IF v_report.tot_pd_amt - v_report.tot_res_amt < 0 THEN
             v_report.tot_os := 0;
          ELSE
             v_report.tot_os :=  (v_report.tot_pd_amt - v_report.tot_res_amt);
          END IF;  
        END;
        
        --M_34
        DECLARE
          v_exist     varchar2(1);
        BEGIN
          BEGIN
            SELECT DISTINCT 'X'
              INTO v_exist
              FROM gipi_polbasic
             WHERE line_cd = v_line_cd
               AND subline_cd = v_subline_cd
               AND iss_cd = v_pol_iss_cd
               AND issue_yy = v_issue_yy  
               AND pol_seq_no = v_pol_seq_no       
               AND renew_no = v_renew_no
               AND endt_seq_no <> 0;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_exist := null;
          END;
          IF v_exist IS NOT NULL THEN
             v_report.endt_exist := 'TRUE';
          ELSE
             v_report.endt_exist := 'FALSE';
          END IF;
        END;
          
        PIPE ROW (v_report);
    END;
    
    FUNCTION get_prem_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_prem_tab PIPELINED 
    AS  
        v_report                giclr029_prem_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_subline_cd            GICL_CLAIMS.subline_cd%TYPE;
        v_pol_iss_cd            GICL_CLAIMS.pol_iss_cd%TYPE;
        v_issue_yy              GICL_CLAIMS.issue_yy%TYPE;
        v_pol_seq_no            GICL_CLAIMS.pol_seq_no%TYPE;
        v_renew_no              GICL_CLAIMS.renew_no%TYPE;
        v_loss_date             GICL_CLAIMS.loss_date%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, pol_iss_cd,  issue_yy, renew_no, pol_seq_no, loss_date
          INTO v_line_cd, v_subline_cd, v_pol_iss_cd,  v_issue_yy, v_renew_no, v_pol_seq_no, v_loss_date
          FROM gicl_claims
         WHERE claim_id = p_claim_id;
       
        FOR i IN (SELECT a.line_cd, 
                           a.subline_cd, 
                           a.iss_cd, 
                           a.issue_yy, 
                           a.pol_seq_no, 
                           a.renew_no, 
                           c.gacc_tran_id, 
                           /*c.premium_amt,  comment out by reymon 11152010*/
                           DECODE(c.currency_cd, 1, c.premium_amt, c.premium_amt/c.convert_rate) premium_amt,  --added by reymon 11152010 --Modified by Jerome Bautista 08.20.2015 SR 18120
                           d.tran_class, 
                           d.tran_class_no, 
                           d.tran_date, 
                           e.short_name 
                      FROM gipi_polbasic a, 
                           gipi_invoice b, 
                           giac_direct_prem_collns c, 
                           giac_acctrans d, 
                           giis_currency e
                           --giac_order_of_payts f  --added by reymon 11152010 --Commented out by Jerome Bautista 08.20.2015 SR 18120
                     WHERE a.policy_id = b.policy_id 
                       AND a.line_cd = v_line_cd        -- added by danny 4/16/2010    
                       AND a.subline_cd = v_subline_cd  -- added by danny 4/16/2010
                       AND a.iss_cd = v_pol_iss_cd      -- added by danny 4/16/2010
                       AND a.issue_yy = v_issue_yy      -- added by danny 4/16/2010
                       AND a.renew_no = v_renew_no      -- added by danny 4/16/2010
                       AND a.pol_seq_no = v_pol_seq_no  -- added by danny 4/16/2010 
                       AND b.iss_cd = c.b140_iss_cd 
                       AND b.prem_seq_no = c.b140_prem_seq_no 
                       AND c.gacc_tran_id = d.tran_id 
                       AND d.tran_id NOT IN (SELECT e.gacc_tran_id 
                                               FROM giac_reversals e, 
                                                    giac_acctrans f 
                                              WHERE e.reversing_tran_id = f.tran_id 
                                                AND f.tran_flag <> 'D') 
                       AND d.tran_flag <> 'D' 
                       AND a.eff_date <= v_loss_date 
                       AND a.pol_flag NOT IN ('4', '5') 
                       AND c.currency_cd = e.main_currency_cd -- Added by Jerome Bautista 08.20.2015 SR 18120
                       /*AND b.currency_cd = e.main_currency_cd  comment out by reymon 11172010*/
                       --AND f.currency_cd = e.main_currency_cd  --added by reymon 11172010 --Commented out by Jerome Bautista 08.20.2015 SR 18120
                       --AND c.gacc_tran_id = f.gacc_tran_id  --added by reymon 11152010 --Commented out by Jerome Bautista 08.20.2015 SR 18120
                    UNION   --added by reymon 11042010
                    SELECT a.line_cd, 
                           a.subline_cd, 
                           a.iss_cd, 
                           a.issue_yy, 
                           a.pol_seq_no, 
                           a.renew_no, 
                           c.gacc_tran_id, 
                           /*c.premium_amt,  comment out by reymon 11152010*/
                           DECODE(c.currency_cd, 1, c.premium_amt, c.premium_amt/c.convert_rate) premium_amt,  --added by reymon 11152010 --Modified by Jerome Bautista 08.20.2015 SR 18120
                           d.tran_class, 
                           d.tran_class_no, 
                           d.tran_date, 
                           e.short_name 
                      FROM gipi_polbasic a, 
                           gipi_invoice b, 
                           giac_inwfacul_prem_collns c, 
                           giac_acctrans d, 
                           giis_currency e
                           --giac_order_of_payts f  --added by reymon 11152010 --Commented out by Jerome Bautista 08.20.2015 SR 18120
                     WHERE a.policy_id = b.policy_id 
                       AND a.line_cd = v_line_cd 
                       AND a.subline_cd = v_subline_cd
                       AND a.iss_cd = v_pol_iss_cd
                       AND a.issue_yy = v_issue_yy
                       AND a.renew_no = v_renew_no
                       AND a.pol_seq_no = v_pol_seq_no
                       AND b.iss_cd = c.b140_iss_cd 
                       AND b.prem_seq_no = c.b140_prem_seq_no 
                       AND c.gacc_tran_id = d.tran_id 
                       AND d.tran_id NOT IN (SELECT e.gacc_tran_id 
                                               FROM giac_reversals e, 
                                                    giac_acctrans f 
                                              WHERE e.reversing_tran_id = f.tran_id 
                                                AND f.tran_flag <> 'D') 
                       AND d.tran_flag <> 'D' 
                       AND a.eff_date <= v_loss_date 
                       AND a.pol_flag NOT IN ('4', '5') 
                       AND c.currency_cd = e.main_currency_cd) -- Added by Jerome Bautista 08.20.2015 SR 18120
                       /*AND b.currency_cd = e.main_currency_cd  comment out by reymon 11172010*/
                       --AND f.currency_cd = e.main_currency_cd  --added by reymon 11172010 --Commented out by Jerome Bautista 08.20.2015 SR 18120
                       --AND c.gacc_tran_id = f.gacc_tran_id) --Commented out by Jerome Bautista 08.20.2015 SR 18120
       LOOP
            v_report.curr3             := i.short_name;
            v_report.premium_amt       := i.premium_amt;
            
            --CF_ref_no
            BEGIN
              IF i.tran_class = 'COL' THEN
                FOR c IN (
                  SELECT or_pref_suf||'-'||TO_CHAR(or_no) or_no 
                FROM giac_order_of_payts
                   WHERE gacc_tran_id = i.gacc_tran_id)
                LOOP
                     v_report.ref_no := c.or_no;
                END LOOP; 
              ELSIF i.tran_class = 'DV' THEN
                FOR r IN (
                  SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)
                         ||'-'||TO_CHAR(doc_seq_no) request_no
                    FROM giac_payt_requests a, giac_payt_requests_dtl b
                   WHERE a.ref_id = b.gprq_ref_id
                     AND b.tran_id = i.gacc_tran_id)
                LOOP
                  v_report.ref_no := r.request_no;
                  FOR d IN (   
                    SELECT dv_pref||'-'||TO_CHAR(dv_no) dv_no
                      FROM giac_disb_vouchers
                     WHERE gacc_tran_id = i.gacc_tran_id)
                  LOOP
                    v_report.ref_no := d.dv_no;
                  END LOOP;
                END LOOP; 
              ELSIF i.tran_class = 'JV' THEN
                v_report.ref_no := i.tran_class||'-'||i.tran_class_no; --i.tran_class Added by Jerome Bautista 08.20.2015 SR 18120
              END IF;
            END; 
            
            --CF_tran_date
            BEGIN
              IF i.tran_class = 'COL' THEN
                FOR c IN (
                  SELECT or_date
                FROM giac_order_of_payts
                   WHERE gacc_tran_id = i.gacc_tran_id)
                LOOP
                     v_report.tran_date := c.or_date;
                     v_report.curr4     := i.short_name;
                END LOOP; 
              ELSIF i.tran_class = 'DV' THEN
                FOR r IN (
                  SELECT request_date
                    FROM giac_payt_requests a, giac_payt_requests_dtl b
                   WHERE a.ref_id = b.gprq_ref_id
                     AND b.tran_id = i.gacc_tran_id)
                LOOP
                  v_report.tran_date := r.request_date;
                  v_report.curr4     := i.short_name;
                  FOR d IN (   
                    SELECT dv_date
                      FROM giac_disb_vouchers
                     WHERE gacc_tran_id = i.gacc_tran_id)
                  LOOP
                    v_report.tran_date := d.dv_date;
                    v_report.curr4     := i.short_name;
                  END LOOP;
                END LOOP; 
              ELSIF i.tran_class = 'JV' THEN
                v_report.tran_date := i.tran_date;
                v_report.curr4     := i.short_name; 
              END IF;
            END; 
          
            PIPE ROW (v_report);
       END LOOP;
    END;
    
    FUNCTION get_share_type
    RETURN giclr029_shr_tab PIPELINED 
    AS  
        v_report                giclr029_shr_type;
    BEGIN
        FOR i IN (SELECT DISTINCT share_type, 
                         DECODE(share_type, '1', 'RETENTION', '2','TREATY', '3', 'FACULTATIVE','4','XOL') share_name
                    FROM giis_dist_share)
       LOOP
          v_report.share_type     := i.share_type;
          v_report.share_name     := i.share_name;
          PIPE ROW (v_report);
       END LOOP;
    END;
    
    FUNCTION get_poldist_dtls(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_share_type    giis_dist_share.share_type%TYPE
    )
    RETURN giclr029_poldist_tab PIPELINED 
    AS  
        v_report                giclr029_poldist_type;
    BEGIN
       
        FOR i IN (SELECT a.claim_id, a.item_no, a.peril_cd, c.share_type, c.line_cd, b.currency_cd, SUM(shr_tsi_amt) shr_tsi_amt
                         , d.short_name
                    FROM gicl_item_peril a, gicl_clm_res_hist b, gicl_policy_dist c, giis_currency d
                   WHERE a.claim_id = p_claim_id --added by danny 4/16/2010
                     AND c.share_type = p_share_type
                     AND a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND b.claim_id = c.claim_id
                     AND b.item_no = c.item_no
                     AND b.peril_cd = c.peril_cd
                     AND b.dist_sw = 'Y'
                     AND d.main_currency_cd (+) = b.currency_cd
                   GROUP BY a.claim_id, a.item_no, a.peril_cd, c.share_type, c.line_cd, b.currency_cd, d.short_name)
       LOOP
            v_report.curr22           := i.short_name;
            v_report.shr_tsi_amt       := i.shr_tsi_amt;
            PIPE ROW (v_report);
       END LOOP;
    END;
    
    FUNCTION get_rdist_dtls(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_share_type    giis_dist_share.share_type%TYPE
    )
    RETURN giclr029_rdist_tab PIPELINED 
    AS  
        v_report                giclr029_rdist_type;
    BEGIN
       
        FOR i IN (SELECT a.claim_id, a.item_no, a.peril_cd, c.clm_res_hist_id, c.share_type, c.line_cd, b.currency_cd, SUM(NVL(shr_loss_res_amt,0) + NVL(shr_exp_res_amt,0)) shr_res_amt
                           , d.short_name
                      FROM gicl_item_peril a, gicl_clm_res_hist b, gicl_reserve_ds c, giis_currency d
                     WHERE a.claim_id = p_claim_id --added by danny 04/16/2010
                       AND c.share_type = p_share_type
                       AND a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND b.claim_id = c.claim_id
                       AND b.item_no = c.item_no
                       AND b.peril_cd = c.peril_cd
                       AND b.dist_sw = 'Y'
                       AND NVL(c.negate_tag,'N') = 'N' 
                       AND d.main_currency_cd (+) = b.currency_cd
                     GROUP BY a.claim_id, a.item_no, a.peril_cd, c.clm_res_hist_id, c.share_type, c.line_cd, b.currency_cd, d.short_name)
       LOOP
            v_report.curr10           := i.short_name;
            v_report.shr_res_amt      := i.shr_res_amt;
            PIPE ROW (v_report);
       END LOOP;
    END;
    
    FUNCTION get_binder_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_binder_tab PIPELINED 
    AS  
        v_report                giclr029_binder_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_subline_cd            GICL_CLAIMS.subline_cd%TYPE;
        v_pol_iss_cd            GICL_CLAIMS.pol_iss_cd%TYPE;
        v_issue_yy              GICL_CLAIMS.issue_yy%TYPE;
        v_pol_seq_no            GICL_CLAIMS.pol_seq_no%TYPE;
        v_renew_no              GICL_CLAIMS.renew_no%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, pol_iss_cd,  issue_yy, renew_no, pol_seq_no
          INTO v_line_cd, v_subline_cd, v_pol_iss_cd,  v_issue_yy, v_renew_no, v_pol_seq_no
          FROM gicl_claims
         WHERE claim_id = p_claim_id;
         
        FOR i IN (SELECT a.ri_cd, 
                       a.ri_shr_pct, 
                       a.ri_tsi_amt, 
                       a.line_cd || '-' || LTRIM(TO_CHAR(a.binder_yy, '09')) || '-' || LTRIM(TO_CHAR(a.binder_seq_no, '099999')) binder_no, 
                       e.line_cd, 
                       e.subline_cd, 
                       e.iss_cd, 
                       e.issue_yy, 
                       e.pol_seq_no, 
                       e.renew_no, 
                       f.short_name 
                  FROM giri_binder a, 
                       giri_frps_ri b, 
                       giri_distfrps c, 
                       giuw_pol_dist d, 
                       gipi_polbasic e, 
                       giis_currency f 
                 WHERE b.line_cd = c.line_cd
                   AND e.line_cd    = v_line_cd     -- added by danny 4/16/2010    
                   AND e.subline_cd = v_subline_cd  -- added by danny 4/16/2010
                   AND e.iss_cd     = v_pol_iss_cd  -- added by danny 4/16/2010
                   AND e.issue_yy   = v_issue_yy    -- added by danny 4/16/2010
                   AND e.renew_no   = v_renew_no    -- added by danny 4/16/2010
                   AND e.pol_seq_no = v_pol_seq_no  -- added by danny 4/16/2010 
                   AND a.fnl_binder_id = b.fnl_binder_id (+) 
                   AND b.frps_yy = c.frps_yy 
                   AND b.frps_seq_no = c.frps_seq_no 
                   AND c.dist_no = d.dist_no 
                   AND d.policy_id = e.policy_id 
                   AND NVL(b.reverse_sw, 'N') = 'N' 
                   AND c.currency_cd = f.main_currency_cd 
                 ORDER BY a.ri_cd)
       LOOP
            v_report.binder_no     := i.binder_no;
            v_report.ri_shr_pct    := i.ri_shr_pct;
            v_report.curr1         := i.short_name;
            v_report.ri_tsi_amt    := i.ri_tsi_amt;
            
            --CF_reinsurer
            BEGIN
              FOR r IN (
                SELECT ri_name
                  FROM giis_reinsurer
                 WHERE ri_cd = i.ri_cd)
              LOOP
                v_report.reinsurer := r.ri_name;
              END LOOP;
            END; 
            PIPE ROW (v_report);
       END LOOP;
    END;
    
    FUNCTION get_rdistri_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_rdistri_tab PIPELINED 
    AS  
        v_report                giclr029_rdistri_type;
    BEGIN
        FOR i IN (SELECT d.claim_id,  e.short_name, d.line_cd||'-'||LTRIM(TO_CHAR(d.la_yy,'09'))||'-'||LTRIM(TO_CHAR(d.pla_seq_no,'0999999')) pla_number, d.ri_cd, (SUM(NVL(c.shr_loss_ri_res_amt,0)) + SUM(NVL(c.shr_exp_ri_res_amt,0))) pla_amt
                                FROM gicl_clm_res_hist a,
                                     gicl_reserve_ds b,
                                     gicl_reserve_rids c,
                                     gicl_advs_pla d,
                                     giis_currency e
                               WHERE d.claim_id = p_claim_id --added by danny 04/16/2010
                                 AND a.dist_sw = 'Y'
                                 AND a.claim_id = b.claim_id
                                 AND a.clm_res_hist_id = b.clm_res_hist_id
                                 AND nvl(b.negate_tag,'N') <> 'Y'
                                 AND b.claim_id = c.claim_id
                                 AND b.clm_res_hist_id = c.clm_res_hist_id
                                 AND b.grp_seq_no = c.grp_seq_no
                                 AND c.pla_id = d.pla_id
                                 AND c.grp_seq_no = d.grp_seq_no
                                 AND c.claim_id = d.claim_id
                                 AND a.currency_cd = e.main_currency_cd
                               GROUP BY d.claim_id, d.line_cd, d.la_yy, d.pla_seq_no, d.ri_cd, e.short_name
                               ORDER BY d.line_cd,d.la_yy,d.pla_seq_no)
       LOOP
            v_report.curr2   := i.short_name;
            v_report.pla_amt := i.pla_amt;
            v_report.pla_no  := i.pla_number;
            
            --CF_ri_name
            BEGIN
              FOR r IN (
                SELECT a.ri_name, b.shr_ri_pct
                  FROM giis_reinsurer a, gicl_reserve_rids b
                 WHERE a.ri_cd    = i.ri_cd
				   AND a.ri_cd    = b.ri_cd
				   AND b.claim_id = p_claim_id)
              LOOP
                v_report.ri_name    := r.ri_name;
				v_report.shr_ri_pct := r.shr_ri_pct;
              END LOOP;
            END; 
            PIPE ROW (v_report);
       END LOOP;
    END;
    
    FUNCTION get_reqd_dtls(p_claim_id      gicl_claims.claim_id%TYPE)
    RETURN giclr029_reqd_tab PIPELINED 
    AS  
        v_report                giclr029_reqd_type;
        v_line_cd               gicl_claims.line_cd%TYPE;
        v_subline_cd            gicl_claims.subline_cd%TYPE;
    BEGIN
        SELECT line_cd, subline_cd
          INTO v_line_cd, v_subline_cd
          FROM gicl_claims
         WHERE claim_id = p_claim_id;
         
        FOR i IN (SELECT line_cd, subline_cd, clm_doc_cd, clm_doc_desc
                     FROM gicl_clm_docs
                    WHERE priority_cd IS NOT NULL
                    UNION
                   SELECT a.line_cd, a.subline_cd, b.clm_doc_cd, b.clm_doc_desc
                     FROM gicl_reqd_docs a, gicl_clm_docs b
                    WHERE a.doc_cmpltd_dt IS NOT NULL
                      AND a.line_cd = b.line_cd
                      AND a.subline_cd = b.subline_cd 
                      AND TO_CHAR(a.clm_doc_cd) = TO_CHAR(b.clm_doc_cd) --marco - 07.31.2014 - added to_char to match datatype of columns
                      AND a.claim_id = p_claim_id)
       LOOP
            v_report.req_doc          := i.clm_doc_desc;
            v_report.line_cd          := v_line_cd;
            
            --CF_dt_cmpltd
            v_report.dt_cmpltd := NULL; --marco - 07.31.2014 - reset value upon iteration
            BEGIN
              FOR d IN (
                SELECT doc_cmpltd_dt
                  FROM gicl_reqd_docs
                 WHERE line_cd = v_line_cd
                   AND subline_cd = v_subline_cd
                   AND TO_CHAR(clm_doc_cd) = i.clm_doc_cd
                   AND claim_id = p_claim_id)
              LOOP
                v_report.dt_cmpltd        := d.doc_cmpltd_dt;
              END LOOP;
            END;
            
            if v_report.dt_cmpltd is not null then
                PIPE ROW (v_report);
            end if;
            
       END LOOP;
    END;
    
    FUNCTION get_sig_dtls(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_line_cd           giac_documents.line_cd%TYPE,
        p_report_id         giac_documents.report_id%TYPE
    )
    RETURN giclr029_sig_tab PIPELINED 
    AS  
        v_report                giclr029_sig_type;
        v_line_cd               gicl_claims.line_cd%TYPE;
        v_subline_cd            gicl_claims.subline_cd%TYPE;
    BEGIN
        SELECT line_cd, subline_cd
          INTO v_line_cd, v_subline_cd
          FROM gicl_claims
         WHERE claim_id = p_claim_id;
         
        FOR i IN (SELECT a.line_cd, a.report_no, 
                         b.item_no, b.label, b.signatory_id,
                         c.signatory, c.designation
                    FROM giac_documents a, giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = b.report_id
                     AND b.signatory_id  = c.signatory_id
                     AND b.report_no >= 0 
                     AND a.report_id = p_report_id
                     AND NVL(a.line_cd, p_line_cd) = p_line_cd
                   MINUS
                  SELECT a.line_cd, a.report_no,
                         b.item_no, b.label, b.signatory_id,
                         c.signatory, c.designation
                    FROM giac_documents a, giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = b.report_id
                     AND b.signatory_id = c.signatory_id
                     AND a.report_no >= 0
                     AND a.report_id = p_report_id   
                     AND a.line_cd IS NULL
                     AND EXISTS (SELECT 1
                                   FROM giac_documents
                                  WHERE report_id = p_report_id
                                    AND report_no >= 0
                                    AND line_cd = p_line_cd) 
                ORDER BY 3)
       LOOP
            v_report.label             := i.label;
            v_report.signatory         := i.signatory;
            v_report.designation       := i.designation;
            
            PIPE ROW (v_report);
       END LOOP;
    END;
END; 
/

