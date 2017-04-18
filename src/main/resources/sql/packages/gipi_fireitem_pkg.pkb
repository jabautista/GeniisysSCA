CREATE OR REPLACE PACKAGE BODY CPI.gipi_fireitem_pkg
AS
/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 3, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve fire type code from GIPI_FIREITEM.
*/
   FUNCTION get_fi_tariff_zone (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eff_date      gipi_wpolbas.eff_date%TYPE;
      v_line_cd       gipi_wpolbas.line_cd%TYPE;
      v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
      v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no      gipi_wpolbas.renew_no%TYPE;
      v_expiry_date   gipi_wpolbas.expiry_date%TYPE;
      v_tariff_zone   gipi_vehicle.tariff_zone%TYPE;
   BEGIN
      v_expiry_date := extract_expiry (p_par_id);

      FOR i IN (SELECT incept_date, eff_date, endt_expiry_date, expiry_date,
                       short_rt_percent, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, comp_sw, prorate_flag
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         v_eff_date := i.eff_date;
         v_expiry_date := i.expiry_date;
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
      END LOOP;

      FOR fire1 IN (SELECT   tariff_zone
                        FROM gipi_fireitem a, gipi_polbasic b
                       WHERE b.policy_id = a.policy_id
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND a.tariff_zone IS NOT NULL
                         AND b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND a.item_no = p_item_no
                         AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                         AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                 b.expiry_date
                                                ),
                                            b.expiry_date, v_expiry_date,
                                            b.endt_expiry_date, b.endt_expiry_date
                                           )
                                   ) >= v_eff_date
                    ORDER BY b.eff_date DESC)
      LOOP
         v_tariff_zone := fire1.tariff_zone;
         EXIT;
      END LOOP;

      RETURN v_tariff_zone;
   END get_fi_tariff_zone;

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 3, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve tariff code from GIPI_FIREITEM.
*/
   FUNCTION get_tarf_cd (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eff_date      gipi_wpolbas.eff_date%TYPE;
      v_line_cd       gipi_wpolbas.line_cd%TYPE;
      v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
      v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no      gipi_wpolbas.renew_no%TYPE;
      v_expiry_date   gipi_wpolbas.expiry_date%TYPE;
      v_tarf_cd       gipi_fireitem.tarf_cd%TYPE;
   BEGIN
      v_expiry_date := extract_expiry (p_par_id);

      FOR i IN (SELECT incept_date, eff_date, endt_expiry_date, expiry_date,
                       short_rt_percent, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, comp_sw, prorate_flag
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         v_eff_date := i.eff_date;
         v_expiry_date := i.expiry_date;
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
      END LOOP;

      FOR fire2 IN (SELECT   tarf_cd
                        FROM gipi_fireitem a, gipi_polbasic b
                       WHERE b.policy_id = a.policy_id
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND a.tarf_cd IS NOT NULL
                         AND b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND a.item_no = p_item_no
                         AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                         AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                 b.expiry_date
                                                ),
                                            b.expiry_date, v_expiry_date,
                                            b.endt_expiry_date, b.endt_expiry_date
                                           )
                                   ) >= v_eff_date
                    ORDER BY b.eff_date DESC)
      LOOP
         v_tarf_cd := fire2.tarf_cd;
         EXIT;
      END LOOP;

      RETURN v_tarf_cd;
   END get_tarf_cd;

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 3, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve construction code from GIPI_FIREITEM.
*/
   FUNCTION get_construction_cd (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eff_date          gipi_wpolbas.eff_date%TYPE;
      v_line_cd           gipi_wpolbas.line_cd%TYPE;
      v_subline_cd        gipi_wpolbas.subline_cd%TYPE;
      v_iss_cd            gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy          gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no        gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no          gipi_wpolbas.renew_no%TYPE;
      v_expiry_date       gipi_wpolbas.expiry_date%TYPE;
      v_construction_cd   gipi_fireitem.tarf_cd%TYPE;
   BEGIN
      v_expiry_date := extract_expiry (p_par_id);

      FOR i IN (SELECT incept_date, eff_date, endt_expiry_date, expiry_date,
                       short_rt_percent, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, comp_sw, prorate_flag
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         v_eff_date := i.eff_date;
         v_expiry_date := i.expiry_date;
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
      END LOOP;

      FOR fire3 IN (SELECT   construction_cd
                        FROM gipi_fireitem a, gipi_polbasic b
                       WHERE b.policy_id = a.policy_id
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND a.construction_cd IS NOT NULL
                         AND b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND a.item_no = p_item_no
                         AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                         AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                 b.expiry_date
                                                ),
                                            b.expiry_date, v_expiry_date,
                                            b.endt_expiry_date, b.endt_expiry_date
                                           )
                                   ) >= v_eff_date
                    ORDER BY b.eff_date DESC)
      LOOP
         v_construction_cd := fire3.construction_cd;
         EXIT;
      END LOOP;

      RETURN v_construction_cd;
   END get_construction_cd;

   /*
   **  Created by        : Andrew
   **  Date Created    : 05.14.2011
   **  Reference By    : (GIPIS039- Item Information - Fire - Endorsement)
   **  Description        : Retrieves record on GIPI_FIREITM based on the given par_id and item_no
   */
   FUNCTION get_gipi_fireitems (
      p_policy_id   IN   gipi_fireitem.policy_id%TYPE,
      p_item_no     IN   gipi_fireitem.item_no%TYPE
   )
      RETURN gipi_fireitem_tab PIPELINED
   IS
      v_gipi_fireitem   gipi_fireitem_type;
   BEGIN
      FOR i IN (SELECT   a.policy_id, a.item_no, a.district_no, a.eq_zone,
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
                         a.latitude, a.longitude --Added by Jerome 11.14.2016 SR 5749
                    FROM gipi_fireitem a,
                         giis_block b,
                         giis_province c,
                         giis_fire_occupancy d
                   WHERE a.policy_id = p_policy_id
                     AND a.item_no = p_item_no
                     AND a.block_id = b.block_id(+)
                     AND b.province_cd = c.province_cd(+)
                     AND a.occupancy_cd = d.occupancy_cd(+)
                ORDER BY a.policy_id, a.item_no)
      LOOP
         v_gipi_fireitem.policy_id := i.policy_id;
         v_gipi_fireitem.item_no := i.item_no;
         v_gipi_fireitem.district_no := i.district_no;
         v_gipi_fireitem.eq_zone := i.eq_zone;
         v_gipi_fireitem.eq_desc :=
                                  giis_eqzone_pkg.get_eqzone_desc (i.eq_zone);
         v_gipi_fireitem.tarf_cd := i.tarf_cd;
         v_gipi_fireitem.block_no := i.block_no;
         v_gipi_fireitem.fr_item_type := i.fr_item_type;
         v_gipi_fireitem.loc_risk1 := i.loc_risk1;
         v_gipi_fireitem.loc_risk2 := i.loc_risk2;
         v_gipi_fireitem.loc_risk3 := i.loc_risk3;
         v_gipi_fireitem.tariff_zone := i.tariff_zone;
         v_gipi_fireitem.typhoon_zone := i.typhoon_zone;
         v_gipi_fireitem.typhoon_zone_desc :=
                 giis_typhoon_zone_pkg.get_typhoon_zone_desc (i.typhoon_zone);
         v_gipi_fireitem.construction_cd := i.construction_cd;
         v_gipi_fireitem.construction_remarks := i.construction_remarks;
         v_gipi_fireitem.front := i.front;
         v_gipi_fireitem.RIGHT := i.RIGHT;
         v_gipi_fireitem.LEFT := i.LEFT;
         v_gipi_fireitem.rear := i.rear;
         v_gipi_fireitem.occupancy_cd := i.occupancy_cd;
         v_gipi_fireitem.occupancy_desc := i.occupancy_desc;
         v_gipi_fireitem.occupancy_remarks := i.occupancy_remarks;
         v_gipi_fireitem.assignee := i.assignee;
         v_gipi_fireitem.flood_zone := i.flood_zone;
         v_gipi_fireitem.flood_zone_desc :=
                       giis_flood_zone_pkg.get_flood_zone_desc (i.flood_zone);
         v_gipi_fireitem.block_id := i.block_id;
         v_gipi_fireitem.risk_cd := i.risk_cd;
         v_gipi_fireitem.city_cd := i.city_cd;
         v_gipi_fireitem.province_cd := i.province_cd;
         v_gipi_fireitem.province_desc := i.province_desc;
         v_gipi_fireitem.city := i.city;
         v_gipi_fireitem.district_desc := i.district_desc;
         v_gipi_fireitem.risk_desc := i.risk_desc;
         v_gipi_fireitem.latitude := i.latitude; --Added by Jerome 11.14.2016 SR 5749
         v_gipi_fireitem.longitude := i.longitude; --Added by Jerome 11.14.2016 SR 5749
         PIPE ROW (v_gipi_fireitem);
      END LOOP;
   END get_gipi_fireitems;

   /*
   **  Created by   : Moses Calma
   **  Date Created : June 7, 2011
   **  Reference By : (GIPIS100 - Policy Information)
   **  Description  : Retrieves list of fireitem
   */
   FUNCTION get_fireitem_info (
      p_policy_id   gipi_fireitem.policy_id%TYPE,
      p_item_no     gipi_fireitem.item_no%TYPE
   )
      RETURN fireitem_info_tab PIPELINED
   IS
      v_fireitem_info    fireitem_info_type;
      v_line_cd          gipi_polbasic.line_cd%TYPE;
      v_subline_cd       gipi_polbasic.subline_cd%TYPE;
      v_iss_cd           gipi_polbasic.iss_cd%TYPE;
      v_issue_yy         gipi_polbasic.issue_yy%TYPE;
      v_renew_no         gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;
      v_line_cd_endt0    gipi_polbasic.line_cd%TYPE;
      v_subline_cd_endt0 gipi_polbasic.subline_cd%TYPE;
      v_iss_cd_endt0     gipi_polbasic.iss_cd%TYPE;
      v_issue_yy_endt0   gipi_polbasic.issue_yy%TYPE;
      v_renew_no_endt0   gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no_endt0 gipi_polbasic.pol_seq_no%TYPE;

   BEGIN
      FOR i IN (SELECT policy_id, item_no, assignee, fr_item_type, block_id, district_no,
                       block_no, eq_zone, typhoon_zone, flood_zone, construction_cd,
                       construction_remarks, occupancy_cd, occupancy_remarks, loc_risk1,
                       loc_risk2, loc_risk3, tariff_zone, tarf_cd, front, rear, right, left, latitude, longitude
                  FROM gipi_fireitem
                 WHERE policy_id = p_policy_id
                   AND item_no = p_item_no)
      LOOP

         v_fireitem_info.policy_id             := i.policy_id;
         v_fireitem_info.item_no               := i.item_no;
         v_fireitem_info.assignee              := i.assignee;
         v_fireitem_info.block_id              := i.block_id;
         v_fireitem_info.block_no              := i.block_no;
         v_fireitem_info.eq_zone               := i.eq_zone;
         v_fireitem_info.loc_risk1             := i.loc_risk1;
         v_fireitem_info.loc_risk2             := i.loc_risk2;
         v_fireitem_info.loc_risk3             := i.loc_risk3;
         v_fireitem_info.front                 := i.front;
         v_fireitem_info.rear                  := i.rear;
         v_fireitem_info.right                 := i.right;
         v_fireitem_info.left                  := i.left;
         v_fireitem_info.tarf_cd               := i.tarf_cd;
         v_fireitem_info.flood_zone            := i.flood_zone;
         v_fireitem_info.district_no           := i.district_no;
         v_fireitem_info.tariff_zone           := i.tariff_zone;
         v_fireitem_info.occupancy_cd          := i.occupancy_cd;
         v_fireitem_info.fr_item_type          := i.fr_item_type;
         v_fireitem_info.typhoon_zone          := i.typhoon_zone;
         v_fireitem_info.construction_cd       := i.construction_cd;
         v_fireitem_info.occupancy_remarks     := i.occupancy_remarks;
         v_fireitem_info.construction_remarks  := i.construction_remarks;
         v_fireitem_info.latitude              := i.latitude; -- Added by Jerome 11.15.2016 SR 5749
         v_fireitem_info.longitude             := i.longitude; -- Added by Jerome 11.15.2016 SR 5749

         BEGIN
            SELECT item_title,
                   risk_no,
                   risk_item_no
              INTO v_fireitem_info.item_title,
                   v_fireitem_info.risk_no,
                   v_fireitem_info.risk_item_no
              FROM gipi_item
             WHERE policy_id = i.policy_id
               AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_fireitem_info.item_title    := '';
               v_fireitem_info.risk_no       := '';
               v_fireitem_info.risk_item_no  := '';
         END;

         BEGIN

           SELECT fr_itm_tp_ds
             INTO v_fireitem_info.fr_item_desc
             FROM giis_fi_item_type
            WHERE fr_item_type = i.fr_item_type;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.fr_item_desc := '';
         END;

         BEGIN

           SELECT eq_desc
             INTO v_fireitem_info.eq_desc
             FROM giis_eqzone
            WHERE eq_zone = i.eq_zone;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.eq_desc := '';
         END;

         BEGIN

         SELECT construction_desc
           INTO v_fireitem_info.construction_desc
           FROM giis_fire_construction
          WHERE construction_cd = i.construction_cd;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.construction_desc := '';
         END;

         BEGIN

           SELECT typhoon_zone_desc
             INTO v_fireitem_info.typhoon_zone_desc
             FROM giis_typhoon_zone
            WHERE typhoon_zone = i.typhoon_zone;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.typhoon_zone_desc := '';
         END;

         BEGIN

           SELECT tariff_zone_desc
             INTO v_fireitem_info.tariff_zone_desc
             FROM giis_tariff_zone
            WHERE tariff_zone = i.tariff_zone;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.tariff_zone_desc := '';
         END;

         BEGIN

           SELECT tarf_desc
             INTO v_fireitem_info.tarf_desc
             FROM giis_tariff
            WHERE tarf_cd = i.tarf_cd;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.tarf_desc := '';
         END;

         BEGIN

           SELECT occupancy_desc
             INTO v_fireitem_info.occupancy_desc
             FROM giis_fire_occupancy
            WHERE occupancy_cd = i.occupancy_cd;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.occupancy_desc := '';
         END;

         BEGIN

           SELECT flood_zone_desc
             INTO v_fireitem_info.flood_zone_desc
             FROM giis_flood_zone
            WHERE flood_zone = i.flood_zone;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.flood_zone_desc := '';
         END;

         BEGIN

           SELECT b.province_desc
             INTO v_fireitem_info.province_desc
             FROM giis_block a, giis_province b
            WHERE a.province_cd = b.province_cd
              AND a.block_id = i.block_id;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.province_desc := '';
         END;

         BEGIN

           SELECT city
             INTO v_fireitem_info.city
             FROM giis_block
            WHERE block_id = i.block_id;

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
           v_fireitem_info.city := '';
         END;

         SELECT line_cd, subline_cd, iss_cd, issue_yy, renew_no, pol_seq_no
           INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_renew_no, v_pol_seq_no
           FROM gipi_polbasic
          WHERE policy_id = i.policy_id;

         SELECT line_cd, subline_cd, iss_cd,
                issue_yy, renew_no, pol_seq_no
           INTO v_line_cd_endt0, v_subline_cd_endt0, v_iss_cd_endt0,
                v_issue_yy_endt0, v_renew_no_endt0, v_pol_seq_no_endt0
           FROM gipi_polbasic
          WHERE endt_seq_no = 0
            AND line_cd = v_line_cd
            AND subline_cd = v_subline_cd
            AND iss_cd = v_iss_cd
            AND issue_yy = v_issue_yy
            AND renew_no = v_renew_no
            AND pol_seq_no = v_pol_seq_no;

         BEGIN

           FOR x IN (SELECT a.to_date, a.from_date --Edit by Rey to handle too many rows 08/11/2011
             --INTO v_fireitem_info.to_date, v_fireitem_info.from_date
             FROM gipi_item a, gipi_polbasic b
            WHERE a.policy_id = b.policy_id
              AND b.line_cd = v_line_cd_endt0
              AND b.subline_cd = v_subline_cd_endt0
              AND b.iss_cd = v_iss_cd_endt0
              AND b.issue_yy = v_issue_yy_endt0
              AND b.renew_no = v_renew_no_endt0
              AND b.pol_seq_no = v_pol_seq_no_endt0
              AND a.item_no = i.item_no)
          LOOP
            v_fireitem_info.to_date := x.to_date;
            v_fireitem_info.from_date := x.from_date;

          END LOOP;

         --EXCEPTION
         --WHEN NO_DATA_FOUND
         --THEN

           --v_fireitem_info.to_date := '';
           --v_fireitem_info.from_date := '';

           --INTO v_fireitem_info.to_date, v_fireitem_info.from_date

         END;

         PIPE ROW (v_fireitem_info);
      END LOOP;
   END get_fireitem_info;

END gipi_fireitem_pkg;
/


