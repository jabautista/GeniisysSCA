CREATE OR REPLACE PACKAGE BODY CPI.gipir924e_pkg
AS
   /*
   **  Created by   :  Alvin Azarraga
   **  Date Created : 05.31.2012
   **  Reference By : MARINE_CARGO_CERTIFICATE_RSIC
   **  Description  :
   */
   FUNCTION get_gipir924e (
      p_iss_param    NUMBER,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN get_gipir924e_tab PIPELINED
   AS
      det   get_gipir924e_type;
   BEGIN
      FOR i IN
         (SELECT   DECODE (spld_date,
                           NULL, DECODE (a.dist_flag, 3, 'D', 'U'),
                           'S'
                          ) "DIST_FLAG",
                   a.line_cd, a.subline_cd,
                   DECODE (p_iss_param,
                           1, a.cred_branch,
                           a.iss_cd
                          ) iss_cd_header,
                   a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                   a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.issue_date,
                   a.incept_date, a.expiry_date,
                   DECODE (spld_date, NULL, a.total_tsi, 0) total_tsi,
                   DECODE (spld_date, NULL, a.total_prem, 0) total_prem,
                   DECODE (spld_date, NULL, a.evatprem, 0) evatprem,
                   DECODE (spld_date, NULL, a.lgt, 0) lgt,
                   DECODE (spld_date, NULL, a.doc_stamps, 0) doc_stamp,
                   DECODE (spld_date, NULL, a.fst, 0) fst,
                   DECODE (spld_date, NULL, a.other_taxes, 0) other_taxes,
                   DECODE (spld_date,
                           NULL, (  a.total_prem
                                  + a.evatprem
                                  + a.lgt
                                  + a.doc_stamps
                                  + a.fst
                                  + a.other_taxes
                            ),
                           0
                          ) total_charges,
                   DECODE (spld_date,
                           NULL, (  a.evatprem
                                  + a.lgt
                                  + a.doc_stamps
                                  + a.fst
                                  + a.other_taxes
                            ),
                           0
                          ) total_taxes,
                   
                          --DECODE(dist_flag, 3, total_prem, 0) Distributed,
                   --       DECODE(dist_flag, 3, 0, total_prem) Undistributed,
                   a.param_date, a.from_date, a.TO_DATE, SCOPE, a.user_id,
                   a.policy_id, a.assd_no,
                   DECODE
                         (spld_date,
                          NULL, NULL,
                             ' S   P  O  I  L  E  D       /       '
                          || TO_CHAR (spld_date, 'DD-MM-YYYY')
                         ) spld_date,
                   DECODE (spld_date, NULL, 1, 0) pol_count,
                   DECODE (spld_date,
                           NULL, b.commission_amt,
                           0
                          ) commission_amt,
                   DECODE (spld_date, NULL, b.wholding_tax, 0) wholding_tax,
                   DECODE (spld_date, NULL, b.net_comm, 0) net_comm,
                   a.policy_id policy_id_1, a.pol_flag
              FROM gipi_uwreports_ext a,
                   (SELECT   SUM
                                (DECODE (c.ri_comm_amt * c.currency_rt,
                                         0, NVL (  b.commission_amt
                                                 * c.currency_rt,
                                                 0
                                                ),
                                         c.ri_comm_amt * c.currency_rt
                                        )
                                ) commission_amt,
                             SUM (NVL (b.wholding_tax, 0)) wholding_tax,
                             SUM ((  NVL (b.commission_amt, 0)
                                   - NVL (b.wholding_tax, 0)
                                  )
                                 ) net_comm,
                             c.policy_id policy_id
                        FROM gipi_comm_invoice b, gipi_invoice c
                       WHERE c.policy_id = b.policy_id
                    GROUP BY c.policy_id) b
             WHERE a.policy_id = b.policy_id(+)
               AND a.user_id = p_user_id
               AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                      NVL (p_iss_cd,
                           DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                          )
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
          ORDER BY a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.endt_iss_cd,
                   a.endt_yy,
                   a.endt_seq_no)
      LOOP
         det.line_name := cf_line_nameformula (i.line_cd);
         det.subline_name := cf_subline_nameformula (i.subline_cd, i.line_cd);
         det.iss_header := cf_iss_nameformula (i.iss_cd_header);
         det.pol_flag_str := cf_pol_flagformula (i.pol_flag);
         det.pol_no :=
            cf_policy_noformula (i.line_cd,
                                 i.subline_cd,
                                 i.iss_cd,
                                 i.issue_yy,
                                 i.pol_seq_no,
                                 i.renew_no,
                                 i.endt_iss_cd,
                                 i.endt_yy,
                                 i.endt_seq_no,
                                 i.policy_id
                                );
         det.dist_flag := i.dist_flag;
         det.line_cd := i.line_cd;
         det.subline_cd := i.subline_cd;
         det.iss_cd_header := i.iss_cd_header;
         det.iss_cd := i.iss_cd;
         det.issue_yy := i.issue_yy;
         det.pol_seq_no := i.pol_seq_no;
         det.renew_no := i.renew_no;
         det.endt_iss_cd := i.endt_iss_cd;
         det.endt_yy := i.endt_yy;
         det.endt_seq_no := i.endt_seq_no;
         det.issue_date := i.issue_date;
         det.incept_date := i.incept_date;
         det.expiry_date := i.expiry_date;
         det.total_tsi := NVL (i.total_tsi, 0);
         det.total_prem := NVL (i.total_prem, 0);
         det.evatprem := NVL (i.evatprem, 0);
         det.lgt := NVL (i.lgt, 0);
         det.doc_stamp := NVL (i.doc_stamp, 0);
         det.fst := NVL (i.fst, 0);
         det.other_taxes := NVL (i.other_taxes, 0);
         det.total_charges := NVL (i.total_charges, 0);
         det.total_taxes := NVL (i.total_taxes, 0);
         det.param_date := i.param_date;
         det.from_date := i.from_date;
         det.TO_DATE := i.TO_DATE;
         det.SCOPE := i.SCOPE;
         det.user_id := i.user_id;
         det.policy_id := i.policy_id;
         det.assd_no := i.assd_no;
         det.spld_date := i.spld_date;
         det.pol_count := i.pol_count;
         det.commission_amt := NVL (i.commission_amt, 0);
         det.wholding_tax := NVL (i.wholding_tax, 0);
         det.net_comm := NVL (i.net_comm, 0);
         det.policy_id_1 := i.policy_id_1;
         det.pol_flag := i.pol_flag;
         PIPE ROW (det);
      END LOOP;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_gipir924e;

   FUNCTION cf_pol_flagformula (p_pol_flag cg_ref_codes.rv_low_value%TYPE)
      RETURN CHAR
   IS
      v_pol_flag   cg_ref_codes.rv_meaning%TYPE;
   BEGIN
      FOR c1 IN (SELECT rv_meaning
                   FROM cg_ref_codes
                  WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                    AND rv_low_value = p_pol_flag)
      LOOP
         v_pol_flag := c1.rv_meaning;
      END LOOP;

      RETURN (v_pol_flag);
   END cf_pol_flagformula;

   FUNCTION cf_heading3formula(
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN CHAR
   IS
      v_param_date   NUMBER (1);
      v_from_date    DATE;
      v_to_date      DATE;
      heading3       VARCHAR2 (150);
   BEGIN
      SELECT DISTINCT param_date, from_date, TO_DATE
                 INTO v_param_date, v_from_date, v_to_date
                 FROM gipi_uwreports_ext
                WHERE user_id = p_user_id;

      IF v_param_date IN (1, 2, 4)
      THEN
         IF v_from_date = v_to_date
         THEN
            heading3 := 'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      ELSE
         IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
         THEN
            heading3 :=
                'For the Month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      END IF;

      RETURN (heading3);
   END;

   FUNCTION cf_company_addressformula
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;

   FUNCTION cf_companyformula
      RETURN CHAR
   IS
      v_company_name   VARCHAR2 (150);
   BEGIN
      SELECT param_value_v
        INTO v_company_name
        FROM giis_parameters
       WHERE UPPER (param_name) = 'COMPANY_NAME';

      RETURN (v_company_name);
   END;

   FUNCTION cf_policy_noformula (
      p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
      p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
      p_issue_yy      gipi_uwreports_ext.issue_yy%TYPE,
      p_pol_seq_no    gipi_uwreports_ext.pol_seq_no%TYPE,
      p_renew_no      gipi_uwreports_ext.renew_no%TYPE,
      p_endt_iss_cd   gipi_uwreports_ext.endt_iss_cd%TYPE,
      p_endt_yy       gipi_uwreports_ext.endt_yy%TYPE,
      p_endt_seq_no   gipi_uwreports_ext.endt_seq_no%TYPE,
      p_policy_id     gipi_uwreports_ext.policy_id%TYPE
   )
      RETURN CHAR
   IS
      v_policy_no    VARCHAR2 (100);
      v_endt_no      VARCHAR2 (30);
      v_ref_pol_no   VARCHAR2 (35)  := NULL;
   BEGIN
      v_policy_no :=
            p_line_cd
         || '-'
         || p_subline_cd
         || '-'
         || LTRIM (p_iss_cd)
         || '-'
         || LTRIM (TO_CHAR (p_issue_yy, '09'))
         || '-'
         || TO_CHAR (p_pol_seq_no, 'FM0000000')
         || '-'
         || LTRIM (TO_CHAR (p_renew_no, '09'));

      --end add
      IF p_endt_seq_no <> 0
      THEN
         v_endt_no :=
               p_endt_iss_cd
            || '-'
            || LTRIM (TO_CHAR (p_endt_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (p_endt_seq_no));
      END IF;

      BEGIN
         SELECT ref_pol_no
           INTO v_ref_pol_no
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL
      THEN
         v_ref_pol_no := '/' || v_ref_pol_no;
      END IF;

      RETURN (v_policy_no || ' ' || v_endt_no || v_ref_pol_no);
   END;

   FUNCTION cf_iss_nameformula (p_iss_cd_header VARCHAR2)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd_header;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (p_iss_cd_header || ' - ' || v_iss_name);
   END;

   FUNCTION cf_line_nameformula (p_line_cd gipi_uwreports_ext.line_cd%TYPE)
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         RETURN (c.line_name);
      END LOOP;
   END;

   FUNCTION cf_subline_nameformula (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         RETURN (c.subline_name);
      END LOOP;
   END;

   FUNCTION cf_special_riskformula (
      p_iss_param   NUMBER,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd     gipi_uwreports_ext.line_cd%TYPE,
      p_user_id     gipi_uwreports_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN cf_special_riskformula_tab PIPELINED
   AS
      det         cf_special_riskformula_type;
      v_sr_prem   NUMBER (16, 2);
      v_sr_comm   NUMBER (16, 2);
      v_fr_prem   NUMBER (16, 2);
      v_fr_comm   NUMBER (16, 2);
      v_sr_tsi    NUMBER (16, 2);
      v_fr_tsi    NUMBER (16, 2);
   BEGIN
      v_sr_prem := 0;
      v_sr_comm := 0;
      v_fr_prem := 0;
      v_fr_comm := 0;
      v_sr_tsi := 0;
      v_fr_tsi := 0;

      FOR a IN (SELECT   SUM (b.premium_amt) prem_amt,
                         SUM (b.commission_amt * c.currency_rt)
                                                              commission_amt,
                         NVL (e.special_risk_tag, 'N') special_risk_tag
                    FROM gipi_uwreports_ext a,
                         gipi_comm_inv_peril b,
                         gipi_invoice c,
                         (SELECT y.line_cd, y.peril_cd, y.special_risk_tag
                            FROM giis_peril y
                           WHERE y.line_cd IN (SELECT z.line_cd
                                                 FROM giis_peril z
                                                WHERE z.special_risk_tag = 'Y')) e
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = c.policy_id
                     AND b.peril_cd = e.peril_cd
                     AND e.line_cd = a.line_cd
                     AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND a.line_cd = p_line_cd
                     AND spld_date IS NULL
                GROUP BY e.special_risk_tag)
      LOOP
         IF a.special_risk_tag = 'Y'
         THEN
            v_sr_prem := a.prem_amt;
            v_sr_comm := a.commission_amt;
         ELSE
            v_fr_prem := a.prem_amt;
            v_fr_comm := a.commission_amt;
         END IF;
      END LOOP;

      FOR a IN (SELECT   SUM (b.prem_amt) prem_amt,
                         SUM (b.ri_comm_amt * c.currency_rt) commission_amt,
                         NVL (e.special_risk_tag, 'N') special_risk_tag
                    FROM gipi_uwreports_ext a,
                         gipi_invperil b,
                         gipi_invoice c,
                         (SELECT y.line_cd, y.peril_cd, y.special_risk_tag
                            FROM giis_peril y
                           WHERE y.line_cd IN (SELECT z.line_cd
                                                 FROM giis_peril z
                                                WHERE z.special_risk_tag = 'Y')) e
                   WHERE 1 = 1
                     AND a.policy_id = c.policy_id
                     AND c.iss_cd = b.iss_cd
                     AND c.prem_seq_no = b.prem_seq_no
                     AND b.peril_cd = e.peril_cd
                     AND e.line_cd = a.line_cd
                     AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND a.line_cd = p_line_cd
                     AND a.iss_cd = giisp.v ('ISS_CD_RI')
                     AND spld_date IS NULL
                GROUP BY e.special_risk_tag)
      LOOP
         IF a.special_risk_tag = 'Y'
         THEN
            v_sr_prem := v_sr_prem + a.prem_amt;
            v_sr_comm := v_sr_comm + a.commission_amt;
         ELSE
            v_fr_prem := v_fr_prem + a.prem_amt;
            v_fr_comm := v_fr_comm + a.commission_amt;
         END IF;
      END LOOP;

      FOR a IN (SELECT   SUM (d.tsi_amt) tsi_amt,
                         NVL (e.special_risk_tag, 'N') special_risk_tag
                    FROM gipi_uwreports_ext a,
                         gipi_itmperil d,
                         (SELECT y.line_cd, y.peril_cd, y.special_risk_tag,
                                 y.peril_type
                            FROM giis_peril y
                           WHERE y.line_cd IN (SELECT z.line_cd
                                                 FROM giis_peril z
                                                WHERE z.special_risk_tag = 'Y')) e
                   WHERE d.policy_id = a.policy_id
                     AND d.item_no >= 0
                     AND NVL (d.line_cd, '') = a.line_cd
                     AND d.peril_cd = e.peril_cd
                     AND e.line_cd = a.line_cd
                     AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND a.line_cd = p_line_cd
                     AND spld_date IS NULL
                GROUP BY e.special_risk_tag)
      LOOP
         IF a.special_risk_tag = 'Y'
         THEN
            v_sr_tsi := a.tsi_amt;
         ELSE
            v_fr_tsi := a.tsi_amt;
         END IF;
      END LOOP;

      det.sr_prem := v_sr_prem;
      det.sr_comm := v_sr_comm;
      det.fr_prem := v_fr_prem;
      det.fr_comm := v_fr_comm;
      det.sr_tsi := v_sr_tsi;
      det.fr_tsi := v_fr_tsi;
      PIPE ROW (det);
      RETURN;
   END;

   FUNCTION populate_gipir924e (
      p_iss_param   NUMBER,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd     gipi_uwreports_ext.line_cd%TYPE,
      p_user_id     gipi_uwreports_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN populate_gipir924e_tab PIPELINED
   AS
      det   populate_gipir924e_type;
   BEGIN
      FOR i IN
         (SELECT gipir924e_pkg.cf_companyformula cf_company,
                 gipir924e_pkg.cf_company_addressformula cf_company_address,
                 gipir924e_pkg.cf_heading3formula(p_user_id) cf_heading3, a.*
            FROM TABLE (gipir924e_pkg.cf_special_riskformula (p_iss_param,
                                                              p_iss_cd,
                                                              p_line_cd,
                                                              p_user_id
                                                             )
                       ) a)
      LOOP
         det.cf_company := i.cf_company;
         det.cf_company_address := i.cf_company_address;
         det.cf_heading3 := i.cf_heading3;
         det.sr_prem := i.sr_prem;
         det.sr_comm := i.sr_comm;
         det.fr_prem := i.fr_prem;
         det.fr_comm := i.fr_comm;
         det.sr_tsi := i.sr_tsi;
         det.fr_tsi := i.fr_tsi;
         PIPE ROW (det);
      END LOOP;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END populate_gipir924e;
END gipir924e_pkg;
/


