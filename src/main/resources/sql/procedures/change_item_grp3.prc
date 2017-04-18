DROP PROCEDURE CPI.CHANGE_ITEM_GRP3;

CREATE OR REPLACE PROCEDURE CPI.CHANGE_ITEM_GRP3(p_par_id IN gipi_parlist.par_id%TYPE) IS

   p_item_grp      gipi_witem.item_grp%TYPE := 1;
   v_pack_pol_flag GIPI_WPOLBAS.pack_pol_flag%TYPE;

BEGIN
--BETH 110398 update to null the item group of all existing item to reset grouping
      UPDATE    gipi_witem
         SET    item_grp    = NULL
       WHERE    par_id      = p_par_id;
	   
	   BEGIN
	   SELECT pack_pol_flag
	     INTO v_pack_pol_flag
		 FROM GIPI_WPOLBAS
		WHERE par_id = p_par_id;
	   EXCEPTION
	     WHEN NO_DATA_FOUND THEN NULL;
	   END;
	   
  IF v_pack_pol_flag = 'Y' THEN
    FOR C1 IN  (SELECT    currency_cd, currency_rt, pack_line_cd, pack_subline_cd
                  FROM    gipi_witem
                 WHERE    par_id  =  p_par_id
              GROUP BY    currency_cd, currency_rt, pack_line_cd, pack_subline_cd
              ORDER BY    currency_cd, currency_rt, pack_line_cd, pack_subline_cd)   
    LOOP
      UPDATE    gipi_witem
         SET    item_grp        = p_item_grp
       WHERE    currency_rt     = c1.currency_rt
         AND    currency_cd     = c1.currency_cd
         AND    pack_line_cd    = c1.pack_line_cd
         AND    pack_subline_cd = c1.pack_subline_cd
         AND    par_id      = p_par_id;
      p_item_grp  :=  p_item_grp + 1;
    END LOOP;
  ELSE
    FOR C2 IN  (SELECT    currency_cd, currency_rt
                  FROM    gipi_witem
                 WHERE    par_id  =  p_par_id
              GROUP BY    currency_cd, currency_rt
              ORDER BY    currency_cd, currency_rt)   
    LOOP
    	--msg_alert('item_grp: '||p_item_grp);
      UPDATE    gipi_witem
         SET    item_grp    = p_item_grp
       WHERE    currency_rt = c2.currency_rt
         AND    currency_cd = c2.currency_cd
         AND    par_id      = p_par_id;
      p_item_grp  :=  p_item_grp + 1;
    END LOOP;
  END IF;
END;
/


