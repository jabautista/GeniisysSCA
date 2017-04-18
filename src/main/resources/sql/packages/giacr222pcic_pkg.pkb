CREATE OR REPLACE PACKAGE BODY CPI.giacr222pcic_pkg
AS
   FUNCTION get_giacr222pcic_company
      RETURN VARCHAR2
   IS
      v_co_name   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_co_name
        FROM giis_parameters
       WHERE param_name LIKE 'COMPANY_NAME';

      RETURN v_co_name;
   END get_giacr222pcic_company;

   FUNCTION get_giacr222pcic_address
      RETURN VARCHAR2
   IS
      v_address   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name LIKE 'COMPANY_ADDRESS';

      RETURN v_address;
   END get_giacr222pcic_address;

   FUNCTION get_giacr222_pcic_records (p_line_cd VARCHAR2, p_proc_qtr VARCHAR2, p_proc_year VARCHAR2, p_ri_cd VARCHAR2, p_share_cd VARCHAR2, p_trty_yy VARCHAR2)
      RETURN giacr222_pcic_record_tab PIPELINED
   IS
      v_list   giacr222_pcic_record_type;
      v_count   number(1) := 0;
   BEGIN
   
      v_list.company := get_giacr222pcic_company;
      v_list.address := get_giacr222pcic_address;
         
      FOR i IN (SELECT   SUM (giactp.commission_amt) commission_amt, gperil.peril_name, greinsr.ri_name, gdshre.trty_name, SUM (NVL (gtqs.prem_resv_retnd_amt, 0.00)) retain_amt,
                         SUM (NVL (gtqs.wht_tax_amt, 0.00)) tax_amt, TO_CHAR (TO_DATE (giactp.proc_qtr, 'j'), 'Jspth') || ' Quarter, ' || TO_CHAR (giactp.proc_year) period1, giactp.proc_qtr,
                         giactp.proc_year
                    FROM giac_treaty_perils giactp, giis_peril gperil, giis_reinsurer greinsr, giis_dist_share gdshre, giac_treaty_qtr_summary gtqs
                   WHERE giactp.line_cd = gperil.line_cd
                     AND giactp.ri_cd = greinsr.ri_cd
                     AND giactp.peril_cd = gperil.peril_cd
                     AND giactp.share_cd = gdshre.share_cd
                     AND giactp.trty_yy = gdshre.trty_yy
                     AND giactp.line_cd = gdshre.line_cd
                     AND giactp.line_cd = NVL (p_line_cd, giactp.line_cd)
                     AND giactp.trty_yy = NVL (p_trty_yy, giactp.trty_yy)
                     AND giactp.share_cd = NVL (p_share_cd, giactp.share_cd)
                     AND giactp.ri_cd = NVL (p_ri_cd, giactp.ri_cd)
                     AND giactp.proc_year = NVL (p_proc_year, giactp.proc_year)
                     AND giactp.proc_qtr = NVL (p_proc_qtr, giactp.proc_qtr)
                     AND giactp.line_cd = gtqs.line_cd
                     AND giactp.ri_cd = gtqs.ri_cd
                     AND giactp.share_cd = gtqs.share_cd
                     AND giactp.trty_yy = gtqs.trty_yy
                     AND giactp.proc_qtr = gtqs.proc_qtr
                     AND giactp.proc_year = gtqs.proc_year
                GROUP BY gperil.peril_name,
                         greinsr.ri_name,
                         gdshre.trty_name,
                         TO_CHAR (TO_DATE (giactp.proc_qtr, 'j'), 'Jspth') || ' Quarter, ' || TO_CHAR (giactp.proc_year),
                         giactp.proc_qtr,
                         giactp.proc_year
                ORDER BY trty_name, giactp.proc_year, giactp.proc_qtr, ri_name, peril_name)
      LOOP
         v_count := 1;
         v_list.ri_name := i.ri_name;
         v_list.trty_name := i.trty_name;
         v_list.retain_amt := i.retain_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.period1 := i.period1;
         v_list.proc_qtr := i.proc_qtr;
         v_list.proc_year := i.proc_year;
         
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_count = 0 THEN
        PIPE ROW(v_list);
      END IF;
      
   END get_giacr222_pcic_records;

   FUNCTION get_giacr222_pcic_peril_name (p_line_cd VARCHAR2, p_proc_qtr VARCHAR2, p_proc_year VARCHAR2, p_ri_cd VARCHAR2, p_share_cd VARCHAR2, p_trty_yy VARCHAR2, p_trty_name VARCHAR2, p_ri_name VARCHAR2)
      RETURN giacr222_pcic_peril_name_tab PIPELINED
   AS
      v_list    giacr222_pcic_peril_name_type;
      v_count   NUMBER := 0;
   BEGIN
      FOR i IN (SELECT DISTINCT SUM (NVL (gtqs.prem_resv_retnd_amt, 0.00)) retain_amt, SUM (giactp.commission_amt) commission_amt, gperil.peril_name, greinsr.ri_name, gdshre.trty_name,
                                SUM (NVL (gtqs.wht_tax_amt, 0.00)) tax_amt, TO_CHAR (TO_DATE (giactp.proc_qtr, 'j'), 'Jspth') || ' Quarter, ' || TO_CHAR (giactp.proc_year) period1, giactp.proc_qtr,
                                giactp.proc_year
                           FROM giac_treaty_perils giactp, giis_peril gperil, giis_reinsurer greinsr, giis_dist_share gdshre, giac_treaty_qtr_summary gtqs
                          WHERE giactp.line_cd = gperil.line_cd
                            AND gdshre.trty_name = NVL (p_trty_name, gdshre.trty_name)
                            AND giactp.ri_cd = greinsr.ri_cd
                            AND giactp.peril_cd = gperil.peril_cd
                            AND giactp.share_cd = gdshre.share_cd
                            AND giactp.trty_yy = gdshre.trty_yy
                            AND giactp.line_cd = gdshre.line_cd
                            AND giactp.line_cd = NVL (p_line_cd, giactp.line_cd)
                            AND giactp.trty_yy = NVL (p_trty_yy, giactp.trty_yy)
                            AND giactp.share_cd = NVL (p_share_cd, giactp.share_cd)
                            AND giactp.ri_cd = NVL (p_ri_cd, giactp.ri_cd)
                            AND giactp.proc_year = NVL (p_proc_year, giactp.proc_year)
                            AND giactp.proc_qtr = NVL (p_proc_qtr, giactp.proc_qtr)
                            AND giactp.line_cd = gtqs.line_cd
                            AND giactp.ri_cd = gtqs.ri_cd
                            AND giactp.share_cd = gtqs.share_cd
                            AND giactp.trty_yy = gtqs.trty_yy
                            AND giactp.proc_qtr = gtqs.proc_qtr
                            AND giactp.proc_year = gtqs.proc_year
                            --
                            AND greinsr.ri_name = NVL (p_ri_name, greinsr.ri_name)
                       GROUP BY gperil.peril_name, greinsr.ri_name, gdshre.trty_name, giactp.proc_qtr, giactp.proc_year
                       ORDER BY trty_name, period1, ri_name, peril_name)
      LOOP
         IF v_list.ri_name = i.ri_name THEN
            v_list.v_count := 0;
            v_list.v_dummy_retain_amt := NULL;
         ELSE
            v_list.v_count := 1;
            v_list.v_dummy_retain_amt := i.retain_amt;
         END IF;

         v_list.peril_name := i.peril_name;
         v_list.commission_amt := i.commission_amt;
         v_list.ri_name := i.ri_name;
         v_list.trty_name := i.trty_name;
         v_list.retain_amt := i.retain_amt;
         v_list.tax_amt := i.tax_amt;
         v_list.period1 := i.period1;
         v_list.proc_qtr := i.proc_qtr;
         v_list.proc_year := i.proc_year;
         v_list.company := get_giacr222pcic_company;
         v_list.address := get_giacr222pcic_address;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr222_pcic_peril_name;
END;
/


