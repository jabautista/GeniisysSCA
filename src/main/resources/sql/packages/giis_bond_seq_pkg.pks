CREATE OR REPLACE PACKAGE CPI.giis_bond_seq_pkg AS

    PROCEDURE generate_bond_seq (
        p_line_cd    IN  VARCHAR2,
        p_subline_cd IN  VARCHAR2,
        p_module_id  IN  VARCHAR2,
        p_user_id    IN  VARCHAR2,
        p_seq_no     OUT NUMBER
    );
    
END giis_bond_seq_pkg;
/


