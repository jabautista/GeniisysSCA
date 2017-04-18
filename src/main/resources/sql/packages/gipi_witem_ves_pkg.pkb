CREATE OR REPLACE PACKAGE BODY CPI.gipi_witem_ves_pkg
AS
   FUNCTION get_gipi_witem_ves (p_par_id gipi_witem_ves.par_id%TYPE)
      --  p_item_no         GIPI_WITEM_VES.item_no%TYPE)
   RETURN gipi_witem_ves_tab PIPELINED
   IS
      v_witem_ves   gipi_witem_ves_type;
   --PAR details
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_no, a.item_title, a.item_grp,
                       a.item_desc, a.item_desc2, a.tsi_amt, a.prem_amt,
                       a.ann_prem_amt, a.ann_tsi_amt, a.currency_cd,
                       a.currency_rt, a.group_cd, a.from_date, a.TO_DATE,
                       a.pack_line_cd, a.pack_subline_cd, a.discount_sw,
                       a.coverage_cd, a.other_info, a.surcharge_sw,
                       a.region_cd, a.changed_tag, a.prorate_flag, a.comp_sw,
                       a.short_rt_percent, a.pack_ben_cd, a.payt_terms,
                       a.risk_no, a.risk_item_no, g.currency_desc,
                       h.coverage_desc, a.rec_flag        --, b.vessel_cd, c.vessel_flag,
                  --c.vessel_name, c.vessel_old_name, d.vestype_desc,
                  --c.propel_sw, e.vess_class_desc, f.hull_desc,
                  --c.reg_owner, c.reg_place, c.gross_ton, c.year_built,
                  --c.net_ton, c.no_crew, c.deadweight, c.crew_nat,
                  --c.vessel_length, c.vessel_breadth, c.vessel_depth,
                  --b.dry_place, TO_CHAR (b.dry_date) dry_date,
                  --b.rec_flag, b.deduct_text, b.geog_limit
                FROM   gipi_witem a,
                                    --gipi_witem_ves b,
                                    --giis_vessel c,
                                    --giis_vestype d,
                                    --giis_vess_class e,
                                    --giis_hull_type f,
                                    giis_currency g, giis_coverage h
                 WHERE a.par_id = p_par_id
                   --AND a.par_id = b.par_id
                   --AND a.item_no = b.item_no
                   --AND b.vessel_cd = c.vessel_cd
                   --AND c.vestype_cd = d.vestype_cd
                   --AND c.vess_class_cd = e.vess_class_cd
                   --AND c.hull_type_cd = f.hull_type_cd
                   AND a.currency_cd = g.main_currency_cd
                   AND a.coverage_cd = h.coverage_cd(+)
                 ORDER BY a.item_no)
      LOOP
         BEGIN
            SELECT b.vessel_cd, c.vessel_flag,
                   c.vessel_name, c.vessel_old_name,
                   d.vestype_desc, c.propel_sw,
                   e.vess_class_desc, f.hull_desc,
                   c.reg_owner, c.reg_place,
                   c.gross_ton, c.year_built,
                   c.net_ton, c.no_crew,
                   c.deadweight, c.crew_nat,
                   c.vessel_length, c.vessel_breadth,
                   c.vessel_depth, b.dry_place,
                   TO_CHAR (b.dry_date, 'mm-dd-yyyy') dry_date, b.deduct_text,
                   b.geog_limit
              INTO v_witem_ves.vessel_cd, v_witem_ves.vessel_flag,
                   v_witem_ves.vessel_name, v_witem_ves.vessel_old_name,
                   v_witem_ves.vestype_desc, v_witem_ves.propel_sw,
                   v_witem_ves.vess_class_desc, v_witem_ves.hull_desc,
                   v_witem_ves.reg_owner, v_witem_ves.reg_place,
                   v_witem_ves.gross_ton, v_witem_ves.year_built,
                   v_witem_ves.net_ton, v_witem_ves.no_crew,
                   v_witem_ves.deadweight, v_witem_ves.crew_nat,
                   v_witem_ves.vessel_length, v_witem_ves.vessel_breadth,
                   v_witem_ves.vessel_depth, v_witem_ves.dry_place,
                   v_witem_ves.dry_date, v_witem_ves.deduct_text,
                   v_witem_ves.geog_limit
              FROM gipi_witem_ves b,
                   giis_vessel c,
                   giis_vestype d,
                   giis_vess_class e,
                   giis_hull_type f
             WHERE b.par_id = i.par_id
               AND b.item_no = i.item_no
               AND b.vessel_cd = c.vessel_cd
               AND c.vestype_cd = d.vestype_cd
               AND c.vess_class_cd = e.vess_class_cd
               AND c.hull_type_cd = f.hull_type_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_witem_ves.vessel_cd := NULL;
               v_witem_ves.vessel_flag := NULL;
               v_witem_ves.vessel_name := NULL;
               v_witem_ves.vessel_old_name := NULL;
               v_witem_ves.vestype_desc := NULL;
               v_witem_ves.propel_sw := NULL;
               v_witem_ves.vess_class_desc := NULL;
               v_witem_ves.hull_desc := NULL;
               v_witem_ves.reg_owner := NULL;
               v_witem_ves.reg_place := NULL;
               v_witem_ves.gross_ton := NULL;
               v_witem_ves.year_built := NULL;
               v_witem_ves.net_ton := NULL;
               v_witem_ves.no_crew := NULL;
               v_witem_ves.deadweight := NULL;
               v_witem_ves.crew_nat := NULL;
               v_witem_ves.vessel_length := NULL;
               v_witem_ves.vessel_breadth := NULL;
               v_witem_ves.vessel_depth := NULL;
               v_witem_ves.dry_place := NULL;
               v_witem_ves.dry_date := NULL;
               v_witem_ves.rec_flag := NULL;
               v_witem_ves.deduct_text := NULL;
               v_witem_ves.geog_limit := NULL;
         END;

         SELECT COUNT (peril_cd)
           INTO v_witem_ves.no_of_itemperils
           FROM gipi_witmperl
          WHERE par_id = p_par_id AND item_no = i.item_no;

         v_witem_ves.par_id := i.par_id;
         v_witem_ves.item_no := i.item_no;
         v_witem_ves.item_title := i.item_title;
         v_witem_ves.item_grp := i.item_grp;
         v_witem_ves.item_desc := i.item_desc;
         v_witem_ves.item_desc2 := i.item_desc2;
         v_witem_ves.tsi_amt := i.tsi_amt;
         v_witem_ves.prem_amt := i.prem_amt;
         v_witem_ves.ann_prem_amt := i.ann_prem_amt;
         v_witem_ves.ann_tsi_amt := i.ann_tsi_amt;
         v_witem_ves.currency_cd := i.currency_cd;
         v_witem_ves.currency_rt := i.currency_rt;
         v_witem_ves.group_cd := i.group_cd;
         v_witem_ves.from_date := i.from_date;
         v_witem_ves.TO_DATE := i.TO_DATE;
         v_witem_ves.pack_line_cd := i.pack_line_cd;
         v_witem_ves.pack_subline_cd := i.pack_subline_cd;
         v_witem_ves.discount_sw := i.discount_sw;
         v_witem_ves.coverage_cd := i.coverage_cd;
         v_witem_ves.other_info := i.other_info;
         v_witem_ves.surcharge_sw := i.surcharge_sw;
         v_witem_ves.region_cd := i.region_cd;
         v_witem_ves.changed_tag := i.changed_tag;
         v_witem_ves.prorate_flag := i.prorate_flag;
         v_witem_ves.comp_sw := i.comp_sw;
         v_witem_ves.short_rt_percent := i.short_rt_percent;
         v_witem_ves.pack_ben_cd := i.pack_ben_cd;
         v_witem_ves.payt_terms := i.payt_terms;
         v_witem_ves.risk_no := i.risk_no;
         v_witem_ves.risk_item_no := i.risk_item_no;
         v_witem_ves.currency_desc := i.currency_desc;
         v_witem_ves.coverage_desc := i.coverage_desc;
         --v_witem_ves.vessel_cd := i.vessel_cd;
         --v_witem_ves.vessel_flag := i.vessel_flag;
         --v_witem_ves.vessel_name := i.vessel_name;
         --v_witem_ves.vessel_old_name := i.vessel_old_name;
         --v_witem_ves.vestype_desc := i.vestype_desc;
         --v_witem_ves.propel_sw := i.propel_sw;
         --v_witem_ves.vess_class_desc := i.vess_class_desc;
         --v_witem_ves.hull_desc := i.hull_desc;
         --v_witem_ves.reg_owner := i.reg_owner;
         --v_witem_ves.reg_place := i.reg_place;
         --v_witem_ves.gross_ton := i.gross_ton;
         --v_witem_ves.year_built := i.year_built;
         --v_witem_ves.net_ton := i.net_ton;
         --v_witem_ves.no_crew := i.no_crew;
         --v_witem_ves.deadweight := i.deadweight;
         --v_witem_ves.crew_nat := i.crew_nat;
         --v_witem_ves.vessel_length := i.vessel_length;
         --v_witem_ves.vessel_breadth := i.vessel_breadth;
         --v_witem_ves.vessel_depth := i.vessel_depth;
         --v_witem_ves.dry_place := i.dry_place;
         --v_witem_ves.dry_date := i.dry_date;
         v_witem_ves.rec_flag := i.rec_flag;
         --v_witem_ves.deduct_text := i.deduct_text;
         --v_witem_ves.geog_limit := i.geog_limit;
         v_witem_ves.itmperl_grouped_exists :=
            gipi_witmperl_grouped_pkg.gipi_witmperl_grouped_exist (p_par_id,
                                                                   i.item_no
                                                                  );
         PIPE ROW (v_witem_ves);
      END LOOP;

      RETURN;
   END get_gipi_witem_ves;

   /*PROCEDURE set_gipi_witem_ves (
      p_par_id        IN   gipi_witem_ves.par_id%TYPE,
      p_item_no       IN   gipi_witem_ves.item_no%TYPE,
      p_vessel_cd     IN   gipi_witem_ves.vessel_cd%TYPE,
      p_rec_flag      IN   gipi_witem_ves.rec_flag%TYPE,
      p_deduct_text   IN   gipi_witem_ves.deduct_text%TYPE,
      p_geog_limit    IN   gipi_witem_ves.geog_limit%TYPE,
      p_dry_date           VARCHAR2,       --IN  GIPI_WITEM_VES.dry_date%TYPE,
      p_dry_place     IN   gipi_witem_ves.dry_place%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_witem_ves
         USING DUAL
         ON (par_id = p_par_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, vessel_cd, rec_flag, deduct_text,
                    geog_limit, dry_date, dry_place)
            VALUES (p_par_id, p_item_no, p_vessel_cd, p_rec_flag,
                    p_deduct_text, p_geog_limit, p_dry_date, p_dry_place)
         WHEN MATCHED THEN
            UPDATE
               SET vessel_cd = p_vessel_cd, rec_flag = p_rec_flag,
                   deduct_text = p_deduct_text, dry_place = p_dry_place,
                   dry_date = TO_DATE (p_dry_date, 'MM-DD-RRRR'),
                   geog_limit = p_geog_limit
            ;
      COMMIT;
   END set_gipi_witem_ves;*/

   /*
    **  Created by    : Cris Castro
    **  Date Created  : 05.14.2010
    **  Reference By  : (GIPIS009- Item Information - Marine Hull)
    **  Description   : Delete per item no PAR record listing for MARINE HULL
    */
   PROCEDURE del_gipi_witem_ves (
      p_par_id    gipi_witem_ves.par_id%TYPE,
      p_item_no   gipi_witem_ves.item_no%TYPE
   )
   IS
   BEGIN
      DELETE      gipi_witem_ves
            WHERE par_id = p_par_id AND item_no = p_item_no;
   END;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 06.01.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This procedure deletes record based on the given par_id
   */
   PROCEDURE del_gipi_witem_ves (p_par_id IN gipi_witem_ves.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_witem_ves
            WHERE par_id = p_par_id;
   END del_gipi_witem_ves;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 06.03.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This procedure inserts/updates record on GIPI_WITEM_VES (complete columns)
   */
   PROCEDURE set_gipi_witem_ves (
      p_par_id        IN   gipi_witem_ves.par_id%TYPE,
      p_item_no       IN   gipi_witem_ves.item_no%TYPE,
      p_vessel_cd     IN   gipi_witem_ves.vessel_cd%TYPE,
      p_rec_flag      IN   gipi_witem_ves.rec_flag%TYPE,
      p_deduct_text   IN   gipi_witem_ves.deduct_text%TYPE,
      p_geog_limit    IN   gipi_witem_ves.geog_limit%TYPE,
      p_dry_date      IN   gipi_witem_ves.dry_date%TYPE,
      p_dry_place     IN   gipi_witem_ves.dry_place%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_witem_ves
         USING DUAL
         ON (par_id = p_par_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, vessel_cd, rec_flag, deduct_text,
                    geog_limit, dry_date, dry_place)
            VALUES (p_par_id, p_item_no, p_vessel_cd, p_rec_flag,
                    p_deduct_text, p_geog_limit, p_dry_date, p_dry_place)
         WHEN MATCHED THEN
            UPDATE
               SET vessel_cd = p_vessel_cd, rec_flag = p_rec_flag,
                   deduct_text = p_deduct_text, dry_place = p_dry_place,
                   dry_date = p_dry_date, geog_limit = p_geog_limit
            ;
   END set_gipi_witem_ves;

   PROCEDURE set_gipi_witem_ves (p_ves gipi_witem_ves%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gipi_witem_ves
         USING DUAL
         ON (par_id = p_ves.par_id AND item_no = p_ves.item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, vessel_cd, rec_flag, deduct_text,
                    geog_limit, dry_date, dry_place)
            VALUES (p_ves.par_id, p_ves.item_no, p_ves.vessel_cd,
                    p_ves.rec_flag, p_ves.deduct_text, p_ves.geog_limit,
                    p_ves.dry_date, p_ves.dry_place)
         WHEN MATCHED THEN
            UPDATE
               SET vessel_cd = p_ves.vessel_cd, rec_flag = p_ves.rec_flag,
                   deduct_text = p_ves.deduct_text,
                   dry_place = p_ves.dry_place, dry_date = p_ves.dry_date,
                   geog_limit = p_ves.geog_limit
            ;
   END set_gipi_witem_ves;

   /*
   **  Created by    : BJGA
   **  Date Created  : 08.20.2010
   **  Reference By  : (GIPIS081 - Endt Marine Hull Item Information)
   **  Description   : This procedure is equivalent to the WHEN-VALIDATE-ITEM for item_no
   */
   FUNCTION get_witem_ves_endt_details (
      p_line_cd        gipi_wpolbas.line_cd%TYPE,
      p_subline_cd     gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd         gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy       gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no     gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no       gipi_wpolbas.renew_no%TYPE,
      p_item_no        gipi_witem.item_no%TYPE,
      p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE
   )
      RETURN gipi_witem_ves_tab PIPELINED
   IS
      v_ves                gipi_witem_ves_type;
      p_eff_date           gipi_polbasic.eff_date%TYPE;
      expired_sw           VARCHAR2 (1)                      := 'N';
      amt_sw               VARCHAR2 (1)                      := 'N';
      v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
      v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;

      CURSOR a (
         p_eff_date      gipi_wpolbas.eff_date%TYPE,
         p_expiry_date   gipi_wpolbas.expiry_date%TYPE
      )
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.renew_no = p_renew_no
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND TRUNC (a.eff_date) <=
                     DECODE (NVL (a.endt_seq_no, 0),
                             0, TRUNC (a.eff_date),
                             TRUNC (p_eff_date)
                            )
              AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                 a.expiry_date, p_expiry_date,
                                 a.endt_expiry_date
                                )
                        ) >= TRUNC (p_eff_date)
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND b.policy_id = a.policy_id)
         ORDER BY eff_date DESC;

      CURSOR b (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT currency_cd, currency_rt, item_title, from_date, TO_DATE,
                ann_tsi_amt, ann_prem_amt, group_cd
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;

      CURSOR d (
         p_eff_date      gipi_wpolbas.eff_date%TYPE,
         p_expiry_date   gipi_wpolbas.expiry_date%TYPE
      )
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.renew_no = p_renew_no
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND TRUNC (a.eff_date) <=
                     DECODE (NVL (a.endt_seq_no, 0),
                             0, TRUNC (a.eff_date),
                             TRUNC (p_eff_date)
                            )
              AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                 a.expiry_date, p_expiry_date,
                                 a.endt_expiry_date
                                )
                        ) >= TRUNC (p_eff_date)
              AND NVL (a.back_stat, 5) = 2
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id)
              AND a.endt_seq_no =
                     (SELECT MAX (endt_seq_no)
                        FROM gipi_polbasic c
                       WHERE line_cd = p_line_cd
                         AND iss_cd = p_iss_cd
                         AND subline_cd = p_subline_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no
                         AND pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (eff_date) <=
                                DECODE (NVL (c.endt_seq_no, 0),
                                        0, TRUNC (c.eff_date),
                                        TRUNC (p_eff_date)
                                       )
                         AND TRUNC (DECODE (NVL (c.endt_expiry_date,
                                                 c.expiry_date
                                                ),
                                            c.expiry_date, p_expiry_date,
                                            c.endt_expiry_date
                                           )
                                   ) >= TRUNC (p_eff_date)
                         AND NVL (c.back_stat, 5) = 2
                         AND EXISTS (
                                SELECT '1'
                                  FROM gipi_item d
                                 WHERE d.item_no = p_item_no
                                   AND c.policy_id = d.policy_id))
         ORDER BY eff_date DESC;

      v_new_item           VARCHAR2 (1)                      := 'Y';
      v_expiry_date        gipi_wpolbas.expiry_date%TYPE;
      v_eff_date           gipi_wpolbas.eff_date%TYPE;
      v_comp_prem          gipi_witmperl.ann_prem_amt%TYPE   := 0;
      v_prorate            NUMBER;
   BEGIN
      v_ves.restricted_condition := 'N';

      BEGIN
         BEGIN
            SELECT b.eff_date, b.expiry_date
              INTO v_eff_date, v_expiry_date
              FROM gipi_wpolbas b
             WHERE b.line_cd = p_line_cd
               AND b.subline_cd = p_subline_cd
               AND b.iss_cd = p_iss_cd
               AND b.issue_yy = p_issue_yy
               AND b.pol_seq_no = p_pol_seq_no
               AND b.renew_no = p_renew_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            FOR z IN (SELECT MAX (endt_seq_no) endt_seq_no
                        FROM gipi_polbasic a
                       WHERE line_cd = p_line_cd
                         AND iss_cd = p_iss_cd
                         AND subline_cd = p_subline_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no
                         AND pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (eff_date) <=
                                DECODE (NVL (a.endt_seq_no, 0),
                                        0, TRUNC (a.eff_date),
                                        TRUNC (v_eff_date)
                                       )
                         AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                                 a.expiry_date
                                                ),
                                            a.expiry_date, v_expiry_date,
                                            a.endt_expiry_date
                                           )
                                   ) >= TRUNC (v_eff_date)
                         AND EXISTS (
                                SELECT '1'
                                  FROM gipi_item b
                                 WHERE b.item_no = p_item_no
                                   AND a.policy_id = b.policy_id))
            LOOP
               v_max_endt_seq_no := z.endt_seq_no;
               EXIT;
            END LOOP;

            FOR x IN (SELECT MAX (endt_seq_no) endt_seq_no
                        FROM gipi_polbasic a
                       WHERE line_cd = p_line_cd
                         AND iss_cd = p_iss_cd
                         AND subline_cd = p_subline_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no
                         AND pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (eff_date) <= TRUNC (v_eff_date)
                         AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                                 a.expiry_date
                                                ),
                                            a.expiry_date, v_expiry_date,
                                            a.endt_expiry_date
                                           )
                                   ) >= TRUNC (v_eff_date)
                         AND NVL (a.back_stat, 5) = 2
                         AND EXISTS (
                                SELECT '1'
                                  FROM gipi_item b
                                 WHERE b.item_no = p_item_no
                                   AND a.policy_id = b.policy_id))
            LOOP
               v_max_endt_seq_no1 := x.endt_seq_no;
               EXIT;
            END LOOP;

            expired_sw := 'N';

            FOR sw IN (SELECT   '1'
                           FROM gipi_itmperil a, gipi_polbasic b
                          WHERE b.line_cd = p_line_cd
                            AND b.subline_cd = p_subline_cd
                            AND b.iss_cd = p_iss_cd
                            AND b.issue_yy = p_issue_yy
                            AND b.pol_seq_no = p_pol_seq_no
                            AND b.renew_no = p_renew_no
                            AND b.policy_id = a.policy_id
                            AND b.pol_flag IN ('1', '2', '3', 'X')
                            AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                            AND a.item_no = p_item_no
                            AND TRUNC (b.eff_date) <=
                                   DECODE (NVL (b.endt_seq_no, 0),
                                           0, TRUNC (b.eff_date),
                                           TRUNC (v_eff_date)
                                          )
                            AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                    b.expiry_date
                                                   ),
                                               b.expiry_date, extract_expiry2
                                                                (p_line_cd,
                                                                 p_subline_cd,
                                                                 p_iss_cd,
                                                                 p_issue_yy,
                                                                 p_pol_seq_no,
                                                                 p_renew_no
                                                                ),
                                               b.expiry_date, b.endt_expiry_date
                                              )
                                      ) < TRUNC (v_eff_date)
                       ORDER BY b.eff_date DESC)
            LOOP
               expired_sw := 'Y';
               EXIT;
            END LOOP;

            amt_sw := 'N';

            IF expired_sw = 'N'
            THEN
               FOR endt IN (SELECT   a.ann_tsi_amt, a.ann_prem_amt
                                FROM gipi_item a, gipi_polbasic b
                               WHERE b.line_cd = p_line_cd
                                 AND b.subline_cd = p_subline_cd
                                 AND b.iss_cd = p_iss_cd
                                 AND b.issue_yy = p_issue_yy
                                 AND b.pol_seq_no = p_pol_seq_no
                                 AND b.renew_no = p_renew_no
                                 AND b.policy_id = a.policy_id
                                 AND b.pol_flag IN ('1', '2', '3', 'X')
                                 AND a.item_no = p_item_no
                                 AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                                 AND NVL (b.endt_seq_no, 0) > 0
                            ORDER BY b.eff_date DESC)
               LOOP
                  v_ves.ann_tsi_amt := endt.ann_tsi_amt;
                  v_ves.ann_prem_amt := endt.ann_prem_amt;
                  amt_sw := 'Y';
                  EXIT;
               END LOOP;

               IF amt_sw = 'N'
               THEN
                  FOR pol IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                                FROM gipi_item a, gipi_polbasic b
                               WHERE b.line_cd = p_line_cd
                                 AND b.subline_cd = p_subline_cd
                                 AND b.iss_cd = p_iss_cd
                                 AND b.issue_yy = p_issue_yy
                                 AND b.pol_seq_no = p_pol_seq_no
                                 AND b.renew_no = p_renew_no
                                 AND b.policy_id = a.policy_id
                                 AND b.pol_flag IN ('1', '2', '3', 'X')
                                 AND a.item_no = p_item_no
                                 AND NVL (b.endt_seq_no, 0) = 0)
                  LOOP
                     v_ves.ann_tsi_amt := pol.ann_tsi_amt;
                     v_ves.ann_prem_amt := pol.ann_prem_amt;
                     EXIT;
                  END LOOP;
               END IF;
            ELSE
               FOR a2 IN (SELECT   a.tsi_amt tsi, a.prem_amt prem,
                                   b.eff_date, b.endt_expiry_date,
                                   b.expiry_date, b.prorate_flag,
                                   NVL (b.comp_sw, 'N') comp_sw,
                                   b.short_rt_percent short_rt, a.peril_cd
                              FROM gipi_itmperil a, gipi_polbasic b
                             WHERE b.line_cd = p_line_cd
                               AND b.subline_cd = p_subline_cd
                               AND b.iss_cd = p_iss_cd
                               AND b.issue_yy = p_issue_yy
                               AND b.pol_seq_no = p_pol_seq_no
                               AND b.renew_no = p_renew_no
                               AND b.policy_id = a.policy_id
                               AND a.item_no = p_item_no
                               AND b.pol_flag IN ('1', '2', '3', 'X')
                               AND TRUNC (NVL (b.endt_expiry_date,
                                               b.expiry_date
                                              )
                                         ) >= TRUNC (v_eff_date)
                               AND TRUNC (b.eff_date) <=
                                      DECODE (NVL (b.endt_seq_no, 0),
                                              0, TRUNC (b.eff_date),
                                              TRUNC (v_eff_date)
                                             )
                          ORDER BY b.eff_date DESC)
               LOOP
                  v_comp_prem := 0;

                  IF a2.prorate_flag = 1
                  THEN
                     IF a2.endt_expiry_date <= a2.eff_date
                     THEN
                        v_ves.restricted_condition := 'Y';
                        --MSG_ALERT('Your endorsement expiry date is equal to or less than your effectivity date.'||
                                  --' Restricted condition.','E',TRUE);
                        NULL;
                     ELSE
                        IF a2.comp_sw = 'Y'
                        THEN
                           v_prorate :=
                                (  (  TRUNC (a2.endt_expiry_date)
                                    - TRUNC (a2.eff_date)
                                   )
                                 + 1
                                )
                              / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                        ELSIF a2.comp_sw = 'M'
                        THEN
                           v_prorate :=
                                (  (  TRUNC (a2.endt_expiry_date)
                                    - TRUNC (a2.eff_date)
                                   )
                                 - 1
                                )
                              / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                        ELSE
                           v_prorate :=
                                (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                        END IF;
                     END IF;

                     IF TRUNC (a2.eff_date) = TRUNC (a2.endt_expiry_date)
                     THEN
                        v_prorate := 1;
                     END IF;

                     v_comp_prem := a2.prem / v_prorate;
                  ELSIF a2.prorate_flag = 2
                  THEN
                     v_comp_prem := a2.prem;
                  ELSE
                     v_comp_prem := a2.prem / (a2.short_rt / 100);
                  END IF;

                  v_ves.ann_prem_amt := NVL (p_ann_prem_amt, 0) + v_comp_prem;

                  FOR TYPE IN (SELECT peril_type
                                 FROM giis_peril
                                WHERE line_cd = p_line_cd
                                  AND peril_cd = a2.peril_cd)
                  LOOP
                     IF TYPE.peril_type = 'B'
                     THEN
                        v_ves.ann_tsi_amt := NVL (p_ann_tsi_amt, 0) + a2.tsi;
                     END IF;
                  END LOOP;
               END LOOP;
            END IF;

            IF v_max_endt_seq_no = v_max_endt_seq_no1
            THEN
               FOR d1 IN d (v_eff_date, v_expiry_date)
               LOOP
                  FOR b1 IN b (d1.policy_id)
                  LOOP
                     p_eff_date := d1.eff_date;
                     v_ves.currency_cd := b1.currency_cd;
                     v_ves.currency_rt := b1.currency_rt;
                     v_ves.item_title := b1.item_title;
                     v_ves.from_date := b1.from_date;
                     v_ves.TO_DATE := b1.TO_DATE;
                     v_ves.group_cd := b1.group_cd;
                     v_new_item := 'N';
                     EXIT;
                  END LOOP;

                  IF p_eff_date IS NOT NULL
                  THEN
                     EXIT;
                  END IF;

                  EXIT;
               END LOOP;
            ELSE
               FOR a1 IN a (v_eff_date, v_expiry_date)
               LOOP
                  FOR b1 IN b (a1.policy_id)
                  LOOP
                     p_eff_date := a1.eff_date;
                     v_ves.currency_cd := b1.currency_cd;
                     v_ves.currency_rt := b1.currency_rt;
                     v_ves.item_title := b1.item_title;
                     v_ves.from_date := b1.from_date;
                     v_ves.TO_DATE := b1.TO_DATE;
                     v_ves.group_cd := b1.group_cd;
                     v_new_item := 'N';
                     EXIT;
                  END LOOP;

                  IF p_eff_date IS NOT NULL
                  THEN
                     EXIT;
                  END IF;

                  EXIT;
               END LOOP;
            END IF;

            IF v_new_item = 'Y'
            THEN
               FOR a1 IN (SELECT main_currency_cd, currency_desc,
                                 currency_rt
                            FROM giis_currency
                           WHERE currency_rt = 1)
               LOOP
                  v_ves.currency_cd := a1.main_currency_cd;
                  --v_ves.dsp_currency_desc := a1.currency_desc;
                  v_ves.currency_rt := a1.currency_rt;
                  EXIT;
               END LOOP;

               v_ves.rec_flag := 'A';
               v_ves.item_title := NULL;
               v_ves.ann_tsi_amt := NULL;
               v_ves.ann_prem_amt := NULL;
               v_ves.group_cd := NULL;
            --:b480.dsp_group_desc := NULL;
            ELSE
               v_ves.rec_flag := 'C';
            END IF;

            NULL;
         END;

         FOR n IN (SELECT   a.region_cd region_cd, b.region_desc region_desc
                       FROM gipi_item a, giis_region b, gipi_polbasic c
                      WHERE 1 = 1
                        AND a.policy_id = c.policy_id
                        AND c.line_cd = p_line_cd
                        AND c.subline_cd = p_subline_cd
                        AND NVL (c.iss_cd, c.iss_cd) = p_iss_cd
                        AND c.issue_yy = p_issue_yy
                        AND c.pol_seq_no = p_pol_seq_no
                        AND c.renew_no = p_renew_no
                        AND a.item_no = p_item_no
                        AND c.pol_flag IN ('1', '2', '3', 'X')
                        AND a.region_cd = b.region_cd
                        AND a.region_cd IS NOT NULL
                        AND NOT EXISTS (
                               SELECT a.region_cd region_cd
                                 FROM gipi_item e, gipi_polbasic d
                                WHERE d.line_cd = p_line_cd
                                  AND d.subline_cd = p_subline_cd
                                  AND NVL (d.iss_cd, d.iss_cd) = p_iss_cd
                                  AND d.issue_yy = p_issue_yy
                                  AND d.pol_seq_no = p_pol_seq_no
                                  AND d.renew_no = p_renew_no
                                  AND e.item_no = p_item_no
                                  AND e.policy_id = d.policy_id
                                  AND e.region_cd IS NOT NULL
                                  AND d.pol_flag IN ('1', '2', '3', 'X')
                                  AND NVL (d.back_stat, 5) = 2
                                  AND d.endt_seq_no > c.endt_seq_no)
                   ORDER BY c.eff_date DESC)
         LOOP
            v_ves.region_cd := n.region_cd;
            --v_ves.dsp_region_desc := n.region_desc;
            EXIT;
         END LOOP;
      END;

      PIPE ROW (v_ves);
      RETURN;
   END get_witem_ves_endt_details;

   FUNCTION pre_insert_witem_ves (
      p_line_cd       gipi_wpolbas.line_cd%TYPE,
      p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
      p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
      p_item_no       gipi_witem.item_no%TYPE,
      p_currency_cd   gipi_witem.currency_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_curr       NUMBER (2)                    := 0;
      p_eff_date   gipi_polbasic.eff_date%TYPE;
      v_eff_date   gipi_polbasic.eff_date%TYPE;

      CURSOR a (po_eff_date gipi_wpolbas.eff_date%TYPE)
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND NVL (a.endt_expiry_date, a.expiry_date) > po_eff_date
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND b.policy_id = a.policy_id)
         ORDER BY eff_date DESC;

      CURSOR b (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT NVL (ann_tsi_amt, 0) ann_tsi_amt,
                NVL (ann_prem_amt, 0) ann_prem_amt, currency_cd, currency_rt
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
   BEGIN
      FOR i IN (SELECT eff_date
                  FROM gipi_wpolbas
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no)
      LOOP
         v_eff_date := i.eff_date;
      END LOOP;

      FOR a1 IN a (v_eff_date)
      LOOP
         FOR b1 IN b (a1.policy_id)
         LOOP
            IF p_eff_date IS NULL
            THEN
               p_eff_date := a1.eff_date;

               IF p_currency_cd != b1.currency_cd
               THEN
                  v_curr := b1.currency_cd;
               END IF;
            END IF;

            IF a1.eff_date > p_eff_date
            THEN
               p_eff_date := a1.eff_date;

               IF p_currency_cd != b1.currency_cd
               THEN
                  v_curr := b1.currency_cd;
               END IF;
            END IF;
         END LOOP;

         EXIT;
      END LOOP;

      RETURN v_curr;
   END pre_insert_witem_ves;

   FUNCTION check_addtl_info (p_par_id gipi_witem_ves.par_id%TYPE)
      RETURN VARCHAR2
   IS
      p_exist           VARCHAR2 (1)                      := 'Y';
      v_exists          VARCHAR2 (1)                      := 'N';
      v_tag             VARCHAR2 (1)                      := 'N';
      no_vessel_info    VARCHAR2 (50)                     := '';
                                        /* String to store number of items */
                                        /* with no vessel info */
      --v_alert            ALERT;
      v_alert_but       NUMBER;
      v_pack_pol_flag   gipi_wpolbas.pack_pol_flag%TYPE;
      p_no_vess_info    VARCHAR2 (50);

      CURSOR p
      IS
         SELECT a.item_no a_item_no, NVL (b.item_no, 0) b_item_no
           FROM gipi_witem a, gipi_witem_ves b
          WHERE a.par_id = b.par_id(+)
            AND a.item_no = b.item_no(+)
            AND UPPER (a.pack_line_cd) = 'MH'
            AND NVL (a.ann_tsi_amt, 0) = 0
            AND a.par_id = p_par_id;

      CURSOR d
      IS
         SELECT a.item_no a_item_no, NVL (b.item_no, 0) b_item_no
           FROM gipi_witem a, gipi_witem_ves b
          WHERE a.par_id = b.par_id(+)
            AND a.item_no = b.item_no(+)
            AND NVL (a.ann_tsi_amt, 0) = 0
            AND a.par_id = p_par_id;

      CURSOR item
      IS
         SELECT item_no, rec_flag
           FROM gipi_witem
          WHERE par_id = p_par_id;

      CURSOR hull (p_item_no NUMBER)
      IS
         SELECT '1'
           FROM gipi_witem_ves
          WHERE par_id = p_par_id AND item_no = p_item_no;
   BEGIN
      BEGIN
         SELECT pack_pol_flag
           INTO v_pack_pol_flag
           FROM gipi_wpolbas
          WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF v_pack_pol_flag = 'Y'
      THEN
         FOR p1 IN p
         LOOP
            IF p1.a_item_no != p1.b_item_no
            THEN
               no_vessel_info :=
                              no_vessel_info || TO_CHAR (p1.a_item_no)
                              || ', ';
               p_exist := 'N';
            END IF;
         END LOOP;
      ELSE
         FOR a IN item
         LOOP
            v_exists := 'N';

            FOR b IN hull (a.item_no)
            LOOP
               v_exists := 'Y';
            END LOOP;

            IF v_exists = 'N' AND a.rec_flag = 'A'
            THEN
               no_vessel_info := no_vessel_info || TO_CHAR (a.item_no)
                                 || ', ';
               v_tag := 'Y';
            END IF;
         END LOOP;
      END IF;

      IF v_tag = 'Y'
      THEN
         --CLEAR_MESSAGE;
         p_no_vess_info :=
              SUBSTR (no_vessel_info, 1, NVL (LENGTH (no_vessel_info), 0) - 2);
      END IF;

      RETURN p_no_vess_info;
   END check_addtl_info;

   FUNCTION check_update_wpolbas_validity (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_tsi                 gipi_wpolbas.tsi_amt%TYPE            := 0;
      v_ann_tsi             gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_prem                gipi_wpolbas.prem_amt%TYPE           := 0;
      v_ann_prem            gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_ann_tsi2            gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_ann_prem2           gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_prorate             NUMBER (12, 9);
      v_no_of_items         NUMBER;
      v_comp_prem           gipi_wpolbas.prem_amt%TYPE           := 0;
      expired_sw            VARCHAR2 (1)                         := 'N';
      v_exist               VARCHAR2 (1);
      v_line_cd             gipi_wpolbas.line_cd%TYPE;
      v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy            gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no          gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no            gipi_wpolbas.renew_no%TYPE;
      v_eff_date            gipi_wpolbas.eff_date%TYPE;
      v_line_cd2            gipi_parlist.line_cd%TYPE;
      v_endt_expiry_date2   gipi_wpolbas.endt_expiry_date%TYPE;
      v_eff_date2           gipi_wpolbas.eff_date%TYPE;
      v_expiry_date2        gipi_wpolbas.expiry_date%TYPE;
      p_message             VARCHAR2(100) := '';
   BEGIN
      v_endt_expiry_date2 :=
         TO_DATE (NVL (p_endt_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_eff_date2 :=
         TO_DATE (NVL (p_eff_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_expiry_date2 :=
         TO_DATE (NVL (p_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );

      SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
             renew_no, eff_date
        INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no,
             v_renew_no, v_eff_date
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

      SELECT line_cd
        INTO v_line_cd2
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0) * NVL (currency_rt, 1)) tsi,
                        SUM (NVL (prem_amt, 0) * NVL (currency_rt, 1)) prem,
                        COUNT (item_no) no_of_items
                   FROM gipi_witem
                  WHERE par_id = p_par_id)
      LOOP
         v_ann_tsi := v_ann_tsi + a1.tsi;
         v_tsi := v_tsi + a1.tsi;
         v_prem := v_prem + a1.prem;
         v_no_of_items := NVL (a1.no_of_items, 0);

         IF NVL (p_negate_item, 'N') = 'Y'
         THEN
            v_ann_prem := v_ann_prem + a1.prem;
         ELSE

            IF p_prorate_flag = 2
            THEN
               v_ann_prem := v_ann_prem + a1.prem;
            ELSIF p_prorate_flag = 1
            THEN
               IF p_comp_sw = 'Y'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        + 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSIF p_comp_sw = 'M'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        - 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSE
                  v_prorate :=
                       (TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2)
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               END IF;

               IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
               THEN
                  v_prorate := 1;
               END IF;

               v_ann_prem := v_ann_prem + (a1.prem / (v_prorate));
            ELSE
               v_ann_prem :=
                  v_ann_prem
                  + (a1.prem / (NVL (p_short_rt_percent, 1) / 100));
            END IF;
         END IF;
      END LOOP;

      expired_sw := 'N';

      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                              b.expiry_date
                                             ),
                                         b.expiry_date, v_expiry_date2,
                                         b.expiry_date, b.endt_expiry_date
                                        )
                                ) < v_eff_date
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      IF NVL (expired_sw, 'N') = 'N'
      THEN
         v_exist := 'N';

         FOR a2 IN
            (SELECT   b250.ann_tsi_amt ann_tsi, b250.ann_prem_amt ann_prem
                 FROM gipi_wpolbas b, gipi_polbasic b250
                WHERE b.par_id = p_par_id
                  AND b250.line_cd = b.line_cd
                  AND b250.subline_cd = b.subline_cd
                  AND b250.iss_cd = b.iss_cd
                  AND b250.issue_yy = b.issue_yy
                  AND b250.pol_seq_no = b.pol_seq_no
                  AND b250.renew_no = b.renew_no
                  AND b250.pol_flag IN ('1', '2', '3', 'X')
                  AND TRUNC (b250.eff_date) <= TRUNC (b.eff_date)
                  AND (   TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                              b250.expiry_date
                                             ),
                                         b250.expiry_date, v_expiry_date2,
                                         b250.expiry_date, b250.endt_expiry_date
                                        )
                                ) >= v_eff_date
                       OR p_negate_item = 'Y'
                      )
                  AND NVL (b250.endt_seq_no, 0) > 0
             ORDER BY b250.eff_date DESC)
         LOOP
            /*UPDATE gipi_wpolbas
               SET tsi_amt = NVL (v_tsi, 0),
                   prem_amt = NVL (v_prem, 0),
                   ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                   ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                   no_of_items = NVL (v_no_of_items, 0)
             WHERE par_id = p_par_id;*/

            v_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            FOR a2 IN (SELECT   b250.tsi_amt tsi, b250.prem_amt prem,
                                b250.ann_tsi_amt ann_tsi,
                                b250.ann_prem_amt ann_prem
                           FROM gipi_wpolbas b, gipi_polbasic b250
                          WHERE b.par_id = p_par_id
                            AND b250.line_cd = b.line_cd
                            AND b250.subline_cd = b.subline_cd
                            AND b250.iss_cd = b.iss_cd
                            AND b250.issue_yy = b.issue_yy
                            AND b250.pol_seq_no = b.pol_seq_no
                            AND b250.renew_no = b.renew_no
                            AND b250.pol_flag IN ('1', '2', '3', 'X')
                            AND NVL (b250.endt_seq_no, 0) = 0
                       ORDER BY b.eff_date DESC)
            LOOP
               /*UPDATE gipi_wpolbas
                  SET tsi_amt = NVL (v_tsi, 0),
                      prem_amt = NVL (v_prem, 0),
                      ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                      ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                      no_of_items = NVL (v_no_of_items, 0)
                WHERE par_id = p_par_id;*/ NULL;

               EXIT;
            END LOOP;
         END IF;
      ELSE

         FOR a2 IN (SELECT   (c.tsi_amt * a.currency_rt) tsi,
                             (c.prem_amt * a.currency_rt) prem, b.eff_date,
                             b.endt_expiry_date, b.expiry_date,
                             b.prorate_flag, NVL (b.comp_sw, 'N') comp_sw,
                             b.short_rt_percent short_rt, c.peril_cd
                        FROM gipi_item a, gipi_polbasic b, gipi_itmperil c
                       WHERE b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND b.policy_id = a.policy_id
                         AND b.policy_id = c.policy_id
                         AND a.item_no = c.item_no
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (b.eff_date) <=
                                DECODE (NVL (b.endt_seq_no, 0),
                                        0, TRUNC (b.eff_date),
                                        TRUNC (v_eff_date)
                                       )
                         --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                         AND (   TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                     b.expiry_date
                                                    ),
                                                b.expiry_date, v_expiry_date2,
                                                b.expiry_date, b.endt_expiry_date
                                               )
                                       ) >= TRUNC (v_eff_date)
                              OR p_negate_item = 'Y'
                             )
                    ORDER BY b.eff_date DESC)
         LOOP
            v_comp_prem := 0;

            /** rollie 21feb2006
               disallows recomputation of prem if item_no was negated programmatically
            **/
            IF NVL (p_negate_item, 'N') = 'Y'
            THEN
               v_comp_prem := a2.prem;
            ELSE
               IF a2.prorate_flag = 1
               THEN
                  IF a2.endt_expiry_date <= a2.eff_date
                  THEN
                     p_message :=
                           'Your endorsement expiry date is equal to or less than your effectivity date.'
                        || ' Restricted condition.';
                     --RETURN;
                  ELSE
                     IF a2.comp_sw = 'Y'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              + 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSIF a2.comp_sw = 'M'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              - 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSE
                        v_prorate :=
                             (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     END IF;
                  END IF;

                  IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
                  THEN
                     v_prorate := 1;
                  END IF;

                  v_comp_prem := a2.prem / v_prorate;
               ELSIF a2.prorate_flag = 2
               THEN
                  v_comp_prem := a2.prem;
               ELSE
                  v_comp_prem := a2.prem / (a2.short_rt / 100);
               END IF;
            END IF;

            v_ann_prem2 := v_ann_prem2 + v_comp_prem;

            FOR TYPE IN (SELECT peril_type
                           FROM giis_peril
                          WHERE line_cd = v_line_cd2
                                AND peril_cd = a2.peril_cd)
            LOOP
               IF TYPE.peril_type = 'B'
               THEN
                  v_ann_tsi2 := v_ann_tsi2 + a2.tsi;
               END IF;
            END LOOP;
         END LOOP;

         /*UPDATE gipi_wpolbas
            SET tsi_amt = NVL (v_tsi, 0),
                prem_amt = NVL (v_prem, 0),
                ann_tsi_amt = NVL (v_ann_tsi, 0) + NVL (v_ann_tsi2, 0),
                ann_prem_amt = NVL (v_ann_prem, 0) + NVL (v_ann_prem2, 0),
                no_of_items = NVL (v_no_of_items, 0)
          WHERE par_id = p_par_id;*/
          NULL;
      END IF;
      RETURN p_message;
   END;

   PROCEDURE update_wpolbas (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
   )
   IS
      v_tsi                 gipi_wpolbas.tsi_amt%TYPE            := 0;
      v_ann_tsi             gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_prem                gipi_wpolbas.prem_amt%TYPE           := 0;
      v_ann_prem            gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_ann_tsi2            gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_ann_prem2           gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_prorate             NUMBER (12, 9);
      v_no_of_items         NUMBER;
      v_comp_prem           gipi_wpolbas.prem_amt%TYPE           := 0;
      expired_sw            VARCHAR2 (1)                         := 'N';
      v_exist               VARCHAR2 (1);
      v_line_cd             gipi_wpolbas.line_cd%TYPE;
      v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy            gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no          gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no            gipi_wpolbas.renew_no%TYPE;
      v_eff_date            gipi_wpolbas.eff_date%TYPE;
      v_line_cd2            gipi_parlist.line_cd%TYPE;
      v_endt_expiry_date2   gipi_wpolbas.endt_expiry_date%TYPE;
      v_eff_date2           gipi_wpolbas.eff_date%TYPE;
      v_expiry_date2        gipi_wpolbas.expiry_date%TYPE;
   BEGIN
      v_endt_expiry_date2 :=
         TO_DATE (NVL (p_endt_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_eff_date2 :=
         TO_DATE (NVL (p_eff_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_expiry_date2 :=
         TO_DATE (NVL (p_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );

      SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
             renew_no, eff_date
        INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no,
             v_renew_no, v_eff_date
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

      SELECT line_cd
        INTO v_line_cd2
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0) * NVL (currency_rt, 1)) tsi,
                        SUM (NVL (prem_amt, 0) * NVL (currency_rt, 1)) prem,
                        COUNT (item_no) no_of_items
                   FROM gipi_witem
                  WHERE par_id = p_par_id)
      LOOP
         v_ann_tsi := v_ann_tsi + a1.tsi;
         v_tsi := v_tsi + a1.tsi;
         v_prem := v_prem + a1.prem;
         v_no_of_items := NVL (a1.no_of_items, 0);

         IF NVL (p_negate_item, 'N') = 'Y'
         THEN
            v_ann_prem := v_ann_prem + a1.prem;
         ELSE

            IF p_prorate_flag = 2
            THEN
               v_ann_prem := v_ann_prem + a1.prem;
            ELSIF p_prorate_flag = 1
            THEN
               IF p_comp_sw = 'Y'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        + 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSIF p_comp_sw = 'M'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        - 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSE
                  v_prorate :=
                       (TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2)
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               END IF;

               IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
               THEN
                  v_prorate := 1;
               END IF;

               v_ann_prem := v_ann_prem + (a1.prem / (v_prorate));
            ELSE
               v_ann_prem :=
                  v_ann_prem
                  + (a1.prem / (NVL (p_short_rt_percent, 1) / 100));
            END IF;
         END IF;
      END LOOP;

      expired_sw := 'N';

      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                              b.expiry_date
                                             ),
                                         b.expiry_date, v_expiry_date2,
                                         b.expiry_date, b.endt_expiry_date
                                        )
                                ) < v_eff_date
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      IF NVL (expired_sw, 'N') = 'N'
      THEN
         v_exist := 'N';

         FOR a2 IN
            (SELECT   b250.ann_tsi_amt ann_tsi, b250.ann_prem_amt ann_prem
                 FROM gipi_wpolbas b, gipi_polbasic b250
                WHERE b.par_id = p_par_id
                  AND b250.line_cd = b.line_cd
                  AND b250.subline_cd = b.subline_cd
                  AND b250.iss_cd = b.iss_cd
                  AND b250.issue_yy = b.issue_yy
                  AND b250.pol_seq_no = b.pol_seq_no
                  AND b250.renew_no = b.renew_no
                  AND b250.pol_flag IN ('1', '2', '3', 'X')
                  AND TRUNC (b250.eff_date) <= TRUNC (b.eff_date)
                  AND (   TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                              b250.expiry_date
                                             ),
                                         b250.expiry_date, v_expiry_date2,
                                         b250.expiry_date, b250.endt_expiry_date
                                        )
                                ) >= v_eff_date
                       OR p_negate_item = 'Y'
                      )
                  AND NVL (b250.endt_seq_no, 0) > 0
             ORDER BY b250.eff_date DESC)
         LOOP
            UPDATE gipi_wpolbas
               SET tsi_amt = NVL (v_tsi, 0),
                   prem_amt = NVL (v_prem, 0),
                   ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                   ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                   no_of_items = NVL (v_no_of_items, 0)
             WHERE par_id = p_par_id;

            v_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            FOR a2 IN (SELECT   b250.tsi_amt tsi, b250.prem_amt prem,
                                b250.ann_tsi_amt ann_tsi,
                                b250.ann_prem_amt ann_prem
                           FROM gipi_wpolbas b, gipi_polbasic b250
                          WHERE b.par_id = p_par_id
                            AND b250.line_cd = b.line_cd
                            AND b250.subline_cd = b.subline_cd
                            AND b250.iss_cd = b.iss_cd
                            AND b250.issue_yy = b.issue_yy
                            AND b250.pol_seq_no = b.pol_seq_no
                            AND b250.renew_no = b.renew_no
                            AND b250.pol_flag IN ('1', '2', '3', 'X')
                            AND NVL (b250.endt_seq_no, 0) = 0
                       ORDER BY b.eff_date DESC)
            LOOP
               UPDATE gipi_wpolbas
                  SET tsi_amt = NVL (v_tsi, 0),
                      prem_amt = NVL (v_prem, 0),
                      ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                      ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                      no_of_items = NVL (v_no_of_items, 0)
                WHERE par_id = p_par_id;

               EXIT;
            END LOOP;
         END IF;
      ELSE

         FOR a2 IN (SELECT   (c.tsi_amt * a.currency_rt) tsi,
                             (c.prem_amt * a.currency_rt) prem, b.eff_date,
                             b.endt_expiry_date, b.expiry_date,
                             b.prorate_flag, NVL (b.comp_sw, 'N') comp_sw,
                             b.short_rt_percent short_rt, c.peril_cd
                        FROM gipi_item a, gipi_polbasic b, gipi_itmperil c
                       WHERE b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND b.policy_id = a.policy_id
                         AND b.policy_id = c.policy_id
                         AND a.item_no = c.item_no
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (b.eff_date) <=
                                DECODE (NVL (b.endt_seq_no, 0),
                                        0, TRUNC (b.eff_date),
                                        TRUNC (v_eff_date)
                                       )
                         --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                         AND (   TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                     b.expiry_date
                                                    ),
                                                b.expiry_date, v_expiry_date2,
                                                b.expiry_date, b.endt_expiry_date
                                               )
                                       ) >= TRUNC (v_eff_date)
                              OR p_negate_item = 'Y'
                             )
                    ORDER BY b.eff_date DESC)
         LOOP
            v_comp_prem := 0;

            /** rollie 21feb2006
               disallows recomputation of prem if item_no was negated programmatically
            **/
            IF NVL (p_negate_item, 'N') = 'Y'
            THEN
               v_comp_prem := a2.prem;
            ELSE
               IF a2.prorate_flag = 1
               THEN
                  IF a2.endt_expiry_date <= a2.eff_date
                  THEN
                     --p_message :=
                           --'Your endorsement expiry date is equal to or less than your effectivity date.'
                        --|| ' Restricted condition.';
                     --RETURN;
                     NULL;
                  ELSE
                     IF a2.comp_sw = 'Y'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              + 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSIF a2.comp_sw = 'M'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              - 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSE
                        v_prorate :=
                             (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     END IF;
                  END IF;

                  IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
                  THEN
                     v_prorate := 1;
                  END IF;

                  v_comp_prem := a2.prem / v_prorate;
               ELSIF a2.prorate_flag = 2
               THEN
                  v_comp_prem := a2.prem;
               ELSE
                  v_comp_prem := a2.prem / (a2.short_rt / 100);
               END IF;
            END IF;

            v_ann_prem2 := v_ann_prem2 + v_comp_prem;

            FOR TYPE IN (SELECT peril_type
                           FROM giis_peril
                          WHERE line_cd = v_line_cd2
                                AND peril_cd = a2.peril_cd)
            LOOP
               IF TYPE.peril_type = 'B'
               THEN
                  v_ann_tsi2 := v_ann_tsi2 + a2.tsi;
               END IF;
            END LOOP;
         END LOOP;

         UPDATE gipi_wpolbas
            SET tsi_amt = NVL (v_tsi, 0),
                prem_amt = NVL (v_prem, 0),
                ann_tsi_amt = NVL (v_ann_tsi, 0) + NVL (v_ann_tsi2, 0),
                ann_prem_amt = NVL (v_ann_prem, 0) + NVL (v_ann_prem2, 0),
                no_of_items = NVL (v_no_of_items, 0)
          WHERE par_id = p_par_id;
          NULL;
      END IF;
   END;


   /*    Date        Author            Description
   **    ==========    ===============    ============================
   **    03.04.2011    d.alcantara        retrieves records fro gipi_witem_ves based on given parameters
   **    10.20.2011    mark jm            modified sql statement by adding decode to propel_sw
   */
   FUNCTION get_gipi_witem_ves1(p_par_id    GIPI_WITEM.par_id%TYPE,
                                p_item_no   GIPI_WITEM.item_no %TYPE)
   RETURN gipi_witem_ves_par_tab PIPELINED
   IS
    v_ves       GIPI_WITEM_VES_PAR_TYPE;
   BEGIN
           /*
           **  Created by    : D.Alcantara
           **  Date Created  : 03.04.2011
           **  Reference By  : (GIPIS009 - Marine Hull Item Info)
           **  Description   : This function retrieves records fro gipi_witem_ves
           **                   based on the par_id and item_no
           **  Modified by     : mark jm 12.01.2011
           **  Description
           */
        FOR i IN (
            SELECT a.par_id, a.item_no,
                   a.vessel_cd, b.vessel_flag,
                   b.vessel_name, b.vessel_old_name,
                   c.vestype_desc, decode(b.propel_sw,'S','SELF-PROPELLED','NON-PROPELLED') propel_sw ,
                   d.vess_class_desc, e.hull_desc,
                   b.reg_owner, b.reg_place,
                   b.gross_ton, b.year_built,
                   b.net_ton, b.no_crew,
                   b.deadweight, b.crew_nat,
                   b.vessel_length, b.vessel_breadth,
                   b.vessel_depth, a.dry_place,
                   TO_CHAR (a.dry_date, 'mm-dd-yyyy') dry_date, a.deduct_text,
                   a.rec_flag, a.geog_limit
            FROM gipi_witem_ves a,
                   giis_vessel b,
                   giis_vestype c,
                   giis_vess_class d,
                   giis_hull_type e
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.vessel_cd = b.vessel_cd
               AND b.vestype_cd = c.vestype_cd
               AND b.vess_class_cd = d.vess_class_cd
               AND b.hull_type_cd = e.hull_type_cd)
        LOOP
           v_ves.par_id                   := i.par_id;
            v_ves.item_no                  := i.item_no;
            v_ves.vessel_cd                := i.vessel_cd;
            v_ves.vessel_flag              := i.vessel_flag;
            v_ves.vessel_name              := i.vessel_name;
            v_ves.vessel_old_name          := i.vessel_old_name;
            v_ves.vestype_desc             := i.vestype_desc;
            v_ves.propel_sw                := i.propel_sw;
            v_ves.vess_class_desc          := i.vess_class_desc;
            v_ves.hull_desc                := i.hull_desc;
            v_ves.reg_owner                := i.reg_owner;
            v_ves.reg_place                := i.reg_place;
            v_ves.gross_ton                := i.gross_ton;
            v_ves.year_built               := i.year_built;
            v_ves.net_ton                  := i.net_ton;
            v_ves.no_crew                  := i.no_crew;
            v_ves.deadweight               := i.deadweight;
            v_ves.crew_nat                 := i.crew_nat;
            v_ves.vessel_length            := i.vessel_length;
            v_ves.vessel_breadth           := i.vessel_breadth;
            v_ves.vessel_depth             := i.vessel_depth;
            v_ves.dry_place                := i.dry_place;
            v_ves.dry_date                 := i.dry_date;
            v_ves.rec_flag                 := i.rec_flag;
            v_ves.deduct_text              := i.deduct_text;
            v_ves.geog_limit               := i.geog_limit;

          /*  SELECT COUNT (peril_cd)
           INTO v_witem_ves.no_of_itemperils
           FROM gipi_witmperl
          WHERE par_id = p_par_id AND item_no = p_item_no;*/

            PIPE ROW(v_ves);
        END LOOP;

        RETURN;
   END get_gipi_witem_ves1;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve rows from gipi_witem_ves based on the given parameters
    */
    FUNCTION get_gipi_witem_ves_pack_pol (
        p_par_id IN gipi_witem_ves.par_id%TYPE,
        p_item_no IN gipi_witem_ves.item_no%TYPE)
    RETURN gipi_witem_ves_par_tab PIPELINED
    IS
        v_witem_ves gipi_witem_ves_par_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_witem_ves
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_witem_ves.par_id     := i.par_id;
            v_witem_ves.item_no    := i.item_no;

            PIPE ROW(v_witem_ves);
        END LOOP;

        RETURN;
    END get_gipi_witem_ves_pack_pol;
END gipi_witem_ves_pkg;
/


