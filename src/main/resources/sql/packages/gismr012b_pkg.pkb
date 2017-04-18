CREATE OR REPLACE PACKAGE BODY CPI.GISMR012B_PKG
AS

    FUNCTION get_gismr012b(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2,
        p_user       VARCHAR2
    )
        RETURN gismr012b_record_tab PIPELINED
    IS
        v_list gismr012b_record_type;
        v_not_exist boolean := true;
    BEGIN
        FOR i IN(  
                   SELECT param_name, g.user_name,
                         DECODE (param_name,
                                 'GLOBE_NUMBER', 'GLOBE',
                                 'SMART_NUMBER', 'SMART',
                                 'SUN_NUMBER', 'SUN'
                                ) line,
                         s.date_sent, MESSAGE MESSAGE, message_status, s.user_id,
                         cellphone_no
                    FROM gism_messages_sent s,
                         giis_parameters,
                         gism_messages_sent_dtl d,
                         giis_users g
                   WHERE (INSTR (param_value_v, SUBSTR (cellphone_no, (LENGTH (cellphone_no) - 9), 3), 1, 1 ) - 1 ) >= 0
                     AND param_name IN ('GLOBE_NUMBER', 'SMART_NUMBER', 'SUN_NUMBER')
                     AND (date_sent BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                     OR date_sent <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                         )
                     AND s.msg_id = d.msg_id
                     AND s.user_id = g.user_id
                     AND g.user_id = NVL (p_user, g.user_id)
                     AND message_status LIKE 'S'
        )
        LOOP
            v_not_exist := false;
            v_list.param_name       :=  i.param_name;    
            v_list.user_name        :=  i.user_name;     
            v_list.line             :=  i.line;          
            v_list.date_sent        :=  i.date_sent;     
            v_list.message          :=  i.message;       
            v_list.message_status   :=  i.message_status;
            v_list.user_id          :=  i.user_id;       
            v_list.cellphone_no     :=  i.cellphone_no;  

            PIPE ROW(v_list);
        END LOOP;
        
        IF v_not_exist THEN
            v_list.exist := 'T';
            PIPE ROW(v_list);
        END IF;
        
        RETURN;
     
    END get_gismr012b;
    
    FUNCTION get_gismr012b_header(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2
    )
        RETURN gismr012b_header_tab PIPELINED
    IS
        v_list gismr012b_header_type;
    BEGIN
        select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
        select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
        
        IF p_as_of_date IS NOT NULL THEN
            v_list.report_date := 'As of ' || TO_CHAR(TO_DATE(p_as_of_date, 'MM-DD-YYYY'),'fmMonth dd, yyyy');
        ELSE
            v_list.report_date := 'From ' || TO_CHAR(TO_DATE(p_from_date, 'MM-DD-YYYY'),'fmMonth dd, yyyy') || ' to ' ||
                                             TO_CHAR(TO_DATE(p_to_date, 'MM-DD-YYYY'),'fmMonth dd, yyyy');
        END IF;
        
        PIPE ROW(v_list);
        RETURN;
    END get_gismr012b_header;
END;
/


