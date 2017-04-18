CREATE OR REPLACE PACKAGE BODY CPI.GIARDC01_PKG
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.19.2013
   **  Reference By : GIARDC01 - Daily Collection Report
   **  Description  :
   */
   FUNCTION get_daily_collection_record (
      p_dsp_date   DATE,
      p_dcb_no     giac_order_of_payts.dcb_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN daily_collection_tab PIPELINED
   IS
      v_rec   daily_collection_type;
   BEGIN
      FOR i IN
         (SELECT b.dcb_no,
                 b.dcb_year,
                 b.fund_cd,
                 b.branch_cd,
                 b.tran_date,
                 b.dcb_flag,
                 b.remarks,
                 b.user_id,
                 a.cashier_cd, 
                 a.print_name
            FROM giac_dcb_users a,
                 giac_colln_batch b
           WHERE TRUNC (b.tran_date) = NVL (p_dsp_date, TRUNC (b.tran_date))
             AND b.dcb_no = NVL (p_dcb_no, b.dcb_no)
             --AND a.dcb_user_id = b.user_id --Commented out by Jerome Bautista 10.02.2015 SR 20162
             AND a.gibr_fund_cd = b.fund_cd
             AND a.gibr_branch_cd = b.branch_cd
             AND b.branch_cd =
                    DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                          b.branch_cd,
                                                          'GIARDC01',
                                                          NVL (p_user_id,
                                                               USER)
                                                         ),
                            1, b.branch_cd,
                            NULL
                           ))
      LOOP
         v_rec.dcb_no       := i.dcb_no;
         v_rec.dcb_year     := i.dcb_year;
         v_rec.fund_cd      := i.fund_cd;
         v_rec.branch_cd    := i.branch_cd;
         v_rec.tran_date    := i.tran_date;
         v_rec.sdf_tran_date:= TO_CHAR(i.tran_date,'MM-DD-YYYY');
         v_rec.dcb_flag     := i.dcb_flag;
         v_rec.remarks      := i.remarks;
         v_rec.user_id      := i.user_id;
         v_rec.cashier_cd   := i.cashier_cd;
         v_rec.print_name   := i.print_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_cashier_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_fund_cd     giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_dcb_no      giac_order_of_payts.dcb_no%TYPE,
      p_dcb_date    giac_colln_batch.tran_date%TYPE, --Added by Jerome Bautista 09.16.2015 SR 20162
      p_dcb_year    giac_colln_batch.dcb_year%TYPE --Added by Jerome Bautista 09.16.2015 SR 20162
   )
      RETURN cashier_lov_tab PIPELINED
   IS
      v_rec   cashier_lov_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.cashier_cd, a.print_name
                     FROM giac_dcb_users a, giac_order_of_payts b, giac_colln_batch c --giac_colln_batch c Added by Jerome Bautista 09.16.2015 SR 20162
                    WHERE b.gibr_branch_cd = a.gibr_branch_cd
                      AND b.gibr_gfun_fund_cd = a.gibr_fund_cd
                      AND b.cashier_cd = a.cashier_cd
                      AND b.gibr_branch_cd = p_branch_cd
                      AND b.gibr_gfun_fund_cd = p_fund_cd
                      AND b.dcb_no = p_dcb_no
                      AND c.fund_cd = b.gibr_gfun_fund_cd -- Added by Jerome Bautista 09.16.2015 SR 20162
                      AND c.dcb_no = b.dcb_no -- Added by Jerome Bautista 09.16.2015 SR 20162
                      AND c.dcb_year = p_dcb_year -- Added by Jerome Bautista 09.16.2015 SR 20162
                      AND TRUNC (c.tran_date) = NVL (p_dcb_date, TRUNC (c.tran_date)) -- Added by Jerome Bautista 09.16.2015 SR 20162
                      AND p_branch_cd =
                             DECODE
                                (check_user_per_iss_cd_acctg2 (NULL,
                                                               p_branch_cd,
                                                               'GIARDC01',
                                                               NVL (p_user_id,
                                                                    USER
                                                                   )
                                                              ),
                                 1, p_branch_cd,
                                 NULL
                                )
                 ORDER BY a.cashier_cd)
      LOOP
         v_rec.cashier_cd := i.cashier_cd;
         v_rec.print_name := i.print_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION get_dcb_lov(
     p_user_id      VARCHAR2,
     p_fund_cd      VARCHAR2,
     p_branch_cd    VARCHAR2,
     p_dcb_year     VARCHAR2,
     p_dcb_no       VARCHAR2,
     p_dcb_date     DATE,
     p_cashier_cd   VARCHAR2,
     p_cashier_name VARCHAR2
  )
     RETURN dcb_lov_tab PIPELINED
  IS
     v_list         dcb_lov_type;
  BEGIN
     FOR i IN (SELECT DISTINCT b.dcb_no, b.dcb_year, b.fund_cd, b.branch_cd, b.tran_date, b.dcb_flag, --DISTINCT added by Jerome Bautista 09.16.2015 SR 20162
                      b.remarks, b.user_id--, a.cashier_cd, a.print_name --Commented out by Jerome Bautista 09.16.2015 SR 20162
                 FROM giac_dcb_users a, giac_colln_batch b
                WHERE 1 = 1
                  --AND a.dcb_user_id = b.user_id --Commented out by Jerome Bautista 09.16.2015 SR 20162
                  AND a.dcb_user_id = p_user_id -- Added by Jerome Bautista 10.12.2015 SR 20162
                  AND a.valid_tag = 'Y' -- Added by Jerome Bautista 10.12.2015 SR 20162
                  AND a.effectivity_dt <= sysdate -- Added by Jerome Bautista 10.12.2015 SR 20162
                  AND (a.expiry_dt >= sysdate OR a.expiry_dt IS NULL) -- Added by Jerome Bautista 10.12.2015 SR 20162
                  AND a.gibr_fund_cd = b.fund_cd
                  AND a.gibr_branch_cd = b.branch_cd
                  AND TRUNC (b.tran_date) = NVL (p_dcb_date, TRUNC (b.tran_date))
                  AND b.dcb_no = NVL (p_dcb_no, b.dcb_no)
                  AND b.dcb_year = NVL(p_dcb_year, b.dcb_year)
                  AND UPPER(b.branch_cd) LIKE UPPER(NVL(p_branch_cd, b.branch_cd))
                  --AND a.cashier_cd = NVL(p_cashier_cd, a.cashier_cd) --Commented out by Jerome Bautista 09.16.2015 SR 20162
                  --AND UPPER(NVL(a.print_name, '%')) LIKE UPPER(NVL(p_cashier_name, NVL(a.print_name, '%'))) --marco - 10.13.2014 - added NVL
                  AND UPPER(b.fund_cd) LIKE UPPER(NVL(p_fund_cd, b.fund_cd))
                  AND check_user_per_iss_cd_acctg2(NULL,b.branch_cd,'GIARDC01',p_user_id) = 1
     )
     LOOP
        v_list.fund_cd := i.fund_cd;
        v_list.branch_cd := i.branch_cd;
        v_list.dcb_year := i.dcb_year;
        v_list.dcb_no := i.dcb_no;
        v_list.tran_date := i.tran_date;
        --v_list.cashier_cd := i.cashier_cd; --Commented out by Jerome Bautista 09.16.2015 SR 20162
        --v_list.print_name := i.print_name; --Commented out by Jerome Bautista 09.16.2015 SR 20162
        PIPE ROW(v_list);
     END LOOP;
     
     RETURN;
  END;
END;
/


