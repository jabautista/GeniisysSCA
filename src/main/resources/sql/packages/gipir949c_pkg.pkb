CREATE OR REPLACE PACKAGE BODY CPI.GIPIR949C_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   9.23.2013
     ** Referenced By:  GIPIR949C - Risk Profile By Risk
     **/

    FUNCTION populate_report(
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    ) RETURN report_tab PIPELINED
    AS
        rep         report_type;
        v_print     boolean := false;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO rep.company_name
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.company_name := ' ';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO rep.company_address
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                rep.company_address := NULL;
        END;
        
        rep.top_header := 'Based on ' || TO_CHAR(TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR') || 
                           ' - ' || TO_CHAR(TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR'); 
        
        FOR i IN  ( SELECT b.ranges, a.block_risk, b.range_from, SUM(a.sum_insured) sum_insured, SUM(a.prem_amt) prem_amt, SUM(a.risk_count) risk_count
                      FROM ( SELECT a1.line_cd, a1.subline_cd, a1.iss_cd, a1.issue_yy, a1.pol_seq_no, a1.renew_no, 
                                    (DECODE(NVL(a1.risk_cd,'*'),'*',a3.block_desc, (SELECT risk_desc FROM giis_risks WHERE risk_cd=a1.risk_cd) || ' / ' || a3.block_desc)) block_risk, 
                                    SUM(a1.ann_tsi_amt) sum_insured, SUM(a2.prem_amt) prem_amt, COUNT(a1.ann_tsi_amt) risk_count
                               FROM gipi_polrisk_item_ext a1, 
                                    gipi_item a2, 
                                    giis_block a3                 
                              WHERE a1.policy_id = a2.policy_id 
                                AND a1.item_no = a2.item_no 
                                AND a1.line_cd = 'FI' 
                                AND a1.block_id = a3.block_id
                                AND a1.user_id = USER             
                              GROUP BY a1.line_cd, a1.subline_cd, a1.iss_cd, a1.issue_yy, a1.pol_seq_no, a1.renew_no, a1.risk_cd, block_desc 
                              ORDER BY block_risk, sum_insured) A, 
                            (SELECT LTRIM(TO_CHAR(x.RANGE_FROM,'999,999,999,999,999')) ||' - '|| 
                                    LTRIM(DECODE((LTRIM(TO_CHAR(x.RANGE_TO,'999,999,999,999,999'))),'100,000,000,000,000','OVER',(TO_CHAR(x.RANGE_TO,'999,999,999,999,999')))) AS "RANGES", 
                                    x.range_from, x.range_to, x.line_cd, x.subline_cd, x.date_from, x.date_to
                               FROM GIPI_RISK_PROFILE_ITEM x 
                              WHERE 1=1 
                                AND x.line_cd = 'FI'
                                AND (x.date_from = TO_DATE(p_from_date, 'MM-DD-RRRR') AND x.date_to = TO_DATE(p_to_date, 'MM-DD-RRRR'))
                              GROUP BY x.range_from, x.range_to, x.line_cd, x.subline_cd, x.date_from, x.date_to) B
                     WHERE (a.sum_insured(+)) BETWEEN b.range_from AND b.range_to
                       AND b.date_from =  TO_DATE(p_from_date, 'MM-DD-RRRR')
                       AND b.date_to =  TO_DATE(p_to_date, 'MM-DD-RRRR')
                     GROUP BY b.ranges, a.block_risk, b.range_from
                     ORDER BY b.range_from, a.block_risk ASC)
        LOOP
            rep.print_details   := 'Y';
            v_print             := true;
            rep.ranges          := i.ranges;
            rep.range_from      := i.range_from;
            rep.block_risk      := i.block_risk;
            rep.sum_insured     := i.sum_insured;
            rep.prem_amount     := i.prem_amt;
            rep.risk_count      := i.risk_count; 
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_print = false THEN
            rep.print_details       := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;
    
END GIPIR949C_PKG;
/


