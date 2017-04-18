CREATE OR REPLACE PACKAGE CPI.GIIS_DEDUCTIBLE_DESC_PKG AS

  TYPE ded_deductible_list_type IS RECORD
    (deductible_cd       VARCHAR2(100),
     deductible_title    GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
     ded_type            GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
     ded_type_desc       CG_REF_CODES.rv_meaning%TYPE,
     deductible_rt       GIIS_DEDUCTIBLE_DESC.deductible_rt%TYPE,
     deductible_amt      GIIS_DEDUCTIBLE_DESC.deductible_amt%TYPE,
     deductible_text     GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
     min_amt             GIIS_DEDUCTIBLE_DESC.min_amt%TYPE,
     max_amt             GIIS_DEDUCTIBLE_DESC.max_amt%TYPE,
     range_sw            GIIS_DEDUCTIBLE_DESC.range_sw%TYPE); 
  
  TYPE ded_deductible_list_tab IS TABLE OF ded_deductible_list_type;
  
  FUNCTION get_ded_deductible_list(p_line_cd         GIIS_LINE.line_cd%TYPE, 
                                   p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE) 
    RETURN ded_deductible_list_tab PIPELINED;
    
  FUNCTION get_ded_deductible_list2(p_line_cd       GIIS_LINE.line_cd%TYPE, 
                                   p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE,
                                   p_find_text      VARCHAR2) 
    RETURN ded_deductible_list_tab PIPELINED;    
    
  FUNCTION get_quote_deductible_list(p_line_cd       GIIS_LINE.line_cd%TYPE,
                                     p_subline_cd     GIIS_SUBLINE.subline_cd%TYPE,
                                     p_find_text      VARCHAR2) 
    RETURN ded_deductible_list_tab PIPELINED;

  /* start - Gzelle 08272015 SR4851*/    
  FUNCTION get_all_t_type_ded(
    p_line_cd        giis_line.line_cd%TYPE, 
    p_subline_cd     giis_subline.subline_cd%TYPE,
    p_ded_type       giis_deductible_desc.ded_type%TYPE
  )
    RETURN ded_deductible_list_tab PIPELINED;    
  /* end - Gzelle 08272015 SR4851*/      
  
END GIIS_DEDUCTIBLE_DESC_PKG;
/


