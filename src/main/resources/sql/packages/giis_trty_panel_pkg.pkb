CREATE OR REPLACE PACKAGE BODY CPI.GIIS_TRTY_PANEL_PKG
AS

    FUNCTION get_trty_panel_list(
        p_line_cd           giis_trty_panel.line_cd%TYPE,
        p_share_cd          giis_trty_panel.trty_seq_no%TYPE,
        p_trty_yy           giis_trty_panel.trty_yy%TYPE,
        p_main_proc_year    NUMBER,
        p_main_proc_qtr     NUMBER
    ) RETURN giis_trty_panel_tab PIPELINED
    IS
        v_panel         giis_trty_panel_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, trty_seq_no, trty_yy
                      FROM giis_trty_panel
                     WHERE line_cd = p_line_cd
                       AND trty_yy = p_trty_yy
                       AND trty_seq_no = p_share_cd)
        LOOP
            v_panel.ri_cd := rec.ri_cd;
            v_panel.trty_seq_no := rec.trty_seq_no;
            v_panel.trty_yy := rec.trty_yy;
            v_panel.line_cd := rec.line_cd;
            
            v_panel.ending_bal_amt  := NULL;
            v_panel.final_tag       := NULL;
            v_panel.user_id         := NULL;
            v_panel.last_update     := NULL;
            
            BEGIN
              SELECT user_id, TO_CHAR(last_extract, 'mm-dd-yyyy') 
                INTO v_panel.ext_user_id,
                     v_panel.last_extract
                FROM giac_treaty_extract
               WHERE line_cd    = rec.line_cd
                 AND share_cd   = rec.trty_seq_no
                 AND trty_yy    = rec.trty_yy
                 AND proc_year  = p_main_proc_year
                 AND proc_qtr   = p_main_proc_qtr;
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    v_panel.ext_user_id := NULL;
                    v_panel.last_extract := NULL;
            END;
        
            BEGIN
              SELECT ri_name 
                INTO v_panel.ri_name
                FROM giis_reinsurer
               WHERE ri_cd = rec.ri_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_panel.ri_name := NULL;
            END;
        
            FOR i IN (SELECT ending_bal_amt,
                             final_tag,
                             user_id,
                             TO_CHAR(last_update, 'mm-dd-yyyy') last_update
                        FROM giac_treaty_qtr_summary
                       WHERE line_cd    = p_line_cd
                         AND share_cd   = rec.trty_seq_no
                         AND trty_yy    = p_trty_yy
                         AND ri_cd      = rec.ri_cd
                         AND proc_year  = p_main_proc_year
                         AND proc_qtr   = p_main_proc_qtr)
            LOOP
                v_panel.ending_bal_amt  := i.ending_bal_amt;
                v_panel.final_tag       := i.final_tag;
                v_panel.user_id         := i.useR_id;
                v_panel.last_update     := i.last_update;
                EXIT;
            END LOOP;        
        
            PIPE ROW(v_panel);
        END LOOP;
        
    END get_trty_panel_list;
    
END GIIS_TRTY_PANEL_PKG;
/


