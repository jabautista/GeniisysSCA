CREATE OR REPLACE PACKAGE BODY CPI.GIACR190b_PKG AS
    P_iss_cd varchar2(2);
    P_prem_seq_no number;
    P_policy_no varchar2(50);
    P_intm_no number;
    P_inst_no number;
    
    function CF_Incept_dateFormula(
        P_iss_cd        gipi_invoice.iss_cd%TYPE,
        P_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
    ) return Date is
        Temp2 gipi_polbasic.incept_date%type;
        v_inceptdate DATE;
    begin
      FOR rec IN (SELECT b.incept_date
                    FROM gipi_invoice a,
                         gipi_polbasic b
                   WHERE a.policy_id = b.policy_id
                     AND a.iss_cd = P_iss_cd
                     and a.prem_seq_no = P_prem_seq_no)
      LOOP              
        v_inceptdate := rec.incept_date;
      END LOOP;   
        RETURN (v_inceptdate);
    end;

    FUNCTION cf_expiry_dateformula(
        P_iss_cd        gipi_invoice.iss_cd%TYPE,
        P_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
    ) RETURN DATE
    IS
       temp2      gipi_polbasic.expiry_date%TYPE;
       v_expiry   DATE;
    BEGIN
       FOR rec IN (SELECT b.expiry_date
                     FROM gipi_invoice a, gipi_polbasic b
                    WHERE a.policy_id = b.policy_id
                      AND a.iss_cd = P_iss_cd
                      AND a.prem_seq_no = P_prem_seq_no)
       LOOP
          v_expiry := rec.expiry_date;
       END LOOP;

       RETURN (v_expiry);
    END;

    FUNCTION cf_policy_noformula(
        p_policy_no VARCHAR2
    )  RETURN CHAR
    IS
        policy_no number;
       v_pol_no   VARCHAR2 (50);
    BEGIN
       FOR rec IN (SELECT SUBSTR (P_policy_no,
                                  1,
                                  INSTR (P_policy_no, '-', 1, 5) + 1
                                 ) pol_no
                     FROM DUAL)
       LOOP
          v_pol_no := rec.pol_no;
       END LOOP;

       RETURN (v_pol_no);
    END;

    FUNCTION cf_cutoffdateformula(
        p_user_id   giac_soa_rep_ext.user_id%TYPE,
        p_intm_no   giac_soa_rep_ext.intm_no%TYPE
    ) RETURN DATE
    IS
       
       cut_date_v   DATE;
    BEGIN
       FOR rec IN (SELECT DISTINCT param_date
                              FROM giac_soa_rep_ext
                             WHERE user_id = p_USER_id AND intm_no = p_intm_no)
       LOOP
          IF rec.param_date IS NOT NULL
          THEN
             cut_date_v := rec.param_date;
             
          ELSE
             cut_date_v := LAST_DAY (SYSDATE);
             
          END IF;
       END LOOP;

       RETURN (cut_date_v);
    END;
    
    FUNCTION cf_invoice#formula(
        P_intm_no       giac_soa_rep_ext.intm_no%TYPE,
        P_iss_cd        giac_soa_rep_ext.iss_cd%TYPE,
        P_prem_seq_no   giac_soa_rep_ext.prem_seq_no%TYPE,
        P_inst_no       giac_soa_rep_ext.INST_NO%type
    ) RETURN CHAR
    IS
       v_invoice#   VARCHAR2 (40);
    BEGIN
       FOR rec IN (SELECT P_iss_cd || P_prem_seq_no || '-' || P_inst_no invoice#
                     FROM giac_soa_rep_ext
                    WHERE intm_no = P_intm_no
                      AND iss_cd = P_iss_cd
                      AND prem_seq_no = P_prem_seq_no)
       --AND user_id=user)
       /*AND aging_id=(SELECT MAX(aging_id)
                      FROM giac_soa_rep_ext
                     WHERE assd_no=:assd_no
                         AND iss_cd=:iss_cd
                       AND prem_seq_no=:prem_seq_no ))*/
       LOOP
          v_invoice# := rec.invoice#;
       END LOOP;

       RETURN (v_invoice#);
    END;
    
    FUNCTION cf_propertyformula(
        P_iss_cd        giac_soa_rep_ext.iss_cd%TYPE,
        P_prem_seq_no   giac_soa_rep_ext.prem_seq_no%TYPE
    )RETURN CHAR
    IS
       v_property   gipi_invoice.property%TYPE;
    BEGIN
       FOR rec IN (SELECT property
                     FROM gipi_invoice
                    WHERE iss_cd = P_iss_cd 
                      AND prem_seq_no = P_prem_seq_no)
       LOOP
          v_property := rec.property;
       END LOOP;

       RETURN (v_property);
    END;

    FUNCTION cf_signatoryformula(
        p_policy_no     VARCHAR2
    )
       RETURN CHAR
    IS
       temp4a        giac_documents.report_no%TYPE;
       temp4b        giac_documents.report_id%TYPE;
       temp4c        giac_rep_signatory.label%TYPE;
       temp4d        giis_signatory_names.signatory%TYPE;
       policy_no     NUMBER;
       v_signatory   VARCHAR (100);
    BEGIN
       FOR rec IN (SELECT c.signatory, b.label
                     FROM giac_documents a,
                          giac_rep_signatory b,
                          giis_signatory_names c
                    WHERE a.report_no = b.report_no
                      AND UPPER(a.report_id) = 'GIACR190C'
                      AND NVL (a.line_cd, SUBSTR (P_policy_no, 1, 2)) =
                                                         SUBSTR (P_policy_no, 1, 2)
                      AND b.signatory_id = c.signatory_id
                   MINUS
                   SELECT c.signatory, b.label
                     FROM giac_documents a,
                          giac_rep_signatory b,
                          giis_signatory_names c
                    WHERE a.report_no = b.report_no
                      AND UPPER(a.report_id) = 'GIACR190C'
                      AND a.line_cd IS NULL
                      AND EXISTS (
                             SELECT 1
                               FROM giac_documents
                              WHERE UPPER(report_id) = 'GIACR190C'
                                AND line_cd = SUBSTR (P_policy_no, 1, 2))
                      AND b.signatory_id = c.signatory_id)
       LOOP
          v_signatory := rec.signatory;
       END LOOP;

       RETURN (v_signatory);
    END;

    FUNCTION cf_designationformula(
        p_policy_no     VARCHAR2
    )
       RETURN CHAR
    IS
       temp4a          giac_documents.report_no%TYPE;
       temp4b          giac_documents.report_id%TYPE;
       temp4c          giac_rep_signatory.label%TYPE;
       temp4d          giis_signatory_names.signatory%TYPE;
       policy_no        NUMBER;
       v_designation   VARCHAR (100);
    BEGIN
       FOR rec IN (SELECT c.designation, b.label
                     FROM giac_documents a,
                          giac_rep_signatory b,
                          giis_signatory_names c
                    WHERE a.report_no = b.report_no
                      AND a.report_id = 'GIACR190c'
                      AND NVL (a.line_cd, SUBSTR (P_policy_no, 1, 2)) =
                                                         SUBSTR (P_policy_no, 1, 2)
                      AND b.signatory_id = c.signatory_id
                   MINUS
                   SELECT c.designation, b.label
                     FROM giac_documents a,
                          giac_rep_signatory b,
                          giis_signatory_names c
                    WHERE a.report_no = b.report_no
                      AND UPPER(a.report_id) = 'GIACR190C'
                      AND a.line_cd IS NULL
                      AND EXISTS (
                             SELECT 1
                               FROM giac_documents
                              WHERE UPPER(report_id) = 'GIACR190C'
                                AND line_cd = SUBSTR (P_policy_no, 1, 2))
                      AND b.signatory_id = c.signatory_id)
       LOOP
          v_designation := rec.designation;
       END LOOP;

       RETURN (v_designation);
    END;
    FUNCTION cf_intm_noformula(
        P_intm_no   giac_soa_rep_ext.intm_no%TYPE,
        P_policy_no giac_soa_rep_ext.policy_no%TYPE
    )
       RETURN NUMBER
    IS
       v_intm_no   NUMBER (20);
    BEGIN
       FOR rec IN (SELECT intm_no
                     FROM giac_soa_rep_ext
                    WHERE intm_no = P_intm_no 
                      AND policy_no = P_policy_no)
       LOOP
          v_intm_no := rec.intm_no;
       END LOOP;

       RETURN (v_intm_no);
    END;
    FUNCTION cf_userformula
       RETURN CHAR
    IS
       v_user   VARCHAR2 (50);
    BEGIN
       SELECT USER
         INTO v_user
         FROM DUAL;

       RETURN (v_user);
    END;

    FUNCTION cf_intm_nameformula(
        P_intm_no   giac_soa_rep_ext.intm_no%TYPE,
        P_policy_no giac_soa_rep_ext.policy_no%TYPE
    )
       RETURN CHAR
    IS
       v_intm_name   VARCHAR2 (100);
    BEGIN
       FOR rec IN (SELECT intm_name
                     FROM giac_soa_rep_ext
                    WHERE intm_no = P_intm_no 
                      AND policy_no = P_policy_no)
       LOOP
          v_intm_name := rec.intm_name;
       END LOOP;

       RETURN (v_intm_name);
    END;

    FUNCTION cf_intm_addressformula(
        P_intm_no   giac_soa_rep_ext.intm_no%TYPE
    )
       RETURN CHAR
    IS
       v_intm_address   VARCHAR2 (100);
    BEGIN
       FOR rec IN (SELECT DECODE (bill_addr1, '.', NULL, bill_addr1) address
                     FROM giis_intermediary
                    WHERE intm_no = P_intm_no)
       LOOP
          v_intm_address := rec.address;
       END LOOP;

       RETURN (INITCAP (v_intm_address));
    END;

    FUNCTION cf_intm_address2formula(
        P_intm_no   giac_soa_rep_ext.intm_no%TYPE
    )
       RETURN CHAR
    IS
       v_intm_address2   VARCHAR2 (100);
    BEGIN
       FOR rec IN (SELECT DECODE (bill_addr2, '.', NULL, bill_addr2) address
                     FROM giis_intermediary
                    WHERE intm_no = P_intm_no)
       LOOP
          v_intm_address2 := rec.address;
       END LOOP;

       RETURN (INITCAP (v_intm_address2));
    END;

    FUNCTION cf_intm_address3formula(
        P_intm_no   giac_soa_rep_ext.intm_no%TYPE
    )
       RETURN CHAR
    IS
       v_intm_address3   VARCHAR2 (100);
    BEGIN
       FOR rec IN (SELECT DECODE (bill_addr3, '.', NULL, bill_addr3) address
                     FROM giis_intermediary
                    WHERE intm_no = P_intm_no)
       LOOP
          v_intm_address3 := rec.address;
       END LOOP;

       RETURN (INITCAP (v_intm_address3));
    END;
    
   FUNCTION populate_giacr190b1(
        p_intm_no       giac_soa_rep_ext.intm_no%TYPE,
        p_aging_id      giac_soa_rep_ext.aging_id%TYPE,
        p_user_id       giac_soa_rep_ext.user_id%TYPE,
        p_selected_aging_id VARCHAR2
   )
      RETURN giacr190b1_tab PIPELINED 
    AS
      v_rec giacr190b1_type;
      intm_name VARCHAR2 (100);
      intm_no NUMBER;
      policy VARCHAR2 (50);
      policy_no VARCHAR2 (50);
      endt_no VARCHAR2 (20);
      iss_cd VARCHAR2 (2);
      prem_seq_no NUMBER;
      prem_bal_due NUMBER;
      tax_bal_due NUMBER;
      balance_amt_due NUMBER;
      inst_no NUMBER;
      
      v_selected_aging_id VARCHAR2(4000);
      v_aging_id          VARCHAR2(5);
    BEGIN
    
        v_selected_aging_id := p_selected_aging_id;
        
        FOR g IN (SELECT DISTINCT aging_id
                    FROM giac_soa_rep_ext
                   WHERE user_id = p_user_id)
        LOOP
            v_aging_id := '#' || g.aging_id || '#';
            
            IF INSTR(v_selected_aging_id, v_aging_id) != 0 THEN
            
                FOR rec IN (select intm_no,  
                                  policy_no policy, 
                                  (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                  (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                  iss_cd,
                                  prem_seq_no, 
                                  prem_bal_due,
                                  tax_bal_due,
                                  balance_amt_due,
                                  inst_no
                             from giac_soa_rep_ext
                            where intm_no = p_intm_no   	                  
                              and aging_id = REPLACE(v_aging_id, '#')  --p_aging_id
                              and user_id = p_user_id
                /*select rpad(' ',100) intm_name,
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
                                from dual*/        
                )
                LOOP
                      v_rec.incept_date := to_char(cf_incept_dateformula(rec.iss_cd, rec.prem_seq_no), 'mm-dd-yyyy');
                      v_rec.expiry_date := to_char(cf_expiry_dateformula(rec.iss_cd, rec.prem_seq_no), 'mm-dd-yyyy');
                      v_rec.policy_no := cf_policy_noformula(rec.policy_no);
                      v_rec.v_date := cf_cutoffdateformula(p_user_id, rec.intm_no);
                      v_rec.v_invoice := cf_invoice#formula(rec.intm_no, rec.iss_cd, rec.prem_seq_no, REC.INST_NO);
                      v_rec.v_property1 := cf_propertyformula(rec.iss_cd, rec.prem_seq_no);
                      v_rec.v_signatory1 := cf_signatoryformula(rec.policy_no);
                      v_rec.v_designation1 := cf_designationformula(rec.policy_no);
                      v_rec.v_intm_no1 := cf_intm_noformula(rec.intm_no, rec.policy_no);
                      v_rec.v_user1 := p_user_id; --cf_userformula;
                      v_rec.v_intm_name1 := cf_intm_nameformula(rec.intm_no, rec.policy_no);
                      v_rec.v_intm_address1 := cf_intm_addressformula(rec.intm_no);
                      v_rec.v_intm_address2 := cf_intm_address2formula(rec.intm_no);
                      v_rec.v_intm_address3 :=  cf_intm_address3formula(rec.intm_no);
                      v_rec.v_intermediary_name := intm_name;
                      v_rec.v_intermediary_no := REC.intm_no;
                      v_rec.v_policy := REC.policy;
                      v_rec.v_policy_no := REC.policy_no;
                      v_rec.v_endt_no := REC.endt_no;
                      v_rec.v_iss_cd := REC.iss_cd;
                      v_rec.v_prem_seq_no := REC.prem_seq_no;
                      v_rec.v_prem_bal_due := REC.prem_bal_due;
                      v_rec.v_tax_bal_due := REC.tax_bal_due;
                      v_rec.v_balance_amt_due := REC.balance_amt_due;
                      v_rec.v_inst_no := REC.inst_no;
                      PIPE ROW(v_rec);
                    --RETURN;                
                END LOOP;
        
            END IF;
        END LOOP;
        
        
        
    

    END populate_giacr190b1;
END GIACR190b_PKG;
/


