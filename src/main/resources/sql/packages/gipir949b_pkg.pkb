CREATE OR REPLACE PACKAGE BODY CPI.GIPIR949B_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.20.2013
     ** Referenced By:  GIPIR949B - Risk Profile By Line
     **/
    
    FUNCTION populate_report(
        p_line_cd           gipi_risk_profile_dtl.LINE_CD%type,
        p_subline_cd        gipi_risk_profile_dtl.SUBLINE_CD%type,
        p_starting_date     VARCHAR2,
        p_ending_date       VARCHAR2,
        p_all_line_tag      VARCHAR2,
        p_param_date        VARCHAR2,
        p_claim_date        VARCHAR2,
        p_loss_date_from    VARCHAR2,
        p_loss_date_to      VARCHAR2,
        p_user              gipi_risk_profile_dtl.USER_ID%type
    ) RETURN report_tab PIPELINED
    AS
        rep                 report_type;
        v_print             boolean := false;
        v_title 	        varchar2(100);
        v_starting_date     DATE := TO_DATE(p_starting_date, 'MM-DD-RRRR');
        v_ending_date       DATE := TO_DATE(p_ending_date, 'MM-DD-RRRR');
        v_loss_date_from    DATE := TO_DATE(p_loss_date_from, 'MM-DD-RRRR');
        v_loss_date_to      DATE := TO_DATE(p_loss_date_to, 'MM-DD-RRRR');
    BEGIN
        begin
            select param_value_v
              into rep.company_name
              from giis_parameters
             where param_name = 'COMPANY_NAME';
        exception
            when no_data_found then
                rep.company_name := ' ';
        end;
        
        begin
            select param_value_v
              into rep.company_address
              from giis_parameters
             where param_name = 'COMPANY_ADDRESS';
        exception
            when no_data_found then
                rep.company_address := ' ';
        end;
        
        BEGIN 
            SELECT line_cd||' - '||line_name
              INTO rep.line
              FROM giis_line
             WHERE line_cd = p_line_cd;
        
        EXCEPTION
	        WHEN NO_DATA_FOUND THEN
	            rep.line := null;
	    END;
        
        rep.top_date1:= 'BASED ON ' || p_param_date || ' ( ' || TO_CHAR(v_starting_date, 'fmMonth DD, RRRR') 
                        || ' - ' || TO_CHAR(v_ending_date, 'fmMonth DD, RRRR') || ' )'; 
                        
        rep.top_date2:= 'BASED ON ' || p_claim_date || ' ( ' || TO_CHAR(v_loss_date_from, 'fmMonth DD, RRRR') 
                        || ' - ' || TO_CHAR(v_loss_date_to, 'fmMonth DD, RRRR') || ' )';  
                                       
                        
        FOR i IN (SELECT  a.range_from ,LTRIM(TO_CHAR(a.range_from,'999,999,999,999,999'))||' - '||LTRIM(TO_CHAR(a.range_to,'999,999,999,999,999')) range 
                           ,d.pol,c.item_no,c.tsi_amt ,c.prem_amt,d.net_tsi ,d.net_prem,d.treaty_tsi
                           ,d.treaty_prem,d.facul_tsi ,d.facul_prem 
                      FROM  gipi_risk_profile_item a 
                           ,(SELECT b.line_cd ||'-'|| b.subline_cd ||'-'|| b.iss_cd ||'-'|| b.issue_yy ||'-'|| LTRIM(TO_CHAR(b.pol_seq_no,'0000009')) 
                                        ||'-'|| LTRIM(TO_CHAR(b.renew_no,'09')) pol 
                                   ,a.item_no,SUM(a.tsi_amt) tsi_amt,SUM(a.prem_amt) prem_amt 
                               FROM gipi_polbasic b 
                                   ,gipi_item a 
                              WHERE a.policy_id = b.policy_id  
                                AND a.policy_id IN (SELECT policy_id FROM gipi_polrisk_item_ext)  
                              GROUP BY b.line_cd ||'-'|| b.subline_cd ||'-'|| b.iss_cd ||'-'|| b.issue_yy ||'-'|| LTRIM(TO_CHAR(b.pol_seq_no,'0000009')) 
                                        ||'-'|| LTRIM(TO_CHAR(b.renew_no,'09')) 
                                   ,a.item_no) c 
                           ,(SELECT b.line_cd ,b.subline_cd 
                                   ,b.line_cd ||'-'|| b.subline_cd ||'-'|| b.iss_cd ||'-'|| b.issue_yy ||'-'|| LTRIM(TO_CHAR(b.pol_seq_no,'0000009')) 
                                                ||'-'|| LTRIM(TO_CHAR(b.renew_no,'09')) pol 
                                   ,b.item_no,SUM(NVL(netret.dist_tsi,0)) net_tsi, SUM(NVL(netret.dist_prem,0)) net_prem 
                                   ,SUM(NVL(treaty.dist_tsi,0)) treaty_tsi,SUM(NVL(treaty.dist_prem,0)) treaty_prem 
                                   ,SUM(NVL(facul.dist_tsi,0)) facul_tsi,SUM(NVL(facul.dist_prem,0)) facul_prem 
                               FROM (SELECT dist_no, item_no, line_cd, dist_tsi, dist_prem FROM giuw_itemds_dtl WHERE share_cd = 1) netret 
                                   ,(SELECT dist_no, item_no, line_cd, dist_tsi, dist_prem FROM giuw_itemds_dtl WHERE share_cd NOT IN (1, 999)) treaty 
                                   ,(SELECT dist_no, item_no, line_cd, dist_tsi, dist_prem FROM giuw_itemds_dtl WHERE share_cd = 999) facul 
                                   ,gipi_polrisk_item_ext b 
                              WHERE netret.dist_no = b.dist_no 
                                AND netret.item_no = b.item_no 
                                AND netret.line_cd = b.line_cd 
                                AND netret.dist_no = facul.dist_no(+) 
                                AND netret.item_no = facul.item_no(+) 
                                AND netret.line_cd = facul.line_cd(+) 
                                AND netret.item_no = treaty.item_no(+) 
                                AND netret.dist_no = treaty.dist_no(+) 
                                AND netret.line_cd = treaty.line_cd(+) 
                                AND b.user_id = UPPER(p_user) 
                              GROUP BY b.line_cd 
                                   ,b.subline_cd 
                                   ,b.line_cd ||'-'|| b.subline_cd ||'-'|| b.iss_cd ||'-'|| b.issue_yy ||'-'|| LTRIM(TO_CHAR(b.pol_seq_no,'0000009')) ||'-'|| LTRIM(TO_CHAR(b.renew_no,'09')) 
                                   ,b.item_no) d 
                     WHERE a.line_cd = NVL(p_line_cd, a.line_cd) 
                       AND NVL(a.subline_cd,'***') = NVL(p_subline_cd,'***') 
                       AND a.user_id = UPPER(p_user) 
                       AND TRUNC(a.date_from) = v_starting_date 
                       AND TRUNC(a.date_to) = v_ending_date
                       AND a.all_line_tag = p_all_line_tag
                       AND d.line_cd = a.line_cd 
                       AND d.subline_cd = NVL(a.subline_cd,d.subline_cd) 
                       AND c.pol = d.pol 
                       AND c.item_no = d.item_no 
                       AND c.tsi_amt BETWEEN a.range_from AND a.range_to 
                     ORDER BY a.range_from, d.pol, c.item_no )
        LOOP
            v_print             := true;
            rep.print_detail    := 'Y';
            rep.range_from      := i.range_from;
            rep.range           := i.range;
            rep.pol             := i.pol;
            rep.item_no         := i.item_no;
            rep.tsi_amt         := i.tsi_amt;
            rep.prem_amt        := i.prem_amt;
            rep.net_tsi         := i.net_tsi;
            rep.net_prem        := i.net_prem;
            rep.treaty_tsi      := i.treaty_tsi;
            rep.treaty_prem     := i.treaty_prem;
            rep.facul_tsi       := i.facul_tsi;
            rep.facul_prem      := i.facul_prem;
            
            begin
                FOR x IN (SELECT item_no||' '||item_title item
                            FROM gipi_item a, gipi_polbasic b
                           WHERE a.policy_id = b.policy_id
                             AND b.line_cd ||'-'|| b.subline_cd ||'-'|| b.iss_cd ||'-'|| b.issue_yy ||'-'|| 
                                    LTRIM(TO_CHAR(b.pol_seq_no,'0000009')) ||'-'|| LTRIM(TO_CHAR(b.renew_no,'09')) = i.pol
                             AND (a.policy_id, a.item_no) IN (SELECT MAX(b.policy_id), b.item_no 
                                                                FROM gipi_polrisk_item_ext b
                                                               WHERE line_cd = p_line_cd
                                                               GROUP BY b.line_cd ||'-'|| b.subline_cd ||'-'|| b.iss_cd ||'-'|| b.issue_yy ||'-'|| 
                                                                        LTRIM(TO_CHAR(b.pol_seq_no,'0000009')) ||'-'|| LTRIM(TO_CHAR(b.renew_no,'09')), 
                                                                        b.item_no)
              
                             AND a.item_no = i.item_no
                           ORDER BY b.endt_seq_no DESC) 
                LOOP
                    v_title := x.item; 
                    EXIT;
                END LOOP;
                         
                rep.item_title := v_title;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rep.item_title := null;
            end;
            
            PIPE ROW(rep);
        END LOOP;
        
         IF v_print = false THEN
            rep.print_detail := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;

END GIPIR949B_PKG;
/


