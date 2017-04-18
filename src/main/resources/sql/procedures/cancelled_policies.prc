DROP PROCEDURE CPI.CANCELLED_POLICIES;

CREATE OR REPLACE PROCEDURE CPI.Cancelled_Policies (
-- rollie 03/15/04
-- based on procedure extract_tab1 of package p_uwreports

      --p_scope        IN   NUMBER,
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
   	  DELETE FROM GIPI_UWREPORTS_EXT
            WHERE user_id = p_user
			  AND cancel_data = 'Y';
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
	     AND gp.pol_flag = '4'
         AND NVL (gp.endt_type, 'A') = 'A'
         AND (  (p_parameter = 1  AND gp.cred_branch = NVL (p_iss_cd, gp.iss_cd))
		      OR (p_parameter = 2 AND gp.iss_cd = NVL (p_iss_cd, gp.iss_cd)))
		 AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
         AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
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
		 AND Check_Cancelled_Policies(gp.line_cd,
		 	 						  gp.subline_cd,
									  gp.iss_cd,
									  gp.issue_yy,
									  gp.pol_seq_no,
									  gp.renew_no,
									  p_param_date,
									  p_from_date,
									  p_to_date) = 1;
    --SET SERVEROUTPUT ON;
      IF v_policy_id.EXISTS (1) THEN
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
	DBMS_OUTPUT.PUT_LINE(V_POLICY_ID(IDX));
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
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
			INSERT INTO GIPI_UWREPORTS_EXT
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
                         --SCOPE,
                         user_id,
                         policy_id,
                         assd_no,
                         issue_date,
                         dist_flag,
                         spld_date,
                         acct_ent_date,
                         spld_acct_ent_date,
						 pol_flag, cancel_data
						 )
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
                         --p_scope,
                         p_user,
                         v_policy_id (cnt),
                         v_assd_no (cnt),
                         TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'),
                         v_dist_flag (cnt),
                         TO_DATE (v_spld_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_acct_ent_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_spld_acct_ent_date (cnt), 'MM-DD-YYYY'), v_pol_flag(cnt),'Y');
         COMMIT;
      END IF; --END OF IF SQL%FOUND
   END; --EXTRACT TAB
/


