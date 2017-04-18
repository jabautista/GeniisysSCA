CREATE OR REPLACE PACKAGE BODY CPI.gipi_item_pkg
AS
/*
**  Created by   : Menandro G.C. Robes
**  Date Created : August 10, 2010
**  Reference By : (GIPIS068 - Endorsement Marine Cargo Item Information)
**  Description  : Function to retrieve marine cargo item records of policy.
*/
   FUNCTION get_gipi_item (
      p_policy_id    gipi_polbasic.policy_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_item   gipi_item_type;
   BEGIN
--    FOR i IN (
--      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date, expiry_date
--        FROM gipi_wpolbas
--       WHERE par_id = p_par_id)
--    LOOP
      FOR j IN (
--          SELECT b.item_no,     b.item_title,  b.ann_tsi_amt, b.ann_prem_amt,
--                 b.currency_cd, b.currency_rt, b.policy_id,   b.group_cd,
--                 b.region_cd,   b.rec_flag
--            FROM gipi_polbasic a,      -- table which will identify latest endorsement
--                 gipi_item     b       -- table which will identify item being endorsed=
--           WHERE a.line_cd      = i.line_cd
--             AND a.subline_cd   = i.subline_cd
--             AND a.iss_cd       = i.iss_cd
--             AND a.issue_yy     = i.issue_yy
--             AND a.pol_seq_no   = i.pol_seq_no
--             AND a.renew_no     = i.renew_no
--             AND a.policy_id    = b.policy_id
--             AND a.pol_flag IN ('1', '2', '3', 'X')
--             AND TRUNC (a.eff_date) <= DECODE (NVL (a.endt_seq_no, 0), 0,
--                                                            TRUNC (a.eff_date),
--                                                            TRUNC (i.eff_date))
--             AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date), a.expiry_date,
--                                                                         i.expiry_date,
--                                                                         a.endt_expiry_date))
--                 >= TRUNC (i.eff_date)
--          ORDER BY a.eff_date DESC
                SELECT b.item_no, b.item_title, b.item_desc, b.item_desc2,
                       b.ann_tsi_amt, b.ann_prem_amt, b.currency_cd,
                       b.currency_rt, b.policy_id, b.group_cd, b.region_cd,
                       b.rec_flag, c.currency_desc, b.from_date, b.TO_DATE,
                       b.item_grp
                  FROM gipi_item b, gipi_polbasic a, giis_currency c
                 WHERE a.policy_id = p_policy_id
                   AND a.policy_id = b.policy_id
                   AND b.currency_cd = c.main_currency_cd
                   AND a.endt_seq_no =
                          (SELECT   MAX (a2.endt_seq_no)
                               FROM gipi_polbasic a2, gipi_item b2
                              WHERE a2.line_cd = p_line_cd
                                AND a2.subline_cd = p_subline_cd
                                AND a2.iss_cd = p_iss_cd
                                AND a2.issue_yy = p_issue_yy
                                AND a2.pol_seq_no = p_pol_seq_no
                                AND a2.renew_no = p_renew_no
                                AND a2.policy_id = b2.policy_id
                                AND b2.item_no = b.item_no
                           GROUP BY b2.item_no))
      LOOP
         v_item.policy_id := j.policy_id;
         v_item.item_no := j.item_no;
         v_item.item_title := j.item_title;
         v_item.item_desc := j.item_desc;
         v_item.item_desc2 := j.item_desc2;
         v_item.item_grp := j.item_grp;
         v_item.ann_tsi_amt := j.ann_tsi_amt;
         v_item.ann_prem_amt := j.ann_prem_amt;
         v_item.currency_cd := j.currency_cd;
         v_item.currency_rt := j.currency_rt;
         v_item.group_cd := j.group_cd;
         v_item.region_cd := j.region_cd;
         v_item.rec_flag := j.rec_flag;
         v_item.currency_desc := j.currency_desc;
         v_item.from_date := j.from_date;
         v_item.TO_DATE := j.TO_DATE;
         PIPE ROW (v_item);
      END LOOP;

      RETURN;
--    END LOOP;
   END get_gipi_item;

   FUNCTION get_gipi_item_rep (              --Created By:  Alfred  03/10/2011
      p_policy_id   gipi_item.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN gipi_item_rep_tab PIPELINED
   IS
      v_gipi_item_rep   gipi_item_rep_type;
   BEGIN
      FOR i IN (SELECT b170.policy_id policy_id1, b170.item_no item_no,
                       b170.currency_rt, b170.from_date, b170.TO_DATE,
                       a.tsi_amt, a.prem_amt, a.peril_cd,
                       d.peril_sname peril_sname,
                       b.param_value_v pl_param_val
                  FROM gipi_item b170,
                       gipi_itmperil a,
                       giis_parameters b,
                       giis_peril d
                 WHERE b.param_name = 'PASSENGER LIABILITY'
                   AND b170.policy_id = a.policy_id
                   AND b170.item_no = a.item_no
                   AND a.line_cd = d.line_cd
                   AND a.peril_cd = d.peril_cd
                   AND d.peril_sname = b.param_value_v
                   AND b170.policy_id = p_policy_id
                   AND b170.item_no = p_item_no)
      LOOP
         v_gipi_item_rep.policy_id := i.policy_id1;
         v_gipi_item_rep.item_no := i.item_no;
         v_gipi_item_rep.currency_rt := i.currency_rt;
         v_gipi_item_rep.from_date := i.from_date;
         v_gipi_item_rep.TO_DATE := i.TO_DATE;
         v_gipi_item_rep.tsi_amt := i.tsi_amt;
         v_gipi_item_rep.prem_amt := i.prem_amt;
         v_gipi_item_rep.peril_cd := i.peril_cd;
         v_gipi_item_rep.peril_sname := i.peril_sname;
         v_gipi_item_rep.param_value_v := i.pl_param_val;
         PIPE ROW (v_gipi_item_rep);
      END LOOP;

      RETURN;
   END get_gipi_item_rep;

   FUNCTION get_gipi_item_rep2 (             --Created By:  Alfred  03/10/2011
      p_policy_id   gipi_item.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN gipi_item_rep_tab PIPELINED
   IS
      v_gipi_item_rep   gipi_item_rep_type;
   BEGIN
      FOR i IN (SELECT b170.policy_id policy_id1, b170.item_no item_no,
                       b170.currency_rt, b170.from_date, b170.TO_DATE,
                       a.tsi_amt, a.prem_amt, a.peril_cd,
                       d.peril_sname peril_sname,
                       c.param_value_v ctpl_param_val
                  FROM gipi_item b170,
                       gipi_itmperil a,
                       giis_parameters c,
                       giis_peril d
                 WHERE c.param_name = 'COMPULSORY DEATH/BI'
                   AND b170.policy_id = a.policy_id
                   AND b170.item_no = a.item_no
                   AND a.line_cd = d.line_cd
                   AND a.peril_cd = d.peril_cd
                   AND d.peril_sname = c.param_value_v
                   AND b170.policy_id = p_policy_id
                   AND b170.item_no = p_item_no)
      LOOP
         v_gipi_item_rep.policy_id := i.policy_id1;
         v_gipi_item_rep.item_no := i.item_no;
         v_gipi_item_rep.currency_rt := i.currency_rt;
         v_gipi_item_rep.from_date := i.from_date;
         v_gipi_item_rep.TO_DATE := i.TO_DATE;
         v_gipi_item_rep.tsi_amt := i.tsi_amt;
         v_gipi_item_rep.prem_amt := i.prem_amt;
         v_gipi_item_rep.peril_cd := i.peril_cd;
         v_gipi_item_rep.peril_sname := i.peril_sname;
         v_gipi_item_rep.param_value_v := i.ctpl_param_val;
         v_gipi_item_rep.cf_print_tsi := cf_print_tsi ();
         PIPE ROW (v_gipi_item_rep);
      END LOOP;

      RETURN;
   END get_gipi_item_rep2;

   /*
   **  Created by   : Moses Calma
   **  Date Created : March 22, 2011
   **  Reference By : (GIPIS100 - Policy Information)
   **  Description  : Retrieves list of items of a given policy
   */
   FUNCTION get_related_item_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_related_item_info_tab PIPELINED
   IS
      v_item_info       gipi_related_item_info_type;
      v_iss_cd          gipi_polbasic.iss_cd%TYPE;
      v_pol_iss_cd      gipi_polbasic.iss_cd%TYPE;
      v_menu_line_cd    giis_line.menu_line_cd%TYPE;
      v_menu_line_cd2   giis_line.menu_line_cd%TYPE;
      v_pack_pol_flag   gipi_polbasic.pack_pol_flag%TYPE;
      v_line_ac         giis_parameters.param_value_v%TYPE;
      v_line_av         giis_parameters.param_value_v%TYPE;
      v_line_ca         giis_parameters.param_value_v%TYPE;
      v_line_en         giis_parameters.param_value_v%TYPE;
      v_line_fi         giis_parameters.param_value_v%TYPE;
      v_line_mc         giis_parameters.param_value_v%TYPE;
      v_line_mh         giis_parameters.param_value_v%TYPE;
      v_line_mn         giis_parameters.param_value_v%TYPE;
      v_line_su         giis_parameters.param_value_v%TYPE;
      v_line_cd         gipi_polbasic.line_cd%TYPE;
      v_pol_line_cd     gipi_polbasic.line_cd%TYPE;
   BEGIN
      SELECT pack_pol_flag, line_cd, iss_cd
        INTO v_pack_pol_flag, v_pol_line_cd, v_pol_iss_cd
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id;

      BEGIN
         SELECT a.param_value_v a, b.param_value_v b, c.param_value_v c,
                d.param_value_v d, e.param_value_v e, f.param_value_v f,
                g.param_value_v g, h.param_value_v h, i.param_value_v i
           INTO v_line_ac, v_line_av, v_line_ca,
                v_line_en, v_line_fi, v_line_mc,
                v_line_mh, v_line_mn, v_line_su
           FROM giis_parameters a,
                giis_parameters b,
                giis_parameters c,
                giis_parameters d,
                giis_parameters e,
                giis_parameters f,
                giis_parameters g,
                giis_parameters h,
                giis_parameters i
          WHERE a.param_name = 'LINE_CODE_AC'
            AND b.param_name = 'LINE_CODE_AV'
            AND c.param_name = 'LINE_CODE_CA'
            AND d.param_name = 'LINE_CODE_EN'
            AND e.param_name = 'LINE_CODE_FI'
            AND f.param_name = 'LINE_CODE_MC'
            AND g.param_name = 'LINE_CODE_MH'
            AND h.param_name = 'LINE_CODE_MN'
            AND i.param_name = 'LINE_CODE_SU';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_line_ac := 'AC';
            v_line_av := 'AV';
            v_line_ca := 'CA';
            v_line_en := 'EN';
            v_line_fi := 'FI';
            v_line_mc := 'MC';
            v_line_mh := 'MH';
            v_line_mn := 'MN';
            v_line_su := 'SU';
      END;

      SELECT param_value_v
        INTO v_iss_cd
        FROM giis_parameters
       WHERE param_name = 'ISS_CD_RI';

      SELECT menu_line_cd
        INTO v_menu_line_cd
        FROM giis_line
       WHERE line_cd = v_pol_line_cd;

      FOR i IN (SELECT a.item_no, a.item_title, a.item_desc, a.item_desc2,
                       a.currency_rt, a.pack_line_cd, a.pack_subline_cd,
                       a.surcharge_sw, a.discount_sw, a.tsi_amt, a.prem_amt,
                       b.currency_desc, c.coverage_desc, a.policy_id,
                       a.item_grp, a.ann_prem_amt, a.ann_tsi_amt,
                       a.other_info
                  FROM gipi_item a, giis_currency b, giis_coverage c
                 WHERE a.currency_cd = b.main_currency_cd(+)
                   AND a.coverage_cd = c.coverage_cd(+)
                   AND a.policy_id = NVL (p_policy_id, policy_id)
              ORDER BY a.item_no) --modified by pol cruz 01.09.2015 - added order by
      LOOP
         v_item_info.policy_id := i.policy_id;
         v_item_info.item_no := i.item_no;
         v_item_info.item_grp := i.item_grp;
         v_item_info.item_title := i.item_title;
         v_item_info.item_desc := i.item_desc;
         v_item_info.item_desc2 := i.item_desc2;
         v_item_info.currency_rt := i.currency_rt;
         v_item_info.pack_line_cd := i.pack_line_cd;
         v_item_info.pack_subline_cd := i.pack_subline_cd;
         v_item_info.surcharge_sw := i.surcharge_sw;
         v_item_info.discount_sw := i.discount_sw;
         v_item_info.tsi_amt := i.tsi_amt;
         v_item_info.prem_amt := i.prem_amt;
         v_item_info.currency_desc := i.currency_desc;
         v_item_info.coverage_desc := i.coverage_desc;
         v_item_info.ann_tsi_amt := i.ann_tsi_amt;
         v_item_info.ann_prem_amt := i.ann_prem_amt;
         v_item_info.other_info := i.other_info;
         v_item_info.pack_pol_flag := v_pack_pol_flag;

         IF v_pack_pol_flag = 'Y'
         THEN
            v_line_cd := i.pack_line_cd;
         ELSE
            v_line_cd := v_pol_line_cd;
         END IF;

         IF v_pol_iss_cd = v_iss_cd
         THEN
            v_item_info.peril_view_type := 'riPeril';
         ELSE
            IF v_line_cd = v_line_fi OR v_menu_line_cd = 'FI'
            THEN
               v_item_info.peril_view_type := 'fiPeril';
            ELSIF v_line_cd = v_line_mn OR v_menu_line_cd = 'MN'
            THEN
               v_item_info.peril_view_type := 'mnPeril';
            ELSE
               v_item_info.peril_view_type := 'otherPeril';
            END IF;
         END IF;

         SELECT menu_line_cd
           INTO v_menu_line_cd2
           FROM giis_line
          WHERE line_cd = v_line_cd;

         IF v_line_cd = v_line_mc OR v_menu_line_cd2 = 'MC'
         THEN
            v_item_info.item_type := 'mcType';
         ELSIF v_line_cd = v_line_ac OR v_menu_line_cd2 = 'AC'
         THEN
            v_item_info.item_type := 'acType';
         ELSIF v_line_cd = v_line_av OR v_menu_line_cd2 = 'AV'
         THEN
            v_item_info.item_type := 'avType';
         ELSIF v_line_cd = v_line_ca OR v_menu_line_cd2 = 'CA'
         THEN
            v_item_info.item_type := 'caType';
         ELSIF v_line_cd = v_line_en OR v_menu_line_cd2 = 'EN'
         THEN
            v_item_info.item_type := 'enType';
         ELSIF v_line_cd = v_line_mn OR v_menu_line_cd2 = 'MN'
         THEN
            v_item_info.item_type := 'mnType';
         ELSIF v_line_cd = v_line_mh OR v_menu_line_cd2 = 'MH'
         THEN
            v_item_info.item_type := 'mhType';
         ELSIF v_line_cd = v_line_fi OR v_menu_line_cd2 = 'FI'
         THEN
            v_item_info.item_type := 'fiType';
         ELSE
            v_item_info.item_type := '';
         END IF;

         PIPE ROW (v_item_info);
      END LOOP;
   END get_related_item_info;

   /*
   **  Created by   : Veronica V. Raymundo
   **  Date Created : July 20, 2011
   **  Reference By : (GIPIS096 - Package Endt Policy Items)
   **  Description  : Retrieves list of items of a given policy
   */
   FUNCTION get_pack_policy_items (
      p_line_cd       IN   gipi_pack_wpolbas.line_cd%TYPE,
      p_iss_cd        IN   gipi_pack_wpolbas.iss_cd%TYPE,
      p_subline_cd    IN   gipi_pack_wpolbas.subline_cd%TYPE,
      p_issue_yy      IN   gipi_pack_wpolbas.issue_yy%TYPE,
      p_pol_seq_no    IN   gipi_pack_wpolbas.pol_seq_no%TYPE,
      p_renew_no      IN   gipi_pack_wpolbas.renew_no%TYPE,
      p_eff_date      IN   gipi_pack_wpolbas.eff_date%TYPE,
      p_expiry_date   IN   gipi_pack_wpolbas.expiry_date%TYPE
   )
      RETURN pack_policy_items_tab PIPELINED
   IS
      v_pol_items   pack_policy_items_type;
   BEGIN
      FOR i IN
         (SELECT   policy_id, item_no, item_title, item_desc, item_desc2,
                   currency_cd, currency_rt, pack_line_cd, pack_subline_cd
              FROM gipi_item
             WHERE policy_id || '-' || item_no IN (
                      SELECT DISTINCT b.policy_id || '-' || b.item_no
                                 FROM gipi_item b,
                                      gipi_polbasic a,
                                      gipi_pack_polbasic c
                                WHERE c.line_cd = p_line_cd
                                  AND c.iss_cd = p_iss_cd
                                  AND c.subline_cd = p_subline_cd
                                  AND c.issue_yy = p_issue_yy
                                  AND c.pol_seq_no = p_pol_seq_no
                                  AND c.renew_no = p_renew_no
                                  AND c.pol_flag IN ('1', '2', '3', 'X')
                                  AND a.pack_policy_id = c.pack_policy_id
                                  AND b.policy_id = a.policy_id
                                  AND TRUNC (c.eff_date) <=
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
                                  AND a.endt_seq_no =
                                         (SELECT MAX (x.endt_seq_no)
                                            FROM gipi_item y,
                                                 gipi_polbasic x,
                                                 gipi_pack_polbasic z
                                           WHERE z.line_cd = p_line_cd
                                             AND z.iss_cd = p_iss_cd
                                             AND z.subline_cd = p_subline_cd
                                             AND z.issue_yy = p_issue_yy
                                             AND z.pol_seq_no = p_pol_seq_no
                                             AND z.renew_no = p_renew_no
                                             AND z.pol_flag IN
                                                         ('1', '2', '3', 'X')
                                             AND x.pack_policy_id =
                                                              z.pack_policy_id
                                             AND y.policy_id = x.policy_id
                                             AND y.item_no = b.item_no
                                             AND TRUNC (z.eff_date) <=
                                                    DECODE
                                                         (NVL (z.endt_seq_no,
                                                               0
                                                              ),
                                                          0, TRUNC (z.eff_date),
                                                          TRUNC (p_eff_date)
                                                         )
                                             AND TRUNC
                                                    (DECODE
                                                        (NVL
                                                            (z.endt_expiry_date,
                                                             z.expiry_date
                                                            ),
                                                         z.expiry_date, p_expiry_date,
                                                         z.endt_expiry_date
                                                        )
                                                    ) >= TRUNC (p_eff_date)))
          ORDER BY item_no, pack_line_cd, pack_subline_cd)
      LOOP
         v_pol_items.policy_id := i.policy_id;
         v_pol_items.item_no := i.item_no;
         v_pol_items.item_title := i.item_title;
         v_pol_items.item_desc := i.item_desc;
         v_pol_items.item_desc2 := i.item_desc2;
         v_pol_items.currency_cd := i.currency_cd;
         v_pol_items.currency_rt := i.currency_rt;
         v_pol_items.pack_line_cd := i.pack_line_cd;
         v_pol_items.pack_subline_cd := i.pack_subline_cd;
         PIPE ROW (v_pol_items);
      END LOOP;
   END get_pack_policy_items;

   /**
   * Rey Jadlocon
   * 08.02.2011
   * item group list Bill Group
   **/
   FUNCTION get_item_group_list (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN item_group_list_tab PIPELINED
   IS
      v_item_group_list   item_group_list_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT DISTINCT a.policy_id, a.item_grp, a.tsi_amt,
                                        a.ann_prem_amt, a.ann_tsi_amt,
                                        a.currency_rt, b.currency_desc
                                   FROM gipi_item a, giis_currency b
                                  WHERE a.currency_cd = b.main_currency_cd
                                    AND a.policy_id = p_policy_id))
      LOOP
         v_item_group_list.policy_id := i.policy_id;
         v_item_group_list.item_grp := i.item_grp;
         v_item_group_list.tsi_amt := i.tsi_amt;
         v_item_group_list.ann_prem_amt := i.ann_prem_amt;
         v_item_group_list.ann_tsi_amt := i.ann_tsi_amt;
         v_item_group_list.currency_rt := i.currency_rt;
         v_item_group_list.currency_desc := i.currency_desc;
         PIPE ROW (v_item_group_list);
      END LOOP;

      RETURN;
   END get_item_group_list;

    /*
   **  Created by      : Niknok
   **  Date Created    : 08.31.2011
   **  Reference By    : (GICLS015 - Claims Fire Item Info)
   **  Description     : check if item no. exist
   */
   FUNCTION check_existing_item (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR h IN
         (SELECT c.item_no
            FROM gipi_item c, gipi_polbasic b
           WHERE                   --:control.claim_id = :global.claim_id AND
                 p_line_cd = b.line_cd
             AND p_subline_cd = b.subline_cd
             AND p_pol_iss_cd = b.iss_cd
             AND p_issue_yy = b.issue_yy
             AND p_pol_seq_no = b.pol_seq_no
             AND p_renew_no = b.renew_no
             AND b.policy_id = c.policy_id
             AND b.pol_flag IN ('1', '2', '3', 'X')
             AND TRUNC (DECODE (TRUNC (b.eff_date),
                                TRUNC (b.incept_date), p_pol_eff_date,
                                b.eff_date
                               )
                       ) <= p_loss_date
             --AND TRUNC(b.eff_date) <= :control.loss_date
             AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                b.expiry_date, p_expiry_date,
                                b.endt_expiry_date
                               )
                       ) >= p_loss_date
             AND c.item_no = p_item_no)
      LOOP
         v_exist := 1;
      END LOOP;

      RETURN v_exist;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2011
   **  Reference By : claims item info - iten no LOV
   **  Description  : getting item no LOV
   */
   FUNCTION get_item_no_list (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                          get_latest_item_title (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (DECODE (TRUNC (NVL (b.from_date, eff_date)),
                                         TRUNC (a.incept_date), NVL
                                                               (b.from_date,
                                                                p_pol_eff_date
                                                               ),
                                         NVL (b.from_date, a.eff_date)
                                        )
                                ) <= TRUNC(p_loss_date)
                      AND TRUNC (DECODE (NVL (b.TO_DATE,
                                              NVL (a.endt_expiry_date,
                                                   a.expiry_date
                                                  )
                                             ),
                                         a.expiry_date, NVL (b.TO_DATE,
                                                             p_expiry_date
                                                            ),
                                         NVL (b.TO_DATE, a.endt_expiry_date)
                                        )
                                ) >= TRUNC(p_loss_date)
                      AND a.policy_id = b.policy_id)
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2011
   **  Reference By : claims item info - iten no LOV
   **  Description  : getting item no LOV
   */
   FUNCTION get_item_no_list_mc (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_find_text      varchar2
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                get_latest_item_title (P_line_cd,
                                       P_subline_cd,
                                       P_pol_iss_cd,
                                       P_issue_yy,
                                       P_pol_seq_no,
                                       P_renew_no,
                                       item_no,
                                       P_loss_date,
                                       P_pol_eff_date,
                                       P_expiry_date
                                      ) item_title
           FROM gipi_item b
          WHERE 1 = 1
            AND EXISTS (
                   SELECT 1
                     FROM gipi_polbasic
                    WHERE line_cd = P_line_cd
                      AND subline_cd = P_subline_cd
                      AND iss_cd = P_pol_iss_cd
                      AND issue_yy = P_issue_yy
                      AND pol_seq_no = P_pol_seq_no
                      AND renew_no = P_renew_no
                      AND pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (DECODE (TRUNC (eff_date),
                                         TRUNC (incept_date), P_pol_eff_date,
                                         eff_date
                                        )
                                ) <= TRUNC (P_loss_date)
                      AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
                                         expiry_date, P_expiry_date,
                                         endt_expiry_date
                                        )
                                ) >= TRUNC (P_loss_date)
                      AND policy_id = b.policy_id)
            AND NOT EXISTS (
                      SELECT 1
                        FROM gicl_motor_car_dtl
                       WHERE claim_id = P_claim_id
                             AND item_no = b.item_no)
            AND EXISTS (
                   SELECT 1
                     FROM gipi_vehicle c
                    WHERE item_no = b.item_no
                      AND policy_id = b.policy_id
                      AND EXISTS (
                             SELECT 1
                               FROM gicl_claims
                              WHERE claim_id = P_claim_id
                                AND NVL (plate_no, '*^&!') =
                                       DECODE (plate_no,
                                               NULL, NVL (plate_no, '*^&!'),
                                               c.plate_no
                                              )))AND (UPPER (item_title) LIKE
                                                    NVL (UPPER (p_find_text), '%%')
                                                     OR item_no LIKE NVL(p_find_text,'%%'))
												)
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  09.28.2011
   **  Reference By : Claims engineering item info - item no LOV
   **  Description  : getting item no LOV
   */
   FUNCTION get_item_no_list_en (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_find_text      varchar2
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT item_no,
                          get_latest_item_title (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (DECODE (TRUNC (eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= p_loss_date
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= p_loss_date
                      AND a.policy_id = b.policy_id
                      AND item_no NOT IN (SELECT item_no
                                            FROM gicl_engineering_dtl
                                           WHERE claim_id = p_claim_id)
										    AND (UPPER (item_title) LIKE
                                               NVL (UPPER (p_find_text), '%%')
											   OR item_no LIKE NVL(p_find_text,'%%')
											   )
										   )
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_item_no_list_en;

   /*
   **  Created by   :  Emman
   **  Date Created :  09.30.2011
   **  Reference By : Claims engineering item info - item no LOV
   **  Description  : getting item no LOV
   */
   FUNCTION get_item_no_list_mn (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_find_text      varchar2
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                          get_latest_item_title (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (DECODE (TRUNC (eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= p_loss_date
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= p_loss_date
                      AND a.policy_id = b.policy_id
                      AND item_no NOT IN (SELECT item_no
                                            FROM gicl_clm_item
                                           WHERE claim_id = p_claim_id)
										   AND (UPPER (item_title) LIKE
                                               NVL (UPPER (p_find_text), '%%')
											 OR item_no LIKE NVL(p_find_text,'%%'))
										   )
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_item_no_list_av (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
	  p_find_text      varchar2
   )
      RETURN gipi_item_tab PIPELINED
   IS
    v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                          get_latest_item_title (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd, --p_iss_cd, replace by: Nica 04.30.2012
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd --p_iss_cd replaced by Nica
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (DECODE (TRUNC (eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= p_loss_date
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= p_loss_date
                      AND a.policy_id = b.policy_id
                      AND item_no NOT IN (SELECT item_no
                                            FROM gicl_aviation_dtl
                                           WHERE claim_id = p_claim_id)
										   AND (UPPER (item_title) LIKE
                                               NVL (UPPER (p_find_text), '%%')
											   OR item_no LIKE NVL(p_find_text,'%%')
											   )
										   )
      LOOP
          v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
   
   FUNCTION get_item_from_policy(
                         p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
                         p_line_cd      GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd   GIPI_POLBASIC.subline_cd%TYPE,
                         p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no     GIPI_POLBASIC.renew_no%TYPE,
                         p_eff_date     GIPI_POLBASIC.eff_date%TYPE) 
   RETURN gipi_item_tab PIPELINED IS
       v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE; 
       v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE; 
       v_item   gipi_item_type;
       
       CURSOR a1_cur IS
            SELECT b.item_no, b.item_title, b.item_desc, b.item_desc2,
                   b.ann_tsi_amt, b.ann_prem_amt, b.currency_cd,
                   b.currency_rt, b.policy_id, b.group_cd, b.region_cd,
                   b.rec_flag, c.currency_desc, b.from_date, b.TO_DATE,
                   b.risk_no, b.risk_item_no, --added by robert SR 20299 09.09.15
                   b.item_grp, b.payt_terms, b.pack_ben_cd -- added by: Nica 10.12.2012
              FROM gipi_item b,
                   gipi_polbasic a,
                   giis_currency c
             WHERE a.policy_id = p_policy_id
               AND a.policy_id = b.policy_id
               AND b.currency_cd = c.main_currency_cd;
               
        TYPE item_type IS RECORD(
            item_no             gipi_item.item_no%TYPE,
            item_title          gipi_item.item_title%TYPE,
            item_desc           gipi_item.item_desc%TYPE,
            item_desc2          gipi_item.item_desc2%TYPE,
            ann_tsi_amt         gipi_item.ann_tsi_amt%TYPE,
            ann_prem_amt        gipi_item.ann_prem_amt%TYPE,
            currency_cd         gipi_item.currency_cd%TYPE,
            currency_rt         gipi_item.currency_rt%TYPE,
            policy_id           gipi_item.policy_id%TYPE,
            group_cd            gipi_item.group_cd%TYPE,
            region_cd           gipi_item.region_cd%TYPE,
            rec_flag            gipi_item.rec_flag%TYPE,
            currency_desc       giis_currency.currency_desc%TYPE,
            from_date           gipi_item.from_date%TYPE,
            TO_DATE             gipi_item.to_date%TYPE,
            risk_no             gipi_item.risk_no%TYPE,
            risk_item_no        gipi_item.risk_item_no%TYPE,
            item_grp            gipi_item.item_grp%TYPE,
            payt_terms          gipi_item.payt_terms%TYPE,
            pack_ben_cd         gipi_item.pack_ben_cd%TYPE
        );
        TYPE item_tab IS TABLE OF item_type;
        vv_item                 item_tab;
   BEGIN
        OPEN a1_cur;
        LOOP
            FETCH a1_cur
            BULK COLLECT INTO vv_item;
            
            EXIT WHEN a1_cur%NOTFOUND;
        END LOOP;
        CLOSE a1_cur;
        
        FOR a IN 1 .. vv_item.COUNT
        LOOP
                 FOR k IN (
                    SELECT MAX(a2.endt_seq_no) endt_seq_no
                               FROM gipi_polbasic a2, gipi_item b2
                              WHERE a2.line_cd = p_line_cd
                                AND a2.subline_cd = p_subline_cd
                                AND a2.iss_cd = p_iss_cd
                                AND a2.issue_yy = p_issue_yy
                                AND a2.pol_seq_no = p_pol_seq_no
                                AND a2.renew_no = p_renew_no
                                AND a2.policy_id = b2.policy_id
                                AND b2.item_no = vv_item(a).item_no
                           GROUP BY b2.item_no
                 ) LOOP
                    v_max_endt_seq_no := k.endt_seq_no;   
                    EXIT;
                 END LOOP;
                 
                 FOR l IN (
                    SELECT MAX(endt_seq_no) endt_seq_no
                      FROM gipi_polbasic a
                     WHERE a.line_cd     =  p_line_cd
                       AND a.iss_cd      =  p_iss_cd
                       AND a.subline_cd  =  p_subline_cd
                       AND a.issue_yy    =  p_issue_yy
                       AND a.pol_seq_no  =  p_pol_seq_no
                       AND a.renew_no    =  p_renew_no
                       AND a.pol_flag  IN( '1','2','3','X')
                       AND TRUNC(a.eff_date) <= TRUNC(p_eff_date)
                       AND NVL(a.endt_expiry_date, a.expiry_date) >= p_eff_date
                       AND NVL(a.back_stat,5) = 2
                       AND EXISTS (SELECT '1'
                                     FROM gipi_item b
                                    WHERE b.item_no = vv_item(a).item_no
                                      AND a.policy_id = b.policy_id)
                 ) LOOP
                    v_max_endt_seq_no1 := l.endt_seq_no;
                    EXIT;
                 END LOOP;
                 
                 IF v_max_endt_seq_no1 = v_max_endt_seq_no THEN
                     FOR m IN (
                        SELECT b.item_no, b.item_title, b.item_desc, b.item_desc2,
                               b.ann_tsi_amt, b.ann_prem_amt, b.currency_cd,
                               b.currency_rt, b.policy_id, b.group_cd, b.region_cd,
                               b.rec_flag, c.currency_desc, b.from_date, b.TO_DATE,
							   b.risk_no, b.risk_item_no, --added by robert SR 20299 09.09.15
                               b.item_grp, b.payt_terms, b.pack_ben_cd -- added by: Nica 10.12.2012
                          FROM gipi_item b, gipi_polbasic a, giis_currency c
                         WHERE a.policy_id = p_policy_id
                           AND a.policy_id = b.policy_id
                           AND b.currency_cd = c.main_currency_cd
                           AND a.endt_seq_no =
                              (SELECT   MAX (a2.endt_seq_no)
                                   FROM gipi_polbasic a2, gipi_item b2
                                  WHERE a2.line_cd = p_line_cd
                                    AND a2.subline_cd = p_subline_cd
                                    AND a2.iss_cd = p_iss_cd
                                    AND a2.issue_yy = p_issue_yy
                                    AND a2.pol_seq_no = p_pol_seq_no
                                    AND a2.renew_no = p_renew_no
                                    AND a2.policy_id = b2.policy_id
                                    AND b2.item_no = b.item_no
                               GROUP BY b2.item_no)
                     ) LOOP
                         v_item.policy_id := m.policy_id;
                         v_item.item_no := m.item_no;
                         v_item.item_title := m.item_title;
                         v_item.item_desc := m.item_desc;
                         v_item.item_desc2 := m.item_desc2;
                         v_item.item_grp := m.item_grp;
                         v_item.ann_tsi_amt := m.ann_tsi_amt;
                         v_item.ann_prem_amt := m.ann_prem_amt;
                         v_item.currency_cd := m.currency_cd;
                         v_item.currency_rt := m.currency_rt;
                         v_item.group_cd := m.group_cd;
                         v_item.region_cd := m.region_cd;
                         v_item.rec_flag := m.rec_flag;
                         v_item.currency_desc := m.currency_desc;
                         v_item.from_date := m.from_date;
                         v_item.TO_DATE := m.TO_DATE;
						 v_item.payt_terms := m.payt_terms; -- added by: Nica 10.12.2012
                         v_item.pack_ben_cd := m.pack_ben_cd; -- added by: Nica 10.12.2012  
						 v_item.risk_no := m.risk_no;  --added by robert SR 20299 09.09.15
      					 v_item.risk_item_no := m.risk_item_no;  --added by robert SR 20299 09.09.15
                         PIPE ROW (v_item);
                     END LOOP;
                 ELSE
                     v_item.policy_id := vv_item(a).policy_id;
                     v_item.item_no := vv_item(a).item_no;
                     v_item.item_title := vv_item(a).item_title;
                     v_item.item_desc := vv_item(a).item_desc;
                     v_item.item_desc2 := vv_item(a).item_desc2;
                     v_item.item_grp := vv_item(a).item_grp;
                     v_item.ann_tsi_amt := vv_item(a).ann_tsi_amt;
                     v_item.ann_prem_amt := vv_item(a).ann_prem_amt;
                     v_item.currency_cd := vv_item(a).currency_cd;
                     v_item.currency_rt := vv_item(a).currency_rt;
                     v_item.group_cd := vv_item(a).group_cd;
                     v_item.region_cd := vv_item(a).region_cd;
                     v_item.rec_flag := vv_item(a).rec_flag;
                     v_item.currency_desc := vv_item(a).currency_desc;
                     v_item.from_date := vv_item(a).from_date;
                     v_item.TO_DATE := vv_item(a).TO_DATE;
					 v_item.payt_terms := vv_item(a).payt_terms; -- added by: Nica 10.12.2012
                     v_item.pack_ben_cd := vv_item(a).pack_ben_cd; -- added by: Nica 10.12.2012   
					 v_item.risk_no := vv_item(a).risk_no;  --added by robert SR 20299 09.09.15
       				 v_item.risk_item_no := vv_item(a).risk_item_no;  --added by robert SR 20299 09.09.15 
                     PIPE ROW (v_item); 
                 END IF;
            END LOOP;
       
   END get_item_from_policy;
   
/*
**  Created by   :  Belle Bebing
**  Date Created :  12.05.2011
**  Reference By : Claims Personal Accident item info - item no LOV
**  Description  : getting item no LOV
*/
   FUNCTION get_item_no_list_PA (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                          get_latest_item_title (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND a.spld_date is null
                      AND trunc(decode(trunc(nvl(b.from_date,eff_date)),trunc(a.incept_date), nvl(b.from_date,p_pol_eff_date), nvl(b.from_date,a.eff_date ))) <= p_loss_date 
                      AND trunc(decode(nvl(b.to_date,nvl(a.endt_expiry_date, a.expiry_date)), a.expiry_date,nvl(b.to_date,p_expiry_date), nvl(b.to_date,a.endt_expiry_date))) >= p_loss_date 
                      AND a.policy_id = b.policy_id
                      AND item_no not in (SELECT item_no
                                            FROM gicl_accident_dtl
                                           WHERE claim_id = p_claim_id))
      LOOP
         v_list.item_no    := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
/*
**  Created by   :  Belle Bebing
**  Date Created :  12.07.2011
**  Reference By : Claims Personal Accident item info -  grouped item no LOV
**  Description  : getting grouped item no LOV
*/
   FUNCTION get_grpitem_no_list_PA (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT e.grouped_item_no grouped_item_no, e.grouped_item_title grouped_item_title 
                     FROM gipi_polbasic c, gipi_grouped_items e, gipi_item b 
                    WHERE c.policy_id = b.policy_id 
                      AND b.item_no = p_item_no 
                      AND b.policy_id = e.policy_id (+) 
                      AND b.item_no = e.item_no (+) 
                      AND c.renew_no = p_renew_no 
                      AND c.pol_seq_no = p_pol_seq_no 
                      AND c.issue_yy = p_issue_yy 
                      AND c.iss_cd = p_pol_iss_cd 
                      AND c.subline_cd = p_subline_cd 
                      AND c.line_cd = p_line_cd 
                      AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date), p_pol_eff_date, c.eff_date )) <= p_loss_date 
                      AND TRUNC(DECODE(NVL(c.endt_expiry_date,c.expiry_date),c.expiry_date,p_expiry_date,c.endt_expiry_date)) >= p_loss_date 
                      AND c.pol_flag NOT IN ('4','5') 
                      AND e.grouped_item_no NOT IN (SELECT grouped_item_no 
                                                      FROM gicl_accident_dtl 
                                                     WHERE claim_id = p_claim_id 
                                                       AND item_no = p_item_no)
                      -- with reference to module request no. GEN-2012-043_gicls017_v01_01262012 belle 02.10.2012                                                       
                      --added condition to get the latest value of same grouped_item_no in a policy
                      --added by cherrie | 01.25.2012
                      AND e.policy_id = (SELECT MAX(in_ggi.policy_id)
                                           FROM gipi_grouped_items in_ggi, gipi_polbasic in_gp
                                          WHERE in_ggi.policy_id = in_gp.policy_id 
                                            and in_ggi.item_no = e.item_no
                                            and in_ggi.grouped_item_no = e.grouped_item_no
                                            and in_gp.renew_no = p_renew_no 
                                            and in_gp.pol_seq_no = p_pol_seq_no 
                                            and in_gp.issue_yy = p_issue_yy  
                                            and in_gp.iss_cd = p_pol_iss_cd 
                                            and in_gp.subline_cd = p_subline_cd 
                                            and in_gp.line_cd = p_line_cd
                                            AND TRUNC (DECODE (TRUNC (in_gp.eff_date),
                                                TRUNC (in_gp.incept_date), p_pol_eff_date,in_gp.eff_date)) <= p_loss_date
                                            AND TRUNC (DECODE(NVL (in_gp.endt_expiry_date, in_gp.expiry_date), in_gp.expiry_date, p_expiry_date, in_gp.endt_expiry_date)) >= p_loss_date )
                     ORDER BY e.grouped_item_no )
      LOOP
         v_list.grouped_item_no    := i.grouped_item_no;
         v_list.grouped_item_title := i.grouped_item_title;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
   /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.13.2011 
    **  Reference By    : (GICLS026 - No Claim)
    **  Description     : nonmotcar_item_lov 
    */  
    FUNCTION get_nonmotcar_item_gicls026( 
        p_line_cd          GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd           GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no         GIPI_POLBASIC.renew_no%TYPE
   )
   RETURN item_tab PIPELINED
   IS
        v_list              item_type;
        previous_item_no    GIPI_ITEM.ITEM_NO%TYPE := -1; 
   BEGIN
        FOR cur IN (SELECT b.item_no, b.item_title      
                      FROM gipi_item b, gipi_polbasic c
                     WHERE b.policy_id           = c.policy_id 
                       AND c.line_cd             = p_line_cd 
                       AND c.subline_cd          = p_subline_cd 
                       AND c.iss_cd              = p_iss_cd 
                       AND c.issue_yy            = p_issue_yy 
                       AND c.pol_seq_no          = p_pol_seq_no 
                       AND c.renew_no            = p_renew_no
                     ORDER BY b.item_no)
        LOOP
            IF cur.item_no <> previous_item_no THEN
                v_list.item_no             := cur.item_no;
                v_list.item_title          := cur.item_title;
                previous_item_no           := cur.item_no;
                PIPE ROW(v_list);
            END IF;
        END LOOP;
   END get_nonmotcar_item_gicls026;
   
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 03.15.2012
    **  Reference By    : (GIEXS007 - Edit Peril Information)
    **  Description     : lov_item_no 
    */  
    FUNCTION get_item_no_giexs007(p_policy_id          gipi_item.policy_id%TYPE)
    RETURN item_tab PIPELINED
    IS
        v_list              item_type;
    BEGIN
        FOR cur IN (SELECT DISTINCT a.item_no, DECODE (a.item_no, 0, NULL, b.item_title) item_title
                      --FROM giex_old_group_deductibles a, gipi_item b 
                      FROM giex_itmperil a, gipi_item b -- joanne 120913, change table into giex_itmperil to return extracted items not only the ones with deductible
                     WHERE b.policy_id = a.policy_id
                       AND a.policy_id = p_policy_id
                       AND --(
                            b.item_no = a.item_no --or
                            --a.item_no = 0) -- comment by andrew - 1.11.2012 
                            )
        LOOP
            v_list.item_no             := cur.item_no;
            v_list.item_title          := cur.item_title;
            PIPE ROW(v_list);
        END LOOP;
    END get_item_no_giexs007;
	
	/*
    **  Created by      : Robert Virrey 
    **  Date Created    : 04.24.2012
    **  Reference By    : (GICLS026 - No Claim)
    **  Description     : get item title
    */ 
    FUNCTION get_item_title (
       p_item_no        gipi_item.item_no%TYPE,
       p_line_cd        gipi_polbasic.line_cd%TYPE,
       p_subline_cd     gipi_polbasic.subline_cd%TYPE,
       p_iss_cd         gipi_polbasic.iss_cd%TYPE,
       p_issue_yy       gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no       gipi_polbasic.renew_no%TYPE
    )
    RETURN VARCHAR2
    IS
       v_item_title   VARCHAR2(50);
    BEGIN
       FOR a IN (SELECT b.item_title
                   FROM gipi_item b, gipi_polbasic c
                  WHERE b.policy_id     = c.policy_id
                    AND c.line_cd       = p_line_cd
                    AND c.subline_cd    = p_subline_cd
                    AND c.iss_cd        = p_iss_cd
                    AND c.issue_yy      = p_issue_yy
                    AND c.pol_seq_no    = p_pol_seq_no
                    AND c.renew_no      = p_renew_no
                    AND b.item_no       = p_item_no)
       LOOP
          v_item_title := a.item_title;
       END LOOP;

       RETURN v_item_title;
    END get_item_title;
    
    /*
    **  Created by      : Marie Kris Felipe 
    **  Date Created    : 08.22.2013
    **  Reference By    : (GIUTS027 - Update Policy Coverage)
    **  Description     : gets the item no and item title of a given policy_id
    */ 
    FUNCTION get_item_giuts027(
        p_policy_id     gipi_item.policy_id%TYPE
    ) RETURN giuts027_item_tab PIPELINED
    IS
        v_item      giuts027_item_type;
    BEGIN
    
        FOR rec IN (SELECT policy_id, item_no, item_title, coverage_cd
                      FROM gipi_item i
                     WHERE policy_id = p_policy_id)
        LOOP
        
            v_item.policy_id    := rec.policy_id;
            v_item.item_no      := rec.item_no;
            v_item.item_title   := rec.item_title;
            v_item.coverage_cd  := rec.coverage_cd;
            v_item.coverage_desc := NULL;
            
            FOR a IN (SELECT coverage_desc
                        INTO v_item.coverage_desc
                        FROM giis_coverage c
                       WHERE c.coverage_cd  = v_item.coverage_cd)
            LOOP
                v_item.coverage_desc := a.coverage_desc;
                EXIT;
            END LOOP;
                   
            PIPE ROW(v_item);
        END LOOP;
    
    END get_item_giuts027;
    
    PROCEDURE update_item_coverage(
        p_policy_id     gipi_item.policy_id%TYPE,
        p_item_no       gipi_item.item_no%TYPE,
        p_coverage_cd   gipi_item.coverage_cd%TYPE
    ) IS    
    BEGIN
    
        UPDATE gipi_item
           SET coverage_cd = p_coverage_cd
         WHERE policy_id   = p_policy_id
           AND item_no     = p_item_no;
         
    END update_item_coverage;
    
    FUNCTION get_endt_item_list(
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_eff_date       gipi_polbasic.eff_date%TYPE
   )
     RETURN item_tab PIPELINED
   IS
      v_row             item_type;
   BEGIN
      FOR i IN(SELECT DISTINCT item_no item_no
                 FROM gipi_polbasic a, gipi_item b
                WHERE a.line_cd = p_line_cd
                  AND a.iss_cd = p_iss_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.issue_yy = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no = p_renew_no
                  AND a.pol_flag IN( '1','2','3','X')
                  AND a.policy_id = b.policy_id
                  AND TRUNC(a.eff_date) <= DECODE(NVL(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
                  AND NVL(a.endt_expiry_date,a.expiry_date) >= TRUNC(p_eff_date))
      LOOP
         v_row.item_no := i.item_no;
         PIPE ROW(v_row);
      END LOOP;
   END;
    
    FUNCTION get_item_ann_tsi_prem(p_par_id          gipi_witem.par_id%TYPE)
    RETURN gipi_item_ann_tsi_prem_tab PIPELINED
    AS
       v_policy_ids       VARCHAR2 (32676);
       v_policy_ann_tsi   gipi_polbasic.ann_tsi_amt%TYPE := 0;
       v_policy_prem_amt  gipi_polbasic.ann_prem_amt%TYPE := 0;
       v_gipi_item_tab    gipi_item_ann_tsi_prem_tab;
       v_gipi_item_tab2   gipi_item_ann_tsi_prem_rec;
    BEGIN
       FOR a1 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                         renew_no, eff_date, expiry_date
                    FROM gipi_wpolbas
                   WHERE par_id = p_par_id)
       LOOP
          FOR i IN (SELECT   policy_id
                        FROM gipi_polbasic
                       WHERE line_cd = a1.line_cd
                         AND subline_cd = a1.subline_cd
                         AND iss_cd = a1.iss_cd
                         AND issue_yy = a1.issue_yy
                         AND pol_seq_no = a1.pol_seq_no
                         AND renew_no = a1.renew_no
                         AND TRUNC (eff_date) <= a1.eff_date
                         AND NVL (TRUNC (endt_expiry_date), TRUNC (expiry_date)) >=
                                                                       a1.eff_date
                    ORDER BY policy_id)
          LOOP
             v_policy_ids := v_policy_ids || ', ' || i.policy_id;
          END LOOP;
          
          IF v_policy_ids IS NOT NULL THEN
              v_policy_ids := SUBSTR (v_policy_ids, 3);

              EXECUTE IMMEDIATE    'SELECT   gi.item_no, SUM (NVL (gi.tsi_amt, 0)) tsi_amt,' ||
                                     'SUM '||
                                       ' (NVL (CASE gp.prorate_flag '||
                                                 'WHEN ''1'' '||
                                                    'THEN (  (  gi.prem_amt '||
                                                             '/ (  ROUND (  NVL (gp.endt_expiry_date, '||
                                                                                'gp.expiry_date '||
                                                                               ') '||
                                                                         '- gp.eff_date '||
                                                                        ') '||
                                                                '+ DECODE (NVL (gp.comp_sw, ''N''), '||
                                                                          '''Y'', 1, '||
                                                                          '''M'', -1, '||
                                                                          '0 '||
                                                                         ') '||
                                                               ') '||
                                                            ') '||
                                                          '* check_duration (gp.incept_date, gp.expiry_date) '||
                                                         ') '||
                                                 'WHEN ''3'' '||
                                                    'THEN (gi.prem_amt * 100) / gp.short_rt_percent '||
                                                 'ELSE gi.prem_amt '||
                                              'END, '||
                                              '0 '||
                                             ') '||
                                        ') prem_amt '||
                                'FROM gipi_item gi, gipi_polbasic gp '||
                               'WHERE gi.policy_id = gp.policy_id '||
                                 'AND gi.policy_id IN ('||v_policy_ids||') '||
                                 'AND gp.pol_flag != ''5'' '||
                                 'AND gp.prorate_flag IN (1, 2, 3) '||
                            'GROUP BY item_no'
              BULK COLLECT INTO v_gipi_item_tab;

              FOR i IN 1 .. v_gipi_item_tab.COUNT
              LOOP
                 DBMS_OUTPUT.put_line (v_gipi_item_tab (i).item_no||': '||v_gipi_item_tab (i).ann_tsi_amt||': '||v_gipi_item_tab (i).ann_prem_amt);
                 v_policy_ann_tsi := v_policy_ann_tsi + v_gipi_item_tab (i).ann_tsi_amt;
                 v_policy_prem_amt := v_policy_prem_amt + v_gipi_item_tab (i).ann_prem_amt;
                 v_gipi_item_tab2.item_no := v_gipi_item_tab (i).item_no;
                 v_gipi_item_tab2.ann_prem_amt := v_gipi_item_tab (i).ann_prem_amt;
                 v_gipi_item_tab2.ann_tsi_amt := v_gipi_item_tab (i).ann_tsi_amt;
                 
                 PIPE ROW(v_gipi_item_tab2);
              END LOOP;
          END IF;
       END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END get_item_ann_tsi_prem;

END gipi_item_pkg;
/


