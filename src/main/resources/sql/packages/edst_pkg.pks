CREATE OR REPLACE PACKAGE CPI.EDST_PKG
AS  
    TYPE edst_rec_type 
    IS
        RECORD  (
                 line_cd         gipi_polbasic.line_cd%TYPE,
                 tin             giis_assured.assd_tin%TYPE,
                 assd_no         giis_assured.assd_no%TYPE,
                 branch          gipi_uwreports_ext.iss_cd%TYPE,
                 branch_tin_cd   giis_issource.branch_tin_cd%TYPE,
                 no_tin          giis_assured.no_tin_reason%TYPE,
                 reason          giis_assured.no_tin_reason%TYPE,
                 company         giis_assured.assd_name%TYPE,
                 first_name      giis_assured.first_name%TYPE,
                 middle_initial  giis_assured.middle_initial%TYPE,
                 last_name       giis_assured.last_name%TYPE,
                 tax_base        edst_ext.total_prem%TYPE,
                 tsi_amt         edst_ext.total_tsi%TYPE,
                 company_name    VARCHAR2(500),
                 company_address VARCHAR2(500),
                 v_flag          VARCHAR(2)
        );
    
    TYPE edst_type IS TABLE OF edst_rec_type;
    
    FUNCTION edst (p_scope           edst_param.SCOPE%TYPE,
                   p_from_date       VARCHAR2,--edst_param.FROM_DATE%TYPE,
                   p_to_date         VARCHAR2,--edst_EXT.TO_DATE1%TYPE,
                   p_negative_amt    VARCHAR2,
                   p_ctpl_pol        NUMBER,
                   p_inc_spo         VARCHAR2,
                   p_user_id         edst_param.user_id%TYPE,
                   p_line_cd         VARCHAR2,
                   p_subline_cd      VARCHAR2,
                   p_iss_cd          VARCHAR2,
                   p_iss_param       NUMBER)
      RETURN edst_type
      PIPELINED;
      
    FUNCTION get_comp_name
    
      RETURN VARCHAR;
 
    FUNCTION get_comp_address 
    
      RETURN VARCHAR2 ;
END;
/


