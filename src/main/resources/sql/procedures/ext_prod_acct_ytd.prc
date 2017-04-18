DROP PROCEDURE CPI.EXT_PROD_ACCT_YTD;

CREATE OR REPLACE PROCEDURE CPI.Ext_Prod_Acct_Ytd IS

v_ytd_prem		  NUMBER(20,2);
v_ytd_tsi		  NUMBER(20,2);
v_ytd_nop		  NUMBER(12);

BEGIN

FOR prod IN (
  SELECT DISTINCT acct_prod_date acct_year,
  		 line_cd,
		 subline_cd,
		 branch_cd,
		 intm_no,
		 assd_no
    FROM eim_production_ext
   WHERE acct_prod_date IS NOT NULL)
LOOP
  v_ytd_prem			:= 0;
  v_ytd_tsi				:= 0;
  v_ytd_nop				:= 0;

  FOR ytd IN (
    SELECT NVL(SUM(prod_prem),0) ytd_prem,
		   NVL(SUM(prod_tsi),0) ytd_tsi,
		   NVL(SUM(prod_nop),0) ytd_nop
	  FROM eim_production_ext
	 WHERE line_cd    = NVL(prod.line_cd, line_cd)
	   AND subline_cd = NVL(prod.subline_cd, subline_cd)
	   AND branch_cd  = NVL(prod.branch_cd, branch_cd)
	   AND intm_no    = NVL(prod.intm_no, intm_no)
	   AND assd_no    = NVL(prod.assd_no, assd_no)
	   AND acct_prod_date >= TO_DATE ('01-01-'||TO_CHAR(prod.acct_year, 'YYYY'),'MM-DD-YYYY')
       AND acct_prod_date <= prod.acct_year)
  LOOP
  dbms_output.put_line(prod.line_cd||'-'||prod.subline_cd||'-'||prod.branch_cd||'-'||prod.intm_no||'-'||prod.assd_no);
    v_ytd_prem		:= ytd.ytd_prem;
	v_ytd_tsi		:= ytd.ytd_tsi;
	v_ytd_nop		:= ytd.ytd_nop;
  dbms_output.put_line(v_ytd_prem||'-'||v_ytd_tsi||'-'||v_ytd_nop);
  END LOOP;

	UPDATE eim_production_ext
	   SET ytd_prem = v_ytd_prem,
	   	   ytd_tsi  = v_ytd_tsi,
		   ytd_nop	= v_ytd_nop
	 WHERE line_cd = NVL(prod.line_cd, line_cd)
	   AND subline_cd = NVL(prod.subline_cd, subline_cd)
	   AND branch_cd = NVL(prod.branch_cd, branch_cd)
	   AND intm_no = NVL(prod.intm_no, intm_no)
	   AND assd_no = NVL(prod.assd_no, assd_no)
	   AND acct_prod_date = prod.acct_year;
    dbms_output.put_line('update-'||v_ytd_prem||'-'||v_ytd_tsi||'-'||v_ytd_nop);
END LOOP;
COMMIT;
END;
/

DROP PROCEDURE CPI.EXT_PROD_ACCT_YTD;

