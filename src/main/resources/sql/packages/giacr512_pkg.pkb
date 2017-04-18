CREATE OR REPLACE PACKAGE BODY CPI.GIACR512_PKG
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.01.2013
    **  Reference By : GIACR512_PKG - PAID PREMIUM
    */

    FUNCTION cf_iss_cdformula(
    p_iss_cd VARCHAR2
    )
       RETURN CHAR
    IS
       v_iss   VARCHAR2 (100) := NULL;
    BEGIN
       FOR c1 IN (SELECT UPPER (iss_name) iss_name
                    FROM giis_issource
                   WHERE iss_cd = p_iss_cd)
       LOOP
          v_iss := c1.iss_name || ' INTERMEDIARIES';
       END LOOP;

       RETURN (v_iss);
    END;
    FUNCTION cf_yearformula(
    p_tran_year     VARCHAR2
    )   
       RETURN CHAR
    IS
       v_from_to   VARCHAR2 (100);
    BEGIN
       RETURN ('PAID PREMIUM FOR THE YEAR ' || p_tran_year);
    END;
    FUNCTION cf_company_addressformula
       RETURN CHAR
    IS
       v_company_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       FOR rec IN (SELECT giacp.v ('COMPANY_ADDRESS') v_company_name
                     FROM DUAL)
       LOOP
          v_company_name := rec.v_company_name;
       END LOOP;

       RETURN (v_company_name);
    END;
    
    FUNCTION cf_company_nameformula
       RETURN CHAR
    IS
       v_company_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       FOR rec IN (SELECT giacp.v ('COMPANY_NAME') v_company_name
                     FROM DUAL)
       LOOP
          v_company_name := rec.v_company_name;
       END LOOP;

       RETURN (v_company_name);
    END;
    
    FUNCTION cf_perilformula(
        p_line_cd   VARCHAR2,
        p_peril_cd  NUMBER
    )
       RETURN CHAR
    IS
       v_peril   giis_peril.peril_name%TYPE   := NULL;
    BEGIN
       FOR c1 IN (SELECT peril_name
                    FROM giis_peril
                   WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd)
       LOOP
          v_peril := c1.peril_name;
       END LOOP;

       RETURN (v_peril);
    END;
    
    FUNCTION cf_intermediaryformula(
        p_intermediary_no NUMBER
    )
       RETURN CHAR
    IS
       v_intm   VARCHAR2 (300);
       p_cp_intm_name   VARCHAR2(300);
    BEGIN
       SELECT intm_no || '-' || intm_name, intm_name
         INTO v_intm, p_cp_intm_name
         FROM giis_intermediary
        WHERE intm_no = p_intermediary_no;
       RETURN (v_intm);
    END;
    
    FUNCTION get_giacr512_record1 (
        p_tran_year     VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_intm_no       NUMBER,
        p_user_id   giis_users.user_id%TYPE
    )
    RETURN giacr512_record_tab PIPELINED
    IS
        v_list giacr512_record_type;
    BEGIN
        FOR i IN ( 
                SELECT NVL(a.parent_intm_no, a.intm_no) intermediary_no, a.line_cd, a.peril_cd, peril_name, SUM(NVL(prem_amt,0)) prem_amt_sum, SUM(NVL(comm_amt,0)) comm_amt_sum, SUM(NVL(prem_amt,0) * NVL(facul_pct,0)) facul_prem_sum, SUM(NVL(comm_amt,0)*NVL(facul_pct,0)) facul_comm_sum
                FROM giis_peril b, giac_cpc_dtl a
                WHERE b.line_cd = a.line_cd
                  AND b.peril_cd = a.peril_cd
                       AND tran_year = p_tran_year
                       AND intm_no = p_intm_no
                       AND a.user_id = p_user_id
                GROUP BY NVL(a.parent_intm_no, a.intm_no), a.line_cd, a.peril_cd, peril_name
                ORDER BY NVL(a.parent_intm_no, a.intm_no), a.line_cd, a.peril_cd, peril_name    
    
        )    
        LOOP
            v_list.intermediary_no1 := i.intermediary_no;
            v_list.line_cd1 := i.line_cd;
            v_list.peril_cd1 := i.peril_cd;
            v_list.peril_name1 := i.peril_name;
            v_list.prem_amt_sum := i.prem_amt_sum;
            v_list.comm_amt_sum := i.comm_amt_sum;
            v_list.facul_prem_sum := i.facul_prem_sum;
            v_list.facul_comm_sum := i.facul_comm_sum;
            
            FOR z IN (  
               SELECT  intm_name
                 FROM giis_intermediary
                WHERE intm_no = i.intermediary_no)
            LOOP
                v_list.intm_name1 := z.intm_name;
            END LOOP;
             

            PIPE ROW (v_list);        
        END LOOP; 
    END get_giacr512_record1;
      
    FUNCTION get_giacr512_record (
        p_tran_year     VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_intm_no       NUMBER,
        p_user_id   giis_users.user_id%TYPE
    )
    RETURN giacr512_record_tab PIPELINED
    IS
        v_list giacr512_record_type;
    BEGIN
        FOR i IN (
                SELECT NVL(a.parent_intm_no, a.intm_no) intermediary_no, 
                       policy_id, get_policy_no(policy_id) policy_no, 
                       prem_seq_no, acct_ent_date,
                       line_cd, peril_cd, 
                       NVL(prem_amt,0) prem_amt, 
                       NVL(comm_amt,0) comm_amt, 
                       NVL(facul_pct,0) FACUL_PCT, 
                       NVL(prem_amt,0) * NVL(facul_pct,0) facul_prem, 
                       NVL(comm_amt,0) * NVL(facul_pct,0) facul_comm,
                       tran_id, tran_doc, tran_date 
                  FROM giis_intermediary b, 
                       giac_cpc_dtl a
                 WHERE 1=1
                   AND b.intm_no = NVL(a.parent_intm_no, a.intm_no)
                   AND tran_year = p_tran_year
                   AND b.iss_cd = NVL(p_iss_cd,b.iss_cd)
                   AND NVL(a.parent_intm_no, a.intm_no) = NVL(p_intm_no,NVL(a.parent_intm_no, a.intm_no))
                   AND a.user_id = p_user_id
                 ORDER BY intermediary_no, policy_no
             )
        LOOP
            v_list.intermediary_no := i.intermediary_no;
            v_list.policy_id := i.policy_id;
            v_list.policy_no := i.policy_no;
            v_list.prem_seq_no := i.prem_seq_no;
            v_list.acct_ent_date := i.acct_ent_date;
            v_list.line_cd := i.line_cd;
            v_list.peril_cd := i.peril_cd;
            v_list.prem_amt := i.prem_amt;
            v_list.comm_amt := i.comm_amt;
            v_list.FACUL_PCT := i.FACUL_PCT;
            v_list.facul_prem := i.facul_prem;
            v_list.facul_comm := i.facul_comm;
            v_list.tran_id := i.tran_id;
            v_list.tran_doc := i.tran_doc;
            v_list.tran_date := i.tran_date;
            v_list.intm_name := cf_intermediaryformula(i.intermediary_no);
            v_list.peril := cf_perilformula(i.line_cd, i.peril_cd);
            v_list.company_name := cf_company_nameformula;
            v_list.company_address := cf_company_addressformula;
            v_list.cf_year := cf_yearformula(p_tran_year);
            v_list.cf_iss_cd := cf_iss_cdformula(p_iss_cd);        
        
            FOR c1 IN (SELECT assd_name, b.assd_no, b.eff_date, b.prem_amt
                         FROM giis_assured a, gipi_polbasic b
                        WHERE a.assd_no = b.assd_no AND b.policy_id = i.policy_id)
            LOOP
            
              v_list.cp_assd_name := c1.assd_name;
              v_list.cp_eff_date := c1.eff_date;
              v_list.cp_prem_amt := c1.prem_amt;
              
            END LOOP;           
           
            PIPE ROW(v_list);
        END LOOP;       
    END get_giacr512_record;

END;
/


