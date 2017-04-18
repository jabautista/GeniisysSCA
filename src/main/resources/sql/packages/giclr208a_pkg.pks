CREATE OR REPLACE PACKAGE CPI.giclr208a_pkg
AS
   TYPE giclr208a_type IS RECORD (
      intm_no             VARCHAR2 (10),
      intm_name           VARCHAR2 (200),
      iss_cd              VARCHAR2 (10),
      iss_name            VARCHAR2 (200),
      line_cd             VARCHAR2 (20),
      line_name           VARCHAR2 (100),
      claim_number        VARCHAR2 (50),
      policy_number       VARCHAR2 (50),
      clm_file_date       DATE,
      eff_date            DATE,
      loss_date           DATE,
      assd_name           giis_assured.assd_name%TYPE,
      loss_cat_category   VARCHAR2 (200),
      outstanding_loss    NUMBER (16, 2),
      share_type1         NUMBER (16, 2),
      share_type2         NUMBER (16, 2),
      share_type3         NUMBER (16, 2),
      share_type4         NUMBER (16, 2),
      company_name        VARCHAR2 (200),
      company_address     VARCHAR2 (200),
      date_as_of          VARCHAR2 (100),
      date_from           VARCHAR2 (100),
      date_to             VARCHAR2 (100),
      exist               VARCHAR2 (1)
   );

   TYPE giclr208a_tab IS TABLE OF giclr208a_type;

   FUNCTION get_giclr208a_report (
      p_session_id      NUMBER,
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr208a_tab PIPELINED;
      
	TYPE giclr208a_company_type IS RECORD(
		company_name		giis_parameters.param_value_v%TYPE,
      company_address	giis_parameters.param_value_v%TYPE,
		date_as_of			VARCHAR2(100),
      date_from			VARCHAR2(100),
      date_to				VARCHAR2(100)
	);
	
	TYPE giclr208a_company_tab IS TABLE OF giclr208a_company_type;
	
	FUNCTION get_giclr208a_company_details(
		p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
	) RETURN giclr208a_company_tab PIPELINED;
END;
/


