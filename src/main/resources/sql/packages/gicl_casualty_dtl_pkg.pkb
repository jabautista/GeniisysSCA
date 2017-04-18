CREATE OR REPLACE PACKAGE BODY CPI.GICL_CASUALTY_DTL_PKG
AS
   /**
   * Rey Jadlocon
   * 09-21-2011
   **/
   FUNCTION get_casualty_item_lov (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN get_casualty_item_info_tab
      PIPELINED
   IS
      v_casualty_item_info   get_casualty_item_info_type;
   BEGIN
      FOR casualty IN (SELECT line_cd,
                              subline_cd,
                              pol_iss_cd,
                              issue_yy,
                              pol_seq_no,
                              renew_no,
                              loss_date,
                              pol_eff_date,
                              expiry_date,
                              claim_id
                         FROM gicl_claims
                        WHERE claim_id = p_claim_id)
      LOOP
         v_casualty_item_info.line_cd := casualty.line_cd;
         v_casualty_item_info.subline_cd := casualty.subline_cd;
         v_casualty_item_info.pol_iss_cd := casualty.pol_iss_cd;
         v_casualty_item_info.issue_yy := casualty.issue_yy;
         v_casualty_item_info.pol_seq_no := casualty.pol_seq_no;
         v_casualty_item_info.renew_no := casualty.renew_no;
         v_casualty_item_info.loss_date := casualty.loss_date;
         v_casualty_item_info.pol_eff_date := casualty.pol_eff_date;
         v_casualty_item_info.expiry_date := casualty.expiry_date;
         v_casualty_item_info.claim_id := casualty.claim_id;

         SELECT DISTINCT b.item_no,
                         Get_Latest_Item_Title (casualty.line_cd,
                                                casualty.subline_cd,
                                                casualty.pol_iss_cd,
                                                casualty.issue_yy,
                                                casualty.pol_seq_no,
                                                casualty.renew_no,
                                                b.item_no,
                                                casualty.loss_date,
                                                casualty.pol_eff_date,
                                                casualty.expiry_date)
                            item_title
           INTO v_casualty_item_info.item_no, v_casualty_item_info.item_title
           FROM gipi_polbasic a, gipi_item b
          WHERE     a.line_cd = casualty.line_cd
                AND a.subline_cd = casualty.subline_cd
                AND a.iss_cd = casualty.pol_iss_cd
                AND a.issue_yy = casualty.issue_yy
                AND a.pol_seq_no = casualty.pol_seq_no
                AND a.renew_no = casualty.renew_no
                AND a.pol_flag IN ('1', '2', '3', 'X')
                AND TRUNC (
                       DECODE (
                          TRUNC (NVL (b.from_date, eff_date)),
                          TRUNC (a.incept_date), NVL (b.from_date,
                                                      casualty.pol_eff_date),
                          NVL (b.from_date, a.eff_date))) <=
                       casualty.loss_date
                AND TRUNC (
                       DECODE (
                          NVL (b.TO_DATE,
                               NVL (a.endt_expiry_date, a.expiry_date)),
                          a.expiry_date, NVL (b.TO_DATE,
                                              casualty.expiry_date),
                          NVL (b.TO_DATE, a.endt_expiry_date))) >=
                       casualty.loss_date
                AND a.policy_id = b.policy_id;

         PIPE ROW (v_casualty_item_info);
      END LOOP;

      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 09-22-2011
   **/
   PROCEDURE extract_latest_grouped (
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_subline_cd            gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy              gicl_claims.issue_yy%TYPE,
      p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      p_renew_no              gicl_claims.renew_no%TYPE,
      p_expiry_date           gicl_claims.expiry_date%TYPE,
      p_loss_date             gicl_claims.loss_date%TYPE,
      p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,
      p_item_no               gipi_item.item_no%TYPE,
      p_grouped_item_no       gicl_casualty_dtl.grouped_item_no%TYPE,
      grouped             OUT get_casualty_item_info_type)
   IS
      v_endt_seq_no          GIPI_POLBASIC.endt_seq_no%TYPE;
      v_grouped_item_title   GICL_CASUALTY_DTL.grouped_item_title%TYPE;
      v_amount_coverage      GICL_CASUALTY_DTL.amount_coverage%TYPE;
   BEGIN
      FOR i
         IN (  SELECT a.endt_seq_no, c.grouped_item_title, c.amount_coverage
                 FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                WHERE     1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND b.item_no = p_item_no
                      AND c.grouped_item_no = p_grouped_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
             ORDER BY eff_date ASC)
      LOOP
         v_endt_seq_no := i.endt_seq_no;
         v_grouped_item_title := i.grouped_item_title;
         v_amount_coverage := i.amount_coverage;
      END LOOP;


      FOR j
         IN (  SELECT c.grouped_item_title, c.amount_coverage
                 FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                WHERE     1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND NVL (a.back_stat, 5) = 2
                      AND endt_seq_no > v_endt_seq_no
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND b.item_no = p_item_no
                      AND c.grouped_item_no = p_grouped_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
             ORDER BY eff_date ASC)
      LOOP
         v_grouped_item_title := j.grouped_item_title;
         v_amount_coverage := j.amount_coverage;
      END LOOP;

      grouped.grouped_item_title := v_grouped_item_title;
      grouped.amount_coverage := v_amount_coverage;
   END;

   /**
   * Rey Jadlocon
   * 09-22-2011
   **/
   PROCEDURE extract_latest_CAdata (
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_subline_cd            gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy              gicl_claims.issue_yy%TYPE,
      p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      p_renew_no              gicl_claims.renew_no%TYPE,
      p_expiry_date           gicl_claims.expiry_date%TYPE,
      p_loss_date             gicl_claims.loss_date%TYPE,
      p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,
      p_item_no               gipi_item.item_no%TYPE,
      CAData           IN OUT get_casualty_item_info_type)
   IS
      v_endt_seq_no              gipi_polbasic.endt_seq_no%TYPE;
      v_item_title               gicl_casualty_dtl.item_title%TYPE;
      v_item_desc                gicl_clm_item.item_desc%TYPE;
      v_item_desc2               gicl_clm_item.item_desc2%TYPE;
      v_currency_cd              gicl_casualty_dtl.currency_cd%TYPE;
      v_currency_rate            gicl_casualty_dtl.currency_rate%TYPE;
      v_capacity_cd              gicl_casualty_dtl.capacity_cd%TYPE;
      v_section_line_cd          gicl_casualty_dtl.section_line_cd%TYPE;
      v_section_subline_cd       gicl_casualty_dtl.section_subline_cd%TYPE;
      v_section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_cd%TYPE;
      v_section_or_hazard_info   gicl_casualty_dtl.section_or_hazard_info%TYPE;
      v_property_no_type         gicl_casualty_dtl.property_no_type%TYPE;
      v_property_no              gicl_casualty_dtl.property_no%TYPE;
      v_location                 gicl_casualty_dtl.location%TYPE;
      v_location_cd              gicl_casualty_dtl.location_cd%TYPE;
      v_conveyance_info          gicl_casualty_dtl.conveyance_info%TYPE;
      v_interest_on_premises     gicl_casualty_dtl.interest_on_premises%TYPE;
      v_limit_of_liability       gicl_casualty_dtl.limit_of_liability%TYPE;
      v_currency_desc            giis_currency.currency_desc%TYPE;
      v_position                 giis_position.position%TYPE;

      /**
       For Grouped item info - irwin 9.20.2012
      **/
      v_endt_seq_no2             GIPI_POLBASIC.endt_seq_no%TYPE;
      v_grouped_item_title       GICL_CASUALTY_DTL.grouped_item_title%TYPE;
      v_amount_coverage          GICL_CASUALTY_DTL.amount_coverage%TYPE;
      v_grp                      gicl_casualty_dtl.grouped_item_no%TYPE;
   BEGIN
      FOR v1
         IN (  SELECT endt_seq_no,
                      b.item_title,
                      b.item_desc,
                      b.item_desc2,
                      b.currency_cd,
                      b.currency_rt,
                      c.capacity_cd,
                      c.section_line_cd,
                      c.section_subline_cd,
                      c.section_or_hazard_cd,
                      c.section_or_hazard_info,
                      c.property_no_type,
                      c.property_no,
                      c.location,
                      c.location_cd, --jess 04122010 add location_cd to be select
                      c.conveyance_info,
                      c.interest_on_premises,
                      c.limit_of_liability
                 FROM gipi_polbasic a,
                      gipi_item b,
                      gipi_casualty_item c,
                      giis_ca_location d
                WHERE     1 = 1
                      AND c.location_cd = d.location_cd(+)
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND b.item_no = p_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id(+)
                      AND b.item_no = c.item_no(+)
             ORDER BY eff_date ASC)
      LOOP
         v_endt_seq_no := v1.endt_seq_no;
         v_item_title := v1.item_title;
         v_item_desc := v1.item_desc;
         v_item_desc2 := v1.item_desc2;
         v_currency_cd := v1.currency_cd;
         v_currency_rate := v1.currency_rt;
         v_capacity_cd := v1.capacity_cd;
         v_section_line_cd := v1.section_line_cd;
         v_section_subline_cd := v1.section_subline_cd;
         v_section_or_hazard_cd := v1.section_or_hazard_cd;
         v_section_or_hazard_info := v1.section_or_hazard_info;
         v_property_no_type := v1.property_no_type;
         v_property_no := v1.property_no;
         v_location := v1.location;
         v_location_cd := v1.location_cd;
         v_conveyance_info := v1.conveyance_info;
         v_interest_on_premises := v1.interest_on_premises;
         v_limit_of_liability := v1.limit_of_liability;
      END LOOP;

      FOR v2
         IN (  SELECT b.item_title,
                      b.item_desc,
                      b.item_desc2,
                      b.currency_cd,
                      b.currency_rt,
                      c.capacity_cd,
                      c.section_line_cd,
                      c.section_subline_cd,
                      c.section_or_hazard_cd,
                      c.section_or_hazard_info,
                      c.property_no_type,
                      c.property_no,
                      c.location,
                      c.location_cd,
                      c.conveyance_info,
                      c.interest_on_premises,
                      c.limit_of_liability
                 FROM gipi_polbasic a,
                      gipi_item b,
                      gipi_casualty_item c,
                      giis_ca_location d
                WHERE     1 = 1
                      AND c.location_cd = d.location_cd(+)
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND NVL (a.back_stat, 5) = 2
                      AND endt_seq_no > v_endt_seq_no
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND b.item_no = p_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id(+)
                      AND b.item_no = c.item_no(+)
             ORDER BY eff_date ASC)
      LOOP
         v_item_title := NVL (v_item_title, v2.item_title);
         v_item_desc := NVL (v_item_desc, v2.item_desc);
         v_item_desc2 := NVL (v_item_desc2, v2.item_desc2);
         v_currency_cd := NVL (v_currency_cd, v2.currency_cd);
         v_currency_rate := NVL (v_currency_rate, v2.currency_rt);
         v_capacity_cd := NVL (v_capacity_cd, v2.capacity_cd);
         v_section_line_cd := NVL (v_section_line_cd, v2.section_line_cd);
         v_section_subline_cd :=
            NVL (v_section_subline_cd, v2.section_subline_cd);
         v_section_or_hazard_cd :=
            NVL (v_section_or_hazard_cd, v2.section_or_hazard_cd);
         v_section_or_hazard_info :=
            NVL (v_section_or_hazard_info, v2.section_or_hazard_info);
         v_property_no_type := NVL (v_property_no_type, v2.property_no_type);
         v_property_no := NVL (v_property_no, v2.property_no);
         v_location := NVL (v_location, v2.location);
         v_location_cd := NVL (v_location_cd, v2.location_cd);
         v_conveyance_info := NVL (v_conveyance_info, v2.conveyance_info);
         v_interest_on_premises :=
            NVL (v_interest_on_premises, v2.interest_on_premises);
         v_limit_of_liability :=
            NVL (v_limit_of_liability, v2.limit_of_liability);
      END LOOP;

      FOR c IN (SELECT currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = v_currency_cd)
      LOOP
         v_currency_desc := c.currency_desc;
         EXIT;
      END LOOP;


      FOR d IN (SELECT position
                  FROM giis_position
                 WHERE position_cd = v_capacity_cd)
      LOOP
         v_position := d.position;
         EXIT;
      END LOOP;

      CAdata.item_no := p_item_no;
      CAdata.item_title := v_item_title;
      CAdata.item_desc := v_item_desc;
      CAdata.item_desc2 := v_item_desc2;
      CAdata.currency_cd := v_currency_cd;
      CAdata.currency_rate := v_currency_rate;
      CAdata.capacity_cd := v_capacity_cd;
      CAdata.section_line_cd := v_section_line_cd;
      CAdata.section_subline_cd := v_section_subline_cd;
      CAdata.section_or_hazard_cd := v_section_or_hazard_cd;
      CAdata.section_or_hazard_info := v_section_or_hazard_info;
      CAdata.property_no_type := v_property_no_type;
      CAdata.property_no := v_property_no;
      CAdata.location := v_location;
      CAdata.location_cd := v_location_cd;
      CAdata.conveyance_info := v_conveyance_info;
      CAdata.interest_on_premises := v_interest_on_premises;
      CAdata.limit_of_liability := v_limit_of_liability;
      CAdata.currency_desc := v_currency_desc;
      CAdata.position := v_position;

      /**
       For grouped item information - irwin 9.20.2012
      */

      FOR A1
         IN (SELECT DISTINCT (b.grouped_item_no) grouped_item_no
               FROM gipi_polbasic a, gipi_grouped_items b
              WHERE     a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_Cd
                    AND a.iss_cd = p_pol_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.pol_flag IN ('1', '2', '3', 'X')
                    --AND trunc(a.eff_date) <= :control.loss_date
                    AND TRUNC (
                           DECODE (TRUNC (a.eff_date),
                                   TRUNC (a.incept_date), p_pol_eff_date,
                                   a.eff_date)) <= p_loss_date
                    AND b.item_no = p_item_no
                    AND TRUNC (
                           DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, p_expiry_date,
                                   a.endt_expiry_date)) >= p_loss_date
                    AND a.policy_id = b.policy_id)
      LOOP
         v_grp := a1.grouped_item_no;
      END LOOP;

      FOR i
         IN (  SELECT a.endt_seq_no, c.grouped_item_title, c.amount_coverage
                 FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                WHERE     1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND b.item_no = p_item_no
                      AND c.grouped_item_no = v_grp
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
             ORDER BY eff_date ASC)
      LOOP
         v_endt_seq_no2 := i.endt_seq_no;
         v_grouped_item_title := i.grouped_item_title;
         v_amount_coverage := i.amount_coverage;
      END LOOP;

      CAdata.grouped_item_title := v_grouped_item_title;
      CAdata.grouped_item_no := v_grp;
      CAdata.amount_coverage := v_amount_coverage;
   END;

   /**
   * Rey Jadlocon
   * 09-28-2011
   **/
   FUNCTION check_casualty_item_no (
      p_claim_id     gicl_casualty_dtl.claim_id%TYPE,
      p_item_no      gicl_casualty_dtl.item_no%TYPE,
      p_start_row    VARCHAR2,
      p_end_row      VARCHAR2)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE (
                                   gicl_claims_pkg.get_casualty_item_info (
                                      p_claim_id))) a)
          WHERE     rownum_ NOT BETWEEN p_start_row AND p_end_row
                AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END;

   /**
   * Rey Jadlocon
   * 09-28-2011
   **/

   FUNCTION check_existing_item (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date    gipi_polbasic.eff_date%TYPE,
      p_expiry_date     gipi_polbasic.expiry_date%TYPE,
      p_loss_date       gipi_polbasic.expiry_date%TYPE,
      p_item_no         gipi_item.item_no%TYPE)
      RETURN NUMBER
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR h
         IN (SELECT c.item_no
               FROM gipi_item c, gipi_polbasic b
              WHERE                 --:control.claim_id = :global.claim_id AND
                   p_line_cd = b.line_cd
                    AND p_subline_cd = b.subline_cd
                    AND p_pol_iss_cd = b.iss_cd
                    AND p_issue_yy = b.issue_yy
                    AND p_pol_seq_no = b.pol_seq_no
                    AND p_renew_no = b.renew_no
                    AND b.policy_id = c.policy_id
                    AND b.pol_flag IN ('1', '2', '3', 'X')
                    AND TRUNC (
                           DECODE (TRUNC (b.eff_date),
                                   TRUNC (b.incept_date), p_pol_eff_date,
                                   b.eff_date)) <= p_loss_date
                    --AND TRUNC(b.eff_date) <= :control.loss_date
                    AND TRUNC (
                           DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                   b.expiry_date, p_expiry_date,
                                   b.endt_expiry_date)) >= p_loss_date
                    AND c.item_no = p_item_no)
      LOOP
         v_exist := 1;
      END LOOP;

      RETURN v_exist;
   END;

   /**
   * Rey Jadlocon
   * 09-28-2011
   **/
   PROCEDURE validate_gicl_casualty_dtl (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date       gipi_polbasic.eff_date%TYPE,
      p_expiry_date        gipi_polbasic.expiry_date%TYPE,
      p_loss_date          gipi_polbasic.expiry_date%TYPE,
      p_incept_date        gipi_polbasic.incept_date%TYPE,
      p_item_no            gipi_item.item_no%TYPE,
      p_claim_id           gicl_casualty_dtl.claim_id%TYPE,
      p_from               VARCHAR2,
      p_to                 VARCHAR2,
      casaulty         OUT GICL_CASUALTY_DTL_PKG.gicl_casualty_dtl_cur,
      p_item_exist     OUT NUMBER,
      p_override_fl    OUT VARCHAR2,
      p_tloss_fl       OUT VARCHAR2,
      p_item_exist2    OUT VARCHAR2)
   IS
   BEGIN
      SELECT gicl_casualty_dtl_pkg.check_casualty_item_no (p_claim_id,
                                                           p_item_no,
                                                           p_from,
                                                           p_to)
        INTO p_item_exist2
        FROM DUAL;

      SELECT Giac_Validate_User_Fn (giis_users_pkg.app_user,
                                    'VL',
                                    'GICLS016')
        INTO p_override_fl
        FROM DUAL;

      SELECT GIPI_ITEM_PKG.check_existing_item (p_line_cd,
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_pol_eff_date,
                                                p_expiry_date,
                                                p_loss_date,
                                                p_item_no)
        INTO p_item_exist
        FROM DUAL;

      SELECT Check_Total_Loss_Settlement2 (0,
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
                                           p_expiry_date)
        INTO p_tloss_fl
        FROM DUAL;

      OPEN casaulty FOR
         SELECT *
           FROM TABLE (GICL_CASUALTY_DTL_PKG.get_casualty_dtl (
                          p_line_cd,
                          p_subline_cd,
                          p_pol_iss_cd,
                          p_issue_yy,
                          p_pol_seq_no,
                          p_renew_no,
                          p_item_no,
                          p_expiry_date,
                          p_loss_date,
                          p_pol_eff_date,
                          p_claim_id));
   END;

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   PROCEDURE extract_casualty_data (
      p_line_cd             gipi_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_polbasic.subline_cd%TYPE,
      p_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_polbasic.renew_no%TYPE,
      p_item_no             gipi_item.item_no%TYPE,
      p_claim_id            gicl_claims.claim_id%TYPE,
      casualty_dtl   IN OUT get_casualty_item_info_type)
   IS
      v_item_title               gicl_casualty_dtl.item_title%TYPE;
      v_item_desc                gipi_item.item_desc%TYPE;
      v_item_desc2               gipi_item.item_desc2%TYPE;
      v_grouped_item_no          gicl_casualty_dtl.grouped_item_title%TYPE;
      v_grouped_item_title       gicl_casualty_dtl.grouped_item_title%TYPE;
      v_currency_cd              gicl_casualty_dtl.currency_cd%TYPE;
      v_currency_desc            giis_currency.currency_desc%TYPE;
      v_property_no_type         gicl_casualty_dtl.property_no_type%TYPE;
      v_property_no              gicl_casualty_dtl.property_no%TYPE;
      v_currency_rt              giis_currency.currency_rt%TYPE;
      v_location                 gicl_casualty_dtl.location%TYPE;
      v_section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_info%TYPE;
      v_section_or_hazard_info   gicl_casualty_dtl.section_or_hazard_info%TYPE;
      v_conveyance_info          gicl_casualty_dtl.conveyance_info%TYPE;
      v_interest_on_premises     gicl_casualty_dtl.interest_on_premises%TYPE;
      v_amount_coverage          gicl_casualty_dtl.amount_coverage%TYPE;
      v_limit_of_liability       gicl_casualty_dtl.limit_of_liability%TYPE;
      v_capacity_cd              gicl_casualty_dtl.capacity_cd%TYPE;
   BEGIN
      FOR c1
         IN (SELECT b.item_title,
                    b.item_desc,
                    b.item_desc2,
                    f.grouped_item_no,
                    f.grouped_item_title,
                    b.currency_cd,
                    d.currency_desc,
                    c.property_no_type,
                    c.property_no,
                    b.currency_rt,
                    c.location,
                    c.section_or_hazard_cd,
                    c.section_or_hazard_info,
                    c.conveyance_info,
                    c.interest_on_premises,
                    f.amount_coverage,
                    c.limit_of_liability,
                    c.capacity_cd
               FROM gipi_polbasic a,
                    gipi_item b,
                    gipi_casualty_item c,
                    giis_currency d,
                    gicl_casualty_dtl f
              WHERE     b.policy_id = c.policy_id
                    AND a.policy_id = b.policy_id
                    AND b.item_no = c.item_no
                    AND b.currency_cd = d.main_currency_cd
                    AND a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND f.claim_id = p_claim_id
                    AND a.renew_no = p_renew_no
                    AND b.item_no = p_item_no)
      LOOP
         v_item_title := c1.item_title;
         v_item_desc := c1.item_desc;
         v_item_desc2 := c1.item_desc2;
         v_grouped_item_no := c1.grouped_item_title;
         v_grouped_item_title := c1.grouped_item_title;
         v_currency_cd := c1.currency_cd;
         v_currency_desc := c1.currency_desc;
         v_property_no_type := c1.property_no_type;
         v_property_no := c1.property_no;
         v_currency_rt := c1.currency_rt;
         v_location := c1.location;
         v_section_or_hazard_cd := c1.section_or_hazard_info;
         v_section_or_hazard_info := c1.section_or_hazard_info;
         v_conveyance_info := c1.conveyance_info;
         v_interest_on_premises := c1.interest_on_premises;
         v_amount_coverage := c1.amount_coverage;
         v_limit_of_liability := c1.limit_of_liability;
         v_capacity_cd := c1.capacity_cd;
      END LOOP;

      casualty_dtl.item_title := v_item_title;
      casualty_dtl.item_desc := v_item_desc;
      casualty_dtl.item_desc2 := v_item_desc2;
      casualty_dtl.grouped_item_no := v_grouped_item_title;
      casualty_dtl.grouped_item_title := v_grouped_item_title;
      casualty_dtl.currency_cd := v_currency_cd;
      casualty_dtl.currency_desc := v_currency_desc;
      casualty_dtl.property_no_type := v_property_no_type;
      casualty_dtl.property_no := v_property_no;
      casualty_dtl.currency_rate := v_currency_rt;
      casualty_dtl.location := v_location;
      casualty_dtl.section_or_hazard_cd := v_section_or_hazard_info;
      casualty_dtl.section_or_hazard_info := v_section_or_hazard_info;
      casualty_dtl.conveyance_info := v_conveyance_info;
      casualty_dtl.interest_on_premises := v_interest_on_premises;
      casualty_dtl.amount_coverage := v_amount_coverage;
      casualty_dtl.limit_of_liability := v_limit_of_liability;
      casualty_dtl.capacity_cd := v_capacity_cd;
   END;

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   FUNCTION get_casualty_dtl (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_item_no         gipi_item.item_no%TYPE,
      p_expiry_date     GIPI_POLBASIC.EXPIRY_DATE%TYPE,
      p_loss_date       GICL_CASUALTY_DTL.LOSS_DATE%TYPE,
      p_pol_eff_date    GIPI_POLBASIC.EFF_DATE%TYPE,
      p_claim_id        gicl_claims.claim_id%TYPE)
      RETURN get_casualty_item_info_tab
      PIPELINED
   IS
      casualty   get_casualty_item_info_type;
   BEGIN
      GICL_CASUALTY_DTL_PKG.extract_latest_CAdata (p_line_cd,
                                                   p_subline_cd,
                                                   p_iss_cd,
                                                   p_issue_yy,
                                                   p_pol_seq_no,
                                                   p_renew_no,
                                                   p_expiry_date,
                                                   p_loss_date,
                                                   p_pol_eff_date,
                                                   p_item_no,
                                                   casualty);
      PIPE ROW (casualty);
      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   FUNCTION get_personnel (
      p_item_no        gicl_casualty_personnel.item_no%TYPE,
      p_capacity_cd    gicl_casualty_personnel.capacity_cd%TYPE)
      RETURN personnel_list_tab
      PIPELINED
   IS
      v_personnel_list   personnel_list_type;
   BEGIN
      FOR i
         IN (SELECT DISTINCT a.personnel_no,
                             a.name,
                             a.capacity_cd,
                             a.amount_covered,
                             b.position,
                             b.position_cd
               FROM gicl_casualty_personnel a, giis_position b
              WHERE     a.capacity_cd = b.position_cd
                    AND a.capacity_cd = p_capacity_cd
                    AND a.item_no = p_item_no)
      LOOP
         v_personnel_list.personnel_no := i.personnel_no;
         v_personnel_list.name := i.name;
         v_personnel_list.capacity_cd := i.capacity_cd;
         v_personnel_list.amount_covered := i.amount_covered;
         v_personnel_list.position := i.position;
         v_personnel_list.position_cd := i.position_cd;
         PIPE ROW (v_personnel_list);
      END LOOP;
   END;

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   PROCEDURE set_gicl_casualty_dtl (
      p_amount_coverage           gicl_casualty_dtl.amount_coverage%TYPE,
      p_capacity_cd               gicl_casualty_dtl.capacity_cd%TYPE,
      p_claim_id                  gicl_casualty_dtl.claim_id%TYPE,
      p_conveyance_info           gicl_casualty_dtl.conveyance_info%TYPE,
      p_cpi_branch_cd             gicl_casualty_dtl.cpi_branch_cd%TYPE,
      p_cpi_rec_no                gicl_casualty_dtl.cpi_rec_no%TYPE,
      p_currency_cd               gicl_casualty_dtl.currency_cd%TYPE,
      p_loss_date                 gicl_casualty_dtl.loss_date%TYPE,
      p_currency_rate             gicl_casualty_dtl.currency_rate%TYPE,
      p_grouped_item_no           gicl_casualty_dtl.grouped_item_no%TYPE,
      p_grouped_item_title        gicl_casualty_dtl.grouped_item_title%TYPE,
      p_interest_on_premises      gicl_casualty_dtl.interest_on_premises%TYPE,
      p_item_no                   gicl_casualty_Dtl.item_no%TYPE,
      p_item_title                gicl_casualty_dtl.item_title%TYPE,
      p_last_update               gicl_casualty_dtl.last_update%TYPE,
      p_limit_of_liability        gicl_casualty_dtl.limit_of_liability%TYPE,
      p_location                  gicl_casualty_dtl.location%TYPE,
      p_location_cd               gicl_casualty_dtl.location_cd%TYPE,
      p_property_no               gicl_casualty_dtl.property_no%TYPE,
      p_property_no_type          gicl_casualty_dtl.property_no_type%TYPE,
      p_section_line_cd           gicl_casualty_dtl.section_line_cd%TYPE,
      p_section_or_hazard_cd      gicl_casualty_dtl.section_or_hazard_cd%TYPE,
      p_section_or_hazard_info    gicl_casualty_dtl.section_or_hazard_info%TYPE,
      p_section_subline_cd        gicl_casualty_dtl.section_subline_cd%TYPE,
      p_user_id                   gicl_casualty_dtl.user_id%TYPE)
   IS
      v_loss_date   gicl_claims.loss_date%TYPE;
   BEGIN
      FOR date IN (SELECT dsp_loss_date
                     FROM gicl_claims
                    WHERE claim_id = p_claim_id)
      LOOP
         v_loss_date := date.dsp_loss_date;
      END LOOP;

      MERGE INTO gicl_casualty_dtl
           USING DUAL
              ON (claim_id = p_claim_id AND item_no = p_item_no)
      WHEN NOT MATCHED
      THEN
         INSERT     (amount_coverage,
                     capacity_cd,
                     claim_id,
                     conveyance_info,
                     cpi_branch_cd,
                     cpi_rec_no,
                     currency_cd,
                     loss_date,
                     currency_rate,
                     grouped_item_no,
                     grouped_item_title,
                     interest_on_premises,
                     item_no,
                     item_title,
                     last_update,
                     limit_of_liability,
                     location,
                     location_cd,
                     property_no,
                     property_no_type,
                     section_line_cd,
                     section_or_hazard_cd,
                     section_or_hazard_info,
                     section_subline_cd,
                     user_id)
             VALUES (p_amount_coverage,
                     p_capacity_cd,
                     p_claim_id,
                     p_conveyance_info,
                     p_cpi_branch_cd,
                     p_cpi_rec_no,
                     p_currency_cd,
                     v_loss_date,
                     p_currency_rate,
                     p_grouped_item_no,
                     p_grouped_item_title,
                     p_interest_on_premises,
                     p_item_no,
                     p_item_title,
                     p_last_update,
                     p_limit_of_liability,
                     p_location,
                     p_location_cd,
                     p_property_no,
                     p_property_no_type,
                     p_section_line_cd,
                     p_section_or_hazard_cd,
                     p_section_or_hazard_info,
                     p_section_subline_cd,
                     p_user_id)
      WHEN MATCHED
      THEN
         UPDATE SET amount_coverage = p_amount_coverage,
                    capacity_cd = p_capacity_cd,
                    conveyance_info = p_conveyance_info,
                    cpi_branch_cd = p_cpi_branch_cd,
                    cpi_rec_no = p_cpi_rec_no,
                    currency_cd = p_currency_cd,
                    currency_rate = p_currency_rate,
                    grouped_item_no = p_grouped_item_no,
                    grouped_item_title = p_grouped_item_title,
                    interest_on_premises = p_interest_on_premises,
                    item_title = p_item_title,
                    last_update = p_last_update,
                    limit_of_liability = p_limit_of_liability,
                    location = p_location,
                    location_cd = p_location_cd,
                    property_no = p_property_no,
                    property_no_type = p_property_no_type,
                    section_line_cd = p_section_line_cd,
                    section_or_hazard_cd = p_section_or_hazard_cd,
                    section_or_hazard_info = p_section_or_hazard_info,
                    section_subline_cd = p_section_subline_cd,
                    user_id = p_user_id,
                    loss_date = v_loss_date;
   END;

   /**
   * Rey Jadlocon
   * 10-03-2011
   **/

   FUNCTION get_position (p_position_cd giis_position.position_cd%TYPE)
      RETURN position_tab
      PIPELINED
   IS
      v_position_desc   position_type;
   BEGIN
      FOR i IN (SELECT position, position_cd
                  FROM giis_position
                 WHERE position_cd = p_position_cd)
      LOOP
         v_position_desc.position := i.position;
         v_position_desc.position_cd := i.position_cd;
         PIPE ROW (v_position_desc);
      END LOOP;

      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 10-03-2011
   **/

   PROCEDURE extract_latest_personel (
      p_line_cd               gipi_polbasic.line_cd%TYPE,
      p_subline_cd            gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy              gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no              gipi_polbasic.renew_no%TYPE,
      p_item_no               gipi_item.item_no%TYPE,
      p_claim_id              gicl_claims.claim_id%TYPE,
      p_personnel_no          gicl_casualty_personnel.personnel_no%TYPE,
      p_loss_date             gicl_casualty_dtl.loss_date%TYPE,
      p_expiry_date           gicl_casualty_dtl.loss_date%TYPE,
      p_pol_eff_date          gicl_casualty_dtl.loss_date%TYPE,
      p_capacity_cd           gicl_casualty_dtl.capacity_cd%TYPE,
      personnel_dtl    IN OUT get_personnel_dtl_type)
   IS
      v_endt_seq_no      GIPI_POLBASIC.endt_seq_no%TYPE;
      v_name             GICL_CASUALTY_PERSONNEL.name%TYPE;
      v_capacity_cd      GICL_CASUALTY_PERSONNEL.capacity_cd%TYPE;
      v_include_tag      GICL_CASUALTY_PERSONNEL.include_tag%TYPE;
      v_amount_covered   GICL_CASUALTY_PERSONNEL.amount_covered%TYPE;
   BEGIN
      FOR v1
         IN (  SELECT a.endt_seq_no,
                      c.name,
                      c.capacity_cd,
                      c.include_tag,
                      c.amount_covered
                 FROM gipi_polbasic a, gipi_item b, gipi_casualty_personnel c
                WHERE     1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND b.item_no = p_item_no
                      AND c.personnel_no = p_personnel_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
             ORDER BY eff_date ASC)
      LOOP
         v_endt_seq_no := v1.endt_seq_no;
         v_name := v1.name;
         v_capacity_cd := v1.capacity_cd;
         v_include_tag := v1.include_tag;
         v_amount_covered := v1.amount_covered;
      END LOOP;

      FOR v2
         IN (  SELECT c.name,
                      c.capacity_cd,
                      c.include_tag,
                      c.amount_covered
                 FROM gipi_polbasic a, gipi_item b, gipi_casualty_personnel c
                WHERE     1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND NVL (a.back_stat, 5) = 2
                      AND endt_seq_no > v_endt_seq_no
                      AND TRUNC (
                             DECODE (TRUNC (a.eff_date),
                                     TRUNC (a.incept_date), p_pol_eff_date,
                                     a.eff_date)) <= p_loss_date
                      AND TRUNC (
                             DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,
                                     a.endt_expiry_date)) >= p_loss_date
                      AND b.item_no = p_item_no
                      AND c.personnel_no = p_personnel_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
             ORDER BY eff_date ASC)
      LOOP
         v_name := NVL (v2.name, v_name);
         v_capacity_cd := NVL (v2.capacity_cd, v_capacity_cd);
         v_include_tag := NVL (v2.include_tag, v_include_tag);
         v_amount_covered := NVL (v2.amount_covered, v_amount_covered);
      END LOOP;

      personnel_dtl.name := v_name;
      personnel_dtl.capacity_cd := v_capacity_cd;
      personnel_dtl.include_tag := v_include_tag;
      personnel_dtl.amount_covered := v_amount_covered;

      FOR pos IN (SELECT position
                    FROM giis_position
                   WHERE position_cd = v_capacity_cd)
      LOOP
         personnel_dtl.position := pos.position;
      END LOOP;

      personnel_dtl.user_id := giis_users_pkg.app_user;
      personnel_dtl.last_update := SYSDATE;
   END;

   /**
   * Rey Jadlocon
   * 10-04-2011
   **/
   FUNCTION get_personnel_list (
      p_claim_id        gicl_casualty_dtl.claim_id%TYPE,
      p_item_no         gicl_casualty_dtl.item_no%TYPE,
      p_capacity_cd     gicl_casualty_dtl.capacity_cd%TYPE,
      p_personnel_no    gicl_casualty_personnel.personnel_no%TYPE)
      RETURN personnel_dtl_tab
      PIPELINED
   IS
      personnel        get_personnel_dtl_type;
      v_line_cd        gipi_polbasic.line_cd%TYPE;
      v_subline_cd     gipi_polbasic.subline_cd%TYPE;
      v_pol_iss_cd     gipi_polbasic.iss_cd%TYPE;
      v_issue_yy       gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no       gipi_polbasic.renew_no%TYPE;
      v_item_no        gipi_item.item_no%TYPE;
      v_claim_id       gicl_claims.claim_id%TYPE;
      v_loss_date      gicl_casualty_dtl.loss_date%TYPE;
      v_expiry_date    gicl_casualty_dtl.loss_date%TYPE;
      v_pol_eff_date   gicl_casualty_dtl.loss_date%TYPE;
   BEGIN
      FOR i IN (SELECT line_cd,
                       subline_cd,
                       pol_iss_cd,
                       issue_yy,
                       pol_seq_no,
                       renew_no,
                       loss_date,
                       pol_eff_date,
                       expiry_date,
                       claim_id
                  FROM gicl_claims
                 WHERE claim_id = p_claim_id)
      LOOP
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_pol_iss_cd := i.pol_iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
         v_claim_id := i.claim_id;
         v_loss_date := i.loss_date;
         v_expiry_date := i.expiry_date;
         v_pol_eff_date := i.pol_eff_date;
      END LOOP;

      GICL_CASUALTY_DTL_PKG.extract_latest_personel (v_line_cd,
                                                     v_subline_cd,
                                                     v_pol_iss_cd,
                                                     v_issue_yy,
                                                     v_pol_seq_no,
                                                     v_renew_no,
                                                     p_item_no,
                                                     p_claim_id,
                                                     p_personnel_no,
                                                     v_loss_date,
                                                     v_expiry_date,
                                                     v_pol_eff_date,
                                                     p_capacity_cd,
                                                     personnel);
      PIPE ROW (personnel);
      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 10-13-2011
   **/

   FUNCTION get_gicl_casualty_dtl (
      p_claim_id gicl_casualty_dtl.claim_id%TYPE)
      RETURN gicl_casualty_dtl_tab
      PIPELINED
   IS
      v_list    gicl_casualty_dtl_type;
      v_exist   VARCHAR2 (1);
   BEGIN
      FOR rec IN (  SELECT DISTINCT a.claim_id,
                                    a.item_no,
                                    a.currency_cd,
                                    a.user_id,
                                    a.last_update,
                                    a.loss_date,
                                    a.item_title,
                                    a.section_line_cd,
                                    a.section_subline_cd,
                                    a.section_or_hazard_cd,
                                    a.capacity_cd,
                                    a.property_no_type,
                                    a.property_no,
                                    a.location,
                                    a.conveyance_info,
                                    a.interest_on_premises,
                                    a.limit_of_liability,
                                    a.section_or_hazard_info,
                                    a.grouped_item_no,
                                    a.grouped_item_title,
                                    a.amount_coverage,
                                    a.cpi_rec_no,
                                    a.cpi_branch_cd,
                                    a.currency_rate,
                                    a.location_cd
                      FROM gicl_casualty_dtl a
                     WHERE a.claim_id = p_claim_id
                  ORDER BY 2 ASC)
      LOOP
         v_list.claim_id := rec.claim_id;
         v_list.item_no := rec.item_no;
         v_list.currency_cd := rec.currency_cd;
         v_list.user_id := rec.user_id;
         v_list.last_update := rec.last_update;
         v_list.loss_date := rec.loss_date;
         v_list.item_title := rec.item_title;
         v_list.section_line_cd := rec.section_line_cd;
         v_list.section_subline_cd := rec.section_subline_cd;
         v_list.section_or_hazard_cd := rec.section_or_hazard_cd;
         v_list.capacity_cd := rec.capacity_cd;
         v_list.property_no_type := rec.property_no_type;
         v_list.property_no := rec.property_no;
         v_list.location := rec.location;
         v_list.conveyance_info := rec.conveyance_info;
         v_list.interest_on_premises := rec.interest_on_premises;
         v_list.limit_of_liability := rec.limit_of_liability;
         v_list.section_or_hazard_info := rec.section_or_hazard_info;
         v_list.grouped_item_no := rec.grouped_item_no;
         v_list.grouped_item_title := rec.grouped_item_title;
         v_list.amount_coverage := rec.amount_coverage;
         v_list.cpi_rec_no := rec.cpi_rec_no;
         v_list.cpi_branch_cd := rec.cpi_branch_cd;
         v_list.currency_rate := rec.currency_rate;
         v_list.location_cd := rec.location_cd;

         BEGIN
            SELECT item_desc, item_desc2
              INTO v_list.item_desc, v_list.item_desc2
              FROM gicl_clm_item
             WHERE     1 = 1
                   AND claim_id = p_claim_id
                   AND item_no = v_list.item_no
                   --AND grouped_item_no = 0; -- replaced by: Nica 05.24.2013
                   AND grouped_item_no = NVL(v_list.grouped_item_no, 0);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.item_desc := NULL;
               v_list.item_desc2 := NULL;
         END;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency
                    WHERE main_currency_cd = v_list.currency_cd)
         LOOP
            v_list.currency_desc := c.currency_desc;
         END LOOP;

         FOR pos IN (SELECT position
                       FROM giis_position
                      WHERE position_cd = rec.capacity_cd)
         LOOP
            v_list.position := pos.position;
         END LOOP;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist (
                   v_list.item_no,
                   v_list.claim_id)
           INTO v_list.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (v_list.item_no,
                                                             v_list.claim_id)
           INTO v_list.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve (
            v_list.item_no,
            v_list.claim_id,
            --0,                              --belle grouped item no 02.13.2012
            NVL(v_list.grouped_item_no, 0), -- replaced by: Nica 5.24.2013 - to consider grouped_item_no
            v_list.gicl_item_peril_msg);

         PIPE ROW (v_list);
      END LOOP;
   END;

   /**
   * Rey Jadlocon
   * 10-14-2011
   **/

   PROCEDURE del_gicl_casualty_dtl (
      p_claim_id    gicl_casualty_dtl.claim_id%TYPE,
      p_item_no     gicl_casualty_dtl.item_no%TYPE)
   IS
   BEGIN
      DELETE FROM gicl_casualty_dtl
            WHERE claim_id = p_claim_id AND item_no = p_item_no;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 10.21.2011
   **  Reference By  : (GICLS010 - Basic Information)
   **  Description   : check if gicl_casualty_dtl exist
   */
   FUNCTION get_gicl_casualty_dtl_exist (
      p_claim_id gicl_casualty_dtl.claim_id%TYPE)
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_casualty_dtl
                 WHERE claim_id = p_claim_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exists;
   END;

   /**
   * Rey Jadlocon
   * 04-20-2012
   **/

   FUNCTION get_group_lov (p_line_cd         VARCHAR2,
                           p_subline_cd      VARCHAR2,
                           p_pol_iss_cd      VARCHAR2,
                           p_issue_yy        NUMBER,
                           p_pol_seq_no      NUMBER,
                           p_renew_no        NUMBER,
                           p_pol_eff_date    DATE,
                           p_loss_date       DATE,
                           p_item_no         NUMBER,
                           p_expiry_date     DATE)
      RETURN group_list_tab
      PIPELINED
   IS
      group_list   group_list_type;
   BEGIN
      FOR i
         IN (SELECT DISTINCT (b.grouped_item_no) grouped_item_no
               FROM gipi_polbasic a, gipi_grouped_items b
              WHERE     a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_pol_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.pol_flag IN ('1', '2', '3', 'X')
                    AND TRUNC (
                           DECODE (TRUNC (a.eff_date),
                                   TRUNC (a.incept_date), p_pol_eff_date,
                                   a.eff_date)) <= p_loss_date
                    AND b.item_no = p_item_no
                    AND TRUNC (
                           DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, p_expiry_date,
                                   a.endt_expiry_date)) >= p_loss_date
                    AND a.policy_id = b.policy_id)
      LOOP
         group_list.group_no := i.grouped_item_no;

         PIPE ROW (group_list);
      END LOOP;
   END;

   /**
    validate and get group item information
 9.20.2012 - irwin
   */

   PROCEDURE validate_Group_ItemNo (
      p_line_cd                gipi_polbasic.line_cd%TYPE,
      p_subline_cd             gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy               gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no               gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date           gipi_polbasic.eff_date%TYPE,
      p_expiry_date            gipi_polbasic.expiry_date%TYPE,
      p_loss_date              gipi_polbasic.expiry_date%TYPE,
      p_item_no                gipi_item.item_no%TYPE,
      p_grouped_item_no        NUMBER,
      grouped_item_title   OUT gicl_casualty_dtl.grouped_item_title%TYPE,
      amount_coverage      OUT gicl_casualty_dtl.amount_coverage%TYPE,
      exist                OUT VARCHAR2)
   IS
      v_endt_seq_no          GIPI_POLBASIC.endt_seq_no%TYPE;
      v_grouped_item_title   GICL_CASUALTY_DTL.grouped_item_title%TYPE;
      v_amount_coverage      GICL_CASUALTY_DTL.amount_coverage%TYPE;
   BEGIN
      exist := 'N';

      FOR A1
         IN (SELECT DISTINCT (b.grouped_item_no) grouped_item_no
               FROM gipi_polbasic a, gipi_grouped_items b
              WHERE     a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_pol_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.pol_flag IN ('1', '2', '3', 'X')
                    --  AND TRUNC(a.eff_date)   <= :control.loss_date
                    AND TRUNC (
                           DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, p_expiry_date,
                                   a.endt_expiry_date)) >= p_loss_date
                    AND TRUNC (
                           DECODE (TRUNC (a.eff_date),
                                   TRUNC (a.incept_date), p_pol_eff_date,
                                   a.eff_date)) <= p_loss_date
                    AND a.policy_id = b.policy_id
                    AND b.item_no = p_item_no
                    AND b.grouped_item_no = p_grouped_item_no)
      LOOP
         exist := 'Y';
         EXIT;
      END LOOP;

      -- EXTRACT_LATEST_GROUPED procedure
      IF exist = 'Y'
      THEN
         FOR v1
            IN (  SELECT a.endt_seq_no, c.grouped_item_title, c.amount_coverage
                    FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                   WHERE     1 = 1
                         AND a.line_cd = p_line_cd
                         AND a.subline_cd = p_subline_cd
                         AND a.iss_cd = p_pol_iss_cd
                         AND a.issue_yy = p_issue_yy
                         AND a.pol_seq_no = p_pol_seq_no
                         AND a.renew_no = p_renew_no
                         AND a.pol_flag IN ('1', '2', '3', 'X')
                         --AND TRUNC(a.eff_date)   <= :control.loss_date
                         AND TRUNC (
                                DECODE (
                                   NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, p_expiry_date,
                                   a.endt_expiry_date)) >= p_loss_date
                         AND TRUNC (
                                DECODE (TRUNC (a.eff_date),
                                        TRUNC (a.incept_date), p_pol_eff_date,
                                        a.eff_date)) <= p_loss_date
                         AND b.item_no = p_item_no
                         AND c.grouped_item_no = p_grouped_item_no
                         AND a.policy_id = b.policy_id
                         AND b.policy_id = c.policy_id
                         AND b.item_no = c.item_no
                ORDER BY eff_date ASC)
         LOOP
            v_endt_seq_no := v1.endt_seq_no;
            v_grouped_item_title := v1.grouped_item_title;
            v_amount_coverage := v1.amount_coverage;
         END LOOP;

         FOR v2
            IN (  SELECT c.grouped_item_title, c.amount_coverage
                    FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                   WHERE     1 = 1
                         AND a.line_cd = p_line_cd
                         AND a.subline_cd = p_subline_cd
                         AND a.iss_cd = p_pol_iss_cd
                         AND a.issue_yy = p_issue_yy
                         AND a.pol_seq_no = p_pol_seq_no
                         AND a.renew_no = p_renew_no
                         AND a.pol_flag IN ('1', '2', '3', 'X')
                         AND NVL (a.back_stat, 5) = 2
                         AND endt_seq_no > v_endt_seq_no
                         --                 AND TRUNC(a.eff_date)   <= :control.loss_date
                         AND TRUNC (
                                DECODE (
                                   NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, p_expiry_date,
                                   a.endt_expiry_date)) >= p_loss_date
                         AND TRUNC (
                                DECODE (TRUNC (a.eff_date),
                                        TRUNC (a.incept_date), p_pol_eff_date,
                                        a.eff_date)) <= p_loss_date
                         AND b.item_no = p_item_no
                         AND c.grouped_item_no = p_grouped_item_no
                         AND a.policy_id = b.policy_id
                         AND b.policy_id = c.policy_id
                         AND b.item_no = c.item_no
                ORDER BY eff_date ASC)
         LOOP
            v_grouped_item_title :=
               NVL (v2.grouped_item_title, v_grouped_item_title);
            v_amount_coverage := NVL (v2.amount_coverage, v_amount_coverage);
         END LOOP;

         grouped_item_title := v_grouped_item_title;
         amount_coverage := v_amount_coverage;
      END IF;
   END;

   PROCEDURE validate_personnel_no (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date       gipi_polbasic.eff_date%TYPE,
      p_expiry_date        gipi_polbasic.expiry_date%TYPE,
      p_loss_date          gipi_polbasic.expiry_date%TYPE,
      p_item_no            gipi_item.item_no%TYPE,
      p_claim_id           gicl_claims.claim_id%TYPE,
      p_personnel_no       gicl_casualty_personnel.capacity_cd%TYPE,
      name             OUT GICL_CASUALTY_PERSONNEL.name%TYPE,
      capacity_cd      OUT VARCHAR2,
      amount_covered   OUT GICL_CASUALTY_PERSONNEL.amount_covered%TYPE,
      position         OUT giis_position.POSITION%TYPE)
   IS
      v_exist            VARCHAR2 (1) := 'N';
      v_cnt              NUMBER := 1;
      v_endt_seq_no      GIPI_POLBASIC.endt_seq_no%TYPE;
      v_name             GICL_CASUALTY_PERSONNEL.name%TYPE;
      v_capacity_cd      GICL_CASUALTY_PERSONNEL.capacity_cd%TYPE;
      v_include_tag      GICL_CASUALTY_PERSONNEL.include_tag%TYPE;
      v_amount_covered   GICL_CASUALTY_PERSONNEL.amount_covered%TYPE;
   BEGIN
      FOR v
         IN (SELECT '1'
               FROM gicl_casualty_personnel
              WHERE     1 = 1
                    AND claim_id = p_claim_id
                    AND item_no = p_item_no
                    AND personnel_no = p_persoNnel_no)
      LOOP
         v_exist := 'Y';
         v_cnt := v_cnt + 1;
      END LOOP;

      IF v_exist = 'Y' AND v_cnt > 1
      THEN
         raise_application_error (
            -20001,
            'Geniisys Exception#I#Personnel no already exists. Check List of Values for valid records.');
      END IF;

      FOR A1
         IN (SELECT DISTINCT (c.personnel_no) personnel_no
               FROM gipi_polbasic a, gipi_item b, gipi_casualty_personnel c
              WHERE     a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_pol_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.pol_flag IN ('1', '2', '3', 'X')
                    AND TRUNC (a.eff_date) <= p_loss_date
                    AND TRUNC (
                           DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, p_expiry_date,
                                   a.endt_expiry_date)) >= p_loss_date
                    AND a.policy_id = b.policy_id
                    AND b.policy_id = c.policy_id
                    AND b.item_no = c.item_no
                    AND c.personnel_no = p_personnel_no
                    AND b.item_no = p_item_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      IF v_exist = 'N'
      THEN
         RAISE_APPLICATION_ERROR (
            '-20001',
            'Geniisys Exception#I#Invalid Personnel No. entered. Press check the list of valid values.');
      ELSIF v_exist = 'Y'
      THEN
         FOR v1
            IN (  SELECT a.endt_seq_no,
                         c.name,
                         c.capacity_cd,
                         c.include_tag,
                         c.amount_covered
                    FROM gipi_polbasic a,
                         gipi_item b,
                         gipi_casualty_personnel c
                   WHERE     1 = 1
                         AND a.line_cd = P_line_cd
                         AND a.subline_cd = P_subline_cd
                         AND a.iss_cd = P_pol_iss_cd
                         AND a.issue_yy = P_issue_yy
                         AND a.pol_seq_no = P_pol_seq_no
                         AND a.renew_no = P_renew_no
                         AND a.pol_flag IN ('1', '2', '3', 'X')
                         --                 AND TRUNC(a.eff_date)   <= :control.loss_date
                         AND TRUNC (
                                DECODE (TRUNC (a.eff_date),
                                        TRUNC (a.incept_date), P_pol_eff_date,
                                        a.eff_date)) <= P_loss_date
                         AND TRUNC (
                                DECODE (
                                   NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, P_expiry_date,
                                   a.endt_expiry_date)) >= P_loss_date
                         AND b.item_no = P_item_no
                         AND c.personnel_no = P_personnel_no
                         AND a.policy_id = b.policy_id
                         AND b.policy_id = c.policy_id
                         AND b.item_no = c.item_no
                ORDER BY eff_date ASC)
         LOOP
            v_endt_seq_no := v1.endt_seq_no;
            v_name := v1.name;
            v_capacity_cd := v1.capacity_cd;
            v_include_tag := v1.include_tag;
            v_amount_covered := v1.amount_covered;
         END LOOP;

         FOR v2
            IN (  SELECT c.name,
                         c.capacity_cd,
                         c.include_tag,
                         c.amount_covered
                    FROM gipi_polbasic a,
                         gipi_item b,
                         gipi_casualty_personnel c
                   WHERE     1 = 1
                         AND a.line_cd = P_line_cd
                         AND a.subline_cd = P_subline_cd
                         AND a.iss_cd = P_pol_iss_cd
                         AND a.issue_yy = P_issue_yy
                         AND a.pol_seq_no = P_pol_seq_no
                         AND a.renew_no = P_renew_no
                         AND a.pol_flag IN ('1', '2', '3', 'X')
                         AND NVL (a.back_stat, 5) = 2
                         AND endt_seq_no > v_endt_seq_no
                         --                 AND TRUNC(a.eff_date)   <= :control.loss_date
                         AND TRUNC (
                                DECODE (TRUNC (a.eff_date),
                                        TRUNC (a.incept_date), P_pol_eff_date,
                                        a.eff_date)) <= P_loss_date
                         AND TRUNC (
                                DECODE (
                                   NVL (a.endt_expiry_date, a.expiry_date),
                                   a.expiry_date, P_expiry_date,
                                   a.endt_expiry_date)) >= P_loss_date
                         AND b.item_no = P_item_no
                         AND c.personnel_no = P_personnel_no
                         AND a.policy_id = b.policy_id
                         AND b.policy_id = c.policy_id
                         AND b.item_no = c.item_no
                ORDER BY eff_date ASC)
         LOOP
            v_name := NVL (v2.name, v_name);
            v_capacity_cd := NVL (v2.capacity_cd, v_capacity_cd);
            v_include_tag := NVL (v2.include_tag, v_include_tag);
            v_amount_covered := NVL (v2.amount_covered, v_amount_covered);
         END LOOP;

         name := v_name;
         capacity_cd := TO_CHAR(v_capacity_cd);
         --  :c017c.include_tag := v_include_tag;
         amount_covered := v_amount_covered;

         FOR pos IN (SELECT position
                       FROM giis_position
                      WHERE position_cd = capacity_cd)
         LOOP
            position := pos.position;
            EXIT;
         END LOOP;
      END IF;
   END;
   
   /**
   * bonok :: 05.15.2013 :: for GICLS260
   **/
   FUNCTION get_casualty_dtl_gicls260 (
      p_claim_id gicl_casualty_dtl.claim_id%TYPE
   ) RETURN gicl_casualty_gicls260_tab
      PIPELINED
   IS
      v_list    gicl_casualty_gicls260_type;
      v_exist   VARCHAR2 (1);
      v_chk     NUMBER := 0;
   BEGIN
      FOR rec IN (  SELECT DISTINCT a.claim_id,
                                    a.item_no,
                                    a.currency_cd,
                                    a.user_id,
                                    a.last_update,
                                    a.loss_date,
                                    a.item_title,
                                    a.section_line_cd,
                                    a.section_subline_cd,
                                    a.section_or_hazard_cd,
                                    a.capacity_cd,
                                    a.property_no_type,
                                    a.property_no,
                                    a.location,
                                    a.conveyance_info,
                                    a.interest_on_premises,
                                    a.limit_of_liability,
                                    a.section_or_hazard_info,
                                    a.grouped_item_no,
                                    a.grouped_item_title,
                                    a.amount_coverage,
                                    a.cpi_rec_no,
                                    a.cpi_branch_cd,
                                    a.currency_rate,
                                    a.location_cd
                      FROM gicl_casualty_dtl a
                     WHERE a.claim_id = p_claim_id
                  ORDER BY 2 ASC)
      LOOP
         v_list.claim_id := rec.claim_id;
         v_list.item_no := rec.item_no;
         v_list.currency_cd := rec.currency_cd;
         v_list.user_id := rec.user_id;
         v_list.last_update := rec.last_update;
         v_list.loss_date := rec.loss_date;
         v_list.item_title := rec.item_title;
         v_list.section_line_cd := rec.section_line_cd;
         v_list.section_subline_cd := rec.section_subline_cd;
         v_list.section_or_hazard_cd := rec.section_or_hazard_cd;
         v_list.capacity_cd := rec.capacity_cd;
         v_list.property_no_type := rec.property_no_type;
         v_list.property_no := rec.property_no;
         v_list.location := rec.location;
         v_list.conveyance_info := rec.conveyance_info;
         v_list.interest_on_premises := rec.interest_on_premises;
         v_list.limit_of_liability := rec.limit_of_liability;
         v_list.section_or_hazard_info := rec.section_or_hazard_info;
         v_list.grouped_item_no := rec.grouped_item_no;
         v_list.grouped_item_title := rec.grouped_item_title;
         v_list.amount_coverage := rec.amount_coverage;
         v_list.cpi_rec_no := rec.cpi_rec_no;
         v_list.cpi_branch_cd := rec.cpi_branch_cd;
         v_list.currency_rate := rec.currency_rate;
         v_list.location_cd := rec.location_cd;         
         v_list.loss_date_char  := TO_CHAR(rec.loss_date, 'MM-DD-YYYY HH:MI AM');

         BEGIN
            SELECT item_desc, item_desc2
              INTO v_list.item_desc, v_list.item_desc2
              FROM gicl_clm_item
             WHERE     1 = 1
                   AND claim_id = p_claim_id
                   AND item_no = v_list.item_no
                   AND grouped_item_no = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.item_desc := NULL;
               v_list.item_desc2 := NULL;
         END;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency
                    WHERE main_currency_cd = v_list.currency_cd)
         LOOP
            v_list.dsp_currency_desc := c.currency_desc;
         END LOOP;

         FOR pos IN (SELECT position
                       FROM giis_position
                      WHERE position_cd = rec.capacity_cd)
         LOOP
            v_list.position := pos.position;
         END LOOP;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist (
                   v_list.item_no,
                   v_list.claim_id)
           INTO v_list.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (v_list.item_no,
                                                             v_list.claim_id)
           INTO v_list.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve (
            v_list.item_no,
            v_list.claim_id,
            0,                              --belle grouped item no 02.13.2012
            v_list.gicl_item_peril_msg);
            
         FOR pers IN (SELECT personnel_no, name, capacity_cd, amount_covered
                        FROM gicl_casualty_personnel
                       WHERE claim_id = rec.claim_id
                         AND item_no = rec.item_no)
         LOOP
            v_list.personnel_no := pers.personnel_no;
            v_list.name := pers.name;
            v_list.pers_capacity_cd := pers.capacity_cd;
            v_list.amount_covered := pers.amount_covered;
            
            SELECT position
              INTO v_list.nbt_position
              FROM giis_position
             WHERE position_cd = pers.capacity_cd;
         END LOOP;
         
         FOR a IN(SELECT distinct 'x'
                    FROM gicl_beneficiary_dtl
                   WHERE claim_id = p_claim_id)
         LOOP
            v_chk := 1;
         END LOOP;
         
         IF v_chk = 1 THEN
            v_list.detail := 1;
         ELSE
            v_list.detail := 2;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END;
END GICL_CASUALTY_DTL_PKG;
/


