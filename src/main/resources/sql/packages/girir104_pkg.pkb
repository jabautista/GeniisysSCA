CREATE OR REPLACE PACKAGE BODY CPI.GIRIR104_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.02.2013
     ** Referenced By:  GIRIR104 - ASSUMED PRODUCTION COMPARATIVE STUDY
     **/
     
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name        giis_parameters.param_name%type;
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
        SELECT param_value_v
          INTO v_address
          FROM giis_parameters 
         WHERE param_name = 'COMPANY_ADDRESS';
        
        return(v_address);

    RETURN NULL; exception
        when no_data_found then null;
            return(v_address);
            
    END CF_COMPANY_ADDRESS;
    
    
    FUNCTION CF_VARIANCE(
        p_pre_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_PRE_YEAR%type,
        p_cur_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_CUR_YEAR%type
    ) RETURN NUMBER
    AS
    BEGIN
        RETURN((( NVL(P_CUR_YEAR,0) - NVL(P_PRE_YEAR,0) ) / NVL(P_PRE_YEAR,0) ) * 100 );
        
    RETURN NULL; exception
        when zero_divide then 
            return(null);
    END CF_VARIANCE;
    
    
    FUNCTION CF_TOTAL_VARIANCE(
        p_total_pre_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_PRE_YEAR%type,
        p_total_cur_year  GIIN_ASSMD_PROD_COMPARATIVE.M01_CUR_YEAR%type
    ) RETURN NUMBER
    AS
    BEGIN
        RETURN((( NVL(P_TOTAL_CUR_YEAR,0) - NVL(P_TOTAL_PRE_YEAR,0) ) / NVL(P_TOTAL_PRE_YEAR,0) ) * 100 );    
    
    RETURN NULL; exception
        when zero_divide then 
            return(null);
    END CF_TOTAL_VARIANCE;
    
    
    FUNCTION get_report_details(
        p_report_month      VARCHAR2,
        p_report_year       NUMBER
    ) RETURN report_details_tab PIPELINED
    AS
        rep         report_details_type;
    BEGIN        
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.paramdate           := UPPER(p_report_month) || ', ' || TO_CHAR(sysdate, 'RRRR') || '  vs.  ' || UPPER(p_report_month) || ', ' 
                                    || (p_report_year - 1);
                                    
        FOR i IN  ( SELECT B.LINE_NAME, A.YTD_PRE_YEAR, A.YTD_CUR_YEAR,
                           DECODE (p_report_month,
                                   'JANUARY', A.M01_PRE_YEAR,
                                   'FEBRUARY', A.M02_PRE_YEAR,
                                   'MARCH', A.M03_PRE_YEAR,
                                   'APRIL', A.M04_PRE_YEAR,
                                   'MAY', A.M05_PRE_YEAR,
                                   'JUNE', A.M06_PRE_YEAR,
                                   'JULY', A.M07_PRE_YEAR,
                                   'AUGUST', A.M08_PRE_YEAR,
                                   'SEPTEMBER', A.M09_PRE_YEAR,
                                   'OCTOBER', A.M10_PRE_YEAR,
                                   'NOVEMBER', A.M11_PRE_YEAR,
                                   'DECEMBER', A.M12_PRE_YEAR  ) MTD_PRE_YEAR,
                           DECODE (p_report_month,
                                   'JANUARY', A.M01_CUR_YEAR,
                                   'FEBRUARY', A.M02_CUR_YEAR,
                                   'MARCH', A.M03_CUR_YEAR,
                                   'APRIL', A.M04_CUR_YEAR,
                                   'MAY', A.M05_CUR_YEAR,
                                   'JUNE', A.M06_CUR_YEAR,
                                   'JULY', A.M07_CUR_YEAR,
                                   'AUGUST', A.M08_CUR_YEAR,
                                   'SEPTEMBER', A.M09_CUR_YEAR,
                                   'OCTOBER', A.M10_CUR_YEAR,
                                   'NOVEMBER', A.M11_CUR_YEAR,
                                   'DECEMBER', A.M12_CUR_YEAR  ) MTD_CUR_YEAR,
                           DECODE (p_report_month,
                                   'JANUARY', A.QD1_PRE_YEAR,
                                   'FEBRUARY', A.QD1_PRE_YEAR,
                                   'MARCH', A.QD1_PRE_YEAR,
                                   'APRIL', A.QD2_PRE_YEAR,
                                   'MAY', A.QD2_PRE_YEAR,
                                   'JUNE', A.QD2_PRE_YEAR,
                                   'JULY', A.QD3_PRE_YEAR,
                                   'AUGUST', A.QD3_PRE_YEAR,
                                   'SEPTEMBER', A.QD3_PRE_YEAR,
                                   'OCTOBER', A.QD4_PRE_YEAR,
                                   'NOVEMBER', A.QD4_PRE_YEAR,
                                   'DECEMBER', A.QD4_PRE_YEAR  ) QTD_PRE_YEAR,
                           DECODE (p_report_month,
                                   'JANUARY', A.QD1_CUR_YEAR,
                                   'FEBRUARY', A.QD1_CUR_YEAR,
                                   'MARCH', A.QD1_CUR_YEAR,
                                   'APRIL', A.QD2_CUR_YEAR,
                                   'MAY', A.QD2_CUR_YEAR,
                                   'JUNE', A.QD2_CUR_YEAR,
                                   'JULY', A.QD3_CUR_YEAR,
                                   'AUGUST', A.QD3_CUR_YEAR,
                                   'SEPTEMBER', A.QD3_CUR_YEAR,
                                   'OCTOBER', A.QD4_CUR_YEAR,
                                   'NOVEMBER', A.QD4_CUR_YEAR,
                                   'DECEMBER', A.QD4_CUR_YEAR  ) QTD_CUR_YEAR
                      FROM GIIN_ASSMD_PROD_COMPARATIVE A,
                           GIIS_LINE B
                     WHERE A.LINE_CD = B.LINE_CD
                     ORDER BY B.LINE_NAME)
        LOOP
            rep.line_name       := i.line_name;
            rep.ytd_pre_year    := i.ytd_pre_year;
            rep.ytd_cur_year    := i.ytd_cur_year;
            rep.qtd_pre_year    := i.qtd_pre_year;
            rep.qtd_cur_year    := i.qtd_cur_year;
            rep.mtd_pre_year    := i.mtd_pre_year;
            rep.mtd_cur_year    := i.mtd_cur_year;
            
            FOR C IN (SELECT DECODE(p_report_month ,
                                    'JANUARY'   , '1ST QUARTER',
                   	                'FEBRUARY'  , '1ST QUARTER',
		                            'MARCH'     , '1ST QUARTER',
                                    'APRIL'     , '2ND QUARTER',
	                                'MAY'       , '2ND QUARTER',
                                    'JUNE'      , '2ND QUARTER',
                                    'JULY'      , '3RD QUARTER',
	                                'AUGUST'    , '3RD QUARTER',
	                                'SEPTEMBER' , '3RD QUARTER',
	                                'OCTOBER'   , '4TH QUARTER',
	                                'NOVEMBER'  , '4TH QUARTER',
	                                'DECEMBER'  , '4TH QUARTER'  ) QUARTER  
                        FROM dual ) 
            LOOP
                rep.cf_quarter  :=  c.quarter; 
            END LOOP;
                        
            rep.cf_var_month    := CF_VARIANCE(i.mtd_pre_year, i.mtd_cur_year);
            rep.cf_var_quarter  := CF_VARIANCE(i.qtd_pre_year, i.qtd_cur_year);
            rep.cf_var_year     := CF_VARIANCE(i.ytd_pre_year, i.ytd_cur_year);            
            
            PIPE ROW(rep);
        END LOOP;
         
    END get_report_details;
    
    
END GIRIR104_PKG;
/


