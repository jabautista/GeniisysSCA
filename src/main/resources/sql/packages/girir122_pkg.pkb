CREATE OR REPLACE PACKAGE BODY CPI.GIRIR122_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.15.2013
     ** Referenced By:  GIRIR122 - List of Inward Policies with Expired PPW
     **/
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name        giis_parameters.param_value_v%type; 
    BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company_name := c.param_value_v;
        END LOOP;
        RETURN(v_company_name);
    END CF_COMPANY_NAME;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_address varchar2(500);
    BEGIN
        select param_value_v
          into v_address
          from giis_parameters 
         where param_name = 'COMPANY_ADDRESS';
        
        return(v_address);
    RETURN NULL; exception
        when no_data_found then 
            null;
        return(v_address);
    END CF_COMPANY_ADDRESS;
        
        
    FUNCTION get_report_details(
        p_reinsurer     GIIS_REINSURER.RI_NAME%type,
        p_line          GIIS_LINE.LINE_NAME%type,
        p_as_of_date    DATE,
        p_rep_date      VARCHAR2
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
        v_date  VARCHAR2(30);
    BEGIN
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        
        --CF_DATE_BASIS_TXT
        IF p_rep_date = 'INCEPT_DATE' THEN
            v_date   := ' (BASED ON INCEPT DATE)';
        ELSIF p_rep_date = 'BOOKING_MONTH' THEN
            v_date   := ' (BASED ON BOOKING MONTH)';
        END IF;
        
        
        IF p_as_of_date IS NOT NULL THEN
            rep.cf_paramdate := 'As of '|| TO_CHAR(p_as_of_date, 'fmMonth DD, RRRR') || v_date;
        ELSE
            rep.cf_paramdate := 'As of' || v_date;
        END IF;
        
        
        FOR i IN  ( SELECT a.policy_id, Get_Policy_No(a.policy_id) "Our Reference", b.line_name LINE,
                           DECODE(c.ri_endt_no, NULL,c.ri_policy_no, c.ri_policy_no||'/'||c.ri_endt_no) "Your Reference", 
                           c.ri_cd, d.assd_name "Assured", 
                           ((NVL(e.prem_amt,0) + NVL(e.tax_amt,0) + NVL(e.other_charges,0) + NVL(e.notarial_fee,0)))
                                    -  (NVL(e.ri_comm_amt,0) + NVL(e.ri_comm_vat,0)) * (NVL(e.currency_rt,0)) "Net Amount Due" , 
                           a.incept_date INCEPT_DATE,
                           a.line_cd|| '-'|| a.subline_cd|| '-'|| a.iss_cd|| '-'|| LTRIM (TO_CHAR (a.issue_yy, '09'))|| '-'
                                    || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))|| '-'|| LTRIM (TO_CHAR (a.renew_no, '09')) POL_NO,
                           f.ri_name, e.multi_booking_mm || ' ' || e.multi_booking_yy booking_month,  -- analyn 06.15.2010
                           d.assd_no  --marion 06.18.2010
                      FROM GIPI_POLBASIC a, 
                           GIIS_LINE b, 
                           GIRI_INPOLBAS c, 
                           GIIS_ASSURED d, 
                           GIPI_INVOICE e , 
                           GIIS_REINSURER f
                     WHERE NOT EXISTS (SELECT 1
                                         FROM GIAC_INWFACUL_PREM_COLLNS g , GIAC_ACCTRANS a -- analyn 06.28.2010
                                        WHERE g.a180_ri_cd       = c.ri_cd
                                          AND g.b140_iss_cd      = e.iss_cd
                                          AND g.b140_prem_seq_no = e.prem_seq_no
                                          AND g.gacc_tran_id = a.tran_id -- analyn 06.28.2010
                                          AND a.tran_flag <> 'D' -- analyn 06.28.2010 
                                          AND g.collection_amt >= ((NVL(e.prem_amt,0) + NVL(e.tax_amt,0) + NVL(e.other_charges,0) + NVL(e.notarial_fee,0)))
                                                                    -  (NVL(e.ri_comm_amt,0) + NVL(e.ri_comm_vat,0)) * (NVL(e.currency_rt,0))
                                          AND NOT EXISTS (SELECT 'X'
                                                            FROM GIAC_REVERSALS gr,
                                                                 GIAC_ACCTRANS  ga
                                                           WHERE gr.reversing_tran_id = ga.tran_id
                                                             AND ga.tran_flag !='D'
                                                             AND gr.gacc_tran_id = ga.tran_id) -- analyn 06.28.2010
                                              ) 
                       AND c.policy_id = a.policy_id
                       AND c.policy_id = e.policy_id 
                       AND a.line_cd = b.line_cd
                       AND a.assd_no = d.assd_no
                       AND c.ri_cd = f.ri_cd
                       AND UPPER(f.ri_name) = NVL(UPPER(p_reinsurer),UPPER(f.ri_name))
                       AND UPPER(b.line_name) =  NVL(UPPER(P_LINE),UPPER(b.line_name))
                       AND( /*petermkaw 06222010 UW-SPECS-2010-00077 added :P_REP_DATE for report date basis*/
                            (TRUNC(a.incept_date) + NVL(a.prem_warr_days,0)  <=  TRUNC( P_AS_OF_DATE) AND p_rep_date = 'INCEPT_DATE' /* commented by analyn 06.10.2010 aging will be based on booking*/)
                            OR
                          (LAST_DAY(TO_DATE(e.multi_booking_mm || ' ' || e.multi_booking_yy, 'MONTH YYYY')) + NVL(a.prem_warr_days,0)  <=  TRUNC( P_AS_OF_DATE) AND p_rep_date = 'BOOKING_MONTH' /* analyn 06.10.2010*/)
                          )
                       AND a.prem_warr_tag = 'Y' -- analyn 06.15.2010
                     ORDER BY f.ri_name, b.line_name, d.assd_name, POL_NO, Get_Policy_No(a.policy_id)  -- analyn 06.17.2010 added d.assd_name
                     )
        LOOP
            rep.ri_cd           := i.ri_cd;
            rep.ri_name         := i.ri_name;
            rep.policy_id       := i.policy_id;
            rep.pol_no          := i.pol_no;
            rep.your_reference  := i."Your Reference";
            rep.our_reference   := i."Our Reference";
            rep.line_name       := i.line;
            rep.assd_no         := i.assd_no;
            rep.assured         := i."Assured";
            rep.incept_date     := i.incept_date;
            rep.booking_month   := i.booking_month;
            rep.net_amount_due  := i."Net Amount Due";
        
            PIPE ROW(rep);
        END LOOP;      
    END get_report_details;
    

END GIRIR122_PKG;
/


