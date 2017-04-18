CREATE OR REPLACE PACKAGE BODY CPI.CSV_UW_INQUIRIES_GIPIR950 AS
/*
**  Created by   : Bernadette Quitain
**  Date Created : 03.28.2016
**  Reference By : GIPIR950 - Risk Category
*/

   FUNCTION get_gipir950_date_basis (p_date_basis VARCHAR2)
      RETURN CHAR
   IS
      v_date_basis   VARCHAR2 (50);
   BEGIN
      IF p_date_basis = '1'
      THEN
         v_date_basis := 'Acct. Entry Date';
      ELSIF p_date_basis = '2'
      THEN
         v_date_basis := 'Issue Date';
      ELSIF p_date_basis = '3'
      THEN
         v_date_basis := 'Effectivity Date';
      ELSIF p_date_basis = '4'
      THEN
         v_date_basis := 'Booking Date';
      ELSE
         v_date_basis := 'No Basis';
      END IF;

      RETURN (v_date_basis);
   END get_gipir950_date_basis;

   FUNCTION get_gipir950_category_desc (p_cat_cd VARCHAR2)
      RETURN CHAR
   IS
      v_category   VARCHAR2 (50);
   BEGIN
      SELECT rv_meaning
        INTO v_category
        FROM cg_ref_codes
       WHERE rv_domain = 'GIXX_RISK_CATEGORY.CAT_CD'
         AND rv_low_value = p_cat_cd;

      RETURN (v_category);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (' ');
   END get_gipir950_category_desc;

   FUNCTION csv_gipir950 (
      p_date_basis   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir950_tab PIPELINED
   IS
      v_list        gipir950_type;
      v_not_exist   BOOLEAN       := TRUE;
   
   BEGIN

      FOR i IN ( SELECT cat_cd,rv_low_value || ' - ' || rv_meaning sub_category, risk_amt,
                  ROUND (risk_pct, 2) risk_pct, prem_amt,
                  ROUND (prem_pct, 2) prem_pct, ave_pct
                   FROM gixx_risk_category,cg_ref_codes
                  WHERE user_id = p_user_id
                    AND CG_REF_CODES.RV_DOMAIN = 'GIPI_POLBASIC.RISK_TAG'
                    AND  CG_REF_CODES.RV_LOW_VALUE = GIXX_RISK_CATEGORY.SUB_CAT_CD
                  ORDER BY cat_cd,sub_cat_cd)
      LOOP 
         v_not_exist := FALSE;
         v_list.category := get_gipir950_category_desc (i.cat_cd);
         v_list.sub_category_desc := i.sub_category;
         v_list.risk := trim(to_char(i.risk_amt, '9,999,999,999,990.00'));
         IF i.risk_pct = 0
         THEN
            v_list.risk_pct_total := 0|| ' %';
         ELSE
            v_list.risk_pct_total := trim(to_char(i.risk_pct, '990.00') || ' %');
         END IF;
         v_list.premium := trim(to_char(i.prem_amt, '9,999,999,999,990.00'));
         IF i.prem_pct = 0
         THEN
            v_list.premium_pct_total :=0|| ' %';
         ELSE
            v_list.premium_pct_total := trim(to_char(i.prem_pct, '990.00')|| ' %');
         END IF;
         IF i.ave_pct = 0
         THEN
            v_list.ave_rate := 0|| ' %';
         ELSE
         v_list.ave_rate := trim(to_char(i.ave_pct, '990.00') || ' %');
         END IF;
         PIPE ROW (v_list);
      END LOOP;

       IF v_not_exist
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_gipir950;
   END;
/
