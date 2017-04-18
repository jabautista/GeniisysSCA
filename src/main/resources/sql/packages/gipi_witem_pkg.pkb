CREATE OR REPLACE PACKAGE BODY CPI.gipi_witem_pkg
AS
   FUNCTION get_gipi_witem (p_par_id gipi_witem.par_id%TYPE)
      RETURN gipi_witem_tab PIPELINED
   IS
      v_witem        gipi_witem_type;
      v_package_cd   giis_package_benefit.package_cd%TYPE;
   BEGIN
    --edited by d.alcantara, 2/17/2011, added region_cd, risk_no and risk_item_no
      FOR i IN (SELECT   a.par_id, a.item_no, a.item_title, a.item_desc, a.item_grp,
                         a.item_desc2, a.currency_cd, b.currency_desc,
                         a.currency_rt, a.coverage_cd, c.coverage_desc,
                         a.pack_line_cd, a.pack_subline_cd, a.from_date,
                         a.TO_DATE, a.changed_tag, a.prorate_flag, a.comp_sw,
                         a.pack_ben_cd, a.short_rt_percent, a.risk_no,
                         a.risk_item_no, a.surcharge_sw, d.line_cd,
                         a.region_cd, a.discount_sw, a.other_info,
                         NVL (a.prem_amt, 0) prem_amt,
                         NVL (a.ann_prem_amt, 0) ann_prem_amt,
                         NVL (a.tsi_amt, 0) tsi_amt,
                         NVL (a.ann_tsi_amt, 0) ann_tsi_amt,
                         a.payt_terms, a.rec_flag
                    FROM gipi_witem a,
                         giis_currency b,
                         giis_coverage c,
                         gipi_parlist d
                   WHERE a.par_id = p_par_id
                     AND a.currency_cd = b.main_currency_cd(+)
                     AND a.coverage_cd = c.coverage_cd(+)
                     AND d.par_id = p_par_id
                ORDER BY a.item_no)
      LOOP
         IF i.pack_ben_cd IS NOT NULL
         THEN
            SELECT package_cd
              INTO v_package_cd
              FROM giis_package_benefit
             WHERE line_cd = i.line_cd AND pack_ben_cd = i.pack_ben_cd;
         END IF;

         v_witem.par_id := i.par_id;
         v_witem.item_no := i.item_no;
         v_witem.item_title := i.item_title;
         v_witem.item_desc := i.item_desc; --removed ESCAPE_VALUE_CLOB rjvirrey 02.27.2013 SR12307
         v_witem.item_desc2 := i.item_desc2; --removed ESCAPE_VALUE_CLOB rjvirrey 02.27.2013 SR12307
         v_witem.item_grp  := i.item_grp;
         v_witem.currency_cd := i.currency_cd;
         v_witem.currency_desc := i.currency_desc;
         v_witem.currency_rt := i.currency_rt;
         v_witem.coverage_cd := i.coverage_cd;
         v_witem.coverage_desc := i.coverage_desc;
         v_witem.pack_line_cd := i.pack_line_cd;
         v_witem.pack_subline_cd := i.pack_subline_cd;
         v_witem.from_date := i.from_date;
         v_witem.TO_DATE := i.TO_DATE;
         v_witem.region_cd := i.region_cd;
         v_witem.discount_sw := i.discount_sw;
         v_witem.other_info := i.other_info;
         v_witem.prem_amt := i.prem_amt;
         v_witem.ann_prem_amt := i.ann_prem_amt;
         v_witem.tsi_amt := i.tsi_amt;
         v_witem.ann_tsi_amt := i.ann_tsi_amt;
         v_witem.changed_tag := i.changed_tag;
         v_witem.prorate_flag := i.prorate_flag;
         v_witem.comp_sw := i.comp_sw;
         v_witem.short_rt_percent := i.short_rt_percent;
         v_witem.risk_no     := i.risk_no;
         v_witem.risk_item_no := i.risk_item_no;
         v_witem.surcharge_sw := i.surcharge_sw;
         v_witem.pack_ben_cd := i.pack_ben_cd;
         v_witem.dsp_package_cd := v_package_cd;
         v_witem.itmperl_grouped_exists := GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_exist(p_par_id, i.item_no);
         v_witem.payt_terms := i.payt_terms;
		 v_witem.rec_flag := i.rec_flag;
         PIPE ROW (v_witem);
      END LOOP;

      RETURN;
   END get_gipi_witem;

   FUNCTION get_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN gipi_witem_tab PIPELINED
   IS
      v_witem   gipi_witem_type;
   BEGIN
      FOR i IN (SELECT a.par_id, a.item_no, a.item_title, a.item_desc,
                       a.item_desc2, a.currency_cd, b.currency_desc,
                       a.currency_rt, a.coverage_cd, c.coverage_desc,
                       a.group_cd, d.group_desc, a.region_cd, e.region_desc,
                       a.pack_line_cd, a.pack_subline_cd, a.discount_sw,
                       a.from_date, a.TO_DATE, a.rec_flag, a.item_grp,
                       a.prem_amt, a.ann_prem_amt, a.tsi_amt, a.ann_tsi_amt,
                       a.other_info, a.payt_terms
                  FROM gipi_witem a,
                       giis_currency b,
                       giis_coverage c,
                       giis_group d,
                       giis_region e
                 WHERE a.par_id = p_par_id
                   AND a.item_no = p_item_no
                   AND a.currency_cd = b.main_currency_cd(+)
                   AND a.coverage_cd = c.coverage_cd(+)
                   AND a.group_cd = d.group_cd(+)
                   AND a.region_cd = e.region_cd(+))
      LOOP
         v_witem.par_id := i.par_id;
         v_witem.item_no := i.item_no;
         v_witem.item_title := i.item_title;
         v_witem.item_desc := i.item_desc;
         v_witem.item_desc2 := i.item_desc2;
         v_witem.currency_cd := i.currency_cd;
         v_witem.currency_desc := i.currency_desc;
         v_witem.currency_rt := i.currency_rt;
         v_witem.coverage_cd := i.coverage_cd;
         v_witem.coverage_desc := i.coverage_desc;
         v_witem.group_cd := i.group_cd;
         v_witem.group_desc := i.group_desc;
         v_witem.region_cd := i.region_cd;
         v_witem.region_desc := i.region_desc;
         v_witem.pack_line_cd := i.pack_line_cd;
         v_witem.pack_subline_cd := i.pack_subline_cd;
         v_witem.discount_sw := i.discount_sw;
         v_witem.from_date := i.from_date;
         v_witem.TO_DATE := i.TO_DATE;
         v_witem.rec_flag := i.rec_flag;
         v_witem.item_grp := i.item_grp;
         v_witem.prem_amt := i.prem_amt;
         v_witem.ann_prem_amt := i.ann_prem_amt;
         v_witem.tsi_amt := i.tsi_amt;
         v_witem.ann_tsi_amt := i.ann_tsi_amt;
         v_witem.other_info := i.other_info;
         v_witem.payt_terms := i.payt_terms;
         PIPE ROW (v_witem);
      END LOOP;

      RETURN;
   END get_gipi_witem;

   PROCEDURE set_gipi_witem (
      v_par_id            IN   gipi_witem.par_id%TYPE,
      v_item_no           IN   gipi_witem.item_no%TYPE,
      v_item_title        IN   gipi_witem.item_title%TYPE,
      v_item_desc         IN   gipi_witem.item_desc%TYPE,
      v_item_desc2        IN   gipi_witem.item_desc2%TYPE,
      v_currency_cd       IN   gipi_witem.currency_cd%TYPE,
      v_currency_rt       IN   gipi_witem.currency_rt%TYPE,
      v_coverage_cd       IN   gipi_witem.coverage_cd%TYPE,
      v_group_cd          IN   gipi_witem.group_cd%TYPE,
      v_region_cd         IN   gipi_witem.region_cd%TYPE,
      v_pack_line_cd      IN   gipi_witem.pack_line_cd%TYPE,
      v_pack_subline_cd   IN   gipi_witem.pack_subline_cd%TYPE,
      v_discount_sw       IN   gipi_witem.discount_sw%TYPE,
      v_from_date         IN   gipi_witem.from_date%TYPE,
      v_to_date           IN   gipi_witem.TO_DATE%TYPE,
      v_rec_flag          IN   gipi_witem.rec_flag%TYPE,
      v_item_grp          IN   gipi_witem.item_grp%TYPE,
      v_prem_amt          IN   gipi_witem.prem_amt%TYPE,
      v_ann_prem_amt      IN   gipi_witem.ann_prem_amt%TYPE,
      v_tsi_amt           IN   gipi_witem.tsi_amt%TYPE,
      v_ann_tsi_amt       IN   gipi_witem.ann_tsi_amt%TYPE,
      v_other_info        IN   gipi_witem.other_info%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_witem
         USING DUAL
         ON (par_id = v_par_id AND item_no = v_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, item_title, item_desc, item_desc2,
                    currency_cd, currency_rt, coverage_cd, group_cd,
                    region_cd, pack_line_cd, pack_subline_cd, discount_sw,
                    from_date, TO_DATE, rec_flag, item_grp, prem_amt,
                    ann_prem_amt, tsi_amt, ann_tsi_amt, other_info)
            VALUES (v_par_id, v_item_no, v_item_title, v_item_desc,
                    v_item_desc2, v_currency_cd, v_currency_rt,
                    v_coverage_cd, v_group_cd, v_region_cd, v_pack_line_cd,
                    v_pack_subline_cd, v_discount_sw, v_from_date, v_to_date,
                    v_rec_flag, v_item_grp, v_prem_amt, v_ann_prem_amt,
                    v_tsi_amt, v_ann_tsi_amt, v_other_info)
         WHEN MATCHED THEN
            UPDATE
               SET item_title = v_item_title, item_desc = v_item_desc,
                   item_desc2 = v_item_desc2, currency_cd = v_currency_cd,
                   currency_rt = v_currency_rt, coverage_cd = v_coverage_cd,
                   group_cd = v_group_cd, region_cd = v_region_cd,
                   pack_line_cd = v_pack_line_cd,
                   pack_subline_cd = v_pack_subline_cd,
                   discount_sw = v_discount_sw, from_date = v_from_date,
                   TO_DATE = v_to_date, rec_flag = v_rec_flag,
                   item_grp = v_item_grp, prem_amt = v_prem_amt,
                   ann_prem_amt = v_ann_prem_amt, tsi_amt = v_tsi_amt,
                   ann_tsi_amt = v_ann_tsi_amt, other_info = v_other_info
            ;
      COMMIT;
   END set_gipi_witem;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure is used for inserting and updating records GIPI_WITEM table
   */
   PROCEDURE set_gipi_witem_1 (p_item gipi_witem%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gipi_witem
         USING DUAL
         ON (par_id = p_item.par_id AND item_no = p_item.item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, item_title, item_desc, item_desc2,
                    currency_cd, currency_rt, coverage_cd, pack_line_cd,
                    pack_subline_cd, item_grp, rec_flag, from_date, TO_DATE)
            VALUES (p_item.par_id, p_item.item_no, p_item.item_title,
                    p_item.item_desc, p_item.item_desc2, p_item.currency_cd,
                    p_item.currency_rt, p_item.coverage_cd,
                    p_item.pack_line_cd, p_item.pack_subline_cd,
                    p_item.item_grp, p_item.rec_flag, p_item.from_date,
                    p_item.TO_DATE)
         WHEN MATCHED THEN
            UPDATE
               SET item_title = p_item.item_title,
                   item_desc = p_item.item_desc,
                   item_desc2 = p_item.item_desc2,
                   currency_cd = p_item.currency_cd,
                   currency_rt = p_item.currency_rt,
                   coverage_cd = p_item.coverage_cd,
                   pack_line_cd = p_item.pack_line_cd,
                   pack_subline_cd = p_item.pack_subline_cd,
                   item_grp = p_item.item_grp, rec_flag = p_item.rec_flag,
                   from_date = p_item.from_date, TO_DATE = p_item.TO_DATE
            ;
   END set_gipi_witem_1;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 03.04.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure is used for inserting and updating records GIPI_WITEM table (complete columns)
   */
    PROCEDURE set_gipi_witem_2 (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_item_no            IN   gipi_witem.item_no%TYPE,
      p_item_title         IN   gipi_witem.item_title%TYPE,
      p_item_grp           IN   gipi_witem.item_grp%TYPE,
      p_item_desc          IN   gipi_witem.item_desc%TYPE,
      p_item_desc2         IN   gipi_witem.item_desc2%TYPE,
      p_tsi_amt            IN   gipi_witem.tsi_amt%TYPE,
      p_prem_amt           IN   gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt       IN   gipi_witem.ann_prem_amt%TYPE,
      p_ann_tsi_amt        IN   gipi_witem.ann_tsi_amt%TYPE,
      p_rec_flag           IN   gipi_witem.rec_flag%TYPE,
      p_currency_cd        IN   gipi_witem.currency_cd%TYPE,
      p_currency_rt        IN   gipi_witem.currency_rt%TYPE,
      p_group_cd           IN   gipi_witem.group_cd%TYPE,
      p_from_date          IN   gipi_witem.from_date%TYPE,
      p_to_date            IN   gipi_witem.TO_DATE%TYPE,
      p_pack_line_cd       IN   gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd    IN   gipi_witem.pack_subline_cd%TYPE,
      p_discount_sw        IN   gipi_witem.discount_sw%TYPE,
      p_coverage_cd        IN   gipi_witem.coverage_cd%TYPE,
      p_other_info         IN   gipi_witem.other_info%TYPE,
      p_surcharge_sw       IN   gipi_witem.surcharge_sw%TYPE,
      p_region_cd          IN   gipi_witem.region_cd%TYPE,
      p_changed_tag        IN   gipi_witem.changed_tag%TYPE,
      p_prorate_flag       IN   gipi_witem.prorate_flag%TYPE,
      p_comp_sw            IN   gipi_witem.comp_sw%TYPE,
      p_short_rt_percent   IN   gipi_witem.short_rt_percent%TYPE,
      p_pack_ben_cd        IN   gipi_witem.pack_ben_cd%TYPE,
      p_payt_terms         IN   gipi_witem.payt_terms%TYPE,
      p_risk_no            IN   gipi_witem.risk_no%TYPE,
      p_risk_item_no       IN   gipi_witem.risk_item_no%TYPE
   )
   IS
      v_line_cd                 gipi_parlist.line_cd%TYPE;
      v_from_date               gipi_witem.from_date%TYPE;
      v_to_date                 gipi_witem.TO_DATE%TYPE;
   BEGIN
      -- (start) added by nante 2.18.2014
      SELECT NVL(b.menu_line_cd, b.line_cd)
        INTO v_line_cd
        FROM gipi_parlist a, giis_line b
       WHERE a.par_id = p_par_id
         AND a.line_cd = b.line_cd;

      IF v_line_cd NOT IN ('AC', 'FI') THEN
         v_from_date := null;
         v_to_date   := null;
      ELSE
         v_from_date := p_from_date;
         v_to_date   := p_to_date;
      END IF;
      -- (end)
      MERGE INTO gipi_witem
         USING DUAL
         ON (par_id = p_par_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, item_title, item_grp, item_desc,
                    item_desc2, tsi_amt, prem_amt, ann_prem_amt, ann_tsi_amt,
                    rec_flag, currency_cd, currency_rt, group_cd, from_date,
                    TO_DATE, pack_line_cd, pack_subline_cd, discount_sw,
                    coverage_cd, other_info, surcharge_sw, region_cd,
                    changed_tag, prorate_flag, comp_sw, short_rt_percent,
                    pack_ben_cd, payt_terms, risk_no, risk_item_no)
            VALUES (p_par_id, p_item_no, p_item_title, p_item_grp,
                    p_item_desc, p_item_desc2, p_tsi_amt, p_prem_amt,
                    p_ann_prem_amt, p_ann_tsi_amt, p_rec_flag, p_currency_cd,
                    --p_currency_rt, p_group_cd, p_from_date, p_to_date,  -- replaced By nante 02.18.2014
                    p_currency_rt, p_group_cd, v_from_date, v_to_date,    --
                    p_pack_line_cd, p_pack_subline_cd, p_discount_sw,
                    p_coverage_cd, p_other_info, p_surcharge_sw, p_region_cd,
                    p_changed_tag, p_prorate_flag, p_comp_sw,
                    p_short_rt_percent, p_pack_ben_cd, p_payt_terms,
                    p_risk_no, p_risk_item_no)
         WHEN MATCHED THEN
            UPDATE
               SET item_title = p_item_title, item_grp = p_item_grp,
                   item_desc = p_item_desc, item_desc2 = p_item_desc2,
                   tsi_amt = p_tsi_amt, prem_amt = p_prem_amt,
                   ann_prem_amt = p_ann_prem_amt,
                   ann_tsi_amt = p_ann_tsi_amt, rec_flag = p_rec_flag,
                   currency_cd = p_currency_cd, currency_rt = p_currency_rt,
                   --group_cd = p_group_cd, from_date = p_from_date,       -- replaced by nante
                   --TO_DATE = p_to_date, pack_line_cd = p_pack_line_cd,   --  2.18.2014
                   group_cd = p_group_cd, from_date = v_from_date,         --
                   TO_DATE = v_to_date, pack_line_cd = p_pack_line_cd,     --
                   pack_subline_cd = p_pack_subline_cd,
                   discount_sw = p_discount_sw, coverage_cd = p_coverage_cd,
                   other_info = p_other_info, surcharge_sw = p_surcharge_sw,
                   region_cd = p_region_cd, changed_tag = p_changed_tag,
                   prorate_flag = p_prorate_flag, comp_sw = p_comp_sw,
                   short_rt_percent = p_short_rt_percent,
                   pack_ben_cd = p_pack_ben_cd, payt_terms = p_payt_terms,
                   risk_no = p_risk_no, risk_item_no = p_risk_item_no
            ;
   END set_gipi_witem_2;

   /*
   **  Created by    : B.J.G.Abuluyan
   **  Date Created  : 09.30.2010
   **  Reference By  : (GIPIS081 - Endorsement Item Information)
   **  Description   : This procedure is used for inserting and updating records GIPI_WITEM table and calls changes for item group value
   */
   PROCEDURE set_gipi_witem_wgroup (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_item_no            IN   gipi_witem.item_no%TYPE,
      p_item_title         IN   gipi_witem.item_title%TYPE,
      p_item_grp           IN   gipi_witem.item_grp%TYPE,
      p_item_desc          IN   gipi_witem.item_desc%TYPE,
      p_item_desc2         IN   gipi_witem.item_desc2%TYPE,
      p_tsi_amt            IN   gipi_witem.tsi_amt%TYPE,
      p_prem_amt           IN   gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt       IN   gipi_witem.ann_prem_amt%TYPE,
      p_ann_tsi_amt        IN   gipi_witem.ann_tsi_amt%TYPE,
      p_rec_flag           IN   gipi_witem.rec_flag%TYPE,
      p_currency_cd        IN   gipi_witem.currency_cd%TYPE,
      p_currency_rt        IN   gipi_witem.currency_rt%TYPE,
      p_group_cd           IN   gipi_witem.group_cd%TYPE,
      p_from_date          IN   gipi_witem.from_date%TYPE,
      p_to_date            IN   gipi_witem.TO_DATE%TYPE,
      p_pack_line_cd       IN   gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd    IN   gipi_witem.pack_subline_cd%TYPE,
      p_discount_sw        IN   gipi_witem.discount_sw%TYPE,
      p_coverage_cd        IN   gipi_witem.coverage_cd%TYPE,
      p_other_info         IN   gipi_witem.other_info%TYPE,
      p_surcharge_sw       IN   gipi_witem.surcharge_sw%TYPE,
      p_region_cd          IN   gipi_witem.region_cd%TYPE,
      p_changed_tag        IN   gipi_witem.changed_tag%TYPE,
      p_prorate_flag       IN   gipi_witem.prorate_flag%TYPE,
      p_comp_sw            IN   gipi_witem.comp_sw%TYPE,
      p_short_rt_percent   IN   gipi_witem.short_rt_percent%TYPE,
      p_pack_ben_cd        IN   gipi_witem.pack_ben_cd%TYPE,
      p_payt_terms         IN   gipi_witem.payt_terms%TYPE,
      p_risk_no            IN   gipi_witem.risk_no%TYPE,
      p_risk_item_no       IN   gipi_witem.risk_item_no%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_witem
         USING DUAL
         ON (par_id = p_par_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, item_title, item_grp, item_desc,
                    item_desc2, tsi_amt, prem_amt, ann_prem_amt, ann_tsi_amt,
                    rec_flag, currency_cd, currency_rt, group_cd, from_date,
                    TO_DATE, pack_line_cd, pack_subline_cd, discount_sw,
                    coverage_cd, other_info, surcharge_sw, region_cd,
                    changed_tag, prorate_flag, comp_sw, short_rt_percent,
                    pack_ben_cd, payt_terms, risk_no, risk_item_no)
            VALUES (p_par_id, p_item_no, p_item_title, p_item_grp,
                    p_item_desc, p_item_desc2, p_tsi_amt, p_prem_amt,
                    p_ann_prem_amt, p_ann_tsi_amt, p_rec_flag, p_currency_cd,
                    p_currency_rt, p_group_cd, p_from_date, p_to_date,
                    p_pack_line_cd, p_pack_subline_cd, p_discount_sw,
                    p_coverage_cd, p_other_info, p_surcharge_sw, p_region_cd,
                    p_changed_tag, p_prorate_flag, p_comp_sw,
                    p_short_rt_percent, p_pack_ben_cd, p_payt_terms,
                    p_risk_no, p_risk_item_no)
         WHEN MATCHED THEN
            UPDATE
               SET item_title = p_item_title, item_grp = p_item_grp,
                   item_desc = p_item_desc, item_desc2 = p_item_desc2,
                   tsi_amt = p_tsi_amt, prem_amt = p_prem_amt,
                   ann_prem_amt = p_ann_prem_amt,
                   ann_tsi_amt = p_ann_tsi_amt, rec_flag = p_rec_flag,
                   currency_cd = p_currency_cd, currency_rt = p_currency_rt,
                   group_cd = p_group_cd, from_date = p_from_date,
                   TO_DATE = p_to_date, pack_line_cd = p_pack_line_cd,
                   pack_subline_cd = p_pack_subline_cd,
                   discount_sw = p_discount_sw, coverage_cd = p_coverage_cd,
                   other_info = p_other_info, surcharge_sw = p_surcharge_sw,
                   region_cd = p_region_cd, changed_tag = p_changed_tag,
                   prorate_flag = p_prorate_flag, comp_sw = p_comp_sw,
                   short_rt_percent = p_short_rt_percent,
                   pack_ben_cd = p_pack_ben_cd, payt_terms = p_payt_terms,
                   risk_no = p_risk_no, risk_item_no = p_risk_item_no
            ;

         CHANGE_ITEM_GRP3(p_par_id);
   END set_gipi_witem_wgroup;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure updates the prem_amt, ann_prem_amt, and discount_sw
   **               on GIPI_WPERIL_DISCOUNT and GIPI_WITEM, and update the
   **               tsi_amt, prem_amt, ann_tsi_amt, and ann_prem_amt on GIPI_WPOLBAS.
   **               It also deletes records on the
   **               following tables: GIPI_WPERIL_DISCOUNT, GIPI_WITEM_DISCOUNT, GIPI_WPOLBAS_DISCOUNT
   */
   PROCEDURE pre_set_gipi_witem (p_par_id gipi_witem.par_id%TYPE)
   IS
   BEGIN
      gipis010_delete_discount (p_par_id);
   END pre_set_gipi_witem;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure delete records on GIPI_WITMPERL, GIPI_WPERIL_DISCOUNT,
   **               GIPI_WDEDUCTIBLES, GIPI_WMORTGAGEE, GIPI_WMCACC (based on par_id and item_no)
   **               before deleting record on GIPI_WITEM
   */
   PROCEDURE del_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
   IS
   v_menu_line_cd  giis_line.menu_line_cd%TYPE;
   BEGIN
      FOR i IN (SELECT line_cd
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
        FOR j IN (SELECT menu_line_cd
                   FROM giis_line
                  WHERE line_cd = i.line_cd)
       LOOP
          v_menu_line_cd := NVL(j.menu_line_cd,i.line_cd);
          EXIT;
       END LOOP;
         pre_del_gipi_witem (p_par_id, p_item_no, v_menu_line_cd); --change by steven 10.18.2013
         EXIT;
      END LOOP;

      DELETE FROM gipi_witem
            WHERE par_id = p_par_id AND item_no = p_item_no;
   END del_gipi_witem;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 07.07.2010
   **  Reference By  : (GIPIS060 - Endt Item Information)
   **  Description   : Delete records used for endt item info
   */
   PROCEDURE del_endt_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT line_cd
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         pre_del_endt_gipi_witem (p_par_id, p_item_no, i.line_cd);
         EXIT;
      END LOOP;

      DELETE FROM gipi_witem
            WHERE par_id = p_par_id AND item_no = p_item_no;
   END del_endt_gipi_witem;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure delete all records on GIPI_WITEM table based on the par_id
   */
   PROCEDURE del_all_gipi_witem (p_par_id gipi_witem.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_witem
            WHERE par_id = p_par_id;
   END del_all_gipi_witem;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure delete records on GIPI_WITMPERL, GIPI_WPERIL_DISCOUNT,
   **               GIPI_WDEDUCTIBLES, GIPI_WMORTGAGEE, GIPI_WMCACC (based on par_id and item_no)
   */
   PROCEDURE pre_del_gipi_witem (
      p_par_id          gipi_witem.par_id%TYPE,
      p_item_no         gipi_witem.item_no%TYPE,
      p_line_cd         gipi_wpolbas.line_cd%TYPE
   )
   IS
   BEGIN
      gipis010_delete_discount (p_par_id);

      FOR d1 IN (SELECT *
                   FROM gipi_witmperl
                  WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         gipi_witmperl_pkg.del_gipi_witmperl_1 (p_par_id, p_item_no, d1.line_cd);
         EXIT;
      END LOOP;

      FOR d2 IN (SELECT 1
                   FROM gipi_wperil_discount
                  WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         gipi_wperil_discount_pkg.del_gipi_wperil_discount_1 (p_par_id,
                                                              p_item_no
                                                             );
         EXIT;
      END LOOP;

      FOR d3 IN (SELECT 1
                   FROM gipi_wdeductibles
                  WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         gipi_wdeductibles_pkg.del_gipi_wdeductibles_item_2 (p_par_id,
                                                             p_item_no
                                                            );
         EXIT;
      END LOOP;

      FOR d3 IN (SELECT 1
                   FROM gipi_wmortgagee
                  WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         gipi_wmortgagee_pkg.del_gipi_wmortgagee_item (p_par_id, p_item_no);
         EXIT;
      END LOOP;

      IF p_line_cd = 'MC'
      THEN
         gipi_wdeductibles_pkg.del_gipi_wdeductibles_item_2 (p_par_id,
                                                             p_item_no
                                                            );
         gipi_wmcacc_pkg.del_gipi_wmcacc (p_par_id, p_item_no);
         gipi_wvehicle_pkg.del_gipi_wvehicle (p_par_id, p_item_no);
      ELSIF p_line_cd = 'FI'
      THEN
         gipi_wfireitm_pkg.del_gipi_wfireitm (p_par_id, p_item_no);
      ELSIF p_line_cd = 'MN'
      THEN
         gipi_wcargo_carrier_pkg.del_gipi_wcargo_carrier (p_par_id,
                                                          p_item_no);
         gipi_wcargo_pkg.del_gipi_wcargo (p_par_id, p_item_no);
      ELSIF p_line_cd = 'AV'
      THEN
         gipi_waviation_item_pkg.del_gipi_waviation_item (p_par_id,
                                                          p_item_no);
      ELSIF p_line_cd = 'CA'
      THEN
         gipi_wgrouped_items_pkg.del_gipi_wgrouped_items (p_par_id,
                                                          p_item_no);
         gipi_wcasualty_personnel_pkg.del_gipi_wcasualty_personnel (p_par_id,
                                                                    p_item_no
                                                                   );
         gipi_wcasualty_item_pkg.del_gipi_wcasualty_item (p_par_id, p_item_no);
      ELSIF p_line_cd = 'AH' OR p_line_cd = 'AC' --added by steven 10.18.2013
      THEN
         gipi_witmperl_beneficiary_pkg.del_gipi_witmperl_benificiary
                                                                   (p_par_id,
                                                                    p_item_no
                                                                   );
         gipi_wgrp_item_beneficiary_pkg.del_gipi_wgrp_item_benificiary
                                                                    (p_par_id,
                                                                     p_item_no
                                                                    );
         gipi_witmperl_grouped_pkg.del_gipi_witmperl_grouped (p_par_id,
                                                              p_item_no
                                                             );
         gipi_wgrouped_items_pkg.del_gipi_wgrouped_items (p_par_id, p_item_no);
         gipi_wbeneficiary_pkg.del_gipi_wbeneficiary (p_par_id, p_item_no);
         gipi_waccident_item_pkg.del_gipi_waccident_item (p_par_id, p_item_no);
      ELSIF p_line_cd = 'MH'
      THEN
         gipi_witem_ves_pkg.del_gipi_witem_ves (p_par_id, p_item_no);
      END IF;
      --added by Gzelle 09152014
      FOR d4 IN (SELECT 1
                   FROM gipi_wpictures
                  WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         DELETE FROM gipi_wpictures
               WHERE par_id = p_par_id
                 AND item_no = p_item_no;
         EXIT;
      END LOOP;

   END pre_del_gipi_witem;

   /*
   **  Created by    : Emman
   **  Date Created  : 07.07.2010
   **  Reference By  : (GIPIS060 - Endt Item Information)
   **  Description   : This procedure delete records on GIPI_WITMPERL, GIPI_WPERIL_DISCOUNT,
   **               GIPI_WDEDUCTIBLES, GIPI_WMORTGAGEE, GIPI_WMCACC (based on par_id and item_no)
   */
   PROCEDURE pre_del_endt_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE,
      p_line_cd   gipi_wpolbas.line_cd%TYPE
   )
   IS
   BEGIN
      delete_discount (p_par_id);
      GIPI_WDEDUCTIBLES_PKG.del_gipi_wdeductibles_item_2(p_par_id, p_item_no);
      GIPI_WITMPERL_PKG.del_gipi_witmperl_1(p_par_id, p_item_no, p_line_cd);

      IF p_line_cd = 'MC' THEN
           GIPI_WMCACC_PKG.del_gipi_wmcacc(p_par_id, p_item_no);
         GIPI_WVEHICLE_PKG.del_gipi_wvehicle(p_par_id, p_item_no);
         GIPI_WMORTGAGEE_PKG.del_gipi_wmortgagee_item(p_par_id, p_item_no);
         GIPI_WPERIL_DISCOUNT_PKG.del_gipi_wperil_discount_1(p_par_id, p_item_no);
      ELSIF p_line_cd = 'FI' THEN
           GIPI_WFIREITM_PKG.del_gipi_wfireitm(p_par_id, p_item_no);
         GIPI_WPERIL_DISCOUNT_PKG.del_gipi_wperil_discount_1(p_par_id, p_item_no);
      END IF;
   END pre_del_endt_gipi_witem;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.26.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : This procedure updates the par_status on GIPI_PARLIST
   **               if the conditions are met
   */
   PROCEDURE post_del_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_line_cd   gipi_parlist.line_cd%TYPE,
      p_iss_cd    gipi_parlist.iss_cd%TYPE
   )
   IS
      p_count_item    NUMBER := 0;
      p_count_peril   NUMBER := 0;

      CURSOR a
      IS
         SELECT item_no
           FROM gipi_witem
          WHERE par_id = p_par_id;

      CURSOR b (p_item_no NUMBER)
      IS
         SELECT DISTINCT item_no
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id AND item_no = p_item_no;
   BEGIN
      FOR a1 IN a
      LOOP
         p_count_item := p_count_item + 1;

         FOR b1 IN b (a1.item_no)
         LOOP
            p_count_peril := p_count_peril + 1;
         END LOOP;
      END LOOP;

      IF p_count_peril = p_count_item
      THEN
         UPDATE gipi_parlist
            SET par_status = 5
          WHERE par_id = p_par_id AND line_cd = p_line_cd
                AND iss_cd = p_iss_cd;
      END IF;
   END post_del_gipi_witem;

   /*
   **  Created by   :  Menandro G.C. Robes
   **  Date Created :  February 03, 2010
   **  Reference By : (CHECK_WDEDUCTIBLE)
   **  Description  : This returns true if the par has items and false if the par has no item.
   */
   FUNCTION par_has_item (p_par_id gipi_wpolbas.par_id%TYPE)
                                                        --par_id to be checked
      RETURN BOOLEAN
   IS
      v_result   BOOLEAN := FALSE;
   BEGIN
      FOR a IN (SELECT item_no
                  FROM gipi_witem
                 WHERE par_id = p_par_id)
      LOOP
         v_result := TRUE;
         EXIT;
      END LOOP;

      RETURN v_result;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END par_has_item;

   /*
   **  Created by   :  Menandro G.C. Robes
   **  Date Created :  February 03, 2010
   **  Reference By : (CHECK_WDEDUCTIBLE)
   **  Description  : This returns par item/s without peril.
   */
   FUNCTION get_par_items_wo_peril (p_par_id gipi_wpolbas.par_id%TYPE)
                                                          --to limit the query
      RETURN VARCHAR2
   IS
      v_item_no   VARCHAR2 (12);
      v_items     VARCHAR2 (32767);
   BEGIN
      FOR i IN (SELECT   item_no
                    FROM gipi_witem
                   WHERE par_id = p_par_id
                     AND item_no NOT IN (SELECT item_no
                                           FROM gipi_witmperl
                                          WHERE par_id = p_par_id)
                ORDER BY 1)
      LOOP
         v_item_no := i.item_no;
         v_items := v_items || v_item_no || ', ';
      END LOOP;

      RETURN v_items;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_par_items_wo_peril;

   /*
   **  Created by   :  Menandro G.C. Robes
   **  Date Created :  February 03, 2010
   **  Reference By : (CHECK_WDEDUCTIBLE)
   **  Description  : This returns the count of different currencies used in the items of PAR.
   */
   FUNCTION get_par_items_currency_count (p_par_id gipi_witem.par_id%TYPE)
                                                          --to limit the query
      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      SELECT COUNT (DISTINCT currency_cd)
        INTO v_count
        FROM gipi_witem
       WHERE par_id = p_par_id;

      RETURN v_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_par_items_currency_count;

   FUNCTION get_par_items_curr_rt_count (p_par_id gipi_witem.par_id%TYPE)

      RETURN NUMBER
   IS
      v_count   NUMBER := 0;
   BEGIN
      SELECT COUNT (DISTINCT currency_rt)
        INTO v_count
        FROM gipi_witem
       WHERE par_id = p_par_id;

      RETURN v_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_par_items_curr_rt_count;

   /*
   **  Created by   :  Menandro G.C. Robes
   **  Date Created :  February 03, 2010
   **  Reference By : (GIPISA169 - Item Deductible)
   **  Description  : This returns the item records of the given par_id.
   */
   FUNCTION get_item_list1 (p_par_id gipi_witem.par_id%TYPE)
                                                   --par_id to limit the query
      RETURN item_list_tab PIPELINED
   IS
      v_item   item_list_type;
   BEGIN
      FOR i IN (SELECT   item_no, item_title
                    FROM gipi_witem
                   WHERE par_id = p_par_id
                ORDER BY item_no)
      LOOP
         v_item.item_no := i.item_no;
         v_item.item_title := i.item_title;
         PIPE ROW (v_item);
      END LOOP;

      RETURN;
   END get_item_list1;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  March 03, 2010
   **  Reference By : (GIPIS143 - Discount/Surcharge)
   **  Description  : This returns the item records of the given par_id.
   */
   FUNCTION get_item_list2 (p_par_id gipi_witem.par_id%TYPE)
                                                   --par_id to limit the query
      RETURN item_list_tab PIPELINED
   IS
      v_item   item_list_type;
   BEGIN
      FOR i IN (SELECT   a.item_no, a.item_title
                    FROM gipi_witem a
                   WHERE a.par_id = p_par_id
                     AND EXISTS (
                            SELECT '1'
                              FROM gipi_witmperl b
                             WHERE b.par_id = a.par_id
                               AND b.item_no = a.item_no)
                ORDER BY 1, 2)
      LOOP
         v_item.item_no := i.item_no;
         v_item.item_title := i.item_title;
         PIPE ROW (v_item);
      END LOOP;

      RETURN;
   END get_item_list2;

   /*
   **  Created by   :  Bryan Joseph G. Abuluyan
   **  Date Created :  February 26, 2010
   **  Reference By : (GIPIS038 - For deleting discount)
   **  Description  : Updates the rate amounts for items after deleting discounts
   */
   PROCEDURE set_amts (
      p_par_id         gipi_witem.par_id%TYPE,
      p_item_no        gipi_witem.item_no%TYPE,
      p_prem_amt       gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_witem
         SET prem_amt = p_prem_amt,
             ann_prem_amt = p_ann_prem_amt
       WHERE par_id = p_par_id AND item_no = p_item_no;
   END set_amts;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 03.08.2010
   **  Reference By  : (GIPI003 - Item Information - FIRE)
   **  Description   : This procedure returns the maximum risk_item_no based on par_id and risk_no
   */
   FUNCTION get_max_risk_item_no (
      p_par_id    gipi_witem.par_id%TYPE,
      p_risk_no   gipi_witem.risk_no%TYPE
   )
      RETURN NUMBER
   IS
      v_max_risk_item_no   gipi_witem.risk_item_no%TYPE;
   BEGIN
      SELECT MAX (NVL (risk_item_no, 0)) + 1
        INTO v_max_risk_item_no
        FROM gipi_witem
       WHERE par_id = p_par_id AND risk_no = p_risk_no;

      RETURN v_max_risk_item_no;
   END get_max_risk_item_no;

   PROCEDURE update_item_value (
      p_tsi_amt        gipi_witem.tsi_amt%TYPE,
      p_prem_amt       gipi_witem.prem_amt%TYPE,
      p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE,
      p_par_id         gipi_witem.par_id%TYPE,
      p_item_no        gipi_witem.item_no%TYPE)
   IS
   BEGIN
      UPDATE gipi_witem
         SET tsi_amt = p_tsi_amt,
             prem_amt = p_prem_amt,
             ann_tsi_amt = p_ann_tsi_amt,
             ann_prem_amt = p_ann_prem_amt
       WHERE par_id = p_par_id AND item_no = p_item_no;
   END update_item_value;

   /*
    **  Created by   :  Bryan Joseph G. Abuluyan
    **  Date Created :  February 26, 2010
    **  Reference By : (GIPIS038 - Peril Information
    **  Description  : Updates the rate amounts for items after updating
    */
   PROCEDURE set_tsi (
      p_par_id        gipi_witem.par_id%TYPE,
      p_item_no       gipi_witem.item_no%TYPE,
      p_tsi_amt       gipi_witem.tsi_amt%TYPE,
      p_ann_tsi_amt   gipi_witem.ann_tsi_amt%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_witem
         SET tsi_amt = p_tsi_amt,
             ann_tsi_amt = p_ann_tsi_amt
       WHERE par_id = p_par_id AND item_no = p_item_no;
   END set_tsi;

   /*
     **  Created by   :  Bryan Joseph G. Abuluyan
     **  Date Created :  March 09, 2010
     **  Reference By : (GIPIS038 - Peril Information
     **  Description  : Updates WPOLBASI table from WITEM changes
     */
   PROCEDURE update_wpolbas (p_par_id IN gipi_witem.par_id%TYPE)
   IS
     v_item_count         NUMBER(5) := 0;
   BEGIN
      FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0) * NVL (currency_rt, 1)) tsi,
                        SUM (NVL (prem_amt, 0) * NVL (currency_rt, 1)) prem,
                        SUM (NVL (ann_tsi_amt, 0) * NVL (currency_rt, 1)
                            ) ann_tsi,
                        SUM (NVL (ann_prem_amt, 0) * NVL (currency_rt, 1)
                            ) ann_prem
                   FROM gipi_witem
                  WHERE par_id = p_par_id)
      LOOP
           v_item_count := v_item_count + 1;
         gipi_wpolbas_pkg.update_wpolbasic (p_par_id,
                                            a1.tsi,
                                            a1.prem,
                                            a1.ann_tsi,
                                            a1.ann_prem
                                           );
         EXIT;
      END LOOP;

      IF v_item_count = 0 THEN
           gipi_wpolbas_pkg.update_wpolbasic (p_par_id,
                                            0,
                                            0,
                                            0,
                                            0
                                           );
      END IF;

   END;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (SET_LIMIT_INTO_GIPI_WITEM)
**  Description  : Procedure to update witem tsi amount and currency.
*/
   PROCEDURE update_tsi_and_currency (
      p_wopen_liab   IN   gipi_wopen_liab%ROWTYPE,
      p_item_no      IN   gipi_witem.item_no%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_witem
         SET tsi_amt = p_wopen_liab.limit_liability,
             ann_tsi_amt = p_wopen_liab.limit_liability,
             currency_cd = p_wopen_liab.currency_cd,
             currency_rt = p_wopen_liab.currency_rt
       WHERE par_id = p_wopen_liab.par_id AND item_no = p_item_no;
   END update_tsi_and_currency;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (SET_LIMIT_INTO_GIPI_WITEM)
**  Description  : Procedure to insert wopen_liab record into gipi_witem.
*/
   PROCEDURE insert_limit (p_wopen_liab IN gipi_wopen_liab%ROWTYPE)
   IS
   BEGIN
      INSERT INTO gipi_witem
                  (par_id, item_no, item_grp,
                   item_title,
                   tsi_amt, prem_amt,
                   ann_tsi_amt, ann_prem_amt,
                   currency_cd, currency_rt
                  )
           VALUES (p_wopen_liab.par_id, 1, 1,
                   'Open policy limit of liability',
                   p_wopen_liab.limit_liability, 0,
                   p_wopen_liab.limit_liability, 0,
                   p_wopen_liab.currency_cd, p_wopen_liab.currency_rt
                  );
   END insert_limit;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  May 31, 2010
   **  Reference By :
   **  Description  : to get the sum of tsi and prem amt not equal to the item selected
   */
   FUNCTION get_tsi_prem_amt (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN item_tsi_prem_tab PIPELINED
   IS
      v_witem   item_tsi_prem_type;
   BEGIN
      SELECT NVL (SUM (NVL (tsi_amt, 0)), 0) tsi_amt,
             NVL (SUM (NVL (prem_amt, 0)), 0) prem_amt
        INTO v_witem.tsi_amt,
             v_witem.prem_amt
        FROM gipi_witem
       WHERE par_id = p_par_id AND item_no != p_item_no;

      PIPE ROW (v_witem);
   END;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 06.03.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This procedure returns the tsi_amt and prem_amt multiply by the currency rate
   */
   PROCEDURE get_tsi_prem_amt (
      p_par_id     IN       gipi_witem.par_id%TYPE,
      p_tsi_amt    OUT      gipi_witem.tsi_amt%TYPE,
      p_prem_amt   OUT      gipi_witem.prem_amt%TYPE
   )
   IS
      v_tsi_amt    NUMBER;
      v_prem_amt   NUMBER;
   BEGIN
      FOR upd_polbas IN (SELECT SUM (tsi_amt * currency_rt) tsi,
                                SUM (prem_amt * currency_rt) prem
                           FROM gipi_witem
                          WHERE par_id = p_par_id)
      LOOP
         v_tsi_amt := upd_polbas.tsi;
         v_prem_amt := upd_polbas.prem;
      END LOOP;

      p_tsi_amt := v_tsi_amt;
      p_prem_amt := v_prem_amt;
   END get_tsi_prem_amt;

/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_gipi_witem (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_par_id     gipi_witem.par_id%TYPE
   )
   IS
      v_item_no           gipi_witem.item_no%TYPE;
      v_item_group        gipi_witem.item_grp%TYPE;
      v_item_title        gipi_witem.item_title%TYPE;
      v_item_desc         gipi_witem.item_desc%TYPE;
      v_tsi_amt           gipi_witem.tsi_amt%TYPE;
      v_prem_amt          gipi_witem.prem_amt%TYPE;
      v_ann_prem          gipi_witem.ann_prem_amt%TYPE;
      v_ann_tsi           gipi_witem.ann_tsi_amt%TYPE;
      v_rec_stat          gipi_witem.rec_flag%TYPE;
      v_currency_cd       gipi_witem.currency_cd%TYPE;
      v_currency_rt       gipi_witem.currency_rt%TYPE;
      v_group_cd          gipi_witem.group_cd%TYPE;
      v_from_date         gipi_witem.from_date%TYPE;
      v_to_date           gipi_witem.TO_DATE%TYPE;
      v_discount_sw       gipi_witem.discount_sw%TYPE;
      v_other_info        gipi_witem.other_info%TYPE;
      v_pack_line_cd      gipi_witem.pack_line_cd%TYPE;
      v_pack_subline_cd   gipi_witem.pack_subline_cd%TYPE;
      v_coverage_cd       gipi_witem.coverage_cd%TYPE;
      v_mc_motor_no       gipi_quote_item.mc_motor_no%TYPE;
      v_mc_serial_no      gipi_quote_item.mc_serial_no%TYPE;
      v_mc_plate_no       gipi_quote_item.mc_plate_no%TYPE;
      --added by annabelle 10.24.05
      v_ann_prem_amt      gipi_quote_item.ann_prem_amt%TYPE;
      v_ann_tsi_amt       gipi_quote_item.ann_tsi_amt%TYPE;
      v_region_cd         gipi_quote_item.region_cd%TYPE;
      p_group_no          gipi_wgrouped_items.grouped_item_no%TYPE;
      p_count             NUMBER;
      v_par_id            NUMBER;

       /*cursor cur_A is select item_no,item_title,item_desc,tsi_amt,prem_amt,
                            b.main_currency_cd CURRENCY_CD,b.currency_rt CURRENCY_RT,
                            pack_line_cd,pack_subline_cd, date_from, date_to, coverage_cd,
                            --added by annbelle 10.24.05
                            a.ann_prem_amt, a.ann_tsi_amt, a.region_cd
                        from gipi_quote_item a, giis_currency b
                       WHERE a.currency_cd = b.main_currency_cd and
                             a.currency_rate = b.currency_rt and
                             QUOTE_ID = :B240.QUOTE_ID; */
      -- added by: Jenny Vi Lim 5/27/2004
      CURSOR cur_b
      IS
         SELECT mc_motor_no, mc_serial_no, mc_plate_no
           FROM gipi_quote_item
          WHERE quote_id = p_quote_id;
   BEGIN
      OPEN cur_b;

      FETCH cur_b
       INTO v_mc_motor_no, v_mc_serial_no, v_mc_plate_no;

      CLOSE cur_b;

      BEGIN
         SELECT item_grp
           INTO v_item_group
           FROM gipi_witem
          WHERE pack_line_cd = v_pack_line_cd
            AND pack_subline_cd = v_pack_subline_cd
            AND currency_cd = v_currency_cd
            AND currency_rt = v_currency_rt;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               --v_item_no         := 1;
               FOR d IN (SELECT par_id, quote_id
                           FROM gipi_parlist
                          WHERE pack_par_id = p_par_id)
               LOOP
                  SELECT line_cd, subline_cd
                    INTO v_pack_line_cd, v_pack_subline_cd
                    FROM gipi_quote
                   WHERE quote_id = d.quote_id;

                  FOR a IN (SELECT   item_no, item_title, item_desc, tsi_amt,
                                     prem_amt, b.main_currency_cd currency_cd,
                                     b.currency_rt currency_rt, pack_line_cd,
                                     pack_subline_cd, date_from, date_to,
                                     coverage_cd,
                                                 --added by annbelle 10.24.05
                                                 a.ann_prem_amt,
                                     a.ann_tsi_amt, a.region_cd
                                FROM gipi_quote_item a, giis_currency b
                               WHERE a.currency_cd = b.main_currency_cd
                                 AND a.currency_rate = b.currency_rt
                                 AND quote_id = d.quote_id
                            ORDER BY quote_id, item_no)
                  LOOP
                     v_par_id        := d.par_id;
                     v_item_no       := a.item_no;
                     v_item_title    := a.item_title;
                     v_item_desc     := a.item_desc;
                     v_tsi_amt       := a.tsi_amt;
                     v_prem_amt      := a.prem_amt;
                     v_currency_cd   := a.currency_cd;
                     v_currency_rt   := a.currency_rt;
                     v_coverage_cd   := a.coverage_cd;
                     v_rec_stat      := NULL;
                     v_group_cd      := NULL;
                     v_from_date     := a.date_from;
                     v_to_date       := a.date_to;
                     v_discount_sw   := 'N';
                     v_other_info    := NULL;
                     v_ann_prem_amt  := a.ann_prem_amt;
                     v_ann_tsi_amt   := a.ann_tsi_amt;
                     v_region_cd     := a.region_cd;

                     SELECT NVL (MAX (item_grp), 0)
                       INTO p_group_no
                       FROM gipi_witem
                      WHERE pack_line_cd = v_pack_line_cd
                        AND pack_subline_cd = v_pack_subline_cd
                        AND currency_cd = v_currency_cd
                        AND currency_rt = v_currency_rt;

                     --v_item_group := NVL(p_group_no,0) +  1;
                     v_item_group := 1;

                     INSERT INTO gipi_witem
                                 (par_id, item_no, item_grp,
                                  item_title, item_desc, tsi_amt,
                                  prem_amt, ann_tsi_amt, ann_prem_amt,
                                  rec_flag, currency_cd, currency_rt,
                                  group_cd, from_date, TO_DATE,
                                  pack_line_cd, pack_subline_cd,
                                  discount_sw, other_info, coverage_cd,
                                  region_cd
                                 )
                          VALUES (v_par_id, v_item_no, v_item_group,
                                  v_item_title, v_item_desc, v_tsi_amt,
                                  v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,
                                  v_rec_stat, v_currency_cd, v_currency_rt,
                                  v_group_cd, v_from_date, v_to_date,
                                  v_pack_line_cd, v_pack_subline_cd,
                                  v_discount_sw, v_other_info, v_coverage_cd,
                                  v_region_cd
                                 );
  --COMMIT;
  -- CLEAR_MESSAGE;
--  v_item_no := v_item_no + 1;
                  END LOOP;
               END LOOP;
            -- END LOOP;
            END;
      END;
   END;
-- end of whofeih
/***************************************************************************/

   /*
   **  Created by    : Emman
   **  Date Created  : 06.22.2010
   **  Reference By  : (GIPIS060 - Endt Item Information)
   **  Description   : Gets the distinct item no in gipi_item that doesn't exist in gipi_witem
   **                     Used in getting the available items for Add Items procedure in the module
   */
   FUNCTION get_distinct_gipi_item (p_par_id        GIPI_WITEM.par_id%TYPE)
   RETURN item_no_tab PIPELINED
   IS
        v_item_no        item_no_type;
   BEGIN
        FOR b540 IN (SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no, eff_date
                        FROM gipi_wpolbas
                   WHERE par_id = p_par_id) LOOP
         FOR a IN (SELECT distinct item_no item_no
                      FROM gipi_polbasic a, gipi_item b
                     WHERE a.line_cd = b540.line_cd
                       AND a.iss_cd      =  b540.iss_cd
                       AND a.subline_cd  =  b540.subline_cd
                       AND a.issue_yy    =  b540.issue_yy
                       AND a.pol_seq_no  =  b540.pol_seq_no
                       AND a.renew_no    =  b540.renew_no
                       AND a.pol_flag    IN( '1','2','3','X')
                       AND a.policy_id = b.policy_id
                       AND TRUNC(a.eff_date)  <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(b540.eff_date))
                       AND NVL(a.endt_expiry_date,a.expiry_date) >=  b540.eff_date
                       AND not exists ( SELECT '1'
                                          FROM gipi_witem c
                                         WHERE c.par_id = p_par_id
                                           AND c.item_no = b.item_no))
          LOOP
                v_item_no.item_no := a.item_no;
              PIPE ROW (v_item_no);
          END LOOP;
     END LOOP;
     RETURN;
   END get_distinct_gipi_item;


   /*
   **  Created by    : Menandro G.C. Robes
   **  Date Created  : June 29, 2010
   **  Reference By  : (GIPIS097 - Endt Item Peril Information)
   **  Description   : Procedure to update amounts when the discount is to be deleted.
   */
   PROCEDURE update_gipi_witem_discount(p_par_id               GIPI_WITEM.par_id%TYPE,
                                        p_item_no              GIPI_WITEM.item_no%TYPE,
                                        p_disc_amt             GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
                                        p_orig_item_ann_prem_amt GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE)
   IS
   BEGIN
     UPDATE gipi_witem
        SET prem_amt     = prem_amt + p_disc_amt,
            ann_prem_amt = NVL(p_orig_item_ann_prem_amt, ann_prem_amt),
            discount_sw  = 'N'
      WHERE par_id   = p_par_id
        AND item_no  = p_item_no;

   END update_gipi_witem_discount;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 09.02.2010
    **  Reference By    : (GIPIS010 - Item Information)
    **  Description        : Returns the item_grp to be used
    **                    : when inserting new record to gipi_witem
    */
    FUNCTION get_item_grp (
        p_par_id            IN gipi_parlist.par_id%TYPE,
        p_pack_pol_flag        IN gipi_wpolbas.pack_pol_flag%TYPE,
        p_currency_cd        IN gipi_witem.currency_cd%TYPE)
    RETURN gipi_witem.item_grp%TYPE
    IS
        v_item_grp    gipi_witem.item_grp%TYPE   := 1;
        v_item_grp2    gipi_witem.item_grp%TYPE;
    BEGIN
        IF p_pack_pol_flag = 'Y' THEN
            FOR c1 IN (
                SELECT currency_cd, currency_rt, pack_line_cd,
                       pack_subline_cd
                  FROM gipi_witem
                 WHERE par_id = p_par_id
              GROUP BY currency_cd, currency_rt, pack_line_cd, pack_subline_cd
              ORDER BY currency_cd, currency_rt, pack_line_cd, pack_subline_cd)
            LOOP
                IF v_item_grp2 IS NULL THEN
                    IF p_currency_cd = c1.currency_cd THEN
                        v_item_grp2 := v_item_grp;
                    ELSIF p_currency_cd < c1.currency_cd THEN
                        v_item_grp2 := v_item_grp;
                        v_item_grp := v_item_grp + 1;
                    END IF;
                END IF;

                v_item_grp := v_item_grp + 1;
            END LOOP;
        ELSE
            FOR c2 IN (
                SELECT currency_cd, currency_rt
                  FROM gipi_witem
                 WHERE par_id = p_par_id
              GROUP BY currency_cd, currency_rt
              ORDER BY currency_cd, currency_rt)
            LOOP
                IF v_item_grp2 IS NULL THEN
                    IF p_currency_cd = c2.currency_cd THEN
                        v_item_grp2 := v_item_grp;
                    ELSIF p_currency_cd < c2.currency_cd THEN
                        v_item_grp2 := v_item_grp;
                        v_item_grp := v_item_grp + 1;
                    END IF;
                END IF;

                v_item_grp := v_item_grp + 1;
            END LOOP;
        END IF;

        RETURN v_item_grp2;
    END get_item_grp;

  /*
    **  Created by        : Bryan Joseph G. Abuluyan
    **  Date Created    : 10.01.2010
    **  Reference By    : (GIPIS081 - Item Information)
    **  Description        : Gets the items from GIPI_POLBASIC that will be added to GIPI_WITEM
    */
  FUNCTION get_endt_add_item_list(
                                    p_par_id                   GIPI_WITEM.par_id%TYPE,
                               p_item_no              GIPI_WITEM.item_no%TYPE,
                               p_line_cd              GIPI_WPOLBAS.line_cd%TYPE,
                               p_subline_cd              GIPI_WPOLBAS.subline_cd%TYPE,
                               p_iss_cd                  GIPI_WPOLBAS.iss_cd%TYPE,
                               p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
                               p_pol_seq_no              GIPI_WPOLBAS.pol_seq_no%TYPE,
                               p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
                               p_eff_date              GIPI_WPOLBAS.eff_date%TYPE)
    RETURN gipi_witem_tab PIPELINED
    IS
    v_item                  gipi_witem_type;
    v_new_item           VARCHAR2(1) := 'Y';
    expired_sw           VARCHAR2(1) := 'N';
    amt_sw               VARCHAR2(1) := 'N';
    v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
    v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;
    v_ann_tsi            gipi_witem.ann_tsi_amt%TYPE;
    v_ann_prem           gipi_witem.ann_prem_amt%TYPE;
    CURSOR A IS
       SELECT    a.policy_id
         FROM    gipi_polbasic a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          AND    a.pol_flag    IN( '1','2','3','X')
          --ASI 081299 add this validation so that data that will be retrieved
          --           is only those from endorsement prior to the current endorsement
          --           this was consider because of the backward endorsement
          AND    TRUNC(a.eff_date)  <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
          AND    TRUNC(NVL(a.endt_expiry_date,a.expiry_date)) >=  TRUNC(p_eff_date)
          AND    EXISTS (SELECT '1'
                           FROM gipi_item b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id)
     ORDER BY   eff_date DESC;
    CURSOR B(p_policy_id  gipi_item.policy_id%TYPE) IS
       SELECT    currency_cd,
                 currency_rt,
                 item_title,
                 ann_tsi_amt,
                 ann_prem_amt,
                 coverage_cd,
                 group_cd
         FROM    gipi_item
        WHERE    item_no   =    p_item_no
          AND    policy_id =    p_policy_id;
    CURSOR C(p_currency_cd giis_currency.main_currency_cd%TYPE) IS
       SELECT    currency_desc
         FROM    giis_currency
        WHERE    main_currency_cd  =  p_currency_cd;

    CURSOR D(p_policy_id gipi_polbasic.policy_id%TYPE) IS
       SELECT item_no,district_no,eq_zone,tarf_cd,block_no,block_id,fr_item_type
           ,loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd
           ,construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks
           ,flood_zone
         FROM gipi_fireitem
        WHERE policy_id = p_policy_id
          AND item_no = p_item_no;

     CURSOR E IS
       SELECT    a.policy_id
         FROM    gipi_polbasic a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          AND    a.pol_flag    IN( '1','2','3','X')
          AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
          AND    NVL(a.endt_expiry_date,a.expiry_date) >=  p_eff_date
          AND    NVL(a.back_stat,5) = 2
          AND    EXISTS (SELECT '1'
                           FROM gipi_item b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id)
          AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                    FROM gipi_polbasic c
                                   WHERE line_cd     =  p_line_cd
                                     AND iss_cd      =  p_iss_cd
                                     AND subline_cd  =  p_subline_cd
                                     AND issue_yy    =  p_issue_yy
                                     AND pol_seq_no  =  p_pol_seq_no
                                     AND renew_no    =  p_renew_no
                                     AND pol_flag  IN( '1','2','3','X')
                                     AND TRUNC(eff_date) <= DECODE(nvl(c.endt_seq_no,0),0,TRUNC(c.eff_date), TRUNC(p_eff_date))
                                     AND NVL(endt_expiry_date,expiry_date) >=  p_eff_date
                                     AND NVL(c.back_stat,5) = 2
                                     AND EXISTS (SELECT '1'
                                                   FROM gipi_item d
                                                  WHERE d.item_no = p_item_no
                                                    AND c.policy_id = d.policy_id))
     ORDER BY   eff_date desc;
  BEGIN
    FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
              FROM gipi_polbasic a
             WHERE line_cd     =  p_line_cd
               AND iss_cd      =  p_iss_cd
               AND subline_cd  =  p_subline_cd
               AND issue_yy    =  p_issue_yy
               AND pol_seq_no  =  p_pol_seq_no
               AND renew_no    =  p_renew_no
               AND pol_flag  IN( '1','2','3','X')
               AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
               AND NVL(endt_expiry_date,expiry_date) >=  p_eff_date
               AND EXISTS (SELECT '1'
                             FROM gipi_item b
                            WHERE b.item_no = p_item_no
                              AND a.policy_id = b.policy_id)) LOOP
      v_max_endt_seq_no := z.endt_seq_no;
      EXIT;
  END LOOP;
  FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
              FROM gipi_polbasic a
             WHERE line_cd     =  p_line_cd
               AND iss_cd      =  p_iss_cd
               AND subline_cd  =  p_subline_cd
               AND issue_yy    =  p_issue_yy
               AND pol_seq_no  =  p_pol_seq_no
               AND renew_no    =  p_renew_no
               AND pol_flag  IN( '1','2','3','X')
               AND TRUNC(eff_date) <= TRUNC(p_eff_date)
               AND NVL(endt_expiry_date,expiry_date) >=  p_eff_date
               AND NVL(a.back_stat,5) = 2
               AND EXISTS (SELECT '1'
                             FROM gipi_item b
                            WHERE b.item_no = p_item_no
                              AND a.policy_id = b.policy_id)) LOOP
      v_max_endt_seq_no1 := x.endt_seq_no;
      EXIT;
  END LOOP;
    expired_sw := 'N';
  FOR SW IN ( SELECT '1'
                FROM GIPI_ITMPERIL A,
                     GIPI_POLBASIC B
               WHERE B.line_cd      =  p_line_cd
                 AND B.subline_cd   =  p_subline_cd
                 AND B.iss_cd       =  p_iss_cd
                 AND B.issue_yy     =  p_issue_yy
                 AND B.pol_seq_no   =  p_pol_seq_no
                 AND B.renew_no     =  p_renew_no
                 AND B.policy_id    =  A.policy_id
                 AND B.pol_flag     in('1','2','3','X')
                 AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0)
                 AND A.item_no = p_item_no
                 AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                 AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(p_eff_date)
            ORDER BY B.eff_date DESC)
  LOOP
    expired_sw := 'Y';
    EXIT;
  END LOOP;
  amt_sw := 'N';
  IF expired_sw = 'N' THEN
       --get amount from the latest endt
       FOR ENDT IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                    FROM gipi_item a,
                         gipi_polbasic b
                   WHERE B.line_cd      =  p_line_cd
                     AND B.subline_cd   =  p_subline_cd
                     AND B.iss_cd       =  p_iss_cd
                     AND B.issue_yy     =  p_issue_yy
                     AND B.pol_seq_no   =  p_pol_seq_no
                     AND B.renew_no     =  p_renew_no
                     AND B.policy_id    =  A.policy_id
                     AND B.pol_flag     in('1','2','3','X')
                     AND A.item_no = p_item_no
                     AND TRUNC(B.eff_date)    <=  TRUNC(p_eff_date)
                     AND NVL(B.endt_expiry_date,B.expiry_date) >= p_eff_date
                     AND NVL(b.endt_seq_no, 0) > 0  -- to query records from endt. only
                ORDER BY B.eff_date DESC)
     LOOP
          v_ann_tsi  := endt.ann_tsi_amt;
       v_ann_prem := endt.ann_prem_amt;
       amt_sw := 'Y';
       EXIT;
     END LOOP;
     --no endt. records found, retrieved amounts from the policy
     IF amt_sw = 'N' THEN
           FOR POL IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                    FROM gipi_item a,
                         gipi_polbasic b
                   WHERE B.line_cd      =  p_line_cd
                     AND B.subline_cd   =  p_subline_cd
                     AND B.iss_cd       =  p_iss_cd
                     AND B.issue_yy     =  p_issue_yy
                     AND B.pol_seq_no   =  p_pol_seq_no
                     AND B.renew_no     =  p_renew_no
                     AND B.policy_id    =  A.policy_id
                     AND B.pol_flag     in('1','2','3','X')
                     AND A.item_no = p_item_no
                     AND NVL(b.endt_seq_no, 0) = 0)
        LOOP
             v_ann_tsi  := pol.ann_tsi_amt;
          v_ann_prem := pol.ann_prem_amt;
          EXIT;
        END LOOP;
     END IF;
  ELSE
     NULL;--EXTRACT_ANN_AMT2(v_item, v_ann_prem,  v_ann_tsi);
     EXTRACT_ANN_AMT2(p_line_cd,
                      p_subline_cd,
                      p_iss_cd,
                      p_issue_yy,
                      p_pol_seq_no,
                      p_renew_no,
                      p_eff_date,
                      p_item_no,
                      v_ann_prem,
                      v_ann_tsi);
  END IF;

  IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN
     FOR E1 IN E LOOP
       FOR B1 IN B(e1.policy_id) LOOP
           /*INSERT INTO gipi_witem
                     (par_id,         item_no,        item_title,       rec_flag,
                      currency_cd,    currency_rt,    coverage_cd,      group_cd,
                      ann_tsi_amt,    ann_prem_amt)
              VALUES (:b240.par_id,   v_item,         B1.item_title,    'C',
                      B1.currency_cd, B1.currency_rt, B1.coverage_cd,   B1.group_cd,
                      v_ann_tsi,      v_ann_prem);*/
           v_item.par_id  := p_par_id;
           v_item.item_no  := p_item_no;
           v_item.item_title := B1.item_title;
           v_item.rec_flag  := 'C';
           v_item.currency_cd  := B1.currency_cd;
           v_item.currency_rt  := B1.currency_rt;
           v_item.coverage_cd  := B1.coverage_cd;
           v_item.group_cd  := B1.group_cd;
           v_item.ann_tsi_amt  := v_ann_tsi;
           v_item.ann_prem_amt  := v_ann_prem;
           PIPE ROW(v_item);
       END LOOP;
       EXIT;
     END LOOP;
  ELSE
     FOR A1 IN A LOOP
       FOR B1 IN B(A1.policy_id) LOOP
              /*INSERT INTO gipi_witem
                     (par_id,         item_no,        item_title,       rec_flag,
                      currency_cd,    currency_rt,    coverage_cd,      group_cd,
                      ann_tsi_amt,    ann_prem_amt)
              VALUES (:b240.par_id,   v_item,         B1.item_title,    'C',
                      B1.currency_cd, B1.currency_rt, B1.coverage_cd,   B1.group_cd,
                      v_ann_tsi,      v_ann_prem);*/
           v_item.par_id  := p_par_id;
           v_item.item_no  := p_item_no;
           v_item.item_title := B1.item_title;
           v_item.rec_flag  := 'C';
           v_item.currency_cd  := B1.currency_cd;
           v_item.currency_rt  := B1.currency_rt;
           v_item.coverage_cd  := B1.coverage_cd;
           v_item.group_cd  := B1.group_cd;
           v_item.ann_tsi_amt  := v_ann_tsi;
           v_item.ann_prem_amt  := v_ann_prem;
           PIPE ROW(v_item);
       END LOOP;
       EXIT;
     END LOOP;
  END IF;
  RETURN;
  END get_endt_add_item_list;

  /*
  **  Created by        : Bryan Joseph G. Abuluyan
  **  Date Created    : 10.14.2010
  **  Reference By    : (GIPIS038 - Peril Information)
  **  Description        : Updates TSI and Prem amt in GIPI_WITEM  based on GIPI_WITMPERL details
  */
  PROCEDURE update_amt_details(p_par_id GIPI_WITEM.par_id%TYPE,
                               p_item_no gipi_witem.item_no%TYPE)
    IS
  BEGIN
    FOR i IN (SELECT SUM(NVL(prem_amt,0)) prem,
                     SUM(NVL(ann_prem_amt,0)) ann_prem
                FROM GIPI_WITMPERL
               WHERE par_id  =  p_par_id
                 AND item_no = p_item_no)
    LOOP
      UPDATE gipi_witem
         SET prem_amt = NVL(i.prem, 0),
             ann_prem_amt = NVL(i.ann_prem, 0)
       WHERE par_id = p_par_id
         AND item_no = p_item_no;
    END LOOP;

    FOR j IN (SELECT SUM(NVL(a.tsi_amt,0)) tsi,
                     SUM(NVL(a.ann_tsi_amt,0)) ann_tsi
                FROM GIPI_WITMPERL a,GIIS_PERIL b
               WHERE a.line_cd = b.line_cd
                 AND a.peril_cd = b.peril_cd
                 AND b.peril_type = 'B'
                 AND a.par_id = p_par_id
                 AND a.item_no = p_item_no)
    LOOP
      UPDATE gipi_witem
         SET tsi_amt = NVL(j.tsi, 0),
             ann_tsi_amt = NVL(j.ann_tsi, 0)
       WHERE par_id = p_par_id
         AND item_no = p_item_no;
    END LOOP;

    GIPI_WITEM_PKG.update_wpolbas(p_par_id);
  END update_amt_details;

  /*
  **  Created by :       Veronica V. Raymundo
  **  Date Created:     10.22.2010
  **  Reference By:     (GIPIS025 - Bill Grouping)
  **  Description:      Updates item_grp in GIPI_WITEM
  */
    Procedure update_item_groups(p_par_id     GIPI_WITEM.par_id%TYPE,
                               p_item_grp   GIPI_WITEM.item_grp%TYPE,
                               p_item_no    GIPI_WITEM.item_no%TYPE)
    IS
    BEGIN

        UPDATE gipi_witem
            SET item_grp = p_item_grp
            WHERE par_id = p_par_id AND item_no = p_item_no;
    END update_item_groups;

  /*
  **  Created by :       Jerome Orio
  **  Date Created:     11.09.2010
  **  Reference By:     (GIPIS002 - Basic Information)
  **  Description:      check if records exist in GIPI_WITEM
  */
    FUNCTION get_gipi_witem_exist (p_par_id    GIPI_WPOLBAS.par_id%TYPE)
    RETURN VARCHAR2 IS
      v_exist       VARCHAR2(1) := 'N';
    BEGIN
      FOR A2 IN (
           SELECT item_no
             FROM gipi_witem
            WHERE par_id  =  p_par_id)
      LOOP
        v_exist := 'Y';
      END LOOP;
      RETURN v_exist;
    END;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 12.03.2010
    **  Reference By     : (GIPIS010 - Item Information - Motorcar)
    **  Description     : This procedure retrieves record on GIPI_WITEM based on the given par_id
    */
    FUNCTION get_gipi_witem_for_par (p_par_id IN gipi_witem.par_id%TYPE)
    RETURN gipi_witem_par_tab PIPELINED
    IS
        v_gipi_witem gipi_witem_par_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.item_title,    a.item_grp,            a.item_desc,
                   a.item_desc2,    a.tsi_amt,        a.prem_amt,        a.ann_prem_amt,        a.ann_tsi_amt,
                   a.rec_flag,        a.currency_cd,    a.currency_rt,    b.currency_desc,    a.group_cd,
                   a.from_date,        a.to_date,        a.pack_line_cd,    a.pack_subline_cd,    a.discount_sw,
                   a.coverage_cd,    a.other_info,    a.surcharge_sw,    a.region_cd,        a.risk_no,
                   a.risk_item_no,  a.prorate_flag, a.comp_sw, a.payt_terms,
                   a.changed_tag -- added by andrew, 08.08.2011
              FROM gipi_witem a,
                   giis_currency b
             WHERE a.par_id = p_par_id
               AND a.currency_cd = b.main_currency_cd (+))
        LOOP
            v_gipi_witem.par_id                := i.par_id;
            v_gipi_witem.item_no            := i.item_no;
            v_gipi_witem.item_title            := i.item_title;
            v_gipi_witem.item_grp            := i.item_grp;
            v_gipi_witem.item_desc            := i.item_desc;
            v_gipi_witem.item_desc2            := i.item_desc2;
            v_gipi_witem.tsi_amt            := i.tsi_amt;
            v_gipi_witem.prem_amt            := i.prem_amt;
            v_gipi_witem.ann_prem_amt        := i.ann_prem_amt;
            v_gipi_witem.ann_tsi_amt        := i.ann_tsi_amt;
            v_gipi_witem.rec_flag            := i.rec_flag;
            v_gipi_witem.currency_cd        := i.currency_cd;
            v_gipi_witem.currency_rt        := i.currency_rt;
            v_gipi_witem.currency_desc        := i.currency_desc;
            v_gipi_witem.group_cd            := i.group_cd;
            v_gipi_witem.from_date            := i.from_date;
            v_gipi_witem.to_date            := i.to_date;
            v_gipi_witem.pack_line_cd        := i.pack_line_cd;
            v_gipi_witem.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_witem.discount_sw        := i.discount_sw;
            v_gipi_witem.coverage_cd        := i.coverage_cd;
            v_gipi_witem.other_info         := i.other_info;
            v_gipi_witem.surcharge_sw       := i.surcharge_sw;
            v_gipi_witem.region_cd          := i.region_cd;
            v_gipi_witem.risk_no            := i.risk_no;
            v_gipi_witem.risk_item_no       := i.risk_item_no;
            v_gipi_witem.prorate_flag       := i.prorate_flag;
            v_gipi_witem.comp_sw            := i.comp_sw;
            v_gipi_witem.payt_terms         := i.payt_terms;
            v_gipi_witem.changed_tag        := i.changed_tag;

            PIPE ROW(v_gipi_witem);
        END LOOP;

        RETURN;
    END get_gipi_witem_for_par;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.17.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : This procedure retrieves record on GIPI_WITEM based on the given pack_par_id
    */
    FUNCTION get_gipi_witem_for_pack_policy (p_pack_par_id IN gipi_parlist.pack_par_id%TYPE)
    RETURN gipi_witem_par_tab PIPELINED
    IS
        v_gipi_witem gipi_witem_par_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.item_title,    a.item_grp,            a.item_desc,
                   a.item_desc2,    a.tsi_amt,        a.prem_amt,        a.ann_prem_amt,        a.ann_tsi_amt,
                   a.rec_flag,        a.currency_cd,    a.currency_rt,    b.currency_desc,    a.group_cd,
                   a.from_date,        a.to_date,        a.pack_line_cd,    a.pack_subline_cd,    a.discount_sw,
                   a.coverage_cd,    a.other_info,    a.surcharge_sw,    a.region_cd,        a.risk_no,
                   a.risk_item_no,  a.prorate_flag, a.comp_sw, a.payt_terms
              FROM gipi_witem a,
                   giis_currency b
             WHERE a.currency_cd = b.main_currency_cd (+)
               AND EXISTS (SELECT 1
                             FROM gipi_parlist gp
                            WHERE gp.par_id = a.par_id
                              AND gp.pack_par_id = p_pack_par_id))
        LOOP
            v_gipi_witem.par_id                := i.par_id;
            v_gipi_witem.item_no            := i.item_no;
            v_gipi_witem.item_title            := i.item_title;
            v_gipi_witem.item_grp            := i.item_grp;
            v_gipi_witem.item_desc            := i.item_desc;
            v_gipi_witem.item_desc2            := i.item_desc2;
            v_gipi_witem.tsi_amt            := i.tsi_amt;
            v_gipi_witem.prem_amt            := i.prem_amt;
            v_gipi_witem.ann_prem_amt        := i.ann_prem_amt;
            v_gipi_witem.ann_tsi_amt        := i.ann_tsi_amt;
            v_gipi_witem.rec_flag            := i.rec_flag;
            v_gipi_witem.currency_cd        := i.currency_cd;
            v_gipi_witem.currency_rt        := i.currency_rt;
            v_gipi_witem.currency_desc        := i.currency_desc;
            v_gipi_witem.group_cd            := i.group_cd;
            v_gipi_witem.from_date            := i.from_date;
            v_gipi_witem.to_date            := i.to_date;
            v_gipi_witem.pack_line_cd        := i.pack_line_cd;
            v_gipi_witem.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_witem.discount_sw        := i.discount_sw;
            v_gipi_witem.coverage_cd        := i.coverage_cd;
            v_gipi_witem.other_info         := i.other_info;
            v_gipi_witem.surcharge_sw       := i.surcharge_sw;
            v_gipi_witem.region_cd          := i.region_cd;
            v_gipi_witem.risk_no            := i.risk_no;
            v_gipi_witem.risk_item_no       := i.risk_item_no;
            v_gipi_witem.prorate_flag       := i.prorate_flag;
            v_gipi_witem.comp_sw            := i.comp_sw;
            v_gipi_witem.payt_terms            := i.payt_terms;

            PIPE ROW(v_gipi_witem);
        END LOOP;
    END get_gipi_witem_for_pack_policy;

    /*
    **  Created by       : Veronica V. Raymundo
    **  Date Created    : 07.19.2011
    **  Reference By   : (GIPIS096 - Package Endt Policy Items)
    **  Description    : This procedure retrieves record on GIPI_WITEM based on the given pack_par_id
    **                    excluding from that of the deleted or cancelled PAR under the package
    */
    FUNCTION get_gipi_witem_for_pack_pol (p_pack_par_id IN gipi_parlist.pack_par_id%TYPE)
    RETURN gipi_witem_par_tab PIPELINED
    IS
        v_gipi_witem gipi_witem_par_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.item_title,      a.item_grp,            a.item_desc,
                   a.item_desc2,    a.tsi_amt,        a.prem_amt,        a.ann_prem_amt,        a.ann_tsi_amt,
                   a.rec_flag,      a.currency_cd,    a.currency_rt,     b.currency_desc,       a.group_cd,
                   a.from_date,     a.to_date,        a.pack_line_cd,    a.pack_subline_cd,     a.discount_sw,
                   a.coverage_cd,   a.other_info,     a.surcharge_sw,    a.region_cd,           a.risk_no,
                   a.risk_item_no,  a.prorate_flag,   a.comp_sw,         a.payt_terms
              FROM GIPI_WITEM a,
                   GIIS_CURRENCY b
             WHERE a.currency_cd = b.main_currency_cd (+)
               AND EXISTS (SELECT 1
                             FROM GIPI_PARLIST gp
                            WHERE gp.par_id = a.par_id
                              AND gp.par_status NOT IN (98,99)
                              AND gp.pack_par_id = p_pack_par_id))
        LOOP
            v_gipi_witem.par_id             := i.par_id;
            v_gipi_witem.item_no            := i.item_no;
            v_gipi_witem.item_title         := i.item_title;
            v_gipi_witem.item_grp           := i.item_grp;
            v_gipi_witem.item_desc          := i.item_desc;
            v_gipi_witem.item_desc2         := i.item_desc2;
            v_gipi_witem.tsi_amt            := i.tsi_amt;
            v_gipi_witem.prem_amt           := i.prem_amt;
            v_gipi_witem.ann_prem_amt       := i.ann_prem_amt;
            v_gipi_witem.ann_tsi_amt        := i.ann_tsi_amt;
            v_gipi_witem.rec_flag           := i.rec_flag;
            v_gipi_witem.currency_cd        := i.currency_cd;
            v_gipi_witem.currency_rt        := i.currency_rt;
            v_gipi_witem.currency_desc      := i.currency_desc;
            v_gipi_witem.group_cd           := i.group_cd;
            v_gipi_witem.from_date          := i.from_date;
            v_gipi_witem.to_date            := i.to_date;
            v_gipi_witem.pack_line_cd       := i.pack_line_cd;
            v_gipi_witem.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_witem.discount_sw        := i.discount_sw;
            v_gipi_witem.coverage_cd        := i.coverage_cd;
            v_gipi_witem.other_info         := i.other_info;
            v_gipi_witem.surcharge_sw       := i.surcharge_sw;
            v_gipi_witem.region_cd          := i.region_cd;
            v_gipi_witem.risk_no            := i.risk_no;
            v_gipi_witem.risk_item_no       := i.risk_item_no;
            v_gipi_witem.prorate_flag       := i.prorate_flag;
            v_gipi_witem.comp_sw            := i.comp_sw;
            v_gipi_witem.payt_terms         := i.payt_terms;

            PIPE ROW(v_gipi_witem);
        END LOOP;
    END get_gipi_witem_for_pack_pol;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  :  This determines whether Package PAR's sub-policies have
**                    existing records in GIPI_WITEM.
*/

FUNCTION check_gipi_witem_for_pack (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2 IS
      v_exist       VARCHAR2(1) := 'N';
    BEGIN
      FOR A2 IN (
           SELECT item_no
             FROM gipi_witem
            WHERE EXISTS (SELECT 1
                          FROM gipi_parlist z
                          WHERE z.par_id = gipi_witem.par_id
                          AND z.par_status NOT IN (98,99)
                          AND z.pack_par_id = p_pack_par_id))
      LOOP
        v_exist := 'Y';
      END LOOP;

      RETURN v_exist;
END;
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.28.2011
    **  Reference By     : (GIPIS095 - Package Policy Items)
    **  Description     : Returns selective column records based on the given pack_par_id
    */
    FUNCTION get_package_records (p_pack_par_id IN gipi_parlist.pack_par_id%TYPE)
    RETURN gipi_witem_par_tab PIPELINED
    IS
        v_pack_records gipi_witem_par_type;
    BEGIN
        FOR i IN (
            SELECT b.par_id, b.pack_line_cd, b.pack_subline_cd
              FROM gipi_parlist a, gipi_witem b
             WHERE pack_par_id = p_pack_par_id
               AND a.par_id = b.par_id
               AND b.pack_line_cd IN (SELECT a.pack_line_cd
                                        FROM giis_pack_plan_cover a, gipi_pack_wpolbas b
                                       WHERE a.plan_cd = b.plan_cd
                                         AND b.pack_par_id = p_pack_par_id)
               AND b.pack_subline_cd IN (SELECT a.pack_subline_cd
                                           FROM giis_pack_plan_cover a, gipi_pack_wpolbas b
                                          WHERE a.plan_cd = b.plan_cd
                                            AND b.pack_par_id = p_pack_par_id))
        LOOP
            v_pack_records.par_id             := i.par_id;
            v_pack_records.pack_line_cd     := i.pack_line_cd;
            v_pack_records.pack_subline_cd     := i.pack_subline_cd;

            PIPE ROW(v_pack_records);
        END LOOP;

        RETURN;
    END get_package_records;

    FUNCTION check_item_exist(p_par_id      GIPI_WITEM.par_id%TYPE)
    RETURN NUMBER

    IS
        v_item_count    NUMBER(3) := 0;
    BEGIN
        FOR ITEM IN(SELECT '1'
                      FROM gipi_witem
                     WHERE par_id = p_par_id)
        LOOP
            v_item_count := v_item_count + 1;
        END LOOP;
        RETURN v_item_count;
    END check_item_exist;

    /*    Date        Author                  Description
    **    ==========    ====================    ===================
    **    xx.xx.xxxx    mark jm                 created get_gipi_witem_for_par_tg
    **    08.08.2011    andrew                    added change_tag column
    **    09.28.2011    mark jm                    added short_rt_percent column
    **    09.29.2011    mark jm                    added pack_ben_cd column
    */
    FUNCTION get_gipi_witem_for_par_tg (
        p_par_id IN gipi_witem.par_id%TYPE,
        p_item_no IN gipi_witem.item_no%TYPE,
        p_item_title IN gipi_witem.item_title%TYPE,
        p_item_desc IN gipi_witem.item_desc%TYPE,
        p_item_desc2 IN gipi_witem.item_desc2%TYPE)
    RETURN gipi_witem_par_tab PIPELINED
    IS
        v_gipi_witem gipi_witem_par_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,            a.item_title,        a.item_grp,            a.item_desc,
                   a.item_desc2,    a.tsi_amt,            a.prem_amt,            a.ann_prem_amt,        a.ann_tsi_amt,
                   a.rec_flag,        a.currency_cd,        a.currency_rt,        b.currency_desc,    a.group_cd,
                   a.from_date,        a.to_date,            a.pack_line_cd,        a.pack_subline_cd,    a.discount_sw,
                   a.coverage_cd,    a.other_info,        a.surcharge_sw,        a.region_cd,        a.risk_no,
                   a.risk_item_no,  a.prorate_flag,        a.comp_sw,            a.payt_terms,
                   a.changed_tag,    a.short_rt_percent,    a.pack_ben_cd
              FROM gipi_witem a,
                   giis_currency b
             WHERE a.par_id = p_par_id
               AND a.currency_cd = b.main_currency_cd (+)
               AND a.item_no = NVL(p_item_no, a.item_no)
               AND UPPER(NVL(a.item_title, '***')) LIKE NVL(UPPER(p_item_title), '%%')
               AND UPPER(NVL(a.item_desc, '***')) LIKE NVL(UPPER(p_item_desc), '%%')
               AND UPPER(NVL(a.item_desc2, '***')) LIKE NVL(UPPER(p_item_desc2), '%%')
          ORDER BY a.item_no)
        LOOP
            v_gipi_witem.par_id                := i.par_id;
            v_gipi_witem.item_no            := i.item_no;
            v_gipi_witem.item_title            := i.item_title;
            v_gipi_witem.item_grp            := i.item_grp;
            v_gipi_witem.item_desc            := i.item_desc;
            v_gipi_witem.item_desc2            := i.item_desc2;
            v_gipi_witem.tsi_amt            := i.tsi_amt;
            v_gipi_witem.prem_amt            := i.prem_amt;
            v_gipi_witem.ann_prem_amt        := i.ann_prem_amt;
            v_gipi_witem.ann_tsi_amt        := i.ann_tsi_amt;
            v_gipi_witem.rec_flag            := i.rec_flag;
            v_gipi_witem.currency_cd        := i.currency_cd;
            v_gipi_witem.currency_rt        := i.currency_rt;
            v_gipi_witem.currency_desc        := i.currency_desc;
            v_gipi_witem.group_cd            := i.group_cd;
            v_gipi_witem.from_date            := i.from_date;
            v_gipi_witem.to_date            := i.to_date;
            v_gipi_witem.pack_line_cd        := i.pack_line_cd;
            v_gipi_witem.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_witem.discount_sw        := i.discount_sw;
            v_gipi_witem.coverage_cd        := i.coverage_cd;
            v_gipi_witem.other_info         := i.other_info;
            v_gipi_witem.surcharge_sw       := i.surcharge_sw;
            v_gipi_witem.region_cd          := i.region_cd;
            v_gipi_witem.risk_no            := i.risk_no;
            v_gipi_witem.risk_item_no       := i.risk_item_no;
            v_gipi_witem.prorate_flag       := i.prorate_flag;
            v_gipi_witem.comp_sw            := i.comp_sw;
            v_gipi_witem.payt_terms         := i.payt_terms;
            v_gipi_witem.changed_tag        := i.changed_tag;
            v_gipi_witem.short_rt_percent    := i.short_rt_percent;
            v_gipi_witem.pack_ben_cd        := i.pack_ben_cd;

            PIPE ROW(v_gipi_witem);
        END LOOP;

        RETURN;
    END get_gipi_witem_for_par_tg;

    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 03.05.2012
    **  Reference By     : (GIPIS198 - Upload Fleet Data)
    **  Description     : Saves items from an uploaded file
    */
    PROCEDURE set_item_on_mcupload (
        p_par_id            IN GIPI_WITEM.par_id%TYPE,
        p_item_no            IN GIPI_WITEM.item_no%TYPE,
        p_item_title        IN GIPI_WITEM.item_title%TYPE,
        p_item_grp            IN GIPI_WITEM.item_grp%TYPE,
        p_item_desc            IN GIPI_WITEM.item_desc%TYPE,
        p_item_desc2        IN GIPI_WITEM.item_desc2%TYPE,
        p_tsi_amt            IN GIPI_WITEM.tsi_amt%TYPE,
        p_prem_amt            IN GIPI_WITEM.prem_amt%TYPE,
        p_ann_prem_amt        IN GIPI_WITEM.ann_prem_amt%TYPE,
        p_ann_tsi_amt        IN GIPI_WITEM.ann_tsi_amt%TYPE,
        p_rec_flag            IN GIPI_WITEM.rec_flag%TYPE,
        p_currency_cd        IN GIPI_WITEM.currency_cd%TYPE,
        p_currency_rt        IN GIPI_WITEM.currency_rt%TYPE,
        p_group_cd            IN GIPI_WITEM.group_cd%TYPE,
        p_from_date            IN GIPI_WITEM.from_date%TYPE,
        p_to_date            IN GIPI_WITEM.TO_DATE%TYPE,
        p_pack_line_cd        IN GIPI_WITEM.pack_line_cd%TYPE,
        p_pack_subline_cd    IN GIPI_WITEM.pack_subline_cd%TYPE,
        p_discount_sw        IN GIPI_WITEM.discount_sw%TYPE,
        p_coverage_cd        IN GIPI_WITEM.coverage_cd%TYPE,
        p_other_info        IN GIPI_WITEM.other_info%TYPE,
        p_surcharge_sw        IN GIPI_WITEM.surcharge_sw%TYPE,
        p_region_cd            IN GIPI_WITEM.region_cd%TYPE,
        p_changed_tag        IN GIPI_WITEM.changed_tag%TYPE,
        p_prorate_flag        IN GIPI_WITEM.prorate_flag%TYPE,
        p_comp_sw            IN GIPI_WITEM.comp_sw%TYPE,
        p_short_rt_percent    IN GIPI_WITEM.short_rt_percent%TYPE,
        p_pack_ben_cd        IN GIPI_WITEM.pack_ben_cd%TYPE,
        p_payt_terms        IN GIPI_WITEM.payt_terms%TYPE,
        p_risk_no            IN GIPI_WITEM.risk_no%TYPE,
        p_risk_item_no        IN GIPI_WITEM.risk_item_no%TYPE
    ) IS
        v_check       NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT 1 FROM GIPI_WITEM
             WHERE par_id = p_par_id
               AND item_no = p_item_no
        ) LOOP
            v_check := 1;
        END LOOP;

        IF v_check = 0 THEN
            GIPI_WITEM_PKG.set_gipi_witem_2(p_par_id, p_item_no, p_item_title,
                    p_item_grp, p_item_desc, p_item_desc2, p_tsi_amt, p_prem_amt,
                    p_ann_prem_amt, p_ann_tsi_amt, p_rec_flag, p_currency_cd,
                    p_currency_rt, p_group_cd, p_from_date, p_to_date, p_pack_line_cd,
                    p_pack_subline_cd, p_discount_sw, p_coverage_cd, p_other_info,
                    p_surcharge_sw, p_region_cd, p_changed_tag, p_prorate_flag,
                    p_comp_sw, p_short_rt_percent, p_pack_ben_cd, p_payt_terms,
                    p_risk_no, p_risk_item_no);
        END IF;
    END set_item_on_mcupload;

	/*
    **  Created by :      Veronica V. Raymundo
    **  Date Created:     08.31.2012
    **  Reference By:     (GIPIS002 - Basic Information)
    **  Description:      Check if records exist in GIPI_WITEM with same item_no
    */
    FUNCTION get_gipi_witem_exist_2 (p_par_id  IN gipi_witem.par_id%TYPE,
									 p_item_no IN gipi_witem.item_no%TYPE)
    RETURN VARCHAR2 IS
      v_exist       VARCHAR2(1) := 'N';
    BEGIN
      FOR A2 IN (
           SELECT item_no
             FROM gipi_witem
            WHERE par_id  =  p_par_id
			  AND item_no = p_item_no)
      LOOP
        v_exist := 'Y';
      END LOOP;
      RETURN v_exist;
    END;

	/*
    **  Created by :      rmanalad
    **  Date Created:     09.10.2012
    **  Reference By:     get_item_list2 with added column
    **  Description:      get LOV for item no.
    */
    FUNCTION get_item_lov (p_par_id gipi_witem.par_id%TYPE)
      RETURN item_title_lov_tab PIPELINED
   IS
      v_item   item_title_lov_type;
   BEGIN
      FOR i IN (SELECT   a.item_no, a.item_title, a.prem_amt
                    FROM gipi_witem a
                   WHERE a.par_id = p_par_id
                     AND EXISTS (
                            SELECT '1'
                              FROM gipi_witmperl b
                             WHERE b.par_id = a.par_id
                               AND b.item_no = a.item_no)
                ORDER BY 1, 2)
      LOOP
         v_item.item_no    := i.item_no;
         v_item.item_title := i.item_title;
         v_item.prem_amt   := i.prem_amt;
         PIPE ROW (v_item);
      END LOOP;

      RETURN;
   END get_item_lov;

	/*
    **  Created by   : Marco Paolo Rebong
    **  Date Created : November 12, 2012
    **  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
    **  Description  : insert_into_gipi_witem program unit
    */
    PROCEDURE insert_into_gipi_witem(
        p_par_id            GIPI_WITEM.par_id%TYPE,
        p_limit_liability   GIPI_WITEM.tsi_amt%TYPE,
        p_currency_cd       GIPI_WITEM.currency_cd%TYPE,
        p_currency_rt       GIPI_WITEM.currency_rt%TYPE
    )
    IS
        v_item_no           GIPI_WITEM.item_no%TYPE := NULL;
    BEGIN
        FOR a IN(SELECT item_no
                   FROM GIPI_WITEM
                  WHERE par_id = p_par_id)
        LOOP
            v_item_no := a.item_no;

            DELETE GIPI_WITEM
             WHERE par_id = p_par_id
               AND item_no != 1;

            UPDATE GIPI_WITEM
               SET tsi_amt = p_limit_liability,
                   ann_tsi_amt = p_limit_liability,
                   currency_cd = p_currency_cd,
                   currency_rt = p_currency_rt
             WHERE par_id = p_par_id
               AND item_no = 1;
            EXIT;
        END LOOP;

        IF v_item_no IS NULL THEN
            INSERT INTO GIPI_WITEM
                   (par_id, item_no, item_grp, item_title,
                    tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, currency_cd,
                    currency_rt)
            VALUES (p_par_id, 1, 1, 'Open policy limit of liability',
                    NVL(p_limit_liability, 0), 0, NVL(p_limit_liability, 0), 0, p_currency_cd,
                    p_currency_rt);
        END IF;
    END;

    /*
    ** Created by   : Gzelle
    ** Date Created : October 24, 2013
    ** Description  : Checks if giacp.v('DEFAULT_CURRENCY') and giacp.n('CURRENCY_CD') is compatible.
    **                Returns the default currency rate based on the default currency.
    */
    FUNCTION check_get_def_curr_rt
        RETURN NUMBER

    IS
        v_def_cur_rt    VARCHAR2(16);
        v_def_cur       VARCHAR2(8) := 'N';
    BEGIN
        FOR i IN (SELECT main_currency_cd currency_cd, currency_rt
                    FROM giis_currency
                   WHERE short_name LIKE giacp.v('DEFAULT_CURRENCY')
                     AND main_currency_cd = giacp.n('CURRENCY_CD'))
        LOOP
            v_def_cur_rt := i.currency_rt;
            v_def_cur    := 'Y';
            EXIT;
        END LOOP;

        IF v_def_cur <> 'Y'
        THEN
            raise_application_error
                (-20001,
                    'Geniisys Exception#I# Local currency is not properly set-up. Please check accounting parameters DEFAULT_CURRENCY and CURRENCY_CD.'
                );
        END IF;

        RETURN v_def_cur_rt;
    END;
END gipi_witem_pkg;
/


