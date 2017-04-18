CREATE OR REPLACE PROCEDURE CPI.Validate_Witem(
                       p_par_id          IN  GIPI_PARLIST.par_id%TYPE,
                  p_line_cd            IN  GIPI_PARLIST.line_cd%TYPE,
                  p_subline_cd        IN  GIPI_WPOLBAS.subline_cd%TYPE,
                       p_pack            IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,
                  p_par_type        IN  GIPI_PARLIST.par_type%TYPE,
                  p_msg_alert        OUT VARCHAR2       
                       )
       IS
          v_item_no1   NUMBER := 0 ;
          v_item_no2   NUMBER;
          v_item_no3     NUMBER := 0 ; --**gmi**--
          v_item_no4      NUMBER;    --**gmi**--
          v_exists         VARCHAR2(1) := 'N'; --**gmi**--
  CURSOR witem_cursor IS
         SELECT item_no,item_title,rec_flag,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt
           FROM GIPI_WITEM
          WHERE par_id = p_par_id
       ORDER BY item_no;
--**--gmi 09/26/05--**--          
  CURSOR witem_grp_cursor IS
         SELECT a.item_no,a.grouped_item_no,a.grouped_item_title,b.rec_flag,b.tsi_amt,b.ann_tsi_amt,b.prem_amt,b.ann_prem_amt
           FROM GIPI_WGROUPED_ITEMS a, GIPI_WITEM b          
          WHERE b.par_id = p_par_id 
            AND a.par_id = b.par_id
            AND a.item_no = b.item_no;        
--**--gmi--**--
  CURSOR pack IS
         SELECT pack_line_cd,pack_subline_cd
           FROM GIPI_WPACK_LINE_SUBLINE
          WHERE par_id = p_par_id;
  CURSOR pack_item(p_line_cd GIPI_WITEM.pack_line_cd%TYPE,
                   p_subline GIPI_WITEM.pack_subline_cd%TYPE) IS
         SELECT item_no,item_title,rec_flag,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt,
                pack_line_cd,pack_subline_cd
           FROM GIPI_WITEM
          WHERE par_id = p_par_id
            AND pack_line_cd    = p_line_cd
            AND pack_subline_cd = p_subline;
            
  v_accident_cd          GIIS_PARAMETERS.param_value_v%TYPE;
  v_aviation_cd          GIIS_PARAMETERS.param_value_v%TYPE;      
  v_casualty_cd          GIIS_PARAMETERS.param_value_v%TYPE;                               
  v_engrng_cd          GIIS_PARAMETERS.param_value_v%TYPE;  
  v_fire_cd              GIIS_PARAMETERS.param_value_v%TYPE;  
  v_motor_cd          GIIS_PARAMETERS.param_value_v%TYPE; 
  v_hull_cd              GIIS_PARAMETERS.param_value_v%TYPE;  
  v_cargo_cd          GIIS_PARAMETERS.param_value_v%TYPE;  
  v_surety_cd          GIIS_PARAMETERS.param_value_v%TYPE;
  v_dumm_num          NUMBER := 0;
  v_subline_mop          GIPI_WPOLBAS.subline_cd%TYPE := 'MOP';
  X                      VARCHAR2(2000);
  v_msg_alert          VARCHAR2(2000);
  v_subline_bpv          GIPI_WPOLBAS.subline_cd%TYPE;
  /*Added by: Gzelle 05.06.2014*/
  v_cnt_item_no       NUMBER := 0;  
  v_dumm_item_no      VARCHAR2(2000);  
  v_stat              VARCHAR2(2000);
  v_col               VARCHAR2(2000);    
  v_menu_line_cd     giis_line.menu_line_cd%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_witem program unit
  **  Modified by : Gzelle May 6,2014
  */
  --:gauge.FILE := 'passing validate policy ITEM';
  --vbx_counter;
  
  BEGIN
    SELECT  a.param_value_v  param_a, b.param_value_v  param_b, c.param_value_v  param_c,
                  d.param_value_v  param_d, e.param_value_v  param_e, f.param_value_v  param_f,
                  g.param_value_v  param_g, h.param_value_v  param_h, i.param_value_v  param_i
      INTO  v_accident_cd, v_aviation_cd, v_casualty_cd,
            v_engrng_cd, v_fire_cd, v_motor_cd,
            v_hull_cd, v_cargo_cd, v_surety_cd
    FROM  GIIS_PARAMETERS A, GIIS_PARAMETERS B, GIIS_PARAMETERS C, 
          GIIS_PARAMETERS D, GIIS_PARAMETERS E, GIIS_PARAMETERS F,
          GIIS_PARAMETERS G, GIIS_PARAMETERS H, GIIS_PARAMETERS I
     WHERE  a.param_name = 'LINE_CODE_AC'
       AND  b.param_name = 'LINE_CODE_AV'
       AND  c.param_name = 'LINE_CODE_CA'
       AND  d.param_name = 'LINE_CODE_EN'
       AND  e.param_name = 'LINE_CODE_FI'
       AND  f.param_name = 'LINE_CODE_MC'
       AND  g.param_name = 'LINE_CODE_MH'
       AND  h.param_name = 'LINE_CODE_MN'
       AND  i.param_name = 'LINE_CODE_SU';
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_msg_alert := 'No parameter record found. Please report error to CSD';
       --error_rtn;
  END; 
  
   FOR menu_line IN ( SELECT menu_line_cd code
                        FROM giis_line
                       WHERE line_cd = p_line_cd)
   LOOP
      v_menu_line_cd := menu_line.code;
   END LOOP;    
  
  BEGIN
    SELECT param_value_v
       INTO v_subline_bpv
       FROM GIIS_PARAMETERS
     WHERE param_name = 'BOILER_AND_PRESSURE_VESSEL';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_msg_alert := 'No record in giis_parameters for engrng. subline '||p_subline_cd;
  END;
  
  FOR a IN (SELECT 1
              FROM GIPI_WITMPERL_GROUPED
             WHERE par_id  = p_par_id)
  LOOP
    v_exists := 'Y';
  EXIT;
  END LOOP;                 
            
  IF NOT(p_pack = 'Y') THEN    
   IF p_line_cd IN (v_hull_cd,v_cargo_cd) THEN
        IF v_exists = 'N' THEN --added by gmi
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF    ((witem_cursor_rec.item_title IS NULL) AND (p_par_type = 'P')) THEN
            p_msg_alert := 'Item no. '||TO_CHAR(witem_cursor_rec.item_no)||
                      ' should have an item title';
            --:gauge.FILE := 'Item no. '||TO_CHAR(witem_cursor_rec.item_no)||
                           --' should have an item title';
            --error_rtn;
         END IF;
         --IF NOT (p_line_cd  = v_hull_cd) AND
         IF NOT (NVL(v_menu_line_cd, p_line_cd)  = v_hull_cd) AND
            (NOT (p_par_type = 'E' AND witem_cursor_rec.rec_flag IN ('C','D','A')) AND
                  p_subline_cd != v_subline_mop) THEN
            --validate_wcargo(witem_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                  INTO X
                  FROM GIPI_WCARGO
                 WHERE par_id  = p_par_id AND
              item_no = witem_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_stat := 'no_item';
                v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                v_cnt_item_no := v_cnt_item_no + 1;
            END;
             ELSIF (NVL(v_menu_line_cd, p_line_cd) = v_hull_cd AND p_par_type = 'P') THEN
            --validate_witem_ves(witem_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                INTO X
                FROM GIPI_WITEM_VES
               WHERE par_id  = p_par_id 
                 AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_stat := 'no_item';
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
            END;           
         END IF;
         IF v_stat = 'no_item'
         THEN
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have additional information: '|| SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
            ELSE
                p_msg_alert := 'Item '||SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1)||' should have an additional information.';
            END IF;                                
         END IF; 
        Validate_Witmperl(witem_cursor_rec.item_no, NULL,
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt, witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;
        --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     ELSIF v_exists = 'Y' THEN --added by gmi
     --**--gmi 09/26/05--**--
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF    ((witem_grp_cursor_rec.grouped_item_title IS NULL) AND (p_par_type = 'P')) THEN
            p_msg_alert := 'Grouped Item no. '||TO_CHAR(witem_grp_cursor_rec.grouped_item_no)||
                      ' should have an item title';
            --:gauge.FILE := 'Grouped Item no. '||TO_CHAR(witem_grp_cursor_rec.grouped_item_no)||
                         --  ' should have an item title';
            --error_rtn;
         END IF;
         IF NOT (p_line_cd  = v_hull_cd) AND
            (NOT (p_par_type = 'E' AND witem_grp_cursor_rec.rec_flag IN ('C','D','A')) AND
                  p_subline_cd != v_subline_mop) THEN
            --validate_wcargo(witem_grp_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                  INTO X
                  FROM GIPI_WCARGO
                 WHERE par_id  = p_par_id AND
              item_no = witem_grp_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_msg_alert := 'Item ' || TO_CHAR(witem_grp_cursor_rec.item_no) || 
                   ' should have an additional information.';
            END;
                  ELSIF (p_line_cd = v_hull_cd AND p_par_type = 'P') THEN
            --validate_witem_ves(witem_grp_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                INTO X
                FROM GIPI_WITEM_VES
               WHERE par_id  = p_par_id 
                 AND item_no = witem_grp_cursor_rec.item_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   p_msg_alert := 'Item ' || TO_CHAR(witem_grp_cursor_rec.item_no) ||
                 ' should have an additional information.';
            END;
         END IF;
         Validate_Witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                                                      witem_grp_cursor_rec.rec_flag,
                                   witem_grp_cursor_rec.tsi_amt, witem_grp_cursor_rec.prem_amt,
                                   witem_grp_cursor_rec.ann_tsi_amt, witem_grp_cursor_rec.ann_prem_amt,
                                   p_line_cd,p_par_id,p_par_type,
                                      v_fire_cd,v_hull_cd,v_cargo_cd,
                                      v_msg_alert);
        p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF p_line_cd = v_fire_cd THEN
     IF v_exists = 'N' THEN --added by gmi    
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                         --' should have an item title';
                         --error_rtn;
         END IF;
         /*Modified by: Gzelle 05.07.2014*/
         IF p_par_type = 'P' THEN
            --validate_wfireitm(witem_cursor_rec.item_no);
            BEGIN
                SELECT item_no
                INTO X
                FROM GIPI_WFIREITM    
               WHERE par_id  = p_par_id 
                 AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   --p_msg_alert:= 'Item '||TO_CHAR(witem_cursor_rec.item_no)||
                -- ' should have an additional information.';
                v_stat := 'no_item';
                v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                v_cnt_item_no := v_cnt_item_no + 1;
              WHEN TOO_MANY_ROWS THEN
                NULL;
            END;
            IF v_stat = 'no_item'
            THEN
                IF v_cnt_item_no > 1
                THEN
                    p_msg_alert := 'The following items should have additional information: '|| SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
                ELSE
                    p_msg_alert := 'Item '||SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1)||' should have an additional information.';
                END IF;                                
            END IF;
            IF v_stat IS NULL
            THEN

                BEGIN
                  SELECT NVL(TO_CHAR(risk_no),'A')
                    INTO X
                    FROM GIPI_WITEM    
                   WHERE par_id  = p_par_id 
                     AND item_no = witem_cursor_rec.item_no;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_stat := 'no_risk_no';
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                  WHEN TOO_MANY_ROWS THEN
                    NULL;
                END;
                IF X = 'A' AND Giisp.v('REQUIRE_FI_RISK_NO') ='Y'
                THEN
                    v_stat := 'no_risk_no';
                    v_col := 'Risk No.';
                ELSE
                    BEGIN
                        SELECT NVL(TO_CHAR(fr_item_type),'*')
                          INTO X
                          FROM GIPI_WFIREITM
                         WHERE par_id = p_par_id
                           AND item_no = witem_cursor_rec.item_no;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_stat := 'no_fr_item_type';
                            v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                            v_cnt_item_no := v_cnt_item_no + 1;
                        WHEN TOO_MANY_ROWS THEN
                            NULL;    
                    END;
                    IF X = '*' AND Giisp.v('REQUIRE_FI_FIREITEM_TYPE') ='Y'
                        THEN
                            v_stat := 'no_fr_item_type';
                            v_col := 'Type';
                    ELSE
                        BEGIN
                            SELECT NVL(TO_CHAR(risk_cd),'*')
                              INTO X
                              FROM GIPI_WFIREITM
                             WHERE par_id = p_par_id
                               AND item_no = witem_cursor_rec.item_no;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                v_stat := 'no_risk_tag';
                                v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                                v_cnt_item_no := v_cnt_item_no + 1;
                            WHEN TOO_MANY_ROWS THEN
                                NULL;    
                        END;
                        IF X = '*' AND Giisp.v('REQUIRE_FI_RISK_TAG') ='Y'
                        THEN
                            v_stat := 'no_risk_tag';
                            v_col := 'Risks';
                        ELSE
                            BEGIN
                                SELECT occupancy_cd
                                  INTO X
                                  FROM GIPI_WFIREITM
                                 WHERE par_id = p_par_id
                                   AND item_no = witem_cursor_rec.item_no;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    v_stat := 'no_occupancy';
                                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                                    v_cnt_item_no := v_cnt_item_no + 1;
                                WHEN TOO_MANY_ROWS THEN
                                    NULL;    
                            END;
                            IF X IS NULL AND Giisp.v('REQUIRE_FI_OCCUPANCY') ='Y'
                            THEN
                                v_stat := 'no_occupancy';
                                v_col := 'Occupancy';
                            ELSE
                                BEGIN
                                    SELECT construction_cd
                                      INTO X
                                      FROM GIPI_WFIREITM
                                     WHERE par_id = p_par_id
                                       AND item_no = witem_cursor_rec.item_no;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        v_stat := 'no_construction';
                                        v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                                        v_cnt_item_no := v_cnt_item_no + 1;
                                    WHEN TOO_MANY_ROWS THEN
                                        NULL;    
                                END;
                                IF X IS NULL AND Giisp.v('REQUIRE_FI_CONSTRUCTION') ='Y'
                                THEN
                                    v_stat := 'no_construction';
                                    v_col := 'Construction';
                                ELSE     
                                    BEGIN
                                        SELECT zone_type
                                          INTO X
                                          FROM giis_peril
                                         WHERE zone_type IS NOT NULL
                                           AND zone_type != '4'
                                           AND line_cd = p_line_cd
                                           AND peril_cd IN (SELECT peril_cd
                                                              FROM gipi_witmperl
                                                             WHERE par_id  = p_par_id
                                                               AND item_no = witem_cursor_rec.item_no);
                                    EXCEPTION
                                        WHEN NO_DATA_FOUND THEN
                                            NULL;
                                        WHEN TOO_MANY_ROWS THEN
                                            NULL;    
                                    END;
                                    IF X = '1'
                                    THEN
                                        v_stat := 'no_flood_zone';
                                        v_col := 'Flood zone';
                                    ELSIF X = '2'
                                    THEN
                                        v_stat := 'no_typhoon_zone';
                                        v_col := 'Typhoon zone';
                                    ELSIF X NOT IN ('1','2','4')    
                                    THEN 
                                        v_stat := 'no_eq_zone';
                                        v_col := 'Earthquake zone';                       
                                    END IF;                               
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;                      
            END IF;
            IF v_stat = 'no_risk_no'
            THEN
                FOR i IN (SELECT risk_no, item_no
                            FROM GIPI_WITEM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND risk_no IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                END LOOP;
            ELSIF v_stat = 'no_fr_item_type'
            THEN
               FOR i IN (SELECT fr_item_type, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND fr_item_type IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                END LOOP;  
            ELSIF v_stat = 'no_risk_tag'
            THEN
               FOR i IN (SELECT risk_cd, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND risk_cd IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                END LOOP;
            ELSIF v_stat = 'no_occupancy'
            THEN
               FOR i IN (SELECT occupancy_cd, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND occupancy_cd IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                END LOOP;   
            ELSIF v_stat = 'no_construction'
            THEN
               FOR i IN (SELECT construction_cd, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND construction_cd IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                END LOOP;
            ELSIF v_stat = 'no_flood_zone'
            THEN
                v_stat := NULL;
               FOR i IN (SELECT flood_zone, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND flood_zone IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                    v_stat := 'no_flood_zone';
                END LOOP;  
            ELSIF v_stat = 'no_typhoon_zone'
            THEN
                v_stat := NULL;
               FOR i IN (SELECT typhoon_zone, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND typhoon_zone IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                    v_stat := 'no_typhoon_zone';
                END LOOP;
            ELSIF v_stat = 'no_eq_zone'
            THEN
                v_stat := NULL;
               FOR i IN (SELECT eq_zone, item_no
                            FROM GIPI_WFIREITM    
                           WHERE par_id  = p_par_id 
                             AND item_no = witem_cursor_rec.item_no
                             AND eq_zone IS NULL)
                LOOP
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
                    v_stat := 'no_eq_zone';
                END LOOP;                                                
            END IF;
            IF v_stat IN ('no_risk_no','no_fr_item_type','no_risk_tag','no_occupancy','no_construction','no_flood_zone','no_typhoon_zone','no_eq_zone')
            THEN
                IF v_cnt_item_no > 1
                THEN
                    p_msg_alert := v_col || ' must be entered for items: '|| SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
                ELSE
                    p_msg_alert := v_col|| ' must be entered for item no. '||SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
                END IF;
            END IF;
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no, NULL,       
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,       witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,   witem_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;                           
        --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
         
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                         --' should have an item title';
            --error_rtn;
         END IF;
         IF p_par_type = 'P' THEN
            --validate_wfireitm(witem_grp_cursor_rec.item_no);
            BEGIN
                SELECT item_no
                INTO X
                FROM GIPI_WFIREITM    
               WHERE par_id  = p_par_id 
                 AND item_no = witem_grp_cursor_rec.item_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   p_msg_alert:= 'Item '||TO_CHAR(witem_grp_cursor_rec.item_no)||
                 ' should have an additional information.';
              WHEN TOO_MANY_ROWS THEN
                NULL;
            END;
         END IF;
         Validate_Witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                                              witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF p_line_cd = v_motor_cd THEN
        IF v_exists = 'N' THEN --added by gmi    
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
             --            ' should have an item title';
            --error_rtn;
         END IF;
         IF p_par_type = 'P' THEN
            --validate_wmotcar_item(witem_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                INTO X
               FROM  GIPI_WVEHICLE
               WHERE par_id  = p_par_id 
                 AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  --p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||' should have an additional information.';
                    v_stat := 'no_item';
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
              WHEN TOO_MANY_ROWS THEN
                  NULL;
            END;
            IF v_stat IS NULL
            THEN
                X := NULL;
                BEGIN
                    SELECT TO_CHAR(car_company_cd)
                      INTO X
                     FROM  GIPI_WVEHICLE
                     WHERE par_id  = p_par_id 
                       AND item_no = witem_cursor_rec.item_no;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                        p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||' should have an additional information.';
                  WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                IF X IS NULL AND Giisp.v('REQUIRE_MC_COMPANY') = 'Y'
                THEN
                        v_stat := 'no_car_company_cd';
                END IF;
            END IF;
            IF v_stat = 'no_car_company_cd'
            THEN
                BEGIN
                    FOR i IN (SELECT car_company_cd, item_no
                               FROM  GIPI_WVEHICLE
                               WHERE par_id  = p_par_id 
                                 AND item_no = witem_cursor_rec.item_no
                                 AND car_company_cd IS NULL)
                    LOOP
                        v_cnt_item_no := v_cnt_item_no + 1;
                        v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    END LOOP;
                END;   
            END IF; 
            IF v_stat = 'no_item'
            THEN
                IF v_cnt_item_no > 1
                THEN
                    p_msg_alert := 'The following items should have additional information: '|| SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
                ELSE
                    p_msg_alert := 'Item '||SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1)||' should have an additional information.';
                END IF;
            ELSIF v_stat = 'no_car_company_cd'
            THEN
                IF v_cnt_item_no > 1
                THEN
                    p_msg_alert := 'Car Company must be entered for items: '|| SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
                ELSE
                    p_msg_alert := 'Car Company must be entered for item no. '||SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1)||'.';
                END IF;                
            END IF;
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no, NULL,      
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;                           
        --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
             --            ' should have an item title';
        --error_rtn;
         END IF;
         IF p_par_type = 'P' THEN
            --validate_wmotcar_item(witem_grp_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                  INTO X
                 FROM  GIPI_WVEHICLE
               WHERE par_id  = p_par_id 
                 AND item_no = witem_grp_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  p_msg_alert := 'Item '||TO_CHAR(witem_grp_cursor_rec.item_no)||' should have an additional information.';
              WHEN TOO_MANY_ROWS THEN
                  NULL;
            END;
         END IF;
         Validate_Witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                                              witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF p_line_cd = v_engrng_cd THEN
        IF v_exists = 'N' THEN --added by gmi    
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
             --            ' should have an item title';
            --error_rtn;
         END IF;
         /*IF (p_par_type = 'P') THEN
            IF p_subline_cd = v_subline_bpv THEN
               --validate_wengr_item(witem_cursor_rec.item_no);
               BEGIN
                 SELECT item_no
                     INTO X
                     FROM GIPI_WLOCATION
                  WHERE par_id  = p_par_id 
                    AND item_no = witem_cursor_rec.item_no;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||
                   ' should have an additional information for location.';
                    --:gauge.FILE:='Item '||TO_CHAR(p_item_no)||
                    --        ' should have an additional information for location.';
                    --error_rtn;
                 WHEN TOO_MANY_ROWS THEN
                    NULL;
              END;
            -- made into a comment by GRACE Mar. 30, 2001
            -- deductible information is no longer required for engineering items
            --ELSE
            --   validate_wengr_item2(witem_cursor_rec.item_no);
            END IF;
         END IF;*/ -- Nica 05.29.2012 - Per Mam VJ, temporarily comment out validation of gipi_wlocation for BOILER and PRESSURE Subline
         Validate_Witmperl(witem_cursor_rec.item_no, NULL,     
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;                           
        --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
             --            ' should have an item title';
        --error_rtn;
         END IF;
         /*IF p_par_type = 'P' THEN
            --validate_wengr_item(witem_grp_cursor_rec.item_no);
            BEGIN
                 SELECT item_no
                     INTO X
                     FROM GIPI_WLOCATION
                  WHERE par_id  = p_par_id 
                    AND item_no = witem_grp_cursor_rec.item_no;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    p_msg_alert := 'Item '||TO_CHAR(witem_grp_cursor_rec.item_no)||
                   ' should have an additional information for location.';
                    --:gauge.FILE:='Item '||TO_CHAR(p_item_no)||
                    --        ' should have an additional information for location.';
                    --error_rtn;
                 WHEN TOO_MANY_ROWS THEN
                    NULL;
              END;
         END IF;*/ -- Nica 05.29.2012 - Per Mam VJ, temporarily comment out validation of gipi_wlocation for BOILER and PRESSURE Subline
         Validate_Witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                                              witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF p_line_cd = v_casualty_cd THEN
        IF v_exists = 'N' THEN --added by gmi    
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
              --           ' should have an item title';
            --error_rtn;
         END IF;
         /*Added by Gzelle - 05.06.2014 - To validate additional information of CA PAR (GIPIS207)*/
         IF p_par_type = 'P'
         THEN
            BEGIN
                SELECT item_no
                  INTO X
                 FROM  GIPI_WCASUALTY_ITEM
                 WHERE par_id  = p_par_id 
                   AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                    v_stat := 'no_item';
                    v_dumm_item_no := v_dumm_item_no||TO_CHAR(witem_cursor_rec.item_no)||', ';
                    v_cnt_item_no := v_cnt_item_no + 1;
              WHEN TOO_MANY_ROWS THEN
                    NULL;                
            END;
            IF v_stat IS NULL
            THEN
                X := NULL;
                IF giisp.v('ORA2010_SW') = 'N' THEN -- Added by Jerome 10.10.2016 SR 5606
                BEGIN
                    SELECT TO_CHAR(location_cd)
                      INTO X
                     FROM  GIPI_WCASUALTY_ITEM
                     WHERE par_id  = p_par_id 
                       AND item_no = witem_cursor_rec.item_no;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                        p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||' should have an additional information.';
                  WHEN TOO_MANY_ROWS THEN
                        NULL;
                END;
                END IF;
                IF X IS NULL AND giisp.v('ORA2010_SW') = 'Y'    --added by Gzelle 07282014
                THEN
                        v_stat := 'no_location';
                ELSE
                    BEGIN
                        FOR x IN(SELECT *
                                   FROM GIPI_WCASUALTY_ITEM
                                   WHERE par_id  = p_par_id 
                                     AND item_no = witem_cursor_rec.item_no)
                        LOOP
                            IF x.location IS NULL AND x.section_or_hazard_cd IS NULL AND x.capacity_cd IS NULL AND x.limit_of_liability IS NULL
                            THEN
                                v_stat := 'no_additional';
                            END IF;
                        END LOOP;
                    END;                
                END IF;
            END IF;
            IF v_stat = 'no_location'
            THEN
                BEGIN
                    FOR i IN (SELECT location_cd, item_no
                               FROM  GIPI_WCASUALTY_ITEM
                               WHERE par_id  = p_par_id 
                                 AND item_no = witem_cursor_rec.item_no
                                 AND location_cd IS NULL)
                    LOOP
                        v_cnt_item_no := v_cnt_item_no + 1;
                        v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                    END LOOP;
                END;   
            ELSIF v_stat = 'no_additional'  --added by Gzelle 07282014
            THEN
                BEGIN
                    FOR i IN (SELECT location, section_or_hazard_cd, capacity_cd, limit_of_liability, item_no
                               FROM  GIPI_WCASUALTY_ITEM
                               WHERE par_id  = p_par_id 
                                 AND item_no = witem_cursor_rec.item_no)
                    LOOP
                        IF i.location IS NULL AND i.section_or_hazard_cd IS NULL AND i.capacity_cd IS NULL AND i.limit_of_liability IS NULL
                        THEN
                            v_cnt_item_no := v_cnt_item_no + 1;
                            v_dumm_item_no := v_dumm_item_no||TO_CHAR(i.item_no)||', ';
                        END IF;
                    END LOOP;
                END;                 
            END IF; 
            IF v_stat IS NOT NULL AND giisp.v('ORA2010_SW') = 'N' --Added by Jerome 10.10.2016 SR 5606
            THEN
                IF v_cnt_item_no > 1
                THEN
                    p_msg_alert := 'The following items should have additional information: '|| SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||'.';
                ELSE
                    p_msg_alert := 'Item '||SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1)||' should have an additional information.';
                END IF;
            END IF;            
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no, NULL,     
                                            witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                          p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;         
         --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Grouped Item no. ' || TO_CHAR(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
              --           ' should have an item title';
        --error_rtn;
         END IF;
         Validate_Witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                                              witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     END IF;
     --**--gmi--**--
   ELSE
     IF v_exists = 'N' THEN --added by gmi
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         v_dumm_num := v_dumm_num + 1;
         Validate_Witmperl(witem_cursor_rec.item_no,      NULL,
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;                           
         --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     --**--gmi 09/26/05 --**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF v_dumm_num = 0 THEN
           v_dumm_num := v_dumm_num + 1;
         END IF;
         Validate_Witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,      
                                              witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,      witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,  witem_grp_cursor_rec.ann_prem_amt,
                           p_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
        /*Modified by Gzelle 05.15.2014 GIPIS207*/
        IF v_msg_alert IS NOT NULL
        THEN
            v_dumm_item_no := v_dumm_item_no||TO_CHAR(v_msg_alert)||', ';
            v_cnt_item_no := v_cnt_item_no + 1;
            IF v_cnt_item_no > 1
            THEN
                p_msg_alert := 'The following items should have at least one peril: ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               '.';
            ELSE
                p_msg_alert := 'Item ' || SUBSTR(v_dumm_item_no,1,INSTR(v_dumm_item_no,',',-1)-1) ||
                               ' should have at least one peril.';
            END IF;
        END IF;                           
         --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     END LOOP;
     END IF;
     --**--gmi--**--
   END IF;
  ELSE
   FOR A IN pack LOOP
      IF A.pack_line_cd IN (v_hull_cd,v_cargo_cd) THEN
        FOR B IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF    ((B.item_title IS NULL) AND (p_par_type = 'P')) THEN
            p_msg_alert:= 'Item no. '||TO_CHAR(B.item_no)||
                      ' should have an item title';
            --:gauge.FILE := 'Item no. '||TO_CHAR(B.item_no)||
              --             ' should have an item title';
            --error_rtn;
         END IF;
         IF NOT (B.pack_line_cd  = v_hull_cd) AND
            (NOT (p_par_type = 'E' AND B.rec_flag IN ('C','D','A')) AND
                  B.pack_subline_cd != v_subline_mop) THEN
            --validate_wcargo(B.item_no);
            BEGIN
              SELECT item_no
                  INTO X
                  FROM GIPI_WCARGO
               WHERE par_id  = p_par_id 
                 AND item_no = B.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_msg_alert := 'Item ' || TO_CHAR(B.item_no) || 
                   ' should have an additional information.';
                    --:gauge.FILE:='Item '||TO_CHAR(p_item_no)||' should have an additional information.';
                    --error_rtn;
            END;
     ELSIF (B.pack_line_cd = v_hull_cd AND p_par_type = 'P') THEN
            --validate_witem_ves(B.item_no);
            BEGIN
              SELECT item_no
                INTO X
                FROM GIPI_WITEM_VES
               WHERE par_id  = p_par_id 
                 AND item_no = B.item_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   p_msg_alert := 'Item ' || TO_CHAR(B.item_no) ||
                 ' should have an additional information.';
                    --:gauge.FILE:=('Item ' || TO_CHAR(p_item_no) || ' should have an additional information.');
                    --error_rtn;
            END;
         END IF;
         Validate_Witmperl(B.item_no, NULL,
                                              B.rec_flag,
                           B.tsi_amt, B.prem_amt,
                           B.ann_tsi_amt, B.ann_prem_amt,
                           B.pack_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
        END LOOP;
      ELSIF A.pack_line_cd = v_fire_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                    --     ' should have an item title';
        --error_rtn;
         END IF;
         IF p_par_type = 'P' THEN
            --validate_wfireitm(witem_cursor_rec.item_no);
            BEGIN
                SELECT item_no
                INTO X
                FROM GIPI_WFIREITM    
               WHERE par_id  = p_par_id 
                 AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||
                 ' should have an additional information.';
              WHEN TOO_MANY_ROWS THEN
                   NULL;
            END;
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no,       NULL,
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,       witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,   witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
        END LOOP;
      ELSIF A.pack_line_cd = v_motor_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
             --            ' should have an item title';
           -- error_rtn;
         END IF;
         IF p_par_type = 'P' THEN
            --validate_wmotcar_item(witem_cursor_rec.item_no);
            BEGIN
              SELECT item_no
                  INTO X
                  FROM  GIPI_WVEHICLE
                WHERE par_id  = p_par_id 
                 AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||' should have an additional information.';
              WHEN TOO_MANY_ROWS THEN
                NULL;
            END;
         ELSE --added by kenneth L. 03.27.2014
            BEGIN
               SELECT item_no
                 INTO X
                 FROM  GIPI_WVEHICLE
                WHERE par_id  = p_par_id 
                  AND item_no = witem_cursor_rec.item_no;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||' should have an additional information.';
              WHEN TOO_MANY_ROWS THEN
                NULL;
            END;
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no,      NULL,
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
        END LOOP;
      ELSIF A.pack_line_cd = v_engrng_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
               --          ' should have an item title';
            --error_rtn;
         END IF;
         IF (p_par_type = 'P') THEN
            IF A.pack_subline_cd = v_subline_bpv THEN
               --validate_wengr_item(witem_cursor_rec.item_no);
               BEGIN
                 SELECT item_no
                     INTO X
                     FROM GIPI_WLOCATION
                   WHERE par_id  = p_par_id 
                    AND item_no = witem_cursor_rec.item_no;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    p_msg_alert := 'Item '||TO_CHAR(witem_cursor_rec.item_no)||
                   ' should have an additional information for location.';
                  WHEN TOO_MANY_ROWS THEN
                    NULL;
               END;
            -- made into a comment by GRACE Mar. 30, 2001
            -- deductible information is no longer required for engineering items
            --ELSE
            --   validate_wengr_item2(witem_cursor_rec.item_no);
            END IF;
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no,     NULL,
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
        END LOOP;
      ELSIF A.pack_line_cd = v_casualty_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (p_par_type = 'P') THEN
            p_msg_alert := 'Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title';
            --:gauge.FILE:='Item no. ' || TO_CHAR(WITEM_cursor_rec.ITEM_NO) ||
             --            ' should have an item title';
            --error_rtn;
         END IF;
         Validate_Witmperl(witem_cursor_rec.item_no,     NULL,
                                              witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
        END LOOP;
      ELSE
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         v_dumm_num := v_dumm_num + 1;
         Validate_Witmperl(witem_cursor_rec.item_no,      NULL,
                                            witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd,p_par_id,p_par_type,
                           v_fire_cd,v_hull_cd,v_cargo_cd,
                           v_msg_alert);
         p_msg_alert := NVL(v_msg_alert,p_msg_alert);
        END LOOP;
      END IF;
   END LOOP;
  END IF;
  --added by kenneth L. 02.17.2014 for batch posting
--  IF v_msg_alert IS NOT NULL
--  THEN
--  gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert, 'GIPIS207');
--  p_msg_alert := NVL(v_msg_alert,p_msg_alert);
--  END IF;  
   
  FOR A IN (SELECT  '1'
              FROM  GIIS_SUBLINE
             WHERE  line_cd  =  NVL(v_menu_line_cd, p_line_cd)
               AND  line_cd  =  v_cargo_cd               
               AND  op_flag  =  'Y') LOOP
    IF v_item_no1 = 0 AND p_par_type = 'P' THEN
       p_msg_alert := 'PAR must have a complete Cargo Limits of Liabilities information including PERIL Info.';
       --:gauge.FILE:='PAR must have a complete Cargo Limits of Liabilities information including PERIL Info.';
       --error_rtn;
    END IF;
    EXIT;
  END LOOP;
  IF p_pack != 'Y' THEN
    SELECT COUNT(DISTINCT item_no) INTO v_item_no2
      FROM GIPI_WITMPERL    
     WHERE line_cd = p_line_cd AND
           par_id  = p_par_id;
    FOR a IN (SELECT COUNT(DISTINCT grouped_item_no) grp_count-- INTO v_item_no4
                          FROM GIPI_WITMPERL_GROUPED
                         WHERE line_cd = p_line_cd    
                           AND par_id  = p_par_id
                         GROUP BY item_no) LOOP   
        v_item_no4 := NVL(v_item_no4,0) + a.grp_count;
        END LOOP;                              
--message(v_item_no1||' : '||v_item_no2);message(v_item_no1||' : '||v_item_no2);
--message(v_item_no3||' : '||v_item_no4);message(v_item_no3||' : '||v_item_no4);
   IF ((v_item_no1 != v_item_no2 AND v_item_no1 <> 0) OR (v_item_no3 != v_item_no4 AND v_item_no3 <> 0)) 
               AND p_par_type = 'P' THEN
       --null;
       --ELSE
           IF v_item_no3 != v_item_no4 THEN
               SELECT COUNT(item_no)
                 INTO v_item_no1
                 FROM GIPI_WITEM
                WHERE par_id  = p_par_id;             
           END IF;
           IF v_item_no1 != v_item_no2 THEN
                p_msg_alert := 'No. of items in WITEM not equal to that in WITMPERL.';
           --:gauge.FILE := 'No. of items in WITEM not equal to that in WITMPERL.';
           --error_rtn;                  
      END IF; 
    END IF;
  END IF;
END;
/
