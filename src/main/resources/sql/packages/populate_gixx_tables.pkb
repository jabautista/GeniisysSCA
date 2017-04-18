CREATE OR REPLACE PACKAGE BODY CPI.Populate_Gixx_Tables AS

PROCEDURE extract_poldoc_record(
     p_policy_id  GIPI_POLBASIC.policy_id%TYPE,
           v_extract_id    GIXX_POLBASIC.extract_id%TYPE) AS
BEGIN
--extract_gipi_polbas_rec

FOR A IN (SELECT acct_ent_date,       acct_of_cd,           acct_of_cd_sw,
         actual_renew_no,     address1,             address2,
        address3,            ann_prem_amt,         ann_tsi_amt,
        assd_no,             auto_renew_flag,  co_insurance_sw,
        cred_branch,         designation,   discount_sw,
        dist_flag,           eff_date,    eis_flag,
        endt_expiry_date,    endt_expiry_tag,  endt_iss_cd,
        endt_seq_no,         endt_type,   endt_yy,
        expiry_date,         expiry_tag,   fleet_print_tag,
        foreign_acc_sw,      incept_date,   incept_tag,
        industry_cd,         invoice_sw,   issue_date,
        issue_yy,     iss_cd,    label_tag,
        line_cd,     manual_renew_no,  mortg_name,
        no_of_items,    old_assd_no,   pack_pol_flag,
        place_cd,     polendt_printed_cnt, polendt_printed_date,
        pol_flag,            pol_seq_no,   pool_pol_no,
        prem_amt,            prem_warr_tag,  prorate_flag,
        prov_prem_pct,       prov_prem_tag,  qd_flag,
        ref_open_pol_no,     ref_pol_no,   region_cd,
        reg_policy_sw,       renew_flag,   renew_no,
        short_rt_percent,   spld_approval,  spld_date,
        spld_flag,           spld_user_id,   subline_cd,
        subline_type_cd,     surcharge_sw,   tsi_amt,
        type_cd,             validate_tag,   with_tariff_sw,
     old_address1,    old_address2,   old_address3,
     policy_id,  back_stat,   booking_mth, -- mod2 start
     booking_year,  cancel_date,   claims_extract_tag,
        comp_sw,  cpi_branch_cd,   cpi_rec_no,
        last_upd_date, old_pol_flag,   orig_policy_id,
     par_id,  reinstatement_date,  ren_notice_cnt,
        ren_notice_date, renew_extract_tag,  risk_tag,
        spld_acct_ent_date,  user_id,  -- mod2 end
  settling_agent_cd,survey_agent_cd
     FROM GIPI_POLBASIC
      WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLBASIC(
    acct_ent_date,       acct_of_cd,             acct_of_cd_sw,
    actual_renew_no,     address1,               address2,
    address3,            ann_prem_amt,           ann_tsi_amt,
    assd_no,             auto_renew_flag,  co_insurance_sw,
    cred_branch,         designation,   discount_sw,
    dist_flag,           eff_date,    eis_flag,
    endt_expiry_date,    endt_expiry_tag,  endt_iss_cd,
    endt_seq_no,         endt_type,    endt_yy,
    expiry_date,         expiry_tag,    fleet_print_tag,
    foreign_acc_sw,      incept_date,   incept_tag,
    industry_cd,         invoice_sw,    issue_date,
    issue_yy,   iss_cd,     label_tag,
    line_cd,    manual_renew_no,  mortg_name,
    no_of_items,   old_assd_no,   pack_pol_flag,
    place_cd,   polendt_printed_cnt, polendt_printed_date,
    pol_flag,            pol_seq_no,    pool_pol_no,
    prem_amt,            prem_warr_tag,   prorate_flag,
    prov_prem_pct,       prov_prem_tag,   qd_flag,
    ref_open_pol_no,     ref_pol_no,    region_cd,
    reg_policy_sw,       renew_flag,    renew_no,
    short_rt_percent, spld_approval,   spld_date,
    spld_flag,           spld_user_id,   subline_cd,
    subline_type_cd,     surcharge_sw,   tsi_amt,
    type_cd,             validate_tag,   with_tariff_sw,
    old_address1,  old_address2,   old_address3,
    policy_id,  back_stat,   booking_mth,  -- mod2 start
    booking_year, cancel_date,   claims_extract_tag,
    comp_sw,  cpi_branch_cd,   cpi_rec_no,
    last_upd_date, old_pol_flag,   orig_policy_id,
    par_id,  reinstatement_date,  ren_notice_cnt,
    ren_notice_date, renew_extract_tag,  risk_tag,
    spld_acct_ent_date,  user_id,   -- mod2 end
 settling_agent_cd,survey_agent_cd,
    extract_id)
VALUES(
    A.acct_ent_date,       A.acct_of_cd,             A.acct_of_cd_sw,
    A.actual_renew_no,     A.address1,               A.address2,
    A.address3,            A.ann_prem_amt,           A.ann_tsi_amt,
    A.assd_no,             A.auto_renew_flag,  A.co_insurance_sw,
    A.cred_branch,         A.designation,   A.discount_sw,
    A.dist_flag,           A.eff_date,    A.eis_flag,
    A.endt_expiry_date,    A.endt_expiry_tag,  A.endt_iss_cd,
    A.endt_seq_no,         A.endt_type,    A.endt_yy,
    A.expiry_date,         A.expiry_tag,    A.fleet_print_tag,
    A.foreign_acc_sw,      A.incept_date,   A.incept_tag,
    A.industry_cd,         A.invoice_sw,    A.issue_date,
    A.issue_yy,     A.iss_cd,     A.label_tag,
    A.line_cd,     A.manual_renew_no,  A.mortg_name,
    A.no_of_items,    A.old_assd_no,   A.pack_pol_flag,
    A.place_cd,     A.polendt_printed_cnt, A.polendt_printed_date,
    A.pol_flag,            A.pol_seq_no,    A.pool_pol_no,
    A.prem_amt,            A.prem_warr_tag,   A.prorate_flag,
    A.prov_prem_pct,       A.prov_prem_tag,   A.qd_flag,
    A.ref_open_pol_no,     A.ref_pol_no,    A.region_cd,
    A.reg_policy_sw,       A.renew_flag,    A.renew_no,
    A.short_rt_percent,   A.spld_approval,   A.spld_date,
    A.spld_flag,           A.spld_user_id,   A.subline_cd,
    A.subline_type_cd,     A.surcharge_sw,   A.tsi_amt,
    A.type_cd,             A.validate_tag,   A.with_tariff_sw,
    A.old_address1,    A.old_address2,   A.old_address3,
    A.policy_id,    A.back_stat,    A.booking_mth,  -- mod2 start
    A.booking_year,   A.cancel_date,   A.claims_extract_tag,
    A.comp_sw,    A.cpi_branch_cd,   A.cpi_rec_no,
    A.last_upd_date,   A.old_pol_flag,   A.orig_policy_id,
    A.par_id,    A.reinstatement_date,   A.ren_notice_cnt,
    A.ren_notice_date,   A.renew_extract_tag,   A.risk_tag,
    A.spld_acct_ent_date,   A.user_id,  -- mod2 end
 A.settling_agent_cd,A.survey_agent_cd,
    v_extract_id);
END LOOP;

--end extract_gipi_polbas_rec

--start_extract_gipi_parlist --rollie10172003
FOR A IN ( SELECT A.line_cd  line_cd, A.iss_cd     iss_cd        ,
            A.par_yy   par_yy, A.par_seq_no par_seq_no, A.quote_seq_no quote_seq_no,
               A.par_type par_type, A.assign_sw  assign_sw,     A.par_status   par_status,
            A.assd_no  assd_no, A.quote_id   quote_id,     A.underwriter  underwriter,
            A.remarks  remarks, A.address1   address1,     A.address2     address2,
            A.address3 address3, A.load_tag   load_tag,     A.cpi_rec_no   cpi_rec_no,
               A.cpi_branch_cd cpi_branch_cd, A.insp_no   insp_no, A.old_par_status  old_par_status, -- mod4 start
   A.pack_par_id pack_par_id, A.par_id    par_id, A.upload_no upload_no -- mod4 end
             FROM GIPI_PARLIST A, GIPI_POLBASIC b
            WHERE b.policy_id = p_policy_id
     AND A.par_id = b.par_id  ) LOOP

INSERT INTO GIXX_PARLIST(
      extract_id,     line_cd,      iss_cd         ,
    par_yy,     par_seq_no,      quote_seq_no,
       par_type,    assign_sw,      par_status,
       assd_no,     quote_id,       underwriter,
       remarks,     address1,      address2,
       address3,    load_tag,      cpi_rec_no,
       cpi_branch_cd,     insp_no,     old_par_status, -- mod4 start
 pack_par_id,    par_id,     upload_no,
 policy_id)  -- mod4 end
VALUES(
       v_extract_id,          A.line_cd,            A.iss_cd         ,
       A.par_yy,           A.par_seq_no,         A.quote_seq_no,
       A.par_type,           A.assign_sw,     A.par_status,
       A.assd_no,            A.quote_id,     A.underwriter,
       A.remarks,           A.address1,     A.address2,
       A.address3,           A.load_tag,     A.cpi_rec_no,
       A.cpi_branch_cd,   A.insp_no,     A.old_par_status, -- mod4 start
       A.pack_par_id,   A.par_id,  A.upload_no,
    p_policy_id);  -- mod4 end
END LOOP;
--end_extract_gipi_parlist --rollie10172003
--begin_extract_gipi_accident_item_rec

FOR A IN (SELECT ac_class_cd,   age,    civil_status,
         date_of_birth,  destination,  group_print_sw,
        height,   item_no,   level_cd,
        monthly_salary, no_of_persons,  parent_level_cd,
        position_cd,  salary_grade,  sex,
     weight
     FROM GIPI_ACCIDENT_ITEM
      WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ACCIDENT_ITEM(
    ac_class_cd,    age,    civil_status,
    date_of_birth,  destination,  group_print_sw,
    height,    item_no,   level_cd,
    monthly_salary,  no_of_persons,  parent_level_cd,
    position_cd,   salary_grade,  sex,
    weight,    extract_id, policy_id)
VALUES(
    A.ac_class_cd,   A.age,    A.civil_status,
    A.date_of_birth,  A.destination,  A.group_print_sw,
    A.height,   A.item_no,   A.level_cd,
    A.monthly_salary, A.no_of_persons, A.parent_level_cd,
    A.position_cd,  A.salary_grade,  A.sex,
    A.weight,   v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_accident_item_rec;


--begin_extract_gipi_aviation_item_rec

FOR A IN(SELECT deduct_text, est_util_hrs, fixed_wing,
       geog_limit,  item_no,  prev_util_hrs,
    purpose,  qualification, rec_flag,
    rotor,   total_fly_time, vessel_cd
  FROM GIPI_AVIATION_ITEM
 WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_AVIATION_ITEM(
    deduct_text,  est_util_hrs, fixed_wing,
    geog_limit,  item_no,  prev_util_hrs,
    purpose,   qualification, rec_flag,
    rotor,   total_fly_time, vessel_cd,
    extract_id, policy_id)
VALUES(
    A.deduct_text, A.est_util_hrs,   A.fixed_wing,
    A.geog_limit, A.item_no,    A.prev_util_hrs,
    A.purpose,  A.qualification,  A.rec_flag,
    A.rotor,   A.total_fly_time, A.vessel_cd,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_aviation_item_rec


--begin_extract_gipi_bank_schedule_rec

FOR A IN(SELECT bank,       bank_address,  bank_eff_date,
       bank_endt_seq_no, bank_issue_yy,  bank_iss_cd,
       bank_item_no,  bank_line_cd,  bank_pol_seq_no,
       bank_renew_no,  bank_subline_cd, cash_in_transit,
       cash_in_vault,  include_tag,  remarks
       FROM GIPI_BANK_SCHEDULE
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_BANK_SCHEDULE(
    bank,       bank_address,  bank_eff_date,
    bank_endt_seq_no, bank_issue_yy,  bank_iss_cd,
    bank_item_no,  bank_line_cd,  bank_pol_seq_no,
    bank_renew_no,  bank_subline_cd, cash_in_transit,
    cash_in_vault,  include_tag,  remarks,
    extract_id, policy_id)
VALUES(
    A.bank,       A.bank_address,  A.bank_eff_date,
    A.bank_endt_seq_no, A.bank_issue_yy, A.bank_iss_cd,
    A.bank_item_no,  A.bank_line_cd,  A.bank_pol_seq_no,
    A.bank_renew_no,  A.bank_subline_cd, A.cash_in_transit,
    A.cash_in_vault,  A.include_tag,  A.remarks,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_bank_schedule_rec


--begin_extract_gipi_beneficiary_rec

FOR A IN(SELECT adult_sw,      age,       beneficiary_addr,
       beneficiary_name, beneficiary_no,  civil_status,
       date_of_birth,  delete_sw,   item_no,
       position_cd,  relation,   remarks,
    sex,   cpi_rec_no,  cpi_branch_cd -- mod5 start/end
       FROM GIPI_BENEFICIARY
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_BENEFICIARY(
    adult_sw,      age,       beneficiary_addr,
    beneficiary_name, beneficiary_no,  civil_status,
    date_of_birth,  delete_sw,   item_no,
    position_cd,   relation,   remarks,
    sex,    cpi_rec_no,   cpi_branch_cd, -- mod5 start/end
    extract_id, policy_id)
VALUES(
    A.adult_sw,      A.age,       A.beneficiary_addr,
    A.beneficiary_name, A.beneficiary_no, A.civil_status,
    A.date_of_birth,  A.delete_sw,  A.item_no,
    A.position_cd,  A.relation,   A.remarks,
    A.sex,   A.cpi_rec_no,  A.cpi_branch_cd, -- mod5 start/end
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_beneficiary_rec

--begin_extract_gipi_bond_basic

FOR A IN(SELECT coll_flag, clause_type, obligee_no, prin_id, val_period_unit,
                val_period, np_no, contract_dtl, contract_date, co_prin_sw,
    waiver_limit, indemnity_text, bond_dtl, endt_eff_date, remarks
       FROM GIPI_BOND_BASIC
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_BOND_BASIC(
    extract_id, obligee_no, prin_id, coll_flag, clause_type, val_period_unit, val_period,
    policy_id, np_no, contract_dtl, contract_date, co_prin_sw, waiver_limit, indemnity_text,
    bond_dtl, endt_eff_date, remarks)
VALUES(
    v_extract_id, A.obligee_no, A.prin_id, A.coll_flag, A.clause_type, A.val_period_unit,
    A.val_period, p_policy_id, A.np_no, A.contract_dtl, A.contract_date, A.co_prin_sw,
    A.waiver_limit, A.indemnity_text, A.bond_dtl, A.endt_eff_date, A.remarks);
END LOOP;

--end_extract_gipi_bond_basic

--begin_extract_gipi_cargo_rec

FOR A IN(SELECT bl_awb,         cargo_class_cd,  cargo_type,
       deduct_text,      destn,       eta,
       etd,        geog_cd,   item_no,
       lc_no,        origin,       pack_method,
       print_tag,       rec_flag,   tranship_destination,
    tranship_origin,  vessel_cd,   voyage_no
       FROM GIPI_CARGO
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CARGO(
    bl_awb,         cargo_class_cd,  cargo_type,
    deduct_text,       destn,       eta,
    etd,         geog_cd,   item_no,
    lc_no,        origin,       pack_method,
    print_tag,       rec_flag,   tranship_destination,
    tranship_origin,   vessel_cd,   voyage_no,
    extract_id, policy_id)
VALUES(
    A.bl_awb,      A.cargo_class_cd, A.cargo_type,
    A.deduct_text,    A.destn,      A.eta,
    A.etd,      A.geog_cd,   A.item_no,
    A.lc_no,        A.origin,   A.pack_method,
    A.print_tag,    A.rec_flag,   A.tranship_destination,
    A.tranship_origin,  A.vessel_cd,  A.voyage_no,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_cargo_rec


--begin_extract_gipi_cargo_carrier_rec

FOR A IN(SELECT delete_sw, destn,  eta,
       etd,  item_no, origin,
    vessel_cd, voy_limit, vessel_limit_of_liab

       FROM GIPI_CARGO_CARRIER
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CARGO_CARRIER(
    delete_sw, destn,  eta,
    etd,   item_no, origin,
    vessel_cd, voy_limit, vessel_limit_of_liab,
    extract_id, policy_id)
VALUES(
    A.delete_sw,   A.destn,   A.eta,
    A.etd,    A.item_no,  A.origin,
    A.vessel_cd,   A.voy_limit,  A.vessel_limit_of_liab,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_cargo_carrier_rec;


--begin_extract_gipi_casualty_item_rec

FOR A IN(SELECT capacity_cd,      conveyance_info,     interest_on_premises,
       item_no,    limit_of_liability,        LOCATION,
       property_no,   property_no_type,     section_line_cd,
    section_or_hazard_cd,   section_or_hazard_info,    section_subline_cd
       FROM GIPI_CASUALTY_ITEM
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CASUALTY_ITEM(
    capacity_cd,       conveyance_info,     interest_on_premises,
    item_no,     limit_of_liability,        LOCATION,
    property_no,       property_no_type,     section_line_cd,
    section_or_hazard_cd,    section_or_hazard_info,    section_subline_cd,
    extract_id, policy_id)
VALUES(
    A.capacity_cd,      A.conveyance_info,     A.interest_on_premises,
    A.item_no,    A.limit_of_liability,    A.LOCATION,
    A.property_no,   A.property_no_type,     A.section_line_cd,
    A.section_or_hazard_cd,  A.section_or_hazard_info,  A.section_subline_cd,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_casualty_item_rec


--begin_extract_gipi_casualty_personnel_rec

FOR A IN(SELECT amount_covered,  capacity_cd,  delete_sw,
       include_tag,  item_no,   NAME,
       personnel_no,  remarks
       FROM GIPI_CASUALTY_PERSONNEL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_CASUALTY_PERSONNEL(
    amount_covered,  capacity_cd,  delete_sw,
    include_tag,   item_no,   NAME,
    personnel_no,  remarks,   extract_id,
 policy_id)
VALUES(
    A.amount_covered, A.capacity_cd,  A.delete_sw,
    A.include_tag,  A.item_no,   A.NAME,
    A.personnel_no,  A.remarks,   v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_casualty_personnel_rec


--begin_extract_gipi_comm_invoice_rec

FOR A IN(SELECT bond_rate,        commission_amt,  default_intm,
       gacc_tran_id,    intrmdry_intm_no,    iss_cd,
       parent_intm_no,    premium_amt,   prem_seq_no,
    share_percentage,  wholding_tax
       FROM GIPI_COMM_INVOICE
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_COMM_INVOICE(
    bond_rate,        commission_amt,  default_intm,
    gacc_tran_id,    intrmdry_intm_no,    iss_cd,
    parent_intm_no,    premium_amt,   prem_seq_no,
    share_percentage,    wholding_tax,  extract_id,
 policy_id)
VALUES(
    A.bond_rate,        A.commission_amt, A.default_intm,
    A.gacc_tran_id,    A.intrmdry_intm_no,  A.iss_cd,
    A.parent_intm_no,   A.premium_amt,  A.prem_seq_no,
    A.share_percentage,  A.wholding_tax,  v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_comm_invoice_rec


--begin_extract_gipi_comm_inv_peril_rec

FOR A IN(SELECT commission_amt,  commission_rt,  intrmdry_intm_no,
       iss_cd,    peril_cd,   premium_amt,
    prem_seq_no,  wholding_tax
       FROM GIPI_COMM_INV_PERIL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_COMM_INV_PERIL(
    commission_amt,   commission_rt,  intrmdry_intm_no,
    iss_cd,    peril_cd,   premium_amt,
    prem_seq_no,   wholding_tax,  extract_id,
 policy_id)
VALUES(
    A.commission_amt,   A.commission_rt, A.intrmdry_intm_no,
    A.iss_cd,    A.peril_cd,   A.premium_amt,
    A.prem_seq_no,   A.wholding_tax,  v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_comm_inv_peril_rec


--begin_extract_gipi_cosigntry_rec

FOR A IN(SELECT assd_no,    bonds_flag,    bonds_ri_flag,
       cosign_id,    indem_flag,    policy_id
       FROM GIPI_COSIGNTRY
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_COSIGNTRY(
    assd_no,     bonds_flag,    bonds_ri_flag,
    cosign_id,    indem_flag,    extract_id,
 policy_id)
VALUES(
    A.assd_no,    A.bonds_flag,    A.bonds_ri_flag,
    A.cosign_id,    A.indem_flag,    v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_cosigntry_rec


--begin_extract_gipi_co_insurer_rec

FOR A IN(SELECT co_ri_cd,   co_ri_prem_amt,  co_ri_shr_pct,
       co_ri_tsi_amt
       FROM GIPI_CO_INSURER
--     WHERE par_id  = p_policy_id)LOOP  edited by rollie 10172003
          WHERE policy_id = p_policy_id) LOOP

INSERT INTO GIXX_CO_INSURER(
    co_ri_cd,   co_ri_prem_amt,  co_ri_shr_pct,
    co_ri_tsi_amt, extract_id, policy_id)
VALUES(
    A.co_ri_cd,   A.co_ri_prem_amt, A.co_ri_shr_pct,
    A.co_ri_tsi_amt, v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_co_insurer_rec


--begin_extract_gipi_deductibles_rec

FOR A IN(SELECT deductible_amt,  deductible_rt,  deductible_text,
       ded_deductible_cd, ded_line_cd,  ded_subline_cd,
       item_no,   peril_cd
       FROM GIPI_DEDUCTIBLES
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_DEDUCTIBLES(
    deductible_amt,  deductible_rt,  deductible_text,
    ded_deductible_cd, ded_line_cd,  ded_subline_cd,
    item_no,    peril_cd,   extract_id, policy_id)
VALUES(
    A.deductible_amt, A.deductible_rt, A.deductible_text,
    A.ded_deductible_cd, A.ded_line_cd,  A.ded_subline_cd,
    A.item_no,   A.peril_cd,   v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_deductibles_rec


--begin_extract_gipi_endttext_rec

FOR A IN(SELECT endt_tax,   endt_text,   endt_text01,
       endt_text02,  endt_text03,  endt_text04,
       endt_text05,  endt_text06,  endt_text07,
       endt_text08,  endt_text09,  endt_text10,
       endt_text11,  endt_text12,  endt_text13,
       endt_text14,  endt_text15,  endt_text16,
       endt_text17, cpi_rec_no, -- mod6 start
    cpi_branch_cd     -- mod6 end
       FROM GIPI_ENDTTEXT
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ENDTTEXT(
    endt_tax,   endt_text,   endt_text01,
    endt_text02,   endt_text03,  endt_text04,
    endt_text05,   endt_text06,  endt_text07,
    endt_text08,   endt_text09,  endt_text10,
    endt_text11,   endt_text12,  endt_text13,
    endt_text14,   endt_text15,  endt_text16,
    endt_text17,   cpi_rec_no, -- mod6 start
 cpi_branch_cd,  extract_id,
 policy_id)   -- mod6 end
VALUES(
    A.endt_tax,   A.endt_text,  A.endt_text01,
    A.endt_text02,  A.endt_text03,  A.endt_text04,
    A.endt_text05,  A.endt_text06,  A.endt_text07,
    A.endt_text08,  A.endt_text09,  A.endt_text10,
    A.endt_text11,  A.endt_text12,  A.endt_text13,
    A.endt_text14,  A.endt_text15,  A.endt_text16,
    A.endt_text17,  A.cpi_rec_no, -- mod6 start
    A.cpi_branch_cd, v_extract_id,
 p_policy_id);   -- mod6 end
END LOOP;

--end_extract_gipi_endttext_rec


--begin_extract_gipi_engg_basic_rec

FOR A IN(SELECT construct_end_date,   construct_start_date,  contract_proj_buss_title,
       engg_basic_infonum,   maintain_end_date,     maintain_start_date,
       mbi_policy_no,    site_location,   testing_end_date,
       testing_start_date,   time_excess,    weeks_test
       FROM GIPI_ENGG_BASIC
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ENGG_BASIC(
    construct_end_date,   construct_start_date,  contract_proj_buss_title,
    engg_basic_infonum,   maintain_end_date,     maintain_start_date,
    mbi_policy_no,    site_location,   testing_end_date,
    testing_start_date,   time_excess,    weeks_test,
    extract_id, policy_id)
VALUES(
    A.construct_end_date,  A.construct_start_date, A.contract_proj_buss_title,
    A.engg_basic_infonum,  A.maintain_end_date,     A.maintain_start_date,
    A.mbi_policy_no,    A.site_location,   A.testing_end_date,
    A.testing_start_date,  A.time_excess,   A.weeks_test,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_engg_basic_rec


--begin_extract_gipi_fireitem_rec

FOR A IN(SELECT assignee,     block_id,      block_no,
       construction_cd,   construction_remarks,   district_no,
       eq_zone,     flood_zone,      front,
       fr_item_type,    item_no,       LEFT,
    loc_risk1,     loc_risk2,      loc_risk3,
    occupancy_cd,    occupancy_remarks,    rear,
    RIGHT,      tarf_cd,       tariff_zone,
    typhoon_zone
       FROM GIPI_FIREITEM
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_FIREITEM(
    assignee,     block_id,      block_no,
    construction_cd,    construction_remarks,   district_no,
    eq_zone,      flood_zone,      front,
    fr_item_type,    item_no,       LEFT,
    loc_risk1,     loc_risk2,      loc_risk3,
    occupancy_cd,    occupancy_remarks,    rear,
    RIGHT,      tarf_cd,       tariff_zone,
    typhoon_zone,    extract_id, policy_id)
VALUES(
    A.assignee,     A.block_id,      A.block_no,
    A.construction_cd,  A.construction_remarks, A.district_no,
    A.eq_zone,     A.flood_zone,     A.front,
    A.fr_item_type,    A.item_no,      A.LEFT,
    A.loc_risk1,     A.loc_risk2,      A.loc_risk3,
    A.occupancy_cd,    A.occupancy_remarks,    A.rear,
    A.RIGHT,      A.tarf_cd,      A.tariff_zone,
    A.typhoon_zone,    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_fireitem_rec


--begin_extract_gipi_grouped_items_rec

FOR A IN(SELECT age,    amount_coverage, civil_status,
       date_of_birth,  delete_sw,    grouped_item_no,
       group_cd,   include_tag,  grouped_item_title,
       item_no,   line_cd,   position_cd,
    remarks,   salary,   salary_grade,
    sex,    subline_cd,  principal_cd,  -- mod1 start
    pack_ben_cd,   from_date,  TO_DATE,  -- mod1 end
 ann_tsi_amt, ann_prem_amt, tsi_amt,
 prem_amt
       FROM GIPI_GROUPED_ITEMS
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_GROUPED_ITEMS(
    age,     amount_coverage, civil_status,
    date_of_birth,  delete_sw,    grouped_item_no,
    group_cd,   include_tag,  grouped_item_title,
    item_no,    line_cd,   position_cd,
    remarks,    salary,   salary_grade,
    sex,     subline_cd,  principal_cd,  -- mod1 start
    pack_ben_cd,   from_date,  TO_DATE, -- mod1 end
 ann_tsi_amt, ann_prem_amt, tsi_amt,
 prem_amt, extract_id, policy_id)
VALUES(
    A.age,    A.amount_coverage, A.civil_status,
    A.date_of_birth,  A.delete_sw,   A.grouped_item_no,
    A.group_cd,   A.include_tag,  A.grouped_item_title,
    A.item_no,   A.line_cd,   A.position_cd,
    A.remarks,   A.salary,   A.salary_grade,
    A.sex,  A.subline_cd,  A.principal_cd, -- mod1 start
    A.pack_ben_cd,  A.from_date,   A.TO_DATE, -- mod1 end
   A.ann_tsi_amt, A.ann_prem_amt, A.tsi_amt,
 A.prem_amt,v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_grouped_items_rec


--begin_extract_gipi_grp_items_beneficiary_rec

FOR A IN(SELECT age,     beneficiary_addr,  beneficiary_name,
       beneficiary_no,   civil_status,   date_of_birth,
       grouped_item_no,  item_no,    relation,
    sex
       FROM GIPI_GRP_ITEMS_BENEFICIARY
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_GRP_ITEMS_BENEFICIARY(
    age,         beneficiary_addr,  beneficiary_name,
    beneficiary_no,   civil_status,   date_of_birth,
    grouped_item_no,   item_no,    relation,
    sex,      extract_id, policy_id)
VALUES(
    A.age,         A.beneficiary_addr,  A.beneficiary_name,
    A.beneficiary_no,   A.civil_status,   A.date_of_birth,
    A.grouped_item_no,   A.item_no,    A.relation,
    A.sex,      v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_grp_items_beneficiary_rec


--begin_extract_gipi_invoice_rec

FOR A IN(SELECT acct_ent_date,      approval_cd,  bond_rate,
       bond_tsi_amt,      card_name,  card_no,
       currency_cd,     currency_rt,  due_date,
       expiry_date,     insured,   invoice_printed_cnt,
       invoice_printed_date,  iss_cd,   item_grp,
       last_upd_date,     notarial_fee, other_charges,
       payt_terms,      pay_type,  policy_currency,
       prem_amt,      prem_seq_no,  property,
       ref_inv_no,      remarks,   ri_comm_amt,
       tax_amt, ri_comm_vat -- jhing 03.29.2016  added ri_comm_vat REPUBLIC 20996
  FROM GIPI_INVOICE
 WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_INVOICE(
    acct_ent_date,      approval_cd,  bond_rate,
    bond_tsi_amt,      card_name,  card_no,
    currency_cd,       currency_rt,  due_date,
    expiry_date,       insured,   invoice_printed_cnt,
    invoice_printed_date,   iss_cd,   item_grp,
    last_upd_date,     notarial_fee, other_charges,
    payt_terms,      pay_type,  policy_currency,
    prem_amt,      prem_seq_no,  property,
    ref_inv_no,      remarks,   ri_comm_amt,
    tax_amt,       extract_id, policy_id, ri_comm_vat )  -- jhing 03.29.2016  added ri_comm_vat REPUBLIC 20996
VALUES(
    A.acct_ent_date,      A.approval_cd, A.bond_rate,
    A.bond_tsi_amt,      A.card_name,  A.card_no,
    A.currency_cd,     A.currency_rt, A.due_date,
    A.expiry_date,     A.insured,  A.invoice_printed_cnt,
    A.invoice_printed_date, A.iss_cd,  A.item_grp,
    A.last_upd_date,     A.notarial_fee, A.other_charges,
    A.payt_terms,     A.pay_type,  A.policy_currency,
    A.prem_amt,      A.prem_seq_no, A.property,
    A.ref_inv_no,     A.remarks,  A.ri_comm_amt,
    A.tax_amt,      v_extract_id, p_policy_id , A.ri_comm_vat ); -- jhing 03.29.2016  added ri_comm_vat REPUBLIC 20996
END LOOP;

--end_extract_gipi_invoice_rec


--begin_extract_gipi_invperil_rec

FOR A IN(SELECT x.iss_cd,   x.item_grp,  x.peril_cd,
       x.prem_amt,   x.prem_seq_no, x.ri_comm_amt,
       x.ri_comm_rt, x.tsi_amt
       FROM GIPI_INVPERIL x,
       GIPI_INVOICE  y
     WHERE x.iss_cd    = y.iss_cd
      AND x.prem_seq_no = y.prem_seq_no
   AND y.policy_id   = p_policy_id)LOOP

INSERT INTO GIXX_INVPERIL(
    iss_cd,    item_grp,     peril_cd,
    prem_amt,   prem_seq_no,    ri_comm_amt,
    ri_comm_rt,   tsi_amt,     extract_id,
 policy_id)
VALUES(
    A.iss_cd,   A.item_grp,  A.peril_cd,
    A.prem_amt,   A.prem_seq_no, A.ri_comm_amt,
    A.ri_comm_rt,  A.tsi_amt,  v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_invperil_rec


--begin_extract_gipi_inv_tax_rec

FOR A IN(SELECT x.iss_cd,     x.item_grp,  x.fixed_tax_allocation,
       x.line_cd,     x.prem_seq_no, x.rate,
       x.tax_allocation,  x.tax_amt,  x.tax_cd,
       x.tax_id
       FROM GIPI_INV_TAX x,
            GIPI_INVOICE y
     WHERE x.iss_cd    = y.iss_cd
         AND x.prem_seq_no = y.prem_seq_no
      AND y.policy_id   = p_policy_id)LOOP

INSERT INTO GIXX_INV_TAX(
    iss_cd,      item_grp,  fixed_tax_allocation,
    line_cd,      prem_seq_no,  rate,
    tax_allocation,    tax_amt,   tax_cd,
    tax_id,      extract_id, policy_id)
VALUES(
    A.iss_cd,   A.item_grp,   A.fixed_tax_allocation,
    A.line_cd,   A.prem_seq_no,  A.rate,
    A.tax_allocation, A.tax_amt,   A.tax_cd,
    A.tax_id,   v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_inv_tax_rec


--begin_extract_gipi_item_rec

FOR A IN(SELECT ann_prem_amt,        ann_tsi_amt,        changed_tag,
       comp_sw,      coverage_cd,     currency_cd,
       currency_rt,     discount_sw,       from_date,
       group_cd,      item_desc,       item_desc2,
       item_grp,      item_no,         item_title,
       mc_coc_printed_cnt,    mc_coc_printed_date,   other_info,
       pack_line_cd,     pack_subline_cd,    prem_amt,
       prorate_flag,     rec_flag,     region_cd,
       short_rt_percent,    revrs_bndr_print_date, surcharge_sw,
       TO_DATE,      tsi_amt,               risk_no,
    risk_item_no, pack_ben_cd
       FROM GIPI_ITEM
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ITEM(
    ann_prem_amt,        ann_tsi_amt,           changed_tag,
    comp_sw,          coverage_cd,        currency_cd,
    currency_rt,      discount_sw,          from_date,
    group_cd,      item_desc,          item_desc2,
    item_grp,      item_no,            item_title,
    mc_coc_printed_cnt,    mc_coc_printed_date,      other_info,
    pack_line_cd,     pack_subline_cd,       prem_amt,
    prorate_flag,     rec_flag,        region_cd,
    short_rt_percent,    revrs_bndr_print_date,    surcharge_sw,
    TO_DATE,       tsi_amt,         extract_id,
    risk_no,                risk_item_no, pack_ben_cd,
 policy_id)
VALUES(
    A.ann_prem_amt,        A.ann_tsi_amt,        A.changed_tag,
    A.comp_sw,      A.coverage_cd,     A.currency_cd,
    A.currency_rt,     A.discount_sw,       A.from_date,
    A.group_cd,      A.item_desc,          A.item_desc2,
    A.item_grp,      A.item_no,         A.item_title,
    A.mc_coc_printed_cnt,   A.mc_coc_printed_date,   A.other_info,
    A.pack_line_cd,     A.pack_subline_cd,    A.prem_amt,
    A.prorate_flag,     A.rec_flag,        A.region_cd,
    A.short_rt_percent,    A.revrs_bndr_print_date,   A.surcharge_sw,
    A.TO_DATE,      A.tsi_amt,      v_extract_id,
    A.risk_no,              A.risk_item_no,  a.pack_ben_cd,
 p_policy_id);
END LOOP;

--end_extract_gipi_item_rec


--begin_extract_gipi_item_ves_rec

FOR A IN(SELECT deduct_text,   dry_date,    dry_place,
       geog_limit,    item_no,    rec_flag,
       vessel_cd
       FROM GIPI_ITEM_VES
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ITEM_VES(
    deduct_text,    dry_date,    dry_place,
    geog_limit,    item_no,    rec_flag,
    vessel_cd,      extract_id, policy_id)
VALUES(
    A.deduct_text,   A.dry_date,   A.dry_place,
    A.geog_limit,   A.item_no,   A.rec_flag,
    A.vessel_cd,      v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_item_ves_rec


--begin_extract_gipi_itmperil_rec

FOR A IN(SELECT ann_prem_amt, ann_tsi_amt,    as_charge_sw,
       comp_rem,  discount_sw,    item_no,
       line_cd,  peril_cd,     prem_amt,
       prem_rt,  prt_flag,     rec_flag,
       ri_comm_amt, ri_comm_rate,    surcharge_sw,
       tarf_cd,  tsi_amt
       FROM GIPI_ITMPERIL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ITMPERIL(
    ann_prem_amt, ann_tsi_amt,    as_charge_sw,
    comp_rem,  discount_sw,    item_no,
    line_cd,   peril_cd,     prem_amt,
    prem_rt,      prt_flag,     rec_flag,
    ri_comm_amt,     ri_comm_rate,    surcharge_sw,
    tarf_cd,   tsi_amt,     extract_id,
 policy_id)
VALUES(
    A.ann_prem_amt, A.ann_tsi_amt,    A.as_charge_sw,
    A.comp_rem,  A.discount_sw,    A.item_no,
    A.line_cd,  A.peril_cd,     A.prem_amt,
    A.prem_rt,     A.prt_flag,     A.rec_flag,
    A.ri_comm_amt,   A.ri_comm_rate,    A.surcharge_sw,
    A.tarf_cd,  A.tsi_amt,     v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_itmperil_rec


--begin_extract_gipi_lim_liab_rec

FOR A IN(SELECT currency_cd,    currency_rt,  liab_cd,
       limit_liability,   line_cd
       FROM GIPI_LIM_LIAB
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_LIM_LIAB(
    currency_cd,    currency_rt,  liab_cd,
    limit_liability,   line_cd,   extract_id,
 policy_id)
VALUES(
    A.currency_cd,  A.currency_rt, A.liab_cd,
    A.limit_liability, A.line_cd,  v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_lim_liab_rec


--begin_extract_gipi_location_rec

FOR A IN(SELECT item_no, province_cd, region_cd
         FROM GIPI_LOCATION
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_LOCATION(
    item_no,  province_cd, region_cd, extract_id, policy_id)
VALUES(
    A.item_no, A.province_cd, A.region_cd, v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_location_rec


--begin_extract_gipi_main_co_ins_rec

FOR A IN(SELECT prem_amt, tsi_amt
         FROM GIPI_MAIN_CO_INS
    WHERE policy_id = p_policy_id)LOOP
     --WHERE par_id = p_policy_id)LOOP --edited by rollie 10172003

INSERT INTO GIXX_MAIN_CO_INS(
    prem_amt, tsi_amt, extract_id, policy_id)
VALUES(
    A.prem_amt, A.tsi_amt, v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_main_co_ins_rec


--begin_extract_gipi_mcacc_rec

FOR A IN(SELECT accessory_cd, acc_amt, delete_sw,
       item_no
       FROM GIPI_MCACC
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_MCACC(
    accessory_cd, acc_amt,  delete_sw,
    item_no,   extract_id, policy_id)
VALUES(
    A.accessory_cd, A.acc_amt,  A.delete_sw,
    A.item_no,  v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_mcacc_rec


--begin_extract_gipi_mortgagee_rec

FOR A IN(SELECT amount,     delete_sw,  iss_cd,
       item_no,    mortg_cd,  remarks
       FROM GIPI_MORTGAGEE
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_MORTGAGEE(
    amount,     delete_sw,  iss_cd,
    item_no,     mortg_cd,  remarks,
    extract_id, policy_id)
VALUES(
    A.amount,     A.delete_sw,  A.iss_cd,
    A.item_no,     A.mortg_cd,  A.remarks,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_mortgagee_rec


--begin_extract_gipi_open_cargo_rec

FOR A IN(SELECT cargo_class_cd,  geog_cd, rec_flag
       FROM GIPI_OPEN_CARGO
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_CARGO(
    cargo_class_cd,  geog_cd,  rec_flag,  extract_id, policy_id)
VALUES(
    A.cargo_class_cd, A.geog_cd,  A.rec_flag,  v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_open_cargo_rec


--begin_extract_gipi_open_liab_rec

FOR A IN(SELECT currency_cd,  currency_rt,  geog_cd,
       limit_liability, multi_geog_tag,  prem_tag,
    rec_flag,   voy_limit,   with_invoice_tag
       FROM GIPI_OPEN_LIAB
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_LIAB(
    currency_cd,      currency_rt,  geog_cd,
    limit_liability,  multi_geog_tag,  prem_tag,
    rec_flag,   voy_limit,   with_invoice_tag,
    extract_id, policy_id)
VALUES(
    A.currency_cd,  A.currency_rt,  A.geog_cd,
    A.limit_liability, A.multi_geog_tag, A.prem_tag,
    A.rec_flag,   A.voy_limit,  A.with_invoice_tag,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_open_liab_rec


--begin_extract_gipi_open_peril_rec

FOR A IN(SELECT geog_cd,  line_cd, peril_cd,
         prem_rate,  rec_flag, remarks,
         with_invoice_tag
       FROM GIPI_OPEN_PERIL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_PERIL(
    geog_cd,     line_cd,  peril_cd,
    prem_rate,       rec_flag,  remarks,
    with_invoice_tag,  extract_id, policy_id)
VALUES(
    A.geog_cd,   A.line_cd,  A.peril_cd,
    A.prem_rate,        A.rec_flag,  A.remarks,
    A.with_invoice_tag,  v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_open_peril_rec


--begin_extract_gipi_open_policy_rec

FOR A IN(SELECT decltn_no,    eff_date,      line_cd,
       op_issue_yy,   op_iss_cd,  op_pol_seqno,
       op_renew_no,   op_subline_cd
       FROM GIPI_OPEN_POLICY
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_OPEN_POLICY(
    decltn_no,    eff_date,      line_cd,
    op_issue_yy,    op_iss_cd,  op_pol_seqno,
    op_renew_no,    op_subline_cd, extract_id,
 policy_id)
VALUES(
    A.decltn_no,    A.eff_date,  A.line_cd,
    A.op_issue_yy,   A.op_iss_cd,  A.op_pol_seqno,
    A.op_renew_no,   A.op_subline_cd, v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_open_policy_rec





--begin_extract_gipi_orig_comm_invoice_rec
--check_me
FOR A IN(SELECT commission_amt,  intrmdry_intm_no, iss_cd,
       item_grp,   premium_amt,  prem_seq_no,
       share_percentage, wholding_tax
       FROM GIPI_ORIG_COMM_INVOICE
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INVOICE(
    commission_amt,   intrmdry_intm_no, iss_cd,
    item_grp,   premium_amt,  prem_seq_no,
    share_percentage, wholding_tax,  extract_id,
 policy_id)
VALUES(
    A.commission_amt,  A.intrmdry_intm_no, A.iss_cd,
    A.item_grp,   A.premium_amt,  A.prem_seq_no,
    A.share_percentage, A.wholding_tax,  v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_orig_comm_invoice_rec


--begin_extract_gipi_orig_comm_inv_peril_rec
--check_me
FOR A IN(SELECT commission_amt,  commission_rt,  intrmdry_intm_no,
       iss_cd,    item_grp,   peril_cd,
       premium_amt,  prem_seq_no,  wholding_tax
       FROM GIPI_ORIG_COMM_INV_PERIL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INV_PERIL(
    commission_amt,   commission_rt,  intrmdry_intm_no,
    iss_cd,    item_grp,   peril_cd,
    premium_amt,   prem_seq_no,  wholding_tax,
    extract_id, policy_id)
VALUES(
    A.commission_amt,  A.commission_rt, A.intrmdry_intm_no,
    A.iss_cd,   A.item_grp,   A.peril_cd,
    A.premium_amt,  A.prem_seq_no,  A.wholding_tax,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_orig_comm_inv_peril_rec


--begin_extract_gipi_orig_invoice_rec
--check_me
FOR A IN(SELECT currency_cd,  currency_rt, insured,
       iss_cd,    item_grp,  other_charges,
       policy_currency, prem_amt,  prem_seq_no,
       property,   ref_inv_no,  remarks,
       ri_comm_amt,  tax_amt
       FROM GIPI_ORIG_INVOICE
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_INVOICE(
    currency_cd,   currency_rt,  insured,
    iss_cd,    item_grp,   other_charges,
    policy_currency,  prem_amt,   prem_seq_no,
    property,   ref_inv_no,   remarks,
    ri_comm_amt,   tax_amt,   extract_id,
 policy_id)
VALUES(
    A.currency_cd,  A.currency_rt,  A.insured,
    A.iss_cd,   A.item_grp,   A.other_charges,
    A.policy_currency, A.prem_amt,   A.prem_seq_no,
    A.property,   A.ref_inv_no,  A.remarks,
    A.ri_comm_amt,  A.tax_amt,   v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_orig_invoice_rec


--begin_extract_gipi_orig_invperl_rec
--check_me
FOR A IN(SELECT item_grp,    peril_cd, prem_amt,
    ri_comm_amt,   ri_comm_rt, tsi_amt
       FROM GIPI_ORIG_INVPERL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_INVPERL(
    item_grp,  peril_cd,   prem_amt,
    ri_comm_amt,  ri_comm_rt,   tsi_amt,
    extract_id, policy_id)
VALUES(
    A.item_grp,  A.peril_cd,   A.prem_amt,
    A.ri_comm_amt, A.ri_comm_rt, A.tsi_amt,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_orig_invperl_rec


--begin_extract_gipi_orig_inv_tax_rec
--check_me
FOR A IN(SELECT iss_cd,  item_grp, fixed_tax_allocation,
       line_cd, rate,  tax_allocation,
       tax_amt, tax_cd,  tax_id
       FROM GIPI_ORIG_INV_TAX
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_INV_TAX(
    iss_cd,  item_grp, fixed_tax_allocation,
    line_cd,  rate,  tax_allocation,
    tax_amt,  tax_cd,  tax_id,
    extract_id, policy_id)
VALUES(
    A.iss_cd,  A.item_grp,    A.fixed_tax_allocation,
    A.line_cd,  A.rate,     A.tax_allocation,
    A.tax_amt,  A.tax_cd,    A.tax_id,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_orig_inv_tax_rec


--begin_extract_gipi_orig_itmperil_rec
--check_me
FOR A IN(SELECT ann_prem_amt, ann_tsi_amt,  comp_rem,
       discount_sw, item_no,  line_cd,
       peril_cd,  prem_amt,  prem_rt,
       rec_flag,  ri_comm_amt, ri_comm_rate,
       surcharge_sw, tsi_amt
       FROM GIPI_ORIG_ITMPERIL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_ORIG_ITMPERIL(
    ann_prem_amt,   ann_tsi_amt,   comp_rem,
    discount_sw,    item_no,   line_cd,
    peril_cd,    prem_amt,     prem_rt,
    rec_flag,    ri_comm_amt,  ri_comm_rate,
    surcharge_sw,   tsi_amt,   extract_id,
 policy_id)
VALUES(
    A.ann_prem_amt,   A.ann_tsi_amt,  A.comp_rem,
    A.discount_sw,   A.item_no,  A.line_cd,
    A.peril_cd,    A.prem_amt,  A.prem_rt,
    A.rec_flag,    A.ri_comm_amt, A.ri_comm_rate,
    A.surcharge_sw,   A.tsi_amt,  v_extract_id,
 p_policy_id);
END LOOP;

--end_extract_gipi_orig_itmperil_rec



--begin_extract_gipi_polgenin_rec

FOR A IN(SELECT agreed_tag,  endt_text01,  endt_text02,
       endt_text03, endt_text04,  endt_text05,
       endt_text06, endt_text07,  endt_text08,
       endt_text09, endt_text10,  endt_text11,
       endt_text12, endt_text13,  endt_text14,
       endt_text15, endt_text16,  endt_text17,
       first_info,  gen_info,   gen_info01,
       gen_info02,  gen_info03,   gen_info04,
       gen_info05,  gen_info06,   gen_info07,
       gen_info08,  gen_info09,   gen_info10,
       gen_info11,  gen_info12,   gen_info13,
       gen_info14,  gen_info15,   gen_info16,
       gen_info17,     initial_info01,  initial_info02,
    initial_info03, initial_info04,  initial_info05,
    initial_info06, initial_info07,  initial_info08,
    initial_info09, initial_info10,  initial_info11,
    initial_info12, initial_info13,  initial_info14,
    initial_info15, initial_info16,  initial_info17
       FROM GIPI_POLGENIN
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLGENIN(
    agreed_tag,  endt_text01,  endt_text02,
    endt_text03,  endt_text04,  endt_text05,
    endt_text06,  endt_text07,  endt_text08,
    endt_text09,  endt_text10,  endt_text11,
    endt_text12,  endt_text13,  endt_text14,
    endt_text15,  endt_text16,  endt_text17,
    first_info,  gen_info,   gen_info01,
    gen_info02,  gen_info03,   gen_info04,
    gen_info05,  gen_info06,   gen_info07,
    gen_info08,  gen_info09,   gen_info10,
    gen_info11,  gen_info12,   gen_info13,
    gen_info14,  gen_info15,   gen_info16,
    gen_info17,  extract_id,   initial_info01,
    initial_info02, initial_info03,  initial_info04,
    initial_info05, initial_info06,  initial_info07,
    initial_info08, initial_info09,  initial_info10,
    initial_info11, initial_info12,  initial_info13,
    initial_info14, initial_info15,  initial_info16,
    initial_info17, policy_id)
VALUES(
    A.agreed_tag, A.endt_text01,  A.endt_text02,
    A.endt_text03, A.endt_text04,  A.endt_text05,
    A.endt_text06, A.endt_text07,  A.endt_text08,
    A.endt_text09, A.endt_text10,  A.endt_text11,
    A.endt_text12, A.endt_text13,  A.endt_text14,
    A.endt_text15, A.endt_text16,  A.endt_text17,
    A.first_info, A.gen_info,   A.gen_info01,
    A.gen_info02, A.gen_info03,  A.gen_info04,
    A.gen_info05, A.gen_info06,  A.gen_info07,
    A.gen_info08, A.gen_info09,  A.gen_info10,
    A.gen_info11, A.gen_info12,  A.gen_info13,
    A.gen_info14, A.gen_info15,  A.gen_info16,
    A.gen_info17, v_extract_id,   A.initial_info01,
    A.initial_info02,A.initial_info03, A.initial_info04,
    A.initial_info05,A.initial_info06, A.initial_info07,
    A.initial_info08,A.initial_info09, A.initial_info10,
    A.initial_info11,A.initial_info12, A.initial_info13,
    A.initial_info14,A.initial_info15, A.initial_info16,
    A.initial_info17, p_policy_id);
END LOOP;

--end_extract_gipi_polgenin_rec



--begin_extract_gipi_polnrep_rec
--check_me
FOR A IN(SELECT expiry_mm,   expiry_yy,  new_policy_id,
      old_policy_id,  rec_flag,  ren_rep_sw
       FROM GIPI_POLNREP
     WHERE new_policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLNREP(
    expiry_mm,   expiry_yy,  new_policy_id,
    old_policy_id,  rec_flag,  ren_rep_sw,
    extract_id)
VALUES(
    A.expiry_mm,   A.expiry_yy,  A.new_policy_id,
    A.old_policy_id,  A.rec_flag,  A.ren_rep_sw,
    v_extract_id);
END LOOP;

--end_extract_gipi_polnrep_rec



--begin_extract_gipi_polwc_rec

FOR A IN(SELECT change_tag,  line_cd,  print_seq_no,
    print_sw,  rec_flag,  swc_seq_no,
    wc_cd,   wc_remarks,  wc_text01,
    wc_text02,  wc_text03,  wc_text04,
    wc_text05,  wc_text06,  wc_text07,
    wc_text08,  wc_text09,  wc_text10,
    wc_text11,  wc_text12,  wc_text13,
    wc_text14,  wc_text15,  wc_text16,
    wc_text17,  wc_title,       wc_title2
       FROM GIPI_POLWC
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_POLWC(
    change_tag,  line_cd,  print_seq_no,
    print_sw,  rec_flag,  swc_seq_no,
    wc_cd,   wc_remarks,  wc_text01,
    wc_text02,  wc_text03,  wc_text04,
    wc_text05,  wc_text06,  wc_text07,
    wc_text08,  wc_text09,  wc_text10,
    wc_text11,  wc_text12,  wc_text13,
    wc_text14,  wc_text15,  wc_text16,
    wc_text17,  wc_title,  wc_title2,
    extract_id, policy_id)
VALUES(
    A.change_tag, A.line_cd,  A.print_seq_no,
    A.print_sw,  A.rec_flag,  A.swc_seq_no,
    A.wc_cd,   A.wc_remarks, A.wc_text01,
    A.wc_text02,  A.wc_text03, A.wc_text04,
    A.wc_text05,  A.wc_text06, A.wc_text07,
    A.wc_text08,  A.wc_text09, A.wc_text10,
    A.wc_text11,  A.wc_text12, A.wc_text13,
    A.wc_text14,  A.wc_text15, A.wc_text16,
    A.wc_text17,  A.wc_title,  A.wc_title2,
    v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_polwc_rec


--begin_extract_gipi_principal_rec

FOR A IN(SELECT principal_cd, engg_basic_infonum,   subcon_sw
         FROM GIPI_PRINCIPAL
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_PRINCIPAL(
    principal_cd,  engg_basic_infonum, subcon_sw,    extract_id, policy_id)
VALUES(
    A.principal_cd,  A.engg_basic_infonum, A.subcon_sw,   v_extract_id, p_policy_id);
END LOOP;

--end_extract_gipi_principal_rec


--begin_extract_gipi_vehicle_rec

FOR A IN(SELECT acquired_from,    assignee,     basic_color_cd,
       car_company_cd,   coc_atcn,     coc_issue_date,
       coc_seq_no,    coc_serial_no,   coc_type,
       coc_yy,     color,     color_cd,
       ctv_tag,    destination,    est_value,
       item_no,    make,      make_cd,
       model_year,    motor_no,     mot_type,
       mv_file_no,    no_of_pass,    origin,
       plate_no,    repair_lim,    serial_no,
    series_cd,    subline_cd,    subline_type_cd,
    tariff_zone,   towing,     type_of_body_cd,
    unladen_wt,       motor_coverage
       FROM GIPI_VEHICLE
     WHERE policy_id = p_policy_id)LOOP


INSERT INTO GIXX_VEHICLE(
    acquired_from,    assignee,     basic_color_cd,
    car_company_cd,  coc_atcn,     coc_issue_date,
    coc_seq_no,   coc_serial_no,    coc_type,
    coc_yy,    color,      color_cd,
    ctv_tag,    destination,    est_value,
    item_no,    make,      make_cd,
    model_year,   motor_no,     mot_type,
    mv_file_no,   no_of_pass,    origin,
    plate_no,   repair_lim,    serial_no,
    series_cd,   subline_cd,    subline_type_cd,
    tariff_zone,      towing,     type_of_body_cd,
    unladen_wt,      extract_id,       motor_coverage,
 policy_id)
VALUES(
    A.acquired_from,    A.assignee,     A.basic_color_cd,
    A.car_company_cd,   A.coc_atcn,     A.coc_issue_date,
    A.coc_seq_no,    A.coc_serial_no,    A.coc_type,
    A.coc_yy,     A.color,      A.color_cd,
    A.ctv_tag,     A.destination,    A.est_value,
    A.item_no,     A.make,      A.make_cd,
    A.model_year,    A.motor_no,     A.mot_type,
    A.mv_file_no,    A.no_of_pass,    A.origin,
    A.plate_no,     A.repair_lim,    A.serial_no,
    A.series_cd,     A.subline_cd,    A.subline_type_cd,
    A.tariff_zone,    A.towing,     A.type_of_body_cd,
    A.unladen_wt,    v_extract_id,       A.motor_coverage,
 p_policy_id);
END LOOP;

--end_extract_gipi_vehicle_rec


--begin_extract_gipi_ves_air_rec

FOR A IN(SELECT rec_flag, vescon,  vessel_cd,
       voy_limit
       FROM GIPI_VES_AIR
     WHERE policy_id = p_policy_id)LOOP

INSERT INTO GIXX_VES_AIR(
    rec_flag,   vescon,  vessel_cd,
    voy_limit,   extract_id, policy_id)
VALUES(
    A.rec_flag,   A.vescon,  A.vessel_cd,
    A.voy_limit,   v_extract_id, p_policy_id);
END LOOP;

COMMIT;
--end_extract_gipi_ves_air_rec

END extract_poldoc_record;




PROCEDURE extract_wpoldoc_record(
     p_par_id  GIPI_WPOLBAS.par_id%TYPE,
           v_extract_id    GIXX_POLBASIC.extract_id%TYPE) AS
BEGIN


--begin_extract_gipi_wpolbas_rec

FOR A IN(SELECT acct_of_cd,        acct_of_cd_sw,     address1,
       address2,     address3,       ann_prem_amt,
       ann_tsi_amt,    assd_no,       auto_renew_flag,
       co_insurance_sw,   cred_branch,      designation,
       discount_sw,    eff_date,        endt_expiry_date,
       endt_expiry_tag,   endt_iss_cd,      endt_seq_no,
       endt_type,     endt_yy,       expiry_date,
       expiry_tag,     fleet_print_tag,     foreign_acc_sw,
       incept_date,    incept_tag,      industry_cd,
       invoice_sw,     issue_date,      issue_yy,
       iss_cd,      label_tag,      line_cd,
       manual_renew_no,   mortg_name,      no_of_items,
       old_assd_no,    orig_policy_id,     pack_pol_flag,
       place_cd,     pol_flag,       pol_seq_no,
    pool_pol_no,    prem_amt,       prem_warr_tag,
    prorate_flag,    prov_prem_pct,     prov_prem_tag,
    qd_flag,     ref_open_pol_no,     ref_pol_no,
    region_cd,     reg_policy_sw,     renew_no,
    same_polno_sw,    short_rt_percent,     subline_cd,
    subline_type_cd,   surcharge_sw,      tsi_amt,
    type_cd,     validate_tag,      with_tariff_sw,
    old_address1,    old_address2,      old_address3,
    back_stat,  booking_mth,   booking_year, -- mod3 start
    cancel_date,  comp_sw,   par_id,
    risk_tag,  user_id,      -- mod3 end
 settling_agent_cd,survey_agent_cd
       FROM GIPI_WPOLBAS
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLBASIC(
    acct_of_cd,        acct_of_cd_sw,     address1,
    address2,     address3,       ann_prem_amt,
    ann_tsi_amt,     assd_no,       auto_renew_flag,
    co_insurance_sw,    cred_branch,      designation,
    discount_sw,     eff_date,        endt_expiry_date,
    endt_expiry_tag,    endt_iss_cd,      endt_seq_no,
    endt_type,     endt_yy,       expiry_date,
    expiry_tag,     fleet_print_tag,     foreign_acc_sw,
    incept_date,     incept_tag,      industry_cd,
    invoice_sw,     issue_date,      issue_yy,
    iss_cd,      label_tag,      line_cd,
    manual_renew_no,    mortg_name,      no_of_items,
    old_assd_no,     orig_policy_id,     pack_pol_flag,
    place_cd,     pol_flag,       pol_seq_no,
    pool_pol_no,     prem_amt,          prem_warr_tag,
    prorate_flag,    prov_prem_pct,     prov_prem_tag,
    qd_flag,      ref_open_pol_no,     ref_pol_no,
    region_cd,     reg_policy_sw,     renew_no,
    same_polno_sw,    short_rt_percent,     subline_cd,
    subline_type_cd,    surcharge_sw,      tsi_amt,
    type_cd,      validate_tag,      with_tariff_sw,
    old_address1,    old_address2,      old_address3,
    back_stat,   booking_mth,    booking_year, -- mod3 start
    cancel_date,   comp_sw,    par_id,
    risk_tag,   user_id,      -- mod3 end
 settling_agent_cd,survey_agent_cd,
    extract_id,policy_id)
VALUES(
    A.acct_of_cd,    A.acct_of_cd_sw,     A.address1,
    A.address2,     A.address3,      A.ann_prem_amt,
    A.ann_tsi_amt,    A.assd_no,      A.auto_renew_flag,
    A.co_insurance_sw,   A.cred_branch,     A.designation,
    A.discount_sw,    A.eff_date,      A.endt_expiry_date,
    A.endt_expiry_tag,   A.endt_iss_cd,     A.endt_seq_no,
    A.endt_type,     A.endt_yy,      A.expiry_date,
    A.expiry_tag,    A.fleet_print_tag,    A.foreign_acc_sw,
    A.incept_date,    A.incept_tag,      A.industry_cd,
    A.invoice_sw,    A.issue_date,      A.issue_yy,
    A.iss_cd,     A.label_tag,      A.line_cd,
    A.manual_renew_no,   A.mortg_name,      A.no_of_items,
    A.old_assd_no,    A.orig_policy_id,     A.pack_pol_flag,
    A.place_cd,     A.pol_flag,      A.pol_seq_no,
    A.pool_pol_no,    A.prem_amt,      A.prem_warr_tag,
    A.prorate_flag,    A.prov_prem_pct,     A.prov_prem_tag,
    A.qd_flag,     A.ref_open_pol_no,    A.ref_pol_no,
    A.region_cd,     A.reg_policy_sw,     A.renew_no,
    A.same_polno_sw,    A.short_rt_percent,    A.subline_cd,
    A.subline_type_cd,   A.surcharge_sw,     A.tsi_amt,
    A.type_cd,     A.validate_tag,     A.with_tariff_sw,
    A.old_address1,    A.old_address2,     A.old_address3,
    A.back_stat,     A.booking_mth,     A.booking_year, -- mod3 start
    A.cancel_date,    A.comp_sw,      A.par_id,
    A.risk_tag,     A.user_id,      -- mod3 end
 A.settling_agent_cd,A.survey_agent_cd,
    v_extract_id,p_par_id); --rollie10282003 added the column old_adrresses
END LOOP;

--end_extract_gipi_wpolbas_rec;

--start_extract_gipi_parlist --rollie10172003
FOR A IN ( SELECT   line_cd,  iss_cd         ,
            par_yy,  par_seq_no,     quote_seq_no,
               par_type,  assign_sw,     par_status,
            assd_no,  quote_id,     underwriter,
            remarks,  address1,     address2,
            address3,  load_tag,     cpi_rec_no,
               cpi_branch_cd
             FROM GIPI_PARLIST
            WHERE par_id = p_par_id) LOOP

INSERT INTO GIXX_PARLIST(
      extract_id,     line_cd,      iss_cd         ,
    par_yy,     par_seq_no,      quote_seq_no,
       par_type,    assign_sw,      par_status,
       assd_no,     quote_id,       underwriter,
       remarks,     address1,      address2,
       address3,    load_tag,      cpi_rec_no,
       cpi_branch_cd,policy_id)
VALUES(
       v_extract_id,          A.line_cd,            A.iss_cd         ,
       A.par_yy,           A.par_seq_no,         A.quote_seq_no,
       A.par_type,           A.assign_sw,     A.par_status,
       A.assd_no,            A.quote_id,     A.underwriter,
       A.remarks,           A.address1,     A.address2,
       A.address3,           A.load_tag,     A.cpi_rec_no,
       A.cpi_branch_cd,p_par_id);
END LOOP;

--end_extract_gipi_parlist
--begin_extract_gipi_waccident_item_rec

FOR A IN(SELECT ac_class_cd,   age,    civil_status,
       date_of_birth,   destination,  group_print_sw,
       height,     item_no,   level_cd,
       monthly_salary,   no_of_persons, parent_level_cd,
       position_cd,   salary_grade,  sex,
    weight
       FROM GIPI_WACCIDENT_ITEM
     WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_ACCIDENT_ITEM(
    ac_class_cd,      age,    civil_status,
    date_of_birth,   destination,  group_print_sw,
    height,     item_no,   level_cd,
    monthly_salary,   no_of_persons, parent_level_cd,
    position_cd,    salary_grade,  sex,
    weight,     extract_id,policy_id)
VALUES(
    A.ac_class_cd,   A.age,   A.civil_status,
    A.date_of_birth,   A.destination, A.group_print_sw,
    A.height,    A.item_no,  A.level_cd,
    A.monthly_salary,  A.no_of_persons, A.parent_level_cd,
    A.position_cd,   A.salary_grade, A.sex,
    A.weight,    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_waccident_item_rec


--begin_extract_gipi_waviation_item_rec

FOR A IN(SELECT deduct_text,  est_util_hrs, fixed_wing,
       geog_limit,  item_no,  prev_util_hrs,
    purpose,  qualification, rec_flag,
    rotor,   total_fly_time, vessel_cd
       FROM GIPI_WAVIATION_ITEM
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_AVIATION_ITEM(
    deduct_text,   est_util_hrs, fixed_wing,
    geog_limit,  item_no,  prev_util_hrs,
    purpose,   qualification, rec_flag,
    rotor,   total_fly_time, vessel_cd,
    extract_id,policy_id)
VALUES(
    A.deduct_text, A.est_util_hrs,   A.fixed_wing,
    A.geog_limit, A.item_no,    A.prev_util_hrs,
    A.purpose,  A.qualification,  A.rec_flag,
    A.rotor,   A.total_fly_time, A.vessel_cd,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_waviation_item_rec


--begin_extract_gipi_wbank_schedule_rec

FOR A IN(SELECT bank,        bank_address,  bank_item_no,
       cash_in_transit,   cash_in_vault,  include_tag,
       remarks
       FROM GIPI_WBANK_SCHEDULE
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_BANK_SCHEDULE(
    bank,        bank_address,  bank_item_no,
    cash_in_transit,    cash_in_vault,  include_tag,
    remarks,      extract_id,policy_id)
VALUES(
    A.bank,        A.bank_address,  A.bank_item_no,
    A.cash_in_transit,  A.cash_in_vault,  A.include_tag,
    A.remarks,      v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wbank_schedule_rec;


--begin_extract_gipi_wbeneficiary_rec

FOR A IN(SELECT adult_sw,           age,      beneficiary_addr,
       beneficiary_name,   beneficiary_no,   civil_status,
       date_of_birth,    delete_sw,    item_no,
       position_cd,    relation,     remarks,
    sex
       FROM GIPI_WBENEFICIARY
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_BENEFICIARY(
    adult_sw,           age,      beneficiary_addr,
    beneficiary_name,   beneficiary_no,   civil_status,
    date_of_birth,    delete_sw,    item_no,
    position_cd,       relation,     remarks,
    sex,         extract_id,policy_id)
VALUES(
    A.adult_sw,           A.age,     A.beneficiary_addr,
    A.beneficiary_name,   A.beneficiary_no,   A.civil_status,
    A.date_of_birth,    A.delete_sw,    A.item_no,
    A.position_cd,      A.relation,    A.remarks,
    A.sex,        v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wbeneficiary_rec;

--begin_extract_gipi_wbond_basic

FOR A IN(SELECT coll_flag, clause_type, obligee_no, prin_id, val_period_unit,
                val_period, np_no, contract_dtl, contract_date, co_prin_sw,
    waiver_limit, indemnity_text, bond_dtl, endt_eff_date, remarks
       FROM GIPI_WBOND_BASIC
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_BOND_BASIC(
    extract_id, obligee_no, prin_id, coll_flag, clause_type, val_period_unit, val_period,
    np_no, contract_dtl, contract_date, co_prin_sw, waiver_limit, indemnity_text,
    bond_dtl, endt_eff_date, remarks,policy_id)
VALUES(
    v_extract_id, A.obligee_no, A.prin_id, A.coll_flag, A.clause_type, A.val_period_unit,
    A.val_period, A.np_no, A.contract_dtl, A.contract_date, A.co_prin_sw,
    A.waiver_limit, A.indemnity_text, A.bond_dtl, A.endt_eff_date, A.remarks,p_par_id);
END LOOP;

--end_extract_gipi_wbond_basic


--begin_extract_gipi_wcargo_rec

FOR A IN(SELECT bl_awb,     cargo_class_cd, cargo_type,
       deduct_text,   destn,   eta,
       etd,     geog_cd,   item_no,
       lc_no,     origin,   pack_method,
       print_tag,    rec_flag,   tranship_destination,
    tranship_origin,  vessel_cd,  voyage_no
       FROM GIPI_WCARGO
     WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_CARGO(
    bl_awb,    cargo_class_cd, cargo_type,
    deduct_text,   destn,       eta,
    etd,     geog_cd,   item_no,
    lc_no,    origin,   pack_method,
    print_tag,   rec_flag,   tranship_destination,
    tranship_origin,  vessel_cd,   voyage_no,
    extract_id,policy_id)
VALUES(
    A.bl_awb,   A.cargo_class_cd, A.cargo_type,
    A.deduct_text,  A.destn,   A.eta,
    A.etd,    A.geog_cd,      A.item_no,
    A.lc_no,       A.origin,      A.pack_method,
    A.print_tag,      A.rec_flag,   A.tranship_destination,
    A.tranship_origin,   A.vessel_cd,  A.voyage_no,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcargo_rec


--begin_extract_gipi_wcargo_carrier_rec

FOR A IN(SELECT delete_sw, destn,   eta,
       etd,  item_no, origin,
       vessel_cd, voy_limit,  vessel_limit_of_liab
       FROM GIPI_WCARGO_CARRIER
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_CARGO_CARRIER(
    delete_sw, destn,   eta,
    etd,   item_no, origin,
    vessel_cd, voy_limit, vessel_limit_of_liab,
    extract_id,policy_id)
VALUES(
    A.delete_sw,  A.destn,   A.eta,
    A.etd,   A.item_no,  A.origin,
    A.vessel_cd,  A.voy_limit, A.vessel_limit_of_liab,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcargo_carrier_rec


--begin_extract_gipi_wcasualty_item_rec

FOR A IN(SELECT capacity_cd,       conveyance_info,   interest_on_premises,
       item_no,        limit_of_liability,  LOCATION,
       property_no,       property_no_type,   section_line_cd,
    section_or_hazard_cd, section_or_hazard_info, section_subline_cd
       FROM GIPI_WCASUALTY_ITEM
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_CASUALTY_ITEM(
    capacity_cd,       conveyance_info,   interest_on_premises,
    item_no,        limit_of_liability,  LOCATION,
    property_no,       property_no_type,   section_line_cd,
    section_or_hazard_cd, section_or_hazard_info, section_subline_cd,
    extract_id,policy_id)
VALUES(
    A.capacity_cd,     A.conveyance_info,   A.interest_on_premises,
    A.item_no,      A.limit_of_liability,  A.LOCATION,
    A.property_no,     A.property_no_type,   A.section_line_cd,
    A.section_or_hazard_cd, A.section_or_hazard_info, A.section_subline_cd,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcasualty_item_rec


--begin_extract_gipi_wcasualty_personnel_rec

FOR A IN(SELECT amount_covered,  capacity_cd,  delete_sw,
       include_tag,  item_no,   NAME,
       personnel_no,  remarks
       FROM GIPI_WCASUALTY_PERSONNEL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_CASUALTY_PERSONNEL(
    amount_covered,  capacity_cd, delete_sw,
    include_tag,   item_no,  NAME,
    personnel_no,  remarks,  extract_id,policy_id)
VALUES(
    A.amount_covered, A.capacity_cd,  A.delete_sw,
    A.include_tag,  A.item_no,   A.NAME,
    A.personnel_no,  A.remarks,   v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcasualty_personnel_rec


--begin_extract_gipi_wcomm_invoices_rec

FOR A IN(SELECT bond_rate,      commission_amt,  default_intm,
       intrmdry_intm_no, item_grp,   parent_intm_no,
       premium_amt,  share_percentage, wholding_tax
       FROM GIPI_WCOMM_INVOICES
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_COMM_INVOICE(
    bond_rate,      commission_amt,  default_intm,
    intrmdry_intm_no, item_grp,   parent_intm_no,
    premium_amt,   share_percentage, wholding_tax,
    extract_id,policy_id)
VALUES(
    A.bond_rate,      A.commission_amt, A.default_intm,
    A.intrmdry_intm_no, A.item_grp,   A.parent_intm_no,
    A.premium_amt,  A.share_percentage, A.wholding_tax,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcomm_invoices_rec

--begin_extract_gipi_co_insurer_rec

FOR A IN(SELECT co_ri_cd,   co_ri_prem_amt,  co_ri_shr_pct,
       co_ri_tsi_amt
       FROM GIPI_CO_INSURER
     WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_CO_INSURER(
    co_ri_cd,   co_ri_prem_amt,  co_ri_shr_pct,
    co_ri_tsi_amt, extract_id,policy_id)
VALUES(
    A.co_ri_cd,   A.co_ri_prem_amt, A.co_ri_shr_pct,
    A.co_ri_tsi_amt, v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_co_insurer_rec
--begin_extract_gipi_wcomm_inv_perils_rec

FOR A IN(SELECT commission_amt,   commission_rt, intrmdry_intm_no,
       item_grp,    peril_cd,   premium_amt,
    wholding_tax
       FROM GIPI_WCOMM_INV_PERILS
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_COMM_INV_PERIL(
    commission_amt,    commission_rt, intrmdry_intm_no,
    item_grp,    peril_cd,   premium_amt,
    wholding_tax,   extract_id,policy_id)
VALUES(
    A.commission_amt,  A.commission_rt, A.intrmdry_intm_no,
    A.item_grp,    A.peril_cd,  A.premium_amt,
    A.wholding_tax,   v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcomm_inv_perils_rec


--begin_extract_gipi_wcosigntry_rec

FOR A IN(SELECT assd_no, bonds_flag,  bonds_ri_flag,
       cosign_id, indem_flag
       FROM GIPI_WCOSIGNTRY
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_COSIGNTRY(
    assd_no,  bonds_flag,  bonds_ri_flag,
    cosign_id, indem_flag,  extract_id,policy_id)
VALUES(
    A.assd_no, A.bonds_flag, A.bonds_ri_flag,
    A.cosign_id, A.indem_flag, v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wcosigntry_rec


--begin_extract_gipi_wdeductibles_rec

FOR A IN(SELECT deductible_amt,    deductible_rt,  deductible_text,
       ded_deductible_cd,   ded_line_cd,   ded_subline_cd,
       item_no,     peril_cd
       FROM GIPI_WDEDUCTIBLES
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_DEDUCTIBLES(
    deductible_amt,    deductible_rt,  deductible_text,
    ded_deductible_cd,   ded_line_cd,   ded_subline_cd,
    item_no,      peril_cd,    extract_id,policy_id)
VALUES(
    A.deductible_amt,   A.deductible_rt,  A.deductible_text,
    A.ded_deductible_cd,   A.ded_line_cd,  A.ded_subline_cd,
    A.item_no,     A.peril_cd,   v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wdeductibles_rec


--begin_extract_gipi_wendttext_rec

/*********
** Modified by Andrew Robes
** Date : 5.22.2013
** Modification : Changed the way of copying gipi_wendttext to gixx_endttext to handle the endt_text column with LONG datatype, error occurs when the max length of the column is used  
************/ 

    INSERT INTO gixx_endttext
                (endt_tax, endt_text, endt_text01, endt_text02, endt_text03, endt_text04, endt_text05,
                 endt_text06, endt_text07, endt_text08, endt_text09, endt_text10, endt_text11,
                 endt_text12, endt_text13, endt_text14, endt_text15, endt_text16, endt_text17,
                 extract_id, policy_id)
           SELECT endt_tax, TO_LOB(endt_text), endt_text01, endt_text02, endt_text03, endt_text04, endt_text05,
                  endt_text06, endt_text07, endt_text08, endt_text09, endt_text10, endt_text11, 
                  endt_text12, endt_text13, endt_text14, endt_text15, endt_text16, endt_text17,
                  v_extract_id, p_par_id
             FROM gipi_wendttext
            WHERE par_id = p_par_id;

--FOR A IN(SELECT endt_tax,       endt_text,  endt_text01,
--       endt_text02, endt_text03, endt_text04,
--       endt_text05, endt_text06, endt_text07,
--       endt_text08, endt_text09, endt_text10,
--       endt_text11, endt_text12, endt_text13,
--       endt_text14, endt_text15, endt_text16,
--       endt_text17
--       FROM GIPI_WENDTTEXT
--     WHERE par_id = p_par_id)LOOP

--INSERT INTO GIXX_ENDTTEXT(
--    endt_tax,       endt_text,  endt_text01,
--    endt_text02,  endt_text03, endt_text04,
--    endt_text05,  endt_text06, endt_text07,
--    endt_text08,  endt_text09, endt_text10,
--    endt_text11,  endt_text12, endt_text13,
--    endt_text14,  endt_text15, endt_text16,
--    endt_text17,  extract_id,policy_id)
--VALUES(
--    A.endt_tax,    A.endt_text,  A.endt_text01,
--    A.endt_text02,  A.endt_text03,  A.endt_text04,
--    A.endt_text05,  A.endt_text06,  A.endt_text07,
--    A.endt_text08,  A.endt_text09,  A.endt_text10,
--    A.endt_text11,  A.endt_text12,  A.endt_text13,
--    A.endt_text14,  A.endt_text15,  A.endt_text16,
--    A.endt_text17,  v_extract_id,p_par_id);
--END LOOP;

--end_extract_gipi_wendttext_rec


--begin_extract_gipi_wengg_basic_rec

FOR A IN(SELECT construct_end_date,    construct_start_date, contract_proj_buss_title,
       engg_basic_infonum,    maintain_end_date,  maintain_start_date,
       mbi_policy_no,     site_location,   testing_end_date,
    testing_start_date,    time_excess,    weeks_test
       FROM GIPI_WENGG_BASIC
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ENGG_BASIC(
    construct_end_date,    construct_start_date, contract_proj_buss_title,
    engg_basic_infonum,    maintain_end_date,  maintain_start_date,
    mbi_policy_no,     site_location,   testing_end_date,
    testing_start_date,    time_excess,    weeks_test,
    extract_id,policy_id)
VALUES(
    A.construct_end_date,   A.construct_start_date, A.contract_proj_buss_title,
    A.engg_basic_infonum,   A.maintain_end_date,  A.maintain_start_date,
    A.mbi_policy_no,     A.site_location,   A.testing_end_date,
    A.testing_start_date,   A.time_excess,   A.weeks_test,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wengg_basic_rec


--begin_extract_gipi_wfireitm_rec

FOR A IN(SELECT assignee,       block_id,     block_no,
       construction_cd,  construction_remarks,  district_no,
       eq_zone,    flood_zone,    front,
       fr_item_type,   item_no,     LEFT,
       loc_risk1,    loc_risk2,     loc_risk3,
       occupancy_cd,   occupancy_remarks,   rear,
    RIGHT,     tarf_cd,     tariff_zone,
    typhoon_zone
       FROM GIPI_WFIREITM
     WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_FIREITEM(
    assignee,       block_id,     block_no,
    construction_cd,   construction_remarks,  district_no,
    eq_zone,     flood_zone,    front,
    fr_item_type,   item_no,     LEFT,
    loc_risk1,    loc_risk2,     loc_risk3,
    occupancy_cd,   occupancy_remarks,   rear,
    RIGHT,     tarf_cd,     tariff_zone,
    typhoon_zone,   extract_id,policy_id)
VALUES(
    A.assignee,       A.block_id,    A.block_no,
    A.construction_cd,  A.construction_remarks, A.district_no,
    A.eq_zone,    A.flood_zone,    A.front,
    A.fr_item_type,   A.item_no,     A.LEFT,
    A.loc_risk1,    A.loc_risk2,    A.loc_risk3,
    A.occupancy_cd,   A.occupancy_remarks,  A.rear,
    A.RIGHT,     A.tarf_cd,     A.tariff_zone,
    A.typhoon_zone,   v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wfireitm_rec


--begin_extract_gipi_wgrouped_items_rec

FOR A IN(SELECT age,       NVL(amount_covered,tsi_amt) amount_covered,
           civil_status,
       date_of_birth,     delete_sw,   grouped_item_no,
       grouped_item_title,   group_cd,    include_tag,
       item_no,     line_cd,    position_cd,
    remarks,     salary,    salary_grade,
    sex,      subline_cd,   principal_cd, -- mod1 start
    pack_ben_cd,    from_date,   TO_DATE, -- mod1 end
 ann_tsi_amt, ann_prem_amt, tsi_amt,
 prem_amt
  FROM GIPI_WGROUPED_ITEMS
 WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_GROUPED_ITEMS(
    age,        amount_coverage, amount_covered,
    civil_status,
    date_of_birth,     delete_sw,   grouped_item_no,
    grouped_item_title,   group_cd,    include_tag,
    item_no,      line_cd,    position_cd,
    remarks,      salary,    salary_grade,
    sex,       subline_cd,   principal_cd, -- mod1 start
    pack_ben_cd,    from_date,   TO_DATE,   -- mod1 end
    ann_tsi_amt, ann_prem_amt, tsi_amt,
 prem_amt, extract_id,policy_id)
VALUES(
    A.age,       A.amount_covered,  A.amount_covered,
    A.civil_status,
    A.date_of_birth,     A.delete_sw,   A.grouped_item_no,
    A.grouped_item_title,  A.group_cd,   A.include_tag,
    A.item_no,     A.line_cd,   A.position_cd,
    A.remarks,     A.salary,    A.salary_grade,
    A.sex,      A.subline_cd,   A.principal_cd, -- mod1 start
    A.pack_ben_cd,    A.from_date,   A.TO_DATE,  -- mod1 end
    A.ann_tsi_amt, A.ann_prem_amt, A.tsi_amt,
 A.prem_amt, v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wgrouped_items_rec


--begin_extract_gipi_wgrp_items_beneficiary_rec

FOR A IN(SELECT age,     beneficiary_addr,  beneficiary_name,
       beneficiary_no,   civil_status,   date_of_birth,
       grouped_item_no,  item_no,    relation,
    sex
       FROM GIPI_WGRP_ITEMS_BENEFICIARY
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_GRP_ITEMS_BENEFICIARY(
    age,         beneficiary_addr,  beneficiary_name,
    beneficiary_no,   civil_status,   date_of_birth,
    grouped_item_no,   item_no,    relation,
    sex,      extract_id,policy_id)
VALUES(
    A.age,         A.beneficiary_addr,  A.beneficiary_name,
    A.beneficiary_no,   A.civil_status,   A.date_of_birth,
    A.grouped_item_no,   A.item_no,    A.relation,
    A.sex,      v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wgrp_items_beneficiary_rec


--begin_extract_gipi_winvoice_rec

FOR A IN(SELECT approval_cd,      bond_rate, bond_tsi_amt,
       card_name,       card_no,  currency_cd,
       currency_rt,   due_date,  expiry_date,
       insured,    item_grp,  notarial_fee,
       other_charges,   payt_terms, pay_type,
    policy_currency,  prem_amt,  prem_seq_no,
    property,       ref_inv_no, remarks,
    ri_comm_amt,      tax_amt
       FROM GIPI_WINVOICE
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_INVOICE(
    approval_cd,     bond_rate,  bond_tsi_amt,
    card_name,     card_no,  currency_cd,
    currency_rt,  due_date,  expiry_date,
    insured,   item_grp,  notarial_fee,
    other_charges, payt_terms,  pay_type,
    policy_currency, prem_amt,  prem_seq_no,
    property,  ref_inv_no,  remarks,
    ri_comm_amt,     tax_amt,  extract_id,policy_id)
VALUES(
    A.approval_cd,   A.bond_rate,  A.bond_tsi_amt,
    A.card_name,       A.card_no,  A.currency_cd,
    A.currency_rt,   A.due_date,  A.expiry_date,
    A.insured,    A.item_grp,  A.notarial_fee,
    A.other_charges,   A.payt_terms,  A.pay_type,
    A.policy_currency, A.prem_amt,  A.prem_seq_no,
    A.property,    A.ref_inv_no,  A.remarks,
    A.ri_comm_amt,   A.tax_amt,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_winvoice_rec


--begin_extract_gipi_winvperl_rec

FOR A IN(SELECT item_grp,     peril_cd,  prem_amt,
    ri_comm_amt,  ri_comm_rt, tsi_amt
     FROM GIPI_WINVPERL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_INVPERIL(
    item_grp,    peril_cd,   prem_amt,
    ri_comm_amt,  ri_comm_rt, tsi_amt,
    extract_id,policy_id)
VALUES(
    A.item_grp,   A.peril_cd,    A.prem_amt,
    A.ri_comm_amt, A.ri_comm_rt,  A.tsi_amt,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_winvperl_rec


--begin_extract_gipi_winv_tax_rec

FOR A IN(SELECT iss_cd,  item_grp,  fixed_tax_allocation,
       line_cd, rate,   tax_amt,
    tax_cd,  tax_allocation, tax_id
       FROM GIPI_WINV_TAX
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_INV_TAX(
    iss_cd,  item_grp,  fixed_tax_allocation,
    line_cd,  rate,   tax_amt,
    tax_cd,  tax_allocation, tax_id,
    extract_id,policy_id)
VALUES(
    A.iss_cd,  A.item_grp,    A.fixed_tax_allocation,
    A.line_cd,  A.rate,     A.tax_amt,
    A.tax_cd,  A.tax_allocation, A.tax_id,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_winv_tax_rec


--begin_extract_gipi_witem_rec

FOR A IN(SELECT ann_prem_amt,     ann_tsi_amt,     changed_tag,
       comp_sw,    coverage_cd,     currency_cd,
       currency_rt,   discount_sw,     from_date,
       group_cd,    item_desc,     item_desc2,
       item_grp,    item_no,      item_title,
       other_info,    pack_line_cd,     pack_subline_cd,
       prem_amt,    prorate_flag,     rec_flag,
    region_cd,    short_rt_percent,    surcharge_sw,
    TO_DATE,    tsi_amt,             risk_no,
    risk_item_no,   pack_ben_cd
       FROM GIPI_WITEM
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ITEM(
    ann_prem_amt,      ann_tsi_amt,     changed_tag,
    comp_sw,     coverage_cd,     currency_cd,
    currency_rt,    discount_sw,     from_date,
    group_cd,    item_desc,     item_desc2,
    item_grp,    item_no,      item_title,
    other_info,    pack_line_cd,     pack_subline_cd,
    prem_amt,    prorate_flag,     rec_flag,
    region_cd,    short_rt_percent,    surcharge_sw,
    TO_DATE,     tsi_amt,      extract_id,
    risk_no,           risk_item_no, pack_ben_cd,policy_id)
VALUES(
    A.ann_prem_amt,    A.ann_tsi_amt,    A.changed_tag,
    A.comp_sw,    A.coverage_cd,    A.currency_cd,
    A.currency_rt,   A.discount_sw,    A.from_date,
    A.group_cd,    A.item_desc,     A.item_desc2,
    A.item_grp,    A.item_no,     A.item_title,
    A.other_info,   A.pack_line_cd,    A.pack_subline_cd,
    A.prem_amt,    A.prorate_flag,    A.rec_flag,
    A.region_cd,    A.short_rt_percent,  A.surcharge_sw,
    A.TO_DATE,    A.tsi_amt,     v_extract_id,
    A.risk_no,         A.risk_item_no, a.pack_ben_cd,p_par_id );
END LOOP;

--end_extract_gipi_witem_rec


--begin_extract_gipi_witem_ves_rec

FOR A IN(SELECT deduct_text, dry_date,  dry_place,
       geog_limit,  item_no,  rec_flag,
    vessel_cd
       FROM GIPI_WITEM_VES
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ITEM_VES(
    deduct_text,  dry_date,  dry_place,
    geog_limit,  item_no,  rec_flag,
    vessel_cd,  extract_id,policy_id)
VALUES(
    A.deduct_text, A.dry_date,  A.dry_place,
    A.geog_limit, A.item_no,  A.rec_flag,
    A.vessel_cd,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_witem_ves_rec


--begin_extract_gipi_witmperl_rec

FOR A IN(SELECT ann_prem_amt, ann_tsi_amt, as_charge_sw,
       comp_rem,  discount_sw, item_no,
       line_cd,  peril_cd,  prem_amt,
    prem_rt,  prt_flag,  rec_flag,
    ri_comm_amt, ri_comm_rate, surcharge_sw,
    tarf_cd,  tsi_amt
       FROM GIPI_WITMPERL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ITMPERIL(
    ann_prem_amt, ann_tsi_amt, as_charge_sw,
    comp_rem,  discount_sw, item_no,
    line_cd,   peril_cd,  prem_amt,
    prem_rt,   prt_flag,  rec_flag,
    ri_comm_amt,  ri_comm_rate, surcharge_sw,
    tarf_cd,   tsi_amt,  extract_id,policy_id)
VALUES(
    A.ann_prem_amt, A.ann_tsi_amt, A.as_charge_sw,
    A.comp_rem,  A.discount_sw, A.item_no,
    A.line_cd,  A.peril_cd,  A.prem_amt,
    A.prem_rt,  A.prt_flag,  A.rec_flag,
    A.ri_comm_amt, A.ri_comm_rate, A.surcharge_sw,
    A.tarf_cd,  A.tsi_amt,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_witmperl_rec


--begin_extract_gipi_wlim_liab_rec

FOR A IN(SELECT currency_cd, currency_rt, liab_cd,
       line_cd,  limit_liability
       FROM GIPI_WLIM_LIAB
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_LIM_LIAB(
    currency_cd,   currency_rt,    liab_cd,
    line_cd,    limit_liability, extract_id,policy_id)
VALUES(
    A.currency_cd, A.currency_rt,   A.liab_cd,
    A.line_cd,  A.limit_liability,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wlim_liab_rec


--begin_extract_gipi_wlocation_rec

FOR A IN(SELECT item_no, province_cd, region_cd
         FROM GIPI_WLOCATION
     WHERE par_id  = p_par_id)LOOP

INSERT INTO GIXX_LOCATION(
    item_no,  province_cd, region_cd,   extract_id,policy_id)
VALUES(
    A.item_no, A.province_cd, A.region_cd,   v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wlocation_rec

--begin_extract_gipi_main_co_ins_rec
--added by rollie 10272003
FOR A IN(SELECT prem_amt, tsi_amt
         FROM GIPI_MAIN_CO_INS
    WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_MAIN_CO_INS(
    prem_amt, tsi_amt, extract_id,policy_id)
VALUES(
    A.prem_amt, A.tsi_amt, v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_main_co_ins_rec

--begin_extract_gipi_wmcacc_rec

FOR A IN(SELECT accessory_cd, acc_amt, delete_sw,
       item_no
     FROM GIPI_WMCACC
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_MCACC(
    accessory_cd, acc_amt,  delete_sw,
    item_no,   extract_id,policy_id)
VALUES(
    A.accessory_cd, A.acc_amt,  A.delete_sw,
    A.item_no,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wmcacc_rec


--begin_extract_gipi_wmortgagee_rec

FOR A IN(SELECT amount,   delete_sw,  iss_cd,
       item_no,  mortg_cd,   remarks
       FROM GIPI_WMORTGAGEE
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_MORTGAGEE(
    amount,   delete_sw,  iss_cd,
    item_no,   mortg_cd,   remarks,
    extract_id,policy_id)
VALUES(
    A.amount,   A.delete_sw,  A.iss_cd,
    A.item_no,   A.mortg_cd,  A. remarks,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wmortgagee_rec


--begin_extract_gipi_wopen_cargo_rec

FOR A IN(SELECT cargo_class_cd,   geog_cd,  rec_flag
         FROM GIPI_WOPEN_CARGO
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_CARGO(
    cargo_class_cd,   geog_cd,  rec_flag,  extract_id,policy_id)
VALUES(
    A.cargo_class_cd,  A.geog_cd, A.rec_flag,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wopen_cargo_rec


--begin_extract_gipi_wopen_liab_rec

FOR A IN(SELECT currency_cd,    currency_rt,  geog_cd,
       limit_liability, multi_geog_tag,  prem_tag,
    rec_flag,   voy_limit,   with_invoice_tag
       FROM GIPI_WOPEN_LIAB
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_LIAB(
    currency_cd,     currency_rt,  geog_cd,
    limit_liability,  multi_geog_tag,  prem_tag,
    rec_flag,   voy_limit,   with_invoice_tag,
    extract_id,policy_id)
VALUES(
    A.currency_cd,    A.currency_rt,  A.geog_cd,
    A.limit_liability, A.multi_geog_tag, A.prem_tag,
    A.rec_flag,   A.voy_limit,  A.with_invoice_tag,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wopen_liab_rec


--begin_extract_gipi_wopen_peril_rec

FOR A IN(SELECT geog_cd,   line_cd,  peril_cd,
       prem_rate,   rec_flag,  remarks,
       with_invoice_tag
       FROM GIPI_WOPEN_PERIL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_PERIL(
    geog_cd,    line_cd,  peril_cd,
    prem_rate,   rec_flag,  remarks,
    with_invoice_tag,    extract_id,policy_id)
VALUES(
    A.geog_cd,   A.line_cd,  A.peril_cd,
    A.prem_rate,      A.rec_flag,  A.remarks,
    A.with_invoice_tag,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wopen_peril_rec


--begin_extract_gipi_wopen_policy_rec

FOR A IN(SELECT decltn_no,  eff_date,    line_cd,
       op_issue_yy, op_iss_cd,    op_pol_seqno,
       op_renew_no, op_subline_cd
       FROM GIPI_WOPEN_POLICY
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_OPEN_POLICY(
    decltn_no,  eff_date,    line_cd,
    op_issue_yy,  op_iss_cd,    op_pol_seqno,
    op_renew_no,  op_subline_cd,   extract_id,policy_id)
VALUES(
    A.decltn_no,  A.eff_date,    A.line_cd,
    A.op_issue_yy, A.op_iss_cd,   A.op_pol_seqno,
    A.op_renew_no, A.op_subline_cd,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wopen_policy_rec


--begin_extract_gipi_orig_comm_invoice_rec
--check_me
FOR A IN(SELECT commission_amt,  intrmdry_intm_no, iss_cd,
       item_grp,   premium_amt,  prem_seq_no,
       share_percentage, wholding_tax
       FROM GIPI_ORIG_COMM_INVOICE
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INVOICE(
    commission_amt,   intrmdry_intm_no, iss_cd,
    item_grp,   premium_amt,  prem_seq_no,
    share_percentage, wholding_tax,  extract_id,policy_id)
VALUES(
    A.commission_amt,  A.intrmdry_intm_no, A.iss_cd,
    A.item_grp,   A.premium_amt,  A.prem_seq_no,
    A.share_percentage, A.wholding_tax,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_orig_comm_invoice_rec


--begin_extract_gipi_orig_comm_inv_peril_rec
--check_me
FOR A IN (SELECT commission_amt,  commission_rt,  intrmdry_intm_no,
        iss_cd,    item_grp,   peril_cd,
       premium_amt,  prem_seq_no,  wholding_tax
       FROM GIPI_ORIG_COMM_INV_PERIL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_COMM_INV_PERIL(
    commission_amt,   commission_rt,  intrmdry_intm_no,
    iss_cd,    item_grp,   peril_cd,
    premium_amt,   prem_seq_no,  wholding_tax,
    extract_id,policy_id)
VALUES(
    A.commission_amt,  A.commission_rt, A.intrmdry_intm_no,
    A.iss_cd,   A.item_grp,   A.peril_cd,
    A.premium_amt,  A.prem_seq_no,  A.wholding_tax,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_orig_comm_inv_peril_rec


--begin_extract_gipi_orig_invoice_rec
--check_me
FOR A IN(SELECT currency_cd,  currency_rt, insured,
       iss_cd,    item_grp,  other_charges,
       policy_currency, prem_amt,  prem_seq_no,
       property,   ref_inv_no,  remarks,
       ri_comm_amt,  tax_amt
       FROM GIPI_ORIG_INVOICE
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_INVOICE(
    currency_cd,   currency_rt,  insured,
    iss_cd,    item_grp,   other_charges,
    policy_currency,  prem_amt,   prem_seq_no,
    property,   ref_inv_no,   remarks,
    ri_comm_amt,   tax_amt,   extract_id,policy_id)
VALUES(
    A.currency_cd,  A.currency_rt,  A.insured,
    A.iss_cd,   A.item_grp,   A.other_charges,
    A.policy_currency, A.prem_amt,   A.prem_seq_no,
    A.property,   A.ref_inv_no,  A.remarks,
    A.ri_comm_amt,  A.tax_amt,   v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_orig_invoice_rec


--begin_extract_gipi_orig_invperl_rec
--check_me
FOR A IN(SELECT item_grp,    peril_cd, prem_amt,
    ri_comm_amt,   ri_comm_rt, tsi_amt
       FROM GIPI_ORIG_INVPERL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_INVPERL(
    item_grp,  peril_cd,   prem_amt,
    ri_comm_amt,  ri_comm_rt,   tsi_amt,
    extract_id,policy_id)
VALUES(
    A.item_grp,  A.peril_cd,   A.prem_amt,
    A.ri_comm_amt, A.ri_comm_rt, A.tsi_amt,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_orig_invperl_rec


--begin_extract_gipi_orig_inv_tax_rec
--check_me
FOR A IN(SELECT iss_cd,  item_grp, fixed_tax_allocation,
       line_cd, rate,  tax_allocation,
       tax_amt, tax_cd,  tax_id
       FROM GIPI_ORIG_INV_TAX
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_INV_TAX(
    iss_cd,  item_grp, fixed_tax_allocation,
    line_cd,  rate,  tax_allocation,
    tax_amt,  tax_cd,  tax_id,
    extract_id,policy_id)
VALUES(
    A.iss_cd,  A.item_grp,    A.fixed_tax_allocation,
    A.line_cd,  A.rate,     A.tax_allocation,
    A.tax_amt,  A.tax_cd,    A.tax_id,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_orig_inv_tax_rec


--begin_extract_gipi_orig_itmperil_rec
--check_me
FOR A IN(SELECT ann_prem_amt, ann_tsi_amt,  comp_rem,
       discount_sw, item_no,  line_cd,
       peril_cd,  prem_amt,  prem_rt,
       rec_flag,  ri_comm_amt, ri_comm_rate,
       surcharge_sw, tsi_amt
       FROM GIPI_ORIG_ITMPERIL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_ORIG_ITMPERIL(
    ann_prem_amt,   ann_tsi_amt,   comp_rem,
    discount_sw,    item_no,   line_cd,
    peril_cd,    prem_amt,     prem_rt,
    rec_flag,    ri_comm_amt,  ri_comm_rate,
    surcharge_sw,   tsi_amt,   extract_id,policy_id)
VALUES(
    A.ann_prem_amt,   A.ann_tsi_amt,  A.comp_rem,
    A.discount_sw,   A.item_no,  A.line_cd,
    A.peril_cd,    A.prem_amt,  A.prem_rt,
    A.rec_flag,    A.ri_comm_amt, A.ri_comm_rate,
    A.surcharge_sw,   A.tsi_amt,  v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_orig_itmperil_rec


--begin_extract_gipi_wpolgenin_rec

FOR A IN(SELECT agreed_tag,  first_info,  gen_info,
       gen_info01,  gen_info02,  gen_info03,
       gen_info04,  gen_info05,  gen_info06,
       gen_info07,  gen_info08,  gen_info09,
       gen_info10,  gen_info11,  gen_info12,
       gen_info13,  gen_info14,  gen_info15,
       gen_info16,  gen_info17,  initial_info01,
       initial_info02, initial_info03, initial_info04,
       initial_info05, initial_info06, initial_info07,
       initial_info08, initial_info09, initial_info10,
       initial_info11, initial_info12, initial_info13,
       initial_info14, initial_info15, initial_info16,
       initial_info17
       FROM GIPI_WPOLGENIN
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLGENIN(
    agreed_tag,  first_info,  gen_info,
    gen_info01,  gen_info02,  gen_info03,
    gen_info04,  gen_info05,  gen_info06,
    gen_info07,  gen_info08,  gen_info09,
    gen_info10,  gen_info11,  gen_info12,
    gen_info13,  gen_info14,  gen_info15,
    gen_info16,  gen_info17,  extract_id,
    initial_info01,  initial_info02, initial_info03,
    initial_info04, initial_info05, initial_info06,
    initial_info07, initial_info08, initial_info09,
    initial_info10, initial_info11, initial_info12,
    initial_info13, initial_info14, initial_info15,
    initial_info16, initial_info17,policy_id)
VALUES(
    A.agreed_tag, A.first_info, A.gen_info,
    A.gen_info01, A.gen_info02, A.gen_info03,
    A.gen_info04, A.gen_info05, A.gen_info06,
    A.gen_info07, A.gen_info08, A.gen_info09,
    A.gen_info10, A.gen_info11, A.gen_info12,
    A.gen_info13, A.gen_info14, A.gen_info15,
    A.gen_info16, A.gen_info17, v_extract_id,
    A.initial_info01,A.initial_info02,A.initial_info03,
    A.initial_info04,A.initial_info05,A.initial_info06,
    A.initial_info07,A.initial_info08,A.initial_info09,
    A.initial_info10,A.initial_info11,A.initial_info12,
    A.initial_info13,A.initial_info14,A.initial_info15,
    A.initial_info16,A.initial_info17,p_par_id);
END LOOP;

--end_extract_gipi_wpolgenin_rec


--begin_extract_gipi_wpolnrep_rec
--check_me
FOR A IN(SELECT expiry_mm,   expiry_yy,  new_policy_id,
      old_policy_id,  rec_flag,  ren_rep_sw
       FROM GIPI_WPOLNREP
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLNREP(
    expiry_mm,   expiry_yy,  new_policy_id,
    old_policy_id,  rec_flag,  ren_rep_sw,
    extract_id)
VALUES(
    A.expiry_mm,   A.expiry_yy,  /*A.new_policy_id*/p_par_id,
    A.old_policy_id,  A.rec_flag,  A.ren_rep_sw,
    v_extract_id);
END LOOP;

--end_extract_gipi_wpolnrep_rec


--begin_extract_gipi_wpolnrep_rec

FOR A IN(SELECT expiry_mm,  expiry_yy, new_policy_id,
       old_policy_id, rec_flag, ren_rep_sw
       FROM GIPI_WPOLNREP
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLNREP(
    expiry_mm,  expiry_yy,   new_policy_id,
    old_policy_id, rec_flag,   ren_rep_sw,
    extract_id)
VALUES(
    A.expiry_mm,  A.expiry_yy,  /*A.new_policy_id*/p_par_id,
    A.old_policy_id, A.rec_flag,   A.ren_rep_sw,
    v_extract_id);
END LOOP;

--end_extract_gipi_wpolnrep_rec


--begin_extract_gipi_wpolwc_rec

FOR A IN(SELECT change_tag,  line_cd,  print_seq_no,
    print_sw,  rec_flag,  swc_seq_no,
    wc_cd,   wc_remarks,  wc_text01,
    wc_text02,  wc_text03,  wc_text04,
    wc_text05,  wc_text06,  wc_text07,
    wc_text08,  wc_text09,  wc_text10,
    wc_text11,  wc_text12,  wc_text13,
    wc_text14,  wc_text15,  wc_text16,
    wc_text17,  wc_title,  wc_title2
       FROM GIPI_WPOLWC
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_POLWC(
    change_tag,  line_cd,    print_seq_no,
    print_sw,  rec_flag,    swc_seq_no,
    wc_cd,   wc_remarks,    wc_text01,
    wc_text02,  wc_text03,    wc_text04,
    wc_text05,  wc_text06,    wc_text07,
    wc_text08,  wc_text09,    wc_text10,
    wc_text11,  wc_text12,    wc_text13,
    wc_text14,  wc_text15,    wc_text16,
    wc_text17,  wc_title,    wc_title2,
    extract_id,policy_id)
VALUES(
    A.change_tag, A.line_cd,    A.print_seq_no,
    A.print_sw,  A.rec_flag,    A.swc_seq_no,
    A.wc_cd,   A.wc_remarks, A.wc_text01,
    A.wc_text02,  A.wc_text03, A.wc_text04,
    A.wc_text05,  A.wc_text06, A.wc_text07,
    A.wc_text08,  A.wc_text09, A.wc_text10,
    A.wc_text11,  A.wc_text12, A.wc_text13,
    A.wc_text14,  A.wc_text15, A.wc_text16,
    A.wc_text17,  A.wc_title,    A.wc_title2,
    v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wpolwc_rec


--begin_extract_gipi_wprincipal_rec

FOR A IN(SELECT engg_basic_infonum,    principal_cd,    subcon_sw
       FROM GIPI_WPRINCIPAL
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_PRINCIPAL(
    engg_basic_infonum,   principal_cd,  subcon_sw,  extract_id,policy_id)
VALUES(
    A.engg_basic_infonum,  A.principal_cd, A.subcon_sw, v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wprincipal_rec


--begin_extract_gipi_wvehicle_rec

FOR A IN(SELECT acquired_from,   assignee,  basic_color_cd,
       car_company_cd,  coc_atcn,  coc_issue_date,
       coc_seq_no,   coc_serial_no, coc_type,
       coc_yy,    color,   color_cd,
       ctv_tag,   destination, est_value,
       item_no,   make,   make_cd,
       model_year,   motor_no,  mot_type,
       mv_file_no,   no_of_pass,  origin,
       plate_no,   repair_lim,  serial_no,
    series_cd,   subline_cd,  subline_type_cd,
    tariff_zone,  towing,   type_of_body_cd,
    unladen_wt,         motor_coverage
       FROM GIPI_WVEHICLE
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_VEHICLE(
    acquired_from,  assignee,  basic_color_cd,
    car_company_cd, coc_atcn,  coc_issue_date,
    coc_seq_no,  coc_serial_no, coc_type,
    coc_yy,   color,   color_cd,
    ctv_tag,   destination, est_value,
    item_no,   make,   make_cd,
    model_year,  motor_no,  mot_type,
    mv_file_no,  no_of_pass,  origin,
    plate_no,  repair_lim,  serial_no,
    series_cd,  subline_cd,  subline_type_cd,
    tariff_zone,  towing,   type_of_body_cd,
    unladen_wt,  extract_id,     motor_coverage,policy_id)
VALUES(
    A.acquired_from,  A.assignee,   A.basic_color_cd,
    A.car_company_cd, A.coc_atcn,   A.coc_issue_date,
    A.coc_seq_no,  A.coc_serial_no, A.coc_type,
    A.coc_yy,   A.color,   A.color_cd,
    A.ctv_tag,   A.destination,  A.est_value,
    A.item_no,   A.make,    A.make_cd,
    A.model_year,  A.motor_no,   A.mot_type,
    A.mv_file_no,  A.no_of_pass,  A.origin,
    A.plate_no,   A.repair_lim,  A.serial_no,
    A.series_cd,   A.subline_cd,  A.subline_type_cd,
    A.tariff_zone,  A.towing,   A.type_of_body_cd,
    A.unladen_wt,  v_extract_id,       A.motor_coverage,p_par_id);
END LOOP;

--end_extract_gipi_wvehicle_rec


--begin_extract_gipi_wves_air_rec

FOR A IN(SELECT rec_flag, vescon,  vessel_cd,
    voy_limit
       FROM GIPI_WVES_AIR
     WHERE par_id = p_par_id)LOOP

INSERT INTO GIXX_VES_AIR(
    rec_flag, vescon,  vessel_cd,
    voy_limit, extract_id,policy_id)
VALUES(
    A.rec_flag, A.vescon,  A.vessel_cd,
    A.voy_limit, v_extract_id,p_par_id);
END LOOP;

--end_extract_gipi_wves_air_rec
COMMIT;
END extract_wpoldoc_record;


END;
/
