DROP PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE03;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE03 (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_p_first_endt_sw IN VARCHAR2,
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
	p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
	p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
	p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
	p_renew_no IN gipi_wpolbas.renew_no%TYPE,
	p_expiry_date IN gipi_wpolbas.expiry_date%TYPE,
	p_p_cg_back_endt OUT VARCHAR2,
	p_p_back_endt_sw OUT VARCHAR2,
	p_gipi_parlist OUT gipis031_ref_cursor_pkg.rc_gipi_parlist_type,
    p_gipi_wpolbas OUT gipis031_ref_cursor_pkg.rc_gipi_wpolbas_type,
    p_message OUT VARCHAR2,
    p_message_type OUT VARCHAR2,
    p_v_v_exp_date IN OUT DATE,
    p_eff_date IN OUT gipi_wpolbas.eff_date%TYPE)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.10.2012    mark jm            Retrieve information based on the new specified effecivity date
    **                                Fires only when the entered effecivity date is changed and if
    **                                endt is a backward endt or if the change in effectivity will
    **                                make it a backward endorsement (Original Description)
    **                                Part 3. See GIPIS031_VALIDATE_EFF_DATE04 for next part
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
    v_parlist gipi_parlist%ROWTYPE;
    v_wpolbas gipi_wpolbas%ROWTYPE;
    v_message VARCHAR2(4000);
    v_message_type VARCHAR2(20);
BEGIN
    IF p_p_first_endt_sw = 'Y' THEN
        p_message := 'This is a Backward Endorsement since it''s effectivity date is earlier than the effectivity date '||
                        'of previous endorsement(s).';
        p_message_type := 'ERROR';
    ELSE
        p_message := 'Since this is a Backward Endorsement initial information is not the latest record as of entered effectivity date. '||
                        'Changes is about to take place.';
        p_message_type := 'ERROR';
    END IF;
    
    p_p_cg_back_endt := 'Y';
    SEARCH_FOR_POLICY2_1(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no,
        p_renew_no,    p_eff_date,    p_expiry_date, p_v_v_exp_date, v_parlist, v_wpolbas,
        v_message, v_message_type); -- retrieved current info based on entered date
    
    /* creates new record cursor for GIPI_PARLIST based on the following data */
    OPEN p_gipi_parlist FOR
    SELECT v_parlist.par_id par_id,        v_parlist.line_cd line_cd,            v_parlist.iss_cd iss_cd,
           v_parlist.par_yy par_yy,        v_parlist.par_seq_no par_seq_no,    v_parlist.quote_seq_no quote_seq_no,
           v_parlist.par_type par_type,    v_parlist.par_status par_status,    v_parlist.assd_no assd_no,
           v_parlist.address1 address1,    v_parlist.address2 address2,        v_parlist.address3 address3
      FROM DUAL;
    
    /* creates new record cursor for GIPI_WPOLBAS based on the following data */
    OPEN p_gipi_wpolbas FOR
    SELECT v_wpolbas.line_cd line_cd,                    v_wpolbas.subline_cd subline_cd,                v_wpolbas.iss_cd iss_cd,
           v_wpolbas.issue_yy issue_yy,                    v_wpolbas.pol_seq_no pol_seq_no,                v_wpolbas.renew_no renew_no,
           v_wpolbas.endt_iss_cd endt_iss_cd,            v_wpolbas.endt_yy endt_yy,                        v_wpolbas.incept_date incept_date,
           v_wpolbas.incept_tag incept_tag,                v_wpolbas.expiry_tag expiry_tag,                v_wpolbas.endt_expiry_date endt_expiry_tag,
           v_wpolbas.eff_date eff_date,                    v_wpolbas.endt_expiry_date endt_expiry_date,    v_wpolbas.type_cd type_cd,
           v_wpolbas.same_polno_sw same_polno_sw,        v_wpolbas.foreign_acc_sw foreign_acc_sw,        v_wpolbas.comp_sw comp_sw,
           v_wpolbas.prem_warr_tag prem_warr_tag,        v_wpolbas.old_assd_no old_assd_no,                v_wpolbas.old_address1 old_address1,
           v_wpolbas.old_address2 old_address2,            v_wpolbas.old_address3 old_address3,            v_wpolbas.address1 address1,
           v_wpolbas.address2 address2,                    v_wpolbas.address3 address3,                    v_wpolbas.reg_policy_sw reg_policy_sw,
           v_wpolbas.co_insurance_sw co_insurance_sw,    v_wpolbas.manual_renew_no manual_renew_no,        v_wpolbas.cred_branch cred_branch,
           v_wpolbas.ref_pol_no ref_pol_no,                v_wpolbas.takeup_term takeup_term,                v_wpolbas.booking_mth booking_mth,
           v_wpolbas.booking_year booking_year,            v_wpolbas.expiry_date expiry_date,                v_wpolbas.prov_prem_tag prov_prem_tag,
           v_wpolbas.prov_prem_pct prov_prem_pct,        v_wpolbas.prorate_flag prorate_flag,            v_wpolbas.pol_flag pol_flag,
           v_wpolbas.ann_tsi_amt ann_tsi_amt,            v_wpolbas.ann_prem_amt ann_prem_amt,            v_wpolbas.issue_date issue_date,
           v_wpolbas.pack_pol_flag pack_pol_flag
      FROM DUAL;
          
    IF NOT v_message IS NULL THEN
        p_message := v_message;
        p_message_type := v_message_type;
        RETURN;        
    END IF;
    
    p_p_back_endt_sw := 'Y';
    
END GIPIS031_VALIDATE_EFF_DATE03;
/


