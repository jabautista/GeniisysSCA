CREATE OR REPLACE PACKAGE BODY CPI.get_cg_ref_codes
AS
/* Created by Mikel 03.16.2015
** Description : Display low value, high value and meaning of cg ref codes
*/
   FUNCTION display_ref_codes (p_table_name VARCHAR2, p_column_name VARCHAR2)
      RETURN cg_ref_codes_list_tab PIPELINED
   IS
      v_list   cg_ref_codes_list_type;
   BEGIN
      FOR rec IN (SELECT rv_low_value, rv_high_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = p_table_name || '.' || p_column_name)
      LOOP
         v_list.rv_low_value := rec.rv_low_value;
         v_list.rv_high_value := rec.rv_high_value;
         v_list.rv_meaning := rec.rv_meaning;
         PIPE ROW (v_list);
      END LOOP;
   END;
END;
/


