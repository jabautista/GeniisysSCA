DROP PROCEDURE CPI.GIPIS060_GET_VALUE;

CREATE OR REPLACE PROCEDURE CPI.gipis060_get_value (
   p_var_line_cd              OUT   giis_parameters.param_value_v%TYPE,
   p_var_subline_motorcycle   OUT   giis_parameters.param_value_v%TYPE,
   p_var_subline_commercial   OUT   giis_parameters.param_value_v%TYPE,
   p_var_subline_private      OUT   giis_parameters.param_value_v%TYPE,
   p_var_subline_lto          OUT   giis_parameters.param_value_v%TYPE,
   p_var_coc_nlto             OUT   giis_parameters.param_value_v%TYPE,
   p_var_coc_lto              OUT   giis_parameters.param_value_v%TYPE
)
IS
   counter   NUMBER;
BEGIN
   FOR line IN (SELECT param_value_v cd
                  FROM giis_parameters
                 WHERE param_name = 'MOTOR CAR')
   LOOP
      p_var_line_cd := line.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name MOTOR CAR'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name MOTOR CAR'
         );
   END IF;

   counter := 0;

   FOR motorcycle IN (SELECT param_value_v cd
                        FROM giis_parameters
                       WHERE param_name = 'MOTORCYCLE')
   LOOP
      p_var_subline_motorcycle := motorcycle.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name MOTORCYCLE'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name MOTORCYCLE'
         );
   END IF;

   counter := 0;

   FOR commercial IN (SELECT param_value_v cd
                        FROM giis_parameters
                       WHERE param_name = 'COMMERCIAL VEHICLE')
   LOOP
      p_var_subline_commercial := commercial.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE'
         );
   END IF;

   counter := 0;

   FOR private_car IN (SELECT param_value_v cd
                         FROM giis_parameters
                        WHERE param_name = 'PRIVATE CAR')
   LOOP
      p_var_subline_private := private_car.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name PRIVATE CAR'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name PRIVATE CAR'
         );
   END IF;

   counter := 0;

   FOR lto IN (SELECT param_value_v cd
                 FROM giis_parameters
                WHERE param_name = 'LAND TRANS. OFFICE')
   LOOP
      p_var_subline_lto := lto.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE'
         );
   END IF;

   counter := 0;

   FOR lto_type IN (SELECT param_value_v cd
                      FROM giis_parameters
                     WHERE param_name = 'COC_TYPE_LTO')
   LOOP
      p_var_coc_lto := lto_type.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_LTO'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_LTO'
         );
   END IF;

   counter := 0;

   FOR nlto_type IN (SELECT param_value_v cd
                       FROM giis_parameters
                      WHERE param_name = 'COC_TYPE_NLTO')
   LOOP
      p_var_coc_nlto := nlto_type.cd;
      counter := NVL (counter, 0) + 1;
   END LOOP;

   IF NVL (counter, 0) = 0
   THEN
      raise_application_error
         ('00000',
          'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO'
         );
   ELSIF NVL (counter, 0) > 1
   THEN
      raise_application_error
         ('00000',
          'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO'
         );
   END IF;

   counter := 0;
END;
/


