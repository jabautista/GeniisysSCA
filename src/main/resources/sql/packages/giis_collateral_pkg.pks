CREATE OR REPLACE PACKAGE CPI.GIIS_COLLATERAL_PKG AS

/******************************************************************************
Created By; RManald    2.15.2011

******************************************************************************/
  TYPE collateral_type IS RECORD ( 
    coll_type           GIIS_COLL_BONDS.coll_type%TYPE,
    coll_desc           GIIS_COLL_BONDS.collateral_desc%TYPE,
    coll_value          GIIS_COLL_BONDS.collateral_val%TYPE,
    rev_date            varchar2(50),
    coll_id             GIIS_COLL_BONDS.collateral_id%TYPE
    --rev_date            GIIS_COLL_DTL.rev_date%TYPE
    );
    
  TYPE collateral_tab IS TABLE OF collateral_type; 
  
  FUNCTION get_collateral_dtl (p_par_id GIPI_COLL_PAR.par_id%TYPE)
    RETURN  collateral_tab PIPELINED;
  
  TYPE lov_coll_type IS RECORD(
    coll_type           GIIS_COLLATERAL_TYPE.coll_type%TYPE,
    coll_name           GIIS_COLLATERAL_TYPE.coll_name%TYPE
    );
    
  TYPE lov_coll_tab IS TABLE OF lov_coll_type;
  
  FUNCTION get_lov_coll_type
    RETURN lov_coll_tab PIPELINED;  
  
  TYPE lov_coll2_type IS RECORD(
    coll_type           GIIS_COLL_BONDS.coll_type%TYPE,
    coll_desc           GIIS_COLL_BONDS.collateral_desc%TYPE,
    coll_val            GIIS_COLL_BONDS.collateral_val%TYPE,
    rev_date            varchar2(50),
    coll_id             GIIS_COLL_BONDS.collateral_id%TYPE
    );
  TYPE lov_coll2_tab IS TABLE OF lov_coll2_type;
  
  FUNCTION get_lov_coll_desc(p_coll_type giis_coll_bonds.coll_type%TYPE)
    RETURN lov_coll2_tab PIPELINED; 
  
END;
/


