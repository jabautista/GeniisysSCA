CREATE OR REPLACE PACKAGE BODY CPI.GIACR171_PKG AS
       
 
    FUNCTION cf_company_nameformula RETURN VARCHAR2 IS
      v_company_name VARCHAR2(200);
     
    BEGIN
      SELECT param_value_v
      INTO   v_company_name
      FROM   giis_parameters
      WHERE  param_name = 'COMPANY_NAME';
      
      RETURN (v_company_name);
      
    END;
    
    FUNCTION cf_company_addressformula RETURN VARCHAR2 IS
      v_company_address VARCHAR2(400);
      
    BEGIN
      SELECT param_value_v
      INTO   v_company_address
      FROM   giis_parameters
      WHERE  param_name = 'COMPANY_ADDRESS';
      
      RETURN (v_company_address);
      
    END;
    
    FUNCTION cf_periodformula (
        p_date_from         DATE,
        p_date_to           DATE
       )
       RETURN VARCHAR2 IS
       v_period              VARCHAR2(60);
      
    BEGIN
       v_period := 'From  '||TO_CHAR(p_date_from, 'fmMonth DD, YYYY')||'  to  '||TO_CHAR(p_date_to, 'fmMonth DD, YYYY');
        
       RETURN (v_period);
       
    END;
    
   FUNCTION populate_giacr171_records (
        p_date_from         VARCHAR2,
        p_date_to           VARCHAR2,
        p_line_cd           VARCHAR2,
        p_ri_cd             VARCHAR2,
        p_user_id           VARCHAR2
       )
       RETURN giacr171_record_tab PIPELINED
    AS
       v_rec                giacr171_record_type;
       
    BEGIN     
       FOR i IN (SELECT a.line_cd,
                        ri_cd,
                        ri_name,
                        b.line_name,    
                        sum(amt_insured) amt_insured,
                        sum(gross_prem_amt) gross_prem_amt, 
                        sum(ri_comm_exp) ri_comm_exp,
                        sum(net_premium) net_premium,
                        sum(prem_vat) prem_vat,
                        sum(comm_vat) comm_vat
                   FROM giac_assumed_ri_ext a, giis_line b
                  WHERE a.line_cd = b.line_cd
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND ri_cd   = NVL(p_ri_cd, ri_cd)
                    AND a.user_id = p_user_id
               GROUP BY ri_name, ri_cd, a.line_cd, b.line_name
               ORDER BY 1, 3)       
                 
       LOOP
            v_rec.company_name    := cf_company_nameformula;
            v_rec.company_address := cf_company_addressformula;
            v_rec.period          := cf_periodformula(TO_DATE(p_date_from, 'MM-DD-YYYY'),
                                                      TO_DATE(p_date_to, 'MM-DD-YYYY'));
            v_rec.line_cd         := i.line_cd;
            v_rec.ri_cd           := i.ri_cd;
            v_rec.ri_name         := i.ri_name;
            v_rec.amt_insured     := i.amt_insured;
            v_rec.gross_prem_amt  := i.gross_prem_amt;
            v_rec.ri_comm_exp     := i.ri_comm_exp;
            v_rec.net_premium     := i.net_premium;
            v_rec.prem_vat        := i.prem_vat;
            v_rec.comm_vat        := i.comm_vat;
            v_rec.line_name       := i.line_name;
              
            PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;
    
END GIACR171_PKG;
/


