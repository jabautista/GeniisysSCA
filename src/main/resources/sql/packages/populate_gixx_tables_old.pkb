CREATE OR REPLACE PACKAGE BODY CPI.Populate_Gixx_Tables_OLD AS

PROCEDURE extract_poldoc_record(
		   p_policy_id		GIPI_POLBASIC.policy_id%TYPE,
           v_extract_id    GIXX_POLBASIC.extract_id%TYPE) AS
BEGIN
--extract_gipi_polbas_rec

FOR a IN (SELECT acct_ent_date,       acct_of_cd,           acct_of_cd_sw,
	   	 		 actual_renew_no,     address1,             address2,
	   			 address3,            ann_prem_amt,         ann_tsi_amt,
	   			 assd_no,             auto_renew_flag,		co_insurance_sw,
	   			 cred_branch,         designation,			discount_sw,
	   			 dist_flag,           eff_date,				eis_flag,
	   			 endt_expiry_date,    endt_expiry_tag,		endt_iss_cd,
	   			 endt_seq_no,         endt_type,			endt_yy,
	   			 expiry_date,         expiry_tag,			fleet_print_tag,
	   			 foreign_acc_sw,      incept_date,			incept_tag,
	   			 industry_cd,         invoice_sw,			issue_date,
	   			 issue_yy,			  iss_cd,				label_tag,
	   			 line_cd,			  manual_renew_no,		mortg_name,
	   			 no_of_items,		  old_assd_no,			pack_pol_flag,
	   			 place_cd,			  polendt_printed_cnt,	polendt_printed_date,
	   			 pol_flag,            pol_seq_no,			pool_pol_no,
	   			 prem_amt,            prem_warr_tag,		prorate_flag,
	   			 prov_prem_pct,       prov_prem_tag,		qd_flag,
	   			 ref_open_pol_no,     ref_pol_no,			region_cd,
	   			 reg_policy_sw,       renew_flag,			renew_no,
	   			 short_rt_percent,	  spld_approval,		spld_date,
	   			 spld_flag,           spld_user_id,			subline_cd,
	   			 subline_type_cd,     surcharge_sw,			tsi_amt,
	   			 type_cd,             validate_tag,			with_tariff_sw,
				 old_address1,		  old_address2,			old_address3,
				 policy_id
  			FROM GIPI_POLBASIC
 		   WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLBASIC(
	   acct_ent_date,       acct_of_cd,             acct_of_cd_sw,
	   actual_renew_no,     address1,               address2,
	   address3,            ann_prem_amt,           ann_tsi_amt,
	   assd_no,             auto_renew_flag,		co_insurance_sw,
	   cred_branch,         designation,			discount_sw,
	   dist_flag,           eff_date,				eis_flag,
	   endt_expiry_date,    endt_expiry_tag,		endt_iss_cd,
	   endt_seq_no,         endt_type,				endt_yy,
	   expiry_date,         expiry_tag,				fleet_print_tag,
	   foreign_acc_sw,      incept_date,			incept_tag,
	   industry_cd,         invoice_sw,				issue_date,
	   issue_yy,			iss_cd,					label_tag,
	   line_cd,				manual_renew_no,		mortg_name,
	   no_of_items,			old_assd_no,			pack_pol_flag,
	   place_cd,			polendt_printed_cnt,	polendt_printed_date,
	   pol_flag,            pol_seq_no,				pool_pol_no,
	   prem_amt,            prem_warr_tag,			prorate_flag,
	   prov_prem_pct,       prov_prem_tag,			qd_flag,
	   ref_open_pol_no,     ref_pol_no,				region_cd,
	   reg_policy_sw,       renew_flag,				renew_no,
	   short_rt_percent,	spld_approval,			spld_date,
	   spld_flag,           spld_user_id,			subline_cd,
	   subline_type_cd,     surcharge_sw,			tsi_amt,
	   type_cd,             validate_tag,			with_tariff_sw,
	   old_address1,		old_address2,			old_address3,
	   policy_id,
	   extract_id)
VALUES(
	   a.acct_ent_date,       a.acct_of_cd,             a.acct_of_cd_sw,
	   a.actual_renew_no,     a.address1,               a.address2,
	   a.address3,            a.ann_prem_amt,           a.ann_tsi_amt,
	   a.assd_no,             a.auto_renew_flag,		a.co_insurance_sw,
	   a.cred_branch,         a.designation,			a.discount_sw,
	   a.dist_flag,           a.eff_date,				a.eis_flag,
	   a.endt_expiry_date,    a.endt_expiry_tag,		a.endt_iss_cd,
	   a.endt_seq_no,         a.endt_type,				a.endt_yy,
	   a.expiry_date,         a.expiry_tag,				a.fleet_print_tag,
	   a.foreign_acc_sw,      a.incept_date,			a.incept_tag,
	   a.industry_cd,         a.invoice_sw,				a.issue_date,
	   a.issue_yy,			  a.iss_cd,					a.label_tag,
	   a.line_cd,			  a.manual_renew_no,		a.mortg_name,
	   a.no_of_items,		  a.old_assd_no,			a.pack_pol_flag,
	   a.place_cd,			  a.polendt_printed_cnt,	a.polendt_printed_date,
	   a.pol_flag,            a.pol_seq_no,				a.pool_pol_no,
	   a.prem_amt,            a.prem_warr_tag,			a.prorate_flag,
	   a.prov_prem_pct,       a.prov_prem_tag,			a.qd_flag,
	   a.ref_open_pol_no,     a.ref_pol_no,				a.region_cd,
	   a.reg_policy_sw,       a.renew_flag,				a.renew_no,
	   a.short_rt_percent,	  a.spld_approval,			a.spld_date,
	   a.spld_flag,           a.spld_user_id,			a.subline_cd,
	   a.subline_type_cd,     a.surcharge_sw,			a.tsi_amt,
	   a.type_cd,             a.validate_tag,			a.with_tariff_sw,
	   a.old_address1,		  a.old_address2,			a.old_address3,
	   a.policy_id,
	   v_extract_id);
END LOOP;

--end extract_gipi_polbas_rec

--start_extract_gipi_parlist --rollie10172003
FOR a IN ( SELECT a.line_cd  line_cd,	a.iss_cd     iss_cd        ,
		          a.par_yy   par_yy,	a.par_seq_no par_seq_no,	a.quote_seq_no quote_seq_no,
        	      a.par_type par_type,	a.assign_sw  assign_sw,	    a.par_status   par_status,
		          a.assd_no  assd_no,	a.quote_id   quote_id,	    a.underwriter  underwriter,
		          a.remarks  remarks,	a.address1   address1,	    a.address2     address2,
		          a.address3 address3,	a.load_tag   load_tag,	    a.cpi_rec_no   cpi_rec_no,
	              a.cpi_branch_cd cpi_branch_cd
             FROM GIPI_PARLIST a, GIPI_POLBASIC b
            WHERE b.policy_id = p_policy_id
			  AND a.par_id = b.par_id  ) LOOP

INSERT INTO GIXX_PARLIST(
  	   extract_id,		 		line_cd,			   iss_cd         ,
	   par_yy,					par_seq_no,			   quote_seq_no,
       par_type,				assign_sw,			   par_status,
       assd_no,					quote_id,	 		   underwriter,
       remarks,					address1,			   address2,
       address3,				load_tag,			   cpi_rec_no,
       cpi_branch_cd)
VALUES(
       v_extract_id,	         a.line_cd,	           a.iss_cd         ,
       a.par_yy,		         a.par_seq_no,         a.quote_seq_no,
       a.par_type,		         a.assign_sw,		   a.par_status,
       a.assd_no,     		     a.quote_id,		   a.underwriter,
       a.remarks,		         a.address1,		   a.address2,
       a.address3,		         a.load_tag,		   a.cpi_rec_no,
       a.cpi_branch_cd);
END LOOP;
--end_extract_gipi_parlist --rollie10172003
--begin_extract_gipi_accident_item_rec

FOR a IN (SELECT ac_class_cd,	 	age,				civil_status,
	   	 		 date_of_birth,		destination,		group_print_sw,
	   			 height,			item_no,			level_cd,
	   			 monthly_salary,	no_of_persons,		parent_level_cd,
	   			 position_cd,		salary_grade,		sex,
				 weight
  			FROM GIPI_ACCIDENT_ITEM
 		   WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ACCIDENT_ITEM(
	   ac_class_cd,	 		age,				civil_status,
	   date_of_birth,		destination,		group_print_sw,
	   height,				item_no,			level_cd,
	   monthly_salary,		no_of_persons,		parent_level_cd,
	   position_cd,			salary_grade,		sex,
	   weight,				extract_id)
VALUES(
	   a.ac_class_cd,	 	a.age,				a.civil_status,
	   a.date_of_birth,		a.destination,		a.group_print_sw,
	   a.height,			a.item_no,			a.level_cd,
	   a.monthly_salary,	a.no_of_persons,	a.parent_level_cd,
	   a.position_cd,		a.salary_grade,		a.sex,
	   a.weight,			v_extract_id);
END LOOP;

--end_extract_gipi_accident_item_rec;


--begin_extract_gipi_aviation_item_rec

FOR a IN(SELECT deduct_text,	est_util_hrs,	fixed_wing,
	   			geog_limit,		item_no,		prev_util_hrs,
				purpose,		qualification,	rec_flag,
				rotor,			total_fly_time, vessel_cd
  FROM GIPI_AVIATION_ITEM
 WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_AVIATION_ITEM(
	   deduct_text,		est_util_hrs,	fixed_wing,
	   geog_limit,		item_no,		prev_util_hrs,
	   purpose,			qualification,	rec_flag,
	   rotor,			total_fly_time,	vessel_cd,
	   extract_id)
VALUES(
	   a.deduct_text,	a.est_util_hrs,	  a.fixed_wing,
	   a.geog_limit,	a.item_no,		  a.prev_util_hrs,
	   a.purpose,		a.qualification,  a.rec_flag,
	   a.rotor,			a.total_fly_time, a.vessel_cd,
	   v_extract_id);
END LOOP;

--end_extract_gipi_aviation_item_rec


--begin_extract_gipi_bank_schedule_rec

FOR a IN(SELECT bank,		   		bank_address,		bank_eff_date,
	   			bank_endt_seq_no,	bank_issue_yy,		bank_iss_cd,
	   			bank_item_no,		bank_line_cd,		bank_pol_seq_no,
	   			bank_renew_no,		bank_subline_cd,	cash_in_transit,
	   			cash_in_vault,		include_tag,		remarks
  		   FROM GIPI_BANK_SCHEDULE
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_BANK_SCHEDULE(
	   bank,		   		bank_address,		bank_eff_date,
	   bank_endt_seq_no,	bank_issue_yy,		bank_iss_cd,
	   bank_item_no,		bank_line_cd,		bank_pol_seq_no,
	   bank_renew_no,		bank_subline_cd,	cash_in_transit,
	   cash_in_vault,		include_tag,		remarks,
	   extract_id)
VALUES(
	   a.bank,		   		a.bank_address,		a.bank_eff_date,
	   a.bank_endt_seq_no,	a.bank_issue_yy,	a.bank_iss_cd,
	   a.bank_item_no,		a.bank_line_cd,		a.bank_pol_seq_no,
	   a.bank_renew_no,		a.bank_subline_cd,	a.cash_in_transit,
	   a.cash_in_vault,		a.include_tag,		a.remarks,
	   v_extract_id);
END LOOP;

--end_extract_gipi_bank_schedule_rec


--begin_extract_gipi_beneficiary_rec

FOR a IN(SELECT adult_sw,	   		age,			    beneficiary_addr,
	   			beneficiary_name,	beneficiary_no,		civil_status,
	   			date_of_birth,		delete_sw,			item_no,
	   			position_cd,		relation,			remarks,
				sex
  		   FROM GIPI_BENEFICIARY
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_BENEFICIARY(
	   adult_sw,	   		age,			    beneficiary_addr,
	   beneficiary_name,	beneficiary_no,		civil_status,
	   date_of_birth,		delete_sw,			item_no,
	   position_cd,			relation,			remarks,
	   sex,					extract_id)
VALUES(
	   a.adult_sw,	   		a.age,			    a.beneficiary_addr,
	   a.beneficiary_name,	a.beneficiary_no,	a.civil_status,
	   a.date_of_birth,		a.delete_sw,		a.item_no,
	   a.position_cd,		a.relation,			a.remarks,
	   a.sex,				v_extract_id);
END LOOP;

--end_extract_gipi_beneficiary_rec

--begin_extract_gipi_bond_basic

FOR a IN(SELECT coll_flag, clause_type, obligee_no, prin_id, val_period_unit,
                val_period, np_no, contract_dtl, contract_date, co_prin_sw,
				waiver_limit, indemnity_text, bond_dtl, endt_eff_date, remarks
  		   FROM GIPI_BOND_BASIC
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_BOND_BASIC(
	   extract_id, obligee_no, prin_id, coll_flag, clause_type, val_period_unit, val_period,
	   policy_id, np_no, contract_dtl, contract_date, co_prin_sw, waiver_limit, indemnity_text,
	   bond_dtl, endt_eff_date, remarks)
VALUES(
	   v_extract_id, a.obligee_no, a.prin_id, a.coll_flag, a.clause_type, a.val_period_unit,
	   a.val_period, p_policy_id, a.np_no, a.contract_dtl, a.contract_date, a.co_prin_sw,
	   a.waiver_limit, a.indemnity_text, a.bond_dtl, a.endt_eff_date, a.remarks);
END LOOP;

--end_extract_gipi_bond_basic

--begin_extract_gipi_cargo_rec

FOR a IN(SELECT bl_awb,	   	 			cargo_class_cd,		cargo_type,
	   			deduct_text,		   	destn,			    eta,
	   			etd,				   	geog_cd,			item_no,
	   			lc_no,			   		origin,			    pack_method,
	   			print_tag,		    	rec_flag,			tranship_destination,
				tranship_origin,		vessel_cd,			voyage_no
  		   FROM GIPI_CARGO
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CARGO(
	   bl_awb,			   	 	cargo_class_cd,		cargo_type,
	   deduct_text,		   		destn,			    eta,
	   etd,				   		geog_cd,			item_no,
	   lc_no,			   		origin,			    pack_method,
	   print_tag,		    	rec_flag,			tranship_destination,
	   tranship_origin,			vessel_cd,			voyage_no,
	   extract_id)
VALUES(
	   a.bl_awb,			  	a.cargo_class_cd,	a.cargo_type,
	   a.deduct_text,		 	a.destn,		    a.eta,
	   a.etd,				 	a.geog_cd,			a.item_no,
	   a.lc_no,			   		a.origin,			a.pack_method,
	   a.print_tag,				a.rec_flag,			a.tranship_destination,
	   a.tranship_origin,		a.vessel_cd,		a.voyage_no,
	   v_extract_id);
END LOOP;

--end_extract_gipi_cargo_rec


--begin_extract_gipi_cargo_carrier_rec

FOR a IN(SELECT delete_sw,	destn,		eta,
	   			etd,		item_no,	origin,
				vessel_cd,	voy_limit,	vessel_limit_of_liab

  		   FROM GIPI_CARGO_CARRIER
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CARGO_CARRIER(
	   delete_sw,	destn,		eta,
	   etd,			item_no,	origin,
	   vessel_cd,	voy_limit,	vessel_limit_of_liab,
	   extract_id)
VALUES(
	   a.delete_sw,   a.destn,		 a.eta,
	   a.etd,		  a.item_no,	 a.origin,
	   a.vessel_cd,   a.voy_limit,	 a.vessel_limit_of_liab,
	   v_extract_id);
END LOOP;

--end_extract_gipi_cargo_carrier_rec;


--begin_extract_gipi_casualty_item_rec

FOR a IN(SELECT capacity_cd,		    conveyance_info,		   interest_on_premises,
	   			item_no,				limit_of_liability,	       LOCATION,
	   			property_no,			property_no_type,		   section_line_cd,
				section_or_hazard_cd,   section_or_hazard_info,	   section_subline_cd
  		   FROM GIPI_CASUALTY_ITEM
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CASUALTY_ITEM(
	   capacity_cd,			    conveyance_info,		   interest_on_premises,
	   item_no,					limit_of_liability,	       LOCATION,
	   property_no,			    property_no_type,		   section_line_cd,
	   section_or_hazard_cd,    section_or_hazard_info,    section_subline_cd,
	   extract_id)
VALUES(
	   a.capacity_cd,		    a.conveyance_info,		   a.interest_on_premises,
	   a.item_no,				a.limit_of_liability,	   a.LOCATION,
	   a.property_no,			a.property_no_type,		   a.section_line_cd,
	   a.section_or_hazard_cd,  a.section_or_hazard_info,  a.section_subline_cd,
	   v_extract_id);
END LOOP;

--end_extract_gipi_casualty_item_rec


--begin_extract_gipi_casualty_personnel_rec

FOR a IN(SELECT amount_covered,		capacity_cd,		delete_sw,
	   			include_tag,		item_no,			NAME,
	   			personnel_no,		remarks
  		   FROM GIPI_CASUALTY_PERSONNEL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CASUALTY_PERSONNEL(
	   amount_covered,		capacity_cd,		delete_sw,
	   include_tag,			item_no,			NAME,
	   personnel_no,		remarks,			extract_id)
VALUES(
	   a.amount_covered,	a.capacity_cd,		a.delete_sw,
	   a.include_tag,		a.item_no,			a.NAME,
	   a.personnel_no,		a.remarks,			v_extract_id);
END LOOP;

--end_extract_gipi_casualty_personnel_rec


--begin_extract_gipi_comm_invoice_rec

FOR a IN(SELECT bond_rate,	   	   commission_amt,		default_intm,
	   			gacc_tran_id,	   intrmdry_intm_no,    iss_cd,
	   			parent_intm_no,	   premium_amt,			prem_seq_no,
				share_percentage,  wholding_tax
  		   FROM GIPI_COMM_INVOICE
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_COMM_INVOICE(
	   bond_rate,	   	   commission_amt,		default_intm,
	   gacc_tran_id,	   intrmdry_intm_no,    iss_cd,
	   parent_intm_no,	   premium_amt,			prem_seq_no,
	   share_percentage,    wholding_tax,		extract_id)
VALUES(
	   a.bond_rate,	   	   a.commission_amt,	a.default_intm,
	   a.gacc_tran_id,	   a.intrmdry_intm_no,  a.iss_cd,
	   a.parent_intm_no,   a.premium_amt,		a.prem_seq_no,
	   a.share_percentage,  a.wholding_tax,		v_extract_id);
END LOOP;

--end_extract_gipi_comm_invoice_rec


--begin_extract_gipi_comm_inv_peril_rec

FOR a IN(SELECT commission_amt, 	commission_rt,		intrmdry_intm_no,
	   			iss_cd,				peril_cd,			premium_amt,
				prem_seq_no,		wholding_tax
  		   FROM GIPI_COMM_INV_PERIL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_COMM_INV_PERIL(
	   commission_amt, 		commission_rt,		intrmdry_intm_no,
	   iss_cd,				peril_cd,			premium_amt,
	   prem_seq_no,			wholding_tax,		extract_id)
VALUES(
	   a.commission_amt, 		a.commission_rt,	a.intrmdry_intm_no,
	   a.iss_cd,				a.peril_cd,			a.premium_amt,
	   a.prem_seq_no,			a.wholding_tax,		v_extract_id);
END LOOP;

--end_extract_gipi_comm_inv_peril_rec


--begin_extract_gipi_cosigntry_rec

FOR a IN(SELECT assd_no,	   bonds_flag,	   bonds_ri_flag,
	   			cosign_id,	   indem_flag,	   policy_id
  		   FROM GIPI_COSIGNTRY
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_COSIGNTRY(
	   assd_no,		   bonds_flag,	   bonds_ri_flag,
	   cosign_id,	   indem_flag,	   extract_id)
VALUES(
	   a.assd_no,	   a.bonds_flag,	   a.bonds_ri_flag,
	   a.cosign_id,	   a.indem_flag,	   v_extract_id);
END LOOP;

--end_extract_gipi_cosigntry_rec


--begin_extract_gipi_co_insurer_rec

FOR a IN(SELECT co_ri_cd,	 	co_ri_prem_amt,		co_ri_shr_pct,
	   			co_ri_tsi_amt
  		   FROM GIPI_CO_INSURER
-- 		  WHERE par_id  = p_policy_id)LOOP  edited by rollie 10172003
          WHERE policy_id = p_policy_id) LOOP

INSERT INTO GIXX_CO_INSURER(
	   co_ri_cd,	 	co_ri_prem_amt,		co_ri_shr_pct,
	   co_ri_tsi_amt,	extract_id)
VALUES(
	   a.co_ri_cd,	 	a.co_ri_prem_amt,	a.co_ri_shr_pct,
	   a.co_ri_tsi_amt,	v_extract_id);
END LOOP;

--end_extract_gipi_co_insurer_rec


--begin_extract_gipi_deductibles_rec

FOR a IN(SELECT deductible_amt,		deductible_rt,		deductible_text,
	   			ded_deductible_cd,	ded_line_cd,		ded_subline_cd,
	   			item_no,			peril_cd
  		   FROM GIPI_DEDUCTIBLES
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_DEDUCTIBLES(
	   deductible_amt,		deductible_rt,		deductible_text,
	   ded_deductible_cd,	ded_line_cd,		ded_subline_cd,
	   item_no,				peril_cd,			extract_id)
VALUES(
	   a.deductible_amt,	a.deductible_rt,	a.deductible_text,
	   a.ded_deductible_cd,	a.ded_line_cd,		a.ded_subline_cd,
	   a.item_no,			a.peril_cd,			v_extract_id);
END LOOP;

--end_extract_gipi_deductibles_rec


--begin_extract_gipi_endttext_rec

FOR a IN(SELECT endt_tax,		 endt_text,		 endt_text01,
	   			endt_text02,	 endt_text03,	 endt_text04,
	   			endt_text05,	 endt_text06,	 endt_text07,
	   			endt_text08,	 endt_text09,	 endt_text10,
	   			endt_text11,	 endt_text12,	 endt_text13,
	   			endt_text14,	 endt_text15,	 endt_text16,
	   			endt_text17
  		   FROM GIPI_ENDTTEXT
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ENDTTEXT(
	   endt_tax,		 endt_text,		 endt_text01,
	   endt_text02,		 endt_text03,	 endt_text04,
	   endt_text05,		 endt_text06,	 endt_text07,
	   endt_text08,		 endt_text09,	 endt_text10,
	   endt_text11,		 endt_text12,	 endt_text13,
	   endt_text14,		 endt_text15,	 endt_text16,
	   endt_text17,		 extract_id)
VALUES(
	   a.endt_tax,		 a.endt_text,	 a.endt_text01,
	   a.endt_text02,	 a.endt_text03,	 a.endt_text04,
	   a.endt_text05,	 a.endt_text06,	 a.endt_text07,
	   a.endt_text08,	 a.endt_text09,	 a.endt_text10,
	   a.endt_text11,	 a.endt_text12,	 a.endt_text13,
	   a.endt_text14,	 a.endt_text15,	 a.endt_text16,
	   a.endt_text17,	 v_extract_id);
END LOOP;

--end_extract_gipi_endttext_rec


--begin_extract_gipi_engg_basic_rec

FOR a IN(SELECT construct_end_date,	  construct_start_date,		contract_proj_buss_title,
	   			engg_basic_infonum,	  maintain_end_date,	    maintain_start_date,
	   			mbi_policy_no,		  site_location,			testing_end_date,
	   			testing_start_date,	  time_excess,				weeks_test
  		   FROM GIPI_ENGG_BASIC
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ENGG_BASIC(
	   construct_end_date,	  construct_start_date,		contract_proj_buss_title,
	   engg_basic_infonum,	  maintain_end_date,	    maintain_start_date,
	   mbi_policy_no,		  site_location,			testing_end_date,
	   testing_start_date,	  time_excess,				weeks_test,
	   extract_id)
VALUES(
	   a.construct_end_date,  a.construct_start_date,	a.contract_proj_buss_title,
	   a.engg_basic_infonum,  a.maintain_end_date,	    a.maintain_start_date,
	   a.mbi_policy_no,		  a.site_location,			a.testing_end_date,
	   a.testing_start_date,  a.time_excess,			a.weeks_test,
	   v_extract_id);
END LOOP;

--end_extract_gipi_engg_basic_rec


--begin_extract_gipi_fireitem_rec

FOR a IN(SELECT assignee,		   block_id,			   block_no,
	   			construction_cd,   construction_remarks,   district_no,
	   			eq_zone,		   flood_zone,			   front,
	   			fr_item_type,	   item_no,				   LEFT,
				loc_risk1,		   loc_risk2,			   loc_risk3,
				occupancy_cd,	   occupancy_remarks,	   rear,
				RIGHT,			   tarf_cd,				   tariff_zone,
				typhoon_zone
  		   FROM GIPI_FIREITEM
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_FIREITEM(
	   assignee,		   block_id,			   block_no,
	   construction_cd,	   construction_remarks,   district_no,
	   eq_zone,			   flood_zone,			   front,
	   fr_item_type,	   item_no,				   LEFT,
	   loc_risk1,		   loc_risk2,			   loc_risk3,
	   occupancy_cd,	   occupancy_remarks,	   rear,
	   RIGHT,			   tarf_cd,				   tariff_zone,
	   typhoon_zone,	   extract_id)
VALUES(
	   a.assignee,		   a.block_id,			   a.block_no,
	   a.construction_cd,  a.construction_remarks, a.district_no,
	   a.eq_zone,		   a.flood_zone,		   a.front,
	   a.fr_item_type,	   a.item_no,			   a.LEFT,
	   a.loc_risk1,		   a.loc_risk2,			   a.loc_risk3,
	   a.occupancy_cd,	   a.occupancy_remarks,	   a.rear,
	   a.RIGHT,			   a.tarf_cd,			   a.tariff_zone,
	   a.typhoon_zone,	   v_extract_id);
END LOOP;

--end_extract_gipi_fireitem_rec


--begin_extract_gipi_grouped_items_rec

FOR a IN(SELECT age,			 nvl(amount_coverage,tsi_amt) amount_coverage,	civil_status,
	   			date_of_birth,	 delete_sw,		 	grouped_item_no,
	   			group_cd,		 include_tag,		grouped_item_title,
	   			item_no,		 line_cd,			position_cd,
				remarks,		 salary,			salary_grade,
				sex,			 subline_cd
  		   FROM GIPI_GROUPED_ITEMS
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_GROUPED_ITEMS(
	   age,				 amount_coverage,	civil_status,
	   date_of_birth,	 delete_sw,		 	grouped_item_no,
	   group_cd,		 include_tag,		grouped_item_title,
	   item_no,			 line_cd,			position_cd,
	   remarks,			 salary,			salary_grade,
	   sex,				 subline_cd,		extract_id)
VALUES(
	   a.age,			 a.amount_coverage,	a.civil_status,
	   a.date_of_birth,	 a.delete_sw,	 	a.grouped_item_no,
	   a.group_cd,		 a.include_tag,		a.grouped_item_title,
	   a.item_no,		 a.line_cd,			a.position_cd,
	   a.remarks,		 a.salary,			a.salary_grade,
	   a.sex,			 a.subline_cd,		v_extract_id);
END LOOP;

--end_extract_gipi_grouped_items_rec


--begin_extract_gipi_grp_items_beneficiary_rec

FOR a IN(SELECT age,			  beneficiary_addr,		beneficiary_name,
	   			beneficiary_no,	  civil_status,			date_of_birth,
	   			grouped_item_no,  item_no,				relation,
				sex
  		   FROM GIPI_GRP_ITEMS_BENEFICIARY
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_GRP_ITEMS_BENEFICIARY(
	   age,			      beneficiary_addr,		beneficiary_name,
	   beneficiary_no,	  civil_status,			date_of_birth,
	   grouped_item_no,	  item_no,				relation,
	   sex,				  extract_id)
VALUES(
	   a.age,			      a.beneficiary_addr,		a.beneficiary_name,
	   a.beneficiary_no,	  a.civil_status,			a.date_of_birth,
	   a.grouped_item_no,	  a.item_no,				a.relation,
	   a.sex,				  v_extract_id);
END LOOP;

--end_extract_gipi_grp_items_beneficiary_rec


--begin_extract_gipi_invoice_rec

FOR a IN(SELECT acct_ent_date,	 	   approval_cd,		bond_rate,
	   			bond_tsi_amt,	 	   card_name,		card_no,
	   			currency_cd,		   currency_rt,		due_date,
	   			expiry_date,		   insured,			invoice_printed_cnt,
	   			invoice_printed_date,  iss_cd,			item_grp,
	   			last_upd_date,		   notarial_fee,	other_charges,
	   			payt_terms,			   pay_type,		policy_currency,
	   			prem_amt,			   prem_seq_no,		property,
	   			ref_inv_no,			   remarks,			ri_comm_amt,
	   			tax_amt
  FROM GIPI_INVOICE
 WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_INVOICE(
	   acct_ent_date,	 	   approval_cd,		bond_rate,
	   bond_tsi_amt,	 	   card_name,		card_no,
	   currency_cd,		 	   currency_rt,		due_date,
	   expiry_date,		 	   insured,			invoice_printed_cnt,
	   invoice_printed_date,   iss_cd,			item_grp,
	   last_upd_date,		   notarial_fee,	other_charges,
	   payt_terms,			   pay_type,		policy_currency,
	   prem_amt,			   prem_seq_no,		property,
	   ref_inv_no,			   remarks,			ri_comm_amt,
	   tax_amt,				   extract_id)
VALUES(
	   a.acct_ent_date,	 	   a.approval_cd,	a.bond_rate,
	   a.bond_tsi_amt,	 	   a.card_name,		a.card_no,
	   a.currency_cd,		   a.currency_rt,	a.due_date,
	   a.expiry_date,		   a.insured,		a.invoice_printed_cnt,
	   a.invoice_printed_date, a.iss_cd,		a.item_grp,
	   a.last_upd_date,		   a.notarial_fee,	a.other_charges,
	   a.payt_terms,		   a.pay_type,		a.policy_currency,
	   a.prem_amt,			   a.prem_seq_no,	a.property,
	   a.ref_inv_no,		   a.remarks,		a.ri_comm_amt,
	   a.tax_amt,			   v_extract_id);
END LOOP;

--end_extract_gipi_invoice_rec


--begin_extract_gipi_invperil_rec

FOR a IN(SELECT x.iss_cd,	  x.item_grp,		x.peril_cd,
	   			x.prem_amt,	  x.prem_seq_no,	x.ri_comm_amt,
	   			x.ri_comm_rt, x.tsi_amt
  		   FROM GIPI_INVPERIL x,
		   		GIPI_INVOICE  y
 		  WHERE x.iss_cd 	  = y.iss_cd
		    AND x.prem_seq_no = y.prem_seq_no
			AND y.policy_id   = p_policy_id)LOOP

INSERT INTO GIXX_INVPERIL(
	   iss_cd,		  item_grp,		   peril_cd,
	   prem_amt,	  prem_seq_no,	   ri_comm_amt,
	   ri_comm_rt,	  tsi_amt,		   extract_id)
VALUES(
	   a.iss_cd,	  a.item_grp,		a.peril_cd,
	   a.prem_amt,	  a.prem_seq_no,	a.ri_comm_amt,
	   a.ri_comm_rt,  a.tsi_amt,		v_extract_id);
END LOOP;

--end_extract_gipi_invperil_rec


--begin_extract_gipi_inv_tax_rec

FOR a IN(SELECT x.iss_cd,		   x.item_grp,		x.fixed_tax_allocation,
	   			x.line_cd,		   x.prem_seq_no,	x.rate,
	   			x.tax_allocation,  x.tax_amt,		x.tax_cd,
	   			x.tax_id
  		   FROM GIPI_INV_TAX x,
  	   	   		GIPI_INVOICE y
 		  WHERE x.iss_cd 	  = y.iss_cd
   		    AND x.prem_seq_no = y.prem_seq_no
   			AND y.policy_id   = p_policy_id)LOOP

INSERT INTO GIXX_INV_TAX(
	   iss_cd,			   item_grp,		fixed_tax_allocation,
	   line_cd,			   prem_seq_no,		rate,
	   tax_allocation,	   tax_amt,			tax_cd,
	   tax_id,			   extract_id)
VALUES(
	   a.iss_cd,			a.item_grp,			a.fixed_tax_allocation,
	   a.line_cd,			a.prem_seq_no,		a.rate,
	   a.tax_allocation,	a.tax_amt,			a.tax_cd,
	   a.tax_id,			v_extract_id);
END LOOP;

--end_extract_gipi_inv_tax_rec


--begin_extract_gipi_item_rec

FOR a IN(SELECT ann_prem_amt,	       ann_tsi_amt,		      changed_tag,
	   			comp_sw,			   coverage_cd,			  currency_cd,
	   			currency_rt,		   discount_sw,		  	  from_date,
	   			group_cd,			   item_desc,		  	  item_desc2,
	   			item_grp,			   item_no,			      item_title,
	   			mc_coc_printed_cnt,	   mc_coc_printed_date,	  other_info,
	   			pack_line_cd,		   pack_subline_cd,		  prem_amt,
	   			prorate_flag,		   rec_flag,			  region_cd,
	   			short_rt_percent,	   revrs_bndr_print_date, surcharge_sw,
	   			TO_DATE,			   tsi_amt,               risk_no,
				risk_item_no
  		   FROM GIPI_ITEM
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ITEM(
	   ann_prem_amt,	       ann_tsi_amt,		      	  changed_tag,
	   comp_sw,			       coverage_cd,			  	  currency_cd,
	   currency_rt,			   discount_sw,		  	  	  from_date,
	   group_cd,			   item_desc,		  	  	  item_desc2,
	   item_grp,			   item_no,			      	  item_title,
	   mc_coc_printed_cnt,	   mc_coc_printed_date,	  	  other_info,
	   pack_line_cd,		   pack_subline_cd,		  	  prem_amt,
	   prorate_flag,		   rec_flag,			  	  region_cd,
	   short_rt_percent,	   revrs_bndr_print_date, 	  surcharge_sw,
	   TO_DATE,				   tsi_amt,				  	  extract_id,
	   risk_no,                risk_item_no)
VALUES(
	   a.ann_prem_amt,	       a.ann_tsi_amt,		      a.changed_tag,
	   a.comp_sw,			   a.coverage_cd,			  a.currency_cd,
	   a.currency_rt,		   a.discount_sw,		  	  a.from_date,
	   a.group_cd,			   a.item_desc,		  	  	  a.item_desc2,
	   a.item_grp,			   a.item_no,			      a.item_title,
	   a.mc_coc_printed_cnt,   a.mc_coc_printed_date,	  a.other_info,
	   a.pack_line_cd,		   a.pack_subline_cd,		  a.prem_amt,
	   a.prorate_flag,		   a.rec_flag,			  	  a.region_cd,
	   a.short_rt_percent,	   a.revrs_bndr_print_date,   a.surcharge_sw,
	   a.TO_DATE,			   a.tsi_amt,				  v_extract_id,
	   a.risk_no,              a.risk_item_no);
END LOOP;

--end_extract_gipi_item_rec


--begin_extract_gipi_item_ves_rec

FOR a IN(SELECT deduct_text,	  dry_date,		  dry_place,
	   			geog_limit,		  item_no,		  rec_flag,
	   			vessel_cd
  		   FROM GIPI_ITEM_VES
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ITEM_VES(
	   deduct_text,		  dry_date,		  dry_place,
	   geog_limit,		  item_no,		  rec_flag,
	   vessel_cd,	  	  extract_id)
VALUES(
	   a.deduct_text,	  a.dry_date,	  a.dry_place,
	   a.geog_limit,	  a.item_no,	  a.rec_flag,
	   a.vessel_cd,	  	  v_extract_id);
END LOOP;

--end_extract_gipi_item_ves_rec


--begin_extract_gipi_itmperil_rec

FOR a IN(SELECT ann_prem_amt,	ann_tsi_amt,	   as_charge_sw,
	   			comp_rem,		discount_sw,	   item_no,
	   			line_cd,		peril_cd,		   prem_amt,
	   			prem_rt,		prt_flag,		   rec_flag,
	   			ri_comm_amt,	ri_comm_rate,	   surcharge_sw,
	   			tarf_cd,		tsi_amt
  		   FROM GIPI_ITMPERIL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ITMPERIL(
	   ann_prem_amt,	ann_tsi_amt,	   as_charge_sw,
	   comp_rem,		discount_sw,	   item_no,
	   line_cd,			peril_cd,		   prem_amt,
	   prem_rt,		   	prt_flag,		   rec_flag,
	   ri_comm_amt,	    ri_comm_rate,	   surcharge_sw,
	   tarf_cd,			tsi_amt,		   extract_id)
VALUES(
	   a.ann_prem_amt,	a.ann_tsi_amt,	   a.as_charge_sw,
	   a.comp_rem,		a.discount_sw,	   a.item_no,
	   a.line_cd,		a.peril_cd,		   a.prem_amt,
	   a.prem_rt,	    a.prt_flag,		   a.rec_flag,
	   a.ri_comm_amt,   a.ri_comm_rate,	   a.surcharge_sw,
	   a.tarf_cd,		a.tsi_amt,		   v_extract_id);
END LOOP;

--end_extract_gipi_itmperil_rec


--begin_extract_gipi_lim_liab_rec

FOR a IN(SELECT currency_cd,		  currency_rt,		liab_cd,
	   			limit_liability,	  line_cd
  		   FROM GIPI_LIM_LIAB
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_LIM_LIAB(
	   currency_cd,		  currency_rt,		liab_cd,
	   limit_liability,	  line_cd,			extract_id)
VALUES(
	   a.currency_cd,		a.currency_rt,	a.liab_cd,
	   a.limit_liability,	a.line_cd,		v_extract_id);
END LOOP;

--end_extract_gipi_lim_liab_rec


--begin_extract_gipi_location_rec

FOR a IN(SELECT item_no,	province_cd,	region_cd
  	  	   FROM GIPI_LOCATION
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_LOCATION(
	   item_no,		province_cd,	region_cd,	extract_id)
VALUES(
	   a.item_no,	a.province_cd,	a.region_cd,	v_extract_id);
END LOOP;

--end_extract_gipi_location_rec


--begin_extract_gipi_main_co_ins_rec

FOR a IN(SELECT prem_amt,	tsi_amt
  	  	   FROM GIPI_MAIN_CO_INS
		  WHERE policy_id = p_policy_id)LOOP
 		  --WHERE par_id = p_policy_id)LOOP --edited by rollie 10172003

INSERT INTO GIXX_MAIN_CO_INS(
	   prem_amt,	tsi_amt,	extract_id)
VALUES(
	   a.prem_amt,	a.tsi_amt,	v_extract_id);
END LOOP;

--end_extract_gipi_main_co_ins_rec


--begin_extract_gipi_mcacc_rec

FOR a IN(SELECT accessory_cd,	acc_amt,	delete_sw,
	   			item_no
  		   FROM GIPI_MCACC
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_MCACC(
	   accessory_cd,	acc_amt,		delete_sw,
	   item_no,			extract_id)
VALUES(
	   a.accessory_cd,	a.acc_amt,		a.delete_sw,
	   a.item_no,		v_extract_id);
END LOOP;

--end_extract_gipi_mcacc_rec


--begin_extract_gipi_mortgagee_rec

FOR a IN(SELECT amount,		   delete_sw,		iss_cd,
	   			item_no,	   mortg_cd,		remarks
  		   FROM GIPI_MORTGAGEE
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_MORTGAGEE(
	   amount,		   delete_sw,		iss_cd,
	   item_no,		   mortg_cd,		remarks,
	   extract_id)
VALUES(
	   a.amount,		   a.delete_sw,		a.iss_cd,
	   a.item_no,		   a.mortg_cd,		a.remarks,
	   v_extract_id);
END LOOP;

--end_extract_gipi_mortgagee_rec


--begin_extract_gipi_open_cargo_rec

FOR a IN(SELECT cargo_class_cd,		geog_cd,	rec_flag
	  	   FROM GIPI_OPEN_CARGO
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_CARGO(
	   cargo_class_cd,		geog_cd,		rec_flag,		extract_id)
VALUES(
	   a.cargo_class_cd,	a.geog_cd,		a.rec_flag,		v_extract_id);
END LOOP;

--end_extract_gipi_open_cargo_rec


--begin_extract_gipi_open_liab_rec

FOR a IN(SELECT currency_cd,		currency_rt,		geog_cd,
	   			limit_liability,	multi_geog_tag,		prem_tag,
				rec_flag,			voy_limit,			with_invoice_tag
  		   FROM GIPI_OPEN_LIAB
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_LIAB(
	   currency_cd,		    currency_rt,		geog_cd,
	   limit_liability,		multi_geog_tag,		prem_tag,
	   rec_flag,			voy_limit,			with_invoice_tag,
	   extract_id)
VALUES(
	   a.currency_cd,		a.currency_rt,		a.geog_cd,
	   a.limit_liability,	a.multi_geog_tag,	a.prem_tag,
	   a.rec_flag,			a.voy_limit,		a.with_invoice_tag,
	   v_extract_id);
END LOOP;

--end_extract_gipi_open_liab_rec


--begin_extract_gipi_open_peril_rec

FOR a IN(SELECT geog_cd,		line_cd,	peril_cd,
	   		  	prem_rate,		rec_flag,	remarks,
	   		  	with_invoice_tag
  		   FROM GIPI_OPEN_PERIL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_PERIL(
	   geog_cd,			  line_cd,		peril_cd,
	   prem_rate,	      rec_flag,		remarks,
	   with_invoice_tag,  extract_id)
VALUES(
	   a.geog_cd,			a.line_cd,		a.peril_cd,
	   a.prem_rate,	      	a.rec_flag,		a.remarks,
	   a.with_invoice_tag,  v_extract_id);
END LOOP;

--end_extract_gipi_open_peril_rec


--begin_extract_gipi_open_policy_rec

FOR a IN(SELECT decltn_no,		  eff_date,		    line_cd,
	   			op_issue_yy,	  op_iss_cd,		op_pol_seqno,
	   			op_renew_no,	  op_subline_cd
  		   FROM GIPI_OPEN_POLICY
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_POLICY(
	   decltn_no,		  eff_date,		    line_cd,
	   op_issue_yy,		  op_iss_cd,		op_pol_seqno,
	   op_renew_no,		  op_subline_cd,	extract_id)
VALUES(
	   a.decltn_no,		  a.eff_date,		a.line_cd,
	   a.op_issue_yy,	  a.op_iss_cd,		a.op_pol_seqno,
	   a.op_renew_no,	  a.op_subline_cd,	v_extract_id);
END LOOP;

--end_extract_gipi_open_policy_rec





--begin_extract_gipi_orig_comm_invoice_rec
--check_me
FOR a IN(SELECT commission_amt, 	intrmdry_intm_no,	iss_cd,
	   			item_grp,			premium_amt,		prem_seq_no,
	   			share_percentage,	wholding_tax
  		   FROM GIPI_ORIG_COMM_INVOICE
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INVOICE(
	   commission_amt, 		intrmdry_intm_no,	iss_cd,
	   item_grp,			premium_amt,		prem_seq_no,
	   share_percentage,	wholding_tax,		extract_id)
VALUES(
	   a.commission_amt, 	a.intrmdry_intm_no,	a.iss_cd,
	   a.item_grp,			a.premium_amt,		a.prem_seq_no,
	   a.share_percentage,	a.wholding_tax,		v_extract_id);
END LOOP;

--end_extract_gipi_orig_comm_invoice_rec


--begin_extract_gipi_orig_comm_inv_peril_rec
--check_me
FOR a IN(SELECT commission_amt, 	commission_rt,		intrmdry_intm_no,
	   			iss_cd,				item_grp,			peril_cd,
	   			premium_amt,		prem_seq_no,		wholding_tax
  		   FROM GIPI_ORIG_COMM_INV_PERIL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INV_PERIL(
	   commission_amt, 		commission_rt,		intrmdry_intm_no,
	   iss_cd,				item_grp,			peril_cd,
	   premium_amt,			prem_seq_no,		wholding_tax,
	   extract_id)
VALUES(
	   a.commission_amt, 	a.commission_rt,	a.intrmdry_intm_no,
	   a.iss_cd,			a.item_grp,			a.peril_cd,
	   a.premium_amt,		a.prem_seq_no,		a.wholding_tax,
	   v_extract_id);
END LOOP;

--end_extract_gipi_orig_comm_inv_peril_rec


--begin_extract_gipi_orig_invoice_rec
--check_me
FOR a IN(SELECT currency_cd,		currency_rt,	insured,
	   			iss_cd,				item_grp,		other_charges,
	   			policy_currency,	prem_amt,		prem_seq_no,
	   			property,			ref_inv_no,		remarks,
	   			ri_comm_amt,		tax_amt
  		   FROM GIPI_ORIG_INVOICE
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_INVOICE(
	   currency_cd,			currency_rt,		insured,
	   iss_cd,				item_grp,			other_charges,
	   policy_currency,		prem_amt,			prem_seq_no,
	   property,			ref_inv_no,			remarks,
	   ri_comm_amt,			tax_amt,			extract_id)
VALUES(
	   a.currency_cd,		a.currency_rt,		a.insured,
	   a.iss_cd,			a.item_grp,			a.other_charges,
	   a.policy_currency,	a.prem_amt,			a.prem_seq_no,
	   a.property,			a.ref_inv_no,		a.remarks,
	   a.ri_comm_amt,		a.tax_amt,			v_extract_id);
END LOOP;

--end_extract_gipi_orig_invoice_rec


--begin_extract_gipi_orig_invperl_rec
--check_me
FOR a IN(SELECT item_grp,	   peril_cd,	prem_amt,
				ri_comm_amt,   ri_comm_rt,	tsi_amt
  		   FROM GIPI_ORIG_INVPERL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_INVPERL(
	   item_grp,		peril_cd,	  prem_amt,
	   ri_comm_amt,		ri_comm_rt,	  tsi_amt,
	   extract_id)
VALUES(
	   a.item_grp,		a.peril_cd,	  a.prem_amt,
	   a.ri_comm_amt,	a.ri_comm_rt, a.tsi_amt,
	   v_extract_id);
END LOOP;

--end_extract_gipi_orig_invperl_rec


--begin_extract_gipi_orig_inv_tax_rec
--check_me
FOR a IN(SELECT iss_cd,		item_grp,	fixed_tax_allocation,
	   			line_cd,	rate,		tax_allocation,
	   			tax_amt,	tax_cd,		tax_id
  		   FROM GIPI_ORIG_INV_TAX
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_INV_TAX(
	   iss_cd,		item_grp,	fixed_tax_allocation,
	   line_cd,		rate,		tax_allocation,
	   tax_amt,		tax_cd,		tax_id,
	   extract_id)
VALUES(
	   a.iss_cd,		a.item_grp,	   a.fixed_tax_allocation,
	   a.line_cd,		a.rate,		   a.tax_allocation,
	   a.tax_amt,		a.tax_cd,	   a.tax_id,
	   v_extract_id);
END LOOP;

--end_extract_gipi_orig_inv_tax_rec


--begin_extract_gipi_orig_itmperil_rec
--check_me
FOR a IN(SELECT ann_prem_amt,	ann_tsi_amt, 	comp_rem,
	   			discount_sw,	item_no,		line_cd,
	   			peril_cd,		prem_amt,		prem_rt,
	   			rec_flag,		ri_comm_amt,	ri_comm_rate,
	   			surcharge_sw,	tsi_amt
  		   FROM GIPI_ORIG_ITMPERIL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_ITMPERIL(
	   ann_prem_amt,	  ann_tsi_amt, 		comp_rem,
	   discount_sw,		  item_no,			line_cd,
	   peril_cd,		  prem_amt,		  	prem_rt,
	   rec_flag,		  ri_comm_amt,		ri_comm_rate,
	   surcharge_sw,	  tsi_amt,			extract_id)
VALUES(
	   a.ann_prem_amt,	  a.ann_tsi_amt, 	a.comp_rem,
	   a.discount_sw,	  a.item_no,		a.line_cd,
	   a.peril_cd,		  a.prem_amt,		a.prem_rt,
	   a.rec_flag,		  a.ri_comm_amt,	a.ri_comm_rate,
	   a.surcharge_sw,	  a.tsi_amt,		v_extract_id);
END LOOP;

--end_extract_gipi_orig_itmperil_rec



--begin_extract_gipi_polgenin_rec

FOR a IN(SELECT agreed_tag,		endt_text01,		endt_text02,
	   			endt_text03,	endt_text04,		endt_text05,
	   			endt_text06,	endt_text07,		endt_text08,
	   			endt_text09,	endt_text10,		endt_text11,
	   			endt_text12,	endt_text13,		endt_text14,
	   			endt_text15,	endt_text16,		endt_text17,
	   			first_info,		gen_info,			gen_info01,
	   			gen_info02,		gen_info03,			gen_info04,
	   			gen_info05,		gen_info06,			gen_info07,
	   			gen_info08,		gen_info09,			gen_info10,
	   			gen_info11,		gen_info12,			gen_info13,
	   			gen_info14,		gen_info15,			gen_info16,
	   			gen_info17,     initial_info01,		initial_info02,
				initial_info03,	initial_info04,		initial_info05,
				initial_info06,	initial_info07,		initial_info08,
				initial_info09,	initial_info10,		initial_info11,
				initial_info12,	initial_info13,		initial_info14,
				initial_info15,	initial_info16,		initial_info17
  		   FROM GIPI_POLGENIN
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLGENIN(
	   agreed_tag,		endt_text01,		endt_text02,
	   endt_text03,		endt_text04,		endt_text05,
	   endt_text06,		endt_text07,		endt_text08,
	   endt_text09,		endt_text10,		endt_text11,
	   endt_text12,		endt_text13,		endt_text14,
	   endt_text15,		endt_text16,		endt_text17,
	   first_info,		gen_info,			gen_info01,
	   gen_info02,		gen_info03,			gen_info04,
	   gen_info05,		gen_info06,			gen_info07,
	   gen_info08,		gen_info09,			gen_info10,
	   gen_info11,		gen_info12,			gen_info13,
	   gen_info14,		gen_info15,			gen_info16,
	   gen_info17,		extract_id, 		initial_info01,
	   initial_info02,	initial_info03,		initial_info04,
	   initial_info05,	initial_info06,		initial_info07,
	   initial_info08,	initial_info09,		initial_info10,
	   initial_info11,	initial_info12,		initial_info13,
	   initial_info14,	initial_info15,		initial_info16,
	   initial_info17)
VALUES(
	   a.agreed_tag,	a.endt_text01,		a.endt_text02,
	   a.endt_text03,	a.endt_text04,		a.endt_text05,
	   a.endt_text06,	a.endt_text07,		a.endt_text08,
	   a.endt_text09,	a.endt_text10,		a.endt_text11,
	   a.endt_text12,	a.endt_text13,		a.endt_text14,
	   a.endt_text15,	a.endt_text16,		a.endt_text17,
	   a.first_info,	a.gen_info,			a.gen_info01,
	   a.gen_info02,	a.gen_info03,		a.gen_info04,
	   a.gen_info05,	a.gen_info06,		a.gen_info07,
	   a.gen_info08,	a.gen_info09,		a.gen_info10,
	   a.gen_info11,	a.gen_info12,		a.gen_info13,
	   a.gen_info14,	a.gen_info15,		a.gen_info16,
	   a.gen_info17,	v_extract_id, 		a.initial_info01,
	   a.initial_info02,a.initial_info03,	a.initial_info04,
	   a.initial_info05,a.initial_info06,	a.initial_info07,
	   a.initial_info08,a.initial_info09,	a.initial_info10,
	   a.initial_info11,a.initial_info12,	a.initial_info13,
	   a.initial_info14,a.initial_info15,	a.initial_info16,
	   a.initial_info17);
END LOOP;

--end_extract_gipi_polgenin_rec



--begin_extract_gipi_polnrep_rec
--check_me
FOR A IN(SELECT expiry_mm,		 expiry_yy,		new_policy_id,
	  			old_policy_id,	 rec_flag,		ren_rep_sw
  		   FROM GIPI_POLNREP
 		  WHERE new_policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLNREP(
	   expiry_mm,		 expiry_yy,		new_policy_id,
	   old_policy_id,	 rec_flag,		ren_rep_sw,
	   extract_id)
VALUES(
	   a.expiry_mm,		 a.expiry_yy,		a.new_policy_id,
	   a.old_policy_id,	 a.rec_flag,		a.ren_rep_sw,
	   v_extract_id);
END LOOP;

--end_extract_gipi_polnrep_rec



--begin_extract_gipi_polwc_rec

FOR a IN(SELECT change_tag,		line_cd,		print_seq_no,
				print_sw,		rec_flag,		swc_seq_no,
				wc_cd,			wc_remarks,		wc_text01,
				wc_text02,		wc_text03,		wc_text04,
				wc_text05,		wc_text06,		wc_text07,
				wc_text08,		wc_text09,		wc_text10,
				wc_text11,		wc_text12,		wc_text13,
				wc_text14,		wc_text15,		wc_text16,
				wc_text17,		wc_title,       wc_title2
  		   FROM GIPI_POLWC
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLWC(
	   change_tag,		line_cd,		print_seq_no,
	   print_sw,		rec_flag,		swc_seq_no,
	   wc_cd,			wc_remarks,		wc_text01,
	   wc_text02,		wc_text03,		wc_text04,
	   wc_text05,		wc_text06,		wc_text07,
	   wc_text08,		wc_text09,		wc_text10,
	   wc_text11,		wc_text12,		wc_text13,
	   wc_text14,		wc_text15,		wc_text16,
	   wc_text17,		wc_title,		wc_title2,
	   extract_id)
VALUES(
	   a.change_tag,	a.line_cd,		a.print_seq_no,
	   a.print_sw,		a.rec_flag,		a.swc_seq_no,
	   a.wc_cd,			a.wc_remarks,	a.wc_text01,
	   a.wc_text02,		a.wc_text03,	a.wc_text04,
	   a.wc_text05,		a.wc_text06,	a.wc_text07,
	   a.wc_text08,		a.wc_text09,	a.wc_text10,
	   a.wc_text11,		a.wc_text12,	a.wc_text13,
	   a.wc_text14,		a.wc_text15,	a.wc_text16,
	   a.wc_text17,		a.wc_title,		a.wc_title2,
	   v_extract_id);
END LOOP;

--end_extract_gipi_polwc_rec


--begin_extract_gipi_principal_rec

FOR a IN(SELECT principal_cd,	engg_basic_infonum,	  subcon_sw
  	  	   FROM GIPI_PRINCIPAL
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_PRINCIPAL(
	   principal_cd,	 engg_basic_infonum,	subcon_sw,	   extract_id)
VALUES(
	   a.principal_cd,	 a.engg_basic_infonum,	a.subcon_sw,   v_extract_id);
END LOOP;

--end_extract_gipi_principal_rec


--begin_extract_gipi_vehicle_rec

FOR a IN(SELECT acquired_from,    assignee,		   basic_color_cd,
	   			car_company_cd,	  coc_atcn,		   coc_issue_date,
	   			coc_seq_no,		  coc_serial_no,   coc_type,
	   			coc_yy,			  color,		   color_cd,
	   			ctv_tag,		  destination,	   est_value,
	   			item_no,		  make,			   make_cd,
	   			model_year,		  motor_no,		   mot_type,
	   			mv_file_no,		  no_of_pass,	   origin,
	   			plate_no,		  repair_lim,	   serial_no,
				series_cd,		  subline_cd,	   subline_type_cd,
				tariff_zone,	  towing,		   type_of_body_cd,
				unladen_wt,       motor_coverage
  		   FROM GIPI_VEHICLE
 		  WHERE policy_id = p_policy_id)LOOP


INSERT INTO GIXX_VEHICLE(
	   acquired_from,    assignee,		   basic_color_cd,
	   car_company_cd,	 coc_atcn,		   coc_issue_date,
	   coc_seq_no,		 coc_serial_no,    coc_type,
	   coc_yy,			 color,			   color_cd,
	   ctv_tag,			 destination,	   est_value,
	   item_no,			 make,			   make_cd,
	   model_year,		 motor_no,		   mot_type,
	   mv_file_no,		 no_of_pass,	   origin,
	   plate_no,		 repair_lim,	   serial_no,
	   series_cd,		 subline_cd,	   subline_type_cd,
	   tariff_zone,	   	 towing,		   type_of_body_cd,
	   unladen_wt,	   	 extract_id,       motor_coverage)
VALUES(
	   a.acquired_from,    a.assignee,		   a.basic_color_cd,
	   a.car_company_cd,   a.coc_atcn,		   a.coc_issue_date,
	   a.coc_seq_no,	   a.coc_serial_no,    a.coc_type,
	   a.coc_yy,		   a.color,			   a.color_cd,
	   a.ctv_tag,		   a.destination,	   a.est_value,
	   a.item_no,		   a.make,			   a.make_cd,
	   a.model_year,	   a.motor_no,		   a.mot_type,
	   a.mv_file_no,	   a.no_of_pass,	   a.origin,
	   a.plate_no,		   a.repair_lim,	   a.serial_no,
	   a.series_cd,		   a.subline_cd,	   a.subline_type_cd,
	   a.tariff_zone,	   a.towing,		   a.type_of_body_cd,
	   a.unladen_wt,	   v_extract_id,       a.motor_coverage);
END LOOP;

--end_extract_gipi_vehicle_rec


--begin_extract_gipi_ves_air_rec

FOR a IN(SELECT rec_flag,	vescon,		vessel_cd,
	   			voy_limit
  		   FROM GIPI_VES_AIR
 		  WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_VES_AIR(
	   rec_flag,		 vescon,		vessel_cd,
	   voy_limit,		 extract_id)
VALUES(
	   a.rec_flag,		 a.vescon,		a.vessel_cd,
	   a.voy_limit,		 v_extract_id);
END LOOP;

COMMIT;
--end_extract_gipi_ves_air_rec

END extract_poldoc_record;




PROCEDURE extract_wpoldoc_record(
		   p_par_id		GIPI_WPOLBAS.par_id%TYPE,
           v_extract_id    GIXX_POLBASIC.extract_id%TYPE) AS
BEGIN


--begin_extract_gipi_wpolbas_rec

FOR a IN(SELECT acct_of_cd,		      acct_of_cd_sw,		   address1,
	   			address2,			  address3,				   ann_prem_amt,
	   			ann_tsi_amt,		  assd_no,				   auto_renew_flag,
	   			co_insurance_sw,	  cred_branch,			   designation,
	   			discount_sw,		  eff_date,			 	   endt_expiry_date,
	   			endt_expiry_tag,	  endt_iss_cd,			   endt_seq_no,
	   			endt_type,			  endt_yy,				   expiry_date,
	   			expiry_tag,			  fleet_print_tag,		   foreign_acc_sw,
	   			incept_date,		  incept_tag,			   industry_cd,
	   			invoice_sw,			  issue_date,			   issue_yy,
	   			iss_cd,				  label_tag,			   line_cd,
	   			manual_renew_no,	  mortg_name,			   no_of_items,
	   			old_assd_no,		  orig_policy_id,		   pack_pol_flag,
	   			place_cd,			  pol_flag,				   pol_seq_no,
				pool_pol_no,		  prem_amt,				   prem_warr_tag,
				prorate_flag,		  prov_prem_pct,		   prov_prem_tag,
				qd_flag,			  ref_open_pol_no,		   ref_pol_no,
				region_cd,			  reg_policy_sw,		   renew_no,
				same_polno_sw,		  short_rt_percent,		   subline_cd,
				subline_type_cd,	  surcharge_sw,			   tsi_amt,
				type_cd,			  validate_tag,			   with_tariff_sw,
				old_address1,		  old_address2,			   old_address3
  		   FROM GIPI_WPOLBAS
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLBASIC(
	   acct_of_cd,		      acct_of_cd_sw,		   address1,
	   address2,			  address3,				   ann_prem_amt,
	   ann_tsi_amt,			  assd_no,				   auto_renew_flag,
	   co_insurance_sw,		  cred_branch,			   designation,
	   discount_sw,			  eff_date,			 	   endt_expiry_date,
	   endt_expiry_tag,		  endt_iss_cd,			   endt_seq_no,
	   endt_type,			  endt_yy,				   expiry_date,
	   expiry_tag,			  fleet_print_tag,		   foreign_acc_sw,
	   incept_date,			  incept_tag,			   industry_cd,
	   invoice_sw,			  issue_date,			   issue_yy,
	   iss_cd,				  label_tag,			   line_cd,
	   manual_renew_no,		  mortg_name,			   no_of_items,
	   old_assd_no,			  orig_policy_id,		   pack_pol_flag,
	   place_cd,			  pol_flag,				   pol_seq_no,
	   pool_pol_no,			  prem_amt,			   	   prem_warr_tag,
	   prorate_flag,		  prov_prem_pct,		   prov_prem_tag,
	   qd_flag,				  ref_open_pol_no,		   ref_pol_no,
	   region_cd,			  reg_policy_sw,		   renew_no,
	   same_polno_sw,		  short_rt_percent,		   subline_cd,
	   subline_type_cd,		  surcharge_sw,			   tsi_amt,
	   type_cd,				  validate_tag,			   with_tariff_sw,
	   old_address1,		  old_address2,			   old_address3,
	   extract_id)
VALUES(
	   a.acct_of_cd,		  a.acct_of_cd_sw,		   a.address1,
	   a.address2,			  a.address3,			   a.ann_prem_amt,
	   a.ann_tsi_amt,		  a.assd_no,			   a.auto_renew_flag,
	   a.co_insurance_sw,	  a.cred_branch,		   a.designation,
	   a.discount_sw,		  a.eff_date,			   a.endt_expiry_date,
	   a.endt_expiry_tag,	  a.endt_iss_cd,		   a.endt_seq_no,
	   a.endt_type,			  a.endt_yy,			   a.expiry_date,
	   a.expiry_tag,		  a.fleet_print_tag,	   a.foreign_acc_sw,
	   a.incept_date,		  a.incept_tag,			   a.industry_cd,
	   a.invoice_sw,		  a.issue_date,			   a.issue_yy,
	   a.iss_cd,			  a.label_tag,			   a.line_cd,
	   a.manual_renew_no,	  a.mortg_name,			   a.no_of_items,
	   a.old_assd_no,		  a.orig_policy_id,		   a.pack_pol_flag,
	   a.place_cd,			  a.pol_flag,			   a.pol_seq_no,
	   a.pool_pol_no,		  a.prem_amt,			   a.prem_warr_tag,
	   a.prorate_flag,		  a.prov_prem_pct,		   a.prov_prem_tag,
	   a.qd_flag,			  a.ref_open_pol_no,	   a.ref_pol_no,
	   a.region_cd,			  a.reg_policy_sw,		   a.renew_no,
	   a.same_polno_sw,		  a.short_rt_percent,	   a.subline_cd,
	   a.subline_type_cd,	  a.surcharge_sw,		   a.tsi_amt,
	   a.type_cd,			  a.validate_tag,		   a.with_tariff_sw,
	   a.old_address1,		  a.old_address2,		   a.old_address3,
	   v_extract_id); --rollie10282003 added the column old_adrresses
END LOOP;

--end_extract_gipi_wpolbas_rec;

--start_extract_gipi_parlist --rollie10172003
FOR a IN ( SELECT 		line_cd,		iss_cd         ,
		          par_yy,		par_seq_no,	    quote_seq_no,
        	      par_type,		assign_sw,	    par_status,
		          assd_no,		quote_id,	    underwriter,
		          remarks,		address1,	    address2,
		          address3,		load_tag,	    cpi_rec_no,
	              cpi_branch_cd
             FROM GIPI_PARLIST
            WHERE par_id = p_par_id) LOOP

INSERT INTO GIXX_PARLIST(
  	   extract_id,		 		line_cd,			   iss_cd         ,
	   par_yy,					par_seq_no,			   quote_seq_no,
       par_type,				assign_sw,			   par_status,
       assd_no,					quote_id,	 		   underwriter,
       remarks,					address1,			   address2,
       address3,				load_tag,			   cpi_rec_no,
       cpi_branch_cd)
VALUES(
       v_extract_id,	         a.line_cd,	           a.iss_cd         ,
       a.par_yy,		         a.par_seq_no,         a.quote_seq_no,
       a.par_type,		         a.assign_sw,		   a.par_status,
       a.assd_no,     		     a.quote_id,		   a.underwriter,
       a.remarks,		         a.address1,		   a.address2,
       a.address3,		         a.load_tag,		   a.cpi_rec_no,
       a.cpi_branch_cd);
END LOOP;

--end_extract_gipi_parlist
--begin_extract_gipi_waccident_item_rec

FOR a IN(SELECT ac_class_cd,	  age,				civil_status,
	   			date_of_birth,	  destination,		group_print_sw,
	   			height,			  item_no,			level_cd,
	   			monthly_salary,	  no_of_persons,	parent_level_cd,
	   			position_cd,	  salary_grade,		sex,
				weight
  		   FROM GIPI_WACCIDENT_ITEM
 		  WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_ACCIDENT_ITEM(
	   ac_class_cd,	  	  age,				civil_status,
	   date_of_birth,	  destination,		group_print_sw,
	   height,			  item_no,			level_cd,
	   monthly_salary,	  no_of_persons,	parent_level_cd,
	   position_cd,		  salary_grade,		sex,
	   weight,			  extract_id)
VALUES(
	   a.ac_class_cd,	  a.age,			a.civil_status,
	   a.date_of_birth,	  a.destination,	a.group_print_sw,
	   a.height,		  a.item_no,		a.level_cd,
	   a.monthly_salary,  a.no_of_persons,	a.parent_level_cd,
	   a.position_cd,	  a.salary_grade,	a.sex,
	   a.weight,		  v_extract_id);
END LOOP;

--end_extract_gipi_waccident_item_rec


--begin_extract_gipi_waviation_item_rec

FOR a IN(SELECT deduct_text, 	est_util_hrs,	fixed_wing,
	   			geog_limit,		item_no,		prev_util_hrs,
				purpose,		qualification,	rec_flag,
				rotor,			total_fly_time,	vessel_cd
  		   FROM GIPI_WAVIATION_ITEM
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_AVIATION_ITEM(
	   deduct_text,	 	est_util_hrs,	fixed_wing,
	   geog_limit,		item_no,		prev_util_hrs,
	   purpose,			qualification,	rec_flag,
	   rotor,			total_fly_time,	vessel_cd,
	   extract_id)
VALUES(
	   a.deduct_text,	a.est_util_hrs,	  a.fixed_wing,
	   a.geog_limit,	a.item_no,		  a.prev_util_hrs,
	   a.purpose,		a.qualification,  a.rec_flag,
	   a.rotor,			a.total_fly_time, a.vessel_cd,
	   v_extract_id);
END LOOP;

--end_extract_gipi_waviation_item_rec


--begin_extract_gipi_wbank_schedule_rec

FOR a IN(SELECT bank,		  	   bank_address,		bank_item_no,
	   			cash_in_transit,   cash_in_vault,		include_tag,
	   			remarks
  		   FROM GIPI_WBANK_SCHEDULE
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_BANK_SCHEDULE(
	   bank,		  	   bank_address,		bank_item_no,
	   cash_in_transit,	   cash_in_vault,		include_tag,
	   remarks, 		   extract_id)
VALUES(
	   a.bank,		  	   a.bank_address,		a.bank_item_no,
	   a.cash_in_transit,  a.cash_in_vault,		a.include_tag,
	   a.remarks, 		   v_extract_id);
END LOOP;

--end_extract_gipi_wbank_schedule_rec;


--begin_extract_gipi_wbeneficiary_rec

FOR a IN(SELECT adult_sw,	          age,				  beneficiary_addr,
	   			beneficiary_name,	  beneficiary_no,	  civil_status,
	   			date_of_birth,		  delete_sw,		  item_no,
	   			position_cd,		  relation,			  remarks,
				sex
  		   FROM GIPI_WBENEFICIARY
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_BENEFICIARY(
	   adult_sw,	          age,				  beneficiary_addr,
	   beneficiary_name,	  beneficiary_no,	  civil_status,
	   date_of_birth,		  delete_sw,		  item_no,
	   position_cd,		  	  relation,			  remarks,
	   sex,				  	  extract_id)
VALUES(
	   a.adult_sw,	          a.age,			  a.beneficiary_addr,
	   a.beneficiary_name,	  a.beneficiary_no,	  a.civil_status,
	   a.date_of_birth,		  a.delete_sw,		  a.item_no,
	   a.position_cd,	  	  a.relation,		  a.remarks,
	   a.sex,			  	  v_extract_id);
END LOOP;

--end_extract_gipi_wbeneficiary_rec;

--begin_extract_gipi_wbond_basic

FOR a IN(SELECT coll_flag, clause_type, obligee_no, prin_id, val_period_unit,
                val_period, np_no, contract_dtl, contract_date, co_prin_sw,
				waiver_limit, indemnity_text, bond_dtl, endt_eff_date, remarks
  		   FROM GIPI_WBOND_BASIC
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_BOND_BASIC(
	   extract_id, obligee_no, prin_id, coll_flag, clause_type, val_period_unit, val_period,
	   np_no, contract_dtl, contract_date, co_prin_sw, waiver_limit, indemnity_text,
	   bond_dtl, endt_eff_date, remarks)
VALUES(
	   v_extract_id, a.obligee_no, a.prin_id, a.coll_flag, a.clause_type, a.val_period_unit,
	   a.val_period, a.np_no, a.contract_dtl, a.contract_date, a.co_prin_sw,
	   a.waiver_limit, a.indemnity_text, a.bond_dtl, a.endt_eff_date, a.remarks);
END LOOP;

--end_extract_gipi_wbond_basic


--begin_extract_gipi_wcargo_rec

FOR a IN(SELECT bl_awb,			  cargo_class_cd,	cargo_type,
	   			deduct_text,	  destn,			eta,
	   			etd,			  geog_cd,			item_no,
	   			lc_no,			  origin,			pack_method,
	   			print_tag,		  rec_flag,			tranship_destination,
				tranship_origin,  vessel_cd,		voyage_no
  		   FROM GIPI_WCARGO
 		  WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_CARGO(
	   bl_awb,			 cargo_class_cd,	cargo_type,
	   deduct_text,		 destn,			    eta,
	   etd,				 geog_cd,			item_no,
	   lc_no,			 origin,			pack_method,
	   print_tag,		 rec_flag,			tranship_destination,
	   tranship_origin,	 vessel_cd,			voyage_no,
	   extract_id)
VALUES(
	   a.bl_awb,			a.cargo_class_cd,	a.cargo_type,
	   a.deduct_text,		a.destn,			a.eta,
	   a.etd,				a.geog_cd,		    a.item_no,
	   a.lc_no,			    a.origin,		    a.pack_method,
	   a.print_tag,		    a.rec_flag,			a.tranship_destination,
	   a.tranship_origin,   a.vessel_cd,		a.voyage_no,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wcargo_rec


--begin_extract_gipi_wcargo_carrier_rec

FOR a IN(SELECT delete_sw,	destn, 		eta,
	   			etd,		item_no,	origin,
	   			vessel_cd,	voy_limit,  vessel_limit_of_liab
  		   FROM GIPI_WCARGO_CARRIER
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_CARGO_CARRIER(
	   delete_sw,	destn, 		eta,
	   etd,			item_no,	origin,
	   vessel_cd,	voy_limit,	vessel_limit_of_liab,
	   extract_id)
VALUES(
	   a.delete_sw,		a.destn, 		a.eta,
	   a.etd,			a.item_no,		a.origin,
	   a.vessel_cd,		a.voy_limit,	a.vessel_limit_of_liab,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wcargo_carrier_rec


--begin_extract_gipi_wcasualty_item_rec

FOR a IN(SELECT capacity_cd,	   	  conveyance_info,			interest_on_premises,
	   			item_no,		   	  limit_of_liability,		LOCATION,
	   			property_no,	   	  property_no_type,			section_line_cd,
				section_or_hazard_cd, section_or_hazard_info,	section_subline_cd
  		   FROM GIPI_WCASUALTY_ITEM
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_CASUALTY_ITEM(
	   capacity_cd,		     conveyance_info,			interest_on_premises,
	   item_no,			     limit_of_liability,		LOCATION,
	   property_no,		     property_no_type,			section_line_cd,
	   section_or_hazard_cd, section_or_hazard_info,	section_subline_cd,
	   extract_id)
VALUES(
	   a.capacity_cd,		   a.conveyance_info,			a.interest_on_premises,
	   a.item_no,			   a.limit_of_liability,		a.LOCATION,
	   a.property_no,		   a.property_no_type,			a.section_line_cd,
	   a.section_or_hazard_cd, a.section_or_hazard_info,	a.section_subline_cd,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wcasualty_item_rec


--begin_extract_gipi_wcasualty_personnel_rec

FOR a IN(SELECT amount_covered,		capacity_cd,		delete_sw,
	   			include_tag,		item_no,			NAME,
	   			personnel_no,		remarks
  		   FROM GIPI_WCASUALTY_PERSONNEL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_CASUALTY_PERSONNEL(
	   amount_covered,		capacity_cd,	delete_sw,
	   include_tag,			item_no,		NAME,
	   personnel_no,		remarks,		extract_id)
VALUES(
	   a.amount_covered,	a.capacity_cd,		a.delete_sw,
	   a.include_tag,		a.item_no,			a.NAME,
	   a.personnel_no,		a.remarks,			v_extract_id);
END LOOP;

--end_extract_gipi_wcasualty_personnel_rec


--begin_extract_gipi_wcomm_invoices_rec

FOR a IN(SELECT bond_rate,	   		commission_amt,		default_intm,
	   			intrmdry_intm_no,	item_grp,			parent_intm_no,
	   			premium_amt,		share_percentage,	wholding_tax
  		   FROM GIPI_WCOMM_INVOICES
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_COMM_INVOICE(
	   bond_rate,	   		commission_amt,		default_intm,
	   intrmdry_intm_no,	item_grp,			parent_intm_no,
	   premium_amt,			share_percentage,	wholding_tax,
	   extract_id)
VALUES(
	   a.bond_rate,	   		a.commission_amt,	a.default_intm,
	   a.intrmdry_intm_no,	a.item_grp,			a.parent_intm_no,
	   a.premium_amt,		a.share_percentage, a.wholding_tax,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wcomm_invoices_rec

--begin_extract_gipi_co_insurer_rec

FOR a IN(SELECT co_ri_cd,	 	co_ri_prem_amt,		co_ri_shr_pct,
	   			co_ri_tsi_amt
  		   FROM GIPI_CO_INSURER
 		  WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_CO_INSURER(
	   co_ri_cd,	 	co_ri_prem_amt,		co_ri_shr_pct,
	   co_ri_tsi_amt,	extract_id)
VALUES(
	   a.co_ri_cd,	 	a.co_ri_prem_amt,	a.co_ri_shr_pct,
	   a.co_ri_tsi_amt,	v_extract_id);
END LOOP;

--end_extract_gipi_co_insurer_rec
--begin_extract_gipi_wcomm_inv_perils_rec

FOR a IN(SELECT commission_amt,   commission_rt,	intrmdry_intm_no,
	   			item_grp,		  peril_cd,			premium_amt,
				wholding_tax
  		   FROM GIPI_WCOMM_INV_PERILS
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_COMM_INV_PERIL(
	   commission_amt, 	  commission_rt,	intrmdry_intm_no,
	   item_grp,		  peril_cd,			premium_amt,
	   wholding_tax,	  extract_id)
VALUES(
	   a.commission_amt,  a.commission_rt,	a.intrmdry_intm_no,
	   a.item_grp,		  a.peril_cd,		a.premium_amt,
	   a.wholding_tax,	  v_extract_id);
END LOOP;

--end_extract_gipi_wcomm_inv_perils_rec


--begin_extract_gipi_wcosigntry_rec

FOR a IN(SELECT assd_no,	bonds_flag,		bonds_ri_flag,
	   			cosign_id,	indem_flag
  		   FROM GIPI_WCOSIGNTRY
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_COSIGNTRY(
	   assd_no,		bonds_flag,		bonds_ri_flag,
	   cosign_id,	indem_flag,		extract_id)
VALUES(
	   a.assd_no,	a.bonds_flag,	a.bonds_ri_flag,
	   a.cosign_id,	a.indem_flag,	v_extract_id);
END LOOP;

--end_extract_gipi_wcosigntry_rec


--begin_extract_gipi_wdeductibles_rec

FOR a IN(SELECT deductible_amt,		  deductible_rt,		deductible_text,
	   			ded_deductible_cd,	  ded_line_cd,			ded_subline_cd,
	   			item_no,			  peril_cd
  		   FROM GIPI_WDEDUCTIBLES
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_DEDUCTIBLES(
	   deductible_amt,		  deductible_rt,		deductible_text,
	   ded_deductible_cd,	  ded_line_cd,			ded_subline_cd,
	   item_no,				  peril_cd,				extract_id)
VALUES(
	   a.deductible_amt,	  a.deductible_rt,		a.deductible_text,
	   a.ded_deductible_cd,	  a.ded_line_cd,		a.ded_subline_cd,
	   a.item_no,			  a.peril_cd,			v_extract_id);
END LOOP;

--end_extract_gipi_wdeductibles_rec


--begin_extract_gipi_wendttext_rec

FOR a IN(SELECT endt_tax,  	    endt_text,		endt_text01,
	   			endt_text02,	endt_text03,	endt_text04,
	   			endt_text05,	endt_text06,	endt_text07,
	   			endt_text08,	endt_text09,	endt_text10,
	   			endt_text11,	endt_text12,	endt_text13,
	   			endt_text14,	endt_text15,	endt_text16,
	   			endt_text17
  		   FROM GIPI_WENDTTEXT
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ENDTTEXT(
	   endt_tax,  	    endt_text,		endt_text01,
	   endt_text02,		endt_text03,	endt_text04,
	   endt_text05,		endt_text06,	endt_text07,
	   endt_text08,		endt_text09,	endt_text10,
	   endt_text11,		endt_text12,	endt_text13,
	   endt_text14,		endt_text15,	endt_text16,
	   endt_text17,		extract_id)
VALUES(
	   a.endt_tax,  	 a.endt_text,	 a.endt_text01,
	   a.endt_text02,	 a.endt_text03,	 a.endt_text04,
	   a.endt_text05,	 a.endt_text06,	 a.endt_text07,
	   a.endt_text08,	 a.endt_text09,	 a.endt_text10,
	   a.endt_text11,	 a.endt_text12,	 a.endt_text13,
	   a.endt_text14,	 a.endt_text15,	 a.endt_text16,
	   a.endt_text17,	 v_extract_id);
END LOOP;

--end_extract_gipi_wendttext_rec


--begin_extract_gipi_wengg_basic_rec

FOR a IN(SELECT construct_end_date,	   construct_start_date,	contract_proj_buss_title,
	   			engg_basic_infonum,	   maintain_end_date,		maintain_start_date,
	   			mbi_policy_no,		   site_location,			testing_end_date,
				testing_start_date,	   time_excess,				weeks_test
  		   FROM GIPI_WENGG_BASIC
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ENGG_BASIC(
	   construct_end_date,	   construct_start_date,	contract_proj_buss_title,
	   engg_basic_infonum,	   maintain_end_date,		maintain_start_date,
	   mbi_policy_no,		   site_location,			testing_end_date,
	   testing_start_date,	   time_excess,				weeks_test,
	   extract_id)
VALUES(
	   a.construct_end_date,   a.construct_start_date,	a.contract_proj_buss_title,
	   a.engg_basic_infonum,   a.maintain_end_date,		a.maintain_start_date,
	   a.mbi_policy_no,		   a.site_location,			a.testing_end_date,
	   a.testing_start_date,   a.time_excess,			a.weeks_test,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wengg_basic_rec


--begin_extract_gipi_wfireitm_rec

FOR a IN(SELECT assignee,		     block_id,					block_no,
	   			construction_cd,	 construction_remarks,		district_no,
	   			eq_zone,			 flood_zone,				front,
	   			fr_item_type,		 item_no,					LEFT,
	   			loc_risk1,			 loc_risk2,					loc_risk3,
	   			occupancy_cd,		 occupancy_remarks,			rear,
				RIGHT,				 tarf_cd,					tariff_zone,
				typhoon_zone
  		   FROM GIPI_WFIREITM
 		  WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_FIREITEM(
	   assignee,		     block_id,					block_no,
	   construction_cd,		 construction_remarks,		district_no,
	   eq_zone,				 flood_zone,				front,
	   fr_item_type,		 item_no,					LEFT,
	   loc_risk1,			 loc_risk2,					loc_risk3,
	   occupancy_cd,		 occupancy_remarks,			rear,
	   RIGHT,				 tarf_cd,					tariff_zone,
	   typhoon_zone,		 extract_id)
VALUES(
	   a.assignee,		     a.block_id,				a.block_no,
	   a.construction_cd,	 a.construction_remarks,	a.district_no,
	   a.eq_zone,			 a.flood_zone,				a.front,
	   a.fr_item_type,		 a.item_no,					a.LEFT,
	   a.loc_risk1,			 a.loc_risk2,				a.loc_risk3,
	   a.occupancy_cd,		 a.occupancy_remarks,		a.rear,
	   a.RIGHT,				 a.tarf_cd,					a.tariff_zone,
	   a.typhoon_zone,		 v_extract_id);
END LOOP;

--end_extract_gipi_wfireitm_rec


--begin_extract_gipi_wgrouped_items_rec

FOR a IN(SELECT age,			 	  nvl(amount_covered,tsi_amt) amount_covered,
         		civil_status,
	   			date_of_birth,	 	  delete_sw,			grouped_item_no,
	   			grouped_item_title,	  group_cd,				include_tag,
	   			item_no,			  line_cd,				position_cd,
				remarks,			  salary,				salary_grade,
				sex,				  subline_cd
  FROM GIPI_WGROUPED_ITEMS
 WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_GROUPED_ITEMS(
	   age,				 	  amount_coverage,	amount_covered,
	   civil_status,
	   date_of_birth,	 	  delete_sw,			grouped_item_no,
	   grouped_item_title,	  group_cd,				include_tag,
	   item_no,				  line_cd,				position_cd,
	   remarks,				  salary,				salary_grade,
	   sex,					  subline_cd,			extract_id)
VALUES(
	   a.age,			 	  a.amount_covered,		a.amount_covered,
	   a.civil_status,
	   a.date_of_birth,	 	  a.delete_sw,			a.grouped_item_no,
	   a.grouped_item_title,  a.group_cd,			a.include_tag,
	   a.item_no,			  a.line_cd,			a.position_cd,
	   a.remarks,			  a.salary,				a.salary_grade,
	   a.sex,				  a.subline_cd,			v_extract_id);
END LOOP;

--end_extract_gipi_wgrouped_items_rec


--begin_extract_gipi_wgrp_items_beneficiary_rec

FOR a IN(SELECT age,			  beneficiary_addr,		beneficiary_name,
	   			beneficiary_no,	  civil_status,			date_of_birth,
	   			grouped_item_no,  item_no,				relation,
				sex
  		   FROM GIPI_WGRP_ITEMS_BENEFICIARY
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_GRP_ITEMS_BENEFICIARY(
	   age,			      beneficiary_addr,		beneficiary_name,
	   beneficiary_no,	  civil_status,			date_of_birth,
	   grouped_item_no,	  item_no,				relation,
	   sex,				  extract_id)
VALUES(
	   a.age,			      a.beneficiary_addr,		a.beneficiary_name,
	   a.beneficiary_no,	  a.civil_status,			a.date_of_birth,
	   a.grouped_item_no,	  a.item_no,				a.relation,
	   a.sex,				  v_extract_id);
END LOOP;

--end_extract_gipi_wgrp_items_beneficiary_rec


--begin_extract_gipi_winvoice_rec

FOR a IN(SELECT approval_cd,      bond_rate,	bond_tsi_amt,
	   			card_name,	      card_no,		currency_cd,
	   			currency_rt,	  due_date,		expiry_date,
	   			insured,		  item_grp,		notarial_fee,
	   			other_charges,	  payt_terms,	pay_type,
				policy_currency,  prem_amt,		prem_seq_no,
				property,	      ref_inv_no,	remarks,
				ri_comm_amt,      tax_amt
  		   FROM GIPI_WINVOICE
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_INVOICE(
	   approval_cd,	    bond_rate,		bond_tsi_amt,
	   card_name,	    card_no,		currency_cd,
	   currency_rt,		due_date,		expiry_date,
	   insured,			item_grp,		notarial_fee,
	   other_charges,	payt_terms,		pay_type,
	   policy_currency, prem_amt,		prem_seq_no,
	   property,		ref_inv_no,		remarks,
	   ri_comm_amt,	    tax_amt,		extract_id)
VALUES(
	   a.approval_cd,	  a.bond_rate,		a.bond_tsi_amt,
	   a.card_name,	      a.card_no,		a.currency_cd,
	   a.currency_rt,	  a.due_date,		a.expiry_date,
	   a.insured,		  a.item_grp,		a.notarial_fee,
	   a.other_charges,	  a.payt_terms,		a.pay_type,
	   a.policy_currency, a.prem_amt,		a.prem_seq_no,
	   a.property,		  a.ref_inv_no,		a.remarks,
	   a.ri_comm_amt,	  a.tax_amt,		v_extract_id);
END LOOP;

--end_extract_gipi_winvoice_rec


--begin_extract_gipi_winvperl_rec

FOR a IN(SELECT item_grp,  	  peril_cd,		prem_amt,
				ri_comm_amt,  ri_comm_rt,	tsi_amt
		   FROM GIPI_WINVPERL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_INVPERIL(
	   item_grp,  	 peril_cd, 	 prem_amt,
	   ri_comm_amt,	 ri_comm_rt, tsi_amt,
	   extract_id)
VALUES(
	   a.item_grp,  	a.peril_cd,	 	 a.prem_amt,
	   a.ri_comm_amt,	a.ri_comm_rt,	 a.tsi_amt,
	   v_extract_id);
END LOOP;

--end_extract_gipi_winvperl_rec


--begin_extract_gipi_winv_tax_rec

FOR a IN(SELECT iss_cd,		item_grp,		fixed_tax_allocation,
	   			line_cd,	rate,			tax_amt,
				tax_cd,		tax_allocation,	tax_id
  		   FROM GIPI_WINV_TAX
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_INV_TAX(
	   iss_cd,		item_grp,		fixed_tax_allocation,
	   line_cd,		rate,			tax_amt,
	   tax_cd,		tax_allocation, tax_id,
	   extract_id)
VALUES(
	   a.iss_cd,		a.item_grp,		  a.fixed_tax_allocation,
	   a.line_cd,		a.rate,			  a.tax_amt,
	   a.tax_cd,		a.tax_allocation, a.tax_id,
	   v_extract_id);
END LOOP;

--end_extract_gipi_winv_tax_rec


--begin_extract_gipi_witem_rec

FOR a IN(SELECT ann_prem_amt,  	  ann_tsi_amt,		   changed_tag,
	   			comp_sw,		  coverage_cd,		   currency_cd,
	   			currency_rt,	  discount_sw,		   from_date,
	   			group_cd,		  item_desc,		   item_desc2,
	   			item_grp,		  item_no,			   item_title,
	   			other_info,		  pack_line_cd,		   pack_subline_cd,
	   			prem_amt,		  prorate_flag,		   rec_flag,
				region_cd,		  short_rt_percent,	   surcharge_sw,
				TO_DATE,		  tsi_amt,             risk_no,
				risk_item_no
  		   FROM GIPI_WITEM
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ITEM(
	   ann_prem_amt,   	  ann_tsi_amt,		   changed_tag,
	   comp_sw,			  coverage_cd,		   currency_cd,
	   currency_rt,		  discount_sw,		   from_date,
	   group_cd,		  item_desc,		   item_desc2,
	   item_grp,		  item_no,			   item_title,
	   other_info,		  pack_line_cd,		   pack_subline_cd,
	   prem_amt,		  prorate_flag,		   rec_flag,
	   region_cd,		  short_rt_percent,	   surcharge_sw,
	   TO_DATE,			  tsi_amt,			   extract_id,
	   risk_no,           risk_item_no)
VALUES(
	   a.ann_prem_amt,    a.ann_tsi_amt,	   a.changed_tag,
	   a.comp_sw,		  a.coverage_cd,	   a.currency_cd,
	   a.currency_rt,	  a.discount_sw,	   a.from_date,
	   a.group_cd,		  a.item_desc,		   a.item_desc2,
	   a.item_grp,		  a.item_no,		   a.item_title,
	   a.other_info,	  a.pack_line_cd,	   a.pack_subline_cd,
	   a.prem_amt,		  a.prorate_flag,	   a.rec_flag,
	   a.region_cd,		  a.short_rt_percent,  a.surcharge_sw,
	   a.TO_DATE,		  a.tsi_amt,		   v_extract_id,
	   a.risk_no,         a.risk_item_no);
END LOOP;

--end_extract_gipi_witem_rec


--begin_extract_gipi_witem_ves_rec

FOR a IN(SELECT deduct_text,	dry_date,		dry_place,
	   			geog_limit,		item_no,		rec_flag,
				vessel_cd
  		   FROM GIPI_WITEM_VES
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ITEM_VES(
	   deduct_text,		dry_date,		dry_place,
	   geog_limit,		item_no,		rec_flag,
	   vessel_cd,		extract_id)
VALUES(
	   a.deduct_text,	a.dry_date,		a.dry_place,
	   a.geog_limit,	a.item_no,		a.rec_flag,
	   a.vessel_cd,		v_extract_id);
END LOOP;

--end_extract_gipi_witem_ves_rec


--begin_extract_gipi_witmperl_rec

FOR a IN(SELECT ann_prem_amt,	ann_tsi_amt,	as_charge_sw,
	   			comp_rem,		discount_sw,	item_no,
	   			line_cd,		peril_cd,		prem_amt,
				prem_rt,		prt_flag,		rec_flag,
				ri_comm_amt,	ri_comm_rate,	surcharge_sw,
				tarf_cd,		tsi_amt
  		   FROM GIPI_WITMPERL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ITMPERIL(
	   ann_prem_amt,	ann_tsi_amt,	as_charge_sw,
	   comp_rem,		discount_sw,	item_no,
	   line_cd,			peril_cd,		prem_amt,
	   prem_rt,			prt_flag,		rec_flag,
	   ri_comm_amt,		ri_comm_rate,	surcharge_sw,
	   tarf_cd,			tsi_amt,		extract_id)
VALUES(
	   a.ann_prem_amt,	a.ann_tsi_amt,	a.as_charge_sw,
	   a.comp_rem,		a.discount_sw,	a.item_no,
	   a.line_cd,		a.peril_cd,		a.prem_amt,
	   a.prem_rt,		a.prt_flag,		a.rec_flag,
	   a.ri_comm_amt,	a.ri_comm_rate,	a.surcharge_sw,
	   a.tarf_cd,		a.tsi_amt,		v_extract_id);
END LOOP;

--end_extract_gipi_witmperl_rec


--begin_extract_gipi_wlim_liab_rec

FOR a IN(SELECT currency_cd,	currency_rt,	liab_cd,
	   			line_cd,		limit_liability
  		   FROM GIPI_WLIM_LIAB
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_LIM_LIAB(
	   currency_cd,	  currency_rt,	  	liab_cd,
	   line_cd,		  limit_liability,	extract_id)
VALUES(
	   a.currency_cd,	a.currency_rt,	 	a.liab_cd,
	   a.line_cd,		a.limit_liability,  v_extract_id);
END LOOP;

--end_extract_gipi_wlim_liab_rec


--begin_extract_gipi_wlocation_rec

FOR a IN(SELECT item_no,	province_cd,	region_cd
  	  	   FROM GIPI_WLOCATION
 		  WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_LOCATION(
	   item_no,		province_cd,	region_cd,   extract_id)
VALUES(
	   a.item_no,	a.province_cd,	a.region_cd,   v_extract_id);
END LOOP;

--end_extract_gipi_wlocation_rec

--begin_extract_gipi_main_co_ins_rec
--added by rollie 10272003
FOR a IN(SELECT prem_amt,	tsi_amt
  	  	   FROM GIPI_MAIN_CO_INS
		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_MAIN_CO_INS(
	   prem_amt,	tsi_amt,	extract_id)
VALUES(
	   a.prem_amt,	a.tsi_amt,	v_extract_id);
END LOOP;

--end_extract_gipi_main_co_ins_rec

--begin_extract_gipi_wmcacc_rec

FOR a IN(SELECT accessory_cd,	acc_amt,	delete_sw,
	   			item_no
		   FROM GIPI_WMCACC
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_MCACC(
	   accessory_cd,	acc_amt,		delete_sw,
	   item_no,			extract_id)
VALUES(
	   a.accessory_cd,	a.acc_amt,		a.delete_sw,
	   a.item_no,		v_extract_id);
END LOOP;

--end_extract_gipi_wmcacc_rec


--begin_extract_gipi_wmortgagee_rec

FOR a IN(SELECT amount,	  delete_sw,	 iss_cd,
	   			item_no,  mortg_cd,		 remarks
  		   FROM GIPI_WMORTGAGEE
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_MORTGAGEE(
	   amount,	  delete_sw,	 iss_cd,
	   item_no,	  mortg_cd,		 remarks,
	   extract_id)
VALUES(
	   a.amount,	  a.delete_sw,	 a.iss_cd,
	   a.item_no,	  a.mortg_cd,	 a. remarks,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wmortgagee_rec


--begin_extract_gipi_wopen_cargo_rec

FOR a IN(SELECT cargo_class_cd,	  geog_cd,		rec_flag
  	  	   FROM GIPI_WOPEN_CARGO
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_CARGO(
	   cargo_class_cd,	  geog_cd,		rec_flag,		extract_id)
VALUES(
	   a.cargo_class_cd,  a.geog_cd,	a.rec_flag,		v_extract_id);
END LOOP;

--end_extract_gipi_wopen_cargo_rec


--begin_extract_gipi_wopen_liab_rec

FOR a IN(SELECT currency_cd,	  	currency_rt,		geog_cd,
	   			limit_liability,	multi_geog_tag,		prem_tag,
				rec_flag,			voy_limit,			with_invoice_tag
  		   FROM GIPI_WOPEN_LIAB
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_LIAB(
	   currency_cd,	  		currency_rt,		geog_cd,
	   limit_liability,		multi_geog_tag,		prem_tag,
	   rec_flag,			voy_limit,			with_invoice_tag,
	   extract_id)
VALUES(
	   a.currency_cd,	  	a.currency_rt,		a.geog_cd,
	   a.limit_liability,	a.multi_geog_tag,	a.prem_tag,
	   a.rec_flag,			a.voy_limit,		a.with_invoice_tag,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wopen_liab_rec


--begin_extract_gipi_wopen_peril_rec

FOR a IN(SELECT geog_cd,			line_cd,		peril_cd,
	   			prem_rate,			rec_flag,		remarks,
	   			with_invoice_tag
  		   FROM GIPI_WOPEN_PERIL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_PERIL(
	   geog_cd,				line_cd,		peril_cd,
	   prem_rate,			rec_flag,		remarks,
	   with_invoice_tag,    extract_id)
VALUES(
	   a.geog_cd,			a.line_cd,		a.peril_cd,
	   a.prem_rate,		   	a.rec_flag,		a.remarks,
	   a.with_invoice_tag,  v_extract_id);
END LOOP;

--end_extract_gipi_wopen_peril_rec


--begin_extract_gipi_wopen_policy_rec

FOR a IN(SELECT decltn_no,		eff_date,		  line_cd,
	   			op_issue_yy,	op_iss_cd,		  op_pol_seqno,
	   			op_renew_no,	op_subline_cd
  		   FROM GIPI_WOPEN_POLICY
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_POLICY(
	   decltn_no,		eff_date,		  line_cd,
	   op_issue_yy,		op_iss_cd,		  op_pol_seqno,
	   op_renew_no,		op_subline_cd,	  extract_id)
VALUES(
	   a.decltn_no,		a.eff_date,		  a.line_cd,
	   a.op_issue_yy,	a.op_iss_cd,	  a.op_pol_seqno,
	   a.op_renew_no,	a.op_subline_cd,  v_extract_id);
END LOOP;

--end_extract_gipi_wopen_policy_rec


--begin_extract_gipi_orig_comm_invoice_rec
--check_me
FOR a IN(SELECT commission_amt, 	intrmdry_intm_no,	iss_cd,
	   			item_grp,			premium_amt,		prem_seq_no,
	   			share_percentage,	wholding_tax
  		   FROM GIPI_ORIG_COMM_INVOICE
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INVOICE(
	   commission_amt, 		intrmdry_intm_no,	iss_cd,
	   item_grp,			premium_amt,		prem_seq_no,
	   share_percentage,	wholding_tax,		extract_id)
VALUES(
	   a.commission_amt, 	a.intrmdry_intm_no,	a.iss_cd,
	   a.item_grp,			a.premium_amt,		a.prem_seq_no,
	   a.share_percentage,	a.wholding_tax,		v_extract_id);
END LOOP;

--end_extract_gipi_orig_comm_invoice_rec


--begin_extract_gipi_orig_comm_inv_peril_rec
--check_me
FOR a IN (SELECT commission_amt, 	commission_rt,		intrmdry_intm_no,
	   		 	iss_cd,				item_grp,			peril_cd,
	   			premium_amt,		prem_seq_no,		wholding_tax
  		   FROM GIPI_ORIG_COMM_INV_PERIL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INV_PERIL(
	   commission_amt, 		commission_rt,		intrmdry_intm_no,
	   iss_cd,				item_grp,			peril_cd,
	   premium_amt,			prem_seq_no,		wholding_tax,
	   extract_id)
VALUES(
	   a.commission_amt, 	a.commission_rt,	a.intrmdry_intm_no,
	   a.iss_cd,			a.item_grp,			a.peril_cd,
	   a.premium_amt,		a.prem_seq_no,		a.wholding_tax,
	   v_extract_id);
END LOOP;

--end_extract_gipi_orig_comm_inv_peril_rec


--begin_extract_gipi_orig_invoice_rec
--check_me
FOR a IN(SELECT currency_cd,		currency_rt,	insured,
	   			iss_cd,				item_grp,		other_charges,
	   			policy_currency,	prem_amt,		prem_seq_no,
	   			property,			ref_inv_no,		remarks,
	   			ri_comm_amt,		tax_amt
  		   FROM GIPI_ORIG_INVOICE
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_INVOICE(
	   currency_cd,			currency_rt,		insured,
	   iss_cd,				item_grp,			other_charges,
	   policy_currency,		prem_amt,			prem_seq_no,
	   property,			ref_inv_no,			remarks,
	   ri_comm_amt,			tax_amt,			extract_id)
VALUES(
	   a.currency_cd,		a.currency_rt,		a.insured,
	   a.iss_cd,			a.item_grp,			a.other_charges,
	   a.policy_currency,	a.prem_amt,			a.prem_seq_no,
	   a.property,			a.ref_inv_no,		a.remarks,
	   a.ri_comm_amt,		a.tax_amt,			v_extract_id);
END LOOP;

--end_extract_gipi_orig_invoice_rec


--begin_extract_gipi_orig_invperl_rec
--check_me
FOR a IN(SELECT item_grp,	   peril_cd,	prem_amt,
				ri_comm_amt,   ri_comm_rt,	tsi_amt
  		   FROM GIPI_ORIG_INVPERL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_INVPERL(
	   item_grp,		peril_cd,	  prem_amt,
	   ri_comm_amt,		ri_comm_rt,	  tsi_amt,
	   extract_id)
VALUES(
	   a.item_grp,		a.peril_cd,	  a.prem_amt,
	   a.ri_comm_amt,	a.ri_comm_rt, a.tsi_amt,
	   v_extract_id);
END LOOP;

--end_extract_gipi_orig_invperl_rec


--begin_extract_gipi_orig_inv_tax_rec
--check_me
FOR a IN(SELECT iss_cd,		item_grp,	fixed_tax_allocation,
	   			line_cd,	rate,		tax_allocation,
	   			tax_amt,	tax_cd,		tax_id
  		   FROM GIPI_ORIG_INV_TAX
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_INV_TAX(
	   iss_cd,		item_grp,	fixed_tax_allocation,
	   line_cd,		rate,		tax_allocation,
	   tax_amt,		tax_cd,		tax_id,
	   extract_id)
VALUES(
	   a.iss_cd,		a.item_grp,	   a.fixed_tax_allocation,
	   a.line_cd,		a.rate,		   a.tax_allocation,
	   a.tax_amt,		a.tax_cd,	   a.tax_id,
	   v_extract_id);
END LOOP;

--end_extract_gipi_orig_inv_tax_rec


--begin_extract_gipi_orig_itmperil_rec
--check_me
FOR a IN(SELECT ann_prem_amt,	ann_tsi_amt, 	comp_rem,
	   			discount_sw,	item_no,		line_cd,
	   			peril_cd,		prem_amt,		prem_rt,
	   			rec_flag,		ri_comm_amt,	ri_comm_rate,
	   			surcharge_sw,	tsi_amt
  		   FROM GIPI_ORIG_ITMPERIL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_ITMPERIL(
	   ann_prem_amt,	  ann_tsi_amt, 		comp_rem,
	   discount_sw,		  item_no,			line_cd,
	   peril_cd,		  prem_amt,		  	prem_rt,
	   rec_flag,		  ri_comm_amt,		ri_comm_rate,
	   surcharge_sw,	  tsi_amt,			extract_id)
VALUES(
	   a.ann_prem_amt,	  a.ann_tsi_amt, 	a.comp_rem,
	   a.discount_sw,	  a.item_no,		a.line_cd,
	   a.peril_cd,		  a.prem_amt,		a.prem_rt,
	   a.rec_flag,		  a.ri_comm_amt,	a.ri_comm_rate,
	   a.surcharge_sw,	  a.tsi_amt,		v_extract_id);
END LOOP;

--end_extract_gipi_orig_itmperil_rec


--begin_extract_gipi_wpolgenin_rec

FOR a IN(SELECT agreed_tag,		first_info,		gen_info,
	   			gen_info01,		gen_info02,		gen_info03,
	   			gen_info04,		gen_info05,		gen_info06,
	   			gen_info07,		gen_info08,		gen_info09,
	   			gen_info10,		gen_info11,		gen_info12,
	   			gen_info13,		gen_info14,		gen_info15,
	   			gen_info16,		gen_info17,		initial_info01,
			    initial_info02,	initial_info03,	initial_info04,
			    initial_info05,	initial_info06,	initial_info07,
			    initial_info08,	initial_info09,	initial_info10,
			    initial_info11,	initial_info12,	initial_info13,
			    initial_info14,	initial_info15,	initial_info16,
			    initial_info17
  		   FROM GIPI_WPOLGENIN
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLGENIN(
	   agreed_tag,		first_info,		gen_info,
	   gen_info01,		gen_info02,		gen_info03,
	   gen_info04,		gen_info05,		gen_info06,
	   gen_info07,		gen_info08,		gen_info09,
	   gen_info10,		gen_info11,		gen_info12,
	   gen_info13,		gen_info14,		gen_info15,
	   gen_info16,		gen_info17,		extract_id,
	   initial_info01,  initial_info02,	initial_info03,
	   initial_info04,	initial_info05,	initial_info06,
	   initial_info07,	initial_info08,	initial_info09,
	   initial_info10,	initial_info11,	initial_info12,
	   initial_info13,	initial_info14,	initial_info15,
	   initial_info16,	initial_info17)
VALUES(
	   a.agreed_tag,	a.first_info,	a.gen_info,
	   a.gen_info01,	a.gen_info02,	a.gen_info03,
	   a.gen_info04,	a.gen_info05,	a.gen_info06,
	   a.gen_info07,	a.gen_info08,	a.gen_info09,
	   a.gen_info10,	a.gen_info11,	a.gen_info12,
	   a.gen_info13,	a.gen_info14,	a.gen_info15,
	   a.gen_info16,	a.gen_info17,	v_extract_id,
	   a.initial_info01,a.initial_info02,a.initial_info03,
	   a.initial_info04,a.initial_info05,a.initial_info06,
	   a.initial_info07,a.initial_info08,a.initial_info09,
	   a.initial_info10,a.initial_info11,a.initial_info12,
	   a.initial_info13,a.initial_info14,a.initial_info15,
	   a.initial_info16,a.initial_info17);
END LOOP;

--end_extract_gipi_wpolgenin_rec


--begin_extract_gipi_wpolnrep_rec
--check_me
FOR a IN(SELECT expiry_mm,		 expiry_yy,		new_policy_id,
	  			old_policy_id,	 rec_flag,		ren_rep_sw
  		   FROM GIPI_WPOLNREP
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLNREP(
	   expiry_mm,		 expiry_yy,		new_policy_id,
	   old_policy_id,	 rec_flag,		ren_rep_sw,
	   extract_id)
VALUES(
	   a.expiry_mm,		 a.expiry_yy,		a.new_policy_id,
	   a.old_policy_id,	 a.rec_flag,		a.ren_rep_sw,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wpolnrep_rec


--begin_extract_gipi_wpolnrep_rec

FOR a IN(SELECT expiry_mm,		expiry_yy,	new_policy_id,
	   			old_policy_id,	rec_flag,	ren_rep_sw
  		   FROM GIPI_WPOLNREP
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLNREP(
	   expiry_mm,		expiry_yy,	  new_policy_id,
	   old_policy_id,	rec_flag,	  ren_rep_sw,
	   extract_id)
VALUES(
	   a.expiry_mm,		a.expiry_yy,  a.new_policy_id,
	   a.old_policy_id,	a.rec_flag,	  a.ren_rep_sw,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wpolnrep_rec


--begin_extract_gipi_wpolwc_rec

FOR a IN(SELECT change_tag,		line_cd,		print_seq_no,
				print_sw,		rec_flag,		swc_seq_no,
				wc_cd,			wc_remarks,		wc_text01,
				wc_text02,		wc_text03,		wc_text04,
				wc_text05,		wc_text06,		wc_text07,
				wc_text08,		wc_text09,		wc_text10,
				wc_text11,		wc_text12,		wc_text13,
				wc_text14,		wc_text15,		wc_text16,
				wc_text17,		wc_title,		wc_title2
  		   FROM GIPI_WPOLWC
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLWC(
	   change_tag,		line_cd,	  	print_seq_no,
	   print_sw,		rec_flag,	  	swc_seq_no,
	   wc_cd,			wc_remarks,	  	wc_text01,
	   wc_text02,		wc_text03,	  	wc_text04,
	   wc_text05,		wc_text06,	  	wc_text07,
	   wc_text08,		wc_text09,	  	wc_text10,
	   wc_text11,		wc_text12,	  	wc_text13,
	   wc_text14,		wc_text15,	  	wc_text16,
	   wc_text17,		wc_title,	  	wc_title2,
	   extract_id)
VALUES(
	   a.change_tag,	a.line_cd,	  	a.print_seq_no,
	   a.print_sw,		a.rec_flag,	  	a.swc_seq_no,
	   a.wc_cd,			a.wc_remarks,	a.wc_text01,
	   a.wc_text02,		a.wc_text03,	a.wc_text04,
	   a.wc_text05,		a.wc_text06,	a.wc_text07,
	   a.wc_text08,		a.wc_text09,	a.wc_text10,
	   a.wc_text11,		a.wc_text12,	a.wc_text13,
	   a.wc_text14,		a.wc_text15,	a.wc_text16,
	   a.wc_text17,		a.wc_title,	  	a.wc_title2,
	   v_extract_id);
END LOOP;

--end_extract_gipi_wpolwc_rec


--begin_extract_gipi_wprincipal_rec

FOR a IN(SELECT engg_basic_infonum,	  	principal_cd,  		subcon_sw
	  	   FROM GIPI_WPRINCIPAL
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_PRINCIPAL(
	   engg_basic_infonum,	  principal_cd,		subcon_sw,		extract_id)
VALUES(
	   a.engg_basic_infonum,  a.principal_cd,	a.subcon_sw,	v_extract_id);
END LOOP;

--end_extract_gipi_wprincipal_rec


--begin_extract_gipi_wvehicle_rec

FOR a IN(SELECT acquired_from, 		assignee,		basic_color_cd,
	   			car_company_cd,		coc_atcn,		coc_issue_date,
	   			coc_seq_no,			coc_serial_no,	coc_type,
	   			coc_yy,				color,			color_cd,
	   			ctv_tag,			destination,	est_value,
	   			item_no,			make,			make_cd,
	   			model_year,			motor_no,		mot_type,
	   			mv_file_no,			no_of_pass,		origin,
	   			plate_no,			repair_lim,		serial_no,
				series_cd,			subline_cd,		subline_type_cd,
				tariff_zone,		towing,			type_of_body_cd,
				unladen_wt,         motor_coverage
  		   FROM GIPI_WVEHICLE
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_VEHICLE(
	   acquired_from, 	assignee,		basic_color_cd,
	   car_company_cd,	coc_atcn,		coc_issue_date,
	   coc_seq_no,		coc_serial_no,	coc_type,
	   coc_yy,			color,			color_cd,
	   ctv_tag,			destination,	est_value,
	   item_no,			make,			make_cd,
	   model_year,		motor_no,		mot_type,
	   mv_file_no,		no_of_pass,		origin,
	   plate_no,		repair_lim,		serial_no,
	   series_cd,		subline_cd,		subline_type_cd,
	   tariff_zone,		towing,			type_of_body_cd,
	   unladen_wt,		extract_id,     motor_coverage)
VALUES(
	   a.acquired_from, 	a.assignee,			a.basic_color_cd,
	   a.car_company_cd,	a.coc_atcn,			a.coc_issue_date,
	   a.coc_seq_no,		a.coc_serial_no,	a.coc_type,
	   a.coc_yy,			a.color,			a.color_cd,
	   a.ctv_tag,			a.destination,		a.est_value,
	   a.item_no,			a.make,				a.make_cd,
	   a.model_year,		a.motor_no,			a.mot_type,
	   a.mv_file_no,		a.no_of_pass,		a.origin,
	   a.plate_no,			a.repair_lim,		a.serial_no,
	   a.series_cd,			a.subline_cd,		a.subline_type_cd,
	   a.tariff_zone,		a.towing,			a.type_of_body_cd,
	   a.unladen_wt,		v_extract_id,       a.motor_coverage);
END LOOP;

--end_extract_gipi_wvehicle_rec


--begin_extract_gipi_wves_air_rec

FOR a IN(SELECT rec_flag,	vescon,		vessel_cd,
				voy_limit
  		   FROM GIPI_WVES_AIR
 		  WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_VES_AIR(
	   rec_flag,	vescon,		vessel_cd,
	   voy_limit,	extract_id)
VALUES(
	   a.rec_flag,	a.vescon,		a.vessel_cd,
	   a.voy_limit,	v_extract_id);
END LOOP;

--end_extract_gipi_wves_air_rec
COMMIT;
END extract_wpoldoc_record;


END;
/


