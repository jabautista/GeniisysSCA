CREATE OR REPLACE PACKAGE BODY CPI.giacr408_pkg
AS
   FUNCTION get_giacr408_detail(
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE,
      p_iss_cd          gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_comm_invoice.prem_seq_no%TYPE,
      p_fund_cd         giac_new_comm_inv.fund_cd%TYPE,
      p_branch_cd       giac_new_comm_inv.branch_cd%TYPE
   ) RETURN giacr408_detail_tab PIPELINED IS
      detail            giacr408_detail_type;
   BEGIN
      detail.print_acct_entries := 'N';
      BEGIN
         FOR a IN (SELECT gacc_tran_id
                     FROM gipi_comm_invoice
                    WHERE prem_seq_no = p_prem_seq_no 
                      AND iss_cd = p_iss_cd)
         LOOP
            IF a.gacc_tran_id IS NULL
            THEN
               detail.print_acct_entries := 'N';
            ELSE
               detail.print_acct_entries := 'Y';
            END IF;
         END LOOP;
      END;
      
      FOR i IN (SELECT RTRIM (a.iss_cd) iss_cd, a.prem_seq_no prem_seq_no, a.intrmdry_intm_no intm_no, b.intm_name intm_name, 
                       a.share_percentage, a.premium_amt, a.commission_amt, a.wholding_tax, a.policy_id,
                       DECODE (f.endt_seq_no, 0, f.line_cd || '-' || f.subline_cd || '-' || f.iss_cd || '-' || 
                       LTRIM(TO_CHAR(f.issue_yy,'09')) || '-' || 
                       LTRIM(TO_CHAR(f.pol_seq_no, '0999999')) || '-' || 
                       LTRIM(TO_CHAR(f.renew_no, '09')),f.line_cd || '-' || f.subline_cd || '-' || f.iss_cd || '-' || 
                       LTRIM(TO_CHAR(f.issue_yy,'09')) || '-' || 
                       LTRIM(TO_CHAR(f.pol_seq_no, '0999999')) || '-' || 
                       LTRIM(TO_CHAR(f.renew_no, '09')) || '/' ||f.endt_iss_cd || '-' || 
                       LTRIM(TO_CHAR(f.endt_yy, '09')) || '-' || 
                       LTRIM(TO_CHAR(f.endt_seq_no, '099999'))) policy_no,
                       h.assd_name, i.post_date, i.posted_by,
                       LTRIM (i.tran_no) tran_no
                  FROM gipi_comm_invoice a, giis_intermediary b, gipi_polbasic f,
                       gipi_parlist g, giis_assured h, giac_new_comm_inv i
                 WHERE a.intrmdry_intm_no = b.intm_no
                   AND a.policy_id = f.policy_id
                   AND f.par_id = g.par_id
                   AND g.assd_no = h.assd_no
                   AND i.iss_cd = a.iss_cd 
                   AND i.prem_seq_no = a.prem_seq_no
                   AND i.intm_no = a.intrmdry_intm_no
                   AND i.comm_rec_id = p_comm_rec_id
                   AND a.iss_cd = p_iss_cd
                   AND a.prem_seq_no = p_prem_seq_no
                   AND i.fund_cd = p_fund_cd
                   AND i.branch_cd = p_branch_cd)
      LOOP
         detail.iss_cd            := i.iss_cd;
         detail.prem_seq_no       := i.prem_seq_no;
         detail.intm_no           := i.intm_no;
         detail.intm_name         := i.intm_name;
         detail.share_percentage  := i.share_percentage;
         detail.premium_amt       := i.premium_amt;
         detail.commission_amt    := i.commission_amt;
         detail.wholding_tax      := i.wholding_tax;
         detail.policy_id         := i.policy_id;
         detail.policy_no         := i.policy_no;
         detail.assd_name         := i.assd_name;
         detail.post_date         := i.post_date;
         detail.posted_by         := i.posted_by;
         detail.tran_no           := i.tran_no;
         
         FOR jv IN (SELECT a.tran_class, TO_CHAR(a.jv_no) jv_no 
                      FROM giac_acctrans a, gipi_comm_invoice b
                     WHERE a.tran_id = b.gacc_tran_id
                       AND b.iss_cd = p_iss_cd
                       AND b.prem_seq_no = p_prem_seq_no)
         LOOP
            detail.jv_no := jv.tran_class||'-'||jv.jv_no;
         END LOOP;
         
         FOR xy IN (SELECT b.intm_name prnt_intm_name
                        FROM gipi_comm_invoice a, giis_intermediary b 
                        WHERE a.intrmdry_intm_no = i.intm_no
                          AND a.iss_cd = p_iss_cd            --Deo [02.14.2017]: SR-23855
                          AND a.prem_seq_no = p_prem_seq_no  --Deo [02.14.2017]: SR-23855
                        AND a.parent_intm_no = b.intm_no)
         LOOP
            detail.prnt_intm_name := xy.prnt_intm_name;
         END LOOP;
         
         PIPE ROW(detail);
      END LOOP;
   END get_giacr408_detail;
   
   FUNCTION get_giacr408_peril(
      p_iss_cd          gipi_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no     gipi_comm_inv_peril.prem_seq_no%TYPE,
      p_policy_id       gipi_polbasic.policy_id%TYPE
   ) RETURN giacr408_peril_tab PIPELINED IS
      peril             giacr408_peril_type;
      v_line            VARCHAR2(2);
   BEGIN
      SELECT line_cd
        INTO v_line
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id;
   
      FOR i IN (SELECT b.iss_cd, b.prem_seq_no, b.intrmdry_intm_no intm_no,
                       b.premium_amt prem_prl, b.peril_cd, b.commission_amt comm_prl,
                       b.commission_rt, b.wholding_tax wtax_prl  
                  FROM gipi_comm_inv_peril b
                 WHERE b.iss_cd = p_iss_cd
                   AND b.prem_seq_no = p_prem_seq_no)
      LOOP
         peril.iss_cd        := i.iss_cd;
         peril.prem_seq_no   := i.prem_seq_no;
         peril.intm_no       := i.intm_no;
         peril.prem_prl      := i.prem_prl;
         peril.peril_cd      := i.peril_cd;
         peril.comm_prl      := i.comm_prl;
         peril.commission_rt := i.commission_rt;
         peril.wtax_prl      := i.wtax_prl;
         
         FOR j IN (SELECT peril_name
                     FROM giis_peril
                    WHERE line_cd = v_line
                      AND peril_cd = i.peril_cd)
         LOOP
            peril.peril_name := j.peril_name;
         END LOOP;
         
         PIPE ROW(peril);
      END LOOP;
   END get_giacr408_peril;
   
   FUNCTION get_giacr408_prev_comm_inv(
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE
   ) RETURN giacr408_prev_comm_inv_tab PIPELINED IS
      prev              giacr408_prev_comm_inv_type;
   BEGIN
      FOR i IN (SELECT d.iss_cd, d.prem_seq_no, a.intm_no ,e.intm_name intm_name, a.comm_rec_id, a.tran_no, 
                       a.share_percentage, a.premium_amt, a.commission_amt, a.wholding_tax, d.policy_id
                  FROM giac_prev_comm_inv a, giac_new_comm_inv d, giis_intermediary e
                 WHERE d.intm_no = e.intm_no
                   AND d.iss_cd = p_iss_cd
                   AND d.prem_seq_no = p_prem_seq_no
                   AND d.comm_rec_id = p_comm_rec_id
                   AND a.comm_rec_id = d.comm_rec_id
                   AND a.intm_no = d.intm_no
                   AND a.fund_cd = d.fund_cd
                   AND a.branch_cd = d.branch_cd)
      LOOP
         prev.iss_cd            := i.iss_cd;                                         
         prev.prem_seq_no       := i.prem_seq_no;
         prev.intm_no           := i.intm_no;
         prev.intm_name         := i.intm_name;
         prev.comm_rec_id       := i.comm_rec_id;
         prev.tran_no           := i.tran_no;
         prev.share_percentage  := i.share_percentage;
         prev.premium_amt       := i.premium_amt;
         prev.commission_amt    := i.commission_amt;
         prev.wholding_tax      := i.wholding_tax;
         prev.policy_id         := i.policy_id;
      
      FOR yz IN (SELECT b.intm_name prnt_intm_name
                        FROM giac_prev_comm_inv a, giis_intermediary b 
                        WHERE a.intm_no = i.intm_no
                          AND a.comm_rec_id = i.comm_rec_id  --Deo [02.14.2017]: SR-23855
                        AND a.parent_intm_no = b.intm_no)
         LOOP
            prev.prnt_intm_name := yz.prnt_intm_name;
         END LOOP;
      
         PIPE ROW (prev);
      END LOOP;
   END get_giacr408_prev_comm_inv;
   
   FUNCTION get_giacr408_prev_peril(
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,
      p_comm_rec_id     giac_prev_comm_inv_peril.comm_rec_id%TYPE,
      p_policy_id       gipi_polbasic.policy_id%TYPE
   ) RETURN giacr408_prev_peril_tab PIPELINED IS
      prev_peril        giacr408_prev_peril_type;
      v_line            VARCHAR2(2);
   BEGIN
      SELECT line_cd
        INTO v_line
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id;
       
      FOR i IN (SELECT c.iss_cd, c.prem_seq_no, b.intm_no, b.comm_rec_id, b.tran_no, b.premium_amt prem_prl, 
                       b.peril_cd, b.commission_amt comm_prl, b.commission_rt, b.wholding_tax wtax_prl  
                  FROM giac_prev_comm_inv_peril b, giac_new_comm_inv c
                 WHERE c.iss_cd = p_iss_cd
                   AND c.prem_seq_no = p_prem_seq_no
                   AND b.comm_rec_id = p_comm_rec_id
                   AND b.comm_rec_id = c.comm_rec_id
                   AND b.intm_no = c.intm_no)
      LOOP
         prev_peril.iss_cd            := i.iss_cd;
         prev_peril.prem_seq_no       := i.prem_seq_no;
         prev_peril.intm_no           := i.intm_no;
         prev_peril.comm_rec_id       := i.comm_rec_id;
         prev_peril.tran_no           := i.tran_no;
         prev_peril.prem_prl          := i.prem_prl;
         prev_peril.peril_cd          := i.peril_cd;
         prev_peril.comm_prl          := i.comm_prl;
         prev_peril.commission_rt     := i.commission_rt;
         prev_peril.wtax_prl          := i.wtax_prl;
         
         FOR j IN (SELECT peril_name
                     FROM giis_peril
                    WHERE line_cd = v_line
                      AND peril_cd = i.peril_cd)
         LOOP
            prev_peril.peril_name := j.peril_name;
         END LOOP;
      
         PIPE ROW(prev_peril);
      END LOOP;
   END get_giacr408_prev_peril;      
   
   FUNCTION get_giacr408_new_acct_entries(
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,  
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE
   ) RETURN giacr408_new_acct_entries_tab PIPELINED IS
      new_acct          giacr408_new_acct_entries_type;
   BEGIN
      FOR i IN (SELECT SUM(e.gl_acct_category)||'-'||
                       SUM(e.gl_control_acct)||'-'||
                       SUM(e.gl_sub_acct_1)||'-'||
                       SUM(e.gl_sub_acct_2)||'-'||
                       SUM(e.gl_sub_acct_3)||'-'||
                       SUM(e.gl_sub_acct_4)||'-'||
                       SUM(e.gl_sub_acct_5)||'-'||
                       SUM(e.gl_sub_acct_6)||'-'||
                       SUM(e.gl_sub_acct_7) account_no,
                       f.gl_acct_sname sname, SUM(e.sl_cd) sl_code, e.debit_amt, e.credit_amt
                  FROM giac_new_comm_inv a, gipi_comm_invoice b, giac_acctrans d, 
                       giac_acct_entries e, giac_chart_of_accts f
                 WHERE a.policy_id = b.policy_id
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.intm_no = b.intrmdry_intm_no
                   AND a.prem_seq_no = p_prem_seq_no
                   AND a.iss_cd = p_iss_cd
                   AND a.comm_rec_id = p_comm_rec_id
                   AND b.gacc_tran_id = d.tran_id
                   AND d.tran_flag <> 'D'
                   AND NOT EXISTS (SELECT x.gacc_tran_id
                                     FROM giac_reversals x, giac_acctrans  y
                                    WHERE x.reversing_tran_id = y.tran_id
                                      AND y.tran_flag <> 'D'
                                      AND x.gacc_tran_id = b.gacc_tran_id)
                   AND d.tran_id = e.gacc_tran_id
                   AND e.gl_acct_id = f.gl_acct_id
                   AND b.gacc_tran_id IS NOT NULL
                 GROUP BY e.gl_acct_category||'-'||
                          e.gl_control_acct||'-'||
                          e.gl_sub_acct_1||'-'||
                          e.gl_sub_acct_2||'-'||
                          e.gl_sub_acct_3||'-'||
                          e.gl_sub_acct_4||'-'||
                          e.gl_sub_acct_5||'-'||
                          e.gl_sub_acct_6||'-'||
                          e.gl_sub_acct_7,
                          f.gl_acct_sname,
                          e.sl_cd,
                          e.debit_amt,
                          e.credit_amt)
      LOOP
         new_acct.account_no        := i.account_no;
         new_acct.sname             := i.sname;
         new_acct.sl_code           := i.sl_code;
         new_acct.debit_amt         := i.debit_amt;
         new_acct.credit_amt        := i.credit_amt;
         
         PIPE ROW(new_acct);
      END LOOP;
   END get_giacr408_new_acct_entries;
   
   FUNCTION get_giacr408_rev_acct_entries(
      p_prem_seq_no     giac_new_comm_inv.prem_seq_no%TYPE,  
      p_iss_cd          giac_new_comm_inv.iss_cd%TYPE,
      p_comm_rec_id     giac_new_comm_inv.comm_rec_id%TYPE
   ) RETURN giacr408_rev_acct_entries_tab PIPELINED IS
      rev_acct          giacr408_rev_acct_entries_type;
   BEGIN
      FOR i IN (SELECT SUM(d.gl_acct_category)||'-'||
                       SUM(d.gl_control_acct)||'-'||
                       SUM(d.gl_sub_acct_1)||'-'||
                       SUM(d.gl_sub_acct_2)||'-'||
                       SUM(d.gl_sub_acct_3)||'-'||
                       SUM(d.gl_sub_acct_4)||'-'||
                       SUM(d.gl_sub_acct_5)||'-'||
                       SUM(d.gl_sub_acct_6)||'-'||
                       SUM(d.gl_sub_acct_7) account_no,
                       e.gl_acct_sname sname,
                       SUM(d.sl_cd) sl_code,
                       d.debit_amt,
                       d.credit_amt
                  FROM giac_new_comm_inv a, gipi_comm_invoice b, giac_acctrans c, 
                       giac_acct_entries d, giac_chart_of_accts e, giac_prev_comm_inv f
                 WHERE a.policy_id = b.policy_id
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.intm_no = b.intrmdry_intm_no
                   AND a.comm_rec_id = f.comm_rec_id
                   AND a.prem_seq_no = p_prem_seq_no
                   AND a.iss_cd = p_iss_cd
                   AND f.comm_rec_id = p_comm_rec_id
                   AND f.gacc_tran_id = c.tran_id
                   AND c.tran_flag <> 'D'
                   AND NOT EXISTS (SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans  y
                                  WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                    AND x.gacc_tran_id = b.gacc_tran_id)
                   AND c.tran_id = d.gacc_tran_id
                   AND d.gl_acct_id = e.gl_acct_id
                   AND b.gacc_tran_id IS NOT NULL
                 GROUP BY d.gl_acct_category||'-'||
                       d.gl_control_acct||'-'||
                       d.gl_sub_acct_1||'-'||
                       d.gl_sub_acct_2||'-'||
                       d.gl_sub_acct_3||'-'||
                       d.gl_sub_acct_4||'-'||
                       d.gl_sub_acct_5||'-'||
                       d.gl_sub_acct_6||'-'||
                       d.gl_sub_acct_7,
                       e.gl_acct_sname,
                       d.sl_cd,
                       d.debit_amt,
                       d.credit_amt)
      LOOP
         rev_acct.account_no        := i.account_no;
         rev_acct.sname             := i.sname;
         rev_acct.sl_code           := i.sl_code;
         rev_acct.debit_amt         := i.debit_amt;
         rev_acct.credit_amt        := i.credit_amt;
         
         PIPE ROW(rev_acct);
      END LOOP;
   END get_giacr408_rev_acct_entries; 
   
   FUNCTION get_giacr408_header
   RETURN giacr408_header_tab PIPELINED IS
      header            giacr408_header_type;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO header.company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            header.company := ' ';
      END;
      
      BEGIN
         SELECT param_value_v
           INTO header.address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            header.address := ' ';
      END;
      
      PIPE ROW(header);
   END get_giacr408_header;
   
END giacr408_pkg;
/
