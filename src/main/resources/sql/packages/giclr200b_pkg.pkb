CREATE OR REPLACE PACKAGE BODY CPI.GICLR200B_PKG
AS

    FUNCTION get_report_details(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_as_of_date    DATE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE
    ) RETURN giclr200b_tab PIPELINED
    IS
        v_dtl       giclr200b_type;
        v_count     NUMBER(1) := 0;
    BEGIN
    
        BEGIN 
            SELECT PARAM_VALUE_V
              INTO v_dtl.company_name
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                v_dtl.company_name := NULL;
        END; 
    
        BEGIN 
            SELECT PARAM_VALUE_V
              INTO v_dtl.company_address
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                v_dtl.company_address := NULL;
        END; 
    
        BEGIN
	        SELECT report_title 
	          INTO v_dtl.cf_title
              FROM giis_reports
	         WHERE report_id = 'GICLR200B';
        EXCEPTION
	        WHEN no_data_found THEN
	            v_dtl.cf_title := null;
        END;
    
        SELECT 'As of '||TO_CHAR(p_as_of_date,'fmMonth DD, YYYY')
          INTO v_dtl.cf_date
          FROM dual;
    
        FOR rec IN (  SELECT a.catastrophic_cd, a.line_cd, b.share_type, b.grp_seq_no, c.ri_cd, c.shr_ri_pct,
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
            v_dtl.catastrophic_cd   := rec.catastrophic_cd;
            v_dtl.line_cd           := NVL(rec.line_cd, '');
            v_dtl.share_type        := rec.share_type;
            v_dtl.grp_seq_no        := rec.grp_seq_no;
            v_dtl.ri_cd             := rec.ri_cd;
            v_dtl.shr_ri_pct        := rec.shr_ri_pct;
            v_dtl.os_ds             := NVL(rec.os_ds, 0);
            v_dtl.pd_ds             := NVL(rec.pd_ds, 0);
            v_dtl.os_rids           := NVL(rec.os_rids, 0);
            v_dtl.pd_rids           := NVL(rec.pd_rids, 0);
            
            v_dtl.total_ds          := NVL(rec.os_ds, 0) + NVL(rec.pd_ds, 0);
            v_dtl.total_rids        := NVL(rec.os_rids, 0) + NVL(rec.pd_rids, 0);
            
            BEGIN
  	            SELECT trty_name 
                  INTO v_dtl.trty_name
                  FROM giis_dist_share
                 WHERE share_cd = rec.grp_seq_no
                   AND line_cd = rec.line_cd;
            EXCEPTION
                WHEN no_data_found THEN
                     v_dtl.trty_name := NULL;
            END;
            
            FOR i IN (SELECT catastrophic_desc, start_date, end_date
                        FROM gicl_cat_dtl
                       WHERE catastrophic_cd = rec.catastrophic_cd
                       ORDER BY catastrophic_desc)
            LOOP
  	            v_dtl.catastrophic_desc := i.catastrophic_desc;
  	            
                IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
  		            v_dtl.catastrophic_desc := v_dtl.catastrophic_desc || '(' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') ||
  		                                       ' - ' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') || ')';
  	            END IF;
                
            END LOOP;
            
            BEGIN
                SELECT ri_sname
                  INTO v_dtl.ri_sname
                  FROM giis_reinsurer
                 WHERE ri_cd = rec.ri_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dtl.ri_sname := NULL;
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
           ELSE
           v_dtl.share_pct := '';
           END IF;
           
--           added by gab 12.21.2016
           BEGIN 
               SELECT line_name
                 INTO v_dtl.line_name
                 FROM GIIS_LINE
                WHERE line_cd = rec.line_cd;
           EXCEPTION
               WHEN NO_DATA_FOUND THEN 
                   v_dtl.line_name := NULL;
           END; 
            
            PIPE ROW(v_dtl);
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
                v_rem.ri_cd          := j.ri_cd;
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
    
--    added by gab 12.08.2016 SR 5850
    FUNCTION get_col_tab (p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
        )
      RETURN col_tab PIPELINED
   IS
      v                   col_type;
      v_col_count         NUMBER        := 1;
      v_report_paramter   VARCHAR2 (50);
   BEGIN
      FOR i IN (SELECT c.ri_cd, c.shr_ri_pct, a.catastrophic_cd, a.line_cd, b.share_type
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
                         AND a.catastrophic_cd  = p_catastrophic_cd
                         AND a.line_cd          = p_line_cd
                       GROUP BY a.catastrophic_cd, a.line_cd, b.share_type, c.ri_cd, c.shr_ri_pct
                       UNION
                      SELECT NULL ri_cd, NULL shr_ri_pct, a.catastrophic_cd,
                             DECODE(share_type, 1, null, 3, null, a.line_cd) line_cd, 
                             b.share_type
                        FROM gicl_os_pd_clm_extr a,
                             gicl_os_pd_clm_ds_extr b,
                             gicl_cat_dtl c
                       WHERE a.session_id   = b.session_id
                         AND a.claim_id     = b.claim_id
                         AND a.os_pd_rec_id = b.os_pd_rec_id
                         AND b.share_type   <> 4
                         AND a.session_id   = p_session_id
                         AND a.catastrophic_cd  = p_catastrophic_cd
                         AND a.line_cd      = p_line_cd
                         AND b.grp_seq_no = giisp.n('NET_RETENTION')
                         AND b.grp_seq_no = giisp.n('FACULTATIVE')
                         AND share_type <> 1
                       GROUP BY a.catastrophic_cd, DECODE(b.share_type, 1, null, 3, null, a.line_cd), b.share_type    
                       ORDER BY catastrophic_cd, share_type, line_cd)
      LOOP
          BEGIN
                SELECT ri_sname
                  INTO v.ri_sname0
                  FROM giis_reinsurer
                 WHERE ri_cd = i.ri_cd;
          EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v.ri_sname0 := NULL;
          END;
            
           IF i.shr_ri_pct IS NOT NULL
           THEN 
                BEGIN            
                    SELECT TO_CHAR(i.shr_ri_pct, '999.00')||'%'
                      INTO v.share_ri_pct0
                      FROM dual;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v.share_ri_pct0 := NULL;
                END;
           ELSE
           v.share_ri_pct0 := '';
           END IF;
      
         IF v_col_count = 1
         THEN
            v.ri_sname1     := v.ri_sname0;
            v.share_ri_pct1 := v.share_ri_pct0;
            v.catastrophic_cd1 := i.catastrophic_cd;
            v.ri_cd1        := i.ri_cd;
         ELSIF v_col_count = 2
         THEN
            v.ri_sname2     := v.ri_sname0;
            v.share_ri_pct2 := v.share_ri_pct0;
            v.catastrophic_cd2 := i.catastrophic_cd;
            v.ri_cd2        := i.ri_cd;
         ELSIF v_col_count = 3
         THEN
            v.ri_sname3     := v.ri_sname0;
            v.share_ri_pct3 := v.share_ri_pct0;
            v.catastrophic_cd3 := i.catastrophic_cd;
            v.ri_cd3        := i.ri_cd;
         ELSIF v_col_count = 4
         THEN
            v.ri_sname4     := v.ri_sname0;
            v.share_ri_pct4 := v.share_ri_pct0;
            v.catastrophic_cd4 := i.catastrophic_cd;
            v.ri_cd4        := i.ri_cd;
            PIPE ROW (v);
            v.row_count     := v.row_count + 1;
            v.catastrophic_cd1  := NULL;
            v.catastrophic_cd2  := NULL;
            v.catastrophic_cd3  := NULL;
            v.catastrophic_cd4  := NULL;
            v.ri_sname0     := NULL;
            v.ri_sname1     := NULL;
            v.ri_sname2     := NULL;
            v.ri_sname3     := NULL;
            v.ri_sname4     := NULL;
            v.share_ri_pct0 := NULL;
            v.share_ri_pct1 := NULL;
            v.share_ri_pct2 := NULL;
            v.share_ri_pct3 := NULL;
            v.share_ri_pct4 := NULL;
            v.ri_cd1        := NULL;
            v.ri_cd2        := NULL;
            v.ri_cd3        := NULL;
            v.ri_cd4        := NULL;
            v_col_count := 0;
         END IF;

         v_col_count := v_col_count + 1;
      END LOOP;

      IF v_col_count <> 1
      THEN
         PIPE ROW (v);
      END IF;
   END get_col_tab;
   
   FUNCTION get_giclr200b_treaty (
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
        )
      RETURN treaty_tab PIPELINED
      
    IS
        v       treaty_type;
    
    BEGIN
            FOR i IN(SELECT   a.catastrophic_cd, a.line_cd, b.share_type, d.trty_name,
                              b.grp_seq_no,
                              SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                              SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds
                         FROM gicl_os_pd_clm_extr a,
                              gicl_os_pd_clm_ds_extr b,
                              giis_dist_share d
                        WHERE a.session_id = b.session_id
                          AND a.claim_id = b.claim_id
                          AND a.os_pd_rec_id = b.os_pd_rec_id
                          AND b.share_type = 4
                          AND a.line_cd = d.line_cd
                          AND b.grp_seq_no = d.share_cd
                          AND a.session_id = p_session_id
                          AND a.catastrophic_cd = p_catastrophic_cd
                          AND a.line_cd = p_line_cd
                     GROUP BY a.catastrophic_cd, a.line_cd, b.share_type, d.trty_name,
                              b.grp_seq_no
                     UNION
                     SELECT   a.catastrophic_cd,
                              DECODE (b.share_type, 1, NULL, 3, NULL, a.line_cd) line_cd,
                              b.share_type, d.trty_name, b.grp_seq_no,
                              SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                              SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds
                         FROM gicl_os_pd_clm_extr a,
                              gicl_os_pd_clm_ds_extr b,
                              gicl_cat_dtl c,
                              giis_dist_share d
                        WHERE a.session_id = b.session_id
                          AND a.claim_id = b.claim_id
                          AND a.os_pd_rec_id = b.os_pd_rec_id
                          AND b.share_type <> 4
                          AND a.line_cd = d.line_cd
                          AND b.grp_seq_no = d.share_cd
                          AND a.session_id = p_session_id
                          AND b.grp_seq_no = giisp.n ('NET_RETENTION')
                          AND b.grp_seq_no = giisp.n ('FACULTATIVE')
                          AND b.share_type <> 1
                          AND a.line_cd = p_line_cd
                     GROUP BY a.catastrophic_cd,
                              DECODE (b.share_type, 1, NULL, 3, NULL, a.line_cd),
                              b.share_type,
                              b.grp_seq_no,
                              d.trty_name
                     ORDER BY catastrophic_cd, share_type, line_cd, grp_seq_no   
                )
        LOOP
            v.catastrophic_cd   := i.catastrophic_cd;
            v.line_cd           := i.line_cd;
            v.share_type        := i.share_type;
            v.trty_name         := i.trty_name;
            v.grp_seq_no        := i.grp_seq_no;
            v.os_ds             := i.os_ds;
            v.pd_ds             := i.pd_ds;
            v.total_ds          := NVL(v.os_ds, 0) + NVL(v.pd_ds, 0);
            
            PIPE ROW(v);
        
        END LOOP;
    
    END;
    
    FUNCTION get_giclr200b_treaty_total (
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
        )
      RETURN treaty_total_tab PIPELINED
      
    IS
        v       treaty_total_type;
    
    BEGIN
            FOR i IN(SELECT   a.catastrophic_cd, a.line_cd, b.share_type,
                              SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                              SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds
                         FROM gicl_os_pd_clm_extr a,
                              gicl_os_pd_clm_ds_extr b
                        WHERE a.session_id = b.session_id
                          AND a.claim_id = b.claim_id
                          AND a.os_pd_rec_id = b.os_pd_rec_id
                          AND b.share_type = 4
                          AND a.session_id = p_session_id
                          AND a.catastrophic_cd = p_catastrophic_cd
                          AND a.line_cd = p_line_cd
                     GROUP BY a.catastrophic_cd, a.line_cd, b.share_type
                     UNION
                     SELECT   a.catastrophic_cd,
                              DECODE (b.share_type, 1, NULL, 3, NULL, a.line_cd) line_cd,
                              b.share_type,
                              SUM (NVL (b.os_loss, 0) + NVL (b.os_exp, 0)) os_ds,
                              SUM (NVL (b.pd_loss, 0) + NVL (b.pd_exp, 0)) pd_ds
                         FROM gicl_os_pd_clm_extr a,
                              gicl_os_pd_clm_ds_extr b,
                              gicl_cat_dtl c
                        WHERE a.session_id = b.session_id
                          AND a.claim_id = b.claim_id
                          AND a.os_pd_rec_id = b.os_pd_rec_id
                          AND b.share_type <> 4
                          AND a.session_id = p_session_id
                          AND a.line_cd = p_line_cd
                          AND b.grp_seq_no = giisp.n ('NET_RETENTION')
                          AND b.grp_seq_no = giisp.n ('FACULTATIVE')
                          AND b.share_type <> 1
                     GROUP BY a.catastrophic_cd,
                              DECODE (b.share_type, 1, NULL, 3, NULL, a.line_cd),
                              b.share_type
                     ORDER BY catastrophic_cd, share_type, line_cd  
                )
        LOOP
            v.catastrophic_cd   := i.catastrophic_cd;
            v.line_cd           := i.line_cd;
            v.share_type        := i.share_type;
            v.tot_os_ds         := i.os_ds;
            v.tot_pd_ds         := i.pd_ds;
            v.tot_total_ds      := NVL(v.tot_os_ds, 0) + NVL(v.tot_pd_ds, 0);
            
            PIPE ROW(v);
        
        END LOOP;
    
    END;
    
    FUNCTION get_giclr200b_ri (p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE)
      RETURN ri_tab PIPELINED
   IS
      v             ri_type;
      v_os_ri         NUMBER;
      v_pd_ri        NUMBER;
      v_count       NUMBER          := 1;
      v_row_count   NUMBER          := 1;
      cursor group_five IS
      
      SELECT   a.catastrophic_cd, a.line_cd, b.share_type, d.trty_name,
                              b.grp_seq_no
                         FROM gicl_os_pd_clm_extr a,
                              gicl_os_pd_clm_ds_extr b,
                              giis_dist_share d
                        WHERE a.session_id = b.session_id
                          AND a.claim_id = b.claim_id
                          AND a.os_pd_rec_id = b.os_pd_rec_id
                          AND b.share_type = 4
                          AND a.line_cd = d.line_cd
                          AND b.grp_seq_no = d.share_cd
                          AND a.session_id = p_session_id
                          AND a.catastrophic_cd = p_catastrophic_cd
                     GROUP BY a.catastrophic_cd, a.line_cd, b.share_type, d.trty_name,
                              b.grp_seq_no
                     UNION
                     SELECT   a.catastrophic_cd,
                              DECODE (b.share_type, 1, NULL, 3, NULL, a.line_cd) line_cd,
                              b.share_type, d.trty_name, b.grp_seq_no
                         FROM gicl_os_pd_clm_extr a,
                              gicl_os_pd_clm_ds_extr b,
                              gicl_cat_dtl c,
                              giis_dist_share d
                        WHERE a.session_id = b.session_id
                          AND a.claim_id = b.claim_id
                          AND a.os_pd_rec_id = b.os_pd_rec_id
                          AND b.share_type <> 4
                          AND a.line_cd = d.line_cd
                          AND b.grp_seq_no = d.share_cd
                          AND a.session_id = p_session_id
                          AND b.grp_seq_no = giisp.n ('NET_RETENTION')
                          AND b.grp_seq_no = giisp.n ('FACULTATIVE')
                          AND b.share_type <> 1
                     GROUP BY a.catastrophic_cd,
                              DECODE (b.share_type, 1, NULL, 3, NULL, a.line_cd),
                              b.share_type,
                              b.grp_seq_no,
                              d.trty_name
                     ORDER BY catastrophic_cd, share_type, line_cd, grp_seq_no ;
   BEGIN
      FOR i IN (SELECT c.ri_cd, c.shr_ri_pct, a.catastrophic_cd, a.line_cd, b.share_type, b.grp_seq_no,
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
                         AND a.catastrophic_cd  = p_catastrophic_cd
                         AND a.line_cd          = p_line_cd
                       GROUP BY a.catastrophic_cd, a.line_cd, b.share_type, c.ri_cd, c.shr_ri_pct, b.grp_seq_no
                       UNION
                      SELECT NULL ri_cd, NULL shr_ri_pct, a.catastrophic_cd,
                             DECODE(share_type, 1, null, 3, null, a.line_cd) line_cd, 
                             b.share_type, b.grp_seq_no,
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
                         AND a.catastrophic_cd  = p_catastrophic_cd
                         AND a.line_cd          = p_line_cd
                         AND b.grp_seq_no = giisp.n('NET_RETENTION')
                         AND b.grp_seq_no = giisp.n('FACULTATIVE')
                         AND share_type <> 1
                       GROUP BY a.catastrophic_cd, DECODE(b.share_type, 1, null, 3, null, a.line_cd), b.share_type, b.grp_seq_no    
                       ORDER BY catastrophic_cd, share_type, line_cd, grp_seq_no)
      LOOP
         FOR j IN group_five  
         LOOP
            IF v.grp_seq_no <> i.grp_seq_no
            THEN
               PIPE ROW (v);
               v.row_count := 1;
               v_count := 1;
               v.os_rids1 := 0;
               v.os_rids2 := 0;
               v.os_rids3 := 0;
               v.os_rids4 := 0;
               v.pd_rids1 := 0;
               v.pd_rids2 := 0;
               v.pd_rids3 := 0;
               v.pd_rids4 := 0;
            END IF;

            
            v.grp_seq_no := i.grp_seq_no;

            IF i.grp_seq_no = j.grp_seq_no
            THEN
               v_os_ri := i.os_rids;
               v_pd_ri := i.pd_rids;
               EXIT;
            ELSE
               v_os_ri := 0;
               v_pd_ri := 0;
            END IF;
         END LOOP;

         IF v_count = 1
         THEN
            v.os_rids1 := v_os_ri;
            v.pd_rids1 := v_pd_ri;
           
         ELSIF v_count = 2
         THEN
            v.os_rids2 := v_os_ri;
            v.pd_rids2 := v_pd_ri;
         ELSIF v_count = 3
         THEN
            v.os_rids3 := v_os_ri;
            v.pd_rids3 := v_pd_ri;
              
         ELSIF v_count = 4
         THEN
            v.os_rids4 := v_os_ri;
            v.pd_rids4 := v_pd_ri;
            PIPE ROW (v);
            v.row_count := v.row_count + 1;
            v_count := 0;
            v.os_rids1 := 0;
            v.os_rids2 := 0;
            v.os_rids3 := 0;
            v.os_rids4 := 0;
            v.pd_rids1 := 0;
            v.pd_rids2 := 0;
            v.pd_rids3 := 0;
            v.pd_rids4 := 0;
            
         END IF;

         v_count := v_count + 1;
      END LOOP;

      IF v_count <> 1
      THEN
         PIPE ROW (v);
      END IF;
   END get_giclr200b_ri;
   
   FUNCTION get_giclr200b_ri_total (p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE)
      RETURN ri_total_tab PIPELINED
   IS
      v                   ri_total_type;
      v_col_count         NUMBER        := 1;
      
   BEGIN
      FOR i IN (SELECT c.ri_cd, a.catastrophic_cd, a.line_cd, b.share_type, 
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
                         AND a.catastrophic_cd  = p_catastrophic_cd
                         AND a.line_cd          = p_line_cd
                       GROUP BY a.catastrophic_cd, a.line_cd, b.share_type, c.ri_cd
                       UNION
                      SELECT NULL ri_cd, a.catastrophic_cd,
                             DECODE(share_type, 1, null, 3, null, a.line_cd) line_cd, 
                             b.share_type,
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
                         AND a.catastrophic_cd  = p_catastrophic_cd
                         AND a.line_cd          = p_line_cd
                         AND b.grp_seq_no = giisp.n('NET_RETENTION')
                         AND b.grp_seq_no = giisp.n('FACULTATIVE')
                         AND share_type <> 1
                       GROUP BY a.catastrophic_cd, DECODE(b.share_type, 1, null, 3, null, a.line_cd), b.share_type  
                       ORDER BY catastrophic_cd, share_type, line_cd)
      LOOP
      
         IF v_col_count = 1
         THEN
            v.tot_os_rids1     := i.os_rids;
            v.tot_pd_rids1     := i.pd_rids;
            v.total_rids1      := NVL(v.tot_os_rids1, 0) + NVL(v.tot_pd_rids1, 0);
         ELSIF v_col_count = 2
         THEN
            v.tot_os_rids2     := i.os_rids;
            v.tot_pd_rids2     := i.pd_rids;
            v.total_rids2      := NVL(v.tot_os_rids2, 0) + NVL(v.tot_pd_rids2, 0);
         ELSIF v_col_count = 3
         THEN
            v.tot_os_rids3     := i.os_rids;
            v.tot_pd_rids3     := i.pd_rids;
            v.total_rids3      := NVL(v.tot_os_rids3, 0) + NVL(v.tot_pd_rids3, 0);
         ELSIF v_col_count = 4
         THEN
            v.tot_os_rids4     := i.os_rids;
            v.tot_pd_rids4     := i.pd_rids;
            v.total_rids4      := NVL(v.tot_os_rids4, 0) + NVL(v.tot_pd_rids4, 0);
            PIPE ROW (v);
            v.row_count    := v.row_count + 1;
            v.tot_os_rids1 := NULL;
            v.tot_os_rids2 := NULL;
            v.tot_os_rids3 := NULL;
            v.tot_os_rids4 := NULL;
            v.tot_pd_rids1 := NULL;
            v.tot_pd_rids2 := NULL;
            v.tot_pd_rids3 := NULL;
            v.tot_pd_rids4 := NULL;
            v.total_rids1  := NULL;
            v.total_rids2  := NULL;
            v.total_rids3  := NULL;
            v.total_rids4  := NULL;

            v_col_count := 0;
         END IF;

         v_col_count := v_col_count + 1;
      END LOOP;

      IF v_col_count <> 1
      THEN
         PIPE ROW (v);
      END IF;
   END get_giclr200b_ri_total;
    
END GICLR200B_PKG;
/
