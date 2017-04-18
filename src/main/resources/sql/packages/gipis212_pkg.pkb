CREATE OR REPLACE PACKAGE BODY CPI.gipis212_pkg
AS
   FUNCTION get_grouped_items (
      p_line_cd              gipi_polbasic.line_cd%TYPE,
      p_subline_cd           gipi_polbasic.subline_cd%TYPE,
      p_iss_cd               gipi_polbasic.iss_cd%TYPE,
      p_issue_yy             VARCHAR2,
      p_pol_seq_no           VARCHAR2,
      p_renew_no             VARCHAR2,
      p_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      p_control_type_cd      VARCHAR2,
      p_control_type_desc    VARCHAR2, --added by robert SR 5157 12.22.15
      p_control_cd           gipi_grouped_items.control_cd%TYPE,
      p_policy_id            gipi_polbasic.policy_id%TYPE
   )
      RETURN grouped_item_tab PIPELINED
   IS
      v_rec   grouped_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.grouped_item_title, a.policy_id, a.item_no, a.grouped_item_no, --added columns by robert SR 5157 12.22.15
                          a.control_type_cd, a.control_cd, b.ref_pol_no,
                          b.assd_no, c.assd_name, b.eff_date, a.delete_sw, d.control_type_desc --added column by robert SR 5157 12.22.15
                     FROM gipi_grouped_items a,
                          gipi_polbasic b,
                          giis_assured c,
                          giis_control_type d --added by robert SR 5157 12.22.15
                    WHERE 1 = 1
                      AND a.policy_id = b.policy_id
                      AND b.assd_no = c.assd_no
                      AND b.line_cd = p_line_cd
                      AND b.subline_cd = p_subline_cd
                      AND b.iss_cd = p_iss_cd
                      AND b.issue_yy = p_issue_yy
                      AND b.pol_seq_no = p_pol_seq_no
                      AND b.renew_no = p_renew_no
                      --AND b.policy_id = p_policy_id --removed by robert SR 5157 12.22.15 
					  --added condition by robert SR 5157 12.22.15 
                      AND a.control_type_cd = d.control_type_cd(+)
					  AND b.pol_flag <> '5'
                      AND NOT EXISTS (
                            SELECT 'X'
                              FROM gipi_polbasic m
                             WHERE m.line_cd         = p_line_cd
                               AND m.subline_cd      = p_subline_cd
                               AND m.iss_cd          = p_iss_cd
                               AND m.issue_yy        = p_issue_yy
                               AND m.pol_seq_no      = p_pol_seq_no
                               AND m.renew_no        = p_renew_no 
                               AND m.endt_seq_no > b.endt_seq_no
                               AND NVL (m.back_stat, 5) = 2)
				      --end robert SR 5157 12.22.15 
                      AND UPPER (a.grouped_item_title) LIKE
                             UPPER (NVL (p_grouped_item_title || '%',
                                         a.grouped_item_title
                                        )
                                   )
                      AND NVL (a.control_type_cd, 99999) LIKE
                             UPPER (NVL (p_control_type_cd || '%',
                                         NVL (a.control_type_cd, 99999)
                                        )
                                   )
                      --added by robert SR 5157 12.22.15
                      AND UPPER (NVL (d.control_type_desc, '!@#$')) LIKE 
                             UPPER (NVL (p_control_type_desc,
                                         NVL (d.control_type_desc, '!@#$')
                                        )
                                   )
                      --end of codes by robert SR 5157 12.22.15
                      AND UPPER (NVL (a.control_cd, '!@#$')) LIKE
                             UPPER (NVL (p_control_cd || '%',
                                         NVL (a.control_cd, '!@#$')
                                        )
                                   )
			     ORDER BY a.item_no, a.grouped_item_no, b.eff_date DESC) --added by robert SR 5157 12.22.15
      LOOP
         IF NVL(v_rec.item_no,0) <> i.item_no OR --added by robert SR 5157 12.22.15
             NVL(v_rec.grouped_item_no,0) <> i.grouped_item_no  THEN 
			 v_rec.item_no := i.item_no;
			 v_rec.grouped_item_no := i.grouped_item_no;
			 v_rec.delete_sw := i.delete_sw; --'N';
			 v_rec.grouped_item_title := i.grouped_item_title;
			 v_rec.policy_id := i.policy_id;
			 v_rec.control_type_cd := i.control_type_cd;
			 v_rec.control_cd := i.control_cd;
			 v_rec.ref_pol_no := i.ref_pol_no;
			 v_rec.assd_no := i.assd_no;
			 v_rec.assd_name := i.assd_name;
             v_rec.control_type_desc := i.control_type_desc;
	
			 --IF     (i.eff_date >= SYSDATE)
			 --	AND (i.delete_sw = 'N' OR i.delete_sw IS NULL)
			 --THEN
			 --	v_rec.delete_sw := 'Y';
			 --END IF;
			 PIPE ROW (v_rec);
	 	 END IF;
      END LOOP;

      RETURN;
   END get_grouped_items;

   FUNCTION get_grouped_items_dtl (
      p_policy_id            VARCHAR2,
      p_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      p_endt                 VARCHAR2,
      p_item_no              VARCHAR2,
      p_grouped_item_no      VARCHAR2,
      p_package_cd           giis_package_benefit.package_cd%TYPE
   )
      RETURN grouped_item_dtl_tab PIPELINED
   IS
      v_rec   grouped_item_dtl_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT ggi.control_type_cd cond1,
                          gct.control_type_cd cond2, gp.policy_id,
                             gp.endt_iss_cd
                          || '-'
                          || TRIM (TO_CHAR (gp.endt_yy, '09'))
                          || '-'
                          || TRIM (TO_CHAR (gp.endt_seq_no, '0000009')) endt,
                          gp.eff_date,
                          TRIM (TO_CHAR (ggi.item_no, '000000009')) item_no,
                          TRIM (TO_CHAR (ggi.grouped_item_no, '000000009')
                               ) grouped_item_no,
                          --gp.tsi_amt, gp.prem_amt, --replaced by robert SR 5157 12.22.15
                          ggi.tsi_amt, ggi.prem_amt,
                          NVL (ggi.delete_sw, /*'Y'*/ 'N') delete_sw, --changed from Y to N by robert SR 5157 12.22.15
                          ggi.grouped_item_title, gp.line_cd,
                          gpb.pack_ben_cd, gpb.package_cd
                     FROM giis_control_type gct,
                          giis_package_benefit gpb,
                          gipi_grouped_items ggi,
                          gipi_polbasic gp
                    WHERE 1 = 1
                      AND gp.policy_id = ggi.policy_id
                      AND gpb.pack_ben_cd(+) = ggi.pack_ben_cd
                      AND gct.control_type_cd(+) = ggi.control_type_cd
                      AND NVL (gct.control_type_cd,
                               (SELECT MAX (a.control_type_cd)
                                  FROM giis_assured a,
                                       gipi_polbasic b,
                                       gipi_grouped_items c
                                 WHERE a.assd_no = b.assd_no
                                   AND b.policy_id = c.policy_id
                                   AND b.policy_id = gp.policy_id)
                              ) =
                             NVL (ggi.control_type_cd,
                                  (SELECT MAX (a.control_type_cd)
                                     FROM giis_assured a,
                                          gipi_polbasic b,
                                          gipi_grouped_items c
                                    WHERE a.assd_no = b.assd_no
                                      AND b.policy_id = c.policy_id
                                      AND b.policy_id = gp.policy_id)
                                 )
                      --AND gp.policy_id = p_policy_id  --removed by robert SR 5157 12.22.15
                      --AND ggi.grouped_item_title = p_grouped_item_title --removed by robert SR 5157 12.22.15
					  --added by robert SR 5157 12.22.15
					  AND EXISTS (SELECT 1 from gipi_polbasic  a where a.policy_id = p_policy_id
                                     AND gp.line_cd = a.line_cd
                                     AND gp.subline_cd = a.subline_cd
                                     AND gp.iss_cd = a.iss_cd
                                     AND gp.issue_yy = a.issue_yy
                                     AND gp.pol_seq_no = a.pol_seq_no
                                     AND gp.renew_no = a.renew_no
                                     )
					  --end robert SR 5157 12.22.15
                      AND    gp.endt_iss_cd
                          || '-'
                          || TRIM (TO_CHAR (gp.endt_yy, '09'))
                          || '-'
                          || TRIM (TO_CHAR (gp.endt_seq_no, '0000009')) LIKE
                             UPPER (NVL (p_endt || '%',
                                            gp.endt_iss_cd
                                         || '-'
                                         || TRIM (TO_CHAR (gp.endt_yy, '09'))
                                         || '-'
                                         || TRIM (TO_CHAR (gp.endt_seq_no,
                                                           '0000009'
                                                          )
                                                 )
                                        )
                                   )
                      AND ggi.grouped_item_no =
                                  NVL (p_grouped_item_no, ggi.grouped_item_no)
                      AND ggi.item_no = NVL (p_item_no, ggi.item_no)
			     ORDER BY ENDT) --added by robert SR 5157 12.22.15
      LOOP
         v_rec.endt := i.endt;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-RRRR');
         v_rec.item_no := i.item_no;
         v_rec.grouped_item_no := i.grouped_item_no;
         v_rec.policy_id := i.policy_id;
         v_rec.line_cd := i.line_cd;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.package_cd := i.package_cd;
         v_rec.delete_sw := i.delete_sw;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_grouped_items_dtl;

   FUNCTION get_policyno_lov (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN policy_no_lov_tab PIPELINED
   IS
      v_rec   policy_no_lov_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT --get_policy_no (a.policy_id) policy_no, --marco - 08.26.2014 - replaced
                          line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09'))
                         || DECODE (
                               NVL (endt_seq_no, 0),
                               0, '',
                                  ' / '
                               || endt_iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (endt_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
                            ) policy_no,
                          policy_id, ref_pol_no,
                          assd_name, line_cd, subline_cd, iss_cd, issue_yy,
                          pol_seq_no, renew_no
                     FROM gipi_polbasic a, giis_assured b
                    WHERE a.assd_no = b.assd_no(+) --marco - 08.26.2014 - (+)
                      AND pack_policy_id IS NULL
                      AND line_cd = NVL (p_line_cd, line_cd)
                      AND subline_cd = NVL (p_subline_cd, subline_cd)
                      AND iss_cd = NVL (p_iss_cd, iss_cd)
                      AND issue_yy = NVL (p_issue_yy, issue_yy)
                      AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                      AND renew_no = NVL (p_renew_no, renew_no)
                      AND a.endt_seq_no = 0 --added by robert SR 5157 12.22.15
                      /* AND ((   a.line_cd = 'AC' --replaced codes by robert SR 5157 01.02.16
                            OR a.line_cd IN (SELECT line_cd
                                               FROM giis_line
                                              WHERE menu_line_cd = 'AC')
                           )
                          )*/
                      AND a.line_cd IN (SELECT line_cd
                                               FROM giis_line
                                              WHERE menu_line_cd = 'AC')
                      /* AND EXISTS ( --marco - 08.26.2014 - comment out duplicate validation
                             SELECT 1
                               FROM giis_line x
                              WHERE x.menu_line_cd = 'AC'
                                AND check_user_per_line2 (DECODE (a.line_cd,
                                                                  'AC', a.line_cd,
                                                                  x.line_cd
                                                                 ),
                                                          a.iss_cd,
                                                          'GIPIS212',
                                                          p_user_id
                                                         ) = 1) */
                      AND check_user_per_iss_cd2 (a.line_cd,
                                                  a.iss_cd,
                                                  'GIPIS212',
                                                  p_user_id
                                                 ) = 1
		              ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no ASC) --added by robert SR 5157 12.22.15
      LOOP
         v_rec.policy_no := i.policy_no;
         v_rec.policy_id := i.policy_id;
         v_rec.ref_pol_no := i.ref_pol_no;
         v_rec.assd_name := i.assd_name;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_policyno_lov;

   FUNCTION get_coverage_dtls (
      p_policy_id         gipi_itmperil_grouped.policy_id%TYPE,
      p_grouped_item_no   gipi_itmperil_grouped.grouped_item_no%TYPE,
      p_item_no           gipi_itmperil_grouped.item_no%TYPE,
      p_line_cd           giis_peril.line_cd%TYPE,
      p_peril_name        giis_peril.peril_name%TYPE
   )
      RETURN coverage_dtls_tab PIPELINED
   IS
      v_rec   coverage_dtls_type;
   BEGIN
      FOR i IN (SELECT DISTINCT gig.policy_id, gp.peril_name, gig.prem_rt,
                                gig.tsi_amt, gig.prem_amt, gig.aggregate_sw,
                                gig.base_amt, gig.no_of_days,
                                gig.grouped_item_no, gig.item_no, gp.line_cd
                           FROM giis_peril gp, gipi_itmperil_grouped gig
                          --,gipi_grouped_items ggi
                WHERE           gp.peril_cd = gig.peril_cd
                            --AND ggi.policy_id = gig.policy_id
                            --AND ggi.line_cd = gig.line_cd
                            AND gig.policy_id = p_policy_id
                            AND gig.grouped_item_no = p_grouped_item_no
                            AND gp.line_cd = p_line_cd
                            AND gig.item_no = p_item_no
                            AND UPPER (gp.peril_name) LIKE
                                   UPPER (NVL (p_peril_name || '%',
                                               gp.peril_name
                                              )
                                         ))
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.peril_name := i.peril_name;
         v_rec.prem_rt := i.prem_rt;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.aggregate_sw := i.aggregate_sw;
         v_rec.base_amt := i.base_amt;
         v_rec.no_of_days := i.no_of_days;
         v_rec.grouped_item_no := i.grouped_item_no;
         v_rec.item_no := i.item_no;
         v_rec.line_cd := i.line_cd;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_coverage_dtls;
END;
/


