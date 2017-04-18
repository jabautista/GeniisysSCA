DROP PROCEDURE CPI.GIPIS096_DEL_RECORDS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS096_DEL_RECORDS(p_par_id           IN  GIPI_WITEM.par_id%TYPE,
                                                 p_item_no          IN  GIPI_WITEM.item_no%TYPE,
                                                 p_pack_line_cd     IN  GIPI_WITEM.pack_line_cd%TYPE)                                          
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 21, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Equivalent to the Program Unit DEL_RECORDS in GIPIS096 module
*/

    v_peril_count       NUMBER := 0;

  BEGIN
        
     SELECT COUNT(*)
          INTO v_peril_count 
     FROM GIPI_WITMPERL
     WHERE par_id = p_par_id
     AND item_no  = p_item_no;
            
     IF v_peril_count > 0 THEN
          GIPI_WITMPERL_PKG.del_witmperl_per_item(p_par_id, p_item_no);
     END IF;
        
     IF p_pack_line_cd = GIISP.V('LINE_CODE_MC') THEN
          
          GIPI_WVEHICLE_PKG.del_gipi_wvehicle(p_par_id, p_item_no);
          GIPI_WMCACC_PKG.del_gipi_wmcacc(p_par_id, p_item_no);
                      
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_FI') THEN
          
          GIPI_WFIREITM_PKG.del_gipi_wfireitm(p_par_id, p_item_no);
                          
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_EN') THEN
          
          GIPI_WLOCATION_PKG.del_gipi_wlocation2(p_par_id, p_item_no);
          GIPI_WDEDUCTIBLES_PKG.del_gipi_wdeductibles_item_2(p_par_id, p_item_no);
          
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_MN') THEN
          
          GIPI_WCARGO_PKG.del_gipi_wcargo(p_par_id, p_item_no);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_MH') OR p_pack_line_cd = GIISP.V('LINE_CODE_AV') THEN
          
          GIPI_WAVIATION_ITEM_PKG.del_gipi_waviation_item(p_par_id, p_item_no);
          GIPI_WITEM_VES_PKG.del_gipi_witem_ves(p_par_id, p_item_no);
                       
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_CA') THEN
          
          GIPI_WCASUALTY_ITEM_PKG.del_gipi_wcasualty_item(p_par_id, p_item_no);
          GIPI_WCASUALTY_PERSONNEL_PKG.del_gipi_wcasualty_personnel(p_par_id, p_item_no);
          GIPI_WGROUPED_ITEMS_PKG.del_gipi_wgrouped_items(p_par_id, p_item_no);
          GIPI_WDEDUCTIBLES_PKG.del_gipi_wdeductibles_item_2(p_par_id, p_item_no);
                      
     ELSIF p_pack_line_cd = GIISP.V('LINE_CODE_AC') THEN
          
          GIPI_WACCIDENT_ITEM_PKG.del_gipi_waccident_item(p_par_id, p_item_no);
                                              
     END IF;
        
  END;
/


