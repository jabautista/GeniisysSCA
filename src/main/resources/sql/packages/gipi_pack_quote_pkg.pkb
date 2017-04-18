CREATE OR REPLACE PACKAGE BODY CPI.gipi_pack_quote_pkg
AS
/*
  for GIPIS050A - shows the list of package quotation
*/
   FUNCTION get_pack_quote_list (
      p_line_cd   gipi_pack_quote.line_cd%TYPE,
      p_iss_cd    gipi_pack_quote.iss_cd%TYPE,
      p_module    giis_user_grp_modules.module_id%TYPE,
      p_keyword   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN gipi_pack_quote_list_tab PIPELINED
   IS
      v_pack_quote   gipi_pack_quote_list_type;
   BEGIN
      FOR i IN (SELECT   a.pack_quote_id, a.line_cd, a.iss_cd, a.subline_cd,
                         TO_CHAR (a.quotation_yy) quotation_yy,
                         TO_CHAR (a.quotation_no, '000009') quotation_no,
                         TO_CHAR (a.proposal_no, '009') proposal_no,
                         TO_CHAR (a.assd_no, '00000000000009') assd_no,
                         a.assd_name, b.assd_name assured,
                         NVL (b.active_tag, 'N') assd_active_tag,
                         a.valid_date,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || TO_CHAR (a.quotation_yy)
                         || '-'
                         || TO_CHAR (a.quotation_no, '000009')
                         || '-'
                         || TO_CHAR (a.proposal_no, '009') quote_no
                    FROM gipi_pack_quote a, giis_assured b
                   WHERE status = 'N'
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND iss_cd = NVL (p_iss_cd, iss_cd)
                     AND b.assd_no(+) = a.assd_no
                     AND check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               p_module,
                                               p_user_id
                                              ) = 1
                     AND (   UPPER (a.line_cd) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.iss_cd) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.subline_cd) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.quotation_yy) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.quotation_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.proposal_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.assd_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                          OR UPPER (a.assd_name) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                         )
                ORDER BY line_cd)
      LOOP
         v_pack_quote.pack_quote_id := i.pack_quote_id;
         v_pack_quote.line_cd := i.line_cd;
         v_pack_quote.iss_cd := i.iss_cd;
         v_pack_quote.subline_cd := i.subline_cd;
         v_pack_quote.quotation_yy := i.quotation_yy;
         v_pack_quote.quotation_no := i.quotation_no;
         v_pack_quote.proposal_no := i.proposal_no;
         v_pack_quote.assd_no := i.assd_no;
         v_pack_quote.assd_name := i.assd_name;
         v_pack_quote.assured := i.assured;
         v_pack_quote.assd_active_tag := i.assd_active_tag;
         v_pack_quote.valid_date := i.valid_date;
         v_pack_quote.quote_no := i.quote_no;
         PIPE ROW (v_pack_quote);
      END LOOP;

      RETURN;
   END get_pack_quote_list;

   PROCEDURE update_gipi_pack_quote (p_quote_id gipi_quote.quote_id%TYPE)
   IS
   BEGIN
      UPDATE gipi_pack_quote
         SET status = 'W'
       WHERE pack_quote_id = p_quote_id;

      FOR x IN (SELECT quote_id, line_cd, iss_cd, quotation_no, subline_cd,
                       quotation_yy
                  FROM gipi_quote
                 WHERE pack_quote_id = p_quote_id)
      LOOP
         /* this will update status of subquotations
         */
         UPDATE gipi_quote
            SET status = 'W'
          WHERE quote_id = x.quote_id;

         UPDATE gipi_quote
            SET status = 'X'
          WHERE line_cd = x.line_cd
            AND subline_cd = x.subline_cd
            AND iss_cd = x.iss_cd
            AND quotation_yy = x.quotation_yy
            AND quotation_no = x.quotation_no
            AND quote_id != x.quote_id;
      END LOOP;

      FOR x IN (SELECT quote_id, line_cd, iss_cd, quotation_no, subline_cd,
                       quotation_yy
                  FROM gipi_quote
                 WHERE pack_quote_id = p_quote_id)
      LOOP
         UPDATE gipi_pack_quote
            SET status = 'X'
          WHERE line_cd = x.line_cd
            AND iss_cd = x.iss_cd
            AND quotation_yy = x.quotation_yy
            AND quotation_no = x.quotation_no
            AND subline_cd = x.subline_cd
            AND pack_quote_id != p_quote_id;
      END LOOP;
   END update_gipi_pack_quote;

   PROCEDURE process_packquote_to_par (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE,
      p_par_id          gipi_parlist.par_id%TYPE,
      p_line_cd         gipi_pack_quote.line_cd%TYPE,
      p_iss_cd          gipi_pack_quote.iss_cd%TYPE,
      p_assd_no         giis_assured.assd_no%TYPE,
      p_user            VARCHAR2
   )
   IS
      p_message   VARCHAR2 (100);
   BEGIN
      pack_quote_to_par.create_parlist_wpack (p_pack_quote_id,
                                              p_line_cd,
                                              p_par_id,
                                              p_iss_cd,
                                              p_assd_no
                                             );
      --inside create_gipi_pack_wpolbas in GIPIS050A.FMB
      gipi_pack_wpolbas_pkg.create_gipi_pack_wpolbas (p_pack_quote_id,
                                                      p_line_cd,
                                                      p_iss_cd,
                                                      p_assd_no,
                                                      p_par_id,
                                                      p_message,
                                                      p_user
                                                     );
      delete_workflow_rec2 ('GIIMM001', p_user, p_pack_quote_id);
      gipi_witem_pkg.create_gipi_witem (p_pack_quote_id, p_par_id);
      --'Creating item information ..
      pack_quote_to_par.create_item_info (p_par_id, p_pack_quote_id);
      --'Creating peril and warranties/clauses information ...
      pack_quote_to_par.create_peril_wc (p_par_id);
      --Creating distribution/deductibles information ...'
      pack_quote_to_par.create_dist_ded (p_par_id);
      pack_quote_to_par.create_wmortgagee (p_pack_quote_id, p_par_id);

      FOR pack IN (SELECT 'A'
                     FROM giis_line
                    WHERE line_cd = p_line_cd AND pack_pol_flag = 'Y')
      LOOP
         gipi_wpack_line_subline_pkg.create_wpack_line_subline (p_par_id,
                                                                p_line_cd
                                                               );
      END LOOP;

      --Creating invoice ...
      FOR d IN (SELECT par_id, quote_id, line_cd, iss_cd
                  FROM gipi_parlist
                 WHERE pack_par_id = p_par_id)
      LOOP
         FOR itmperil IN (SELECT '1'
                            FROM gipi_witmperl
                           WHERE par_id = d.par_id)
         LOOP
            create_winvoice (0, 0, 0, d.par_id, d.line_cd, d.iss_cd);
         END LOOP;
      END LOOP;

      --Creating discount information ...
      pack_quote_to_par.create_discounts (p_par_id);
   END;

   FUNCTION get_pack_quotation_listing (
      p_user     giis_users.user_id%TYPE,
      p_module   giis_modules.module_id%TYPE,
      p_line     giis_line.line_cd%TYPE
   )
      RETURN pack_quotation_listing_tab PIPELINED
   IS
      v_gipi_pack   pack_quotation_listing_type;
   BEGIN
      FOR a IN (SELECT   a.pack_quote_id,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || a.quotation_yy
                         || '-'
                         || TO_CHAR (a.quotation_no, '000009')
                         || '-'
                         || TO_CHAR (a.proposal_no, '009') quote_no,
                         a.assd_name, a.incept_date, a.expiry_date,
                         a.valid_date, a.user_id, a.assd_no, a.accept_dt,
                         a.iss_cd, a.quotation_no, a.quotation_yy,
                         a.proposal_no, a.subline_cd
                    FROM gipi_pack_quote a
                   WHERE a.user_id =
                            (SELECT DECODE (b.all_user_sw,
                                            'Y', a.user_id,
                                            'N', p_user,
                                            p_user
                                           )
                               FROM giis_users b
                              WHERE b.user_id = p_user)
                     AND a.status = 'N'
                     AND check_user_per_line2 (line_cd,
                                               iss_cd,
                                               p_module,
                                               p_user
                                              ) = 1
                     AND check_user_per_iss_cd2 (p_line,
                                                 iss_cd,
                                                 p_module,
                                                 p_user
                                                ) = 1
                     AND a.line_cd = p_line
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || a.quotation_yy
                         || '-'
                         || TO_CHAR (a.quotation_no, '000009')
                         || '-'
                         || TO_CHAR (a.proposal_no, '009'),
                         a.accept_dt DESC)
      LOOP
         v_gipi_pack.pack_quote_id := a.pack_quote_id;
         v_gipi_pack.quote_no := a.quote_no;
         v_gipi_pack.assd_name := a.assd_name;
         v_gipi_pack.assd_no := a.assd_no;
         v_gipi_pack.incept_date := a.incept_date;
         v_gipi_pack.expiry_date := a.expiry_date;
         v_gipi_pack.valid_date := a.valid_date;
         v_gipi_pack.user_id := a.user_id;
         v_gipi_pack.accept_dt := a.accept_dt;
         v_gipi_pack.iss_cd := a.iss_cd;
         v_gipi_pack.quotation_no := a.quotation_no;
         v_gipi_pack.quotation_yy := a.quotation_yy;
         v_gipi_pack.proposal_no := a.proposal_no;
         v_gipi_pack.subline_cd := a.subline_cd;
         PIPE ROW (v_gipi_pack);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipi_pack_quote (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   )
      RETURN gipi_pack_details_tab PIPELINED
   IS
      v_gipi_pack_quote   gipi_pack_details_type;
   BEGIN
      FOR a IN
         (SELECT pack_quote_id,
                    line_cd
                 || '-'
                 || subline_cd
                 || '-'
                 || iss_cd
                 || '-'
                 || TO_CHAR (quotation_yy, '0009')
                 || '-'
                 || TO_CHAR (quotation_no, '000009')
                 || '-'
                 || TO_CHAR (proposal_no, '09') quote_no,
                 assd_name, incept_date, expiry_date, incept_tag, expiry_tag,
                 TRUNC (expiry_date) - TRUNC (incept_date) no_of_days,
                 accept_dt, underwriter underwriter, user_id, line_cd,
                 giis_line_pkg.get_line_name (line_cd) line_name, subline_cd,
                 giis_subline_pkg.get_subline_name2 (line_cd,
                                                     subline_cd
                                                    ) subline_name,
                 iss_cd, giis_issource_pkg.get_iss_name (iss_cd) iss_name,
                 quotation_yy, quotation_no, proposal_no, cred_branch,
                 giis_issource_pkg.get_iss_name (cred_branch)
                                                            cred_branch_name,
                 valid_date,
                 giis_assured_pkg.get_assd_name (acct_of_cd) acct_of,
                 address1, address2, address3, prorate_flag, header, footer,
                 remarks, reason_cd,
                 giis_loss_bid_pkg.get_reason_desc (reason_cd) reason_desc,
                 comp_sw, short_rt_percent, acct_of_cd, assd_no, prem_amt,
                 ann_prem_amt, tsi_amt, bank_ref_no, account_sw
            FROM gipi_pack_quote
           WHERE pack_quote_id = p_pack_quote_id)
      LOOP
         v_gipi_pack_quote.pack_quote_id := a.pack_quote_id;
         v_gipi_pack_quote.quote_no := a.quote_no;
         v_gipi_pack_quote.assd_name := a.assd_name;
         v_gipi_pack_quote.incept_date := a.incept_date;
         v_gipi_pack_quote.expiry_date := a.expiry_date;
         v_gipi_pack_quote.incept_tag := a.incept_tag;
         v_gipi_pack_quote.expiry_tag := a.expiry_tag;
         v_gipi_pack_quote.no_of_days := a.no_of_days;
         v_gipi_pack_quote.accept_dt := a.accept_dt;
         v_gipi_pack_quote.underwriter := a.underwriter;
         v_gipi_pack_quote.user_id := a.user_id;
         v_gipi_pack_quote.line_cd := a.line_cd;
         v_gipi_pack_quote.line_name := a.line_name;
         v_gipi_pack_quote.subline_cd := a.subline_cd;
         v_gipi_pack_quote.subline_name := a.subline_name;
         v_gipi_pack_quote.iss_cd := a.iss_cd;
         v_gipi_pack_quote.iss_name := a.iss_name;
         v_gipi_pack_quote.quotation_yy := a.quotation_yy;
         v_gipi_pack_quote.quotation_no := a.quotation_no;
         v_gipi_pack_quote.proposal_no := a.proposal_no;
         v_gipi_pack_quote.cred_branch := a.cred_branch;
         v_gipi_pack_quote.cred_branch_name := a.iss_name;
         v_gipi_pack_quote.valid_date := a.valid_date;
         --v_gipi_pack_quote.acct_of := a.assd_name; -- marco - 04.22.2013 - replaced with line below
         v_gipi_pack_quote.acct_of := a.acct_of;
         v_gipi_pack_quote.address1 := a.address1;
         v_gipi_pack_quote.address2 := a.address2;
         v_gipi_pack_quote.address3 := a.address3;
         v_gipi_pack_quote.prorate_flag := a.prorate_flag;
         v_gipi_pack_quote.header := a.header;
         v_gipi_pack_quote.footer := a.footer;
         v_gipi_pack_quote.remarks := a.remarks;
         v_gipi_pack_quote.reason_cd := a.reason_cd;
         v_gipi_pack_quote.reason_desc := a.reason_desc;
         v_gipi_pack_quote.comp_sw := a.comp_sw;
         v_gipi_pack_quote.short_rt_percent := a.short_rt_percent;
         v_gipi_pack_quote.acct_of_cd := a.acct_of_cd;
         v_gipi_pack_quote.assd_no := a.assd_no;
         v_gipi_pack_quote.prem_amt := a.prem_amt;
         v_gipi_pack_quote.ann_prem_amt := a.ann_prem_amt;
         v_gipi_pack_quote.tsi_amt := a.tsi_amt;
         v_gipi_pack_quote.bank_ref_no := a.bank_ref_no;
         v_gipi_pack_quote.account_sw := a.account_sw;
         PIPE ROW (v_gipi_pack_quote);
      END LOOP;

      RETURN;
   END;

   PROCEDURE save_gipi_pack_quotation (
      p_gipi_pack_quote   IN   gipi_pack_quote%ROWTYPE
   )
   IS
      pack_quote   gipi_pack_quote%ROWTYPE;
	  v_short_rt_percent_temp   gipi_pack_quote.short_rt_percent%TYPE;	--added by steven 10.30.2012
	  v_reason_cd_temp			gipi_pack_quote.reason_cd%TYPE;			--added by steven 10.30.2012
	  v_acct_of_cd_temp      	gipi_pack_quote.acct_of_cd%TYPE;		--added by steven 10.30.2012
	  v_assd_no    				gipi_pack_quote.assd_no%TYPE;			--added by steven 10.30.2012
   BEGIN
      pack_quote := p_gipi_pack_quote;
	  v_short_rt_percent_temp := pack_quote.short_rt_percent;
	  v_reason_cd_temp := pack_quote.reason_cd;
	  v_acct_of_cd_temp := pack_quote.acct_of_cd;
	  v_assd_no := pack_quote.assd_no;
	  
	  IF v_assd_no = 0 THEN --added by steven 11.8.2012
		v_assd_no := NULL;
	  END IF;
	  IF pack_quote.prorate_flag = 2 THEN --added by steven 10.30.2012 base on SR 0011167
	  	v_short_rt_percent_temp := null;
	  END IF;
      
      IF pack_quote.reason_cd = 0 THEN --added by steven 10.30.2012 base on SR 0011167
        v_reason_cd_temp := null;
      END IF;
         
      IF pack_quote.acct_of_cd = 0 THEN --added by steven 10.30.2012 base on SR 0011167
        v_acct_of_cd_temp := null;
      END IF;
      
      MERGE INTO gipi_pack_quote
         USING DUAL
         ON (pack_quote_id = pack_quote.pack_quote_id)
         WHEN NOT MATCHED THEN
            INSERT (pack_quote_id, line_cd, subline_cd, iss_cd, quotation_yy,
                    quotation_no, proposal_no, assd_no, assd_name, tsi_amt,
                    prem_amt, print_dt, accept_dt, post_dt, denied_dt,
                    status, print_tag, header, footer, remarks, user_id,
                    last_update, cpi_rec_no, cpi_branch_cd,
                    quotation_printed_cnt, incept_date, expiry_date, origin,
                    reason_cd, address1, address2, address3, valid_date,
                    prorate_flag, short_rt_percent, comp_sw, underwriter,
                    insp_no, ann_prem_amt, ann_tsi_amt, with_tariff_sw,
                    incept_tag, expiry_tag, cred_branch, acct_of_cd,
                    acct_of_cd_sw, account_sw)
            VALUES (pack_quote.pack_quote_id, pack_quote.line_cd,
                    pack_quote.subline_cd, pack_quote.iss_cd,
                    pack_quote.quotation_yy, pack_quote.quotation_no,
                    pack_quote.proposal_no, --pack_quote.assd_no, --editted by MJ for consolidation 01022012 [pack_quote.assd_no was replaced by v_assd_no]
					v_assd_no, 			--added by steven 11.8.2012
                    pack_quote.assd_name, pack_quote.tsi_amt,
                    pack_quote.prem_amt, NULL, SYSDATE, pack_quote.post_dt,
                    pack_quote.denied_dt, 'N', 'N', pack_quote.header,
                    pack_quote.footer, pack_quote.remarks,
                    pack_quote.user_id, SYSDATE, pack_quote.cpi_rec_no,
                    pack_quote.cpi_branch_cd,
                    pack_quote.quotation_printed_cnt, pack_quote.incept_date,
                    pack_quote.expiry_date, pack_quote.origin,
                    --pack_quote.reason_cd, --editted by MJ for consolidation 01022013 [pack_quote.reason_cd was replaced by v_reason_cd_temp]
					v_reason_cd_temp, --added by steven 10/31/2012: v_reason_cd_temp
					pack_quote.address1,
                    pack_quote.address2, pack_quote.address3,
                    pack_quote.valid_date, pack_quote.prorate_flag,
                    --pack_quote.short_rt_percent, --editted by MJ for consolidation 01022013 [pack_quote.short_rt_percent was replaced by v_short_rt_percent_temp]
					v_short_rt_percent_temp, --added by steven 10/31/2012: v_short_rt_percent_temp
					pack_quote.comp_sw,
                    pack_quote.underwriter, pack_quote.insp_no,
                    pack_quote.ann_prem_amt, pack_quote.ann_tsi_amt,
                    pack_quote.with_tariff_sw, pack_quote.incept_tag,
                    pack_quote.expiry_tag, pack_quote.cred_branch,
                    --pack_quote.acct_of_cd, --editted by MJ for consolidation 01022013 [pack_quote.acct_of_cd was replaced by v_acct_of_cd_temp]
					v_acct_of_cd_temp,  --added by steven 10/31/2012: v_acct_of_cd_temp
					pack_quote.acct_of_cd_sw, pack_quote.account_sw)
         WHEN MATCHED THEN
            UPDATE
               SET                    /*line_cd = pack_quote.line_cd,
                                      subline_cd = pack_quote.subline_cd,
                                      iss_cd = pack_quote.iss_cd,
                                      quotation_yy = pack_quote.quotation_yy,
                                      quotation_no = pack_quote.quotation_no,
                                      proposal_no = pack_quote.proposal_no,*/
                  --assd_no = pack_quote.assd_no, --editted by MJ for consolidation 01022013
				  assd_no = v_assd_no, --added by steven 11.8.2012
                  assd_name = pack_quote.assd_name,
                  tsi_amt = pack_quote.tsi_amt,
                  prem_amt = pack_quote.prem_amt,
                  print_dt = pack_quote.print_dt,
                  accept_dt = pack_quote.accept_dt,
                  post_dt = pack_quote.post_dt,
                  denied_dt = pack_quote.denied_dt, status = 'N',
                  print_tag = pack_quote.print_tag,
                  header = pack_quote.header, footer = pack_quote.footer,
                  remarks = pack_quote.remarks, user_id = pack_quote.user_id,
                  last_update = SYSDATE, cpi_rec_no = pack_quote.cpi_rec_no,
                  cpi_branch_cd = pack_quote.cpi_branch_cd,
                  quotation_printed_cnt = pack_quote.cpi_rec_no,
                  incept_date = pack_quote.incept_date,
                  expiry_date = pack_quote.expiry_date,
                  origin = pack_quote.origin,
                  --reason_cd = pack_quote.reason_cd, --editted by MJ for consolidation 01022013
				  reason_cd = v_reason_cd_temp, --added by steven 10/31/2012: v_reason_cd_temp
                  address1 = pack_quote.address1,
                  address2 = pack_quote.address2,
                  address3 = pack_quote.address3,
                  valid_date = pack_quote.valid_date,
                  prorate_flag = pack_quote.prorate_flag,
                  --short_rt_percent = pack_quote.short_rt_percent, --editted by MJ for consolidation 01022013
				  short_rt_percent = v_short_rt_percent_temp,   --added by steven 10/31/2012: v_short_rt_percent_temp
                  comp_sw = pack_quote.comp_sw,
                  underwriter = pack_quote.underwriter,
                  insp_no = pack_quote.insp_no,
                  ann_prem_amt = pack_quote.ann_prem_amt,
                  ann_tsi_amt = pack_quote.ann_tsi_amt,
                  with_tariff_sw = pack_quote.with_tariff_sw,
                  incept_tag = pack_quote.incept_tag,
                  expiry_tag = pack_quote.expiry_tag,
                  cred_branch = pack_quote.cred_branch,
                  --acct_of_cd = pack_quote.acct_of_cd, --editted by MJ for consolidation 01022013
				  acct_of_cd = v_acct_of_cd_temp,   --added by steven 10/31/2012: v_acct_of_cd_temp
                  acct_of_cd_sw = pack_quote.acct_of_cd_sw,
                  account_sw = pack_quote.account_sw
            ;
   END;

   PROCEDURE del_gipi_pack_quotation (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   )
   AS
   BEGIN
      FOR alls IN (SELECT quote_id, line_cd
                     FROM gipi_quote
                    WHERE pack_quote_id = p_pack_quote_id)
      LOOP
         --/**delete from table with regards with line_cd**/
         IF alls.line_cd = 'AC'        --OR alls.line_cd = :quote.accident_cd
         THEN
            DELETE FROM gipi_quote_ac_item
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'MC'         --OR alls.line_cd = :quote.motor_cd
         THEN
            DELETE FROM gipi_quote_item_mc
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'FI'          --OR alls.line_cd = :quote.fire_cd
         THEN
            DELETE FROM gipi_quote_fi_item
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'EN'        --OR alls.line_cd = :quote.engrng_cd
         THEN
            DELETE FROM gipi_quote_en_item
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'CA'      --OR alls.line_cd = :quote.casualty_cd
         THEN
            DELETE FROM gipi_quote_ca_item
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'AV'      --OR alls.line_cd = :quote.aviation_cd
         THEN
            DELETE FROM gipi_quote_av_item
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'MH'          --OR alls.line_cd = :quote.hull_cd
         THEN
            DELETE FROM gipi_quote_mh_item
                  WHERE quote_id = alls.quote_id;

            DELETE FROM gipi_quote_ves_air
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'SU'        --OR alls.line_cd = :quote.surety_cd
         THEN
            DELETE FROM gipi_quote_bond_basic
                  WHERE quote_id = alls.quote_id;
         ELSIF alls.line_cd = 'MN'         --OR alls.line_cd = :quote.cargo_cd
         THEN
            DELETE FROM gipi_quote_cargo
                  WHERE quote_id = alls.quote_id;

            DELETE FROM gipi_quote_ves_air
                  WHERE quote_id = alls.quote_id;
         END IF;

         --aaron deletion of mortgagee 102508
         DELETE FROM gipi_quote_mortgagee
               WHERE quote_id = alls.quote_id;

         /***delete quotation from all other gipi_quotes tables regardless of line_cd***/
         DELETE FROM gipi_quote_wc
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_item_discount
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_peril_discount
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_pictures
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_polbasic_discount
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_principal
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_cosign
               WHERE quote_id = alls.quote_id;

 /**********/
--deletion from subtable gipi_quote_invoice and its corresponding
    --child records from gipi_quote_invtax
         FOR invoice IN (SELECT iss_cd, quote_inv_no
                           FROM gipi_quote_invoice
                          WHERE quote_id = alls.quote_id)
         LOOP
            --delete child records from gipi_quote_invtax
            FOR invtax IN (SELECT tax_cd
                             FROM gipi_quote_invtax
                            WHERE iss_cd = invoice.iss_cd
                              AND quote_inv_no = invoice.quote_inv_no)
            LOOP
               DELETE FROM gipi_quote_invtax
                     WHERE iss_cd = invoice.iss_cd
                       AND quote_inv_no = invoice.quote_inv_no
                       AND tax_cd = invtax.tax_cd;
            END LOOP;
         END LOOP;

         DELETE FROM gipi_quote_invoice
               WHERE quote_id = alls.quote_id;

         DELETE FROM gipi_quote_itmperil
               WHERE quote_id = alls.quote_id;

/*********/

         --deletion from subtable gipi_quote_item and its corresponding
--child records from gipi_quote_item_mc
         FOR item IN (SELECT item_no
                        FROM gipi_quote_item
                       WHERE quote_id = alls.quote_id)
         LOOP
            --delete child records from gipi_quote_item_mc
            FOR item_mc IN (SELECT item_no
                              FROM gipi_quote_item_mc
                             WHERE quote_id = alls.quote_id
                               AND item_no = item.item_no)
            LOOP
               DELETE FROM gipi_quote_item_mc
                     WHERE quote_id = alls.quote_id
                           AND item_no = item.item_no;
            END LOOP;

            DELETE FROM gipi_quote_item
                  WHERE quote_id = alls.quote_id;
         END LOOP;

         --delete from the main table gipi_quote.
         DELETE FROM gipi_quote
               WHERE quote_id = alls.quote_id;
      END LOOP;

      -- Lastly, delete from main gipi_pack_quote
      DELETE FROM gipi_pack_quote
            WHERE pack_quote_id = p_pack_quote_id;
   END;

   PROCEDURE deny_gipi_pack_quotation (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE,
      p_reason_cd       gipi_pack_quote.reason_cd%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_pack_quote
         SET status = 'D',
             denied_dt = SYSDATE,
             reason_cd = p_reason_cd
       WHERE pack_quote_id = p_pack_quote_id;

      UPDATE gipi_quote
         SET status = 'D',
             denied_dt = SYSDATE,
             reason_cd = p_reason_cd
       WHERE pack_quote_id = p_pack_quote_id AND status = 'N';
   END;

      PROCEDURE copy_gipi_pack_quotation (
      p_pack_quote_id         gipi_pack_quote.pack_quote_id%TYPE,
      p_new_quote_no    OUT   VARCHAR2,
      p_user_id               gipi_pack_quote.user_id%TYPE
   )
   IS
      TYPE quote_ids IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;

      quote_num             quote_ids;
      v_quote_no            NUMBER;
      v_counter             NUMBER                                       := 0;
      v_counter_peril       NUMBER                                       := 0;
      v_counter_item        NUMBER                                       := 1;
      v_quote_no1           NUMBER;
      v_temp_quote          NUMBER                                       := 1;
      v_temp_line_cd        VARCHAR2 (2);
      v_temp_id             NUMBER;
      x1                    NUMBER                                       := 1;
      --gipi_pack_quote
      v_line_cd             gipi_pack_quote.line_cd%TYPE;
      v_subline_cd          gipi_pack_quote.subline_cd%TYPE;
      v_iss_cd              gipi_pack_quote.iss_cd%TYPE;
      v_quotation_yy        gipi_pack_quote.quotation_yy%TYPE;
      v_quotation_no        gipi_pack_quote.quotation_no%TYPE;
      v_proposal_no         gipi_pack_quote.proposal_no%TYPE;
      v_new_proposal_no     gipi_pack_quote.proposal_no%TYPE;
      v_assd_no             gipi_pack_quote.assd_no%TYPE;
      v_assd_name           gipi_pack_quote.assd_name%TYPE;
      v_remarks             gipi_pack_quote.remarks%TYPE;
      v_header              gipi_pack_quote.header%TYPE;
      v_footer              gipi_pack_quote.footer%TYPE;
      v_status              gipi_pack_quote.status%TYPE;
      v_print_tag           gipi_pack_quote.print_tag%TYPE;
      v_incept_date         gipi_pack_quote.incept_date%TYPE;
      v_expiry_date         gipi_pack_quote.expiry_date%TYPE;
      v_accept_dt           gipi_pack_quote.accept_dt%TYPE;
      v_incept_tag          gipi_pack_quote.incept_tag%TYPE;
      v_expiry_tag          gipi_pack_quote.expiry_tag%TYPE;
      v_address1            gipi_pack_quote.address1%TYPE;
      v_address2            gipi_pack_quote.address2%TYPE;
      v_address3            gipi_pack_quote.address3%TYPE;
      v_acct_of_cd          gipi_pack_quote.acct_of_cd%TYPE;
      v_acct_of_cd_sw       gipi_pack_quote.acct_of_cd_sw%TYPE;
      v_cred_branch         gipi_pack_quote.cred_branch%TYPE;
      v_valid_date          gipi_pack_quote.valid_date%TYPE;
      /*added by VJ 110707*/
      v_prorate_flag        gipi_pack_quote.prorate_flag%TYPE;
      v_comp_sw             gipi_pack_quote.comp_sw%TYPE;
      v_with_tariff_sw      gipi_pack_quote.with_tariff_sw%TYPE;
    /*end VJ*/
--    v_tsi_amt                 gipi_quote_itmperil.tsi_amt%TYPE;
--    v_prem_amt             gipi_quote_itmperil.prem_amt%TYPE;
      v_quote_id            NUMBER;
      v_menu_line_cd        giis_line.menu_line_cd%TYPE;    -- grace 06.10.06
                                                                                                 -- stores the value of the menu_line_cd
      v_underwriter         gipi_pack_quote.UNDERWRITER%type;           -- shan 05.07.2014
      --gipi_quote
      v_line_cd1            gipi_quote.line_cd%TYPE;
      v_subline_cd1         gipi_quote.subline_cd%TYPE;
      v_iss_cd1             gipi_quote.iss_cd%TYPE;
      v_quotation_yy1       gipi_quote.quotation_yy%TYPE;
      v_quotation_no1       gipi_quote.quotation_no%TYPE;
      v_proposal_no1        gipi_quote.proposal_no%TYPE;
      v_new_proposal_no1    gipi_quote.proposal_no%TYPE;
      v_assd_no1            gipi_quote.assd_no%TYPE;
      v_assd_name1          gipi_quote.assd_name%TYPE;
      v_remarks1            gipi_quote.remarks%TYPE;
      v_header1             gipi_quote.header%TYPE;
      v_footer1             gipi_quote.footer%TYPE;
      v_status1             gipi_quote.status%TYPE;
      v_print_tag1          gipi_quote.print_tag%TYPE;
      v_incept_date1        gipi_quote.incept_date%TYPE;
      v_expiry_date1        gipi_quote.expiry_date%TYPE;
      v_accept_dt1          gipi_quote.accept_dt%TYPE;
      v_incept_tag1         gipi_quote.incept_tag%TYPE;
      v_expiry_tag1         gipi_quote.expiry_tag%TYPE;
      v_address1_1          gipi_quote.address1%TYPE;
      v_address2_1          gipi_quote.address2%TYPE;
      v_address3_1          gipi_quote.address3%TYPE;
      v_acct_of_cd1         gipi_quote.acct_of_cd%TYPE;
      v_acct_of_cd_sw1      gipi_quote.acct_of_cd_sw%TYPE;
      v_cred_branch1        gipi_quote.cred_branch%TYPE;
      v_valid_date1         gipi_quote.valid_date%TYPE;
      v_prorate_flag1       gipi_quote.prorate_flag%TYPE;
      v_comp_sw1            gipi_quote.comp_sw%TYPE;
      v_with_tariff_sw1     gipi_quote.with_tariff_sw%TYPE;
--    v_tsi_amt                 gipi_quote_itmperil.tsi_amt%TYPE;
--    v_prem_amt             gipi_quote_itmperil.prem_amt%TYPE;
      v_quote_id1           NUMBER (12);
      v_menu_line_cd1       giis_line.menu_line_cd%TYPE;
      --gipi_quote_item
      v_item_no             gipi_quote_item.item_no%TYPE;
      v_item_title          gipi_quote_item.item_title%TYPE;
      v_item_desc           gipi_quote_item.item_desc%TYPE;
      v_currency_cd         gipi_quote_item.currency_cd%TYPE;
      v_currency_rt         gipi_quote_item.currency_rate%TYPE;
      v_pack_line_cd        gipi_quote_item.pack_line_cd%TYPE;
      v_pack_subline_cd     gipi_quote_item.pack_subline_cd%TYPE;
      v_ann_prem_amt        gipi_quote_item.ann_prem_amt%TYPE; --Gzelle
      v_ann_tsi_amt         gipi_quote_item.ann_tsi_amt%TYPE; --Gzelle
      --gipi_quote_itmperil
      v_item_no1              gipi_quote_itmperil.item_no%TYPE;
      v_peril_cd              gipi_quote_itmperil.peril_cd%TYPE;
      v_tsi_amt               gipi_quote_itmperil.tsi_amt%TYPE;
      v_prem_amt              gipi_quote_itmperil.prem_amt%TYPE;
      v_prem_rt               gipi_quote_itmperil.prem_rt%TYPE;
      v_comp_rem              gipi_quote_itmperil.comp_rem%TYPE;
      p_exists                VARCHAR2 (1)                               := 'N';
      v_ann_prem_amt_itmperil gipi_quote_itmperil.ann_prem_amt%TYPE; --Gzelle
      v_ann_tsi_amt_itmperil  gipi_quote_itmperil.ann_tsi_amt%TYPE; --Gzelle
      v_line_cd_itmperil      gipi_quote_itmperil.line_cd%TYPE; --Gzelle
      v_peril_type_itmperil   gipi_quote_itmperil.peril_type%TYPE; --Gzelle
      --gipi_quote_invoice
      v_quote_inv_no        gipi_quote_invoice.quote_inv_no%TYPE;
      v_intm_no             gipi_quote_invoice.intm_no%TYPE;
      v_tax_amt             gipi_quote_invoice.tax_amt%TYPE;
      v_tax_cd              gipi_quote_invtax.tax_cd%TYPE;
      v_tax_id              gipi_quote_invtax.tax_id%TYPE;
      v_tax_amt_2           gipi_quote_invtax.tax_amt%TYPE;
      v_rate                gipi_quote_invtax.rate%TYPE;
      v_exists              VARCHAR2 (1)                               := 'N';
      --******************************
--dannel 05/26/2006
/* variables to be used in copying complete information with same line_cd and quote_id

/*******************************with same line_cd****************************/
--gipi_quote_ac_item
      v_ac_quote_id         gipi_quote_ac_item.quote_id%TYPE;
      v_ac_item_no          gipi_quote_ac_item.item_no%TYPE;
      v_ac_persons          gipi_quote_ac_item.no_of_persons%TYPE;
      v_ac_positions        gipi_quote_ac_item.position_cd%TYPE;
      v_ac_monthly          gipi_quote_ac_item.monthly_salary%TYPE;
      v_ac_salary           gipi_quote_ac_item.salary_grade%TYPE;
      v_ac_destination      gipi_quote_ac_item.destination%TYPE;
      v_ac_class            gipi_quote_ac_item.ac_class_cd%TYPE;
      v_ac_age              gipi_quote_ac_item.age%TYPE;
      v_ac_status           gipi_quote_ac_item.civil_status%TYPE;
      v_ac_birth            gipi_quote_ac_item.date_of_birth%TYPE;
      v_ac_print_sw         gipi_quote_ac_item.group_print_sw%TYPE;
      v_ac_height           gipi_quote_ac_item.height%TYPE;
      v_ac_level_cd         gipi_quote_ac_item.level_cd%TYPE;
      v_ac_plevel           gipi_quote_ac_item.parent_level_cd%TYPE;
      v_ac_sex              gipi_quote_ac_item.sex%TYPE;
      v_ac_weight           gipi_quote_ac_item.weight%TYPE;
      ---gipi_quote_item_mc
      v_mc_quote            gipi_quote_item_mc.quote_id%TYPE;
      v_mc_item             gipi_quote_item_mc.item_no%TYPE;
      v_mc_plate            gipi_quote_item_mc.plate_no%TYPE;
      v_mc_motor            gipi_quote_item_mc.motor_no%TYPE;
      v_mc_serial_no        gipi_quote_item_mc.serial_no%TYPE;
      v_mc_subline_type     gipi_quote_item_mc.subline_type_cd%TYPE;
      v_mc_mot_type         gipi_quote_item_mc.mot_type%TYPE;
      v_mc_car              gipi_quote_item_mc.car_company_cd%TYPE;
      v_mc_coc_yy           gipi_quote_item_mc.coc_yy%TYPE;
      v_mc_coc_seq_no       gipi_quote_item_mc.coc_seq_no%TYPE;
      v_mc_coc_serial       gipi_quote_item_mc.coc_serial_no%TYPE;
      v_mc_coc_type         gipi_quote_item_mc.coc_type%TYPE;
      v_mc_repair           gipi_quote_item_mc.repair_lim%TYPE;
      v_mc_color            gipi_quote_item_mc.color%TYPE;
      v_mc_model_year       gipi_quote_item_mc.model_year%TYPE;
      v_mc_make             gipi_quote_item_mc.make%TYPE;
      v_mc_est              gipi_quote_item_mc.est_value%TYPE;
      v_mc_towing           gipi_quote_item_mc.towing%TYPE;
      v_mc_assignee         gipi_quote_item_mc.assignee%TYPE;
      v_mc_no_pass          gipi_quote_item_mc.no_of_pass%TYPE;
      v_mc_tariff           gipi_quote_item_mc.tariff_zone%TYPE;
      v_mc_coc_issue        gipi_quote_item_mc.coc_issue_date%TYPE;
      v_mc_mv               gipi_quote_item_mc.mv_file_no%TYPE;
      v_mc_acquired         gipi_quote_item_mc.acquired_from%TYPE;
      v_mc_ctv              gipi_quote_item_mc.ctv_tag%TYPE;
      v_mc_type             gipi_quote_item_mc.type_of_body_cd%TYPE;
      v_mc_unladen          gipi_quote_item_mc.unladen_wt%TYPE;
      v_mc_make_cd          gipi_quote_item_mc.make_cd%TYPE;
      v_mc_series           gipi_quote_item_mc.series_cd%TYPE;
      v_mc_basic_color      gipi_quote_item_mc.basic_color_cd%TYPE;
      v_mc_color_cd         gipi_quote_item_mc.color_cd%TYPE;
      v_mc_origin           gipi_quote_item_mc.origin%TYPE;
      v_mc_destination      gipi_quote_item_mc.destination%TYPE;
      v_mc_coc_atcn         gipi_quote_item_mc.coc_atcn%TYPE;
      v_mc_subline_cd       gipi_quote_item_mc.subline_cd%TYPE;
      ---gipi_quote_fi_item
      v_fi_quote_id         gipi_quote_fi_item.quote_id%TYPE;
      v_fi_item             gipi_quote_fi_item.item_no%TYPE;
      v_fi_district         gipi_quote_fi_item.district_no%TYPE;
      v_fi_req_zone         gipi_quote_fi_item.eq_zone%TYPE;
      v_fi_tarf             gipi_quote_fi_item.tarf_cd%TYPE;
      v_fi_block_no         gipi_quote_fi_item.block_no%TYPE;
      v_fi_fr               gipi_quote_fi_item.fr_item_type%TYPE;
      v_fi_risk1            gipi_quote_fi_item.loc_risk1%TYPE;
      v_fi_risk2            gipi_quote_fi_item.loc_risk2%TYPE;
      v_fi_risk3            gipi_quote_fi_item.loc_risk3%TYPE;
      v_fi_tariff           gipi_quote_fi_item.tariff_zone%TYPE;
      v_fi_typhoon          gipi_quote_fi_item.typhoon_zone%TYPE;
      v_fi_cons_cd          gipi_quote_fi_item.construction_cd%TYPE;
      v_fi_cons_rem         gipi_quote_fi_item.construction_remarks%TYPE;
      v_fi_front            gipi_quote_fi_item.front%TYPE;
      v_fi_right            gipi_quote_fi_item.RIGHT%TYPE;
      v_fi_left             gipi_quote_fi_item.LEFT%TYPE;
      v_fi_rear             gipi_quote_fi_item.rear%TYPE;
      v_fi_occ_cd           gipi_quote_fi_item.occupancy_cd%TYPE;
      v_fi_occ_rem          gipi_quote_fi_item.occupancy_remarks%TYPE;
      v_fi_flood            gipi_quote_fi_item.flood_zone%TYPE;
      v_fi_assignee         gipi_quote_fi_item.assignee%TYPE;
      v_fi_block            gipi_quote_fi_item.block_id%TYPE;
      v_fi_risk             gipi_quote_fi_item.risk_cd%TYPE;
      ----gipi_quote_en_item
      v_en_quote_id         gipi_quote_en_item.quote_id%TYPE;
      v_en_engg             gipi_quote_en_item.engg_basic_infonum%TYPE;
      v_en_contract         gipi_quote_en_item.contract_proj_buss_title%TYPE;
      v_en_site             gipi_quote_en_item.site_location%TYPE;
      v_en_construct_s      gipi_quote_en_item.construct_start_date%TYPE;
      v_en_construct_e      gipi_quote_en_item.construct_end_date%TYPE;
      v_en_maintain_s       gipi_quote_en_item.maintain_start_date%TYPE;
      v_en_maintain_e       gipi_quote_en_item.maintain_end_date%TYPE;
      v_en_testing_s        gipi_quote_en_item.testing_start_date%TYPE;
      v_en_testing_e        gipi_quote_en_item.testing_end_date%TYPE;
      v_en_weeks            gipi_quote_en_item.weeks_test%TYPE;
      v_en_time             gipi_quote_en_item.time_excess%TYPE;
      v_en_mbi              gipi_quote_en_item.mbi_policy_no%TYPE;
      ---gipi_quote_ca_item
      v_ca_quote_id         gipi_quote_ca_item.quote_id%TYPE;
      v_ca_item             gipi_quote_ca_item.item_no%TYPE;
      v_ca_sec_line         gipi_quote_ca_item.section_line_cd%TYPE;
      v_ca_sec_sub          gipi_quote_ca_item.section_subline_cd%TYPE;
      v_ca_sec_or           gipi_quote_ca_item.section_or_hazard_cd%TYPE;
      v_ca_capacity         gipi_quote_ca_item.capacity_cd%TYPE;
      v_ca_prop             gipi_quote_ca_item.property_no_type%TYPE;
      v_ca_propno           gipi_quote_ca_item.property_no%TYPE;
      v_ca_location         gipi_quote_ca_item.LOCATION%TYPE;
      v_ca_conveyance       gipi_quote_ca_item.conveyance_info%TYPE;
      v_ca_interest         gipi_quote_ca_item.interest_on_premises%TYPE;
      v_ca_limit            gipi_quote_ca_item.limit_of_liability%TYPE;
      v_ca_sec_info         gipi_quote_ca_item.section_or_hazard_info%TYPE;
      ---gipi_quote_cargo
      v_mn_quote_id         gipi_quote_cargo.quote_id%TYPE;
      v_mn_item             gipi_quote_cargo.item_no%TYPE;
      v_mn_vessel           gipi_quote_cargo.vessel_cd%TYPE;
      v_mn_geog_cd          gipi_quote_cargo.geog_cd%TYPE;
      v_mn_cargo            gipi_quote_cargo.cargo_class_cd%TYPE;
      v_mn_voyage           gipi_quote_cargo.voyage_no%TYPE;
      v_mn_bl               gipi_quote_cargo.bl_awb%TYPE;
      v_mn_orig             gipi_quote_cargo.origin%TYPE;
      v_mn_destn            gipi_quote_cargo.destn%TYPE;
      v_mn_etd              gipi_quote_cargo.etd%TYPE;
      v_mn_eta              gipi_quote_cargo.eta%TYPE;
      v_mn_ctype            gipi_quote_cargo.cargo_type%TYPE;
      v_mn_pack             gipi_quote_cargo.pack_method%TYPE;
      v_mn_trans_orig       gipi_quote_cargo.tranship_origin%TYPE;
      v_mn_trans_dest       gipi_quote_cargo.tranship_destination%TYPE;
      v_mn_lc               gipi_quote_cargo.lc_no%TYPE;
      v_mn_print            gipi_quote_cargo.print_tag%TYPE;
      v_mn_deduct           gipi_quote_cargo.deduct_text%TYPE;
      v_mn_rec              gipi_quote_cargo.rec_flag%TYPE;
      ---gipi_quote_av_item
      v_av_quote            gipi_quote_av_item.quote_id%TYPE;
      v_av_item             gipi_quote_av_item.item_no%TYPE;
      v_av_vessel           gipi_quote_av_item.vessel_cd%TYPE;
      v_av_total            gipi_quote_av_item.total_fly_time%TYPE;
      v_av_qualify          gipi_quote_av_item.qualification%TYPE;
      v_av_purpose          gipi_quote_av_item.purpose%TYPE;
      v_av_geog             gipi_quote_av_item.geog_limit%TYPE;
      v_av_deduct           gipi_quote_av_item.deduct_text%TYPE;
      v_av_rec              gipi_quote_av_item.rec_flag%TYPE;
      v_av_fixed            gipi_quote_av_item.fixed_wing%TYPE;
      v_av_rotor            gipi_quote_av_item.rotor%TYPE;
      v_av_prev             gipi_quote_av_item.prev_util_hrs%TYPE;
      v_av_est              gipi_quote_av_item.est_util_hrs%TYPE;
      ---gipi_quote_mh_item
      v_mh_quote            gipi_quote_mh_item.quote_id%TYPE;
      v_mh_item             gipi_quote_mh_item.item_no%TYPE;
      v_mh_vessel           gipi_quote_mh_item.vessel_cd%TYPE;
      v_mh_geog             gipi_quote_mh_item.geog_limit%TYPE;
      v_mh_rec              gipi_quote_mh_item.rec_flag%TYPE;
      v_mh_deduct           gipi_quote_mh_item.deduct_text%TYPE;
      v_mh_ddate            gipi_quote_mh_item.dry_date%TYPE;
      v_mh_dplace           gipi_quote_mh_item.dry_place%TYPE;
      ---gipi_quote_ves_air
      v_vquote              gipi_quote_ves_air.quote_id%TYPE;
      v_vvessel             gipi_quote_ves_air.vessel_cd%TYPE;
      v_vrec                gipi_quote_ves_air.rec_flag%TYPE;
      v_vves                gipi_quote_ves_air.vescon%TYPE;
      v_vvoy                gipi_quote_ves_air.voy_limit%TYPE;
      ---gipi_quote_bond_basic
      v_b_quote             gipi_quote_bond_basic.quote_id%TYPE;
      v_b_oblg              gipi_quote_bond_basic.obligee_no%TYPE;
      v_b_prin              gipi_quote_bond_basic.prin_id%TYPE;
      v_b_vunit             gipi_quote_bond_basic.val_period_unit%TYPE;
      v_b_vperiod           gipi_quote_bond_basic.val_period%TYPE;
      v_b_coll              gipi_quote_bond_basic.coll_flag%TYPE;
      v_b_clause            gipi_quote_bond_basic.clause_type%TYPE;
      v_b_np                gipi_quote_bond_basic.np_no%TYPE;
      v_b_contract          gipi_quote_bond_basic.contract_dtl%TYPE;
      v_b_cdate             gipi_quote_bond_basic.contract_date%TYPE;
      v_b_co                gipi_quote_bond_basic.co_prin_sw%TYPE;
      v_b_waiver            gipi_quote_bond_basic.waiver_limit%TYPE;
      v_b_indemnity         gipi_quote_bond_basic.indemnity_text%TYPE;
      v_b_bond              gipi_quote_bond_basic.bond_dtl%TYPE;
      v_b_endt              gipi_quote_bond_basic.endt_eff_date%TYPE;
      v_b_rem               gipi_quote_bond_basic.remarks%TYPE;
      /*****************regardless of line_cd****************/

      ---gipi_quote_wc
      v_wc_quote            gipi_quote_wc.quote_id%TYPE;
      v_wc_line             gipi_quote_wc.line_cd%TYPE;
      v_wc_cd               gipi_quote_wc.wc_cd%TYPE;
      v_print               gipi_quote_wc.print_seq_no%TYPE;
      v_wc_title            gipi_quote_wc.wc_title%TYPE;
      v_wc_title2           gipi_quote_wc.wc_title2%TYPE;
      v_wc01                gipi_quote_wc.wc_text01%TYPE;
      v_wc02                gipi_quote_wc.wc_text02%TYPE;
      v_wc03                gipi_quote_wc.wc_text03%TYPE;
      v_wc04                gipi_quote_wc.wc_text04%TYPE;
      v_wc05                gipi_quote_wc.wc_text05%TYPE;
      v_wc06                gipi_quote_wc.wc_text06%TYPE;
      v_wc07                gipi_quote_wc.wc_text07%TYPE;
      v_wc08                gipi_quote_wc.wc_text08%TYPE;
      v_wc09                gipi_quote_wc.wc_text09%TYPE;
      v_wc10                gipi_quote_wc.wc_text10%TYPE;
      v_wc11                gipi_quote_wc.wc_text11%TYPE;
      v_wc12                gipi_quote_wc.wc_text12%TYPE;
      v_wc13                gipi_quote_wc.wc_text13%TYPE;
      v_wc14                gipi_quote_wc.wc_text14%TYPE;
      v_wc15                gipi_quote_wc.wc_text15%TYPE;
      v_wc16                gipi_quote_wc.wc_text16%TYPE;
      v_wc17                gipi_quote_wc.wc_text17%TYPE;
      v_wcremarks           gipi_quote_wc.wc_remarks%TYPE;
      v_print_sw            gipi_quote_wc.print_sw%TYPE;
      v_change_tag          gipi_quote_wc.change_tag%TYPE;
      ---gipi_quote_deductibles
      v_d_quote             gipi_quote_deductibles.quote_id%TYPE;
      v_d_item              gipi_quote_deductibles.item_no%TYPE;
      v_d_peril             gipi_quote_deductibles.peril_cd%TYPE;
      v_d_cd                gipi_quote_deductibles.ded_deductible_cd%TYPE;
      v_d_text              gipi_quote_deductibles.deductible_text%TYPE;
      v_d_amt               gipi_quote_deductibles.deductible_rt%TYPE;
      --gipi_quote_cosign
      v_cos_quote_id        gipi_quote_cosign.quote_id%TYPE;
      v_cos_id              gipi_quote_cosign.cosign_id%TYPE;
      v_cos_assd            gipi_quote_cosign.assd_no%TYPE;
      v_cos_indem           gipi_quote_cosign.indem_flag%TYPE;
      v_cos_bond            gipi_quote_cosign.bonds_flag%TYPE;
      v_cos_ri              gipi_quote_cosign.bonds_ri_flag%TYPE;
      --gipi_quote_pictures
      v_pic_quote           gipi_quote_pictures.quote_id%TYPE;
      v_pic_item            gipi_quote_pictures.item_no%TYPE;
      v_pic_fname           gipi_quote_pictures.file_name%TYPE;
      v_pic_type            gipi_quote_pictures.file_type%TYPE;
      v_pic_ext             gipi_quote_pictures.file_ext%TYPE;
      v_pic_rem             gipi_quote_pictures.remarks%TYPE;
      --gipi_quote_item_discount
      v_id_quote            gipi_quote_item_discount.quote_id%TYPE;
      v_id_srt              gipi_quote_item_discount.surcharge_rt%TYPE;
      v_id_samt             gipi_quote_item_discount.surcharge_amt%TYPE;
      v_id_sub              gipi_quote_item_discount.subline_cd%TYPE;
      v_id_seq              gipi_quote_item_discount.SEQUENCE%TYPE;
      v_id_rem              gipi_quote_item_discount.remarks%TYPE;
      v_id_orig             gipi_quote_item_discount.orig_prem_amt%TYPE;
      v_id_neta             gipi_quote_item_discount.net_prem_amt%TYPE;
      v_id_nett             gipi_quote_item_discount.net_gross_tag%TYPE;
      v_id_line             gipi_quote_item_discount.line_cd%TYPE;
      v_id_item             gipi_quote_item_discount.item_no%TYPE;
      v_id_drt              gipi_quote_item_discount.disc_rt%TYPE;
      v_id_damt             gipi_quote_item_discount.disc_amt%TYPE;
      --gipi_quote_peril_discount
      v_pd_quote            gipi_quote_peril_discount.quote_id%TYPE;
      v_pd_item             gipi_quote_peril_discount.item_no%TYPE;
      v_pd_line             gipi_quote_peril_discount.line_cd%TYPE;
      v_pd_peril            gipi_quote_peril_discount.peril_cd%TYPE;
      v_pd_drt              gipi_quote_peril_discount.disc_rt%TYPE;
      v_pd_level            gipi_quote_peril_discount.level_tag%TYPE;
      v_pd_damt             gipi_quote_peril_discount.disc_amt%TYPE;
      v_pd_ngtag            gipi_quote_peril_discount.net_gross_tag%TYPE;
      v_pd_dtag             gipi_quote_peril_discount.discount_tag%TYPE;
      v_pd_sub              gipi_quote_peril_discount.subline_cd%TYPE;
      v_pd_orig             gipi_quote_peril_discount.orig_peril_prem_amt%TYPE;
      v_pd_seq              gipi_quote_peril_discount.SEQUENCE%TYPE;
      v_pd_net              gipi_quote_peril_discount.net_prem_amt%TYPE;
      v_pd_rem              gipi_quote_peril_discount.remarks%TYPE;
      v_pd_srt              gipi_quote_peril_discount.surcharge_rt%TYPE;
      v_pd_samt             gipi_quote_peril_discount.surcharge_amt%TYPE;
      --gipi_quote_polbasic_discount
      v_pol_quote           gipi_quote_polbasic_discount.quote_id%TYPE;
      v_pol_line            gipi_quote_polbasic_discount.line_cd%TYPE;
      v_pol_sub             gipi_quote_polbasic_discount.subline_cd%TYPE;
      v_pol_drt             gipi_quote_polbasic_discount.disc_rt%TYPE;
      v_pol_damt            gipi_quote_polbasic_discount.disc_amt%TYPE;
      v_pol_ngtag           gipi_quote_polbasic_discount.net_gross_tag%TYPE;
      v_pol_orig            gipi_quote_polbasic_discount.orig_prem_amt%TYPE;
      v_pol_seq             gipi_quote_polbasic_discount.SEQUENCE%TYPE;
      v_pol_npa             gipi_quote_polbasic_discount.net_prem_amt%TYPE;
      v_pol_rem             gipi_quote_polbasic_discount.remarks%TYPE;
      v_pol_srt             gipi_quote_polbasic_discount.surcharge_rt%TYPE;
      v_pol_samt            gipi_quote_polbasic_discount.surcharge_amt%TYPE;
      ---gipi_quote_principal
      v_pr_quote            gipi_quote_principal.quote_id%TYPE;
      v_pr_pcd              gipi_quote_principal.principal_cd%TYPE;
      v_pr_engg             gipi_quote_principal.engg_basic_infonum%TYPE;
      v_pr_sub              gipi_quote_principal.subcon_sw%TYPE;
---------************-----------
      v_pack_pol_flag       VARCHAR2 (2);
      v_new_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE;
      v_new_quote_id        gipi_quote.pack_quote_id%TYPE;
      v_quote_id_more       gipi_quote.pack_quote_id%TYPE;    --QUOTE_ID_MORE
   BEGIN
      v_quote_id := p_pack_quote_id;

      /* generate new quote_id */
      BEGIN
         SELECT pack_quote_id_s.NEXTVAL
           INTO v_new_pack_quote_id
           FROM DUAL;

         SELECT quote_quote_id_s.NEXTVAL
           INTO v_new_quote_id
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         /* insert copied values to gipi_pack_quote */
         SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                proposal_no, assd_no, assd_name, tsi_amt,
                prem_amt, remarks, header, footer, status,
                print_tag, incept_date, expiry_date, accept_dt,
                address1, address2, address3, cred_branch,
                acct_of_cd, acct_of_cd_sw, incept_tag, expiry_tag
                                                                 /*added by VJ 110707*/
         ,
                prorate_flag, comp_sw, with_tariff_sw
           /*end VJ*/, underwriter          -- added underwriter : shan 05.07.2014
         INTO   v_line_cd, v_subline_cd, v_iss_cd, v_quotation_yy,
                v_proposal_no, v_assd_no, v_assd_name, v_tsi_amt,
                v_prem_amt, v_remarks, v_header, v_footer, v_status,
                v_print_tag, v_incept_date, v_expiry_date, v_accept_dt,
                v_address1, v_address2, v_address3, v_cred_branch,
                v_acct_of_cd, v_acct_of_cd_sw, v_incept_tag, v_expiry_tag
                                                                         /*added by VJ 110707*/
         ,
                v_prorate_flag, v_comp_sw, v_with_tariff_sw
           /*end VJ*/, v_underwriter        -- added underwriter : shan 05.07.2014 
         FROM   gipi_pack_quote
          WHERE pack_quote_id = p_pack_quote_id;

         -- get new quotation no.
         gipi_quote_pkg.compute_quote_no (v_line_cd,
                                          v_subline_cd,
                                          v_iss_cd,
                                          v_quotation_yy,
                                          v_quotation_no
                                         );
         -- return new quote no
         p_new_quote_no :=
               v_line_cd
            || '-'
            || v_subline_cd
            || '-'
            || v_iss_cd
            || '-'
            || v_quotation_yy
            || '-'
            || TO_CHAR (v_quotation_no, '000009')     -- added to_char : shan 05.07.2014
            || '-'
            || TO_CHAR (v_proposal_no, '009');     -- added to_char : shan 05.07.2014

         INSERT INTO gipi_pack_quote
                     (quotation_no, pack_quote_id, line_cd,
                      subline_cd, iss_cd, quotation_yy, proposal_no, assd_no,
                      assd_name, tsi_amt, prem_amt, remarks,
                      header, footer, status, print_tag,
                      incept_date, expiry_date, last_update, user_id,
                      accept_dt, valid_date, address1, address2,
                      address3, cred_branch, acct_of_cd,
                      acct_of_cd_sw, incept_tag, expiry_tag
                                                           /*added by VJ 110707*/
         ,
                      prorate_flag, comp_sw, with_tariff_sw
                     /*end VJ*/, underwriter   -- added underwriter : shan 05.07.2014
                     )
              VALUES (v_quotation_no, v_new_pack_quote_id, v_line_cd,
                      v_subline_cd, v_iss_cd, v_quotation_yy, 0, v_assd_no,
                      v_assd_name, v_tsi_amt, v_prem_amt, v_remarks,
                      v_header, v_footer, v_status, v_print_tag,
                      v_incept_date, v_expiry_date, SYSDATE, p_user_id, --USER, --editted by MJ for consolidation 01022013 
                      v_accept_dt, SYSDATE + 30, v_address1, v_address2,
                      v_address3, v_cred_branch, v_acct_of_cd,
                      v_acct_of_cd_sw, v_incept_tag, v_expiry_tag
                                                                 /*added by VJ 110707*/
         ,
                      v_prorate_flag, v_comp_sw, v_with_tariff_sw
                     /*end VJ*/, v_underwriter -- added underwriter : shan 05.07.2014
                     );
      -- COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   -- msg_alert ('There is no existing record.', 'I', TRUE);
      END;

/******************************************************/
      BEGIN
         FOR z IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                          proposal_no, assd_no, assd_name, tsi_amt, prem_amt,
                          remarks, header, footer, status, print_tag,
                          incept_date, expiry_date, accept_dt, address1,
                          address2, address3, cred_branch, acct_of_cd,
                          acct_of_cd_sw, incept_tag, expiry_tag,
                          prorate_flag, comp_sw, with_tariff_sw, quote_id
                     FROM gipi_quote
                    WHERE pack_quote_id = p_pack_quote_id)
         LOOP
            -- get new quote no
            compute_quote_no1 (z.line_cd,
                               z.subline_cd,
                               z.iss_cd,
                               z.quotation_yy,
                               z.proposal_no,
                               v_quotation_no1
                              );
            v_line_cd1 := z.line_cd;
            v_subline_cd1 := z.subline_cd;
            v_iss_cd1 := z.iss_cd;
            v_quotation_yy1 := z.quotation_yy;
            v_proposal_no1 := z.proposal_no;
            v_incept_date1 := z.incept_date;
            v_expiry_date1 := z.expiry_date;
            v_assd_no1 := z.assd_no;
            v_assd_name1 := z.assd_name;
            v_tsi_amt := z.tsi_amt;
            v_prem_amt := z.prem_amt;
            v_remarks1 := z.remarks;
            v_header1 := z.header;
            v_footer1 := z.footer;
            v_status1 := z.status;
            v_print_tag1 := z.print_tag;
            v_accept_dt1 := z.accept_dt;
            v_address1_1 := z.address1;
            v_address2_1 := z.address2;
            v_address3_1 := z.address3;
            v_cred_branch1 := z.cred_branch;
            v_acct_of_cd1 := z.acct_of_cd;
            v_acct_of_cd_sw1 := z.acct_of_cd_sw;
            v_incept_tag1 := z.incept_tag;
            v_expiry_tag1 := z.expiry_tag;
            v_prorate_flag1 := z.prorate_flag;
            v_comp_sw1 := z.comp_sw;
            v_with_tariff_sw1 := z.with_tariff_sw;

            IF v_counter = 0
            THEN
               INSERT INTO gipi_quote
                           (quote_id, line_cd, subline_cd,
                            iss_cd, quotation_yy, proposal_no, incept_date,
                            expiry_date, pack_quote_id, last_update,
                            user_id, assd_no, assd_name, tsi_amt,
                            prem_amt, remarks, header, footer,
                            status, print_tag, accept_dt,
                            address1, address2, address3,
                            cred_branch, acct_of_cd, acct_of_cd_sw,
                            incept_tag, expiry_tag, prorate_flag,
                            comp_sw, with_tariff_sw, quotation_no,
                            pack_pol_flag
                           )                --aaron added pack_pol_flag 102508
                    VALUES (v_new_quote_id, v_line_cd1, v_subline_cd1,
                            v_iss_cd1, v_quotation_yy1, 0, v_incept_date1,
                            v_expiry_date1, v_new_pack_quote_id, SYSDATE,
                            /*USER*/ p_user_id, v_assd_no1, v_assd_name1, v_tsi_amt, --editted by MJ for consolidation 01022013
                            v_prem_amt, v_remarks1, v_header1, v_footer1,
                            v_status1, v_print_tag1, v_accept_dt1,
                            v_address1_1, v_address2_1, v_address3_1,
                            v_cred_branch1, v_acct_of_cd1, v_acct_of_cd_sw1,
                            v_incept_tag1, v_expiry_tag1, v_prorate_flag1,
                            v_comp_sw1, v_with_tariff_sw1, v_quotation_no1,
                            'Y'
                           );
            ELSE
               SELECT quote_quote_id_s.NEXTVAL
                 INTO v_quote_id_more
                 FROM DUAL;

               INSERT INTO gipi_quote
                           (quote_id, line_cd, subline_cd,
                            iss_cd, quotation_yy, proposal_no, incept_date,
                            expiry_date, pack_quote_id, last_update,
                            user_id, assd_no, assd_name, tsi_amt,
                            prem_amt, remarks, header, footer,
                            status, print_tag, accept_dt,
                            address1, address2, address3,
                            cred_branch, acct_of_cd, acct_of_cd_sw,
                            incept_tag, expiry_tag, prorate_flag,
                            comp_sw, with_tariff_sw, quotation_no,
                            pack_pol_flag
                           )
                    VALUES (v_quote_id_more, v_line_cd1, v_subline_cd1,
                            v_iss_cd1, v_quotation_yy1, 0, v_incept_date1,
                            v_expiry_date1, v_new_pack_quote_id, SYSDATE,
                            /*USER*/ p_user_id, v_assd_no1, v_assd_name1, v_tsi_amt, --editted by MJ for consolidation 01022013
                            v_prem_amt, v_remarks1, v_header1, v_footer1,
                            v_status1, v_print_tag1, v_accept_dt1,
                            v_address1_1, v_address2_1, v_address3_1,
                            v_cred_branch1, v_acct_of_cd1, v_acct_of_cd_sw1,
                            v_incept_tag1, v_expiry_tag1, v_prorate_flag1,
                            v_comp_sw1, v_with_tariff_sw1, v_quotation_no1,
                            'Y'
                           );               --aaron added pack_pol_flag 102508
            END IF;

            FOR t1 IN (SELECT   quote_id, item_no, item_title, item_desc,
                                currency_cd, currency_rate, pack_line_cd,
                                pack_subline_cd, tsi_amt, prem_amt
                                ,ann_prem_amt, ann_tsi_amt  --Gzelle
                           FROM gipi_quote_item
                          WHERE quote_id = z.quote_id
                       ORDER BY quote_id DESC)
            LOOP
               v_item_no := t1.item_no;
               v_item_title := t1.item_title;
               v_item_desc := t1.item_desc;
               v_currency_cd := t1.currency_cd;
               v_currency_rt := t1.currency_rate;
               v_pack_line_cd := t1.pack_line_cd;
               v_pack_subline_cd := t1.pack_subline_cd;
               v_tsi_amt := t1.tsi_amt;
               v_prem_amt := t1.prem_amt;
               --Gzelle
               v_ann_tsi_amt := t1.ann_tsi_amt;
               v_ann_prem_amt := t1.ann_prem_amt;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_item
                              (quote_id, item_no, item_title,
                               item_desc, currency_cd, currency_rate,
                               pack_line_cd, pack_subline_cd, tsi_amt,
                               prem_amt
                               ,ann_prem_amt, ann_tsi_amt   --Gzelle
                              )
                       VALUES (v_new_quote_id, v_item_no, v_item_title,
                               v_item_desc, v_currency_cd, v_currency_rt,
                               v_pack_line_cd, v_pack_subline_cd, v_tsi_amt,
                               v_prem_amt
                               ,v_ann_prem_amt, v_ann_tsi_amt   --Gzelle
                              );
               ELSE
                  INSERT INTO gipi_quote_item
                              (quote_id, item_no, item_title,
                               item_desc, currency_cd, currency_rate,
                               pack_line_cd, pack_subline_cd, tsi_amt,
                               prem_amt
                               ,ann_prem_amt, ann_tsi_amt --Gzelle
                              )
                       VALUES (v_quote_id_more, v_item_no, v_item_title,
                               v_item_desc, v_currency_cd, v_currency_rt,
                               v_pack_line_cd, v_pack_subline_cd, v_tsi_amt,
                               v_prem_amt
                               ,v_ann_prem_amt, v_ann_tsi_amt   --Gzelle
                              );
               END IF;
            END LOOP;

            FOR m IN (SELECT   item_no, peril_cd, tsi_amt, prem_amt, prem_rt,
                               comp_rem, quote_id
                               ,ann_tsi_amt, ann_prem_amt, line_cd, peril_type  --Gzelle
                          FROM gipi_quote_itmperil
                         WHERE quote_id = z.quote_id
                      ORDER BY quote_id DESC)
            LOOP
               v_temp_id := m.quote_id;
               v_peril_cd := m.peril_cd;
               v_tsi_amt := m.tsi_amt;
               v_prem_amt := m.prem_amt;
               v_prem_rt := m.prem_rt;
               v_comp_rem := m.comp_rem;
               --Gzelle
               v_ann_tsi_amt_itmperil := m.ann_tsi_amt;
               v_ann_prem_amt_itmperil := m.ann_prem_amt;
               v_line_cd_itmperil := m.line_cd;
               v_peril_type_itmperil := m.peril_type;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_itmperil
                              (quote_id, item_no, peril_cd,
                               tsi_amt, prem_amt, prem_rt, comp_rem
                               ,ann_tsi_amt, ann_prem_amt, line_cd, peril_type   --Gzelle
                              )
                       VALUES (v_new_quote_id, v_item_no, v_peril_cd,
                               v_tsi_amt, v_prem_amt, v_prem_rt, v_comp_rem
                               ,v_ann_tsi_amt_itmperil, v_ann_prem_amt_itmperil, v_line_cd_itmperil, v_peril_type_itmperil  --Gzelle
                              );
               ELSE
                  INSERT INTO gipi_quote_itmperil
                              (quote_id, item_no, peril_cd,
                               tsi_amt, prem_amt, prem_rt, comp_rem
                               ,ann_tsi_amt, ann_prem_amt, line_cd, peril_type   --Gzelle
                              )
                       VALUES (v_quote_id_more, v_item_no, v_peril_cd,
                               v_tsi_amt, v_prem_amt, v_prem_rt, v_comp_rem
                               ,v_ann_tsi_amt_itmperil, v_ann_prem_amt_itmperil, v_line_cd_itmperil, v_peril_type_itmperil  --Gzelle
                              );
               END IF;
            END LOOP;

            FOR b IN (SELECT   quote_inv_no, iss_cd, intm_no, currency_cd,
                               currency_rt, prem_amt, tax_amt
                          FROM gipi_quote_invoice
                         WHERE quote_id = z.quote_id
                      ORDER BY quote_id DESC)
            LOOP
               FOR j IN (SELECT quote_inv_no
                           FROM giis_quote_inv_seq
                          WHERE iss_cd = v_iss_cd)
               LOOP
                  v_quote_inv_no := j.quote_inv_no + 1;
                  EXIT;
               END LOOP;

               v_iss_cd := b.iss_cd;
               v_currency_cd := b.currency_cd;
               v_currency_rt := b.currency_rt;
               v_prem_amt := b.prem_amt;
               v_tax_amt := b.tax_amt;
               v_quote_no := b.quote_inv_no;
               v_intm_no := b.intm_no;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_invoice
                              (quote_id, iss_cd, quote_inv_no,
                               intm_no, currency_cd, currency_rt,
                               prem_amt, tax_amt
                              )
                       VALUES (v_new_quote_id, v_iss_cd, v_quote_inv_no,
                               v_intm_no, v_currency_cd, v_currency_rt,
                               v_prem_amt, v_tax_amt
                              );
               ELSE
                  INSERT INTO gipi_quote_invoice
                              (quote_id, iss_cd, quote_inv_no,
                               intm_no, currency_cd, currency_rt,
                               prem_amt, tax_amt
                              )
                       VALUES (v_quote_id_more, v_iss_cd, v_quote_inv_no,
                               v_intm_no, v_currency_cd, v_currency_rt,
                               v_prem_amt, v_tax_amt
                              );
               END IF;
            END LOOP;

            FOR a IN (SELECT menu_line_cd
                        FROM giis_line
                       WHERE line_cd = z.line_cd)
            LOOP
               v_menu_line_cd := a.menu_line_cd;
               EXIT;
            END LOOP;

            IF v_menu_line_cd = 'AC' OR z.line_cd = 'AC'
            THEN
               FOR ac IN (SELECT item_no, no_of_persons, position_cd,
                                 monthly_salary, salary_grade, destination,
                                 ac_class_cd, age, civil_status,
                                 date_of_birth, group_print_sw, height,
                                 level_cd, parent_level_cd sex, weight
                            FROM gipi_quote_ac_item
                           WHERE quote_id = v_temp_quote)
               -- AND item_no = V.item_no)
               LOOP
                  v_ac_item_no := ac.item_no;
                  v_ac_persons := ac.no_of_persons;
                  v_ac_positions := ac.position_cd;
                  v_ac_monthly := ac.monthly_salary;
                  v_ac_salary := ac.salary_grade;
                  v_ac_destination := ac.destination;
                  v_ac_class := ac.ac_class_cd;
                  v_ac_age := ac.age;
                  v_ac_status := ac.civil_status;
                  v_ac_birth := ac.date_of_birth;
                  v_ac_print_sw := ac.group_print_sw;
                  v_ac_height := ac.height;
                  v_ac_level_cd := ac.level_cd;
                  v_ac_sex := ac.sex;
                  v_ac_weight := ac.weight;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ac_item
                                 (quote_id, item_no,
                                  no_of_persons, position_cd,
                                  monthly_salary, salary_grade,
                                  destination, ac_class_cd, age,
                                  civil_status, date_of_birth,
                                  group_print_sw, height, level_cd,
                                  parent_level_cd, sex, weight, user_id,
                                  last_update
                                 )
                          VALUES (v_new_quote_id, v_ac_item_no,
                                  v_ac_persons, v_ac_positions,
                                  v_ac_monthly, v_ac_salary,
                                  v_ac_destination, v_ac_class, v_ac_age,
                                  v_ac_status, v_ac_birth,
                                  v_ac_print_sw, v_ac_height, v_ac_level_cd,
                                  v_ac_plevel, v_ac_sex, v_ac_weight, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ac_item
                                 (quote_id, item_no,
                                  no_of_persons, position_cd,
                                  monthly_salary, salary_grade,
                                  destination, ac_class_cd, age,
                                  civil_status, date_of_birth,
                                  group_print_sw, height, level_cd,
                                  parent_level_cd, sex, weight, user_id,
                                  last_update
                                 )
                          VALUES (v_quote_id_more, v_ac_item_no,
                                  v_ac_persons, v_ac_positions,
                                  v_ac_monthly, v_ac_salary,
                                  v_ac_destination, v_ac_class, v_ac_age,
                                  v_ac_status, v_ac_birth,
                                  v_ac_print_sw, v_ac_height, v_ac_level_cd,
                                  v_ac_plevel, v_ac_sex, v_ac_weight, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'MC' OR z.line_cd = 'MC'
            THEN
               FOR mc IN (SELECT item_no, plate_no, motor_no, serial_no,
                                 subline_type_cd, mot_type, car_company_cd,
                                 coc_yy, coc_seq_no, coc_serial_no, coc_type,
                                 repair_lim, color, model_year, make,
                                 est_value, towing, assignee, no_of_pass,
                                 tariff_zone, coc_issue_date, mv_file_no,
                                 acquired_from, ctv_tag, type_of_body_cd,
                                 unladen_wt, make_cd, series_cd,
                                 basic_color_cd, color_cd, origin,
                                 destination, coc_atcn, subline_cd
                            FROM gipi_quote_item_mc
                           WHERE quote_id = z.quote_id)
               -- AND item_no = V.item_no)
               LOOP
                  v_mc_item := mc.item_no;
                  v_mc_plate := mc.plate_no;
                  v_mc_motor := mc.motor_no;
                  v_mc_serial_no := mc.serial_no;
                  v_mc_subline_type := mc.subline_type_cd;
                  v_mc_mot_type := mc.mot_type;
                  v_mc_car := mc.car_company_cd;
                  v_mc_coc_yy := mc.coc_yy;
                  v_mc_coc_seq_no := mc.coc_seq_no;
                  v_mc_coc_serial := mc.coc_serial_no;
                  v_mc_coc_type := mc.coc_type;
                  v_mc_repair := mc.repair_lim;
                  v_mc_color := mc.color;
                  v_mc_model_year := mc.model_year;
                  v_mc_make := mc.make;
                  v_mc_est := mc.est_value;
                  v_mc_towing := mc.towing;
                  v_mc_assignee := mc.assignee;
                  v_mc_no_pass := mc.no_of_pass;
                  v_mc_tariff := mc.tariff_zone;
                  v_mc_coc_issue := mc.coc_issue_date;
                  v_mc_mv := mc.mv_file_no;
                  v_mc_acquired := mc.acquired_from;
                  v_mc_ctv := mc.ctv_tag;
                  v_mc_type := mc.type_of_body_cd;
                  v_mc_unladen := mc.unladen_wt;
                  v_mc_make_cd := mc.make_cd;
                  v_mc_series := mc.series_cd;
                  v_mc_basic_color := mc.basic_color_cd;
                  v_mc_color_cd := mc.color_cd;
                  v_mc_origin := mc.origin;
                  v_mc_destination := mc.destination;
                  v_mc_coc_atcn := mc.coc_atcn;
                  v_mc_subline_cd := mc.subline_cd;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_item_mc
                                 (quote_id, item_no, plate_no,
                                  motor_no, serial_no,
                                  subline_type_cd, mot_type,
                                  car_company_cd, coc_yy, coc_seq_no,
                                  coc_serial_no, coc_type,
                                  repair_lim, color, model_year,
                                  make, est_value, towing,
                                  assignee, no_of_pass, tariff_zone,
                                  coc_issue_date, mv_file_no, acquired_from,
                                  ctv_tag, type_of_body_cd, unladen_wt,
                                  make_cd, series_cd,
                                  basic_color_cd, color_cd,
                                  origin, destination,
                                  coc_atcn, subline_cd, user_id,
                                  last_update
                                 )
                          VALUES (v_new_quote_id, v_mc_item, v_mc_plate,
                                  v_mc_motor, v_mc_serial_no,
                                  v_mc_subline_type, v_mc_mot_type,
                                  v_mc_car, v_mc_coc_yy, v_mc_coc_seq_no,
                                  v_mc_coc_serial, v_mc_coc_type,
                                  v_mc_repair, v_mc_color, v_mc_model_year,
                                  v_mc_make, v_mc_est, v_mc_towing,
                                  v_mc_assignee, v_mc_no_pass, v_mc_tariff,
                                  v_mc_coc_issue, v_mc_mv, v_mc_acquired,
                                  v_mc_ctv, v_mc_type, v_mc_unladen,
                                  v_mc_make_cd, v_mc_series,
                                  v_mc_basic_color, v_mc_color_cd,
                                  v_mc_origin, v_mc_destination,
                                  v_mc_coc_atcn, v_mc_subline_cd, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  ELSE
                     INSERT INTO gipi_quote_item_mc
                                 (quote_id, item_no, plate_no,
                                  motor_no, serial_no,
                                  subline_type_cd, mot_type,
                                  car_company_cd, coc_yy, coc_seq_no,
                                  coc_serial_no, coc_type,
                                  repair_lim, color, model_year,
                                  make, est_value, towing,
                                  assignee, no_of_pass, tariff_zone,
                                  coc_issue_date, mv_file_no, acquired_from,
                                  ctv_tag, type_of_body_cd, unladen_wt,
                                  make_cd, series_cd,
                                  basic_color_cd, color_cd,
                                  origin, destination,
                                  coc_atcn, subline_cd, user_id,
                                  last_update
                                 )
                          VALUES (v_quote_id_more, v_mc_item, v_mc_plate,
                                  v_mc_motor, v_mc_serial_no,
                                  v_mc_subline_type, v_mc_mot_type,
                                  v_mc_car, v_mc_coc_yy, v_mc_coc_seq_no,
                                  v_mc_coc_serial, v_mc_coc_type,
                                  v_mc_repair, v_mc_color, v_mc_model_year,
                                  v_mc_make, v_mc_est, v_mc_towing,
                                  v_mc_assignee, v_mc_no_pass, v_mc_tariff,
                                  v_mc_coc_issue, v_mc_mv, v_mc_acquired,
                                  v_mc_ctv, v_mc_type, v_mc_unladen,
                                  v_mc_make_cd, v_mc_series,
                                  v_mc_basic_color, v_mc_color_cd,
                                  v_mc_origin, v_mc_destination,
                                  v_mc_coc_atcn, v_mc_subline_cd, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'FI' OR z.line_cd = 'FI'
            THEN
               FOR fi IN (SELECT item_no, district_no, eq_zone, tarf_cd,
                                 block_no, fr_item_type, loc_risk1,
                                 loc_risk2, loc_risk3, tariff_zone,
                                 typhoon_zone, construction_cd,
                                 construction_remarks, front, RIGHT, LEFT,
                                 rear, occupancy_cd, occupancy_remarks,
                                 flood_zone, assignee, block_id, risk_cd
                            FROM gipi_quote_fi_item
                           WHERE quote_id = z.quote_id)
               --AND item_no = V.item_no)
               LOOP
                  v_fi_item := fi.item_no;
                  v_fi_district := fi.district_no;
                  v_fi_req_zone := fi.eq_zone;
                  v_fi_tarf := fi.tarf_cd;
                  v_fi_block_no := fi.block_no;
                  v_fi_fr := fi.fr_item_type;
                  v_fi_risk1 := fi.loc_risk1;
                  v_fi_risk2 := fi.loc_risk2;
                  v_fi_risk3 := fi.loc_risk3;
                  v_fi_tariff := fi.tariff_zone;
                  v_fi_typhoon := fi.typhoon_zone;
                  v_fi_cons_cd := fi.construction_cd;
                  v_fi_cons_rem := fi.construction_remarks;
                  v_fi_front := fi.front;
                  v_fi_right := fi.RIGHT;
                  v_fi_left := fi.LEFT;
                  v_fi_rear := fi.rear;
                  v_fi_occ_cd := fi.occupancy_cd;
                  v_fi_occ_rem := fi.occupancy_remarks;
                  v_fi_flood := fi.flood_zone;
                  v_fi_assignee := fi.assignee;
                  v_fi_block := fi.block_id;
                  v_fi_risk := fi.risk_cd;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_fi_item
                                 (quote_id, item_no, district_no,
                                  eq_zone, tarf_cd, block_no,
                                  fr_item_type, loc_risk1, loc_risk2,
                                  loc_risk3, tariff_zone, typhoon_zone,
                                  construction_cd, construction_remarks,
                                  front, RIGHT, LEFT,
                                  rear, occupancy_cd, occupancy_remarks,
                                  flood_zone, assignee, block_id,
                                  risk_cd, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_fi_item, v_fi_district,
                                  v_fi_req_zone, v_fi_tarf, v_fi_block_no,
                                  v_fi_fr, v_fi_risk1, v_fi_risk2,
                                  v_fi_risk3, v_fi_tariff, v_fi_typhoon,
                                  v_fi_cons_cd, v_fi_cons_rem,
                                  v_fi_front, v_fi_right, v_fi_left,
                                  v_fi_rear, v_fi_occ_cd, v_fi_occ_rem,
                                  v_fi_flood, v_fi_assignee, v_fi_block,
                                  v_fi_risk, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_fi_item
                                 (quote_id, item_no, district_no,
                                  eq_zone, tarf_cd, block_no,
                                  fr_item_type, loc_risk1, loc_risk2,
                                  loc_risk3, tariff_zone, typhoon_zone,
                                  construction_cd, construction_remarks,
                                  front, RIGHT, LEFT,
                                  rear, occupancy_cd, occupancy_remarks,
                                  flood_zone, assignee, block_id,
                                  risk_cd, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_fi_item, v_fi_district,
                                  v_fi_req_zone, v_fi_tarf, v_fi_block_no,
                                  v_fi_fr, v_fi_risk1, v_fi_risk2,
                                  v_fi_risk3, v_fi_tariff, v_fi_typhoon,
                                  v_fi_cons_cd, v_fi_cons_rem,
                                  v_fi_front, v_fi_right, v_fi_left,
                                  v_fi_rear, v_fi_occ_cd, v_fi_occ_rem,
                                  v_fi_flood, v_fi_assignee, v_fi_block,
                                  v_fi_risk, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --**
            ELSIF v_menu_line_cd = 'EN' OR z.line_cd = 'EN'
            THEN
               FOR en IN (SELECT engg_basic_infonum,
                                 contract_proj_buss_title, site_location,
                                 construct_start_date, construct_end_date,
                                 maintain_start_date, maintain_end_date,
                                 testing_start_date, testing_end_date,
                                 weeks_test, time_excess, mbi_policy_no
                            FROM gipi_quote_en_item
                           WHERE quote_id = z.quote_id)
               -- AND item_no = V.item_no)
               LOOP
                  v_en_engg := en.engg_basic_infonum;
                  v_en_contract := en.contract_proj_buss_title;
                  v_en_site := en.site_location;
                  v_en_construct_s := en.construct_start_date;
                  v_en_construct_e := en.construct_end_date;
                  v_en_maintain_s := en.maintain_start_date;
                  v_en_maintain_e := en.maintain_end_date;
                  v_en_testing_s := en.testing_start_date;
                  v_en_testing_e := en.testing_end_date;
                  v_en_weeks := en.weeks_test;
                  v_en_time := en.time_excess;
                  v_en_mbi := en.mbi_policy_no;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_en_item
                                 (quote_id, engg_basic_infonum,
                                  contract_proj_buss_title, site_location,
                                  construct_start_date, construct_end_date,
                                  maintain_start_date, maintain_end_date,
                                  testing_start_date, testing_end_date,
                                  weeks_test, time_excess, mbi_policy_no,
                                  user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_en_engg,
                                  v_en_contract, v_en_site,
                                  v_en_construct_s, v_en_construct_e,
                                  v_en_maintain_s, v_en_maintain_e,
                                  v_en_testing_s, v_en_testing_e,
                                  v_en_weeks, v_en_time, v_en_mbi,
                                  /*USER*/ p_user_id, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_en_item
                                 (quote_id, engg_basic_infonum,
                                  contract_proj_buss_title, site_location,
                                  construct_start_date, construct_end_date,
                                  maintain_start_date, maintain_end_date,
                                  testing_start_date, testing_end_date,
                                  weeks_test, time_excess, mbi_policy_no,
                                  user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_en_engg,
                                  v_en_contract, v_en_site,
                                  v_en_construct_s, v_en_construct_e,
                                  v_en_maintain_s, v_en_maintain_e,
                                  v_en_testing_s, v_en_testing_e,
                                  v_en_weeks, v_en_time, v_en_mbi,
                                  /*USER*/ p_user_id, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'CA' OR z.line_cd = 'CA'
            THEN
               FOR ca IN (SELECT item_no, section_line_cd,
                                 section_subline_cd, section_or_hazard_cd,
                                 capacity_cd, property_no_type, property_no,
                                 LOCATION, conveyance_info,
                                 interest_on_premises, limit_of_liability,
                                 section_or_hazard_info
                            FROM gipi_quote_ca_item
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_ca_item := ca.item_no;
                  v_ca_sec_line := ca.section_line_cd;
                  v_ca_sec_sub := ca.section_subline_cd;
                  v_ca_sec_or := ca.section_or_hazard_cd;
                  v_ca_capacity := ca.capacity_cd;
                  v_ca_prop := ca.property_no_type;
                  v_ca_propno := ca.property_no;
                  v_ca_location := ca.LOCATION;
                  v_ca_conveyance := ca.conveyance_info;
                  v_ca_interest := ca.interest_on_premises;
                  v_ca_limit := ca.limit_of_liability;
                  v_ca_sec_info := ca.section_or_hazard_info;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ca_item
                                 (quote_id, item_no, section_line_cd,
                                  section_subline_cd, section_or_hazard_cd,
                                  capacity_cd, property_no_type,
                                  property_no, LOCATION,
                                  conveyance_info, interest_on_premises,
                                  limit_of_liability,
                                  section_or_hazard_info, user_id,
                                  last_update
                                 )
                          VALUES (v_new_quote_id, v_ca_item, v_ca_sec_line,
                                  v_ca_sec_sub, v_ca_sec_or,
                                  v_ca_capacity, v_ca_prop,
                                  v_ca_propno, v_ca_location,
                                  v_ca_conveyance, v_ca_interest,
                                  v_ca_limit,
                                  v_ca_sec_info, p_user_id,
                                  SYSDATE
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ca_item
                                 (quote_id, item_no, section_line_cd,
                                  section_subline_cd, section_or_hazard_cd,
                                  capacity_cd, property_no_type,
                                  property_no, LOCATION,
                                  conveyance_info, interest_on_premises,
                                  limit_of_liability,
                                  section_or_hazard_info, user_id,
                                  last_update
                                 )
                          VALUES (v_quote_id_more, v_ca_item, v_ca_sec_line,
                                  v_ca_sec_sub, v_ca_sec_or,
                                  v_ca_capacity, v_ca_prop,
                                  v_ca_propno, v_ca_location,
                                  v_ca_conveyance, v_ca_interest,
                                  v_ca_limit,
                                  v_ca_sec_info, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'MN' OR z.line_cd = 'MN'
            THEN
               FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                             FROM gipi_quote_ves_air
                            WHERE quote_id = z.quote_id)
               --AND item_no = V.item_no)
               LOOP
                  v_vvessel := ves.vessel_cd;
                  v_vrec := ves.rec_flag;
                  v_vves := ves.vescon;
                  v_vvoy := ves.voy_limit;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag, vescon,
                                  voy_limit
                                 )
                          VALUES (v_new_quote_id, v_vvessel, v_vrec, v_vves,
                                  v_vvoy
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag,
                                  vescon, voy_limit
                                 )
                          VALUES (v_quote_id_more, v_vvessel, v_vrec,
                                  v_vves, v_vvoy
                                 );
                  END IF;
               END LOOP;

               FOR mn IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                                 voyage_no, bl_awb, origin, destn, etd, eta,
                                 cargo_type, pack_method, tranship_origin,
                                 tranship_destination, lc_no, print_tag,
                                 deduct_text, rec_flag
                            FROM gipi_quote_cargo
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_mn_item := mn.item_no;
                  v_mn_vessel := mn.vessel_cd;
                  v_mn_geog_cd := mn.geog_cd;
                  v_mn_cargo := mn.cargo_class_cd;
                  v_mn_voyage := mn.voyage_no;
                  v_mn_bl := mn.bl_awb;
                  v_mn_orig := mn.origin;
                  v_mn_destn := mn.destn;
                  v_mn_etd := mn.etd;
                  v_mn_eta := mn.eta;
                  v_mn_ctype := mn.cargo_type;
                  v_mn_pack := mn.pack_method;
                  v_mn_trans_orig := mn.tranship_origin;
                  v_mn_trans_dest := mn.tranship_destination;
                  v_mn_lc := mn.lc_no;
                  v_mn_print := mn.print_tag;
                  v_mn_deduct := mn.deduct_text;
                  v_mn_rec := mn.rec_flag;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_cargo
                                 (quote_id, item_no, vessel_cd,
                                  geog_cd, cargo_class_cd, voyage_no,
                                  bl_awb, origin, destn, etd,
                                  eta, cargo_type, pack_method,
                                  tranship_origin, tranship_destination,
                                  lc_no, print_tag, deduct_text,
                                  rec_flag, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_mn_item, v_mn_vessel,
                                  v_mn_geog_cd, v_mn_cargo, v_mn_voyage,
                                  v_mn_bl, v_mn_orig, v_mn_destn, v_mn_etd,
                                  v_mn_eta, v_mn_ctype, v_mn_pack,
                                  v_mn_trans_orig, v_mn_trans_dest,
                                  v_mn_lc, v_mn_print, v_mn_deduct,
                                  v_mn_rec, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_cargo
                                 (quote_id, item_no, vessel_cd,
                                  geog_cd, cargo_class_cd, voyage_no,
                                  bl_awb, origin, destn, etd,
                                  eta, cargo_type, pack_method,
                                  tranship_origin, tranship_destination,
                                  lc_no, print_tag, deduct_text,
                                  rec_flag, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_mn_item, v_mn_vessel,
                                  v_mn_geog_cd, v_mn_cargo, v_mn_voyage,
                                  v_mn_bl, v_mn_orig, v_mn_destn, v_mn_etd,
                                  v_mn_eta, v_mn_ctype, v_mn_pack,
                                  v_mn_trans_orig, v_mn_trans_dest,
                                  v_mn_lc, v_mn_print, v_mn_deduct,
                                  v_mn_rec, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'AV' OR z.line_cd = 'AV'
            THEN
               FOR av IN (SELECT item_no, vessel_cd, total_fly_time,
                                 qualification, purpose, geog_limit,
                                 deduct_text, rec_flag, fixed_wing, rotor,
                                 prev_util_hrs, est_util_hrs
                            FROM gipi_quote_av_item
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_av_item := av.item_no;
                  v_av_vessel := av.vessel_cd;
                  v_av_total := av.total_fly_time;
                  v_av_qualify := av.qualification;
                  v_av_purpose := av.purpose;
                  v_av_geog := av.geog_limit;
                  v_av_deduct := av.deduct_text;
                  v_av_rec := av.rec_flag;
                  v_av_fixed := av.fixed_wing;
                  v_av_rotor := av.rotor;
                  v_av_prev := av.prev_util_hrs;
                  v_av_est := av.est_util_hrs;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_av_item
                                 (quote_id, item_no, vessel_cd,
                                  total_fly_time, qualification, purpose,
                                  geog_limit, deduct_text, rec_flag,
                                  fixed_wing, rotor, prev_util_hrs,
                                  est_util_hrs, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_av_item, v_av_vessel,
                                  v_av_total, v_av_qualify, v_av_purpose,
                                  v_av_geog, v_av_deduct, v_av_rec,
                                  v_av_fixed, v_av_rotor, v_av_prev,
                                  v_av_est, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_av_item
                                 (quote_id, item_no, vessel_cd,
                                  total_fly_time, qualification, purpose,
                                  geog_limit, deduct_text, rec_flag,
                                  fixed_wing, rotor, prev_util_hrs,
                                  est_util_hrs, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_av_item, v_av_vessel,
                                  v_av_total, v_av_qualify, v_av_purpose,
                                  v_av_geog, v_av_deduct, v_av_rec,
                                  v_av_fixed, v_av_rotor, v_av_prev,
                                  v_av_est, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'MH' OR z.line_cd = 'MH'
            THEN
               FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                             FROM gipi_quote_ves_air
                            WHERE quote_id = z.quote_id)
               --AND item_no = V.item_no)
               LOOP
                  v_vvessel := ves.vessel_cd;
                  v_vrec := ves.rec_flag;
                  v_vves := ves.vescon;
                  v_vvoy := ves.voy_limit;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag, vescon,
                                  voy_limit
                                 )
                          VALUES (v_new_quote_id, v_vvessel, v_vrec, v_vves,
                                  v_vvoy
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag,
                                  vescon, voy_limit
                                 )
                          VALUES (v_quote_id_more, v_vvessel, v_vrec,
                                  v_vves, v_vvoy
                                 );
                  END IF;
               END LOOP;

               FOR mh IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                                 deduct_text, dry_date, dry_place
                            FROM gipi_quote_mh_item
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_mh_item := mh.item_no;
                  v_mh_vessel := mh.vessel_cd;
                  v_mh_geog := mh.geog_limit;
                  v_mh_rec := mh.rec_flag;
                  v_mh_deduct := mh.deduct_text;
                  v_mh_ddate := mh.dry_date;
                  v_mh_dplace := mh.dry_place;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_mh_item
                                 (quote_id, item_no, vessel_cd,
                                  geog_limit, rec_flag, deduct_text,
                                  dry_date, dry_place, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_mh_item, v_mh_vessel,
                                  v_mh_geog, v_mh_rec, v_mh_deduct,
                                  v_mh_ddate, v_mh_dplace, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_mh_item
                                 (quote_id, item_no, vessel_cd,
                                  geog_limit, rec_flag, deduct_text,
                                  dry_date, dry_place, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_mh_item, v_mh_vessel,
                                  v_mh_geog, v_mh_rec, v_mh_deduct,
                                  v_mh_ddate, v_mh_dplace, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'SU' OR z.line_cd = 'SU'
            THEN
               FOR su IN (SELECT obligee_no, prin_id, val_period_unit,
                                 val_period, coll_flag, clause_type, np_no,
                                 contract_dtl, contract_date, co_prin_sw,
                                 waiver_limit, indemnity_text, bond_dtl,
                                 endt_eff_date, remarks
                            FROM gipi_quote_bond_basic
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_b_oblg := su.obligee_no;
                  v_b_prin := su.prin_id;
                  v_b_vunit := su.val_period_unit;
                  v_b_vperiod := su.val_period;
                  v_b_coll := su.coll_flag;
                  v_b_clause := su.clause_type;
                  v_b_np := su.np_no;
                  v_b_contract := su.contract_dtl;
                  v_b_cdate := su.contract_date;
                  v_b_co := su.co_prin_sw;
                  v_b_waiver := su.waiver_limit;
                  v_b_indemnity := su.indemnity_text;
                  v_b_bond := su.bond_dtl;
                  v_b_endt := su.endt_eff_date;
                  v_b_rem := su.remarks;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_bond_basic
                                 (quote_id, obligee_no, prin_id,
                                  val_period_unit, val_period, coll_flag,
                                  clause_type, np_no, contract_dtl,
                                  contract_date, co_prin_sw, waiver_limit,
                                  indemnity_text, bond_dtl, endt_eff_date,
                                  remarks
                                 )
                          VALUES (v_new_quote_id, v_b_oblg, v_b_prin,
                                  v_b_vunit, v_b_vperiod, v_b_coll,
                                  v_b_clause, v_b_np, v_b_contract,
                                  v_b_cdate, v_b_co, v_b_waiver,
                                  v_b_indemnity, v_b_bond, v_b_endt,
                                  v_b_rem
                                 );
                  ELSE
                     INSERT INTO gipi_quote_bond_basic
                                 (quote_id, obligee_no, prin_id,
                                  val_period_unit, val_period, coll_flag,
                                  clause_type, np_no, contract_dtl,
                                  contract_date, co_prin_sw, waiver_limit,
                                  indemnity_text, bond_dtl, endt_eff_date,
                                  remarks
                                 )
                          VALUES (v_quote_id_more, v_b_oblg, v_b_prin,
                                  v_b_vunit, v_b_vperiod, v_b_coll,
                                  v_b_clause, v_b_np, v_b_contract,
                                  v_b_cdate, v_b_co, v_b_waiver,
                                  v_b_indemnity, v_b_bond, v_b_endt,
                                  v_b_rem
                                 );
                  END IF;
               END LOOP;
            END IF;

            -- end of long if statement
            FOR wc IN (SELECT line_cd, wc_cd, print_seq_no, wc_title,
                              wc_title2, wc_text01, wc_text02, wc_text03,
                              wc_text04, wc_text05, wc_text06, wc_text07,
                              wc_text08, wc_text09, wc_text10, wc_text11,
                              wc_text12, wc_text13, wc_text14, wc_text15,
                              wc_text16, wc_text17, wc_remarks, print_sw,
                              change_tag
                         FROM gipi_quote_wc
                        WHERE quote_id = z.quote_id)
            LOOP
               v_wc_line := wc.line_cd;
               v_wc_cd := wc.wc_cd;
               v_print := wc.print_seq_no;
               v_wc_title := wc.wc_title;
               v_wc_title2 := wc.wc_title2;
               v_wc01 := wc.wc_text01;
               v_wc02 := wc.wc_text02;
               v_wc03 := wc.wc_text03;
               v_wc04 := wc.wc_text04;
               v_wc05 := wc.wc_text05;
               v_wc06 := wc.wc_text06;
               v_wc07 := wc.wc_text07;
               v_wc08 := wc.wc_text08;
               v_wc09 := wc.wc_text09;
               v_wc10 := wc.wc_text10;
               v_wc11 := wc.wc_text11;
               v_wc12 := wc.wc_text12;
               v_wc13 := wc.wc_text13;
               v_wc14 := wc.wc_text14;
               v_wc15 := wc.wc_text15;
               v_wc16 := wc.wc_text16;
               v_wc17 := wc.wc_text17;
               v_wcremarks := wc.wc_remarks;
               v_print_sw := wc.print_sw;
               v_change_tag := wc.change_tag;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_wc
                              (quote_id, line_cd, wc_cd, print_seq_no,
                               wc_title, wc_title2, wc_text01, wc_text02,
                               wc_text03, wc_text04, wc_text05, wc_text06,
                               wc_text07, wc_text08, wc_text09, wc_text10,
                               wc_text11, wc_text12, wc_text13, wc_text14,
                               wc_text15, wc_text16, wc_text17, wc_remarks,
                               print_sw, change_tag, user_id, last_update
                              )
                       VALUES (v_new_quote_id, v_wc_line, v_wc_cd, v_print,
                               v_wc_title, v_wc_title2, v_wc01, v_wc02,
                               v_wc03, v_wc04, v_wc05, v_wc06,
                               v_wc07, v_wc08, v_wc09, v_wc10,
                               v_wc11, v_wc12, v_wc13, v_wc14,
                               v_wc15, v_wc16, v_wc17, v_wcremarks,
                               v_print_sw, v_change_tag, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                              );
               ELSE
                  INSERT INTO gipi_quote_wc
                              (quote_id, line_cd, wc_cd, print_seq_no,
                               wc_title, wc_title2, wc_text01, wc_text02,
                               wc_text03, wc_text04, wc_text05, wc_text06,
                               wc_text07, wc_text08, wc_text09, wc_text10,
                               wc_text11, wc_text12, wc_text13, wc_text14,
                               wc_text15, wc_text16, wc_text17, wc_remarks,
                               print_sw, change_tag, user_id, last_update
                              )
                       VALUES (v_quote_id_more, v_wc_line, v_wc_cd, v_print,
                               v_wc_title, v_wc_title2, v_wc01, v_wc02,
                               v_wc03, v_wc04, v_wc05, v_wc06,
                               v_wc07, v_wc08, v_wc09, v_wc10,
                               v_wc11, v_wc12, v_wc13, v_wc14,
                               v_wc15, v_wc16, v_wc17, v_wcremarks,
                               v_print_sw, v_change_tag, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                              );
               END IF;
            END LOOP;

            BEGIN
               SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                      bonds_ri_flag
                 INTO v_cos_id, v_cos_assd, v_cos_indem, v_cos_bond,
                      v_cos_ri
                 FROM gipi_quote_cosign
                WHERE quote_id = z.quote_id;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_cosign
                              (quote_id, cosign_id, assd_no,
                               indem_flag, bonds_flag, bonds_ri_flag
                              )
                       VALUES (v_new_quote_id, v_cos_id, v_cos_assd,
                               v_cos_indem, v_cos_bond, v_cos_ri
                              );
               ELSE                                                  --COMMIT;
                  INSERT INTO gipi_quote_cosign
                              (quote_id, cosign_id, assd_no,
                               indem_flag, bonds_flag, bonds_ri_flag
                              )
                       VALUES (v_quote_id_more, v_cos_id, v_cos_assd,
                               v_cos_indem, v_cos_bond, v_cos_ri
                              );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            FOR idis IN (SELECT surcharge_rt, surcharge_amt, subline_cd,
                                SEQUENCE, remarks, orig_prem_amt,
                                net_prem_amt, net_gross_tag, line_cd, item_no,
                                disc_rt, disc_amt
                           FROM gipi_quote_item_discount
                          WHERE quote_id = z.quote_id)
            LOOP
               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_item_discount
                              (quote_id, surcharge_rt,
                               surcharge_amt, subline_cd,
                               SEQUENCE, remarks,
                               orig_prem_amt, net_prem_amt,
                               net_gross_tag, line_cd,
                               item_no, disc_rt, disc_amt,
                               last_update
                              )
                       VALUES (v_new_quote_id, idis.surcharge_rt,
                               idis.surcharge_amt, idis.subline_cd,
                               idis.SEQUENCE, idis.remarks,
                               idis.orig_prem_amt, idis.net_prem_amt,
                               idis.net_gross_tag, idis.line_cd,
                               idis.item_no, idis.disc_rt, idis.disc_amt,
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_item_discount
                              (quote_id, surcharge_rt,
                               surcharge_amt, subline_cd,
                               SEQUENCE, remarks,
                               orig_prem_amt, net_prem_amt,
                               net_gross_tag, line_cd,
                               item_no, disc_rt, disc_amt,
                               last_update
                              )
                       VALUES (v_quote_id_more, idis.surcharge_rt,
                               idis.surcharge_amt, idis.subline_cd,
                               idis.SEQUENCE, idis.remarks,
                               idis.orig_prem_amt, idis.net_prem_amt,
                               idis.net_gross_tag, idis.line_cd,
                               idis.item_no, idis.disc_rt, idis.disc_amt,
                               SYSDATE
                              );
               END IF;
            END LOOP;

            BEGIN
               SELECT line_cd, subline_cd, disc_rt, disc_amt,
                      net_gross_tag, orig_prem_amt, SEQUENCE, net_prem_amt,
                      remarks, surcharge_rt, surcharge_amt
                 INTO v_pol_line, v_pol_sub, v_pol_drt, v_pol_damt,
                      v_pol_ngtag, v_pol_orig, v_pol_seq, v_pol_npa,
                      v_pol_rem, v_pol_srt, v_pol_samt
                 FROM gipi_quote_polbasic_discount
                WHERE quote_id = z.quote_id;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_polbasic_discount
                              (quote_id, line_cd, subline_cd,
                               disc_rt, disc_amt, net_gross_tag,
                               orig_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_new_quote_id, v_pol_line, v_pol_sub,
                               v_pol_drt, v_pol_damt, v_pol_ngtag,
                               v_pol_orig, v_pol_seq, v_pol_npa,
                               v_pol_rem, v_pol_srt, v_pol_samt,
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_polbasic_discount
                              (quote_id, line_cd, subline_cd,
                               disc_rt, disc_amt, net_gross_tag,
                               orig_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_quote_id_more, v_pol_line, v_pol_sub,
                               v_pol_drt, v_pol_damt, v_pol_ngtag,
                               v_pol_orig, v_pol_seq, v_pol_npa,
                               v_pol_rem, v_pol_srt, v_pol_samt,
                               SYSDATE
                              );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            --added by aaron 102508 to include mortgagee
            BEGIN
               FOR mort IN (SELECT iss_cd, item_no, mortg_cd, amount,
                                   remarks
                              FROM gipi_quote_mortgagee
                             WHERE quote_id = z.quote_id)
               LOOP
                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_mortgagee
                                 (quote_id, iss_cd, item_no,
                                  mortg_cd, amount, remarks,
                                  last_update, user_id
                                 )
                          VALUES (v_new_quote_id, mort.iss_cd, mort.item_no,
                                  mort.mortg_cd, mort.amount, mort.remarks,
                                  SYSDATE, p_user_id --USER --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_mortgagee
                                 (quote_id, iss_cd,
                                  item_no, mortg_cd, amount,
                                  remarks, last_update, user_id
                                 )
                          VALUES (v_quote_id_more, mort.iss_cd,
                                  mort.item_no, mort.mortg_cd, mort.amount,
                                  mort.remarks, SYSDATE, p_user_id --USER --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            END;

            BEGIN
               SELECT principal_cd, engg_basic_infonum, subcon_sw
                 INTO v_pr_pcd, v_pr_engg, v_pr_sub
                 FROM gipi_quote_principal
                WHERE quote_id = z.quote_id;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_principal
                              (quote_id, principal_cd, engg_basic_infonum,
                               subcon_sw
                              )
                       VALUES (v_new_quote_id, v_pr_pcd, v_pr_engg,
                               v_pr_sub
                              );
               --COMMIT;
               ELSE
                  INSERT INTO gipi_quote_principal
                              (quote_id, principal_cd, engg_basic_infonum,
                               subcon_sw
                              )
                       VALUES (v_quote_id_more, v_pr_pcd, v_pr_engg,
                               v_pr_sub
                              );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            FOR pic IN (SELECT item_no, file_name, file_type, file_ext,
                               remarks
                          FROM gipi_quote_pictures
                         WHERE quote_id = z.quote_id)
            LOOP
               v_pic_item := pic.item_no;
               v_pic_fname := pic.file_name;
               v_pic_type := pic.file_type;
               v_pic_ext := pic.file_ext;
               v_pic_rem := pic.remarks;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_pictures
                              (quote_id, item_no, file_name,
                               file_type, file_ext, remarks, user_id,
                               last_update
                              )
                       VALUES (v_new_quote_id, v_pic_item, v_pic_fname,
                               v_pic_type, v_pic_ext, v_pic_rem, p_user_id, --USER, --editted by MJ for consolidation 01022013
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_pictures
                              (quote_id, item_no, file_name,
                               file_type, file_ext, remarks, user_id,
                               last_update
                              )
                       VALUES (v_quote_id_more, v_pic_item, v_pic_fname,
                               v_pic_type, v_pic_ext, v_pic_rem, p_user_id, --USER, --editted by MJ for consolidation 01022013
                               SYSDATE
                              );
               END IF;
            END LOOP;

            FOR d IN (SELECT item_no, peril_cd, ded_deductible_cd,
                             deductible_text, deductible_rt
                        FROM gipi_quote_deductibles
                       WHERE quote_id = z.quote_id)
            LOOP
               v_d_item := d.item_no;
               v_d_peril := d.peril_cd;
               v_d_cd := d.ded_deductible_cd;
               v_d_text := d.deductible_text;
               v_d_amt := d.deductible_rt;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_deductibles
                              (quote_id, item_no, peril_cd,
                               ded_deductible_cd, deductible_text,
                               deductible_rt, user_id, last_update
                              )
                       VALUES (v_new_quote_id, v_d_item, v_d_peril,
                               v_d_cd, v_d_text,
                               v_d_amt, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                              );
               ELSE
                  INSERT INTO gipi_quote_deductibles
                              (quote_id, item_no, peril_cd,
                               ded_deductible_cd, deductible_text,
                               deductible_rt, user_id, last_update
                              )
                       VALUES (v_quote_id_more, v_d_item, v_d_peril,
                               v_d_cd, v_d_text,
                               v_d_amt, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                              );
               END IF;
            END LOOP;

            FOR pd IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                              disc_amt, net_gross_tag, discount_tag,
                              subline_cd, orig_peril_prem_amt, SEQUENCE,
                              net_prem_amt, remarks, surcharge_rt,
                              surcharge_amt
                         FROM gipi_quote_peril_discount
                        WHERE quote_id = z.quote_id)
            LOOP
               v_pd_item := pd.item_no;
               v_pd_line := pd.line_cd;
               v_pd_peril := pd.peril_cd;
               v_pd_drt := pd.disc_rt;
               v_pd_level := pd.level_tag;
               v_pd_damt := pd.disc_amt;
               v_pd_ngtag := pd.net_gross_tag;
               v_pd_dtag := pd.discount_tag;
               v_pd_sub := pd.subline_cd;
               v_pd_orig := pd.orig_peril_prem_amt;
               v_pd_seq := pd.SEQUENCE;
               v_pd_net := pd.net_prem_amt;
               v_pd_rem := pd.remarks;
               v_pd_srt := pd.surcharge_rt;
               v_pd_samt := pd.surcharge_amt;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_peril_discount
                              (quote_id, item_no, line_cd,
                               peril_cd, disc_rt, level_tag, disc_amt,
                               net_gross_tag, discount_tag, subline_cd,
                               orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_new_quote_id, v_pd_item, v_pd_line,
                               v_pd_peril, v_pd_drt, v_pd_level, v_pd_damt,
                               v_pd_ngtag, v_pd_dtag, v_pd_sub,
                               v_pd_orig, v_pd_seq, v_pd_net,
                               v_pd_rem, v_pd_srt, v_pd_samt,
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_peril_discount
                              (quote_id, item_no, line_cd,
                               peril_cd, disc_rt, level_tag, disc_amt,
                               net_gross_tag, discount_tag, subline_cd,
                               orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_quote_id_more, v_pd_item, v_pd_line,
                               v_pd_peril, v_pd_drt, v_pd_level, v_pd_damt,
                               v_pd_ngtag, v_pd_dtag, v_pd_sub,
                               v_pd_orig, v_pd_seq, v_pd_net,
                               v_pd_rem, v_pd_srt, v_pd_samt,
                               SYSDATE
                              );
               END IF;
            END LOOP;

            v_counter := v_counter + 1;
         -- end of main loop
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;    --msg_alert ('There is no existing record.', 'I', TRUE);
      END;                                                -- long begin to end
   END;

      PROCEDURE duplicate_gipi_pack_quote (
      p_pack_quote_id         gipi_pack_quote.pack_quote_id%TYPE,
      p_new_quote_no    OUT   VARCHAR2,
      p_user_id               gipi_pack_quote.user_id%TYPE
   )
   IS
      v_quote_no1           NUMBER;
      v_temp_quote          NUMBER;
      v_temp_line_cd        VARCHAR2 (2);
      v_line_cd             gipi_quote.line_cd%TYPE;
      v_subline_cd          gipi_quote.subline_cd%TYPE;
      v_iss_cd              gipi_quote.iss_cd%TYPE;
      v_quotation_yy        gipi_quote.quotation_yy%TYPE;
      v_quotation_no        gipi_quote.quotation_no%TYPE;
      v_proposal_no         gipi_quote.proposal_no%TYPE;
      v_new_proposal_no     gipi_quote.proposal_no%TYPE;
      v_assd_no             gipi_quote.assd_no%TYPE;
      v_assd_name           gipi_quote.assd_name%TYPE;
      v_remarks             gipi_quote.remarks%TYPE;
      v_header              gipi_quote.header%TYPE;
      v_footer              gipi_quote.footer%TYPE;
      v_status              gipi_quote.status%TYPE;
      v_print_tag           gipi_quote.print_tag%TYPE;
      v_item_no             gipi_quote_item.item_no%TYPE;
      v_item_title          gipi_quote_item.item_title%TYPE;
      v_item_desc           gipi_quote_item.item_desc%TYPE;
      v_currency_cd         gipi_quote_item.currency_cd%TYPE;
      v_currency_rt         gipi_quote_item.currency_rate%TYPE;
      v_pack_line_cd        gipi_quote_item.pack_line_cd%TYPE;
      v_pack_subline_cd     gipi_quote_item.pack_subline_cd%TYPE;
      v_coverage_cd_itm     gipi_quote_item.coverage_cd%TYPE;       --
      v_ann_prem_amt_itm    gipi_quote_item.ann_prem_amt%TYPE;      --
      v_ann_tsi_amt_itm     gipi_quote_item.ann_tsi_amt%TYPE;       --
      v_item_desc2_itm      gipi_quote_item.item_desc2%TYPE;        --
      v_item_no1            gipi_quote_itmperil.item_no%TYPE;   
      v_peril_cd            gipi_quote_itmperil.peril_cd%TYPE;
      v_tsi_amt             gipi_quote_itmperil.tsi_amt%TYPE;
      v_prem_amt            gipi_quote_itmperil.prem_amt%TYPE;
      v_prem_rt             gipi_quote_itmperil.prem_rt%TYPE;
      v_comp_rem            gipi_quote_itmperil.comp_rem%TYPE;
      v_ann_prem_amt_itmprl gipi_quote_itmperil.ann_prem_amt%TYPE;  --
      v_ann_tsi_amt_itmprl  gipi_quote_itmperil.ann_tsi_amt%TYPE;   --
      v_line_cd_itmprl      gipi_quote_itmperil.line_cd%TYPE;       --
      v_peril_type_itmprl   gipi_quote_itmperil.peril_type%TYPE;    --
      v_incept_date         gipi_quote.incept_date%TYPE;
      v_expiry_date         gipi_quote.expiry_date%TYPE;
      v_incept_tag          gipi_quote.incept_tag%TYPE;
      v_expiry_tag          gipi_quote.expiry_tag%TYPE;
      v_cred_branch         gipi_quote.cred_branch%TYPE;
      v_acct_of_cd          gipi_quote.acct_of_cd%TYPE;
      v_acct_of_cd_sw       gipi_quote.acct_of_cd_sw%TYPE;
      v_accept_dt           gipi_quote.accept_dt%TYPE;
      v_address1            gipi_quote.address1%TYPE;
      v_address2            gipi_quote.address2%TYPE;
      v_address3            gipi_quote.address3%TYPE;
      v_valid_date          gipi_quote.valid_date%TYPE;
      v_quote_id            NUMBER;
      p_exists              VARCHAR2 (1)                               := 'N';
      v_quote_inv_no        gipi_quote_invoice.quote_inv_no%TYPE;
      v_intm_no             gipi_quote_invoice.intm_no%TYPE;
      v_tax_amt             gipi_quote_invoice.tax_amt%TYPE;
      v_quote_no            NUMBER;
      v_quote_inv_no_tax    gipi_quote_invoice.quote_inv_no%TYPE;
      v_tax_cd              gipi_quote_invtax.tax_cd%TYPE;
      v_tax_id              gipi_quote_invtax.tax_id%TYPE;
      v_tax_amt_2           gipi_quote_invtax.tax_amt%TYPE;
      v_rate                gipi_quote_invtax.rate%TYPE;
      v_line_cd_inv_tax     gipi_quote_invtax.line_cd%TYPE;     --
      v_iss_cd_inv_tax      gipi_quote_invtax.iss_cd%TYPE;      --
      v_fxd_tax_alloc_inv   gipi_quote_invtax.fixed_tax_allocation%TYPE;      --
      v_item_grp_inv_tax    gipi_quote_invtax.item_grp%TYPE;    --
      v_tax_alloc_inv_tax   gipi_quote_invtax.tax_allocation%TYPE;     --
      v_exists              VARCHAR2 (1)                               := 'N';
      v_menu_line_cd        giis_line.menu_line_cd%TYPE;
      v_underwriter         gipi_pack_quote.UNDERWRITER%type;           -- shan 05.07.2014
      --***********************gipi_quote ANTHONY SANTOS 03/13/08*****************
      v_counter             NUMBER                                       := 0;
      v_line_cd1            gipi_quote.line_cd%TYPE;
      v_subline_cd1         gipi_quote.subline_cd%TYPE;
      v_iss_cd1             gipi_quote.iss_cd%TYPE;
      v_quotation_yy1       gipi_quote.quotation_yy%TYPE;
      v_quotation_no1       gipi_quote.quotation_no%TYPE;
      v_proposal_no1        gipi_quote.proposal_no%TYPE;
      v_new_proposal_no1    gipi_quote.proposal_no%TYPE;
      v_assd_no1            gipi_quote.assd_no%TYPE;
      v_assd_name1          gipi_quote.assd_name%TYPE;
      v_remarks1            gipi_quote.remarks%TYPE;
      v_header1             gipi_quote.header%TYPE;
      v_footer1             gipi_quote.footer%TYPE;
      v_status1             gipi_quote.status%TYPE;
      v_print_tag1          gipi_quote.print_tag%TYPE;
      v_incept_date1        gipi_quote.incept_date%TYPE;
      v_expiry_date1        gipi_quote.expiry_date%TYPE;
      v_accept_dt1          gipi_quote.accept_dt%TYPE;
      v_incept_tag1         gipi_quote.incept_tag%TYPE;
      v_expiry_tag1         gipi_quote.expiry_tag%TYPE;
      v_address1_1          gipi_quote.address1%TYPE;
      v_address2_1          gipi_quote.address2%TYPE;
      v_address3_1          gipi_quote.address3%TYPE;
      v_acct_of_cd1         gipi_quote.acct_of_cd%TYPE;
      v_acct_of_cd_sw1      gipi_quote.acct_of_cd_sw%TYPE;
      v_cred_branch1        gipi_quote.cred_branch%TYPE;
      v_valid_date1         gipi_quote.valid_date%TYPE;
      v_prorate_flag1       gipi_quote.prorate_flag%TYPE;
      v_comp_sw1            gipi_quote.comp_sw%TYPE;
      v_with_tariff_sw1     gipi_quote.with_tariff_sw%TYPE;
--    v_tsi_amt                 gipi_quote_itmperil.tsi_amt%TYPE;
--    v_prem_amt             gipi_quote_itmperil.prem_amt%TYPE;
      v_quote_id1           NUMBER (12);
      v_menu_line_cd1       giis_line.menu_line_cd%TYPE;
 --******************************
--dannel 05/26/2006
/* variables to be used in copying complete information with same line_cd and quote_id

/*******************************with same line_cd****************************/
--gipi_quote_ac_item
      v_ac_quote_id         gipi_quote_ac_item.quote_id%TYPE;
      v_ac_item_no          gipi_quote_ac_item.item_no%TYPE;
      v_ac_persons          gipi_quote_ac_item.no_of_persons%TYPE;
      v_ac_positions        gipi_quote_ac_item.position_cd%TYPE;
      v_ac_monthly          gipi_quote_ac_item.monthly_salary%TYPE;
      v_ac_salary           gipi_quote_ac_item.salary_grade%TYPE;
      v_ac_destination      gipi_quote_ac_item.destination%TYPE;
      v_ac_class            gipi_quote_ac_item.ac_class_cd%TYPE;
      v_ac_age              gipi_quote_ac_item.age%TYPE;
      v_ac_status           gipi_quote_ac_item.civil_status%TYPE;
      v_ac_birth            gipi_quote_ac_item.date_of_birth%TYPE;
      v_ac_print_sw         gipi_quote_ac_item.group_print_sw%TYPE;
      v_ac_height           gipi_quote_ac_item.height%TYPE;
      v_ac_level_cd         gipi_quote_ac_item.level_cd%TYPE;
      v_ac_plevel           gipi_quote_ac_item.parent_level_cd%TYPE;
      v_ac_sex              gipi_quote_ac_item.sex%TYPE;
      v_ac_weight           gipi_quote_ac_item.weight%TYPE;
      ---gipi_quote_item_mc
      v_mc_quote            gipi_quote_item_mc.quote_id%TYPE;
      v_mc_item             gipi_quote_item_mc.item_no%TYPE;
      v_mc_plate            gipi_quote_item_mc.plate_no%TYPE;
      v_mc_motor            gipi_quote_item_mc.motor_no%TYPE;
      v_mc_serial_no        gipi_quote_item_mc.serial_no%TYPE;
      v_mc_subline_type     gipi_quote_item_mc.subline_type_cd%TYPE;
      v_mc_mot_type         gipi_quote_item_mc.mot_type%TYPE;
      v_mc_car              gipi_quote_item_mc.car_company_cd%TYPE;
      v_mc_coc_yy           gipi_quote_item_mc.coc_yy%TYPE;
      v_mc_coc_seq_no       gipi_quote_item_mc.coc_seq_no%TYPE;
      v_mc_coc_serial       gipi_quote_item_mc.coc_serial_no%TYPE;
      v_mc_coc_type         gipi_quote_item_mc.coc_type%TYPE;
      v_mc_repair           gipi_quote_item_mc.repair_lim%TYPE;
      v_mc_color            gipi_quote_item_mc.color%TYPE;
      v_mc_model_year       gipi_quote_item_mc.model_year%TYPE;
      v_mc_make             gipi_quote_item_mc.make%TYPE;
      v_mc_est              gipi_quote_item_mc.est_value%TYPE;
      v_mc_towing           gipi_quote_item_mc.towing%TYPE;
      v_mc_assignee         gipi_quote_item_mc.assignee%TYPE;
      v_mc_no_pass          gipi_quote_item_mc.no_of_pass%TYPE;
      v_mc_tariff           gipi_quote_item_mc.tariff_zone%TYPE;
      v_mc_coc_issue        gipi_quote_item_mc.coc_issue_date%TYPE;
      v_mc_mv               gipi_quote_item_mc.mv_file_no%TYPE;
      v_mc_acquired         gipi_quote_item_mc.acquired_from%TYPE;
      v_mc_ctv              gipi_quote_item_mc.ctv_tag%TYPE;
      v_mc_type             gipi_quote_item_mc.type_of_body_cd%TYPE;
      v_mc_unladen          gipi_quote_item_mc.unladen_wt%TYPE;
      v_mc_make_cd          gipi_quote_item_mc.make_cd%TYPE;
      v_mc_series           gipi_quote_item_mc.series_cd%TYPE;
      v_mc_basic_color      gipi_quote_item_mc.basic_color_cd%TYPE;
      v_mc_color_cd         gipi_quote_item_mc.color_cd%TYPE;
      v_mc_origin           gipi_quote_item_mc.origin%TYPE;
      v_mc_destination      gipi_quote_item_mc.destination%TYPE;
      v_mc_coc_atcn         gipi_quote_item_mc.coc_atcn%TYPE;
      v_mc_subline_cd       gipi_quote_item_mc.subline_cd%TYPE;
      ---gipi_quote_fi_item
      v_fi_quote_id         gipi_quote_fi_item.quote_id%TYPE;
      v_fi_item             gipi_quote_fi_item.item_no%TYPE;
      v_fi_district         gipi_quote_fi_item.district_no%TYPE;
      v_fi_req_zone         gipi_quote_fi_item.eq_zone%TYPE;
      v_fi_tarf             gipi_quote_fi_item.tarf_cd%TYPE;
      v_fi_block_no         gipi_quote_fi_item.block_no%TYPE;
      v_fi_fr               gipi_quote_fi_item.fr_item_type%TYPE;
      v_fi_risk1            gipi_quote_fi_item.loc_risk1%TYPE;
      v_fi_risk2            gipi_quote_fi_item.loc_risk2%TYPE;
      v_fi_risk3            gipi_quote_fi_item.loc_risk3%TYPE;
      v_fi_tariff           gipi_quote_fi_item.tariff_zone%TYPE;
      v_fi_typhoon          gipi_quote_fi_item.typhoon_zone%TYPE;
      v_fi_cons_cd          gipi_quote_fi_item.construction_cd%TYPE;
      v_fi_cons_rem         gipi_quote_fi_item.construction_remarks%TYPE;
      v_fi_front            gipi_quote_fi_item.front%TYPE;
      v_fi_right            gipi_quote_fi_item.RIGHT%TYPE;
      v_fi_left             gipi_quote_fi_item.LEFT%TYPE;
      v_fi_rear             gipi_quote_fi_item.rear%TYPE;
      v_fi_occ_cd           gipi_quote_fi_item.occupancy_cd%TYPE;
      v_fi_occ_rem          gipi_quote_fi_item.occupancy_remarks%TYPE;
      v_fi_flood            gipi_quote_fi_item.flood_zone%TYPE;
      v_fi_assignee         gipi_quote_fi_item.assignee%TYPE;
      v_fi_block            gipi_quote_fi_item.block_id%TYPE;
      v_fi_risk             gipi_quote_fi_item.risk_cd%TYPE;
      v_fi_date_from        gipi_quote_fi_item.date_from%TYPE;      --
      v_fi_date_to          gipi_quote_fi_item.date_to%TYPE;        --
      ----gipi_quote_en_item
      v_en_quote_id         gipi_quote_en_item.quote_id%TYPE;
      v_en_engg             gipi_quote_en_item.engg_basic_infonum%TYPE;
      v_en_contract         gipi_quote_en_item.contract_proj_buss_title%TYPE;
      v_en_site             gipi_quote_en_item.site_location%TYPE;
      v_en_construct_s      gipi_quote_en_item.construct_start_date%TYPE;
      v_en_construct_e      gipi_quote_en_item.construct_end_date%TYPE;
      v_en_maintain_s       gipi_quote_en_item.maintain_start_date%TYPE;
      v_en_maintain_e       gipi_quote_en_item.maintain_end_date%TYPE;
      v_en_testing_s        gipi_quote_en_item.testing_start_date%TYPE;
      v_en_testing_e        gipi_quote_en_item.testing_end_date%TYPE;
      v_en_weeks            gipi_quote_en_item.weeks_test%TYPE;
      v_en_time             gipi_quote_en_item.time_excess%TYPE;
      v_en_mbi              gipi_quote_en_item.mbi_policy_no%TYPE;
      ---gipi_quote_ca_item
      v_ca_quote_id         gipi_quote_ca_item.quote_id%TYPE;
      v_ca_item             gipi_quote_ca_item.item_no%TYPE;
      v_ca_sec_line         gipi_quote_ca_item.section_line_cd%TYPE;
      v_ca_sec_sub          gipi_quote_ca_item.section_subline_cd%TYPE;
      v_ca_sec_or           gipi_quote_ca_item.section_or_hazard_cd%TYPE;
      v_ca_capacity         gipi_quote_ca_item.capacity_cd%TYPE;
      v_ca_prop             gipi_quote_ca_item.property_no_type%TYPE;
      v_ca_propno           gipi_quote_ca_item.property_no%TYPE;
      v_ca_location         gipi_quote_ca_item.LOCATION%TYPE;
      v_ca_conveyance       gipi_quote_ca_item.conveyance_info%TYPE;
      v_ca_interest         gipi_quote_ca_item.interest_on_premises%TYPE;
      v_ca_limit            gipi_quote_ca_item.limit_of_liability%TYPE;
      v_ca_sec_info         gipi_quote_ca_item.section_or_hazard_info%TYPE;
      ---gipi_quote_cargo
      v_mn_quote_id         gipi_quote_cargo.quote_id%TYPE;
      v_mn_item             gipi_quote_cargo.item_no%TYPE;
      v_mn_vessel           gipi_quote_cargo.vessel_cd%TYPE;
      v_mn_geog_cd          gipi_quote_cargo.geog_cd%TYPE;
      v_mn_cargo            gipi_quote_cargo.cargo_class_cd%TYPE;
      v_mn_voyage           gipi_quote_cargo.voyage_no%TYPE;
      v_mn_bl               gipi_quote_cargo.bl_awb%TYPE;
      v_mn_orig             gipi_quote_cargo.origin%TYPE;
      v_mn_destn            gipi_quote_cargo.destn%TYPE;
      v_mn_etd              gipi_quote_cargo.etd%TYPE;
      v_mn_eta              gipi_quote_cargo.eta%TYPE;
      v_mn_ctype            gipi_quote_cargo.cargo_type%TYPE;
      v_mn_pack             gipi_quote_cargo.pack_method%TYPE;
      v_mn_trans_orig       gipi_quote_cargo.tranship_origin%TYPE;
      v_mn_trans_dest       gipi_quote_cargo.tranship_destination%TYPE;
      v_mn_lc               gipi_quote_cargo.lc_no%TYPE;
      v_mn_print            gipi_quote_cargo.print_tag%TYPE;
      v_mn_deduct           gipi_quote_cargo.deduct_text%TYPE;
      v_mn_rec              gipi_quote_cargo.rec_flag%TYPE;
      ---gipi_quote_av_item
      v_av_quote            gipi_quote_av_item.quote_id%TYPE;
      v_av_item             gipi_quote_av_item.item_no%TYPE;
      v_av_vessel           gipi_quote_av_item.vessel_cd%TYPE;
      v_av_total            gipi_quote_av_item.total_fly_time%TYPE;
      v_av_qualify          gipi_quote_av_item.qualification%TYPE;
      v_av_purpose          gipi_quote_av_item.purpose%TYPE;
      v_av_geog             gipi_quote_av_item.geog_limit%TYPE;
      v_av_deduct           gipi_quote_av_item.deduct_text%TYPE;
      v_av_rec              gipi_quote_av_item.rec_flag%TYPE;
      v_av_fixed            gipi_quote_av_item.fixed_wing%TYPE;
      v_av_rotor            gipi_quote_av_item.rotor%TYPE;
      v_av_prev             gipi_quote_av_item.prev_util_hrs%TYPE;
      v_av_est              gipi_quote_av_item.est_util_hrs%TYPE;
      ---gipi_quote_mh_item
      v_mh_quote            gipi_quote_mh_item.quote_id%TYPE;
      v_mh_item             gipi_quote_mh_item.item_no%TYPE;
      v_mh_vessel           gipi_quote_mh_item.vessel_cd%TYPE;
      v_mh_geog             gipi_quote_mh_item.geog_limit%TYPE;
      v_mh_rec              gipi_quote_mh_item.rec_flag%TYPE;
      v_mh_deduct           gipi_quote_mh_item.deduct_text%TYPE;
      v_mh_ddate            gipi_quote_mh_item.dry_date%TYPE;
      v_mh_dplace           gipi_quote_mh_item.dry_place%TYPE;
      ---gipi_quote_ves_air
      v_vquote              gipi_quote_ves_air.quote_id%TYPE;
      v_vvessel             gipi_quote_ves_air.vessel_cd%TYPE;
      v_vrec                gipi_quote_ves_air.rec_flag%TYPE;
      v_vves                gipi_quote_ves_air.vescon%TYPE;
      v_vvoy                gipi_quote_ves_air.voy_limit%TYPE;
      ---gipi_quote_bond_basic
      v_b_quote             gipi_quote_bond_basic.quote_id%TYPE;
      v_b_oblg              gipi_quote_bond_basic.obligee_no%TYPE;
      v_b_prin              gipi_quote_bond_basic.prin_id%TYPE;
      v_b_vunit             gipi_quote_bond_basic.val_period_unit%TYPE;
      v_b_vperiod           gipi_quote_bond_basic.val_period%TYPE;
      v_b_coll              gipi_quote_bond_basic.coll_flag%TYPE;
      v_b_clause            gipi_quote_bond_basic.clause_type%TYPE;
      v_b_np                gipi_quote_bond_basic.np_no%TYPE;
      v_b_contract          gipi_quote_bond_basic.contract_dtl%TYPE;
      v_b_cdate             gipi_quote_bond_basic.contract_date%TYPE;
      v_b_co                gipi_quote_bond_basic.co_prin_sw%TYPE;
      v_b_waiver            gipi_quote_bond_basic.waiver_limit%TYPE;
      v_b_indemnity         gipi_quote_bond_basic.indemnity_text%TYPE;
      v_b_bond              gipi_quote_bond_basic.bond_dtl%TYPE;
      v_b_endt              gipi_quote_bond_basic.endt_eff_date%TYPE;
      v_b_rem               gipi_quote_bond_basic.remarks%TYPE;
      /*****************regardless of line_cd****************/

      ---gipi_quote_wc
      v_wc_quote            gipi_quote_wc.quote_id%TYPE;
      v_wc_line             gipi_quote_wc.line_cd%TYPE;
      v_wc_cd               gipi_quote_wc.wc_cd%TYPE;
      v_print               gipi_quote_wc.print_seq_no%TYPE;
      v_wc_title            gipi_quote_wc.wc_title%TYPE;
      v_wc_title2           gipi_quote_wc.wc_title2%TYPE;
      v_wc01                gipi_quote_wc.wc_text01%TYPE;
      v_wc02                gipi_quote_wc.wc_text02%TYPE;
      v_wc03                gipi_quote_wc.wc_text03%TYPE;
      v_wc04                gipi_quote_wc.wc_text04%TYPE;
      v_wc05                gipi_quote_wc.wc_text05%TYPE;
      v_wc06                gipi_quote_wc.wc_text06%TYPE;
      v_wc07                gipi_quote_wc.wc_text07%TYPE;
      v_wc08                gipi_quote_wc.wc_text08%TYPE;
      v_wc09                gipi_quote_wc.wc_text09%TYPE;
      v_wc10                gipi_quote_wc.wc_text10%TYPE;
      v_wc11                gipi_quote_wc.wc_text11%TYPE;
      v_wc12                gipi_quote_wc.wc_text12%TYPE;
      v_wc13                gipi_quote_wc.wc_text13%TYPE;
      v_wc14                gipi_quote_wc.wc_text14%TYPE;
      v_wc15                gipi_quote_wc.wc_text15%TYPE;
      v_wc16                gipi_quote_wc.wc_text16%TYPE;
      v_wc17                gipi_quote_wc.wc_text17%TYPE;
      v_wcremarks           gipi_quote_wc.wc_remarks%TYPE;
      v_print_sw            gipi_quote_wc.print_sw%TYPE;
      v_change_tag          gipi_quote_wc.change_tag%TYPE;
      ---gipi_quote_deductibles
      v_d_quote             gipi_quote_deductibles.quote_id%TYPE;
      v_d_item              gipi_quote_deductibles.item_no%TYPE;
      v_d_peril             gipi_quote_deductibles.peril_cd%TYPE;
      v_d_cd                gipi_quote_deductibles.ded_deductible_cd%TYPE;
      v_d_text              gipi_quote_deductibles.deductible_text%TYPE;
      v_d_amt               gipi_quote_deductibles.deductible_rt%TYPE;
      v_d_deduct_amt        gipi_quote_deductibles.deductible_amt%TYPE; --
      --gipi_quote_cosign
      v_cos_quote_id        gipi_quote_cosign.quote_id%TYPE;
      v_cos_id              gipi_quote_cosign.cosign_id%TYPE;
      v_cos_assd            gipi_quote_cosign.assd_no%TYPE;
      v_cos_indem           gipi_quote_cosign.indem_flag%TYPE;
      v_cos_bond            gipi_quote_cosign.bonds_flag%TYPE;
      v_cos_ri              gipi_quote_cosign.bonds_ri_flag%TYPE;
      --gipi_quote_pictures
      v_pic_quote           gipi_quote_pictures.quote_id%TYPE;
      v_pic_item            gipi_quote_pictures.item_no%TYPE;
      v_pic_fname           gipi_quote_pictures.file_name%TYPE;
      v_pic_type            gipi_quote_pictures.file_type%TYPE;
      v_pic_ext             gipi_quote_pictures.file_ext%TYPE;
      v_pic_rem             gipi_quote_pictures.remarks%TYPE;
      --gipi_quote_item_discount
      v_id_quote            gipi_quote_item_discount.quote_id%TYPE;
      v_id_srt              gipi_quote_item_discount.surcharge_rt%TYPE;
      v_id_samt             gipi_quote_item_discount.surcharge_amt%TYPE;
      v_id_sub              gipi_quote_item_discount.subline_cd%TYPE;
      v_id_seq              gipi_quote_item_discount.SEQUENCE%TYPE;
      v_id_rem              gipi_quote_item_discount.remarks%TYPE;
      v_id_orig             gipi_quote_item_discount.orig_prem_amt%TYPE;
      v_id_neta             gipi_quote_item_discount.net_prem_amt%TYPE;
      v_id_nett             gipi_quote_item_discount.net_gross_tag%TYPE;
      v_id_line             gipi_quote_item_discount.line_cd%TYPE;
      v_id_item             gipi_quote_item_discount.item_no%TYPE;
      v_id_drt              gipi_quote_item_discount.disc_rt%TYPE;
      v_id_damt             gipi_quote_item_discount.disc_amt%TYPE;
      --gipi_quote_peril_discount
      v_pd_quote            gipi_quote_peril_discount.quote_id%TYPE;
      v_pd_item             gipi_quote_peril_discount.item_no%TYPE;
      v_pd_line             gipi_quote_peril_discount.line_cd%TYPE;
      v_pd_peril            gipi_quote_peril_discount.peril_cd%TYPE;
      v_pd_drt              gipi_quote_peril_discount.disc_rt%TYPE;
      v_pd_level            gipi_quote_peril_discount.level_tag%TYPE;
      v_pd_damt             gipi_quote_peril_discount.disc_amt%TYPE;
      v_pd_ngtag            gipi_quote_peril_discount.net_gross_tag%TYPE;
      v_pd_dtag             gipi_quote_peril_discount.discount_tag%TYPE;
      v_pd_sub              gipi_quote_peril_discount.subline_cd%TYPE;
      v_pd_orig             gipi_quote_peril_discount.orig_peril_prem_amt%TYPE;
      v_pd_seq              gipi_quote_peril_discount.SEQUENCE%TYPE;
      v_pd_net              gipi_quote_peril_discount.net_prem_amt%TYPE;
      v_pd_rem              gipi_quote_peril_discount.remarks%TYPE;
      v_pd_srt              gipi_quote_peril_discount.surcharge_rt%TYPE;
      v_pd_samt             gipi_quote_peril_discount.surcharge_amt%TYPE;
      --gipi_quote_polbasic_discount
      v_pol_quote           gipi_quote_polbasic_discount.quote_id%TYPE;
      v_pol_line            gipi_quote_polbasic_discount.line_cd%TYPE;
      v_pol_sub             gipi_quote_polbasic_discount.subline_cd%TYPE;
      v_pol_drt             gipi_quote_polbasic_discount.disc_rt%TYPE;
      v_pol_damt            gipi_quote_polbasic_discount.disc_amt%TYPE;
      v_pol_ngtag           gipi_quote_polbasic_discount.net_gross_tag%TYPE;
      v_pol_orig            gipi_quote_polbasic_discount.orig_prem_amt%TYPE;
      v_pol_seq             gipi_quote_polbasic_discount.SEQUENCE%TYPE;
      v_pol_npa             gipi_quote_polbasic_discount.net_prem_amt%TYPE;
      v_pol_rem             gipi_quote_polbasic_discount.remarks%TYPE;
      v_pol_srt             gipi_quote_polbasic_discount.surcharge_rt%TYPE;
      v_pol_samt            gipi_quote_polbasic_discount.surcharge_amt%TYPE;
      ---gipi_quote_principal
      v_pr_quote            gipi_quote_principal.quote_id%TYPE;
      v_pr_pcd              gipi_quote_principal.principal_cd%TYPE;
      v_pr_engg             gipi_quote_principal.engg_basic_infonum%TYPE;
      v_pr_sub              gipi_quote_principal.subcon_sw%TYPE;
      v_new_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE;
      v_new_quote_id        gipi_quote.pack_quote_id%TYPE;
      v_quote_id_more       gipi_quote.pack_quote_id%TYPE;    --QUOTE_ID_MORE
   BEGIN
      v_quote_id := p_pack_quote_id;

      BEGIN
         SELECT pack_quote_id_s.NEXTVAL
           INTO v_new_pack_quote_id
           FROM DUAL;

         SELECT quote_quote_id_s.NEXTVAL
           INTO v_new_quote_id
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                quotation_no, assd_no, assd_name, tsi_amt,
                prem_amt, remarks, header, footer, status,
                print_tag, incept_date, expiry_date, accept_dt,
                address1, address2, address3, cred_branch,
                acct_of_cd, acct_of_cd_sw, incept_tag, expiry_tag,
                valid_date, underwriter                 -- added underwriter : shan 05.07.2014
           INTO v_line_cd, v_subline_cd, v_iss_cd, v_quotation_yy,
                v_quotation_no, v_assd_no, v_assd_name, v_tsi_amt,
                v_prem_amt, v_remarks, v_header, v_footer, v_status,
                v_print_tag, v_incept_date, v_expiry_date, v_accept_dt,
                v_address1, v_address2, v_address3, v_cred_branch,
                v_acct_of_cd, v_acct_of_cd_sw, v_incept_tag, v_expiry_tag,
                v_valid_date, v_underwriter                 -- added underwriter : shan 05.07.2014
           FROM gipi_pack_quote
          WHERE pack_quote_id = p_pack_quote_id;

/*
         -- get proposal No.
         BEGIN
            SELECT MAX (proposal_no)
              INTO v_proposal_no
              FROM gipi_quote
             WHERE line_cd = v_line_cd
               AND subline_cd = v_subline_cd
               AND iss_cd = v_iss_cd
               AND quotation_yy = v_quotation_yy
               AND quotation_no = v_quotation_no;

            v_proposal_no := v_proposal_no + 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;*/
         compute_proposal (v_line_cd,
                           v_subline_cd,
                           v_iss_cd,
                           v_quotation_yy,
                           v_quotation_no,
                           v_proposal_no
                          );
         -- assign new p_new_quote_no
         -- return new quote no
         p_new_quote_no :=
               v_line_cd
            || '-'
            || v_subline_cd
            || '-'
            || v_iss_cd
            || '-'
            || v_quotation_yy
            || '-'
            || TO_CHAR (v_quotation_no, '000009')     -- added to_char : shan 05.07.2014
            || '-'
            || TO_CHAR (v_proposal_no, '009');     -- added to_char : shan 05.07.2014
            
         INSERT INTO gipi_pack_quote
                     (proposal_no, pack_quote_id, line_cd,
                      subline_cd, iss_cd, quotation_yy, quotation_no,
                      assd_no, assd_name, tsi_amt, prem_amt,
                      remarks, header, footer, status, print_tag,
                      incept_date, expiry_date, last_update, user_id,
                      accept_dt, address1, address2, address3,
                      cred_branch, acct_of_cd, acct_of_cd_sw,
                      incept_tag, expiry_tag, valid_date, underwriter   -- added underwriter : shan 05.07.2014
                     )
              VALUES (v_proposal_no, v_new_pack_quote_id, v_line_cd,
                      v_subline_cd, v_iss_cd, v_quotation_yy, v_quotation_no,
                      v_assd_no, v_assd_name, v_tsi_amt, v_prem_amt,
                      v_remarks, v_header, v_footer, v_status, v_print_tag,
                      v_incept_date, v_expiry_date, SYSDATE, p_user_id, --USER, --editted by MJ for consolidation 01022013
                      v_accept_dt, v_address1, v_address2, v_address3,
                      v_cred_branch, v_acct_of_cd, v_acct_of_cd_sw,
                      v_incept_tag, v_expiry_tag, v_valid_date, v_underwriter -- added underwriter : shan 05.07.2014
                     );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   -- msg_alert ('There is no existing record.', 'I', TRUE);
      END;

      BEGIN
         FOR z IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                          proposal_no, assd_no, assd_name, tsi_amt, prem_amt,
                          remarks, header, footer, status, print_tag,
                          incept_date, expiry_date, accept_dt, address1,
                          address2, address3, cred_branch, acct_of_cd,
                          acct_of_cd_sw, incept_tag, expiry_tag,
                          prorate_flag, comp_sw, with_tariff_sw,
                          quotation_no, quote_id
                     FROM gipi_quote
                    WHERE pack_quote_id = p_pack_quote_id)
         LOOP
            compute_proposal1 (z.line_cd,
                               z.subline_cd,
                               z.iss_cd,
                               z.quotation_yy,
                               z.quotation_no,
                               v_proposal_no1
                              );
            v_line_cd1 := z.line_cd;
            v_subline_cd1 := z.subline_cd;
            v_iss_cd1 := z.iss_cd;
            v_quotation_yy1 := z.quotation_yy;
            --v_proposal_no1 := z.proposal_no;
            v_incept_date1 := z.incept_date;
            v_expiry_date1 := z.expiry_date;
            v_assd_no1 := z.assd_no;
            v_assd_name1 := z.assd_name;
            v_tsi_amt := z.tsi_amt;
            v_prem_amt := z.prem_amt;
            v_remarks1 := z.remarks;
            v_header1 := z.header;
            v_footer1 := z.footer;
            v_status1 := z.status;
            v_print_tag1 := z.print_tag;
            v_accept_dt1 := z.accept_dt;
            v_address1_1 := z.address1;
            v_address2_1 := z.address2;
            v_address3_1 := z.address3;
            v_cred_branch1 := z.cred_branch;
            v_acct_of_cd1 := z.acct_of_cd;
            v_acct_of_cd_sw1 := z.acct_of_cd_sw;
            v_incept_tag1 := z.incept_tag;
            v_expiry_tag1 := z.expiry_tag;
            v_prorate_flag1 := z.prorate_flag;
            v_comp_sw1 := z.comp_sw;
            v_with_tariff_sw1 := z.with_tariff_sw;
            v_quotation_no1 := z.quotation_no;

            IF v_counter = 0
            THEN
               INSERT INTO gipi_quote
                           (quote_id, line_cd, subline_cd,
                            iss_cd, quotation_yy, proposal_no,
                            incept_date, expiry_date,
                            pack_quote_id, last_update, user_id, assd_no,
                            assd_name, tsi_amt, prem_amt, remarks,
                            header, footer, status, print_tag,
                            accept_dt, address1, address2,
                            address3, cred_branch, acct_of_cd,
                            acct_of_cd_sw, incept_tag, expiry_tag,
                            prorate_flag, comp_sw, with_tariff_sw,
                            quotation_no, pack_pol_flag
                           )                --aaron added pack_pol_flag 102508
                    VALUES (v_new_quote_id, v_line_cd1, v_subline_cd1,
                            v_iss_cd1, v_quotation_yy1, v_proposal_no1,
                            v_incept_date1, v_expiry_date1,
                            v_new_pack_quote_id, SYSDATE, p_user_id /*USER*/, v_assd_no1, --editted by MJ for consolidation 01022013
                            v_assd_name1, v_tsi_amt, v_prem_amt, v_remarks1,
                            v_header1, v_footer1, v_status1, v_print_tag1,
                            v_accept_dt1, v_address1_1, v_address2_1,
                            v_address3_1, v_cred_branch1, v_acct_of_cd1,
                            v_acct_of_cd_sw1, v_incept_tag1, v_expiry_tag1,
                            v_prorate_flag1, v_comp_sw1, v_with_tariff_sw1,
                            v_quotation_no1, 'Y'
                           );
            ELSE
               SELECT quote_quote_id_s.NEXTVAL
                 INTO v_quote_id_more
                 FROM DUAL;

               INSERT INTO gipi_quote
                           (quote_id, line_cd, subline_cd,
                            iss_cd, quotation_yy, proposal_no,
                            incept_date, expiry_date,
                            pack_quote_id, last_update, user_id, assd_no,
                            assd_name, tsi_amt, prem_amt, remarks,
                            header, footer, status, print_tag,
                            accept_dt, address1, address2,
                            address3, cred_branch, acct_of_cd,
                            acct_of_cd_sw, incept_tag, expiry_tag,
                            prorate_flag, comp_sw, with_tariff_sw,
                            quotation_no, pack_pol_flag
                           )
                    VALUES (v_quote_id_more, v_line_cd1, v_subline_cd1,
                            v_iss_cd1, v_quotation_yy1, v_proposal_no1,
                            v_incept_date1, v_expiry_date1,
                            v_new_pack_quote_id, SYSDATE, p_user_id /*USER*/, v_assd_no1, --editted by MJ for consolidation 01022013
                            v_assd_name1, v_tsi_amt, v_prem_amt, v_remarks1,
                            v_header1, v_footer1, v_status1, v_print_tag1,
                            v_accept_dt1, v_address1_1, v_address2_1,
                            v_address3_1, v_cred_branch1, v_acct_of_cd1,
                            v_acct_of_cd_sw1, v_incept_tag1, v_expiry_tag1,
                            v_prorate_flag1, v_comp_sw1, v_with_tariff_sw1,
                            v_quotation_no1, 'Y'
                           );               --aaron added pack_pol_flag 102508
            END IF;

            FOR t1 IN (SELECT   quote_id, item_no, item_title, item_desc,
                                currency_cd, currency_rate, pack_line_cd,
                                pack_subline_cd, tsi_amt, prem_amt,
                                coverage_cd, ann_prem_amt, ann_tsi_amt, item_desc2
                           FROM gipi_quote_item
                          WHERE quote_id = z.quote_id
                       ORDER BY quote_id DESC)
            LOOP
               v_item_no := t1.item_no;
               v_item_title := t1.item_title;
               v_item_desc := t1.item_desc;
               v_currency_cd := t1.currency_cd;
               v_currency_rt := t1.currency_rate;
               v_pack_line_cd := t1.pack_line_cd;
               v_pack_subline_cd := t1.pack_subline_cd;
               v_tsi_amt := t1.tsi_amt;
               v_prem_amt := t1.prem_amt;
               v_coverage_cd_itm := t1.coverage_cd;
               v_ann_prem_amt_itm := t1.ann_prem_amt;
               v_ann_tsi_amt_itm := t1.ann_tsi_amt;
               v_item_desc2_itm := t1.item_desc2;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_item
                              (quote_id, item_no, item_title,
                               item_desc, currency_cd, currency_rate,
                               pack_line_cd, pack_subline_cd, tsi_amt,
                               prem_amt, coverage_cd, ann_prem_amt,
                               ann_tsi_amt, item_desc2
                              )
                       VALUES (v_new_quote_id, v_item_no, v_item_title,
                               v_item_desc, v_currency_cd, v_currency_rt,
                               v_pack_line_cd, v_pack_subline_cd, v_tsi_amt,
                               v_prem_amt, v_coverage_cd_itm, v_ann_prem_amt_itm,
                               v_ann_tsi_amt_itm, v_item_desc2_itm
                              );
               ELSE
                  INSERT INTO gipi_quote_item
                              (quote_id, item_no, item_title,
                               item_desc, currency_cd, currency_rate,
                               pack_line_cd, pack_subline_cd, tsi_amt,
                               prem_amt, coverage_cd, ann_prem_amt,
                               ann_tsi_amt, item_desc2
                              )
                       VALUES (v_quote_id_more, v_item_no, v_item_title,
                               v_item_desc, v_currency_cd, v_currency_rt,
                               v_pack_line_cd, v_pack_subline_cd, v_tsi_amt,
                               v_prem_amt, v_coverage_cd_itm, v_ann_prem_amt_itm,
                               v_ann_tsi_amt_itm, v_item_desc2_itm
                              );
               END IF;
            END LOOP;

            FOR m IN (SELECT   item_no, peril_cd, tsi_amt, prem_amt, prem_rt,
                               comp_rem, quote_id, ann_prem_amt, ann_tsi_amt,
                               line_cd, peril_type
                          FROM gipi_quote_itmperil
                         WHERE quote_id = z.quote_id
                      ORDER BY quote_id DESC)
            LOOP
               --v_temp_id     := M.quote_id;
               v_peril_cd := m.peril_cd;
               v_tsi_amt := m.tsi_amt;
               v_prem_amt := m.prem_amt;
               v_prem_rt := m.prem_rt;
               v_comp_rem := m.comp_rem;
               v_ann_prem_amt_itmprl := m.ann_prem_amt;
               v_ann_tsi_amt_itmprl := m.ann_tsi_amt;
               v_line_cd_itmprl := m.line_cd;
               v_peril_type_itmprl := m.peril_type;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_itmperil
                              (quote_id, item_no, peril_cd,
                               tsi_amt, prem_amt, prem_rt, comp_rem,
                               ann_prem_amt, ann_tsi_amt,line_cd, peril_type
                              )
                       VALUES (v_new_quote_id, v_item_no, v_peril_cd,
                               v_tsi_amt, v_prem_amt, v_prem_rt, v_comp_rem,
                               v_ann_prem_amt_itmprl, v_ann_tsi_amt_itmprl, v_line_cd_itmprl,
                               v_peril_type_itmprl
                              );
               ELSE
                  INSERT INTO gipi_quote_itmperil
                              (quote_id, item_no, peril_cd,
                               tsi_amt, prem_amt, prem_rt, comp_rem,
                               ann_prem_amt, ann_tsi_amt,line_cd, peril_type
                              )
                       VALUES (v_quote_id_more, v_item_no, v_peril_cd,
                               v_tsi_amt, v_prem_amt, v_prem_rt, v_comp_rem,
                               v_ann_prem_amt_itmprl, v_ann_tsi_amt_itmprl, v_line_cd_itmprl,
                               v_peril_type_itmprl
                              );
               END IF;
            END LOOP;

            FOR b IN (SELECT   quote_inv_no, iss_cd, intm_no, currency_cd,
                               currency_rt, prem_amt, tax_amt
                          FROM gipi_quote_invoice
                         WHERE quote_id = z.quote_id
                      ORDER BY quote_id DESC)
            LOOP
               FOR j IN (SELECT quote_inv_no
                           FROM giis_quote_inv_seq
                          WHERE iss_cd = v_iss_cd)
               LOOP
                  v_quote_inv_no := j.quote_inv_no + 1;
                  v_quote_inv_no_tax := j.quote_inv_no + 1;
                  EXIT;
               END LOOP;

               v_iss_cd := b.iss_cd;
               v_currency_cd := b.currency_cd;
               v_currency_rt := b.currency_rt;
               v_prem_amt := b.prem_amt;
               v_tax_amt := b.tax_amt;
               v_quote_no := b.quote_inv_no;
               v_intm_no := b.intm_no;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_invoice
                              (quote_id, iss_cd, quote_inv_no,
                               intm_no, currency_cd, currency_rt,
                               prem_amt, tax_amt
                              )
                       VALUES (v_new_quote_id, v_iss_cd, v_quote_inv_no,
                               v_intm_no, v_currency_cd, v_currency_rt,
                               v_prem_amt, v_tax_amt
                              );
               ELSE
                  INSERT INTO gipi_quote_invoice
                              (quote_id, iss_cd, quote_inv_no,
                               intm_no, currency_cd, currency_rt,
                               prem_amt, tax_amt
                              )
                       VALUES (v_quote_id_more, v_iss_cd, v_quote_inv_no,
                               v_intm_no, v_currency_cd, v_currency_rt,
                               v_prem_amt, v_tax_amt
                              );
               END IF;
               
               FOR inv IN (SELECT line_cd, iss_cd, tax_cd, tax_id,
                                tax_amt, rate, fixed_tax_allocation, item_grp,
                                tax_allocation
                           FROM gipi_quote_invtax
                          WHERE quote_inv_no = b.quote_inv_no
                            AND iss_cd = b.iss_cd)
                LOOP
                    v_line_cd_inv_tax := inv.line_cd;
                    v_iss_cd_inv_tax := inv.iss_cd;
                    v_tax_cd := inv.tax_cd;
                    v_tax_id := inv.tax_id;
                    v_tax_amt_2 := inv.tax_amt;
                    v_rate := inv.rate;
                    v_fxd_tax_alloc_inv := inv.fixed_tax_allocation;
                    v_item_grp_inv_tax := inv.item_grp;
                    v_tax_alloc_inv_tax := inv.tax_allocation;
                    
                    INSERT INTO gipi_quote_invtax 
                               (line_cd, iss_cd,quote_inv_no,tax_cd,tax_id,
                                tax_amt, rate,fixed_tax_allocation,item_grp,
                                tax_allocation
                               )
                        VALUES (v_line_cd_inv_tax, v_iss_cd_inv_tax, v_quote_inv_no_tax, v_tax_cd, v_tax_id,
                                v_tax_amt_2, v_rate, v_fxd_tax_alloc_inv, v_item_grp_inv_tax,
                                v_tax_alloc_inv_tax 
                               );
                END LOOP;

            END LOOP;

            FOR a IN (SELECT menu_line_cd
                        FROM giis_line
                       WHERE line_cd = z.line_cd)
            LOOP
               v_menu_line_cd := a.menu_line_cd;
               EXIT;
            END LOOP;

            IF v_menu_line_cd = 'AC' OR z.line_cd = 'AC'
            THEN
               FOR ac IN (SELECT item_no, no_of_persons, position_cd,
                                 monthly_salary, salary_grade, destination,
                                 ac_class_cd, age, civil_status,
                                 date_of_birth, group_print_sw, height,
                                 level_cd, parent_level_cd sex, weight
                            FROM gipi_quote_ac_item
                           WHERE quote_id = v_temp_quote)
               -- AND item_no = V.item_no)
               LOOP
                  v_ac_item_no := ac.item_no;
                  v_ac_persons := ac.no_of_persons;
                  v_ac_positions := ac.position_cd;
                  v_ac_monthly := ac.monthly_salary;
                  v_ac_salary := ac.salary_grade;
                  v_ac_destination := ac.destination;
                  v_ac_class := ac.ac_class_cd;
                  v_ac_age := ac.age;
                  v_ac_status := ac.civil_status;
                  v_ac_birth := ac.date_of_birth;
                  v_ac_print_sw := ac.group_print_sw;
                  v_ac_height := ac.height;
                  v_ac_level_cd := ac.level_cd;
                  v_ac_sex := ac.sex;
                  v_ac_weight := ac.weight;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ac_item
                                 (quote_id, item_no,
                                  no_of_persons, position_cd,
                                  monthly_salary, salary_grade,
                                  destination, ac_class_cd, age,
                                  civil_status, date_of_birth,
                                  group_print_sw, height, level_cd,
                                  parent_level_cd, sex, weight, user_id,
                                  last_update
                                 )
                          VALUES (v_new_quote_id, v_ac_item_no,
                                  v_ac_persons, v_ac_positions,
                                  v_ac_monthly, v_ac_salary,
                                  v_ac_destination, v_ac_class, v_ac_age,
                                  v_ac_status, v_ac_birth,
                                  v_ac_print_sw, v_ac_height, v_ac_level_cd,
                                  v_ac_plevel, v_ac_sex, v_ac_weight, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ac_item
                                 (quote_id, item_no,
                                  no_of_persons, position_cd,
                                  monthly_salary, salary_grade,
                                  destination, ac_class_cd, age,
                                  civil_status, date_of_birth,
                                  group_print_sw, height, level_cd,
                                  parent_level_cd, sex, weight, user_id,
                                  last_update
                                 )
                          VALUES (v_quote_id_more, v_ac_item_no,
                                  v_ac_persons, v_ac_positions,
                                  v_ac_monthly, v_ac_salary,
                                  v_ac_destination, v_ac_class, v_ac_age,
                                  v_ac_status, v_ac_birth,
                                  v_ac_print_sw, v_ac_height, v_ac_level_cd,
                                  v_ac_plevel, v_ac_sex, v_ac_weight, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'MC' OR z.line_cd = 'MC'
            THEN
               FOR mc IN (SELECT item_no, plate_no, motor_no, serial_no,
                                 subline_type_cd, mot_type, car_company_cd,
                                 coc_yy, coc_seq_no, coc_serial_no, coc_type,
                                 repair_lim, color, model_year, make,
                                 est_value, towing, assignee, no_of_pass,
                                 tariff_zone, coc_issue_date, mv_file_no,
                                 acquired_from, ctv_tag, type_of_body_cd,
                                 unladen_wt, make_cd, series_cd,
                                 basic_color_cd, color_cd, origin,
                                 destination, coc_atcn, subline_cd
                            FROM gipi_quote_item_mc
                           WHERE quote_id = z.quote_id)
               -- AND item_no = V.item_no)
               LOOP
                  v_mc_item := mc.item_no;
                  v_mc_plate := mc.plate_no;
                  v_mc_motor := mc.motor_no;
                  v_mc_serial_no := mc.serial_no;
                  v_mc_subline_type := mc.subline_type_cd;
                  v_mc_mot_type := mc.mot_type;
                  v_mc_car := mc.car_company_cd;
                  v_mc_coc_yy := mc.coc_yy;
                  v_mc_coc_seq_no := mc.coc_seq_no;
                  v_mc_coc_serial := mc.coc_serial_no;
                  v_mc_coc_type := mc.coc_type;
                  v_mc_repair := mc.repair_lim;
                  v_mc_color := mc.color;
                  v_mc_model_year := mc.model_year;
                  v_mc_make := mc.make;
                  v_mc_est := mc.est_value;
                  v_mc_towing := mc.towing;
                  v_mc_assignee := mc.assignee;
                  v_mc_no_pass := mc.no_of_pass;
                  v_mc_tariff := mc.tariff_zone;
                  v_mc_coc_issue := mc.coc_issue_date;
                  v_mc_mv := mc.mv_file_no;
                  v_mc_acquired := mc.acquired_from;
                  v_mc_ctv := mc.ctv_tag;
                  v_mc_type := mc.type_of_body_cd;
                  v_mc_unladen := mc.unladen_wt;
                  v_mc_make_cd := mc.make_cd;
                  v_mc_series := mc.series_cd;
                  v_mc_basic_color := mc.basic_color_cd;
                  v_mc_color_cd := mc.color_cd;
                  v_mc_origin := mc.origin;
                  v_mc_destination := mc.destination;
                  v_mc_coc_atcn := mc.coc_atcn;
                  v_mc_subline_cd := mc.subline_cd;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_item_mc
                                 (quote_id, item_no, plate_no,
                                  motor_no, serial_no,
                                  subline_type_cd, mot_type,
                                  car_company_cd, coc_yy, coc_seq_no,
                                  coc_serial_no, coc_type,
                                  repair_lim, color, model_year,
                                  make, est_value, towing,
                                  assignee, no_of_pass, tariff_zone,
                                  coc_issue_date, mv_file_no, acquired_from,
                                  ctv_tag, type_of_body_cd, unladen_wt,
                                  make_cd, series_cd,
                                  basic_color_cd, color_cd,
                                  origin, destination,
                                  coc_atcn, subline_cd, user_id,
                                  last_update
                                 )
                          VALUES (v_new_quote_id, v_mc_item, v_mc_plate,
                                  v_mc_motor, v_mc_serial_no,
                                  v_mc_subline_type, v_mc_mot_type,
                                  v_mc_car, v_mc_coc_yy, v_mc_coc_seq_no,
                                  v_mc_coc_serial, v_mc_coc_type,
                                  v_mc_repair, v_mc_color, v_mc_model_year,
                                  v_mc_make, v_mc_est, v_mc_towing,
                                  v_mc_assignee, v_mc_no_pass, v_mc_tariff,
                                  v_mc_coc_issue, v_mc_mv, v_mc_acquired,
                                  v_mc_ctv, v_mc_type, v_mc_unladen,
                                  v_mc_make_cd, v_mc_series,
                                  v_mc_basic_color, v_mc_color_cd,
                                  v_mc_origin, v_mc_destination,
                                  v_mc_coc_atcn, v_mc_subline_cd, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  ELSE
                     INSERT INTO gipi_quote_item_mc
                                 (quote_id, item_no, plate_no,
                                  motor_no, serial_no,
                                  subline_type_cd, mot_type,
                                  car_company_cd, coc_yy, coc_seq_no,
                                  coc_serial_no, coc_type,
                                  repair_lim, color, model_year,
                                  make, est_value, towing,
                                  assignee, no_of_pass, tariff_zone,
                                  coc_issue_date, mv_file_no, acquired_from,
                                  ctv_tag, type_of_body_cd, unladen_wt,
                                  make_cd, series_cd,
                                  basic_color_cd, color_cd,
                                  origin, destination,
                                  coc_atcn, subline_cd, user_id,
                                  last_update
                                 )
                          VALUES (v_quote_id_more, v_mc_item, v_mc_plate,
                                  v_mc_motor, v_mc_serial_no,
                                  v_mc_subline_type, v_mc_mot_type,
                                  v_mc_car, v_mc_coc_yy, v_mc_coc_seq_no,
                                  v_mc_coc_serial, v_mc_coc_type,
                                  v_mc_repair, v_mc_color, v_mc_model_year,
                                  v_mc_make, v_mc_est, v_mc_towing,
                                  v_mc_assignee, v_mc_no_pass, v_mc_tariff,
                                  v_mc_coc_issue, v_mc_mv, v_mc_acquired,
                                  v_mc_ctv, v_mc_type, v_mc_unladen,
                                  v_mc_make_cd, v_mc_series,
                                  v_mc_basic_color, v_mc_color_cd,
                                  v_mc_origin, v_mc_destination,
                                  v_mc_coc_atcn, v_mc_subline_cd, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'FI' OR z.line_cd = 'FI'
            THEN
               FOR fi IN (SELECT item_no, district_no, eq_zone, tarf_cd,
                                 block_no, fr_item_type, loc_risk1,
                                 loc_risk2, loc_risk3, tariff_zone,
                                 typhoon_zone, construction_cd,
                                 construction_remarks, front, RIGHT, LEFT,
                                 rear, occupancy_cd, occupancy_remarks,
                                 flood_zone, assignee, block_id, risk_cd,
                                 date_from, date_to
                            FROM gipi_quote_fi_item
                           WHERE quote_id = z.quote_id)
               --AND item_no = V.item_no)
               LOOP
                  v_fi_item := fi.item_no;
                  v_fi_district := fi.district_no;
                  v_fi_req_zone := fi.eq_zone;
                  v_fi_tarf := fi.tarf_cd;
                  v_fi_block_no := fi.block_no;
                  v_fi_fr := fi.fr_item_type;
                  v_fi_risk1 := fi.loc_risk1;
                  v_fi_risk2 := fi.loc_risk2;
                  v_fi_risk3 := fi.loc_risk3;
                  v_fi_tariff := fi.tariff_zone;
                  v_fi_typhoon := fi.typhoon_zone;
                  v_fi_cons_cd := fi.construction_cd;
                  v_fi_cons_rem := fi.construction_remarks;
                  v_fi_front := fi.front;
                  v_fi_right := fi.RIGHT;
                  v_fi_left := fi.LEFT;
                  v_fi_rear := fi.rear;
                  v_fi_occ_cd := fi.occupancy_cd;
                  v_fi_occ_rem := fi.occupancy_remarks;
                  v_fi_flood := fi.flood_zone;
                  v_fi_assignee := fi.assignee;
                  v_fi_block := fi.block_id;
                  v_fi_risk := fi.risk_cd;
                  v_fi_date_from := fi.date_from;
                  v_fi_date_to := fi.date_to;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_fi_item
                                 (quote_id, item_no, district_no,
                                  eq_zone, tarf_cd, block_no,
                                  fr_item_type, loc_risk1, loc_risk2,
                                  loc_risk3, tariff_zone, typhoon_zone,
                                  construction_cd, construction_remarks,
                                  front, RIGHT, LEFT,
                                  rear, occupancy_cd, occupancy_remarks,
                                  flood_zone, assignee, block_id,
                                  risk_cd, user_id, last_update,
                                  date_from, date_to
                                 )
                          VALUES (v_new_quote_id, v_fi_item, v_fi_district,
                                  v_fi_req_zone, v_fi_tarf, v_fi_block_no,
                                  v_fi_fr, v_fi_risk1, v_fi_risk2,
                                  v_fi_risk3, v_fi_tariff, v_fi_typhoon,
                                  v_fi_cons_cd, v_fi_cons_rem,
                                  v_fi_front, v_fi_right, v_fi_left,
                                  v_fi_rear, v_fi_occ_cd, v_fi_occ_rem,
                                  v_fi_flood, v_fi_assignee, v_fi_block,
                                  v_fi_risk, p_user_id /*USER*/, SYSDATE, --editted by MJ for consolidation 01022013
                                  v_fi_date_from, v_fi_date_to
                                 );
                  ELSE
                     INSERT INTO gipi_quote_fi_item
                                 (quote_id, item_no, district_no,
                                  eq_zone, tarf_cd, block_no,
                                  fr_item_type, loc_risk1, loc_risk2,
                                  loc_risk3, tariff_zone, typhoon_zone,
                                  construction_cd, construction_remarks,
                                  front, RIGHT, LEFT,
                                  rear, occupancy_cd, occupancy_remarks,
                                  flood_zone, assignee, block_id,
                                  risk_cd, user_id, last_update,
                                  date_from, date_to
                                 )
                          VALUES (v_quote_id_more, v_fi_item, v_fi_district,
                                  v_fi_req_zone, v_fi_tarf, v_fi_block_no,
                                  v_fi_fr, v_fi_risk1, v_fi_risk2,
                                  v_fi_risk3, v_fi_tariff, v_fi_typhoon,
                                  v_fi_cons_cd, v_fi_cons_rem,
                                  v_fi_front, v_fi_right, v_fi_left,
                                  v_fi_rear, v_fi_occ_cd, v_fi_occ_rem,
                                  v_fi_flood, v_fi_assignee, v_fi_block,
                                  v_fi_risk, p_user_id /*USER*/, SYSDATE, --editted by MJ for consolidation 01022013
                                  v_fi_date_from, v_fi_date_to
                                 );
                  END IF;
               END LOOP;
            --**
            ELSIF v_menu_line_cd = 'EN' OR z.line_cd = 'EN'
            THEN
               FOR en IN (SELECT engg_basic_infonum,
                                 contract_proj_buss_title, site_location,
                                 construct_start_date, construct_end_date,
                                 maintain_start_date, maintain_end_date,
                                 testing_start_date, testing_end_date,
                                 weeks_test, time_excess, mbi_policy_no
                            FROM gipi_quote_en_item
                           WHERE quote_id = z.quote_id)
               -- AND item_no = V.item_no)
               LOOP
                  v_en_engg := en.engg_basic_infonum;
                  v_en_contract := en.contract_proj_buss_title;
                  v_en_site := en.site_location;
                  v_en_construct_s := en.construct_start_date;
                  v_en_construct_e := en.construct_end_date;
                  v_en_maintain_s := en.maintain_start_date;
                  v_en_maintain_e := en.maintain_end_date;
                  v_en_testing_s := en.testing_start_date;
                  v_en_testing_e := en.testing_end_date;
                  v_en_weeks := en.weeks_test;
                  v_en_time := en.time_excess;
                  v_en_mbi := en.mbi_policy_no;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_en_item
                                 (quote_id, engg_basic_infonum,
                                  contract_proj_buss_title, site_location,
                                  construct_start_date, construct_end_date,
                                  maintain_start_date, maintain_end_date,
                                  testing_start_date, testing_end_date,
                                  weeks_test, time_excess, mbi_policy_no,
                                  user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_en_engg,
                                  v_en_contract, v_en_site,
                                  v_en_construct_s, v_en_construct_e,
                                  v_en_maintain_s, v_en_maintain_e,
                                  v_en_testing_s, v_en_testing_e,
                                  v_en_weeks, v_en_time, v_en_mbi,
                                  p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_en_item
                                 (quote_id, engg_basic_infonum,
                                  contract_proj_buss_title, site_location,
                                  construct_start_date, construct_end_date,
                                  maintain_start_date, maintain_end_date,
                                  testing_start_date, testing_end_date,
                                  weeks_test, time_excess, mbi_policy_no,
                                  user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_en_engg,
                                  v_en_contract, v_en_site,
                                  v_en_construct_s, v_en_construct_e,
                                  v_en_maintain_s, v_en_maintain_e,
                                  v_en_testing_s, v_en_testing_e,
                                  v_en_weeks, v_en_time, v_en_mbi,
                                  p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'CA' OR z.line_cd = 'CA'
            THEN
               FOR ca IN (SELECT item_no, section_line_cd,
                                 section_subline_cd, section_or_hazard_cd,
                                 capacity_cd, property_no_type, property_no,
                                 LOCATION, conveyance_info,
                                 interest_on_premises, limit_of_liability,
                                 section_or_hazard_info
                            FROM gipi_quote_ca_item
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_ca_item := ca.item_no;
                  v_ca_sec_line := ca.section_line_cd;
                  v_ca_sec_sub := ca.section_subline_cd;
                  v_ca_sec_or := ca.section_or_hazard_cd;
                  v_ca_capacity := ca.capacity_cd;
                  v_ca_prop := ca.property_no_type;
                  v_ca_propno := ca.property_no;
                  v_ca_location := ca.LOCATION;
                  v_ca_conveyance := ca.conveyance_info;
                  v_ca_interest := ca.interest_on_premises;
                  v_ca_limit := ca.limit_of_liability;
                  v_ca_sec_info := ca.section_or_hazard_info;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ca_item
                                 (quote_id, item_no, section_line_cd,
                                  section_subline_cd, section_or_hazard_cd,
                                  capacity_cd, property_no_type,
                                  property_no, LOCATION,
                                  conveyance_info, interest_on_premises,
                                  limit_of_liability,
                                  section_or_hazard_info, user_id,
                                  last_update
                                 )
                          VALUES (v_new_quote_id, v_ca_item, v_ca_sec_line,
                                  v_ca_sec_sub, v_ca_sec_or,
                                  v_ca_capacity, v_ca_prop,
                                  v_ca_propno, v_ca_location,
                                  v_ca_conveyance, v_ca_interest,
                                  v_ca_limit,
                                  v_ca_sec_info, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ca_item
                                 (quote_id, item_no, section_line_cd,
                                  section_subline_cd, section_or_hazard_cd,
                                  capacity_cd, property_no_type,
                                  property_no, LOCATION,
                                  conveyance_info, interest_on_premises,
                                  limit_of_liability,
                                  section_or_hazard_info, user_id,
                                  last_update
                                 )
                          VALUES (v_quote_id_more, v_ca_item, v_ca_sec_line,
                                  v_ca_sec_sub, v_ca_sec_or,
                                  v_ca_capacity, v_ca_prop,
                                  v_ca_propno, v_ca_location,
                                  v_ca_conveyance, v_ca_interest,
                                  v_ca_limit,
                                  v_ca_sec_info, p_user_id, --USER, --editted by MJ for consolidation 01022013
                                  SYSDATE
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'MN' OR z.line_cd = 'MN'
            THEN
               FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                             FROM gipi_quote_ves_air
                            WHERE quote_id = z.quote_id)
               --AND item_no = V.item_no)
               LOOP
                  v_vvessel := ves.vessel_cd;
                  v_vrec := ves.rec_flag;
                  v_vves := ves.vescon;
                  v_vvoy := ves.voy_limit;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag, vescon,
                                  voy_limit
                                 )
                          VALUES (v_new_quote_id, v_vvessel, v_vrec, v_vves,
                                  v_vvoy
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag,
                                  vescon, voy_limit
                                 )
                          VALUES (v_quote_id_more, v_vvessel, v_vrec,
                                  v_vves, v_vvoy
                                 );
                  END IF;
               END LOOP;

               FOR mn IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                                 voyage_no, bl_awb, origin, destn, etd, eta,
                                 cargo_type, pack_method, tranship_origin,
                                 tranship_destination, lc_no, print_tag,
                                 deduct_text, rec_flag
                            FROM gipi_quote_cargo
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_mn_item := mn.item_no;
                  v_mn_vessel := mn.vessel_cd;
                  v_mn_geog_cd := mn.geog_cd;
                  v_mn_cargo := mn.cargo_class_cd;
                  v_mn_voyage := mn.voyage_no;
                  v_mn_bl := mn.bl_awb;
                  v_mn_orig := mn.origin;
                  v_mn_destn := mn.destn;
                  v_mn_etd := mn.etd;
                  v_mn_eta := mn.eta;
                  v_mn_ctype := mn.cargo_type;
                  v_mn_pack := mn.pack_method;
                  v_mn_trans_orig := mn.tranship_origin;
                  v_mn_trans_dest := mn.tranship_destination;
                  v_mn_lc := mn.lc_no;
                  v_mn_print := mn.print_tag;
                  v_mn_deduct := mn.deduct_text;
                  v_mn_rec := mn.rec_flag;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_cargo
                                 (quote_id, item_no, vessel_cd,
                                  geog_cd, cargo_class_cd, voyage_no,
                                  bl_awb, origin, destn, etd,
                                  eta, cargo_type, pack_method,
                                  tranship_origin, tranship_destination,
                                  lc_no, print_tag, deduct_text,
                                  rec_flag, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_mn_item, v_mn_vessel,
                                  v_mn_geog_cd, v_mn_cargo, v_mn_voyage,
                                  v_mn_bl, v_mn_orig, v_mn_destn, v_mn_etd,
                                  v_mn_eta, v_mn_ctype, v_mn_pack,
                                  v_mn_trans_orig, v_mn_trans_dest,
                                  v_mn_lc, v_mn_print, v_mn_deduct,
                                  v_mn_rec, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_cargo
                                 (quote_id, item_no, vessel_cd,
                                  geog_cd, cargo_class_cd, voyage_no,
                                  bl_awb, origin, destn, etd,
                                  eta, cargo_type, pack_method,
                                  tranship_origin, tranship_destination,
                                  lc_no, print_tag, deduct_text,
                                  rec_flag, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_mn_item, v_mn_vessel,
                                  v_mn_geog_cd, v_mn_cargo, v_mn_voyage,
                                  v_mn_bl, v_mn_orig, v_mn_destn, v_mn_etd,
                                  v_mn_eta, v_mn_ctype, v_mn_pack,
                                  v_mn_trans_orig, v_mn_trans_dest,
                                  v_mn_lc, v_mn_print, v_mn_deduct,
                                  v_mn_rec, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'AV' OR z.line_cd = 'AV'
            THEN
               FOR av IN (SELECT item_no, vessel_cd, total_fly_time,
                                 qualification, purpose, geog_limit,
                                 deduct_text, rec_flag, fixed_wing, rotor,
                                 prev_util_hrs, est_util_hrs
                            FROM gipi_quote_av_item
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_av_item := av.item_no;
                  v_av_vessel := av.vessel_cd;
                  v_av_total := av.total_fly_time;
                  v_av_qualify := av.qualification;
                  v_av_purpose := av.purpose;
                  v_av_geog := av.geog_limit;
                  v_av_deduct := av.deduct_text;
                  v_av_rec := av.rec_flag;
                  v_av_fixed := av.fixed_wing;
                  v_av_rotor := av.rotor;
                  v_av_prev := av.prev_util_hrs;
                  v_av_est := av.est_util_hrs;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_av_item
                                 (quote_id, item_no, vessel_cd,
                                  total_fly_time, qualification, purpose,
                                  geog_limit, deduct_text, rec_flag,
                                  fixed_wing, rotor, prev_util_hrs,
                                  est_util_hrs, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_av_item, v_av_vessel,
                                  v_av_total, v_av_qualify, v_av_purpose,
                                  v_av_geog, v_av_deduct, v_av_rec,
                                  v_av_fixed, v_av_rotor, v_av_prev,
                                  v_av_est, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_av_item
                                 (quote_id, item_no, vessel_cd,
                                  total_fly_time, qualification, purpose,
                                  geog_limit, deduct_text, rec_flag,
                                  fixed_wing, rotor, prev_util_hrs,
                                  est_util_hrs, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_av_item, v_av_vessel,
                                  v_av_total, v_av_qualify, v_av_purpose,
                                  v_av_geog, v_av_deduct, v_av_rec,
                                  v_av_fixed, v_av_rotor, v_av_prev,
                                  v_av_est, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'MH' OR z.line_cd = 'MH'
            THEN
               FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                             FROM gipi_quote_ves_air
                            WHERE quote_id = z.quote_id)
               --AND item_no = V.item_no)
               LOOP
                  v_vvessel := ves.vessel_cd;
                  v_vrec := ves.rec_flag;
                  v_vves := ves.vescon;
                  v_vvoy := ves.voy_limit;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag, vescon,
                                  voy_limit
                                 )
                          VALUES (v_new_quote_id, v_vvessel, v_vrec, v_vves,
                                  v_vvoy
                                 );
                  ELSE
                     INSERT INTO gipi_quote_ves_air
                                 (quote_id, vessel_cd, rec_flag,
                                  vescon, voy_limit
                                 )
                          VALUES (v_quote_id_more, v_vvessel, v_vrec,
                                  v_vves, v_vvoy
                                 );
                  END IF;
               END LOOP;

               FOR mh IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                                 deduct_text, dry_date, dry_place
                            FROM gipi_quote_mh_item
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_mh_item := mh.item_no;
                  v_mh_vessel := mh.vessel_cd;
                  v_mh_geog := mh.geog_limit;
                  v_mh_rec := mh.rec_flag;
                  v_mh_deduct := mh.deduct_text;
                  v_mh_ddate := mh.dry_date;
                  v_mh_dplace := mh.dry_place;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_mh_item
                                 (quote_id, item_no, vessel_cd,
                                  geog_limit, rec_flag, deduct_text,
                                  dry_date, dry_place, user_id, last_update
                                 )
                          VALUES (v_new_quote_id, v_mh_item, v_mh_vessel,
                                  v_mh_geog, v_mh_rec, v_mh_deduct,
                                  v_mh_ddate, v_mh_dplace, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_mh_item
                                 (quote_id, item_no, vessel_cd,
                                  geog_limit, rec_flag, deduct_text,
                                  dry_date, dry_place, user_id, last_update
                                 )
                          VALUES (v_quote_id_more, v_mh_item, v_mh_vessel,
                                  v_mh_geog, v_mh_rec, v_mh_deduct,
                                  v_mh_ddate, v_mh_dplace, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            --***
            ELSIF v_menu_line_cd = 'SU' OR z.line_cd = 'SU'
            THEN
               FOR su IN (SELECT obligee_no, prin_id, val_period_unit,
                                 val_period, coll_flag, clause_type, np_no,
                                 contract_dtl, contract_date, co_prin_sw,
                                 waiver_limit, indemnity_text, bond_dtl,
                                 endt_eff_date, remarks
                            FROM gipi_quote_bond_basic
                           WHERE quote_id = z.quote_id)
               --    AND item_no = V.item_no)
               LOOP
                  v_b_oblg := su.obligee_no;
                  v_b_prin := su.prin_id;
                  v_b_vunit := su.val_period_unit;
                  v_b_vperiod := su.val_period;
                  v_b_coll := su.coll_flag;
                  v_b_clause := su.clause_type;
                  v_b_np := su.np_no;
                  v_b_contract := su.contract_dtl;
                  v_b_cdate := su.contract_date;
                  v_b_co := su.co_prin_sw;
                  v_b_waiver := su.waiver_limit;
                  v_b_indemnity := su.indemnity_text;
                  v_b_bond := su.bond_dtl;
                  v_b_endt := su.endt_eff_date;
                  v_b_rem := su.remarks;

                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_bond_basic
                                 (quote_id, obligee_no, prin_id,
                                  val_period_unit, val_period, coll_flag,
                                  clause_type, np_no, contract_dtl,
                                  contract_date, co_prin_sw, waiver_limit,
                                  indemnity_text, bond_dtl, endt_eff_date,
                                  remarks
                                 )
                          VALUES (v_new_quote_id, v_b_oblg, v_b_prin,
                                  v_b_vunit, v_b_vperiod, v_b_coll,
                                  v_b_clause, v_b_np, v_b_contract,
                                  v_b_cdate, v_b_co, v_b_waiver,
                                  v_b_indemnity, v_b_bond, v_b_endt,
                                  v_b_rem
                                 );
                  ELSE
                     INSERT INTO gipi_quote_bond_basic
                                 (quote_id, obligee_no, prin_id,
                                  val_period_unit, val_period, coll_flag,
                                  clause_type, np_no, contract_dtl,
                                  contract_date, co_prin_sw, waiver_limit,
                                  indemnity_text, bond_dtl, endt_eff_date,
                                  remarks
                                 )
                          VALUES (v_quote_id_more, v_b_oblg, v_b_prin,
                                  v_b_vunit, v_b_vperiod, v_b_coll,
                                  v_b_clause, v_b_np, v_b_contract,
                                  v_b_cdate, v_b_co, v_b_waiver,
                                  v_b_indemnity, v_b_bond, v_b_endt,
                                  v_b_rem
                                 );
                  END IF;
               END LOOP;
            END IF;

            -- end of long if statement
            FOR wc IN (SELECT line_cd, wc_cd, print_seq_no, wc_title,
                              wc_title2, wc_text01, wc_text02, wc_text03,
                              wc_text04, wc_text05, wc_text06, wc_text07,
                              wc_text08, wc_text09, wc_text10, wc_text11,
                              wc_text12, wc_text13, wc_text14, wc_text15,
                              wc_text16, wc_text17, wc_remarks, print_sw,
                              change_tag
                         FROM gipi_quote_wc
                        WHERE quote_id = z.quote_id)
            LOOP
               v_wc_line := wc.line_cd;
               v_wc_cd := wc.wc_cd;
               v_print := wc.print_seq_no;
               v_wc_title := wc.wc_title;
               v_wc_title2 := wc.wc_title2;
               v_wc01 := wc.wc_text01;
               v_wc02 := wc.wc_text02;
               v_wc03 := wc.wc_text03;
               v_wc04 := wc.wc_text04;
               v_wc05 := wc.wc_text05;
               v_wc06 := wc.wc_text06;
               v_wc07 := wc.wc_text07;
               v_wc08 := wc.wc_text08;
               v_wc09 := wc.wc_text09;
               v_wc10 := wc.wc_text10;
               v_wc11 := wc.wc_text11;
               v_wc12 := wc.wc_text12;
               v_wc13 := wc.wc_text13;
               v_wc14 := wc.wc_text14;
               v_wc15 := wc.wc_text15;
               v_wc16 := wc.wc_text16;
               v_wc17 := wc.wc_text17;
               v_wcremarks := wc.wc_remarks;
               v_print_sw := wc.print_sw;
               v_change_tag := wc.change_tag;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_wc
                              (quote_id, line_cd, wc_cd, print_seq_no,
                               wc_title, wc_title2, wc_text01, wc_text02,
                               wc_text03, wc_text04, wc_text05, wc_text06,
                               wc_text07, wc_text08, wc_text09, wc_text10,
                               wc_text11, wc_text12, wc_text13, wc_text14,
                               wc_text15, wc_text16, wc_text17, wc_remarks,
                               print_sw, change_tag, user_id, last_update
                              )
                       VALUES (v_new_quote_id, v_wc_line, v_wc_cd, v_print,
                               v_wc_title, v_wc_title2, v_wc01, v_wc02,
                               v_wc03, v_wc04, v_wc05, v_wc06,
                               v_wc07, v_wc08, v_wc09, v_wc10,
                               v_wc11, v_wc12, v_wc13, v_wc14,
                               v_wc15, v_wc16, v_wc17, v_wcremarks,
                               v_print_sw, v_change_tag, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                              );
               ELSE
                  INSERT INTO gipi_quote_wc
                              (quote_id, line_cd, wc_cd, print_seq_no,
                               wc_title, wc_title2, wc_text01, wc_text02,
                               wc_text03, wc_text04, wc_text05, wc_text06,
                               wc_text07, wc_text08, wc_text09, wc_text10,
                               wc_text11, wc_text12, wc_text13, wc_text14,
                               wc_text15, wc_text16, wc_text17, wc_remarks,
                               print_sw, change_tag, user_id, last_update
                              )
                       VALUES (v_quote_id_more, v_wc_line, v_wc_cd, v_print,
                               v_wc_title, v_wc_title2, v_wc01, v_wc02,
                               v_wc03, v_wc04, v_wc05, v_wc06,
                               v_wc07, v_wc08, v_wc09, v_wc10,
                               v_wc11, v_wc12, v_wc13, v_wc14,
                               v_wc15, v_wc16, v_wc17, v_wcremarks,
                               v_print_sw, v_change_tag, p_user_id /*USER*/, SYSDATE --editted by MJ for consolidation 01022013
                              );
               END IF;
            END LOOP;

            BEGIN
               SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                      bonds_ri_flag
                 INTO v_cos_id, v_cos_assd, v_cos_indem, v_cos_bond,
                      v_cos_ri
                 FROM gipi_quote_cosign
                WHERE quote_id = z.quote_id;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_cosign
                              (quote_id, cosign_id, assd_no,
                               indem_flag, bonds_flag, bonds_ri_flag
                              )
                       VALUES (v_new_quote_id, v_cos_id, v_cos_assd,
                               v_cos_indem, v_cos_bond, v_cos_ri
                              );
               ELSE                                                  --COMMIT;
                  INSERT INTO gipi_quote_cosign
                              (quote_id, cosign_id, assd_no,
                               indem_flag, bonds_flag, bonds_ri_flag
                              )
                       VALUES (v_quote_id_more, v_cos_id, v_cos_assd,
                               v_cos_indem, v_cos_bond, v_cos_ri
                              );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            FOR idis IN (SELECT surcharge_rt, surcharge_amt, subline_cd,
                                SEQUENCE, remarks, orig_prem_amt,
                                net_prem_amt, net_gross_tag, line_cd, item_no,
                                disc_rt, disc_amt
                           FROM gipi_quote_item_discount
                          WHERE quote_id = z.quote_id)
            LOOP
               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_item_discount
                              (quote_id, surcharge_rt,
                               surcharge_amt, subline_cd,
                               SEQUENCE, remarks,
                               orig_prem_amt, net_prem_amt,
                               net_gross_tag, line_cd,
                               item_no, disc_rt, disc_amt,
                               last_update
                              )
                       VALUES (v_new_quote_id, idis.surcharge_rt,
                               idis.surcharge_amt, idis.subline_cd,
                               idis.SEQUENCE, idis.remarks,
                               idis.orig_prem_amt, idis.net_prem_amt,
                               idis.net_gross_tag, idis.line_cd,
                               idis.item_no, idis.disc_rt, idis.disc_amt,
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_item_discount
                              (quote_id, surcharge_rt,
                               surcharge_amt, subline_cd,
                               SEQUENCE, remarks,
                               orig_prem_amt, net_prem_amt,
                               net_gross_tag, line_cd,
                               item_no, disc_rt, disc_amt,
                               last_update
                              )
                       VALUES (v_quote_id_more, idis.surcharge_rt,
                               idis.surcharge_amt, idis.subline_cd,
                               idis.SEQUENCE, idis.remarks,
                               idis.orig_prem_amt, idis.net_prem_amt,
                               idis.net_gross_tag, idis.line_cd,
                               idis.item_no, idis.disc_rt, idis.disc_amt,
                               SYSDATE
                              );
               END IF;
            END LOOP;

            BEGIN
               SELECT line_cd, subline_cd, disc_rt, disc_amt,
                      net_gross_tag, orig_prem_amt, SEQUENCE, net_prem_amt,
                      remarks, surcharge_rt, surcharge_amt
                 INTO v_pol_line, v_pol_sub, v_pol_drt, v_pol_damt,
                      v_pol_ngtag, v_pol_orig, v_pol_seq, v_pol_npa,
                      v_pol_rem, v_pol_srt, v_pol_samt
                 FROM gipi_quote_polbasic_discount
                WHERE quote_id = z.quote_id;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_polbasic_discount
                              (quote_id, line_cd, subline_cd,
                               disc_rt, disc_amt, net_gross_tag,
                               orig_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_new_quote_id, v_pol_line, v_pol_sub,
                               v_pol_drt, v_pol_damt, v_pol_ngtag,
                               v_pol_orig, v_pol_seq, v_pol_npa,
                               v_pol_rem, v_pol_srt, v_pol_samt,
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_polbasic_discount
                              (quote_id, line_cd, subline_cd,
                               disc_rt, disc_amt, net_gross_tag,
                               orig_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_quote_id_more, v_pol_line, v_pol_sub,
                               v_pol_drt, v_pol_damt, v_pol_ngtag,
                               v_pol_orig, v_pol_seq, v_pol_npa,
                               v_pol_rem, v_pol_srt, v_pol_samt,
                               SYSDATE
                              );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            BEGIN
               SELECT principal_cd, engg_basic_infonum, subcon_sw
                 INTO v_pr_pcd, v_pr_engg, v_pr_sub
                 FROM gipi_quote_principal
                WHERE quote_id = z.quote_id;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_principal
                              (quote_id, principal_cd, engg_basic_infonum,
                               subcon_sw
                              )
                       VALUES (v_new_quote_id, v_pr_pcd, v_pr_engg,
                               v_pr_sub
                              );
               --COMMIT;
               ELSE
                  INSERT INTO gipi_quote_principal
                              (quote_id, principal_cd, engg_basic_infonum,
                               subcon_sw
                              )
                       VALUES (v_quote_id_more, v_pr_pcd, v_pr_engg,
                               v_pr_sub
                              );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            --added by aaron 102508 to include mortgagee
            BEGIN
               FOR mort IN (SELECT iss_cd, item_no, mortg_cd, amount,
                                   remarks
                              FROM gipi_quote_mortgagee
                             WHERE quote_id = z.quote_id)
               LOOP
                  IF v_counter = 0
                  THEN
                     INSERT INTO gipi_quote_mortgagee
                                 (quote_id, iss_cd, item_no,
                                  mortg_cd, amount, remarks,
                                  last_update, user_id
                                 )
                          VALUES (v_new_quote_id, mort.iss_cd, mort.item_no,
                                  mort.mortg_cd, mort.amount, mort.remarks,
                                  SYSDATE, p_user_id --USER --editted by MJ for consolidation 01022013
                                 );
                  ELSE
                     INSERT INTO gipi_quote_mortgagee
                                 (quote_id, iss_cd,
                                  item_no, mortg_cd, amount,
                                  remarks, last_update, user_id
                                 )
                          VALUES (v_quote_id_more, mort.iss_cd,
                                  mort.item_no, mort.mortg_cd, mort.amount,
                                  mort.remarks, SYSDATE, p_user_id --USER --editted by MJ for consolidation 01022013
                                 );
                  END IF;
               END LOOP;
            END;

            FOR pic IN (SELECT item_no, file_name, file_type, file_ext,
                               remarks
                          FROM gipi_quote_pictures
                         WHERE quote_id = z.quote_id)
            LOOP
               v_pic_item := pic.item_no;
               v_pic_fname := pic.file_name;
               v_pic_type := pic.file_type;
               v_pic_ext := pic.file_ext;
               v_pic_rem := pic.remarks;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_pictures
                              (quote_id, item_no, file_name,
                               file_type, file_ext, remarks, user_id,
                               last_update
                              )
                       VALUES (v_new_quote_id, v_pic_item, v_pic_fname,
                               v_pic_type, v_pic_ext, v_pic_rem, p_user_id, --USER, --editted by MJ for consolidation 01022013
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_pictures
                              (quote_id, item_no, file_name,
                               file_type, file_ext, remarks, user_id,
                               last_update
                              )
                       VALUES (v_quote_id_more, v_pic_item, v_pic_fname,
                               v_pic_type, v_pic_ext, v_pic_rem, p_user_id, --USER, --editted by MJ for consolidation 01022013
                               SYSDATE
                              );
               END IF;
            END LOOP;

            FOR d IN (SELECT item_no, peril_cd, ded_deductible_cd,
                             deductible_text, deductible_rt, deductible_amt
                        FROM gipi_quote_deductibles
                       WHERE quote_id = z.quote_id)
            LOOP
               v_d_item := d.item_no;
               v_d_peril := d.peril_cd;
               v_d_cd := d.ded_deductible_cd;
               v_d_text := d.deductible_text;
               v_d_amt := d.deductible_rt;
               v_d_deduct_amt := d.deductible_amt;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_deductibles
                              (quote_id, item_no, peril_cd,
                               ded_deductible_cd, deductible_text,
                               deductible_rt, user_id, last_update,
                               deductible_amt
                              )
                       VALUES (v_new_quote_id, v_d_item, v_d_peril,
                               v_d_cd, v_d_text,
                               v_d_amt, p_user_id /*USER*/, SYSDATE, --editted by MJ for consolidation 01022013
                               v_d_deduct_amt
                              );
               ELSE
                  INSERT INTO gipi_quote_deductibles
                              (quote_id, item_no, peril_cd,
                               ded_deductible_cd, deductible_text,
                               deductible_rt, user_id, last_update,
                               deductible_amt
                              )
                       VALUES (v_quote_id_more, v_d_item, v_d_peril,
                               v_d_cd, v_d_text,
                               v_d_amt, p_user_id /*USER*/, SYSDATE, --editted by MJ for consolidation 01022013
                               v_d_deduct_amt
                              );
               END IF;
            END LOOP;

            FOR pd IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                              disc_amt, net_gross_tag, discount_tag,
                              subline_cd, orig_peril_prem_amt, SEQUENCE,
                              net_prem_amt, remarks, surcharge_rt,
                              surcharge_amt
                         FROM gipi_quote_peril_discount
                        WHERE quote_id = z.quote_id)
            LOOP
               v_pd_item := pd.item_no;
               v_pd_line := pd.line_cd;
               v_pd_peril := pd.peril_cd;
               v_pd_drt := pd.disc_rt;
               v_pd_level := pd.level_tag;
               v_pd_damt := pd.disc_amt;
               v_pd_ngtag := pd.net_gross_tag;
               v_pd_dtag := pd.discount_tag;
               v_pd_sub := pd.subline_cd;
               v_pd_orig := pd.orig_peril_prem_amt;
               v_pd_seq := pd.SEQUENCE;
               v_pd_net := pd.net_prem_amt;
               v_pd_rem := pd.remarks;
               v_pd_srt := pd.surcharge_rt;
               v_pd_samt := pd.surcharge_amt;

               IF v_counter = 0
               THEN
                  INSERT INTO gipi_quote_peril_discount
                              (quote_id, item_no, line_cd,
                               peril_cd, disc_rt, level_tag, disc_amt,
                               net_gross_tag, discount_tag, subline_cd,
                               orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_new_quote_id, v_pd_item, v_pd_line,
                               v_pd_peril, v_pd_drt, v_pd_level, v_pd_damt,
                               v_pd_ngtag, v_pd_dtag, v_pd_sub,
                               v_pd_orig, v_pd_seq, v_pd_net,
                               v_pd_rem, v_pd_srt, v_pd_samt,
                               SYSDATE
                              );
               ELSE
                  INSERT INTO gipi_quote_peril_discount
                              (quote_id, item_no, line_cd,
                               peril_cd, disc_rt, level_tag, disc_amt,
                               net_gross_tag, discount_tag, subline_cd,
                               orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt,
                               last_update
                              )
                       VALUES (v_quote_id_more, v_pd_item, v_pd_line,
                               v_pd_peril, v_pd_drt, v_pd_level, v_pd_damt,
                               v_pd_ngtag, v_pd_dtag, v_pd_sub,
                               v_pd_orig, v_pd_seq, v_pd_net,
                               v_pd_rem, v_pd_srt, v_pd_samt,
                               SYSDATE
                              );
               END IF;
            END LOOP;

            v_counter := v_counter + 1;
         -- end of long loop
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      -- end of long begin-end
   ---end
   END;

   PROCEDURE generate_pack_bank_ref_no (
      p_pack_quote_id            gipi_pack_quote.pack_quote_id%TYPE,
      p_acct_iss_cd     IN       giis_ref_seq.acct_iss_cd%TYPE,
      p_branch_cd       IN       giis_ref_seq.branch_cd%TYPE,
      p_bank_ref_no     OUT      gipi_wpolbas.bank_ref_no%TYPE,
      p_msg_alert       OUT      VARCHAR2
   )
   IS
      v_ref_no       giis_ref_seq.ref_no%TYPE;
      v_dsp_mod_no   gipi_ref_no_hist.mod_no%TYPE;
   BEGIN
      generate_ref_no (p_acct_iss_cd, p_branch_cd, v_ref_no, 'GIIMM001A');

      BEGIN
         SELECT mod_no
           INTO v_dsp_mod_no
           FROM gipi_ref_no_hist
          WHERE acct_iss_cd = p_acct_iss_cd
            AND branch_cd = p_branch_cd
            AND ref_no = v_ref_no;

         p_bank_ref_no :=
               LPAD (p_acct_iss_cd, 2, 0)
            || '-'
            || LPAD (p_branch_cd, 4, 0)
            || '-'
            || LPAD (v_ref_no, 7, 0)
            || '-'
            || LPAD (v_dsp_mod_no, 2, 0);

         UPDATE gipi_quote
            SET bank_ref_no = p_bank_ref_no
          WHERE pack_quote_id = p_pack_quote_id;

         UPDATE gipi_pack_quote
            SET bank_ref_no = p_bank_ref_no
          WHERE pack_quote_id = p_pack_quote_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert :=
               'Please double check your data in generating a bank reference number.';
            ROLLBACK;
            RETURN;
      END;
   END;

   /**
      created by: Irwin Tabisora
   Date: 5.14.2012
   Description: retrieves the list of existing quotation/par/policy of assured
   **/
   FUNCTION get_existing_pack_quotations (
      p_line_cd   gipi_pack_quote.line_cd%TYPE,
      p_assd_no   gipi_pack_quote.assd_no%TYPE
   )
      RETURN existing_pack_quotation_tab PIPELINED
   IS
      v_quote      existing_pack_quotation_type;
      v_pol        VARCHAR2 (500);
      v_quote_no   VARCHAR2 (500);
      v_par_no     VARCHAR2 (500);
   BEGIN
      FOR i IN (SELECT a.pack_quote_id, a.quotation_yy, a.quotation_no,
                       a.proposal_no, a.incept_date, a.expiry_date,
                       NULL pack_par_id, NULL par_yy, NULL par_seq_no,
                       NULL quote_seq_no, NULL policy_id, a.subline_cd,
                       NULL issue_yy, NULL pol_seq_no, NULL endt_iss_cd,
                       NULL endt_yy, NULL endt_seq_no, NULL renew_no,
                       a.line_cd, a.iss_cd, a.tsi_amt tsi_amt,
                       b.assd_name assd_name, b.assd_no assd_no,
                       a.address1 address1, a.address2 address2,
                       a.address3 address3, a.status status
                  FROM giis_assured b, gipi_pack_quote a
                 WHERE 1 = 1
                   AND b.assd_no = a.assd_no
                   AND a.line_cd = p_line_cd
                   AND a.assd_no = p_assd_no
                   AND NOT EXISTS (SELECT 1
                                     FROM gipi_pack_parlist z
                                    WHERE z.quote_id = a.pack_quote_id)
                UNION
                SELECT a.quote_id, NULL quotation_yy, NULL quotation_no,
                       NULL proposal_no, b.incept_date, b.expiry_date,
                       a.pack_par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                       NULL policy_id, b.subline_cd, b.issue_yy, b.pol_seq_no,
                       b.endt_iss_cd, b.endt_yy, b.endt_seq_no, b.renew_no,
                       a.line_cd line_cd, a.iss_cd iss_cd, b.tsi_amt tsi_amt,
                       c.assd_name assd_name, c.assd_no assd_no,
                       a.address1 address1, a.address2 address2,
                       a.address3 address3, NULL status
                  FROM giis_assured c,
                       gipi_pack_wpolbas b,
                       gipi_pack_parlist a
                 WHERE 1 = 1
                   AND c.assd_no = a.assd_no
                   AND b.pack_par_id = a.pack_par_id
                   AND a.par_status NOT IN (98, 99, 10)
                   AND a.line_cd = p_line_cd
                   AND a.assd_no = p_assd_no
                   AND NOT EXISTS (SELECT 1
                                     FROM gipi_pack_quote z
                                    WHERE z.pack_quote_id = a.quote_id)
                UNION
                SELECT a.quote_id, d.quotation_yy, d.quotation_no,
                       d.proposal_no, b.incept_date, b.expiry_date,
                       a.pack_par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                       NULL pack_policy_id, b.subline_cd, b.issue_yy,
                       b.pol_seq_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no,
                       b.renew_no, a.line_cd line_cd, a.iss_cd iss_cd,
                       b.tsi_amt tsi_amt, c.assd_name assd_name,
                       c.assd_no assd_no, a.address1 address1,
                       a.address2 address2, a.address3 address3,
                       d.status status
                  FROM gipi_pack_quote d,
                       giis_assured c,
                       gipi_pack_wpolbas b,
                       gipi_pack_parlist a
                 WHERE 1 = 1
                   AND d.pack_quote_id = a.quote_id
                   AND c.assd_no = a.assd_no
                   AND b.pack_par_id = a.pack_par_id
                   AND a.par_status NOT IN (98, 99, 10)
                   AND a.line_cd = p_line_cd
                   AND a.assd_no = p_assd_no
                UNION
                SELECT a.quote_id, NULL quotation_yy, NULL quotation_no,
                       NULL proposal_no, b.incept_date, b.expiry_date,
                       a.pack_par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                       b.pack_policy_id, b.subline_cd, b.issue_yy,
                       b.pol_seq_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no,
                       b.renew_no, a.line_cd line_cd, a.iss_cd iss_cd,
                       b.tsi_amt tsi_amt, c.assd_name assd_name,
                       c.assd_no assd_no, a.address1 address1,
                       a.address2 address2, a.address3 address3, NULL status
                  FROM giis_assured c,
                       gipi_pack_polbasic b,
                       gipi_pack_parlist a
                 WHERE 1 = 1
                   AND c.assd_no = a.assd_no
                   AND b.pack_par_id = a.pack_par_id
                   AND a.par_status = 10
                   AND a.line_cd = p_line_cd
                   AND a.assd_no = p_assd_no
                   AND NOT EXISTS (SELECT 1
                                     FROM gipi_pack_quote z
                                    WHERE z.pack_quote_id = a.quote_id)
                UNION
                SELECT a.quote_id, d.quotation_yy, d.quotation_no,
                       d.proposal_no, b.incept_date, b.expiry_date,
                       a.pack_par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                       b.pack_policy_id, b.subline_cd, b.issue_yy,
                       b.pol_seq_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no,
                       b.renew_no, a.line_cd line_cd, a.iss_cd iss_cd,
                       b.tsi_amt tsi_amt, c.assd_name assd_name,
                       c.assd_no assd_no, a.address1 address1,
                       a.address2 address2, a.address3 address3,
                       d.status status
                  FROM gipi_pack_quote d,
                       giis_assured c,
                       gipi_pack_polbasic b,
                       gipi_pack_parlist a
                 WHERE 1 = 1
                   AND d.pack_quote_id = a.quote_id
                   AND c.assd_no = a.assd_no
                   AND b.pack_par_id = a.pack_par_id
                   AND a.par_status = 10
                   AND a.line_cd = p_line_cd
                   AND a.assd_no = p_assd_no)
      LOOP
         v_pol := '';
         v_quote_no := '';
         v_par_no := '';
         v_quote.pack_quote_id := i.pack_quote_id;
         v_quote.line_cd := i.line_cd;
         v_quote.iss_cd := i.iss_cd;
         v_quote.tsi_amt := i.tsi_amt;
         v_quote.assd_name := i.assd_name;
         v_quote.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_quote.incept_date := TO_CHAR (i.incept_date, 'MM-DD-YYYY');

         FOR asd IN (SELECT mail_addr1, mail_addr2, mail_addr3, assd_name
                       FROM giis_assured
                      WHERE assd_no = p_assd_no)
         LOOP
            v_quote.address :=
               asd.mail_addr1 || ' ' || asd.mail_addr2 || ' '
               || asd.mail_addr3;
         END LOOP;

         IF i.pack_quote_id IS NOT NULL
         THEN
            ---place quotation no in nbt_quote_no
            v_quote_no :=
                  i.line_cd
               || '-'
               || i.subline_cd
               || '-'
               || i.iss_cd
               || '-'
               || TO_CHAR (i.quotation_yy, '0999')
               || '-'
               || TO_CHAR (i.quotation_no, '099999')
               || '-'
               || TO_CHAR (i.proposal_no, '099');
         END IF;

         v_quote.quote_no := v_quote_no;

         --add populate of par no and policy no
         IF i.pack_par_id IS NOT NULL
         THEN
            v_par_no :=
                  i.line_cd
               || '-'
               || i.iss_cd
               || '-'
               || TO_CHAR (i.par_yy, '09')
               || '-'
               || TO_CHAR (i.par_seq_no, '099999');
         END IF;

         v_quote.par_no := v_par_no;

         IF i.policy_id IS NOT NULL
         THEN
            v_pol :=
                  i.line_cd
               || '-'
               || i.subline_cd
               || '-'
               || i.iss_cd
               || '-'
               || TO_CHAR (i.issue_yy, '09')
               || '-'
               || TO_CHAR (i.pol_seq_no, '0999999')
               || '-'
               || TO_CHAR (i.renew_no, '09');

            IF NVL (i.endt_seq_no, 0) <> 0
            THEN
               v_pol :=
                     v_pol
                  || ' / '
                  || i.endt_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (i.endt_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (i.endt_seq_no, '9999999'));
            END IF;
         END IF;

         v_quote.pol_no := v_pol;

         FOR c1 IN (SELECT rv_meaning status
                      FROM cg_ref_codes
                     WHERE rv_domain LIKE 'GIPI_PACK_QUOTE.STATUS'
                       AND rv_low_value = i.status)
         LOOP
            v_quote.status := c1.status;
         END LOOP;

         PIPE ROW (v_quote);
      END LOOP;
   END;

    FUNCTION get_ora2010_sw
       RETURN VARCHAR2
    IS
        v_param VARCHAR2(1);
    BEGIN
        SELECT param_value_v
          INTO v_param
          FROM giis_parameters
         WHERE param_name = 'ORA2010_SW';
        RETURN v_param;
    END get_ora2010_sw;   
    
    FUNCTION get_pack_quote_pic (
        p_pack_quote_id     gipi_pack_quote.pack_quote_id%TYPE
    )
        RETURN attachment_tab PIPELINED
    IS
        v_row   attachment_type;
    BEGIN
        FOR i IN (
            SELECT file_name
              FROM gipi_quote_pictures
             WHERE quote_id IN (
                SELECT quote_id
                  FROM gipi_quote
                 WHERE pack_quote_id = p_pack_quote_id
             )
        )
        LOOP
            v_row.file_name := i.file_name;
            
            PIPE ROW(v_row);
        END LOOP;
        
    END get_pack_quote_pic;
    
END gipi_pack_quote_pkg;
/


