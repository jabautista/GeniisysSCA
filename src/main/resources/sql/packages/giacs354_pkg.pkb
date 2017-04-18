CREATE OR REPLACE PACKAGE BODY CPI.giacs354_pkg
AS
   FUNCTION select_gl_branch_line (
      p_module        VARCHAR2,
      p_item_no       NUMBER,
      p_tran_class    VARCHAR2,
      p_break_by      VARCHAR2,
      p_date_option   VARCHAR2,
      --T=Transaction Date or P=Posting Date by MAC 07/16/2013
      p_from_date     DATE,         --added for Losses Paid by MAC 07/16/2013
      p_to_date       DATE          --added for Losses Paid by MAC 07/16/2013
   )
      RETURN giacr354_gl_type PIPELINED
   IS
      v_giacr354_gl    giacr354_gl_rec_type;
      v_break_by       VARCHAR2 (5)         := p_break_by;
      v_treaty_level   NUMBER (2);

      --giac_module_entries.ca_treaty_type_level%TYPE;
      CURSOR gl_by_branch
      IS
         SELECT   e.gibr_branch_cd, c.gl_acct_name,
                  get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                  SUM (debit_amt) debit, SUM (credit_amt) credit,
                  SUM (debit_amt) - SUM (credit_amt) balance
             FROM giac_modules a,
                  giac_module_entries b,
                  giac_chart_of_accts c,
                  giac_acct_entries d,
                  giac_acctrans e
            WHERE 1 = 1
              AND a.module_id = b.module_id
              AND module_name = p_module
              AND b.item_no IN (p_item_no)
              AND c.gl_acct_category = d.gl_acct_category
              AND c.gl_control_acct = d.gl_control_acct
              AND c.gl_sub_acct_1 = d.gl_sub_acct_1
              AND c.gl_sub_acct_2 = d.gl_sub_acct_2
              AND c.gl_sub_acct_3 = d.gl_sub_acct_3
              AND c.gl_sub_acct_4 = d.gl_sub_acct_4
              AND c.gl_sub_acct_5 = d.gl_sub_acct_5
              AND c.gl_sub_acct_6 = d.gl_sub_acct_6
              AND c.gl_sub_acct_7 = d.gl_sub_acct_7
              AND d.gacc_tran_id = e.tran_id
              AND e.tran_flag IN ('C', 'P')
              AND (   (    e.tran_class = p_tran_class
                       AND p_date_option IS NOT NULL
                       AND p_module NOT IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                   OR (    e.tran_class IN ('COL', 'DV', 'BCS', 'JV', 'REV')
                       AND p_date_option IS NOT NULL
                       AND p_module IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                  )   --return true if based on Losses Paid by MAC 09/24/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          NVL (d.generation_type, 'Y')
                         ) NOT IN                           --mikel 03.14.2014
                                                                   ('X', 'C')
--do not retrieve Manual Entries and Loss Recovery if Losses Paid by MAC 07/16/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          DECODE (p_module,
                                  'GIACS017', d.generation_type,
                                  'GIACS018', d.generation_type,
                                  'X'
                                 )
                         ) NOT IN
                     (DECODE (p_module,
                              'GIACS017', '8',
                              
--do not include Inward Claim Payment if :p_module is GIACS017 by MAC 07/18/2013.
                              'GIACS018', 'K',
                              
--do not include Direct Claim Payment if :p_module is GIACS018 by MAC 07/18/2013.
                              'MAC'
                             )
                     )
--              AND (   (e.tran_flag <> 'D' AND NVL (p_date_option, 'P') != 'T'
--                      )
--                   OR (e.tran_flag = 'C' AND p_date_option = 'T')
--                  )
--check all Closed transaction only if based on Losses Paid by MAC 09/24/2013.
              AND c.leaf_tag = 'Y'
              --return true if based on Losses Paid by MAC 07/16/2013.
              /*AND (   (TO_CHAR (TRUNC (e.tran_date), 'MM-YYYY') =
                                             LPAD (p_mm, 2, 0) || '-'
                                             || p_year
                      )
                   OR (DECODE (p_date_option, NULL, 0, 1) = 1)
                  )*/
              --check if Tran Date or Posting Date is between parameter date if Losses Paid otherwise return true by MAC 07/16/2013.
              AND (   (DECODE (p_date_option,
                               'T', TRUNC (e.tran_date),
                               'P', TRUNC (e.posting_date)
                              ) BETWEEN p_from_date AND p_to_date
                      )
                   OR (DECODE (p_date_option, NULL, 1, 0) = 1)
                  )
              AND b.gl_acct_category = c.gl_acct_category
              AND b.gl_control_acct = c.gl_control_acct
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          DECODE (b.gl_sub_acct_1,
                                  0, c.gl_sub_acct_1,
                                  b.gl_sub_acct_1
                                 )
                         ) = c.gl_sub_acct_1
              AND DECODE (b.line_dependency_level,
                          2, d.gl_sub_acct_2,
                          DECODE (b.gl_sub_acct_2,
                                  0, c.gl_sub_acct_2,
                                  b.gl_sub_acct_2
                                 )
                         ) = c.gl_sub_acct_2
              AND DECODE (b.line_dependency_level,
                          3, d.gl_sub_acct_3,
                          DECODE (b.gl_sub_acct_3,
                                  0, c.gl_sub_acct_3,
                                  b.gl_sub_acct_3
                                 )
                         ) = c.gl_sub_acct_3
              AND DECODE (b.line_dependency_level,
                          4, d.gl_sub_acct_4,
                          DECODE (b.gl_sub_acct_4,
                                  0, c.gl_sub_acct_4,
                                  b.gl_sub_acct_4
                                 )
                         ) = c.gl_sub_acct_4
         GROUP BY e.gibr_branch_cd, c.gl_acct_name, d.gl_acct_id;

      CURSOR gl_by_branch_line
      IS
         SELECT   e.gibr_branch_cd, c.gl_acct_name, f.line_cd,
                  get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                  SUM (debit_amt) debit, SUM (credit_amt) credit,
                  SUM (debit_amt) - SUM (credit_amt) balance
             FROM giac_modules a,
                  giac_module_entries b,
                  giac_chart_of_accts c,
                  giac_acct_entries d,
                  giac_acctrans e,
                  giis_line f
            WHERE 1 = 1
              AND a.module_id = b.module_id
              AND module_name = p_module
              AND b.item_no IN (p_item_no)
              AND c.gl_acct_category = d.gl_acct_category
              AND c.gl_control_acct = d.gl_control_acct
              AND c.gl_sub_acct_1 = d.gl_sub_acct_1
              AND c.gl_sub_acct_2 = d.gl_sub_acct_2
              AND c.gl_sub_acct_3 = d.gl_sub_acct_3
              AND c.gl_sub_acct_4 = d.gl_sub_acct_4
              AND c.gl_sub_acct_5 = d.gl_sub_acct_5
              AND c.gl_sub_acct_6 = d.gl_sub_acct_6
              AND c.gl_sub_acct_7 = d.gl_sub_acct_7
              AND d.gacc_tran_id = e.tran_id
              AND e.tran_flag IN ('C', 'P')
              AND (   (    e.tran_class = p_tran_class
                       AND p_date_option IS NOT NULL
                       AND p_module NOT IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                   OR (    e.tran_class IN ('COL', 'DV', 'BCS', 'JV', 'REV')
                       AND p_date_option IS NOT NULL
                       AND p_module IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                  )   --return true if based on Losses Paid by MAC 09/24/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          NVL (d.generation_type, 'Y')
                         ) NOT IN                           --mikel 03.14.2014
                                                                   ('X', 'C')
--do not retrieve Manual Entries and Loss Recovery if Losses Paid by MAC 07/16/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          DECODE (p_module,
                                  'GIACS017', d.generation_type,
                                  'GIACS018', d.generation_type,
                                  'X'
                                 )
                         ) NOT IN
                     (DECODE (p_module,
                              'GIACS017', '8',
                              
--do not include Inward Claim Payment if p_module is GIACS017 by MAC 07/18/2013.
                              'GIACS018', 'K',
                              
--do not include Direct Claim Payment if p_module is GIACS018 by MAC 07/18/2013.
                              'MAC'
                             )
                     )
--              AND (   (e.tran_flag <> 'D' AND NVL (p_date_option, 'P') != 'T'
--                      )
--                   OR (e.tran_flag = 'C' AND p_date_option = 'T')
--                  )
--check all Closed transaction only if based on Losses Paid by MAC 09/24/2013.
              AND c.leaf_tag = 'Y'
              --return true if based on Losses Paid by MAC 07/16/2013.
              /*AND (   (TO_CHAR (TRUNC (e.tran_date), 'MM-YYYY') =
                                             LPAD (p_mm, 2, 0) || '-'
                                             || p_year
                      )
                   OR (DECODE (p_date_option, NULL, 0, 1) = 1)
                  )*/
              --check if Tran Date or Posting Date is between parameter date if Losses Paid otherwise return true by MAC 07/16/2013.
              AND (   (DECODE (p_date_option,
                               'T', TRUNC (e.tran_date),
                               'P', TRUNC (e.posting_date)
                              ) BETWEEN p_from_date AND p_to_date
                      )
                   OR (DECODE (p_date_option, NULL, 1, 0) = 1)
                  )
              AND b.gl_acct_category = c.gl_acct_category
              AND b.gl_control_acct = c.gl_control_acct
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          DECODE (b.gl_sub_acct_1,
                                  0, c.gl_sub_acct_1,
                                  b.gl_sub_acct_1
                                 )
                         ) = c.gl_sub_acct_1
              AND DECODE (b.line_dependency_level,
                          2, d.gl_sub_acct_2,
                          DECODE (b.gl_sub_acct_2,
                                  0, c.gl_sub_acct_2,
                                  b.gl_sub_acct_2
                                 )
                         ) = c.gl_sub_acct_2
              AND DECODE (b.line_dependency_level,
                          3, d.gl_sub_acct_3,
                          DECODE (b.gl_sub_acct_3,
                                  0, c.gl_sub_acct_3,
                                  b.gl_sub_acct_3
                                 )
                         ) = c.gl_sub_acct_3
              AND DECODE (b.line_dependency_level,
                          4, d.gl_sub_acct_4,
                          DECODE (b.gl_sub_acct_4,
                                  0, c.gl_sub_acct_4,
                                  b.gl_sub_acct_4
                                 )
                         ) = c.gl_sub_acct_4
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          2, d.gl_sub_acct_2,
                          3, d.gl_sub_acct_3,
                          4, d.gl_sub_acct_4,
                          5, d.gl_sub_acct_5,
                          6, d.gl_sub_acct_6,
                          7, d.gl_sub_acct_7,
                          NULL, f.acct_line_cd
                         ) = f.acct_line_cd
         GROUP BY e.gibr_branch_cd, c.gl_acct_name, f.line_cd, d.gl_acct_id;

      --HAVING (SUM(debit_amt) <> 0 OR SUM(credit_amt) <> 0);
      CURSOR gl_sum
      IS
         SELECT   c.gl_acct_name, get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                  SUM (debit_amt) debit, SUM (credit_amt) credit,
                  SUM (debit_amt) - SUM (credit_amt) balance
             FROM giac_modules a,
                  giac_module_entries b,
                  giac_chart_of_accts c,
                  giac_acct_entries d,
                  giac_acctrans e
            WHERE 1 = 1
              AND a.module_id = b.module_id
              AND module_name = p_module
              AND b.item_no IN (p_item_no)
              AND c.gl_acct_category = d.gl_acct_category
              AND c.gl_control_acct = d.gl_control_acct
              AND c.gl_sub_acct_1 = d.gl_sub_acct_1
              AND c.gl_sub_acct_2 = d.gl_sub_acct_2
              AND c.gl_sub_acct_3 = d.gl_sub_acct_3
              AND c.gl_sub_acct_4 = d.gl_sub_acct_4
              AND c.gl_sub_acct_5 = d.gl_sub_acct_5
              AND c.gl_sub_acct_6 = d.gl_sub_acct_6
              AND c.gl_sub_acct_7 = d.gl_sub_acct_7
              AND d.gacc_tran_id = e.tran_id
              AND e.tran_flag IN ('C', 'P')
              AND (   (    e.tran_class = p_tran_class
                       AND p_date_option IS NOT NULL
                       AND p_module NOT IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                   OR (    e.tran_class IN ('COL', 'DV', 'BCS', 'JV', 'REV')
                       AND p_date_option IS NOT NULL
                       AND p_module IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                  )   --return true if based on Losses Paid by MAC 09/24/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          NVL (d.generation_type, 'Y')
                         ) NOT IN                           --mikel 03.14.2014
                                                                   ('X', 'C')
--do not retrieve Manual Entries and Loss Recovery if Losses Paid by MAC 07/16/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          DECODE (p_module,
                                  'GIACS017', d.generation_type,
                                  'GIACS018', d.generation_type,
                                  'X'
                                 )
                         ) NOT IN
                     (DECODE (p_module,
                              'GIACS017', '8',
                              
--do not include Inward Claim Payment if p_module is GIACS017 by MAC 07/18/2013.
                              'GIACS018', 'K',
                              
--do not include Direct Claim Payment if p_module is GIACS018 by MAC 07/18/2013.
                              'MAC'
                             )
                     )
--              AND (   (e.tran_flag <> 'D' AND NVL (p_date_option, 'P') != 'T'
--                      )
--                   OR (e.tran_flag = 'C' AND p_date_option = 'T')
--                  )
--check all Closed transaction only if based on Losses Paid by MAC 09/24/2013.
              AND c.leaf_tag = 'Y'
              AND DECODE (p_date_option,
                          'T', TRUNC (e.tran_date),
                          'P', TRUNC (e.posting_date)
                         ) BETWEEN p_from_date AND p_to_date
              AND b.gl_acct_category = c.gl_acct_category
              AND b.gl_control_acct = c.gl_control_acct
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          DECODE (b.gl_sub_acct_1,
                                  0, c.gl_sub_acct_1,
                                  b.gl_sub_acct_1
                                 )
                         ) = c.gl_sub_acct_1
              AND DECODE (b.line_dependency_level,
                          2, d.gl_sub_acct_2,
                          DECODE (b.gl_sub_acct_2,
                                  0, c.gl_sub_acct_2,
                                  b.gl_sub_acct_2
                                 )
                         ) = c.gl_sub_acct_2
              AND DECODE (b.line_dependency_level,
                          3, d.gl_sub_acct_3,
                          DECODE (b.gl_sub_acct_3,
                                  0, c.gl_sub_acct_3,
                                  b.gl_sub_acct_3
                                 )
                         ) = c.gl_sub_acct_3
              AND DECODE (b.line_dependency_level,
                          4, d.gl_sub_acct_4,
                          DECODE (b.gl_sub_acct_4,
                                  0, c.gl_sub_acct_4,
                                  b.gl_sub_acct_4
                                 )
                         ) = c.gl_sub_acct_4
         GROUP BY c.gl_acct_name, d.gl_acct_id;

      CURSOR gl_by_branch_line_treaty
      IS
         SELECT   e.gibr_branch_cd, f.line_cd, c.gl_acct_name,
                  get_gl_acct_no (d.gl_acct_id) gl_acct_no, g.acct_trty_type,
                  SUM (debit_amt) debit, SUM (credit_amt) credit,
                  SUM (debit_amt) - SUM (credit_amt) balance
             FROM giac_modules a,
                  giac_module_entries b,
                  giac_chart_of_accts c,
                  giac_acct_entries d,
                  giac_acctrans e,
                  giis_line f,
                  (SELECT DISTINCT line_cd, acct_trty_type
                              FROM giis_dist_share
                             WHERE share_type = giacp.v ('TRTY_SHARE_TYPE')) g
            WHERE 1 = 1
              AND a.module_id = b.module_id
              AND module_name = p_module
              AND b.item_no IN (p_item_no)
              AND c.gl_acct_category = d.gl_acct_category
              AND c.gl_control_acct = d.gl_control_acct
              AND c.gl_sub_acct_1 = d.gl_sub_acct_1
              AND c.gl_sub_acct_2 = d.gl_sub_acct_2
              AND c.gl_sub_acct_3 = d.gl_sub_acct_3
              AND c.gl_sub_acct_4 = d.gl_sub_acct_4
              AND c.gl_sub_acct_5 = d.gl_sub_acct_5
              AND c.gl_sub_acct_6 = d.gl_sub_acct_6
              AND c.gl_sub_acct_7 = d.gl_sub_acct_7
              AND b.gl_acct_category = c.gl_acct_category
              AND b.gl_control_acct = c.gl_control_acct
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          DECODE (b.gl_sub_acct_1,
                                  0, c.gl_sub_acct_1,
                                  b.gl_sub_acct_1
                                 )
                         ) = c.gl_sub_acct_1
              AND DECODE (b.line_dependency_level,
                          2, d.gl_sub_acct_2,
                          DECODE (b.gl_sub_acct_2,
                                  0, c.gl_sub_acct_2,
                                  b.gl_sub_acct_2
                                 )
                         ) = c.gl_sub_acct_2
              AND DECODE (b.line_dependency_level,
                          3, d.gl_sub_acct_3,
                          DECODE (b.gl_sub_acct_3,
                                  0, c.gl_sub_acct_3,
                                  b.gl_sub_acct_3
                                 )
                         ) = c.gl_sub_acct_3
              AND DECODE (b.line_dependency_level,
                          4, d.gl_sub_acct_4,
                          DECODE (b.gl_sub_acct_4,
                                  0, c.gl_sub_acct_4,
                                  b.gl_sub_acct_4
                                 )
                         ) = c.gl_sub_acct_4
              AND d.gacc_tran_id = e.tran_id
              AND e.tran_flag IN ('C', 'P')
              AND (   (    e.tran_class = p_tran_class
                       AND p_date_option IS NOT NULL
                       AND p_module NOT IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                   OR (    e.tran_class IN ('COL', 'DV', 'BCS', 'JV', 'REV')
                       AND p_date_option IS NOT NULL
                       AND p_module IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                  )   --return true if based on Losses Paid by MAC 09/24/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          NVL (d.generation_type, 'Y')
                         ) NOT IN                           --mikel 03.14.2014
                                                                   ('X', 'C')
--do not retrieve Manual Entries and Loss Recovery if Losses Paid by MAC 07/16/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          DECODE (p_module,
                                  'GIACS017', d.generation_type,
                                  'GIACS018', d.generation_type,
                                  'X'
                                 )
                         ) NOT IN
                     (DECODE (p_module,
                              'GIACS017', '8',
                              
--do not include Inward Claim Payment if p_module is GIACS017 by MAC 07/18/2013.
                              'GIACS018', 'K',
                              
--do not include Direct Claim Payment if p_module is GIACS018 by MAC 07/18/2013.
                              'MAC'
                             )
                     )
--              AND (   (e.tran_flag <> 'D' AND NVL (p_date_option, 'P') != 'T'
--                      )
--                   OR (e.tran_flag = 'C' AND p_date_option = 'T')
--                  )
--check all Closed transaction only if based on Losses Paid by MAC 09/24/2013.
              AND c.leaf_tag = 'Y'
              --return true if based on Losses Paid by MAC 07/16/2013.
              /*AND (   (TO_CHAR (TRUNC (e.tran_date), 'MM-YYYY') =
                                             LPAD (p_mm, 2, 0) || '-'
                                             || p_year
                      )
                   OR (DECODE (p_date_option, NULL, 0, 1) = 1)
                  )*/
              --check if Tran Date or Posting Date is between parameter date if Losses Paid otherwise return true by MAC 07/16/2013.
              AND (   (DECODE (p_date_option,
                               'T', TRUNC (e.tran_date),
                               'P', TRUNC (e.posting_date)
                              ) BETWEEN p_from_date AND p_to_date
                      )
                   OR (DECODE (p_date_option, NULL, 1, 0) = 1)
                  )
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          2, d.gl_sub_acct_2,
                          3, d.gl_sub_acct_3,
                          4, d.gl_sub_acct_4,
                          5, d.gl_sub_acct_5,
                          6, d.gl_sub_acct_6,
                          7, d.gl_sub_acct_7,
                          f.acct_line_cd
                         ) = f.acct_line_cd
              AND DECODE (b.ca_treaty_type_level,
                          1, d.gl_sub_acct_1,
                          2, d.gl_sub_acct_2,
                          3, d.gl_sub_acct_3,
                          4, d.gl_sub_acct_4,
                          5, d.gl_sub_acct_5,
                          6, d.gl_sub_acct_6,
                          7, d.gl_sub_acct_7,
                          NULL, g.acct_trty_type
                         ) = g.acct_trty_type
              AND f.line_cd = g.line_cd
         GROUP BY e.gibr_branch_cd,
                  c.gl_acct_name,
                  f.line_cd,
                  g.acct_trty_type,
                  d.gl_acct_id;

      --cursor to select GL of XOL by MAC 07/15/2013.
      CURSOR gl_by_branch_line_xol
      IS
         SELECT   e.gibr_branch_cd, f.line_cd, c.gl_acct_name,
                  get_gl_acct_no (d.gl_acct_id) gl_acct_no, g.acct_trty_type,
                  SUM (debit_amt) debit, SUM (credit_amt) credit,
                  SUM (debit_amt) - SUM (credit_amt) balance
             FROM giac_modules a,
                  giac_module_entries b,
                  giac_chart_of_accts c,
                  giac_acct_entries d,
                  giac_acctrans e,
                  giis_line f,
                  (SELECT DISTINCT line_cd, acct_trty_type
                              FROM giis_dist_share
                             WHERE share_type =
                                               giacp.v ('XOL_TRTY_SHARE_TYPE')) g
            WHERE 1 = 1
              AND a.module_id = b.module_id
              AND module_name = p_module
              AND b.item_no IN (p_item_no)
              AND c.gl_acct_category = d.gl_acct_category
              AND c.gl_control_acct = d.gl_control_acct
              AND c.gl_sub_acct_1 = d.gl_sub_acct_1
              AND c.gl_sub_acct_2 = d.gl_sub_acct_2
              AND c.gl_sub_acct_3 = d.gl_sub_acct_3
              AND c.gl_sub_acct_4 = d.gl_sub_acct_4
              AND c.gl_sub_acct_5 = d.gl_sub_acct_5
              AND c.gl_sub_acct_6 = d.gl_sub_acct_6
              AND c.gl_sub_acct_7 = d.gl_sub_acct_7
              AND b.gl_acct_category = c.gl_acct_category
              AND b.gl_control_acct = c.gl_control_acct
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          DECODE (b.gl_sub_acct_1,
                                  0, c.gl_sub_acct_1,
                                  b.gl_sub_acct_1
                                 )
                         ) = c.gl_sub_acct_1
              AND DECODE (b.line_dependency_level,
                          2, d.gl_sub_acct_2,
                          DECODE (b.gl_sub_acct_2,
                                  0, c.gl_sub_acct_2,
                                  b.gl_sub_acct_2
                                 )
                         ) = c.gl_sub_acct_2
              AND DECODE (b.line_dependency_level,
                          3, d.gl_sub_acct_3,
                          DECODE (b.gl_sub_acct_3,
                                  0, c.gl_sub_acct_3,
                                  b.gl_sub_acct_3
                                 )
                         ) = c.gl_sub_acct_3
              AND DECODE (b.line_dependency_level,
                          4, d.gl_sub_acct_4,
                          DECODE (b.gl_sub_acct_4,
                                  0, c.gl_sub_acct_4,
                                  b.gl_sub_acct_4
                                 )
                         ) = c.gl_sub_acct_4
              AND d.gacc_tran_id = e.tran_id
              AND e.tran_flag IN ('C', 'P')
              AND (   (    e.tran_class = p_tran_class
                       AND p_date_option IS NOT NULL
                       AND p_module NOT IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                   OR (    e.tran_class IN ('COL', 'DV', 'BCS', 'JV', 'REV')
                       AND p_date_option IS NOT NULL
                       AND p_module IN
                                   ('GIACS017', 'GIACS018') --mikel 03.14.2014
                      )
                  )   --return true if based on Losses Paid by MAC 09/24/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          NVL (d.generation_type, 'Y')
                         ) NOT IN                           --mikel 03.14.2014
                                                                   ('X', 'C')
--do not retrieve Manual Entries and Loss Recovery if Losses Paid by MAC 07/16/2013.
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          DECODE (p_module,
                                  'GIACS017', d.generation_type,
                                  'GIACS018', d.generation_type,
                                  'X'
                                 )
                         ) NOT IN
                     (DECODE (p_module,
                              'GIACS017', '8',
                              
--do not include Inward Claim Payment if p_module is GIACS017 by MAC 07/18/2013.
                              'GIACS018', 'K',
                              
--do not include Direct Claim Payment if p_module is GIACS018 by MAC 07/18/2013.
                              'MAC'
                             )
                     )
--              AND (   (e.tran_flag <> 'D' AND NVL (p_date_option, 'P') != 'T'
--                      )
--                   OR (e.tran_flag = 'C' AND p_date_option = 'T')
--                  )
--check all Closed transaction only if based on Losses Paid by MAC 09/24/2013.
              AND c.leaf_tag = 'Y'
              --return true if based on Losses Paid by MAC 07/16/2013.
              /*AND (   (TO_CHAR (TRUNC (e.tran_date), 'MM-YYYY') =
                                             LPAD (p_mm, 2, 0) || '-'
                                             || p_year
                      )
                   OR (DECODE (p_date_option, NULL, 0, 1) = 1)
                  )*/
              --check if Tran Date or Posting Date is between parameter date if Losses Paid otherwise return true by MAC 07/16/2013.
              AND (   (DECODE (p_date_option,
                               'T', TRUNC (e.tran_date),
                               'P', TRUNC (e.posting_date)
                              ) BETWEEN p_from_date AND p_to_date
                      )
                   OR (DECODE (p_date_option, NULL, 1, 0) = 1)
                  )
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          2, d.gl_sub_acct_2,
                          3, d.gl_sub_acct_3,
                          4, d.gl_sub_acct_4,
                          5, d.gl_sub_acct_5,
                          6, d.gl_sub_acct_6,
                          7, d.gl_sub_acct_7,
                          f.acct_line_cd
                         ) = f.acct_line_cd
              AND DECODE (b.ca_treaty_type_level,
                          1, d.gl_sub_acct_1,
                          2, d.gl_sub_acct_2,
                          3, d.gl_sub_acct_3,
                          4, d.gl_sub_acct_4,
                          5, d.gl_sub_acct_5,
                          6, d.gl_sub_acct_6,
                          7, d.gl_sub_acct_7,
                          NULL, g.acct_trty_type
                         ) = g.acct_trty_type
              AND f.line_cd = g.line_cd
         GROUP BY e.gibr_branch_cd,
                  c.gl_acct_name,
                  f.line_cd,
                  g.acct_trty_type,
                  d.gl_acct_id;

      CURSOR gl_by_tran_id
      IS
         SELECT   c.gl_acct_name, f.line_cd,
                  get_gl_acct_no (d.gl_acct_id) gl_acct_no, e.tran_id,
                  e.tran_class, SUM (debit_amt) debit, SUM (credit_amt)
                                                                       credit,
                  SUM (debit_amt) - SUM (credit_amt) balance
             FROM giac_modules a,
                  giac_module_entries b,
                  giac_chart_of_accts c,
                  giac_acct_entries d,
                  giac_acctrans e,
                  giis_line f
            WHERE 1 = 1
              AND a.module_id = b.module_id
              AND module_name = p_module
              AND b.item_no IN (p_item_no)
              AND c.gl_acct_category = d.gl_acct_category
              AND c.gl_control_acct = d.gl_control_acct
              AND c.gl_sub_acct_1 = d.gl_sub_acct_1
              AND c.gl_sub_acct_2 = d.gl_sub_acct_2
              AND c.gl_sub_acct_3 = d.gl_sub_acct_3
              AND c.gl_sub_acct_4 = d.gl_sub_acct_4
              AND c.gl_sub_acct_5 = d.gl_sub_acct_5
              AND c.gl_sub_acct_6 = d.gl_sub_acct_6
              AND c.gl_sub_acct_7 = d.gl_sub_acct_7
              AND d.gacc_tran_id = e.tran_id
              AND e.tran_flag IN ('C', 'P')
              AND (   (    e.tran_class = p_tran_class
                       AND p_date_option IS NOT NULL
                       AND p_module NOT IN ('GIACS017', 'GIACS018')
                      )
                   OR (    e.tran_class IN ('COL', 'DV', 'BCS', 'JV', 'REV')
                       AND p_date_option IS NOT NULL
                       AND p_module IN ('GIACS017', 'GIACS018')
                      )
                  )
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          NVL (d.generation_type, 'Y')
                         ) NOT IN ('X', 'C')
              AND DECODE (p_date_option,
                          NULL, 'Y',
                          DECODE (p_module,
                                  'GIACS017', d.generation_type,
                                  'GIACS018', d.generation_type,
                                  'X'
                                 )
                         ) NOT IN
                     (DECODE (p_module,
                              'GIACS017', '8',
                              'GIACS018', 'K',
                              'MAC'
                             )
                     )
              AND c.leaf_tag = 'Y'
              AND (   (DECODE (p_date_option,
                               'T', TRUNC (e.tran_date),
                               'P', TRUNC (e.posting_date)
                              ) BETWEEN p_from_date AND p_to_date
                      )
                   OR (DECODE (p_date_option, NULL, 1, 0) = 1)
                  )
              AND b.gl_acct_category = c.gl_acct_category
              AND b.gl_control_acct = c.gl_control_acct
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          DECODE (b.gl_sub_acct_1,
                                  0, c.gl_sub_acct_1,
                                  b.gl_sub_acct_1
                                 )
                         ) = c.gl_sub_acct_1
              AND DECODE (b.line_dependency_level,
                          2, d.gl_sub_acct_2,
                          DECODE (b.gl_sub_acct_2,
                                  0, c.gl_sub_acct_2,
                                  b.gl_sub_acct_2
                                 )
                         ) = c.gl_sub_acct_2
              AND DECODE (b.line_dependency_level,
                          3, d.gl_sub_acct_3,
                          DECODE (b.gl_sub_acct_3,
                                  0, c.gl_sub_acct_3,
                                  b.gl_sub_acct_3
                                 )
                         ) = c.gl_sub_acct_3
              AND DECODE (b.line_dependency_level,
                          4, d.gl_sub_acct_4,
                          DECODE (b.gl_sub_acct_4,
                                  0, c.gl_sub_acct_4,
                                  b.gl_sub_acct_4
                                 )
                         ) = c.gl_sub_acct_4
              AND DECODE (b.line_dependency_level,
                          1, d.gl_sub_acct_1,
                          2, d.gl_sub_acct_2,
                          3, d.gl_sub_acct_3,
                          4, d.gl_sub_acct_4,
                          5, d.gl_sub_acct_5,
                          6, d.gl_sub_acct_6,
                          7, d.gl_sub_acct_7,
                          NULL, f.acct_line_cd
                         ) = f.acct_line_cd
         GROUP BY c.gl_acct_name,
                  f.line_cd,
                  d.gl_acct_id,
                  e.tran_id,
                  e.tran_class,
                  c.gl_acct_name;
   BEGIN
      IF p_break_by = 'BLT'
      THEN
         BEGIN
            SELECT NVL (ca_treaty_type_level, 99)
              INTO v_treaty_level
              FROM giac_modules a, giac_module_entries b
             WHERE 1 = 1
               AND a.module_id = b.module_id
               AND a.module_name = p_module
               AND b.item_no = p_item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_break_by := 'JMR';
         END;
      END IF;

      IF v_treaty_level = 99
      THEN
         v_break_by := 'BL';
      END IF;

      IF v_break_by = 'BL'                          --break by branch and line
      THEN
         FOR rec IN gl_by_branch_line
         LOOP
            v_giacr354_gl.gibr_branch_cd := rec.gibr_branch_cd;
            v_giacr354_gl.line_cd := rec.line_cd;
            v_giacr354_gl.gl_acct_name := rec.gl_acct_name;
            v_giacr354_gl.gl_acct_no := rec.gl_acct_no;
            v_giacr354_gl.balance := rec.balance;
            PIPE ROW (v_giacr354_gl);
         END LOOP;
      ELSIF v_break_by = 'N'                                      --heartbreak
      THEN
         FOR rec IN gl_sum
         LOOP
            v_giacr354_gl.gibr_branch_cd := '';
            v_giacr354_gl.line_cd := '';
            v_giacr354_gl.gl_acct_name := rec.gl_acct_name;
            v_giacr354_gl.gl_acct_no := rec.gl_acct_no;
            v_giacr354_gl.balance := rec.balance;
            PIPE ROW (v_giacr354_gl);
         END LOOP;
      ELSIF v_break_by = 'BLT'              --break by branch, line and treaty
      THEN
         FOR rec IN gl_by_branch_line_treaty
         LOOP
            v_giacr354_gl.gibr_branch_cd := rec.gibr_branch_cd;
            v_giacr354_gl.line_cd := rec.line_cd;
            v_giacr354_gl.gl_acct_name := rec.gl_acct_name;
            v_giacr354_gl.gl_acct_no := rec.gl_acct_no;
            v_giacr354_gl.balance := rec.balance;
            v_giacr354_gl.acct_trty_type := rec.acct_trty_type;
            PIPE ROW (v_giacr354_gl);
         END LOOP;
      ELSIF v_break_by = 'BLX'
      --break by branch, line and xol by MAC 07/15/2013
      THEN
         FOR rec IN gl_by_branch_line_xol
         LOOP
            v_giacr354_gl.gibr_branch_cd := rec.gibr_branch_cd;
            v_giacr354_gl.line_cd := rec.line_cd;
            v_giacr354_gl.gl_acct_name := rec.gl_acct_name;
            v_giacr354_gl.gl_acct_no := rec.gl_acct_no;
            v_giacr354_gl.balance := rec.balance;
            v_giacr354_gl.acct_trty_type := rec.acct_trty_type;
            PIPE ROW (v_giacr354_gl);
         END LOOP;
      ELSIF v_break_by = 'B'
      --break by branch by MAC 01/06/2014
      THEN
         FOR rec IN gl_by_branch
         LOOP
            v_giacr354_gl.gibr_branch_cd := rec.gibr_branch_cd;
            v_giacr354_gl.gl_acct_name := rec.gl_acct_name;
            v_giacr354_gl.gl_acct_no := rec.gl_acct_no;
            v_giacr354_gl.balance := rec.balance;
            PIPE ROW (v_giacr354_gl);
         END LOOP;
      ELSIF v_break_by = 'BT'                               --mikel 05.12.2014
      THEN
         FOR rec IN gl_by_tran_id
         LOOP
            v_giacr354_gl.gibr_branch_cd := '';
            v_giacr354_gl.line_cd := rec.line_cd;
            v_giacr354_gl.gl_acct_name := rec.gl_acct_name;
            v_giacr354_gl.gl_acct_no := rec.gl_acct_no;
            v_giacr354_gl.tran_id := rec.tran_id;
            v_giacr354_gl.tran_class := rec.tran_class;
            v_giacr354_gl.balance := rec.balance;
            PIPE ROW (v_giacr354_gl);
         END LOOP;
      END IF;

      RETURN;
   END;

   FUNCTION giacr354_prd (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_type PIPELINED
   IS
      /* PRD vs TAB1 */
      v_giacr354_prd   giacr354_rec_type;
      v_module         VARCHAR2 (10)     := 'GIACB001';
      v_item_no        NUMBER            := 1;
      v_tran_class     VARCHAR2 (5)      := 'PRD';

      CURSOR gross_prem_written
      IS
         SELECT   '1PREMIUM' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL", NVL (y.prem, 0)
                                                                        "UW",
                  NVL (x.balance, 0) - NVL (y.prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, SUM (prem) prem
                       FROM (SELECT   cred_branch, line_cd, SCOPE,
                                        DECODE (SCOPE,
                                                5, NVL (SUM (total_prem), 0),
                                                4, NVL (SUM (total_prem), 0)
                                                 * -1
                                               )
                                      * -1 prem
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY cred_branch, line_cd, SCOPE)
                   GROUP BY cred_branch, line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR prem_rec
      IS
         SELECT   '5PREMIUM RECEIVABLE' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.prem_rec, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.prem_rec, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, SUM (prem_rec) prem_rec
                       FROM (SELECT   cred_branch, line_cd, SCOPE,
                                      DECODE
                                           (SCOPE,
                                            5, NVL (SUM (  total_prem
                                                         + evatprem
                                                         + fst
                                                         + lgt
                                                         + doc_stamps
                                                         + other_taxes
                                                        ),
                                                    0
                                                   ),
                                            4, NVL (SUM (  total_prem
                                                         + evatprem
                                                         + fst
                                                         + lgt
                                                         + doc_stamps
                                                         + other_taxes
                                                        ),
                                                    0
                                                   )
                                             * -1
                                           ) prem_rec
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY cred_branch, line_cd, SCOPE)
                   GROUP BY cred_branch, line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR comm_expense
      IS
         SELECT   '2COMMISSION EXP' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  gl_acct_no, x.balance "GL", NVL (y.comm_amt, 0) "UW",
                  x.balance - NVL (y.comm_amt, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 6,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, SUM (comm_amt) comm_amt
                       FROM (SELECT   cred_branch, line_cd, SCOPE,
                                      DECODE (SCOPE,
                                              5, NVL (SUM (comm_amt), 0),
                                              4, NVL (SUM (comm_amt), 0) * -1
                                             ) comm_amt
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY cred_branch, line_cd, SCOPE)
                   GROUP BY cred_branch, line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 3;

      CURSOR comm_payable
      IS
         SELECT   '3COMM PAYABLE' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  gl_acct_no, x.balance "GL", NVL (y.comm_amt, 0) "UW",
                  x.balance - NVL (y.comm_amt, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 5,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, SUM (comm_amt) comm_amt
                       FROM (SELECT   cred_branch, line_cd, SCOPE,
                                        DECODE (SCOPE,
                                                5, NVL (SUM (comm_amt), 0),
                                                4, NVL (SUM (comm_amt), 0)
                                                 * -1
                                               )
                                      * -1 comm_amt
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY cred_branch, line_cd, SCOPE)
                   GROUP BY cred_branch, line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 3;

      /*CURSOR taxes
      IS
         SELECT   '4TAXES' base_amt, x.gl_acct_name, x.gl_acct_no,
                  x.balance "GL", NVL (y.tax_amt, 0) "UW",
                  x.balance - NVL (y.tax_amt, 0) variances
             FROM (SELECT   tax_cd,
                            DECODE (tax_cd,
                                    999, 'OTHER TAXES',
                                    gl_acct_name
                                   ) gl_acct_name,
                            DECODE (tax_cd, 999, ' ', gl_acct_no) gl_acct_no,
                            SUM (balance) balance
                       FROM (SELECT   f.tax_cd, c.gl_acct_name,
                                      get_gl_acct_no (d.gl_acct_id)
                                                                   gl_acct_no,
                                      SUM (debit_amt) debit,
                                      SUM (credit_amt) credit,
                                        SUM (debit_amt)
                                      - SUM (credit_amt) balance
                                 FROM giac_chart_of_accts c,
                                      giac_acct_entries d,
                                      giac_acctrans e,
                                      giac_taxes f
                                WHERE 1 = 1
                                  AND d.gacc_tran_id = e.tran_id
                                  AND e.tran_class = 'PRD'
                                  AND e.tran_flag <> 'D'
                                  AND d.gl_acct_id = c.gl_acct_id
                                  AND DECODE (p_post_tran,
                                              'T', TRUNC (e.tran_date),
                                              'P', TRUNC (e.posting_date)
                                             ) BETWEEN p_from_date AND p_to_date
                                  AND d.gl_acct_id = f.gl_acct_id
                                  AND f.tax_cd IN
                                         (giacp.n ('EVAT'),
                                          giacp.n ('PREM_TAX'),
                                          giacp.n ('LGT'),
                                          giacp.n ('DOC_STAMPS'),
                                          giacp.n ('FST')
                                         )
                             GROUP BY f.tax_cd, c.gl_acct_name, d.gl_acct_id
                             UNION
                             SELECT DISTINCT 999, c.gl_acct_name,
                                             get_gl_acct_no (d.gl_acct_id),
                                             SUM (debit_amt) debit,
                                             SUM (credit_amt) credit,
                                               SUM (debit_amt)
                                             - SUM (credit_amt) balance
                                        FROM giac_chart_of_accts c,
                                             giac_acct_entries d,
                                             giac_acctrans e,
                                             giac_taxes f
                                       WHERE 1 = 1
                                         AND d.gacc_tran_id = e.tran_id
                                         AND e.tran_class = 'PRD'
                                         AND e.tran_flag <> 'D'
                                         AND d.gl_acct_id = c.gl_acct_id
                                         AND DECODE (p_post_tran,
                                                     'T', TRUNC (e.tran_date),
                                                     'P', TRUNC
                                                               (e.posting_date)
                                                    ) BETWEEN p_from_date
                                                          AND p_to_date
                                         AND d.gl_acct_id = f.gl_acct_id
                                         AND f.tax_cd NOT IN
                                                (giacp.n ('EVAT'),
                                                 giacp.n ('PREM_TAX'),
                                                 giacp.n ('LGT'),
                                                 giacp.n ('DOC_STAMPS'),
                                                 giacp.n ('FST')
                                                )
                                    GROUP BY f.tax_cd,
                                             c.gl_acct_name,
                                             d.gl_acct_id)
                   GROUP BY tax_cd,
                            DECODE (tax_cd, 999, 'OTHER TAXES', gl_acct_name),
                            DECODE (tax_cd, 999, ' ', gl_acct_no)) x
                  FULL OUTER JOIN
                  (SELECT   x.tax_cd, NVL (y.tax_name,
                                           'OTHER TAXES') tax_name,
                            SUM (tax_amt) * -1 tax_amt
                       FROM (SELECT   DECODE (SCOPE,
                                              5, NVL (SUM (evatprem), 0),
                                              4, NVL (SUM (evatprem), 0) * -1
                                             ) tax_amt,
                                      giacp.n ('EVAT') tax_cd
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY SCOPE
                             UNION
                             SELECT   DECODE (SCOPE,
                                              5, NVL (SUM (fst), 0),
                                              4, NVL (SUM (fst), 0) * -1
                                             ) tax_amt,
                                      giacp.n ('FST') tax_cd
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY SCOPE
                             UNION
                             SELECT   DECODE (SCOPE,
                                              5, NVL (SUM (lgt), 0),
                                              4, NVL (SUM (lgt), 0) * -1
                                             ) tax_amt,
                                      giacp.n ('LGT') tax_cd
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY SCOPE
                             UNION
                             SELECT   DECODE (SCOPE,
                                              5, NVL (SUM (doc_stamps), 0),
                                              4, NVL (SUM (doc_stamps), 0)
                                               * -1
                                             ) tax_amt,
                                      giacp.n ('DOC_STAMPS') tax_cd
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY SCOPE
                             UNION
                             SELECT   DECODE (SCOPE,
                                              5, NVL (SUM (other_taxes), 0),
                                              4, NVL (SUM (other_taxes), 0)
                                               * -1
                                             ) tax_amt,
                                      999
                                 FROM gipi_uwreports_ext
                                WHERE user_id = USER
                                  AND from_date = p_from_date
                                  AND TO_DATE = p_to_date
                                  AND iss_cd <> 'RI'
                             GROUP BY SCOPE) x,
                            giac_taxes y
                      WHERE x.tax_cd = y.tax_cd(+)
                   GROUP BY x.tax_cd, y.tax_name) y ON x.tax_cd = y.tax_cd
         ORDER BY 1;
       */
      CURSOR taxes
      IS
         --PLEASE CONFIRM WITH PNBGEN IF THE GL ACCT NO OF "NO CLAIM BONUS" IN TAX MAINTENANCE IS CORRECT
         SELECT '4TAXES' base_amt,
                SUM (CASE
                        WHEN base_amt IN ('GL')
                           THEN tax_amt
                        ELSE 0
                     END) gl,
                SUM (CASE
                        WHEN base_amt IN ('UW')
                           THEN tax_amt
                        ELSE 0
                     END) uw
           FROM (SELECT 'GL' base_amt,
                        SUM (debit_amt) - SUM (credit_amt) tax_amt
                   FROM giac_chart_of_accts c,
                        giac_acct_entries d,
                        giac_acctrans e
                  WHERE 1 = 1
                    AND d.gacc_tran_id = e.tran_id
                    AND e.tran_class = 'PRD'
                    AND e.tran_flag <> 'D'
                    AND d.gl_acct_id = c.gl_acct_id
                    AND DECODE (p_post_tran,
                                'T', TRUNC (e.tran_date),
                                'P', TRUNC (e.posting_date)
                               ) BETWEEN p_from_date AND p_to_date
                    AND d.gl_acct_id IN (SELECT DISTINCT gl_acct_id
                                                    FROM giac_taxes)
                 UNION
                 SELECT 'UW' base_amt,
                          SUM ((  NVL (evatprem, 0)
                                + NVL (fst, 0)
                                + NVL (lgt, 0)
                                + NVL (doc_stamps, 0)
                                + NVL (other_taxes, 0)
                               )
                              )
                        * -1 tax_amt
                   FROM gipi_uwreports_ext
                  WHERE user_id = USER
                    AND from_date = p_from_date
                    AND TO_DATE = p_to_date
                    AND iss_cd <> 'RI');

      CURSOR misc_entries
      IS
         SELECT   '6MISCELLANEOUS' base_amt, x.gibr_branch_cd branch_cd,
                  x.line_cd line_cd, x.gl_acct_name, gl_acct_no,
                  x.balance "GL", 0 "UW", x.balance - 0 variances
             FROM (SELECT   e.gibr_branch_cd, c.gl_acct_name, '' line_cd,
                            get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                            SUM (debit_amt) debit, SUM (credit_amt) credit,
                            SUM (debit_amt) - SUM (credit_amt) balance
                       FROM giac_modules a,
                            giac_module_entries b,
                            giac_chart_of_accts c,
                            giac_acct_entries d,
                            giac_acctrans e
                      WHERE 1 = 1
                        AND a.module_id = b.module_id
                        AND module_name = 'GIACB001'
                        AND b.item_no IN (9, 10)
                        AND c.gl_acct_category = d.gl_acct_category
                        AND c.gl_control_acct = d.gl_control_acct
                        AND c.gl_sub_acct_1 = d.gl_sub_acct_1
                        AND c.gl_sub_acct_2 = d.gl_sub_acct_2
                        AND c.gl_sub_acct_3 = d.gl_sub_acct_3
                        AND c.gl_sub_acct_4 = d.gl_sub_acct_4
                        AND c.gl_sub_acct_5 = d.gl_sub_acct_5
                        AND c.gl_sub_acct_6 = d.gl_sub_acct_6
                        AND c.gl_sub_acct_7 = d.gl_sub_acct_7
                        AND d.gacc_tran_id = e.tran_id
                        AND e.tran_class = 'PRD'
                        AND e.tran_flag <> 'D'
                        AND DECODE (p_post_tran,
                                    'T', TRUNC (e.tran_date),
                                    'P', TRUNC (e.posting_date)
                                   ) BETWEEN p_from_date AND p_to_date
                        AND b.gl_acct_category = c.gl_acct_category
                        AND b.gl_control_acct = c.gl_control_acct
                        AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                        AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                        AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                        AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                        AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                        AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                        AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                        AND c.leaf_tag = 'Y'
                   GROUP BY e.gibr_branch_cd, c.gl_acct_name, d.gl_acct_id) x
         ORDER BY 1, 3;
   BEGIN
      FOR rec IN gross_prem_written
      LOOP
         v_giacr354_prd.branch_cd := rec.branch_cd;
         v_giacr354_prd.line_cd := rec.line_cd;
         v_giacr354_prd.gl_acct_name := rec.gl_acct_name;
         v_giacr354_prd.base_amt := rec.base_amt;
         v_giacr354_prd.gl_acct_no := rec.gl_acct_no;
         v_giacr354_prd.gl_amount := rec.gl;
         v_giacr354_prd.uw_amount := rec.uw;
         v_giacr354_prd.variances := rec.variances;
         PIPE ROW (v_giacr354_prd);
      END LOOP;

      FOR rec2 IN taxes
      LOOP
         v_giacr354_prd.branch_cd := NULL;
         v_giacr354_prd.line_cd := NULL;
         v_giacr354_prd.gl_acct_name := 'TAXES';
         v_giacr354_prd.base_amt := rec2.base_amt;
         v_giacr354_prd.gl_acct_no := NULL;
         v_giacr354_prd.gl_amount := rec2.gl;
         v_giacr354_prd.uw_amount := rec2.uw;
         v_giacr354_prd.variances := rec2.gl - rec2.uw;
         PIPE ROW (v_giacr354_prd);
      END LOOP;

      FOR rec3 IN prem_rec
      LOOP
         v_giacr354_prd.branch_cd := rec3.branch_cd;
         v_giacr354_prd.line_cd := rec3.line_cd;
         v_giacr354_prd.gl_acct_name := rec3.gl_acct_name;
         v_giacr354_prd.base_amt := rec3.base_amt;
         v_giacr354_prd.gl_acct_no := rec3.gl_acct_no;
         v_giacr354_prd.gl_amount := rec3.gl;
         v_giacr354_prd.uw_amount := rec3.uw;
         v_giacr354_prd.variances := rec3.variances;
         PIPE ROW (v_giacr354_prd);
      END LOOP;

      FOR rec4 IN misc_entries
      LOOP
         v_giacr354_prd.branch_cd := rec4.branch_cd;
         v_giacr354_prd.line_cd := rec4.line_cd;
         v_giacr354_prd.gl_acct_name := rec4.gl_acct_name;
         v_giacr354_prd.base_amt := rec4.base_amt;
         v_giacr354_prd.gl_acct_no := rec4.gl_acct_no;
         v_giacr354_prd.gl_amount := rec4.gl;
         v_giacr354_prd.uw_amount := rec4.uw;
         v_giacr354_prd.variances := rec4.variances;
         PIPE ROW (v_giacr354_prd);
      END LOOP;

      FOR rec5 IN comm_payable
      LOOP
         v_giacr354_prd.branch_cd := rec5.branch_cd;
         v_giacr354_prd.line_cd := rec5.line_cd;
         v_giacr354_prd.gl_acct_name := rec5.gl_acct_name;
         v_giacr354_prd.base_amt := rec5.base_amt;
         v_giacr354_prd.gl_acct_no := rec5.gl_acct_no;
         v_giacr354_prd.gl_amount := rec5.gl;
         v_giacr354_prd.uw_amount := rec5.uw;
         v_giacr354_prd.variances := rec5.variances;
         PIPE ROW (v_giacr354_prd);
      END LOOP;

      FOR rec6 IN comm_expense
      LOOP
         v_giacr354_prd.branch_cd := rec6.branch_cd;
         v_giacr354_prd.line_cd := rec6.line_cd;
         v_giacr354_prd.gl_acct_name := rec6.gl_acct_name;
         v_giacr354_prd.base_amt := rec6.base_amt;
         v_giacr354_prd.gl_acct_no := rec6.gl_acct_no;
         v_giacr354_prd.gl_amount := rec6.gl;
         v_giacr354_prd.uw_amount := rec6.uw;
         v_giacr354_prd.variances := rec6.variances;
         PIPE ROW (v_giacr354_prd);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_prd_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED
   IS
      /* UW vs TAB2 - per POLICY per DIST NO */
      v_giacr354_prd_dtl   giacr354_dtl_rec_type;
      v_module             VARCHAR2 (10)                        := 'GIACB001';
      v_item_no            NUMBER                                  := 1;
      v_tran_class         VARCHAR2 (5)                            := 'UW';
      v_mod_comm           VARCHAR2 (1)                            := 'N';
      v_gl_comm_amt        gipi_comm_invoice.commission_amt%TYPE;
      v_variances          gipi_comm_invoice.commission_amt%TYPE;

      CURSOR gross_premium
      IS
         SELECT   '1PREMIUM' base_amt,
                  NVL (x.cred_branch, y.cred_branch) branch_cd,
                  NVL (x.line_cd, y.line_cd) line_cd,
                  NVL (x.policy_no, y.policy_no) policy_no,
                  NVL (x.policy_id, y.policy_id) policy_id, x.pol_flag,
                  x.prem_amt, y.total_prem,
                  NVL (x.prem_amt, 0) - NVL (total_prem, 0) variances
             FROM (SELECT   b.cred_branch, b.line_cd, a.policy_id,
                            get_policy_no (a.policy_id) policy_no,
                            DECODE (a.spoiled_acct_ent_date,
                                    p_to_date, 'SPOILED',
                                    ''
                                   ) pol_flag,
                            SUM (  a.prem_amt
                                 * a.currency_rt
                                 * DECODE (a.spoiled_acct_ent_date,
                                           p_to_date, -1,
                                           1
                                          )
                                ) prem_amt
                       FROM gipi_invoice a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND (   a.acct_ent_date BETWEEN p_from_date AND p_to_date
                             OR a.spoiled_acct_ent_date BETWEEN p_from_date
                                                            AND p_to_date
                            )
                        AND b.iss_cd != giisp.v ('RI')
                   GROUP BY b.cred_branch,
                            b.line_cd,
                            a.policy_id,
                            a.spoiled_acct_ent_date) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, policy_id,
                            get_policy_no (policy_id) policy_no, '' pol_flag,
                            SUM (total_prem) total_prem
                       FROM gipi_uwreports_ext
                      WHERE user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND iss_cd != giisp.v ('RI')
                   GROUP BY cred_branch, line_cd, policy_id) y
                  ON x.cred_branch = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.policy_id = y.policy_id
         ORDER BY 1, 2, 3, 4;

      CURSOR comm_exp
      IS
         SELECT   '2COMMISSION EXP' base_amt,
                  NVL (x.cred_branch, y.cred_branch) branch_cd,
                  NVL (x.line_cd, y.line_cd) line_cd,
                  NVL (x.policy_no, y.policy_no) policy_no,
                  NVL (x.policy_id, y.policy_id) policy_id, x.pol_flag,
                  x.comm_amt, y.comm_amt uw_comm_amt
             --NVL (x.comm_amt, 0) - NVL (y.comm_amt, 0) variances
         FROM     (SELECT   c.cred_branch, c.line_cd,
                            get_policy_no (a.policy_id) policy_no,
                            a.policy_id,
                            DECODE (a.spoiled_acct_ent_date,
                                    p_to_date, 'SPOILED',
                                    ''
                                   ) pol_flag,
                            SUM (  NVL (b.commission_amt, 0)
                                 * NVL (a.currency_rt, 1)
                                 * DECODE (a.spoiled_acct_ent_date,
                                           p_to_date, -1,
                                           1
                                          )
                                ) comm_amt
                       FROM gipi_invoice a,
                            gipi_comm_inv_peril b,
                            gipi_polbasic c
                      WHERE 1 = 1
                        AND a.policy_id = b.policy_id
                        AND a.iss_cd = b.iss_cd
                        AND a.prem_seq_no = b.prem_seq_no
                        AND a.policy_id = c.policy_id
                        AND (   a.acct_ent_date BETWEEN p_from_date AND p_to_date
                             OR a.spoiled_acct_ent_date BETWEEN p_from_date
                                                            AND p_to_date
                            )
                        AND b.iss_cd != giisp.v ('RI')
                   GROUP BY c.cred_branch,
                            c.line_cd,
                            a.policy_id,
                            a.spoiled_acct_ent_date) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, policy_id,
                            get_policy_no (policy_id) policy_no, '' pol_flag,
                            SUM (comm_amt) comm_amt
                       FROM gipi_uwreports_ext
                      WHERE user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND iss_cd != giisp.v ('RI')
                   GROUP BY cred_branch, line_cd, policy_id) y
                  ON x.cred_branch = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.policy_id = y.policy_id
         ORDER BY 1, 2, 3, 4;
   BEGIN
      FOR rec IN gross_premium
      LOOP
         v_giacr354_prd_dtl.branch_cd := rec.branch_cd;
         v_giacr354_prd_dtl.line_cd := rec.line_cd;
         v_giacr354_prd_dtl.policy_no := rec.policy_no;
         v_giacr354_prd_dtl.policy_id := rec.policy_id;
         v_giacr354_prd_dtl.pol_flag := rec.pol_flag;
         v_giacr354_prd_dtl.base_amt := rec.base_amt;
         v_giacr354_prd_dtl.gl_amount := rec.prem_amt;
         v_giacr354_prd_dtl.uw_amount := rec.total_prem;
         v_giacr354_prd_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_prd_dtl);
      END LOOP;

      FOR rec IN comm_exp
      LOOP
         v_mod_comm := 'N';
         v_gl_comm_amt := rec.comm_amt;

         FOR mc IN (SELECT policy_id
                      FROM giac_new_comm_inv
                     WHERE policy_id = rec.policy_id
                       AND tran_flag = 'P'
                       AND ROWNUM = 1)
         LOOP
            v_mod_comm := 'Y';
         END LOOP;

         IF v_mod_comm = 'Y'
         THEN
            BEGIN
               SELECT get_booked_comm_amt (iss_cd,
                                           prem_seq_no,
                                           NULL,
                                           p_to_date
                                          )
                 INTO v_gl_comm_amt
                 FROM gipi_invoice
                WHERE policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         v_variances := v_gl_comm_amt - rec.uw_comm_amt;
         v_giacr354_prd_dtl.branch_cd := rec.branch_cd;
         v_giacr354_prd_dtl.line_cd := rec.line_cd;
         v_giacr354_prd_dtl.policy_no := rec.policy_no;
         v_giacr354_prd_dtl.policy_id := rec.policy_id;
         v_giacr354_prd_dtl.pol_flag := rec.pol_flag;
         v_giacr354_prd_dtl.base_amt := rec.base_amt;
         v_giacr354_prd_dtl.gl_amount := v_gl_comm_amt;
         v_giacr354_prd_dtl.uw_amount := rec.uw_comm_amt;
         v_giacr354_prd_dtl.variances := v_variances;
         PIPE ROW (v_giacr354_prd_dtl);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_uw (p_from_date DATE, p_to_date DATE, p_post_tran VARCHAR2)
      RETURN giacr354_type PIPELINED
   IS
      /* UW vs TAB2 - per GL */
      v_giacr354_uw            giacr354_rec_type;
      v_module                 VARCHAR2 (10)     := 'GIACB002';
      v_item_no                NUMBER            := 1;
      v_tran_class             VARCHAR2 (5)      := 'UW';
      v_separate_cessions_gl   VARCHAR2 (1)
                               := NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N');

      CURSOR prem_ceded_trty
      IS
         --CHANGE LEAF_TAG FROM N TO Y (UCPBGEN)
         --PREMIUMS CEDED - DIRECT BUSINESS - TREATY - MARINE CARGO - TRUST RECEIPT EXCESS OF LOSS
         --PREMIUMS CEDED - FACULTATIVE ASSUMED - TREATY - MARINE CARGO - TRUST RECEIPT EXCESS OF LOSS
         SELECT   DECODE (NVL (y.cred_branch, x.gibr_branch_cd),
                          'RI', '2PREMIUM',
                          '1PREMIUM'
                         ) base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no,
                  NVL (y.acct_trty_type, x.acct_trty_type) acct_trty_type,
                  NVL (x.balance, 0) "GL", NVL (y.trty_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd, b.acct_trty_type,
                            SUM (a.tr_dist_prem) trty_prem
                       FROM gipi_uwreports_dist_peril_ext a,
                            giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.share_cd = b.share_cd
                        AND a.user_id = USER
                        AND a.cred_branch != 'RI'
                        AND from_date1 = p_from_date
                        AND to_date1 = p_to_date
                        AND a.tr_dist_prem IS NOT NULL
                   GROUP BY a.cred_branch, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         UNION
         SELECT   DECODE (NVL (y.cred_branch, x.gibr_branch_cd),
                          'RI', '2PREMIUM',
                          '1PREMIUM'
                         ) base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no,
                  NVL (y.acct_trty_type, x.acct_trty_type) acct_trty_type,
                  NVL (x.balance, 0) "GL", NVL (y.trty_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 12,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd, b.acct_trty_type,
                            SUM (a.tr_dist_prem) trty_prem
                       FROM gipi_uwreports_dist_peril_ext a,
                            giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.share_cd = b.share_cd
                        AND a.user_id = USER
                        AND a.cred_branch = 'RI'
                        AND from_date1 = p_from_date
                        AND to_date1 = p_to_date
                        AND a.tr_dist_prem IS NOT NULL
                   GROUP BY a.cred_branch, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2;

      CURSOR prem_ceded_trty2
      IS
         SELECT   DECODE (NVL (y.cred_branch, x.gibr_branch_cd),
                          'RI', '2PREMIUM',
                          '1PREMIUM'
                         ) base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no,
                  NVL (y.acct_trty_type, x.acct_trty_type) acct_trty_type,
                  NVL (x.balance, 0) "GL", NVL (y.trty_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd, b.acct_trty_type,
                            SUM (a.tr_dist_prem) trty_prem
                       FROM gipi_uwreports_dist_peril_ext a,
                            giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.share_cd = b.share_cd
                        AND a.user_id = USER
                        AND from_date1 = p_from_date
                        AND to_date1 = p_to_date
                        AND a.tr_dist_prem IS NOT NULL
                   GROUP BY a.cred_branch, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2;

      CURSOR comm_inc_trty
      IS
         --CHANGE LEAF_TAG FROM N TO Y (UCPBGEN)
         --COMMISSION INCOME FROM TREATY REINSURER - DIRECT BUSINESS - MARINE CARGO -TRUST RECEIPT EXCESS OF LO
         SELECT   '3COMMISSION INC' base_amt,
                  NVL (y.branch_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.trty_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.branch_cd, a.line_cd, b.acct_trty_type,
                            SUM (commission_amt) * -1 trty_comm
                       FROM giac_treaty_cessions a, giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.treaty_yy = b.trty_yy
                        AND a.share_cd = b.share_cd
                        AND a.branch_cd != 'RI'
                        AND a.cession_mm =
                                         TO_NUMBER (TO_CHAR (p_to_date, 'MM'))
                        AND a.cession_year =
                                       TO_NUMBER (TO_CHAR (p_to_date, 'YYYY'))
                   GROUP BY a.branch_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.branch_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         UNION
         SELECT   '3COMMISSION INC' base_amt,
                  NVL (y.branch_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.trty_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 13,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.branch_cd, a.line_cd, b.acct_trty_type,
                            SUM (commission_amt) * -1 trty_comm
                       FROM giac_treaty_cessions a, giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.treaty_yy = b.trty_yy
                        AND a.share_cd = b.share_cd
                        AND a.branch_cd = 'RI'
                        AND a.cession_mm =
                                         TO_NUMBER (TO_CHAR (p_to_date, 'MM'))
                        AND a.cession_year =
                                       TO_NUMBER (TO_CHAR (p_to_date, 'YYYY'))
                   GROUP BY a.branch_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.branch_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2;

      CURSOR comm_inc_trty2
      IS
         SELECT   '3COMMISSION INC' base_amt,
                  NVL (y.branch_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.trty_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.branch_cd, a.line_cd, b.acct_trty_type,
                            SUM (commission_amt) * -1 trty_comm
                       FROM giac_treaty_cessions a, giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.treaty_yy = b.trty_yy
                        AND a.share_cd = b.share_cd
                        AND a.cession_mm =
                                         TO_NUMBER (TO_CHAR (p_to_date, 'MM'))
                        AND a.cession_year =
                                       TO_NUMBER (TO_CHAR (p_to_date, 'YYYY'))
                   GROUP BY a.branch_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.branch_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2;

      CURSOR funds_held_trty
      IS
         --CHANGE LEAF_TAG FROM N TO Y (UCPBGEN)
         --PREMIUM RESERVE WITHHELD FOR REINSURERS - TREATY - MARINE CARGO - TRUST RECEIPT EXCESS OF LOSS
         SELECT   '4FUNDS HELD' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.funds_held, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.funds_held, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 3,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd, b.acct_trty_type,
                              SUM (  a.tr_dist_prem
                                   * (c.trty_shr_pct / 100)
                                   * (  NVL (c.funds_held_pct,
                                             b.funds_held_pct
                                            )
                                      / 100
                                     )
                                  )
                            * -1 funds_held
                       FROM gipi_uwreports_dist_peril_ext a,
                            giis_dist_share b,
                            giis_trty_panel c,
                            giis_trty_peril d
                      WHERE 1 = 1
                        AND a.user_id = USER
                        AND a.line_cd = b.line_cd
                        AND a.share_cd = b.share_cd
                        AND b.line_cd = c.line_cd
                        AND b.trty_yy = c.trty_yy
                        AND b.share_cd = c.trty_seq_no
                        AND c.line_cd = d.line_cd
                        AND c.trty_seq_no = d.trty_seq_no
                        AND a.peril_cd = d.peril_cd
                        AND from_date1 = p_from_date
                        AND to_date1 = p_to_date
                        AND a.tr_dist_prem IS NOT NULL
                   GROUP BY a.cred_branch, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2;

      CURSOR comm_vat_trty
      IS
         SELECT   '5RI COMM VAT' base_amt, '' branch_cd, '' line_cd,
                  x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.trty_comm_vat, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.trty_comm_vat, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 8,
                                                                 v_tran_class,
                                                                 'N',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT SUM (comm_vat) * -1 trty_comm_vat
                     FROM giac_treaty_cessions a, giis_dist_share b
                    WHERE 1 = 1
                      AND a.line_cd = b.line_cd
                      AND a.treaty_yy = b.trty_yy
                      AND a.share_cd = b.share_cd
                      AND a.cession_mm = TO_NUMBER (TO_CHAR (p_to_date, 'MM'))
                      AND a.cession_year =
                                       TO_NUMBER (TO_CHAR (p_to_date, 'YYYY'))) y
                  ON 1 = 1
         ORDER BY 1, 2;

      CURSOR due_to_trty
      IS
         --CHANGE LEAF_TAG FROM N TO Y (UCPBGEN)
         --PREMIUMS DUE TO REINSURERS - TREATY - MARINE CARGO - TRUST RECEIPT EXCESS OF LOSS
         SELECT   '6PREMIUMS DUE TO' base_amt,
                  NVL (y.branch_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.due_to_trty, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.due_to_trty, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 4,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT j.branch_cd, j.line_cd, j.acct_trty_type,
                            (NVL (j.due_to_trty, 0) - NVL (m.funds_held, 0)
                            )
                          * -1 due_to_trty
                     FROM (SELECT   a.branch_cd, a.line_cd, b.acct_trty_type,
                                    SUM
                                       (  premium_amt
                                        + DECODE
                                             (NVL (giacp.v ('GEN_VAT_ON_RI'),
                                                   'BL'
                                                  ),
                                              'BL', (DECODE
                                                        (NVL
                                                            (giacp.v
                                                                ('GEN_TRTY_PREM_VAT'
                                                                ),
                                                             'N'
                                                            ),
                                                         'BL', (DECODE
                                                                   (NVL
                                                                       (giacp.v
                                                                           ('GEN_PREM_VAT_FOREIGN'
                                                                           ),
                                                                        'N'
                                                                       ),
                                                                    'N', (a.prem_vat
                                                                     ),
                                                                    0
                                                                   )
                                                          ),
                                                         0 * -1
                                                        )
                                               ),
                                              0
                                             )
                                        - (  commission_amt
                                           + comm_vat
                                           - ri_wholding_vat
                                          )
                                       ) due_to_trty
                               FROM giac_treaty_cessions a, giis_dist_share b
                              WHERE 1 = 1
                                AND a.line_cd = b.line_cd
                                AND a.treaty_yy = b.trty_yy
                                AND a.share_cd = b.share_cd
                                AND a.cession_mm =
                                         TO_NUMBER (TO_CHAR (p_to_date, 'MM'))
                                AND a.cession_year =
                                       TO_NUMBER (TO_CHAR (p_to_date, 'YYYY'))
                           GROUP BY a.branch_cd, a.line_cd, b.acct_trty_type) j,
                          (SELECT   a.cred_branch, a.line_cd,
                                    b.acct_trty_type,
                                    SUM (  a.tr_dist_prem
                                         * (c.trty_shr_pct / 100)
                                         * (  NVL (c.funds_held_pct,
                                                   b.funds_held_pct
                                                  )
                                            / 100
                                           )
                                        ) funds_held
                               FROM gipi_uwreports_dist_peril_ext a,
                                    giis_dist_share b,
                                    giis_trty_panel c,
                                    giis_trty_peril d
                              WHERE 1 = 1
                                AND a.user_id = USER
                                AND a.line_cd = b.line_cd
                                AND a.share_cd = b.share_cd
                                AND b.line_cd = c.line_cd
                                AND b.trty_yy = c.trty_yy
                                AND b.share_cd = c.trty_seq_no
                                AND c.line_cd = d.line_cd
                                AND c.trty_seq_no = d.trty_seq_no
                                AND a.peril_cd = d.peril_cd
                                AND from_date1 = p_from_date
                                AND to_date1 = p_to_date
                                AND a.tr_dist_prem IS NOT NULL
                           GROUP BY a.cred_branch, a.line_cd,
                                    b.acct_trty_type) m
                    WHERE j.branch_cd = m.cred_branch
                      AND j.line_cd = m.line_cd
                      AND j.acct_trty_type = m.acct_trty_type) y
                  ON x.gibr_branch_cd = y.branch_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2;

      CURSOR misc_entries
      IS
         SELECT   'MISCELLANEOUS' base_amt, '' branch_cd, '' line_cd,
                  x.gl_acct_name, gl_acct_no, x.balance "GL", 0 "UW",
                  x.balance - 0 variances
             FROM (SELECT   c.gl_acct_name, '' line_cd,
                            get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                            SUM (debit_amt) debit, SUM (credit_amt) credit,
                            SUM (debit_amt) - SUM (credit_amt) balance
                       FROM giac_modules a,
                            giac_module_entries b,
                            giac_chart_of_accts c,
                            giac_acct_entries d,
                            giac_acctrans e
                      WHERE 1 = 1
                        AND a.module_id = b.module_id
                        AND module_name = 'GIACB002'
                        AND b.item_no IN (5, 6)
                        AND c.gl_acct_category = d.gl_acct_category
                        AND c.gl_control_acct = d.gl_control_acct
                        AND c.gl_sub_acct_1 = d.gl_sub_acct_1
                        AND c.gl_sub_acct_2 = d.gl_sub_acct_2
                        AND c.gl_sub_acct_3 = d.gl_sub_acct_3
                        AND c.gl_sub_acct_4 = d.gl_sub_acct_4
                        AND c.gl_sub_acct_5 = d.gl_sub_acct_5
                        AND c.gl_sub_acct_6 = d.gl_sub_acct_6
                        AND c.gl_sub_acct_7 = d.gl_sub_acct_7
                        AND d.gacc_tran_id = e.tran_id
                        AND e.tran_class = 'UW'
                        AND e.tran_flag <> 'D'
                        AND DECODE (p_post_tran,
                                    'T', TRUNC (e.tran_date),
                                    'P', TRUNC (e.posting_date)
                                   ) BETWEEN p_from_date AND p_to_date
                        AND b.gl_acct_category = c.gl_acct_category
                        AND b.gl_control_acct = c.gl_control_acct
                        AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                        AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                        AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                        AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                        AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                        AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                        AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                        AND c.leaf_tag = 'Y'
                   GROUP BY c.gl_acct_name, d.gl_acct_id) x
         ORDER BY 1, 3;
   BEGIN
      IF v_separate_cessions_gl = 'Y'
      THEN
         FOR rec IN prem_ceded_trty
         LOOP
            v_giacr354_uw.branch_cd := rec.branch_cd;
            v_giacr354_uw.line_cd := rec.line_cd;
            v_giacr354_uw.gl_acct_name := rec.gl_acct_name;
            v_giacr354_uw.base_amt := rec.base_amt;
            v_giacr354_uw.gl_acct_no := rec.gl_acct_no;
            v_giacr354_uw.acct_trty_type := rec.acct_trty_type;
            v_giacr354_uw.gl_amount := rec.gl;
            v_giacr354_uw.uw_amount := rec.uw;
            v_giacr354_uw.variances := rec.variances;
            PIPE ROW (v_giacr354_uw);
         END LOOP;

         FOR rec2 IN comm_inc_trty
         LOOP
            v_giacr354_uw.branch_cd := rec2.branch_cd;
            v_giacr354_uw.line_cd := rec2.line_cd;
            v_giacr354_uw.gl_acct_name := rec2.gl_acct_name;
            v_giacr354_uw.base_amt := rec2.base_amt;
            v_giacr354_uw.gl_acct_no := rec2.gl_acct_no;
            v_giacr354_uw.gl_amount := rec2.gl;
            v_giacr354_uw.uw_amount := rec2.uw;
            v_giacr354_uw.variances := rec2.variances;
            PIPE ROW (v_giacr354_uw);
         END LOOP;
      ELSE
         FOR rec IN prem_ceded_trty2
         LOOP
            v_giacr354_uw.branch_cd := rec.branch_cd;
            v_giacr354_uw.line_cd := rec.line_cd;
            v_giacr354_uw.gl_acct_name := rec.gl_acct_name;
            v_giacr354_uw.base_amt := rec.base_amt;
            v_giacr354_uw.gl_acct_no := rec.gl_acct_no;
            v_giacr354_uw.acct_trty_type := rec.acct_trty_type;
            v_giacr354_uw.gl_amount := rec.gl;
            v_giacr354_uw.uw_amount := rec.uw;
            v_giacr354_uw.variances := rec.variances;
            PIPE ROW (v_giacr354_uw);
         END LOOP;

         FOR rec2 IN comm_inc_trty2
         LOOP
            v_giacr354_uw.branch_cd := rec2.branch_cd;
            v_giacr354_uw.line_cd := rec2.line_cd;
            v_giacr354_uw.gl_acct_name := rec2.gl_acct_name;
            v_giacr354_uw.base_amt := rec2.base_amt;
            v_giacr354_uw.gl_acct_no := rec2.gl_acct_no;
            v_giacr354_uw.gl_amount := rec2.gl;
            v_giacr354_uw.uw_amount := rec2.uw;
            v_giacr354_uw.variances := rec2.variances;
            PIPE ROW (v_giacr354_uw);
         END LOOP;
      END IF;

      FOR rec3 IN funds_held_trty
      LOOP
         v_giacr354_uw.branch_cd := rec3.branch_cd;
         v_giacr354_uw.line_cd := rec3.line_cd;
         v_giacr354_uw.gl_acct_name := rec3.gl_acct_name;
         v_giacr354_uw.base_amt := rec3.base_amt;
         v_giacr354_uw.gl_acct_no := rec3.gl_acct_no;
         v_giacr354_uw.gl_amount := rec3.gl;
         v_giacr354_uw.uw_amount := rec3.uw;
         v_giacr354_uw.variances := rec3.variances;
         PIPE ROW (v_giacr354_uw);
      END LOOP;

      FOR rec4 IN comm_vat_trty
      LOOP
         v_giacr354_uw.branch_cd := rec4.branch_cd;
         v_giacr354_uw.line_cd := rec4.line_cd;
         v_giacr354_uw.gl_acct_name := rec4.gl_acct_name;
         v_giacr354_uw.base_amt := rec4.base_amt;
         v_giacr354_uw.gl_acct_no := rec4.gl_acct_no;
         v_giacr354_uw.gl_amount := rec4.gl;
         v_giacr354_uw.uw_amount := rec4.uw;
         v_giacr354_uw.variances := rec4.variances;
         PIPE ROW (v_giacr354_uw);
      END LOOP;

      FOR rec5 IN due_to_trty
      LOOP
         v_giacr354_uw.branch_cd := rec5.branch_cd;
         v_giacr354_uw.line_cd := rec5.line_cd;
         v_giacr354_uw.gl_acct_name := rec5.gl_acct_name;
         v_giacr354_uw.base_amt := rec5.base_amt;
         v_giacr354_uw.gl_acct_no := rec5.gl_acct_no;
         v_giacr354_uw.gl_amount := rec5.gl;
         v_giacr354_uw.uw_amount := rec5.uw;
         v_giacr354_uw.variances := rec5.variances;
         PIPE ROW (v_giacr354_uw);
      END LOOP;

      FOR rec6 IN misc_entries
      LOOP
         v_giacr354_uw.branch_cd := rec6.branch_cd;
         v_giacr354_uw.line_cd := rec6.line_cd;
         v_giacr354_uw.gl_acct_name := rec6.gl_acct_name;
         v_giacr354_uw.base_amt := rec6.base_amt;
         v_giacr354_uw.gl_acct_no := rec6.gl_acct_no;
         v_giacr354_uw.gl_amount := rec6.gl;
         v_giacr354_uw.uw_amount := rec6.uw;
         v_giacr354_uw.variances := rec6.variances;
         PIPE ROW (v_giacr354_uw);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_uw_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED
   IS
      /* UW vs TAB2 - per POLICY per DIST NO */
      v_giacr354_uw_dtl   giacr354_dtl_rec_type;
      v_module            VARCHAR2 (10)         := 'GIACB002';
      v_item_no           NUMBER                := 1;
      v_tran_class        VARCHAR2 (5)          := 'UW';

      CURSOR prem_ceded_trty
      IS
         SELECT   DECODE (NVL (x.branch_cd, y.cred_branch),
                          'RI', '2PREMIUM',
                          '1PREMIUM'
                         ) base_amt,
                  NVL (x.branch_cd, y.cred_branch) branch_cd,
                  NVL (x.line_cd, y.line_cd) line_cd,
                  NVL (x.policy_no, y.policy_no) policy_no,
                  NVL (x.policy_id, y.policy_id) policy_id,
                  NVL (x.dist_no, y.dist_no) dist_no,
                                                     --NVL (x.acct_trty_type, y.acct_trty_type) acct_trty_type,
                                                     x.prem_amt, y.trty_prem,
                  NVL (x.prem_amt, 0) - NVL (trty_prem, 0) variances
             FROM (SELECT   a.branch_cd, a.line_cd,
                            get_policy_no (a.policy_id) policy_no,
                            a.policy_id, a.dist_no,       --b.acct_trty_type,
                            SUM (a.premium_amt) prem_amt
                       FROM giac_treaty_cessions a, giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.treaty_yy = b.trty_yy
                        AND a.share_cd = b.share_cd
                        AND a.acct_ent_date BETWEEN p_from_date AND p_to_date
                   GROUP BY a.branch_cd, a.line_cd, a.policy_id, a.dist_no --,
                                                                          --b.acct_trty_type
                  ) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            get_policy_no (a.policy_id) policy_no,
                            a.policy_id, a.dist_no,        --b.acct_trty_type,
                            SUM (a.tr_dist_prem) trty_prem
                       FROM gipi_uwreports_dist_peril_ext a,
                            giis_dist_share b
                      WHERE 1 = 1
                        AND a.line_cd = b.line_cd
                        AND a.share_cd = b.share_cd
                        AND a.user_id = USER
                        AND a.from_date1 = p_from_date
                        AND a.to_date1 = p_to_date
                        AND a.tr_dist_prem != 0
                   GROUP BY a.cred_branch,
                            a.line_cd,
                            a.policy_id,
                            a.dist_no                                      --,
                                     --b.acct_trty_type
                  ) y
                  ON x.branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.policy_id = y.policy_id
                AND x.dist_no = y.dist_no
         --AND x.acct_trty_type = y.acct_trty_type
         ORDER BY 1, 2, 3, 5;
   BEGIN
      FOR rec IN prem_ceded_trty
      LOOP
         v_giacr354_uw_dtl.branch_cd := rec.branch_cd;
         v_giacr354_uw_dtl.line_cd := rec.line_cd;
         v_giacr354_uw_dtl.policy_no := rec.policy_no;
         v_giacr354_uw_dtl.policy_id := rec.policy_id;
         v_giacr354_uw_dtl.dist_no := rec.dist_no;
         --v_giacr354_uw_dtl.acct_trty_type := rec.acct_trty_type;
         v_giacr354_uw_dtl.base_amt := rec.base_amt;
         v_giacr354_uw_dtl.gl_amount := rec.prem_amt;
         v_giacr354_uw_dtl.uw_amount := rec.trty_prem;
         v_giacr354_uw_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_uw_dtl);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_of (p_from_date DATE, p_to_date DATE, p_post_tran VARCHAR2)
      RETURN giacr354_type PIPELINED
   IS
      /* OF vs TAB3 */
      v_giacr354_of            giacr354_rec_type;
      v_module                 VARCHAR2 (10)     := 'GIACB003';
      v_item_no                NUMBER            := 1;
      v_tran_class             VARCHAR2 (5)      := 'OF';
      v_separate_cessions_gl   VARCHAR2 (1)
                               := NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N');

      CURSOR prem_ceded_facul
      IS
         SELECT   '1PREMIUM' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.facul_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.facul_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.share_premium) facul_prem
                       FROM gipi_uwreports_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND cred_branch != 'RI'
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         UNION
         SELECT   '2PREMIUM' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.facul_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.facul_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 11,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.share_premium) facul_prem
                       FROM gipi_uwreports_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND cred_branch = 'RI'
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR prem_ceded_facul2
      IS
         SELECT   '1PREMIUM' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.facul_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.facul_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.share_premium) facul_prem
                       FROM gipi_uwreports_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR comm_inc_facul
      IS
         SELECT   '3COMMISSION INC' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.facul_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.facul_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.ri_comm_amt) * -1 facul_comm
                       FROM gipi_uwreports_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND cred_branch != 'RI'
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         UNION
         SELECT   '3COMMISSION INC' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.facul_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.facul_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 12,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.ri_comm_amt) * -1 facul_comm
                       FROM gipi_uwreports_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND cred_branch = 'RI'
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR comm_inc_facul2
      IS
         SELECT   '3COMMISSION INC' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.facul_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.facul_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.ri_comm_amt) * -1 facul_comm
                       FROM gipi_uwreports_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR due_to_facul
      IS
         SELECT   '5PREMIUMS DUE TO' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.net_due, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.net_due, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 3,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            DECODE
                               (NVL (giacp.v ('GEN_VAT_ON_RI'), 'BL'),
                                'BL', (DECODE
                                          (NVL (giacp.v ('GEN_TRTY_PREM_VAT'),
                                                'N'
                                               ),
                                           'BL', (DECODE
                                                     (NVL
                                                         (giacp.v
                                                             ('GEN_PREM_VAT_FOREIGN'
                                                             ),
                                                          'N'
                                                         ),
                                                      'N', (  SUM (a.net_due)
                                                            * -1),
                                                        SUM
                                                           (  a.net_due
                                                            - NVL
                                                                 (a.ri_prem_vat,
                                                                  0
                                                                 )
                                                           )
                                                      * -1
                                                     )
                                            ),
                                             SUM (  a.net_due
                                                  - NVL (a.ri_prem_vat, 0)
                                                 )
                                           * -1
                                          )
                                 ),
                                SUM (a.net_due - NVL (a.ri_prem_vat, 0)) * -1
                               ) net_due
                       FROM gipi_uwreports_ri_ext a, giis_reinsurer b
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND a.ri_cd = b.ri_cd
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON x.gibr_branch_cd = y.cred_branch
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR prem_vat_facul
      IS
         SELECT   '3PREMIUM VAT' base_amt, '' branch_cd, '' line_cd,
                  x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.prem_vat, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.prem_vat, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 6,
                                                                 v_tran_class,
                                                                 'N',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT DECODE
                             (NVL (giacp.v ('GEN_VAT_ON_RI'), 'BL'),
                              'BL', (DECODE
                                        (NVL (giacp.v ('GEN_TRTY_PREM_VAT'),
                                              'N'
                                             ),
                                         'BL', (DECODE
                                                   (NVL
                                                       (giacp.v
                                                           ('GEN_PREM_VAT_FOREIGN'
                                                           ),
                                                        'N'
                                                       ),
                                                    'N', (  SUM (a.ri_prem_vat)
                                                          * -1),
                                                    0
                                                   )
                                          ),
                                         0 * -1
                                        )
                               ),
                              0
                             ) prem_vat
                     FROM gipi_uwreports_ri_ext a, giis_reinsurer b
                    WHERE a.user_id = USER
                      AND from_date = p_from_date
                      AND TO_DATE = p_to_date
                      AND a.ri_cd = b.ri_cd) y ON 1 = 1
         ORDER BY 1, 2;

      CURSOR comm_vat_facul
      IS
         SELECT   '4RI COMM VAT' base_amt, '' branch_cd, '' line_cd,
                  x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.comm_vat, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.comm_vat, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 7,
                                                                 v_tran_class,
                                                                 'N',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT SUM (a.ri_comm_vat) * -1 comm_vat
                     FROM gipi_uwreports_ri_ext a
                    WHERE a.user_id = USER
                      AND from_date = p_from_date
                      AND TO_DATE = p_to_date) y ON 1 = 1
         ORDER BY 1, 2;

      CURSOR misc_entries
      IS
         SELECT   'MISCELLANEOUS' base_amt, x.gibr_branch_cd branch_cd,
                  x.line_cd line_cd, x.gl_acct_name, gl_acct_no,
                  x.balance "GL", 0 "UW", x.balance - 0 variances
             FROM (SELECT   e.gibr_branch_cd, c.gl_acct_name, '' line_cd,
                            get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                            SUM (debit_amt) debit, SUM (credit_amt) credit,
                            SUM (debit_amt) - SUM (credit_amt) balance
                       FROM giac_modules a,
                            giac_module_entries b,
                            giac_chart_of_accts c,
                            giac_acct_entries d,
                            giac_acctrans e
                      WHERE 1 = 1
                        AND a.module_id = b.module_id
                        AND module_name = 'GIACB003'
                        AND b.item_no IN (4, 5)
                        AND c.gl_acct_category = d.gl_acct_category
                        AND c.gl_control_acct = d.gl_control_acct
                        AND c.gl_sub_acct_1 = d.gl_sub_acct_1
                        AND c.gl_sub_acct_2 = d.gl_sub_acct_2
                        AND c.gl_sub_acct_3 = d.gl_sub_acct_3
                        AND c.gl_sub_acct_4 = d.gl_sub_acct_4
                        AND c.gl_sub_acct_5 = d.gl_sub_acct_5
                        AND c.gl_sub_acct_6 = d.gl_sub_acct_6
                        AND c.gl_sub_acct_7 = d.gl_sub_acct_7
                        AND d.gacc_tran_id = e.tran_id
                        AND e.tran_class = 'OF'
                        AND e.tran_flag <> 'D'
                        AND DECODE (p_post_tran,
                                    'T', TRUNC (e.tran_date),
                                    'P', TRUNC (e.posting_date)
                                   ) BETWEEN p_from_date AND p_to_date
                        AND b.gl_acct_category = c.gl_acct_category
                        AND b.gl_control_acct = c.gl_control_acct
                        AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                        AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                        AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                        AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                        AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                        AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                        AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                        AND c.leaf_tag = 'Y'
                   GROUP BY e.gibr_branch_cd, c.gl_acct_name, d.gl_acct_id) x
         ORDER BY 1, 3;
   BEGIN
      IF v_separate_cessions_gl = 'Y'
      THEN
         FOR rec IN prem_ceded_facul
         LOOP
            v_giacr354_of.branch_cd := rec.branch_cd;
            v_giacr354_of.line_cd := rec.line_cd;
            v_giacr354_of.gl_acct_name := rec.gl_acct_name;
            v_giacr354_of.base_amt := rec.base_amt;
            v_giacr354_of.gl_acct_no := rec.gl_acct_no;
            v_giacr354_of.gl_amount := rec.gl;
            v_giacr354_of.uw_amount := rec.uw;
            v_giacr354_of.variances := rec.variances;
            PIPE ROW (v_giacr354_of);
         END LOOP;

         FOR rec2 IN comm_inc_facul
         LOOP
            v_giacr354_of.branch_cd := rec2.branch_cd;
            v_giacr354_of.line_cd := rec2.line_cd;
            v_giacr354_of.gl_acct_name := rec2.gl_acct_name;
            v_giacr354_of.base_amt := rec2.base_amt;
            v_giacr354_of.gl_acct_no := rec2.gl_acct_no;
            v_giacr354_of.gl_amount := rec2.gl;
            v_giacr354_of.uw_amount := rec2.uw;
            v_giacr354_of.variances := rec2.variances;
            PIPE ROW (v_giacr354_of);
         END LOOP;
      ELSE
         FOR rec IN prem_ceded_facul2
         LOOP
            v_giacr354_of.branch_cd := rec.branch_cd;
            v_giacr354_of.line_cd := rec.line_cd;
            v_giacr354_of.gl_acct_name := rec.gl_acct_name;
            v_giacr354_of.base_amt := rec.base_amt;
            v_giacr354_of.gl_acct_no := rec.gl_acct_no;
            v_giacr354_of.gl_amount := rec.gl;
            v_giacr354_of.uw_amount := rec.uw;
            v_giacr354_of.variances := rec.variances;
            PIPE ROW (v_giacr354_of);
         END LOOP;

         FOR rec2 IN comm_inc_facul2
         LOOP
            v_giacr354_of.branch_cd := rec2.branch_cd;
            v_giacr354_of.line_cd := rec2.line_cd;
            v_giacr354_of.gl_acct_name := rec2.gl_acct_name;
            v_giacr354_of.base_amt := rec2.base_amt;
            v_giacr354_of.gl_acct_no := rec2.gl_acct_no;
            v_giacr354_of.gl_amount := rec2.gl;
            v_giacr354_of.uw_amount := rec2.uw;
            v_giacr354_of.variances := rec2.variances;
            PIPE ROW (v_giacr354_of);
         END LOOP;
      END IF;

      FOR rec3 IN due_to_facul
      LOOP
         v_giacr354_of.branch_cd := rec3.branch_cd;
         v_giacr354_of.line_cd := rec3.line_cd;
         v_giacr354_of.gl_acct_name := rec3.gl_acct_name;
         v_giacr354_of.base_amt := rec3.base_amt;
         v_giacr354_of.gl_acct_no := rec3.gl_acct_no;
         v_giacr354_of.gl_amount := rec3.gl;
         v_giacr354_of.uw_amount := rec3.uw;
         v_giacr354_of.variances := rec3.variances;
         PIPE ROW (v_giacr354_of);
      END LOOP;

      FOR rec4 IN prem_vat_facul
      LOOP
         v_giacr354_of.branch_cd := rec4.branch_cd;
         v_giacr354_of.line_cd := rec4.line_cd;
         v_giacr354_of.gl_acct_name := rec4.gl_acct_name;
         v_giacr354_of.base_amt := rec4.base_amt;
         v_giacr354_of.gl_acct_no := rec4.gl_acct_no;
         v_giacr354_of.gl_amount := rec4.gl;
         v_giacr354_of.uw_amount := rec4.uw;
         v_giacr354_of.variances := rec4.variances;
         PIPE ROW (v_giacr354_of);
      END LOOP;

      FOR rec5 IN comm_vat_facul
      LOOP
         v_giacr354_of.branch_cd := rec5.branch_cd;
         v_giacr354_of.line_cd := rec5.line_cd;
         v_giacr354_of.gl_acct_name := rec5.gl_acct_name;
         v_giacr354_of.base_amt := rec5.base_amt;
         v_giacr354_of.gl_acct_no := rec5.gl_acct_no;
         v_giacr354_of.gl_amount := rec5.gl;
         v_giacr354_of.uw_amount := rec5.uw;
         v_giacr354_of.variances := rec5.variances;
         PIPE ROW (v_giacr354_of);
      END LOOP;

      FOR rec6 IN misc_entries
      LOOP
         v_giacr354_of.branch_cd := rec6.branch_cd;
         v_giacr354_of.line_cd := rec6.line_cd;
         v_giacr354_of.gl_acct_name := rec6.gl_acct_name;
         v_giacr354_of.base_amt := rec6.base_amt;
         v_giacr354_of.gl_acct_no := rec6.gl_acct_no;
         v_giacr354_of.gl_amount := rec6.gl;
         v_giacr354_of.uw_amount := rec6.uw;
         v_giacr354_of.variances := rec6.variances;
         PIPE ROW (v_giacr354_of);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_of_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED
   IS
      /* TAB3 - per POLICY */
      v_giacr354_of_dtl        giacr354_dtl_rec_type;
      v_separate_cessions_gl   VARCHAR2 (1)
                               := NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N');

      CURSOR prem_due_to
      IS
         SELECT   '5PREMIUMS DUE TO' base_amt,
                  NVL (x.branch_cd, y.cred_branch) branch_cd,
                  NVL (x.line_cd, y.line_cd) line_cd,
                  NVL (x.policy_no, y.policy_no) policy_no,
                  NVL (x.policy_id, y.policy_id) policy_id,
                  NVL (x.binder_no, y.binder_no) binder_no, x.due_to,
                  y.net_due, NVL (x.due_to, 0) - NVL (y.net_due, 0)
                                                                   variances
             FROM (SELECT   branch_cd, line_cd, policy_no, policy_id,
                            binder_no, SUM (due_to) due_to
                       FROM (SELECT   NVL (g.cred_branch, g.iss_cd) branch_cd,
                                      g.line_cd,
                                      get_policy_no (g.policy_id) policy_no,
                                      g.policy_id,
                                      get_binder_no
                                                   (b.fnl_binder_id)
                                                                    binder_no,
                                        (  SUM (a.ri_prem_amt * d.currency_rt)
                                         + SUM (  NVL (a.ri_prem_vat, 0)
                                                * d.currency_rt
                                               )
                                        )
                                      - (  SUM (  NVL (a.ri_comm_amt, 0)
                                                * d.currency_rt
                                               )
                                         + SUM (  NVL (a.ri_comm_vat, 0)
                                                * d.currency_rt
                                               )
                                         + SUM (  NVL (a.ri_wholding_vat, 0)
                                                * d.currency_rt
                                               )
                                        ) due_to
                                 FROM giri_frperil a,
                                      giri_frps_ri b,
                                      giri_binder c,
                                      giri_distfrps d,
                                      giuw_policyds e,
                                      giuw_pol_dist f,
                                      gipi_polbasic g,
                                      giis_line i,
                                      giis_subline j,
                                      giis_reinsurer k
                                WHERE a.line_cd = b.line_cd
                                  AND a.frps_yy = b.frps_yy
                                  AND a.frps_seq_no = b.frps_seq_no
                                  AND a.ri_seq_no = b.ri_seq_no
                                  AND a.ri_cd = k.ri_cd
                                  AND b.fnl_binder_id = c.fnl_binder_id
                                  AND b.line_cd = d.line_cd
                                  AND b.frps_yy = d.frps_yy
                                  AND b.frps_seq_no = d.frps_seq_no
                                  AND d.dist_no = e.dist_no
                                  AND d.dist_seq_no = e.dist_seq_no
                                  AND e.dist_no = f.dist_no
                                  AND f.policy_id = g.policy_id
                                  AND g.acct_ent_date IS NOT NULL
                                  AND LAST_DAY (g.acct_ent_date) <=
                                                          LAST_DAY (p_to_date)
                                  AND TRUNC (c.acc_ent_date) BETWEEN p_from_date
                                                                 AND p_to_date
                                  AND LAST_DAY (TRUNC (f.acct_ent_date)) <=
                                                          LAST_DAY (p_to_date)
                                  AND g.line_cd = i.line_cd
                                  AND g.line_cd = j.line_cd
                                  AND g.subline_cd = j.subline_cd
                                  AND g.reg_policy_sw = 'Y'
                             GROUP BY NVL (g.cred_branch, g.iss_cd),
                                      g.line_cd,
                                      g.policy_id,
                                      b.fnl_binder_id
                             UNION
                             SELECT   NVL (g.cred_branch, g.iss_cd) branch_cd,
                                      g.line_cd,
                                      get_policy_no (g.policy_id) policy_no,
                                      g.policy_id,
                                      get_binder_no
                                                   (b.fnl_binder_id)
                                                                    binder_no,
                                        (  (  SUM (  a.ri_prem_amt
                                                   * d.currency_rt
                                                  )
                                            + SUM (  NVL (a.ri_prem_vat, 0)
                                                   * d.currency_rt
                                                  )
                                           )
                                         - (  SUM (  NVL (a.ri_comm_amt, 0)
                                                   * d.currency_rt
                                                  )
                                            + SUM (  NVL (a.ri_comm_vat, 0)
                                                   * d.currency_rt
                                                  )
                                            + SUM (  NVL (a.ri_wholding_vat,
                                                          0)
                                                   * d.currency_rt
                                                  )
                                           )
                                        )
                                      * -1 due_to
                                 FROM giri_frperil a,
                                      giri_frps_ri b,
                                      giri_binder c,
                                      giri_distfrps d,
                                      giuw_policyds e,
                                      giuw_pol_dist f,
                                      gipi_polbasic g,
                                      giis_line i,
                                      giis_subline j,
                                      giis_reinsurer k
                                WHERE a.line_cd = b.line_cd
                                  AND a.frps_yy = b.frps_yy
                                  AND a.frps_seq_no = b.frps_seq_no
                                  AND a.ri_seq_no = b.ri_seq_no
                                  AND a.ri_cd = k.ri_cd
                                  AND b.fnl_binder_id = c.fnl_binder_id
                                  AND b.line_cd = d.line_cd
                                  AND b.frps_yy = d.frps_yy
                                  AND b.frps_seq_no = d.frps_seq_no
                                  AND d.dist_no = e.dist_no
                                  AND d.dist_seq_no = e.dist_seq_no
                                  AND e.dist_no = f.dist_no
                                  AND f.policy_id = g.policy_id
                                  AND g.acct_ent_date IS NOT NULL
                                  AND LAST_DAY (g.acct_ent_date) <=
                                                          LAST_DAY (p_to_date)
                                  AND TRUNC (c.acc_rev_date) BETWEEN p_from_date
                                                                 AND p_to_date
                                  AND (   (    f.dist_flag = '4'
                                           AND LAST_DAY
                                                       (TRUNC (f.acct_neg_date)
                                                       ) <=
                                                          LAST_DAY (p_to_date)
                                          )             --negated distribution
                                       OR (     /*f.dist_flag = '3'
                                            AND */b.reverse_sw = 'Y'
                                          )                  --reversed binder
                                       OR f.dist_flag = '5'    --redistributed
                                      )
                                  AND g.line_cd = i.line_cd
                                  AND g.line_cd = j.line_cd
                                  AND g.subline_cd = j.subline_cd
                                  AND g.reg_policy_sw = 'Y'
                             GROUP BY NVL (g.cred_branch, g.iss_cd),
                                      g.line_cd,
                                      g.policy_id,
                                      b.fnl_binder_id)
                   GROUP BY branch_cd,
                            line_cd,
                            policy_no,
                            policy_id,
                            binder_no) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd,
                            get_policy_no (policy_id) policy_no, policy_id,
                            binder_no, SUM (net_due) net_due
                       FROM gipi_uwreports_ri_ext
                      --edit padding of binder_no in P_UWREPORTS
                   WHERE    user_id = USER
                   GROUP BY cred_branch, line_cd, policy_id, binder_no) y
                  ON x.branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.policy_id = y.policy_id
                AND x.binder_no = y.binder_no
         ORDER BY 1, 2, 3;

      CURSOR prem_ceded_facul
      IS
         SELECT   DECODE (NVL (x.branch_cd, y.cred_branch),
                          'RI', DECODE (v_separate_cessions_gl,
                                        'Y', '2PREMIUM',
                                        '1PREMIUM'
                                       ),
                          '1PREMIUM'
                         ) base_amt,
                  NVL (x.branch_cd, y.cred_branch) branch_cd,
                  NVL (x.line_cd, y.line_cd) line_cd,
                  NVL (x.policy_no, y.policy_no) policy_no,
                  NVL (x.policy_id, y.policy_id) policy_id,
                  NVL (x.binder_no, y.binder_no) binder_no, x.prem_ceded,
                  y.share_premium,
                  NVL (x.prem_ceded, 0) - NVL (y.share_premium, 0) variances
             FROM (SELECT   branch_cd, line_cd, policy_no, policy_id,
                            binder_no, SUM (prem_ceded) prem_ceded
                       FROM (SELECT   NVL (g.cred_branch, g.iss_cd) branch_cd,
                                      g.line_cd,
                                      get_policy_no (g.policy_id) policy_no,
                                      g.policy_id,
                                      get_binder_no
                                                   (b.fnl_binder_id)
                                                                    binder_no,
                                      SUM (a.ri_prem_amt * d.currency_rt
                                          ) prem_ceded
                                 FROM giri_frperil a,
                                      giri_frps_ri b,
                                      giri_binder c,
                                      giri_distfrps d,
                                      giuw_policyds e,
                                      giuw_pol_dist f,
                                      gipi_polbasic g,
                                      giis_line i,
                                      giis_subline j,
                                      giis_reinsurer k
                                WHERE a.line_cd = b.line_cd
                                  AND a.frps_yy = b.frps_yy
                                  AND a.frps_seq_no = b.frps_seq_no
                                  AND a.ri_seq_no = b.ri_seq_no
                                  AND a.ri_cd = k.ri_cd
                                  AND b.fnl_binder_id = c.fnl_binder_id
                                  AND b.line_cd = d.line_cd
                                  AND b.frps_yy = d.frps_yy
                                  AND b.frps_seq_no = d.frps_seq_no
                                  AND d.dist_no = e.dist_no
                                  AND d.dist_seq_no = e.dist_seq_no
                                  AND e.dist_no = f.dist_no
                                  AND f.policy_id = g.policy_id
                                  AND g.acct_ent_date IS NOT NULL
                                  AND LAST_DAY (g.acct_ent_date) <=
                                                          LAST_DAY (p_to_date)
                                  AND TRUNC (c.acc_ent_date) BETWEEN p_from_date
                                                                 AND p_to_date
                                  AND LAST_DAY (TRUNC (f.acct_ent_date)) <=
                                                          LAST_DAY (p_to_date)
                                  AND g.line_cd = i.line_cd
                                  AND g.line_cd = j.line_cd
                                  AND g.subline_cd = j.subline_cd
                                  AND g.reg_policy_sw = 'Y'
                             GROUP BY NVL (g.cred_branch, g.iss_cd),
                                      g.line_cd,
                                      g.policy_id,
                                      b.fnl_binder_id
                             UNION
                             SELECT   NVL (g.cred_branch, g.iss_cd) branch_cd,
                                      g.line_cd,
                                      get_policy_no (g.policy_id) policy_no,
                                      g.policy_id,
                                      get_binder_no
                                                   (b.fnl_binder_id)
                                                                    binder_no,
                                        SUM (a.ri_prem_amt * d.currency_rt
                                            )
                                      * -1 prem_ceded
                                 FROM giri_frperil a,
                                      giri_frps_ri b,
                                      giri_binder c,
                                      giri_distfrps d,
                                      giuw_policyds e,
                                      giuw_pol_dist f,
                                      gipi_polbasic g,
                                      giis_line i,
                                      giis_subline j,
                                      giis_reinsurer k
                                WHERE a.line_cd = b.line_cd
                                  AND a.frps_yy = b.frps_yy
                                  AND a.frps_seq_no = b.frps_seq_no
                                  AND a.ri_seq_no = b.ri_seq_no
                                  AND a.ri_cd = k.ri_cd
                                  AND b.fnl_binder_id = c.fnl_binder_id
                                  AND b.line_cd = d.line_cd
                                  AND b.frps_yy = d.frps_yy
                                  AND b.frps_seq_no = d.frps_seq_no
                                  AND d.dist_no = e.dist_no
                                  AND d.dist_seq_no = e.dist_seq_no
                                  AND e.dist_no = f.dist_no
                                  AND f.policy_id = g.policy_id
                                  AND g.acct_ent_date IS NOT NULL
                                  AND LAST_DAY (g.acct_ent_date) <=
                                                          LAST_DAY (p_to_date)
                                  AND TRUNC (c.acc_rev_date) BETWEEN p_from_date
                                                                 AND p_to_date
                                  AND (   (    f.dist_flag = '4'
                                           AND LAST_DAY
                                                       (TRUNC (f.acct_neg_date)
                                                       ) <=
                                                          LAST_DAY (p_to_date)
                                          )             --negated distribution
                                       OR (     /*f.dist_flag = '3'
                                            AND */b.reverse_sw = 'Y'
                                          )                  --reversed binder
                                       OR f.dist_flag = '5'    --redistributed
                                      )
                                  AND g.line_cd = i.line_cd
                                  AND g.line_cd = j.line_cd
                                  AND g.subline_cd = j.subline_cd
                                  AND g.reg_policy_sw = 'Y'
                             GROUP BY NVL (g.cred_branch, g.iss_cd),
                                      g.line_cd,
                                      g.policy_id,
                                      b.fnl_binder_id)
                   GROUP BY branch_cd,
                            line_cd,
                            policy_no,
                            policy_id,
                            binder_no) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd,
                            get_policy_no (policy_id) policy_no, policy_id,
                            binder_no, SUM (share_premium) share_premium
                       FROM gipi_uwreports_ri_ext
                      --edit padding of binder_no in P_UWREPORTS
                   WHERE    user_id = USER
                   GROUP BY cred_branch, line_cd, policy_id, binder_no) y
                  ON x.branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.policy_id = y.policy_id
                AND x.binder_no = y.binder_no
         ORDER BY 1, 2, 3;
   BEGIN
      /*FOR rec IN prem_due_to
      LOOP
         v_giacr354_of_dtl.branch_cd := rec.branch_cd;
         v_giacr354_of_dtl.line_cd := rec.line_cd;
         v_giacr354_of_dtl.policy_no := rec.policy_no;
         v_giacr354_of_dtl.policy_id := rec.policy_id;
         v_giacr354_of_dtl.binder_no := rec.binder_no;
         v_giacr354_of_dtl.dist_no := NULL;
         v_giacr354_of_dtl.base_amt := rec.base_amt;
         v_giacr354_of_dtl.gl_amount := rec.due_to;
         v_giacr354_of_dtl.uw_amount := rec.net_due;
         v_giacr354_of_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_of_dtl);
      END LOOP;*/
      FOR rec2 IN prem_ceded_facul
      LOOP
         v_giacr354_of_dtl.branch_cd := rec2.branch_cd;
         v_giacr354_of_dtl.line_cd := rec2.line_cd;
         v_giacr354_of_dtl.policy_no := rec2.policy_no;
         v_giacr354_of_dtl.policy_id := rec2.policy_id;
         v_giacr354_of_dtl.binder_no := rec2.binder_no;
         v_giacr354_of_dtl.dist_no := NULL;
         v_giacr354_of_dtl.base_amt := rec2.base_amt;
         v_giacr354_of_dtl.gl_amount := rec2.prem_ceded;
         v_giacr354_of_dtl.uw_amount := rec2.share_premium;
         v_giacr354_of_dtl.variances := rec2.variances;
         PIPE ROW (v_giacr354_of_dtl);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_inf (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_type PIPELINED
   IS
      /* INF vs TAB6 */
      v_giacr354_inf   giacr354_rec_type;
      v_module         VARCHAR2 (10)     := 'GIACB004';
      v_item_no        NUMBER            := 1;
      v_tran_class     VARCHAR2 (5)      := 'INF';

      CURSOR prem_ceded_inf
      IS
         SELECT   '7RI PREMIUM' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.inw_prem, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.inw_prem, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.total_prem) * -1 inw_prem
                       FROM gipi_uwreports_inw_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON 1 = 1               --x.gibr_branch_cd = y.cred_branch(+)
                AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR comm_exp_inf
      IS
         SELECT   '8RI COMMI EXP' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.ri_comm, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.ri_comm, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 3,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (a.ri_comm_amt) ri_comm
                       FROM gipi_uwreports_inw_ri_ext a
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON 1 = 1
                          --x.gibr_branch_cd = y.cred_branch(+)
                     AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR comm_vat_inf
      IS
         SELECT   '9COMM VAT' base_amt, '' branch_cd, '' line_cd,
                  x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.comm_vat, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.comm_vat, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 7,
                                                                 v_tran_class,
                                                                 'N',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT 'XX' branch_cd, SUM (a.ri_comm_vat) comm_vat
                     FROM gipi_uwreports_inw_ri_ext a
                    WHERE a.user_id = USER
                      AND from_date = p_from_date
                      AND TO_DATE = p_to_date) y
                  ON 1 = 1                    --x.gibr_branch_cd = y.branch_cd
         ORDER BY 1, 2;

      CURSOR due_from_inf
      IS
         SELECT   '9DUE FROM' base_amt,
                  NVL (y.cred_branch, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.due_from, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.due_from, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 --added 3 parameters for Losses Paid by MAC 07/16/2013
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.cred_branch, a.line_cd,
                            SUM (  total_prem
                                 - ri_comm_amt
                                 - DECODE (local_foreign_sw,
                                           'L', ri_comm_vat,
                                           0
                                          )
                                ) due_from
                       FROM gipi_uwreports_inw_ri_ext a, giis_reinsurer b
                      WHERE a.user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND a.ri_cd = b.ri_cd
                   GROUP BY a.cred_branch, a.line_cd) y
                  ON 1 = 1                 -- x.gibr_branch_cd = y.cred_branch
                AND x.line_cd = y.line_cd
         ORDER BY 1, 2;

      CURSOR misc_entries
      IS
         SELECT   '9MISCELLANEOUS' base_amt, x.gibr_branch_cd branch_cd,
                  x.line_cd line_cd, x.gl_acct_name, gl_acct_no,
                  x.balance "GL", 0 "UW", x.balance - 0 variances
             FROM (SELECT   e.gibr_branch_cd, c.gl_acct_name, '' line_cd,
                            get_gl_acct_no (d.gl_acct_id) gl_acct_no,
                            SUM (debit_amt) debit, SUM (credit_amt) credit,
                            SUM (debit_amt) - SUM (credit_amt) balance
                       FROM giac_modules a,
                            giac_module_entries b,
                            giac_chart_of_accts c,
                            giac_acct_entries d,
                            giac_acctrans e
                      WHERE 1 = 1
                        AND a.module_id = b.module_id
                        AND module_name = 'GIACB004'
                        AND b.item_no IN (4, 5)
                        AND c.gl_acct_category = d.gl_acct_category
                        AND c.gl_control_acct = d.gl_control_acct
                        AND c.gl_sub_acct_1 = d.gl_sub_acct_1
                        AND c.gl_sub_acct_2 = d.gl_sub_acct_2
                        AND c.gl_sub_acct_3 = d.gl_sub_acct_3
                        AND c.gl_sub_acct_4 = d.gl_sub_acct_4
                        AND c.gl_sub_acct_5 = d.gl_sub_acct_5
                        AND c.gl_sub_acct_6 = d.gl_sub_acct_6
                        AND c.gl_sub_acct_7 = d.gl_sub_acct_7
                        AND d.gacc_tran_id = e.tran_id
                        AND e.tran_class = 'INF'
                        AND e.tran_flag <> 'D'
                        AND DECODE (p_post_tran,
                                    'T', TRUNC (e.tran_date),
                                    'P', TRUNC (e.posting_date)
                                   ) BETWEEN p_from_date AND p_to_date
                        AND b.gl_acct_category = c.gl_acct_category
                        AND b.gl_control_acct = c.gl_control_acct
                        AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                        AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                        AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                        AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                        AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                        AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                        AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                        AND c.leaf_tag = 'Y'
                   GROUP BY e.gibr_branch_cd, c.gl_acct_name, d.gl_acct_id) x
         ORDER BY 1, 3;
   BEGIN
      FOR rec IN prem_ceded_inf
      LOOP
         v_giacr354_inf.branch_cd := rec.branch_cd;
         v_giacr354_inf.line_cd := rec.line_cd;
         v_giacr354_inf.gl_acct_name := rec.gl_acct_name;
         v_giacr354_inf.base_amt := rec.base_amt;
         v_giacr354_inf.gl_acct_no := rec.gl_acct_no;
         v_giacr354_inf.gl_amount := rec.gl;
         v_giacr354_inf.uw_amount := rec.uw;
         v_giacr354_inf.variances := rec.variances;
         PIPE ROW (v_giacr354_inf);
      END LOOP;

      FOR rec2 IN comm_exp_inf
      LOOP
         v_giacr354_inf.branch_cd := rec2.branch_cd;
         v_giacr354_inf.line_cd := rec2.line_cd;
         v_giacr354_inf.gl_acct_name := rec2.gl_acct_name;
         v_giacr354_inf.base_amt := rec2.base_amt;
         v_giacr354_inf.gl_acct_no := rec2.gl_acct_no;
         v_giacr354_inf.gl_amount := rec2.gl;
         v_giacr354_inf.uw_amount := rec2.uw;
         v_giacr354_inf.variances := rec2.variances;
         PIPE ROW (v_giacr354_inf);
      END LOOP;

      FOR rec3 IN comm_vat_inf
      LOOP
         v_giacr354_inf.branch_cd := rec3.branch_cd;
         v_giacr354_inf.line_cd := rec3.line_cd;
         v_giacr354_inf.gl_acct_name := rec3.gl_acct_name;
         v_giacr354_inf.base_amt := rec3.base_amt;
         v_giacr354_inf.gl_acct_no := rec3.gl_acct_no;
         v_giacr354_inf.gl_amount := rec3.gl;
         v_giacr354_inf.uw_amount := rec3.uw;
         v_giacr354_inf.variances := rec3.variances;
         PIPE ROW (v_giacr354_inf);
      END LOOP;

      FOR rec4 IN due_from_inf
      LOOP
         v_giacr354_inf.branch_cd := rec4.branch_cd;
         v_giacr354_inf.line_cd := rec4.line_cd;
         v_giacr354_inf.gl_acct_name := rec4.gl_acct_name;
         v_giacr354_inf.base_amt := rec4.base_amt;
         v_giacr354_inf.gl_acct_no := rec4.gl_acct_no;
         v_giacr354_inf.gl_amount := rec4.gl;
         v_giacr354_inf.uw_amount := rec4.uw;
         v_giacr354_inf.variances := rec4.variances;
         PIPE ROW (v_giacr354_inf);
      END LOOP;

      FOR rec5 IN misc_entries
      LOOP
         v_giacr354_inf.branch_cd := rec5.branch_cd;
         v_giacr354_inf.line_cd := rec5.line_cd;
         v_giacr354_inf.gl_acct_name := rec5.gl_acct_name;
         v_giacr354_inf.base_amt := rec5.base_amt;
         v_giacr354_inf.gl_acct_no := rec5.gl_acct_no;
         v_giacr354_inf.gl_amount := rec5.gl;
         v_giacr354_inf.uw_amount := rec5.uw;
         v_giacr354_inf.variances := rec5.variances;
         PIPE ROW (v_giacr354_inf);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_inf_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED
   IS
      /* UW vs TAB2 - per POLICY per DIST NO */
      v_giacr354_inf_dtl   giacr354_dtl_rec_type;
      v_module             VARCHAR2 (10)         := 'GIACB001';
      v_item_no            NUMBER                := 1;
      v_tran_class         VARCHAR2 (5)          := 'UW';

      CURSOR gross_premium
      IS
         SELECT   '7RI PREMIUM' base_amt,
                  NVL (x.cred_branch, y.cred_branch) branch_cd,
                  NVL (x.line_cd, y.line_cd) line_cd,
                  NVL (x.policy_no, y.policy_no) policy_no,
                  NVL (x.policy_id, y.policy_id) policy_id, x.pol_flag,
                  x.prem_amt, y.total_prem,
                  NVL (x.prem_amt, 0) - NVL (total_prem, 0) variances
             FROM (SELECT   b.cred_branch, b.line_cd, a.policy_id,
                            get_policy_no (a.policy_id) policy_no,
                            DECODE (a.spoiled_acct_ent_date,
                                    p_to_date, 'SPOILED',
                                    ''
                                   ) pol_flag,
                            SUM (  a.prem_amt
                                 * a.currency_rt
                                 * DECODE (a.spoiled_acct_ent_date,
                                           p_to_date, -1,
                                           1
                                          )
                                ) prem_amt
                       FROM gipi_invoice a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND (   a.acct_ent_date BETWEEN p_from_date AND p_to_date
                             OR a.spoiled_acct_ent_date BETWEEN p_from_date
                                                            AND p_to_date
                            )
                        AND b.iss_cd = giisp.v ('RI')
                   GROUP BY b.cred_branch,
                            b.line_cd,
                            a.policy_id,
                            a.spoiled_acct_ent_date) x
                  FULL OUTER JOIN
                  (SELECT   cred_branch, line_cd, policy_id,
                            get_policy_no (policy_id) policy_no, '' pol_flag,
                            SUM (total_prem) total_prem
                       FROM gipi_uwreports_inw_ri_ext
                      WHERE user_id = USER
                        AND from_date = p_from_date
                        AND TO_DATE = p_to_date
                        AND iss_cd = giisp.v ('RI')
                   GROUP BY cred_branch, line_cd, policy_id) y
                  ON x.cred_branch = y.cred_branch
                AND x.line_cd = y.line_cd
                AND x.policy_id = y.policy_id
         ORDER BY 1, 2, 3, 4;
   BEGIN
      FOR rec IN gross_premium
      LOOP
         v_giacr354_inf_dtl.branch_cd := rec.branch_cd;
         v_giacr354_inf_dtl.line_cd := rec.line_cd;
         v_giacr354_inf_dtl.policy_no := rec.policy_no;
         v_giacr354_inf_dtl.policy_id := rec.policy_id;
         v_giacr354_inf_dtl.pol_flag := rec.pol_flag;
         v_giacr354_inf_dtl.base_amt := rec.base_amt;
         v_giacr354_inf_dtl.gl_amount := rec.prem_amt;
         v_giacr354_inf_dtl.uw_amount := rec.total_prem;
         v_giacr354_inf_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_inf_dtl);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_ol (p_from_date DATE, p_to_date DATE, p_post_tran VARCHAR2)
      RETURN giacr354_brdrx_reg_type PIPELINED
   IS
      /* OL vs BORDEREAUX (Outstanding Losses) */
      v_giacr354_ol   giacr354_brdrx_rec_type;
      v_module        VARCHAR2 (10)           := 'GICLB001';
      v_item_no       NUMBER                  := 1;
      v_tran_class    VARCHAR2 (5)            := 'OL';
      v_session_id    NUMBER                  := 0;

      --created cursor to select Outstanding Losses from GL and Bordereaux by MAC 07/17/2013.
      CURSOR os_loss (p_session_id NUMBER)
      IS
         --Item 1 (DIRECT OL LOSS RESERVE)
         SELECT   'LOSS RESERVE - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 1,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   iss_cd, line_cd, SUM (loss_reserve) outstanding
                       FROM gicl_res_brdrx_extr
                      WHERE session_id = p_session_id
                        AND iss_cd != giacp.v ('RI_ISS_CD')
                        AND loss_reserve != 0
                   GROUP BY iss_cd, line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 2 (DIRECT OL EXPENSE RESERVE)
         SELECT   'EXPENSE RESERVE - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 2,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   iss_cd, line_cd, SUM (expense_reserve)
                                                                  outstanding
                       FROM gicl_res_brdrx_extr
                      WHERE session_id = p_session_id
                        AND iss_cd != giacp.v ('RI_ISS_CD')
                        AND expense_reserve != 0
                   GROUP BY iss_cd, line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 3 (INWARD OL LOSS RESERVE)
         SELECT   'LOSS RESERVE - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 3,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   iss_cd, line_cd, SUM (loss_reserve) outstanding
                       FROM gicl_res_brdrx_extr
                      WHERE session_id = p_session_id
                        AND iss_cd = giacp.v ('RI_ISS_CD')
                        AND loss_reserve != 0
                   GROUP BY iss_cd, line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 4 (INWARD OL EXPENSE RESERVE)
         SELECT   'EXPENSE RESERVE - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 4,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   iss_cd, line_cd, SUM (expense_reserve)
                                                                  outstanding
                       FROM gicl_res_brdrx_extr
                      WHERE session_id = p_session_id
                        AND iss_cd = giacp.v ('RI_ISS_CD')
                        AND expense_reserve != 0
                   GROUP BY iss_cd, line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 5 (OL LOSS RESERVE PER LINE, TREATY)
         SELECT   'LOSS DISTRIBUTION - TREATY - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 5,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                            SUM (a.loss_reserve) outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('TRTY_SHARE_TYPE')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.iss_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 6 (OL LOSS RESERVE PER FACUL)
         SELECT   'LOSS DISTRIBUTION - FACUL - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 6,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 16 (OL LOSS RESERVE PER LINE, XOL LAYER)
         SELECT   'LOSS DISTRIBUTION - XOL - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 16,
                                                                 v_tran_class,
                                                                 'BLX',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                            SUM (a.loss_reserve) outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.iss_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 13 (OL EXPENSE RESERVE PER LINE, TREATY)
         SELECT   'EXP DISTRIBUTION - TREATY - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 13,
                                                                 v_tran_class,
                                                                 'BLT',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                            SUM (a.expense_reserve) outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('TRTY_SHARE_TYPE')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.iss_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 14 (OL EXPENSE RESERVE PER FACUL)
         SELECT   'EXP DISTRIBUTION - FACUL - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 14,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 17 (OL EXPENSE RESERVE PER LINE, XOL LAYER)
         SELECT   'EXP DISTRIBUTION - XOL - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 17,
                                                                 v_tran_class,
                                                                 'BLX',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                            SUM (a.expense_reserve) outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                  ON x.gibr_branch_cd = y.iss_cd
                AND x.line_cd = y.line_cd
                AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 7 (DIRECT OL LOSS RESERVE PER LINE (TREATY ONLY))
         SELECT   'LOSS DISTRIBUTION - TREATY2 - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 7,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     7,
                                                                     24
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     7,
                                                                     24
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 8 (DIRECT OL LOSS RESERVE PER LINE (FACUL ONLY))
         SELECT   'LOSS DISTRIBUTION - FACUL2 - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 8,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 24 (DIRECT OL LOSS RESERVE PER LINE (XOL ONLY))
         SELECT   DECODE
                     (giacs354_pkg.is_gl_treaty_xol_same (v_module, 7, 24),
                      1, 'LOSS DISTRIBUTION - TREATY2 - DIRECT',
                      'LOSS DISTRIBUTION - XOL2 - DIRECT'
                     ) base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 24,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     7,
                                                                     24
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('XOL_TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     7,
                                                                     24
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 18 (DIRECT OL EXPENSE RESERVE PER LINE (TREATY ONLY))
         SELECT   'EXP DISTRIBUTION - TREATY2 - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 18,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     18,
                                                                     26
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     18,
                                                                     26
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 19 (DIRECT OL EXPENSE RESERVE PER LINE (FACUL ONLY))
         SELECT   'EXP DISTRIBUTION - FACUL2 - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 19,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 26 (DIRECT OL EXPENSE RESERVE PER LINE (XOL ONLY))
         SELECT   DECODE
                     (giacs354_pkg.is_gl_treaty_xol_same (v_module, 18, 26),
                      1, 'EXP DISTRIBUTION - TREATY2 - DIRECT',
                      'EXP DISTRIBUTION - XOL2 - DIRECT'
                     ) base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 26,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     18,
                                                                     26
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('XOL_TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     18,
                                                                     26
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 20 (INWARD OL LOSS RESERVE PER LINE (TREATY ONLY))
         SELECT   'LOSS DISTRIBUTION - TREATY - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 20,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     20,
                                                                     25
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     20,
                                                                     25
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 21 (INWARD OL LOSS RESERVE PER LINE (FACUL ONLY))
         SELECT   'LOSS DISTRIBUTION - FACUL - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 21,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 25 (INWARD OL LOSS RESERVE PER LINE (XOL ONLY))
         SELECT   DECODE
                     (giacs354_pkg.is_gl_treaty_xol_same (v_module, 20, 25),
                      1, 'LOSS DISTRIBUTION - TREATY - INWARD',
                      'LOSS DISTRIBUTION - XOL - INWARD'
                     ) base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 25,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     20,
                                                                     25
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('XOL_TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     20,
                                                                     25
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 22 (INWARD OL EXPENSE RESERVE PER LINE (TREATY ONLY))
         SELECT   'EXP DISTRIBUTION - TREATY - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 22,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     22,
                                                                     28
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     22,
                                                                     28
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 23 (INWARD OL EXPENSE RESERVE PER LINE (FACUL ONLY))
         SELECT   'EXP DISTRIBUTION - FACUL - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 23,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         --Item 28 (INWARD OL EXPENSE RESERVE PER LINE (XOL ONLY))
         UNION
         SELECT   DECODE
                     (giacs354_pkg.is_gl_treaty_xol_same (v_module, 22, 28),
                      1, 'EXP DISTRIBUTION - TREATY - INWARD',
                      'EXP DISTRIBUTION - XOL - INWARD'
                     ) base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 28,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND (   DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     22,
                                                                     28
                                                                    ),
                                    1, 1,
                                    b.share_type
                                   ) = giacp.v ('XOL_TRTY_SHARE_TYPE')
                             OR DECODE
                                   (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (v_module,
                                                                     22,
                                                                     28
                                                                    ),
                                    1, b.share_type,
                                    1
                                   ) IN
                                   (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                    giacp.v ('TRTY_SHARE_TYPE')
                                   )
                            )
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 9 (N - DIRECT OL LOSS RESERVE / Y - DIRECT OL LOSS RESERVE (NET RETENTION ONLY))
         SELECT   'LOSS DISTRIBUTION - NETRET - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 9,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND DECODE (giacp.v ('OS_NET_TAKEUP'),
                                    'N', 1,
                                    'Y', b.share_type
                                   ) = 1
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 10 (N - DIRECT OL EXPENSE RESERVE / Y - DIRECT OL EXPENSE RESERVE (NET RETENTION ONLY))
         SELECT   'EXP DISTRIBUTION - NETRET - DIRECT' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 10,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND DECODE (giacp.v ('OS_NET_TAKEUP'),
                                    'N', 1,
                                    'Y', b.share_type
                                   ) = 1
                        AND a.iss_cd != giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 11 (N - INWARD OL LOSS RESERVE / Y - INWARD OL LOSS RESERVE (NET RETENTION ONLY))
         SELECT   'LOSS DISTRIBUTION - NETRET - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 11,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.loss_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND DECODE (giacp.v ('OS_NET_TAKEUP'),
                                    'N', 1,
                                    'Y', b.share_type
                                   ) = 1
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.loss_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 12 (N - INWARD OL EXPENSE RESERVE / Y - INWARD OL EXPENSE RESERVE (NET RETENTION ONLY))
         SELECT   'EXP DISTRIBUTION - NETRET - INWARD' base_amt,
                  NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                  NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                  x.gl_acct_no, NVL (x.balance, 0) "GL",
                  NVL (y.outstanding, 0) "UW",
                  NVL (x.balance, 0) - NVL (y.outstanding, 0) variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 12,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
                  FULL OUTER JOIN
                  (SELECT   a.iss_cd, a.line_cd,
                            SUM (a.expense_reserve) * -1 outstanding
                       FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                      WHERE a.session_id = p_session_id
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.share_cd
                        AND DECODE (giacp.v ('OS_NET_TAKEUP'),
                                    'N', 1,
                                    'Y', b.share_type
                                   ) = 1
                        AND a.iss_cd = giacp.v ('RI_ISS_CD')
                        AND a.expense_reserve != 0
                   GROUP BY a.iss_cd, a.line_cd) y
                  ON x.gibr_branch_cd = y.iss_cd AND x.line_cd = y.line_cd
         UNION
         --Item 15 (OTHER OPERATING EXPENSE)
         SELECT   'MISCELLANEOUS' base_amt, x.gibr_branch_cd branch_cd,
                  x.line_cd, x.gl_acct_name, x.gl_acct_no,
                  NVL (x.balance, 0) "GL", 0 "UW",
                  NVL (x.balance, 0) - 0 variances
             FROM (SELECT *
                     FROM TABLE
                             (giacs354_pkg.select_gl_branch_line
                                                                (v_module,
                                                                 15,
                                                                 v_tran_class,
                                                                 'BL',
                                                                 p_post_tran,
                                                                 p_from_date,
                                                                 p_to_date
                                                                )
                             )) x
         ORDER BY 4, 1, 2;
   BEGIN
      BEGIN
         SELECT MAX (session_id)
           INTO v_session_id
           FROM gicl_res_brdrx_extr
          WHERE user_id = USER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      FOR rec IN os_loss (v_session_id)
      LOOP
         v_giacr354_ol.branch_cd := rec.branch_cd;
         v_giacr354_ol.line_cd := rec.line_cd;
         v_giacr354_ol.gl_acct_name := rec.gl_acct_name;
         v_giacr354_ol.base_amt := rec.base_amt;
         v_giacr354_ol.gl_acct_no := rec.gl_acct_no;
         v_giacr354_ol.gl_amount := rec.gl;
         v_giacr354_ol.brdrx_amount := rec.uw;
         v_giacr354_ol.variances := rec.variances;
         PIPE ROW (v_giacr354_ol);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_ol_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_brdrx_dtl_type PIPELINED
   IS
      v_giacr354_ol_dtl   giacr354_brdrx_dtl_rec_type;
      v_module            VARCHAR2 (10)               := 'GICLB001';
      v_item_no           NUMBER                      := 1;
      v_tran_class        VARCHAR2 (5)                := 'OL';
      v_session_id        NUMBER                      := 0;

      CURSOR os_loss_exp
      IS
         SELECT    'LOSS RESERVE - '
                || DECODE (NVL (x.iss_cd, y.iss_cd),
                           giisp.v ('RI'), 'INWARD',
                           'DIRECT'
                          ) base_amt,
                NVL (x.claim_no, y.claim_no) claim_no,
                NVL (x.iss_cd, y.iss_cd) iss_cd,
                NVL (x.line_cd, y.line_cd) line_cd,
                NVL (x.claim_id, y.claim_id) claim_id,
                NVL (x.item_no, y.item_no) item_no,
                NVL (x.peril_cd, y.peril_cd) peril_cd, x.os_loss gl,
                NVL (y.brdrx_loss, 0) brdrx
           FROM (SELECT   a.iss_cd, b.line_cd,
                          get_claim_number (a.claim_id) claim_no, a.claim_id,
                          item_no, a.peril_cd, SUM (a.os_loss) os_loss,
                          SUM (a.os_expense) os_expense
                     FROM gicl_take_up_hist a, gicl_claims b,
                          giac_acctrans c
                    WHERE a.claim_id = b.claim_id
                      AND a.acct_tran_id = c.tran_id
                      AND c.tran_class = 'OL'
                      AND c.tran_flag != 'D'
                      AND DECODE (p_post_tran,
                                  'P', TRUNC (c.posting_date),
                                  TRUNC (c.tran_date)
                                 ) BETWEEN p_from_date AND p_to_date
                      AND a.acct_date = p_to_date
                 GROUP BY a.iss_cd,
                          b.line_cd,
                          a.claim_id,
                          a.item_no,
                          a.peril_cd) x
                FULL OUTER JOIN
                (SELECT   iss_cd, line_cd,
                          get_claim_number (claim_id) claim_no, claim_id,
                          item_no, peril_cd,
                          SUM (loss_reserve - NVL (losses_paid, 0))
                                                                   brdrx_loss,
                          SUM (expense_reserve - NVL (expenses_paid, 0)
                              ) brdrx_expense
                     FROM gicl_res_brdrx_extr
                    WHERE user_id = USER
                 GROUP BY iss_cd, line_cd, claim_id, item_no, peril_cd) y
                ON x.claim_id = y.claim_id
              AND x.iss_cd = y.iss_cd
              AND x.line_cd = y.line_cd
              AND x.item_no = y.item_no
              AND x.peril_cd = y.peril_cd
         UNION
         SELECT    'EXPENSE RESERVE - '
                || DECODE (NVL (x.iss_cd, y.iss_cd),
                           giisp.v ('RI'), 'INWARD',
                           'DIRECT'
                          ) base_amt,
                NVL (x.claim_no, y.claim_no) claim_no,
                NVL (x.iss_cd, y.iss_cd) iss_cd,
                NVL (x.line_cd, y.line_cd) line_cd,
                NVL (x.claim_id, y.claim_id) claim_id,
                NVL (x.item_no, y.item_no) item_no,
                NVL (x.peril_cd, y.peril_cd) peril_cd, x.os_expense gl,
                NVL (y.brdrx_expense, 0) brdrx
           FROM (SELECT   a.iss_cd, b.line_cd,
                          get_claim_number (a.claim_id) claim_no, a.claim_id,
                          item_no, a.peril_cd, SUM (a.os_loss) os_loss,
                          SUM (a.os_expense) os_expense
                     FROM gicl_take_up_hist a, gicl_claims b, giac_acctrans c
                    WHERE a.claim_id = b.claim_id
                      AND a.acct_tran_id = c.tran_id
                      AND c.tran_class = 'OL'
                      AND c.tran_flag != 'D'
                      AND DECODE (p_post_tran,
                                  'P', TRUNC (c.posting_date),
                                  TRUNC (c.tran_date)
                                 ) BETWEEN p_from_date AND p_to_date
                      AND a.acct_date = p_to_date
                 GROUP BY a.iss_cd,
                          b.line_cd,
                          a.claim_id,
                          a.item_no,
                          a.peril_cd) x
                FULL OUTER JOIN
                (SELECT   iss_cd, line_cd,
                          get_claim_number (claim_id) claim_no, claim_id,
                          item_no, peril_cd,
                          SUM (loss_reserve - NVL (losses_paid, 0))
                                                                   brdrx_loss,
                          SUM (expense_reserve - NVL (expenses_paid, 0)
                              ) brdrx_expense
                     FROM gicl_res_brdrx_extr
                    WHERE user_id = USER
                 GROUP BY iss_cd, line_cd, claim_id, item_no, peril_cd) y
                ON x.claim_id = y.claim_id
              AND x.iss_cd = y.iss_cd
              AND x.line_cd = y.line_cd
              AND x.item_no = y.item_no
              AND x.peril_cd = y.peril_cd
                ;
   BEGIN
      FOR rec IN os_loss_exp
      LOOP
         v_giacr354_ol_dtl.line_cd := rec.line_cd;
         v_giacr354_ol_dtl.claim_no := rec.claim_no;
         v_giacr354_ol_dtl.claim_id := rec.claim_id;
         v_giacr354_ol_dtl.item_no := rec.item_no;
         v_giacr354_ol_dtl.peril_cd := rec.peril_cd;
         v_giacr354_ol_dtl.base_amt := rec.base_amt;
         v_giacr354_ol_dtl.gl_amount := rec.gl;
         v_giacr354_ol_dtl.brdrx_amount := rec.brdrx;
         --v_giacr354_ol_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_ol_dtl);
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_clm_payt (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_brdrx_reg_type PIPELINED
   IS
      v_giacr354_clm_payt   giacr354_brdrx_rec_type;
      v_module              VARCHAR2 (10);
      v_session_id          NUMBER                  := 0;

      CURSOR claim_payt (p_session_id NUMBER, p_module VARCHAR2)
      IS
         --Item 1 (LOSSES PAID)
         SELECT    DECODE (p_module, 'GIACS018', '2', '1')
                || 'LOSSES PAID' base_amt,
                NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  1,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   iss_cd, line_cd, SUM (losses_paid) paid_amt
                     FROM gicl_res_brdrx_extr
                    WHERE session_id = p_session_id
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND losses_paid != 0
                 GROUP BY iss_cd, line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 2 (LOSSES PAID (TREATY ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  2,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, SUM (losses_paid)
                                               * -1 paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND (   DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     2,
                                                                     17
                                                                    ),
                                  1, 1,
                                  b.share_type
                                 ) = giacp.v ('TRTY_SHARE_TYPE')
                           OR DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     2,
                                                                     17
                                                                    ),
                                  1, b.share_type,
                                  1
                                 ) IN
                                 (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                  giacp.v ('TRTY_SHARE_TYPE')
                                 )
                          )
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND losses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 3 (LOSSES PAID (FACUL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  3,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, SUM (losses_paid)
                                               * -1 paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND losses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 17 (LOSSES PAID (XOL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  17,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, SUM (losses_paid)
                                               * -1 paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND (   DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     2,
                                                                     17
                                                                    ),
                                  1, 1,
                                  b.share_type
                                 ) = giacp.v ('XOL_TRTY_SHARE_TYPE')
                           OR DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     2,
                                                                     17
                                                                    ),
                                  1, b.share_type,
                                  1
                                 ) IN
                                 (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                  giacp.v ('TRTY_SHARE_TYPE')
                                 )
                          )
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND losses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 4 (EXPENSES PAID)
         SELECT    DECODE (p_module, 'GIACS018', '4', '3')
                || 'EXPENSES PAID' base_amt,
                NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  4,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   iss_cd, line_cd, SUM (expenses_paid) paid_amt
                     FROM gicl_res_brdrx_extr
                    WHERE session_id = p_session_id
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND expenses_paid != 0
                 GROUP BY iss_cd, line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 5 (EXPENSES PAID (TREATY ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  5,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd,
                          SUM (expenses_paid) * -1 paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND (   DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     5,
                                                                     18
                                                                    ),
                                  1, 1,
                                  b.share_type
                                 ) = giacp.v ('TRTY_SHARE_TYPE')
                           OR DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     5,
                                                                     18
                                                                    ),
                                  1, b.share_type,
                                  1
                                 ) IN
                                 (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                  giacp.v ('TRTY_SHARE_TYPE')
                                 )
                          )
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND expenses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 6 (EXPENSES PAID (FACUL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  6,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd,
                          SUM (expenses_paid) * -1 paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND expenses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 18 (EXPENSES PAID (XOL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  18,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd,
                          SUM (expenses_paid) * -1 paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND (   DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     5,
                                                                     18
                                                                    ),
                                  1, 1,
                                  b.share_type
                                 ) = giacp.v ('XOL_TRTY_SHARE_TYPE')
                           OR DECODE
                                 (giacs354_pkg.is_gl_treaty_xol_same
                                                                    (p_module,
                                                                     5,
                                                                     18
                                                                    ),
                                  1, b.share_type,
                                  1
                                 ) IN
                                 (giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                  giacp.v ('TRTY_SHARE_TYPE')
                                 )
                          )
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND expenses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 7 (LOSSES PAID PER LINE, TREATY (TREATY ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  7,
                                                                  NULL,
                                                                  'BLT',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                          SUM (a.losses_paid) paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('TRTY_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND a.losses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
              --do not compare Issue Code if Inward by MAC 07/19/2013
              AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 8 (LOSSES PAID PER LINE (FACUL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  8,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, SUM (a.losses_paid) paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND a.losses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 13 (LOSSES PAID PER LINE, TREATY (XOL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  13,
                                                                  NULL,
                                                                  'BLX',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                          SUM (a.losses_paid) paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND a.losses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
              --do not compare Issue Code if Inward by MAC 07/19/2013
              AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 9 (EXPENSES PAID PER LINE, TREATY (TREATY ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  9,
                                                                  NULL,
                                                                  'BLT',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                          SUM (a.expenses_paid) paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('TRTY_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND a.expenses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
              --do not compare Issue Code if Inward by MAC 07/19/2013
              AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 10 (EXPENSES PAID PER LINE (FACUL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  10,
                                                                  NULL,
                                                                  'BL',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, SUM (a.expenses_paid) paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('FACUL_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND a.expenses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
         --do not compare Issue Code if Inward by MAC 07/19/2013
         UNION
         --Item 16 (EXPENSES PAID PER LINE, TREATY (XOL ONLY))
         SELECT '' base_amt, NVL (y.iss_cd, x.gibr_branch_cd) branch_cd,
                NVL (y.line_cd, x.line_cd) line_cd, x.gl_acct_name,
                x.gl_acct_no, NVL (x.balance, 0) "GL",
                NVL (y.paid_amt, 0) "UW",
                NVL (x.balance, 0) - NVL (y.paid_amt, 0) variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  16,
                                                                  NULL,
                                                                  'BLX',
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
                FULL OUTER JOIN
                (SELECT   a.iss_cd, a.line_cd, b.acct_trty_type,
                          SUM (a.expenses_paid) paid_amt
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE a.session_id = p_session_id
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND b.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                      AND (   (    iss_cd != giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS017'
                              )
                           OR (    iss_cd = giacp.v ('RI_ISS_CD')
                               AND p_module = 'GIACS018'
                              )
                          )
                      AND a.expenses_paid != 0
                 GROUP BY a.iss_cd, a.line_cd, b.acct_trty_type) y
                ON x.gibr_branch_cd =
                     DECODE (p_module,
                             'GIACS018', x.gibr_branch_cd,
                             y.iss_cd
                            )
              AND x.line_cd = y.line_cd
              --do not compare Issue Code if Inward by MAC 07/19/2013
              AND x.acct_trty_type = y.acct_trty_type
         UNION
         --Item 11 (MISCELLANEOUS INCOME)
         SELECT '' base_amt, x.gibr_branch_cd branch_cd, x.line_cd,
                x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL", 0 "UW",
                NVL (x.balance, 0) - 0 variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  11,
                                                                  NULL,
                                                                  'B',
                                                                  --use GL by Branch by MAC 01/06/2014
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
         UNION
         --Item 12 (OTHER OPERATING EXPENSE)
         SELECT '' base_amt, x.gibr_branch_cd branch_cd, x.line_cd,
                x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL", 0 "UW",
                NVL (x.balance, 0) - 0 variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  12,
                                                                  NULL,
                                                                  'B',
                                                                  --use GL by Branch by MAC 01/06/2014
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
         UNION
         --Item 14
         SELECT '' base_amt, x.gibr_branch_cd branch_cd, x.line_cd,
                x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL", 0 "UW",
                NVL (x.balance, 0) - 0 variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  14,
                                                                  NULL,
                                                                  'B',
                                                                  --use GL by Branch by MAC 01/06/2014
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x
         UNION
         --Item 15
         SELECT '' base_amt, x.gibr_branch_cd branch_cd, x.line_cd,
                x.gl_acct_name, x.gl_acct_no, NVL (x.balance, 0) "GL", 0 "UW",
                NVL (x.balance, 0) - 0 variances
           FROM (SELECT *
                   FROM TABLE
                             (giacs354_pkg.select_gl_branch_line (p_module,
                                                                  15,
                                                                  NULL,
                                                                  'B',
                                                                  --use GL by Branch by MAC 01/06/2014
                                                                  p_post_tran,
                                                                  p_from_date,
                                                                  p_to_date
                                                                 )
                             )) x;
   BEGIN
      BEGIN
         SELECT MAX (session_id)
           INTO v_session_id
           FROM gicl_res_brdrx_extr
          WHERE user_id = USER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      FOR i IN 1 .. 2
      LOOP
         IF i = 1
         THEN
            v_module := 'GIACS017';
         ELSIF i = 2
         THEN
            v_module := 'GIACS018';
         END IF;

         FOR rec IN claim_payt (v_session_id, v_module)
         LOOP
            v_giacr354_clm_payt.base_amt := rec.base_amt;
            v_giacr354_clm_payt.branch_cd := rec.branch_cd;
            v_giacr354_clm_payt.line_cd := rec.line_cd;
            v_giacr354_clm_payt.gl_acct_name := rec.gl_acct_name;
            v_giacr354_clm_payt.gl_acct_no := rec.gl_acct_no;
            v_giacr354_clm_payt.gl_amount := rec.gl;
            v_giacr354_clm_payt.brdrx_amount := rec.uw;
            v_giacr354_clm_payt.variances := rec.variances;
            PIPE ROW (v_giacr354_clm_payt);
         END LOOP;
      END LOOP;

      RETURN;
   END;

   FUNCTION giacr354_clm_payt_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_brdrx_dtl_type PIPELINED
   IS
      v_giacr354_lp_dtl   giacr354_brdrx_dtl_rec_type;
      v_session_id        NUMBER                      := 0;

      CURSOR loss_paid_di
      IS
         SELECT '1LOSSES PAID' base_amt, NVL (x.line_cd, y.line_cd) line_cd,
                NVL (x.claim_no, y.claim_no) claim_no,
                NVL (x.claim_id, y.claim_id) claim_id,
                NVL (x.item_no, y.item_no) item_no,
                NVL (x.peril_cd, y.peril_cd) peril_cd, x.losses_paid gl_amt,
                y.losses_paid brdrx_amt,
                NVL (x.losses_paid, 0) - NVL (y.losses_paid, 0) variances
           FROM (SELECT   line_cd, claim_no, claim_id, item_no, peril_cd,
                          SUM (losses_paid) losses_paid
                     FROM (SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) losses_paid
                               FROM giac_direct_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d
                              WHERE 1 = 1
                                AND b.tran_id = a.gacc_tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'L'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd
                           UNION
                           SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) * -1 losses_paid
                               FROM giac_direct_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d,
                                    giac_reversals e
                              WHERE 1 = 1
                                AND a.gacc_tran_id = e.gacc_tran_id
                                AND e.reversing_tran_id = b.tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'L'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd)
                 GROUP BY line_cd, claim_no, claim_id, item_no, peril_cd) x
                FULL OUTER JOIN
                (SELECT   line_cd, get_claim_number (claim_id) claim_no,
                          claim_id, item_no, peril_cd,
                          SUM (losses_paid) losses_paid
                     FROM gicl_res_brdrx_extr
                    WHERE user_id = USER
                      AND iss_cd != giacp.v ('RI_ISS_CD')
                      AND losses_paid != 0
                 GROUP BY line_cd, claim_id, item_no, peril_cd) y
                ON x.line_cd = y.line_cd
              AND x.claim_no = y.claim_no
              AND x.claim_id = y.claim_id
              AND x.item_no = y.item_no
              AND x.peril_cd = y.peril_cd
                ;

      CURSOR loss_paid_ri
      IS
         SELECT '2LOSSES PAID' base_amt, NVL (x.line_cd, y.line_cd) line_cd,
                NVL (x.claim_no, y.claim_no) claim_no,
                NVL (x.claim_id, y.claim_id) claim_id,
                NVL (x.item_no, y.item_no) item_no,
                NVL (x.peril_cd, y.peril_cd) peril_cd, x.losses_paid gl_amt,
                y.losses_paid brdrx_amt,
                NVL (x.losses_paid, 0) - NVL (y.losses_paid, 0) variances
           FROM (SELECT   line_cd, claim_no, claim_id, item_no, peril_cd,
                          SUM (losses_paid) losses_paid
                     FROM (SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) losses_paid
                               FROM giac_inw_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d
                              WHERE 1 = 1
                                AND b.tran_id = a.gacc_tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'L'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd
                           UNION
                           SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) * -1 losses_paid
                               FROM giac_inw_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d,
                                    giac_reversals e
                              WHERE 1 = 1
                                AND a.gacc_tran_id = e.gacc_tran_id
                                AND e.reversing_tran_id = b.tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'L'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd)
                 GROUP BY line_cd, claim_no, claim_id, item_no, peril_cd) x
                FULL OUTER JOIN
                (SELECT   line_cd, get_claim_number (claim_id) claim_no,
                          claim_id, item_no, peril_cd,
                          SUM (losses_paid) losses_paid
                     FROM gicl_res_brdrx_extr
                    WHERE user_id = USER
                      AND iss_cd = giacp.v ('RI_ISS_CD')
                      AND losses_paid != 0
                 GROUP BY line_cd, claim_id, item_no, peril_cd) y
                ON x.line_cd = y.line_cd
              AND x.claim_no = y.claim_no
              AND x.claim_id = y.claim_id
              AND x.item_no = y.item_no
              AND x.peril_cd = y.peril_cd
                ;

      CURSOR exp_paid_di
      IS
         SELECT '3EXPENSES PAID' base_amt, NVL (x.line_cd, y.line_cd) line_cd,
                NVL (x.claim_no, y.claim_no) claim_no,
                NVL (x.claim_id, y.claim_id) claim_id,
                NVL (x.item_no, y.item_no) item_no,
                NVL (x.peril_cd, y.peril_cd) peril_cd, x.losses_paid gl_amt,
                y.losses_paid brdrx_amt,
                NVL (x.losses_paid, 0) - NVL (y.losses_paid, 0) variances
           FROM (SELECT   line_cd, claim_no, claim_id, item_no, peril_cd,
                          SUM (losses_paid) losses_paid
                     FROM (SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) losses_paid
                               FROM giac_direct_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d
                              WHERE 1 = 1
                                AND b.tran_id = a.gacc_tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'E'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd
                           UNION
                           SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) * -1 losses_paid
                               FROM giac_direct_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d,
                                    giac_reversals e
                              WHERE 1 = 1
                                AND a.gacc_tran_id = e.gacc_tran_id
                                AND e.reversing_tran_id = b.tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'E'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd)
                 GROUP BY line_cd, claim_no, claim_id, item_no, peril_cd) x
                FULL OUTER JOIN
                (SELECT   line_cd, get_claim_number (claim_id) claim_no,
                          claim_id, item_no, peril_cd,
                          SUM (expenses_paid) losses_paid
                     FROM gicl_res_brdrx_extr
                    WHERE user_id = USER
                      AND iss_cd != giacp.v ('RI_ISS_CD')
                      AND expenses_paid != 0
                 GROUP BY line_cd, claim_id, item_no, peril_cd) y
                ON x.line_cd = y.line_cd
              AND x.claim_no = y.claim_no
              AND x.claim_id = y.claim_id
              AND x.item_no = y.item_no
              AND x.peril_cd = y.peril_cd
                ;

      CURSOR exp_paid_ri
      IS
         SELECT '4EXPENSES PAID' base_amt, NVL (x.line_cd, y.line_cd) line_cd,
                NVL (x.claim_no, y.claim_no) claim_no,
                NVL (x.claim_id, y.claim_id) claim_id,
                NVL (x.item_no, y.item_no) item_no,
                NVL (x.peril_cd, y.peril_cd) peril_cd, x.losses_paid gl_amt,
                y.losses_paid brdrx_amt,
                NVL (x.losses_paid, 0) - NVL (y.losses_paid, 0) variances
           FROM (SELECT   line_cd, claim_no, claim_id, item_no, peril_cd,
                          SUM (losses_paid) losses_paid
                     FROM (SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) losses_paid
                               FROM giac_inw_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d
                              WHERE 1 = 1
                                AND b.tran_id = a.gacc_tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'E'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd
                           UNION
                           SELECT   d.line_cd,
                                    get_claim_number (d.claim_id) claim_no,
                                    d.claim_id, c.item_no, c.peril_cd,
                                    SUM (disbursement_amt) * -1 losses_paid
                               FROM giac_inw_claim_payts a,
                                    giac_acctrans b,
                                    gicl_clm_res_hist c,
                                    gicl_claims d,
                                    giac_reversals e
                              WHERE 1 = 1
                                AND a.gacc_tran_id = e.gacc_tran_id
                                AND e.reversing_tran_id = b.tran_id
                                AND a.claim_id = c.claim_id
                                AND a.clm_loss_id = c.clm_loss_id
                                AND a.advice_id = c.advice_id
                                AND c.claim_id = d.claim_id
                                AND a.gacc_tran_id = c.tran_id
                                AND b.tran_flag != 'D'
                                AND a.payee_type = 'E'
                                AND DECODE (p_post_tran,
                                            'P', TRUNC (b.posting_date),
                                            TRUNC (b.tran_date)
                                           ) BETWEEN p_from_date AND p_to_date
                           GROUP BY d.line_cd,
                                    d.claim_id,
                                    c.item_no,
                                    c.peril_cd)
                 GROUP BY line_cd, claim_no, claim_id, item_no, peril_cd) x
                FULL OUTER JOIN
                (SELECT   line_cd, get_claim_number (claim_id) claim_no,
                          claim_id, item_no, peril_cd,
                          SUM (expenses_paid) losses_paid
                     FROM gicl_res_brdrx_extr
                    WHERE user_id = USER
                      AND iss_cd = giacp.v ('RI_ISS_CD')
                      AND expenses_paid != 0
                 GROUP BY line_cd, claim_id, item_no, peril_cd) y
                ON x.line_cd = y.line_cd
              AND x.claim_no = y.claim_no
              AND x.claim_id = y.claim_id
              AND x.item_no = y.item_no
              AND x.peril_cd = y.peril_cd
                ;
   BEGIN
      FOR rec IN loss_paid_di
      LOOP
         v_giacr354_lp_dtl.line_cd := rec.line_cd;
         v_giacr354_lp_dtl.claim_no := rec.claim_no;
         v_giacr354_lp_dtl.claim_id := rec.claim_id;
         v_giacr354_lp_dtl.item_no := rec.item_no;
         v_giacr354_lp_dtl.peril_cd := rec.peril_cd;
         v_giacr354_lp_dtl.base_amt := rec.base_amt;
         v_giacr354_lp_dtl.gl_amount := rec.gl_amt;
         v_giacr354_lp_dtl.brdrx_amount := rec.brdrx_amt;
         v_giacr354_lp_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_lp_dtl);
      END LOOP;

      FOR rec2 IN loss_paid_ri
      LOOP
         v_giacr354_lp_dtl.line_cd := rec2.line_cd;
         v_giacr354_lp_dtl.claim_no := rec2.claim_no;
         v_giacr354_lp_dtl.claim_id := rec2.claim_id;
         v_giacr354_lp_dtl.item_no := rec2.item_no;
         v_giacr354_lp_dtl.peril_cd := rec2.peril_cd;
         v_giacr354_lp_dtl.base_amt := rec2.base_amt;
         v_giacr354_lp_dtl.gl_amount := rec2.gl_amt;
         v_giacr354_lp_dtl.brdrx_amount := rec2.brdrx_amt;
         v_giacr354_lp_dtl.variances := rec2.variances;
         PIPE ROW (v_giacr354_lp_dtl);
      END LOOP;

      FOR rec IN exp_paid_di
      LOOP
         v_giacr354_lp_dtl.line_cd := rec.line_cd;
         v_giacr354_lp_dtl.claim_no := rec.claim_no;
         v_giacr354_lp_dtl.claim_id := rec.claim_id;
         v_giacr354_lp_dtl.item_no := rec.item_no;
         v_giacr354_lp_dtl.peril_cd := rec.peril_cd;
         v_giacr354_lp_dtl.base_amt := rec.base_amt;
         v_giacr354_lp_dtl.gl_amount := rec.gl_amt;
         v_giacr354_lp_dtl.brdrx_amount := rec.brdrx_amt;
         v_giacr354_lp_dtl.variances := rec.variances;
         PIPE ROW (v_giacr354_lp_dtl);
      END LOOP;

      FOR rec2 IN exp_paid_ri
      LOOP
         v_giacr354_lp_dtl.line_cd := rec2.line_cd;
         v_giacr354_lp_dtl.claim_no := rec2.claim_no;
         v_giacr354_lp_dtl.claim_id := rec2.claim_id;
         v_giacr354_lp_dtl.item_no := rec2.item_no;
         v_giacr354_lp_dtl.peril_cd := rec2.peril_cd;
         v_giacr354_lp_dtl.base_amt := rec2.base_amt;
         v_giacr354_lp_dtl.gl_amount := rec2.gl_amt;
         v_giacr354_lp_dtl.brdrx_amount := rec2.brdrx_amt;
         v_giacr354_lp_dtl.variances := rec2.variances;
         PIPE ROW (v_giacr354_lp_dtl);
      END LOOP;

      RETURN;
   END;

   --   FUNCTION giacr354_tb (p_mm NUMBER, p_year NUMBER)
--      RETURN giacr354_tb_reg_type PIPELINED
--   IS
--      v_tb_reg   giacr354_tb_reg_rec_type;
--   BEGIN
--      FOR rec IN
--         (SELECT   gl_acct_no_formatted gl_acct_no, gl_acct_name,
--                   SUM
--                      (CASE
--                          WHEN TYPE NOT IN ('CASH', 'DV', 'JV')
--                             THEN tb_debit_bal
--                          ELSE 0
--                       END
--                      ) AS tb_debit_bal,
--                   SUM
--                      (CASE
--                          WHEN TYPE NOT IN ('CASH', 'DV', 'JV')
--                             THEN tb_credit_bal
--                          ELSE 0
--                       END
--                      ) AS tb_credit_bal,
--                   SUM (DECODE (TYPE, 'CASH', tb_debit_bal, 0)
--                       ) AS cash_reg_debit_amt,
--                   SUM (DECODE (TYPE, 'CASH', tb_credit_bal, 0)
--                       ) AS cash_reg_credit_amt,
--                   SUM (DECODE (TYPE, 'DV', tb_debit_bal, 0)
--                       ) AS dv_reg_debit_amt,
--                   SUM (DECODE (TYPE, 'DV', tb_credit_bal, 0)
--                       ) AS dv_reg_credit_amt,
--                   SUM (DECODE (TYPE, 'JV', tb_debit_bal, 0)
--                       ) AS jv_reg_debit_amt,
--                   SUM (DECODE (TYPE, 'JV', tb_credit_bal, 0)
--                       ) AS jv_reg_credit_amt
--              FROM (
--                    --TB
--                    SELECT   gl_acct_no_formatted, gl_acct_name, 'TB' TYPE,
--                             SUM (trans_debit_bal) tb_debit_bal,
--                             SUM (trans_credit_bal) tb_credit_bal
--                        FROM giac_trial_balance_v
--                       WHERE tran_year = p_year
--                             AND tran_mm = LPAD (p_mm, 2, 0)
--                    GROUP BY gl_acct_no_formatted, gl_acct_name
--                    UNION ALL
--                    --CASH
--                    SELECT   gl_account, gl_account_name, 'CASH',
--                             SUM (debit_amt) cash_debit_amt,
--                             SUM (credit_amt) cash_credit_amt
--                        FROM TABLE
--                                (csv_acctg.cashreceiptsregister_d
--                                                (NULL,
--                                                 TO_DATE (p_mm || '-'
--                                                          || p_year,
--                                                          'MM-YYYY'
--                                                         ),
--                                                 LAST_DAY (TO_DATE (   p_mm
--                                                                    || '-'
--                                                                    || p_year,
--                                                                    'MM-YYYY'
--                                                                   )
--                                                          ),
--                                                 'P',
--                                                 NULL
--                                                )
--                                )
--                    GROUP BY gl_account, gl_account_name
--                    UNION ALL
--                    --DV
--                    SELECT   gl_account, gl_account_name, 'DV',
--                             SUM (debit_amt) dv_debit_amt,
--                             SUM (credit_amt) dv_credit_amt
--                        FROM TABLE
--                                (csv_acctg.cashdisbregister_d
--                                                (NULL,
--                                                 TO_DATE (p_mm || '-'
--                                                          || p_year,
--                                                          'MM-YYYY'
--                                                         ),
--                                                 LAST_DAY (TO_DATE (   p_mm
--                                                                    || '-'
--                                                                    || p_year,
--                                                                    'MM-YYYY'
--                                                                   )
--                                                          ),
--                                                 'P',
--                                                 'V',
--                                                 NULL
--                                                )
--                                )
--                    GROUP BY gl_account, gl_account_name
--                    UNION ALL
--                    --JV
--                    SELECT   gl_account, gl_account_name, 'JV',
--                             SUM (debit_amt) jv_debit_amt,
--                             SUM (credit_amt) jv_credit_amt
--                        FROM TABLE
--                                (csv_acctg.journalvoucherregister_d
--                                                (NULL,
--                                                 TO_DATE (p_mm || '-'
--                                                          || p_year,
--                                                          'MM-YYYY'
--                                                         ),
--                                                 LAST_DAY (TO_DATE (   p_mm
--                                                                    || '-'
--                                                                    || p_year,
--                                                                    'MM-YYYY'
--                                                                   )
--                                                          ),
--                                                 'P',
--                                                 NULL,
--                                                 NULL
--                                                )
--                                )
--                    GROUP BY gl_account, gl_account_name)
--          GROUP BY gl_acct_no_formatted, gl_acct_name
--          ORDER BY 1)
--      LOOP
--         v_tb_reg.gl_acct_no := rec.gl_acct_no;
--         v_tb_reg.gl_acct_name := rec.gl_acct_name;
--         v_tb_reg.cash_reg_dr := rec.cash_reg_debit_amt;
--         v_tb_reg.cash_reg_cr := rec.cash_reg_credit_amt;
--         v_tb_reg.disb_reg_dr := rec.dv_reg_debit_amt;
--         v_tb_reg.disb_reg_cr := rec.dv_reg_credit_amt;
--         v_tb_reg.jv_reg_dr := rec.jv_reg_debit_amt;
--         v_tb_reg.jv_reg_cr := rec.jv_reg_credit_amt;
--         v_tb_reg.tb_debit := rec.tb_debit_bal;
--         v_tb_reg.tb_credit := rec.tb_credit_bal;
--         v_tb_reg.variances :=
--              (NVL (rec.tb_debit_bal, 0) - NVL (rec.tb_credit_bal, 0)
--              )
--            - (  (  NVL (rec.cash_reg_debit_amt, 0)
--                  - NVL (rec.cash_reg_credit_amt, 0)
--                 )
--               + (  NVL (rec.dv_reg_debit_amt, 0)
--                  - NVL (rec.dv_reg_credit_amt, 0)
--                 )
--               + (  NVL (rec.jv_reg_debit_amt, 0)
--                  - NVL (rec.jv_reg_credit_amt, 0)
--                 )
--              );
--         PIPE ROW (v_tb_reg);
--      END LOOP;
--   END giacr354_tb;

   --   --mikel 02.11.2014
--   FUNCTION giacr354_evat (
--      p_post_tran   VARCHAR2,
--      p_from_date   DATE,
--      p_to_date     DATE
--   )
--      RETURN giacr354_tax_type PIPELINED
--   IS
--      v_giacr354_tax   giacr354_tax_rec_type;
--      v_module         VARCHAR2 (10)         := 'GIACS007';
--      v_item_no        NUMBER                := 6;

   --      --VALUE ADDED TAX (VAT) OUTPUT - DIRECT
--      CURSOR gl_evat
--      IS
--         SELECT NVL (y.ref_no, x.pyt_ref) ref_no, y.tran_id, y.balance,
--                x.evat, NVL (y.balance, 0) - NVL (x.evat, 0) variances
--           FROM (SELECT   pyt_ref, SUM (evat) evat
--                     FROM TABLE (csv_vat.csv_evat (NULL,
--                                                   NULL,
--                                                   p_post_tran,
--                                                   p_from_date,
--                                                   p_to_date
--                                                  )
--                                )
--                    WHERE dir_inw = 'DIRECT'
--                 GROUP BY pyt_ref
--                 UNION
--                 SELECT 'PPR', SUM (evat) evat
--                   FROM TABLE (csv_vat.csv_evat (NULL,
--                                                 NULL,
--                                                 p_post_tran,
--                                                 p_from_date,
--                                                 p_to_date
--                                                )
--                              )
--                  WHERE dir_inw = 'PPR') x
--                FULL OUTER JOIN
--                (SELECT   DECODE (b.tran_class,
--                                  'PPR', 'PPR',
--                                  get_ref_no (tran_id)
--                                 ) ref_no,
--                          tran_id, SUM (credit_amt - debit_amt) balance
--                     FROM giac_acct_entries a,
--                          giac_acctrans b,
--                          giac_chart_of_accts c,
--                          giac_module_entries d,
--                          giac_modules e
--                    WHERE 1 = 1
--                      AND gacc_tran_id = tran_id
--                      AND a.gl_acct_id = c.gl_acct_id
--                      AND d.module_id = e.module_id
--                      AND e.module_name = 'GIACS007'                --v_module
--                      AND d.item_no = 6                            --v_item_no
--                      AND a.gl_acct_category = d.gl_acct_category
--                      AND a.gl_control_acct = d.gl_control_acct
--                      AND a.gl_sub_acct_1 = d.gl_sub_acct_1
--                      AND a.gl_sub_acct_2 = d.gl_sub_acct_2
--                      AND a.gl_sub_acct_3 = d.gl_sub_acct_3
--                      AND a.gl_sub_acct_4 = d.gl_sub_acct_4
--                      AND a.gl_sub_acct_5 = d.gl_sub_acct_5
--                      AND a.gl_sub_acct_6 = d.gl_sub_acct_6
--                      AND a.gl_sub_acct_7 = d.gl_sub_acct_7
--                      AND DECODE (p_post_tran,
--                                  'T', TRUNC (b.tran_date),
--                                  TRUNC (b.posting_date)
--                                 ) BETWEEN p_from_date AND p_to_date
--                      AND NVL (a.generation_type, 'Y') != 'X'
--                 GROUP BY DECODE (b.tran_class,
--                                  'PPR', 'PPR',
--                                  get_ref_no (tran_id)
--                                 ),
--                          tran_id) y ON x.pyt_ref = y.ref_no
--                ;
--   --ORDER BY 1;
--   BEGIN
--      FOR rec IN gl_evat
--      LOOP
--         v_giacr354_tax.reference_no := rec.ref_no;
--         v_giacr354_tax.tran_id := rec.tran_id;
--         v_giacr354_tax.gl_amount := rec.balance;
--         v_giacr354_tax.tax_amount := rec.evat;
--         v_giacr354_tax.variances := rec.variances;
--         PIPE ROW (v_giacr354_tax);
--      END LOOP;

   --      RETURN;
--   END;

   --   FUNCTION get_tran_class_lov
--      RETURN tran_class_type PIPELINED
--   IS
--      v_tran_class   tran_class_rec_type;
--   BEGIN
--      FOR i IN
--         (SELECT rv_low_value, rv_meaning
--            FROM cg_ref_codes
--           WHERE rv_domain LIKE '%GIAC_ACCTRANS.TRAN_CLASS%'
--             AND rv_low_value IN ('PRD', 'INF', 'OF', 'UW', 'OL')
--          UNION
--          SELECT 'TB' rv_low_value,
--                 'Trial Balance vs Registers (Cash, Disbursement and JV)'
--                                                                   rv_meaning
--            FROM DUAL)
--      LOOP
--         v_tran_class.rv_low_value := i.rv_low_value;
--         v_tran_class.rv_meaning := i.rv_meaning;
--         PIPE ROW (v_tran_class);
--      END LOOP;
--   END get_tran_class_lov;

   --   FUNCTION validate_tran_date (
--      p_mm                 NUMBER,
--      p_yyyy               NUMBER,
--      p_tran_class         cg_ref_codes.rv_low_value%TYPE,
--      p_user_id            giis_users.user_id%TYPE,
--      p_message      OUT   VARCHAR2
--   )
--      RETURN BOOLEAN
--   AS
--      v_month   NUMBER (2);
--      v_year    NUMBER (4);
--   BEGIN
--      IF p_tran_class = 'PRD'
--      THEN
--         BEGIN
--            SELECT DISTINCT TO_CHAR (TO_DATE, 'MM') MONTH,
--                            TO_CHAR (TO_DATE, 'YYYY') YEAR
--                       INTO v_month,
--                            v_year
--                       FROM gipi_uwreports_ext
--                      WHERE user_id = p_user_id;

   --            IF p_mm <> v_month OR p_yyyy <> v_year
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Production Register (TAB 1) for specific date.';
--               RETURN TRUE;
--            ELSE
--               RETURN FALSE;
--            END IF;
--         EXCEPTION
--            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Production Register (TAB 1) for specific date.';
--               RETURN TRUE;
--         END;
--      ELSIF p_tran_class = 'INF'
--      THEN
--         BEGIN
--            SELECT DISTINCT TO_CHAR (TO_DATE, 'MM') MONTH,
--                            TO_CHAR (TO_DATE, 'YYYY') YEAR
--                       INTO v_month,
--                            v_year
--                       FROM gipi_uwreports_inw_ri_ext
--                      WHERE user_id = p_user_id;

   --            IF p_mm <> v_month OR p_yyyy <> v_year
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Inward Facultative (TAB 6) for specific date.';
--               RETURN TRUE;
--            ELSE
--               RETURN FALSE;
--            END IF;
--         EXCEPTION
--            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Inward Facultative (TAB 6) for specific date.';
--               RETURN TRUE;
--         END;
--      ELSIF p_tran_class = 'OF'
--      THEN
--         BEGIN
--            SELECT DISTINCT TO_CHAR (TO_DATE, 'MM') MONTH,
--                            TO_CHAR (TO_DATE, 'YYYY') YEAR
--                       INTO v_month,
--                            v_year
--                       FROM gipi_uwreports_ri_ext
--                      WHERE user_id = p_user_id;

   --            IF p_mm <> v_month OR p_yyyy <> v_year
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Outward Facultative (TAB 3) for specific date.';
--               RETURN TRUE;
--            ELSE
--               RETURN FALSE;
--            END IF;
--         EXCEPTION
--            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Outward Facultative (TAB 3) for specific date.';
--               RETURN TRUE;
--         END;
--      ELSIF p_tran_class = 'UW'
--      THEN
--         BEGIN
--            SELECT DISTINCT TO_CHAR (to_date1, 'MM') MONTH,
--                            TO_CHAR (to_date1, 'YYYY') YEAR
--                       INTO v_month,
--                            v_year
--                       FROM gipi_uwreports_dist_peril_ext
--                      WHERE user_id = p_user_id;

   --            IF p_mm <> v_month OR p_yyyy <> v_year
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Distribution Register (TAB 2) for specific date.';
--               RETURN TRUE;
--            ELSE
--               RETURN FALSE;
--            END IF;
--         EXCEPTION
--            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
--            THEN
--               p_message :=
--                  'Kindly extract UW report for Distribution Register (TAB 2) for specific date.';
--               RETURN TRUE;
--         END;
--      ELSIF p_tran_class = 'OL'
--      THEN
--         BEGIN
--            SELECT DISTINCT TO_CHAR (TO_DATE, 'MM') MONTH,
--                            TO_CHAR (TO_DATE, 'YYYY') YEAR
--                       INTO v_month,
--                            v_year
--                       FROM gicl_res_brdrx_extr
--                      WHERE user_id = p_user_id
--                        AND extr_type = 1
--                        AND brdrx_type = 1
--                        AND ol_date_opt = 3
--                        AND brdrx_rep_type = 3
--                     HAVING session_id = MAX (session_id)
--                   GROUP BY TO_DATE, session_id;

   --            IF p_mm <> v_month OR p_yyyy <> v_year
--            THEN
--               p_message :=
--                       'Kindly extract Outstanding Losses for specific date.';
--               RETURN TRUE;
--            ELSE
--               RETURN FALSE;
--            END IF;
--         EXCEPTION
--            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
--            THEN
--               p_message :=
--                       'Kindly extract Outstanding Losses for specific date.';
--               RETURN TRUE;
--         END;
--      END IF;

   --      RETURN FALSE;
--   END;

   --created function to check if GL of Treaty and XOL is the same by MAC 07/16/2013.
   FUNCTION is_gl_treaty_xol_same (
      p_module_id     VARCHAR2,
      p_treaty_item   NUMBER,
      p_xol_item      NUMBER
   )
      RETURN NUMBER
   AS
   BEGIN
      FOR i IN (SELECT COUNT (*) ctr
                  FROM giac_modules a, giac_module_entries b
                 WHERE a.module_id = b.module_id
                   AND a.module_name = p_module_id
                   AND b.item_no = p_treaty_item
                   AND NOT EXISTS (
                          SELECT 1
                            FROM giac_modules c, giac_module_entries d
                           WHERE b.gl_acct_category = d.gl_acct_category
                             AND b.gl_control_acct = d.gl_control_acct
                             AND b.gl_sub_acct_1 = d.gl_sub_acct_1
                             AND b.gl_sub_acct_2 = d.gl_sub_acct_2
                             AND b.gl_sub_acct_3 = d.gl_sub_acct_3
                             AND b.gl_sub_acct_4 = d.gl_sub_acct_4
                             AND b.gl_sub_acct_5 = d.gl_sub_acct_5
                             AND b.gl_sub_acct_6 = d.gl_sub_acct_6
                             AND b.gl_sub_acct_7 = d.gl_sub_acct_7
                             AND c.module_id = b.module_id
                             AND d.item_no = p_xol_item))
      LOOP
         --return 1 if GL of Treaty and XOL is the same otherwise return 0
         IF i.ctr = 0
         THEN
            RETURN (1);
         ELSE
            RETURN (0);
         END IF;
      END LOOP;

      RETURN (0);
   END;

   PROCEDURE extract_gross_prem (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_GROSS_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, gl_acct_name,
                           SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_prd (p_from_date,
                                                             p_to_date,
                                                             p_post_tran
                                                            )
                                 )
                  GROUP BY line_cd, gl_acct_name, base_amt)
      LOOP
         INSERT INTO giac_batch_check_gross_ext
                     (line_cd, prem_amt, gl_acct_sname,
                      balance, TO_DATE, from_date, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.uw_amount, ins.gl_acct_name,
                      ins.gl_amount, p_to_date, p_from_date, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      FOR ins IN (SELECT   base_amt, line_cd, gl_acct_name,
                           SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_inf (p_from_date,
                                                             p_to_date,
                                                             p_post_tran
                                                            )
                                 )
                  GROUP BY line_cd, gl_acct_name, base_amt)
      LOOP
         INSERT INTO giac_batch_check_gross_ext
                     (line_cd, prem_amt, gl_acct_sname,
                      balance, TO_DATE, from_date, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.uw_amount, ins.gl_acct_name,
                      ins.gl_amount, p_to_date, p_from_date, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_gross_prem_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_GROSS_DTL_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, policy_id, policy_no, pol_flag,
                           SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_prd_dtl (p_from_date,
                                                                 p_to_date,
                                                                 p_post_tran
                                                                )
                                 )
                  GROUP BY base_amt, line_cd, policy_id, policy_no, pol_flag)
      LOOP
         INSERT INTO giac_batch_check_gross_dtl_ext
                     (line_cd, policy_no, policy_id,
                      pol_flag, uw_amount, gl_amount, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.policy_no, ins.policy_id,
                      ins.pol_flag, ins.uw_amount, ins.gl_amount, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      FOR ins IN (SELECT   base_amt, line_cd, policy_id, policy_no, pol_flag,
                           SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_inf_dtl (p_from_date,
                                                                 p_to_date,
                                                                 p_post_tran
                                                                )
                                 )
                  GROUP BY base_amt, line_cd, policy_id, policy_no, pol_flag)
      LOOP
         INSERT INTO giac_batch_check_gross_dtl_ext
                     (line_cd, policy_no, policy_id,
                      pol_flag, uw_amount, gl_amount, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.policy_no, ins.policy_id,
                      ins.pol_flag, ins.uw_amount, ins.gl_amount, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_treaty_prem (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_TREATY_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, gl_acct_name, acct_trty_type,
                           SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_uw (p_from_date,
                                                            p_to_date,
                                                            p_post_tran
                                                           )
                                 )
                  GROUP BY line_cd, gl_acct_name, base_amt, acct_trty_type)
      LOOP
         INSERT INTO giac_batch_check_treaty_ext
                     (line_cd, prem_amt, gl_acct_sname,
                      balance, TO_DATE, from_date, user_id,
                      date_tag, base_amt, acct_trty_type
                     )
              VALUES (ins.line_cd, ins.uw_amount, ins.gl_acct_name,
                      ins.gl_amount, p_to_date, p_from_date, USER,
                      p_post_tran, ins.base_amt, ins.acct_trty_type
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_facul_prem (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_FACUL_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, gl_acct_name,
                           SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_of (p_from_date,
                                                            p_to_date,
                                                            p_post_tran
                                                           )
                                 )
                  GROUP BY line_cd, gl_acct_name, base_amt)
      LOOP
         INSERT INTO giac_batch_check_facul_ext
                     (line_cd, prem_amt, gl_acct_sname,
                      balance, TO_DATE, from_date, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.uw_amount, ins.gl_acct_name,
                      ins.gl_amount, p_to_date, p_from_date, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_facul_prem_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_FACUL_DTL_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, policy_id, policy_no,
                           binder_no, SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_of_dtl (p_from_date,
                                                                p_to_date,
                                                                p_post_tran
                                                               )
                                 )
                  GROUP BY line_cd, policy_id, policy_no, binder_no, base_amt)
      LOOP
         INSERT INTO giac_batch_check_facul_dtl_ext
                     (line_cd, policy_no, policy_id,
                      binder_no, uw_amount, gl_amount, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.policy_no, ins.policy_id,
                      ins.binder_no, ins.uw_amount, ins.gl_amount, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_treaty_prem_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_TRTY_DTL_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, policy_id, policy_no, dist_no,
                           acct_trty_type, SUM (gl_amount) gl_amount,
                           SUM (uw_amount) uw_amount
                      FROM TABLE (giacs354_pkg.giacr354_uw_dtl (p_from_date,
                                                                p_to_date,
                                                                p_post_tran
                                                               )
                                 )
                  GROUP BY line_cd,
                           policy_id,
                           policy_no,
                           dist_no,
                           base_amt,
                           acct_trty_type)
      LOOP
         INSERT INTO giac_batch_check_trty_dtl_ext
                     (line_cd, policy_no, policy_id,
                      dist_no, uw_amount, gl_amount, user_id,
                      date_tag, base_amt, acct_trty_type
                     )
              VALUES (ins.line_cd, ins.policy_no, ins.policy_id,
                      ins.dist_no, ins.uw_amount, ins.gl_amount, USER,
                      p_post_tran, ins.base_amt, ins.acct_trty_type
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_os_loss (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_OS_LOSS_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, gl_acct_name,
                           SUM (gl_amount) gl_amount,
                           SUM (brdrx_amount) brdrx_amount
                      FROM TABLE (giacs354_pkg.giacr354_ol (p_from_date,
                                                            p_to_date,
                                                            p_post_tran
                                                           )
                                 )
                  GROUP BY line_cd, gl_acct_name, base_amt)
      LOOP
         INSERT INTO giac_batch_check_os_loss_ext
                     (line_cd, brdrx_amt, gl_acct_sname,
                      balance, TO_DATE, from_date, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.brdrx_amount, ins.gl_acct_name,
                      ins.gl_amount, p_to_date, p_from_date, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_os_loss_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHK_OS_LOSS_DTL_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, claim_no, claim_id, item_no,
                           peril_cd, SUM (gl_amount) gl_amount,
                           SUM (brdrx_amount) brdrx_amount
                      FROM TABLE (giacs354_pkg.giacr354_ol_dtl (p_from_date,
                                                                p_to_date,
                                                                p_post_tran
                                                               )
                                 )
                  GROUP BY base_amt,
                           line_cd,
                           claim_no,
                           claim_id,
                           item_no,
                           peril_cd)
      LOOP
         INSERT INTO giac_batch_chk_os_loss_dtl_ext
                     (line_cd, claim_no, claim_id, item_no,
                      peril_cd, brdrx_amt, gl_amount, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.claim_no, ins.claim_id, ins.item_no,
                      ins.peril_cd, ins.brdrx_amount, ins.gl_amount, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_losses_paid (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHECK_LOSS_PD_EXT';

      FOR ins IN (SELECT   base_amt, line_cd, gl_acct_name,
                           SUM (gl_amount) gl_amount,
                           SUM (brdrx_amount) brdrx_amount
                      FROM TABLE (giacs354_pkg.giacr354_clm_payt (p_from_date,
                                                                  p_to_date,
                                                                  p_post_tran
                                                                 )
                                 )
                  GROUP BY line_cd, gl_acct_name, base_amt)
      LOOP
         INSERT INTO giac_batch_check_loss_pd_ext
                     (line_cd, brdrx_amt, gl_acct_sname,
                      balance, TO_DATE, from_date, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.brdrx_amount, ins.gl_acct_name,
                      ins.gl_amount, p_to_date, p_from_date, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_losses_paid_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
   AS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_BATCH_CHK_LOSS_PD_DTL_EXT';

      FOR ins IN
         (SELECT   base_amt, line_cd, claim_no, claim_id, item_no, peril_cd,
                   SUM (gl_amount) gl_amount, SUM (brdrx_amount)
                                                                brdrx_amount
              FROM TABLE (giacs354_pkg.giacr354_clm_payt_dtl (p_from_date,
                                                              p_to_date,
                                                              p_post_tran
                                                             )
                         )
          GROUP BY base_amt, line_cd, claim_no, claim_id, item_no, peril_cd)
      LOOP
         INSERT INTO giac_batch_chk_loss_pd_dtl_ext
                     (line_cd, claim_no, claim_id, item_no,
                      peril_cd, brdrx_amt, gl_amount, user_id,
                      date_tag, base_amt
                     )
              VALUES (ins.line_cd, ins.claim_no, ins.claim_id, ins.item_no,
                      ins.peril_cd, ins.brdrx_amount, ins.gl_amount, USER,
                      p_post_tran, ins.base_amt
                     );
      END LOOP;

      COMMIT;
   END;
END;
/


