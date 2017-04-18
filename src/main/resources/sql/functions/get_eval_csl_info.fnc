DROP FUNCTION CPI.GET_EVAL_CSL_INFO;

CREATE OR REPLACE FUNCTION CPI.Get_Eval_Csl_Info (p_claim_id IN gicl_claims.claim_id%TYPE,
                                              p_eval_id  IN gicl_eval_loa.eval_id%TYPE,
             p_payee_type_cd  IN gicl_eval_loa.payee_type_cd%TYPE,
             p_payee_cd  IN gicl_eval_loa.payee_cd%TYPE )
RETURN VARCHAR2 AS
/* Beth 11032006
** Get evaluation CSL information
*/
     p_csl_dtl  VARCHAR2(700);
  p_loa_amt  NUMBER :=0;

 BEGIN
    --retrieves total part_amt
 FOR i IN (SELECT NVL(SUM(part_amt),0) sum_part_amt
    FROM GICL_REPLACE 
      WHERE NVL(payt_payee_Type_cd,payee_type_cd) = p_payee_type_cd   
     AND NVL(payt_payee_cd,payee_cd) =  p_payee_cd 
     AND eval_id = p_eval_id)
 LOOP
   p_loa_amt := p_loa_amt + i.sum_part_amt;
    END LOOP;
  
 --retrieves the sum of actual_total_amt and other_labor_amt,including with_vat field   
 FOR i IN (SELECT NVL(actual_total_amt, 0) + NVL(other_labor_amt, 0) total_amt
             FROM gicl_repair_hdr
            WHERE payee_type_cd = p_payee_type_cd   
        AND payee_cd =  p_payee_cd 
    AND eval_id = p_eval_id)
    LOOP
   p_loa_amt := p_loa_amt + i.total_amt;
 END LOOP;
  
 --retrieves the vat amount of the record with apply_to equal to 'L'...
    FOR i IN (SELECT b.vat_amt  A
             FROM gicl_repair_hdr A, gicl_eval_vat b
      WHERE A.eval_id = p_eval_id
     AND A.eval_id = b.eval_id
     AND A.payee_Type_cd = p_payee_type_cd
     AND A.payee_cd = p_payee_cd
     AND b.apply_to = 'L'
     AND NVL(A.with_vat,'N') = 'N')
   LOOP
  p_loa_amt := p_loa_amt + i.A;
   END LOOP;
  
   FOR vatAmt IN ( SELECT SUM(ROUND( DECODE(A.with_vat,'Y',0,'N',(A.part_amt*(Giacp.n('INPUT_VAT_RT')/100)) ) ,2)) A
            FROM GICL_REPLACE A, gicl_eval_vat b
     WHERE A.eval_id = p_eval_id
       AND A.eval_id = b.eval_id
       AND NVL(A.payt_payee_type_cd,A.payee_Type_cd) = p_payee_type_cd
       AND NVL(A.payt_payee_cd,A.payee_cd) = p_payee_cd
       AND b.apply_to = 'P'
    GROUP BY NVL(A.payt_payee_type_cd,A.payee_Type_cd),NVL(A.payt_payee_cd,A.payee_cd)) 
   LOOP
  p_loa_amt := p_loa_amt + NVL(vatAmt.A,0);  
   END LOOP;
    
   --dEDUCTIBLES
     FOR g IN (SELECT NVL(SUM(ABS(ded_amt)), 0) ded_amt
    FROM gicl_eval_deductibles
         WHERE payee_type_cd = p_payee_type_cd
        AND payee_cd = p_payee_cd 
        AND eval_id = p_eval_id)
      
    LOOP
      p_loa_amt := p_loa_amt - g.ded_amt;
 END LOOP;
   
   --depREciatiOn amount
   FOR i IN (SELECT NVL(SUM(ABS(ded_amt)), 0) ded_amt
         FROM GICL_EVAL_DEP_DTL
         WHERE payee_type_cd = p_payee_type_cd 
         AND payee_cd = p_payee_cd 
         AND eval_id = p_eval_id)
   LOOP
   p_loa_amt := p_loa_amt - i.ded_amt;
   END LOOP;   
   
   FOR get_csl_info IN(
     SELECT 'CSL No. : '||DECODE(d.subline_cd,NULL,NULL,d.subline_cd||'-'||d.iss_cd||'-'||trim(TO_CHAR(d.csl_yy,'09'))||'-'||trim(TO_CHAR(d.csl_seq_no,'00009'))) ||CHR(10)||
            'Payee :'   ||b.class_desc||'-'||c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,','||c.payee_first_name) ||DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name||'.') ||CHR(10)||
   'CSL Amount : ' || LTRIM(RTRIM(TO_CHAR(p_loa_amt,'999,999,999,990.99'))) csl_info
       FROM giis_payee_class b, giis_payees c, gicl_eval_csl d 
      WHERE d.payee_type_cd = b.payee_class_cd
        AND d.payee_cd = c.payee_no 
      AND d.eval_id = p_eval_id 
     AND d.payee_type_cd = p_payee_type_cd
     AND d.payee_cd = p_payee_cd)
   LOOP
     p_csl_dtl := get_csl_info.csl_info;
  EXIT;
   END LOOP;
   
   RETURN p_csl_dtl;

 END;
/


