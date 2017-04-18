CREATE OR REPLACE PACKAGE BODY CPI.gipir902f_pkg
AS
   FUNCTION get_gipir902f (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2
   )
      RETURN gipir902f_tab PIPELINED
   IS
      v   gipir902f_type;
   BEGIN
      FOR i IN (SELECT   f.range_from,
                            LTRIM (TO_CHAR (f.range_from,
                                            '999,999,999,999,999'
                                           )
                                  )
                         || ' - '
                         || LTRIM (TO_CHAR (f.range_to, '999,999,999,999,999'))
                                                                       RANGE,
                         a.pol, c.item_no item, a.ann_tsi_amt, c.prem_amt,
                         NVL (d.loss_amt, 0) loss_amt, a.subline_cd,
                         a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                         a.line_cd
                    FROM (SELECT   line_cd, subline_cd, iss_cd, issue_yy,
                                   pol_seq_no, renew_no,
                                      line_cd
                                   || '-'
                                   || subline_cd
                                   || '-'
                                   || iss_cd
                                   || '-'
                                   || issue_yy
                                   || '-'
                                   || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                                   || '-'
                                   || LTRIM (TO_CHAR (renew_no, '09')) pol,
                                   item_no, SUM (ann_tsi_amt) ann_tsi_amt
                              FROM gipi_polriskloss_item_ext
                          GROUP BY line_cd,
                                   subline_cd,
                                   iss_cd,
                                   issue_yy,
                                   pol_seq_no,
                                   renew_no,
                                      line_cd
                                   || '-'
                                   || subline_cd
                                   || '-'
                                   || iss_cd
                                   || '-'
                                   || issue_yy
                                   || '-'
                                   || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                                   || '-'
                                   || LTRIM (TO_CHAR (renew_no, '09')),
                                   item_no) a,
                         (SELECT    a.line_cd
                                 || '-'
                                 || a.subline_cd
                                 || '-'
                                 || a.pol_iss_cd
                                 || '-'
                                 || a.issue_yy
                                 || '-'
                                 || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.renew_no, '09')) pol,
                                 a.claim_id, c.item_no, b.loss_amt
                            FROM gicl_claims a,
                                 gicl_risk_loss_profile_ext3 b,
                                 gicl_clm_item c
                           WHERE a.claim_id = b.claim_id
                             AND b.claim_id = c.claim_id
                             AND b.item_no = c.item_no) d,
                         (SELECT      b.line_cd
                                   || '-'
                                   || b.subline_cd
                                   || '-'
                                   || b.iss_cd
                                   || '-'
                                   || b.issue_yy
                                   || '-'
                                   || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                                   || '-'
                                   || LTRIM (TO_CHAR (b.renew_no, '09')) pol,
                                   a.item_no, SUM (a.prem_amt) prem_amt
                              FROM gipi_item a,
                                   gipi_polbasic b,
                                   gipi_polriskloss_item_ext c
                             WHERE a.policy_id = b.policy_id
                               AND a.item_no = c.item_no
                               AND b.policy_id = c.policy_id
                          GROUP BY    b.line_cd
                                   || '-'
                                   || b.subline_cd
                                   || '-'
                                   || b.iss_cd
                                   || '-'
                                   || b.issue_yy
                                   || '-'
                                   || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                                   || '-'
                                   || LTRIM (TO_CHAR (b.renew_no, '09')),
                                   a.item_no) c,
                         gipi_risk_loss_profile_item f
                   WHERE a.pol = d.pol(+)
                     AND a.item_no = d.item_no(+)
                     AND a.pol = c.pol
                     AND a.item_no = c.item_no
                     AND f.line_cd = p_line_cd
                     AND NVL (f.subline_cd, '***') =
                                 NVL (p_subline_cd, NVL (f.subline_cd, '***'))
                     AND f.user_id = p_user_id
                     AND f.date_from = TO_DATE (p_date_from, 'mm-dd-yyyy')
                     AND f.date_to = TO_DATE (p_date_to, 'mm-dd-yyyy')
                     AND f.all_line_tag = p_all_line_tag
                     AND f.loss_date_from =
                                      TO_DATE (p_loss_date_from, 'mm-dd-yyyy')
                     AND f.loss_date_to =
                                        TO_DATE (p_loss_date_to, 'mm-dd-yyyy')
                     AND a.ann_tsi_amt BETWEEN f.range_from AND f.range_to
                     AND a.line_cd = f.line_cd
                     AND a.subline_cd = NVL (f.subline_cd, a.subline_cd)
                ORDER BY range_from, subline_cd, iss_cd, renew_no, pol_seq_no, issue_yy, line_cd, pol, loss_amt, item, ann_tsi_amt, prem_amt)
      LOOP
         v.range_from := i.range_from;
         v.RANGE := i.RANGE;
         v.subline_cd := i.subline_cd;
         v.iss_cd := i.iss_cd;
         v.renew_no := i.renew_no;
         v.pol_seq_no := i.pol_seq_no;
         v.issue_yy := i.issue_yy;
         v.line_cd := i.line_cd;
         v.pol := i.pol;
         v.loss_amt := i.loss_amt;
         v.ann_tsi_amt := i.ann_tsi_amt;
         v.prem_amt := i.prem_amt;

         FOR x IN (SELECT   policy_id
                       FROM gipi_polbasic
                      WHERE line_cd = i.line_cd
                        AND subline_cd = i.subline_cd
                        AND iss_cd = i.iss_cd
                        AND issue_yy = i.issue_yy
                        AND pol_seq_no = i.pol_seq_no
                        AND renew_no = i.renew_no
                   ORDER BY eff_date DESC)
         LOOP
            FOR y IN (SELECT item_title
                        FROM gipi_item
                       WHERE policy_id = x.policy_id AND item_no = i.item)
            LOOP
               v.item := i.item || ' - ' || y.item_title;
            END LOOP;

            IF v.item IS NOT NULL
            THEN
               EXIT;
            END IF;
         END LOOP;
         
         v.date_from := TRIM(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.date_to := TRIM(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_from := TRIM(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_to := TRIM(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'YYYY');

         PIPE ROW (v);
         v.item := NULL;
      END LOOP;
   END get_gipir902f;
END;
/


