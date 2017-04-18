DROP PROCEDURE CPI.GICLS032_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GICLS032_NEW_FORM_INSTANCE(
  p_user_id         IN giis_users.user_id%TYPE,
  p_line_cd         IN gicl_claims.line_cd%TYPE,
  p_iss_cd          IN gicl_claims.iss_cd%TYPE,
  p_ri_iss_cd       OUT GIAC_PARAMETERS.param_value_v%TYPE,
  p_gpa_exists      OUT GIAC_PARAMETERS.param_value_v%TYPE,
  p_local_currency  OUT GIAC_PARAMETERS.param_value_n%TYPE,
  p_separate_booking OUT GIAC_PARAMETERS.param_value_v%TYPE,
  p_popup_dir       OUT VARCHAR2,
  p_range_to        OUT NUMBER,
  p_disallow_pymt   OUT GIAC_PARAMETERS.param_value_v%TYPE 
) IS   
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - WHEN_NEW_FORM_INSTANCE
  */
BEGIN 
   BEGIN
      SELECT param_value_v
        INTO p_ri_iss_cd
        FROM giac_parameters
       WHERE param_name = 'RI_ISS_CD';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error(-20001, 'Geniisys Exception#E#No existing RI_ISS_CD parameter on GIAC_PARAMETERS.');
   END;

/* gmi*/
   BEGIN
      SELECT param_value_v
        INTO p_gpa_exists
        FROM giis_parameters
       WHERE param_name = 'GROUP ACCIDENT';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error(-20001, 'Geniisys Exception#E#No Existing SUBLINE_CD parameter on GIIS_PARAMETERS.');
   END;

   -- this stores the CURRENCY CD from giac_parameters table -- csalvani 091703
   p_local_currency := giacp.n ('CURRENCY_CD');

   /*Added by: jen.120605*/
   FOR i IN (SELECT NVL (param_value_v, 'N') param_value_v
               FROM giac_parameters
              WHERE param_name LIKE 'SEPARATE_BOOKING_OF_TAXABLE_LOSS')
   LOOP
      p_separate_booking := i.param_value_v;
   END LOOP;

   IF p_separate_booking IS NULL
   THEN
      raise_application_error(-20001, 'Geniisys Exception#E#No existing SEPARATE_BOOKING_OF_TAXABLE_LOSS parameter on GIAC_PARAMETERS.');
   END IF;
   
   p_popup_dir := wf.get_popup_dir;
   
   FOR rec IN (SELECT range_to
                 FROM gicl_adv_line_amt
                WHERE adv_user = p_user_id 
                  AND line_cd = p_line_cd 
                  AND iss_cd = p_iss_cd)
   LOOP
      p_range_to := rec.range_to;
   END LOOP;
   
   p_disallow_pymt := giisp.v ('DISALLOW RESERVE LESS THAN PAYMENT');
END;
/


