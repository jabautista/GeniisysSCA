SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giac_parameters
    WHERE param_name = 'HIDE_SOA_NET_ASSD';

   IF v_exist = 1 THEN
      DELETE FROM giac_parameters
      WHERE param_name = 'HIDE_SOA_NET_ASSD'
      AND param_type = 'V';

      DBMS_OUTPUT.put_line ('HIDE_SOA_NET_ASSD deleted from giac_parameters.');
      COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line ('HIDE_SOA_NET_ASSD not found in giac_parameters.');
END;