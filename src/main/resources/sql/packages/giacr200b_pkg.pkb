CREATE OR REPLACE PACKAGE BODY CPI.giacr200b_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 06.13.2013
    **  Reference By : GIACR224 - STATEMENT OF ACCOUNTS
    */
   FUNCTION get_details (
      p_param         NUMBER,
      p_branch_code   gipi_invoice.iss_cd%TYPE,
      p_module_id     VARCHAR2,
      p_date          VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_exist  VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      BEGIN
         IF p_from_date = p_to_date
         THEN
            v_list.cf_top_date :=
               TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                        'fmMonth DD, YYYY'
                       );
         ELSE
            v_list.cf_top_date :=
                  'From '
               || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                           'fmMonth DD, YYYY'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                           'fmMonth DD, YYYY'
                          );
         END IF;
      END;

      BEGIN
         IF p_date = 1
         THEN
            v_list.based_on := 'Based on Transaction Date';
         ELSE
            v_list.based_on := 'Based on Posting Date';
         END IF;

         IF p_param = 1
         THEN
            v_list.based_on := v_list.based_on || '/Booked Policies ';
         ELSIF p_param = 2
         THEN
            v_list.based_on := v_list.based_on || '/Unbooked Policies ';
         ELSE
            v_list.based_on := v_list.based_on || '/All Policies ';
         END IF;
      END;
      
      v_exist := 'N';
      FOR i IN
         (SELECT   b.line_cd, a.b140_iss_cd, c.tran_flag, c.posting_date,
                   DECODE (b.acct_ent_date,
                           NULL, 'Unbooked Policies',
                           'Booked Policies'
                          ) pol_stat,
                   SUM (a.collection_amt) sum_collection_amt, SUM (a.premium_amt) sum_preium_amt,
                   SUM (a.tax_amt) sum_tax_amt
              FROM giac_direct_prem_collns a,
                   gipi_polbasic b,
                   giac_acctrans c,
                   gipi_invoice d,
                   gipi_parlist e,
                   giis_assured f,
                   gipi_comm_invoice g,
                   giis_intermediary h
             WHERE b.policy_id = d.policy_id
               AND d.iss_cd = a.b140_iss_cd
               AND d.prem_seq_no = a.b140_prem_seq_no
               AND a.gacc_tran_id = c.tran_id
               AND c.tran_id > 0
               AND c.tran_flag <> 'D'
               AND c.tran_class <> 'CP'
               AND g.intrmdry_intm_no = h.intm_no
               AND g.iss_cd = d.iss_cd
               AND g.prem_seq_no = d.prem_seq_no
               AND g.policy_id = d.policy_id
               AND (b.acct_ent_date IS NOT NULL OR p_param IN (2, 3))
               AND (b.acct_ent_date IS NULL OR p_param IN (1, 3))
               AND b.par_id = e.par_id
               AND e.assd_no = f.assd_no
               AND d.iss_cd = NVL (p_branch_code, d.iss_cd)
               --AND check_user_per_iss_cd_acctg (NULL, d.iss_cd, p_module_id) = 1
               AND ((SELECT access_tag
                          FROM giis_user_modules
                         WHERE userid = NVL (p_user_id, USER)   
                           AND module_id = 'GIACS200'
                           AND tran_cd IN (
                                  SELECT b.tran_cd         
                                    FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                   WHERE a.user_id = b.userid
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = d.iss_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS200')) = 1
                 OR (SELECT access_tag
                          FROM giis_user_grp_modules
                         WHERE module_id = 'GIACS200'
                           AND (user_grp, tran_cd) IN (
                                  SELECT a.user_grp, b.tran_cd
                                    FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                   WHERE a.user_grp = b.user_grp
                                     AND a.user_id = NVL (p_user_id, USER)
                                     AND b.iss_cd = d.iss_cd
                                     AND b.tran_cd = c.tran_cd
                                     AND c.module_id = 'GIACS200')) = 1
               )
               AND TRUNC (DECODE (p_date, 1, c.tran_date, c.posting_date))
                      BETWEEN TO_DATE (p_from_date, 'MM-DD-YYYY')
                          AND TO_DATE (p_to_date, 'MM-DD-YYYY')
               AND NOT EXISTS (
                      SELECT x.gacc_tran_id
                        FROM giac_reversals x, giac_acctrans y
                       WHERE x.reversing_tran_id = y.tran_id
                         AND y.tran_flag <> 'D'
                         AND x.gacc_tran_id = a.gacc_tran_id)
          GROUP BY b.line_cd,
                   a.b140_iss_cd,
                   c.tran_flag,
                   c.posting_date,
                   DECODE (b.acct_ent_date,
                           NULL, 'Unbooked Policies',
                           'Booked Policies'
                          )
          ORDER BY a.b140_iss_cd, pol_stat, b.line_cd, c.tran_flag, c.posting_date) -- added pol_stat by jdiago 07302014
      LOOP
         v_exist := 'Y';
         v_list.b140_iss_cd := i.b140_iss_cd;
         v_list.pol_stat := i.pol_stat;
         v_list.line_cd := i.line_cd;
         v_list.tran_flag := i.tran_flag;
         v_list.posting_date := i.posting_date;
         v_list.sum_preium_amt := i.sum_preium_amt;
         v_list.sum_collection_amt := i.sum_collection_amt;
         v_list.sum_tax_amt := i.sum_tax_amt;

         BEGIN
            SELECT iss_name
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = i.b140_iss_cd;
         END;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         END;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_exist = 'N' THEN
        v_list.exist := 'Y';
        PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_details;
END giacr200b_pkg;
/


