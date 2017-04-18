CREATE OR REPLACE PACKAGE CPI.giiss061_pkg
AS
   TYPE rec_type IS RECORD (
      param_name            giis_parameters.param_name%TYPE,
      param_type            giis_parameters.param_type%TYPE,
      param_type_mean       cg_ref_codes.rv_meaning%TYPE,
      param_value_n         giis_parameters.param_value_n%TYPE,
      param_value_v         giis_parameters.param_value_v%TYPE,
      param_value_d         giis_parameters.param_value_d%TYPE,
      param_value_d_str     giis_parameters.param_value_v%TYPE,
      param_value_d_str1    giis_parameters.param_value_v%TYPE,
      param_length          giis_parameters.param_length%TYPE,
      format_mask           giis_parameters.param_value_v%TYPE,
      remarks               giis_parameters.remarks%TYPE,
      user_id               giis_parameters.user_id%TYPE,
      last_update           VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_param_name            giis_parameters.param_name%TYPE,
      p_param_type            giis_parameters.param_type%TYPE,
      p_param_length          giis_parameters.param_length%TYPE
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_parameters%ROWTYPE);

   PROCEDURE val_add_rec (p_param_name giis_parameters.param_name%TYPE);
   
   PROCEDURE val_del_rec (p_param_name giis_parameters.param_name%TYPE);

END;
/


