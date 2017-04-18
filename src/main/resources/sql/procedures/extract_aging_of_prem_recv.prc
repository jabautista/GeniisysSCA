DROP PROCEDURE CPI.EXTRACT_AGING_OF_PREM_RECV;

CREATE OR REPLACE PROCEDURE CPI.Extract_Aging_Of_Prem_Recv
  (p_branch_cd      VARCHAR2,
   p_intm_no        NUMBER,
   p_intm_type      VARCHAR2,
   p_as_off_date    DATE,
   p_special_pol    VARCHAR2,
   p_row_counter    OUT NUMBER,
   p_module_id VARCHAR2 --RCD 05/21/2012
  )
AS
  v_row_counter         NUMBER := 0;
   v_assd_name			GIAC_AGING_PREM_REP_EXT.assd_name%TYPE;
   v_intm_name          GIAC_AGING_PREM_REP_EXT.intm_name%TYPE;
   v_age                GIAC_AGING_PARAMETERS.max_no_days%TYPE;
   v_inst_no            GIAC_AGING_PREM_REP_EXT.inst_no%TYPE;
   v_iss_cd             GIAC_AGING_PREM_REP_EXT.iss_cd%TYPE;
   v_prem_seq_no        GIAC_AGING_PREM_REP_EXT.prem_seq_no%TYPE;
   v_aging_id           GIAC_AGING_PREM_REP_EXT.aging_id%TYPE;
   v_balance_amt_due    GIAC_AGING_PREM_REP_EXT.balance_amt_due%TYPE := 0;
   v_collection_amt     GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE := 0;
   v_fund_cd            GIAC_PARAMETERS.param_value_v%TYPE;
   v_intm_type          GIIS_INTERMEDIARY.intm_type%TYPE;
   v_column_no          GIAC_AGING_PREM_REP_EXT.column_no%TYPE;
   v_column_title       GIAC_AGING_PREM_REP_EXT.column_title%TYPE;
   v_prem_bal_due       GIAC_AGING_PREM_REP_EXT.prem_bal_due%TYPE := 0;
   v_tax_bal_due        GIAC_AGING_PREM_REP_EXT.tax_bal_due%TYPE := 0;
   v_inv_no             GIAC_AGING_PREM_REP_EXT.ref_inv_no%TYPE;
   v_last_update        GIAC_AGING_PREM_REP_EXT.last_update%TYPE;
   al_id                NUMBER;
/*TEMPORARY SOLUTION*/
   V_TEMP_COL  NUMBER;
/*FOR THE FILTERING OF DUE AND NOT DUE INSTALLMENTS*/
   V_DUE_TAG            GIAC_AGING_PREM_REP_EXT.DUE_TAG%TYPE;
/*FOR THE PARENT_INTM_NO AND THE LIC_TAG */
   v_parent_intm_no        GIIS_INTERMEDIARY.parent_intm_no%TYPE;
   v_lic_tag            GIIS_INTERMEDIARY.lic_tag%TYPE;
   var_parent_intm_no   GIIS_INTERMEDIARY.parent_intm_no%TYPE;
   var_lic_tag          GIIS_INTERMEDIARY.lic_tag%TYPE;
   var_intm_no            GIIS_INTERMEDIARY.intm_no%TYPE;
   v_assd_no             NUMBER;
   v_special_pol        VARCHAR2(1);
   v_as_off_date        GIAC_AGING_PREM_REP_EXT.as_of_date%TYPE;
   v_policy_id            GIPI_POLBASIC.policy_id%TYPE;
   v_afterdate_coll     GIAC_AGING_PREM_REP_EXT.afterdate_coll%TYPE    := 0;
   v_afterdate_prem     GIAC_AGING_PREM_REP_EXT.afterdate_prem%TYPE    := 0;
   v_afterdate_tax      GIAC_AGING_PREM_REP_EXT.afterdate_tax%TYPE;
   iss_cd_var           GIPI_INVOICE.iss_cd%TYPE;
   prem_seq_var         GIPI_INVOICE.prem_seq_no%TYPE;
   v_intm_no            GIIS_INTERMEDIARY.intm_no%TYPE;

  TYPE policy_id_tab            IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
  TYPE policy_no_tab            IS TABLE OF VARCHAR2(50);
  TYPE assd_no_tab              IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
  TYPE iss_cd_tab               IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
  TYPE line_cd_tab              IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
  TYPE subline_cd_tab           IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
  TYPE issue_yy_tab             IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
  TYPE renew_no                 IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
  TYPE pol_seq_no               IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
  TYPE line_name_tab            IS TABLE OF GIIS_LINE.line_name%TYPE;
  TYPE acct_ent_date_tab        IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
  TYPE ref_pol_no_tab           IS TABLE OF GIPI_POLBASIC.ref_pol_no%TYPE;
  TYPE incept_date_tab          IS TABLE OF GIPI_POLBASIC.incept_date%TYPE;
  TYPE issue_date_tab           IS TABLE OF GIPI_POLBASIC.issue_date%TYPE;
  TYPE spld_date_tab            IS TABLE OF GIPI_POLBASIC.spld_date%TYPE;
  TYPE pol_flag_tab             IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
  TYPE eff_date_tab             IS TABLE OF GIPI_POLBASIC.eff_date%TYPE;
  TYPE expiry_date_tab          IS TABLE OF GIPI_POLBASIC.expiry_date%TYPE;
  TYPE assd_name_tab            IS TABLE OF GIIS_ASSURED.assd_name%TYPE;
  TYPE reg_policy_sw_tab        IS TABLE OF GIPI_POLBASIC.reg_policy_sw%TYPE;
  TYPE endt_type_tab            IS TABLE OF GIPI_POLBASIC.endt_type%TYPE;

  vv_policy_id                  policy_id_tab;
  vv_policy_no                  policy_no_tab;
  vv_assd_no                    assd_no_tab;
  vv_iss_cd                     iss_cd_tab;
  vv_line_cd                    line_cd_tab;
  vv_subline_cd                 subline_cd_tab;
  vv_issue_yy                   issue_yy_tab;
  vv_renew_no                   renew_no;
  vv_pol_seq_no                 pol_seq_no;
  vv_line_name                  line_name_tab;
  vv_acct_ent_date              acct_ent_date_tab;
  vv_ref_pol_no                 ref_pol_no_tab;
  vv_incept_date                incept_date_tab;
  vv_issue_date                 issue_date_tab;
  vv_spld_date                  spld_date_tab;
  vv_pol_flag                   pol_flag_tab;
  vv_eff_date                   eff_date_tab;
  vv_expiry_date                expiry_date_tab;
  vv_policy_id2                 policy_id_tab;
  vv_assd_no2                   assd_no_tab;
  vv_assd_name                  assd_name_tab;
  vv_reg_policy_sw              reg_policy_sw_tab;
  vv_endt_type                  endt_type_tab;

/*
** Created By:   Jerome (based on extract_soa_rep)
** Date Created: 021005
** Description:     This is the extract procedure for the aging of premium receivables. This was done for
**               optimization purpose.
*/

BEGIN

  /*Delete records in extract table for the current user*/
  DELETE FROM GIAC_AGING_PREM_REP_EXT
   WHERE user_id = USER;

  /*Get fund_cd */
  FOR c IN (SELECT param_value_v
              FROM GIAC_PARAMETERS
             WHERE param_name = 'FUND_CD')
  LOOP
    v_fund_cd := c.param_value_v;
    EXIT;
  END LOOP;

  /*Get the records*/
  SELECT policy_id,
         policy_no,
         assd_no,
         iss_cd,
         line_cd,
         subline_cd,
         issue_yy,
         renew_no,
         pol_seq_no,
         line_name,
         acct_ent_date,
         ref_pol_no,
         incept_DATE,
         issue_date,
         spld_date,
         pol_flag,
         eff_date,
         expiry_date,
         policy_id2,
         assd_no2,
         assd_name,
         reg_policy_sw,
         endt_type
  BULK COLLECT
    INTO vv_policy_id,
         vv_policy_no,
         vv_assd_no,
         vv_iss_cd,
         vv_line_cd,
         vv_subline_cd,
         vv_issue_yy,
         vv_renew_no,
         vv_pol_seq_no,
         vv_line_name,
         vv_acct_ent_date,
         vv_ref_pol_no,
         vv_incept_date,
         vv_issue_date,
         vv_spld_date,
         vv_pol_flag,
         vv_eff_date,
         vv_expiry_date,
         vv_policy_id2,
         vv_assd_no2,
         vv_assd_name,
         vv_reg_policy_sw,
         vv_endt_type
    FROM (SELECT *
            FROM giac_soa_rep_v
           WHERE TRUNC(acct_ent_date) <= p_as_off_date)
   WHERE 1=1
     AND reg_policy_sw = DECODE(p_special_pol, 'Y', reg_policy_sw,'Y')
     AND NVL(endt_type, 'A') = 'A'
     AND iss_cd = NVL(p_branch_cd, iss_cd)
     AND iss_cd IN (DECODE (check_user_per_iss_cd_acctg (NULL, iss_cd, p_module_id), 1, iss_cd, NULL)) ----RCD 05/21/2012
     AND EXISTS (SELECT 'X'
                   FROM GIPI_COMM_INVOICE aa,
                        GIIS_INTERMEDIARY bb
                  WHERE aa.policy_id = policy_id2
                    AND aa.intrmdry_intm_no = bb.intm_no
                    AND intrmdry_intm_no = NVL(p_intm_no, intrmdry_intm_no)
                    AND intm_type = NVL(p_intm_type, intm_type)
                    AND ROWNUM=1);

  IF SQL% FOUND THEN
  FOR cur1 IN vv_policy_id.FIRST..vv_policy_id.LAST
  LOOP

    IF ((vv_spld_date(cur1) IS NULL) OR
        (TRUNC(vv_spld_date(cur1)) > p_as_off_date AND vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '5')
         OR (vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '1')) --to include policies that is only tagged for spoilage has spoiled date but pol flag is still 1*/
       THEN

      FOR cur2a IN (SELECT iss_cd, prem_seq_no, ref_inv_no
                      FROM GIPI_INVOICE
                     WHERE policy_id = vv_policy_id(cur1))
      LOOP
        iss_cd_var := cur2a.iss_cd;
        prem_seq_var := cur2a.prem_seq_no;
        v_inv_no := cur2a.ref_inv_no;

        FOR c IN (SELECT intm_name, intm_type, a.parent_intm_no, lic_tag, b.intrmdry_intm_no intm_no
                    FROM GIIS_INTERMEDIARY a, GIPI_COMM_INVOICE b
                   WHERE a.intm_no = b.intrmdry_intm_no
                     AND b.policy_id = vv_policy_id2(cur1))
        LOOP
          v_intm_name      := c.intm_name;
          v_intm_type      := c.intm_type;
          v_lic_tag        := c.lic_tag;
          v_parent_intm_no := c.parent_intm_no;
          v_intm_no        := c.intm_no;

          --This part will get the parent_intm of the intermediary
          IF v_lic_tag  = 'Y' THEN
            v_parent_intm_no := c.intm_no;
            v_lic_tag        := 'Y';
          ELSIF v_lic_tag  = 'N' THEN
            IF v_parent_intm_no IS NULL THEN
              v_parent_intm_no := c.intm_no;
              v_lic_tag := 'N';
            ELSE  --check for the nearest licensed parent intm no
              var_lic_tag := v_lic_tag;
              WHILE var_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL LOOP
                BEGIN
                  SELECT intm_no,
                         parent_intm_no,
                         lic_tag
                    INTO var_intm_no,
                         var_parent_intm_no,
                         var_lic_tag
                    FROM GIIS_INTERMEDIARY
                   WHERE intm_no = v_parent_intm_no;

                  v_parent_intm_no := var_parent_intm_no;

                  IF var_lic_tag = 'Y' THEN
                    v_parent_intm_no := var_intm_no;
                    EXIT;
                  ELSE
                    NULL;
                  END IF;

                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_parent_intm_no := var_intm_no;
                    EXIT;
                END;
              END LOOP;
            END IF;
          END IF;
          EXIT;
        END LOOP;

        /* Loops in the GIPI_INSTALLMENT to get the due_date, inst_no and prem_amt */

        FOR cur3 IN (SELECT due_date, inst_no, prem_amt
                       FROM GIPI_INSTALLMENT
                      WHERE iss_cd = iss_cd_var
                        AND prem_seq_no = prem_seq_var
                      ORDER BY inst_no)
        LOOP
          v_age         := ((p_as_off_date) - TRUNC(cur3.due_date));
          v_inst_no     := cur3.inst_no;
          v_iss_cd      := iss_cd_var;
          v_prem_seq_no := prem_seq_var;
          v_aging_id    := 0;

          /* Get the corresponding rep_col_no */
          IF (p_as_off_date - cur3.due_date) <= 0 THEN
            --get aging_id and rep_col_no when not overdue
            FOR a IN (SELECT aging_id, rep_col_no
                        FROM GIAC_AGING_PARAMETERS
                       WHERE (ABS(v_age) BETWEEN min_no_days AND max_no_days)
                         AND gibr_branch_cd = v_iss_cd
                         AND over_due_tag = 'N')
            LOOP
              v_aging_id  := a.aging_id;
              v_column_no := a.rep_col_no;
              v_due_tag   := 'N';
              EXIT;
            END LOOP;
          ELSIF(p_as_off_date - cur3.due_date) > 0 THEN -- overdue records
            --get aging_id and rep_col_no when overdue
            FOR b IN (SELECT aging_id, rep_col_no
                        FROM GIAC_AGING_PARAMETERS
                       WHERE (v_age BETWEEN min_no_days AND max_no_days)
                         AND gibr_branch_cd = v_iss_cd
                         AND over_due_tag = 'Y')
            LOOP
              v_aging_id  := b.aging_id;
              v_column_no := b.rep_col_no;
              v_due_tag   := 'Y';
              EXIT;
            END LOOP;
          END IF;

          /*THIS IS A TEMPORARY SOLUTION TO THE COL_NO PROBLEM RESULTING TO ERRONEOUS COL_TITLE*/
          BEGIN
            SELECT MAX(col_no)
              INTO v_temp_col
              FROM GIAC_SOA_TITLE
             WHERE rep_cd = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20201,'NO DATA FOUND IN GIAC_SOA_TITLE.');
          END;

          IF v_column_no > v_temp_col THEN
            v_column_no := v_temp_col;
          END IF;

          /* get column title */
          FOR c IN (SELECT col_title
                      FROM GIAC_SOA_TITLE
                     WHERE col_no = v_column_no
                       AND rep_cd = 1)--to identify title bet RI soa and soa
          LOOP
            v_column_title := c.col_title;
            EXIT;
          END LOOP;

          /*
          For records that are NOT spoiled, the v_balance_amt_due, v_prem_bal_due and
          v_tax_bal_due will be computed again using the GIAC_AGING_SOA_DETAILS table.
          */
          --to handle policies w/c are tagged for spoilage only so pol_flag is still 1
          IF vv_spld_date(cur1) IS NULL OR (vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '1') THEN
            FOR s1 IN (SELECT balance_amt_due, prem_balance_due, tax_balance_due
                         FROM GIAC_AGING_SOA_DETAILS
                        WHERE iss_cd = iss_cd_var
                          AND prem_seq_no = prem_seq_var
                          AND inst_no = cur3.inst_no)
            LOOP
              v_balance_amt_due := s1.balance_amt_due;
              v_prem_bal_due    := s1.prem_balance_due;
              v_tax_bal_due     := s1.tax_balance_due;
              EXIT;
            END LOOP;

            /* get payments to add back to balance */
            v_afterdate_coll := 0;
            v_afterdate_prem := 0;
            v_afterdate_tax  := 0;

            FOR c1 IN (SELECT SUM(a.collection_amt) collection_amt,
                              SUM(a.premium_amt) prem_amt,
                              SUM(a.tax_amt) tax_amt
                         FROM GIAC_DIRECT_PREM_COLLNS a,
                              GIAC_ACCTRANS b
                        WHERE a.gacc_tran_id = b.tran_id
                          AND a.b140_iss_cd = iss_cd_var
                          AND a.b140_prem_seq_no = prem_seq_var
                          AND a.inst_no = cur3.inst_no
                          AND b.tran_flag != 'D'
                          AND b.tran_id >= 0
                          AND NOT EXISTS (SELECT 'X'
                                            FROM GIAC_REVERSALS gr,
                                                 GIAC_ACCTRANS  ga
                                           WHERE gr.reversing_tran_id = ga.tran_id
                                             AND ga.tran_flag        !='D'
                                             AND gr.gacc_tran_id = a.gacc_tran_id)
                          --AND TRUNC(b.tran_date) > p_as_off_date
                          AND (TRUNC(b.posting_date) > p_as_off_date OR
                               b.posting_date IS NULL)
                        GROUP BY a.b140_iss_cd, a.b140_prem_seq_no, a.inst_no)
            LOOP
              v_balance_amt_due := v_balance_amt_due + c1.collection_amt;
              v_prem_bal_due    := v_prem_bal_due + c1.prem_amt;
              v_tax_bal_due     := v_tax_bal_due + c1.tax_amt;
              v_afterdate_coll    := c1.collection_amt;
              v_afterdate_prem    := c1.prem_amt;
              v_afterdate_tax   := c1.tax_amt;
              EXIT;
            END LOOP;
          /*
          FOR records that are spoiled, THE v_balance_amt_due, v_prem_bal_due AND
          v_tax_bal_due will be computed again using THE GIPI_INVOICE TABLE INSTEAD OF
          THE GIAC_AGING_SOA_DETAILS TABLE.
          */
          --to handle policies w/c are tagged for spoilage only so pol_flag is still 1
          ELSIF (vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '5' AND vv_spld_date(cur1) > p_as_off_date) THEN
            FOR s2 IN (SELECT (NVL(prem_amt,0) + NVL(other_charges,0) + NVL(notarial_fee,0) +
                               NVL(tax_amt,0)) * NVL(currency_rt,1) balance,
                              (NVL(prem_amt,0) * NVL(currency_rt,1)) prem_amt,
                              (NVL(tax_amt,0) * NVL(currency_rt,1)) tax_amt
                         FROM GIPI_INVOICE
                        WHERE policy_id = vv_policy_id(cur1)
                          AND iss_cd = iss_cd_var
                          AND prem_seq_no = prem_seq_var)
            LOOP
              v_balance_amt_due := s2.balance;
              v_prem_bal_due    := s2.prem_amt;
              v_tax_bal_due     := s2.tax_amt;
              EXIT;
            END LOOP;

            -- get payments made and deduct it to the amount due
            FOR c2 IN (SELECT SUM(a.collection_amt) collection_amt,
                              SUM(a.premium_amt) prem_amt,
                              SUM(a.tax_amt) tax_amt
                         FROM GIAC_DIRECT_PREM_COLLNS a,
                              GIAC_ACCTRANS b
                        WHERE a.gacc_tran_id = b.tran_id
                          AND a.b140_iss_cd = iss_cd_var
                          AND a.b140_prem_seq_no = prem_seq_var
                          AND a.inst_no = cur3.inst_no
                          AND b.tran_flag != 'D'
                          AND b.tran_id >= 0
                          AND NOT EXISTS (SELECT 'X'
                                            FROM GIAC_REVERSALS gr,
                                                 GIAC_ACCTRANS  ga
                                           WHERE gr.reversing_tran_id = ga.tran_id
                                             AND ga.tran_flag        !='D'
                                             AND gr.gacc_tran_id = a.gacc_tran_id)
                                             AND TRUNC(b.posting_date) <= p_as_off_date
                                             --AND TRUNC(b.tran_date) <= p_as_off_date
                                           GROUP BY a.b140_iss_cd, a.b140_prem_seq_no, a.inst_no)
            LOOP
              v_balance_amt_due := v_balance_amt_due - c2.collection_amt;
              v_prem_bal_due    := v_prem_bal_due - c2.prem_amt;
              v_tax_bal_due     := v_tax_bal_due - c2.tax_amt;
              EXIT;
            END LOOP;
          END IF;

          v_row_counter := v_row_counter + 1;

          INSERT INTO GIAC_AGING_PREM_REP_EXT
                   (fund_cd,
                    branch_cd,
                    intm_no,
                    intm_name,
                    intm_type,
                    assd_no,
                    assd_name,
                    policy_no,
                    iss_cd,
                    prem_seq_no,
                    inst_no,
                    due_date,
                    aging_id,
                    column_no,
                    column_title,
                    balance_amt_due,
                    prem_bal_due,
                    tax_bal_due,
                    ref_pol_no,
                    ref_inv_no,
                    user_id,
                    last_update,
                    no_of_days,
                    due_tag,
                    lic_tag,
                    parent_intm_no,
                    spld_date,
                    incept_date,
                    expiry_date,
                    as_of_date,
                    afterdate_coll,
                    afterdate_prem,
                    afterdate_tax,
                    line_cd
                   )
                   VALUES
                   (NVL(v_fund_cd,'NULL'),
                    NVL(vv_iss_cd(cur1),'NULL'),
                    NVL(v_intm_no,0),
                    NVL(v_intm_name,'NULL'),
                    NVL(v_intm_type,'NULL'),
                    NVL(vv_assd_no2(cur1),0),
                    NVL(vv_assd_name(cur1),'NULL'),
                    NVL(vv_policy_no(cur1),'NULL'),
                    NVL(iss_cd_var,'NULL'),
                    NVL(prem_seq_var,0),
                    NVL(v_inst_no,0),
                    cur3.due_date,
                    NVL(v_aging_id,0),
                    NVL(v_column_no,0),
                    NVL(v_column_title,'NULL TITLE'),
                    NVL(v_balance_amt_due,0),
                    NVL(v_prem_bal_due,0),
                    NVL(v_tax_bal_due,0),
                    vv_ref_pol_no(cur1),
                    v_inv_no,
                      USER,
                    SYSDATE,
                    v_age,
                    v_due_tag,
                    v_lic_tag,
                    v_parent_intm_no,
                    vv_spld_date(cur1),
                    vv_incept_date(cur1),
                    vv_expiry_date(cur1),
                    p_as_off_date,
                    NVL(v_afterdate_coll,0),
                    NVL(v_afterdate_prem,0),
                    NVL(v_afterdate_tax,0),
                    vv_line_cd(cur1)
                   );
        END LOOP;
      END LOOP;
    END IF;
  END LOOP;
  END IF;
  p_row_counter := v_row_counter;
  COMMIT;
END Extract_Aging_Of_Prem_Recv;
/


