CREATE OR REPLACE PACKAGE BODY CPI.validate_spoilage
AS
   PROCEDURE check_paid_policy (
      p_policy_id   IN     gipi_polbasic.policy_id%TYPE,
      p_iss_cd      IN     gipi_polbasic.iss_cd%TYPE,
      p_msge1          OUT VARCHAR2,
      p_msge2          OUT VARCHAR2,
      p_msge3          OUT BOOLEAN
   )
   IS
      v_policy_id         gipi_invoice.policy_id%TYPE;
      v_ri                gipi_polbasic.iss_cd%TYPE := giisp.v ('ISS_CD_RI');
      v_prem_coll         giac_inwfacul_prem_collns.collection_amt%TYPE;
      v_iss_cd            gipi_polbasic.iss_cd%TYPE := p_iss_cd;
      v_policy_id_param   gipi_invoice.policy_id%TYPE := p_policy_id;
   BEGIN
      IF v_iss_cd != v_ri
      THEN
         FOR a1
         IN (SELECT   a.policy_id policy_id
               FROM   gipi_invoice a, giac_aging_soa_details b
              WHERE       a.policy_id = v_policy_id_param
                      AND a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND b.total_amount_due != b.balance_amt_due)
         LOOP
            v_policy_id := a1.policy_id;
            EXIT;
         END LOOP;

         IF v_policy_id IS NOT NULL
         THEN
            p_msge1 :=
               'Please reverse the payment for the policy before spoilage.';
            p_msge2 := 'E';
            p_msge3 := TRUE;
         END IF;
      END IF;

      IF v_iss_cd = v_ri
      THEN
         FOR a1
         IN (SELECT   a.policy_id policy_id
               FROM   gipi_invoice a, giac_aging_ri_soa_details b
              WHERE       a.policy_id = v_policy_id_param
                      AND b.gagp_aging_id >= 0
                      AND a.iss_cd = v_ri
                      AND a.prem_seq_no = b.prem_seq_no
                      AND b.total_amount_due != b.balance_due)
         LOOP
            IF NVL (a1.policy_id, 0) != 0
            THEN
               p_msge1 :=
                  'Policy has collection(s) already from Cedant. '
                  || 'Reverse the collections first before spoiling the policy.';
               p_msge2 := 'I';
               p_msge3 := TRUE;
            END IF;

            EXIT;
         END LOOP;
      END IF;
   END check_paid_policy;

   PROCEDURE check_reinsurance_payment (
      p_policy_id   IN     gipi_polbasic.policy_id%TYPE,
      p_line_cd     IN     gipi_polbasic.line_cd%TYPE,
      p_msge1          OUT VARCHAR2,
      p_msge2          OUT VARCHAR2,
      p_msge3          OUT BOOLEAN
   )
   IS
      v_param_value_n giis_parameters.param_value_n%TYPE
            := giisp.n ('FACULTATIVE') ;
      v_policy_id_param   gipi_invoice.policy_id%TYPE := p_policy_id;
      v_line_cd           gipi_polbasic.line_cd%TYPE := p_line_cd;
   BEGIN
      IF v_param_value_n IS NOT NULL
      THEN
         FOR a2
         IN (SELECT   a.dist_no dist_no,
                      a.dist_seq_no dist_seq_no,
                      a.line_cd line_cd,
                      a.share_cd share_cd
               FROM   giuw_pol_dist c, giuw_policyds_dtl a, giuw_policyds b
              WHERE       c.policy_id = v_policy_id_param
                      AND c.dist_no = b.dist_no
                      AND c.negate_date IS NULL
                      AND a.dist_no = b.dist_no
                      AND a.dist_seq_no = b.dist_seq_no
                      AND a.line_cd = v_line_cd
                      AND a.share_cd = v_param_value_n)
         LOOP
            FOR a3
            IN (SELECT   c.fnl_binder_id, b.ri_cd
                  FROM   giri_distfrps a, giri_frps_ri b, giri_binder c
                 WHERE       a.dist_no = a2.dist_no
                         AND a.dist_seq_no = a2.dist_seq_no
                         AND a.frps_yy = b.frps_yy
                         AND a.frps_seq_no = b.frps_seq_no
                         AND b.line_cd = a2.line_cd
                         AND b.fnl_binder_id = c.fnl_binder_id
                         AND c.reverse_date IS NULL)
            LOOP
               FOR a4
               IN (SELECT   SUM (NVL (a.disbursement_amt, 0)) amt
                     FROM   giac_outfacul_prem_payts a, giac_acctrans b
                    WHERE       a.a180_ri_cd = a3.ri_cd
                            AND a.d010_fnl_binder_id = a3.fnl_binder_id
                            AND a.gacc_tran_id = b.tran_id
                            AND b.tran_flag <> 'D'
                            AND NOT EXISTS
                                  (SELECT   '1'
                                     FROM   giac_reversals c, giac_acctrans d
                                    WHERE   a.gacc_tran_id = c.gacc_tran_id
                                            AND c.reversing_tran_id =
                                                  d.tran_id
                                            AND d.tran_flag <> 'D'))
               LOOP
                  IF a4.amt <> 0
                  THEN
                     p_msge1 :=
                        'This policy has collections from Facultative Reinsurers, Cannot spoil policy.';
                     p_msge2 := 'I';
                     p_msge3 := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
            END LOOP;
         END LOOP;
      END IF;
   END;

   PROCEDURE validate_renewal_policy (
      p_line_cd      IN     giex_expiry.line_cd%TYPE,
      p_subline_cd   IN     giex_expiry.subline_cd%TYPE,
      p_iss_cd       IN     giex_expiry.iss_cd%TYPE,
      p_issue_yy     IN     giex_expiry.issue_yy%TYPE,
      p_pol_seq_no   IN     giex_expiry.pol_seq_no%TYPE,
      p_renew_no     IN     giex_expiry.renew_no%TYPE,
      p_alert           OUT VARCHAR2
   )
   IS
   BEGIN
      FOR c
      IN (SELECT   policy_id
            FROM   gipi_polbasic
           WHERE       line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         FOR n
         IN (SELECT   b.par_status
               FROM   gipi_wpolnrep a, gipi_parlist b
              WHERE       1 = 1
                      AND a.par_id = b.par_id
                      AND a.old_policy_id = c.policy_id)
         LOOP
            IF n.par_status NOT IN (99, 98)
            THEN
               p_alert := 'Y';
            ELSE
               p_alert := 'N';
            END IF;

            EXIT;
         END LOOP;

         FOR x
         IN (SELECT   b.pol_flag
               FROM   gipi_polnrep a, gipi_polbasic b
              WHERE       1 = 1
                      AND a.new_policy_id = b.policy_id
                      AND a.old_policy_id = c.policy_id)
         LOOP
            IF x.pol_flag NOT IN ('4', '5', 'X')
            THEN
               p_alert := 'Y';
            ELSE
               p_alert := 'N';
            END IF;

            EXIT;
         END LOOP;

         EXIT;
      END LOOP;
   END validate_renewal_policy;

   PROCEDURE validate_renewal_pack_policy (
      p_line_cd      IN     giex_expiry.line_cd%TYPE,
      p_subline_cd   IN     giex_expiry.subline_cd%TYPE,
      p_iss_cd       IN     giex_expiry.iss_cd%TYPE,
      p_issue_yy     IN     giex_expiry.issue_yy%TYPE,
      p_pol_seq_no   IN     giex_expiry.pol_seq_no%TYPE,
      p_renew_no     IN     giex_expiry.renew_no%TYPE,
      p_alert           OUT VARCHAR2
   )
   IS
   BEGIN
      FOR c
      IN (SELECT   pack_policy_id
            FROM   gipi_pack_polbasic
           WHERE       line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         FOR n
         IN (SELECT   b.par_status
               FROM   gipi_pack_wpolnrep a, gipi_pack_parlist b
              WHERE       1 = 1
                      AND a.pack_par_id = b.pack_par_id
                      AND a.old_pack_policy_id = c.pack_policy_id)
         LOOP
            IF n.par_status NOT IN (99, 98)
            THEN
               p_alert := 'N';
            ELSE
               p_alert := 'Y';
            END IF;


            EXIT;
         END LOOP;

         FOR x
         IN (SELECT   b.pol_flag
               FROM   gipi_pack_polnrep a, gipi_pack_polbasic b
              WHERE       1 = 1
                      AND a.new_pack_policy_id = b.pack_policy_id
                      AND a.old_pack_policy_id = c.pack_policy_id)
         LOOP
            IF x.pol_flag NOT IN ('4', '5', 'X')
            THEN
               p_alert := 'N';
            ELSE
               p_alert := 'Y';
            END IF;

            EXIT;
         END LOOP;

         EXIT;
      END LOOP;
   END validate_renewal_pack_policy;


   PROCEDURE check_acct_ent_date (
      p_acct_ent_date       gipi_polbasic.acct_ent_date%TYPE,
      p_restrict            giis_parameters.param_value_v%TYPE,
      p_msge1           OUT VARCHAR2,
      p_msge2           OUT VARCHAR2,
      p_msge3           OUT BOOLEAN
   )
   IS
      v_acct_ent_date   gipi_polbasic.acct_ent_date%TYPE := p_acct_ent_date;
      v_restrict        giis_parameters.param_value_v%TYPE := p_restrict;
   BEGIN
      IF v_acct_ent_date IS NOT NULL
      THEN
         IF v_restrict = 'Y'
         THEN
            p_msge1 :=
                  'Policy has been considered in Accounting on '
               || TO_CHAR (v_acct_ent_date, 'fmMonth DD, YYYY')
               || ', Cannot spoil policy.';
            p_msge2 := 'I';
            p_msge3 := TRUE;
         ELSE
            p_msge1 :=
                  'Policy has been considered in Accounting on '
               || TO_CHAR (v_acct_ent_date, 'fmMonth DD, YYYY')
               || ', Please inform Accounting of spoilage.';
            p_msge2 := 'I';
            p_msge3 := FALSE;
         END IF;
      END IF;
   END check_acct_ent_date;
END validate_spoilage;
/


