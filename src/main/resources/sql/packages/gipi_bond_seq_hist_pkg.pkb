CREATE OR REPLACE PACKAGE BODY CPI.GIPI_BOND_SEQ_HIST_PKG AS
    
    FUNCTION get_bond_seq_list (
        p_line_cd       gipi_bond_seq_hist.line_cd%TYPE,
        p_subline_cd    gipi_bond_seq_hist.subline_cd%TYPE,
        p_par_id        gipi_bond_seq_hist.par_id%TYPE
    ) RETURN gipi_bond_seq_hist_tab PIPELINED IS
        v_list gipi_bond_seq_hist_rec;
    BEGIN
        FOR rec IN (
            SELECT line_cd, subline_cd, seq_no
              FROM gipi_bond_seq_hist
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND (   (par_id IS NULL)
                    OR (par_id = p_par_id)
                    OR (par_id IN (SELECT par_id
                                     FROM gipi_parlist
                                    WHERE par_status IN (99, 98)))
                   )
             ORDER BY seq_no ASC
        ) LOOP
            v_list.line_cd      := rec.line_cd;
            v_list.subline_cd   := rec.subline_cd;
            v_list.seq_no       := rec.seq_no;
            
            PIPE ROW(v_list);
        END LOOP;
    
    END get_bond_seq_list;
    
    
    FUNCTION GET_BOND_SEQ_NO (
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
        p_par_id        gipi_parlist.par_id%TYPE
    ) RETURN NUMBER IS
        v_bond_seq gipi_wpolbas.bond_seq_no%TYPE :=0;
    BEGIN
        BEGIN
            SELECT MIN(SEQ_NO)
              INTO v_bond_seq
              FROM GIPI_BOND_SEQ_HIST
             WHERE LINE_CD = p_line_cd
               AND SUBLINE_CD = p_subline_cd
               AND (PAR_ID IS NULL
                    OR PAR_ID = p_par_id
                    OR PAR_ID IN (SELECT PAR_ID
                                 FROM GIPI_PARLIST
                                WHERE PAR_STATUS IN ('98','99'))
                   )   
             ORDER BY 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_bond_seq    := 0;
        END;     
       RETURN (v_bond_seq);
    END GET_BOND_SEQ_NO;
    
    PROCEDURE UPD_BOND_SEQ_HIST (
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
        p_seq_no        gipi_bond_seq_hist.seq_no%TYPE,
        p_par_id        gipi_parlist.par_id%TYPE
    ) IS
    
    BEGIN
        UPDATE gipi_bond_seq_hist
           SET par_id = p_par_id
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd
           AND seq_no = p_seq_no;
           
    END UPD_BOND_SEQ_HIST;
    
    FUNCTION VALIDATE_BOND_SEQ (
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
        p_seq_no        gipi_bond_seq_hist.seq_no%TYPE,
        p_par_id        gipi_parlist.par_id%TYPE
    ) RETURN NUMBER IS
        v_par_id        gipi_parlist.par_id%TYPE; 
    BEGIN
        SELECT par_id
          INTO v_par_id
          FROM gipi_bond_seq_hist
         WHERE line_cd    = p_line_cd
           AND subline_cd = p_subline_cd
           AND seq_no     = p_seq_no;

        FOR rec IN (
            SELECT par_status
              FROM gipi_parlist
             WHERE par_id = v_par_id
               AND par_id <> p_par_id
        ) LOOP
        
            IF rec.par_status NOT IN (99, 98) THEN
                RAISE NO_DATA_FOUND;
            END IF;
            
        END LOOP;

        RETURN 1;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
        
    END VALIDATE_BOND_SEQ;
    
    FUNCTION get_bond_seq_histlist(
        p_user_id       gipi_bond_seq_hist.user_id%TYPE
    ) RETURN gipi_bond_seq_hist_tab2 PIPELINED IS
    v_list gipi_bond_seq_hist_rec2;
    BEGIN
        FOR rec IN (
                SELECT line_cd, subline_cd, seq_no, par_id,
                       user_id, last_update, remarks
                  FROM gipi_bond_seq_hist
                 WHERE user_id = NVL(p_user_id, user_id)
                   AND check_user_per_iss_cd2(line_cd, NULL, 'GIUTS036', p_user_id) = 1
                 ORDER BY last_update DESC
        ) LOOP
            v_list.line_cd      := rec.line_cd;
            v_list.subline_cd   := rec.subline_cd;
            v_list.seq_no       := rec.seq_no;
            v_list.par_id       := rec.par_id;
            v_list.user_id      := rec.user_id;
            v_list.last_update  := rec.last_update;
            v_list.remarks      := rec.remarks;
            
            PIPE ROW (v_list);
        END LOOP;
            
    END get_bond_seq_histlist;
    
    
    
    
END GIPI_BOND_SEQ_HIST_PKG;
/


