CREATE OR REPLACE PACKAGE BODY CPI.GIACR171B_PKG AS
 
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
    
    FUNCTION cf_from_dateformula(
        p_user_id   giac_assumed_ri_ext.user_id%TYPE
    ) 
        RETURN VARCHAR2
    IS
        v_from_date    DATE;
    BEGIN  
      SELECT DISTINCT from_date
        INTO v_from_date
        FROM giac_assumed_ri_ext
       WHERE user_id = p_user_id;
      
      RETURN TO_CHAR(v_from_date, 'fmMonth DD, RRRR');
      
    END;
    
    FUNCTION cf_to_dateformula(
        p_user_id   giac_assumed_ri_ext.user_id%TYPE
    )
        RETURN VARCHAR2
    IS
        v_to_date      DATE;
      
    BEGIN
      SELECT DISTINCT to_date
        INTO v_to_date
        FROM giac_assumed_ri_ext
       WHERE user_id = p_user_id;
      
      RETURN TO_CHAR(v_to_date, 'fmMonth DD, RRRR');
      
    END;
    
   FUNCTION populate_giacr171b_records (
        p_line_cd           VARCHAR2,
        p_ri_cd             VARCHAR2,
        p_user_id           VARCHAR2
       )
       RETURN giacr171b_record_tab PIPELINED
    AS
       v_rec                giacr171b_record_type;
       v_company_name       VARCHAR2(200);
       v_company_address    VARCHAR2(400);
       v_from_date          VARCHAR2(200);
       v_to_date            VARCHAR2(200);
       
    BEGIN
       FOR i IN (SELECT assd_no, assd_name, a.line_cd, fund_cd,
                        branch_cd, ri_cd, ri_name, amt_insured,
                        policy_no, gross_prem_amt, ri_comm_exp,
                        booking_date, net_premium, prem_vat,
                        comm_vat, b.line_name
                   FROM giac_assumed_ri_ext a, giis_line b
                  WHERE a.line_cd = b.line_cd
                    AND a.line_cd = NVL(UPPER(p_line_cd), a.line_cd)
                   AND ri_cd = NVL(p_ri_cd, ri_cd)
                   AND a.user_id = p_user_id
              ORDER BY 12)
                 
       LOOP
            v_rec.company_name    := cf_company_nameformula;
            v_rec.company_address := cf_company_addressformula;
            v_rec.from_date       := cf_from_dateformula(p_user_id);
            v_rec.fmto_date       := cf_to_dateformula(p_user_id);
            v_rec.assd_no         := i.assd_no;
            v_rec.assd_name       := i.assd_name;
            v_rec.line_cd         := i.line_cd;
            v_rec.fund_cd         := i.fund_cd;
            v_rec.branch_cd       := i.branch_cd;
            v_rec.ri_cd           := i.ri_cd;
            v_rec.ri_name         := i.ri_name;
            v_rec.amt_insured     := i.amt_insured;
            v_rec.policy_no       := i.policy_no;
            v_rec.gross_prem_amt  := i.gross_prem_amt;
            v_rec.ri_comm_exp     := i.ri_comm_exp;
            v_rec.booking_date    := i.booking_date;
            v_rec.net_premium     := i.net_premium;
            v_rec.prem_vat        := i.prem_vat;
            v_rec.comm_vat        := i.comm_vat;
            v_rec.line_name       := i.line_name; 
                        
            PIPE ROW (v_rec);
       END LOOP;
    END;
    
END GIACR171B_PKG;
/


