CREATE OR REPLACE PACKAGE BODY CPI.populate_pack_gixx_tables AS
/*
Created by  : John Oliver Mendoza
Date        : June 29, 2006
Description : This package populates record on GIXX_PACK_TABLES
*/

-------------------------------Extract_pack_pol_record-------------------------------
PROCEDURE extract_pack_pol_record(
     p_pack_policy_id  gipi_pack_polbasic.pack_policy_id%TYPE,
           v_extract_id      gixx_pack_polbasic.extract_id%TYPE
     )
AS
BEGIN


--begin_extract_gipi_pack_parlist
FOR rec IN (SELECT a1.pack_par_id pack_par_id,   a1.line_cd line_cd,      a1.iss_cd iss_cd,
          a1.par_yy par_yy,      a1.par_seq_no par_seq_no,     a1.quote_seq_no quote_seq_no,
       a1.par_type par_type,      a1.assign_sw assign_sw,     a1.par_status par_status,
       a1.assd_no assd_no,       a1.quote_id quote_id,    a1.underwriter underwriter,
       a1.remarks remarks,       a1.address1 address1,    a1.address2 address2,
       a1.address3 address3,      a1.old_par_status old_par_ststus
     FROM gipi_pack_parlist a1,gipi_pack_polbasic b1
    WHERE 1=1
      AND a1.pack_par_id=b1.pack_par_id
      AND b1.pack_policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_parlist(
             extract_id,   line_cd,   iss_cd,
       par_yy,    par_seq_no,  quote_seq_no,
       par_type,   assign_sw,  par_status,
       assd_no,    quote_id,   underwriter,
       remarks,    address1,   address2,
       address3,   par_id)
   VALUES(   v_extract_id,   rec.line_cd,   rec.iss_cd,
        rec.par_yy,    rec.par_seq_no,  rec.quote_seq_no,
       rec.par_type,   rec.assign_sw,   rec.par_status,
       rec.assd_no,    rec.quote_id,   rec.underwriter,
       rec.remarks,    rec.address1,   rec.address2,
       rec.address3,   rec.pack_par_id
      );
END LOOP;

--end_extract_gipi_pack_parlist

--begin_extract_gipi_pack_polbasic
FOR rec1 IN (SELECT gpp.pack_policy_id pack_policy_id,    gpp.line_cd line_cd,               gpp.subline_cd subline_cd,
         gpp.iss_cd iss_cd,        gpp.issue_yy issue_yy,            gpp.pol_seq_no pol_seq_no,
        gpp.endt_iss_cd endt_iss_cd,     gpp.endt_yy endt_yy,            gpp.endt_seq_no endt_seq_no,
     gpp.renew_no renew_no,       gpp.pack_par_id pack_par_id,          gpp.eff_date eff_date,
     gpp.pol_flag pol_flag,       gpp.invoice_sw invoice_sw,           gpp.auto_renew_flag auto_renew_flag,
     gpp.prov_prem_tag prov_prem_tag,    gpp.pack_pol_flag pack_pol_flag,      gpp.reg_policy_sw reg_policy_sw,
     gpp.co_insurance_sw co_insurance_sw,   gpp.manual_renew_no manual_renew_no,     gpp.old_pol_flag old_pol_flag,
     gpp.endt_type endt_type,      gpp.incept_date incept_date,         gpp.expiry_date expiry_date,
     gpp.expiry_tag expiry_tag,      gpp.issue_date issue_date,           gpp.assd_no assd_no,
     gpp.designation designation,     gpp.address1 address1,            gpp.address2 address2,
     gpp.address3 address3,       gpp.mortg_name mortg_name,           gpp.tsi_amt tsi_amt,
     gpp.prem_amt prem_amt,       gpp.ann_tsi_amt ann_tsi_amt,          gpp.ann_prem_amt ann_prem_amt,
     gpp.pool_pol_no pool_pol_no,     gpp.foreign_acc_sw foreign_acc_sw,         gpp.discount_sw discount_sw,
     gpp.back_stat back_stat,                       gpp.acct_ent_date acct_ent_date,
     gpp.spld_acct_ent_date spld_acct_ent_date, gpp.spld_approval spld_approval,      gpp.spld_date spld_date,
     gpp.spld_user_id spld_user_id,     gpp.spld_flag spld_flag,           gpp.dist_flag dist_flag,
     gpp.orig_policy_id orig_policy_id,    gpp.endt_expiry_date endt_expiry_date,     gpp.no_of_items no_of_items,
     gpp.subline_type_cd subline_type_cd,   gpp.prorate_flag prorate_flag,          gpp.short_rt_percent short_rt_percent,
     gpp.type_cd type_cd,       gpp.acct_of_cd acct_of_cd,           gpp.prov_prem_pct prov_prem_pct,
     gpp.renew_flag renew_flag,      gpp.prem_warr_tag prem_warr_tag,      gpp.ref_pol_no ref_pol_no,
     gpp.ref_open_pol_no ref_open_pol_no,   gpp.incept_tag incept_tag,           gpp.comp_sw comp_sw,
     gpp.booking_mth booking_mth,     gpp.booking_year booking_year,          gpp.endt_expiry_tag endt_expiry_tag,
     gpp.fleet_print_tag fleet_print_tag,   gpp.with_tariff_sw with_tariff_sw,         gpp.polendt_printed_date polendt_printed_date,
     gpp.user_id user_id,       gpp.last_upd_date last_upd_date,      gpp.polendt_printed_cnt polendt_printed_cnt,
     gpp.place_cd place_cd,       gpp.eis_flag eis_flag,            gpp.ren_notice_cnt ren_notice_cnt,
     gpp.ren_notice_date ren_notice_date,   gpp.qd_flag qd_flag,            gpp.actual_renew_no actual_renew_no,
     gpp.validate_tag validate_tag,     gpp.industry_cd industry_cd,          gpp.region_cd region_cd,
     gpp.acct_of_cd_sw acct_of_cd_sw,    gpp.surcharge_sw surcharge_sw,          gpp.cred_branch cred_branch,
     gpp.old_assd_no old_assd_no,      gpp.cancel_date cancel_date,          gpp.label_tag label_tag,
     gpp.old_address1 old_address1,     gpp.old_address2 old_address2,          gpp.old_address3 old_address3,
     gpp.reinstatement_date reinstatement_date, gpp.risk_tag risk_tag,            gpp.renew_extract_tag renew_extract_tag,
     gpp.claims_extract_tag claims_extract_tag
      FROM gipi_pack_polbasic gpp
     WHERE gpp.pack_policy_id=p_pack_policy_id
   )
LOOP
 INSERT INTO gixx_pack_polbasic(
        extract_id,         line_cd,        subline_cd,
     iss_cd,     issue_yy,     pol_seq_no,
     renew_no,    pol_flag,     eff_date,
     incept_date,   expiry_date,    issue_date,
     assd_no,    designation,    type_cd,
     acct_of_cd,    mortg_name,    address1,
     address2,    address3,     tsi_amt,
     prem_amt,    pool_pol_no,    no_of_items,
     subline_type_cd,  short_rt_percent,   prov_prem_pct,
     auto_renew_flag,  prorate_flag,    renew_flag,
     pack_pol_flag,   prov_prem_tag,    expiry_tag,
     foreign_acc_sw,   invoice_sw,    discount_sw,
     ref_pol_no,    prem_warr_tag,    co_insurance_sw,
     reg_policy_sw,   ref_open_pol_no,   manual_renew_no,
     incept_tag,    with_tariff_sw,   surcharge_sw,
     industry_cd,   region_cd,     cred_branch,
     ann_tsi_amt,   dist_flag,     acct_ent_date,
     acct_of_cd_sw,   actual_renew_no,   ann_prem_amt,
     back_stat,    booking_mth,    booking_year,
     cancel_date,   comp_sw,     eis_flag,
     endt_expiry_tag,         endt_iss_cd,
     endt_seq_no,   endt_type,     endt_yy,
     fleet_print_tag,  label_tag,     old_address1,
     old_address2,   old_address3,    old_pol_flag,
     orig_policy_id,   place_cd,     polendt_printed_cnt,
     polendt_printed_date,policy_id,     qd_flag,
     reinstatement_date,  ren_notice_cnt,   ren_notice_date,
     spld_acct_ent_date , spld_approval,     spld_date,
     spld_flag,       spld_user_id,     user_id,
     last_upd_date,    validate_tag,    old_assd_no,endt_expiry_date
       )
  VALUES (  v_extract_id,        rec1.line_cd,      rec1.subline_cd,
        rec1.iss_cd,      rec1.issue_yy,     rec1.pol_seq_no,
     rec1.renew_no,      rec1.pol_flag,     rec1.eff_date,
     rec1.incept_date,     rec1.expiry_date,    rec1.issue_date,
     rec1.assd_no,       rec1.designation,    rec1.type_cd,
     rec1.acct_of_cd,      rec1.mortg_name,    rec1.address1,
     rec1.address2,       rec1.address3,     rec1.tsi_amt,
     rec1.prem_amt,       rec1.pool_pol_no,    rec1.no_of_items,
     rec1.subline_type_cd,     rec1.short_rt_percent,   rec1.prov_prem_pct,
     rec1.auto_renew_flag,     rec1.prorate_flag,    rec1.renew_flag,
     rec1.pack_pol_flag,      rec1.prov_prem_tag,    rec1.expiry_tag,
     rec1.foreign_acc_sw,     rec1.invoice_sw,    rec1.discount_sw,
     rec1.ref_pol_no,      rec1.prem_warr_tag,    rec1.co_insurance_sw,
     rec1.reg_policy_sw,      rec1.ref_open_pol_no,   rec1.manual_renew_no,
     rec1.incept_tag,      rec1.with_tariff_sw,   rec1.surcharge_sw,
     rec1.industry_cd,      rec1.region_cd,     rec1.cred_branch,
     rec1.ann_tsi_amt,      rec1.dist_flag,     rec1.acct_ent_date,
     rec1.acct_of_cd_sw,      rec1.actual_renew_no,   rec1.ann_prem_amt,
     rec1.back_stat,       rec1.booking_mth,    rec1.booking_year,
     rec1.cancel_date,      rec1.comp_sw,     rec1.eis_flag,
     rec1.endt_expiry_tag,             rec1.endt_iss_cd,
     rec1.endt_seq_no,      rec1.endt_type,     rec1.endt_yy,
     rec1.fleet_print_tag,     rec1.label_tag,     rec1.old_address1,
     rec1.old_address2,      rec1.old_address3,    rec1.old_pol_flag,
     rec1.orig_policy_id,     rec1.place_cd,     rec1.polendt_printed_cnt,
     rec1.polendt_printed_date,      rec1.pack_policy_id,   rec1.qd_flag,
     rec1.reinstatement_date,   rec1.ren_notice_cnt,   rec1.ren_notice_date,
     rec1.spld_acct_ent_date ,      rec1.spld_approval,     rec1.spld_date,
     rec1.spld_flag,         rec1.spld_user_id,     rec1.user_id,
     rec1.last_upd_date,     rec1.validate_tag,    rec1.old_assd_no,
  rec1.endt_expiry_date
    );
END LOOP;
--end_extract_gipi_pack_polbasic

--begin_extract_gipi_pack_parhist
/*
FOR rec IN (SELECT pack_par_id,        user_id,      parstat_date,
          entry_source,      parstat_cd
     FROM gipi_pack_parhist
      )
LOOP
 INSERT INTO GIXX_PACK_PARHIST(
         extract_id,        par_id,         user_id,
      parstat_date,      entry_source,       parstat_cd
      )
  VALUES(
      rec.pack_par_id,     rec.pack_par_id,    rec.user_id,
      rec.parstst_cd,     rec.entry_source,    rec.parstat_cd
     )
END LOOP;
*/
--end_extract_gipi_pack_parhist

--begin_extract_gipi_pack_polgenin
FOR rec IN (SELECT pack_policy_id,         gen_info01,      gen_info02,
          gen_info03,       gen_info04,      gen_info05,
       gen_info06,       gen_info07,      gen_info08,
       gen_info09,       gen_info10,      gen_info11,
       gen_info12,       gen_info13,      gen_info14,
       gen_info15,       gen_info16,      gen_info17,
       genin_info_cd,      initial_info01,     initial_info02,
       initial_info03,      initial_info04,     initial_info05,
       initial_info06,      initial_info07,     initial_info08,
       initial_info09,      initial_info10,     initial_info11,
       initial_info12,      initial_info13,     initial_info14,
       initial_info15,      initial_info16,     initial_info17,
       endt_text01,       endt_text02,     endt_text03,
       endt_text04,       endt_text05,     endt_text06,
       endt_text07,       endt_text08,     endt_text09,
       endt_text10,       endt_text11,     endt_text12,
       endt_text13,       endt_text14,     endt_text15,
       endt_text16,       endt_text17,     user_id,
       last_update
        FROM gipi_pack_polgenin
    WHERE pack_policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_polgenin(
          extract_id,                  user_id,
       last_update,       gen_info01,      gen_info02,
          gen_info03,       gen_info04,      gen_info05,
       gen_info06,       gen_info07,      gen_info08,
       gen_info09,       gen_info10,      gen_info11,
       gen_info12,       gen_info13,      gen_info14,
       gen_info15,       gen_info16,      gen_info17,
          initial_info01,      initial_info02,     initial_info03,
       initial_info04,      initial_info05,     initial_info06,
       initial_info07,      initial_info08,     initial_info09,
       initial_info10,      initial_info11,     initial_info12,
       initial_info13,      initial_info14,     initial_info15,
       initial_info16,      initial_info17,     endt_text01,
       endt_text02,       endt_text03,     endt_text04,
       endt_text05,       endt_text06,     endt_text07,
       endt_text08,       endt_text09,     endt_text10,
       endt_text11,       endt_text12,     endt_text13,
       endt_text14,       endt_text15,     endt_text16,
       endt_text17
    )
       VALUES(
         v_extract_id,--rec.pack_policy_id,   change by koks 6.30.15
                      rec.user_id,
       rec.last_update,      rec.gen_info01,     rec.gen_info02,
          rec.gen_info03,      rec.gen_info04,     rec.gen_info05,
       rec.gen_info06,      rec.gen_info07,     rec.gen_info08,
       rec.gen_info09,      rec.gen_info10,     rec.gen_info11,
       rec.gen_info12,      rec.gen_info13,     rec.gen_info14,
       rec.gen_info15,      rec.gen_info16,     rec.gen_info17,
          rec.initial_info01,     rec.initial_info02,    rec.initial_info03,
       rec.initial_info04,     rec.initial_info05,    rec.initial_info06,
       rec.initial_info07,     rec.initial_info08,    rec.initial_info09,
       rec.initial_info10,     rec.initial_info11,    rec.initial_info12,
       rec.initial_info13,     rec.initial_info14,    rec.initial_info15,
       rec.initial_info16,     rec.initial_info17,    rec.endt_text01,
       rec.endt_text02,      rec.endt_text03,    rec.endt_text04,
       rec.endt_text05,      rec.endt_text06,    rec.endt_text07,
       rec.endt_text08,      rec.endt_text09,    rec.endt_text10,
       rec.endt_text11,      rec.endt_text12,    rec.endt_text13,
       rec.endt_text14,      rec.endt_text15,    rec.endt_text16,
       rec.endt_text17
    );
END LOOP;
--end_extract_gipi_pack_polgenin

--begin_extract_gipi_pack_polnrep
FOR rec IN (SELECT pack_policy_id,      old_pack_policy_id,    new_pack_policy_id,
          rec_flag,       ren_rep_sw,      expiry_yy,
       expiry_mm,       user_id,      last_update
        FROM gipi_pack_polnrep
    WHERE pack_policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_polnrep
        (
          extract_id,        old_policy_id,     rec_flag,
       new_policy_id,      expiry_yy,      expiry_mm,
       ren_rep_sw,       user_id,      last_update
     )
   VALUES
     (
             v_extract_id,      rec.old_pack_policy_id,   rec.rec_flag,
       rec.new_pack_policy_id,    rec.expiry_yy,     rec.expiry_mm,
       rec.ren_rep_sw,      rec.user_id,     rec.last_update
     );
END LOOP;
--end_extract_gipi_pack_polnrep

--begin_extract_gipi_pack_line_subline
FOR rec IN (SELECT policy_id,         pack_line_cd,     pack_subline_cd,
          line_cd,        remarks
     FROM gipi_pack_line_subline
       WHERE policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_line_subline
        (
          extract_id,         policy_id,      pack_line_cd,
       pack_subline_cd,      line_cd,      remarks
     )
         VALUES
     (
             v_extract_id,        rec.policy_id,     rec.pack_line_cd,
       rec.pack_subline_cd,     rec.line_cd,     rec.remarks
     );
END LOOP;
--end_extract_gipi_pack_line_subline

--begin_extract_gipi_pack_invoice
FOR rec IN (SELECT iss_cd,         prem_seq_no,     policy_id,
          item_grp,       currency_cd,     currency_rt,
       property,       prem_amt,      tax_amt,
       payt_terms,       insured,      acct_ent_date,
       due_date,       ri_comm_amt,     remarks,
       other_charges,      notarial_fee,     ref_inv_no,
       policy_currency,      bond_rate,      bond_tsi_amt,
       pay_type,       card_name,      card_no,
       expiry_date,       approval_cd,     invoice_printed_date,
       user_id,        last_upd_date,     invoice_printed_cnt,
       ri_comm_vat
        FROM gipi_pack_invoice
    WHERE policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_invoice
        (
          extract_id,        iss_cd,       prem_seq_no,
       item_grp,       currency_cd,     currency_rt,
       prem_amt,       tax_amt,      due_date,
       ri_comm_amt,       other_charges,     notarial_fee,
       ref_inv_no,       policy_currency,    acct_ent_date,
       approval_cd,       bond_rate,      bond_tsi_amt,
       card_name,       card_no,      expiry_date,
       insured,        invoice_printed_cnt,   invoice_printed_date,
       pay_type,       payt_terms,      policy_id,
       property,       remarks,      user_id,
       last_upd_date
     )
   VALUES
     (
             v_extract_id,       rec.iss_cd,      rec.prem_seq_no,
       rec.item_grp,      rec.currency_cd,    rec.currency_rt,
       rec.prem_amt,      rec.tax_amt,     rec.due_date,
       rec.ri_comm_amt,      rec.other_charges,    rec.notarial_fee,
       rec.ref_inv_no,      rec.policy_currency,   rec.acct_ent_date,
       rec.approval_cd,      rec.bond_rate,     rec.bond_tsi_amt,
       rec.card_name,      rec.card_no,     rec.expiry_date,
       rec.insured,       rec.invoice_printed_cnt,  rec.invoice_printed_date,
       rec.pay_type,      rec.payt_terms,     rec.policy_id,
       rec.property,      rec.remarks,     rec.user_id,
       rec.last_upd_date
     );
END LOOP;
--end_extract_gipi_pack_invoice

--begin_extract_gipi_pack_invperl
FOR rec IN (SELECT a1.iss_cd iss_cd,          a1.prem_seq_no prem_seq_no,     a1.line_cd line_cd,
          a1.peril_cd peril_cd,       a1.item_grp item_grp,      a1.tsi_amt tsi_amt,
       a1.prem_amt prem_amt,        a1.ri_comm_amt ri_comm_amt,     a1.ri_comm_rt ri_comm_rt
        FROM gipi_pack_invperl a1, gipi_pack_invoice b1
    WHERE a1.iss_cd=b1.iss_cd
      AND a1.prem_seq_no=b1.prem_seq_no
      AND b1.policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_invperl
     (
         extract_id,        iss_cd,       prem_seq_no,
      peril_cd,        item_grp,      tsi_amt,
      prem_amt,           ri_comm_amt,     ri_comm_rt
     )
      VALUES
     (
            v_extract_id,       rec.iss_cd,      rec.prem_seq_no,
      rec.peril_cd,       rec.item_grp,     rec.tsi_amt,
      rec.prem_amt,       rec.ri_comm_amt,    rec.ri_comm_rt
     );
END LOOP;
--end_extract_gipi_pack_invperl

--begin_extract_gipi_pack_inv_tax
FOR rec IN(SELECT a2.iss_cd iss_cd,        a2.prem_seq_no prem_seq_no,    a2.item_grp item_grp,
      a2.tax_cd tax_cd,       a2.line_cd line_cd,      a2.tax_allocation tax_allocation,
      a2.fixed_tax_allocation,     a2.tax_amt tax_amt,      a2.tax_id tax_id,
      a2.rate rate,        b2.policy_id policy_id
    FROM gipi_pack_inv_tax a2,  gipi_pack_invoice b2
   WHERE a2.iss_cd=b2.iss_cd
     AND a2.prem_seq_no=b2.prem_seq_no
     AND b2.policy_id=p_pack_policy_id
     )
LOOP
 INSERT INTO gixx_pack_inv_tax
        (
            extract_id,              iss_cd,      prem_seq_no,
      tax_cd,         line_cd,      item_grp,
      tax_amt,         tax_id,      tax_allocation,
      fixed_tax_allocation,      rate,       policy_id
     )
   VALUES
     (
            v_extract_id,        rec.iss_cd,       rec.prem_seq_no,
      rec.tax_cd,        rec.line_cd,     rec.item_grp,
      rec.tax_amt,        rec.tax_id,     rec.tax_allocation,
      rec.fixed_tax_allocation,     rec.rate,      rec.policy_id
     );
END LOOP;
--end_extract_gipi_pack_inv_tax

--begin_extract_gipi_pack_polwc
FOR rec IN (SELECT pack_policy_id,       line_cd,       wc_cd,
          swc_seq_no,        print_seq_no,      wc_title,
       wc_text01,        wc_text02,       wc_text03,
       wc_text04,        wc_text05,       wc_text06,
       wc_text07,        wc_text08,       wc_text09,
       wc_text10,        wc_text11,       wc_text12,
       wc_text13,        wc_text14,       wc_text15,
       wc_text16,        wc_text17,       rec_flag,
       wc_remarks,        print_sw,       change_tag
     FROM gipi_pack_polwc
    WHERE pack_policy_id=p_pack_policy_id
   )
LOOP
 INSERT INTO gixx_pack_polwc
         (
        extract_id,          line_cd,       wc_cd,
       swc_seq_no,        print_seq_no,      wc_title,
       wc_text01,        wc_text02,       wc_text03,
       wc_text04,        wc_text05,       wc_text06,
       wc_text07,        wc_text08,       wc_text09,
       wc_text10,        wc_text11,       wc_text12,
       wc_text13,        wc_text14,       wc_text15,
       wc_text16,        wc_text17,           rec_flag,
       wc_remarks,        print_sw,       change_tag
   )
   VALUES
      (
        v_extract_id,       rec.line_cd,      rec.wc_cd,
       rec.swc_seq_no,       rec.print_seq_no,     rec.wc_title,
       rec.wc_text01,       rec.wc_text02,      rec.wc_text03,
       rec.wc_text04,       rec.wc_text05,      rec.wc_text06,
       rec.wc_text07,       rec.wc_text08,      rec.wc_text09,
       rec.wc_text10,       rec.wc_text11,      rec.wc_text12,
       rec.wc_text13,       rec.wc_text14,      rec.wc_text15,
       rec.wc_text16,       rec.wc_text17,          rec.rec_flag,
       rec.wc_remarks,       rec.print_sw,      rec.change_tag
   );
END LOOP;
--end_extract_gipi_pack_polwc

COMMIT;


FOR rec IN(SELECT policy_id
             FROM gipi_polbasic
   WHERE pack_policy_id = p_pack_policy_id)

LOOP
 populate_gixx_tables.extract_poldoc_record(rec.policy_id,v_extract_id);
END LOOP;

COMMIT;
END extract_pack_pol_record;



-------------------------------Extract_pack_par_record-------------------------------

PROCEDURE extract_pack_par_record(
     p_pack_par_id  gipi_pack_parlist.pack_par_id%TYPE,
           v_extract_id         gixx_pack_polbasic.extract_id%TYPE
     )
AS
BEGIN


--begin_extract_gipi_pack_parlist
FOR rec IN (SELECT a.pack_par_id, a.line_cd,   a.iss_cd,
          a.par_yy,   a.par_seq_no, a.quote_seq_no,
       a.par_type,   a.assign_sw,  a.par_status,
       a.assd_no,   a.quote_id, a.underwriter,
       a.remarks,   a.address1, a.address2,
       a.address3,   a.old_par_status
     FROM gipi_pack_parlist a
    WHERE a.pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_parlist(
             extract_id,   line_cd,   iss_cd,
       par_yy,    par_seq_no,  quote_seq_no,
       par_type,   assign_sw,  par_status,
       assd_no,    quote_id,   underwriter,
       remarks,    address1,   address2,
       address3,   par_id)
   VALUES(
        v_extract_id,   rec.line_cd,   rec.iss_cd,
        rec.par_yy,    rec.par_seq_no,  rec.quote_seq_no,
       rec.par_type,   rec.assign_sw,   rec.par_status,
       rec.assd_no,    rec.quote_id,   rec.underwriter,
       rec.remarks,    rec.address1,   rec.address2,
       rec.address3,   rec.pack_par_id
      );
END LOOP;

--end_extract_gipi_pack_parlist

--begin_extract_gipi_pack_wpolbas
FOR rec IN ( SELECT pack_par_id,   line_cd,     subline_cd,
         iss_cd,      issue_yy,    pol_seq_no,
        endt_iss_cd,   endt_yy,    endt_seq_no,
     renew_no,     eff_date,    pol_flag,
     invoice_sw,     auto_renew_flag,  prov_prem_tag,
     pack_pol_flag,    reg_policy_sw,   co_insurance_sw,
     manual_renew_no,  endt_type,     incept_date,
     expiry_date,    back_stat,    user_id,
     expiry_tag,     issue_date,   assd_no,
     designation,   address1,    address2,
     address3,     mortg_name,   tsi_amt,
     prem_amt,     ann_tsi_amt,   ann_prem_amt,
     pool_pol_no,   foreign_acc_sw,  discount_sw,
     orig_policy_id,      no_of_items,
     subline_type_cd,  prorate_flag,   short_rt_percent,
     type_cd,    acct_of_cd,   prov_prem_pct,
     place_cd,     prem_warr_tag,   ref_pol_no,
     ref_open_pol_no,  incept_tag,   comp_sw,
     booking_mth,   booking_year,   endt_expiry_tag,
     fleet_print_tag,  with_tariff_sw,  qd_flag,
     validate_tag,    industry_cd,   region_cd,
     acct_of_cd_sw,    surcharge_sw,   cred_branch,
     old_assd_no,   cancel_date,   label_tag,
     old_address1,    old_address2,   old_address3,
     risk_tag,       quotation_printed_sw, covernote_printed_sw,
     same_polno_sw,   cover_nt_printed_date, cover_nt_printed_cnt,
     endt_expiry_date -- bonok :: 7.1.2015 :: SR 19596 UCPB Fullweb - temp sol
      FROM gipi_pack_wpolbas
     WHERE pack_par_id=p_pack_par_id
   )
LOOP
 INSERT INTO gixx_pack_polbasic(
        extract_id,               line_cd,        subline_cd,
     iss_cd,         issue_yy,     pol_seq_no,
     renew_no,        pol_flag,     eff_date,
     incept_date,       expiry_date,    issue_date,
     assd_no,        designation,    type_cd,
     acct_of_cd,        mortg_name,        address1,
     address2,        address3,     tsi_amt,
     prem_amt,        pool_pol_no,    no_of_items,
     subline_type_cd,      short_rt_percent,   prov_prem_pct,
     auto_renew_flag,      prorate_flag,    pack_pol_flag,
     prov_prem_tag,      expiry_tag,     foreign_acc_sw,
     invoice_sw,       discount_sw,      ref_pol_no,
     prem_warr_tag,      co_insurance_sw,   reg_policy_sw,
     ref_open_pol_no,     manual_renew_no,    incept_tag,
     with_tariff_sw,      surcharge_sw,    industry_cd,
     region_cd,       cred_branch,     ann_tsi_amt,
     acct_of_cd_sw,       ann_prem_amt,    back_stat,
     booking_mth,      booking_year,    cancel_date,
     comp_sw,              endt_expiry_tag,
     endt_iss_cd,      endt_seq_no,    endt_type,
     endt_yy,       fleet_print_tag,   label_tag,
     old_address1,        old_address2,    old_address3,
     orig_policy_id,       place_cd,     qd_flag,
     user_id,          validate_tag,    old_assd_no,
     endt_expiry_date -- bonok :: 7.1.2015 :: SR 19596 UCPB Fullweb - temp sol
       )
  VALUES (  v_extract_id,        rec.line_cd,      rec.subline_cd,
        rec.iss_cd,       rec.issue_yy,     rec.pol_seq_no,
     rec.renew_no,      rec.pol_flag,     rec.eff_date,
     rec.incept_date,     rec.expiry_date,    rec.issue_date,
     rec.assd_no,       rec.designation,    rec.type_cd,
     rec.acct_of_cd,       rec.mortg_name,     rec.address1,
     rec.address2,       rec.address3,     rec.tsi_amt,
     rec.prem_amt,       rec.pool_pol_no,    rec.no_of_items,
     rec.subline_type_cd,     rec.short_rt_percent,   rec.prov_prem_pct,
     rec.auto_renew_flag,     rec.prorate_flag,    rec.pack_pol_flag,
     rec.prov_prem_tag,     rec.expiry_tag,     rec.foreign_acc_sw,
     rec.invoice_sw,      rec.discount_sw,    rec.ref_pol_no,
     rec.prem_warr_tag,     rec.co_insurance_sw,   rec.reg_policy_sw,
     rec.ref_open_pol_no,    rec.manual_renew_no,    rec.incept_tag,
     rec.with_tariff_sw,        rec.surcharge_sw,      rec.industry_cd,
     rec.region_cd,      rec.cred_branch,       rec.ann_tsi_amt,
     rec.acct_of_cd_sw,      rec.ann_prem_amt,    rec.back_stat,
     rec.booking_mth,        rec.booking_year,    rec.cancel_date,
     rec.comp_sw,              rec.endt_expiry_tag,
     rec.endt_iss_cd,     rec.endt_seq_no,     rec.endt_type,
     rec.endt_yy,        rec.fleet_print_tag,    rec.label_tag,
     rec.old_address1,     rec.old_address2,     rec.old_address3,
     rec.orig_policy_id,      rec.place_cd,     rec.qd_flag,
     rec.user_id,      rec.validate_tag,    rec.old_assd_no,
     rec.endt_expiry_date -- bonok :: 7.1.2015 :: SR 19596 UCPB Fullweb - temp sol
    );
END LOOP;
--end_extract_gipi_pack_wpolbas

--begin_extract_gipi_pack_parhist
/*
FOR rec IN (SELECT pack_par_id,        user_id,      parstat_date,
          entry_source,      parstat_cd
     FROM gipi_pack_parhist
    WHERE pack_par_id=p_pack_par_id
      )
LOOP
 INSERT INTO GIXX_PACK_PARHIST(
         extract_id,        par_id,         user_id,
      parstat_date,      entry_source,       parstat_cd
      )
  VALUES(
      v_extract_id,     rec.pack_par_id,    rec.user_id,
      rec.parstst_cd,     rec.entry_source,    rec.parstat_cd
     )
END LOOP;
*/
--end_extract_gipi_pack_parhist

--begin_extract_gipi_pack_wpolgenin
FOR rec IN (SELECT pack_par_id,          gen_info01,      gen_info02,
          gen_info03,       gen_info04,      gen_info05,
       gen_info06,       gen_info07,      gen_info08,
       gen_info09,       gen_info10,      gen_info11,
       gen_info12,       gen_info13,      gen_info14,
       gen_info15,       gen_info16,      gen_info17,
       genin_info_cd,      initial_info01,     initial_info02,
       initial_info03,      initial_info04,     initial_info05,
       initial_info06,      initial_info07,     initial_info08,
       initial_info09,      initial_info10,     initial_info11,
       initial_info12,      initial_info13,     initial_info14,
       initial_info15,      initial_info16,     initial_info17,
       user_id,        last_update,     agreed_tag
        FROM gipi_pack_wpolgenin
    WHERE pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_polgenin(
          extract_id,          agreed_tag,      user_id,
       last_update,       gen_info01,      gen_info02,
          gen_info03,       gen_info04,      gen_info05,
       gen_info06,       gen_info07,      gen_info08,
       gen_info09,       gen_info10,      gen_info11,
       gen_info12,       gen_info13,      gen_info14,
       gen_info15,       gen_info16,      gen_info17,
          initial_info01,      initial_info02,     initial_info03,
       initial_info04,      initial_info05,     initial_info06,
       initial_info07,      initial_info08,     initial_info09,
       initial_info10,      initial_info11,     initial_info12,
       initial_info13,      initial_info14,     initial_info15,
       initial_info16,      initial_info17

    )
       VALUES(
         v_extract_id,         rec.agreed_tag,     rec.user_id,
       rec.last_update,      rec.gen_info01,     rec.gen_info02,
          rec.gen_info03,      rec.gen_info04,     rec.gen_info05,
       rec.gen_info06,      rec.gen_info07,     rec.gen_info08,
       rec.gen_info09,      rec.gen_info10,     rec.gen_info11,
       rec.gen_info12,      rec.gen_info13,     rec.gen_info14,
       rec.gen_info15,      rec.gen_info16,     rec.gen_info17,
          rec.initial_info01,     rec.initial_info02,    rec.initial_info03,
       rec.initial_info04,     rec.initial_info05,    rec.initial_info06,
       rec.initial_info07,     rec.initial_info08,    rec.initial_info09,
       rec.initial_info10,     rec.initial_info11,    rec.initial_info12,
       rec.initial_info13,     rec.initial_info14,    rec.initial_info15,
       rec.initial_info16,     rec.initial_info17
    );
END LOOP;
--end_extract_gipi_pack_wpolgenin

--begin_extract_gipi_pack_wpolnrep
FOR rec IN (SELECT pack_par_id,       old_pack_policy_id,    rec_flag,
                   ren_rep_sw,       user_id,      last_update
        FROM gipi_pack_wpolnrep
    WHERE pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_polnrep
        (
          extract_id,        old_policy_id,     rec_flag,
       ren_rep_sw,       user_id,      last_update
     )
   VALUES
     (
             v_extract_id,       rec.old_pack_policy_id,   rec.rec_flag,
       rec.ren_rep_sw,      rec.user_id,     rec.last_update
     );
END LOOP;
--end_extract_gipi_pack_wpolnrep

--begin_extract_gipi_wpack_line_subline
FOR rec IN (SELECT a3.par_id,          a3.pack_line_cd,     a3.pack_subline_cd,
          a3.line_cd,        a3.remarks,       b3.pack_policy_id
     FROM gipi_wpack_line_subline a3, gipi_pack_polbasic b3
       WHERE 1=1
      AND a3.pack_par_id=b3.pack_par_id
      AND a3.pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_line_subline
        (
          extract_id,         policy_id,      pack_line_cd,
       pack_subline_cd,      line_cd,      remarks
     )
         VALUES
     (
             v_extract_id,        rec.pack_policy_id,    rec.pack_line_cd,
       rec.pack_subline_cd,     rec.line_cd,     rec.remarks
     );
END LOOP;
--end_extract_gipi_wpack_line_subline

--begin_extract_gipi_pack_winvoice
FOR rec IN (SELECT pack_par_id,        prem_seq_no,     item_grp,
          currency_cd,       currency_rt,        property,
       prem_amt,       tax_amt,               payt_terms,
       insured,        due_date,      ri_comm_amt,
       remarks,            other_charges,     notarial_fee,
       ref_inv_no,          policy_currency,       bond_rate,
       bond_tsi_amt,         pay_type,      card_name,
       card_no,        expiry_date,     approval_cd,
       ri_comm_vat
        FROM gipi_pack_winvoice
    WHERE pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_invoice
        (
          extract_id,        prem_seq_no,          item_grp,
       currency_cd,       currency_rt,        prem_amt,
       tax_amt,        due_date,           ri_comm_amt,
       other_charges,       notarial_fee,          ref_inv_no,
       policy_currency,      approval_cd,     bond_rate,
       bond_tsi_amt,          card_name,      card_no,
       expiry_date,             insured,      pay_type,
       payt_terms,          property,      remarks
     )
   VALUES
     (
             v_extract_id,       rec.prem_seq_no,       rec.item_grp,
       rec.currency_cd,      rec.currency_rt,        rec.prem_amt,
       rec.tax_amt,       rec.due_date,        rec.ri_comm_amt,
       rec.other_charges,     rec.notarial_fee,       rec.ref_inv_no,
       rec.policy_currency,     rec.approval_cd,    rec.bond_rate,
       rec.bond_tsi_amt,        rec.card_name,     rec.card_no,
       rec.expiry_date,         rec.insured,        rec.pay_type,
       rec.payt_terms,         rec.property,     rec.remarks
     );
END LOOP;
--end_extract_gipi_pack_winvoice

--begin_extract_gipi_pack_winvperl
FOR rec IN (SELECT pack_par_id,       line_cd,                  peril_cd,
          item_grp,          tsi_amt,      prem_amt,
       ri_comm_amt,       ri_comm_rt
        FROM gipi_pack_winvperl
    WHERE pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_invperl
     (
         extract_id,        peril_cd,      prem_amt,
      ri_comm_amt,       ri_comm_rt,      item_grp,
      tsi_amt,        par_id
     )
      VALUES
     (
            v_extract_id,        rec.peril_cd,     rec.prem_amt,
      rec.ri_comm_amt,      rec.ri_comm_rt,     rec.item_grp,
      rec.tsi_amt,       rec.pack_par_id
     );
END LOOP;
--end_extract_gipi_pack_winvperl

--begin_extract_gipi_pack_winv_tax
FOR rec IN(SELECT a2.pack_par_id pack_par_id,      a2.iss_cd iss_cd,        a2.item_grp item_grp,
      a2.tax_cd tax_cd,         a2.line_cd line_cd,      a2.tax_allocation tax_allocation,
      a2.fixed_tax_allocation fixed_tax_allocation,  a2.tax_amt tax_amt,      a2.tax_id tax_id,
      a2.rate rate
    FROM gipi_pack_winv_tax a2
   WHERE a2.pack_par_id=p_pack_par_id
     )
LOOP
 INSERT INTO gixx_pack_inv_tax
        (
            extract_id,              iss_cd,      par_id,
      tax_cd,         line_cd,      item_grp,
      tax_amt,         tax_id,      tax_allocation,
      fixed_tax_allocation,      rate

     )
   VALUES
     (
            v_extract_id,        rec.iss_cd,       rec.pack_par_id,
      rec.tax_cd,        rec.line_cd,     rec.item_grp,
      rec.tax_amt,        rec.tax_id,     rec.tax_allocation,
      rec.fixed_tax_allocation,     rec.rate

     );
END LOOP;
--end_extract_gipi_pack_winv_tax

--begin_extract_gipi_pack_wpolwc
FOR rec IN (SELECT pack_par_id,         line_cd,       wc_cd,
          swc_seq_no,        print_seq_no,      wc_title,
       wc_text01,        wc_text02,       wc_text03,
       wc_text04,        wc_text05,       wc_text06,
       wc_text07,        wc_text08,       wc_text09,
       wc_text10,        wc_text11,       wc_text12,
       wc_text13,        wc_text14,       wc_text15,
       wc_text16,        wc_text17,       rec_flag,
       wc_remarks,        print_sw,       change_tag,
       wc_title2
     FROM gipi_pack_wpolwc
    WHERE pack_par_id=p_pack_par_id
   )
LOOP
 INSERT INTO gixx_pack_polwc
         (
        extract_id,          line_cd,       wc_cd,
       swc_seq_no,        print_seq_no,      wc_title,
       wc_text01,        wc_text02,       wc_text03,
       wc_text04,        wc_text05,       wc_text06,
       wc_text07,        wc_text08,       wc_text09,
       wc_text10,        wc_text11,       wc_text12,
       wc_text13,        wc_text14,       wc_text15,
       wc_text16,        wc_text17,           rec_flag,
       wc_remarks,        print_sw,       change_tag,
       wc_title2
   )
   VALUES
      (
        v_extract_id,       rec.line_cd,      rec.wc_cd,
       rec.swc_seq_no,       rec.print_seq_no,     rec.wc_title,
       rec.wc_text01,       rec.wc_text02,      rec.wc_text03,
       rec.wc_text04,       rec.wc_text05,      rec.wc_text06,
       rec.wc_text07,       rec.wc_text08,      rec.wc_text09,
       rec.wc_text10,       rec.wc_text11,      rec.wc_text12,
       rec.wc_text13,       rec.wc_text14,      rec.wc_text15,
       rec.wc_text16,       rec.wc_text17,          rec.rec_flag,
       rec.wc_remarks,       rec.print_sw,      rec.change_tag,
       rec.wc_title2
   );
END LOOP;
--end_extract_gipi_pack_wpolwc

COMMIT;

FOR rec IN(SELECT par_id
             FROM gipi_parlist
            WHERE pack_par_id = p_pack_par_id
     AND par_status <> 99)

LOOP
 populate_gixx_tables.extract_wpoldoc_record(rec.par_id,v_extract_id);
END LOOP;

END extract_pack_par_record;


END;
/
