CREATE OR REPLACE PACKAGE CPI.Endt_Ref_Cursor_Pkg
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 05.10.2011
    **  Reference By     : Endorsement Modules
    **  Description     : Contains different row types of every table used in endorsement
    */
    TYPE gipis031_wendttext_type IS RECORD (
        endt_text    GIPI_WENDTTEXT.endt_text%TYPE,
        endt_tax    GIPI_WENDTTEXT.endt_tax%TYPE,
        endt_text01    GIPI_WENDTTEXT.endt_text01%TYPE,
        endt_text02    GIPI_WENDTTEXT.endt_text02%TYPE,
        endt_text03    GIPI_WENDTTEXT.endt_text03%TYPE,
        endt_text04    GIPI_WENDTTEXT.endt_text04%TYPE,
        endt_text05    GIPI_WENDTTEXT.endt_text05%TYPE,
        endt_text06    GIPI_WENDTTEXT.endt_text06%TYPE,
        endt_text07    GIPI_WENDTTEXT.endt_text07%TYPE,
        endt_text08    GIPI_WENDTTEXT.endt_text08%TYPE,
        endt_text09    GIPI_WENDTTEXT.endt_text09%TYPE,
        endt_text10    GIPI_WENDTTEXT.endt_text10%TYPE,
        endt_text11    GIPI_WENDTTEXT.endt_text11%TYPE,
        endt_text12    GIPI_WENDTTEXT.endt_text12%TYPE,
        endt_text13    GIPI_WENDTTEXT.endt_text13%TYPE,
        endt_text14    GIPI_WENDTTEXT.endt_text14%TYPE,
        endt_text15    GIPI_WENDTTEXT.endt_text15%TYPE,
        endt_text16    GIPI_WENDTTEXT.endt_text16%TYPE,
        endt_text17    GIPI_WENDTTEXT.endt_text17%TYPE,
        endt_cd        GIPI_WENDTTEXT.endt_cd%TYPE);
    TYPE gipis031_wpolgenin_type IS RECORD (
        gen_info01    GIPI_WPOLGENIN.gen_info01%TYPE,
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
        par_id            GIPI_PARLIST.par_id%TYPE,
        line_cd            GIPI_PARLIST.line_cd%TYPE,
        iss_cd            GIPI_PARLIST.iss_cd%TYPE,
        par_yy            GIPI_PARLIST.par_yy%TYPE,
        par_seq_no        GIPI_PARLIST.par_seq_no%TYPE,
        quote_seq_no    GIPI_PARLIST.quote_seq_no%TYPE,
        par_type        GIPI_PARLIST.par_type%TYPE,
        par_status        GIPI_PARLIST.par_status%TYPE,
        assd_no            GIPI_PARLIST.assd_no%TYPE,
        address1        GIPI_PARLIST.address1%TYPE,
        address2        GIPI_PARLIST.address2%TYPE,
        address3        GIPI_PARLIST.address3%TYPE);
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
        issue_date            GIPI_WPOLBAS.issue_date%TYPE,
        pack_pol_flag        GIPI_WPOLBAS.pack_pol_flag%TYPE);
    TYPE gipis031_cancel_records_type IS RECORD (
        endorsement            VARCHAR2(150),
        policy_id            GIPI_POLBASIC.policy_id%TYPE);
    TYPE cancel_record_tab IS TABLE OF gipis031_cancel_records_type;
    TYPE endt_fi_item_type IS RECORD (
      ann_tsi_amt            gipi_witem.ann_tsi_amt%TYPE,
      ann_prem_amt           gipi_witem.ann_prem_amt%TYPE,
      rec_flag               gipi_witem.rec_flag%TYPE,
      item_no                gipi_witem.item_no%TYPE,
      item_title             gipi_witem.item_title%TYPE,
      currency_cd            gipi_witem.currency_cd%TYPE,
      currency_desc          giis_currency.currency_desc%TYPE,
      currency_rt            gipi_witem.currency_rt%TYPE,
      coverage_cd            gipi_witem.coverage_cd%TYPE,
      coverage_desc          giis_coverage.coverage_desc%TYPE,
      group_cd               gipi_witem.group_cd%TYPE,
      group_desc             giis_group.group_desc%TYPE,
      risk_no                gipi_witem.risk_no%TYPE,
      risk_item_no           gipi_witem.risk_item_no%TYPE,
      block_no               gipi_wfireitm.block_no%TYPE,
      district_no            gipi_wfireitm.district_no%TYPE,
      block_id               gipi_wfireitm.block_id%TYPE,
      risk_cd                gipi_wfireitm.risk_cd%TYPE,
      risk_desc              giis_risks.risk_desc%TYPE,
      province_cd            giis_province.province_cd%TYPE,
      province_desc          giis_province.province_desc%TYPE,
      city_cd                giis_block.city_cd%TYPE,
      city                   giis_block.city%TYPE,
      eq_zone                giis_eqzone.eq_zone%TYPE,
      eq_desc                giis_eqzone.eq_desc%TYPE,
      flood_zone             giis_flood_zone.flood_zone%TYPE,
      flood_zone_desc        giis_flood_zone.flood_zone_desc%TYPE,
      typhoon_zone           giis_typhoon_zone.typhoon_zone%TYPE,
      typhoon_zone_desc      giis_typhoon_zone.typhoon_zone_desc%TYPE,
      tariff_zone            giis_tariff_zone.tariff_zone%TYPE,
      tariff_zone_desc       giis_tariff_zone.tariff_zone_desc%TYPE,
      tarf_cd                gipi_wfireitm.tarf_cd%TYPE,
      region_cd              gipi_witem.region_cd%TYPE,
      region_desc            giis_region.region_desc%TYPE,
      item_desc              gipi_witem.item_desc%TYPE,
      other_info             gipi_witem.other_info%TYPE,
      from_date              gipi_witem.from_date%TYPE,
      TO_DATE                gipi_witem.TO_DATE%TYPE,
      assignee               gipi_wfireitm.assignee%TYPE,
      fr_item_type           giis_fi_item_type.fr_itm_tp_ds%TYPE,
      fr_itm_tp_ds           giis_fi_item_type.fr_itm_tp_ds%TYPE,
      construction_cd        giis_fire_construction.construction_cd%TYPE,
      construction_desc      giis_fire_construction.construction_desc%TYPE,
      construction_remarks   gipi_fireitem.construction_remarks%TYPE,
      loc_risk1              gipi_wfireitm.loc_risk1%TYPE,
      loc_risk2              gipi_wfireitm.loc_risk2%TYPE,
      loc_risk3              gipi_wfireitm.loc_risk3%TYPE,
      front                  gipi_wfireitm.front%TYPE,
      rear                   gipi_wfireitm.rear%TYPE,
      LEFT                   gipi_wfireitm.LEFT%TYPE,
      RIGHT                  gipi_wfireitm.RIGHT%TYPE,
      occupancy_cd           giis_fire_occupancy.occupancy_cd%TYPE,
      occupancy_desc         giis_fire_occupancy.occupancy_desc%TYPE,
      occupancy_remarks      gipi_wfireitm.occupancy_remarks%TYPE
   );
   TYPE rc_endt_fi_item IS REF CURSOR
      RETURN endt_fi_item_type;
   TYPE endt_mc_item_type IS RECORD (
      item_no               gipi_witem.item_no%TYPE,
      item_title            gipi_witem.item_title%TYPE,
      ann_tsi_amt           gipi_witem.ann_tsi_amt%TYPE,
      ann_prem_amt          gipi_witem.ann_prem_amt%TYPE,
      rec_flag              gipi_witem.rec_flag%TYPE,
      currency_rt           gipi_witem.currency_rt%TYPE,
      coverage_cd           gipi_witem.coverage_cd%TYPE,
      coverage_desc         giis_coverage.coverage_desc%TYPE,
      group_cd              gipi_witem.group_cd%TYPE,
      group_desc            giis_group.group_desc%TYPE,
      currency_cd           gipi_witem.currency_cd%TYPE,
      currency_desc         giis_currency.currency_desc%TYPE,
      short_name            giis_currency.short_name%TYPE,
      region_cd             gipi_witem.region_cd%TYPE,
      region_desc           giis_region.region_desc%TYPE,
      subline_cd            gipi_wvehicle.subline_cd%TYPE,
      motor_coverage        gipi_wvehicle.motor_coverage%TYPE,
      motor_coverage_desc   cg_ref_codes.rv_meaning%TYPE,
      assignee              gipi_wvehicle.assignee%TYPE,
      origin                gipi_wvehicle.origin%TYPE,
      plate_no              gipi_wvehicle.plate_no%TYPE,
      mv_file_no            gipi_wvehicle.mv_file_no%TYPE,
      basic_color_cd        gipi_wvehicle.basic_color_cd%TYPE,
      mot_type              gipi_wvehicle.mot_type%TYPE,
      motor_type_desc       giis_motortype.motor_type_desc%TYPE,
      serial_no             gipi_wvehicle.serial_no%TYPE,
      coc_type              gipi_wvehicle.coc_type%TYPE,
      coc_yy                gipi_wvehicle.coc_yy%TYPE,
      --coc_serial_no         gipi_wvehicle.coc_serial_no%TYPE,
      acquired_from         gipi_wvehicle.acquired_from%TYPE,
      destination           gipi_wvehicle.destination%TYPE,
      model_year            gipi_wvehicle.model_year%TYPE,
      no_of_pass            gipi_wvehicle.no_of_pass%TYPE,
      color_cd              gipi_wvehicle.color_cd%TYPE,
      color                 gipi_wvehicle.color%TYPE,
      unladen_wt            gipi_wvehicle.unladen_wt%TYPE,
      subline_type_cd       giis_mc_subline_type.subline_type_cd%TYPE,
      subline_type_desc     giis_mc_subline_type.subline_type_desc%TYPE,
      motor_no              gipi_wvehicle.motor_no%TYPE,
      type_of_body_cd       gipi_wvehicle.type_of_body_cd%TYPE,
      car_company_cd        gipi_wvehicle.car_company_cd%TYPE,
      car_company           giis_mc_car_company.car_company%TYPE,
      make                  gipi_wvehicle.make%TYPE,
      make_cd               gipi_wvehicle.make_cd%TYPE,
      series_cd             gipi_wvehicle.series_cd%TYPE,
      towing                gipi_wvehicle.towing%TYPE,
      repair_lim            gipi_wvehicle.repair_lim%TYPE
   );
   TYPE rc_endt_mc_item IS REF CURSOR
      RETURN endt_mc_item_type;
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
    TYPE RC_GIPI_WPOLGENIN    IS REF CURSOR RETURN GIPI_WPOLGENIN%ROWTYPE;
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
    TYPE RC_GIPI_WITMPERL_GROUPED IS REF CURSOR RETURN GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_type;
    TYPE RC_GIPI_GROUPED_ITEMS IS REF CURSOR RETURN GIPI_GROUPED_ITEMS_PKG.gipi_grouped_items_type;
    TYPE RC_GIPI_ITMPERIL_GROUPED IS REF CURSOR RETURN GIPI_ITMPERIL_GROUPED_PKG.gipi_itmperil_grouped_type;
    TYPE RC_GIPI_GRP_ITEMS_BENEFICIARY IS REF CURSOR RETURN GIPI_GRP_ITEMS_BENEFICIARY_PKG.gipi_grp_items_ben_type;
END Endt_Ref_Cursor_Pkg;
/


