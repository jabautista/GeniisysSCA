DROP PROCEDURE CPI.POPULATE_CARGO;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_CARGO (
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wcargo.par_id%TYPE,
    p_user             IN  gipi_wcargo_carrier.user_id%TYPE,
    p_vessel_cd        IN  giis_vessel.vessel_cd%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id                  RECORDGROUP;
  rg_name                VARCHAR2(30) := 'GROUP_POLICY';
  rg_count               NUMBER;
  rg_count2              NUMBER;
  rg_col                 VARCHAR2(50) := rg_name || '.policy_id';
  item_exist             VARCHAR2(1); 
  v_row                  NUMBER;
  v_policy_id            gipi_polbasic.policy_id%TYPE;
  v_endt_id              gipi_polbasic.policy_id%TYPE;
  v_vessel_cd            gipi_wcargo.vessel_cd%TYPE;
  v_geog_cd              gipi_wcargo.geog_cd%TYPE;
  v_cargo_class_cd       gipi_wcargo.cargo_class_cd%TYPE;
  v_bl_awb               gipi_wcargo.bl_awb%TYPE;
  v_origin               gipi_wcargo.origin%TYPE;
  v_destn                gipi_wcargo.destn%TYPE;
  v_etd                  gipi_wcargo.etd%TYPE;
  v_eta                  gipi_wcargo.eta%TYPE;
  v_cargo_type           gipi_wcargo.cargo_type%TYPE;
  v_tranship_destination gipi_wcargo.tranship_destination%TYPE;
  v_deduct_text          gipi_wcargo.deduct_text%TYPE;
  v_pack_method          gipi_wcargo.pack_method%TYPE;
  v_print_tag            gipi_wcargo.print_tag%TYPE;
  v_tranship_origin      gipi_wcargo.tranship_origin%TYPE;
  v_voyage_no            gipi_wcargo.voyage_no%TYPE;
  v_lc_no                gipi_wcargo.lc_no%TYPE;
  
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
  **  Description  : POPULATE_CARGO program unit 
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
        v_policy_id   := b.policy_id;
        FOR DATA IN
          ( SELECT cargo_class_cd,  bl_awb,        origin,      destn,
                   etd, eta,        cargo_type,    tranship_destination,
                   deduct_text,     pack_method,   print_tag,   tranship_origin,
                   vessel_cd,       geog_cd,       voyage_no,   lc_no
              FROM gipi_cargo
             WHERE item_no = v_item_no
               AND policy_id = v_policy_id               
          ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wcargo
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN
                 v_vessel_cd            := data.vessel_cd;
                 v_geog_cd              := data.geog_cd;
                 v_cargo_class_cd       := data.cargo_class_cd;
                 v_bl_awb               := data.bl_awb;  
                 v_origin               := data.origin;
                 v_destn                := data.destn;
                 v_etd                  := data.etd;
                 v_eta                  := data.eta;
                 v_cargo_type           := data.cargo_type;
                 v_tranship_destination := data.tranship_destination;
                 v_deduct_text          := data.deduct_text;
                 v_pack_method          := data.pack_method;
                 v_print_tag            := data.print_tag;
                 v_tranship_origin      := data.tranship_origin;
                 v_voyage_no            := data.voyage_no;
                 v_lc_no                := data.lc_no;
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
                    v_endt_id   := b1.policy_id;
                    FOR DATA2 IN
                            ( SELECT cargo_class_cd,   bl_awb,        origin,      destn,
                                   etd, eta,         cargo_type,    tranship_destination,
                                   deduct_text,      pack_method,   print_tag,   tranship_origin,
                                   vessel_cd,        geog_cd,       voyage_no,   lc_no
                              FROM gipi_cargo
                             WHERE item_no = v_item_no 
                               AND policy_id = v_endt_id
                         ) LOOP
                         v_vessel_cd            := NVL(data2.vessel_cd, v_vessel_cd);
                         v_geog_cd              := NVL(data2.geog_cd, v_geog_cd);
                         v_cargo_class_cd       := NVL(data2.cargo_class_cd, v_cargo_class_cd);
                         v_bl_awb               := NVL(data2.bl_awb, v_bl_awb);  
                         v_origin               := NVL(data2.origin, v_origin);
                         v_destn                := NVL(data2.destn, v_destn);
                         v_etd                  := NVL(data2.etd, v_etd);
                         v_eta                  := NVL(data2.eta, v_eta);
                         v_cargo_type           := NVL(data2.cargo_type, v_cargo_type);
                         v_tranship_destination := NVL(data2.tranship_destination, v_tranship_destination);
                         v_deduct_text          := NVL(data2.deduct_text, v_deduct_text);
                         v_pack_method          := NVL(data2.pack_method, v_pack_method);
                         v_print_tag            := NVL(data2.print_tag, v_print_tag);
                         v_tranship_origin      := NVL(data2.tranship_origin, v_tranship_origin);
                         v_lc_no                := NVL(data2.lc_no, v_lc_no);
                     END LOOP;
                 END LOOP;  
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying cargo info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_wcargo (
                         par_id,               item_no,       vessel_cd,   geog_cd,
                         cargo_class_cd,       bl_awb,        origin,      destn,
                         etd, eta,             cargo_type,    tranship_destination,
                         deduct_text,          pack_method,   print_tag,   tranship_origin,
                         voyage_no,            rec_flag,      lc_no) 
                 VALUES(p_new_par_id,          v_item_no,     v_vessel_cd, v_geog_cd,
                         v_cargo_class_cd,     v_bl_awb,      v_origin,    v_destn,
                         v_etd, v_eta,         v_cargo_type,  v_tranship_destination,
                         v_deduct_text,        v_pack_method, v_print_tag, v_tranship_origin,
                         v_voyage_no,          'A',           v_lc_no);   
                 IF data.vessel_cd = p_vessel_cd THEN
                    populate_carrier( v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);
                 END IF;                         
                 v_vessel_cd            := NULL;
                 v_geog_cd              := NULL;
                 v_cargo_class_cd       := NULL;
                 v_bl_awb               := NULL;  
                 v_origin               := NULL;
                 v_destn                := NULL;
                 v_etd                  := NULL;
                 v_eta                  := NULL;
                 v_cargo_type           := NULL;
                 v_tranship_destination := NULL;
                 v_deduct_text          := NULL;
                 v_pack_method          := NULL;
                 v_print_tag            := NULL;
                 v_tranship_origin      := NULL;
                 v_voyage_no            := NULL;
                 v_lc_no                := NULL;
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
        v_policy_id   := b.policy_id;
        FOR DATA IN
          ( SELECT cargo_class_cd,  bl_awb,        origin,      destn,
                   etd, eta,        cargo_type,    tranship_destination,
                   deduct_text,     pack_method,   print_tag,   tranship_origin,
                   vessel_cd,       geog_cd,       voyage_no,   lc_no
              FROM gipi_cargo
             WHERE item_no = v_item_no
               AND policy_id = v_policy_id               
          ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wcargo
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN
                 v_vessel_cd            := data.vessel_cd;
                 v_geog_cd              := data.geog_cd;
                 v_cargo_class_cd       := data.cargo_class_cd;
                 v_bl_awb               := data.bl_awb;  
                 v_origin               := data.origin;
                 v_destn                := data.destn;
                 v_etd                  := data.etd;
                 v_eta                  := data.eta;
                 v_cargo_type           := data.cargo_type;
                 v_tranship_destination := data.tranship_destination;
                 v_deduct_text          := data.deduct_text;
                 v_pack_method          := data.pack_method;
                 v_print_tag            := data.print_tag;
                 v_tranship_origin      := data.tranship_origin;
                 v_voyage_no            := data.voyage_no;
                 v_lc_no                := data.lc_no;
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
                    v_endt_id   := b1.policy_id;
                    FOR DATA2 IN
                            ( SELECT cargo_class_cd, bl_awb,        origin,      destn,
                                   etd, eta,         cargo_type,    tranship_destination,
                                   deduct_text,      pack_method,   print_tag,   tranship_origin,
                                   vessel_cd,        geog_cd,       voyage_no,   lc_no
                              FROM gipi_cargo
                             WHERE item_no = v_item_no 
                               AND policy_id = v_endt_id
                         ) LOOP
                         v_vessel_cd            := NVL(data2.vessel_cd, v_vessel_cd);
                         v_geog_cd              := NVL(data2.geog_cd, v_geog_cd);
                         v_cargo_class_cd       := NVL(data2.cargo_class_cd, v_cargo_class_cd);
                         v_bl_awb               := NVL(data2.bl_awb, v_bl_awb);  
                         v_origin               := NVL(data2.origin, v_origin);
                         v_destn                := NVL(data2.destn, v_destn);
                         v_etd                  := NVL(data2.etd, v_etd);
                         v_eta                  := NVL(data2.eta, v_eta);
                         v_cargo_type           := NVL(data2.cargo_type, v_cargo_type);
                         v_tranship_destination := NVL(data2.tranship_destination, v_tranship_destination);
                         v_deduct_text          := NVL(data2.deduct_text, v_deduct_text);
                         v_pack_method          := NVL(data2.pack_method, v_pack_method);
                         v_print_tag            := NVL(data2.print_tag, v_print_tag);
                         v_tranship_origin      := NVL(data2.tranship_origin, v_tranship_origin);
                         v_lc_no                := NVL(data2.lc_no, v_lc_no);
                     END LOOP;
                 END LOOP;  
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying cargo info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_wcargo (
                         par_id,               item_no,       vessel_cd,   geog_cd,
                         cargo_class_cd,       bl_awb,        origin,      destn,
                         etd, eta,             cargo_type,    tranship_destination,
                         deduct_text,          pack_method,   print_tag,   tranship_origin,
                         voyage_no,            rec_flag,      lc_no) 
                 VALUES(p_new_par_id,          v_item_no,     v_vessel_cd, v_geog_cd,
                         v_cargo_class_cd,     v_bl_awb,      v_origin,    v_destn,
                         v_etd, v_eta,         v_cargo_type,  v_tranship_destination,
                         v_deduct_text,        v_pack_method, v_print_tag, v_tranship_origin,
                         v_voyage_no,          'A',           v_lc_no);   
                 IF data.vessel_cd = p_vessel_cd THEN
                    populate_carrier( v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);
                 END IF;                         
                 v_vessel_cd            := NULL;
                 v_geog_cd              := NULL;
                 v_cargo_class_cd       := NULL;
                 v_bl_awb               := NULL;  
                 v_origin               := NULL;
                 v_destn                := NULL;
                 v_etd                  := NULL;
                 v_eta                  := NULL;
                 v_cargo_type           := NULL;
                 v_tranship_destination := NULL;
                 v_deduct_text          := NULL;
                 v_pack_method          := NULL;
                 v_print_tag            := NULL;
                 v_tranship_origin      := NULL;
                 v_voyage_no            := NULL;
                 v_lc_no                := NULL;
              ELSE
                 EXIT;         
              END IF;                        
          END LOOP;
     END LOOP;
   END IF;
END;
/


