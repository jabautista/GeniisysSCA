DROP PROCEDURE CPI.BAE_GET_MODULE_PARAMETERS;

CREATE OR REPLACE PROCEDURE CPI.BAE_get_module_parameters (
        var_module_item_no        IN     giac_module_entries.item_no%type,
        var_module_name           IN     giac_modules.module_name%type,
   var_gl_acct_category      IN OUT giac_module_entries.gl_acct_category%type,
        var_gl_control_acct       IN OUT giac_module_entries.gl_control_acct%type,
   var_gl_sub_acct_1         IN OUT giac_module_entries.gl_sub_acct_1%type,
        var_gl_sub_acct_2         IN OUT giac_module_entries.gl_sub_acct_2%type,
   var_gl_sub_acct_3         IN OUT giac_module_entries.gl_sub_acct_3%type,
        var_gl_sub_acct_4         IN OUT giac_module_entries.gl_sub_acct_4%type,
   var_gl_sub_acct_5         IN OUT giac_module_entries.gl_sub_acct_5%type,
        var_gl_sub_acct_6         IN OUT giac_module_entries.gl_sub_acct_6%type,
   var_gl_sub_acct_7         IN OUT giac_module_entries.gl_sub_acct_7%type,
        var_intm_type_level       IN OUT giac_module_entries.intm_type_level%type,
        var_ca_treaty_type_level  IN OUT giac_module_entries.ca_treaty_type_level%type,
   var_line_dependency_level IN OUT giac_module_entries.line_dependency_level%type,
   var_old_new_acct_level    IN OUT giac_module_entries.old_new_acct_level%type,
        var_dr_cr_tag             IN OUT giac_module_entries.dr_cr_tag%type ) is
BEGIN
 SELECT gl_acct_category   ,  gl_control_acct   ,
        gl_sub_acct_1      ,  gl_sub_acct_2     ,
     gl_sub_acct_3      ,  gl_sub_acct_4     ,
    gl_sub_acct_5      ,  gl_sub_acct_6     ,
    gl_sub_acct_7      ,  intm_type_level   ,
    line_dependency_level  ,
    old_new_acct_level ,  dr_cr_tag         ,
    ca_treaty_type_level
 INTO   var_gl_acct_category   ,  var_gl_control_acct   ,
    var_gl_sub_acct_1      ,  var_gl_sub_acct_2     ,
    var_gl_sub_acct_3      ,  var_gl_sub_acct_4     ,
    var_gl_sub_acct_5      ,  var_gl_sub_acct_6     ,
    var_gl_sub_acct_7      ,  var_intm_type_level   ,
    var_line_dependency_level  ,
        var_old_new_acct_level ,  var_dr_cr_tag         ,
        var_ca_treaty_type_level
   FROM  giac_module_entries a, giac_modules b
  WHERE  a.module_id = b.module_id
    AND  module_name = var_module_name
    AND  item_no = VAR_MODULE_ITEM_NO  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    null;
END;
/


