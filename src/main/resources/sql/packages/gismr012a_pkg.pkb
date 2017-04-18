CREATE OR REPLACE PACKAGE BODY CPI.GISMR012A_PKG
AS

    FUNCTION get_gismr012a(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2
    )
        RETURN gismr012a_record_tab PIPELINED
    IS
        v_list gismr012a_record_type;
        v_not_exist boolean := true;
    BEGIN
        FOR i IN(  
                   SELECT param_name,
                         DECODE (param_name,
                                 'GLOBE_NUMBER', 'GLOBE',
                                 'SMART_NUMBER', 'SMART',
                                 'SUN_NUMBER', 'SUN'
                                ) LINE,
                         message, keyword, date_received, cellphone_no,
                         DECODE (error_msg_id, NULL, '', '*') reply
                    FROM gism_messages_received, giis_parameters
                   WHERE (  INSTR (param_value_v,
                                   SUBSTR (cellphone_no, (LENGTH (cellphone_no) - 9), 3), 1,1 ) - 1 ) >= 0
                     AND param_name IN ('GLOBE_NUMBER', 'SMART_NUMBER', 'SUN_NUMBER')
                     AND (date_received BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                            OR date_received <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                            )
        )
        LOOP
            v_not_exist := false;
            v_list.param_name    := i.param_name;   
            v_list.line          := i.line;         
            v_list.message       := i.message;      
            v_list.keyword       := i.keyword;      
            v_list.date_received := i.date_received;
            v_list.cellphone_no  := i.cellphone_no; 
            v_list.reply         := i.reply;        

            PIPE ROW(v_list);
        END LOOP;
        
        IF v_not_exist THEN
            v_list.exist := 'T';
            PIPE ROW(v_list);
        END IF;
        
        RETURN;
     
    END get_gismr012a;
    
    FUNCTION get_gismr012a_header(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2
    )
        RETURN gismr012a_header_tab PIPELINED
    IS
        v_list gismr012a_header_type;
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
    END get_gismr012a_header;
END;
/


