CREATE OR REPLACE PACKAGE BODY CPI.csv_recap
AS
/* Created by: Ramon 04/15/2010, Generate CSV in GIACS290 - Recapitulation */
   FUNCTION csv_recap1 (p_report_name VARCHAR2)
      RETURN recap1_type PIPELINED
   IS
      v_recap1   recap1_rec_type;
   BEGIN
      IF p_report_name = 'PREMIUM'
      THEN
         FOR rec IN
            (SELECT   1 num, b.rowno, b.rowtitle,
                      DECODE (a.line_cd, 'MC', d.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                      NVL ((SELECT SUM (total) --Dean 05.09.2012 Added sum to prevent ora-01427
                              FROM giac_recap_count
                             WHERE rowno = b.rowno AND rowtitle = b.rowtitle),
                           0
                          ) no_of_pol,
                      NVL ((SELECT   COUNT (DISTINCT f.coc_serial_no)
                                FROM giac_recap_summ_ext e, gipi_vehicle f
                               WHERE e.policy_id = f.policy_id
                                 AND rowno = b.rowno
                                 AND rowtitle = b.rowtitle
                                 AND NVL (f.coc_serial_no, 0) <> 0
                                 AND e.line_cd = 'MC'
                                 AND e.peril_cd = (SELECT param_value_n
                                                     FROM giis_parameters
                                                    WHERE param_name = 'CTPL')
                            GROUP BY rowno, rowtitle),
                           0
                          ) coc,
                      SUM (NVL (a.direct_prem, 0)) direct_prem,
                      SUM (NVL (a.ceded_prem_auth, 0)) ceded_auth,
                      SUM (NVL (a.ceded_prem_asean, 0)) ceded_asean,
                      SUM (NVL (a.ceded_prem_oth, 0)) ceded_oth,
                      (  SUM (NVL (a.direct_prem, 0))
                       - SUM (NVL (a.ceded_prem_auth, 0))
                       - SUM (NVL (a.ceded_prem_asean, 0))
                       - SUM (NVL (a.ceded_prem_oth, 0))
                      ) direct_net,
                      SUM (NVL (a.inw_prem_auth, 0)) inw_auth,
                      SUM (NVL (a.inw_prem_asean, 0)) inw_asean,
                      SUM (NVL (a.inw_prem_oth, 0)) inw_oth,
                      SUM (NVL (a.retceded_prem_auth, 0)) ret_auth,
                      SUM (NVL (a.retceded_prem_asean, 0)) ret_asean,
                      SUM (NVL (a.retceded_prem_oth, 0)) ret_oth,
                      (  SUM (NVL (a.direct_prem, 0))
                       - SUM (NVL (a.ceded_prem_auth, 0))
                       - SUM (NVL (a.ceded_prem_asean, 0))
                       - SUM (NVL (a.ceded_prem_oth, 0))
                       + SUM (NVL (a.inw_prem_auth, 0))
                       + SUM (NVL (a.inw_prem_asean, 0))
                       + SUM (NVL (a.inw_prem_oth, 0))
                       - SUM (NVL (a.retceded_prem_auth, 0))
                       - SUM (NVL (a.retceded_prem_asean, 0))
                       - SUM (NVL (a.retceded_prem_oth, 0))
                      ) net_written
                 FROM giac_recap_summ_ext a,
                      giac_recap_summary_v b,
                      giis_peril c,  --Dean 05.09.2012
                      giis_subline d --Dean 05.09.2012
                WHERE 1 = 1
                  AND a.rowno(+) = b.rowno
                  AND a.rowtitle(+) = b.rowtitle
                  AND a.line_cd = c.line_cd    --Dean 05.09.2012
                  AND a.peril_cd = c.peril_cd  --Dean 05.09.2012
                  AND a.line_cd = d.line_cd    --Dean 05.09.2012
                  AND c.line_cd = d.line_cd    --Dean 05.09.2012
             GROUP BY b.rowno,
                      b.rowtitle,
                      DECODE (a.line_cd, 'MC', d.subline_name, NULL), --Dean 05.09.2012
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL)    --Dean 05.09.2012
             UNION
             SELECT   2, t2.subno,
                      DECODE (t2.subno,
                              1, 'FI TARIFF SUBTOTAL',
                              2, 'FI SR SUBTOTAL',
                              3, 'SU SUBTOTAL',
                              4, 'MC SUBTOTAL',
                              5, 'CA SUBTOTAL',
                              6, 'MN AND MH SUBTOTAL',
                              7, 'EN SUBTOTAL',
                              8, 'PA AND AH SUBTOTAL',
                              9, 'AV SUBTOTAL',
                              'MISC SUBTOTAL'
                             ) subtitle,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name,   --Dean 05.09.2012
                      NVL (SUM (no_of_pol), 0) no_of_pol,
                      NVL (SUM (coc), 0) coc,
                      NVL (SUM (direct_prem), 0) direct_prem,
                      NVL (SUM (ceded_auth), 0) ceded_auth,
                      NVL (SUM (ceded_asean), 0) ceded_asean,
                      NVL (SUM (ceded_oth), 0) ceded_oth,
                      NVL (SUM (direct_net), 0) direct_net,
                      NVL (SUM (inw_auth), 0) inw_auth,
                      NVL (SUM (inw_asean), 0) inw_asean,
                      NVL (SUM (inw_oth), 0) inw_oth,
                      NVL (SUM (ret_auth), 0) ret_auth,
                      NVL (SUM (ret_asean), 0) ret_asean,
                      NVL (SUM (ret_oth), 0) ret_oth,
                      NVL (SUM (net_written), 0) net_written
                 FROM (SELECT   CASE
                                   WHEN b.rowno IN (1, 2, 3, 4)
                                      THEN 1
                                   WHEN b.rowno IN (5, 6, 7, 8)
                                      THEN 2
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_SU')
                                      THEN 3
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_MC')
                                      THEN 4
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_CA')
                                      THEN 5
                                   WHEN a.line_cd IN
                                          (giisp.v ('LINE_CODE_MN'),
                                           giisp.v ('LINE_CODE_MH')
                                          )
                                      THEN 6
                                   WHEN a.line_cd IN
                                             (giisp.v ('LINE_CODE_EN'), 'E1')
                                      THEN 7
                                   WHEN a.line_cd IN
                                                   (giisp.v ('LINE_CODE_AC'))
                                      THEN 8
                                   WHEN a.line_cd = giisp.v ('LINE_CODE_AV')
                                      THEN 9
                                   ELSE 10
                                END subno,
                                a.line_cd, b.rowno rowno, b.rowtitle rowtitle,
                                DECODE (a.line_cd, 'MC', d.subline_name, NULL) subline_name, --Dean 05.09.2012 and decode for line MC
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name,     --Dean 05.09.2012 and decode for line MC
                                NVL ((SELECT SUM (total) --Dean 05.09.2012 Added sum to prevent ora-01427
                                        FROM giac_recap_count
                                       WHERE rowno = b.rowno
                                         AND rowtitle = b.rowtitle),
                                     0
                                    ) no_of_pol,
                                (SELECT   COUNT (DISTINCT f.coc_serial_no)
                                     FROM giac_recap_summ_ext e,
                                          gipi_vehicle f
                                    WHERE e.policy_id = f.policy_id
                                      AND rowno = b.rowno
                                      AND rowtitle = b.rowtitle
                                      AND NVL (f.coc_serial_no, 0) <> 0
                                      AND e.line_cd = 'MC'
                                      AND e.peril_cd =
                                                  (SELECT param_value_n
                                                     FROM giis_parameters
                                                    WHERE param_name = 'CTPL')
                                 GROUP BY rowno, rowtitle) coc,
                                SUM (NVL (a.direct_prem, 0)) direct_prem,
                                SUM (NVL (a.ceded_prem_auth, 0)) ceded_auth,
                                SUM (NVL (a.ceded_prem_asean, 0)) ceded_asean,
                                SUM (NVL (a.ceded_prem_oth, 0)) ceded_oth,
                                (  SUM (NVL (a.direct_prem, 0))
                                 - SUM (NVL (a.ceded_prem_auth, 0))
                                 - SUM (NVL (a.ceded_prem_asean, 0))
                                 - SUM (NVL (a.ceded_prem_oth, 0))
                                ) direct_net,
                                SUM (NVL (a.inw_prem_auth, 0)) inw_auth,
                                SUM (NVL (a.inw_prem_asean, 0)) inw_asean,
                                SUM (NVL (a.inw_prem_oth, 0)) inw_oth,
                                SUM (NVL (a.retceded_prem_auth, 0)) ret_auth,
                                SUM (NVL (a.retceded_prem_asean, 0))
                                                                    ret_asean,
                                SUM (NVL (a.retceded_prem_oth, 0)) ret_oth,
                                (  SUM (NVL (a.direct_prem, 0))
                                 - SUM (NVL (a.ceded_prem_auth, 0))
                                 - SUM (NVL (a.ceded_prem_asean, 0))
                                 - SUM (NVL (a.ceded_prem_oth, 0))
                                 + SUM (NVL (a.inw_prem_auth, 0))
                                 + SUM (NVL (a.inw_prem_asean, 0))
                                 + SUM (NVL (a.inw_prem_oth, 0))
                                 - SUM (NVL (a.retceded_prem_auth, 0))
                                 - SUM (NVL (a.retceded_prem_asean, 0))
                                 - SUM (NVL (a.retceded_prem_oth, 0))
                                ) net_written
                           FROM giac_recap_summ_ext a,
                                giac_recap_summary_v b,
                                giis_peril c,   --Dean 05.09.2012
                                giis_subline d  --Dean 05.09.2012
                          WHERE 1 = 1
                            AND a.rowno(+) = b.rowno
                            AND a.rowtitle(+) = b.rowtitle
                            AND a.line_cd = c.line_cd    --Dean 05.09.2012
                            AND a.peril_cd = c.peril_cd  --Dean 05.09.2012
                            AND a.line_cd = d.line_cd    --Dean 05.09.2012
                            AND c.line_cd = d.line_cd    --Dean 05.09.2012
                       GROUP BY a.line_cd,
                                b.rowno,
                                b.rowtitle,
                                DECODE (a.line_cd, 'MC', d.subline_name, NULL), --Dean 05.09.2012
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL) --Dean 05.09.2012
                       ORDER BY b.rowno) t1,
                      (SELECT 1 subno
                         FROM DUAL
                       UNION
                       SELECT 2
                         FROM DUAL
                       UNION
                       SELECT 3
                         FROM DUAL
                       UNION
                       SELECT 4
                         FROM DUAL
                       UNION
                       SELECT 5
                         FROM DUAL
                       UNION
                       SELECT 6
                         FROM DUAL
                       UNION
                       SELECT 7
                         FROM DUAL
                       UNION
                       SELECT 8
                         FROM DUAL
                       UNION
                       SELECT 9
                         FROM DUAL
                       UNION
                       SELECT 10
                         FROM DUAL) t2
                WHERE t1.subno(+) = t2.subno
             GROUP BY t2.subno,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name)   --Dean 05.09.2012
         LOOP
            v_recap1.rowtitle := rec.rowtitle;
            v_recap1.subline_name := rec.subline_name;   --Dean 05.09.2012
            v_recap1.peril_name := rec.peril_name;       --Dean 05.09.2012
            v_recap1.no_of_pol := rec.no_of_pol;
            v_recap1.coc := rec.coc;
            v_recap1.direct_prem := rec.direct_prem;
            v_recap1.ceded_auth := rec.ceded_auth;
            v_recap1.ceded_asean := rec.ceded_asean;
            v_recap1.ceded_oth := rec.ceded_oth;
            v_recap1.direct_net := rec.direct_net;
            v_recap1.inw_auth := rec.inw_auth;
            v_recap1.inw_asean := rec.inw_asean;
            v_recap1.inw_oth := rec.inw_oth;
            v_recap1.ret_auth := rec.ret_auth;
            v_recap1.ret_asean := rec.ret_asean;
            v_recap1.ret_oth := rec.ret_oth;
            v_recap1.net_written := rec.net_written;
            PIPE ROW (v_recap1);
         END LOOP;
      END IF;

      RETURN;
   END csv_recap1;

   --## END FUNCTION CSV_RECAP1 ##--
   FUNCTION csv_recap2 (p_report_name VARCHAR2)
      RETURN recap2_type PIPELINED
   IS
      v_recap2   recap2_rec_type;
   BEGIN
      IF p_report_name = 'LOSSPD'
      THEN
         FOR rec IN
            (SELECT   1 num, b.rowno, b.rowtitle,
                      DECODE (a.line_cd, 'MC', e.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                      NVL ((SELECT SUM(total_losspd) --Dean 05.09.2012 Added sum to prevent ora-01427
                              FROM giac_recap_count
                             WHERE rowno = b.rowno AND rowtitle = b.rowtitle),
                           0
                          ) no_of_pol,
                      SUM (NVL (a.gross_loss + a.gross_exp, 0)) direct_prem,
                      SUM (NVL (a.loss_auth + a.exp_auth, 0)) ceded_auth,
                      SUM (NVL (a.loss_asean + a.exp_asean, 0)) ceded_asean,
                      SUM (NVL (a.loss_oth + a.exp_oth, 0)) ceded_oth,
                      (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                       - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                       - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                       - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                      ) direct_net,
                      SUM (NVL (a.inw_grs_loss_auth + a.inw_grs_exp_auth, 0)
                          ) inw_auth,
                      SUM (NVL (a.inw_grs_loss_asean + a.inw_grs_exp_asean, 0)
                          ) inw_asean,
                      SUM (NVL (a.inw_grs_loss_oth + a.inw_grs_exp_oth, 0)
                          ) inw_oth,
                      SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0))
                                                                    ret_auth,
                      SUM (NVL (a.ret_loss_asean + a.ret_exp_asean, 0)
                          ) ret_asean,
                      SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0)) ret_oth,
                      (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                       - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                       - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                       - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                       + SUM (NVL (a.inw_grs_loss_auth + a.inw_grs_exp_auth,
                                   0)
                             )
                       + SUM (NVL (a.inw_grs_loss_asean + a.inw_grs_exp_asean,
                                   0
                                  )
                             )
                       + SUM (NVL (a.inw_grs_loss_oth + a.inw_grs_exp_oth, 0))
                       - SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0))
                       - SUM (NVL (a.ret_loss_asean + a.ret_exp_asean, 0))
                       - SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0))
                      ) net_written
                 FROM giac_recap_losspd_summ_ext a,
                      giac_recap_summary_lpd_v b,
                      giis_peril c,          --Dean 05.09.2012
                      gicl_clm_res_hist d,   --Dean 05.09.2012
                      giis_subline e         --Dean 05.09.2012
                WHERE 1 = 1
                  AND a.rowno = b.rowno
                  AND a.rowtitle = b.rowtitle
                  AND a.line_cd = c.line_cd     --Dean 05.09.2012
                  AND a.claim_id = d.claim_id   --Dean 05.09.2012
                  AND c.peril_cd = d.peril_cd   --Dean 05.09.2012
                  AND a.line_cd = e.line_cd     --Dean 05.09.2012
                  AND c.line_cd = e.line_cd     --Dean 05.09.2012
             GROUP BY b.rowno,
                      b.rowtitle,
                      DECODE (a.line_cd, 'MC', e.subline_name, NULL), --Dean 05.09.2012
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL)   --Dean 05.09.2012
             UNION
             SELECT   2, t2.subno,
                      DECODE (t2.subno,
                              1, 'FI TARIFF SUBTOTAL',
                              2, 'FI SR SUBTOTAL',
                              3, 'SU SUBTOTAL',
                              4, 'MC SUBTOTAL',
                              5, 'CA SUBTOTAL',
                              6, 'MN AND MH SUBTOTAL',
                              7, 'EN SUBTOTAL',
                              8, 'PA AND AH SUBTOTAL',
                              9, 'AV SUBTOTAL',
                              'MISC SUBTOTAL'
                             ) subtitle,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name,   --Dean 05.09.2012
                      NVL (SUM (t1.no_of_pol), 0) no_of_pol,
                      NVL (SUM (direct_prem), 0) direct_prem,
                      NVL (SUM (ceded_auth), 0) ceded_auth,
                      NVL (SUM (ceded_asean), 0) ceded_asean,
                      NVL (SUM (ceded_oth), 0) ceded_oth,
                      NVL (SUM (direct_net), 0) direct_net,
                      NVL (SUM (inw_auth), 0) inw_auth,
                      NVL (SUM (inw_asean), 0) inw_asean,
                      NVL (SUM (inw_oth), 0) inw_oth,
                      NVL (SUM (ret_auth), 0) ret_auth,
                      NVL (SUM (ret_asean), 0) ret_asean,
                      NVL (SUM (ret_oth), 0) ret_oth,
                      NVL (SUM (net_written), 0) net_written
                 FROM (SELECT   CASE
                                   WHEN b.rowno IN (1, 2, 3, 4)
                                      THEN 1
                                   WHEN b.rowno IN (5, 6, 7, 8)
                                      THEN 2
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_SU')
                                      THEN 3
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_MC')
                                      THEN 4
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_CA')
                                      THEN 5
                                   WHEN a.line_cd IN
                                          (giisp.v ('LINE_CODE_MN'),
                                           giisp.v ('LINE_CODE_MH')
                                          )
                                      THEN 6
                                   WHEN a.line_cd IN
                                             (giisp.v ('LINE_CODE_EN'), 'E1')
                                      THEN 7
                                   WHEN a.line_cd IN
                                                   (giisp.v ('LINE_CODE_AC'))
                                      THEN 8
                                   WHEN a.line_cd = giisp.v ('LINE_CODE_AV')
                                      THEN 9
                                   ELSE 10
                                END subno,
                                a.line_cd, b.rowno, b.rowtitle,
                                DECODE (a.line_cd, 'MC', e.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                                NVL ((SELECT SUM(total_losspd) --Dean 05.09.2012 Added sum to prevent ora-01427
                                        FROM giac_recap_count
                                       WHERE rowno = b.rowno
                                         AND rowtitle = b.rowtitle),
                                     0
                                    ) no_of_pol,
                                SUM (NVL (a.gross_loss + a.gross_exp, 0)
                                    ) direct_prem,
                                SUM (NVL (a.loss_auth + a.exp_auth, 0)
                                    ) ceded_auth,
                                SUM (NVL (a.loss_asean + a.exp_asean, 0)
                                    ) ceded_asean,
                                SUM (NVL (a.loss_oth + a.exp_oth, 0)
                                    ) ceded_oth,
                                (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                                 - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                                 - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                                 - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                ) direct_net,
                                SUM (NVL (  a.inw_grs_loss_auth
                                          + a.inw_grs_exp_auth,
                                          0
                                         )
                                    ) inw_auth,
                                SUM (NVL (  a.inw_grs_loss_asean
                                          + a.inw_grs_exp_asean,
                                          0
                                         )
                                    ) inw_asean,
                                SUM (NVL (  a.inw_grs_loss_oth
                                          + a.inw_grs_exp_oth,
                                          0
                                         )
                                    ) inw_oth,
                                SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0)
                                    ) ret_auth,
                                SUM (NVL (a.ret_loss_asean + a.ret_exp_asean,
                                          0
                                         )
                                    ) ret_asean,
                                SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0)
                                    ) ret_oth,
                                (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                                 - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                                 - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                                 - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                 + SUM (NVL (  a.inw_grs_loss_auth
                                             + a.inw_grs_exp_auth,
                                             0
                                            )
                                       )
                                 + SUM (NVL (  a.inw_grs_loss_asean
                                             + a.inw_grs_exp_asean,
                                             0
                                            )
                                       )
                                 + SUM (NVL (  a.inw_grs_loss_oth
                                             + a.inw_grs_exp_oth,
                                             0
                                            )
                                       )
                                 - SUM (NVL (a.ret_loss_auth + a.ret_exp_auth,
                                             0
                                            )
                                       )
                                 - SUM (NVL (a.ret_loss_asean
                                             + a.ret_exp_asean,
                                             0
                                            )
                                       )
                                 - SUM (NVL (a.ret_loss_oth + a.ret_exp_oth,
                                             0)
                                       )
                                ) net_written
                           FROM giac_recap_losspd_summ_ext a,
                                giac_recap_summary_lpd_v b,
                                giis_peril c,          --Dean 05.09.2012
                                gicl_clm_res_hist d,   --Dean 05.09.2012
                                giis_subline e         --Dean 05.09.2012
                          WHERE 1 = 1
                            AND a.rowno = b.rowno
                            AND a.rowtitle = b.rowtitle
                            AND a.line_cd = c.line_cd     --Dean 05.09.2012
                            AND a.claim_id = d.claim_id   --Dean 05.09.2012
                            AND c.peril_cd = d.peril_cd   --Dean 05.09.2012
                            AND a.line_cd = e.line_cd     --Dean 05.09.2012
                            AND c.line_cd = e.line_cd     --Dean 05.09.2012
                       GROUP BY a.line_cd,
                                b.rowno,
                                b.rowtitle,
                                DECODE (a.line_cd, 'MC', e.subline_name, NULL),  --Dean 05.09.2012
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL)    --Dean 05.09.2012
                       ORDER BY b.rowno) t1,
                      (SELECT 1 subno
                         FROM DUAL
                       UNION
                       SELECT 2
                         FROM DUAL
                       UNION
                       SELECT 3
                         FROM DUAL
                       UNION
                       SELECT 4
                         FROM DUAL
                       UNION
                       SELECT 5
                         FROM DUAL
                       UNION
                       SELECT 6
                         FROM DUAL
                       UNION
                       SELECT 7
                         FROM DUAL
                       UNION
                       SELECT 8
                         FROM DUAL
                       UNION
                       SELECT 9
                         FROM DUAL
                       UNION
                       SELECT 10
                         FROM DUAL) t2
                WHERE t1.subno(+) = t2.subno
             GROUP BY t2.subno,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name)   --Dean 05.09.2012
         LOOP
            v_recap2.rowtitle := rec.rowtitle;
            v_recap2.subline_name := rec.subline_name;  --Dean 05.09.2012
            v_recap2.peril_name := rec.peril_name;      --Dean 05.09.2012
            v_recap2.direct_prem := rec.direct_prem;
            v_recap2.ceded_auth := rec.ceded_auth;
            v_recap2.ceded_asean := rec.ceded_asean;
            v_recap2.ceded_oth := rec.ceded_oth;
            v_recap2.direct_net := rec.direct_net;
            v_recap2.inw_auth := rec.inw_auth;
            v_recap2.inw_asean := rec.inw_asean;
            v_recap2.inw_oth := rec.inw_oth;
            v_recap2.ret_auth := rec.ret_auth;
            v_recap2.ret_asean := rec.ret_asean;
            v_recap2.ret_oth := rec.ret_oth;
            v_recap2.net_written := rec.net_written;
            PIPE ROW (v_recap2);
         END LOOP;
      ELSIF p_report_name = 'OSLOSS'
      THEN
         FOR rec IN
            (SELECT   1 num, b.rowno, b.rowtitle,
                      DECODE (a.line_cd, 'MC', e.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                      NVL ((SELECT SUM(total_osloss) --Dean 05.09.2012 Added sum to prevent ora-01427
                              FROM giac_recap_count
                             WHERE rowno = b.rowno AND rowtitle = b.rowtitle),
                           0
                          ) no_of_pol,
                      SUM (NVL (a.gross_loss + a.gross_exp, 0)) direct_prem,
                      SUM (NVL (a.loss_auth + a.exp_auth, 0)) ceded_auth,
                      SUM (NVL (a.loss_asean + a.exp_asean, 0)) ceded_asean,
                      SUM (NVL (a.loss_oth + a.exp_oth, 0)) ceded_oth,
                      (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                       - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                       - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                       - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                      ) direct_net,
                      SUM (NVL (a.inw_grs_loss_auth + a.inw_grs_exp_auth, 0)
                          ) inw_auth,
                      SUM (NVL (a.inw_grs_loss_asean + a.inw_grs_exp_asean, 0)
                          ) inw_asean,
                      SUM (NVL (a.inw_grs_loss_oth + a.inw_grs_exp_oth, 0)
                          ) inw_oth,
                      SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0))
                                                                    ret_auth,
                      SUM (NVL (a.ret_loss_asean + a.ret_exp_asean, 0)
                          ) ret_asean,
                      SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0)) ret_oth,
                      (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                       - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                       - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                       - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                       + SUM (NVL (a.inw_grs_loss_auth + a.inw_grs_exp_auth,
                                   0)
                             )
                       + SUM (NVL (a.inw_grs_loss_asean + a.inw_grs_exp_asean,
                                   0
                                  )
                             )
                       + SUM (NVL (a.inw_grs_loss_oth + a.inw_grs_exp_oth, 0))
                       - SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0))
                       - SUM (NVL (a.ret_loss_asean + a.ret_exp_asean, 0))
                       - SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0))
                      ) net_written
                 FROM giac_recap_osloss_summ_ext a,
                      giac_recap_summary_osl_v b,
                      giis_peril c,          --Dean 05.09.2012
                      gicl_clm_res_hist d,   --Dean 05.09.2012
                      giis_subline e         --Dean 05.09.2012
                WHERE 1 = 1
                  AND a.rowno(+) = b.rowno
                  AND a.rowtitle(+) = b.rowtitle
                  AND a.line_cd = c.line_cd     --Dean 05.09.2012
                  AND a.claim_id = d.claim_id   --Dean 05.09.2012
                  AND c.peril_cd = d.peril_cd   --Dean 05.09.2012
                  AND a.line_cd = e.line_cd     --Dean 05.09.2012
                  AND c.line_cd = e.line_cd     --Dean 05.09.2012
             GROUP BY b.rowno,
                      b.rowtitle,
                      DECODE (a.line_cd, 'MC', e.subline_name, NULL),  --Dean 05.09.2012
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL)    --Dean 05.09.2012
             UNION
             SELECT   2, t2.subno,
                      DECODE (t2.subno,
                              1, 'FI TARIFF SUBTOTAL',
                              2, 'FI SR SUBTOTAL',
                              3, 'SU SUBTOTAL',
                              4, 'MC SUBTOTAL',
                              5, 'CA SUBTOTAL',
                              6, 'MN AND MH SUBTOTAL',
                              7, 'EN SUBTOTAL',
                              8, 'PA AND AH SUBTOTAL',
                              9, 'AV SUBTOTAL',
                              'MISC SUBTOTAL'
                             ) subtitle,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name,   --Dean 05.09.2012
                      NVL (SUM (t1.no_of_pol), 0) no_of_pol,
                      NVL (SUM (direct_prem), 0) direct_prem,
                      NVL (SUM (ceded_auth), 0) ceded_auth,
                      NVL (SUM (ceded_asean), 0) ceded_asean,
                      NVL (SUM (ceded_oth), 0) ceded_oth,
                      NVL (SUM (direct_net), 0) direct_net,
                      NVL (SUM (inw_auth), 0) inw_auth,
                      NVL (SUM (inw_asean), 0) inw_asean,
                      NVL (SUM (inw_oth), 0) inw_oth,
                      NVL (SUM (ret_auth), 0) ret_auth,
                      NVL (SUM (ret_asean), 0) ret_asean,
                      NVL (SUM (ret_oth), 0) ret_oth,
                      NVL (SUM (net_written), 0) net_written
                 FROM (SELECT   CASE
                                   WHEN b.rowno IN (1, 2, 3, 4)
                                      THEN 1
                                   WHEN b.rowno IN (5, 6, 7, 8)
                                      THEN 2
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_SU')
                                      THEN 3
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_MC')
                                      THEN 4
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_CA')
                                      THEN 5
                                   WHEN a.line_cd IN
                                          (giisp.v ('LINE_CODE_MN'),
                                           giisp.v ('LINE_CODE_MH')
                                          )
                                      THEN 6
                                   WHEN a.line_cd IN
                                             (giisp.v ('LINE_CODE_EN'), 'E1')
                                      THEN 7
                                   WHEN a.line_cd IN
                                                   (giisp.v ('LINE_CODE_AC'))
                                      THEN 8
                                   WHEN a.line_cd = giisp.v ('LINE_CODE_AV')
                                      THEN 9
                                   ELSE 10
                                END subno,
                                a.line_cd, b.rowno, b.rowtitle,
                                DECODE (a.line_cd, 'MC', e.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                                NVL ((SELECT SUM(total_osloss)  --Dean 05.09.2012 Added sum to prevent ora-01427
                                        FROM giac_recap_count
                                       WHERE rowno = b.rowno
                                         AND rowtitle = b.rowtitle),
                                     0
                                    ) no_of_pol,
                                SUM (NVL (a.gross_loss + a.gross_exp, 0)
                                    ) direct_prem,
                                SUM (NVL (a.loss_auth + a.exp_auth, 0)
                                    ) ceded_auth,
                                SUM (NVL (a.loss_asean + a.exp_asean, 0)
                                    ) ceded_asean,
                                SUM (NVL (a.loss_oth + a.exp_oth, 0)
                                    ) ceded_oth,
                                (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                                 - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                                 - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                                 - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                ) direct_net,
                                SUM (NVL (  a.inw_grs_loss_auth
                                          + a.inw_grs_exp_auth,
                                          0
                                         )
                                    ) inw_auth,
                                SUM (NVL (  a.inw_grs_loss_asean
                                          + a.inw_grs_exp_asean,
                                          0
                                         )
                                    ) inw_asean,
                                SUM (NVL (  a.inw_grs_loss_oth
                                          + a.inw_grs_exp_oth,
                                          0
                                         )
                                    ) inw_oth,
                                SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0)
                                    ) ret_auth,
                                SUM (NVL (a.ret_loss_asean + a.ret_exp_asean,
                                          0
                                         )
                                    ) ret_asean,
                                SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0)
                                    ) ret_oth,
                                (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                                 - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                                 - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                                 - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                 + SUM (NVL (  a.inw_grs_loss_auth
                                             + a.inw_grs_exp_auth,
                                             0
                                            )
                                       )
                                 + SUM (NVL (  a.inw_grs_loss_asean
                                             + a.inw_grs_exp_asean,
                                             0
                                            )
                                       )
                                 + SUM (NVL (  a.inw_grs_loss_oth
                                             + a.inw_grs_exp_oth,
                                             0
                                            )
                                       )
                                 - SUM (NVL (a.ret_loss_auth + a.ret_exp_auth,
                                             0
                                            )
                                       )
                                 - SUM (NVL (a.ret_loss_asean
                                             + a.ret_exp_asean,
                                             0
                                            )
                                       )
                                 - SUM (NVL (a.ret_loss_oth + a.ret_exp_oth,
                                             0)
                                       )
                                ) net_written
                           FROM giac_recap_osloss_summ_ext a,
                                giac_recap_summary_osl_v b,
                                giis_peril c,          --Dean 05.09.2012
                                gicl_clm_res_hist d,   --Dean 05.09.2012
                                giis_subline e         --Dean 05.09.2012
                          WHERE 1 = 1 AND a.rowno(+) = b.rowno
                            AND a.rowtitle(+) = b.rowtitle
                            AND a.line_cd = c.line_cd     --Dean 05.09.2012
                            AND a.claim_id = d.claim_id   --Dean 05.09.2012
                            AND c.peril_cd = d.peril_cd   --Dean 05.09.2012
                            AND a.line_cd = e.line_cd     --Dean 05.09.2012
                            AND c.line_cd = e.line_cd     --Dean 05.09.2012    
                       GROUP BY a.line_cd,
                                b.rowno,
                                b.rowtitle,
                                DECODE (a.line_cd, 'MC', e.subline_name, NULL),  --Dean 05.09.2012
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL)    --Dean 05.09.2012
                       ORDER BY b.rowno) t1,
                      (SELECT 1 subno
                         FROM DUAL
                       UNION
                       SELECT 2
                         FROM DUAL
                       UNION
                       SELECT 3
                         FROM DUAL
                       UNION
                       SELECT 4
                         FROM DUAL
                       UNION
                       SELECT 5
                         FROM DUAL
                       UNION
                       SELECT 6
                         FROM DUAL
                       UNION
                       SELECT 7
                         FROM DUAL
                       UNION
                       SELECT 8
                         FROM DUAL
                       UNION
                       SELECT 9
                         FROM DUAL
                       UNION
                       SELECT 10
                         FROM DUAL) t2
                WHERE t1.subno(+) = t2.subno
             GROUP BY t2.subno,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name)   --Dean 05.09.2012
         LOOP
            v_recap2.rowtitle := rec.rowtitle;
            v_recap2.subline_name := rec.subline_name;  --Dean 05.09.2012
            v_recap2.peril_name := rec.peril_name;      --Dean 05.09.2012
            v_recap2.no_of_pol := rec.no_of_pol;
            v_recap2.direct_prem := rec.direct_prem;
            v_recap2.ceded_auth := rec.ceded_auth;
            v_recap2.ceded_asean := rec.ceded_asean;
            v_recap2.ceded_oth := rec.ceded_oth;
            v_recap2.direct_net := rec.direct_net;
            v_recap2.inw_auth := rec.inw_auth;
            v_recap2.inw_asean := rec.inw_asean;
            v_recap2.inw_oth := rec.inw_oth;
            v_recap2.ret_auth := rec.ret_auth;
            v_recap2.ret_asean := rec.ret_asean;
            v_recap2.ret_oth := rec.ret_oth;
            v_recap2.net_written := rec.net_written;
            PIPE ROW (v_recap2);
         END LOOP;
      END IF;

      RETURN;
   END csv_recap2;

   --## END FUNCTION CSV_RECAP2 ##--
   FUNCTION csv_recap3 (p_report_name VARCHAR2)
      RETURN recap3_type PIPELINED
   IS
      v_recap3   recap3_rec_type;
   BEGIN
      IF p_report_name = 'COMM'
      THEN
         FOR rec IN
            (SELECT   1 num, b.rowno rowno, b.rowtitle rowtitle,
                      DECODE (a.line_cd, 'MC', d.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                      SUM (NVL (a.direct_comm, 0)) direct_prem,
                      SUM (NVL (a.ceded_comm_auth, 0)) ceded_auth,
                      SUM (NVL (a.ceded_comm_asean, 0)) ceded_asean,
                      SUM (NVL (a.ceded_comm_oth, 0)) ceded_oth,
                      (  SUM (NVL (a.direct_comm, 0))
                       - SUM (NVL (a.ceded_comm_auth, 0))
                       - SUM (NVL (a.ceded_comm_asean, 0))
                       - SUM (NVL (a.ceded_comm_oth, 0))
                      ) direct_net,
                      SUM (NVL (a.inw_comm_auth, 0)) inw_auth,
                      SUM (NVL (a.inw_comm_asean, 0)) inw_asean,
                      SUM (NVL (a.inw_comm_oth, 0)) inw_oth,
                      SUM (NVL (a.retceded_comm_auth, 0)) ret_auth,
                      SUM (NVL (a.retceded_comm_asean, 0)) ret_asean,
                      SUM (NVL (a.retceded_comm_oth, 0)) ret_oth,
                      (  SUM (NVL (a.direct_comm, 0))
                       - SUM (NVL (a.ceded_comm_auth, 0))
                       - SUM (NVL (a.ceded_comm_asean, 0))
                       - SUM (NVL (a.ceded_comm_oth, 0))
                       + SUM (NVL (a.inw_comm_auth, 0))
                       + SUM (NVL (a.inw_comm_asean, 0))
                       + SUM (NVL (a.inw_comm_oth, 0))
                       - SUM (NVL (a.retceded_comm_auth, 0))
                       - SUM (NVL (a.retceded_comm_asean, 0))
                       - SUM (NVL (a.retceded_comm_oth, 0))
                      ) net_written
                 FROM giac_recap_summ_ext a,
                      giac_recap_summary_v b,
                      giis_peril c,  --Dean 05.09.2012
                      giis_subline d --Dean 05.09.2012
                WHERE 1 = 1
                  AND a.rowno(+) = b.rowno
                  AND a.rowtitle(+) = b.rowtitle
                  AND a.line_cd = c.line_cd    --Dean 05.09.2012
                  AND a.peril_cd = c.peril_cd  --Dean 05.09.2012
                  AND a.line_cd = d.line_cd    --Dean 05.09.2012
                  AND c.line_cd = d.line_cd    --Dean 05.09.2012
             GROUP BY b.rowno,
                      b.rowtitle,
                      DECODE (a.line_cd, 'MC', d.subline_name, NULL), --Dean 05.09.2012
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL)    --Dean 05.09.2012
             UNION
             SELECT   2, t2.subno,
                      DECODE (t2.subno,
                              1, 'FI TARIFF SUBTOTAL',
                              2, 'FI SR SUBTOTAL',
                              3, 'SU SUBTOTAL',
                              4, 'MC SUBTOTAL',
                              5, 'CA SUBTOTAL',
                              6, 'MN AND MH SUBTOTAL',
                              7, 'EN SUBTOTAL',
                              8, 'PA AND AH SUBTOTAL',
                              9, 'AV SUBTOTAL',
                              'MISC SUBTOTAL'
                             ) subtitle,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name,   --Dean 05.09.2012
                      NVL (SUM (direct_prem), 0) direct_prem,
                      NVL (SUM (ceded_auth), 0) ceded_auth,
                      NVL (SUM (ceded_asean), 0) ceded_asean,
                      NVL (SUM (ceded_oth), 0) ceded_oth,
                      NVL (SUM (direct_net), 0) direct_net,
                      NVL (SUM (inw_auth), 0) inw_auth,
                      NVL (SUM (inw_asean), 0) inw_asean,
                      NVL (SUM (inw_oth), 0) inw_oth,
                      NVL (SUM (ret_auth), 0) ret_auth,
                      NVL (SUM (ret_asean), 0) ret_asean,
                      NVL (SUM (ret_oth), 0) ret_oth,
                      NVL (SUM (net_written), 0) net_written
                 FROM (SELECT   CASE
                                   WHEN b.rowno IN (1, 2, 3, 4)
                                      THEN 1
                                   WHEN b.rowno IN (5, 6, 7, 8)
                                      THEN 2
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_SU')
                                      THEN 3
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_MC')
                                      THEN 4
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_CA')
                                      THEN 5
                                   WHEN a.line_cd IN
                                          (giisp.v ('LINE_CODE_MN'),
                                           giisp.v ('LINE_CODE_MH')
                                          )
                                      THEN 6
                                   WHEN a.line_cd IN
                                             (giisp.v ('LINE_CODE_EN'), 'E1')
                                      THEN 7
                                   WHEN a.line_cd IN
                                                   (giisp.v ('LINE_CODE_AC'))
                                      THEN 8
                                   WHEN a.line_cd = giisp.v ('LINE_CODE_AV')
                                      THEN 9
                                   ELSE 10
                                END subno,
                                a.line_cd, b.rowno rowno, b.rowtitle rowtitle,
                                DECODE (a.line_cd, 'MC', d.subline_name, NULL) subline_name, --Dean 05.09.2012 and decode for line MC
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name,     --Dean 05.09.2012 and decode for line MC
                                SUM (NVL (a.direct_comm, 0)) direct_prem,
                                SUM (NVL (a.ceded_comm_auth, 0)) ceded_auth,
                                SUM (NVL (a.ceded_comm_asean, 0)) ceded_asean,
                                SUM (NVL (a.ceded_comm_oth, 0)) ceded_oth,
                                (  SUM (NVL (a.direct_comm, 0))
                                 - SUM (NVL (a.ceded_comm_auth, 0))
                                 - SUM (NVL (a.ceded_comm_asean, 0))
                                 - SUM (NVL (a.ceded_comm_oth, 0))
                                ) direct_net,
                                SUM (NVL (a.inw_comm_auth, 0)) inw_auth,
                                SUM (NVL (a.inw_comm_asean, 0)) inw_asean,
                                SUM (NVL (a.inw_comm_oth, 0)) inw_oth,
                                SUM (NVL (a.retceded_comm_auth, 0)) ret_auth,
                                SUM (NVL (a.retceded_comm_asean, 0))
                                                                    ret_asean,
                                SUM (NVL (a.retceded_comm_oth, 0)) ret_oth,
                                (  SUM (NVL (a.direct_comm, 0))
                                 - SUM (NVL (a.ceded_comm_auth, 0))
                                 - SUM (NVL (a.ceded_comm_asean, 0))
                                 - SUM (NVL (a.ceded_comm_oth, 0))
                                 + SUM (NVL (a.inw_comm_auth, 0))
                                 + SUM (NVL (a.inw_comm_asean, 0))
                                 + SUM (NVL (a.inw_comm_oth, 0))
                                 - SUM (NVL (a.retceded_comm_auth, 0))
                                 - SUM (NVL (a.retceded_comm_asean, 0))
                                 - SUM (NVL (a.retceded_comm_oth, 0))
                                ) net_written
                           FROM giac_recap_summ_ext a,
                                giac_recap_summary_v b,
                                giis_peril c,   --Dean 05.09.2012
                                giis_subline d  --Dean 05.09.2012
                          WHERE 1 = 1 AND a.rowno(+) = b.rowno
                            AND a.rowtitle(+) = b.rowtitle
                            AND a.line_cd = c.line_cd    --Dean 05.09.2012
                            AND a.peril_cd = c.peril_cd  --Dean 05.09.2012
                            AND a.line_cd = d.line_cd    --Dean 05.09.2012
                            AND c.line_cd = d.line_cd    --Dean 05.09.2012
                       GROUP BY a.line_cd,
                                b.rowno,
                                b.rowtitle,
                                DECODE (a.line_cd, 'MC', d.subline_name, NULL),  --Dean 05.09.2012
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL)     --Dean 05.09.2012
                       ORDER BY b.rowno) t1, 
                      (SELECT 1 subno
                         FROM DUAL
                       UNION
                       SELECT 2
                         FROM DUAL
                       UNION
                       SELECT 3
                         FROM DUAL
                       UNION
                       SELECT 4
                         FROM DUAL
                       UNION
                       SELECT 5
                         FROM DUAL
                       UNION
                       SELECT 6
                         FROM DUAL
                       UNION
                       SELECT 7
                         FROM DUAL
                       UNION
                       SELECT 8
                         FROM DUAL
                       UNION
                       SELECT 9
                         FROM DUAL
                       UNION
                       SELECT 10
                         FROM DUAL) t2
                WHERE t1.subno(+) = t2.subno
             GROUP BY t2.subno,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name)   --Dean 05.09.2012
         LOOP
            v_recap3.rowtitle := rec.rowtitle;
            v_recap3.subline_name := rec.subline_name;  --Dean 05.09.2012
            v_recap3.peril_name := rec.peril_name;      --Dean 05.09.2012
            v_recap3.direct_prem := rec.direct_prem;
            v_recap3.ceded_auth := rec.ceded_auth;
            v_recap3.ceded_asean := rec.ceded_asean;
            v_recap3.ceded_oth := rec.ceded_oth;
            v_recap3.direct_net := rec.direct_net;
            v_recap3.inw_auth := rec.inw_auth;
            v_recap3.inw_asean := rec.inw_asean;
            v_recap3.inw_oth := rec.inw_oth;
            v_recap3.ret_auth := rec.ret_auth;
            v_recap3.ret_asean := rec.ret_asean;
            v_recap3.ret_oth := rec.ret_oth;
            v_recap3.net_written := rec.net_written;
            PIPE ROW (v_recap3);
         END LOOP;
      ELSIF p_report_name = 'TSI'
      THEN
         FOR rec IN
            (SELECT   1 num, b.rowno rowno, b.rowtitle rowtitle,
                      DECODE (a.line_cd, 'MC', d.subline_name, NULL) subline_name, --Dean 05.09.2012 Added subline_name and decode for line MC
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name, --Dean 05.09.2012 Added peril_name and decode for line MC
                      SUM (NVL (a.direct_tsi, 0)) direct_prem,
                      SUM (NVL (a.ceded_tsi_auth, 0)) ceded_auth,
                      SUM (NVL (a.ceded_tsi_asean, 0)) ceded_asean,
                      SUM (NVL (a.ceded_tsi_oth, 0)) ceded_oth,
                      (  SUM (NVL (a.direct_tsi, 0))
                       - SUM (NVL (a.ceded_tsi_auth, 0))
                       - SUM (NVL (a.ceded_tsi_asean, 0))
                       - SUM (NVL (a.ceded_tsi_oth, 0))
                      ) direct_net,
                      SUM (NVL (a.inw_tsi_auth, 0)) inw_auth,
                      SUM (NVL (a.inw_tsi_asean, 0)) inw_asean,
                      SUM (NVL (a.inw_tsi_oth, 0)) inw_oth,
                      SUM (NVL (a.retceded_tsi_auth, 0)) ret_auth,
                      SUM (NVL (a.retceded_tsi_asean, 0)) ret_asean,
                      SUM (NVL (a.retceded_tsi_oth, 0)) ret_oth,
                      (  SUM (NVL (a.direct_tsi, 0))
                       - SUM (NVL (a.ceded_tsi_auth, 0))
                       - SUM (NVL (a.ceded_tsi_asean, 0))
                       - SUM (NVL (a.ceded_tsi_oth, 0))
                       + SUM (NVL (a.inw_tsi_auth, 0))
                       + SUM (NVL (a.inw_tsi_asean, 0))
                       + SUM (NVL (a.inw_tsi_oth, 0))
                       - SUM (NVL (a.retceded_tsi_auth, 0))
                       - SUM (NVL (a.retceded_tsi_asean, 0))
                       - SUM (NVL (a.retceded_tsi_oth, 0))
                      ) net_written
                 FROM giac_recap_summ_ext a,
                      giac_recap_summary_v b,
                      giis_peril c,  --Dean 05.09.2012
                      giis_subline d --Dean 05.09.2012
                WHERE 1 = 1
                  AND a.rowno(+) = b.rowno
                  AND a.rowtitle(+) = b.rowtitle
                  AND a.line_cd = c.line_cd    --Dean 05.09.2012
                  AND a.peril_cd = c.peril_cd  --Dean 05.09.2012
                  AND a.line_cd = d.line_cd    --Dean 05.09.2012
                  AND c.line_cd = d.line_cd    --Dean 05.09.2012
             GROUP BY b.rowno,
                      b.rowtitle,
                      DECODE (a.line_cd, 'MC', d.subline_name, NULL), --Dean 05.09.2012
                      DECODE (a.line_cd, 'MC', c.peril_name, NULL)    --Dean 05.09.2012
             UNION
             SELECT   2, t2.subno,
                      DECODE (t2.subno,
                              1, 'FI TARIFF SUBTOTAL',
                              2, 'FI SR SUBTOTAL',
                              3, 'SU SUBTOTAL',
                              4, 'MC SUBTOTAL',
                              5, 'CA SUBTOTAL',
                              6, 'MN AND MH SUBTOTAL',
                              7, 'EN SUBTOTAL',
                              8, 'PA AND AH SUBTOTAL',
                              9, 'AV SUBTOTAL',
                              'MISC SUBTOTAL'
                             ) subtitle,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name,   --Dean 05.09.2012
                      NVL (SUM (direct_prem), 0) direct_prem,
                      NVL (SUM (ceded_auth), 0) ceded_auth,
                      NVL (SUM (ceded_asean), 0) ceded_asean,
                      NVL (SUM (ceded_oth), 0) ceded_oth,
                      NVL (SUM (direct_net), 0) direct_net,
                      NVL (SUM (inw_auth), 0) inw_auth,
                      NVL (SUM (inw_asean), 0) inw_asean,
                      NVL (SUM (inw_oth), 0) inw_oth,
                      NVL (SUM (ret_auth), 0) ret_auth,
                      NVL (SUM (ret_asean), 0) ret_asean,
                      NVL (SUM (ret_oth), 0) ret_oth,
                      NVL (SUM (net_written), 0) net_written
                 FROM (SELECT   CASE
                                   WHEN b.rowno IN (1, 2, 3, 4)
                                      THEN 1
                                   WHEN b.rowno IN (5, 6, 7, 8)
                                      THEN 2
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_SU')
                                      THEN 3
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_MC')
                                      THEN 4
                                   WHEN a.line_cd =
                                               giisp.v ('LINE_CODE_CA')
                                      THEN 5
                                   WHEN a.line_cd IN
                                          (giisp.v ('LINE_CODE_MN'),
                                           giisp.v ('LINE_CODE_MH')
                                          )
                                      THEN 6
                                   WHEN a.line_cd IN
                                             (giisp.v ('LINE_CODE_EN'), 'E1')
                                      THEN 7
                                   WHEN a.line_cd IN
                                                   (giisp.v ('LINE_CODE_AC'))
                                      THEN 8
                                   WHEN a.line_cd = giisp.v ('LINE_CODE_AV')
                                      THEN 9
                                   ELSE 10
                                END subno,
                                a.line_cd, b.rowno rowno, b.rowtitle rowtitle,
                                DECODE (a.line_cd, 'MC', d.subline_name, NULL) subline_name, --Dean 05.09.2012 and decode for line MC
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL) peril_name,     --Dean 05.09.2012 and decode for line MC
                                SUM (NVL (a.direct_tsi, 0)) direct_prem,
                                SUM (NVL (a.ceded_tsi_auth, 0)) ceded_auth,
                                SUM (NVL (a.ceded_tsi_asean, 0)) ceded_asean,
                                SUM (NVL (a.ceded_tsi_oth, 0)) ceded_oth,
                                (  SUM (NVL (a.direct_tsi, 0))
                                 - SUM (NVL (a.ceded_tsi_auth, 0))
                                 - SUM (NVL (a.ceded_tsi_asean, 0))
                                 - SUM (NVL (a.ceded_tsi_oth, 0))
                                ) direct_net,
                                SUM (NVL (a.inw_tsi_auth, 0)) inw_auth,
                                SUM (NVL (a.inw_tsi_asean, 0)) inw_asean,
                                SUM (NVL (a.inw_tsi_oth, 0)) inw_oth,
                                SUM (NVL (a.retceded_tsi_auth, 0)) ret_auth,
                                SUM (NVL (a.retceded_tsi_asean, 0)) ret_asean,
                                SUM (NVL (a.retceded_tsi_oth, 0)) ret_oth,
                                (  SUM (NVL (a.direct_tsi, 0))
                                 - SUM (NVL (a.ceded_tsi_auth, 0))
                                 - SUM (NVL (a.ceded_tsi_asean, 0))
                                 - SUM (NVL (a.ceded_tsi_oth, 0))
                                 + SUM (NVL (a.inw_tsi_auth, 0))
                                 + SUM (NVL (a.inw_tsi_asean, 0))
                                 + SUM (NVL (a.inw_tsi_oth, 0))
                                 - SUM (NVL (a.retceded_tsi_auth, 0))
                                 - SUM (NVL (a.retceded_tsi_asean, 0))
                                 - SUM (NVL (a.retceded_tsi_oth, 0))
                                ) net_written
                           FROM giac_recap_summ_ext a,
                                giac_recap_summary_v b,
                                giis_peril c,   --Dean 05.09.2012
                                giis_subline d  --Dean 05.09.2012
                          WHERE 1 = 1
                            AND a.rowno(+) = b.rowno
                            AND a.rowtitle(+) = b.rowtitle
                            AND a.line_cd = c.line_cd    --Dean 05.09.2012
                            AND a.peril_cd = c.peril_cd  --Dean 05.09.2012
                            AND a.line_cd = d.line_cd    --Dean 05.09.2012
                            AND c.line_cd = d.line_cd    --Dean 05.09.2012    
                       GROUP BY a.line_cd,
                                b.rowno,
                                b.rowtitle,
                                DECODE (a.line_cd, 'MC', d.subline_name, NULL),
                                DECODE (a.line_cd, 'MC', c.peril_name, NULL)
                       ORDER BY b.rowno) t1,
                      (SELECT 1 subno
                         FROM DUAL
                       UNION
                       SELECT 2
                         FROM DUAL
                       UNION
                       SELECT 3
                         FROM DUAL
                       UNION
                       SELECT 4
                         FROM DUAL
                       UNION
                       SELECT 5
                         FROM DUAL
                       UNION
                       SELECT 6
                         FROM DUAL
                       UNION
                       SELECT 7
                         FROM DUAL
                       UNION
                       SELECT 8
                         FROM DUAL
                       UNION
                       SELECT 9
                         FROM DUAL
                       UNION
                       SELECT 10
                         FROM DUAL) t2
                WHERE t1.subno(+) = t2.subno
             GROUP BY t2.subno,
                      t1.subline_name, --Dean 05.09.2012
                      t1.peril_name)   --Dean 05.09.2012
         LOOP
            v_recap3.rowtitle := rec.rowtitle;
            v_recap3.subline_name := rec.subline_name;   --Dean 05.09.2012
            v_recap3.peril_name := rec.peril_name;       --Dean 05.09.2012
            v_recap3.direct_prem := rec.direct_prem;
            v_recap3.ceded_auth := rec.ceded_auth;
            v_recap3.ceded_asean := rec.ceded_asean;
            v_recap3.ceded_oth := rec.ceded_oth;
            v_recap3.direct_net := rec.direct_net;
            v_recap3.inw_auth := rec.inw_auth;
            v_recap3.inw_asean := rec.inw_asean;
            v_recap3.inw_oth := rec.inw_oth;
            v_recap3.ret_auth := rec.ret_auth;
            v_recap3.ret_asean := rec.ret_asean;
            v_recap3.ret_oth := rec.ret_oth;
            v_recap3.net_written := rec.net_written;
            PIPE ROW (v_recap3);
         END LOOP;
      END IF;

      RETURN;
   END csv_recap3;

   --## END FUNCTION CSV_RECAP3 ##--
   FUNCTION csv_recap_dtl (p_report_name VARCHAR2, p_rowtitle VARCHAR2)
      RETURN recap_dtl_type PIPELINED
   IS
      v_recap_dtl   recap_dtl_rec_type;
   BEGIN
      IF p_report_name = 'PREMIUM'
      THEN                                                        --RECAP I--
         FOR rec IN (SELECT   get_policy_no (a.policy_id) policy_no,
                              SUM (NVL (a.direct_prem, 0)) direct_prem,
                              SUM (NVL (a.ceded_prem_auth, 0)) ceded_auth,
                              SUM (NVL (a.ceded_prem_asean, 0)) ceded_asean,
                              SUM (NVL (a.ceded_prem_oth, 0)) ceded_oth,
                              (  SUM (NVL (a.direct_prem, 0))
                               - SUM (NVL (a.ceded_prem_auth, 0))
                               - SUM (NVL (a.ceded_prem_asean, 0))
                               - SUM (NVL (a.ceded_prem_oth, 0))
                              ) direct_net,
                              SUM (NVL (a.inw_prem_auth, 0)) inw_auth,
                              SUM (NVL (a.inw_prem_asean, 0)) inw_asean,
                              SUM (NVL (a.inw_prem_oth, 0)) inw_oth,
                              SUM (NVL (a.retceded_prem_auth, 0)) ret_auth,
                              SUM (NVL (a.retceded_prem_asean, 0)) ret_asean,
                              SUM (NVL (a.retceded_prem_oth, 0)) ret_oth,
                              (  SUM (NVL (a.direct_prem, 0))
                               - SUM (NVL (a.ceded_prem_auth, 0))
                               - SUM (NVL (a.ceded_prem_asean, 0))
                               - SUM (NVL (a.ceded_prem_oth, 0))
                               + SUM (NVL (a.inw_prem_auth, 0))
                               + SUM (NVL (a.inw_prem_asean, 0))
                               + SUM (NVL (a.inw_prem_oth, 0))
                               - SUM (NVL (a.retceded_prem_auth, 0))
                               - SUM (NVL (a.retceded_prem_asean, 0))
                               - SUM (NVL (a.retceded_prem_oth, 0))
                              ) net_written
                         FROM giac_recap_summ_ext a
                        WHERE 1 = 1 AND a.rowtitle = p_rowtitle
                     GROUP BY a.policy_id
                     ORDER BY a.policy_id)
         LOOP
            v_recap_dtl.polclm_no := rec.policy_no;
            v_recap_dtl.direct_prem := rec.direct_prem;
            v_recap_dtl.ceded_auth := rec.ceded_auth;
            v_recap_dtl.ceded_asean := rec.ceded_asean;
            v_recap_dtl.ceded_oth := rec.ceded_oth;
            v_recap_dtl.direct_net := rec.direct_net;
            v_recap_dtl.inw_auth := rec.inw_auth;
            v_recap_dtl.inw_asean := rec.inw_asean;
            v_recap_dtl.inw_oth := rec.inw_oth;
            v_recap_dtl.ret_auth := rec.ret_auth;
            v_recap_dtl.ret_asean := rec.ret_asean;
            v_recap_dtl.ret_oth := rec.ret_oth;
            v_recap_dtl.net_written := rec.net_written;
            PIPE ROW (v_recap_dtl);
         END LOOP;
      ELSIF p_report_name = 'LOSSPD'
      THEN                                                        --RECAP II--
         FOR rec IN (SELECT   get_recap_claim_no (a.claim_id) claim_no,
                              SUM (NVL (a.gross_loss + a.gross_exp, 0)
                                  ) direct_prem,
                              SUM (NVL (a.loss_auth + a.exp_auth, 0)
                                  ) ceded_auth,
                              SUM (NVL (a.loss_asean + a.exp_asean, 0)
                                  ) ceded_asean,
                              SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                                                   ceded_oth,
                                SUM (NVL (a.gross_loss + a.gross_exp, 0)
                                    )
                              - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                              - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                              - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                                                  direct_net,
                              SUM (NVL (  a.inw_grs_loss_auth
                                        + a.inw_grs_exp_auth,
                                        0
                                       )
                                  ) inw_auth,
                              SUM (NVL (  a.inw_grs_loss_asean
                                        + a.inw_grs_exp_asean,
                                        0
                                       )
                                  ) inw_asean,
                              SUM (NVL (a.inw_grs_loss_oth + a.inw_grs_exp_oth,
                                        0
                                       )
                                  ) inw_oth,
                              SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0)
                                  ) ret_auth,
                              SUM (NVL (a.ret_loss_asean + a.ret_exp_asean, 0)
                                  ) ret_asean,
                              SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0)
                                  ) ret_oth,
                              (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                               - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                               - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                               - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                               + SUM (NVL (  a.inw_grs_loss_auth
                                           + a.inw_grs_exp_auth,
                                           0
                                          )
                                     )
                               + SUM (NVL (  a.inw_grs_loss_asean
                                           + a.inw_grs_exp_asean,
                                           0
                                          )
                                     )
                               + SUM (NVL (  a.inw_grs_loss_oth
                                           + a.inw_grs_exp_oth,
                                           0
                                          )
                                     )
                               - SUM (NVL (a.ret_loss_auth + a.ret_exp_auth,
                                           0)
                                     )
                               - SUM (NVL (a.ret_loss_asean + a.ret_exp_asean,
                                           0
                                          )
                                     )
                               - SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0))
                              ) net_written
                         FROM giac_recap_losspd_summ_ext a
                        WHERE 1 = 1 AND a.rowtitle = p_rowtitle
                     GROUP BY a.claim_id
                     ORDER BY a.claim_id)
         LOOP
            v_recap_dtl.polclm_no := rec.claim_no;
            v_recap_dtl.direct_prem := rec.direct_prem;
            v_recap_dtl.ceded_auth := rec.ceded_auth;
            v_recap_dtl.ceded_asean := rec.ceded_asean;
            v_recap_dtl.ceded_oth := rec.ceded_oth;
            v_recap_dtl.direct_net := rec.direct_net;
            v_recap_dtl.inw_auth := rec.inw_auth;
            v_recap_dtl.inw_asean := rec.inw_asean;
            v_recap_dtl.inw_oth := rec.inw_oth;
            v_recap_dtl.ret_auth := rec.ret_auth;
            v_recap_dtl.ret_asean := rec.ret_asean;
            v_recap_dtl.ret_oth := rec.ret_oth;
            v_recap_dtl.net_written := rec.net_written;
            PIPE ROW (v_recap_dtl);
         END LOOP;
      ELSIF p_report_name = 'COMM'
      THEN                                                       --RECAP III--
         FOR rec IN (SELECT   get_policy_no (a.policy_id) policy_no,
                              SUM (NVL (a.direct_comm, 0)) direct_prem,
                              SUM (NVL (a.ceded_comm_auth, 0)) ceded_auth,
                              SUM (NVL (a.ceded_comm_asean, 0)) ceded_asean,
                              SUM (NVL (a.ceded_comm_oth, 0)) ceded_oth,
                              (  SUM (NVL (a.direct_comm, 0))
                               - SUM (NVL (a.ceded_comm_auth, 0))
                               - SUM (NVL (a.ceded_comm_asean, 0))
                               - SUM (NVL (a.ceded_comm_oth, 0))
                              ) direct_net,
                              SUM (NVL (a.inw_comm_auth, 0)) inw_auth,
                              SUM (NVL (a.inw_comm_asean, 0)) inw_asean,
                              SUM (NVL (a.inw_comm_oth, 0)) inw_oth,
                              SUM (NVL (a.retceded_comm_auth, 0)) ret_auth,
                              SUM (NVL (a.retceded_comm_asean, 0)) ret_asean,
                              SUM (NVL (a.retceded_comm_oth, 0)) ret_oth,
                              (  SUM (NVL (a.direct_comm, 0))
                               - SUM (NVL (a.ceded_comm_auth, 0))
                               - SUM (NVL (a.ceded_comm_asean, 0))
                               - SUM (NVL (a.ceded_comm_oth, 0))
                               + SUM (NVL (a.inw_comm_auth, 0))
                               + SUM (NVL (a.inw_comm_asean, 0))
                               + SUM (NVL (a.inw_comm_oth, 0))
                               - SUM (NVL (a.retceded_comm_auth, 0))
                               - SUM (NVL (a.retceded_comm_asean, 0))
                               - SUM (NVL (a.retceded_comm_oth, 0))
                              ) net_written
                         FROM giac_recap_summ_ext a
                        WHERE 1 = 1 AND a.rowtitle = p_rowtitle
                     GROUP BY a.policy_id
                     ORDER BY a.policy_id)
         LOOP
            v_recap_dtl.polclm_no := rec.policy_no;
            v_recap_dtl.direct_prem := rec.direct_prem;
            v_recap_dtl.ceded_auth := rec.ceded_auth;
            v_recap_dtl.ceded_asean := rec.ceded_asean;
            v_recap_dtl.ceded_oth := rec.ceded_oth;
            v_recap_dtl.direct_net := rec.direct_net;
            v_recap_dtl.inw_auth := rec.inw_auth;
            v_recap_dtl.inw_asean := rec.inw_asean;
            v_recap_dtl.inw_oth := rec.inw_oth;
            v_recap_dtl.ret_auth := rec.ret_auth;
            v_recap_dtl.ret_asean := rec.ret_asean;
            v_recap_dtl.ret_oth := rec.ret_oth;
            v_recap_dtl.net_written := rec.net_written;
            PIPE ROW (v_recap_dtl);
         END LOOP;
      ELSIF p_report_name = 'TSI'
      THEN                                                        --RECAP IV--
         FOR rec IN (SELECT   get_policy_no (a.policy_id) policy_no,
                              SUM (NVL (a.direct_tsi, 0)) direct_prem,
                              SUM (NVL (a.ceded_tsi_auth, 0)) ceded_auth,
                              SUM (NVL (a.ceded_tsi_asean, 0)) ceded_asean,
                              SUM (NVL (a.ceded_tsi_oth, 0)) ceded_oth,
                              (  SUM (NVL (a.direct_tsi, 0))
                               - SUM (NVL (a.ceded_tsi_auth, 0))
                               - SUM (NVL (a.ceded_tsi_asean, 0))
                               - SUM (NVL (a.ceded_tsi_oth, 0))
                              ) direct_net,
                              SUM (NVL (a.inw_tsi_auth, 0)) inw_auth,
                              SUM (NVL (a.inw_tsi_asean, 0)) inw_asean,
                              SUM (NVL (a.inw_tsi_oth, 0)) inw_oth,
                              SUM (NVL (a.retceded_tsi_auth, 0)) ret_auth,
                              SUM (NVL (a.retceded_tsi_asean, 0)) ret_asean,
                              SUM (NVL (a.retceded_tsi_oth, 0)) ret_oth,
                              (  SUM (NVL (a.direct_tsi, 0))
                               - SUM (NVL (a.ceded_tsi_auth, 0))
                               - SUM (NVL (a.ceded_tsi_asean, 0))
                               - SUM (NVL (a.ceded_tsi_oth, 0))
                               + SUM (NVL (a.inw_tsi_auth, 0))
                               + SUM (NVL (a.inw_tsi_asean, 0))
                               + SUM (NVL (a.inw_tsi_oth, 0))
                               - SUM (NVL (a.retceded_tsi_auth, 0))
                               - SUM (NVL (a.retceded_tsi_asean, 0))
                               - SUM (NVL (a.retceded_tsi_oth, 0))
                              ) net_written
                         FROM giac_recap_summ_ext a
                        WHERE 1 = 1 AND a.rowtitle = p_rowtitle
                     GROUP BY a.policy_id
                     ORDER BY a.policy_id)
         LOOP
            v_recap_dtl.polclm_no := rec.policy_no;
            v_recap_dtl.direct_prem := rec.direct_prem;
            v_recap_dtl.ceded_auth := rec.ceded_auth;
            v_recap_dtl.ceded_asean := rec.ceded_asean;
            v_recap_dtl.ceded_oth := rec.ceded_oth;
            v_recap_dtl.direct_net := rec.direct_net;
            v_recap_dtl.inw_auth := rec.inw_auth;
            v_recap_dtl.inw_asean := rec.inw_asean;
            v_recap_dtl.inw_oth := rec.inw_oth;
            v_recap_dtl.ret_auth := rec.ret_auth;
            v_recap_dtl.ret_asean := rec.ret_asean;
            v_recap_dtl.ret_oth := rec.ret_oth;
            v_recap_dtl.net_written := rec.net_written;
            PIPE ROW (v_recap_dtl);
         END LOOP;
      ELSIF p_report_name = 'OSLOSS'
      THEN                                                         --RECAP V--
         FOR rec IN (SELECT   get_recap_claim_no (a.claim_id) claim_no,
                              SUM (NVL (a.gross_loss + a.gross_exp, 0)
                                  ) direct_prem,
                              SUM (NVL (a.loss_auth + a.exp_auth, 0)
                                  ) ceded_auth,
                              SUM (NVL (a.loss_asean + a.exp_asean, 0)
                                  ) ceded_asean,
                              SUM (NVL (a.loss_oth + a.exp_oth, 0))
                                                                   ceded_oth,
                              (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                               - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                               - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                               - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                              ) direct_net,
                              SUM (NVL (  a.inw_grs_loss_auth
                                        + a.inw_grs_exp_auth,
                                        0
                                       )
                                  ) inw_auth,
                              SUM (NVL (  a.inw_grs_loss_asean
                                        + a.inw_grs_exp_asean,
                                        0
                                       )
                                  ) inw_asean,
                              SUM (NVL (a.inw_grs_loss_oth + a.inw_grs_exp_oth,
                                        0
                                       )
                                  ) inw_oth,
                              SUM (NVL (a.ret_loss_auth + a.ret_exp_auth, 0)
                                  ) ret_auth,
                              SUM (NVL (a.ret_loss_asean + a.ret_exp_asean, 0)
                                  ) ret_asean,
                              SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0)
                                  ) ret_oth,
                              (  SUM (NVL (a.gross_loss + a.gross_exp, 0))
                               - SUM (NVL (a.loss_auth + a.exp_auth, 0))
                               - SUM (NVL (a.loss_asean + a.exp_asean, 0))
                               - SUM (NVL (a.loss_oth + a.exp_oth, 0))
                               + SUM (NVL (  a.inw_grs_loss_auth
                                           + a.inw_grs_exp_auth,
                                           0
                                          )
                                     )
                               + SUM (NVL (  a.inw_grs_loss_asean
                                           + a.inw_grs_exp_asean,
                                           0
                                          )
                                     )
                               + SUM (NVL (  a.inw_grs_loss_oth
                                           + a.inw_grs_exp_oth,
                                           0
                                          )
                                     )
                               - SUM (NVL (a.ret_loss_auth + a.ret_exp_auth,
                                           0)
                                     )
                               - SUM (NVL (a.ret_loss_asean + a.ret_exp_asean,
                                           0
                                          )
                                     )
                               - SUM (NVL (a.ret_loss_oth + a.ret_exp_oth, 0))
                              ) net_written
                         FROM giac_recap_osloss_summ_ext a
                        WHERE 1 = 1 AND a.rowtitle = p_rowtitle
                     GROUP BY a.claim_id
                     ORDER BY a.claim_id)
         LOOP
            v_recap_dtl.polclm_no := rec.claim_no;
            v_recap_dtl.direct_prem := rec.direct_prem;
            v_recap_dtl.ceded_auth := rec.ceded_auth;
            v_recap_dtl.ceded_asean := rec.ceded_asean;
            v_recap_dtl.ceded_oth := rec.ceded_oth;
            v_recap_dtl.direct_net := rec.direct_net;
            v_recap_dtl.inw_auth := rec.inw_auth;
            v_recap_dtl.inw_asean := rec.inw_asean;
            v_recap_dtl.inw_oth := rec.inw_oth;
            v_recap_dtl.ret_auth := rec.ret_auth;
            v_recap_dtl.ret_asean := rec.ret_asean;
            v_recap_dtl.ret_oth := rec.ret_oth;
            v_recap_dtl.net_written := rec.net_written;
            PIPE ROW (v_recap_dtl);
         END LOOP;
      END IF;

      RETURN;
   END csv_recap_dtl;
--## END FUNCTION CSV_RECAP_DTL ##--
    --printGIPIR203CSV added by carlo de guzman 3.14.2016--
    FUNCTION csv_gipir203
        RETURN recap4_dtl_tab PIPELINED
    IS
        v_detail    recap4_dtl_type;
        v_count     NUMBER := 0;
    BEGIN
        
        FOR rec IN (SELECT region_cd, ind_grp_cd, no_of_policy,
                           gross_prem, gross_losses, social_gross_prem
                      FROM gixx_recapitulation 
                     ORDER BY region_cd, ind_grp_cd)
        LOOP
            v_count := 1;
            v_detail.policy_holders          := rec.no_of_policy;
            v_detail.premiums_earned         := rec.gross_prem;
            v_detail.losses_incured          := rec.gross_losses;
            v_detail.social_premiums_earned  := rec.social_gross_prem;
            
            FOR i IN (SELECT region_cd, region_desc
                        FROM giis_region
                       WHERE region_cd = rec.region_cd)
            LOOP
                v_detail.regions := i.region_cd || ' - ' || i.region_desc;
            END LOOP;
            
            BEGIN
            
                SELECT INITCAP(IND_GRP_NM)
                  INTO v_detail.industry_group
                  FROM giis_industry_group
                 WHERE ind_grp_cd = rec.ind_grp_cd;
                 
            EXCEPTION
                WHEN no_data_found THEN
                  v_detail.industry_group := 'Micro Insurance';
            END;            
            
            PIPE ROW(v_detail);
        END LOOP;
        
        IF v_count = 0 THEN
             
            PIPE ROW(v_detail);
        END IF;    
    END csv_gipir203;
    --printGIPIR203CSV  END--      
    
    --printGIPIR203BCSV added by carlo de guzman 3.14.2016--
    FUNCTION csv_gipir203B
        RETURN gipir203b_tab PIPELINED
    IS
        v_detail        gipir203b_type;
        v_count         NUMBER := 0;
    BEGIN
    
        FOR rec IN (SELECT assd_no, policy_id, claim_id, region_cd, ind_grp_cd, loss_amt
                      FROM GIXX_RECAPITULATION_LOSSES_DTL
                     )
        LOOP
            v_count := 1;
            v_detail.region_cd      := rec.region_cd;
            v_detail.industry_cd    := rec.ind_grp_cd;
            v_detail.loss_amount    := rec.loss_amt;
            
            FOR a IN (SELECT DISTINCT a.line_cd||' - '||b.line_name line_name
                        FROM gipi_polbasic a,giis_line b
                       WHERE 1 = 1
                         AND a.line_cd = b.line_cd
                         AND a.policy_id = rec.policy_id)
            LOOP
                v_detail.line := LTRIM(a.line_name);
                EXIT;
            END LOOP;
            
            FOR a IN (SELECT region_desc
                        FROM giis_region
                       WHERE region_cd = rec.region_cd)
            LOOP
                v_detail.region_desc := a.region_desc;
                EXIT;
            END LOOP;
            
            FOR c1 IN (SELECT INITCAP(ind_grp_nm) ind_grp_nm
                         FROM giis_industry_group
                        WHERE ind_grp_cd = rec.ind_grp_cd)
            LOOP
                v_detail.industry_name := c1.ind_grp_nm;
            END LOOP;
            
            FOR C1 IN (SELECT x.assd_name
                           FROM giis_assured x
                          WHERE x.assd_no = rec.assd_no)
            LOOP
                v_detail.assured_name := C1.assd_name;
            END LOOP;
            
            FOR c1 IN (SELECT x.line_cd||'-'||x.subline_cd||'-'||x.iss_cd||'-'||LTRIM(TO_CHAR(x.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(x.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(x.renew_no,'09')) policy_no
                         FROM GIPI_POLBASIC x
                        WHERE x.policy_id = rec.policy_id)
            LOOP
                v_detail.policy_number := c1.policy_no;
            END LOOP;
            
            FOR c1 IN (SELECT x.line_cd||'-'||x.subline_cd||'-'||x.iss_cd||'-'||LTRIM(TO_CHAR(x.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(x.clm_seq_no,'0000009')) claim_no
	                     FROM GICL_CLAIMS x
				        WHERE x.claim_id = rec.claim_id)
            LOOP
                v_detail.claim_number := c1.claim_no;
            END LOOP;
            
            PIPE ROW(v_detail);
        END LOOP;
        
        IF v_count = 0 THEN
        
            PIPE ROW(v_detail);
        END IF;
    
    END csv_gipir203B;
    --printGIPIR203BCSV END--    
END;
/