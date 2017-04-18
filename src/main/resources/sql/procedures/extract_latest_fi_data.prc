DROP PROCEDURE CPI.EXTRACT_LATEST_FI_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Fi_Data (p_expiry_date      gicl_claims.expiry_date%TYPE,
                             p_incept_date      gicl_claims.expiry_date%TYPE,
                             p_loss_date        gicl_claims.loss_date%TYPE,
                             p_clm_endt_seq_no  gicl_claims.max_endt_seq_no%TYPE,
                             p_line_cd          gicl_claims.line_cd%TYPE,
                             p_subline_cd       gicl_claims.subline_cd%TYPE,
                             p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
                             p_issue_yy         gicl_claims.issue_yy%TYPE,
                             p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                             p_renew_no     gicl_claims.renew_no%TYPE,
                             p_claim_id         gicl_claims.claim_id%TYPE,
                             p_item_no          gicl_clm_item.item_no%TYPE)

/** Created by : Hardy Teng
    Date Created : 09/22/06
**/

IS
  v_assignee            gipi_fireitem.assignee%TYPE;
  v_currency_cd       gipi_item.currency_cd%TYPE;
  v_currency_desc      giis_currency.currency_desc%TYPE;
  v_currency_rt       gipi_item.currency_rt%TYPE;
  v_fr_item_type       gipi_fireitem.fr_item_type%TYPE;
  v_item_title               gipi_item.item_title%TYPE;
  v_district_no       gipi_fireitem.district_no%TYPE;
  v_block_no             gipi_fireitem.block_no%TYPE;
  v_block_id           gipi_fireitem.block_id%TYPE;
  v_eq_zone            gipi_fireitem.eq_zone%TYPE;
  v_typhoon_zone        gipi_fireitem.typhoon_zone%TYPE;
  v_flood_zone        gipi_fireitem.flood_zone%TYPE;
  v_tariff_zone       gipi_fireitem.tariff_zone%TYPE;
  v_tarf_cd          gipi_fireitem.tarf_cd%TYPE;
  v_risk_cd             gipi_fireitem.risk_cd%TYPE; -- jess 06232010
  v_loc_risk1            gipi_fireitem.loc_risk1%TYPE;
  v_loc_risk2            gipi_fireitem.loc_risk2%TYPE;
  v_loc_risk3           gipi_fireitem.loc_risk3%TYPE;
  v_front           gipi_fireitem.front%TYPE;
  v_rear           gipi_fireitem.rear%TYPE;
  v_left            gipi_fireitem.left%TYPE;
  v_right           gipi_fireitem.right%TYPE;
  v_occupancy_cd         gipi_fireitem.occupancy_cd%TYPE;
  v_occupancy_remarks      gipi_fireitem.occupancy_remarks%TYPE;
  v_construction_cd       gipi_fireitem.construction_cd%TYPE;
  v_construction_remarks  gipi_fireitem.construction_remarks%TYPE;
  v_max_endt_seq_no       gipi_polbasic.endt_seq_no%TYPE;
BEGIN
  FOR c1 IN (SELECT endt_seq_no, d.assignee, c.currency_cd, e.currency_desc, d.fr_item_type,d.district_no,d.block_no, d.block_id, d.eq_zone, d.typhoon_zone, d.flood_zone,d.tariff_zone, d.tarf_cd, d.risk_cd, d.loc_risk1, d.loc_risk2,                                 d.loc_risk3, d.front,d.rear, d.left, d.right, d.occupancy_cd,                                    d.occupancy_remarks, d.construction_cd,d.construction_remarks,                                   c.currency_rt, c.item_title
               FROM gipi_polbasic b, gipi_item c, gipi_fireitem d, giis_currency e
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.policy_id = c.policy_id
                AND b.endt_seq_no > p_clm_endt_seq_no
                AND c.currency_cd = e.main_currency_cd
                AND c.policy_id = d.policy_id
                AND c.item_no = d.item_no
                AND b.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(NVL(c.from_date,b.eff_date)),
                    TRUNC(b.incept_date), NVL(c.from_date, p_incept_date),
                    NVL(c.from_date,b.eff_date))) <= p_loss_date
                AND TRUNC(DECODE(NVL(c.TO_DATE,NVL(b.endt_expiry_date, b.expiry_date)),
                    b.expiry_date,NVL(c.TO_DATE,p_expiry_date),
                    NVL(c.TO_DATE,b.endt_expiry_date))) >= p_loss_date
              ORDER BY b.eff_date DESC, endt_seq_no DESC)
  LOOP
    v_max_endt_seq_no      := c1.endt_seq_no;
    v_assignee             := NVL(c1.assignee, v_assignee);
    v_currency_cd          := NVL(c1.currency_cd, v_currency_cd);
    v_currency_rt          := NVL(c1.currency_rt, v_currency_rt);
    v_currency_desc         := NVL(c1.currency_desc, v_currency_desc);
    v_fr_item_type          := NVL(c1.fr_item_type, v_fr_item_type);
    v_item_title          := NVL(c1.item_title, v_item_title);
    v_district_no          := NVL(c1.district_no, v_district_no);
    v_block_no            := NVL(c1.block_no, v_block_no);
    v_block_id          := NVL(c1.block_id, v_block_id);
    v_eq_zone           := NVL(c1.eq_zone, v_eq_zone);
    v_typhoon_zone           := NVL(c1.typhoon_zone, v_typhoon_zone);
    v_flood_zone           := NVL(c1.flood_zone, v_flood_zone);
    v_tariff_zone          := NVL(c1.tariff_zone, v_tariff_zone);
    v_tarf_cd             := NVL(c1.tarf_cd, v_tarf_cd);
    v_risk_cd               := NVL(c1.risk_cd, v_risk_cd); -- jess 06232010
    v_loc_risk1               := NVL(c1.loc_risk1, v_loc_risk1);
    v_loc_risk2           := NVL(c1.loc_risk2, v_loc_risk2);
    v_loc_risk3          := NVL(c1.loc_risk3, v_loc_risk3);
    v_front              := NVL(c1.front, v_front);
    v_rear              := NVL(c1.rear, v_rear);
    v_left               := NVL(c1.left, v_left);
    v_right              := NVL(c1.right, v_right);
    v_occupancy_cd            := NVL(c1.occupancy_cd, v_occupancy_cd);
    v_occupancy_remarks    := NVL(c1.occupancy_remarks, v_occupancy_remarks);
    v_construction_cd      := NVL(c1.construction_cd, v_construction_cd);
    v_construction_remarks := NVL(c1.construction_remarks, v_construction_remarks);
    EXIT;
  END LOOP;
  FOR c2 IN (SELECT d.assignee, c.currency_cd, e.currency_desc, d.fr_item_type, d.district_no, d.block_no, d.block_id, d.eq_zone, d.typhoon_zone, d.flood_zone, d.tariff_zone, d.tarf_cd, d.risk_cd, d.loc_risk1, d.loc_risk2, d.loc_risk3, d.front,                        d.rear, d.left, d.right,d.occupancy_cd, d.occupancy_remarks,                                     d.construction_cd, d.construction_remarks, c.currency_rt, item_title
               FROM gipi_polbasic b, gipi_item c, gipi_fireitem d,giis_currency e
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.policy_id = c.policy_id
                AND c.currency_cd = e.main_currency_cd
                AND c.policy_id = d.policy_id
                AND c.item_no = d.item_no
                AND NVL(b.back_stat,5) = 2
                AND b.pol_flag IN ('1','2','3','X')
                AND endt_seq_no > v_max_endt_seq_no
                AND TRUNC(DECODE(TRUNC(NVL(c.from_date,b.eff_date)),TRUNC(b.incept_date),                            NVL(c.from_date,p_incept_date), NVL(c.from_date,b.eff_date)))                                    <= p_loss_date
                AND TRUNC(DECODE(NVL(c.TO_DATE,NVL(b.endt_expiry_date, b.expiry_date)),
                    b.expiry_date, NVL(c.TO_DATE,p_expiry_date),                                                     NVL(c.TO_DATE,b.endt_expiry_date)))>= p_loss_date
              ORDER BY endt_seq_no DESC)
  LOOP
    v_assignee          := NVL(c2.assignee, v_assignee);
    v_currency_cd          := NVL(c2.currency_cd, v_currency_cd);
    v_currency_desc         := NVL(c2.currency_desc, v_currency_desc);
    v_currency_rt          := NVL(c2.currency_rt, v_currency_rt);
    v_fr_item_type          := NVL(c2.fr_item_type, v_fr_item_type);
    v_item_title          := NVL(c2.item_title, v_item_title);
    v_district_no          := NVL(c2.district_no, v_district_no);
    v_block_no            := NVL(c2.block_no, v_block_no);
    v_block_id          := NVL(c2.block_id, v_block_id);
    v_eq_zone           := NVL(c2.eq_zone, v_eq_zone);
    v_typhoon_zone           := NVL(c2.typhoon_zone, v_typhoon_zone);
    v_flood_zone           := NVL(c2.flood_zone, v_flood_zone);
    v_tariff_zone          := NVL(c2.tariff_zone, v_tariff_zone);
    v_tarf_cd             := NVL(c2.tarf_cd, v_tarf_cd);
    v_risk_cd               := NVL(c2.risk_cd, v_risk_cd); -- jess 06232010
    v_loc_risk1               := NVL(c2.loc_risk1, v_loc_risk1);
    v_loc_risk2           := NVL(c2.loc_risk2, v_loc_risk2);
    v_loc_risk3          := NVL(c2.loc_risk3, v_loc_risk3);
    v_front              := NVL(c2.front, v_front);
    v_rear              := NVL(c2.rear, v_rear);
    v_left               := NVL(c2.left, v_left);
    v_right              := NVL(c2.right, v_right);
    v_occupancy_cd            := NVL(c2.occupancy_cd, v_occupancy_cd);
    v_occupancy_remarks    := NVL(c2.occupancy_remarks, v_occupancy_remarks);
    v_construction_cd      := NVL(c2.construction_cd, v_construction_cd);
    v_construction_remarks := NVL(c2.construction_remarks, v_construction_remarks);
    EXIT;
  END LOOP;
  UPDATE gicl_fire_dtl
     SET assignee = NVL(v_assignee,assignee),
         currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rt,currency_rate),
         fr_item_type = NVL(v_fr_item_type,fr_item_type),
         item_title = NVL(v_item_title,item_title),
         district_no = NVL(v_district_no,district_no),
         block_no = NVL(v_block_no,block_no),
         block_id = NVL(v_block_id,block_id),
         eq_zone = NVL(v_eq_zone,eq_zone),
         typhoon_zone = NVL(v_typhoon_zone,typhoon_zone),
         flood_zone = NVL(v_flood_zone,flood_zone),
         tariff_zone = NVL(v_tariff_zone,tariff_zone),
         tarf_cd = NVL(v_tarf_cd,tarf_cd),
         risk_cd = NVL(v_risk_cd, risk_cd), -- jess 06232010
         loc_risk1 = NVL(v_loc_risk1,loc_risk1),
         loc_risk2 = NVL(v_loc_risk2,loc_risk2),
         loc_risk3 = NVL(v_loc_risk3,loc_risk3),
         front = NVL(v_front,front),
         rear = NVL(v_rear,rear),
         left = NVL(v_left,left),
         right = NVL(v_right,right),
         occupancy_cd = NVL(v_occupancy_cd,occupancy_cd),
         occupancy_remarks = NVL(v_occupancy_remarks,occupancy_remarks),
         construction_cd = NVL(v_construction_cd,construction_cd),
         construction_remarks = NVL(v_construction_remarks,construction_remarks)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/


