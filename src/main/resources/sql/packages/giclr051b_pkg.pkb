CREATE OR REPLACE PACKAGE BODY CPI.giclr051b_pkg
AS
   FUNCTION get_giclr051b_status (p_clm_stat_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      --v_desc   varchar2(50);
      v_desc   giis_clm_stat.clm_stat_desc%TYPE;
   BEGIN
      BEGIN
         SELECT clm_stat_desc
           INTO v_desc
           FROM giis_clm_stat
          WHERE clm_stat_cd = p_clm_stat_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN v_desc;
   END get_giclr051b_status;

   FUNCTION get_giclr051b_paid_shr_amt (
      p_claim_id     NUMBER,
      p_advice_id    NUMBER,
      p_share_type   VARCHAR2,
      p_share_cd     NUMBER
   )
      RETURN NUMBER
   IS
      v_paid_shr_amt   gicl_advice.paid_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT   NVL (SUM (b.shr_le_pd_amt * NVL (c.convert_rate, 1)),
                              0
                             ) paid_amt
                    FROM gicl_clm_loss_exp a,
                         gicl_loss_exp_ds b,
                         gicl_advice c
                   WHERE a.claim_id = b.claim_id
                     AND a.clm_loss_id = b.clm_loss_id
                     AND a.claim_id = c.claim_id
                     AND a.advice_id = c.advice_id
                     AND a.claim_id = p_claim_id
                     AND a.advice_id = p_advice_id
                     AND b.share_type = p_share_type
                     AND b.grp_seq_no = p_share_cd
                GROUP BY b.grp_seq_no)
      LOOP
         v_paid_shr_amt := v_paid_shr_amt + i.paid_amt;
      END LOOP;

      RETURN (v_paid_shr_amt);
   END get_giclr051b_paid_shr_amt;

   FUNCTION get_giclr051b_net_shr_amt (
      p_claim_id     NUMBER,
      p_advice_id    NUMBER,
      p_share_type   VARCHAR2,
      p_share_cd     NUMBER
   )
      RETURN NUMBER
   IS
      v_net_shr_amt   gicl_advice.net_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT   NVL (SUM (b.shr_le_net_amt * NVL (c.convert_rate, 1)),
                              0
                             ) net_amt
                    FROM gicl_clm_loss_exp a,
                         gicl_loss_exp_ds b,
                         gicl_advice c
                   WHERE a.claim_id = b.claim_id
                     AND a.clm_loss_id = b.clm_loss_id
                     AND a.claim_id = c.claim_id
                     AND a.advice_id = c.advice_id
                     AND a.claim_id = p_claim_id
                     AND a.advice_id = p_advice_id
                     AND b.share_type = p_share_type
                     AND b.grp_seq_no = p_share_cd
                GROUP BY b.grp_seq_no)
      LOOP
         v_net_shr_amt := v_net_shr_amt + i.net_amt;
      END LOOP;

      RETURN (v_net_shr_amt);
   END get_giclr051b_net_shr_amt;

   FUNCTION get_giclr051b_adv_shr_amt (
      p_claim_id     NUMBER,
      p_advice_id    NUMBER,
      p_share_type   VARCHAR2,
      p_share_cd     NUMBER
   )
      RETURN NUMBER
   IS
      v_adv_shr_amt   gicl_advice.advise_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT   NVL (SUM (b.shr_le_adv_amt * NVL (c.convert_rate, 1)),
                              0
                             ) advise_amt
                    FROM gicl_clm_loss_exp a,
                         gicl_loss_exp_ds b,
                         gicl_advice c
                   WHERE a.claim_id = b.claim_id
                     AND a.clm_loss_id = b.clm_loss_id
                     AND a.claim_id = c.claim_id
                     AND a.advice_id = c.advice_id
                     AND a.claim_id = p_claim_id
                     AND a.advice_id = p_advice_id
                     AND b.share_type = p_share_type
                     AND b.grp_seq_no = p_share_cd
                GROUP BY b.grp_seq_no)
      LOOP
         v_adv_shr_amt := v_adv_shr_amt + i.advise_amt;
      END LOOP;

      RETURN (v_adv_shr_amt);
   END get_giclr051b_adv_shr_amt;

   FUNCTION get_giclr051b_records (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giclr051b_record_tab PIPELINED
   IS
      v_list        giclr051b_record_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_add := giisp.v ('COMPANY_ADDRESS');

      FOR i IN
         (SELECT DISTINCT                                      --b.advice_id,
                          line_name, a.line_cd || ' - ' || x.line_name line,
                          a.claim_id,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                claim_number,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.pol_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                               policy_number,
                          a.assured_name, a.in_hou_adj, a.clm_stat_cd
                     FROM gicl_claims a,
                          gicl_advice b,
                          giis_dist_share f,
                          giis_line x,
                          gicl_clm_loss_exp g,
                          gicl_loss_exp_ds h
                    WHERE a.claim_id = b.claim_id
                      AND b.claim_id = g.claim_id
                      AND b.advice_id = g.advice_id
                      AND g.claim_id = h.claim_id
                      AND g.clm_loss_id = h.clm_loss_id
                      AND h.share_type IN ('2', '3')
                      AND a.line_cd = f.line_cd
                      AND h.share_type = f.share_type
                      AND h.grp_seq_no = f.share_cd
                      AND a.line_cd = x.line_cd
                      AND b.advice_flag = 'Y'
                      AND a.clm_stat_cd NOT IN ('CC', 'DN', 'WD')
                      AND NOT EXISTS (
                             SELECT '1'
                               FROM gicl_advs_fla c
                              WHERE c.claim_id = b.claim_id
                                AND c.adv_fla_id = b.adv_fla_id
                                AND NVL (c.cancel_tag, 'N') = 'N')
                      AND a.in_hou_adj = NVL (p_user_id, a.in_hou_adj)
                      AND a.line_cd = p_line_cd
                      AND check_user_per_iss_cd2 (a.line_cd,
                                                  a.iss_cd,
                                                  'GICLS051',
                                                  NVL (p_user_id,
                                                       USER)
                                                 ) = 1)
      LOOP
         v_not_exist := FALSE;
         v_list.line := i.line;
         v_list.claim_id := i.claim_id;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.line_name := i.line_name;
         v_list.status := get_giclr051b_status (i.clm_stat_cd);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr051b_records;

   FUNCTION get_giclr051b_subreport (
      p_line_cd         VARCHAR2,
      p_user_id         VARCHAR2,
      p_claim_id        NUMBER,
      p_policy_number   VARCHAR2
   )
      RETURN giclr051b_subreport_tab PIPELINED
   IS
      v_list   giclr051b_subreport_type;
   BEGIN
      FOR i IN (SELECT b.advice_id, line_name,
                       a.line_cd || ' - ' || x.line_name line, a.claim_id,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.clm_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                claim_number,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.pol_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number,
                       a.assured_name,
                          b.line_cd
                       || '-'
                       || b.iss_cd
                       || '-'
                       || b.advice_year
                       || '-'
                       || LTRIM (TO_CHAR (b.advice_seq_no, '0000009'))
                                                                   advice_no,
                       f.trty_name, f.share_type, f.share_cd, a.in_hou_adj,
                       a.clm_stat_cd
                  FROM gicl_claims a,
                       gicl_advice b,
                       giis_dist_share f,
                       giis_line x,
                       gicl_clm_loss_exp g,
                       gicl_loss_exp_ds h
                 WHERE a.claim_id = b.claim_id
                   AND b.claim_id = g.claim_id
                   AND b.advice_id = g.advice_id
                   AND g.claim_id = h.claim_id
                   AND g.clm_loss_id = h.clm_loss_id
                   AND h.share_type IN ('2', '3')
                   AND a.line_cd = f.line_cd
                   AND h.share_type = f.share_type
                   AND h.grp_seq_no = f.share_cd
                   AND a.line_cd = x.line_cd
                   AND b.advice_flag = 'Y'
                   AND a.clm_stat_cd NOT IN ('CC', 'DN', 'WD')
                   AND a.claim_id = p_claim_id
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM gicl_advs_fla c
                           WHERE c.claim_id = b.claim_id
                             AND c.adv_fla_id = b.adv_fla_id
                             AND NVL (c.cancel_tag, 'N') = 'N')
                   AND a.in_hou_adj = NVL (p_user_id, a.in_hou_adj)
                   AND a.line_cd = p_line_cd
                   AND check_user_per_iss_cd2 (a.line_cd,
                                               a.iss_cd,
                                               'GICLS051',
                                               NVL (p_user_id, USER)
                                              ) = 1)
      LOOP
         v_list.advice_id := i.advice_id;
         v_list.line := i.line;
         v_list.claim_id := i.claim_id;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.advice_no := i.advice_no;
         v_list.trty_name := i.trty_name;
         v_list.share_type := i.share_type;
         v_list.share_cd := i.share_cd;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.line_name := i.line_name;
         v_list.status := get_giclr051b_status (i.clm_stat_cd);
         v_list.paid_shr_amt :=
            get_giclr051b_paid_shr_amt (i.claim_id,
                                        i.advice_id,
                                        i.share_type,
                                        i.share_cd
                                       );
         v_list.net_shr_amt :=
            get_giclr051b_net_shr_amt (i.claim_id,
                                       i.advice_id,
                                       i.share_type,
                                       i.share_cd
                                      );
         v_list.adv_shr_amt :=
            get_giclr051b_adv_shr_amt (i.claim_id,
                                       i.advice_id,
                                       i.share_type,
                                       i.share_cd
                                      );
         PIPE ROW (v_list);
      END LOOP;
   END get_giclr051b_subreport;
END;
/


