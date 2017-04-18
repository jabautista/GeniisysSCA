CREATE OR REPLACE PACKAGE CPI.GICLS265_PKG
AS
   TYPE clm_list_per_cargo_type IS RECORD (
      item_no             gicl_cargo_dtl.item_no%TYPE,
      claim_id            gicl_cargo_dtl.claim_id%TYPE,
      item_title          gicl_cargo_dtl.item_title%TYPE,
      grouped_item_no     VARCHAR2(200),
      vessel_cd           gicl_cargo_dtl.vessel_cd%TYPE,
      claim_number        VARCHAR (50),
      policy_number       VARCHAR (50),
      assured_name        GICL_CLAIMS.assured_name%TYPE,
      
      loss_res_amt        VARCHAR (50),
      loss_paid_amt       VARCHAR (50),
      exp_res_amt         VARCHAR (50),
      exp_paid_amt        VARCHAR (50),
      tot_loss_res_amt    VARCHAR (50),
      tot_loss_paid_amt   VARCHAR (50),
      tot_exp_res_amt     VARCHAR (50),
      tot_exp_paid_amt    VARCHAR (50),
      
      loss_date           GICL_CLAIMS.loss_date%TYPE,
      clm_stat_desc       GIIS_CLM_STAT.clm_stat_desc%TYPE,
      clm_file_date       GICL_CLAIMS.clm_file_date%TYPE
      
   );

   TYPE clm_list_per_cargo_tab IS TABLE OF clm_list_per_cargo_type;
   
   TYPE cargo_type_list_type IS RECORD (
      cargo_type          giis_cargo_type.cargo_type%TYPE,
      cargo_type_desc     giis_cargo_type.cargo_type_desc%TYPE
   
   );
   
   TYPE cargo_type_list_tab IS TABLE OF cargo_type_list_type;
   
   TYPE valid_cargo_class_type IS RECORD(
      cargo_class_cd      giis_cargo_class.cargo_class_cd%TYPE
      
   );
   
   TYPE valid_cargo_class_tab IS TABLE OF valid_cargo_class_type;

   FUNCTION get_clm_list_per_cargo ( 
      p_user_id                 GIIS_USERS.user_id%TYPE,
      p_cargo_class_cd          GIIS_CARGO_CLASS.cargo_class_cd%TYPE,
      p_cargo_type              GIIS_CARGO_TYPE.cargo_type%TYPE,
      p_search_by               VARCHAR2,
      p_as_of_date              VARCHAR2,
      p_from_date               VARCHAR2,   
      p_to_date                 VARCHAR2
   )
      RETURN clm_list_per_cargo_tab PIPELINED;
      
   FUNCTION validate_cargo_class(
      p_cargo_class_desc    giis_cargo_class.cargo_class_desc%TYPE
   )
   RETURN VARCHAR2;

   FUNCTION validate_cargo_type(
      p_cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE,
      p_cargo_type_desc    giis_cargo_type.cargo_type_desc%TYPE
   )
   RETURN VARCHAR2;
   
   FUNCTION fetch_cargo_type_by_code(
      p_cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE
   )
   RETURN cargo_type_list_tab PIPELINED;
   
   FUNCTION fetch_valid_cargo_class(
        p_module_id         VARCHAR2
   )
      RETURN valid_cargo_class_tab PIPELINED;
END;
/


