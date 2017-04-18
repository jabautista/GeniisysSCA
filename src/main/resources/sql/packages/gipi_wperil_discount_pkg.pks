CREATE OR REPLACE PACKAGE CPI.Gipi_Wperil_Discount_Pkg
AS
    TYPE gipi_Wperil_discount_type IS RECORD
    (par_id                      GIPI_WPERIL_DISCOUNT.par_id%TYPE,                                    
     line_cd                  GIPI_WPERIL_DISCOUNT.line_cd%TYPE,
     item_no                  GIPI_WPERIL_DISCOUNT.item_no%TYPE,
     peril_cd                  GIPI_WPERIL_DISCOUNT.peril_cd%TYPE,
     subline_cd                  GIPI_WPERIL_DISCOUNT.subline_cd%TYPE,
     disc_rt                  GIPI_WPERIL_DISCOUNT.disc_rt%TYPE,
     level_tag                  GIPI_WPERIL_DISCOUNT.level_tag%TYPE,
     disc_amt                  GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
     net_gross_tag              GIPI_WPERIL_DISCOUNT.net_gross_tag%TYPE,
     discount_tag              GIPI_WPERIL_DISCOUNT.discount_tag%TYPE,
     orig_peril_prem_amt      GIPI_WPERIL_DISCOUNT.orig_peril_prem_amt%TYPE,
     SEQUENCE                  GIPI_WPERIL_DISCOUNT.SEQUENCE%TYPE,
     remarks                  GIPI_WPERIL_DISCOUNT.remarks%TYPE,
     net_prem_amt              GIPI_WPERIL_DISCOUNT.net_prem_amt%TYPE,
     orig_peril_ann_prem_amt  GIPI_WPERIL_DISCOUNT.orig_peril_ann_prem_amt%TYPE,
     orig_item_ann_prem_amt   GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE,
     orig_pol_ann_prem_amt      GIPI_WPERIL_DISCOUNT.orig_pol_ann_prem_amt%TYPE,
     surcharge_rt              GIPI_WPERIL_DISCOUNT.surcharge_rt%TYPE,
     surcharge_amt              GIPI_WPERIL_DISCOUNT.surcharge_amt%TYPE,
     peril_name                  GIIS_PERIL.peril_name%TYPE
     );

    TYPE gipi_wperil_discount_tab IS TABLE OF gipi_wperil_discount_type;

    FUNCTION get_gipi_wperil_discount (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE)
    RETURN gipi_wperil_discount_tab PIPELINED;
    
    FUNCTION get_gipi_wperil_discount1 (p_par_id IN GIPI_WPERIL_DISCOUNT.par_id%TYPE)
    RETURN gipi_wperil_discount_tab PIPELINED;
    
    PROCEDURE set_gipi_wperil_discount (p_wperil_disc IN GIPI_WPERIL_DISCOUNT%ROWTYPE);
    
    PROCEDURE del_gipi_wperil_discount (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE);
    
    PROCEDURE del_gipi_wperil_discount_1 (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE,
        p_item_no    GIPI_WPERIL_DISCOUNT.item_no%TYPE);
        
    PROCEDURE del_gipi_wperil_discount_2 (p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE);    
    
    PROCEDURE get_peril_discount(p_b240_par_id     IN     GIPI_PARLIST.par_id%TYPE
                                  ,p_b480_item_no  IN     GIPI_WITEM.item_no%TYPE
                                ,p_B480_prem_amt IN  GIPI_WITEM.prem_amt%TYPE
                                ,p_b490_peril_cd IN     GIPI_WITMPERL.peril_cd%TYPE
                                ,p_B490_prem_amt IN     GIPI_WITMPERL.prem_amt%TYPE
                                ,p_b490_ri_comm_rate IN GIPI_WITMPERL.ri_comm_rate%TYPE
                                ,p_B480_prem_amt2 OUT GIPI_WITEM.prem_amt%TYPE
                                ,p_B490_prem_amt2 OUT GIPI_WITMPERL.prem_amt%TYPE
                                ,p_B490_discount_sw OUT GIPI_WITMPERL.discount_sw%TYPE
                                ,p_B490_ri_comm_amt OUT GIPI_WITMPERL.ri_comm_amt%TYPE
                                ,p_B490_ann_prem_amt OUT GIPI_WITMPERL.ann_prem_amt%TYPE);
                                 
    FUNCTION get_orig_item_ann_prem_amt(p_par_id         GIPI_WPERIL_DISCOUNT.par_id%TYPE
                                         ,p_item_no         GIPI_WPERIL_DISCOUNT.item_no%TYPE)
      RETURN GIPI_WPERIL_DISCOUNT.orig_item_ann_prem_amt%TYPE;
      
    FUNCTION check_if_discount_exists(p_par_id     GIPI_WPERIL_DISCOUNT.par_id%TYPE)
      RETURN VARCHAR2;
      
    FUNCTION get_peril_sum_discount(p_par_id   GIPI_WITMPERL.par_id%TYPE,
                                    p_item_no  GIPI_WITMPERL.item_no%TYPE,
                                    p_peril_cd GIPI_WITMPERL.peril_cd%TYPE)
      RETURN NUMBER;
                                
END Gipi_Wperil_Discount_Pkg;
/


