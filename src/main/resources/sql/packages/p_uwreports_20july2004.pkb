CREATE OR REPLACE PACKAGE BODY CPI.P_Uwreports_20july2004
/* Author     : TERRENCE TO
** Desciption : This package will hold all the procedures and functions that will
**              handle the Extraction for UWREPORTS (GIPIS901A) module.
**
*/
AS
   PROCEDURE extract_tab1 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER)
   AS
      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_evatprem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_fst_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_lgt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_doc_stamps_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_taxes_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_charges_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_dist_flag_tab IS TABLE OF gipi_polbasic.dist_flag%TYPE;

      TYPE v_spld_date_tab IS TABLE OF VARCHAR2 (20);

	  TYPE v_pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;

      v_assd_no                     v_assd_no_tab;
      v_policy_id                   v_policy_id_tab;
      v_issue_date                  v_issue_date_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_issue_yy                    v_issue_yy_tab;
      v_pol_seq_no                  v_pol_seq_no_tab;
      v_renew_no                    v_renew_no_tab;
      v_endt_iss_cd                 v_endt_iss_cd_tab;
      v_endt_yy                     v_endt_yy_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_incept_date                 v_incept_date_tab;
      v_expiry_date                 v_expiry_date_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_evatprem                    v_evatprem_tab;
      v_fst                         v_fst_tab;
      v_lgt                         v_lgt_tab;
      v_doc_stamps                  v_doc_stamps_tab;
      v_other_taxes                 v_other_taxes_tab;
      v_other_charges               v_other_charges_tab;
      v_dist_flag                   v_dist_flag_tab;
      v_spld_date                   v_spld_date_tab;
	  v_pol_flag                    v_pol_flag_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT a.assd_no, gp.policy_id gp_policy_id,
             TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
             gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
             gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
             gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
             gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
             gp.endt_seq_no gp_endt_seq_no,
             TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
             TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
             gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
             TO_CHAR (gp.acct_ent_date, 'MM-DD-YYYY') gp_acct_ent_date,
             TO_CHAR (gp.spld_acct_ent_date, 'MM-DD-YYYY') gp_spld_acct_ent_date,
             NULL, NULL, NULL, NULL, NULL,
             NULL, gp.dist_flag dist_flag,
             TO_CHAR (gp.spld_date, 'MM-DD-YYYY') gp_spld_date,
			 gp.pol_flag gp_pol_flag
        BULK COLLECT INTO v_assd_no, v_policy_id,
                          v_issue_date,
                          v_line_cd, v_subline_cd,
                          v_iss_cd, v_issue_yy,
                          v_pol_seq_no, v_renew_no,
                          v_endt_iss_cd, v_endt_yy,
                          v_endt_seq_no,
                          v_incept_date,
                          v_expiry_date,
                          v_tsi_amt, v_prem_amt,
                          v_acct_ent_date,
                          v_spld_acct_ent_date,
                          v_evatprem, v_fst, v_lgt, v_doc_stamps, v_other_taxes,
                          v_other_charges, v_dist_flag,
                          v_spld_date, v_pol_flag
        FROM gipi_polbasic gp, gipi_parlist a
       WHERE a.par_id = gp.par_id
         /*AND (  (p_parameter = 1  AND gp.cred_branch = NVL (p_iss_cd, gp.iss_cd))
		      OR (p_parameter = 2 AND gp.iss_cd = NVL (p_iss_cd, gp.iss_cd)))*/
         AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (gp.acct_ent_date) BETWEEN p_from_date
                                                  AND p_to_date
                  OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
	     AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
		 	 									gp.line_cd,
		 	 									gp.subline_cd,
												gp.iss_cd,
												gp.issue_yy,
												gp.pol_seq_no,
												gp.renew_no,
												p_param_date,
												p_from_date,
												p_to_date),1) = 1
		 AND NVL (gp.endt_type, 'A') = 'A'
         AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
         AND gp.line_cd    = NVL (p_line_cd, gp.line_cd)
		 AND gp.iss_cd     = DECODE(p_parameter,1,NVL(p_iss_cd,gp.cred_branch),NVL (p_iss_cd, gp.iss_cd));
    --SET SERVEROUTPUT ON;
      IF v_policy_id.EXISTS (1) THEN
         FOR idx IN v_policy_id.first .. v_policy_id.last
         LOOP
	dbms_output.put_line(v_policy_id(idx));
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (
                             TO_DATE (v_acct_ent_date (idx), 'MM-DD-YYYY'))
                             BETWEEN p_from_date
                                 AND p_to_date
                      AND TRUNC (
                             TO_DATE (
                                v_spld_acct_ent_date (idx),
                                'MM-DD-YYYY')) BETWEEN p_from_date
                                                   AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (TO_DATE (v_acct_ent_date (idx), 'MM-DD-YYYY'))
                           BETWEEN p_from_date
                               AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (
                           TO_DATE (v_spld_acct_ent_date (idx), 'MM-DD-YYYY'))
                           BETWEEN p_from_date
                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;
                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
				  v_spld_date(idx) := NULL;
			   END IF;
             END;

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_evat
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND (   git.tax_cd = Giacp.n ('EVAT')
                               OR git.tax_cd = Giacp.n ('5PREM_TAX'))
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_evatprem (idx) := NVL (c.gparam_evat, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_prem_tax
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('FST')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_fst (idx) := NVL (c.gparam_prem_tax, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_lgt
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('LGT')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_lgt (idx) := NVL (c.gparam_lgt, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_doc_stamps
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('DOC_STAMPS')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_doc_stamps (idx) :=
                                   NVL (c.gparam_doc_stamps, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR d IN
                (SELECT SUM (
                           NVL (git.tax_amt, 0) * giv.currency_rt) git_otax_amt
                   FROM gipi_inv_tax git, gipi_invoice giv
                  WHERE giv.iss_cd = git.iss_cd
                    AND giv.prem_seq_no = git.prem_seq_no
                    AND giv.policy_id = v_policy_id (idx)
                    AND NOT EXISTS ( SELECT gp.param_value_n
                                       FROM giac_parameters gp
                                      WHERE gp.param_name IN ('EVAT',
                                                              '5PREM_TAX',
                                                              'LGT',
                                                              'DOC_STAMPS',
                                                              'FST')
                                        AND gp.param_value_n = git.tax_cd))
            LOOP
               v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
            END LOOP; -- FOR D IN..

            FOR e IN  (SELECT SUM (
                                 NVL (giv.other_charges, 0) * giv.currency_rt)
                                    giv_otax_amt
                         FROM gipi_invoice giv
                        WHERE giv.policy_id = v_policy_id (idx))
            LOOP
               v_other_charges (idx) := NVL (e.giv_otax_amt, 0) * v_multiplier;
            END LOOP; --FOR E IN...
         END LOOP; -- FOR IDX IN 1 .. V_POL_COUNT
      END IF; --IF V_POLICY_ID.EXISTS(1)

      IF SQL%FOUND THEN --
         FORALL cnt IN v_policy_id.first .. v_policy_id.last
            INSERT INTO gipi_uwreports_ext
                        (line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         endt_seq_no,
                         incept_date,
                         expiry_date,
                         total_tsi,
                         total_prem,
                         evatprem,
                         fst,
                         lgt,
                         doc_stamps,
                         other_taxes,
                         other_charges,
                         param_date,
                         from_date,
                         TO_DATE,
                         scope,
                         user_id,
                         policy_id,
                         assd_no,
                         issue_date,
                         dist_flag,
                         spld_date,
                         acct_ent_date,
                         spld_acct_ent_date,pol_flag, cancel_data)
                 VALUES (v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         v_issue_yy (cnt),
                         v_pol_seq_no (cnt),
                         v_renew_no (cnt),
                         v_endt_iss_cd (cnt),
                         v_endt_yy (cnt),
                         v_endt_seq_no (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
						 v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_evatprem (cnt),
						 v_fst (cnt),
						 v_lgt (cnt),
						 v_doc_stamps (cnt),
						 v_other_taxes (cnt),
						 v_other_charges (cnt),
						 p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_policy_id (cnt),
                         v_assd_no (cnt),
                         TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'),
                         v_dist_flag (cnt),
                         TO_DATE (v_spld_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_acct_ent_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_spld_acct_ent_date (cnt), 'MM-DD-YYYY'), v_pol_flag(cnt),'N');
         COMMIT;
      END IF; --END OF IF SQL%FOUND
/*	  Cancelled_Policies(p_param_date,
	  					 p_from_date,
						 p_to_date,
						 p_iss_cd,
						 p_line_cd,
						 p_subline_cd,
						 p_user,
						 p_parameter);*/
   END; --EXTRACT TAB 1

   PROCEDURE extract_tab2 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2)
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (150);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_share_cd_tab IS TABLE OF giuw_perilds_dtl.share_cd%TYPE;

      TYPE v_share_type_tab IS TABLE OF giis_dist_share.share_type%TYPE;

      TYPE v_trty_name_tab IS TABLE OF giis_dist_share.trty_name%TYPE;

      TYPE v_trty_yy_tab IS TABLE OF giis_dist_share.trty_yy%TYPE;

      TYPE v_dist_no_tab IS TABLE OF giuw_perilds_dtl.dist_no%TYPE;

      TYPE v_dist_seq_no_tab IS TABLE OF giuw_perilds_dtl.dist_seq_no%TYPE;

      TYPE v_peril_cd_tab IS TABLE OF giuw_perilds_dtl.peril_cd%TYPE;

      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;

      TYPE v_nr_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;

      TYPE v_nr_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;

      TYPE v_nr_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;

      TYPE v_tr_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;

      TYPE v_tr_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;

      TYPE v_tr_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;

      TYPE v_fa_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;

      TYPE v_fa_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;

      TYPE v_fa_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;

      TYPE v_currency_rt_tab IS TABLE OF gipi_invoice.currency_rt%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF giuw_pol_dist.acct_ent_date%TYPE;

      TYPE v_acct_neg_date_tab IS TABLE OF giuw_pol_dist.acct_neg_date%TYPE;

      v_policy_id                   v_policy_id_tab;
      v_policy_no                   v_policy_no_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_share_cd                    v_share_cd_tab;
      v_share_type                  v_share_type_tab;
      v_trty_name                   v_trty_name_tab;
      v_trty_yy                     v_trty_yy_tab;
      v_dist_no                     v_dist_no_tab;
      v_dist_seq_no                 v_dist_seq_no_tab;
      v_peril_cd                    v_peril_cd_tab;
      v_peril_type                  v_peril_type_tab;
      v_nr_dist_tsi                 v_nr_dist_tsi_tab;
      v_nr_dist_prem                v_nr_dist_prem_tab;
      v_nr_dist_spct                v_nr_dist_spct_tab;
      v_tr_dist_tsi                 v_tr_dist_tsi_tab;
      v_tr_dist_prem                v_tr_dist_prem_tab;
      v_tr_dist_spct                v_tr_dist_spct_tab;
      v_fa_dist_tsi                 v_fa_dist_tsi_tab;
      v_fa_dist_prem                v_fa_dist_prem_tab;
      v_fa_dist_spct                v_fa_dist_spct_tab;
      v_currency_rt                 v_currency_rt_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_issue_yy                    v_issue_yy_tab;
      v_pol_seq_no                  v_pol_seq_no_tab;
      v_renew_no                    v_renew_no_tab;
      v_endt_iss_cd                 v_endt_iss_cd_tab;
      v_endt_yy                     v_endt_yy_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_acct_neg_date               v_acct_neg_date_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_dist_peril_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT b.policy_id, Get_Policy_No (b.policy_id) policy_no, g.line_cd,
             b.subline_cd, g.share_cd, f.share_type, f.trty_name, f.trty_yy,
             g.dist_no, g.dist_seq_no, g.peril_cd, h.peril_type,
             DECODE (f.share_type, '1', NVL (g.dist_tsi, 0)) * e.currency_rt  nr_dist_tsi,
             DECODE (f.share_type, '1', NVL (g.dist_prem, 0)) * e.currency_rt  nr_dist_prem,
             DECODE (f.share_type, '1', g.dist_spct) nr_dist_spct,
             DECODE (f.share_type, '2', NVL (g.dist_tsi, 0)) * e.currency_rt  tr_dist_tsi,
             DECODE (f.share_type, '2', NVL (g.dist_prem, 0)) * e.currency_rt  tr_dist_prem,
             DECODE (f.share_type, '2', g.dist_spct) tr_dist_spct,
             DECODE (f.share_type, '3', NVL (g.dist_tsi, 0)) * e.currency_rt  fa_dist_tsi,
             DECODE (f.share_type, '3', NVL (g.dist_prem, 0)) * e.currency_rt fa_dist_prem,
             DECODE (f.share_type, '3', g.dist_spct) fa_dist_spct,
             e.currency_rt, b.endt_seq_no, b.iss_cd, b.issue_yy,
             b.pol_seq_no, b.renew_no, b.endt_iss_cd, b.endt_yy,
             a.acct_ent_date, a.acct_neg_date
        BULK COLLECT INTO v_policy_id, v_policy_no, v_line_cd,
                          v_subline_cd, v_share_cd, v_share_type, v_trty_name, v_trty_yy,
                          v_dist_no, v_dist_seq_no, v_peril_cd, v_peril_type,
                          v_nr_dist_tsi,
                          v_nr_dist_prem,
                          v_nr_dist_spct,
                          v_tr_dist_tsi,
                          v_tr_dist_prem,
                          v_tr_dist_spct,
                          v_fa_dist_tsi,
                          v_fa_dist_prem,
                          v_fa_dist_spct,
                          v_currency_rt, v_endt_seq_no, v_iss_cd, v_issue_yy,
                          v_pol_seq_no, v_renew_no, v_endt_iss_cd, v_endt_yy,
                          v_acct_ent_date, v_acct_neg_date
        FROM gipi_polbasic b,
             giuw_pol_dist a,
             giuw_perilds_dtl g,
             gipi_invoice e,
             giis_dist_share f,
             giis_peril h
       WHERE a.policy_id = b.policy_id
         AND g.dist_no = a.dist_no
         AND a.policy_id = e.policy_id
         AND NVL (b.line_cd, b.line_cd) = f.line_cd
         AND NVL (b.line_cd, b.line_cd) = f.line_cd
         AND NVL (b.line_cd, b.line_cd) = f.line_cd
         AND b.line_cd >= '%'
         AND b.subline_cd >= '%'
         AND g.share_cd = f.share_cd
         AND g.share_cd = f.share_cd
         AND g.peril_cd = h.peril_cd
         AND g.line_cd = h.line_cd
         AND (   b.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND NVL (b.endt_type, 'A') = 'A'
         AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
         AND b.line_cd = NVL (p_line_cd, b.line_cd)
         AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
         AND (   (a.dist_flag = 3 AND b.dist_flag = 3)
              OR p_param_date = 4)
         AND (   (    p_param_date = 3
                  AND LAST_DAY (
                         Convert_Booking_My (b.booking_mth, b.booking_year)) >=
                                                                  p_from_date)
              OR (p_param_date <> 3))
         AND (   (    p_param_date = 3
                  AND Convert_Booking_My (b.booking_mth, b.booking_year) <=
                                                                    p_to_date)
              OR (p_param_date <> 3))
         AND (   (    TRUNC (
                         DECODE (
                            p_param_date,
                            1, b.issue_date,
                            2, b.eff_date,
                            4, a.acct_ent_date,
                            p_from_date + 1)) >= p_from_date
                  AND TRUNC (
                         DECODE (
                            p_param_date,
                            1, b.issue_date,
                            2, b.eff_date,
                            4, a.acct_ent_date,
                            p_to_date - 1)) <= p_to_date)
              OR (    a.acct_neg_date >= p_from_date
                  AND a.acct_neg_date <= p_to_date
                  AND p_param_date = 4))
	     AND DECODE(b.pol_flag,'4',Check_Date_Dist_Peril(b.line_cd,
		                                                 b.subline_cd,
													     b.iss_cd,
													     b.issue_yy,
													     b.pol_seq_no,
													     b.renew_no,
													     p_param_date,
													     p_from_date,
													     p_to_date)
								  ,1) = 1;

      IF v_policy_id.EXISTS (1) THEN

--      IF SQL%FOUND THEN
         FOR idx IN v_policy_id.first .. v_policy_id.last
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_nr_dist_tsi (idx) := v_nr_dist_tsi (idx) * v_multiplier;
                  v_nr_dist_prem (idx) := v_nr_dist_prem (idx) * v_multiplier;
                  v_tr_dist_tsi (idx) := v_tr_dist_tsi (idx) * v_multiplier;
                  v_tr_dist_prem (idx) := v_tr_dist_prem (idx) * v_multiplier;
                  v_fa_dist_tsi (idx) := v_fa_dist_tsi (idx) * v_multiplier;
                  v_fa_dist_prem (idx) := v_fa_dist_prem (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- FOR IDX IN 1 .. V_POL_COUNT
      END IF; --IF V_POLICY_ID.EXISTS(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.first .. v_policy_id.last
            INSERT INTO gipi_uwreports_dist_peril_ext
                        (policy_id,
                         policy_no,
                         line_cd,
                         subline_cd,
                         share_cd,
                         share_type,
                         dist_no,
                         dist_seq_no,
                         trty_name,
                         trty_yy,
                         from_date1,
                         to_date1,
                         peril_cd,
                         peril_type,
                         nr_dist_tsi,
                         nr_dist_prem,
                         nr_dist_spct,
                         tr_dist_tsi,
                         tr_dist_prem,
                         tr_dist_spct,
                         fa_dist_tsi,
                         fa_dist_prem,
                         fa_dist_spct,
                         currency_rt,
                         endt_seq_no,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         user_id,
                         scope,
                         param_date)
                 VALUES (v_policy_id (cnt),
                         v_policy_no (cnt),
                         v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_share_cd (cnt),
                         v_share_type (cnt),
                         v_dist_no (cnt),
                         v_dist_seq_no (cnt),
                         v_trty_name (cnt),
                         v_trty_yy (cnt),
                         p_from_date,
                         p_to_date,
                         v_peril_cd (cnt),
                         v_peril_type (cnt),
                         v_nr_dist_tsi (cnt),
                         v_nr_dist_prem (cnt),
                         v_nr_dist_spct (cnt),
                         v_tr_dist_tsi (cnt),
                         v_tr_dist_prem (cnt),
                         v_tr_dist_spct (cnt),
                         v_fa_dist_tsi (cnt),
                         v_fa_dist_prem (cnt),
                         v_fa_dist_spct (cnt),
                         v_currency_rt (cnt),
                         v_endt_seq_no (cnt),
                         v_iss_cd (cnt),
                         v_issue_yy (cnt),
                         v_pol_seq_no (cnt),
                         v_renew_no (cnt),
                         v_endt_iss_cd (cnt),
                         v_endt_yy (cnt),
                         p_user,
                         p_scope,
                         p_param_date);
      END IF; --END OF IF SQL%FOUND

      COMMIT;
   END; --EXTRACT TAB 2

   PROCEDURE extract_tab3 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2)
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;

      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (200);

      TYPE v_binder_no_tab IS TABLE OF VARCHAR2 (200);

      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_ri_tsi_amt_tab IS TABLE OF giri_binder.ri_tsi_amt%TYPE;

      TYPE v_ri_prem_amt_tab IS TABLE OF giri_binder.ri_prem_amt%TYPE;

      TYPE v_ri_comm_amt_tab IS TABLE OF giri_binder.ri_comm_amt%TYPE;

      TYPE v_ri_sname_tab IS TABLE OF giis_reinsurer.ri_sname%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_ri_cd_tab IS TABLE OF giis_reinsurer.ri_cd%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_line_name                   v_line_name_tab;
      v_subline_name                v_subline_name_tab;
      v_policy_no                   v_policy_no_tab;
      v_binder_no                   v_binder_no_tab;
      v_assd_name                   v_assd_name_tab;
      v_policy_id                   v_policy_id_tab;
      v_incept_date                 v_incept_date_tab;
      v_expiry_date                 v_expiry_date_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_ri_tsi_amt                  v_ri_tsi_amt_tab;
      v_ri_prem_amt                 v_ri_prem_amt_tab;
      v_ri_comm_amt                 v_ri_comm_amt_tab;
      v_ri_sname                    v_ri_sname_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_ri_cd                       v_ri_cd_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_ri_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT b250.line_cd, b250.subline_cd, b250.iss_cd, a120.line_name,
             a130.subline_name, Get_Policy_No (b250.policy_id) policy_no,
             b250.line_cd || '-' || LTRIM (TO_CHAR (d005.binder_yy, '09')) || '-'
             || LTRIM (TO_CHAR (d005.binder_seq_no, '099999')) binder_no,
             a020.assd_name, b250.policy_id,
             TO_CHAR (b250.incept_date, 'MM-DD-YYYY'),
             TO_CHAR (b250.expiry_date, 'MM-DD-YYYY'),
             d060.tsi_amt sum_insured, d060.prem_amt,
             d005.ri_tsi_amt amt_accepted, d005.ri_prem_amt prem_accepted,
             NVL(d005.ri_comm_amt,0) ri_comm_amt, a140.ri_sname ri_short_name,
             b250.acct_ent_date, b250.spld_acct_ent_date, d005.ri_cd,
             b250.endt_seq_no
        BULK COLLECT INTO v_line_cd, v_subline_cd, v_iss_cd, v_line_name,
                          v_subline_name, v_policy_no,
                          v_binder_no,
                          v_assd_name, v_policy_id,
                          v_incept_date,
                          v_expiry_date,
                          v_tsi_amt, v_prem_amt,
                          v_ri_tsi_amt, v_ri_prem_amt,
                          v_ri_comm_amt, v_ri_sname,
                          v_acct_ent_date, v_spld_acct_ent_date, v_ri_cd,
                          v_endt_seq_no
        FROM gipi_polbasic b250,
             giuw_pol_dist c080,
             giri_distfrps d060,
             giri_frps_ri d070,
             gipi_parlist b240,
             giri_binder d005,
             giis_line a120,
             giis_subline a130,
             giis_assured a020,
             giis_reinsurer a140
       WHERE d060.line_cd >= '%'
         AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
         AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
         AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
         AND c080.dist_no = d060.dist_no
         AND b250.par_id = b240.par_id
         AND c080.policy_id = b250.policy_id
         AND d070.fnl_binder_id = d005.fnl_binder_id
         AND NVL (a120.line_cd, a120.line_cd) =
                                             NVL (b250.line_cd, b250.line_cd)
         AND NVL (b250.line_cd, b250.line_cd) =
                                             NVL (a130.line_cd, a130.line_cd)
         AND NVL (b250.subline_cd, b250.subline_cd) =
                                       NVL (a130.subline_cd, a130.subline_cd)
         AND b240.assd_no = a020.assd_no
         AND d005.ri_cd = a140.ri_cd
         AND (   b250.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND NVL (b250.endt_type, 'A') = 'A'
         AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd)
         AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
         AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
         AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date
                                                    AND p_to_date
                  OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         AND d005.reverse_date IS NULL
	     AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
		 	 									  b250.line_cd,
		 	 				  					  b250.subline_cd,
												  b250.iss_cd,
												  b250.issue_yy,
												  b250.pol_seq_no,
												  b250.renew_no,
												  p_param_date,
												  p_from_date,
												  p_to_date),1) = 1;

      IF v_policy_id.EXISTS (1) THEN

--IF SQL%FOUND THEN
         FOR idx IN v_policy_id.first .. v_policy_id.last
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
                  v_ri_tsi_amt (idx) := v_ri_tsi_amt (idx) * v_multiplier;
                  v_ri_prem_amt (idx) := v_ri_prem_amt (idx) * v_multiplier;
                  v_ri_comm_amt (idx) := v_ri_comm_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- FOR IDX IN 1 .. V_POL_COUNT
      END IF; --IF V_POLICY_ID.EXISTS(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.first .. v_policy_id.last
/*
DBMS_OUTPUT.PUT_LINE('assd_name-'||v_assd_name (cnt));
DBMS_OUTPUT.PUT_LINE('LINE_CD-'||v_line_cd (cnt));
DBMS_OUTPUT.PUT_LINE('SUBLINE_CD-'||v_subline_cd (cnt));
DBMS_OUTPUT.PUT_LINE('ISS_CD-'||v_iss_cd (cnt));
DBMS_OUTPUT.PUT_LINE('LINE_NAME-'||v_line_name (cnt));
DBMS_OUTPUT.PUT_LINE('SUBLINE_NAME-'||v_subline_name (cnt));
DBMS_OUTPUT.PUT_LINE('POLICY_NO-'||v_policy_no (cnt));
DBMS_OUTPUT.PUT_LINE('BINDER_NO-'||v_binder_no (cnt));
DBMS_OUTPUT.PUT_LINE('TOTAL_SI-'||v_tsi_amt (cnt));
DBMS_OUTPUT.PUT_LINE('TOTAL_PROM-'||v_prem_amt (cnt));
DBMS_OUTPUT.PUT_LINE('SUM_REINSURED-'||v_ri_tsi_amt (cnt));
DBMS_OUTPUT.PUT_LINE('SHARE_PREM-'||v_ri_prem_amt (cnt));
DBMS_OUTPUT.PUT_LINE('COMM_AMT-'||v_ri_comm_amt (cnt));
DBMS_OUTPUT.PUT_LINE('NET_DUE-'||NVL (v_ri_prem_amt (cnt), 0)
                         - NVL (v_ri_comm_amt (cnt), 0));
DBMS_OUTPUT.PUT_LINE('SHORT_NAME-'||v_ri_sname (cnt));
DBMS_OUTPUT.PUT_LINE('RI_CD-'||v_ri_cd (cnt));
DBMS_OUTPUT.PUT_LINE('POLICY_CD-'||v_policy_cd (cnt));
DBMS_OUTPUT.PUT_LINE('PARAM_DATE-'||p_param_date);
DBMS_OUTPUT.PUT_LINE('FROM_DATE-'||p_from_date);
DBMS_OUTPUT.PUT_LINE('TO_DATE-'||p_to_date);
DBMS_OUTPUT.PUT_LINE('USER_ID-'||p_user);*/
			INSERT INTO gipi_uwreports_ri_ext
                        (assd_name,
                         line_cd,
                         subline_cd,
                         iss_cd,
                         incept_date,
                         expiry_date,
                         line_name,
                         subline_name,
                         policy_no,
                         binder_no,
                         total_si,
                         total_prem,
                         sum_reinsured,
                         share_premium,
                         ri_comm_amt,
                         net_due,
                         ri_short_name,
                         ri_cd,
                         policy_id,
                         param_date,
                         from_date,
                         TO_DATE,
                         scope,
                         user_id,
                         endt_seq_no)
                 VALUES (v_assd_name (cnt),
                         v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                         v_line_name (cnt),
                         v_subline_name (cnt),
                         v_policy_no (cnt),
                         v_binder_no (cnt),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_ri_tsi_amt (cnt),
                         v_ri_prem_amt (cnt),
                         v_ri_comm_amt (cnt),
                         NVL (v_ri_prem_amt (cnt), 0)
                         - NVL (v_ri_comm_amt (cnt), 0),
                         v_ri_sname (cnt),
                         v_ri_cd (cnt),
                         v_policy_id (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_endt_seq_no (cnt));
         COMMIT;
      END IF; --END OF IF SQL%FOUND
   END; --EXTRACT TAB 3

   PROCEDURE extract_tab4 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2)
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_peril_sname_tab IS TABLE OF giis_peril.peril_sname%TYPE;

      TYPE v_peril_name_tab IS TABLE OF giis_peril.peril_name%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_line_name                   v_line_name_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_peril_sname                 v_peril_sname_tab;
      v_peril_name                  v_peril_name_tab;
      v_intm_name                   v_intm_name_tab;
      v_peril_cd                    v_peril_cd_tab;
      v_peril_type                  v_peril_type_tab;
      v_intm_no                     v_intm_no_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_policy_id                   v_policy_id_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_peril_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT   b250.line_cd, b250.subline_cd, a100.line_name,
               SUM (
                  NVL (b300.share_percentage, 0) / 100 * NVL (
                                                            b400.tsi_amt,
                                                            0)) tsi_amt,
               SUM (
                  NVL (b300.share_percentage, 0) / 100
                  * NVL (b400.prem_amt, 0)) prem_amt,
               a300.peril_sname, a300.peril_name, a400.intm_name,
               a300.peril_cd, a300.peril_type, a400.intm_no,
               b250.acct_ent_date, b250.spld_acct_ent_date, b250.policy_id,
               b250.iss_cd, b250.endt_seq_no
          BULK COLLECT INTO v_line_cd, v_subline_cd, v_line_name,
                            v_tsi_amt,
                            v_prem_amt,
                            v_peril_sname, v_peril_name, v_intm_name,
                            v_peril_cd, v_peril_type, v_intm_no,
                            v_acct_ent_date, v_spld_acct_ent_date, v_policy_id,
                            v_iss_cd, v_endt_seq_no
          FROM gipi_polbasic b250,
               gipi_comm_invoice b300,
               gipi_invperil b400,
               giis_line a100,
               giis_peril a300,
               giis_intermediary a400
         WHERE NVL (b300.intrmdry_intm_no, b300.intrmdry_intm_no) =
                                             NVL (a400.intm_no, a400.intm_no)
           AND NVL (b400.peril_cd, b400.peril_cd) =
                                           NVL (a300.peril_cd, a300.peril_cd)
           AND NVL (a300.line_cd, a300.line_cd) =
                                             NVL (b250.line_cd, b250.line_cd)
           AND b250.line_cd = a100.line_cd
           AND b250.line_cd = a100.line_cd
           AND b300.iss_cd = b400.iss_cd
           AND b300.prem_seq_no = b400.prem_seq_no
           AND b250.policy_id = b300.policy_id
           AND (   b250.pol_flag != '5'
                OR DECODE (p_param_date, 4, 1, 0) = 1)
           --AND (B250.DIST_FLAG = '3'  OR DECODE(V_PARAM_DATE,4,1,0) = 1)
           AND NVL (b250.endt_type, 'A') = 'A'
           AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd)
           AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
           AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
           AND b250.iss_cd <> Giacp.v ('RI_ISS_CD')
           AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 1, 0, 1) = 1)
           AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 2, 0, 1) = 1)
           AND (   LAST_DAY (
                      TO_DATE (
                         b250.booking_mth || ',' || TO_CHAR (
                                                       b250.booking_year),
                         'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                              AND LAST_DAY (p_to_date)
                OR DECODE (p_param_date, 3, 0, 1) = 1)
           AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date
                                                      AND p_to_date
                    OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                          BETWEEN p_from_date
                              AND p_to_date)
                OR DECODE (p_param_date, 4, 0, 1) = 1)
		   AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
		   	   		  								b250.line_cd,
		 	 				  					    b250.subline_cd,
												    b250.iss_cd,
												    b250.issue_yy,
												    b250.pol_seq_no,
												    b250.renew_no,
												    p_param_date,
												    p_from_date,
												    p_to_date),1) = 1
      GROUP BY b250.line_cd,
               b250.subline_cd,
               a100.line_name,
               a300.peril_sname,
               a300.peril_name,
               a400.intm_name,
               a300.peril_cd,
               a300.peril_type,
               a400.intm_no,
               b250.acct_ent_date,
               b250.spld_acct_ent_date,
               b250.policy_id,
               b250.iss_cd,
               b250.endt_seq_no;

      IF v_policy_id.EXISTS (1) THEN

--IF SQL%FOUND THEN
         FOR idx IN v_policy_id.first .. v_policy_id.last
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- FOR IDX IN 1 .. V_POL_COUNT
      END IF; --IF V_POLICY_ID.EXISTS(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.first .. v_policy_id.last
            INSERT INTO gipi_uwreports_peril_ext
                        (line_cd,
                         subline_cd,
                         iss_cd,
                         line_name,
                         tsi_amt,
                         prem_amt,
                         policy_id,
                         peril_cd,
                         peril_sname,
                         peril_name,
                         peril_type,
                         intm_no,
                         intm_name,
                         param_date,
                         from_date,
                         TO_DATE,
                         scope,
                         user_id,
                         endt_seq_no)
                 VALUES (v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         v_line_name (cnt),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_policy_id (cnt),
                         v_peril_cd (cnt),
                         v_peril_sname (cnt),
                         v_peril_name (cnt),
                         v_peril_type (cnt),
                         v_intm_no (cnt),
                         v_intm_name (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_endt_seq_no (cnt));
         COMMIT;
      END IF; --END OF IF SQL%FOUND
   END; --EXTRACT TAB 4 DIRECT

   PROCEDURE extract_tab4_ri (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2)
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_peril_sname_tab IS TABLE OF giis_peril.peril_sname%TYPE;

      TYPE v_peril_name_tab IS TABLE OF giis_peril.peril_name%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_line_name                   v_line_name_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_peril_sname                 v_peril_sname_tab;
      v_peril_name                  v_peril_name_tab;
      v_intm_name                   v_intm_name_tab;
      v_peril_cd                    v_peril_cd_tab;
      v_peril_type                  v_peril_type_tab;
      v_intm_no                     v_intm_no_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_policy_id                   v_policy_id_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      SELECT b250.line_cd, b250.subline_cd, a100.line_name, b400.tsi_amt,
             b400.prem_amt, a300.peril_sname, a300.peril_name, NULL,
             a300.peril_cd, a300.peril_type, NULL, b250.acct_ent_date,
             b250.spld_acct_ent_date, b250.policy_id, b250.iss_cd,
             b250.endt_seq_no
        BULK COLLECT INTO v_line_cd, v_subline_cd, v_line_name, v_tsi_amt,
                          v_prem_amt, v_peril_sname, v_peril_name, v_intm_name,
                          v_peril_cd, v_peril_type, v_intm_no, v_acct_ent_date,
                          v_spld_acct_ent_date, v_policy_id, v_iss_cd,
                          v_endt_seq_no
        FROM gipi_polbasic b250,
             gipi_invperil b400,
             giis_line a100,
             giis_peril a300,
             gipi_invoice l300
       WHERE b250.policy_id = l300.policy_id
         AND l300.iss_cd = b400.iss_cd
         AND l300.iss_cd = b400.iss_cd
         AND l300.prem_seq_no = b400.prem_seq_no
         AND l300.prem_seq_no = b400.prem_seq_no
         AND b400.peril_cd = a300.peril_cd
         AND a300.line_cd = b250.line_cd
         AND b250.line_cd = a100.line_cd
         AND b250.iss_cd = Giacp.v ('RI_ISS_CD')
         AND (   b250.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND NVL (b250.endt_type, 'A') = 'A'
         AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd)
         AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
         AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
         AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date
                                                    AND p_to_date
                  OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
	     AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
		 	 									  b250.line_cd,
		 	 				  					  b250.subline_cd,
												  b250.iss_cd,
												  b250.issue_yy,
												  b250.pol_seq_no,
												  b250.renew_no,
												  p_param_date,
												  p_from_date,
												  p_to_date),1) = 1;

      IF v_policy_id.EXISTS (1) THEN

--IF SQL%FOUND THEN
         FOR idx IN v_policy_id.first .. v_policy_id.last
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- FOR IDX IN 1 .. V_POL_COUNT
      END IF; --IF V_POLICY_ID.EXISTS(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.first .. v_policy_id.last
            INSERT INTO gipi_uwreports_peril_ext
                        (line_cd,
                         subline_cd,
                         iss_cd,
                         line_name,
                         tsi_amt,
                         prem_amt,
                         policy_id,
                         peril_cd,
                         peril_sname,
                         peril_name,
                         peril_type,
                         intm_no,
                         intm_name,
                         param_date,
                         from_date,
                         TO_DATE,
                         scope,
                         user_id,
                         endt_seq_no)
                 VALUES (v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         v_line_name (cnt),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_policy_id (cnt),
                         v_peril_cd (cnt),
                         v_peril_sname (cnt),
                         v_peril_name (cnt),
                         v_peril_type (cnt),
                         v_intm_no (cnt),
                         v_intm_name (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_endt_seq_no (cnt));
         COMMIT;
      END IF; -- END OF IF SQL%FOUND
   END; --EXTRACT TAB 4 RI

   PROCEDURE extract_tab5 (
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_scope        IN   NUMBER,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_assd         IN   NUMBER,
      p_intm         IN   NUMBER)
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;

      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;

      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;

      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;

      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);

      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;

      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;

      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;

      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;

      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;

      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;

      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE v_evatprem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_fst_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_lgt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_doc_stamps_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_taxes_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE v_other_charges_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      v_policy_id                   v_policy_id_tab;
      v_assd_name                   v_assd_name_tab;
      v_issue_date                  v_issue_date_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_issue_yy                    v_issue_yy_tab;
      v_pol_seq_no                  v_pol_seq_no_tab;
      v_renew_no                    v_renew_no_tab;
      v_endt_iss_cd                 v_endt_iss_cd_tab;
      v_endt_yy                     v_endt_yy_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_incept_date                 v_incept_date_tab;
      v_expiry_date                 v_expiry_date_tab;
      v_line_name                   v_line_name_tab;
      v_subline_name                v_subline_name_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_intm_name                   v_intm_name_tab;
      v_assd_no                     v_assd_no_tab;
      v_intm_no                     v_intm_no_tab;
      v_evatprem                    v_evatprem_tab;
      v_fst                         v_fst_tab;
      v_lgt                         v_lgt_tab;
      v_doc_stamps                  v_doc_stamps_tab;
      v_other_taxes                 v_other_taxes_tab;
      v_other_charges               v_other_charges_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_intm_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT gp.policy_id gp_policy_id, ga.assd_name ga_assd_name,
             TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
             gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
             gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
             gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
             gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
             gp.endt_seq_no gp_endt_seq_no,
             TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
             TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
             gl.line_name gl_line_name, gs.subline_name gs_subline_name,
             gp.tsi_amt gp_tsi_amt, gci.premium_amt gp_prem_amt,
             gp.acct_ent_date gp_acct_ent_date,
             gp.spld_acct_ent_date gp_spld_acct_ent_date,
             b.intm_name gp_intm_name, a.assd_no,
             gci.intrmdry_intm_no intm_no, NULL, NULL, NULL, NULL,
             NULL, NULL
        BULK COLLECT INTO v_policy_id, v_assd_name,
                          v_issue_date,
                          v_line_cd, v_subline_cd,
                          v_iss_cd, v_issue_yy,
                          v_pol_seq_no, v_renew_no,
                          v_endt_iss_cd, v_endt_yy,
                          v_endt_seq_no,
                          v_incept_date,
                          v_expiry_date,
                          v_line_name, v_subline_name,
                          v_tsi_amt, v_prem_amt,
                          v_acct_ent_date,
                          v_spld_acct_ent_date,
                          v_intm_name, v_assd_no,
                          v_intm_no, v_evatprem, v_fst, v_lgt, v_doc_stamps,
                          v_other_taxes, v_other_charges
        FROM gipi_polbasic gp,
             gipi_parlist a,
             giis_line gl,
             giis_subline gs,
             giis_issource gi,
             giis_assured ga,
             gipi_comm_invoice gci,
             giis_intermediary b
       WHERE gp.line_cd = gl.line_cd
         AND gci.intrmdry_intm_no >= 0
         AND gp.policy_id = gci.policy_id
         AND b.intm_no = gci.intrmdry_intm_no
         AND a.par_id = gp.par_id
         AND gp.subline_cd = gs.subline_cd
         AND gl.line_cd = gs.line_cd
         AND ga.assd_no = a.assd_no
         AND gp.iss_cd = gi.iss_cd
         AND gci.intrmdry_intm_no = NVL (p_intm, gci.intrmdry_intm_no)
         AND ga.assd_no = NVL (p_assd, ga.assd_no)
         AND (   gp.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND NVL (gp.endt_type, 'A') = 'A'
         AND gp.iss_cd = NVL (p_iss_cd, gp.iss_cd)
         AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
         AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
         AND gp.iss_cd <> Giacp.v ('RI_ISS_CD')
         AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (gp.acct_ent_date) BETWEEN p_from_date
                                                  AND p_to_date
                  OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
		AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
				   							   gp.line_cd,
		 	 				  				   gp.subline_cd,
											   gp.iss_cd,
											   gp.issue_yy,
											   gp.pol_seq_no,
											   gp.renew_no,
											   p_param_date,
											   p_from_date,
											   p_to_date),1) = 1;

      IF v_policy_id.EXISTS (1) THEN

--IF SQL%FOUND THEN
         FOR idx IN v_policy_id.first .. v_policy_id.last
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_evat
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND (   git.tax_cd = Giacp.n ('EVAT')
                               OR git.tax_cd = Giacp.n ('5PREM_TAX'))
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_evatprem (idx) := NVL (c.gparam_evat, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_prem_tax
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('FST')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_fst (idx) := NVL (c.gparam_prem_tax, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_lgt
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('LGT')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_lgt (idx) := NVL (c.gparam_lgt, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_doc_stamps
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('DOC_STAMPS')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_doc_stamps (idx) :=
                                   NVL (c.gparam_doc_stamps, 0) * v_multiplier;
            END LOOP; -- FOR C IN...

            FOR d IN
                (SELECT SUM (
                           NVL (git.tax_amt, 0) * giv.currency_rt) git_otax_amt
                   FROM gipi_inv_tax git, gipi_invoice giv
                  WHERE giv.iss_cd = git.iss_cd
                    AND giv.prem_seq_no = git.prem_seq_no
                    AND giv.policy_id = v_policy_id (idx)
                    AND NOT EXISTS ( SELECT gp.param_value_n
                                       FROM giac_parameters gp
                                      WHERE gp.param_name IN ('EVAT',
                                                              '5PREM_TAX',
                                                              'LGT',
                                                              'DOC_STAMPS',
                                                              'FST')
                                        AND gp.param_value_n = git.tax_cd))
            LOOP
               v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
            END LOOP; -- FOR D IN..

            FOR e IN  (SELECT SUM (
                                 NVL (giv.other_charges, 0) * giv.currency_rt)
                                    giv_otax_amt
                         FROM gipi_invoice giv
                        WHERE giv.policy_id = v_policy_id (idx))
            LOOP
               v_other_charges (idx) := NVL (e.giv_otax_amt, 0) * v_multiplier;
            END LOOP; --FOR E IN...
         END LOOP; -- FOR IDX IN 1 .. V_POL_COUNT
      END IF; --IF V_POLICY_ID.EXISTS(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.first .. v_policy_id.last
            INSERT INTO gipi_uwreports_intm_ext
                        (assd_name,
                         line_cd,
                         line_name,
                         subline_cd,
                         subline_name,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         endt_seq_no,
                         incept_date,
                         expiry_date,
                         total_tsi,
                         total_prem,
                         evatprem,
                         fst,
                         lgt,
                         doc_stamps,
                         other_taxes,
                         other_charges,
                         param_date,
                         from_date,
                         TO_DATE,
                         scope,
                         user_id,
                         policy_id,
                         intm_name,
                         assd_no,
                         intm_no,
                         issue_date)
                 VALUES (v_assd_name (cnt),
                         v_line_cd (cnt),
                         v_line_name (cnt),
                         v_subline_cd (cnt),
                         v_subline_name (cnt),
                         v_iss_cd (cnt),
                         v_issue_yy (cnt),
                         v_pol_seq_no (cnt),
                         v_renew_no (cnt),
                         v_endt_iss_cd (cnt),
                         v_endt_yy (cnt),
                         v_endt_seq_no (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_evatprem (cnt),
                         v_fst (cnt),
                         v_lgt (cnt),
                         v_doc_stamps (cnt),
                         v_other_taxes (cnt),
                         v_other_charges (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_policy_id (cnt),
                         v_intm_name (cnt),
                         v_assd_no (cnt),
                         v_intm_no (cnt),
                         TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'));
         COMMIT;
      END IF; --END OF IF SQL%FOUND
   END; --EXTRACT TAB 5
END P_Uwreports_20july2004;
/

DROP PACKAGE CPI.P_UWREPORTS_20JULY2004;

