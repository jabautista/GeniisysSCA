CREATE OR REPLACE PACKAGE CPI.giiss099_pkg
AS
   TYPE rec_type IS RECORD (
      clause_type     giis_bond_class_clause.clause_type%TYPE,
      clause_desc  giis_bond_class_clause.clause_desc%TYPE,
      remarks     giis_bond_class_clause.remarks%TYPE,
      user_id     giis_bond_class_clause.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_clause_type     giis_bond_class_clause.clause_type%TYPE,
      p_clause_desc  giis_bond_class_clause.clause_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_bond_class_clause%ROWTYPE);

   PROCEDURE del_rec (p_clause_type giis_bond_class_clause.clause_type%TYPE);

   PROCEDURE val_del_rec (p_clause_type giis_bond_class_clause.clause_type%TYPE);
   
   PROCEDURE val_add_rec(p_clause_type giis_bond_class_clause.clause_type%TYPE);
   
END;
/


