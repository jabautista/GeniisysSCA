CREATE OR REPLACE PACKAGE BODY CPI.GIXX_ITEM_PKG AS
  FUNCTION get_gixx_item(p_extract_id        GIXX_ITEM.extract_id%TYPE)
    RETURN gixx_item_tab PIPELINED
    IS
    v_item                  gixx_item_type;
  BEGIN
    FOR i IN (SELECT TSI.EXTRACT_ID EXTRACT_ID3, 
                           TSI.FX_NAME TSI_FX_NAME, 
                        TSI.FX_DESC TSI_FX_DESC,   
                        UPPER( TSI.FX_NAME|| ' ' || DH_UTIL.SPELL ( TRUNC ( SUM(TSI.ITM_TSI) ) )
                                  || ' AND ' || LTRIM (ABS((( SUM(TSI.ITM_TSI) )-( TRUNC ( SUM(TSI.ITM_TSI) ) ) )*100))
                                 || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( SUM(TSI.ITM_TSI), '999,999,999,999,999.00' ) ) )
                               || ') IN ' || TSI.FX_DESC ) TSI_SPELLED_TSI
                  FROM (SELECT ITEM.EXTRACT_ID EXTRACT_ID,
                                 SUM(DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', NVL(ITEM.TSI_AMT, 0),
                                            'N', NVL(ITEM.TSI_AMT, 0) * INVOICE.CURRENCY_RT,
                                           NVL(ITEM.TSI_AMT, 0))) ITM_TSI,  
                                           DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME,
                                           'N', 'PHP',
                                           FX.SHORT_NAME) FX_NAME,  
                                DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC,
                                            'N', 'PHILIPPINE PESO',
                                           FX.CURRENCY_DESC ) FX_DESC,  
                                INVOICE.CURRENCY_CD INVOICE_FX_CD, 
                                AVG(INVOICE.CURRENCY_RT) AVG_FX_RT           
                        FROM GIXX_ITEM ITEM,  GIIS_CURRENCY FX,  GIXX_INVOICE  INVOICE,GIXX_POLBASIC POL
                         WHERE (( ITEM.CURRENCY_CD= FX.MAIN_CURRENCY_CD)
                         AND ( ITEM.EXTRACT_ID= INVOICE.EXTRACT_ID)
                         AND ( FX.MAIN_CURRENCY_CD= INVOICE.CURRENCY_CD))
                         AND ITEM.EXTRACT_ID = p_extract_id
                         AND ITEM.EXTRACT_ID = POL.EXTRACT_ID
                         AND POL.CO_INSURANCE_SW = 1
                      GROUP BY ITEM.EXTRACT_ID, 
                                 DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME,
                                      'N', 'PHP',
                                      FX.SHORT_NAME),
                             DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC,
                                     'N', 'PHILIPPINE PESO',
                                    FX.CURRENCY_DESC ),  
                             INVOICE.CURRENCY_CD) TSI
           GROUP BY TSI.EXTRACT_ID, 
                    TSI.FX_NAME ,   
                    TSI.FX_DESC   
              UNION
             SELECT TSI.EXTRACT_ID EXTRACT_ID3, 
                        TSI.FX_NAME TSI_FX_NAME, 
                       TSI.FX_DESC TSI_FX_DESC,   
                       UPPER( TSI.FX_NAME|| ' ' || DH_UTIL.SPELL ( TRUNC ( SUM(TSI.ITM_TSI) ) )
                                || ' AND ' || LTRIM (ABS((( SUM(TSI.ITM_TSI) )-( TRUNC ( SUM(TSI.ITM_TSI) ) ) )*100))
                                || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( SUM(TSI.ITM_TSI), '999,999,999,999,999.00' ) ) )
                              || ') IN ' || TSI.FX_DESC ) TSI_SPELLED_TSI
                 FROM (SELECT ITEM.EXTRACT_ID EXTRACT_ID,
                               SUM(DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', NVL(ITEM.TSI_AMT, 0),
                                          'N', NVL(ITEM.TSI_AMT, 0) * INVOICE.CURRENCY_RT,
                                       NVL(ITEM.TSI_AMT, 0))) ITM_TSI,  
                               DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME,
                                       'N', 'PHP',
                                       FX.SHORT_NAME) FX_NAME,  
                               DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC,
                                       'N', 'PHILIPPINE PESO',
                                       FX.CURRENCY_DESC ) FX_DESC,  
                               INVOICE.CURRENCY_CD INVOICE_FX_CD, 
                               AVG(INVOICE.CURRENCY_RT) AVG_FX_RT           
                          FROM GIXX_ITEM ITEM,  GIIS_CURRENCY FX,  GIXX_ORIG_INVOICE  INVOICE,GIXX_POLBASIC POL
                      WHERE (( ITEM.CURRENCY_CD= FX.MAIN_CURRENCY_CD)
                        AND ( ITEM.EXTRACT_ID= INVOICE.EXTRACT_ID)
                        AND ( FX.MAIN_CURRENCY_CD= INVOICE.CURRENCY_CD))
                        AND ITEM.EXTRACT_ID = P_EXTRACT_ID
                        AND ITEM.EXTRACT_ID = POL.EXTRACT_ID
                        AND POL.CO_INSURANCE_SW = 2
                     GROUP BY ITEM.EXTRACT_ID, 
                                  DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.SHORT_NAME,
                                     'N', 'PHP',
                                     FX.SHORT_NAME),
                            DECODE(NVL(INVOICE.POLICY_CURRENCY,'N'), 'Y', FX.CURRENCY_DESC,
                                    'N', 'PHILIPPINE PESO',
                                    FX.CURRENCY_DESC ),  
                            INVOICE.CURRENCY_CD) TSI
        GROUP BY TSI.EXTRACT_ID, TSI.FX_NAME , 
                      TSI.FX_DESC)
    LOOP
      v_item.extract_id3     := i.extract_id3;
      v_item.tsi_fx_name     := i.tsi_fx_name;
      v_item.tsi_fx_desc     := i.tsi_fx_desc;
      v_item.tsi_spelled_tsi := i.tsi_spelled_tsi;
      PIPE ROW(v_item);
    END LOOP;
    RETURN;
  END get_gixx_item;
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 28, 2010
**  Reference By : 
**  Description  : Function to compute for the tow limit of the motor item record. 
*/
   FUNCTION get_tow_limit(p_extract_id IN GIXX_ITEM.extract_id%TYPE,
                          p_item_no    IN GIXX_ITEM.item_no%TYPE)
      RETURN NUMBER
   IS
      v_tow               NUMBER (16, 2);
      v_repair            NUMBER (16, 2);
      v_policy_currency   gipi_invoice.policy_currency%TYPE;
      v_currency_rt       gipi_item.currency_rt%TYPE;
   BEGIN
      FOR a IN (SELECT b.currency_rt,
                       NVL (a.policy_currency, 'N') policy_currency
                  FROM gixx_item b, gixx_invoice a
                 WHERE b.extract_id = p_extract_id
                   AND a.extract_id = b.extract_id
                   AND item_no = p_item_no)
      LOOP
         v_currency_rt := a.currency_rt;
         v_policy_currency := a.policy_currency;
      END LOOP;
      SELECT NVL(SUM (NVL (towing, 0)), 0)
        INTO v_tow
        FROM gixx_vehicle
       WHERE extract_id = p_extract_id 
         AND item_no    = p_item_no;
      IF NVL (v_policy_currency, 'N') = 'Y'
      THEN
         v_repair := (v_tow);
      ELSE
         v_repair := (v_tow * v_currency_rt);
      END IF;
      RETURN (v_repair);
   END;
    /*
    **  Created by   :  mark jm
    **  Date Created :  05.02.2011
    **  Reference By : 
    **  Description  : Function to compute for the deductible of the motor item record. 
    */
    FUNCTION get_item_deductibles (
        p_extract_id IN gixx_polbasic.extract_id%TYPE,
        p_item_no IN gixx_item.item_no%TYPE)
    RETURN NUMBER
    IS
        v_ded_amt gixx_deductibles.deductible_amt%TYPE := 0;
        v_currency_rt gipi_item.currency_rt%type;
        v_policy_currency gipi_invoice.policy_currency%type;
    BEGIN
        FOR i IN (
            SELECT deductibles.item_no item_no,       
                   SUM(DECODE(deductibles.deductible_amt, null, 
                         deduct_desc.deductible_amt, deductibles.deductible_amt)) -- andrew - 2.9.2013 - added SUM function to get the total deductible amount
                         deductibles_deductible_amt--,        
                  -- deductibles.ded_deductible_cd deductibles_ded_deductible_cd     -- andrew - 2.9.2013  
              FROM gixx_deductibles deductibles, 
                   giis_deductible_desc deduct_desc,
                   giis_peril peril
             WHERE deductibles.ded_deductible_cd = deduct_desc.deductible_cd (+)
               AND deductibles.ded_subline_cd = deduct_desc.subline_cd (+)
               AND deductibles.ded_line_cd = deduct_desc.line_cd (+)
               AND deductibles.ded_line_cd = peril.line_cd (+)
               AND deductibles.peril_cd = peril.peril_cd (+)
               AND deductibles.extract_id = p_extract_id
               AND deductibles.item_no = p_item_no
          GROUP BY deductibles.item_no--, deductibles.ded_deductible_cd -- andrew - 2.9.2013
          )
        LOOP
            FOR A IN (
                SELECT b.currency_rt,NVL(a.policy_currency,'N') policy_currency
                  FROM gixx_item b, gixx_invoice a
                 WHERE b.extract_id = p_extract_id
                   AND a.extract_id = b.extract_id
                   AND item_no      = p_item_no)
            LOOP
                v_currency_rt := A.currency_rt;
                v_policy_currency := a.policy_currency;
            END LOOP;
            IF NVL(v_policy_currency,'N') = 'Y' THEN
                RETURN(NVL(i.deductibles_deductible_amt , 0));
            ELSE
                RETURN(NVL((i.deductibles_deductible_amt  * NVL(v_currency_rt,1)), 0));
            END IF;
        END LOOP;

        RETURN v_ded_amt;
    END get_item_deductibles;
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 12, 2010
**  Reference By : 
**  Description  : Function to get the motor car item records which is used in policy document report. 
*/ 
   FUNCTION get_pol_doc_mc_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
     RETURN pol_doc_mc_item_tab PIPELINED IS
     v_item pol_doc_mc_item_type;
   BEGIN     
     FOR i IN (
          SELECT /**** ITEM ****/
                 b480.extract_id    extract_id, 
                 b480.item_no       item_item_no,
                 b480.item_no || ' - ' || LTRIM (b480.item_title) item_item_title,
                 b480.item_title item_item_title2,
                 b480.item_desc     item_desc, 
                 b480.item_desc2    item_desc2,
                 b480.coverage_cd   item_coverage_cd,
                 coverage.coverage_desc item_coverage_desc,
                 b110.currency_desc item_currency_desc,
                 b480.other_info    item_other_info,
                 /**** END ITEM ****/
                 /**** VEHICLE ****/
                 vehicle.assignee             vehicle_assignee, 
                 vehicle.origin               vehicle_origin,
                 vehicle.destination          vehicle_destination,
                 vehicle.model_year           vehicle_model_year,
                 carcoy.car_company           vehicle_car_coy, 
                 vehicle.make                 vehicle_make,
                 bodytype.type_of_body        bodytype_type_of_body,
                 vehicle.color                vehicle_color, 
                 vehicle.mv_file_no           vehicle_mv_file_no,
                 LPAD (vehicle.coc_serial_no, 7, 0)
                 || '-'
                 || LPAD (vehicle.coc_yy, 2, 0) vehicle_coc_no,
                 vehicle.coc_issue_date       vehicle_coc_issue_date,
                 vehicle.coc_serial_no        vehicle_coc_serial_no,
                 vehicle.serial_no            vehicle_serial_no,
                 sublinetype.subline_type_desc sublinetype_subline_type_desc,
                 vehicle.acquired_from        vehicle_acquired_from,
                 vehicle.plate_no             vehicle_plate_no,
                 vehicle.no_of_pass           vehicle_no_of_pass,
                 vehicle.unladen_wt           vehicle_unladen_wt,
                 motortype.motor_type_desc    motortyp_motor_type_desc,
                 vehicle.motor_no             vehicle_motor_no,
                 NVL(vehicle.towing, 0)       vehicle_towing,
                 NVL(vehicle.repair_lim, 0)   vehicle_repair_lim,
                 vehicle.repair_lim,          
                 vehicle.series_cd            vehicle_series_cd,
                 vehicle.make_cd              vehicle_make_cd,
                 vehicle.car_company_cd       vehicle_car_company_cd,
                 eng.engine_series            
                 /**** END VEHICLE ****/               
            FROM GIXX_ITEM            b480, 
                 GIIS_CURRENCY        b110,
                 GIIS_COVERAGE        coverage,
                 GIXX_VEHICLE         vehicle,      --vehicle
                 GIIS_TYPE_OF_BODY    bodytype,     --vehicle
                 GIIS_MC_SUBLINE_TYPE sublinetype,  --vehicle
                 GIIS_MOTORTYPE       motortype,    --vehicle
                 GIIS_MC_CAR_COMPANY  carcoy,       --vehicle
                 GIIS_MC_ENG_SERIES   eng
           WHERE b480.extract_id          = p_extract_id 
             AND b110.main_currency_cd    = b480.currency_cd
             AND b480.coverage_cd         = coverage.coverage_cd(+) -- bonok :: 07.10.2013 :: added (+) for SR: 13618
             /****VEHICLE CONDITIONS****/
             AND vehicle.extract_id       = b480.extract_id
             AND vehicle.item_no          = b480.item_no                    
             AND vehicle.type_of_body_cd  = bodytype.type_of_body_cd(+)
             AND vehicle.subline_cd       = sublinetype.subline_cd(+)
             AND vehicle.subline_type_cd  = sublinetype.subline_type_cd(+)
             AND vehicle.subline_cd       = motortype.subline_cd(+)
             AND vehicle.mot_type         = motortype.type_cd(+)
             AND vehicle.car_company_cd   = carcoy.car_company_cd(+)
             AND vehicle.series_cd        = eng.series_cd(+)
             AND vehicle.make_cd          = eng.make_cd(+)
             AND vehicle.car_company_cd   = eng.car_company_cd(+)
             /****END VEHICLE CONDITIONS****/        
        ORDER BY b480.item_no)
     LOOP
        v_item.extract_id          := i.extract_id;
        v_item.item_item_no        := i.item_item_no;
        v_item.item_item_title     := i.item_item_title;
        v_item.item_item_title2       := i.item_item_title2;
        v_item.item_desc           := i.item_desc;
        v_item.item_desc2          := i.item_desc2;
        v_item.item_coverage_cd    := i.item_coverage_cd;
        v_item.item_coverage_desc  := i.item_coverage_desc;
        v_item.item_currency_desc  := i.item_currency_desc;
        v_item.item_other_info     := i.item_other_info;
        v_item.vehicle_assignee                := i.vehicle_assignee;
        v_item.vehicle_origin                  := i.vehicle_origin;
        v_item.vehicle_destination             := i.vehicle_destination;
        v_item.vehicle_model_year              := i.vehicle_model_year;
        v_item.vehicle_car_coy                 := i.vehicle_car_coy;
        v_item.vehicle_make                    := i.vehicle_make;
        v_item.bodytype_type_of_body           := i.bodytype_type_of_body;
        v_item.vehicle_color                   := i.vehicle_color;
        v_item.vehicle_mv_file_no              := i.vehicle_mv_file_no;
        v_item.vehicle_coc_no                  := i.vehicle_coc_no;
        v_item.vehicle_coc_issue_date          := i.vehicle_coc_issue_date;    
        v_item.vehicle_coc_serial_no           := i.vehicle_coc_serial_no;
        v_item.vehicle_serial_no               := i.vehicle_serial_no;
        v_item.sublinetype_subline_type_desc   := i.sublinetype_subline_type_desc;
        v_item.vehicle_acquired_from           := i.vehicle_acquired_from;
        v_item.vehicle_plate_no                := i.vehicle_plate_no;
        v_item.vehicle_no_of_pass              := i.vehicle_no_of_pass;
        v_item.vehicle_unladen_wt              := i.vehicle_unladen_wt;
        v_item.motortyp_motor_type_desc        := i.motortyp_motor_type_desc;
        v_item.vehicle_motor_no                := i.vehicle_motor_no;
        v_item.vehicle_towing                  := i.vehicle_towing;
        v_item.vehicle_repair_lim              := i.vehicle_repair_lim;
        v_item.repair_lim                      := i.repair_lim;
        v_item.vehicle_series_cd               := i.vehicle_series_cd;
        v_item.vehicle_make_cd                 := i.vehicle_make_cd;
        v_item.vehicle_car_company_cd          := i.vehicle_car_company_cd;  
        v_item.f_towing                        := GET_TOW_LIMIT(p_extract_id, i.item_item_no);
        v_item.f_make                          := TRIM(i.vehicle_car_coy||' '|| i.vehicle_make||' '|| i.engine_series);  
        v_item.vehicle_deductibles               := get_item_deductibles(p_extract_id, i.item_item_no);
		--added by robert 04.17.2013
		v_item.assignee_label := 'N'; 
        if v_item.vehicle_assignee is not null or  v_item.vehicle_acquired_from is not null then
           v_item.assignee_label := 'Y';
        end if;
		
       PIPE ROW(v_item);
     END LOOP;
     RETURN;
   END get_pol_doc_mc_item;
   /* This function obtains item informations for marine cargo line including cargo and vessel details
         This does not work for non-cargo lines.
      Created by: BRYAN JOSEPH ABULUYAN
      Date: April 14, 2010
   */
   FUNCTION get_pol_doc_mn_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
     RETURN pol_doc_mn_item_tab PIPELINED IS
     v_item                     pol_doc_mn_item_type;
     v_vessel                    giis_vestype.vestype_desc%TYPE;
     v_geog_desc                  giis_geog_class.geog_desc%TYPE;
     v_cargo_class                giis_cargo_class.cargo_class_desc%TYPE;
     v_decltn                      gixx_open_policy.decltn_no%type;
     v_cp_deduct_text            GIIS_DOCUMENT.TEXT%TYPE;
     v_cnt                        NUMBER(10);
     v_show_peril                VARCHAR2(1) := 'Y';
   BEGIN     
     FOR i IN (
          SELECT b480.extract_id    extract_id, 
                 b480.item_no       item_item_no,
                 b480.item_no || ' - ' || LTRIM (b480.item_title) item_item_title,
                 b480.item_title item_item_title2,
                 b480.item_desc     item_desc, 
                 b480.item_desc2    item_desc2,
                 b480.coverage_cd   item_coverage_cd,
                 b110.currency_desc item_currency_desc,
                 b480.other_info    item_other_info,
                 C.ITEM_NO CARGO_ITEM_NO, 
                 C.GEOG_CD CARGO_GEOG_CD,          
                 C.CARGO_CLASS_CD CARGO_CLASS_CD,
                 C.VESSEL_CD CARGO_VESEL_CD,        
                 C.BL_AWB CARGO_BL_AWB,
                 C.ORIGIN CARGO_ORIGIN,
                 C.ETD    CARGO_ETD,
                 C.DESTN  CARGO_DESTN,        
                 C.ETA    CARGO_ETA,
                 C.DEDUCT_TEXT CARGO_DEDUCT_TEXT,
                 C.PACK_METHOD  CARGO_PACK_METHOD,
                 C.PRINT_TAG CARGO_PRINT_TAG,            
                 C.LC_NO CARGO_LC_NO,
                 C.TRANSHIP_ORIGIN CARGO_TRANSHIP_ORIGIN,      
                 C.TRANSHIP_DESTINATION CARGO_TRANSHIP_DEST,     
                 C.VOYAGE_NO CARGO_VOYAGE_NO
            FROM GIXX_ITEM     b480, 
                 GIIS_CURRENCY b110,
                 GIXX_CARGO C
           WHERE b480.extract_id       = p_extract_id 
             AND b110.main_currency_cd = b480.currency_cd
             AND c.EXTRACT_ID(+)       = b480.extract_id
             AND c.ITEM_NO(+)           = b480.item_no
        ORDER BY b480.item_no)
     LOOP
        BEGIN
          SELECT VESSEL_CD,
                    DECODE(VESSEL_CD, 'MULTI', VESSEL_NAME, VESSEL_NAME || ' (' || 
                            DECODE(VESSEL_FLAG, 'V', 'VESSEL',
                        DECODE(VESSEL_FLAG, 'I', 'INLAND', 'AIRCRAFT')) || ')' ),
                    MOTOR_NO,
                 SERIAL_NO, 
                 PLATE_NO, 
                 VESTYPE_CD
            INTO v_item.vessel_vessel_cd,            
                   v_item.vessel_vessel_name,
                   v_item.vessel_motor_no,
                 v_item.vessel_serial_no,
                   v_item.vessel_plate_no,
                   v_item.vessel_vestype_cd
            FROM GIIS_VESSEL
           WHERE vessel_cd = i.CARGO_VESEL_CD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
         SELECT vestype_desc
          INTO v_vessel
            FROM giis_vestype
         WHERE vestype_cd = v_item.vessel_vestype_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
        SELECT geog_desc
          INTO v_geog_desc
          FROM giis_geog_class
         WHERE geog_cd = i.cargo_geog_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
        SELECT cargo_class_desc   
          INTO v_cargo_class     
          FROM giis_cargo_class
         WHERE cargo_class_cd = i.cargo_class_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
          SELECT decltn_no
            INTO v_decltn
            FROM gixx_open_policy
           WHERE extract_id = p_extract_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
          FOR ded IN (SELECT ALL DECODE(deductibles.deductible_text, NULL, deduct_desc.deductible_text, deductibles.deductible_text) deductibles_deductible_text         
                        FROM GIXX_DEDUCTIBLES     DEDUCTIBLES, 
                               GIIS_DEDUCTIBLE_DESC DEDUCT_DESC,
                               GIIS_PERIL           PERIL
                       WHERE deductibles.ded_deductible_cd  = deduct_desc.deductible_cd (+)
                         AND deductibles.ded_subline_cd     = deduct_desc.subline_cd (+)
                           AND deductibles.ded_line_cd        = deduct_desc.line_cd (+)
                           AND deductibles.ded_line_cd        = peril.line_cd (+)
                           AND deductibles.peril_cd           = peril.peril_cd (+)
                           AND deductibles.extract_id         = i.extract_id
                           AND deductibles.item_no             = i.item_item_no)
          LOOP
              v_cp_deduct_text := ded.deductibles_deductible_text;
          END LOOP;
          SELECT NVL(COUNT(*),0) cnt
            INTO v_cnt               
            FROM GIXX_DEDUCTIBLES                 DEDUCTIBLES, 
                   GIIS_DEDUCTIBLE_DESC         DEDUCT_DESC,
                  GIIS_PERIL                PERIL
           WHERE DEDUCTIBLES.DED_DEDUCTIBLE_CD  = DEDUCT_DESC.DEDUCTIBLE_CD (+)
             AND DEDUCTIBLES.DED_SUBLINE_CD     = DEDUCT_DESC.SUBLINE_CD (+)
                AND DEDUCTIBLES.DED_LINE_CD        = DEDUCT_DESC.LINE_CD (+)
                AND DEDUCTIBLES.DED_LINE_CD        = PERIL.LINE_CD (+)
                AND DEDUCTIBLES.PERIL_CD           = PERIL.PERIL_CD (+)
                AND DEDUCTIBLES.EXTRACT_ID = i.extract_id
             AND DEDUCTIBLES.ITEM_NO    = i.item_item_no;
          IF (v_cp_deduct_text = 'ZERO DEDUCTIBLE' OR v_cp_deduct_text = 'Zero Deductible') AND v_cnt = 1  THEN
            v_item.show_ded_text := 'N';
          ELSIF v_cnt = 0 THEN
            v_item.show_ded_text := 'N';
          ELSE
            v_item.show_ded_text := 'Y';
          END IF;
        END;
        /*    show_peril */
        BEGIN
            v_show_peril := 'N';
            FOR a IN (
                SELECT co_insurance_sw
                  FROM gixx_polbasic
                 WHERE extract_id = p_extract_id)
            LOOP
                IF a.co_insurance_sw = 1 THEN
                    FOR x IN (
                        SELECT extract_id
                          FROM gixx_itmperil
                         WHERE extract_id = p_extract_id
                           AND item_no = i.item_item_no)
                    LOOP
                        v_show_peril := 'Y';
                        EXIT;
                    END LOOP;
                ELSE
                    FOR x IN (
                        SELECT extract_id
                          FROM gixx_orig_itmperil
                         WHERE extract_id = p_extract_id
                           AND item_no = i.item_item_no)
                    LOOP
                        v_show_peril := 'Y';
                        EXIT;
                    END LOOP;
                END IF;                
            END LOOP;
        END;
        v_item.extract_id                := i.extract_id;
        v_item.item_item_no                 := i.item_item_no;
        v_item.item_item_title              := i.item_item_title;
        v_item.item_item_title2                := i.item_item_title2;
        v_item.item_desc                    := i.item_desc;
        v_item.item_desc2                   := i.item_desc2;
        v_item.item_coverage_cd             := i.item_coverage_cd;
        v_item.item_currency_desc           := i.item_currency_desc;
        v_item.item_other_info              := i.item_other_info;
        v_item.CARGO_ITEM_NO               := i.CARGO_ITEM_NO;
          v_item.CARGO_GEOG_CD               := i.CARGO_GEOG_CD;
          v_item.CARGO_CLASS_CD               := i.CARGO_CLASS_CD;
          v_item.CARGO_VESEL_CD               := i.CARGO_VESEL_CD;
          v_item.CARGO_BL_AWB               := i.CARGO_BL_AWB;
          v_item.CARGO_ORIGIN               := i.CARGO_ORIGIN;
          v_item.CARGO_ETD                   := i.CARGO_ETD;
          v_item.CARGO_DESTN                    := i.CARGO_DESTN;
          v_item.CARGO_ETA                   := i.CARGO_ETA;
          v_item.CARGO_DEDUCT_TEXT           := i.CARGO_DEDUCT_TEXT;
          v_item.CARGO_PACK_METHOD           := i.CARGO_PACK_METHOD;
          v_item.CARGO_PRINT_TAG                := i.CARGO_PRINT_TAG;
          v_item.CARGO_LC_NO                    := i.CARGO_LC_NO;
          v_item.CARGO_TRANSHIP_ORIGIN      := i.CARGO_TRANSHIP_ORIGIN;
          v_item.CARGO_TRANSHIP_DEST           := i.CARGO_TRANSHIP_DEST;
          v_item.CARGO_VOYAGE_NO                 := i.CARGO_VOYAGE_NO;
        v_item.cargo_geog_desc              := v_geog_desc;
        v_item.vessel_desc                  := v_vessel; 
        v_item.cargo_class                 := v_cargo_class;
        v_item.item_declaration_no         := v_decltn;
        v_item.ccarrier_exists             := GIXX_CARGO_CARRIER_PKG.check_ccarrier_exist(p_extract_id); 
        v_item.f_item_curr_cd             := GIPI_CARGO_PKG.get_cargo_item_currency(p_extract_id, i.item_item_no);
        v_item.f_inv_value                 := GIPI_CARGO_PKG.get_inv_value(p_extract_id, i.item_item_no);  
        v_item.f_markup_rate             := GIPI_CARGO_PKG.get_markup_rate(p_extract_id, i.item_item_no); 
        v_item.f_inv_curr_rt             := GIPI_CARGO_PKG.get_inv_curr_rt(p_extract_id, i.item_item_no);
        v_item.f_inv_curr_cd             := GIPI_CARGO_PKG.get_inv_currency(p_extract_id, i.item_item_no); 
        v_item.f_agreed_value             := GIPI_CARGO_PKG.get_agreed_value(p_extract_id, i.item_item_no); 
        v_item.f_item_tsi_amt             := RTRIM(LTRIM(TO_CHAR(GIXX_ITMPERIL_PKG.get_mn_tsi_amt_total(p_extract_id, i.item_item_no), '999,999,999,999,999.99')));
        v_item.f_item_prem_amt             := RTRIM(LTRIM(TO_CHAR(GIXX_ITMPERIL_PKG.get_mn_prem_amt_total(p_extract_id, i.item_item_no), '999,999,999,999,999.99')));
        v_item.f_item_short_name         := GIIS_CURRENCY_PKG.get_item_short_name(p_extract_id);
        v_item.f_peril_exists             := COUNT_PERIL_ITEM(p_extract_id, i.item_item_no);
        v_item.ded_exists                 := GIXX_DEDUCTIBLES_PKG.is_exist(p_extract_id, i.item_item_no);
        v_item.show_peril                := v_show_peril;
           PIPE ROW(v_item);
     END LOOP;
     RETURN;
   END get_pol_doc_mn_item;
   FUNCTION get_itmperil_tsi_amt (p_extract_id  GIXX_ITEM.extract_id%TYPE,
                                  p_item_no     GIXX_ITEM.item_no%TYPE,
                                  p_itmperil_tsi_amt GIXX_ITEM.tsi_amt%TYPE)
      RETURN NUMBER
   IS
      v_currency_rt       gipi_item.currency_rt%TYPE;
      v_policy_currency   gixx_invoice.policy_currency%TYPE;
   BEGIN
      FOR a IN
          (SELECT a.currency_rt, NVL (policy_currency, 'N') policy_currency
             FROM gixx_item b, 
                  gixx_invoice a
            WHERE a.extract_id = b.extract_id
              AND a.extract_id = p_extract_id
              AND b.item_no    = p_item_no)
      LOOP
         v_currency_rt     := a.currency_rt;
         v_policy_currency := a.policy_currency;
      END LOOP;
      IF NVL (v_policy_currency, 'N') = 'Y' THEN
         RETURN (NVL (p_itmperil_tsi_amt, 0));
      ELSE
         RETURN (NVL ((p_itmperil_tsi_amt * NVL (v_currency_rt, 1)), 0));
      END IF;
   END;    
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 19, 2010
**  Reference By : 
**  Description  : Function to get casualty item records which is used in policy document report. 
*/     
  FUNCTION get_pol_doc_ca_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
    RETURN pol_doc_ca_item_tab PIPELINED IS
    v_casualty  pol_doc_ca_item_type;
  BEGIN
    FOR i IN (
          SELECT item.extract_id, item.item_no, item.item_title, item.item_desc,
                 item.item_desc2, item.coverage_cd, currency.currency_desc,
                 item.other_info, 
                 casualty.location                  casualty_location,
                 casualty.capacity_cd               casualty_capacity_cd,
                 pos.position                       capacity,
                 casualty.section_or_hazard_info    casualty_hazard_info,
                 casualty.section_line_cd           casualty_line_cd,
                 casualty.section_subline_cd        casualty_subline_cd,
                 casualty.section_or_hazard_cd      casualty_hazard_cd,
                 hazard.section_or_hazard_title     hazard_title,
                 casualty.limit_of_liability        casualty_liability,
                 casualty.interest_on_premises      casualty_interest,
                 casualty.conveyance_info           casualty_conveyance,
                 casualty.property_no_type          casualty_property_type,
                 casualty.property_no               casualty_property_no,
                 item.from_date                     itemca_from_date,
                 item.to_date                       itemca_to_date
            FROM gixx_item          item, 
                 giis_currency      currency,
                 gixx_casualty_item casualty,
                 giis_position      pos,
                 giis_section_or_hazard hazard
           WHERE item.extract_id           = p_extract_id 
             AND item.extract_id           = casualty.extract_id (+)
             AND item.item_no              = casualty.item_no (+)
             AND currency.main_currency_cd = item.currency_cd
             AND casualty.capacity_cd      = pos.position_cd (+)
             AND casualty.section_line_cd      = hazard.section_line_cd (+)
             AND casualty.section_subline_cd   = hazard.section_subline_cd (+)
             AND casualty.section_or_hazard_cd = hazard.section_or_hazard_cd (+)
        ORDER BY item.item_no)
    LOOP
        v_casualty.extract_id             := i.extract_id;
        v_casualty.item_no                := i.item_no; 
        v_casualty.item_title             := i.item_title; 
        v_casualty.item_desc              := i.item_desc;
        v_casualty.item_desc2             := i.item_desc2; 
        v_casualty.coverage_cd            := i.coverage_cd;
        v_casualty.currency_desc          := i.currency_desc;
        v_casualty.other_info             := i.other_info;
        v_casualty.casualty_location      := i.casualty_location;
        v_casualty.casualty_capacity_cd   := i.casualty_capacity_cd;
        v_casualty.capacity               := i.capacity;
        v_casualty.casualty_hazard_info   := i.casualty_hazard_info;
        v_casualty.casualty_line_cd       := i.casualty_line_cd;
        v_casualty.casualty_subline_cd    := i.casualty_subline_cd;
        v_casualty.casualty_hazard_cd     := i.casualty_hazard_cd;
        v_casualty.hazard_title           := i.hazard_title;
        v_casualty.casualty_liability     := i.casualty_liability;
        v_casualty.casualty_interest      := i.casualty_interest;
        v_casualty.casualty_conveyance    := i.casualty_conveyance;
        v_casualty.casualty_property_type := i.casualty_property_type;
        v_casualty.casualty_property_no   := i.casualty_property_no;
        v_casualty.itemca_from_date       := i.itemca_from_date;
        v_casualty.itemca_to_date         := i.itemca_to_date;
      PIPE ROW(v_casualty);
    END LOOP;
    RETURN;
  END;  
  FUNCTION get_pol_doc_en_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
    RETURN pol_doc_en_item_tab PIPELINED IS
    v_item  pol_doc_en_item_type; 
    --v_ded    VARCHAR2(1) := 'N';
  BEGIN
    FOR i IN (SELECT a.extract_id extract_id            
                    ,a.item_no item_item_no
                    ,a.item_title item_item_title
                    ,a.item_desc item_item_desc
                    ,a.item_desc2 item_item_desc2
                    ,a.coverage_cd item_coverage_cd
                    ,b.currency_desc item_currency_desc
                    ,a.other_info item_other_info
                    ,TO_CHAR(LENGTH(a.item_title)) item_title_length
               FROM gixx_item a,
                    giis_currency b
              WHERE b.main_currency_cd = a.currency_cd
                AND a.extract_id        = p_extract_id
                ORDER BY a.item_no)
    LOOP
      --gixx_location details
      BEGIN
        SELECT province_cd,
               region_cd
          INTO v_item.province_cd,
               v_item.region_cd
          FROM GIXX_LOCATION
         WHERE extract_id        = p_extract_id
             AND item_no         = i.item_item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      --giis_province details
      BEGIN
        SELECT province_desc
          INTO v_item.province_desc
          FROM GIIS_PROVINCE
         WHERE province_cd = v_item.province_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      --giis_region details
      BEGIN
        SELECT region_desc
          INTO v_item.region_desc
          FROM GIIS_REGION
         WHERE region_cd = v_item.region_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      --show_ded
      v_item.show_ded := 'N';
      FOR count_rec in (
            SELECT deductible_text
              FROM gixx_deductibles
             WHERE extract_id = i.extract_id
               AND item_no    = i.item_item_no) 
      LOOP
        --v_ded := 'Y';
        v_item.show_ded := 'Y';
        EXIT;
      END LOOP;
      v_item.extract_id          := i.extract_id;
      v_item.item_item_no          := i.item_item_no;
      v_item.item_item_title      := i.item_item_title;
      v_item.item_item_desc      := i.item_item_desc;
      v_item.item_item_desc2      := i.item_item_desc2;
      v_item.item_coverage_cd      := i.item_coverage_cd;
      v_item.item_currency_desc  := i.item_currency_desc;
      v_item.item_other_info      := i.item_other_info;
      --v_item.province_cd          := i.province_cd;
      --v_item.region_cd              := i.region_cd;
      --v_item.province_desc          := i.province_desc;
      --v_item.region_desc          := i.region_desc;
      v_item.item_title_length     := i.item_title_length;
      --v_item.show_ded             := v_ded;
      PIPE ROW(v_item);
    END LOOP;
    RETURN;
  END get_pol_doc_en_item;  
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 26, 2010
**  Reference By : 
**  Description  : Function to get accident item records which is used in policy document report. 
*/   
  FUNCTION get_pol_doc_ah_item (p_extract_id GIXX_ITEM.extract_id%TYPE)
    RETURN pol_doc_ah_item_tab PIPELINED IS
    v_accident pol_doc_ah_item_type;
  BEGIN
    FOR i IN (
        SELECT item.extract_id, item.item_no,
               item.item_title, item.item_desc,
               item.item_desc2, item.coverage_cd,
               currency.currency_desc,
               item.other_info,
               TO_CHAR (item.from_date, 'fmMonth DD, RRRR')
                   || DECODE(item.to_date, NULL, '', ' to ')
                   || TO_CHAR (item.to_date, 'fmMonth DD, RRRR') item_date_of_travel,
               item.from_date, item.to_date,
               acitem.age acitem_age,
               DECODE (acitem.sex, 'M', 'MALE', 'F', 'FEMALE', NULL) acitem_sex,
               acitem.height acitem_height, acitem.weight acitem_weight,
               acitem.date_of_birth acitem_date_of_birth,
               DECODE (acitem.civil_status,
                       'D', 'DIVORCED',
                       'L', 'LEGALLY SEPARATED',
                       'M', 'MARRIED',
                       'S', 'SINGLE',
                       'W', 'WIDOW(ER)',
                       NULL
                      ) acitem_civil_status,
               acitem.monthly_salary,       
               LTRIM (TO_CHAR (acitem.monthly_salary, '999,999,990.99'))
               || DECODE (NVL (acitem.salary_grade, ' '),
                          ' ', ' ',
                          ' / ' || acitem.salary_grade
                         ) acitem_monthly_salary,
               acitem.salary_grade  acitem_salary_grade,
               acitem.no_of_persons acitem_no_of_persons,
               acitem.destination   acitem_destination,
               acitem.position_cd   acitem_position_cd,
               position.position
          FROM gixx_item            item,
               giis_currency        currency,
               gixx_accident_item   acitem,
               giis_position        position               
         WHERE item.extract_id           = p_extract_id
           AND item.extract_id           = acitem.extract_id
           AND item.item_no              = acitem.item_no
           AND acitem.position_cd        = position.position_cd (+)
           AND currency.main_currency_cd = item.currency_cd
      ORDER BY item.item_no)
    LOOP
        v_accident.extract_id            := i.extract_id;
        v_accident.item_no               := i.item_no;
        v_accident.item_title            := i.item_title;
        v_accident.item_desc             := i.item_desc;
        v_accident.item_desc2            := i.item_desc2;
        v_accident.coverage_cd           := i.coverage_cd;
        v_accident.currency_desc         := i.currency_desc;
        v_accident.other_info            := i.other_info;
        v_accident.item_date_of_travel   := i.item_date_of_travel;
        v_accident.from_date             := i.from_date;
        v_accident.to_date               := i.to_date;
        v_accident.acitem_age            := i.acitem_age;
        v_accident.acitem_sex            := i.acitem_sex;
        v_accident.acitem_height         := i.acitem_height;
        v_accident.acitem_weight         := i.acitem_weight;
        v_accident.acitem_date_of_birth  := i.acitem_date_of_birth;
        v_accident.acitem_civil_status   := i.acitem_civil_status;
        v_accident.monthly_salary := i.monthly_salary;
        v_accident.acitem_monthly_salary := i.acitem_monthly_salary;
        v_accident.acitem_salary_grade   := i.acitem_salary_grade;
        v_accident.acitem_no_of_persons  := i.acitem_no_of_persons;
        v_accident.acitem_destination    := i.acitem_destination;
        v_accident.acitem_position_cd    := i.acitem_position_cd;
        v_accident.position              := i.position;
      PIPE ROW(v_accident);
    END LOOP;
    RETURN;
  END get_pol_doc_ah_item;  
  FUNCTION get_pol_doc_mh_item (p_extract_id GIXX_ITEM.extract_id%TYPE)
    RETURN pol_doc_mh_item_tab PIPELINED IS
    v_item                        pol_doc_mh_item_type;
  BEGIN
    FOR i IN (SELECT B480.EXTRACT_ID EXTRACT_ID            
                    ,B480.ITEM_NO ITEM_ITEM_NO
                    ,B480.ITEM_NO||' - '||B480.ITEM_TITLE ITEM_ITEM_TITLE
                    ,B480.ITEM_TITLE ITEM_ITEM_TITLE2   --added by ging082906
                    ,B480.ITEM_DESC ITEM_DESC
                    ,B480.ITEM_DESC2 ITEM_DESC2
                    ,B480.COVERAGE_CD ITEM_COVERAGE_CD
                    ,B110.CURRENCY_DESC ITEM_CURRENCY_DESC
                    ,B480.OTHER_INFO ITEM_OTHER_INFO
                FROM GIXX_ITEM B480,
                     GIIS_CURRENCY B110
               WHERE B110.MAIN_CURRENCY_CD = B480.CURRENCY_CD
                 AND B480.EXTRACT_ID = P_EXTRACT_ID
               ORDER BY B480.ITEM_NO)
    LOOP
      BEGIN
        SELECT ITEM_NO,              
               VESSEL_CD, 
               DEDUCT_TEXT, 
               GEOG_LIMIT
          INTO v_item.ves_item_no,
               v_item.ves_vessel_cd,
               v_item.ves_deduct_text,
               v_item.ves_geog_limit
          FROM GIXX_ITEM_VES  
         WHERE EXTRACT_ID = i.extract_id
           AND ITEM_NO = i.item_item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      BEGIN
        SELECT VESSEL_CD,
               VESSEL_NAME,
               VESTYPE_CD,
               VESS_CLASS_CD,
               HULL_TYPE_CD,
               LTRIM(TO_CHAR(GROSS_TON, '99,999,990.99')),
               LTRIM(TO_CHAR(NET_TON, '99,999,990.99')),
               YEAR_BUILT,
               DEADWEIGHT,
               DRY_PLACE,
               NO_CREW,
               VESSEL_LENGTH,       
               VESSEL_BREADTH,      
               VESSEL_DEPTH,
               DRY_DATE
          INTO V_ITEM.VESSEL_VESSEL_CD,
               V_ITEM.VESSEL_VESSEL_NAME,
               V_ITEM.VESSEL_VESTYPE_CD,
               V_ITEM.VESSEL_CLASS_CD,
               V_ITEM.VESSEL_HULL_TYPE_CD,
               V_ITEM.VESSEL_GROSS_TON,
               V_ITEM.VESSEL_NET_TON,
               V_ITEM.VESSEL_YEAR_BUILT,
               V_ITEM.VESSEL_DEADWEIGHT,
               V_ITEM.VESSEL_DRY_PLACE,
               V_ITEM.VESSEL_NO_CREW,
               V_ITEM.VESSEL_LENGTH,       
               V_ITEM.VESSEL_BREADTH,      
               V_ITEM.VESSEL_DEPTH,
                  V_ITEM.VESSEL_DRY_DATE
          FROM GIIS_VESSEL
         WHERE VESSEL_CD = v_item.ves_vessel_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      BEGIN
         SELECT vestype_desc
          INTO v_item.vestype_desc
            FROM giis_vestype
         WHERE vestype_cd = v_item.vessel_vestype_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      BEGIN
        SELECT vess_class_desc
          INTO v_item.vess_class_desc
          FROM giis_vess_class
         WHERE vess_class_cd = v_item.vessel_class_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      BEGIN
        SELECT hull_desc
          INTO v_item.hull_desc
          FROM giis_hull_type
         WHERE hull_type_cd = V_ITEM.VESSEL_HULL_TYPE_CD;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      v_item.extract_id              := i.extract_id;
      v_item.item_item_no              := i.item_item_no;
      v_item.item_item_title          := i.item_item_title;
      v_item.item_item_title2          := i.item_item_title2;
      v_item.item_desc                   := i.item_desc;
      v_item.item_desc2               := i.item_desc2;
      v_item.item_coverage_cd          := i.item_coverage_cd;
      v_item.item_currency_desc      := i.item_currency_desc;
      v_item.item_other_info          := i.item_other_info;
      PIPE ROW(v_item);
    END LOOP;
    RETURN;
  END get_pol_doc_mh_item;
  /* This will be used for other sections outside of the ITEM_<LINE_NAME> subreport that repeats per GIXX_ITEM entry
   * BRYAN 04.30.2010
   */
   FUNCTION get_items(p_extract_id GIXX_ITEM.extract_id%TYPE)
     RETURN item_tab PIPELINED IS
     v_item                      item_type;
     v_cnt                        NUMBER(10);
     v_cp_deduct_text            GIIS_DOCUMENT.TEXT%TYPE;
   BEGIN
     FOR i IN (SELECT EXTRACT_ID, 
                      ITEM_NO 
                 FROM GIXX_ITEM 
                WHERE EXTRACT_ID = p_extract_id)
     LOOP
       BEGIN
          FOR ded IN (SELECT ALL DECODE(deductibles.deductible_text, NULL, deduct_desc.deductible_text, deductibles.deductible_text) deductibles_deductible_text         
                        FROM GIXX_DEDUCTIBLES     DEDUCTIBLES, 
                               GIIS_DEDUCTIBLE_DESC DEDUCT_DESC,
                               GIIS_PERIL           PERIL
                       WHERE deductibles.ded_deductible_cd  = deduct_desc.deductible_cd (+)
                         AND deductibles.ded_subline_cd     = deduct_desc.subline_cd (+)
                           AND deductibles.ded_line_cd        = deduct_desc.line_cd (+)
                           AND deductibles.ded_line_cd        = peril.line_cd (+)
                           AND deductibles.peril_cd           = peril.peril_cd (+)
                           AND deductibles.extract_id         = i.extract_id
                           AND deductibles.item_no             = i.item_no)
          LOOP
              v_cp_deduct_text := ded.deductibles_deductible_text;
          END LOOP;
          SELECT NVL(COUNT(*),0) cnt
            INTO v_cnt               
            FROM GIXX_DEDUCTIBLES                 DEDUCTIBLES, 
                   GIIS_DEDUCTIBLE_DESC         DEDUCT_DESC,
                  GIIS_PERIL                PERIL
           WHERE DEDUCTIBLES.DED_DEDUCTIBLE_CD  = DEDUCT_DESC.DEDUCTIBLE_CD (+)
             AND DEDUCTIBLES.DED_SUBLINE_CD     = DEDUCT_DESC.SUBLINE_CD (+)
                AND DEDUCTIBLES.DED_LINE_CD        = DEDUCT_DESC.LINE_CD (+)
                AND DEDUCTIBLES.DED_LINE_CD        = PERIL.LINE_CD (+)
                AND DEDUCTIBLES.PERIL_CD           = PERIL.PERIL_CD (+)
                AND DEDUCTIBLES.EXTRACT_ID = i.extract_id
             AND DEDUCTIBLES.ITEM_NO    = i.item_no
             ;
          IF (v_cp_deduct_text = 'ZERO DEDUCTIBLE' OR v_cp_deduct_text = 'Zero Deductible') AND v_cnt = 1  THEN
            v_item.show_ded_text := 'N';
          ELSIF v_cnt = 0 THEN
            v_item.show_ded_text := 'N';
          ELSE
            v_item.show_ded_text := 'Y';
          END IF;
        END;
       v_item.extract_id         := i.extract_id;
       v_item.item_no             := i.item_no;
       v_item.v_cnt                 := v_cnt;
       PIPE ROW(v_item);
     END LOOP;
     RETURN;
   END get_items;
/** START OF PACKAGE POLICY DOCUMENTS GIXX_ITEM FUNCTIONS**/
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 04, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to compute for the tow limit of the motor item record. 
*/
   FUNCTION get_tow_limit_for_pack(p_extract_id IN GIXX_ITEM.extract_id%TYPE,
                                   p_item_no    IN GIXX_ITEM.item_no%TYPE)
      RETURN NUMBER
   IS
      v_tow               NUMBER (16, 2);
      v_repair            NUMBER (16, 2);
      v_policy_currency   gipi_pack_invoice.policy_currency%TYPE;
      v_currency_rt       gipi_item.currency_rt%TYPE;
   BEGIN
      FOR a IN (SELECT b.currency_rt,
                       NVL (a.policy_currency, 'N') policy_currency
                  FROM gixx_item b, gixx_pack_invoice a
                 WHERE b.extract_id = p_extract_id
                   AND a.extract_id = b.extract_id
                   AND item_no = p_item_no)
      LOOP
         v_currency_rt := a.currency_rt;
         v_policy_currency := a.policy_currency;
      END LOOP;
      SELECT NVL(SUM (NVL (towing, 0)), 0)
        INTO v_tow
        FROM gixx_vehicle
       WHERE extract_id = p_extract_id 
         AND item_no    = p_item_no;
      IF NVL (v_policy_currency, 'N') = 'Y'
      THEN
         v_repair := (v_tow);
      ELSE
         v_repair := (v_tow * v_currency_rt);
      END IF;
      RETURN (v_repair);
   END;
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 04, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to get the motor car item records which is used in package policy document report. 
*/
   FUNCTION get_pack_pol_doc_mc_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                     p_policy_id  GIXX_ITEM.policy_id%TYPE)
   RETURN pol_doc_mc_item_tab PIPELINED
   IS
   v_item   pol_doc_mc_item_type;
   BEGIN     
    -- d.alcantara, 08162012, inadd itong query sa item para makainclude yung mga records na walang gipi_vehicle sa report
     FOR h IN (
        SELECT  B480.EXTRACT_ID       EXTRACT_ID
                ,B480.POLICY_ID                 POLICY_ID  
                ,B480.pack_line_cd               line_cd      
                ,B480.ITEM_NO                    SORT_ITEM_NO
                ,B480.ITEM_NO                    ITEM_ITEM_NO
                ,B480.ITEM_NO||' - '||B480.ITEM_TITLE               ITEM_ITEM_TITLE
                ,B480.ITEM_TITLE               ITEM_ITEM_TITLE2 
                ,B480.ITEM_DESC                ITEM_DESC
                ,B480.ITEM_DESC2              ITEM_DESC2
                ,B480.COVERAGE_CD	      ITEM_COVERAGE_CD
                ,B110.CURRENCY_DESC   ITEM_CURRENCY_DESC
                ,B480.OTHER_INFO             ITEM_OTHER_INFO
                ,B480.FROM_DATE              ITEM_FROM_DATE
                ,B480.TO_DATE                   ITEM_TO_DATE
                ,B480.CURRENCY_RT         ITEM_CURRENCY_RT      
                ,B480.pack_line_cd               pack_line_cd
                ,'Risk '||B480.RISK_NO||' Item '||B480.RISK_ITEM_NO RISK
                ,B480.TSI_AMT TSI_AMT
                ,B480.RISK_ITEM_NO
                ,B480.RISK_NO
                ,B480.coverage_cd           
                ,COV.coverage_desc        item_coverage_desc
          FROM  GIXX_ITEM           B480,
                GIIS_CURRENCY       B110,
                GIIS_COVERAGE       COV 
         WHERE B110.MAIN_CURRENCY_CD = B480.CURRENCY_CD
           AND B480.EXTRACT_ID = p_extract_id
           AND B480.policy_id = p_policy_id
           AND B480.coverage_cd        = COV.coverage_cd(+)
         order by SORT_ITEM_NO
     ) LOOP
        v_item.extract_id                      := h.extract_id;
        v_item.item_item_no                    := h.item_item_no;
        v_item.item_item_title                 := h.item_item_title;
        v_item.item_item_title2                := h.item_item_title2;
        v_item.item_desc                       := h.item_desc;
        v_item.item_desc2                      := h.item_desc2;
        v_item.item_coverage_cd                := h.item_coverage_cd;
        v_item.item_coverage_desc              := h.item_coverage_desc;
        v_item.item_other_info                 := h.item_other_info;
        
            --to initialize additional details value
--            v_item.extract_id                      := null;
--            v_item.item_item_no                    := null;
--            v_item.item_item_title                 := null;
--            v_item.item_item_title2                := null;
--            v_item.item_desc                       := null;
--            v_item.item_desc2                      := null;
--            v_item.item_coverage_cd                := null;
--            v_item.item_coverage_desc              := null;
--            v_item.item_other_info                 := null;
--            v_item.vehicle_assignee                := null;
--            v_item.vehicle_origin                  := null;
--            v_item.vehicle_destination             := null;
--            v_item.vehicle_model_year              := null;
--            v_item.vehicle_car_coy                 := null;
--            v_item.vehicle_make                    := null;
--            v_item.bodytype_type_of_body           := null;
--            v_item.vehicle_color                   := null;
--            v_item.vehicle_mv_file_no              := null;
--            v_item.vehicle_coc_no                  := null;
--            v_item.vehicle_coc_issue_date          := null;
--            v_item.vehicle_coc_serial_no           := null;
--            v_item.vehicle_serial_no               := null;
--            v_item.sublinetype_subline_type_desc   := null;
--            v_item.vehicle_acquired_from           := null;
--            v_item.vehicle_plate_no                := null;
--            v_item.vehicle_no_of_pass              := null;
--            v_item.vehicle_unladen_wt              := null;
--            v_item.motortyp_motor_type_desc        := null;
--            v_item.vehicle_motor_no                := null;
--            v_item.vehicle_towing                  := null;
--            v_item.vehicle_repair_lim              := null;
--            v_item.repair_lim                      := null;
--            v_item.vehicle_series_cd               := null;
--            v_item.vehicle_make_cd                 := null;
--            v_item.vehicle_car_company_cd          := null;
--            v_item.f_towing                        := null;
--            v_item.f_make                          := null;

        
        FOR i IN (
            SELECT ITEM.extract_id                    extract_id, 
                   ITEM.item_no                       item_item_no,
                   ITEM.item_no || ' - ' || LTRIM (ITEM.item_title) item_item_title,
                   ITEM.item_title                    item_item_title2,
                   ITEM.item_desc                     item_desc, 
                   ITEM.item_desc2                    item_desc2,
                   ITEM.coverage_cd                   item_coverage_cd,
                   COVERAGE.coverage_desc             item_coverage_desc,
                   ITEM.other_info                    item_other_info,
                   VEHICLE.policy_id                  policy_id,
                   VEHICLE.item_no                    vehicle_item_no, 
                   VEHICLE.assignee                   vehicle_assignee, 
                   VEHICLE.origin                     vehicle_origin, 
                   VEHICLE.destination                vehicle_destination, 
                   VEHICLE.model_year                 vehicle_model_year, 
                   CARCOY.car_company                 vehicle_car_coy,
                   VEHICLE.make                       vehicle_make, 
                   BODYTYPE.type_of_body              bodytype_type_of_body, 
                   VEHICLE.color                      vehicle_color, 
                   VEHICLE.mv_file_no                 vehicle_mv_file_no, 
                   LPAD(VEHICLE.coc_serial_no, 7, 0) || '-' || LPAD  (VEHICLE.coc_yy, 2, 0)  vehicle_coc_no, 
                   VEHICLE.coc_issue_date             vehicle_coc_issue_date, 
                   VEHICLE.coc_serial_no              vehicle_coc_serial_no, 
                   VEHICLE.serial_no                  vehicle_serial_no, 
                   SUBLINETYPE.subline_type_desc      sublinetype_subline_type_desc, 
                   VEHICLE.acquired_from              vehicle_acquired_from, 
                   VEHICLE.plate_no                   vehicle_plate_no, 
                   VEHICLE.no_of_pass                 vehicle_no_of_pass, 
                   VEHICLE.unladen_wt                 vehicle_unladen_wt, 
                   MOTORTYPE.motor_type_desc          motortyp_motor_type_desc, 
                   VEHICLE.motor_no                   vehicle_motor_no, 
                   NVL(VEHICLE.towing, 0)             vehicle_towing, 
                   NVL(VEHICLE.repair_lim,0)          vehicle_repair_lim,
                   VEHICLE.repair_lim                 repair_lim,
                   VEHICLE.series_cd                  vehicle_series_cd,
                   VEHICLE.make_cd                    vehicle_make_cd,
                   VEHICLE.car_company_cd             vehicle_car_company_cd,
                   ENG.engine_series                  engine_series
              FROM GIXX_ITEM                          ITEM, 
                   GIIS_COVERAGE                      COVERAGE,
                   GIXX_VEHICLE                       VEHICLE, 
                   GIIS_TYPE_OF_BODY                  BODYTYPE, 
                   GIIS_MC_SUBLINE_TYPE               SUBLINETYPE, 
                   GIIS_MOTORTYPE                     MOTORTYPE,
                   GIIS_MC_CAR_COMPANY                CARCOY,
                   GIIS_MC_ENG_SERIES                 ENG
             WHERE VEHICLE.extract_id      = p_extract_id 
               AND VEHICLE.policy_id       = p_policy_id
               AND VEHICLE.item_no         = h.ITEM_ITEM_NO
               AND ITEM.extract_id         = VEHICLE.extract_id(+)
               AND ITEM.policy_id          = VEHICLE.policy_id(+)
               AND ITEM.item_no            = VEHICLE.item_no(+)   
               AND ITEM.coverage_cd        = COVERAGE.coverage_cd(+)
               AND VEHICLE.type_of_body_cd = BODYTYPE.type_of_body_cd (+)  
               AND VEHICLE.subline_cd      = SUBLINETYPE.subline_cd (+)
               AND VEHICLE.subline_type_cd = SUBLINETYPE.subline_type_cd (+)
               AND VEHICLE.subline_cd      = MOTORTYPE.subline_cd (+)
               AND VEHICLE.mot_type        = MOTORTYPE.type_cd (+)
               AND VEHICLE.car_company_cd  = CARCOY.car_company_cd(+)
               AND VEHICLE.series_cd       = ENG.series_cd(+)
               AND VEHICLE.make_cd         = ENG.make_cd(+)
               AND VEHICLE.car_company_cd  = ENG.car_company_cd(+)
             ORDER BY ITEM.item_no)
         LOOP
            v_item.extract_id                      := i.extract_id;
            v_item.item_item_no                    := i.item_item_no;
            v_item.item_item_title                 := i.item_item_title;
            v_item.item_item_title2                   := i.item_item_title2;
            v_item.item_desc                       := i.item_desc;
            v_item.item_desc2                      := i.item_desc2;
            v_item.item_coverage_cd                := i.item_coverage_cd;
            v_item.item_coverage_desc              := i.item_coverage_desc;
            v_item.item_other_info                 := i.item_other_info;
            v_item.vehicle_assignee                := i.vehicle_assignee;
            v_item.vehicle_origin                  := i.vehicle_origin;
            v_item.vehicle_destination             := i.vehicle_destination;
            v_item.vehicle_model_year              := i.vehicle_model_year;
            v_item.vehicle_car_coy                 := i.vehicle_car_coy;
            v_item.vehicle_make                    := i.vehicle_make;
            v_item.bodytype_type_of_body           := i.bodytype_type_of_body;
            v_item.vehicle_color                   := i.vehicle_color;
            v_item.vehicle_mv_file_no              := i.vehicle_mv_file_no;
            v_item.vehicle_coc_no                  := i.vehicle_coc_no;
            v_item.vehicle_coc_issue_date          := i.vehicle_coc_issue_date;    
            v_item.vehicle_coc_serial_no           := i.vehicle_coc_serial_no;
            v_item.vehicle_serial_no               := i.vehicle_serial_no;
            v_item.sublinetype_subline_type_desc   := i.sublinetype_subline_type_desc;
            v_item.vehicle_acquired_from           := i.vehicle_acquired_from;
            v_item.vehicle_plate_no                := i.vehicle_plate_no;
            v_item.vehicle_no_of_pass              := i.vehicle_no_of_pass;
            v_item.vehicle_unladen_wt              := i.vehicle_unladen_wt;
            v_item.motortyp_motor_type_desc        := i.motortyp_motor_type_desc;
            v_item.vehicle_motor_no                := i.vehicle_motor_no;
            v_item.vehicle_towing                  := i.vehicle_towing;
            v_item.vehicle_repair_lim              := i.vehicle_repair_lim;
            v_item.repair_lim                      := i.repair_lim;
            v_item.vehicle_series_cd               := i.vehicle_series_cd;
            v_item.vehicle_make_cd                 := i.vehicle_make_cd;
            v_item.vehicle_car_company_cd          := i.vehicle_car_company_cd;  
            v_item.f_towing                        := GET_TOW_LIMIT_FOR_PACK(p_extract_id, i.item_item_no);
            v_item.f_make                          := TRIM(i.vehicle_car_coy||' '|| i.vehicle_make||' '|| i.engine_series);  
			EXIT;
         END LOOP;
         PIPE ROW(v_item);
         
     END LOOP;

     RETURN;
   END get_pack_pol_doc_mc_item;
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 05, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to get the engineering item records which is used in package policy document report. 
*/
 FUNCTION get_pack_pol_doc_en_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                   p_policy_id  GIXX_ITEM.policy_id%TYPE)
    RETURN pol_doc_en_item_tab PIPELINED IS
    v_item  pol_doc_en_item_type; 
  BEGIN
    FOR i IN (SELECT a.extract_id extract_id
                    ,a.policy_id  policy_id
                    ,a.item_no item_item_no
                    ,a.item_title item_item_title
                    ,a.item_desc item_item_desc
                    ,a.item_desc2 item_item_desc2
                    ,a.coverage_cd item_coverage_cd
                    ,b.currency_desc item_currency_desc
                    ,a.other_info item_other_info
                    ,TO_CHAR(LENGTH(a.item_title)) item_title_length
               FROM gixx_item a,
                    giis_currency b
              WHERE b.main_currency_cd = a.currency_cd
                AND a.extract_id        = p_extract_id
                AND a.policy_id           = p_policy_id
              ORDER BY a.item_no)
    LOOP
      --gixx_location details
      BEGIN
        SELECT province_cd,
               region_cd
          INTO v_item.province_cd,
               v_item.region_cd
          FROM GIXX_LOCATION
         WHERE extract_id        = p_extract_id
           AND policy_id       = i.policy_id
           AND item_no         = i.item_item_no;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      --giis_province details
      BEGIN
        SELECT province_desc
          INTO v_item.province_desc
          FROM GIIS_PROVINCE
         WHERE province_cd = v_item.province_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      --giis_region details
      BEGIN
        SELECT region_desc
          INTO v_item.region_desc
          FROM GIIS_REGION
         WHERE region_cd = v_item.region_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
      --show_ded
      v_item.show_ded := 'N';
      FOR count_rec in (
            SELECT deductible_text
              FROM gixx_deductibles
             WHERE extract_id = i.extract_id
               AND item_no    = i.item_item_no) 
      LOOP
        v_item.show_ded := 'Y';
        EXIT;
      END LOOP;
      v_item.extract_id          := i.extract_id;
      v_item.item_item_no          := i.item_item_no;
      v_item.item_item_title      := i.item_item_title;
      v_item.item_item_desc      := i.item_item_desc;
      v_item.item_item_desc2      := i.item_item_desc2;
      v_item.item_coverage_cd      := i.item_coverage_cd;
      v_item.item_currency_desc  := i.item_currency_desc;
      v_item.item_other_info      := i.item_other_info;
      v_item.item_title_length     := i.item_title_length;
      PIPE ROW(v_item);
    END LOOP;
    RETURN;
 END get_pack_pol_doc_en_item;
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 06, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to get the marine cargo item records which is used in package policy document report. 
*/
 FUNCTION get_pack_pol_doc_mn_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                   p_policy_id  GIXX_ITEM.policy_id%TYPE) 
     RETURN pol_doc_mn_item_tab PIPELINED IS
     v_item                     pol_doc_mn_item_type;
     v_vessel                   GIIS_VESTYPE.vestype_desc%TYPE;
     v_geog_desc                GIIS_GEOG_CLASS.geog_desc%TYPE;
     v_cargo_class              GIIS_CARGO_CLASS.cargo_class_desc%TYPE;
     v_decltn                   GIXX_OPEN_POLICY.decltn_no%type;
     v_cp_deduct_text           GIIS_DOCUMENT.TEXT%TYPE;
     v_cnt                      NUMBER(10);
   BEGIN     
     FOR i IN (
            SELECT ITEM.extract_id    extract_id,
                   ITEM.policy_id     policy_id, 
                   ITEM.item_no       item_item_no,
                   ITEM.item_no || ' - ' || LTRIM (ITEM.item_title) item_item_title,
                   ITEM.item_title    item_item_title2,
                   ITEM.item_desc     item_desc, 
                   ITEM.item_desc2    item_desc2,
                   ITEM.coverage_cd   item_coverage_cd,
                   CURRENCY.currency_desc item_currency_desc,
                   ITEM.other_info    item_other_info/*,    
                   C.item_no          cargo_item_no, 
                   C.geog_cd          cargo_geog_cd,          
                   C.cargo_class_cd   cargo_class_cd,
                   C.vessel_cd        cargo_vesel_cd,        
                   C.bl_awb           cargo_bl_awb,
                   C.origin           cargo_origin,
                   C.etd              cargo_etd,
                   C.destn            cargo_destn,        
                   C.eta              cargo_eta,
                   C.deduct_text      cargo_deduct_text,
                   C.pack_method      cargo_pack_method,
                   C.print_tag        cargo_print_tag,            
                   C.lc_no            cargo_lc_no,
                   C.tranship_origin  cargo_tranship_origin,      
                   C.tranship_destination cargo_tranship_dest,     
                   C.voyage_no        cargo_voyage_no*/
            FROM GIXX_ITEM     ITEM, 
                 GIIS_CURRENCY CURRENCY/*,
                 GIXX_CARGO C*/
            WHERE ITEM.extract_id           = p_extract_id
              AND ITEM.policy_id            = p_policy_id
              AND CURRENCY.main_currency_cd = ITEM.currency_cd/*
              AND C.extract_id(+)           = ITEM.extract_id
              AND C.policy_id(+)            = ITEM.policy_id
              AND C.item_no(+)              = ITEM.item_no*/
            ORDER BY ITEM.item_no)
     LOOP
		BEGIN
			SELECT C.item_no          cargo_item_no, 
                   C.geog_cd          cargo_geog_cd,          
                   C.cargo_class_cd   cargo_class_cd,
                   C.vessel_cd        cargo_vesel_cd,        
                   C.bl_awb           cargo_bl_awb,
                   C.origin           cargo_origin,
                   C.etd              cargo_etd,
                   C.destn            cargo_destn,        
                   C.eta              cargo_eta,
                   C.deduct_text      cargo_deduct_text,
                   C.pack_method      cargo_pack_method,
                   C.print_tag        cargo_print_tag,            
                   C.lc_no            cargo_lc_no,
                   C.tranship_origin  cargo_tranship_origin,      
                   C.tranship_destination cargo_tranship_dest,     
                   C.voyage_no        cargo_voyage_no
			  INTO  v_item.cargo_item_no,
				    v_item.cargo_geog_cd,
					v_item.cargo_class_cd,
					v_item.cargo_vesel_cd,
					v_item.cargo_bl_awb,
					v_item.cargo_origin,
					v_item.cargo_etd,
					v_item.cargo_destn,
					v_item.cargo_eta,
					v_item.cargo_deduct_text,
					v_item.cargo_pack_method,
					v_item.cargo_print_tag,
					v_item.cargo_lc_no,
					v_item.cargo_tranship_origin,
					v_item.cargo_tranship_dest,
					v_item.cargo_voyage_no
		      FROM GIXX_CARGO C
			 WHERE extract_id = p_extract_id
			   AND policy_id = p_policy_id
			   AND item_no = i.item_item_no;
		EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
		END;
	 
        BEGIN
          SELECT vessel_cd,
                 DECODE(vessel_cd, 'MULTI', vessel_name, vessel_name || ' (' || 
                 DECODE(vessel_flag, 'V', 'VESSEL',
                 DECODE(vessel_flag, 'I', 'INLAND', 'AIRCRAFT')) || ')' ),
                 motor_no,
                 serial_no, 
                 plate_no, 
                 vestype_cd
            INTO v_item.vessel_vessel_cd,            
                 v_item.vessel_vessel_name,
                 v_item.vessel_motor_no,
                 v_item.vessel_serial_no,
                 v_item.vessel_plate_no,
                 v_item.vessel_vestype_cd
            FROM GIIS_VESSEL
           WHERE vessel_cd = v_item.cargo_vesel_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
         SELECT vestype_desc
            INTO v_vessel
            FROM GIIS_VESTYPE
         WHERE vestype_cd = v_item.vessel_vestype_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
        SELECT geog_desc
          INTO v_geog_desc
          FROM GIIS_GEOG_CLASS
         WHERE geog_cd = v_item.cargo_geog_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
        SELECT cargo_class_desc   
          INTO v_cargo_class     
          FROM GIIS_CARGO_CLASS
         WHERE cargo_class_cd = v_item.cargo_class_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        BEGIN
          SELECT decltn_no
            INTO v_decltn
            FROM GIXX_OPEN_POLICY
           WHERE extract_id = p_extract_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
        END;
        v_item.extract_id                   := i.extract_id;
        v_item.item_item_no                 := i.item_item_no;
        v_item.item_item_title              := i.item_item_title;
        v_item.item_item_title2             := i.item_item_title2;
        v_item.item_desc                    := i.item_desc;
        v_item.item_desc2                   := i.item_desc2;
        v_item.item_coverage_cd             := i.item_coverage_cd;
        v_item.item_currency_desc           := i.item_currency_desc;
        v_item.item_other_info              := i.item_other_info;
        /*v_item.cargo_item_no                := i.cargo_item_no;
        v_item.cargo_geog_cd                := i.cargo_geog_cd;
        v_item.cargo_class_cd               := i.cargo_class_cd;
        v_item.cargo_vesel_cd               := i.cargo_vesel_cd;
        v_item.cargo_bl_awb                 := i.cargo_bl_awb;
        v_item.cargo_origin                 := i.cargo_origin;
        v_item.cargo_etd                    := i.cargo_etd;
        v_item.cargo_destn                  := i.cargo_destn;
        v_item.cargo_eta                    := i.cargo_eta;
        v_item.cargo_deduct_text            := i.cargo_deduct_text;
        v_item.cargo_pack_method            := i.cargo_pack_method;
        v_item.cargo_print_tag              := i.cargo_print_tag;
        v_item.cargo_lc_no                  := i.cargo_lc_no;
        v_item.cargo_tranship_origin        := i.cargo_tranship_origin;
        v_item.cargo_tranship_dest          := i.cargo_tranship_dest;
        v_item.cargo_voyage_no              := i.cargo_voyage_no;*/
        v_item.cargo_geog_desc              := v_geog_desc;
        v_item.vessel_desc                  := v_vessel; 
        v_item.cargo_class                  := v_cargo_class;
        v_item.item_declaration_no          := v_decltn;
        v_item.ccarrier_exists              := GIXX_CARGO_CARRIER_PKG.check_ccarrier_exist(p_extract_id); 
        v_item.ded_exists                   := GIXX_DEDUCTIBLES_PKG.is_exist(p_extract_id, i.item_item_no);
       PIPE ROW(v_item);
     END LOOP;
     RETURN;
   END get_pack_pol_doc_mn_item;
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 07, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to get the casualty item records which is used in package policy document report. 
*/
  FUNCTION get_pack_pol_doc_ca_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_ca_item_tab PIPELINED IS
    v_casualty  pol_doc_ca_item_type;
   BEGIN
        FOR i IN (
              SELECT item.extract_id, item.item_no, item.item_title, item.item_desc,
                     item.item_desc2, item.coverage_cd, currency.currency_desc,
                     item.other_info, 
                     casualty.location                  casualty_location,
                     casualty.capacity_cd               casualty_capacity_cd,
                     pos.position                       capacity,
                     casualty.section_or_hazard_info    casualty_hazard_info,
                     casualty.section_line_cd           casualty_line_cd,
                     casualty.section_subline_cd        casualty_subline_cd,
                     casualty.section_or_hazard_cd      casualty_hazard_cd,
                     hazard.section_or_hazard_title     hazard_title,
                     casualty.limit_of_liability        casualty_liability,
                     casualty.interest_on_premises      casualty_interest,
                     casualty.conveyance_info           casualty_conveyance,
                     casualty.property_no_type          casualty_property_type,
                     casualty.property_no               casualty_property_no,
                     item.from_date                     itemca_from_date,
                     item.to_date                       itemca_to_date
                FROM gixx_item          item, 
                     giis_currency      currency,
                     gixx_casualty_item casualty,
                     giis_position      pos,
                     giis_section_or_hazard hazard
               WHERE item.extract_id           = p_extract_id
                 AND item.policy_id            = p_policy_id
                 AND item.extract_id           = casualty.extract_id (+)
                 AND item.policy_id            = casualty.policy_id (+)
                 AND item.item_no              = casualty.item_no (+)
                 AND currency.main_currency_cd = item.currency_cd
                 AND casualty.capacity_cd      = pos.position_cd (+)
                 AND casualty.section_line_cd      = hazard.section_line_cd (+)
                 AND casualty.section_subline_cd   = hazard.section_subline_cd (+)
                 AND casualty.section_or_hazard_cd = hazard.section_or_hazard_cd (+)
            ORDER BY item.item_no)
        LOOP
            v_casualty.extract_id             := i.extract_id;
            v_casualty.item_no                := i.item_no; 
            v_casualty.item_title             := i.item_title; 
            v_casualty.item_desc              := i.item_desc;
            v_casualty.item_desc2             := i.item_desc2; 
            v_casualty.coverage_cd            := i.coverage_cd;
            v_casualty.currency_desc          := i.currency_desc;
            v_casualty.other_info             := i.other_info;
            v_casualty.casualty_location      := i.casualty_location;
            v_casualty.casualty_capacity_cd   := i.casualty_capacity_cd;
            v_casualty.capacity               := i.capacity;
            v_casualty.casualty_hazard_info   := i.casualty_hazard_info;
            v_casualty.casualty_line_cd       := i.casualty_line_cd;
            v_casualty.casualty_subline_cd    := i.casualty_subline_cd;
            v_casualty.casualty_hazard_cd     := i.casualty_hazard_cd;
            v_casualty.hazard_title           := i.hazard_title;
            v_casualty.casualty_liability     := i.casualty_liability;
            v_casualty.casualty_interest      := i.casualty_interest;
            v_casualty.casualty_conveyance    := i.casualty_conveyance;
            v_casualty.casualty_property_type := i.casualty_property_type;
            v_casualty.casualty_property_no   := i.casualty_property_no;
            v_casualty.itemca_from_date       := i.itemca_from_date;
            v_casualty.itemca_to_date         := i.itemca_to_date;
          PIPE ROW(v_casualty);
        END LOOP;
    RETURN;
   END;
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 08, 2011
**  Reference By :  Package Policy Document
**  Description  : Function to get the accident item records which is used in package policy document report. 
*/
  FUNCTION get_pack_pol_doc_ah_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_ah_item_tab PIPELINED
  IS
    v_accident pol_doc_ah_item_type;
  BEGIN
    FOR i IN (
        SELECT item.extract_id, item.item_no,
               item.item_title, item.item_desc,
               item.item_desc2, item.coverage_cd,
               currency.currency_desc,
               item.other_info,
               TO_CHAR (item.from_date, 'fmMonth DD, RRRR')
                   || DECODE(item.to_date, NULL, '', ' to ')
                   || TO_CHAR (item.to_date, 'fmMonth DD, RRRR') item_date_of_travel,
               item.from_date, item.to_date,
               acitem.age acitem_age,
               DECODE (acitem.sex, 'M', 'MALE', 'F', 'FEMALE', NULL) acitem_sex,
               acitem.height acitem_height, acitem.weight acitem_weight,
               acitem.date_of_birth acitem_date_of_birth,
               DECODE (acitem.civil_status,
                       'D', 'DIVORCED',
                       'L', 'LEGALLY SEPARATED',
                       'M', 'MARRIED',
                       'S', 'SINGLE',
                       'W', 'WIDOW(ER)',
                       NULL
                      ) acitem_civil_status,
               acitem.monthly_salary,       
               LTRIM (TO_CHAR (acitem.monthly_salary, '999,999,990.99'))
               || DECODE (NVL (acitem.salary_grade, ' '),
                          ' ', ' ',
                          ' / ' || acitem.salary_grade
                         ) acitem_monthly_salary,
               acitem.salary_grade  acitem_salary_grade,
               acitem.no_of_persons acitem_no_of_persons,
               acitem.destination   acitem_destination,
               acitem.position_cd   acitem_position_cd,
               position.position
          FROM gixx_item            item,
               giis_currency        currency,
               gixx_accident_item   acitem,
               giis_position        position               
         WHERE item.extract_id           = p_extract_id
           AND item.policy_id            = p_policy_id
           AND item.extract_id           = acitem.extract_id(+)
           AND item.policy_id            = acitem.policy_id(+)
           AND item.item_no              = acitem.item_no(+)
           AND acitem.position_cd        = position.position_cd (+)
           AND currency.main_currency_cd = item.currency_cd
      ORDER BY item.item_no)
    LOOP
        v_accident.extract_id            := i.extract_id;
        v_accident.item_no               := i.item_no;
        v_accident.item_title            := i.item_title;
        v_accident.item_desc             := i.item_desc;
        v_accident.item_desc2            := i.item_desc2;
        v_accident.coverage_cd           := i.coverage_cd;
        v_accident.currency_desc         := i.currency_desc;
        v_accident.other_info            := i.other_info;
        v_accident.item_date_of_travel   := i.item_date_of_travel;
        v_accident.from_date             := i.from_date;
        v_accident.to_date               := i.to_date;
        v_accident.acitem_age            := i.acitem_age;
        v_accident.acitem_sex            := i.acitem_sex;
        v_accident.acitem_height         := i.acitem_height;
        v_accident.acitem_weight         := i.acitem_weight;
        v_accident.acitem_date_of_birth  := i.acitem_date_of_birth;
        v_accident.acitem_civil_status   := i.acitem_civil_status;
        v_accident.monthly_salary        := i.monthly_salary;
        v_accident.acitem_monthly_salary := i.acitem_monthly_salary;
        v_accident.acitem_salary_grade   := i.acitem_salary_grade;
        v_accident.acitem_no_of_persons  := i.acitem_no_of_persons;
        v_accident.acitem_destination    := i.acitem_destination;
        v_accident.acitem_position_cd    := i.acitem_position_cd;
        v_accident.position              := i.position;
      PIPE ROW(v_accident);
    END LOOP;
    RETURN;
  END get_pack_pol_doc_ah_item;   
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  February 26, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves related item info for GIPIS101 
  */
  FUNCTION get_related_item_info(
        p_extract_id        gixx_item.extract_id%TYPE,
        p_policy_id         gixx_polbasic.policy_id%TYPE
--        p_pack_pol_flag     gixx_polbasic.pack_pol_flag%TYPE,  
--        p_line_cd           giis_line.line_cd%TYPE             
  ) RETURN related_item_info_tab PIPELINED
  IS
        v_item            related_item_info_type;
        v_iss_cd          gipi_polbasic.iss_cd%TYPE;  
        v_line_cd         giis_line.line_cd%TYPE;
        v_menu_line_cd    giis_line.line_cd%TYPE;
        v_pack_pol_flag   gixx_polbasic.pack_pol_flag%TYPE;
        v_pol_line_cd     gixx_polbasic.line_cd%TYPE;
        v_pol_iss_cd      gixx_polbasic.iss_cd%TYPE;
        
        v_line_ac         giis_parameters.param_value_v%TYPE;
        v_line_av         giis_parameters.param_value_v%TYPE;
        v_line_ca         giis_parameters.param_value_v%TYPE;
        v_line_en         giis_parameters.param_value_v%TYPE;
        v_line_fi         giis_parameters.param_value_v%TYPE;
        v_line_mc         giis_parameters.param_value_v%TYPE;
        v_line_mh         giis_parameters.param_value_v%TYPE;
        v_line_mn         giis_parameters.param_value_v%TYPE;
        v_line_su         giis_parameters.param_value_v%TYPE;
  BEGIN
  
    SELECT pack_pol_flag, line_cd, iss_cd
      INTO v_pack_pol_flag, v_pol_line_cd, v_pol_iss_cd
      FROM gipi_polbasic
     WHERE policy_id = p_policy_id;
    
    BEGIN
      SELECT a.param_value_v A, b.param_value_v B, c.param_value_v C,
             d.param_value_v D, e.param_value_v E, f.param_value_v F,
             g.param_value_v G, h.param_value_v H, i.param_value_v I
        INTO v_line_ac, v_line_av, v_line_ca,
             v_line_en, v_line_fi, v_line_mc,
             v_line_mh, v_line_mn, v_line_su
        FROM giis_parameters a, giis_parameters b, giis_parameters c,
             giis_parameters d, giis_parameters e, giis_parameters f,
             giis_parameters g, giis_parameters h, giis_parameters i
       WHERE a.param_name = 'LINE_CODE_AC'
         AND b.param_name = 'LINE_CODE_AV'
         AND c.param_name = 'LINE_CODE_CA'
         AND d.param_name = 'LINE_CODE_EN'
         AND e.param_name = 'LINE_CODE_FI'
         AND f.param_name = 'LINE_CODE_MC'
         AND g.param_name = 'LINE_CODE_MH'
         AND h.param_name = 'LINE_CODE_MN'
         AND i.param_name = 'LINE_CODE_SU';
         
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_line_ac := 'AC';
            v_line_av := 'AV';
            v_line_ca := 'CA';
            v_line_en := 'EN';
            v_line_fi := 'FI';
            v_line_mc := 'MC';
            v_line_mh := 'MH';
            v_line_mn := 'MN';
            v_line_su := 'SU';
    END;
    
    BEGIN
        FOR iss IN (SELECT param_value_v
                      FROM giis_parameters
                     WHERE param_name = 'ISS_CD_RI')
        LOOP
            v_iss_cd := iss.param_value_v;
            EXIT;
        END LOOP;
        
        SELECT menu_line_cd
          INTO v_menu_line_cd
          FROM giis_line
         WHERE line_cd = v_pol_line_cd;
        
    END;
  
    FOR rec IN (SELECT extract_id, policy_id, 
                       item_grp, item_no, item_title, item_desc, item_desc2,
                       tsi_amt, prem_amt,
                       currency_cd, currency_rt, coverage_cd, group_cd,
                       pack_line_cd, pack_subline_cd
                  FROM gixx_item
                 WHERE extract_id = p_extract_id)
    LOOP
        
        FOR a IN (SELECT coverage_desc
                    FROM giis_coverage
                   WHERE coverage_cd = rec.coverage_cd)
        LOOP
            v_item.coverage_desc := a.coverage_desc;
        END LOOP;
        
        FOR b IN (SELECT currency_desc
                    FROM giis_currency
                   WHERE main_currency_cd = rec.currency_cd)
        LOOP
            v_item.currency_desc := b.currency_desc;
        END LOOP;
        
        IF v_pack_pol_flag = 'Y' THEN 
            v_line_cd := rec.pack_line_cd;
        ELSE 
            v_line_cd := v_pol_line_cd;
        END IF;
        
        IF v_pol_iss_cd = v_iss_cd THEN
            v_item.peril_view_type := 'riPeril';
        ELSE
        
            IF v_line_cd = v_line_fi OR v_menu_line_cd = 'FI' THEN
               v_item.peril_view_type := 'fiPeril';
            ELSIF v_line_cd = v_line_mn OR v_menu_line_cd = 'MN' THEN
               v_item.peril_view_type := 'mnPeril';
            ELSE
               v_item.peril_view_type := 'otherPeril';
            END IF;
            
        END IF;        
        
        --------------
        FOR c IN (SELECT menu_line_cd
                    FROM giis_line
                   WHERE line_cd = v_pol_line_cd)
        LOOP
            IF c.menu_line_cd IS NOT NULL THEN
                v_menu_line_cd := c.menu_line_cd;
            END IF;
            EXIT;
        END LOOP;
        
        IF v_line_cd = v_line_mc OR v_menu_line_cd = 'MC' THEN
            v_item.item_type := 'mcType';
        ELSIF v_line_cd = v_line_ac OR v_menu_line_cd = 'AC' THEN
            v_item.item_type := 'acType';
        ELSIF v_line_cd = v_line_av OR v_menu_line_cd = 'AV' THEN
            v_item.item_type := 'avType';
        ELSIF v_line_cd = v_line_ca OR v_menu_line_cd = 'CA' THEN
            v_item.item_type := 'caType';
        ELSIF v_line_cd = v_line_en OR v_menu_line_cd = 'EN' THEN
            v_item.item_type := 'enType';
        ELSIF v_line_cd = v_line_mn OR v_menu_line_cd = 'MN' THEN
            v_item.item_type := 'mnType';
        ELSIF v_line_cd = v_line_mh OR v_menu_line_cd = 'MH' THEN
            v_item.item_type := 'mhType';
        ELSIF v_line_cd = v_line_fi OR v_menu_line_cd = 'FI' THEN
            v_item.item_type := 'fiType';
        ELSE   
            v_item.item_type := '';
        END IF;
                
        v_item.extract_id := rec.extract_id;
        v_item.policy_id := p_policy_id; --rec.policy_id;
        v_item.item_grp := rec.item_grp;
        v_item.item_no := rec.item_no;
        v_item.item_title := rec.item_title;
        v_item.item_desc := rec.item_desc;
        v_item.item_desc2 := rec.item_desc2;
        v_item.tsi_amt := rec.tsi_amt;
        v_item.prem_amt := rec.prem_amt;
        v_item.currency_cd := rec.currency_cd;
        v_item.currency_rt := rec.currency_rt;
        v_item.coverage_cd := rec.coverage_cd;
        v_item.group_cd := rec.group_cd;
        v_item.pack_line_cd := rec.pack_line_cd;
        v_item.pack_subline_cd := rec.pack_subline_cd;
        v_item.pack_pol_flag := v_pack_pol_flag;
        
        PIPE ROW(v_item);
    END LOOP;
    
  END get_related_item_info;
  
  
  
END GIXX_ITEM_PKG;
/


