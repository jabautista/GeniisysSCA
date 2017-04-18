CREATE OR REPLACE PACKAGE BODY CPI.GIACS283_PKG
AS
   FUNCTION get_giacs283_status_lov
   RETURN giacs283_status_lov_tab PIPELINED
   IS
      v_list giacs283_status_lov_type;
   BEGIN
        FOR i IN (
            SELECT rv_low_value, rv_meaning
              FROM cg_ref_codes
             WHERE rv_domain LIKE 'GIAC_PDC_CHECKS.CHECK_FLAG'
        )
        LOOP
            v_list.status_cd     := i.rv_low_value;  
            v_list.status_desc   := UPPER(i.rv_meaning);
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
 
END;
/


