CREATE OR REPLACE PACKAGE BODY CPI.giacs155_pkg
AS
   FUNCTION get_intm_lov
      RETURN intm_lov_tab PIPELINED
   IS
      v_list intm_lov_type;
   BEGIN
      FOR i IN (SELECT ref_intm_cd, intm_name, intm_no
                  FROM giis_intermediary)
      LOOP
         v_list.ref_intm_cd := i.ref_intm_cd;
         v_list.intm_name := i.intm_name;
         v_list.intm_no := i.intm_no;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_intm_lov;
   
   FUNCTION get_fund_lov (
      p_user_id     VARCHAR2,
      p_intm_no     VARCHAR2
   )
      RETURN fund_lov_tab PIPELINED
   IS
      v_list fund_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.fund_cd, b.fund_desc
                  FROM giac_comm_v a, giis_funds b
                 WHERE a.fund_cd = b.fund_cd
                   AND a.intm_no = p_intm_no
                   AND check_user_per_iss_cd_acctg2(NULL, a.branch_cd, 'GIACS155', p_user_id) = 1)
      LOOP
         v_list.fund_cd := i.fund_cd;
         v_list.fund_desc := i.fund_desc;
         PIPE ROW(v_list);
      END LOOP;           
   END get_fund_lov;
   
   FUNCTION get_branch_lov (
      p_user_id     VARCHAR2,
      p_intm_no     VARCHAR2,
      p_fund_cd     VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS   
      v_list branch_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM giac_comm_v
                 WHERE intm_no = p_intm_no 
                   AND fund_cd = p_fund_cd
                   AND check_user_per_iss_cd_acctg2(NULL, branch_cd, 'GIACS155', p_user_id) = 1)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         
         PIPE ROW(v_list);
      END LOOP;    
   END get_branch_lov;
   
   FUNCTION populate_comm_voucher (
      p_user_id         VARCHAR2,
      p_intm_no         VARCHAR2,
      p_fund_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_prem_seq_no     NUMBER, -- marco - SR-5745 - 11.07.2016
      p_cv_pref         VARCHAR2,
      p_cv_no           VARCHAR2,
      p_cv_date         VARCHAR2,
      p_policy_no       VARCHAR2,
      p_actual_comm     VARCHAR2,
      p_comm_payable    VARCHAR2,
      p_comm_paid       VARCHAR2,
      p_net_due         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN comm_voucher_tab PIPELINED
   IS
      v_list comm_voucher_type;
      v_max_cv_no NUMBER := 0;
      v_no_prem_payt VARCHAR2(1);
      v_override_tag giac_parameters.param_value_v%TYPE :=  GIACP.v('COMM_VOUCHER_OVERRIDE_TAG');
      
      -- marco - SR-5745 - 11.07.2016
      TYPE cur_type IS REF CURSOR;
      c                 cur_type;
      v_sql             VARCHAR2(30000);
      v_table           VARCHAR2(100);
      v_cv_no_dt		VARCHAR2(30); --Deo [01.17.2017]: SR-23541
   BEGIN
      IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
        v_table := 'giac_comm_voucher_v3';
      ELSE
        v_table := 'giac_comm_voucher_v'; 
      END IF;
   
      --IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
      /* Deo [01.17.2017]: comment out codes below (SR-23541)
      ** the parentsql section encounters ORA-00600: internal error code, arguments: [qctcte1], [0],... in 10g
      ** query for cv no/date will not retrieve the max cv no
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (SELECT ROWNUM rownum_, innersql.*,
                                   SUM(innersql.actual_comm) OVER () tot_actual_comm,
                                   SUM(innersql.comm_payable) OVER () tot_comm_payable,
                                   SUM(innersql.comm_paid) OVER () tot_comm_paid,
                                   SUM(innersql.net_due) OVER () tot_net_due
                              FROM (SELECT parentsql.* , (parentsql.comm_payable - parentsql.comm_paid) net_due
                                      FROM (SELECT a.iss_cd, a.prem_seq_no, a.policy_id, a.actual_comm, a.comm_payable,
                                                   a.wtax_amt, a.prem_amt, a.comm_amt, a.input_vat, b.pol_flag,
                                                   b.line_cd || ''-'' || b.subline_cd || ''-'' || b.iss_cd || ''-'' || LTRIM (TO_CHAR (b.issue_yy, ''09'')) || ''-'' || 
                                                   LTRIM (TO_CHAR (b.pol_seq_no, ''0999999'')) || ''-'' || LTRIM (TO_CHAR (b.renew_no, ''09''))
                                                   || DECODE (NVL (b.endt_seq_no, 0), 0, '''', '' / '' || b.endt_iss_cd || ''-'' || LTRIM (TO_CHAR (b.endt_yy, ''09'')) || ''-'' || 
                                                   LTRIM (TO_CHAR (b.endt_seq_no, ''0999999''))) policy_no,
                                                   (SELECT ROUND(NVL(SUM(NVL(x.comm_amt,0) - NVL(x.wtax_amt,0) + NVL(x.input_vat_amt,0)), 0),2)
                                                      FROM giac_comm_payts x,
                                                           giac_acctrans y
                                                     WHERE NOT EXISTS(SELECT ''X''
                                                                        FROM giac_reversals c,
                                                                             giac_acctrans  d
                                                                       WHERE c.reversing_tran_id = d.tran_id
                                                                         AND d.tran_flag != ''D''
                                                                         AND c.gacc_tran_id = x.gacc_tran_id)
                                                       AND x.gacc_tran_id = y.tran_id
                                                       AND y.tran_flag != ''D''
                                                       AND x.prem_seq_no = a.prem_seq_no
                                                       AND x.iss_cd = a.iss_cd
                                                       AND x.intm_no = a.intm_no
                                                       AND x.gacc_tran_id >= 0) comm_paid,
                                                       (SELECT DISTINCT e.cv_pref
                                                          FROM giac_comm_voucher_ext e
                                                         WHERE e.intm_no = ' || NVL(p_intm_no, 0) ||
                                                         ' AND e.iss_cd = ''' || p_branch_cd || '''' ||
                                                         ' AND e.prem_seq_no = a.prem_seq_no    
                                                           AND e.prem_amt = a.prem_amt
                                                           AND e.commission_amt = a.comm_amt
                                                           AND e.wholding_tax = a.wtax_amt
                                                           AND nvl(e.input_vat,0) = nvl(a.input_vat,0)
                                                           AND e.advances = (SELECT ROUND(NVL(SUM(NVL(x.comm_amt,0) - NVL(x.wtax_amt,0) + NVL(x.input_vat_amt,0)), 0),2)
                                                                              FROM giac_comm_payts x,
                                                                                   giac_acctrans y
                                                                             WHERE NOT EXISTS(SELECT ''X''
                                                                                                FROM giac_reversals c,
                                                                                                     giac_acctrans  d
                                                                                               WHERE c.reversing_tran_id = d.tran_id
                                                                                                 AND d.tran_flag != ''D''
                                                                                                 AND c.gacc_tran_id = x.gacc_tran_id)
                                                                               AND x.gacc_tran_id = y.tran_id
                                                                               AND y.tran_flag != ''D''
                                                                               AND x.prem_seq_no = a.prem_seq_no
                                                                               AND x.iss_cd = a.iss_cd
                                                                               AND x.intm_no = a.intm_no
                                                                               AND x.gacc_tran_id >= 0)
                                                           AND e.print_tag = ''P''
                                                           AND ROWNUM = 1
                                                         GROUP BY e.cv_pref, e.cv_no, e.cv_date
                                                        HAVING e.cv_no = MAX(e.cv_no)) cv_pref,
                                                       (SELECT DISTINCT e.cv_no
                                                          FROM giac_comm_voucher_ext e
                                                         WHERE e.intm_no = ' || NVL(p_intm_no, 0) ||
                                                         ' AND e.iss_cd = ''' || p_branch_cd || '''' ||
                                                         ' AND e.prem_seq_no = a.prem_seq_no    
                                                           AND e.prem_amt = a.prem_amt
                                                           AND e.commission_amt = a.comm_amt
                                                           AND e.wholding_tax = a.wtax_amt
                                                           AND nvl(e.input_vat,0) = nvl(a.input_vat,0)
                                                           AND e.advances = (SELECT ROUND(NVL(SUM(NVL(x.comm_amt,0) - NVL(x.wtax_amt,0) + NVL(x.input_vat_amt,0)), 0),2)
                                                                              FROM giac_comm_payts x,
                                                                                   giac_acctrans y
                                                                             WHERE NOT EXISTS(SELECT ''X''
                                                                                                FROM giac_reversals c,
                                                                                                     giac_acctrans  d
                                                                                               WHERE c.reversing_tran_id = d.tran_id
                                                                                                 AND d.tran_flag != ''D''
                                                                                                 AND c.gacc_tran_id = x.gacc_tran_id)
                                                                               AND x.gacc_tran_id = y.tran_id
                                                                               AND y.tran_flag != ''D''
                                                                               AND x.prem_seq_no = a.prem_seq_no
                                                                               AND x.iss_cd = a.iss_cd
                                                                               AND x.intm_no = a.intm_no
                                                                               AND x.gacc_tran_id >= 0)
                                                           AND e.print_tag = ''P''
                                                           AND ROWNUM = 1
                                                         GROUP BY e.cv_pref, e.cv_no, e.cv_date
                                                        HAVING e.cv_no = MAX(e.cv_no)) cv_no,
                                                        (SELECT DISTINCT e.cv_date
                                                          FROM giac_comm_voucher_ext e
                                                         WHERE e.intm_no = ' || NVL(p_intm_no, 0) ||
                                                         ' AND e.iss_cd = ''' || p_branch_cd || '''' ||
                                                         ' AND e.prem_seq_no = a.prem_seq_no    
                                                           AND e.prem_amt = a.prem_amt
                                                           AND e.commission_amt = a.comm_amt
                                                           AND e.wholding_tax = a.wtax_amt
                                                           AND nvl(e.input_vat,0) = nvl(a.input_vat,0)
                                                           AND e.advances = (SELECT ROUND(NVL(SUM(NVL(x.comm_amt,0) - NVL(x.wtax_amt,0) + NVL(x.input_vat_amt,0)), 0),2)
                                                                              FROM giac_comm_payts x,
                                                                                   giac_acctrans y
                                                                             WHERE NOT EXISTS(SELECT ''X''
                                                                                                FROM giac_reversals c,
                                                                                                     giac_acctrans  d
                                                                                               WHERE c.reversing_tran_id = d.tran_id
                                                                                                 AND d.tran_flag != ''D''
                                                                                                 AND c.gacc_tran_id = x.gacc_tran_id)
                                                                               AND x.gacc_tran_id = y.tran_id
                                                                               AND y.tran_flag != ''D''
                                                                               AND x.prem_seq_no = a.prem_seq_no
                                                                               AND x.iss_cd = a.iss_cd
                                                                               AND x.intm_no = a.intm_no
                                                                               AND x.gacc_tran_id >= 0)
                                                           AND e.print_tag = ''P''
                                                           AND ROWNUM = 1
                                                         GROUP BY e.cv_pref, e.cv_no, e.cv_date
                                                        HAVING e.cv_no = MAX(e.cv_no)) cv_date
                                              FROM ' || v_table || ' a,
                                                   gipi_polbasic b
                                             WHERE a.intm_no = :p_intm_no
                                               AND a.iss_cd = :p_branch_cd
                                               AND a.policy_id = b.policy_id
                                               AND b.pol_flag <> ''5'') parentsql
                                     WHERE (ROUND(parentsql.comm_payable,2) <> parentsql.comm_paid '; */
                                     
      --Deo [01.17.2017]: add start (SR-23541)
      v_sql :=
           'SELECT mainsql.*
              FROM (SELECT COUNT (1) OVER () count_, outersql.*
                      FROM (SELECT ROWNUM rownum_, innersql.*,
                                   SUM (innersql.actual_comm) OVER () tot_actual_comm,
                                   SUM (innersql.comm_payable) OVER () tot_comm_payable,
                                   SUM (innersql.comm_paid) OVER () tot_comm_paid,
                                   SUM (innersql.net_due) OVER () tot_net_due
                              FROM (SELECT parentsql.*,
                                           (parentsql.comm_payable - parentsql.comm_paid
                                           ) net_due
                                      FROM (SELECT a.iss_cd, a.prem_seq_no, a.policy_id, a.actual_comm,
                                                   a.comm_payable, a.wtax_amt, a.prem_amt, a.comm_amt,
                                                   a.input_vat, b.pol_flag,
                                                   b.line_cd || ''-'' || b.subline_cd || ''-'' || b.iss_cd
                                                   || ''-'' || LTRIM (TO_CHAR (b.issue_yy, ''09''))
                                                   || ''-'' || LTRIM (TO_CHAR (b.pol_seq_no, ''0999999''))
                                                   || ''-'' || LTRIM (TO_CHAR (b.renew_no, ''09''))
                                                   || DECODE (NVL (b.endt_seq_no, 0), 0, '''', '' / ''
                                                        || b.endt_iss_cd || ''-''
                                                        || LTRIM (TO_CHAR (b.endt_yy,''09'')) || ''-''
                                                        || LTRIM (TO_CHAR (b.endt_seq_no, ''0999999''))
                                                       ) policy_no,
                                                   (SELECT ROUND (NVL (SUM (NVL (x.comm_amt, 0 )
                                                                          - NVL (x.wtax_amt, 0 )
                                                                          + NVL (x.input_vat_amt, 0)
                                                                      ), 0), 2)
                                                      FROM giac_comm_payts x,
                                                           giac_acctrans y
                                                     WHERE NOT EXISTS (
                                                              SELECT ''X''
                                                                FROM giac_reversals c,
                                                                     giac_acctrans d
                                                               WHERE c.reversing_tran_id = d.tran_id
                                                                 AND d.tran_flag != ''D''
                                                                 AND c.gacc_tran_id = x.gacc_tran_id)
                                                       AND x.gacc_tran_id = y.tran_id
                                                       AND y.tran_flag != ''D''
                                                       AND x.prem_seq_no = a.prem_seq_no
                                                       AND x.iss_cd = a.iss_cd
                                                       AND x.intm_no = a.intm_no
                                                       AND x.gacc_tran_id >= 0) comm_paid,
                                                   (SELECT DISTINCT e.cv_pref || '','' || e.cv_no
                                                           || '','' || TO_CHAR (e.cv_date, ''MM-DD-YYYY'')
                                                      FROM giac_comm_voucher_ext e
                                                     WHERE e.intm_no = :p_intm_no
                                                       AND e.iss_cd = :p_branch_cd
                                                       AND e.prem_seq_no = a.prem_seq_no
                                                       AND e.prem_amt = a.prem_amt
                                                       AND e.commission_amt = a.comm_amt
                                                       AND e.wholding_tax = a.wtax_amt
                                                       AND NVL (e.input_vat, 0) = NVL (a.input_vat, 0)
                                                       AND e.advances = ROUND (get_comm_paid
                                                                          (a.intm_no,
                                                                           a.iss_cd,
                                                                           a.prem_seq_no
                                                                          ), 2)
                                                       AND e.print_tag = ''P''
                                                       AND e.cv_no =
                                                              (SELECT MAX (cv_no)
                                                                 FROM giac_comm_voucher_ext f
                                                                WHERE f.intm_no = e.intm_no
                                                                  AND f.iss_cd = e.iss_cd
                                                                  AND f.prem_seq_no = e.prem_seq_no
                                                                  AND f.prem_amt = e.prem_amt
                                                                  AND f.commission_amt = e.commission_amt
                                                                  AND f.wholding_tax = e.wholding_tax
                                                                  AND NVL (f.input_vat, 0) = 
                                                                                     NVL (e.input_vat, 0)
                                                                  AND f.advances = e.advances)) cv_no_dt
                                              FROM ' || v_table || ' a,
                                                    gipi_polbasic b
                                             WHERE a.intm_no = :p_intm_no
                                               AND a.iss_cd = :p_branch_cd
                                               AND a.policy_id = b.policy_id
                                               AND b.pol_flag <> ''5'') parentsql
                             WHERE (ROUND (parentsql.comm_payable, 2) <> parentsql.comm_paid';
                             --Deo [01.17.2017]: add ends (SR-23541)

                                     IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
                                        v_sql := v_sql || ' OR parentsql.prem_amt = 0) ';
                                     ELSE
                                        v_sql := v_sql || ') ';
                                     END IF;
                                     
                                     IF p_prem_seq_no IS NOT NULL THEN
                                        v_sql := v_sql || ' AND parentsql.prem_seq_no = ' || p_prem_seq_no;
                                     END IF;
                                     
                                     IF p_policy_no IS NOT NULL THEN
                                        v_sql := v_sql || ' AND UPPER(parentsql.policy_no) LIKE UPPER(''' || p_policy_no || ''') ';
                                     END IF;
                                     
                                     IF p_actual_comm IS NOT NULL THEN
                                        v_sql := v_sql || ' AND parentsql.actual_comm = ' || p_actual_comm;
                                     END IF;
                                     
                                     IF p_comm_payable IS NOT NULL THEN
                                        v_sql := v_sql || ' AND parentsql.comm_payable = ' || p_comm_payable;
                                     END IF;

                                     IF p_comm_paid IS NOT NULL THEN
                                        v_sql := v_sql || ' AND parentsql.comm_paid = ' || p_comm_paid;
                                     END IF;
                                     
                                     IF p_net_due IS NOT NULL THEN
                                        v_sql := v_sql || ' AND parentsql.comm_payable - parentsql.comm_paid = ' || p_net_due;
                                     END IF;
                                       
                                     /*IF p_cv_pref IS NOT NULL THEN
                                        v_sql := v_sql || ' AND UPPER(cv_pref) LIKE UPPER(''' || p_cv_pref || ''') ';
                                     END IF;
                                     
                                     IF p_cv_no IS NOT NULL THEN
                                        v_sql := v_sql || ' AND parentsql.cv_no = ' || p_cv_no;
                                     END IF;  
                                     
                                     IF p_cv_date IS NOT NULL THEN
                                        v_sql := v_sql || ' AND cv_date = TO_DATE(''' || p_cv_date || ''',''MM-DD-YYYY'') ';
                                     END IF;*/ --Deo [01.17.2017]: comment out (SR-23541)
                                       
		/* benjo 03.09.2017 SR-23987 replaced parentsql.cv_number -> parentsql.cv_no_dt */
        --Deo [01.17.2017]: add start (SR-23541)
        IF p_cv_pref IS NOT NULL
        THEN
           v_sql := v_sql || ' AND UPPER (SUBSTR (parentsql.cv_no_dt, 1, '
                    || 'INSTR (parentsql.cv_no_dt, '','', -1, 2) - 1 )) '
                    || 'LIKE UPPER (''' || p_cv_pref || ''') ';
        END IF;
                                     
        IF p_cv_no IS NOT NULL
        THEN
           v_sql := v_sql || ' AND SUBSTR (parentsql.cv_no_dt, INSTR ( '
                    || 'parentsql.cv_no_dt, '','', -1, 2) + 1, INSTR ( '
                    || 'parentsql.cv_no_dt, '','', -1, 1) - INSTR ( '
                    || 'parentsql.cv_no_dt, '','', -1, 2) - 1) = ' || p_cv_no;
        END IF;
        
        IF p_cv_date IS NOT NULL
        THEN
           v_sql := v_sql || ' AND SUBSTR (parentsql.cv_no_dt, INSTR ('
                    || 'parentsql.cv_no_dt, '','', -1, 1) + 1) = '''
                    || p_cv_date || '''';
        END IF;
        --Deo [01.17.2017]: add ends (SR-23541)
        /* end SR-23987*/

        IF p_order_by IS NOT NULL THEN
            IF p_order_by = 'issCd premSeqNo' THEN
                v_sql := v_sql || ' ORDER BY prem_seq_no ';
            ELSIF p_order_by = 'cvPref cvNo cvDate' THEN
                --v_sql := v_sql || ' ORDER BY cv_pref '; --Deo [01.17.2017]: comment out (SR-23541)
                v_sql := v_sql || ' ORDER BY cv_no_dt '; --Deo [01.17.2017]: SR-23541
            ELSIF p_order_by = 'policyNo' THEN
                v_sql := v_sql || ' ORDER BY policy_no ';
            ELSIF p_order_by = 'actualComm' THEN
                v_sql := v_sql || ' ORDER BY actual_comm ';
            ELSIF p_order_by = 'commPayable' THEN
                v_sql := v_sql || ' ORDER BY comm_payable ';
            ELSIF p_order_by = 'commPaid' THEN
                v_sql := v_sql || ' ORDER BY comm_paid ';
            ELSIF p_order_by = 'netDue' THEN
                v_sql := v_sql || ' ORDER BY net_due ';
            END IF;
            
            IF p_asc_desc_flag IS NOT NULL THEN
               v_sql := v_sql || p_asc_desc_flag;
            ELSE
               v_sql := v_sql || ' ASC';
            END IF;
        END IF;                                       
                                             
        v_sql := v_sql || ') innersql';
                                       
        v_sql := v_sql || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                    
        OPEN c FOR v_sql USING p_intm_no, p_branch_cd, p_intm_no, p_branch_cd; --Deo [01.17.2017]: another p_intm_no, p_branch_cd (SR-23541)
        LOOP
            FETCH c INTO
            v_list.count_,
            v_list.rownum_,
            v_list.iss_cd,
            v_list.prem_seq_no,
            v_list.policy_id,
            v_list.actual_comm,
            v_list.comm_payable,
            v_list.wtax_amt,
            v_list.prem_amt,
            v_list.comm_amt,
            v_list.input_vat,
            v_list.pol_flag,
            v_list.policy_no,
            v_list.comm_paid,
            /*v_list.cv_pref,
            v_list.cv_no,
            v_list.cv_date,*/ --Deo [01.17.2017]: comment out (SR-23541)
            v_cv_no_dt, --Deo [01.17.2017]: SR-23541
            v_list.net_due,
            v_list.tot_actual_comm,
            v_list.tot_comm_payable,
            v_list.tot_comm_paid,
            v_list.tot_net_due;            
			--Deo [01.17.2017]: add start (SR-23541)
            v_list.cv_pref := SUBSTR (v_cv_no_dt, 1, INSTR (v_cv_no_dt, ',', -1, 2) - 1);
            v_list.cv_no := SUBSTR (v_cv_no_dt, INSTR (v_cv_no_dt, ',', -1, 2) + 1,
                                    INSTR (v_cv_no_dt, ',', -1, 1) - INSTR (v_cv_no_dt, ',', -1, 2) - 1);
            v_list.cv_date := TO_DATE (SUBSTR (v_cv_no_dt, INSTR (v_cv_no_dt, ',', -1, 1) + 1), 'MM-DD-YYYY');
            --Deo [01.17.2017]: add ends (SR-23541)

            BEGIN --Deo [01.12.2017]: add start (SR-23698)
               SELECT DISTINCT assd_no
                          INTO v_list.assd_no
                          FROM giis_assured
                         WHERE assd_no IN (
                                     SELECT b.assd_no
                                       FROM gipi_polbasic a, gipi_parlist b
                                      WHERE policy_id = v_list.policy_id
                                        AND a.par_id = b.par_id);
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_list.assd_no := NULL;
            END; --Deo [01.12.2017]: add ends (SR-23698)
            
            EXIT WHEN c%NOTFOUND;
            
            v_list.override_tag := v_override_tag;
            
            PIPE ROW (v_list);
        END LOOP;
      
        CLOSE c;
      --END IF;
   
      /* marco - SR-5745 - 11.07.2016 - replaced codes for optimization
      IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
         FOR i IN (SELECT *
                     FROM giac_comm_voucher_v3
                    WHERE (ROUND(comm_payable,2) <> ROUND(get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                      OR prem_amt = 0) --added by steven 09.29.2014
                      AND intm_no = p_intm_no
                      AND iss_cd = p_branch_cd)
         LOOP
            v_list.iss_cd := i.iss_cd;   
            v_list.prem_seq_no := i.prem_seq_no;
            v_list.policy_id := i.policy_id;
            v_list.policy_no := get_policy_no(i.policy_id);
            v_list.actual_comm := i.actual_comm;
            v_list.comm_payable := i.comm_payable;
            v_list.comm_paid := get_comm_paid(i.intm_no, i.iss_cd, i.prem_seq_no);
            v_list.net_due := v_list.comm_payable - v_list.comm_paid;
            v_list.input_vat := i.input_vat;
            v_list.wtax_amt := i.wtax_amt;
            v_list.prem_amt := i.prem_amt;
            v_list.comm_amt := i.comm_amt;
            v_list.override_tag := v_override_tag;
            
            BEGIN
               SELECT DISTINCT assd_no
                 INTO v_list.assd_no
                 FROM giis_assured
                WHERE assd_no IN (SELECT b.assd_no
                                FROM gipi_polbasic a, gipi_parlist b
                               WHERE policy_id = i.policy_id
                                 AND a.par_id=b.par_id);
            EXCEPTION WHEN OTHERS THEN
               v_list.assd_no := NULL;
            END;
            
            BEGIN
               SELECT pol_flag
                 INTO v_list.pol_flag
                 FROM gipi_polbasic
                WHERE policy_id = i.policy_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.pol_flag := NULL;     
            END;
            
            BEGIN
               SELECT MAX(cv_no)
                 INTO v_max_cv_no
                 FROM giac_comm_voucher_ext
                WHERE intm_no = p_intm_no
                  AND iss_cd = p_branch_cd
                  AND prem_seq_no = i.prem_seq_no    
    	            AND prem_amt = i.prem_amt
    	            AND commission_amt = i.comm_amt
    	            AND wholding_tax = i.wtax_amt
    	            AND nvl(input_vat,0) = nvl(i.input_vat,0)
    	            AND advances = v_list.comm_paid
    	            AND print_tag = 'P';
               
               BEGIN
                  SELECT DISTINCT cv_pref, cv_no, cv_date
                    INTO v_list.cv_pref, v_list.cv_no, v_list.cv_date
                    FROM giac_comm_voucher_ext
                   WHERE intm_no = p_intm_no
                     AND iss_cd = p_branch_cd
                     AND prem_seq_no = i.prem_seq_no    
                     AND prem_amt = i.prem_amt
                     AND commission_amt = i.comm_amt
                     AND wholding_tax = i.wtax_amt
                     AND nvl(input_vat,0) = nvl(i.input_vat,0)
                     AND advances = v_list.comm_paid
                     AND print_tag = 'P'
                     AND cv_no = v_max_cv_no
                     AND ROWNUM = 1;
                    
               END;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.cv_pref := NULL;
                  v_list.cv_no := NULL;
                  v_list.cv_date := NULL;                     
            END;
            
            PIPE ROW(v_list);
         END LOOP;
      ELSE
         FOR i IN (SELECT *
                     FROM giac_comm_voucher_v
                    WHERE ROUND(comm_payable,2) <> ROUND(get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                      AND intm_no = p_intm_no
                      AND iss_cd = p_branch_cd)
         LOOP
            v_list.iss_cd := i.iss_cd;   
            v_list.prem_seq_no := i.prem_seq_no;
            v_list.policy_id := i.policy_id;
            v_list.policy_no := get_policy_no(i.policy_id);
            v_list.actual_comm := i.actual_comm;
            v_list.comm_payable := i.comm_payable;
            v_list.comm_paid := get_comm_paid(i.intm_no, i.iss_cd, i.prem_seq_no);
            v_list.net_due := v_list.comm_payable - v_list.comm_paid;
            v_list.input_vat := i.input_vat;
            v_list.wtax_amt := i.wtax_amt;
            v_list.prem_amt := i.prem_amt;
            v_list.comm_amt := i.comm_amt;
            v_list.override_tag := v_override_tag;
            
            BEGIN
               SELECT DISTINCT assd_no
                 INTO v_list.assd_no
                 FROM giis_assured
                WHERE assd_no IN (SELECT b.assd_no
                                FROM gipi_polbasic a, gipi_parlist b
                               WHERE policy_id = i.policy_id
                                 AND a.par_id=b.par_id);
            EXCEPTION WHEN OTHERS THEN
               v_list.assd_no := NULL;
            END;
            
            BEGIN
               SELECT pol_flag
                 INTO v_list.pol_flag
                 FROM gipi_polbasic
                WHERE policy_id = i.policy_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.pol_flag := NULL;     
            END;
            
            BEGIN
               SELECT MAX(cv_no)
                 INTO v_max_cv_no
                 FROM giac_comm_voucher_ext
                WHERE intm_no = p_intm_no
                  AND iss_cd = p_branch_cd
                  AND prem_seq_no = i.prem_seq_no    
    	            AND prem_amt = i.prem_amt
    	            AND commission_amt = i.comm_amt
    	            AND wholding_tax = i.wtax_amt
    	            AND nvl(input_vat,0) = nvl(i.input_vat,0)
    	            AND advances = v_list.comm_paid
    	            AND print_tag = 'P';
               
               BEGIN
                  SELECT DISTINCT cv_pref, cv_no, cv_date
                    INTO v_list.cv_pref, v_list.cv_no, v_list.cv_date
                    FROM giac_comm_voucher_ext
                   WHERE intm_no = p_intm_no
                     AND iss_cd = p_branch_cd
                     AND prem_seq_no = i.prem_seq_no    
                     AND prem_amt = i.prem_amt
                     AND commission_amt = i.comm_amt
                     AND wholding_tax = i.wtax_amt
                     AND nvl(input_vat,0) = nvl(i.input_vat,0)
                     AND advances = v_list.comm_paid
                     AND print_tag = 'P'
                     AND cv_no = v_max_cv_no
                     AND ROWNUM = 1;
                    
               END;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.cv_pref := NULL;
                  v_list.cv_no := NULL;
                  v_list.cv_date := NULL;                     
            END;
            
            PIPE ROW(v_list);
         END LOOP;
      END IF; */
         
   END populate_comm_voucher;
   
   FUNCTION populate_comm_invoice (
      p_user_id     VARCHAR2,
      p_intm_no     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_prem_seq_no VARCHAR2,
      p_policy_id   VARCHAR2
   )
      RETURN comm_invoice_tab PIPELINED
   IS
      v_list comm_invoice_type;
   BEGIN
      FOR i IN ( SELECT * 
                   FROM gipi_comm_invoice      
                  WHERE intrmdry_intm_no = p_intm_no
                    AND iss_cd = p_iss_cd
                    AND iss_cd = DECODE(check_user_per_iss_cd_acctg2(null ,iss_cd, 'GIACS155', p_user_id),1,iss_cd,NULL)
                    AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.premium_amt := i.premium_amt;
         v_list.commission_amt := i.commission_amt;
         v_list.share_percentage := i.share_percentage;
         v_list.wholding_tax := i.wholding_tax;
         
         BEGIN
            SELECT DISTINCT assd_no, assd_name
             INTO v_list.assd_no, v_list.assd_name
             FROM giis_assured
            WHERE assd_no IN (SELECT b.assd_no
                                FROM gipi_polbasic a, gipi_parlist b
                               WHERE policy_id = p_policy_id
                                 AND a.par_id=b.par_id);
            EXCEPTION WHEN OTHERS THEN
               v_list.assd_no := NULL;
               v_list.assd_name := NULL;                        
         END;
         
         BEGIN
            SELECT input_vat_rate
              INTO v_list.input_vat_rate
              FROM giis_intermediary
             WHERE intm_no = i.intrmdry_intm_no;
             
            v_list.input_vat_rate := NVL(ROUND((v_list.input_vat_rate / 100)* i.commission_amt, 2),0);
             
         EXCEPTION WHEN OTHERS THEN
            v_list.input_vat_rate := NULL;    
         END;
         
         PIPE ROW(v_list);
      END LOOP;   
   END populate_comm_invoice;
   
   FUNCTION populate_comm_invoice_tg (
      p_user_id         VARCHAR2,
      p_intm_no         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_prem_seq_no     VARCHAR2
      
   )
      RETURN comm_invoice_tg_tab PIPELINED
   IS
      v_list comm_invoice_tg_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gipi_comm_inv_peril
                 WHERE intrmdry_intm_no = p_intm_no
                   AND iss_cd = p_iss_cd
                   AND iss_cd = DECODE(check_user_per_iss_cd_acctg2(null ,iss_cd, 'GIACS155', p_user_id),1,iss_cd,NULL)
                   AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_list.intrmdry_intm_no := i.intrmdry_intm_no;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.policy_id := i.policy_id;
         v_list.peril_cd := i.peril_cd;
         v_list.premium_amt := i.premium_amt;
         v_list.commission_rt := i.commission_rt;
         v_list.commission_amt := i.commission_amt;
         v_list.wholding_tax := i.wholding_tax;
         
         BEGIN
            SELECT a.peril_name
              INTO v_list.peril_name
              FROM giis_peril a, gipi_polbasic b
             WHERE a.line_cd = b.line_cd
               AND b.policy_id = i.policy_id
               AND a.peril_cd = i.peril_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.peril_name := NULL;       
         END;
         
         BEGIN
            SELECT input_vat_rate
              INTO v_list.input_vat_rate
              FROM giis_intermediary
             WHERE intm_no = p_intm_no;
             
            v_list.input_vat_rate := NVL(ROUND ((v_list.input_vat_rate / 100)* i.commission_amt,2),0);
             
         EXCEPTION WHEN OTHERS THEN
            v_list.input_vat_rate := NULL;    
         END;
         
         PIPE ROW(v_list);
      END LOOP;      
   END populate_comm_invoice_tg;
   
   FUNCTION populate_comm_payables (
      p_intm_no         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_prem_seq_no     VARCHAR2,
      p_policy_id       VARCHAR2
   )
      RETURN comm_payable_tab PIPELINED
   IS
      v_list comm_payable_type;
   BEGIN
      FOR i IN(SELECT a.intrmdry_intm_no, a.iss_cd, a.prem_seq_no,
                      NVL (a.premium_amt, 0) prem,
                      ROUND (SUM (((NVL (b.premium_amt, 0) / DECODE (a.premium_amt, 0, 1,NULL, 1, a.premium_amt)) * NVL (a.commission_amt, 0))), 2) comm,
                      ROUND (SUM ((  (  NVL (b.premium_amt, 0) / DECODE (a.premium_amt, 0, 1, NULL, 1, a.premium_amt)) * NVL (a.wholding_tax, 0))), 2) wtax,
                      ROUND (NVL (c.input_vat_rate, 0) * ROUND (SUM ((  (  NVL (b.premium_amt, 0) / DECODE (a.premium_amt, 0, 1, NULL, 1, a.premium_amt)) * NVL (a.commission_amt, 0))),2) / 100,2) vat,
                      NVL (SUM (b.tax_amt), 0) tax, NVL (SUM (b.collection_amt), 0) coll
                 FROM gipi_comm_invoice a,
                      giac_direct_prem_collns b,
                      giis_intermediary c,
                      giac_acctrans d
                WHERE 1 = 1
                  AND a.iss_cd = p_iss_cd
                  AND a.prem_seq_no = p_prem_seq_no
                  AND a.intrmdry_intm_no = p_intm_no
                  AND a.prem_seq_no = b.b140_prem_seq_no(+)
                  AND a.iss_cd = b.b140_iss_cd(+)
                  AND b.gacc_tran_id = d.tran_id(+)
                  AND a.intrmdry_intm_no = c.intm_no
                  AND d.tran_flag(+) != 'D'
             GROUP BY a.intrmdry_intm_no,
                      a.iss_cd,
                      a.prem_seq_no,
                      NVL (a.premium_amt, 0),
                      NVL (c.input_vat_rate, 0))
      LOOP
         v_list.collection_amt := i.coll;
         v_list.premium_amt := i.prem;
         v_list.tax_amt := i.tax;
         v_list.commission_amt := i.comm;
         v_list.wholding_tax := i.wtax;
         v_list.vat_amt := i.vat;
         v_list.net_amt := i.comm - i.wtax + i.vat;
         
         BEGIN
            SELECT DISTINCT assd_no, assd_name
             INTO v_list.assd_no, v_list.assd_name
             FROM giis_assured
            WHERE assd_no IN (SELECT b.assd_no
                                FROM gipi_polbasic a, gipi_parlist b
                               WHERE policy_id = p_policy_id
                                 AND a.par_id=b.par_id);
            EXCEPTION WHEN OTHERS THEN
               v_list.assd_no := NULL;
               v_list.assd_name := NULL;                        
         END;
      
         PIPE ROW(v_list);
      END LOOP;       
   END populate_comm_payables;
   
   FUNCTION populate_comm_payments (
      p_intm_no         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_prem_seq_no     VARCHAR2
   )
      RETURN comm_payments_tab PIPELINED
   IS
      v_list comm_payments_type;
      v_ref_intm_no giis_intermediary.ref_intm_cd%TYPE;
      v_ref_no VARCHAR2(50);
   BEGIN
      BEGIN
         SELECT ref_intm_cd
           INTO v_ref_intm_no
           FROM giis_intermediary
          WHERE intm_no = p_intm_no; 
      END;
      
      BEGIN
         FOR x IN (SELECT s.gacc_tran_id tran_id, s.comm_amt, s.input_vat_amt, s.wtax_amt
                     FROM giac_comm_payts s, giac_acctrans t
		            WHERE s.gacc_tran_id = t.tran_id
		              AND s.gacc_tran_id > 0
		              AND intm_no = p_intm_no
		              AND s.iss_cd = p_iss_cd
		              AND prem_seq_no = p_prem_seq_no 
		              AND tran_flag <> 'D'
 		              AND NOT EXISTS(SELECT c.gacc_tran_id
	                                   FROM giac_reversals c, giac_acctrans d
			                          WHERE c.reversing_tran_id = d.tran_id
			                            AND d.tran_flag        <> 'D'
			                            AND c.gacc_tran_id = s.gacc_tran_id))
         LOOP
            FOR c IN (SELECT a.tran_id, a.tran_date, a.tran_flag, a.tran_class, a.tran_class_no
		                FROM giac_acctrans a
		               WHERE a.tran_id = x.tran_id)
            LOOP
               	IF C.TRAN_CLASS = 'COL' THEN
				   BEGIN
                      SELECT or_pref_suf||'-'||TO_CHAR(or_no) 
					    INTO v_ref_no
					    FROM giac_order_of_payts
					   WHERE gacc_tran_id = c.tran_id;
                   END;
                ELSIF C.TRAN_CLASS = 'DV' THEN
				   BEGIN
				      SELECT dv_pref||'-'||TO_CHAR(dv_no)
					    INTO v_ref_no
					    FROM giac_disb_vouchers
					   WHERE gacc_tran_id = c.tran_id;
                   EXCEPTION WHEN NO_DATA_FOUND THEN 
				      SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no)
					    INTO v_ref_no 
					    FROM giac_payt_requests a, giac_payt_requests_dtl b
					   WHERE a.ref_id = b.gprq_ref_id
					     AND tran_id = c.tran_id;    
                   END;
                ELSIF c.tran_class = 'JV' THEN
				   v_ref_no := c.tran_class_no;          
                END IF;
                
                v_list.agent_no := v_ref_no;
                v_list.tran_date := c.tran_date;
                v_list.comm_amt := x.comm_amt;
                v_list.input_vat_amt := x.input_vat_amt;
                v_list.wtax_amt := x.wtax_amt;
                v_list.or_no := c.tran_class||' '||v_ref_no;
                
                PIPE ROW(v_list);    
            END LOOP;           
         END LOOP;                                  
      END;
   END populate_comm_payments;
   
   PROCEDURE update_comm_voucher_ext(
      p_fund_cd         giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no         giac_comm_voucher_ext.intm_no%TYPE,
      p_policy_no       giac_comm_voucher_ext.policy_no%TYPE,
      p_iss_cd          giac_comm_voucher_ext.iss_cd%TYPE,
      p_prem_seq_no     giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_comm_amt        giac_comm_voucher_ext.commission_amt%TYPE,
      p_wtax            giac_comm_voucher_ext.wholding_tax%TYPE,
      p_comm_paid       giac_comm_voucher_ext.advances%TYPE,
      p_assd_no         giac_comm_voucher_ext.assd_no%TYPE,
      p_prem_amt        giac_comm_voucher_ext.prem_amt%TYPE,
      p_input_vat       giac_comm_voucher_ext.input_vat%TYPE,
      p_user_id         VARCHAR2,
      p_cv_pref         giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no           giac_comm_voucher_ext.cv_no%TYPE
   )
   IS
      v_count NUMBER(10);
      v_max_cv_no giac_comm_voucher_ext.cv_no%TYPE;
   BEGIN
      
      IF p_cv_no IS NULL
      THEN
           SELECT COUNT(*), MAX(cv_no)
            INTO v_count, v_max_cv_no
            FROM giac_comm_voucher_ext
           WHERE fund_cd = p_fund_cd
             AND intm_no = p_intm_no
             AND policy_no = p_policy_no
             AND iss_cd = p_iss_cd
             AND prem_seq_no = p_prem_seq_no
             AND commission_amt = p_comm_amt
             AND wholding_tax = p_wtax
             AND advances = p_comm_paid
             AND assd_no = p_assd_no
             AND prem_amt = p_prem_amt
             AND NVL(input_vat,0) = NVL(p_input_vat,0);
             
         IF v_count > 0 THEN
            UPDATE giac_comm_voucher_ext
               SET include_tag = 'Y', user_id = p_user_id
             WHERE fund_cd = p_fund_cd
               AND intm_no = p_intm_no
               AND policy_no = p_policy_no
               AND iss_cd = p_iss_cd
               AND prem_seq_no = p_prem_seq_no  
               AND commission_amt = p_comm_amt
               AND wholding_tax = p_wtax
               AND advances = p_comm_paid
               AND assd_no = p_assd_no
               AND prem_amt = p_prem_amt
               AND NVL(input_vat,0) = NVL(p_input_vat,0)
               AND ROWNUM = 1
               AND NVL(cv_no,0) = NVL(v_max_cv_no,0);            
         ELSE
            INSERT INTO giac_comm_voucher_ext 
               (fund_cd, intm_no, policy_no, iss_cd, 
                prem_seq_no, cv_no, cv_pref, cv_date, 
                include_tag, commission_amt, wholding_tax, 
                advances, assd_no, prem_amt, input_vat, user_id)
            VALUES 
               (p_fund_cd, p_intm_no, p_policy_no, p_iss_cd, 
                p_prem_seq_no, NULL, NULL, NULL,
                'Y', p_comm_amt, p_wtax,
                p_comm_paid, p_assd_no, p_prem_amt, p_input_vat, p_user_id);
         END IF;                
      ELSE
        UPDATE giac_comm_voucher_ext
           SET include_tag = 'Y', user_id = p_user_id
         WHERE fund_cd = p_fund_cd
           AND intm_no = p_intm_no
           AND iss_cd = p_iss_cd
           AND print_tag = 'P'
           AND cv_no = p_cv_no
           AND cv_pref = p_cv_pref;       
      END IF;    
   END update_comm_voucher_ext;
   
   PROCEDURE update_override_hist (
      p_fund_cd         giac_commvouch_override_hist.fund_cd%TYPE,
      p_intm_no         giac_commvouch_override_hist.intm_no%TYPE,
      p_iss_cd          giac_commvouch_override_hist.iss_cd%TYPE,
      p_prem_seq_no     giac_commvouch_override_hist.prem_seq_no%TYPE,
      p_net_due         giac_commvouch_override_hist.amount%TYPE,
      p_overriding_user giac_commvouch_override_hist.overriding_user%TYPE,
      p_user_id           giac_commvouch_override_hist.user_id%TYPE
   )
   IS
      v_branch_cd giac_commvouch_override_hist.branch_cd%TYPE;
      v_history_id giac_commvouch_override_hist.history_id%TYPE;
   BEGIN
   
      v_branch_cd   := giacp.v('BRANCH_CD');   
   
      SELECT gcoh_history_id.NEXTVAL	
        INTO v_history_id
        FROM dual;
        
      BEGIN
         INSERT INTO giac_commvouch_override_hist
      	    (fund_cd,      branch_cd,        history_id, 
             intm_no,      iss_cd,           prem_seq_no, 
             amount,       overriding_user,  user_id, 
             last_update)
    	VALUES
            (p_fund_cd,    v_branch_cd,       v_history_id,
             p_intm_no,    p_iss_cd,          p_prem_seq_no,
             p_net_due,    p_overriding_user, p_user_id,
             SYSDATE);
      END;
        
   END update_override_hist;
   
   PROCEDURE check_tagged_records (
      p_user_id     giis_users.user_id%TYPE,
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_message     OUT VARCHAR2,
      p_cv_pref     OUT VARCHAR2,
      p_cv_no       OUT VARCHAR2,
      p_cv_date     OUT DATE,
      p_grp_iss_cd  OUT VARCHAR2
   )
   IS
      v_null_count NUMBER(10);
      v_slip_count NUMBER(10);
   BEGIN
   
      SELECT count(DISTINCT NVL(TO_CHAR(cv_no),'X')) 
  		INTO v_null_count 	
    	FROM giac_comm_voucher_ext
       WHERE include_tag = 'Y'
     	 AND cv_no IS NULL
     	 AND user_id = p_user_id; --change by steven to p_user_id 06.15.2013
         
      SELECT count(DISTINCT NVL(TO_CHAR(cv_no),'X')) 
        INTO v_slip_count
        FROM giac_comm_voucher_ext
       WHERE include_tag = 'Y'
     	 AND user_id = p_user_id; --change by steven to p_user_id
   
      IF v_null_count <> 0 AND (v_slip_count - v_null_count) > 0 THEN
      
         DELETE FROM giac_comm_voucher_ext
          WHERE include_tag = 'Y'
     	 	AND cv_no IS NULL
     	 	AND user_id = p_user_id;
            
         UPDATE giac_comm_voucher_ext
            SET include_tag = NULL
          WHERE include_tag = 'Y'
       	    AND user_id = p_user_id;
            
         p_message := 'Cannot combine unprinted records with printed records.';
         
      ELSIF v_slip_count > 1 THEN
      
         DELETE FROM giac_comm_voucher_ext
          WHERE include_tag = 'Y'
     	    AND cv_no IS NULL
     	 	AND user_id = p_user_id;
            
         UPDATE giac_comm_voucher_ext
            SET include_tag = NULL
          WHERE include_tag = 'Y'
       	    AND user_id = p_user_id;
            
         p_message := 'Cannot combine records with different comm voucher numbers.';
         
      ELSIF v_null_count = 0 THEN
      
         SELECT DISTINCT(cv_pref)
    	   INTO p_cv_pref
      	   FROM giac_comm_voucher_ext    		
		  WHERE include_tag = 'Y'
     	 	AND user_id = p_user_id;
            
         SELECT DISTINCT(cv_no)
    	   INTO p_cv_no
      	   FROM giac_comm_voucher_ext    		
		  WHERE include_tag = 'Y'
     	 	AND user_id = p_user_id;
            
         SELECT DISTINCT(MAX(cv_date))
    	   INTO p_cv_date
      	   FROM giac_comm_voucher_ext    		
	      WHERE include_tag = 'Y'
     	 	AND user_id = p_user_id;
            
         p_message := 'no_update';   
            
      ELSE
         
         FOR i IN (SELECT doc_pref_suf slip_pref, doc_seq_no slip_no, b.grp_iss_cd   
	                 FROM giac_doc_sequence a, giis_user_grp_hdr b, giis_users c 
                    WHERE doc_name = 'COMM_VCR'
                      AND a.branch_cd = b.grp_iss_cd
                      AND a.fund_cd = p_fund_cd
                      AND b.user_grp = c.user_grp
                     AND c.user_id = p_user_id)
         LOOP
            p_cv_pref := i.slip_pref;
      	    p_cv_no := i.slip_no;
            p_cv_date := SYSDATE;
            p_grp_iss_cd := i.grp_iss_cd;
         END LOOP; 
         
         p_message := 'good';                 
               
      END IF;
             
   END check_tagged_records;
   
   FUNCTION get_grp_iss_cd (
      p_user_id VARCHAR2,
      p_rep_id  VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_iss_cd VARCHAR2(100);
      v_exist  VARCHAR2(1);
   BEGIN
      SELECT b.grp_iss_cd
    	INTO v_iss_cd
    	FROM giis_users a,
             giis_user_grp_hdr b
       WHERE a.user_grp = b.user_grp 
         AND a.user_id = p_user_id;
         
      BEGIN
         SELECT '1'
    	   INTO v_exist
    	   FROM giac_documents
    	  WHERE report_id = p_rep_id
    	    AND branch_cd = v_iss_cd;
            
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_iss_cd := 'error';
      END;
      
      RETURN v_iss_cd;
         
   END get_grp_iss_cd;
   
   PROCEDURE save_cv_no(
      p_fund_cd         giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no         giac_comm_voucher_ext.intm_no%TYPE,
      p_policy_no       giac_comm_voucher_ext.policy_no%TYPE,
      p_iss_cd          giac_comm_voucher_ext.iss_cd%TYPE,
      p_prem_seq_no     giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_comm_amt        giac_comm_voucher_ext.commission_amt%TYPE,
      p_wtax            giac_comm_voucher_ext.wholding_tax%TYPE,
      p_comm_paid       giac_comm_voucher_ext.advances%TYPE,
      p_assd_no         giac_comm_voucher_ext.assd_no%TYPE,
      p_prem_amt        giac_comm_voucher_ext.prem_amt%TYPE,
      p_input_vat       giac_comm_voucher_ext.input_vat%TYPE,
      p_user_id         VARCHAR2,
      p_cv_pref         giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no           giac_comm_voucher_ext.cv_no%TYPE,
      p_cv_date           giac_comm_voucher_ext.cv_date%TYPE
   )
   IS
      v_grp_iss_cd VARCHAR2(10);
      v_doc_seq_no giac_doc_sequence.doc_seq_no%TYPE; -- added by jeffdojello 01.27.2014
   BEGIN
    
      UPDATE giac_comm_voucher_ext
	  	 SET print_tag = 'P', cv_pref = p_cv_pref, cv_no = p_cv_no, cv_date = p_cv_date
	   WHERE fund_cd = p_fund_cd
	     AND intm_no = p_intm_no
	     AND policy_no = p_policy_no
	     AND iss_cd = p_iss_cd
	     AND prem_seq_no = p_prem_seq_no
	     AND include_tag = 'Y'
    	 AND commission_amt = p_comm_amt
    	 AND wholding_tax = p_wtax
    	 AND advances = p_comm_paid
    	 AND assd_no = p_assd_no
    	 AND prem_amt = p_prem_amt    
    	 AND NVL(input_vat,0) = NVL(p_input_vat,0)
         AND cv_no IS NULL
	     AND user_id = p_user_id;
         
      SELECT a.grp_iss_cd
		INTO v_grp_iss_cd
  		FROM giis_user_grp_hdr a, giis_users b
 	   WHERE b.user_id = p_user_id
  	 	AND a.user_grp = b.user_grp;   
      
      ---added by jeffdojello 02.07.2014 SR-14821---
      BEGIN
          SELECT doc_seq_no
            INTO v_doc_seq_no
            FROM giac_doc_sequence
           WHERE doc_name = 'COMM_VCR'
             AND branch_cd = v_grp_iss_cd
             AND fund_cd = p_fund_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_doc_seq_no := 0;  
      END;
      ----------------------------------------------

      IF v_doc_seq_no = p_cv_no THEN  --added by jeffdojello 02.07.2014 SR-14821
          UPDATE giac_doc_sequence 
             SET doc_seq_no = doc_seq_no + 1	 		 
           WHERE doc_name = 'COMM_VCR'
             AND branch_cd = v_grp_iss_cd
             AND fund_cd = p_fund_cd;
      END IF;
         
   END save_cv_no;
   
   PROCEDURE remove_include_tag(
      p_user_id VARCHAR2
   )
   IS
   BEGIN
      UPDATE giac_comm_voucher_ext		
		 SET include_tag = NULL
	   WHERE include_tag = 'Y'
		 AND user_id = p_user_id;
   END remove_include_tag;
         
END;
/


