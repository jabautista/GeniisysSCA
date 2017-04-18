CREATE OR REPLACE PACKAGE BODY CPI.CSV_GICLR200B_PKG
AS

    FUNCTION get_report_details(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_as_of_date    DATE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE
    ) RETURN giclr200b_tab PIPELINED
    IS
        v_dtl       giclr200b_type;
        v_count     NUMBER(1) := 0;
        v_check     BOOLEAN := true; --jm
    BEGIN
    
       
    
--        IF v_check
--        THEN
--        v_check := false;
--            BEGIN
--                SELECT report_title 
--                  INTO v_dtl.cf_title
--                  FROM giis_reports
--                 WHERE report_id = 'GICLR200B';
--            EXCEPTION
--                WHEN no_data_found THEN
--                    v_dtl.cf_title := null;
--            END;
--        END IF;
            
        
   
    
        FOR rec IN ( SELECT a.catastrophic_cd, a.line_cd, b.share_type, b.grp_seq_no, c.ri_cd, c.shr_ri_pct,
                             SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                             SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds,
                             SUM (NVL (c.os_loss, 0) + NVL (c.os_exp, 0)) os_rids,
                             SUM (NVL (c.pd_loss, 0) + NVL (c.pd_exp, 0)) pd_rids
                        FROM gicl_os_pd_clm_extr a,
                             gicl_os_pd_clm_ds_extr b,
                             gicl_os_pd_clm_rids_extr c
                       WHERE a.session_id       = b.session_id
                         AND a.claim_id         = b.claim_id
                         AND a.os_pd_rec_id     = b.os_pd_rec_id
                         AND b.session_id       = c.session_id
                         AND b.claim_id         = c.claim_id
                         AND b.os_pd_rec_id     = c.os_pd_rec_id
                         AND b.os_pd_ds_rec_id  = c.os_pd_ds_rec_id
                         AND b.grp_seq_no       = c.grp_seq_no
                         AND b.share_type       = 4
                         AND c.ri_cd            = NVL (p_ri_cd, c.ri_cd)
                         AND a.session_id       = p_session_id
                       GROUP BY a.catastrophic_cd, a.line_cd, b.share_type, b.grp_seq_no, c.ri_cd, c.shr_ri_pct
                       UNION
                      SELECT a.catastrophic_cd,
                             DECODE(share_type, 1, null, 3, null, a.line_cd) line_cd, 
                             b.share_type, b.grp_seq_no, NULL ri_cd, NULL shr_ri_pct, 
                             SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                             SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds,
                             NULL os_rids,
                             NULL pd_rids
                        FROM gicl_os_pd_clm_extr a,
                             gicl_os_pd_clm_ds_extr b,
                             gicl_cat_dtl c
                       WHERE a.session_id   = b.session_id
                         AND a.claim_id     = b.claim_id
                         AND a.os_pd_rec_id = b.os_pd_rec_id
                         AND b.share_type   <> 4
                         AND a.session_id   = p_session_id
                         AND b.grp_seq_no = giisp.n('NET_RETENTION')-- SR 5412
                         AND b.grp_seq_no = giisp.n('FACULTATIVE') --  SR 5412
                         AND share_type <> 1 -- SR 5412
                       GROUP BY a.catastrophic_cd, DECODE(b.share_type, 1, null, 3, null, a.line_cd), b.share_type, b.grp_seq_no     
                       ORDER BY catastrophic_cd, share_type, line_cd, grp_seq_no)
        LOOP
            
             
                
            v_count := 1;
            v_dtl.Outstanding      := TO_CHAR (NVL(rec.os_ds, 0),'9,999,999,999.99');
            v_dtl.Paid             := TO_CHAR(NVL(rec.pd_ds, 0),'9,999,999,999.99');
            v_dtl.catastrophic_cd  := rec.catastrophic_cd;
            v_dtl.OUTSTANDING_RI           := TO_CHAR(NVL(rec.os_rids, 0),'9,999,999,999.99');
            v_dtl.PAID_RI           := TO_CHAR(NVL(rec.pd_rids, 0),'9,999,999,999.99');
            
            BEGIN
                  SELECT trty_name 
                  INTO v_dtl.treaty
                  FROM giis_dist_share
                 WHERE share_cd = rec.grp_seq_no
                   AND line_cd = rec.line_cd;
            EXCEPTION
                WHEN no_data_found THEN
                     v_dtl.treaty := NULL;
            END;
            
            FOR i IN (SELECT catastrophic_desc, start_date, end_date
                        FROM gicl_cat_dtl
                       WHERE catastrophic_cd = rec.catastrophic_cd)
            LOOP
                  v_dtl.CATASTROPHIC_EVENT_DESCRIPTION := i.catastrophic_desc;
                  v_dtl.CATASTROPHIC_EVENT_TO := TO_CHAR(i.start_date, 'FmMonth DD, YYYY');
                  v_dtl.CATASTROPHIC_EVENT_FROM := TO_CHAR(i.end_date, 'FmMonth DD, YYYY');
--                IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
--                      v_dtl.Catastrophic_event := v_dtl.Catastrophic_event || '(' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') ||
--                                                 ' - ' || TO_CHAR(i.end_date, 'FmMonth DD, YYYY') || ')';
--                END IF;
                
            END LOOP;
            
            BEGIN
                SELECT ri_sname
                  INTO v_dtl.reinsurer
                  FROM giis_reinsurer
                 WHERE ri_cd = rec.ri_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dtl.reinsurer := NULL;
            END;
            
           IF rec.shr_ri_pct IS NOT NULL
           THEN 
                BEGIN            
                    SELECT TO_CHAR(rec.shr_ri_pct, '999.00')||'%'
                      INTO v_dtl.share_pct
                      FROM dual;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_dtl.share_pct := NULL;
                END;
           END IF;
            PIPE ROW(v_dtl);
            
            
         --v_dtl.cf_title := '';
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW(v_dtl);
        END IF;
        
    END get_report_details;   
    
    
    FUNCTION get_remittance(
        p_session_id        gicl_os_pd_clm_rids_extr.session_id%TYPE,
        p_ri_cd             gicl_os_pd_clm_rids_extr.ri_cd%TYPE
    ) RETURN giclr200b_remittance_tab PIPELINED
    IS
        v_rem        giclr200b_remittance_type;
        v_count      NUMBER(1) := 0;
    BEGIN
        
        FOR i IN (SELECT DISTINCT ri_cd
                    FROM gicl_os_pd_clm_rids_extr a, gicl_os_pd_clm_ds_extr b
                   WHERE a.session_id       = p_session_id
                     AND a.ri_cd            = NVL(p_ri_cd, a.ri_cd)
                     AND a.session_id       = b.session_id
                     AND a.os_pd_ds_rec_id  = b.os_pd_ds_rec_id
                     AND b.share_type       = (SELECT param_value_v
                                                 FROM giac_parameters
                                                WHERE param_name = 'XOL_TRTY_SHARE_TYPE')
                   ORDER BY ri_cd)
        LOOP
            
            v_count := 1;
            v_rem.ri_cd := i.ri_cd;
            
            FOR j IN (SELECT A.A180_RI_CD ri_cd, A.COLLECTION_AMT,  TRUNC(C.OR_DATE) or_date
                        FROM giac_loss_ri_collns a, gicl_os_pd_clm_extr b, giac_order_of_payts c
                       WHERE A.CLAIM_ID     = B.CLAIM_ID
                         AND A.GACC_TRAN_ID = C.GACC_TRAN_ID
                         AND C.OR_FLAG      = 'P'
                         AND B.SESSION_ID   = p_session_id
                         AND a.a180_ri_cd   = i.ri_cd)
            LOOP
                v_count := 2;
                v_rem.collection_amt := j.collection_amt;
                v_rem.or_date        := j.or_date;
                v_rem.ri_cd          := j.ri_Cd;
                v_rem.tag            := 'Y';
            END LOOP;
            
            
            BEGIN
              SELECT SUM (NVL (a.pd_loss, 0) + NVL (a.pd_exp, 0))
                INTO v_rem.pd_losses  
                FROM gicl_os_pd_clm_rids_extr a, gicl_os_pd_clm_ds_extr b
               WHERE a.session_id       = p_session_id
                 AND a.session_id       = b.session_id
                 AND a.os_pd_rec_id     = b.os_pd_rec_id
                 AND a.os_pd_ds_rec_id  = b.os_pd_ds_rec_id
                 AND a.ri_cd            = i.ri_cd
                 AND b.share_type       = (SELECT param_value_v
                                             FROM giac_parameters
                                            WHERE param_name = 'XOL_TRTY_SHARE_TYPE');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     v_rem.pd_losses := NULL;
            END;
            
            -- FOR TESTING ONLY
           /*IF v_count = 1 THEN
                v_rem.ri_cd          := i.ri_Cd;
                v_rem.collection_amt := 1.00;
                v_rem.or_date        := sysdate;
                v_rem.tag            := 'Y';
            END IF;*/
            
            PIPE ROW(v_rem);
        END LOOP;
        
    END get_remittance;
    
END CSV_GICLR200B_PKG;
/
