CREATE OR REPLACE PACKAGE BODY CPI.Gixx_Fireitem_Pkg
AS
	FUNCTION get_report_details (
		p_extract_id IN GIXX_ITEM.extract_id%TYPE,
		p_print_tariff_zone IN VARCHAR2,
		p_print_zone IN VARCHAR2)
	RETURN fire_item_table PIPELINED
	IS
		v_fire_item fire_item_type;
	BEGIN
		FOR i IN (
			SELECT ALL item.extract_id extract_id,
				   item.item_no item_item_no,
				   item.item_title item_item_title,
				   item.item_desc item_desc,
				   item.item_desc2 item_desc2,
				   item.coverage_cd item_coverage_cd,
				   currency.currency_desc item_currency_desc,
				   item.other_info item_other_info,
				   item.from_date item_from_date,
				   item.TO_DATE item_to_date,
				   item.currency_rt item_currency_rt,
				   fitem.item_no fitem_item_no,
				   fitem.assignee fitem_assignee,
				   fitem.loc_risk1 fitem_location_of_risk1,
				   fitem.loc_risk2 fitem_location_of_risk2,
				   fitem.loc_risk3 fitem_location_of_risk3,
				   fitype.fr_itm_tp_ds fitem_fr_item_type,
				   blk.block_desc block_block_desc,
				   fitem.tarf_cd fitem_tarf_cd,
				   fitem.eq_zone fitem_eq_zone,
				   fitem.typhoon_zone fitem_typhoon_zone,
				   fitem.flood_zone fitem_flood_zone,
				   ficonstruct.construction_desc ficonstruct_construction_desc,
				   fitem.construction_remarks fitem_construction_remarks,
				   fiocc.occupancy_desc fiocc_occupancy_desc,
				   fitem.occupancy_remarks fitem_occupancy_remarks,
				   fitem.tariff_zone fitem_tariff_zone,
				   fitem.front fitem_front,
				   fitem.RIGHT fitem_right,
				   fitem.LEFT fitem_left,
				   fitem.rear fitem_rear,
				   fitem.block_id fitem_block_id,
				   fitem.block_no fitem_block_no,
				   fitem.district_no fitem_district_no,
				   blk.block_desc block_desc
			  FROM GIXX_FIREITEM FITEM,
				   GIIS_BLOCK BLK,
				   GIIS_FIRE_CONSTRUCTION FICONSTRUCT,
				   GIIS_FIRE_OCCUPANCY FIOCC,
				   GIIS_FI_ITEM_TYPE FITYPE,
				   GIXX_ITEM ITEM,
				   GIIS_CURRENCY CURRENCY
			 WHERE ((fitem.block_id = blk.block_id (+) )
			   AND (fitem.construction_cd = ficonstruct.construction_cd (+) )
			   AND (fitem.occupancy_cd = fiocc.occupancy_cd (+) )
			   AND (fitem.fr_item_type = fitype.fr_item_type (+) ))
			   AND item.currency_cd = currency.main_currency_cd (+)
			   AND item.extract_id = fitem.extract_id (+)
			   AND item.item_no = fitem.item_no (+)
			   AND item.extract_id = p_extract_id
          ORDER BY item.item_no)
		LOOP
			v_fire_item.extract_id						:= i.extract_id;
			v_fire_item.item_item_no					:= i.item_item_no;
			v_fire_item.item_item_title					:= i.item_item_title;
			v_fire_item.item_desc						:= i.item_desc;
			v_fire_item.item_desc2						:= i.item_desc2;
			v_fire_item.item_coverage_cd				:= i.item_coverage_cd;
			v_fire_item.item_currency_desc				:= i.item_currency_desc;
			v_fire_item.item_other_info					:= i.item_other_info;
			v_fire_item.item_from_date					:= i.item_from_date;
			v_fire_item.item_to_date					:= i.item_to_date;
			v_fire_item.item_currency_rt				:= i.item_currency_rt;
			v_fire_item.fitem_item_no					:= i.fitem_item_no;
			v_fire_item.fitem_assignee					:= i.fitem_assignee;
			v_fire_item.fitem_location_of_risk1			:= i.fitem_location_of_risk1;
			v_fire_item.fitem_location_of_risk2 		:= i.fitem_location_of_risk2;
			v_fire_item.fitem_location_of_risk3			:= i.fitem_location_of_risk3;
			v_fire_item.fitem_fr_item_type				:= i.fitem_fr_item_type;
			v_fire_item.block_block_desc				:= i.block_block_desc;
			v_fire_item.fitem_tarf_cd					:= i.fitem_tarf_cd;
			v_fire_item.fitem_eq_zone					:= i.fitem_eq_zone;
			v_fire_item.fitem_typhoon_zone				:= i.fitem_typhoon_zone;
			v_fire_item.fitem_flood_zone				:= i.fitem_flood_zone;
			v_fire_item.ficonstruct_construction_desc	:= i.ficonstruct_construction_desc;
			v_fire_item.fitem_construction_remarks		:= i.fitem_construction_remarks;
			v_fire_item.fiocc_occupancy_desc			:= i.fiocc_occupancy_desc;
			v_fire_item.fitem_occupancy_remarks			:= i.fitem_occupancy_remarks;
			v_fire_item.fitem_tariff_zone				:= i.fitem_tariff_zone;
			v_fire_item.fitem_front						:= i.fitem_front;
			v_fire_item.fitem_right						:= i.fitem_right;
			v_fire_item.fitem_left						:= i.fitem_left;
			v_fire_item.fitem_rear						:= i.fitem_rear;
			v_fire_item.fitem_block_id					:= i.fitem_block_id;
			v_fire_item.fitem_block_no					:= i.fitem_block_no;
			v_fire_item.fitem_district_no				:= i.fitem_district_no;
			v_fire_item.block_desc						:= i.block_desc;
			v_fire_item.f_item_short_name				:= Giis_Currency_Pkg.get_item_short_name(i.extract_id);
			v_fire_item.show_boundary					:= Gixx_Fireitem_Pkg.show_pol_doc_fire_boundary(i.fitem_front, i.fitem_right, i.fitem_left, i.fitem_rear, p_print_tariff_zone);
			v_fire_item.show_earthquake_zone			:= Gixx_Fireitem_Pkg.show_pol_doc_fire_xxx_zone(p_print_zone, i.fitem_eq_zone, i.fitem_front, i.fitem_rear, i.fitem_left, i.fitem_right);
			v_fire_item.show_typhoon_zone				:= Gixx_Fireitem_Pkg.show_pol_doc_fire_xxx_zone(p_print_zone, i.fitem_typhoon_zone, i.fitem_front, i.fitem_rear, i.fitem_left, i.fitem_right);
			v_fire_item.show_flood_zone					:= Gixx_Fireitem_Pkg.show_pol_doc_fire_xxx_zone(p_print_zone, i.fitem_flood_zone, i.fitem_front, i.fitem_rear, i.fitem_left, i.fitem_right);
			v_fire_item.detail_count					:= Gixx_Fireitem_Pkg.get_record_count(i.extract_id);
			
			PIPE ROW(v_fire_item);
		END LOOP;
	END get_report_details;
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.05.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This function determines if the boundary part of the fire item will be shown
	*/
	FUNCTION show_pol_doc_fire_boundary (
		p_front	IN GIXX_FIREITEM.front%TYPE,
		p_right	IN GIXX_FIREITEM.RIGHT%TYPE,
		p_left	IN GIXX_FIREITEM.LEFT%TYPE,
		p_rear	IN GIXX_FIREITEM.rear%TYPE,
		p_print_tariff_zone	GIIS_DOCUMENT.text%TYPE)
	RETURN VARCHAR2
	IS
		v_show VARCHAR2(1) := 'N';
	BEGIN
		IF NVL(LENGTH(p_front),1) = 1  AND NVL(LENGTH(p_rear),1) = 1 
			AND NVL(LENGTH(p_left),1) = 1 AND NVL(LENGTH(p_right),1)= 1
			AND p_print_tariff_zone = 'N' THEN
			v_show := 'N';
		ELSE
			v_show := 'Y';
		END IF;
		RETURN v_show;
	END show_pol_doc_fire_boundary;
	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.05.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This function returns the number of records by the given extract_id
	*/
	FUNCTION get_record_count(p_extract_id IN GIXX_FIREITEM.extract_id%TYPE)
	RETURN NUMBER
	IS
		v_count NUMBER := 0;
	BEGIN
		SELECT COUNT(extract_id) cnt
		  INTO v_count
		  FROM GIXX_FIREITEM
		 WHERE extract_id = p_extract_id;
		RETURN v_count;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_count := 0;
	RETURN v_count;
	END get_record_count;
	
	FUNCTION show_pol_doc_fire_xxx_zone (
		p_print_zone IN VARCHAR2,		
		p_xxx_zone IN VARCHAR2,
		p_front IN GIXX_FIREITEM.front%TYPE,
		p_rear IN GIXX_FIREITEM.rear%TYPE,
		p_left IN GIXX_FIREITEM.LEFT%TYPE,
		p_right IN GIXX_FIREITEM.RIGHT%TYPE)
	RETURN VARCHAR2
	IS
		v_show VARCHAR2(1) := 'N';
	BEGIN
		IF p_print_zone = 'N' OR p_xxx_zone IS NULL OR 
			(LENGTH(p_front) = 1 AND LENGTH(p_rear) = 1 AND LENGTH(p_left) = 1 AND LENGTH(p_right) = 1) THEN
			v_show := 'N';
		ELSE
			v_show := 'Y';
		END IF;
		RETURN v_show;
	END show_pol_doc_fire_xxx_zone;
    
    FUNCTION get_pack_fi_report_details (
        p_extract_id IN GIXX_ITEM.extract_id%TYPE,
        p_policy_id  IN GIXX_ITEM.policy_id%TYPE,
        p_print_tariff_zone IN VARCHAR2,
        p_print_zone IN VARCHAR2)
    RETURN fire_item_table PIPELINED
    IS
        v_fire_item fire_item_type;
        v_risk_no   GIXX_ITEM.risk_no%TYPE;
        v_item_no   GIXX_ITEM.item_no%TYPE;
    BEGIN
		FOR h IN (
			SELECT ITEM.item_no                  item_item_no,
				   ITEM.item_title               item_item_title,
				   ITEM.item_desc                item_desc,
				   ITEM.item_desc2               item_desc2,
				   ITEM.other_info               item_other_info,
				   ITEM.from_date                item_from_date,
				   ITEM.to_date                  item_to_date,
				   ITEM.coverage_cd              item_coverage_cd,
				   ITEM.currency_rt              item_currency_rt,
				   CURRENCY.currency_desc        item_currency_desc,
				   ITEM.risk_no                  item_risk_no,
				   ITEM.extract_id				 extract_id
			  FROM GIXX_ITEM ITEM,
				   GIIS_CURRENCY CURRENCY
			 WHERE ITEM.policy_id = p_policy_id
			   AND ITEM.extract_id = p_extract_id
			   AND ITEM.currency_cd = CURRENCY.main_currency_cd (+)
		) LOOP
			v_fire_item.extract_id						:= h.extract_id;
            v_fire_item.item_item_no					:= h.item_item_no;
            v_fire_item.item_item_title					:= h.item_item_title;
            v_fire_item.item_desc						:= h.item_desc;
            v_fire_item.item_desc2						:= h.item_desc2;
            v_fire_item.item_coverage_cd				:= h.item_coverage_cd;
            v_fire_item.item_currency_desc				:= h.item_currency_desc;
            v_fire_item.item_risk_no					:= h.item_risk_no;
            v_fire_item.item_other_info					:= h.item_other_info;
            v_fire_item.item_from_date					:= h.item_from_date;
            v_fire_item.item_to_date					:= h.item_to_date;
            v_fire_item.item_currency_rt				:= h.item_currency_rt;
            
            -- to clear additional details 
            v_fire_item.fitem_item_no					:= null;
            v_fire_item.fitem_assignee					:= null;
            v_fire_item.fitem_location_of_risk1			:= null;
            v_fire_item.fitem_location_of_risk2 		:= null;
            v_fire_item.fitem_location_of_risk3			:= null;
            v_fire_item.fitem_fr_item_type				:= null;
            v_fire_item.block_block_desc				:= null;
            v_fire_item.fitem_tarf_cd					:= null;
            v_fire_item.fitem_eq_zone					:= null;
            v_fire_item.fitem_typhoon_zone				:= null;
            v_fire_item.fitem_flood_zone				:= null;
            v_fire_item.ficonstruct_construction_desc	:= null;
            v_fire_item.fitem_construction_remarks		:= null;
            v_fire_item.fiocc_occupancy_desc			:= null;
            v_fire_item.fitem_occupancy_remarks			:= null;
            v_fire_item.fitem_tariff_zone				:= null;
            v_fire_item.fitem_front						:= null;
            v_fire_item.fitem_right						:= null;
            v_fire_item.fitem_left						:= null;
            v_fire_item.fitem_rear						:= null;
            v_fire_item.fitem_block_id					:= null;
            v_fire_item.fitem_block_no					:= null;
            v_fire_item.fitem_district_no				:= null;
            v_fire_item.block_desc						:= null;
            
            v_fire_item.f_item_short_name				:= null;
            v_fire_item.show_boundary					:= null;
            v_fire_item.show_earthquake_zone			:= null;
            v_fire_item.show_typhoon_zone				:= null;
            v_fire_item.show_flood_zone					:= null;
            v_fire_item.detail_count					:= null;
            v_risk_no                                   := null;
            v_fire_item.show_tariff                     := null;
            
			
			FOR i IN (
				SELECT FITEM.policy_id               fitem_policy_id, 
                           FITEM.item_no                 fitem_item_no, 
                           FITEM.assignee                fitem_assignee, 
                           FITEM.loc_risk1               fitem_location_of_risk1, 
                           FITEM.loc_risk2               fitem_location_of_risk2, 
                           FITEM.loc_risk3               fitem_location_of_risk3, 
                           FITYPE.fr_itm_tp_ds           fitem_fr_item_type, 
                           BLK.block_desc                block_block_desc, 
                           FITEM.tarf_cd                 fitem_tarf_cd, 
                           FITEM.eq_zone                 fitem_eq_zone, 
                           FITEM.typhoon_zone            fitem_typhoon_zone, 
                           FITEM.flood_zone              fitem_flood_zone, 
                           FICONSTRUCT.construction_desc ficonstruct_construction_desc, 
                           FITEM.construction_remarks    fitem_construction_remarks, 
                           FIOCC.occupancy_desc          fiocc_occupancy_desc, 
                           FITEM.occupancy_remarks       fitem_occupancy_remarks, 
                           FITEM.tariff_zone             fitem_tariff_zone, 
                           FITEM.front                   fitem_front, 
                           FITEM.right                   fitem_right, 
                           FITEM.left                    fitem_left, 
                           FITEM.rear                    fitem_rear, 
                           FITEM.block_id                fitem_block_id, 
                           FITEM.block_no                fitem_block_no, 
                           FITEM.district_no             fitem_district_no,
                           FITEM.district_no || ' / ' || FITEM.block_no || ' ' || BLK.block_desc BLOCK,
                           BLK.block_desc                block_desc
                    FROM GIXX_FIREITEM FITEM, 
                         GIIS_BLOCK BLK, 
                         GIIS_FIRE_CONSTRUCTION FICONSTRUCT, 
                         GIIS_FIRE_OCCUPANCY FIOCC,
                         GIIS_FI_ITEM_TYPE FITYPE
                    WHERE ((FITEM.block_id = BLK.block_id)
                        AND (FITEM.construction_cd = FICONSTRUCT.construction_cd)
                        AND (FITEM.occupancy_cd = FIOCC.occupancy_cd)
                        AND (FITEM.fr_item_type = FITYPE.fr_item_type))
                        AND FITEM.item_no    = h.item_item_no
                        AND FITEM.extract_id = p_extract_id
                        AND FITEM.policy_id  = p_policy_id
			) LOOP
				v_fire_item.fitem_item_no					:= i.fitem_item_no;
				v_fire_item.fitem_assignee					:= i.fitem_assignee;
				v_fire_item.fitem_location_of_risk1			:= i.fitem_location_of_risk1;
				v_fire_item.fitem_location_of_risk2 		:= i.fitem_location_of_risk2;
				v_fire_item.fitem_location_of_risk3			:= i.fitem_location_of_risk3;
				v_fire_item.fitem_fr_item_type				:= i.fitem_fr_item_type;
				v_fire_item.block_block_desc				:= i.block_block_desc;
				v_fire_item.fitem_tarf_cd					:= i.fitem_tarf_cd;
				v_fire_item.fitem_eq_zone					:= i.fitem_eq_zone;
				v_fire_item.fitem_typhoon_zone				:= i.fitem_typhoon_zone;
				v_fire_item.fitem_flood_zone				:= i.fitem_flood_zone;
				v_fire_item.ficonstruct_construction_desc	:= i.ficonstruct_construction_desc;
				v_fire_item.fitem_construction_remarks		:= i.fitem_construction_remarks;
				v_fire_item.fiocc_occupancy_desc			:= i.fiocc_occupancy_desc;
				v_fire_item.fitem_occupancy_remarks			:= i.fitem_occupancy_remarks;
				v_fire_item.fitem_tariff_zone				:= i.fitem_tariff_zone;
				v_fire_item.fitem_front						:= i.fitem_front;
				v_fire_item.fitem_right						:= i.fitem_right;
				v_fire_item.fitem_left						:= i.fitem_left;
				v_fire_item.fitem_rear						:= i.fitem_rear;
				v_fire_item.fitem_block_id					:= i.fitem_block_id;
				v_fire_item.fitem_block_no					:= i.fitem_block_no;
				v_fire_item.fitem_district_no				:= i.fitem_district_no;
				v_fire_item.block_desc						:= i.block_desc;
				
				v_fire_item.f_item_short_name				:= Giis_Currency_Pkg.get_item_short_name(h.extract_id);
				v_fire_item.show_boundary					:= Gixx_Fireitem_Pkg.show_pol_doc_fire_boundary(i.fitem_front, i.fitem_right, i.fitem_left, i.fitem_rear, p_print_tariff_zone);
				v_fire_item.show_earthquake_zone			:= Gixx_Fireitem_Pkg.show_pol_doc_fire_xxx_zone(p_print_zone, i.fitem_eq_zone, i.fitem_front, i.fitem_rear, i.fitem_left, i.fitem_right);
				v_fire_item.show_typhoon_zone				:= Gixx_Fireitem_Pkg.show_pol_doc_fire_xxx_zone(p_print_zone, i.fitem_typhoon_zone, i.fitem_front, i.fitem_rear, i.fitem_left, i.fitem_right);
				v_fire_item.show_flood_zone					:= Gixx_Fireitem_Pkg.show_pol_doc_fire_xxx_zone(p_print_zone, i.fitem_flood_zone, i.fitem_front, i.fitem_rear, i.fitem_left, i.fitem_right);
				v_fire_item.detail_count					:= Gixx_Fireitem_Pkg.get_record_count(h.extract_id);
				
				IF v_risk_no = h.item_risk_no THEN
					v_risk_no := h.item_risk_no;
					v_fire_item.show_tariff := 'N';
				
				ELSE
					v_risk_no := h.item_risk_no;
					v_fire_item.show_tariff := 'Y'; 
				END IF;                                
                
			END LOOP;            
            
            PIPE ROW(v_fire_item);
		END LOOP;
        
	END get_pack_fi_report_details;
    
    
    
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 5, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves fire irem information
  */
  FUNCTION get_fire_item_info (
        p_extract_id    gixx_fireitem.extract_id%TYPE,
        p_item_no       gixx_fireitem.item_no%TYPE
    ) RETURN fire_item_tab2 PIPELINED
    IS
        v_fire_item     fire_item_type2;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, 
                           fr_item_type, block_id,
                           eq_zone, typhoon_zone, flood_zone, tarf_cd,
                           construction_cd, tariff_zone, occupancy_cd,
                           assignee, district_no, block_no,
                           construction_remarks, occupancy_remarks,
                           loc_risk1, loc_risk2, loc_risk3,
                           front, right, left, rear,
                           latitude, longitude --benjo 01.10.2017 SR-5749
                      FROM gixx_fireitem
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            v_fire_item.extract_id := rec.extract_id;
            v_fire_item.item_no := rec.item_no;
            v_fire_item.fr_item_type := rec.fr_item_type;
--            v_fire_item.province_cd := rec.province_cd;
            v_fire_item.block_id := rec.block_id;
            v_fire_item.eq_zone := rec.eq_zone;
            v_fire_item.typhoon_zone := rec.typhoon_zone;
            v_fire_item.flood_zone := rec.flood_zone;
            v_fire_item.tarf_cd := rec.tarf_cd;
            v_fire_item.construction_cd := rec.construction_cd;
            v_fire_item.tariff_zone := rec.tariff_zone;
            v_fire_item.occupancy_cd := rec.occupancy_cd;
            v_fire_item.assignee := rec.assignee;
            v_fire_item.district_no := rec.district_no;
            v_fire_item.block_no := rec.block_no;
            v_fire_item.construction_remarks := rec.construction_remarks;
            v_fire_item.occupancy_remarks := rec.occupancy_remarks;
            v_fire_item.loc_risk1 := rec.loc_risk1;
            v_fire_item.loc_risk2 := rec.loc_risk2;
            v_fire_item.loc_risk3 := rec.loc_risk3;
            v_fire_item.front := rec.front;
            v_fire_item.right := rec.right;
            v_fire_item.left := rec.left;
            v_fire_item.rear := rec.rear;
            v_fire_item.latitude := rec.latitude;   --benjo 01.10.2017 SR-5749
            v_fire_item.longitude := rec.longitude; --benjo 01.10.2017 SR-5749
            
            FOR a IN (SELECT from_date, to_date
                        FROM gixx_item
                       WHERE extract_id = rec.extract_id
                         AND item_no = rec.item_no)
            LOOP
                v_fire_item.to_date := TRUNC(a.to_date);
                v_fire_item.from_date := TRUNC(a.from_date);
            END LOOP;
            
            FOR b IN (SELECT fr_itm_tp_ds
                        FROM giis_fi_item_type
                       WHERE fr_item_type = rec.fr_item_type)
            LOOP
                v_fire_item.fr_item_desc := b.fr_itm_tp_ds;
                EXIT;
            END LOOP;
            
            FOR c IN (SELECT eq_desc
                        FROM giis_eqzone 
                       WHERE eq_zone = rec.eq_zone)
            LOOP
                v_fire_item.eq_desc := c.eq_desc;
                EXIT;
            END LOOP;
            
            FOR d IN (SELECT construction_desc
                        FROM giis_fire_construction 
                       WHERE construction_cd = rec.construction_cd)
            LOOP
                v_fire_item.construction_desc := d.construction_desc;
                EXIT;
            END LOOP;
              
            FOR e IN (SELECT typhoon_zone_desc
                        FROM giis_typhoon_zone 
                       WHERE typhoon_zone = rec.typhoon_zone)
            LOOP
                v_fire_item.typhoon_zone_desc := e.typhoon_zone_desc;
                EXIT;
            END LOOP; 
        
            FOR f IN (SELECT tariff_zone_desc
                        FROM giis_tariff_zone
                       WHERE tariff_zone = rec.tariff_zone)
            LOOP
                v_fire_item.tariff_zone_desc := f.tariff_zone_desc;
                EXIT;
            END LOOP;
            
            FOR g IN (SELECT tarf_desc
                        FROM giis_tariff
                       WHERE tarf_cd = rec.tarf_cd)
            LOOP
                v_fire_item.tarf_desc := g.tarf_desc;
                EXIT;
            END LOOP;
            
            FOR h IN (SELECT occupancy_desc
                        FROM giis_fire_occupancy
                       WHERE occupancy_cd = rec.occupancy_cd) 
            LOOP
                v_fire_item.occupancy_desc := h.occupancy_desc;
                EXIT;
            END LOOP;
            
            FOR i IN (SELECT flood_zone_desc
                        FROM giis_flood_zone
                       WHERE flood_zone = rec.flood_zone) 
            LOOP
                v_fire_item.flood_zone_desc := i.flood_zone_desc;
                EXIT;
            END LOOP;
            
            FOR j IN (SELECT b.province_desc province
                        FROM giis_block a, giis_province b
                       WHERE a.province_cd = b.province_cd 
                         AND a.block_id = rec.block_id) 
            LOOP
                v_fire_item.province := j.province;
                EXIT;
            END LOOP;
            
            FOR k IN (SELECT city
                          FROM giis_block
                         WHERE block_id = rec.block_id) 
            LOOP
                v_fire_item.city := k.city;
                EXIT;
            END LOOP;    

        
            PIPE ROW(v_fire_item);
        END LOOP;
    
    END get_fire_item_info;
    
END Gixx_Fireitem_Pkg;
/


