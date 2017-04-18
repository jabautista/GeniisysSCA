CREATE OR REPLACE PACKAGE BODY CPI.gipis191_pkg
AS
   PROCEDURE process_policy (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_risk_tag     OUT   gipi_polbasic.risk_tag%TYPE,
      p_tsi_amt      OUT   gipi_polbasic.tsi_amt%TYPE,
      p_prem_amt     OUT   gipi_polbasic.prem_amt%TYPE,
      p_user_id            giis_users.user_id%TYPE
   )
   IS
      v_loop   NUMBER := 0;
   BEGIN
      FOR pol IN (SELECT   a.risk_tag, a.tsi_amt, a.prem_amt
                      FROM gipi_polbasic a
                     WHERE 1 = 1
                       AND a.line_cd = p_line_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.iss_cd = p_iss_cd
                       AND a.issue_yy = p_issue_yy
                       AND a.pol_seq_no = p_pol_seq_no
                       AND a.renew_no = p_renew_no
                       AND check_user_per_iss_cd2 (a.line_cd,
                                                   a.iss_cd,
                                                   'GIPIS191',
                                                   p_user_id
                                                  ) = 1
                       AND check_user_per_line2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GIPIS191',
                                                 p_user_id
                                                ) = 1
                  ORDER BY eff_date DESC, endt_seq_no DESC)
      LOOP
         IF v_loop = 0
         THEN
            p_risk_tag := pol.risk_tag;
            v_loop := 1;
         END IF;

         p_tsi_amt := NVL (p_tsi_amt, 0) + NVL (pol.tsi_amt, 0);
         p_prem_amt := NVL (p_prem_amt, 0) + NVL (pol.prem_amt, 0);
      END LOOP;

      IF p_risk_tag IS NULL
      THEN
         p_risk_tag := 'J';
      END IF;
   END process_policy;

   PROCEDURE extract_risk_category   (
      p_from_date   IN VARCHAR2,
      p_to_date     IN VARCHAR2,
      p_basis       IN VARCHAR2,
      p_user_id     IN VARCHAR2,
      p_no_of_recs  OUT VARCHAR2
   )
   IS
      TYPE tab_cat_cd IS TABLE OF gixx_risk_category.cat_cd%TYPE;

      TYPE tab_sub_cat_cd IS TABLE OF gixx_risk_category.sub_cat_cd%TYPE;

      TYPE tab_risk_amt IS TABLE OF gixx_risk_category.risk_amt%TYPE;

      TYPE tab_risk_pct IS TABLE OF gixx_risk_category.risk_pct%TYPE;

      TYPE tab_prem_amt IS TABLE OF gixx_risk_category.prem_amt%TYPE;

      TYPE tab_prem_pct IS TABLE OF gixx_risk_category.prem_pct%TYPE;

      TYPE tab_ave_pct IS TABLE OF gixx_risk_category.ave_pct%TYPE;

      TYPE tab_pol_count IS TABLE OF gixx_risk_category.pol_count%TYPE;

      vv_cat_cd             tab_cat_cd;
      vv_risk_cat_cd        tab_cat_cd;
      vv_sub_cat_cd         tab_sub_cat_cd;
      vv_risk_sub_cat_cd    tab_sub_cat_cd;
      vv_risk_amt           tab_risk_amt;
      vv_risk_pct           tab_risk_pct;
      vv_risk_prem_amt      tab_prem_amt;
      vv_prem_pct           tab_prem_pct;
      vv_ave_pct            tab_ave_pct;
      vv_pol_count          tab_pol_count;

      TYPE tab_line_cd IS TABLE OF gipi_polbasic.line_cd%TYPE;

      TYPE tab_subline_cd IS TABLE OF gipi_polbasic.subline_cd%TYPE;

      TYPE tab_iss_cd IS TABLE OF gipi_polbasic.iss_cd%TYPE;

      TYPE tab_issue_yy IS TABLE OF gipi_polbasic.issue_yy%TYPE;

      TYPE tab_pol_seq_no IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;

      TYPE tab_renew_no IS TABLE OF gipi_polbasic.renew_no%TYPE;

      TYPE tab_risk_tag IS TABLE OF gipi_polbasic.risk_tag%TYPE;

      TYPE tab_tsi_amt IS TABLE OF gipi_polbasic.tsi_amt%TYPE;

      vv_line_cd            tab_line_cd;
      vv_subline_cd         tab_subline_cd;
      vv_iss_cd             tab_iss_cd;
      vv_issue_yy           tab_issue_yy;
      vv_pol_seq_no         tab_pol_seq_no;
      vv_renew_no           tab_renew_no;
      vv_risk_tag           tab_risk_tag;
      vv_tsi_amt            tab_tsi_amt;
      vv_prem_amt           tab_prem_amt;
      rec_num               NUMBER         := 0;
      risk_rec              NUMBER         := 0;
      v_total_ri_risk_amt   NUMBER         := 0;
      v_total_ri_prem_amt   NUMBER         := 0;
      v_total_ho_risk_amt   NUMBER         := 0;
      v_total_ho_prem_amt   NUMBER         := 0;
      v_total_ol_risk_amt   NUMBER         := 0;
      v_total_ol_prem_amt   NUMBER         := 0;
      v_risk_pct            NUMBER         := 0;
      v_prem_pct            NUMBER         := 0;
      v_ave_pct             NUMBER         := 0;
   BEGIN
      DELETE FROM gixx_risk_category
       WHERE user_id = p_user_id
          OR user_id IS NULL;

      SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy,
                      pol_seq_no, renew_no
      BULK COLLECT INTO vv_line_cd, vv_subline_cd, vv_iss_cd, vv_issue_yy,
                      vv_pol_seq_no, vv_renew_no
                 FROM gipi_polbasic
                WHERE 1 = 1
                  AND pol_flag <> '5'
                  AND (   (    p_basis = 1
                           AND acct_ent_date IS NOT NULL
                           AND TRUNC (acct_ent_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                                                         AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                          )
                       OR (    p_basis = 2
                           AND TRUNC (eff_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                          )
                       OR (    p_basis = 3
                           AND TRUNC (issue_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                                                      AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                          )
                       OR (    p_basis = 4
                           AND LAST_DAY (TO_DATE (   booking_mth
                                                  || ','
                                                  || TO_CHAR (booking_year),
                                                  'FMMONTH,YYYY'
                                                 )
                                        ) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                          )
                      )
                  AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GIPIS191', p_user_id) = 1
                  AND check_user_per_line2 (line_cd, iss_cd, 'GIPIS191', p_user_id) = 1;

      IF SQL%FOUND
      THEN
         SELECT rv_low_value
         BULK COLLECT INTO vv_cat_cd
           FROM cg_ref_codes
          WHERE rv_domain = 'GIXX_RISK_CATEGORY.CAT_CD';

         SELECT rv_low_value
         BULK COLLECT INTO vv_sub_cat_cd
           FROM cg_ref_codes
          WHERE rv_domain = 'GIPI_POLBASIC.RISK_TAG';

         vv_risk_tag := tab_risk_tag ();
         vv_tsi_amt := tab_tsi_amt ();
         vv_prem_amt := tab_prem_amt ();
         vv_risk_tag.EXTEND (vv_line_cd.COUNT);
         vv_tsi_amt.EXTEND (vv_line_cd.COUNT);
         vv_prem_amt.EXTEND (vv_line_cd.COUNT);
         vv_risk_cat_cd := tab_cat_cd ();
         vv_risk_sub_cat_cd := tab_sub_cat_cd ();
         vv_risk_amt := tab_risk_amt ();
         vv_risk_pct := tab_risk_pct ();
         vv_risk_prem_amt := tab_prem_amt ();
         vv_prem_pct := tab_prem_pct ();
         vv_ave_pct := tab_ave_pct ();
         vv_pol_count := tab_pol_count ();
         vv_risk_cat_cd.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_risk_sub_cat_cd.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_risk_amt.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_risk_pct.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_risk_prem_amt.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_prem_pct.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_ave_pct.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);
         vv_pol_count.EXTEND (vv_cat_cd.COUNT * vv_sub_cat_cd.COUNT);

         FOR pol IN vv_line_cd.FIRST .. vv_line_cd.LAST
         LOOP
            gipis191_pkg.process_policy (vv_line_cd (pol),
                                         vv_subline_cd (pol),
                                         vv_iss_cd (pol),
                                         vv_issue_yy (pol),
                                         vv_pol_seq_no (pol),
                                         vv_renew_no (pol),
                                         vv_risk_tag (pol),
                                         vv_tsi_amt (pol),
                                         vv_prem_amt (pol),
                                         p_user_id
                                        );

            FOR subcat IN vv_sub_cat_cd.FIRST .. vv_sub_cat_cd.LAST
            LOOP
               IF vv_risk_tag (pol) = vv_sub_cat_cd (subcat)
               THEN
                  rec_num := 0;
                  risk_rec := subcat + (vv_sub_cat_cd.COUNT * rec_num);
                  vv_risk_cat_cd (risk_rec) := 'O';
                  vv_risk_sub_cat_cd (risk_rec) := vv_sub_cat_cd (subcat);
                  vv_risk_amt (risk_rec) :=
                            NVL (vv_risk_amt (risk_rec), 0)
                            + vv_tsi_amt (pol);
                  vv_risk_prem_amt (risk_rec) :=
                      NVL (vv_risk_prem_amt (risk_rec), 0)
                      + vv_prem_amt (pol);
                  vv_pol_count (risk_rec) :=
                                          NVL (vv_pol_count (risk_rec), 0)
                                          + 1;
                  v_total_ol_risk_amt :=
                                       v_total_ol_risk_amt + vv_tsi_amt (pol);
                  v_total_ol_prem_amt :=
                                      v_total_ol_prem_amt + vv_prem_amt (pol);

                  IF vv_iss_cd (pol) <> 'RI'
                  THEN
                     rec_num := 1;
                     risk_rec := subcat + (vv_sub_cat_cd.COUNT * rec_num);
                     vv_risk_cat_cd (risk_rec) := 'D';
                     vv_risk_sub_cat_cd (risk_rec) := vv_sub_cat_cd (subcat);
                     vv_risk_amt (risk_rec) :=
                            NVL (vv_risk_amt (risk_rec), 0)
                            + vv_tsi_amt (pol);
                     vv_risk_prem_amt (risk_rec) :=
                          NVL (vv_risk_prem_amt (risk_rec), 0)
                        + vv_prem_amt (pol);
                     vv_pol_count (risk_rec) :=
                                           NVL (vv_pol_count (risk_rec), 0)
                                           + 1;
                     v_total_ho_risk_amt :=
                                        v_total_ho_risk_amt + vv_tsi_amt (pol);
                     v_total_ho_prem_amt :=
                                       v_total_ho_prem_amt + vv_prem_amt (pol);
                  ELSIF vv_iss_cd (pol) = 'RI'
                  THEN
                     rec_num := 2;
                     risk_rec := subcat + (vv_sub_cat_cd.COUNT * rec_num);
                     vv_risk_cat_cd (risk_rec) := 'R';
                     vv_risk_sub_cat_cd (risk_rec) := vv_sub_cat_cd (subcat);
                     vv_risk_amt (risk_rec) :=
                            NVL (vv_risk_amt (risk_rec), 0)
                            + vv_tsi_amt (pol);
                     vv_risk_prem_amt (risk_rec) :=
                          NVL (vv_risk_prem_amt (risk_rec), 0)
                        + vv_prem_amt (pol);
                     vv_pol_count (risk_rec) :=
                                           NVL (vv_pol_count (risk_rec), 0)
                                           + 1;
                     v_total_ri_risk_amt :=
                                        v_total_ri_risk_amt + vv_tsi_amt (pol);
                     v_total_ri_prem_amt :=
                                       v_total_ri_prem_amt + vv_prem_amt (pol);
                  END IF;
               END IF;
            END LOOP;
         END LOOP;

         DBMS_OUTPUT.put_line ('IRIS ' || v_total_ol_risk_amt);

         FOR risk IN vv_risk_cat_cd.FIRST .. vv_risk_cat_cd.LAST
         LOOP
            IF vv_risk_amt (risk) IS NULL OR vv_risk_amt (risk) = 0
            THEN
               v_risk_pct := NULL;
               v_ave_pct := NULL;
            ELSE
               v_ave_pct :=
                  ROUND (vv_risk_prem_amt (risk) / vv_risk_amt (risk) * 100,
                         2);

               IF vv_risk_cat_cd (risk) = 'O'
               THEN
                  v_risk_pct :=
                     ROUND (vv_risk_amt (risk) / v_total_ol_risk_amt * 100,
                            2);
               ELSIF vv_risk_cat_cd (risk) = 'R'
               THEN
                  v_risk_pct :=
                     ROUND (vv_risk_amt (risk) / v_total_ri_risk_amt * 100,
                            2);
               ELSIF vv_risk_cat_cd (risk) = 'D'
               THEN
                  v_risk_pct :=
                     ROUND (vv_risk_amt (risk) / v_total_ho_risk_amt * 100,
                            2);
               END IF;
            END IF;

            IF vv_risk_prem_amt (risk) IS NULL OR vv_risk_prem_amt (risk) = 0
            THEN
               v_prem_pct := NULL;
            ELSE
               IF vv_risk_cat_cd (risk) = 'O'
               THEN
                  v_prem_pct :=
                     ROUND (vv_risk_prem_amt (risk) / v_total_ol_prem_amt
                            * 100,
                            2
                           );
               ELSIF vv_risk_cat_cd (risk) = 'R'
               THEN
                  v_prem_pct :=
                     ROUND (vv_risk_prem_amt (risk) / v_total_ri_prem_amt
                            * 100,
                            2
                           );
               ELSIF vv_risk_cat_cd (risk) = 'D'
               THEN
                  v_prem_pct :=
                     ROUND (vv_risk_prem_amt (risk) / v_total_ho_prem_amt
                            * 100,
                            2
                           );
               END IF;
            END IF;

            vv_risk_pct (risk) := v_risk_pct;
            vv_prem_pct (risk) := v_prem_pct;
            vv_ave_pct (risk) := v_ave_pct;
         END LOOP;

         FORALL recs IN vv_risk_cat_cd.FIRST .. vv_risk_cat_cd.LAST
            INSERT INTO gixx_risk_category
                        (cat_cd,
                         sub_cat_cd,
                         risk_amt, risk_pct,
                         prem_amt, prem_pct,
                         ave_pct, pol_count,
                         from_date, to_date,
                         date_basis, user_id
                        )
                 VALUES (NVL (vv_risk_cat_cd (recs), 'X'),
                         NVL (vv_risk_sub_cat_cd (recs), 'X'),
                         vv_risk_amt (recs), vv_risk_pct (recs),
                         vv_risk_prem_amt (recs), vv_prem_pct (recs),
                         vv_ave_pct (recs), vv_pol_count (recs),
                         TO_DATE(p_from_date, 'mm-dd-yyyy'),
                         TO_DATE(p_to_date, 'mm-dd-yyyy'),
                         p_basis, p_user_id
                        );

         DELETE FROM gixx_risk_category
               WHERE cat_cd = 'X'
                 AND user_id = p_user_id;                 
               
         BEGIN               
            SELECT COUNT(*)
              INTO p_no_of_recs
              FROM gixx_risk_category
             WHERE user_id = p_user_id ;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_no_of_recs := NULL;     
         END;        

      END IF;
   END extract_risk_category;
   
   FUNCTION get_params (
      p_user_id VARCHAR2
   )
      RETURN params_tab PIPELINED
   IS
      v_list params_type;
   BEGIN
      BEGIN
         SELECT TO_CHAR(from_date, 'mm-dd-yyyy'), TO_CHAR(to_date, 'mm-dd-yyyy'), date_basis
           INTO v_list.from_date, v_list.to_date, v_list.date_basis
           FROM gixx_risk_category
          WHERE user_id = p_user_id
            AND ROWNUM = 1;
          
         SELECT COUNT(*)
           INTO v_list.no_of_recs
           FROM gixx_risk_category; 
          
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_list.from_date := NULL;
         v_list.to_date := NULL;
         v_list.date_basis := NULL;
         v_list.no_of_recs := 0;    
      END;
      PIPE ROW(v_list);
   END get_params;   
END;
/


