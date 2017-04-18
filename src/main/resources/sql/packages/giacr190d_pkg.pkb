CREATE OR REPLACE PACKAGE BODY CPI.GIACR190D_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   06.04.2013
     ** Referenced By:  GIACR190D - SOA AGING (ASSD)
     **/
    
    FUNCTION CF_ASSD_ADDRESS1(
        p_assd_no       GIIS_ASSURED.ASSD_NO%TYPE
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
        p_assd_no       GIIS_ASSURED.ASSD_NO%TYPE
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
        p_assd_no       GIIS_ASSURED.ASSD_NO%TYPE
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
    
    
    FUNCTION CF_CUTOFF_DATE(
        p_assd_no   GIAC_SOA_REP_EXT.ASSD_NO%TYPE,
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN DATE
    AS
        cut_date_v       DATE;
    BEGIN
        FOR rec IN (SELECT DISTINCT param_date              
                      FROM giac_soa_rep_ext
                     WHERE user_id = p_user
                       AND assd_no = p_assd_no)
        LOOP
            IF rec.param_date IS NOT NULL THEN              
                cut_date_v:=rec.param_date;
            ELSE
                cut_date_v:=LAST_DAY(SYSDATE);  
            END IF;	
        END LOOP;
    
        RETURN (cut_date_v);
    END CF_CUTOFF_DATE;
    
    
    FUNCTION CF_INTM_NO(
        p_assd_no       giac_soa_rep_ext.ASSD_NO%TYPE,
        p_policy_no     giac_soa_rep_ext.POLICY_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_intm_no  	NUMBER(20);
    BEGIN 
        FOR rec IN (SELECT intm_no
                      FROM giac_soa_rep_ext
                     WHERE assd_no = p_assd_no
                       AND policy_no = p_policy_no)
        LOOP
            v_intm_no := rec.intm_no;
        END LOOP;
    
        RETURN (v_intm_no);
    END CF_INTM_NO;
    
    
    FUNCTION CF_INTM_NAME(
        p_assd_no       giac_soa_rep_ext.ASSD_NO%TYPE,
        p_policy_no     giac_soa_rep_ext.POLICY_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_intm_name  	giac_soa_rep_ext.INTM_NAME%type;
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
    
    
    FUNCTION CF_PROPERTY(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
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
    
    
    FUNCTION CF_INCEPT_DATE(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_inceptdate    DATE;
    BEGIN 
        FOR rec IN (SELECT b.incept_date
                      FROM gipi_invoice a,
                           gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND a.iss_cd = p_iss_cd
                       AND a.prem_seq_no = p_prem_seq_no)
        LOOP              
            v_inceptdate := rec.incept_date;
        END LOOP;   
    
        RETURN (v_inceptdate);
    END CF_INCEPT_DATE;
    
    
    FUNCTION CF_EXPIRY_DATE(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_expiry DATE;
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
    
    
    FUNCTION CF_POLICY_NO(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_pol_no  VARCHAR2(30); --VARCHAR2(20);
    BEGIN 
        FOR rec IN (SELECT SUBSTR(p_policy_no,1,INSTR(p_policy_no,'-',1,5)+1)pol_no
                      FROM DUAL)
        LOOP
            v_pol_no := rec.pol_no;
        END LOOP;
    
        RETURN (v_pol_no); 
    END CF_POLICY_NO;
    
    
    FUNCTION CF_INV_DATE(
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2
    AS
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
        p_iss_cd        GIPI_INVOICE.ISS_CD%TYPE,
        p_prem_seq_no   GIPI_INVOICE.PREM_SEQ_NO%TYPE
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
    
    
    FUNCTION CF_INVOICE_NO(
        p_iss_cd        giac_soa_rep_ext.ISS_CD%type,
        p_prem_seq_no   giac_soa_rep_ext.PREM_SEQ_NO%type,
        p_inst_no       giac_soa_rep_ext.INST_NO%type,
        p_assd_no       giac_soa_rep_ext.ASSD_NO%type
    ) RETURN VARCHAR2
    AS
        v_invoice# varchar2(40);
    BEGIN 
        FOR rec IN (SELECT p_iss_cd||p_prem_seq_no||'-'||p_inst_no invoice# 
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
    
        return(v_invoice#);
    END CF_INVOICE_NO;
    
    
    FUNCTION CF_AGING_ID(
        p_assd_no       GIAC_SOA_REP_EXT.ASSD_NO%TYPE,
        p_iss_cd        GIAC_SOA_REP_EXT.ISS_CD%TYPE,
        p_prem_seq_no   GIAC_SOA_REP_EXT.PREM_SEQ_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_aging varchar2(40);
    BEGIN 
        FOR rec IN (SELECT MAX(aging_id)aging_id
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
    
    
    FUNCTION CF_DESIGNATION(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_designation VARCHAR(100); 
    BEGIN 
        FOR rec IN (SELECT c.designation, b.label
                      FROM giac_documents a,
                           giac_rep_signatory b,
                           giis_signatory_names c
                     WHERE a.report_no = b.report_no
                       AND a.report_id ='GIACR190c'   
                       AND nvl(a.line_cd,substr(p_policy_no,1,2)) = substr(p_policy_no,1,2)
                       AND b.signatory_id = c.signatory_id
                     MINUS   
                    SELECT c.designation, b.label
                      FROM giac_documents a,
                           giac_rep_signatory b,
                           giis_signatory_names c
                     WHERE a.report_no = b.report_no
                       AND a.report_id ='GIACR190c'     
                       AND a.line_cd IS NULL
                       AND EXISTS (SELECT 1
                                     FROM giac_documents
                                    WHERE report_id = 'GIACR190c'
                                      AND line_cd = substr(p_policy_no,1,2))
                       AND b.signatory_id = c.signatory_id)
        LOOP
            v_designation := rec.designation;
        END LOOP;  	
    
        RETURN(v_designation);
    END CF_DESIGNATION;
    
    
    FUNCTION CF_SIGNATORY(
        p_policy_no     VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_signatory VARCHAR(100); 
    BEGIN 
        FOR rec IN (SELECT c.signatory, b.label
                      FROM giac_documents a,
                           giac_rep_signatory b,
                           giis_signatory_names c
                     WHERE a.report_no = b.report_no
                       AND a.report_id ='GIACR190c'   
                       AND nvl(a.line_cd,substr(p_policy_no,1,2)) = substr(p_policy_no,1,2)
                       AND b.signatory_id = c.signatory_id
                     MINUS   
                    SELECT c.signatory, b.label
                      FROM giac_documents a,
                           giac_rep_signatory b,
                           giis_signatory_names c
                     WHERE a.report_no = b.report_no
                       AND a.report_id ='GIACR190c'     
                       AND a.line_cd IS NULL
                       AND EXISTS (SELECT 1
                                     FROM giac_documents
                                    WHERE report_id = 'GIACR190c'
                                      AND line_cd = substr(p_policy_no,1,2))
                       AND b.signatory_id = c.signatory_id)
        LOOP
            v_signatory := rec.signatory;
        END LOOP;  	
    
        RETURN(v_signatory);
    END CF_SIGNATORY;
    
    
    FUNCTION GET_REPORT_DETAILS(
        p_assd_no               giac_soa_rep_ext.ASSD_NO%type,
        p_selected_aging_id     VARCHAR2,
        p_user                  VARCHAR2
    ) RETURN report_details_tab PIPELINED
    AS
        rep                 report_details_type;
        v_selected_aging_id VARCHAR2(1000);
        v_aging_id          VARCHAR2(5);
    BEGIN 
        v_selected_aging_id := p_selected_aging_id;
        
        FOR h IN (SELECT DISTINCT aging_id
                    FROM giac_soa_rep_ext
                   WHERE assd_no = p_assd_no	                   
                     AND user_id = p_user )
        LOOP
            v_aging_id := '#' || h.aging_id ||'#';
            
            IF INSTR(v_selected_aging_id, v_aging_id) != 0 THEN
                FOR i IN ( -- RDF original query --
                          /*SELECT rpad(' ',500) assd_name, /***100 to 500***totel***7/10/2006*** /
                                 1 assd_no,
                                 rpad(' ',100) intm_name,
                                 1 intm_no,
                                 rpad(' ',50) policy ,       --includes endt_no
                                 rpad(' ',50) policy_no , --without endt_no
                                 rpad(' ',20) endt_no,
                                 rpad(' ',2) iss_cd,
                                 1 prem_seq_no,
                                 1 prem_bal_due,
                                 1 tax_bal_due,
                                 1 balance_amt_due,
                                 1 inst_no
                            FROM dual */ 
                            
                           -- FMB parameter query--
                           SELECT assd_name, assd_no, intm_name,
                                  intm_no, policy_no policy, 
                                  (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                  (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                  iss_cd, prem_seq_no, prem_bal_due,
                                  tax_bal_due, balance_amt_due, inst_no
                             FROM giac_soa_rep_ext
                            WHERE assd_no = p_assd_no
                              AND aging_id= REPLACE(v_aging_id, '#')  	                   
                              AND user_id = p_user 
                            ORDER BY assd_no, intm_no, policy_no)
                LOOP
                    rep.assd_no             := i.assd_no;
                    rep.assd_name           := i.assd_name;
                    rep.cf_assd_address1    := CF_ASSD_ADDRESS1(i.assd_no);
                    rep.cf_assd_address2    := CF_ASSD_ADDRESS2(i.assd_no);
                    rep.cf_assd_address3    := CF_ASSD_ADDRESS3(i.assd_no);
                    rep.cf_cutoff_date      := CF_CUTOFF_DATE(i.assd_no, p_user);
                    rep.cf_cutoff_date2     := TO_CHAR(rep.cf_cutoff_date, 'fmMonth DD, RRRR');
                    rep.intm_no             := i.intm_no;
                    rep.intm_name           := i.intm_name;
                    rep.cf_intm_no          := CF_INTM_NO(i.assd_no, i.policy_no);
                    rep.cf_intm_name        := CF_INTM_NAME(i.assd_no, i.policy_no);
                    rep.cf_property         := CF_PROPERTY(i.iss_cd, i.prem_seq_no);
                    rep.cf_incept_date      := CF_INCEPT_DATE(i.iss_cd, i.prem_seq_no);
                    rep.cf_expiry_date      := CF_EXPIRY_DATE(i.iss_cd, i.prem_seq_no);
                    rep.policy              := i.policy;
                    rep.policy_no           := i.policy_no;
                    rep.cf_policy_no        := CF_POLICY_NO(i.policy_no);
                    rep.endt_no             := i.endt_no;
                    rep.cf_inv_date         := CF_INV_DATE(i.iss_cd, i.prem_seq_no);
                    rep.cf_endt             := CF_ENDT(i.iss_cd, i.prem_seq_no);
                    rep.cf_invoice_no       := CF_INVOICE_NO(i.iss_cd, i.prem_seq_no, i.inst_no, i.assd_no);
                    rep.iss_cd              := i.iss_cd;
                    rep.inst_no             := i.inst_no;
                    rep.cf_aging_id         := CF_AGING_ID(i.assd_no, i.iss_cd, i.prem_seq_no);
                    rep.prem_seq_no         := i.prem_seq_no;
                    rep.prem_bal_due        := i.prem_bal_due;
                    rep.tax_bal_due         := i.tax_bal_due;
                    rep.balance_amt_due     := i.balance_amt_due;
                    rep.cf_designation      := CF_DESIGNATION(i.policy_no);
                    rep.cf_signatory        := CF_SIGNATORY(i.policy_no);
                
                    PIPE ROW(rep);
                END LOOP;
            END IF;
        END LOOP;
        
    END GET_REPORT_DETAILS;

END GIACR190D_PKG;
/


