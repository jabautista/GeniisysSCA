CREATE OR REPLACE PACKAGE CPI.GIPI_WENGG_ITEM_PKG AS
/******************************************************************************
   NAME:       GIPI_WENGG_ITEM_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/19/2010             1. Created this package.
******************************************************************************/

    TYPE gipi_wengineering_type IS RECORD (
         par_id                  GIPI_WITEM.par_id%TYPE,
         item_no                 GIPI_WITEM.item_no%TYPE,
         item_title              GIPI_WITEM.item_title%TYPE,
         item_grp                GIPI_WITEM.item_grp%TYPE,
         item_desc               GIPI_WITEM.item_desc%TYPE,
         item_desc2              GIPI_WITEM.item_desc2%TYPE,
         tsi_amt                 GIPI_WITEM.tsi_amt%TYPE,
         prem_amt                GIPI_WITEM.prem_amt%TYPE,
         ann_prem_amt            GIPI_WITEM.ann_prem_amt%TYPE,
         ann_tsi_amt             GIPI_WITEM.ann_tsi_amt%TYPE,
         rec_flag                GIPI_WITEM.rec_flag%TYPE,
         currency_cd             GIPI_WITEM.currency_cd%TYPE,
         currency_rt             GIPI_WITEM.currency_rt%TYPE,
         group_cd                GIPI_WITEM.group_cd%TYPE,
         from_date               GIPI_WITEM.from_date%TYPE,
         TO_DATE                 GIPI_WITEM.TO_DATE%TYPE,
         pack_line_cd            GIPI_WITEM.pack_line_cd%TYPE,
         pack_subline_cd         GIPI_WITEM.pack_subline_cd%TYPE,
         discount_sw             GIPI_WITEM.discount_sw%TYPE,
         coverage_cd             GIPI_WITEM.coverage_cd%TYPE,
		 other_info 			 GIPI_WITEM.other_info%TYPE,
		 surcharge_sw 			 GIPI_WITEM.surcharge_sw%TYPE,
		 region_cd 				 GIPI_WITEM.region_cd%TYPE,
		 changed_tag 			 GIPI_WITEM.changed_tag%TYPE,
		 prorate_flag 			 GIPI_WITEM.prorate_flag%TYPE,
		 comp_sw 				 GIPI_WITEM.comp_sw%TYPE,
		 short_rt_percent 		 GIPI_WITEM.short_rt_percent%TYPE,
		 pack_ben_cd 			 GIPI_WITEM.pack_ben_cd%TYPE,
		 payt_terms 			 GIPI_WITEM.payt_terms%TYPE,
		 risk_no 				 GIPI_WITEM.risk_no%TYPE,
		 risk_item_no 			 GIPI_WITEM.risk_item_no%TYPE,
         currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
         itmperl_grouped_exists VARCHAR2(1)
    );
    
    TYPE gipi_wengineering_tab IS TABLE OF gipi_wengineering_type;

    FUNCTION get_gipi_wengg_item (p_par_id GIPI_WITEM.par_id%TYPE)
        RETURN gipi_wengineering_tab PIPELINED;
  
END GIPI_WENGG_ITEM_PKG;
/


