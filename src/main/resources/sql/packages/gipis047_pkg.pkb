CREATE OR REPLACE PACKAGE BODY cpi.gipis047_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 09.02.2013
   **  Reference By : GIPIS047- Update Bond Policy Basic Info
   **  Description  :
   */
   FUNCTION get_bond_lov (
      p_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_line_cd     gipi_polbasic.line_cd%TYPE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN bond_lov_tab PIPELINED
   IS
      v_rec            bond_lov_type;
      v_pol_eff_date   gipi_polbasic.eff_date%TYPE;
      v_count       NUMBER; --added by Mark C. 05072015
      v_or_no       VARCHAR2(15); --added by Mark C. 05072015      
   BEGIN
      FOR i IN (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.assd_no, a.eff_date, a.endt_expiry_date,
                         a.expiry_date, a.incept_date, a.issue_date,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_seq_no, '099999')) endt_no
                    FROM gipi_polbasic a
                        ,giis_line b                                                                --SR4037 lmlbeltran 06082015            
                     WHERE (b.menu_line_cd = 'SU' OR (b.menu_line_cd IS NULL AND b.line_cd = 'SU')) --to include all line_cd under menu_line_cd = 'SU'             
                     AND a.line_cd = b.line_cd                     
                     --WHERE  line_cd IN ('SU', 'BN') -- added by Mark C 04272015, added BN to include it in query --line_cd = 'SU'
                     AND UPPER (b.line_cd) LIKE
                                 '%' || UPPER (NVL (p_line_cd, b.line_cd))
                                 || '%'
                     AND UPPER (a.iss_cd) LIKE
                                 '%' || UPPER (NVL (p_iss_cd, a.iss_cd))
                                 || '%'
                     AND b.line_cd =
                            DECODE (check_user_per_line2 (b.line_cd,
                                                          p_iss_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ),
                                    1, a.line_cd,
                                    NULL
                                   )
                     AND a.iss_cd =
                            DECODE (check_user_per_iss_cd2 (p_line_cd,
                                                            a.iss_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ),
                                    1, a.iss_cd,
                                    NULL
                                   )
                     AND a.pol_flag NOT IN ('4','5','X') -- Added by JDiago 07.14.2014
                ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no)
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.assd_no := i.assd_no;
         v_rec.eff_date := i.eff_date;
         v_rec.dsp_eff_date := TO_CHAR (i.eff_date, 'MM-DD-YYYY HH:MM:SS');
         v_rec.endt_expiry_date := i.endt_expiry_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.incept_date := i.incept_date;
         v_rec.issue_date := i.issue_date;
         v_rec.policy_no := i.policy_no;
         v_rec.endt_no := i.endt_no;
         v_rec.dsp_or_no := NULL;
         v_rec.dsp_obligee_name := NULL;
         v_rec.obligee_no := NULL;
         v_rec.np_name := NULL;
         v_rec.np_no := NULL;
         v_rec.coll_flag := NULL;
         v_rec.waiver_limit := NULL;
         v_rec.dsp_amt_paid :=NULL; --added by Mark C. 05072015
         
         BEGIN
            SELECT waiver_limit
              INTO v_rec.waiver_limit_cond
              FROM giis_bond_class_subline
             WHERE subline_cd = i.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.waiver_limit_cond := 0;
            WHEN OTHERS
            THEN
               v_rec.waiver_limit_cond := 0;
         END;

         BEGIN
            SELECT eff_date
              INTO v_rec.eff_date_cond
              FROM gipi_polbasic
             WHERE endt_seq_no = 0
               AND line_cd = i.line_cd
               AND subline_cd = i.subline_cd
               AND iss_cd = i.iss_cd
               AND issue_yy = i.issue_yy
               AND pol_seq_no = i.pol_seq_no
               AND renew_no = i.renew_no
               AND pol_flag NOT IN ('4', '5');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.eff_date_cond := NULL;
            WHEN OTHERS
            THEN
               v_rec.eff_date_cond := NULL;
         END;

         BEGIN
            SELECT a020.assd_name
              INTO v_rec.assd_name
              FROM giis_assured a020
             WHERE a020.assd_no = i.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.assd_name := NULL;
         END;

         BEGIN
            IF i.endt_seq_no > 0
            THEN                                               -- ENDORSEMENT
               IF TRUNC (i.eff_date) >= TRUNC (i.endt_expiry_date)
               THEN
                  v_rec.updt_eff_dt := 'Y';
               ELSE
                  v_rec.updt_eff_dt := 'N';
               END IF;
            ELSE
               IF TRUNC (i.eff_date) >= TRUNC (i.expiry_date)
               THEN
                  v_rec.updt_eff_dt := 'Y';
               ELSE
                  v_rec.updt_eff_dt := 'N';
               END IF;
            END IF;
         END;

         BEGIN      -- replaced by Mark C. 05072015
            v_count := 0;           
            
            SELECT COUNT(1)
                INTO v_count
              FROM giac_acctrans gacc8,
                          giac_order_of_payts giop10,
                          giac_direct_prem_collns gdpc9,
                          gipi_invoice a
            WHERE giop10.gacc_tran_id = gacc8.tran_id
                  AND gdpc9.gacc_tran_id = giop10.gacc_tran_id
                  AND gacc8.tran_seq_no IS NOT NULL
                  AND gacc8.tran_flag NOT IN ('D', 'd')
                  AND gdpc9.transaction_type = 1
                  AND gdpc9.b140_iss_cd = a.iss_cd
                  AND gdpc9.b140_prem_seq_no = a.prem_seq_no
                  AND a.policy_id = i.policy_id
       ORDER BY gdpc9.gacc_tran_id;
       
            IF v_count = 1 THEN
            
                SELECT giop10.or_no
                    INTO v_or_no
                   FROM giac_acctrans gacc8,
                        giac_order_of_payts giop10,
                        giac_direct_prem_collns gdpc9,
                        gipi_invoice a
                WHERE giop10.gacc_tran_id = gacc8.tran_id
                     AND gdpc9.gacc_tran_id = giop10.gacc_tran_id
                     AND gacc8.tran_seq_no IS NOT NULL
                     AND gacc8.tran_flag NOT IN ('D', 'd')
                     AND gdpc9.transaction_type = 1
                     AND gdpc9.b140_iss_cd = a.iss_cd
                     AND gdpc9.b140_prem_seq_no = a.prem_seq_no
                     AND a.policy_id = i.policy_id
               ORDER BY gdpc9.gacc_tran_id;
                           
                   v_rec.dsp_or_no := v_or_no;
                   
            ELSIF v_count > 1 THEN
                  v_rec.dsp_or_no := 'VARIOUS';      
            END IF;         
/*         
            FOR c1 IN (SELECT   giop10.or_no
                           FROM giac_acctrans gacc8,
                                giac_order_of_payts giop10,
                                giac_direct_prem_collns gdpc9,
                                gipi_invoice a
                          WHERE giop10.gacc_tran_id = gacc8.tran_id
                            AND gdpc9.gacc_tran_id = giop10.gacc_tran_id
                            AND gacc8.tran_seq_no IS NOT NULL
                            AND gacc8.tran_flag NOT IN ('D', 'd')
                            AND gdpc9.transaction_type = 1
                            AND gdpc9.b140_iss_cd = a.iss_cd
                            AND gdpc9.b140_prem_seq_no = a.prem_seq_no
                            AND a.policy_id = i.policy_id
                       ORDER BY gdpc9.gacc_tran_id)
            LOOP
               v_rec.dsp_or_no := c1.or_no;
            END LOOP;  
            */
         END;

         IF v_rec.dsp_or_no IS NOT NULL
         THEN
            FOR c2 IN (SELECT c.total_payments
                                  FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c        -- replaced by Mark C. 05072015
                                 WHERE a.policy_id = b.policy_id
                                   AND b.iss_cd = c.iss_cd
                                   AND b.prem_seq_no = c.prem_seq_no
                                   AND a.policy_id = i.policy_id)
            LOOP
               v_rec.dsp_amt_paid := c2.total_payments; 
            END LOOP;             
         /*
            FOR c2 IN (SELECT prem_amt, tax_amt
                         FROM gipi_invoice
                        WHERE policy_id = i.policy_id)
            LOOP
               v_rec.dsp_amt_paid :=
                                    NVL (c2.prem_amt, 0)
                                    + NVL (c2.tax_amt, 0);
            END LOOP; 
            */
         END IF;

         BEGIN
            IF     v_rec.updt_eff_dt = 'Y'
               AND TRUNC (SYSDATE) >= TRUNC (i.incept_date)
               AND TRUNC (SYSDATE) >= TRUNC (i.issue_date)
            THEN
               IF i.endt_seq_no > 0
               THEN                                            -- ENDORSEMENT
                  BEGIN
                     SELECT eff_date
                       INTO v_pol_eff_date
                       FROM gipi_polbasic
                      WHERE endt_seq_no = 0
                        AND line_cd = i.line_cd
                        AND subline_cd = i.subline_cd
                        AND iss_cd = i.iss_cd
                        AND issue_yy = i.issue_yy
                        AND pol_seq_no = i.pol_seq_no
                        AND renew_no = i.renew_no
                        AND pol_flag NOT IN ('4', '5');

                     IF TRUNC (v_pol_eff_date) <= TRUNC (SYSDATE)
                     THEN
                        v_rec.eff_date := SYSDATE;
                     END IF;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        v_rec.eff_date := NULL;
                  END;
               ELSE                                       -- POLICY OR RENEWAL
                  v_rec.eff_date := SYSDATE;
               END IF;
            END IF;
         END;

         FOR c3 IN (SELECT policy_id, obligee_no, np_no, coll_flag,
                           waiver_limit
                      FROM gipi_bond_basic
                     WHERE policy_id = i.policy_id)
         LOOP
            v_rec.obligee_no := c3.obligee_no;
            v_rec.np_no := c3.np_no;
            v_rec.coll_flag := c3.coll_flag;
            v_rec.waiver_limit := c3.waiver_limit;

            BEGIN
               SELECT a3702.obligee_name
                 INTO v_rec.dsp_obligee_name
                 FROM giis_obligee a3702
                WHERE a3702.obligee_no = c3.obligee_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dsp_obligee_name := NULL;
            END;

            FOR c1_rec IN (SELECT np_name
                             FROM giis_notary_public
                            WHERE np_no = c3.np_no)
            LOOP
               v_rec.np_name := c1_rec.np_name;
            END LOOP;

            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_notary_lov
      RETURN notary_lov_tab PIPELINED
   IS
      v_rec   notary_lov_type;
   BEGIN
      FOR i IN (SELECT np_name np_name, np_no
                  FROM giis_notary_public
                 WHERE TRUNC(expiry_date) > TRUNC(SYSDATE)) --added by Mark C. 04242015 to not include expired notary public                  
      LOOP
         v_rec.np_name := i.np_name;
         v_rec.np_no := i.np_no;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE set_gipi_bond_basic (p_bond_basic gipi_bond_basic%ROWTYPE)
   IS
   BEGIN
      UPDATE gipi_bond_basic
         SET np_no = p_bond_basic.np_no,
             waiver_limit = p_bond_basic.waiver_limit,
             coll_flag = p_bond_basic.coll_flag
       WHERE policy_id = p_bond_basic.policy_id;
   END;
END;
/