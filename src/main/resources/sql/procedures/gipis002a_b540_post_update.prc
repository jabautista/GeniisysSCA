DROP PROCEDURE CPI.GIPIS002A_B540_POST_UPDATE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_B540_POST_UPDATE
(  p_pack_par_id                 GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
   p_label_tag                   GIPI_PACK_WPOLBAS.label_tag%TYPE,
   p_assd_no                     GIPI_PACK_WPOLBAS.assd_no%TYPE,
   p_eff_date                    GIPI_PACK_WPOLBAS.eff_date%TYPE,
   p_surcharge_sw                GIPI_PACK_WPOLBAS.surcharge_sw%TYPE,
   p_discount_sw                 GIPI_PACK_WPOLBAS.discount_sw%TYPE,
   p_incept_tag                  GIPI_PACK_WPOLBAS.incept_tag%TYPE,
   p_manual_renew_no             GIPI_PACK_WPOLBAS.manual_renew_no%TYPE,
   p_issue_yy                    GIPI_PACK_WPOLBAS.issue_yy%TYPE, 
   p_expiry_tag                  GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
   p_pol_flag                    GIPI_PACK_WPOLBAS.pol_flag%TYPE,
   p_place_cd                    GIPI_PACK_WPOLBAS.place_cd%TYPE,
   p_type_cd                     GIPI_PACK_WPOLBAS.type_cd%TYPE,
   p_industry_cd                 GIPI_PACK_WPOLBAS.industry_cd%TYPE,
   p_region_cd                   GIPI_PACK_WPOLBAS.region_cd%TYPE,
   p_address1                    GIPI_PACK_WPOLBAS.address1%TYPE, 
   p_address2                    GIPI_PACK_WPOLBAS.address2%TYPE, 
   p_address3                    GIPI_PACK_WPOLBAS.address3%TYPE,
   p_cred_branch                 GIPI_PACK_WPOLBAS.cred_branch%TYPE,
   p_booking_year                GIPI_PACK_WPOLBAS.booking_year%TYPE,
   p_booking_mth                 GIPI_PACK_WPOLBAS.booking_mth%TYPE,
   p_prorate_flag                GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
   p_comp_sw                     GIPI_PACK_WPOLBAS.comp_sw%TYPE,
   p_foreign_acc_sw              GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
   p_reg_policy_sw               GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,
   p_co_insurance_sw             GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
   p_auto_renew_flag             GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
   p_prov_prem_tag               GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,
   p_same_polno_sw               GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
   p_prov_prem_pct               GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
   p_short_rt_percent            GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,
   p_prem_warr_tag               GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
   p_with_tariff_sw              GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
   p_designation                 GIPI_PACK_WPOLBAS.designation%TYPE,
   p_ref_open_pol_no             GIPI_PACK_WPOLBAS.ref_open_pol_no%TYPE,
   p_acct_of_cd                  GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
   p_incept_date                 GIPI_PACK_WPOLBAS.incept_date%TYPE,
   p_expiry_date                 GIPI_PACK_WPOLBAS.expiry_date%TYPE,
   p_issue_date                  GIPI_PACK_WPOLBAS.issue_date%TYPE,
   p_ref_pol_no                  GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
   p_risk_tag                    GIPI_PACK_WPOLBAS.risk_tag%TYPE)
 
 IS
 
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 11, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This executes POST-UPDATE trigger in Block 540 of GIPIS002A. 
**                            
*/
 
 BEGIN
    
    UPDATE GIPI_PARLIST
       SET assd_no = p_assd_no
    WHERE pack_par_id = p_pack_par_id
      AND par_status NOT IN (98,99);   

    UPDATE GIPI_WPOLBAS
       SET label_tag         = p_label_tag,
           assd_no           = p_assd_no,
           eff_date          = p_incept_date,--p_eff_date, replaced by: Nica 04.18.2011 
           surcharge_sw      = p_surcharge_sw,
           discount_sw       = p_discount_sw,
           incept_tag        = p_incept_tag,
           manual_renew_no   = p_manual_renew_no,
           issue_yy          = p_issue_yy, 
           expiry_tag        = p_expiry_tag,
           pol_flag          = p_pol_flag,
           place_cd          = p_place_cd,
           type_cd           = p_type_cd,
           industry_cd       = p_industry_cd,
           region_cd         = p_region_cd,
           address1          = p_address1, 
           address2          = p_address2, 
           address3          = p_address3,
           cred_branch       = p_cred_branch,
           booking_year      = p_booking_year,
           booking_mth       = p_booking_mth,
           prorate_flag      = p_prorate_flag,
           comp_sw           = p_comp_sw,
           foreign_acc_sw    = p_foreign_acc_sw,
           reg_policy_sw     = p_reg_policy_sw,
           co_insurance_sw   = p_co_insurance_sw,
           auto_renew_flag   = p_auto_renew_flag,
           prov_prem_tag     = p_prov_prem_tag,
           same_polno_sw     = p_same_polno_sw,
           prov_prem_pct     = p_prov_prem_pct,
           short_rt_percent  = p_short_rt_percent,
           prem_warr_tag     = p_prem_warr_tag,
           with_tariff_sw    = p_with_tariff_sw,
           designation       = p_designation,
           ref_open_pol_no   = p_ref_open_pol_no,
           acct_of_cd        = p_acct_of_cd,
           incept_date       = p_incept_date,
           expiry_date       = p_expiry_date,
           issue_date        = p_issue_date,
           ref_pol_no        = p_ref_pol_no,
           risk_tag          = p_risk_tag
    WHERE pack_par_id = p_pack_par_id;
END;
/


