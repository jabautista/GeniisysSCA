CREATE OR REPLACE PROCEDURE CPI.RECAP_UPR_PREV_YEAR_DTL (p_fm_date    DATE,
                                                         p_to_date    DATE)
AS
   TYPE tab_iss_cd IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.iss_cd%TYPE;

   TYPE tab_line_cd IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.line_cd%TYPE;

   TYPE tab_subline_cd IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.subline_cd%TYPE;

   TYPE tab_policy_id IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.policy_id%TYPE;

   TYPE tab_peril_cd IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.peril_cd%TYPE;

   TYPE tab_tariff_cd IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.tariff_cd%TYPE;

   TYPE tab_subline_type_cd
      IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.subline_type_cd%TYPE;

   TYPE tab_bond_class_subline
      IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.bond_class_subline%TYPE;

   TYPE tab_premium_amt IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.premium_amt%TYPE;

   TYPE tab_commission_amt
      IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.commission_amt%TYPE;

   TYPE tab_tsi_amt IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.tsi_amt%TYPE;

   TYPE tab_ri_cd IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.ri_cd%TYPE;

   TYPE tab_local_foreign_sw
      IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.local_foreign_sw%TYPE;

   TYPE tab_treaty_prem IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.treaty_prem%TYPE;

   TYPE tab_treaty_tsi IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.treaty_tsi%TYPE;

   TYPE tab_treaty_comm IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.treaty_comm%TYPE;

   TYPE tab_facul_prem IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.facul_prem%TYPE;

   TYPE tab_facul_tsi IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.facul_tsi%TYPE;

   TYPE tab_facul_comm IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.facul_comm%TYPE;

   TYPE tab_inw_ri_comm IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.inw_ri_comm%TYPE;

   TYPE tab_item_no IS TABLE OF gipi_fireitem.item_no%TYPE;

   TYPE tab_currency_rt IS TABLE OF gipi_item.currency_rt%TYPE;

   TYPE tab_date_tag IS TABLE OF GIAC_RECAP_PRIOR_DTL_EXT.date_tag%TYPE;

   TYPE tab_issue_yy IS TABLE OF gipi_polbasic.issue_yy%TYPE;

   TYPE tab_pol_seq_no IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

   TYPE tab_renew_no IS TABLE OF gipi_polbasic.renew_no%TYPE;

   TYPE tab_acct_ent_date IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

   TYPE tab_spld_acct_ent_date
      IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

   TYPE tab_cedant IS TABLE OF giri_inpolbas.ri_cd%TYPE;

   TYPE tab_rowid IS TABLE OF VARCHAR2 (18);

   vv_line_cd               tab_line_cd;
   vv_subline_cd            tab_subline_cd;
   vv_iss_cd                tab_iss_cd;
   vv_issue_yy              tab_issue_yy;
   vv_pol_seq_no            tab_pol_seq_no;
   vv_renew_no              tab_renew_no;
   vv_policy_id             tab_policy_id;
   vv_peril_cd              tab_peril_cd;
   vv_tariff_cd             tab_tariff_cd;
   vv_subline_type_cd       tab_subline_type_cd;
   vv_bond_class_subline    tab_bond_class_subline;
   vv_premium_amt           tab_premium_amt;
   vv_commission_amt        tab_commission_amt;
   vv_tsi_amt               tab_tsi_amt;
   vv_ri_cd                 tab_ri_cd;
   vv_local_foreign_sw      tab_local_foreign_sw;
   vv_treaty_prem           tab_treaty_prem;
   vv_treaty_tsi            tab_treaty_tsi;
   vv_treaty_comm           tab_treaty_comm;
   vv_facul_prem            tab_facul_prem;
   vv_facul_tsi             tab_facul_tsi;
   vv_facul_comm            tab_facul_comm;
   vv_inw_ri_comm           tab_inw_ri_comm;
   vv_item_no               tab_item_no;
   vv_date_tag              tab_date_tag;
   vv_currency_rt           tab_currency_rt;
   vv_acct_ent_date         tab_acct_ent_date;
   vv_spld_acct_ent_date    tab_spld_acct_ent_date;
   vv_cedant                tab_cedant;

   vv_line_cd2              tab_line_cd;
   vv_subline_cd2           tab_subline_cd;
   vv_iss_cd2               tab_iss_cd;
   vv_issue_yy2             tab_issue_yy;
   vv_pol_seq_no2           tab_pol_seq_no;
   vv_renew_no2             tab_renew_no;
   vv_policy_id2            tab_policy_id;
   vv_peril_cd2             tab_peril_cd;
   vv_tariff_cd2            tab_tariff_cd;
   vv_subline_type_cd2      tab_subline_type_cd;
   vv_premium_amt2          tab_premium_amt;
   vv_commission_amt2       tab_commission_amt;
   vv_tsi_amt2              tab_tsi_amt;
   vv_inw_ri_comm2          tab_inw_ri_comm;
   vv_item_no2              tab_item_no;
   vv_date_tag2             tab_date_tag;
   vv_currency_rt2          tab_currency_rt;
   vv_acct_ent_date2        tab_acct_ent_date;
   vv_spld_acct_ent_date2   tab_spld_acct_ent_date;
   vv_cedant2               tab_cedant;

   TYPE chk_ext IS TABLE OF NUMBER
      INDEX BY VARCHAR2 (100);

   v_chk_ext1               chk_ext;
   v_chk_ext2               chk_ext;
   v_chk_ext3               chk_ext;

   vv_rowid                 tab_rowid;
   v_fm_treaty_year         giac_treaty_cessions.cession_year%TYPE;
   v_fm_treaty_mm           giac_treaty_cessions.cession_mm%TYPE;
   v_to_treaty_year         giac_treaty_cessions.cession_year%TYPE;
   v_to_treaty_mm           giac_treaty_cessions.cession_mm%TYPE;
   v_cnt                    NUMBER (12);
   v_iss_cd                 gipi_polbasic.iss_cd%TYPE;
   v_line_cd                gipi_polbasic.line_cd%TYPE;
   v_subline_cd             gipi_polbasic.subline_cd%TYPE;
   v_acct_ent_date          gipi_polbasic.acct_ent_date%TYPE;
   v_issue_yy               gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no               gipi_polbasic.renew_no%TYPE;
   v_fi_line_cd             gipi_polbasic.line_cd%TYPE;
   v_mc_line_cd             gipi_polbasic.line_cd%TYPE;
   v_su_line_cd             gipi_polbasic.line_cd%TYPE;
   v_currency_rt            gipi_item.currency_rt%TYPE;
   v_acc_rev_date           giri_binder.acc_rev_date%TYPE;
   v_cancel_date            gipi_polbasic.cancel_date%TYPE;

   TYPE tab_sum_prem_amt IS TABLE OF NUMBER (18, 2);

   TYPE tab_sum_comm_amt IS TABLE OF NUMBER (18, 2);

   vv_sum_policy_id         tab_policy_id := tab_policy_id ();
   vv_sum_peril_cd          tab_peril_cd := tab_peril_cd ();
   vv_sum_prem_amt          tab_sum_prem_amt := tab_sum_prem_amt ();
   vv_sum_comm_amt          tab_sum_comm_amt := tab_sum_comm_amt ();
   v_temp_rt                gipi_item.currency_rt%TYPE;
   v_exists                 BOOLEAN := FALSE;
   v_row                    NUMBER (12);
   vv_bas_line_cd           tab_line_cd := tab_line_cd ();
   vv_bas_subline_cd        tab_subline_cd := tab_subline_cd ();
   vv_bas_iss_cd            tab_iss_cd := tab_iss_cd ();
   vv_bas_issue_yy          tab_issue_yy := tab_issue_yy ();
   vv_bas_pol_seq_no        tab_pol_seq_no := tab_pol_seq_no ();
   vv_bas_renew_no          tab_renew_no := tab_renew_no ();
   vv_bas_item_no           tab_item_no := tab_item_no ();
   vv_bas_peril_cd          tab_peril_cd := tab_peril_cd ();
   vv_bas_tariff_cd         tab_tariff_cd := tab_tariff_cd ();
   vv_bas_subline_type_cd   tab_subline_type_cd := tab_subline_type_cd ();
   vv_bas_tsi_amt           tab_tsi_amt := tab_tsi_amt ();
   v_comm_exs               NUMBER;

   FUNCTION get_cur_rt (p_policy_id GIAC_RECAP_PRIOR_DTL_EXT.policy_id%TYPE)
      RETURN NUMBER
   AS
      v_rate   gipi_item.currency_rt%TYPE := 0;
   BEGIN
      SELECT currency_rt
        INTO v_rate
        FROM gipi_item
       WHERE policy_id = p_policy_id AND ROWNUM = 1;

      RETURN v_rate;
   END;

   FUNCTION get_bond_class (
      p_line_cd       GIAC_RECAP_PRIOR_DTL_EXT.line_cd%TYPE,
      p_subline_cd    GIAC_RECAP_PRIOR_DTL_EXT.subline_cd%TYPE)
      RETURN CHAR
   AS
      v_exs        BOOLEAN := FALSE;
      v_class_no   VARCHAR2 (1);
   BEGIN
      FOR bc_no IN (SELECT class_no
                      FROM giis_bond_class_subline
                     WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd)
      LOOP
         v_class_no := bc_no.class_no;
         v_exs := TRUE;
         EXIT;
      END LOOP;

      IF v_exs = TRUE
      THEN
         RETURN (v_class_no);
      ELSE
         RETURN (NULL);
      END IF;
   END;

   --Procedure to populate unearned premium, effectivity and expiry date
   PROCEDURE pop_unearned_amount (p_to_date DATE)
   IS
      /*TYPE unearned_amt_type IS RECORD
      (
         policy_id     giac_recap_prior_dtl_ext.policy_id%TYPE,
         peril_cd      giac_recap_prior_dtl_ext.peril_cd%TYPE,
         ri_cd         giac_recap_prior_dtl_ext.ri_cd%TYPE,
         eff_date      giac_recap_prior_dtl_ext.eff_date%TYPE,
         exp_date      giac_recap_prior_dtl_ext.exp_date%TYPE,
         def_prem_amt  giac_recap_prior_dtl_ext.def_prem_amt%TYPE
      );

      TYPE unearned_amt_tab IS TABLE OF unearned_amt_type;

      unearned_amt     unearned_amt_tab;*/
      v_num_factor      NUMBER;
      v_den_factor      NUMBER;
      v_ext_mm_yy       VARCHAR2(7) := TO_CHAR(p_to_date,'MM-YYYY'); --added by albert 01.25.2017 GENQA SR 5848, to handle policies with multiple takeup 

      TYPE policy_id_tab IS TABLE OF giac_recap_prior_dtl_ext.policy_id%TYPE;

      TYPE peril_cd_tab IS TABLE OF giac_recap_prior_dtl_ext.peril_cd%TYPE;

      TYPE ri_cd_tab IS TABLE OF giac_recap_prior_dtl_ext.ri_cd%TYPE;

      TYPE eff_date_tab IS TABLE OF giac_recap_prior_dtl_ext.eff_date%TYPE;

      TYPE exp_date_tab IS TABLE OF giac_recap_prior_dtl_ext.exp_date%TYPE;

      TYPE def_prem_amt_tab
         IS TABLE OF giac_recap_prior_dtl_ext.def_prem_amt%TYPE;

      vv_policy_id      policy_id_tab;
      vv_peril_cd       peril_cd_tab;
      vv_ri_cd          ri_cd_tab;
      vv_eff_date       eff_date_tab;
      vv_exp_date       exp_date_tab;
      vv_def_prem_amt   def_prem_amt_tab;
   BEGIN
      SELECT a.policy_id,
             a.peril_cd,
             NVL (a.ri_cd, 0) ri_cd,
             /*cpi.invoice_takeupterm.get_eff_date (a.policy_id, 1) eff_date, --long-term policies not yet handled
             cpi.invoice_takeupterm.get_exp_date (a.policy_id, 1) exp_date,
               (  NVL (a.premium_amt, 0)
                + NVL (a.treaty_prem, 0)
                + NVL (a.facul_prem, 0))
             * cpi.get_numerator_factor_24th (
                  p_to_date,
                  invoice_takeupterm.get_eff_date (a.policy_id, 1),
                  invoice_takeupterm.get_exp_date (a.policy_id, 1),
                  NVL (c.menu_line_cd, c.line_cd))
             / cpi.get_denominator_factor_24th (
                  p_to_date,
                  invoice_takeupterm.get_eff_date (a.policy_id, 1),
                  invoice_takeupterm.get_exp_date (a.policy_id, 1))
                def_prem_amt*/ --commented by albert 01.25.2017, replaced by codes below to handle policies with multiple takeup (GENQA SR 5848)
             cpi.invoice_takeupterm.get_eff_date (a.policy_id, d.takeup_seq_no, v_ext_mm_yy) eff_date,
             cpi.invoice_takeupterm.get_exp_date (a.policy_id, d.takeup_seq_no, v_ext_mm_yy) exp_date,
               (  NVL (a.premium_amt, 0)
                + NVL (a.treaty_prem, 0)
                + NVL (a.facul_prem, 0))
             * cpi.get_numerator_factor_24th (
                  p_to_date,
                  invoice_takeupterm.get_eff_date (a.policy_id, d.takeup_seq_no, v_ext_mm_yy),
                  invoice_takeupterm.get_exp_date (a.policy_id, d.takeup_seq_no, v_ext_mm_yy),
                  NVL (c.menu_line_cd, c.line_cd))
             / cpi.get_denominator_factor_24th (
                  p_to_date,
                  invoice_takeupterm.get_eff_date (a.policy_id, d.takeup_seq_no, v_ext_mm_yy),
                  invoice_takeupterm.get_exp_date (a.policy_id, d.takeup_seq_no, v_ext_mm_yy))
                def_prem_amt             
        --BULK COLLECT INTO unearned_amt
        BULK COLLECT INTO vv_policy_id,
             vv_peril_cd,
             vv_ri_cd,
             vv_eff_date,
             vv_exp_date,
             vv_def_prem_amt
        FROM GIAC_RECAP_PRIOR_DTL_EXT a, gipi_polbasic b, giis_line c, gipi_invoice d   --added gipi_invoice by albert 01.25.2017 (GENQA SR 5848)
       WHERE a.policy_id = b.policy_id AND b.line_cd = c.line_cd
         AND a.policy_id = d.policy_id;                                                 --added by albert 01.25.2017 (GENQA SR 5848)

      IF SQL%FOUND
      THEN
         --FORALL indx IN 1 .. unearned_amt.COUNT
         FORALL indx IN 1 .. vv_policy_id.COUNT
            UPDATE GIAC_RECAP_PRIOR_DTL_EXT
               --                   SET eff_date = unearned_amt (indx).eff_date,
               --                       exp_date = unearned_amt (indx).exp_date,
               --                       def_prem_amt = unearned_amt (indx).def_prem_amt
               SET eff_date = vv_eff_date (indx),
                   exp_date = vv_exp_date (indx),
                   def_prem_amt = vv_def_prem_amt (indx)
             WHERE     policy_id = vv_policy_id (indx) --unearned_amt (indx).policy_id
                   AND peril_cd = vv_peril_cd (indx) --unearned_amt (indx).peril_cd
                   AND NVL (ri_cd, 0) = vv_ri_cd (indx); --unearned_amt (indx).ri_cd;
      END IF;
   END;

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_RECAP_PRIOR_DTL_EXT';

   v_fi_line_cd := Giisp.v ('LINE_CODE_FI');

   IF v_fi_line_cd IS NULL
   THEN
      RAISE_APPLICATION_ERROR (
         -20101,
         'Geniisys Exception#E#Line code for fire is not found in giis_parameters.');
   END IF;

   v_mc_line_cd := Giisp.v ('LINE_CODE_MC');

   IF v_mc_line_cd IS NULL
   THEN
      RAISE_APPLICATION_ERROR (
         -20102,
         'Geniisys Exception#E#Line code for Motor Car is not found in giis_parameters.');
   END IF;

   v_su_line_cd := Giisp.v ('LINE_CODE_SU');

   IF v_su_line_cd IS NULL
   THEN
      RAISE_APPLICATION_ERROR (
         -20103,
         'Geniisys Exception#E#Line code for Bonds is not found in giis_parameters.');
   END IF;

   /* direct and assumed */
   SELECT pol.line_cd AS line_cd,
          pol.subline_cd AS subline_cd,
          pol.iss_cd AS iss_cd,
          pol.issue_yy AS issue_yy,
          pol.pol_seq_no AS pol_seq_no,
          pol.renew_no AS renew_no,
          pol.policy_id AS policy_id,
          ipr.peril_cd AS peril_cd,
          NULL AS tariff_cd,
          NULL AS subline_type_cd,
          acct_ent_date AS acct_ent_dae,
          spld_acct_ent_date AS spld_acct_ent_date,
          NULL AS commission_amt,
            DECODE (
                 (SIGN (p_fm_date - pol.acct_ent_date) * 4)
               + SIGN (
                    NVL (pol.spld_acct_ent_date, p_to_date + 60) - p_to_date),
               1, 1,
               -3, 1,
               3, -1,
               4, -1,
               0)
          * (ipr.prem_amt * itm.currency_rt)
             AS premium_amt,
            DECODE (
                 (SIGN (p_fm_date - pol.acct_ent_date) * 4)
               + SIGN (
                    NVL (pol.spld_acct_ent_date, p_to_date + 60) - p_to_date),
               1, 1,
               -3, 1,
               3, -1,
               4, -1,
               0)
          * (ipr.tsi_amt * itm.currency_rt)
             AS tsi_amt,
            DECODE (
                 (SIGN (p_fm_date - pol.acct_ent_date) * 4)
               + SIGN (
                    NVL (pol.spld_acct_ent_date, p_to_date + 60) - p_to_date),
               1, 1,
               -3, 1,
               3, -1,
               4, -1,
               0)
          * (ipr.ri_comm_amt * itm.currency_rt)
             AS ri_comm_amt,
          ipr.item_no AS item_no,
          itm.currency_rt AS currency_rt,
          DECODE (
             SIGN (NVL (pol.cancel_date, p_to_date + 60) - p_to_date),
             1, DECODE (
                     (SIGN (p_fm_date - pol.acct_ent_date) * 4)
                   + SIGN (
                          NVL (pol.spld_acct_ent_date, p_to_date + 60)
                        - p_to_date),
                   1, 'A',
                   -3, 'A',
                   3, 'S',
                   4, 'S',
                   'Z'),
             'C')
             AS date_tag,
          inp.ri_cd AS cedant,
          ftm.tarf_cd AS tariff_cd,
          veh.subline_type_cd AS subline_type_cd
     BULK COLLECT INTO vv_line_cd,
          vv_subline_cd,
          vv_iss_cd,
          vv_issue_yy,
          vv_pol_seq_no,
          vv_renew_no,
          vv_policy_id,
          vv_peril_cd,
          vv_tariff_cd,
          vv_subline_type_cd,
          vv_acct_ent_date,
          vv_spld_acct_ent_date,
          vv_commission_amt,
          vv_premium_amt,
          vv_tsi_amt,
          vv_inw_ri_comm,
          vv_item_no,
          vv_currency_rt,
          vv_date_tag,
          vv_cedant,
          vv_tariff_cd,
          vv_subline_type_cd
     FROM giri_inpolbas inp,
          gipi_vehicle veh,
          gipi_fireitem ftm,
          gipi_itmperil ipr,
          gipi_item itm,
          gipi_polbasic pol
    WHERE     1 = 1
          AND pol.policy_id = inp.policy_id(+)
          AND itm.policy_id = veh.policy_id(+)
          AND itm.item_no = veh.item_no(+)
          AND itm.policy_id = ftm.policy_id(+)
          AND itm.item_no = ftm.item_no(+)
          AND pol.policy_id = itm.policy_id
          AND itm.policy_id = ipr.policy_id
          AND itm.item_no = ipr.item_no
          AND TRUNC (NVL (pol.endt_expiry_date, pol.expiry_date)) > p_to_date
          AND (   (    TRUNC (pol.acct_ent_date) >= p_fm_date
                   AND TRUNC (pol.acct_ent_date) <= p_to_date)
               OR (    TRUNC (
                          NVL (pol.spld_acct_ent_date, pol.acct_ent_date)) >=
                          p_fm_date
                   AND TRUNC (
                          NVL (pol.spld_acct_ent_date, pol.acct_ent_date)) <=
                          p_to_date));

   IF vv_policy_id IS NOT NULL
   THEN
      FORALL i IN vv_iss_cd.FIRST .. vv_iss_cd.LAST
         INSERT INTO GIAC_RECAP_PRIOR_DTL_EXT (iss_cd,
                                               line_cd,
                                               subline_cd,
                                               policy_id,
                                               peril_cd,
                                               tariff_cd,
                                               subline_type_cd,
                                               premium_amt,
                                               commission_amt,
                                               tsi_amt,
                                               inw_ri_comm,
                                               date_tag,
                                               cedant,
                                               issue_yy,
                                               pol_seq_no,
                                               renew_no)
              VALUES (vv_iss_cd (i),
                      vv_line_cd (i),
                      vv_subline_cd (i),
                      vv_policy_id (i),
                      vv_peril_cd (i),
                      vv_tariff_cd (i),
                      vv_subline_type_cd (i),
                      vv_premium_amt (i),
                      vv_commission_amt (i),
                      vv_tsi_amt (i),
                      vv_inw_ri_comm (i),
                      vv_date_tag (i),
                      vv_cedant (i),
                      vv_issue_yy (i),
                      vv_pol_seq_no (i),
                      vv_renew_no (i));
   END IF;

   -- reinitialize collection
   vv_iss_cd.DELETE;
   vv_line_cd.DELETE;
   vv_subline_cd.DELETE;
   vv_policy_id.DELETE;
   vv_peril_cd.DELETE;
   vv_tariff_cd.DELETE;
   vv_subline_type_cd.DELETE;
   vv_premium_amt.DELETE;
   vv_commission_amt.DELETE;
   vv_inw_ri_comm.DELETE;
   vv_item_no.DELETE;
   vv_currency_rt.DELETE;
   vv_cedant.DELETE;
   vv_issue_yy.DELETE;
   vv_pol_seq_no.DELETE;
   vv_renew_no.DELETE;
   vv_date_tag.DELETE;

   /* treaty cession */
   SELECT pol.iss_cd AS iss_cd,
          pol.subline_cd AS subline_cd,
          gtc.line_cd AS line_cd,
          gtc.policy_id AS policy_id,
          gdl.peril_cd AS peril_cd,
          NULL AS tariff_cd,
          NULL AS subline_type_cd,
          gdl.premium_amt AS premium_amt,
          ROUND (
               DECODE (
                    (SIGN (p_fm_date - dis.acct_ent_date) * 4)
                  + SIGN (
                       NVL (dis.acct_neg_date, p_to_date + 60) - p_to_date),
                  1, 1,
                  -3, 1,
                  3, -1,
                  4, -1,
                  0)
             * ids.dist_tsi
             * (typ.trty_shr_pct / 100),
             4)
             AS dist_tsi,
          gdl.commission_amt AS commission_amt,
          gri.ri_cd AS ri_cd,
          gri.local_foreign_sw AS local_foreign_sw,
          ipr.item_no AS item_no,
          NULL AS cedant,
          pol.issue_yy AS issue_yy,
          pol.pol_seq_no AS pol_seq_no,
          pol.renew_no AS renew_no,
          DECODE (
             SIGN (NVL (pol.cancel_date, p_to_date + 60) - p_to_date),
             1, DECODE (
                     (SIGN (p_fm_date - dis.acct_ent_date) * 4)
                   + SIGN (
                        NVL (dis.acct_neg_date, p_to_date + 60) - p_to_date),
                   1, 'A',
                   -3, 'A',
                   3, 'S',
                   4, 'S',
                   'Z'),
             'C')
             AS date_tag
     BULK COLLECT INTO vv_iss_cd,
          vv_subline_cd,
          vv_line_cd,
          vv_policy_id,
          vv_peril_cd,
          vv_tariff_cd,
          vv_subline_type_cd,
          vv_treaty_prem,
          vv_treaty_tsi,
          vv_treaty_comm,
          vv_ri_cd,
          vv_local_foreign_sw,
          vv_item_no,
          vv_cedant,
          vv_issue_yy,
          vv_pol_seq_no,
          vv_renew_no,
          vv_date_tag
     FROM giuw_itemperilds_dtl ids,
          giuw_pol_dist dis,
          giis_trty_panel typ,
          giis_dist_share shr,
          gipi_polbasic pol,
          giis_reinsurer gri,
          gipi_itmperil ipr,
          giac_treaty_cession_dtl gdl,
          giac_treaty_cessions gtc
    WHERE     gtc.cession_id = gdl.cession_id
          AND gtc.acct_ent_date >= p_fm_date
          AND gtc.acct_ent_date <= p_to_date
          AND gtc.policy_id = ipr.policy_id
          AND gtc.item_no = ipr.item_no
          AND gtc.line_cd = ipr.line_cd
          AND gdl.peril_cd = ipr.peril_cd
          AND gtc.ri_cd = gri.ri_cd
          AND gtc.policy_id = pol.policy_id
          AND gtc.line_cd = shr.line_cd
          AND gtc.share_cd = shr.share_cd
          AND shr.share_type = 2
          AND shr.line_cd = typ.line_cd
          AND shr.trty_yy = typ.trty_yy
          AND shr.share_cd = typ.trty_seq_no
          AND gtc.ri_cd = typ.ri_cd
          AND gtc.dist_no = dis.dist_no
          AND gtc.dist_no = ids.dist_no
          AND gtc.item_no = ids.item_no
          AND ipr.peril_cd = ids.peril_cd
          AND TRUNC (NVL (pol.endt_expiry_date, pol.expiry_date)) > p_to_date
          AND gtc.line_cd = ids.line_cd || NULL       -- optimization purposes
          AND gtc.share_cd = ids.share_cd;

   IF SQL%FOUND
   THEN
      FOR i IN vv_iss_cd.FIRST .. vv_iss_cd.LAST
      LOOP
         IF vv_line_cd (i) = v_fi_line_cd
         THEN
            BEGIN
               SELECT tarf_cd
                 INTO vv_tariff_cd (i)
                 FROM gipi_fireitem
                WHERE     policy_id = vv_policy_id (i)
                      AND item_no = vv_item_no (i);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         IF vv_line_cd (i) = v_mc_line_cd
         THEN
            BEGIN
               SELECT subline_type_cd
                 INTO vv_subline_type_cd (i)
                 FROM gipi_vehicle
                WHERE     policy_id = vv_policy_id (i)
                      AND item_no = vv_item_no (i);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         IF vv_iss_cd (i) = 'RI'
         THEN
            BEGIN                                                -- get cedant
               SELECT ri_cd
                 INTO vv_cedant (i)
                 FROM giri_inpolbas rip
                WHERE rip.policy_id = vv_policy_id (i) AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;
      END LOOP;

      FORALL i IN vv_iss_cd.FIRST .. vv_iss_cd.LAST
         INSERT INTO GIAC_RECAP_PRIOR_DTL_EXT (iss_cd,
                                               line_cd,
                                               subline_cd,
                                               policy_id,
                                               peril_cd,
                                               tariff_cd,
                                               subline_type_cd,
                                               treaty_prem,
                                               treaty_tsi,
                                               treaty_comm,
                                               ri_cd,
                                               local_foreign_sw,
                                               cedant,
                                               issue_yy,
                                               pol_seq_no,
                                               renew_no,
                                               date_tag)
              VALUES (vv_iss_cd (i),
                      vv_line_cd (i),
                      vv_subline_cd (i),
                      vv_policy_id (i),
                      vv_peril_cd (i),
                      vv_tariff_cd (i),
                      vv_subline_type_cd (i),
                      vv_treaty_prem (i),
                      vv_treaty_tsi (i),
                      vv_treaty_comm (i),
                      vv_ri_cd (i),
                      vv_local_foreign_sw (i),
                      vv_cedant (i),
                      vv_issue_yy (i),
                      vv_pol_seq_no (i),
                      vv_renew_no (i),
                      vv_date_tag (i));
   END IF;

   -- facultative cession
   vv_iss_cd.DELETE;
   vv_line_cd.DELETE;
   vv_subline_cd.DELETE;
   vv_policy_id.DELETE;
   vv_peril_cd.DELETE;
   vv_tariff_cd.DELETE;
   vv_subline_type_cd.DELETE;
   vv_treaty_prem.DELETE;
   vv_treaty_comm.DELETE;
   vv_ri_cd.DELETE;
   vv_local_foreign_sw.DELETE;
   vv_item_no.DELETE;
   vv_cedant.DELETE;
   vv_issue_yy.DELETE;
   vv_pol_seq_no.DELETE;
   vv_renew_no.DELETE;
   vv_date_tag.DELETE;
   vv_facul_prem := tab_facul_prem ();
   vv_facul_tsi := tab_facul_tsi ();
   vv_facul_comm := tab_facul_comm ();
   v_cnt := 0;

   FOR perl
      IN (SELECT distfr.dist_no AS dist_no,
                 distfr.dist_seq_no AS dist_seq_no,
                 poldst.policy_id AS policy_id,
                 bndr.acc_rev_date AS acc_rev_date,
                 bndr.acc_ent_date AS acc_ent_date,
                 (frperl.ri_comm_rt / 100) AS comm_rt,
                 frperl.ri_shr_pct AS shr_pct,
                 frperl.ri_cd AS ri_cd,
                 reinsr.local_foreign_sw AS local_foreign_sw,
                 frperl.peril_cd AS peril_cd
            FROM giis_reinsurer reinsr,
                 giuw_pol_dist poldst,
                 giri_distfrps distfr,
                 giri_frperil frperl,
                 giri_frps_ri frpsri,
                 giri_binder bndr,
                 gipi_polbasic pol
           WHERE     1 = 1
                 AND (   (    TRUNC (bndr.acc_ent_date) >= p_fm_date
                          AND TRUNC (bndr.acc_ent_date) <= p_to_date
                          -- to handle re-used binders
                          AND distfr.dist_no IN
                                 (SELECT MIN (dist_no)
                                    FROM giri_distfrps x,
                                         giri_frps_ri y,
                                         giri_binder z
                                   WHERE     x.line_cd = y.line_cd
                                         AND x.frps_yy = y.frps_yy
                                         AND x.frps_seq_no = y.frps_seq_no
                                         AND y.fnl_binder_id =
                                                z.fnl_binder_id
                                         AND y.fnl_binder_id =
                                                bndr.fnl_binder_id))
                      OR (    TRUNC (bndr.acc_rev_date) >= p_fm_date
                          AND TRUNC (bndr.acc_rev_date) <= p_to_date))
                 AND poldst.policy_id = pol.policy_id
                 AND TRUNC (NVL (pol.endt_expiry_date, pol.expiry_date)) >
                        p_to_date
                 AND bndr.fnl_binder_id = frpsri.fnl_binder_id
                 AND frpsri.frps_yy = distfr.frps_yy
                 AND frpsri.frps_seq_no = distfr.frps_seq_no
                 AND frpsri.line_cd = distfr.line_cd
                 AND frpsri.ri_seq_no = frperl.ri_seq_no
                 AND distfr.line_cd = frperl.line_cd
                 AND distfr.frps_yy = frperl.frps_yy
                 AND distfr.frps_seq_no = frperl.frps_seq_no
                 AND frperl.ri_cd = bndr.ri_cd
                 AND frperl.ri_cd = reinsr.ri_cd
                 AND distfr.dist_no = poldst.dist_no)
   LOOP
      BEGIN
         SELECT line_cd,
                subline_cd,
                iss_cd,
                TRUNC (acct_ent_date),
                issue_yy,
                pol_seq_no,
                renew_no,
                cancel_date
           INTO v_line_cd,
                v_subline_cd,
                v_iss_cd,
                v_acct_ent_date,
                v_issue_yy,
                v_pol_seq_no,
                v_renew_no,
                v_cancel_date
           FROM gipi_polbasic
          WHERE policy_id = perl.policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR (
               -20106,
                  'Geniisys Exception#E#Policy_id '
               || perl.policy_id
               || ' does not exist in gipi_polbasic');
      END;

      FOR item
         IN (SELECT DECODE (itmprl.dist_spct, 0, 1, itmprl.dist_spct) spct,
                    itmprl.dist_prem prem,
                    itmprl.line_cd,
                    itmprl.item_no,
                    itmprl.dist_tsi tsi
               FROM giuw_itemperilds_dtl itmprl
              WHERE     itmprl.dist_no = perl.dist_no
                    AND itmprl.dist_seq_no = perl.dist_seq_no
                    AND itmprl.peril_cd = perl.peril_cd
                    AND itmprl.line_cd = v_line_cd
                    AND itmprl.share_cd = 999)
      LOOP
         v_cnt := v_cnt + 1;
         vv_iss_cd.EXTEND (1);
         vv_line_cd.EXTEND (1);
         vv_subline_cd.EXTEND (1);
         vv_policy_id.EXTEND (1);
         vv_peril_cd.EXTEND (1);
         vv_tariff_cd.EXTEND (1);
         vv_subline_type_cd.EXTEND (1);
         vv_facul_prem.EXTEND (1);
         vv_facul_tsi.EXTEND (1);
         vv_facul_comm.EXTEND (1);
         vv_ri_cd.EXTEND (1);
         vv_local_foreign_sw.EXTEND (1);
         vv_cedant.EXTEND (1);
         vv_issue_yy.EXTEND (1);
         vv_pol_seq_no.EXTEND (1);
         vv_renew_no.EXTEND (1);
         vv_date_tag.EXTEND (1);

         BEGIN
            SELECT currency_rt
              INTO v_currency_rt
              FROM gipi_item
             WHERE policy_id = perl.policy_id AND item_no = item.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RAISE_APPLICATION_ERROR (
                  -20107,
                     'Geniisys Exception#E#The record with policy_id='
                  || TO_CHAR (perl.policy_id)
                  || ' and item_no='
                  || TO_CHAR (item.item_no)
                  || ' does not exists in gipi_item.');
         END;

         vv_issue_yy (v_cnt) := v_issue_yy;
         vv_pol_seq_no (v_cnt) := v_pol_seq_no;
         vv_renew_no (v_cnt) := v_renew_no;

         vv_iss_cd (v_cnt) := v_iss_cd;
         vv_line_cd (v_cnt) := v_line_cd;
         vv_subline_cd (v_cnt) := v_subline_cd;
         vv_policy_id (v_cnt) := perl.policy_id;
         vv_peril_cd (v_cnt) := perl.peril_cd;
         vv_tariff_cd (v_cnt) := NULL;
         vv_facul_prem (v_cnt) :=
            (perl.shr_pct / item.spct) * item.prem * v_currency_rt;
         vv_facul_tsi (v_cnt) :=
            ( (perl.shr_pct / item.spct) * item.tsi) * v_currency_rt;
         vv_facul_comm (v_cnt) :=
              ROUND (
                 perl.comm_rt * ( (perl.shr_pct / item.spct) * item.prem),
                 4)
            * v_currency_rt;
         vv_ri_cd (v_cnt) := perl.ri_cd;
         vv_local_foreign_sw (v_cnt) := perl.local_foreign_sw;

         v_acc_rev_date := NVL (TRUNC (perl.acc_rev_date), p_to_date + 60.0);

         IF perl.acc_ent_date >= p_fm_date AND v_acc_rev_date <= p_to_date
         THEN
            vv_facul_prem (v_cnt) := vv_facul_prem (v_cnt) * 0.0;
            vv_facul_tsi (v_cnt) := vv_facul_tsi (v_cnt) * 0.0;
            vv_facul_comm (v_cnt) := vv_facul_comm (v_cnt) * 0.0;
            vv_date_tag (v_cnt) := 'Z';
         ELSIF perl.acc_ent_date < p_fm_date AND v_acc_rev_date <= p_to_date
         THEN
            vv_facul_prem (v_cnt) := vv_facul_prem (v_cnt) * -1.0;
            vv_facul_tsi (v_cnt) := vv_facul_tsi (v_cnt) * -1.0;
            vv_facul_comm (v_cnt) := vv_facul_comm (v_cnt) * -1.0;
            vv_date_tag (v_cnt) := 'S';
         ELSE
            vv_date_tag (v_cnt) := 'A';
         END IF;

         IF v_cancel_date <= p_to_date
         THEN
            vv_date_tag (v_cnt) := 'C';
         END IF;

         IF vv_line_cd (v_cnt) = v_fi_line_cd
         THEN
            BEGIN                                          -- to get tariff_cd
               SELECT tarf_cd
                 INTO vv_tariff_cd (v_cnt)
                 FROM gipi_fireitem
                WHERE     policy_id = vv_policy_id (v_cnt)
                      AND item_no = item.item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         IF vv_line_cd (v_cnt) = v_mc_line_cd
         THEN
            BEGIN                                    -- to get subline_type_cd
               SELECT subline_type_cd
                 INTO vv_subline_type_cd (v_cnt)
                 FROM gipi_vehicle
                WHERE     policy_id = vv_policy_id (v_cnt)
                      AND item_no = item.item_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         IF vv_iss_cd (v_cnt) = 'RI'
         THEN
            BEGIN                                                -- get cedant
               SELECT ri_cd
                 INTO vv_cedant (v_cnt)
                 FROM giri_inpolbas rip
                WHERE rip.policy_id = vv_policy_id (v_cnt) AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;
      END LOOP;                                                        -- item
   END LOOP;                                                           -- perl

   IF v_cnt > 0
   THEN
      FORALL i IN vv_iss_cd.FIRST .. vv_iss_cd.LAST
         INSERT INTO GIAC_RECAP_PRIOR_DTL_EXT (iss_cd,
                                               line_cd,
                                               subline_cd,
                                               policy_id,
                                               peril_cd,
                                               tariff_cd,
                                               subline_type_cd,
                                               facul_prem,
                                               facul_comm,
                                               facul_tsi,
                                               ri_cd,
                                               local_foreign_sw,
                                               cedant,
                                               issue_yy,
                                               pol_seq_no,
                                               renew_no,
                                               date_tag)
              VALUES (vv_iss_cd (i),
                      vv_line_cd (i),
                      vv_subline_cd (i),
                      vv_policy_id (i),
                      vv_peril_cd (i),
                      vv_tariff_cd (i),
                      vv_subline_type_cd (i),
                      vv_facul_prem (i),
                      vv_facul_comm (i),
                      vv_facul_tsi (i),
                      vv_ri_cd (i),
                      vv_local_foreign_sw (i),
                      vv_cedant (i),
                      vv_issue_yy (i),
                      vv_pol_seq_no (i),
                      vv_renew_no (i),
                      vv_date_tag (i));
   END IF;

   vv_subline_cd.DELETE;

   SELECT subline_cd, bond_class_subline, ROWID
     BULK COLLECT INTO vv_subline_cd, vv_bond_class_subline, vv_rowid
     FROM GIAC_RECAP_PRIOR_DTL_EXT
    WHERE line_cd = v_su_line_cd;

   IF SQL%FOUND
   THEN
      FOR i IN vv_rowid.FIRST .. vv_rowid.LAST
      LOOP
         BEGIN
            SELECT class_no
              INTO vv_bond_class_subline (i)
              FROM giis_bond_class_subline
             WHERE     line_cd = v_su_line_cd
                   AND subline_cd = vv_subline_cd (i)
                   AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RAISE_APPLICATION_ERROR (
                  -20108,
                     'Geniisys Exception#E#Bond subline code '
                  || vv_subline_cd (i)
                  || ' has no bond class no in giis_bond_class_subline.');
         END;
      END LOOP;

      FORALL i IN vv_rowid.FIRST .. vv_rowid.LAST
         UPDATE GIAC_RECAP_PRIOR_DTL_EXT
            SET bond_class_subline = vv_bond_class_subline (i)
          WHERE ROWID = vv_rowid (i);
   END IF;

   pop_unearned_amount (p_to_date);

   COMMIT;

END;
/