CREATE OR REPLACE PACKAGE BODY CPI.GIPIR949_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.20.2013
     ** Referenced By:  GIPIR949 - Detail Risk Profile (FIRE)
     **/
    
    FUNCTION populate_report(
        p_line_cd           gipi_risk_profile_dtl.LINE_CD%type,
        p_subline_cd        gipi_risk_profile_dtl.SUBLINE_CD%type,
        p_starting_date     VARCHAR2,
        p_ending_date       VARCHAR2,
        p_all_line_tag      VARCHAR2, -- benjo 05.22.2015 UW-SPECS-2015-046
        p_param_date        VARCHAR2,
        p_user              gipi_risk_profile_dtl.USER_ID%type
    ) RETURN report_tab PIPELINED
    AS
        rep                 report_type;
        v_print             boolean := false;
        v_param_date        VARCHAR2(50);
        v_starting_date     DATE := TO_DATE(p_starting_date, 'MM-DD-RRRR');
        v_ending_date       DATE := TO_DATE(p_ending_date, 'MM-DD-RRRR');
        v_line_name         giis_line.LINE_NAME%type;
        v_subline_name      giis_subline.SUBLINE_NAME%type;
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
        
        IF p_param_date = 'AD' THEN
            v_param_date := 'ACCOUNTING ENTRY DATE';
        ELSIF p_param_date = 'ED' THEN	 
            v_param_date := 'EFFECTIVITY DATE';
        ELSIF p_param_date = 'ID' THEN	 
            v_param_date := 'ISSUE DATE';
        ELSIF p_param_date = 'BD' THEN	 
            v_param_date := 'BOOKING DATE';
        END IF;	 
        
        rep.top_date := v_param_date || ' FROM ' || TO_CHAR(v_starting_date, 'fmMONTH DD, RRRR') || ' TO ' || TO_CHAR(v_ending_date, 'fmMONTH DD, RRRR');
        
        BEGIN 
            SELECT line_name
              INTO v_line_name
              FROM giis_line
             WHERE line_cd = p_line_cd;
        
            rep.line := p_line_cd||' - '||v_line_name;
        EXCEPTION
	        WHEN NO_DATA_FOUND THEN
	            rep.line := null;
	    END;
        
        BEGIN 
            SELECT subline_name
              INTO v_subline_name
              FROM giis_subline
             WHERE line_cd    = p_line_cd
               AND subline_cd = p_subline_cd;
        
            rep.subline := p_subline_cd||' - '||v_subline_name;
        EXCEPTION
	        WHEN NO_DATA_FOUND THEN
	            rep.subline := null;
	    END;
        
        FOR i IN (SELECT tarf_cd, range_from, range_to, 
                         line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LPAD(issue_yy,2,'0')||'-'
                                    ||LPAD(pol_seq_no,7,'0')||'-'||LPAD(renew_no,2,'0') POLICY_NO,
                         ann_tsi_amt, net_retention netret_prem, facultative facul_prem, quota_share quota_prem, 
                         --treaty_prem
                         (NVL(treaty_prem,0) + NVL(treaty2_prem,0) + NVL(treaty3_prem,0) + NVL(treaty4_prem,0) + 
                             NVL(treaty5_prem,0) + NVL(treaty6_prem,0) + NVL(treaty7_prem,0) + NVL(treaty8_prem,0) + 
                             NVL(treaty9_prem,0) + nvl(treaty10_prem,0) ) treaty_prem
                         --       SUM(ann_tsi_amt) ann_tsi_amt,
                         --       SUM(net_retention) netret_prem,
                         --       SUM(facultative) facul_prem,
                         --       SUM(quota_share) quota_prem,
                         --       SUM(treaty_prem) treaty_prem
                    FROM gipi_risk_profile_dtl
                   WHERE user_id = P_USER
                     AND all_line_tag = /*'Y'*/ p_all_line_tag -- benjo 05.22.2015 UW-SPECS-2015-046
                     AND TRUNC(date_from)    = v_starting_date
                     AND TRUNC(date_to)      = v_ending_date     
                     AND line_cd = nvl(p_line_cd,line_cd)
                     AND NVL (subline_cd, '&') = NVL (p_subline_cd, NVL (subline_cd, '&')) -- benjo 05.22.2015 added NVL('&')
                     --AND ann_tsi_amt >= range_from
                     --AND ann_tsi_amt <= range_to
                   /*
                   HAVING ABS(SUM(ann_tsi_amt)) >= range_from 
                     AND  ABS(SUM(ann_tsi_amt)) <= range_to
                   GROUP BY tarf_cd,range_from,range_to,
                            line_cd||'-'||subline_cd||'-'||iss_cd||'-'||
                            LPAD(issue_yy,2,'0')||'-'||LPAD(pol_seq_no,7,'0')||
                            '-'||LPAD(renew_no,2,'0')/*z.share_type,*/--acct_trty_type --, z.ann_tsi_amt */
                   ORDER BY tarf_cd, range_from, range_to,
                            line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LPAD(issue_yy,2,'0')||'-'
                                    ||LPAD(pol_seq_no,7,'0')||'-'||LPAD(renew_no,2,'0'))
        LOOP
            rep.print_details   := 'Y';
            v_print             := true;
            rep.tarf_cd         := i.tarf_cd;
            rep.range_from      := i.range_from;
            rep.range_to        := i.range_to;
            rep.cf_ranges       := ltrim(to_char(i.RANGE_FROM,'999,999,999,999,990.99')||' - '||ltrim(to_char(i.RANGE_TO,'999,999,999,999,990.99')));
            rep.policy_no       := i.policy_no;
            rep.ann_tsi_amt     := i.ann_tsi_amt;
            rep.netret_prem     := i.netret_prem;
            rep.facul_prem      := i.facul_prem;
            rep.quota_prem      := i.quota_prem;
            rep.treaty_prem     := i.treaty_prem;
            rep.pol_total       := NVL(i.netret_prem,0) + NVL(i.treaty_prem,0) + NVL(i.facul_prem,0) + NVL(i.quota_prem,0);
            
            BEGIN
                IF p_line_cd = 'FI' THEN
                    SELECT rv_meaning
                      INTO rep.tarf_desc
                      FROM cg_ref_codes
                     WHERE rv_low_value = i.tarf_cd
                       AND rv_domain    = 'GIIS_TARIFF.TARF_CD';
                ELSE
                    rep.tarf_desc := null;--rep.tarf_desc := ' '; benjo 05.22.2015 commented out and replaced.
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rep.tarf_desc := null;
            END;
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_print = false THEN
            rep.print_details := 'N';
            PIPE ROW(rep);
        END IF;
    END populate_report;


END GIPIR949_PKG;