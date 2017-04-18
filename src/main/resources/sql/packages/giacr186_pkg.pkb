CREATE OR REPLACE PACKAGE BODY CPI.GIACR186_PKG AS
FUNCTION populate_giacr186(
    p_bank_cd       VARCHAR2,
    p_cleared       VARCHAR2,
    p_bank_acct_cd  VARCHAR2,
    p_null          VARCHAR2,
    p_branch_cd     VARCHAR2,
    p_from_date     DATE,
    p_to_date       DATE,
    p_as_of_date    DATE,
    p_user_id       VARCHAR2
)
RETURN giacr186_tab PIPELINED as 

    v_rec giacr186_type;
    v_count NUMBER := 0;
BEGIN
    FOR a IN(
        SELECT   a.posting_date,
                 b.branch_name,
                 b.branch_cd, e.check_pref_suf, e.check_no check_no2, c.dv_pref, LPAD (c.dv_no, 10, '0') dv_no2, --Dren 05.03.2016 SR-5355      
                 c.dv_pref || '-' || LPAD (c.dv_no, 10, '0') "DV_NO", 
                 c.dv_date,
                 d.bank_name, 
                 e.check_date,
                 DECODE (e.check_pref_suf,NULL, NULL,
                    LPAD (e.check_pref_suf, 5, ' ')
                 || '-'|| LPAD (e.check_no, 10, '0')) "CHECK_NO",                             
                 e.amount "CHECK_AMOUNT", 
                 e.payee ,
                 f.bank_acct_no,
                 g.check_release_date "DATE_RELEASED",
                 g.clearing_date,
                 h.rv_meaning --SR19642 Lara 07092015
        FROM    giac_acctrans a,
                giac_branches b,
                giac_disb_vouchers c,
                giac_banks d,
                giac_chk_disbursement e,
                giac_bank_accounts f,
                giac_chk_release_info g,
                cg_ref_codes h --SR19642 Lara 07092015
        WHERE   a.tran_id = c.gacc_tran_id
        AND     b.branch_cd = c.gibr_branch_cd
        AND     c.gacc_tran_id = e.gacc_tran_id
        AND     d.bank_cd = f.bank_cd
        AND     f.bank_cd = e.bank_cd
        AND     f.bank_acct_cd = e.bank_acct_cd
        AND     e.gacc_tran_id = g.gacc_tran_id
        AND     e.item_no = g.item_no
        AND     a.gfun_fund_cd = b.gfun_fund_cd
        AND     e.check_no = g.check_no
        --AND     e.check_stat = 2 --SR19642 Lara 07092015
        AND     h.rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT'   
        AND     e.check_stat LIKE h.rv_low_value 
        AND     e.check_stat IN (2, 3) --end SR19642 
        AND     (   (    (   (TRUNC (g.check_release_date) BETWEEN p_from_date AND p_to_date )
                            OR (TRUNC (g.check_release_date) <= p_as_of_date)
                    )
                        AND p_cleared = 'N'
                    )
                OR (    (    TRUNC (e.check_date) <= p_as_of_date
                             AND TO_CHAR (TRUNC (g.clearing_date), 'MM-RRRR') = TO_CHAR (p_as_of_date, 'MM-RRRR')
                        )
                    AND p_cleared = 'Y')
                )
        AND     f.bank_cd = NVL (p_bank_cd, f.bank_cd)
        AND     f.bank_acct_cd = NVL (p_bank_acct_cd, f.bank_acct_cd)
        AND     (   (    (   (    TRUNC (g.check_release_date) <= p_as_of_date
                                   AND g.clearing_date IS NULL
                             )
                         OR (   TRUNC (g.clearing_date) > p_as_of_date
                                AND TRUNC (g.check_release_date) <= p_as_of_date
                            )
                         )
                    AND p_null = '1'
                    AND TRUNC (e.check_date) <= p_as_of_date
                    )
                    OR (p_null = '0')
                )
        AND     b.branch_cd = DECODE (p_branch_cd,
                                        NULL, DECODE (check_user_per_iss_cd_acctg2 (NULL,b.branch_cd,'GIACS184',p_user_id),
                                            1, b.branch_cd,NULL),
                                       p_branch_cd
                                       )
        )
        LOOP
            v_count := 1;
            v_rec.company_name      :=  giacp.v('COMPANY_NAME');
            v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
            v_rec.date_posted       :=  a.posting_date;
            v_rec.branch_cd         :=  a.branch_cd; --Dren 05.03.2016 SR-5355 -Start
            v_rec.dv_prefix         :=  a.dv_pref; 
            v_rec.dv_no2            :=  a.dv_no2; 
            v_rec.check_prefix      :=  a.check_pref_suf; 
            v_rec.check_no2         :=  a.check_no2; --Dren 05.03.2016 SR-5355 - End           
            v_rec.branch_name       :=  a.branch_name;
            v_rec.dv_no             :=  a.dv_no;                     
            v_rec.dv_date           :=  a.dv_date;
            v_rec.bank_name         :=  a.bank_name;
            v_rec.check_date        :=  a.check_date;
            v_rec.check_no          :=  a.check_no;
            v_rec.check_amount      :=  a.check_amount;
            v_rec.date_released     :=  a.date_released;
            v_rec.clearing_date     :=  a.clearing_date;
            v_rec.bank_acct_no      :=  a.bank_acct_no;
            v_rec.payee             :=  a.payee;
            v_rec.check_status      :=  a.rv_meaning; --SR19642 Lara 07092015
            PIPE ROW (v_rec);
            
        END LOOP;
        
        IF v_count = 0 THEN
            v_rec.company_name      :=  giacp.v('COMPANY_NAME');
            v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
            
            PIPE ROW (v_rec);
        END IF;
 
END populate_giacr186;

FUNCTION get_total_checks_per_bank_acct (
    p_bank_cd       VARCHAR2,
    p_cleared       VARCHAR2,
    p_bank_acct_cd  VARCHAR2,
    p_null          VARCHAR2,
    p_branch_cd     VARCHAR2,
    p_from_date     DATE,
    p_to_date       DATE,
    p_as_of_date    DATE,
    p_user_id       VARCHAR2
    
)
 RETURN NUMBER IS
 ctr NUMBER(5) := 0;
    BEGIN
  FOR a IN (SELECT g.check_release_date,
                   g.clearing_date,
                   e.check_date 
                          FROM giac_acctrans a, 
                     giac_branches b, 
                     giac_disb_vouchers c, 
                     giac_banks d, 
                     giac_chk_disbursement e, 
                     giac_bank_accounts f, 
                     giac_chk_release_info g 
             WHERE a.tran_id = c.gacc_tran_id 
               AND b.branch_cd = c.gibr_branch_cd 
               AND c.gacc_tran_id = e.gacc_tran_id 
               AND d.bank_cd = f.bank_cd 
                       AND f.bank_cd = e.bank_cd 
               AND f.bank_acct_cd = e.bank_acct_cd 
               AND e.gacc_tran_id = g.gacc_tran_id 
               AND e.item_no = g.item_no 
               AND a.gfun_fund_cd  = b.gfun_fund_cd 
               AND e.check_no = g.check_no 
               AND e.check_stat = 2 
               AND ((((TRUNC(g.check_release_date) BETWEEN p_from_date AND p_to_date) OR (TRUNC(g.check_release_date) <= p_as_of_date)) 
                     AND p_cleared = 'N') 
                        OR ((TRUNC(e.check_date) <= p_as_of_date AND TRUNC(g.clearing_date) <= p_as_of_date) AND p_cleared = 'Y')) 
               AND f.bank_cd = NVL(p_bank_cd,f.bank_cd) 
               AND f.bank_acct_cd = NVL(p_bank_acct_cd,f.bank_acct_cd) 
               AND ((((TRUNC(g.check_release_date) <= p_as_of_date AND g.clearing_date IS NULL) OR (TRUNC(g.clearing_date) > p_as_of_date AND TRUNC(g.check_release_date) <= p_as_of_date)) 
                     AND p_null = '1' AND TRUNC(e.check_date) <= p_as_of_date) 
                      OR 
                      (p_null = '0'))) 
 
LOOP
  IF P_NULL = '0' AND P_CLEARED = 'N' THEN  /*RELEASED*/
      IF (to_char(a.check_release_date,'MM-RRRR')) = (to_char(p_as_of_date,'MM-RRRR')) 
           AND (to_char(a.check_date,'MM-RRRR')) = (to_char(p_as_of_date,'MM-RRRR')) THEN
          ctr := ctr + 1;
      END IF;
  ELSIF P_NULL = '0' AND P_CLEARED = 'Y' THEN /*CLEARED*/
      IF (to_char(a.check_date,'MM-RRRR')) = (to_char(p_as_of_date,'MM-RRRR')) AND
           (to_char(a.clearing_date,'MM-RRRR')) = (to_char(p_as_of_date,'MM-RRRR'))
          THEN
        ctr := ctr + 1;
      END IF;
  ELSIF P_NULL = '1' AND P_CLEARED = 'N' THEN /*OUTSTANDING*/
      IF (to_char(a.check_release_date,'MM-RRRR')) = (to_char(p_as_of_date,'MM-RRRR')) THEN
          ctr := ctr + 1;
      END IF;
  END IF;
END LOOP;
END get_total_checks_per_bank_acct;
END GIACR186_PKG;
/
