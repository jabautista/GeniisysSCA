DROP PROCEDURE CPI.UPDATE_WINV_TAX;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_WINV_TAX(
    p_policy_id     giex_new_group_tax.policy_id%TYPE,
    p_new_par_id    gipi_winv_tax.par_id%TYPE,
    p_iss_cd        giis_issource.iss_cd%TYPE    
) 
IS 
  v_exist_sw             VARCHAR2(1) := NULL;
  v_sum_new_tax          gipi_winvoice.tax_amt%TYPE:=0;
  v_f_tax_amt            gipi_winv_tax.tax_amt%TYPE:=0;
  v_s_tax_amt            gipi_winv_tax.tax_amt%TYPE:=0;
  v_s_tax_amt2           gipi_winv_tax.tax_amt%TYPE:=0;
  v_tot_tax_amt          gipi_winv_tax.tax_amt%TYPE:=0;
  v_diff_tax_amt         gipi_winv_tax.tax_amt%TYPE:=0;
  v_l_tax_amt            gipi_winv_tax.tax_amt%TYPE:=0;
  v_tax_amt_due          gipi_winv_tax.tax_amt%TYPE:=0;
  v_fixed_tax_allocation gipi_winv_tax.fixed_tax_allocation%TYPE;
  v_count                NUMBER:=0;
  v_takeup_seq_no        gipi_winvoice.takeup_seq_no%TYPE;--added by robert, 12/03/12
  CURSOR CUR_A IS 
        SELECT a.line_cd, a.iss_cd, a.tax_cd, a.tax_id, a.tax_desc, 
               nvl(a.tax_amt,0)tax_amt, a.rate, 
               DECODE(b.allocation_tag,'N','F',b.allocation_tag) allocation_tag
          FROM giex_new_group_tax a, giis_tax_charges b
         WHERE a.line_cd = b.line_cd
           AND a.iss_cd = b.iss_cd
           AND a.tax_cd = b.tax_cd
           AND a.tax_id = b.tax_id
           AND a.policy_id = p_policy_id
           AND b.tax_cd IN (SELECT c.tax_cd --added by apollo cruz 02.24.2015
                              FROM giis_tax_charges c, gipi_parlist d
                             WHERE c.line_cd = d.line_cd
                               AND c.iss_cd = d.iss_cd
                               AND d.par_id =  p_new_par_id);
           
  CURSOR CUR_C IS
    SELECT c.line_cd, c.iss_cd, c.tax_cd, c.tax_id
      FROM gipi_winv_tax c
     WHERE NOT EXISTS (SELECT '1'
                         FROM giex_new_group_tax d
                        WHERE d.line_cd = c.line_cd
                          --AND d.iss_cd = c.iss_cd -- removed by apollo cruz 02.13.2015
                          AND d.tax_cd = c.tax_cd   -- causes a conflict when orig policy's iss_cd is not the same in the new par
                          --AND d.tax_id = c.tax_id -- removed by apollo cruz 02.18.2015
                          AND d.policy_id = p_policy_id)
                          AND c.par_id = p_new_par_id;
                          
  CURSOR CUR_D IS 
    SELECT e.inst_no, nvl(f.no_of_payt,1) no_of_payt
      FROM gipi_winvoice d, gipi_winstallment e, giis_payterm f
     WHERE d.par_id = e.par_id
       AND d.item_grp = e.item_grp
       AND d.payt_terms = f.payt_terms
       AND d.par_id = p_new_par_id;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : UPDATE_WINV_TAX program unit 
  */
/* If records in GIEX_NEW_GROUP_TAX already exist in GIPI_WINV_TAX,                        */
/* update tax amounts in gipi_winv_tax.                                                                                */
/* If there are records that do not exist in GIPI_WINV_TAX,                                     */
/* insert the records into gipi_winv_tax.                                                                            */                                                                                  
  FOR A IN CUR_A 
  LOOP
          v_exist_sw := 'N';
          v_sum_new_tax := nvl(v_sum_new_tax,0) + a.tax_amt;
          IF a.allocation_tag IN ('F','N') THEN
                v_f_tax_amt := nvl(v_f_tax_amt,0) + a.tax_amt;
          ELSIF a.allocation_tag = 'S' THEN
                v_s_tax_amt := nvl(v_s_tax_amt,0) + a.tax_amt;
          ELSIF a.allocation_tag = 'L' THEN
                v_l_tax_amt := nvl(v_l_tax_amt,0) + a.tax_amt;
          END IF;
          FOR B IN ( SELECT '1'
                    FROM gipi_winv_tax b
                   WHERE b.line_cd = a.line_cd
                     --AND b.iss_cd  = a.iss_cd -- removed by apollo cruz 02.13.2015
                     AND b.tax_cd  = a.tax_cd   -- causes a conflict when orig policy's iss_cd is not the same in the new par
                     --AND b.tax_id  = a.tax_id -- removed by apollo cruz 02.18.2015
                     AND b.par_id  = p_new_par_id ) 
     LOOP
        v_exist_sw := 'Y';      
        UPDATE gipi_winv_tax
           SET tax_amt = a.tax_amt
         WHERE tax_cd  = a.tax_cd
           --AND tax_id  = a.tax_id -- removed by apollo cruz 02.18.2015
           AND par_id  = p_new_par_id;
     END LOOP;
     
     IF v_exist_sw = 'N' THEN
                IF a.allocation_tag = 'N' THEN
                     v_fixed_tax_allocation := 'N';
                ELSE
                     v_fixed_tax_allocation := 'Y';
                END IF;
                
                --robert, added select statement to have value for takeup_seq_no, 12/03/12
                SELECT takeup_seq_no
                  INTO v_takeup_seq_no
                  FROM gipi_winvoice a
                 WHERE par_id = p_new_par_id
                   AND (   (    NVL (NULL, 'N') = 'Y'
                            AND EXISTS (
                                   SELECT '1'
                                     FROM gipi_witmperl b, gipi_witem c
                                    WHERE c.par_id = a.par_id
                                      AND c.item_grp = a.item_grp
                                      AND b.par_id = c.par_id
                                      AND b.item_no = c.item_no)
                           )
                        OR (NVL (NULL, 'N') = 'N')
                       );
                       
                       
                INSERT INTO gipi_winv_tax
                             (par_id,                        item_grp,                tax_cd,             line_cd,
                              tax_allocation,                fixed_tax_allocation,    iss_cd,             tax_amt,
                              tax_id,                        rate,                    takeup_seq_no) --robert 12/03/12
                VALUES
                             (p_new_par_id,                  1,                       a.tax_cd,           a.line_cd,
                              a.allocation_tag,              v_fixed_tax_allocation,  NVL(p_iss_cd, a.iss_cd),           a.tax_amt,
                              a.tax_id,                      a.rate,                  v_takeup_seq_no);--robert 12/03/12
     END IF;
  END LOOP;

IF v_exist_sw IS NOT NULL THEN
/* If there are records in GIPI_WINV_TAX does not exist in GIPI_NEW_GROUP_TAX,*/
/* delete the records from GIPI_WINV_TAX.                                                                            */
       FOR C IN CUR_C 
       LOOP
          DELETE gipi_winv_tax
           WHERE 1 = 1 --tax_id = c.tax_id -- removed by apollo cruz 02.18.2015
             AND tax_cd = c.tax_cd
             AND par_id = p_new_par_id;
       END LOOP;

/* UPDATE TOTAL TAX AMOUNT IN GIPI_WINVOICE. */  
  UPDATE gipi_winvoice
     SET tax_amt = v_sum_new_tax
   WHERE par_id = p_new_par_id; 

/* UPDATE TAX AMOUNTS IN GIPI_WINSTALLMENT. */  
  FOR D IN CUR_D LOOP
      v_count := nvl(v_count,0) + 1;
      IF v_count = 1 THEN
       IF v_s_tax_amt != 0 THEN
          v_s_tax_amt2     := round((v_s_tax_amt / d.no_of_payt),2);
          v_tot_tax_amt := v_s_tax_amt2 * d.no_of_payt;
          v_diff_tax_amt:= v_s_tax_amt - v_tot_tax_amt;
       END IF;
    END IF;
      IF d.inst_no = 1 THEN
           v_tax_amt_due := nvl(v_f_tax_amt,0) + nvl(v_s_tax_amt2,0);
       UPDATE gipi_winstallment
          SET tax_amt = v_tax_amt_due
        WHERE inst_no = 1
          AND par_id = p_new_par_id; 
      ELSIF d.inst_no = d.no_of_payt THEN
           v_tax_amt_due := nvl(v_l_tax_amt,0) + nvl(v_s_tax_amt2,0) + nvl(v_diff_tax_amt,0);
       UPDATE gipi_winstallment
          SET tax_amt = v_tax_amt_due
        WHERE inst_no = d.no_of_payt
          AND par_id = p_new_par_id;           
      ELSE
           v_tax_amt_due := nvl(v_s_tax_amt2,0);
       UPDATE gipi_winstallment
          SET tax_amt = v_tax_amt_due
        WHERE inst_no = d.inst_no
          AND par_id = p_new_par_id;           
    END IF;
  END LOOP;
END IF;
END;
/


