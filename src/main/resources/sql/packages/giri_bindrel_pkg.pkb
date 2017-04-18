CREATE OR REPLACE PACKAGE BODY CPI.giri_bindrel_pkg
AS
     /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Inserts records to GIRI_BINDREL which were tagged for reversal.
     */
    PROCEDURE insert_to_bindrel (
        p_fnl_binder_id     IN      giri_frps_ri.fnl_binder_id%TYPE,
        p_binder_id         IN OUT  giri_bindrel.neg_binder_id%TYPE,
        p_year              IN      NUMBER,
        p_fbndr_seq_no      IN OUT  giri_bindrel.neg_binder_seq_no%TYPE
    )
    IS
      v_line_cd             giri_binder.line_cd%TYPE;
      v_binder_yy           giri_binder.binder_yy%TYPE;
      v_binder_seq_no       giri_binder.binder_seq_no%TYPE;

    --Get records from GIRI_FRPS_RI which were tagged for reversal.
      CURSOR c1 IS
        SELECT ri_cd, fnl_binder_id
          FROM giri_frps_ri
         WHERE fnl_binder_id = p_fnl_binder_id;

    BEGIN
      FOR c1_rec IN c1 LOOP
        SELECT line_cd, binder_yy, binder_seq_no
          INTO v_line_cd, v_binder_yy, v_binder_seq_no
          FROM giri_binder
         WHERE fnl_binder_id = c1_rec.fnl_binder_id;
        UPDATE giri_binder
           SET reverse_date = SYSDATE,
               bndr_stat_cd = NULL --benjo 12.15.2016 SR-5811
         WHERE fnl_binder_id = c1_rec.fnl_binder_id;
        INSERT INTO giri_bindrel
           (fnl_binder_id, neg_binder_id, 
            line_cd, binder_yy, binder_seq_no,
            neg_binder_yy, neg_binder_seq_no,
            user_id, reverse_date)
        VALUES
           (c1_rec.fnl_binder_id, p_binder_id,
            v_line_cd, v_binder_yy, v_binder_seq_no,
            p_year, p_fbndr_seq_no,
            USER, SYSDATE);
        SELECT binder_id_s.nextval
          INTO p_binder_id
          FROM dual;
        p_fbndr_seq_no  := p_fbndr_seq_no + 1;
      END LOOP;
    END insert_to_bindrel;
    
END;
/


