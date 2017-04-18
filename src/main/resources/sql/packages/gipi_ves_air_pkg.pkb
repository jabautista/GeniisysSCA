CREATE OR REPLACE PACKAGE BODY CPI.gipi_ves_air_pkg
AS
   FUNCTION get_cargoinformations (p_policy_id gipi_ves_air.policy_id%TYPE)
      RETURN ves_air_tab PIPELINED
   IS
      v_ves_air   ves_air_type;
   BEGIN
      FOR i IN (SELECT policy_id, vessel_cd, rec_flag, vescon, voy_limit
                  FROM gipi_ves_air
                 WHERE policy_id = NVL(p_policy_id,policy_id))
      LOOP
         v_ves_air.policy_id := i.policy_id;
         v_ves_air.vessel_cd := i.vessel_cd;
         v_ves_air.rec_flag := i.rec_flag;
         v_ves_air.vescon := i.vescon;
         v_ves_air.voy_limit := i.voy_limit;

         SELECT vessel_name, vessel_flag
           INTO v_ves_air.vessel_name, v_ves_air.vessel_flag
           FROM giis_vessel
          WHERE vessel_cd = i.vessel_cd;

         PIPE ROW (v_ves_air);
      END LOOP;
   END get_cargoinformations;               --moses 05122011
END gipi_ves_air_pkg;
/


