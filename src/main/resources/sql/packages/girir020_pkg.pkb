CREATE OR REPLACE PACKAGE BODY CPI.GIRIR020_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.21.2013
     ** Referenced By:  GIRIR020 - RI Renewal Report
     **/
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name  GIIS_PARAMETERS.param_value_v%type;
    BEGIN
        FOR i IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company_name := i.param_value_v;
        END LOOP;
        
        RETURN (v_company_name);
    END CF_COMPANY_NAME;
    
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_address   VARCHAR2(500);
    BEGIN
        SELECT param_value_v
          INTO v_address
          FROM GIIS_PARAMETERS
         WHERE param_name = 'COMPANY_ADDRESS';
         
        RETURN (v_address);
    RETURN NULL; EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        RETURN (v_address);
    END CF_COMPANY_ADDRESS;
    
    
    FUNCTION get_report_details(
        p_ri_sname      giis_reinsurer.RI_SNAME%type,
        p_start_date    giuw_pol_dist.EXPIRY_DATE%type,
        p_end_date      giuw_pol_dist.EXPIRY_DATE%type
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        rep.cf_paramdate    := 'FOR POLICIES EXPIRING ' || TO_CHAR(P_END_DATE, 'MM-DD-YYYY');
        
        FOR i IN  (SELECT  a1806.ri_name          ri_name 
                           ,a1806.bill_address1   bill_address12
                           ,a1806.bill_address2   bill_address23
                           ,a1806.bill_address3   bill_address34
                           ,d0804.ri_tsi_amt      ri_tsi_amt1
                           ,d0804.ri_shr_pct      ri_shr_pct
                           ,d0804.remarks         remarks
                           ,d0605.loc_voy_unit    loc_voy_unit
                           ,b2502.endt_seq_no     endt_seq_no4
                           ,b2502.line_cd || '-' || b2502.subline_cd || '-' || b2502.iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b2502.issue_yy, '09'))) 
                                    || '-' || LTRIM(RTRIM(TO_CHAR(b2502.pol_seq_no, '0999999'))) ||'-'|| LTRIM(TO_CHAR(b2502.renew_no,'09'))   policy_no
                           ,b2502.policy_id       policy_id2 
                           ,a020.assd_name        assd_name
                           ,d0103.line_cd || '-' || LTRIM(TO_CHAR(d0103.binder_yy,'09')) || '-' || LTRIM(TO_CHAR(d0103.binder_seq_no,'09999'))   binder_seq_no
                           ,TO_CHAR(c080.expiry_date,'MM-DD-YYYY')  expiry_date
                           ,c100.currency_desc
                      FROM giis_reinsurer  a1806
                           ,giri_frps_ri   d0804
                           ,giri_distfrps  d0605
                           ,giuw_pol_dist  c080
                           ,gipi_polbasic  b2502
                           ,giis_assured   a020
                           ,giri_binder    d0103
                           ,giis_currency  c100
                     WHERE d0804.ri_cd           = a1806.ri_cd
                       AND d0605.line_cd         = d0804.line_cd
                       AND d0605.frps_yy         = d0804.frps_yy
                       AND d0605.frps_seq_no     = d0804.frps_seq_no
                       AND c080.dist_no          = d0605.dist_no
                       AND b2502.policy_id       = c080.policy_id
                       AND a020.assd_no          = b2502.assd_no
                       AND d0103.fnl_binder_id   = d0804.fnl_binder_id
                       AND d0605.currency_cd     = c100.main_currency_cd
                       AND d0605.ri_flag         = '2'
                       AND UPPER(a1806.ri_sname) = NVL(UPPER(p_ri_sname), a1806.ri_sname)
                       AND c080.expiry_date      >= p_start_date  
                       AND c080.expiry_date      <= p_end_date
                     ORDER BY a1806.ri_name, c100.currency_desc, b2502.line_cd  )
        LOOP
            rep.ri_name         := i.ri_name;
            rep.bill_address1   := i.bill_address12;
            rep.bill_address2   := i.bill_address23;
            rep.bill_address3   := i.bill_address34;
            rep.currency_desc   := i.currency_desc;
            rep.policy_no       := i.policy_no;
            rep.policy_id       := i.policy_id2;
            rep.endt_seq_no     := i.endt_seq_no4;
            rep.assd_name       := i.assd_name;
            rep.loc_voy_unit    := i.loc_voy_unit;
            rep.binder_seq_no   := i.binder_seq_no;
            rep.expiry_date     := i.expiry_date;
            rep.ri_tsi_amt      := i.ri_tsi_amt1;
            rep.ri_shr_pct      := i.ri_shr_pct;
            rep.remarks         := i.remarks;
            
            PIPE ROW(rep);                          
        END LOOP;
        
    END get_report_details;
    
    
    FUNCTION get_item_details(
        p_policy_id     gipi_polbasic.policy_id%type
    ) RETURN item_details_tab PIPELINED
    AS
        rep     item_details_type;
    BEGIN         
        FOR j IN  (SELECT  B1701.POLICY_ID   POLICY_ID 
                           ,B050.DISTRICT_NO DISTRICT_NO
                           ,B050.BLOCK_NO    BLOCK_NO
                      FROM GIPI_ITEM         B1701
                           ,GIPI_FIREITEM    B050
                     WHERE B050.POLICY_ID  = B1701.POLICY_ID
                       AND B050.ITEM_NO    = B1701.ITEM_NO 
                       AND B1701.POLICY_ID = p_policy_id )
        LOOP
            rep.policy_id   := j.policy_id;
            rep.district_no := j.district_no;
            rep.block_no    := j.block_no; 
                
            PIPE ROW(rep);         
        END LOOP;
    END get_item_details;

END GIRIR020_PKG;
/


