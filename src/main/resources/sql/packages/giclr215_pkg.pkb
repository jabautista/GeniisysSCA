CREATE OR REPLACE PACKAGE BODY CPI.giclr215_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.29.2013
     **  Reference By : GICLR215
     **  Description  : Loss Profile Details, (Total Sum Insured)
     */
   FUNCTION cf_title
      RETURN CHAR
   IS
      v_addl   giis_reports.report_title%TYPE;
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR215')
      LOOP
         v_addl := rpt.title;
      END LOOP;

      RETURN (UPPER (v_addl));
   END;

   FUNCTION cf_heading1 (
      p_param_date      VARCHAR2,
      p_starting_date   DATE,
      p_ending_date     DATE
   )
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT    p_param_date
                || ' from '
                || TO_CHAR (p_starting_date, 'fmMonth DD, YYYY')
                || ' to '
                || TO_CHAR (p_ending_date, 'fmMonth DD, YYYY')
           INTO v_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_date := NULL;
      END;

      RETURN (v_date);
   END;

   FUNCTION cf_heading2 (
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN CHAR
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
   END;

   FUNCTION cf_line_name (p_line_cd VARCHAR2)
      RETURN CHAR
   IS
      v_line_name   VARCHAR2 (100);
   BEGIN
      FOR a IN (SELECT INITCAP (line_name) line_name
                  FROM giis_line
                 WHERE line_cd = NVL (UPPER (p_line_cd), line_cd))
      LOOP
         v_line_name := a.line_name;
      END LOOP;

      RETURN (v_line_name);
   END;

   FUNCTION cf_subline_name (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN CHAR
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT INITCAP (subline_name) subline_name
                  FROM giis_subline
                 WHERE subline_cd = NVL (UPPER (p_subline_cd), subline_cd)
                   AND line_cd = NVL (UPPER (p_line_cd), line_cd))
      LOOP
         v_subline_name := a.subline_name;
      END LOOP;

      RETURN (v_subline_name);
   END;

   FUNCTION cf_net_retention (
      p_clm_stat_cd      VARCHAR2,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date        DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      IF p_clm_stat_cd != 'CD'
      THEN
         FOR rec IN (SELECT SUM (  NVL (c018.shr_loss_res_amt, 0)
                                 + NVL (c018.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND c017.claim_id = c018.claim_id
                        AND c017.clm_res_hist_id = c018.clm_res_hist_id
                        AND NVL (c017.dist_sw, 'N') = 'Y'
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
                        AND c018.share_type = 1)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_clm_stat_cd = 'CD'
      THEN
         FOR rec IN (SELECT SUM (NVL (c018.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist c017,
                            gicl_clm_loss_exp c016,
                            gicl_loss_exp_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND NVL (c017.cancel_tag, 'N') = 'N'
                        AND c017.tran_id IS NOT NULL
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
                        AND c016.claim_id = c017.claim_id
                        AND c016.tran_id = c017.tran_id
                        AND c016.item_no = c017.item_no
                        AND c016.peril_cd = c017.peril_cd
                        AND c018.claim_id = c016.claim_id
                        AND c018.clm_loss_id = c016.clm_loss_id
                        AND NVL (c018.negate_tag, 'N') = 'N'
                        AND c018.share_type = 1)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END;

   FUNCTION cf_treaty (
      p_clm_stat_cd      VARCHAR2,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date        DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      IF p_clm_stat_cd != 'CD'
      THEN
         FOR rec IN (SELECT SUM (  NVL (c018.shr_loss_res_amt, 0)
                                 + NVL (c018.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND c017.claim_id = c018.claim_id
                        AND c017.clm_res_hist_id = c018.clm_res_hist_id
                        AND NVL (c017.dist_sw, 'N') = 'Y'
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
--                        AND c018.share_type = 3)
                        AND c018.share_type = 2) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_clm_stat_cd = 'CD'
      THEN
         FOR rec IN (SELECT SUM (NVL (c018.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist c017,
                            gicl_clm_loss_exp c016,
                            gicl_loss_exp_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND NVL (c017.cancel_tag, 'N') = 'N'
                        AND c017.tran_id IS NOT NULL
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
                        AND c016.claim_id = c017.claim_id
                        AND c016.tran_id = c017.tran_id
                        AND c016.item_no = c017.item_no
                        AND c016.peril_cd = c017.peril_cd
                        AND c018.claim_id = c016.claim_id
                        AND c018.clm_loss_id = c016.clm_loss_id
                        AND NVL (c018.negate_tag, 'N') = 'N'
--                        AND c018.share_type = 3)
                        AND c018.share_type = 2) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END;

   FUNCTION cf_xol (
      p_clm_stat_cd      VARCHAR2,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date        DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
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

      IF p_clm_stat_cd != 'CD'
      THEN
         FOR rec IN (SELECT SUM (  NVL (c018.shr_loss_res_amt, 0)
                                 + NVL (c018.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND c017.claim_id = c018.claim_id
                        AND c017.clm_res_hist_id = c018.clm_res_hist_id
                        AND NVL (c017.dist_sw, 'N') = 'Y'
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
                        AND c018.share_type = v_param_value_v)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_clm_stat_cd = 'CD'
      THEN
         FOR rec IN (SELECT SUM (NVL (c018.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist c017,
                            gicl_clm_loss_exp c016,
                            gicl_loss_exp_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND NVL (c017.cancel_tag, 'N') = 'N'
                        AND c017.tran_id IS NOT NULL
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
                        AND c016.claim_id = c017.claim_id
                        AND c016.tran_id = c017.tran_id
                        AND c016.item_no = c017.item_no
                        AND c016.peril_cd = c017.peril_cd
                        AND c018.claim_id = c016.claim_id
                        AND c018.clm_loss_id = c016.clm_loss_id
                        AND NVL (c018.negate_tag, 'N') = 'N'
                        AND c018.share_type = v_param_value_v)
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END;

   FUNCTION cf_facultative (
      p_clm_stat_cd      VARCHAR2,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date        DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      IF p_clm_stat_cd != 'CD'
      THEN
         FOR rec IN (SELECT SUM (  NVL (c018.shr_loss_res_amt, 0)
                                 + NVL (c018.shr_exp_res_amt, 0)
                                ) amt
                       FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND c017.claim_id = c018.claim_id
                        AND c017.clm_res_hist_id = c018.clm_res_hist_id
                        AND NVL (c017.dist_sw, 'N') = 'Y'
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
--                        AND c018.share_type = 2)
                        AND c018.share_type = 3) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      ELSIF p_clm_stat_cd = 'CD'
      THEN
         FOR rec IN (SELECT SUM (NVL (c018.shr_le_net_amt, 0)) amt
                       FROM gicl_clm_res_hist c017,
                            gicl_clm_loss_exp c016,
                            gicl_loss_exp_ds c018
                      WHERE c017.claim_id = p_claim_id
                        AND NVL (c017.cancel_tag, 'N') = 'N'
                        AND c017.tran_id IS NOT NULL
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) >= TRUNC (p_loss_date_from)
                        AND DECODE (p_loss_sw,
                                    'FD', TRUNC (p_clm_file_date),
                                    'LD', TRUNC (p_loss_date),
                                    SYSDATE
                                   ) <= TRUNC (p_loss_date_to)
                        AND c016.claim_id = c017.claim_id
                        AND c016.tran_id = c017.tran_id
                        AND c016.item_no = c017.item_no
                        AND c016.peril_cd = c017.peril_cd
                        AND c018.claim_id = c016.claim_id
                        AND c018.clm_loss_id = c016.clm_loss_id
                        AND NVL (c018.negate_tag, 'N') = 'N'
--                        AND c018.share_type = 2)
                        AND c018.share_type = 3) --edited by gab 12.17.2015
         LOOP
            v_amt := v_amt + NVL (rec.amt, 0);
            EXIT;
         END LOOP;
      END IF;

      RETURN (NVL (v_amt, 0));
   END;
    
   FUNCTION get_giclr215_record (
      p_line_cd          VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_user_id          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_param_date       VARCHAR2,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER,
      p_loss_sw          VARCHAR2
   )
      RETURN giclr215_record_tab PIPELINED
   IS
      v_rec   giclr215_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.title := cf_title;
      v_rec.heading1 :=
                   cf_heading1 (p_param_date, p_starting_date, p_ending_date);
      v_rec.heading2 :=
                 cf_heading2 (p_claim_date, p_loss_date_from, p_loss_date_to);

      FOR i IN (SELECT   a.range_from, a.range_to, b.tsi_amt, a.line_cd,
                         a.subline_cd,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_seq_no, '0000009'))
                                                                    claim_no,
                         c.clm_stat_cd, c.assured_name, c.clm_file_date,
                         c.loss_date, c.claim_id
                    FROM gicl_loss_profile a,
                         gicl_loss_profile_ext2 b,
                         gicl_claims c
                   WHERE a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.user_id = UPPER (p_user_id)
                     AND NVL (a.subline_cd, '*') = NVL (p_subline_cd, '*')
                     AND b.tsi_amt >= a.range_from
                     AND b.tsi_amt <= a.range_to
                     AND a.line_cd = b.line_cd
                     AND NVL (a.subline_cd, b.subline_cd) = b.subline_cd
                     AND c.line_cd = b.line_cd
                     AND c.subline_cd = b.subline_cd
                     AND c.pol_iss_cd = b.pol_iss_cd
                     AND c.issue_yy = b.issue_yy
                     AND c.pol_seq_no = b.pol_seq_no
                     AND c.renew_no = b.renew_no
                     AND c.clm_stat_cd NOT IN ('CC', 'DN', 'WD')
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (c.clm_file_date),
                                 'LD', TRUNC (c.loss_date),
                                 TRUNC(SYSDATE)
                                ) >= TRUNC (p_loss_date_from)
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (c.clm_file_date),
                                 'LD', TRUNC (c.loss_date),
                                 TRUNC(SYSDATE)
                                ) <= TRUNC (p_loss_date_to)
                GROUP BY a.range_from,
                         a.range_to,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09')),
                         a.line_cd,
                         a.subline_cd,
                         b.tsi_amt,
                            c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.clm_seq_no, '0000009')),
                         c.clm_stat_cd,
                         c.assured_name,
                         c.clm_file_date,
                         c.loss_date,
                         c.claim_id
                ORDER BY range_from,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09')) ASC)
      LOOP
         mjm := FALSE;
         --modified by gab 03.15.2016
--         v_rec.range_from := i.range_from;
--         v_rec.range_to := i.range_to;
        IF i.range_from <> 0
        THEN
         v_rec.range_from := TO_CHAR(i.range_from, '99,999,999,999,999.99');
        ELSE
            v_rec.range_from := TO_CHAR(i.range_from, '99,999,999,999,990.99');
        END IF;
         v_rec.range_to := TO_CHAR(i.range_to, '99,999,999,999,999.99');
         --end
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.policy_no := i.policy_no;
         v_rec.claim_no := i.claim_no;
         v_rec.clm_stat_cd := i.clm_stat_cd;
         v_rec.assured_name := i.assured_name;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.loss_date := i.loss_date;
         v_rec.claim_id := i.claim_id;
         v_rec.cf_line := i.line_cd || ' - ' || cf_line_name (i.line_cd);
--         v_rec.cf_subline :=
--            i.subline_cd || ' - '
--            || cf_subline_name (i.line_cd, i.subline_cd);
         v_rec.cf_subline := cf_subline_name (i.line_cd, i.subline_cd); --modified by gab 03.16.2016
         v_rec.net_retention :=
            cf_net_retention (i.clm_stat_cd,
                              i.claim_id,
                              p_loss_sw,
                              i.clm_file_date,
                              i.loss_date,
                              p_loss_date_from,
                              p_loss_date_to
                             );
         v_rec.treaty :=
            cf_treaty (i.clm_stat_cd,
                       i.claim_id,
                       p_loss_sw,
                       i.clm_file_date,
                       i.loss_date,
                       p_loss_date_from,
                       p_loss_date_to
                      );
         v_rec.xol :=
            cf_xol (i.clm_stat_cd,
                    i.claim_id,
                    p_loss_sw,
                    i.clm_file_date,
                    i.loss_date,
                    p_loss_date_from,
                    p_loss_date_to
                   );
         v_rec.facul :=
            cf_facultative (i.clm_stat_cd,
                            i.claim_id,
                            p_loss_sw,
                            i.clm_file_date,
                            i.loss_date,
                            p_loss_date_from,
                            p_loss_date_to
                           );
         v_rec.gross_loss :=
              cf_net_retention (i.clm_stat_cd,
                                i.claim_id,
                                p_loss_sw,
                                i.clm_file_date,
                                i.loss_date,
                                p_loss_date_from,
                                p_loss_date_to
                               )
            + cf_treaty (i.clm_stat_cd,
                         i.claim_id,
                         p_loss_sw,
                         i.clm_file_date,
                         i.loss_date,
                         p_loss_date_from,
                         p_loss_date_to
                        )
            + cf_xol (i.clm_stat_cd,
                      i.claim_id,
                      p_loss_sw,
                      i.clm_file_date,
                      i.loss_date,
                      p_loss_date_from,
                      p_loss_date_to
                     )
            + cf_facultative (i.clm_stat_cd,
                              i.claim_id,
                              p_loss_sw,
                              i.clm_file_date,
                              i.loss_date,
                              p_loss_date_from,
                              p_loss_date_to
                             );
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giclr215_record;

   FUNCTION cf_net_ret_rec (
      p_recovery_id      NUMBER,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_loss_date        DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT -SUM (NVL (c018.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt c017, gicl_recovery_ds c018
                   WHERE c017.claim_id = p_claim_id
                     AND c017.recovery_id = p_recovery_id
                     AND NVL (c017.cancel_tag, 'N') = 'N'
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) >= TRUNC (p_loss_date_from)
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) <= TRUNC (p_loss_date_to)
                     AND TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY')) =
                                  TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
                     AND c017.recovery_id = c018.recovery_id
                     AND c017.recovery_payt_id = c018.recovery_payt_id
                     AND NVL (c018.negate_tag, 'N') = 'N'
                     AND c018.share_type = 1)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_treaty_rec (
      p_recovery_id      NUMBER,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_loss_date        DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT -SUM (NVL (c018.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt c017, gicl_recovery_ds c018
                   WHERE c017.claim_id = p_claim_id
                     AND c017.recovery_id = p_recovery_id
                     AND NVL (c017.cancel_tag, 'N') = 'N'
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) >= TRUNC (p_loss_date_from)
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) <= TRUNC (p_loss_date_to)
                     AND TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY')) =
                                  TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
                     AND c017.recovery_id = c018.recovery_id
                     AND c017.recovery_payt_id = c018.recovery_payt_id
                     AND NVL (c018.negate_tag, 'N') = 'N'
                     AND c018.share_type = 3)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_xol_rec (
      p_recovery_id      NUMBER,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_loss_date        DATE
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

      FOR rec IN (SELECT -SUM (NVL (c018.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt c017, gicl_recovery_ds c018
                   WHERE c017.claim_id = p_claim_id
                     AND c017.recovery_id = p_recovery_id
                     AND NVL (c017.cancel_tag, 'N') = 'N'
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) >= TRUNC (p_loss_date_from)
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) <= TRUNC (p_loss_date_to)
                     AND TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY')) =
                                  TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
                     AND c017.recovery_id = c018.recovery_id
                     AND c017.recovery_payt_id = c018.recovery_payt_id
                     AND NVL (c018.negate_tag, 'N') = 'N'
                     AND c018.share_type = v_param_value_v)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_facul_rec (
      p_recovery_id      NUMBER,
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_loss_date        DATE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER;
   BEGIN
      FOR rec IN (SELECT -SUM (NVL (c018.shr_recovery_amt, 0)) amt
                    FROM gicl_recovery_payt c017, gicl_recovery_ds c018
                   WHERE c017.claim_id = p_claim_id
                     AND c017.recovery_id = p_recovery_id
                     AND NVL (c017.cancel_tag, 'N') = 'N'
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) >= TRUNC (p_loss_date_from)
                     AND DECODE (p_loss_sw,
                                 'FD', TRUNC (p_clm_file_date),
                                 'LD', TRUNC (p_loss_date),
                                 SYSDATE
                                ) <= TRUNC (p_loss_date_to)
                     AND TO_NUMBER (TO_CHAR (p_loss_date, 'YYYY')) =
                                  TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
                     AND c017.recovery_id = c018.recovery_id
                     AND c017.recovery_payt_id = c018.recovery_payt_id
                     AND NVL (c018.negate_tag, 'N') = 'N'
                     AND c018.share_type = 2)
      LOOP
         v_amt := rec.amt;
         EXIT;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION get_recovery_record (
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_loss_date        DATE,
      p_line_cd          VARCHAR2
   )
      RETURN recovery_record_tab PIPELINED
   IS
      v_rec   recovery_record_type;
   BEGIN
      FOR i IN (SELECT recovery_id, claim_id,
                          line_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (SUBSTR (rec_year, 3), '09'))
                       || '-'
                       || LTRIM (TO_CHAR (rec_seq_no, '000009')) rec
                  FROM gicl_clm_recovery
                  WHERE claim_id = p_claim_id)
      LOOP
         v_rec.recovery_id := i.recovery_id;
         v_rec.claim_id := i.claim_id;
         v_rec.rec := i.rec;
         v_rec.rec_net_retention :=
            cf_net_ret_rec (i.recovery_id,
                            i.claim_id,
                            p_loss_sw,
                            p_clm_file_date,
                            p_loss_date_from,
                            p_loss_date_to,
                            p_loss_date
                           );
         v_rec.rec_treaty :=
            cf_treaty_rec (i.recovery_id,
                           i.claim_id,
                           p_loss_sw,
                           p_clm_file_date,
                           p_loss_date_from,
                           p_loss_date_to,
                           p_loss_date
                          );
         v_rec.rec_xol :=
            cf_xol_rec (i.recovery_id,
                        i.claim_id,
                        p_loss_sw,
                        p_clm_file_date,
                        p_loss_date_from,
                        p_loss_date_to,
                        p_loss_date
                       );
         v_rec.rec_facul :=
            cf_facul_rec (i.recovery_id,
                          i.claim_id,
                          p_loss_sw,
                          p_clm_file_date,
                          p_loss_date_from,
                          p_loss_date_to,
                          p_loss_date
                         );
         v_rec.rec_gross_loss :=
              cf_net_ret_rec (i.recovery_id,
                              i.claim_id,
                              p_loss_sw,
                              p_clm_file_date,
                              p_loss_date_from,
                              p_loss_date_to,
                              p_loss_date
                             )
            + cf_treaty_rec (i.recovery_id,
                             i.claim_id,
                             p_loss_sw,
                             p_clm_file_date,
                             p_loss_date_from,
                             p_loss_date_to,
                             p_loss_date
                            )
            + cf_xol_rec (i.recovery_id,
                          i.claim_id,
                          p_loss_sw,
                          p_clm_file_date,
                          p_loss_date_from,
                          p_loss_date_to,
                          p_loss_date
                         )
            + cf_facul_rec (i.recovery_id,
                            i.claim_id,
                            p_loss_sw,
                            p_clm_file_date,
                            p_loss_date_from,
                            p_loss_date_to,
                            p_loss_date
                           );
         PIPE ROW (v_rec);
      END LOOP;
   END get_recovery_record;
END;
/


