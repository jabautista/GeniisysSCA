DROP VIEW CPI.GIAC_DCB_BANK_COLLN_DTL;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_dcb_bank_colln_dtl (gacc_tran_id,
                                                          dcb_no,
                                                          or_date,
                                                          reference_no,
                                                          gibr_gfun_fund_cd,
                                                          gibr_branch_cd,
                                                          with_pdc,
                                                          or_flag,
                                                          cancel_date,
                                                          cancel_dcb_no,
                                                          due_dcb_no,
                                                          due_dcb_date,
                                                          pay_mode,
                                                          dcb_bank_cd,
                                                          dcb_bank_acct_cd,
                                                          amount
                                                         )
AS
   SELECT c.gacc_tran_id, a.dcb_no, a.or_date,
          a.or_pref_suf || '-' || a.or_no reference_no, a.gibr_gfun_fund_cd,
          a.gibr_branch_cd, a.with_pdc, a.or_flag, a.cancel_date,
          a.cancel_dcb_no, b.due_dcb_no, b.due_dcb_date, b.pay_mode,
          b.dcb_bank_cd, b.dcb_bank_acct_cd, b.amount
     FROM giac_order_of_payts a, giac_collection_dtl b, giac_dcb_bank_dep c
    WHERE a.gacc_tran_id = b.gacc_tran_id
      AND (   (a.dcb_no = c.dcb_no AND NVL (with_pdc, 'N') <> 'Y')
           OR (b.due_dcb_no = c.dcb_no AND NVL (with_pdc, 'N') = 'Y')
          )
      AND (   (    TO_CHAR (a.or_date, 'MM-DD-RRRR') =
                                            TO_CHAR (c.dcb_date, 'MM-DD-RRRR')
               AND NVL (with_pdc, 'N') <> 'Y'
              )
           OR (    TO_CHAR (b.due_dcb_date, 'MM-DD-RRRR') =
                                            TO_CHAR (c.dcb_date, 'MM-DD-RRRR')
               AND with_pdc = 'Y'
              )
          )
      AND (   (a.or_flag = 'P')
           OR (    a.or_flag = 'C'
               AND NVL (TO_CHAR (a.cancel_date, 'MM-DD-YYYY'), '-') <>
                                             TO_CHAR (a.or_date, 'MM-DD-YYYY')
              )
           OR (    a.or_flag = 'C'
               AND a.cancel_dcb_no <> c.dcb_no
               AND NVL (TO_CHAR (a.cancel_date, 'MM-DD-YYYY'), '-') =
                                             TO_CHAR (a.or_date, 'MM-DD-YYYY')
              )
          );


