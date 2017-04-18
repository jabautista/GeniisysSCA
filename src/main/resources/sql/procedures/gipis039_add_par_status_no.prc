DROP PROCEDURE CPI.GIPIS039_ADD_PAR_STATUS_NO;

CREATE OR REPLACE PROCEDURE CPI.gipis039_add_par_status_no (
   p_par_id            IN       gipi_parlist.par_id%TYPE,
   p_line_cd           IN       gipi_parlist.line_cd%TYPE,
   p_par_status        IN       gipi_parlist.par_status%TYPE,
   p_iss_cd                     gipi_parlist.iss_cd%TYPE,
   p_var_endt_tax_sw   OUT      VARCHAR2,
   p_var_negate_item            VARCHAR2,
   p_button_id1                 NUMBER,
   p_button_id2                 NUMBER
)
IS
   p_dist_no   giuw_pol_dist.dist_no%TYPE;
   v_counter   NUMBER;
   v_exist     VARCHAR2 (1)                 := 'N';
BEGIN
   SELECT DISTINCT 1
              INTO v_counter
              FROM gipi_witmperl
             WHERE par_id = p_par_id;

   FOR a IN (SELECT dist_no
               FROM giuw_pol_dist
              WHERE par_id = p_par_id)
   LOOP
      gipis039_changes_in_par_status (p_par_id,
                                      a.dist_no,
                                      p_line_cd,
                                      p_iss_cd,
                                      p_par_status,
                                      p_var_endt_tax_sw,
                                      p_var_negate_item,
                                      p_button_id1,
                                      p_button_id2
                                     );
      v_exist := 'Y';
   END LOOP;

   IF v_exist = 'N'
   THEN
      gipis039_changes_in_par_status (p_par_id,
                                      p_dist_no,
                                      p_line_cd,
                                      p_iss_cd,
                                      p_par_status,
                                      p_var_endt_tax_sw,
                                      p_var_negate_item,
                                      p_button_id1,
                                      p_button_id2
                                     );
   END IF;

   IF p_par_status = 3 OR p_par_status IS NULL
   THEN
      NULL;
   ELSIF p_par_status > 3
   THEN
      NULL;
   ELSIF p_par_status < 3
   THEN
      raise_application_error
         ('GENIISYS',
             'You are not granted access to this form. The changes that you have made '
          || 'will not be committed to the database.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      gipis039_changes_in_par_status (p_par_id,
                                      p_dist_no,
                                      p_line_cd,
                                      p_iss_cd,
                                      p_par_status,
                                      p_var_endt_tax_sw,
                                      p_var_negate_item,
                                      p_button_id1,
                                      p_button_id2
                                     );
END;
/


