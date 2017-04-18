CREATE OR REPLACE PACKAGE CPI.gipi_ves_air_pkg
AS
   TYPE ves_air_type IS RECORD (
      policy_id     gipi_ves_air.policy_id%TYPE,
      vessel_cd     gipi_ves_air.vessel_cd%TYPE,
      rec_flag      gipi_ves_air.rec_flag%TYPE,
      vescon        gipi_ves_air.vescon%TYPE,
      voy_limit     gipi_ves_air.voy_limit%TYPE,
      vessel_name   giis_vessel.vessel_name%TYPE,
      vessel_flag   giis_vessel.vessel_flag%TYPE
   );

   TYPE ves_air_tab IS TABLE OF ves_air_type;

   FUNCTION get_cargoinformations (p_policy_id gipi_ves_air.policy_id%TYPE)
      RETURN ves_air_tab PIPELINED;
END gipi_ves_air_pkg;
/


