CREATE OR REPLACE PACKAGE BODY CPI.GIACS171_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.17.2013
   **  Reference By : GIACS171
   **  Remarks      : RI list of values
   */
    FUNCTION get_ri_lov
        RETURN ri_tab PIPELINED
    IS
        v_list  ri_type;
    BEGIN
        FOR q IN(SELECT *
                    FROM(
--                    SELECT 99999 ri_cd, 'ALL REINSURERS' ri_name
--                           FROM DUAL
--                         UNION
                         SELECT garsd.a180_ri_cd ri_cd, gr.ri_name ri_name
                           FROM giac_aging_ri_soa_details garsd, giis_reinsurer gr
                          WHERE garsd.a180_ri_cd = gr.ri_cd
                       GROUP BY garsd.a180_ri_cd, gr.ri_name)
--                          WHERE ri_cd = NVL(p_ri_cd,ri_cd)
--                            AND UPPER(ri_name) LIKE UPPER(NVL(p_ri_name, ri_name))
                            )
        LOOP
            v_list.ri_cd    := q.ri_cd;
            v_list.ri_name  := q.ri_name;
        PIPE ROW(v_list);
        END LOOP;
    END get_ri_lov;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.17.2013
   **  Reference By : GIACS171
   **  Remarks      : line list of values
   */
    FUNCTION get_line_lov
        RETURN line_tab PIPELINED
    IS
        v_list  line_type;
    BEGIN
        FOR q IN(SELECT *
                   FROM (
--                   SELECT 'A' line_cd,'ALL LINES' line_name 
--                           FROM dual 
--                         UNION 
                         SELECT line_cd, line_name 
                           FROM giis_line)
--                  WHERE UPPER(line_cd) LIKE UPPER(NVL(p_line_cd,line_cd))
--                    AND UPPER(line_name) LIKE UPPER(NVL(p_line_name,line_name))
                    )                         
        LOOP
            v_list.line_cd      := q.line_cd;
            v_list.line_name    := q.line_name; 
            PIPE ROW(v_list);
        END LOOP;
    END get_line_lov;
            
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.19.2013
   **  Reference By : GIACS171
   **  Remarks      : check date
   */       
    FUNCTION get_dates(
        p_user_id       giac_assumed_ri_ext.user_id%TYPE
        
    )
        RETURN date_tab PIPELINED
    IS
        v_date  date_type;
        v_ri    giac_aging_ri_soa_details.a180_ri_cd%TYPE;
        v_line  giis_line.line_cd%TYPE;
    BEGIN
        FOR q IN(SELECT from_date, to_date, param_ri_cd, param_line_cd
                   FROM giac_assumed_ri_ext
                  WHERE rownum = 1
                    AND user_id = p_user_id)
        LOOP
            v_date.from_date := TO_CHAR(q.from_date,'MM-DD-YYYY');
            v_date.to_date   := TO_CHAR(q.to_date, 'MM-DD-YYYY');
            v_date.ri_cd     := q.param_ri_cd;
            v_date.line_cd   := q.param_line_cd; 
            
            IF v_date.ri_cd IS NOT NULL
            THEN
                SELECT ri_name 
                  INTO v_date.ri_name
                  FROM giis_reinsurer
                 WHERE ri_cd = q.param_ri_cd;
            END IF;
            
            IF v_date.line_cd IS NOT NULL
            THEN
                SELECT line_name 
                  INTO v_date.line_name
                  FROM giis_line
                 WHERE line_cd = q.param_line_cd;            
            END IF;
                        
            PIPE ROW(v_date);
        END LOOP;
    END get_dates;
        

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.18.2013
   **  Reference By : GIACS171
   **  Remarks      : extract records
   */    
    PROCEDURE extract_to_table(
        p_from_date     IN  VARCHAR2,
        p_to_date       IN  VARCHAR2,
        p_line_cd       IN  gipi_polbasic.line_cd%TYPE,
        p_ri_cd         IN  giri_inpolbas.ri_cd%TYPE,
        p_user_id       IN  giac_assumed_ri_ext.user_id%TYPE,
        p_msg           OUT   VARCHAR2  
    )
    IS
        v_fund_cd           VARCHAR2(10);
        v_branch_cd         VARCHAR2(10);
        v_ext_count         NUMBER;
    BEGIN
        SELECT param_value_v
          INTO v_fund_cd
          FROM giac_parameters
         WHERE param_name = 'FUND_CD';
        
        SELECT param_value_v
          INTO v_branch_cd
          FROM giac_parameters
         WHERE param_name = 'BRANCH_CD';
      
        DELETE FROM giac_assumed_ri_ext
              WHERE user_id = p_user_id;
        
        FOR k IN (SELECT NVL(ginv.acct_ent_date,gp.acct_ent_date) booking_date, gp.line_cd line_cd, gri.ri_name ri_name, gp.line_cd||'-'||
                         gp.subline_cd||'-'||gp.iss_cd||'-'||gp.issue_yy||'-'|| 
                         LTRIM(TO_CHAR(gp.pol_seq_no, '000000'))||'-'||
                         LTRIM(TO_CHAR(gp.renew_no, '00'))||
                         DECODE(gp.endt_seq_no,0,NULL,'/'||gp.endt_iss_cd||'-'||gp.endt_yy||'-'||
                         LTRIM(TO_CHAR(gp.endt_seq_no,'000000'))) policy_no,
                         NVL(ginv.due_date,gins.due_date) invoice_date,
                         ginv.iss_cd||'-'||LTRIM(TO_CHAR(ginv.prem_seq_no,'000000')) invoice_no,                
                         ROUND(NVL(gp.tsi_amt,0),2) amt_insured,                
                         ROUND(NVL(gins.prem_amt,0) * NVL(ginv.currency_rt,0),2) gross_prem_amt,
                         ROUND((NVL(gins.prem_amt,0)/ DECODE(NVL(ginv.prem_amt,0), 0, 1, ginv.prem_amt))*(NVL(ginv.ri_comm_amt,0)*NVL(ginv.currency_rt,0)),2) ri_comm_exp,
                         ROUND((((NVL(gins.prem_amt,0)/ DECODE(NVL(ginv.prem_amt,0), 0, 1, ginv.prem_amt)) )*((NVL(ginv.prem_amt,0)) + (NVL(ginv.tax_amt,0)) 
                                   - (NVL(ginv.ri_comm_amt,0)) - NVL(ginv.ri_comm_vat,0))* NVL(ginv.currency_rt,0)),2) net_premium, 
                         ROUND(NVL(gins.tax_amt,0)* NVL(ginv.currency_rt,0),2) EVAT,
                         ROUND((NVL(gins.prem_amt,0)/ DECODE(NVL(ginv.prem_amt,0), 0, 1, ginv.prem_amt))*(NVL(GINV.RI_COMM_VAT,0)* NVL(ginv.currency_rt,0)),2) VAT,
                         ga.assd_name assd_name, ginv.prem_seq_no prem_seq_no, gins.inst_no inst_no,
                         gp.iss_cd iss_cd, gp.policy_id policy_id, gip.ri_cd ri_cd, gpl.assd_no assd_no        
                  FROM giri_inpolbas    gip,
                       giis_reinsurer   gri,
                       gipi_invoice     ginv,
                       gipi_parlist     gpl,
                       giis_assured     ga,
                       gipi_installment gins,
                       gipi_polbasic    gp  
                 WHERE 1=1
                   AND gp.policy_id+0   = gip.policy_id                     
                   AND gip.ri_cd        = gri.ri_cd
                   AND gp.policy_id+0   = ginv.policy_id                    
                   AND gp.par_id        = gpl.par_id
                   AND gpl.assd_no      = ga.assd_no
                   AND ginv.iss_cd      = gins.iss_cd
                   AND ginv.prem_seq_no = gins.prem_seq_no      
                   AND gip.ri_cd        = NVL(p_ri_cd, gip.ri_cd) 
                   AND gp.line_cd       = NVL(p_line_cd, gp.line_cd) 
                   AND NVL(ginv.acct_ent_date,gp.acct_ent_date) BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY') AND TO_DATE(p_to_date,'MM-DD-YYYY')
                   /*AND check_user_per_iss_cd_acctg2(gp.line_cd, gp.iss_cd, 'GIACS171', p_user_id) = 1      
                   AND check_user_per_line2(gp.line_cd, gp.iss_cd, 'GIACS171', p_user_id) = 1*/--modified checking of security access by albert 10.22.2015 (GENQA SR 4462)
                   AND ginv.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS171',p_user_id)))
      UNION ALL
                SELECT NVL(ginv.spoiled_acct_ent_date,gp.spld_acct_ent_date) booking_date, gp.line_cd line_cd, gri.ri_sname ri_sname,
                       gp.line_cd||'-'||gp.subline_cd||'-'||gp.iss_cd||'-'||gp.issue_yy||'-'||
                       LTRIM(TO_CHAR(gp.pol_seq_no, '000000'))||'-'||
                       LTRIM(TO_CHAR(gp.renew_no, '00'))||
                       DECODE(gp.endt_seq_no,0,NULL,'/'||gp.endt_iss_cd||'-'||gp.endt_yy||'-'||
                       LTRIM(TO_CHAR(gp.endt_seq_no,'000000'))) policy_no,
                       NVL(ginv.due_date,gins.due_date) invoice_date,
                       ginv.iss_cd||'-'||LTRIM(TO_CHAR(ginv.prem_seq_no,'000000')) invoice_no,
                       ROUND((NVL(gp.tsi_amt,0)) *-1,2) amt_insured,
                       ROUND((NVL(gins.prem_amt,0) * NVL(ginv.currency_rt,0)) *-1,2)  gross_prem_amt, 
                       ROUND((NVL(gins.prem_amt,0)/DECODE(NVL(ginv.prem_amt,0), 0, 1, ginv.prem_amt))*((NVL(ginv.ri_comm_amt,0) * NVL(ginv.currency_rt,0)) *-1),2)  ri_comm_exp,
                       ROUND(((((NVL(gins.prem_amt,0)/ DECODE(NVL(ginv.prem_amt,0), 0, 1, ginv.prem_amt)) )*((NVL(ginv.prem_amt,0)) + (NVL(ginv.tax_amt,0)) 
                                   - (NVL(ginv.ri_comm_amt,0)) - NVL(ginv.ri_comm_vat,0))* NVL(ginv.currency_rt,0))*-1),2) net_premium, 
                       ROUND((NVL(gins.tax_amt,0)* NVL(ginv.currency_rt,0)*-1),2) EVAT,
                       ROUND(((NVL(gins.prem_amt,0)/ DECODE(NVL(ginv.prem_amt,0), 0, 1, ginv.prem_amt))*(NVL(GINV.RI_COMM_VAT,0)*NVL(ginv.currency_rt,0))*-1),2)VAT, 
                       ga.assd_name assd_name, ginv.prem_seq_no prem_seq_no, gins.inst_no inst_no,
                       gp.iss_cd iss_cd, gp.policy_id policy_id, gip.ri_cd ri_cd, gpl.assd_no assd_no                 
                  FROM giri_inpolbas     gip,
                       giis_reinsurer    gri,
                       gipi_invoice      ginv,
                       gipi_parlist      gpl,
                       giis_assured      ga,
                       gipi_installment  gins,
                       gipi_polbasic    gp                    
                 WHERE 1=1 
                   AND ginv.spoiled_acct_ent_date IS NOT NULL 
                   AND gp.policy_id+0        = gip.policy_id                       
                   AND gip.ri_cd             = gri.ri_cd
                   AND gp.policy_id+0        = ginv.policy_id                      
                   AND gp.par_id             = gpl.par_id 
                   AND gpl.assd_no           = ga.assd_no
                   AND ginv.iss_cd           = gins.iss_cd
                   AND ginv.prem_seq_no      = gins.prem_seq_no      
                   AND gip.ri_cd        = NVL(p_ri_cd, gip.ri_cd) 
                   AND gp.line_cd       = NVL(p_line_cd, gp.line_cd) 
                   AND NVL(ginv.spoiled_acct_ent_date,gp.spld_acct_ent_date) BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY') AND TO_DATE(p_to_date,'MM-DD-YYYY')
                   /*AND check_user_per_iss_cd_acctg2(gp.line_cd, gp.iss_cd, 'GIACS171', p_user_id) = 1
                   AND check_user_per_line2(gp.line_cd, gp.iss_cd, 'GIACS171', p_user_id) = 1*/--modified checking of security access by albert 10.22.2015 (GENQA SR 4462)
                   AND ginv.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS171',p_user_id))))      
        LOOP
        
        INSERT INTO giac_assumed_ri_ext 
                    (fund_cd, branch_cd, ri_cd, ri_name, assd_no, assd_name,
                    iss_cd, prem_seq_no, inst_no, policy_id, policy_no, amt_insured, gross_prem_amt, 
                    ri_comm_exp, from_date, to_date, booking_date, invoice_date, line_cd, net_premium,
                    prem_vat, comm_vat, user_id, param_line_cd, param_ri_cd) 
             VALUES (v_fund_cd, v_branch_cd, k.ri_cd, k.ri_name, k.assd_no, k.assd_name,  
                    k.iss_cd, k.prem_seq_no, k.inst_no, k.policy_id, k.policy_no, k.amt_insured, k.gross_prem_amt,
                    k.ri_comm_exp, TO_DATE(p_from_date,'MM-DD-YYYY'), TO_DATE(p_to_date,'MM-DD-YYYY'), k.booking_date, k.invoice_date, k.line_cd, k.net_premium,
                    k.evat, k.vat, p_user_id, p_line_cd, p_ri_cd); 
        END LOOP;   
        
        SELECT COUNT(*) 
          INTO v_ext_count
          FROM giac_assumed_ri_ext
         WHERE from_date = TO_DATE(p_from_date, 'MM-DD-YYYY')
           AND to_date = TO_DATE(p_to_date,'MM-DD-YYYY')
           AND user_id = p_user_id;
        IF v_ext_count = 0 THEN
            p_msg := 'Extraction finished. No records extracted.';        
        ELSE   
            p_msg := 'Extraction finished. '||v_ext_count||' records extracted.';
        END IF;        
        
    END extract_to_table;
   
END GIACS171_PKG;
/
