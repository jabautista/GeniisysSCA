CREATE OR REPLACE PACKAGE BODY CPI.pack_quote_to_par
/* Created by: Aaron
** Created on: May 06, 2008
** This package procedure will copy records from quotation tables
** to PAR tables during creation of PAR from a package. This package
** is called used by module GIPIS050A.
*/

AS


PROCEDURE create_parlist_wpack (p_pack_quote_id   NUMBER,
                          p_line_cd    giis_line.line_cd%TYPE,
        p_pack_par_id   NUMBER,
        p_iss_cd    gipi_parlist.iss_cd%TYPE,
        p_assd_no    gipi_parlist.assd_no%TYPE)
IS
/*
** This package procedure will insert records into gipi_wpack_line_subline
** and gipi_parlist.
*/
v_line_cd   VARCHAR2(10);
v_subline_cd  VARCHAR2(20);
v_remarks       VARCHAR2(4000);
v_par_id        NUMBER(20);
v_quote_id      NUMBER;
v_assd_no  NUMBER;


BEGIN

  FOR x IN (SELECT quote_id,line_cd, subline_cd,remarks,assd_no
              FROM gipi_quote
             WHERE pack_quote_id = p_pack_quote_id)
  LOOP
    v_quote_id     := x.quote_id;
    v_line_cd     := x.line_cd;
    v_subline_cd   := x.subline_cd;
    v_remarks     := x.remarks;
    --v_assd_no     := x.assd_no;


    SELECT  PARLIST_PAR_ID_S.NEXTVAL
   INTO  v_par_id
      FROM  SYS.DUAL;

    INSERT INTO gipi_wpack_line_subline (par_id, pack_line_cd, pack_subline_cd,
                                         line_cd, remarks, item_tag,pack_par_id)
                                  VALUES(v_par_id,v_line_cd, v_subline_cd,
                                         p_line_cd, v_remarks, NULL,p_pack_par_id);

    INSERT INTO gipi_parlist (par_id, line_cd,iss_cd,par_yy,par_type,assign_sw,
                            par_status,quote_seq_no,pack_par_id,quote_id,assd_no)
                    VALUES (v_par_id,v_line_cd,p_ISS_CD,to_char(SYSDATE,'YY'),'P',
             'Y',2,0,p_pack_par_id,v_quote_id,p_assd_no);

  END LOOP;
END;



PROCEDURE create_pack_wpolbas (p_pack_quote_id   NUMBER,
                               p_pack_par_id   NUMBER,
            p_assd_no    NUMBER,
            p_line_cd    giis_line.line_cd%TYPE,
          p_iss_cd     gipi_parlist.iss_cd%TYPE,
          p_issue_date    gipi_wpolbas.issue_date%TYPE,
          p_user     gipi_pack_wpolbas.user_id%TYPE,
          p_booking_mth   gipi_wpolbas.booking_mth%TYPE,
          p_booking_yr    gipi_wpolbas.booking_year%TYPE)

/* This procedure will insert records into
** gipi_wpolbas and gipi_pack_wpolbas
*/
IS
  v_line_cd                gipi_wpolbas.line_cd%TYPE;
  v_iss_cd          gipi_wpolbas.iss_cd%TYPE;
  v_subline_cd      gipi_wpolbas.subline_cd%TYPE;
  v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
  v_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE;
  v_incept_date      gipi_wpolbas.incept_date%TYPE;
  v_expiry_date      gipi_wpolbas.expiry_date%TYPE;
  v_eff_date      gipi_wpolbas.eff_date%TYPE;
  v_issue_date      gipi_wpolbas.issue_date%TYPE;
  v_assd_no          gipi_wpolbas.assd_no%TYPE;
  v_designation      gipi_wpolbas.designation%TYPE;
  v_address1      gipi_wpolbas.address1%TYPE;
  v_address2      gipi_wpolbas.address2%TYPE;
  v_address3      gipi_wpolbas.address3%TYPE;
  v_tsi_amt          gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt      gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt      gipi_wpolbas.ann_tsi_amt%TYPE;
  v_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE;
  v_user_id          gipi_wpolbas.user_id%TYPE;
  v_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE;
  v_prorate_flag     gipi_wpolbas.prorate_flag%TYPE;
  v_short_rt_percent    gipi_wpolbas.short_rt_percent%TYPE;
  v_comp_sw                gipi_wpolbas.comp_sw%TYPE;
  v_booking_mth            gipi_wpolbas.booking_mth%TYPE;
  v_booking_yr             gipi_wpolbas.booking_year%TYPE;
  v_prod_take_up           giac_parameters.param_value_n%type;
  v_later_date             gipi_wpolbas.issue_date%TYPE;
  v_par_id       NUMBER;
  v_bank_ref_no  gipi_wpolbas.bank_ref_no%TYPE;   --added by aliza 07112011


  CURSOR cur_b IS SELECT SUBLINE_CD,NVL(tsi_amt,0),NVL(prem_amt,0),NVL(print_tag,'N'),
         incept_date,expiry_date, address1, address2, address3, prorate_flag,
         short_rt_percent, comp_sw, ann_prem_amt, ann_tsi_amt, bank_ref_no -- edited by aliza 07112011 added bank_ref_no
                   FROM gipi_pack_quote
                  WHERE pack_quote_id = p_pack_quote_id;

  CURSOR cur_a IS SELECT par_id, quote_id
                    FROM gipi_parlist
                   WHERE pack_par_id = p_pack_par_id;


BEGIN

  OPEN CUR_B;
  FETCH CUR_B
   INTO v_subline_cd,
        v_tsi_amt,
  v_prem_amt,
  v_quotation_printed_sw,
  v_incept_date,
  v_expiry_date,
  v_address1,
        v_address2,
  v_address3,
  v_prorate_flag,
  v_short_rt_percent,
  v_comp_sw,
  v_ann_prem_amt,
  v_ann_tsi_amt,
  v_bank_ref_no;    --added by aliza 07112011
  CLOSE CUR_B;

  FOR A IN (SELECT designation
           FROM giis_assured
          WHERE assd_no = p_assd_no)
  LOOP
    v_designation := A.DESIGNATION;
    EXIT;
  END LOOP;

  v_line_cd      := p_line_cd;
  v_iss_cd       := p_iss_cd;
  v_issue_date   := p_issue_date;
  v_booking_mth  := p_booking_mth;
  v_booking_yr   := p_booking_yr;


  INSERT INTO gipi_pack_wpolbas
         (pack_par_id,line_cd,subline_cd,iss_cd, issue_yy, pol_seq_no,
          endt_iss_cd,endt_yy, endt_seq_no, renew_no, endt_type,
          incept_date, expiry_date, eff_date, issue_date,
          pol_flag, foreign_acc_sw, assd_no, designation,
          address1, address2, address3, mortg_name,
          tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
          invoice_sw, pool_pol_no, user_id, quotation_printed_sw,
          covernote_printed_sw, orig_policy_id, endt_expiry_date,
          no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
          short_rt_percent, prov_prem_tag, type_cd, acct_of_cd,
          prov_prem_pct, same_polno_sw, pack_pol_flag,  expiry_tag,
          prem_warr_tag,ref_pol_no,ref_open_pol_no,reg_policy_sw,co_insurance_sw,
          discount_sw,fleet_print_tag,incept_tag,comp_sw,booking_mth,
          endt_expiry_tag,booking_year, bank_ref_no) --edited by aliza 07112011 added bank_ref_no
  VALUES (p_pack_par_id,v_line_cd,v_subline_cd,v_iss_cd,
         TO_NUMBER(TO_CHAR(SYSDATE,'YY')), v_pol_seq_no,NULL,0,
         0,0,NULL,v_incept_date,v_expiry_date,v_incept_date,
         v_issue_date,1, 'N', p_assd_no, v_designation,
         v_address1, v_address2, v_address3, NULL,v_tsi_amt, v_prem_amt,
         v_ann_tsi_amt, v_ann_prem_amt,'N', NULL,p_user,
         v_quotation_printed_sw,'N',NULL,
         NULL,NULL,NULL, 'N',
         v_prorate_flag,v_short_rt_percent,'N',NULL,NULL,
         NULL,'N','Y','N','N',
         NULL,NULL,'Y',1,
         'N','N','N',v_comp_sw,v_booking_mth,
         NULL,v_booking_yr, v_bank_ref_no); --edited by aliza 07112011 added v_bank_ref_no


  FOR d IN cur_a
  LOOP
    FOR x in (SELECT line_cd, SUBLINE_CD,NVL(a.tsi_amt,0) tsi_amt,NVL(a.prem_amt,0) prem_amt,NVL(a.print_tag,'N') print_tag,
              a.incept_date,a.expiry_date, a.address1, a.address2, a.address3, a.prorate_flag,
              a.short_rt_percent, a.comp_sw, a.ann_prem_amt, a.ann_tsi_amt, a.bank_ref_no /*edited by aliza 07112011 added bank_ref_no*/
                 FROM gipi_quote a
                 WHERE 1=1
                   AND a.quote_id = d.quote_id
                   AND a.pack_quote_id = p_pack_quote_id)
    LOOP

    v_line_cd          := x.line_cd;
    v_subline_cd         := x.subline_cd;
    v_tsi_amt          := x.tsi_amt;
    v_prem_amt          := x.prem_amt;
    v_quotation_printed_sw := x.print_tag;
    v_incept_date      := x.incept_date;
    v_expiry_date      := x.expiry_date;
    v_address1       := x.address1;
    v_address2       := x.address2;
    v_address3       := x.address3;
    v_prorate_flag      := x.prorate_flag;
    v_short_rt_percent     := x.short_rt_percent;
    v_comp_sw       := x.comp_sw;
    v_ann_prem_amt      := x.ann_prem_Amt;
    v_ann_tsi_amt      := x.ann_Tsi_amt;
    v_par_id       := d.par_id;
    v_bank_ref_no  := x.bank_ref_no;    --added by aliza 07112011 to add bank_ref no on details transferred to gipi_wpolbas


    INSERT INTO gipi_wpolbas
           (par_id,line_cd,subline_cd,iss_cd, issue_yy, pol_seq_no,
            endt_iss_cd,endt_yy, endt_seq_no, renew_no, endt_type,
            incept_date, expiry_date, eff_date, issue_date,
            pol_flag, foreign_acc_sw, assd_no, designation,
            address1, address2, address3, mortg_name,
            tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
            invoice_sw, pool_pol_no, user_id, quotation_printed_sw,
            covernote_printed_sw, orig_policy_id, endt_expiry_date,
            no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
            short_rt_percent, prov_prem_tag, type_cd, acct_of_cd,
            prov_prem_pct, same_polno_sw, pack_pol_flag,  expiry_tag,
            prem_warr_tag,ref_pol_no,ref_open_pol_no,reg_policy_sw,co_insurance_sw,
            discount_sw,fleet_print_tag,incept_tag,comp_sw,booking_mth,
            endt_expiry_tag,booking_year,pack_par_id, bank_ref_no) --edited by aliza 07112011 added bank_ref_no
    VALUES ( v_par_id,v_line_cd,v_subline_cd,v_iss_cd,
           TO_NUMBER(TO_CHAR(SYSDATE,'YY')), v_pol_seq_no,NULL,0,
           0,0,NULL,v_incept_date,v_expiry_date,v_incept_date,
           v_issue_date,1, 'N', p_assd_no, v_designation,
           v_address1, v_address2, v_address3, NULL,v_tsi_amt, v_prem_amt,
           v_ann_tsi_amt, v_ann_prem_amt,'N', NULL,p_user,
           v_quotation_printed_sw,'N',NULL,
           NULL,NULL,NULL, 'N',
           v_prorate_flag,v_short_rt_percent,'N',NULL,NULL,
           NULL,'N','Y','N','N',
           NULL,NULL,'Y',1,
           'N','N','N',v_comp_sw,v_booking_mth,
           NULL,v_booking_yr,p_pack_par_id, v_bank_ref_no); --edited by aliza 07112011 added v_bank_ref_no

    END LOOP;
  END LOOP;

  UPDATE GIPI_PACK_PARLIST
     SET PAR_STATUS = 3
   WHERE PACK_PAR_ID = p_pack_par_id;

  UPDATE GIPI_PARLIST
     SET PAR_STATUS = 3
   WHERE PACK_PAR_ID = p_pack_par_id;



END;

PROCEDURE create_item_info (p_pack_par_id NUMBER, p_pack_quote_id NUMBER) IS
/* This procedure will check the lines included in a package quotation and
** then copy records from quotation tables to par tables depending on the
** lines.
*/
with_mc          VARCHAR2(1);
with_av      VARCHAR2(1);
with_mh          VARCHAR2(1);
with_mn          VARCHAR2(1);
with_ca          VARCHAR2(1);
with_ac          VARCHAR2(1);
with_en          VARCHAR2(1);
with_fi          VARCHAR2(1);
v_line_cd   giis_line.line_cd%TYPE;


CURSOR mc IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_MC');

CURSOR av IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_AV');

CURSOR mh IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_MH');

CURSOR mn IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_MN');

CURSOR ca IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_CA');

CURSOR ac IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_AC');

CURSOR en IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_EN');

CURSOR fi IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id
     AND line_Cd = giisp.v('LINE_CODE_FI');


BEGIN

  FOR x IN (SELECT quote_id,line_cd, subline_cd,remarks,assd_no
                     FROM gipi_quote
                    WHERE pack_quote_id = p_pack_quote_id)
  LOOP
    v_line_cd := x.line_cd;
    IF v_line_cd = giisp.v('LINE_CODE_MC')THEN
       with_mc := 'Y';
    ELSIF v_line_cd = giisp.v('LINE_CODE_AV') THEN
      with_av := 'Y';
   ELSIF v_line_cd = giisp.v('LINE_CODE_MH') THEN
      with_mh := 'Y';
   ELSIF v_line_cd = giisp.v('LINE_CODE_MN') THEN
      with_mn := 'Y';
   ELSIF v_line_cd = giisp.v('LINE_CODE_CA') THEN
      with_ca := 'Y';
   ELSIF v_line_cd = giisp.v('LINE_CODE_AC') THEN
      with_ac := 'Y';
   ELSIF v_line_cd = giisp.v('LINE_CODE_EN') THEN
      with_en := 'Y';
   ELSIF v_line_cd = giisp.v('LINE_CODE_FI') THEN
      with_fi := 'Y';
   END IF;
  END LOOP;



IF with_mc = 'Y' THEN
/* This will copy records from gipi_quote_item_mc
** to gipi_wvehicle during creation of PAR from a package
** quotation.
*/
  FOR parlist_rec IN mc
  LOOP
    FOR v IN (SELECT item_no,          plate_no,           motor_no,
                   serial_no,          subline_type_cd,     mot_type,
               coc_yy,                coc_seq_no,        coc_type,
               repair_lim,              color,          model_year,
               make,             est_value,        towing,
               assignee,           no_of_pass,        tariff_zone,
               coc_issue_date,         mv_file_no,        acquired_from,
               ctv_tag,               type_of_body_cd,      unladen_wt,
               make_cd,               series_cd,        basic_color_cd,
                color_cd,           origin,          destination,
               coc_atcn,           car_company_cd,     coc_serial_no,
               subline_cd
                FROM gipi_quote_item_mc
           WHERE quote_id = parlist_rec.quote_id)
    LOOP
    INSERT INTO GIPI_WVEHICLE (par_id,    item_no,      subline_cd,        motor_no,
                    plate_no,      serial_no,     subline_type_cd,    mot_type,
                    coc_yy,        coc_seq_no,     coc_type,        repair_lim,
                  color,        model_year,     make,         est_value,
                    towing,        assignee,      no_of_pass,      tariff_zone,
                  coc_issue_date, mv_file_no,    acquired_from,      ctv_tag,
                  type_of_body_cd,unladen_wt,    make_cd,        series_cd,
                  basic_color_cd, color_cd,      origin,        destination,
                  coc_atcn,      car_company_cd, coc_serial_no)
                        VALUES(parlist_rec.par_id,    v.item_no,    v.subline_cd,     NVL(v.motor_no,'0'),
                  v.plate_no,         v.serial_no,  v.subline_type_cd,  v.mot_type,
                     v.coc_yy,         v.coc_seq_no, v.coc_type,     v.repair_lim,
                  v.color,         v.model_year, v.make,       v.est_value,
                  v.towing,         v.assignee,   v.no_of_pass,       v.tariff_zone,
                  v.coc_issue_date,    v.mv_file_no, v.acquired_from,   v.ctv_tag,
                  v.type_of_body_cd,   v.unladen_wt, v.make_cd,      v.series_cd,
                  v.basic_color_cd,    v.color_cd,   v.origin,      v.destination,
                  v.coc_atcn,        v.car_company_cd, v.coc_serial_no);
    END LOOP;

  END LOOP;

END IF;  -- end of with_mc


IF with_av = 'Y' THEN
/* This will copy records from gipi_quote_av_item
** to gipi_waviation_item during creation of PAR from a package
** quotation.
*/
  FOR parlist_rec IN av
    LOOP
      FOR rec IN (SELECT item_no, vessel_cd, total_fly_time, qualification, purpose, geog_limit,
                         deduct_text, rec_flag, fixed_wing, rotor, prev_util_hrs, est_util_hrs
            FROM gipi_quote_av_item
            WHERE quote_id = parlist_rec.quote_id)
      LOOP
        INSERT INTO GIPI_WAVIATION_ITEM (par_id,item_no,vessel_cd, total_fly_time, qualification,
                                         purpose, geog_limit, deduct_text, rec_flag, fixed_wing,
                                         rotor, prev_util_hrs, est_util_hrs)
             VALUES(parlist_rec.par_id,rec.item_no,rec.vessel_cd, rec.total_fly_time, rec.qualification,
                    rec.purpose, rec.geog_limit, rec.deduct_text, rec.rec_flag, rec.fixed_wing, rec.rotor,
                    rec.prev_util_hrs, rec.est_util_hrs);
      END LOOP;

    END LOOP;
END IF; -- end of with_av



IF with_mh = 'Y' THEN

  FOR parlist_rec IN mh
    LOOP
      FOR rec IN (SELECT item_no, vessel_cd, geog_limit, rec_flag, deduct_text,
                         dry_date, dry_place
                    FROM gipi_quote_mh_item
                   WHERE quote_id = parlist_rec.quote_id)
      LOOP
       INSERT INTO gipi_witem_ves(par_id, item_no, vessel_cd, geog_limit, rec_flag, deduct_text,
                                  dry_date, dry_place)
            VALUES (parlist_rec.par_id, rec.item_no, rec.vessel_cd, rec.geog_limit, rec.rec_flag,
                    rec.deduct_text, rec.dry_date, rec.dry_place);
      END LOOP;

    END LOOP;
END IF; -- end of with_mh

IF with_mn = 'Y' THEN
/* This will copy recorsd from gipi_quote_cargo to gipi_wcargo.
** The column rec_flag in gipi_wcargo is hardcoded to 'A' since
** it cannot be null. In the marketing modules, the column rec_flag
** in gipi_quote_cargo is not populated.
*/
  FOR parlist_rec IN mn
    LOOP
    FOR rec IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                       voyage_no, bl_awb, origin, destn, etd, eta,
                       cargo_type, pack_method, tranship_origin,
                       tranship_destination, lc_no, print_tag
                  FROM gipi_quote_cargo
                 WHERE quote_id = parlist_rec.quote_id)
    LOOP
     INSERT INTO gipi_wcargo (par_id, item_no, vessel_cd, geog_cd, cargo_class_cd,
                              voyage_no, bl_awb, origin, destn, etd, eta,
                              cargo_type, pack_method, tranship_origin,
                              tranship_destination, lc_no, print_tag,rec_Flag)
          VALUES (parlist_rec.par_id, rec.item_no, rec.vessel_cd, rec.geog_cd, rec.cargo_class_cd,
                  rec.voyage_no, rec.bl_awb, rec.origin, rec.destn, rec.etd, rec.eta,
                  rec.cargo_type, rec.pack_method, rec.tranship_origin, rec.tranship_destination,
                  rec.lc_no, rec.print_tag,'A');
    END LOOP;

  END LOOP;
END IF; -- end of with_mn

IF with_ca = 'Y' THEN

  FOR parlist_rec IN ca
  LOOP
    FOR rec IN (SELECT item_no, capacity_cd, conveyance_info, interest_on_premises, limit_of_liability,
                       location, property_no, property_no_type, section_line_cd, section_or_hazard_cd,
                     section_or_hazard_info, section_subline_cd
                  FROM gipi_quote_ca_item
                 WHERE quote_id = parlist_rec.quote_id)
    LOOP
     INSERT INTO gipi_wcasualty_item (par_id, item_no, capacity_cd, conveyance_info, interest_on_premises,
                                      limit_of_liability, location, property_no, property_no_type,
                                      section_line_cd, section_or_hazard_cd, section_or_hazard_info,
                                      section_subline_cd)
          VALUES (parlist_rec.par_id, rec.item_no, rec.capacity_cd, rec.conveyance_info, rec.interest_on_premises,
                  rec.limit_of_liability, rec.location, rec.property_no, rec.property_no_type,
                  rec.section_line_cd, rec.section_or_hazard_cd, rec.section_or_hazard_info, rec.section_subline_cd);
    END LOOP;

  END LOOP;
END IF; -- end of with_ca

IF with_ac = 'Y' THEN
  FOR parlist_rec IN ac
  LOOP
    FOR rec IN (SELECT item_no, destination, monthly_salary, no_of_persons,
                       position_cd, salary_grade, age, civil_status, date_of_birth, height,
                       sex, weight
                  FROM gipi_quote_ac_item
                 WHERE quote_id = parlist_rec.quote_id)
    LOOP
     INSERT INTO gipi_waccident_item (par_id, item_no, destination, monthly_salary, no_of_persons,
                                      position_cd, salary_grade, age, civil_status, date_of_birth, height,
                                       sex, weight)
          VALUES (parlist_rec.par_id, rec.item_no, rec.destination, rec.monthly_salary,
                  rec.no_of_persons, rec.position_cd, rec.salary_grade, rec.age, rec.civil_status,
                  rec.date_of_birth, rec.height, rec.sex, rec.weight);
    END LOOP;

  END LOOP;
END IF; -- end of with_ac

IF with_en = 'Y' THEN

FOR parlist_rec IN en
  LOOP
    FOR rec IN (SELECT construct_end_date, construct_start_date, contract_proj_buss_title,
                       engg_basic_infonum, maintain_end_date, maintain_start_date, mbi_policy_no,
                       site_location, testing_end_date, testing_start_date, time_excess, weeks_test
                  FROM gipi_quote_en_item
                 WHERE quote_id = parlist_rec.quote_id)
    LOOP
     INSERT INTO gipi_wengg_basic (par_id, construct_end_date, construct_start_date,
                                   contract_proj_buss_title, engg_basic_infonum, maintain_end_date,
                                   maintain_start_date, mbi_policy_no, site_location, testing_end_date,
                                   testing_start_date, time_excess, weeks_test)
          VALUES (parlist_rec.par_id, rec.construct_end_date, rec.construct_start_date,
                  rec.contract_proj_buss_title, rec.engg_basic_infonum, rec.maintain_end_date,
                  rec.maintain_start_date, rec.mbi_policy_no, rec.site_location, rec.testing_end_date,
                  rec.testing_start_date, rec.time_excess, rec.weeks_test);
    END LOOP;

  END LOOP;
END IF; -- end of with_en

IF with_fi = 'Y' THEN
  FOR parlist_rec IN fi
  LOOP
    FOR rec IN (SELECT item_no, assignee, block_id, block_no, construction_cd,
                       construction_remarks, district_no, eq_zone, flood_zone,
                       fr_item_type, front, left, loc_risk1, loc_risk2, loc_risk3,
                       occupancy_cd, occupancy_remarks, rear, right, tarf_cd,
                       tariff_zone, typhoon_zone, risk_cd --added by annabelle 10.24.05
                  FROM gipi_quote_fi_item
                 WHERE quote_id = parlist_rec.quote_id)
    LOOP
     INSERT INTO gipi_wfireitm (par_id, item_no, assignee, block_id, block_no,
                                construction_cd, construction_remarks, district_no,
                                eq_zone, flood_zone, fr_item_type, front, left,
                                loc_risk1, loc_risk2, loc_risk3, occupancy_cd,
                                occupancy_remarks, rear, right, tarf_cd,
                                tariff_zone, typhoon_zone, risk_cd)
          VALUES (parlist_rec.par_id, rec.item_no, rec.assignee, rec.block_id, rec.block_no,
                  rec.construction_cd, rec.construction_remarks, rec.district_no,
                  rec.eq_zone, rec.flood_zone, rec.fr_item_type, rec.front, rec.left,
                  rec.loc_risk1, rec.loc_risk2, rec.loc_risk3, rec.occupancy_cd,
                  rec.occupancy_remarks, rec.rear, rec.right, rec.tarf_cd, rec.tariff_zone,
                rec.typhoon_zone, rec.risk_cd);

  FOR a IN (SELECT region_cd
                   FROM giis_block a, giis_province b
                  WHERE a.province_cd = b.province_cd
                    AND a.block_id = rec.block_id)
     LOOP
      UPDATE gipi_witem
         SET region_cd = a.region_cd
       WHERE par_id  = p_pack_par_id
         AND item_no = rec.item_no;
      EXIT;
        END LOOP;
    END LOOP;
  END LOOP;

END IF; -- end of with_fi


END;

PROCEDURE create_discounts (p_pack_par_id NUMBER)
/* This procedure will insert records into the discount tables
*/
IS

CURSOR par IS
  SELECT par_id, quote_id
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id;

BEGIN

FOR disc in par
LOOP
  FOR itm IN (SELECT surcharge_rt, surcharge_amt, subline_cd, sequence, remarks, orig_prem_amt,
                     net_prem_amt, net_gross_tag, line_cd, item_no, disc_rt, disc_amt
                FROM gipi_quote_item_discount
               WHERE quote_id = disc.quote_id)
  LOOP
   INSERT INTO gipi_witem_discount(par_id, line_cd, item_no, subline_cd, disc_rt, disc_amt,
                                   net_gross_tag, orig_prem_amt, sequence, remarks, net_prem_amt,
                                   surcharge_rt, surcharge_amt)
        VALUES (disc.par_id, itm.line_cd, itm.item_no, itm.subline_cd, itm.disc_rt, itm.disc_amt,
                itm.net_gross_tag, itm.orig_prem_amt, itm.sequence, itm.remarks, itm.net_prem_amt,
                itm.surcharge_rt, itm.surcharge_amt);
  END LOOP;

  FOR peril IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag, disc_amt,
               net_gross_tag, discount_tag, subline_cd, orig_peril_prem_amt,
               sequence, net_prem_amt, remarks, surcharge_rt, surcharge_amt
         FROM gipi_quote_peril_discount
         WHERE quote_id = disc.quote_id)
  LOOP
   INSERT INTO gipi_wperil_discount(par_id, item_no, line_cd, peril_cd, disc_rt, level_tag,
               disc_amt, net_gross_tag, discount_tag, subline_cd, orig_peril_prem_amt,
               sequence, net_prem_amt, remarks, surcharge_rt, surcharge_amt)
        VALUES (disc.par_id, peril.item_no, peril.line_cd, peril.peril_cd, peril.disc_rt, peril.level_tag,
               peril.disc_amt, peril.net_gross_tag, peril.discount_tag, peril.subline_cd,
               peril.orig_peril_prem_amt, peril.sequence, peril.net_prem_amt, peril.remarks,
               peril.surcharge_rt, peril.surcharge_amt);
  END LOOP;

  FOR pol IN (SELECT line_cd, subline_cd, disc_rt, disc_amt, net_gross_tag, orig_prem_amt,
                     sequence, net_prem_amt, remarks, surcharge_rt, surcharge_amt
                FROM gipi_quote_polbasic_discount
               WHERE quote_id = disc.quote_id)
  LOOP
   INSERT INTO gipi_wpolbas_discount(par_id, line_cd, subline_cd, disc_rt, disc_amt, net_gross_tag,
                                     orig_prem_amt, sequence, remarks, net_prem_amt, surcharge_rt,
                                     surcharge_amt)
        VALUES (disc.par_id, pol.line_cd, pol.subline_cd, pol.disc_rt, pol.disc_amt,
                pol.net_gross_tag, pol.orig_prem_amt, pol.sequence, pol.remarks, pol.net_prem_amt,
                pol.surcharge_rt, pol.surcharge_amt);
  END LOOP;

END LOOP;

END;

PROCEDURE create_peril_wc (p_pack_par_id NUMBER)
/* This procedure will insert records in
** gipi_witmperl and gipi_wpolwc.
*/
IS

v_item_no       gipi_witmperl.item_no%type;
v_line_cd       gipi_witmperl.line_cd%type;
v_peril_cd      gipi_witmperl.peril_cd%type;
v_prem_rt       gipi_witmperl.prem_rt%type;
v_tsi_amt       gipi_witmperl.tsi_amt%type;
v_prem_amt      gipi_witmperl.prem_amt%type;
v_ann_tsi_amt   gipi_witmperl.ann_tsi_amt%type;
v_ann_prem_amt  gipi_witmperl.ann_prem_amt%type;

CURSOR par IS
  SELECT par_id, quote_id, line_cd
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id;

BEGIN

FOR x IN par
LOOP

  FOR A IN (SELECT item_no,peril_cd,prem_rt,tsi_amt,prem_amt,ann_prem_amt, ann_tsi_amt
              FROM gipi_quote_itmperil
             WHERE quote_id = x.quote_id)
  LOOP
    v_item_no      := A.ITEM_NO;
    v_peril_cd     := A.PERIL_CD;
    v_prem_rt      := A.PREM_RT;
    v_tsi_amt      := A.TSI_AMT;
    v_prem_amt     := A.PREM_AMT;
 v_ann_tsi_amt  := A.ann_tsi_amt;
 v_ann_prem_amt := A.ann_prem_amt;

 INSERT INTO gipi_witmperl
           (par_id,item_no,line_cd,peril_cd,tarf_cd,prem_rt,
            tsi_amt,prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,
            comp_rem,discount_sw,ri_comm_rate,ri_comm_amt)
    VALUES (x.par_id,v_item_no,x.line_cd,v_peril_cd,NULL,v_prem_rt,
            v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,NULL,
            NULL,'N',NULL,0);
  END LOOP;

  FOR wc IN (SELECT change_tag, line_cd, print_seq_no, print_sw, wc_cd, wc_remarks,
                     wc_text01, wc_text02, wc_text03, wc_text04, wc_text05, wc_text06,
                     wc_text07, wc_text08, wc_text09, wc_text10, wc_text11, wc_text12,
                     wc_text13, wc_text14, wc_text15, wc_text16, wc_text17, wc_title
                FROM gipi_quote_wc
               WHERE quote_id = x.quote_id)
  LOOP
   INSERT INTO gipi_wpolwc ( par_id, change_tag, line_cd, print_seq_no, print_sw, wc_cd,
                             wc_remarks, wc_text01, wc_text02, wc_text03, wc_text04,
                             wc_text05, wc_text06, wc_text07, wc_text08, wc_text09,
                             wc_text10, wc_text11, wc_text12, wc_text13, wc_text14,
                             wc_text15, wc_text16, wc_text17, wc_title, swc_seq_no )
        VALUES ( x.par_id, wc.change_tag, wc.line_cd, wc.print_seq_no, wc.print_sw,
                 wc.wc_cd, wc.wc_remarks, wc.wc_text01, wc.wc_text02, wc.wc_text03,
                 wc.wc_text04, wc.wc_text05, wc.wc_text06, wc.wc_text07, wc.wc_text08,
                 wc.wc_text09, wc.wc_text10, wc.wc_text11, wc.wc_text12, wc.wc_text13,
                 wc.wc_text14, wc.wc_text15, wc.wc_text16, wc.wc_text17, wc.wc_title,0 );
  END LOOP;
END LOOP;
END;


PROCEDURE create_dist_ded (p_pack_par_id NUMBER)
/* This procedure will create distribution and deductible records
*/
IS

p_dist_no        giuw_pol_dist.dist_no%TYPE;
v_tsi_amt        gipi_polbasic.ann_tsi_amt%TYPE;
v_ann_tsi_amt    gipi_polbasic.ann_tsi_amt%TYPE;
v_prem_amt       gipi_polbasic.ann_prem_amt%TYPE;
p_eff_date       gipi_wpolbas.incept_date%TYPE;
p_expiry_date    gipi_wpolbas.expiry_date%TYPE;

CURSOR par IS
  SELECT par_id, quote_id, line_cd
    FROM gipi_parlist
   WHERE pack_par_id = p_pack_par_id;

BEGIN

FOR dist_ded IN par
LOOP
  SELECT POL_DIST_DIST_NO_S.NEXTVAL
    INTO p_dist_no
    FROM DUAL;

  FOR a IN ( SELECT sum(tsi_amt     * currency_rt) tsi,
                  sum(ann_tsi_amt * currency_rt) ann_tsi,
                  sum(prem_amt    * currency_rt) prem
               FROM gipi_witem
              WHERE par_id = dist_ded.par_id)
  LOOP
   v_tsi_amt     := a.tsi;
    v_ann_tsi_amt := a.ann_tsi;
    v_prem_amt    := a.prem;
  END LOOP;

  FOR b IN ( SELECT incept_date, expiry_date
               FROM gipi_quote
              WHERE quote_id = dist_ded.quote_id)
  LOOP
   p_eff_date     := b.incept_date;
    p_expiry_date  := b.expiry_date;
  END LOOP;

  INSERT INTO giuw_pol_dist(dist_no, par_id, tsi_amt,
              prem_amt, ann_tsi_amt, dist_flag, redist_flag,
              eff_date, expiry_date, create_date, user_id,
              last_upd_date, post_flag, auto_dist)
       VALUES (p_dist_no, dist_ded.par_id, NVL(v_tsi_amt,0),
               NVL(v_prem_amt,0), NVL(v_ann_tsi_amt,0), 1, 1,
               p_eff_date, p_expiry_date, SYSDATE, USER,
               SYSDATE, 'O', 'N');

  FOR rec IN (SELECT ded_deductible_cd, deductible_amt, deductible_rt, deductible_text,
                     item_no, peril_cd
                FROM gipi_quote_deductibles
               WHERE quote_id = dist_ded.quote_id)
  LOOP
   FOR a IN (SELECT line_cd, subline_cd
               FROM gipi_quote
              WHERE quote_id = dist_ded.quote_id)
   LOOP
    INSERT INTO gipi_wdeductibles (par_id, ded_line_cd, ded_subline_cd, ded_deductible_cd, deductible_amt, deductible_rt,
                                  deductible_text, item_no, peril_cd)
         VALUES (dist_ded.par_id, a.line_cd, a.subline_cd, rec.ded_deductible_cd, rec.deductible_amt, rec.deductible_rt,
                rec.deductible_text, rec.item_no, 0);
     EXIT;
   END LOOP;
  END LOOP;
  END LOOP;


END;

PROCEDURE return_to_quote (p_pack_quote_id NUMBER, p_pack_par_id NUMBER)
/* This procedure will return the package PAR to a quotation
** by updating its status from 'W' to 'N'
*/
IS

CURSOR cur_b IS SELECT quotation_no,quotation_yy,subline_cd,iss_cd,line_cd
                  FROM gipi_pack_quote
                 WHERE pack_quote_id = p_pack_quote_id;

BEGIN

  FOR x IN cur_b
  LOOP

    UPDATE gipi_pack_parlist
    SET par_status = 99
  WHERE quote_id = p_pack_quote_id;

 UPDATE gipi_parlist
    SET par_status = 99
  WHERE pack_par_id = p_pack_par_id;

 UPDATE gipi_pack_quote
      SET status = 'N'
    WHERE line_cd = x.line_cd
      AND iss_cd = x.iss_cd
      AND quotation_yy = x.quotation_yy
      AND quotation_no = x.quotation_no
      AND subline_cd = x.subline_cd;

   UPDATE gipi_quote
      SET status = 'N'
    WHERE pack_quote_id = p_pack_quote_id;
  END LOOP;
  COMMIT;
END;

------anthony santos 10,17,07---------------
PROCEDURE create_wmortgagee (p_pack_quote_id NUMBER, p_pack_par_id NUMBER)

IS

CURSOR cur_c IS SELECT c.par_id, b.quote_id, a.iss_cd,a.item_no,a.mortg_cd,a.amount,a.remarks,a.last_update,a.user_id, pack_quote_id
                 FROM gipi_quote_mortgagee a, gipi_quote b, gipi_parlist c
                 WHERE b.pack_quote_id = p_pack_quote_id and B.quote_id = A.quote_id and c.pack_par_id = p_pack_par_id and c.quote_id = b.quote_id;

BEGIN

  FOR x IN cur_c
  LOOP
    INSERT INTO gipi_wmortgagee(par_id,iss_cd,item_no,mortg_cd,amount,remarks,last_update,user_id)
    VALUES(x.par_id,x.iss_cd, x.item_no, x.mortg_cd, x.amount, x.remarks, x.last_update, x.user_id);
  END LOOP;

  COMMIT;
END; ------END anthony santos 10,17,07---------------
END;
/


