CREATE OR REPLACE PACKAGE BODY CPI.giis_bond_seq_pkg AS

    PROCEDURE generate_bond_seq (
        p_line_cd    IN  VARCHAR2,
        p_subline_cd IN  VARCHAR2,
        p_module_id  IN  VARCHAR2,
        p_user_id    IN  VARCHAR2,
        p_seq_no     OUT NUMBER
    ) IS
        v_seq_no        NUMBER(7) := 0;
        v_module_desc   VARCHAR2(100);
    BEGIN
       giis_users_pkg.app_user := p_user_id;
       -- check if there is an exisitng record in giis_bond_seq
       FOR seq IN (SELECT seq_no
                     FROM giis_bond_seq
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd)
       LOOP
          UPDATE giis_bond_seq
             SET seq_no = seq_no + 1
           WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;

          v_seq_no := seq.seq_no + 1;
       END LOOP;

       IF v_seq_no = 0 THEN
          v_seq_no := 1;

          INSERT
            INTO giis_bond_seq
                 (line_cd, subline_cd, seq_no)
          VALUES (p_line_cd, p_subline_cd, 1);
       END IF;

       -- check module
       FOR module IN (SELECT module_id, module_desc
                        FROM giis_modules
                       WHERE module_id = p_module_id)
       LOOP
          v_module_desc := module.module_desc;
       END LOOP;

       -- insert record in gipi_bond_seq_hist
       INSERT
         INTO gipi_bond_seq_hist
              (line_cd, subline_cd, seq_no, remarks)
       VALUES (p_line_cd, p_subline_cd, v_seq_no, 'Generate using ' || p_module_id || ' - ' || v_module_desc);

       p_seq_no := v_seq_no;
    END generate_bond_seq;
    
END giis_bond_seq_pkg;
/


