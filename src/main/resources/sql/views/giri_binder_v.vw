DROP VIEW CPI.GIRI_BINDER_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_binder_v (line_cd,
                                                binder_yy,
                                                binder_seq_no,
                                                ri_sname,
                                                ri_shr_pct,
                                                ri_tsi_amt,
                                                ri_prem_amt,
                                                ri_comm_amt,
                                                prem_tax,
                                                frps_yy,
                                                frps_seq_no,
                                                reverse_sw,
                                                fnl_binder_id,
                                                local_foreign_sw,
                                                ri_prem_vat,
                                                ri_comm_vat,
                                                ri_wholding_vat,
                                                ri_comm_rt
                                               )
AS
   SELECT t1.line_cd, binder_yy, binder_seq_no, ri_sname, t1.ri_shr_pct,
          t1.ri_tsi_amt, t1.ri_prem_amt, t1.ri_comm_amt, t1.prem_tax, frps_yy,
          frps_seq_no, reverse_sw, t1.fnl_binder_id, local_foreign_sw,
          t1.ri_prem_vat, t1.ri_comm_vat, t1.ri_wholding_vat, t1.ri_comm_rt
     FROM giri_binder t1, giri_frps_ri t2, giis_reinsurer t3
    WHERE t1.fnl_binder_id = t2.fnl_binder_id
      AND t2.ri_cd = t3.ri_cd
      AND t3.ri_cd > 0;


