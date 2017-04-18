CREATE OR REPLACE PACKAGE BODY CPI.gicls274_pkg
AS
   /**
    **  Created by      : Koks
    **  Date Created    : 01.30.2013
    **  Reference By    : (GICLS274 - Claims Listing Per Package Policy)
    **  Description     : Claims Listing Per Package Policy TableGrid
    **/
   FUNCTION get_clm_list_per_pack_policy (
      p_pack_policy_id   gicl_claims.pack_policy_id%TYPE,
      p_line_cd          giis_line.line_cd%TYPE,
      p_iss_cd           giis_issource.iss_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by_opt    VARCHAR2,
      p_date_as_of       VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_claim_no         VARCHAR2,
      p_loss_res_amt     NUMBER,
      p_exp_res_amt      NUMBER,
      p_loss_pd_amt      NUMBER,
      p_exp_pd_amt       NUMBER,
      p_recovery_sw      VARCHAR2
   )
      RETURN clm_list_per_pack_policy_tab PIPELINED
   IS
      v_list   clm_list_per_pack_policy_type;
   BEGIN
      FOR i IN
         (SELECT   a.claim_id, get_clm_no (a.claim_id) claim_no,
                   (   a.line_cd
                    || '-'
                    || a.subline_cd
                    || '-'
                    || a.pol_iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (a.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a.renew_no, '09'))
                   ) pol_no,
                   b.clm_stat_desc, a.recovery_sw,
                   TO_DATE (TO_CHAR (a.clm_file_date, 'MM-DD-YYYY'),
                            'MM-DD-YYYY'
                           ) clm_file_date,
                   TO_DATE (TO_CHAR (a.dsp_loss_date, 'MM-DD-YYYY'),
                            'MM-DD-YYYY'
                           ) dsp_loss_date,
                   TO_CHAR (SUM (NVL (a.exp_res_amt, 0)),
                            '999,999,990.99'
                           ) exp_res_amt,
                   TO_CHAR (SUM (NVL (a.loss_pd_amt, 0)),
                            '999,999,990.99'
                           ) loss_pd_amt,
                   TO_CHAR (SUM (NVL (a.exp_pd_amt, 0)),
                            '999,999,990.99'
                           ) exp_pd_amt,
                   TO_CHAR (SUM (NVL (a.loss_res_amt, 0)),
                            '999,999,990.99'
                           ) loss_res_amt
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.pack_policy_id = p_pack_policy_id
               AND a.clm_stat_cd = b.clm_stat_cd
               AND a.claim_id IN (
                      SELECT claim_id
                        FROM gicl_claims
                       WHERE check_user_per_iss_cd2 (a.line_cd,
                                                     a.iss_cd,
                                                     'GICLS274',
                                                     p_user_id
                                                    ) = 1)
               AND a.recovery_sw = UPPER (NVL (p_recovery_sw, a.recovery_sw))
               AND UPPER (get_clm_no (a.claim_id)) LIKE
                             UPPER (NVL (p_claim_no, get_clm_no (a.claim_id)))
               AND NVL (a.loss_res_amt, 0) =
                                 NVL (p_loss_res_amt, NVL (a.loss_res_amt, 0))
               AND NVL (a.exp_res_amt, 0) =
                                   NVL (p_exp_res_amt, NVL (a.exp_res_amt, 0))
               AND NVL (loss_pd_amt, 0) =
                                   NVL (p_loss_pd_amt, NVL (a.loss_pd_amt, 0))
               AND NVL (a.exp_pd_amt, 0) =
                                     NVL (p_exp_pd_amt, NVL (a.exp_pd_amt, 0))
               AND (   (    (DECODE (p_search_by_opt,
                                     'lossDate', TRUNC (a.loss_date),
                                     'fileDate', TRUNC (a.clm_file_date)
                                    ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                            )
                        AND (DECODE (p_search_by_opt,
                                     'lossDate', TRUNC (a.loss_date),
                                     'fileDate', TRUNC (a.clm_file_date)
                                    ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                            )
                       )
                    OR (DECODE (p_search_by_opt,
                                'lossDate', TRUNC (a.loss_date),
                                'fileDate', TRUNC (a.clm_file_date)
                               ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                       )
                   )
          GROUP BY get_clm_no (a.claim_id),
                   (   a.line_cd
                    || '-'
                    || a.subline_cd
                    || '-'
                    || a.pol_iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (a.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a.renew_no, '09'))
                   ),
                   loss_res_amt,
                   exp_res_amt,
                   loss_pd_amt,
                   exp_pd_amt,
                   clm_stat_desc,
                   a.claim_id,
                   a.clm_file_date,
                   a.recovery_sw,
                   a.dsp_loss_date,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no
          ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.loss_res_amt := i.loss_res_amt;
         v_list.claim_no := i.claim_no;
         v_list.exp_res_amt := i.exp_res_amt;
         v_list.loss_pd_amt := i.loss_pd_amt;
         v_list.exp_pd_amt := i.exp_pd_amt;
         v_list.pol_no := i.pol_no;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.clm_file_date := i.clm_file_date;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery_sw := i.recovery_sw;

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
             WHERE claim_id = i.claim_id;
         END;

         IF     v_list.tot_loss_res_amt IS NULL
            AND v_list.tot_loss_pd_amt IS NULL
            AND v_list.tot_exp_res_amt IS NULL
            AND v_list.tot_exp_pd_amt IS NULL
         THEN
            FOR b IN
               (SELECT SUM (NVL (a.loss_res_amt, 0)) loss_res_amt,
                       SUM (NVL (a.loss_pd_amt, 0)) loss_pd_amt,
                       SUM (NVL (a.exp_res_amt, 0)) exp_res_amt,
                       SUM (NVL (a.exp_pd_amt, 0)) exp_pd_amt
                  FROM gicl_claims a
                 WHERE a.pack_policy_id = p_pack_policy_id
                   AND a.claim_id IN (
                          SELECT claim_id
                            FROM gicl_claims
                           WHERE check_user_per_iss_cd2 (a.line_cd,
                                                         a.iss_cd,
                                                         'GICLS274',
                                                         p_user_id
                                                        ) = 1)
                   AND (   (    (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC (a.loss_date),
                                         'fileDate', TRUNC (a.clm_file_date)
                                        ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                )
                            AND (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC (a.loss_date),
                                         'fileDate', TRUNC (a.clm_file_date)
                                        ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                )
                           )
                        OR (DECODE (p_search_by_opt,
                                    'lossDate', TRUNC (a.loss_date),
                                    'fileDate', TRUNC (a.clm_file_date)
                                   ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                           )
                       ))
            LOOP
               v_list.tot_loss_res_amt := NVL (b.loss_res_amt, 0);
               v_list.tot_loss_pd_amt := NVL (b.loss_pd_amt, 0);
               v_list.tot_exp_res_amt := NVL (b.exp_res_amt, 0);
               v_list.tot_exp_pd_amt := NVL (b.exp_pd_amt, 0);
            END LOOP;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**
    **  Created by      : Koks
    **  Date Created    : 01.30.2013
    **  Reference By    : (GICLS274 - Claims Listing Per Package Policy)
    **  Description     : get Line Cd
    **/
   FUNCTION get_clm_pack_line_list
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE pack_pol_flag = 'Y'
                ORDER BY line_name)
      LOOP
         v_list.code := i.line_cd;
         v_list.code_desc := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_pack_line_list;

   /**
    **  Created by      : Koks
    **  Date Created    : 01.30.2013
    **  Reference By    : (GICLS274 - Claims Listing Per Package Policy)
    **  Description     : Get Subline Cd
    **/
   FUNCTION get_clm_pack_subline_list (p_line_cd gicl_claims.line_cd%TYPE)
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.subline_cd, b.subline_name
                           FROM gipi_pack_polbasic a, giis_subline b
                          WHERE a.line_cd = b.line_cd
                            AND a.subline_cd = b.subline_cd
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       GROUP BY a.subline_cd, b.subline_name
                       ORDER BY 1)
      LOOP
         v_list.code := i.subline_cd;
         v_list.code_desc := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**
    **  Created by      : Koks
    **  Date Created    : 01.30.2013
    **  Reference By    : (GICLS274 - Claims Listing Per Package Policy)
    **  Description     : Get Iss Cd
    **/
   FUNCTION get_clm_pack_iss_list (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, c.iss_name
                           FROM gipi_pack_polbasic a,
                                giis_assured b,
                                giis_issource c
                          WHERE b.assd_no = a.assd_no
                            AND a.iss_cd = c.iss_cd
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                            AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                       ORDER BY 1)
      LOOP
         v_list.code := i.iss_cd;
         v_list.code_desc := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**
    **  Created by      : Koks
    **  Date Created    : 01.30.2013
    **  Reference By    : (GICLS274 - Claims Listing Per Package Policy)
    **  Description     : Get Issue YY
    **/
   FUNCTION get_clm_issue_pack_yy_list (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd  gicl_claims.pol_iss_cd%TYPE
   )
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.issue_yy
                           FROM gipi_pack_polbasic a
                          WHERE a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.iss_cd = NVL(p_pol_iss_cd, a.iss_cd)
                       ORDER BY 1)
      LOOP
         v_list.code := i.issue_yy;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**
    **  Created by      : Koks
    **  Date Created    : 01.30.2013
    **  Reference By    : (GICLS274 - Claims Listing Per Package Policy)
    **  Description     : Get Package Policy List
    **/
   FUNCTION get_clm_pack_policy_lov (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE
   )
      RETURN get_clm_pack_policy_lov_tab PIPELINED
   IS
      v_list   get_clm_pack_policy_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.iss_cd,
                                a.issue_yy, a.pol_seq_no, a.renew_no,
                                a.assd_no, a.pack_policy_id, b.assd_name
                           FROM gipi_pack_polbasic a,
                                giis_assured b,
                                gicl_claims c
                          WHERE b.assd_no = a.assd_no
                            AND a.pack_policy_id = c.pack_policy_id
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                            AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                            AND a.pol_seq_no =
                                              NVL (p_pol_seq_no, a.pol_seq_no)
                            AND a.renew_no = NVL (p_renew_no, a.renew_no)
                       ORDER BY 1)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.pack_policy_id := i.pack_policy_id;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
END;
/


