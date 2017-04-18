CREATE OR REPLACE PACKAGE CPI.giiss085_pkg
AS
   TYPE rec_type IS RECORD (
      param_name      giis_parameters.param_name%TYPE,
      param_type      giis_parameters.param_type%TYPE,
      param_length    giis_parameters.param_length%TYPE,
      param_value_v   giis_parameters.param_value_v%TYPE,
      remarks         giis_parameters.remarks%TYPE,
      user_id         giis_parameters.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec (p_param_name giis_parameters.param_name%TYPE)
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_parameters%ROWTYPE);
END;
/


