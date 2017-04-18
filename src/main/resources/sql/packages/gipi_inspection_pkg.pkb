CREATE OR REPLACE PACKAGE BODY CPI.gipi_inspection_pkg
AS
   FUNCTION get_gipi_insp_data1
      RETURN gipi_insp_data1_tab PIPELINED
   IS
      v_insp_data1   gipi_insp_data1_type;
   BEGIN
      FOR i IN (SELECT DISTINCT A.insp_no, A.status, A.date_insp, A.insp_cd,
                                b.insp_name, A.assd_no, A.assd_name,
                                A.intm_no, c.intm_name,
                                a.approved_by, TRUNC(a.date_approved) date_approved                               
                           FROM gipi_insp_data A,
                                giis_inspector b,
                                giis_intermediary c
                          WHERE A.insp_cd = b.insp_cd
                                AND A.intm_no = c.intm_no
                       ORDER BY A.insp_no)
      LOOP
         v_insp_data1.insp_no := i.insp_no;
         v_insp_data1.status := i.status;
         v_insp_data1.date_insp := i.date_insp;
         v_insp_data1.insp_cd := i.insp_cd;
         v_insp_data1.insp_name := i.insp_name;
         v_insp_data1.assd_no := i.assd_no;
         v_insp_data1.assd_name := i.assd_name;
         v_insp_data1.intm_no := i.intm_no;
         v_insp_data1.intm_name := i.intm_name;
         v_insp_data1.approved_by := i.approved_by;
         v_insp_data1.date_approved := i.date_approved;
         FOR j IN (SELECT a.remarks                               
                           FROM gipi_insp_data A,
                                giis_inspector b,
                                giis_intermediary c
                          WHERE A.insp_cd = b.insp_cd
                                AND A.intm_no = c.intm_no
                                AND A.insp_no = i.insp_no)
         LOOP
            v_insp_data1.remarks := j.remarks;
            EXIT;
         END LOOP;
         PIPE ROW (v_insp_data1);
      END LOOP;
   END get_gipi_insp_data1;

   FUNCTION get_gipi_insp_data (p_insp_no gipi_insp_data.insp_no%TYPE)
      RETURN gipi_insp_data_tab PIPELINED
   IS
      v_gipi_insp_data   gipi_insp_data_type;
   BEGIN
      FOR i IN (
      		 SELECT a.item_no, a.item_title, a.item_desc, a.loc_risk1, a.loc_risk2,
                    a.loc_risk3, a.front, a.LEFT, a.RIGHT, a.rear, a.tsi_amt,
                    a.prem_rate, a.tarf_cd, a.tariff_zone, a.eq_zone, a.flood_zone,
                    a.typhoon_zone, a.occupancy_cd, a.occupancy_remarks,
                    a.construction_cd, a.construction_remarks, a.block_id, a.approved_by,
                    TRUNC (a.date_approved) date_approved, a.remarks, b.block_no,
                    b.district_no, d.city, c.province_desc province, c.province_cd,
                    b.city_cd, latitude, longitude --Added by MarkS 02/10/2017 SR5919
               FROM gipi_insp_data a, giis_block b, giis_province c, giis_city d
              WHERE a.block_id = b.block_id(+)
                AND b.province_cd = c.province_cd
                AND b.province_cd = d.province_cd -- Added by Jerome 08.19.2016 SR 5615
                AND d.city_cd = b.city_cd
                AND insp_no = p_insp_no
           ORDER BY item_no
      )
      LOOP
          v_gipi_insp_data.item_no := i.item_no;
         v_gipi_insp_data.item_title := i.item_title;
         v_gipi_insp_data.item_desc := i.item_desc;
         v_gipi_insp_data.loc_risk1 := i.loc_risk1;
         v_gipi_insp_data.loc_risk2 := i.loc_risk2;
         v_gipi_insp_data.loc_risk3 := i.loc_risk3;
         v_gipi_insp_data.front := escape_value_clob(i.front); --emsy08012012
         v_gipi_insp_data.LEFT := escape_value_clob(i.LEFT); --emsy08012012
         v_gipi_insp_data.RIGHT := escape_value_clob(i.RIGHT); --emsy08012012
         v_gipi_insp_data.rear := escape_value_clob(i.rear); --emsy08012012
         v_gipi_insp_data.tsi_amt := i.tsi_amt;
         v_gipi_insp_data.prem_rate := i.prem_rate;
         v_gipi_insp_data.tarf_cd := i.tarf_cd;
         v_gipi_insp_data.tariff_zone := i.tariff_zone;
         v_gipi_insp_data.eq_zone := i.eq_zone;
         v_gipi_insp_data.flood_zone := i.flood_zone;
         v_gipi_insp_data.typhoon_zone := i.typhoon_zone;
         v_gipi_insp_data.occupancy_cd := i.occupancy_cd;
         v_gipi_insp_data.occupancy_remarks := escape_value_clob(i.occupancy_remarks); --emsy08012012
         v_gipi_insp_data.construction_cd := i.construction_cd;
         v_gipi_insp_data.construction_remarks := escape_value_clob(i.construction_remarks); --emsy08012012
         v_gipi_insp_data.block_id := i.block_id;
         v_gipi_insp_data.approved_by := i.approved_by;
         v_gipi_insp_data.date_approved := i.date_approved;
         v_gipi_insp_data.remarks := escape_value_clob(i.remarks);
         v_gipi_insp_data.block_no := i.block_no;
         v_gipi_insp_data.district_no := i.district_no;
         v_gipi_insp_data.city := i.city;
         v_gipi_insp_data.province := i.province;
         v_gipi_insp_data.province_cd := i.province_cd;
         v_gipi_insp_data.city_cd := i.city_cd;
         v_gipi_insp_data.latitude := i.latitude; --Added by MarkS 02/10/2017 SR5919
         v_gipi_insp_data.longitude := i.longitude; --Added by MarkS 02/10/2017 SR5919
         PIPE ROW (v_gipi_insp_data);
      END LOOP;
   END get_gipi_insp_data;

   FUNCTION get_inspection_details (p_insp_no gipi_insp_data.insp_no%TYPE)
      RETURN ins_det_tab PIPELINED
   IS
      ins_det   ins_det_type;
   BEGIN
      FOR i IN (SELECT A.insp_no, NVL (A.assd_name, ' ') assd_name,
                       NVL (A.loc_risk1, ' ') loc_risk1,
                       NVL (A.loc_risk2, ' ') loc_risk2,
                       NVL (A.loc_risk3, ' ') loc_risk3, A.date_insp,
                       c.block_no, c.district_no,
                       NVL (E.insp_name, ' ') insp_name,
                       NVL (d.intm_name, ' ') intm_name, f.user_name,
                       A.approved_by, A.date_approved, A.tarf_cd, A.remarks,
                       G.tariff_zone_desc
                  FROM gipi_insp_data A,
                       giis_block c,
                       giis_intermediary d,
                       giis_inspector E,
                       giis_users f,
                       giis_tariff_zone G
                 WHERE A.block_id = c.block_id(+)
                   AND A.insp_cd = E.insp_cd(+)
                   AND A.approved_by = f.user_id(+)
                   AND A.intm_no = d.intm_no(+)
                   AND A.tariff_zone = G.tariff_zone(+)
                   AND A.insp_no = p_insp_no
                   AND A.item_no = 1)
      LOOP
         ins_det.insp_no := i.insp_no;
         ins_det.assd_name := i.assd_name;
         ins_det.loc_risk1 := i.loc_risk1;
         ins_det.loc_risk2 := i.loc_risk2;
         ins_det.loc_risk3 := i.loc_risk3;
         ins_det.date_insp := i.date_insp;
         ins_det.block_no := i.block_no;
         ins_det.district_no := i.district_no;
         ins_det.insp_name := i.insp_name;
         ins_det.intm_name := i.intm_name;
         ins_det.user_name := i.user_name;
         ins_det.date_approved := i.date_approved;
         ins_det.approved_by := i.approved_by;
         ins_det.tarf_cd := i.tarf_cd;
         ins_det.remarks := i.remarks;
         ins_det.tariff_zone_desc := i.tariff_zone_desc;
         PIPE ROW (ins_det);
      END LOOP;
   END get_inspection_details;

   FUNCTION get_insp_items (p_insp_no gipi_insp_data.insp_no%TYPE)
      RETURN insp_items_tab PIPELINED
   IS
      insp_items   insp_items_type;
      v_left       VARCHAR2 (2000);
      v_right      VARCHAR2 (2000);
      v_front      VARCHAR2 (2000);
      v_rear       VARCHAR2 (2000);
   BEGIN
      
      FOR i IN (SELECT insp_no, NVL (occupancy_remarks, ' ') occu_remarks,
                       item_no, NVL (item_desc, ' ') item_desc, tsi_amt,
                       item_title, front, LEFT, rear, RIGHT, block_no block_id
                  FROM gipi_insp_data A,
                       giis_block b
                 WHERE insp_no = p_insp_no
                   AND A.block_id = b.block_id(+)) --change by steven from: b.block_id  to: b.block_id(+)
      LOOP
         FOR o IN (SELECT occupancy_desc
                     FROM gipi_insp_data C,
                          giis_fire_occupancy D
                    WHERE c.insp_no = p_insp_no       
                    AND c.occupancy_cd (+)= d.occupancy_cd)
         LOOP 
           insp_items.occupancy_desc := o.occupancy_desc;
           EXIT;
         END LOOP;               
         insp_items.insp_no := i.insp_no;
         insp_items.item_no := i.item_no;
         insp_items.item_desc := i.item_desc;
         insp_items.occu_remarks := i.occu_remarks;
         insp_items.tsi_amt := i.tsi_amt;
         insp_items.item_title := i.item_title;
         insp_items.block_id := i.block_id;
        
      
         IF v_left IS NULL THEN
            v_left := i.LEFT;
         ELSE
            v_left := v_left || ' / ' || i.LEFT;
         END IF;

         IF v_right IS NULL THEN
            v_right := i.RIGHT;
         ELSE
            v_right := v_right || ' / ' || i.RIGHT;
         END IF;

         IF v_front IS NULL THEN
            v_front := i.front;
         ELSE
            v_front := v_front || ' / ' || i.front;
         END IF;

         IF v_rear IS NULL THEN
            v_rear := i.rear;
         ELSE
            v_rear := v_rear || ' / ' || i.rear;  
         END IF;
         insp_items.LEFT := v_left;
         insp_items.RIGHT := v_right;
         insp_items.front := v_front;
         insp_items.rear := v_rear;
          
         PIPE ROW (insp_items);
      END LOOP;
   END get_insp_items;

   FUNCTION get_insp_pics (
      p_insp_no   NUMBER
   )
      RETURN insp_pics_tab PIPELINED
   IS
      insp_pics   insp_pics_type;
   BEGIN
      FOR i IN (SELECT insp_no, item_no, file_ext,
                       MIN (file_name) AS file_name
                  FROM gipi_insp_pictures
                 WHERE insp_no = p_insp_no 
                GROUP BY insp_no, item_no, file_ext)
      LOOP
         insp_pics.insp_no := i.insp_no;
         insp_pics.item_no := i.item_no;
         insp_pics.file_ext := i.file_ext;
         insp_pics.file_name := i.file_name;
         PIPE ROW (insp_pics);
      END LOOP;
   END get_insp_pics;

   FUNCTION get_image_path (
      p_insp_no     NUMBER,
      p_file_name   gipi_insp_pictures.file_name%TYPE,
      p_file_ext    gipi_insp_pictures.file_ext%TYPE
   )
      RETURN image_path_tab PIPELINED
   IS
      image_path   image_path_type;
      v_path       VARCHAR2 (2000);
   BEGIN
      FOR i IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_type = 'V' AND param_name = 'MEDIA_PATH')
      LOOP
         image_path.v_path :=
            UPPER (   i.param_value_v
                   || 'insp_no_'
                   || p_insp_no
                   || '\insp_no_'
                   || p_file_name
                   || p_file_ext
                  );
         PIPE ROW (image_path);
      END LOOP;
   END get_image_path;

   PROCEDURE update_gipi_insp_data_table (
      p_insp_no                gipi_insp_data.insp_no%TYPE,
      p_item_no                gipi_insp_data.item_no%TYPE,
      p_item_desc              gipi_insp_data.item_desc%TYPE,
      p_block_id               gipi_insp_data.block_id%TYPE,
      p_assd_no                gipi_insp_data.assd_no%TYPE,
      p_assd_name              gipi_insp_data.assd_name%TYPE,
      p_loc_risk1              gipi_insp_data.loc_risk1%TYPE,
      p_loc_risk2              gipi_insp_data.loc_risk2%TYPE,
      p_loc_risk3              gipi_insp_data.loc_risk3%TYPE,
      p_occupancy_cd           gipi_insp_data.occupancy_cd%TYPE,
      p_occupancy_remarks      gipi_insp_data.occupancy_remarks%TYPE,
      p_construction_cd        gipi_insp_data.construction_cd%TYPE,
      p_construction_remarks   gipi_insp_data.construction_remarks%TYPE,
      p_front                  gipi_insp_data.front%TYPE,
      p_left                   gipi_insp_data.LEFT%TYPE,
      p_right                  gipi_insp_data.RIGHT%TYPE,
      p_rear                   gipi_insp_data.rear%TYPE,
      p_wc_cd                  gipi_insp_data.wc_cd%TYPE,
      p_tarf_cd                gipi_insp_data.tarf_cd%TYPE,
      p_tariff_zone            gipi_insp_data.tariff_zone%TYPE,
      p_eq_zone                gipi_insp_data.eq_zone%TYPE,
      p_flood_zone             gipi_insp_data.flood_zone%TYPE,
      p_typhoon_zone           gipi_insp_data.typhoon_zone%TYPE,
      p_prem_rate              gipi_insp_data.prem_rate%TYPE,
      p_tsi_amt                gipi_insp_data.tsi_amt%TYPE,
      p_intm_no                gipi_insp_data.intm_no%TYPE,
      p_insp_cd                gipi_insp_data.insp_cd%TYPE,
      p_date_insp              gipi_insp_data.date_insp%TYPE,
      p_approved_by            gipi_insp_data.approved_by%TYPE,
      p_date_approved          gipi_insp_data.date_approved%TYPE,
      p_par_id                 gipi_insp_data.par_id%TYPE,
      p_quote_id               gipi_insp_data.quote_id%TYPE,
      p_item_title             gipi_insp_data.item_title%TYPE,
      p_status                 gipi_insp_data.status%TYPE,
      p_item_grp               gipi_insp_data.item_grp%TYPE,
      p_remarks                gipi_insp_data.remarks%TYPE,
      p_arc_ext_data           gipi_insp_data.arc_ext_data%TYPE,
      p_user_id                gipi_insp_data.user_id%TYPE,
      --Added by MarkS 02/09/2017 SR5919
      p_latitude               gipi_insp_data.latitude%TYPE,
      p_longitude              gipi_insp_data.longitude%TYPE
      --end SR5919
      
      
   )
   IS
   BEGIN
      MERGE INTO gipi_insp_data
         USING DUAL
         ON (insp_no = p_insp_no AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (insp_no, item_no, item_desc, block_id, assd_no,
                    assd_name, loc_risk1, loc_risk2, loc_risk3, occupancy_cd,
                    occupancy_remarks, construction_cd, construction_remarks,
                    front, LEFT, RIGHT, rear, wc_cd, tarf_cd, tariff_zone,
                    eq_zone, flood_zone, typhoon_zone, prem_rate, tsi_amt,
                    intm_no, insp_cd, date_insp, approved_by, date_approved,
                    user_id, last_update, par_id, quote_id, item_title,
                    status, item_grp, remarks, arc_ext_data, date_reported,
                    --Added by MarkS 02/09/2017 SR5919
                    latitude, longitude
                    --end SR5919
                    )
            VALUES (p_insp_no, p_item_no, p_item_desc, p_block_id, p_assd_no,
                    p_assd_name, p_loc_risk1, p_loc_risk2, p_loc_risk3,
                    p_occupancy_cd, p_occupancy_remarks, p_construction_cd,
                    p_construction_remarks, p_front, p_left, p_right, p_rear,
                    p_wc_cd, p_tarf_cd, p_tariff_zone, p_eq_zone,
                    p_flood_zone, p_typhoon_zone, p_prem_rate, p_tsi_amt,
                    p_intm_no, p_insp_cd, p_date_insp, DECODE(p_status, 'A', p_approved_by, NULL),
                    DECODE(p_status, 'A', SYSDATE, NULL), p_user_id, SYSDATE, p_par_id, p_quote_id,
                    p_item_title, p_status, p_item_grp, p_remarks,
                    p_arc_ext_data, sysdate,
                    --Added by MarkS 02/09/2017 SR5919
                    p_latitude,p_longitude
                    --end SR5919
                    )
         WHEN MATCHED THEN
            UPDATE
               SET item_desc = p_item_desc, block_id = p_block_id,
                   --assd_no = p_assd_no, assd_name = p_assd_name,
                   loc_risk1 = p_loc_risk1, loc_risk2 = p_loc_risk2,
                   loc_risk3 = p_loc_risk3, occupancy_cd = p_occupancy_cd,
                   occupancy_remarks = p_occupancy_remarks,
                   construction_cd = p_construction_cd,
                   construction_remarks = p_construction_remarks,
                   front = p_front, LEFT = p_left, RIGHT = p_right,
                   rear = p_rear, wc_cd = p_wc_cd, tarf_cd = p_tarf_cd,
                   tariff_zone = p_tariff_zone, eq_zone = p_eq_zone,
                   flood_zone = p_flood_zone, typhoon_zone = p_typhoon_zone,
                   prem_rate = p_prem_rate, tsi_amt = p_tsi_amt,
                   --intm_no = p_intm_no, insp_cd = p_insp_cd,
                   --date_insp = p_date_insp, approved_by = DECODE(p_status, 'A', p_approved_by, NULL),
                   --date_approved = DECODE(p_status, 'A', SYSDATE, NULL), 
                   user_id = p_user_id,
                   last_update = SYSDATE, par_id = p_par_id,
                   quote_id = p_quote_id, item_title = p_item_title,
                   status = p_status, 
                   item_grp = p_item_grp,
                   --remarks = p_remarks, 
                   arc_ext_data = p_arc_ext_data,
                   --Added by MarkS 02/09/2017 SR5919
                   latitude     =   p_latitude,
                   longitude    =   p_longitude
                   --end SR5919
            ;
   END update_gipi_insp_data_table;

   PROCEDURE delete_gipi_insp_data (p_insp_no gipi_insp_data.insp_no%TYPE)
   IS
   BEGIN
      DELETE FROM gipi_insp_data
            WHERE insp_no = p_insp_no;
   END delete_gipi_insp_data;

   FUNCTION get_insp_otherdtls (
      p_insp_no   gipi_insp_data.insp_no%TYPE,
      p_item_no   gipi_insp_data.item_no%TYPE
   )
      RETURN gipi_insp_otherdtls_tab PIPELINED
   IS
      v_otherdtls   gipi_insp_otherdtls_type;
   BEGIN
      FOR i IN (SELECT risk_grade, peril_option1, peril_option1_bldg_rate,
                       peril_option1_cont_rate, peril_option2,
                       peril_option2_bldg_rate, peril_option2_cont_rate
                  FROM gipi_insp_data
                 WHERE insp_no = p_insp_no AND item_no = p_item_no)
      LOOP
         v_otherdtls.risk_grade := i.risk_grade;
         v_otherdtls.peril_option1 := i.peril_option1;
         v_otherdtls.peril_option1_bldg_rate := i.peril_option1_bldg_rate;
         v_otherdtls.peril_option1_cont_rate := i.peril_option1_cont_rate;
         v_otherdtls.peril_option2 := i.peril_option2;
         v_otherdtls.peril_option2_bldg_rate := i.peril_option2_bldg_rate;
         v_otherdtls.peril_option2_cont_rate := i.peril_option2_cont_rate;
         PIPE ROW (v_otherdtls);
      END LOOP;

      RETURN;
   END get_insp_otherdtls;

   PROCEDURE set_insp_otherdtls (
      p_insp_no                   gipi_insp_data.insp_no%TYPE,
      p_item_no                   gipi_insp_data.item_no%TYPE,
      p_risk_grade                gipi_insp_data.risk_grade%TYPE,
      p_peril_option1             gipi_insp_data.peril_option1%TYPE,
      p_peril_option1_bldg_rate   gipi_insp_data.peril_option1_bldg_rate%TYPE,
      p_peril_option1_cont_rate   gipi_insp_data.peril_option1_cont_rate%TYPE,
      p_peril_option2             gipi_insp_data.peril_option2%TYPE,
      p_peril_option2_bldg_rate   gipi_insp_data.peril_option2_bldg_rate%TYPE,
      p_peril_option2_cont_rate   gipi_insp_data.peril_option2_cont_rate%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_insp_data
         SET risk_grade = p_risk_grade,
             peril_option1 = p_peril_option1,
             peril_option1_bldg_rate = p_peril_option1_bldg_rate,
             peril_option1_cont_rate = p_peril_option1_cont_rate,
             peril_option2 = p_peril_option2,
             peril_option2_bldg_rate = p_peril_option2_bldg_rate,
             peril_option2_cont_rate = p_peril_option2_cont_rate
       WHERE insp_no = p_insp_no AND item_no = p_item_no;
   END set_insp_otherdtls;

   FUNCTION get_quote_inspection_list (p_assd_no gipi_insp_data.assd_no%TYPE, p_find_text VARCHAR2)
      RETURN quote_ins_det_tab PIPELINED
   IS
      v_quote_ins   quote_ins_det_type;
   BEGIN
      FOR A IN (SELECT gid.item_no, gid.assd_name, gid.insp_no, gi.insp_name,
                       gid.item_desc, gb.province, gb.city, gb.district_desc,
                       gb.block_desc, gid.loc_risk1, gid.loc_risk2,
                       loc_risk3, gb.province_cd, gb.district_no,
                       gb.block_no
                  FROM gipi_insp_data gid, giis_inspector gi, giis_block gb
                 WHERE gid.insp_cd = gi.insp_cd
                   AND gid.block_id = gb.block_id(+) -- marco - 11.28.2012 - for records with no block_id
                   AND gid.status = 'A'
                   AND gid.assd_no = NVL (p_assd_no, gid.assd_no)
                   AND (gid.assd_name LIKE NVL(p_find_text, gid.assd_name)
                    OR gi.insp_name LIKE NVL(p_find_text, gi.insp_name)
                    OR gid.item_desc LIKE NVL(p_find_text, gid.item_desc)
                    OR gb.province LIKE NVL(p_find_text, gb.province)
                    OR gb.city LIKE NVL(p_find_text, gb.city)
                    OR gb.district_desc LIKE NVL(p_find_text, gb.district_desc)
                    OR gb.block_desc LIKE NVL(p_find_text, gb.block_desc)
                    OR gid.loc_risk1 LIKE NVL(p_find_text, gid.loc_risk1)
                    OR gid.loc_risk2 LIKE NVL(p_find_text, gid.loc_risk2)
                    OR gid.loc_risk3 LIKE NVL(p_find_text, gid.loc_risk3)))
      LOOP
         v_quote_ins.item_no := A.item_no;
         v_quote_ins.assd_name := A.assd_name;
         v_quote_ins.insp_no := A.insp_no;
         v_quote_ins.insp_name := A.insp_name;
         v_quote_ins.item_desc := A.item_desc;
         v_quote_ins.province := A.province;
         v_quote_ins.city := A.city;
         v_quote_ins.district_desc := A.district_desc;
         v_quote_ins.block_desc := A.block_desc;
         v_quote_ins.loc_risk1 := A.loc_risk1;
         v_quote_ins.loc_risk2 := A.loc_risk2;
         v_quote_ins.loc_risk3 := A.loc_risk3;
         v_quote_ins.province_cd := A.province_cd;
         v_quote_ins.district_no := A.district_no;
         v_quote_ins.block_no := A.block_no;
         PIPE ROW (v_quote_ins);
      END LOOP;

      RETURN;
   END;

   PROCEDURE save_quote_insp_det (
      p_quote_id      gipi_quote.quote_id%TYPE,
      p_user_id       gipi_quote.user_id%TYPE,
      p_insp_no       gipi_insp_data.insp_no%TYPE,
      p_item_no       gipi_insp_data.item_no%TYPE,
      p_province_cd   giis_block.province_cd%TYPE,
      p_item_desc     gipi_insp_data.item_desc%TYPE,
      p_block_no      giis_block.block_no%TYPE,
      p_district_no   giis_block.district_no%TYPE,
      p_loc_risk1     gipi_insp_data.loc_risk1%TYPE,
      p_loc_risk2     gipi_insp_data.loc_risk2%TYPE,
      p_loc_risk3     gipi_insp_data.loc_risk3%TYPE
   )
   IS
      v_item_no       gipi_insp_data.item_no%TYPE;
      v_item_title    gipi_insp_data.item_title%TYPE;
      v_curr_cd       giac_parameters.param_value_n%TYPE;
      v_curr_rt       giis_currency.currency_rt%TYPE;
      v_reg_cd        giis_province.region_cd%TYPE;
      v_block_id      gipi_insp_data.block_id%TYPE;
      v_cons_cd       gipi_insp_data.construction_cd%TYPE;
      v_cons_rem      gipi_insp_data.construction_remarks%TYPE;
      v_eq_zone       gipi_insp_data.eq_zone%TYPE;
      v_flood         gipi_insp_data.flood_zone%TYPE;
      v_front         gipi_insp_data.front%TYPE;
      v_left          gipi_insp_data.LEFT%TYPE;
      v_occ_cd        gipi_insp_data.occupancy_cd%TYPE;
      v_occ_rem       gipi_insp_data.occupancy_remarks%TYPE;
      v_rear          gipi_insp_data.rear%TYPE;
      v_right         gipi_insp_data.RIGHT%TYPE;
      v_tarf_cd       gipi_insp_data.tarf_cd%TYPE;
      v_tarf_zone     gipi_insp_data.tariff_zone%TYPE;
      v_typ_zone      gipi_insp_data.typhoon_zone%TYPE;
      v_item_no_pic   gipi_insp_pictures.item_no%TYPE;
      v_file_name     gipi_insp_pictures.file_name%TYPE;
      v_file_type     gipi_insp_pictures.file_type%TYPE;
      v_file_ext      gipi_insp_pictures.file_ext%TYPE;
      v_remarks       gipi_insp_pictures.remarks%TYPE;
      v_user          VARCHAR2 (8);
      v_last_update   DATE;
   BEGIN
      v_user := p_user_id;
      v_last_update := SYSDATE;

      --data for gipi_quote_item and gipi_quote_fi_item
      FOR i IN (SELECT item_no, item_title, block_id, construction_cd,
                       construction_remarks, eq_zone, flood_zone, front,
                       LEFT, occupancy_cd, occupancy_remarks, rear, RIGHT,
                       tarf_cd, tariff_zone, typhoon_zone
                  FROM gipi_insp_data
                 WHERE insp_no = p_insp_no AND item_no = p_item_no)
      LOOP
         v_item_no := i.item_no;
         v_item_title := i.item_title;
         v_block_id := i.block_id;
         v_cons_cd := i.construction_cd;
         v_cons_rem := i.construction_remarks;
         v_eq_zone := i.eq_zone;
         v_flood := i.flood_zone;
         v_front := i.front;
         v_left := i.LEFT;
         v_occ_cd := i.occupancy_cd;
         v_occ_rem := i.occupancy_remarks;
         v_rear := i.rear;
         v_right := i.RIGHT;
         v_tarf_cd := i.tarf_cd;
         v_tarf_zone := i.tariff_zone;
         v_typ_zone := i.typhoon_zone;
      END LOOP;

      FOR s IN (SELECT param_value_n
                  FROM giac_parameters
                 WHERE param_name LIKE 'CURRENCY_CD')
      LOOP
         v_curr_cd := s.param_value_n;
      END LOOP;

      FOR A IN (SELECT currency_rt
                  FROM giis_currency
                 WHERE main_currency_cd = v_curr_cd)
      LOOP
         v_curr_rt := A.currency_rt;
      END LOOP;

      FOR M IN (SELECT region_cd
                  FROM giis_province
                 WHERE province_cd = p_province_cd)
      LOOP
         v_reg_cd := M.region_cd;
      END LOOP;

      --for gipi_quote_pictures
      FOR o IN (SELECT item_no, file_name, file_type, file_ext, remarks
                  FROM gipi_insp_pictures
                 WHERE insp_no = p_insp_no AND item_no = p_item_no)
      LOOP
         v_item_no_pic := o.item_no;
         v_file_name := o.file_name;
         v_file_type := o.file_type;
         v_file_ext := o.file_ext;
         v_remarks := o.remarks;

         IF v_item_no_pic IS NOT NULL
         THEN
            INSERT INTO gipi_quote_pictures
                        (quote_id, item_no, file_name,
                         file_type, file_ext, remarks, user_id,
                         last_update
                        )
                 VALUES (p_quote_id, v_item_no_pic, v_file_name,
                         v_file_type, v_file_ext, v_remarks, v_user,
                         v_last_update
                        );
         END IF;
      END LOOP;

      INSERT INTO gipi_quote_item
                  (quote_id, item_no, item_title, item_desc,
                   currency_cd, currency_rate, region_cd
                  )
           VALUES (p_quote_id, v_item_no, v_item_title, p_item_desc,
                   v_curr_cd, v_curr_rt, v_reg_cd
                  );

      INSERT INTO gipi_quote_fi_item
                  (block_id, block_no, district_no, item_no,
                   loc_risk1, loc_risk2, loc_risk3, quote_id,
                   construction_cd, construction_remarks, eq_zone,
                   flood_zone, front, LEFT, occupancy_cd, occupancy_remarks,
                   rear, RIGHT, tarf_cd, tariff_zone, typhoon_zone,
                   user_id, last_update
                  )
           VALUES (v_block_id, p_block_no, p_district_no, v_item_no,
                   p_loc_risk1, p_loc_risk2, p_loc_risk3, p_quote_id,
                   v_cons_cd, v_cons_rem, v_eq_zone,
                   v_flood, v_front, v_left, v_occ_cd, v_occ_rem,
                   v_rear, v_right, v_tarf_cd, v_tarf_zone, v_typ_zone,
                   v_user, v_last_update
                  );

      UPDATE gipi_insp_data
         SET status = 'Q'
       WHERE insp_no = p_insp_no AND item_no = p_item_no;

      UPDATE gipi_quote
         SET insp_no = p_insp_no
       WHERE quote_id = p_quote_id;
   END;
   
/**
 * Rey Jadlocon
 * 05-18-2012
 **/
 PROCEDURE delete_item(p_item_no			number,
					  p_insp_no			number)IS
	BEGIN
		DELETE FROM GIPI_INSP_DATA
			  WHERE ITEM_NO = p_item_no
				AND INSP_NO = p_insp_no;
                
        DELETE FROM GIPI_INSP_PICTURES
         WHERE item_no = p_item_no 
           AND insp_no = p_insp_no;   
	END;
	
	/*
	**  Created by   : Veronica V. Raymundo
	**  Date Created : August 31, 2012
	**  Reference By : GIPIS002 - Basic Information
	**  Description  : Retrieve list for inspection report
	*/
	  
	FUNCTION get_approved_inspection_list(p_par_id	  IN  GIPI_PARLIST.par_id%TYPE,
										  p_assd_no   IN  GIPI_INSP_DATA.assd_no%TYPE, 
										  p_find_text IN  VARCHAR2)
	RETURN gipi_inspection_tab PIPELINED AS
	
	  v_insp      gipi_inspection_type;
	  
	BEGIN
		FOR i IN (SELECT a.assd_name,  a.item_no,       a.status,      a.insp_no, 
						a.block_id,    b.insp_name,     a.item_title,  a.item_desc,
						c.province_cd, c.province,      c.city_cd,     c.city,        
						c.district_no, c.district_desc, c.block_no,    c.block_desc,     
						a.loc_risk1,   a.loc_risk2,     a.loc_risk3 
				   FROM GIPI_INSP_DATA a, 
						GIIS_INSPECTOR b, 
						GIIS_BLOCK c
				 WHERE a.insp_cd=b.insp_cd
				   AND a.block_id = c.block_id
				   AND a.assd_no = p_assd_no
				   AND (a.status = 'A' OR a.par_id = p_par_id)
				   AND (a.assd_name LIKE NVL(p_find_text, a.assd_name)
					OR b.insp_name LIKE NVL(p_find_text, b.insp_name)
					OR a.item_desc LIKE NVL(p_find_text, a.item_desc)
					OR c.province LIKE NVL(p_find_text, c.province)
					OR c.city LIKE NVL(p_find_text, c.city)
					OR c.district_desc LIKE NVL(p_find_text, c.district_desc)
					OR c.block_desc LIKE NVL(p_find_text, c.block_desc)
					OR a.loc_risk1 LIKE NVL(p_find_text, a.loc_risk1)
					OR a.loc_risk2 LIKE NVL(p_find_text, a.loc_risk2)
					OR a.loc_risk3 LIKE NVL(p_find_text, a.loc_risk3)))
		LOOP
			v_insp.assd_name       :=  i.assd_name; 
			v_insp.item_no         :=  i.item_no;
			v_insp.status          :=  i.status; 
			v_insp.insp_no         :=  i.insp_no; 
			v_insp.block_id        :=  i.block_id; 
			v_insp.insp_name       :=  i.insp_name; 
			v_insp.item_title      :=  i.item_title;
			v_insp.item_desc       :=  i.item_desc;
			v_insp.province_cd     :=  i.province_cd; 
			v_insp.province        :=  i.province; 
			v_insp.city_cd         :=  i.city_cd; 
			v_insp.city            :=  i.city; 
			v_insp.district_no     :=  i.district_no; 
			v_insp.district_desc   :=  i.district_desc; 
			v_insp.block_no        :=  i.block_no; 
			v_insp.block_desc      :=  i.block_desc; 
			v_insp.loc_risk1       :=  i.loc_risk1; 
			v_insp.loc_risk2       :=  i.loc_risk2; 
			v_insp.loc_risk3       :=  i.loc_risk3;
			
			PIPE ROW(v_insp);
			
		END LOOP;
	
	END get_approved_inspection_list;
	
	/*
	**  Created by :      Veronica V. Raymundo 
	**  Date Created:     08.31.2012
	**  Reference By:     (GIPIS002 - Basic Information) 
	**  Description:      Save items from Inspection to PAR item information 
	*/
	
	PROCEDURE save_par_witem_from_inspection
	(p_par_id        GIPI_PARLIST.par_id%TYPE,
	 p_insp_no       GIPI_INSP_DATA.insp_no%TYPE,
	 p_item_no		 GIPI_INSP_DATA.item_no%TYPE,
	 p_item_title	 GIPI_INSP_DATA.item_title%TYPE,
	 p_item_desc	 GIPI_INSP_DATA.item_desc%TYPE,
	 p_block_id	     GIPI_INSP_DATA.block_id%TYPE) AS
	
	v_curr_cd         GIIS_CURRENCY.main_currency_cd%type;
	v_curr_rt         GIIS_CURRENCY.currency_rt%type;
	v_region_cd       GIIS_PROVINCE.region_cd%type;
	v_item_grp        NUMBER:=1;
	v_rec_exist       NUMBER(1);
	
	BEGIN
		FOR c IN (SELECT a.param_value_n currency_cd, currency_rt
					FROM GIAC_PARAMETERS a, 
						 GIIS_CURRENCY b 
				   WHERE param_name LIKE 'CURRENCY_CD'
					 AND a.param_value_n = b.main_currency_cd)
		LOOP
		  v_curr_cd   := c.currency_cd;
		  v_curr_rt   := c.currency_rt;        
		END LOOP;
		
		FOR d IN (SELECT c.region_cd, a.block_id, b.insp_no, b.item_grp  
					FROM GIIS_BLOCK a, 
						 GIPI_INSP_DATA b, 
						 GIIS_PROVINCE c
				   WHERE a.block_id    = b.block_id                
					 AND a.province_cd = c.province_cd
					 AND b.insp_no     = p_insp_no
					 AND b.block_id    = p_block_id)    
		LOOP
		  v_region_cd := d.region_cd;
		  v_item_grp  := d.item_grp;
		END LOOP;
		
		FOR e IN (SELECT '1' rec_exist 
					FROM GIPI_WITEM
				   WHERE par_id  = p_par_id
					 AND item_no = p_item_no)
		LOOP
			v_rec_exist := e.rec_exist;
		END LOOP;
		
		IF v_rec_exist = 1 THEN   
			NULL;                                    
		ELSE                                    
			INSERT INTO GIPI_WITEM
			   (par_id, 	  item_no, 		item_title, 	item_desc, 
				currency_cd,  currency_rt,  region_cd, 		item_grp)
			VALUES
				(p_par_id,    p_item_no,    p_item_title,   p_item_desc,
				 v_curr_cd,   v_curr_rt,    v_region_cd,    NVL(v_item_grp, 1));
		END IF;
	
	END save_par_witem_from_inspection;
	
	/*
	**  Created by :      Veronica V. Raymundo 
	**  Date Created:     08.31.2012
	**  Reference By:     (GIPIS002 - Basic Information) 
	**  Description:      Save fire items additional information from Inspection 
	*/
	
	PROCEDURE save_wfireitm_from_inspection
	(p_par_id        GIPI_PARLIST.par_id%TYPE,
	 p_insp_no       GIPI_INSP_DATA.insp_no%TYPE,
	 p_item_no		 GIPI_INSP_DATA.item_no%TYPE,
	 p_block_id	     GIPI_INSP_DATA.block_id%TYPE,
	 p_insp_cd       GIPI_INSP_DATA.insp_cd%TYPE
	) AS
	
		v_nbt_district_no   GIIS_BLOCK.district_no%TYPE;  
		v_nbt_block_no      GIIS_BLOCK.block_no%TYPE;
		
	BEGIN
		FOR a in (SELECT b.insp_name, c.province, c.city, c.district_no, c.block_no 
					FROM GIPI_INSP_DATA A, GIIS_INSPECTOR b, GIIS_BLOCK c
				   WHERE a.insp_cd  = b.insp_cd
					 AND a.block_id = c.block_id
					 AND a.insp_cd  = p_insp_cd
					 AND c.block_id = p_block_id)
		LOOP
		  v_nbt_district_no := a.district_no;  
		  v_nbt_block_no    := a.block_no;    
		END LOOP;
	
		/* Creates a record in GIPI_WFIREITM */            
		INSERT INTO gipi_wfireitm 
			(block_id,	 	construction_cd,	construction_remarks,	eq_zone,		flood_zone,		
			 front,		 	item_no,			left,					loc_risk1,		loc_risk2,
			 loc_risk3,  	occupancy_cd,		occupancy_remarks,		par_id,			rear,
			 right,		 	tarf_cd,			tariff_zone,			typhoon_zone,
             --Added by MarkS 02/10/2017 SR5919
             latitude,      longitude
             --end SR5919
             )
		SELECT 
			 a.block_id, 	a.construction_cd,  a.construction_remarks, a.eq_zone,      a.flood_zone,
			 a.front,	 	a.item_no,          a.left,					a.loc_risk1,	a.loc_risk2,
			 a.loc_risk3,	a.occupancy_cd,	    a.occupancy_remarks,	b.par_id,		rear,
			 a.right,		a.tarf_cd,			a.tariff_zone,			a.typhoon_zone,
             --Added by MarkS 02/10/2017 SR5919
             a.latitude,    a.longitude
             --end SR5919
		FROM gipi_insp_data a, 
			(SELECT p_par_id par_id FROM dual) b
		WHERE a.insp_no = p_insp_no
		  AND a.item_no = p_item_no;
	
		/* Updates district and block of PAR */
		UPDATE gipi_wfireitm
		   SET block_no = v_nbt_block_no,
			   district_no = v_nbt_district_no
		 WHERE par_id = p_par_id;
	
		/* Updates status of PAR */
		UPDATE GIPI_PARLIST
		   SET par_status = 4
		 WHERE par_id = p_par_id;
	
		/* Updates PAR_ID of the selected record */
		UPDATE GIPI_INSP_DATA
		   SET par_id   = p_par_id,
		       status   = 'W' -- added by: Nica 09.03.2012 - tag inspection status to 'WITH PAR'
		 WHERE insp_no  = p_insp_no;
		   --AND block_id = p_block_id; remove this line Nica 09.26.2012
	END save_wfireitm_from_inspection;
	
	/*
	**  Created by :      Veronica V. Raymundo 
	**  Date Created:     08.31.2012
	**  Reference By:     (GIPIS002 - Basic Information) 
	**  Description:      Save gipi_wpictures from Inspection 
	*/
	
	PROCEDURE save_wpictures_from_inspection
	(p_par_id        GIPI_PARLIST.par_id%TYPE,
	 p_insp_no       GIPI_INSP_DATA.insp_no%TYPE,
	 p_item_no		 GIPI_INSP_DATA.item_no%TYPE
	) AS
	
	BEGIN
		FOR f IN (SELECT insp_no, file_name, file_type, file_ext, remarks 
					FROM gipi_insp_pictures
				   WHERE insp_no  = p_insp_no
					 AND item_no  = p_item_no)
		LOOP
			INSERT INTO gipi_wpictures
				(par_id, file_name, file_ext, item_no, file_type, remarks)
			VALUES
				(p_par_id, f.file_name, f.file_ext, p_item_no, f.file_type, f.remarks);	          	            	
		END LOOP;
	END save_wpictures_from_inspection;
	
	/*
	**  Created by   : Veronica V. Raymundo
	**  Date Created : September 26, 2012
	**  Reference By : GIPIS002 - Basic Information
	**  Description  : Retrieve list of approved inspection
	*/
	  
	FUNCTION get_approved_inspection_list_2(p_par_id	IN  GIPI_PARLIST.par_id%TYPE,
										    p_assd_no   IN  GIPI_INSP_DATA.assd_no%TYPE, 
										    p_find_text IN  VARCHAR2)
	RETURN gipi_inspection_tab_2 PIPELINED AS
	
	  v_insp      gipi_inspection_type_2;
	  
	BEGIN
		FOR i IN (SELECT DISTINCT A.insp_no, A.insp_cd,
                        b.insp_name, A.assd_no, A.assd_name,
                        A.intm_no, c.intm_name
                   FROM GIPI_INSP_DATA A,
                        GIIS_INSPECTOR b,
                        GIIS_INTERMEDIARY c
                  WHERE A.insp_cd = b.insp_cd
                    AND A.intm_no = c.intm_no
                    AND a.assd_no = p_assd_no
                    AND (a.status = 'A' OR a.par_id = p_par_id)
                    /* Commented and changed by reymon 05032013
                    AND (a.assd_name LIKE NVL(p_find_text, a.assd_name)
                     OR b.insp_name LIKE NVL(p_find_text, b.insp_name))*/
                    AND (UPPER(a.assd_name) LIKE NVL(UPPER(p_find_text), UPPER(a.assd_name))
                     OR UPPER(b.insp_name) LIKE NVL(UPPER(p_find_text), UPPER(b.insp_name))
                     OR a.insp_no LIKE NVL(p_find_text, a.insp_no)
                     OR UPPER(DECODE(loc_risk1, NULL, '', loc_risk1|| ' ')||
							  DECODE(loc_risk2, NULL, '', loc_risk2|| ' ')||
							  DECODE(loc_risk3, NULL, '', loc_risk3))
                        LIKE NVL(UPPER(p_find_text), UPPER(DECODE(loc_risk1, NULL, '', loc_risk1|| ' ')||
							                               DECODE(loc_risk2, NULL, '', loc_risk2|| ' ')||
							                               DECODE(loc_risk3, NULL, '', loc_risk3))))
                ORDER BY A.insp_no)
		LOOP
			v_insp.insp_no      :=  i.insp_no; 
            v_insp.insp_cd      :=  i.insp_cd;
            v_insp.insp_name    :=  i.insp_name;
            v_insp.assd_no      :=  i.assd_no;
            v_insp.assd_name    :=  i.assd_name;
            v_insp.intm_no      :=  i.intm_no;
            v_insp.intm_name    :=  i.intm_name;    
			v_insp.loc_risk1    :=  NULL; 
			v_insp.loc_risk2    :=  NULL; 
			v_insp.loc_risk3    :=  NULL;
			v_insp.loc_of_risk  :=  NULL;
            
            FOR loc IN (SELECT loc_risk1, loc_risk2, loc_risk3, 
							   DECODE(loc_risk1, NULL, '', loc_risk1|| ' ')||
							   DECODE(loc_risk2, NULL, '', loc_risk2|| ' ')||
							   DECODE(loc_risk3, NULL, '', loc_risk3) loc_of_risk
                          FROM GIPI_INSP_DATA
                         WHERE insp_no = i.insp_no
                        ORDER BY item_no)
            LOOP
                v_insp.loc_risk1    :=  loc.loc_risk1; 
                v_insp.loc_risk2    :=  loc.loc_risk2; 
                v_insp.loc_risk3    :=  loc.loc_risk3;
				v_insp.loc_of_risk  :=  loc.loc_of_risk;
                EXIT;
            END LOOP;
            
			PIPE ROW(v_insp);
			
		END LOOP;
	
	END get_approved_inspection_list_2;
	
	FUNCTION get_quote_inspection_list2(
        p_assd_no           GIPI_INSP_DATA.assd_no%TYPE,
        p_find_text         VARCHAR2
    )
      RETURN quote_ins_det_tab PIPELINED AS
        v_insp              quote_ins_det_type;
    BEGIN
        FOR i IN(SELECT DISTINCT a.insp_no, a.assd_name,
                        b.insp_name
                   FROM GIPI_INSP_DATA a,
                        GIIS_INSPECTOR b,
                        GIIS_BLOCK c
                  WHERE a.insp_cd = b.insp_cd
                    AND a.block_id = c.block_id(+)
                    AND a.status = 'A'
                    AND a.assd_no = NVL (p_assd_no, a.assd_no))
        LOOP
            v_insp.insp_no := i.insp_no;
            v_insp.insp_name := i.insp_name;
            v_insp.assd_name := i.assd_name;
            v_insp.loc_risk1 :=  NULL; 
			v_insp.loc_risk2 :=  NULL; 
			v_insp.loc_risk3 :=  NULL;
            
            /*FOR loc IN (SELECT loc_risk1, loc_risk2, loc_risk3
                          FROM GIPI_INSP_DATA
                         WHERE insp_no = i.insp_no
                         ORDER BY item_no)
            LOOP
                v_insp.loc_risk1 := loc.loc_risk1; 
                v_insp.loc_risk2 := loc.loc_risk2; 
                v_insp.loc_risk3 := loc.loc_risk3;
                EXIT;
            END LOOP;*/ -- replaced by: Nica 1.18.2013
			
			FOR loc IN (SELECT loc_risk1, loc_risk2, loc_risk3, 
							   DECODE(loc_risk1, NULL, '', loc_risk1|| ' ')||
							   DECODE(loc_risk2, NULL, '', loc_risk2|| ' ')||
							   DECODE(loc_risk3, NULL, '', loc_risk3) loc_risk
                          FROM GIPI_INSP_DATA
                         WHERE insp_no = i.insp_no
                        ORDER BY item_no)
            LOOP
                v_insp.loc_risk1    :=  loc.loc_risk1; 
                v_insp.loc_risk2    :=  loc.loc_risk2; 
                v_insp.loc_risk3    :=  loc.loc_risk3;
				v_insp.loc_risk     :=  loc.loc_risk;
                EXIT;
            END LOOP; 
            
            PIPE ROW(v_insp);
        END LOOP;
    END;
    
    PROCEDURE save_quote_inspection(
        p_quote_id          GIPI_QUOTE.quote_id%TYPE,
        p_insp_no           GIPI_INSP_DATA.insp_no%TYPE,
        p_item_no           GIPI_INSP_DATA.item_no%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE
    )
    AS
        v_curr_rt			GIIS_CURRENCY.currency_rt%TYPE;
        v_curr_cd			GIAC_PARAMETERS.param_value_n%TYPE;
        v_province_cd       GIIS_BLOCK.province_cd%TYPE;
        v_district_no       GIIS_BLOCK.district_no%TYPE;
        v_block_no          GIIS_BLOCK.block_no%TYPE;
        v_reg_cd			GIIS_PROVINCE.region_cd%TYPE;
        v_item_no_pic	    GIPI_INSP_PICTURES.item_no%TYPE;
        v_file_name			GIPI_INSP_PICTURES.file_name%TYPE;
        v_file_type			GIPI_INSP_PICTURES.file_type%TYPE;
        v_file_ext			GIPI_INSP_PICTURES.file_ext%TYPE;
        v_remarks			GIPI_INSP_PICTURES.remarks%TYPE;
    BEGIN
        FOR s IN (SELECT param_value_n
                    FROM GIAC_PARAMETERS
                  WHERE param_name LIKE 'CURRENCY_CD')
        LOOP
            v_curr_cd := s.param_value_n;
        END LOOP;
        
        FOR a IN (SELECT currency_rt
                    FROM GIIS_CURRENCY
                   WHERE main_currency_cd = v_curr_cd)
        LOOP
            v_curr_rt := a.currency_rt;
        END LOOP;
    
        FOR i IN (SELECT item_no, item_title,
	          			 block_id, construction_cd, construction_remarks, eq_zone, 
	          			 flood_zone, front, left, occupancy_cd, occupancy_remarks, 
	          			 rear, right, tarf_cd, tariff_zone, typhoon_zone, item_desc,
                         loc_risk1, loc_risk2, loc_risk3,
                         --Added by MarkS 02/10/2017 SR5919
                         latitude,longitude
                         --end SR5919
                    FROM GIPI_INSP_DATA
                   WHERE insp_no = p_insp_no
                     AND item_no = p_item_no)
        LOOP
        
            BEGIN
                SELECT province_cd, district_no, block_no
                  INTO v_province_cd, v_district_no, v_block_no
                  FROM GIIS_BLOCK
                 WHERE block_id = i.block_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_province_cd := NULL;
                    v_district_no := NULL;
                    v_block_no := NULL;
            END;
        
            FOR m IN (SELECT region_cd
                        FROM GIIS_PROVINCE
                       WHERE province_cd = v_province_cd)
            LOOP
                v_reg_cd := m.region_cd;
            END LOOP;
            
            FOR o IN (SELECT item_no, file_name, file_type, file_ext, remarks
                        FROM GIPI_INSP_PICTURES
                       WHERE insp_no = p_insp_no
                         AND item_no = p_item_no)
            LOOP
                v_item_no_pic := o.item_no;
                v_file_name	:= o.file_name;
                v_file_type	:= o.file_type;
                v_file_ext := o.file_ext;
                v_remarks := o.remarks;
        		
                IF v_item_no_pic IS NOT NULL THEN		
                    INSERT INTO GIPI_QUOTE_PICTURES
                           (quote_id, item_no, file_name, file_type, file_ext, remarks, user_id, last_update)
                    VALUES (p_quote_id, v_item_no_pic, v_file_name, v_file_type, v_file_ext, v_remarks, p_user_id, SYSDATE);   
                END IF;
            END LOOP;
            
            INSERT INTO GIPI_QUOTE_ITEM
                   (quote_id, item_no, item_title, item_desc, currency_cd, currency_rate, region_cd)
            VALUES (p_quote_id, i.item_no, i.item_title, i.item_desc, v_curr_cd, v_curr_rt, v_reg_cd);
            
            INSERT INTO GIPI_QUOTE_FI_ITEM
                   (block_id, block_no, district_no, item_no, loc_risk1, loc_risk2, loc_risk3,
                   quote_id, construction_cd, construction_remarks, eq_zone, flood_zone, front, 
                   left, occupancy_cd, occupancy_remarks, rear, right, tarf_cd, tariff_zone, typhoon_zone,
                   user_id, last_update,
                   --Added by MarkS 02/10/2017 SR5919
                   latitude,longitude
                   --end SR5919
                   )
            VALUES (i.block_id, v_block_no, v_district_no, i.item_no, i.loc_risk1, 
                   i.loc_risk2, i.loc_risk3, p_quote_id, i.construction_cd, i.construction_remarks, i.eq_zone,
                   i.flood_zone, i.front, i.left, i.occupancy_cd, i.occupancy_remarks, i.rear, i.right, i.tarf_cd, i.tariff_zone, i.typhoon_zone,
                   p_user_id, SYSDATE,
                   --Added by MarkS 02/10/2017 SR5919
                   i.latitude,i.longitude
                   --end SR5919
                   );
        END LOOP;
               
        UPDATE GIPI_INSP_DATA
	       SET status = 'Q'
	     WHERE insp_no = p_insp_no
	       AND item_no = p_item_no;
	 
	    UPDATE GIPI_QUOTE
	       SET insp_no = p_insp_no
	     WHERE quote_id = p_quote_id;
    END;
    
    --marco - 08.05.2014
    PROCEDURE update_inspection_status(
      p_par_id       GIPI_INSP_DATA.par_id%TYPE
   )
   IS
      v_exists       VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT insp_no
                 FROM GIPI_PARLIST
                WHERE par_id = p_par_id
                  AND insp_no IS NOT NULL)
      LOOP
         FOR m IN(SELECT 1
                    FROM GIPI_WITEM a
                   WHERE a.par_id = p_par_id
                     AND EXISTS (SELECT 'X'
                                   FROM GIPI_INSP_DATA b
                                  WHERE b.par_id = p_par_id
                                    AND b.insp_no = i.insp_no
                                    AND a.item_no = b.item_no))
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
         
         IF v_exists = 'N' THEN
            UPDATE GIPI_INSP_DATA c
               SET c.status = 'A',
                   c.par_id = NULL
             WHERE c.par_id = p_par_id
               AND c.insp_no = i.insp_no;
         END IF;
      END LOOP;
   END;
   
   --marco - 08.05.2014
   PROCEDURE set_status_to_approved(
      p_par_id       GIPI_INSP_DATA.par_id%TYPE
   )
   IS
   BEGIN
      UPDATE GIPI_INSP_DATA
         SET status = 'A',
             par_id = NULL
       WHERE par_id = p_par_id;
   END;
   
   --john 3.22.2016 SR#5470
   PROCEDURE update_parent_record(
        p_insp_no     VARCHAR2,
        p_assd_no     VARCHAR2,
        p_assd_name   VARCHAR2,
        p_intm_no     VARCHAR2,
        p_insp_cd     VARCHAR2,
        p_remarks     VARCHAR2,
        p_status      VARCHAR2,
        p_user          VARCHAR2
   )
   IS
   BEGIN
    IF p_status = 'N' THEN
        UPDATE GIPI_INSP_DATA
           SET assd_no = p_assd_no,
               assd_name = p_assd_name,
               intm_no = p_intm_no,
               insp_cd = p_insp_cd,
               remarks = p_remarks,
               status = p_status
         WHERE insp_no = p_insp_no;
    ELSE
        UPDATE GIPI_INSP_DATA
           SET assd_no = p_assd_no,
               assd_name = p_assd_name,
               intm_no = p_intm_no,
               insp_cd = p_insp_cd,
               remarks = p_remarks,
               approved_by = p_user,
               date_approved = sysdate,
               status = p_status
         WHERE insp_no = p_insp_no;
    END IF;
   END;

END gipi_inspection_pkg;
/
