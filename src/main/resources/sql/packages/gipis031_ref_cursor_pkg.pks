CREATE OR REPLACE PACKAGE CPI.Gipis031_Ref_Cursor_Pkg 
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.25.2010
	**  Reference By 	: GIPIS031 - Endt Basic Information
	**  Description 	: Contains different row types of every table used in GIPIS031	
	*/	

	TYPE gipis031_wendttext_type IS RECORD (		
		endt_text	GIPI_WENDTTEXT.endt_text%TYPE,		
		endt_tax	GIPI_WENDTTEXT.endt_tax%TYPE,
		endt_text01	GIPI_WENDTTEXT.endt_text01%TYPE,
		endt_text02	GIPI_WENDTTEXT.endt_text02%TYPE,
		endt_text03	GIPI_WENDTTEXT.endt_text03%TYPE,
		endt_text04	GIPI_WENDTTEXT.endt_text04%TYPE,
		endt_text05	GIPI_WENDTTEXT.endt_text05%TYPE,
		endt_text06	GIPI_WENDTTEXT.endt_text06%TYPE,
		endt_text07	GIPI_WENDTTEXT.endt_text07%TYPE,
		endt_text08	GIPI_WENDTTEXT.endt_text08%TYPE,
		endt_text09	GIPI_WENDTTEXT.endt_text09%TYPE,
		endt_text10	GIPI_WENDTTEXT.endt_text10%TYPE,
		endt_text11	GIPI_WENDTTEXT.endt_text11%TYPE,
		endt_text12	GIPI_WENDTTEXT.endt_text12%TYPE,
		endt_text13	GIPI_WENDTTEXT.endt_text13%TYPE,
		endt_text14	GIPI_WENDTTEXT.endt_text14%TYPE,
		endt_text15	GIPI_WENDTTEXT.endt_text15%TYPE,
		endt_text16	GIPI_WENDTTEXT.endt_text16%TYPE,
		endt_text17	GIPI_WENDTTEXT.endt_text17%TYPE,
		endt_cd		GIPI_WENDTTEXT.endt_cd%TYPE);

	TYPE gipis031_wpolgenin_type IS RECORD (
		gen_info01	GIPI_WPOLGENIN.gen_info01%TYPE,
		gen_info02  GIPI_WPOLGENIN.gen_info02%TYPE,
		gen_info03  GIPI_WPOLGENIN.gen_info03%TYPE,
		gen_info04  GIPI_WPOLGENIN.gen_info04%TYPE,
		gen_info05  GIPI_WPOLGENIN.gen_info05%TYPE,
		gen_info06  GIPI_WPOLGENIN.gen_info06%TYPE,
		gen_info07  GIPI_WPOLGENIN.gen_info07%TYPE,
		gen_info08  GIPI_WPOLGENIN.gen_info08%TYPE,
		gen_info09  GIPI_WPOLGENIN.gen_info09%TYPE,
		gen_info10  GIPI_WPOLGENIN.gen_info10%TYPE,
		gen_info11  GIPI_WPOLGENIN.gen_info11%TYPE,
		gen_info12  GIPI_WPOLGENIN.gen_info12%TYPE,
		gen_info13  GIPI_WPOLGENIN.gen_info13%TYPE,
		gen_info14  GIPI_WPOLGENIN.gen_info14%TYPE,
		gen_info15  GIPI_WPOLGENIN.gen_info15%TYPE,
		gen_info16  GIPI_WPOLGENIN.gen_info16%TYPE,
		gen_info17  GIPI_WPOLGENIN.gen_info17%TYPE);
	
	TYPE gipis031_parlist_type IS RECORD (
		par_id			GIPI_PARLIST.par_id%TYPE,
		line_cd			GIPI_PARLIST.line_cd%TYPE,
		iss_cd			GIPI_PARLIST.iss_cd%TYPE,
		par_yy			GIPI_PARLIST.par_yy%TYPE,
		par_seq_no		GIPI_PARLIST.par_seq_no%TYPE,
		quote_seq_no	GIPI_PARLIST.quote_seq_no%TYPE,
		par_type		GIPI_PARLIST.par_type%TYPE,
		par_status		GIPI_PARLIST.par_status%TYPE,
		assd_no			GIPI_PARLIST.assd_no%TYPE,
		address1		GIPI_PARLIST.address1%TYPE,
		address2		GIPI_PARLIST.address2%TYPE,
		address3		GIPI_PARLIST.address3%TYPE);
		
	TYPE gipis031_wpolbas_type IS RECORD (
        line_cd                GIPI_WPOLBAS.line_cd%TYPE,
        subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        issue_yy            GIPI_WPOLBAS.issue_yy%TYPE,
        pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        renew_no            GIPI_WPOLBAS.renew_no%TYPE,
        endt_iss_cd            GIPI_WPOLBAS.endt_iss_cd%TYPE,
        endt_yy                GIPI_WPOLBAS.endt_yy%TYPE,
        incept_date         GIPI_WPOLBAS.incept_date%TYPE,
        incept_tag          GIPI_WPOLBAS.incept_tag%TYPE,
        expiry_tag          GIPI_WPOLBAS.expiry_tag%TYPE,
        endt_expiry_tag     GIPI_WPOLBAS.endt_expiry_tag%TYPE,
        eff_date            GIPI_WPOLBAS.eff_date%TYPE,
        endt_expiry_date    GIPI_WPOLBAS.endt_expiry_date%TYPE,
        type_cd             GIPI_WPOLBAS.type_cd%TYPE,
        same_polno_sw       GIPI_WPOLBAS.same_polno_sw%TYPE,
        foreign_acc_sw      GIPI_WPOLBAS.foreign_acc_sw%TYPE,
        comp_sw             GIPI_WPOLBAS.comp_sw%TYPE,
        prem_warr_tag       GIPI_WPOLBAS.prem_warr_tag%TYPE,
        old_assd_no         GIPI_WPOLBAS.old_assd_no%TYPE,
        old_address1        GIPI_WPOLBAS.old_address1%TYPE,
        old_address2        GIPI_WPOLBAS.old_address2%TYPE,
        old_address3        GIPI_WPOLBAS.old_address3%TYPE,
        address1            GIPI_WPOLBAS.address1%TYPE,
        address2            GIPI_WPOLBAS.address2%TYPE,
        address3            GIPI_WPOLBAS.address3%TYPE,
        reg_policy_sw       GIPI_WPOLBAS.reg_policy_sw%TYPE,
        co_insurance_sw     GIPI_WPOLBAS.co_insurance_sw%TYPE,
        manual_renew_no     GIPI_WPOLBAS.manual_renew_no%TYPE,
        cred_branch         GIPI_WPOLBAS.cred_branch%TYPE,
        ref_pol_no          GIPI_WPOLBAS.ref_pol_no%TYPE,
        takeup_term            GIPI_WPOLBAS.takeup_term%TYPE,
        booking_mth            GIPI_WPOLBAS.booking_mth%TYPE,
        booking_year        GIPI_WPOLBAS.booking_year%TYPE,
        expiry_date            GIPI_WPOLBAS.expiry_date%TYPE,
        prov_prem_tag        GIPI_WPOLBAS.prov_prem_tag%TYPE,
        prov_prem_pct        GIPI_WPOLBAS.prov_prem_pct%TYPE,
        prorate_flag        GIPI_WPOLBAS.prorate_flag%TYPE,
        pol_flag            GIPI_WPOLBAS.pol_flag%TYPE,
        ann_tsi_amt            GIPI_WPOLBAS.ann_tsi_amt%TYPE,
        ann_prem_amt        GIPI_WPOLBAS.ann_prem_amt%TYPE,
		issue_date			GIPI_WPOLBAS.issue_date%TYPE,
		pack_pol_flag		GIPI_WPOLBAS.pack_pol_flag%TYPE);
        
    TYPE gipis031_wpolbas_type2 IS RECORD (
		line_cd				GIPI_WPOLBAS.line_cd%TYPE,
		subline_cd			GIPI_WPOLBAS.subline_cd%TYPE,
		iss_cd				GIPI_WPOLBAS.iss_cd%TYPE,
		issue_yy			GIPI_WPOLBAS.issue_yy%TYPE,
		pol_seq_no			GIPI_WPOLBAS.pol_seq_no%TYPE,
		renew_no			GIPI_WPOLBAS.renew_no%TYPE,
		endt_iss_cd			GIPI_WPOLBAS.endt_iss_cd%TYPE,
		endt_yy				GIPI_WPOLBAS.endt_yy%TYPE,
		incept_date     	GIPI_WPOLBAS.incept_date%TYPE,
		incept_tag      	GIPI_WPOLBAS.incept_tag%TYPE,
		expiry_tag      	GIPI_WPOLBAS.expiry_tag%TYPE,
		endt_expiry_tag 	GIPI_WPOLBAS.endt_expiry_tag%TYPE,
		eff_date        	GIPI_WPOLBAS.eff_date%TYPE,
		endt_expiry_date	GIPI_WPOLBAS.endt_expiry_date%TYPE,
		type_cd         	GIPI_WPOLBAS.type_cd%TYPE,
		same_polno_sw   	GIPI_WPOLBAS.same_polno_sw%TYPE,
		foreign_acc_sw  	GIPI_WPOLBAS.foreign_acc_sw%TYPE,
		comp_sw         	GIPI_WPOLBAS.comp_sw%TYPE,
		prem_warr_tag   	GIPI_WPOLBAS.prem_warr_tag%TYPE,
		old_assd_no     	GIPI_WPOLBAS.old_assd_no%TYPE,
		old_address1    	GIPI_WPOLBAS.old_address1%TYPE,
		old_address2    	GIPI_WPOLBAS.old_address2%TYPE,
		old_address3    	GIPI_WPOLBAS.old_address3%TYPE,
		address1        	GIPI_WPOLBAS.address1%TYPE,
		address2        	GIPI_WPOLBAS.address2%TYPE,
		address3        	GIPI_WPOLBAS.address3%TYPE,
		reg_policy_sw   	GIPI_WPOLBAS.reg_policy_sw%TYPE,
		co_insurance_sw 	GIPI_WPOLBAS.co_insurance_sw%TYPE,
		manual_renew_no 	GIPI_WPOLBAS.manual_renew_no%TYPE,
		cred_branch     	GIPI_WPOLBAS.cred_branch%TYPE,
		ref_pol_no      	GIPI_WPOLBAS.ref_pol_no%TYPE,
		takeup_term			GIPI_WPOLBAS.takeup_term%TYPE,
		booking_mth			GIPI_WPOLBAS.booking_mth%TYPE,
		booking_year		GIPI_WPOLBAS.booking_year%TYPE,
		expiry_date	        GIPI_WPOLBAS.expiry_date%TYPE,
		prov_prem_tag	    GIPI_WPOLBAS.prov_prem_tag%TYPE,
		prov_prem_pct	    GIPI_WPOLBAS.prov_prem_pct%TYPE,
		prorate_flag	    GIPI_WPOLBAS.prorate_flag%TYPE,
		pol_flag	        GIPI_WPOLBAS.pol_flag%TYPE,
		ann_tsi_amt	        GIPI_WPOLBAS.ann_tsi_amt%TYPE,
		ann_prem_amt		GIPI_WPOLBAS.ann_prem_amt%TYPE,
		issue_date			GIPI_WPOLBAS.issue_date%TYPE,
		pack_pol_flag		GIPI_WPOLBAS.pack_pol_flag%TYPE,
        bank_ref_no         GIPI_WPOLBAS.bank_ref_no%TYPE,
        bancassurance_sw    GIPI_WPOLBAS.bancassurance_sw%TYPE,
        banc_type_cd        GIPI_WPOLBAS.banc_type_cd%TYPE,
        area_cd             GIPI_WPOLBAS.area_cd%TYPE,
        branch_cd           GIPI_WPOLBAS.branch_cd%TYPE,
        manager_cd          GIPI_WPOLBAS.manager_cd%TYPE,
		acct_of_cd          GIPI_WPOLBAS.acct_of_cd%TYPE, --added by steven 11.22.2012
		risk_tag			GIPI_WPOLBAS.risk_tag%TYPE,
		industry_cd			GIPI_WPOLBAS.industry_cd%TYPE,
		region_cd			GIPI_WPOLBAS.region_cd%TYPE,
		place_cd			GIPI_WPOLBAS.place_cd%TYPE,
        mortg_name          GIPI_WPOLBAS.mortg_name%TYPE, -- added by christian 03/04/13
        label_tag           GIPI_WPOLBAS.label_tag%TYPE -- added by Kris 04.11.2014
        );
	
	TYPE gipis031_cancel_records_type IS RECORD (
		endorsement			VARCHAR2(150),
		policy_id			GIPI_POLBASIC.policy_id%TYPE);
	
	TYPE cancel_record_tab IS TABLE OF gipis031_cancel_records_type;
	
	--TYPE RC_GIPI_WENDTTEXT IS REF CURSOR RETURN GIPI_WENDTTEXT%ROWTYPE;
	--TYPE RC_GIPI_WPOLGENIN IS REF CURSOR RETURN GIPI_WPOLGENIN%ROWTYPE;
	--TYPE RC_GIPI_PARLIST IS REF CURSOR RETURN GIPI_PARLIST%ROWTYPE;	
	--TYPE RC_GIPI_WPOLBAS IS REF CURSOR RETURN GIPI_WPOLBAS%ROWTYPE;	
	
	TYPE RC_GIPI_WENDTTEXT_TYPE IS REF CURSOR RETURN gipis031_wendttext_type;
	TYPE RC_GIPI_WPOLGENIN_TYPE IS REF CURSOR RETURN gipis031_wpolgenin_type;
	TYPE RC_GIPI_PARLIST_TYPE IS REF CURSOR RETURN gipis031_parlist_type;	
	TYPE RC_GIPI_WPOLBAS_TYPE IS REF CURSOR RETURN gipis031_wpolbas_type;
	TYPE RC_COI_RECORDS IS REF CURSOR RETURN gipis031_cancel_records_type;
	TYPE RC_ENDT_RECORDS IS REF CURSOR RETURN gipis031_cancel_records_type;
    TYPE RC_GIPI_WPOLBAS_TYPE2 IS REF CURSOR RETURN gipis031_wpolbas_type2;
	
	TYPE RC_GIPI_WPOLGENIN	IS REF CURSOR RETURN GIPI_WPOLGENIN%ROWTYPE;
	TYPE RC_GIPI_WENDTTEXT IS REF CURSOR RETURN GIPI_WENDTTEXT%ROWTYPE;
	TYPE RC_GIPI_WOPEN_POLICY IS REF CURSOR RETURN GIPI_WOPEN_POLICY%ROWTYPE;
	TYPE RC_GIPI_PARLIST IS REF CURSOR RETURN GIPI_PARLIST%ROWTYPE;
	
	TYPE RC_GIPI_WITEM IS REF CURSOR RETURN GIPI_WITEM%ROWTYPE;
	TYPE RC_GIPI_WFIREITM IS REF CURSOR RETURN GIPI_WFIREITM%ROWTYPE;
	TYPE RC_GIPI_WVEHICLE IS REF CURSOR RETURN GIPI_WVEHICLE%ROWTYPE;
	TYPE RC_GIPI_WACCIDENT_ITEM IS REF CURSOR RETURN GIPI_WACCIDENT_ITEM%ROWTYPE;
	TYPE RC_GIPI_WAVIATION_ITEM IS REF CURSOR RETURN GIPI_WAVIATION_ITEM%ROWTYPE;	
	TYPE RC_GIPI_WCARGO IS REF CURSOR RETURN GIPI_WCARGO%ROWTYPE;
	TYPE RC_GIPI_WCASUALTY_ITEM IS REF CURSOR RETURN GIPI_WCASUALTY_ITEM%ROWTYPE;
	TYPE RC_GIPI_WENGG_BASIC IS REF CURSOR RETURN GIPI_WENGG_BASIC%ROWTYPE;
	TYPE RC_GIPI_WITEM_VES IS REF CURSOR RETURN GIPI_WITEM_VES%ROWTYPE;
	TYPE RC_GIPI_WITMPERL IS REF CURSOR RETURN GIPI_WITMPERL%ROWTYPE;
    	
END Gipis031_Ref_Cursor_Pkg;
/


