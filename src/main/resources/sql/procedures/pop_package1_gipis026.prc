DROP PROCEDURE CPI.POP_PACKAGE1_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.Pop_Package1_Gipis026(
	   	  		  			 P_PACK_PAR_ID		 IN  GIPI_PACK_WINSTALLMENT.PACK_PAR_ID%TYPE
							,PGL_PACK_PAR_ID 	 IN  GIPI_PACK_WINSTALLMENT.PACK_PAR_ID%TYPE
							,PGL_CG$B240_PAR_ID	 IN  GIPI_PARLIST.PAR_ID%TYPE
							,P_MSG_ALERT		 OUT VARCHAR2 ) IS
  v_var         NUMBER := 0;
  v_par_id      gipi_parlist.par_id%TYPE;
  v_item_grp    gipi_winvoice.item_grp%TYPE;
  v_line_cd     gipi_parlist.line_cd%TYPE;
  v_tax_amt     gipi_winv_tax.tax_amt%TYPE;
BEGIN
	--A.R.C. 07.18.2006
  IF PGL_PACK_PAR_ID IS NOT NULL THEN
  	 DELETE FROM GIPI_PACK_WINSTALLMENT
           WHERE pack_par_id = P_PACK_PAR_ID; 
     INSERT INTO GIPI_PACK_WINSTALLMENT(pack_par_id, item_grp, inst_no, share_pct, prem_amt, tax_amt, due_date)
          SELECT P_PACK_PAR_ID, item_grp, inst_no, share_pct, SUM(prem_amt), SUM(tax_amt), due_date
	          FROM GIPI_WINSTALLMENT A
	         WHERE EXISTS (SELECT 1
	                         FROM GIPI_PARLIST gp
				                  WHERE gp.par_id = A.par_id
					                  AND gp.pack_par_id = P_PACK_PAR_ID)		
           GROUP BY P_PACK_PAR_ID, item_grp, inst_no, share_pct, due_date;
  END IF;
  
 FOR H IN (SELECT par_id, line_cd
             FROM gipi_parlist
            WHERE par_id = PGL_CG$B240_PAR_ID) LOOP
    v_par_id  := H.par_id; 
  EXIT;
 END LOOP;

 FOR C IN (SELECT  pack_pol_flag
              FROM  gipi_wpolbas
             WHERE  par_id  =  v_par_id
               AND  pack_pol_flag = 'Y') LOOP

   FOR O IN (SELECT prem_amt, item_grp, other_charges,
                    prem_seq_no
               FROM gipi_winvoice
              WHERE par_id   = v_par_id) LOOP
 
     FOR line IN (
        SELECT DISTINCT pack_line_cd
          FROM gipi_witem
         WHERE par_id   = v_par_id
           AND item_grp = o.item_grp)
     LOOP  
       v_line_cd := line.pack_line_cd;
     END LOOP; 

     FOR L IN (SELECT 'a'
                 FROM gipi_wpackage_inv_tax
                WHERE par_id  = v_par_id
                  AND line_cd = v_line_cd) LOOP
        v_var     := v_var + 1;
      EXIT;
     END LOOP;

     SELECT SUM(tax_amt)
       INTO v_tax_amt
       FROM gipi_winv_tax 
      WHERE par_id   = v_par_id
        AND item_grp = O.item_grp
        AND line_cd  = v_line_cd;
        
      IF v_var > 0 THEN
         UPDATE gipi_wpackage_inv_tax
           SET  PREM_AMT      = NVL(O.prem_amt,0),
                TAX_AMT       = NVL(v_tax_amt,0),
                OTHER_CHARGES = NVL(O.other_charges,0)
          WHERE par_id   = v_par_id
            AND item_grp = O.item_grp
            AND line_cd  = v_line_cd; 
      ELSE
         INSERT INTO GIPI_WPACKAGE_INV_TAX(
            par_id, item_grp, line_cd, prem_seq_no,
            prem_amt, tax_amt, other_charges)
         VALUES(
            v_par_id, O.item_grp,
            v_line_cd, NVL(O.prem_seq_no,NULL),
            NVL(O.prem_amt,0), NVL(v_tax_amt,0), NVL(O.other_charges,0));
      END IF;
   END LOOP;
 END LOOP;
--variables.commit_sw := 'N';
--POST;
--CLEAR_MESSAGE;
--FORMS_DDL('COMMIT');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      P_MSG_ALERT := 'No data found';
END;
/


