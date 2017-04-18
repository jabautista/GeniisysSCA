CREATE OR REPLACE PACKAGE CPI.GIPI_BOND_SEQ_HIST_PKG AS

    TYPE gipi_bond_seq_hist_rec IS RECORD (
        line_cd         gipi_bond_seq_hist.line_cd%TYPE,
        subline_cd      gipi_bond_seq_hist.subline_cd%TYPE,
        seq_no          gipi_bond_seq_hist.seq_no%TYPE
    );
    TYPE gipi_bond_seq_hist_tab IS TABLE OF gipi_bond_seq_hist_rec;
    
    FUNCTION get_bond_seq_list (
        p_line_cd       gipi_bond_seq_hist.line_cd%TYPE,
        p_subline_cd    gipi_bond_seq_hist.subline_cd%TYPE,
        p_par_id        gipi_bond_seq_hist.par_id%TYPE
    ) RETURN gipi_bond_seq_hist_tab PIPELINED;
        

    FUNCTION GET_BOND_SEQ_NO (
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
        p_par_id        gipi_parlist.par_id%TYPE
    ) RETURN NUMBER;
    
    PROCEDURE UPD_BOND_SEQ_HIST (
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
        p_seq_no        gipi_bond_seq_hist.seq_no%TYPE,
        p_par_id        gipi_parlist.par_id%TYPE
    );
    
    FUNCTION VALIDATE_BOND_SEQ (
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
        p_seq_no        gipi_bond_seq_hist.seq_no%TYPE,
        p_par_id        gipi_parlist.par_id%TYPE
    ) RETURN NUMBER;
    
    TYPE gipi_bond_seq_hist_rec2 IS RECORD (
        line_cd         gipi_bond_seq_hist.line_cd%TYPE,
        subline_cd      gipi_bond_seq_hist.subline_cd%TYPE,
        seq_no          gipi_bond_seq_hist.seq_no%TYPE,
        par_id          gipi_bond_seq_hist.par_id%TYPE,
        user_id         gipi_bond_seq_hist.user_id%TYPE,
        last_update     gipi_bond_seq_hist.last_update%TYPE,
        remarks         gipi_bond_seq_hist.remarks%TYPE
    );
    TYPE gipi_bond_seq_hist_tab2 IS TABLE OF gipi_bond_seq_hist_rec2;
    
    FUNCTION get_bond_seq_histlist(
        p_user_id       gipi_bond_seq_hist.user_id%TYPE
    ) RETURN gipi_bond_seq_hist_tab2 PIPELINED;
    
END GIPI_BOND_SEQ_HIST_PKG;
/


