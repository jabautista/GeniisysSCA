CREATE OR REPLACE PACKAGE CPI.GIUTS008A_PKG
	/*
    **  Created by        : bonok
    **  Date Created      : 02.11.2013
    **  Reference By      : GIUTS008A - COPY PACKAGE POLICY TO PAR
    */
AS
	FUNCTION validate_line_cd(
		p_line_cd	giis_line.line_cd%TYPE,
		p_iss_cd	giis_issource.iss_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE --added by reymon 05042013
	)
		RETURN VARCHAR2;
		
	FUNCTION validate_iss_cd(
		p_line_cd	giis_line.line_cd%TYPE,
		p_iss_cd	giis_issource.iss_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE --added by reymon 05072013
	)
		RETURN VARCHAR2;
		
	PROCEDURE copy_pack_policy_giuts008a(
		p_line_cd		   IN  gipi_polbasic.line_cd%TYPE,
		p_subline_cd	   IN  gipi_polbasic.subline_cd%TYPE,
		p_iss_cd		   IN  gipi_polbasic.iss_cd%TYPE,
        p_par_iss_cd	   IN  gipi_polbasic.iss_cd%TYPE,
		p_issue_yy		   IN  gipi_polbasic.issue_yy%TYPE,
		p_pol_seq_no	   IN  gipi_polbasic.pol_seq_no%TYPE,
		p_renew_no		   IN  gipi_polbasic.renew_no%TYPE,
		p_endt_iss_cd	   IN  gipi_polbasic.endt_iss_cd%TYPE,
		p_endt_yy		   IN  gipi_polbasic.endt_yy%TYPE,
		p_endt_seq_no	   IN  gipi_polbasic.endt_seq_no%TYPE,
        p_user_id          IN  gipi_polbasic.user_id%TYPE,
        v_par_par_seq_no   OUT gipi_pack_parlist.par_seq_no%TYPE,
        v_par_quote_seq_no OUT gipi_pack_parlist.quote_seq_no%TYPE
	);
	
    PROCEDURE get_param_value_v(
        p_variables_line_ac     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_av     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_en     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_mc     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_fi     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_ca     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_mh     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_mn     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_su     OUT giis_parameters.param_value_v%TYPE,
        p_variables_subline_mop OUT giis_parameters.param_value_v%TYPE
    );
    
	PROCEDURE check_endt(
		p_line_cd		gipi_polbasic.line_cd%TYPE,
		p_subline_cd	gipi_polbasic.subline_cd%TYPE,
		p_iss_cd		gipi_polbasic.iss_cd%TYPE,
		p_issue_yy		gipi_polbasic.issue_yy%TYPE,
		p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
		p_renew_no		gipi_polbasic.renew_no%TYPE,
		p_endt_iss_cd	gipi_polbasic.endt_iss_cd%TYPE,
		p_endt_yy		gipi_polbasic.endt_yy%TYPE,
		p_endt_seq_no	gipi_polbasic.endt_seq_no%TYPE
	);
    
    PROCEDURE check_policy(
        p_line_cd		gipi_polbasic.line_cd%TYPE,
		p_subline_cd	gipi_polbasic.subline_cd%TYPE,
		p_iss_cd		gipi_polbasic.iss_cd%TYPE,
		p_issue_yy		gipi_polbasic.issue_yy%TYPE,
		p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
		p_renew_no		gipi_polbasic.renew_no%TYPE
    );
    
    PROCEDURE insert_into_pack_parlist(
        p_policy_id          IN  gipi_polbasic.policy_id%TYPE,
        p_user_id            IN  gipi_polbasic.user_id%TYPE,
        p_par_iss_cd         IN  gipi_polbasic.iss_cd%TYPE,
        p_copy_pack_par_id   OUT gipi_parlist.pack_par_id%TYPE,
        p_parameter_par_type OUT gipi_parlist.par_type%TYPE
    );
    
    PROCEDURE insert_into_pack_parhist(
        p_copy_pack_par_id  gipi_parlist.pack_par_id%TYPE,
        p_user_id           gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_pack_polbasic(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_line_cd		     gipi_polbasic.line_cd%TYPE,
		p_subline_cd	     gipi_polbasic.subline_cd%TYPE,
		p_iss_cd		     gipi_polbasic.iss_cd%TYPE,
        p_par_iss_cd         gipi_polbasic.iss_cd%TYPE,
		p_issue_yy		     gipi_polbasic.issue_yy%TYPE,
		p_pol_seq_no	     gipi_polbasic.pol_seq_no%TYPE,
		p_renew_no		     gipi_polbasic.renew_no%TYPE,
        p_variables_iss_cd   gipi_polbasic.iss_cd%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_pack_polgenin(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_pack_polwc(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE   
    );
    
    PROCEDURE copy_pack_endttext(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE insert_into_parlist(
        p_policy_id          IN  gipi_polbasic.policy_id%TYPE,
        p_copy_par_id        OUT gipi_parlist.par_id%TYPE,
        p_user_id            IN  gipi_polbasic.user_id%TYPE,
        p_copy_pack_par_id   IN  gipi_polbasic.par_id%TYPE,
        p_parameter_par_type OUT gipi_parlist.par_type%TYPE,
        p_par_iss_cd         IN  gipi_polbasic.iss_cd%TYPE
    );
    
    PROCEDURE insert_into_parhist(
        p_copy_par_id        gipi_parlist.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_polbasic(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_variables_line_cd    gipi_polbasic.line_cd%TYPE,
		p_variables_subline_cd gipi_polbasic.subline_cd%TYPE,
		p_variables_iss_cd	   gipi_polbasic.iss_cd%TYPE,
		p_variables_issue_yy   gipi_polbasic.issue_yy%TYPE,
		p_variables_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
		p_variables_renew_no   gipi_polbasic.renew_no%TYPE,
        p_par_iss_cd           gipi_polbasic.iss_cd%TYPE,
        p_copy_pack_par_id     gipi_polbasic.par_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_mortgagee(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_par_iss_cd           gipi_polbasic.iss_cd%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_polgenin(
        p_policy_id            IN  gipi_polbasic.policy_id%TYPE,
        p_copy_v_long          OUT gipi_polgenin.gen_info%TYPE,
        p_copy_par_id          IN  gipi_polbasic.par_id%TYPE,
        p_user_id              IN  gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_polwc(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_endttext(
        p_policy_id            IN  gipi_polbasic.policy_id%TYPE,
        p_copy_v_long          OUT gipi_polgenin.gen_info%TYPE,
        p_copy_par_id          IN  gipi_polbasic.par_id%TYPE,
        p_user_id              IN  gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_pack_line_subline(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_copy_pack_par_id     gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_lim_liab(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_item(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_parameter_par_type   gipi_parlist.par_type%TYPE,
        p_variables_line_cd    gipi_polbasic.line_cd%TYPE,
		p_variables_subline_cd gipi_polbasic.subline_cd%TYPE,
		p_variables_iss_cd	   gipi_polbasic.iss_cd%TYPE,
		p_variables_issue_yy   gipi_polbasic.issue_yy%TYPE,
		p_variables_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
		p_variables_renew_no   gipi_polbasic.renew_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_itmperil(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_peril_discount(
        p_policy_id            gipi_peril_discount.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_item_discount(
        p_policy_id            gipi_peril_discount.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_polbas_discount(
        p_policy_id            gipi_peril_discount.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_beneficiary(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_accident_item(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_casualty_item(
        p_policy_id            gipi_casualty_item.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_casualty_personnel(
        p_policy_id            gipi_casualty_item.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_engg_basic(
        p_policy_id            gipi_engg_basic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_location(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_principal(
        p_policy_id            gipi_principal.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_fire(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_vehicle(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_mcacc(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_bond_basic(
        p_policy_id            IN gipi_polbasic.policy_id%TYPE,
        p_copy_v_long          OUT gipi_polgenin.gen_info%TYPE,
        p_copy_par_id          IN gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_cosigntry(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_aviation_cargo_hull(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_line_cd		       gipi_polbasic.line_cd%TYPE,
		p_subline_cd	       gipi_polbasic.subline_cd%TYPE,
		p_iss_cd		       gipi_polbasic.iss_cd%TYPE,
		p_issue_yy		       gipi_polbasic.issue_yy%TYPE,
		p_pol_seq_no	       gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no		       gipi_polbasic.renew_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_parameter_par_type   gipi_pack_parlist.par_type%TYPE,
        p_variables_line_mn    giis_parameters.param_value_v%TYPE,
        p_variables_line_mh    giis_parameters.param_value_v%TYPE,
        p_variables_line_av    giis_parameters.param_value_v%TYPE,
        p_user_id		       gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_open_liab(
        p_policy_id            gipi_open_liab.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_open_cargo(
        p_policy_id            gipi_open_cargo.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_open_peril(
        p_policy_id            gipi_open_peril.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_cargo(
        p_policy_id            gipi_cargo.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_cargo_carrier(
        p_policy_id            gipi_cargo_carrier.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    );
    
    PROCEDURE copy_item_ves(
        p_policy_id            gipi_item_ves.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_ves_air(
        p_policy_id            gipi_ves_air.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_open_policy(
        p_open_policy_id       gipi_open_policy.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_ves_accumulation(
        p_line_cd		       gipi_ves_accumulation.line_cd%TYPE,
		p_subline_cd	       gipi_ves_accumulation.subline_cd%TYPE,
		p_iss_cd		       gipi_ves_accumulation.iss_cd%TYPE,
		p_issue_yy		       gipi_ves_accumulation.issue_yy%TYPE,
		p_pol_seq_no	       gipi_ves_accumulation.pol_seq_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_aviation_item(
        p_policy_id            gipi_aviation_item.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_deductibles(
        p_policy_id            IN  gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          IN  gipi_polbasic.par_id%TYPE,
        p_copy_v_long          OUT gipi_wdeductibles.deductible_text%TYPE
    );
    
    PROCEDURE copy_grouped_items(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_grp_items_beneficiary(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_item_no              gipi_item.item_no%TYPE,
        p_grouped_item_no      gipi_grp_items_beneficiary.grouped_item_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ); 
    
    PROCEDURE copy_itmperil_beneficiary(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_item_no              gipi_item.item_no%TYPE,
        p_grouped_item_no      gipi_grp_items_beneficiary.grouped_item_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_itmperil_grouped(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_item_no              gipi_item.item_no%TYPE,
        p_grouped_item_no      gipi_itmperil_grouped.grouped_item_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_pictures(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_orig_invoice(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE    
    );
    
    PROCEDURE copy_orig_invperl(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_orig_inv_tax(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );    
    
    PROCEDURE copy_orig_itmperil(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_co_ins(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    ); 
    
    PROCEDURE copy_invoice_pack(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_invperil(
        p_item_grp             gipi_inv_tax.item_grp%TYPE,
        p_prem_seq_no          gipi_inv_tax.prem_seq_no%TYPE,
        p_iss_cd               gipi_inv_tax.iss_cd%TYPE,
        p_takeup_seq_no        NUMBER,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_inv_tax(
        p_item_grp             gipi_inv_tax.item_grp%TYPE,
        p_prem_seq_no          gipi_inv_tax.prem_seq_no%TYPE,
        p_iss_cd               gipi_inv_tax.iss_cd%TYPE,
        p_takeup_seq_no        NUMBER,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
    
    PROCEDURE copy_installment(
        p_item_grp             gipi_inv_tax.item_grp%TYPE,
        p_prem_seq_no          gipi_inv_tax.prem_seq_no%TYPE,
        p_iss_cd               gipi_inv_tax.iss_cd%TYPE,
        p_takeup_seq_no        NUMBER,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    );
        
END GIUTS008A_PKG;
/


