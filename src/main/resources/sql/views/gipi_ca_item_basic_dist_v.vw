DROP VIEW CPI.GIPI_CA_ITEM_BASIC_DIST_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_ca_item_basic_dist_v (par_id,
                                                            par_yy,
                                                            par_seq_no,
                                                            quote_seq_no,
                                                            assd_no,
                                                            line_cd,
                                                            subline_cd,
                                                            iss_cd,
                                                            issue_yy,
                                                            pol_seq_no,
                                                            renew_no,
                                                            pol_flag,
                                                            eff_date,
                                                            incept_date,
                                                            expiry_date,
                                                            item_no,
                                                            ann_tsi_amt,
                                                            location_cd,
                                                            prem_rt,
                                                            peril_cd,
                                                            dist_flag,
                                                            dist_tsi,
                                                            share_cd,
                                                            share_type,
                                                            peril_name,
                                                            assd_name,
                                                            location_desc
                                                           )
AS
   SELECT a.par_id, par_yy, par_seq_no, quote_seq_no, a.assd_no, b.line_cd,
          b.subline_cd, b.iss_cd, issue_yy, pol_seq_no, renew_no, pol_flag,
          b.eff_date, incept_date, NVL (endt_expiry_date, b.expiry_date),
          c.item_no, (c.ann_tsi_amt * c.currency_rt) ann_tsi_amt,
          d.location_cd, prem_rt, e.peril_cd, dist_flag,
          (dist_tsi * c.currency_rt) dist_tsi, g.share_cd, share_type,
          peril_name, assd_name, location_desc
     FROM gipi_parlist a,
          gipi_wpolbas b,
          gipi_witem c,
          gipi_wcasualty_item d,
          gipi_witmperl e,
          giuw_pol_dist f,
          giuw_witemperilds_dtl g,
          giis_peril h,
          giis_assured i,
          giis_ca_location j,
          giis_dist_share k
    WHERE a.par_id = b.par_id
      AND a.par_id = c.par_id
      AND a.par_id = d.par_id
      AND c.item_no = d.item_no
      AND a.par_id = e.par_id
      AND a.par_id = f.par_id
      AND f.dist_no = g.dist_no
      AND c.item_no = g.item_no
      AND c.item_no = e.item_no
      AND b.line_cd = h.line_cd
      AND e.peril_cd = h.peril_cd
      AND a.assd_no = i.assd_no
      AND b.line_cd = k.line_cd
      AND g.share_cd = k.share_cd
      AND g.peril_cd = e.peril_cd                   -- added by adrel 03052010
      AND b.subline_cd = NVL (giisp.v ('CA_SUBLINE_PFL'), 'PFL')
      -- added by ramon 08092010
      AND d.location_cd = j.location_cd(+);


