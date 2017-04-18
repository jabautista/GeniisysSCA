CREATE OR REPLACE PACKAGE CPI.GIISS041_PKG
AS

   TYPE giis041_type IS RECORD(
      user_grp                   giis_user_grp_hdr.user_grp%TYPE,
      user_grp_desc              giis_user_grp_hdr.user_grp_desc%TYPE,
      user_id                    giis_user_grp_hdr.user_id%TYPE, 
      last_update                giis_user_grp_hdr.last_update%TYPE,
      remarks                    giis_user_grp_hdr.remarks%TYPE, 
      grp_iss_cd                 giis_user_grp_hdr.grp_iss_cd%TYPE,
      iss_name                   giis_issource.iss_name%TYPE,
      dsp_last_update            VARCHAR2(50)
   );       
   TYPE giiss041_tab IS TABLE OF giis041_type;
   
   TYPE user_grp_tran_type IS RECORD(
      user_grp                   giis_user_grp_tran.user_grp%TYPE,
      tran_cd                    giis_user_grp_tran.tran_cd%TYPE,
      tran_desc                  giis_transaction.tran_desc%TYPE,
      access_tag                 giis_user_grp_tran.access_tag%TYPE,
      inc_all_tag                VARCHAR2(1),
      remarks                    giis_user_grp_tran.remarks%TYPE,
      user_id                    giis_user_grp_tran.user_id%TYPE,
      last_update                giis_user_grp_tran.last_update%TYPE
   );
   TYPE user_grp_tran_tab IS TABLE OF user_grp_tran_type;
   
   TYPE user_grp_dtl_type IS RECORD(
      user_grp                   giis_user_grp_dtl.user_grp%TYPE,
      iss_cd                     giis_user_grp_dtl.iss_cd%TYPE,
      iss_name                   giis_issource.iss_name%TYPE,
      tran_cd                    giis_user_grp_dtl.tran_cd%TYPE
   );
   TYPE user_grp_dtl_tab IS TABLE OF user_grp_dtl_type;
   
   TYPE user_grp_line_type IS RECORD(
      user_grp                   giis_user_grp_line.user_grp%TYPE,
      tran_cd                    giis_user_grp_line.tran_cd%TYPE,
      iss_cd                     giis_user_grp_line.iss_cd%TYPE,
      line_cd                    giis_user_grp_line.line_cd%TYPE,
      line_name                  giis_line.line_name%TYPE,
      remarks                    giis_user_grp_line.remarks%TYPE,
      user_id                    giis_user_grp_line.user_id%TYPE,
      last_update                VARCHAR2(50)
   );
   TYPE user_grp_line_tab IS TABLE OF user_grp_line_type;
   
   TYPE modules_type IS RECORD(
      user_grp                   giis_user_grp_modules.user_grp%TYPE,
      tran_cd                    giis_user_grp_modules.tran_cd%TYPE,
      module_id                  giis_modules_tran.module_id%TYPE,
      module_desc                giis_modules.module_desc%TYPE,
      user_id                    giis_user_grp_modules.user_id%TYPE,
      last_update                VARCHAR2(50),
      remarks                    giis_user_grp_modules.remarks%TYPE,
      access_tag                 giis_user_grp_modules.access_tag%TYPE,
      access_tag_desc            cg_ref_codes.rv_meaning%TYPE,
      inc_tag                    VARCHAR2(1)
   );
   TYPE modules_tab IS TABLE OF modules_type;
   
   TYPE user_grp_type IS RECORD(
      user_grp                   giis_user_grp_hdr.user_grp%TYPE,
      user_grp_desc              giis_user_grp_hdr.user_grp_desc%TYPE
   );
   TYPE user_grp_tab IS TABLE OF user_grp_type;
   
   TYPE grp_iss_cd_type IS RECORD(
      iss_cd                     giis_issource.iss_cd%TYPE,
      iss_name                   giis_issource.iss_name%TYPE
   );
   TYPE grp_iss_cd_tab IS TABLE OF grp_iss_cd_type;
   
   TYPE tran_lov_type IS RECORD(
      tran_cd                    giis_transaction.tran_cd%TYPE,
      tran_desc                  giis_transaction.tran_desc%TYPE
   );
   TYPE tran_lov_tab IS TABLE OF tran_lov_type;
   
   TYPE line_lov_type IS RECORD(
      line_cd                    giis_line.line_cd%TYPE,
      line_name                  giis_line.line_name%TYPE
   );
   TYPE line_lov_tab IS TABLE OF line_lov_type;
   
   FUNCTION get_giiss041_rec_list(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_user_grp_desc            giis_user_grp_hdr.user_grp_desc%TYPE,
      p_iss_name                 giis_issource.iss_name%TYPE
   )
     RETURN giiss041_tab PIPELINED;
     
   FUNCTION get_grp_iss_cd_lov(
      p_find_text                VARCHAR2
   )
     RETURN grp_iss_cd_tab PIPELINED;
     
   PROCEDURE val_del_rec(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE
   );
   
   PROCEDURE del_rec(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE
   );
   
   PROCEDURE val_add_rec(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE
   );
   
   PROCEDURE add_rec(
      p_rec                      giis_user_grp_hdr%ROWTYPE
   );
   
   FUNCTION get_user_grp_tran_list(
      p_user_grp                 giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_tran.tran_cd%TYPE,
      p_tran_desc                giis_transaction.tran_desc%TYPE
   )
     RETURN user_grp_tran_tab PIPELINED;
     
   PROCEDURE del_user_grp_tran(
      p_user_grp                 giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_tran.tran_cd%TYPE
   );
   
   PROCEDURE val_add_user_grp_tran(
      p_user_grp                 giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_tran.tran_cd%TYPE
   );
   
   PROCEDURE add_user_grp_tran(
      p_rec                      giis_user_grp_tran%ROWTYPE
   );
   
   FUNCTION get_user_grp_dtl_list(
      p_user_grp                 giis_user_grp_dtl.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_dtl.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_dtl.iss_cd%TYPE,
      p_iss_name                 giis_issource.iss_name%TYPE
   )
     RETURN user_grp_dtl_tab PIPELINED;
     
   PROCEDURE val_del_user_grp_dtl(
      p_user_grp                 giis_user_grp_dtl.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_dtl.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_dtl.iss_cd%TYPE
   );
     
   PROCEDURE del_user_grp_dtl(
      p_user_grp                 giis_user_grp_dtl.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_dtl.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_dtl.iss_cd%TYPE
   );
   
   PROCEDURE set_user_grp_dtl(
      p_rec                      giis_user_grp_dtl%ROWTYPE
   );
   
   FUNCTION get_user_grp_line_list(
      p_user_grp                 giis_user_grp_line.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_line.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_line.iss_cd%TYPE,
      p_line_cd                  giis_line.line_cd%TYPE,
      p_line_name                giis_line.line_name%TYPE
   )
     RETURN user_grp_line_tab PIPELINED;
     
   PROCEDURE val_del_user_grp_line(
      p_user_grp                 giis_user_grp_line.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_line.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_line.iss_cd%TYPE,
      p_line_cd                  giis_user_grp_line.line_cd%TYPE
   );
   
   PROCEDURE del_user_grp_line(
      p_user_grp                 giis_user_grp_line.user_grp%TYPE,
      p_tran_cd                  giis_user_grp_line.tran_cd%TYPE,
      p_iss_cd                   giis_user_grp_line.iss_cd%TYPE,
      p_line_cd                  giis_user_grp_line.line_cd%TYPE
   );
   
   PROCEDURE set_user_grp_line(
      p_rec                      giis_user_grp_line%ROWTYPE
   );
   
   FUNCTION get_module_list(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_module_id                giis_modules.module_id%TYPE,
      p_module_desc              giis_modules.module_desc%TYPE
   )
     RETURN modules_tab PIPELINED;
     
   PROCEDURE del_user_grp_modules(
      p_user_grp                 giis_user_grp_modules.user_grp%TYPE,
      p_module_id                giis_user_grp_modules.module_id%TYPE,
      p_tran_cd                  giis_user_grp_modules.tran_cd%TYPE
   );
     
   PROCEDURE set_user_grp_modules(
      p_rec                      giis_user_grp_modules%ROWTYPE
   );
   
   PROCEDURE check_all_modules(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_module_id                giis_modules.module_id%TYPE,
      p_module_desc              giis_modules.module_desc%TYPE
   );
   
   PROCEDURE uncheck_all_modules(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_module_id                giis_modules.module_id%TYPE,
      p_module_desc              giis_modules.module_desc%TYPE
   );
   
   PROCEDURE copy_user_grp(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_new_user_grp             giis_user_grp_hdr.user_grp%TYPE,
      p_user_id                  giis_user_grp_hdr.user_id%TYPE
   );
   
   FUNCTION get_user_grp_lov(
      p_find_text                VARCHAR2
   )
     RETURN user_grp_tab PIPELINED;
   
   FUNCTION get_tran_lov(
      p_find_text                VARCHAR2
   )
     RETURN tran_lov_tab PIPELINED;
     
   FUNCTION get_issue_lov(
      p_grp_iss_cd               giis_user_grp_hdr.grp_iss_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN grp_iss_cd_tab PIPELINED;
     
   FUNCTION get_line_lov(
      p_find_text                VARCHAR2
   )
     RETURN line_lov_tab PIPELINED;
     
   PROCEDURE insert_all_modules(
      p_user_grp                 giis_user_grp_hdr.user_grp%TYPE,
      p_tran_cd                  giis_modules_tran.tran_cd%TYPE,
      p_access_tag               giis_user_grp_tran.access_tag%TYPE
   );

END;
/


