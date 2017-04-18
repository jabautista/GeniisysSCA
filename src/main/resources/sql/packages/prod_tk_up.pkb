CREATE OR REPLACE PACKAGE BODY CPI.PROD_TK_UP
AS

    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.20.2013
   **  Reference By :this is use in GIACB000 - Batch Accounting Entry
   **  Description  : 
   */
   FUNCTION get_inv_amount (
      p_policy_id     NUMBER,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER 
   IS
      v_amt        NUMBER := 0;
      v_prem       NUMBER := 0;
      v_tax        NUMBER := 0;
      v_other      NUMBER := 0;
      v_notarial   NUMBER := 0;
   BEGIN
      FOR rec IN (SELECT prem_amt, tax_amt, other_charges, notarial_fee,
                         currency_rt
                    FROM gipi_invoice
                   WHERE policy_id = p_policy_id
                     AND iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no)
      LOOP
         BEGIN
            v_prem := NVL (rec.prem_amt * rec.currency_rt, 0);
            v_tax := NVL (rec.tax_amt * rec.currency_rt, 0);
            v_notarial := NVL (rec.notarial_fee * rec.currency_rt, 0);
            v_other := NVL (rec.other_charges * rec.currency_rt, 0);
            v_amt := v_prem + v_tax + v_other + v_amt + v_notarial;
         END;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION get_inv_amount_f (
      p_policy_id     NUMBER,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_amt    NUMBER := 0;
      v_prem   NUMBER := 0;
   BEGIN
      FOR rec IN (SELECT prem_amt, currency_rt
                    FROM gipi_invoice
                   WHERE policy_id = p_policy_id
                     AND iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no)
      LOOP
         BEGIN
            v_prem := NVL (rec.prem_amt * rec.currency_rt, 0);
            v_amt := v_prem + v_amt;
         END;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION get_intm_ri_amount (
      p_policy_id     NUMBER,                             --p_line_cd varchar2
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
      FOR rec IN
         (              /*SELECT SUM(B.RI_COMM_AMT*A.CURRENCY_RT) RI_COMM_AMT
                          FROM GIPI_ITEM A, GIPI_ITMPERIL B
                         WHERE A.POLICY_ID = B.POLICY_ID
                           AND A.ITEM_NO   = B.ITEM_NO
                           AND A.POLICY_ID = P_POLICY_ID
                      GROUP BY a.currency_rt*/
                                              --VJ 063007
          SELECT   SUM (b.ri_comm_amt * a.currency_rt) ri_comm_amt
              FROM gipi_invoice a, gipi_invperil b
             WHERE a.iss_cd = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.policy_id = p_policy_id
               AND b.iss_cd = p_iss_cd
               AND b.prem_seq_no = p_prem_seq_no
          GROUP BY a.currency_rt)
      LOOP
         BEGIN
            v_amt := NVL (rec.ri_comm_amt, 0) + v_amt;
         END;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION get_comm_input_vat (
      p_policy_id     NUMBER,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER := 0;
   BEGIN
        /* modified by judyann 02172006
      ** vat on comm should be based on the rate upon policy issuance

      FOR rec IN (SELECT SUM((B.RI_COMM_AMT*A.CURRENCY_RT)*NVL(D.INPUT_VAT_RATE,0)/100) INPUT_VAT
                    FROM GIRI_INPOLBAS C, GIPI_ITEM A, GIPI_ITMPERIL B, GIIS_REINSURER D
                   WHERE A.POLICY_ID = B.POLICY_ID
                     AND A.ITEM_NO   = B.ITEM_NO
                     AND C.POLICY_ID = A.POLICY_ID
                     AND C.RI_CD     = D.RI_CD
                     AND A.POLICY_ID = P_POLICY_ID
                GROUP BY a.currency_rt)
      LOOP
      */

      /*  FOR rec IN (SELECT NVL(SUM(D.COMM_VAT*B.CURRENCY_RT),0) INPUT_VAT
                      FROM GIRI_INPOLBAS C, GIPI_INVOICE B, --GIAC_AGING_RI_SOA_DETAILS D
                           (SELECT DISTINCT prem_seq_no, a180_ri_cd, comm_vat
                                                FROM GIAC_AGING_RI_SOA_DETAILS) D         -- judyann 03162006
                     WHERE C.POLICY_ID   = B.POLICY_ID
                       AND C.RI_CD       = D.A180_RI_CD
                       AND B.PREM_SEQ_NO = D.PREM_SEQ_NO
                       AND C.POLICY_ID   = P_POLICY_ID
                     GROUP BY c.ri_cd, b.currency_rt)*/
      FOR rec IN
         (SELECT   NVL (SUM (b.ri_comm_vat * b.currency_rt), 0) input_vat
              FROM giri_inpolbas c, gipi_invoice b
             WHERE c.policy_id = b.policy_id
               AND c.policy_id = p_policy_id
               AND b.iss_cd = p_iss_cd
               AND b.prem_seq_no = p_prem_seq_no
          GROUP BY b.currency_rt)                             -- lina 08252006
      LOOP
         BEGIN
            v_amt := NVL (rec.input_vat, 0) + v_amt;
         END;
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION check_if_exist (
      p_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      p_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      p_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd              giac_acct_entries.sl_cd%TYPE,
      p_v_branch_cd          GIAC_ACCTRANS.gibr_branch_cd%type,
      p_v_fund_cd            GIAC_ACCTRANS.gfun_fund_cd%type,
      p_v_tran_id            GIAC_ACCTRANS.tran_id%type
   )
      RETURN BOOLEAN
   IS
      v_dummy   VARCHAR2 (1);
   BEGIN
      SELECT 'x'
        INTO v_dummy
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_v_branch_cd
         AND gacc_gfun_fund_cd = p_v_fund_cd
         AND gacc_tran_id = p_v_tran_id
         AND gl_control_acct = p_gl_control_acct
         AND gl_acct_category = p_gl_acct_category
         AND gl_acct_id = p_gl_acct_id
         AND gl_sub_acct_1 = p_gl_sub_acct_1
         AND gl_sub_acct_2 = p_gl_sub_acct_2
         AND gl_sub_acct_3 = p_gl_sub_acct_3
         AND gl_sub_acct_4 = p_gl_sub_acct_4
         AND gl_sub_acct_5 = p_gl_sub_acct_5
         AND gl_sub_acct_6 = p_gl_sub_acct_6
         AND gl_sub_acct_7 = p_gl_sub_acct_7
         AND sl_cd = p_sl_cd
         AND ROWNUM = 1;

      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN FALSE;
   END;
END;
/


