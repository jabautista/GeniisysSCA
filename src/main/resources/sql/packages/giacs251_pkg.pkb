CREATE OR REPLACE PACKAGE BODY CPI.giacs251_pkg
AS

   FUNCTION get_fund_lov(
      p_find_text             VARCHAR2
   )
     RETURN fund_lov_tab PIPELINED
   IS
      v_row                   fund_lov_type;
   BEGIN
      FOR i IN(SELECT fund_cd, fund_desc
                 FROM giis_funds
                WHERE (UPPER(fund_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(fund_desc) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.fund_cd := i.fund_cd;
         v_row.fund_desc := i.fund_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;

   FUNCTION get_batch_comm_voucher(
      p_fund_cd               giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   )
     RETURN batch_tab PIPELINED
   IS
      v_row                batch_type;
   BEGIN
      IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
         FOR i IN(SELECT intm_no, cv_pref, cv_no, print_tag, iss_cd,
                         SUM(actual_comm) actual_comm,
                         SUM(comm_payable) comm_payable,
                         SUM(comm_paid) comm_paid
                    FROM (SELECT DISTINCT a.*, b.cv_no, cv_pref, c.actual_comm, c.comm_payable, print_tag
                            FROM ((SELECT a.intm_no, a.iss_cd, a.prem_seq_no, a.wtax_amt,
                                          CPI.get_comm_paid(a.intm_no,a.iss_cd, a.prem_seq_no) comm_paid, a.prem_amt, a.comm_amt, a.input_vat
                                     FROM giac_comm_voucher_v3 a
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(a.intm_no,a.iss_cd,a.prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                INTERSECT
                                   SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)
                                    UNION 
                                  (SELECT intm_no, iss_cd, prem_seq_no, wtax_amt,
                                          CPI.get_comm_paid(intm_no,iss_cd, prem_seq_no) comm_paid, prem_amt, comm_amt, input_vat
                                     FROM giac_comm_voucher_v3
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                    MINUS
                                   SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)) a,
                                 giac_comm_voucher_ext b,
                                 giac_comm_voucher_v3 c
                           WHERE 1 = 1
                             AND c.iss_cd(+) = a.iss_cd
                             AND c.prem_seq_no(+) = a.prem_seq_no
                             AND c.intm_no(+) = a.intm_no
                             AND c.wtax_amt(+) = a.wtax_amt
                             AND c.prem_amt(+) = a.prem_amt
                             AND c.comm_amt(+) = a.comm_amt
                             AND c.input_vat(+) = a.INPUT_VAT
                             AND b.iss_cd(+) = a.iss_cd
                             AND b.prem_seq_no(+) = a.prem_seq_no
                             AND b.intm_no(+) = a.intm_no
                             AND b.wholding_tax(+) = a.wtax_amt
                             AND b.advances(+) = a.comm_paid
                             AND b.prem_amt(+) = a.prem_amt
                             AND b.commission_amt(+) = a.comm_amt
                             AND b.input_vat(+) = a.input_vat                             
                             AND b.fund_cd = p_fund_cd)
                   WHERE intm_no LIKE NVL(p_intm_no, intm_no)
                     AND (cv_no LIKE NVL(p_cv_no, cv_no) OR cv_no IS NULL)
                     AND (cv_pref LIKE NVL(p_cv_pref, cv_pref) OR cv_pref IS NULL)
                   GROUP BY intm_no, iss_cd, cv_no, cv_pref, print_tag
                   ORDER BY iss_cd, intm_no, cv_no)
         LOOP
            v_row.iss_cd := i.iss_cd;
            v_row.intm_no := i.intm_no;
            v_row.cv_pref := i.cv_pref;
            v_row.cv_no := i.cv_no;
            v_row.print_tag := i.print_tag;
            v_row.actual_comm := i.actual_comm;
            v_row.comm_payable := i.comm_payable;
            v_row.comm_paid := i.comm_paid;
            v_row.net_due := i.comm_payable - i.comm_paid;
            
            v_row.intm_name := NULL;
            v_row.parent_intm_name := NULL;
            FOR j IN(SELECT a.intm_name, b.intm_name parent_intm_name 
                       FROM giis_intermediary a,
                            giis_intermediary b
                      WHERE a.intm_no = i.intm_no
                        AND b.intm_no(+) = a.parent_intm_no)
            LOOP
               v_row.intm_name := j.intm_name;
               v_row.parent_intm_name := j.parent_intm_name;
               EXIT;
            END LOOP;
            
            PIPE ROW(v_row);
         END LOOP;
      ELSE
         FOR i IN(SELECT intm_no, cv_pref, cv_no, print_tag, iss_cd,
                         SUM(actual_comm) actual_comm,
                         SUM(comm_payable) comm_payable,
                         SUM(comm_paid) comm_paid
                    FROM (SELECT DISTINCT a.*, b.cv_no, cv_pref, c.actual_comm, c.comm_payable, print_tag
                            FROM ((SELECT a.intm_no, a.iss_cd, a.prem_seq_no, a.wtax_amt,
                                          CPI.get_comm_paid(a.intm_no,a.iss_cd, a.prem_seq_no) comm_paid, a.prem_amt, a.comm_amt, a.input_vat
                                     FROM giac_comm_voucher_v a
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(a.intm_no,a.iss_cd,a.prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                INTERSECT
                                   SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)
                                    UNION 
                                  (SELECT intm_no, iss_cd, prem_seq_no, wtax_amt,
                                          CPI.get_comm_paid(intm_no,iss_cd, prem_seq_no) comm_paid, prem_amt, comm_amt, input_vat
                                     FROM giac_comm_voucher_v
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                    MINUS
                                   SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)) a,
                                 giac_comm_voucher_ext b,
                                 giac_comm_voucher_v c
                           WHERE 1 = 1
                             AND c.iss_cd(+) = a.iss_cd
                             AND c.prem_seq_no(+) = a.prem_seq_no
                             AND c.intm_no(+) = a.intm_no
                             AND c.wtax_amt(+) = a.wtax_amt
                             AND c.prem_amt(+) = a.prem_amt
                             AND c.comm_amt(+) = a.comm_amt
                             AND c.input_vat(+) = a.INPUT_VAT
                             AND b.iss_cd(+) = a.iss_cd
                             AND b.prem_seq_no(+) = a.prem_seq_no
                             AND b.intm_no(+) = a.intm_no
                             AND b.wholding_tax(+) = a.wtax_amt
                             AND b.advances(+) = a.comm_paid
                             AND b.prem_amt(+) = a.prem_amt
                             AND b.commission_amt(+) = a.comm_amt
                             AND b.input_vat(+) = a.input_vat
                             AND (c.inv_prem_amt = c.prem_amt OR (c.inv_prem_amt - c.prem_amt)=0.01)
                             AND b.fund_cd = p_fund_cd)
                   WHERE intm_no LIKE NVL(p_intm_no, intm_no)
                     AND (cv_no LIKE NVL(p_cv_no, cv_no) OR cv_no IS NULL)
                     AND (cv_pref LIKE NVL(p_cv_pref, cv_pref) OR cv_pref IS NULL)
                   GROUP BY intm_no, iss_cd, cv_no, cv_pref, print_tag
                   ORDER BY iss_cd, intm_no, cv_no)
         LOOP
            v_row.iss_cd := i.iss_cd;
            v_row.intm_no := i.intm_no;
            v_row.cv_pref := i.cv_pref;
            v_row.cv_no := i.cv_no;
            v_row.print_tag := i.print_tag;
            v_row.actual_comm := i.actual_comm;
            v_row.comm_payable := i.comm_payable;
            v_row.comm_paid := i.comm_paid;
            v_row.net_due := i.comm_payable - i.comm_paid;
            
            v_row.intm_name := NULL;
            v_row.parent_intm_name := NULL;
            FOR j IN(SELECT a.intm_name, b.intm_name parent_intm_name 
                       FROM giis_intermediary a,
                            giis_intermediary b
                      WHERE a.intm_no = i.intm_no
                        AND b.intm_no(+) = a.parent_intm_no)
            LOOP
               v_row.intm_name := j.intm_name;
               v_row.parent_intm_name := j.parent_intm_name;
               EXIT;
            END LOOP;
            
            PIPE ROW(v_row);
         END LOOP;
      END IF;
   END;
   
   FUNCTION get_batch_comm_voucher_dtl(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_prem_seq_no           giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_prem_amt              NUMBER,
      p_actual_comm           NUMBER,
      p_comm_payable          NUMBER,
      p_comm_amt              NUMBER,
      p_wtax_amt              NUMBER,
      p_input_vat             NUMBER
   )
     RETURN batch_dtl_tab PIPELINED
   IS
      v_row                   batch_dtl_type;
   BEGIN
      giacs251_pkg.get_detail_totals(p_intm_no, p_cv_pref, p_cv_no, p_prem_seq_no, p_prem_amt, p_actual_comm, p_comm_payable, p_comm_amt,
                                    p_wtax_amt, p_input_vat, v_row.total_prem_amt, v_row.total_actual_comm, v_row.total_comm_payable,
                                    v_row.total_comm_amt, v_row.total_wtax_amt, v_row.total_input_vat_amt);
                                    
      IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
         FOR i IN(SELECT DISTINCT a.*, b.cv_no, cv_pref, c.actual_comm, c.comm_payable, c.policy_id
                    FROM ((SELECT a.intm_no, a.iss_cd, a.prem_seq_no, a.wtax_amt,
                                  CPI.get_comm_paid(a.intm_no,a.iss_cd, a.prem_seq_no) comm_paid, a.prem_amt, a.comm_amt, a.input_vat
                             FROM giac_comm_voucher_v3 a
                            WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(a.intm_no,a.iss_cd,a.prem_seq_no),2)
                              AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                        INTERSECT
                           SELECT intm_no, iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                             FROM giac_comm_voucher_ext)
                            UNION
                          (SELECT intm_no, iss_cd, prem_seq_no, wtax_amt,
                                  CPI.get_comm_paid(intm_no,iss_cd, prem_seq_no) comm_paid, prem_amt, comm_amt, input_vat
                             FROM giac_comm_voucher_v3
                            WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                              AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                            MINUS
                           SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                             FROM giac_comm_voucher_ext)) a,
                         giac_comm_voucher_ext b,
                         giac_comm_voucher_v3 c
                   WHERE 1 = 1
                     AND a.intm_no = p_intm_no
                     AND ((p_cv_pref IS NOT NULL AND cv_pref = p_cv_pref) OR (p_cv_pref IS NULL AND cv_pref IS NULL))
                     AND ((p_cv_no IS NOT NULL AND cv_no = p_cv_no) OR (p_cv_no IS NULL AND cv_no IS NULL))
                     AND c.iss_cd(+) = a.iss_cd
                     AND c.prem_seq_no(+) = a.prem_seq_no
                     AND c.intm_no(+) = a.intm_no
                     AND c.wtax_amt(+) = a.wtax_amt
                     AND c.prem_amt(+) = a.prem_amt
                     AND c.comm_amt(+) = a.comm_amt
                     AND c.input_vat(+) = a.input_vat
                     AND b.iss_cd(+) = a.iss_cd
                     AND b.prem_seq_no(+) = a.prem_seq_no
                     AND b.intm_no(+) = a.intm_no
                     AND b.wholding_tax(+) = a.wtax_amt
                     AND b.advances(+) = a.comm_paid
                     AND b.prem_amt(+) = a.prem_amt
                     AND b.commission_amt(+) = a.comm_amt
                     AND b.input_vat(+) = a.input_vat
                     AND NVL(a.prem_seq_no, 0) = NVL(p_prem_seq_no, NVL(a.prem_seq_no, 0))
                     AND NVL(a.prem_amt, 0) = NVL(p_prem_amt, NVL(a.prem_amt, 0))
                     AND NVL(c.actual_comm, 0) = NVL(p_actual_comm, NVL(c.actual_comm, 0))
                     AND NVL(c.comm_payable, 0) = NVL(p_comm_payable, NVL(c.comm_payable, 0))
                     AND NVL(a.comm_amt, 0) = NVL(p_comm_amt, NVL(a.comm_amt, 0))
                     AND NVL(a.wtax_amt, 0) = NVL(p_wtax_amt, NVL(a.wtax_amt, 0))
                     AND NVL(a.input_vat, 0) = NVL(p_input_vat, NVL(a.input_vat, 0))
                   ORDER BY a.iss_cd, a.prem_seq_no)
         LOOP
            v_row.cv_pref := NULL;
            v_row.cv_no := NULL;
         
            v_row.intm_no := i.intm_no;
            v_row.iss_cd := i.iss_cd;
            v_row.prem_seq_no := i.prem_seq_no;
            v_row.wtax_amt := i.wtax_amt;
            v_row.comm_paid := i.comm_paid;
            v_row.prem_amt := i.prem_amt;
            v_row.comm_amt := i.comm_amt;
            v_row.input_vat := i.input_vat;
            v_row.cv_no := i.cv_no;
            v_row.cv_pref := i.cv_pref;
            v_row.actual_comm := i.actual_comm;
            v_row.comm_payable := i.comm_payable;
            v_row.policy_id := i.policy_id;
            
            v_row.policy_no := NULL;
            v_row.pol_status := NULL;
            FOR j IN(SELECT    line_cd
                            || '-'
                            || subline_cd
                            || '-'
                            || iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM (TO_CHAR (renew_no, '09'))
                            || DECODE (
                                  NVL (endt_seq_no, 0),
                                  0, '',
                                     ' / '
                                  || endt_iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (endt_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
                               ) policy_no, pol_flag
                       FROM gipi_polbasic pol
                      WHERE pol.policy_id = i.policy_id)
            LOOP
               v_row.policy_no := j.policy_no;
               v_row.pol_flag := j.pol_flag;
               
               FOR s IN(SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                           AND rv_low_value = j.pol_flag)
               LOOP
                  v_row.pol_status := UPPER(s.rv_meaning);
                  EXIT;
               END LOOP;
               
               EXIT;
            END LOOP; 
            
            v_row.intm_name := NULL;
            FOR k IN(SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
            LOOP
               v_row.intm_name := k.intm_name;
               EXIT;
            END LOOP;
            
            PIPE ROW(v_row);
         END LOOP;
      ELSE
         FOR i IN(SELECT DISTINCT a.*, b.cv_no, cv_pref, c.actual_comm, c.comm_payable, c.policy_id
                    FROM ((SELECT a.intm_no, a.iss_cd, a.prem_seq_no, a.wtax_amt,
                                  CPI.get_comm_paid(a.intm_no,a.iss_cd, a.prem_seq_no) comm_paid, a.prem_amt, a.comm_amt, a.input_vat
                             FROM giac_comm_voucher_v a
                            WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(a.intm_no,a.iss_cd,a.prem_seq_no),2)
                              AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                        INTERSECT
                           SELECT intm_no, iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                             FROM giac_comm_voucher_ext)
                            UNION
                          (SELECT intm_no, iss_cd, prem_seq_no, wtax_amt,
                                  CPI.get_comm_paid(intm_no,iss_cd, prem_seq_no) comm_paid, prem_amt, comm_amt, input_vat
                             FROM giac_comm_voucher_v
                            WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                              AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                            MINUS
                           SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                             FROM giac_comm_voucher_ext)) a, giac_comm_voucher_ext B, giac_comm_voucher_v c
                   WHERE 1 = 1
                     AND a.intm_no = p_intm_no
                     --AND NVL(cv_pref, 1) = NVL(p_cv_pref, 1) 
                     --AND NVL(cv_no, 1) = NVL(p_cv_no, 1)
                     AND ((p_cv_pref IS NOT NULL AND cv_pref = p_cv_pref) OR (p_cv_pref IS NULL AND cv_pref IS NULL))
                     AND ((p_cv_no IS NOT NULL AND cv_no = p_cv_no) OR (p_cv_no IS NULL AND cv_no IS NULL))
                     AND c.iss_cd(+) = a.iss_cd
                     AND c.prem_seq_no(+) = a.prem_seq_no
                     AND c.intm_no(+) = a.intm_no
                     AND c.wtax_amt(+) = a.wtax_amt
                     AND c.prem_amt(+) = a.prem_amt
                     AND c.comm_amt(+) = a.comm_amt
                     AND c.input_vat(+) = a.input_vat
                     AND b.iss_cd(+) = a.iss_cd
                     AND b.prem_seq_no(+) = a.prem_seq_no
                     AND b.intm_no(+) = a.intm_no
                     AND b.wholding_tax(+) = a.wtax_amt
                     AND b.advances(+) = a.comm_paid
                     AND b.prem_amt(+) = a.prem_amt
                     AND b.commission_amt(+) = a.comm_amt
                     AND b.input_vat(+) = A.input_vat
                     AND (c.inv_prem_amt = c.prem_amt OR (c.inv_prem_amt - c.prem_amt)=0.01)
                     AND NVL(a.prem_seq_no, 0) = NVL(p_prem_seq_no, NVL(a.prem_seq_no, 0))
                     AND NVL(a.prem_amt, 0) = NVL(p_prem_amt, NVL(a.prem_amt, 0))
                     AND NVL(c.actual_comm, 0) = NVL(p_actual_comm, NVL(c.actual_comm, 0))
                     AND NVL(c.comm_payable, 0) = NVL(p_comm_payable, NVL(c.comm_payable, 0))
                     AND NVL(a.comm_amt, 0) = NVL(p_comm_amt, NVL(a.comm_amt, 0))
                     AND NVL(a.wtax_amt, 0) = NVL(p_wtax_amt, NVL(a.wtax_amt, 0))
                     AND NVL(a.input_vat, 0) = NVL(p_input_vat, NVL(a.input_vat, 0))
                   ORDER BY a.iss_cd, a.prem_seq_no)
         LOOP
            v_row.cv_pref := NULL;
            v_row.cv_no := NULL;
         
            v_row.intm_no := i.intm_no;
            v_row.iss_cd := i.iss_cd;
            v_row.prem_seq_no := i.prem_seq_no;
            v_row.wtax_amt := i.wtax_amt;
            v_row.comm_paid := i.comm_paid;
            v_row.prem_amt := i.prem_amt;
            v_row.comm_amt := i.comm_amt;
            v_row.input_vat := i.input_vat;
            v_row.cv_no := i.cv_no;
            v_row.cv_pref := i.cv_pref;
            v_row.actual_comm := i.actual_comm;
            v_row.comm_payable := i.comm_payable;
            v_row.policy_id := i.policy_id;
            
            v_row.policy_no := NULL;
            v_row.pol_status := NULL;
            FOR j IN(SELECT    line_cd
                            || '-'
                            || subline_cd
                            || '-'
                            || iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM (TO_CHAR (renew_no, '09'))
                            || DECODE (
                                  NVL (endt_seq_no, 0),
                                  0, '',
                                     ' / '
                                  || endt_iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (endt_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
                               ) policy_no, pol_flag
                       FROM gipi_polbasic pol
                      WHERE pol.policy_id = i.policy_id)
            LOOP
               v_row.policy_no := j.policy_no;
               
               FOR s IN(SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                           AND rv_low_value = j.pol_flag)
               LOOP
                  v_row.pol_status := UPPER(s.rv_meaning);
                  EXIT;
               END LOOP;
               
               EXIT;
            END LOOP;
            
            v_row.intm_name := NULL;
            FOR k IN(SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
            LOOP
               v_row.intm_name := k.intm_name;
               EXIT;
            END LOOP;
            
            PIPE ROW(v_row);
         END LOOP;
      END IF;
   END;
   
   PROCEDURE get_detail_totals(
      p_intm_no               IN       giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               IN       giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 IN       giac_comm_voucher_ext.cv_no%TYPE,
      p_prem_seq_no           IN       giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_prem_amt              IN       NUMBER,
      p_actual_comm           IN       NUMBER,
      p_comm_payable          IN       NUMBER,
      p_comm_amt              IN       NUMBER,
      p_wtax_amt              IN       NUMBER,
      p_input_vat             IN       NUMBER,
      p_total_prem_amt        IN OUT   NUMBER,
      p_total_actual_comm     IN OUT   NUMBER,
      p_total_comm_payable    IN OUT   NUMBER,
      p_total_comm_amt        IN OUT   NUMBER,
      p_total_wtax_amt        IN OUT   NUMBER,
      p_total_input_vat_amt   IN OUT   NUMBER
   )
   IS
   BEGIN
      IF NVL(giacp.v('NO_PREM_PAYT'),'N') = 'Y' THEN
         FOR i IN(SELECT SUM(prem_amt) prem_amt, SUM(actual_comm) actual_comm, SUM(comm_payable) comm_payable,
                         SUM(comm_amt) comm_amt, SUM(wtax_amt) wtax_amt, SUM(input_vat) input_vat
                    FROM (SELECT DISTINCT a.*, b.cv_no, cv_pref, c.actual_comm, c.comm_payable, c.policy_id
                            FROM ((SELECT a.intm_no, a.iss_cd, a.prem_seq_no, a.wtax_amt,
                                          CPI.get_comm_paid(a.intm_no,a.iss_cd, a.prem_seq_no) comm_paid, a.prem_amt, a.comm_amt, a.input_vat
                                     FROM giac_comm_voucher_v3 a
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(a.intm_no,a.iss_cd,a.prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                INTERSECT
                                   SELECT intm_no, iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)
                                    UNION
                                  (SELECT intm_no, iss_cd, prem_seq_no, wtax_amt,
                                          CPI.get_comm_paid(intm_no,iss_cd, prem_seq_no) comm_paid, prem_amt, comm_amt, input_vat
                                     FROM giac_comm_voucher_v3
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                    MINUS
                                   SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)) a,
                                 giac_comm_voucher_ext b,
                                 giac_comm_voucher_v3 c
                           WHERE 1 = 1
                             AND a.intm_no = p_intm_no
                             AND NVL(cv_pref,1) = NVL(p_cv_pref, 1) 
                             AND NVL(cv_no,1) = NVL(p_cv_no, 1)
                             AND c.iss_cd(+) = a.iss_cd
                             AND c.prem_seq_no(+) = a.prem_seq_no
                             AND c.intm_no(+) = a.intm_no
                             AND c.wtax_amt(+) = a.wtax_amt
                             AND c.prem_amt(+) = a.prem_amt
                             AND c.comm_amt(+) = a.comm_amt
                             AND c.input_vat(+) = a.input_vat
                             AND b.iss_cd(+) = a.iss_cd
                             AND b.prem_seq_no(+) = a.prem_seq_no
                             AND b.intm_no(+) = a.intm_no
                             AND b.wholding_tax(+) = a.wtax_amt
                             AND b.advances(+) = a.comm_paid
                             AND b.prem_amt(+) = a.prem_amt
                             AND b.commission_amt(+) = a.comm_amt
                             AND b.input_vat(+) = A.input_vat
                             AND NVL(a.prem_seq_no, 0) = NVL(p_prem_seq_no, NVL(a.prem_seq_no, 0))
                             AND NVL(a.prem_amt, 0) = NVL(p_prem_amt, NVL(a.prem_amt, 0))
                             AND NVL(c.actual_comm, 0) = NVL(p_actual_comm, NVL(c.actual_comm, 0))
                             AND NVL(c.comm_payable, 0) = NVL(p_comm_payable, NVL(c.comm_payable, 0))
                             AND NVL(a.comm_amt, 0) = NVL(p_comm_amt, NVL(a.comm_amt, 0))
                             AND NVL(a.wtax_amt, 0) = NVL(p_wtax_amt, NVL(a.wtax_amt, 0))
                             AND NVL(a.input_vat, 0) = NVL(p_input_vat, NVL(a.input_vat, 0))
                           ORDER BY a.iss_cd, a.prem_seq_no))
         LOOP
            p_total_prem_amt := i.prem_amt;
            p_total_actual_comm := i.actual_comm;
            p_total_comm_payable := i.comm_payable;
            p_total_comm_amt := i.comm_amt;
            p_total_wtax_amt := i.wtax_amt;
            p_total_input_vat_amt := i.input_vat;
            EXIT;
         END LOOP;
      ELSE
         FOR i IN(SELECT SUM(prem_amt) prem_amt, SUM(actual_comm) actual_comm, SUM(comm_payable) comm_payable,
                         SUM(comm_amt) comm_amt, SUM(wtax_amt) wtax_amt, SUM(input_vat) input_vat
                    FROM (SELECT DISTINCT a.*, b.cv_no, cv_pref, c.actual_comm, c.comm_payable, c.policy_id
                            FROM ((SELECT a.intm_no, a.iss_cd, a.prem_seq_no, a.wtax_amt,
                                          CPI.get_comm_paid(a.intm_no,a.iss_cd, a.prem_seq_no) comm_paid, a.prem_amt, a.comm_amt, a.input_vat
                                     FROM giac_comm_voucher_v a
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(a.intm_no,a.iss_cd,a.prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                INTERSECT
                                   SELECT intm_no, iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)
                                    UNION
                                  (SELECT intm_no, iss_cd, prem_seq_no, wtax_amt,
                                          CPI.get_comm_paid(intm_no,iss_cd, prem_seq_no) comm_paid, prem_amt, comm_amt, input_vat
                                     FROM giac_comm_voucher_v
                                    WHERE ROUND(comm_payable,2) <> ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_no),2)
                                      AND 1 = DECODE(comm_payable - ROUND(CPI.get_comm_paid(intm_no,iss_cd,prem_seq_No),2), -.01,0,1)
                                    MINUS
                                   SELECT intm_no , iss_cd, prem_seq_no, wholding_tax wtax_amt, advances comm_paid, prem_amt, commission_amt comm_amt, input_vat
                                     FROM giac_comm_voucher_ext)) a, giac_comm_voucher_ext B, giac_comm_voucher_v c
                           WHERE 1 = 1
                             AND a.intm_no = p_intm_no
                             AND NVL(cv_pref,1) = NVL(p_cv_pref, 1) 
                             AND NVL(cv_no,1) = NVL(p_cv_no, 1)
                             AND c.iss_cd(+) = a.iss_cd
                             AND c.prem_seq_no(+) = a.prem_seq_no
                             AND c.intm_no(+) = a.intm_no
                             AND c.wtax_amt(+) = a.wtax_amt
                             AND c.prem_amt(+) = a.prem_amt
                             AND c.comm_amt(+) = a.comm_amt
                             AND c.input_vat(+) = a.input_vat
                             AND b.iss_cd(+) = a.iss_cd
                             AND b.prem_seq_no(+) = a.prem_seq_no
                             AND b.intm_no(+) = a.intm_no
                             AND b.wholding_tax(+) = a.wtax_amt
                             AND b.advances(+) = a.comm_paid
                             AND b.prem_amt(+) = a.prem_amt
                             AND b.commission_amt(+) = a.comm_amt
                             AND b.input_vat(+) = A.input_vat
                             AND (c.inv_prem_amt = c.prem_amt OR (c.inv_prem_amt - c.prem_amt)=0.01)
                             AND NVL(a.prem_seq_no, 0) = NVL(p_prem_seq_no, NVL(a.prem_seq_no, 0))
                             AND NVL(a.prem_amt, 0) = NVL(p_prem_amt, NVL(a.prem_amt, 0))
                             AND NVL(c.actual_comm, 0) = NVL(p_actual_comm, NVL(c.actual_comm, 0))
                             AND NVL(c.comm_payable, 0) = NVL(p_comm_payable, NVL(c.comm_payable, 0))
                             AND NVL(a.comm_amt, 0) = NVL(p_comm_amt, NVL(a.comm_amt, 0))
                             AND NVL(a.wtax_amt, 0) = NVL(p_wtax_amt, NVL(a.wtax_amt, 0))
                             AND NVL(a.input_vat, 0) = NVL(p_input_vat, NVL(a.input_vat, 0))
                           ORDER BY a.iss_cd, a.prem_seq_no))
         LOOP
            p_total_prem_amt := i.prem_amt;
            p_total_actual_comm := i.actual_comm;
            p_total_comm_payable := i.comm_payable;
            p_total_comm_amt := i.comm_amt;
            p_total_wtax_amt := i.wtax_amt;
            p_total_input_vat_amt := i.input_vat;
            EXIT;
         END LOOP;
      END IF;
   END;
   
   PROCEDURE populate_batch_comm_voucher(
      p_fund_cd               giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_comm_voucher_ext_temp;
      
      INSERT INTO giac_comm_voucher_ext_temp
       VALUE (SELECT a.*, NULL, NULL
                FROM TABLE(giacs251_pkg.get_batch_comm_voucher(p_fund_cd, p_intm_no, p_cv_pref, p_cv_no)) a);
      
      COMMIT;
   END;
   
   FUNCTION get_batch_comm_voucher_listing(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_actual_comm           NUMBER,
      p_comm_payable          NUMBER,
      p_comm_paid             NUMBER,
      p_net_due               NUMBER,
      p_get_totals            VARCHAR2
   )
     RETURN batch_listing_tab PIPELINED
   IS
      v_row                   batch_listing_type;
   BEGIN
      IF p_get_totals = 'Y' THEN
         giacs251_pkg.get_totals(p_intm_no, p_cv_pref, p_cv_no, p_actual_comm, p_comm_payable, p_comm_paid, p_net_due,
                                 v_row.tagged_actual_comm, v_row.tagged_comm_payable, v_row.tagged_comm_paid, v_row.tagged_net_due,
                                 v_row.grand_actual_comm, v_row.grand_comm_payable, v_row.grand_comm_paid, v_row.grand_net_due);
      END IF;
   
      FOR i IN(SELECT *
                 FROM giac_comm_voucher_ext_temp
                WHERE NVL(actual_comm, 0) = NVL(p_actual_comm, NVL(actual_comm, 0))
                  AND NVL(comm_payable, 0) = NVL(p_comm_payable, NVL(comm_payable, 0))
                  AND NVL(comm_paid, 0) = NVL(p_comm_paid, NVL(comm_paid, 0))
                  AND NVL(intm_no, 0) = NVL(p_intm_no, NVL(intm_no, 0))
                  AND NVL(net_due, 0) = NVL(p_net_due, NVL(net_due, 0))
                ORDER BY intm_no, cv_no)
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.intm_no := i.intm_no;
         v_row.cv_pref := i.cv_pref;
         v_row.cv_no := i.cv_no;
         v_row.print_tag := i.print_tag;
         v_row.actual_comm := i.actual_comm;
         v_row.comm_payable := i.comm_payable;
         v_row.comm_paid := i.comm_paid;
         v_row.net_due := i.net_due;
         v_row.intm_name := i.intm_name;
         v_row.parent_intm_name := i.parent_intm_name;
         v_row.generate_flag := i.generate_flag;
         v_row.printed_flag := i.printed_flag;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE get_doc_cv_seq(
      p_fund_cd         IN    giis_funds.fund_cd%TYPE,
      p_user_id         IN    giis_users.user_id%TYPE,
      p_cv_pref         OUT   giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_seq_no       OUT   giac_comm_voucher_ext.cv_no%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT doc_pref_suf cv_pref, doc_seq_no cv_no, b.grp_iss_cd
                 FROM giac_doc_sequence a,
                      giis_user_grp_hdr b, 
                      giis_users c 
                WHERE doc_name = 'COMM_VCR'
                  AND a.branch_cd = b.grp_iss_cd
                  AND a.fund_cd = p_fund_cd
                  AND b.user_grp = c.user_grp
                  AND c.user_id = p_user_id)
      LOOP
  	      p_cv_pref := i.cv_pref;
         p_cv_seq_no := i.cv_no;
         EXIT;
      END LOOP;
   END;
   
   PROCEDURE update_sum_ext(
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_bank_file_no          giac_comm_voucher_ext.bank_file_no%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE
   )
   IS
   BEGIN
      UPDATE giac_bank_comm_payt_sum_ext
         SET cv_pref = p_cv_pref,
             cv_no = p_cv_no
       WHERE bank_file_no = p_bank_file_no
         AND intm_no = p_intm_no;
   END;
   
   PROCEDURE get_totals(
      p_intm_no               IN    giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               IN    giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 IN    giac_comm_voucher_ext.cv_no%TYPE,
      p_actual_comm           IN    NUMBER,
      p_comm_payable          IN    NUMBER,
      p_comm_paid             IN    NUMBER,
      p_net_due               IN    NUMBER,
      p_tagged_actual_comm    OUT   NUMBER,
      p_tagged_comm_payable   OUT   NUMBER,
      p_tagged_comm_paid      OUT   NUMBER,
      p_tagged_net_due        OUT   NUMBER,
      p_total_actual_comm     OUT   NUMBER,
      p_total_comm_payable    OUT   NUMBER,
      p_total_comm_paid       OUT   NUMBER,
      p_total_net_due         OUT   NUMBER
   )
   IS
   BEGIN
      FOR i IN(SELECT SUM(actual_comm) actual_comm, SUM(comm_payable) comm_payable,
                      SUM(comm_paid) comm_paid, SUM(net_due) net_due
                 FROM TABLE(giacs251_pkg.get_batch_comm_voucher_listing(p_intm_no, p_cv_pref,p_cv_no,p_actual_comm,p_comm_payable,p_comm_paid,p_net_due, 'N'))
                WHERE generate_flag = 'Y')
      LOOP
         p_tagged_actual_comm := i.actual_comm;
         p_tagged_comm_payable := i.comm_payable;
         p_tagged_comm_paid := i.comm_paid;
         p_tagged_net_due := i.net_due;
         EXIT;
      END LOOP;
   
      FOR i IN(SELECT SUM(actual_comm) actual_comm, SUM(comm_payable) comm_payable,
                      SUM(comm_paid) comm_paid, SUM(net_due) net_due
                 FROM TABLE(giacs251_pkg.get_batch_comm_voucher_listing(p_intm_no, p_cv_pref,p_cv_no,p_actual_comm,p_comm_payable,p_comm_paid,p_net_due, 'N')))
      LOOP
         p_total_actual_comm := i.actual_comm;
         p_total_comm_payable := i.comm_payable;
         p_total_comm_paid := i.comm_paid;
         p_total_net_due := i.net_due;
         EXIT;
      END LOOP;
   END;
   
   PROCEDURE clear_temp_table
   IS
   BEGIN
      DELETE FROM giac_comm_voucher_ext_temp;
      COMMIT;
   END;
   
   PROCEDURE save_generate_flag(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_iss_cd                giac_comm_voucher_ext.iss_cd%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_generate_flag         VARCHAR2
   )
   IS
   BEGIN
      --here
      UPDATE giac_comm_voucher_ext
         SET include_tag = 'Y'
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND (p_cv_pref IS NULL AND cv_pref IS NULL) OR (p_cv_pref IS NOT NULL AND cv_pref = p_cv_pref)
         AND (p_cv_no IS NULL AND cv_no IS NULL) OR (p_cv_no IS NOT NULL AND cv_no = p_cv_no);  
   
      UPDATE giac_comm_voucher_ext_temp
         SET generate_flag = p_generate_flag
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND (p_cv_pref IS NULL AND cv_pref IS NULL) OR (p_cv_pref IS NOT NULL AND cv_pref = p_cv_pref)
         AND (p_cv_no IS NULL AND cv_no IS NULL) OR (p_cv_no IS NOT NULL AND cv_no = p_cv_no);
         --AND UPPER(NVL(cv_pref, '-')) = UPPER(NVL(p_cv_pref, NVL(cv_pref, '-')))
         --AND NVL(cv_no, 0) = NVL(p_cv_no, NVL(cv_no, 0));
   END;
   
   PROCEDURE generate_cv_number(
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   )
   IS
      v_cv_no                 giac_comm_voucher_ext.cv_no%TYPE;
   BEGIN
      v_cv_no := p_cv_no;
   
      FOR i IN(SELECT iss_cd, intm_no, generate_flag
                 FROM giac_comm_voucher_ext_temp
                WHERE NVL(generate_flag, 'N') = 'Y'
                  AND NVL(print_tag, 'N') <> 'P'
                ORDER BY iss_cd, intm_no, cv_no)
      LOOP
         UPDATE giac_comm_voucher_ext_temp
            SET cv_pref = p_cv_pref,
                cv_no = v_cv_no
          WHERE intm_no = i.intm_no
            AND iss_cd = i.iss_cd
            AND NVL(print_tag, 'N') <> 'P';
            
         v_cv_no := v_cv_no + 1;
      END LOOP;
   END;
   
   FUNCTION get_batch_reports
     RETURN reports_tab PIPELINED
   IS
      v_row                   reports_type;
   BEGIN
      FOR i IN(SELECT intm_no, cv_no, cv_pref, iss_cd
                 FROM giac_comm_voucher_ext_temp
                WHERE cv_pref IS NOT NULL
                  AND cv_no IS NOT NULL
                  AND NVL(print_tag, 'N') <> 'P'
                ORDER BY iss_cd, intm_no, cv_no)
      LOOP
         v_row.intm_no := i.intm_no;
         v_row.cv_no := i.cv_no;
         v_row.cv_pref := i.cv_pref;
         v_row.iss_cd := i.iss_cd;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE tag_all(
      p_actual_comm           NUMBER,
      p_comm_payable          NUMBER,
      p_comm_paid             NUMBER,
      p_net_due               NUMBER
   )
   IS
   BEGIN
      UPDATE giac_comm_voucher_ext
         SET include_tag = 'Y'
       WHERE cv_pref IS NULL
         AND cv_no IS NULL
         AND NVL(print_tag, 'N') <> 'P';
   
      UPDATE giac_comm_voucher_ext_temp
         SET generate_flag = 'Y'
       WHERE cv_pref IS NULL
         AND cv_no IS NULL
         AND NVL(print_tag, 'N') <> 'P';
         --AND NVL(actual_comm, 0) = NVL(p_actual_comm, NVL(actual_comm, 0))
         --AND NVL(comm_payable, 0) = NVL(p_comm_payable, NVL(comm_payable, 0))
         --AND NVL(comm_paid, 0) = NVL(p_comm_paid, NVL(comm_paid, 0))
         --AND NVL(net_due, 0) = NVL(p_net_due, NVL(p_net_due, 0));
   END;
   
   PROCEDURE untag_all
   IS   
   BEGIN
      UPDATE giac_comm_voucher_ext
         SET include_tag = 'N';
   
      UPDATE giac_comm_voucher_ext_temp
         SET generate_flag = 'N',
             cv_pref = DECODE(print_tag, NULL, NULL, cv_pref),
             cv_no = DECODE(print_tag, NULL, NULL, cv_no);
   END;
   
   PROCEDURE update_tags(
      p_fund_cd               giis_funds.fund_cd%TYPE,
      p_iss_cd                giac_comm_voucher_ext.iss_cd%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_user_id               giac_comm_voucher_ext.user_id%TYPE
   )
   IS
      v_branch_cd             giac_doc_sequence.branch_cd%TYPE;
   BEGIN
      UPDATE giac_comm_voucher_ext_temp
         SET print_tag = 'P',
             printed_flag = 'Y',
             generate_flag = NULL
       WHERE intm_no = p_intm_no
         AND iss_cd = p_iss_cd
         AND NVL(print_tag, 'N') <> 'P'
         AND cv_pref IS NOT NULL
         AND cv_no IS NOT NULL;
         
		UPDATE giac_comm_voucher_ext	
		 	SET include_tag = NULL,
		 	    print_tag = 'P',
             cv_no = p_cv_no,
             cv_pref = p_cv_pref,
		 	    cv_date = TRUNC(SYSDATE)
		 WHERE iss_cd = p_iss_cd
	   	AND intm_no = p_intm_no
         AND NVL(print_tag, 'N') <> 'P'
         AND cv_pref IS NULL
         AND cv_no IS NULL;
      
      BEGIN
         SELECT b.grp_iss_cd
           INTO v_branch_cd
           FROM giac_doc_sequence a,
                giis_user_grp_hdr b, 
                giis_users c 
          WHERE doc_name = 'COMM_VCR'
            AND a.branch_cd = b.grp_iss_cd
            AND a.fund_cd = p_fund_cd
            AND b.user_grp = c.user_grp
            AND c.user_id = p_user_id;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      UPDATE giac_doc_sequence
         SET doc_seq_no = doc_seq_no + 1
       WHERE fund_cd = p_fund_cd
         AND branch_cd = v_branch_cd   	          												
         AND doc_name  = 'COMM_VCR';
   END;
   
   FUNCTION check_policy_status(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   )
     RETURN VARCHAR2
   IS
      v_result                VARCHAR2(100);
      v_spoiled_exists        BOOLEAN := FALSE;
      v_cancelled_exists      BOOLEAN := FALSE;
      v_count_all             NUMBER := 0;
      v_count                 NUMBER := 0;
   BEGIN
      FOR i IN(SELECT pol_flag
                 FROM TABLE(giacs251_pkg.get_batch_comm_voucher_dtl(p_intm_no, p_cv_pref, p_cv_no, NULL, NULL, NULL, NULL, NULL, NULL, NULL)))
      LOOP
         IF i.pol_flag = '4' THEN	-- AFP SR-18481 : shan 05.21.2015
            v_cancelled_exists := TRUE;
            v_count := v_count + 1;
         ELSIF i.pol_flag = '5' THEN	-- AFP SR-18481 : shan 05.21.2015
            v_spoiled_exists := TRUE;
            v_count := v_count + 1;
         END IF;
         v_count_all := v_count_all + 1;
      END LOOP;
      
      IF v_count_all = v_count AND v_count_all <> 0 THEN
         v_result := 'A';
      ELSIF v_cancelled_exists AND v_spoiled_exists THEN
         v_result := 'B';
      ELSIF v_cancelled_exists THEN
         v_result := 'C';
      ELSIF v_spoiled_exists THEN
         v_result := 'S';
      ELSE
         v_result := 'N';
      END IF;
      
      RETURN v_result;
   END;
   
    -- used when module is called by GIACS158 : shan 03.25.2015 -- start - AFP SR-18481 : shan 05.21.2015
    
    FUNCTION get_comm_due_listing(
        p_bank_file_no      GIAC_BANK_COMM_PAYT_SUM_EXT.BANK_FILE_NO%TYPE
    ) RETURN comm_due_tab PIPELINED
    AS
        rec     comm_due_type;
    BEGIN
        FOR i IN (SELECT bank_file_no, CV_PREF, CV_NO, intm_no, SUM(net_comm_due) net_comm_due 
                    FROM GIAC_BANK_COMM_PAYT_SUM_EXT 
                   WHERE bank_file_no = p_bank_file_no
                   GROUP BY bank_file_no, CV_NO, CV_PREF, intm_no
                   ORDER BY intm_no)
        LOOP
            rec.bank_file_no    := i.bank_file_no;
            rec.cv_pref         := i.cv_pref;
            rec.cv_no           := i.cv_no;
            rec.intm_no         := i.intm_no;
            rec.net_comm_due    := i.net_comm_due;
            
            FOR j IN (SELECT a.intm_name, b.intm_name parent_intm_name 
                        FROM giis_intermediary a, giis_intermediary b
                       WHERE a.intm_no = i.intm_no
                         AND b.intm_no(+) = a.parent_intm_no)
            LOOP
                rec.intm_name := j.intm_name;
                rec.parent_intm_name := j.parent_intm_name;
                EXIT;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_comm_due_listing;
    
    
    PROCEDURE gen_cv_number_comm_due(
        p_bank_file_no          giac_bank_comm_payt_sum_ext.BANK_FILE_NO%TYPE,
        p_intm_no               GIAC_BANK_COMM_PAYT_SUM_EXT.INTM_NO%TYPE,
        p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
        p_cv_no        IN OUT   giac_comm_voucher_ext.cv_no%TYPE
    )
    IS
        v_cv_no                 giac_comm_voucher_ext.cv_no%TYPE;
        --v_intm_list             CLOB := SUBSTR(p_intm_list, 2, (LENGTH(p_intm_list) - 2));
    BEGIN
        v_cv_no := p_cv_no;
               
        /*FOR i IN(SELECT *
                   FROM TABLE(GIACS251_PKG.GET_COMM_DUE_LISTING(p_bank_file_no))
                  WHERE cv_pref IS NULL
                    AND cv_no IS NULL
                    AND intm_no IN (SELECT column_value
                                      FROM TABLE (GIACS180_PKG.CLOB_TO_TABLE(v_intm_list, ',')) )
                  ORDER BY intm_no)
        LOOP*/
            UPDATE GIAC_BANK_COMM_PAYT_SUM_EXT
               SET cv_pref = p_cv_pref,
                   cv_no = v_cv_no
             WHERE intm_no = p_intm_no
               AND bank_file_no = p_bank_file_no;
                                    
            --v_cv_no := v_cv_no + 1;
        --END LOOP;
        
        p_cv_no := v_cv_no;
    END gen_cv_number_comm_due;
    
    
    FUNCTION get_comm_due_dtl(
        p_intm_no      GIAC_BANK_COMM_PAYT_SUM_EXT.INTM_NO%TYPE
    ) RETURN comm_due_dtl_tab PIPELINED
    AS
        rec     comm_due_dtl_type;
    BEGIN
        FOR i IN  ( SELECT cv_pref, cv_no, intm_no, policy_id, iss_cd, prem_seq_no, bank_file_no, 
                           SUM (premium_paid) premium_paid, SUM (commission_due) commission_due, 
                           SUM (wholding_tax_due) wholding_tax_due, SUM (input_vat_due) input_vat_due, 
                           SUM (net_comm_due) net_comm_due, SUM (commission_amt) inv_comm_amt, 
                           SUM (wholding_tax) inv_whtax_amt, SUM (input_vat) inv_input_vat, 
                           SUM (net_comm_paid) net_comm_paid 
                      FROM giac_bank_comm_payt_sum_ext 
                     WHERE intm_no = NVL(p_intm_no, intm_no)
                     GROUP BY cv_pref, cv_no, intm_no, policy_id, iss_cd, prem_seq_no, bank_file_no)
        LOOP
            rec.bank_file_no    := i.bank_file_no;
            rec.cv_pref         := i.cv_pref;
            rec.cv_no           := i.cv_no;
            rec.policy_id       := i.policy_id;
            rec.iss_cd          := i.iss_cd;
            rec.prem_seq_no     := i.prem_seq_no;
            rec.premium_paid    := i.premium_paid;
            rec.commission_due  := i.commission_due;
            rec.wholding_tax_due := i.wholding_tax_due;
            rec.input_vat_due   := i.input_vat_due;
            rec.net_comm_due    := i.net_comm_due;
            rec.inv_comm_amt    := i.inv_comm_amt;
            rec.inv_whtax_amt   := i.inv_whtax_amt;
            rec.inv_input_vat   := i.inv_input_vat;
            rec.net_comm_paid   := i.net_comm_paid;
            
            FOR j IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = i.intm_no)
            LOOP
                rec.intm_name := j.intm_name;
              EXIT;
            END LOOP;

            FOR j IN (SELECT get_policy_no(i.policy_id) policy_no
                        FROM dual)
            LOOP
                rec.policy_no := j.policy_no;
            END LOOP;

            PIPE ROW(rec);
        END LOOP;
    END get_comm_due_dtl;
    
    
    PROCEDURE update_comm_due_tags(
        p_fund_cd               giis_funds.fund_cd%TYPE,
        p_bank_file_no          GIAC_BANK_COMM_PAYT_SUM_EXT.BANK_FILE_NO%TYPE,
        p_intm_no               GIAC_BANK_COMM_PAYT_SUM_EXT.intm_no%TYPE,
        p_cv_no                 GIAC_BANK_COMM_PAYT_SUM_EXT.cv_no%TYPE,
        p_cv_pref               GIAC_BANK_COMM_PAYT_SUM_EXT.cv_pref%TYPE,
        p_user_id               giac_comm_voucher_ext.user_id%TYPE,
        p_to_revert             VARCHAR2
    )
    AS
        v_branch_cd             giac_doc_sequence.branch_cd%TYPE;
    BEGIN      
        BEGIN
            SELECT b.grp_iss_cd
              INTO v_branch_cd
              FROM giac_doc_sequence a,
                   giis_user_grp_hdr b, 
                   giis_users c 
             WHERE doc_name = 'COMM_VCR'
               AND a.branch_cd = b.grp_iss_cd
               AND a.fund_cd = p_fund_cd
               AND b.user_grp = c.user_grp
               AND c.user_id = p_user_id;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        
        IF p_to_revert <> 'Y' THEN   -- update before print
            UPDATE giac_comm_voucher_ext	
               SET include_tag = 'Y',
                   print_tag = 'P',
                   cv_no = p_cv_no,
                   cv_pref = p_cv_pref,
                   cv_date = TRUNC(SYSDATE)
             WHERE bank_file_no = p_bank_file_no
               AND intm_no = p_intm_no
               AND NVL(print_tag, 'N') <> 'P'
               AND cv_pref IS NULL
               AND cv_no IS NULL;
                                
            UPDATE giac_doc_sequence
               SET doc_seq_no = doc_seq_no + 1
             WHERE fund_cd = p_fund_cd
               AND branch_cd = v_branch_cd   	          												
               AND doc_name  = 'COMM_VCR';
        ELSE -- revert
            UPDATE giac_comm_voucher_ext	
               SET include_tag = 'Y',
                   print_tag = NULL,
                   cv_no = NULL,
                   cv_pref = NULL,
                   cv_date = NULL
             WHERE bank_file_no = p_bank_file_no
               AND intm_no = p_intm_no
               AND NVL(print_tag, 'N') <> 'P'
               AND cv_pref = p_cv_pref
               AND cv_no = p_cv_no;
                                
            UPDATE giac_doc_sequence
               SET doc_seq_no = doc_seq_no - 1
             WHERE fund_cd = p_fund_cd
               AND branch_cd = v_branch_cd   	          												
               AND doc_name  = 'COMM_VCR';
        END IF;
    END update_comm_due_tags;
    -- end - AFP SR-18481 : shan 05.21.2015
END;
/
