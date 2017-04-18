DROP VIEW CPI.GIPI_FIRE_BASIC_ITEM_V2;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_fire_basic_item_v2 (par_id,
                                                          line_cd,
                                                          subline_cd,
                                                          iss_cd,
                                                          issue_yy,
                                                          par_yy,
                                                          par_seq_no,
                                                          quote_seq_no,
                                                          renew_no,
                                                          item_no,
                                                          district_no,
                                                          block_no,
                                                          pol_flag,
                                                          ann_tsi_amt,
                                                          assd_no,
                                                          assd_name,
                                                          eff_date,
                                                          incept_date,
                                                          expiry_date,
                                                          endt_expiry_date,
                                                          dist_flag,
                                                          tarf_cd,
                                                          construction_cd,
                                                          loc_risk,
                                                          peril_cd,
                                                          prem_rt,
                                                          peril_sname,
                                                          peril_name,
                                                          province_cd,
                                                          city,
                                                          block_id,
                                                          par_no,
                                                          fr_item_type,
                                                          risk_cd
                                                         )
AS
   SELECT c.par_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, c.par_yy,
          c.par_seq_no, c.quote_seq_no, b.renew_no, a.item_no, i.district_no,
          i.block_no, b.pol_flag, (e.tsi_amt * e.currency_rt) ann_tsi_amt,
          c.assd_no, d.assd_name, b.eff_date, b.incept_date, b.expiry_date,
          b.endt_expiry_date, f.dist_flag, a.tarf_cd, a.construction_cd,
          a.loc_risk1 || '' || a.loc_risk2 || '' || a.loc_risk3 loc_risk,
          g.peril_cd, g.prem_rt, h.peril_sname, h.peril_name, i.province_cd,
          i.city, i.block_id,
             b.line_cd
          || '-'
          || b.iss_cd
          || '-'
          || c.par_yy
          || '-'
          || c.par_seq_no
          || '-'
          || c.quote_seq_no par_no,
          a.fr_item_type, NVL (a.risk_cd, 0) risk_cd
     FROM gipi_wfireitm a,
          gipi_wpolbas b,
          gipi_parlist c,
          giis_assured d,
          gipi_witem e,
          giuw_pol_dist f,
          gipi_witmperl g,
          giis_peril h,
          giis_block i
    WHERE 1 = 1
      AND c.assd_no = d.assd_no
      AND e.par_id = a.par_id
      AND e.item_no = a.item_no
      AND a.block_id = i.block_id
      AND g.line_cd = h.line_cd
      AND g.peril_cd = h.peril_cd
      AND g.par_id(+) = e.par_id
      AND g.item_no(+) = e.item_no
      AND e.par_id = b.par_id
      AND c.par_id = f.par_id
      AND b.par_id = c.par_id
      AND c.par_status NOT IN (98, 99) --nieko 12052016 KB 894
      AND b.pol_flag IN ('1', '2', '3')      
      AND f.dist_flag IN ('1', '2', '3');


