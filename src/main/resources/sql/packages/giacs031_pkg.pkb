CREATE OR REPLACE PACKAGE BODY CPI.GIACS031_PKG
AS
   FUNCTION get_giacs031_bill_tran1_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
   RETURN giacs031_bill_lov_tab PIPELINED
   IS
      v_list    giacs031_bill_lov_type;
   BEGIN
        FOR i IN (
            SELECT a.iss_cd, a.prem_seq_no, b.property, b.ref_inv_no, c.policy_id, pol_flag, currency_cd, currency_rt,
                     c.line_cd
                     || '-'
                     || c.subline_cd
                     || '-'
                     || c.iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (c.issue_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                     || '-'
                     || LTRIM (TO_CHAR (c.renew_no, '09'))
                     || DECODE (
                           NVL (c.endt_seq_no, 0),
                           0, '',
                              ' / '
                           || c.endt_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (c.endt_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (c.endt_seq_no, '0999999'))
                        ) policy_no,
               c.ref_pol_no, c.assd_no, d.assd_name
          FROM gipi_polbasic c,
               gipi_invoice b,
               giac_aging_soa_details a,
               giis_assured d
         WHERE 1 = 1
           AND a.policy_id = c.policy_id
           AND c.assd_no = d.assd_no
           AND a.prem_seq_no = b.prem_seq_no
           AND a.iss_cd = b.iss_cd
           AND a.balance_amt_due > 0
           AND a.iss_cd = p_iss_cd
           AND a.prem_seq_no = NVL(p_search, a.prem_seq_no)
        )
        LOOP
            v_list.iss_cd           := i.iss_cd;       
            v_list.prem_seq_no      := i.prem_seq_no;  
            v_list.property         := i.property;     
            v_list.ref_inv_no       := i.ref_inv_no;   
            v_list.policy_id        := i.policy_id;    
            v_list.policy_number    := i.policy_no;
            v_list.ref_pol_no       := i.ref_pol_no;   
            v_list.assd_no          := i.assd_no;      
            v_list.assd_name        := i.assd_name;
            v_list.pol_flag         := i.pol_flag;
            v_list.currency_cd      := i.currency_cd;
            
            BEGIN
               SELECT currency_rt, currency_desc
                 INTO v_list.currency_rt, v_list.currency_desc
                 FROM giis_currency
                WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                v_list.currency_rt := 1;
                v_list.currency_desc := '';
            END;
             
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_bill_tran2_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
   RETURN giacs031_bill_lov_tab PIPELINED
   IS
      v_list    giacs031_bill_lov_type;
   BEGIN
        FOR i IN (
            SELECT d.iss_cd iss_cd, d.prem_seq_no prem_seq_no, d.property, d.ref_inv_no, pol_flag, currency_cd, currency_rt,
               c.policy_id, c.ref_pol_no,
                  c.line_cd
                     || '-'
                     || c.subline_cd
                     || '-'
                     || c.iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (c.issue_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                     || '-'
                     || LTRIM (TO_CHAR (c.renew_no, '09'))
                     || DECODE (
                           NVL (c.endt_seq_no, 0),
                           0, '',
                              ' / '
                           || c.endt_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (c.endt_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (c.endt_seq_no, '0999999'))
                        ) policy_no,
               g.assd_no, g.assd_name
          FROM gipi_polbasic c, gipi_invoice d, giis_assured g
         WHERE 1=1
           AND d.policy_id = c.policy_id
           AND g.assd_no = c.assd_no
           AND EXISTS (
                  SELECT a.iss_cd, a.prem_seq_no
                    FROM giac_pdc_payts a, giac_acctrans b
                   WHERE 1 = 1
                     AND a.iss_cd = d.iss_cd
                     AND a.prem_seq_no = d.prem_seq_no
                     AND a.gacc_tran_id = b.tran_id
                     AND transaction_type = 1
                     AND NOT EXISTS (
                            SELECT e.gacc_tran_id
                              FROM giac_reversals e, giac_acctrans f
                             WHERE e.reversing_tran_id = f.tran_id
                               AND f.tran_flag <> 'D'
                               AND e.gacc_tran_id = b.tran_id)
                     AND b.tran_flag <> 'D'
                  HAVING SUM (a.collection_amt) > 0)
           AND d.iss_cd = p_iss_cd
           AND d.prem_seq_no = NVL(p_search, d.prem_seq_no)
        )
        LOOP
            v_list.iss_cd           := i.iss_cd;       
            v_list.prem_seq_no      := i.prem_seq_no;  
            v_list.property         := i.property;     
            v_list.ref_inv_no       := i.ref_inv_no;   
            v_list.policy_id        := i.policy_id;    
            v_list.policy_number    := i.policy_no;
            v_list.ref_pol_no       := i.ref_pol_no;   
            v_list.assd_no          := i.assd_no;   
            v_list.assd_name        := i.assd_name;
            v_list.pol_flag         := i.pol_flag;     
            v_list.currency_cd      := i.currency_cd;
            
            BEGIN
               SELECT currency_rt, currency_desc
                 INTO v_list.currency_rt, v_list.currency_desc
                 FROM giis_currency
                WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                v_list.currency_rt := 1;
                v_list.currency_desc := '';
            END;
             
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_bill_tran3_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
       RETURN giacs031_bill_lov_tab PIPELINED
       IS
          v_list    giacs031_bill_lov_type;
   BEGIN
            FOR i IN (
                SELECT a.iss_cd, a.prem_seq_no, b.property, b.ref_inv_no, c.policy_id, pol_flag, currency_cd, currency_rt,
                     c.line_cd
                         || '-'
                         || c.subline_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (c.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (c.renew_no, '09'))
                         || DECODE (
                               NVL (c.endt_seq_no, 0),
                               0, '',
                                  ' / '
                               || c.endt_iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (c.endt_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (c.endt_seq_no, '0999999'))
                            ) policy_no,
                   c.ref_pol_no, c.assd_no, d.assd_name
              FROM giis_assured d,
                   gipi_polbasic c,
                   gipi_invoice b,
                   giac_aging_soa_details a
             WHERE 1 = 1
               AND c.assd_no = d.assd_no
               AND a.policy_id = c.policy_id
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd = b.iss_cd
               AND a.balance_amt_due < 0
               AND a.iss_cd = p_iss_cd
               AND a.prem_seq_no = NVL(p_search, a.prem_seq_no)
        )
        LOOP
            v_list.iss_cd           := i.iss_cd;       
            v_list.prem_seq_no      := i.prem_seq_no;  
            v_list.property         := i.property;     
            v_list.ref_inv_no       := i.ref_inv_no;   
            v_list.policy_id        := i.policy_id;    
            v_list.policy_number    := i.policy_no;
            v_list.ref_pol_no       := i.ref_pol_no;   
            v_list.assd_no          := i.assd_no;   
            v_list.assd_name        := i.assd_name;
            v_list.pol_flag         := i.pol_flag;  
            v_list.currency_cd      := i.currency_cd;
            
            BEGIN
               SELECT currency_rt, currency_desc
                 INTO v_list.currency_rt, v_list.currency_desc
                 FROM giis_currency
                WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                v_list.currency_rt := 1;
                v_list.currency_desc := '';
            END; 
             
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_bill_tran4_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
       RETURN giacs031_bill_lov_tab PIPELINED
       IS
          v_list    giacs031_bill_lov_type;
   BEGIN
            FOR i IN (
                SELECT d.iss_cd iss_cd, d.prem_seq_no prem_seq_no, d.property, d.ref_inv_no, pol_flag, currency_cd, currency_rt,
                   c.policy_id, c.ref_pol_no,
                      RTRIM (c.line_cd)
                   || '-'
                   || RTRIM (c.subline_cd)
                   || '-'
                   || RTRIM (c.iss_cd)
                   || '-'
                   || LTRIM (TO_CHAR (c.issue_yy))
                   || '-'
                   || LTRIM (TO_CHAR (c.pol_seq_no))
                   || DECODE (c.endt_seq_no,
                              0, NULL,
                                 '-'
                              || c.endt_iss_cd
                              || '-'
                              || LTRIM (TO_CHAR (c.endt_yy))
                              || '-'
                              || LTRIM (TO_CHAR (c.endt_seq_no))
                              || '-'
                              || RTRIM (c.endt_type)
                             )
                   || '-'
                   || LTRIM (TO_CHAR (c.renew_no)) policy_no,
                   g.assd_no, g.assd_name
              FROM giis_assured g, gipi_polbasic c, gipi_invoice d
             WHERE c.assd_no = g.assd_no
               AND d.policy_id = c.policy_id
               AND EXISTS (
                      SELECT a.iss_cd, a.prem_seq_no
                        FROM giac_pdc_payts a, giac_acctrans b
                       WHERE 1 = 1
                         AND a.iss_cd = d.iss_cd
                         AND a.prem_seq_no = d.prem_seq_no
                         AND a.gacc_tran_id = b.tran_id
                         AND transaction_type = 3
                         AND NOT EXISTS (
                                SELECT e.gacc_tran_id
                                  FROM giac_reversals e, giac_acctrans f
                                 WHERE e.reversing_tran_id = f.tran_id
                                   AND f.tran_flag <> 'D'
                                   AND e.gacc_tran_id = b.tran_id)
                         AND b.tran_flag <> 'D'
                      HAVING SUM (a.collection_amt) < 0)
               AND d.iss_cd = p_iss_cd
               AND d.prem_seq_no = NVL(p_search, d.prem_seq_no)
        )
        LOOP
            v_list.iss_cd           := i.iss_cd;       
            v_list.prem_seq_no      := i.prem_seq_no;  
            v_list.property         := i.property;     
            v_list.ref_inv_no       := i.ref_inv_no;   
            v_list.policy_id        := i.policy_id;    
            v_list.policy_number    := i.policy_no;
            v_list.ref_pol_no       := i.ref_pol_no;   
            v_list.assd_no          := i.assd_no;
            v_list.assd_name        := i.assd_name;  
            v_list.pol_flag         := i.pol_flag;
            v_list.currency_cd      := i.currency_cd;
            
            BEGIN
               SELECT currency_rt, currency_desc
                 INTO v_list.currency_rt, v_list.currency_desc
                 FROM giis_currency
                WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                v_list.currency_rt := 1;
                v_list.currency_desc := '';
            END;       
             
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_inst_tran1_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED
   IS
      v_list    giacs031_inst_lov_type;
   BEGIN
        FOR i IN (
            SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt,
                   balance_amt_due collection_amt1
              FROM giac_aging_soa_details
             WHERE iss_cd = p_iss_cd
               AND prem_seq_no = p_prem_seq_no
               AND balance_amt_due > 0
        )
        LOOP
            v_list.iss_cd            := i.iss_cd;         
            v_list.prem_seq_no       := i.prem_seq_no;    
            v_list.inst_no           := i.inst_no;        
            v_list.collection_amt    := i.collection_amt; 
            v_list.collection_amt1   := i.collection_amt1;
            
            FOR j IN(
                SELECT NVL(prem_amt,0)+NVL(tax_amt,0) total_amount_due
                  FROM gipi_invoice
                 WHERE iss_cd        = p_iss_cd
                   AND prem_seq_no   = p_prem_seq_no
            )
            LOOP
                v_list.total_balance := j.total_amount_due;
                
                FOR k IN(
                    SELECT SUM (NVL (b.collection_amt, 0)) total_payments,
                           j.total_amount_due - SUM (NVL (b.collection_amt, 0)) balance_amt_due
                      FROM giac_direct_prem_collns b, giac_acctrans c
                     WHERE b.b140_iss_cd = p_iss_cd
                       AND b.b140_prem_seq_no = p_prem_seq_no
                       AND b.gacc_tran_id <> p_gacc_tran_id
                       AND c.tran_id = b.gacc_tran_id
                       AND c.tran_flag <> 'D'
                       AND c.tran_id NOT IN (
                                      SELECT gacc_tran_id
                                        FROM giac_acctrans d, giac_reversals e
                                       WHERE d.tran_id = e.reversing_tran_id
                                         AND d.tran_flag <> 'D')
                )
                LOOP
                    IF NVL(k.balance_amt_due, 0) != 0 THEN
                        v_list.total_balance := k.balance_amt_due;
                    END IF;
                    
                END LOOP;
                
            END LOOP;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_inst_tran2_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED
   IS
      v_list    giacs031_inst_lov_type;
   BEGIN
        FOR i IN (
              SELECT a.iss_cd iss_cd, a.prem_seq_no prem_seq_no, a.inst_no,
                     SUM (a.collection_amt) collection_amt,
                     (-1) * SUM (a.collection_amt) collection_amt1
                FROM giac_acctrans b, giac_pdc_payts a
               WHERE 1 = 1
                 AND a.gacc_tran_id = b.tran_id
                 AND NOT EXISTS (
                        SELECT 'x'
                          FROM giac_reversals c, giac_acctrans d
                         WHERE c.reversing_tran_id = d.tran_id
                           AND c.gacc_tran_id = a.gacc_tran_id
                           AND d.tran_flag <> 'D')
                 AND b.tran_flag <> 'D'
                 AND a.prem_seq_no = p_prem_seq_no
                 AND a.iss_cd = p_iss_cd
            GROUP BY a.iss_cd, a.prem_seq_no, a.inst_no
              HAVING SUM (a.collection_amt) > 0
        )
        LOOP
            v_list.iss_cd            := i.iss_cd;         
            v_list.prem_seq_no       := i.prem_seq_no;    
            v_list.inst_no           := i.inst_no;        
            v_list.collection_amt    := i.collection_amt; 
            v_list.collection_amt1   := i.collection_amt1;
            
            FOR j IN(
                SELECT NVL(prem_amt,0)+NVL(tax_amt,0) total_amount_due
                  FROM gipi_invoice
                 WHERE iss_cd        = p_iss_cd
                   AND prem_seq_no   = p_prem_seq_no
            )
            LOOP
                v_list.total_balance := j.total_amount_due;
                
                FOR k IN(
                    SELECT SUM (b.collection_amt) total_payments,
                           j.total_amount_due - SUM (NVL (b.collection_amt, 0)) balance_amt_due
                      FROM giac_direct_prem_collns b, giac_acctrans c
                     WHERE b.b140_iss_cd = p_iss_cd
                       AND b.b140_prem_seq_no = p_prem_seq_no
                       AND b.gacc_tran_id <> p_gacc_tran_id
                       AND c.tran_id = b.gacc_tran_id
                       AND c.tran_flag <> 'D'
                       AND c.tran_id NOT IN (
                                      SELECT gacc_tran_id
                                        FROM giac_acctrans d, giac_reversals e
                                       WHERE d.tran_id = e.reversing_tran_id
                                         AND d.tran_flag <> 'D')
                )
                LOOP
                    IF NVL(k.balance_amt_due, 0) != 0 THEN
                            v_list.total_balance := (-1)*(k.balance_amt_due);   
                    END IF;
                END LOOP;
                
            END LOOP;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_inst_tran3_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED
   IS
      v_list    giacs031_inst_lov_type;
   BEGIN
        FOR i IN (
                SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt,
                       balance_amt_due collection_amt1
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND balance_amt_due < 0
        )
        LOOP
            v_list.iss_cd            := i.iss_cd;         
            v_list.prem_seq_no       := i.prem_seq_no;    
            v_list.inst_no           := i.inst_no;        
            v_list.collection_amt    := i.collection_amt; 
            v_list.collection_amt1   := i.collection_amt1;
            
            FOR j IN(
                SELECT NVL(prem_amt,0)+NVL(tax_amt,0) total_amount_due
                  FROM gipi_invoice
                 WHERE iss_cd        = p_iss_cd
                   AND prem_seq_no   = p_prem_seq_no
            )
            LOOP
                v_list.total_balance := j.total_amount_due;
            
                FOR k IN(
                    SELECT SUM (NVL (b.collection_amt, 0)) total_payments,
                           j.total_amount_due - SUM (NVL (b.collection_amt, 0)) balance_amt_due
                      FROM giac_direct_prem_collns b, giac_acctrans c
                     WHERE b.b140_iss_cd = p_iss_cd
                       AND b.b140_prem_seq_no = p_prem_seq_no
                       AND b.gacc_tran_id <> p_gacc_tran_id
                       AND c.tran_id = b.gacc_tran_id
                       AND c.tran_flag <> 'D'
                       AND c.tran_id NOT IN (
                                      SELECT gacc_tran_id
                                        FROM giac_acctrans d, giac_reversals e
                                       WHERE d.tran_id = e.reversing_tran_id
                                         AND d.tran_flag <> 'D')
                )
                LOOP
                    v_list.total_balance := k.balance_amt_due;
                END LOOP;
                
            END LOOP;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_inst_tran4_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED
   IS
      v_list    giacs031_inst_lov_type;
   BEGIN
        FOR i IN (
              SELECT a.iss_cd iss_cd, a.prem_seq_no prem_seq_no, a.inst_no,
                     SUM (a.collection_amt) collection_amt,
                     (-1) * SUM (a.collection_amt) collection_amt1
                FROM giac_acctrans b, giac_pdc_payts a
               WHERE 1 = 1
                 AND a.gacc_tran_id = b.tran_id
                 AND NOT EXISTS (
                        SELECT 'x'
                          FROM giac_reversals c, giac_acctrans d
                         WHERE c.reversing_tran_id = d.tran_id
                           AND c.gacc_tran_id = a.gacc_tran_id
                           AND d.tran_flag <> 'D')
                 AND b.tran_flag <> 'D'
                 AND a.prem_seq_no = p_prem_seq_no
                 AND a.iss_cd = p_iss_cd
            GROUP BY a.iss_cd, a.prem_seq_no, a.inst_no
              HAVING SUM (a.collection_amt) < 0
        )
        LOOP
            v_list.iss_cd            := i.iss_cd;         
            v_list.prem_seq_no       := i.prem_seq_no;    
            v_list.inst_no           := i.inst_no;        
            v_list.collection_amt    := i.collection_amt; 
            v_list.collection_amt1   := i.collection_amt1;
            
            FOR j IN(
                SELECT NVL(prem_amt,0)+NVL(tax_amt,0) total_amount_due
                  FROM gipi_invoice
                 WHERE iss_cd        = p_iss_cd
                   AND prem_seq_no   = p_prem_seq_no
            )
            LOOP
                v_list.total_balance := j.total_amount_due;
            
                FOR k IN(
                    SELECT SUM (NVL (b.collection_amt, 0)) total_payments,
                           j.total_amount_due - SUM (NVL (b.collection_amt, 0)) balance_amt_due
                      FROM giac_direct_prem_collns b, giac_acctrans c
                     WHERE b.b140_iss_cd = p_iss_cd
                       AND b.b140_prem_seq_no = p_prem_seq_no
                       AND b.gacc_tran_id <> p_gacc_tran_id
                       AND c.tran_id = b.gacc_tran_id
                       AND c.tran_flag <> 'D'
                       AND c.tran_id NOT IN (
                                      SELECT gacc_tran_id
                                        FROM giac_acctrans d, giac_reversals e
                                       WHERE d.tran_id = e.reversing_tran_id
                                         AND d.tran_flag <> 'D')
                )
                LOOP
                    v_list.total_balance := (-1)*(k.balance_amt_due);                         
                END LOOP;
                
            END LOOP;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION get_giacs031_list(
        p_tran_id       VARCHAR2
   )
   RETURN giacs031_list_tab PIPELINED
   IS
        v_list    giacs031_list_type;
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_pdc_payts
             WHERE gacc_tran_id = p_tran_id
        )
        LOOP
            v_list.gacc_tran_id     := i.gacc_tran_id; 
            v_list.iss_cd           := i.iss_cd;                        
            v_list.prem_seq_no      := i.prem_seq_no;     
            v_list.inst_no          := i.inst_no;         
            v_list.collection_amt   := i.collection_amt;  
            v_list.currency_cd      := i.currency_cd;     
            v_list.fcurrency_amt    := i.fcurrency_amt;   
            v_list.particulars      := i.particulars;     
            v_list.transaction_type := i.transaction_type;
            v_list.user_id          := i.user_id;
            v_list.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            BEGIN
               SELECT currency_rt, currency_desc
                 INTO v_list.currency_rt, v_list.currency_desc
                 FROM giis_currency
                WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                v_list.currency_rt := 1;
                v_list.currency_desc := '';
            END;
            
            IF i.transaction_type = 1 THEN
                SELECT get_policy_no(c.policy_id), get_assd_name(c.assd_no)
                  INTO v_list.policy_no, v_list.assd_name
                  FROM gipi_polbasic c,
                       gipi_invoice b,
                       giac_aging_soa_details a
                 WHERE 1 = 1
                   AND a.policy_id = c.policy_id
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.iss_cd = b.iss_cd
                   AND a.balance_amt_due > 0
                   AND a.iss_cd = i.iss_cd
                   AND a.prem_seq_no = i.prem_seq_no
                   and inst_no = i.inst_no;
                   
            ELSIF i.transaction_type = 2 THEN
                SELECT get_policy_no(c.policy_id), get_assd_name(c.assd_no)
                  INTO v_list.policy_no, v_list.assd_name
                  FROM gipi_polbasic c, gipi_invoice d
                 WHERE d.policy_id = c.policy_id
                   AND EXISTS (
                          SELECT a.iss_cd, a.prem_seq_no
                            FROM giac_pdc_payts a, giac_acctrans b
                           WHERE 1 = 1
                             AND a.iss_cd = d.iss_cd
                             AND a.prem_seq_no = d.prem_seq_no
                             AND a.gacc_tran_id = b.tran_id
                             AND transaction_type = 1
                             AND NOT EXISTS (
                                    SELECT e.gacc_tran_id
                                      FROM giac_reversals e, giac_acctrans f
                                     WHERE e.reversing_tran_id = f.tran_id
                                       AND f.tran_flag <> 'D'
                                       AND e.gacc_tran_id = b.tran_id)
                             AND b.tran_flag <> 'D'
                          HAVING SUM (a.collection_amt) > 0)
                   AND d.iss_cd = i.iss_cd
                   AND d.prem_seq_no = i.prem_seq_no;
            
            ELSIF i.transaction_type = 3 THEN
                SELECT get_policy_no(c.policy_id), get_assd_name(c.assd_no)
                  INTO v_list.policy_no, v_list.assd_name
                  FROM gipi_polbasic c,
                       gipi_invoice b,
                       giac_aging_soa_details a
                 WHERE 1 = 1
                   AND a.policy_id = c.policy_id
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.iss_cd = b.iss_cd
                   AND a.balance_amt_due < 0
                   AND a.iss_cd = i.iss_cd
                   AND a.prem_seq_no = i.prem_seq_no
                   and inst_no = i.inst_no;
            
            ELSIF i.transaction_type = 4 THEN
                SELECT get_policy_no(c.policy_id), get_assd_name(c.assd_no)
                  INTO v_list.policy_no, v_list.assd_name
                  FROM gipi_polbasic c, gipi_invoice d
                 WHERE d.policy_id = c.policy_id
                   AND EXISTS (
                          SELECT a.iss_cd, a.prem_seq_no
                            FROM giac_pdc_payts a, giac_acctrans b
                           WHERE 1 = 1
                             AND a.iss_cd = d.iss_cd
                             AND a.prem_seq_no = d.prem_seq_no
                             AND a.gacc_tran_id = b.tran_id
                             AND transaction_type = 3
                             AND NOT EXISTS (
                                    SELECT e.gacc_tran_id
                                      FROM giac_reversals e, giac_acctrans f
                                     WHERE e.reversing_tran_id = f.tran_id
                                       AND f.tran_flag <> 'D'
                                       AND e.gacc_tran_id = b.tran_id)
                             AND b.tran_flag <> 'D'
                          HAVING SUM (a.collection_amt) < 0)
                   AND d.iss_cd = i.iss_cd
                   AND d.prem_seq_no = i.prem_seq_no;
            END IF;   
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE val_add_rec(
        p_gacc_tran_id  giac_pdc_payts.gacc_tran_id%TYPE,
        p_iss_cd        giac_pdc_payts.iss_cd%TYPE,      
        p_prem_seq_no   giac_pdc_payts.prem_seq_no%TYPE, 
        p_inst_no       giac_pdc_payts.inst_no%TYPE     
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_pdc_payts
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND iss_cd       = p_iss_cd      
                   AND prem_seq_no  = p_prem_seq_no
                   AND inst_no      = p_inst_no    
      )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same gacc_tran_id, iss_cd, prem_seq_no and inst_no.'
                                 );
      END IF;
   END;
   
   PROCEDURE set_rec (p_rec giac_pdc_payts%ROWTYPE)
   AS
   BEGIN
   
    INSERT INTO giac_pdc_payts
                (gacc_tran_id, iss_cd, prem_seq_no, inst_no,
                collection_amt, currency_cd, currency_rt, fcurrency_amt,
                particulars, transaction_type, user_id, last_update
                )
         VALUES (p_rec.gacc_tran_id, p_rec.iss_cd, p_rec.prem_seq_no, p_rec.inst_no,
                p_rec.collection_amt, p_rec.currency_cd, p_rec.currency_rt, p_rec.collection_amt / p_rec.currency_rt,
                p_rec.particulars, p_rec.transaction_type, p_rec.user_id, SYSDATE
                );
                
    post_commit (p_rec);
    /*    
    BEGIN
        SELECT module_id,
               generation_type
          INTO v_module_id,
               v_gen_type
          FROM giac_modules
         WHERE module_name  = 'GIACS031';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
    END;
        
        DELETE giac_op_text
         WHERE gacc_tran_id  = p_rec.gacc_tran_id
           AND item_gen_type = v_gen_type;
           
      V_EXIST := FALSE;
      FOR i IN(
          SELECT a.iss_cd, a.prem_seq_no, SUM (a.collection_amt) collection_amt,
                 b.currency_cd, b.currency_rt
            FROM giac_pdc_payts a, gipi_invoice b, gipi_polbasic c
           WHERE a.iss_cd       = b.iss_cd
             AND a.prem_seq_no  = b.prem_seq_no
             AND b.policy_id    = c.policy_id
             AND gacc_tran_id   = p_rec.gacc_tran_id
             AND a.iss_cd       = p_rec.iss_cd   
             AND a.prem_seq_no  = p_rec.prem_seq_no
             AND a.inst_no      = p_rec.inst_no
        GROUP BY a.iss_cd, a.prem_seq_no, b.currency_cd, b.currency_rt
      )
      LOOP
        V_EXIST := TRUE;
        check_op_text_insert(i.collection_amt,i.iss_cd, i.prem_seq_no, v_counter, i.currency_cd, v_gen_type, p_rec);
      END LOOP;
        
      IF NOT V_EXIST THEN
        check_op_text_insert(p_rec.collection_amt,p_rec.iss_cd, p_rec.prem_seq_no,v_counter, p_rec.currency_cd, v_gen_type, p_rec);
      END IF;
      
      DELETE giac_op_text
       WHERE gacc_tran_id    = p_rec.gacc_tran_id
         AND NVL(item_amt,0) = 0
         AND item_gen_type   = v_gen_type;
            
      UPDATE giac_op_text
         SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
       WHERE gacc_tran_id = p_rec.gacc_tran_id
         AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
         AND item_gen_type = v_gen_type;  */
             
   END;
   
   
   
   PROCEDURE del_rec (p_rec giac_pdc_payts%ROWTYPE)
   AS
    v_gen_type  giac_modules.generation_type%TYPE;
    v_item_amt  giac_op_text.item_amt%TYPE;
    v_fcurr_amt  giac_op_text.item_amt%TYPE;
   BEGIN
     DELETE FROM giac_pdc_payts
      WHERE gacc_tran_id = p_rec.gacc_tran_id
        AND iss_cd       = p_rec.iss_cd      
        AND prem_seq_no  = p_rec.prem_seq_no
        AND inst_no      = p_rec.inst_no;
        
     SELECT generation_type
       INTO v_gen_type
       FROM giac_modules
      WHERE module_name  = 'GIACS031'; 
        
     BEGIN
         SELECT item_amt, foreign_curr_amt
           INTO v_item_amt, v_fcurr_amt
           FROM giac_op_text
          WHERE gacc_tran_id = p_rec.gacc_tran_id
            AND item_gen_type = v_gen_type
            AND bill_no = p_rec.iss_cd ||'-'||TO_CHAR(p_rec.prem_seq_no);
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
                v_item_amt  := 0;
                v_fcurr_amt := 0; 
     
     END;
    
    IF p_rec.collection_amt = v_item_amt THEN
        DELETE FROM giac_op_text
         WHERE gacc_tran_id = p_rec.gacc_tran_id
           AND item_gen_type = v_gen_type
           AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
           AND bill_no = p_rec.iss_cd ||'-'||TO_CHAR(p_rec.prem_seq_no);
    ELSE
        UPDATE giac_op_text
           SET item_amt = v_item_amt - p_rec.collection_amt,
               foreign_curr_amt = v_fcurr_amt - p_rec.collection_amt
         WHERE gacc_tran_id = p_rec.gacc_tran_id
           AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
           AND item_gen_type = v_gen_type
           AND bill_no = p_rec.iss_cd ||'-'||TO_CHAR(p_rec.prem_seq_no);
    END IF;
    
     /*DELETE FROM giac_op_text
      WHERE gacc_tran_id = p_rec.gacc_tran_id
        AND item_gen_type = v_gen_type
        AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
        AND bill_no = p_rec.iss_cd ||'-'||TO_CHAR(p_rec.prem_seq_no);*/
   END;
   
   PROCEDURE check_op_text_insert (
    p_collection_amt  IN NUMBER, 
    p_iss_cd          IN giac_pdc_payts.iss_cd%TYPE,
    p_prem_seq_no     IN giac_pdc_payts.prem_seq_no%TYPE,
    p_seq_no          IN NUMBER,
    p_currency_cd     IN giac_pdc_payts.currency_cd%TYPE,
    p_gen_type           giac_modules.generation_type%TYPE,
    p_rec                giac_pdc_payts%ROWTYPE              
   )
   IS
      v_exist                VARCHAR2(1);
      n_seq_no               NUMBER(2):=0;
      v_count                NUMBER:=0;
      v_no                   NUMBER:=0;
      v_currency_cd          giac_pdc_payts.currency_cd%TYPE;
      v_convert_rate         giac_pdc_payts.currency_rt%TYPE;    
      v_column_no            giac_taxes.column_no%TYPE;        
      v_seq                  NUMBER := 1;
        
    BEGIN
      BEGIN
        SELECT 'X'
         INTO v_exist
         FROM giac_op_text
        WHERE gacc_tran_id = p_rec.gacc_tran_id
          AND item_gen_type  =  p_gen_type
          AND SUBSTR(item_text, 1, 7) = 'PREMIUM'
          AND bill_no = p_rec.iss_cd||'-'||TO_CHAR(p_rec.prem_seq_no);    

--        IF v_exist = 'X' THEN
            UPDATE giac_op_text
              SET   item_amt= NVL(p_collection_amt,0) + NVL(item_amt,0) , 
                    foreign_curr_amt =  NVL(p_collection_amt,0) + NVL(foreign_curr_amt,0),
                    column_no = 1
             WHERE gacc_tran_id = p_rec.gacc_tran_id
               AND SUBSTR(item_text,1,7) = 'PREMIUM'
               AND item_gen_type  =  p_gen_type
               AND bill_no = p_rec.iss_cd||'-'||TO_CHAR(p_rec.prem_seq_no); 
               
        
        /*ELSE
            SELECT MAX (item_seq_no)
              INTO v_seq
              FROM giac_op_text
             WHERE gacc_tran_id = p_rec.gacc_tran_id 
               AND item_gen_type = p_gen_type;
                 
            v_seq := v_seq + 1;
             INSERT INTO giac_op_text(
                  gacc_tran_id ,item_gen_type ,item_seq_no      ,item_amt, 
                  item_text    ,bill_no       ,print_seq_no     ,currency_cd,
                  user_id      ,last_update   ,foreign_curr_amt ,column_no)
                VALUES(
                  p_rec.gacc_tran_id, p_gen_type, v_seq, p_collection_amt,
                  'PREMIUM PAYMENT', p_iss_cd||'-'||TO_CHAR(p_prem_seq_no), v_seq, p_currency_cd,
                  p_rec.user_id, SYSDATE, p_collection_amt, 1);
        END IF;*/

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        
        SELECT NVL(MAX (item_seq_no),0)
              INTO v_seq
              FROM giac_op_text
             WHERE gacc_tran_id = p_rec.gacc_tran_id 
               AND item_gen_type = p_gen_type;
               
          v_seq := v_seq + 1;
          
         BEGIN
         INSERT INTO giac_op_text(
              gacc_tran_id ,item_gen_type ,item_seq_no      ,item_amt, 
              item_text    ,bill_no       ,print_seq_no     ,currency_cd,
              user_id      ,last_update   ,foreign_curr_amt ,column_no)
            VALUES(
              p_rec.gacc_tran_id, p_gen_type, v_seq, p_collection_amt,
              'PREMIUM PAYMENT', p_iss_cd||'-'||TO_CHAR(p_prem_seq_no), v_seq, p_currency_cd,
              p_rec.user_id, SYSDATE, p_collection_amt, 1);

         EXCEPTION
            WHEN OTHERS THEN
                raise_application_error (-20001, SQLERRM);
         END;
       END;
    END;  
    
    PROCEDURE post_commit (p_rec giac_pdc_payts%ROWTYPE)
    IS
        v_module_id     giac_modules.module_id%TYPE;   
        v_gen_type      giac_modules.generation_type%TYPE;  
        v_exist         NUMBER := 0;
        v_counter       NUMBER := 1;
    BEGIN
        BEGIN
        SELECT module_id,
               generation_type
          INTO v_module_id,
               v_gen_type
          FROM giac_modules
         WHERE module_name  = 'GIACS031';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
        END;
            
          /* DELETE giac_op_text
             WHERE gacc_tran_id  = p_rec.gacc_tran_id
               AND item_gen_type = v_gen_type;*/
               
          V_EXIST := 0;
          FOR i IN(
              SELECT a.iss_cd, a.prem_seq_no, SUM (a.collection_amt) collection_amt,
                     b.currency_cd, b.currency_rt
                FROM giac_pdc_payts a, gipi_invoice b, gipi_polbasic c
               WHERE a.iss_cd       = b.iss_cd
                 AND a.prem_seq_no  = b.prem_seq_no
                 AND b.policy_id    = c.policy_id
                 AND gacc_tran_id   = p_rec.gacc_tran_id
                 AND a.iss_cd       = p_rec.iss_cd   
                 AND a.prem_seq_no  = p_rec.prem_seq_no
                 AND a.inst_no      = p_rec.inst_no
            GROUP BY a.iss_cd, a.prem_seq_no, b.currency_cd, b.currency_rt
          )
          LOOP
            V_EXIST := 1;
            check_op_text_insert(i.collection_amt,i.iss_cd, i.prem_seq_no, v_counter, i.currency_cd, v_gen_type, p_rec);
          END LOOP;
            
          IF V_EXIST = 0 THEN
            check_op_text_insert(p_rec.collection_amt,p_rec.iss_cd, p_rec.prem_seq_no,v_counter, p_rec.currency_cd, v_gen_type, p_rec);
          END IF;
          
          DELETE giac_op_text
           WHERE gacc_tran_id    = p_rec.gacc_tran_id
             AND NVL(item_amt,0) = 0
             AND item_gen_type   = v_gen_type;
                
          UPDATE giac_op_text
             SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
           WHERE gacc_tran_id = p_rec.gacc_tran_id
             AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
             AND item_gen_type = v_gen_type; 
    END;
    
    FUNCTION get_giacs031_policy_lov(
        p_line_cd       VARCHAR2,   
        p_subline_cd    VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_issue_yy      VARCHAR2,
        p_pol_seq_no    VARCHAR2,
        p_renew_no      VARCHAR2,
        p_ref_pol_no    VARCHAR2,
        p_due_sw        VARCHAR2
   )
   RETURN giacs031_policy_tab PIPELINED
   IS
      v_list    giacs031_policy_type;
   BEGIN
        FOR i IN (
            SELECT c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no,
                   c.renew_no, c.ref_pol_no
              FROM gipi_polbasic c, gipi_invoice b, giac_aging_soa_details a
             WHERE 1 = 1
               AND a.policy_id = c.policy_id
               AND b.policy_id = c.policy_id
               AND a.prem_seq_no = b.prem_seq_no
               AND a.iss_cd = b.iss_cd
               AND a.balance_amt_due <> 0
               AND c.line_cd    = p_line_cd   
               AND c.subline_cd = p_subline_cd
               AND c.iss_cd     = NVL(p_iss_cd, c.iss_cd)  
               AND c.issue_yy   = NVL(p_issue_yy,   c.issue_yy)  
               AND c.pol_seq_no = NVL(p_pol_seq_no, c.pol_seq_no)
               AND c.renew_no   = NVL(p_renew_no,   c.renew_no)  
        )
        LOOP
            v_list.line_cd        := i.line_cd;     
            v_list.subline_cd     := i.subline_cd;   
            v_list.iss_cd         := i.iss_cd;       
            v_list.issue_yy       := i.issue_yy;     
            v_list.pol_seq_no     := i.pol_seq_no;   
            v_list.renew_no       := i.renew_no;   
            v_list.ref_pol_no     := i.ref_pol_no;   
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   FUNCTION query_policy_list(
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        gipi_polbasic.iss_cd%TYPE,
        p_issue_yy      gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no      gipi_polbasic.renew_no%TYPE,
        p_due_sw        VARCHAR2 
   )
   RETURN policy_dummy_tab PIPELINED
   IS
        v_list policy_dummy_type;
   BEGIN
    FOR i IN (
            SELECT b.iss_cd, b.prem_seq_no, c.balance_amt_due collection_amt, c.inst_no, get_policy_no(a.policy_id) policy_no,
                    get_assd_name(assd_no) assd_name, currency_cd, currency_rt, pol_flag
              FROM gipi_polbasic a,
                   gipi_invoice b,
                   giac_aging_soa_details c,
                   gipi_installment d
             WHERE a.policy_id = b.policy_id
               AND b.prem_seq_no = c.prem_seq_no
               AND b.iss_cd = c.iss_cd
               AND a.pol_flag <> '5'
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd = p_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
               AND c.iss_cd = d.iss_cd
               AND c.prem_seq_no = d.prem_seq_no
               AND c.inst_no = d.inst_no
               AND d.due_date <= DECODE (p_due_sw, 'N', SYSDATE, d.due_date)
               AND balance_amt_due <> 0
    )
    LOOP
        v_list.iss_cd           := i.iss_cd;     
        v_list.prem_seq_no      := i.prem_seq_no;   
        v_list.inst_no          := i.inst_no;       
        v_list.collection_amt   := i.collection_amt;     
        v_list.currency_cd      := i.currency_cd;   
        v_list.policy_no        := i.policy_no;    
        v_list.assd_name        := i.assd_name; 
        v_list.pol_flag         := i.pol_flag;
        
        BEGIN
           SELECT currency_rt, currency_desc
             INTO v_list.currency_rt, v_list.currency_desc
             FROM giis_currency
            WHERE main_currency_cd = i.currency_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_list.currency_rt := 1;
            v_list.currency_desc := '';
        END;    
        
        PIPE ROW(v_list);
    END LOOP;    
    RETURN;               
   END;
   
   
   PROCEDURE post_forms_commit (
        p_gacc_tran_id giac_pdc_payts.gacc_tran_id%TYPE,
        p_fund_cd      VARCHAR2,
        p_branch_cd    VARCHAR2,
        p_user_id      VARCHAR2
   )
   IS
        v_module_id     giac_modules.module_id%TYPE;
        v_gen_type      giac_modules.generation_type%TYPE; 
        v_debit_amt     giac_acct_entries.debit_amt%TYPE;
        v_credit_amt    giac_acct_entries.credit_amt%TYPE;     
        loc_flag	    giac_acctrans.tran_flag%TYPE;
   BEGIN
        BEGIN
            SELECT module_id, generation_type
              INTO v_module_id, v_gen_type
              FROM giac_modules
             WHERE module_name  = 'GIACS031';
          EXCEPTION
            WHEN no_data_found THEN
              raise_application_error (-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
        END;
        
        giacs031_pkg.aeg_delete_acct_entries(p_gacc_tran_id, v_gen_type);
        commit;
        global_fund_cd      := p_fund_cd;  
        global_branch_cd    := p_branch_cd;
        global_gacc_tran_id := p_gacc_tran_id;
        global_user_id      := p_user_id;
        
        FOR i IN(
            SELECT SUM(NVL(collection_amt,0)) collection_amt
              FROM giac_pdc_payts
             WHERE gacc_tran_id = p_gacc_tran_id
        )
        LOOP
            IF I.collection_amt != 0 THEN
                giacs031_pkg.aeg_create_acct_entries(NVL(i.collection_amt,0), v_gen_type, v_module_id);
            END IF;
        END LOOP;
        
        
   END; 
   
   
   PROCEDURE aeg_delete_acct_entries(
        p_gacc_tran_id      giac_pdc_payts.gacc_tran_id%TYPE,
        p_generation_type   giac_modules.generation_type%TYPE
   )
   IS
   BEGIN
   
        FOR i IN(
            SELECT gacc_tran_id, generation_type
              FROM giac_acct_entries
             WHERE gacc_tran_id    = p_gacc_tran_id
               AND generation_type = p_generation_type
        )
       LOOP
            DELETE FROM giac_acct_entries
                  WHERE gacc_tran_id = p_gacc_tran_id
                    AND generation_type = p_generation_type;
        END LOOP;
   END;
   
   PROCEDURE aeg_create_acct_entries(
        p_collection_amt    giac_bank_collns.collection_amt%TYPE,
        p_gen_type          giac_acct_entries.generation_type%TYPE,
        p_module_id         giac_modules.module_id%TYPE
   )
   IS
        ws_gl_acct_category              giac_acct_entries.gl_acct_category%TYPE;
        ws_gl_control_acct               giac_acct_entries.gl_control_acct%TYPE;
        ws_gl_sub_acct_1                 giac_acct_entries.gl_sub_acct_1%TYPE;
        ws_gl_sub_acct_2                 giac_acct_entries.gl_sub_acct_2%TYPE;
        ws_gl_sub_acct_3                 giac_acct_entries.gl_sub_acct_3%TYPE;
        ws_gl_sub_acct_4                 giac_acct_entries.gl_sub_acct_4%TYPE;
        ws_gl_sub_acct_5                 giac_acct_entries.gl_sub_acct_5%TYPE;
        ws_gl_sub_acct_6                 giac_acct_entries.gl_sub_acct_6%TYPE;
        ws_gl_sub_acct_7                 giac_acct_entries.gl_sub_acct_7%TYPE;

        ws_pol_type_tag                  giac_module_entries.pol_type_tag%TYPE;
        ws_intm_type_level               giac_module_entries.intm_type_level%TYPE;
        ws_old_new_acct_level            giac_module_entries.old_new_acct_level%TYPE;
        ws_line_dep_level                giac_module_entries.line_dependency_level%TYPE;
        ws_dr_cr_tag                     giac_module_entries.dr_cr_tag%TYPE;
        ws_acct_intm_cd                  giis_intm_type.acct_intm_cd%TYPE;
        ws_line_cd                       giis_line.line_cd%typE;
        ws_iss_cd                        gipi_polbasic.iss_cd%TYPE;
        ws_old_acct_cd                   giac_acct_entries.gl_sub_acct_2%TYPE;
        ws_new_acct_cd                   giac_acct_entries.gl_sub_acct_2%TYPE;
        pt_gl_sub_acct_1                 giac_acct_entries.gl_sub_acct_1%TYPE;
        pt_gl_sub_acct_2                 giac_acct_entries.gl_sub_acct_2%TYPE;
        pt_gl_sub_acct_3                 giac_acct_entries.gl_sub_acct_3%TYPE;
        pt_gl_sub_acct_4                 giac_acct_entries.gl_sub_acct_4%TYPE;
        pt_gl_sub_acct_5                 giac_acct_entries.gl_sub_acct_5%TYPE;
        pt_gl_sub_acct_6                 giac_acct_entries.gl_sub_acct_6%TYPE;
        pt_gl_sub_acct_7                 giac_acct_entries.gl_sub_acct_7%TYPE;

        ws_debit_amt                     giac_acct_entries.debit_amt%TYPE;
        ws_credit_amt                    giac_acct_entries.credit_amt%TYPE;  
        ws_gl_acct_id                    giac_acct_entries.gl_acct_id%TYPE;
        ws_sl_cd                    	 giac_acct_entries.sl_cd%TYPE;
   BEGIN
        BEGIN
            SELECT gl_acct_category, gl_control_acct,
                   gl_sub_acct_1   , gl_sub_acct_2  ,
                   gl_sub_acct_3   , gl_sub_acct_4  ,
                   gl_sub_acct_5   , gl_sub_acct_6  ,
                   gl_sub_acct_7   , pol_type_tag   ,
                   intm_type_level , old_new_acct_level,
                   dr_cr_tag       , line_dependency_level
              INTO ws_gl_acct_category, ws_gl_control_acct,
                   ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
                   ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
                   ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
                   ws_gl_sub_acct_7   , ws_pol_type_tag   ,
                   ws_intm_type_level , ws_old_new_acct_level,
                   ws_dr_cr_tag       , ws_line_dep_level
              FROM giac_module_entries
             WHERE module_id = p_module_id
               AND item_no   = 1
            FOR UPDATE of gl_sub_acct_1;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            raise_application_error (-20001, 'Geniisys Exception#E#No data found in giac_module_entries.');
        END;
        
        
        IF p_collection_amt > 0 THEN
             ws_debit_amt  := 0;
             ws_credit_amt := ABS(p_collection_amt);
        ELSE
             ws_debit_amt  := ABS(p_collection_amt);
             ws_credit_amt := 0;
        END IF;
        
        BEGIN

          SELECT DISTINCT(gl_acct_id)
            INTO ws_gl_acct_id
            FROM giac_chart_of_accts
           WHERE gl_acct_category  = ws_gl_acct_category
             AND gl_control_acct   = ws_gl_control_acct
             AND gl_sub_acct_1     = ws_gl_sub_acct_1
             AND gl_sub_acct_2     = ws_gl_sub_acct_2
             AND gl_sub_acct_3     = ws_gl_sub_acct_3
             AND gl_sub_acct_4     = ws_gl_sub_acct_4
             AND gl_sub_acct_5     = ws_gl_sub_acct_5
             AND gl_sub_acct_6     = ws_gl_sub_acct_6
             AND gl_sub_acct_7     = ws_gl_sub_acct_7;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            raise_application_error (-20001, 'Geniisys Exception#E#GL account code '||to_char(ws_gl_acct_category)
                        ||'-'||to_char(ws_gl_control_acct,'09') 
                        ||'-'||to_char(ws_gl_sub_acct_1,'09')
                        ||'-'||to_char(ws_gl_sub_acct_2,'09')
                        ||'-'||to_char(ws_gl_sub_acct_3,'09')
                        ||'-'||to_char(ws_gl_sub_acct_4,'09')
                        ||'-'||to_char(ws_gl_sub_acct_5,'09')
                        ||'-'||to_char(ws_gl_sub_acct_6,'09')
                        ||'-'||to_char(ws_gl_sub_acct_7,'09')
                        ||' does not exist in Chart of Accounts (Giac_Acctrans). ');
        END;
        
        BEGIN
            SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                   gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                   gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, gl_acct_id
              INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                   ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                   ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7, ws_gl_acct_id
              FROM giac_chart_of_accts
             WHERE gl_acct_id = ws_gl_acct_id;

        EXCEPTION
           WHEN no_data_found THEN
             raise_application_error (-20001, 'Geniisys Exception#E#GL account code '||to_char(ws_gl_acct_category)
                        ||'-'||to_char(ws_gl_control_acct,'09') 
                        ||'-'||to_char(ws_gl_sub_acct_1,'09')
                        ||'-'||to_char(ws_gl_sub_acct_2,'09')
                        ||'-'||to_char(ws_gl_sub_acct_3,'09')
                        ||'-'||to_char(ws_gl_sub_acct_4,'09')
                        ||'-'||to_char(ws_gl_sub_acct_5,'09')
                        ||'-'||to_char(ws_gl_sub_acct_6,'09')
                        ||'-'||to_char(ws_gl_sub_acct_7,'09')
                        ||' does not exist in Chart of Accounts (Giac_Acctrans). ');
        END;
        
        giacs031_pkg.aeg_insert_update_acct_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                  p_gen_type  , ws_gl_acct_id   ,        
                                  ws_debit_amt       , ws_credit_amt);
        
   END;
   
   PROCEDURE aeg_insert_update_acct_entries(
        p_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE,
        p_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE,
        p_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE,
        p_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE,
        p_generation_type   giac_acct_entries.generation_type%TYPE,
        p_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
        p_debit_amt         giac_acct_entries.debit_amt%TYPE,
        p_credit_amt        giac_acct_entries.credit_amt%TYPE
   )
   IS
        v_acct_entry_id  giac_acct_entries.ACCT_ENTRY_ID%TYPE;
        v_count		    NUMBER;  
   BEGIN
        SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
          INTO v_acct_entry_id
          FROM giac_acct_entries
         WHERE gacc_gibr_branch_cd  = global_fund_cd     
           AND gacc_gfun_fund_cd    = global_branch_cd   
           AND gacc_tran_id         = global_gacc_tran_id
           AND generation_type      = p_generation_type
           AND gl_acct_id           = p_gl_acct_id;
           
           BEGIN

                SELECT NVL(count(*),0)
                  INTO v_count
                  FROM giac_acct_entries
                 WHERE gacc_gibr_branch_cd = global_fund_cd
                   AND gacc_gfun_fund_cd   = global_branch_cd   
                   AND gacc_tran_id        = global_gacc_tran_id
                   AND generation_type     = p_generation_type
                   AND gl_acct_category  = p_gl_acct_category  
                   AND gl_control_acct   = p_gl_control_acct   
                   AND gl_sub_acct_1     = p_gl_sub_acct_1     
                   AND gl_sub_acct_2     = p_gl_sub_acct_2     
                   AND gl_sub_acct_3     = p_gl_sub_acct_2     
                   AND gl_sub_acct_4     = p_gl_sub_acct_2     
                   AND gl_sub_acct_5     = p_gl_sub_acct_2     
                   AND gl_sub_acct_6     = p_gl_sub_acct_2     
                   AND gl_sub_acct_7     = p_gl_sub_acct_2     
                   AND gl_acct_id        = p_gl_acct_id;

           EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_count :=0;
           END;
           
           IF NVL(v_count,0) = 0 THEN
                v_acct_entry_id := NVL(v_acct_entry_id,0) + 1;
                
                INSERT INTO giac_acct_entries
                            (gacc_tran_id, gacc_gfun_fund_cd,
                             gacc_gibr_branch_cd, acct_entry_id,
                             gl_acct_id, gl_acct_category, gl_control_acct,
                             gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                             gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                             gl_sub_acct_7, debit_amt, credit_amt,
                             generation_type, user_id, last_update
                            )
                     VALUES (global_gacc_tran_id, global_fund_cd,
                             global_branch_cd, v_acct_entry_id,
                             p_gl_acct_id, p_gl_acct_category, p_gl_control_acct,
                             p_gl_sub_acct_1, p_gl_sub_acct_2, p_gl_sub_acct_3,
                             p_gl_sub_acct_4, p_gl_sub_acct_5, p_gl_sub_acct_6,
                             p_gl_sub_acct_7, p_debit_amt, p_credit_amt,
                             p_generation_type, global_user_id, SYSDATE
                            );
                            
           ELSE
            UPDATE giac_acct_entries
               SET debit_amt = debit_amt + p_debit_amt,
                   credit_amt = credit_amt + p_credit_amt
             WHERE generation_type = p_generation_type
               AND gl_acct_id = p_gl_acct_id
               AND gacc_gibr_branch_cd = global_branch_cd
               AND gacc_gfun_fund_cd = global_fund_cd
               AND gacc_tran_id = global_gacc_tran_id;
               
           END IF; 
   END;
END;
/


