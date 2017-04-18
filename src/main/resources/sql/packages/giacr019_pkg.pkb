CREATE OR REPLACE PACKAGE BODY CPI.giacr019_pkg
AS
   FUNCTION populate_giacr019 (p_gacc_tran_id giac_acctrans.tran_id%TYPE)
      RETURN giacr019_tab PIPELINED
   AS
      v_rec           giacr019_type;
      v_not_exist     BOOLEAN       := TRUE;
      v_other_taxes   NUMBER;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_add := giisp.v ('COMPANY_ADDRESS');

      FOR q1 IN (SELECT DISTINCT b.tran_id, a.request_date request_date,
                                    a.document_cd
                                 || '-'
                                 || a.branch_cd
                                 || '-'
                                 || a.doc_year
                                 || '-'
                                 || a.doc_mm
                                 || '-'
                                 || a.doc_seq_no request_no,
                                 c.a180_ri_cd, e.ri_name
                            FROM giac_payt_requests a,
                                 giac_payt_requests_dtl b,
                                 giac_outfacul_prem_payts c,
                                 giis_reinsurer e
                           WHERE a.ref_id = b.gprq_ref_id
                             AND b.tran_id = c.gacc_tran_id
                             AND b.tran_id = p_gacc_tran_id
                             AND c.a180_ri_cd = e.ri_cd
                 UNION
                 SELECT DISTINCT a.tran_id, a.tran_date request_date,
                                 NVL (   a.jv_tran_type
                                      || '-'
                                      || a.tran_year
                                      || '-'
                                      || a.tran_month
                                      || '-'
                                      || a.tran_seq_no,
                                      f.or_pref_suf || '-' || f.or_no
                                     ) request_no,
                                 c.a180_ri_cd, e.ri_name
                            FROM giac_acctrans a,
                                 giac_outfacul_prem_payts c,
                                 giis_reinsurer e,
                                 giac_order_of_payts f
                           WHERE a.tran_id = p_gacc_tran_id
                             AND a.tran_id = c.gacc_tran_id
                             AND c.a180_ri_cd = e.ri_cd
                             AND tran_class IN ('JV', 'COL')
                             AND a.tran_id = f.gacc_tran_id(+))
      LOOP
         v_not_exist := FALSE;
         v_rec.exist := 'Y';
         v_rec.tran_id := q1.tran_id;
         v_rec.request_date := q1.request_date;
         v_rec.request_no := q1.request_no;
         v_rec.a180_ri_cd := q1.a180_ri_cd;
         v_rec.ri_name := q1.ri_name;
         v_rec.with_vat := 'N';
         v_rec.non_vat := 'N';

         FOR q2 IN
            (SELECT DISTINCT b.tran_id, a.request_date,
                                a.document_cd
                             || '-'
                             || a.branch_cd
                             || '-'
                             || a.doc_year
                             || '-'
                             || a.doc_mm
                             || '-'
                             || a.doc_seq_no request_no,
                             c.a180_ri_cd, e.ri_name,
                                d.line_cd
                             || '-'
                             || d.binder_yy
                             || '-'
                             || d.binder_seq_no binder_no,
                             c.disbursement_amt,
                               (NVL (d.ri_prem_amt, 0)
                                + NVL (d.ri_prem_vat, 0)
                               )
                             - (  NVL (d.ri_comm_amt, 0)
                                + NVL (d.ri_comm_vat, 0)
                                + NVL (d.ri_wholding_vat, 0)
                               ) net_due,
                             c.convert_rate, c.foreign_curr_amt,
                             d.ri_prem_amt, d.ri_prem_vat, d.ri_comm_amt,
                             d.ri_comm_vat, d.ri_wholding_vat,
                             (   f.line_cd
                              || '-'
                              || f.subline_cd
                              || '-'
                              || f.iss_cd
                              || '-'
                              || LTRIM (TO_CHAR (f.issue_yy, '09'))
                              || '-'
                              || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                              || '-'
                              || LTRIM (TO_CHAR (f.renew_no, '09'))
                              || DECODE (NVL (f.endt_seq_no, 0),
                                         0, NULL,
                                            '-'
                                         || f.endt_iss_cd
                                         || '-'
                                         || LTRIM (TO_CHAR (f.endt_yy, '09'))
                                         || '-'
                                         || LTRIM (TO_CHAR (f.endt_seq_no,
                                                            '099999'
                                                           )
                                                  )
                                        )
                             ) policy_no,
                             h.assd_name, NVL (c.prem_amt, 0) prem_amt,
                             NVL (c.prem_vat, 0) prem_vat,
                             NVL (c.comm_amt, 0) comm_amt,
                             NVL (c.comm_vat, 0) comm_vat,
                             NVL (c.wholding_vat, 0) wholding_vat
                        FROM giac_payt_requests a,
                             giac_payt_requests_dtl b,
                             giac_outfacul_prem_payts c,
                             giri_binder d,
                             giis_reinsurer e,
                             giri_frps_ri i,
                             giri_distfrps j,
                             giuw_pol_dist k,
                             gipi_polbasic f,
                             gipi_parlist g,
                             giis_assured h
                       WHERE a.ref_id = b.gprq_ref_id
                         AND b.tran_id = c.gacc_tran_id
                         AND b.tran_id = p_gacc_tran_id
                         AND c.a180_ri_cd = q1.a180_ri_cd
                         AND c.d010_fnl_binder_id = d.fnl_binder_id
                         AND d.fnl_binder_id = i.fnl_binder_id
                         AND c.a180_ri_cd = e.ri_cd
                         AND f.policy_id = k.policy_id
                         AND k.dist_no = j.dist_no
                         AND j.line_cd = i.line_cd
                         AND j.frps_yy = i.frps_yy
                         AND j.frps_seq_no = i.frps_seq_no
                         AND f.par_id = g.par_id
                         AND g.assd_no = h.assd_no
                         AND k.dist_no >= 0
                         AND c.prem_vat <> 0
             UNION
             SELECT DISTINCT a.tran_id, a.tran_date request_date,
                             NVL (   a.jv_tran_type
                                  || '-'
                                  || a.tran_year
                                  || '-'
                                  || a.tran_month
                                  || '-'
                                  || a.tran_seq_no,
                                  l.or_pref_suf || '-' || l.or_no
                                 ) request_no,
                             c.a180_ri_cd, e.ri_name,
                                d.line_cd
                             || '-'
                             || d.binder_yy
                             || '-'
                             || d.binder_seq_no binder_no,
                             c.disbursement_amt,
                               (NVL (d.ri_prem_amt, 0)
                                + NVL (d.ri_prem_vat, 0)
                               )
                             - (  NVL (d.ri_comm_amt, 0)
                                + NVL (d.ri_comm_vat, 0)
                                + NVL (d.ri_wholding_vat, 0)
                               ) net_due,
                             c.convert_rate, c.foreign_curr_amt,
                             d.ri_prem_amt, d.ri_prem_vat, d.ri_comm_amt,
                             d.ri_comm_vat, d.ri_wholding_vat,
                             (   f.line_cd
                              || '-'
                              || f.subline_cd
                              || '-'
                              || f.iss_cd
                              || '-'
                              || LTRIM (TO_CHAR (f.issue_yy, '09'))
                              || '-'
                              || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                              || '-'
                              || LTRIM (TO_CHAR (f.renew_no, '09'))
                              || DECODE (NVL (f.endt_seq_no, 0),
                                         0, NULL,
                                            '-'
                                         || f.endt_iss_cd
                                         || '-'
                                         || LTRIM (TO_CHAR (f.endt_yy, '09'))
                                         || '-'
                                         || LTRIM (TO_CHAR (f.endt_seq_no,
                                                            '099999'
                                                           )
                                                  )
                                        )
                             ) policy_no,
                             h.assd_name, NVL (c.prem_amt, 0) prem_amt,
                             NVL (c.prem_vat, 0) prem_vat,
                             NVL (c.comm_amt, 0) comm_amt,
                             NVL (c.comm_vat, 0) comm_vat,
                             NVL (c.wholding_vat, 0) wholding_vat
                        FROM giac_acctrans a,
                             giac_outfacul_prem_payts c,
                             giri_binder d,
                             giis_reinsurer e,
                             gipi_polbasic f,
                             gipi_parlist g,
                             giis_assured h,
                             giri_frps_ri i,
                             giri_distfrps j,
                             giuw_pol_dist k,
                             giac_order_of_payts l
                       WHERE tran_id = p_gacc_tran_id
                         AND c.a180_ri_cd = q1.a180_ri_cd
                         AND a.tran_id = c.gacc_tran_id
                         AND c.d010_fnl_binder_id = d.fnl_binder_id
                         AND d.fnl_binder_id = i.fnl_binder_id
                         AND c.a180_ri_cd = e.ri_cd
                         AND f.policy_id = k.policy_id
                         AND k.dist_no = j.dist_no
                         AND j.line_cd = i.line_cd
                         AND j.frps_yy = i.frps_yy
                         AND j.frps_seq_no = i.frps_seq_no
                         AND f.par_id = g.par_id
                         AND g.assd_no = h.assd_no
                         AND k.dist_no >= 0
                         AND c.prem_vat <> 0
                         AND a.tran_id = l.gacc_tran_id(+)
                         AND tran_class IN ('JV', 'COL')
                    ORDER BY policy_no, binder_no)
         LOOP
            v_rec.with_vat := 'Y';
            v_rec.binder_no := q2.binder_no;
            v_rec.disbursement_amt := q2.disbursement_amt;
            v_rec.net_due := q2.net_due;
            v_rec.convert_rate := q2.convert_rate;
            v_rec.foreign_curr_amt := q2.foreign_curr_amt;
            v_rec.ri_prem_amt := q2.ri_prem_amt;
            v_rec.ri_prem_vat := q2.ri_prem_vat;
            v_rec.ri_comm_amt := q2.ri_comm_amt;
            v_rec.ri_comm_vat := q2.ri_comm_vat;
            v_rec.ri_wholding_vat := q2.ri_wholding_vat;
            v_rec.policy_no := q2.policy_no;
            v_rec.assd_name := q2.assd_name;
            v_rec.prem_amt := q2.prem_amt;
            v_rec.prem_vat := q2.prem_vat;
            v_rec.comm_amt := q2.comm_amt;
            v_rec.comm_vat := q2.comm_vat;
            v_rec.wholding_vat := q2.wholding_vat;
            PIPE ROW (v_rec);
         END LOOP;

         v_rec.binder_no := NULL;
         v_rec.disbursement_amt := NULL;
         v_rec.net_due := NULL;
         v_rec.convert_rate := NULL;
         v_rec.foreign_curr_amt := NULL;
         v_rec.ri_prem_amt := NULL;
         v_rec.ri_prem_vat := NULL;
         v_rec.ri_comm_amt := NULL;
         v_rec.ri_comm_vat := NULL;
         v_rec.ri_wholding_vat := NULL;
         v_rec.policy_no := NULL;
         v_rec.assd_name := NULL;
         v_rec.prem_amt := NULL;
         v_rec.prem_vat := NULL;
         v_rec.comm_amt := NULL;
         v_rec.comm_vat := NULL;
         v_rec.wholding_vat := NULL;

         FOR q3 IN
            (SELECT   b.tran_id, a.request_date,
                         a.document_cd
                      || '-'
                      || a.branch_cd
                      || '-'
                      || a.doc_year
                      || '-'
                      || a.doc_mm
                      || '-'
                      || a.doc_seq_no request_no,
                      c.a180_ri_cd, e.ri_name,
                         d.line_cd
                      || '-'
                      || d.binder_yy
                      || '-'
                      || d.binder_seq_no binder_no,
                      c.disbursement_amt,
                        (NVL (d.ri_prem_amt, 0) + NVL (d.ri_prem_vat, 0)
                        )
                      - (  NVL (d.ri_comm_amt, 0)
                         + NVL (d.ri_comm_vat, 0)
                         + NVL (d.ri_wholding_vat, 0)
                        ) net_due,
                      c.convert_rate, c.foreign_curr_amt, d.ri_prem_amt,
                      d.ri_prem_vat, d.ri_comm_amt, d.ri_comm_vat,
                      d.ri_wholding_vat,
                      (   f.line_cd
                       || '-'
                       || f.subline_cd
                       || '-'
                       || f.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (f.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (f.renew_no, '09'))
                       || DECODE (NVL (f.endt_seq_no, 0),
                                  0, NULL,
                                     '-'
                                  || f.endt_iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (f.endt_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (f.endt_seq_no, '099999'))
                                 )
                      ) policy_no,
                      h.assd_name, NVL (c.prem_amt, 0) prem_amt,
                      NVL (c.prem_vat, 0) prem_vat,
                      NVL (c.comm_amt, 0) comm_amt,
                      NVL (c.comm_vat, 0) comm_vat,
                      NVL (c.wholding_vat, 0) wholding_vat
                 FROM giac_payt_requests a,
                      giac_payt_requests_dtl b,
                      giac_outfacul_prem_payts c,
                      giri_binder d,
                      giis_reinsurer e,
                      giri_frps_ri i,
                      giri_distfrps j,
                      giuw_pol_dist k,
                      gipi_polbasic f,
                      gipi_parlist g,
                      giis_assured h
                WHERE a.ref_id = b.gprq_ref_id
                  AND b.tran_id = c.gacc_tran_id
                  AND b.tran_id = p_gacc_tran_id
                  AND c.a180_ri_cd = q1.a180_ri_cd
                  AND c.d010_fnl_binder_id = d.fnl_binder_id
                  AND d.fnl_binder_id = i.fnl_binder_id
                  AND c.a180_ri_cd = e.ri_cd
                  AND f.policy_id = k.policy_id
                  AND k.dist_no = j.dist_no
                  AND j.line_cd = i.line_cd
                  AND j.frps_yy = i.frps_yy
                  AND j.frps_seq_no = i.frps_seq_no
                  AND f.par_id = g.par_id
                  AND g.assd_no = h.assd_no
                  AND k.dist_no >= 0
                  AND (c.prem_vat IS NULL OR c.prem_vat = 0)
             UNION
             SELECT DISTINCT a.tran_id, a.tran_date request_date,
                             NVL (   a.jv_tran_type
                                  || '-'
                                  || a.tran_year
                                  || '-'
                                  || a.tran_month
                                  || '-'
                                  || a.tran_seq_no,
                                  l.or_pref_suf || '-' || l.or_no
                                 ) request_no,
                             c.a180_ri_cd, e.ri_name,
                                d.line_cd
                             || '-'
                             || d.binder_yy
                             || '-'
                             || d.binder_seq_no binder_no,
                             c.disbursement_amt,
                               (NVL (d.ri_prem_amt, 0)
                                + NVL (d.ri_prem_vat, 0)
                               )
                             - (  NVL (d.ri_comm_amt, 0)
                                + NVL (d.ri_comm_vat, 0)
                                + NVL (d.ri_wholding_vat, 0)
                               ) net_due,
                             c.convert_rate, c.foreign_curr_amt,
                             d.ri_prem_amt, d.ri_prem_vat, d.ri_comm_amt,
                             d.ri_comm_vat, d.ri_wholding_vat,
                             (   f.line_cd
                              || '-'
                              || f.subline_cd
                              || '-'
                              || f.iss_cd
                              || '-'
                              || LTRIM (TO_CHAR (f.issue_yy, '09'))
                              || '-'
                              || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                              || '-'
                              || LTRIM (TO_CHAR (f.renew_no, '09'))
                              || DECODE (NVL (f.endt_seq_no, 0),
                                         0, NULL,
                                            '-'
                                         || f.endt_iss_cd
                                         || '-'
                                         || LTRIM (TO_CHAR (f.endt_yy, '09'))
                                         || '-'
                                         || LTRIM (TO_CHAR (f.endt_seq_no,
                                                            '099999'
                                                           )
                                                  )
                                        )
                             ) policy_no,
                             h.assd_name, NVL (c.prem_amt, 0) prem_amt,
                             NVL (c.prem_vat, 0) prem_vat,
                             NVL (c.comm_amt, 0) comm_amt,
                             NVL (c.comm_vat, 0) comm_vat,
                             NVL (c.wholding_vat, 0) wholding_vat
                        FROM giac_acctrans a,
                             giac_outfacul_prem_payts c,
                             giis_reinsurer e,
                             giri_binder d,
                             gipi_polbasic f,
                             giuw_pol_dist k,
                             gipi_parlist g,
                             giis_assured h,
                             giri_frps_ri i,
                             giri_distfrps j,
                             giac_order_of_payts l
                       WHERE tran_id = p_gacc_tran_id
                         AND c.a180_ri_cd = q1.a180_ri_cd
                         AND a.tran_id = c.gacc_tran_id
                         AND c.d010_fnl_binder_id = d.fnl_binder_id
                         AND d.fnl_binder_id = i.fnl_binder_id
                         AND c.a180_ri_cd = e.ri_cd
                         AND f.policy_id = k.policy_id
                         AND k.dist_no = j.dist_no
                         AND j.line_cd = i.line_cd
                         AND j.frps_yy = i.frps_yy
                         AND j.frps_seq_no = i.frps_seq_no
                         AND f.par_id = g.par_id
                         AND g.assd_no = h.assd_no
                         AND k.dist_no >= 0
                         AND (c.prem_vat IS NULL OR c.prem_vat = 0)
                         AND a.tran_id = l.gacc_tran_id(+)
                         AND tran_class IN ('JV', 'COL')
                    ORDER BY policy_no, binder_no)
         LOOP
            v_rec.non_vat := 'Y';
            v_rec.binder_no1 := q3.binder_no;
            v_rec.disbursement_amt1 := q3.disbursement_amt;
            v_rec.net_due1 := q3.net_due;
            v_rec.convert_rate1 := q3.convert_rate;
            v_rec.foreign_curr_amt1 := q3.foreign_curr_amt;
            v_rec.ri_prem_amt1 := q3.ri_prem_amt;
            v_rec.ri_prem_vat1 := q3.ri_prem_vat;
            v_rec.ri_comm_amt1 := q3.ri_comm_amt;
            v_rec.ri_comm_vat1 := q3.ri_comm_vat;
            v_rec.ri_wholding_vat1 := q3.ri_wholding_vat;
            v_rec.policy_no1 := q3.policy_no;
            v_rec.assd_name1 := q3.assd_name;
            v_rec.prem_amt1 := q3.prem_amt;
            v_rec.prem_vat1 := q3.prem_vat;
            v_rec.comm_amt1 := q3.comm_amt;
            v_rec.comm_vat1 := q3.comm_vat;
            v_rec.wholding_vat1 := q3.wholding_vat;
            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;
   END populate_giacr019;
END giacr019_pkg;
/


