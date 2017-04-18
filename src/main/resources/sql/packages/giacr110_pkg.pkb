CREATE OR REPLACE PACKAGE BODY CPI.giacr110_pkg
AS
  
   FUNCTION get_giacr110_records (
      p_date1              VARCHAR2,
      p_date2              VARCHAR2,
      p_exclude_tag        VARCHAR2,
      p_module_id          VARCHAR2,
      p_payee              VARCHAR2,
      p_post_tran_toggle   VARCHAR2,
      p_tax_cd             VARCHAR2, --Added by Jerome 09.26.2016 SR 5671
      p_user_id            VARCHAR2
   )
      RETURN giacr110_record_tab PIPELINED
   IS
      v_list        giacr110_record_type;
      v_date1       DATE                 := TO_DATE (p_date1, 'MM/DD/RRRR');
      v_date2       DATE                 := TO_DATE (p_date2, 'MM/DD/RRRR');
      v_not_exist   BOOLEAN              := TRUE;
   BEGIN
      v_list.company := giisp.v ('COMPANY_NAME');
      v_list.address := giisp.v ('COMPANY_ADDRESS');
      v_list.cf_intm := giacp.v ('INTM_CLASS_CD');
      v_list.cf_emp := giacp.v ('EMP_CLASS_CD');
      v_list.cf_date := 'From ' || TO_CHAR (v_date1, 'fmMonth DD,YYYY') || ' to ' || TO_CHAR (v_date2, 'fmMonth DD,YYYY');

      FOR i IN
         (SELECT   a.payee_class_cd, INITCAP (d.class_desc) class_desc,
                   a.payee_cd,
                      RTRIM (b.payee_last_name)
                   || DECODE (b.payee_first_name,
                              '', DECODE (b.payee_middle_name, '', NULL, ','),
                              ','
                             )
                   || RTRIM (b.payee_first_name)
                   || ' '
                   || b.payee_middle_name NAME,
                   SUM (a.income_amt) income, SUM (a.wholding_tax_amt) wtax,
                   e.percent_rate, e.whtax_desc, b.tin, e.bir_tax_cd
              FROM giac_taxes_wheld a,
                   giis_payees b,
                   giac_acctrans c,
                   giis_payee_class d,
                   giac_wholding_taxes e
             WHERE a.gacc_tran_id NOT IN (
                      SELECT e.gacc_tran_id
                        FROM giac_reversals e, giac_acctrans f
                       WHERE e.reversing_tran_id = f.tran_id
                         AND f.tran_flag <> 'D')
               AND a.payee_class_cd = b.payee_class_cd
               AND a.payee_cd = b.payee_no
               AND b.payee_class_cd = d.payee_class_cd
               AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
               AND a.gacc_tran_id = c.tran_id
               AND c.tran_flag <> 'D'
               AND (   (    TRUNC (c.tran_date) BETWEEN v_date1 AND v_date2
                        AND p_post_tran_toggle = 'T'
                       )
                    OR (    TRUNC (c.posting_date) BETWEEN v_date1 AND v_date2
                        AND p_post_tran_toggle = 'P'
                       )
                   )
               AND e.whtax_id = a.gwtx_whtax_id
               AND e.whtax_code = NVL(p_tax_cd, e.whtax_code) -- Added by Jerome 09.26.2016 SR 5671
               AND (   (    p_post_tran_toggle = 'T'
                        AND c.tran_flag <> NVL (p_exclude_tag, ' ')
                       )
                    OR p_post_tran_toggle = 'P'
                   )
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                c.gibr_branch_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1
          GROUP BY a.payee_class_cd,
                   d.class_desc,
                   a.payee_cd,
                      RTRIM (b.payee_last_name)
                   || DECODE (b.payee_first_name,
                              '', DECODE (b.payee_middle_name, '', NULL, ','),
                              ','
                             )
                   || RTRIM (b.payee_first_name)
                   || ' '
                   || b.payee_middle_name,
                   e.percent_rate,
                   e.whtax_desc,
                   b.tin,
                   e.bir_tax_cd
          ORDER BY class_desc,
                      RTRIM (b.payee_last_name)
                   || DECODE (b.payee_first_name,
                              '', DECODE (b.payee_middle_name, '', NULL, ','),
                              ','
                             )
                   || RTRIM (b.payee_first_name)
                   || ' '
                   || b.payee_middle_name)
      LOOP
         v_not_exist := FALSE;
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.class_desc := i.class_desc;
         v_list.payee_cd := i.payee_cd;
         v_list.payee_name := i.NAME;
         v_list.income_amt := i.income;
         v_list.wholding_tax_amt := i.wtax;
         v_list.percent_rate := i.percent_rate;
         v_list.whtax_desc := i.whtax_desc;
         v_list.tin := i.tin;
         v_list.bir_tax_cd := i.bir_tax_cd;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacr110_records;
END;
/


