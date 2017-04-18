DROP PROCEDURE CPI.GIPIS010_RENUMBER;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_RENUMBER (p_par_id	IN gipi_witem.par_id%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Re-arranged item numbering
	*/
	v_cnt_item	NUMBER := 0;
	v_old_no	gipi_witem.item_no%TYPE;
	v_exist		VARCHAR2(1);
	v_line_cd	giis_line.line_cd%TYPE;
	v_alt_line_cd giis_line.line_cd%TYPE;
BEGIN
	FOR x IN (
		SELECT line_cd
		  FROM gipi_wpolbas
		 WHERE par_id = p_par_id)
	LOOP
		v_line_cd := x.line_cd;
		EXIT;
	END LOOP;
	
	v_alt_line_cd := NVL(giis_line_pkg.get_menu_line_cd(v_line_cd), v_line_cd);
	
	FOR cnt IN (SELECT COUNT(*) item
				  FROM gipi_witem
				 WHERE par_id = p_par_id)
	LOOP   
		v_cnt_item := cnt.item;
		EXIT;
	END LOOP;
	
	IF v_cnt_item > 0 THEN
		FOR A IN 1 .. v_cnt_item
		LOOP
			v_old_no := NULL;
			v_exist := 'N';
			FOR B IN (SELECT '1'
						FROM gipi_witem
					   WHERE par_id = p_par_id
						 AND item_no = a)
			LOOP
				v_exist := 'Y';
				EXIT;
			END LOOP;
			
			IF v_exist = 'N' THEN
				FOR C IN (SELECT item_no,      item_title,     item_grp,    item_desc,
								 item_desc2,   tsi_amt,        prem_amt,    ann_prem_amt,
								 ann_tsi_amt,  rec_flag,       currency_cd, currency_rt,
								 group_cd,     from_date,      TO_DATE,     coverage_cd,
								 pack_line_cd, pack_subline_cd,discount_sw, other_info, region_cd
							FROM gipi_witem
						   WHERE par_id = p_par_id
							 AND item_no > a
						ORDER BY item_no)
				LOOP
					v_old_no := c.item_no;
					INSERT INTO gipi_witem (
						par_id,       item_no,        item_title,  item_grp,    
						item_desc2,   tsi_amt,        prem_amt,    ann_prem_amt,
						ann_tsi_amt,  rec_flag,       currency_cd, currency_rt,
						item_desc,    group_cd,       from_date,   TO_DATE,
						pack_line_cd, pack_subline_cd,discount_sw, other_info,
						coverage_cd, region_cd )
					VALUES  (
						p_par_id,   a,                 c.item_title,  c.item_grp,    
						c.item_desc2,   c.tsi_amt,         c.prem_amt,    c.ann_prem_amt,
						c.ann_tsi_amt,  c.rec_flag,        c.currency_cd, c.currency_rt,
						c.item_desc,    c.group_cd,        c.from_date,   c.TO_DATE,
						c.pack_line_cd, c.pack_subline_cd, c.discount_sw, c.other_info,
						c.coverage_cd, c.region_cd );
					EXIT;
				END LOOP;
				
				IF v_alt_line_cd = 'MC' THEN
					UPDATE gipi_wvehicle
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					
					UPDATE gipi_wmortgagee
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					
					UPDATE gipi_wmcacc
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				ELSIF v_alt_line_cd = 'FI' THEN
					UPDATE gipi_wfireitm
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					
					UPDATE gipi_wmortgagee
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				ELSIF v_alt_line_cd = 'MN' THEN
					UPDATE gipi_wcargo
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					
					UPDATE gipi_wcargo_carrier
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				ELSIF v_alt_line_cd = 'AV' THEN
					UPDATE gipi_waviation_item
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				ELSIF v_alt_line_cd = 'CA' THEN
					UPDATE gipi_wcasualty_item
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_wgrouped_items
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_wcasualty_personnel
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				ELSIF v_alt_line_cd = 'AC' THEN
					UPDATE gipi_waccident_item
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_witmperl_beneficiary
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_wgrp_items_beneficiary
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_witmperl_grouped
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_wgrouped_items
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
					   
					UPDATE gipi_wbeneficiary
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				ELSIF v_alt_line_cd = 'MH' THEN
					UPDATE gipi_witem_ves
					   SET item_no = a
					 WHERE par_id = p_par_id
					   AND item_no = v_old_no;
				END IF;				
				   
				INSERT INTO  gipi_witmperl (
					par_id,       item_no,      line_cd,     peril_cd,
					tarf_cd,      prem_rt,      tsi_amt,     prem_amt,
					ann_tsi_amt,  ann_prem_amt, rec_flag,    comp_rem,
					discount_sw,  ri_comm_rate, ri_comm_amt, prt_flag,
					as_charge_sw)
				SELECT p_par_id, 	 a,            line_cd,     peril_cd,
					   tarf_cd,      prem_rt,      tsi_amt,     prem_amt,
					   ann_tsi_amt,  ann_prem_amt, rec_flag,    comp_rem,
					   discount_sw,  ri_comm_rate, ri_comm_amt, prt_flag,
					   as_charge_sw
				  FROM gipi_witmperl
				 WHERE par_id = p_par_id
				   AND item_no = v_old_no;
				   
				UPDATE gipi_witem_discount
				   SET item_no = a
				 WHERE par_id = p_par_id
				   AND item_no = v_old_no;
				   
				UPDATE gipi_wperil_discount
				   SET item_no = a
				 WHERE par_id = p_par_id
				   AND item_no = v_old_no;
				   
				UPDATE gipi_wdeductibles
				   SET item_no = a
				 WHERE par_id = p_par_id
                   AND item_no = v_old_no;                
                   
                Gipis010_Renumber_Dist(p_par_id, a, v_old_no);   
                
                DELETE gipi_witmperl
                 WHERE par_id = p_par_id
                   AND item_no = v_old_no;
                   
                DELETE gipi_witem
                 WHERE par_id = p_par_id
                   AND item_no = v_old_no;      
            END IF;
        END LOOP; 
    END IF;       
END GIPIS010_RENUMBER;
/


