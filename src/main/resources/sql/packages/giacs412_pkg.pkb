CREATE OR REPLACE PACKAGE BODY CPI.giacs412_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 08.02.2013
   **  Reference By : GIACS412- Update Cancelled Policy Accounts
   **  Description  :
   */
   FUNCTION get_cancelled_policies_records (
        p_user_id           giis_users.user_id%TYPE,
        p_policy_number     VARCHAR2,
        p_assd_name         giis_assured.ASSD_NAME%TYPE,
        p_incept_date       VARCHAR2,
        p_expiry_date       VARCHAR2,
        p_tsi_amt           gipi_polbasic.TSI_AMT%TYPE,
        p_prem_amt          gipi_polbasic.PREM_AMT%TYPE,
        p_order_by          VARCHAR2,
        p_asc_desc_flag     VARCHAR2,
        p_row_from          NUMBER,
        p_row_to            NUMBER     
    )  RETURN giac_cancelled_policies_tab PIPELINED
   IS
      v_rec             giac_cancelled_policies_type;
      v_reg_policy_sw   giac_parameters.param_value_v%TYPE;
      
      TYPE cur_type IS REF CURSOR;
      c                 cur_type;
      v_sql             VARCHAR2(32767);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_reg_policy_sw
           FROM giac_parameters
          WHERE param_name LIKE '%EXCLUDE_SPECIAL%';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_reg_policy_sw := 'N';
      END;
 /*Modified by pjsantos 10/14/2016,for optimization GENQA 5753*/  
      /*FOR i IN (SELECT   a.*,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number
                    FROM giac_cancelled_policies_v a
                   WHERE policy_id IN (
                            SELECT policy_id
                              FROM gipi_polbasic
                             WHERE reg_policy_sw =
                                      DECODE (v_reg_policy_sw,
                                              'Y', 'Y',
                                              reg_policy_sw
                                             ))
                     AND iss_cd =
                            DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                  iss_cd,
                                                                  'GIACS412',
                                                                  p_user_id
                                                                 ),
                                    1, iss_cd,
                                    NULL
                                   )
                ORDER BY line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no)
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.policy_number := i.policy_number;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.assd_name := i.assd_name;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.cancellation_tag := i.cancellation_tag;
         PIPE ROW (v_rec);
      END LOOP;*/
      
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.*  
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT  a.*,
                                            a.line_cd
                                         || ''-''
                                         || a.subline_cd
                                         || ''-''
                                         || a.iss_cd
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.renew_no, ''09'')) 
                                    FROM giac_cancelled_policies_v a --, gipi_polbasic b
                                   WHERE 1 = 1 ';
                                /*    AND a.policy_id = b.policy_id
                                   AND a.reg_policy_sw =  DECODE (:v_reg_policy_sw,''Y'', ''Y'', a.reg_policy_sw) ';
                                     
                                     AND policy_id IN (
                                            SELECT policy_id
                                              FROM gipi_polbasic
                                             WHERE reg_policy_sw =
                                                      DECODE (:v_reg_policy_sw,
                                                              ''Y'', ''Y'',
                                                              reg_policy_sw
                                                             ))
                                    AND ( (SELECT access_tag
                                             FROM giis_user_modules
                                            WHERE userid = :p_user_id
                                              AND module_id = ''GIACS412''
                                              AND tran_cd IN (SELECT b.tran_cd 
                                                                FROM giis_users aa, giis_user_iss_cd b, giis_modules_tran c
                                                               WHERE aa.user_id = b.userid
                                                                 AND aa.user_id = :p_user_id
                                                                 AND b.iss_cd = a.iss_cd
                                                                 AND b.tran_cd = c.tran_cd
                                                                 AND c.module_id = ''GIACS412'')) = 1
                                            OR 
                                            (SELECT access_tag
                                               FROM giis_user_grp_modules
                                              WHERE module_id = ''GIACS412''
                                                AND (user_grp, tran_cd) IN ( SELECT aa.user_grp, b.tran_cd
                                                                               FROM giis_users aa, giis_user_grp_dtl b, giis_modules_tran c
                                                                              WHERE aa.user_grp = b.user_grp
                                                                                AND aa.user_id = :p_user_id
                                                                                AND b.iss_cd = a.iss_cd
                                                                                AND b.tran_cd = c.tran_cd
                                                                                AND c.module_id = ''GIACS412'')) = 1) 
          
                                     AND UPPER((a.line_cd || ''-'' || a.subline_cd || ''-'' 
                                         || a.iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                         || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                         || ''-'' || LTRIM (TO_CHAR (a.renew_no, ''09'')))) LIKE UPPER(NVL(:p_policy_number,  (a.line_cd || ''-'' || a.subline_cd || ''-''
                                                                                                                         || a.iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                                                                                                         || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                                                                                                         || ''-'' || LTRIM (TO_CHAR (a.renew_no, ''09''))) ))
                                     AND UPPER(assd_name) LIKE UPPER(NVL(:p_assd_name, assd_name))
                                     AND TRUNC(incept_date) = TRUNC(NVL(TO_DATE(:p_incept_date, ''MM-DD-YYYY''), incept_date))
                                     AND TRUNC(expiry_date) = TRUNC(NVL(TO_DATE(:p_expiry_date, ''MM-DD-YYYY''), expiry_date))
                                     AND tsi_amt = NVL(:p_tsi_amt, tsi_amt)
                                     AND prem_amt = NVL(:p_prem_amt, prem_amt)';*/
         
        
        IF v_reg_policy_sw = 'Y'
          THEN  
           v_sql := v_sql || 'AND a.reg_policy_sw = ''Y'' '; 
        ELSE
           v_sql := v_sql || 'AND a.reg_policy_sw LIKE ''%'' ';
        END IF;
        
        v_sql := v_sql || ' AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''AC'', ''GIACS412'', :p_user_id  ))
                                WHERE branch_cd = a.iss_cd) ';
        IF p_policy_number IS NOT NULL 
          THEN
           v_sql := v_sql || 'AND UPPER (a.line_cd || ''-'' || a.subline_cd || ''-''
                                         || a.iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                         || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                         || ''-'' || LTRIM (TO_CHAR (a.renew_no, ''09''))) LIKE UPPER('||''''|| p_policy_number||''''|| ') ';
        END IF;
--        
        IF p_assd_name IS NOT NULL
         THEN
          v_sql := v_sql || ' AND UPPER(assd_name) LIKE UPPER('||''''|| REPLACE(p_assd_name,'''','''''')||'''' ||') ';
        END IF;
        
        IF p_incept_date IS NOT NULL
         THEN
          v_sql := v_sql || ' AND TRUNC(a.incept_date) = TRUNC(TO_DATE('||''''|| p_incept_date ||''''|| ', ''MM-DD-YYYY'')) ';
        END IF;
        
        IF p_expiry_date IS NOT NULL
         THEN
          v_sql := v_sql || ' AND TRUNC(a.expiry_date) = TRUNC(TO_DATE(' ||''''|| p_expiry_date ||''''|| ', ''MM-DD-YYYY'')) ';
        END IF;
        
        IF p_tsi_amt IS NOT NULL
         THEN
          v_sql := v_sql || ' AND a.tsi_amt = ' || p_tsi_amt|| ' ';
        END IF;
        
        IF p_prem_amt IS NOT NULL
         THEN
          v_sql := v_sql || '  AND a.prem_amt = ' || p_prem_amt|| ' ';
        END IF;
        
         
        IF p_order_by IS NOT NULL THEN
            IF p_order_by = 'policyNo' THEN
                v_sql := v_sql || ' ORDER BY  a.line_cd
                                         || ''-''
                                         || a.subline_cd
                                         || ''-''
                                         || a.iss_cd
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.renew_no, ''09'')) ';
            ELSIF p_order_by = 'assdName' THEN
                v_sql := v_sql || ' ORDER BY a.assd_name ';
            ELSIF p_order_by = 'inceptDate' THEN
                v_sql := v_sql || ' ORDER BY a.incept_date ';
            ELSIF p_order_by = 'expiryDate' THEN
                v_sql := v_sql || ' ORDER BY a.expiry_date ';
            ELSIF p_order_by = 'tsiAmt' THEN
                v_sql := v_sql || ' ORDER BY a.tsi_amt ';
            ELSIF p_order_by = 'premAmt' THEN
                v_sql := v_sql || ' ORDER BY a.prem_amt ';
            END IF;
                    
            IF p_asc_desc_flag IS NOT NULL THEN
                v_sql := v_sql || p_asc_desc_flag;
            ELSE  
                v_sql := v_sql || ' ASC '; 
            END IF;
        END IF;
                    
        v_sql := v_sql || '       ) innersql
                                ) outersql
                             ) mainsql
                        WHERE rownum_ BETWEEN '|| p_row_from ||' AND NVL(''' || p_row_to || ''', count_)';
                        
        OPEN c FOR v_sql USING p_user_id; --v_reg_policy_sw, p_user_id, p_user_id, p_policy_number, p_assd_name, p_incept_date, p_expiry_date, p_tsi_amt, p_prem_amt; modified by pjsantos 10/14/2016, GENQA 5753
        LOOP    
            FETCH c INTO 
                v_rec.count_,            
                v_rec.rownum_,
                v_rec.policy_id,
                v_rec.tsi_amt,
                v_rec.prem_amt,
                v_rec.line_cd,
                v_rec.subline_cd,
                v_rec.iss_cd,
                v_rec.issue_yy,
                v_rec.pol_seq_no,  
                v_rec.renew_no,
                v_rec.assd_name,
                v_rec.incept_date,
                v_rec.expiry_date,
                v_rec.reg_policy_sw,                
                v_rec.cancellation_tag,
                v_rec.policy_number;
          /*pjsantos end*/      
             
                    
            EXIT WHEN c%NOTFOUND;  
            PIPE ROW (v_rec);
        END LOOP;      
      
      CLOSE c;
   END;

   FUNCTION get_endorsement_records (
      p_user_id      giis_users.user_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN giac_endorsement_policies_tab PIPELINED
   IS
      v_rec       giac_endorsement_policies_type;
      v_tran_id   NUMBER;
   BEGIN
      FOR i IN (SELECT   a.*,
                            a.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_seq_no, '000009'))
                                                                 endt_number
                    FROM gipi_polbasic a
                   WHERE endt_seq_no <> 0
                     AND iss_cd =
                            DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                  iss_cd,
                                                                  'GIACS412',
                                                                  p_user_id
                                                                 ),
                                    1, iss_cd,
                                    NULL
                                   )
                     AND line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                ORDER BY endt_iss_cd, endt_yy, endt_seq_no)
      LOOP
         v_rec.endt_number := i.endt_number;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.eff_date := i.eff_date;
         v_rec.issue_date := i.issue_date;
         v_rec.endt_expiry_date := i.endt_expiry_date;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE process_payments (
      p_cancellation_tag            VARCHAR2,
      p_line_cd                     VARCHAR2,
      p_subline_cd                  VARCHAR2,
      p_iss_cd                      VARCHAR2,
      p_issue_yy                    VARCHAR2,
      p_pol_seq_no                  VARCHAR2,
      p_renew_no                    VARCHAR2,
      p_user_id                     giis_users.user_id%TYPE,
      p_tran_id            IN OUT   VARCHAR2
   )
   IS
      v_comm_total   NUMBER;
      v_cnt          NUMBER := 1;
      v_rec_num      NUMBER;
      v_tran_id      NUMBER;
   BEGIN
      giis_users_pkg.app_user := p_user_id;
      IF p_cancellation_tag = 'F'
      THEN                                            -- for flat cancellation
         /*BEGIN
         --CHECK IF COMM_AMT IS equal to 0, sum of comm amts for endts is equal to negative of policy comm amt
           SELECT SUM(NVL(a.commission_amt,0)-NVL(wholding_tax,0))
             INTO v_comm_total
           FROM GIPI_COMM_INVOICE A, GIPI_POLBASIC B
          WHERE a.policy_id = b.policy_id
              AND b.line_cd = v_line_cd
              AND b.subline_cd = v_subline_cd
            AND b.iss_cd = v_iss_cd
              AND issue_yy = v_issue_yy
              AND pol_seq_no = v_pol_seq_no
              AND renew_no = v_renew_no
              AND (endt_seq_no = 0 OR endt_type='A');
         EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
         END; ----CHECK IF COMM_AMT IS equal */ --mikel 02.22.2011; replaced by codes below

         /* added by mikel 02.22.2011
                      for flat and pro-rata cancellation
         */
         BEGIN
            --CHECK IF COMM_AMT IS equal to 0, sum of comm amts of child intm for endt is equal to negative of sum of outstanding comm amt of child intm from policy and other endts
            SELECT (  SUM (  NVL (inv.commission_amt, 0)
                           - NVL (inv.wholding_tax, 0)
                          )
                    - SUM (NVL (payt.comm_amt, 0) - NVL (payt.wtax_amt, 0))
                   )
              INTO v_comm_total
              FROM (SELECT c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy,
                           c.pol_seq_no, c.renew_no, a.intrmdry_intm_no,
                           a.iss_cd bill_iss_cd, a.prem_seq_no,
                           (  NVL (d.commission_amt, a.commission_amt)
                            * b.currency_rt
                           ) commission_amt,
                           (  NVL (d.wholding_tax, a.wholding_tax)
                            * b.currency_rt
                           ) wholding_tax,
                           a.parent_intm_no, b.currency_cd, b.currency_rt
                      FROM gipi_comm_invoice a,
                           gipi_invoice b,
                           gipi_polbasic c,
                           gipi_comm_inv_dtl d
                     WHERE 1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND b.policy_id = c.policy_id
                       AND c.pol_flag <> '5'
                       AND a.iss_cd = d.iss_cd(+)
                       AND a.prem_seq_no = d.prem_seq_no(+)
                       AND a.intrmdry_intm_no = d.intrmdry_intm_no(+)) inv,
                   (SELECT c.intm_no, c.iss_cd, c.prem_seq_no, c.comm_amt,
                           c.wtax_amt
                      FROM giac_comm_payts c, giac_acctrans d
                     WHERE 1 = 1
                       AND c.gacc_tran_id = d.tran_id
                       AND d.tran_flag <> 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.reversing_tran_id = y.tran_id
                                 AND x.gacc_tran_id = c.gacc_tran_id
                                 AND y.tran_flag <> 'D')) payt
             WHERE inv.line_cd = p_line_cd
               AND inv.subline_cd = p_subline_cd
               AND inv.iss_cd = p_iss_cd
               AND inv.issue_yy = p_issue_yy
               AND inv.pol_seq_no = p_pol_seq_no
               AND inv.renew_no = p_renew_no
               AND inv.intrmdry_intm_no = payt.intm_no(+)
               AND inv.bill_iss_cd = payt.iss_cd(+)
               AND inv.prem_seq_no = payt.prem_seq_no(+);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;                                   ----CHECK IF COMM_AMT IS equal

         -- end mikel 02.22.2011
         FOR a IN (SELECT policy_id
                     FROM gipi_polbasic
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND (endt_seq_no = 0 OR endt_type = 'A'))
         LOOP
            
            v_tran_id := p_tran_id;    
            IF p_tran_id IS NULL
            THEN
               SELECT acctran_tran_id_s.NEXTVAL
                 INTO v_tran_id
                 FROM SYS.DUAL;

               p_tran_id:= v_tran_id;
               giacs412_pkg.populate_giac_acctrans (v_tran_id, p_iss_cd);
            END IF;

            --apply premium collections
            giacs412_pkg.populate_giac_direct_prem (v_tran_id, a.policy_id);

            --apply commission payments
            IF (v_comm_total = 0 OR ABS (v_comm_total) = 0.01)
            THEN -- mikel 02.23.2012; to handle difference due to rounding-off
               giacs412_pkg.populate_giac_comm_payts (v_tran_id, a.policy_id);
            END IF;
          --apply tax collections
         -- populate_giac_tax_collns(v_tran_id, a.policy_id); /* mikel 02.23.2011; commeted out, no acctg entries will be generated for this transaction, */
         END LOOP;                                                --END LOOP A
      ELSIF p_cancellation_tag = 'E'
      THEN                                 -- for endt cancelling another endt
         BEGIN
            --CHECK IF COMM_AMT IS equal to 0, sum of comm amts for cancellation endt is equal to negative of comm amt of cancelled endt
            SELECT SUM (NVL (a.commission_amt, 0) - NVL (wholding_tax, 0))
              INTO v_comm_total
              FROM gipi_comm_invoice a, gipi_polbasic b
             WHERE a.policy_id = b.policy_id
               AND b.line_cd = p_line_cd
               AND b.subline_cd = p_subline_cd
               AND b.iss_cd = p_iss_cd
               AND b.issue_yy = p_issue_yy
               AND b.pol_seq_no = p_pol_seq_no
               AND b.renew_no = p_renew_no
               AND (   cancelled_endt_id IS NOT NULL
                    OR b.policy_id IN (
                          SELECT cancelled_endt_id
                            FROM gipi_polbasic c
                           WHERE c.line_cd = b.line_cd
                             AND c.subline_cd = b.subline_cd
                             AND c.iss_cd = b.iss_cd
                             AND c.issue_yy = b.issue_yy
                             AND c.pol_seq_no = b.pol_seq_no
                             AND c.renew_no = b.renew_no)
                   );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;                                     --CHECK IF COMM_AMT IS equal

         FOR a IN (SELECT policy_id
                     FROM gipi_polbasic b
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND (   cancelled_endt_id IS NOT NULL
                           OR b.policy_id IN (
                                 SELECT cancelled_endt_id
                                   FROM gipi_polbasic c
                                  WHERE c.line_cd = b.line_cd
                                    AND c.subline_cd = b.subline_cd
                                    AND c.iss_cd = b.iss_cd
                                    AND c.issue_yy = b.issue_yy
                                    AND c.pol_seq_no = b.pol_seq_no
                                    AND c.renew_no = b.renew_no)
                          ))
         LOOP
         
            v_tran_id := p_tran_id;
            IF p_tran_id IS NULL
            THEN
               SELECT acctran_tran_id_s.NEXTVAL
                 INTO v_tran_id
                 FROM SYS.DUAL;

               p_tran_id := v_tran_id;
               giacs412_pkg.populate_giac_acctrans (v_tran_id, p_iss_cd);
            END IF;

            --apply premium collections
            giacs412_pkg.populate_giac_direct_prem (v_tran_id, a.policy_id);

            --apply commission payments
            IF v_comm_total = 0
            THEN
               giacs412_pkg.populate_giac_comm_payts (v_tran_id, a.policy_id);
            END IF;
         --apply tax collections
         --populate_giac_tax_collns(v_tran_id, a.policy_id); /* mikel 02.23.2011; commeted out, no acctg entries will be generated for this transaction, */
         END LOOP;                                                --END LOOP A
      ELSIF p_cancellation_tag = 'O'
      THEN                      -- for endt cancelling the outstanding balance
         BEGIN
            --CHECK IF COMM_AMT IS equal to 0, sum of comm amts for endt is equal to negative of sum of outstanding comm amt from policy and other endts
                /* modified by mikel 02.23.2011
                            if the intm has a parent intm then
                            the basis for commputing the comm amt is the child intm's commission
                */
            SELECT (  SUM (  NVL (inv.commission_amt, 0)
                           - NVL (inv.wholding_tax, 0)
                          )
                    - SUM (NVL (payt.comm_amt, 0) - NVL (payt.wtax_amt, 0))
                   )
              INTO v_comm_total
              FROM (SELECT c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy,
                           c.pol_seq_no, c.renew_no, a.intrmdry_intm_no,
                           a.iss_cd bill_iss_cd, a.prem_seq_no,
                           
                           -- (a.commission_amt*b.currency_rt) commission_amt,
                                 -- (a.wholding_tax*b.currency_rt) wholding_tax,
                           (  NVL (d.commission_amt, a.commission_amt)
                            * b.currency_rt
                           ) commission_amt,                --mikel 02.23.2012
                           (  NVL (d.wholding_tax, a.wholding_tax)
                            * b.currency_rt
                           ) wholding_tax,                  --mikel 02.23.2012
                           a.parent_intm_no, b.currency_cd, b.currency_rt
                      FROM gipi_comm_invoice a,
                           gipi_invoice b,
                           gipi_polbasic c,
                           gipi_comm_inv_dtl d
                     /* mikel 02.23.2012; added gipi_comm_inv_dtl */
                    WHERE  1 = 1
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND b.policy_id = c.policy_id
                       AND c.pol_flag <> '5'  /*condition added by VJ 013009*/
                       AND a.iss_cd = d.iss_cd(+)       /* mikel 02.23.2012 */
                       AND a.prem_seq_no = d.prem_seq_no(+)
                       /* mikel 02.23.2012 */
                       AND a.intrmdry_intm_no = d.intrmdry_intm_no(+)) inv,
                   
                   /* mikel 02.23.2012 */
                   (SELECT c.intm_no, c.iss_cd, c.prem_seq_no, c.comm_amt,
                           c.wtax_amt
                      FROM giac_comm_payts c, giac_acctrans d
                     WHERE 1 = 1
                       AND c.gacc_tran_id = d.tran_id
                       AND d.tran_flag <> 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.reversing_tran_id = y.tran_id
                                 AND x.gacc_tran_id = c.gacc_tran_id
                                 AND y.tran_flag <> 'D')) payt
             WHERE inv.line_cd = p_line_cd
               AND inv.subline_cd = p_subline_cd
               AND inv.iss_cd = p_iss_cd
               AND inv.issue_yy = p_issue_yy
               AND inv.pol_seq_no = p_pol_seq_no
               AND inv.renew_no = p_renew_no
               AND inv.intrmdry_intm_no = payt.intm_no(+)
               AND inv.bill_iss_cd = payt.iss_cd(+)
               AND inv.prem_seq_no = payt.prem_seq_no(+);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;                                   ----CHECK IF COMM_AMT IS equal

         FOR a IN
            (SELECT DISTINCT b.policy_id
                        FROM gipi_comm_invoice a,
                             gipi_polbasic b,
                             giac_comm_payts e,
                             giac_acctrans f,
                             giac_aging_soa_details h
                       --sjm, 05162012, added giac_aging_soa_details for seici 9307
             WHERE           b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND a.policy_id(+) = b.policy_id
                         --added outer join to gipi_comm_invoice reymon 09032012
                         AND b.pol_flag <> '5'          /*added by VJ 013009*/
                         AND a.intrmdry_intm_no = e.intm_no(+)
                         AND a.iss_cd = e.iss_cd(+)
                         AND a.prem_seq_no = e.prem_seq_no(+)
                         AND b.cancelled_endt_id IS NULL
                         AND b.policy_id NOT IN (
                                SELECT c.cancelled_endt_id
                                  FROM gipi_polbasic c
                                 WHERE c.line_cd = b.line_cd
                                   AND c.subline_cd = b.subline_cd
                                   AND c.iss_cd = b.iss_cd
                                   AND c.issue_yy = b.issue_yy
                                   AND c.pol_seq_no = b.pol_seq_no
                                   AND c.renew_no = b.renew_no
                                   AND c.cancelled_endt_id IS NOT NULL)
                         /* added by judyann 03232009; to exclude endt cancellations */
                         AND EXISTS (
                                SELECT '1'
                                  FROM gipi_polbasic c,
                                       giac_aging_soa_details d
                                 WHERE c.policy_id = d.policy_id
                                   AND c.line_cd = b.line_cd
                                   AND c.subline_cd = b.subline_cd
                                   AND c.iss_cd = b.iss_cd
                                   AND c.issue_yy = b.issue_yy
                                   AND c.pol_seq_no = b.pol_seq_no
                                   AND c.renew_no = b.renew_no
                                HAVING SUM (balance_amt_due) = 0)
                         AND e.gacc_tran_id = f.tran_id(+)
                         AND f.tran_flag(+) <> 'D'
                         /* commented out by reymon 09032012
                         AND a.iss_cd = h.iss_cd  --added by sjm 05162012, for seici 9307
                         AND a.prem_seq_no = h.prem_seq_no  --added by sjm 05162012, for seici 9307
                         */
                         AND b.policy_id = h.policy_id
                         --added by reymon 09032012
                         AND h.balance_amt_due <> 0
                         --added by sjm 05162012, to exclude policies/endt without outstanding balance
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM giac_reversals x, giac_acctrans y
                                 WHERE x.reversing_tran_id = y.tran_id
                                   AND x.gacc_tran_id = e.gacc_tran_id
                                   AND y.tran_flag <> 'D'))
         LOOP
            
            v_tran_id := p_tran_id;
            IF p_tran_id IS NULL
            THEN
               SELECT acctran_tran_id_s.NEXTVAL
                 INTO v_tran_id
                 FROM SYS.DUAL;

               p_tran_id := v_tran_id;
               giacs412_pkg.populate_giac_acctrans (v_tran_id, p_iss_cd);
            END IF;

            --apply premium collections
            giacs412_pkg.populate_giac_direct_prem (v_tran_id, a.policy_id);

            --apply commission payments
            IF (v_comm_total = 0 OR ABS (v_comm_total) = 0.01)
            THEN -- judyann 01212009; to handle difference due to rounding-off
               giacs412_pkg.populate_giac_comm_payts (v_tran_id, a.policy_id);
            END IF;
           --apply tax collections
         --  populate_giac_tax_collns(v_tran_id, a.policy_id); /* mikel 02.23.2011; commeted out, no acctg entries will be generated for this transaction, */
         END LOOP;                                                --END LOOP A
      END IF;                               --end checking of cancellation tag
   END;

   PROCEDURE populate_giac_acctrans (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_branch_cd   gipi_polbasic.iss_cd%TYPE
   )
   IS
      v_fund_cd         giac_acctrans.gfun_fund_cd%TYPE;
      v_tran_year       giac_acctrans.tran_year%TYPE;
      v_tran_month      giac_acctrans.tran_month%TYPE;
      v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
      v_tran_class      giac_acctrans.tran_class%TYPE;
      v_tran_flag       giac_acctrans.tran_flag%TYPE;
      v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
      v_jv_no           giac_acctrans.jv_no%TYPE;
      v_jv_pref_suff    giac_acctrans.jv_pref_suff%TYPE;
      v_jv_id           giac_acctrans.jv_id%TYPE;
      v_particulars     giac_acctrans.particulars%TYPE;
   BEGIN
      v_fund_cd := giacp.v ('FUND_CD');
      v_tran_year := TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy'));
      v_tran_month := TO_NUMBER (TO_CHAR (SYSDATE, 'mm'));
      v_tran_class := 'CP';
      --Cancelled Policy
      v_tran_seq_no :=
         giac_sequence_generation (v_fund_cd,
                                   p_branch_cd,
                                   'ACCTRAN_TRAN_SEQ_NO',
                                   v_tran_year,
                                   v_tran_month
                                  );
      v_tran_flag := 'C';
      --Closed
      v_tran_class_no :=
         giac_sequence_generation (v_fund_cd,
                                   p_branch_cd,
                                   'CANCEL_POLICY',
                                   v_tran_year,
                                   0
                                  );
      --sequence no in a year, resets per year, not month
      v_jv_no := NULL;
      v_jv_pref_suff := NULL;
      v_jv_id := NULL;
      v_particulars :=
         'This is a system generated transaction to apply payments to cancelled policies and endorsements.';

      INSERT INTO giac_acctrans
                  (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                   tran_flag, tran_year, tran_month, tran_seq_no,
                   tran_class, tran_class_no, jv_no, jv_pref_suff,
                   jv_id, posting_date, particulars, user_id,
                   last_update, cpi_rec_no, cpi_branch_cd
                  )
           VALUES (p_tran_id, v_fund_cd, p_branch_cd, SYSDATE,
                   v_tran_flag, v_tran_year, v_tran_month, v_tran_seq_no,
                   v_tran_class, v_tran_class_no, v_jv_no, v_jv_pref_suff,
                   v_jv_id, NULL, v_particulars, giis_users_pkg.app_user,
                   SYSDATE, NULL, NULL
                  );
   END;

   PROCEDURE populate_giac_direct_prem (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
   IS
      v_transaction_type   giac_direct_prem_collns.transaction_type%TYPE;
      v_collection_amt     giac_direct_prem_collns.collection_amt%TYPE;
      v_or_print_tag       giac_direct_prem_collns.or_print_tag%TYPE;
      v_foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE;
      v_doc_no             giac_direct_prem_collns.doc_no%TYPE;
      v_colln_date         giac_direct_prem_collns.colln_dt%TYPE;
      v_acct_ent_date      giac_direct_prem_collns.acct_ent_date%TYPE;
      v_particulars        giac_direct_prem_collns.particulars%TYPE;
      v_paid_colln         giac_direct_prem_collns.collection_amt%TYPE;
   -- jhing 09/26/2011 will contain the total amount of paid amount
   BEGIN
/* modified by mikel; commented out some codes to correct the amounts in giac_aging_soa_details.
   updating of columns in giac_aging_soa_details was already done by UPDATE_AGING_SOA_TAUXD trigger, therefore no need to reupdate the table.
*/
      v_or_print_tag := NULL;
      v_foreign_curr_amt := NULL;
      v_doc_no := NULL;
      v_colln_date := NULL;
      v_acct_ent_date := NULL;
      v_particulars :=
         'This is a system generated transaction to apply payments to cancelled policies and endorsements.';
      -- jhing 09/28/2011 call populate_soa procedure to refresh the giac_aging_soa_details
      populate_soa (p_policy_id);

      --gets all invoices under the particular policy or endorsement
      FOR b IN (SELECT a.iss_cd, a.prem_seq_no, a.inst_no,
                       a.prem_balance_due, a.tax_balance_due, b.currency_cd,
                       b.currency_rt
                  FROM giac_aging_soa_details a, gipi_invoice b
                 WHERE 1 = 1
                   AND a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND b.policy_id = p_policy_id)
      LOOP
         IF b.prem_balance_due > 0
         THEN
            v_transaction_type := 1;
         ELSE
            v_transaction_type := 3;
         END IF;

         v_collection_amt :=
                       NVL (b.prem_balance_due, 0)
                       + NVL (b.tax_balance_due, 0);
         v_foreign_curr_amt := v_collection_amt / b.currency_rt;

          -- jhing 09/26/2011 added this code to retrieve payments for bill and to ensure that total_payments stored in the giac_aging_soa_details corresponds to the total payments for the bill and not just the total amount to be paid for partially paid invoices whose outstanding balance is the one paid by the CP.
          /* SELECT SUM(NVL(y.tax_amt,0)) + SUM(NVL(y.premium_amt, 0)) coll_amt
                    into v_paid_colln
                    FROM   GIAC_DIRECT_PREM_COLLNS  y,
                           GIAC_ACCTRANS    x
                  WHERE  y.gacc_tran_id = x.tran_id
                  AND    y.b140_iss_cd = b.iss_cd
                  AND    y.b140_prem_Seq_no = b.prem_Seq_no
                  AND    y.inst_no = b.inst_no
                  AND    x.tran_flag != 'D'
                  AND    x.tran_id NOT IN (SELECT aa.gacc_tran_id
                                           FROM GIAC_REVERSALS aa,
                                                GIAC_ACCTRANS  bb
                                           WHERE aa.reversing_tran_id = bb.tran_id
                                           AND bb.tran_flag != 'D');

          v_collection_amt :=  v_collection_amt + nvl(v_paid_colln, 0 ) ;
          -- end jhing 09/26/2011
         */ --commented out by mikel 02.24.2012;
         INSERT INTO giac_direct_prem_collns
                     (gacc_tran_id, transaction_type, b140_iss_cd,
                      b140_prem_seq_no, collection_amt,
                      premium_amt,
                      tax_amt, inst_no, or_print_tag,
                      particulars, currency_cd, convert_rate,
                      foreign_curr_amt, doc_no, colln_dt,
                      acct_ent_date, user_id, last_update,
                      cpi_rec_no, cpi_branch_cd
                     )
              VALUES (p_tran_id, v_transaction_type, b.iss_cd,
                      b.prem_seq_no, v_collection_amt,
                      NVL (b.prem_balance_due, 0),
                      NVL (b.tax_balance_due, 0), b.inst_no, v_or_print_tag,
                      v_particulars, b.currency_cd, b.currency_rt,
                      v_foreign_curr_amt, v_doc_no, v_colln_date,
                      v_acct_ent_date, giis_users_pkg.app_user, SYSDATE,
                      NULL, NULL
                     );
       /*UPDATE   giac_aging_soa_details
                SET   prem_balance_due = 0
                ,tax_balance_due  = 0
                ,total_payments   = v_collection_amt
                ,balance_amt_due  = 0
            WHERE iss_cd      = b.iss_cd
                AND prem_seq_no = b.prem_seq_no
                AND inst_no     = b.inst_no;
      */ -- commented out by mikel 02.24.2012;
      END LOOP;                                                   --end loop b
   END;

   PROCEDURE populate_giac_comm_payts (
      p_tran_id     giac_acctrans.tran_id%TYPE,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
   IS
      v_transaction_type   giac_comm_payts.tran_type%TYPE;
      v_input_vat_amt      giac_comm_payts.input_vat_amt%TYPE;
      v_particulars        giac_comm_payts.particulars%TYPE;
      v_foreign_curr_amt   giac_comm_payts.foreign_curr_amt%TYPE;
      v_def_comm_tag       giac_comm_payts.def_comm_tag%TYPE;
      v_inst_no            giac_comm_payts.inst_no%TYPE;
      v_print_tag          giac_comm_payts.print_tag%TYPE;
      v_or_print_tag       giac_comm_payts.or_print_tag%TYPE;
      v_acct_tag           giac_comm_payts.acct_tag%TYPE;
      v_sp_acctg           giac_comm_payts.sp_acctg%TYPE;
      v_parent_intm_no     giac_comm_payts.parent_intm_no%TYPE;
      v_cnt                NUMBER (3)                              := 1;
   BEGIN
      v_transaction_type := NULL;
      --v_input_vat_amt    := null; -- U mikel 01.21.2011 comment out
      v_foreign_curr_amt := NULL;
      v_def_comm_tag := NULL;
      v_inst_no := NULL;
      v_print_tag := NULL;
      v_or_print_tag := NULL;
      v_acct_tag := NULL;
      v_sp_acctg := 'N';
      v_particulars :=
         'This is a system generated transaction to apply payments to cancelled policies and endorsements.';

      --get all records in gipi_comm_invoice under the policy
      /*
      FOR c IN (SELECT a.intrmdry_intm_no,   a.iss_cd,   a.prem_seq_no,
                         a.commission_amt,   a.wholding_tax, a.parent_intm_no,
                         b.currency_cd,   b.currency_rt
                 FROM gipi_comm_invoice a, gipi_invoice b
                  WHERE 1=1
                    AND a.iss_cd = b.iss_cd
                    AND a.prem_seq_no = b.prem_seq_no
                   AND a.policy_id = v_policy_id) */

      --modified by judyann 01232009
       /* modified by mikel 02.23.2011
           if the intm has a parent intm then
        the basis for commputing the comm amt is the child intm's commission
      */
      FOR c IN
         (SELECT DISTINCT inv.intrmdry_intm_no, inv.iss_cd, inv.prem_seq_no,
                          (inv.commission_amt - NVL (payt.comm_amt, 0)
                          ) commission_amt,
                          (inv.wholding_tax - NVL (payt.wtax_amt, 0)
                          ) wholding_tax,
                          inv.parent_intm_no, inv.currency_cd,
                          inv.currency_rt, inv.input_vat_rate,
                          
                          -- added by U mikel 01.21.2011

                          --ROUND(inv.commission_amt,2)commission_amount -- added by U mikel 01.21.2011
                          ROUND (inv.commission_amt - NVL (payt.comm_amt, 0),
                                 2
                                ) commission_amount       --mikel 02.23.2012;
                     FROM (SELECT a.policy_id, a.intrmdry_intm_no, a.iss_cd,
                                  a.prem_seq_no,
                                  
                                  --(a.commission_amt*b.currency_rt) commission_amt,
                                     --(a.wholding_tax*b.currency_rt) wholding_tax,
                                  (  NVL (d.commission_amt, a.commission_amt)
                                   * b.currency_rt
                                  ) commission_amt,         --mikel 02.23.2012
                                  (  NVL (d.wholding_tax, a.wholding_tax)
                                   * b.currency_rt
                                  ) wholding_tax,           --mikel 02.23.2012
                                  a.parent_intm_no, b.currency_cd,
                                  b.currency_rt, e.input_vat_rate
                             FROM gipi_comm_invoice a,
                                  gipi_invoice b,
                                  giis_intermediary e,
                                  gipi_comm_inv_dtl d
                            --mikel 02.23.2012; added gipi_comm_inv_dtl
                           WHERE  1 = 1
                              AND a.iss_cd = b.iss_cd
                              AND a.intrmdry_intm_no = e.intm_no
                              AND a.prem_seq_no = b.prem_seq_no
                              AND a.intrmdry_intm_no = d.intrmdry_intm_no(+)
                              --mikel 02.23.2012
                              AND a.iss_cd = d.iss_cd(+)    --mikel 02.23.2012
                              AND a.prem_seq_no = d.prem_seq_no(+)) inv,
                          
                          --mikel 02.23.2012
                          (SELECT c.intm_no, c.iss_cd, c.prem_seq_no,
                                  SUM(c.comm_amt) comm_amt, SUM(c.wtax_amt) wtax_amt -- SR-4266 : shan 07.23.2015
                             FROM giac_comm_payts c, giac_acctrans d
                            WHERE 1 = 1
                              AND c.gacc_tran_id = d.tran_id
                              AND d.tran_flag <> 'D'
                              AND NOT EXISTS (
                                     SELECT '1'
                                       FROM giac_reversals x, giac_acctrans y
                                      WHERE x.reversing_tran_id = y.tran_id
                                        AND x.gacc_tran_id = c.gacc_tran_id
                                        AND y.tran_flag <> 'D')
                            GROUP BY c.intm_no, c.iss_cd, c.prem_seq_no) payt -- SR-4266 : shan 07.23.2015
                    WHERE inv.intrmdry_intm_no = payt.intm_no(+)
                      AND inv.iss_cd = payt.iss_cd(+)
                      AND inv.prem_seq_no = payt.prem_seq_no(+)
                      AND inv.policy_id = p_policy_id)
      LOOP
         IF c.commission_amt > 0
         THEN
            v_transaction_type := 1;
         ELSE
            v_transaction_type := 3;
         END IF;

         v_foreign_curr_amt := c.commission_amt / c.currency_rt;
         v_input_vat_amt := c.commission_amount * c.input_vat_rate / 100;
                       -- added by U mikel 01.21.2011 to compute for input vat
         /*PAU 03FEB09 CHECKING ORA-000001 OUTPUT TO C:\GIACS412B.TXT
         declare
            v_temp varchar2(500);
            in_file   Text_IO.File_Type;
         begin
            v_temp := v_cnt || ', ' || v_tran_id || ', ' || c.intrmdry_intm_no || ', ' || c.iss_cd || ', ' ||
                           c.prem_seq_no || ', ' || v_transaction_type || ', ' || c.commission_amt || ', ' ||
                        c.wholding_tax || ', ' || nvl(v_input_vat_amt,0) || ', ' || user || ', ' ||
                           SYSDATE || ', ' ||            v_particulars || ', ' || c.currency_cd || ', ' ||
                           c.currency_rt || ', ' || v_foreign_curr_amt || ', ' || v_def_comm_tag || ', ' ||
                           v_inst_no || ', ' || v_print_tag || ', ' || v_or_print_tag || ', ' ||
                           null || ', ' || null || ', ' || v_acct_tag || ', ' ||
                           NVL(c.parent_intm_no, c.intrmdry_intm_no) || ', ' || v_sp_acctg;
            in_file := text_io.fopen('c:\giacs412B.txt', 'A');
            text_io.put_line(in_file, v_temp);
            text_io.fclose(in_file);
         end;
         */
         v_cnt := v_cnt + 1;

         INSERT INTO giac_comm_payts
                     (gacc_tran_id, intm_no, iss_cd, prem_seq_no,
                      tran_type, comm_amt, wtax_amt,
                      input_vat_amt, user_id,
                      last_update, particulars, currency_cd, convert_rate,
                      foreign_curr_amt, def_comm_tag, inst_no,
                      print_tag, or_print_tag, cpi_rec_no, cpi_branch_cd,
                      acct_tag, parent_intm_no,
                      sp_acctg, comm_tag, record_no, record_seq_no      --added record_seq_no by albert 12.10.2015 (GENQA SR 5173)
                     )
              VALUES (p_tran_id, c.intrmdry_intm_no, c.iss_cd, c.prem_seq_no,
                      v_transaction_type, c.commission_amt, c.wholding_tax,
                      NVL (v_input_vat_amt, 0), giis_users_pkg.app_user,
                      SYSDATE, v_particulars, c.currency_cd, c.currency_rt,
                      v_foreign_curr_amt, v_def_comm_tag, v_inst_no,
                      v_print_tag, v_or_print_tag, NULL, NULL,
                      v_acct_tag, NVL (c.parent_intm_no, c.intrmdry_intm_no),
                      v_sp_acctg, 'N', 0, 1                             --added value of record_seq_no by albert 12.10.2015 (GENQA SR 5173)
                     );
      END LOOP;                                                   --END C LOOP
   END;
   
   -- ================================================
   -- for enhancement : shan 04.15.2015
   
    FUNCTION get_policies_for_reverse (
        p_user_id       giis_users.user_id%TYPE,
        p_policy_number     VARCHAR2,
        p_assd_name         giis_assured.ASSD_NAME%TYPE,
        p_incept_date       VARCHAR2,
        p_expiry_date       VARCHAR2,
        p_tsi_amt           gipi_polbasic.TSI_AMT%TYPE,
        p_prem_amt          gipi_polbasic.PREM_AMT%TYPE,
        p_order_by          VARCHAR2,
        p_asc_desc_flag     VARCHAR2,
        p_row_from          NUMBER,
        p_row_to            NUMBER     
    ) RETURN policies_for_reverse_tab PIPELINED
    AS
        v_rec       policies_for_reverse_type;
        
        TYPE cur_type IS REF CURSOR;
        c           cur_type;
        v_sql       VARCHAR2(32767);
    BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.policy_id, a.tsi_amt, a.prem_amt, 
                                           a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                                           a.incept_date, a.expiry_date, a.assd_no,
                                            a.line_cd
                                         || ''-''
                                         || a.subline_cd
                                         || ''-''
                                         || a.iss_cd
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                         || ''-''
                                         || LTRIM (TO_CHAR (a.renew_no, ''09'')) policy_number
                                      FROM gipi_polbasic a,
                                           gipi_invoice b,
                                           giac_aging_soa_details c     -- SR-4266 : shan 07.23.2015
                                     WHERE a.policy_id = b.policy_id 
                                       AND a.endt_seq_no = 0
                                       AND b.ISS_CD = c.iss_cd       -- SR-4266 : shan 07.23.2015
                                       AND b.prem_seq_no = c.prem_seq_no
                                       AND c.balance_amt_due = 0
                                       AND (b.iss_cd, b.prem_seq_no) IN (SELECT b140_iss_cd, b140_prem_seq_no
                                                                          FROM giac_direct_prem_collns x,
                                                                               giac_acctrans y
                                                                         WHERE x.gacc_tran_id = y.tran_id 
                                                                           AND y.TRAN_CLASS = ''CP''
                                                                           AND y.TRAN_FLAG IN (''C'', ''P'')
                                                                           /*AND NOT EXISTS(SELECT ''x''         -- SR-4266 : shan 07.23.2015
                                                                                            FROM giac_reversals cc, giac_acctrans dd 
                                                                                           WHERE cc.reversing_tran_id = dd.tran_id 
                                                                                             AND dd.tran_flag <> ''D'' 
                                                                                             AND cc.gacc_tran_id = y.tran_id)*/) ';
        /*Modified by pjsantos 10/14/2016,for optimization GENQA 5753*/            
                            /* AND ( ( SELECT access_tag
                                                 FROM giis_user_modules
                                                WHERE userid = :p_user_id
                                                  AND module_id = ''GIACS412''
                                                  AND tran_cd IN (SELECT b.tran_cd 
                                                                    FROM giis_users aa, giis_user_iss_cd b, giis_modules_tran c
                                                                   WHERE aa.user_id = b.userid
                                                                     AND aa.user_id = :p_user_id
                                                                     AND b.iss_cd = a.iss_cd
                                                                     AND b.tran_cd = c.tran_cd
                                                                     AND c.module_id = ''GIACS412'')) = 1
                                                OR 
                                                (SELECT access_tag
                                                   FROM giis_user_grp_modules
                                                  WHERE module_id = ''GIACS412''
                                                    AND (user_grp, tran_cd) IN ( SELECT aa.user_grp, b.tran_cd
                                                                                   FROM giis_users aa, giis_user_grp_dtl b, giis_modules_tran c
                                                                                  WHERE aa.user_grp = b.user_grp
                                                                                    AND aa.user_id = :p_user_id
                                                                                    AND b.iss_cd = a.iss_cd
                                                                                    AND b.tran_cd = c.tran_cd
                                                                                    AND c.module_id = ''GIACS412'')) = 1)
                                       AND UPPER((a.line_cd || ''-'' || a.subline_cd || ''-''
                                             || a.iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                             || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                             || ''-'' || LTRIM (TO_CHAR (a.renew_no, ''09'')))) LIKE UPPER(NVL(:p_policy_number,  (a.line_cd || ''-'' || a.subline_cd || ''-''
                                                                                                                             || a.iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                                                                                                             || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                                                                                                             || ''-'' || LTRIM (TO_CHAR (a.renew_no, ''09''))) ))
                                        AND TRUNC(a.incept_date) = TRUNC(NVL(TO_DATE(:p_incept_date, ''MM-DD-YYYY''), a.incept_date))
                                        AND TRUNC(a.expiry_date) = TRUNC(NVL(TO_DATE(:p_expiry_date, ''MM-DD-YYYY''), a.expiry_date))
                                        AND a.tsi_amt = NVL(:p_tsi_amt, a.tsi_amt)
                                        AND a.prem_amt = NVL(:p_prem_amt, a.prem_amt)
                                        AND a.assd_no IN (SELECT assd_no
                                                            FROM giis_assured 
                                                           WHERE UPPER(assd_name) LIKE UPPER(NVL(:p_assd_name, assd_name)))';*/
                                        
         
        v_sql := v_sql || 'AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''AC'', ''GIACS412'', :p_user_id  ))
                                WHERE branch_cd = a.iss_cd) ';
        IF p_policy_number IS NOT NULL 
          THEN
           v_sql := v_sql || 'AND UPPER (a.line_cd || ''-'' || a.subline_cd || ''-''
                                         || a.iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                         || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                                         || ''-'' || LTRIM (TO_CHAR (a.renew_no, ''09''))) LIKE UPPER('||''''|| p_policy_number||''''|| ') ';
        END IF;
--        
        IF p_assd_name IS NOT NULL
         THEN
          v_sql := v_sql || ' AND a.assd_no IN (SELECT assd_no
                                                            FROM giis_assured 
                                                           WHERE UPPER(assd_name) LIKE UPPER(NVL('||''''||REPLACE(p_assd_name, '''','''''')||''''||', assd_name))) ';
        END IF;
        
        IF p_incept_date IS NOT NULL
         THEN
          v_sql := v_sql || ' AND TRUNC(a.incept_date) = TRUNC(TO_DATE('||''''|| p_incept_date||'''' || ', ''MM-DD-YYYY'')) ';
        END IF;
        
        IF p_expiry_date IS NOT NULL
         THEN
          v_sql := v_sql || ' AND TRUNC(a.expiry_date) = TRUNC(TO_DATE(' ||''''|| p_expiry_date ||''''|| ', ''MM-DD-YYYY'')) ';
        END IF;
        
        IF p_tsi_amt IS NOT NULL 
         THEN
          v_sql := v_sql || ' AND a.tsi_amt = ' || p_tsi_amt|| ' ';
        END IF;
        
        IF p_prem_amt IS NOT NULL
         THEN
          v_sql := v_sql || '  AND a.prem_amt = ' || p_prem_amt|| ' ';
        END IF;
        /*pjsantos end*/
        
        IF p_order_by IS NOT NULL AND p_order_by != 'assdName' THEN
            IF p_order_by = 'policyNo' THEN
                v_sql := v_sql || ' ORDER BY policy_number ';
            ELSIF p_order_by = 'inceptDate' THEN
                v_sql := v_sql || ' ORDER BY incept_date ';
            ELSIF p_order_by = 'expiryDate' THEN
                v_sql := v_sql || ' ORDER BY expiry_date ';
            ELSIF p_order_by = 'tsiAmt' THEN
                v_sql := v_sql || ' ORDER BY tsi_amt ';
            ELSIF p_order_by = 'premAmt' THEN
                v_sql := v_sql || ' ORDER BY prem_amt ';
            END IF;
                    
            IF p_asc_desc_flag IS NOT NULL THEN
                v_sql := v_sql || p_asc_desc_flag;
            ELSE 
                v_sql := v_sql || ' ASC ';
            END IF;
        END IF;
                    
        v_sql := v_sql || '       )innersql
                                ) outersql
                             ) mainsql
                        WHERE rownum_ BETWEEN NVL('|| p_row_from ||', 1) AND NVL(''' || p_row_to || ''', count_)';
                                                                
        OPEN c FOR v_sql USING p_user_id;--, p_user_id, p_user_id, p_policy_number, p_incept_date, p_expiry_date, p_tsi_amt, p_prem_amt, p_assd_name; comment out by pjsantos for optimization, 10/25/2016, genqa 5753
        LOOP    
            FETCH c INTO
                v_rec.count_,            
                v_rec.rownum_,
                v_rec.policy_id,
                v_rec.tsi_amt,
                v_rec.prem_amt,
                v_rec.line_cd,
                v_rec.subline_cd,
                v_rec.iss_cd,
                v_rec.issue_yy,
                v_rec.pol_seq_no,
                v_rec.renew_no,
                v_rec.incept_date,
                v_rec.expiry_date,
                v_rec.assd_no,
                v_rec.policy_number;
                
                v_rec.assd_name := NULL;
            
                BEGIN
                    SELECT assd_name
                      INTO v_rec.assd_name
                      FROM giis_assured
                     WHERE assd_no = v_rec.assd_no;
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN                    
                        v_rec.assd_name := NULL;
                END;
                    
            EXIT WHEN c%NOTFOUND;  
            PIPE ROW (v_rec);
        END LOOP;      
      
        CLOSE c;
    END get_policies_for_reverse;
    
    
    PROCEDURE reverse_processed_pol(
        p_line_cd           VARCHAR2,
        p_subline_cd        VARCHAR2,
        p_iss_cd            VARCHAR2,
        p_issue_yy          VARCHAR2,
        p_pol_seq_no        VARCHAR2,
        p_renew_no          VARCHAR2,
        p_user_id           VARCHAR2
    )
    AS
        v_rec_tran_flag     GIAC_ACCTRANS.TRAN_FLAG%TYPE;
        v_rec_posting_date  GIAC_ACCTRANS.POSTING_DATE%TYPE;
        v_rec_tran_id       GIAC_ACCTRANS.TRAN_ID%TYPE;
        v_rec_iss_cd        GIPI_INVOICE.iss_cd%TYPE;
        v_rec_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE;
        
        v_gacc_tran_id      giac_acctrans.tran_id%TYPE;
        v_fund_cd           GIAC_PARAMETERS.param_name%TYPE;
        v_branch_cd         GIPI_POLBASIC.ISS_CD%TYPE;
        v_tran_flag         giac_acctrans.tran_flag%TYPE;
        v_tran_year         giac_acctrans.tran_year%TYPE;
        v_tran_month        giac_acctrans.tran_month%TYPE;
        v_tran_seq_no       giac_acctrans.tran_seq_no%TYPE;
        v_tran_class        giac_acctrans.tran_class%TYPE;
        v_tran_class_no     giac_acctrans.tran_class_no%TYPE;
        v_jv_no             giac_acctrans.jv_no%TYPE;
        v_jv_pref_suff      giac_acctrans.jv_pref_suff%TYPE;
        v_jv_id             giac_acctrans.jv_id%TYPE;
        v_particulars       giac_acctrans.particulars%TYPE;
        v_tran_type         giac_direct_prem_collns.TRANSACTION_TYPE%TYPE;  -- SR-4266 : shan 07.22.2015
    BEGIN
        FOR main IN (SELECT a.*
                       FROM gipi_polbasic a
                      WHERE line_cd = p_line_cd
                        AND subline_cd = p_subline_cd
                        AND iss_cd = p_iss_cd
                        AND issue_yy = p_issue_yy   -- SR-4266 : shan 07.22.2015
                        AND pol_seq_no = p_pol_seq_no
                        AND renew_no = p_renew_no)
        LOOP
            /*BEGIN
                SELECT a.tran_id, a.tran_flag, a.posting_date
                  INTO v_rec_tran_id, v_rec_tran_flag, v_rec_posting_date
                  FROM giac_acctrans a,
                       giac_direct_prem_collns b
                 WHERE a.TRAN_ID = b.GACC_TRAN_ID
                   AND (b.B140_ISS_CD, b.B140_PREM_SEQ_NO) IN (SELECT y.iss_cd, y.prem_seq_no
                                                                 FROM gipi_polbasic x,
                                                                      gipi_invoice y
                                                                WHERE x.policy_id = y.POLICY_ID
                                                                  AND x.policy_id = main.policy_id)                   
                   AND NOT EXISTS(SELECT 'x'
                                    FROM giac_reversals cc, giac_acctrans dd 
                                   WHERE cc.reversing_tran_id = dd.tran_id 
                                     AND dd.tran_flag <> 'D'
                                     AND cc.gacc_tran_id = a.tran_id);
                                                                  
                EXIT;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rec_tran_id       := NULL;
                    v_rec_tran_flag     := NULL;
                    v_rec_posting_date  := NULL;
                    v_rec_iss_cd        := NULL;
                    v_rec_prem_seq_no   := NULL;
            END; */ -- replaced with codes below :: SR-4266 : shan 07.23.2015
            
            FOR j IN ( SELECT a.tran_id, a.tran_flag, a.posting_date
                         FROM giac_acctrans a,
                              giac_direct_prem_collns b
                        WHERE a.TRAN_ID = b.GACC_TRAN_ID
                          AND (b.B140_ISS_CD, b.B140_PREM_SEQ_NO) IN (SELECT y.iss_cd, y.prem_seq_no
                                                                        FROM gipi_polbasic x,
                                                                             gipi_invoice y
                                                                       WHERE x.policy_id = y.POLICY_ID
                                                                         AND x.policy_id = main.policy_id)    
                          ORDER BY a.tran_id DESC)
            LOOP
                v_rec_tran_id       := j.tran_id;
                v_rec_tran_flag     := j.tran_flag;
                v_rec_posting_date  := j.posting_date;
                EXIT;
            END LOOP;       
        END LOOP;    
        
        /*IF v_rec_tran_flag  = 'C' AND v_rec_posting_date IS NULL THEN -- removed condition :: SR-4266 : shan 07.23.2015
            UPDATE GIAC_ACCTRANS
               SET tran_flag = 'D'
             WHERE tran_id = v_rec_tran_id;
                   
        ELSIF v_rec_tran_flag = 'P' AND v_rec_posting_date IS NOT NULL THEN*/
            v_fund_cd       := Giacp.v ('FUND_CD');                
            v_branch_cd     := p_iss_cd;
            v_tran_class    := 'CPR';
            v_tran_year     := TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy'));
            v_tran_month    := TO_NUMBER (TO_CHAR (SYSDATE, 'mm'));
            v_tran_flag     := 'C';
                            
            SELECT ACCTRAN_TRAN_ID_S.NEXTVAL
              INTO v_gacc_tran_id
              FROM dual;
                      
            v_tran_seq_no := GIAC_SEQUENCE_GENERATION(v_fund_cd, v_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);
                    
            v_tran_class_no := GIAC_SEQUENCE_GENERATION(v_fund_cd, v_branch_cd, 'REV_CANCEL_POLICY', v_tran_year, v_tran_month);
                    
            v_jv_no         := NULL;
            v_jv_pref_suff  := NULL;
            v_jv_id         := NULL;
            v_particulars   := 'This is a system generated transaction to reverse applied payments to cancelled policies and endorsements.';
                    
            INSERT INTO giac_acctrans
                        (tran_id,       gfun_fund_cd,   gibr_branch_cd,     tran_date,
                         tran_flag,     tran_year,      tran_month,         tran_seq_no,
                         tran_class,    tran_class_no,  jv_no,              jv_pref_suff,
                         jv_id,         posting_date,   particulars,        user_id,
                         last_update,   cpi_rec_no,     cpi_branch_cd
                        )
                 VALUES (v_gacc_tran_id,v_fund_cd,      v_branch_cd,        SYSDATE,
                         v_tran_flag,   v_tran_year,    v_tran_month,       v_tran_seq_no,
                         v_tran_class,  v_tran_class_no, v_jv_no,           v_jv_pref_suff,
                         v_jv_id,       NULL,           v_particulars,      p_user_id,
                         SYSDATE,       NULL,           NULL
                        );
                      
            /*INSERT INTO giac_reversals
                        (gacc_tran_id, reversing_tran_id, rev_corr_tag)
                 VALUES (v_rec_tran_id, v_gacc_tran_id, 'R'); */ -- replaced with codes below :: SR-4266 : shan 07.21.2015
             
            FOR bill IN (SELECT y.*
                           FROM gipi_polbasic x,
                                gipi_invoice y
                          WHERE x.policy_id = y.POLICY_ID
                            AND x.line_cd = p_line_cd
                            AND x.subline_cd = p_subline_cd
                            AND x.iss_cd = p_iss_cd
                            AND x.pol_seq_no = p_pol_seq_no
                            AND x.renew_no = p_renew_no)
            LOOP
                FOR i IN (SELECT *
                            FROM giac_direct_prem_collns
                           WHERE b140_iss_cd = bill.iss_cd
                             AND b140_prem_seq_no = bill.prem_seq_no
                             AND transaction_type IN (1,3)
                           ORDER BY gacc_tran_id DESC)
                LOOP
                    IF i.transaction_type = 1 THEN
                        v_tran_type := 2;
                    ELSIF i.transaction_type = 3 THEN
                        v_tran_type := 4;
                    END IF;
                     
                    INSERT INTO GIAC_DIRECT_PREM_COLLNS
                                (gacc_tran_id,              transaction_type,           b140_iss_cd,            b140_prem_seq_no,     
                                 inst_no,                   collection_amt,             premium_amt,            tax_amt,
                                 or_print_tag,              particulars,                currency_cd,            convert_rate, 
                                 foreign_curr_amt,          doc_no,                     colln_dt,               acct_ent_date, 
                                 cpi_rec_no,                cpi_branch_cd,              user_id,                last_update)
                                 
                         VALUES (v_gacc_tran_id,            v_tran_type,                i.b140_iss_cd,          i.b140_prem_seq_no,
                                 i.inst_no,                 (i.collection_amt * -1),    (i.premium_amt * -1),   (i.tax_amt * -1),
                                 i.or_print_tag,            v_particulars,              i.currency_cd,          i.convert_rate,
                                 (i.foreign_curr_amt * -1), i.doc_no,                   i.colln_dt,             i.acct_ent_date, 
                                 i.cpi_rec_no,              i.cpi_branch_cd,            p_user_id,              SYSDATE);
                    EXIT;
                END LOOP;
                
                FOR j IN (SELECT *
                            FROM giac_comm_payts
                           WHERE iss_cd = bill.iss_cd
                             AND prem_seq_no = bill.prem_seq_no
                             AND tran_type IN (1,3)
                           ORDER BY gacc_tran_id DESC)
                LOOP
                    IF j.tran_type = 1 THEN
                        v_tran_type := 2;
                    ELSIF j.tran_type = 3 THEN
                        v_tran_type := 4;
                    END IF;
                    
                    INSERT INTO giac_comm_payts
                                 (gacc_tran_id,     intm_no,            iss_cd,             prem_seq_no,
                                  tran_type,        comm_amt,           wtax_amt,           input_vat_amt, 
                                  particulars,      currency_cd,        convert_rate,       foreign_curr_amt, 
                                  def_comm_tag,     inst_no,            print_tag,          or_print_tag, 
                                  cpi_rec_no,       cpi_branch_cd,      acct_tag,           parent_intm_no, 
                                  sp_acctg,         comm_tag,           record_no,          user_id, 
                                  last_update,      record_seq_no )     --added record_seq_no by albert 12.10.2015 (GENQA SR 5173)
                         VALUES  (v_gacc_tran_id,   j.intm_no,          j.iss_cd,           j.prem_seq_no,
                                  v_tran_type,      (j.comm_amt * -1),  (j.wtax_amt * -1),  (j.input_vat_amt * -1), 
                                  v_particulars,    j.currency_cd,      j.convert_rate,     (j.foreign_curr_amt * -1), 
                                  j.def_comm_tag,   j.inst_no,          j.print_tag,        j.or_print_tag, 
                                  j.cpi_rec_no,     j.cpi_branch_cd,    j. acct_tag,        j.parent_intm_no, 
                                  j.sp_acctg,       j.comm_tag,         j.record_no,        p_user_id, 
                                  SYSDATE,          j.record_seq_no );  --added value of record_seq_no by albert 12.10.2015 (GENQA SR 5173)
                    EXIT;
                END LOOP;
            END LOOP;
        --END IF;    
        
    END reverse_processed_pol;
    
    -- end enhancement : shan 04.15.2015
    -- ================================================
END;
/
