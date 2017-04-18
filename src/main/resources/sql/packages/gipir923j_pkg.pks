CREATE OR REPLACE PACKAGE CPI.GIPIR923J_PKG AS
    TYPE gipir923j_type IS RECORD(
         dist_flag              VARCHAR2(32767),
         line_cd                gipi_uwreports_ext.line_cd%TYPE,
         subline_cd             gipi_uwreports_ext.subline_cd%TYPE,
         iss_cd                 gipi_uwreports_ext.iss_cd%TYPE, 
         iss_cd_header          VARCHAR2(32767),
         issue_yy               gipi_uwreports_ext.issue_yy%TYPE,
         pol_seq_no             gipi_uwreports_ext.pol_seq_no%TYPE,
         renew_no               gipi_uwreports_ext.renew_no%TYPE,
         endt_iss_cd            gipi_uwreports_ext.endt_iss_cd%TYPE,
         endt_yy                gipi_uwreports_ext.endt_yy%TYPE,
         endt_seq_no            gipi_uwreports_ext.endt_seq_no%TYPE,
         issue_date             gipi_uwreports_ext.issue_date%TYPE,
         incept_date            gipi_uwreports_ext.incept_date%TYPE,
         expiry_date            gipi_uwreports_ext.expiry_date%TYPE,
         total_tsi              gipi_uwreports_ext.total_tsi%TYPE,
         total_prem             gipi_uwreports_ext.total_prem%TYPE,
         evatprem               gipi_uwreports_ext.evatprem%type,
         lgt                    gipi_uwreports_ext.lgt%TYPE,
         doc_stamps             gipi_uwreports_ext.doc_stamps%TYPE,
         fst                    gipi_uwreports_ext.fst%TYPE,
         other_taxes            gipi_uwreports_ext.other_taxes%TYPE,
         total_charges          number,
         total_taxes            VARCHAR2(32767),
         param_date             gipi_uwreports_ext.param_date%TYPE,
         from_date              gipi_uwreports_ext.from_date%TYPE,
         to_date                gipi_uwreports_ext.to_date%TYPE,
         scope                  gipi_uwreports_ext.scope%TYPE,
         user_id                gipi_uwreports_ext.user_id%TYPE,
         policy_id              gipi_uwreports_ext.policy_id%TYPE,
         assd_no                gipi_uwreports_ext.assd_no%TYPE,
         spld_date              VARCHAR2(32767),
         cf_iss_name            VARCHAR2(32767),
         cf_iss_title           VARCHAR2(32767),
         cf_line_name           VARCHAR2 (20),
         cf_subline_name        VARCHAR2 (40),
         cf_assd_name           VARCHAR2 (500),
         cf_policy_no           VARCHAR (200)          
         );
     TYPE gipir923j_tab IS TABLE of gipir923j_type;
     
     TYPE header_type IS RECORD (
         cf_company                 VARCHAR2 (150),
         cf_company_address         VARCHAR2 (500),
         cf_heading3                VARCHAR2 (150),
         cf_based_on                VARCHAR2 (100),
         cf_spoiled                 NUMBER,
         cf_1                       NUMBER,
         cf_count_undistributed     NUMBER,
         cf_total_undistributed     NUMBER,
         cf_count_distributed       NUMBER,
         cf_total_distributed       NUMBER,
         cf_total_prem              NUMBER
         
    );
    TYPE header_tab IS TABLE of header_type;
  
    FUNCTION populate_gipir923j(
        p_line_cd        gipi_uwreports_ext.line_cd%TYPE,
        p_scope          gipi_uwreports_ext.scope%TYPE,
        p_iss_cd         gipi_uwreports_ext.iss_cd%TYPE,
        p_subline_cd     gipi_uwreports_ext.subline_cd%TYPE,
        --p_from_date      gipi_uwreports_ext.from_date%TYPE,
        --p_to_date        gipi_uwreports_ext.to_date%TYPE,
        p_iss_param      gipi_uwreports_ext.iss_cd%TYPE,
        p_user_id        gipi_uwreports_ext.user_id%TYPE
    )
      RETURN gipir923j_tab PIPELINED; 
       
    FUNCTION get_header_gipir923j (
        p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,    
        p_scope        gipi_uwreports_ext.SCOPE%TYPE,
        p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
        -- p_from_date    DATE,         
        --p_to_date      DATE       
    )
      RETURN header_tab PIPELINED;  
     
    FUNCTION cf_companyformula
      RETURN CHAR;
      
    FUNCTION cf_company_addressformula
      RETURN CHAR;
      
    FUNCTION cf_based_onformula (
      p_scope           gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id         gipi_uwreports_ext.user_id%TYPE
    )
      RETURN CHAR;
      
    FUNCTION cf_heading3formula(
        p_user_id       gipi_uwreports_ext.user_id%TYPE
    )
      RETURN CHAR;
       
    FUNCTION cf_spoiledformula 
      RETURN NUMBER;
      
    FUNCTION cf_iss_nameformula(
        p_iss_cd giis_issource.iss_cd%TYPE
    )
     RETURN CHAR;
     
    FUNCTION cf_iss_titleformula(
        p_iss_param   gipi_uwreports_ext.iss_cd%TYPE
   )
      RETURN CHAR;
      
    FUNCTION cf_line_nameformula(p_line_cd giis_line.line_cd%TYPE)
      RETURN CHAR;
      
    FUNCTION cf_subline_nameformula(
        p_subline_cd   giis_subline.subline_cd%TYPE,
        p_line_cd      giis_subline.line_cd%TYPE
    )
      RETURN CHAR;
      
    FUNCTION cf_assd_nameformula (p_assd_no giis_assured.assd_no%TYPE)
      RETURN CHAR;
      
    FUNCTION cf_policy_noformula (
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_issue_yy      gipi_uwreports_ext.issue_yy%TYPE,
        p_pol_seq_no    gipi_uwreports_ext.pol_seq_no%TYPE,
        p_renew_no      gipi_uwreports_ext.renew_no%TYPE,
        p_endt_seq_no   gipi_uwreports_ext.endt_seq_no%TYPE,
        p_endt_iss_cd   gipi_uwreports_ext.endt_iss_cd%TYPE,
        p_endt_yy       gipi_uwreports_ext.endt_yy%TYPE,
        p_policy_id     gipi_uwreports_ext.policy_id%TYPE
    )
      RETURN CHAR;
      
    FUNCTION cf_1formula 
      RETURN NUMBER;

    FUNCTION cf_count_undistributedformula (
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
        p_scope         gipi_uwreports_ext.scope%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE
    )
      RETURN NUMBER;
      
    FUNCTION cf_undistributed_totalFormula(
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
        p_scope         gipi_uwreports_ext.scope%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013
    ) 
      RETURN NUMBER;
      
    FUNCTION cf_count_distributedFormula(
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
        p_scope         gipi_uwreports_ext.scope%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE
        --p_from_date     DATE,         
        --p_to_date       DATE
    ) 
      RETURN NUMBER;
      
    FUNCTION cf_distributed_totalFormula(
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
        p_scope         gipi_uwreports_ext.scope%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE
    ) 
      RETURN NUMBER; 
      
END;
/


