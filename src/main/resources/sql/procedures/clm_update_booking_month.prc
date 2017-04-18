CREATE OR REPLACE PROCEDURE cpi.clm_update_booking_month (
   p_claim_id        gicl_clm_res_hist.claim_id%TYPE,
   p_hist_seq_no     gicl_clm_res_hist.hist_seq_no%TYPE,
   p_item_no         gicl_clm_res_hist.item_no%TYPE,
   p_peril_cd        gicl_clm_res_hist.peril_cd%TYPE,
   p_booking_month   gicl_clm_res_hist.booking_month%TYPE,
   p_booking_year    gicl_clm_res_hist.booking_year%TYPE,
   p_remarks         gicl_clm_res_hist.remarks%TYPE
)
IS
   v_check_closed    VARCHAR2 (1)                       := 'N';
   v_booking_month   VARCHAR2 (10);
   v_booking_year    NUMBER (4);
   v_loss_date       gicl_claims.loss_date%TYPE;
   v_clm_file_date   gicl_claims.clm_file_date%TYPE;
   v_max_acct_date   gicl_take_up_hist.acct_date%TYPE;
BEGIN
   SELECT loss_date, clm_file_date
     INTO v_loss_date, v_clm_file_date
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   FOR max_acct_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                           FROM gicl_take_up_hist d, giac_acctrans e
                          WHERE d.acct_tran_id = e.tran_id
                            AND e.tran_class = 'OL'
                            AND e.tran_flag NOT IN ('D', 'P'))
   LOOP
      v_max_acct_date := max_acct_date.acct_date;
   END LOOP;

   FOR a IN (SELECT 'Y'
               FROM giac_tran_mm a
              WHERE a.closed_tag = 'N'
                AND a.branch_cd = giacp.v ('BRANCH_CD')
                AND a.tran_yr = NVL (p_booking_year, a.tran_yr)
                AND a.tran_mm =
                       DECODE (p_booking_month,
                               'JANUARY', 1,
                               'FEBRUARY', 2,
                               'MARCH', 3,
                               'APRIL', 4,
                               'MAY', 5,
                               'JUNE', 6,
                               'JULY', 7,
                               'AUGUST', 8,
                               'SEPTEMBER', 9,
                               'OCTOBER', 10,
                               'NOVEMBER', 11,
                               'DECEMBER', 12,
                               13
                              )
                AND TO_DATE (   '01-'
                             || TO_CHAR (a.tran_mm)
                             || '-'
                             || TO_CHAR (a.tran_yr),
                             'DD-MM-YYYY'
                            ) >=
                       TRUNC (DECODE (giacp.v ('RESERVE BOOKING'),
                                      'L', v_loss_date,
                                      v_clm_file_date
                                     ),
                              'MONTH'
                             )
                AND TO_DATE (   '01-'
                             || TO_CHAR (a.tran_mm)
                             || '-'
                             || TO_CHAR (a.tran_yr),
                             'DD-MM-YYYY'
                            ) >=
                       NVL (v_max_acct_date,
                            TO_DATE (   '01-'
                                     || TO_CHAR (a.tran_mm)
                                     || '-'
                                     || TO_CHAR (a.tran_yr),
                                     'DD-MM-YYYY'
                                    )
                           )
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_acctrans c
                        WHERE c.tran_month = a.tran_mm
                          AND c.tran_year = a.tran_yr
                          AND TRUNC (c.tran_date) =
                                                TRUNC (LAST_DAY (c.tran_date))
                          AND tran_flag = 'P'
                          AND tran_class = 'OL'))
   LOOP
      v_check_closed := 'Y';
   END LOOP;

   SELECT booking_mth, booking_year
     INTO v_booking_month, v_booking_year
     FROM TABLE (giac_tran_mm_pkg.gicls024_get_booking_date_lov (p_claim_id))
    WHERE ROWNUM = 1;

   UPDATE gicl_clm_res_hist
      SET booking_month =
                DECODE (v_check_closed,
                        'Y', p_booking_month,
                        v_booking_month
                       ),
          booking_year =
                  DECODE (v_check_closed,
                          'Y', p_booking_year,
                          v_booking_year
                         ),
          remarks = p_remarks
    WHERE claim_id = p_claim_id
      AND hist_seq_no = p_hist_seq_no
      AND item_no = p_item_no
      AND peril_cd = p_peril_cd;
END;
/