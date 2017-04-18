DROP VIEW cpi.giac_upload_prem_comm_v;

CREATE OR REPLACE FORCE VIEW cpi.giac_upload_prem_comm_v (payor,
                                                          v_or_colln_amt,
                                                          v_or_gross_amt,
                                                          v_or_comm_amt,
                                                          v_or_whtax_amt,
                                                          v_or_input_vat_amt,
                                                          currency_cd,
                                                          convert_rate
                                                         )
AS
   SELECT   payor, NVL (SUM (net_amt_due), 0) v_or_colln_amt,
            NVL (SUM (gross_prem_amt), 0) v_or_gross_amt,
            NVL (SUM (comm_amt), 0) v_or_comm_amt,
            NVL (SUM (whtax_amt), 0) v_or_whtax_amt,
            NVL (SUM (input_vat_amt), 0) v_or_input_vat_amt, currency_cd,
            convert_rate
       FROM giac_upload_prem_comm
      WHERE source_cd || '-' || file_no =
                                  SYS_CONTEXT ('USERENV', 'CLIENT_IDENTIFIER')
   GROUP BY payor, currency_cd, convert_rate;


DROP PUBLIC SYNONYM giac_upload_prem_comm_v;

CREATE PUBLIC SYNONYM giac_upload_prem_comm_v FOR cpi.giac_upload_prem_comm_v;