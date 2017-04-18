CREATE OR REPLACE PACKAGE BODY CPI.giacr221_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.11.2013
    **  Reference By : GIACR221 - PERIL BREAKDOWN
    */
   FUNCTION get_details (
      p_line_cd     VARCHAR2,
      p_trty_yy     VARCHAR2,
      p_share_cd    VARCHAR2,
      p_ri_cd       VARCHAR2,
      p_proc_year   VARCHAR2,
      p_proc_qtr    VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_count   number(1) := 0;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      FOR i IN
         (SELECT DISTINCT SUM (giactp.premium_amt) premium_amt,
                          gperil.peril_name, greinsr.ri_name,
                          gdshre.trty_name,
                          SUM (NVL (gtqs.prem_resv_relsd_amt, 0.00)
                              ) release_amt,
                          SUM (NVL (gtqs.released_int_amt, 0.00)) interest,
                             TO_CHAR (TO_DATE (giactp.proc_qtr, 'j'),
                                      'Jspth'
                                     )
                          || ' Quarter, '
                          || TO_CHAR (giactp.proc_year) period1
                     FROM giac_treaty_perils giactp,
                          giis_peril gperil,
                          giis_reinsurer greinsr,
                          giis_dist_share gdshre,
                          giac_treaty_qtr_summary gtqs
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
                      AND giactp.proc_year =
                                           NVL (p_proc_year, giactp.proc_year)
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
                             TO_CHAR (TO_DATE (giactp.proc_qtr, 'j'), 'Jspth')
                          || ' Quarter, '
                          || TO_CHAR (giactp.proc_year)
                 ORDER BY trty_name, period1, ri_name, peril_name)
      LOOP
         v_count := 1;
         v_list.trty_name := i.trty_name;
         v_list.period1 := i.period1;
         v_list.ri_name := i.ri_name;
         v_list.release_amt := i.release_amt;
         v_list.interest := i.interest;
         v_list.peril_name := i.peril_name;
         v_list.premium_amt := i.premium_amt;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_count = 0 THEN
        PIPE ROW(v_list);
      END IF;
      --RETURN;
   END get_details;
END giacr221_pkg;
/


