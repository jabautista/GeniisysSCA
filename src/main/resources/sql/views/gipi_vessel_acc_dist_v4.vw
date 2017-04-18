DROP VIEW CPI.GIPI_VESSEL_ACC_DIST_V4;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_vessel_acc_dist_v4 (line_cd,
                                                          subline_cd,
                                                          iss_cd,
                                                          issue_yy,
                                                          renew_no,
                                                          pol_flag,
                                                          incept_date,
                                                          expiry_date,
                                                          endt_expiry_date,
                                                          eff_date,
                                                          ann_tsi_amt,
                                                          tsi_amt,
                                                          rec_flag,
                                                          item_no,
                                                          vessel_cd,
                                                          peril_cd,
                                                          prem_rt,
                                                          par_id,
                                                          par_yy,
                                                          par_seq_no,
                                                          quote_seq_no,
                                                          assd_no,
                                                          par_no,
                                                          assd_name,
                                                          dist_flag,
                                                          dist_tsi,
                                                          share_cd,
                                                          peril_sname,
                                                          peril_name
                                                         )
AS
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_witem_ves a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_itemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_waviation_item a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_itemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_wcargo a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_itemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
      AND h.peril_cd =
                      g.peril_cd
                                --added by steven 10.03.2013 base on test case
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_wcargo_carrier a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_itemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_witem_ves a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_witemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_waviation_item a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_witemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_wcargo a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_witemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, a.item_no, a.vessel_cd, g.peril_cd, g.prem_rt, c.par_id,
          c.par_yy, c.par_seq_no, c.quote_seq_no, c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          d.assd_name, f.dist_flag, j.dist_tsi, j.share_cd, h.peril_sname,
          h.peril_name
     FROM gipi_wpolbas b,
          gipi_witem e,
          gipi_wcargo_carrier a,
          gipi_witmperl g,
          gipi_parlist c,
          giis_assured d,
          giuw_pol_dist f,
          giuw_witemperilds_dtl j,
          giis_peril h
    WHERE 1 = 1
      AND b.par_id = e.par_id                                  -- gipi_wpolbas
      AND b.par_id = a.par_id
      AND a.par_id = e.par_id                                    -- gipi_witem
      AND a.item_no = e.item_no                                  -- gipi_witem
      AND a.par_id = g.par_id                                 -- gipi_witmperl
      AND a.item_no = g.item_no                               -- gipi_witmperl
      AND b.par_id = c.par_id
      AND b.par_id = f.par_id
      AND f.dist_no = j.dist_no
      AND f.dist_no = f.dist_no
      AND NVL (c.assd_no, c.assd_no) = d.assd_no
      AND g.item_no = j.item_no
      AND g.peril_cd = j.peril_cd
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND d.assd_no > 0
      AND b.line_cd LIKE '%'
      AND b.pol_flag IN ('1', '2', '3')
      AND f.dist_flag IN ('1', '2', '3');


