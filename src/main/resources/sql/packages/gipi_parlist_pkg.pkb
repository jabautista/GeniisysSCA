CREATE OR REPLACE PACKAGE BODY CPI.gipi_parlist_pkg
AS
   FUNCTION get_gipi_parlist (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_keyword        VARCHAR2,
      p_user_id        giis_users.user_id%TYPE,
      p_ri_switch      VARCHAR2
   )
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_parlist   gipi_parlist_type;      
   BEGIN
      FOR i IN
         (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.assd_no, b.assd_name, A.underwriter,
                   c.pack_pol_flag, c.line_name,
                   cg_ref_codes_pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                   A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '009') par_no              --,
              --d.pol_flag, d.subline_cd, d.pol_seq_no, d.issue_yy, --to enable fetching records that doesnt have records in GIPI_WPOLBAS yet BRY07.07.2010
              --e.op_flag
          FROM     gipi_parlist A, giis_assured b, giis_line c            --,
             --GIPI_WPOLBAS d,
             --GIIS_SUBLINE e
          WHERE    check_user_per_line2 (A.line_cd, p_iss_cd, p_module_id, p_user_id) = 1
               AND Check_User_Per_Iss_Cd2 (NVL (p_line_cd, A.line_cd),
                                          A.iss_cd,
                                          p_module_id,
                                          p_user_id
                                         ) = 1
               AND A.line_cd || '-' || A.iss_cd IN (
                      SELECT line_cd || '-' || iss_cd
                        FROM TABLE
                                (gipi_parlist_pkg.parlist_security
                                                                  (p_module_id, p_user_id)
                                ))
               AND par_status < 10
               AND underwriter LIKE (check_accessible_records ())
               AND par_type = 'P'
               AND c.pack_pol_flag != 'Y'
               AND A.assd_no = b.assd_no
               AND A.line_cd = c.line_cd
               --AND a.line_cd = p_line_cd
               AND A.line_cd = NVL (p_line_cd, A.line_cd)
               --AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               --AND a.iss_cd != 'RI'
               AND A.iss_cd LIKE UPPER(NVL (decode(p_ri_switch,'Y','RI',p_iss_cd), A.iss_cd))
               AND decode(p_ri_switch,'Y','1',A.iss_cd) != decode(p_ri_switch,'Y','2','RI')
               AND (   UPPER (A.iss_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_yy) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_seq_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.quote_seq_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.underwriter) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER
                          (cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                          ) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (b.assd_name) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.line_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (c.line_name) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                   )
          --AND d.par_id = a.par_id
          --AND d.line_cd = e.line_cd
          --AND d.subline_cd = e.subline_cd
          ORDER BY    LTRIM (A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '009') DESC)
      LOOP
         BEGIN
            SELECT pol_flag, subline_cd,
                   pol_seq_no, issue_yy
              INTO v_parlist.pol_flag, v_parlist.subline_cd,
                   v_parlist.pol_seq_no, v_parlist.issue_yy
              FROM gipi_wpolbas
             WHERE par_id = i.par_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT op_flag
              INTO v_parlist.op_flag
              FROM giis_subline
             WHERE line_cd = i.line_cd AND subline_cd = v_parlist.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
         
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.line_name := i.line_name;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.status := i.status;
         v_parlist.par_type := i.par_type;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         v_parlist.par_no := i.par_no;
         v_parlist.par_status := i.par_status;
         --v_parlist.pol_flag := i.pol_flag;
         --v_parlist.subline_cd := i.subline_cd;
         --v_parlist.op_flag := i.op_flag;
         --v_parlist.pol_seq_no := i.pol_seq_no;
         --v_parlist.issue_yy := i.issue_yy;
         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END get_gipi_parlist;

   FUNCTION get_gipi_parlist (
      p_par_id      gipi_parlist.par_id%TYPE,
      p_line_cd     gipi_parlist.line_cd%TYPE,
      p_iss_cd      gipi_parlist.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_underwriter gipi_parlist.underwriter%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_parlist   gipi_parlist_type;
   BEGIN
      FOR i IN (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy,
                         A.par_seq_no, A.quote_seq_no, A.assd_no,
                         b.assd_name, A.underwriter, c.pack_pol_flag,
                         A.par_status, A.par_type, A.quote_id, A.assign_sw,
                         A.remarks, A.address1, A.address2, A.address3
                    FROM gipi_parlist A, giis_assured b, giis_line c
                   WHERE A.par_id = p_par_id
                     AND check_user_per_line2 (A.line_cd, p_iss_cd,
                                              p_module_id, p_underwriter) = 1
                     AND Check_User_Per_Iss_Cd2 (p_line_cd,
                                                A.iss_cd,
                                                p_module_id,
                                                p_underwriter
                                               ) = 1
                     AND par_status < 10
                     AND underwriter = NVL(p_underwriter, USER)
                     AND par_type = 'P'
                     AND c.pack_pol_flag != 'Y'
                     AND A.assd_no = b.assd_no
                     AND A.line_cd = c.line_cd
                     AND A.line_cd = p_line_cd
                 AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
                ORDER BY A.line_cd,
                         A.iss_cd,
                         A.par_yy,
                         A.par_seq_no,
                         A.quote_seq_no)
      LOOP
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.par_status := i.par_status;
         v_parlist.par_type := i.par_type;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         v_parlist.address1 := i.address1;
         v_parlist.address2 := i.address2;
         v_parlist.address3 := i.address3;
         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END get_gipi_parlist;

   PROCEDURE set_gipi_parlist (
      v_par_id         IN   gipi_parlist.par_id%TYPE,
      v_line_cd        IN   gipi_parlist.line_cd%TYPE,
      v_iss_cd         IN   gipi_parlist.iss_cd%TYPE,
      v_par_yy         IN   gipi_parlist.par_yy%TYPE,
      v_quote_seq_no   IN   gipi_parlist.quote_seq_no%TYPE,
      v_assd_no        IN   gipi_parlist.assd_no%TYPE,
      v_underwriter    IN   gipi_parlist.underwriter%TYPE,
      v_par_status     IN   gipi_parlist.par_status%TYPE,
      v_par_type       IN   gipi_parlist.par_type%TYPE,
      v_quote_id       IN   gipi_parlist.quote_id%TYPE,
      v_assign_sw      IN   gipi_parlist.assign_sw%TYPE,
      v_remarks        IN   gipi_parlist.remarks%TYPE
   )
   IS
      var_par_id   gipi_parlist.par_id%TYPE;
   BEGIN
      IF v_par_id IS NULL
      THEN
         SELECT parlist_par_id_s.NEXTVAL
           INTO var_par_id
           FROM DUAL;
      ELSE
         var_par_id := v_par_id;
      END IF;

      MERGE INTO gipi_parlist
         USING DUAL
         ON (par_id = var_par_id)
         WHEN NOT MATCHED THEN
            INSERT (par_id, line_cd, iss_cd, par_yy, quote_seq_no, assd_no,
                    underwriter, par_status, par_type, quote_id, assign_sw,
                    remarks)
            VALUES (var_par_id, v_line_cd, v_iss_cd, v_par_yy, v_quote_seq_no,
                    v_assd_no, v_underwriter, v_par_status, v_par_type,
                    v_quote_id, v_assign_sw, v_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET line_cd = v_line_cd, iss_cd = v_iss_cd, par_yy = v_par_yy,
                   quote_seq_no = v_quote_seq_no, assd_no = v_assd_no,
                   underwriter = v_underwriter, par_status = v_par_status,
                   par_type = v_par_type, quote_id = v_quote_id,
                   assign_sw = v_assign_sw, remarks = v_remarks
            ;
      COMMIT;
   END set_gipi_parlist;

   PROCEDURE del_gipi_parlist (p_par_id gipi_parlist.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_parlist
            WHERE par_id = p_par_id;

      COMMIT;
   END del_gipi_parlist;

   FUNCTION get_gipi_parlist_filtered (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_no        gipi_parlist.assd_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         cg_ref_codes.rv_meaning%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_parlist   gipi_parlist_type;
      v_user_sw   VARCHAR2 (1)      := 'N';
   BEGIN
      FOR x IN (SELECT '1'
                  FROM giis_users
                 WHERE user_id = NVL(p_underwriter, USER) AND NVL (all_user_sw, 'N') = 'Y')
      LOOP
         v_user_sw := 'Y';
         EXIT;
      END LOOP;

      FOR i IN (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy,
                         A.par_seq_no, A.quote_seq_no, A.assd_no, b.assd_name,
                         A.underwriter, c.pack_pol_flag, A.par_status,
                         d.rv_meaning status, A.par_type, A.quote_id,
                         A.assign_sw, A.remarks
                    FROM gipi_parlist A,
                         giis_assured b,
                         giis_line c,
                         cg_ref_codes d
                   WHERE A.assd_no = b.assd_no
                     AND A.line_cd = c.line_cd
                     AND A.par_status = d.rv_low_value
                     AND d.rv_domain = 'GIPI_PARLIST.PAR_STATUS'
                     AND A.line_cd = NVL (p_line_cd, A.line_cd)
                     AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
                     AND A.par_yy = NVL (p_par_yy, A.par_yy)
                     AND A.par_seq_no = NVL (p_par_seq_no, A.par_seq_no)
                     AND A.quote_seq_no = NVL (p_quote_seq_no, A.quote_seq_no)
                     AND A.assd_no = NVL (p_assd_no, A.assd_no)
                     AND b.assd_name = NVL (p_assd_name, b.assd_name)
                     AND A.underwriter = NVL (p_underwriter, A.underwriter)
                     AND d.rv_meaning = NVL (p_status, d.rv_meaning)
                     AND par_status < 10
                     AND par_type = 'P'
                     AND EXISTS (
                            SELECT DISTINCT line_cd, iss_cd
                                       FROM gipi_parlist gp
                                      WHERE 1 = 1
                                        AND assign_sw = 'Y'
                                        AND (   (    underwriter = NVL(p_underwriter, USER)
                                                 AND v_user_sw = 'N'
                                                )
                                             OR v_user_sw = 'Y'
                                            )
                                        /*AND EXISTS (
                                               SELECT h.line_cd, f.iss_cd
                                                 FROM giis_users E,
                                                      giis_user_iss_cd f,
                                                      giis_modules_tran G,
                                                      giis_user_line h
                                                WHERE 1 = 1
                                                  AND E.user_id = f.userid
                                                  AND E.user_id = NVL(p_underwriter, USER)
                                                  AND f.tran_cd = G.tran_cd
                                                  AND G.module_id =
                                                                   p_module_id
                                                  AND h.userid = f.userid
                                                  AND h.iss_cd = f.iss_cd
                                                  AND h.tran_cd = f.tran_cd
                                                  AND h.line_cd = gp.line_cd
                                                  AND h.iss_cd = gp.iss_cd
                                               UNION
                                               SELECT h.line_cd, f.iss_cd
                                                 FROM giis_users E,
                                                      giis_user_grp_dtl f,
                                                      giis_modules_tran G,
                                                      giis_user_grp_line h
                                                WHERE 1 = 1
                                                  AND E.user_id = NVL(p_underwriter, USER)
                                                  AND E.user_grp = f.user_grp
                                                  AND f.tran_cd = G.tran_cd
                                                  AND G.module_id =
                                                                   p_module_id
                                                  AND h.user_grp = f.user_grp
                                                  AND h.iss_cd = f.iss_cd
                                                  AND h.tran_cd = f.tran_cd
                                                  AND h.line_cd = gp.line_cd
                                                  AND h.iss_cd = gp.iss_cd)-- commented out and replaced by steven 07.01.2013; base on enhancement made in the CS version*/
                                            AND check_user_per_iss_cd2(gp.line_cd, gp.iss_cd, p_module_id, NVL(p_underwriter, USER)) = 1) /* steven 07.01.2013 */ 
                     AND A.pack_par_id IS NULL
                ORDER BY A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no)
      LOOP
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.par_status := i.par_status;
         v_parlist.status := i.status;
         v_parlist.par_type := i.par_type;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END get_gipi_parlist_filtered;

   FUNCTION get_gipi_parlist (p_par_id gipi_parlist.par_id%TYPE)
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_parlist     gipi_parlist_type;
      v_assd_name   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN (SELECT A.par_id, A.assd_no, /*b.assd_name,*/ A.line_cd,
                       c.line_name, A.iss_cd, A.par_yy, A.quote_seq_no,
                       A.par_type, A.assign_sw, A.par_status, A.remarks,
                       A.underwriter, A.quote_id, A.par_seq_no, A.address1,
                       A.address2, A.address3,
                       TO_CHAR (A.par_seq_no, '000099') par_seq_no_c,
                       c.pack_pol_flag, d.pol_flag, d.subline_cd,
                       d.pol_seq_no, d.issue_yy,                --, e.op_flag
                                                d.renew_no, d.incept_date,
                       d.expiry_date, d.eff_date, d.endt_expiry_date,
                       d.short_rt_percent, d.comp_sw, d.prorate_flag,
                       d.prov_prem_tag, d.prov_prem_pct, d.with_tariff_sw
                  FROM gipi_parlist A
                                     --,GIIS_ASSURED b
                       , giis_line c, gipi_wpolbas d
                 --,GIIS_SUBLINE e
                WHERE  A.par_id = p_par_id
                   --AND a.assd_no            = b.assd_no
                   AND c.line_cd = A.line_cd
                   AND A.par_id = d.par_id(+)
                                             --AND d.line_cd               = e.line_cd
                                             --AND d.subline_cd            = e.subline_cd
              )
      LOOP
         SELECT op_flag
           INTO v_parlist.op_flag
           FROM (SELECT *
                   FROM TABLE
                           (giis_subline_pkg.get_subline_details (i.line_cd,
                                                                  i.subline_cd
                                                                 )
                           ));

         BEGIN
            SELECT dist_no
              INTO v_parlist.dist_no
              FROM giuw_pol_dist
             WHERE par_id = p_par_id AND ROWNUM = 1;
                   --ADDED BY TONIO to remove exact fetch sql error 11/10/2010
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT assd_name
              INTO v_assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
         
         --added by belle 05.22.2012 to check if posted binder exist
         BEGIN
            FOR binder IN (SELECT count(*) count
                        FROM GIPI_WPOLBAS a, GIUW_POL_DIST b, GIRI_DISTFRPS c, GIRI_FRPS_RI d, GIRI_BINDER e
                       WHERE a.par_id = b.par_id
                         AND b.dist_no = c.dist_no
                         AND c.line_cd = d.line_cd
                         AND c.frps_yy = d.frps_yy
                         AND c.frps_seq_no = d.frps_seq_no
                         AND d.fnl_binder_id = e.fnl_binder_id
                         AND a.par_id = i.par_id)
            LOOP
                IF binder.count > 0 THEN
                    v_parlist.binder_exist := 'Y';
                ELSE 
                    v_parlist.binder_exist := 'N';
                END IF;
            END LOOP;
         END;

         v_parlist.par_no := gipi_parlist_pkg.get_par_no (i.par_id);
         v_parlist.par_id := i.par_id;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := v_assd_name;
         v_parlist.line_cd := i.line_cd;
         v_parlist.line_name := i.line_name;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.par_type := i.par_type;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.par_status := i.par_status;
         v_parlist.remarks := i.remarks;
         v_parlist.underwriter := i.underwriter;
         v_parlist.quote_id := i.quote_id;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.par_seq_no_c := RTRIM (LTRIM (i.par_seq_no_c));
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.pol_flag := i.pol_flag;
         v_parlist.subline_cd := i.subline_cd;
         --v_parlist.op_flag           := i.op_flag;
         v_parlist.pol_seq_no := i.pol_seq_no;
         v_parlist.issue_yy := i.issue_yy;
         v_parlist.disc_exists :=
                  gipi_wperil_discount_pkg.check_if_discount_exists (p_par_id);
         v_parlist.endt_policy_id :=
            get_policy_id (i.line_cd,
                           i.subline_cd,
                           i.iss_cd,
                           i.issue_yy,
                           i.pol_seq_no,
                           i.renew_no
                          );                               --andrew 06.07.2010
         v_parlist.endt_policy_no := get_policy_no (v_parlist.endt_policy_id);
         --andrew 06.07.2010
         v_parlist.incept_date := i.incept_date;           --andrew 06.11.2010
         v_parlist.expiry_date := i.expiry_date;           --andrew 06.11.2010
         v_parlist.eff_date := i.eff_date;                 --andrew 06.11.2010
         v_parlist.endt_expiry_date := i.endt_expiry_date; --andrew 06.11.2010
         v_parlist.short_rt_percent := i.short_rt_percent; --andrew 06.11.2010
         v_parlist.comp_sw := i.comp_sw;
         v_parlist.prorate_flag := i.prorate_flag;
         v_parlist.prov_prem_tag := i.prov_prem_tag;
         v_parlist.prov_prem_pct := i.prov_prem_pct;
         v_parlist.with_tariff_sw := i.with_tariff_sw;
         v_parlist.line_motor := giis_parameters_pkg.v ('MOTOR CAR');
         v_parlist.line_fire := giis_parameters_pkg.v ('FIRE');
         v_parlist.ctpl_cd := giis_parameters_pkg.n ('CTPL');
         v_parlist.back_endt := get_back_endt_status (p_par_id);
         v_parlist.endt_tax := get_back_endt_status (p_par_id);
         v_parlist.address1 := i.address1;
         v_parlist.address2 := i.address2;
         v_parlist.address3 := i.address3;
         v_parlist.renew_no := i.renew_no;
		 v_parlist.str_expiry_date:= to_char(i.expiry_date,'MM-DD-YYYY'); -- irwin 7.24.2012
		 v_parlist.str_incept_date := to_char(i.incept_date, 'mm-dd-yyyy');
         gipi_winvoice_pkg.get_gipi_winvoice_exist
                                                (p_par_id,
                                                 v_parlist.gipi_winvoice_exist
                                                );
         gipi_winv_tax_pkg.get_gipi_winv_tax_exist
                                                (p_par_id,
                                                 v_parlist.gipi_winv_tax_exist
                                                );
         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END get_gipi_parlist;

   /*for GIPIS038*/
   FUNCTION get_gipi_parlist (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_parlist   gipi_parlist_type;
   BEGIN
      FOR i IN (SELECT A.par_id, A.assd_no, b.assd_name, A.line_cd,
                       f.line_name, A.iss_cd, A.par_yy, A.quote_seq_no,
                       A.par_type, A.assign_sw, A.par_status, A.remarks,
                       A.underwriter, A.quote_id, A.par_seq_no,
                       d.subline_name, A.address1, A.address2, A.address3,
                       NVL (f.pack_pol_flag, 'N') pack_pol_flag,
                          c.line_cd
                       || ' - '
                       || c.iss_cd
                       || ' - '
                       || TO_CHAR (c.par_yy, '09')
                       || ' - '
                       || TO_CHAR (c.par_seq_no, '099999')
                       || ' - '
                       || TO_CHAR (c.quote_seq_no, '09') pack_par_no
                  FROM gipi_parlist A,
                       giis_assured b,
                       gipi_pack_parlist c,
                       giis_subline d,
                       gipi_wpack_line_subline E,
                       giis_line f
                 WHERE A.assd_no = b.assd_no
                   AND A.par_id = p_par_id
                   AND c.pack_par_id = p_pack_par_id
                   AND d.line_cd = E.pack_line_cd
                   AND d.subline_cd = E.pack_subline_cd
                   AND E.pack_par_id = p_pack_par_id
                   AND E.par_id = p_par_id
                   AND f.line_cd = A.line_cd)
      LOOP
         get_par_seq_no (v_parlist.par_no,
                         i.quote_seq_no,
                         i.par_yy,
                         i.par_seq_no,
                         i.line_cd,
                         i.iss_cd
                        );
         v_parlist.par_id := i.par_id;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.line_cd := i.line_cd;
         v_parlist.line_name := i.line_name;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.par_type := i.par_type;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.par_status := i.par_status;
         v_parlist.remarks := i.remarks;
         v_parlist.underwriter := i.underwriter;
         v_parlist.quote_id := i.quote_id;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.subline_name := i.subline_name;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.pack_par_no := i.pack_par_no;
         v_parlist.address1 := i.address1;
         v_parlist.address2 := i.address2;
         v_parlist.address3 := i.address3;

         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END get_gipi_parlist;

   PROCEDURE save_par (p_gipi_par IN gipi_parlist%ROWTYPE)
   IS
      par                       gipi_parlist%ROWTYPE;
      v_assign_sw               VARCHAR2 (1);
      v_raise_no_data_found     VARCHAR2 (30);
      v_cgte$other_exceptions   VARCHAR2 (30);
      v_par_id                  NUMBER;
      v_quote_id                NUMBER; --edgar 10/15/2014     
   BEGIN
      par := p_gipi_par;
      v_assign_sw := giis_parameters_pkg.v ('AUTOMATIC_PAR_ASSIGNMENT_FLAG');

      IF v_assign_sw = 'Y'
      THEN
         par.assign_sw := 'Y';
         par.par_status := 2;
      ELSE
         par.assign_sw := 'N';
         par.par_status := 1;
      END IF;

      IF (giis_parameters_pkg.check_param_by_iss_cd (par.iss_cd) = 'Y')
      THEN
         par.assign_sw := 'Y';
         par.par_status := '2';
      END IF;

      BEGIN
         check_unique_par (par.quote_seq_no,
                           par.par_seq_no,
                           par.par_yy,
                           par.iss_cd,
                           par.line_cd,
                           TRUE,
                           v_raise_no_data_found,
                           v_cgte$other_exceptions
                          );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;                                    --CGTE$OTHER_EXCEPTIONS;
      END;

      BEGIN
         v_assign_sw :=
                      giis_parameters_pkg.v ('AUTOMATIC_PAR_ASSIGNMENT_FLAG');

         IF v_assign_sw = 'Y'
         THEN
            par.assign_sw := 'Y';
            par.par_status := 2;
         ELSE
            par.assign_sw := 'N';
            par.par_status := 1;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            par.assign_sw := 'N';
            par.par_status := 1;
      END;

      gipi_parlist_pkg.save_parlist (par);
      /*added edgar 10/15/2014 to correct par_status when coming from qoutation*/
        BEGIN
           FOR parlist IN (SELECT par_id, quote_id
                             FROM gipi_parlist
                            WHERE par_id = par.par_id)
           LOOP
              v_par_id := parlist.par_id;
              v_quote_id := parlist.quote_id;
           END LOOP;

           IF v_quote_id IS NOT NULL
           THEN
              FOR polbas IN (SELECT '1'
                               FROM gipi_wpolbas
                              WHERE par_id = v_par_id)
              LOOP
                 UPDATE gipi_parlist
                    SET par_status = 3
                  WHERE par_id = v_par_id;
              END LOOP;

              FOR item IN (SELECT '1'
                             FROM gipi_witem
                            WHERE par_id = v_par_id)
              LOOP
                 UPDATE gipi_parlist
                    SET par_status = 3
                  WHERE par_id = v_par_id;

                 EXIT;
              END LOOP;

              FOR item IN (SELECT '1'
                             FROM gipi_witmperl
                            WHERE par_id = v_par_id)
              LOOP
                 UPDATE gipi_parlist
                    SET par_status = 5
                  WHERE par_id = v_par_id;

                 EXIT;
              END LOOP;
           END IF;
        END;
      /*ended edgar 10/15/2014*/
      FOR A IN (SELECT par_seq_no
                  FROM gipi_parlist
                 WHERE par_id = par.par_id)
      LOOP
         par.par_seq_no := A.par_seq_no;
         EXIT;
      END LOOP;

      gipi_parhist_pkg.check_parhist (par.par_id, par.underwriter);
   --COMMIT; ommited for transaction BRYAN
   END save_par;

   PROCEDURE save_parlist (p_gipi_par IN gipi_parlist%ROWTYPE)
   IS
      par   gipi_parlist%ROWTYPE;
   BEGIN
      --lineCd, issCd, parYy, parSeqNo, quoteSeqNo
      par := p_gipi_par;
      MERGE INTO gipi_parlist
         USING DUAL
         ON (par_id = par.par_id)
         WHEN NOT MATCHED THEN
            INSERT (par_id, line_cd, iss_cd, par_yy, quote_seq_no, assd_no,
                    underwriter, par_status, par_type, quote_id, assign_sw,
                    remarks)
            VALUES (par.par_id, par.line_cd, par.iss_cd, par.par_yy,
                    par.quote_seq_no, par.assd_no, par.underwriter,
                    par.par_status, par.par_type, par.quote_id,
                    par.assign_sw, par.remarks)
         WHEN MATCHED THEN
            UPDATE
               SET line_cd = par.line_cd, iss_cd = par.iss_cd,
                   par_yy = par.par_yy, quote_seq_no = par.quote_seq_no,
                   assd_no = par.assd_no, underwriter = par.underwriter,
                   par_status = par.par_status, par_type = par.par_type,
                   quote_id = par.quote_id, assign_sw = par.assign_sw,
                   remarks = par.remarks
            ;
   --COMMIT; commented for transaction purposes BRYAN
   END save_parlist;

   --formerly Cgfd$get_B240_Drv_Par_Gipis002
   PROCEDURE get_par_seq_no (
      p_drv_par_seq_no   IN OUT   VARCHAR2,
      p_quote_seq_no     IN       NUMBER,
      p_par_yy           IN       NUMBER,
      p_par_seq_no       IN       NUMBER,
      p_line_cd          IN       VARCHAR2,
      p_iss_cd           IN       VARCHAR2
   )
   IS
   BEGIN
      p_drv_par_seq_no :=
            p_line_cd
         || '-'
         || p_iss_cd
         || '-'
         || LTRIM (TO_CHAR (p_par_yy, '09'))
         || '-'
         || LTRIM (TO_CHAR (p_par_seq_no, '099999'))
         || '-'
         || LTRIM (TO_CHAR (p_quote_seq_no, '09'));
   END get_par_seq_no;

   --formerly CGUV$CHK_PARLIST_U1_GIPIS050
   PROCEDURE check_unique_par (
      p_quote_seq_no            IN       NUMBER,
      p_par_seq_no              IN       NUMBER,
      p_par_yy                  IN       NUMBER,
      p_iss_cd                  IN       VARCHAR2,
      p_line_cd                 IN       VARCHAR2,
      p_field_level             IN       BOOLEAN,
      v_raise_no_data_found     OUT      VARCHAR2,
      v_cgte$other_exceptions   OUT      VARCHAR2
   )
   IS
      cg$dummy   VARCHAR2 (1);

      CURSOR c
      IS
         SELECT '1'
           FROM gipi_parlist
          WHERE line_cd = p_line_cd
            AND iss_cd = p_iss_cd
            AND par_yy = p_par_yy
            AND par_seq_no = p_par_seq_no
            AND quote_seq_no = p_quote_seq_no;
   BEGIN
      OPEN c;

      FETCH c
       INTO cg$dummy;

      IF c%NOTFOUND
      THEN
         v_raise_no_data_found := 'Y';
      END IF;

      CLOSE c;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_cgte$other_exceptions := 'Y';
   END check_unique_par;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.15.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Get Par No of a given par_id
   */
   FUNCTION get_par_no (p_par_id NUMBER)
      RETURN VARCHAR2
   IS
      v_par   VARCHAR2 (40);
   BEGIN
      FOR A IN (SELECT    line_cd
                       || ' - '
                       || iss_cd
                       || ' - '
                       || LTRIM (TO_CHAR (par_yy, '09'))
                       || ' - '
                       || LTRIM (TO_CHAR (par_seq_no, '099999'))
                       || ' - '
                       || LTRIM (TO_CHAR (quote_seq_no, '09')) par_no
                  FROM gipi_parlist
                 WHERE par_id = p_par_id)
      LOOP
         v_par := A.par_no;
         EXIT;
      END LOOP;

      RETURN (v_par);
   END get_par_no;

   FUNCTION get_par_no_2(p_policy_id NUMBER)
      RETURN VARCHAR2
   IS
      v_par_no VARCHAR2(40);
   BEGIN 
      SELECT line_cd || '-' || iss_cd || '-' ||
             LTRIM(TO_CHAR(par_yy, '09')) || '-' ||
             LTRIM(TO_CHAR(par_seq_no, '099999')) || '-' ||
             LTRIM(TO_CHAR(quote_seq_no, '09'))
             AS par_no
        INTO v_par_no
        FROM gipi_parlist
       WHERE par_id = (
                SELECT par_id
                  FROM gipi_polbasic
                 WHERE policy_id = p_policy_id
             );
      RETURN (NVL(v_par_no, ''));
   END get_par_no_2;

   /*
   **  Created by  : Menandro Robes
   **  Date Created   : February 16, 2010
   **  Reference By   : (GIPIS002 - Renewal/Replacement Details)
   **  Description    : This function returns the rec_flag (par_type) of the given par_id
   */
   FUNCTION get_rec_flag (p_par_id IN gipi_parlist.par_id%TYPE)
      --par_id to limit the query
   RETURN gipi_parlist.par_type%TYPE
   IS
      v_par_type   gipi_parlist.par_type%TYPE;
   BEGIN
      SELECT NVL (par_type, 'P')
        INTO v_par_type
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      IF v_par_type = 'P'
      THEN
         v_par_type := 'A';
      ELSE
         v_par_type := 'D';
      END IF;

      RETURN v_par_type;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE;
   END get_rec_flag;

/*
  **  Created by  : Bryan Joseph G. Abuluyan
  **  Date Created   : February 17, 2010
  **  Reference By   : (GIPIS050 - PAR Creation - Select Quotation
  **  Description    : This checks whether a PAR has an existing record in GIPI_QUOTE or GIPI_POLBAS table
  */
   FUNCTION check_par_quote (p_par_id gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2
   IS
      with_quote       gipi_quote.quote_id%TYPE;
      with_info        gipi_polbasic.par_id%TYPE;
      par_quote_stat   VARCHAR2 (1)                := NULL;
   BEGIN
      SELECT A.quote_id
        INTO with_quote
        FROM gipi_parlist A, gipi_quote b
       WHERE A.quote_id = b.quote_id AND par_id = p_par_id;

      IF with_quote IS NOT NULL
      THEN
         par_quote_stat := 'Q';
      ELSE
         SELECT par_id
           INTO with_info
           FROM gipi_polbasic
          WHERE par_id = p_par_id;

         IF with_info IS NOT NULL
         THEN
            par_quote_stat := 'I';
         END IF;
      END IF;

      RETURN par_quote_stat;
   END;

   PROCEDURE update_status_from_quote (
      p_quote_id     gipi_parlist.quote_id%TYPE,
      p_par_status   gipi_parlist.par_status%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_parlist
         SET par_status = p_par_status
       WHERE quote_id = p_quote_id;
   END update_status_from_quote;

/*
  **  Created by  : Bryan Joseph G. Abuluyan
  **  Date Created   : March 9, 2010
  **  Reference By   : (GIPIS038 - Peril Information (Commit Form)
  **  Description    : This deletes all unnecessary records of PAR when peril is created
  */
   PROCEDURE delete_bill_details (p_par_id gipi_parlist.par_id%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_winstallment
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wcomm_inv_perils
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wcomm_invoices
            WHERE par_id = p_par_id;

      DELETE FROM gipi_winvperl
            WHERE par_id = p_par_id;

      DELETE FROM gipi_winv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wpackage_inv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_winvoice
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_invperl
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_inv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_invoice
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_itmperil
            WHERE par_id = p_par_id;

      DELETE FROM gipi_co_insurer
            WHERE par_id = p_par_id;

      DELETE FROM gipi_main_co_ins
            WHERE par_id = p_par_id;
   END delete_bill_details;

/*
  **  Created by  : Bryan Joseph G. Abuluyan
  **  Date Created   : March 9, 2010
  **  Reference By   : (GIPIS038 - Peril Information
  **  Description    : This sets the value of PAR-STATUS when pack_par_id is not null
  */
   PROCEDURE set_status_wperil (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
   IS
      v_count        NUMBER;
      v_pack_count   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM gipi_witem
       WHERE par_id = p_par_id AND NOT EXISTS (SELECT item_no
                                                 FROM gipi_witmperl
                                                WHERE par_id = p_par_id);

      --AND ITEM_NO = GIPI_WITEM.ITEM_NO);
      IF v_count = 0
      THEN
         UPDATE gipi_parlist
            SET par_status = 5
          WHERE par_id = p_par_id;
      ELSE
         UPDATE gipi_parlist
            SET par_status = 4
          WHERE par_id = p_par_id;
      END IF;

      SELECT COUNT (*)
        INTO v_pack_count
        FROM gipi_witem A, gipi_parlist b
       WHERE 1 = 1
         AND A.par_id = b.par_id
         AND b.pack_par_id = p_pack_par_id
         AND b.par_status NOT IN (98, 99)                  --A.R.C. 08.31.2006
         AND NOT EXISTS (SELECT item_no
                           FROM gipi_witmperl
                          WHERE par_id = A.par_id AND item_no = A.item_no);

      IF v_pack_count = 0
      THEN
         UPDATE gipi_pack_parlist
            SET par_status = 5
          WHERE pack_par_id = p_pack_par_id;
      ELSE
         UPDATE gipi_pack_parlist
            SET par_status = 4
          WHERE pack_par_id = p_pack_par_id;
      END IF;
   END set_status_wperil;

/*
  **  Created by  : Bryan Joseph G. Abuluyan
  **  Date Created   : March 9, 2010
  **  Reference By   : (GIPIS038 - Peril Information
  **  Description    : This sets the value of PAR-STATUS when pack_par_id is null
  */
   PROCEDURE set_status_wperil (p_par_id gipi_parlist.par_id%TYPE)
   IS
      v_count   NUMBER (5);
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM gipi_witem
       WHERE par_id = p_par_id AND NOT EXISTS (SELECT item_no
                                                 FROM gipi_witmperl
                                                WHERE par_id = p_par_id);

      --AND ITEM_NO = GIPI_WITEM.ITEM_NO);
      IF v_count = 0
      THEN
         UPDATE gipi_parlist
            SET par_status = 5
          WHERE par_id = p_par_id;
      ELSE
         UPDATE gipi_parlist
            SET par_status = 4
          WHERE par_id = p_par_id;
      END IF;
   END set_status_wperil;

   /*
   **  Created by  : Menandro G.C. Robes
   **  Date Created   : March 22, 2010
   **  Reference By   : (SET_LIMIT_INTO_GIPI_WITMPERL)
   **  Description    : Procedure to update par status.
   */
   PROCEDURE update_par_status (
      p_par_id       IN   gipi_parlist.par_id%TYPE,
      --par_id of par to be updated.
      p_par_status   IN   gipi_parlist.par_status%TYPE
   )                                                          --new par status
   IS
   BEGIN
      UPDATE gipi_parlist
         SET par_status = p_par_status
       WHERE par_id = p_par_id;
   END update_par_status;

   /*Created by: Cris Castro
     Date: 04/20/2010
    for GIPIS058(Endorsement par list)
   */
   FUNCTION get_endt_parlist (
      p_line_cd     gipi_parlist.line_cd%TYPE,
      p_iss_cd      gipi_parlist.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_keyword     VARCHAR2,
      p_user_id giis_users.user_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_parlist   gipi_parlist_type;
   BEGIN
      FOR i IN
         (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.underwriter, c.pack_pol_flag,
                   cg_ref_codes_pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                   A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '009') par_no
              FROM gipi_parlist A, giis_line c
             WHERE check_user_per_line2 (A.line_cd, p_iss_cd, p_module_id, p_user_id) = 1
               AND Check_User_Per_Iss_Cd2 (p_line_cd, A.iss_cd, p_module_id, p_user_id) =
                                                                             1
               AND A.line_cd || '-' || A.iss_cd IN (
                      SELECT line_cd || '-' || iss_cd
                        FROM TABLE
                                (gipi_parlist_pkg.parlist_security
                                                                  (p_module_id, p_user_id)
                                ))
               AND A.pack_par_id IS NULL
               AND par_status BETWEEN 2 AND 9
               AND A.line_cd = c.line_cd
               AND underwriter LIKE (check_accessible_records ())
               AND par_type = 'E'
               AND A.line_cd = p_line_cd
               AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
               AND c.pack_pol_flag != 'Y'
               AND A.assign_sw = 'Y'
               AND (   UPPER (A.iss_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_yy) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (A.par_seq_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.quote_seq_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (A.underwriter) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER
                          (cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                          ) LIKE '%' || UPPER (p_keyword) || '%'
                   )
          ORDER BY    A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '009') DESC)
      LOOP
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
      --v_parlist.assd_no         := i.assd_no;
--    v_parlist.assd_name         := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.status := i.status;
         v_parlist.par_type := i.par_type;
         v_parlist.par_status := i.par_status;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         v_parlist.par_no := i.par_no;
      -- v_parlist.pol_flag          := i.pol_flag;
--        v_parlist.subline_cd       := i.subline_cd;
      --  v_parlist.op_flag           := i.op_flag;
      --  v_parlist.pol_seq_no       := i.pol_seq_no;
       -- v_parlist.issue_yy          := i.issue_yy;
         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END get_endt_parlist;

   PROCEDURE get_line_cd_iss_cd (
      p_par_id    IN       gipi_parlist.par_id%TYPE,
      p_line_cd   OUT      gipi_parlist.line_cd%TYPE,
      p_iss_cd    OUT      gipi_parlist.iss_cd%TYPE
   )
   IS
   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.29.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : Retrieves line_cd and iss_cd based on the par_id
   */
   BEGIN
      FOR i IN (SELECT line_cd, iss_cd
                  FROM gipi_parlist
                 WHERE par_id = p_par_id)
      LOOP
         p_line_cd := i.line_cd;
         p_iss_cd := i.iss_cd;
         EXIT;
      END LOOP;
   END get_line_cd_iss_cd;

   FUNCTION parlist_security (p_module_id VARCHAR2,
                              p_user_id    GIIS_USERS.user_id%TYPE)
      RETURN parlist_security_tab PIPELINED
   IS
      v_line_iss   parlist_security_type;
   BEGIN
      FOR line IN (SELECT d.line_cd, b.iss_cd
                     FROM giis_users A,
                          giis_user_iss_cd b,
                          giis_modules_tran c,
                          giis_user_line d
                    WHERE 1 = 1
                      AND A.user_id = b.userid
                      AND A.user_id = NVL(p_user_id, USER)
                      AND b.tran_cd = c.tran_cd
                      AND c.module_id = p_module_id
                      AND d.userid = b.userid
                      AND d.iss_cd = b.iss_cd
                      AND d.tran_cd = b.tran_cd
                   UNION
                   SELECT d.line_cd, b.iss_cd
                     FROM giis_users A,
                          giis_user_grp_dtl b,
                          giis_modules_tran c,
                          giis_user_grp_line d
                    WHERE 1 = 1
                      AND A.user_id = NVL(p_user_id, USER)
                      AND A.user_grp = b.user_grp
                      AND b.tran_cd = c.tran_cd
                      AND c.module_id = p_module_id
                      AND d.user_grp = b.user_grp
                      AND d.iss_cd = b.iss_cd
                      AND d.tran_cd = b.tran_cd)
      LOOP
         v_line_iss.line_cd := line.line_cd;
         v_line_iss.iss_cd := line.iss_cd;
         PIPE ROW (v_line_iss);
      END LOOP;

      RETURN;
   END parlist_security;

   -- copy par list related procs
   PROCEDURE copy_parlist (
      p_par_id                 NUMBER,
      p_user_id                VARCHAR2,
      p_line_cd                giis_line.line_cd%TYPE,
      p_iss_cd                 gipi_invoice.iss_cd%TYPE,
      p_new_par_id       OUT   NUMBER,
      p_open_flag        OUT   VARCHAR2,
      p_menu_line        OUT   giis_line.menu_line_cd%TYPE,
      p_new_par_seq_no   OUT   gipi_parlist.par_seq_no%TYPE,
      p_par_no           OUT   VARCHAR2
   )
   IS
      v_line_cd          gipi_parlist.line_cd%TYPE;
      v_iss_cd           gipi_parlist.iss_cd%TYPE;
      v_par_yy           gipi_parlist.par_yy%TYPE;
      v_new_par_seq_no   gipi_parlist.par_seq_no%TYPE;
      v_quote_seq_no     gipi_parlist.quote_seq_no%TYPE;
   BEGIN
      p_open_flag := 'N';

      SELECT line_cd, iss_cd, par_yy, quote_seq_no
        INTO v_line_cd, v_iss_cd, v_par_yy, v_quote_seq_no
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      -- get par id sequence
      SELECT parlist_par_id_s.NEXTVAL
        INTO p_new_par_id
        FROM DUAL;

      -- insert data to gipi_parlist
      FOR i IN (SELECT line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no,
                       par_type, assd_no, remarks, underwriter, assign_sw,
                       par_status, address1, address2, address3, load_tag
                  FROM gipi_parlist
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_parlist
                     (par_id, line_cd, iss_cd, par_yy,
                      par_seq_no, quote_seq_no, par_type, assd_no,
                      remarks, underwriter, assign_sw, par_status, address1,
                      address2, address3, load_tag
                     )
              VALUES (p_new_par_id, i.line_cd, i.iss_cd, TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'YYYY'),3,2)), --i.par_yy, (updated par_yy to sysdate) nica 04.14.2011
                      i.par_seq_no, i.quote_seq_no, i.par_type, i.assd_no,
                      i.remarks, p_user_id, 'Y', i.par_status, i.address1,
                      i.address2, i.address3, 'P'
                     );
      END LOOP;

      SELECT menu_line_cd
        INTO p_menu_line
        FROM giis_line
       WHERE line_cd = p_line_cd;

      /* BETH 011399 get op_flag to determine if the policy
      **             is an open oplicy or not
      */
      FOR s IN (SELECT subline_cd
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         FOR flag IN (SELECT op_flag
                        FROM giis_subline
                       WHERE line_cd = p_line_cd
                             AND subline_cd = s.subline_cd)
         LOOP
            p_open_flag := flag.op_flag;
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

      FOR c IN (SELECT par_seq_no
                  FROM gipi_parlist
                 WHERE par_id = p_new_par_id)
      LOOP
         p_new_par_seq_no := c.par_seq_no;
         EXIT;
      END LOOP;

      p_par_no :=
            v_line_cd
         || ' - '
         || v_iss_cd
         || ' - '
         || TO_CHAR (v_par_yy, '09')
         || ' - '
         || LTRIM (TO_CHAR (p_new_par_seq_no, '099999'))
         || ' - '
         || LTRIM (TO_CHAR (v_quote_seq_no, '09'));
   END copy_parlist;

   -- copy_wpolbas edited by: nica 04.14.2011
   PROCEDURE copy_wpolbas (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   
    v_policy_days            NUMBER;
    v_booking_mth           GIPI_WPOLBAS.booking_mth%TYPE;
    v_booking_year          GIPI_WPOLBAS.booking_year%TYPE;
   
   BEGIN
      
      FOR i IN (SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
                       endt_iss_cd, endt_yy, endt_seq_no, 0 renew_no,/*renew_no,*/ --added by steven 07.01.2013; base on enhancement made in the CS version
                       endt_type, incept_date, expiry_date, issue_date,
                       eff_date, pol_flag, foreign_acc_sw, assd_no,
                       designation, address1, address2, address3, mortg_name,
                       tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
                       invoice_sw, pool_pol_no, orig_policy_id,
                       endt_expiry_date, no_of_items, subline_type_cd,
                       auto_renew_flag, prorate_flag, prov_prem_tag, type_cd,
                       acct_of_cd, prov_prem_pct, same_polno_sw,
                       pack_pol_flag, expiry_tag, prem_warr_tag, ref_pol_no,
                       ref_open_pol_no, reg_policy_sw, co_insurance_sw,
                       discount_sw, fleet_print_tag, incept_tag, comp_sw,
                       manual_renew_no, with_tariff_sw, short_rt_percent,
                       place_cd, surcharge_sw, takeup_term, validate_tag, 
                       industry_cd, region_cd, cred_branch,
                       endt_expiry_tag, cover_nt_printed_date, cover_nt_printed_cnt, 
                       back_stat, qd_flag, acct_of_cd_sw,
                       old_assd_no, cancel_date, label_tag, 
                       old_address1, old_address2, old_address3, 
                       risk_tag, pack_par_id, survey_agent_cd, 
                       settling_agent_cd, prem_warr_days
                  FROM GIPI_WPOLBAS
                 WHERE par_id = p_par_id)
      LOOP
          
         IF TRUNC(i.expiry_date - i.incept_date) = 31 THEN
            v_policy_days      := 30;
         ELSE
            v_policy_days      := TRUNC(i.expiry_date - i.incept_date);
         END IF;
         
         GET_BOOK_DATE_FOR_COPIED_PAR(i.issue_date, i.incept_date, v_booking_mth, v_booking_year);
         
         INSERT INTO GIPI_WPOLBAS
             (par_id,             line_cd,             iss_cd,             subline_cd,
              issue_yy,         pol_seq_no,         endt_iss_cd,         endt_yy,
              endt_seq_no,         renew_no,             endt_type,             incept_date,
              expiry_date,         issue_date,         booking_year,         booking_mth, 
              eff_date,         pol_flag,            foreign_acc_sw,     assd_no, 
              designation,        address1,             address2,             address3, 
              mortg_name,        tsi_amt,             prem_amt,             ann_tsi_amt, 
              ann_prem_amt,        invoice_sw,         pool_pol_no,         user_id,
              orig_policy_id,     endt_expiry_date,     no_of_items,        subline_type_cd,     
              auto_renew_flag,     prorate_flag,        prov_prem_tag,         type_cd, 
              acct_of_cd,        prov_prem_pct,         same_polno_sw,         pack_pol_flag,
              expiry_tag,         prem_warr_tag,         ref_open_pol_no,    reg_policy_sw, 
              co_insurance_sw,     discount_sw,        fleet_print_tag,     incept_tag, 
              comp_sw,            manual_renew_no,     with_tariff_sw,     covernote_printed_sw,
              quotation_printed_sw, short_rt_percent, place_cd,            surcharge_sw, 
              takeup_term,         validate_tag,         industry_cd,         region_cd, 
              cred_branch,         endt_expiry_tag,     cover_nt_printed_date, cover_nt_printed_cnt, 
              back_stat,         qd_flag,             acct_of_cd_sw,         old_assd_no, 
              cancel_date,         label_tag,             old_address1,         old_address2, 
              old_address3,     risk_tag,             pack_par_id,         survey_agent_cd, 
              settling_agent_cd, prem_warr_days
             )
       VALUES (p_new_par_id,     i.line_cd,             i.iss_cd,             i.subline_cd,
              TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'YYYY'),3,2)),             i.pol_seq_no,         i.endt_iss_cd,         i.endt_yy,
              i.endt_seq_no,     i.renew_no,         i.endt_type,         SYSDATE,
              SYSDATE + v_policy_days, SYSDATE,     v_booking_year,        v_booking_mth,
              SYSDATE,             '1',                    i.foreign_acc_sw,     i.assd_no, 
              i.designation,    i.address1,         i.address2,         i.address3, 
              i.mortg_name,        i.tsi_amt,             i.prem_amt,         i.ann_tsi_amt, 
              i.ann_prem_amt,    i.invoice_sw,         i.pool_pol_no,         p_user_id,
              i.orig_policy_id, i.endt_expiry_date, i.no_of_items,        i.subline_type_cd, 
              i.auto_renew_flag, i.prorate_flag,    i.prov_prem_tag,     i.type_cd, 
              i.acct_of_cd,        i.prov_prem_pct,     i.same_polno_sw,     i.pack_pol_flag,
              i.expiry_tag,     i.prem_warr_tag,     i.ref_open_pol_no,    i.reg_policy_sw, 
              i.co_insurance_sw, i.discount_sw,        i.fleet_print_tag,  i.incept_tag, 
              i.comp_sw,        0,/*i.manual_renew_no,*/ /*added by steven 07.01.2013; base on enhancement made in the CS version*/ 
			  											 i.with_tariff_sw,     'N',
              'N',                 i.short_rt_percent, i.place_cd,            i.surcharge_sw, 
              i.takeup_term,    i.validate_tag,     i.industry_cd,         i.region_cd, 
              i.cred_branch,     i.endt_expiry_tag,  i.cover_nt_printed_date, i.cover_nt_printed_cnt, 
              i.back_stat,         i.qd_flag,             i.acct_of_cd_sw,     i.old_assd_no, 
              i.cancel_date,     i.label_tag,         i.old_address1,     i.old_address2, 
              i.old_address3,     i.risk_tag,         i.pack_par_id,         i.survey_agent_cd, 
              i.settling_agent_cd, i.prem_warr_days
        );

      END LOOP;
   END;

   -- copy_wpolgenin
   PROCEDURE copy_wpolgenin (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT gen_info, gen_info01, gen_info02, gen_info03,
                       gen_info04, gen_info05, gen_info06, gen_info07,
                       gen_info08, gen_info09, gen_info10, gen_info11,
                       gen_info12, gen_info13, gen_info14, gen_info15,
                       gen_info16, gen_info17, first_info
                  FROM gipi_wpolgenin
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wpolgenin
                     (par_id, gen_info, gen_info01, gen_info02,
                      gen_info03, gen_info04, gen_info05,
                      gen_info06, gen_info07, gen_info08,
                      gen_info09, gen_info10, gen_info11,
                      gen_info12, gen_info13, gen_info14,
                      gen_info15, gen_info16, gen_info17,
                      first_info, user_id, last_update
                     )
              VALUES (p_new_par_id, i.gen_info, i.gen_info01, i.gen_info02,
                      i.gen_info03, i.gen_info04, i.gen_info05,
                      i.gen_info06, i.gen_info07, i.gen_info08,
                      i.gen_info09, i.gen_info10, i.gen_info11,
                      i.gen_info12, i.gen_info13, i.gen_info14,
                      i.gen_info15, i.gen_info16, i.gen_info17,
                      i.first_info, p_user_id, SYSDATE
                     );
      END LOOP;
   END;

   -- copy_wopen_policy
   PROCEDURE copy_wopen_policy (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT line_cd, op_subline_cd, op_iss_cd, op_pol_seqno,
                       decltn_no, op_issue_yy, eff_date, op_renew_no
                  FROM gipi_wopen_policy
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wopen_policy
                     (par_id, line_cd, op_subline_cd, op_iss_cd,
                      op_pol_seqno, decltn_no, op_issue_yy,
                      eff_date, op_renew_no
                     )
              VALUES (p_new_par_id, i.line_cd, i.op_subline_cd, i.op_iss_cd,
                      i.op_pol_seqno, i.decltn_no, i.op_issue_yy,
                      i.eff_date, i.op_renew_no
                     );
      END LOOP;
   END;

   -- copy_wlim_liab
   PROCEDURE copy_wlim_liab (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT line_cd, liab_cd, limit_liability, currency_cd,
                       currency_rt
                  FROM gipi_wlim_liab
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wlim_liab
                     (par_id, line_cd, liab_cd, limit_liability,
                      currency_cd, currency_rt
                     )
              VALUES (p_new_par_id, i.line_cd, i.liab_cd, i.limit_liability,
                      i.currency_cd, i.currency_rt
                     );
      END LOOP;
   END;

   -- copy_wpack_line_subline
   PROCEDURE copy_wpack_line_subline (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT pack_line_cd, pack_subline_cd, line_cd, remarks,
                       item_tag
                  FROM gipi_wpack_line_subline
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wpack_line_subline
                     (par_id, pack_line_cd, pack_subline_cd,
                      line_cd, remarks, item_tag
                     )
              VALUES (p_new_par_id, i.pack_line_cd, i.pack_subline_cd,
                      i.line_cd, i.remarks, i.item_tag
                     );
      END LOOP;
   END;

   -- copy_witem
   PROCEDURE copy_witem (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, item_grp, item_title, item_desc, tsi_amt,
                       prem_amt, ann_tsi_amt, ann_prem_amt, rec_flag,
                       currency_cd, currency_rt, group_cd, from_date,
                       TO_DATE, coverage_cd, item_desc2, pack_line_cd,
                       pack_subline_cd, discount_sw, other_info,
                       surcharge_sw, region_cd, risk_no , risk_item_no   -- jhing 10.05.2015 added region_cd, risk_no, risk_item_no GENQA 0005030
                  FROM gipi_witem
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_witem
                     (par_id, item_no, item_grp, item_title,
                      item_desc, tsi_amt, prem_amt, ann_tsi_amt,
                      ann_prem_amt, rec_flag, currency_cd,
                      currency_rt, group_cd, from_date, TO_DATE,
                      coverage_cd, item_desc2, pack_line_cd,
                      pack_subline_cd, discount_sw, other_info,
                      surcharge_sw , region_cd, risk_no , risk_item_no 
                     )
              VALUES (p_new_par_id, i.item_no, i.item_grp, i.item_title,
                      i.item_desc, i.tsi_amt, i.prem_amt, i.ann_tsi_amt,
                      i.ann_prem_amt, i.rec_flag, i.currency_cd,
                      i.currency_rt, i.group_cd, i.from_date, i.TO_DATE,
                      i.coverage_cd, i.item_desc2, i.pack_line_cd,
                      i.pack_subline_cd, i.discount_sw, i.other_info,
                      i.surcharge_sw, i.region_cd, i.risk_no , i.risk_item_no 
                     );
      END LOOP;
   END;

   -- copy_witmperl
   PROCEDURE copy_witmperl (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, line_cd, peril_cd, tarf_cd, prem_rt, tsi_amt,
                       prem_amt, ann_tsi_amt, ann_prem_amt, rec_flag,
                       comp_rem, discount_sw, ri_comm_rate, ri_comm_amt,
                       prt_flag, as_charge_sw, surcharge_sw
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_witmperl
                     (par_id, item_no, line_cd, peril_cd,
                      tarf_cd, prem_rt, tsi_amt, prem_amt,
                      ann_tsi_amt, ann_prem_amt, rec_flag, comp_rem,
                      discount_sw, ri_comm_rate, ri_comm_amt,
                      prt_flag, as_charge_sw, surcharge_sw
                     )
              VALUES (p_new_par_id, i.item_no, i.line_cd, i.peril_cd,
                      i.tarf_cd, i.prem_rt, i.tsi_amt, i.prem_amt,
                      i.ann_tsi_amt, i.ann_prem_amt, i.rec_flag, i.comp_rem,
                      i.discount_sw, i.ri_comm_rate, i.ri_comm_amt,
                      i.prt_flag, i.as_charge_sw, i.surcharge_sw
                     );
      END LOOP;
   END;

   -- copy-winvoice
   PROCEDURE copy_winvoice (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_iss_cd       gipi_invoice.iss_cd%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
      v_prem_seq_no   gipi_invoice.prem_seq_no%TYPE;
   BEGIN
      BEGIN
         SELECT prem_seq_no + 1
           INTO v_prem_seq_no
           FROM giis_prem_seq
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_prem_seq_no := 1;
         WHEN TOO_MANY_ROWS
         THEN
            DBMS_OUTPUT.put_line ('No value in GIIS_PREM_SEQ.');
      END;

      FOR i IN (SELECT item_grp, payt_terms, prem_seq_no, prem_amt, tax_amt,
                       property, insured, notarial_fee, ri_comm_amt,
                       currency_cd, currency_rt, remarks, other_charges,
                       bond_rate, bond_tsi_amt, ref_inv_no, policy_currency,
                       pay_type, card_name, card_no, approval_cd, expiry_date,
                       takeup_seq_no, multi_booking_mm, multi_booking_yy,
                       no_of_takeup, ri_comm_vat, dist_flag, changed_tag
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_winvoice
                     (par_id, item_grp, payt_terms, prem_seq_no,
                      prem_amt, tax_amt, property, insured, due_date,
                      notarial_fee, ri_comm_amt, currency_cd,
                      currency_rt, remarks, other_charges,
                      bond_rate, bond_tsi_amt, ref_inv_no,
                      policy_currency, pay_type, card_name, card_no,
                      approval_cd, expiry_date, takeup_seq_no,
                      multi_booking_mm, multi_booking_yy, no_of_takeup,
                      ri_comm_vat, dist_flag, changed_tag
                     )
              VALUES (p_new_par_id, i.item_grp, i.payt_terms, v_prem_seq_no,
                      i.prem_amt, i.tax_amt, i.property, i.insured, SYSDATE,
                      i.notarial_fee, i.ri_comm_amt, i.currency_cd,
                      i.currency_rt, i.remarks, i.other_charges,
                      i.bond_rate, i.bond_tsi_amt, i.ref_inv_no,
                      i.policy_currency, i.pay_type, i.card_name, i.card_no,
                      i.approval_cd, i.expiry_date, i.takeup_seq_no,
                      i.multi_booking_mm, i.multi_booking_yy, i.no_of_takeup,
                      i.ri_comm_vat, i.dist_flag, i.changed_tag -- added by: nica 04.14.2011
                     );
      END LOOP;
   END;

   PROCEDURE copy_winvperl (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT peril_cd, item_grp, tsi_amt, prem_amt, ri_comm_amt,
                       ri_comm_rt, takeup_seq_no
                  FROM gipi_winvperl
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_winvperl
                     (par_id, peril_cd, item_grp, tsi_amt,
                      prem_amt, ri_comm_amt, ri_comm_rt,
                      takeup_seq_no
                     )
              VALUES (p_new_par_id, i.peril_cd, i.item_grp, i.tsi_amt,
                      i.prem_amt, i.ri_comm_amt, i.ri_comm_rt,
                      i.takeup_seq_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_winstallment (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, inst_no, share_pct, prem_amt, tax_amt,
                       due_date, takeup_seq_no
                  FROM gipi_winstallment
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_winstallment
                     (par_id, item_grp, inst_no, share_pct,
                      prem_amt, tax_amt, due_date, takeup_seq_no
                     )
              VALUES (p_new_par_id, i.item_grp, i.inst_no, i.share_pct,
                      i.prem_amt, i.tax_amt, i.due_date, i.takeup_seq_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_winv_tax (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, tax_cd, line_cd, iss_cd, tax_amt, tax_id,
                       tax_allocation, fixed_tax_allocation, rate,
                       takeup_seq_no
                  FROM gipi_winv_tax
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_winv_tax
                     (par_id, item_grp, tax_cd, line_cd,
                      iss_cd, tax_amt, tax_id, tax_allocation,
                      fixed_tax_allocation, rate, takeup_seq_no
                     )
              VALUES (p_new_par_id, i.item_grp, i.tax_cd, i.line_cd,
                      i.iss_cd, i.tax_amt, i.tax_id, i.tax_allocation,
                      i.fixed_tax_allocation, i.rate, i.takeup_seq_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_wpolbas_discount (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, SEQUENCE, disc_rt, disc_amt,
                       net_gross_tag, orig_prem_amt, net_prem_amt,
                       last_update, remarks, surcharge_rt, surcharge_amt
                  FROM gipi_wpolbas_discount
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wpolbas_discount
                     (par_id, line_cd, subline_cd, SEQUENCE,
                      disc_rt, disc_amt, net_gross_tag,
                      orig_prem_amt, net_prem_amt, last_update,
                      remarks, surcharge_rt, surcharge_amt
                     )
              VALUES (p_new_par_id, i.line_cd, i.subline_cd, i.SEQUENCE,
                      i.disc_rt, i.disc_amt, i.net_gross_tag,
                      i.orig_prem_amt, i.net_prem_amt, i.last_update,
                      i.remarks, i.surcharge_rt, i.surcharge_amt
                     );
      END LOOP;
   END;

   PROCEDURE copy_witem_discount (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, SEQUENCE, item_no, disc_rt,
                       disc_amt, net_gross_tag, orig_prem_amt, net_prem_amt,
                       last_update, remarks, surcharge_rt, surcharge_amt
                  FROM gipi_witem_discount
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_witem_discount
                     (par_id, line_cd, subline_cd, SEQUENCE,
                      disc_rt, disc_amt, net_gross_tag,
                      orig_prem_amt, net_prem_amt, last_update,
                      remarks, item_no, surcharge_rt, surcharge_amt
                     )
              VALUES (p_new_par_id, i.line_cd, i.subline_cd, i.SEQUENCE,
                      i.disc_rt, i.disc_amt, i.net_gross_tag,
                      i.orig_prem_amt, i.net_prem_amt, i.last_update,
                      i.remarks, i.item_no, i.surcharge_rt, i.surcharge_amt
                     );
      END LOOP;
   END;

   PROCEDURE copy_wperil_discount (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, line_cd, peril_cd, SEQUENCE, disc_rt,
                       disc_amt, net_gross_tag, discount_tag, level_tag,
                       subline_cd, orig_peril_prem_amt, net_prem_amt,
                       remarks, last_update, orig_peril_ann_prem_amt,
                       orig_item_ann_prem_amt, orig_pol_ann_prem_amt,
                       surcharge_rt, surcharge_amt
                  FROM gipi_wperil_discount
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wperil_discount
                     (par_id, item_no, line_cd, peril_cd,
                      SEQUENCE, disc_rt, disc_amt, net_gross_tag,
                      discount_tag, level_tag, subline_cd,
                      orig_peril_prem_amt, net_prem_amt, remarks,
                      last_update, orig_peril_ann_prem_amt,
                      orig_item_ann_prem_amt, orig_pol_ann_prem_amt,
                      surcharge_rt, surcharge_amt
                     )
              VALUES (p_new_par_id, i.item_no, i.line_cd, i.peril_cd,
                      i.SEQUENCE, i.disc_rt, i.disc_amt, i.net_gross_tag,
                      i.discount_tag, i.level_tag, i.subline_cd,
                      i.orig_peril_prem_amt, i.net_prem_amt, i.remarks,
                      i.last_update, i.orig_peril_ann_prem_amt,
                      i.orig_item_ann_prem_amt, i.orig_pol_ann_prem_amt,
                      i.surcharge_rt, i.surcharge_amt
                     );
      END LOOP;
   END;

   PROCEDURE copy_co_ins (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT tsi_amt, prem_amt, policy_id
                  FROM gipi_main_co_ins
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_main_co_ins
                     (par_id, tsi_amt, prem_amt, user_id, last_update
                     )
              VALUES (p_new_par_id, i.tsi_amt, i.prem_amt, p_user_id, SYSDATE
                     );
      END LOOP;

      FOR i IN (SELECT co_ri_cd, co_ri_shr_pct, co_ri_prem_amt, co_ri_tsi_amt
                  FROM gipi_co_insurer
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_co_insurer
                     (par_id, co_ri_cd, co_ri_shr_pct,
                      co_ri_prem_amt, co_ri_tsi_amt, user_id, last_update
                     )
              VALUES (p_new_par_id, i.co_ri_cd, i.co_ri_shr_pct,
                      i.co_ri_prem_amt, i.co_ri_tsi_amt, p_user_id, SYSDATE
                     );
      END LOOP;
   END;

   PROCEDURE copy_wendttext (
      p_par_id              NUMBER,
      p_new_par_id          NUMBER,
      p_user_id             giis_users.user_id%TYPE,
      p_endt_text01   OUT   VARCHAR2,
      p_endt_text02   OUT   VARCHAR2,
      p_endt_text03   OUT   VARCHAR2,
      p_endt_text04   OUT   VARCHAR2,
      p_endt_text05   OUT   VARCHAR2,
      p_endt_text06   OUT   VARCHAR2,
      p_endt_text07   OUT   VARCHAR2,
      p_endt_text08   OUT   VARCHAR2,
      p_endt_text09   OUT   VARCHAR2,
      p_endt_text10   OUT   VARCHAR2,
      p_endt_text11   OUT   VARCHAR2,
      p_endt_text12   OUT   VARCHAR2,
      p_endt_text13   OUT   VARCHAR2,
      p_endt_text14   OUT   VARCHAR2,
      p_endt_text15   OUT   VARCHAR2,
      p_endt_text16   OUT   VARCHAR2,
      p_endt_text17   OUT   VARCHAR2
   )
   IS
      p_long   gipi_wendttext.endt_text%TYPE   := '';
   BEGIN
      BEGIN
         SELECT NVL (endt_text01, ''), NVL (endt_text02, ''),
                NVL (endt_text03, ''), NVL (endt_text04, ''),
                NVL (endt_text05, ''), NVL (endt_text06, ''),
                NVL (endt_text07, ''), NVL (endt_text08, ''),
                NVL (endt_text09, ''), NVL (endt_text10, ''),
                NVL (endt_text11, ''), NVL (endt_text12, ''),
                NVL (endt_text13, ''), NVL (endt_text14, ''),
                NVL (endt_text15, ''), NVL (endt_text16, ''),
                NVL (endt_text17, ''), endt_text
           INTO p_endt_text01, p_endt_text02,
                p_endt_text03, p_endt_text04,
                p_endt_text05, p_endt_text06,
                p_endt_text07, p_endt_text08,
                p_endt_text09, p_endt_text10,
                p_endt_text11, p_endt_text12,
                p_endt_text13, p_endt_text14,
                p_endt_text15, p_endt_text16,
                p_endt_text17, p_long
           FROM gipi_wendttext
          WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_long := '';
         WHEN TOO_MANY_ROWS
         THEN
            DBMS_OUTPUT.put_line ('Too many rows.');
      END;

      INSERT INTO gipi_wendttext
                  (par_id, endt_text, user_id, last_update
                  )
           VALUES (p_new_par_id, SUBSTR (p_long, 1, 250), p_user_id, SYSDATE
                  );
   END;

   PROCEDURE copy_wcomm_invoices (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, intrmdry_intm_no, share_percentage,
                       premium_amt, commission_amt, wholding_tax, bond_rate,
                       parent_intm_no, default_intm, takeup_seq_no
                  FROM gipi_wcomm_invoices
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wcomm_invoices
                     (par_id, item_grp, intrmdry_intm_no,
                      share_percentage, premium_amt, commission_amt,
                      wholding_tax, bond_rate, parent_intm_no,
                      default_intm, takeup_seq_no
                     )
              VALUES (p_new_par_id, i.item_grp, i.intrmdry_intm_no,
                      i.share_percentage, i.premium_amt, i.commission_amt,
                      i.wholding_tax, i.bond_rate, i.parent_intm_no,
                      i.default_intm, i.takeup_seq_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_wcomm_inv_perils (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, intrmdry_intm_no, peril_cd, premium_amt,
                       commission_amt, commission_rt, wholding_tax,
                       takeup_seq_no
                  FROM gipi_wcomm_inv_perils
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wcomm_inv_perils
                     (par_id, item_grp, intrmdry_intm_no,
                      peril_cd, premium_amt, commission_amt,
                      commission_rt, wholding_tax, takeup_seq_no
                     )
              VALUES (p_new_par_id, i.item_grp, i.intrmdry_intm_no,
                      i.peril_cd, i.premium_amt, i.commission_amt,
                      i.commission_rt, i.wholding_tax, i.takeup_seq_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_wmortgagee (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT iss_cd, mortg_cd, item_no, amount, remarks, user_id,
                       last_update, delete_sw
                  FROM gipi_wmortgagee
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wmortgagee
                     (par_id, iss_cd, mortg_cd, item_no,
                      amount, remarks, user_id, last_update, delete_sw
                     )
              VALUES (p_new_par_id, i.iss_cd, i.mortg_cd, i.item_no,
                      i.amount, i.remarks, p_user_id, SYSDATE, i.delete_sw
                     );
      END LOOP;
   END;

   PROCEDURE copy_orig_comm_invoice (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT intrmdry_intm_no, item_grp, premium_amt,
                       share_percentage, commission_amt, wholding_tax,
                       policy_id, iss_cd, prem_seq_no
                  FROM gipi_orig_comm_invoice
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_orig_comm_invoice
                     (par_id, intrmdry_intm_no, item_grp,
                      premium_amt, share_percentage, commission_amt,
                      wholding_tax, policy_id, iss_cd, prem_seq_no
                     )
              VALUES (p_new_par_id, i.intrmdry_intm_no, i.item_grp,
                      i.premium_amt, i.share_percentage, i.commission_amt,
                      i.wholding_tax, i.policy_id, i.iss_cd, i.prem_seq_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_orig_comm_inv_peril (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT intrmdry_intm_no, item_grp, peril_cd, premium_amt,
                       policy_id, iss_cd, prem_seq_no, commission_amt,
                       commission_rt, wholding_tax
                  FROM gipi_orig_comm_inv_peril
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_orig_comm_inv_peril
                     (par_id, intrmdry_intm_no, item_grp,
                      peril_cd, premium_amt, policy_id, iss_cd,
                      prem_seq_no, commission_amt, commission_rt,
                      wholding_tax
                     )
              VALUES (p_new_par_id, i.intrmdry_intm_no, i.item_grp,
                      i.peril_cd, i.premium_amt, i.policy_id, i.iss_cd,
                      i.prem_seq_no, i.commission_amt, i.commission_rt,
                      i.wholding_tax
                     );
      END LOOP;
   END;

   PROCEDURE copy_orig_invoice (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, policy_id, iss_cd, prem_seq_no, prem_amt,
                       tax_amt, other_charges, ref_inv_no, policy_currency,
                       property, insured, ri_comm_amt, currency_cd,
                       currency_rt, remarks
                  FROM gipi_orig_invoice
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_orig_invoice
                     (par_id, item_grp, policy_id, iss_cd,
                      prem_seq_no, prem_amt, tax_amt, other_charges,
                      ref_inv_no, policy_currency, property,
                      insured, ri_comm_amt, currency_cd,
                      currency_rt, remarks
                     )
              VALUES (p_new_par_id, i.item_grp, i.policy_id, i.iss_cd,
                      i.prem_seq_no, i.prem_amt, i.tax_amt, i.other_charges,
                      i.ref_inv_no, i.policy_currency, i.property,
                      i.insured, i.ri_comm_amt, i.currency_cd,
                      i.currency_rt, i.remarks
                     );
      END LOOP;
   END;

   PROCEDURE copy_orig_invperil (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, peril_cd, tsi_amt, prem_amt, policy_id,
                       ri_comm_amt, ri_comm_rt
                  FROM gipi_orig_invperl
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_orig_invperl
                     (par_id, item_grp, peril_cd, tsi_amt,
                      prem_amt, policy_id, ri_comm_amt, ri_comm_rt
                     )
              VALUES (p_par_id, i.item_grp, i.peril_cd, i.tsi_amt,
                      i.prem_amt, i.policy_id, i.ri_comm_amt, i.ri_comm_rt
                     );
      END LOOP;
   END;

   PROCEDURE copy_orig_inv_tax (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_grp, tax_cd, line_cd, tax_allocation,
                       fixed_tax_allocation, policy_id, iss_cd, tax_amt,
                       tax_id, rate
                  FROM gipi_orig_inv_tax
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_orig_inv_tax
                     (par_id, item_grp, tax_cd, line_cd,
                      tax_allocation, fixed_tax_allocation, policy_id,
                      iss_cd, tax_amt, tax_id, rate
                     )
              VALUES (p_new_par_id, i.item_grp, i.tax_cd, i.line_cd,
                      i.tax_allocation, i.fixed_tax_allocation, i.policy_id,
                      i.iss_cd, i.tax_amt, i.tax_id, i.rate
                     );
      END LOOP;
   END;

   PROCEDURE copy_orig_itmperil (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, line_cd, peril_cd, rec_flag, policy_id,
                       prem_rt, prem_amt, tsi_amt, ann_prem_amt, ann_tsi_amt,
                       comp_rem, discount_sw, ri_comm_rate, ri_comm_amt,
                       surcharge_sw
                  FROM gipi_orig_itmperil
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_orig_itmperil
                     (par_id, item_no, line_cd, peril_cd,
                      rec_flag, policy_id, prem_rt, prem_amt,
                      tsi_amt, ann_prem_amt, ann_tsi_amt, comp_rem,
                      discount_sw, ri_comm_rate, ri_comm_amt,
                      surcharge_sw
                     )
              VALUES (p_new_par_id, i.item_no, i.line_cd, i.peril_cd,
                      i.rec_flag, i.policy_id, i.prem_rt, i.prem_amt,
                      i.tsi_amt, i.ann_prem_amt, i.ann_tsi_amt, i.comp_rem,
                      i.discount_sw, i.ri_comm_rate, i.ri_comm_amt,
                      i.surcharge_sw
                     );
      END LOOP;
   END;

   PROCEDURE copy_wfireitm (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, district_no, eq_zone, tarf_cd, block_no,
                       fr_item_type, loc_risk1, loc_risk2, loc_risk3,
                       tariff_zone, typhoon_zone, construction_cd,
                       construction_remarks, front, RIGHT, LEFT, rear,
                       occupancy_cd, occupancy_remarks, flood_zone, assignee,
                       block_id
                  FROM gipi_wfireitm
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wfireitm
                     (par_id, item_no, district_no, eq_zone,
                      tarf_cd, block_no, fr_item_type, loc_risk1,
                      loc_risk2, loc_risk3, tariff_zone,
                      typhoon_zone, construction_cd,
                      construction_remarks, front, RIGHT, LEFT,
                      rear, occupancy_cd, occupancy_remarks,
                      flood_zone, assignee, block_id
                     )
              VALUES (p_new_par_id, i.item_no, i.district_no, i.eq_zone,
                      i.tarf_cd, i.block_no, i.fr_item_type, i.loc_risk1,
                      i.loc_risk2, i.loc_risk3, i.tariff_zone,
                      i.typhoon_zone, i.construction_cd,
                      i.construction_remarks, i.front, i.RIGHT, i.LEFT,
                      i.rear, i.occupancy_cd, i.occupancy_remarks,
                      i.flood_zone, i.assignee, i.block_id
                     );
      END LOOP;
   END;

   PROCEDURE copy_wvehicle (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, plate_no, subline_cd, motor_no, est_value,
                       make, mot_type, color, repair_lim, serial_no,
                       coc_seq_no, coc_type, assignee, model_year,
                       coc_issue_date, coc_yy, towing, subline_type_cd,
                       no_of_pass, tariff_zone, acquired_from, mv_file_no,
                       ctv_tag, car_company_cd, coc_serial_no,
                       type_of_body_cd, make_cd, series_cd, basic_color_cd,
                       color_cd, unladen_wt, origin, destination
                  FROM gipi_wvehicle
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wvehicle
                     (par_id, item_no, plate_no, subline_cd,
                      motor_no, est_value, make, mot_type, color,
                      repair_lim, serial_no, coc_seq_no, coc_type,
                      assignee, model_year, coc_issue_date, coc_yy,
                      towing, subline_type_cd, no_of_pass,
                      tariff_zone, acquired_from, mv_file_no,
                      ctv_tag, car_company_cd, coc_serial_no,
                      type_of_body_cd, make_cd, series_cd,
                      basic_color_cd, color_cd, unladen_wt, origin,
                      destination
                     )
              VALUES (p_new_par_id, i.item_no, i.plate_no, i.subline_cd,
                      i.motor_no, i.est_value, i.make, i.mot_type, i.color,
                      i.repair_lim, i.serial_no, i.coc_seq_no, i.coc_type,
                      i.assignee, i.model_year, i.coc_issue_date, i.coc_yy,
                      i.towing, i.subline_type_cd, i.no_of_pass,
                      i.tariff_zone, i.acquired_from, i.mv_file_no,
                      i.ctv_tag, i.car_company_cd, i.coc_serial_no,
                      i.type_of_body_cd, i.make_cd, i.series_cd,
                      i.basic_color_cd, i.color_cd, i.unladen_wt, i.origin,
                      i.destination
                     );
      END LOOP;
   END;

   PROCEDURE copy_wmcacc (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, accessory_cd, acc_amt, par_id, user_id,
                       last_update
                  FROM gipi_wmcacc
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wmcacc
                     (par_id, item_no, accessory_cd, acc_amt,
                      user_id, last_update
                     )
              VALUES (p_new_par_id, i.item_no, i.accessory_cd, i.acc_amt,
                      p_user_id, SYSDATE
                     );
      END LOOP;
   END;

   PROCEDURE copy_waccident_item (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, date_of_birth, age, civil_status,
                       position_cd, monthly_salary, salary_grade,
                       no_of_persons, destination, height, weight, sex,
                       ac_class_cd, group_print_sw
                  FROM gipi_waccident_item
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_waccident_item
                     (par_id, item_no, date_of_birth, age,
                      civil_status, position_cd, monthly_salary,
                      salary_grade, no_of_persons, destination,
                      height, weight, sex, ac_class_cd,
                      group_print_sw
                     )
              VALUES (p_new_par_id, i.item_no, i.date_of_birth, i.age,
                      i.civil_status, i.position_cd, i.monthly_salary,
                      i.salary_grade, i.no_of_persons, i.destination,
                      i.height, i.weight, i.sex, i.ac_class_cd,
                      i.group_print_sw
                     );
      END LOOP;
   END;

   PROCEDURE copy_wbeneficiary (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, beneficiary_name, beneficiary_addr, relation,
                       civil_status, date_of_birth, age, adult_sw, sex,
                       position_cd, beneficiary_no, delete_sw, remarks
                  FROM gipi_wbeneficiary
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wbeneficiary
                     (par_id, item_no, beneficiary_name,
                      beneficiary_addr, relation, civil_status,
                      date_of_birth, age, adult_sw, sex,
                      position_cd, beneficiary_no, delete_sw, remarks
                     )
              VALUES (p_new_par_id, i.item_no, i.beneficiary_name,
                      i.beneficiary_addr, i.relation, i.civil_status,
                      i.date_of_birth, i.age, i.adult_sw, i.sex,
                      i.position_cd, i.beneficiary_no, i.delete_sw, i.remarks
                     );
      END LOOP;
   END;

   PROCEDURE copy_wgrouped_items (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, grouped_item_no, grouped_item_title,
                       include_tag, amount_covered, remarks, line_cd,
                       subline_cd, sex, position_cd, civil_status,
                       date_of_birth, age, salary, salary_grade, delete_sw,
                       group_cd
                  FROM gipi_wgrouped_items
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wgrouped_items
                     (par_id, item_no, grouped_item_no,
                      grouped_item_title, include_tag, amount_covered,
                      remarks, line_cd, subline_cd, sex,
                      position_cd, civil_status, date_of_birth, age,
                      salary, salary_grade, delete_sw, group_cd
                     )
              VALUES (p_new_par_id, i.item_no, i.grouped_item_no,
                      i.grouped_item_title, i.include_tag, i.amount_covered,
                      i.remarks, i.line_cd, i.subline_cd, i.sex,
                      i.position_cd, i.civil_status, i.date_of_birth, i.age,
                      i.salary, i.salary_grade, i.delete_sw, i.group_cd
                     );
      END LOOP;
   END;

   PROCEDURE copy_wgrp_items_beneficiary (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, grouped_item_no, beneficiary_no,
                       beneficiary_name, beneficiary_addr, relation,
                       date_of_birth, age, civil_status, sex
                  FROM gipi_wgrp_items_beneficiary
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wgrp_items_beneficiary
                     (par_id, item_no, grouped_item_no,
                      beneficiary_no, beneficiary_name,
                      beneficiary_addr, relation, date_of_birth,
                      age, civil_status, sex
                     )
              VALUES (p_new_par_id, i.item_no, i.grouped_item_no,
                      i.beneficiary_no, i.beneficiary_name,
                      i.beneficiary_addr, i.relation, i.date_of_birth,
                      i.age, i.civil_status, i.sex
                     );
      END LOOP;
   END;

   PROCEDURE copy_witem_ves (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, vessel_cd, geog_limit, rec_flag, deduct_text,
                       dry_date, dry_place
                  FROM gipi_witem_ves
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_witem_ves
                     (par_id, item_no, vessel_cd, geog_limit,
                      rec_flag, deduct_text, dry_date, dry_place
                     )
              VALUES (p_new_par_id, i.item_no, i.vessel_cd, i.geog_limit,
                      i.rec_flag, i.deduct_text, i.dry_date, i.dry_place
                     );
      END LOOP;
   END;

   PROCEDURE copy_wcargo (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd, bl_awb,
                       rec_flag, origin, destn, etd, eta, cargo_type,
                       deduct_text, pack_method, tranship_origin,
                       tranship_destination, print_tag, voyage_no, lc_no, inv_curr_rt, invoice_value , inv_curr_cd, markup_rate   -- jhing 10.05.2015 added inv_curr_rt, invoice_value, inv_curr_cd, markup_rate GENQA SR# 0005030
                  FROM gipi_wcargo
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wcargo
                     (par_id, item_no, vessel_cd, geog_cd,
                      cargo_class_cd, bl_awb, rec_flag, origin,
                      destn, etd, eta,
                      cargo_type, deduct_text, pack_method,
                      tranship_origin, tranship_destination,
                      print_tag, voyage_no, lc_no, inv_curr_rt, invoice_value , 
                      inv_curr_cd, markup_rate 
                     )
              VALUES (p_new_par_id, i.item_no, i.vessel_cd, i.geog_cd,
                      i.cargo_class_cd, i.bl_awb, i.rec_flag, i.origin,
                      i.destn, SYSDATE, ADD_MONTHS (SYSDATE, 12),
                      i.cargo_type, i.deduct_text, i.pack_method,
                      i.tranship_origin, i.tranship_destination,
                      i.print_tag, i.voyage_no, i.lc_no, i.inv_curr_rt, i.invoice_value , 
                      i.inv_curr_cd, i.markup_rate 
                     );
      END LOOP;
   END;

   PROCEDURE copy_wves_air (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT vessel_cd, vescon, voy_limit, rec_flag
                  FROM gipi_wves_air
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wves_air
                     (par_id, vessel_cd, vescon, voy_limit,
                      rec_flag
                     )
              VALUES (p_new_par_id, i.vessel_cd, i.vescon, i.voy_limit,
                      i.rec_flag
                     );
      END LOOP;
   END;

   PROCEDURE copy_wves_accumulation (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT vessel_cd, item_no, eta, etd, tsi_amt, rec_flag,
                       eff_date
                  FROM gipi_wves_accumulation
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wves_accumulation
                     (par_id, vessel_cd, item_no, eta,
                      etd, tsi_amt, rec_flag,
                      eff_date
                     )
              VALUES (p_new_par_id, i.vessel_cd, i.item_no, SYSDATE,
                      ADD_MONTHS (SYSDATE, 12), i.tsi_amt, i.rec_flag,
                      i.eff_date
                     );
      END LOOP;
   END;

   PROCEDURE copy_wopen_liab (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT geog_cd, limit_liability, currency_cd, currency_rt,
                       voy_limit, rec_flag, prem_tag, with_invoice_tag,
                       multi_geog_tag
                  FROM gipi_wopen_liab
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wopen_liab
                     (par_id, geog_cd, limit_liability,
                      currency_cd, currency_rt, voy_limit, rec_flag,
                      prem_tag, with_invoice_tag, multi_geog_tag
                     )
              VALUES (p_new_par_id, i.geog_cd, i.limit_liability,
                      i.currency_cd, i.currency_rt, i.voy_limit, i.rec_flag,
                      i.prem_tag, i.with_invoice_tag, i.multi_geog_tag
                     );
      END LOOP;
   END;

   PROCEDURE copy_wopen_cargo (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT geog_cd, cargo_class_cd, rec_flag
                  FROM gipi_wopen_cargo
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wopen_cargo
                     (par_id, geog_cd, cargo_class_cd, rec_flag
                     )
              VALUES (p_new_par_id, i.geog_cd, i.cargo_class_cd, i.rec_flag
                     );
      END LOOP;
   END;

   PROCEDURE copy_wopen_peril (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT geog_cd, line_cd, peril_cd, rec_flag, prem_rate,
                       with_invoice_tag, remarks
                  FROM gipi_wopen_peril
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wopen_peril
                     (par_id, geog_cd, line_cd, peril_cd,
                      rec_flag, prem_rate, with_invoice_tag, remarks
                     )
              VALUES (p_new_par_id, i.geog_cd, i.line_cd, i.peril_cd,
                      i.rec_flag, i.prem_rate, i.with_invoice_tag, i.remarks
                     );
      END LOOP;
   END;

   PROCEDURE copy_wcasualty_item (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, section_line_cd, section_subline_cd,
                       section_or_hazard_cd, property_no_type, capacity_cd,
                       property_no, LOCATION, conveyance_info,
                       limit_of_liability, interest_on_premises,
                       section_or_hazard_info, location_cd     -- added location_cd jhing GENQA SR# 0005030 (10.05.2015)
                  FROM gipi_wcasualty_item
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wcasualty_item
                     (par_id, item_no, section_line_cd,
                      section_subline_cd, section_or_hazard_cd,
                      property_no_type, capacity_cd, property_no,
                      LOCATION, conveyance_info, limit_of_liability,
                      interest_on_premises, section_or_hazard_info, location_cd
                     )
              VALUES (p_new_par_id, i.item_no, i.section_line_cd,
                      i.section_subline_cd, i.section_or_hazard_cd,
                      i.property_no_type, i.capacity_cd, i.property_no,
                      i.LOCATION, i.conveyance_info, i.limit_of_liability,
                      i.interest_on_premises, i.section_or_hazard_info, i.location_cd
                     );
      END LOOP;
   END;

   PROCEDURE copy_wcasualty_personnel (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, personnel_no, NAME, include_tag, capacity_cd,
                       amount_covered, remarks
                  FROM gipi_wcasualty_personnel
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wcasualty_personnel
                     (par_id, item_no, personnel_no, NAME,
                      include_tag, capacity_cd, amount_covered,
                      remarks
                     )
              VALUES (p_new_par_id, i.item_no, i.personnel_no, i.NAME,
                      i.include_tag, i.capacity_cd, i.amount_covered,
                      i.remarks
                     );
      END LOOP;
   END;

   PROCEDURE copy_wbank_schedule (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT bank_item_no, bank, include_tag, bank_address,
                       cash_in_vault, cash_in_transit, remarks
                  FROM gipi_wbank_schedule
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wbank_schedule
                     (par_id, bank_item_no, bank, include_tag,
                      bank_address, cash_in_vault, cash_in_transit,
                      remarks
                     )
              VALUES (p_new_par_id, i.bank_item_no, i.bank, i.include_tag,
                      i.bank_address, i.cash_in_vault, i.cash_in_transit,
                      i.remarks
                     );
      END LOOP;
   END;

   PROCEDURE copy_wengg_basic (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT engg_basic_infonum, contract_proj_buss_title,
                       site_location, construct_start_date,
                       construct_end_date, maintain_start_date,
                       maintain_end_date, weeks_test, time_excess,
                       mbi_policy_no, testing_start_date, testing_end_date
                  FROM gipi_wengg_basic
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wengg_basic
                     (par_id, engg_basic_infonum,
                      contract_proj_buss_title, site_location,
                      construct_start_date, construct_end_date,
                      maintain_start_date, maintain_end_date,
                      weeks_test, time_excess, mbi_policy_no,
                      testing_start_date, testing_end_date
                     )
              VALUES (p_new_par_id, i.engg_basic_infonum,
                      i.contract_proj_buss_title, i.site_location,
                      i.construct_start_date, i.construct_end_date,
                      i.maintain_start_date, i.maintain_end_date,
                      i.weeks_test, i.time_excess, i.mbi_policy_no,
                      i.testing_start_date, i.testing_end_date
                     );
      END LOOP;
   END;

   PROCEDURE copy_wlocation (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, region_cd, province_cd
                  FROM gipi_wlocation
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wlocation
                     (par_id, item_no, region_cd, province_cd
                     )
              VALUES (p_new_par_id, i.item_no, i.region_cd, i.province_cd
                     );
      END LOOP;
   END;

   PROCEDURE copy_wprincipal (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT principal_cd, subcon_sw, engg_basic_infonum
                  FROM gipi_wprincipal
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wprincipal
                     (par_id, principal_cd, subcon_sw,
                      engg_basic_infonum
                     )
              VALUES (p_new_par_id, i.principal_cd, i.subcon_sw,
                      i.engg_basic_infonum
                     );
      END LOOP;
   END;

   PROCEDURE copy_wbond_basic (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE,
      p_long         gipi_wendttext.endt_text%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT obligee_no, val_period, val_period_unit, np_no,
                       contract_dtl, contract_date, prin_id, coll_flag,
                       co_prin_sw, waiver_limit, indemnity_text, bond_dtl,
                       clause_type, endt_eff_date, remarks, plaintiff_dtl, defendant_dtl, civil_case_no  -- jhing GENQA SR# 0005030 added plaintiff, defendant, civil case no.
                  FROM gipi_wbond_basic
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wbond_basic
                     (par_id, obligee_no, val_period,
                      val_period_unit, np_no, contract_dtl,
                      contract_date, prin_id, coll_flag, co_prin_sw,
                      waiver_limit, indemnity_text, bond_dtl,
                      clause_type, endt_eff_date, remarks,
                      plaintiff_dtl, defendant_dtl, civil_case_no
                     )
              VALUES (p_new_par_id, i.obligee_no, i.val_period,
                      i.val_period_unit, i.np_no, i.contract_dtl,
                      i.contract_date, i.prin_id, i.coll_flag, i.co_prin_sw,
                      i.waiver_limit, i.indemnity_text, p_long,
                      i.clause_type, i.endt_eff_date, i.remarks, 
                      i.plaintiff_dtl, i.defendant_dtl, i.civil_case_no
                     );
      END LOOP;
   END;

   PROCEDURE copy_wcosigntry (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                       bonds_ri_flag
                  FROM gipi_wcosigntry
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wcosigntry
                     (par_id, cosign_id, assd_no, indem_flag,
                      bonds_flag, bonds_ri_flag
                     )
              VALUES (p_new_par_id, i.cosign_id, i.assd_no, i.indem_flag,
                      i.bonds_flag, i.bonds_ri_flag
                     );
      END LOOP;
   END;

   PROCEDURE copy_waviation_item (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, vessel_cd, total_fly_time, qualification,
                       purpose, geog_limit, deduct_text, rec_flag,
                       fixed_wing, rotor, prev_util_hrs, est_util_hrs
                  FROM gipi_waviation_item
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_waviation_item
                     (par_id, item_no, vessel_cd,
                      total_fly_time, qualification, purpose,
                      geog_limit, deduct_text, rec_flag, fixed_wing,
                      rotor, prev_util_hrs, est_util_hrs
                     )
              VALUES (p_new_par_id, i.item_no, i.vessel_cd,
                      i.total_fly_time, i.qualification, i.purpose,
                      i.geog_limit, i.deduct_text, i.rec_flag, i.fixed_wing,
                      i.rotor, i.prev_util_hrs, i.est_util_hrs
                     );
      END LOOP;
   END;

   PROCEDURE copy_wpolwc (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title,
                       wc_remarks, wc_text01, wc_text02, wc_text03,
                       wc_text04, wc_text05, wc_text06, wc_text07, wc_text08,
                       wc_text09, wc_text10, wc_text11, wc_text12, wc_text13,
                       wc_text14, wc_text15, wc_text16, wc_text17, rec_flag,
                       print_sw, change_tag
                  FROM gipi_wpolwc
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wpolwc
                     (par_id, line_cd, wc_cd, swc_seq_no,
                      print_seq_no, wc_title, wc_remarks, wc_text01,
                      wc_text02, wc_text03, wc_text04, wc_text05,
                      wc_text06, wc_text07, wc_text08, wc_text09,
                      wc_text10, wc_text11, wc_text12, wc_text13,
                      wc_text14, wc_text15, wc_text16, wc_text17,
                      rec_flag, print_sw, change_tag
                     )
              VALUES (p_new_par_id, i.line_cd, i.wc_cd, i.swc_seq_no,
                      i.print_seq_no, i.wc_title, i.wc_remarks, i.wc_text01,
                      i.wc_text02, i.wc_text03, i.wc_text04, i.wc_text05,
                      i.wc_text06, i.wc_text07, i.wc_text08, i.wc_text09,
                      i.wc_text10, i.wc_text11, i.wc_text12, i.wc_text13,
                      i.wc_text14, i.wc_text15, i.wc_text16, i.wc_text17,
                      i.rec_flag, i.print_sw, i.change_tag
                     );
      END LOOP;
   END;
    
   -- modified by : nica 04.14.2011 in relation to GIPIS001 - 12.15.2010 version
   PROCEDURE copy_pol_dist (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
      -- longterm --
      v_no_of_takeup          GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
      v_yearly_tag            GIIS_TAKEUP_TERM.yearly_tag%TYPE;
      v_takeup_term           GIPI_WPOLBAS.takeup_term%TYPE;
      v_eff_date              GIPI_WPOLBAS.eff_date%TYPE;
      v_expiry_date           GIPI_WPOLBAS.expiry_date%TYPE;
      v_endt_type             GIPI_WPOLBAS.endt_type%TYPE;                          

      v_policy_days           NUMBER:=0;
      v_no_of_payment         NUMBER:=1;
      v_duration_frm          DATE;
      v_duration_to           DATE;              
      v_days_interval         NUMBER:=0;
      
      v_dist_no   giuw_pol_dist.dist_no%TYPE   := 0;
   
   BEGIN
        /*SELECT eff_date,
               expiry_date, 
               endt_type,
               takeup_term
        INTO v_eff_date,
             v_expiry_date,
             v_endt_type,
             v_takeup_term
          FROM gipi_wpolbas
         WHERE par_id  =  p_new_par_id;*/ -- replaced by: Nica 02.02.2012
         
        FOR dt IN (SELECT eff_date,
                       expiry_date, 
                       endt_type,
                       takeup_term
                  FROM GIPI_WPOLBAS
                 WHERE par_id  =  p_new_par_id)
        LOOP
            v_eff_date      := dt.eff_date;
            v_expiry_date   := dt.expiry_date;
            v_endt_type     := dt.endt_type;
            v_takeup_term   := dt.takeup_term;
        END LOOP;
             
        IF TRUNC(v_expiry_date - v_eff_date) = 31 THEN
          v_policy_days      := 30;
        ELSE
          v_policy_days      := TRUNC(v_expiry_date - v_eff_date);
        END IF;
            
        FOR b1 IN (SELECT no_of_takeup, yearly_tag
                   FROM GIIS_TAKEUP_TERM
                   WHERE takeup_term = v_takeup_term)
        LOOP
            v_no_of_takeup := b1.no_of_takeup;
            v_yearly_tag   := b1.yearly_tag;
        END LOOP;
            
        IF v_yearly_tag = 'Y' THEN
            IF TRUNC((v_policy_days)/365,2) * v_no_of_takeup >
                TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) THEN
                v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) + 1;
            ELSE
                v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup);
            END IF;
        ELSE
            IF v_policy_days < v_no_of_takeup THEN
                v_no_of_payment := v_policy_days;
            ELSE
                v_no_of_payment := v_no_of_takeup;
            END IF;
        END IF;
            
        IF v_no_of_payment < 1 THEN
            v_no_of_payment := 1;
        END IF;
            
        v_days_interval := ROUND(v_policy_days/v_no_of_payment);
      

      FOR i IN (SELECT endt_type, tsi_amt, prem_amt, ann_tsi_amt, redist_flag,
                       dist_type, item_posted_sw, ex_loss_sw, batch_id,
                       post_flag, auto_dist, item_grp, takeup_seq_no
                  FROM GIUW_POL_DIST
                 WHERE par_id = p_par_id)
      LOOP
      
          SELECT pol_dist_dist_no_s.NEXTVAL
            INTO v_dist_no
          FROM SYS.DUAL;
          
          IF v_duration_frm IS NULL THEN
             v_duration_frm := TRUNC(v_eff_date);                                             
          ELSE
             v_duration_frm := TRUNC(v_duration_frm + v_days_interval);                           
          END IF;
          
          v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
            
          INSERT INTO GIUW_POL_DIST
                (dist_no,          par_id,           policy_id,            endt_type,         tsi_amt,         prem_amt,       ann_tsi_amt,
                 dist_flag,        redist_flag,      eff_date,             expiry_date,       negate_date,     dist_type,      item_posted_sw,   
                 ex_loss_sw,       acct_ent_date,    acct_neg_date,        create_date,       user_id,         last_upd_date,  batch_id,                
                 post_flag,        auto_dist,        item_grp,             takeup_seq_no)
          VALUES (v_dist_no,       p_new_par_id,     NULL,                 i.endt_type,       i.tsi_amt,       i.prem_amt,     i.ann_tsi_amt,
                '1',               i.redist_flag,    v_duration_frm,       v_duration_to,     NULL,            i.dist_type,    i.item_posted_sw,     
                 i.ex_loss_sw,     NULL,             NULL,                 SYSDATE,           p_user_id,       SYSDATE,        i.batch_id,            
                 i.post_flag,      NULL,             i.item_grp,           i.takeup_seq_no);
      END LOOP;
   END;

   PROCEDURE copy_wdeductibles (
      p_par_id       NUMBER,
      p_new_par_id   NUMBER,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT item_no, ded_line_cd, ded_subline_cd,
                       ded_deductible_cd, deductible_text, deductible_rt,
                       deductible_amt, peril_cd
                  FROM gipi_wdeductibles
                 WHERE par_id = p_par_id)
      LOOP
         INSERT INTO gipi_wdeductibles
                     (par_id, item_no, ded_line_cd,
                      ded_subline_cd, ded_deductible_cd,
                      deductible_text, deductible_rt, deductible_amt,
                      peril_cd
                     )
              VALUES (p_new_par_id, i.item_no, i.ded_line_cd,
                      i.ded_subline_cd, i.ded_deductible_cd,
                      i.deductible_text, i.deductible_rt, i.deductible_amt,
                      i.peril_cd
                     );
      END LOOP;
   END;

   PROCEDURE save_parlist_from_endt (
      p_par_id         IN   gipi_parlist.par_id%TYPE,
      p_par_type       IN   gipi_parlist.par_type%TYPE,
      p_par_status     IN   gipi_parlist.par_status%TYPE,
      p_line_cd        IN   gipi_parlist.line_cd%TYPE,
      p_iss_cd         IN   gipi_parlist.iss_cd%TYPE,
      p_par_yy         IN   gipi_parlist.par_yy%TYPE,
      p_par_seq_no     IN   gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   IN   gipi_parlist.quote_seq_no%TYPE,
      p_assd_no        IN   gipi_parlist.assd_no%TYPE,
      p_address1       IN   gipi_parlist.address1%TYPE,
      p_address2       IN   gipi_parlist.address2%TYPE,
      p_address3       IN   gipi_parlist.address3%TYPE
   )
   IS
   /*
   **  Created by        : Mark JM
   **  Date Created     : 07.26.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedures inserts/updates record in GIPI_PARLIST table
   **                    : based on the given parameters
   */
   BEGIN
      MERGE INTO gipi_parlist
         USING DUAL
         ON (par_id = p_par_id)
         WHEN NOT MATCHED THEN
            INSERT (par_id, line_cd, iss_cd, par_yy, par_seq_no,
                    quote_seq_no, assd_no, par_status, par_type, address1,
                    address2, address3)
            VALUES (p_par_id, p_line_cd, p_iss_cd, p_par_yy, p_par_seq_no,
                    p_quote_seq_no, p_assd_no, p_par_status, p_par_type,
                    p_address1, p_address2, p_address3)
         WHEN MATCHED THEN
            UPDATE
               SET line_cd = p_line_cd, iss_cd = p_iss_cd, par_yy = p_par_yy,
                   par_seq_no = p_par_seq_no, quote_seq_no = p_quote_seq_no,
                   assd_no = p_assd_no, par_status = p_par_status,
                   par_type = p_par_type, address1 = p_address1,
                   address2 = p_address2, address3 = p_address3
            ;
   END save_parlist_from_endt;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 07.28.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the par_status
   **                    : on the given par_id
   */
   FUNCTION get_par_status (p_par_id IN gipi_parlist.par_id%TYPE)
      RETURN gipi_parlist.par_status%TYPE
   IS
      v_par_status   gipi_parlist.par_status%TYPE;
   BEGIN
      FOR i IN (SELECT par_status
                  FROM gipi_parlist
                 WHERE par_id = p_par_id)
      LOOP
         v_par_status := i.par_status;
         EXIT;
      END LOOP;

      RETURN v_par_status;
   END get_par_status;

   /************************* DELETE PAR LIST RELATED PROCS - whofeih 07.29.2010 ***************************/
   PROCEDURE delete_wpolwc (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wpolwc
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_fire_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wfireitm
            WHERE par_id = p_par_id;

      DELETE      rmd_fire_basic_info
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_motorcar_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wvehicle
            WHERE par_id = p_par_id;

      DELETE      gipi_wmcacc
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_accident_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_waccident_item
            WHERE par_id = p_par_id;

      DELETE      gipi_wbeneficiary
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_cargo_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wcargo_carrier
            WHERE par_id = p_par_id;

      DELETE      gipi_wcargo
            WHERE par_id = p_par_id;

      DELETE      gipi_wves_air
            WHERE par_id = p_par_id;

      DELETE      gipi_wves_accumulation
            WHERE par_id = p_par_id;

      DELETE      gipi_wopen_liab
            WHERE par_id = p_par_id;

      DELETE      gipi_wopen_cargo
            WHERE par_id = p_par_id;

      DELETE      gipi_wopen_peril
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_hull_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wcargo_carrier
            WHERE par_id = p_par_id;

      DELETE      gipi_witem_ves
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_casualty_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wcasualty_personnel
            WHERE par_id = p_par_id;

      DELETE      gipi_wcasualty_item
            WHERE par_id = p_par_id;

      DELETE      gipi_wbank_schedule
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_engineering_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wdeductibles
            WHERE par_id = p_par_id;

      DELETE      gipi_wlocation
            WHERE par_id = p_par_id;

      DELETE      gipi_wprincipal
            WHERE par_id = p_par_id;

      DELETE      gipi_wengg_basic
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_bonds_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wbond_basic
            WHERE par_id = p_par_id;

      DELETE      gipi_wcosigntry
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_oth_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wgrp_items_beneficiary --added by jongs 05.15.2015
            WHERE par_id = p_par_id; 
			
      DELETE      gipi_wgrouped_items
            WHERE par_id = p_par_id;

      DELETE      gipi_wpackage_inv_tax
            WHERE par_id = p_par_id;

      DELETE      gipi_wpolbas_discount
            WHERE par_id = p_par_id;

      DELETE      gipi_witem_discount
            WHERE par_id = p_par_id;

      DELETE      gipi_wperil_discount
            WHERE par_id = p_par_id;

      DELETE      gipi_co_insurer
            WHERE par_id = p_par_id;

      DELETE      gipi_main_co_ins
            WHERE par_id = p_par_id;

      DELETE      gipi_winv_tax
            WHERE par_id = p_par_id;

      DELETE      gipi_winstallment
            WHERE par_id = p_par_id;

      DELETE      gipi_wcomm_inv_perils
            WHERE par_id = p_par_id;

      DELETE      gipi_winvperl
            WHERE par_id = p_par_id;

      DELETE      gipi_wcomm_invoices
            WHERE par_id = p_par_id;

      DELETE      gipi_winvoice
            WHERE par_id = p_par_id;

      DELETE      gipi_witmperl
            WHERE par_id = p_par_id;

      DELETE      gipi_wdeductibles
            WHERE par_id = p_par_id;

      DELETE      gipi_witem
            WHERE par_id = p_par_id;

      DELETE      gipi_wpack_line_subline
            WHERE par_id = p_par_id;

      DELETE      gipi_wlim_liab
            WHERE par_id = p_par_id;

      DELETE      gipi_wopen_policy
            WHERE par_id = p_par_id;

      DELETE      gipi_wendttext
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_comm_invoice
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_comm_inv_peril
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_invperl
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_inv_tax
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_invoice
            WHERE par_id = p_par_id;

      DELETE      gipi_wendttext
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_inv_tax
            WHERE par_id = p_par_id;

      DELETE      gipi_orig_itmperil
            WHERE par_id = p_par_id;
   END delete_oth_workfile;

   PROCEDURE delete_aviation_workfile (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_waviation_item
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_by_packpol_flag (p_par_id NUMBER)
   IS
   BEGIN
      FOR A IN (SELECT 1
                  FROM giis_line A, gipi_parlist b
                 WHERE A.line_cd = b.line_cd
                   AND b.par_id = p_par_id
                   AND A.pack_pol_flag = 'Y')
      LOOP
         gipi_parlist_pkg.delete_fire_workfile (p_par_id);
         gipi_parlist_pkg.delete_motorcar_workfile (p_par_id);
         gipi_parlist_pkg.delete_accident_workfile (p_par_id);
         gipi_parlist_pkg.delete_cargo_workfile (p_par_id);
         gipi_parlist_pkg.delete_hull_workfile (p_par_id);
         gipi_parlist_pkg.delete_casualty_workfile (p_par_id);
         gipi_parlist_pkg.delete_engineering_workfile (p_par_id);
         gipi_parlist_pkg.delete_bonds_workfile (p_par_id);
         gipi_parlist_pkg.delete_aviation_workfile (p_par_id);
         EXIT;
      END LOOP;
   END;

   PROCEDURE delete_expiry (p_par_id NUMBER)
   IS
      v_policy_id   gipi_polnrep.old_policy_id%TYPE;
   BEGIN
      /*  BEGIN
            SELECT OLD_POLICY_ID
              INTO V_POLICY_ID
              FROM GIPI_WPOLNREP
             WHERE PAR_ID = p_par_id;
        EXCEPTION
        WHEN no_data_found THEN V_POLICY_ID := null;

        END;       */
      FOR rec IN (SELECT old_policy_id
                    FROM gipi_wpolnrep
                   WHERE par_id = p_par_id)
      LOOP
         v_policy_id := rec.old_policy_id;
      END LOOP;

      DELETE FROM giex_old_group_tax
            WHERE policy_id = v_policy_id;

      DELETE FROM giex_old_group_peril
            WHERE policy_id = v_policy_id;

      DELETE FROM giex_new_group_tax
            WHERE policy_id = v_policy_id;

      DELETE FROM giex_new_group_peril
            WHERE policy_id = v_policy_id;

      DELETE FROM giex_itmperil
            WHERE policy_id = v_policy_id;
   /*   DELETE FROM GIEX_EXPIRY
       WHERE POLICY_ID = V_POLICY_ID;*/
   END delete_expiry;

   PROCEDURE delete_distribution (p_par_id NUMBER)
   IS
      v_dist_no   giuw_pol_dist.dist_no%TYPE;
   BEGIN
      FOR A IN (SELECT dist_no
                  FROM giuw_pol_dist
                 WHERE par_id = p_par_id)
      LOOP
         v_dist_no := A.dist_no;
         EXIT;
      END LOOP;

      DELETE      giuw_witemperilds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_itemperilds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_witemperilds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_itemperilds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_wperilds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_perilds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_wperilds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_perilds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_witemds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_itemds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_witemds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_itemds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_policyds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giri_wdistfrps
            WHERE dist_no = v_dist_no;

      DELETE      giuw_wpolicyds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_policyds
            WHERE dist_no = v_dist_no;

      DELETE      giuw_distrel
            WHERE dist_no_old = v_dist_no;

      gipi_parlist_pkg.delete_ri_tables (v_dist_no);

      DELETE      giuw_pol_dist
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_wpolbas (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wpolgenin
            WHERE par_id = p_par_id;

      DELETE      gipi_wmortgagee
            WHERE par_id = p_par_id;

      DELETE      gipi_wpolbas
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_wpolnrep (p_par_id NUMBER)
   IS
   BEGIN
      DELETE      gipi_wpolnrep
            WHERE par_id = p_par_id;
   END;

   PROCEDURE delete_ri_tables (p_dist_no NUMBER)
   IS
   BEGIN
      FOR A IN (SELECT A.pre_binder_id, b.line_cd, A.frps_yy, A.frps_seq_no
                  FROM giri_wfrps_ri A, giri_wdistfrps b
                 WHERE A.line_cd = b.line_cd
                   AND A.frps_yy = b.frps_yy
                   AND A.frps_seq_no = b.frps_seq_no
                   AND b.dist_no = p_dist_no)
      LOOP
         DELETE      giri_wbinder_peril
               WHERE pre_binder_id = A.pre_binder_id;

         DELETE      giri_wbinder
               WHERE pre_binder_id = A.pre_binder_id;

         DELETE      giri_wfrperil
               WHERE line_cd = A.line_cd
                 AND frps_yy = A.frps_yy
                 AND frps_seq_no = A.frps_seq_no;

         DELETE      giri_wfrps_ri
               WHERE line_cd = A.line_cd
                 AND frps_yy = A.frps_yy
                 AND frps_seq_no = A.frps_seq_no;

         DELETE      giri_wdistfrps
               WHERE dist_no = p_dist_no;
      END LOOP;
   END delete_ri_tables;

   /************************* END OF DELETE PAR LIST RELATED PROCS - whofeih 07.29.2010 ***************************/

   /*
**  Created by      : Veronica V. Raymundo
**  Date Created  : January 20, 2011
**  Reference By  : GIPIS024A and GIPIS035A - Package Par
**  Description   : Function retrieves all par with pack_par_id that is equal to the parameter
*/
   FUNCTION get_package_policy_list (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_parlist_tab PIPELINED
   IS
      v_par   gipi_parlist_type;
   BEGIN
      FOR i IN (SELECT   A.par_id, A.line_cd, b.line_name, A.iss_cd,
                         A.par_yy, A.par_seq_no, A.quote_seq_no, A.remarks,
                         c.subline_cd, c.pol_seq_no, c.issue_yy, a.par_type, c.pol_flag, c.pack_pol_flag,
                            A.line_cd
                         || '-'
                         || A.iss_cd
                         || '-'
                         || TO_CHAR (A.par_yy, '09')
                         || '-'
                         || TO_CHAR (A.par_seq_no, '000009')
                         || '-'
                         || TO_CHAR (A.quote_seq_no, '09') par_no,
                            c.line_cd
                         || ' - '
                         || c.subline_cd
                         || ' - '
                         || c.iss_cd
                         || ' - '
                         || TO_CHAR (c.issue_yy, '09')
                         || ' - '
                         || TO_CHAR (NVL (c.pol_seq_no, 0), '0999999')
                                                                      pol_no
                    FROM gipi_parlist A, giis_line b, gipi_wpolbas c
                   WHERE A.pack_par_id = p_pack_par_id
                     AND A.line_cd = b.line_cd
                     AND A.par_id = c.par_id
                     AND A.par_status NOT IN (98, 99)
                ORDER BY (SELECT MIN (item_no)
                            FROM gipi_witem z
                           WHERE z.par_id = A.par_id))
      LOOP
         v_par.par_id := i.par_id;
         v_par.line_cd := i.line_cd;
         v_par.line_name := i.line_name;
         v_par.iss_cd := i.iss_cd;
         v_par.par_yy := i.par_yy;
         v_par.issue_yy := i.issue_yy;
         v_par.par_seq_no := i.par_seq_no;
         v_par.quote_seq_no := i.quote_seq_no;
         v_par.remarks := i.remarks;
         v_par.subline_cd := i.subline_cd;
         v_par.par_no := i.par_no;
         v_par.pol_seq_no := i.pol_seq_no;
         v_par.endt_policy_no := i.pol_no;
         -- andrew - 10.07.2011 - added columns
         v_par.par_type := i.par_type;
         v_par.pack_pol_flag := i.pack_pol_flag;
         v_par.pol_flag := i.pol_flag;
         -- end andrew
         
         FOR c1 IN (SELECT subline_name
                      FROM giis_subline A, gipi_wpack_line_subline b
                     WHERE A.line_cd = b.pack_line_cd
                       AND A.subline_cd = b.pack_subline_cd
                       AND b.pack_par_id = p_pack_par_id
                       AND b.par_id = i.par_id)
         LOOP
            v_par.subline_name := c1.subline_name;
         END LOOP;

         PIPE ROW (v_par);
      END LOOP;

      RETURN;
   END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS001- Par Listing
**                  GIPIS058 - Endt Par Listing
**  Description   : Function returns necessary details for par listings
*/
   FUNCTION get_gipi_parlist (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_par_type       gipi_parlist.par_type%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         VARCHAR2,
      p_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE,
      p_ri_switch      VARCHAR2
   )
      RETURN gipi_parlist_tab PIPELINED
   AS
      v_parlist   gipi_parlist_type;
      v_iss_cd    giis_issource.iss_cd%TYPE;
   BEGIN
      FOR iss IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_iss_cd := iss.param_value_v;
      END LOOP;

      FOR i IN
         (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.assd_no, LTRIM (b.assd_name) assd_name,
                   A.underwriter, c.pack_pol_flag, c.line_name, d.bank_ref_no,
                   d.cn_date_printed,
                   cg_ref_codes_pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                   A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') par_no,
                   d.pol_flag, d.subline_cd, d.pol_seq_no, d.issue_yy
              FROM gipi_parlist A, giis_assured b, giis_line c,
                   gipi_wpolbas d
             WHERE check_user_per_line2 (A.line_cd, p_iss_cd, p_module_id, p_user_id) = 1
               AND Check_User_Per_Iss_Cd2 (NVL (p_line_cd, A.line_cd),
                                          A.iss_cd,
                                          p_module_id, 
                                          p_user_id
                                         ) = 1
               AND A.line_cd || '-' || A.iss_cd IN (
                      SELECT line_cd || '-' || iss_cd
                        FROM TABLE
                                (gipi_parlist_pkg.parlist_security
                                                                  (p_module_id, p_user_id)
                                ))
               AND par_status < 10
               AND assign_sw = 'Y'
               AND A.underwriter = NVL (p_user_id, A.underwriter)
               AND A.par_type = NVL (p_par_type, 'P')
               AND A.par_id = d.par_id(+)
               AND A.assd_no = b.assd_no(+)
               AND A.line_cd = c.line_cd
               AND A.line_cd = NVL (p_line_cd, A.line_cd)
               --AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               --AND a.iss_cd != v_iss_cd
               AND A.iss_cd LIKE UPPER(NVL (decode(p_ri_switch,'Y',v_iss_cd,p_iss_cd), A.iss_cd))
               AND decode(p_ri_switch,'Y','1',A.iss_cd) != decode(p_ri_switch,'Y','2',v_iss_cd)
               AND A.pack_par_id IS NULL
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
               AND UPPER
                      (cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                      ) LIKE
                      UPPER
                         (NVL
                             (p_status,
                              cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                             )
                         )
               AND UPPER (A.par_yy) LIKE UPPER (NVL (p_par_yy, A.par_yy))
               AND UPPER (A.par_seq_no) LIKE
                                      UPPER (NVL (p_par_seq_no, A.par_seq_no))
               AND UPPER (A.quote_seq_no) LIKE
                                  UPPER (NVL (p_quote_seq_no, A.quote_seq_no))
               AND UPPER (A.underwriter) LIKE
                                    UPPER (NVL (p_underwriter, A.underwriter))
               AND UPPER (NVL (bank_ref_no, '*')) LIKE
                         '%'
                      || UPPER (NVL (p_bank_ref_no,
                                     DECODE (bank_ref_no,
                                             NULL, '*',
                                             bank_ref_no
                                            )
                                    )
                               )
          ORDER BY    LTRIM (A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC)
      LOOP
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.line_name := i.line_name;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.status := i.status;
         v_parlist.par_type := i.par_type;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         v_parlist.par_no := i.par_no;
         v_parlist.par_status := i.par_status;
         v_parlist.pol_flag := i.pol_flag;
         v_parlist.subline_cd := i.subline_cd;
         v_parlist.pol_seq_no := i.pol_seq_no;
         v_parlist.issue_yy := i.issue_yy;
         v_parlist.bank_ref_no := i.bank_ref_no;
         v_parlist.cn_date_printed := i.cn_date_printed;
         PIPE ROW (v_parlist);
      END LOOP;

      RETURN;
   END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS001- Par Listing
**                  GIPIS058 - Endt Par Listing
**  Description   : Procedure updates remarks for par listings
*/
   PROCEDURE update_par_remarks (
      p_par_id        gipi_parlist.par_id%TYPE,
      p_par_remarks   gipi_parlist.remarks%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_parlist
         SET remarks = p_par_remarks
       WHERE par_id = p_par_id;
   END update_par_remarks;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS001 - Par Listing - Policy
**             GIPIS058 - Par Listing - Endorsement
**  Description   : Function checks user accessible line_cd and iss_cd
*/
   FUNCTION gipi_parlist_security (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN parlist_security_tab PIPELINED
   IS
      v_line_iss   parlist_security_type;
   BEGIN
      FOR line IN (SELECT d.line_cd, b.iss_cd
                     FROM giis_users A,
                          giis_user_iss_cd b,
                          giis_modules_tran c,
                          giis_user_line d
                    WHERE 1 = 1
                      AND A.user_id = b.userid
                      AND A.user_id = p_user_id
                      AND b.tran_cd = c.tran_cd
                      AND c.module_id = p_module_id
                      AND d.userid = b.userid
                      AND d.iss_cd = b.iss_cd
                      AND d.tran_cd = b.tran_cd
                   UNION
                   SELECT d.line_cd, b.iss_cd
                     FROM giis_users A,
                          giis_user_grp_dtl b,
                          giis_modules_tran c,
                          giis_user_grp_line d
                    WHERE 1 = 1
                      AND A.user_id = p_user_id
                      AND A.user_grp = b.user_grp
                      AND b.tran_cd = c.tran_cd
                      AND c.module_id = p_module_id
                      AND d.user_grp = b.user_grp
                      AND d.iss_cd = b.iss_cd
                      AND d.tran_cd = b.tran_cd)
      LOOP
         v_line_iss.line_cd := line.line_cd;
         v_line_iss.iss_cd := line.iss_cd;
         PIPE ROW (v_line_iss);
      END LOOP;

      RETURN;
   END gipi_parlist_security;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS001 - Par Listing - Policy
**  Description   : Function returns necessary details for par listing policy
*/
   FUNCTION get_gipi_parlist_policy (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_all_user_sw    VARCHAR2,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE, 
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         VARCHAR2,
      p_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE,
      p_ri_switch      VARCHAR2,
      p_order_by       VARCHAR2,        --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678            
      p_asc_desc_flag  VARCHAR2,        --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_first_row      NUMBER,          --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_last_row       NUMBER           --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      
   )
      RETURN gipi_parlist_tg_tab PIPELINED
   AS
      v_parlist   gipi_parlist_tg_type;
      v_iss_cd    giis_issource.iss_cd%TYPE;
      TYPE cur_type IS REF CURSOR;      --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      c        cur_type;                --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      v_sql    VARCHAR2(32767);         --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
   BEGIN
      FOR iss IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_iss_cd := iss.param_value_v;
      END LOOP;
      /*Comment out by pjsantos 09/23/2016, optimized by codes below for GENQA 5678*/
      /*FOR i IN
         (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.assd_no, LTRIM (b.assd_name) assd_name,
                   A.underwriter, c.pack_pol_flag, c.line_name, d.bank_ref_no,
                   TO_CHAR(d.cn_date_printed, 'MM-DD-YYYY') cn_date_printed,
                   cg_ref_codes_pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                   /*ESCAPE_VALUE(A.remarks)*//*A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') par_no,
                   d.pol_flag, d.subline_cd, d.pol_seq_no, d.issue_yy
              FROM gipi_parlist A, giis_assured b, giis_line c,
                   gipi_wpolbas d
             WHERE check_user_per_line1 (NVL (p_line_cd, A.line_cd),
                                         A.iss_cd,
                                         p_user_id,
                                         p_module_id
                                        ) = 1
               AND check_user_per_iss_cd1 (NVL (p_line_cd, A.line_cd),
                                           A.iss_cd,
                                           p_user_id,
                                           p_module_id
                                          ) = 1
               AND A.line_cd || '-' || A.iss_cd IN (
                      SELECT line_cd || '-' || iss_cd
                        FROM TABLE
                                (gipi_parlist_pkg.gipi_parlist_security
                                                                 (p_module_id,
                                                                  p_user_id
                                                                 )
                                ))
               AND par_status < 10
               AND assign_sw = 'Y'
               AND A.underwriter =
                         DECODE (p_all_user_sw,
                                 'Y', A.underwriter,
                                 p_user_id
                                )
               AND A.par_type = 'P'
               AND A.par_id = d.par_id(+)
               AND A.assd_no = b.assd_no(+)
               AND A.line_cd = c.line_cd
               AND A.line_cd = NVL (p_line_cd, A.line_cd)
               AND A.iss_cd LIKE UPPER(NVL (decode(p_ri_switch,'Y',v_iss_cd,p_iss_cd), A.iss_cd))
               AND decode(p_ri_switch,'Y','1',A.iss_cd) != decode(p_ri_switch,'Y','2',v_iss_cd)
               AND A.pack_par_id IS NULL
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
               AND UPPER
                      (cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                      ) LIKE
                      UPPER
                         (NVL
                             (p_status,
                              cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                             )
                         )
               AND UPPER (A.par_yy) LIKE UPPER (NVL (p_par_yy, A.par_yy))
               AND UPPER (A.par_seq_no) LIKE
                                      UPPER (NVL (p_par_seq_no, A.par_seq_no))
               AND UPPER (A.quote_seq_no) LIKE
                                  UPPER (NVL (p_quote_seq_no, A.quote_seq_no))
               AND UPPER (A.underwriter) LIKE
                                    UPPER (NVL (p_underwriter, A.underwriter))
               AND UPPER (NVL (bank_ref_no, '*')) LIKE
                         '%'
                      || UPPER (NVL (p_bank_ref_no,
                                     DECODE (bank_ref_no,
                                             NULL, '*',
                                             bank_ref_no
                                            )
                                    )
                               )
          ORDER BY    LTRIM (A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC)
      LOOP
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.line_name := i.line_name;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.status := i.status;
         v_parlist.par_type := i.par_type;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         v_parlist.par_no := i.par_no;
         v_parlist.par_status := i.par_status;
         v_parlist.pol_flag := i.pol_flag; 
         v_parlist.subline_cd := i.subline_cd;
         v_parlist.pol_seq_no := i.pol_seq_no;
         v_parlist.issue_yy := i.issue_yy;
         v_parlist.bank_ref_no := i.bank_ref_no;
         v_parlist.cn_date_printed := i.cn_date_printed;
         PIPE ROW (v_parlist);
      END LOOP;*/
      v_sql := v_sql || 'SELECT mainsql.*
            FROM (SELECT COUNT (1) OVER () count_, outersql.*
                    FROM (SELECT ROWNUM rownum_, innersql.*
                            FROM (SELECT A.par_id,
                                 A.line_cd,
                                 A.iss_cd,
                                 A.par_yy,
                                 A.par_seq_no,
                                 A.quote_seq_no,
                                 A.assd_no,
                                 LTRIM (b.assd_name) assd_name,
                                 A.underwriter,
                                 c.pack_pol_flag,
                                 c.line_name,
                                 d.bank_ref_no,
                                 TO_CHAR (d.cn_date_printed, ''MM-DD-YYYY'')
                                    cn_date_printed,
                                    DECODE(a.par_status, 10, ''POSTED'', 2, ''WITH PAR'', 3, ''WITH BASIC INFORMATION'', 4, ''WITH ITEM INFORMATION'', 
                                           5, ''WITH PERIL INFORMATION'', 6, ''WITH BILL'', 98, ''CANCELLED'', 99, ''DELETED'')  status,
                                 A.par_type,
                                 A.par_status,
                                 A.quote_id,
                                 A.assign_sw,
                                 A.remarks,
                                    A.line_cd 
                                 || ''-''
                                 || A.iss_cd
                                 || ''-''
                                 || LTRIM(RTRIM(TO_CHAR (A.par_yy, ''09'')))
                                 || ''-''
                                 || LTRIM(RTRIM(TO_CHAR (A.par_seq_no, ''000009'')))
                                 || ''-''
                                 || LTRIM(RTRIM(TO_CHAR (A.quote_seq_no, ''09'')))
                                    par_no,
                                 d.pol_flag,
                                 d.subline_cd,
                                 d.pol_seq_no,
                                 d.issue_yy
                            FROM gipi_parlist A,
                                 giis_assured b,
                                 giis_line c,
                                 gipi_wpolbas d
                           WHERE 1=1
                                 AND EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''UW'', :p_module_id, :p_user_id)) WHERE branch_cd = a.iss_cd)
                                 AND A.line_cd || ''-'' || A.iss_cd IN
                                        (SELECT line_cd || ''-'' || iss_cd
                                           FROM TABLE (
                                                   gipi_parlist_pkg.gipi_parlist_security (
                                                      :p_module_id,
                                                      :p_user_id)))
                                 AND par_status < 10
                                 AND assign_sw = ''Y''
                                 AND A.underwriter =
                                        DECODE (:p_all_user_sw,
                                                ''Y'', A.underwriter,
                                                :p_user_id)
                                 AND A.par_type = ''P''
                                 AND A.par_id = d.par_id(+)
                                 AND A.assd_no = b.assd_no(+)
                                 AND A.line_cd = c.line_cd
                                 AND A.line_cd = NVL (:p_line_cd, A.line_cd)
                                 AND A.iss_cd LIKE
                                        UPPER (
                                           NVL (
                                              DECODE (:p_ri_switch,
                                                      ''Y'', :v_iss_cd,
                                                      :p_iss_cd),
                                              A.iss_cd))
                                 AND DECODE (:p_ri_switch, ''Y'', ''1'', A.iss_cd) !=
                                        DECODE (:p_ri_switch,
                                                ''Y'', ''2'',
                                                :v_iss_cd)
                                 AND A.pack_par_id IS NULL
                                 AND UPPER (NVL (assd_name, ''*'')) LIKE
                                        UPPER (
                                           NVL (
                                              :p_assd_name,
                                              DECODE (assd_name,
                                                      NULL, ''*'',
                                                      assd_name)))
                                 AND  DECODE(a.par_status, 10, ''POSTED'', 2, ''WITH PAR'', 3, ''WITH BASIC INFORMATION'', 4, ''WITH ITEM INFORMATION'', 
                                           5, ''WITH PERIL INFORMATION'', 6, ''WITH BILL'', 98, ''CANCELLED'', 99, ''DELETED'')
                                 LIKE
                                        UPPER (
                                           NVL (
                                              :p_status, DECODE(a.par_status, 10, ''POSTED'', 2, ''WITH PAR'', 3, ''WITH BASIC INFORMATION'', 4, ''WITH ITEM INFORMATION'', 
                                           5, ''WITH PERIL INFORMATION'', 6, ''WITH BILL'', 98, ''CANCELLED'', 99, ''DELETED'')))
                                 AND UPPER (A.par_yy) LIKE
                                        UPPER (NVL (:p_par_yy, A.par_yy))
                                 AND UPPER (A.par_seq_no) LIKE
                                        UPPER (
                                           NVL (:p_par_seq_no, A.par_seq_no))
                                 AND UPPER (A.quote_seq_no) LIKE
                                        UPPER (
                                           NVL (:p_quote_seq_no, A.quote_seq_no))
                                 AND UPPER (A.underwriter) LIKE
                                        UPPER (
                                           NVL (:p_underwriter, A.underwriter))
                                 AND UPPER (NVL (bank_ref_no, ''*'')) LIKE
                                           ''%''
                                        || UPPER (
                                              NVL (
                                                 :p_bank_ref_no,
                                                 DECODE (bank_ref_no, 
                                                         NULL, ''*'',
                                                         bank_ref_no)))';
                
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'parNo'
         THEN        
          v_sql := v_sql || ' ORDER BY par_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_sql := v_sql || ' ORDER BY assd_name ';
        ELSIF  p_order_by = 'underwriter'
         THEN
          v_sql := v_sql || ' ORDER BY underwriter ';
        ELSIF  p_order_by = 'status'
         THEN
          v_sql := v_sql || ' ORDER BY status '; 
        ELSIF  p_order_by = 'remarks'
         THEN        
          v_sql := v_sql || ' ORDER BY remarks '; 
        ELSIF  p_order_by = 'bankRefNo'
         THEN
          v_sql := v_sql || ' ORDER BY bank_ref_no '; 
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF;  
        
        
        v_sql := v_sql || ', LTRIM (A.line_cd)
                                 || ''-''
                                 || A.iss_cd
                                 || ''-''
                                 || TO_CHAR (A.par_yy, ''09'')
                                 || ''-''
                                 || TO_CHAR (A.par_seq_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (A.quote_seq_no, ''09'') DESC';
    ELSE
           v_sql := v_sql || ' ORDER BY LTRIM (A.line_cd)
                                 || ''-''
                                 || A.iss_cd
                                 || ''-''
                                 || TO_CHAR (A.par_yy, ''09'')
                                 || ''-''
                                 || TO_CHAR (A.par_seq_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (A.quote_seq_no, ''09'') DESC';
    END IF;
    
    v_sql := v_sql || ') innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
    OPEN c FOR v_sql USING  p_module_id, p_user_id, p_module_id, p_user_id, p_all_user_sw, p_user_id,
                            p_line_cd, p_ri_switch, v_iss_cd, p_iss_cd, p_ri_switch, p_ri_switch, v_iss_cd,
                            p_assd_name, p_status, p_par_yy, p_par_seq_no, p_quote_seq_no, p_underwriter,
                            p_bank_ref_no;    
           LOOP
           FETCH c INTO 
           v_parlist.count_,
           v_parlist.rownum_,           
           v_parlist.par_id,
           v_parlist.line_cd,
           v_parlist.iss_cd,
           v_parlist.par_yy,
           v_parlist.par_seq_no,
           v_parlist.quote_seq_no,
           v_parlist.assd_no,
           v_parlist.assd_name,
           v_parlist.underwriter,
           v_parlist.pack_pol_flag,
           v_parlist.line_name,
           v_parlist.bank_ref_no,
           v_parlist.cn_date_printed,
           v_parlist.status,
           v_parlist.par_type,
           v_parlist.par_status,
           v_parlist.quote_id,
           v_parlist.assign_sw,
           v_parlist.remarks,
           v_parlist.par_no,
           v_parlist.pol_flag,
           v_parlist.subline_cd,
           v_parlist.pol_seq_no,
           v_parlist.issue_yy;

           EXIT WHEN c%NOTFOUND;              
           PIPE ROW (v_parlist);
           END LOOP;      
           CLOSE c;
  
      RETURN;
   END;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : February 11, 2011
**  Reference By  : GIPIS058 - Par Listing - Endorsement
**  Description   : Function returns necessary details for par listing(endoresement)
*/
   FUNCTION get_gipi_parlist_endt (
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_module_id      giis_user_grp_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_all_user_sw    VARCHAR2,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_status         VARCHAR2,
      p_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE,
      p_ri_switch      VARCHAR2,
      p_order_by       VARCHAR2,        --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678             
      p_asc_desc_flag  VARCHAR2,        --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_first_row      NUMBER,          --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      p_last_row       NUMBER           --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
   )
      RETURN gipi_parlist_tg_tab PIPELINED
   AS
      v_parlist   gipi_parlist_tg_type;
      v_iss_cd    giis_issource.iss_cd%TYPE;
      TYPE cur_type IS REF CURSOR;      --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      c        cur_type;                --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
      v_sql    VARCHAR2(32767);         --added by pjsantos @pcic 09/23/2016, for optimization GENQA 5678
   BEGIN
      FOR iss IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_iss_cd := iss.param_value_v;
      END LOOP;
/*
      FOR i IN
         (SELECT   A.par_id, A.line_cd, A.iss_cd, A.par_yy, A.par_seq_no,
                   A.quote_seq_no, A.assd_no, LTRIM (b.assd_name) assd_name,
                   A.underwriter, c.pack_pol_flag, c.line_name, d.bank_ref_no,
                   TO_CHAR(d.cn_date_printed, 'MM-DD-YYYY') cn_date_printed,
                   cg_ref_codes_pkg.get_rv_meaning
                                           ('GIPI_PARLIST.PAR_STATUS',
                                            A.par_status
                                           ) status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                   --ESCAPE_VALUE(A.remarks) remarks, commented out escape_value by robert 09.16.2013
                   A.remarks,
                      A.line_cd
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') par_no,
                   d.pol_flag, d.subline_cd, d.pol_seq_no, d.issue_yy
              FROM gipi_parlist A, giis_assured b, giis_line c,
                   gipi_wpolbas d
             WHERE check_user_per_line1 (NVL (p_line_cd, A.line_cd),
                                         A.iss_cd,
                                         p_user_id,
                                         p_module_id
                                        ) = 1
               AND check_user_per_iss_cd1 (NVL (p_line_cd, A.line_cd),
                                           A.iss_cd,
                                           p_user_id,
                                           p_module_id
                                          ) = 1
               AND A.line_cd || '-' || A.iss_cd IN (
                      SELECT line_cd || '-' || iss_cd
                        FROM TABLE
                                (gipi_parlist_pkg.gipi_parlist_security
                                                                 (p_module_id,
                                                                  p_user_id
                                                                 )
                                ))
               AND par_status < 10
               AND assign_sw = 'Y'
               AND A.underwriter =
                         DECODE (p_all_user_sw,
                                 'Y', A.underwriter,
                                 p_user_id
                                )
               AND A.par_type = 'E'
               AND A.par_id = d.par_id(+)
               AND A.assd_no = b.assd_no(+)
               AND A.line_cd = c.line_cd
               AND A.line_cd = NVL (p_line_cd, A.line_cd)
               --AND a.iss_cd LIKE UPPER(NVL (p_iss_cd, a.iss_cd))
               AND A.iss_cd LIKE UPPER(NVL (decode(p_ri_switch,'Y',v_iss_cd,p_iss_cd), A.iss_cd))
               AND decode(p_ri_switch,'Y','1',A.iss_cd) != decode(p_ri_switch,'Y','2',v_iss_cd)
               --AND a.iss_cd != v_iss_cd
               AND A.pack_par_id IS NULL
               AND UPPER (NVL (assd_name, '*')) LIKE
                      UPPER (NVL (p_assd_name,
                                  DECODE (assd_name, NULL, '*', assd_name)
                                 )
                            )
               AND UPPER
                      (cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                      ) LIKE
                      UPPER
                         (NVL
                             (p_status,
                              cg_ref_codes_pkg.get_rv_meaning
                                                   ('GIPI_PARLIST.PAR_STATUS',
                                                    A.par_status
                                                   )
                             )
                         )
               AND UPPER (A.par_yy) LIKE UPPER (NVL (p_par_yy, A.par_yy))
               AND UPPER (A.par_seq_no) LIKE
                                      UPPER (NVL (p_par_seq_no, A.par_seq_no))
               AND UPPER (A.quote_seq_no) LIKE
                                  UPPER (NVL (p_quote_seq_no, A.quote_seq_no))
               AND UPPER (A.underwriter) LIKE
                                    UPPER (NVL (p_underwriter, A.underwriter))
               AND UPPER (NVL (bank_ref_no, '*')) LIKE
                         '%'
                      || UPPER (NVL (p_bank_ref_no,
                                     DECODE (bank_ref_no,
                                             NULL, '*',
                                             bank_ref_no
                                            )
                                    )
                               )
          ORDER BY    LTRIM (A.line_cd)
                   || '-'
                   || A.iss_cd
                   || '-'
                   || TO_CHAR (A.par_yy, '09')
                   || '-'
                   || TO_CHAR (A.par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (A.quote_seq_no, '09') DESC)
      LOOP
         v_parlist.par_id := i.par_id;
         v_parlist.line_cd := i.line_cd;
         v_parlist.line_name := i.line_name;
         v_parlist.iss_cd := i.iss_cd;
         v_parlist.par_yy := i.par_yy;
         v_parlist.par_seq_no := i.par_seq_no;
         v_parlist.quote_seq_no := i.quote_seq_no;
         v_parlist.assd_no := i.assd_no;
         v_parlist.assd_name := i.assd_name;
         v_parlist.underwriter := i.underwriter;
         v_parlist.pack_pol_flag := i.pack_pol_flag;
         v_parlist.status := i.status;
         v_parlist.par_type := i.par_type;
         v_parlist.quote_id := i.quote_id;
         v_parlist.assign_sw := i.assign_sw;
         v_parlist.remarks := i.remarks;
         v_parlist.par_no := i.par_no;
         v_parlist.par_status := i.par_status;
         v_parlist.pol_flag := i.pol_flag;
         v_parlist.subline_cd := i.subline_cd;
         v_parlist.pol_seq_no := i.pol_seq_no;
         v_parlist.issue_yy := i.issue_yy;
         v_parlist.bank_ref_no := i.bank_ref_no;
         v_parlist.cn_date_printed := i.cn_date_printed;
         PIPE ROW (v_parlist);
      END LOOP;    Comemnt out by pjsantos 09/27/2016, replaced by codes below for optimization GENWA 5678*/

     v_sql := v_sql ||   'SELECT mainsql.*
            FROM (SELECT COUNT (1) OVER () count_, outersql.*
                     FROM (SELECT ROWNUM rownum_, innersql.*
                            FROM (                  
         SELECT A.par_id,
                A.line_cd,
                A.iss_cd,
                A.par_yy,
                A.par_seq_no,
                A.quote_seq_no,
                A.assd_no,
                LTRIM (b.assd_name) assd_name,
                A.underwriter,
                c.pack_pol_flag,
                c.line_name,
                d.bank_ref_no,
                TO_CHAR (d.cn_date_printed, ''MM-DD-YYYY'') cn_date_printed,
                 DECODE(a.par_status, 10, ''POSTED'', 2, ''WITH PAR'', 3, ''WITH BASIC INFORMATION'', 4, ''WITH ITEM INFORMATION'', 
                                           5, ''WITH PERIL INFORMATION'', 6, ''WITH BILL'', 98, ''CANCELLED'', 99, ''DELETED'')  status,
                   A.par_type, A.par_status, A.quote_id, A.assign_sw,
                  A.remarks,
                      A.line_cd
                   || ''-''
                   || A.iss_cd
                   || ''-''
                   || LTRIM(RTRIM(TO_CHAR (A.par_yy, ''09'')))
                   || ''-''
                   || LTRIM(RTRIM(TO_CHAR (A.par_seq_no, ''000009'')))
                   || ''-''
                   || LTRIM(RTRIM(TO_CHAR (A.quote_seq_no, ''09''))) par_no,
                   d.pol_flag, d.subline_cd, d.pol_seq_no, d.issue_yy
              FROM gipi_parlist A, giis_assured b, giis_line c,
                   gipi_wpolbas d
             WHERE 1=1
               AND EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''UW'', :p_module_id, :p_user_id)) WHERE branch_cd = a.iss_cd)
               AND A.line_cd || ''-'' || A.iss_cd IN (
                      SELECT line_cd || ''-'' || iss_cd
                        FROM TABLE
                                (gipi_parlist_pkg.gipi_parlist_security
                                                                 (:p_module_id,
                                                                  :p_user_id
                                                                 )
                                ))
               AND par_status < 10
               AND assign_sw = ''Y''
               AND A.underwriter =
                         DECODE (:p_all_user_sw,
                                 ''Y'', A.underwriter,
                                 :p_user_id
                                )
               AND A.par_type = ''E''
               AND A.par_id = d.par_id(+)
               AND A.assd_no = b.assd_no(+)
               AND A.line_cd = c.line_cd
               AND A.line_cd = NVL (:p_line_cd, A.line_cd)
               AND A.iss_cd LIKE UPPER(NVL (decode(:p_ri_switch,''Y'',:v_iss_cd,:p_iss_cd), A.iss_cd))
               AND decode(:p_ri_switch,''Y'',''1'',A.iss_cd) != decode(:p_ri_switch,''Y'',''2'',:v_iss_cd)
               AND A.pack_par_id IS NULL
               AND UPPER (NVL (assd_name, ''*'')) LIKE
                      UPPER (NVL (:p_assd_name,
                                  DECODE (assd_name, NULL, ''*'', assd_name)
                                 )
                            )
               AND DECODE(a.par_status, 10, ''POSTED'', 2, ''WITH PAR'', 3, ''WITH BASIC INFORMATION'', 4, ''WITH ITEM INFORMATION'', 
                                           5, ''WITH PERIL INFORMATION'', 6, ''WITH BILL'', 98, ''CANCELLED'', 99, ''DELETED'')
                   LIKE
                      UPPER
                         (NVL
                             (:p_status,DECODE(a.par_status, 10, ''POSTED'', 2, ''WITH PAR'', 3, ''WITH BASIC INFORMATION'', 4, ''WITH ITEM INFORMATION'', 
                                           5, ''WITH PERIL INFORMATION'', 6, ''WITH BILL'', 98, ''CANCELLED'', 99, ''DELETED'')))
               AND UPPER (A.par_yy) LIKE UPPER (NVL (:p_par_yy, A.par_yy))
               AND UPPER (A.par_seq_no) LIKE
                                      UPPER (NVL (:p_par_seq_no, A.par_seq_no))
               AND UPPER (A.quote_seq_no) LIKE
                                  UPPER (NVL (:p_quote_seq_no, A.quote_seq_no))
               AND UPPER (A.underwriter) LIKE
                                    UPPER (NVL (:p_underwriter, A.underwriter))
               AND UPPER (NVL (bank_ref_no, ''*'')) LIKE
                         ''%''
                      || UPPER (NVL (:p_bank_ref_no,
                                     DECODE (bank_ref_no,
                                             NULL, ''*'',
                                             bank_ref_no)))'; 
   
 IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'parNo'
         THEN        
          v_sql := v_sql || ' ORDER BY par_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_sql := v_sql || ' ORDER BY assd_name ';
        ELSIF  p_order_by = 'underwriter'
         THEN
          v_sql := v_sql || ' ORDER BY underwriter ';
        ELSIF  p_order_by = 'status'
         THEN
          v_sql := v_sql || ' ORDER BY status '; 
        ELSIF  p_order_by = 'remarks'
         THEN        
          v_sql := v_sql || ' ORDER BY remarks '; 
        ELSIF  p_order_by = 'bankRefNo'
         THEN
          v_sql := v_sql || ' ORDER BY bank_ref_no '; 
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF;  
        
        
        v_sql := v_sql || ', LTRIM (A.line_cd)
                                 || ''-''
                                 || A.iss_cd
                                 || ''-''
                                 || TO_CHAR (A.par_yy, ''09'')
                                 || ''-''
                                 || TO_CHAR (A.par_seq_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (A.quote_seq_no, ''09'') DESC';
    ELSE
           v_sql := v_sql || ' ORDER BY LTRIM (A.line_cd)
                                 || ''-''
                                 || A.iss_cd
                                 || ''-''
                                 || TO_CHAR (A.par_yy, ''09'')
                                 || ''-''
                                 || TO_CHAR (A.par_seq_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (A.quote_seq_no, ''09'') DESC';
    END IF;
    
    v_sql := v_sql || ') innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
   
   OPEN c FOR v_sql USING   p_module_id, p_user_id, p_module_id, p_user_id, p_all_user_sw, p_user_id,
                            p_line_cd, p_ri_switch, v_iss_cd, p_iss_cd, p_ri_switch, p_ri_switch, v_iss_cd,
                            p_assd_name, p_status, p_par_yy, p_par_seq_no, p_quote_seq_no, p_underwriter,
                            p_bank_ref_no;    
           LOOP
           FETCH c INTO  
           v_parlist.count_,
           v_parlist.rownum_,           
           v_parlist.par_id,
           v_parlist.line_cd,
           v_parlist.iss_cd,
           v_parlist.par_yy,
           v_parlist.par_seq_no,
           v_parlist.quote_seq_no,
           v_parlist.assd_no,
           v_parlist.assd_name,
           v_parlist.underwriter,
           v_parlist.pack_pol_flag,
           v_parlist.line_name,
           v_parlist.bank_ref_no,
           v_parlist.cn_date_printed,
           v_parlist.status,
           v_parlist.par_type,
           v_parlist.par_status,
           v_parlist.quote_id,
           v_parlist.assign_sw,
           v_parlist.remarks,
           v_parlist.par_no,
           v_parlist.pol_flag,
           v_parlist.subline_cd,
           v_parlist.pol_seq_no,
           v_parlist.issue_yy;

           EXIT WHEN c%NOTFOUND;              
           PIPE ROW (v_parlist);
           END LOOP;      
           CLOSE c; 
     
     RETURN;
   END;
   
      
   /*
**  Created by    : Anthony Santos
**  Date Created  : February 22, 2011
**  Reference By  : GIPIS026 - Bill Premiums
**  Description   : Set par status of par
*/

   PROCEDURE update_par_status_bill_prem (
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_pack_par_id     IN   gipi_pack_parlist.pack_par_id%TYPE,
      p_item_grp        IN   gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no   IN   gipi_winvoice.takeup_seq_no%TYPE
   )
   IS
      CURSOR A
      IS
         SELECT property
           FROM gipi_winvoice
          WHERE par_id = p_par_id
            AND item_grp = p_item_grp
            AND takeup_seq_no = p_takeup_seq_no;

      v_exist   NUMBER := 0;
   BEGIN
      FOR a1 IN A
      LOOP
         IF a1.property IS NULL
         THEN
            v_exist := 1;
         ELSE
            NULL;
         END IF;
      END LOOP;

      IF v_exist = 1
      THEN
         UPDATE gipi_parlist
            SET par_status = 5
          WHERE par_id = p_par_id;

         IF p_pack_par_id IS NOT NULL
         THEN
            UPDATE gipi_pack_parlist
               SET par_status = 5
             WHERE pack_par_id = p_pack_par_id;
         END IF;
      ELSE
         UPDATE gipi_parlist
            SET par_status = 6
          WHERE par_id = p_par_id;

         IF p_pack_par_id IS NOT NULL
         THEN
            UPDATE gipi_pack_parlist
               SET par_status = 6
             WHERE pack_par_id = p_pack_par_id;
         END IF;
      END IF;
   END;

   
/*
**  Created by    : Andrew Robes
**  Date Created  : March 16, 2011
**  Reference By  : Package item modules
**  Description   : Funtion to retreive the list of par in package
*/   
  FUNCTION get_pack_item_par_list(p_pack_par_id GIPI_PARLIST.pack_par_id%TYPE,
                                  p_line_cd     GIPI_PARLIST.line_cd%TYPE)
    RETURN pack_item_par_list_tab PIPELINED IS
      v_par   pack_item_par_list_type;
   BEGIN
      FOR i IN (/*SELECT   A.par_id, A.line_cd, b.line_name , A.iss_cd,
                         A.par_yy, A.par_seq_no, A.quote_seq_no, A.par_status,
                         c.subline_cd, d.subline_name, d.op_flag,
                         A.line_cd||'-'||A.iss_cd||'-'||TO_CHAR(A.par_yy,'09')||'-'||TO_CHAR(A.par_seq_no,'000009')||'-'||TO_CHAR(A.quote_seq_no,'009') par_no
                    FROM gipi_parlist A
                        ,giis_line b
                        ,gipi_wpolbas c
                        ,giis_subline d
                   WHERE A.pack_par_id = p_pack_par_id
                     AND A.line_cd = NVL(p_line_cd, A.line_cd)
                     AND A.line_cd = b.line_cd
                     AND A.par_id = c.par_id
                     AND A.line_cd = d.line_cd
                     AND c.subline_cd = d.subline_cd
                     AND A.par_status NOT IN (98, 99)*/
        /*
        -- comment ko muna yung select statement sa taas
        -- may problem sa paghandle ng line_cd/menu_line_cd
        -- ibalik nyo na lang sa dati kapag may problem
        -- yung papalit ko
        -- mark jm 06.21.2011
        */
        SELECT A.par_id, A.pack_par_id, A.line_cd, giis_line_pkg.get_line_name(a.line_cd) line_name, A.iss_cd,
               A.par_yy, A.par_seq_no, A.quote_seq_no, A.par_status,
               c.subline_cd, d.subline_name, d.op_flag,
               A.line_cd||'-'||A.iss_cd||'-'||TO_CHAR(A.par_yy,'09')||'-'||TO_CHAR(A.par_seq_no,'000009')||'-'||TO_CHAR(A.quote_seq_no,'09') par_no,
               giis_line_pkg.get_menu_line_cd(a.line_cd) menu_line_cd,
               c.pol_flag, c.pack_pol_flag
          FROM gipi_parlist A,
               gipi_wpolbas c,
               giis_subline d
         WHERE A.pack_par_id = p_pack_par_id   
           AND giis_line_pkg.get_menu_line_cd(A.line_cd) = giis_line_pkg.get_menu_line_cd(NVL(p_line_cd, A.line_cd))          
           AND A.par_id = c.par_id
           AND A.line_cd = d.line_cd
           AND c.subline_cd = d.subline_cd
           AND A.par_status NOT IN (98, 99))
      LOOP
        v_par.par_id         := i.par_id;
        v_par.pack_par_id     := i.pack_par_id;
        v_par.par_status     := i.par_status;
        v_par.line_cd         := i.line_cd;
        v_par.line_name     := i.line_name;
        v_par.iss_cd         := i.iss_cd;
        v_par.par_yy         := i.par_yy;
        v_par.par_seq_no     := i.par_seq_no;
        v_par.quote_seq_no     := i.quote_seq_no;
        v_par.subline_cd     := i.subline_cd;
        v_par.subline_name     := i.subline_name;
        v_par.op_flag         := i.op_flag;
        v_par.par_no         := i.par_no;
        v_par.menu_line_cd    := i.menu_line_cd;
        v_par.pol_flag          := i.pol_flag;
        v_par.pack_pol_flag      := i.pack_pol_flag;
        
        IF i.line_cd <> GIISP.V('LINE_CODE_FI') THEN
            v_par.region_cd := giis_issource_pkg.get_region_cd(i.iss_cd);
        ELSE
            v_par.region_cd := NULL;
        END IF;
        
        PIPE ROW (v_par);
      END LOOP;
      RETURN;
  END get_pack_item_par_list;

    /*    Date        Author                    Reference By            Description
    **    ==========    ====================    =======================    ============================
    **    07.27.2011    Veronica V. Raymundo    GIPIS096 - Package Endt Function to retreive the list of par in package including
    **                                        PAR Policy Items        pars that have been deleted and cancelled.
    **    09.12.2011    mark jm                    xxxxx                    replace existing sql statement to fetch the correct records
    **    10.17.2011    Veronica V. Raymundo                                - return to original query
    */
    FUNCTION get_all_pack_item_par(p_pack_par_id GIPI_PARLIST.pack_par_id%TYPE,
                                   p_line_cd     GIPI_PARLIST.line_cd%TYPE)
    RETURN pack_item_par_list_tab PIPELINED IS
      v_par   pack_item_par_list_type;
   BEGIN
      FOR i IN (SELECT A.par_id, A.pack_par_id, A.line_cd, giis_line_pkg.get_line_name(a.line_cd) line_name, A.iss_cd,
               A.par_yy, A.par_seq_no, A.quote_seq_no, A.par_status,
               c.subline_cd, d.subline_name, d.op_flag,
               A.line_cd||'-'||A.iss_cd||'-'||TO_CHAR(A.par_yy,'09')||'-'||TO_CHAR(A.par_seq_no,'000009')||'-'||TO_CHAR(A.quote_seq_no,'09') par_no,
               giis_line_pkg.get_menu_line_cd(a.line_cd) menu_line_cd,
               c.pol_flag, c.pack_pol_flag
          FROM gipi_parlist A,
               gipi_wpack_line_subline b,          
               gipi_wpolbas c,
               giis_subline d
         WHERE A.pack_par_id = p_pack_par_id
           AND A.pack_par_id = b.pack_par_id   
           AND giis_line_pkg.get_menu_line_cd(A.line_cd) = giis_line_pkg.get_menu_line_cd(NVL(p_line_cd, A.line_cd))          
           AND A.par_id = c.par_id
           AND A.par_id = b.par_id
           AND A.line_cd = d.line_cd
           AND b.pack_subline_cd = d.subline_cd
        /*SELECT A.par_id, A.pack_par_id, A.line_cd, giis_line_pkg.get_line_name(a.line_cd) line_name, A.iss_cd,
               A.par_yy, A.par_seq_no, A.quote_seq_no, A.par_status,
               c.subline_cd, d.subline_name, d.op_flag,
               A.line_cd||'-'||A.iss_cd||'-'||TO_CHAR(A.par_yy,'09')||'-'||TO_CHAR(A.par_seq_no,'000009')||'-'||TO_CHAR(A.quote_seq_no,'09') par_no,
               giis_line_pkg.get_menu_line_cd(a.line_cd) menu_line_cd,
               c.pol_flag, c.pack_pol_flag
          FROM gipi_parlist A,
               gipi_wpack_line_subline b,
               gipi_pack_wpolbas c,
               giis_subline d
         WHERE A.pack_par_id = p_pack_par_id
           AND A.pack_par_id = b.pack_par_id
           AND giis_line_pkg.get_menu_line_cd(A.line_cd) = giis_line_pkg.get_menu_line_cd(NVL(p_line_cd, A.line_cd))          
           AND A.pack_par_id = c.pack_par_id
           AND A.line_cd = b.pack_line_cd
           AND b.pack_subline_cd = d.subline_cd*/)
      LOOP
        v_par.par_id         := i.par_id;
        v_par.pack_par_id    := i.pack_par_id;
        v_par.par_status     := i.par_status;
        v_par.line_cd        := i.line_cd;
        v_par.line_name      := i.line_name;
        v_par.iss_cd         := i.iss_cd;
        v_par.par_yy         := i.par_yy;
        v_par.par_seq_no     := i.par_seq_no;
        v_par.quote_seq_no   := i.quote_seq_no;
        v_par.subline_cd     := i.subline_cd;
        v_par.subline_name   := i.subline_name;
        v_par.op_flag        := i.op_flag;
        v_par.par_no         := i.par_no;
        v_par.menu_line_cd   := i.menu_line_cd;
        v_par.pol_flag         := i.pol_flag;
        v_par.pack_pol_flag     := i.pack_pol_flag;
        
        IF i.line_cd <> GIISP.V('LINE_CODE_FI') THEN
            v_par.region_cd  := giis_issource_pkg.get_region_cd(i.iss_cd);
        ELSE
            v_par.region_cd := NULL;
        END IF;
        
        PIPE ROW (v_par);
      END LOOP;
      RETURN;
  END get_all_pack_item_par;   
    
  PROCEDURE set_gipi_parlist_pack (
      p_pack_par_id      gipi_parlist.pack_par_id%TYPE,
      p_par_id           gipi_parlist.par_id%TYPE,
      p_line_cd        gipi_parlist.line_cd%TYPE,
      p_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_par_type       gipi_parlist.par_type%TYPE,
      p_assign_sw      gipi_parlist.assign_sw%TYPE,
      p_par_status     gipi_parlist.par_status%TYPE,
      p_assd_no        gipi_parlist.assd_no%TYPE,
      p_quote_id       gipi_parlist.quote_id%TYPE,
      p_underwriter    gipi_parlist.underwriter%TYPE,
      p_remarks          gipi_parlist.remarks%TYPE
   ) IS
   
   BEGIN
       INSERT INTO GIPI_PARLIST(pack_par_id, par_id, line_cd, 
                             iss_cd, par_yy, quote_seq_no, 
                             par_type, assign_sw, par_status, 
                             assd_no, quote_id, underwriter, 
                             remarks)
                    VALUES(p_pack_par_id, p_par_id, p_line_cd, 
                           p_iss_cd,  p_par_yy , p_quote_seq_no, 
                           p_par_type, p_assign_sw, p_par_status, 
                           p_assd_no,  p_quote_id , p_underwriter, 
                           p_remarks);
   END;
   
  
/*
**  Created by    : Andrew Robes
**  Date Created  : April 13, 2011
**  Reference By  : (GIPIS050 - Par Creation)
**  Description   : Procedure to insert quotation to par
*/   
   PROCEDURE insert_quote_to_par(p_quote_id     GIPI_PARLIST.quote_id%TYPE
                                ,p_par_id       GIPI_PARLIST.par_id%TYPE
                                ,p_line_cd      GIPI_PARLIST.line_cd%TYPE
                                ,p_iss_cd       GIPI_PARLIST.iss_cd%TYPE
                                ,p_assd_no      GIPI_PARLIST.assd_no%TYPE
                                ,p_underwriter  GIPI_PARLIST.underwriter%TYPE
                                ,p_message      OUT VARCHAR2)
   IS
   BEGIN
         select_quote_to_par.create_gipi_wpolbas2(p_quote_id, p_par_id, p_line_cd, p_iss_cd, p_assd_no, p_underwriter, p_message);
         select_quote_to_par.create_gipi_witem  (p_quote_id,p_par_id );
         select_quote_to_par.create_item_info   (p_par_id , p_quote_id);
         select_quote_to_par.create_peril_wc    (p_par_id);
         select_quote_to_par.create_dist_deduct (p_par_id);
         select_quote_to_par.create_discounts   (p_par_id);
         select_quote_to_par.INSERT_REMINDER    (p_quote_id, p_par_id); 
         --select_quote_to_par.mortgagee_information (p_quote_id, p_par_id);
         /*added edgar 10/11/2014 to insert mortgagee from quote*/
        BEGIN
           FOR mort IN (SELECT iss_cd, item_no, mortg_cd, amount, remarks
                          FROM gipi_quote_mortgagee
                         WHERE quote_id = p_quote_id)
           LOOP
              INSERT INTO gipi_wmortgagee
                          (par_id, iss_cd, item_no, mortg_cd,
                           amount, remarks
                          )
                   VALUES (p_par_id, mort.iss_cd, mort.item_no, mort.mortg_cd,
                           mort.amount, mort.remarks
                          );
           END LOOP;

           /*FOR bond IN (SELECT obligee_no, prin_id, val_period_unit, val_period, --commented out by Gzelle 12052014
                               coll_flag, clause_type, np_no, contract_dtl,
                               contract_date, co_prin_sw, waiver_limit,
                               indemnity_text, bond_dtl, endt_eff_date, remarks
                          FROM gipi_quote_bond_basic
                         WHERE quote_id = p_quote_id)
           LOOP
              INSERT INTO gipi_wbond_basic
                          (par_id, obligee_no, prin_id,
                           val_period_unit, val_period, coll_flag,
                           clause_type, np_no, contract_dtl, contract_date,
                           co_prin_sw, waiver_limit, indemnity_text,
                           bond_dtl, endt_eff_date, remarks
                          )
                   VALUES (p_par_id, bond.obligee_no, bond.prin_id,
                           bond.val_period_unit, bond.val_period, bond.coll_flag,
                           bond.clause_type, bond.np_no, bond.contract_dtl, bond.contract_date,
                           bond.co_prin_sw, bond.waiver_limit, bond.indemnity_text,
                           bond.bond_dtl, bond.endt_eff_date, bond.remarks
                          );
           END LOOP;*/  --duplicate Insert statement for SU called in select_quote_to_par.create_item_info
        END;
         /*ended edgar 10/11/2014*/
         FOR A IN (SELECT A.item_grp
                     FROM gipi_witem A,
                          gipi_witmperl b
                    WHERE A.item_no = b.item_no
                      AND A.par_id = b.par_id  --edited by d.alcantara, 11-08-2011
                      AND A.par_id = p_par_id) 
         LOOP             
           IF A.item_grp IS NOT NULL THEN
              create_winvoice(0,0,0,p_par_id,p_line_cd, p_iss_cd);
           END IF;   
         END LOOP; 
         /*added edgar 10/15/2014 to update bond tsi and bond rate for bond PARs*/
         FOR bond IN (SELECT A.tsi_amt, b.line_cd, b.prem_rt 
                        FROM gipi_witem A,
                             gipi_witmperl b
                       WHERE A.item_no = b.item_no
                         AND A.par_id = b.par_id  --edited by d.alcantara, 11-08-2011
                         AND A.par_id = p_par_id) 
         LOOP             
            FOR line IN (SELECT menu_line_cd
                           FROM giis_line
                          WHERE line_cd = bond.line_cd)
            LOOP
                IF line.menu_line_cd = 'SU' THEN
                    UPDATE gipi_winvoice
                       SET bond_tsi_amt = bond.tsi_amt,
                           bond_rate = bond.prem_rt
                     WHERE par_id = p_par_id;
                END IF;
            END LOOP;
            EXIT; --only one item should be allowed in bonds
         END LOOP;         
         /*ended edgar 10/15/2014*/       
   END insert_quote_to_par;                             
   
   FUNCTION check_parlist_dependency(p_insp_no             GIPI_INSP_DATA.insp_no%TYPE)
        RETURN VARCHAR2
   
   IS
      v_message         VARCHAR2(100) := 'Valid';
   BEGIN
           FOR A IN (SELECT A.insp_no
                 FROM gipi_insp_data A, gipi_parlist b
                WHERE A.insp_no = b.insp_no)
        LOOP
            IF p_insp_no = A.insp_no THEN
               v_message := 'Cannot delete record. Detail record already exists in GIPI_PARLIST.';
            END IF;
        END LOOP;
        RETURN v_message;
   END;
   
   FUNCTION get_par_assured_list(p_keyword giis_assured.assd_name%TYPE)
   
      RETURN assured_tab PIPELINED
      
   IS
      v_assured     assured_type;
      
   BEGIN
      
       
   
      FOR i IN (SELECT *
                  FROM (SELECT DISTINCT assd_no 
                          FROM gipi_parlist)
                         WHERE assd_no IN (SELECT assd_no
                                             FROM giis_assured
                                            WHERE assd_name 
                                             LIKE UPPER('%' || p_keyword || '%'))
                            OR TO_CHAR (assd_no) LIKE '%' || p_keyword || '%' )
                                         
      LOOP
           
         v_assured.assd_no       := i.assd_no;

         
         SELECT designation||' '||assd_name
           INTO v_assured.assd_name
           FROM giis_assured
          WHERE assd_no = i.assd_no;
           
         PIPE ROW (v_assured);
         
      END LOOP;
      
   END get_par_assured_list;            --moses04142011
   
   /*
   **  Created by        : Emman
   **  Date Created     : 09.29.2011
   **  Reference By     : (GIPIS031A - Package Endt Basic Information)
   **  Description     : This function returns the par_status
   **                    : on the given pack_par_id
   */
   FUNCTION get_pack_par_status (p_pack_par_id IN gipi_parlist.pack_par_id%TYPE)
      RETURN gipi_parlist.par_status%TYPE
   IS
      v_par_status   gipi_parlist.par_status%TYPE;
   BEGIN
      FOR i IN (SELECT par_status
                  FROM gipi_parlist
                 WHERE pack_par_id = p_pack_par_id)
      LOOP
         v_par_status := i.par_status;
         EXIT;
      END LOOP;

      RETURN v_par_status;
   END get_pack_par_status;
   
    /*    Date        Author            Description
    **    ==========    ===============    ============================       
    **    11.02.2011    mark jm            update the assd_no in gipi_parlist
    **                              Reference by : (GIPIS031A - Pack Endt Basic Information)
    */
    PROCEDURE update_assd_no (
        p_pack_par_id IN gipi_parlist.pack_par_id%TYPE,
        p_assd_no IN gipi_parlist.assd_no%TYPE)
    IS
    BEGIN
        UPDATE gipi_parlist
           SET assd_no = p_assd_no
         WHERE pack_par_id = p_pack_par_id;
    END update_assd_no;

   /*
   **  Created by        : D.Alcantara
   **  Date Created     : 02.06.2012
   **  Reference By     : (GIPIS031A - Package Endt Basic Information)
   **  Description     : Retrieves parlist to be used for create_winvoice1
   */
    FUNCTION get_parlist_by_pack (
        p_pack_par_id   GIPI_PARLIST.pack_par_id%TYPE
   ) RETURN gipi_parlist_tab PIPELINED IS
        p_par   gipi_parlist_type;
   BEGIN
        FOR i IN (
            SELECT par_id, line_cd, iss_cd
	                FROM gipi_parlist
	               WHERE pack_par_id = p_pack_par_id
	                 AND par_status NOT IN (98,99)
        ) LOOP
           p_par.par_id     := i.par_id;
           p_par.line_cd    := i.line_cd;
           p_par.iss_cd     := i.iss_cd;
           PIPE ROW(p_par);
        END LOOP;
   END get_parlist_by_pack;
/*
** Created by reymon 05022013
** To update insp_no
*/   
   PROCEDURE update_insp_no (
        p_par_id IN gipi_parlist.par_id%TYPE,
        p_insp_no IN gipi_parlist.insp_no%TYPE)
   IS
   BEGIN
       UPDATE gipi_parlist
          SET insp_no = p_insp_no
        WHERE par_id = p_par_id;
   END update_insp_no;
    PROCEDURE check_allow_cancellation (
       p_par_id   IN       gipi_wpolbas.par_id%TYPE,
       allowed    OUT      VARCHAR2
    )
    AS
    /*
    **  Created by        : Edgar Nobleza
    **  Date Created     : 02.16.2015
    **  Reference By     : (GIPIS058 - Endt PAR Listing)
    **  Description     : This procedure checks the parameter ALLOW_CANCEL_PAR_WITH_BNDR
    **                    to determine if a PAR with posted binders can be cancelled or not
    */
       v_allowcancel   VARCHAR2 (1)
                     := NVL (UPPER (giisp.v ('ALLOW_CANCEL_PAR_WITH_BNDR')), 'N');
    BEGIN
       IF v_allowcancel = 'Y'
       THEN
          allowed := 'Y';
       ELSE
          allowed := 'N';
       END IF;
    END check_allow_cancellation;   
END gipi_parlist_pkg;
/


