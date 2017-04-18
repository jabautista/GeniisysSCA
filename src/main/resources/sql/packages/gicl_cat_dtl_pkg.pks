CREATE OR REPLACE PACKAGE CPI.gicl_cat_dtl_pkg
AS
   TYPE gicl_cat_dtl_type IS RECORD (
      catastrophic_cd     gicl_cat_dtl.catastrophic_cd%TYPE,
      catastrophic_desc   gicl_cat_dtl.catastrophic_desc%TYPE,
      line_cd             gicl_cat_dtl.line_cd%TYPE,
      loss_cat_cd         gicl_cat_dtl.loss_cat_cd%TYPE,
      start_date          gicl_cat_dtl.start_date%TYPE,
      end_date            gicl_cat_dtl.end_date%TYPE,
      location            gicl_cat_dtl.LOCATION%TYPE,
      district_no         gicl_cat_dtl.district_no%TYPE,
      block_no            gicl_cat_dtl.block_no%TYPE,
      city_cd             gicl_cat_dtl.city_cd%TYPE,
      province_cd         gicl_cat_dtl.province_cd%TYPE,
      remarks             gicl_cat_dtl.remarks%TYPE
   );

   TYPE gicl_cat_dtl_tab IS TABLE OF gicl_cat_dtl_type;

   FUNCTION get_cat_dtls 
      RETURN gicl_cat_dtl_tab PIPELINED;
      
   FUNCTION get_cat_dtl_by_cat_cd
    (p_catastrophic_cd      GICL_CLAIMS.catastrophic_cd%TYPE,
     p_line_cd              GICL_CLAIMS.line_cd%TYPE) 
    RETURN gicl_cat_dtl_tab PIPELINED;
    
END gicl_cat_dtl_pkg;
/


