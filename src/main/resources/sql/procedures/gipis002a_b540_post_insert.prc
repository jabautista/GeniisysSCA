DROP PROCEDURE CPI.GIPIS002A_B540_POST_INSERT;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_B540_POST_INSERT
(p_pack_par_id              GIPI_PACK_WPOLBAS.pack_par_id%TYPE)

IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 11, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This executes POST-INSERT trigger in Block 540 of GIPIS002A. 
**  modified : added default takeup_term - irwin 10.24.2012                          
*/

v_takeup_term GIPI_WPOLBAS.takeup_term%type;

BEGIN
	v_takeup_term := GIIS_PARAMETERS_PKG.v('TAKEUP_TERM');
	
    INSERT INTO GIPI_WPOLBAS
    (par_id,                  line_cd,                iss_cd, 
     foreign_acc_sw,          invoice_sw,             quotation_printed_sw, 
     covernote_printed_sw,    auto_renew_flag,        prov_prem_tag, 
     same_polno_sw,           pack_pol_flag,          reg_policy_sw, 
     co_insurance_sw,         manual_renew_no,        subline_cd, 
     issue_yy,                pol_seq_no,             endt_iss_cd, 
     endt_yy,                 endt_seq_no,            renew_no, 
     endt_type,               incept_date,            expiry_date, 
     expiry_tag,              eff_date,               issue_date, 
     pol_flag,                assd_no,                designation, 
     address1,                address2,               address3, 
     mortg_name,              tsi_amt,                prem_amt, 
     ann_tsi_amt,             ann_prem_amt,           pool_pol_no, 
     user_id,                 orig_policy_id,         endt_expiry_date, 
     no_of_items,             subline_type_cd,        prorate_flag, 
     short_rt_percent,        type_cd,                acct_of_cd, 
     prov_prem_pct,           discount_sw,            prem_warr_tag, 
     ref_pol_no,              ref_open_pol_no,        incept_tag, 
     fleet_print_tag,         comp_sw,                booking_mth, 
     booking_year,            with_tariff_sw,         endt_expiry_tag, 
     cover_nt_printed_date,   cover_nt_printed_cnt,   place_cd, 
     back_stat,               qd_flag,                validate_tag, 
     industry_cd,             region_cd,              acct_of_cd_sw, 
     surcharge_sw,            cred_branch,            old_assd_no, 
     cancel_date,             label_tag,              old_address1, 
     old_address2,            old_address3,           risk_tag, 
     pack_par_id,             bancassurance_sw,       bank_ref_no,
     area_cd,                 branch_cd,              manager_cd, 
     banc_type_cd,            company_cd,             employee_cd, takeup_term)                                                  
    SELECT 
     c.par_id,                A.pack_line_cd,         b.iss_cd, 
     b.foreign_acc_sw,        b.invoice_sw,           b.quotation_printed_sw, 
     b.covernote_printed_sw,  b.auto_renew_flag,      b.prov_prem_tag, 
     b.same_polno_sw,         b.pack_pol_flag,        b.reg_policy_sw, 
     b.co_insurance_sw,       b.manual_renew_no,      A.pack_subline_cd,
     b.issue_yy,              b.pol_seq_no,           b.endt_iss_cd, 
     b.endt_yy,               b.endt_seq_no,          b.renew_no, 
     b.endt_type,             b.incept_date,          b.expiry_date, 
     b.expiry_tag,            b.eff_date,             b.issue_date, 
     b.pol_flag,              b.assd_no,              b.designation, 
     b.address1,              b.address2,             b.address3, 
     b.mortg_name,            b.tsi_amt,              b.prem_amt, 
     b.ann_tsi_amt,           b.ann_prem_amt,         b.pool_pol_no, 
     b.user_id,               b.orig_policy_id,       b.endt_expiry_date, 
     b.no_of_items,           b.subline_type_cd,      b.prorate_flag, 
     b.short_rt_percent,      b.type_cd,              b.acct_of_cd, 
     b.prov_prem_pct,         b.discount_sw,          b.prem_warr_tag, 
     b.ref_pol_no,            b.ref_open_pol_no,      b.incept_tag, 
     b.fleet_print_tag,       b.comp_sw,              b.booking_mth, 
     b.booking_year,          b.with_tariff_sw,       b.endt_expiry_tag, 
     b.cover_nt_printed_date, b.cover_nt_printed_cnt, b.place_cd, 
     b.back_stat,             b.qd_flag,              b.validate_tag, 
     b.industry_cd,           b.region_cd,            b.acct_of_cd_sw, 
     b.surcharge_sw,          b.cred_branch,          b.old_assd_no, 
     b.cancel_date,           b.label_tag,            b.old_address1, 
     b.old_address2,          b.old_address3,         b.risk_tag,
     b.pack_par_id,           b.bancassurance_sw,     b.bank_ref_no,
     b.area_cd,               b.branch_cd,            b.manager_cd, 
     b.banc_type_cd,          b.company_cd,           b.employee_cd, v_takeup_term
    FROM GIPI_PARLIST c,
    GIPI_WPACK_LINE_SUBLINE A,     
    GIPI_PACK_WPOLBAS b
    WHERE 1=1
    AND c.par_id = A.par_id
    AND c.line_cd = A.pack_line_cd  
    AND A.pack_par_id = b.pack_par_id
    AND A.line_cd = b.line_cd
    AND b.pack_par_id = p_pack_par_id;
END;
/


