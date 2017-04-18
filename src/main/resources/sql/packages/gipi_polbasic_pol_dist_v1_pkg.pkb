CREATE OR REPLACE PACKAGE BODY CPI.gipi_polbasic_pol_dist_v1_pkg
IS
/**
** Created by:      Veronica V. Raymundo
** Date Created:    July 6, 2011
** Reference by:    GIUWS010 - Set-up Group for Distribution
** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
**
**/
   FUNCTION get_polbasic_pol_dist_v1 (
      p_module_id     giis_user_grp_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic_pol_dist_v1.line_cd%TYPE,
      p_subline_cd    gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic_pol_dist_v1.renew_no%TYPE,
      p_endt_yy       gipi_polbasic_pol_dist_v1.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_dist_no       gipi_polbasic_pol_dist_v1.dist_no%TYPE
   )
      RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
   AS
      v_pol_dist   gipi_polbasic_pol_dist_v1_type;
   BEGIN
      FOR i IN
         (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag, a.acct_ent_date,
                   a.spld_flag, d.dist_flag, a.dist_no, a.eff_date,
                   a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
				   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.endt_iss_cd
                   || '-'
                   || TO_CHAR (a.endt_yy, '09')
                   || '-'
                   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
              FROM gipi_polbasic_pol_dist_v1 a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d
             WHERE a.dist_flag IN ('1','2')
               AND NOT EXISTS (
                      SELECT '1'
                        FROM giri_distfrps b2502
                       WHERE b2502.dist_no = a.dist_no
                         AND ri_flag IN ('2', '3', '4'))
               AND a.line_cd || '-' || a.iss_cd IN (
                          SELECT line_cd || '-' || iss_cd
                            FROM TABLE (check_security (p_module_id,
                                                        p_user_id)
                                       ))
               AND a.assd_no = b.assd_no(+)
               AND a.policy_id = c.policy_id
               AND a.policy_id = d.policy_id
               AND a.dist_no = d.dist_no
               AND a.line_cd LIKE UPPER (NVL (p_line_cd, a.line_cd))
               AND a.iss_cd LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
               AND a.issue_yy LIKE UPPER (NVL (p_issue_yy, a.issue_yy))
               AND a.pol_seq_no LIKE UPPER (NVL (p_pol_seq_no, a.pol_seq_no))
               AND a.renew_no LIKE UPPER (NVL (p_renew_no, a.renew_no))
               AND a.endt_yy LIKE UPPER (NVL (p_endt_yy, a.endt_yy))
               AND a.endt_seq_no LIKE
                                    UPPER (NVL (p_endt_seq_no, a.endt_seq_no))
               AND a.dist_no LIKE UPPER (NVL (p_dist_no, a.dist_no))
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
          ORDER BY line_cd ASC,
                   subline_cd ASC,
                   iss_cd ASC,
                   issue_yy DESC,
                   pol_seq_no ASC,
                   endt_iss_cd ASC,
                   endt_yy DESC,
                   endt_seq_no ASC,
                   dist_no ASC)
      LOOP
         v_pol_dist.policy_id       := i.policy_id;
         v_pol_dist.line_cd         := i.line_cd;
         v_pol_dist.subline_cd      := i.subline_cd;
         v_pol_dist.iss_cd          := i.iss_cd;
         v_pol_dist.issue_yy        := i.issue_yy;
         v_pol_dist.pol_seq_no      := i.pol_seq_no;
         v_pol_dist.endt_iss_cd     := i.endt_iss_cd;
         v_pol_dist.endt_yy         := i.endt_yy;
         v_pol_dist.endt_seq_no     := i.endt_seq_no;
         v_pol_dist.renew_no        := i.renew_no;
         v_pol_dist.par_id          := i.par_id;
         v_pol_dist.pol_flag        := i.pol_flag;
         v_pol_dist.assd_no         := i.assd_no;
         v_pol_dist.assd_name       := i.assd_name;
         v_pol_dist.acct_ent_date   := i.acct_ent_date;
         v_pol_dist.spld_flag       := i.spld_flag;
         v_pol_dist.pack_pol_flag   := i.pack_pol_flag;
         v_pol_dist.dist_flag       := i.dist_flag;
         v_pol_dist.dist_no         := i.dist_no;
         v_pol_dist.eff_date        := i.eff_date;
         v_pol_dist.expiry_date     := i.expiry_date;
         v_pol_dist.negate_date     := i.negate_date;
         v_pol_dist.dist_type       := i.dist_type;
         v_pol_dist.acct_neg_date   := i.acct_neg_date;
         v_pol_dist.par_type        := i.par_type;
         v_pol_dist.policy_no       := i.policy_no;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;
   END get_polbasic_pol_dist_v1;

   /**
   ** Created by:      Emman
   ** Date Created:    July 19, 2011
   ** Reference by:    GIUWS012 - Distribution by Peril
   ** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
   **
   **/
   FUNCTION get_pol_dist_v1_for_peril_dist (
      p_line_cd       gipi_polbasic_pol_dist_v1.line_cd%TYPE,
      p_subline_cd    gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic_pol_dist_v1.renew_no%TYPE,
      p_endt_yy       gipi_polbasic_pol_dist_v1.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_dist_no       gipi_polbasic_pol_dist_v1.dist_no%TYPE
   )
      RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
   AS
      v_pol_dist   gipi_polbasic_pol_dist_v1_type;
   BEGIN
      FOR i IN
         (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag, a.acct_ent_date,
                   a.spld_flag, d.dist_flag, a.dist_no, a.eff_date,
                   a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
				   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added renew_no by christian 01/04/13
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.endt_iss_cd
                   || '-'
                   || TO_CHAR (a.endt_yy, '09')
                   || '-'
                   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
              FROM gipi_polbasic_pol_dist_v1 a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d
             WHERE NVL (a.dist_flag, '1') != '3'
               --AND NOT EXISTS (
               --       SELECT '1'
               --         FROM giri_distfrps e
               --        WHERE e.dist_no = a.dist_no
               --          AND ri_flag IN ('2', '3', '4'))
               AND a.assd_no = b.assd_no(+)
               AND a.policy_id = c.policy_id
               AND a.policy_id = d.policy_id
               AND a.dist_no = d.dist_no
               AND a.line_cd LIKE UPPER (NVL (p_line_cd, a.line_cd))
               AND a.iss_cd LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
               AND a.issue_yy LIKE UPPER (NVL (p_issue_yy, a.issue_yy))
               AND a.pol_seq_no LIKE UPPER (NVL (p_pol_seq_no, a.pol_seq_no))
               AND a.renew_no LIKE UPPER (NVL (p_renew_no, a.renew_no))
               AND a.endt_yy LIKE UPPER (NVL (p_endt_yy, a.endt_yy))
               AND a.endt_seq_no LIKE
                                    UPPER (NVL (p_endt_seq_no, a.endt_seq_no))
               AND a.dist_no LIKE UPPER (NVL (p_dist_no, a.dist_no))
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
          ORDER BY line_cd ASC,
                   subline_cd ASC,
                   iss_cd ASC,
                   issue_yy DESC,
                   pol_seq_no ASC,
                   endt_iss_cd ASC,
                   endt_yy DESC,
                   endt_seq_no ASC,
                   dist_no ASC)
      LOOP
         v_pol_dist.policy_id := i.policy_id;
         v_pol_dist.line_cd := i.line_cd;
         v_pol_dist.subline_cd := i.subline_cd;
         v_pol_dist.iss_cd := i.iss_cd;
         v_pol_dist.issue_yy := i.issue_yy;
         v_pol_dist.pol_seq_no := i.pol_seq_no;
         v_pol_dist.endt_iss_cd := i.endt_iss_cd;
         v_pol_dist.endt_yy := i.endt_yy;
         v_pol_dist.endt_seq_no := i.endt_seq_no;
         v_pol_dist.renew_no := i.renew_no;
         v_pol_dist.par_id := i.par_id;
         v_pol_dist.pol_flag := i.pol_flag;
         v_pol_dist.assd_no := i.assd_no;
         v_pol_dist.assd_name := i.assd_name;
         v_pol_dist.acct_ent_date := i.acct_ent_date;
         v_pol_dist.spld_flag := i.spld_flag;
         v_pol_dist.pack_pol_flag := i.pack_pol_flag;
         v_pol_dist.dist_flag := i.dist_flag;
         v_pol_dist.dist_no := i.dist_no;
         v_pol_dist.eff_date := i.eff_date;
         v_pol_dist.expiry_date := i.expiry_date;
         v_pol_dist.negate_date := i.negate_date;
         v_pol_dist.dist_type := i.dist_type;
         v_pol_dist.acct_neg_date := i.acct_neg_date;
         v_pol_dist.par_type := i.par_type;
         v_pol_dist.policy_no := i.policy_no;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;
   END get_pol_dist_v1_for_peril_dist;

   /**
   ** Created by:      Tonio
   ** Date Created:    July 22, 2011
   ** Reference by:    GIUWS013 - One Risk Dist
   ** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
   **
   **/
   
   FUNCTION get_pol_dist_v1_one_risk_dist (
      p_line_cd       gipi_polbasic_pol_dist_v1.line_cd%TYPE,
      p_subline_cd    gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic_pol_dist_v1.renew_no%TYPE,
      p_endt_yy       gipi_polbasic_pol_dist_v1.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_dist_no       gipi_polbasic_pol_dist_v1.dist_no%TYPE,
	  p_user_id       giis_users.user_id%type
   )
      RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
   AS
      v_pol_dist   gipi_polbasic_pol_dist_v1_type;
   BEGIN
   
	IF														--[START] Optimized by MJ 11/27/2012
	  p_line_cd IS NULL AND
      p_subline_cd IS NULL AND
      p_iss_cd IS NULL AND
      p_issue_yy IS NULL AND
      p_pol_seq_no IS NULL AND
      p_renew_no IS NULL AND
      p_endt_yy IS NULL AND
      p_endt_seq_no IS NULL AND
      p_assd_name IS NULL AND
      p_dist_no IS NULL
	THEN
      FOR i IN (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                       a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                       a.assd_no, b.assd_name, c.pack_pol_flag,
                       a.acct_ent_date, a.spld_flag, d.dist_flag, a.dist_no,
                       a.eff_date, a.expiry_date, a.negate_date, a.dist_type,
                       a.acct_neg_date, a.par_type,
                          a.line_cd
					   || '-'
					   || a.subline_cd
					   || '-'
					   || a.iss_cd
					   || '-'
					   || LTRIM(TO_CHAR (a.issue_yy, '09'))
					   || '-'
					   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
					   || '-'
					   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added renew_no by christian 01/04/13
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.endt_iss_cd
                       || '-'
                       || TO_CHAR (a.endt_yy, '09')
                       || '-'
                       || TO_CHAR (a.endt_seq_no, '0999999') endt_no
                  FROM gipi_polbasic_pol_dist_v1 a,
                       giis_assured b,
                       gipi_polbasic c,
                       giuw_pol_dist d
           WHERE a.policy_id = d.policy_id 
             AND a.dist_flag <> 3 -- andrew 09.24.2012
						 AND a.dist_no = d.dist_no
						 AND a.policy_id = c.policy_id
						 AND b.assd_no = a.assd_no
				AND check_user_per_line2 (a.line_cd,   --added by steven 11.12.2012
                                     a.iss_cd, 'GIUWS013', p_user_id) = 1 --change module id christian 03/12/2013
				AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIUWS013', p_user_id) = 1							 
                      ORDER BY line_cd ASC,
                               subline_cd ASC,
                               iss_cd ASC,
                               issue_yy DESC,
                               pol_seq_no ASC,
                               endt_iss_cd ASC,
                               endt_yy DESC,
                               endt_seq_no ASC,
                               dist_no ASC
              )
      LOOP
         v_pol_dist.policy_id := i.policy_id;
         v_pol_dist.line_cd := i.line_cd;
         v_pol_dist.subline_cd := i.subline_cd;
         v_pol_dist.iss_cd := i.iss_cd;
         v_pol_dist.issue_yy := i.issue_yy;
         v_pol_dist.pol_seq_no := i.pol_seq_no;
         v_pol_dist.endt_iss_cd := i.endt_iss_cd;
         v_pol_dist.endt_yy := i.endt_yy;
         v_pol_dist.endt_seq_no := i.endt_seq_no;
         v_pol_dist.renew_no := i.renew_no;
         v_pol_dist.par_id := i.par_id;
         v_pol_dist.pol_flag := i.pol_flag;
         v_pol_dist.assd_no := i.assd_no;
         v_pol_dist.assd_name := i.assd_name;
         v_pol_dist.acct_ent_date := i.acct_ent_date;
         v_pol_dist.spld_flag := i.spld_flag;
         v_pol_dist.pack_pol_flag := i.pack_pol_flag;
         v_pol_dist.dist_flag := i.dist_flag;
         v_pol_dist.dist_no := i.dist_no;
         v_pol_dist.eff_date := i.eff_date;
         v_pol_dist.expiry_date := i.expiry_date;
         v_pol_dist.negate_date := i.negate_date;
         v_pol_dist.dist_type := i.dist_type;
         v_pol_dist.acct_neg_date := i.acct_neg_date;
         v_pol_dist.par_type := i.par_type;
         v_pol_dist.policy_no := i.policy_no;

         FOR c1 IN (SELECT batch_id
                      FROM giuw_pol_dist
                     WHERE policy_id = i.policy_id AND dist_no = i.dist_no)
         LOOP
            v_pol_dist.batch_id := c1.batch_id;
            EXIT;
         END LOOP;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;

	  
	ELSE
      FOR i IN (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                       a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                       a.assd_no, b.assd_name, c.pack_pol_flag,
                       a.acct_ent_date, a.spld_flag, d.dist_flag, a.dist_no,
                       a.eff_date, a.expiry_date, a.negate_date, a.dist_type,
                       a.acct_neg_date, a.par_type,
                          a.line_cd
					   || '-'
					   || a.subline_cd
					   || '-'
					   || a.iss_cd
					   || '-'
					   || LTRIM(TO_CHAR (a.issue_yy, '09'))
					   || '-'
					   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
					   || '-'
					   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added renew_no by christian 01/04/13
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.endt_iss_cd
                       || '-'
                       || TO_CHAR (a.endt_yy, '09')
                       || '-'
                       || TO_CHAR (a.endt_seq_no, '0999999') endt_no
                  FROM gipi_polbasic_pol_dist_v1 a,
                       giis_assured b,
                       gipi_polbasic c,
                       giuw_pol_dist d
           WHERE a.policy_id = d.policy_id 
             AND a.dist_flag <> 3 -- andrew 09.24.2012
						 AND a.dist_no = d.dist_no
						 AND a.policy_id = c.policy_id
						 AND b.assd_no = a.assd_no
						 AND A.line_cd     LIKE UPPER(NVL (p_line_cd,    A.line_cd))
                      AND A.iss_cd      LIKE UPPER(NVL (p_iss_cd,     A.iss_cd))
                      AND A.subline_cd  LIKE UPPER(NVL (p_subline_cd, A.subline_cd))
                      AND A.issue_yy    LIKE UPPER(NVL (p_issue_yy,   A.issue_yy))
                      AND A.pol_seq_no  LIKE UPPER(NVL (p_pol_seq_no, A.pol_seq_no))
                      AND A.renew_no    LIKE UPPER(NVL (p_renew_no,   A.renew_no))
                      AND A.endt_yy     LIKE UPPER(NVL (p_endt_yy,    A.endt_yy))
                      AND A.endt_seq_no LIKE UPPER(NVL (p_endt_seq_no,A.endt_seq_no))
                      AND A.dist_no     LIKE UPPER(NVL (p_dist_no,    A.dist_no))
                      AND UPPER (NVL (assd_name, '*')) LIKE UPPER (NVL (p_assd_name,DECODE (assd_name, NULL, '*', assd_name)))
					  AND check_user_per_line2 (a.line_cd,   --added by steven 11.12.2012
                                     a.iss_cd, 'GIUWS013',p_user_id) = 1
					  AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIUWS013',p_user_id) = 1						  
                      ORDER BY line_cd ASC,
                               subline_cd ASC,
                               iss_cd ASC,
                               issue_yy DESC,
                               pol_seq_no ASC,
                               endt_iss_cd ASC,
                               endt_yy DESC,
                               endt_seq_no ASC,
                               dist_no ASC
              )
      LOOP
         v_pol_dist.policy_id := i.policy_id;
         v_pol_dist.line_cd := i.line_cd;
         v_pol_dist.subline_cd := i.subline_cd;
         v_pol_dist.iss_cd := i.iss_cd;
         v_pol_dist.issue_yy := i.issue_yy;
         v_pol_dist.pol_seq_no := i.pol_seq_no;
         v_pol_dist.endt_iss_cd := i.endt_iss_cd;
         v_pol_dist.endt_yy := i.endt_yy;
         v_pol_dist.endt_seq_no := i.endt_seq_no;
         v_pol_dist.renew_no := i.renew_no;
         v_pol_dist.par_id := i.par_id;
         v_pol_dist.pol_flag := i.pol_flag;
         v_pol_dist.assd_no := i.assd_no;
         v_pol_dist.assd_name := i.assd_name;
         v_pol_dist.acct_ent_date := i.acct_ent_date;
         v_pol_dist.spld_flag := i.spld_flag;
         v_pol_dist.pack_pol_flag := i.pack_pol_flag;
         v_pol_dist.dist_flag := i.dist_flag;
         v_pol_dist.dist_no := i.dist_no;
         v_pol_dist.eff_date := i.eff_date;
         v_pol_dist.expiry_date := i.expiry_date;
         v_pol_dist.negate_date := i.negate_date;
         v_pol_dist.dist_type := i.dist_type;
         v_pol_dist.acct_neg_date := i.acct_neg_date;
         v_pol_dist.par_type := i.par_type;
         v_pol_dist.policy_no := i.policy_no;

         FOR c1 IN (SELECT batch_id
                      FROM giuw_pol_dist
                     WHERE policy_id = i.policy_id AND dist_no = i.dist_no)
         LOOP
            v_pol_dist.batch_id := c1.batch_id;
            EXIT;
         END LOOP;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;
	END IF;  													--[END] Optimized by MJ 11/27/2012
	
   END get_pol_dist_v1_one_risk_dist;
   
/**
** Created by:      Veronica V. Raymundo
** Date Created:    July 28, 2011
** Reference by:    GIUWS016 - Distribution by TSI/Prem (Group)
** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
**
**/
   FUNCTION get_pol_dist_v1_tsi_prem_distr (
      p_module_id     giis_user_grp_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic_pol_dist_v1.line_cd%TYPE,
      p_subline_cd    gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic_pol_dist_v1.renew_no%TYPE,
      p_endt_yy       gipi_polbasic_pol_dist_v1.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_dist_no       gipi_polbasic_pol_dist_v1.dist_no%TYPE
   )
      RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
   AS
      v_pol_dist   gipi_polbasic_pol_dist_v1_type;
   BEGIN
      FOR i IN
         (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag, a.acct_ent_date,
                   a.spld_flag, d.dist_flag, a.dist_no, a.eff_date,
                   a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
				   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added renew_no by christian 01/04/13
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.endt_iss_cd
                   || '-'
                   || TO_CHAR (a.endt_yy, '09')
                   || '-'
                   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
              FROM gipi_polbasic_pol_dist_v1 a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d
             WHERE NVL(a.dist_flag, '1') != '3'
               AND a.line_cd || '-' || a.iss_cd IN (
                          SELECT line_cd || '-' || iss_cd
                            FROM TABLE (check_security (p_module_id,
                                                        p_user_id)
                                       ))
               AND a.assd_no = b.assd_no(+)
               AND a.policy_id = c.policy_id
               AND a.policy_id = d.policy_id
               AND a.dist_no = d.dist_no
               AND a.line_cd LIKE UPPER (NVL (p_line_cd, a.line_cd))
               AND a.iss_cd LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
               AND a.issue_yy LIKE UPPER (NVL (p_issue_yy, a.issue_yy))
               AND a.pol_seq_no LIKE UPPER (NVL (p_pol_seq_no, a.pol_seq_no))
               AND a.renew_no LIKE UPPER (NVL (p_renew_no, a.renew_no))
               AND a.endt_yy LIKE UPPER (NVL (p_endt_yy, a.endt_yy))
               AND a.endt_seq_no LIKE
                                    UPPER (NVL (p_endt_seq_no, a.endt_seq_no))
               AND a.dist_no LIKE UPPER (NVL (p_dist_no, a.dist_no))
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
          ORDER BY line_cd ASC,
                   subline_cd ASC,
                   iss_cd ASC,
                   issue_yy DESC,
                   pol_seq_no ASC,
                   endt_iss_cd ASC,
                   endt_yy DESC,
                   endt_seq_no ASC,
                   dist_no ASC)
      LOOP
         v_pol_dist.policy_id       := i.policy_id;
         v_pol_dist.line_cd         := i.line_cd;
         v_pol_dist.subline_cd      := i.subline_cd;
         v_pol_dist.iss_cd          := i.iss_cd;
         v_pol_dist.issue_yy        := i.issue_yy;
         v_pol_dist.pol_seq_no      := i.pol_seq_no;
         v_pol_dist.endt_iss_cd     := i.endt_iss_cd;
         v_pol_dist.endt_yy         := i.endt_yy;
         v_pol_dist.endt_seq_no     := i.endt_seq_no;
         v_pol_dist.renew_no        := i.renew_no;
         v_pol_dist.par_id          := i.par_id;
         v_pol_dist.pol_flag        := i.pol_flag;
         v_pol_dist.assd_no         := i.assd_no;
         v_pol_dist.assd_name       := i.assd_name;
         v_pol_dist.acct_ent_date   := i.acct_ent_date;
         v_pol_dist.spld_flag       := i.spld_flag;
         v_pol_dist.pack_pol_flag   := i.pack_pol_flag;
         v_pol_dist.dist_flag       := i.dist_flag;
         v_pol_dist.dist_no         := i.dist_no;
         v_pol_dist.eff_date        := i.eff_date;
         v_pol_dist.expiry_date     := i.expiry_date;
         v_pol_dist.negate_date     := i.negate_date;
         v_pol_dist.dist_type       := i.dist_type;
         v_pol_dist.acct_neg_date   := i.acct_neg_date;
         v_pol_dist.par_type        := i.par_type;
         v_pol_dist.policy_no       := i.policy_no;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;
   END get_pol_dist_v1_tsi_prem_distr;
   
/**
** Created by:      Robert John Virrey
** Date Created:    July 28, 2011
** Reference by:    GIUTS002 - Distribution Negation
** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
**
**/
--REVISED
   
   FUNCTION get_pol_dist_v1_neg_post_distr (
      p_line_cd       gipi_polbasic_pol_dist_v1.line_cd%TYPE,
      p_subline_cd    gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic_pol_dist_v1.renew_no%TYPE,
      p_endt_yy       gipi_polbasic_pol_dist_v1.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_dist_no       gipi_polbasic_pol_dist_v1.dist_no%TYPE,
	  p_user_id       giis_users.user_id%type
   )
      RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
   AS
      v_pol_dist   gipi_polbasic_pol_dist_v1_type;
   BEGIN
   
    IF p_line_cd IS NULL AND						-- [START] Optimized by MJ 11/27/2012
	   p_subline_cd IS NULL AND
       p_iss_cd IS NULL AND
       p_issue_yy IS NULL AND
       p_pol_seq_no IS NULL AND
       p_renew_no IS NULL AND
       p_endt_yy IS NULL AND
       p_endt_seq_no IS NULL AND
       p_assd_name IS NULL AND
       p_dist_no IS NULL	
	THEN
      FOR i IN
           (SELECT distinct a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag,
                   a.acct_ent_date, a.spld_flag, d.dist_flag, a.dist_no,
                   a.eff_date, a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no,--added by christian 01/03/13
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.endt_iss_cd
                   || '-'
                   || TO_CHAR (a.endt_yy, '09')
                   || '-'
                   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
              FROM gipi_polbasic_pol_dist_v a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d,
                   giuw_policyds e
             WHERE  a.assd_no = b.assd_no(+)
                    AND a.policy_id = c.policy_id
                    AND a.policy_id = d.policy_id
                    AND a.dist_no = d.dist_no
                    AND a.dist_no = e.dist_no
				/* removed by jdiago 08.15.2014 : will be placed in xml for optimization
                AND check_user_per_line2 (a.line_cd,   --added by steven 11.12.2012
                                     a.iss_cd, 'GIUTS002',p_user_id) = 1
				AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIUTS002',p_user_id) = 1
                */	
          ORDER BY line_cd ASC,
                   subline_cd ASC,
                   iss_cd ASC,
                   issue_yy DESC,
                   pol_seq_no ASC,
                   endt_iss_cd ASC,
                   endt_yy DESC,
                   endt_seq_no ASC,
                   a.dist_no ASC)
      LOOP
         v_pol_dist.policy_id       := i.policy_id;
         v_pol_dist.line_cd         := i.line_cd;
         v_pol_dist.subline_cd      := i.subline_cd;
         v_pol_dist.iss_cd          := i.iss_cd;
         v_pol_dist.issue_yy        := i.issue_yy;
         v_pol_dist.pol_seq_no      := i.pol_seq_no;
         v_pol_dist.endt_iss_cd     := i.endt_iss_cd;
         v_pol_dist.endt_yy         := i.endt_yy;
         v_pol_dist.endt_seq_no     := i.endt_seq_no;
         v_pol_dist.renew_no        := i.renew_no;
         v_pol_dist.par_id          := i.par_id;
         v_pol_dist.pol_flag        := i.pol_flag;
         v_pol_dist.assd_no         := i.assd_no;
         v_pol_dist.assd_name       := i.assd_name;
         v_pol_dist.acct_ent_date   := i.acct_ent_date;
         v_pol_dist.spld_flag       := i.spld_flag;
         v_pol_dist.pack_pol_flag   := i.pack_pol_flag;
         v_pol_dist.dist_flag       := i.dist_flag;
         v_pol_dist.dist_no         := i.dist_no;
         v_pol_dist.eff_date        := i.eff_date;
         v_pol_dist.expiry_date     := i.expiry_date;
         v_pol_dist.negate_date     := i.negate_date;
         v_pol_dist.dist_type       := i.dist_type;
         v_pol_dist.acct_neg_date   := i.acct_neg_date;
         v_pol_dist.par_type        := i.par_type;
         v_pol_dist.policy_no       := i.policy_no;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;
	
	ELSE
	  FOR i IN
           (SELECT distinct a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag,
                   a.acct_ent_date, a.spld_flag, d.dist_flag, a.dist_no,
                   a.eff_date, a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added by christian 01/03/13
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.endt_iss_cd
                   || '-'
                   || TO_CHAR (a.endt_yy, '09')
                   || '-'
                   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
              FROM gipi_polbasic_pol_dist_v a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d,
                   giuw_policyds e
             WHERE  a.assd_no = b.assd_no(+)
                    AND a.policy_id = c.policy_id
                    AND a.policy_id = d.policy_id
                    AND a.dist_no = d.dist_no
                    AND a.dist_no = e.dist_no
               AND a.line_cd LIKE UPPER (NVL (p_line_cd, a.line_cd))
               AND a.iss_cd LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
               AND a.issue_yy LIKE UPPER (NVL (p_issue_yy, a.issue_yy))
               AND a.pol_seq_no LIKE UPPER (NVL (p_pol_seq_no, a.pol_seq_no))
               AND a.renew_no LIKE UPPER (NVL (p_renew_no, a.renew_no))
               AND a.endt_yy LIKE UPPER (NVL (p_endt_yy, a.endt_yy))
               AND a.endt_seq_no LIKE
                                    UPPER (NVL (p_endt_seq_no, a.endt_seq_no))
               AND a.dist_no LIKE UPPER (NVL (p_dist_no, a.dist_no))
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
				/*AND check_user_per_line2 (a.line_cd,   --added by steven 11.12.2012
                                     a.iss_cd, 'GIUTS002',p_user_id) = 1
				AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIUTS002',p_user_id) = 1*/			
          ORDER BY line_cd ASC,
                   subline_cd ASC,
                   iss_cd ASC,
                   issue_yy DESC,
                   pol_seq_no ASC,
                   endt_iss_cd ASC,
                   endt_yy DESC,
                   endt_seq_no ASC,
                   a.dist_no ASC)
      LOOP
         v_pol_dist.policy_id       := i.policy_id;
         v_pol_dist.line_cd         := i.line_cd;
         v_pol_dist.subline_cd      := i.subline_cd;
         v_pol_dist.iss_cd          := i.iss_cd;
         v_pol_dist.issue_yy        := i.issue_yy;
         v_pol_dist.pol_seq_no      := i.pol_seq_no;
         v_pol_dist.endt_iss_cd     := i.endt_iss_cd;
         v_pol_dist.endt_yy         := i.endt_yy;
         v_pol_dist.endt_seq_no     := i.endt_seq_no;
         v_pol_dist.renew_no        := i.renew_no;
         v_pol_dist.par_id          := i.par_id;
         v_pol_dist.pol_flag        := i.pol_flag;
         v_pol_dist.assd_no         := i.assd_no;
         v_pol_dist.assd_name       := i.assd_name;
         v_pol_dist.acct_ent_date   := i.acct_ent_date;
         v_pol_dist.spld_flag       := i.spld_flag;
         v_pol_dist.pack_pol_flag   := i.pack_pol_flag;
         v_pol_dist.dist_flag       := i.dist_flag;
         v_pol_dist.dist_no         := i.dist_no;
         v_pol_dist.eff_date        := i.eff_date;
         v_pol_dist.expiry_date     := i.expiry_date;
         v_pol_dist.negate_date     := i.negate_date;
         v_pol_dist.dist_type       := i.dist_type;
         v_pol_dist.acct_neg_date   := i.acct_neg_date;
         v_pol_dist.par_type        := i.par_type;
         v_pol_dist.policy_no       := i.policy_no;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
         PIPE ROW (v_pol_dist);
      END LOOP;
	
	END IF;									-- [END] Optimized by MJ 11/27/2012
	  
   END get_pol_dist_v1_neg_post_distr;
      
       FUNCTION security(p_module_id VARCHAR2,
                      p_line_cd   VARCHAR2,
                      p_iss_cd    VARCHAR2,
                      p_user_id   VARCHAR2) 
    RETURN GIPI_PARLIST_PKG.parlist_security_tab PIPELINED IS
      v_where    VARCHAR2(32767);
      var        VARCHAR2(32767); 
      v_security              GIPI_PARLIST_PKG.parlist_security_type;
    BEGIN
        FOR line in (
      SELECT d.line_cd, B.iss_cd
        FROM GIIS_USERS        a
           , GIIS_USER_ISS_CD  b
           , GIIS_MODULES_TRAN c
               , GIIS_USER_LINE    d
       WHERE 1=1
         AND a.user_id   = b.userid
         AND a.user_id   = p_user_id
         AND b.tran_cd   = c.tran_cd
         AND c.module_id = p_module_id
           AND d.userid    = b.userid
           AND d.iss_cd    = b.iss_cd
           AND d.tran_cd   = b.tran_cd
           AND d.line_cd   = NVL(p_line_cd,d.line_cd)
           AND b.iss_cd    = NVL(p_iss_cd,b.iss_cd)
      UNION
      SELECT d.line_cd, b.iss_cd
        FROM GIIS_USERS          a
            , GIIS_USER_GRP_DTL  b
            , GIIS_MODULES_TRAN  c
                , GIIS_USER_GRP_LINE d
       WHERE 1=1
         AND a.user_id   = p_user_id
         AND a.user_grp  = b.user_grp
         AND b.tran_cd   = c.tran_cd
         AND c.module_id = p_module_id
         AND d.user_grp = b.user_grp
         AND d.iss_cd   = b.iss_cd
         AND d.tran_cd  = b.tran_cd
         AND d.line_cd   = NVL(p_line_cd,d.line_cd)
         AND b.iss_cd    = NVL(p_iss_cd,b.iss_cd))
      LOOP
        v_security.line_cd :=   line.line_cd;
        v_security.iss_cd  :=   line.iss_cd;
                
        PIPE ROW(v_security); 
      END LOOP;
    END;

   /**
   ** Created by:      Niknok 
   ** Date Created:    July 28, 2011 
   ** Reference by:    GIUWS017 - Dist by  TSI/Prem (Peril) 
   ** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
   **
   **/
   FUNCTION get_v1_dist_by_tsi_prem_peril(
        p_module_id     VARCHAR2,
        p_line_cd       VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_user_id       VARCHAR2,
        p_endt_iss_cd   VARCHAR2,
        p_endt_yy       VARCHAR2)
   RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
   AS
      v_pol_dist   gipi_polbasic_pol_dist_v1_type;
   BEGIN
      FOR i IN
         (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag, a.acct_ent_date,
                   a.spld_flag, d.dist_flag, a.dist_no, a.eff_date,
                   a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
				   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added renew_no by christian 01/04/13
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.endt_iss_cd
                   || '-'
                   || TO_CHAR (a.endt_yy, '09')
                   || '-'
                   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
              FROM gipi_polbasic_pol_dist_v1 a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d
             WHERE NVL (a.dist_flag, '1') != '3'
               AND a.line_cd || '-' || a.iss_cd IN (
                          SELECT line_cd || '-' || iss_cd
                            FROM TABLE (GIPI_POLBASIC_POL_DIST_V1_PKG.security(p_module_id, p_line_cd, p_iss_cd, p_user_id)
                                       ))
               AND a.assd_no = b.assd_no(+)
               AND a.policy_id = c.policy_id
               AND a.policy_id = d.policy_id
               AND a.dist_no = d.dist_no
             ORDER BY line_cd ASC,
                   subline_cd ASC,
                   iss_cd ASC,
                   issue_yy DESC,
                   pol_seq_no ASC,
                   endt_iss_cd ASC,
                   endt_yy DESC,
                   endt_seq_no ASC,
                   dist_no ASC)
      LOOP
         v_pol_dist.policy_id := i.policy_id;
         v_pol_dist.line_cd := i.line_cd;
         v_pol_dist.subline_cd := i.subline_cd;
         v_pol_dist.iss_cd := i.iss_cd;
         v_pol_dist.issue_yy := i.issue_yy;
         v_pol_dist.pol_seq_no := i.pol_seq_no;
         v_pol_dist.endt_iss_cd := i.endt_iss_cd;
         v_pol_dist.endt_yy := i.endt_yy;
         v_pol_dist.endt_seq_no := i.endt_seq_no;
         v_pol_dist.renew_no := i.renew_no;
         v_pol_dist.par_id := i.par_id;
         v_pol_dist.pol_flag := i.pol_flag;
         v_pol_dist.assd_no := i.assd_no;
         v_pol_dist.assd_name := i.assd_name;
         v_pol_dist.acct_ent_date := i.acct_ent_date;
         v_pol_dist.spld_flag := i.spld_flag;
         v_pol_dist.pack_pol_flag := i.pack_pol_flag;
         v_pol_dist.dist_flag := i.dist_flag;
         v_pol_dist.dist_no := i.dist_no;
         v_pol_dist.eff_date := i.eff_date;
         v_pol_dist.expiry_date := i.expiry_date;
         v_pol_dist.negate_date := i.negate_date;
         v_pol_dist.dist_type := i.dist_type;
         v_pol_dist.acct_neg_date := i.acct_neg_date;
         v_pol_dist.par_type := i.par_type;
         v_pol_dist.policy_no := i.policy_no;

         IF (i.endt_seq_no IS NOT NULL AND i.endt_seq_no != 0)
         THEN
            v_pol_dist.endt_no := i.endt_no;
         ELSE
            v_pol_dist.endt_no := '';
         END IF;

         chk_char_ref_codes (i.dist_flag,
                             v_pol_dist.mean_dist_flag,
                             'GIUW_POL_DIST.DIST_FLAG'
                            );
                            
        BEGIN
            FOR x IN (SELECT multi_booking_mm, multi_booking_yy
                        FROM GIPI_INVOICE
                       WHERE takeup_seq_no = (SELECT NVL(takeup_seq_no,1)
                                                FROM giuw_pol_dist
                                               WHERE dist_no = v_pol_dist.dist_no
                                                 AND policy_id = v_pol_dist.policy_id)
                         AND item_grp = (SELECT NVL(item_grp,1)
                                           FROM giuw_pol_dist
                                          WHERE dist_no = v_pol_dist.dist_no
                                            AND policy_id = v_pol_dist.policy_id)
                         AND policy_id = v_pol_dist.policy_id)
            LOOP
                v_pol_dist.multi_booking_yy := x.multi_booking_yy;
                v_pol_dist.multi_booking_mm := x.multi_booking_mm;
            END LOOP;
        END;       
                            
         IF p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN                   
            IF i.endt_seq_no > 0 THEN
                PIPE ROW (v_pol_dist);
            END IF;
         ELSE
            PIPE ROW (v_pol_dist);
         END IF;
      END LOOP;
   END get_v1_dist_by_tsi_prem_peril;
   
   FUNCTION get_giuws012_currency_desc(p_policy_id         GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                        p_dist_no           GIUW_WPERILDS.dist_no%TYPE,
                                        p_dist_seq_no       GIUW_WPERILDS.dist_seq_no%TYPE)
      RETURN currency_tab PIPELINED
   IS
      v_item_grp		giuw_wpolicyds.item_grp%TYPE;
      v_currency        currency_type;
   BEGIN
      FOR a1 in (SELECT 		item_grp
                 FROM 		giuw_wpolicyds
                WHERE 		dist_no = p_dist_no
                  AND 		dist_seq_no = p_dist_seq_no)
    LOOP                
   	    v_item_grp := a1.item_grp;
   	END LOOP;   
        FOR a2 IN (SELECT 		currency_cd
                     FROM 		gipi_invoice
                    WHERE 		item_grp = v_item_grp
                      AND 		policy_id = p_policy_id)
        LOOP
            v_currency.currency_cd := a2.currency_cd;
        END LOOP;   

        FOR A IN (SELECT 		currency_desc
                    FROM 		giis_currency
                   WHERE    main_currency_cd = v_currency.currency_cd)
        LOOP
              v_currency.currency_desc := a.currency_desc;
        END LOOP;
        
        PIPE ROW(v_currency);
   END get_giuws012_currency_desc;

    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 12, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    ** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
    **
    **/
    FUNCTION get_v1_pop_missing_dist_rec(
        p_module_id     VARCHAR2,
        p_line_cd       VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_user_id       VARCHAR2,
        p_endt_iss_cd   VARCHAR2,
        p_endt_yy       VARCHAR2,
        p_endt_seq_no   VARCHAR2)
    RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
    AS
      v_pol_dist    gipi_polbasic_pol_dist_v1_type;
      TYPE cur_typ IS REF CURSOR;
      c cur_typ;
      stmt_str      VARCHAR2(32000);
      v_where       VARCHAR2(32000) := ' AND ';
    BEGIN
          IF p_iss_cd IS NULL AND p_line_cd IS NOT NULL THEN
          v_where := v_where || ' a.line_cd = DECODE(check_user_per_line('''||p_line_cd||''','''||p_iss_cd||''','''||p_module_id||'''),1,'''||p_line_cd||''',NULL) '|| 
                           '  AND a.iss_cd = DECODE(check_user_per_123123iss_cd(a.line_cd,a.iss_cd,'''||p_module_id||'''),1,a.iss_cd,NULL) ';
          ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NULL THEN  	               
          v_where := v_where || ' a.line_cd = DECODE(check_user_per_line(a.line_cd,a.iss_cd,'''||p_module_id||'''),1,a.line_cd,NULL) '|| 
                           '  AND a.iss_cd = DECODE(check_user_per_iss_cd('''||p_line_cd||''','''||p_iss_cd||''','''||p_module_id||'''),1,'''||p_iss_cd||''',NULL) ';
          ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NOT NULL THEN  	               
          v_where := v_where || ' a.line_cd = DECODE(check_user_per_line('''||p_line_cd||''','''||p_iss_cd||''','''||p_module_id||'''),1,a.line_cd,NULL) '|| 
                           '  AND a.iss_cd = DECODE(check_user_per_iss_cd('''||p_line_cd||''','''||p_iss_cd||''','''||p_module_id||'''),1,a.iss_cd,NULL) ';
          ELSIF p_iss_cd IS NULL AND p_line_cd IS NULL THEN  	               
          v_where := v_where || ' a.line_cd = DECODE(check_user_per_line(a.line_cd,a.iss_cd,'''||p_module_id||'''),1,a.line_cd,NULL) '|| 
                           '  AND a.iss_cd = DECODE(check_user_per_iss_cd(a.line_cd,a.iss_cd,'''||p_module_id||'''),1,a.iss_cd,NULL) ';
          END IF;

          IF p_endt_iss_cd IS NOT NULL THEN
            IF v_where IS NOT NULL THEN
              v_where := v_where || ' AND ';
            END IF;
                  v_where := v_where ||' a.endt_seq_no > 0 AND a.endt_iss_cd = '''||p_endt_iss_cd||'''';  	 
          END IF;
          
          IF p_endt_yy IS NOT NULL THEN
            IF v_where IS NOT NULL THEN
              v_where := v_where || ' AND ';
            END IF;
                  v_where := v_where || 'a.endt_seq_no > 0 AND a.endt_yy = '||p_endt_yy;
          END IF;
          IF p_endt_seq_no IS NOT NULL AND p_endt_seq_no != 0 THEN
            IF v_where IS NOT NULL THEN
              v_where := v_where || ' AND ';
            END IF;
                  v_where := v_where || 'a.endt_seq_no > 0 AND a.endt_seq_no = '||p_endt_seq_no;
          END IF;  

        stmt_str := 'SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.issue_yy, a.pol_seq_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.renew_no, a.par_id, a.pol_flag,
                   a.assd_no, b.assd_name, c.pack_pol_flag, a.acct_ent_date,
                   a.spld_flag, d.dist_flag, a.dist_no, a.eff_date,
                   a.expiry_date, a.negate_date, a.dist_type,
                   a.acct_neg_date, a.par_type,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.issue_yy, ''09''))
                   || '-'
                   || LTRIM(TO_CHAR (a.pol_seq_no, ''0999999''))
				   || '-'
                   || LTRIM(TO_CHAR (a.renew_no, ''09'')) policy_no, 
                      a.line_cd
                   || ''-''
                   || a.subline_cd
                   || ''-''
                   || a.endt_iss_cd
                   || ''-''
                   || TO_CHAR (a.endt_yy, ''09'')
                   || ''-''
                   || TO_CHAR (a.endt_seq_no, ''0999999'') endt_no
              FROM gipi_polbasic_pol_dist_v1 a,
                   giis_assured b,
                   gipi_polbasic c,
                   giuw_pol_dist d
             WHERE a.assd_no = b.assd_no(+)
               AND a.policy_id = c.policy_id
               AND a.policy_id = d.policy_id
               AND a.dist_no = d.dist_no
               '||v_where||'
               AND a.dist_flag <> 2
             ORDER BY line_cd asc, 
                    subline_cd asc, 
                    iss_cd asc, 
                    issue_yy desc,  
                    pol_seq_no  asc, 
                    endt_iss_cd asc, 
                    endt_yy desc, 
                    endt_seq_no asc';
        stmt_str := stmt_str;            
        OPEN c FOR stmt_str;
        LOOP
            FETCH c INTO v_pol_dist.policy_id, v_pol_dist.line_cd, v_pol_dist.subline_cd, v_pol_dist.iss_cd,
                   v_pol_dist.issue_yy, v_pol_dist.pol_seq_no, v_pol_dist.endt_iss_cd, v_pol_dist.endt_yy,
                   v_pol_dist.endt_seq_no, v_pol_dist.renew_no, v_pol_dist.par_id, v_pol_dist.pol_flag,
                   v_pol_dist.assd_no, v_pol_dist.assd_name, v_pol_dist.pack_pol_flag, v_pol_dist.acct_ent_date,
                   v_pol_dist.spld_flag, v_pol_dist.dist_flag, v_pol_dist.dist_no, v_pol_dist.eff_date,
                   v_pol_dist.expiry_date, v_pol_dist.negate_date, v_pol_dist.dist_type,
                   v_pol_dist.acct_neg_date, v_pol_dist.par_type, v_pol_dist.policy_no, v_pol_dist.endt_no;
            EXIT WHEN c%NOTFOUND;
            IF (v_pol_dist.endt_seq_no IS NOT NULL AND v_pol_dist.endt_seq_no != 0) THEN
                v_pol_dist.endt_no := v_pol_dist.endt_no;
            ELSE
                v_pol_dist.endt_no := '';
            END IF;
            chk_char_ref_codes (v_pol_dist.dist_flag,
                                v_pol_dist.mean_dist_flag,
                                'GIUW_POL_DIST.DIST_FLAG'
                                );
            giuw_pol_dist_pkg.VALIDATE_EXISTING_DIST(v_pol_dist.dist_no, v_pol_dist.policy_id, v_pol_dist.msg_alert);                    
            PIPE ROW(v_pol_dist);   
        END LOOP;
        CLOSE c;
        RETURN;
    END get_v1_pop_missing_dist_rec;

    PROCEDURE DELETE_DIST_WORKING_TABLES(
        p_dist_no   giuw_pol_dist.dist_no%TYPE,
        p_ri_sw     VARCHAR2
        ) IS
      v_dist_no			giuw_pol_dist.dist_no%TYPE;
    BEGIN
      v_dist_no := p_dist_no;
      DELETE giuw_perilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_perilds
       WHERE dist_no = v_dist_no;
      DELETE giuw_itemperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_itemperilds
       WHERE dist_no = v_dist_no;
      DELETE giuw_itemds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_itemds
       WHERE dist_no = v_dist_no;
      IF p_ri_sw = 'N' THEN 
      DELETE giuw_policyds_dtl
       WHERE dist_no = v_dist_no;
      FOR c1 IN (SELECT frps_yy, frps_seq_no
                   FROM giri_distfrps
                  WHERE dist_no = v_dist_no)
      LOOP
        FOR c2 IN (SELECT fnl_binder_id
                     FROM giri_frps_ri
                    WHERE frps_yy     = c1.frps_yy 
                      AND frps_seq_no = c1.frps_seq_no) 
        LOOP
          DELETE giri_binder_peril
           WHERE fnl_binder_id = c2.fnl_binder_id; 
          DELETE giri_binder
           WHERE fnl_binder_id = c2.fnl_binder_id;
        END LOOP;
        DELETE giri_frperil
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no;
        DELETE giri_frps_ri
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no;
      END LOOP;
      DELETE giri_distfrps
       WHERE dist_no = v_dist_no;
      DELETE giuw_policyds
       WHERE dist_no = v_dist_no;
       END IF;
    END;

    /* Create default distribution records in all distribution tables namely:
    ** GIUW_POLICYDS, GIUW_POLICYDS_DTL, GIUW_ITEMDS, GIUW_ITEMDS_DTL,
    ** GIUW_ITEMPERILDS, GIUW_ITEMPERILDS_DTL, GIUW_PERILDS and GIUW_PERILDS_DTL.
    ** The default records inserted to the detail tables were driven from the default
    ** distribution tables:  GIIS_DEFAULT_DIST, GIIS_DEFAULT_DIST_GROUP and 
    ** GIIS_DEFAULT_DIST_PERIL. */
    PROCEDURE  CREATE_POLICY_DIST_RECS
              (p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
               p_policy_id     IN gipi_polbasic.policy_id%TYPE,
               p_line_cd       IN gipi_polbasic.line_cd%TYPE,
               p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
               p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
               p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE,
               p_ri_sw         IN VARCHAR2) IS

      v_line_cd			        gipi_polbasic.line_cd%TYPE;
      v_subline_cd			    gipi_polbasic.subline_cd%TYPE;
      v_dist_seq_no             giuw_policyds.dist_seq_no%TYPE := 0;
      --rg_id				        RECORDGROUP;
      rg_name      			    VARCHAR2(20) := 'DFLT_DIST_VALUES';
      v_exist			        VARCHAR2(1);
      v_errors			        NUMBER;
      v_default_no    		    giis_default_dist.default_no%TYPE;
      v_default_type		    giis_default_dist.default_type%TYPE;
      v_dflt_netret_pct         giis_default_dist.dflt_netret_pct%TYPE;
      v_dist_type			    giis_default_dist.dist_type%TYPE;
      v_post_flag			    VARCHAR2(1)  := 'O';
      v_package_policy_sw       VARCHAR2(1)  := 'Y';
    BEGIN
      -- initialize record group tab
      gipi_polbasic_pol_dist_v1_pkg.rg_id := gipi_polbasic_pol_dist_v1_pkg.rg_tab();
      gipi_polbasic_pol_dist_v1_pkg.rg_selection := gipi_polbasic_pol_dist_v1_pkg.rg_tab();
            
      --Get the unique ITEM_GRP to produce a unique DIST_SEQ_NO for each.
      --from records in gipi_item that has peril(s)
      FOR c1 IN (SELECT NVL(item_grp, 1) item_grp        ,
                        pack_line_cd     pack_line_cd    ,
                        pack_subline_cd  pack_subline_cd ,
                        currency_rt      currency_rt     ,
                        SUM(tsi_amt)     policy_tsi      ,
                        SUM(prem_amt)    policy_premium  ,
                        SUM(ann_tsi_amt) policy_ann_tsi
                   FROM gipi_item a
                  WHERE policy_id = p_policy_id
                    AND EXISTS (SELECT '1'
                                  FROM gipi_itmperil b
                                 WHERE b.policy_id = a.policy_id
                                   AND b.item_no   = a.item_no)                
                  GROUP BY item_grp , pack_line_cd , pack_subline_cd ,
                          currency_rt)
      LOOP
        -- If the POLICY processed is a package policy
        -- then get the true LINE_CD and true SUBLINE_CD,
        -- that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
        -- from the GIPI_ITEM table.
        -- This will be used upon inserting to certain
        -- distribution tables requiring a value for
        -- the similar field. 
        IF p_pack_pol_flag = 'N' THEN
           v_line_cd    := p_line_cd;
           v_subline_cd := p_subline_cd;
        ELSE
           v_line_cd           := c1.pack_line_cd;
           v_subline_cd        := c1.pack_subline_cd;
           v_package_policy_sw := 'Y';
        END IF;

        IF v_package_policy_sw = 'Y' THEN
           FOR c2 IN (SELECT default_no, default_type, dist_type,
                             dflt_netret_pct
                        FROM giis_default_dist
                       WHERE iss_cd     = p_iss_cd
                         AND subline_cd = v_subline_cd
                         AND line_cd    = v_line_cd)
           LOOP
             v_default_no      := c2.default_no;
             v_default_type    := c2.default_type;
             v_dist_type       := c2.dist_type;
             v_dflt_netret_pct := c2.dflt_netret_pct;
             EXIT;
           END LOOP;
           IF NVL(v_dist_type, '1') = '1' THEN
                IF gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT > 0 THEN
                    gipi_polbasic_pol_dist_v1_pkg.rg_id.TRIM(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT);
                END IF;   

                FOR rg_rec IN (SELECT a.line_cd    , a.share_cd , a.share_pct  ,  
                                      a.share_amt1 , a.peril_cd , a.share_amt2 ,  
                                      1 true_pct  
                                 FROM giis_default_dist_group a  
                                WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                  AND a.line_cd    = v_line_cd 
                                  AND a.share_cd   <> 999 
                                ORDER BY a.sequence ASC)
                LOOP
                    gipi_polbasic_pol_dist_v1_pkg.rg_id.EXTEND(1);
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).line_cd      := rg_rec.line_cd;
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).share_cd     := rg_rec.share_cd;
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).share_pct    := rg_rec.share_pct;
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).share_amt1   := rg_rec.share_amt1;
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).peril_cd     := rg_rec.peril_cd;
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).share_amt2   := rg_rec.share_amt2;
                    gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).true_pct     := rg_rec.true_pct;
                END LOOP;
               
                gipi_polbasic_pol_dist_v1_pkg.rg_count := gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT;
           END IF;
           v_package_policy_sw := 'N';
        END IF;

        /* Generate a new DIST_SEQ_NO for the new
        ** item group. */
        IF p_ri_sw =  'N' THEN
           v_dist_seq_no := v_dist_seq_no + 1;
        ELSE   
           FOR a IN (SELECT dist_seq_no
                       FROM giuw_policyds
                      WHERE dist_no = p_dist_no
                        AND item_grp = c1.item_grp)
           LOOP
             v_dist_seq_no := a.dist_seq_no;
           END LOOP;	
        END IF;   
        IF NVL(v_dist_type, '1') = '1' THEN
           v_post_flag := 'O';
           IF p_ri_sw =  'N' THEN
              GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST999
                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                  c1.item_grp    , v_line_cd         , gipi_polbasic_pol_dist_v1_pkg.rg_count          ,
                  v_default_type , c1.currency_rt    , p_policy_id);
           ELSE       	  
              GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_RI999
                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                  c1.item_grp    , v_line_cd         , rg_count          ,
                  v_default_type , c1.currency_rt    , p_policy_id); 
           END IF;       
        ELSIF v_dist_type = '2' THEN
           v_post_flag := 'P';
           GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_DIST999
                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                  c1.item_grp    , v_line_cd         , v_default_no      ,
                  v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                  p_policy_id    , p_ri_sw);
        END IF;

      END LOOP;
      IF gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT > 0 THEN
        gipi_polbasic_pol_dist_v1_pkg.rg_id.TRIM(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT);
      END IF;

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_PERILDS     - GIUW_PERILDS_DTL
      **                   GIUW_POLICYDS    - GIUW_POLICYDS_DTL
      **                   GIUW_ITEMDS      - GIUW_ITEMDS_DTL
      **                   GIUW_ITEMPERILDS - GIUW_ITEMPERILDS_DTL */
      ADJUST_NET_RET_IMPERFECTION(p_dist_no);

    END;

    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    ** Description :    create_btn when-button-pressed trigger 
    **
    **/
    PROCEDURE create_missing_dist_rec(
        p_dist_no           IN       giuw_pol_dist.dist_no%TYPE,
        p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
        p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
        p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN       GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN       GIPI_POLBASIC.iss_cd%TYPE,
        p_msg_alert         OUT      VARCHAR2
        ) IS
        v_ri_sw                 VARCHAR2(1);
        v_polds_sw              VARCHAR2(1);   --for table giuw_policyds
        v_polds_dtl_sw          VARCHAR2(1);   --for table giuw_policyds_dtl
        v_perilds_sw            VARCHAR2(1);   --for table giuw_perilds
        v_perilds_dtl_sw        VARCHAR2(1);   --for table giuw_perilds_dtl
        v_itemds_sw             VARCHAR2(1);   --for table giuw_itemds
        v_itemds_dtl_sw         VARCHAR2(1);   --for table giuw_itemds_dtl
        v_itemperilds_sw        VARCHAR2(1);   --for table giuw_itemperilds
        v_itemperilds_dtl_sw    VARCHAR2(1);   --for table giuw_itemperilds_dtl	 
        v_partial_sw            VARCHAR2(1);
    BEGIN
      v_ri_sw := 'N';
      
      --check for the correct amts on gipi_itmperil versus amts on gipi_item
      COMPARE_GIPI_ITEM_ITMPERIL(p_policy_id, p_pack_pol_flag, p_line_cd, p_msg_alert);
      IF p_msg_alert <> 'SUCCESS' THEN
        RETURN;
      END IF;
      
      --check what tables have missing records
      CHECK_MISSING_RECORDS(p_dist_no,          p_policy_id,            v_polds_sw,  v_polds_dtl_sw, 
                            v_perilds_sw,       v_perilds_dtl_sw,       v_itemds_sw, v_itemds_dtl_sw, 
                            v_itemperilds_sw,   v_itemperilds_dtl_sw,   v_partial_sw);
      --if all detail records are missing then recreate records in all
      --final distribution records
      
      IF v_partial_sw = 'N' THEN
        -- for records with giuw_policyds data check if existing records in giri_distfrps exists
        IF v_polds_sw = 'Y' THEN
  	 	  giri_distfrps_pkg.CHECK_FOR_RI_RECORDS(p_dist_no, v_ri_sw);
  	    END IF;
        
        -- Delete all data related to the current DIST_NO
        -- from the distribution tables. 
        gipi_polbasic_pol_dist_v1_pkg.DELETE_DIST_WORKING_TABLES(p_dist_no, v_ri_sw);
        
        -- Create or recreate records in distribution tables GIUW_POLICYDS,
        -- GIUW_POLICYDS_DTL, GIUW_ITEMDS, GIUW_ITEMDS_DTL, GIUW_ITEMPERILDS,
        -- GIUW_ITEMPERILDS_DTL, GIUW_PERILDS and GIUW_PERILDS_DTL. 
        gipi_polbasic_pol_dist_v1_pkg.CREATE_POLICY_DIST_RECS(p_dist_no    , p_policy_id , p_line_cd , 
                                p_subline_cd , p_iss_cd    , p_pack_pol_flag,
                                v_ri_sw);
      ELSE
         --if records exists only in giuw_policyds and giuw_policyds_dtl
         IF v_itemds_dtl_sw = 'N' AND
            v_itemperilds_dtl_sw = 'N' AND
            v_perilds_dtl_sw = 'N' THEN
            CREATE_ITEMDS_BY_POLDS(p_dist_no, p_policy_id, v_itemds_sw);
            CREATE_ITEMPERILDS_BY_ITEMDS(p_dist_no, p_policy_id);
            CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no);
         ELSIF v_polds_dtl_sw = 'N' AND
            v_itemperilds_dtl_sw = 'N' AND
            v_perilds_dtl_sw = 'N' THEN 	 
            CREATE_POLDS_BY_ITEMDS(p_dist_no);
            CREATE_ITEMPERILDS_BY_ITEMDS(p_dist_no, p_policy_id);
            CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no);
         ELSIF v_polds_dtl_sw = 'N' AND
            v_itemds_dtl_sw = 'N' AND
            v_perilds_dtl_sw = 'N' THEN 	 
            CREATE_ITEMDS_BY_ITEMPERILDS(p_dist_no, v_itemds_sw);
            CREATE_POLDS_BY_ITEMDS(p_dist_no); 	    
            CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no);
         ELSIF v_polds_dtl_sw = 'N' AND
            v_itemds_dtl_sw = 'N' AND
            v_itemperilds_dtl_sw = 'N' THEN
            CREATE_ITEMPERILDS_BY_PERILDS(p_dist_no, p_policy_id, v_itemperilds_sw);
            CREATE_ITEMDS_BY_ITEMPERILDS(p_dist_no, v_itemds_sw);
            CREATE_POLDS_BY_ITEMDS(p_dist_no);  	      	    
         ELSIF v_itemperilds_dtl_sw = 'N' AND
            v_perilds_dtl_sw = 'N' THEN	 
            CREATE_ITEMPERILDS_BY_ITEMDS(p_dist_no, p_policy_id);
            CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no);
         ELSIF v_itemds_dtl_sw = 'N' AND
            v_perilds_dtl_sw = 'N' THEN	
            CREATE_ITEMDS_BY_ITEMPERILDS(p_dist_no, v_itemds_sw);
            CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no); 
         ELSIF v_itemds_dtl_sw = 'N' AND
            v_itemperilds_dtl_sw = 'N' THEN
            CREATE_ITEMPERILDS_BY_PERILDS(p_dist_no, p_policy_id, v_itemperilds_sw);
            CREATE_ITEMDS_BY_ITEMPERILDS(p_dist_no, v_itemds_sw);
         ELSIF v_polds_dtl_sw = 'N' AND
            v_perilds_dtl_sw = 'N' THEN	 	 	 	 
            CREATE_POLDS_BY_ITEMDS(p_dist_no);   	      	    
            CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no);  
         ELSIF v_polds_dtl_sw = 'N' AND
            v_itemperilds_dtl_sw = 'N' THEN	 	 
            CREATE_POLDS_BY_ITEMDS(p_dist_no);   	   
            CREATE_ITEMPERILDS_BY_ITEMDS(p_dist_no, p_policy_id);   	    
         ELSIF v_polds_dtl_sw = 'N' AND
            v_itemds_dtl_sw = 'N' THEN	 	 
            CREATE_ITEMDS_BY_ITEMPERILDS(p_dist_no, v_itemds_sw); 
            CREATE_POLDS_BY_ITEMDS(p_dist_no);    	   
         ELSIF v_perilds_dtl_sw = 'N' THEN	 	 
              CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no);   
         ELSIF v_itemperilds_dtl_sw = 'N' THEN	 	
              CREATE_ITEMPERILDS_BY_ITEMDS(p_dist_no, p_policy_id);   	       	     
         ELSIF v_itemds_dtl_sw = 'N' THEN
              CREATE_ITEMDS_BY_ITEMPERILDS(p_dist_no, v_itemds_sw); 
         ELSIF v_polds_dtl_sw = 'N' THEN	 	
              CREATE_POLDS_BY_ITEMDS(p_dist_no);     	   
         END IF;
         
         /* Adjust computational floats to equalize the amounts
         ** attained by the master tables with that of its detail
         ** tables.
         ** Tables involved:  GIUW_PERILDS     - GIUW_PERILDS_DTL
         **                   GIUW_POLICYDS    - GIUW_POLICYDS_DTL
         **                   GIUW_ITEMDS      - GIUW_ITEMDS_DTL
         **                   GIUW_ITEMPERILDS - GIUW_ITEMPERILDS_DTL */
         ADJUST_NET_RET_IMPERFECTION(p_dist_no);
      END IF;  	
    END;
	
   /**
	** Created by:      Veronica V. Raymundo
	** Date Created:    December 27, 2012
	** Reference by:    GIUTS999 - Populate Missing Distribution Records
	** Description :    Function returns query details from GIPI_POLBASIC_POL_DIST_V1.
	**
	**/
    
	FUNCTION get_pol_dist_v1_giuts999(
        p_module_id     GIIS_USER_GRP_MODULES.module_id%TYPE,
        p_user_id       GIIS_USERS.user_id%TYPE,
        p_line_cd       GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
      	p_subline_cd    GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
      	p_iss_cd        GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
      	p_issue_yy      GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
      	p_pol_seq_no    GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
      	p_renew_no      GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
		p_dist_no       GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
	RETURN gipi_polbasic_pol_dist_v1_tab PIPELINED
	AS
      v_pol_dist    gipi_polbasic_pol_dist_v1_type;
	
	BEGIN
		FOR i IN (  SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
						   a.issue_yy, a.pol_seq_no, a.renew_no,
						   a.endt_iss_cd, a.endt_yy, a.endt_seq_no,  
						   a.par_id, a.pol_flag, c.pack_pol_flag, 
						   a.assd_no, b.assd_name, a.acct_ent_date,
						   a.spld_flag, d.dist_flag, a.dist_no, a.eff_date,
						   a.expiry_date, a.negate_date, a.dist_type,
						   a.acct_neg_date, a.par_type,
							  a.line_cd
						   || '-'
						   || a.subline_cd
						   || '-'
						   || a.iss_cd
						   || '-'
						   || LTRIM(TO_CHAR (a.issue_yy, '09'))
						   || '-'
						   || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
						   || '-'
                   		   || LTRIM(TO_CHAR (a.renew_no, '09')) policy_no, --added renew_no by christian 01/04/13
							  a.line_cd
						   || '-'
						   || a.subline_cd
						   || '-'
						   || a.endt_iss_cd
						   || '-'
						   || TO_CHAR (a.endt_yy, '09')
						   || '-'
						   || TO_CHAR (a.endt_seq_no, '0999999') endt_no
					  FROM GIPI_POLBASIC_POL_DIST_V1 a,
						   GIIS_ASSURED b,
						   GIPI_POLBASIC c,
						   GIUW_POL_DIST d
					 WHERE a.assd_no = b.assd_no(+)
					   AND a.policy_id = c.policy_id
					   AND a.policy_id = d.policy_id
					   AND a.dist_no = d.dist_no
					   AND a.dist_flag <> 2
					   AND a.line_cd = NVL(p_line_cd, a.line_cd)
					   AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
					   AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)
					   AND a.issue_yy = NVL(p_issue_yy, a.issue_yy)
					   AND a.pol_seq_no = NVL(p_pol_seq_no, a.pol_seq_no)
					   AND a.renew_no = NVL(p_renew_no, a.renew_no)
					   AND a.dist_no = NVL(p_dist_no, a.dist_no)
					   AND CHECK_USER_PER_LINE1(NVL (p_line_cd, a.line_cd),
												A.iss_cd, p_user_id, p_module_id) = 1
					   AND CHECK_USER_PER_ISS_CD1(NVL (p_line_cd, A.line_cd),
												  A.iss_cd, p_user_id, p_module_id) = 1
				   ORDER BY line_cd ASC, 
							subline_cd ASC, 
							iss_cd ASC, 
							issue_yy DESC,  
							pol_seq_no  ASC, 
							endt_iss_cd ASC, 
							endt_yy DESC, 
							endt_seq_no ASC)
		LOOP
			v_pol_dist.policy_id	:= i.policy_id; 
			v_pol_dist.line_cd		:= i.line_cd; 
			v_pol_dist.subline_cd	:= i.subline_cd; 
			v_pol_dist.iss_cd		:= i.iss_cd;
            v_pol_dist.issue_yy		:= i.issue_yy; 
			v_pol_dist.pol_seq_no	:= i.pol_seq_no; 
			v_pol_dist.endt_iss_cd	:= i.endt_seq_no; 
			v_pol_dist.endt_yy		:= i.endt_yy;
            v_pol_dist.endt_seq_no	:= i.endt_seq_no; 
			v_pol_dist.renew_no		:= i.renew_no; 
			v_pol_dist.par_id		:= i.par_id; 
			v_pol_dist.pol_flag		:= i.pol_flag;
            v_pol_dist.assd_no		:= i.assd_no; 
			v_pol_dist.assd_name	:= i.assd_name; 
			v_pol_dist.pack_pol_flag:= i.pack_pol_flag; 
			v_pol_dist.acct_ent_date:= i.acct_ent_date;
            v_pol_dist.spld_flag	:= i.spld_flag; 
			v_pol_dist.dist_flag	:= i.dist_flag;
			v_pol_dist.dist_no		:= i.dist_no;
			v_pol_dist.eff_date		:= i.eff_date;
            v_pol_dist.expiry_date	:= i.expiry_date;
			v_pol_dist.negate_date	:= i.negate_date; 
			v_pol_dist.dist_type	:= i.dist_type;
            v_pol_dist.acct_neg_date:= i.acct_neg_date; 
			v_pol_dist.par_type		:= i.par_type;
			v_pol_dist.policy_no	:= i.policy_no; 
			v_pol_dist.endt_no		:= i.endt_no;
			
			IF (v_pol_dist.endt_seq_no IS NOT NULL AND v_pol_dist.endt_seq_no != 0) THEN
                v_pol_dist.endt_no := v_pol_dist.endt_no;
            ELSE
                v_pol_dist.endt_no := '';
            END IF;
			
            CHK_CHAR_REF_CODES (v_pol_dist.dist_flag,
                                v_pol_dist.mean_dist_flag,
                                'GIUW_POL_DIST.DIST_FLAG');
								
            --GIUW_POL_DIST_PKG.validate_existing_dist(i.dist_no, i.policy_id, v_pol_dist.msg_alert);
            
            PIPE ROW(v_pol_dist);
			
		END LOOP;
	END;

END gipi_polbasic_pol_dist_v1_pkg;
/


