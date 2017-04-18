CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Bond_Basic_Pkg AS

  TYPE gipi_quote_bond_basic_type IS RECORD
    (quote_id                GIPI_QUOTE_BOND_BASIC.quote_id%TYPE,
	 obligee_no        	  	 GIPI_QUOTE_BOND_BASIC.obligee_no%TYPE,
	 obligee_name			 GIIS_OBLIGEE.obligee_name%TYPE,
	 bond_dtl				 GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
	 indemnity_text			 GIPI_QUOTE_BOND_BASIC.indemnity_text%TYPE,
	 coll_flag				 GIPI_QUOTE_BOND_BASIC.coll_flag%TYPE,
	 contract_dtl			 GIPI_QUOTE_BOND_BASIC.contract_dtl%TYPE,
	 prin_id				 GIPI_QUOTE_BOND_BASIC.prin_id%TYPE,
	 prin_signor			 GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
	 designation			 GIIS_PRIN_SIGNTRY.designation%TYPE,	 	 
	 co_prin_sw				 GIPI_QUOTE_BOND_BASIC.co_prin_sw%TYPE,       
	 clause_type			 GIPI_QUOTE_BOND_BASIC.clause_type%TYPE,
	 clause_desc			 GIIS_BOND_CLASS_CLAUSE.clause_desc%TYPE,
	 np_no					 GIPI_QUOTE_BOND_BASIC.np_no%TYPE,
	 np_name				 GIIS_NOTARY_PUBLIC.np_name%TYPE,         
	 waiver_limit			 GIPI_QUOTE_BOND_BASIC.waiver_limit%TYPE,
	 incept_date			 GIPI_QUOTE.incept_date%TYPE);  							   	
							   
  TYPE gipi_quote_bond_basic_tab IS TABLE OF gipi_quote_bond_basic_type;

  TYPE gipi_quote_bond_basic_type2 IS RECORD(
    quote_id                GIPI_QUOTE_BOND_BASIC.quote_id%TYPE,
    obligee_no              GIPI_QUOTE_BOND_BASIC.obligee_no%TYPE,
    prin_id                 GIPI_QUOTE_BOND_BASIC.prin_id%TYPE,
    val_period_unit         GIPI_QUOTE_BOND_BASIC.val_period_unit%TYPE,
    val_period              GIPI_QUOTE_BOND_BASIC.val_period%TYPE,
    coll_flag               GIPI_QUOTE_BOND_BASIC.coll_flag%TYPE,
    clause_type             GIPI_QUOTE_BOND_BASIC.clause_type%TYPE,
    np_no                   GIPI_QUOTE_BOND_BASIC.np_no%TYPE,
    contract_dtl            GIPI_QUOTE_BOND_BASIC.contract_dtl%TYPE,
    contract_date           GIPI_QUOTE_BOND_BASIC.contract_date%TYPE,
    co_prin_sw              GIPI_QUOTE_BOND_BASIC.co_prin_sw%TYPE,
    waiver_limit            GIPI_QUOTE_BOND_BASIC.waiver_limit%TYPE,
    indemnity_text          GIPI_QUOTE_BOND_BASIC.indemnity_text%TYPE,
    bond_dtl                GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
    endt_eff_date           GIPI_QUOTE_BOND_BASIC.endt_eff_date%TYPE,
    remarks                 GIPI_QUOTE_BOND_BASIC.remarks%TYPE
    );
    
  TYPE gipi_quote_bond_basic_tab2 IS TABLE OF gipi_quote_bond_basic_type2;

  FUNCTION get_gipi_quote_bond_basic (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_bond_basic_tab PIPELINED;
	

  PROCEDURE set_gipi_quote_bond_basic (
  	 v_quote_id              IN  GIPI_QUOTE_BOND_BASIC.quote_id%TYPE,
	 v_obligee_no        	 IN  GIPI_QUOTE_BOND_BASIC.obligee_no%TYPE,
	 v_bond_dtl				 IN  GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
	 v_indemnity_text		 IN  GIPI_QUOTE_BOND_BASIC.indemnity_text%TYPE,
	 v_coll_flag			 IN  GIPI_QUOTE_BOND_BASIC.coll_flag%TYPE,
	 v_contract_dtl			 IN  GIPI_QUOTE_BOND_BASIC.contract_dtl%TYPE,
	 v_prin_id				 IN  GIPI_QUOTE_BOND_BASIC.prin_id%TYPE, 
	 v_co_prin_sw			 IN  GIPI_QUOTE_BOND_BASIC.co_prin_sw%TYPE,       
	 v_clause_type			 IN  GIPI_QUOTE_BOND_BASIC.clause_type%TYPE,
	 v_np_no				 IN  GIPI_QUOTE_BOND_BASIC.np_no%TYPE,       
	 v_waiver_limit			 IN  GIPI_QUOTE_BOND_BASIC.waiver_limit%TYPE,
	 v_contract_date		 IN  GIPI_QUOTE_BOND_BASIC.contract_date%TYPE);	

								 
  PROCEDURE del_gipi_quote_bond_basic (p_quote_id       GIPI_QUOTE.quote_id%TYPE);

  FUNCTION get_gipi_quote_bond_basic2(p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_bond_basic_tab2 PIPELINED;
    
  PROCEDURE set_gipi_quote_bond_basic2 (
  	p_quote_id                GIPI_QUOTE_BOND_BASIC.quote_id%TYPE,
    p_obligee_no              GIPI_QUOTE_BOND_BASIC.obligee_no%TYPE,
    p_prin_id                 GIPI_QUOTE_BOND_BASIC.prin_id%TYPE,
    p_val_period_unit         GIPI_QUOTE_BOND_BASIC.val_period_unit%TYPE,
    p_val_period              GIPI_QUOTE_BOND_BASIC.val_period%TYPE,
    p_coll_flag               GIPI_QUOTE_BOND_BASIC.coll_flag%TYPE,
    p_clause_type             GIPI_QUOTE_BOND_BASIC.clause_type%TYPE,
    p_np_no                   GIPI_QUOTE_BOND_BASIC.np_no%TYPE,
    p_contract_dtl            GIPI_QUOTE_BOND_BASIC.contract_dtl%TYPE,
    p_contract_date           GIPI_QUOTE_BOND_BASIC.contract_date%TYPE,
    p_co_prin_sw              GIPI_QUOTE_BOND_BASIC.co_prin_sw%TYPE,
    p_waiver_limit            GIPI_QUOTE_BOND_BASIC.waiver_limit%TYPE,
    p_indemnity_text          GIPI_QUOTE_BOND_BASIC.indemnity_text%TYPE,
    p_bond_dtl                GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
    p_endt_eff_date           GIPI_QUOTE_BOND_BASIC.endt_eff_date%TYPE,
    p_remarks                 GIPI_QUOTE_BOND_BASIC.remarks%TYPE
    );    
END Gipi_Quote_Bond_Basic_Pkg;
/


