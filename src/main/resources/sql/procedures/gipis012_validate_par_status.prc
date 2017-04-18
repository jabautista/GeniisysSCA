DROP PROCEDURE CPI.GIPIS012_VALIDATE_PAR_STATUS;

CREATE OR REPLACE PROCEDURE CPI.gipis012_validate_par_status(p_par_id in NUMBER) IS
/* Created by Vida 01/05/97
** For the validation of the par_status
** after all transaction in this form is
** committed, the par status is updated
** based on the processing performed
*/


  CURSOR A IS (SELECT  par_status
                 FROM  gipi_parlist
                WHERE  par_id = p_par_id);
  CURSOR B IS (SELECT  '1'
                 FROM  gipi_witem
                WHERE  par_id = p_par_id);
  CURSOR C IS (SELECT  '1'
                 FROM  gipi_wgrouped_items
                WHERE  par_id = p_par_id);              
  v_par_status         gipi_parlist.par_status%TYPE;
  v_exist1             VARCHAR2(1) := 'N';
  v_exist1b             VARCHAR2(1) := 'N';
  v_exist2             VARCHAR2(1) := 'N';
  v_exist2b            VARCHAR2(1) := 'N';
  v_exist3             VARCHAR2(1) := 'N';

  v_count1             NUMBER      := 0;
  v_count1b            NUMBER      := 0;    
  v_count2             NUMBER      := 0;  
  v_count2b            NUMBER      := 0;  
  v_count3             NUMBER      := 0;  
  v_count4             NUMBER      := 0;  
BEGIN
  FOR A1 IN A LOOP
    v_par_status := a1.par_status;
  END LOOP;
  FOR B1 IN B LOOP
    v_exist1 := 'Y';
  END LOOP;
  FOR C1 IN C LOOP
      v_exist1b := 'Y';
  END LOOP;
  IF v_exist1b = 'Y' THEN
      v_exist1 := NULL;
  END IF;
  
  SELECT  COUNT(item_no)
    INTO  v_count1
    FROM  gipi_witem
   WHERE  par_id = p_par_id;
   
  SELECT  COUNT(grouped_item_no)
    INTO  v_count1b
    FROM  gipi_wgrouped_items
   WHERE  par_id = p_par_id;

  SELECT  COUNT(DISTINCT item_no)
    INTO  v_count2
    FROM  gipi_witmperl
   WHERE  par_id = p_par_id;
   
  SELECT  COUNT(DISTINCT grouped_item_no)
    INTO  v_count2b
    FROM  gipi_witmperl_grouped
   WHERE  par_id = p_par_id;
    
  SELECT  COUNT(DISTINCT item_grp)
    INTO  v_count3
    FROM  gipi_witem
   WHERE  par_id = p_par_id;

  SELECT  COUNT(DISTINCT item_grp)
    INTO  v_count4
    FROM  gipi_winvoice
   WHERE  par_id = p_par_id;
    
    IF v_count1b != 0 THEN
        v_count1 := NULL;
    END IF;
    
    IF v_count2b != 0 THEN
        v_count2 := NULL;
    END IF;
    
  IF NVL(v_exist1,v_exist1b) = 'N' THEN
    GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 3);
     --:b240.par_status := 3;
  ELSIF v_par_status < 4 AND
     NVL(v_exist1,v_exist1b) = 'Y'   THEN
     GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 4);
     --:b240.par_status := 4;
  ELSIF v_par_status < 5 AND
        NVL(v_count1,v_count1b) = NVL(v_count2,v_count2b) THEN
     GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 5);
     --:b240.par_status := 5;
  ELSIF v_par_status < 6 AND
        v_count3 = v_count4 THEN
      GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 6);
     --:b240.par_status := 6;
  ELSIF v_par_status > 4 AND
        NVL(v_count1,v_count1b) != NVL(v_count2,v_count2b) THEN
     GIPI_PARLIST_PKG.UPDATE_PAR_STATUS(p_par_id, 4);
     --:b240.par_status := 4;
  END IF;
END;
/


