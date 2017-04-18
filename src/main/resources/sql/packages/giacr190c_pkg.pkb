CREATE OR REPLACE PACKAGE BODY CPI.GIACR190C_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.29.2013
     ** Referenced By:  GIACR190C - SOA LIST ALL (ASSD)
     **/
    
    
    PROCEDURE CF_TEXT (
        p_beginning_text    OUT VARCHAR2,
        p_end_text          OUT VARCHAR2
    )
    AS
    BEGIN
        FOR REPORT IN (SELECT a.param_name parameter, a.PARAM_VALUE_V TEXT
                         FROM giac_parameters a
                              --giis_reports b    
                        WHERE param_name IN ('COLL_LET_BEG_TEXT','COLL_LET_END_TEXT'))
                          --AND b.report_id =UPPER(P_REP_ID)) 
        LOOP
            IF REPORT.PARAMETER='COLL_LET_BEG_TEXT' THEN                	     
               P_BEGINNING_TEXT := REPORT.TEXT;
            ELSIF REPORT.PARAMETER='COLL_LET_END_TEXT' THEN   
               P_END_TEXT := REPORT.TEXT;
            END IF;   
        END LOOP; 
    END CF_TEXT;
    
    
    FUNCTION CF_DESIGNATION(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2
    AS
        temp4a          giac_documents.report_no%type;
        temp4b          giac_documents.report_id%type;
        temp4c          giac_rep_signatory.label%type;
        temp4d          giis_signatory_names.signatory%type;
        v_designation   VARCHAR(100); 
    BEGIN
        FOR rec IN (SELECT c.designation, b.label
                      FROM giac_documents a,
                           giac_rep_signatory b,
                           giis_signatory_names c
                     WHERE a.report_no=b.report_no
                       AND UPPER(a.report_id) ='GIACR190C'   --added UPPER function by RCD 04/26/2012 to prevent case mismatch
                       AND nvl(a.line_cd ,substr(p_policy_no,1,2)) = substr(p_policy_no,1,2)
                       AND b.signatory_id = c.signatory_id
                     MINUS   
                    SELECT c.designation, b.label
                      FROM giac_documents a,
                           giac_rep_signatory b,
                           giis_signatory_names c
                     WHERE a.report_no=b.report_no
                       AND UPPER(a.report_id) ='GIACR190C' --added UPPER function by RCD 04/26/2012 to prevent case mismatch     
                       AND a.line_cd IS NULL
                       AND EXISTS (SELECT 1
                                     FROM giac_documents
                                    WHERE UPPER(report_id)='GIACR190C' --added UPPER function by RCD 04/26/2012 to prevent case mismatch
                                      AND line_cd = substr(p_policy_no,1,2))
                       AND b.signatory_id=c.signatory_id)
        LOOP
            v_designation:=rec.designation;
        END LOOP;  	
    
        RETURN(v_designation);
    END CF_DESIGNATION;
        
       
    FUNCTION CF_SIGNATORY (
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2
    AS
        temp4a      giac_documents.report_no%type;
        temp4b      giac_documents.report_id%type;
        temp4c      giac_rep_signatory.label%type;
        temp4d      giis_signatory_names.signatory%type;
        v_signatory VARCHAR(100); 
    BEGIN
        FOR rec IN  ( SELECT c.signatory, b.label
                        FROM giac_documents a,
                             giac_rep_signatory b,
                             giis_signatory_names c
                       WHERE a.report_no=b.report_no
                         AND UPPER(a.report_id) ='GIACR190C'--added UPPER function by RCD 04/26/2012 to prevent case mismatch   
                         AND nvl(a.line_cd,substr(p_policy_no,1,2)) = substr(p_policy_no,1,2)
                         AND b.signatory_id = c.signatory_id
                       MINUS   
                      SELECT c.signatory, b.label
                        FROM giac_documents a,
                             giac_rep_signatory b,
                             giis_signatory_names c
                       WHERE a.report_no=b.report_no
                         AND UPPER(a.report_id) ='GIACR190C'--added UPPER function by RCD 04/26/2012 to prevent case mismatch     
                         AND a.line_cd IS NULL
                         AND EXISTS (SELECT 1
                                       FROM giac_documents
                                      WHERE UPPER(report_id)='GIACR190C'--added UPPER function by RCD 04/26/2012 to prevent case mismatch
                                        AND line_cd = substr(p_policy_no,1,2))
                         AND b.signatory_id=c.signatory_id)
        LOOP
            v_signatory:=rec.signatory;
        END LOOP;  	
    
        RETURN(v_signatory);
    END CF_SIGNATORY;
    
    
    FUNCTION CF_ASSD_ADDRESS1(
        p_assd_no   NUMBER
    ) RETURN VARCHAR2
    AS
        v_assd_address VARCHAR2(100);
    BEGIN
        FOR rec IN (SELECT DECODE(bill_addr1,'.',NULL,bill_addr1) address
                      FROM giis_assured
                     WHERE assd_no = p_assd_no) 
        LOOP           
            v_assd_address:= rec.address;   
        END LOOP;
    
        RETURN (INITCAP(v_assd_address));
    END CF_ASSD_ADDRESS1;
    
    
    FUNCTION CF_ASSD_ADDRESS2(
        p_assd_no   NUMBER
    ) RETURN VARCHAR2
    AS
        v_assd_address2 VARCHAR2(100);
    BEGIN
        FOR rec IN (SELECT DECODE(bill_addr2,'.',NULL,bill_addr2) address
                      FROM giis_assured
                     WHERE assd_no = p_assd_no) 
        LOOP           
            v_assd_address2:= rec.address;   
        END LOOP;
        
        RETURN (INITCAP(v_assd_address2));
    END CF_ASSD_ADDRESS2;
    
    
    FUNCTION CF_ASSD_ADDRESS3(
        p_assd_no   NUMBER
    ) RETURN VARCHAR2
    AS
        v_assd_address3 VARCHAR2(100);
    BEGIN
        FOR rec IN (SELECT DECODE(bill_addr3,'.',NULL,bill_addr3) address
                      FROM giis_assured
                     WHERE assd_no = p_assd_no) 
        LOOP           
            v_assd_address3:= rec.address;   
        END LOOP;
    
        RETURN (INITCAP(v_assd_address3));
    END CF_ASSD_ADDRESS3;
    
    
    FUNCTION CF_PROPERTY(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN VARCHAR2
    AS
        v_property gipi_invoice.property%TYPE;
    BEGIN
        FOR rec IN (SELECT property
                      FROM gipi_invoice
                     WHERE iss_cd = p_iss_cd 
                       AND prem_seq_no = p_prem_seq_no) 
        LOOP           
            v_property := rec.property;   
        END LOOP;   
         
        RETURN (v_property);
    END CF_PROPERTY;
    
    
    FUNCTION CF_INTM_NAME(
        p_assd_no   NUMBER,
        p_policy_no VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_intm_name  	giac_soa_rep_ext.intm_name%type;
    BEGIN
        FOR rec IN (SELECT intm_name
                      FROM giac_soa_rep_ext
                     WHERE assd_no = p_assd_no
                       AND policy_no = p_policy_no)
        LOOP
            v_intm_name := rec.intm_name;
        END LOOP;
        
        RETURN (v_intm_name);
    END CF_INTM_NAME;
    
    
    FUNCTION CF_POLICY_NO(
        p_policy_no VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_pol_no  VARCHAR2(50);
    BEGIN
        FOR rec IN (SELECT SUBSTR(p_policy_no,1,INSTR(p_policy_no,'-',1,5)+1) pol_no
                      FROM DUAL)
        LOOP
            v_pol_no := rec.pol_no;
        END LOOP;
            
        RETURN (v_pol_no); 
    END CF_POLICY_NO;
    
    
    FUNCTION CF_EXPIRY_DATE(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN DATE
    AS
        Temp2       gipi_polbasic.expiry_date%type;
        v_expiry    DATE;
    BEGIN
        FOR rec IN (SELECT b.expiry_date
                      FROM gipi_invoice a,
                           gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND a.iss_cd = p_iss_cd
                       AND a.prem_seq_no = p_prem_seq_no )
        LOOP              
            v_expiry := rec.expiry_date;
        END LOOP; 
          
        RETURN (v_expiry);
    END CF_EXPIRY_DATE;
    
    
    FUNCTION CF_INV_DATE(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN DATE
    AS
        temp1       gipi_polbasic.issue_date%type;
        v_issuedate DATE;
    BEGIN
        FOR rec IN (SELECT b.issue_date
                      FROM gipi_invoice a,
                           gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND a.iss_cd = p_iss_cd
                       AND a.prem_seq_no = p_prem_seq_no) 
        LOOP           
            v_issuedate:= rec.issue_date;   
        END LOOP;
        
        RETURN (v_issuedate);
    END CF_INV_DATE;
    
    
    FUNCTION CF_ENDT(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN VARCHAR2
    AS
        v_endt        VARCHAR2(20);
        v_endt_seq_no VARCHAR2(20);
    BEGIN
        FOR rec IN (SELECT b.endt_iss_cd||'-'||b.endt_yy||'-'||b.endt_seq_no endt, 
                           b.endt_seq_no 
                      FROM gipi_invoice a,
                           gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND a.iss_cd = p_iss_cd
                       AND a.prem_seq_no = p_prem_seq_no)
        LOOP
            v_endt:=rec.endt;
            v_endt_seq_no:=rec.endt_seq_no;
        END LOOP;
      
        RETURN (v_endt); 
    END CF_ENDT;
    
    
    FUNCTION CF_INCEPT_DATE(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER
    ) RETURN DATE
    AS
        Temp2           gipi_polbasic.incept_date%type;
        v_inceptdate    DATE;
    BEGIN
        FOR rec IN (SELECT b.incept_date
                      FROM gipi_invoice a,
                           gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND a.iss_cd = p_iss_cd
                       AND a.prem_seq_no = p_prem_seq_no )
        LOOP              
            v_inceptdate := rec.incept_date;
        END LOOP; 
          
        RETURN (v_inceptdate);
    END CF_INCEPT_DATE;
    
    
    FUNCTION CF_INVOICE_NO(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_inst_no       NUMBER,
        p_assd_no       NUMBER
    ) RETURN VARCHAR2
    AS
        v_invoice# varchar2(40);
    BEGIN
        FOR rec IN ( SELECT p_iss_cd||p_prem_seq_no||'-'||p_inst_no invoice# 
                       FROM giac_soa_rep_ext 
                      WHERE assd_no = p_assd_no 
                        AND iss_cd = p_iss_cd 
                      AND prem_seq_no = p_prem_seq_no)
                      --AND user_id=user)
                      /*AND aging_id=(SELECT MAX(aging_id)
                                     FROM giac_soa_rep_ext
                                    WHERE assd_no=:assd_no 
                                        AND iss_cd=:iss_cd 
                                      AND prem_seq_no=:prem_seq_no ))*/
        LOOP
            v_invoice# := rec.invoice#;
        END LOOP;
        
        RETURN(v_invoice#);
    END CF_INVOICE_NO;
    
    
    FUNCTION CF_AGING_ID(           -- CF_1 in RDF
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_assd_no       NUMBER
    ) RETURN VARCHAR2
    AS
        v_aging varchar2(40);
    BEGIN
        FOR rec IN ( SELECT MAX(aging_id)aging_id
                       FROM giac_soa_rep_ext 
                      WHERE assd_no = p_assd_no 
                        AND iss_cd = p_iss_cd 
                      AND prem_seq_no = p_prem_seq_no)
                      /*AND aging_id=(SELECT MAX(aging_id)
                                     FROM giac_soa_rep_ext
                                    WHERE assd_no=:assd_no 
                                        AND iss_cd=:iss_cd 
                                      AND prem_seq_no=:prem_seq_no ))*/
        LOOP
            v_aging := rec.aging_id;
        END LOOP;
        
        RETURN(v_aging);
    END CF_AGING_ID;
    
        
    FUNCTION get_report_details(
        p_selected_intm_no  VARCHAR2,  
        p_selected_assd_no  VARCHAR2,
        p_selected_aging_id VARCHAR2, -- giac_soa_rep_ext.AGING_ID%type,
        p_user              giac_soa_rep_ext.USER_ID%type,
        p_print_btn_no      NUMBER
    ) RETURN report_details_tab PIPELINED
    AS
        rep                 report_details_type;
        v_endt_seq_no       VARCHAR2(20);
        v_selected_intm_no  VARCHAR2(1000);
        v_intm_no           VARCHAR2(14);
        v_selected_assd_no  VARCHAR2(1000);
        v_assd_no           VARCHAR2(14);
        v_selected_aging_id VARCHAR2(1000);
        v_aging_id          VARCHAR2(5);
    BEGIN
        IF p_print_btn_no = 4 THEN  --  FMB query variables.print_btn_no := 4
            v_selected_intm_no := p_selected_intm_no;
            v_selected_aging_id := p_selected_aging_id;
            
            FOR g IN (SELECT DISTINCT aging_id
                        FROM giac_soa_rep_ext
                       WHERE user_id = p_user)
            LOOP
                v_aging_id := '#' || g.aging_id || '#';
                
                IF INSTR(v_selected_aging_id, v_aging_id) != 0 THEN
                    FOR h IN (SELECT DISTINCT intm_no
                                FROM giac_soa_rep_ext 	                  
                               WHERE aging_id = REPLACE(v_aging_id, '#') 
                                 AND user_id = p_user)
                    LOOP
                        v_intm_no := '#' || h.intm_no || '#';
                        
                        IF INSTR(v_selected_intm_no, v_intm_no) != 0 THEN
                            FOR i IN ( SELECT assd_name, assd_no,   --added 
                                              intm_name, intm_no,    
                                              policy_no policy, 
                                              (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                              (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                              iss_cd, prem_seq_no, 
                                              prem_bal_due, tax_bal_due,
                                              balance_amt_due, inst_no
                                         FROM giac_soa_rep_ext
                                        WHERE intm_no = REPLACE(v_intm_no, '#')  	                  
                                          AND aging_id = REPLACE(v_aging_id, '#') 
                                          AND user_id = p_user
                                        ORDER BY assd_no, policy_no
                                        --original RDF query --
                                        /*SELECT RPAD (' ', 100) intm_name, 
                                               1 intm_no, 
                                               RPAD (' ', 100) assd_name,
                                               1 assd_no, 
                                               RPAD (' ', 50) POLICY,               ---added 04/26/2012 RCD
                                               RPAD (' ', 50) policy_no,
                                               RPAD (' ', 20) endt_no,                         ---added 04/26/2012 RCD
                                               RPAD (' ', 2) iss_cd,
                                               1 prem_seq_no,
                                               1 prem_bal_due,
                                               1 tax_bal_due,
                                               1 balance_amt_due,
                                               1 inst_no
                                          FROM DUAL */ ) 
                            LOOP
                                rep.intm_name       := i.intm_name;
                                rep.intm_no         := i.intm_no;
                                rep.assd_name       := i.assd_name;
                                rep.assd_no         := i.assd_no;
                                rep.policy          := i.policy;
                                rep.policy_no       := i.policy_no;
                                rep.endt_no         := i.endt_no;
                                rep.iss_cd          := i.iss_cd;
                                rep.prem_seq_no     := i.prem_seq_no;
                                rep.prem_bal_due    := i.prem_bal_due;
                                rep.tax_bal_due     := i.tax_bal_due;
                                rep.balance_amt_due := i.balance_amt_due;
                                rep.inst_no         := i.inst_no;
                                
                                CF_TEXT(rep.cf_beginning_text, rep.cf_end_text);
                                rep.cf_designation      := CF_DESIGNATION(i.policy_no);
                                rep.cf_signatory        := CF_SIGNATORY(i.policy_no);
                                rep.cf_assd_address1    := CF_ASSD_ADDRESS1(i.assd_no);
                                rep.cf_assd_address2    := CF_ASSD_ADDRESS2(i.assd_no);
                                rep.cf_assd_address3    := CF_ASSD_ADDRESS3(i.assd_no);
                                rep.cf_property         := CF_PROPERTY(i.iss_cd, i.prem_seq_no);
                                rep.cf_intm_name        := CF_INTM_NAME(i.assd_no, i.policy_no);
                                rep.cf_policy_no        := CF_POLICY_NO(i.policy_no);
                                rep.cf_expiry_date      := CF_EXPIRY_DATE(i.iss_cd, i.prem_seq_no);
                                rep.cf_inv_date         := CF_INV_DATE(i.iss_cd, i.prem_seq_no);
                                rep.cf_endt             := CF_ENDT(i.iss_cd, i.prem_seq_no);
                                rep.cf_incept_date      := CF_INCEPT_DATE(i.iss_cd, i.prem_seq_no);
                                rep.cf_invoice_no       := CF_INVOICE_NO(i.iss_cd, i.prem_seq_no, i.inst_no, i.assd_no);
                                rep.cf_aging_id         := CF_AGING_ID(i.iss_cd, i.prem_seq_no, i.assd_no);
                                
                                --F_ENDTFormatTrigger
                                FOR rec IN  ( SELECT b.endt_seq_no 
                                                FROM gipi_invoice a,
                                                     gipi_polbasic b
                                               WHERE a.policy_id = b.policy_id
                                                 AND a.iss_cd = i.iss_cd
                                                 AND a.prem_seq_no = i.prem_seq_no)
                                LOOP
                                    v_endt_seq_no:= rec.endt_seq_no;
                                END LOOP;
                                
                                IF v_endt_seq_no = 0 THEN
                                    rep.print_cf_endt  := 'N';
                                ELSE	
                                    rep.print_cf_endt  := 'Y';
                                END IF;  
                                
                                PIPE ROW(rep);
                            END LOOP;
                        END IF;
                    END LOOP;   
                END IF;
            END LOOP;
        
        
        ELSIF p_print_btn_no = 5 THEN --  FMB query variables.print_btn_no := 5   
            v_selected_assd_no  := p_selected_assd_no;
            
            FOR h IN (SELECT DISTINCT assd_no
                        FROM giac_soa_rep_ext
                       WHERE user_id = p_user 
                       ORDER BY assd_no)
            LOOP             
                v_assd_no   := '#' || h.assd_no || '#';
                        
                IF INSTR(v_selected_assd_no, v_assd_no) != 0 THEN
                    FOR i IN (SELECT assd_name, assd_no, 
                                     policy_no policy, 
                                     (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                     (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                     iss_cd, prem_seq_no, 
                                     prem_bal_due, tax_bal_due,
                                     balance_amt_due, inst_no
                                FROM giac_soa_rep_ext
                               WHERE assd_no = REPLACE(v_assd_no, '#')
                                 AND user_id = p_user 
                               ORDER BY assd_no, policy_no)  
                    LOOP
                        --rep.intm_name       := i.intm_name;
                        --rep.intm_no         := i.intm_no;
                        rep.assd_name       := i.assd_name;
                        rep.assd_no         := i.assd_no;
                        rep.policy          := i.policy;
                        rep.policy_no       := i.policy_no;
                        rep.endt_no         := i.endt_no;
                        rep.iss_cd          := i.iss_cd;
                        rep.prem_seq_no     := i.prem_seq_no;
                        rep.prem_bal_due    := i.prem_bal_due;
                        rep.tax_bal_due     := i.tax_bal_due;
                        rep.balance_amt_due := i.balance_amt_due;
                        rep.inst_no         := i.inst_no;
                                
                        CF_TEXT(rep.cf_beginning_text, rep.cf_end_text);
                        rep.cf_designation      := CF_DESIGNATION(i.policy_no);
                        rep.cf_signatory        := CF_SIGNATORY(i.policy_no);
                        rep.cf_assd_address1    := CF_ASSD_ADDRESS1(i.assd_no);
                        rep.cf_assd_address2    := CF_ASSD_ADDRESS2(i.assd_no);
                        rep.cf_assd_address3    := CF_ASSD_ADDRESS3(i.assd_no);
                        rep.cf_property         := CF_PROPERTY(i.iss_cd, i.prem_seq_no);
                        rep.cf_intm_name        := CF_INTM_NAME(i.assd_no, i.policy_no);
                        rep.cf_policy_no        := CF_POLICY_NO(i.policy_no);
                        rep.cf_expiry_date      := CF_EXPIRY_DATE(i.iss_cd, i.prem_seq_no);
                        rep.cf_inv_date         := CF_INV_DATE(i.iss_cd, i.prem_seq_no);
                        rep.cf_endt             := CF_ENDT(i.iss_cd, i.prem_seq_no);
                        rep.cf_incept_date      := CF_INCEPT_DATE(i.iss_cd, i.prem_seq_no);
                        rep.cf_invoice_no       := CF_INVOICE_NO(i.iss_cd, i.prem_seq_no, i.inst_no, i.assd_no);
                        rep.cf_aging_id         := CF_AGING_ID(i.iss_cd, i.prem_seq_no, i.assd_no);
                                
                        --F_ENDTFormatTrigger
                        FOR rec IN  ( SELECT b.endt_seq_no 
                                        FROM gipi_invoice a,
                                             gipi_polbasic b
                                       WHERE a.policy_id = b.policy_id
                                         AND a.iss_cd = i.iss_cd
                                         AND a.prem_seq_no = i.prem_seq_no)
                        LOOP
                            v_endt_seq_no:= rec.endt_seq_no;
                        END LOOP;
                                
                        IF v_endt_seq_no = 0 THEN
                            rep.print_cf_endt  := 'N';
                        ELSE	
                            rep.print_cf_endt  := 'Y';
                        END IF;  
                                
                        PIPE ROW(rep);
                    END LOOP;
                END IF;
            END LOOP;
                 
            
        ELSIF p_print_btn_no = 6 THEN --  FMB query variables.print_btn_no := 6   
            v_selected_assd_no  := p_selected_assd_no;
            v_selected_aging_id := p_selected_aging_id;
            
            FOR g IN (SELECT DISTINCT aging_id
                        FROM giac_soa_rep_ext
                       WHERE user_id = p_user)
            LOOP
                v_aging_id := '#' || g.aging_id || '#';
                
                IF INSTR(v_selected_aging_id, v_aging_id) != 0 THEN
                    FOR h IN (SELECT DISTINCT assd_no
                                FROM giac_soa_rep_ext
                               WHERE user_id = p_user 
                                 AND aging_id = REPLACE(v_aging_id, '#')  
                               ORDER BY assd_no)
                    LOOP             
                        v_assd_no   := '#' || h.assd_no || '#';
                        
                        IF INSTR(v_selected_assd_no, v_assd_no) != 0 THEN
                            FOR i IN (SELECT assd_name, assd_no, 
                                             policy_no policy, 
                                             (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                             (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                             iss_cd, prem_seq_no, 
                                             prem_bal_due, tax_bal_due,
                                             balance_amt_due, inst_no
                                        FROM giac_soa_rep_ext
                                       WHERE assd_no = REPLACE(v_assd_no, '#')
                                         AND user_id = p_user 
                                         AND aging_id = REPLACE(v_aging_id, '#')  --  for FMB query variables.print_btn_no := 6 
                                       ORDER BY assd_no, policy_no)  
                            LOOP
                                --rep.intm_name       := i.intm_name;
                                --rep.intm_no         := i.intm_no;
                                rep.assd_name       := i.assd_name;
                                rep.assd_no         := i.assd_no;
                                rep.policy          := i.policy;
                                rep.policy_no       := i.policy_no;
                                rep.endt_no         := i.endt_no;
                                rep.iss_cd          := i.iss_cd;
                                rep.prem_seq_no     := i.prem_seq_no;
                                rep.prem_bal_due    := i.prem_bal_due;
                                rep.tax_bal_due     := i.tax_bal_due;
                                rep.balance_amt_due := i.balance_amt_due;
                                rep.inst_no         := i.inst_no;
                                
                                CF_TEXT(rep.cf_beginning_text, rep.cf_end_text);
                                rep.cf_designation      := CF_DESIGNATION(i.policy_no);
                                rep.cf_signatory        := CF_SIGNATORY(i.policy_no);
                                rep.cf_assd_address1    := CF_ASSD_ADDRESS1(i.assd_no);
                                rep.cf_assd_address2    := CF_ASSD_ADDRESS2(i.assd_no);
                                rep.cf_assd_address3    := CF_ASSD_ADDRESS3(i.assd_no);
                                rep.cf_property         := CF_PROPERTY(i.iss_cd, i.prem_seq_no);
                                rep.cf_intm_name        := CF_INTM_NAME(i.assd_no, i.policy_no);
                                rep.cf_policy_no        := CF_POLICY_NO(i.policy_no);
                                rep.cf_expiry_date      := CF_EXPIRY_DATE(i.iss_cd, i.prem_seq_no);
                                rep.cf_inv_date         := CF_INV_DATE(i.iss_cd, i.prem_seq_no);
                                rep.cf_endt             := CF_ENDT(i.iss_cd, i.prem_seq_no);
                                rep.cf_incept_date      := CF_INCEPT_DATE(i.iss_cd, i.prem_seq_no);
                                rep.cf_invoice_no       := CF_INVOICE_NO(i.iss_cd, i.prem_seq_no, i.inst_no, i.assd_no);
                                rep.cf_aging_id         := CF_AGING_ID(i.iss_cd, i.prem_seq_no, i.assd_no);
                                
                                --F_ENDTFormatTrigger
                                FOR rec IN  ( SELECT b.endt_seq_no 
                                                FROM gipi_invoice a,
                                                     gipi_polbasic b
                                               WHERE a.policy_id = b.policy_id
                                                 AND a.iss_cd = i.iss_cd
                                                 AND a.prem_seq_no = i.prem_seq_no)
                                LOOP
                                    v_endt_seq_no:= rec.endt_seq_no;
                                END LOOP;
                                
                                IF v_endt_seq_no = 0 THEN
                                    rep.print_cf_endt  := 'N';
                                ELSE	
                                    rep.print_cf_endt  := 'Y';
                                END IF;  
                                
                                PIPE ROW(rep);
                            END LOOP;
                        END IF;
                    END LOOP;
                END IF;
            END LOOP;
            
        END IF;
        
    END get_report_details;
    

END GIACR190C_PKG;
/


