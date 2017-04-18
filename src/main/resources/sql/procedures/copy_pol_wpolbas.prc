CREATE OR REPLACE PROCEDURE CPI.Copy_Pol_Wpolbas(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
				  p_line_cd				IN  GIPI_WPOLBAS.line_cd%TYPE,
				  p_iss_cd				IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_par_type		    IN  GIPI_PARLIST.par_type%TYPE,
				  p_user_id				IN  VARCHAR2,
				  p_policy_id			OUT GIPI_POLBASIC.policy_id%TYPE,
                  p_pack_policy_id      IN VARCHAR2,
				  p_change_stat			IN OUT VARCHAR2,
	   	  		  p_msg_alert			OUT VARCHAR2	
	   	  		  )
	    IS
  v_incept_dt 		    GIPI_POLBASIC.incept_date%TYPE;
  v_expiry_dt		    GIPI_POLBASIC.expiry_date%TYPE;
  v_expiry_tag          GIPI_POLBASIC.expiry_tag%TYPE;
  v_incept_tag          GIPI_POLBASIC.incept_tag%TYPE;
  v_eff_dt		        GIPI_POLBASIC.eff_date%TYPE;
  v_issue_dt		    GIPI_POLBASIC.issue_date%TYPE;
  v_pol_flag		    GIPI_POLBASIC.pol_flag%TYPE;
  v_assd_no		        GIPI_POLBASIC.assd_no%TYPE;
  v_designation		    GIPI_POLBASIC.designation%TYPE;
  v_pol_addr1		    GIPI_POLBASIC.address1%TYPE;
  v_pol_addr2		    GIPI_POLBASIC.address2%TYPE;
  v_pol_addr3		    GIPI_POLBASIC.address3%TYPE;
  v_mortg_name		    GIPI_POLBASIC.mortg_name%TYPE;
  v_tsi_amt		        GIPI_POLBASIC.tsi_amt%TYPE;
  v_prem_amt		    GIPI_POLBASIC.prem_amt%TYPE;
  v_ann_tsi		        GIPI_POLBASIC.ann_tsi_amt%TYPE;
  v_ann_prem		    GIPI_POLBASIC.ann_prem_amt%TYPE;
  v_invoices		    GIPI_POLBASIC.invoice_sw%TYPE;    
  v_user_id		        GIPI_POLBASIC.user_id%TYPE;
  v_pool_pol_no		    GIPI_POLBASIC.pool_pol_no%TYPE;
  v_foreign_acc_tag 	GIPI_POLBASIC.foreign_acc_sw%TYPE;
  v_policy_id		    GIPI_POLBASIC.policy_id%TYPE;      
  v_issue_yy		    GIPI_POLBASIC.issue_yy%TYPE;
  v_renew_no		    GIPI_POLBASIC.renew_no%TYPE;
  v_subline_cd		    GIPI_POLBASIC.subline_cd%TYPE;
  v_auto_renew_flag	    GIPI_POLBASIC.auto_renew_flag%TYPE;
  v_no_of_items		    GIPI_POLBASIC.no_of_items%TYPE;
  v_endt_yy		        GIPI_POLBASIC.endt_yy%TYPE := 0;
  v_pol_seq_no	      	GIPI_POLBASIC.pol_seq_no%TYPE;
  v_endt_expiry_date	GIPI_POLBASIC.endt_expiry_date%TYPE;
  v_subline_type_cd	    GIPI_POLBASIC.subline_type_cd%TYPE;
  v_prorate_flag	    GIPI_POLBASIC.prorate_flag%TYPE;
  v_short_rt_percent	GIPI_POLBASIC.short_rt_percent%TYPE;
  v_prov_prem_tag       GIPI_POLBASIC.prov_prem_tag%TYPE;
  v_type_cd             GIPI_POLBASIC.type_cd%TYPE;
  v_acct_of_cd          GIPI_POLBASIC.acct_of_cd%TYPE;
  v_pack_pol_flag       GIPI_POLBASIC.pack_pol_flag%TYPE;
  v_prem_warr_tag       GIPI_POLBASIC.prem_warr_tag%TYPE;  --BETH
  v_ref_pol_no          GIPI_POLBASIC.ref_pol_no%TYPE;     --010799
  v_reg_policy_sw       GIPI_POLBASIC.reg_policy_sw%TYPE;   --LOTH
  v_co_insurance_sw  	GIPI_POLBASIC.co_insurance_sw%TYPE; --012799
  v_discount_sw         GIPI_POLBASIC.discount_sw%TYPE;     --020499
  v_surcharge_sw        GIPI_POLBASIC.surcharge_sw%TYPE;     --RBD (08162002)
  v_ref_open_pol_no     GIPI_POLBASIC.ref_open_pol_no%TYPE; --020499
  v_booking_mth         GIPI_POLBASIC.booking_mth%TYPE;     --022799
  v_booking_year        GIPI_POLBASIC.booking_mth%TYPE;     --040899
  v_fleet_print_tag     GIPI_POLBASIC.fleet_print_tag%TYPE; --042099

  v_endt_expiry_tag     GIPI_POLBASIC.endt_expiry_tag%TYPE;  --BETH
  v_manual_renew_no     GIPI_POLBASIC.manual_renew_no%TYPE;  --BETH
  v_with_tariff_sw      GIPI_POLBASIC.with_tariff_sw%TYPE;   --BETH 120199
  
  --BETH 	01-27-2000  
  v_comp_sw             GIPI_POLBASIC.comp_sw%TYPE;
  v_orig_policy_id      GIPI_POLBASIC.orig_policy_id%TYPE;
  v_prov_prem_pct       GIPI_POLBASIC.prov_prem_pct%TYPE;

  -- jpc 08/02/2001
  v_region_cd       	GIPI_POLBASIC.region_cd%TYPE;
  v_industry_cd       	GIPI_POLBASIC.industry_cd%TYPE;

  --BETH 06-21-2000
  v_place_cd            GIPI_POLBASIC.place_cd%TYPE;
  --BETH 04-16-2001
  v_actual_renew_no     GIPI_POLBASIC.actual_renew_no%TYPE;
  v_count_id            GIPI_POLBASIC.policy_id%TYPE; --store policy_id of renewed policy
  v_exit_sw             VARCHAR2(1); --switch that will be use in counting actual_renew_n
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  --added by iris 07.11.2002
  --for the added column acct_of_cd_sw
  v_acct_of_cd_sw       GIPI_POLBASIC.acct_of_cd_sw%TYPE;
  
  --added by grace 01.06.2003
  --for the added column cred_branch
  v_cred_branch         GIPI_POLBASIC.cred_branch%TYPE;
  v_old_assd_no         GIPI_POLBASIC.old_assd_no%TYPE;
  v_old_address1        GIPI_POLBASIC.old_address1%TYPE;
  v_old_address2        GIPI_POLBASIC.old_address2%TYPE;  
  v_old_address3        GIPI_POLBASIC.old_address3%TYPE;        
  v_cancel_date			GIPI_POLBASIC.cancel_date%TYPE;
  v_label_tag           GIPI_POLBASIC.label_tag%TYPE;
  v_survey_agent_cd     GIPI_POLBASIC.survey_agent_cd%TYPE;
  v_settling_agent_cd   GIPI_POLBASIC.settling_agent_cd%TYPE;
  
  --added by iris bordey 09.30.2003
  --for added column risk_tag
  v_risk_tag            GIPI_POLBASIC.risk_tag%TYPE;
  
  --added by VJ 03.02.2007
  --add column prem_warr_days
  v_prem_warr_days      GIPI_POLBASIC.prem_warr_days%TYPE;
  --v--
  
  -- longterm --  
  v_takeup_term         GIPI_POLBASIC.takeup_term%TYPE;
  v_cancelled_endt_id   GIPI_POLBASIC.cancelled_endt_id%TYPE;
  
  -- aaron 050409 SOA enh
  v_cancel_type         GIPI_POLBASIC.cancel_type%TYPE;
  v_affecting           VARCHAR2(1);
  
  v_bank_ref_no         gipi_polbasic.bank_ref_no%TYPE;
  v_plan_sw             gipi_pack_polbasic.plan_sw%TYPE;
  v_plan_cd             gipi_pack_polbasic.plan_cd%TYPE;                
  v_plan_ch_tag         gipi_pack_polbasic.plan_ch_tag%TYPE;
  v_bond_seq_no         gipi_wpolbas.bond_seq_no%TYPE;
  
  -- bonok :: 06.03.2013 :: added insert for bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days and cn_date_printed
  v_cn_no_of_days		gipi_polbasic.cn_no_of_days%TYPE;
  v_cn_date_printed 	gipi_polbasic.cn_date_printed%TYPE;
  v_bancassurance_sw	gipi_polbasic.bancassurance_sw%TYPE;
  v_area_cd				gipi_polbasic.area_cd%TYPE;
  v_branch_cd			gipi_polbasic.branch_cd%TYPE;
  v_manager_cd			gipi_polbasic.manager_cd%TYPE;
  v_banc_type_cd		gipi_polbasic.banc_type_cd%TYPE;
  v_bond_auto_prem      gipi_polbasic.bond_auto_prem%TYPE; --added by robert GENQA 4828 08.27.15
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wpolbas program unit
  */
  /*
  **  Modified by   : Udel Dela Cruz Jr.
  **  Date Created : June 7, 2012
  **  Description  : added bond_seq_no
  */    
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Basic info..';
  ELSE
    :gauge.FILE := 'passing copy policy WPOLBAS';
  END IF;
  vbx_counter;  */
  BEGIN
    SELECT polbasic_policy_id_s.NEXTVAL
      INTO v_policy_id 
      FROM DUAL;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         p_msg_alert := 'Cannot generate new POLICY ID.';
         --:gauge.FILE := 'Cannot generate new POLICY ID.';
         --error_rtn;
  END;

  BEGIN
    SELECT COUNT(*)
      INTO v_no_of_items
      FROM GIPI_WITEM
     WHERE par_id = p_par_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
  END;
  
  SELECT issue_yy,incept_date,expiry_date,NVL(eff_date,incept_date),NVL(issue_date,TRUNC(SYSDATE)),pol_flag,
         assd_no,designation,address1,address2,address3,mortg_name,tsi_amt,prem_amt,ann_tsi_amt,
         ann_prem_amt,invoice_sw,user_id,pool_pol_no,foreign_acc_sw,renew_no,subline_cd,
         auto_renew_flag,pol_seq_no,
         endt_expiry_date,subline_type_cd,prorate_flag,short_rt_percent,
         prov_prem_tag,type_cd,acct_of_cd,pack_pol_flag, expiry_tag,
  --BETH 010799 add transfering of new fields prem_warr_tag and ref_pol_no
         prem_warr_tag, ref_pol_no, reg_policy_sw, co_insurance_sw,discount_sw,
         ref_open_pol_no, incept_tag, booking_mth, booking_year,fleet_print_tag,
         endt_expiry_tag, manual_renew_no, with_tariff_sw, --BETH
         comp_sw, orig_policy_id, prov_prem_pct, place_cd, region_cd, industry_cd,
         acct_of_cd_sw, surcharge_sw, cred_branch, old_assd_no, 
         old_address1, old_address2, old_address3, risk_tag, label_tag, 
         survey_agent_cd, settling_agent_cd,
         prem_warr_days, bank_ref_no, /*petermkaw 06212010*/ 
         plan_sw, plan_cd, plan_ch_tag,
         nvl(takeup_term,'ST') takeup_term, cancelled_endt_id, cancel_type, -- aaron 050409
         bond_seq_no, bond_auto_prem, --added by robert GENQA 4828 08.27.15
         -- bonok :: 06.03.2013 :: added insert for bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days and cn_date_printed
         bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days, cn_date_printed
    INTO v_issue_yy,v_incept_dt,v_expiry_dt,
         v_eff_dt,v_issue_dt,v_pol_flag,v_assd_no,
         v_designation,v_pol_addr1,v_pol_addr2,v_pol_addr3,    
         v_mortg_name,v_tsi_amt,v_prem_amt,
         v_ann_tsi,v_ann_prem,v_invoices,
         v_user_id,v_pool_pol_no,v_foreign_acc_tag,v_renew_no,v_subline_cd,
         v_auto_renew_flag,v_pol_seq_no,
         v_endt_expiry_date,v_subline_type_cd,v_prorate_flag,v_short_rt_percent,
         v_prov_prem_tag,v_type_cd,v_acct_of_cd,v_pack_pol_flag, v_expiry_tag,
         v_prem_warr_tag, v_ref_pol_no, v_reg_policy_sw, v_co_insurance_sw, 
         v_discount_sw, v_ref_open_pol_no, v_incept_tag, v_booking_mth,
         v_booking_year, v_fleet_print_tag, v_endt_expiry_tag, v_manual_renew_no,
         v_with_tariff_sw, v_comp_sw, v_orig_policy_id, v_prov_prem_pct, v_place_cd,
         v_region_cd, v_industry_cd, v_acct_of_cd_sw, v_surcharge_sw, v_cred_branch, 
         v_old_assd_no, v_old_address1, v_old_address2, v_old_address3, 
         v_risk_tag, v_label_tag, v_survey_agent_cd, v_settling_agent_cd,
         v_prem_warr_days, v_bank_ref_no, /*petermkaw 06212010*/ 
         v_plan_sw, v_plan_cd, v_plan_ch_tag,
         v_takeup_term,v_cancelled_endt_id, v_cancel_type, -- aaron 050409
         v_bond_seq_no, v_bond_auto_prem, --added by robert GENQA 4828 08.27.15
         -- bonok :: 06.03.2013 :: added insert for bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days and cn_date_printed
         v_bancassurance_sw, v_area_cd, v_branch_cd, v_manager_cd, v_banc_type_cd, v_cn_no_of_days, v_cn_date_printed
    FROM GIPI_WPOLBAS
   WHERE par_id  = p_par_id;
  -- for endorsement year value --
  IF p_par_type = 'E' THEN
     BEGIN
        FOR A IN (SELECT 1
                    FROM GIPI_WINVOICE
                   WHERE par_id = p_par_id) 
        LOOP
          v_affecting  := 'A';
        END LOOP;
        IF v_affecting IS NULL THEN
          v_affecting := 'N';
        END IF;
     END;
  
     --v_endt_yy    := TO_NUMBER(TO_CHAR(SYSDATE,'YY'));
     v_endt_yy    := v_issue_yy;
     --iris bordey (09.20.2002)
     --parameter.change_stat determines if user chooses to continue
     --posting after prompting that status of PAR will change to cancellation
     --endt since effective tsi = 0
     IF p_change_stat = 'Y' THEN 
         v_pol_flag := 4; 
        p_change_stat := 'N';     
     END IF;
     --BETH 041599 update pol_flag of the policy and all previous endorsement to 4 
     --            and save the current pol_flag to old_pol_flag
     IF v_pol_flag = '4' THEN
        UPDATE GIPI_POLBASIC
           SET old_pol_flag =  pol_flag,
               pol_flag     =  '4'  ,
               eis_flag     =  'N'           
         WHERE line_cd     = p_line_cd
           AND subline_cd  = v_subline_cd
           AND iss_cd      = p_iss_cd
           AND issue_yy    = v_issue_yy
           AND pol_seq_no  = v_pol_seq_no
           AND renew_no    = v_renew_no
           AND pol_flag  IN ('1','2','3');
        v_cancel_date := SYSDATE;
     END IF;    
     
     --added by John Daniel SR-22286 05.19.2016; set policy id of cancelled endorsement to 4 (cancelled)
     IF v_cancelled_endt_id IS NOT NULL THEN
        UPDATE GIPI_POLBASIC
           SET pol_flag = '4'
           WHERE policy_id = v_cancelled_endt_id;
     END IF;     
     
  --BETH 102299 for renewal/replacement policies that will use same policy no 
  --            extract the policy no of policy to be renew
  --BETH 102299 for renewal/replacement policies that will use same policy no 
  --            extract the policy no of policy to be renew
  --BETH 02062001 for renewal or replacement renew_no must accumulate
  --       regardless if it will use same policy or not
  ELSE
     FOR RENEW IN
         ( SELECT b.old_policy_id ID, NVL(a.same_polno_sw,'N') same_sw,
                  a.pol_flag --beth 04162001 to be use in determining value of actual_renew_no   
             FROM GIPI_WPOLBAS a, GIPI_WPOLNREP b
            WHERE a.par_id = b.par_id
              AND a.par_id = p_par_id
              AND a.pol_flag IN ('2','3'))
              --BETH 02062001 comment out validation for same policy no 
              --     so that renew no. will accumulate regardless if it will
              --     use same policy no or not    
              --AND NVL(a.same_polno_sw,'N') = 'Y'   
     LOOP 
       FOR OLD_DATA IN
           ( SELECT line_cd, subline_cd, iss_cd,issue_yy, pol_seq_no, renew_no, actual_renew_no,
                    manual_renew_no
               FROM GIPI_POLBASIC
              WHERE policy_id  = renew.ID)
       LOOP
            -- for policy that will use same no. copy pol_seq_no and issue_yy 
            -- from the old policy  
         IF renew.same_sw = 'Y' THEN    
            v_issue_yy   := old_data.issue_yy;
            v_pol_seq_no := old_data.pol_seq_no;
         END IF;   
         --BETH 04162001
         --     get max renew_no for the policy to be renewed 
         --     so that error for unique constraints will be eliminated 
         FOR  MAX_REN IN (SELECT renew_no, manual_renew_no--added by ailene 10/13/2008 to correct error in renewing policies with endorsement 
                                 --DECODE(policy_id, renew.id,manual_renew_no, 0) manual_renew_no --comment out by ailene 10/13/2008 
                            FROM GIPI_POLBASIC
                           WHERE line_cd = old_data.line_cd       
                             AND subline_cd = old_data.subline_cd
                             AND iss_cd = old_data.iss_cd
                             AND issue_yy = old_data.issue_yy
                             AND pol_seq_no = old_data.pol_seq_no
                             AND endt_seq_no = 0 -- 100809 aaron prf 3797
                          ORDER BY renew_no DESC)
         LOOP                    
           --if old policy has an existing manual_renew_no the renew no of the 
           --new policy will be the manual_renew_no + 1 else the renew_no is the 
           --old renew_no + 1
           IF NVL(max_ren.manual_renew_no,0) > 0 THEN
                v_renew_no   := NVL(max_ren.manual_renew_no,0) + 1;
           ELSE    
                 -- if policy is for replacement and new policy number is to be generated then 
                 -- renew number must be retained else renew number must be incremented
                 -- added by aivhie 120601
                 IF renew.pol_flag = '3' AND renew.same_sw = 'N' THEN 
                     v_renew_no   := NVL(max_ren.renew_no,0);
                 --added by iris bordey (09.18.2002)
                 --to handle a special case (for AUII) of renewing 1 policy to many/several policies.
                 --if renewing policy and nwe polict is to be generated then
                 --renew_no must be incremented from the renew_no(old_date.renew_no) of the policy to be renewed.
                 ELSIF renew.pol_flag = '2' AND renew.same_sw = 'N' THEN 
                     v_renew_no := NVL(old_data.renew_no,0) + 1;
                 ELSE
                v_renew_no   := NVL(max_ren.renew_no,0) + 1;
              END IF;
           END IF;   
           EXIT;
         END LOOP;    
         --BETH 04162001 for renewal populate field actual_renew_no if actual_renew_no
         --     is already existing in policy being renewd just accumulate it by 1 but if it is not yet 
         --     existing retrieved it by counting no. of renewals for the policy in gipi_polnrep for policy
         --     that is not spoiled                 
         IF renew.pol_flag = '2' THEN
               --if actual_renew_no is already populated in the policy being renewed
               --then add 1 to its actual renewed no     
               IF NVL(old_data.actual_renew_no,0) > 0 THEN
                    v_actual_renew_no := old_data.actual_renew_no + 1;                    
               ELSE
                    --if actual_renew_no of the policy being renew is null then
                    --actual_renew_no would be 1 + manual_renew_no    
                    v_actual_renew_no := NVL(old_data.manual_renew_no,0) +1;
                    v_count_id := renew.ID;
                    v_exit_sw := 'Y';
                    --check history of renewal of policy and for every renewal that is 
                    --not spoiled add 1 to actual_renew_no
                    WHILE v_exit_sw = 'Y'
                    LOOP
                 v_exit_sw := 'N';   
                         FOR A IN (SELECT b610.old_policy_id, 
                                          b250a.manual_renew_no
                                     FROM GIPI_POLBASIC b250, GIPI_POLBASIC b250a,
                                          GIPI_POLNREP b610
                                    WHERE b250.policy_id = b610.new_policy_id
                                      AND b250a.policy_id = b610.old_policy_id
                                      AND b250.pol_flag NOT IN( '4','5')
                                      AND b610.new_policy_id = v_count_id)
                         LOOP
                              v_actual_renew_no := v_actual_renew_no + NVL(a.manual_renew_no,0) + 1;
                              v_count_id := a.old_policy_id;              
                           v_exit_sw := 'Y'; 
                           EXIT;
                         END LOOP;
                         IF v_exit_sw = 'N' THEN
                               EXIT;
                         END IF;
                    END LOOP;                  
               END IF;     
         END IF;
       END LOOP;
     END LOOP;
  END IF;
  BEGIN
    /* Revised on 04 September 1997.
    */
    /* Modified by VJ 03.02.2007
    ** add solumn prem_warr_days
    */
    INSERT INTO GIPI_POLBASIC
               (policy_id,    line_cd,    subline_cd,    iss_cd,        issue_yy,
                pol_seq_no,    endt_iss_cd,    endt_yy,    endt_seq_no,    renew_no,
                    endt_type,    par_id,        incept_date,    expiry_date,    eff_date,
                    issue_date,    pol_flag,    assd_no,    designation,    address1,
                    address2,    address3,    mortg_name,    tsi_amt,    prem_amt,
                    ann_tsi_amt,    ann_prem_amt,    pool_pol_no,    foreign_acc_sw,    invoice_sw,
                  user_id,    last_upd_date,    spld_flag,    dist_flag,    endt_expiry_date,
                no_of_items,    subline_type_cd,auto_renew_flag,prorate_flag,    short_rt_percent,
                    prov_prem_tag,    type_cd,    acct_of_cd,     pack_pol_flag,    expiry_tag,
                prem_warr_tag,  ref_pol_no,     reg_policy_sw,  co_insurance_sw,discount_sw,
                ref_open_pol_no,incept_tag ,    booking_mth,    endt_expiry_tag,
                booking_year,   fleet_print_tag, manual_renew_no, with_tariff_sw,
                comp_sw, orig_policy_id, prov_prem_pct, place_cd,
                actual_renew_no, region_cd, industry_cd,acct_of_cd_sw,
                surcharge_sw, cred_branch, old_assd_no, cancel_date,
                old_address1, old_address2, old_address3, risk_tag, label_tag, 
                survey_agent_cd, settling_agent_cd,
                prem_warr_days,
                -- longterm --
                takeup_term,cancelled_endt_id, cancel_type,
                bank_ref_no, plan_sw, plan_cd, plan_ch_tag,
                pack_policy_id,  -- aaron 050409
                bond_seq_no, bond_auto_prem, --added by robert GENQA 4828 08.27.15
                -- bonok :: 06.03.2013 :: added insert for bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days and cn_date_printed
                bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days, cn_date_printed)
         VALUES(v_policy_id,    p_line_cd,    v_subline_cd,    p_iss_cd,    v_issue_yy,
                v_pol_seq_no,        p_iss_cd,    v_endt_yy,0,    v_renew_no,    
                    v_affecting,    p_par_id,    v_incept_dt,    v_expiry_dt,
                    v_eff_dt,        v_issue_dt,        v_pol_flag,    v_assd_no,
                    DECODE(v_designation, NULL, ' ', v_designation),
                    v_pol_addr1,        v_pol_addr2,    v_pol_addr3,
                    v_mortg_name,        
                    DECODE(v_tsi_amt, NULL, 0, v_tsi_amt),
                    DECODE(v_prem_amt, NULL, 0, v_prem_amt),
                    DECODE(v_ann_tsi, NULL, 0, v_ann_tsi),
                    DECODE(v_ann_prem, NULL, 0, v_ann_prem),
                    DECODE(v_pool_pol_no, NULL, ' ', v_pool_pol_no),
                    v_foreign_acc_tag,        v_invoices,
                    p_user_id,    SYSDATE,        '1',        '1',
                    v_endt_expiry_date,    v_no_of_items,        v_subline_type_cd,
                    DECODE(v_auto_renew_flag, NULL, ' ', v_auto_renew_flag),
                    v_prorate_flag,        
                    DECODE(v_short_rt_percent,NULL, 0, v_short_rt_percent),
                    v_prov_prem_tag,    v_type_cd,v_acct_of_cd,v_pack_pol_flag,     
                    DECODE(v_expiry_tag, NULL, 'N', v_expiry_tag),
                v_prem_warr_tag, v_ref_pol_no, v_reg_policy_sw, v_co_insurance_sw, 
                v_discount_sw, v_ref_open_pol_no, v_incept_tag, v_booking_mth,
                v_endt_expiry_tag, v_booking_year, v_fleet_print_tag,
                v_manual_renew_no, v_with_tariff_sw, v_comp_sw, v_orig_policy_id,
                v_prov_prem_pct, v_place_cd,
                v_actual_renew_no, v_region_cd, v_industry_cd, v_acct_of_cd_sw, 
                v_surcharge_sw, v_cred_branch, v_old_assd_no, v_cancel_date,
                v_old_address1, v_old_address2, v_old_address3,v_risk_tag, v_label_tag,
                v_survey_agent_cd, v_settling_agent_cd,
                v_prem_warr_days,
                -- longterm --
                v_takeup_term,v_cancelled_endt_id, v_cancel_type,
                v_bank_ref_no, v_plan_sw, v_plan_cd, v_plan_ch_tag,
                p_pack_policy_id,  -- aaron 050409
                v_bond_seq_no, v_bond_auto_prem, --added by robert GENQA 4828 08.27.15
                -- bonok :: 06.03.2013 :: added insert for bancassurance_sw, area_cd, branch_cd, manager_cd, banc_type_cd, cn_no_of_days and cn_date_printed
                v_bancassurance_sw, v_area_cd, v_branch_cd, v_manager_cd, v_banc_type_cd, v_cn_no_of_days, v_cn_date_printed);
  END;
  p_policy_id := v_policy_id;
END;
/


