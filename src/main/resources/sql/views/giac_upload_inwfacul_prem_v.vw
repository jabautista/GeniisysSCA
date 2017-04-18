DROP VIEW cpi.giac_upload_inwfacul_prem_v;

CREATE OR REPLACE FORCE VIEW cpi.giac_upload_inwfacul_prem_v (ri_cd,
                                                              lcollection_amt,
                                                              currency_cd,
                                                              convert_rate
                                                             )
AS
   SELECT   ri_cd, SUM (lcollection_amt) lcollection_amt, currency_cd,
            convert_rate
       FROM giac_upload_inwfacul_prem
      WHERE source_cd || '-' || file_no =
                                  SYS_CONTEXT ('USERENV', 'CLIENT_IDENTIFIER')
   GROUP BY ri_cd, currency_cd, convert_rate;

DROP PUBLIC SYNONYM giac_upload_inwfacul_prem_v;

CREATE PUBLIC SYNONYM giac_upload_inwfacul_prem_v FOR cpi.giac_upload_inwfacul_prem_v;