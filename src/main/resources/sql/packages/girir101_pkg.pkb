CREATE OR REPLACE PACKAGE BODY CPI.GIRIR101_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   05.10.2013
     ** Referenced By:  GIRIR101 - OUTSTANDING ACCEPTANCES REPORT
     **/
     
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name        giis_parameters.PARAM_VALUE_V%type;    
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
        p_ri_cd             giri_inpolbas.RI_CD%type,
        p_line_cd           gipi_polbasic.LINE_CD%type,
        p_oar_print_date    VARCHAR2,
        p_morethan          NUMBER,
        p_lessthan          NUMBER,
        p_date_sw           VARCHAR2
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        rep.exist := 'N';
                
        FOR i IN (SELECT e.oar_print_date, 1, e.ACCEPT_NO,
                       (trunc(sysdate)-trunc(e.accept_date)) NO_OF_DAYS, --petermkaw02192010
                       e.ri_cd ri_cd, --petermkaw removed nvl 02232010
                       a.line_cd line_cd, --petermkaw removed nvl 02232010
                       c.line_name,
                       b.ri_name reinsurer,
                       d.assd_name, 
                       to_number('0.00') AMOUNT_OFFERED, --petermkaw 03162010
                       a.tsi_amt our_acceptance,
                       a.incept_date,
                       a.expiry_date,
                       e.accept_date date_accepted  --petermkaw 02192010 changed from g.parstat_date 
                       -- commented out petermkaw 02192010 ,e.remarks
                  FROM gipi_parhist g,
                       gipi_parlist f,
                       giis_assured d,
                       gipi_polbasic a,
                       giri_inpolbas e,
                       giis_reinsurer b,
                       giis_line c          
                 WHERE b.ri_cd = e.ri_cd
                   AND e.ri_cd = NVL( p_ri_cd, e.ri_cd)
                   AND a.line_cd = c.line_cd
                   AND a.line_cd = NVL(p_line_cd, a.line_cd )      
                   AND a.policy_id = e.policy_id  
                   AND a.pol_flag IN ('1', '2', '3')
                   AND a.assd_no = d.assd_no
                   AND A.REG_POLICY_SW <> 'N'   --added by cris on 021709 to eliminate special policies from the report
                   AND e.accept_date <= trunc(sysdate) --petermkaw 03162010
                   AND e.ri_binder_no is null   --petermkaw
                   AND ((nvl(trunc(e.oar_print_date),TO_DATE('01-01-1990','MM-DD-YYYY')) = nvl(to_date(p_oar_print_date,'MM-DD-RRRR'),nvl(trunc(e.oar_print_date),TO_DATE('01-01-1990','MM-DD-YYYY')))) or (p_date_sw = 1 and e.oar_print_date is not null))
                   AND ((nvl(trunc(to_date(p_oar_print_date,'MM-DD-RRRR')),trunc(sysdate)) - trunc(e.accept_date)) between to_number(p_morethan) and to_number(p_lessthan))
                  --two "AND" conditions added by petermkaw 04162010 that satisfies specs (3 conditions):
                  --(45 days) no oar_print_date with date accept <= entered date. aging >=45 but <65.
                  --(75 days) with oar_print_datae with date accept <= entered date. aging <= 65.
                  --(sysdate) no oar_print_date with date accept <= sysdate. 
                  --added by petermkaw 02192010 from enhancement of giris051
                   AND a.par_id  = f.par_id 
                   AND a.line_cd = f.line_cd   
                   AND f.line_cd = c.line_cd 
                   AND f.assd_no = d.assd_no
                   AND f.par_id  = g.par_id
                   AND f.iss_cd  = (SELECT param_value_v
                                      FROM giis_parameters
                                     WHERE param_name = 'ISS_CD_RI')
                   AND g.parstat_cd = '1'
                 UNION
                SELECT e.oar_print_date, 2, e.accept_no,
                       (trunc(sysdate)-trunc(e.accept_date)) no_of_days,  --petermkaw02192010
                       E.ri_cd RI_CD, --petermkaw removed nvl 02232010
                       A.line_cd LINE_CD, --petermkaw removed nvl 02232010
                       C.line_name,
                       B.ri_name REINSURER,
                       D.assd_name,
                       nvl(E.amount_offered,0.00) AMOUNT_OFFERED, --petermkaw 03162010
                       A.tsi_amt OUR_ACCEPTANCE,
                       A.INCEPT_DATE,
                       A.EXPIRY_DATE,
                       e.accept_date date_accepted  --petermkaw 02192010 changed from g.parstat_date 
                       -- commented out petermkaw 02192010 
                  FROM gipi_parhist G,
                       gipi_parlist F,
                       giis_assured D,
                       gipi_wpolbas A,
                       giri_winpolbas E,
                       giis_reinsurer B,
                       giis_line C          
                 WHERE B.ri_cd = E.ri_cd
                   AND E.ri_cd = NVL(p_ri_cd, E.ri_cd)
                   AND A.line_cd = C.line_cd
                   AND A.line_cd = NVL(p_line_cd, A.line_cd )      
                   AND A.par_id = E.par_id  
                   AND A.pol_flag IN ('1', '2', '3')
                   AND A.assd_no = D.assd_no
                   AND e.accept_date <= trunc(sysdate) --petermkaw 03162010
                   AND e.ri_binder_no is null --petermkaw
                   AND A.REG_POLICY_SW <> 'N'  -- analyn 03.16.2010 to exclude special policies
                   AND ((nvl(trunc(e.oar_print_date),TO_DATE('01-01-1990','MM-DD-YYYY')) = nvl(to_date(p_oar_print_date,'MM-DD-RRRR'),nvl(trunc(e.oar_print_date),TO_DATE('01-01-1990','MM-DD-YYYY')))) or (p_date_sw = 1 and e.oar_print_date is not null))
                   AND ((nvl(trunc(to_date(p_oar_print_date,'MM-DD-RRRR')),trunc(sysdate)) - trunc(e.accept_date)) between to_number(p_morethan) and to_number(p_lessthan))
                  --two "AND" conditions added by petermkaw 04162010 that satisfies specs (3 conditions):
                  --(45 days) no oar_print_date with date accept <= entered date. aging >=45 but <65.
                  --(75 days) with oar_print_datae with date accept <= entered date. aging <= 65.
                  --(sysdate) no oar_print_date with date accept <= sysdate. 
                  --added by petermkaw 02192010 from enhancement of giris051
                   AND A.par_id  = F.par_id 
                   AND A.line_cd = F.line_cd   
                   AND F.line_cd = C.line_cd 
                   AND F.assd_no = D.assd_no
                   AND F.par_id  = G.par_id
                   AND F.iss_cd  = (SELECT param_value_v
                                      FROM giis_parameters
                                     WHERE param_name = 'ISS_CD_RI')
                   AND G.parstat_cd = '1'
                 UNION  --added third query to accomodate ri_acceptances without basic information
                SELECT e.oar_print_date, 3, e.accept_no,
                       (trunc(sysdate)-trunc(e.accept_date)) no_of_days,  --petermkaw02192010
                       E.ri_cd RI_CD, --petermkaw removed nvl 02232010
                       F.line_cd LINE_CD, --petermkaw removed nvl 02232010 and changed to F
                       C.line_name,
                       B.ri_name REINSURER,
                       D.assd_name,
                       nvl(E.AMOUNT_OFFERED,0.00) AMOUNT_OFFERED,  --petermkaw 03162010
                       NULL OUR_ACCEPTANCE,
                       NULL,
                       NULL,
                       e.accept_date date_accepted  --petermkaw 02192010 changed from g.parstat_date 
                       -- commented out petermkaw 02192010 
                  FROM gipi_parhist G,
                       gipi_parlist F,
                       giis_assured D,
                       giri_winpolbas E,
                       giis_reinsurer B,
                       giis_line C          
                 WHERE B.ri_cd = E.ri_cd
                   AND E.ri_cd = NVL(p_ri_cd, E.ri_cd)
                   AND F.line_cd = C.line_cd
                   AND F.line_cd = NVL(p_line_cd, F.line_cd )      
                   AND F.assd_no = D.assd_no
                   AND e.accept_date <= trunc(sysdate) --petermkaw 03162010
                   AND e.ri_binder_no is null --petermkaw
                   AND ((nvl(trunc(e.oar_print_date),TO_DATE('01-01-1990','MM-DD-YYYY')) = nvl(to_date(p_oar_print_date,'MM-DD-RRRR'),nvl(trunc(e.oar_print_date),TO_DATE('01-01-1990','MM-DD-YYYY')))) or (p_date_sw = 1 and e.oar_print_date is not null))
                   AND ((nvl(trunc(to_date(p_oar_print_date,'MM-DD-RRRR')),trunc(sysdate)) - trunc(e.accept_date)) between to_number(p_morethan) and to_number(p_lessthan))
                  --two "AND" conditions added by petermkaw 04162010 that satisfies specs (3 conditions):
                  --(45 days) no oar_print_date with date accept <= entered date. aging >=45 but <65.
                  --(75 days) with oar_print_datae with date accept <= entered date. aging <= 65.
                  --(sysdate) no oar_print_date with date accept <= sysdate. 
                  --added by petermkaw 02192010 from enhancement of giris051
                   AND E.par_id  = F.par_id 
                   AND F.par_id  = G.par_id
                   AND F.iss_cd  = (SELECT param_value_v
                                      FROM giis_parameters
                                     WHERE param_name = 'ISS_CD_RI')
                   AND F.par_status = 2 -- analyn 03.23.2010
                   AND G.parstat_cd = '1'
                   AND NOT EXISTS (SELECT c.par_id  --petermkaw 02232010
                                     FROM gipi_wpolbas c
                                    WHERE e.par_id = c.par_id)
                /*
                ** modified by aivhie 030701
                ** modified by petermkaw 02232010 see comments
                */  
                 ORDER BY ri_cd)
        LOOP
            rep.oar_print_date  := i.oar_print_date;
            rep.ri_cd           := i.ri_cd;
            rep.reinsurer       := i.reinsurer;
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.assd_name       := i.assd_name;
            rep.amount_offered  := i.amount_offered;
            rep.our_acceptance  := i.our_acceptance;
            rep.incept_date     := i.incept_date;
            rep.expiry_date     := i.expiry_date;
            rep.date_accepted   := i.date_accepted;
            rep.accept_no       := i.accept_no;
            rep.no_of_days      := i.no_of_days;
            
            
            IF GIISP.V('ORA2010_SW') = 'Y' THEN
                rep.format_trigger  := 'Y';
            ELSE
                rep.format_trigger  := 'N';
            END IF;
            
            rep.exist := 'Y';
            
            PIPE ROW(rep);
        END LOOP;
        
        IF rep.exist = 'N' THEN
           PIPE ROW(rep);
        END IF;
    END get_report_details;
    
    
END GIRIR101_PKG;
/


