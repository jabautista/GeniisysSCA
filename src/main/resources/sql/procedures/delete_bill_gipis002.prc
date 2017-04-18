DROP PROCEDURE CPI.DELETE_BILL_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Delete_Bill_Gipis002
 (p_par_id NUMBER,
  b540_co_insurance_sw IN NUMBER) IS
  /*added variables edgar 02/04/2015*/
  v_menu_line_cd        giis_line.MENU_LINE_CD%TYPE;
  v_line_cd             giis_line.LINE_CD%TYPE;
  BEGIN
     DELETE FROM GIPI_WINSTALLMENT
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WCOMM_INV_PERILS
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WCOMM_INVOICES
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WINVPERL
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WINV_TAX
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WPACKAGE_INV_TAX
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_WINVOICE
       WHERE  par_id  =  p_par_id;
     DELETE FROM GIPI_ORIG_INVPERL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INV_TAX
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INVOICE
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_ITMPERIL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_CO_INSURER
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_MAIN_CO_INS
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_WPOLBAS_DISCOUNT
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_WITEM_DISCOUNT
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_WPERIL_DISCOUNT
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_WITMPERL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_WOPEN_PERIL
       WHERE  par_id  = p_par_id;  
     DELETE FROM GIPI_WDEDUCTIBLES
       WHERE  par_id  = p_par_id;  
     Delete_Co_Ins_Gipis002(p_par_id, b540_co_insurance_sw);
     /*added edgar 02/04/2015*/
        BEGIN
           SELECT b.menu_line_cd, b.line_cd
             INTO v_menu_line_cd, v_line_cd
             FROM gipi_parlist a, giis_line b
            WHERE a.line_cd = b.line_cd AND a.par_id = p_par_id;

           IF    v_menu_line_cd = 'AC'
              OR (v_menu_line_cd IS NULL AND v_line_cd = giisp.v ('LINE_CODE_AC'))
           THEN
              DELETE FROM gipi_witmperl_grouped
                    WHERE par_id = p_par_id;

              DELETE FROM gipi_witmperl_beneficiary
                    WHERE par_id = p_par_id;

              DELETE FROM gipi_wgrp_items_beneficiary
                    WHERE par_id = p_par_id;

              DELETE FROM gipi_wgrouped_items
                    WHERE par_id = p_par_id;
           END IF;
        END;   
     /*ended edgar 02/04/2015*/
     UPDATE GIPI_WITEM
        SET PREM_AMT     = 0,
            ANN_PREM_AMT = 0,
            TSI_AMT      = 0,
            ANN_TSI_AMT  = 0,
            DISCOUNT_SW  = 'N',
            SURCHARGE_SW = 'N'
      WHERE PAR_ID = p_par_id;
     UPDATE GIPI_WPOLBAS 
        SET PREM_AMT     = 0,
            ANN_PREM_AMT = 0,
            TSI_AMT      = 0,
            ANN_TSI_AMT  = 0,
            DISCOUNT_SW  = 'N',
            SURCHARGE_SW = 'N'
      WHERE PAR_ID = p_par_id;
     UPDATE GIPI_PARLIST
        SET PAR_STATUS = '4'
      WHERE PAR_ID = p_par_id;
  END;
/


