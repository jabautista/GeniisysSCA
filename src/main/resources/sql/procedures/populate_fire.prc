CREATE OR REPLACE PROCEDURE CPI.POPULATE_FIRE(
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wfireitm.par_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id                   RECORDGROUP;
  rg_name                 VARCHAR2(30) := 'GROUP_POLICY';
  rg_count                NUMBER;
  rg_count2               NUMBER;
  rg_col                  VARCHAR2(50) := rg_name || '.policy_id';
  item_exist              VARCHAR2(1); 
  v_row                   NUMBER;
  v_policy_id             gipi_polbasic.policy_id%TYPE;
  v_endt_id               gipi_polbasic.policy_id%TYPE;
  v_district_no           gipi_wfireitm.district_no%TYPE;
  v_eq_zone               gipi_wfireitm.eq_zone%TYPE;
  v_tarf_cd               gipi_wfireitm.tarf_cd%TYPE;
  v_block_no              gipi_wfireitm.block_no%TYPE;
  v_loc_risk1             gipi_wfireitm.loc_risk1%TYPE; 
  v_loc_risk2             gipi_wfireitm.loc_risk2%TYPE;
  v_fr_item_type          gipi_wfireitm.fr_item_type%TYPE;
  v_loc_risk3             gipi_wfireitm.loc_risk3%TYPE;
  v_tariff_zone           gipi_wfireitm.tariff_zone%TYPE;
  v_typhoon_zone          gipi_wfireitm.typhoon_zone%TYPE;
  v_front                 gipi_wfireitm.front%TYPE; 
  v_right                 gipi_wfireitm.right%TYPE;
  v_construction_cd       gipi_wfireitm.construction_cd%TYPE;
  v_left                  gipi_wfireitm.left%TYPE; 
  v_rear                  gipi_wfireitm.rear%TYPE; 
  v_construction_remarks  gipi_wfireitm.construction_remarks%TYPE;
  v_flood_zone            gipi_wfireitm.flood_zone%TYPE;
  v_occupancy_cd          gipi_wfireitm.occupancy_cd%TYPE;
  v_occupancy_remarks     gipi_wfireitm.occupancy_remarks%TYPE;
  v_block_id              gipi_wfireitm.block_id%TYPE;  
  v_assignee              gipi_wfireitm.assignee%TYPE;
  v_risk_cd               gipi_wfireitm.risk_cd%TYPE;
  v_latitude              gipi_wfireitm.latitude%TYPE;  --benjo 01.10.2017 SR-5749
  v_longitude             gipi_wfireitm.longitude%TYPE; --benjo 01.10.2017 SR-5749
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_FIRE program unit 
  */

   GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
      FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                 FROM gipi_polbasic
                WHERE line_cd     =  x_line_cd
                  AND subline_cd  =  x_subline_cd
                  AND iss_cd      =  x_iss_cd
                  AND issue_yy    =  to_char(x_issue_yy)
                  AND pol_seq_no  =  to_char(x_pol_seq_no)
                  AND renew_no    =  to_char(x_renew_no)
                  AND (endt_seq_no = 0 OR 
                      (endt_seq_no > 0 AND 
                      TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                  AND pol_flag In ('1','2','3')
                  AND NVL(endt_seq_no,0) = 0
                ORDER BY eff_date, endt_seq_no)
       LOOP      
          v_policy_id  := b.policy_id;
          FOR DATA IN
              ( SELECT district_no,   eq_zone,            tarf_cd,        block_no,
                   loc_risk1,         loc_risk2,          fr_item_type,   loc_risk3,
                   tariff_zone,       typhoon_zone,       front,          right,
                   construction_cd,   left,               rear,           construction_remarks,
                   flood_zone,        occupancy_cd,       occupancy_remarks, block_id,  assignee,
                   risk_cd,           latitude,           longitude --benjo 01.10.2017 SR-5749
                  FROM gipi_fireitem
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wfireitm
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN         
                 v_district_no           := data.district_no;
                 v_eq_zone               := data.eq_zone;
                 v_tarf_cd               := data.tarf_cd;
                 v_block_no              := data.block_no;
                 v_loc_risk1             := data.loc_risk1; 
                 v_loc_risk2             := data.loc_risk2;
                 v_fr_item_type          := data.fr_item_type;
                 v_loc_risk3             := data.loc_risk3;
                 v_tariff_zone           := data.tariff_zone;
                 v_typhoon_zone          := data.typhoon_zone;
                 v_front                 := data.front; 
                 v_right                 := data.right;
                 v_construction_cd       := data.construction_cd;
                 v_left                  := data.left; 
                 v_rear                  := data.rear; 
                 v_construction_remarks  := data.construction_remarks;
                 v_flood_zone            := data.flood_zone;
                 v_occupancy_cd          := data.occupancy_cd;
                 v_occupancy_remarks     := data.occupancy_remarks;
                 v_block_id              := data.block_id;
                 v_assignee              := data.assignee;
                 v_risk_cd               := data.risk_cd; --added by lhen 031104;
                 v_latitude              := data.latitude;  --benjo 01.10.2017 SR-5749
                 v_longitude             := data.longitude; --benjo 01.10.2017 SR-5749
                 FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                             FROM gipi_polbasic
                          WHERE line_cd     =  x_line_cd
                            AND subline_cd  =  x_subline_cd
                            AND iss_cd      =  x_iss_cd
                            AND issue_yy    =  to_char(x_issue_yy)
                            AND pol_seq_no  =  to_char(x_pol_seq_no)
                            AND renew_no    =  to_char(x_renew_no)
                            AND (endt_seq_no = 0 OR 
                                (endt_seq_no > 0 AND 
                                TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                            AND pol_flag In ('1','2','3')
                            AND NVL(endt_seq_no,0) = 0
                          ORDER BY eff_date, endt_seq_no)
                 LOOP      
                    v_endt_id  := b1.policy_id;
                     FOR DATA2 IN
                              ( SELECT district_no,   eq_zone,            tarf_cd,        block_no,
                                   loc_risk1,         loc_risk2,          fr_item_type,   loc_risk3,
                                   tariff_zone,       typhoon_zone,       front,          right,
                                   construction_cd,   left,               rear,           construction_remarks,
                                   flood_zone,        occupancy_cd,       occupancy_remarks, block_id, assignee,
                                   risk_cd,           latitude,           longitude --benjo 01.10.2017 SR-5749
                                  FROM gipi_fireitem
                                 WHERE item_no = v_item_no 
                                   AND policy_id = v_endt_id
                      ) LOOP
                         v_district_no           := NVL(data2.district_no, v_district_no);
                         v_eq_zone               := NVL(data2.eq_zone, v_eq_zone);
                         v_tarf_cd               := NVL(data2.tarf_cd, v_tarf_cd);
                         v_block_no              := NVL(data2.block_no, v_block_no);
                         IF data2.loc_risk1 IS NOT NULL OR 
                            data2.loc_risk2 IS NOT NULL OR
                            data2.loc_risk3 IS NOT NULL THEN                           
                            v_loc_risk1          := data2.loc_risk1; 
                            v_loc_risk2          := data2.loc_risk2;
                            v_loc_risk3          := data2.loc_risk3;
                         END IF;
                         v_fr_item_type          := NVL(data2.fr_item_type, v_fr_item_type);                 
                         v_tariff_zone           := NVL(data2.tariff_zone, v_tariff_zone);
                         v_typhoon_zone          := NVL(data2.typhoon_zone, v_typhoon_zone);
                         v_front                 := NVL(data2.front, v_front); 
                         v_right                 := NVL(data2.right, v_right);
                         v_construction_cd       := NVL(data2.construction_cd, v_construction_cd);
                         v_left                  := NVL(data2.left, v_left); 
                         v_rear                  := NVL(data2.rear, v_rear); 
                         v_construction_remarks  := NVL(data2.construction_remarks, v_construction_remarks);
                         v_flood_zone            := NVL(data2.flood_zone, v_flood_zone);
                         v_occupancy_cd          := NVL(data2.occupancy_cd, v_occupancy_cd);
                         v_occupancy_remarks     := NVL(data2.occupancy_remarks, v_occupancy_remarks);
                         v_block_id              := NVL(data2.block_id, v_block_id);
                         v_assignee              := NVL(data2.assignee, v_assignee);
                         v_risk_cd               := NVL(data2.risk_cd, v_risk_cd);  --added by lhen 031104);
                         v_latitude              := NVL(data2.latitude, v_latitude);   --benjo 01.10.2017 SR-5749
                         v_longitude             := NVL(data2.longitude, v_longitude); --benjo 01.10.2017 SR-5749
                     END LOOP;
                 END LOOP;        
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying fire info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_wfireitm (
                          par_id,               item_no,        district_no,
                          eq_zone,              tarf_cd,        block_no,
                          loc_risk1,            loc_risk2,      fr_item_type,
                          loc_risk3,            tariff_zone,    typhoon_zone,
                          front,                right,          construction_cd,
                          left,                 rear,           construction_remarks,
                          flood_zone,           occupancy_cd,   occupancy_remarks,
                          block_id,             assignee,       risk_cd, /*added by lhen 031104*/
                          latitude,             longitude) --benjo 01.10.2017 SR-5749
                    VALUES(p_new_par_id,        v_item_no,      v_district_no,
                            v_eq_zone,          v_tarf_cd,      v_block_no,
                            v_loc_risk1,        v_loc_risk2,    v_fr_item_type,
                            v_loc_risk3,        v_tariff_zone,  v_typhoon_zone,
                            v_front,            v_right,        v_construction_cd,
                            v_left,             v_rear,         v_construction_remarks,
                            v_flood_zone,       v_occupancy_cd, v_occupancy_remarks,
                            v_block_id,         v_assignee,     v_risk_cd, /*--added by lhen 031104*/
                            v_latitude,         v_longitude); --benjo 01.10.2017 SR-5749           
                 --variables.fireitem_flag := 'N';
                 v_district_no           := NULL;
                 v_eq_zone               := NULL;
                 v_tarf_cd               := NULL;
                 v_block_no              := NULL;
                 v_loc_risk1             := NULL; 
                 v_loc_risk2             := NULL;
                 v_fr_item_type          := NULL;
                 v_loc_risk3             := NULL;
                 v_tariff_zone           := NULL;
                 v_typhoon_zone          := NULL;
                 v_front                 := NULL; 
                 v_right                 := NULL;
                 v_construction_cd       := NULL;
                 v_left                  := NULL; 
                 v_rear                  := NULL; 
                 v_construction_remarks  := NULL;
                 v_flood_zone            := NULL;
                 v_occupancy_cd          := NULL;
                 v_occupancy_remarks     := NULL;
                 v_block_id              := NULL;
                 v_assignee              := NULL;
                 v_risk_cd               := NULL; --added bylhen 031104
                 v_latitude              := NULL; --benjo 01.10.2017 SR-5749
                 v_longitude             := NULL; --benjo 01.10.2017 SR-5749
              ELSE
                 EXIT;         
              END IF;                        
          END LOOP;
       END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
      FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                 FROM gipi_polbasic
                WHERE line_cd     =  x_line_cd
                  AND subline_cd  =  x_subline_cd
                  AND iss_cd      =  x_iss_cd
                  AND issue_yy    =  to_char(x_issue_yy)
                  AND pol_seq_no  =  to_char(x_pol_seq_no)
                  AND renew_no    =  to_char(x_renew_no)
                  AND (endt_seq_no = 0 OR 
                      (endt_seq_no > 0 AND 
                      TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                  AND pol_flag In ('1','2','3')
                ORDER BY eff_date, endt_seq_no)
       LOOP      
        v_policy_id  := b.policy_id;
          FOR DATA IN
              ( SELECT district_no,   eq_zone,            tarf_cd,        block_no,
                   loc_risk1,         loc_risk2,          fr_item_type,   loc_risk3,
                   tariff_zone,       typhoon_zone,       front,          right,
                   construction_cd,   left,               rear,           construction_remarks,
                   flood_zone,        occupancy_cd,       occupancy_remarks, block_id,  assignee,
                   risk_cd,           latitude,           longitude --benjo 01.10.2017 SR-5749
                  FROM gipi_fireitem
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wfireitm
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN         
                 v_district_no           := data.district_no;
                 v_eq_zone               := data.eq_zone;
                 v_tarf_cd               := data.tarf_cd;
                 v_block_no              := data.block_no;
                 v_loc_risk1             := data.loc_risk1; 
                 v_loc_risk2             := data.loc_risk2;
                 v_fr_item_type          := data.fr_item_type;
                 v_loc_risk3             := data.loc_risk3;
                 v_tariff_zone           := data.tariff_zone;
                 v_typhoon_zone          := data.typhoon_zone;
                 v_front                 := data.front; 
                 v_right                 := data.right;
                 v_construction_cd       := data.construction_cd;
                 v_left                  := data.left; 
                 v_rear                  := data.rear; 
                 v_construction_remarks  := data.construction_remarks;
                 v_flood_zone            := data.flood_zone;
                 v_occupancy_cd          := data.occupancy_cd;
                 v_occupancy_remarks     := data.occupancy_remarks;
                 v_block_id              := data.block_id;
                 v_assignee              := data.assignee;
                 v_risk_cd               := data.risk_cd; --added by lhen 031104;
                 v_latitude              := data.latitude;  --benjo 01.10.2017 SR-5749
                 v_longitude             := data.longitude; --benjo 01.10.2017 SR-5749
                 FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                             FROM gipi_polbasic
                          WHERE line_cd     =  x_line_cd
                            AND subline_cd  =  x_subline_cd
                            AND iss_cd      =  x_iss_cd
                            AND issue_yy    =  to_char(x_issue_yy)
                            AND pol_seq_no  =  to_char(x_pol_seq_no)
                            AND renew_no    =  to_char(x_renew_no)
                            AND (endt_seq_no = 0 OR 
                                (endt_seq_no > 0 AND 
                                TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                            AND pol_flag In ('1','2','3')
                          ORDER BY eff_date, endt_seq_no)
                 LOOP      
                    v_endt_id  := b1.policy_id;
                     FOR DATA2 IN
                              ( SELECT district_no,   eq_zone,            tarf_cd,        block_no,
                                   loc_risk1,         loc_risk2,          fr_item_type,   loc_risk3,
                                   tariff_zone,       typhoon_zone,       front,          right,
                                   construction_cd,   left,               rear,           construction_remarks,
                                   flood_zone,        occupancy_cd,       occupancy_remarks, block_id, assignee,
                                   risk_cd,           latitude,           longitude --benjo 01.10.2017 SR-5749
                                  FROM gipi_fireitem
                                 WHERE item_no = v_item_no 
                                   AND policy_id = v_endt_id
                      ) LOOP
                         v_district_no           := NVL(data2.district_no, v_district_no);
                         v_eq_zone               := NVL(data2.eq_zone, v_eq_zone);
                         v_tarf_cd               := NVL(data2.tarf_cd, v_tarf_cd);
                         v_block_no              := NVL(data2.block_no, v_block_no);
                         IF data2.loc_risk1 IS NOT NULL OR 
                            data2.loc_risk2 IS NOT NULL OR
                            data2.loc_risk3 IS NOT NULL THEN                           
                            v_loc_risk1          := data2.loc_risk1; 
                            v_loc_risk2          := data2.loc_risk2;
                            v_loc_risk3          := data2.loc_risk3;
                         END IF;
                         v_fr_item_type          := NVL(data2.fr_item_type, v_fr_item_type);                 
                         v_tariff_zone           := NVL(data2.tariff_zone, v_tariff_zone);
                         v_typhoon_zone          := NVL(data2.typhoon_zone, v_typhoon_zone);
                         v_front                 := NVL(data2.front, v_front); 
                         v_right                 := NVL(data2.right, v_right);
                         v_construction_cd       := NVL(data2.construction_cd, v_construction_cd);
                         v_left                  := NVL(data2.left, v_left); 
                         v_rear                  := NVL(data2.rear, v_rear); 
                         v_construction_remarks  := NVL(data2.construction_remarks, v_construction_remarks);
                         v_flood_zone            := NVL(data2.flood_zone, v_flood_zone);
                         v_occupancy_cd          := NVL(data2.occupancy_cd, v_occupancy_cd);
                         v_occupancy_remarks     := NVL(data2.occupancy_remarks, v_occupancy_remarks);
                         v_block_id              := NVL(data2.block_id, v_block_id);
                         v_assignee              := NVL(data2.assignee, v_assignee);
                         v_risk_cd               := NVL(data2.risk_cd, v_risk_cd);  --added by lhen 031104);
                         v_latitude              := NVL(data2.latitude, v_latitude);   --benjo 01.10.2017 SR-5749
                         v_longitude             := NVL(data2.longitude, v_longitude); --benjo 01.10.2017 SR-5749
                     END LOOP;
                 END LOOP;        
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying fire info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_wfireitm (
                          par_id,               item_no,        district_no,
                          eq_zone,              tarf_cd,        block_no,
                          loc_risk1,            loc_risk2,      fr_item_type,
                          loc_risk3,            tariff_zone,    typhoon_zone,
                          front,                right,          construction_cd,
                          left,                 rear,           construction_remarks,
                          flood_zone,           occupancy_cd,   occupancy_remarks,
                          block_id,             assignee,       risk_cd, /*added by lhen 031104*/
                          latitude,             longitude) --benjo 01.10.2017 SR-5749
                    VALUES(p_new_par_id,        v_item_no,      v_district_no,
                            v_eq_zone,          v_tarf_cd,      v_block_no,
                            v_loc_risk1,        v_loc_risk2,    v_fr_item_type,
                            v_loc_risk3,        v_tariff_zone,  v_typhoon_zone,
                            v_front,            v_right,        v_construction_cd,
                            v_left,             v_rear,         v_construction_remarks,
                            v_flood_zone,       v_occupancy_cd, v_occupancy_remarks,
                            v_block_id,         v_assignee,     v_risk_cd, /*--added by lhen 031104*/
                            v_latitude,         v_longitude); --benjo 01.10.2017 SR-5749
                 --variables.fireitem_flag := 'N';
                 v_district_no           := NULL;
                 v_eq_zone               := NULL;
                 v_tarf_cd               := NULL;
                 v_block_no              := NULL;
                 v_loc_risk1             := NULL; 
                 v_loc_risk2             := NULL;
                 v_fr_item_type          := NULL;
                 v_loc_risk3             := NULL;
                 v_tariff_zone           := NULL;
                 v_typhoon_zone          := NULL;
                 v_front                 := NULL; 
                 v_right                 := NULL;
                 v_construction_cd       := NULL;
                 v_left                  := NULL; 
                 v_rear                  := NULL; 
                 v_construction_remarks  := NULL;
                 v_flood_zone            := NULL;
                 v_occupancy_cd          := NULL;
                 v_occupancy_remarks     := NULL;
                 v_block_id              := NULL;
                 v_assignee              := NULL;
                 v_risk_cd               := NULL; --added bylhen 031104
                 v_latitude              := NULL; --benjo 01.10.2017 SR-5749
                 v_longitude             := NULL; --benjo 01.10.2017 SR-5749
              ELSE
                 EXIT;         
              END IF;                        
          END LOOP;
       END LOOP;
   END IF;    
END;
/


