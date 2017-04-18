CREATE OR REPLACE PACKAGE CPI.giiss090_pkg
AS
   TYPE rec_type IS RECORD (
      report_id                 giis_reports.report_id%TYPE,
      report_title              giis_reports.report_title%TYPE,
      line_cd                   giis_reports.line_cd%TYPE,
      subline_cd                giis_reports.subline_cd%TYPE,
      report_type               giis_reports.report_type%TYPE,
      report_desc               giis_reports.report_desc%TYPE,
      destype                   giis_reports.destype%TYPE,
      desname                   giis_reports.desname%TYPE,
      desformat                 giis_reports.desformat%TYPE,
      paramform                 giis_reports.paramform%TYPE,
      copies                    giis_reports.report_title%TYPE,
      report_mode               giis_reports.report_mode%TYPE,
      orientation               giis_reports.orientation%TYPE,
      background                giis_reports.background%TYPE,
      generation_frequency      giis_reports.generation_frequency%TYPE,
      eis_tag                   giis_reports.eis_tag%TYPE,
      doc_type                  giis_reports.doc_type%TYPE,
      module_tag                giis_reports.module_tag%TYPE,
      document_tag              giis_reports.document_tag%TYPE,
      version                   giis_reports.version%TYPE,
      bir_tag                   giis_reports.bir_tag%TYPE,
      bir_form_type             giis_reports.bir_form_type%TYPE,
      bir_freq_tag              giis_reports.bir_freq_tag%TYPE,
      pagesize                  giis_reports.pagesize%TYPE,
      add_source                giis_reports.add_source%TYPE,
      bir_with_report           giis_reports.bir_with_report%TYPE,
      disable_file_sw           giis_reports.disable_file_sw%TYPE,
      csv_file_sw               giis_reports.csv_file_sw%TYPE,
      remarks                   giis_reports.remarks%TYPE,
      user_id                   giis_reports.user_id%TYPE,
      last_update               VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   FUNCTION get_rec_list (
      p_report_id     giis_reports.report_id%TYPE,
      p_report_title  giis_reports.report_title%TYPE
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_reports%ROWTYPE, p_prev_line_cd VARCHAR2); --added p_prev_line_cd for proper updating; John Daniel 04.08.2016

   PROCEDURE del_rec (p_report_id giis_reports.report_id%TYPE);

   PROCEDURE val_del_rec (p_report_id giis_reports.report_id%TYPE);
   
   PROCEDURE val_add_rec (
      p_report_id       giis_reports.report_id%TYPE,
      p_line_cd giis_reports.line_cd%TYPE --John Daniel 04.08.2016; replaced: p_report_title giis_reports.report_title%TYPE
   ); 
   
   
   -- for GIIS_REPORT_AGING
   TYPE rec_aging_type IS RECORD(
      report_id         giis_report_aging.report_id%TYPE,
      branch_cd         giis_report_aging.branch_cd%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      column_no         giis_report_aging.column_no%TYPE,
      column_title      giis_report_aging.column_title%TYPE,
      min_days          giis_report_aging.min_days%TYPE,
      max_days          giis_report_aging.max_days%TYPE,
      user_id           giis_report_aging.user_id%TYPE,
      last_update       VARCHAR2(30)
   );
   
   TYPE rec_aging_tab IS TABLE OF rec_aging_type;
   
   FUNCTION get_rec_aging_list(
      p_report_id       giis_report_aging.reporT_id%TYPE,
      p_user_id         VARCHAR2
   ) RETURN rec_aging_tab PIPELINED;
   
   PROCEDURE set_rec_aging (p_rec giis_report_aging%ROWTYPE);

--   PROCEDURE del_rec_aging (p_report_id giis_report_aging.report_id%TYPE);
    PROCEDURE del_rec_aging (p_rec giis_report_aging%ROWTYPE);
    
    PROCEDURE val_add_rec_aging (
        p_report_id giis_report_aging.report_id%TYPE,
        p_branch_cd giis_report_aging.branch_cd%TYPE,
        p_column_no giis_report_aging.column_no%TYPE
    );
    
    PROCEDURE val_del_rec_aging (p_report_id giis_reports.report_id%TYPE);
   
END;
/


