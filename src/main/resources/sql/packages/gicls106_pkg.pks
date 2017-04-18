CREATE OR REPLACE PACKAGE CPI.gicls106_pkg
AS
   TYPE rec_type IS RECORD (
      loss_tax_id     giis_loss_taxes.loss_tax_id%TYPE,
      tax_type        giis_loss_taxes.tax_type%TYPE,   
      branch_cd       giis_loss_taxes.branch_cd%TYPE,  
      tax_cd          giis_loss_taxes.tax_cd%TYPE,     
      tax_name        giis_loss_taxes.tax_name%TYPE,
      tax_rate        giis_loss_taxes.tax_rate%TYPE,
      start_date      giis_loss_taxes.start_date%TYPE,
      end_date        giis_loss_taxes.end_date%TYPE,
      remarks         giis_loss_taxes.remarks%TYPE,
      user_id         giis_loss_taxes.user_id%TYPE,
      last_update     VARCHAR2(30),
      gl_acct_id      giis_loss_taxes.gl_acct_id%TYPE,
      gl_acct_category giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct  giac_chart_of_accts.gl_control_acct%TYPE, 
      gl_sub_acct_1    giac_chart_of_accts.gl_sub_acct_1%TYPE,   
      gl_sub_acct_2    giac_chart_of_accts.gl_sub_acct_2%TYPE,   
      gl_sub_acct_3    giac_chart_of_accts.gl_sub_acct_3%TYPE,   
      gl_sub_acct_4    giac_chart_of_accts.gl_sub_acct_4%TYPE,   
      gl_sub_acct_5    giac_chart_of_accts.gl_sub_acct_5%TYPE,   
      gl_sub_acct_6    giac_chart_of_accts.gl_sub_acct_6%TYPE,  
      gl_sub_acct_7    giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE,
      
      sl_type_cd    giac_sl_types.sl_type_cd%TYPE,
      sl_type_name  giac_sl_types.sl_type_name%TYPE
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
       p_tax_cd     VARCHAR2,
       p_branch_cd  VARCHAR2
   )
      RETURN rec_tab PIPELINED;
   PROCEDURE set_rec (p_rec giis_loss_taxes%ROWTYPE);
   
   PROCEDURE del_rec (p_fund_cd    GIAC_DOC_SEQUENCE.fund_cd%TYPE, 
                    p_branch_cd  GIAC_DOC_SEQUENCE.branch_cd%TYPE,
                    p_doc_name   GIAC_DOC_SEQUENCE.doc_name%TYPE);

   FUNCTION val_del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION val_add_rec(
            p_fund_cd    GIAC_DOC_SEQUENCE.fund_cd%TYPE,          
            p_branch_cd  GIAC_DOC_SEQUENCE.branch_cd%TYPE,
            p_doc_name   GIAC_DOC_SEQUENCE.doc_name%TYPE
   )
   RETURN VARCHAR2;
   
   TYPE gicls106_tax_lov_type IS RECORD (
       rv_low_value   cg_ref_codes.rv_low_value%TYPE,
       rv_meaning     cg_ref_codes.rv_meaning%TYPE
   ); 

   TYPE gicls106_tax_lov_tab IS TABLE OF gicls106_tax_lov_type;
   
   FUNCTION get_gicls106_tax_lov(
        p_search VARCHAR2
   )
   RETURN gicls106_tax_lov_tab PIPELINED;
   
   TYPE gicls106_branch_lov_type IS RECORD (
       iss_cd     giis_issource.iss_cd%TYPE,
       iss_name   giis_issource.iss_name%TYPE
   ); 

   TYPE gicls106_branch_lov_tab IS TABLE OF gicls106_branch_lov_type;
   
   FUNCTION get_gicls106_branch_lov(
        p_search VARCHAR2,
        p_user   VARCHAR2
   )
   RETURN gicls106_branch_lov_tab PIPELINED;
   
   PROCEDURE validate_tax(
        p_tax_type   IN OUT VARCHAR2,
        p_tax_desc      OUT VARCHAR2
   );
    
   PROCEDURE validate_branch(
        p_branch   IN OUT VARCHAR2,
        p_branch_name OUT VARCHAR2,
        p_user     IN     VARCHAR2
   );
   
   TYPE tax_rate_history_type IS RECORD (
      tax_rate        giis_loss_taxes.tax_rate%TYPE,
      start_date      giis_loss_taxes.start_date%TYPE,
      end_date        giis_loss_taxes.end_date%TYPE,
      remarks         giis_loss_taxes.remarks%TYPE,
      user_id         giis_loss_taxes.user_id%TYPE,
      last_update     VARCHAR2(30)
   ); 

   TYPE tax_rate_history_tab IS TABLE OF tax_rate_history_type;
   
   FUNCTION get_tax_rate_history(
        p_loss_tax_id   VARCHAR2
   )
   RETURN tax_rate_history_tab PIPELINED;
   
   TYPE copy_tax_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   ); 

   TYPE copy_tax_tab IS TABLE OF copy_tax_type;
   
   FUNCTION get_copy_tax(
        p_iss_cd   VARCHAR2,
        p_user     VARCHAR2
   )
   RETURN copy_tax_tab PIPELINED;
   
   PROCEDURE copy_tax_to_issue_cd (p_rec giis_loss_taxes%ROWTYPE);
   
   PROCEDURE validate_loss_taxes(
        p_tax_cd   IN VARCHAR2,
        p_iss_cd   IN VARCHAR2,
        p_tax_type IN VARCHAR2,
        p_output  OUT VARCHAR2
   );
   
   TYPE line_loss_exp_type IS RECORD (
      line_cd        giis_loss_tax_line.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE,
      loss_exp_cd    giis_loss_tax_line.loss_exp_cd%TYPE,
      loss_exp_desc  giis_loss_exp.loss_exp_desc%TYPE,
      loss_exp_type  giis_loss_tax_line.loss_exp_type%TYPE,
      tax_rate       giis_loss_tax_line.tax_rate%TYPE,
      line           VARCHAR2(100),
      loss_exp       VARCHAR2(100)
   ); 

   TYPE line_loss_exp_tab IS TABLE OF line_loss_exp_type;
   
   FUNCTION line_loss_exp(
        p_iss_cd        VARCHAR2,
        p_loss_tax_id   VARCHAR2,
        p_user          VARCHAR2
   )
   RETURN line_loss_exp_tab PIPELINED;
   
   TYPE gicls106_line_lov_type IS RECORD (
       line_cd     giis_line.line_cd%TYPE,
       line_name   giis_line.line_name%TYPE
   ); 

   TYPE gicls106_line_lov_tab IS TABLE OF gicls106_line_lov_type;
   
   FUNCTION get_gicls106_line_lov(
        p_search VARCHAR2,
        p_user   VARCHAR2,
        p_iss_cd VARCHAR2
   )
   RETURN gicls106_line_lov_tab PIPELINED;
   
   PROCEDURE validate_line(
        p_line_cd   IN OUT VARCHAR2,
        p_line_name    OUT VARCHAR2,
        p_user      IN     VARCHAR2,
        p_iss_cd    IN     VARCHAR2
   );
   
   TYPE gicls106_loss_exp_lov_type IS RECORD (
       loss_exp_cd     giis_loss_exp.loss_exp_cd%TYPE,   
       loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE, 
       loss_exp_type   giis_loss_exp.loss_exp_type%TYPE 
   ); 

   TYPE gicls106_loss_exp_lov_tab IS TABLE OF gicls106_loss_exp_lov_type;
   
   FUNCTION get_gicls106_loss_exp_lov(
        p_line_cd     VARCHAR2,
        p_search VARCHAR2
   )
   RETURN gicls106_loss_exp_lov_tab PIPELINED;
   
   PROCEDURE validate_loss_exp(
        p_line_cd         IN     VARCHAR2,
        p_loss_exp_cd     IN OUT VARCHAR2,
        p_loss_exp_desc      OUT VARCHAR2,
        p_loss_exp_type      OUT VARCHAR2
   );
   
   PROCEDURE save_line_loss_exp (p_rec giis_loss_tax_line%ROWTYPE);
   
   FUNCTION val_line_loss_exp(
            p_loss_tax_id   giis_loss_tax_line.loss_tax_id%TYPE,         
            p_line_cd       giis_loss_tax_line.line_cd%TYPE,    
            p_loss_exp_cd   giis_loss_tax_line.loss_exp_cd%TYPE 
   )
   RETURN VARCHAR2;
   
   TYPE line_loss_exp_history_type IS RECORD (
      line_cd         giis_loss_tax_line_hist.line_cd%TYPE,
      loss_exp_cd     giis_loss_tax_line_hist.loss_exp_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE,
      tax_rate        giis_loss_taxes.tax_rate%TYPE,
      user_id         giis_loss_taxes.user_id%TYPE,
      last_update     VARCHAR2(30)
   ); 

   TYPE line_loss_exp_history_tab IS TABLE OF line_loss_exp_history_type;
   
   FUNCTION get_line_loss_exp_history(
        p_loss_tax_id   VARCHAR2,
        p_line_cd       VARCHAR2,
        p_loss_exp_cd   VARCHAR2
   )
   RETURN line_loss_exp_history_tab PIPELINED;
   
   PROCEDURE copy_tax_line_to_issue_cd (p_rec giis_loss_taxes%ROWTYPE, p_orig_iss_cd VARCHAR2);
   
   PROCEDURE populate_line_loss_exp_field(
        p_line_cd         IN     VARCHAR2,
        p_loss_exp_cd     IN     VARCHAR2,
        p_line_name          OUT VARCHAR2,
        p_loss_exp_desc      OUT VARCHAR2
   );
   
   PROCEDURE check_copy_tax_line_btn(
        p_loss_tax_id IN VARCHAR2,
        p_iss_cd      IN VARCHAR2,
        p_user        IN VARCHAR2,
        p_output     OUT VARCHAR2
   );
END;
/


