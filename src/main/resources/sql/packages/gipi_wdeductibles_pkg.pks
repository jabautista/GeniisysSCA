CREATE OR REPLACE PACKAGE CPI.Gipi_Wdeductibles_Pkg AS

  TYPE gipi_wdeductibles_type IS RECORD
    (par_id                GIPI_WDEDUCTIBLES.par_id%TYPE,
     item_no            GIPI_WDEDUCTIBLES.item_no%TYPE,
     item_title            GIPI_WITEM.item_title%TYPE,
     peril_cd            GIPI_WDEDUCTIBLES.peril_cd%TYPE,
      peril_name            GIIS_PERIL.peril_name%TYPE,
     ded_line_cd        GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
     ded_subline_cd        GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE,
     aggregate_sw        GIPI_WDEDUCTIBLES.aggregate_sw%TYPE,
     ceiling_sw            GIPI_WDEDUCTIBLES.ceiling_sw%TYPE,
     ded_deductible_cd  VARCHAR2(100),
     deductible_title   GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
     deductible_rt        GIPI_WDEDUCTIBLES.deductible_rt%TYPE,
     deductible_amt        GIPI_WDEDUCTIBLES.deductible_amt%TYPE,
     deductible_text    GIPI_WDEDUCTIBLES.deductible_text%TYPE,
     min_amt            GIPI_WDEDUCTIBLES.min_amt%TYPE,
     max_amt            GIPI_WDEDUCTIBLES.max_amt%TYPE,
     range_sw            GIPI_WDEDUCTIBLES.range_sw%TYPE,
     ded_type            GIIS_DEDUCTIBLE_DESC.ded_type%TYPE);
     
     
  TYPE gipi_wdeductibles_tab IS TABLE OF gipi_wdeductibles_type;
  
  FUNCTION get_gipi_wdeductibles_policy (p_par_id  GIPI_WDEDUCTIBLES.par_id%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED;

  FUNCTION get_gipi_wdeductibles_item (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED;
    
  FUNCTION get_gipi_wdeductibles_peril (p_par_id   GIPI_WDEDUCTIBLES.par_id%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED; 
  
  Procedure set_gipi_wdeductibles (p_wdeductible   GIPI_WDEDUCTIBLES%ROWTYPE);
  
  
  Procedure del_gipi_wdeductibles (p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE,
                                     p_item_no    GIPI_WDEDUCTIBLES.item_no%TYPE,
                                   p_peril_cd    GIPI_WDEDUCTIBLES.peril_cd%TYPE);
                                   
  Procedure del_gipi_wdeductibles_policy (p_par_id  GIPI_WDEDUCTIBLES.par_id%TYPE);
  
  /* emman 060210
     * Procedure DEL_POL_DED ON GIPIS060
    */
  Procedure del_gipi_wdeductibles_policy_2 (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_line_cd          GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
           p_subline_cd      GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE);
  
  Procedure del_gipi_wdeductibles_item (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE);
                                        
  Procedure del_gipi_wdeductibles_peril (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE);
    
  FUNCTION CHECK_GIPI_WDEDUCTIBLES_ITEMS(
                                                  p_par_id              GIPI_WDEDUCTIBLES.par_id%TYPE,
                                                p_line_cd             GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                        p_nbt_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE) 
    RETURN VARCHAR;    
    
  FUNCTION GET_GIPI_WDEDUCTIBLES_ITEMS2(
                                                  p_par_id              GIPI_WDEDUCTIBLES.par_id%TYPE,
                                                p_line_cd             GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                        p_nbt_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE) 
    RETURN gipi_wdeductibles_tab PIPELINED;
  
  Procedure del_gipi_wdeductibles_peril (p_par_id          GIPI_WDEDUCTIBLES.par_id%TYPE,
                                           p_line_cd          GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                         p_nbt_subline_cd GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE);

    Procedure del_gipi_wdeductibles_item_1 (    
        p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no        GIPI_WDEDUCTIBLES.item_no%TYPE,
        p_line_cd        GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
        p_subline_cd    GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE);
    
    Procedure del_gipi_wdeductibles_item_2 (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no    GIPI_WDEDUCTIBLES.item_no%TYPE);    
        
  FUNCTION get_deductible_level(p_par_id          GIPI_WDEDUCTIBLES.par_id%TYPE,
                                     p_line_cd         GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                p_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE,
                                p_item_no       GIPI_WDEDUCTIBLES.item_no%TYPE,
                                p_peril_cd      GIPI_WDEDUCTIBLES.peril_cd%TYPE) 
  RETURN NUMBER;
  
    Procedure del_gipi_wdeductibles (p_par_id IN GIPI_WDEDUCTIBLES.par_id%TYPE);
    
  Procedure del_gipi_wdeductibles_2(
                                     p_par_id              GIPI_WDEDUCTIBLES.par_id%TYPE,
                                        p_line_cd             GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                   p_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE);

  Procedure del_gipi_wdeductible_peril(p_par_id   GIPI_WDEDUCTIBLES.par_id%TYPE,
                                       p_item_no  GIPI_WDEDUCTIBLES.item_no%TYPE,
                                       p_peril_cd GIPI_WDEDUCTIBLES.peril_cd%TYPE);

    Procedure del_gipi_wdeductible (
        p_par_id    IN GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no    IN GIPI_WDEDUCTIBLES.item_no%TYPE,
        p_ded_cd    IN GIPI_WDEDUCTIBLES.ded_deductible_cd%TYPE);
              
  PROCEDURE del_gipi_wdeductible2 (p_par_id          GIPI_WDEDUCTIBLES.par_id%TYPE,
                                   p_item_no         GIPI_WDEDUCTIBLES.item_no%TYPE,
                                   p_peril_cd        GIPI_WDEDUCTIBLES.peril_cd%TYPE,
                                   p_deductible_cd   GIPI_WDEDUCTIBLES.ded_deductible_cd%TYPE,
                                   p_line_cd         GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                   p_subline_cd      GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE);        

    FUNCTION get_gipi_wdeductibles_pack_pol (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_item_no IN gipi_wdeductibles.item_no%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED;
    
    FUNCTION get_gipi_wdeductibles_policy1 (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_ded_title IN VARCHAR2,
        p_ded_text IN VARCHAR2)
    RETURN gipi_wdeductibles_tab PIPELINED;
    
    FUNCTION get_gipi_wdeductibles_item1 (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_item_no IN gipi_wdeductibles.item_no%TYPE,
        p_ded_title IN VARCHAR2,
        p_ded_text IN VARCHAR2)
    RETURN gipi_wdeductibles_tab PIPELINED;
    
    FUNCTION get_gipi_wdeductibles_peril (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_item_no IN gipi_wdeductibles.item_no%TYPE,
        p_peril_cd IN gipi_wdeductibles.peril_cd%TYPE,
        p_ded_title IN VARCHAR2,
        p_ded_text IN VARCHAR2)
    RETURN gipi_wdeductibles_tab PIPELINED;
    
    FUNCTION get_all_gipi_wdeductibles (
        p_par_id IN gipi_wdeductibles.par_id%TYPE)    
    RETURN gipi_wdeductibles_tab PIPELINED;
END Gipi_Wdeductibles_Pkg;
/


