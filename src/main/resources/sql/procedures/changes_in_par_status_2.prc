DROP PROCEDURE CPI.CHANGES_IN_PAR_STATUS_2;

CREATE OR REPLACE PROCEDURE CPI.changes_in_par_status_2(p_par_id    IN gipi_parlist.par_id%TYPE,
                                p_dist_no   IN giuw_pol_dist.dist_no%TYPE,
                                p_line_cd   IN gipi_parlist.line_cd%TYPE,
								p_iss_cd	IN gipi_parlist.iss_cd%TYPE,
								p_endt_tax_sw IN OUT gipi_wendttext.endt_tax%TYPE,
								p_co_ins_sw IN VARCHAR2,
								p_negate_item				IN VARCHAR2,
							    p_prorate_flag 				IN GIPI_WPOLBAS.prorate_flag%TYPE,
							    p_comp_sw					IN VARCHAR2,
							    p_endt_expiry_date			IN VARCHAR2,
							    p_eff_date					IN VARCHAR2,
							    p_short_rt_percent			IN GIPI_WPOLBAS.short_rt_percent%TYPE,
							    p_expiry_date				IN VARCHAR2,
								p_message OUT VARCHAR2) IS

	/*
	**  Created by		: Emman
	**  Date Created 	: 06.24.2010
	**  Reference By 	: (GIPIS060 - Endt Item Information)
	**  Description 	: Perform necessary actions based on the changes
	** 					  made in the gipi_witem table.  Specifically, 
	** 					  perform the necessary adjustments in the invoice
	** 					  tables, distribution tables and ri tables
	** 					  NOTE: this is an old procedure that  was totally changed for 
	**       			  correct update of records old procedure was renamed as
	**       			  CHANGER_IN_PAR_STATUS_OLD
	*/
   a_item          VARCHAR2(1)  := 'N';    -- switch that will determine existance of additional item
   c_item          VARCHAR2(1)  := 'N';    -- switch that will determine existance of endorsed item  
   a_perl          VARCHAR2(1)  := 'N';    -- switch that will determine existance of perils for additional item
   c_perl          VARCHAR2(1)  := 'N';    -- switch that will determine existance of perils for endorsed item
   v_pack_pol_flag GIPI_WPOLBAS.pack_pol_flag%TYPE;
   v_item_tag	   gipi_wpack_line_subline.item_tag%type;
BEGIN
  FOR A IN (SELECT endt_tax
                FROM gipi_wendttext
               WHERE par_id = p_par_id) LOOP
        p_endt_tax_sw := a.endt_tax;
        EXIT;
    END LOOP;           	 
  
  FOR A1 IN (SELECT b480.item_no item_no
               FROM gipi_witem b480
              WHERE b480.par_id = p_par_id
                AND b480.rec_flag = 'A' )
  LOOP
    a_perl := 'N';
    a_item := 'Y';  -- toggle sw to determine that PAR has an additional item 
    -- check if additinal item has peril already.
    FOR A2 IN (SELECT '1'
                 FROM gipi_witmperl b490
                WHERE b490.par_id   = p_par_id
                  AND b490.item_no  = a1.item_no)
    LOOP
      a_perl := 'Y'; -- toggle sw to determine that additional item has corresponding peril
      EXIT;
    END LOOP;
    IF a_perl = 'N' THEN -- if any of the additional item has no peril exit the loop
       EXIT;
    END IF;
  END LOOP; 

  IF a_item = 'N' THEN  -- if there is no existing additional item then check for endorsed item
     FOR A1 IN (SELECT '1'
                  FROM gipi_witem b480
                 WHERE b480.par_id = p_par_id)
     LOOP
       c_item := 'Y';  -- toggle sw to determine that PAR has an endorsed item 
       FOR A2 IN (SELECT '1' 
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id)
       LOOP
         c_perl  := 'Y'; -- toggle sw to determine that perils for an endorsed item is existing
         EXIT;
       END LOOP;
       EXIT;
     END LOOP;
  END IF;
  
  IF a_item = 'N' AND c_perl = 'N' AND
     nvl(p_endt_tax_sw,'N') = 'Y' THEN
     -- call procedure that will create invoice for PAR that has no peril but
     -- tagged as endoresemnt of tax
     IF c_item = 'Y' THEN
     	  GIPIS060_PAR_STATUS_4(p_par_id,v_pack_pol_flag,v_item_tag); 
     	  p_endt_tax_sw := 'N';     	  
     ELSE
        GIPIS060_CREATE_WINVOICE1(p_par_id,p_line_cd,p_iss_cd);  
        UPDATE gipi_parlist
           SET par_status = 5
         WHERE par_id = p_par_id;        
     END IF;
  ELSIF a_perl = 'Y'  OR c_perl = 'Y' THEN
     -- update par status to 5 for PAR which have perils 
     -- and all additional item has an attached perils
     UPDATE gipi_parlist
        SET par_status = 5
      WHERE par_id = p_par_id;     
  ELSIF a_item = 'Y' OR c_item = 'Y' THEN
     -- call procedure that will update par status of PAR to 4 and do enabling of 
     -- valid menus
     GIPIS060_PAR_STATUS_4(p_par_id,v_pack_pol_flag,v_item_tag); 
  ELSE
     -- call procedure that will update par status of PAR to 4 and do enabling of 
     -- valid menus
     gipis060_PAR_STATUS_3(p_par_id,v_pack_pol_flag,v_item_tag);
	 null;
  END IF;
  -- update amounts for table gipi_wpolbas depending on currenct perils
  gipis060_update_gipi_wpolbas2(p_par_id, p_negate_item, p_prorate_flag, p_comp_sw, p_endt_expiry_date,p_eff_date,
  										  p_short_rt_percent, p_expiry_date, p_message);
END;
/


