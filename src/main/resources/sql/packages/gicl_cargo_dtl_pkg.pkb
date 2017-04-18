CREATE OR REPLACE PACKAGE BODY CPI.gicl_cargo_dtl_pkg
AS
   /*
     **  Created by   :  Irwin Tabisora
     **  Date Created :  09.29.2011
     **  Reference By : (GICLS019- Claims Marine Cargo Item Information)
     **  Description  : Retrieves the Cargo Item Info
     */
   FUNCTION get_gicl_cargo_dtl (p_claim_id gicl_cargo_dtl.claim_id%TYPE)
      RETURN gicl_cargo_dtl_tab PIPELINED
   IS
      v_item   gicl_cargo_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_cargo_dtl
                 WHERE claim_id = p_claim_id)
      LOOP
         v_item.claim_id := i.claim_id;
         v_item.item_no := i.item_no;
         v_item.user_id := i.user_id;
         v_item.item_title := i.item_title;
         v_item.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY HH:MI AM');  -- added timestamp : shan 04.15.2014
         v_item.currency_cd := i.currency_cd;
         v_item.last_update := i.last_update;
         v_item.cpi_rec_no := i.cpi_rec_no;
         v_item.cpi_branch_cd := i.cpi_branch_cd;
         v_item.geog_cd := i.geog_cd;
         v_item.cargo_class_cd := i.cargo_class_cd;
         v_item.voyage_no := i.voyage_no;
         v_item.bl_awb := i.bl_awb;
         v_item.origin := i.origin;
         v_item.destn := i.destn;
         v_item.etd := i.etd;
         v_item.eta := i.eta;
         v_item.cargo_type := i.cargo_type;
         v_item.deduct_text := i.deduct_text;
         v_item.pack_method := i.pack_method;
         v_item.tranship_origin := i.tranship_origin;
         v_item.tranship_destination := i.tranship_destination;
         v_item.lc_no := i.lc_no;
         v_item.currency_rate := i.currency_rate;
         v_item.vessel_cd := i.vessel_cd;

         BEGIN
            SELECT item_desc, item_desc2
              INTO v_item.item_desc, v_item.item_desc2
              FROM gicl_clm_item
             WHERE 1 = 1
               AND claim_id = p_claim_id
               AND item_no = v_item.item_no
               AND grouped_item_no = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item.item_desc := NULL;
               v_item.item_desc2 := NULL;
         END;

         -- vessel name
         IF v_item.vessel_cd IS NOT NULL
         THEN
            FOR c IN (SELECT vessel_name
                        FROM giis_vessel
                       WHERE vessel_cd = v_item.vessel_cd)
            LOOP
               v_item.vessel_name := c.vessel_name;
            END LOOP;
         ELSE
            v_item.vessel_name := NULL;
         END IF;

         -- geog desc
         FOR c IN (SELECT geog_desc
                     FROM giis_geog_class
                    WHERE geog_cd = v_item.geog_cd)
         LOOP
            v_item.geog_desc := NVL (c.geog_desc, NULL);
         END LOOP;

         -- cargo class desc
         FOR c IN (SELECT cargo_class_desc
                     FROM giis_cargo_class
                    WHERE cargo_class_cd = v_item.cargo_class_cd)
         LOOP
            v_item.cargo_class_desc := NVL (c.cargo_class_desc, NULL);
         END LOOP;

         -- cargo type desc
         FOR c IN (SELECT cargo_type_desc
                     FROM giis_cargo_type
                    WHERE cargo_type = v_item.cargo_type
                      AND cargo_class_cd = v_item.cargo_class_cd)
         LOOP
            v_item.cargo_type_desc := NVL (c.cargo_type_desc, NULL);
         END LOOP;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency
                    WHERE main_currency_cd = v_item.currency_cd)
         LOOP
            v_item.dsp_currency_desc := c.currency_desc;
         END LOOP;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist (v_item.item_no,
                                                               v_item.claim_id
                                                              )
           INTO v_item.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (v_item.item_no,
                                                             v_item.claim_id
                                                            )
           INTO v_item.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve
                                                   (v_item.item_no,
                                                    v_item.claim_id,
                                                    0, --belle grouped item no 02.13.2012
                                                    v_item.gicl_item_peril_msg
                                                   );
         PIPE ROW (v_item);
      END LOOP;
   END;

      /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.302011
   **  Reference By : (GICLS019- Claims Marine Cargo Item Information)
   **  Description  : Validates the item_no
   */
   PROCEDURE validate_gicl_cargo_item_no (
      p_line_cd                 gipi_polbasic.line_cd%TYPE,
      p_subline_cd              gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
      p_expiry_date             gipi_polbasic.expiry_date%TYPE,
      p_loss_date               gipi_polbasic.expiry_date%TYPE,
      p_incept_date             gipi_polbasic.incept_date%TYPE,
      p_item_no                 gipi_item.item_no%TYPE,
      p_claim_id                gicl_cargo_dtl.claim_id%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c006             IN OUT   gicl_cargo_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT gicl_cargo_dtl_pkg.check_cargo_item_no (p_claim_id,
                                                     p_item_no,
                                                     p_from,
                                                     p_to
                                                    )
        INTO p_item_exist2
        FROM DUAL;

      SELECT giac_validate_user_fn (giis_users_pkg.app_user, 'TL', 'GICLS015')
        INTO p_override_fl
        FROM DUAL;

      SELECT gipi_item_pkg.check_existing_item (p_line_cd,
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_pol_eff_date,
                                                p_expiry_date,
                                                p_loss_date,
                                                p_item_no
                                               )
        INTO p_item_exist
        FROM DUAL;

      SELECT check_total_loss_settlement2 (0,
                                           NULL,
                                           p_item_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_loss_date,
                                           p_pol_eff_date,
                                           p_expiry_date
                                          )
        INTO p_tloss_fl
        FROM DUAL;

      OPEN c006 FOR
         SELECT *
           FROM TABLE
                   (gicl_cargo_dtl_pkg.extract_latest_marine_data
                                                              (p_line_cd,
                                                               p_subline_cd,
                                                               p_pol_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no,
                                                               p_pol_eff_date,
                                                               p_expiry_date,
                                                               p_loss_date,
                                                               p_item_no,
                                                               p_claim_id
                                                              )
                   );
   END;

   FUNCTION check_cargo_item_no (
      p_claim_id    gicl_cargo_dtl.claim_id%TYPE,
      p_item_no     gicl_cargo_dtl.item_no%TYPE,
      p_start_row   VARCHAR2,
      p_end_row     VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE
                                   (gicl_cargo_dtl_pkg.get_gicl_cargo_dtl
                                                                   (p_claim_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END;

   /*
   **  Created by    : Irwin Tabisora
   **  Date Created  : 09.30.2011
   **  Reference By  : (GICLS019 - cargo Item Information)
   **  Description   : extract_marine_data program unit - extracting marine cargo details
   */
   FUNCTION extract_latest_marine_data (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE,
      p_claim_id       gicl_cargo_dtl.claim_id%TYPE
   )
      RETURN gicl_cargo_dtl_tab PIPELINED
   IS
      v_item                   gicl_cargo_dtl_type;
      v_item_desc              gicl_clm_item.item_desc%TYPE;
      v_item_desc2             gicl_clm_item.item_desc2%TYPE;
      v_currency_cd            gipi_item.currency_cd%TYPE;
      v_currency_desc          giis_currency.currency_desc%TYPE;
      v_currency_rt            gipi_item.currency_rt%TYPE;
      v_max_endt_seq_no        gipi_polbasic.endt_seq_no%TYPE         := 0;
      v_vessel_cd              gipi_cargo.vessel_cd%TYPE;
      v_geog_cd                gipi_cargo.geog_cd%TYPE;
      v_cargo_class_cd         gipi_cargo.cargo_class_cd%TYPE;
      v_pack_method            gipi_cargo.pack_method%TYPE;
      v_origin                 gipi_cargo.origin%TYPE;
      v_destn                  gipi_cargo.destn%TYPE;
      v_tranship_origin        gipi_cargo.tranship_origin%TYPE;
      v_tranship_destination   gipi_cargo.tranship_destination%TYPE;
      v_voyage_no              gipi_cargo.voyage_no%TYPE;
      v_lc_no                  gipi_cargo.lc_no%TYPE;
      v_deduct_text            gipi_cargo.deduct_text%TYPE;
      v_bl_awb                 gipi_cargo.bl_awb%TYPE;
      v_cargo_type             gipi_cargo.cargo_type%TYPE;
      v_etd                    gipi_cargo.etd%TYPE;
      v_eta                    gipi_cargo.eta%TYPE;
      v_cnt                    NUMBER                                 := 0;
      v_item_title             gipi_item.item_title%TYPE;
   BEGIN
    -------------------------------------------------
--first get info. from policy and all valid endt.
-------------------------------------------------
      FOR c1 IN
         (SELECT   c.item_desc, c.item_desc2, endt_seq_no, c.currency_cd,
                   e.currency_desc, c.currency_rt, d.vessel_cd, d.geog_cd,
                   d.cargo_class_cd, d.pack_method, d.origin, d.destn,
                   d.tranship_origin, d.tranship_destination, d.voyage_no,
                   d.lc_no, d.deduct_text, d.bl_awb, d.cargo_type, d.etd,
                   d.eta, c.item_title
              FROM gipi_polbasic b,
                   gipi_item c,
                   gipi_cargo d,
                   giis_currency e
             WHERE                      --:control.claim_id = :global.claim_id
                   --AND
                   p_line_cd = b.line_cd
               AND p_subline_cd = b.subline_cd
               AND p_pol_iss_cd = b.iss_cd
               AND c.item_no = p_item_no
               AND p_issue_yy = b.issue_yy
               AND p_pol_seq_no = b.pol_seq_no
               AND p_renew_no = b.renew_no
               AND b.policy_id = c.policy_id
               AND c.currency_cd = e.main_currency_cd
               AND c.policy_id = d.policy_id
               AND c.item_no = d.item_no
               AND b.pol_flag IN ('1', '2', '3', 'X')
               AND TRUNC (DECODE (TRUNC (b.eff_date),
                                  TRUNC (b.incept_date), p_pol_eff_date,
                                  b.eff_date
                                 )
                         ) <= TRUNC (p_loss_date)
               --AND TRUNC(b.eff_date)   <= :control.loss_date
               AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                  b.expiry_date, p_expiry_date,
                                  b.endt_expiry_date
                                 )
                         ) >= TRUNC (p_loss_date)
          ORDER BY eff_date ASC)
      LOOP
         v_item_desc := NVL (c1.item_desc, v_item_desc);
         v_item_desc2 := NVL (c1.item_desc2, v_item_desc2);
         --variable.v_temp    := v_item_desc;
         --variable.v_temp2   := v_item_desc2;
         v_max_endt_seq_no := c1.endt_seq_no;
         v_currency_cd := NVL (c1.currency_cd, v_currency_cd);
         v_currency_desc := NVL (c1.currency_desc, v_currency_desc);
         v_currency_rt := NVL (c1.currency_rt, v_currency_rt);
         v_vessel_cd := NVL (c1.vessel_cd, v_vessel_cd);
         v_geog_cd := NVL (c1.geog_cd, v_geog_cd);
         v_cargo_class_cd := NVL (c1.cargo_class_cd, v_cargo_class_cd);
         v_pack_method := NVL (c1.pack_method, v_pack_method);
         v_origin := NVL (c1.origin, v_origin);
         v_destn := NVL (c1.destn, v_destn);
         v_tranship_origin := NVL (c1.tranship_origin, v_tranship_origin);
         v_tranship_destination :=
                        NVL (c1.tranship_destination, v_tranship_destination);
         v_voyage_no := NVL (c1.voyage_no, v_voyage_no);
         v_lc_no := NVL (c1.lc_no, v_lc_no);
         v_deduct_text := NVL (c1.deduct_text, v_deduct_text);
         v_bl_awb := NVL (c1.bl_awb, v_bl_awb);
         v_cargo_type := NVL (c1.cargo_type, v_cargo_type);
         v_etd := NVL (c1.etd, v_etd);
         v_eta := NVL (c1.eta, v_eta);
         v_item_title := NVL (c1.item_title, v_item_title);
      END LOOP;

------------------------------
--get info from backward endt.
------------------------------
      FOR c2 IN
         (SELECT   c.item_desc, c.item_desc2, c.currency_cd, e.currency_desc,
                   c.currency_rt, d.vessel_cd, d.geog_cd, d.cargo_class_cd,
                   d.pack_method, d.origin, d.destn, d.tranship_origin,
                   d.tranship_destination, d.voyage_no, d.lc_no,
                   d.deduct_text, d.bl_awb, d.cargo_type, d.etd, d.eta,
                   c.item_title
              FROM gipi_polbasic b, gipi_item c, gipi_cargo d,
                   giis_currency e
             WHERE                  --:control.claim_id     = :global.claim_id
                   --AND
                   p_line_cd = b.line_cd
               AND p_subline_cd = b.subline_cd
               AND p_pol_iss_cd = b.iss_cd
               AND c.item_no = p_item_no
               AND p_issue_yy = b.issue_yy
               AND p_pol_seq_no = b.pol_seq_no
               AND p_renew_no = b.renew_no
               AND b.policy_id = c.policy_id
               AND c.currency_cd = e.main_currency_cd
               AND c.policy_id = d.policy_id
               AND c.item_no = d.item_no
               AND NVL (b.back_stat, 5) = 2
               AND b.pol_flag IN ('1', '2', '3', 'X')
               AND endt_seq_no > v_max_endt_seq_no
               AND TRUNC (DECODE (TRUNC (b.eff_date),
                                  TRUNC (b.incept_date), p_pol_eff_date,
                                  b.eff_date
                                 )
                         ) <= TRUNC (p_loss_date)
               --AND TRUNC(b.eff_date)   <= :control.loss_date
               AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                  b.expiry_date, p_expiry_date,
                                  b.endt_expiry_date
                                 )
                         ) >= TRUNC (p_loss_date)
          ORDER BY endt_seq_no ASC)
      LOOP
         v_item_desc := NVL (c2.item_desc, v_item_desc);
         v_item_desc2 := NVL (c2.item_desc2, v_item_desc2);
         --variable.v_temp       := v_item_desc;
         --variable.v_temp2      := v_item_desc2;
         v_currency_cd := NVL (c2.currency_cd, v_currency_cd);
         v_currency_desc := NVL (c2.currency_desc, v_currency_desc);
         v_currency_rt := NVL (c2.currency_rt, v_currency_rt);
         v_vessel_cd := NVL (c2.vessel_cd, v_vessel_cd);
         v_geog_cd := NVL (c2.geog_cd, v_geog_cd);
         v_cargo_class_cd := NVL (c2.cargo_class_cd, v_cargo_class_cd);
         v_pack_method := NVL (c2.pack_method, v_pack_method);
         v_origin := NVL (c2.origin, v_origin);
         v_destn := NVL (c2.destn, v_destn);
         v_tranship_origin := NVL (c2.tranship_origin, v_tranship_origin);
         v_tranship_destination :=
                        NVL (c2.tranship_destination, v_tranship_destination);
         v_voyage_no := NVL (c2.voyage_no, v_voyage_no);
         v_lc_no := NVL (c2.lc_no, v_lc_no);
         v_deduct_text := NVL (c2.deduct_text, v_deduct_text);
         v_bl_awb := NVL (c2.bl_awb, v_bl_awb);
         v_cargo_type := NVL (c2.cargo_type, v_cargo_type);
         v_etd := NVL (c2.etd, v_etd);
         v_eta := NVL (c2.eta, v_eta);
         v_item_title := NVL (c2.item_title, v_item_title);
      END LOOP;

      --message(v_item_desc||'-222');
      FOR ves IN (SELECT f.item_desc, f.item_desc2, a.vessel_cd,
                         c.vessel_name
                    FROM gipi_cargo a,
                         giis_vessel c,
                         gipi_item f,
                         gicl_claims h,
                         gipi_polbasic z
                   WHERE a.policy_id = f.policy_id
                     AND a.item_no = f.item_no
                     AND a.item_no = TO_CHAR (p_item_no)
                     AND a.vessel_cd = c.vessel_cd
                     AND h.claim_id = TO_CHAR (p_claim_id)
                     AND z.policy_id = a.policy_id
                     AND z.line_cd = p_line_cd
                     AND z.subline_cd = p_subline_cd
                     AND z.iss_cd = p_pol_iss_cd
                     AND z.pol_seq_no = p_pol_seq_no
                     AND z.issue_yy = p_issue_yy
                     AND z.renew_no = p_renew_no
                     AND z.pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC (DECODE (TRUNC (z.eff_date),
                                        TRUNC (z.incept_date), p_pol_eff_date,
                                        z.eff_date
                                       )
                               ) <= TRUNC (p_loss_date)
                     --and trunc(z.eff_date) <= :control.loss_date
                     AND TRUNC (DECODE (NVL (z.endt_expiry_date,
                                             z.expiry_date),
                                        z.expiry_date, p_expiry_date,
                                        z.endt_expiry_date
                                       )
                               ) >= TRUNC (p_loss_date))
      LOOP
         v_cnt := v_cnt + 1;
      END LOOP;

      -- assign to main types
      v_item.item_no := p_item_no;
      v_item.item_desc := v_item_desc;
      v_item.item_desc2 := v_item_desc2;
      v_item.currency_cd := v_currency_cd;
      v_item.dsp_currency_desc := v_currency_desc;
      v_item.currency_rate := v_currency_rt;
      v_item.geog_cd := v_geog_cd;
      v_item.cargo_class_cd := v_cargo_class_cd;
      v_item.pack_method := v_pack_method;
      v_item.origin := v_origin;
      v_item.destn := v_destn;
      v_item.tranship_origin := v_tranship_origin;
      v_item.tranship_destination := v_tranship_destination;
      v_item.voyage_no := v_voyage_no;
      v_item.lc_no := v_lc_no;
      v_item.deduct_text := v_deduct_text;
      v_item.bl_awb := v_bl_awb;
      v_item.cargo_type := v_cargo_type;
      v_item.etd := v_etd;
      v_item.eta := v_eta;
      v_item.item_title := v_item_title;
      v_item.vessel_cd :=v_vessel_cd;

      IF v_item.vessel_cd IS NOT NULL
      THEN
         FOR c IN (SELECT vessel_name
                     FROM giis_vessel
                    WHERE vessel_cd = v_item.vessel_cd)
         LOOP
            v_item.vessel_name := c.vessel_name;
         END LOOP;
      ELSE
         v_item.vessel_name := NULL;
      END IF;

      FOR c IN (SELECT geog_desc
                  FROM giis_geog_class
                 WHERE geog_cd = v_item.geog_cd)
      LOOP
         v_item.geog_desc := c.geog_desc;
      END LOOP;

      FOR c IN (SELECT cargo_class_desc
                  FROM giis_cargo_class
                 WHERE cargo_class_cd = v_item.cargo_class_cd)
      LOOP
         v_item.cargo_class_desc := c.cargo_class_desc;
      END LOOP;

      FOR c IN (SELECT cargo_type_desc
                  FROM giis_cargo_type
                 WHERE cargo_type = v_item.cargo_type
                   AND cargo_class_cd = v_item.cargo_class_cd)
      LOOP
         v_item.cargo_type_desc := c.cargo_type_desc;
      END LOOP;

      FOR c IN (SELECT currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = v_item.currency_cd)
      LOOP
         v_item.dsp_currency_desc := c.currency_desc;
      END LOOP;

      BEGIN
         SELECT item_desc, item_desc2
           INTO v_item.item_desc, v_item.item_desc2
           FROM gicl_clm_item
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      PIPE ROW (v_item);
   END;

   PROCEDURE del_gicl_cargo_dtl (
      p_claim_id   gicl_cargo_dtl.claim_id%TYPE,
      p_item_no    gicl_cargo_dtl.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_cargo_dtl
            WHERE claim_id = p_claim_id AND item_no = p_item_no;
   END;

   PROCEDURE set_gicl_cargo_dtl (
      p_claim_id               gicl_cargo_dtl.claim_id%TYPE,
      p_item_no                gicl_cargo_dtl.item_no%TYPE,
      p_vessel_cd              gicl_cargo_dtl.vessel_cd%TYPE,
      p_geog_cd                gicl_cargo_dtl.geog_cd%TYPE,
      p_cargo_class_cd         gicl_cargo_dtl.cargo_class_cd%TYPE,
      p_voyage_no              gicl_cargo_dtl.voyage_no%TYPE,
      p_bl_awb                 gicl_cargo_dtl.bl_awb%TYPE,
      p_origin                 gicl_cargo_dtl.origin%TYPE,
      p_destn                  gicl_cargo_dtl.destn%TYPE,
      p_etd                    gicl_cargo_dtl.etd%TYPE,
      p_eta                    gicl_cargo_dtl.eta%TYPE,
      p_cargo_type             gicl_cargo_dtl.cargo_type%TYPE,
      p_deduct_text            gicl_cargo_dtl.deduct_text%TYPE,
      p_pack_method            gicl_cargo_dtl.pack_method%TYPE,
      p_tranship_origin        gicl_cargo_dtl.tranship_origin%TYPE,
      p_tranship_destination   gicl_cargo_dtl.tranship_destination%TYPE,
      p_lc_no                  gicl_cargo_dtl.lc_no%TYPE,
      p_item_title             gicl_cargo_dtl.item_title%TYPE,
      p_currency_cd            gicl_cargo_dtl.currency_cd%TYPE,
      p_currency_rate          gicl_cargo_dtl.currency_rate%TYPE,
      p_cpi_rec_no             gicl_cargo_dtl.cpi_rec_no%TYPE,
      p_cpi_branch_cd          gicl_cargo_dtl.cpi_branch_cd%TYPE
   )
   IS
      v_loss_date   gicl_claims.dsp_loss_date%TYPE;
   BEGIN
   /* Modified by : Joms Diago
   ** Date Modified : 04152013
   ** Description : loss_date was not inserted. Insert loss_date.
   */
      FOR a IN (SELECT dsp_loss_date
                  FROM gicl_claims
                 WHERE claim_id = p_claim_id)
      LOOP
         v_loss_date := a.dsp_loss_date;
      END LOOP;

      MERGE INTO gicl_cargo_dtl
         USING DUAL
         ON (claim_id = p_claim_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (claim_id, item_no, vessel_cd, geog_cd, cargo_class_cd,
                    voyage_no, bl_awb, origin, destn, etd, eta, cargo_type,
                    deduct_text, pack_method, tranship_origin,
                    tranship_destination, lc_no, item_title, currency_cd,
                    currency_rate, user_id, last_update, cpi_rec_no,
                    cpi_branch_cd, loss_date)
            VALUES (p_claim_id, p_item_no, p_vessel_cd, p_geog_cd,
                    p_cargo_class_cd, p_voyage_no, p_bl_awb, p_origin,
                    p_destn, p_etd, p_eta, p_cargo_type, p_deduct_text,
                    p_pack_method, p_tranship_origin, p_tranship_destination,
                    p_lc_no, p_item_title, p_currency_cd, p_currency_rate,
                    giis_users_pkg.app_user, SYSDATE, p_cpi_rec_no,
                    p_cpi_branch_cd, v_loss_date)
         WHEN MATCHED THEN
            UPDATE
               SET vessel_cd = p_vessel_cd, geog_cd = p_geog_cd,
                   cargo_class_cd = p_cargo_class_cd, voyage_no = p_voyage_no,
                   bl_awb = p_bl_awb, origin = p_origin, destn = p_destn,
                   etd = p_etd, eta = p_eta, cargo_type = p_cargo_type,
                   deduct_text = p_deduct_text, pack_method = p_pack_method,
                   tranship_origin = p_tranship_origin,
                   tranship_destination = p_tranship_destination,
                   lc_no = p_lc_no, item_title = p_item_title,
                   currency_cd = p_currency_cd,
                   currency_rate = p_currency_rate,
                   user_id = giis_users_pkg.app_user, last_update = SYSDATE,
                   cpi_rec_no = p_cpi_rec_no, cpi_branch_cd = p_cpi_branch_cd,
                   loss_date = v_loss_date
            ;
   END;
END;
/


