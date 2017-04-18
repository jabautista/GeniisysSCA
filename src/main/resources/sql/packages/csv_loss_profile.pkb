CREATE OR REPLACE PACKAGE BODY CPI.CSV_LOSS_PROFILE AS
  /* Modified by   : Edison
  ** Date modified : 08.15.2012
  ** Modifications : Removed all utl.file functions and replaced by PIPE function.
  **                 This is to print directly the report into CSV.
  **                 Changed PROCEDURE to FUNCTION.
  **                 Applied to CSV_GICLR211 and CSV_GICLR215*/
  FUNCTION CSV_GICLR211(p_line_cd           VARCHAR2,
                        p_user           VARCHAR2,
                        p_subline_cd        VARCHAR2) RETURN giclr211_type PIPELINED --Edison 08.15.2012
                      --  p_file_name      VARCHAR2
  IS
    --v_file              UTL_FILE.FILE_TYPE; --Edison 08.15.2012
    v_giclr211          giclr211_rec_type; --Edison 08.15.2012
    v_columns           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_line              VARCHAR2(30);
    v_max_range         NUMBER;
    v_range             VARCHAR2(50);
    v_total_clm_count   NUMBER(6);
    v_total_tsi_amt     NUMBER(20,2);
    v_total_gross_loss  NUMBER(20,2);
    v_total_net_ret     NUMBER(16,2);
    v_total_treaty      NUMBER(16,2);
    v_total_xol_treaty  NUMBER(16,2);
    v_total_facul       NUMBER(16,2);
  BEGIN 
    --v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W'); Edison 08.15.2012
    FOR x in  (SELECT DISTINCT line_cd
                 FROM gicl_loss_profile
                WHERE line_cd = NVL (p_line_cd, line_cd)
                  AND user_id = UPPER (p_user)
                  AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
             ORDER BY line_cd)
    LOOP
      FOR i IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = x.line_cd)
      LOOP
        v_line := x.line_cd||' - '||i.line_name;
      END LOOP;
      
      v_total_clm_count   := 0;
      v_total_tsi_amt     := 0;
      v_total_gross_loss  := 0;
      v_total_net_ret     := 0;
      v_total_treaty      := 0;
      v_total_xol_treaty  := 0;
      v_total_facul       := 0;
      
      /* Comment out by Edison 08.15.2012
      utl_file.put_line(v_file,'Line: '||v_line);
      utl_file.put_line(v_file,' ');
      utl_file.put_line(v_file, 'RANGE,CLAIM COUNT, SUM INSURED, GROSS LOSS, NET RETENTION, PROPORTIONAL TREATY, NON PROPORTIONAL TREATY, FACULTATIVE');          
      */
      
      FOR rec IN (SELECT range_from, 
                         range_to, 
                         line_cd, 
                         policy_count, 
                         net_retention,
                         quota_share, 
                         treaty, 
                         NVL(total_tsi_amt, 0) total_tsi_amt,
                         facultative,
                         (NVL(net_retention, 0) + NVL (treaty, 0) + NVL (facultative, 0) + NVL (xol_treaty, 0)) gross_loss,
                         xol_treaty
                    FROM gicl_loss_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND line_cd = x.line_cd
                     AND user_id = UPPER (p_user)
                     AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                ORDER BY line_cd, range_from ASC)
      LOOP    
        FOR A IN (SELECT MAX(range_to) range_to
	                FROM gicl_loss_profile
	               WHERE line_cd = nvl(p_line_cd, line_cd)
	                 AND user_id = p_user
	                 AND range_to <> 99999999999999.99) 
        LOOP
          v_max_range := a.range_to;
          EXIT;
        END LOOP;
      
        IF to_char(rec.range_to,'99,999,999,999,999.99') <> TO_CHAR(99999999999999.99,'99,999,999,999,999.99') THEN
           v_range := to_char(rec.range_from,'fm99,999,999,999,999.00')||' - '||to_char(rec.range_to,'fm99,999,999,999,999.00');
	    ELSE
           v_range := 'OVER '||to_char(v_max_range,'fm99,999,999,999,999.00');
	    END IF;    
      
        /* Comment out by Edison 08.15.2012
        utl_file.put_line(v_file, '"'||v_range||'",'||rec.policy_count||','||rec.total_tsi_amt||
                                  ','||rec.gross_loss||','||nvl(rec.net_retention,0)||','||nvl(rec.treaty,0)||
                                  ','||nvl(rec.xol_treaty, 0)||','||nvl(rec.facultative,0));*/
                                  
        --Added by Edison 08.15.2012, this will be the columns to be printed in CSV
        v_giclr211.rnge          := v_range;
        v_giclr211.claim_cnt     := rec.policy_count;
        v_giclr211.total_tsi_amt := rec.total_tsi_amt;
        v_giclr211.gross_loss    := NVL(rec.gross_loss,0);
        v_giclr211.net_ret       := NVL(rec.net_retention,0);
        v_giclr211.prop_trty     := NVL(rec.treaty,0);   
        v_giclr211.nprop_trty    := NVL(rec.xol_treaty,0);
        v_giclr211.facultative   := NVL(rec.facultative,0);
        
        PIPE ROW(v_giclr211);
        --End 08.15.2012
                          
        v_total_clm_count   := v_total_clm_count + nvl(rec.policy_count, 0);
        v_total_tsi_amt     := v_total_tsi_amt + nvl(rec.total_tsi_amt, 0);
        v_total_gross_loss  := v_total_gross_loss + nvl(rec.gross_loss,0);
        v_total_net_ret     := v_total_net_ret + nvl(rec.net_retention, 0);
        v_total_treaty      := v_total_treaty + nvl(rec.treaty, 0);
        v_total_xol_treaty  := v_total_xol_treaty + nvl(rec.xol_treaty,0);
        v_total_facul       := v_total_facul + nvl(rec.facultative, 0);  
        
      END LOOP;
      
      /* Comment out by Edison 08.15.2012
      utl_file.put_line(v_file, 'Totals :,'||v_total_clm_count||','||v_total_tsi_amt||
                                        ','||v_total_gross_loss||','||v_total_net_ret||
                                        ','||v_total_treaty||','||v_total_xol_treaty||
                                        ','||v_total_facul);*/
      --Added by Edison 08.15.2012, to print the totals in CSV. 
      v_giclr211.rnge          := 'Totals :';                       
      v_giclr211.claim_cnt     := v_total_clm_count;
      v_giclr211.total_tsi_amt := v_total_tsi_amt;
      v_giclr211.gross_loss    := v_total_gross_loss;
      v_giclr211.net_ret       := NVL(v_total_net_ret,0);
      v_giclr211.prop_trty     := NVL(v_total_treaty,0);   
      v_giclr211.nprop_trty    := NVL(v_total_xol_treaty,0);
      v_giclr211.facultative   := NVL(v_total_facul,0);
        
      PIPE ROW(v_giclr211);
      --End 08.15.2012
    END LOOP;
    --utl_file.fclose(v_file); --Edison 08.15.2012
    RETURN; --Edison 08.15.2012
  END;
  
  FUNCTION CSV_GICLR215(p_line_cd           VARCHAR2,
                        p_user           VARCHAR2,
                        p_loss_sw        VARCHAR2,
                        p_loss_date_from DATE,
                        p_loss_date_to   DATE,
                        p_subline_cd        VARCHAR2) RETURN giclr215_type PIPELINED --Edison 08.15.2012
                   --     p_file_name      VARCHAR2
  IS
    --v_file              UTL_FILE.FILE_TYPE; Edison 08.15.2012
    v_giclr215          giclr215_rec_type; --Edison 08.15.2012
    v_line              VARCHAR2(30);
    v_max_range         NUMBER;
    v_range             VARCHAR2(50);
    v_net_ret           NUMBER(16,2);
    v_facul             NUMBER(16,2);
    v_treaty            NUMBER(16,2);
    v_xol_treaty        NUMBER(16,2);
    v_gross_loss        NUMBER(20,2);
    v_net_ret_rcvry     NUMBER(16,2);
    v_facul_rcvry       NUMBER(16,2);
    v_treaty_rcvry      NUMBER(16,2);
    v_xol_treaty_rcvry  NUMBER(16,2);
    v_gross_loss_rcvry  NUMBER(20,2);
    v_total_gross_loss  NUMBER(20,2);
    v_total_net_ret     NUMBER(16,2);
    v_total_treaty      NUMBER(16,2);
    v_total_xol_treaty  NUMBER(16,2);
    v_total_facul       NUMBER(16,2);
    v_gtotal_gross_loss NUMBER(20,2);
    v_gtotal_net_ret    NUMBER(16,2);
    v_gtotal_treaty     NUMBER(16,2);
    v_gtotal_xol_treaty NUMBER(16,2);
    v_gtotal_facul      NUMBER(16,2);
    v_param_value_v    giac_parameters.param_value_v%TYPE;     
  BEGIN
    --v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W'); --Edison 08.15.2012
    FOR x in  (SELECT DISTINCT line_cd
                 FROM gicl_loss_profile
                WHERE line_cd = NVL (p_line_cd, line_cd)
                  AND user_id = UPPER (p_user)
                  AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
             ORDER BY line_cd)
    LOOP
      FOR i IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = x.line_cd)
      LOOP
        v_line := x.line_cd||' - '||i.line_name;
      END LOOP;
      
      v_gtotal_gross_loss  := 0;
      v_gtotal_net_ret     := 0;
      v_gtotal_treaty      := 0;
      v_gtotal_xol_treaty  := 0;
      v_gtotal_facul       := 0;
      
      /* Comment out by Edison 08.15.2012
      utl_file.put_line(v_file,'Line: '||v_line);
      utl_file.put_line(v_file,' ');
      utl_file.put_line(v_file, 'POLICY NUMBER,TOTAL SUM INSURED, CLAIM NUMBER, ASSURED, GROSS_LOSS, NET RETENTION, PROPORTIONAL TREATY, NON PROPORTIONAL TREATY, FACULTATIVE');          
      */
      
      FOR y in (SELECT DISTINCT range_from,
                                range_to
                           FROM gicl_loss_profile
                          WHERE line_cd = NVL (p_line_cd, line_cd)
                            AND line_cd = x.line_cd
                            AND user_id = UPPER (p_user)
                            AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                       ORDER BY range_from) 
      LOOP
        FOR A IN (SELECT MAX(range_to) range_to
	                FROM gicl_loss_profile
	               WHERE line_cd = nvl(p_line_cd, line_cd)
	                 AND user_id = p_user
	          AND range_to <> 99999999999999.99) 
        LOOP
          v_max_range := a.range_to;
          EXIT;
        END LOOP;
      
        IF to_char(y.range_to,'99,999,999,999,999.99') <> TO_CHAR(99999999999999.99,'99,999,999,999,999.99') THEN
           v_range := to_char(y.range_from,'fm99,999,999,999,999.00')||' - '||to_char(y.range_to,'fm99,999,999,999,999.00');
	    ELSE
           v_range := 'OVER '||to_char(v_max_range,'fm99,999,999,999,999.00');
	    END IF;
      
        v_total_gross_loss  := 0;
        v_total_net_ret     := 0;
        v_total_treaty      := 0;
        v_total_xol_treaty  := 0;
        v_total_facul       := 0;
                 
        --utl_file.put_line(v_file,'"Range: '||v_range||'"'); --Edison 08.15.2012
    
        FOR rec IN (SELECT A.RANGE_FROM, 
                           A.RANGE_TO, 
                           B.TSI_AMT, 
                           a.line_cd, 
                           a.subline_cd,
                           b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(b.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')) POL,
                           c.line_cd||'-'||c.subline_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(c.clm_seq_no,'0000009')) CLM, 
                           c.clm_stat_cd, 
                           c.assured_name, 
                           c.clm_file_date, 
                           c.loss_date,
                           c.claim_id
                      FROM GICL_LOSS_PROFILE A, 
                           GICL_LOSS_PROFILE_EXT2 B, 
                           GICL_CLAIMS C
                     WHERE a.LINE_CD = NVL(P_LINE_CD,a.LINE_CD)
                       AND a.LINE_CD = x.LINE_CD
                       AND a.RANGE_FROM = y.range_from
                       AND a.RANGE_TO = y.range_to 
                       AND a.USER_ID = UPPER(P_USER)
                       AND NVL(a.subline_cd,'*') = NVL(p_subline_cd, '*')
                       AND b.tsi_amt >= a.range_from
                       AND b.tsi_amt <= a.range_to
                       AND a.line_cd = b.line_cd
                       AND NVL(a.subline_cd,b.subline_cd) = b.subline_cd      
                       AND c.line_cd = b.line_cd
                       AND c.subline_cd = b.subline_cd
                       AND c.pol_iss_cd = b.pol_iss_cd
                       AND c.issue_yy    = b.issue_yy
                       AND c.pol_seq_no = b.pol_seq_no
                       AND c.renew_no  = b.renew_no
                       AND c.clm_stat_cd NOT IN ('CC','DN','WD')
                       AND DECODE(p_loss_sw,'FD', TRUNC(c.clm_file_date),'LD', TRUNC(c.loss_date),SYSDATE) >=Trunc(p_loss_date_from)     
                       AND DECODE(p_loss_sw,'FD', TRUNC(c.clm_file_date),'LD', TRUNC(c.loss_date),SYSDATE) <=Trunc(p_loss_date_to)
                  GROUP BY A.RANGE_FROM, A.RANGE_TO,b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(b.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')), a.line_cd, a.subline_cd,B.TSI_AMT,
                           c.line_cd||'-'||c.subline_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.clm_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(c.clm_seq_no,'0000009')) , c.clm_stat_cd, c.assured_name, c.clm_file_date, c.loss_date,c.claim_id
                  ORDER BY b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(b.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')) ASC)
        LOOP
      
          FOR i IN (SELECT param_value_v
    	              FROM giac_parameters
   	                 WHERE param_name = 'XOL_TRTY_SHARE_TYPE')
          LOOP
            v_param_value_v :=  i.param_value_v;
          END LOOP;
      
          IF rec.clm_stat_cd <> 'CD' THEN
             FOR i IN (SELECT SUM(DECODE(c018.share_type, 1, NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0), 0)) net_ret, 
                              SUM(DECODE(c018.share_type, 2, NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0), 0)) treaty,
                              SUM(DECODE(c018.share_type, 3, NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0), 0)) facultative,
                              SUM(DECODE(c018.share_type, v_param_value_v, NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0), 0)) xol_treaty
                         FROM gicl_clm_res_hist c017,
                              gicl_reserve_ds   c018
                        WHERE c017.claim_id = rec.claim_id
                          AND c017.claim_id         = c018.claim_id
                          AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                          AND NVL(c017.dist_sw,'N') = 'Y'
                          AND DECODE(p_loss_sw,'FD', TRUNC(rec.clm_file_date),'LD', TRUNC(rec.loss_date),SYSDATE) >= Trunc(p_loss_date_from)   
                          AND DECODE(p_loss_sw,'FD', TRUNC(rec.clm_file_date),'LD', TRUNC(rec.loss_date),SYSDATE) <= Trunc(p_loss_date_to))
             LOOP
               v_net_ret := NVL(i.net_ret, 0);
               v_treaty := NVL(i.treaty, 0);
               v_facul := NVL(i.facultative, 0);
               v_xol_treaty := NVL(i.xol_treaty, 0);
             END LOOP;
          ELSIF rec.clm_stat_cd = 'CD' THEN
             FOR i IN (SELECT SUM(DECODE(share_type, 1, NVL(c018.shr_le_net_amt,0), 0)) net_ret,
                              SUM(DECODE(share_type, 2, NVL(c018.shr_le_net_amt,0), 0)) treaty,
                              SUM(DECODE(share_type, 3, NVL(c018.shr_le_net_amt,0), 0)) facultative,
                              SUM(DECODE(share_type, 4, NVL(c018.shr_le_net_amt,0), 0)) xol_treaty
                         FROM gicl_clm_res_hist c017,
                              gicl_clm_loss_exp c016, 
                              gicl_loss_exp_ds   c018
                        WHERE c017.claim_id = rec.claim_id
                          AND NVL(c017.cancel_tag,'N') = 'N'
                          AND c017.tran_id IS NOT NULL
                          AND DECODE(p_loss_sw,'FD', TRUNC(rec.clm_file_date),'LD', TRUNC(rec.loss_date),SYSDATE) >= TRUNC(p_loss_date_from)   
                          AND DECODE(p_loss_sw,'FD', TRUNC(rec.clm_file_date),'LD', TRUNC(rec.loss_date),SYSDATE) <= TRUNC(p_loss_date_to)
                          AND c016.claim_id = c017.claim_id
                          AND c016.tran_id  = c017.tran_id
                          AND c016.item_no  = c017.item_no
                          AND c016.peril_cd = c017.peril_cd
                          AND c018.claim_id = c016.claim_id     
                          AND c018.clm_loss_id = c016.clm_loss_id     
                          AND nvl(c018.negate_tag, 'N') = 'N')
             LOOP
               v_net_ret := NVL(i.net_ret, 0);
               v_treaty := NVL(i.treaty, 0);
               v_facul := NVL(i.facultative, 0);
               v_xol_treaty := NVL(i.xol_treaty, 0);
             END LOOP;       
          END IF;              
          
          v_gross_loss := NVL(v_net_ret, 0) + NVL(v_treaty, 0) + NVL(v_facul, 0) + NVL(v_xol_treaty, 0);
          v_total_gross_loss  := v_total_gross_loss + nvl(v_gross_loss,0);
          v_total_net_ret     := v_total_net_ret + nvl(v_net_ret, 0);
          v_total_treaty      := v_total_treaty + nvl(v_treaty, 0);
          v_total_xol_treaty  := v_total_xol_treaty + nvl(v_xol_treaty,0);
          v_total_facul       := v_total_facul + nvl(v_facul, 0);
          
          /* Comment out by Edison 08.15.2012
          utl_file.put_line(v_file, rec.pol||','||rec.tsi_amt||','||rec.clm||',"'||rec.assured_name||
                                  '",'||v_gross_loss||','||nvl(v_net_ret,0)||','||nvl(v_treaty,0)||
                                  ','||nvl(v_xol_treaty, 0)||','||nvl(v_facul,0));*/
                                  
          --Added by Edison 08.15.2012, this will be the columns to be printed in CSV.
          v_giclr215.policy_no      := rec.pol;
          v_giclr215.total_tsi_amt  := rec.tsi_amt;
          v_giclr215.claim_no       := rec.clm;
          v_giclr215.assd_name      := rec.assured_name;
          v_giclr215.gross_loss     := v_gross_loss;
          v_giclr215.net_ret        := NVL(v_net_ret,0); 
          v_giclr215.prop_trty      := NVL(v_treaty,0);
          v_giclr215.nprop_trty     := NVL(v_xol_treaty,0);
          v_giclr215.facultative    := NVL(v_facul,0);   
                 
          PIPE ROW(v_giclr215);
          --END 08.15.2012
         
          FOR rcvry IN (SELECT recovery_id, 
                               claim_id, 
                               line_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(SUBSTR(rec_year,3),'09'))||'-'||LTRIM(TO_CHAR(rec_seq_no,'000009')) REC
                          FROM gicl_clm_recovery
                         WHERE claim_id = rec.claim_id)
          LOOP
      
            FOR i IN (SELECT -SUM(DECODE(share_type, 1,NVL(c018.shr_recovery_amt,0), 0)) net_ret,
                             -SUM(DECODE(share_type, 2,NVL(c018.shr_recovery_amt,0), 0)) treaty,
                             -SUM(DECODE(share_type, 3,NVL(c018.shr_recovery_amt,0), 0)) facultative,
                             -SUM(DECODE(share_type, 4,NVL(c018.shr_recovery_amt,0), 0)) xol_treaty
                        FROM gicl_recovery_payt c017 ,
                             gicl_recovery_ds   c018
                       WHERE c017.claim_id = rec.claim_id
                         AND c017.recovery_id = rcvry.recovery_id
                         AND NVL(c017.cancel_tag,'N') = 'N'
                         AND DECODE(p_loss_sw,'FD', TRUNC(rec.clm_file_date),'LD', TRUNC(rec.loss_date),SYSDATE)>=TRUNC(p_loss_date_from)   
                         AND DECODE(p_loss_sw,'FD', TRUNC(rec.clm_file_date),'LD', TRUNC(rec.loss_date),SYSDATE)<=TRUNC(p_loss_date_to)
                         AND TO_NUMBER(TO_CHAR(rec.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))                
                         AND c017.recovery_id = c018.recovery_id
                         AND c017.recovery_payt_id = c018.recovery_payt_id
                         AND nvl(c018.negate_tag, 'N') = 'N')
            LOOP
              v_net_ret_rcvry := NVL(i.net_ret, 0);
              v_treaty_rcvry := NVL(i.treaty, 0);
              v_facul_rcvry := NVL(i.facultative, 0);
              v_xol_treaty_rcvry := NVL(i.xol_treaty, 0);
            END LOOP;
            
            v_gross_loss_rcvry := NVL(v_net_ret_rcvry, 0) + NVL(v_treaty_rcvry, 0) + NVL(v_facul_rcvry, 0) + NVL(v_xol_treaty_rcvry, 0);
            v_total_gross_loss  := v_total_gross_loss + nvl(v_gross_loss_rcvry,0);
            v_total_net_ret     := v_total_net_ret + nvl(v_net_ret_rcvry, 0);
            v_total_treaty      := v_total_treaty + nvl(v_treaty_rcvry, 0);
            v_total_xol_treaty  := v_total_xol_treaty + nvl(v_xol_treaty_rcvry,0);
            v_total_facul       := v_total_facul + nvl(v_facul_rcvry, 0);
            
            /* Comment out by Edison 08.15.2012
            utl_file.put_line(v_file,',,,Recovery No.: '||rcvry.rec||
                                  ','||v_gross_loss_rcvry||','||nvl(v_net_ret_rcvry,0)||','||nvl(v_treaty_rcvry,0)||
                                  ','||nvl(v_xol_treaty_rcvry, 0)||','||nvl(v_facul_rcvry,0));*/
            
            --Added by Edison 08.15.2012, this will be the columns to be printed in CSV.          
            v_giclr215.policy_no      := NULL;
            v_giclr215.total_tsi_amt  := NULL;
            v_giclr215.claim_no       := NULL;
            v_giclr215.assd_name      := 'Recovery No : ' || rcvry.rec;
            v_giclr215.gross_loss     := v_gross_loss_rcvry;
            v_giclr215.net_ret        := NVL(v_net_ret_rcvry,0); 
            v_giclr215.prop_trty      := NVL(v_treaty_rcvry,0);
            v_giclr215.nprop_trty     := NVL(v_xol_treaty_rcvry,0);
            v_giclr215.facultative    := NVL(v_facul_rcvry,0);
            
            PIPE ROW(v_giclr215);
            --END 08.15.2012
            
          END LOOP;
        END LOOP;
        
        /* Comment out by Edison 08.15.2012
        utl_file.put_line(v_file,',,,Range Totals:,'||v_total_gross_loss||','||nvl(v_total_net_ret,0)||','||nvl(v_total_treaty,0)||
                                  ','||nvl(v_total_xol_treaty, 0)||','||nvl(v_total_facul,0));
        utl_file.put_line(v_file, ' ');*/
                                  
        v_gtotal_gross_loss  := v_gtotal_gross_loss + v_total_gross_loss;
        v_gtotal_net_ret     := v_gtotal_net_ret + v_total_net_ret;
        v_gtotal_treaty      := v_gtotal_treaty + v_total_treaty;
        v_gtotal_xol_treaty  := v_gtotal_xol_treaty + v_total_xol_treaty;
        v_gtotal_facul       := v_gtotal_facul + v_total_facul;
        
        --Added by Edison 08.15.2012, to print the Ranged Totals in CSV.         
        v_giclr215.policy_no      := NULL;
        v_giclr215.total_tsi_amt  := NULL;
        v_giclr215.claim_no       := NULL;
        v_giclr215.assd_name      := 'Ranged Totals : ';
        v_giclr215.gross_loss     := NVL(v_total_gross_loss,0);
        v_giclr215.net_ret        := NVL(v_total_net_ret,0); 
        v_giclr215.prop_trty      := NVL(v_total_treaty,0);
        v_giclr215.nprop_trty     := NVL(v_total_xol_treaty,0);
        v_giclr215.facultative    := NVL(v_total_facul,0);
        PIPE ROW(v_giclr215);
        --Added by Edison 08.15.2012, to have a NULL row in CSV.
        v_giclr215.policy_no      := NULL;
        v_giclr215.total_tsi_amt  := NULL;
        v_giclr215.claim_no       := NULL;
        v_giclr215.assd_name      := NULL;
        v_giclr215.gross_loss     := NULL;
        v_giclr215.net_ret        := NULL; 
        v_giclr215.prop_trty      := NULL;
        v_giclr215.nprop_trty     := NULL;
        v_giclr215.facultative    := NULL;
        PIPE ROW(v_giclr215);
        --END 08.15.2012
      END LOOP;
      
      /* Comment out by Edison 08.15.2012
      utl_file.put_line(v_file,',,,Grand Totals:,'||v_gtotal_gross_loss||','||nvl(v_gtotal_net_ret,0)||','||nvl(v_gtotal_treaty,0)||
                                 ','||nvl(v_gtotal_xol_treaty, 0)||','||nvl(v_gtotal_facul,0));*/
                                 
       --Added by Edison 08.15.2012, to print the Grand Totals in CSV.         
       v_giclr215.policy_no      := NULL;
       v_giclr215.total_tsi_amt  := NULL;
       v_giclr215.claim_no       := NULL;
       v_giclr215.assd_name      := 'Grand Totals : ';
       v_giclr215.gross_loss     := NVL(v_gtotal_gross_loss,0);
       v_giclr215.net_ret        := NVL(v_gtotal_net_ret,0); 
       v_giclr215.prop_trty      := NVL(v_gtotal_treaty,0);
       v_giclr215.nprop_trty     := NVL(v_gtotal_xol_treaty,0);
       v_giclr215.facultative    := NVL(v_gtotal_facul,0);
       PIPE ROW(v_giclr215);                          
      RETURN; --Edison 08.15.2012
    END LOOP;
    --utl_file.fclose(v_file);
  END;
END;
/


