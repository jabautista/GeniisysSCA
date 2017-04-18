CREATE OR REPLACE PACKAGE CPI.GIEX_BUSINESS_CON_PKG AS
/******************************************************************************
   NAME:       GIEX_BUSINESS_CONSERVATION_PKG
   REPORT:     GIEXR109

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/7/2012    Bonok            Created this package.
******************************************************************************/

   /**GIEXR110**/ 
   TYPE giexr110_main_type IS RECORD (
      iss_cd            giis_issource.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      subline_cd        giis_subline.subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      year              giex_ren_ratio.year%TYPE,
      renew_prem        number,        
      new_prem          number,
      sum_nop           number,
      sum_nnp           number,
      sum_nrp           number,
      pct_differ        number,
      no_of_policy      number,
      pol_premium       number,
      lcd_pct_diff      number,
      lcd_pol_premium   number,
      icd_pct_differ    number,
      scd_pct_differ    number,
      min_lcd_pd        number,
      max_lcd_pd        number,
      line_pct_diff     number,
      iss_pct_diff      number,
      min_icd_pd        number,
      max_icd_pd        number,
      min_scd_pd        number,
      max_scd_pd        number
   );
   
   TYPE giexr110_main_tab IS TABLE OF giexr110_main_type;
   
   TYPE giexr110_header_type IS RECORD (
       company_name      varchar2(32767),
       company_address   varchar2(32767)
    );
    
   TYPE giexr110_header_tab IS TABLE OF giexr110_header_type;
   
   TYPE giexr110_recap_type IS RECORD (
       year                giex_ren_ratio.year%TYPE,
       iss_name            giis_issource.iss_name%TYPE,
       iss_cd              giis_issource.iss_cd%TYPE,
       sum_nop             number,
       sum_nrp             number,
       sum_nnp             number,
       pol_premium         number,
       renew_prem          number,
       pct_differ          number,
       min_year_pct        number,
       max_year_pct        number,
       iss_pct_diff        number,
       min_grand_pd        number,
       max_grand_pd        number,
       grand_pct_diff      number
   );
    
   TYPE giexr110_recap_tab IS TABLE OF giexr110_recap_type;
    
   TYPE giexr110_grand_total_type IS RECORD (
       year                giex_ren_ratio.year%TYPE,
       sum_nop             number,
       sum_nrp             number,
       sum_nnp             number,
       grand_pol_premium   number,
       grand_renew_prem    number,
       grand_pct_differ    number,
       min_grand_pd        number,
       max_grand_pd        number,
       grand_pct_diff      number
   );
    
   TYPE giexr110_grand_total_tab IS TABLE OF giexr110_grand_total_type;
   /**GIEXR110**/
   /**GIEXR109**/
    TYPE giexr109_main_type IS RECORD (
       line_name         giis_line.line_name%TYPE,
       line_cd           giis_line.line_cd%TYPE,
       iss_cd            giis_issource.iss_cd%TYPE,
       subline_cd        giis_subline.subline_cd%TYPE,
       subline_name      giis_subline.subline_name%TYPE,
       year              giex_ren_ratio.year%TYPE,
       iss_name          giis_issource.iss_name%TYPE,
       no_of_policy      number,
       no_of_renewed     number,
       no_of_new         number,
       pct_renew         number,
       pct_diff          number,
       pct_renew_diff    number,
       sum_nop           number,
       sum_nrp           number,
       sum_nnp           number,
       g_sum_nop         number,
       g_sum_nrp         number,
       g_sum_nnp         number,
       pct_renew_avg     number,
       lcd_pct_diff      number,
       min_lcd_pd        number,
       max_lcd_pd        number,
       icd_pct_diff      number,
       min_isd_pd        number,
       max_isd_pd        number,
       isd_pct_diff      number,
       scd_pct_diff      number
    );
    
    TYPE giexr109_main_tab IS TABLE OF giexr109_main_type;
    
    TYPE giexr109_header_type IS RECORD (
       company_name      varchar2(32767),
       company_address   varchar2(32767)
    );
    
    TYPE giexr109_header_tab IS TABLE OF giexr109_header_type;
    
    TYPE giexr109_recap_type IS RECORD (
        iss_name            giis_issource.iss_name%TYPE,
        iss_cd              giis_issource.iss_cd%TYPE,
        year                giex_ren_ratio.year%TYPE,
        sum_nop             number,
        sum_nrp             number,
        sum_nnp             number,
        min_year_pct        number,
        max_year_pct        number,
        sum_pct_renew       number,
        g_min_year_pct      number,
        g_max_year_pct      number,
        g_sum_pct_renew     number
    );
    
    TYPE giexr109_recap_tab IS TABLE OF giexr109_recap_type;
    
    TYPE giexr109_grand_total_type IS RECORD (
        year                giex_ren_ratio.year%TYPE,
        sum_nop             number,
        sum_nrp             number,
        sum_nnp             number,
        grand_pct_renew     number,
        grand_pct_diff      number,
        min_year_pct        number,
        max_year_pct        number
    );
    
    TYPE giexr109_grand_total_tab IS TABLE OF giexr109_grand_total_type;
    /**GIEXR109**/
    /**GIEXR110**/
    FUNCTION populate_giexr110_main(
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE
    )
       RETURN giexr110_main_tab PIPELINED;
       
    FUNCTION populate_giexr110_header
    
       RETURN giexr110_header_tab PIPELINED;
    
    FUNCTION populate_giexr110_recap (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE
    )
       RETURN giexr110_recap_tab PIPELINED;
       
    FUNCTION populate_giexr110_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE
    )
       RETURN giexr110_grand_total_tab PIPELINED;
   
    /**GIEXR110**/
    /**GIEXR109**/
    FUNCTION populate_giexr109_main(
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE
    )
       RETURN giexr109_main_tab PIPELINED;
       
    FUNCTION populate_giexr109_header
    
       RETURN giexr109_header_tab PIPELINED;
       
    FUNCTION populate_giexr109_recap(
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE
    )
       RETURN giexr109_recap_tab PIPELINED;
       
    FUNCTION populate_giexr109_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE
    )
       RETURN giexr109_grand_total_tab PIPELINED;
    /**GIEXR109**/
       
 END GIEX_BUSINESS_CON_PKG;
/


