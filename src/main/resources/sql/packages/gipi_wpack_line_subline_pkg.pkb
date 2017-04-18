CREATE OR REPLACE PACKAGE BODY CPI.gipi_wpack_line_subline_pkg
AS
   FUNCTION get_gipi_wpack_line_subline (
      p_par_id   gipi_wpack_line_subline.par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab PIPELINED
   IS
      v_wpack   gipi_wpack_line_subline_type;
   BEGIN
      FOR i IN (SELECT a.par_id, a.pack_par_id, a.line_cd, c.line_name,
                       a.pack_line_cd, a.pack_subline_cd, d.subline_name,
                       a.item_tag, a.remarks
                  FROM gipi_wpack_line_subline a,
                       giis_line_subline_coverages b,
                       giis_line c,
                       giis_subline d
                 WHERE a.par_id = p_par_id
                   AND b.line_cd = a.line_cd
                   AND a.pack_line_cd = b.pack_line_cd
                   AND a.pack_subline_cd = b.pack_subline_cd
                   AND c.line_cd = b.pack_line_cd
                   AND d.line_cd = b.pack_line_cd
                   AND d.subline_cd = b.pack_subline_cd)
      LOOP
         v_wpack.par_id := i.par_id;
         v_wpack.pack_par_id := i.pack_par_id;
         v_wpack.line_cd := i.line_cd;
         v_wpack.line_name := i.line_name;
         v_wpack.pack_line_cd := i.pack_line_cd;
         v_wpack.pack_subline_cd := i.pack_subline_cd;
         v_wpack.subline_name := i.subline_name;
         v_wpack.item_tag := i.item_tag;
         v_wpack.remarks := i.remarks;
         v_wpack.menu_line_cd :=
                              giis_line_pkg.get_menu_line_cd (i.pack_line_cd);
         PIPE ROW (v_wpack);
      END LOOP;

      RETURN;
   END get_gipi_wpack_line_subline;

   --for GIRIS005A
   FUNCTION get_gipi_wpack_line_subline (
      p_par_id    gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd   gipi_wpack_line_subline.line_cd%TYPE
   )
      RETURN gipi_wpack_line_subline_tab PIPELINED
   IS
      v_wpack   gipi_wpack_line_subline_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.pack_line_cd, b.line_name,
                         a.pack_subline_cd, c.subline_name, a.pack_par_id,
                         a.item_tag
                    FROM gipi_wpack_line_subline a,
                         giis_line b,
                         giis_subline c
                   WHERE a.par_id = p_par_id
                     AND a.line_cd = p_line_cd
                     AND b.line_cd = a.pack_line_cd
                     AND c.subline_cd = a.pack_subline_cd
                ORDER BY a.line_cd, a.pack_line_cd, a.pack_subline_cd)
      LOOP
         v_wpack.line_cd := i.line_cd;
         v_wpack.line_name := i.line_name;
         v_wpack.pack_line_cd := i.pack_line_cd;
         v_wpack.pack_subline_cd := i.pack_subline_cd;
         v_wpack.subline_name := i.subline_name;
         v_wpack.item_tag := i.item_tag;
         v_wpack.pack_par_id := i.pack_par_id;
         v_wpack.menu_line_cd :=
                              giis_line_pkg.get_menu_line_cd (i.pack_line_cd);
         PIPE ROW (v_wpack);
      END LOOP;

      RETURN;
   END get_gipi_wpack_line_subline;

/*
**  Created by        : Andrew
**  Date Created     : 03.11.2011
**  Reference By     : (GIPIS002A - Endt Item Information - Casualty)
**  Description     : Update the item_tag of the given par_id
*/
   FUNCTION get_gipi_wpack_line_subline3 (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab PIPELINED
   IS
      v_wpack   gipi_wpack_line_subline_type;
   BEGIN
      FOR i IN (SELECT a.par_id, a.line_cd, a.pack_line_cd,
                       a.pack_subline_cd, a.pack_par_id, a.item_tag,
                       a.remarks, b.op_flag
                  FROM gipi_wpack_line_subline a, giis_subline b
                 WHERE a.pack_par_id = p_pack_par_id
                   AND a.pack_line_cd = b.line_cd
                   AND a.pack_subline_cd = b.subline_cd)
      LOOP
         v_wpack.par_id := i.par_id;
         v_wpack.line_cd := i.line_cd;
         v_wpack.pack_line_cd := i.pack_line_cd;
         v_wpack.pack_subline_cd := i.pack_subline_cd;
         v_wpack.item_tag := i.item_tag;
         v_wpack.pack_par_id := i.pack_par_id;
         v_wpack.remarks := i.remarks;
         v_wpack.op_flag := i.op_flag;
         v_wpack.menu_line_cd :=
                              giis_line_pkg.get_menu_line_cd (i.pack_line_cd);
         PIPE ROW (v_wpack);
      END LOOP;

      RETURN;
   END get_gipi_wpack_line_subline3;

/*
**  Created by        : irwin
**  Date Created     : 03.11.2011
*/
   FUNCTION get_line_subline (p_line_cd gipi_wpack_line_subline.line_cd%TYPE)
      RETURN gipi_wpack_coverage_tab PIPELINED
   IS
      v_line_subline   gipi_wpack_coverage_type;
   BEGIN
      FOR a IN (SELECT   a.pack_line_cd pack_line_cd, a.line_cd line_cd,
                         b.line_name line_name,
                         a.pack_subline_cd pack_subline_cd,
                         c.subline_name pack_subline_name
                    FROM giis_line_subline_coverages a,
                         giis_line b,
                         giis_subline c
                   WHERE b.line_cd = a.pack_line_cd
                     AND c.line_cd = a.pack_line_cd
                     AND c.subline_cd = a.pack_subline_cd
                     AND a.line_cd = p_line_cd
                ORDER BY a.pack_line_cd, a.pack_subline_cd)
      LOOP
         v_line_subline.pack_line_cd := a.pack_line_cd;
         v_line_subline.pack_line_name := a.line_name;
         v_line_subline.pack_subline_cd := a.pack_subline_cd;
         v_line_subline.pack_subline_name := a.pack_subline_name;
         PIPE ROW (v_line_subline);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_wpack_line_subline_list (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab1 PIPELINED
   IS
      v_line_subline   gipi_wpack_line_subline_type1;
      v_line_name      giis_line.line_name%TYPE;
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT a.*
                  FROM gipi_wpack_line_subline a
                 WHERE NOT EXISTS (
                              SELECT 1
                                FROM gipi_parlist z
                               WHERE z.par_id = a.par_id
                                     AND z.par_status = 99)
                   AND pack_par_id = p_pack_par_id)
      LOOP
         BEGIN
            SELECT DISTINCT line_name
                       INTO v_line_subline.pack_line_name
                       FROM giis_line
                      WHERE line_cd = a.pack_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_line_subline.pack_line_name := NULL;
         END;

         BEGIN
            SELECT DISTINCT subline_name
                       INTO v_line_subline.pack_subline_name
                       FROM giis_subline
                      WHERE subline_cd = a.pack_subline_cd
                        AND line_cd = a.pack_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_line_subline.pack_subline_name := NULL;
         END;

         v_line_subline.pack_par_id := a.pack_par_id;
         v_line_subline.par_id := a.par_id;
         v_line_subline.pack_line_cd := a.pack_line_cd;
         v_line_subline.pack_subline_cd := a.pack_subline_cd;
         v_line_subline.item_tag := a.item_tag;
         v_line_subline.remarks := a.remarks;
         PIPE ROW (v_line_subline);
      END LOOP;

      RETURN;
   END;

         /*
   **  Created by        : irwin tabisora
   **  Date Created     : 03.17.2011
   */
   FUNCTION get_wpack_dsp_tag (
      p_par_id            gipi_wpack_line_subline.par_id%TYPE,
      p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_line_cd           gipi_wpack_line_subline.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_dsp_tag   VARCHAR2 (1);
      v_item      NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO v_item
           FROM gipi_witem
          WHERE par_id = p_par_id AND pack_line_cd = p_pack_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_item := NULL;
      END;

      BEGIN
         SELECT required_flag
           INTO v_dsp_tag
           FROM giis_line_subline_coverages a990
          WHERE a990.pack_line_cd = p_pack_line_cd
            AND a990.pack_subline_cd = p_pack_subline_cd
            AND a990.line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_dsp_tag := NULL;
      END;

      RETURN v_dsp_tag;
   END;

-- end of functions
   PROCEDURE set_gipi_wpack_line_subline (
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_pack_par_id       IN   gipi_wpack_line_subline.pack_par_id%TYPE,
      p_line_cd           IN   gipi_wpack_line_subline.line_cd%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_item_tag          IN   gipi_wpack_line_subline.item_tag%TYPE,
      p_remarks           IN   gipi_wpack_line_subline.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_wpack_line_subline
         USING DUAL
         ON (    par_id = p_par_id
             AND line_cd = p_line_cd
             AND pack_line_cd = p_pack_line_cd
             AND pack_subline_cd = p_pack_subline_cd)
         WHEN NOT MATCHED THEN
            INSERT (par_id, pack_par_id, line_cd, pack_line_cd,
                    pack_subline_cd, item_tag, remarks)
            VALUES (p_par_id, p_pack_par_id, p_line_cd, p_pack_line_cd,
                    p_pack_subline_cd, p_item_tag, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET pack_par_id = p_pack_par_id, item_tag = p_item_tag,
                   remarks = p_remarks
            ;
   --COMMIT; removed commit irwin 6.5.2012
   END set_gipi_wpack_line_subline;

   /**
        Created by Irwin Tabisora
        Date: March 22, 2011
        Descriptions: Delete of gipis093. Includes multiple procedures
   */
   PROCEDURE del_gipi_wpack_line_subline (
      p_par_id            gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd           gipi_wpack_line_subline.line_cd%TYPE,
      p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_wpack_line_subline
            WHERE par_id = p_par_id
              AND line_cd = p_line_cd
              AND pack_line_cd = p_pack_line_cd
              AND pack_subline_cd = p_pack_subline_cd;

      COMMIT;
   END del_gipi_wpack_line_subline;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-13-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  :
   */
   PROCEDURE del_gipi_wpack_line_subline (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_wpack_line_subline
            WHERE pack_par_id = p_pack_par_id;
   END del_gipi_wpack_line_subline;

   PROCEDURE check_if_line_subline_exist (
      p_pack_par_id   IN       gipi_wpack_line_subline.pack_par_id%TYPE,
      p_line_cd       IN       gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_message       IN OUT   VARCHAR2
   )
   IS
      v_col_separator   VARCHAR2 (1) := '@';
      v_row_separator   VARCHAR2 (2) := '##';
      v_count           NUMBER;
   BEGIN
      --p_message := '0' || v_col_separator || 'SUCCESS';
      p_message := 'Y';

      SELECT COUNT (*)
        INTO v_count
        FROM gipi_wpack_line_subline
       WHERE pack_par_id = p_pack_par_id AND line_cd = p_line_cd;

      IF v_count = 0 AND p_line_cd IS NOT NULL
      THEN
         p_message := 'N';
      --'At least 1 record must be entered in the Package Line/Subline.';
      END IF;
   END check_if_line_subline_exist;

/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_wpack_line_subline (
      p_par_id    gipi_witem.par_id%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   )
   IS
      v_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE;
      v_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE;
      v_line_cd           gipi_wpack_line_subline.line_cd%TYPE;
      v_remarks           gipi_wpack_line_subline.remarks%TYPE;
      v_item_tag          gipi_wpack_line_subline.item_tag%TYPE;
      var                 gipi_parlist.par_status%TYPE;
   BEGIN
      FOR pack IN (SELECT 'A'
                     FROM giis_line
                    WHERE line_cd = p_line_cd AND pack_pol_flag = 'Y')
      LOOP
         BEGIN
            SELECT DISTINCT pack_line_cd, pack_subline_cd
                       INTO v_pack_line_cd, v_pack_subline_cd
                       FROM gipi_witem
                      WHERE par_id = p_par_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN;
               v_remarks := NULL;

               SELECT par_status
                 INTO var
                 FROM gipi_pack_parlist
                WHERE pack_par_id = p_par_id;

               IF var NOT IN (1, 2, 3)
               THEN
                  v_item_tag := 'Y';
               ELSE
                  v_item_tag := 'N';
               END IF;

               INSERT INTO gipi_wpack_line_subline
                           (par_id, pack_line_cd, pack_subline_cd,
                            line_cd, remarks, item_tag
                           )
                    VALUES (p_par_id, v_pack_line_cd, v_pack_subline_cd,
                            v_line_cd, v_remarks, v_item_tag
                           );
         END;
      END LOOP;
   END create_wpack_line_subline;

-- end of whofeih
/***************************************************************************/

   /**
   *     Created by: Emman
   *  Used on: Endt Item Info
   */
   PROCEDURE update_gipi_wpack_line_subline (
      p_par_id            gipi_wpolbas.par_id%TYPE,
      p_pack_line_cd      gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd   gipi_witem.pack_subline_cd%TYPE
   )
   IS
      p_count_a         NUMBER                            := 0;
      p_count_b         NUMBER                            := 0;
      v_pack_pol_flag   gipi_wpolbas.pack_pol_flag%TYPE;
      v_line_cd         gipi_wpolbas.line_cd%TYPE;

      CURSOR a
      IS
         SELECT item_no
           FROM gipi_witem
          WHERE par_id = p_par_id
            AND pack_line_cd = p_pack_line_cd
            AND pack_subline_cd = p_pack_subline_cd;
   BEGIN
      FOR temp IN (SELECT pack_pol_flag, line_cd
                     FROM gipi_wpolbas
                    WHERE par_id = p_par_id)
      LOOP
         v_pack_pol_flag := temp.pack_pol_flag;
         v_line_cd := temp.line_cd;
         EXIT;
      END LOOP;

      IF v_pack_pol_flag = 'Y'
      THEN
         FOR a1 IN a
         LOOP
            p_count_a := p_count_a + 1;

            IF v_line_cd = 'MC'
            THEN
               FOR b1 IN (SELECT '1'
                            FROM gipi_wvehicle
                           WHERE par_id = p_par_id AND item_no = a1.item_no)
               LOOP
                  p_count_b := p_count_b + 1;
               END LOOP;
            ELSIF v_line_cd = 'FI'
            THEN
               FOR b1 IN (SELECT '1'
                            FROM gipi_wfireitm
                           WHERE par_id = p_par_id AND item_no = a1.item_no)
               LOOP
                  p_count_b := p_count_b + 1;
               END LOOP;
            END IF;
         END LOOP;

         IF p_count_a = p_count_b
         THEN
            UPDATE gipi_wpack_line_subline
               SET item_tag = 'Y'
             WHERE par_id = p_par_id
               AND pack_line_cd = p_pack_line_cd
               AND pack_subline_cd = p_pack_subline_cd;
         ELSE
            UPDATE gipi_wpack_line_subline
               SET item_tag = 'N'
             WHERE par_id = p_par_id
               AND pack_line_cd = p_pack_line_cd
               AND pack_subline_cd = p_pack_subline_cd;
         END IF;
      END IF;
   END;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 10.07.2010
   **  Reference By     : (GIPI061 - Endt Item Information - Casualty)
   **  Description     : Update the item_tag of the given par_id
   */
   PROCEDURE upd_gipi_wpack_line_subline (
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_wpack_line_subline
         SET item_tag = 'Y'
       WHERE par_id = p_par_id
         AND pack_line_cd = p_pack_line_cd
         AND pack_subline_cd = p_pack_subline_cd;
   END upd_gipi_wpack_line_subline;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  11-09-2010
   **  Reference By : (GIPIS002 - Basic Information)
   **  Description  :  POPULATE_PACKAGE program unit
   */
   PROCEDURE populate_package (
      p_par_id    gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd   gipi_wpack_line_subline.line_cd%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT a990.pack_line_cd, a990.pack_subline_cd, a990.line_cd
           FROM giis_line_subline_coverages a990
          WHERE NOT EXISTS (
                   SELECT 1
                     FROM gipi_wpack_line_subline b955
                    WHERE b955.line_cd = a990.line_cd
                      AND b955.pack_subline_cd = a990.pack_subline_cd
                      AND b955.pack_line_cd = a990.pack_line_cd
                      AND b955.par_id = p_par_id)
            AND a990.required_flag = 'Y'
            AND a990.line_cd = p_line_cd;
   BEGIN
      FOR c_rec IN c
      LOOP
         INSERT INTO gipi_wpack_line_subline
                     (par_id, pack_line_cd, pack_subline_cd,
                      line_cd, item_tag
                     )
              VALUES (p_par_id, c_rec.pack_line_cd, c_rec.pack_subline_cd,
                      c_rec.line_cd, 'N'
                     );
      END LOOP;
   END;

/*   Created By Irwin Tabisora
        B955 POST INSERT
   */
   PROCEDURE gipis093_post_insert (
      p_iss_cd         IN   VARCHAR2,
      p_pack_par_id    IN   gipi_wpack_line_subline.pack_par_id%TYPE,
      p_pack_line_cd   IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_par_id         IN   gipi_wpack_line_subline.par_id%TYPE
   )
   IS
      v_accept_no   giri_winpolbas.accept_no%TYPE;
   BEGIN
      -- gipi_pack_parlist
      FOR c1 IN (SELECT pack_par_id, line_cd, iss_cd, par_yy, quote_seq_no,
                        par_type, assign_sw, par_status, assd_no, quote_id,
                        underwriter, remarks
                   FROM gipi_pack_parlist
                  WHERE pack_par_id = p_pack_par_id)
      LOOP
         INSERT INTO gipi_parlist
                     (pack_par_id, par_id, line_cd, iss_cd,
                      par_yy, quote_seq_no, par_type, assign_sw,
                      par_status, assd_no, quote_id,
                      underwriter, remarks
                     )
              VALUES (c1.pack_par_id, p_par_id, p_pack_line_cd, c1.iss_cd,
                      c1.par_yy, c1.quote_seq_no, c1.par_type, c1.assign_sw,
                      c1.par_status, c1.assd_no, c1.quote_id,
                      c1.underwriter, c1.remarks
                     );

         INSERT INTO gipi_parhist
                     (par_id, user_id, parstat_date, entry_source, parstat_cd
                     )
              VALUES (p_par_id, c1.underwriter, SYSDATE, 'DB', '1'
                     );
      END LOOP;

      -- GIRI_WINPOLBAS
      IF p_iss_cd = giisp.v ('ISS_CD_RI')
      THEN
         BEGIN
            SELECT winpolbas_accept_no_s.NEXTVAL
              INTO v_accept_no
              FROM DUAL;
         END;

         INSERT INTO giri_winpolbas
                     (accept_no, par_id, ri_cd, accept_date, ri_policy_no,
                      ri_endt_no, ri_binder_no, writer_cd, offer_date,
                      accept_by, orig_tsi_amt, orig_prem_amt, remarks,
                      ref_accept_no, pack_par_id, pack_accept_no)
            SELECT v_accept_no, p_par_id, ri_cd, accept_date, ri_policy_no,
                   ri_endt_no, ri_binder_no, writer_cd, offer_date, accept_by,
                   orig_tsi_amt, orig_prem_amt, remarks, ref_accept_no,
                   pack_par_id, pack_accept_no
              FROM giri_pack_winpolbas
             WHERE pack_par_id = p_pack_par_id;
      END IF;

      INSERT INTO gipi_wpolbas
                  (par_id, line_cd, iss_cd, foreign_acc_sw, invoice_sw,
                   quotation_printed_sw, covernote_printed_sw,
                   auto_renew_flag, prov_prem_tag, same_polno_sw,
                   pack_pol_flag, reg_policy_sw, co_insurance_sw,
                   manual_renew_no, subline_cd, issue_yy, pol_seq_no,
                   endt_iss_cd, endt_yy, endt_seq_no, renew_no, endt_type,
                   incept_date, expiry_date, expiry_tag, eff_date, issue_date,
                   pol_flag, assd_no, designation, address1, address2,
                   address3, mortg_name, tsi_amt, prem_amt, ann_tsi_amt,
                   ann_prem_amt, pool_pol_no, user_id, orig_policy_id,
                   endt_expiry_date, no_of_items, subline_type_cd,
                   prorate_flag, short_rt_percent, type_cd, acct_of_cd,
                   prov_prem_pct, discount_sw, prem_warr_tag, ref_pol_no,
                   ref_open_pol_no, incept_tag, fleet_print_tag, comp_sw,
                   booking_mth, booking_year, with_tariff_sw, endt_expiry_tag,
                   cover_nt_printed_date, cover_nt_printed_cnt, place_cd,
                   back_stat, qd_flag, validate_tag, industry_cd, region_cd,
                   acct_of_cd_sw, surcharge_sw, cred_branch, old_assd_no,
                   cancel_date, label_tag, old_address1, old_address2,
                   old_address3, risk_tag, pack_par_id)
         SELECT c.par_id, a.pack_line_cd, b.iss_cd, b.foreign_acc_sw,
                b.invoice_sw, b.quotation_printed_sw, b.covernote_printed_sw,
                b.auto_renew_flag, b.prov_prem_tag, b.same_polno_sw,
                b.pack_pol_flag, b.reg_policy_sw, b.co_insurance_sw,
                b.manual_renew_no, a.pack_subline_cd, b.issue_yy,
                b.pol_seq_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no,
                b.renew_no, b.endt_type, b.incept_date, b.expiry_date,
                b.expiry_tag, b.eff_date, b.issue_date, b.pol_flag, b.assd_no,
                b.designation, b.address1, b.address2, b.address3,
                b.mortg_name, b.tsi_amt, b.prem_amt, b.ann_tsi_amt,
                b.ann_prem_amt, b.pool_pol_no, b.user_id, b.orig_policy_id,
                b.endt_expiry_date, b.no_of_items, b.subline_type_cd,
                b.prorate_flag, b.short_rt_percent, b.type_cd, b.acct_of_cd,
                b.prov_prem_pct, b.discount_sw, b.prem_warr_tag, b.ref_pol_no,
                b.ref_open_pol_no, b.incept_tag, b.fleet_print_tag, b.comp_sw,
                b.booking_mth, b.booking_year, b.with_tariff_sw,
                b.endt_expiry_tag, b.cover_nt_printed_date,
                b.cover_nt_printed_cnt, b.place_cd, b.back_stat, b.qd_flag,
                b.validate_tag, b.industry_cd, b.region_cd, b.acct_of_cd_sw,
                b.surcharge_sw, b.cred_branch, b.old_assd_no, b.cancel_date,
                b.label_tag, b.old_address1, b.old_address2, b.old_address3,
                b.risk_tag, b.pack_par_id
           FROM gipi_parlist c, gipi_wpack_line_subline a,
                gipi_pack_wpolbas b
          WHERE 1 = 1
            AND c.par_id = a.par_id
            --  AND c.par_id = A.par_id
            AND c.line_cd = a.pack_line_cd
            AND a.pack_par_id = b.pack_par_id
            AND a.line_cd = b.line_cd
            AND a.par_id = p_par_id
            AND b.pack_par_id = p_pack_par_id;

      --to insert records to gipi_wpolgenin
      INSERT INTO gipi_wpolgenin
                  (par_id, gen_info01, gen_info02, gen_info03, gen_info04,
                   gen_info05, gen_info06, gen_info07, gen_info08, gen_info09,
                   gen_info10, gen_info11, gen_info12, gen_info13, gen_info14,
                   gen_info15, gen_info16, gen_info17, genin_info_cd,
                   initial_info01, initial_info02, initial_info03,
                   initial_info04, initial_info05, initial_info06,
                   initial_info07, initial_info08, initial_info09,
                   initial_info10, initial_info11, initial_info12,
                   initial_info13, initial_info14, initial_info15,
                   initial_info16, initial_info17, agreed_tag)
         SELECT c.par_id, b.gen_info01, b.gen_info02, b.gen_info03,
                b.gen_info04, b.gen_info05, b.gen_info06, b.gen_info07,
                b.gen_info08, b.gen_info09, b.gen_info10, b.gen_info11,
                b.gen_info12, b.gen_info13, b.gen_info14, b.gen_info15,
                b.gen_info16, b.gen_info17, b.genin_info_cd, b.initial_info01,
                b.initial_info02, b.initial_info03, b.initial_info04,
                b.initial_info05, b.initial_info06, b.initial_info07,
                b.initial_info08, b.initial_info09, b.initial_info10,
                b.initial_info11, b.initial_info12, b.initial_info13,
                b.initial_info14, b.initial_info15, b.initial_info16,
                b.initial_info17, b.agreed_tag
           FROM gipi_parlist c, gipi_pack_wpolgenin b
          WHERE 1 = 1
            AND c.pack_par_id = b.pack_par_id
            AND c.par_status NOT IN (98, 99)
            AND c.par_id = p_par_id
            AND b.pack_par_id = p_pack_par_id;
   END;

/**
* Created by: Andrew Robes
* Date: 09.15.2011
* Referenced by: (GIPIS031A - package endt basic info)
* Description : Procedure to insert into gipi_wpolbas after saving package endt basic info
*/
   PROCEDURE post_insert_pack_line_subline (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
   IS
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
   BEGIN
      FOR i IN (SELECT c.par_id, a.pack_line_cd, b.iss_cd, b.foreign_acc_sw,
                       b.invoice_sw, b.quotation_printed_sw,
                       b.covernote_printed_sw, b.auto_renew_flag,
                       b.prov_prem_tag, b.same_polno_sw, b.pack_pol_flag,
                       b.reg_policy_sw, b.co_insurance_sw, b.manual_renew_no,
                       a.pack_subline_cd, b.issue_yy, b.pol_seq_no,
                       b.endt_iss_cd, b.endt_yy, b.endt_seq_no, b.renew_no,
                       b.endt_type, b.incept_date, b.expiry_date,
                       b.expiry_tag, b.eff_date, b.issue_date, b.pol_flag,
                       b.assd_no, b.designation, b.address1, b.address2,
                       b.address3, b.mortg_name, b.tsi_amt, b.prem_amt,
                       b.ann_tsi_amt, b.ann_prem_amt, b.pool_pol_no,
                       b.user_id, b.orig_policy_id, b.endt_expiry_date,
                       b.no_of_items, b.subline_type_cd, b.prorate_flag,
                       b.short_rt_percent, b.type_cd, b.acct_of_cd,
                       b.prov_prem_pct, b.discount_sw, b.prem_warr_tag,
                       b.ref_pol_no, b.ref_open_pol_no, b.incept_tag,
                       b.fleet_print_tag, b.comp_sw, b.booking_mth,
                       b.booking_year, b.with_tariff_sw, b.endt_expiry_tag,
                       b.cover_nt_printed_date, b.cover_nt_printed_cnt,
                       b.place_cd, b.back_stat, b.qd_flag, b.validate_tag,
                       b.industry_cd, b.region_cd, b.acct_of_cd_sw,
                       b.surcharge_sw, b.cred_branch, b.old_assd_no,
                       b.cancel_date, b.label_tag, b.old_address1,
                       b.old_address2, b.old_address3, b.risk_tag,
                       b.pack_par_id, b.line_cd, b.subline_cd
                  FROM gipi_parlist c,
                       gipi_wpack_line_subline a,
                       gipi_pack_wpolbas b
                 WHERE 1 = 1
                   AND c.par_id = a.par_id
                   --  AND c.par_id = A.par_id
                   AND c.line_cd = a.pack_line_cd
                   AND a.pack_par_id = b.pack_par_id
                   AND a.line_cd = b.line_cd
                   --AND a.par_id = p_par_id
                   AND b.pack_par_id = p_pack_par_id)
      LOOP
         /**The following lines added by: Nica 10.24.2011 to retrieve details of endorse policy*/
         v_line_cd := i.pack_line_cd;
         v_subline_cd := i.pack_subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := NULL;
         v_renew_no := i.renew_no;

         FOR c2 IN (SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
                           b.pol_seq_no, b.renew_no
                      FROM gipi_polbasic b, gipi_pack_polbasic a
                     WHERE b.pack_policy_id = a.pack_policy_id
                       AND a.line_cd = i.line_cd
                       AND a.subline_cd = i.subline_cd
                       AND a.iss_cd = i.iss_cd
                       AND a.issue_yy = i.issue_yy
                       AND a.pol_seq_no = i.pol_seq_no
                       AND a.renew_no = i.renew_no
                       AND a.endt_seq_no = 0
                       AND a.pol_flag NOT IN ('5', '4')
                       AND a.dist_flag NOT IN ('5', 'X')
                       AND b.line_cd = i.pack_line_cd
                       AND b.subline_cd = i.pack_subline_cd)
         LOOP
            v_line_cd := c2.line_cd;
            v_subline_cd := c2.subline_cd;
            v_iss_cd := c2.iss_cd;
            v_issue_yy := c2.issue_yy;
            v_pol_seq_no := c2.pol_seq_no;
            v_renew_no := c2.renew_no;
         END LOOP;

         /** end **/
         MERGE INTO gipi_wpolbas
            USING DUAL
            ON (par_id = i.par_id)
            WHEN NOT MATCHED THEN
               INSERT (par_id, line_cd, iss_cd, foreign_acc_sw, invoice_sw,
                       quotation_printed_sw, covernote_printed_sw,
                       auto_renew_flag, prov_prem_tag, same_polno_sw,
                       pack_pol_flag, reg_policy_sw, co_insurance_sw,
                       manual_renew_no, subline_cd, issue_yy, pol_seq_no,
                       endt_iss_cd, endt_yy, endt_seq_no, renew_no, endt_type,
                       incept_date, expiry_date, expiry_tag, eff_date,
                       issue_date, pol_flag, assd_no, designation, address1,
                       address2, address3, mortg_name, tsi_amt, prem_amt,
                       ann_tsi_amt, ann_prem_amt, pool_pol_no, user_id,
                       orig_policy_id, endt_expiry_date, no_of_items,
                       subline_type_cd, prorate_flag, short_rt_percent,
                       type_cd, acct_of_cd, prov_prem_pct, discount_sw,
                       prem_warr_tag, ref_pol_no, ref_open_pol_no, incept_tag,
                       fleet_print_tag, comp_sw, booking_mth, booking_year,
                       with_tariff_sw, endt_expiry_tag, cover_nt_printed_date,
                       cover_nt_printed_cnt, place_cd, back_stat, qd_flag,
                       validate_tag, industry_cd, region_cd, acct_of_cd_sw,
                       surcharge_sw, cred_branch, old_assd_no, cancel_date,
                       label_tag, old_address1, old_address2, old_address3,
                       risk_tag, pack_par_id)
               VALUES (i.par_id, v_line_cd, v_iss_cd, i.foreign_acc_sw,
                       i.invoice_sw, i.quotation_printed_sw,
                       i.covernote_printed_sw, i.auto_renew_flag,
                       i.prov_prem_tag, i.same_polno_sw, i.pack_pol_flag,
                       i.reg_policy_sw, i.co_insurance_sw, i.manual_renew_no,
                       v_subline_cd, v_issue_yy, v_pol_seq_no, i.endt_iss_cd,
                       i.endt_yy, i.endt_seq_no, v_renew_no, i.endt_type,
                       i.incept_date, i.expiry_date, i.expiry_tag, i.eff_date,
                       i.issue_date, i.pol_flag, i.assd_no, i.designation,
                       i.address1, i.address2, i.address3, i.mortg_name,
                       i.tsi_amt, i.prem_amt, i.ann_tsi_amt, i.ann_prem_amt,
                       i.pool_pol_no, i.user_id, i.orig_policy_id,
                       i.endt_expiry_date, i.no_of_items, i.subline_type_cd,
                       i.prorate_flag, i.short_rt_percent, i.type_cd,
                       i.acct_of_cd, i.prov_prem_pct, i.discount_sw,
                       i.prem_warr_tag, i.ref_pol_no, i.ref_open_pol_no,
                       i.incept_tag, i.fleet_print_tag, i.comp_sw,
                       i.booking_mth, i.booking_year, i.with_tariff_sw,
                       i.endt_expiry_tag, i.cover_nt_printed_date,
                       i.cover_nt_printed_cnt, i.place_cd, i.back_stat,
                       i.qd_flag, i.validate_tag, i.industry_cd, i.region_cd,
                       i.acct_of_cd_sw, i.surcharge_sw, i.cred_branch,
                       i.old_assd_no, i.cancel_date, i.label_tag,
                       i.old_address1, i.old_address2, i.old_address3,
                       i.risk_tag, i.pack_par_id)
            WHEN MATCHED THEN
               UPDATE
                  SET line_cd = v_line_cd, iss_cd = v_iss_cd,
                      foreign_acc_sw = i.foreign_acc_sw,
                      invoice_sw = i.invoice_sw,
                      quotation_printed_sw = i.quotation_printed_sw,
                      covernote_printed_sw = i.covernote_printed_sw,
                      auto_renew_flag = i.auto_renew_flag,
                      prov_prem_tag = i.prov_prem_tag,
                      same_polno_sw = i.same_polno_sw,
                      pack_pol_flag = i.pack_pol_flag,
                      reg_policy_sw = i.reg_policy_sw,
                      co_insurance_sw = i.co_insurance_sw,
                      manual_renew_no = i.manual_renew_no,
                      subline_cd = v_subline_cd, issue_yy = i.issue_yy,
                      pol_seq_no = v_pol_seq_no, endt_iss_cd = i.endt_iss_cd,
                      endt_yy = i.endt_yy, endt_seq_no = i.endt_seq_no,
                      renew_no = v_renew_no, endt_type = i.endt_type,
                      incept_date = i.incept_date,
                      expiry_date = i.expiry_date, expiry_tag = i.expiry_tag,
                      eff_date = i.eff_date, issue_date = i.issue_date,
                      pol_flag = i.pol_flag, assd_no = i.assd_no,
                      designation = i.designation, address1 = i.address1,
                      address2 = i.address2, address3 = i.address3,
                      mortg_name = i.mortg_name,                                                /*tsi_amt = i.tsi_amt, --belle 09252012 commented to insert correct amts in gipi_wpolbas
                                                 prem_amt = i.prem_amt,                         ann_tsi_amt = i.ann_tsi_amt,
                                                 ann_prem_amt = i.ann_prem_amt,*/ pool_pol_no =
                                                                 i.pool_pol_no,
                      user_id = i.user_id, orig_policy_id = i.orig_policy_id,
                      endt_expiry_date = i.endt_expiry_date,
                      no_of_items = i.no_of_items,
                      subline_type_cd = i.subline_type_cd,
                      prorate_flag = i.prorate_flag,
                      short_rt_percent = i.short_rt_percent,
                      type_cd = i.type_cd, acct_of_cd = i.acct_of_cd,
                      prov_prem_pct = i.prov_prem_pct,
                      discount_sw = i.discount_sw,
                      prem_warr_tag = i.prem_warr_tag,
                      ref_pol_no = i.ref_pol_no,
                      ref_open_pol_no = i.ref_open_pol_no,
                      incept_tag = i.incept_tag,
                      fleet_print_tag = i.fleet_print_tag,
                      comp_sw = i.comp_sw, booking_mth = i.booking_mth,
                      booking_year = i.booking_year,
                      with_tariff_sw = i.with_tariff_sw,
                      endt_expiry_tag = i.endt_expiry_tag,
                      cover_nt_printed_date = i.cover_nt_printed_date,
                      cover_nt_printed_cnt = i.cover_nt_printed_cnt,
                      place_cd = i.place_cd, back_stat = i.back_stat,
                      qd_flag = i.qd_flag, validate_tag = i.validate_tag,
                      industry_cd = i.industry_cd, region_cd = i.region_cd,
                      acct_of_cd_sw = i.acct_of_cd_sw,
                      surcharge_sw = i.surcharge_sw,
                      cred_branch = i.cred_branch,
                      old_assd_no = i.old_assd_no,
                      cancel_date = i.cancel_date, label_tag = i.label_tag,
                      old_address1 = i.old_address1,
                      old_address2 = i.old_address2,
                      old_address3 = i.old_address3, risk_tag = i.risk_tag,
                      pack_par_id = i.pack_par_id
               ;
         post_ins_wpolgenin_gipis031a (p_pack_par_id, i.par_id);
         post_ins_wendttext_gipis031a (p_pack_par_id, i.par_id);
      END LOOP;
   END post_insert_pack_line_subline;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 03.24.2011
   **  Reference By     : (GIPIS095 - Package Policy Items)
   **  Description     : Update the item_tag of gipi_wpack_line_subline based on given parameters
   */
   PROCEDURE update_item_tag (
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_item_tag          IN   gipi_wpack_line_subline.item_tag%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_wpack_line_subline
         SET item_tag = p_item_tag
       WHERE par_id = p_par_id
         AND pack_line_cd = p_pack_line_cd
         AND pack_subline_cd = p_pack_subline_cd;
   END update_item_tag;

   /*
   **  Created by: Robert 07.25.2011
   **  Used on: Endt Package Line  Coverage
   */
   FUNCTION get_endt_line_subline (
      p_line_cd      gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     gipi_wpolbas.renew_no%TYPE
   )
      RETURN gipi_wpack_coverage_tab PIPELINED
   IS
      v_line_subline   gipi_wpack_coverage_type;
   BEGIN
      FOR a IN
         (SELECT DISTINCT a.pack_line_cd, b.line_name, a.pack_subline_cd,
                          c.subline_name
                     FROM gipi_pack_line_subline a,
                          giis_line b,
                          giis_subline c
                    WHERE a.pack_line_cd = b.line_cd
                      AND b.line_cd = c.line_cd
                      AND a.pack_subline_cd = c.subline_cd
                      AND a.policy_id IN (
                             SELECT w.policy_id
                               FROM gipi_polbasic w,
                                    gipi_pack_polbasic x
                --, GIPI_PACK_WPOLBAS y  -- comment out by andrew - 09.07.2011
                              WHERE w.pack_policy_id = x.pack_policy_id
--                                          AND x.line_cd=y.line_cd
--                                             AND x.subline_cd=y.subline_cd
--                                             AND x.iss_cd=y.iss_cd
--                                             AND x.issue_yy=y.issue_yy
--                                          AND x.pol_seq_no=y.pol_seq_no
--                                          AND x.RENEW_NO=y.renew_no
                                AND x.line_cd = p_line_cd
                                AND x.subline_cd = p_subline_cd
                                AND x.iss_cd = p_iss_cd
                                AND x.issue_yy = p_issue_yy
                                AND x.pol_seq_no = p_pol_seq_no
                                AND x.renew_no = p_renew_no)
                 ORDER BY a.pack_line_cd)
      LOOP
         v_line_subline.pack_line_cd := a.pack_line_cd;
         v_line_subline.pack_line_name := a.line_name;
         v_line_subline.pack_subline_cd := a.pack_subline_cd;
         v_line_subline.pack_subline_name := a.subline_name;
         PIPE ROW (v_line_subline);
      END LOOP;

      RETURN;
   END;

   /**
   *  Created by : Andrew Robes
   *  Date: 09.08.2011
   *  Descriptions: Procedure to delete gipi_wpack_line_subline records by pack_par_id
   */
   PROCEDURE del_wpack_line_subline_by_id (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_parlist
         SET par_status = 99
       WHERE pack_par_id = p_pack_par_id;

      DELETE FROM gipi_wpack_line_subline
            WHERE pack_par_id = p_pack_par_id;

      COMMIT;
   END del_wpack_line_subline_by_id;

   /*
   **  Created by        : Veronica V. Raymundo
   **  Date Created     : 10.24.2011
   **  Reference By     : (GIPIS094 - Endt Line Subline Coverage)
   **  Description     : Executes post_insert trigger on block B955
   */
   PROCEDURE gipis094_post_insert (
      p_pack_par_id       IN   gipi_wpack_line_subline.pack_par_id%TYPE,
      p_pack_line_cd      IN   gipi_wpack_line_subline.pack_line_cd%TYPE,
      p_pack_subline_cd   IN   gipi_wpack_line_subline.pack_subline_cd%TYPE,
      p_par_id            IN   gipi_wpack_line_subline.par_id%TYPE,
      p_line_cd           IN   gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd        IN   gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd            IN   gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy          IN   gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN   gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN   gipi_pack_polbasic.renew_no%TYPE
   )
   IS
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_accept_no    giri_winpolbas.accept_no%TYPE;
   BEGIN
      FOR c1 IN (SELECT pack_par_id, line_cd, iss_cd, par_yy, quote_seq_no,
                        par_type, assign_sw, par_status, assd_no, quote_id,
                        underwriter, remarks
                   FROM gipi_pack_parlist
                  WHERE pack_par_id = p_pack_par_id)
      LOOP
         INSERT INTO gipi_parlist
                     (pack_par_id, par_id, line_cd, iss_cd,
                      par_yy, quote_seq_no, par_type, assign_sw,
                      par_status, assd_no, quote_id, underwriter, remarks
                     )
              VALUES (c1.pack_par_id, p_par_id, p_pack_line_cd, c1.iss_cd,
                      c1.par_yy, c1.quote_seq_no, c1.par_type, c1.assign_sw,
                      3, c1.assd_no, c1.quote_id, c1.underwriter, c1.remarks
                     );

         INSERT INTO gipi_parhist
                     (par_id, user_id, parstat_date, entry_source, parstat_cd
                     )
              VALUES (p_par_id, c1.underwriter, SYSDATE, 'DB', '1'
                     );
      END LOOP;

      --A.R.C. 11.14.2006
      IF p_iss_cd = giisp.v ('ISS_CD_RI')
      THEN
         BEGIN
            SELECT winpolbas_accept_no_s.NEXTVAL
              INTO v_accept_no
              FROM DUAL;
         END;

         INSERT INTO giri_winpolbas
                     (accept_no, par_id, ri_cd, accept_date, ri_policy_no,
                      ri_endt_no, ri_binder_no, writer_cd, offer_date,
                      accept_by, orig_tsi_amt, orig_prem_amt, remarks,
                      ref_accept_no, pack_par_id, pack_accept_no)
            SELECT v_accept_no, p_par_id, ri_cd, accept_date, ri_policy_no,
                   ri_endt_no, ri_binder_no, writer_cd, offer_date, accept_by,
                   orig_tsi_amt, orig_prem_amt, remarks, ref_accept_no,
                   pack_par_id, pack_accept_no
              FROM giri_pack_winpolbas
             WHERE pack_par_id = p_pack_par_id;
      END IF;

      FOR c2 IN (SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
                        b.pol_seq_no, b.renew_no
                   FROM gipi_polbasic b, gipi_pack_polbasic a
                  WHERE b.pack_policy_id = a.pack_policy_id
                    AND a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.endt_seq_no = 0
                    AND a.pol_flag NOT IN ('5', '4')
                    AND a.dist_flag NOT IN ('5', 'X')
                    AND b.line_cd = p_pack_line_cd
                    AND b.subline_cd = p_pack_subline_cd)
      LOOP
         v_line_cd := c2.line_cd;
         v_subline_cd := c2.subline_cd;
         v_iss_cd := c2.iss_cd;
         v_issue_yy := c2.issue_yy;
         v_pol_seq_no := c2.pol_seq_no;
         v_renew_no := c2.renew_no;
      END LOOP;

      INSERT INTO gipi_wpolbas
                  (par_id, line_cd, iss_cd, foreign_acc_sw, invoice_sw,
                   quotation_printed_sw, covernote_printed_sw,
                   auto_renew_flag, prov_prem_tag, same_polno_sw,
                   pack_pol_flag, reg_policy_sw, co_insurance_sw,
                   manual_renew_no, subline_cd, issue_yy, pol_seq_no,
                   endt_iss_cd, endt_yy, endt_seq_no, renew_no, endt_type,
                   incept_date, expiry_date, expiry_tag, eff_date, issue_date,
                   pol_flag, assd_no, designation, address1, address2,
                   address3, mortg_name, tsi_amt, prem_amt, ann_tsi_amt,
                   ann_prem_amt, pool_pol_no, user_id, orig_policy_id,
                   endt_expiry_date, no_of_items, subline_type_cd,
                   prorate_flag, short_rt_percent, type_cd, acct_of_cd,
                   prov_prem_pct, discount_sw, prem_warr_tag, ref_pol_no,
                   ref_open_pol_no, incept_tag, fleet_print_tag, comp_sw,
                   booking_mth, booking_year, with_tariff_sw, endt_expiry_tag,
                   cover_nt_printed_date, cover_nt_printed_cnt, place_cd,
                   back_stat, qd_flag, validate_tag, industry_cd, region_cd,
                   acct_of_cd_sw, surcharge_sw, cred_branch, old_assd_no,
                   cancel_date, label_tag, old_address1, old_address2,
                   old_address3, risk_tag, pack_par_id)
         SELECT c.par_id, v_line_cd, v_iss_cd, b.foreign_acc_sw, b.invoice_sw,
                b.quotation_printed_sw, b.covernote_printed_sw,
                b.auto_renew_flag, b.prov_prem_tag, b.same_polno_sw,
                b.pack_pol_flag, b.reg_policy_sw, b.co_insurance_sw,
                b.manual_renew_no, v_subline_cd, v_issue_yy, v_pol_seq_no,
                b.endt_iss_cd, b.endt_yy, b.endt_seq_no, v_renew_no,
                b.endt_type, b.incept_date, b.expiry_date, b.expiry_tag,
                b.eff_date, b.issue_date, b.pol_flag, b.assd_no,
                b.designation, b.address1, b.address2, b.address3,
                b.mortg_name, b.tsi_amt, b.prem_amt, b.ann_tsi_amt,
                b.ann_prem_amt, b.pool_pol_no, b.user_id, b.orig_policy_id,
                b.endt_expiry_date, b.no_of_items, b.subline_type_cd,
                b.prorate_flag, b.short_rt_percent, b.type_cd, b.acct_of_cd,
                b.prov_prem_pct, b.discount_sw, b.prem_warr_tag, b.ref_pol_no,
                b.ref_open_pol_no, b.incept_tag, b.fleet_print_tag, b.comp_sw,
                b.booking_mth, b.booking_year, b.with_tariff_sw,
                b.endt_expiry_tag, b.cover_nt_printed_date,
                b.cover_nt_printed_cnt, b.place_cd, b.back_stat, b.qd_flag,
                b.validate_tag, b.industry_cd, b.region_cd, b.acct_of_cd_sw,
                b.surcharge_sw, b.cred_branch, b.old_assd_no, b.cancel_date,
                b.label_tag, b.old_address1, b.old_address2, b.old_address3,
                b.risk_tag, b.pack_par_id
           FROM gipi_parlist c, gipi_wpack_line_subline a,
                gipi_pack_wpolbas b
          WHERE 1 = 1
            AND c.par_id = a.par_id
            --  AND c.par_id = A.par_id
            AND c.line_cd = a.pack_line_cd
            AND a.pack_par_id = b.pack_par_id
            AND a.line_cd = b.line_cd
            AND a.par_id = p_par_id
            AND b.pack_par_id = p_pack_par_id;

      --A.R.C. 09.01.2006
      --to insert records to gipi_wendttext
      INSERT INTO gipi_wendttext
                  (par_id, endt_tax, endt_text01, endt_text02, endt_text03,
                   endt_text04, endt_text05, endt_text06, endt_text07,
                   endt_text08, endt_text09, endt_text10, endt_text11,
                   endt_text12, endt_text13, endt_text14, endt_text15,
                   endt_text16, endt_text17, endt_cd)
         SELECT p_par_id, endt_tax, endt_text01, endt_text02, endt_text03,
                endt_text04, endt_text05, endt_text06, endt_text07,
                endt_text08, endt_text09, endt_text10, endt_text11,
                endt_text12, endt_text13, endt_text14, endt_text15,
                endt_text16, endt_text17, endt_cd
           FROM gipi_pack_wendttext
          WHERE pack_par_id = p_pack_par_id;

      --A.R.C. 09.08.2006
      --to insert records to gipi_wpolgenin
      INSERT INTO gipi_wpolgenin
                  (par_id, gen_info01, gen_info02, gen_info03, gen_info04,
                   gen_info05, gen_info06, gen_info07, gen_info08, gen_info09,
                   gen_info10, gen_info11, gen_info12, gen_info13, gen_info14,
                   gen_info15, gen_info16, gen_info17, genin_info_cd,
                   initial_info01, initial_info02, initial_info03,
                   initial_info04, initial_info05, initial_info06,
                   initial_info07, initial_info08, initial_info09,
                   initial_info10, initial_info11, initial_info12,
                   initial_info13, initial_info14, initial_info15,
                   initial_info16, initial_info17, agreed_tag)
         SELECT p_par_id, gen_info01, gen_info02, gen_info03, gen_info04,
                gen_info05, gen_info06, gen_info07, gen_info08, gen_info09,
                gen_info10, gen_info11, gen_info12, gen_info13, gen_info14,
                gen_info15, gen_info16, gen_info17, genin_info_cd,
                initial_info01, initial_info02, initial_info03,
                initial_info04, initial_info05, initial_info06,
                initial_info07, initial_info08, initial_info09,
                initial_info10, initial_info11, initial_info12,
                initial_info13, initial_info14, initial_info15,
                initial_info16, initial_info17, agreed_tag
           FROM gipi_pack_wpolgenin
          WHERE pack_par_id = p_pack_par_id;
   END;

   /*
   **  Created by        : Veronica V. Raymundo
   **  Date Created     : 10.24.2011
   **  Reference By    : (GIPIS094 - Endt Line Subline Coverage)
   **  Description    : Gets all the records fro gipi_wpack_line_subline
   **                   with the given pack_par_id.
   */
   FUNCTION get_wpack_line_subline_list2 (
      p_pack_par_id   gipi_wpack_line_subline.pack_par_id%TYPE
   )
      RETURN gipi_wpack_line_subline_tab1 PIPELINED
   IS
      v_line_subline   gipi_wpack_line_subline_type1;
      v_line_name      giis_line.line_name%TYPE;
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT a.*
                  FROM gipi_wpack_line_subline a
                 WHERE pack_par_id = p_pack_par_id)
      LOOP
         BEGIN
            SELECT DISTINCT line_name
                       INTO v_line_subline.pack_line_name
                       FROM giis_line
                      WHERE line_cd = a.pack_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_line_subline.pack_line_name := NULL;
         END;

         BEGIN
            SELECT DISTINCT subline_name
                       INTO v_line_subline.pack_subline_name
                       FROM giis_subline
                      WHERE subline_cd = a.pack_subline_cd
                        AND line_cd = a.pack_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_line_subline.pack_subline_name := NULL;
         END;

         v_line_subline.pack_par_id := a.pack_par_id;
         v_line_subline.par_id := a.par_id;
         v_line_subline.pack_line_cd := a.pack_line_cd;
         v_line_subline.pack_subline_cd := a.pack_subline_cd;
         v_line_subline.item_tag := a.item_tag;
         v_line_subline.remarks := a.remarks;
         PIPE ROW (v_line_subline);
      END LOOP;

      RETURN;
   END;

   /**
       Description: updates the amount of the sub policies of the package when the cancellation is untagged.
    Date: 10.29.2012
    Irwin
   */
   PROCEDURE cancellation_update_amounts (
      p_pack_par_id   IN   gipi_wpack_line_subline.pack_par_id%TYPE
   )
   IS
      v_ann_tsi_amt    gipi_wpolbas.ann_tsi_amt%TYPE;
      v_ann_prem_amt   gipi_wpolbas.ann_prem_amt%TYPE;
   BEGIN
      FOR i IN (SELECT ABS (tsi_amt) tsi_amt,
                       ABS (prem_amt) prem_amt, par_id
                  FROM gipi_wpolbas
                 WHERE pack_par_id = p_pack_par_id)
      LOOP
         v_ann_tsi_amt := i.tsi_amt;
         v_ann_prem_amt := i.prem_amt;

         BEGIN
            UPDATE gipi_wpolbas
               SET tsi_amt = 0,
                   prem_amt = 0,
                   ann_tsi_amt = v_ann_tsi_amt,
                   ann_prem_amt = v_ann_prem_amt
             WHERE par_id = i.par_id;
         END;
      END LOOP;
   END;
END;
/


