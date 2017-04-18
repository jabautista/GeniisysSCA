DROP VIEW CPI.BATCH_PARLIST_V2;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.batch_parlist_v2 (par_id,
                                                   line_cd,
                                                   subline_cd,
                                                   iss_cd,
                                                   par_yy,
                                                   par_seq_no,
                                                   quote_seq_no,
                                                   assd_no,
                                                   user_id,
                                                   par_type,
                                                   cred_branch,
                                                   bank_ref_no
                                                  )
AS
   SELECT /*+ ALL_ROWS*/
          a.par_id, a.line_cd, x.subline_cd, a.iss_cd, a.par_yy, a.par_seq_no,
          a.quote_seq_no, a.assd_no, x.user_id, a.par_type, x.cred_branch,
          x.bank_ref_no
     FROM gipi_parlist a, gipi_wpolbas x
    WHERE 1 = 1
      AND a.par_id = x.par_id
      AND par_status = 6
      AND EXISTS (SELECT 1
                    FROM gipi_wcomm_invoices b
                   WHERE a.par_id = b.par_id)
      AND a.pack_par_id IS NULL;


