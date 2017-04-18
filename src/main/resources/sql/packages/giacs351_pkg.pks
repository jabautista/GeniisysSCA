CREATE OR REPLACE PACKAGE CPI.giacs351_pkg
AS
   TYPE rec_type IS RECORD (
      rep_cd             giac_eom_rep_dtl.rep_cd%TYPE,
      rep_title          giac_eom_rep.rep_title%TYPE,
      gl_acct_id         giac_eom_rep_dtl.gl_acct_id%TYPE,
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE,
      gl_acct_no         VARCHAR2 (100),
      remarks            giac_eom_rep_dtl.remarks%TYPE,
      user_id            giac_eom_rep_dtl.user_id%TYPE,
      last_update        VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_rep_cd         giac_eom_rep_dtl.rep_cd%TYPE,
      p_gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
      p_gl_acct_no     VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   TYPE rep_lov_type IS RECORD (
      rep_cd      giac_eom_rep.rep_cd%TYPE,
      rep_title   giac_eom_rep.rep_title%TYPE
   );

   TYPE rep_lov_tab IS TABLE OF rep_lov_type;

   FUNCTION get_rep_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN rep_lov_tab PIPELINED;

   PROCEDURE val_glacctno_rec (
      p_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      p_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   );

   TYPE gl_lov_type IS RECORD (
      gl_acct_id         giac_eom_rep_dtl.gl_acct_id%TYPE,
      gl_acct_no         VARCHAR2 (100),
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   );

   TYPE gl_lov_tab IS TABLE OF gl_lov_type;

   FUNCTION get_glacctno_lov (
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_keyword            VARCHAR2,
      p_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      p_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   )
      RETURN gl_lov_tab PIPELINED;
      
      FUNCTION get_gl_acct_lov (p_find VARCHAR2)
      RETURN gl_lov_tab PIPELINED;

   PROCEDURE val_addglacctno_rec (
      p_rep_cd             giac_eom_rep_dtl.rep_cd%TYPE,
      p_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      p_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   );

   PROCEDURE set_rec (p_rec giac_eom_rep_dtl%ROWTYPE);

   PROCEDURE del_rec (
      p_rep_cd       giac_eom_rep_dtl.rep_cd%TYPE,
      p_gl_acct_id   giac_eom_rep_dtl.gl_acct_id%TYPE
   );
END;
/


