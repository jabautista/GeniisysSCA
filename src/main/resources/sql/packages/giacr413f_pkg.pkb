CREATE OR REPLACE PACKAGE BODY CPI.giacr413f_pkg
AS
   FUNCTION get_giacr413f_company_nm
      RETURN VARCHAR2
   IS
      v_company   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giac_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
   END get_giacr413f_company_nm;

   FUNCTION get_giacr413f_company_add
      RETURN VARCHAR2
   IS
      v_company_add   VARCHAR2 (400);
   BEGIN
      SELECT param_value_v
        INTO v_company_add
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_company_add);
   END get_giacr413f_company_add;

   FUNCTION get_giacr413f_period (p_from_dt DATE, p_to_dt DATE)
      RETURN VARCHAR2
   IS
      v_period   VARCHAR2 (50);
   BEGIN
      SELECT 'From ' || TO_CHAR (p_from_dt, 'fm Month dd, yyyy') || ' to ' || TO_CHAR (p_to_dt, 'fm Month dd, yyyy')
        INTO v_period
        FROM DUAL;

      RETURN (v_period);
   END get_giacr413f_period;

   FUNCTION get_giacr413f_tran_post (p_tran_post VARCHAR2)
      RETURN VARCHAR2
   IS
      v_tran_post   VARCHAR2 (50);
   BEGIN
      IF p_tran_post = 1 THEN
         v_tran_post := 'Based on Transaction Date';
      ELSE
         v_tran_post := 'Based on Posting Date';
      END IF;

      RETURN (v_tran_post);
   END get_giacr413f_tran_post;

   FUNCTION get_giacr413f_iss_name (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_iss_name   VARCHAR2 (20);
   BEGIN
      SELECT iss_name
        INTO v_iss_name
        FROM giis_issource
       WHERE iss_cd = p_iss_cd;

      RETURN (v_iss_name);
   END get_giacr413f_iss_name;

   FUNCTION get_giacr413_intm (p_intm_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_intm_desc   VARCHAR2 (20);
   BEGIN
      SELECT intm_desc
        INTO v_intm_desc
        FROM giis_intm_type
       WHERE intm_type = p_intm_type;

      RETURN (v_intm_desc);
   END get_giacr413_intm;

   FUNCTION get_giacr413_comm (p_comm_amt NUMBER)
      RETURN NUMBER
   IS
      comm   VARCHAR2 (20);
   BEGIN
      IF p_comm_amt IS NULL THEN
         RETURN comm;
      ELSE
         RETURN p_comm_amt;
      END IF;
   END get_giacr413_comm;

   FUNCTION get_giacr413_wtax_formula (p_wtax NUMBER, p_wtax_amt NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_wtax_amt IS NULL THEN
         RETURN p_wtax;
      ELSE
         RETURN p_wtax_amt;
      END IF;
   END get_giacr413_wtax_formula;

   FUNCTION get_giacr413_input_vat (p_input_vat_amt NUMBER, p_input_vat NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      IF p_input_vat_amt IS NULL THEN
         RETURN p_input_vat;
      ELSE
         RETURN p_input_vat_amt;
      END IF;
   END get_giacr413_input_vat;

   FUNCTION get_giacr413f_records (
        p_branch    VARCHAR2, 
        p_from_dt   DATE, 
        p_intm_type VARCHAR2, 
        p_module_id VARCHAR2, 
        p_to_dt     DATE, 
        p_tran_post VARCHAR2, 
        p_user_id   VARCHAR2)
      RETURN giacr413f_record_tab PIPELINED
   IS
      v_list   giacr413f_record_type;
      v_is_empty VARCHAR2(1) := 'Y';
   BEGIN
   
      v_list.company_nm := get_giacr413f_company_nm;
      v_list.company_add := get_giacr413f_company_add;
      v_list.period := get_giacr413f_period (p_from_dt, p_to_dt);
      v_list.tran_post := get_giacr413f_tran_post (p_tran_post);
      
      FOR i IN (SELECT   d.intm_type, a.intm_no, e.line_cd, f.iss_cd, f.iss_cd || '-' || LPAD (f.prem_seq_no, 12, 0) AS f_iss_cd_f_prem_seq_no, d.intm_name, get_policy_no (e.policy_id) policy_no,
                         e.subline_cd, e.issue_yy, e.pol_seq_no, e.renew_no, e.endt_seq_no, a.comm_amt comm, a.wtax_amt wtax, a.input_vat_amt input_vat, c.inst_no, g.comm_amt, g.wtax_amt,
                         g.input_vat_amt, DECODE (g.comm_amt, NULL, NULL, g.ref_no || ' / ' || TO_CHAR (g.comm_slip_date, 'MM-DD-YYYY')) comm_voucher,
                         DECODE (b.tran_class,
                                 'JV', b.jv_pref_suff || '-' || LPAD (b.jv_no, 6, 0) || ' / ' || TO_CHAR (b.tran_date, 'MM-DD-YYYY'),
                                 'DV', h.dv_pref || '-' || LPAD (h.dv_no, 6, 0) || ' / ' || TO_CHAR (h.dv_date, 'MM-DD-YYYY'),
                                 'COL', i.or_pref_suf || '-' || LPAD (i.or_no, 6, 0) || ' / ' || TO_CHAR (i.or_date, 'MM-DD-YYYY')
                                ) TRANSACTION
                    FROM gipi_polbasic e,
                         giac_comm_payts a,
                         gipi_comm_invoice f,
                         giac_acctrans b,
                         giis_intermediary d,
                         gipi_installment c,
                         giac_disb_vouchers h,
                         giac_order_of_payts i,
                         (SELECT gacc_tran_id, comm_slip_pref || '-' || comm_slip_no ref_no, iss_cd || '-' || prem_seq_no bill_no, comm_amt, wtax_amt, input_vat_amt, comm_slip_date,
                                 iss_cd || '-' || prem_seq_no || '-' || intm_no REFERENCE
                            FROM giac_comm_fund_ext z
                           WHERE comm_slip_no IS NOT NULL AND NVL (spoiled_tag, 'N') = 'N' AND EXISTS (SELECT 1
                                                                                                         FROM giac_comm_payts
                                                                                                        WHERE iss_cd = z.iss_cd AND prem_seq_no = z.prem_seq_no AND intm_no = z.intm_no)
                          UNION ALL
                          /*SELECT cv_pref || '-' || LPAD (cv_no, 10, 0), iss_cd || '-' || prem_seq_no bill_no, commission_amt, wholding_tax, input_vat, cv_date,
                                 iss_cd || '-' || prem_seq_no || '-' || intm_no REFERENCE
                            FROM giac_comm_voucher_ext y
                           WHERE cv_no IS NOT NULL AND EXISTS (SELECT 1
                                                                 FROM giac_comm_payts
                                                                WHERE iss_cd = y.iss_cd AND prem_seq_no = y.prem_seq_no AND intm_no = y.intm_no)
                          */ -- modified by judyann 12132012; to get correct amounts for comm voucher  -- SR-11684 : shan 09.03.2015
                          SELECT p2.gacc_tran_id, cv_pref || '-' || LPAD (cv_no, 10, 0) ref_no,
                                 y.iss_cd || '-' || y.prem_seq_no bill_no,
                                 (commission_amt - p1.comm_amt) comm_amt,
                                 (wholding_tax - p1.wtax_amt) wtax_amt,
                                 (input_vat - p1.input_vat_amt) input_vat_amt, cv_date,
                                 y.iss_cd || '-' || y.prem_seq_no || '-'
                                 || y.intm_no reference
                            FROM giac_comm_voucher_ext y,
                                 (SELECT   gacc_tran_id, iss_cd, prem_seq_no, intm_no,
                                           SUM (comm_amt) comm_amt, SUM (wtax_amt) wtax_amt,
                                           SUM (input_vat_amt) input_vat_amt
                                      FROM giac_comm_payts m1
                                     WHERE EXISTS (
                                              SELECT '1'
                                                FROM giac_comm_fund_ext t1
                                               WHERE t1.gacc_tran_id = m1.gacc_tran_id
                                                 AND t1.iss_cd = m1.iss_cd
                                                 AND t1.prem_seq_no = m1.prem_seq_no
                                                 AND t1.intm_no = m1.intm_no
                                                 AND comm_slip_no IS NOT NULL
                                              UNION
                                              SELECT '1'
                                                FROM giac_comm_slip_ext s1
                                               WHERE s1.gacc_tran_id = m1.gacc_tran_id
                                                 AND s1.iss_cd = m1.iss_cd
                                                 AND s1.prem_seq_no = m1.prem_seq_no
                                                 AND s1.intm_no = m1.intm_no
                                                 AND comm_slip_no IS NOT NULL
                                                 )
                                  GROUP BY gacc_tran_id, iss_cd, prem_seq_no, intm_no) p1,
                                 (SELECT gacc_tran_id, iss_cd, prem_seq_no, intm_no
                                    FROM giac_comm_payts m2
                                   WHERE NOT EXISTS (
                                            SELECT '1'
                                              FROM giac_comm_fund_ext t2
                                             WHERE t2.gacc_tran_id = m2.gacc_tran_id
                                               AND t2.iss_cd = m2.iss_cd
                                               AND t2.prem_seq_no = m2.prem_seq_no
                                               AND t2.intm_no = m2.intm_no
                                               AND comm_slip_no IS NOT NULL
                                            UNION
                                              SELECT '1'
                                                FROM giac_comm_slip_ext s2
                                               WHERE s2.gacc_tran_id = m2.gacc_tran_id
                                                 AND s2.iss_cd = m2.iss_cd
                                                 AND s2.prem_seq_no = m2.prem_seq_no
                                                 AND s2.intm_no = m2.intm_no
                                                 AND comm_slip_no IS NOT NULL
                                               )) p2
                           WHERE cv_no IS NOT NULL
                             AND y.iss_cd = p1.iss_cd
                             AND y.prem_seq_no = p1.prem_seq_no
                             AND y.intm_no = p1.intm_no
                             AND y.iss_cd = p2.iss_cd
                             AND y.prem_seq_no = p2.prem_seq_no
                             AND y.intm_no = p2.intm_no
                           UNION ALL 
                          SELECT gacc_tran_id, comm_slip_pref || '-' || comm_slip_no, iss_cd || '-' || prem_seq_no bill_no, comm_amt, wtax_amt, input_vat_amt, comm_slip_date,
                                 iss_cd || '-' || prem_seq_no || '-' || intm_no REFERENCE
                            FROM giac_comm_slip_ext x
                           WHERE comm_slip_no IS NOT NULL AND EXISTS (SELECT 1
                                                                        FROM giac_comm_payts
                                                                       WHERE iss_cd = x.iss_cd AND prem_seq_no = x.prem_seq_no AND intm_no = x.intm_no)) g
                   WHERE d.intm_type = NVL (p_intm_type, d.intm_type)
                     AND ((p_tran_post = 1 AND TRUNC (b.tran_date) BETWEEN p_from_dt AND p_to_dt) OR (p_tran_post = 2 AND TRUNC (b.posting_date) BETWEEN p_from_dt AND p_to_dt))
                     AND b.tran_flag <> 'D'
                     --AND b.tran_flag <> 'CP' --mikel 12.12.2016;
                     AND b.tran_class NOT IN ('CP', 'CPR') --mikel 12.12.2016; SR 5874 - excluded transactions that are processed from cancelled policies module (GIACS412)
                     AND b.tran_id > 0
                     AND a.gacc_tran_id = b.tran_id
                     AND a.gacc_tran_id = h.gacc_tran_id(+)
                     AND a.gacc_tran_id = i.gacc_tran_id(+)
                     AND a.iss_cd = NVL (p_branch, a.iss_cd)
                     --AND check_user_per_iss_cd_acctg2 (NULL, a.iss_cd, p_module_id, p_user_id) = 1 --mikel 12.12.2016; 
                     AND EXISTS (SELECT 'X'
                                   FROM table (security_access.get_branch_line('AC', p_module_id, p_user_id))
                                  WHERE branch_cd = a.iss_cd) --mikel 12.12.2016; SR 5874 - optimization
                     AND f.intrmdry_intm_no > 0
                     AND f.iss_cd = a.iss_cd
                     AND f.prem_seq_no = a.prem_seq_no
                     AND a.intm_no = d.intm_no
                     AND e.policy_id = f.policy_id
                     AND c.iss_cd = f.iss_cd
                     AND c.prem_seq_no = f.prem_seq_no
                     AND a.intm_no = f.intrmdry_intm_no
                     AND a.iss_cd || '-' || a.prem_seq_no || '-' || a.intm_no = g.REFERENCE(+)
                     AND a.gacc_tran_id = g.gacc_tran_id(+)  -- SR-11684 : shan 09.03.2015
                     AND a.comm_amt = g.comm_amt(+)          -- SR-11684 : shan 09.03.2015
                     AND NOT EXISTS (SELECT c.gacc_tran_id
                                       FROM giac_reversals c, giac_acctrans d
                                      WHERE c.reversing_tran_id = d.tran_id AND d.tran_flag <> 'D' AND c.gacc_tran_id = a.gacc_tran_id)
                ORDER BY d.intm_type, d.intm_name, e.line_cd, e.subline_cd, e.issue_yy, e.pol_seq_no, e.renew_no, e.endt_seq_no)
      LOOP
         v_is_empty := 'N';
         v_list.intm_type := i.intm_type;
         v_list.intm_no := i.intm_no;
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.f_iss_cd_f_prem_seq_no;
         v_list.intm_name := i.intm_name;
         v_list.policy_no := i.policy_no;
         v_list.comm_voucher := i.comm_voucher;
         v_list.subline_cd := i.subline_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.comm_amt := i.comm_amt;

         --IF i.wtax_amt IS NULL THEN
            v_list.wtax_amt := i.wtax;
         --ELSE
         --   v_list.wtax_amt := i.wtax_amt;
         --END IF;

         --IF i.input_vat_amt IS NULL THEN
            v_list.input_vat_amt := i.input_vat;
         --ELSE
         --   v_list.input_vat_amt := i.input_vat_amt;
         --END IF;

         v_list.inst_no := i.inst_no;
         v_list.iss_name := get_giacr413f_iss_name (i.iss_cd);
         v_list.intm := get_giacr413_intm (i.intm_type);
         v_list.TRANSACTION := i.TRANSACTION;
         v_list.input_vat := get_giacr413_input_vat (i.input_vat, i.input_vat_amt);
         v_list.wtax_formula := get_giacr413_wtax_formula (i.wtax, i.wtax_amt);

         IF i.comm_amt IS NULL THEN
            v_list.comm := i.comm;
         ELSE
            v_list.comm := i.comm_amt;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_is_empty = 'Y' THEN
        PIPE ROW(v_list);
      END IF;
   END get_giacr413f_records;
END;
/