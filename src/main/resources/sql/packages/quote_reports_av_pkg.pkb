CREATE OR REPLACE PACKAGE BODY CPI.quote_reports_av_pkg
AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_AV_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/11/2010   anthony       Created this package.
******************************************************************************/
--SEICI--
   FUNCTION get_quote_av_details (p_quote_id NUMBER)
      RETURN quote_av_details_tab PIPELINED
   IS
      v_item   av_quote_details_type;
   BEGIN
      FOR a IN (SELECT gq.line_cd, gq.subline_cd,
                          gq.line_cd
                       || '-'
                       || gq.subline_cd
                       || '-'
                       || gq.iss_cd
                       || '-'
                       || gq.quotation_yy
                       || '-'
                       || gq.quotation_no
                       || '-'
                       || gq.proposal_no quote_no,
                       gq.assd_name, gq.header, gq.footer,
                       TO_CHAR (gq.accept_dt, 'fmDD Month YYYY') accept_date,
                       TO_CHAR (gq.valid_date, 'DD fmMonth YYYY') valid_date,
                       gq.quote_id,
                       DECODE (gq.incept_tag,
                               'Y', 'TBA',
                               TO_CHAR (gq.incept_date, 'fmMonth DD, YYYY')
                              ) incept_dt,
                       DECODE (gq.expiry_tag,
                               'Y', 'TBA',
                               TO_CHAR (gq.expiry_date, 'fmMonth DD, YYYY')
                              ) expiry_dt,
                       gq.incept_tag, gq.expiry_tag, gq.remarks,
                       LOWER(dh_util.spell(TRUNC(gq.valid_date - gq.accept_dt))) no_of_days
                  FROM gipi_quote gq
                 WHERE 1 = 1 AND gq.quote_id = p_quote_id)
      LOOP
         v_item.v_line_cd := 'AV';
         v_item.v_subline_cd := a.subline_cd;
         v_item.v_quote_num := a.quote_no;
         v_item.v_header := a.header;
         v_item.v_footer := a.footer;
         v_item.v_accept_dt := a.accept_date;
         v_item.v_valid_dt := a.valid_date;
         v_item.v_quote_id := a.quote_id;
         v_item.v_assd_name := a.assd_name;
         v_item.v_itag := a.incept_tag;
         v_item.v_etag := a.expiry_tag;
         v_item.v_incept := a.incept_dt;
         v_item.v_expiry := a.expiry_dt;
         v_item.v_remarks := a.remarks;
         v_item.v_no_of_days := a.no_of_days;

         BEGIN
            SELECT PARAM_VALUE_V
                   INTO  v_item.logo_file
                   FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'LOGO_FILE';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
         null;
         END;

         IF v_item.v_header IS NULL
         THEN
            BEGIN
               SELECT text
                 INTO v_item.v_header
                 FROM giis_document
                WHERE title LIKE 'AVIATION_HEADER';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         FOR tprem IN (SELECT      INITCAP (c.short_name)
                                || ' '
                                || TO_CHAR (NVL (SUM (b.prem_amt), 0),
                                            'fm999,999,999,990.90'
                                           ) prem_amt,
                                INITCAP (c.short_name) short_name
                           FROM gipi_quote_item a,
                                gipi_quote_itmperil b,
                                giis_currency c,
                                gipi_quote d
                          WHERE a.quote_id = b.quote_id
                            AND b.quote_id = d.quote_id
                            AND a.item_no = b.item_no
                            AND a.currency_cd = c.main_currency_cd
                            AND a.quote_id = p_quote_id
                       GROUP BY c.short_name)
         LOOP
            v_item.v_tprem := tprem.prem_amt;
         END LOOP;

         FOR c IN (SELECT     SUM (NVL (b.prem_amt, 0))
                            + SUM (NVL (b.tax_amt, 0)) prem_amt,
                            currency_cd
                       FROM gipi_quote_invoice b
                      WHERE b.quote_id = p_quote_id
                   GROUP BY prem_amt, tax_amt, currency_cd)
         LOOP
            FOR c1 IN (SELECT INITCAP (short_name) short_name
                         FROM giis_currency
                        WHERE main_currency_cd = c.currency_cd)
            LOOP
               v_item.v_prem_total :=
                     c1.short_name
                  || TO_CHAR (c.prem_amt, 'fm999,999,999,990.90');
            END LOOP;
         END LOOP;

         PIPE ROW (v_item);
      END LOOP;

      RETURN;
   END get_quote_av_details;

   FUNCTION get_peril_details (p_quote_id NUMBER)
      RETURN quote_av_perildetails_tab PIPELINED
   IS
      v_peril   av_peril_details_type;
      v_colon   VARCHAR2 (32767)      := NULL;
   BEGIN
      FOR b IN (SELECT   peril_name,
                            INITCAP (c.short_name)
                         || ' '
                         || TO_CHAR (NVL (b.tsi_amt, 0),
                                     'fm999,999,999,990.90'
                                    ) tsi_amt,
                         TO_CHAR (NVL (b.prem_amt, 0),
                                  'fm999,999,999,990.90'
                                 ) prem_amt,
                         INITCAP (c.short_name) short_name
                    FROM gipi_quote_item a,
                         gipi_quote_itmperil b,
                         giis_currency c,
                         gipi_quote d,
                         giis_peril e
                   WHERE a.quote_id = b.quote_id
                     AND b.quote_id = d.quote_id
                     AND d.line_cd = e.line_cd
                     AND b.peril_cd = e.peril_cd
                     AND a.item_no = b.item_no
                     AND a.currency_cd = c.main_currency_cd
                     AND a.quote_id = p_quote_id
                ORDER BY SEQUENCE)
      LOOP
         v_peril.peril_name := b.peril_name;
         v_peril.tsi := b.tsi_amt;
         v_peril.prem := b.short_name || ' ' || b.prem_amt;
         v_peril.short_name := b.short_name;
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_peril_details;

   FUNCTION get_aircraft_details (p_quote_id NUMBER)
      RETURN quote_av_aircraft_details_tab PIPELINED
   IS
      v_aircraft   av_aircraft_details_type;
   BEGIN
      FOR v IN (SELECT      a.vessel_cd
                         || '-'
                         || DECODE (year_built,
                                    NULL, vessel_name,
                                    year_built || ' ' || vessel_name
                                   ) vessel,
                         'Air Type : ' || air_desc air_type,
                         'No of Passengers : ' || NVL (no_pass, 0) no_pass,
                         'No of Crews : ' || NVL (no_crew, 0) no_crew,
                         'RPC No. : ' || rpc_no rpc_no, item_desc,
                         qualification, purpose, geog_limit
                    FROM giis_vessel a,
                         giis_air_type b,
                         gipi_quote_av_item c,
                         gipi_quote_item d
                   WHERE vessel_flag = 'A'
                     AND a.air_type_cd = b.air_type_cd
                     AND c.vessel_cd = a.vessel_cd
                     AND c.quote_id = d.quote_id
                     AND c.item_no = d.item_no
                     AND c.quote_id = p_quote_id
                ORDER BY c.item_no)
      LOOP
         v_aircraft.aircraft := v.vessel;
         v_aircraft.air_type := v.air_type;
         v_aircraft.rpc_no := v.rpc_no;
         v_aircraft.no_pass := v.no_pass;
         v_aircraft.no_crew := v.no_crew;
         v_aircraft.qualification := v.qualification;
         v_aircraft.purpose := v.purpose;
         v_aircraft.item_desc := v.item_desc;
         v_aircraft.geog_limit := v.geog_limit;
         PIPE ROW (v_aircraft);
      END LOOP;

      RETURN;
   END get_aircraft_details;

   FUNCTION get_deductible_details (p_quote_id NUMBER)
      RETURN quote_av_deduct_details_tab PIPELINED
   IS
      v_deductible   av_deductible_details_type;
   BEGIN
      FOR ded IN (SELECT deductible_title deduct_title,
                         a.deductible_text deduct_text
                    FROM gipi_quote_deductibles a,
                         giis_deductible_desc b,
                         gipi_quote c
                   WHERE a.ded_deductible_cd = b.deductible_cd
                     AND a.quote_id = c.quote_id
                     AND b.line_cd = c.line_cd
                     AND b.subline_cd = c.subline_cd
                     AND a.quote_id = p_quote_id)
      LOOP
         v_deductible.deductible_title := ded.deduct_title;
         v_deductible.deductible_text := ded.deduct_text;
         PIPE ROW (v_deductible);
      END LOOP;

      RETURN;
   END get_deductible_details;

   FUNCTION get_wc_title (p_quote_id NUMBER)
      RETURN quote_av_wc_details_tab PIPELINED
   IS
      v_wc_title   av_wc_details_type;
   BEGIN
      FOR wc IN (SELECT   wc_title
                     FROM gipi_quote_wc a
                    WHERE a.quote_id = p_quote_id
                 ORDER BY print_seq_no)
      LOOP
         v_wc_title.wc_title := wc.wc_title;
         PIPE ROW (v_wc_title);
      END LOOP;

      RETURN;
   END get_wc_title;

   FUNCTION get_invoice_details (p_quote_id NUMBER)
      RETURN quote_av_invoice_details_tab PIPELINED
   IS
      v_invoice   av_invoice_details_type;
   BEGIN
      FOR c IN (SELECT     SUM (NVL (b.prem_amt, 0))
                         + SUM (NVL (b.tax_amt, 0)) prem_amt,
                         currency_cd
                    FROM gipi_quote_invoice b
                   WHERE b.quote_id = p_quote_id
                GROUP BY prem_amt, tax_amt, currency_cd)
      LOOP
         FOR c1 IN (SELECT INITCAP (short_name) short_name
                      FROM giis_currency
                     WHERE main_currency_cd = c.currency_cd)
         LOOP
            v_invoice.short_name := c1.short_name;
            v_invoice.tprem := TO_CHAR (c.prem_amt, 'fm999,999,999,990.90');
            PIPE ROW (v_invoice);
         END LOOP;
      END LOOP;

      RETURN;
   END get_invoice_details;

--END SEICI--

   --PNBGEN--
   FUNCTION get_quote_details_pnbgen (p_quote_id NUMBER)
      RETURN quote_av_details_pnbgen_tab PIPELINED
   IS
      v_details   av_quote_details_pnbgen_type;
   BEGIN
      FOR a IN (SELECT quote_id, a.line_cd, a.iss_cd, user_name, line_name,
                          a.line_cd
                       || '-'
                       || subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || quotation_yy
                       || '-'
                       || LTRIM (TO_CHAR (quotation_no, '0000009'))
                       || '-'
                       || LTRIM (TO_CHAR (proposal_no, '09')) quoteno,
                       NVL (DECODE (c.assd_name2,
                                    NULL, c.assd_name,
                                    c.assd_name || ' ' || c.assd_name2
                                   ),
                            a.assd_name
                           ) assd_name,
                       header, footer, incept_date, expiry_date, incept_tag,
                       expiry_tag, valid_date, acct_of_cd, acct_of_cd_sw,
                       DECODE (address3,
                               NULL, DECODE (address2,
                                             NULL, address1,
                                             address1 || ' ' || address2
                                            ),
                                  DECODE (address2,
                                          NULL, address1,
                                          address1 || ' ' || address2
                                         )
                               || address3
                              ) address,
                       a.remarks
                  FROM gipi_quote a,
                       giis_line b,
                       giis_assured c,
                       giis_users d
                 WHERE quote_id = p_quote_id
                   AND a.line_cd = b.line_cd
                   AND a.assd_no = c.assd_no(+)
                   AND a.user_id = d.user_id)
      LOOP
         v_details.quote_id := a.quote_id;
         v_details.line_name := a.line_name;
         v_details.quote_no := a.quoteno;
         v_details.assd := a.assd_name;
         v_details.header := a.header;
         v_details.footer := a.footer;
         v_details.incept := a.incept_date;
         v_details.expiry := a.expiry_date;
         v_details.valid := TO_CHAR (a.valid_date, 'fmMonth DD, YYYY');
         v_details.acct_of_cd := a.acct_of_cd;
         v_details.acct_of_cd_sw := a.acct_of_cd_sw;
         v_details.address := a.address;
         v_details.remarks := a.remarks;
         v_details.line_cd := a.line_cd;
         v_details.iss_cd := a.iss_cd;
         v_details.user_name := a.user_name;

         BEGIN
            SELECT PARAM_VALUE_V
                   INTO  v_details.logo_file
                   FROM GIIS_PARAMETERS
            WHERE PARAM_NAME = 'LOGO_FILE';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
         null;
         END;

         FOR h IN (SELECT DISTINCT mortg_name
                              FROM gipi_quote_mortgagee a, giis_mortgagee b
                             WHERE a.mortg_cd = b.mortg_cd
                               AND quote_id = p_quote_id)
         LOOP
            v_details.mortgagee := h.mortg_name;
         END LOOP;

         FOR sig IN (SELECT signatory, designation
                       FROM giis_signatory a, giis_signatory_names b
                      WHERE NVL (a.report_id, 'AV_QUOTE') = 'AV_QUOTE'
                        AND NVL (a.iss_cd, v_details.iss_cd) =
                                                              v_details.iss_cd
                        AND NVL (a.line_cd, v_details.line_cd) =
                                                             v_details.line_cd
                        AND current_signatory_sw = 'Y'
                        AND a.signatory_id = b.signatory_id)
         LOOP
            v_details.sig_name := sig.signatory;
            v_details.sig_des := sig.designation;
         END LOOP;

         PIPE ROW (v_details);
      END LOOP;

      RETURN;
   END get_quote_details_pnbgen;

   FUNCTION get_peril_details_pnbgen (p_quote_id NUMBER)
      RETURN peril_av_details_tab PIPELINED
   IS
      v_peril   av_peril_details_pnbgen_type;
   BEGIN
      FOR f IN (SELECT DISTINCT DECODE (a.comp_rem,
                                        NULL, peril_name,
                                           peril_name
                                        || CHR (10)
                                        || CHR (9)
                                        || a.comp_rem
                                       ) peril_name,
                                peril_name peril, a.comp_rem remarks,
                                c.SEQUENCE
                           FROM gipi_quote_itmperil a,
                                gipi_quote b,
                                giis_peril c
                          WHERE a.quote_id = p_quote_id
                            AND a.quote_id = b.quote_id
                            AND b.line_cd = c.line_cd
                            AND a.peril_cd = c.peril_cd
                       ORDER BY c.SEQUENCE, peril_name)
      LOOP
         v_peril.peril := f.peril;
         v_peril.peril_remarks := f.remarks;
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_peril_details_pnbgen;

   FUNCTION get_deductible_details_pnbgen (p_quote_id NUMBER)
      RETURN deductible_av_details_tab PIPELINED
   IS
      v_deduct   av_deduct_details_pnbgen_type;
   BEGIN
      FOR g IN (SELECT DISTINCT deductible_text
                           FROM gipi_quote_deductibles
                          WHERE quote_id = p_quote_id)
      LOOP
         v_deduct.deductible_text := g.deductible_text;
         PIPE ROW (v_deduct);
      END LOOP;

      RETURN;
   END get_deductible_details_pnbgen;

   FUNCTION get_item_details_pnbgen (p_quote_id NUMBER)
      RETURN item_av_details_tab PIPELINED
   IS
      v_item   av_item_details_pnbgen_type;
   BEGIN
      FOR d IN (SELECT LTRIM (TO_CHAR (item_no, '99990')) item_no,
                       item_title, item_desc,
                          short_name
                       || LTRIM (TO_CHAR (tsi_amt, '9,999,999,999,999,990.99'))
                                                                     tsi_amt
                  FROM gipi_quote_item a, giis_currency b
                 WHERE quote_id = p_quote_id
                   AND a.currency_cd = b.main_currency_cd)
      LOOP
         v_item.item :=
               d.item_no
            || '-'
            || d.item_title
            || '            '
            || '('
            || d.tsi_amt
            || ')';
         v_item.detail :=
               d.item_no
            || '-'
            || d.item_title
            || '            '
            || '('
            || d.tsi_amt
            || ')';
         v_item.item_desc := d.item_desc;
         PIPE ROW (v_item);
      END LOOP;

      RETURN;
   END get_item_details_pnbgen;

   FUNCTION get_wc_details_pnbgen (p_quote_id NUMBER)
      RETURN wc_av_details_tab PIPELINED
   IS
      v_warrcla   av_wc_details_pnbgen_type;
   BEGIN
      FOR wc IN (SELECT   DECODE (wc_title2,
                                  NULL, wc_title,
                                  wc_title || ' ' || wc_title2
                                 ) title
                     FROM gipi_quote_wc
                    WHERE quote_id = p_quote_id
                 ORDER BY print_seq_no, title)
      LOOP
         v_warrcla.warrcla := wc.title;
         PIPE ROW (v_warrcla);
      END LOOP;

      RETURN;
   END get_wc_details_pnbgen;

   FUNCTION get_premium_details_pnbgen (p_quote_id NUMBER)
      RETURN premium_av_details_tab PIPELINED
   IS
      v_prem   av_premium_details_pnbgen_type;
   BEGIN
      FOR i IN
         (SELECT b.line_cd, a.iss_cd, a.quote_inv_no, a.prem_amt,
                 LTRIM (TO_CHAR (NVL ((a.prem_amt + a.tax_amt), 0),
                                 '9,999,999,999,999,990.99'
                                )
                       ) total_amt_due
            FROM gipi_quote_invoice a, gipi_quote b
           WHERE a.quote_id = p_quote_id AND a.quote_id = b.quote_id)
      LOOP
         v_prem.premium :=
                     LTRIM (TO_CHAR (i.prem_amt, '9,999,999,999,999,990.99'));
         v_prem.tot_amt := i.total_amt_due;

         FOR j IN
            (SELECT   tax_desc,
                      LTRIM (TO_CHAR (tax_amt, '9,999,999,999,999,990.90')
                            ) tax_amt,
                      SEQUENCE
                 FROM gipi_quote_invtax a, giis_tax_charges b
                WHERE b.line_cd = i.line_cd
                  AND b.tax_cd = a.tax_cd
                  AND b.iss_cd = a.iss_cd
                  AND a.iss_cd = i.iss_cd
                  AND a.quote_inv_no = i.quote_inv_no
                  AND NVL (b.expired_sw, 'N') = 'N'
             ORDER BY SEQUENCE, tax_desc)
         LOOP
            v_prem.tax_desc := j.tax_desc;
            v_prem.tax_amt := j.tax_amt;
         END LOOP;

         PIPE ROW (v_prem);
      END LOOP;

      RETURN;
   END;
--END PNBGEN--
END QUOTE_REPORTS_AV_PKG;
/


