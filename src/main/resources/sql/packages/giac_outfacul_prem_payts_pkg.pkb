CREATE OR REPLACE PACKAGE BODY CPI.giac_outfacul_prem_payts_pkg
AS
/*
   CREATED BY TONIO
   DATE: FEB 14, 2011
   MODULE ID: GIACS019
*/
   FUNCTION get_binder_dtls (
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_user               giac_outfacul_prem_payts.user_id%TYPE,
      p_module_name        VARCHAR2,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE
   )
      RETURN binder_list_tab PIPELINED
   IS
      v_binder         binder_list_type;
      v_convert_rate   giac_outfacul_prem_payts.convert_rate%TYPE;
      v_message        VARCHAR2 (1000);

      CURSOR a
      IS
         SELECT   e.line_cd, e.binder_yy, e.binder_seq_no, e.binder_date,
                  e.fnl_binder_id, a.policy_id, a.line_cd pol_line_cd,
                  a.subline_cd pol_subline_cd, a.iss_cd pol_iss_cd,
                  a.issue_yy pol_issue_yy, a.pol_seq_no pol_seq_no,
                  a.renew_no pol_renew_no,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_iss_cd) endt_iss_cd,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_yy) endt_yy,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_seq_no) endt_seq_no,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_type) endt_type,
                  a.incept_date, a.expiry_date, a.assd_no, d.currency_cd,
                  d.currency_rt curr_rt, g.currency_desc, a.par_id,
                  a.prem_warr_tag prem_tag, a.policy_id pol_policy_id,
                  /*(SELECT remarks
                     FROM giac_outfacul_prem_payts
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND d010_fnl_binder_id = e.fnl_binder_id
                      AND a180_ri_cd = p_ri_cd) remarks,*/   -- commented out SR-19631 : shan 08.17.2015
                  (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no IN (SELECT assd_no
                                        FROM gipi_parlist
                                       WHERE par_id = a.par_id)) assd_name
             FROM gipi_polbasic a,
                  giuw_pol_dist b,
                  giri_frps_ri c,
                  giri_distfrps d,
                  giri_binder e,
                  giis_currency g
            WHERE c.line_cd = d.line_cd
              AND c.frps_yy = d.frps_yy
              AND c.frps_seq_no = d.frps_seq_no
              AND d.dist_no = b.dist_no
              AND a.policy_id = b.policy_id
              AND c.fnl_binder_id = e.fnl_binder_id
              AND d.currency_cd = g.main_currency_cd
              AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
              AND e.binder_seq_no = NVL (p_binder_seq_no, e.binder_seq_no)
              AND (   (NVL (e.ri_prem_amt, 0) >= 0 AND p_transaction_type = 1
                      )
                   OR (NVL (e.ri_prem_amt, 0) < 0 AND p_transaction_type = 3)
                  )
              AND b.dist_flag NOT IN (4, 5)
              AND c.reverse_sw <> 'Y'
              AND (e.replaced_flag <> 'Y' OR e.replaced_flag IS NULL)
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND e.binder_yy = NVL (p_binder_yy, e.binder_yy)
              --  AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIACS019', p_user) = 1 --added by steven 12.10.2013 : replaced by code below : shan 09.09.2014
              AND ((SELECT access_tag       -- check_user_per_iss_cd_acctg2   -- SR-19593 : shan 07.24.2015;;; uncomment -- SR-19792, 19840 : shan 08.06.2015
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user, USER)
                              AND module_id = 'GIACS019'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user, USER)
                                                 AND b.iss_cd = a.iss_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS019')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS019'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user, USER)
                                                                AND b.iss_cd = a.iss_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS019')) = 1)
         ORDER BY e.line_cd, e.binder_yy, e.binder_seq_no;

      CURSOR b
      IS
         SELECT   i.gacc_tran_id, e.line_cd, e.binder_yy, e.binder_seq_no, e.binder_date,
                  e.fnl_binder_id, a.policy_id, a.line_cd pol_line_cd,
                  a.subline_cd pol_subline_cd, a.iss_cd pol_iss_cd,
                  a.issue_yy pol_issue_yy, a.pol_seq_no pol_seq_no,
                  a.renew_no pol_renew_no, i.record_no, get_ref_no(i.gacc_tran_id) ref_no,      -- SR-19631 : shan 08.17.015
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_iss_cd) endt_iss_cd,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_yy) endt_yy,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_seq_no) endt_seq_no,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_type) endt_type,
                  a.incept_date, a.expiry_date, a.assd_no, d.currency_cd,
                  d.currency_rt curr_rt, g.currency_desc, a.par_id,
                  e.replaced_flag, c.reverse_sw, a.policy_id pol_policy_id,
                  i.remarks, i.prem_amt, i.prem_vat, i.comm_amt, i.comm_vat,
                  i.wholding_vat, a.prem_warr_tag prem_tag,
                  (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no IN (SELECT assd_no
                                        FROM gipi_parlist
                                       WHERE par_id = a.par_id)) assd_name
             FROM gipi_polbasic a,
                  giuw_pol_dist b,
                  giri_frps_ri c,
                  giri_distfrps d,
                  giri_binder e,
                  giis_currency g,
                  giac_outfacul_prem_payts i,
                  giac_acctrans j
            WHERE i.gacc_tran_id NOT IN (
                     SELECT k.gacc_tran_id
                       FROM giac_reversals k, giac_acctrans l
                      WHERE k.reversing_tran_id = l.tran_id
                        AND k.gacc_tran_id = i.gacc_tran_id
                        AND l.tran_flag <> 'D')
              AND c.line_cd = d.line_cd
              AND c.frps_yy = d.frps_yy
              AND c.frps_seq_no = d.frps_seq_no
              AND d.dist_no = b.dist_no
              AND a.policy_id = b.policy_id
              AND c.fnl_binder_id = e.fnl_binder_id
              AND d.currency_cd = g.main_currency_cd
              AND i.d010_fnl_binder_id = e.fnl_binder_id
              AND i.gacc_tran_id = j.tran_id
              AND j.tran_flag <> 'D'
              AND (   (i.transaction_type = '1' AND p_transaction_type = 2)
                   OR (i.transaction_type = '3' AND p_transaction_type = 4)
                  )
              AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
              AND e.binder_seq_no = NVL (p_binder_seq_no, e.binder_seq_no)
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND e.binder_yy = NVL (p_binder_yy, e.binder_yy)
              AND get_ref_no(i.gacc_tran_id) != get_ref_no(p_gacc_tran_id)    --to restrict reversal on same transaction :  SR-19631 : shan 08.19.2015
              AND i.rev_gacc_tran_id IS NULL    -- SR-19631 : shan 08.19.2015
              --AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIACS019', p_user) = 1 --added by steven 12.10.2013: replaced by code below : shan 09.09.2014
              AND ((SELECT access_tag       -- check_user_per_iss_cd_acctg2   -- SR-19593 : shan 07.24.2015;;; uncomment -- SR-19792, 19840 : shan 08.06.2015
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user, USER)
                              AND module_id = 'GIACS019'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user, USER)
                                                 AND b.iss_cd = a.iss_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS019')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS019'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user, USER)
                                                                AND b.iss_cd = a.iss_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS019')) = 1)
         ORDER BY e.line_cd, e.binder_yy, e.binder_seq_no;
   BEGIN
      IF p_transaction_type IN (1, 3)
      THEN
         FOR a_rec IN a
         LOOP
            /*BEGIN       -- commented out SR-19631 : shan 08.17.2015
               SELECT convert_rate
                 INTO v_convert_rate
                 FROM giac_outfacul_prem_payts
                WHERE gacc_tran_id = p_gacc_tran_id
                  AND a180_ri_cd = p_ri_cd
                  AND d010_fnl_binder_id = a_rec.fnl_binder_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_convert_rate := 1;
            END;*/

            BEGIN
               check_disbursement_amt (p_transaction_type,
                                       p_ri_cd,
                                       p_gacc_tran_id,
                                       a_rec.fnl_binder_id,
                                       a_rec.line_cd,
                                       a_rec.binder_yy,
                                       a_rec.binder_seq_no,
                                       0,       -- SR-19631 : shan 08.19.2015
                                       a_rec.policy_id,
                                       p_user,
                                       p_module_name,
                                       v_message
                                      );
            END;

            v_binder.line_cd := a_rec.line_cd;
            v_binder.binder_yy := a_rec.binder_yy;
            v_binder.binder_seq_no := a_rec.binder_seq_no;
            v_binder.binder_date := a_rec.binder_date;
            v_binder.binder_id := a_rec.fnl_binder_id;
            v_binder.policy_id := a_rec.policy_id;
            v_binder.pol_line_cd := a_rec.pol_line_cd;
            v_binder.pol_subline_cd := a_rec.pol_subline_cd;
            v_binder.pol_iss_cd := a_rec.pol_iss_cd;
            v_binder.pol_issue_yy := a_rec.pol_issue_yy;
            v_binder.pol_seq_no := a_rec.pol_seq_no;
            v_binder.pol_renew_no := a_rec.pol_renew_no;
            v_binder.endt_iss_cd := a_rec.endt_iss_cd;
            v_binder.endt_yy := a_rec.endt_yy;
            v_binder.endt_seq_no := a_rec.endt_seq_no;
            v_binder.endt_type := a_rec.endt_type;
            v_binder.incept_date := a_rec.incept_date;
            v_binder.expiry_date := a_rec.expiry_date;
            v_binder.assd_no := a_rec.assd_no;
            v_binder.currency_cd := a_rec.currency_cd;
            v_binder.currency_rt := a_rec.curr_rt;
            v_binder.currency_desc := a_rec.currency_desc;
            v_binder.par_id := a_rec.par_id;
            v_binder.assd_name := a_rec.assd_name;
            IF a_rec.endt_type IS NOT NULL THEN --added by steven 10.29.2013
             v_binder.policy_no :=
                  get_policy_no (a_rec.pol_policy_id) || '-'
                  || a_rec.endt_type;
            ELSE
             v_binder.policy_no :=
                  get_policy_no (a_rec.pol_policy_id);
            END IF;
           
            v_binder.disbursement_amt :=
               giac_outfacul_prem_payts_pkg.get_list_disb_amt
                                         (p_transaction_type,
                                          p_ri_cd,
                                          a_rec.line_cd,
                                          a_rec.binder_yy,
                                          a_rec.fnl_binder_id,
                                          a_rec.binder_seq_no,
                                          v_convert_rate,
                                          a_rec.pol_policy_id,
                                          giac_validate_user_fn (p_user,
                                                                 'OD',
                                                                 p_module_name
                                                                )
                                         , null); -- SR-19631 : shan 08.17.2015
            v_binder.disbursement_amt_local := v_binder.disbursement_amt * v_binder.currency_rt; --added by steven 11.26.2014
            v_binder.prem_tag := a_rec.prem_tag;
            v_binder.prem_seq_no :=
               giac_outfacul_prem_payts_pkg.get_iss_prem_seq_no
                                                         (a_rec.fnl_binder_id,
                                                          a_rec.line_cd,
                                                          p_ri_cd
                                                         );
            v_binder.MESSAGE := v_message;
            PIPE ROW (v_binder);
         END LOOP;
      ELSIF p_transaction_type IN (2, 4)
      THEN
         FOR b_rec IN b
         LOOP
            BEGIN
               SELECT convert_rate
                 INTO v_convert_rate
                 FROM giac_outfacul_prem_payts
                WHERE gacc_tran_id = p_gacc_tran_id
                  AND a180_ri_cd = p_ri_cd
                  AND d010_fnl_binder_id = b_rec.fnl_binder_id
                  AND record_no = b_rec.record_no;  -- SR-19631 : shan 08.17.2015
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_convert_rate := 1;
            END;
            
            v_message := check_open_tran(p_transaction_type, p_ri_cd, b_rec.fnl_binder_id, b_rec.gacc_tran_id);   -- SR-19631 : shan 08.17.2015
            
            IF v_message IS NULL THEN
                BEGIN
                   check_disbursement_amt (p_transaction_type,
                                           p_ri_cd,
                                           p_gacc_tran_id,
                                           b_rec.fnl_binder_id,
                                           b_rec.line_cd,
                                           b_rec.binder_yy,
                                           b_rec.binder_seq_no,
                                           b_rec.record_no,    -- SR-19631 : shan 08.19.2015
                                           b_rec.policy_id,
                                           p_user,
                                           p_module_name,
                                           v_message
                                          );
                END;
            END IF;

            v_binder.line_cd := b_rec.line_cd;
            v_binder.binder_yy := b_rec.binder_yy;
            v_binder.binder_seq_no := b_rec.binder_seq_no;
            v_binder.binder_date := b_rec.binder_date;
            v_binder.binder_id := b_rec.fnl_binder_id;
            v_binder.payt_gacc_tran_id   := b_rec.gacc_tran_id;   -- SR-19631 : shan 08.17.2105
            v_binder.record_no  := b_rec.record_no; -- SR-19631 : shan 08.17.2105
            v_binder.policy_id := b_rec.policy_id;
            v_binder.pol_line_cd := b_rec.pol_line_cd;
            v_binder.pol_subline_cd := b_rec.pol_subline_cd;
            v_binder.pol_iss_cd := b_rec.pol_iss_cd;
            v_binder.pol_issue_yy := b_rec.pol_issue_yy;
            v_binder.pol_seq_no := b_rec.pol_seq_no;
            v_binder.pol_renew_no := b_rec.pol_renew_no;
            v_binder.endt_iss_cd := b_rec.endt_iss_cd;
            v_binder.endt_yy := b_rec.endt_yy;
            v_binder.endt_seq_no := b_rec.endt_seq_no;
            v_binder.endt_type := b_rec.endt_type;
            v_binder.incept_date := b_rec.incept_date;
            v_binder.expiry_date := b_rec.expiry_date;
            v_binder.assd_no := b_rec.assd_no;
            v_binder.currency_cd := b_rec.currency_cd;
            v_binder.currency_rt := b_rec.curr_rt;
            v_binder.currency_desc := b_rec.currency_desc;
            v_binder.par_id := b_rec.par_id;
            v_binder.replaced_flag := b_rec.replaced_flag;
            v_binder.reverse_sw := b_rec.reverse_sw;
            v_binder.assd_name := b_rec.assd_name;
            v_binder.remarks := b_rec.remarks;
            v_binder.ref_no     := b_rec.ref_no;    -- SR-19631 : shan 08.19.2015
            v_binder.policy_no :=
                  get_policy_no (b_rec.pol_policy_id) || '-'
                  || b_rec.endt_type;
            v_binder.disbursement_amt :=
               giac_outfacul_prem_payts_pkg.get_list_disb_amt
                                         (p_transaction_type,
                                          p_ri_cd,
                                          b_rec.line_cd,
                                          b_rec.binder_yy,
                                          b_rec.fnl_binder_id,
                                          b_rec.binder_seq_no,
                                          v_convert_rate,
                                          b_rec.pol_policy_id,
                                          giac_validate_user_fn (p_user,
                                                                 'OD',
                                                                 p_module_name
                                                                )
                                          , b_rec.gacc_tran_id);    -- SR-19631 : shan 08.17.2015
            v_binder.disbursement_amt_local := v_binder.disbursement_amt * v_binder.currency_rt; --added by steven 11.26.2014
            v_binder.prem_amt := b_rec.prem_amt;
            v_binder.prem_vat := b_rec.prem_vat;
            v_binder.comm_amt := b_rec.comm_amt;
            v_binder.comm_vat := b_rec.comm_vat;
            v_binder.wholding_vat := b_rec.wholding_vat;
            v_binder.prem_tag := b_rec.prem_tag;
            v_binder.prem_seq_no :=
               giac_outfacul_prem_payts_pkg.get_iss_prem_seq_no
                                                         (b_rec.fnl_binder_id,
                                                          b_rec.line_cd,
                                                          p_ri_cd
                                                         );
            v_binder.MESSAGE := v_message;
            PIPE ROW (v_binder);
         END LOOP;
      END IF;
   END get_binder_dtls;

   FUNCTION get_list_disb_amt (
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_binder_id          giri_binder.fnl_binder_id%TYPE,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE,
      p_convert_rate       giac_outfacul_prem_payts.convert_rate%TYPE,
      p_policy_id          gipi_polbasic.policy_id%TYPE,
      p_allow_def          VARCHAR2,
      p_gacc_tran_id       GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE   -- SR-19631 : shan 08.17.2015
   )
      RETURN NUMBER
   IS
      v_payable_exists           giri_binder.ri_prem_amt%TYPE            := 0;
      v_total_payable            giri_binder.ri_prem_amt%TYPE            := 0;
      v_total_receivable         gipi_invoice.prem_amt%TYPE;
      v_actual_prem_collection   NUMBER := 0;--giac_direct_prem_collns.collection_amt%TYPE -- bonok :: 9.22.2015 :: SR 20296 :: changed data type to NUMBER
                                             --                          := 0;
      v_actual_payments          NUMBER := 0;--giac_outfacul_prem_payts.disbursement_amt%TYPE
                                             --                          := 0;
      v_percent_payable          NUMBER := 0;--giac_outfacul_prem_payts.disbursement_amt%TYPE
                                             --                          := 0;
      v_default_disb_amt         NUMBER := 0;--giac_outfacul_prem_payts.disbursement_amt%TYPE
                                             --                          := 0;
      al_button                  NUMBER;
      v_iss_cd                   gipi_invoice.iss_cd%TYPE;
      v_prem_seq_no              gipi_invoice.prem_seq_no%TYPE;
      v_set_prem_switch          BOOLEAN                             := FALSE;
      v_currency_rt              gipi_invoice.currency_rt%TYPE;
   BEGIN
      FOR a1 IN (SELECT g.iss_cd, g.prem_seq_no
                   FROM giri_binder a,
                        giri_frps_ri b,
                        giri_distfrps c,
                        giuw_policyds d,
                        giuw_pol_dist e,
                        gipi_polbasic f,
                        gipi_invoice g
                  WHERE f.policy_id = g.policy_id
                    AND e.policy_id = f.policy_id
                    AND d.dist_no = e.dist_no
                    AND c.dist_no = d.dist_no
                    AND c.dist_seq_no = d.dist_seq_no
                    AND b.line_cd = c.line_cd
                    AND b.frps_yy = c.frps_yy
                    AND b.frps_seq_no = c.frps_seq_no
                    AND a.fnl_binder_id = b.fnl_binder_id
                    AND a.ri_cd = p_ri_cd
                    AND a.line_cd = p_line_cd
                    AND a.fnl_binder_id = p_binder_id)
      LOOP
         v_iss_cd := a1.iss_cd;
         v_prem_seq_no := a1.prem_seq_no;
         EXIT;
      END LOOP;
      --added by steven 12.12.2014
      FOR i IN (SELECT currency_rt
                   FROM gipi_invoice
                  WHERE iss_cd = v_iss_cd AND prem_seq_no = v_prem_seq_no)
      LOOP
          v_currency_rt := i.currency_rt;
          EXIT;
      END LOOP;

      FOR a1 IN (SELECT NVL (ri_prem_amt, 0) ri_prem
                   FROM giri_binder
                  WHERE binder_yy = p_binder_yy
                    AND line_cd = p_line_cd
                    AND binder_seq_no = p_binder_seq_no
                    AND ri_cd = p_ri_cd)
      LOOP
         v_payable_exists := a1.ri_prem;
         EXIT;
      END LOOP;

      FOR a2 IN (SELECT (  (NVL (ri_prem_amt, 0) + NVL (ri_prem_vat, 0))
                         - (  NVL (ri_comm_amt, 0)
                            + NVL (ri_comm_vat, 0)
                            + NVL (ri_wholding_vat, 0)
                           )
                        ) tot_payable
                   FROM giri_binder
                  WHERE binder_yy = p_binder_yy
                    AND line_cd = p_line_cd
                    AND binder_seq_no = p_binder_seq_no
                    AND ri_cd = p_ri_cd)
      LOOP
         v_total_payable := (a2.tot_payable) * NVL (p_convert_rate, 1);
         EXIT;
      END LOOP;

      FOR a5 IN (SELECT NVL (prem_amt, 0) tot_receivable
                   FROM gipi_invoice
                  WHERE iss_cd = v_iss_cd AND prem_seq_no = v_prem_seq_no)
      LOOP
         v_total_receivable := a5.tot_receivable;
         EXIT;
      END LOOP;

      v_set_prem_switch := FALSE;

      FOR c1 IN (SELECT 1
                   FROM gipi_polbasic a, giri_inpolbas b
                  WHERE a.policy_id = b.policy_id
                        AND a.policy_id = p_policy_id)
      LOOP
         v_set_prem_switch := TRUE;
      END LOOP;

      IF v_set_prem_switch = TRUE
      THEN
         FOR a4 IN (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll 
                      FROM giac_inwfacul_prem_collns gipc,
                           gipi_invoice b140,
                           giac_acctrans gacc
                     WHERE gipc.b140_iss_cd = b140.iss_cd
                       AND gipc.b140_prem_seq_no = b140.prem_seq_no
                       AND gipc.gacc_tran_id = gacc.tran_id
                       AND gacc.tran_flag <> 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_acctrans c, giac_reversals d
                               WHERE c.tran_flag != 'D'
                                 AND c.tran_id = d.reversing_tran_id
                                 AND d.gacc_tran_id = gacc.tran_id)
                       AND gipc.b140_iss_cd = v_iss_cd
                       AND gipc.b140_prem_seq_no = v_prem_seq_no)
         LOOP
            v_actual_prem_collection := a4.actual_prem_coll / v_currency_rt; --added by steven 12.12.2014 convert to foriegn currency
            EXIT;
         END LOOP;
      ELSIF v_set_prem_switch = FALSE
      THEN
         FOR a4 IN (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll
                      FROM giac_direct_prem_collns gdpc,
                           gipi_invoice b140,
                           giac_acctrans gacc
                     WHERE gdpc.b140_iss_cd = b140.iss_cd
                       AND gdpc.b140_prem_seq_no = b140.prem_seq_no
                       AND gdpc.gacc_tran_id = gacc.tran_id
                       AND gacc.tran_flag <> 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_acctrans c, giac_reversals d
                               WHERE c.tran_flag != 'D'
                                 AND c.tran_id = d.reversing_tran_id
                                 AND d.gacc_tran_id = gacc.tran_id)
                       AND gdpc.b140_iss_cd = v_iss_cd
                       AND gdpc.b140_prem_seq_no = v_prem_seq_no)
         LOOP
            v_actual_prem_collection := a4.actual_prem_coll / v_currency_rt; --added by steven 12.12.2014 convert to foriegn currency
            EXIT;
         END LOOP;
      END IF;

      IF v_payable_exists >= 0
      THEN
         IF p_transaction_type IN (1, 2)
         THEN
            FOR a5 IN
               (SELECT NVL (SUM (gfpp.disbursement_amt), 0) actual_payments
                  FROM giac_outfacul_prem_payts gfpp,
                       giac_acctrans gacc,
                       giri_binder gibr
                 WHERE gfpp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_flag != 'D'
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM giac_acctrans c, giac_reversals d
                           WHERE c.tran_flag != 'D'
                             AND c.tran_id = d.reversing_tran_id
                             AND d.gacc_tran_id = gacc.tran_id)
                   AND gfpp.d010_fnl_binder_id = gibr.fnl_binder_id
                   AND binder_yy = p_binder_yy
                   AND line_cd = p_line_cd
                   AND binder_seq_no = p_binder_seq_no
                   AND ri_cd = p_ri_cd
                   --AND gfpp.transaction_type IN (1, 2) -- replaced with codes below ::: SR-19631 : shan 08.17.2015
                   AND (
                        (p_transaction_type = 2 AND gfpp.gacc_tran_id = p_gacc_tran_id)
                        OR
                        p_transaction_type = 1))
            LOOP
               --v_actual_payments := a5.actual_payments;
               v_actual_payments := a5.actual_payments / v_currency_rt; -- bonok :: 9.22.2015 :: SR 20296 
               EXIT;
            END LOOP;

            IF v_total_receivable = 0
            THEN
               v_percent_payable := NULL;
            ELSE
               v_percent_payable :=
                    (v_actual_prem_collection / v_total_receivable
                    )
                  * v_total_payable;
            END IF;

            IF p_transaction_type = 1
            THEN
               v_default_disb_amt := v_percent_payable - v_actual_payments;

               --IF p_allow_def = 'TRUE'
               --THEN
                  IF ROUND(v_default_disb_amt,2) <= 0 OR p_allow_def = 'TRUE'-- bonok :: 9.22.2015 :: SR 20296 :: added ROUND , --nieko 06212016, SR 22501 KB3560
                  THEN
                     v_default_disb_amt :=
                                          v_total_payable - v_actual_payments;
                  END IF;
               --END IF;
            ELSIF p_transaction_type = 2
            THEN
               v_default_disb_amt := (-1) * v_actual_payments;
            END IF;
         END IF;
      ELSIF v_payable_exists < 0
      THEN
         IF p_transaction_type IN (3, 4)
         THEN
            FOR a6 IN
               (SELECT NVL (SUM (gfpp.disbursement_amt), 0) actual_payments
                  FROM giac_outfacul_prem_payts gfpp,
                       giac_acctrans gacc,
                       giri_binder gibr
                 WHERE gfpp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_flag != 'D'
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM giac_acctrans c, giac_reversals d
                           WHERE c.tran_flag != 'D'
                             AND c.tran_id = d.reversing_tran_id
                             AND d.gacc_tran_id = gacc.tran_id)
                   AND gfpp.d010_fnl_binder_id = gibr.fnl_binder_id
                   AND gibr.binder_yy = p_binder_yy
                   AND gibr.line_cd = p_line_cd
                   AND gibr.binder_seq_no = p_binder_seq_no
                   AND gibr.ri_cd = p_ri_cd --Deo [01.27.2017]: SR-23187
                   --AND gfpp.transaction_type IN (3, 4) -- replaced with codes below ::: SR-19631 : shan 08.17.2015
                   AND (
                        (p_transaction_type = 4/*3*/ AND gfpp.gacc_tran_id = p_gacc_tran_id) --Deo [01.27.2017]: replace 3 with 4 (SR-23187)
                        OR
                        p_transaction_type = 3/*4*/)) --Deo [01.27.2017]: replace 4 with 3 (SR-23187)
            LOOP
               --v_actual_payments := a6.actual_payments;
                v_actual_payments := a6.actual_payments / v_currency_rt; -- bonok :: 9.22.2015 :: SR 20296 
               EXIT;
            END LOOP;

            IF v_total_receivable = 0
            THEN
               v_percent_payable := NULL;
            ELSE
               v_percent_payable :=
                    (v_actual_prem_collection / v_total_receivable
                    )
                  * v_total_payable;
            END IF;

            IF p_transaction_type = 3
            THEN
               v_default_disb_amt := v_percent_payable - v_actual_payments;

               --IF p_allow_def = 'TRUE'
               --THEN
                  IF ROUND(v_default_disb_amt,2) <= 0 OR p_allow_def = 'TRUE' -- bonok :: 9.22.2015 :: SR 20296 :: added ROUND --nieko 06212016, SR 22501 KB3560
                  	 OR v_total_payable = v_actual_payments --Deo [02.03.2017]: SR-23187
                  THEN
                     v_default_disb_amt :=
                                          v_total_payable - v_actual_payments;
                  END IF;
               --END IF;
            ELSIF p_transaction_type = 4
            THEN
               v_default_disb_amt := (-1) * v_actual_payments;
            END IF;
         END IF;
      END IF;
      RETURN (v_default_disb_amt);
   END get_list_disb_amt;

   FUNCTION get_giac_outfacul_prem_payts (
      p_gacc_tran_id   giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_user           VARCHAR2,
      p_module_name    VARCHAR2
   )
      RETURN binder_list_tab PIPELINED
   AS
      v_binder   binder_list_type;
   BEGIN
      FOR i IN (SELECT fnl_binder_id, a.transaction_type, b.line_cd,
                       b.binder_yy, b.binder_seq_no, a180_ri_cd,
                       disbursement_amt, a.remarks,a.or_print_tag,
                       cm_tag, -- added by: Nica 06.10.2013 for OR RI Comm Enh.
                       (SELECT ri_name
                          FROM giis_reinsurer
                         WHERE ri_cd = a180_ri_cd) ri_name
                  FROM giac_outfacul_prem_payts a, giri_binder b
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND b.fnl_binder_id = a.d010_fnl_binder_id)
      LOOP
         FOR j IN
            (SELECT *
               FROM TABLE
                       (giac_outfacul_prem_payts_pkg.get_binder_dtls
                                                          (i.transaction_type,
                                                           i.a180_ri_cd,
                                                           i.line_cd,
                                                           i.binder_yy,
                                                           p_gacc_tran_id,
                                                           p_user,
                                                           p_module_name,
                                                           i.binder_seq_no
                                                          )
                       ))
         LOOP
            v_binder.line_cd 		:= j.line_cd;
            v_binder.binder_yy 		:= j.binder_yy;
            v_binder.binder_seq_no 	:= j.binder_seq_no;
            v_binder.binder_date 	:= j.binder_date;
            v_binder.binder_id 		:= j.binder_id;
            v_binder.policy_id 		:= j.policy_id;
            v_binder.pol_line_cd 	:= j.pol_line_cd;
            v_binder.pol_subline_cd := j.pol_subline_cd;
            v_binder.pol_iss_cd 	:= j.pol_iss_cd;
            v_binder.pol_issue_yy 	:= j.pol_issue_yy;
            v_binder.pol_seq_no 	:= j.pol_seq_no;
            v_binder.pol_renew_no 	:= j.pol_renew_no;
            v_binder.endt_iss_cd 	:= j.endt_iss_cd;
            v_binder.endt_yy 		:= j.endt_yy;
            v_binder.endt_seq_no 	:= j.endt_seq_no;
            v_binder.endt_type 		:= j.endt_type;
            v_binder.incept_date 	:= j.incept_date;
            v_binder.expiry_date 	:= j.expiry_date;
            v_binder.assd_no 		:= j.assd_no;
            v_binder.currency_cd 	:= j.currency_cd;
            v_binder.currency_rt 	:= j.currency_rt;
            v_binder.currency_desc 	:= j.currency_desc;
            v_binder.par_id 		:= j.par_id;
            v_binder.assd_name 		:= j.assd_name;
            v_binder.policy_no 		:= j.policy_no;
            v_binder.disbursement_amt := i.disbursement_amt;
            v_binder.ri_cd 			:= i.a180_ri_cd;
            v_binder.ri_name 		:= i.ri_name;
            v_binder.transaction_type := i.transaction_type;
			v_binder.or_print_tag 	:= i.or_print_tag;  --added by steven 07.13.2012
            v_binder.remarks 		:= i.remarks;
            v_binder.MESSAGE 		:= j.MESSAGE;
            v_binder.cm_tag         := i.cm_tag; -- added by: Nica 06.10.2013 for OR RI Comm Enh.
            PIPE ROW (v_binder);
         END LOOP;
      END LOOP;
   END;

   PROCEDURE save_giac_outfacul_prem_payts (
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_binder_id          giac_outfacul_prem_payts.d010_fnl_binder_id%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_disbursement_amt   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      p_prem_amt           giac_outfacul_prem_payts.prem_amt%TYPE,
      p_prem_vat           giac_outfacul_prem_payts.prem_vat%TYPE,
      p_comm_amt           giac_outfacul_prem_payts.comm_amt%TYPE,
      p_comm_vat           giac_outfacul_prem_payts.comm_vat%TYPE,
      p_wholding_vat       giac_outfacul_prem_payts.wholding_vat%TYPE,
      p_remarks            giac_outfacul_prem_payts.remarks%TYPE,
      p_currency_cd        giac_outfacul_prem_payts.currency_cd%TYPE,
      p_convert_rate       giac_outfacul_prem_payts.convert_rate%TYPE,
      p_foreign_curr_amt   giac_outfacul_prem_payts.foreign_curr_amt%TYPE,
      p_or_print_tag       giac_outfacul_prem_payts.or_print_tag%TYPE,
      p_cm_tag             giac_outfacul_prem_payts.cm_tag%TYPE, -- added by: Nica 06.10.2013
      p_user_id            giac_outfacul_prem_payts.user_id%TYPE,
      p_record_no          giac_outfacul_prem_payts.record_no%TYPE  -- SR_19631 : shan 08.17.2015
   )
   IS
   BEGIN
      MERGE INTO giac_outfacul_prem_payts
         USING DUAL
         ON (    gacc_tran_id = p_gacc_tran_id
             AND a180_ri_cd = p_ri_cd
             AND d010_fnl_binder_id = p_binder_id
             AND record_no = p_record_no)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, d010_fnl_binder_id, a180_ri_cd,
                    transaction_type, disbursement_amt, prem_amt, prem_vat,
                    comm_amt, comm_vat, wholding_vat, remarks, currency_cd,
                    user_id, last_update, convert_rate, foreign_curr_amt,
                    or_print_tag, cm_tag, record_no)    -- SR-19631 : shan 08.13.2015
            VALUES (p_gacc_tran_id, p_binder_id, p_ri_cd, p_transaction_type,
                    p_disbursement_amt, p_prem_amt, p_prem_vat, p_comm_amt,
                    p_comm_vat, p_wholding_vat, p_remarks, p_currency_cd,
                    p_user_id, SYSDATE, p_convert_rate, p_foreign_curr_amt,
                    p_or_print_tag, p_cm_tag, NVL(p_record_no, 0));       -- SR-19631 : shan 08.13.2015
   END save_giac_outfacul_prem_payts;

   PROCEDURE delete_giac_outfacul_prem (
      p_gacc_tran_id   giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_binder_id      giac_outfacul_prem_payts.d010_fnl_binder_id%TYPE,
      p_ri_cd          giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_record_no      giac_outfacul_prem_payts.record_no%type  -- SR-19631 : shan 08.18.2015
   )
   IS
   BEGIN
      DELETE FROM giac_outfacul_prem_payts
            WHERE gacc_tran_id = p_gacc_tran_id
              AND d010_fnl_binder_id = p_binder_id
              AND a180_ri_cd = p_ri_cd
              AND record_no = p_record_no;  -- SR-19631 : shan 08.18.2015
   END;

   PROCEDURE get_override_disbursement_amt (
      p_transaction_type         giac_outfacul_prem_payts.transaction_type%TYPE,
      p_binder_yy                giri_binder.binder_yy%TYPE,
      p_line_cd                  giri_binder.line_cd%TYPE,
      p_binder_seq_no            giri_binder.binder_seq_no%TYPE,
      p_binder_id                giri_binder.fnl_binder_id%TYPE,
      p_disbursement_amt   OUT   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      p_message            OUT   VARCHAR2
   )
   IS
      amount1          giac_outfacul_prem_payts.disbursement_amt%TYPE   := 0;
      amount2          giac_outfacul_prem_payts.disbursement_amt%TYPE   := 0;
      ws_disbmnt       giac_outfacul_prem_payts.disbursement_amt%TYPE   := 0;
      ws_ri_prem_amt   giri_binder.ri_prem_amt%TYPE                     := 0;
   BEGIN
      SELECT NVL (ri_prem_amt, 0)
        INTO ws_ri_prem_amt
        FROM giri_binder
       WHERE binder_yy = p_binder_yy
         AND line_cd = p_line_cd
         AND binder_seq_no = p_binder_seq_no;

      IF (ws_ri_prem_amt >= 0)
      THEN
         IF p_transaction_type IN (1, 2)
         THEN
            SELECT NVL (SUM (NVL (a.disbursement_amt, 0)), 0)
              INTO amount2
              FROM giac_outfacul_prem_payts a, giac_acctrans b
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_flag != 'D'
               AND NOT EXISTS (
                      SELECT '1'
                        FROM giac_acctrans c, giac_reversals d
                       WHERE c.tran_flag != 'D'
                         AND c.tran_id = d.reversing_tran_id
                         AND d.gacc_tran_id = b.tran_id)
               AND a.d010_fnl_binder_id = p_binder_id
               AND a.transaction_type IN (1, 2);

            IF p_transaction_type = 1
            THEN
               SELECT   (  (  NVL (a.ri_prem_amt, 0)
                            + NVL (a.ri_prem_vat, 0)
                            - NVL (a.prem_tax, 0)
                           )
                         - (  NVL (a.ri_comm_amt, 0)
                            + NVL (a.ri_comm_vat, 0)
                            + NVL (a.ri_wholding_vat, 0)
                           )
                        )
                      * c.currency_rt
                 INTO amount1
                 FROM giri_binder a, giri_frps_ri b, giri_distfrps c
                WHERE a.binder_yy = p_binder_yy
                  AND a.line_cd = p_line_cd
                  AND a.binder_seq_no = p_binder_seq_no
                  AND a.fnl_binder_id = b.fnl_binder_id
                  AND b.line_cd = c.line_cd
                  AND b.frps_yy = c.frps_yy
                  AND b.frps_seq_no = c.frps_seq_no;

               ws_disbmnt := amount1 - amount2;

               IF ws_disbmnt = 0
               THEN
                  p_message := ' No valid value for entered Binder No. ';
                  RETURN;
               ELSIF ws_disbmnt < 0
               THEN
                  p_message := ' Negative amount for entered Binder No. ';
                  RETURN;
               END IF;
            ELSIF p_transaction_type = 2
            THEN
               ws_disbmnt := (-1) * amount2;

               IF ws_disbmnt = 0
               THEN
                  p_message := ' No valid value for entered Binder No. ';
                  RETURN;
               ELSIF ws_disbmnt > 0
               THEN
                  p_message := '  Binder No. ';
                  RETURN;
               END IF;
            END IF;
         ELSE
            p_message :=
               ' This is a positive binder. Only transaction type [1,2] are allowed. ';
            RETURN;
         END IF;
      ELSIF (ws_ri_prem_amt < 0)
      THEN
         IF p_transaction_type IN (3, 4)
         THEN
            SELECT NVL (SUM (NVL (a.disbursement_amt, 0)), 0)
              INTO amount2
              FROM giac_outfacul_prem_payts a, giac_acctrans b
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_flag != 'D'
               AND NOT EXISTS (
                      SELECT '1'
                        FROM giac_acctrans c, giac_reversals d
                       WHERE c.tran_flag != 'D'
                         AND c.tran_id = d.reversing_tran_id
                         AND d.gacc_tran_id = b.tran_id)
               AND a.d010_fnl_binder_id = p_binder_id
               AND a.transaction_type IN (3, 4);

            IF p_transaction_type = 3
            THEN
               SELECT   (  (  NVL (a.ri_prem_amt, 0)
                            + NVL (a.ri_prem_vat, 0)
                            - NVL (a.prem_tax, 0)
                           )
                         - (  NVL (a.ri_comm_amt, 0)
                            + NVL (a.ri_comm_vat, 0)
                            + NVL (a.ri_wholding_vat, 0)
                           )
                        )
                      * c.currency_rt
                 INTO amount1
                 FROM giri_binder a, giri_frps_ri b, giri_distfrps c
                WHERE a.fnl_binder_id = p_binder_id
                  AND a.fnl_binder_id = b.fnl_binder_id
                  AND b.line_cd = c.line_cd
                  AND b.frps_yy = c.frps_yy
                  AND b.frps_seq_no = c.frps_seq_no;

               ws_disbmnt := amount1 - amount2;

               IF ws_disbmnt = 0
               THEN
                  p_message := ' No valid value for entered Binder No. ';
                  RETURN;
               ELSIF ws_disbmnt > 0
               THEN
                  p_message := ' Positive amount for entered Binder No. ';
                  RETURN;
               END IF;
            ELSIF p_transaction_type = 4
            THEN
               ws_disbmnt := (-1) * amount2;

               IF ws_disbmnt = 0
               THEN
                  p_message := ' No valid value for entered Binder No. ';
                  RETURN;
               ELSIF ws_disbmnt < 0
               THEN
                  p_message := ' Negative amount for entered Binder No. ';
                  RETURN;
               END IF;
            END IF;
         ELSE
            p_message :=
               ' This is a negative binder. Only transaction type [3,4] are allowed. ';
            RETURN;
         END IF;
      END IF;

      IF p_transaction_type IN (1, 3)
      THEN
         p_disbursement_amt := ws_disbmnt;
      ELSE
         p_disbursement_amt := ws_disbmnt;
      END IF;

      IF p_message IS NULL
      THEN
         p_message := ' ';
      END IF;
   END get_override_disbursement_amt;

   PROCEDURE get_disb_amt_for_but_revert (
      p_binder_id                giri_binder.fnl_binder_id%TYPE,
      p_transaction_type         giac_outfacul_prem_payts.transaction_type%TYPE,
      p_gacc_tran_id             giac_outfacul_prem_payts.gacc_tran_id%TYPE,
	  p_line_cd     	   		 giri_binder.line_cd%TYPE,
      p_ri_cd       			 giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_disbursement_amt   OUT   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      p_message            OUT   VARCHAR2
   )
   IS
      v_payable_exists           giri_binder.ri_prem_amt%TYPE            := 0;
      v_total_payable            giri_binder.ri_prem_amt%TYPE            := 0;
      v_total_receivable         gipi_invoice.prem_amt%TYPE;
      v_actual_prem_collection   giac_direct_prem_collns.collection_amt%TYPE
                                                                         := 0;
      v_actual_payments          giac_outfacul_prem_payts.disbursement_amt%TYPE
                                                                         := 0;
      v_percent_payable          giac_outfacul_prem_payts.disbursement_amt%TYPE
                                                                         := 0;
      v_default_disb_amt         giac_outfacul_prem_payts.disbursement_amt%TYPE
                                                                         := 0;
      v_line_cd                  giri_binder.line_cd%TYPE;
      v_ri_cd                    giri_binder.ri_cd%TYPE;
      v_convert_rate             giac_outfacul_prem_payts.convert_rate%TYPE;
	  v_iss_cd		 gipi_invoice.iss_cd%type;
	  v_prem_seq_no  gipi_invoice.prem_seq_no%type;				 
   BEGIN
   
   	  get_facul_iss_cd_prem_seq_no(p_binder_id, p_line_cd, p_ri_cd, v_iss_cd, v_prem_seq_no);
	  
      FOR a1 IN (SELECT NVL (ri_prem_amt, 0) ri_prem
                   FROM giri_binder
                  WHERE fnl_binder_id = p_binder_id)
      LOOP
         v_payable_exists := a1.ri_prem;

         EXIT;
      END LOOP;

      BEGIN
         SELECT convert_rate
           INTO v_convert_rate
           FROM giac_outfacul_prem_payts
          WHERE gacc_tran_id = p_gacc_tran_id
            AND a180_ri_cd = p_ri_cd
            AND d010_fnl_binder_id = p_binder_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_convert_rate := 1;
      END;

      -- get total outfacul premium payable.
      FOR a2 IN
         (SELECT                    /*(
                                      NVL(ri_prem_amt,0) -
                                      ( NVL(ri_comm_amt,0) + NVL(prem_tax,0) )
                                     ) tot_payable */
                 (  (  NVL (ri_prem_amt, 0)
                     + NVL (ri_prem_vat, 0)
                     - NVL (prem_tax, 0)
                    )
                  - (  NVL (ri_comm_amt, 0)
                     + NVL (ri_comm_vat, 0)
                     + NVL (ri_wholding_vat, 0)
                    )
                 ) tot_payable
            FROM giri_binder
           WHERE fnl_binder_id = p_binder_id)
      LOOP
         v_total_payable := (a2.tot_payable) * NVL (v_convert_rate, 1);
         EXIT;
      END LOOP;

      -- get total premium receivable.
      FOR a5 IN
         (SELECT (NVL (prem_amt, 0) * currency_rt) tot_receivable
            FROM gipi_invoice
           WHERE iss_cd = v_iss_cd
             AND prem_seq_no =
                    (giac_outfacul_prem_payts_pkg.get_iss_prem_seq_no
                                                                 (p_binder_id,
                                                                  p_line_cd,
                                                                  p_ri_cd
                                                                 )
                    ))
      LOOP
         v_total_receivable := a5.tot_receivable;
         EXIT;
      END LOOP;

      -- get total premium collections made so far.
      FOR a4 IN
         (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll
            FROM giac_direct_prem_collns gdpc,
                 gipi_invoice b140,
                 giac_acctrans gacc
           WHERE gdpc.b140_iss_cd = b140.iss_cd
             AND gdpc.b140_prem_seq_no = b140.prem_seq_no
             AND gdpc.b140_iss_cd = v_iss_cd
             AND gdpc.gacc_tran_id = gacc.tran_id
             AND gacc.tran_flag != 'D'                          -- starts here
             AND NOT EXISTS (
                    SELECT '1'                       -- added by rj 02/18/2000
                      FROM giac_acctrans c, giac_reversals d
                     WHERE c.tran_flag != 'D'
                       AND c.tran_id = d.reversing_tran_id
                       AND d.gacc_tran_id = gacc.tran_id)        -- until here
             AND gdpc.b140_prem_seq_no = v_prem_seq_no
                   
                    )
      LOOP
         v_actual_prem_collection := a4.actual_prem_coll;
         EXIT;
      END LOOP;

      IF v_payable_exists >= 0
      THEN
         IF p_transaction_type IN (1, 2)
         THEN
            -- get actual payments made so far.
            FOR a5 IN
               (SELECT NVL (SUM (gfpp.disbursement_amt), 0) actual_payments
                  FROM giac_outfacul_prem_payts gfpp, giac_acctrans gacc
                 WHERE gfpp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_flag != 'D'
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM giac_acctrans c, giac_reversals d
                           WHERE c.tran_flag != 'D'
                             AND c.tran_id = d.reversing_tran_id
                             AND d.gacc_tran_id = gacc.tran_id)
                   AND gfpp.d010_fnl_binder_id = p_binder_id
                   AND gfpp.transaction_type IN (1, 2))
            LOOP
               v_actual_payments := a5.actual_payments;
               EXIT;
            END LOOP;

            IF v_total_receivable = 0
            THEN
               v_percent_payable := NULL;
            ELSE
               v_percent_payable :=
                    (v_actual_prem_collection / v_total_receivable
                    )
                  * v_total_payable;
            END IF;

            IF p_transaction_type = 1
            THEN
               v_default_disb_amt := v_percent_payable - v_actual_payments;

               IF v_total_payable = v_actual_payments
               THEN
                  p_message := 'This binder has been fully paid.';
                  RETURN;
               END IF;

               IF v_default_disb_amt = 0
               THEN
                  p_message := 'No collection has been made for this binder.';
                  RETURN;
                  RETURN;
               ELSIF v_default_disb_amt < 0
               THEN
                  p_message :=
                        'Negative amount for entered Binder No. '
                     || 'Amount previously disbursed/refunded already exceeds'
                     || ' the default amount.';
                  RETURN;
               END IF;
            ELSIF p_transaction_type = 2
            THEN
               v_default_disb_amt := (-1) * v_actual_payments;

               IF v_default_disb_amt = 0
               THEN
                  p_message :=
                        'Trantype 2 not allowed. No payment has been made '
                     || 'for this Binder No.';
                  RETURN;
               ELSIF v_default_disb_amt > 0
               THEN
                  p_message := 'Positive amount for entered Binder No. ';
                  RETURN;
               END IF;
            END IF;
         ELSE
            p_message :=
                  'This is a positive binder. Only transaction '
               || 'type [1,2] are allowed.';
            RETURN;
         END IF;
      ELSIF v_payable_exists < 0
      THEN
         IF p_transaction_type IN (3, 4)
         THEN
            FOR a6 IN
               (SELECT NVL (SUM (gfpp.disbursement_amt), 0) actual_payments
                  FROM giac_outfacul_prem_payts gfpp, giac_acctrans gacc
                 WHERE gfpp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_flag != 'D'
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM giac_acctrans c, giac_reversals d
                           WHERE c.tran_flag != 'D'
                             AND c.tran_id = d.reversing_tran_id
                             AND d.gacc_tran_id = gacc.tran_id)
                   AND gfpp.d010_fnl_binder_id = p_binder_id
                   AND gfpp.transaction_type IN (3, 4))
            LOOP
               v_actual_payments := a6.actual_payments;
               EXIT;
            END LOOP;

            IF p_transaction_type = 3
            THEN
               v_default_disb_amt := v_percent_payable - v_actual_payments;

               IF v_total_payable = v_actual_payments
               THEN
                  p_message := 'This binder has been fully paid.';
                  RETURN;
               END IF;

               IF v_default_disb_amt = 0
               THEN
                  p_message := 'No collection has been made for this binder.';
                  RETURN;
               ELSIF v_default_disb_amt > 0
               THEN
                  p_message :=
                        'Positive amount for entered Binder No. Amount previously disbursed/refunded already exceeds'
                     || ' the default amount.';
                  RETURN;
               END IF;
            ELSIF p_transaction_type = 4
            THEN
               v_default_disb_amt := (-1) * v_actual_payments;

               IF v_default_disb_amt = 0
               THEN
                  p_message := ' No valid value for entered Binder No. ';
                  RETURN;
               ELSIF v_default_disb_amt < 0
               THEN
                  p_message := ' Negative amount for entered Binder No. ';
                  RETURN;
               END IF;
            END IF;
         ELSE
            p_message :=
                  'This is a negative binder. Only transaction type [3,4] '
               || 'are allowed.';
            RETURN;
         END IF;
      END IF;

      -- return value derived by function.
      IF p_transaction_type IN (1, 3)
      THEN
         p_disbursement_amt := NVL (v_default_disb_amt, 0);
      ELSE
         p_disbursement_amt := NVL (v_default_disb_amt, 0);
      END IF;
	  
	  IF p_message IS NULL
      THEN
         p_message := ' ';
      END IF;
   END get_disb_amt_for_but_revert;

   FUNCTION get_iss_prem_seq_no (
      p_binder_id   giri_binder.fnl_binder_id%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_ri_cd       giac_outfacul_prem_payts.a180_ri_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_prem_seq_no   gipi_invoice.prem_seq_no%TYPE;
   BEGIN
      FOR a1 IN (SELECT g.iss_cd, g.prem_seq_no
                   FROM giri_binder a,
                        giri_frps_ri b,
                        giri_distfrps c,
                        giuw_policyds d,
                        giuw_pol_dist e,
                        gipi_polbasic f,
                        gipi_invoice g
                  WHERE f.policy_id = g.policy_id
                    AND e.policy_id = f.policy_id
                    AND d.dist_no = e.dist_no
                    AND c.dist_no = d.dist_no
                    AND c.dist_seq_no = d.dist_seq_no
                    AND b.line_cd = c.line_cd
                    AND b.frps_yy = c.frps_yy
                    AND b.frps_seq_no = c.frps_seq_no
                    AND a.fnl_binder_id = b.fnl_binder_id
                    AND a.ri_cd = p_ri_cd
                    AND a.line_cd = p_line_cd
                    AND a.fnl_binder_id = p_binder_id)
      LOOP
         v_prem_seq_no := a1.prem_seq_no;
         EXIT;
      END LOOP;

      RETURN v_prem_seq_no;
   END get_iss_prem_seq_no;
   
   PROCEDURE get_facul_iss_cd_prem_seq_no (
      p_binder_id   giri_binder.fnl_binder_id%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_ri_cd       giac_outfacul_prem_payts.a180_ri_cd%TYPE,
	  p_iss_cd		OUT gipi_invoice.iss_cd%type,
	  p_prem_seq_no OUT gipi_invoice.prem_seq_no%type
   )      
   IS
   BEGIN
      FOR a1 IN (SELECT g.iss_cd, g.prem_seq_no
                   FROM giri_binder a,
                        giri_frps_ri b,
                        giri_distfrps c,
                        giuw_policyds d,
                        giuw_pol_dist e,
                        gipi_polbasic f,
                        gipi_invoice g
                  WHERE f.policy_id = g.policy_id
                    AND e.policy_id = f.policy_id
                    AND d.dist_no = e.dist_no
                    AND c.dist_no = d.dist_no
                    AND c.dist_seq_no = d.dist_seq_no
                    AND b.line_cd = c.line_cd
                    AND b.frps_yy = c.frps_yy
                    AND b.frps_seq_no = c.frps_seq_no
                    AND a.fnl_binder_id = b.fnl_binder_id
                    AND a.ri_cd = p_ri_cd
                    AND a.line_cd = p_line_cd
                    AND a.fnl_binder_id = p_binder_id)
      LOOP
         p_prem_seq_no := a1.prem_seq_no;
		 p_iss_cd	   := a1.iss_cd;
         EXIT;
      END LOOP;
   END;
   
   
    PROCEDURE validate_binder_no2 (
        p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
        p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
        p_line_cd            giri_binder.line_cd%TYPE,
        p_binder_yy          giri_binder.binder_yy%TYPE,
        p_binder_seq_no      giri_binder.binder_seq_no%TYPE,
        p_override_def       VARCHAR2,
        p_user_id            VARCHAR2,
        v_default_disb_amt  OUT giac_outfacul_prem_payts.disbursement_amt%TYPE,
        v_message           OUT VARCHAR2
    )
    IS
        CURSOR a
        IS
         SELECT  e.fnl_binder_id, 
                 (a.line_cd ||'-'|| a.subline_cd ||'-'|| a.iss_cd ||'-'|| ltrim(to_char(a.issue_yy,'09')) ||'-'|| ltrim(to_char(a.pol_seq_no,'0999999')) ||'-'||                
                     ltrim(to_char(a.renew_no,'09')) || decode(nvl(a.endt_seq_no,1), 0, null, '-'|| a.endt_iss_cd ||'-'|| ltrim(to_char(a.endt_yy,'09')) ||'-'||                  
                     ltrim(to_char(a.endt_seq_no,'099999')) || a.endt_type ) ) policy, 
                 A.POLICY_ID,  d.currency_cd, 
                 d.currency_rt curr_rt,  g.currency_desc      
           FROM gipi_polbasic a, 
                giuw_pol_dist b, 
                giri_frps_ri c, 
                giri_distfrps d, 
                giri_binder e, 
                giis_currency g 
          WHERE c.line_cd = d.line_cd 
            AND c.frps_yy = d.frps_yy 
            AND c.frps_seq_no = d.frps_seq_no 
            AND d.dist_no = b.dist_no 
            AND a.policy_id = b.policy_id 
            AND c.fnl_binder_id = e.fnl_binder_id 
            AND d.currency_cd = g.main_currency_cd 
            AND e.ri_cd = p_ri_cd    
            AND e.line_cd = p_line_cd 
            AND e.binder_yy = p_binder_yy 
            AND e.binder_seq_no = p_binder_seq_no --nvl(:gfpp.dsp_binder_seq_no,e.binder_seq_no)  -- 30 
            AND B.DIST_FLAG NOT IN (4,5); 

        CURSOR b
        IS
          SELECT fnl_binder_id, POLICY, policy_id, currency_cd, curr_rt, currency_desc
            FROM (SELECT e.fnl_binder_id,
                         (a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' || LTRIM (TO_CHAR (a.issue_yy, '09'))
                            || '-' || LTRIM (TO_CHAR (a.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (a.renew_no, '09'))
                            || DECODE (NVL (a.endt_seq_no, 1), 0, NULL,
                                        '-' || a.endt_iss_cd || '-' || LTRIM (TO_CHAR (a.endt_yy, '09')) || '-'
                                                || LTRIM (TO_CHAR (a.endt_seq_no, '099999')) || a.endt_type
                                        )
                          ) POLICY,
                          a.policy_id, d.currency_cd, d.currency_rt curr_rt, g.currency_desc
                    FROM gipi_polbasic a,
                         giuw_pol_dist b,
                         giri_frps_ri c,
                         giri_distfrps d,
                         giri_binder e,
                         giis_currency g
                   WHERE c.line_cd = d.line_cd
                     AND c.frps_yy = d.frps_yy
                     AND c.frps_seq_no = d.frps_seq_no
                     AND d.dist_no = b.dist_no
                     AND a.policy_id = b.policy_id
                     AND c.fnl_binder_id = e.fnl_binder_id
                     AND d.currency_cd = g.main_currency_cd
                     AND e.ri_cd = p_ri_cd
                     AND e.line_cd = p_line_cd
                     AND e.binder_yy = p_binder_yy
                     AND e.binder_seq_no = p_binder_seq_no
                       --nvl(:gfpp.dsp_binder_seq_no,e.binder_seq_no)  -- 30
                       ---AND B.DIST_FLAG NOT IN (4,5); /*comment out by bem */
                   UNION --RCD 03.20.2013
                  SELECT e.fnl_binder_id,
                         ( a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' || LTRIM (TO_CHAR (a.issue_yy, '09'))
                            || '-' || LTRIM (TO_CHAR (a.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (a.renew_no, '09'))
                            || DECODE (NVL (a.endt_seq_no, 1), 0, NULL,
                                                '-' || a.endt_iss_cd || '-' || LTRIM (TO_CHAR (a.endt_yy, '09')) || '-'
                                                        || LTRIM (TO_CHAR (a.endt_seq_no, '099999')) || a.endt_type
                                       )
                         ) POLICY,
                         a.policy_id, d.currency_cd, d.currency_rt curr_rt, g.currency_desc
                    FROM gipi_polbasic a,
                         giuw_pol_dist b,
                         giri_frps_ri c,
                         giri_distfrps d,
                         giri_binder e,
                         giis_currency g
                   WHERE c.line_cd = d.line_cd
                     AND c.frps_yy = d.frps_yy
                     AND c.frps_seq_no = d.frps_seq_no
                     AND d.dist_no = b.dist_no
                     AND a.policy_id = b.policy_id
                     AND c.fnl_binder_id = e.fnl_binder_id
                     AND d.currency_cd = g.main_currency_cd
                     AND e.ri_cd = p_ri_cd
                     AND e.line_cd = p_line_cd
                     AND e.binder_yy = p_binder_yy
                     AND e.binder_seq_no = p_binder_seq_no
                     --nvl(:gfpp.dsp_binder_seq_no,e.binder_seq_no)  -- 30
                     AND b.dist_flag NOT IN (4, 5));
                         
    BEGIN
        IF p_ri_cd IS NULL OR p_line_cd IS NULL OR p_binder_yy IS NULL OR p_binder_seq_no IS NULL THEN
            FOR i IN (SELECT *
                        FROM giri_binder
                       WHERE ri_cd = NVL(p_ri_cd, ri_cd)
                         AND line_cd = NVL(p_line_cd, line_cd)
                         AND binder_yy = NVL(p_binder_yy, binder_yy)
                         AND binder_seq_no = NVL(p_binder_seq_no, binder_seq_no))
            LOOP
               v_message := 'Y';
            END LOOP;
                        
        ELSIF p_line_cd IS NOT NULL AND p_binder_yy IS NOT NULL AND p_binder_seq_no IS NOT NULL THEN
            IF p_transaction_type IN (1, 3) THEN
                FOR a_rec IN a
                LOOP
                    IF p_override_def = 'N' THEN
                        get_disbursement_amt(p_transaction_type, p_ri_cd, p_line_cd, p_binder_yy, p_binder_seq_no, 
                                                a_rec.curr_rt, a_rec.policy_id, a_rec.fnl_binder_id, p_user_id, v_default_disb_amt, v_message);       
                    ELSE
                        get_override_disbursement_amt(p_transaction_type, p_binder_yy, p_line_cd, p_binder_seq_no, a_rec.fnl_binder_id, 
                                                        v_default_disb_amt, v_message);
                    END IF;                                 
                END LOOP;
            ELSIF p_transaction_type IN (2, 4) THEN
                FOR b_rec IN b
                LOOP
                    IF p_override_def = 'N' THEN
                        get_disbursement_amt(p_transaction_type, p_ri_cd, p_line_cd, p_binder_yy, p_binder_seq_no, 
                                                b_rec.curr_rt, b_rec.policy_id, b_rec.fnl_binder_id, p_user_id, v_default_disb_amt, v_message);    
                    ELSE
                        get_override_disbursement_amt(p_transaction_type, p_binder_yy, p_line_cd, p_binder_seq_no, b_rec.fnl_binder_id, 
                                                        v_default_disb_amt, v_message);
                    END IF;                                        
                END LOOP;
            END IF;
        END IF;
    END validate_binder_no2;
   
     PROCEDURE get_disbursement_amt(
        p_transaction_type      giac_outfacul_prem_payts.transaction_type%TYPE,      
        p_ri_cd                 giac_outfacul_prem_payts.a180_ri_cd%TYPE,
        p_line_cd               giri_binder.line_cd%TYPE,
        p_binder_yy             giri_binder.binder_yy%TYPE,
        p_binder_seq_no         giri_binder.binder_seq_no%TYPE,
        p_convert_rate          giri_distfrps.CURRENCY_RT%type,
        p_policy_id             gipi_polbasic.POLICY_ID%type,
        p_binder_id             giri_binder.FNL_BINDER_ID%type,
        p_user_id               VARCHAR2,
        v_default_disb_amt  OUT giac_outfacul_prem_payts.disbursement_amt%TYPE,
        v_message           OUT VARCHAR2
    )
    AS
        v_payable_exists          giri_binder.ri_prem_amt%TYPE := 0;
        v_total_payable           giri_binder.ri_prem_amt%TYPE := 0;
        v_total_receivable        gipi_invoice.prem_amt%TYPE;
        v_actual_prem_collection  giac_direct_prem_collns.collection_amt%TYPE := 0;
        v_actual_payments         giac_outfacul_prem_payts.disbursement_amt%TYPE := 0;
        v_percent_payable         giac_outfacul_prem_payts.disbursement_amt%TYPE := 0;     
        --v_default_disb_amt        giac_outfacul_prem_payts.disbursement_amt%TYPE := 0;
        
        v_iss_cd                   gipi_invoice.iss_cd%TYPE;
        v_prem_seq_no              gipi_invoice.prem_seq_no%TYPE;
        v_set_prem_switch          BOOLEAN := FALSE;
        v_allow_default             VARCHAR2(10);
    BEGIN
        FOR a1 IN  ( SELECT g.iss_cd, g.prem_seq_no
                       FROM giri_binder a,
                            giri_frps_ri b,
                            giri_distfrps c,
                            giuw_policyds d,
                            giuw_pol_dist e,
                            gipi_polbasic f,
                            gipi_invoice g
                      WHERE f.policy_id = g.policy_id
                        AND e.policy_id = f.policy_id
                        AND d.dist_no = e.dist_no
                        AND c.dist_no = d.dist_no
                        AND c.dist_seq_no = d.dist_seq_no
                        AND b.line_cd = c.line_cd
                        AND b.frps_yy = c.frps_yy
                        AND b.frps_seq_no = c.frps_seq_no
                        AND a.fnl_binder_id = b.fnl_binder_id
                        AND a.ri_cd = p_ri_cd
                        AND a.line_cd = p_line_cd
                        AND a.fnl_binder_id = p_binder_id)
        LOOP
            v_iss_cd := a1.iss_cd;
            v_prem_seq_no := a1.prem_seq_no;
            EXIT;
        END LOOP;
        
        FOR a1 IN ( SELECT NVL(ri_prem_amt,0) ri_prem
                      FROM giri_binder 
                     WHERE binder_yy = p_binder_yy
                       AND line_cd = p_line_cd
                       AND binder_seq_no = p_binder_seq_no
                       AND ri_cd = p_ri_Cd) 
        LOOP ---REVISED BY BEM2002 
            v_payable_exists := a1.ri_prem;
            EXIT;
        END LOOP;
        
        -- get total outfacul premium payable.

        FOR a2 IN (/*SELECT (
                          NVL(ri_prem_amt,0) - 
                          ( NVL(ri_comm_amt,0) + NVL(prem_tax,0) )
                         ) tot_payable*/ -- commented by gmi to correct computation replaced by :
                  SELECT (
                          (NVL(ri_prem_amt,0) + NVL(ri_prem_vat,0) - NVL(prem_tax,0)) -
                          ( NVL(ri_comm_amt,0) + NVL(ri_comm_vat,0) + NVL(ri_wholding_vat,0))
                         ) tot_payable       
                   FROM giri_binder
                  WHERE binder_yy = p_binder_yy
                    AND line_cd = p_line_cd
                    AND binder_seq_no = p_binder_seq_no
                    AND ri_cd = p_ri_Cd) 
        LOOP      --REVISED BY BEM                   
            v_total_payable := (a2.tot_payable) * NVL(P_CONVERT_RATE,1);
            EXIT;
        END LOOP;

        -- get total premium receivable. 
        FOR a5 IN (SELECT --NVL(prem_amt,0) tot_receivable
                         NVL(prem_amt,0) * NVL(CURRENCY_RT,1)tot_receivable --edited by lina 07/01/2006
                     FROM gipi_invoice
                    WHERE iss_cd = v_iss_cd
                      AND prem_seq_no = v_prem_seq_no) 
        LOOP
            v_total_receivable := a5.tot_receivable;
            EXIT;
        END LOOP;
        
        v_set_prem_switch := FALSE;

        FOR c1 IN (SELECT 1
                     FROM gipi_polbasic a, giri_inpolbas b
                    WHERE a.policy_id = b.policy_id
                      AND a.policy_id = p_policy_id)
        LOOP
         v_set_prem_switch := TRUE;
        END LOOP;
        
        IF v_set_prem_switch = TRUE THEN
            /*WILL USE THE GIAC_INWFACUL_PREM_COLLNS TABLE FOR PREM_COLLNS*/
            -- get total premium collections made so far.         
            FOR a4 IN (SELECT NVL(SUM(premium_amt),0) actual_prem_coll
                         FROM giac_inwfacul_prem_collns gipc, 
                              gipi_invoice b140,
                              giac_acctrans gacc
                        WHERE gipc.b140_iss_cd = b140.iss_cd
                          AND gipc.b140_prem_seq_no = b140.prem_seq_no
                          AND gipc.gacc_tran_id = gacc.tran_id
                          AND gacc.tran_flag <> 'D'
                          AND NOT EXISTS (SELECT '1'                       -- starts here
                                            FROM giac_acctrans c, giac_reversals d       -- added by rj 02/18/2000    
                                           WHERE c.tran_flag   != 'D'
                                             AND c.tran_id      = d.reversing_tran_id
                                             AND d.gacc_tran_id = gacc.tran_id)          -- until here
                          AND gipc.b140_iss_cd = v_iss_cd
                          AND gipc.b140_prem_seq_no = v_prem_seq_no) 
            LOOP
                v_actual_prem_collection := a4.actual_prem_coll;
                EXIT;
            END LOOP;
            
        ELSIF v_set_prem_switch = FALSE THEN
            /*WILL USE THE GIAC_DIRECT_PREM_COLLNS TABLE FOR PREM_COLLNS*/          
            -- get total premium collections made so far.         
            FOR a4 IN (SELECT NVL(SUM(premium_amt),0) actual_prem_coll
                         FROM giac_direct_prem_collns gdpc, 
                              gipi_invoice b140,
                              giac_acctrans gacc
                        WHERE gdpc.b140_iss_cd = b140.iss_cd
                          AND gdpc.b140_prem_seq_no = b140.prem_seq_no
                          AND gdpc.gacc_tran_id = gacc.tran_id
                          AND gacc.tran_flag <> 'D'
                          AND NOT EXISTS (SELECT '1'                       -- starts here
                                            FROM giac_acctrans c, giac_reversals d       -- added by rj 02/18/2000    
                                           WHERE c.tran_flag   != 'D'
                                             AND c.tran_id      = d.reversing_tran_id
                                             AND d.gacc_tran_id = gacc.tran_id)          -- until here
                          AND gdpc.b140_iss_cd = v_iss_cd
                          AND gdpc.b140_prem_seq_no = v_prem_seq_no) 
            LOOP
                v_actual_prem_collection := a4.actual_prem_coll;
                EXIT;
            END LOOP;
        END IF;
        
        
        IF v_payable_exists >= 0 THEN
            IF p_transaction_type IN (1, 2) THEN
                -- get actual payments made so far.
                FOR a5 IN (SELECT NVL(SUM(gfpp.disbursement_amt),0) actual_payments
                             FROM giac_outfacul_prem_payts gfpp,
                                  giac_acctrans gacc,
                                  GIRI_BINDER gibr
                            WHERE gfpp.gacc_tran_id = gacc.tran_id
                              AND gacc.tran_flag != 'D'
                              AND NOT EXISTS (SELECT '1'
                                                FROM giac_acctrans c, giac_reversals d
                                               WHERE c.tran_flag   != 'D'
                                                 AND c.tran_id      = d.reversing_tran_id
                                                 AND d.gacc_tran_id = gacc.tran_id)
                                              -- AND gfpp.d010_fnl_binder_id = :gfpp.d010_fnl_binder_id 
                             AND gfpp.d010_fnl_binder_id = gibr.fnl_binder_id
                             AND binder_yy = p_binder_yy
                             AND line_cd = p_line_cd
                             AND binder_seq_no = p_binder_seq_no
                             AND ri_cd = p_ri_Cd
                             AND gfpp.transaction_type IN (1,2)) 
                LOOP
                    v_actual_payments := a5.actual_payments;
                    EXIT;
                END LOOP;
                
                IF v_total_receivable = 0 THEN --added by Ramon, 20APR07
                    v_percent_payable := NULL;     --to avoid dividing by zero
                ELSE
                    v_percent_payable := (v_actual_prem_collection/v_total_receivable) * v_total_payable;
                END IF;
                
                IF p_transaction_type = 1 THEN
                    v_default_disb_amt := v_percent_payable - v_actual_payments; 
                    
                    IF v_total_payable = v_actual_payments THEN           
                       /*IF :gfpp.disbursement_amt is not null THEN
                          :cg$ctrl.sum_disbursement_amt := :cg$ctrl.sum_disbursement_amt-:gfpp.disbursement_amt;
                          :gfpp.disbursement_amt := NULL;   
                           msg_alert('This binder has been fully paid.' , 'I', TRUE);
                       ELSE
                            msg_alert('This binder has been fully paid.' , 'I', TRUE);
                       END IF;*/
                       v_message := 'This binder has been fully paid.#I#';
                       RETURN;
                    END IF;
                    
                    v_allow_default := GIAC_VALIDATE_USER_FN(p_user_id, 'OD', 'GIACS019');
                    
                    IF v_allow_default = 'TRUE' THEN
                        IF v_default_disb_amt = 0 THEN
                            --MSG_ALERT('MUST NOT CLEAR RECORD HERE','I',FALSE);
                            v_message := 'No collection has been made for this binder. Will now override default computation.#I#enable_revert_btn';
                            v_default_disb_amt := v_total_payable - v_actual_payments;
                            --:gfpp.nbt_override_default := 'Y';
                            --SET_ITEM_PROPERTY('cg$ctrl.but_revert', ENABLED, PROPERTY_TRUE);
                        ELSIF v_default_disb_amt < 0 THEN
                            /*DEFAULT THE VALUE IF NEGATIVE AND AUTHORIZED ZERO GRAVITY JULY2000*/
                            --MSG_ALERT('---IF AUTHORIZED THEN OVERRIDE DEFAULT, ELSE MUST CLEAR RECORD','I',FALSE);
                            v_message := 'Amount previously disbursed/refunded already exceeds the default amount. '||
                                            'Will now override default computation.#I#enable_revert_btn';             
                            v_default_disb_amt := v_total_payable - v_actual_payments;
                            --:gfpp.nbt_override_default := 'Y';
                            --SET_ITEM_PROPERTY('cg$ctrl.but_revert', ENABLED, PROPERTY_TRUE);
                        /*ELSE
                            v_message := '#I#enable_revert_btn';  */           
                        END IF;                        
                    
                    ELSE
                        IF v_default_disb_amt = 0 THEN
                            v_message := 'There is still no premium payment for this policy,Do you want to continue facultative premium payment?#I#';
                            -- override will be done in jsp
                        ELSIF v_default_disb_amt < 0 THEN
                            v_message := 'Amount previously disbursed/refunded already exceeds the default amount.#I#';     
                            /*CLEAR_RECORD IF USER IS UNAUTHORIZED TO OVERRIDE THE DEFAULT*/
                            /*VALUE - ZERO GRAVITY JULY2000*/
                            --CLEAR_D_RECORD;
                        END IF;
                    END IF;
                    
                ELSIF p_transaction_type = '2' THEN
                    v_default_disb_amt := (-1) * v_actual_payments;
                    
                    IF v_default_disb_amt = 0 THEN
                        v_message := 'Trantype 2 not allowed. No payment has been made for this Binder No.#I#';
                        RETURN;
                    ELSIF v_default_disb_amt > 0 THEN
                        v_message := 'Positive amount for entered Binder No.#E#';
                        RETURN;
                    /*ELSE
                        IF v_allow_default = 'TRUE' THEN   
                            SET_ITEM_PROPERTY('cg$ctrl.but_override_default', ENABLED, PROPERTY_TRUE);
                        END IF;*/
                    END IF;
                
                END IF;
            
            ELSE
                v_message := 'This is a positive binder. Only transaction type [1,2] are allowed.#I#';
                RETURN;
            END IF; 
        
        ELSIF v_payable_exists < 0 THEN
            IF p_transaction_type IN (3, 4) THEN
                FOR a6 IN  ( SELECT NVL(SUM(gfpp.disbursement_amt),0) actual_payments
                               FROM giac_outfacul_prem_payts gfpp,
                                    giac_acctrans gacc,
                                    GIRI_BINDER GIBR
                              WHERE gfpp.gacc_tran_id  = gacc.tran_id
                                AND gacc.tran_flag    != 'D'
                                AND NOT EXISTS (SELECT '1'
                                                  FROM giac_acctrans c, giac_reversals d
                                                 WHERE c.tran_flag   != 'D'
                                                   AND c.tran_id      = d.reversing_tran_id
                                                   AND d.gacc_tran_id = gacc.tran_id)
                    -----                    AND gfpp.d010_fnl_binder_id = :gfpp.d010_fnl_binder_id
                                      AND gfpp.d010_fnl_binder_id = gibr.fnl_binder_id
                               AND gibr.binder_yy = p_binder_yy
                               AND gibr.line_cd = p_line_cd
                               AND gibr.binder_seq_no = p_binder_seq_no                        
                               AND gfpp.transaction_type IN (3,4))
                    LOOP
                        v_actual_payments := a6.actual_payments;
                        EXIT;
                    END LOOP;
                    
                    IF v_total_receivable = 0 THEN --added by Ramon, 20APR07
                        v_percent_payable := NULL;     --to avoid dividing by zero
                    ELSE
                        v_percent_payable := (v_actual_prem_collection/v_total_receivable) * v_total_payable;        
                    END IF;
                    
                    IF p_transaction_type = 3 THEN
                        v_default_disb_amt := v_percent_payable - v_actual_payments;
        
                        IF v_total_payable = v_actual_payments THEN
                            v_message := 'This binder has been fully paid.#I#';
                            RETURN;
                        END IF;
                        
                        IF  v_allow_default = 'TRUE' THEN
                            IF v_default_disb_amt = 0 THEN
                                v_message := 'No collection has been made for this binder. Will now ' ||
                                                'override default computation.#I#enable_revert_btn';
                                v_default_disb_amt := v_total_payable - v_actual_payments;
                                /*:gfpp.nbt_override_default := 'Y';
                                SET_ITEM_PROPERTY('cg$ctrl.but_revert', ENABLED, PROPERTY_TRUE);*/
                            ELSIF v_default_disb_amt > 0 THEN
                                v_message := ' Positive amount for entered Binder No. '||  
                                             'Will override default amount#I#enable_revert_btn';
                                v_default_disb_amt := v_total_payable - v_actual_payments;
                                /*:gfpp.nbt_override_default := 'Y';
                                SET_ITEM_PROPERTY('cg$ctrl.but_revert', ENABLED, PROPERTY_TRUE);

                            ELSE
                                SET_ITEM_PROPERTY('cg$ctrl.but_override_default', ENABLED, PROPERTY_TRUE);*/
                            END IF;
                        ELSE
                            IF v_default_disb_amt = 0 THEN
                                v_message := 'No collection has been made for this binder.#I#';

                            ELSIF v_default_disb_amt > 0 THEN
                                v_message := ' Positive amount for entered Binder No.#I#';  
                            END IF;
                        END IF;
                    
                    ELSIF p_transaction_type = 4 THEN
                        v_default_disb_amt := (-1)* v_actual_payments;
                        IF v_default_disb_amt = 0 THEN
                            v_message := 'Trantype 4 not allowed. No payment has been made ' ||
                                            'for this Binder No.#I#';
                            RETURN;
                        ELSIF v_default_disb_amt < 0 THEN
                            v_message := 'Negative amount for entered Binder No.#E#';
                            RETURN;
                        /*ELSE
                            SET_ITEM_PROPERTY('cg$ctrl.but_override_default', ENABLED, PROPERTY_TRUE);*/
                        END IF;
                    END IF;
            
            ELSE
                v_message := 'This is a negative binder. Only transaction type [3,4] are allowed.#I#';
                RETURN;
            END IF;
        END IF;
        
    END get_disbursement_amt;
    
    
    -- SR-19792, 19840 : shan 08.06.2015
    FUNCTION get_outfacul_prem_payts_dtls(
        p_gacc_tran_id   giac_outfacul_prem_payts.gacc_tran_id%TYPE
    ) RETURN binder_list_tab PIPELINED
    AS
        v_binder         binder_list_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM giac_outfacul_prem_payts
                   WHERE gacc_tran_id = p_gacc_tran_id)
        LOOP
            v_binder.transaction_type := i.transaction_type;
            v_binder.ri_cd  := i.a180_ri_cd;
            v_binder.currency_cd := i.currency_cd;
            v_binder.currency_rt := i.convert_rate;
            v_binder.prem_amt   := i.prem_amt;
            v_binder.prem_vat   := i.prem_vat;
            v_binder.comm_amt   := i.comm_amt;
            v_binder.comm_vat   := i.comm_vat;
            v_binder.remarks    := i.remarks;
            v_binder.cm_tag     := i.cm_tag;
            v_binder.or_print_tag   := i.or_print_tag;
            v_binder.disbursement_amt := i.disbursement_amt;                
            v_binder.disbursement_amt_local := v_binder.disbursement_amt * v_binder.currency_rt;
            v_binder.record_no  := i.record_no; -- SR-19631 : shan : 08.17.2015
            
            BEGIN
                SELECT currency_desc
                  INTO v_binder.currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd  = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_binder.currency_desc := NULL;
            END;
                                    
            FOR j IN (SELECT *
                        FROM giri_binder
                       WHERE fnl_binder_id = i.d010_fnl_binder_id)
            LOOP
                v_binder.line_cd := j.line_cd;
                v_binder.binder_yy := j.binder_yy;
                v_binder.binder_seq_no := j.binder_seq_no;
                v_binder.binder_date := j.binder_date;
                v_binder.binder_id := j.fnl_binder_id;
                v_binder.policy_id := j.policy_id;
                v_binder.prem_seq_no := giac_outfacul_prem_payts_pkg.get_iss_prem_seq_no
                                                                                         (j.fnl_binder_id,
                                                                                          j.line_cd,
                                                                                          i.a180_ri_cd
                                                                                         );
            
                BEGIN
                    SELECT DISTINCT b.ri_name 
                      INTO v_binder.ri_name
                      FROM giri_binder a, giis_reinsurer b
                     WHERE a.ri_cd = b.ri_cd
                       AND a.line_cd       = NVL(j.LINE_CD, a.line_cd)
                       AND a.binder_yy     = NVL(j.BINDER_YY, a.binder_yy)
                       AND a.binder_seq_no = NVL(j.BINDER_SEQ_NO, a.binder_seq_no)
                       AND a.ri_cd         = i.A180_RI_CD;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_binder.ri_name := NULL;
                END;
                
                
                FOR k IN (SELECT *
                            FROM gipi_polbasic 
                           WHERE policy_id = j.policy_id)
                LOOP
                    v_binder.pol_line_cd := k.line_cd;
                    v_binder.pol_subline_cd := k.subline_cd;
                    v_binder.pol_iss_cd := k.iss_cd;
                    v_binder.pol_issue_yy := k.issue_yy;
                    v_binder.pol_seq_no := k.pol_seq_no;
                    v_binder.pol_renew_no := k.renew_no;
                    v_binder.endt_iss_cd := k.endt_iss_cd;
                    v_binder.endt_yy := k.endt_yy;
                    v_binder.endt_seq_no := k.endt_seq_no;
                    v_binder.endt_type := k.endt_type;
                    v_binder.incept_date := k.incept_date;
                    v_binder.expiry_date := k.expiry_date;
                    v_binder.assd_no := k.assd_no;
                    v_binder.par_id := k.par_id;
                    v_binder.prem_tag := k.prem_warr_tag;
                    
                    BEGIN
                        SELECT assd_name
                          INTO v_binder.assd_name
                          FROM giis_assured
                         WHERE assd_no = k.assd_no;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_binder.assd_name := NULL;
                    END;
                    
                    IF k.endt_type IS NOT NULL THEN
                        v_binder.policy_no := get_policy_no (k.policy_id) || '-' || k.endt_type;
                    ELSE
                        v_binder.policy_no := get_policy_no (k.policy_id);
                    END IF;
                END LOOP;
            END LOOP;
            
            -- SR-19631 : shan 08.17.2015
            v_binder.payt_gacc_tran_id := NULL;
            
            IF i.transaction_type IN (2, 4) THEN
                FOR l IN (SELECT *
                            FROM giac_outfacul_prem_payts
                           WHERE a180_ri_cd = i.a180_ri_cd
                             AND d010_fnl_binder_id = i.d010_fnl_binder_id
                             AND rev_gacc_tran_id = i.gacc_tran_id
                             AND ABS(disbursement_amt) = ABS(i.disbursement_amt)
                             AND rev_record_no = i.record_no)
                LOOP
                    v_binder.payt_gacc_tran_id := l.gacc_tran_id;
                END LOOP;
            END IF;            
            -- SR-19631 : shan 08.17.2015
            
            PIPE ROW(v_binder);
        END LOOP;
    END get_outfacul_prem_payts_dtls;
    -- end SR-19792, 19840
   
   -- SR-19631 : shan 08.13.2015 
   FUNCTION get_binder_dtls_for_override (
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_user               giac_outfacul_prem_payts.user_id%TYPE,
      p_module_name        VARCHAR2,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE
   )
      RETURN binder_list_tab PIPELINED
   IS
      v_binder         binder_list_type;
      v_convert_rate   giac_outfacul_prem_payts.convert_rate%TYPE;
      v_message        VARCHAR2 (1000);

      CURSOR a
      IS
         SELECT   e.line_cd, e.binder_yy, e.binder_seq_no, e.binder_date,
                  e.fnl_binder_id, a.policy_id, a.line_cd pol_line_cd,
                  a.subline_cd pol_subline_cd, a.iss_cd pol_iss_cd,
                  a.issue_yy pol_issue_yy, a.pol_seq_no pol_seq_no,
                  a.renew_no pol_renew_no,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_iss_cd) endt_iss_cd,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_yy) endt_yy,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_seq_no) endt_seq_no,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_type) endt_type,
                  a.incept_date, a.expiry_date, a.assd_no, d.currency_cd,
                  d.currency_rt curr_rt, g.currency_desc, a.par_id,
                  a.prem_warr_tag prem_tag, a.policy_id pol_policy_id,
                  /*(SELECT remarks
                     FROM giac_outfacul_prem_payts
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND d010_fnl_binder_id = e.fnl_binder_id
                      AND a180_ri_cd = p_ri_cd) remarks,*/   -- commented out SR-19631 : shan 08.17.2015
                  (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no IN (SELECT assd_no
                                        FROM gipi_parlist
                                       WHERE par_id = a.par_id)) assd_name
             FROM gipi_polbasic a,
                  giuw_pol_dist b,
                  giri_frps_ri c,
                  giri_distfrps d,
                  giri_binder e,
                  giis_currency g
            WHERE c.line_cd = d.line_cd
              AND c.frps_yy = d.frps_yy
              AND c.frps_seq_no = d.frps_seq_no
              AND d.dist_no = b.dist_no
              AND a.policy_id = b.policy_id
              AND c.fnl_binder_id = e.fnl_binder_id
              AND d.currency_cd = g.main_currency_cd
              AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
              AND e.binder_seq_no = NVL (p_binder_seq_no, e.binder_seq_no)
              AND (   (NVL (e.ri_prem_amt, 0) >= 0 AND p_transaction_type = 1
                      )
                   OR (NVL (e.ri_prem_amt, 0) < 0 AND p_transaction_type = 3)
                  )
              AND b.dist_flag NOT IN (4, 5)
              AND c.reverse_sw <> 'Y'
              AND (e.replaced_flag <> 'Y' OR e.replaced_flag IS NULL)
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND e.binder_yy = NVL (p_binder_yy, e.binder_yy)
         ORDER BY e.line_cd, e.binder_yy, e.binder_seq_no;

      CURSOR b
      IS
         SELECT   i.gacc_tran_id, e.line_cd, e.binder_yy, e.binder_seq_no, e.binder_date,
                  e.fnl_binder_id, a.policy_id, a.line_cd pol_line_cd,
                  a.subline_cd pol_subline_cd, a.iss_cd pol_iss_cd,
                  a.issue_yy pol_issue_yy, a.pol_seq_no pol_seq_no,
                  a.renew_no pol_renew_no, i.record_no, get_ref_no(i.gacc_tran_id) ref_no,      -- SR-19631 : shan 08.17.2015
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_iss_cd) endt_iss_cd,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_yy) endt_yy,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_seq_no) endt_seq_no,
                  DECODE (a.endt_seq_no, 0, NULL, a.endt_type) endt_type,
                  a.incept_date, a.expiry_date, a.assd_no, d.currency_cd,
                  d.currency_rt curr_rt, g.currency_desc, a.par_id,
                  e.replaced_flag, c.reverse_sw, a.policy_id pol_policy_id,
                  i.remarks, i.prem_amt, i.prem_vat, i.comm_amt, i.comm_vat,
                  i.wholding_vat, a.prem_warr_tag prem_tag,
                  (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no IN (SELECT assd_no
                                        FROM gipi_parlist
                                       WHERE par_id = a.par_id)) assd_name
             FROM gipi_polbasic a,
                  giuw_pol_dist b,
                  giri_frps_ri c,
                  giri_distfrps d,
                  giri_binder e,
                  giis_currency g,
                  giac_outfacul_prem_payts i,
                  giac_acctrans j
            WHERE i.gacc_tran_id NOT IN (
                     SELECT k.gacc_tran_id
                       FROM giac_reversals k, giac_acctrans l
                      WHERE k.reversing_tran_id = l.tran_id
                        AND k.gacc_tran_id = i.gacc_tran_id
                        AND l.tran_flag <> 'D')
              AND c.line_cd = d.line_cd
              AND c.frps_yy = d.frps_yy
              AND c.frps_seq_no = d.frps_seq_no
              AND d.dist_no = b.dist_no
              AND a.policy_id = b.policy_id
              AND c.fnl_binder_id = e.fnl_binder_id
              AND d.currency_cd = g.main_currency_cd
              AND i.d010_fnl_binder_id = e.fnl_binder_id
              AND i.gacc_tran_id = j.tran_id
              AND j.tran_flag <> 'D'
              AND (   (i.transaction_type = '1' AND p_transaction_type = 2)
                   OR (i.transaction_type = '3' AND p_transaction_type = 4)
                  )
              AND e.ri_cd = NVL (p_ri_cd, e.ri_cd)
              AND e.binder_seq_no = NVL (p_binder_seq_no, e.binder_seq_no)
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND e.binder_yy = NVL (p_binder_yy, e.binder_yy)
              AND get_ref_no(i.gacc_tran_id) != get_ref_no(p_gacc_tran_id)    --to restrict reversal on same transaction :  SR-19631 : shan 08.19.2015
              AND i.rev_gacc_tran_id IS NULL    -- SR-19631 : shan 08.19.2015
         ORDER BY e.line_cd, e.binder_yy, e.binder_seq_no;
   BEGIN
      IF p_transaction_type IN (1, 3)
      THEN
         FOR a_rec IN a
         LOOP
            /*BEGIN      -- commented out SR-19631 : shan 08.17.2015
               SELECT convert_rate
                 INTO v_convert_rate
                 FROM giac_outfacul_prem_payts
                WHERE gacc_tran_id = p_gacc_tran_id
                  AND a180_ri_cd = p_ri_cd
                  AND d010_fnl_binder_id = a_rec.fnl_binder_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_convert_rate := 1;
            END;*/

            v_binder.line_cd := a_rec.line_cd;
            v_binder.binder_yy := a_rec.binder_yy;
            v_binder.binder_seq_no := a_rec.binder_seq_no;
            v_binder.binder_date := a_rec.binder_date;
            v_binder.binder_id := a_rec.fnl_binder_id;
            v_binder.policy_id := a_rec.policy_id;
            v_binder.pol_line_cd := a_rec.pol_line_cd;
            v_binder.pol_subline_cd := a_rec.pol_subline_cd;
            v_binder.pol_iss_cd := a_rec.pol_iss_cd;
            v_binder.pol_issue_yy := a_rec.pol_issue_yy;
            v_binder.pol_seq_no := a_rec.pol_seq_no;
            v_binder.pol_renew_no := a_rec.pol_renew_no;
            v_binder.endt_iss_cd := a_rec.endt_iss_cd;
            v_binder.endt_yy := a_rec.endt_yy;
            v_binder.endt_seq_no := a_rec.endt_seq_no;
            v_binder.endt_type := a_rec.endt_type;
            v_binder.incept_date := a_rec.incept_date;
            v_binder.expiry_date := a_rec.expiry_date;
            v_binder.assd_no := a_rec.assd_no;
            v_binder.currency_cd := a_rec.currency_cd;
            v_binder.currency_rt := a_rec.curr_rt;
            v_binder.currency_desc := a_rec.currency_desc;
            v_binder.par_id := a_rec.par_id;
            v_binder.assd_name := a_rec.assd_name;
            IF a_rec.endt_type IS NOT NULL THEN --added by steven 10.29.2013
             v_binder.policy_no :=
                  get_policy_no (a_rec.pol_policy_id) || '-'
                  || a_rec.endt_type;
            ELSE
             v_binder.policy_no :=
                  get_policy_no (a_rec.pol_policy_id);
            END IF;
           
            v_binder.disbursement_amt :=
               giac_outfacul_prem_payts_pkg.get_list_disb_amt
                                         (p_transaction_type,
                                          p_ri_cd,
                                          a_rec.line_cd,
                                          a_rec.binder_yy,
                                          a_rec.fnl_binder_id,
                                          a_rec.binder_seq_no,
                                          v_convert_rate,
                                          a_rec.pol_policy_id,
                                          giac_validate_user_fn (p_user,
                                                                 'OD',
                                                                 p_module_name
                                                                )
                                         , null); -- SR-19631 : shan 08.17.2015
            v_binder.disbursement_amt_local := v_binder.disbursement_amt * v_binder.currency_rt; --added by steven 11.26.2014
            v_binder.prem_tag := a_rec.prem_tag;
            v_binder.prem_seq_no :=
               giac_outfacul_prem_payts_pkg.get_iss_prem_seq_no
                                                         (a_rec.fnl_binder_id,
                                                          a_rec.line_cd,
                                                          p_ri_cd
                                                         );
            v_binder.MESSAGE := v_message;
            PIPE ROW (v_binder);
         END LOOP;
      ELSIF p_transaction_type IN (2, 4)
      THEN
         FOR b_rec IN b
         LOOP
            BEGIN
               SELECT convert_rate
                 INTO v_convert_rate
                 FROM giac_outfacul_prem_payts
                WHERE gacc_tran_id = p_gacc_tran_id
                  AND a180_ri_cd = p_ri_cd
                  AND d010_fnl_binder_id = b_rec.fnl_binder_id
                  AND record_no = b_rec.record_no;    -- SR-19631 : shan 08.17.2015
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_convert_rate := 1;
            END;
            
            v_message := check_open_tran(p_transaction_type, p_ri_cd, b_rec.fnl_binder_id, b_rec.gacc_tran_id);   -- SR-19631 : shan 08.17.2015
            
            IF v_message IS NULL THEN
                BEGIN
                   check_disbursement_amt (p_transaction_type,
                                           p_ri_cd,
                                           p_gacc_tran_id,
                                           b_rec.fnl_binder_id,
                                           b_rec.line_cd,
                                           b_rec.binder_yy,
                                           b_rec.binder_seq_no,
                                           b_rec.record_no,          -- SR-19631 : shan 08.19.2015
                                           b_rec.policy_id,
                                           p_user,
                                           p_module_name,
                                           v_message
                                          );
                END;
            END IF;
            

            v_binder.line_cd := b_rec.line_cd;
            v_binder.binder_yy := b_rec.binder_yy;
            v_binder.binder_seq_no := b_rec.binder_seq_no;
            v_binder.binder_date := b_rec.binder_date;
            v_binder.binder_id := b_rec.fnl_binder_id;
            v_binder.policy_id := b_rec.policy_id;
            v_binder.pol_line_cd := b_rec.pol_line_cd;
            v_binder.pol_subline_cd := b_rec.pol_subline_cd;
            v_binder.pol_iss_cd := b_rec.pol_iss_cd;
            v_binder.pol_issue_yy := b_rec.pol_issue_yy;
            v_binder.pol_seq_no := b_rec.pol_seq_no;
            v_binder.pol_renew_no := b_rec.pol_renew_no;
            v_binder.endt_iss_cd := b_rec.endt_iss_cd;
            v_binder.endt_yy := b_rec.endt_yy;
            v_binder.endt_seq_no := b_rec.endt_seq_no;
            v_binder.endt_type := b_rec.endt_type;
            v_binder.incept_date := b_rec.incept_date;
            v_binder.expiry_date := b_rec.expiry_date;
            v_binder.assd_no := b_rec.assd_no;
            v_binder.currency_cd := b_rec.currency_cd;
            v_binder.currency_rt := b_rec.curr_rt;
            v_binder.currency_desc := b_rec.currency_desc;
            v_binder.par_id := b_rec.par_id;
            v_binder.replaced_flag := b_rec.replaced_flag;
            v_binder.reverse_sw := b_rec.reverse_sw;
            v_binder.assd_name := b_rec.assd_name;
            v_binder.remarks := b_rec.remarks;
            v_binder.ref_no     := b_rec.ref_no;    -- SR-19631 : shan 08.19.2015
            v_binder.policy_no :=
                  get_policy_no (b_rec.pol_policy_id) || '-'
                  || b_rec.endt_type;
            v_binder.disbursement_amt :=
               giac_outfacul_prem_payts_pkg.get_list_disb_amt
                                         (p_transaction_type,
                                          p_ri_cd,
                                          b_rec.line_cd,
                                          b_rec.binder_yy,
                                          b_rec.fnl_binder_id,
                                          b_rec.binder_seq_no,
                                          v_convert_rate,
                                          b_rec.pol_policy_id,
                                          giac_validate_user_fn (p_user,
                                                                 'OD',
                                                                 p_module_name
                                                                )
                                         , b_rec.gacc_tran_id); -- SR-19631 : shan 08.17.2015
            v_binder.disbursement_amt_local := v_binder.disbursement_amt * v_binder.currency_rt; --added by steven 11.26.2014
            v_binder.prem_amt := b_rec.prem_amt;
            v_binder.prem_vat := b_rec.prem_vat;
            v_binder.comm_amt := b_rec.comm_amt;
            v_binder.comm_vat := b_rec.comm_vat;
            v_binder.wholding_vat := b_rec.wholding_vat;
            v_binder.prem_tag := b_rec.prem_tag;
            v_binder.prem_seq_no :=
               giac_outfacul_prem_payts_pkg.get_iss_prem_seq_no
                                                         (b_rec.fnl_binder_id,
                                                          b_rec.line_cd,
                                                          p_ri_cd
                                                         );
            v_binder.MESSAGE := v_message;
            PIPE ROW (v_binder);
         END LOOP;
      END IF;
   END get_binder_dtls_for_override;   
   

    FUNCTION check_open_tran(
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_binder_id          giri_binder.fnl_binder_id%TYPE,
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE    
    ) RETURN VARCHAR2
    AS
        v_message   VARCHAR2(200);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIAC_OUTFACUL_PREM_PAYTS a,
                         GIAC_ACCTRANS B
                   WHERE A.transaction_type = DECODE(p_transaction_type, 1, 2, 
                                                           2, 1,
                                                           3, 4,
                                                           4, 3)
                     AND A.a180_ri_cd = p_ri_cd
                     AND A.D010_FNL_BINDER_ID = p_binder_id
                     AND A.GACC_TRAN_ID = p_gacc_tran_id
                     AND A.GACC_TRAN_ID=B.TRAN_ID
                     AND B.TRAN_FLAG = 'O'
                     AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                FROM GIAC_REVERSALS X,
                                                     GIAC_ACCTRANS Y
                                               WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                 AND Y.TRAN_FLAG !='D'))
        LOOP
            v_message :=  'RI premium payment transaction related to this invoice is still open.';
            EXIT;
        END LOOP;
        
        RETURN v_message;
        
    END check_open_tran;
   
    PROCEDURE update_rev_columns(
        p_gacc_tran_id      GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,
        p_ri_cd             GIAC_OUTFACUL_PREM_PAYTS.A180_RI_CD%TYPE,
        p_binder_id         GIAC_OUTFACUL_PREM_PAYTS.D010_FNL_BINDER_ID%TYPE,
        p_user_id           GIAC_OUTFACUL_PREM_PAYTS.USER_ID%TYPE,
        p_rev_gacc_tran_id  GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,
        p_rev_record_no     GIAC_OUTFACUL_PREM_PAYTS.REV_RECORD_NO%TYPE,
        p_add_del_sw        NUMBER
    )
    AS
    BEGIN
        -- P_ADD_DEL_SW :: 1 = Add, else delete
        UPDATE giac_outfacul_prem_payts
           SET rev_gacc_tran_id = DECODE(p_add_del_sw, 1, p_rev_gacc_tran_id, null),
               rev_record_no = DECODE(p_add_del_sw, 1, p_rev_record_no, null),
               user_id = p_user_id,
               last_update = SYSDATE
         WHERE gacc_tran_id = p_gacc_tran_id
           AND a180_ri_cd = p_ri_cd
           AND d010_fnl_binder_id = p_binder_id
           AND record_no = 0;
    END update_rev_columns;      
        
    
    PROCEDURE renumber_outfacul_prem_payts(
        p_gacc_tran_id      GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,
        p_user_id           GIAC_OUTFACUL_PREM_PAYTS.USER_ID%TYPE
    )
    AS
        TYPE outfacul_tab IS TABLE OF giac_outfacul_prem_payts%ROWTYPE  INDEX BY PLS_INTEGER;
        v_tab       outfacul_tab;
        v_cnt       NUMBER := 0;
    BEGIN
        FOR i IN (SELECT t.*, row_number() OVER (ORDER BY a180_ri_cd, d010_fnl_binder_id, ABS(disbursement_amt)) AS new_record_no
                    FROM giac_outfacul_prem_payts t 
                   WHERE transaction_type IN (2, 4)
                     AND gacc_tran_id = p_gacc_tran_id)
        LOOP            
            /*UPDATE giac_outfacul_prem_payts
               SET record_no = i.new_record_no,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = i.gacc_tran_id
               AND a180_ri_cd = i.a180_ri_cd
               AND d010_fnl_binder_id = i.d010_fnl_binder_id
               AND record_no = i.record_no;*/
               
            v_tab(v_cnt).gacc_tran_id       := i.gacc_tran_id;
            v_tab(v_cnt).a180_ri_cd         := i.a180_ri_cd;
            v_tab(v_cnt).transaction_type   := i.transaction_type;
            v_tab(v_cnt).d010_fnl_binder_id := i.d010_fnl_binder_id;
            v_tab(v_cnt).disbursement_amt   := i.disbursement_amt;
            v_tab(v_cnt).request_no         := i.request_no;
            v_tab(v_cnt).currency_cd        := i.currency_cd;
            v_tab(v_cnt).convert_rate       := i.convert_rate;
            v_tab(v_cnt).foreign_curr_amt   := i.foreign_curr_amt;
            v_tab(v_cnt).or_print_tag       := i.or_print_tag;
            v_tab(v_cnt).remarks            := i.remarks;
            v_tab(v_cnt).cpi_rec_no         := i.cpi_rec_no;
            v_tab(v_cnt).cpi_branch_cd      := i.cpi_branch_cd;
            v_tab(v_cnt).prem_amt           := i.prem_amt;
            v_tab(v_cnt).prem_vat           := i.prem_vat;
            v_tab(v_cnt).comm_amt           := i.comm_amt;
            v_tab(v_cnt).comm_vat           := i.comm_vat;
            v_tab(v_cnt).wholding_vat       := i.wholding_vat;
            v_tab(v_cnt).cm_tag             := i.cm_tag;
            v_tab(v_cnt).rev_gacc_tran_id   := i.rev_gacc_tran_id;
            v_tab(v_cnt).rev_record_no      := i.rev_record_no;
            v_tab(v_cnt).record_no          := i.new_record_no;
            v_tab(v_cnt).user_id            := p_user_id;
            v_tab(v_cnt).last_update        := SYSDATE;
            
            DELETE giac_outfacul_prem_payts
             WHERE gacc_tran_id = i.gacc_tran_id
               AND a180_ri_cd = i.a180_ri_cd
               AND d010_fnl_binder_id = i.d010_fnl_binder_id
               AND record_no = i.record_no;
               
            v_cnt := v_cnt + 1;
        END LOOP;
        
        FORALL i IN v_tab.FIRST..v_tab.LAST            
            INSERT INTO giac_outfacul_prem_payts
            VALUES v_tab(i);
                    
        
        -- UPDATES rev_record_no of corresponding payment
        FOR i IN (SELECT t.*, row_number() OVER (ORDER BY a180_ri_cd, d010_fnl_binder_id, ABS(disbursement_amt)) AS new_rev_record_no
                    FROM giac_outfacul_prem_payts t 
                   WHERE transaction_type IN (1, 3)
                     AND rev_gacc_tran_id = p_gacc_tran_id)
        LOOP
            UPDATE giac_outfacul_prem_payts
               SET rev_record_no = i.new_rev_record_no,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = i.gacc_tran_id
               AND a180_ri_cd = i.a180_ri_cd
               AND d010_fnl_binder_id = i.d010_fnl_binder_id;
        END LOOP;        
    END renumber_outfacul_prem_payts; 
    -- end SR-19631
   
END giac_outfacul_prem_payts_pkg;
/


