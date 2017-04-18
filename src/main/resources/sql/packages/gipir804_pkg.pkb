CREATE OR REPLACE PACKAGE BODY CPI.gipir804_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 12.27.2013
    **  Reference By : GIPIR804 - List of District/Block
    */
   FUNCTION get_details
      RETURN get_details_tab PIPELINED
   IS
      v_list    get_details_type;
      v_print   BOOLEAN          := TRUE;
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

      FOR i IN (SELECT   a.province_cd || '-' || b.province_desc province,
                         a.city_cd || '-' || c.city city, a.district_no,
                         a.block_no, a.block_desc
                    FROM giis_block a, giis_province b, giis_city c
                   WHERE a.province_cd = b.province_cd
                     AND a.city_cd = c.city_cd
                ORDER BY province, city)
      LOOP
         v_list.province := i.province;
         v_list.city := i.city;
         v_list.district_no := i.district_no;
         v_list.block_no := i.block_no;
         v_list.block_desc := i.block_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_details;
END gipir804_pkg;
/


