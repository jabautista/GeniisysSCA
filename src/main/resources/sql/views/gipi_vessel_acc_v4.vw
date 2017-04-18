DROP VIEW CPI.GIPI_VESSEL_ACC_V4;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_vessel_acc_v4 (line_cd,
                                                     subline_cd,
                                                     iss_cd,
                                                     issue_yy,
                                                     renew_no,
                                                     pol_flag,
                                                     incept_date,
                                                     expiry_date,
                                                     endt_expiry_date,
                                                     eff_date,
                                                     endt_seq_no,
                                                     endt_yy,
                                                     endt_iss_cd,
                                                     item_no,
                                                     vessel_cd,
                                                     ann_tsi_amt,
                                                     tsi_amt,
                                                     rec_flag,
                                                     par_id,
                                                     par_yy,
                                                     par_seq_no,
                                                     quote_seq_no,
                                                     assd_no,
                                                     par_no,
                                                     peril_cd,
                                                     prem_rt,
                                                     dist_flag,
                                                     peril_sname,
                                                     peril_name,
                                                     assd_name
                                                    )
AS
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_yy, c.par_seq_no, c.quote_seq_no,
          c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          g.peril_cd, g.prem_rt, i.dist_flag, h.peril_sname, h.peril_name,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_waviation_item a,
          gipi_witem e,
          gipi_witmperl g,
          giuw_pol_dist i,
          giis_peril h,
          giis_assured d,
          gipi_parlist c
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND e.par_id = g.par_id(+)
      AND e.item_no = g.item_no(+)
      AND b.par_id = c.par_id                        --NVL(b.par_id, b.par_id)
      AND b.par_id = i.par_id
      AND c.par_id = i.par_id
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND b.line_cd = c.line_cd                    -- for optimization purpose
      AND i.dist_no = i.dist_no                    -- for optimization purpose
      AND c.assd_no = d.assd_no
      AND b.line_cd LIKE '%'                       -- for optimization purpose
      AND b.pol_flag IN ('1', '2', '3')
      AND i.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_yy, c.par_seq_no, c.quote_seq_no,
          c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          g.peril_cd, g.prem_rt, i.dist_flag, h.peril_sname, h.peril_name,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_wcargo a,
          gipi_witem e,
          gipi_witmperl g,
          giuw_pol_dist i,
          giis_peril h,
          giis_assured d,
          gipi_parlist c
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND e.par_id = g.par_id(+)
      AND e.item_no = g.item_no(+)
      AND b.par_id = c.par_id                        --NVL(b.par_id, b.par_id)
      AND b.par_id = i.par_id
      AND c.par_id = i.par_id
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND b.line_cd = c.line_cd                    -- for optimization purpose
      AND i.dist_no = i.dist_no                    -- for optimization purpose
      AND c.assd_no = d.assd_no
      AND b.line_cd LIKE '%'                       -- for optimization purpose
      AND b.pol_flag IN ('1', '2', '3')
      AND i.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_yy, c.par_seq_no, c.quote_seq_no,
          c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          g.peril_cd, g.prem_rt, i.dist_flag, h.peril_sname, h.peril_name,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_wcargo_carrier a,
          gipi_witem e,
          gipi_witmperl g,
          giuw_pol_dist i,
          giis_peril h,
          giis_assured d,
          gipi_parlist c
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND e.par_id = g.par_id(+)
      AND e.item_no = g.item_no(+)
      AND b.par_id = c.par_id                        --NVL(b.par_id, b.par_id)
      AND b.par_id = i.par_id
      AND c.par_id = i.par_id
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND b.line_cd = c.line_cd                    -- for optimization purpose
      AND i.dist_no = i.dist_no                    -- for optimization purpose
      AND c.assd_no = d.assd_no
      AND b.line_cd LIKE '%'                       -- for optimization purpose
      AND b.pol_flag IN ('1', '2', '3')
      AND i.dist_flag IN ('1', '2', '3')
   UNION
   SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.renew_no,
          b.pol_flag, b.incept_date, b.expiry_date, b.endt_expiry_date,
          b.eff_date, b.endt_seq_no, b.endt_yy, b.endt_iss_cd, a.item_no,
          a.vessel_cd, (e.tsi_amt * e.currency_rt) ann_tsi_amt, e.tsi_amt,
          e.rec_flag, c.par_id, c.par_yy, c.par_seq_no, c.quote_seq_no,
          c.assd_no,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          g.peril_cd, g.prem_rt, i.dist_flag, h.peril_sname, h.peril_name,
          d.assd_name
     FROM gipi_wpolbas b,
          gipi_witem_ves a,
          gipi_witem e,
          gipi_witmperl g,
          giuw_pol_dist i,
          giis_peril h,
          giis_assured d,
          gipi_parlist c
    WHERE 1 = 1
      AND b.par_id = a.par_id
      AND b.par_id = e.par_id
      AND a.par_id = e.par_id
      AND a.item_no = e.item_no
      AND e.par_id = g.par_id(+)
      AND e.item_no = g.item_no(+)
      AND b.par_id = c.par_id                        --NVL(b.par_id, b.par_id)
      AND b.par_id = i.par_id
      AND c.par_id = i.par_id
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND b.line_cd = c.line_cd                    -- for optimization purpose
      AND i.dist_no = i.dist_no                    -- for optimization purpose
      AND c.assd_no = d.assd_no
      AND b.line_cd LIKE '%'                       -- for optimization purpose
      AND b.pol_flag IN ('1', '2', '3')
      AND i.dist_flag IN ('1', '2', '3');


