DROP PROCEDURE CPI.BREAK_TAXES_GIACS180;

CREATE OR REPLACE PROCEDURE CPI.BREAK_TAXES_GIACS180
(p_misc_cut_off_date  IN  DATE                          --:misc.cut_off_date
)
AS
/* this procedure is created to break the taxes of the
** Statement of Account GIACS180 
** by danny tamayo, 05/28/10. 
*/
   TYPE tab_fund_cd      IS TABLE OF GIAC_SOA_REP_EXT.fund_cd%TYPE INDEX BY PLS_INTEGER;
   TYPE tab_branch_cd    IS TABLE OF GIAC_SOA_REP_EXT.branch_cd%TYPE;
   TYPE tab_iss_cd       IS TABLE OF GIAC_SOA_REP_EXT.iss_cd%TYPE;
   TYPE tab_prem_seq_no  IS TABLE OF GIAC_SOA_REP_EXT.prem_seq_no%TYPE;
   TYPE tab_inst_no      IS TABLE OF GIAC_SOA_REP_EXT.inst_no%TYPE;
   TYPE tab_due_date     IS TABLE OF GIAC_SOA_REP_EXT.due_date%TYPE;
   TYPE tab_column_no    IS TABLE OF GIAC_SOA_REP_EXT.aging_id%TYPE;   
   TYPE tab_column_title IS TABLE OF GIAC_SOA_REP_EXT.column_title%TYPE;
   TYPE tab_tax_bal_due  IS TABLE OF GIAC_SOA_REP_EXT.tax_bal_due %TYPE;
   TYPE tab_spld_date    IS TABLE OF GIAC_SOA_REP_EXT.spld_date%TYPE;
   vv_fund_cd            tab_fund_cd;     
   vv_branch_cd          tab_branch_cd;   
   vv_iss_cd             tab_iss_cd;       
   vv_prem_seq_no        tab_prem_seq_no;  
   vv_inst_no            tab_inst_no;      
   vv_due_date           tab_due_date;     
   vv_column_no          tab_column_no;    
   vv_column_title       tab_column_title; 
   vv_tax_bal_due        tab_tax_bal_due;  
   vv_spld_date          tab_spld_date;
   
   v_max_inst_no         GIPI_INSTALLMENT.inst_no%TYPE;    
   v_tax_bal_due         GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE;
PROCEDURE retrieve_sorep
   IS
   BEGIN
      SELECT fund_cd,
             branch_cd,
             iss_cd,
             prem_seq_no,
             inst_no,
             due_date,
             aging_id, --column_no
             column_title,
             tax_bal_due, 
             spld_date
      BULK COLLECT INTO                  
             vv_fund_cd,       
             vv_branch_cd,         
             vv_iss_cd,             
             vv_prem_seq_no,       
             vv_inst_no,              
             vv_due_date,          
             vv_column_no,         
             vv_column_title,      
             vv_tax_bal_due,      
             vv_spld_date 
        FROM GIAC_SOA_REP_EXT    
       WHERE user_id = USER;
   END;
-- start of main procedure
BEGIN
   DELETE FROM GIAC_SOA_REP_TAX_EXT
    WHERE user_id = USER;
   retrieve_sorep;
   FOR indx IN vv_fund_cd.FIRST .. vv_fund_cd.LAST
      LOOP
         BEGIN
            SELECT MAX(INST_NO)
              INTO v_max_inst_no
              FROM GIPI_INSTALLMENT 
             WHERE ISS_CD = vv_iss_cd(indx)
               AND PREM_SEQ_NO = vv_prem_seq_no(indx);
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   v_max_inst_no := 1;
         END;




--Included GIPI_INVOICE in the select stmt to compute foreign currency
--Terrence 05-08-2002
         FOR invtax IN (SELECT A.iss_cd, A.prem_seq_no, A.tax_cd,A.tax_amt*B.CURRENCY_RT TAX_AMT, A.tax_allocation
                     FROM GIPI_INV_TAX A, GIPI_INVOICE B
                     WHERE A.iss_cd = B.iss_cd
                     AND A.prem_seq_no =B.PREM_SEQ_NO
             AND A.iss_cd = vv_iss_cd(indx)
                     AND A.prem_seq_no = vv_prem_seq_no(indx))
      LOOP
         --Set the total balances per inst no
         --Start the computation of the per installment amount
         IF invtax.tax_allocation = 'F' THEN
            IF vv_inst_no(indx) = 1 THEN
               v_tax_bal_due := invtax.tax_amt;
            ELSE
               v_tax_bal_due := 0;
            END IF;
         ELSIF invtax.tax_allocation = 'S' THEN
            IF vv_inst_no(indx) = v_max_inst_no THEN
               v_tax_bal_due := invtax.tax_amt - ROUND((invtax.tax_amt/v_max_inst_no),2)*(v_max_inst_no - 1);
            ELSE
               v_tax_bal_due := ROUND((invtax.tax_amt/v_max_inst_no),2);
            END IF;
         ELSIF invtax.tax_allocation = 'L' THEN
            IF vv_inst_no(indx) = v_max_inst_no THEN
               v_tax_bal_due := invtax.tax_amt;
            ELSE
               v_tax_bal_due := 0;
            END IF;
         END IF;
         IF (vv_spld_date(indx) IS NULL) THEN
            FOR collns IN (SELECT b160_iss_Cd, b160_prem_seq_no, 
                                  b160_tax_cd, tax_amt 
                           FROM GIAC_TAX_COLLNS a, GIAC_ACCTRANS b 
                           WHERE 1=1
                           AND a.gacc_tran_id = b.tran_id
                           AND b.tran_flag != 'D'
                           AND b.tran_id >= 0
                           AND a.b160_iss_cd = vv_iss_cd(indx)
                           AND a.b160_prem_seq_no = vv_prem_seq_no(indx)
                           AND a.inst_no = vv_inst_no(indx)
                           AND a.b160_tax_cd = invtax.tax_cd
                           AND NOT EXISTS (SELECT gr.gacc_tran_id
                                       FROM GIAC_REVERSALS gr,
                                                GIAC_ACCTRANS  ga
                                  WHERE gr.reversing_tran_id = ga.tran_id
                                     AND ga.tran_flag        !='D'
                                           AND ga.tran_id >= 0
                                AND gr.gacc_tran_id = a.gacc_tran_id)
                           AND TRUNC(b.tran_date) <= p_misc_cut_off_date)
            LOOP
               v_tax_bal_due := v_tax_bal_due - collns.tax_amt;
            END LOOP; --TAX_COLLNS
         END IF;
         --Insert the record to the soa_rep_tax table
         INSERT INTO GIAC_SOA_REP_TAX_EXT(
            ISS_CD, PREM_SEQ_NO,INST_NO,TAX_CD,TAX_BAL_DUE,USER_ID)
         VALUES(
            vv_iss_cd(indx),vv_prem_seq_no(indx),vv_inst_no(indx),invtax.tax_cd,v_tax_bal_due,USER);
      END LOOP;    --INVTAX
   END LOOP;       --SOAREP         
COMMIT;
END;
/


