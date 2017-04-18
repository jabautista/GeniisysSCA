CREATE OR REPLACE PACKAGE BODY CPI.GIACR223_PKG
AS

    FUNCTION get_report_details(
        p_line_cd           giac_treaty_claims.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_claims.trty_yy%TYPE,
        p_treaty_seq_no     giac_treaty_claims.treaty_seq_no%TYPE,
        p_ri_cd             giac_treaty_claims.ri_cd%TYPE,
        p_proc_year         giac_treaty_claims.proc_year%TYPE,
        p_proc_qtr          giac_treaty_claims.proc_qtr%TYPE
    ) RETURN giacr223_tab PIPELINED
    IS
        v_dtl       giacr223_type;
        v_count     NUMBER(1) := 0;
    BEGIN
    
        BEGIN
           SELECT param_value_v 
             INTO v_dtl.company_name
             FROM giis_parameters 
             WHERE param_name LIKE 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_dtl.company_name := NULL;
        END;
        
        BEGIN
           SELECT param_value_v 
             INTO v_dtl.company_address
             FROM giis_parameters 
             WHERE param_name LIKE 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_dtl.company_address := NULL;
        END;
        
        -- main query
        FOR rec IN (SELECT DISTINCT gire.ri_name reinsurer,  gire.ri_cd ri_cd,   
                    --       gcrh.losses_paid loss_paid, 
                    --       gcrh.expenses_paid exp_paid, 
                    --       gler.shr_le_ri_net_amt ri_net_amt, 
                           TO_CHAR(TO_DATE(gitc.proc_qtr,'j'),'Jspth') || ' Quarter, ' || TO_CHAR(gitc.proc_year) period
                      FROM gicl_clm_res_hist gcrh,
                           gicl_loss_exp_rids gler,
                           giis_reinsurer gire,
                           giac_treaty_claims gitc
                     WHERE gcrh.tran_id IS NOT NULL
                       AND TO_NUMBER(TO_CHAR(gcrh.date_paid, 'RRRR')) = gitc.proc_year
                       AND DECODE(TO_NUMBER(TO_CHAR(gcrh.date_paid, 'MM')),1,1,
                                                                           2,1,
                                                                           3,1,
                                                                           4,2,
                                                                           5,2,
                                                                           6,2,
                                                                           7,3,
                                                                           8,3,
                                                                           9,3,
                                                                           10,4,
                                                                           11,4,
                                                                           12,4) = gitc.proc_qtr
                       AND gcrh.dist_no         = gler.clm_dist_no
                       AND gcrh.claim_id        = gler.claim_id
                       AND gcrh.clm_loss_id     = gler.clm_loss_id
                       AND gler.ri_cd           = gire.ri_cd
                       AND gcrh.clm_loss_id     = gitc.clm_loss_id
                       AND gler.clm_dist_no     = gitc.clm_dist_no
                       AND gler.ri_cd           = gitc.ri_cd
                       AND gitc.line_cd         = NVL(p_line_cd, gitc.line_cd)
                       AND gitc.trty_yy         = NVL(p_trty_yy, gitc.trty_yy)
                       AND gitc.treaty_seq_no   = NVL(p_treaty_seq_no, gitc.treaty_seq_no)
                       AND gitc.ri_cd           = NVL(p_ri_cd, gitc.ri_cd)
                       AND gitc.proc_year       = NVL(p_proc_year, gitc.proc_year)
                       AND gitc.proc_qtr        = NVL(p_proc_qtr, gitc.proc_qtr)
                     ORDER BY ri_name)
        LOOP
            v_count := 1;
            v_dtl.reinsurer := rec.reinsurer;
            v_dtl.ri_cd := rec.ri_Cd;
            v_dtl.period := rec.period;
            
            BEGIN
            
               SELECT trty_name
                 INTO v_dtl.treaty_name
                 FROM giis_dist_share
                WHERE line_cd       = p_line_cd
                  AND trty_yy       = p_trty_yy
                  AND share_cd      = p_treaty_seq_no
                  AND share_type    = 2;
             
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    v_dtl.treaty_name := NULL;
            END;
            
            -- for loss_expense amt
            FOR i IN (SELECT DISTINCT gire.ri_name reinsurer, 
							 SUM(gler.shr_le_ri_net_amt) loss_amt
                        FROM gicl_clm_res_hist gcrh,
                             gicl_loss_exp_rids gler,
                             giis_reinsurer gire,
                             giac_treaty_claims gitc
                       WHERE gcrh.tran_id IS NOT NULL
                         AND gcrh.losses_paid IS NULL
                         AND TO_NUMBER(TO_CHAR(gcrh.date_paid, 'RRRR')) = gitc.proc_year
                         AND DECODE(TO_NUMBER(TO_CHAR(gcrh.date_paid, 'MM')),1,1,2,1,3,1,4,2,5,2,6,2,
                                                   7,3,8,3,9,3,10,4,11,4,12,4) = gitc.proc_qtr
                         AND gcrh.dist_no       = gler.clm_dist_no
                         AND gcrh.claim_id      = gler.claim_id
                         AND gcrh.clm_loss_id   = gler.clm_loss_id
                         AND gler.ri_cd         = gire.ri_cd
                         AND gcrh.clm_loss_id   = gitc.clm_loss_id
                         AND gler.clm_dist_no   = gitc.clm_dist_no
                         AND gler.ri_cd         = gitc.ri_cd
                         AND gitc.line_cd       = NVL(p_line_cd, gitc.line_cd)
                         AND gitc.trty_yy       = NVL(p_trty_yy, gitc.trty_yy)
                         AND gitc.treaty_seq_no = NVL(p_treaty_seq_no, gitc.treaty_seq_no)
                         AND gitc.ri_cd         = rec.ri_cd
                         AND gitc.proc_year     = NVL(p_proc_year, gitc.proc_year)
                         AND gitc.proc_qtr      = NVL(p_proc_qtr, gitc.proc_qtr)
                       GROUP BY ri_name
                       ORDER BY ri_name)
            LOOP		
                v_dtl.loss_expense := i.loss_amt;		 
            END LOOP;
            
            -- for loss_paid amount
            FOR i IN (SELECT DISTINCT gire.ri_name reinsurer, 
							 SUM(gler.shr_le_ri_net_amt) loss_amt
                        FROM gicl_clm_res_hist gcrh,
                             gicl_loss_exp_rids gler,
                             giis_reinsurer gire,
                             giac_treaty_claims gitc
                       WHERE gcrh.tran_id IS NOT NULL
                         AND TO_NUMBER(TO_CHAR(gcrh.date_paid, 'RRRR')) = gitc.proc_year
                         AND DECODE(TO_NUMBER(TO_CHAR(gcrh.date_paid, 'MM')),1,1,2,1,3,1,4,2,5,2,6,2,
                                                   7,3,8,3,9,3,10,4,11,4,12,4) = gitc.proc_qtr
                         AND gcrh.dist_no       = gler.clm_dist_no
                         AND gcrh.claim_id      = gler.claim_id
                         AND gcrh.clm_loss_id   = gler.clm_loss_id
                         AND gler.ri_cd         = gire.ri_cd
                         AND gcrh.clm_loss_id   = gitc.clm_loss_id
                         AND gler.clm_dist_no   = gitc.clm_dist_no
                         AND gler.ri_cd         = gitc.ri_cd
                         AND gitc.line_cd       = NVL(p_line_cd, gitc.line_cd)
                         AND gitc.trty_yy       = NVL(p_trty_yy, gitc.trty_yy)
                         AND gitc.treaty_seq_no = NVL(p_treaty_seq_no, gitc.treaty_seq_no)
                         AND gitc.ri_cd         = rec.ri_cd
                         AND gitc.proc_year     = NVL(p_proc_year, gitc.proc_year)
                         AND gitc.proc_qtr      = NVL(p_proc_qtr, gitc.proc_qtr)
                         AND gcrh.expenses_paid IS NULL
                       GROUP BY ri_name
                       ORDER BY ri_name)
            LOOP		
                v_dtl.loss_paid := i.loss_amt;		 
            END LOOP;
        
            PIPE ROW(v_dtl);
        END LOOP;
        
        
        IF v_count = 0 THEN
            PIPE ROW(v_dtl);
        END IF;
    
    END get_report_details;

END GIACR223_PKG;
/


