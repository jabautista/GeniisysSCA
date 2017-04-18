DROP PROCEDURE CPI.CHECK_ENDT_PERIL;

CREATE OR REPLACE PROCEDURE CPI.CHECK_ENDT_PERIL(p_par_id            IN     GIPI_WITMPERL.par_id%TYPE,
                                                 p_item_no           IN     GIPI_WITMPERL.item_no%TYPE,
                                                 p_line_cd           IN     GIPI_WITMPERL.line_cd%TYPE,
                                                 p_subline_cd        IN     GIPI_WITMPERL.line_cd%TYPE,
                                                 p_peril_cd          IN     GIPI_WITMPERL.peril_cd%TYPE,
                                                 p_message           IN OUT VARCHAR2,
                                                 p_validation_flag   IN OUT VARCHAR2)
/*
**  Created by	    : Menandro G.C. Robes
**  Date Created 	: May 14, 2010
**  Reference By 	: (GIPIS097 - Endorsement Item Peril Information)
**  Description 	: Validates the peril to be added.
*/                                              
IS

  v_peril_wc_exists     VARCHAR2(1);
  v_deductible_level    NUMBER(1);
  v_with_grouped_peril  VARCHAR2(1);
  v_col_separator       VARCHAR2(1) := '@';
  v_row_separator       VARCHAR2(2) := '##';  

BEGIN   
  p_message := '0' || v_col_separator || 'SUCCESS';
  /**
  ** 1 = Peril has Warranties and Clauses
  ** 2 = Par item has deductible.
  ** 3 = Par has deductible.
  ** 4 = Peril has deductible.
  ** 5 = Has grouped peril.
  **/
  
  v_peril_wc_exists  := GIPI_WPOLWC_PKG.endt_peril_wc_exists(p_par_id, p_line_cd, p_peril_cd);
  v_deductible_level := GIPI_WDEDUCTIBLES_PKG.GET_DEDUCTIBLE_LEVEL(p_par_id, p_line_cd, p_subline_cd, p_item_no, p_peril_cd);
  v_with_grouped_peril := GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_exist(p_par_id, p_item_no);
  
  IF v_peril_wc_exists = 'Y' THEN
    p_message := p_message || v_row_separator;   
    p_message := p_message || '1' || v_col_separator || 'Peril has an attached warranties and clauses, would you like to use these as your default values on warranties and clauses?';    
  END IF;
    
  IF v_deductible_level = 3 THEN
    p_message := p_message || v_row_separator;
    p_message := p_message || '2' || v_col_separator || 'The peril has existing deductible based on % of TSI. Changing TSI will recompute the existing deductible amount. Continue?';    --Gzelle 08172015 SR4851    
  ELSIF v_deductible_level = 2 THEN
    p_message := p_message || v_row_separator;
    p_message := p_message || '3' || v_col_separator || 'The item has existing deductible based on % of TSI. Changing TSI will recompute the existing deductible amount. Continue?';    --Gzelle 08172015 SR4851
  ELSIF v_deductible_level = 1 THEN
    p_message := p_message || v_row_separator;
    p_message := p_message || '4' || v_col_separator || 'The PAR has an existing deductible based on % of TSI. Changing TSI will recompute the existing deductible amount. Continue?';    --Gzelle 08172015 SR4851   
  END IF;
  
  IF v_with_grouped_peril = 'Y' THEN
    p_message := p_message || v_row_separator;   
    p_message := p_message || '5' || v_col_separator || 'There are existing grouped item perils and you cannot modify, add or delete perils in current item.';      
  END IF;
      
END CHECK_ENDT_PERIL;
/


