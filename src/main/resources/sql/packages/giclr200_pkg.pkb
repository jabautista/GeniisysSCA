CREATE OR REPLACE PACKAGE BODY CPI.GICLR200_PKG
AS

    FUNCTION get_report_details(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_as_of_date    DATE
    ) RETURN giclr200_tab PIPELINED    
    IS
        v_count     NUMBER(1) := 0;
        v_dtl  giclr200_type;            
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
	         WHERE report_id = 'GICLR200';
        EXCEPTION
	        WHEN no_data_found THEN
	            v_dtl.cf_title := null;
        END;
    
        SELECT 'As of '||TO_CHAR(p_as_of_date,'fmMonth DD, YYYY')
          INTO v_dtl.cf_date
          FROM dual;
    
        FOR rec IN (SELECT clm_cnt,     claim_id,       claim_no,       assured_name, 
                           loss_loc,    policy_no,      tsi_amt,        loss_cat_cd, 
                           loss_date,   os_loss,        os_exp,         gross_loss,
                           pd_loss,     pd_exp,         clm_stat_cd,    line_cd,
                           iss_cd,      catastrophic_cd 
                      FROM gicl_os_pd_clm_extr 
                     WHERE session_id = p_session_id
                     ORDER BY catastrophic_cd, iss_cd, line_cd, clm_cnt)
        LOOP
            v_count := 1;
            
            v_dtl.clm_cnt       := rec.clm_cnt;
            v_dtl.claim_id      := rec.claim_id;
            v_dtl.claim_no      := rec.claim_no;
            v_dtl.assured_name  := rec.assured_name;
            v_dtl.loss_loc      := rec.loss_loc;
            v_dtl.policy_no     := rec.policy_no;
            v_dtl.tsi_amt       := rec.tsi_amt;
            v_dtl.loss_cat_cd   := rec.loss_cat_cd;
            v_dtl.loss_date     := rec.loss_date;
            v_dtl.os_loss       := rec.os_loss;
            v_dtl.os_exp        := rec.os_exp;
            v_dtl.gross_loss    := rec.gross_loss;
            v_dtl.pd_loss       := rec.pd_loss;
            v_dtl.pd_exp        := rec.pd_exp;
            v_dtl.clm_stat_cd   := rec.clm_stat_cd;
            v_dtl.line_cd       := rec.line_cd;
            v_dtl.iss_cd        := rec.iss_cd;
            v_dtl.catastrophic_cd := rec.catastrophic_cd;
            
            v_dtl.total_os      := NVL(rec.os_loss, 0) + NVL(rec.os_exp, 0);
            v_dtl.total_pd      := NVL(rec.pd_loss, 0) + NVL(rec.pd_exp, 0);
            
            BEGIN
                SELECT loss_cat_des
                  INTO v_dtl.loss_category
                  FROM giis_loss_ctgry
                 WHERE loss_cat_cd  = rec.loss_cat_cd
                   AND line_cd      = rec.line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dtl.loss_category := NULL;
            END;
            
            IF rec.clm_stat_cd = 'CD' THEN
                v_dtl.clm_status := 'CLOSED';
            ELSIF rec.clm_stat_cd NOT IN ('CD', 'WD', 'DN', 'CC') THEN
                v_dtl.clm_status := 'OPEN';
            END IF;
            
            FOR i IN (SELECT catastrophic_desc, start_date, end_date
                        FROM gicl_cat_dtl
                       WHERE catastrophic_cd = rec.catastrophic_cd)
            LOOP
  	            v_dtl.catastrophic_desc := i.catastrophic_desc;
  	            
                IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
  		            v_dtl.catastrophic_desc := v_dtl.catastrophic_desc || '(' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') ||
  		                                       ' - ' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') || ')';
  	            END IF;
                
            END LOOP;
            
            BEGIN
                SELECT iss_name
                  INTO v_dtl.iss_name
                  FROM giis_issource
                 WHERE iss_cd = rec.iss_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dtl.iss_name := NULL;
            END;
            
             BEGIN
                SELECT line_name
                  INTO v_dtl.line_name
                  FROM giis_line
                 WHERE line_cd = rec.line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_dtl.line_name := NULL;
            END;
            
            PIPE ROW(v_dtl);
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW (v_dtl);
        END IF;
    
    END get_report_details;
    
    
    FUNCTION get_report_summary(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE        
    ) RETURN giclr200_summ_tab PIPELINED
    IS
        v_summ      giclr200_summ_type;
    BEGIN
    
        FOR rec IN ( SELECT b.catastrophic_cd, a.grp_seq_no, a.share_type, 
                            line_cd, --null line_cd, -- kris: replaced null with line_cd
                            SUM (NVL (a.os_loss, 0) + NVL (a.os_exp, 0)) os,
                            SUM (NVL (a.pd_loss, 0) + NVL (a.pd_exp, 0)) pd
                      FROM gicl_os_pd_clm_ds_extr a, gicl_os_pd_clm_extr b
                     WHERE b.session_id = P_SESSION_ID
                       AND a.session_id = b.session_id
                       AND a.os_pd_rec_id = b.os_pd_rec_id
                       AND a.claim_id = b.claim_id
                       AND a.share_type in (1, 3)
                     GROUP BY a.grp_seq_no, b.catastrophic_cd, a.share_type, line_cd
                     UNION
                    SELECT b.catastrophic_cd, a.grp_seq_no, a.share_type, b.line_cd,
                           SUM (NVL (a.os_loss, 0) + NVL (a.os_exp, 0)) os,
                           SUM (NVL (a.pd_loss, 0) + NVL (a.pd_exp, 0)) pd
                      FROM gicl_os_pd_clm_ds_extr a, gicl_os_pd_clm_extr b
                     WHERE b.session_id = P_SESSION_ID
                       AND a.session_id = b.session_id
                       AND a.os_pd_rec_id = b.os_pd_rec_id
                       AND a.claim_id = b.claim_id
                       AND a.share_type not in (1, 3)
                     GROUP BY a.grp_seq_no, b.catastrophic_cd, a.share_type, b.line_cd
                     ORDER BY catastrophic_cd, share_type, grp_seq_no, line_cd)
        LOOP
            v_summ.catastrophic_cd  := rec.catastrophic_cd;
            v_summ.grp_seq_no       := rec.grp_seq_no;
            v_summ.share_type       := rec.share_type;
            v_summ.line_cd          := rec.line_cd;
            v_summ.os               := rec.os;
            v_summ.pd               := rec.pd;
            v_summ.total            := NVL(rec.pd, 0) + NVL(rec.os, 0);
            
            BEGIN
  	            SELECT trty_name 
                  INTO v_summ.trty_name
                  FROM giis_dist_share
                 WHERE share_cd = rec.grp_seq_no
                   AND line_cd = rec.line_cd;
            EXCEPTION
                WHEN no_data_found THEN
                     v_summ.trty_name := NULL;
            END;
            
            FOR i IN (SELECT catastrophic_desc, start_date, end_date
                        FROM gicl_cat_dtl
                       WHERE catastrophic_cd = rec.catastrophic_cd)
            LOOP
  	            v_summ.catastrophic_desc := i.catastrophic_desc;
  	            
                IF i.start_date IS NOT NULL AND i.end_date IS NOT NULL THEN
  		            v_summ.catastrophic_desc := v_summ.catastrophic_desc || '(' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') ||
  		                                       ' - ' || TO_CHAR(i.start_date, 'FmMonth DD, YYYY') || ')';
  	            END IF;
                
            END LOOP;
            
            PIPE ROW(v_summ);
        END LOOP;
    
    END get_report_summary;
    
END GICLR200_PKG;
/


