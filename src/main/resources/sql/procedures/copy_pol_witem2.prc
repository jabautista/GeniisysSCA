DROP PROCEDURE CPI.COPY_POL_WITEM2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witem2(
	   	  		  		  p_line_cd     IN  VARCHAR2,
                          p_subline_cd  IN  VARCHAR2,
						  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
						  p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE 
						  )
 		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_witem2 program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Item info..';
  ELSE
    :gauge.FILE := 'passing copy policy WITEM2';
  END IF;
  vbx_counter;  */
  FOR A IN (
         SELECT item_no,item_grp,item_title,item_desc,tsi_amt,
                prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
                currency_rt,group_cd,from_date,TO_DATE,pack_line_cd,
                pack_subline_cd,discount_sw,surcharge_sw, region_cd, changed_tag,
                prorate_flag, comp_sw, short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns
                risk_no, risk_item_no, -- grace 05/24/06
                other_info, coverage_cd, item_desc2
           FROM GIPI_WITEM
          WHERE par_id         = p_par_id
            AND pack_line_cd   = p_line_cd
            AND pack_subline_cd= p_subline_cd) LOOP
    BEGIN        
    INSERT INTO GIPI_ITEM
               (policy_id,item_no,item_grp,item_title,item_desc,tsi_amt,
		            prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
		            currency_rt,group_cd,from_date,TO_DATE,pack_line_cd,
                pack_subline_cd,discount_sw,surcharge_sw, region_cd, changed_tag,
                prorate_flag, comp_sw, short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns)
                risk_no, risk_item_no, -- grace 05/24/06
                other_info, coverage_cd, item_desc2)
        VALUES (p_policy_id,A.item_no,A.item_grp,A.item_title,A.item_desc,A.tsi_amt,
                A.prem_amt,A.ann_tsi_amt,A.ann_prem_amt,A.rec_flag,A.currency_cd,
                A.currency_rt,A.group_cd,A.from_date,A.TO_DATE,A.pack_line_cd,
                A.pack_subline_cd, A.discount_sw, A.surcharge_sw, A.region_cd, 
                A.changed_tag, A.prorate_flag, A.comp_sw, A.short_rt_percent, A.PACK_BEN_CD, A.PAYT_TERMS, -- gmi 09/21/05 ; added columns);
                A.risk_no, A.risk_item_no, -- grace 05/24/06
                A.other_info, A.coverage_cd, A.item_desc2);
    EXCEPTION
		  WHEN DUP_VAL_ON_INDEX THEN
		       null;                
    END;            
          copy_pol_witmperl2(A.item_no,p_par_id,p_policy_id);
  END LOOP;
END;
/


