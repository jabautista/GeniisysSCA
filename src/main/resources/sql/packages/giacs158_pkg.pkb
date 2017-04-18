CREATE OR REPLACE PACKAGE BODY CPI.GIACS158_PKG
AS
   /*
   **  Modified by  :  Maria Gzelle Ison
   **  Date Created : 10.24.2013
   **  Reference By : GIACS158
   **  Remarks      : Commissions Due
   */
   
    FUNCTION get_intm_type_lov
        RETURN intm_type_tab PIPELINED
    IS
        v_list  intm_type_type;
    BEGIN
        FOR i IN(SELECT intm_type, intm_desc 
                   FROM giis_intm_type)
        LOOP
            v_list.intm_type := i.intm_type;
            v_list.intm_desc := i.intm_desc;
            PIPE ROW(v_list);
        END LOOP;
    END get_intm_type_lov;
    
    FUNCTION get_intm_lov(
        p_intm_type  giis_intermediary.intm_type%TYPE
    )
        RETURN intm_tab PIPELINED
    IS
        v_list  intm_type;
    BEGIN
        FOR i IN(SELECT intm_no, intm_name
                   FROM giis_intermediary
                  WHERE parent_intm_no IS NULL
                    AND intm_type LIKE DECODE(p_intm_type,NULL,'%',p_intm_type)
                    AND 1 = (SELECT 1
                               FROM giis_payees
                              WHERE payee_no = intm_no
                                AND payee_class_cd = giacp.v('INTM_CLASS_CD')
                                AND bank_acct_no IS NOT NULL)
                 UNION
                 SELECT a.intm_no, a.intm_name
                   FROM giis_intermediary a, giis_intermediary b
                  WHERE a.parent_intm_no = b.intm_no
                    AND b.intm_type = giisp.v('BANC_INTM_TYPE')
                    AND 1 = DECODE(NVL(p_intm_type,giisp.v('BANC_INTM_TYPE')),giisp.v('BANC_INTM_TYPE'),1,0)
                    AND 1 = (SELECT 1
                               FROM giis_payees
                              WHERE payee_no = a.intm_no
                                AND payee_class_cd = giacp.v('INTM_CLASS_CD')
                                AND bank_acct_no IS NOT NULL))
        LOOP
            v_list.intm_no   := i.intm_no;
            v_list.intm_name := i.intm_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_intm_lov;

    FUNCTION get_bank_files
        RETURN bank_files_tab PIPELINED
    IS
        v_list  bank_files_type;
    BEGIN
        FOR i IN(SELECT bank_file_no, bank_file_name, extract_date, DECODE(paid_sw,'Y','I','N','N','I','I') paid_sw
                   FROM giac_bank_comm_payt_hdr_ext
               ORDER BY bank_file_no)
        LOOP
            v_list.bank_file_no   := i.bank_file_no;
            v_list.bank_file_name := i.bank_file_name;
            v_list.extract_date   := TO_CHAR(i.extract_date, 'MM/DD/YYYY HH:MM:SS PM');
            v_list.paid_sw        := i.paid_sw;
            PIPE ROW(v_list);
        END LOOP;
    END get_bank_files;    

    FUNCTION check_view_records(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE
    )
        RETURN VARCHAR2
    IS
        v_message VARCHAR2(280);
        v_bank    VARCHAR2(280);
    BEGIN 
        FOR i IN(SELECT bank_file_no
                   FROM giac_bank_comm_payt_hdr_ext
                  WHERE TRUNC(as_of_date_param) = TO_DATE(p_as_of_date,'MM-DD-YYYY')
                    AND NVL(intm_type_param,'XX') = NVL(p_intm_type,'XX')
                    AND NVL(intm_no_param,-1) = NVL(p_intm,-1)
                    AND paid_sw = 'N'
                    AND ROWNUM = 1)
         LOOP
            v_bank := i.bank_file_no;
         END LOOP;
         
         IF v_bank IS NOT NULL THEN
            v_message := 'A file was already  extracted with this date, intermediary type and intermediary. '||
                         'Do you want to continue? Choosing "Yes" will INVALIDATE bank file '||v_bank||'.';
         END IF;        
    RETURN v_message; 
    END check_view_records;
    
    PROCEDURE invalidate_bank_file(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE
    )
    IS
    BEGIN
        UPDATE giac_bank_comm_payt_hdr_ext
           SET paid_sw = 'I'
         WHERE TRUNC(as_of_date_param) = TO_DATE(p_as_of_date,'MM-DD-YYYY')
           AND NVL(intm_type_param,'XX') = NVL(p_intm_type,'XX')
           AND NVL(intm_no_param,-1) = NVL(p_intm,-1);
    END invalidate_bank_file;   

    PROCEDURE delete_temp_ext
    IS
    BEGIN
        DELETE FROM giac_bank_comm_payt_temp_ext;
    END delete_temp_ext; 
    
    PROCEDURE insert_into_temp_table(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE
    )
    IS
        v_bank_ref_no  giac_bank_comm_payt_dtl_ext.bank_ref_no%TYPE;
    BEGIN
    -- select with bancassurance
        FOR b IN (SELECT gppcdv.policy_id,gppcdv.iss_cd, gppcdv.prem_seq_no,get_intm_type(gppcdv.intm_no) intm_type,
                         gppcdv.intm_no, gppcdv.parent_intm_no,
                         ROUND(inv_prem_amt,2) gross_premium,
                         ROUND(prem_amt,2) premium_paid,
                         ROUND(gppcdv.comm_amt - gppcdv.comm_paid,2) commission_due,
                         ROUND(gppcdv.wtax_amt - gppcdv.wtax_paid,2) wholding_tax_due,
                         ROUND(gppcdv.input_vat - gppcdv.input_vat_paid, 2) input_vat_due,
                         ROUND(gppcdv.comm_amt, 2) inv_comm_amt,
                         ROUND(gppcdv.wtax_amt, 2) inv_whtax_amt,
                         ROUND(gppcdv.input_vat, 2) inv_input_vat,
                         ROUND(gppcdv.net_comm_paid,2) net_comm_paid
                    FROM giac_comm_voucher_v gppcdv 
                   WHERE 1 = 1 
                     AND DECODE(ABS(inv_prem_amt - prem_amt), .01, 0, (inv_prem_amt - prem_amt)) = 0
                     AND (comm_amt - wtax_amt + input_vat) - net_comm_paid NOT BETWEEN -.01 AND 0
                     AND TRUNC(gppcdv.payment_date) <= TO_DATE(p_as_of_date,'MM-DD-YYYY')
                     AND get_intm_type(parent_intm_no) = (SELECT NVL(giisp.v('BANC_INTM_TYPE'),NVL(p_intm_type, get_intm_type(gppcdv.parent_intm_no)))
                                                            FROM giis_intermediary a, giis_intermediary b
                                                           WHERE a.parent_intm_no = b.intm_no
                                                             AND b.intm_type = giisp.v('BANC_INTM_TYPE')
                                                             AND a.intm_no = gppcdv.intm_no
                                                             AND 1 = (SELECT 1
                                                                        FROM giis_payees
                                                                       WHERE payee_no = a.intm_no
                                                                         AND payee_class_cd = giacp.v('INTM_CLASS_CD')
                                                                         AND bank_acct_no IS NOT NULL
                                                                         AND NVL(bank_acct_app_tag,'N') = 'Y'))
                     AND (gppcdv.parent_intm_no  = NVL(p_intm,gppcdv.parent_intm_no)
                      OR gppcdv.intm_no = (SELECT a.intm_no
                                             FROM giis_intermediary a, giis_intermediary b
                                            WHERE a.parent_intm_no = b.intm_no
                                              AND b.intm_type = giisp.v('BANC_INTM_TYPE')
                                              AND a.intm_no = gppcdv.intm_no
                                              AND 1 = (SELECT 1
                                                         FROM giis_payees
                                                        WHERE payee_no = a.intm_no
                                                          AND payee_class_cd = giacp.v('INTM_CLASS_CD')
                                                          AND bank_acct_no IS NOT NULL
                                                          AND NVL(bank_acct_app_tag,'N') = 'Y')))          
                                              AND 1 = (SELECT 1
                                                         FROM giis_intermediary a, giis_payees b
                                                        WHERE a.intm_no = b.payee_no
                                                          AND b.payee_class_cd = giacp.v('INTM_CLASS_CD')
                                                          AND b.bank_acct_no IS NOT NULL
                                                          AND a.intm_no = gppcdv.intm_no
                                                          AND NVL(bank_acct_app_tag,'N') = 'Y')
                ORDER BY 1, 9, 5, 6, 7)
            LOOP               
            -- get value for bank_ref_no
                FOR a IN (SELECT bank_ref_no
                            FROM gipi_polbasic
                           WHERE policy_id = b.policy_id)
                LOOP
                    v_bank_ref_no := a.bank_ref_no;
                    EXIT;
                END LOOP;
            
                INSERT INTO giac_bank_comm_payt_temp_ext
                            (policy_id, policy_no, bank_ref_no, iss_cd, prem_seq_no, intm_type, parent_intm_no, parent_intm_name, child_intm_no, child_intm_name,
                             gross_premium, premium_paid, commission_due, wholding_tax_due, input_vat_due, commission_amt, wholding_tax, input_vat, net_comm_paid
                            )
                     VALUES (b.policy_id, get_policy_no (b.policy_id), v_bank_ref_no, b.iss_cd, b.prem_seq_no, b.intm_type, b.parent_intm_no, get_intm_name (b.parent_intm_no), b.intm_no, get_intm_name (b.intm_no),
                             b.gross_premium, b.premium_paid, b.commission_due, b.wholding_tax_due, b.input_vat_due, b.inv_comm_amt, b.inv_whtax_amt, b.inv_input_vat, b.net_comm_paid
                            );
            END LOOP;
            
            -- select disrgarding bancassurance
            FOR b IN (SELECT gppcdv.policy_id, gppcdv.iss_cd, gppcdv.prem_seq_no, get_intm_type(intm_no) intm_type, 
                             gppcdv.intm_no, gppcdv.parent_intm_no, inv_prem_amt gross_premium, prem_amt premium_paid, 
                             ROUND(gppcdv.comm_amt - gppcdv.comm_paid,2) commission_due,
                             ROUND(gppcdv.wtax_amt - gppcdv.wtax_paid,2) wholding_tax_due,
                             ROUND(gppcdv.input_vat - gppcdv.input_vat_paid, 2) input_vat_due,
                             ROUND(gppcdv.comm_amt, 2) inv_comm_amt,
                             ROUND(gppcdv.wtax_amt, 2) inv_whtax_amt,
                             ROUND(gppcdv.input_vat, 2) inv_input_vat,
                             ROUND(gppcdv.net_comm_paid,2) net_comm_paid
                        FROM giac_comm_voucher_v gppcdv
                       WHERE 1 = 1
                         AND DECODE(ABS(inv_prem_amt - prem_amt), .01, 0, (inv_prem_amt - prem_amt)) = 0 
                         AND (comm_amt - wtax_amt + input_vat) - net_comm_paid NOT BETWEEN -.01 AND 0
                         AND TRUNC(gppcdv.payment_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')
                         AND get_intm_type(parent_intm_no) = NVL(p_intm_type, get_intm_type(parent_intm_no))
                         AND gppcdv.parent_intm_no = NVL(p_intm, gppcdv.parent_intm_no)
                         AND 1 = (SELECT 1
                                    FROM giis_intermediary a, giis_payees b
                                   WHERE a.intm_no = b.payee_no
                                     AND b.payee_class_cd = giacp.v( 'INTM_CLASS_CD')
                                     AND b.bank_acct_no IS NOT NULL
                                     AND a.intm_no = gppcdv.parent_intm_no
                                     AND NVL(bank_acct_app_tag,'N') = 'Y')
                            ORDER BY 1, 9, 5, 6, 7)
            LOOP 
            -- get value for bank_ref_no
                FOR a IN (SELECT bank_ref_no
                            FROM gipi_polbasic
                           WHERE policy_id = b.policy_id)
                LOOP
                    v_bank_ref_no := a.bank_ref_no;
                    EXIT;
                END LOOP;
                
                INSERT INTO giac_bank_comm_payt_temp_ext
                            (policy_id, policy_no, bank_ref_no, iss_cd, prem_seq_no, intm_type, parent_intm_no, parent_intm_name, child_intm_no, child_intm_name,
                             gross_premium, premium_paid, commission_due, wholding_tax_due, input_vat_due, commission_amt, wholding_tax, input_vat, net_comm_paid
                            )
                     VALUES (b.policy_id, get_policy_no (b.policy_id), v_bank_ref_no, b.iss_cd, b.prem_seq_no, b.intm_type, b.parent_intm_no, get_intm_name (b.parent_intm_no), b.intm_no, get_intm_name (b.intm_no),
                             b.gross_premium, b.premium_paid, b.commission_due, b.wholding_tax_due, b.input_vat_due, b.inv_comm_amt, b.inv_whtax_amt, b.inv_input_vat, b.net_comm_paid
                            );
            END LOOP;
    END insert_into_temp_table;    

    FUNCTION get_records
        RETURN records_tab PIPELINED
    IS
        v_list  records_type;
    BEGIN
        FOR i IN(SELECT DECODE (get_intm_type (parent_intm_no), giisp.v ('BANC_INTM_TYPE'), intm_type, get_intm_type (parent_intm_no)) parent_intm_type,
                        DECODE (get_intm_type (parent_intm_no), giisp.v ('BANC_INTM_TYPE'), child_intm_no, parent_intm_no) parent_intm_no,
                        SUM ((commission_amt - wholding_tax + input_vat) - net_comm_paid) net_comm_due
                   FROM giac_bank_comm_payt_temp_ext
               GROUP BY DECODE (get_intm_type (parent_intm_no), giisp.v ('BANC_INTM_TYPE'), intm_type, get_intm_type (parent_intm_no)),
                        DECODE (get_intm_type (parent_intm_no), giisp.v ('BANC_INTM_TYPE'), child_intm_no, parent_intm_no)
                 HAVING (SUM (commission_due) - SUM (wholding_tax_due) + SUM (input_vat_due)) > 0
               ORDER BY parent_intm_type, get_intm_name(parent_intm_no))
        LOOP
            BEGIN
                SELECT intm_name
                  INTO v_list.parent_intm_name
                  FROM giis_intermediary
                 WHERE intm_no = i.parent_intm_no;
            END;
            v_list.parent_intm_no   := i.parent_intm_no;
            v_list.parent_intm_type := i.parent_intm_type;
            v_list.net_comm_due     := i.net_comm_due;
            PIPE ROW(v_list);
        END LOOP;
    END get_records; 

    FUNCTION get_records_via_bank_file(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    )
        RETURN records_tab PIPELINED
    IS
        v_list  records_type;
    BEGIN
        FOR i IN(SELECT b.intm_type parent_intm_type, a.parent_intm_no, SUM (a.commission_due - a.wholding_tax_due + a.input_vat_due) net_comm_due
                   FROM giac_bank_comm_payt_dtl_ext a, giis_intermediary b
                  WHERE a.parent_intm_no = b.intm_no 
                    AND a.bank_file_no = p_bank_file_no 
                    AND b.intm_type <> giisp.v ('BANC_INTM_TYPE')
               GROUP BY b.intm_type, a.parent_intm_no
                 UNION
                 SELECT b.intm_type parent_intm_type, a.child_intm_no, SUM (a.commission_due - a.wholding_tax_due + a.input_vat_due) net_comm_due
                   FROM giac_bank_comm_payt_dtl_ext a, giis_intermediary b
                  WHERE a.child_intm_no = b.intm_no 
                    AND a.bank_file_no = p_bank_file_no 
                    AND EXISTS (SELECT intm_no
                                  FROM giis_intermediary
                                 WHERE intm_type = giisp.v ('BANC_INTM_TYPE') 
                                   AND intm_no = a.parent_intm_no)
               GROUP BY b.intm_type, a.child_intm_no)
        LOOP
            BEGIN
                SELECT intm_name
                  INTO v_list.parent_intm_name
                  FROM giis_intermediary
                 WHERE intm_no = i.parent_intm_no;
            END;
            v_list.parent_intm_no   := i.parent_intm_no;
            v_list.parent_intm_type := i.parent_intm_type;
            v_list.net_comm_due     := i.net_comm_due;
            PIPE ROW(v_list);
        END LOOP;
    END get_records_via_bank_file;   

    FUNCTION view_details_via_records(
        p_as_of_date        VARCHAR2,
        p_parent_intm_type  giac_paid_prem_comm_due_v.parent_intm_type%TYPE,
        p_parent_intm_no    giac_paid_prem_comm_due_v.parent_intm_no%TYPE
    )
        RETURN details_tab PIPELINED
    IS
    	v_ref_no VARCHAR2(1000) := NULL;
        v_list   details_type;
    BEGIN
        For i IN(SELECT policy_id, line_cd, assd_no, iss_cd, prem_seq_no,
                        intm_no, peril_cd, sum(gross_premium) gross_premium,
                        sum(premium_paid) premium_paid, sum(commission_due) commission_due,
                        sum(wholding_tax_due) wholding_tax_due, sum(input_vat_due) input_vat_due,
                        sum(net_comm_due) net_comm_due, commission_rt
                   FROM giac_paid_prem_comm_due_v ab
	              WHERE DECODE(ABS(premium_os),.01,0,premium_os) = 0
	                AND net_comm_due <> 0
                    AND TRUNC(payment_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')
                    AND parent_intm_type = DECODE(intm_no, NULL, parent_intm_type,NVL(giisp.v('BANC_INTM_TYPE'),p_parent_intm_type)) 
                    AND (parent_intm_no = p_parent_intm_no
                     OR parent_intm_no = DECODE(intm_no, NULL, p_parent_intm_no, parent_intm_no)
                     OR intm_no IN (SELECT a.intm_no
                                       FROM giis_intermediary a, giis_intermediary b
                                      WHERE a.parent_intm_no = b.intm_no
                                        AND b.intm_type = giisp.v('BANC_INTM_TYPE')
                                        AND a.intm_no = p_parent_intm_no
                                        AND 1 = (SELECT 1
                                                   FROM giis_payees
                                                  WHERE payee_no = a.intm_no
                                                    AND payee_class_cd = giacp.v('INTM_CLASS_CD')
                                                    AND bank_acct_no IS NOT NULL)))
                    AND 1 = (SELECT 1
		  	                   FROM giis_intermediary a, giis_payees b
    	                      WHERE a.intm_no = b.payee_no
                                AND b.payee_class_cd = giacp.v('INTM_CLASS_CD')
      	                        AND b.bank_acct_no IS NOT NULL
                                AND a.intm_no = ab.intm_no)
        	   GROUP BY policy_id, line_cd, assd_no, iss_cd, prem_seq_no,intm_no, peril_cd, commission_rt)
        LOOP
            v_list.bill_no := i.iss_cd||'-'||TO_CHAR(i.prem_seq_no);
            v_list.gross_premium := i.gross_premium;
            v_list.premium_paid := i.premium_paid;
            BEGIN
                SELECT peril_sname
                  INTO v_list.peril
                  FROM giis_peril
                 WHERE peril_cd = i.peril_cd
                   AND line_cd  = i.line_cd; 
            END;
            v_list.commission_rt := i.commission_rt;
            v_list.commission_due := i.commission_due;
            v_list.wholding_tax_due := i.wholding_tax_due;
            v_list.input_vat_due := i.input_vat_due;
            v_list.net_comm_due := i.net_comm_due;
            v_list.policy_no := get_policy_no(i.policy_id);
            v_list.assured := get_assd_name(i.assd_no);
            BEGIN
                SELECT bank_ref_no
                  INTO v_list.bank_ref_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            END;
            v_list.intm_no := i.intm_no;
            BEGIN
                SELECT intm_name
                  INTO v_list.intm_name
                  FROM giis_intermediary    
                 WHERE intm_no = i.intm_no;
            END;
            
            FOR k IN(SELECT gacc_tran_id
                       FROM giac_direct_prem_collns
                      WHERE b140_iss_cd = i.iss_cd
                        AND b140_prem_seq_no = i.prem_seq_no)
            LOOP
                v_ref_no := v_ref_no || get_ref_no(k.gacc_tran_id) || ',';
            END LOOP;
            
            IF v_ref_no IS NOT NULL THEN
  	            SELECT SUBSTR(v_ref_no,1,LENGTH(v_ref_no)-1)
                  INTO v_list.or_no
                  FROM DUAL;
            END IF;
            PIPE ROW(v_list);
        END LOOP;       
    END view_details_via_records;          

    FUNCTION view_details_via_bank_files(
        p_bank_file_no      giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE,
        p_parent_intm_type  giac_paid_prem_comm_due_v.parent_intm_type%TYPE,
        p_parent_intm_no    giac_paid_prem_comm_due_v.parent_intm_no%TYPE
    )
        RETURN details_tab PIPELINED
    IS
    	v_ref_no CLOB /*VARCHAR2(1000)*/ := NULL;	-- AFP SR-18481 : shan 05.21.2015
        v_list   details_type;
    BEGIN
        For i IN(SELECT a.policy_id, /*a.line_cd, a.assd_no,*/ a.iss_cd, a.prem_seq_no,
                        a.child_intm_no intm_no, /*a.peril_cd,*/ sum(a.gross_premium) gross_premium,
                        sum(a.premium_paid) premium_paid, sum(a.commission_due) commission_due,
                        sum(a.wholding_tax_due) wholding_tax_due, sum(a.input_vat_due) input_vat_due,
                        sum(a.commission_due - a.wholding_tax_due + a.input_vat_due) net_comm_due/*, a.commission_rt*/
                   FROM giac_bank_comm_payt_dtl_ext a, giis_intermediary b
                  WHERE a.parent_intm_no = b.intm_no
                    AND a.bank_file_no   = p_bank_file_no
                    AND a.parent_intm_no = p_parent_intm_no
                    AND b.intm_type    = p_parent_intm_type 
               GROUP BY a.policy_id, /*a.line_cd, a.assd_no,*/ a.iss_cd, a.prem_seq_no,
                        a.child_intm_no/*, a.peril_cd, a.commission_rt*/)
        LOOP
            v_list.bill_no := i.iss_cd||'-'||TO_CHAR(i.prem_seq_no);
            v_list.gross_premium := i.gross_premium;
            v_list.premium_paid := i.premium_paid;
--            BEGIN
--                SELECT peril_sname
--                  INTO v_list.peril
--                  FROM giis_peril
--                 WHERE peril_cd = i.peril_cd
--                   AND line_cd  = i.line_cd; 
--            END;
--            v_list.commission_rt := i.commission_rt;
            v_list.commission_due := i.commission_due;
            v_list.wholding_tax_due := i.wholding_tax_due;
            v_list.input_vat_due := i.input_vat_due;
            v_list.net_comm_due := i.net_comm_due;
            v_list.policy_no := get_policy_no(i.policy_id);
--            v_list.assured := get_assd_name(i.assd_no);
            BEGIN
                SELECT bank_ref_no
                  INTO v_list.bank_ref_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            END;
            v_list.intm_no := i.intm_no;
            BEGIN
                SELECT intm_name
                  INTO v_list.intm_name
                  FROM giis_intermediary
                 WHERE intm_no = i.intm_no;
            END;
            
            FOR k IN(SELECT gacc_tran_id
                       FROM giac_direct_prem_collns
                      WHERE b140_iss_cd = i.iss_cd
                        AND b140_prem_seq_no = i.prem_seq_no)
            LOOP
                v_ref_no := v_ref_no || get_ref_no(k.gacc_tran_id) || ',';
            END LOOP;
            
            IF v_ref_no IS NOT NULL THEN
  	            SELECT SUBSTR(v_ref_no,1,LENGTH(v_ref_no)-1)
                  INTO v_list.or_no
                  FROM DUAL;
            END IF;
            PIPE ROW(v_list);
        END LOOP;       
    END view_details_via_bank_files; 
    
    FUNCTION get_max_bank_file_no
        RETURN NUMBER
    IS
        v_bank_file_no NUMBER;
    BEGIN
        SELECT NVL(MAX(bank_file_no),0) + 1
	      INTO v_bank_file_no
          FROM giac_bank_comm_payt_hdr_ext;       
    RETURN v_bank_file_no; 
    END get_max_bank_file_no;    

    PROCEDURE set_bank_file_no(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE,
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    )
    IS
        v_as_of_date   DATE := TO_DATE(p_as_of_date,'MM-DD-YYYY');
    BEGIN
        INSERT INTO giac_bank_comm_payt_hdr_ext
                    (bank_file_no, extract_date, paid_sw, as_of_date_param, intm_type_param, intm_no_param)                                                                                                                                                              -- added by jayson 08.16.2010
             VALUES (p_bank_file_no, SYSDATE, 'N', v_as_of_date, p_intm_type, p_intm);                                                      
    END set_bank_file_no;

    PROCEDURE set_giac_bank_comm_payt(
        p_parent_intm_no    giac_paid_prem_comm_due_v.parent_intm_no%TYPE,
        p_bank_file_no      giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    )
    IS
    BEGIN
        INSERT INTO giac_bank_comm_payt_dtl_ext
                    (bank_file_no, policy_id, policy_no, bank_ref_no, iss_cd, prem_seq_no, 
                     intm_type, parent_intm_no, parent_intm_name, child_intm_no, child_intm_name, 
                     gross_premium, premium_paid,  commission_due, wholding_tax_due, input_vat_due, 
                     commission_amt, wholding_tax, input_vat, net_comm_paid)
             SELECT p_bank_file_no, temp.policy_id, temp.policy_no, temp.bank_ref_no, temp.iss_cd, temp.prem_seq_no, 
                    temp.intm_type, temp.parent_intm_no, temp.parent_intm_name, temp.child_intm_no, temp.child_intm_name, 
                    temp.gross_premium, temp.premium_paid, temp.commission_due, temp.wholding_tax_due, temp.input_vat_due, 
                    temp.commission_amt, temp.wholding_tax, temp.input_vat, temp.net_comm_paid
               FROM giac_bank_comm_payt_temp_ext temp
              WHERE DECODE (get_intm_type (parent_intm_no), giisp.v ('BANC_INTM_TYPE'), child_intm_no, parent_intm_no) = p_parent_intm_no;
    END set_giac_bank_comm_payt; 

    PROCEDURE insert_into_summ_table(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    )
    IS
    BEGIN
    	FOR sum_ext IN (SELECT bank_file_no, child_intm_no, parent_intm_no, policy_id, iss_cd, prem_seq_no, 
                               SUM(premium_paid) premium_paid, SUM(commission_due) commission_due,
                               SUM(wholding_tax_due) wholding_tax_due,
                               SUM(input_vat_due) input_vat_due,
                               SUM((commission_amt - wholding_tax + input_vat) - net_comm_paid) net_comm_due, 
                               SUM(commission_amt) inv_comm_amt,
                               SUM(wholding_tax) inv_whtax_amt,
                               SUM(input_vat) inv_input_vat,
                               SUM(net_comm_paid) net_comm_paid 
                          FROM giac_bank_comm_payt_dtl_ext
                         WHERE bank_file_no = p_bank_file_no
                      GROUP BY bank_file_no, child_intm_no, parent_intm_no, policy_id, iss_cd, prem_seq_no)
        LOOP
            INSERT INTO giac_bank_comm_payt_sum_ext
                        (bank_file_no, intm_no, parent_intm_no, policy_id, iss_cd, prem_seq_no,
                         premium_paid, commission_due, wholding_tax_due, input_vat_due,
                         net_comm_due, commission_amt, wholding_tax, input_vat, net_comm_paid) 
                 VALUES (sum_ext.bank_file_no, sum_ext.child_intm_no, sum_ext.parent_intm_no, sum_ext.policy_id, sum_ext.iss_cd, sum_ext.prem_seq_no, 
                         sum_ext.premium_paid, sum_ext.commission_due, sum_ext.wholding_tax_due,sum_ext.input_vat_due,
                         sum_ext.net_comm_due, sum_ext.inv_comm_amt, sum_ext.inv_whtax_amt, sum_ext.inv_input_vat, sum_ext.net_comm_paid); 
        END LOOP;     
    END insert_into_summ_table;

    FUNCTION generate_file(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE   
    )
        RETURN file_tab PIPELINED
    IS
        v_write         file_type;
        v_amount        NUMBER;
        v_bank_acct_no  VARCHAR2(100);
        v_first_name    VARCHAR2(20);
        v_last_name     VARCHAR2(20);
        v_company_code  VARCHAR2(10)  := LPAD(NVL(giacp.v('COMPANY_CODE'),'0'),4,'0');
        v_branch_code   VARCHAR2(10);
        v_total_amount  NUMBER := 0;
        v_record_count  NUMBER := 0;
        v_float_amount  VARCHAR2(5) := '00';
    BEGIN
    	v_branch_code := '072';
        
        FOR i IN(SELECT DECODE(b.intm_type, giisp.v('BANC_INTM_TYPE'), a.child_intm_no, a.parent_intm_no) intermediary_no,
                        SUM((a.commission_amt - a.wholding_tax + input_vat) - a.net_comm_paid) net_comm_due
                   FROM giac_bank_comm_payt_dtl_ext a, giis_intermediary b
                  WHERE a.parent_intm_no = b.intm_no
                    AND a.bank_file_no = p_bank_file_no
               GROUP BY DECODE(b.intm_type, giisp.v('BANC_INTM_TYPE'), a.child_intm_no, a.parent_intm_no))
        LOOP
            BEGIN
                SELECT LPAD(bank_acct_no,12,'0')
                  INTO v_bank_acct_no
                  FROM giis_payees
                 WHERE payee_no = i.intermediary_no
                   AND payee_class_cd = giacp.v('INTM_CLASS_CD');
            END;
            
            BEGIN
                SELECT RPAD(DECODE(corp_tag, 'N', SUBSTR(intm_name, 1, instr(intm_name, ',') - 1), SUBSTR(intm_name, 20 + 1)), 20,' ') lastName,
                       RPAD(DECODE(corp_tag, 'N', LTRIM(SUBSTR(intm_name, instr(intm_name,',') + 1)), SUBSTR(intm_name, 1, 20 + 1)), 20, ' ') firstName
                  INTO v_last_name, v_first_name
                  FROM giis_intermediary
                 WHERE intm_no =i.intermediary_no;
            END;
            
            v_amount := i.net_comm_due;
            
            IF INSTR(v_amount, '.') > 0 THEN
    	        v_float_amount := RPAD(SUBSTR(v_amount, INSTR(v_amount, '.') + 1),2,'0');
            END IF; 
            
            v_write.text_to_write := '052'||v_branch_code||v_company_code||TO_CHAR(SYSDATE, 'mmddrr')||
  	                                 LPAD(TRUNC(v_amount),10,'0')||v_float_amount
  	                                 ||v_bank_acct_no||v_last_name||v_first_name;
            
            v_total_amount := v_total_amount + v_amount;
  	        v_record_count := v_record_count + 1;       
            
            PIPE ROW(v_write);                            
        END LOOP;
        
        v_float_amount := '00';
        
        IF INSTR(v_total_amount, '.') > 0 THEN
            v_float_amount := RPAD(SUBSTR(v_total_amount, INSTR(v_total_amount, '.') + 1),2,'0');
        END IF;
        
        v_write.text_to_write := '099'||v_branch_code||v_company_code||TO_CHAR(SYSDATE, 'mmddrr')||LPAD(TRUNC(v_total_amount),10,'0')||v_float_amount
                                 ||LPAD(v_record_count,10,'0');   
        PIPE ROW(v_write);                                   
    END generate_file;    

    PROCEDURE update_file_name(
        p_file_name     giac_bank_comm_payt_hdr_ext.bank_file_name%TYPE,
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    )
    IS
    BEGIN
        UPDATE giac_bank_comm_payt_hdr_ext
		   SET bank_file_name = p_file_name
		 WHERE bank_file_no = p_bank_file_no;
    END update_file_name;    
                         
END GIACS158_PKG;
/
