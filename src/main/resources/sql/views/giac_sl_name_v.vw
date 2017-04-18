DROP VIEW CPI.GIAC_SL_NAME_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_sl_name_v (fund_cd,
                                                 sl_cd,
                                                 sl_name,
                                                 sl_type_cd,
                                                 source_table
                                                )
AS
   SELECT gsll.fund_cd fund_cd, gsll.sl_cd sl_cd, gsll.sl_name sl_name,
          gsll.sl_type_cd sl_type_cd, '1' source_table
     FROM giac_sl_lists gsll
   UNION ALL
   SELECT NULL fund_cd, gpay.payee_no sl_cd,
          DECODE (gpay.payee_first_name,
                  NULL, gpay.payee_last_name
                   || ' '
                   || gpay.payee_first_name
                   || ' '
                   || gpay.payee_first_name,
                     gpay.payee_last_name
                  || ', '
                  || gpay.payee_first_name
                  || ' '
                  || gpay.payee_first_name
                 ) sl_name,
          gpay.payee_class_cd sl_type_cd, '2' source_table
     FROM giis_payees gpay
          WITH READ ONLY;


