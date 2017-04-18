DROP PROCEDURE CPI.GIPIS002A_B540_POST_UPDATE_REV;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_B540_POST_UPDATE_REV
(  p_pack_par_id                 GIPI_PACK_WPOLBAS.pack_par_id%TYPE)
 
 IS
 
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  September 05, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This executes POST-UPDATE trigger in Block 540 of GIPIS002A.
**                 However, modifications were done to eliminate several input parameters.  
**  **  modified : added default takeup_term - irwin 10.24.2012                             
*/
 v_takeup_term GIPI_WPOLBAS.takeup_term%type;
 BEGIN
 	v_takeup_term := GIIS_PARAMETERS_PKG.v('TAKEUP_TERM');
    FOR i IN (SELECT a.label_tag,         a.assd_no,        a.eff_date,           a.surcharge_sw,       a.discount_sw,
                     a.incept_tag,        a.issue_yy,       a.expiry_tag,         a.pol_flag,           a.manual_renew_no,
                     a.place_cd,          a.type_cd,        a.industry_cd,        a.region_cd,          a.cred_branch,
                     a.address1,          a.address2,       a.address3,           a.booking_year,       a.booking_mth,
                     a.prorate_flag,      a.comp_sw,        a.foreign_acc_sw,     a.reg_policy_sw,      a.co_insurance_sw,
                     a.auto_renew_flag,   a.prov_prem_pct,  a.same_polno_sw,      a.prov_prem_tag,      a.short_rt_percent,
                     a.prem_warr_tag,     a.with_tariff_sw, a.designation,        a.ref_open_pol_no,    a.acct_of_cd,
                     a.incept_date,       a.expiry_date,    a.issue_date,         a.ref_pol_no,         a.risk_tag,
                     a.area_cd,           a.branch_cd,      a.manager_cd,         a.banc_type_cd,       a.employee_cd,
                     a.company_cd,        a.bank_ref_no
              FROM GIPI_PACK_WPOLBAS a
              WHERE pack_par_id = p_pack_par_id)
    LOOP
    
        UPDATE GIPI_PARLIST
           SET assd_no = i.assd_no
        WHERE pack_par_id = p_pack_par_id
          AND par_status NOT IN (98,99);   

        UPDATE GIPI_WPOLBAS
           SET label_tag         = i.label_tag,
               assd_no           = i.assd_no,
               eff_date          = i.eff_date,  
               surcharge_sw      = i.surcharge_sw,
               discount_sw       = i.discount_sw,
               incept_tag        = i.incept_tag,
               manual_renew_no   = i.manual_renew_no,
               issue_yy          = i.issue_yy, 
               expiry_tag        = i.expiry_tag,
               pol_flag          = i.pol_flag,
               place_cd          = i.place_cd,
               type_cd           = i.type_cd,
               industry_cd       = i.industry_cd,
               region_cd         = i.region_cd,
               address1          = i.address1, 
               address2          = i.address2, 
               address3          = i.address3,
               cred_branch       = i.cred_branch,
               booking_year      = i.booking_year,
               booking_mth       = i.booking_mth,
               prorate_flag      = i.prorate_flag,
               comp_sw           = i.comp_sw,
               foreign_acc_sw    = i.foreign_acc_sw,
               reg_policy_sw     = i.reg_policy_sw,
               co_insurance_sw   = i.co_insurance_sw,
               auto_renew_flag   = i.auto_renew_flag,
               prov_prem_tag     = i.prov_prem_tag,
               same_polno_sw     = i.same_polno_sw,
               prov_prem_pct     = i.prov_prem_pct,
               short_rt_percent  = i.short_rt_percent,
               prem_warr_tag     = i.prem_warr_tag,
               with_tariff_sw    = i.with_tariff_sw,
               designation       = i.designation,
               ref_open_pol_no   = i.ref_open_pol_no,
               acct_of_cd        = i.acct_of_cd,
               incept_date       = i.incept_date,
               expiry_date       = i.expiry_date,
               issue_date        = i.issue_date,
               ref_pol_no        = i.ref_pol_no,
               risk_tag          = i.risk_tag,
               area_cd           = i.area_cd, 
               branch_cd         = i.branch_cd, 
               manager_cd        = i.manager_cd, 
               banc_type_cd      = i.banc_type_cd,
               company_cd        = i.company_cd, 
               employee_cd       = i.employee_cd,
			   takeup_term       = v_takeup_term
        WHERE pack_par_id = p_pack_par_id;
        
        EXIT;
        
    END LOOP;
END;
/


