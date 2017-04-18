DROP PROCEDURE CPI.GIPIS002_UPDATE_WITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002_UPDATE_WITEM(p_par_id	GIPI_PARLIST.par_id%TYPE) IS
/******************************************************************************
   FOR OPEN POLICY SAVING OF GIPIS002 - BRYAN 09/21/2010
******************************************************************************/
BEGIN
   FOR A IN (SELECT  sum(NVL(prem_amt,0)) prem,
                    sum(NVL(ann_prem_amt,0)) ann_prem,
                    item_no
              FROM  gipi_witmperl
             WHERE  par_id  =  p_par_id
          GROUP BY  item_no) LOOP
      UPDATE  gipi_witem
         SET  prem_amt   =  A.prem, ann_prem_amt = A.ann_prem
       WHERE  par_id     =  p_par_id
         AND  item_no    =  A.item_no;
  END LOOP;
  FOR B IN (SELECT  sum(NVL(a.tsi_amt,0)) tsi,
                    sum(NVL(a.ann_tsi_amt,0)) ann_tsi,
                    a.item_no
              FROM  gipi_witmperl a,giis_peril b
             WHERE  a.line_cd    =  b.line_cd
               AND  a.peril_cd   =  b.peril_cd
               AND  b.peril_type =  'B'
               AND  a.par_id     =  p_par_id
          GROUP BY  a.item_no) LOOP
      UPDATE  gipi_witem
         SET  tsi_amt   =  B.tsi, 
              ann_tsi_amt = B.ann_tsi
       WHERE  par_id     =  p_par_id
         AND  item_no    =  B.item_no;
  END LOOP;

END GIPIS002_UPDATE_WITEM;
/


