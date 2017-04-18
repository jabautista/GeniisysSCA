CREATE OR REPLACE PACKAGE BODY CPI.gipir950_pkg
AS
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

   FUNCTION get_gipir950_record (
      p_date_basis   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir950_tab PIPELINED
   IS
      v_list        gipir950_type;
      v_not_exist   BOOLEAN       := TRUE;
    --tot_risk_pct  NUMBER;
   -- tot_prem_pct NUMBER;
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.date_basis := get_gipir950_date_basis (p_date_basis);
      v_list.header :=
         (v_list.date_basis || ' From ' || p_from_date || ' To ' || p_to_date
         );

      FOR i IN (SELECT   cat_cd, sub_cat_cd, risk_amt,
                         ROUND (risk_pct, 2) risk_pct, prem_amt,
                         ROUND (prem_pct, 2) prem_pct, ave_pct, pol_count
                    FROM gixx_risk_category
                   WHERE user_id = p_user_id 
                ORDER BY cat_cd, sub_cat_cd)
      LOOP
         SELECT ROUND (SUM (risk_pct)) tot_risk_pct
           INTO v_list.cp_tot_risk_pct
           FROM gixx_risk_category
          WHERE cat_cd = i.cat_cd;

         SELECT ROUND (SUM (prem_pct)) tot_prem_pct
           INTO v_list.cp_tot_prem_pct
           FROM gixx_risk_category
          WHERE cat_cd = i.cat_cd
            AND user_id = p_user_id;

         v_not_exist := FALSE;
         v_list.cat_cd := i.cat_cd;
         v_list.sub_cat_cd := i.sub_cat_cd;
         v_list.risk_amt := i.risk_amt;
         v_list.risk_pct := (i.risk_pct || ' % ');
         v_list.prem_amt := i.prem_amt;
         v_list.prem_pct := (i.prem_pct || ' % ');
         v_list.ave_pct := (i.ave_pct || ' % ');
         v_list.pol_count := i.pol_count;
         v_list.category_desc := get_gipir950_category_desc (i.cat_cd);
         v_list.cp_tot_prem_pct2 := (v_list.cp_tot_prem_pct || ' % ');
         v_list.cp_tot_risk_pct2 := (v_list.cp_tot_risk_pct || ' % ');
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir950_record;

   FUNCTION get_gipir950_subcategory (
      p_date_basis   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN subcategory_tab PIPELINED
   IS
      v_list        subcategory_type;
      v_not_exist   BOOLEAN          := TRUE;
   BEGIN
      FOR i IN (SELECT   rv_low_value || ' - ' || rv_meaning sub_cat_cd_desc
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIPI_POLBASIC.RISK_TAG'
                ORDER BY rv_low_value)
      LOOP
         v_not_exist := FALSE;
         v_list.sub_cat_cd_desc := i.sub_cat_cd_desc;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir950_subcategory;
END;
/


