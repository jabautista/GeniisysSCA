CREATE OR REPLACE PACKAGE CPI.GIPIR924B_PKG AS
/******************************************************************************
   NAME:       GIPIR924B_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/09/2012  Rodel         
******************************************************************************/
    TYPE header_type IS RECORD (
        cf_company           VARCHAR2 (150),
        cf_company_address   VARCHAR2 (500),
        cf_heading3          VARCHAR2 (150),
        cf_based_on          VARCHAR2 (100)
    );

    TYPE header_tab IS TABLE OF header_type;

    TYPE report_type IS RECORD (
        line_cd                     gipi_uwreports_intm_ext.line_cd%TYPE,
        line_name                   gipi_uwreports_intm_ext.line_name%TYPE,
        subline_cd                  gipi_uwreports_intm_ext.subline_cd%TYPE,
        subline_name                gipi_uwreports_intm_ext.subline_name%TYPE,
        iss_cd                      VARCHAR2 (10),
        total_tsi                   gipi_uwreports_intm_ext.total_tsi%TYPE,
        total_prem                  gipi_uwreports_intm_ext.total_prem%TYPE,
        evatprem                    gipi_uwreports_intm_ext.evatprem%TYPE,
        lgt                         gipi_uwreports_intm_ext.lgt%TYPE,
        doc_stamps                  gipi_uwreports_intm_ext.doc_stamps%TYPE,
        fst                         gipi_uwreports_intm_ext.fst%TYPE,
        other_taxes                 gipi_uwreports_intm_ext.other_taxes%TYPE, 
        other_charges               gipi_uwreports_intm_ext.other_charges%TYPE,
        param_date                  gipi_uwreports_intm_ext.param_date%TYPE,
        from_date                   gipi_uwreports_intm_ext.from_date%TYPE,
        to_date                     gipi_uwreports_intm_ext.to_date%TYPE,
        scope                       gipi_uwreports_intm_ext.scope%TYPE,
        user_id                     gipi_uwreports_intm_ext.user_id%TYPE,
        intm_no                     gipi_uwreports_intm_ext.intm_no%TYPE,
        intm_name                   gipi_uwreports_intm_ext.intm_name%TYPE,
        total                       NUMBER,  
        polcount                    NUMBER,
        commission                  NUMBER,
        intm_type                   gipi_uwreports_intm_ext.intm_type%TYPE,
        prem_share_amt              NUMBER,       
        iss_name                    VARCHAR2 (50),
        intm_desc                   VARCHAR2 (50),
        
        total_polcount_intm         NUMBER,
        total_polcount_branch       NUMBER,
        total_polcount_grand        NUMBER,
        
        total_intm_tsi              NUMBER,
        total_branch_tsi            NUMBER,
        total_grand_tsi             NUMBER,
        
        total_intm_prem             NUMBER,
        total_branch_prem           NUMBER,
        total_grand_prem            NUMBER,
        
        total_intm_evatprem         NUMBER,
        total_branch_evatprem       NUMBER,
        total_grand_evatprem        NUMBER,
        
        total_intm_lgt              NUMBER,
        total_branch_lgt            NUMBER,
        total_grand_lgt             NUMBER,
        
        total_intm_doc              NUMBER,
        total_branch_doc            NUMBER,
        total_grand_doc             NUMBER,
        
        total_intm_fst              NUMBER,
        total_branch_fst            NUMBER,
        total_grand_fst             NUMBER,
        
        total_intm_other            NUMBER,
        total_branch_other          NUMBER,
        total_grand_other           NUMBER,
        
        total_intm_amtdue           NUMBER,
        total_branch_amtdue         NUMBER,
        total_grand_amtdue          NUMBER,
       -- added by jhing 08.22.2015 FGICWEB SR# 17728
      total_intm_prem_shr     NUMBER,
      total_branch_prem_shr   NUMBER,
      total_grand_prem_shr    NUMBER     
      -- end of added columns by jhing 08.22.2015 
    );

    TYPE report_tab IS TABLE OF report_type;
    
    TYPE intmTotal_type IS RECORD (
        total_polcount          NUMBER,
        total_tsi               gipi_uwreports_intm_ext.total_tsi%TYPE,
        total_prem              gipi_uwreports_intm_ext.total_prem%TYPE
    );
    
    TYPE intmTotal_tab IS TABLE OF intmTotal_type;
    
       -- added by Jhing 08.22.2015 FGICWEB 17728
TYPE intm_type_totals_rec
   IS record (
           intm_type giis_intermediary.intm_type%TYPE
           , branch_cd giis_issource.iss_cd%TYPE
           , total_intm_tsi NUMBER
           , total_intm_prem NUMBER 
           , total_intm_evatprem NUMBER 
           , total_intm_lgt NUMBER 
           , total_intm_doc NUMBER
           , total_intm_fst NUMBER
           , total_intm_other NUMBER
           , total_intm_amtdue NUMBER
           , total_intm_prem_share_amt NUMBER
           , total_intm_comm_amt NUMBER
           , total_intm_policy_cnt NUMBER 
   );
   
   TYPE intm_type_totals_tab is TABLE OF intm_type_totals_rec ;    
   
   TYPE branch_totals_rec
       IS record (
                 branch_cd giis_issource.iss_cd%TYPE
               , total_branch_tsi NUMBER
               , total_branch_prem NUMBER 
               , total_branch_evatprem NUMBER 
               , total_branch_lgt NUMBER 
               , total_branch_doc NUMBER
               , total_branch_fst NUMBER
               , total_branch_other NUMBER
               , total_branch_amtdue NUMBER
               , total_branch_prem_share_amt NUMBER
               , total_branch_comm_amt NUMBER
               , total_branch_policy_cnt NUMBER 
       );
   
   TYPE branch_totals_tab is TABLE OF branch_totals_rec ;      
    
    FUNCTION get_header_gipir924b (
        p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE,
        p_user_id   gipi_uwreports_intm_ext.user_id%TYPE
    )
        RETURN header_tab PIPELINED;
        
    FUNCTION cf_companyformula
        RETURN CHAR;
        
    FUNCTION cf_company_addressformula
        RETURN CHAR;
    
    FUNCTION cf_heading3formula (p_user_id gipi_uwreports_intm_ext.user_id%TYPE)
        RETURN CHAR;

    FUNCTION cf_based_onformula (
        p_user_id   gipi_uwreports_intm_ext.user_id%TYPE,
        p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE
    )
        RETURN CHAR;
        

    
    FUNCTION populate_gipir924b (
        p_intm_no           gipi_uwreports_intm_ext.intm_no%TYPE,
        p_assd_no           gipi_uwreports_intm_ext.assd_no%TYPE,
        p_scope             gipi_uwreports_intm_ext.scope%TYPE,
        p_subline_cd        gipi_uwreports_intm_ext.subline_cd%TYPE,
        p_line_cd           gipi_uwreports_intm_ext.line_cd%TYPE,
        p_iss_cd            gipi_uwreports_intm_ext.iss_cd%TYPE,
        p_iss_param         NUMBER,
        p_intm_type         gipi_uwreports_intm_ext.intm_type%TYPE,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE
    )
        RETURN report_tab PIPELINED;
        
    FUNCTION cf_iss_nameFormula (p_iss_cd giis_issource.iss_cd%TYPE)
        RETURN CHAR;
        
    FUNCTION cf_intm_descFormula (p_intm_type giis_intm_type.intm_type%TYPE)
        RETURN CHAR;
        
    FUNCTION cf_new_commissionFormula (
        p_intm_no           gipi_uwreports_intm_ext.intm_no%TYPE,
        p_intm_type         gipi_uwreports_intm_ext.intm_type%TYPE,
        p_iss_param         NUMBER,
        p_iss_cd            gipi_uwreports_intm_ext.iss_cd%TYPE,
        p_line_cd           gipi_uwreports_intm_ext.line_cd%TYPE,
        p_subline_cd        gipi_uwreports_intm_ext.subline_cd%TYPE,
        p_scope             gipi_uwreports_intm_ext.scope%TYPE,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE
    )
        RETURN NUMBER;
        
    FUNCTION cf_totals_per_groupFormula (
        p_intm_no           gipi_uwreports_intm_ext.intm_no%TYPE,
        p_assd_no           gipi_uwreports_intm_ext.assd_no%TYPE,
        p_scope             gipi_uwreports_intm_ext.scope%TYPE,
        p_subline_cd        gipi_uwreports_intm_ext.subline_cd%TYPE,
        p_line_cd           gipi_uwreports_intm_ext.line_cd%TYPE,
        p_iss_cd            gipi_uwreports_intm_ext.iss_cd%TYPE,
        p_iss_param         NUMBER,
        p_intm_type         gipi_uwreports_intm_ext.intm_type%TYPE,
        p_column_invoker    VARCHAR2,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE
    )
        RETURN NUMBER; 
    FUNCTION check_unique_policy(pol_id_i GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE,pol_id_j GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE) 
        RETURN CHAR;
                       
END GIPIR924B_PKG;
/
