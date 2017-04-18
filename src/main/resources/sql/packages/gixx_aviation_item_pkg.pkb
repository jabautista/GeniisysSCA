CREATE OR REPLACE PACKAGE BODY CPI.GIXX_AVIATION_ITEM_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 04.021.2010
	**  Reference By 	: (Policy Documents)
	**  Description 	: This procedure returns records from gixx_aviation_item av,
	**			   		  gixx_item item, giis_currency curr, and giis_vessel vessel
	*/
	FUNCTION get_pol_doc_records (p_extract_id GIXX_ITEM.extract_id%TYPE)
	RETURN aviation_item_tab PIPELINED
	IS
		v_aviation aviation_item_type;
	BEGIN
		FOR i IN (
			SELECT ALL item.extract_id extract_id,
				   item.item_no item_item_no,
				   item.item_title item_item_title,
				   item.item_desc item_desc,
				   item.item_desc2 item_desc2,
				   item.coverage_cd item_coverage_cd,
				   curr.currency_desc item_currency_desc,
				   item.other_info item_other_info,
				   item.from_date item_from_date,
				   item.TO_DATE item_to_date,
				   item.currency_rt item_currency_rt,
				   av.total_fly_time av_total_fly_time,
				   av.qualification av_qualification, 
				   av.purpose av_purpose,
				   av.geog_limit av_geog_limit,
				   av.deduct_text av_deduct_txt,
				   av.vessel_cd av_vessel_cd,
				   av.prev_util_hrs av_prev_util_hrs,
				   av.est_util_hrs av_est_util_hrs,
				   vessel.vessel_name av_vessel_name,
				   vessel.rpc_no av_rpc_no
			  FROM GIXX_AVIATION_ITEM av,
				   GIXX_ITEM item,
				   GIIS_CURRENCY curr,
				   GIIS_VESSEL vessel
			 WHERE av.extract_id = item.extract_id
			   AND av.item_no = item.item_no
			   AND item.currency_cd = curr.main_currency_cd
			   AND av.vessel_cd = vessel.vessel_cd
			   AND item.extract_id = p_extract_id)
		LOOP
			v_aviation.extract_id			:= i.extract_id;
			v_aviation.item_no				:= i.item_item_no;
			v_aviation.item_title			:= i.item_item_title;
			v_aviation.item_desc			:= i.item_desc;
			v_aviation.item_desc2			:= i.item_desc2;
			v_aviation.item_coverage_cd		:= i.item_coverage_cd;
			v_aviation.item_currency_desc	:= i.item_currency_desc;
			v_aviation.item_other_info		:= i.item_other_info;
			v_aviation.item_from_date		:= i.item_from_date;
			v_aviation.item_to_date			:= i.item_to_date;
			v_aviation.item_currency_rt		:= i.item_currency_rt;
			v_aviation.av_total_fly_time	:= i.av_total_fly_time;
			v_aviation.av_qualification		:= i.av_qualification;
			v_aviation.av_purpose			:= i.av_purpose;
			v_aviation.av_geog_limit		:= i.av_geog_limit;
			v_aviation.av_deduct_txt        := i.av_deduct_txt;
			v_aviation.av_vessel_cd			:= i.av_vessel_cd;
			v_aviation.av_prev_util_hrs		:= i.av_prev_util_hrs;
			v_aviation.av_est_util_hrs		:= i.av_est_util_hrs;
			v_aviation.av_vessel_name		:= i.av_vessel_name;
			v_aviation.av_rpc_no			:= i.av_rpc_no;
			
			PIPE ROW(v_aviation);
		END LOOP;
		RETURN;
	END get_pol_doc_records;
    
    
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 4, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves aviation item information for GIPIS101
    */
    FUNCTION get_aviation_item_info(
        p_extract_id        gixx_aviation_item.extract_id%TYPE,
        p_item_no           gixx_aviation_item.item_no%TYPE
    ) RETURN aviation_item_tab2 PIPELINED
    IS
        v_aviation_item     aviation_item_type2;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, vessel_cd, geog_limit,
                           prev_util_hrs, est_util_hrs, total_fly_time,
                           deduct_text, purpose, qualification
                      FROM gixx_aviation_item
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            FOR a IN (SELECT vessel_name
                        FROM giis_vessel
                       WHERE vessel_cd = rec.vessel_cd)
            LOOP
                v_aviation_item.vessel_name := a.vessel_name;
            END LOOP;
            
            FOR b IN (SELECT air_desc
                        FROM giis_air_type
                       WHERE air_type_cd IN (SELECT air_type_cd
                                               FROM giis_vessel
                                              WHERE vessel_cd = rec.vessel_cd))
            LOOP
                v_aviation_item.air_desc := b.air_desc;
            END LOOP;
            
            FOR c IN (SELECT rpc_no
                        FROM giis_vessel
                       WHERE vessel_cd = rec.vessel_cd)
            LOOP
                v_aviation_item.rpc_no := c.rpc_no;
            END LOOP;
            
            BEGIN        
               SELECT item_title 
                 INTO v_aviation_item.item_title 
                 FROM gixx_item
                WHERE extract_id = rec.extract_id 
                  AND item_no = rec.item_no;
                  
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_aviation_item.item_title    := '';
            END;
            
            v_aviation_item.extract_id := rec.extract_id;
            v_aviation_item.item_no := rec.item_no;
            v_aviation_item.vessel_cd := rec.vessel_cd;
            v_aviation_item.prev_util_hrs := rec.prev_util_hrs;
            v_aviation_item.est_util_hrs := rec.est_util_hrs;
            v_aviation_item.total_fly_time := rec.total_fly_time;
            v_aviation_item.qualification := rec.qualification;
            v_aviation_item.purpose := rec.purpose;
            v_aviation_item.deduct_text := rec.deduct_text;
            v_aviation_item.geog_limit := rec.geog_limit;
        
            PIPE ROW(v_aviation_item);
            
        END LOOP;        
    END get_aviation_item_info;
    
    
END GIXX_AVIATION_ITEM_PKG;
/


