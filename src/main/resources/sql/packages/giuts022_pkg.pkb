CREATE OR REPLACE PACKAGE BODY CPI.GIUTS022_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 04.22.2013
    **  Reference By : GIUTS022 - CHANGE IN PAYMENT TERM
    */
   FUNCTION get_policy_info (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      --added for optimization SR5693  10.10.2016 MarkS
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER,
      --end SR5693
      p_user_id       giis_users.user_id%TYPE
      
   )
      RETURN policy_info_tab PIPELINED
   IS
    --commented out for optimization SR5693 MarkS 10.11.2016
--BEGIN
--      FOR pol IN (SELECT   line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
--                           renew_no, endt_iss_cd, endt_yy, endt_seq_no,
--                           policy_id, par_id, assd_no, eff_date, expiry_date,
--                           incept_date, endt_type, pol_flag
--                      FROM gipi_polbasic
--                     WHERE pol_flag IN ('1', '2', '3')
--                       AND NVL (endt_type, 'A') = 'A'
--                       --AND iss_cd =  DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIUTS022', p_user_id),  1, iss_cd,  NULL)
--                       --AND check_user_per_line1 (line_cd, null, p_user_id, 'GIUTS022') = 1
--                       AND UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
--                       AND UPPER (subline_cd) LIKE UPPER (NVL (p_subline_cd, '%'))
--                       AND UPPER (iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
--                       AND issue_yy = NVL (p_issue_yy, issue_yy)
--                       AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
--                       AND renew_no = NVL (p_renew_no, renew_no)
--                       --AND UPPER (iss_cd) LIKE UPPER (NVL (p_endt_iss_cd, '%'))
--                       AND endt_yy = NVL (p_endt_yy, endt_yy)
--                       AND endt_seq_no = NVL (p_endt_seq_no, endt_seq_no)
--                  ORDER BY line_cd,
--                           subline_cd,
--                           iss_cd,
--                           issue_yy,
--                           pol_seq_no,
--                           renew_no,
--                           endt_yy,
--                           endt_seq_no)
--      LOOP
--         v_policy.line_cd       := pol.line_cd;
--         v_policy.subline_cd    := pol.subline_cd;
--         v_policy.iss_cd        := pol.iss_cd;
--         v_policy.issue_yy      := pol.issue_yy;
--         v_policy.pol_seq_no    := pol.pol_seq_no;
--         v_policy.renew_no      := pol.renew_no;
--         v_policy.endt_iss_cd   := pol.endt_iss_cd;
--         v_policy.endt_yy       := pol.endt_yy;
--         v_policy.endt_seq_no   := pol.endt_seq_no;

--         BEGIN
--            IF (pol.assd_no IS NOT NULL)
--            THEN
--               SELECT assd_name
--                 INTO v_policy.assd_name
--                 FROM giis_assured
--                WHERE assd_no = pol.assd_no;
--            END IF;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               v_policy.assd_name := NULL;
--         END;

--         v_policy.policy_id     := pol.policy_id;
--         v_policy.par_id        := pol.par_id;
--         v_policy.assd_no       := pol.assd_no;
--         v_policy.eff_date      := pol.eff_date;
--         v_policy.expiry_date   := pol.expiry_date;
--         v_policy.incept_date   := pol.incept_date;
--         v_policy.policy_no     :=
--               pol.line_cd
--            || ' - '
--            || pol.subline_cd
--            || ' - '
--            || pol.iss_cd
--            || ' -'
--            || TO_CHAR (pol.issue_yy, '09')
--            || ' -'
--            || TO_CHAR (pol.pol_seq_no, '099999')
--            || ' -'
--            || TO_CHAR (pol.renew_no, '09');

--         IF pol.endt_seq_no = 0
--         THEN
--            v_policy.endt_no := NULL;
--         ELSE
--            v_policy.endt_no :=
--                  pol.line_cd
--               || ' - '
--               || pol.subline_cd
--               || ' - '
--               || pol.endt_iss_cd
--               || ' -'
--               || TO_CHAR (pol.endt_yy, '09')
--               || ' -'
--               || TO_CHAR (pol.endt_seq_no, '099999');
--         END IF;

--         PIPE ROW (v_policy);
--      END LOOP;
--commented out for optimization SR5693 MarkS 10.11.2016 
      v_policy   policy_info_type;
      TYPE       cur_type IS REF CURSOR;
      c          cur_type;
      v_sql      VARCHAR2(32767);
   BEGIN                     
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                              SELECT   line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                           renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                           policy_id, par_id, assd_no, eff_date, expiry_date,
                           incept_date, endt_type, pol_flag,(SELECT assd_name
                                                                    FROM giis_assured
                                                             WHERE assd_no = ax.assd_no) assd_name,
                           (line_cd || '' - '' || subline_cd || '' - '' || iss_cd || '' -'' || TO_CHAR (issue_yy, ''09'')
                           || '' -'' || TO_CHAR (pol_seq_no, ''099999'') || '' -'' || TO_CHAR (renew_no, ''09'')) policy_no,
                           DECODE(endt_seq_no,0,null, line_cd || '' - '' || subline_cd || '' - '' || endt_iss_cd  || '' -''  || TO_CHAR (endt_yy, ''09'')
                           || '' -''
                           || TO_CHAR (endt_seq_no, ''099999'')) endt_no
                      FROM gipi_polbasic ax
                     WHERE pol_flag IN (''1'', ''2'', ''3'')
                       AND NVL (endt_type, ''A'') = ''A''
                       AND UPPER (line_cd) LIKE UPPER (NVL (:p_line_cd, ''%''))
                       AND UPPER (subline_cd) LIKE UPPER (NVL (:p_subline_cd, ''%''))
                       AND UPPER (iss_cd) LIKE UPPER (NVL (:p_iss_cd, ''%''))
                       AND issue_yy = NVL (:p_issue_yy, issue_yy)
                       AND pol_seq_no = NVL (:p_pol_seq_no, pol_seq_no)
                       AND renew_no = NVL (:p_renew_no, renew_no)
                       AND endt_yy = NVL (:p_endt_yy, endt_yy)
                       AND endt_seq_no = NVL (:p_endt_seq_no, endt_seq_no)
                       AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''AC'', ''GIUTS022'', :p_user_id)) 
                                WHERE branch_cd = ax.iss_cd) ';
     v_sql := v_sql || ') innersql';  
    IF p_find_text IS NOT NULL
         THEN
            v_sql := v_sql || ' where  (policy_no LIKE UPPER('''||p_find_text||''') OR 
                                       endt_no LIKE UPPER('''||p_find_text||''') OR 
                                        assd_name LIKE UPPER('''||p_find_text||''')) ';
      END IF; 
     IF p_order_by IS NOT NULL
        THEN
          IF p_order_by = 'policyNo'
            THEN        
                v_sql := v_sql || ' ORDER BY policy_no ';
            ELSIF p_order_by = 'endtNo'
            THEN
                v_sql := v_sql || ' ORDER BY endt_no ';
            ELSIF p_order_by = 'assdName'
            THEN
                v_sql := v_sql || ' ORDER BY assd_name ';
            ELSE
                v_sql := v_sql || 'ORDER BY line_cd,
                               subline_cd,
                               iss_cd,
                               issue_yy,
                               pol_seq_no,
                               renew_no,
                               endt_yy,
                               endt_seq_no';
            IF p_asc_desc_flag IS NOT NULL
            THEN
               v_sql := v_sql || p_asc_desc_flag;
            ELSE
               v_sql := v_sql || ' ASC';
            END IF;           
          END IF;
      END IF;     
      
      v_sql := v_sql || ' ) outersql ) mainsql WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                      
      OPEN c FOR v_sql USING p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_endt_yy,p_endt_seq_no,p_user_id;
      LOOP
         FETCH c INTO v_policy.count_      , 
                      v_policy.rownum_     ,
                      v_policy.line_cd     ,
                      v_policy.subline_cd  ,
                      v_policy.iss_cd      ,
                      v_policy.issue_yy    ,
                      v_policy.pol_seq_no  ,
                      v_policy.renew_no    ,
                      v_policy.endt_iss_cd ,
                      v_policy.endt_yy     ,
                      v_policy.endt_seq_no ,
                      v_policy.policy_id   ,
                      v_policy.par_id      ,
                      v_policy.assd_no     ,
                      v_policy.eff_date    ,
                      v_policy.expiry_date ,
                      v_policy.incept_date ,
                      v_policy.endt_type   ,
                      v_policy.pol_flag    ,
                      v_policy.assd_name   , 
                      v_policy.policy_no   ,
                      v_policy.endt_no     ;                              
         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_policy);
      END LOOP;
      CLOSE c; 
      RETURN;
   END get_policy_info;

   FUNCTION get_payterm_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN payterm_tab PIPELINED
   IS
      v_payterm   payterm_type;
   BEGIN
      FOR pay IN (SELECT iss_cd, prem_seq_no, item_grp, property, remarks,
                         prem_amt, tax_amt, other_charges, notarial_fee,
                         due_date, payt_terms, expiry_date, policy_id
                    FROM gipi_invoice
                   WHERE policy_id = p_policy_id)
      LOOP
         v_payterm.iss_cd           := pay.iss_cd;
         v_payterm.prem_seq_no      := pay.prem_seq_no;
         v_payterm.item_grp         := pay.item_grp;
         v_payterm.property         := pay.property;
         v_payterm.remarks          := pay.remarks;
         v_payterm.prem_amt         := pay.prem_amt;
         v_payterm.tax_amt          := pay.tax_amt;
         v_payterm.other_charges    := pay.other_charges;
         v_payterm.notarial_fee     := pay.notarial_fee;
         v_payterm.due_date         := pay.due_date;
         v_payterm.payt_terms       := pay.payt_terms;
         v_payterm.expiry_date      := pay.expiry_date;
         v_payterm.policy_id        := pay.policy_id;

         BEGIN
            SELECT payt_terms_desc, no_of_payt
              INTO v_payterm.payt_terms_desc, v_payterm.no_of_payt
              FROM giis_payterm
             WHERE payt_terms = pay.payt_terms;
         END;

         v_payterm.total_amt := NVL(pay.prem_amt, 0) + NVL(pay.tax_amt, 0);
         PIPE ROW (v_payterm);
      END LOOP;

      RETURN;
   END get_payterm_info;

   FUNCTION get_installment_info (
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_item_grp            gipi_invoice.item_grp%TYPE
   )
      RETURN installment_tab PIPELINED
   IS
      v_install   installment_type;
   BEGIN
      FOR ins IN (SELECT iss_cd, prem_seq_no, inst_no, share_pct, tax_amt,
                         prem_amt, item_grp, due_date
                    FROM gipi_installment
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND item_grp = p_item_grp)
      LOOP
         v_install.iss_cd       := ins.iss_cd;
         v_install.prem_seq_no  := ins.prem_seq_no;
         v_install.inst_no      := ins.inst_no;
         v_install.share_pct    := ins.share_pct;
         v_install.tax_amt      := ins.tax_amt;
         v_install.prem_amt     := ins.prem_amt;
         v_install.item_grp     := ins.item_grp;
         v_install.due_date     := ins.due_date;
         PIPE ROW (v_install);
      END LOOP;

      RETURN;
   END get_installment_info;

   --copied from CS
   PROCEDURE update_payment_term (
      p_user_id           gipi_invoice.user_id%TYPE,
      p_iss_cd            gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no       gipi_invoice.prem_seq_no%TYPE,
      p_item_grp          gipi_invoice.item_grp%TYPE,
      p_policy_id         gipi_invoice.policy_id%TYPE,
      p_due_date          gipi_invoice.due_date%TYPE,
      p_payt_terms_desc   giis_payterm.payt_terms_desc%TYPE,
      p_prem_amt          gipi_invoice.prem_amt%TYPE,
      p_other_charges     gipi_invoice.other_charges%TYPE,
      p_notarial_fee      gipi_invoice.notarial_fee%TYPE,
      p_tax_amt           gipi_invoice.tax_amt%TYPE
   )
   IS
   BEGIN
      DECLARE
         var_no_of_payt          giis_payterm.no_of_payt%TYPE;
         var_inst_no             gipi_installment.inst_no%TYPE           := 0;
         var_share_pct           gipi_installment.share_pct%TYPE         := 0;
         var_prem_amt            gipi_installment.prem_amt%TYPE          := 0;
         var_tax_amt             gipi_installment.tax_amt%TYPE           := 0;
         var_due_date            gipi_installment.due_date%TYPE;
         var_due_date2           gipi_installment.due_date%TYPE; --carlo SR 5928 02-14-2017
         var_hist_seq            gipi_installment_hist.hist_seq_no%TYPE  := 1;
         v_payt_terms            giis_payterm.payt_terms%TYPE;
         v_on_incept_tag         giis_payterm.on_incept_tag%TYPE;
         v_no_of_days            giis_payterm.no_of_days%TYPE;
         v_duration              NUMBER;
         v_interval              NUMBER;
         v_incept_date           gipi_polbasic.incept_date%TYPE;
         v_expiry_date           gipi_polbasic.expiry_date%TYPE;
         v_no_of_payment         NUMBER;
         v_no_payt_days          NUMBER;
         v_no_of_days_again      giis_payterm.no_of_days%TYPE;
         v_exact_no_of_payment   NUMBER;
         v_annual_sw             giis_payterm.annual_sw%TYPE;
         v_policy_days           NUMBER;
         v_count                 NUMBER;
         v_ctr                   NUMBER;
         v_variable              VARCHAR2 (1)                          := 'N';
         v_exist                 VARCHAR2 (1)                          := 'N';
         v_orig_incept_date      gipi_polbasic.eff_date%TYPE;
         v_orig_expiry_date      gipi_polbasic.expiry_date%TYPE;
         v_prod_take_up          VARCHAR2(1); --carlo SR 5928 02-14-2017
      BEGIN
         FOR a1 IN (SELECT MAX (hist_seq_no) seq
                      FROM gipi_installment_hist
                     WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            var_hist_seq := NVL (a1.seq, 0) + 1;
         END LOOP a1;

         INSERT INTO gipi_installment_hist
                     (iss_cd, prem_seq_no, hist_seq_no,
                      last_update, user_id
                     )
              VALUES (p_iss_cd, p_prem_seq_no, NVL (var_hist_seq, 1),
                      SYSDATE, p_user_id
                     );

         FOR a2 IN (SELECT *
                      FROM gipi_installment
                     WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            INSERT INTO gipi_installment_hist_dtl
                        (iss_cd, prem_seq_no, hist_seq_no,
                         item_grp, inst_no, share_pct, tax_amt,
                         prem_amt, due_date
                        )
                 VALUES (p_iss_cd, p_prem_seq_no, NVL (var_hist_seq, 1),
                         a2.item_grp, a2.inst_no, a2.share_pct, a2.tax_amt,
                         a2.prem_amt, a2.due_date
                        );
         END LOOP a2;

         DELETE FROM gipi_installment
               WHERE iss_cd = p_iss_cd
                 AND prem_seq_no = p_prem_seq_no
                 AND item_grp = p_item_grp;

         FOR x IN (SELECT MAX (takeup_seq_no) takeup_seq
                     FROM gipi_invoice
                    WHERE policy_id = p_policy_id)
         LOOP
            v_ctr := x.takeup_seq;
         END LOOP;

         IF v_ctr > 1
         THEN
            v_variable := 'Y';
         END IF;
         
         BEGIN --carlo SR 5928 02-14-2017
            SELECT GIACP.N('PROD_TAKE_UP') INTO v_prod_take_up
            FROM DUAL;
         END;

         FOR b IN (SELECT eff_date, endt_expiry_date, expiry_date, issue_date
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id)
         LOOP
            IF b.endt_expiry_date IS NULL
            THEN
               v_expiry_date        := b.expiry_date;
               v_incept_date        := b.eff_date;
               v_orig_incept_date   := b.eff_date;
               v_orig_expiry_date   := b.expiry_date;
            ELSE
               v_expiry_date        := b.endt_expiry_date;
               v_incept_date        := b.eff_date;
               v_orig_incept_date   := b.eff_date;
               v_orig_expiry_date   := b.endt_expiry_date;
            END IF;
            
            IF v_prod_take_up = 1 OR --Added by carlo SR 5928 02-14-2017
                      (v_prod_take_up = 3 AND b.issue_date > v_incept_date) OR
                      (v_prod_take_up = 4 AND b.issue_date< v_incept_date) THEN
                      var_due_date:= b.issue_date;
            ELSIF v_prod_take_up = 2 OR
                      (v_prod_take_up = 3 AND b.issue_date <= v_incept_date) OR
                      (v_prod_take_up = 4 AND b.issue_date >= v_incept_date) THEN
                      var_due_date:= v_incept_date;
            END IF;

            EXIT;
         END LOOP;

         FOR rec IN (SELECT a.no_of_days, a.no_of_payt, a.annual_sw,
                            a.on_incept_tag, a.no_payt_days, a.payt_terms
                       FROM giis_payterm a
                      WHERE a.payt_terms_desc = p_payt_terms_desc)
         LOOP
            v_no_of_days    := NVL (rec.no_of_days, 0);
            var_no_of_payt  := rec.no_of_payt;
            v_annual_sw     := rec.annual_sw;
            v_on_incept_tag := rec.on_incept_tag;
            v_no_payt_days  := rec.no_payt_days;
            v_payt_terms    := rec.payt_terms;

            FOR m IN (SELECT due_date, takeup_seq_no
                        FROM gipi_invoice
                       WHERE policy_id = p_policy_id
                         AND prem_seq_no = p_prem_seq_no)
            LOOP
               IF v_variable = 'Y'
               THEN
                  FOR y IN (SELECT takeup_seq_no, due_date
                              FROM gipi_invoice
                             WHERE policy_id = p_policy_id
                               AND takeup_seq_no = m.takeup_seq_no + 1)
                  LOOP
                     v_exist       := 'Y';
                     v_incept_date := m.due_date;
                     v_expiry_date := y.due_date;
                  END LOOP;

                  IF v_exist = 'N'
                  THEN
                     v_expiry_date := v_orig_expiry_date;
                  END IF;
               END IF;
            END LOOP;

            IF NVL (rec.on_incept_tag, 'N') = 'N'
            THEN
               v_no_of_days_again := 0;
            ELSE
               v_no_of_days_again := NVL (rec.no_of_days, 0);
            END IF;
         END LOOP;

         IF TRUNC(v_expiry_date) - TRUNC(v_incept_date) = 31
         THEN
            v_policy_days := 30;
         ELSE
            v_policy_days := TRUNC(v_expiry_date) - TRUNC(v_incept_date);
         END IF;

         IF NVL (v_annual_sw, 'N') = 'N'
         THEN
            IF v_no_payt_days IS NOT NULL
            THEN
               IF v_no_payt_days < v_policy_days - v_no_of_days
               THEN
                  IF v_no_payt_days < var_no_of_payt
                  THEN
                     v_no_of_payment := v_no_payt_days;
                  ELSE
                     v_no_of_payment := var_no_of_payt;
                  END IF;
               ELSE
                  IF v_policy_days - v_no_of_days < var_no_of_payt
                  THEN
                     v_no_of_payment := v_policy_days - v_no_of_days;
                  ELSE
                     v_no_of_payment :=
                        ROUND (((v_policy_days - v_no_of_days) * var_no_of_payt) / v_no_payt_days);
                  END IF;
               END IF;

               v_exact_no_of_payment := v_no_of_payment;
            ELSE
               IF v_policy_days - v_no_of_days < var_no_of_payt
               THEN
                  v_no_of_payment := v_policy_days - v_no_of_days;
               ELSE
                  v_no_of_payment := var_no_of_payt;
               END IF;
               
               v_exact_no_of_payment := v_no_of_payment;    --SR 0013259  PHILFIRE-QA  added by kenneth L. 05.31.2013
               
            END IF;
         ELSE
            IF   TRUNC((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt > TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt)
            THEN
               v_no_of_payment :=  TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 3) * var_no_of_payt) + 1;
            ELSE
               IF (v_expiry_date - v_incept_date) >= 1095
               THEN
                  FOR x IN (SELECT COUNT (prem_seq_no) c_prem
                              FROM gipi_invoice
                             WHERE policy_id = p_policy_id)
                  LOOP
                     v_count := x.c_prem;

                     IF v_count > 1
                     THEN
                        v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days)  / 365,  3) * (var_no_of_payt / 3));
                     ELSE
                        v_no_of_payment := TRUNC(TRUNC( (v_policy_days - v_no_of_days) / 365, 3)  * (var_no_of_payt));
                     END IF;
                  END LOOP;
               ELSIF (v_expiry_date - v_incept_date) >= 730
               THEN
                  FOR x IN (SELECT COUNT (prem_seq_no) c_prem
                              FROM gipi_invoice
                             WHERE policy_id = p_policy_id)
                  LOOP
                     v_count := x.c_prem;

                     IF v_count > 1
                     THEN
                        v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365,  3)  * (var_no_of_payt / 2));
                     ELSE
                        v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365,  3) * (var_no_of_payt));
                     END IF;
                  END LOOP;
               ELSE
                  v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 3) * (var_no_of_payt));
               END IF;
            END IF;

            IF TRUNC ((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt < 1
            THEN
               v_exact_no_of_payment := 1;
            ELSE
               v_exact_no_of_payment := TRUNC((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt;
            END IF;
         END IF;

         IF v_no_of_payment < 1
         THEN
            v_no_of_payment := 1;
         END IF;

         var_share_pct := TRUNC((100 / v_no_of_payment), 2);
         var_prem_amt :=  ROUND((p_prem_amt + NVL (p_other_charges, 0) + NVL (p_notarial_fee, 0)) / v_no_of_payment,  2);

         IF v_on_incept_tag = 'Y'
         THEN
            var_due_date := v_incept_date; --p_due_date; comment out by carlo SR 5928 02-15-2017
         END IF;
         /*ELSE
            var_due_date := p_due_date + v_no_of_days;
         END IF; comment out by carlo SR 5928 02-15-2017*/

         FOR n IN 1 .. v_no_of_payment
         LOOP
            var_inst_no := var_inst_no + 1;
            var_tax_amt := 0;

            FOR tax IN (SELECT tax_allocation, tax_amt
                          FROM gipi_inv_tax
                         WHERE iss_cd = p_iss_cd
                           AND prem_seq_no = p_prem_seq_no)
            LOOP
               IF var_inst_no > 1
               THEN
                  IF tax.tax_allocation = 'S'
                  THEN
                     var_tax_amt := var_tax_amt + ROUND ((tax.tax_amt / v_no_of_payment), 2);
                  ELSIF tax.tax_allocation = 'L' AND n = var_no_of_payt
                  THEN
                     var_tax_amt := var_tax_amt + tax.tax_amt;
                  END IF;
               ELSE
                  IF tax.tax_allocation = 'S'
                  THEN
                     var_tax_amt := var_tax_amt + ROUND ((tax.tax_amt / v_no_of_payment), 2);
                  ELSIF tax.tax_allocation = 'F'
                  THEN
                     var_tax_amt := var_tax_amt + tax.tax_amt;
                  END IF;
               END IF;
            END LOOP;

            IF var_inst_no >= 1 --carlo SR 5928 02-15-2017
            THEN
               IF v_no_payt_days IS NOT NULL
               THEN
                  IF (v_policy_days - v_no_of_days) > v_no_payt_days
                  THEN
                     var_due_date := var_due_date + ROUND (v_no_payt_days / v_no_of_payment);-- + v_no_of_days_again; comment out by carlo SR 5928 02-15-2017
                  ELSE
                     var_due_date := var_due_date + ROUND (  (v_policy_days - v_no_of_days) / v_exact_no_of_payment);-- + v_no_of_days_again; comment out by carlo SR 5928 02-15-2017
                  END IF;
               ELSE
                  var_due_date := var_due_date + ROUND (  (v_policy_days - v_no_of_days) / v_exact_no_of_payment);-- + v_no_of_days_again; comment out by carlo SR 5928 02-15-2017
               END IF;

               --v_no_of_days_again := 0; comment out by carlo SR 5928 02-15-2017
            END IF;

            INSERT INTO gipi_installment
                        (iss_cd, prem_seq_no, item_grp, inst_no,
                         share_pct, prem_amt, tax_amt,
                         due_date
                        )
                 VALUES (p_iss_cd, p_prem_seq_no, p_item_grp, var_inst_no,
                         var_share_pct, var_prem_amt, var_tax_amt,
                         TRUNC(var_due_date)--Add trunc by carlo SR 5928 02-15-2017
                        );
         END LOOP;
         
         BEGIN --Added by carlo SR 5928 02-15-2017
          SELECT MIN(due_date) INTO var_due_date2
               FROM gipi_installment
            WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
         END;
         
         BEGIN --moved by carlo SR 5928 02-15-2017
          UPDATE gipi_invoice
             SET payt_terms = v_payt_terms,
                  due_date = var_due_date2
          WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
         END;
         
      END;

      DECLARE
         adj_share_pct   gipi_winstallment.share_pct%TYPE   := 0;
         adj_prem_amt    gipi_winstallment.prem_amt%TYPE    := 0;
         adj_tax_amt     gipi_winstallment.tax_amt%TYPE     := 0;
         tax_sw          VARCHAR2 (1)                       := 'N';
      BEGIN
         FOR adj IN (SELECT SUM (share_pct) pct, SUM (prem_amt) prem,
                            SUM (tax_amt) tax, MAX (inst_no) max3,
                            MIN (inst_no) min3
                       FROM gipi_installment
                      WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            adj_share_pct := 100 - adj.pct;
            adj_prem_amt  := (p_prem_amt + NVL (p_other_charges, 0) + NVL (p_notarial_fee, 0)) - adj.prem;
            adj_tax_amt   := p_tax_amt - adj.tax;

            IF (NVL (adj_share_pct, 0) <> 0) OR (NVL (adj_prem_amt, 0) <> 0)
            THEN
               UPDATE gipi_installment
                  SET share_pct = share_pct + adj_share_pct,
                      prem_amt = prem_amt + adj_prem_amt
                WHERE iss_cd = p_iss_cd
                  AND prem_seq_no = p_prem_seq_no
                  AND inst_no = adj.max3;
            END IF;

            IF NVL (adj_tax_amt, 0) <> 0
            THEN
               FOR allocation IN (SELECT '1'
                                    FROM gipi_inv_tax
                                   WHERE iss_cd = p_iss_cd
                                     AND prem_seq_no = p_prem_seq_no
                                     AND tax_allocation IN ('S', 'F'))
               LOOP
                  tax_sw := 'Y';
                  EXIT;
               END LOOP;

               IF NVL (tax_sw, 'N') = 'N'
               THEN
                  UPDATE gipi_installment
                     SET tax_amt = tax_amt + adj_tax_amt
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND inst_no = adj.max3;
               ELSE
                  UPDATE gipi_installment
                     SET tax_amt = tax_amt + adj_tax_amt
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND inst_no = adj.max3;
               END IF;
            END IF;
         END LOOP;
      END;
   END;

   PROCEDURE update_due_date (p_installment gipi_installment%ROWTYPE)
   IS
   BEGIN
      UPDATE gipi_installment
         SET due_date       = p_installment.due_date,
             share_pct      = p_installment.share_pct,
             tax_amt        = p_installment.tax_amt,
             prem_amt       = p_installment.prem_amt
       WHERE prem_seq_no    = p_installment.prem_seq_no
         AND iss_cd         = p_installment.iss_cd
         AND inst_no        = p_installment.inst_no;
   END update_due_date;

   FUNCTION get_tax_allocation_info (
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_item_grp            gipi_invoice.item_grp%TYPE
   )
      RETURN tax_allocation_tab PIPELINED
   IS
      v_tax_alloc   tax_allocation_type;
   BEGIN
      FOR tax IN (SELECT tax_id, prem_seq_no, tax_cd, tax_amt, line_cd,
                         iss_cd, rate, tax_allocation,
                         DECODE (tax_allocation,
                                 'F', 'First',
                                 'S', 'Spread',
                                 'L', 'Last'
                                ) tax_allocation_desc,
                         fixed_tax_allocation
                    FROM gipi_inv_tax
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND item_grp = p_item_grp)
      LOOP
         v_tax_alloc.tax_id               := tax.tax_id;
         v_tax_alloc.prem_seq_no          := tax.prem_seq_no;
         v_tax_alloc.tax_cd               := tax.tax_cd;
         v_tax_alloc.tax_amt              := tax.tax_amt;
         v_tax_alloc.line_cd              := tax.line_cd;
         v_tax_alloc.iss_cd               := tax.iss_cd;
         v_tax_alloc.rate                 := tax.rate;
         v_tax_alloc.tax_allocation_desc  := tax.tax_allocation_desc;
         v_tax_alloc.tax_allocation       := tax.tax_allocation;
         v_tax_alloc.fixed_tax_allocation := tax.fixed_tax_allocation;

         BEGIN
            SELECT tax_desc
              INTO v_tax_alloc.tax_description
              FROM giis_tax_charges
             WHERE line_cd = tax.line_cd
               AND iss_cd = tax.iss_cd
               AND tax_cd = tax.tax_cd
               AND tax_id = tax.tax_id;         --kenneth L. 06.17.2013
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tax_alloc.tax_description := NULL;
         END;

         PIPE ROW (v_tax_alloc);
      END LOOP;

      RETURN;
   END get_tax_allocation_info;

   FUNCTION validate_fully_paid (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_prem_amt   giac_direct_prem_collns.premium_amt%TYPE;
   BEGIN
      FOR i IN (SELECT premium_amt
                  FROM giac_direct_prem_collns a, giac_acctrans b
                 WHERE a.gacc_tran_id = b.tran_id
                   AND b.tran_flag <> 'D'
                   AND NOT EXISTS (
                          SELECT c.gacc_tran_id
                            FROM giac_reversals c, giac_acctrans d
                           WHERE c.reversing_tran_id = d.tran_id
                             AND d.tran_flag <> 'D'
                             AND c.gacc_tran_id = a.gacc_tran_id)
                   AND b140_iss_cd = p_iss_cd
                   AND b140_prem_seq_no = p_prem_seq_no)
      LOOP
         v_prem_amt := i.premium_amt;
         EXIT;
      END LOOP;

      RETURN v_prem_amt;
   END validate_fully_paid;

   FUNCTION get_incept_expiry (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_inv_due_date        DATE
   )
      RETURN incept_expiry_tab PIPELINED
   IS
      v_date   incept_expiry_type;
   BEGIN
      FOR i IN (SELECT TRUNC (incept_date) incept_date,
                       TRUNC (expiry_date) expiry_date, line_cd, subline_cd,
                       iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_polbasic
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   AND endt_seq_no =
                          (SELECT MAX (endt_seq_no)
                             FROM gipi_polbasic
                            WHERE line_cd = p_line_cd
                              AND subline_cd = p_subline_cd
                              AND iss_cd = p_iss_cd
                              AND issue_yy = p_issue_yy
                              AND pol_seq_no = p_pol_seq_no
                              AND renew_no = p_renew_no))
      LOOP
      
         v_date.incept_date := TO_CHAR (i.incept_date, 'MM-DD-YYYY');
         v_date.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_date.line_cd     := i.line_cd;
         v_date.subline_cd  := i.subline_cd;
         v_date.iss_cd      := i.iss_cd;
         v_date.issue_yy    := i.issue_yy;
         v_date.pol_seq_no  := i.pol_seq_no;
         v_date.renew_no    := i.renew_no;
         
         if TRUNC(p_inv_due_date) < i.incept_date
          THEN 
            v_date.message := 'Due date must not be earlier than ' || TO_CHAR (i.incept_date, 'fmMonth DD, RRRR') ||  '.';
          elsif TRUNC(p_inv_due_date) > i.expiry_date
          then
            v_date.message := 'Due date must not be later than ' || TO_CHAR (i.expiry_date, 'fmMonth DD, RRRR') ||  '.';
          end if;
         
         PIPE ROW (v_date);
      END LOOP;

      RETURN;
   END get_incept_expiry;

   PROCEDURE update_due_date_invoice (
      p_due_date    gipi_invoice.due_date%TYPE,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_invoice
         SET due_date   = p_due_date
       WHERE policy_id  = p_policy_id;
   END update_due_date_invoice;

   FUNCTION check_if_can_change (
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_alert   VARCHAR2 (1);
      v_ri_cd   VARCHAR2 (2);
   BEGIN
      v_ri_cd := giisp.v ('ISS_CD_RI');

      IF v_ri_cd IS NULL
      THEN
         v_alert := '0';
      END IF;

      IF p_iss_cd = v_ri_cd
      THEN
         BEGIN
            FOR ri IN (SELECT ri_cd
                         FROM giri_inpolbas
                        WHERE policy_id = p_policy_id)
            LOOP
               v_ri_cd := ri.ri_cd;
               EXIT;
            END LOOP;
         END;

         FOR a1 IN (SELECT SUM (NVL (balance_due, 0)) sum1
                      FROM giac_aging_ri_soa_details
                     WHERE 1 = 1
                       AND gagp_aging_id > 0
                       AND a020_assd_no > 0
                       AND a150_line_cd = p_line_cd
                       AND prem_seq_no = p_prem_seq_no)
         LOOP
            IF a1.sum1 = 0
            THEN
               v_alert := '1';
            ELSE
               DECLARE
                  v_total_payts   giac_inwfacul_prem_collns.collection_amt%TYPE;
               BEGIN
                  SELECT SUM (NVL (collection_amt, 0))
                    INTO v_total_payts
                    FROM giac_inwfacul_prem_collns gifc, giac_acctrans gacc
                   WHERE gifc.gacc_tran_id = gacc.tran_id
                     AND gifc.b140_iss_cd = p_iss_cd
                     AND gifc.b140_prem_seq_no = p_prem_seq_no
                     AND gifc.a180_ri_cd = v_ri_cd
                     AND gacc.tran_flag != 'D'
                     AND gacc.tran_id NOT IN (
                            SELECT grev.gacc_tran_id
                              FROM giac_reversals grev, giac_acctrans gacc2
                             WHERE grev.reversing_tran_id = gacc2.tran_id
                               AND gacc2.tran_flag != 'D');

                  IF v_total_payts != 0
                  THEN
                     v_alert := '2';
                  ELSE
                     NULL;
                  END IF;
               END gifc;
            END IF;
         END LOOP a1;
      ELSE
         FOR a1 IN (SELECT SUM (NVL (balance_amt_due, 0)) sum1
                      FROM giac_aging_soa_details
                     WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            IF a1.sum1 = 0
            THEN
               v_alert := '3';
            ELSE
               DECLARE
                  v_total_payts2   giac_direct_prem_collns.collection_amt%TYPE;
               BEGIN
                  SELECT SUM (NVL (gdpc.collection_amt, 0))
                    INTO v_total_payts2
                    FROM giac_direct_prem_collns gdpc, giac_acctrans gacc
                   WHERE gdpc.b140_iss_cd = p_iss_cd
                     AND gdpc.b140_prem_seq_no = p_prem_seq_no
                     AND gdpc.gacc_tran_id = gacc.tran_id
                     AND gacc.tran_flag != 'D'
                     AND gacc.tran_id NOT IN (
                            SELECT grev.gacc_tran_id
                              FROM giac_reversals grev, giac_acctrans gacc2
                             WHERE grev.reversing_tran_id = gacc2.tran_id
                               AND gacc2.tran_flag != 'D');

                  IF v_total_payts2 != 0
                  THEN
                     v_alert := '4';
                  ELSE
                     NULL;
                  END IF;
               END gdpc;
            END IF;
         END LOOP;
      END IF;

      RETURN v_alert;
   END;

   PROCEDURE update_workflow_switch (
      p_event_desc   IN   VARCHAR2,
      p_module_id    IN   VARCHAR2,
      p_user         IN   VARCHAR2
   )
   IS
      v_commit   BOOLEAN := FALSE;
   BEGIN
      FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd
                      FROM giis_events_column c,
                           giis_event_mod_users b,
                           giis_event_modules a,
                           giis_events d
                     WHERE 1 = 1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       AND b.userid = p_user
                       AND a.module_id = p_module_id
                       AND a.event_cd = d.event_cd
                       AND UPPER (d.event_desc) = UPPER (NVL (p_event_desc, d.event_desc)))
      LOOP
         FOR b_rec IN (SELECT b.col_value, b.tran_id, b.event_col_cd,
                              b.event_user_mod, b.SWITCH
                         FROM gipi_user_events b
                        WHERE b.event_user_mod = a_rec.event_user_mod
                          AND b.event_col_cd = a_rec.event_col_cd)
         LOOP
            IF b_rec.SWITCH = 'N'
            THEN
               UPDATE gipi_user_events
                  SET SWITCH = 'Y'
                WHERE event_user_mod = b_rec.event_user_mod
                  AND event_col_cd = b_rec.event_col_cd
                  AND tran_id = b_rec.tran_id;

               v_commit := TRUE;
            END IF;
         END LOOP;
      END LOOP;

      IF v_commit = TRUE
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE update_tax_amt (
      p_policy_id         gipi_invoice.policy_id%TYPE,
      p_payt_terms_desc   giis_payterm.payt_terms_desc%TYPE,
      p_iss_cd            gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no       gipi_invoice.prem_seq_no%TYPE,
      p_tax_amt           gipi_invoice.tax_amt%TYPE
   )
   IS
   BEGIN
      DECLARE
         var_no_of_payt          giis_payterm.no_of_payt%TYPE;
         var_inst_no             gipi_winstallment.inst_no%TYPE          := 0;
         var_share_pct           gipi_winstallment.share_pct%TYPE        := 0;
         var_prem_amt            gipi_winstallment.prem_amt%TYPE         := 0;
         var_tax_amt             gipi_winstallment.tax_amt%TYPE          := 0;
         var_due_date            gipi_winstallment.due_date%TYPE;
         var_hist_seq            gipi_installment_hist.hist_seq_no%TYPE  := 1;
         var_max                 gipi_winstallment.inst_no%TYPE          := 0;
         var_min                 gipi_winstallment.inst_no%TYPE          := 0;
         v_on_incept_tag         giis_payterm.on_incept_tag%TYPE;
         v_no_of_days            giis_payterm.no_of_days%TYPE;
         v_payt_terms            giis_payterm.payt_terms%TYPE;
         v_expiry_date           gipi_polbasic.expiry_date%TYPE;
         v_incept_date           gipi_polbasic.incept_date%TYPE;
         v_no_of_payment         NUMBER;
         v_no_payt_days          NUMBER;
         v_no_of_days_again      giis_payterm.no_of_days%TYPE;
         v_exact_no_of_payment   NUMBER;
         v_annual_sw             giis_payterm.annual_sw%TYPE;
         v_policy_days           NUMBER;
         v_count                 NUMBER;
      BEGIN
         FOR b IN (SELECT eff_date, endt_expiry_date, expiry_date
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id)
         LOOP
            IF b.endt_expiry_date IS NULL
            THEN
               v_expiry_date := b.expiry_date;
               v_incept_date := b.eff_date;
            ELSE
               v_expiry_date := b.endt_expiry_date;
               v_incept_date := b.eff_date;
            END IF;

            EXIT;
         END LOOP;

         FOR rec IN (SELECT no_of_days, no_of_payt, annual_sw, on_incept_tag,
                            no_payt_days, payt_terms
                       FROM giis_payterm
                      WHERE payt_terms_desc = p_payt_terms_desc)
         LOOP
            v_no_of_days := NVL (rec.no_of_days, 0);
            var_no_of_payt := rec.no_of_payt;
            v_annual_sw := rec.annual_sw;
            v_on_incept_tag := rec.on_incept_tag;
            v_no_payt_days := rec.no_payt_days;
            v_payt_terms := rec.payt_terms;

            IF NVL (rec.on_incept_tag, 'N') = 'N'
            THEN
               v_no_of_days_again := 0;
            ELSE
               v_no_of_days_again := NVL (rec.no_of_days, 0);
            END IF;
         END LOOP;

         IF TRUNC (v_expiry_date) - TRUNC (v_incept_date) = 31
         THEN
            v_policy_days := 30;
         ELSE
            v_policy_days := TRUNC (v_expiry_date) - TRUNC (v_incept_date);
         END IF;

         IF NVL (v_annual_sw, 'N') = 'N'
         THEN
            IF v_no_payt_days IS NOT NULL
            THEN
               IF v_no_payt_days < v_policy_days - v_no_of_days
               THEN
                  IF v_no_payt_days < var_no_of_payt
                  THEN
                     v_no_of_payment := v_no_payt_days;
                  ELSE
                     v_no_of_payment := var_no_of_payt;
                  END IF;
               ELSE
                  IF v_policy_days - v_no_of_days < var_no_of_payt
                  THEN
                     v_no_of_payment := v_policy_days - v_no_of_days;
                  ELSE
                     v_no_of_payment := ROUND (  (  (v_policy_days - v_no_of_days) * var_no_of_payt) / v_no_payt_days);
                  END IF;
               END IF;

               v_exact_no_of_payment := v_no_of_payment;
            ELSE
               IF v_policy_days - v_no_of_days < var_no_of_payt
               THEN
                  v_no_of_payment := v_policy_days - v_no_of_days;
               ELSE
                  v_no_of_payment := var_no_of_payt;
               END IF;
               
               v_exact_no_of_payment := v_no_of_payment;    --SR 0013259  PHILFIRE-QA  added by kenneth L. 05.31.2013
            END IF;
         ELSE
            IF TRUNC ((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt > TRUNC (  TRUNC ((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt)
            THEN
               v_no_of_payment := TRUNC (  TRUNC ((v_policy_days - v_no_of_days) / 365, 3) * var_no_of_payt) + 1;
            ELSE
               v_no_of_payment := TRUNC (  TRUNC ((v_policy_days - v_no_of_days) / 365, 3) * var_no_of_payt);
            END IF;

            IF TRUNC ((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt < 1
            THEN
               v_exact_no_of_payment := 1;
            ELSE
               v_exact_no_of_payment := TRUNC ((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt;
            END IF;
         END IF;

         IF v_no_of_payment < 1
         THEN
            v_no_of_payment := 1;
         END IF;

         UPDATE gipi_installment
            SET tax_amt = 0
          WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;

         FOR inst IN (SELECT MAX (inst_no) max1, MIN (inst_no) min1
                        FROM gipi_installment
                       WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            var_max := inst.max1;
            var_min := inst.min1;

            FOR alloc IN (SELECT tax_id, prem_seq_no, tax_cd, tax_amt,
                                 line_cd, iss_cd, rate, tax_allocation
                            FROM gipi_inv_tax
                           WHERE iss_cd = p_iss_cd
                             AND prem_seq_no = p_prem_seq_no)
            LOOP
               IF alloc.tax_cd IS NOT NULL
               THEN
                  IF alloc.tax_allocation = 'F'
                  THEN
                     UPDATE gipi_installment
                        SET tax_amt = tax_amt + alloc.tax_amt
                      WHERE iss_cd = p_iss_cd
                        AND prem_seq_no = p_prem_seq_no
                        AND inst_no = var_min;
                  ELSIF alloc.tax_allocation = 'L'
                  THEN
                     UPDATE gipi_installment
                        SET tax_amt = tax_amt + alloc.tax_amt
                      WHERE iss_cd = p_iss_cd
                        AND prem_seq_no = p_prem_seq_no
                        AND inst_no = var_max;
                  ELSE
                     UPDATE gipi_installment
                        SET tax_amt = tax_amt + ROUND ((alloc.tax_amt / v_no_of_payment), 2)
                      WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      END;

      DECLARE
         adj_share_pct   gipi_winstallment.share_pct%TYPE   := 0;
         adj_prem_amt    gipi_winstallment.prem_amt%TYPE    := 0;
         adj_tax_amt     gipi_winstallment.tax_amt%TYPE     := 0;
         tax_sw          VARCHAR2 (1)                       := 'N';
      BEGIN
         FOR adj IN (SELECT SUM (tax_amt) tax, MAX (inst_no) max2,
                            MIN (inst_no) min2
                       FROM gipi_installment
                      WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            adj_tax_amt := p_tax_amt - adj.tax;

            IF NVL (adj_tax_amt, 0) <> 0
            THEN
               FOR allocation IN (SELECT '1'
                                    FROM gipi_inv_tax
                                   WHERE iss_cd = p_iss_cd
                                     AND prem_seq_no = p_prem_seq_no
                                     AND tax_allocation IN ('F', 'S'))
               LOOP
                  tax_sw := 'Y';
                  EXIT;
               END LOOP;

               IF NVL (tax_sw, 'N') = 'Y'
               THEN
                  UPDATE gipi_installment
                     SET tax_amt = tax_amt + adj_tax_amt
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND inst_no = adj.max2;
               ELSE
                  UPDATE gipi_installment
                     SET tax_amt = tax_amt + adj_tax_amt
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND inst_no = adj.min2;
               END IF;
            END IF;
         END LOOP;
      END;
   END;

   PROCEDURE update_tax_allocation (p_inv_tax gipi_inv_tax%ROWTYPE)
   IS
   BEGIN
      UPDATE gipi_inv_tax
         SET tax_allocation = p_inv_tax.tax_allocation
       WHERE prem_seq_no    = p_inv_tax.prem_seq_no
         AND iss_cd         = p_inv_tax.iss_cd
         AND tax_cd         = p_inv_tax.tax_cd;
   END update_tax_allocation;
   
    /*
    **  Created by   :  Carlo Rubenecia
    **  Date Created : 02-14-2017
    **  Reference By : GIUTS022 - CHANGE IN PAYMENT TERM
    */
   PROCEDURE get_due_date (
      p_policy_id   IN      gipi_invoice.policy_id%TYPE,
      p_payt_term   IN      VARCHAR2,
      p_prem_seq_no IN      GIPI_INVOICE.prem_seq_no%TYPE,
      p_due_date    OUT     gipi_installment.due_date%TYPE
   )
   IS
      v_prod_take_up        NUMBER;
      v_incept_date         gipi_polbasic.incept_date%TYPE;
      v_expiry_date         gipi_polbasic.expiry_date%TYPE;
      v_policy_days         NUMBER;
      v_no_of_days          giis_payterm.no_of_days%TYPE;
      v_no_payt_days        giis_payterm.no_payt_days%TYPE;
      v_annual_sw           giis_payterm.annual_sw%TYPE;
      var_no_of_payt        giis_payterm.no_of_payt%TYPE;
      v_exact_no_of_payment NUMBER;
      v_no_of_payment       NUMBER;
      v_count               NUMBER;
      var_inst_no           gipi_installment.inst_no%TYPE   := 0;
      v_orig_expiry_date    gipi_polbasic.expiry_date%TYPE;
      v_on_incept_tag       VARCHAR2(1);
      v_ctr                 NUMBER;
      v_variable            VARCHAR2 (1);
      v_exist               VARCHAR2 (1);
      v_test                VARCHAR2(200);     
   BEGIN
         FOR x IN (SELECT MAX (takeup_seq_no) takeup_seq
                     FROM gipi_invoice
                    WHERE policy_id = p_policy_id)
         LOOP
            v_ctr := x.takeup_seq;
         END LOOP;

         IF v_ctr > 1
         THEN
            v_variable := 'Y';
         END IF; 
    
        BEGIN
            SELECT GIACP.N('PROD_TAKE_UP') INTO v_prod_take_up
            FROM DUAL;
         END;
         
         FOR b IN (SELECT eff_date, endt_expiry_date, expiry_date, issue_date
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id)
         LOOP
            IF b.endt_expiry_date IS NULL
            THEN
               v_expiry_date        := b.expiry_date;
               v_incept_date        := b.eff_date;
               v_orig_expiry_date   := b.expiry_date;
            ELSE
               v_expiry_date        := b.endt_expiry_date;
               v_incept_date        := b.eff_date;
               v_orig_expiry_date   := b.endt_expiry_date;
            END IF;
            
            IF v_prod_take_up = 1 OR
                      (v_prod_take_up = 3 AND b.issue_date > v_incept_date) OR
                      (v_prod_take_up = 4 AND b.issue_date< v_incept_date) THEN
                      p_due_date:= b.issue_date;
            ELSIF v_prod_take_up = 2 OR
                      (v_prod_take_up = 3 AND b.issue_date <= v_incept_date) OR
                      (v_prod_take_up = 4 AND b.issue_date >= v_incept_date) THEN
                      p_due_date:= v_incept_date;
            END IF;

            EXIT;
         END LOOP;

         FOR rec IN (SELECT a.no_of_days, a.no_of_payt, a.annual_sw,
                            a.on_incept_tag, a.no_payt_days, a.payt_terms
                       FROM giis_payterm a
                      WHERE a.payt_terms= p_payt_term)
         LOOP
            v_no_of_days    := NVL (rec.no_of_days, 0);
            var_no_of_payt  := rec.no_of_payt;
            v_annual_sw     := rec.annual_sw;
            v_on_incept_tag := rec.on_incept_tag;
            v_no_payt_days  := rec.no_payt_days;

            FOR m IN (SELECT due_date, takeup_seq_no
                        FROM gipi_invoice
                       WHERE policy_id = p_policy_id
                         AND prem_seq_no = p_prem_seq_no)
            LOOP
               IF v_variable = 'Y'
               THEN
                  FOR y IN (SELECT takeup_seq_no, due_date
                              FROM gipi_invoice
                             WHERE policy_id = p_policy_id
                               AND takeup_seq_no = m.takeup_seq_no + 1)
                  LOOP
                     v_exist       := 'Y';
                     v_incept_date := m.due_date;
                     v_expiry_date := y.due_date;
                  END LOOP;

                  IF v_exist = 'N'
                  THEN
                     v_expiry_date := v_orig_expiry_date;
                  END IF;
               END IF;
            END LOOP;
            
         END LOOP;

         IF TRUNC(v_expiry_date) - TRUNC(v_incept_date) = 31
         THEN
            v_policy_days := 30;
         ELSE
            v_policy_days := TRUNC(v_expiry_date) - TRUNC(v_incept_date);
         END IF;

         IF NVL (v_annual_sw, 'N') = 'N'
         THEN
            IF v_no_payt_days IS NOT NULL
            THEN
               IF v_no_payt_days < v_policy_days - v_no_of_days
               THEN
                  IF v_no_payt_days < var_no_of_payt
                  THEN
                     v_no_of_payment := v_no_payt_days;
                  ELSE
                     v_no_of_payment := var_no_of_payt;
                  END IF;
               ELSE
                  IF v_policy_days - v_no_of_days < var_no_of_payt
                  THEN
                     v_no_of_payment := v_policy_days - v_no_of_days;
                  ELSE
                     v_no_of_payment :=
                        ROUND (((v_policy_days - v_no_of_days) * var_no_of_payt) / v_no_payt_days);
                  END IF;
               END IF;

               v_exact_no_of_payment := v_no_of_payment;
            ELSE
               IF v_policy_days - v_no_of_days < var_no_of_payt
               THEN
                  v_no_of_payment := v_policy_days - v_no_of_days;
               ELSE
                  v_no_of_payment := var_no_of_payt;
               END IF;
               
               v_exact_no_of_payment := v_no_of_payment;
               
            END IF;
         ELSE
            IF   TRUNC((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt > TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt)
            THEN
               v_no_of_payment :=  TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 3) * var_no_of_payt) + 1;
            ELSE
               IF (v_expiry_date - v_incept_date) >= 1095
               THEN
                  FOR x IN (SELECT COUNT (prem_seq_no) c_prem
                              FROM gipi_invoice
                             WHERE policy_id = p_policy_id)
                  LOOP
                     v_count := x.c_prem;

                     IF v_count > 1
                     THEN
                        v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days)  / 365,  3) * (var_no_of_payt / 3));
                     ELSE
                        v_no_of_payment := TRUNC(TRUNC( (v_policy_days - v_no_of_days) / 365, 3)  * (var_no_of_payt));
                     END IF;
                  END LOOP;
               ELSIF (v_expiry_date - v_incept_date) >= 730
               THEN
                  FOR x IN (SELECT COUNT (prem_seq_no) c_prem
                              FROM gipi_invoice
                             WHERE policy_id = p_policy_id)
                  LOOP
                     v_count := x.c_prem;

                     IF v_count > 1
                     THEN
                        v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365,  3)  * (var_no_of_payt / 2));
                     ELSE
                        v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365,  3) * (var_no_of_payt));
                     END IF;
                  END LOOP;
               ELSE
                  v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 3) * (var_no_of_payt));
               END IF;
            END IF;

            IF TRUNC ((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt < 1
            THEN
               v_exact_no_of_payment := 1;
            ELSE
               v_exact_no_of_payment := TRUNC((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt;
            END IF;
         END IF;

         IF v_no_of_payment < 1
         THEN
            v_no_of_payment := 1;
         END IF;

         IF v_on_incept_tag = 'Y'
         THEN
             p_due_date := v_incept_date;
         END IF;
         
         IF v_no_payt_days IS NOT NULL
         THEN
            IF (v_policy_days - v_no_of_days) > v_no_payt_days
            THEN
               p_due_date := p_due_date + ROUND (v_no_payt_days / v_no_of_payment);
            ELSE
               p_due_date := p_due_date + ROUND (  (v_policy_days - v_no_of_days) / v_exact_no_of_payment);
            END IF;
         ELSE
               p_due_date := p_due_date + ROUND (  (v_policy_days - v_no_of_days) / v_exact_no_of_payment);
         END IF;
   END;
END GIUTS022_PKG;
/
