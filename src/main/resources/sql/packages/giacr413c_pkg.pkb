CREATE OR REPLACE PACKAGE BODY CPI.GIACR413C_PKG
AS

    FUNCTION get_commission_payt_dtls(
        p_tran_post     NUMBER,
        p_from_dt       DATE,
        p_to_dt         DATE,
        p_intm_type     giis_intm_type.intm_type%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    ) RETURN commission_payt_tab PIPELINED 
    IS
        v_comm_payt         commission_payt_type;
        v_is_empty          VARCHAR2(1) := 'Y';
    BEGIN
    
        SELECT giacp.v('COMPANY_NAME'), giacp.v('COMPANY_ADDRESS')
          INTO v_comm_payt.cf_company_name, v_comm_payt.cf_company_add
          FROM dual;
            
        SELECT 'From '|| TO_CHAR(p_from_dt , 'fm Month dd, yyyy')||' to '||TO_CHAR(p_to_dt , 'fm Month dd, yyyy')
          INTO v_comm_payt.cf_period
          FROM Dual;
              
        BEGIN
            IF p_tran_post = 1  THEN
                v_comm_payt.cf_tran_post := 'Based on Transaction Date' ;
            ELSE
                v_comm_payt.cf_tran_post := 'Based on Posting Date' ;
            END IF;
        END;
    
        FOR rec IN (SELECT d.intm_type, a.intm_no, e.line_cd, d.intm_name, 
                           SUM (a.comm_amt) comm,
                           SUM (a.wtax_amt) wtax, 
                           SUM (input_vat_amt) input_vat, 
                           SUM (a.comm_amt)-SUM (a.wtax_amt)+SUM (input_vat_amt) net
                      FROM gipi_polbasic e,
                           giac_comm_payts a,
                           gipi_comm_invoice f,
                           giac_acctrans b,
                           giis_intermediary d
                     WHERE 1 = 1
                       AND (   (p_tran_post = 1 AND TRUNC (b.tran_date) BETWEEN p_from_dt AND p_to_dt)
                            OR (p_tran_post = 2 AND TRUNC (b.posting_date) BETWEEN p_from_dt AND p_to_dt)  )
                       AND b.tran_flag <> 'D'
                       --AND b.tran_flag <> 'CP' --system generated payments for cancelled policies  --terrence 11/29/2002 --mikel 12.12.2016;
                       AND b.tran_class NOT IN ('CP', 'CPR') --mikel 12.12.2016; SR 5874 - excluded transactions that are processed from cancelled policies module (GIACS412)
                       AND b.tran_id > 0
                       AND a.gacc_tran_id = b.tran_id
                       AND d.intm_type = nvl(p_intm_type, d.intm_type)
                       AND f.intrmdry_intm_no > 0
                       AND f.iss_cd = a.iss_cd
                       --AND check_user_per_iss_cd_acctg2 (NULL, a.iss_cd, p_module_id, p_user_id) = 1  --added by reymon 05242012 --mikel 12.12.2016;
                       AND EXISTS (SELECT 'X'
                                   FROM table (security_access.get_branch_line('AC', p_module_id, p_user_id))
                                  WHERE branch_cd = a.iss_cd) --mikel 12.12.2016; SR 5874 - optimization
                       AND f.prem_seq_no = a.prem_seq_no
                       AND a.intm_no = d.intm_no
                       AND a.intm_no = f.intrmdry_intm_no  -- belle 08162010 to filter only commission payment for a certain intermediary only for PNBGen PRF5380
                       AND e.policy_id = f.policy_id
                       AND NOT EXISTS (SELECT c.gacc_tran_id
                                         FROM giac_reversals c, giac_acctrans d
                                        WHERE c.reversing_tran_id = d.tran_id
                                          AND d.tran_flag <> 'D'
                                          AND c.gacc_tran_id = a.gacc_tran_id)
                     GROUP BY d.intm_type, a.intm_no, e.line_cd, d.intm_name
                     ORDER BY d.intm_type, d.intm_name)
        LOOP
            v_is_empty := 'N';
            v_comm_payt.intm_no         := rec.intm_no;
            v_comm_payt.intm_name       := rec.intm_name;
            v_comm_payt.intm_type       := rec.intm_type;
            v_comm_payt.line_cd         := rec.line_cd;
            v_comm_payt.commission      := rec.comm;
            v_comm_payt.witholding_tax  := rec.wtax;
            v_comm_payt.input_vat       := rec.input_vat;
            v_comm_payt.net             := rec.net;
            
            SELECT intm_desc
              INTO v_comm_payt.intm_desc
              FROM giis_intm_type
             WHERE intm_type = v_comm_payt.intm_type;
        
            PIPE ROW(v_comm_payt);
        END LOOP;
        
        IF v_is_empty = 'Y' THEN
            PIPE ROW(v_comm_payt);
        END IF;
        
        RETURN;
        
    END get_commission_payt_dtls;
    
END GIACR413C_PKG;
/