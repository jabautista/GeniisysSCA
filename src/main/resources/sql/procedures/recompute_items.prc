DROP PROCEDURE CPI.RECOMPUTE_ITEMS;

CREATE OR REPLACE PROCEDURE CPI.recompute_items(
	   	  		  p_par_id	     IN  GIPI_PARLIST.par_id%TYPE,
				  p_line_cd		 IN  GIPI_PARLIST.line_cd%TYPE,
				  p_iss_cd		 IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_msg_alert    OUT VARCHAR2
	   	  		  )
	    IS
  p_error         VARCHAR2(1) := 'N';
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : recompute_items program unit
  */
  FOR D IN (SELECT item_no,prem_amt,tsi_amt
              FROM GIPI_WITEM
             WHERE par_id  =  p_par_id) LOOP
       FOR E IN (/*SELECT   sum(a.prem_amt) prem_amt,sum(b.tsi_amt) tsi_amt
                   FROM   gipi_witmperl a,gipi_witmperl b,giis_peril c
                  WHERE   a.par_id   =  b.par_id
                    AND   a.item_no  =  b.item_no
                    AND   a.par_id   =  :postpar.par_id
                    AND   a.item_no  =  D.item_no
                    AND   b.peril_cd =  c.peril_cd
                    AND   c.line_cd  =  b.line_cd
                    AND   c.peril_type = 'B'*/--comment by VJ 052207 replaced by the query below.
                  SELECT SUM(X.prem_amt) prem_amt, y.tsi_amt tsi_amt
  									FROM GIPI_WITMPERL X,
       									 (SELECT par_id,item_no,SUM(tsi_amt) tsi_amt
          									FROM GIPI_WITMPERL a,GIIS_PERIL b
         									 WHERE a.line_cd    = b.line_cd
           									 AND a.peril_cd   = b.peril_cd
           									 AND b.peril_type = 'B'
           									 AND a.par_id     = p_par_id
           									 AND a.item_no  = D.item_no   
         									 GROUP BY  par_id, item_no) y
 									WHERE X.par_id = y.par_id
   									AND X.item_no = y.item_no
 									GROUP BY  y.tsi_amt   ) LOOP
              IF ((NVL(E.prem_amt,0) != NVL(D.prem_amt,0)) OR 
                  (NVL(E.tsi_amt,0) != NVL(D.tsi_amt,0))) THEN
                   UPDATE    GIPI_WITEM
                      SET    tsi_amt  =  D.tsi_amt,
                             prem_amt =  D.prem_amt
                    WHERE    par_id   =  p_par_id
                      AND    item_no  =  D.item_no;
                    p_error   :=  'Y';
              END IF;
        END LOOP;
  END LOOP;
  IF p_error = 'Y' THEN
      Create_Winvoice(0,0,0,p_par_id,p_line_cd,p_iss_cd); -- modified by aivhie 120601
      Cr_Bill_Dist.get_tsi(p_par_id);
      UPDATE  GIPI_PARLIST
         SET  par_status  =  5
       WHERE  par_id      =  p_par_id;
	   p_msg_alert := 'Internal computation error, please go to Bill Information Module.';
      --p_msg_alert := 'Internal computation error, will now call Bill Information Module.';
      --NEW_FORM('GIPIS026');
  END IF;
END;
/


