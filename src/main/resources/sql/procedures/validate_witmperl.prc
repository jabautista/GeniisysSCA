DROP PROCEDURE CPI.VALIDATE_WITMPERL;

CREATE OR REPLACE PROCEDURE CPI.validate_witmperl(
                                   p_item_no      IN GIPI_WITEM.item_no%TYPE,
                            p_grouped_item_no IN GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
                            p_rec_stat     IN GIPI_WITEM.rec_flag%TYPE,
                            p_item_tsi     IN GIPI_WITEM.tsi_amt%TYPE,
                            p_item_prem    IN GIPI_WITEM.prem_amt%TYPE,
                            p_item_anntsi  IN GIPI_WITEM.ann_tsi_amt%TYPE,
                            p_item_annprem IN GIPI_WITEM.ann_prem_amt%TYPE,
                            p_line_cd      IN GIPI_WITMPERL.line_cd%TYPE,
                            p_par_id       IN GIPI_PARLIST.par_id%TYPE,
                            p_par_type       IN GIPI_PARLIST.par_type%TYPE,
                            p_fire_cd       IN GIIS_PARAMETERS.param_value_v%TYPE,
                            p_hull_cd       IN GIIS_PARAMETERS.param_value_v%TYPE,
                            p_cargo_cd       IN GIIS_PARAMETERS.param_value_v%TYPE,
                            p_msg_alert       OUT VARCHAR2 
                            )
            IS
  CURSOR witmperl_cursor IS SELECT item_no,peril_cd,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt
                              FROM GIPI_WITMPERL
                             WHERE par_id  = p_par_id AND
                                   line_cd = p_line_cd AND
                                   item_no = p_item_no;
--**--gmi 09/23/05--**--                                   
  CURSOR witmperl_grp_cursor IS SELECT item_no,grouped_item_no,peril_cd,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt
                              FROM GIPI_WITMPERL_GROUPED
                             WHERE par_id  = p_par_id AND
                                   line_cd = p_line_cd AND                                 
                                   item_no = p_item_no AND
                                   grouped_item_no = p_grouped_item_no;  
--**--gmi--**--                                   
                   
  X            NUMBER;
  y            NUMBER;
  j            NUMBER;--gmi :used for grouped item perils
  v_rec_not_found     CHAR;
  v_perl_type        GIIS_PERIL.peril_type%TYPE;
  v_perl_cd        GIPI_WITMPERL.peril_cd%TYPE;
  v_basic_cd        GIIS_PERIL.basc_perl_cd%TYPE;
  v_linename        GIIS_LINE.line_name%TYPE;
  v_tsi            GIPI_WITMPERL.tsi_amt%TYPE  := 0;
  v_prem        GIPI_WITMPERL.prem_amt%TYPE  := 0;
  v_anntsi        GIPI_WITMPERL.ann_tsi_amt%TYPE  := 0;
  v_annprem        GIPI_WITMPERL.ann_prem_amt%TYPE  := 0;
/* to check for existing perils for each item */
BEGIN

     --:gauge.FILE := 'passing validate policy ITEM PERIL';
  --vbx_counter;
  X := 0;
  j := 0;--gmi
   FOR witmperl_cursor_rec IN witmperl_cursor LOOP
        X := X + 1;
        v_tsi     := v_tsi     + NVL(witmperl_cursor_rec.tsi_amt,0);
        v_prem    := v_prem    + NVL(witmperl_cursor_rec.prem_amt,0);
        v_anntsi  := v_anntsi  + NVL(witmperl_cursor_rec.ann_tsi_amt,0);
        v_annprem := v_annprem + NVL(witmperl_cursor_rec.ann_prem_amt,0);
        -- for casualty's wperil_section -nski 101196 --
    END LOOP;
--**--gmi--**--    
        FOR witmperl_grp_cursor_rec IN witmperl_grp_cursor LOOP
        j := j + 1;        
        END LOOP;
/*        IF p_grouped_item_no IS NULL THEN
            j := 0;
        END IF;*/
--**--gmi--**--        
    IF X > 0 OR j > 0 THEN
       NULL;
        ELSE
       IF p_par_type = 'E' THEN
          --IF p_line_cd IN         commented out by Gzelle 05.15.2014 all lines should be checked
          --   (p_fire_cd,p_hull_cd,p_cargo_cd) THEN
             IF p_rec_stat NOT IN ('C','D') THEN
                p_msg_alert := p_item_no;
                --p_msg_alert := 'Item ' || TO_CHAR(p_item_no) ||
                --          ' should have at least one peril.';
                --:gauge.FILE:=('Item ' || TO_CHAR(p_item_no) ||
                     --         ' should have at least one peril.');
                --error_rtn;
             END IF;
          /* All lines should not delete their items
          ** September 1, 1997
          */
          --END IF;
       ELSE
          p_msg_alert := 'Item ' || TO_CHAR(p_item_no) ||
                    ' should have at least one peril.';
          --:gauge.FILE:='Item ' || TO_CHAR(p_item_no) ||
             --          ' should have at least one peril.';
       --error_rtn;
       END IF;
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
      --error_rtn;
      p_msg_alert := 'No data found in VALIDATE_WITMPERL. ';
END;
/


