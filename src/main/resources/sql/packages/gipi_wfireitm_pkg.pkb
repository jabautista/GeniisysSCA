CREATE OR REPLACE PACKAGE BODY CPI.gipi_wfireitm_pkg
AS
   /*
     **  Created by    : Mark JM
      **  Date Created     : 03.02.2010
      **  Reference By     : (GIPIS003 - Item Information - Fire)
      **  Description     : Returns PAR record listing for FIRE
      */
   FUNCTION get_gipi_wfireitems (p_par_id gipi_wfireitm.par_id%TYPE)
      RETURN gipi_wfireitm_tab PIPELINED
   IS
      v_gipi_wfireitm   gipi_wfireitm_type;
   BEGIN
      FOR i IN (SELECT   a.par_id, a.item_no, a.item_title, a.item_grp,
                         a.item_desc, a.item_desc2, a.tsi_amt, a.prem_amt,
                         a.ann_prem_amt, a.ann_tsi_amt, a.rec_flag,
                         a.currency_cd, a.currency_rt, a.group_cd,
                         a.from_date, a.TO_DATE, a.pack_line_cd,
                         a.pack_subline_cd, a.discount_sw, a.coverage_cd,
                         a.other_info, a.surcharge_sw, a.region_cd,
                         a.changed_tag, a.prorate_flag, a.comp_sw,
                         a.short_rt_percent, a.pack_ben_cd, a.payt_terms,
                         a.risk_no, a.risk_item_no, e.currency_desc,
                         f.coverage_desc, b.district_no, b.eq_zone,
                         b.tarf_cd, b.block_no, b.fr_item_type, b.loc_risk1,
                         b.loc_risk2, b.loc_risk3, b.tariff_zone,
                         b.typhoon_zone, b.construction_cd,
                         b.construction_remarks, b.front, b.RIGHT, b.LEFT,
                         b.rear, b.occupancy_cd, b.occupancy_remarks,
                         b.assignee, b.flood_zone, b.block_id, b.risk_cd,
                         c.city, d.province_cd, d.province_desc
                    FROM gipi_witem a,
                         gipi_wfireitm b,
                         giis_block c,
                         giis_province d,
                         giis_currency e,
                         giis_coverage f
                   WHERE a.par_id = b.par_id(+)
                     AND a.item_no = b.item_no(+)
                     AND b.block_id = c.block_id(+)
                     AND c.province_cd = d.province_cd(+)
                     AND a.currency_cd = e.main_currency_cd(+)
                     AND a.coverage_cd = f.coverage_cd(+)
                     AND a.par_id = p_par_id
                ORDER BY a.par_id, a.item_no)
      LOOP
         v_gipi_wfireitm.par_id := i.par_id;
         v_gipi_wfireitm.item_no := i.item_no;
         v_gipi_wfireitm.item_title := i.item_title;
         v_gipi_wfireitm.item_grp := i.item_grp;
         v_gipi_wfireitm.item_desc := i.item_desc;
         v_gipi_wfireitm.item_desc2 := i.item_desc2;
         v_gipi_wfireitm.tsi_amt := i.tsi_amt;
         v_gipi_wfireitm.prem_amt := i.prem_amt;
         v_gipi_wfireitm.ann_prem_amt := i.ann_prem_amt;
         v_gipi_wfireitm.ann_tsi_amt := i.ann_tsi_amt;
         v_gipi_wfireitm.rec_flag := i.rec_flag;
         v_gipi_wfireitm.currency_cd := i.currency_cd;
         v_gipi_wfireitm.currency_rt := i.currency_rt;
         v_gipi_wfireitm.group_cd := i.group_cd;
         v_gipi_wfireitm.from_date := i.from_date;
         v_gipi_wfireitm.TO_DATE := i.TO_DATE;
         v_gipi_wfireitm.pack_line_cd := i.pack_line_cd;
         v_gipi_wfireitm.pack_subline_cd := i.pack_subline_cd;
         v_gipi_wfireitm.discount_sw := i.discount_sw;
         v_gipi_wfireitm.coverage_cd := i.coverage_cd;
         v_gipi_wfireitm.other_info := i.other_info;
         v_gipi_wfireitm.surcharge_sw := i.surcharge_sw;
         v_gipi_wfireitm.region_cd := i.region_cd;
         v_gipi_wfireitm.changed_tag := i.changed_tag;
         v_gipi_wfireitm.prorate_flag := i.prorate_flag;
         v_gipi_wfireitm.comp_sw := i.comp_sw;
         v_gipi_wfireitm.short_rt_percent := i.short_rt_percent;
         v_gipi_wfireitm.pack_ben_cd := i.pack_ben_cd;
         v_gipi_wfireitm.payt_terms := i.payt_terms;
         v_gipi_wfireitm.risk_no := i.risk_no;
         v_gipi_wfireitm.risk_item_no := i.risk_item_no;
         v_gipi_wfireitm.currency_desc := i.currency_desc;
         v_gipi_wfireitm.coverage_desc := i.coverage_desc;
         v_gipi_wfireitm.district_no := i.district_no;
         v_gipi_wfireitm.eq_zone := i.eq_zone;
         v_gipi_wfireitm.tarf_cd := i.tarf_cd;
         v_gipi_wfireitm.block_no := i.block_no;
         v_gipi_wfireitm.fr_item_type := i.fr_item_type;
         v_gipi_wfireitm.loc_risk1 := i.loc_risk1;
         v_gipi_wfireitm.loc_risk2 := i.loc_risk2;
         v_gipi_wfireitm.loc_risk3 := i.loc_risk3;
         v_gipi_wfireitm.tariff_zone := i.tariff_zone;
         v_gipi_wfireitm.typhoon_zone := i.typhoon_zone;
         v_gipi_wfireitm.construction_cd := i.construction_cd;
         v_gipi_wfireitm.construction_remarks := i.construction_remarks;
         v_gipi_wfireitm.front := i.front;
         v_gipi_wfireitm.RIGHT := i.RIGHT;
         v_gipi_wfireitm.LEFT := i.LEFT;
         v_gipi_wfireitm.rear := i.rear;
         v_gipi_wfireitm.occupancy_cd := i.occupancy_cd;
         v_gipi_wfireitm.occupancy_remarks := i.occupancy_remarks;
         v_gipi_wfireitm.assignee := i.assignee;
         v_gipi_wfireitm.flood_zone := i.flood_zone;
         v_gipi_wfireitm.block_id := i.block_id;
         v_gipi_wfireitm.risk_cd := i.risk_cd;
         v_gipi_wfireitm.city := i.city;
         v_gipi_wfireitm.province_cd := i.province_cd;
         v_gipi_wfireitm.province_desc := i.province_desc;
         v_gipi_wfireitm.itmperl_grouped_exists :=
            gipi_witmperl_grouped_pkg.gipi_witmperl_grouped_exist (p_par_id,
                                                                   i.item_no
                                                                  );
         PIPE ROW (v_gipi_wfireitm);
      END LOOP;

      RETURN;
   END get_gipi_wfireitems;

   /*
   **  Created by        : Mark JM
   **  Date Created    : 01.28.2011
   **  Reference By    : (GIPIS003 - Item Information - Fire)
   **  Description        : Retrieves record on GIPI_WFIREITM based on the given par_id and 

item_no
   */
   FUNCTION get_gipi_wfireitems1 (
      p_par_id    IN   gipi_wfireitm.par_id%TYPE,
      p_item_no   IN   gipi_wfireitm.item_no%TYPE
   )
      RETURN gipi_wfireitm_par_tab PIPELINED
   IS
      v_gipi_wfireitm   gipi_wfireitm_par_type;
   BEGIN
      FOR i IN (SELECT   a.par_id, a.item_no, a.district_no, a.eq_zone,
                         a.tarf_cd, a.block_no, a.fr_item_type, a.loc_risk1,
                         a.loc_risk2, a.loc_risk3, a.tariff_zone,
                         a.typhoon_zone, a.construction_cd,
                         a.construction_remarks, a.front, a.RIGHT, a.LEFT,
                         a.rear, a.occupancy_cd, a.occupancy_remarks,
                         a.assignee, a.flood_zone, a.block_id, a.risk_cd,
                         b.city_cd, c.province_cd, c.province_desc, b.city,
                         b.district_desc, d.occupancy_desc,
                         giis_risks_pkg.get_risk_desc (a.block_id,
                                                       a.risk_cd
                                                      ) risk_desc,
                         a.latitude, a.longitude
                    FROM gipi_wfireitm a,
                         giis_block b,
                         giis_province c,
                         giis_fire_occupancy d
                   WHERE a.par_id = p_par_id
                     AND a.item_no = p_item_no
                     AND a.block_id = b.block_id(+)
                     AND b.province_cd = c.province_cd(+)
                     AND a.occupancy_cd = d.occupancy_cd(+)
                ORDER BY a.par_id, a.item_no)
      LOOP
         v_gipi_wfireitm.par_id := i.par_id;
         v_gipi_wfireitm.item_no := i.item_no;
         v_gipi_wfireitm.district_no := i.district_no;
         v_gipi_wfireitm.eq_zone := i.eq_zone;
         v_gipi_wfireitm.eq_desc :=
                                  giis_eqzone_pkg.get_eqzone_desc (i.eq_zone);
         v_gipi_wfireitm.tarf_cd := i.tarf_cd;
         v_gipi_wfireitm.block_no := i.block_no;
         v_gipi_wfireitm.fr_item_type := i.fr_item_type;
         v_gipi_wfireitm.loc_risk1 := i.loc_risk1;
         v_gipi_wfireitm.loc_risk2 := i.loc_risk2;
         v_gipi_wfireitm.loc_risk3 := i.loc_risk3;
         v_gipi_wfireitm.tariff_zone := i.tariff_zone;
         v_gipi_wfireitm.typhoon_zone := i.typhoon_zone;
         v_gipi_wfireitm.typhoon_zone_desc :=
                 giis_typhoon_zone_pkg.get_typhoon_zone_desc (i.typhoon_zone);
         v_gipi_wfireitm.construction_cd := i.construction_cd;
         v_gipi_wfireitm.construction_remarks := i.construction_remarks;
         v_gipi_wfireitm.front := i.front;
         v_gipi_wfireitm.RIGHT := i.RIGHT;
         v_gipi_wfireitm.LEFT := i.LEFT;
         v_gipi_wfireitm.rear := i.rear;
         v_gipi_wfireitm.occupancy_cd := i.occupancy_cd;
         v_gipi_wfireitm.occupancy_desc := i.occupancy_desc;
         v_gipi_wfireitm.occupancy_remarks := i.occupancy_remarks;
         v_gipi_wfireitm.assignee := i.assignee;
         v_gipi_wfireitm.flood_zone := i.flood_zone;
         v_gipi_wfireitm.flood_zone_desc :=
                       giis_flood_zone_pkg.get_flood_zone_desc (i.flood_zone);
         v_gipi_wfireitm.block_id := i.block_id;
         v_gipi_wfireitm.risk_cd := i.risk_cd;
         v_gipi_wfireitm.city_cd := i.city_cd;
         v_gipi_wfireitm.province_cd := i.province_cd;
         v_gipi_wfireitm.province_desc := i.province_desc;
         v_gipi_wfireitm.city := i.city;
         v_gipi_wfireitm.district_desc := i.district_desc;
         v_gipi_wfireitm.risk_desc := i.risk_desc;
         v_gipi_wfireitm.latitude := i.latitude;
         v_gipi_wfireitm.longitude := i.longitude;
         PIPE ROW (v_gipi_wfireitm);
      END LOOP;
   END get_gipi_wfireitems1;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 03.03.2010
   **  Reference By     : (GIPIS003 - Item Information - Fire)
   **  Description     : Insert / Update records on GIPI_WFIREITM
   */
   PROCEDURE set_gipi_wfireitm (
      p_par_id                 gipi_wfireitm.par_id%TYPE,
      p_item_no                gipi_wfireitm.item_no%TYPE,
      p_district_no            gipi_wfireitm.district_no%TYPE,
      p_eq_zone                gipi_wfireitm.eq_zone%TYPE,
      p_tarf_cd                gipi_wfireitm.tarf_cd%TYPE,
      p_block_no               gipi_wfireitm.block_no%TYPE,
      p_fr_item_type           gipi_wfireitm.fr_item_type%TYPE,
      p_loc_risk1              gipi_wfireitm.loc_risk1%TYPE,
      p_loc_risk2              gipi_wfireitm.loc_risk2%TYPE,
      p_loc_risk3              gipi_wfireitm.loc_risk3%TYPE,
      p_tariff_zone            gipi_wfireitm.tariff_zone%TYPE,
      p_typhoon_zone           gipi_wfireitm.typhoon_zone%TYPE,
      p_construction_cd        gipi_wfireitm.construction_cd%TYPE,
      p_construction_remarks   gipi_wfireitm.construction_remarks%TYPE,
      p_front                  gipi_wfireitm.front%TYPE,
      p_right                  gipi_wfireitm.RIGHT%TYPE,
      p_left                   gipi_wfireitm.LEFT%TYPE,
      p_rear                   gipi_wfireitm.rear%TYPE,
      p_occupancy_cd           gipi_wfireitm.occupancy_cd%TYPE,
      p_occupancy_remarks      gipi_wfireitm.occupancy_remarks%TYPE,
      p_assignee               gipi_wfireitm.assignee%TYPE,
      p_flood_zone             gipi_wfireitm.flood_zone%TYPE,
      p_block_id               gipi_wfireitm.block_id%TYPE,
      p_risk_cd                gipi_wfireitm.risk_cd%TYPE,
      p_latitude               gipi_wfireitm.latitude%TYPE, --Added by Jerome 11.10.2016 SR 5749
      p_longitude              gipi_wfireitm.longitude%TYPE --Added by Jerome 11.10.2016 SR 5749
   )
   IS
   BEGIN
      MERGE INTO gipi_wfireitm
         USING DUAL
         ON (par_id = p_par_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, district_no, eq_zone, tarf_cd, block_no,
                    fr_item_type, loc_risk1, loc_risk2, loc_risk3,
                    tariff_zone, typhoon_zone, construction_cd,
                    construction_remarks, front, RIGHT, LEFT, rear,
                    occupancy_cd, occupancy_remarks, assignee, flood_zone,
                    block_id, risk_cd, latitude, longitude)
            VALUES (p_par_id, p_item_no, p_district_no, p_eq_zone, p_tarf_cd,
                    p_block_no, p_fr_item_type, p_loc_risk1, p_loc_risk2,
                    p_loc_risk3, p_tariff_zone, p_typhoon_zone,
                    p_construction_cd, p_construction_remarks, p_front,
                    p_right, p_left, p_rear, p_occupancy_cd,
                    p_occupancy_remarks, p_assignee, p_flood_zone,
                    p_block_id, p_risk_cd, p_latitude, p_longitude)
         WHEN MATCHED THEN
            UPDATE
               SET district_no = p_district_no, eq_zone = p_eq_zone,
                   tarf_cd = p_tarf_cd, block_no = p_block_no,
                   fr_item_type = p_fr_item_type, loc_risk1 = p_loc_risk1,
                   loc_risk2 = p_loc_risk2, loc_risk3 = p_loc_risk3,
                   tariff_zone = p_tariff_zone,
                   typhoon_zone = p_typhoon_zone,
                   construction_cd = p_construction_cd,
                   construction_remarks = p_construction_remarks,
                   front = p_front, RIGHT = p_right, LEFT = p_left,
                   rear = p_rear, occupancy_cd = p_occupancy_cd,
                   occupancy_remarks = p_occupancy_remarks,
                   assignee = p_assignee, flood_zone = p_flood_zone,
                   block_id = p_block_id, risk_cd = p_risk_cd,
                   latitude = p_latitude, longitude = p_longitude
            ;
   END set_gipi_wfireitm;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 03.03.2010
   **  Reference By     : (GIPIS003 - Item Information - Fire)
   **  Description     : Delete record/s on GIPI_WFIREITM
   */
   PROCEDURE del_gipi_wfireitm (
      p_par_id    gipi_wfireitm.par_id%TYPE,
      p_item_no   gipi_wfireitm.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_wfireitm
            WHERE par_id = p_par_id AND item_no = p_item_no;
   END del_gipi_wfireitm;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.01.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure deletes record based on the given par_id
   */
   PROCEDURE del_gipi_wfireitm (p_par_id IN gipi_wfireitm.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_wfireitm
            WHERE par_id = p_par_id;
   END del_gipi_wfireitm;

   PROCEDURE get_gipis039_basic_var_values (
      p_par_id                   IN       gipi_wfireitm.par_id%TYPE,
      p_par_type                 IN       VARCHAR2,
      p_assd_no                  IN       giis_assured.assd_no%TYPE,
      p_gipi_par_iss_cd          IN       giis_parameters.param_name%TYPE,
      p_line_cd                  IN       gipi_wpolbas.line_cd%TYPE,
      p_subline_cd               IN       gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd                   IN       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy                 IN       gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no               IN       gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no                 IN       gipi_wpolbas.renew_no%TYPE,
      p_eff_date                 IN       gipi_wpolbas.eff_date%TYPE,
      p_expiry_date              IN       gipi_wpolbas.expiry_date%TYPE,
      p_iss_cd_ri                OUT      VARCHAR2,
      p_param_by_iss_cd          OUT      VARCHAR2,
      p_deductible_exist         OUT      VARCHAR2,
      p_display_risk             OUT      VARCHAR2,
      p_allow_update_curr_rate   OUT      VARCHAR2,
      p_buildings                OUT      VARCHAR2,
      p_new_endt_address_1       OUT      gipi_polbasic.address1%TYPE,
      p_new_endt_address_2       OUT      gipi_polbasic.address2%TYPE,
      p_new_endt_address_3       OUT      gipi_polbasic.address3%TYPE,
      p_mail_address_1           OUT      giis_assured.mail_addr1%TYPE,
      p_mail_address_2           OUT      giis_assured.mail_addr2%TYPE,
      p_mail_address_3           OUT      giis_assured.mail_addr3%TYPE,
      p_wfireitm_list            OUT      gipi_wfireitm_pkg.gipi_wfireitm_cur
   )
   IS
   BEGIN
      OPEN p_wfireitm_list FOR
         SELECT par_id, item_no, item_title, item_grp, item_desc, item_desc2,
                tsi_amt, prem_amt, ann_prem_amt, ann_tsi_amt, rec_flag,
                currency_cd, currency_rt, group_cd, from_date, TO_DATE,
                pack_line_cd, pack_subline_cd, discount_sw, coverage_cd,
                other_info, surcharge_sw, region_cd, changed_tag,
                prorate_flag, comp_sw, short_rt_percent, pack_ben_cd,
                payt_terms, risk_no, risk_item_no, currency_desc,
                coverage_desc, district_no, eq_zone, tarf_cd, block_no,
                fr_item_type, loc_risk1, loc_risk2, loc_risk3, tariff_zone,
                typhoon_zone, construction_cd, construction_remarks, front,
                RIGHT, LEFT, rear, occupancy_cd, occupancy_remarks, assignee,
                flood_zone, block_id, risk_cd, city, province_cd,
                province_desc, itmperl_grouped_exists, latitude, longitude
           FROM TABLE (gipi_wfireitm_pkg.get_gipi_wfireitems (p_par_id));

      BEGIN
         SELECT mail_addr1, mail_addr2, mail_addr3
           INTO p_mail_address_1, p_mail_address_2, p_mail_address_3
           FROM giis_assured
          WHERE assd_no = p_assd_no;
      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            NULL;
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT giis_parameters_pkg.v ('ISS_CD_RI') param_value_v
           INTO p_iss_cd_ri
           FROM DUAL;
      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            NULL;
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT giis_parameters_pkg.get_param_by_iss_cd (p_gipi_par_iss_cd)
                                                                param_value_v
           INTO p_param_by_iss_cd
           FROM DUAL;
      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            NULL;
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT NVL
                   (gipi_wdeductibles_pkg.check_gipi_wdeductibles_items
                                                                 (p_par_id,
                                                                  p_line_cd,
                                                                  p_subline_cd
                                                                 ),
                    'N'
                   )
           INTO p_deductible_exist
           FROM DUAL;
      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            NULL;
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF p_par_type = 'E'
      THEN
         BEGIN
            SELECT giis_parameters_pkg.v ('DISPLAY_RISK') param_value_v
              INTO p_display_risk
              FROM DUAL;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               NULL;
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT giis_parameters_pkg.v ('BUILDINGS') param_value_v
              INTO p_buildings
              FROM DUAL;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               NULL;
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT giis_parameters_pkg.v ('ALLOW_UPDATE_CURR_RATE')
                                                                param_value_v
              INTO p_allow_update_curr_rate
              FROM DUAL;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               NULL;
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         gipi_polbasic_pkg.get_address_for_new_endt_item
                                                        (p_line_cd,
                                                         p_subline_cd,
                                                         p_iss_cd,
                                                         p_issue_yy,
                                                         p_pol_seq_no,
                                                         p_renew_no,
                                                         p_eff_date,
                                                         p_expiry_date,
                                                         p_new_endt_address_1,
                                                         p_new_endt_address_2,
                                                         p_new_endt_address_3
                                                        );
      END IF;
   END get_gipis039_basic_var_values;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 03.21.2011
   **  Reference By     : (GIPIS095 - Package Policy Items)
   **  Description     : Retrieve rows from gipi_wfireitm based on the given parameters
   */
   FUNCTION get_gipi_wfireitm_pack_pol (
      p_par_id    IN   gipi_wfireitm.par_id%TYPE,
      p_item_no   IN   gipi_wfireitm.item_no%TYPE
   )
      RETURN gipi_wfireitm_par_tab PIPELINED
   IS
      v_gipi_wfireitm   gipi_wfireitm_par_type;
   BEGIN
      FOR i IN (SELECT par_id, item_no
                  FROM gipi_wfireitm
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_gipi_wfireitm.par_id := i.par_id;
         v_gipi_wfireitm.item_no := i.item_no;
         PIPE ROW (v_gipi_wfireitm);
      END LOOP;

      RETURN;
   END get_gipi_wfireitm_pack_pol;
   
 FUNCTION get_tarf_cd_pre_commit (
      p_occupancy_cd   gipi_wfireitm.occupancy_cd%TYPE,
      p_tariff_zone    gipi_wfireitm.tariff_zone%TYPE,
      p_tarf_cd        gipi_wfireitm.tarf_cd%TYPE
   )
      RETURN gipi_wfireitm.tarf_cd%TYPE
   IS
      v_tarf_cd   gipi_wfireitm.tarf_cd%TYPE;
      /*Modified by pjsantos 10/05/2016, GENQA 5699,moved return then added begin and end to query*/
   BEGIN
    BEGIN 
      SELECT tarf_cd
        INTO v_tarf_cd
        FROM giis_tariff
WHERE occupancy_cd = p_occupancy_cd AND tariff_zone = p_tariff_zone AND p_tarf_cd = tarf_cd;
     EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_tarf_cd := p_tarf_cd;
    END;
         RETURN v_tarf_cd;
   END;
   
 PROCEDURE validate_tariff_cd (
      p_occupancy_cd              gipi_wfireitm.occupancy_cd%TYPE,
      p_tariff_zone               gipi_wfireitm.tariff_zone%TYPE,
      p_tarf_cd          IN OUT   gipi_wfireitm.tarf_cd%TYPE,
      p_message          OUT      VARCHAR2
   )
   IS
      v_tarf_cd   giis_tariff.tarf_cd%TYPE;
      v_exist     VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 'EXISTS'
                  FROM giis_tariff
                 WHERE occupancy_cd = p_occupancy_cd
                   AND tariff_zone = p_tariff_zone)
      LOOP
         v_exist := 'Y';
      END LOOP;

      IF v_exist = 'Y'
      THEN
         SELECT tarf_cd
           INTO v_tarf_cd
           FROM giis_tariff
          WHERE occupancy_cd = p_occupancy_cd AND tariff_zone = p_tariff_zone;

         IF v_tarf_cd IS NOT NULL
         THEN
            IF v_tarf_cd != p_tarf_cd
            THEN
               p_message :='not ok';
               p_tarf_cd := v_tarf_cd;
            END IF;
         END IF;
      ELSE
         p_message := '';
      END IF;
   END;

 FUNCTION get_tariff_zone_occupancy_val (p_tarf_cd  gipi_wfireitm.tarf_cd%TYPE)
      RETURN gipi_wfireitm_value_tab PIPELINED
   IS
      v_gipi_wfireitm   gipi_wfireitm_value;
    BEGIN
      FOR i IN (SELECT o.occupancy_cd, o.occupancy_desc, z.tariff_zone, z.tariff_zone_desc
                  FROM giis_tariff t, giis_fire_occupancy o, giis_tariff_zone z
                 WHERE t.tarf_cd = p_tarf_cd
                 AND t.occupancy_cd = o.occupancy_cd
                 AND t.tariff_zone = z.tariff_zone)
      LOOP
         v_gipi_wfireitm.occupancy_cd := i.occupancy_cd;
         v_gipi_wfireitm.occupancy_desc := i.occupancy_desc;
         v_gipi_wfireitm.tariff_zone := i.tariff_zone;
         v_gipi_wfireitm.tariff_zone_desc := i.tariff_zone_desc;
         PIPE ROW (v_gipi_wfireitm);
      END LOOP;
      RETURN;
  END get_tariff_zone_occupancy_val;

END gipi_wfireitm_pkg;
/


