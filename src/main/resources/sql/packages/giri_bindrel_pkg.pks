CREATE OR REPLACE PACKAGE CPI.giri_bindrel_pkg
AS
    PROCEDURE insert_to_bindrel (
        p_fnl_binder_id     IN      giri_frps_ri.fnl_binder_id%TYPE,
        p_binder_id         IN OUT  giri_bindrel.neg_binder_id%TYPE,
        p_year              IN      NUMBER,
        p_fbndr_seq_no      IN OUT  giri_bindrel.neg_binder_seq_no%TYPE
    );
    
END giri_bindrel_pkg;
/


