CREATE OR REPLACE PACKAGE BODY CPI.GICLS272_PKG
AS
    FUNCTION get_clm_list_per_bill(
        p_payee_no          GIIS_PAYEES.payee_no%TYPE,
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
    )
        RETURN clm_list_per_bill_tab PIPELINED
    IS
        v_list clm_list_per_bill_type;
    BEGIN
        FOR i IN (
                SELECT f.doc_type, i.rv_meaning, f.doc_number, f.amount, f.bill_date,
                        a.item_no, c.item_title, a.peril_cd, b.peril_name, e.le_stat_desc,
                        NVL (d.paid_amt, 0) paid_amt, NVL (d.net_amt, 0) net_amt,
                        NVL (d.advise_amt, 0) advise_amt,
                        a.claim_id, --j.line_cd ||'-'|| j.subline_cd||'-'|| j.iss_cd || '-'|| LTRIM (TO_CHAR (j.issue_yy, '09'))||'-'|| LTRIM (TO_CHAR (j.pol_seq_no, '0999999'))||'-'|| LTRIM (TO_CHAR (j.renew_no, '09')) AS policy_number,
                        get_policy_id(j.line_cd,j.subline_cd,j.pol_iss_cd,j.issue_yy,j.pol_seq_no,j.renew_no) as policy_number, 
                        j.clm_stat_cd, j.assured_name, j.loss_date, j.clm_file_date, 
                        f.payee_class_cd, f.payee_cd -- for checking purposes
                FROM gicl_item_peril a,
                     giis_peril b,
                     gicl_clm_item c,
                     gicl_clm_loss_exp d,
                     gicl_le_stat e,
                     gicl_loss_exp_bill f,
                     giis_payees g,
                     giis_payee_class h,
                     cg_ref_codes i,
                     gicl_claims j
                WHERE a.peril_cd = b.peril_cd
                    AND a.line_cd = b.line_cd
                    AND a.claim_id = j.claim_id
                    AND a.claim_id = c.claim_id
                    AND a.item_no = c.item_no
                    AND a.grouped_item_no = c.grouped_item_no
                    AND a.claim_id = d.claim_id
                    AND a.peril_cd = d.peril_cd
                    AND a.item_no = d.item_no
                    AND a.grouped_item_no = d.grouped_item_no
                    AND d.item_stat_cd = e.le_stat_cd
                    AND d.claim_id = f.claim_id
                    AND d.clm_loss_id = f.claim_loss_id
                    AND g.payee_no = f.payee_cd
                    AND g.payee_class_cd = f.payee_class_cd
                    AND h.payee_class_cd = f.payee_class_cd
                    AND i.rv_domain LIKE 'GICL_LOSS_EXP_BILL.DOC_TYPE'
                    AND i.rv_low_value = f.doc_type
                    AND f.doc_number = p_doc_number
                    AND g.payee_no = NVL(p_payee_no, g.payee_no)
                    AND f.payee_class_cd = NVL(p_payee_class_cd, f.payee_class_cd)
                    AND ((DECODE (p_search_by, 'lossDate', TO_DATE(j.loss_date), 'claimFileDate', TO_DATE(j.clm_file_date)) >= TO_DATE(p_from_date, 'MM-DD-YYYY'))
                    AND (DECODE (p_search_by, 'lossDate', TO_DATE(j.loss_date), 'claimFileDate', TO_DATE(j.clm_file_date)) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                    OR (DECODE (p_search_by, 'lossDate', TO_DATE(j.loss_date), 'claimFileDate', TO_DATE(j.clm_file_date)) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')))
        )
        LOOP
        
            v_list.doc_type         := i.doc_type;       
            v_list.rv_meaning       := i.rv_meaning;    
            v_list.doc_number       := i.doc_number;     
            v_list.amount           := i.amount;     
            v_list.bill_date        := i.bill_date;      
            v_list.item_no          := i.item_no;        
            v_list.item_title       := i.item_title;   
            v_list.peril_cd         := i.peril_cd;      
            v_list.peril_name       := i.peril_name;    
            v_list.le_stat_desc     := i.le_stat_desc;  
            v_list.paid_amt         := i.paid_amt;      
            v_list.net_amt          := i.net_amt;       
            v_list.advise_amt       := i.advise_amt;     
            v_list.claim_no         := GET_CLAIM_NUMBER(i.claim_id);      
            v_list.policy_no        := GET_POLICY_NO(i.policy_number);    
            v_list.clm_stat_desc    := GET_CLM_STAT_DESC(i.clm_stat_cd);  
            v_list.assured_name     := i.assured_name;   
            v_list.loss_date        := i.loss_date;    
            v_list.clm_file_date    := i.clm_file_date; 
            v_list.payee_cd         := i.payee_cd;     
            v_list.payee_class_cd   := i.payee_class_cd;
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
    END get_clm_list_per_bill;
    
    FUNCTION validate_payee(
        p_payee_no    VARCHAR2,
        p_payee_name  VARCHAR2
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
    BEGIN   
        SELECT(SELECT DISTINCT 'X'
                    FROM giis_payees a, gicl_loss_exp_bill b, gicl_claims c, gicl_clm_loss_exp d, giis_payee_class e
                    WHERE a.payee_no = b.payee_cd
                        AND a.payee_class_cd = b.payee_class_cd
                        AND a.payee_class_cd = e.payee_class_cd
                        AND c.claim_id = b.claim_id
                        AND d.claim_id = b.claim_id
                        AND d.clm_loss_id = b.claim_loss_id
                        AND UPPER(a.payee_last_name||decode(a.payee_first_name,NULL,NULL,', '||a.payee_first_name)||decode(a.payee_middle_name,NULL,NULL,' '||substr(a.payee_middle_name,1,1)||'.'))
                            LIKE NVL(UPPER(p_payee_name),UPPER(a.payee_last_name||decode(a.payee_first_name,NULL,NULL,', '||a.payee_first_name)||decode(a.payee_middle_name,NULL,NULL,' '||substr(a.payee_middle_name,1,1)||'.')))
                        AND a.payee_no LIKE NVL(p_payee_no,a.payee_no)  
              )
       INTO v_temp_x
       FROM DUAL;
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;
    END;
    
    FUNCTION validate_payee_class(
        p_payee_class_cd    VARCHAR2,
        p_payee_class       VARCHAR2      
    ) 
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
    BEGIN   
        SELECT( SELECT DISTINCT 'X'
                     FROM giis_payee_class a, gicl_loss_exp_bill b,gicl_claims c
                     WHERE  c.claim_id = b.claim_id    
                     AND b.payee_class_cd = a.payee_class_cd
                     AND a.payee_class_cd LIKE NVL(p_payee_class_cd,a.payee_class_cd)
                     AND UPPER(a.class_desc) LIKE NVL(UPPER(p_payee_class),UPPER(a.class_desc))
              )
       INTO v_temp_x
       FROM DUAL;
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;
    END;
    
    FUNCTION validate_doc_number(
        p_doc_number        VARCHAR2
    ) 
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
    BEGIN   
        SELECT( SELECT DISTINCT 'X'
                    FROM gicl_loss_exp_bill a, cg_ref_codes b
                    --WHERE payee_class_cd = NVL(p_payee_class_cd,payee_class_cd)
                    --AND payee_cd =  NVL(p_payee_cd,payee_cd)
                    WHERE doc_number  LIKE NVL(p_doc_number,doc_number)
                    --AND doc_type    LIKE NVL(p_doc_type,doc_type)
                    --AND UPPER(rv_meaning) LIKE NVL(UPPER(p_rv_meaning),'%')
                    --AND amount    = NVL(p_amount,amount)
                    --AND bill_date = NVL(p_bill_date,bill_date)
                    AND b.rv_low_value = a.doc_type
                    AND b.rv_domain LIKE 'GICL_LOSS_EXP_BILL.DOC_TYPE'
              )
       INTO v_temp_x
       FROM DUAL;
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;
    END;
    
    FUNCTION get_payee_names(
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_payee_cd          GICL_LOSS_EXP_BILL.payee_cd%TYPE,  
        p_payee_name        VARCHAR2    
    )
        
      RETURN payee_names_list_tab PIPELINED
    IS
      v_list   payee_names_list_type;
    BEGIN
        FOR i IN ( SELECT DISTINCT a.payee_no, b.payee_class_cd,
                                    a.payee_last_name||decode(a.payee_first_name,NULL,NULL,', '||a.payee_first_name)||decode(a.payee_middle_name,NULL,NULL,' '||substr(a.payee_middle_name,1,1)||'.') payee_name
                    FROM giis_payees a, gicl_loss_exp_bill b, gicl_claims c, gicl_clm_loss_exp d, giis_payee_class e
                    WHERE a.payee_no = b.payee_cd
                        AND a.payee_class_cd = b.payee_class_cd
                        AND a.payee_class_cd = e.payee_class_cd
                        AND c.claim_id = b.claim_id
                        AND d.claim_id = b.claim_id
                        AND d.clm_loss_id = b.claim_loss_id
                        AND UPPER(a.payee_last_name||decode(a.payee_first_name,NULL,NULL,', '||a.payee_first_name)||decode(a.payee_middle_name,NULL,NULL,' '||substr(a.payee_middle_name,1,1)||'.'))
                            LIKE NVL(UPPER(p_payee_name),UPPER(a.payee_last_name||decode(a.payee_first_name,NULL,NULL,', '||a.payee_first_name)||decode(a.payee_middle_name,NULL,NULL,' '||substr(a.payee_middle_name,1,1)||'.')))
                        AND a.payee_no LIKE NVL(p_payee_cd,a.payee_no)  
                        AND a.payee_class_cd = NVL(p_payee_class_cd, B.payee_class_cd)
                        AND b.doc_number = NVL(p_doc_number, b.doc_number)
                        ORDER BY payee_name)
        LOOP
            v_list.payee_no     := i.payee_no;
            v_list.payee_name   := i.payee_name;
            PIPE ROW (v_list);
        END LOOP;
        RETURN;
    END;
        
    FUNCTION get_payee_class(
        p_payee_cd    GICL_LOSS_EXP_BILL.payee_cd%TYPE,
        p_doc_number  GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_payee_class       GIIS_PAYEE_CLASS.class_desc%TYPE
    )
      RETURN payee_class_list_tab PIPELINED
    IS
      v_list   payee_class_list_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a.payee_class_cd, a.class_desc
                     FROM giis_payee_class a, gicl_loss_exp_bill b,gicl_claims c
                     WHERE     c.claim_id = b.claim_id    
                     AND b.payee_class_cd = a.payee_class_cd
                     AND a.payee_class_cd LIKE NVL(p_payee_class_cd,a.payee_class_cd)
                     AND UPPER(a.class_desc) LIKE NVL(UPPER(p_payee_class),UPPER(a.class_desc))
                     AND b.payee_cd = NVL(p_payee_cd,b.payee_cd)
                     AND b.doc_number = NVL(p_doc_number, b.doc_number)
                     ORDER BY PAYEE_CLASS_CD)
        LOOP
            v_list.payee_class_cd   := i.payee_class_cd;
            v_list.payee_class_name := i.class_desc;
            PIPE ROW (v_list);
        END LOOP;
        RETURN;
    END;
    
    FUNCTION get_doc_number(
        p_payee_cd          GICL_LOSS_EXP_BILL.payee_cd%TYPE,
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_doc_type          GICL_LOSS_EXP_BILL.doc_type%TYPE,
        p_rv_meaning        CG_REF_CODES.rv_meaning%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_amount            GICL_LOSS_EXP_BILL.amount%TYPE,
        p_bill_date         GICL_LOSS_EXP_BILL.bill_date%TYPE     
    )
        RETURN doc_number_list_tab PIPELINED
    IS
      v_list   doc_number_list_type;
    BEGIN
        FOR i IN (select doc_number, doc_type, amount, bill_date, rv_meaning
                    FROM gicl_loss_exp_bill a, cg_ref_codes b
                    WHERE payee_class_cd = NVL(p_payee_class_cd,payee_class_cd)
                    AND payee_cd =  NVL(p_payee_cd,payee_cd)
                    AND doc_number  LIKE NVL(p_doc_number,doc_number)
                    AND doc_type    LIKE NVL(p_doc_type,doc_type)
                    AND UPPER(rv_meaning) LIKE NVL(UPPER(p_rv_meaning),'%')
                    AND amount    = NVL(p_amount,amount)
                    AND NVL(bill_date,sysdate) = NVL(p_bill_date,NVL(bill_date,sysdate))
                    AND b.rv_low_value = a.doc_type
                    AND b.rv_domain LIKE 'GICL_LOSS_EXP_BILL.DOC_TYPE')
        LOOP
            v_list.doc_number   := i.doc_number;
            v_list.doc_type     := i.doc_type;
            v_list.amount       := i.amount;
            v_list.bill_date    := i.bill_date;
            v_list.rv_meaning   := i.rv_meaning;
            
            pipe row(v_list);
        END LOOP;
        RETURN;
    END;
    
     FUNCTION new_get_clm_list_per_bill(
        p_payee_no          VARCHAR2,
        p_payee_class_cd    VARCHAR2,
        p_doc_number        VARCHAR2,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
    )
        RETURN new_clm_list_per_bill_tab PIPELINED
    IS
        v_list new_clm_list_per_bill_type;
    BEGIN
        FOR i IN (
                SELECT item_title, peril_name, le_stat_desc, paid_amt, net_amt, advise_amt,
                       g.line_cd, g.subline_cd, g.iss_cd, g.issue_yy, g.pol_seq_no, g.renew_no,
                       clm_stat_cd, assd_no, G.loss_date, g.clm_file_date, g.claim_id, g.pol_iss_cd
                  FROM gicl_item_peril a,
                       giis_peril b,
                       gicl_clm_item c,
                       gicl_clm_loss_exp d,
                       gicl_le_stat e,
                       gicl_loss_exp_bill f,
                       gicl_claims g
                 WHERE a.peril_cd = b.peril_cd
                   AND a.line_cd = b.line_cd
                   AND a.claim_id = c.claim_id
                   AND a.claim_id = g.claim_id
                   AND a.item_no = c.item_no
                   AND a.grouped_item_no = c.grouped_item_no
                   AND a.claim_id = d.claim_id
                   AND a.peril_cd = d.peril_cd
                   AND a.item_no = d.item_no
                   AND a.grouped_item_no = d.grouped_item_no
                   AND d.item_stat_cd = e.le_stat_cd
                   AND d.claim_id = f.claim_id
                   AND d.clm_loss_id = f.claim_loss_id
                   AND f.payee_cd =           p_payee_no      
                   AND f.payee_class_cd =     p_payee_class_cd
                   AND f.doc_number =         p_doc_number  
                   AND ((DECODE (p_search_by, 'lossDate', TO_DATE(g.loss_date), 'claimFileDate', TO_DATE(g.clm_file_date)) >= TO_DATE(p_from_date, 'MM-DD-YYYY'))
                    AND (DECODE (p_search_by, 'lossDate', TO_DATE(g.loss_date), 'claimFileDate', TO_DATE(g.clm_file_date)) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                    OR (DECODE (p_search_by, 'lossDate', TO_DATE(g.loss_date), 'claimFileDate', TO_DATE(g.clm_file_date)) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')))  
        )
        LOOP
            v_list.policy_no       := get_policy_no(get_policy_id(i.line_cd,i.subline_cd,i.pol_iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no));
            v_list.claim_no        := get_claim_number(i.claim_id);
            v_list.item_title      := i.item_title; 
            v_list.peril_name      := i.peril_name;   
            v_list.le_stat_desc    := i.le_stat_desc; 
            v_list.paid_amt        := i.paid_amt;     
            v_list.net_amt         := i.net_amt;      
            v_list.advise_amt      := i.advise_amt;   
            v_list.clm_stat_cd     := i.clm_stat_cd;  
            v_list.assd_no         := i.assd_no; 
            v_list.assd_name       := get_assd_name(i.assd_no);      
            v_list.loss_date       := i.loss_date;    
            v_list.clm_file_date   := i.clm_file_date;  
            v_list.clm_stat_desc   := GET_CLM_STAT_DESC(i.clm_stat_cd); 
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
    END new_get_clm_list_per_bill;
    
END;
/


