CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_MC_PKG AS

  TYPE quote_mc_type IS RECORD
   (accept_date             varchar2(50),
    assd_name            GIIS_ASSURED.assd_name%TYPE,
    assd_add1            varchar2(50),
    assd_add2            varchar2(50),
    assd_add3            varchar2(50),
    attn_name            varchar2(200),
    attn_position        varchar2(200),
    currency            giis_currency.short_name%TYPE,
    deductible            NUMBER(16,2),
    designation            varchar2(200),
    end_remarks            varchar2(50),
    expiry                varchar2(50),
    expiry_tag            GIPI_QUOTE.expiry_tag%TYPE,
    footer                  gipi_quote.footer%TYPE,
    HEADER                GIPI_QUOTE.HEADER%TYPE,
    incept                varchar2(50),
    incept_tag            GIPI_QUOTE.incept_tag%TYPE,
    iss_cd                GIPI_QUOTE.iss_cd%TYPE,
    line_cd                GIPI_QUOTE.line_cd%TYPE,
    --logo_file            GIIS_PARAMETERS.param_name%TYPE, -- andrew - 01.13.2011 - commented this line replaced with the line below
    logo_file            GIIS_PARAMETERS.param_value_v%TYPE,
    net_due_seici        NUMBER(16,2),
    prem_amt            NUMBER(16,2),
    prem_amt_seici        NUMBER(16,2),
    quote_num            VARCHAR2(50),
    remarks                GIPI_QUOTE.remarks%TYPE,
    short_name            GIIS_CURRENCY.short_name%TYPE,
    signatory            VARCHAR2(50),
    subline_name        GIIS_SUBLINE.subline_name%TYPE,
    tax_amt                NUMBER(16,2),
    title                varchar2(50),
    title7                varchar2(50),
    today                 VARCHAR2(20),
    tot_prem            NUMBER(16,2),
    tsi_amt_seici        NUMBER(16,2)
    );

  TYPE quote_mc_tab IS TABLE OF quote_mc_type;
  
  FUNCTION get_mc_quote(p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                             p_attn_name        VARCHAR2,
                        p_attn_position    VARCHAR2,
                        p_signatory        VARCHAR2,
                        p_designation    VARCHAR2) 
    RETURN quote_mc_tab PIPELINED;
 
  TYPE quote_mc_item_type IS RECORD
   (item_title            GIPI_QUOTE_WC.wc_title%TYPE,
    item_title_make        GIPI_QUOTE_WC.wc_title%TYPE,
    item_no                GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    row_num                NUMBER(4),
    plate_no            gipi_quote_item_mc.plate_no%TYPE, 
    serial_no            gipi_quote_item_mc.serial_no%TYPE, 
    motor_no            gipi_quote_item_mc.motor_no%TYPE, -- modified by Kris 07.02.2014 for MAC SR 16047: changed serial_no to motor_no
    color                gipi_quote_item_mc.color%TYPE,
    make                VARCHAR2(50),
    car_company            giis_mc_car_company.car_company%TYPE,
    model_year            gipi_quote_item_mc.model_year%TYPE,
    motor_type_desc        giis_motortype.motor_type_desc%TYPE,
    subline_type_desc    giis_mc_subline_type.SUBLINE_TYPE_DESC%TYPE,
    ded_amt                gipi_quote_deductibles.deductible_amt%TYPE,
    towing                gipi_quote_item_mc.towing%TYPE,
    repair_limit        NUMBER(22,2),
    coverage_desc        giis_coverage.coverage_desc%TYPE,
    itemperil_exists    VARCHAR2(1)
    );
    
  TYPE quote_mc_item_tab IS TABLE OF quote_mc_item_type;
  
  TYPE quote_mc_itemperil_type IS RECORD
   (item_no                VARCHAR2(20),
    peril_name            giis_peril.PERIL_NAME%TYPE,
    peril_lname            giis_peril.PERIL_LNAME%TYPE,
    prem_amt            gipi_quote_itmperil.prem_amt%TYPE,
    tsi_amt                gipi_quote_itmperil.tsi_amt%TYPE,
    short_name            giis_currency.short_name%TYPE);
   
  TYPE quote_mc_itemperil_tab IS TABLE OF quote_mc_itemperil_type;
  
  TYPE quote_mc_itmperil_ucpb_type IS RECORD
   (item_no                gipi_quote_item.item_no%TYPE,
    peril_name             giis_peril.PERIL_LNAME%TYPE,
    prem_amt               gipi_quote_itmperil.prem_amt%TYPE,
    opt1_prem              gipi_quote_itmperil.prem_amt%TYPE,
    tsi_amt                gipi_quote_itmperil.tsi_amt%TYPE,
    short_name             giis_currency.short_name%TYPE); 
   
  TYPE quote_mc_itmperil_ucpb_tab IS TABLE OF quote_mc_itmperil_ucpb_type;
  
  TYPE quote_mc_invtax_ucpb_type IS RECORD
   (tax_amt               gipi_quote_invtax.tax_amt%TYPE,
    opt1_tax              gipi_quote_invtax.tax_amt%TYPE,
	currency_rate  		  gipi_quote_item.currency_rate%TYPE, --added by steven 1.24.2013
	the_same  	 		  VARCHAR2(1));
    
  TYPE quote_mc_invtax_ucpb_tab IS TABLE OF quote_mc_invtax_ucpb_type;  

  FUNCTION get_mc_invtax_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                               p_item_no         GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_invtax_ucpb_tab PIPELINED;
  
  
  FUNCTION get_mc_quote_item(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_mc_item_tab PIPELINED;
    
  FUNCTION get_mc_quote_itemperil(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_mc_itemperil_tab PIPELINED;
    
  FUNCTION get_mc_quote_itemperil(p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                       p_item_no            GIPI_QUOTE_ITMPERIL.item_no%TYPE)
    RETURN quote_mc_itemperil_tab PIPELINED;
    
  FUNCTION get_mc_quote_itemperil_seici(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_mc_itemperil_tab PIPELINED;
 
  TYPE quote_wc_type IS RECORD
   (wc_title            GIPI_QUOTE_WC.wc_title%TYPE,
    wc_text                VARCHAR2(4000),
    row_num                NUMBER(4));
    
  TYPE quote_wc_tab IS TABLE OF quote_wc_type;
  
  FUNCTION get_quote_wc(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_wc_tab PIPELINED;
    
  TYPE quote_invtax_type IS RECORD
   (tax_cd                gipi_quote_invtax.tax_cd%TYPE,
    tax_desc            giis_tax_charges.tax_desc%TYPE,
    tax_amt                gipi_quote_invtax.tax_amt%TYPE);

  TYPE quote_invtax_tab IS TABLE OF quote_invtax_type;
  
  FUNCTION get_mc_quote_invtax(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_invtax_tab PIPELINED;
    
  FUNCTION get_mc_quote_invtax_seici(p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                     p_iss_cd        GIPI_QUOTE.iss_cd%TYPE)
    RETURN quote_invtax_tab PIPELINED;
    
  TYPE quote_deductibles_type IS RECORD
   (deductible_text        gipi_quote_deductibles.deductible_text%TYPE,
    deductible_amt        gipi_quote_deductibles.deductible_amt%TYPE);
    
  TYPE quote_deductibles_tab IS TABLE OF quote_deductibles_type;
  
  FUNCTION get_mc_quote_deductibles(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_deductibles_tab PIPELINED;
    
  TYPE mc_quote_signatory_type IS RECORD(   ------------------------------------------gino                      
    sig_name                giis_signatory_names.signatory%TYPE,   
    sig_des                 giis_signatory_names.designation%TYPE                                                          
  );                                                              
  
  TYPE mc_quote_signatory_tab IS TABLE OF mc_quote_signatory_type;  

  FUNCTION get_mc_quote_signatory(p_line_cd VARCHAR2, p_iss_cd VARCHAR2)
  RETURN mc_quote_signatory_tab PIPELINED;------------------------------------------end gino
  
  FUNCTION get_mc_quote_itemperil_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                        p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_itmperil_ucpb_tab PIPELINED;
    
  TYPE quote_mc_kalakbay_ucpb_type IS RECORD(                         
    peril_name                giis_peril.peril_lname%TYPE,   
    comp_rem                  gipi_itmperil.comp_rem%TYPE                                                          
  );                                                              
 
  TYPE quote_mc_kalakbay_ucpb_tab IS TABLE OF quote_mc_kalakbay_ucpb_type; 
  
  TYPE quote_mc_autopa_ucpb_type IS RECORD(                         
    peril_name                giis_peril.peril_lname%TYPE,   
    tsi_per_pass              VARCHAR2(20), --* Revised by Windell ON May 17, 2011; Changed from VARCHAR2(50),
    tsi_med_exp               VARCHAR2(20), --* Revised by Windell ON May 17, 2011; Changed from VARCHAR2(50),
    no_of_pass                VARCHAR2(10)  --* Added by Windell ON May 17, 2011                                                            
  );                                                              
 
  TYPE quote_mc_autopa_ucpb_tab IS TABLE OF quote_mc_autopa_ucpb_type; 
  
  FUNCTION get_mc_quote_kalakbay_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                       p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_kalakbay_ucpb_tab PIPELINED;
    
  FUNCTION get_mc_quote_autopa_ucpb (p_quote_id        GIPI_QUOTE.quote_id%TYPE,
                                     p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN quote_mc_autopa_ucpb_tab PIPELINED;  
   
END QUOTE_REPORTS_MC_PKG;
/


