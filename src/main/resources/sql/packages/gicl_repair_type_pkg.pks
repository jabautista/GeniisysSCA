CREATE OR REPLACE PACKAGE CPI.gicl_repair_type_pkg
AS
    /******************************************************************************
      NAME:       gicl_repair_type_pkg
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        3/03/2012    Irwin Tabisora   1. Created this package.
   ******************************************************************************/
   TYPE gicl_repair_type_type IS RECORD (
      repair_cd     gicl_repair_type.repair_cd%TYPE,
      repair_desc   gicl_repair_type.repair_desc%TYPE,
      remarks       gicl_repair_type.remarks%TYPE,
      required      gicl_repair_type.required%TYPE,
      user_id       gicl_repair_type.user_id%TYPE,
      last_update   gicl_repair_type.last_update%TYPE
   );

   TYPE gicl_repair_type_tab IS TABLE OF gicl_repair_type_type;

   FUNCTION get_repair_type_type_list (
      p_eval_id     gicl_mc_evaluation.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN gicl_repair_type_tab PIPELINED;
END;
/


