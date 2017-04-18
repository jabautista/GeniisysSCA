CREATE OR REPLACE PACKAGE BODY CPI.GICLR256_PKG
AS

    FUNCTION populate_giclr256(
        p_line_cd       VARCHAR2,
        p_loss_cat      VARCHAR2,
        p_search_by     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
    RETURN giclr256_report_tab PIPELINED
    AS
    v_list      giclr256_report_type;
    v_not_exist     BOOLEAN := true;
    BEGIN
        FOR i IN (
            SELECT f.line_cd||'-'||f.line_name line,d.loss_cat_des,
                   get_claim_number(a.claim_id) claim_no, get_policy_no(get_policy_id(E.LINE_CD,E.SUBLINE_CD,E.POL_ISS_CD,E.ISSUE_YY, E.POL_SEQ_NO,E.RENEW_NO)) policy_no,
                   E.ASSURED_NAME assd_name,e.dsp_loss_date,
                   ltrim(to_char(b.item_no,'00009'))||'-'||b.item_title item, b.item_title item_title, c.peril_name peril_name, E.CLAIM_ID,B.ITEM_NO,A.PERIL_CD,
                   NVL(e.exp_pd_amt,0) exp_pd_amt, NVL(e.exp_res_amt,0)  * NVL(g.convert_rate,0) exp_res_amt, NVL(e.loss_pd_amt,0) loss_pd_amt, NVL(e.loss_res_amt,0) * NVL(g.convert_rate,0) loss_res_amt
              FROM gicl_item_peril a,                                   
                   gicl_clm_item b,                                     
                   giis_peril c,                                        
                   giis_loss_ctgry d,                                   
                   gicl_claims e,                                       
                   giis_line f,
                   gicl_clm_reserve g,               
                   giis_clm_stat h      
             WHERE a.claim_id = b.claim_id
               AND a.grouped_item_no = b.grouped_item_no
               AND e.claim_id = a.claim_id
               AND d.line_cd=a.line_cd
               AND e.line_cd=a.line_cd 
               AND d.loss_cat_cd=a.loss_cat_cd
               AND a.peril_cd = c.peril_cd      
               AND a.line_cd = c.line_cd
               AND d.line_cd = f.line_cd
               AND d.line_cd = p_line_cd
               AND d.loss_cat_cd = p_loss_cat
               AND a.item_no = b.item_no
               AND g.claim_id(+) = a.claim_id
               AND g.peril_cd(+) = a.peril_cd
               AND g.item_no(+) = a.item_no
               AND h.clm_stat_cd = e.clm_stat_cd
               AND CHECK_USER_PER_LINE(a.LINE_CD,ISS_CD,'GICLS256')=1
               AND (DECODE(p_search_by, 1,TO_DATE(e.clm_file_date), 2, TO_DATE(e.loss_date)) >= TO_DATE(p_from_date,'MM-DD-YYYY')
               AND DECODE(p_search_by, 1,TO_DATE(e.clm_file_date), 2, TO_DATE(e.loss_date)) <= TO_DATE(p_to_date,'MM-DD-YYYY')
                OR DECODE(p_search_by, 1,TO_DATE(e.clm_file_date), 2, TO_DATE(e.loss_date)) <= TO_DATE(p_as_of_date,'MM-DD-YYYY'))
            ORDER BY claim_no, policy_no  
        )
        LOOP
            v_not_exist := false;
            v_list.line         := i.line;         
            v_list.loss_cat_des := i.loss_cat_des; 
            v_list.claim_no     := i.claim_no;     
            v_list.policy_no    := i.policy_no;   
            v_list.assd_name    := i.assd_name;   
            v_list.dsp_loss_date:= i.dsp_loss_date;
            v_list.item         := i.item;         
            v_list.item_title   := i.item_title;   
            v_list.peril_name   := i.peril_name;   
            v_list.claim_id     := i.claim_id;     
            v_list.item_no      := i.item_no;      
            v_list.peril_cd     := i.peril_cd;
            v_list.loss_res_amt  := i.loss_res_amt;   
            v_list.loss_pd_amt   := i.loss_pd_amt;     
            v_list.exp_res_amt   := i.exp_res_amt;      
            v_list.exp_pd_amt    := i.exp_pd_amt;
            
           PIPE ROW(v_list); 
        END LOOP;
        
        IF v_not_exist THEN
            v_list.not_exist     := 'T';
            PIPE ROW(v_list);
        END IF;
        RETURN;
    END;
    
    FUNCTION get_giclr256_header(
        p_search_by     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
        RETURN giclr256_header_tab PIPELINED
    IS
        v_list giclr256_header_type;
    BEGIN
        select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
        select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
        
        IF p_search_by = 1 THEN
            IF p_as_of_date IS NOT NULL THEN
                v_list.report_date := 'Claim File Date As of '||to_char(TO_DATE(p_as_of_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
            ELSE
                v_list.report_date := 'Claim File Date From '||to_char(TO_DATE(p_from_date,'MM-DD-YYYY'),'fmMonth DD, RRRR')||' to '||to_char(TO_DATE(p_to_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
            END IF;
            
        ELSIF p_search_by = 2 THEN
            IF p_as_of_date IS NOT NULL THEN
                v_list.report_date := 'Loss Date As of '||to_char(TO_DATE(p_as_of_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
            ELSE
                v_list.report_date := 'Loss Date From '||to_char(TO_DATE(p_from_date,'MM-DD-YYYY'),'fmMonth DD, RRRR')||' to '||to_char(TO_DATE(p_to_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
            END IF;
            
        ELSE
            v_list.report_date := ' ';
     
        END IF;
                
        PIPE ROW(v_list);
        RETURN;
    END get_giclr256_header;
END giclr256_pkg;
/


