CREATE OR REPLACE PACKAGE BODY CPI.CSV_GICLR259 
AS
  FUNCTION CSV_GICLR259_f (p_payee_no       NUMBER,
                           p_payee_class_cd NUMBER, 
                           p_from_date      DATE,
                           p_to_date        DATE,
                           p_as_of_date     DATE, 
                           p_from_ldate     DATE,
                           p_to_ldate       DATE,
                           p_as_of_ldate    DATE) RETURN giclr259_type PIPELINED
  
  
  IS
    v_giclr259  giclr259_rec_type;
    
  BEGIN
  

    FOR CA IN (SELECT a.claim_id,a.line_cd,b.payee_class_cd, b.payee_no,
                      b.payee_class_cd||'-'||e.class_desc payee_class,
                      b.payee_no||'-'||DECODE(b.payee_first_name, '-', b.payee_last_name ,
                        b.payee_last_name||' '||b.payee_first_name||' '||b.payee_middle_name) payee_name,        
                      get_claim_number(a.claim_id) Claim_Number,
                      a.line_cd||'-'|| a.subline_cd||'-'|| a.pol_iss_cd ||'-'||LTRIM(TO_CHAR( a.issue_yy,'09')) || '-' ||LTRIM(TO_CHAR( a.pol_seq_no,'0000009')) || '-'||LTRIM(TO_CHAR( a.renew_no,'09')) Policy_Number,
                      g.assd_name, c.item_no, NVL(c.paid_amt,0) paid_amt, NVL(c.net_amt,0) net_amt, 
                      NVL(c.advise_amt,0) advise_amt, LTRIM(TO_CHAR( f.peril_cd, '00009'))||'-'||f.peril_name peril, c.hist_seq_no,  
                      LTRIM(TO_CHAR(d.item_no,'00009'))||'-'|| Get_Gpa_Item_Title(a.claim_id,a.line_cd,d.item_no,d.grouped_item_no) item,
                      Get_Advice_Number(c.advice_id) advice_no,a.dsp_loss_date, c.payee_type, a.clm_file_date
                 FROM GICL_CLAIMS a, 
                      GIIS_PAYEES b,
                      GICL_CLM_LOSS_EXP c,
                      GICL_CLM_ITEM d,
                      GIIS_PAYEE_CLASS e,
                      GIIS_PERIL f,
                      giis_assured g
                WHERE a.assd_no = g.assd_no 
                  and a.claim_id = c.claim_id
                  AND a.claim_id = d.claim_id
                  AND b.payee_class_cd = e.payee_class_cd
                  AND b.payee_no = c.payee_cd
                  AND b.payee_class_cd = c.payee_class_cd    
                  AND b.payee_no = p_payee_no
                  AND b.payee_class_cd = p_payee_class_cd 
                  AND a.claim_id = d.claim_id
                  AND f.peril_cd = c.peril_cd
                  AND d.item_no = c.item_no
                  AND d.grouped_item_no = c.grouped_item_no
                  AND NVL(c.cancel_sw,'N') ='N'
                  AND f.line_cd= a.line_cd
                  AND Check_User_Per_Line(a.line_cd,iss_cd,'GICLS259')=1
                  AND (((TRUNC(a.clm_file_date) between p_from_date
                               AND p_to_date)
                               OR TRUNC(a.clm_file_date) <= p_as_of_date)
                         OR ((TRUNC(a.loss_date) between p_from_ldate
                                   AND p_to_ldate)
                                   OR TRUNC(a.loss_date) <= p_as_of_ldate))
                ORDER BY Claim_number) 
    LOOP
                    
      v_giclr259.claim_no := CA.claim_nUMBER;
      v_giclr259.policy_no := ca.policy_number;
      v_giclr259.assured_name := ca.assd_name;
      v_giclr259.file_date := ca.clm_file_date;
      v_giclr259.loss_date := ca.dsp_loss_date;
      v_giclr259.item := ca.item;
      v_giclr259.peril_name := ca.peril;
      v_giclr259.advice_no := ca.advice_no;
      v_giclr259.hist_seq_no := ca.hist_seq_no;
      v_giclr259.paid_amt := ca.paid_amt;
      v_giclr259.net_amt := ca.net_amt; --added by Dexter 07/03/2013 
      v_giclr259.advice_amt := ca.advise_amt;
      v_giclr259.payee_type := ca.payee_type;
      v_giclr259.payee_class := ca.payee_class;
      v_giclr259.payee_name := ca.payee_name;
               
      pipe row(v_giclr259);  
    END LOOP;
     
    
  END;
END;
/


