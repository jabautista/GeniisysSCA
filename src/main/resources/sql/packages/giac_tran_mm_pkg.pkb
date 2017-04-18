CREATE OR REPLACE PACKAGE BODY CPI.giac_tran_mm_pkg
AS
   FUNCTION closed_transaction_month_year (
      p_fund_cd     giac_tran_mm.fund_cd%TYPE,
      p_branch_cd   giac_tran_mm.branch_cd%TYPE
   )
      RETURN giac_tran_mm_tab PIPELINED
   IS
      v_giac_tran_mm   giac_tran_mm_type;
   BEGIN
      FOR i IN (SELECT tran_mm, tran_yr, closed_tag, fund_cd, branch_cd, remarks
                  FROM giac_tran_mm
                 --WHERE branch_cd = 'HO' AND closed_tag = 'Y') --  commented out by Kris 01.30.2013: replaced with the following lines:
                 WHERE branch_cd = p_branch_cd 
                   AND fund_cd = p_fund_cd
                   AND (closed_tag = 'T' OR closed_tag = 'Y'))
      LOOP
	  	 v_giac_tran_mm.fund_cd := i.fund_cd;
		 v_giac_tran_mm.branch_cd := i.branch_cd;
         v_giac_tran_mm.tran_mm := i.tran_mm;
		 v_giac_tran_mm.tran_yr := i.tran_yr;
		 v_giac_tran_mm.closed_tag := i.closed_tag;
		 v_giac_tran_mm.remarks := i.remarks;
		 PIPE ROW(v_giac_tran_mm);
      END LOOP;
	  RETURN;
   END closed_transaction_month_year;
   
    FUNCTION get_booking_date_list(p_claim_id   gicl_claims.claim_id%TYPE)
       RETURN booked_list_tab PIPELINED
    IS
       v_booked         booked_list_type;
       v_loss_date      gicl_claims.loss_date%TYPE;
       v_clm_file_date  gicl_claims.clm_file_date%TYPE;
       v_max_acct_date  gicl_take_up_hist.acct_date%TYPE;
       v_max_post_date  gicl_take_up_hist.acct_date%TYPE;
    BEGIN
       SELECT a.loss_date, a.clm_file_date
         INTO v_loss_date, v_clm_file_date
         FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
        WHERE a.loss_cat_cd = b.loss_cat_cd
          AND a.line_cd = b.line_cd
          AND a.claim_id = p_claim_id
          AND c.clm_stat_cd = a.clm_stat_cd;

       FOR max_acct_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag NOT IN ('D', 'P'))
       LOOP
          v_max_acct_date := max_acct_date.acct_date;
       END LOOP;

       FOR max_post_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag = 'P')
       LOOP
          v_max_post_date := max_post_date.acct_date;
       END LOOP;

       FOR i IN (SELECT   DECODE (a.tran_mm,
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
                                  12, 'DECEMBER'
                                 ) booking_month,
                          a.tran_yr booking_year, a.tran_mm
                     FROM giac_tran_mm a
                    WHERE a.closed_tag = 'N'
                      AND a.branch_cd = giacp.v ('BRANCH_CD')
                      AND LAST_DAY (TO_DATE (   TO_CHAR (a.tran_mm)
                                             || '-'
                                             || TO_CHAR (a.tran_yr),
                                             'MM-YYYY'
                                            )
                                   ) >=
                             TRUNC (DECODE (giacp.v ('RESERVE BOOKING'),
                                            'L', TO_DATE (v_loss_date,
                                                          'DD-MON-RR'),
                                            TO_DATE (v_clm_file_date, 'DD-MON-RR')
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
                      AND TO_DATE (   '01-'
                                   || TO_CHAR (a.tran_mm)
                                   || '-'
                                   || TO_CHAR (a.tran_yr),
                                   'DD-MM-YYYY'
                                  ) > TO_DATE (v_max_post_date, 'DD-MM-YYYY')
                 ORDER BY a.tran_yr ASC, a.tran_mm ASC)
       LOOP
          v_booked.booking_year := i.booking_year;
          v_booked.booking_mth := i.booking_month;
          v_booked.booking_mth_num := TO_CHAR(TO_DATE('01-'||SUBSTR(i.BOOKING_MONTH,1, 3)|| i.BOOKING_YEAR, 'DD-MON-RRRR'), 'MM');
          PIPE ROW (v_booked);
       END LOOP;

       RETURN;
    END get_booking_date_list;
    
    FUNCTION check_booking_date (
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_booking_year  giac_tran_mm.tran_yr%TYPE,
        p_booking_month VARCHAR2
    )
       RETURN VARCHAR2
    IS
       v_exists          VARCHAR2(1) := 'N';
       v_loss_date       gicl_claims.loss_date%TYPE;
       v_clm_file_date   gicl_claims.clm_file_date%TYPE;
       v_iss_cd          gicl_claims.iss_cd%TYPE;
       v_max_acct_date   gicl_take_up_hist.acct_date%TYPE;
       v_max_post_date   gicl_take_up_hist.acct_date%TYPE;
    BEGIN
       SELECT a.loss_date, a.clm_file_date, iss_cd
         INTO v_loss_date, v_clm_file_date, v_iss_cd
         FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
        WHERE a.loss_cat_cd = b.loss_cat_cd
          AND a.line_cd = b.line_cd
          AND a.claim_id = p_claim_id
          AND c.clm_stat_cd = a.clm_stat_cd;

       FOR max_acct_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag NOT IN ('D', 'P'))
       LOOP
          v_max_acct_date := max_acct_date.acct_date;
       END LOOP;

       FOR max_post_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag = 'P')
       LOOP
          v_max_post_date := max_post_date.acct_date;
       END LOOP;

       FOR a IN (SELECT '1'
                   FROM giac_tran_mm a
                  WHERE a.closed_tag = 'N'
                    AND a.branch_cd = v_iss_cd
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
                                   'DECEMBER',12,
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
          v_exists := 'Y';
       END LOOP;

       RETURN v_exists;
    END check_booking_date;
	
	FUNCTION gicls024_get_booking_date_lov(
        p_claim_id              GICL_CLAIMS.claim_id%TYPE
    )
    RETURN gicls024_booking_date_tab PIPELINED AS
        v_book           gicls024_booking_date_type;
        v_loss_date      gicl_claims.loss_date%TYPE;
        v_clm_file_date  gicl_claims.clm_file_date%TYPE;
        v_max_acct_date  gicl_take_up_hist.acct_date%TYPE;
        v_max_post_date  gicl_take_up_hist.acct_date%TYPE;
    BEGIN
        SELECT a.loss_date, a.clm_file_date
         INTO v_loss_date, v_clm_file_date
         FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
        WHERE a.loss_cat_cd = b.loss_cat_cd
          AND a.line_cd = b.line_cd
          AND a.claim_id = p_claim_id
          AND c.clm_stat_cd = a.clm_stat_cd;

       FOR max_acct_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag NOT IN ('D', 'P'))
       LOOP
          v_max_acct_date := max_acct_date.acct_date;
       END LOOP;

       FOR max_post_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag = 'P')
       LOOP
          v_max_post_date := max_post_date.acct_date;
       END LOOP;
       
       IF v_max_post_date IS NULL THEN
            FOR i IN(SELECT DECODE(a.tran_mm, 1, 'JANUARY',     2, 'FEBRUARY', 
                                              3, 'MARCH',       4, 'APRIL',
                                              5, 'MAY',         6, 'JUNE',
                                              7, 'JULY',        8, 'AUGUST',
                                              9, 'SEPTEMBER',  10, 'OCTOBER',
                                             11, 'NOVEMBER',   12, 'DECEMBER') booking_month,
                            a.tran_yr booking_year, a.tran_mm
                       FROM GIAC_TRAN_MM a
                      WHERE a.closed_tag = 'N'
                        AND a.branch_cd = giacp.v('BRANCH_CD')
                        --AND LAST_DAY(TO_DATE(TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'MM-YYYY')) >= TRUNC(DECODE(giacp.v ('RESERVE BOOKING'),'L',to_date(v_loss_date,'dd-mon-rr'),to_date(v_clm_file_date,'dd-mon-rr')), 'MONTH')
                        -- andrew - 08.30.2012 - removed to_date function in v_loss_date and v_clm_file_date
                        AND LAST_DAY(TO_DATE(TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'MM-YYYY')) >= TRUNC(DECODE(giacp.v ('RESERVE BOOKING'),'L',v_loss_date,v_clm_file_date), 'MONTH')
                        AND TO_DATE('01-'||TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY') >= NVL(v_max_acct_date, TO_DATE('01-'||TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY'))
                        --AND UPPER(booking_month) LIKE UPPER(NVL(p_find_text, '%')) OR TO_CHAR(a.tran_yr) LIKE NVL(p_find_text, '%')
                      ORDER BY a.tran_yr ASC, a.tran_mm ASC)
            LOOP
                v_book.booking_mth := i.booking_month;
                v_book.booking_year := i.booking_year;
                PIPE ROW(v_book);
            END LOOP;
            RETURN;
       ELSE
            FOR i IN(SELECT DECODE(a.tran_mm, 1, 'JANUARY',     2, 'FEBRUARY',
                                              3, 'MARCH',       4, 'APRIL',
                                              5, 'MAY',         6, 'JUNE',
                                              7, 'JULY',        8, 'AUGUST',
                                              9, 'SEPTEMBER',  10, 'OCTOBER',
                                             11, 'NOVEMBER',   12,'DECEMBER') booking_month,
                            a.tran_yr booking_year, a.tran_mm
                       FROM GIAC_TRAN_MM a
                      WHERE a.closed_tag = 'N'
                        AND a.branch_cd = giacp.v('BRANCH_CD')    
                        --AND LAST_DAY(TO_DATE(TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'MM-YYYY')) >= TRUNC(DECODE(giacp.v ('RESERVE BOOKING'),'L',to_date(v_loss_date,'DD-MON-RR'),to_date(v_clm_file_date,'DD-MON-RR')), 'MONTH')
                        -- andrew - 08.30.2012 - removed to_date function in v_loss_date and v_clm_file_date
                        AND LAST_DAY(TO_DATE(TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'MM-YYYY')) >= TRUNC(DECODE(giacp.v ('RESERVE BOOKING'),'L',v_loss_date,v_clm_file_date), 'MONTH')
                        AND TO_DATE('01-'||TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY') >= NVL(v_max_acct_date, TO_DATE('01-'||TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY'))
                        AND TO_DATE('01-'||TO_CHAR(a.tran_mm)||'-'||TO_CHAR(a.tran_yr),'DD-MM-YYYY') > to_date(v_max_post_date, 'DD-MM-YYYY')
                      ORDER BY a.tran_yr ASC, a.tran_mm ASC)
            LOOP
                v_book.booking_mth := i.booking_month;
                v_book.booking_year := i.booking_year;
                PIPE ROW(v_book);
            END LOOP;
            RETURN;
       END IF;
    END;
    
    
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  April 16, 2013
  ** Reference by:  GIACS002 - Generate Disbursement Voucher
  ** Description:   Gets the value for closed tag of the given voucher date
  */
  FUNCTION get_closed_tag(
        p_fund_cd   IN  giac_tran_mm.fund_cd%TYPE,
        p_branch_cd IN  giac_tran_mm.branch_cd%TYPE,
        p_date      IN  giac_acctrans.tran_date%TYPE
  ) RETURN VARCHAR2
  IS
    v_closed_tag  giac_tran_mm.closed_tag%TYPE;
  BEGIN
    FOR a1 IN (SELECT closed_tag
                 FROM giac_tran_mm
                WHERE fund_cd = p_fund_cd
               	--AND branch_cd = giacp.v('BRANCH_CD')--commented by totel--10/27/2006
               	AND branch_cd = p_branch_cd      --replacement for the commented where clause.
                                                 --to consider the branch of the transaction in the validation of the date being entered. 
               	AND tran_yr = to_number(to_char(p_date, 'YYYY'))
               	AND tran_mm = to_number(to_char(p_date, 'MM'))) 
	LOOP
        v_closed_tag := a1.closed_tag;
        EXIT;
    END LOOP;          
       
    RETURN (v_closed_tag);
  END get_closed_tag;
   
END giac_tran_mm_pkg;
/


