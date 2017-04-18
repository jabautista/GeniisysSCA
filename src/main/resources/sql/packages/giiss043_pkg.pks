CREATE OR REPLACE PACKAGE CPI.giiss043_pkg
AS
   TYPE bond_class_type IS RECORD (
      class_no      giis_bond_class.class_no%TYPE,
      fixed_flag    giis_bond_class.fixed_flag%TYPE,
      fixed_amt     giis_bond_class.fixed_amt%TYPE,
      fixed_rt      giis_bond_class.fixed_rt%TYPE,
      min_amt       giis_bond_class.min_amt%TYPE,
      user_id       giis_bond_class.user_id%TYPE,
      last_update   VARCHAR2 (50),
      remarks       giis_bond_class.remarks%TYPE
   );

   TYPE bond_class_tab IS TABLE OF bond_class_type;

   FUNCTION get_bond_class
      RETURN bond_class_tab PIPELINED;

   PROCEDURE save_bond_class (p_rec giis_bond_class%ROWTYPE);

   PROCEDURE val_add_bond_class (p_class_no VARCHAR2);

   PROCEDURE del_bond_class (p_class_no VARCHAR2);

   PROCEDURE val_del_bond_class (p_class_no VARCHAR2);

   TYPE bond_class_subline_type IS RECORD (
      class_no       giis_bond_class_subline.class_no%TYPE,
      line_cd        giis_bond_class_subline.line_cd%TYPE,
      subline_cd     giis_bond_class_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE,
      clause_type    giis_bond_class_subline.clause_type%TYPE,
      clause_desc    giis_bond_class_clause.clause_desc%TYPE,
      waiver_limit   giis_bond_class_subline.waiver_limit%TYPE,
      last_update    VARCHAR2 (50),
      remarks        giis_bond_class_subline.remarks%TYPE,
      user_id        giis_bond_class_subline.user_id%TYPE
   );

   TYPE bond_class_subline_tab IS TABLE OF bond_class_subline_type;

   FUNCTION get_bond_class_subline (p_class_no VARCHAR2)
      RETURN bond_class_subline_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_subline_lov
      RETURN subline_lov_tab PIPELINED;

   TYPE clause_lov_type IS RECORD (
      clause_type   giis_bond_class_clause.clause_type%TYPE,
      clause_desc   giis_bond_class_clause.clause_desc%TYPE
   );

   TYPE clause_lov_tab IS TABLE OF clause_lov_type;

   FUNCTION get_clause_lov
      RETURN clause_lov_tab PIPELINED;

   PROCEDURE val_add_bond_class_subline(
      p_class_no      VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_clause_type   VARCHAR2
   );

   PROCEDURE val_del_bond_class_subline (
      p_subline_cd    VARCHAR2,
      p_clause_type   VARCHAR2
   );

   PROCEDURE save_bond_class_subline (p_rec giis_bond_class_subline%ROWTYPE);

   PROCEDURE del_bond_class_subline (
      p_class_no      VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_clause_type   VARCHAR2
   );

   TYPE bond_class_rt_type IS RECORD (
      class_no      giis_bond_class_rt.class_no%TYPE,
      range_low     giis_bond_class_rt.range_low%TYPE,
      range_high    giis_bond_class_rt.range_high%TYPE,
      default_rt    giis_bond_class_rt.default_rt%TYPE,
      user_id       giis_bond_class_rt.user_id%TYPE,
      last_update   VARCHAR2 (50),
      remarks       giis_bond_class_rt.remarks%TYPE
   );

   TYPE bond_class_rt_tab IS TABLE OF bond_class_rt_type;

   FUNCTION get_bond_class_rt (p_class_no VARCHAR2)
      RETURN bond_class_rt_tab PIPELINED;

   PROCEDURE val_add_bond_class_rt (
      p_range_low    VARCHAR2,
      p_range_high   VARCHAR2,
      p_class_no     VARCHAR2
   );

   PROCEDURE save_bond_class_rt (p_rec giis_bond_class_rt%ROWTYPE);

   PROCEDURE del_bond_class_rt (
      p_range_low    VARCHAR2,
      p_range_high   VARCHAR2,
      p_class_no     VARCHAR2
   );
END;
/


