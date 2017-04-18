CREATE OR REPLACE PACKAGE CPI.GIACS317_PKG

AS
   TYPE rec_type IS RECORD (
      module_id       giac_modules.module_id%TYPE,      
      module_name     giac_modules.module_name%TYPE,    
      scrn_rep_name   giac_modules.scrn_rep_name%TYPE,  
      scrn_rep_tag    giac_modules.scrn_rep_tag%TYPE,
      scrn_rep_tag_name cg_ref_codes.rv_meaning%TYPE,   
      generation_type giac_modules.generation_type%TYPE,
      mod_entries_tag giac_modules.mod_entries_tag%TYPE,
      functions_tag   giac_modules.functions_tag%TYPE,  
      remarks         giac_modules.remarks%TYPE,
      user_id         giac_modules.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_modules%ROWTYPE);

   PROCEDURE del_rec (p_module_id giac_modules.module_id%TYPE);

   FUNCTION val_del_rec (p_module_id giac_modules.module_id%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_module_name giac_modules.module_name%TYPE,
                         p_generation_type giac_modules.generation_type%TYPE);
                         
   TYPE scrn_rep_tag_lov_type IS RECORD (
        rv_low_value    CG_REF_CODES.rv_low_value%TYPE,    
        rv_meaning      CG_REF_CODES.rv_meaning%TYPE  
   );
   
   TYPE scrn_rep_tag_lov_tab IS TABLE OF scrn_rep_tag_lov_type;
   
   FUNCTION get_scrn_rep_tag_lov
     RETURN scrn_rep_tag_lov_tab PIPELINED;
     
   PROCEDURE val_scrn_rep_tag(
       p_scrn_rep_tag_name   IN OUT CG_REF_CODES.rv_meaning%TYPE,
       p_scrn_rep_tag           OUT CG_REF_CODES.rv_low_value%TYPE
   );
   
END;
/


