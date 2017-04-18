CREATE OR REPLACE PACKAGE CPI.Giis_Intermediary_Pkg AS

/********************************** FUNCTION 1 ************************************/

  TYPE intm_list_type IS RECORD 
    (intm_no        GIIS_INTERMEDIARY.intm_no%TYPE,
     intm_name      GIIS_INTERMEDIARY.intm_name%TYPE,
     active_tag        GIIS_INTERMEDIARY.active_tag%TYPE,
     ref_intm_cd    GIIS_INTERMEDIARY.ref_intm_cd%TYPE);
     
  TYPE intm_list_type2 IS RECORD
    (intm_no        GIIS_INTERMEDIARY.intm_no%TYPE,
     intm_name      GIIS_INTERMEDIARY.intm_name%TYPE);
  
  TYPE intm_list_tab IS TABLE OF intm_list_type;
  
  TYPE intm_list_tab2 IS TABLE OF intm_list_type2;
        
  FUNCTION get_intm_list RETURN intm_list_tab PIPELINED;
  
  FUNCTION get_intm_list2(p_keyword              VARCHAR2)
    RETURN intm_list_tab2 PIPELINED;
  
  
/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS085 
  RECORD GROUP NAME: CGFK$WCOMINV_DSP_INTM_NAME 
***********************************************************************************/

  TYPE intm_name1_list_type IS RECORD
    (intm_name        GIIS_INTERMEDIARY.intm_name%TYPE,
     parent_intm_no   GIIS_INTERMEDIARY.parent_intm_no%TYPE,
     parent_intm_name GIIS_INTERMEDIARY.intm_name%TYPE,
     intm_no          GIIS_INTERMEDIARY.intm_no%TYPE,
     wtax_rate          GIIS_INTERMEDIARY.wtax_rate%TYPE,
     intm_type          GIIS_INTERMEDIARY.intm_type%TYPE, 
     ref_intm_cd       GIIS_INTERMEDIARY.ref_intm_cd%TYPE,
     active_tag          GIIS_INTERMEDIARY.active_tag%TYPE,
     parent_intm_lic_tag GIIS_INTERMEDIARY.lic_tag%type,
     parent_intm_special_rate GIIS_INTERMEDIARY.special_rate%type,
     share_percentage gipi_comm_invoice.share_percentage%TYPE,
     lic_tag          GIIS_INTERMEDIARY.lic_tag%TYPE, --added by christian 08.25.2012
     special_rate      GIIS_INTERMEDIARY.special_rate%TYPE); --added by christian 08.25.2012
       
  TYPE intm_name1_list_tab IS TABLE OF intm_name1_list_type; 
        
  FUNCTION get_intm_name1_list(p_assd_no   GIIS_ASSURED_INTM.assd_no%TYPE,
                                    p_line_cd   GIIS_ASSURED_INTM.line_cd%TYPE,
                               p_keyword   VARCHAR2)
    RETURN intm_name1_list_tab PIPELINED;
    
  FUNCTION get_intm_name1_list_renewal(
      p_keyword VARCHAR2,
     p_par_id  GIPI_WPOLBAS.par_id%TYPE, --benjo 09.07.2016 SR-5604
     p_assd_no GIIS_ASSURED_INTM.assd_no%TYPE, --benjo 09.07.2016 SR-5604
     p_line_cd GIIS_ASSURED_INTM.line_cd%TYPE --benjo 09.07.2016 SR-5604
  )
     RETURN intm_name1_list_tab PIPELINED;    
    

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS085 
  RECORD GROUP NAME: CGFK$WCOMINV_DSP_INTM_NAME3 
***********************************************************************************/
       
  FUNCTION get_intm_name2_list(p_assd_no   GIIS_ASSURED_INTM.assd_no%TYPE,
                                    p_line_cd   GIIS_ASSURED_INTM.line_cd%TYPE,
                               p_par_id    GIPI_WPOLBAS.par_id%TYPE,
                               p_keyword   VARCHAR2)
    RETURN intm_name1_list_tab PIPELINED; 
    

/********************************** FUNCTION 4 ************************************
  MODULE: GIPIS085 
  RECORD GROUP NAME: CGFK$WCOMINV_DSP_INTM_NAME5 
***********************************************************************************/
      
  FUNCTION get_intm_name3_list(p_keyword   VARCHAR2)
    RETURN intm_name1_list_tab PIPELINED;
  

/********************************** FUNCTION 5 ************************************
  MODULE: GIIMM02 
  RECORD GROUP NAME: LOV578  
***********************************************************************************/
      
  FUNCTION get_intm_name4_list RETURN intm_list_tab PIPELINED; 
  
/********************************** FUNCTION 5 koks************************************
     MODULE: GIPIS085
     BY: KOKS
***********************************************************************************/
    FUNCTION get_intm_name5_list(p_assd_no   GIIS_ASSURED_INTM.assd_no%TYPE,
                                    p_line_cd   GIIS_ASSURED_INTM.line_cd%TYPE,
                               p_par_id    GIPI_WPOLBAS.par_id%TYPE,
                               p_keyword   VARCHAR2)
    RETURN intm_name1_list_tab PIPELINED;     
  
  
 /********************************** FUNCTION 5************************************
  MODULE: GIAC001
  RECORD GROUP NAME: PAYOR RC 
  BY: TONIO
***********************************************************************************/  
  TYPE intm_payor_list_type IS RECORD
  (       intm_name          varchar2(3000),
         payor_type       varchar2(50),
       mail_addr1       GIIS_INTERMEDIARY.mail_addr1%TYPE,
       mail_addr2       GIIS_INTERMEDIARY.mail_addr2%TYPE,
       mail_addr3       GIIS_INTERMEDIARY.mail_addr3%TYPE,
       tin               GIIS_REINSURER.ri_tin%TYPE,--GIIS_INTERMEDIARY.tin%TYPE, --marco - 09.15.2014
       intm_no        GIIS_INTERMEDIARY.intm_no%TYPE,
       ref_intm_cd      GIIS_INTERMEDIARY.ref_intm_cd%TYPE,
       iss_cd          GIIS_INTERMEDIARY.iss_cd%TYPE,
       lic_tag          GIIS_INTERMEDIARY.lic_tag%TYPE
  );                    
  
  TYPE intm_payor_list_tab IS TABLE OF intm_payor_list_type;
  
  FUNCTION get_intm_payor_list(p_intm_name varchar2)
        RETURN intm_payor_list_tab PIPELINED;
      
  FUNCTION get_intm_payor_list2(p_intm_name     VARCHAR2,
                                p_ri_comm_tag   VARCHAR2)
        RETURN intm_payor_list_tab PIPELINED;            
    
  FUNCTION get_giis_intm_lov(p_keyword VARCHAR2)
      RETURN intm_payor_list_tab PIPELINED;  
    
 /********************************** FUNCTION 6************************************
  MODULE: GIAC001
  RECORD GROUP NAME: INTM_NO 
  BY: TONIO
***********************************************************************************/        
  FUNCTION get_all_intermediary_list
        RETURN intm_payor_list_tab PIPELINED;                                                                              

  /********************************** FUNCTION 6************************************
  MODULE: GIACS020
  RECORD GROUP NAME: INTM_NO 
  BY:  EMMAN
***********************************************************************************/
  TYPE comm_invoice_intm_list_type IS RECORD
    (intm_no        GIIS_INTERMEDIARY.intm_no%TYPE,
     intm_name      GIIS_INTERMEDIARY.intm_name%TYPE);
  
  TYPE comm_invoice_intm_list_tab IS TABLE OF comm_invoice_intm_list_type; 
  
  FUNCTION get_comm_invoice_intm_list(p_tran_type            GIAC_COMM_PAYTS.tran_type%TYPE,
                                           p_iss_cd                GIAC_COMM_PAYTS.iss_cd%TYPE,
                                      p_prem_seq_no            GIAC_COMM_PAYTS.prem_seq_no%TYPE,
                                      p_intm_name            GIIS_INTERMEDIARY.intm_name%TYPE)
      RETURN comm_invoice_intm_list_tab PIPELINED;
                                                      
  FUNCTION get_vat_rate (p_intm_no   GIIS_INTERMEDIARY.intm_no%TYPE)
      RETURN GIIS_INTERMEDIARY.input_vat_rate%TYPE;
      
  FUNCTION get_banca_intm_list(p_keyword              VARCHAR2,
                                    p_banc_type_cd          GIIS_BANC_TYPE_DTL.banc_type_cd%TYPE,
                               p_intm_type              GIIS_INTERMEDIARY.intm_type%TYPE)
    RETURN intm_list_tab2 PIPELINED;                                                              

    TYPE intm_type_noFormula_type     IS RECORD (
     v_returned_string     varchar2(200)
    );
    
  TYPE intm_type_noFormula_tab IS TABLE OF  intm_type_noFormula_type;     
  
     FUNCTION get_intm_type_noFormula (
                            p_intm_no     giis_intermediary.parent_intm_no%type)
      RETURN intm_type_noFormula_tab PIPELINED; 
        
  FUNCTION get_intm_no_GIPIR025(
    p_prem_seq_no   GIPI_COMM_INVOICE.prem_seq_no%TYPE,
    p_iss_cd        GIPI_COMM_INVOICE.iss_cd%TYPE
  ) RETURN VARCHAR2;
  
  
  /** Created by: Queenie C. Santos
  ** Comm_slip - get intm/agentname - 
  ** May 9, 2011
  **/
    FUNCTION get_intm_name_GIACR250(
    p_intm_no        giis_intermediary.intm_no%TYPE
  ) RETURN VARCHAR2;
  
   FUNCTION get_agent_cd (
           p_intm_no     giis_intermediary.parent_intm_no%type)
      RETURN VARCHAR2;
  
    PROCEDURE get_prem_warr_letter(
        p_claim_id          gicl_basic_intm_v1.claim_id%TYPE,
        p_assd_name         giis_assured.assd_name%TYPE,
        p_report_id         VARCHAR2,
        p_nbt_mail1     OUT VARCHAR2,
        p_nbt_mail2     OUT VARCHAR2,
        p_nbt_mail3     OUT VARCHAR2,
        p_nbt_attn      OUT VARCHAR2,
        p_msg_alert     OUT VARCHAR2
        );
        
    PROCEDURE validate_purge_intm_no(
        p_intm_no       IN      GIIS_INTERMEDIARY.intm_no%TYPE,
        p_intm_name     OUT     GIIS_INTERMEDIARY.intm_name%TYPE
    );
    
    FUNCTION validate_intm_no_giexs006(
        p_intm_no       giis_intermediary.intm_no%TYPE
    )
    
    RETURN intm_list_tab2 PIPELINED;
    
    FUNCTION get_giacs180_intm_lov(
        p_intm_type     giis_intermediary.intm_type%TYPE
   ) RETURN intm_list_tab PIPELINED;
   
   FUNCTION get_giacs512_intm_lov 
        RETURN intm_list_tab PIPELINED;
   
   --added by : Kenneth L. 07.16.2013 :for giacs286
    FUNCTION get_giacs286_intm_lov
     RETURN intm_payor_list_tab PIPELINED;
     
    FUNCTION get_giacs153_intm_no_lov
       RETURN intm_list_tab2 PIPELINED;
       
    FUNCTION get_giacs288_intm_lov(
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_find_text     VARCHAR2
    )
      RETURN intm_payor_list_tab PIPELINED;
      
    FUNCTION get_gisms008_intm_lov(
      p_name   VARCHAR2
    )
      RETURN intm_list_tab2 PIPELINED;
   
   FUNCTION val_comm_rate ( --Apollo Cruz 09.25.2014
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_peril_cd     VARCHAR2,
      p_comm_rate    VARCHAR2
   )
      RETURN VARCHAR2; 
             
    --benjo 10.29.2015 for gipis901a
    TYPE gipis901a_intm_list_type IS RECORD
        (intm_no        giis_intermediary.intm_no%TYPE,
         intm_name      giis_intermediary.intm_name%TYPE,
         intm_type      giis_intm_type.intm_type%TYPE,
         intm_desc      giis_intm_type.intm_desc%TYPE);
      
    TYPE gipis901a_intm_list_tab IS TABLE OF gipis901a_intm_list_type;
    
    FUNCTION get_gipis901a_intm_lov(
        p_intm_type     VARCHAR2,
        p_intm_no       VARCHAR2
    )
      RETURN gipis901a_intm_list_tab PIPELINED;
    --benjo end
   
END Giis_Intermediary_Pkg;
/
