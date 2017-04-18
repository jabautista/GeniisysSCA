CREATE OR REPLACE PACKAGE CPI.gisms011_pkg
AS
   TYPE rec_type IS RECORD (
      tbg_id           NUMBER,
      param_name       giis_parameters.param_name%TYPE,
      network_number   VARCHAR2 (10)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec (p_param_name giis_parameters.param_name%TYPE)
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (
      p_rec              giis_parameters%ROWTYPE,
      p_tbg_id           NUMBER,
      p_network_number   VARCHAR2
   );

   PROCEDURE val_assd_name_format (p_assd_name_format VARCHAR2);

   PROCEDURE val_intm_name_format (p_intm_name_format VARCHAR2);

   PROCEDURE val_add_rec (
      p_param_name       giis_parameters.param_name%TYPE,
      p_network_number   VARCHAR2
   );

   PROCEDURE delete_rec (
      p_rec              giis_parameters%ROWTYPE,
      p_network_number   VARCHAR2
   );

   PROCEDURE set_name_format (p_rec giac_parameters%ROWTYPE);
END;
/


