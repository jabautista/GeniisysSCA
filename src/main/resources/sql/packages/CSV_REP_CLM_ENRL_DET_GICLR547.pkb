CREATE OR REPLACE PACKAGE BODY CPI.CSV_REP_CLM_ENRL_DET_GICLR547
AS

/*
   **  Created by   :  Bernadette B. Quitain
   **  Date Created : 03.31.2016
   **  Modified by:   Herbert DR. Tagudin
   **  Date Modified : 04.05.2016  (SR 5403)
   **  Reference By : GICLR547_PKG
   **  Remarks      : Reported Claims Per Enrollee - Detailed
   */   
   
    FUNCTION cf_intm(
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE
    )
        RETURN CHAR 
    IS
        v_intm          VARCHAR2(300) := NULL;
        var_intm        VARCHAR2(300) := null;
        

    BEGIN
        IF p_pol_iss_cd = 'RI' THEN
            FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                         FROM gicl_claims a, giis_reinsurer b
                        WHERE a.claim_id = p_claim_id
                          AND a.ri_cd    = b.ri_cd(+))
            LOOP
                v_intm := TO_CHAR(ri.ri_cd)||'/'||ri.ri_name;
                IF var_intm IS NULL THEN
                    var_intm := v_intm;
                ELSE
                    var_intm := v_intm||chr(10)||var_intm;  
                END IF;
            END LOOP;
        ELSE
            FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm, b.ref_intm_cd ref_cd
                           FROM gicl_intm_itmperil a, giis_intermediary b
                          WHERE a.intm_no  = b.intm_no
                            AND a.claim_id = p_claim_id) 
            LOOP
                v_intm := TO_CHAR(intm.nmbr)||'/'||intm.ref_cd||'/'|| intm.nm;
                IF var_intm IS NULL THEN
                    var_intm := v_intm;
                ELSE
                    var_intm := v_intm||CHR(10)||var_intm;
                END IF;
            END LOOP;
        END IF;
        RETURN (var_intm);
    END cf_intm;

    FUNCTION CSV_GICLR547_BOTH(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_user_id            VARCHAR2   
    )
        RETURN giclr547_tab PIPELINED
    IS
        v_rep               giclr547_rec_type;
        v_intm              VARCHAR2(300) := null; 
        v_loss_exp          VARCHAR2 (2);
        v_print             BOOLEAN:=TRUE;
        
    BEGIN
    
        FOR i IN(SELECT b.clm_stat_desc,a.claim_id,c.item_no,a.clm_stat_cd,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.pol_iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                     a.pol_eff_date,a.dsp_loss_date, a.clm_file_date, a.pol_iss_cd, 
                     c.grouped_item_title, c.control_cd, c.control_type_cd
                FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
               WHERE a.clm_stat_cd = b.clm_stat_cd
                 AND a.claim_id = c.claim_id
                 AND c.grouped_item_title IS NOT NULL          
                 AND NVL (c.grouped_item_title, '!@#') LIKE NVL (p_grouped_item_title, NVL (c.grouped_item_title, '!@#'))
                 AND NVL (c.control_cd, '!@#') LIKE NVL (p_control_cd, NVL (c.control_cd, '!@#'))
                 AND NVL (c.control_type_cd, 1234) LIKE NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
                 AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE(p_start_dt,'MM/DD/YYYY'), a.clm_file_date) AND NVL (TO_DATE(p_end_dt,'MM/DD/YYYY'), a.clm_file_date)
                 AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
            ORDER BY c.grouped_item_title,
                     b.clm_stat_desc,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.clm_yy,
                     a.clm_seq_no)
        LOOP
        
            v_rep.status                := i.clm_stat_desc;
            v_rep.claim_number              := i.claim_number;
            v_rep.policy_number             := i.policy_number;
            v_rep.eff_date              := TO_CHAR(TRUNC(i.pol_eff_date),'MM-DD-YYYY');
            v_rep.loss_date                 := TO_CHAR(TRUNC(i.dsp_loss_date),'MM-DD-YYYY');
            v_rep.file_date           := TO_CHAR(TRUNC(i.clm_file_date),'MM-DD-YYYY');
            v_rep.enrollee                  := i.grouped_item_title;
            v_rep.intermediary_cedant       := cf_intm(i.claim_id, i.pol_iss_cd);
            
            v_print  := TRUE;
            
            -- where the function for subreport starts
             BEGIN 
             
                FOR j IN(SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                   FROM giis_peril a, gicl_item_peril b
                  WHERE a.line_cd  = b.line_cd
                    AND a.peril_cd = b.peril_cd
                    AND b.claim_id = i.claim_id)
                LOOP
                
                    --loss amounts
                    v_print := FALSE;
                    v_rep.peril   := j.peril_name;
                        v_rep.claim_amount_type         := 'Loss Amount';
                        v_rep.claim_amount              := TRIM(TO_CHAR(gicls540_pkg.get_loss_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 1, 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                   
                    PIPE ROW(v_rep);
                    
                    --expense amounts
                        
                        v_rep.claim_amount_type         := 'Expense Amount';
                        v_rep.claim_amount              := TRIM(TO_CHAR(gicls540_pkg.get_loss_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 1, 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd),'999999999999990.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'E', i.clm_stat_cd),'999999999999990.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd),'999999999999990.99'));
                        
                   PIPE ROW(v_rep);
                END LOOP;
                
                IF v_print THEN
                        v_rep.peril   := NULL;
                        
                        v_rep.claim_amount_type         := 'Loss Amount';
                        v_rep.claim_amount              := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(0,'0.99'));
                        
                        PIPE ROW(v_rep);
                        
                        v_rep.claim_amount_type         := 'Expense Amount';
                        v_rep.claim_amount              := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(0,'0.99'));
                        
                         PIPE ROW(v_rep);
                
                END IF;
                      
            END; --end of subreport function.
              
        END LOOP;
    END CSV_GICLR547_BOTH;
    
    
    FUNCTION CSV_GICLR547_EXPENSES(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_user_id            VARCHAR2   
    )
        RETURN giclr547_exp_tab PIPELINED
    IS
        v_rep               giclr547_exp_rec_type;
        v_intm              VARCHAR2(300) := null; 
        v_loss_exp          VARCHAR2 (2);
        
        v_print             BOOLEAN := TRUE;
        
    BEGIN
    
        FOR i IN(SELECT b.clm_stat_desc,a.claim_id,c.item_no,a.clm_stat_cd,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.pol_iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                     a.pol_eff_date,a.dsp_loss_date, a.clm_file_date, a.pol_iss_cd, 
                     c.grouped_item_title, c.control_cd, c.control_type_cd
                FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
               WHERE a.clm_stat_cd = b.clm_stat_cd
                 AND a.claim_id = c.claim_id
                 AND c.grouped_item_title IS NOT NULL          
                 AND NVL (c.grouped_item_title, '!@#') LIKE NVL (p_grouped_item_title, NVL (c.grouped_item_title, '!@#'))
                 AND NVL (c.control_cd, '!@#') LIKE NVL (p_control_cd, NVL (c.control_cd, '!@#'))
                 AND NVL (c.control_type_cd, 1234) LIKE NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
                 AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE(p_start_dt,'MM/DD/YYYY'), a.clm_file_date) AND NVL (TO_DATE(p_end_dt,'MM/DD/YYYY'), a.clm_file_date)
                 AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
            ORDER BY c.grouped_item_title,
                     b.clm_stat_desc,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.clm_yy,
                     a.clm_seq_no)
        LOOP
        
            v_rep.status                := i.clm_stat_desc;
            v_rep.claim_number              := i.claim_number;
            v_rep.policy_number             := i.policy_number;
            v_rep.eff_date              := TO_CHAR(TRUNC(i.pol_eff_date),'MM-DD-YYYY');
            v_rep.loss_date                 := TO_CHAR(TRUNC(i.dsp_loss_date),'MM-DD-YYYY');
            v_rep.file_date           := TO_CHAR(TRUNC(i.clm_file_date),'MM-DD-YYYY');
            v_rep.enrollee                  := i.grouped_item_title;
            v_rep.intermediary_cedant       := cf_intm(i.claim_id, i.pol_iss_cd);
            
            v_print := TRUE;
            
            -- where the function for subreport starts
            BEGIN 
                FOR j IN(SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                   FROM giis_peril a, gicl_item_peril b
                  WHERE a.line_cd  = b.line_cd
                    AND a.peril_cd = b.peril_cd
                    AND b.claim_id = i.claim_id)
                LOOP
                    v_print := FALSE;
                    v_rep.peril   := j.peril_name;
                  
                        v_rep.expense_amount            := TRIM(TO_CHAR(gicls540_pkg.get_loss_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 1, 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'E', i.clm_stat_cd),'999,999,999,999,990.99'));
                   
                    PIPE ROW(v_rep);
                        
                END LOOP;      
            END; --end of subreport function.
            
            
            IF v_print THEN
                        v_rep.peril   := NULL;
                        v_rep.expense_amount            := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(0,'0.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(0,'0.99'));
                        
                        PIPE ROW(v_rep);
                
            END IF;
                 
        END LOOP;
    END CSV_GICLR547_EXPENSES;
    
    
    FUNCTION CSV_GICLR547_LOSS(
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_user_id            VARCHAR2   
    )
        RETURN giclr547_loss_tab PIPELINED
    IS
        v_rep               giclr547_loss_rec_type;
        v_intm              VARCHAR2(300) := null; 
        v_loss_exp          VARCHAR2 (2);
        
        v_print  BOOLEAN := TRUE;
    BEGIN
    
        FOR i IN(SELECT b.clm_stat_desc,a.claim_id,c.item_no,a.clm_stat_cd,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                        a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.pol_iss_cd
                     || '-'
                     || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                     || '-'
                     || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                     a.pol_eff_date,a.dsp_loss_date, a.clm_file_date, a.pol_iss_cd, 
                     c.grouped_item_title, c.control_cd, c.control_type_cd
                FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
               WHERE a.clm_stat_cd = b.clm_stat_cd
                 AND a.claim_id = c.claim_id
                 AND c.grouped_item_title IS NOT NULL          
                 AND NVL (c.grouped_item_title, '!@#') LIKE NVL (p_grouped_item_title, NVL (c.grouped_item_title, '!@#'))
                 AND NVL (c.control_cd, '!@#') LIKE NVL (p_control_cd, NVL (c.control_cd, '!@#'))
                 AND NVL (c.control_type_cd, 1234) LIKE NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
                 AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE(p_start_dt,'MM/DD/YYYY'), a.clm_file_date) AND NVL (TO_DATE(p_end_dt,'MM/DD/YYYY'), a.clm_file_date)
                 AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS540', p_user_id) = 1
            ORDER BY c.grouped_item_title,
                     b.clm_stat_desc,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.clm_yy,
                     a.clm_seq_no)
        LOOP
        
            v_rep.status                := i.clm_stat_desc;
            v_rep.claim_number              := i.claim_number;
            v_rep.policy_number             := i.policy_number;
            v_rep.eff_date              := TO_CHAR(TRUNC(i.pol_eff_date),'MM-DD-YYYY');
            v_rep.loss_date                 := TO_CHAR(TRUNC(i.dsp_loss_date),'MM-DD-YYYY');
            v_rep.file_date           := TO_CHAR(TRUNC(i.clm_file_date),'MM-DD-YYYY');
            v_rep.enrollee                  := i.grouped_item_title;
            v_rep.intermediary_cedant       := cf_intm(i.claim_id, i.pol_iss_cd);
            
            v_print := TRUE;
            
            -- where the function for subreport starts
             BEGIN 
                FOR j IN(SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                   FROM giis_peril a, gicl_item_peril b
                  WHERE a.line_cd  = b.line_cd
                    AND a.peril_cd = b.peril_cd
                    AND b.claim_id = i.claim_id)
                LOOP
                    
                    v_print := FALSE;
                    v_rep.peril   := j.peril_name;
                  
                        v_rep.loss_amount               := TRIM(TO_CHAR(gicls540_pkg.get_loss_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.retention                 := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, 1, 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.proportional_treaty       := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('TRTY_SHARE_TYPE'), 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.facultative               := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('FACUL_SHARE_TYPE'), 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                        v_rep.nonproportional_treaty    := TRIM(TO_CHAR(gicls540_pkg.get_amount_per_item_peril(i.claim_id, i.item_no, j.peril_cd, giacp.v('XOL_TRTY_SHARE_TYPE'), 'L', i.clm_stat_cd),'999,999,999,999,990.99'));
                   
                    PIPE ROW(v_rep);
                        
                END LOOP;      
            END; --end of subreport function.
            
            IF v_print THEN
                    v_rep.peril   := NULL;
                    v_rep.loss_amount               := TRIM(TO_CHAR(0,'0.99'));
                    v_rep.retention                 := TRIM(TO_CHAR(0,'0.99'));
                    v_rep.proportional_treaty       := TRIM(TO_CHAR(0,'0.99'));
                    v_rep.facultative               := TRIM(TO_CHAR(0,'0.99'));
                    v_rep.nonproportional_treaty    := TRIM(TO_CHAR(0,'0.99'));
                        
                    PIPE ROW(v_rep);
            END IF;  
                 
        END LOOP;
    END CSV_GICLR547_LOSS;
       
END CSV_REP_CLM_ENRL_DET_GICLR547;
/
