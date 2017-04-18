CREATE OR REPLACE PACKAGE CPI.giacs311_pkg
AS
   TYPE rec_type IS RECORD (
      gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
      gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_sname     giac_chart_of_accts.gl_acct_sname%TYPE,
      leaf_tag          giac_chart_of_accts.leaf_tag%TYPE,
      gslt_sl_type_cd   giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      dsp_sl_type_name  giac_sl_types.sl_type_name%TYPE,
      dr_cr_tag         giac_chart_of_accts.dr_cr_tag%TYPE,
      acct_type         giac_chart_of_accts.acct_type%TYPE,
      ref_acct_cd       giac_chart_of_accts.ref_acct_cd%TYPE,    
      user_id           giac_chart_of_accts.user_id%TYPE,
      last_update       VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE sl_type IS RECORD(
      gslt_sl_type_cd   giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      dsp_sl_type_name  giac_sl_types.sl_type_name%TYPE
   );
   
   TYPE sl_tab IS TABLE OF sl_type;
      
   TYPE acct_type IS RECORD(
      rv_low_value      cg_ref_codes.rv_low_value%TYPE,
      rv_meaning        cg_ref_codes.rv_meaning%TYPE
   );
   
   TYPE acct_tab IS TABLE OF acct_type;

   TYPE child_type IS RECORD (
      gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
      gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_sname     giac_chart_of_accts.gl_acct_sname%TYPE,
      leaf_tag          giac_chart_of_accts.leaf_tag%TYPE,
      gslt_sl_type_cd   giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      dsp_sl_type_name  giac_sl_types.sl_type_name%TYPE,
      dr_cr_tag         giac_chart_of_accts.dr_cr_tag%TYPE,
      acct_type         giac_chart_of_accts.acct_type%TYPE,
      ref_acct_cd       giac_chart_of_accts.ref_acct_cd%TYPE,    
      user_id           giac_chart_of_accts.user_id%TYPE,
      last_update       VARCHAR2 (30)
   ); 

   TYPE child_tab IS TABLE OF child_type;
   
   FUNCTION check_user_function(
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN VARCHAR2;
        
   FUNCTION get_rec_list(
      p_query_level     VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_sl_type_rec_list
      RETURN sl_tab PIPELINED;    

   FUNCTION get_acct_type_rec_list(
      p_acct_type      cg_ref_codes.rv_low_value%TYPE
   )
      RETURN acct_tab PIPELINED;         
   
   FUNCTION get_gl_mother_acct(
      p_gl_acct_id      giac_chart_of_accts.gl_acct_id%TYPE,
      p_level           VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_child_rec_list(
      p_gl_acct_id      giac_chart_of_accts.gl_acct_id%TYPE,
      p_mother_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE,
      p_level           VARCHAR2
   )
      RETURN child_tab PIPELINED;  

   FUNCTION get_incremented_level(
      p_gl_acct_id      giac_chart_of_accts.gl_acct_id%TYPE,
      p_level           VARCHAR2
   )
      RETURN VARCHAR2;          

   PROCEDURE set_rec (p_rec giac_chart_of_accts%ROWTYPE);

   PROCEDURE del_rec (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE);

   PROCEDURE val_del_rec (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE);   

   PROCEDURE val_update_rec (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE);
   
   PROCEDURE val_add_rec(
      p_tran              VARCHAR2,
      p_gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE,
      p_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE
   );
   
END;
/


