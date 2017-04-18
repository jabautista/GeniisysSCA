DROP PROCEDURE CPI.GET_BOOKING_DATE;

CREATE OR REPLACE PROCEDURE CPI.get_booking_date (
   p_claim_id       gicl_claims.claim_id%TYPE,
   p_month      OUT VARCHAR2,
   p_year       OUT NUMBER)
IS
   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Converted procedure from GICLS024 - get_booking_date program unit
   */

   v_max_acct_date   VARCHAR2 (10);
   v_max_post_date   VARCHAR2 (10);
   v_loss_date       gicl_claims.loss_date%TYPE;
   v_clm_file_date   gicl_claims.clm_file_date%TYPE;
   v_book_param      giac_parameters.param_value_v%TYPE
                        := giacp.v ('RESERVE BOOKING');
   v_branch_code     giac_parameters.param_value_v%TYPE
                        := giacp.v ('BRANCH_CD');
BEGIN
   SELECT loss_date, clm_file_date
     INTO v_loss_date, v_clm_file_date
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   /* modified by mon
   ** date modified: 04/24/2002
   ** modification: added rownum <= 1 to optimize select statements */

   -- get booking month and date from giac_tran_mm
   -- which is not later than the maximum acct_date for OL transactions
   -- and which is not yet closed in giac_tran_mm

   /* modified by Pia, 08.15.02
** added branch_cd */
   -- retrieve maximum acct_date from giac_acctrans for outstanding loss
   -- transactions
   --   IF v_max_acct_date IS NULL
   --   THEN
   FOR max_acct_date
      IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
            FROM gicl_take_up_hist d, giac_acctrans e
           WHERE     d.acct_tran_id = e.tran_id
                 AND e.tran_class = 'OL'
                 AND e.tran_flag NOT IN ('D', 'P'))
   LOOP
      --variables.v_max_acct_date := max_acct_date.acct_date;
      v_max_acct_date := max_acct_date.acct_date;
   END LOOP;

   --      v_max_acct_date := variables.v_max_acct_date;
   --   END IF;

   -- retrieve maximum acct_date from giac_acctrans for outstanding loss
   -- transactions
   --   IF v_max_post_date IS NULL
   --   THEN
   FOR max_post_date
      IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
            FROM gicl_take_up_hist d, giac_acctrans e
           WHERE     d.acct_tran_id = e.tran_id
                 AND e.tran_class = 'OL'
                 AND e.tran_flag = 'P')
   LOOP
      v_max_post_date := max_post_date.acct_date;
   END LOOP;

   --      v_max_post_date := variables.v_max_post_date;
   --   END IF;
   IF v_max_post_date IS NOT NULL
   THEN
      FOR booking_date
         IN (  SELECT DECODE (a.tran_mm,
                              1, 'JANUARY',
                              2, 'FEBRUARY',
                              3, 'MARCH',
                              4, 'APRIL',
                              5, 'MAY',
                              6, 'JUNE',
                              7, 'JULY',
                              8, 'AUGUST',
                              9, 'SEPTEMBER',
                              10, 'OCTOBER',
                              11, 'NOVEMBER',
                              12, 'DECEMBER')
                         booking_month,
                      a.tran_yr booking_year,
                      a.tran_mm
                 FROM giac_tran_mm a
                WHERE     a.closed_tag = 'N'
                      AND a.branch_cd = v_branch_code
                      AND LAST_DAY (
                             TO_DATE (
                                   TO_CHAR (a.tran_mm)
                                || '-'
                                || TO_CHAR (a.tran_yr),
                                'MM-YYYY')) >=
                             TRUNC (
                                DECODE (v_book_param,
                                        'L', v_loss_date,
                                        v_clm_file_date),
                                'MONTH')
                      AND TO_DATE (
                                '01-'
                             || TO_CHAR (a.tran_mm)
                             || '-'
                             || TO_CHAR (a.tran_yr),
                             'DD-MM-YYYY') >=
                             NVL (
                                v_max_acct_date,
                                TO_DATE (
                                      '01-'
                                   || TO_CHAR (a.tran_mm)
                                   || '-'
                                   || TO_CHAR (a.tran_yr),
                                   'DD-MM-YYYY'))
                      AND TO_DATE (
                                '01-'
                             || TO_CHAR (a.tran_mm)
                             || '-'
                             || TO_CHAR (a.tran_yr),
                             'DD-MM-YYYY') > v_max_post_date
             ORDER BY a.tran_yr ASC, a.tran_mm ASC)
      LOOP
         p_month := booking_date.booking_month;
         p_year := booking_date.booking_year;
         EXIT;
      END LOOP;                                       -- end loop booking_date
   ELSE
      FOR booking_date
         IN (  SELECT DECODE (a.tran_mm,
                              1, 'JANUARY',
                              2, 'FEBRUARY',
                              3, 'MARCH',
                              4, 'APRIL',
                              5, 'MAY',
                              6, 'JUNE',
                              7, 'JULY',
                              8, 'AUGUST',
                              9, 'SEPTEMBER',
                              10, 'OCTOBER',
                              11, 'NOVEMBER',
                              12, 'DECEMBER')
                         booking_month,
                      a.tran_yr booking_year,
                      a.tran_mm
                 FROM giac_tran_mm a
                WHERE     a.closed_tag = 'N'
                      AND a.branch_cd = v_branch_code
                      AND LAST_DAY (
                             TO_DATE (
                                   TO_CHAR (a.tran_mm)
                                || '-'
                                || TO_CHAR (a.tran_yr),
                                'MM-YYYY')) >=
                             TRUNC (
                                DECODE (v_book_param,
                                        'L', v_loss_date,
                                        v_clm_file_date),
                                'MONTH')
                      AND TO_DATE (
                                '01-'
                             || TO_CHAR (a.tran_mm)
                             || '-'
                             || TO_CHAR (a.tran_yr),
                             'DD-MM-YYYY') >=
                             NVL (
                                v_max_acct_date,
                                TO_DATE (
                                      '01-'
                                   || TO_CHAR (a.tran_mm)
                                   || '-'
                                   || TO_CHAR (a.tran_yr),
                                   'DD-MM-YYYY'))
             ORDER BY a.tran_yr ASC, a.tran_mm ASC)
      LOOP
         p_month := booking_date.booking_month;
         p_year := booking_date.booking_year;
         EXIT;
      END LOOP;                                       -- end loop booking_date
   END IF;

   IF p_month IS NULL
   THEN
      RAISE_APPLICATION_ERROR (
         -20001,
         'Geniisys Exception#E#Booking month cannot be null.');
   END IF;

   IF p_year IS NULL
   THEN
      RAISE_APPLICATION_ERROR (
         -20001,
         'Geniisys Exception#E#Booking year cannot be null.');
   END IF;
END;                                                   -- end get_booking_date
/


