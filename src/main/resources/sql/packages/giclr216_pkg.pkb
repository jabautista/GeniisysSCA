CREATE OR REPLACE PACKAGE BODY CPI.giclr216_pkg
AS
   FUNCTION get_giclr216_title
      RETURN CHAR
   IS
      v_addl   giis_reports.report_title%TYPE;
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR216')
      LOOP
         v_addl := rpt.title;
      END LOOP;

      RETURN (UPPER (v_addl));
   END get_giclr216_title;

   FUNCTION get_giclr216_heading (
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT    p_claim_date
                || ' from '
                || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                || ' to '
                || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
           INTO v_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_date := NULL;
      END;

      RETURN (v_date);
   END get_giclr216_heading;

   FUNCTION get_giclr216_line_name (p_line VARCHAR2, p_line_cd VARCHAR2)
      RETURN CHAR
   IS
      v_line_name   VARCHAR2 (100);
   BEGIN
      FOR a IN (SELECT INITCAP (line_name) line_name
                  FROM giis_line
                 WHERE line_cd = NVL (UPPER (p_line), p_line_cd))
      LOOP
         v_line_name := a.line_name;
      END LOOP;

      RETURN (v_line_name);
   END get_giclr216_line_name;

   FUNCTION get_giclr216_sub_name (
      p_subline      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2
   )
      RETURN CHAR
   IS
      --v_subline_name    VARCHAR2(100);
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT INITCAP (subline_name) subline_name
                  FROM giis_subline
                 WHERE subline_cd = NVL (UPPER (p_subline), p_subline_cd)
                   AND line_cd = NVL (UPPER (p_line), p_line_cd))
      LOOP
         v_subline_name := a.subline_name;
      END LOOP;

      RETURN (v_subline_name);
   END get_giclr216_sub_name;

   FUNCTION get_giclr216_net_reten (p_close_sw VARCHAR2, p_claim_id NUMBER)
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      IF p_close_sw = 'N'
      THEN
         FOR rec IN (SELECT SUM (  NVL (b.shr_loss_res_amt, 0)
                                 + NVL (b.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b
                      WHERE a.claim_id = p_claim_id
                        AND a.claim_id = b.claim_id
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND NVL (a.dist_sw, 'N') = 'Y'
                        AND b.share_type = 1)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_close_sw = 'Y'
      THEN
         FOR rec IN (SELECT SUM (NVL (c.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist a,
                            gicl_clm_loss_exp b,
                            gicl_loss_exp_ds c
                      WHERE a.claim_id = p_claim_id
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND b.claim_id = a.claim_id
                        AND b.tran_id = a.tran_id
                        AND b.item_no = a.item_no
                        AND b.peril_cd = a.peril_cd
                        AND c.claim_id = b.claim_id
                        AND c.clm_loss_id = b.clm_loss_id
                        AND NVL (c.negate_tag, 'N') = 'N'
                        AND c.share_type = 1)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END get_giclr216_net_reten;

   FUNCTION get_giclr216_treaty (p_close_sw VARCHAR2, p_claim_id NUMBER)
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      IF p_close_sw = 'N'
      THEN
         FOR rec IN (SELECT SUM (  NVL (b.shr_loss_res_amt, 0)
                                 + NVL (b.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b
                      WHERE a.claim_id = p_claim_id
                        AND a.claim_id = b.claim_id
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND NVL (a.dist_sw, 'N') = 'Y'
--                        AND b.share_type = 3)
                        AND b.share_type = 2) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_close_sw = 'Y'
      THEN
         FOR rec IN (SELECT SUM (NVL (c.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist a,
                            gicl_clm_loss_exp b,
                            gicl_loss_exp_ds c
                      WHERE a.claim_id = p_claim_id
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND b.claim_id = a.claim_id
                        AND b.tran_id = a.tran_id
                        AND b.item_no = a.item_no
                        AND b.peril_cd = a.peril_cd
                        AND c.claim_id = b.claim_id
                        AND c.clm_loss_id = b.clm_loss_id
                        AND NVL (c.negate_tag, 'N') = 'N'
--                        AND c.share_type = 3)
                        AND c.share_type = 2) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END get_giclr216_treaty;

   FUNCTION get_giclr216_xol (p_close_sw VARCHAR2, p_claim_id NUMBER)
      RETURN NUMBER
   IS
      v_amt             NUMBER                               := 0;
      v_param_value_v   giac_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_param_value_v
           FROM giac_parameters
          WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_param_value_v := NULL;
      END;

      IF p_close_sw = 'N'
      THEN
         FOR rec IN (SELECT SUM (  NVL (b.shr_loss_res_amt, 0)
                                 + NVL (b.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b
                      WHERE a.claim_id = p_claim_id
                        AND a.claim_id = b.claim_id
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND NVL (a.dist_sw, 'N') = 'Y'
                        AND b.share_type = v_param_value_v)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_close_sw = 'Y'
      THEN
         FOR rec IN (SELECT SUM (NVL (c.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist a,
                            gicl_clm_loss_exp b,
                            gicl_loss_exp_ds c
                      WHERE a.claim_id = p_claim_id
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND b.claim_id = a.claim_id
                        AND b.tran_id = a.tran_id
                        AND b.item_no = a.item_no
                        AND b.peril_cd = a.peril_cd
                        AND c.claim_id = b.claim_id
                        AND c.clm_loss_id = b.clm_loss_id
                        AND NVL (c.negate_tag, 'N') = 'N'
                        AND c.share_type = v_param_value_v)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END get_giclr216_xol;

   FUNCTION get_giclr216_facultative (p_close_sw VARCHAR2, p_claim_id NUMBER)
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      IF p_close_sw = 'N'
      THEN
         FOR rec IN (SELECT SUM (  NVL (b.shr_loss_res_amt, 0)
                                 + NVL (b.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b
                      WHERE a.claim_id = p_claim_id
                        AND a.claim_id = b.claim_id
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND NVL (a.dist_sw, 'N') = 'Y'
--                        AND b.share_type = 2)
                        AND b.share_type = 3) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_close_sw = 'Y'
      THEN
         FOR rec IN (SELECT SUM (NVL (c.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist a,
                            gicl_clm_loss_exp b,
                            gicl_loss_exp_ds c
                      WHERE a.claim_id = p_claim_id
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND b.claim_id = a.claim_id
                        AND b.tran_id = a.tran_id
                        AND b.item_no = a.item_no
                        AND b.peril_cd = a.peril_cd
                        AND c.claim_id = b.claim_id
                        AND c.clm_loss_id = b.clm_loss_id
                        AND NVL (c.negate_tag, 'N') = 'N'
--                        AND c.share_type = 2)
                        AND c.share_type = 3) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END get_giclr216_facultative;

   FUNCTION get_giclr216_net_ret_rec (
      p_claim_id      NUMBER,
      p_recovery_id   NUMBER,
      p_loss_date     DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT SUM (NVL (b.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt a, gicl_recovery_ds b
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id
                     AND NVL (a.cancel_tag, 'N') = 'N'
                     AND TO_NUMBER (TO_CHAR (a.tran_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY'))
                     AND a.recovery_id = b.recovery_id
                     AND a.recovery_payt_id = b.recovery_payt_id
                     AND NVL (b.negate_tag, 'N') = 'N'
                     AND b.share_type = 1)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END get_giclr216_net_ret_rec;

   FUNCTION get_giclr216_treaty_rec (
      p_claim_id      NUMBER,
      p_recovery_id   NUMBER,
      p_loss_date     DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT -SUM (NVL (b.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt a, gicl_recovery_ds b
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id
                     AND NVL (a.cancel_tag, 'N') = 'N'
                     AND TO_NUMBER (TO_CHAR (a.tran_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY'))
                     AND a.recovery_id = b.recovery_id
                     AND a.recovery_payt_id = b.recovery_payt_id
                     AND NVL (b.negate_tag, 'N') = 'N'
                     AND b.share_type = 3)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END get_giclr216_treaty_rec;

   FUNCTION get_giclr216_xol_rec (
      p_claim_id      NUMBER,
      p_recovery_id   NUMBER,
      p_loss_date     DATE
   )
      RETURN NUMBER
   IS
      v_amt             NUMBER;
      v_param_value_v   giac_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_param_value_v
           FROM giac_parameters
          WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_param_value_v := NULL;
      END;

      FOR rec IN (SELECT -SUM (NVL (b.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt a, gicl_recovery_ds b
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id
                     AND NVL (a.cancel_tag, 'N') = 'N'
                     AND TO_NUMBER (TO_CHAR (a.tran_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY'))
                     AND a.recovery_id = b.recovery_id
                     AND a.recovery_payt_id = b.recovery_payt_id
                     AND NVL (b.negate_tag, 'N') = 'N'
                     AND b.share_type = v_param_value_v)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END get_giclr216_xol_rec;

   FUNCTION get_giclr216_facul_rec (
      p_claim_id      NUMBER,
      p_recovery_id   NUMBER,
      p_loss_date     DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT -SUM (NVL (b.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt a, gicl_recovery_ds b
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id
                     AND NVL (a.cancel_tag, 'N') = 'N'
                     AND TO_NUMBER (TO_CHAR (a.tran_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY'))
                     AND a.recovery_id = b.recovery_id
                     AND a.recovery_payt_id = b.recovery_payt_id
                     AND NVL (b.negate_tag, 'N') = 'N'
                     AND b.share_type = 2)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END get_giclr216_facul_rec;

   FUNCTION get_giclr216_record (
      p_claim_date       VARCHAR2,
      p_ending_date      VARCHAR2,
      p_extract          NUMBER,
      p_line             VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_param_date       VARCHAR2,
      p_starting_date    VARCHAR2,
      p_subline          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN giclr216_tab PIPELINED
   IS
      v_list             giclr216_type;
      v_not_exist        BOOLEAN       := TRUE;
      v_loss_date_from   DATE     := TO_DATE (p_loss_date_from, 'MM/DD/YYYY');
      v_loss_date_to     DATE       := TO_DATE (p_loss_date_to, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.title := get_giclr216_title;
      v_list.heading :=
         get_giclr216_heading (p_claim_date, v_loss_date_from,
                               v_loss_date_to);

      FOR i IN (SELECT   a.line_cd, a.subline_cd, a.range_from, a.range_to,
                         b.loss_amt, b.close_sw,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (c.renew_no, '09')) pol,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_seq_no, '0000009')) clm,
                         c.clm_stat_cd, c.assured_name, c.loss_date,
                         c.claim_id
                    FROM gicl_loss_profile a,
                         gicl_loss_profile_ext3 b,
                         gicl_claims c
                   WHERE a.line_cd = NVL (p_line, a.line_cd)
                     AND a.user_id = UPPER (p_user)
                     AND NVL (a.subline_cd, '*') = NVL (p_subline, '*')
                     AND b.loss_amt >= a.range_from
                     AND b.loss_amt <= a.range_to
                     AND b.claim_id = c.claim_id
                     AND clm_stat_cd NOT IN ('CC', 'DN', 'WD')
                ORDER BY range_from ASC,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (c.renew_no, '09')) ASC,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_seq_no, '0000009')) ASC)
      LOOP
         v_not_exist := FALSE;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         --modified by gab 03.15.2016
--         v_rec.range_from := i.range_from;
--         v_rec.range_to := i.range_to;
        IF i.range_from <> 0
        THEN
         v_list.range_from := TO_CHAR(i.range_from, '99,999,999,999,999.99');
        ELSE
            v_list.range_from := TO_CHAR(i.range_from, '99,999,999,999,990.99');
        END IF;
         v_list.range_to := TO_CHAR(i.range_to, '99,999,999,999,999.99');
         --end 
         v_list.loss_amt := i.loss_amt;
         v_list.close_sw := i.close_sw;
         v_list.pol := i.pol;
         v_list.clm := i.clm;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.loss_date;
         v_list.claim_id := i.claim_id;
         v_list.line_name := get_giclr216_line_name (p_line, i.line_cd);
         v_list.sub_name :=
            get_giclr216_sub_name (p_subline, i.subline_cd, p_line,
                                   i.line_cd);
         v_list.net_reten :=
                     NVL (get_giclr216_net_reten (i.close_sw, i.claim_id), 0);
         v_list.treaty :=
                        NVL (get_giclr216_treaty (i.close_sw, i.claim_id), 0);
         v_list.xol := NVL (get_giclr216_xol (i.close_sw, i.claim_id), 0);
         v_list.facultative :=
                   NVL (get_giclr216_facultative (i.close_sw, i.claim_id), 0);

         FOR j IN (SELECT recovery_id, claim_id claim_id1,
                             line_cd
                          || '-'
                          || iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (SUBSTR (rec_year, 3), '09'))
                          || '-'
                          || LTRIM (TO_CHAR (rec_seq_no, '000009')) rec
                     FROM gicl_clm_recovery
                    WHERE claim_id = i.claim_id)
         LOOP
            v_list.recovery_id := j.recovery_id;
            v_list.claim_id1 := j.claim_id1;
            v_list.rec := j.rec;
            v_list.net_ret_rec :=
               NVL (get_giclr216_net_ret_rec (i.claim_id,
                                              j.recovery_id,
                                              i.loss_date
                                             ),
                    0
                   );
            v_list.treaty_rec :=
               NVL (get_giclr216_treaty_rec (i.claim_id,
                                             j.recovery_id,
                                             i.loss_date
                                            ),   
                    0
                   );
            v_list.xol_rec :=
               NVL (get_giclr216_xol_rec (i.claim_id,
                                          j.recovery_id,
                                          i.loss_date
                                         ),
                    0
                   );
            v_list.facul_rec :=
               NVL (get_giclr216_facul_rec (i.claim_id,
                                            j.recovery_id,
                                            i.loss_date
                                           ),
                    0
                   );
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr216_record;
END;
/


