DROP VIEW CPI.GIAC_RECAP_SUMMARY_OSL_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_recap_summary_osl_v (rowno, rowtitle)
AS
   SELECT grr.rowno, grr.rowtitle
     FROM giac_recap_row grr
   UNION
   SELECT DISTINCT grse.rowno, grse.rowtitle
              FROM giac_recap_osloss_summ_ext grse;


