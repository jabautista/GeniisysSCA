CREATE OR REPLACE PACKAGE BODY CPI.GIACR052C_CPI_PKG AS

   FUNCTION populate_giacr052c_records (
      p_tran_id             VARCHAR2,
      p_item_no             VARCHAR2
      )
      RETURN giacr052c_record_tab PIPELINED
    AS
      v_rec                 giacr052c_record_type;
      v_currency            VARCHAR2 (20) := 'PESOS';
    BEGIN     
       FOR i IN (SELECT 'CV_NO.' || gibr_gfun_fund_cd || '-' || gibr_branch_cd || '-' ||
                        b.dv_pref || '-' || TO_CHAR (b.dv_no, 'FM0999999999') dv_no,
                        '** ' || a.payee || ' **' payee,
                        '**' || TO_CHAR (a.fcurrency_amt, 'FM99,999,999,999,990.00') amount,
                        a.fcurrency_amt chk_amt, a.currency_cd currency, 
                        DECODE (a.currency_cd, 1, ' PESOS', c.currency_desc) currency_desc
                   FROM GIAC_CHK_DISBURSEMENT a, 
                        GIAC_DISB_VOUCHERS b,
                        GIIS_CURRENCY c
                  WHERE a.gacc_tran_id  = b.gacc_tran_id
                    AND a.gacc_tran_id  = p_tran_id
                    AND a.item_no       = p_item_no
                    AND a.currency_cd   = c.main_currency_cd(+))
                    
       LOOP
            v_rec.payee             := i.payee;
            v_rec.amount            := i.amount;
            v_rec.dv_no             := i.dv_no;
            v_rec.amt_in_words      := '** ' || UPPER (dh_util.check_protect2 (i.chk_amt, i.currency, TRUE))
                                             || i.currency_desc ||' ONLY ' || ' **';
              
            PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;
    
END GIACR052C_CPI_PKG;
/

DROP PACKAGE BODY CPI.GIACR052C_CPI_PKG;
