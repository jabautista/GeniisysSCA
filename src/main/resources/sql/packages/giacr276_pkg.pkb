CREATE OR REPLACE PACKAGE BODY CPI.GIACR276_PKG
AS
    FUNCTION get_giacr276_tab(
        P_ISS_PARAM       NUMBER,
        P_FROM_DATE       VARCHAR2,    
        P_TO_DATE         VARCHAR2,
        P_MODULE_ID       VARCHAR2,
        P_LINE_CD         VARCHAR2,
        P_USER_ID         VARCHAR2
    )
    RETURN giacr276_tab PIPELINED
    IS
        v_not_exist BOOLEAN;
        v_list  giacr276_type;
    BEGIN
        FOR i IN (
             SELECT line_cd, line_cd || ' - ' || get_line_name (line_cd) line,
                    --iss_cd, --Vincent 041105: comment out
                    --iss_cd||' - '||get_iss_name(iss_cd) iss_source, --Vincent 041105: comment out
                    DECODE (P_ISS_PARAM, 1, cred_branch, iss_cd) iss_cd,--Vincent 041105: added code
                    DECODE (P_ISS_PARAM,1, cred_branch || ' - ' || get_iss_name (cred_branch),
                    iss_cd || ' - ' || get_iss_name (iss_cd)) iss_source,--Vincent 041105: added code
                    get_assd_name (assd_no) assd_name, get_policy_no (policy_id) policy_no,
                    incept_date, acct_ent_date, get_peril_name (line_cd, peril_cd) peril,
                    prem_amt, comm_amt
             FROM giac_comm_expense_ext
            WHERE acct_ent_date BETWEEN TO_DATE (P_FROM_DATE, 'MM-DD-YYYY')
              AND TO_DATE (P_TO_DATE, 'MM-DD-YYYY')
              AND check_user_per_iss_cd_acctg (NULL,DECODE (P_ISS_PARAM,1, cred_branch,iss_cd),P_MODULE_ID) = 1/*added by Jongs 03.26.2013*/
              AND line_cd = NVL (P_LINE_CD, line_cd)
              AND user_id = P_USER_ID       
         )
         LOOP
            v_not_exist := false;
            v_list.line_cd        :=   i.line_cd;      
            v_list.line           :=   i.line;         
            v_list.iss_cd         :=   i.iss_cd;       
            v_list.iss_source     :=   i.iss_source;   
            v_list.assd_name      :=   i.assd_name;    
            v_list.policy_no      :=   i.policy_no;    
            v_list.incept_date    :=   i.incept_date;  
            v_list.acct_ent_date  :=   i.acct_ent_date;
            v_list.peril          :=   i.peril;        
            v_list.prem_amt       :=   i.prem_amt;     
            v_list.comm_amt       :=   i.comm_amt;     
                     
            PIPE ROW(v_list);
         END LOOP;
         
         IF v_not_exist THEN
            v_list.flag := 'T';
            PIPE ROW(v_list);
         END IF;
         
         RETURN;
    END;
    
    
    FUNCTION get_giacr276_header(
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
        RETURN giacr276_header_tab PIPELINED
    IS
        v_list giacr276_header_type;
    BEGIN
        select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
        select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
        
        IF p_from_date = p_to_date THEN
            v_list.report_date_header := 'For '||to_char(to_date(p_from_date, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
        ELSE
            v_list.report_date_header := 'For the period of '|| to_char(to_date(p_from_date,'MM-DD-RRRR'),'fmMonth DD, RRRR')||' to '|| to_char(to_date(p_to_date,'MM-DD-RRRR'),'fmMonth DD, RRRR');
        END IF;
        
        PIPE ROW(v_list);
        RETURN;
    END get_giacr276_header;
        

END;
/


