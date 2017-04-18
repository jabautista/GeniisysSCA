DROP PROCEDURE CPI.VALIDATE_INSTALLMENT;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_INSTALLMENT(p_par_id  GIPI_PARLIST.par_id%TYPE,
    p_message   OUT  VARCHAR2,
    p_module_id giis_modules.module_id%TYPE Default NULL)
IS
    inv_tot_premamt gipi_winvoice.prem_amt%TYPE;
    inv_tot_taxamt  gipi_winvoice.tax_amt%TYPE;
    ins_tot_premamt gipi_winstallment.prem_amt%TYPE;
    ins_tot_taxamt  gipi_winstallment.tax_amt%TYPE;
    ins_due_date    gipi_winstallment.due_date%TYPE;
   
BEGIN

   FOR i IN (SELECT par_id, item_grp, 
                    takeup_seq_no
               FROM GIPI_WINVOICE
              WHERE par_id = p_par_id)
   LOOP
       SELECT SUM(prem_amt), SUM(tax_amt) 
         INTO inv_tot_premamt, inv_tot_taxamt  
         FROM GIPI_WINVOICE
        WHERE par_id = i.par_id
          AND item_grp = i.item_grp
          AND takeup_seq_no = i.takeup_seq_no;
       
       SELECT SUM(prem_amt), SUM(tax_amt)
         INTO ins_tot_premamt, ins_tot_taxamt  
         FROM GIPI_WINSTALLMENT
        WHERE par_id = i.par_id
          AND item_grp = i.item_grp
          AND takeup_seq_no = i.takeup_seq_no;

       SELECT due_date
         INTO ins_due_date 
         FROM GIPI_WINVOICE
        WHERE par_id = i.par_id
          AND item_grp = i.item_grp
          AND takeup_seq_no = i.takeup_seq_no;
          
       IF ((inv_tot_premamt != ins_tot_premamt) OR (inv_tot_taxamt != ins_tot_taxamt)) THEN
       
            UPDATE GIPI_WINVOICE
               SET payt_terms = 'COD'
             WHERE par_id = i.par_id
               AND item_grp = i.item_grp
               AND takeup_seq_no = i.takeup_seq_no;
                 
            DELETE FROM GIPI_WINSTALLMENT
             WHERE par_id = i.par_id
               AND item_grp = i.item_grp
               AND takeup_seq_no = i.takeup_seq_no;
                 
            INSERT INTO GIPI_WINSTALLMENT
            VALUES (i.par_id, i.item_grp, 1, 100, inv_tot_premamt, inv_tot_taxamt, ins_due_date, i.takeup_seq_no);
                
            --Gzelle for batch posting error logs 09.03.2013
            --gipis207_pkg.pre_post_error2(p_par_id, 'Invalid Installment.', p_module_id);      
            --p_message := 'Invalid Installment';
            --replaced by kenneth L.: added if statement
            IF p_module_id = 'GIPIS207'
            THEN
                gipis207_pkg.pre_post_error2(p_par_id, 'There was an error in Invoice Premium Details, payment term will be updated to COD. Please check and provide the correct payment term.', p_module_id);    
                 p_message := 'Y';
            ELSE
                p_message := 'Invalid Installment';
            END IF; 
            
             COMMIT;             
       END IF;
          
   END LOOP;
   

  /*SELECT SUM(prem_amt), SUM(tax_amt) 
    INTO inv_tot_premamt, inv_tot_taxamt  
    FROM GIPI_WINVOICE
   WHERE par_id = p_par_id;
   
   SELECT SUM(prem_amt), SUM(tax_amt)
     INTO ins_tot_premamt, ins_tot_taxamt  
     FROM GIPI_WINSTALLMENT
    WHERE par_id = p_par_id;

   SELECT due_date
     INTO ins_due_date 
     FROM GIPI_WINVOICE
    WHERE par_id = p_par_id
      AND takeup_seq_no = 1;
      
   IF ((inv_tot_premamt != ins_tot_premamt) OR (inv_tot_taxamt != ins_tot_taxamt)) THEN
   
    UPDATE GIPI_WINVOICE
       SET payt_terms = 'COD'
     WHERE par_id = p_par_id;
         
    DELETE FROM GIPI_WINSTALLMENT
     WHERE par_id = p_par_id;
         
    INSERT INTO GIPI_WINSTALLMENT
    VALUES (p_par_id, 1, 1, 100,inv_tot_premamt, inv_tot_taxamt, ins_due_date, 1);
        
     p_message := 'Invalid Installment';
     COMMIT;
         
   END IF;*/ -- replaced by: Nica 12.5.2012 - to consider item_grp and takeup_seq_no
         
END;
/


