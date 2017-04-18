CREATE OR REPLACE PACKAGE CPI.GIPI_GROUPED_ITEMS_PKG 
AS
	TYPE gipi_grouped_items_type IS RECORD (
		policy_id			gipi_grouped_items.policy_id%TYPE,
		item_no				gipi_grouped_items.item_no%TYPE,
		grouped_item_no		gipi_grouped_items.grouped_item_no%TYPE,
		grouped_item_title	gipi_grouped_items.grouped_item_title%TYPE,
		include_tag			gipi_grouped_items.include_tag%TYPE,
		sex					gipi_grouped_items.sex%TYPE,
		position_cd			gipi_grouped_items.position_cd%TYPE,
		civil_status		gipi_grouped_items.civil_status%TYPE,
		date_of_birth		gipi_grouped_items.date_of_birth%TYPE,
		age					gipi_grouped_items.age%TYPE,
        salary                gipi_grouped_items.salary%TYPE,
        salary_grade        gipi_grouped_items.salary_grade%TYPE,
        amount_coverage        gipi_grouped_items.amount_coverage%TYPE,
        remarks                gipi_grouped_items.remarks%TYPE,
        line_cd                gipi_grouped_items.line_cd%TYPE,
        subline_cd            gipi_grouped_items.subline_cd%TYPE,
        cpi_rec_no            gipi_grouped_items.cpi_rec_no%TYPE,
        cpi_branch_cd        gipi_grouped_items.cpi_branch_cd%TYPE,
        delete_sw            gipi_grouped_items.delete_sw%TYPE,
        group_cd            gipi_grouped_items.group_cd%TYPE,
        user_id                gipi_grouped_items.user_id%TYPE,
        last_update            gipi_grouped_items.last_update%TYPE,
        pack_ben_cd            gipi_grouped_items.pack_ben_cd%TYPE,
        ann_tsi_amt            gipi_grouped_items.ann_tsi_amt%TYPE,
        ann_prem_amt        gipi_grouped_items.ann_prem_amt%TYPE,
        control_cd            gipi_grouped_items.control_cd%TYPE,
        control_type_cd        gipi_grouped_items.control_type_cd%TYPE,
        tsi_amt                gipi_grouped_items.tsi_amt%TYPE,
        prem_amt            gipi_grouped_items.prem_amt%TYPE,
        from_date            gipi_grouped_items.from_date%TYPE,
        to_date                gipi_grouped_items.to_date%TYPE,
        payt_terms            gipi_grouped_items.payt_terms%TYPE,
        principal_cd        gipi_grouped_items.principal_cd%TYPE,
        arc_ext_data        gipi_grouped_items.arc_ext_data%TYPE);
        
    TYPE gipi_grouped_items_tab IS TABLE OF gipi_grouped_items_type;
    
    FUNCTION get_gipi_grouped_items_endt (
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_item_no IN gipi_grouped_items.item_no%TYPE,
        p_grouped_item_no IN gipi_grouped_items.grouped_item_no%TYPE)
    RETURN gipi_grouped_items_tab PIPELINED;
    
    FUNCTION is_zero_out_or_negated (
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_eff_date IN gipi_wpolbas.eff_date%TYPE,
        p_item_no IN gipi_item.item_no%TYPE,
        p_item_from_date IN gipi_item.from_date%TYPE,
        p_grouped_item_no IN gipi_grouped_items.grouped_item_no%TYPE,
        p_grp_from_date IN gipi_grouped_items.from_date%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION check_if_principal_enrollee (
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_item_no IN gipi_grouped_items.item_no%TYPE,
        p_grouped_item_no IN gipi_grouped_items.grouped_item_no%TYPE)
    RETURN VARCHAR2;
    
    TYPE casualty_grouped_item_type IS RECORD(
    
        policy_id           gipi_grouped_items.policy_id%TYPE,
        item_no             gipi_grouped_items.item_no%TYPE,
        sex                 gipi_grouped_items.sex%TYPE,
        age                 gipi_grouped_items.age%TYPE,
        salary              gipi_grouped_items.salary%TYPE,
        remarks             gipi_grouped_items.remarks%TYPE,
        position_cd         gipi_grouped_items.position_cd%TYPE,
        include_tag         gipi_grouped_items.include_tag%TYPE,
        salary_grade        gipi_grouped_items.salary_grade%TYPE,
        civil_status        gipi_grouped_items.civil_status%TYPE,
        date_of_birth       gipi_grouped_items.date_of_birth%TYPE,
        grouped_item_no     gipi_grouped_items.grouped_item_no%TYPE,
        amount_coverage     gipi_grouped_items.amount_coverage%TYPE,
        grouped_item_title  gipi_grouped_items.grouped_item_title%TYPE,

        sum_amt             gipi_grouped_items.amount_coverage%TYPE,
        mean_sex            cg_ref_codes.rv_meaning%TYPE,
        mean_civil_status   cg_ref_codes.rv_meaning%TYPE
        
    );
    
    TYPE casualty_grouped_item_tab IS TABLE OF casualty_grouped_item_type;
    
    FUNCTION get_casualty_grouped_items(
       p_policy_id   gipi_grouped_items.policy_id%TYPE,
       p_item_no     gipi_grouped_items.item_no%TYPE
    )
    RETURN casualty_grouped_item_tab PIPELINED;
    
    TYPE accident_grouped_item_type IS RECORD(
    
        age                 gipi_grouped_items.age%TYPE,
        sex                 gipi_grouped_items.sex%TYPE,
        salary              gipi_grouped_items.salary%TYPE,
        item_no             gipi_grouped_items.item_no%TYPE,
        remarks             gipi_grouped_items.remarks%TYPE,
        line_cd             gipi_grouped_items.line_cd%TYPE,
        to_date             gipi_grouped_items.to_date%TYPE,
        group_cd            gipi_grouped_items.group_cd%TYPE,
        from_date           gipi_grouped_items.from_date%TYPE,
        policy_id           gipi_grouped_items.policy_id%TYPE,
        payt_terms          gipi_grouped_items.payt_terms%TYPE,
        subline_cd          gipi_grouped_items.subline_cd%TYPE,
        control_cd          gipi_grouped_items.control_cd%TYPE,
        pack_ben_cd         gipi_grouped_items.pack_ben_cd%TYPE,
        position_cd         gipi_grouped_items.position_cd%TYPE,
        include_tag         gipi_grouped_items.include_tag%TYPE,
        principal_cd        gipi_grouped_items.principal_cd%TYPE,
        civil_status        gipi_grouped_items.civil_status%TYPE,
        salary_grade        gipi_grouped_items.salary_grade%TYPE,
        date_of_birth       gipi_grouped_items.date_of_birth%TYPE,
        grouped_item_no     gipi_grouped_items.grouped_item_no%TYPE,
        control_type_cd     gipi_grouped_items.control_type_cd%TYPE,
        amount_coverage     gipi_grouped_items.amount_coverage%TYPE,
        grouped_item_title  gipi_grouped_items.grouped_item_title%TYPE,

        control_type_desc   giis_control_type.control_type_desc%TYPE,
        package_cd          giis_package_benefit.package_cd%TYPE,
        payt_terms_desc     giis_payterm.payt_terms_desc%TYPE,
        position            giis_position.position%TYPE,
        group_desc          giis_group.group_desc%TYPE,
        mean_civil_status   VARCHAR2(20),
        mean_sex            VARCHAR2(10)
        
    );
    
    TYPE accident_grouped_item_tab IS TABLE OF accident_grouped_item_type;
    

    FUNCTION get_accident_grouped_items(
       p_policy_id   gipi_grouped_items.policy_id%TYPE,
       p_item_no     gipi_grouped_items.item_no%TYPE,
       p_grouped_item_no GIPI_GROUPED_ITEMS.GROUPED_ITEM_NO%TYPE,
       p_grouped_item_title GIPI_GROUPED_ITEMS.GROUPED_ITEM_TITLE%TYPE
    )
      RETURN accident_grouped_item_tab PIPELINED;
  
END GIPI_GROUPED_ITEMS_PKG;
/


