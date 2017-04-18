CREATE OR REPLACE PACKAGE BODY CPI.GICL_FIRE_DTL_PKG
AS
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 08.19.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : c014_detail_chk program unit 
   */   
    PROCEDURE c014_detail_chk(c014            IN OUT gicl_fire_dtl_type) IS
      v_exists          number;
      v_district_no     gicl_fire_dtl.district_no%type;
      v_block_no        gicl_fire_dtl.block_no%type;
      v_temp            number;
      --v_status        varchar2(50) := :system.record_status;
    BEGIN
    IF c014.fr_item_type IS NOT NULL THEN
        BEGIN
          SELECT fr_itm_tp_ds
              INTO c014.dsp_item_type 
              FROM giis_fi_item_type
          WHERE fr_item_type = c014.fr_item_type;
            EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Item Type!';
        END;
    ELSE
       c014.dsp_item_type := NULL; 
    END IF;

    IF c014.district_no IS NOT NULL THEN
        BEGIN
          SELECT DISTINCT district_no
          INTO v_district_no
          FROM giis_block
          WHERE district_no = c014.district_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid District Number!';
        END;
    END IF;

    IF c014.eq_zone IS NOT NULL THEN
        BEGIN
          SELECT eq_desc
          INTO c014.dsp_eq_zone
          FROM giis_eqzone
          WHERE eq_zone = c014.eq_zone;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid EQ Zone!';
        END;
    ELSE
       c014.dsp_eq_zone := NULL;
    END IF;

    IF c014.tarf_cd IS NOT NULL THEN
        BEGIN
          SELECT 1
          INTO v_exists
          FROM giis_tariff
          WHERE tarf_cd = c014.tarf_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Tariff Code!';
        END;
    END IF;

    IF c014.block_no IS NOT NULL THEN
        BEGIN
          SELECT DISTINCT block_no
          INTO v_block_no
          FROM giis_block
          WHERE block_no = c014.block_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Block No.!';
        END;
    END IF;

    IF c014.BLOCK_ID IS NOT NULL THEN
        BEGIN
          SELECT 1
          INTO V_EXISTS
          FROM GIIS_BLOCK
          WHERE BLOCK_ID = c014.BLOCK_ID;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Block ID.!';
        END;      
    END IF;

    IF c014.tariff_zone IS NOT NULL THEN
        BEGIN
          SELECT tariff_zone_desc
          INTO c014.dsp_tariff_zone
          FROM giis_tariff_zone
          WHERE tariff_zone = c014.tariff_zone;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Tariff Zone!';
        END;      
    ELSE
       c014.dsp_tariff_zone := NULL; 
    END IF;

    IF c014.typhoon_zone IS NOT NULL THEN
        BEGIN
          SELECT typhoon_zone_desc
          INTO c014.dsp_typhoon
          FROM giis_typhoon_zone
          WHERE typhoon_zone = c014.typhoon_zone;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Typhoon Zone!';
        END;      
    ELSE
       c014.dsp_typhoon := NULL; 
    END IF; 

    IF c014.construction_cd IS NOT NULL THEN
        BEGIN
          SELECT construction_cd
          INTO c014.dsp_construction
          FROM giis_fire_construction
          WHERE construction_cd = c014.construction_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Construction Code!';
        END;      
       --herbert 119101
      --IF get_record_property(:system.cursor_record, :system.current_block, STATUS) <> 'QUERY' THEN
         
       FOR i in (SELECT construction_desc
                   FROM giis_fire_construction
              WHERE construction_cd = c014.dsp_construction) LOOP
           c014.construction_remarks := i.construction_desc;
       END LOOP;

      --END IF;
    ELSE
       c014.dsp_construction := NULL; 
    END IF; 

    IF c014.occupancy_cd IS NOT NULL THEN
        BEGIN
          SELECT occupancy_cd
          INTO c014.dsp_occupancy
          FROM giis_fire_occupancy
          WHERE occupancy_cd = c014.occupancy_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Occupancy Code!';
        END;      
       --Herbert 111901
      --IF get_record_property(:system.cursor_record, :system.current_block, STATUS) <> 'QUERY' THEN

       FOR i in (SELECT occupancy_desc
                   FROM giis_fire_occupancy
              WHERE occupancy_cd = c014.dsp_occupancy) LOOP
           c014.occupancy_remarks := i.occupancy_desc;
       END LOOP;
      --END IF;

    ELSE
       c014.dsp_occupancy := NULL; 
    END IF; 

    IF c014.flood_zone IS NOT NULL THEN
        BEGIN
          SELECT flood_zone_desc --benjo 09.08.2015 GENQA-SR-4874 flood_zone -> flood_zone_desc
          INTO c014.dsp_flood_zone
          FROM giis_flood_zone
          WHERE flood_zone = c014.flood_zone;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            c014.msg_alert := 'Invalid Flood Zone Code!';
        END;      
    ELSE
       c014.dsp_flood_zone := NULL; 
    END IF; 
    END;    

   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 08.18.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : Get the gicl_fire_dtls per claim number 
   */    
    FUNCTION get_gicl_fire_dtl(
        p_claim_id              gicl_fire_dtl.claim_id%TYPE
        )
    RETURN gicl_fire_dtl_tab PIPELINED IS
        v_list              gicl_fire_dtl_type;
        v_exist		        VARCHAR2(1);
    BEGIN
        FOR rec IN(SELECT a.claim_id, a.item_no, a.currency_cd, a.user_id, 
                          a.last_update, a.item_title, a.district_no, a.eq_zone, 
                          a.tarf_cd, a.block_no, a.block_id, a.fr_item_type, 
                          a.loc_risk1, a.loc_risk2, a.loc_risk3, a.tariff_zone, 
                          a.typhoon_zone, a.construction_cd, a.construction_remarks, a.front, 
                          a.right, a.left, a.rear, a.occupancy_cd, 
                          a.occupancy_remarks, a.flood_zone, a.assignee, a.cpi_rec_no, 
                          a.cpi_branch_cd, a.loss_date, a.currency_rate, a.risk_cd
                     FROM gicl_fire_dtl a
                    WHERE a.claim_id = p_claim_id)
        LOOP             
            v_list.claim_id             := rec.claim_id; 
            v_list.item_no              := rec.item_no; 
            v_list.currency_cd          := rec.currency_cd; 
            v_list.user_id              := rec.user_id; 
            v_list.last_update          := rec.last_update; 
            v_list.item_title           := rec.item_title; 
            v_list.district_no          := rec.district_no; 
            v_list.eq_zone              := rec.eq_zone; 
            v_list.tarf_cd              := rec.tarf_cd; 
            v_list.block_no             := rec.block_no; 
            v_list.block_id             := rec.block_id; 
            v_list.fr_item_type         := rec.fr_item_type;
            v_list.loc_risk1            := rec.loc_risk1; 
            v_list.loc_risk2            := rec.loc_risk2; 
            v_list.loc_risk3            := rec.loc_risk3; 
            v_list.tariff_zone          := rec.tariff_zone;
            v_list.typhoon_zone         := rec.typhoon_zone; 
            v_list.construction_cd      := rec.construction_cd; 
            v_list.construction_remarks := rec.construction_remarks; 
            v_list.front                := rec.front; 
            v_list.right                := rec.right;
            v_list.left                 := rec.left; 
            v_list.rear                 := rec.rear; 
            v_list.occupancy_cd         := rec.occupancy_cd; 
            v_list.occupancy_remarks    := rec.occupancy_remarks; 
            v_list.flood_zone           := rec.flood_zone; 
            v_list.assignee             := rec.assignee; 
            v_list.cpi_rec_no           := rec.cpi_rec_no; 
            v_list.cpi_branch_cd        := rec.cpi_branch_cd; 
            v_list.loss_date            := rec.loss_date; 
            v_list.currency_rate        := rec.currency_rate; 
            v_list.risk_cd              := rec.risk_cd; 
            v_list.loss_date_char       := TO_CHAR(rec.loss_date, 'MM-DD-YYYY HH:MI AM'); 
            
            BEGIN
                SELECT DISTINCT 'x'
                  INTO v_exist
                  FROM gicl_fire_dtl
                 WHERE claim_id = p_claim_id;
                IF v_exist IS NOT NULL THEN   	
                  BEGIN
                  SELECT NVL(risk_desc,'')
                    INTO v_list.risk_desc
                    FROM GIIS_RISKS			   	 
                   WHERE risk_cd = v_list.risk_cd
                   AND block_id = v_list.block_id;
                  EXCEPTION 
                  WHEN NO_DATA_FOUND THEN 
                    v_list.risk_desc   := NULL;
                  END;
                END IF;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN 
                v_list.risk_desc   := NULL;
            END;             
            
            BEGIN
              SELECT item_desc, item_desc2
                INTO v_list.item_desc, v_list.item_desc2
                FROM gicl_clm_item
               WHERE 1=1
                 AND claim_id = p_claim_id
                 AND item_no = v_list.item_no
                 AND grouped_item_no = 0;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.item_desc   := NULL;
                v_list.item_desc2  := NULL;
            END;
      
            GICL_FIRE_DTL_PKG.c014_detail_chk(v_list);
            
            FOR c IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = v_list.currency_cd) 
            LOOP
               v_list.dsp_currency_desc := c.currency_desc;
            END LOOP;
            
            SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist(v_list.item_no, v_list.claim_id)
              INTO v_list.gicl_item_peril_exist
              FROM dual;
              
            SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist(v_list.item_no, v_list.claim_id)
              INTO v_list.gicl_mortgagee_exist
              FROM dual;
                
            gicl_item_peril_pkg.validate_peril_reserve(v_list.item_no, 
                                                       v_list.claim_id,
                                                       0, --belle grouped item no 02.13.2012
                                                       v_list.gicl_item_peril_msg);
            
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 09.01.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : extract_fire_data program unit - extracting fire details 
   */  
    PROCEDURE extract_fire_data(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
        c014            IN OUT gicl_fire_dtl_type
        ) IS
      v_item_desc               gipi_item.item_desc%type;
      v_item_desc2              gipi_item.item_desc2%type;
      v_assignee 	 	        gipi_fireitem.assignee%TYPE;
      v_currency_cd 	        gipi_item.currency_cd%TYPE;
      v_currency_desc	        giis_currency.currency_desc%TYPE;
      v_currency_rt 	        gipi_item.currency_rt%TYPE;
      v_fr_item_type 	        gipi_fireitem.fr_item_type%TYPE;
      v_item_title 	            gipi_item.item_title%TYPE;
      v_district_no 	        gipi_fireitem.district_no%TYPE;
      v_block_no   		        gipi_fireitem.block_no%TYPE;  
      v_block_id 		        gipi_fireitem.block_id%TYPE;
      v_eq_zone  		        gipi_fireitem.eq_zone%TYPE;
      v_typhoon_zone  	        gipi_fireitem.typhoon_zone%TYPE;
      v_flood_zone  	        gipi_fireitem.flood_zone%TYPE;
      v_tariff_zone 	        gipi_fireitem.tariff_zone%TYPE;
      v_tarf_cd		            gipi_fireitem.tarf_cd%TYPE;
      v_loc_risk1      	        gipi_fireitem.loc_risk1%TYPE;
      v_loc_risk2  		        gipi_fireitem.loc_risk2%TYPE;
      v_loc_risk3 		        gipi_fireitem.loc_risk3%TYPE;
      v_front 		            gipi_fireitem.front%TYPE;
      v_rear 		            gipi_fireitem.rear%TYPE;
      v_left  		            gipi_fireitem.left%TYPE;
      v_right 		            gipi_fireitem.right%TYPE;
      v_occupancy_cd   	        gipi_fireitem.occupancy_cd%TYPE;
      v_occupancy_remarks	    gipi_fireitem.occupancy_remarks%TYPE;  
      v_construction_cd 	    gipi_fireitem.construction_cd%TYPE;
      v_construction_remarks    gipi_fireitem.construction_remarks%TYPE;
      v_max_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE  := 0;
      v_risk_cd 		        gipi_fireitem.risk_cd%TYPE;  
      v_risk_desc			    giis_risks.risk_desc%TYPE;
    BEGIN
        -------------------------------------------------
        --first get info. from policy and all valid endt.
        -------------------------------------------------
        FOR c1 IN (
                  SELECT c.item_desc,c.item_desc2,endt_seq_no, d.assignee, c.currency_cd, e.currency_desc, d.fr_item_type, d.district_no,
                         d.block_no, d.block_id, d.eq_zone, d.typhoon_zone, d.flood_zone, d.tariff_zone, d.tarf_cd,
                         d.loc_risk1, d.loc_risk2, d.loc_risk3, d.front, d.rear, d.left, d.right, d.occupancy_cd,
                         d.occupancy_remarks, d.construction_cd, d.construction_remarks, c.currency_rt,
                         c.item_title,d.risk_cd--,f.risk_desc -- jess 06092010 add risk_desc Comment out by Marlo 06172010
                    FROM gipi_polbasic b, gipi_item c, gipi_fireitem d, giis_currency e--, giis_risks f -- jess 06092010 add giis_risks Comment out by Marlo 07162010
                   WHERE --:control.claim_id = :global.claim_id AND 
                         p_line_cd = b.line_cd 
                     AND p_subline_cd = b.subline_cd 
                     AND p_pol_iss_cd = b.iss_cd 
                     AND c.item_no = p_item_no 
                     AND p_issue_yy = b.issue_yy 
                     AND p_pol_seq_no = b.pol_seq_no 
                     AND p_renew_no = b.renew_no 
                     AND b.policy_id = c.policy_id 
                     AND c.currency_cd = e.main_currency_cd 
                     AND c.policy_id = d.policy_id 
                     AND c.item_no = d.item_no 
                     --AND d.block_id = f.block_id -- jess 06092010 Comment out by Marlo 06172010
                     --AND d.risk_cd = f.risk_cd -- jess 06092010
                     AND b.pol_flag in ('1','2','3','4','X')    --kenneth SR4855 10072015
                     AND trunc(DECODE(NVL(C.from_date,b.eff_date),b.incept_date, NVL(C.from_date,p_pol_eff_date), NVL(C.from_date,b.eff_date) ))
                         <= p_loss_date 
                     AND TRUNC(DECODE(NVL(c.to_date,NVL(b.endt_expiry_date, b.expiry_date)),
                         b.expiry_date,NVL(C.to_date,p_expiry_date),NVL(c.to_date,b.endt_expiry_date)))  
                         >= p_loss_date
                   ORDER BY NVL(c.from_date,b.eff_date) ASC) 
        LOOP
          --v_item_desc	 := c1.item_desc;
          v_item_desc       := NVL(c1.item_desc,v_item_desc);
          v_item_desc2      := NVL(c1.item_desc2,v_item_desc2);
          v_max_endt_seq_no := c1.endt_seq_no;
          v_assignee 		:= NVL(c1.assignee, v_assignee);
          v_currency_cd 	:= NVL(c1.currency_cd, v_currency_cd);
          v_currency_rt 	:= NVL(c1.currency_rt, v_currency_rt);
          v_currency_desc	:= NVL(c1.currency_desc, v_currency_desc);
          v_fr_item_type 	:= NVL(c1.fr_item_type, v_fr_item_type);
          v_item_title 	    := NVL(c1.item_title, v_item_title);
          v_district_no 	:= NVL(c1.district_no, v_district_no);
          v_block_no   		:= NVL(c1.block_no, v_block_no);  
          v_block_id 		:= NVL(c1.block_id, v_block_id);
          v_eq_zone  		:= NVL(c1.eq_zone, v_eq_zone);
          v_typhoon_zone  	:= NVL(c1.typhoon_zone, v_typhoon_zone);
          v_flood_zone  	:= NVL(c1.flood_zone, v_flood_zone);
          v_tariff_zone 	:= NVL(c1.tariff_zone, v_tariff_zone);
          v_tarf_cd		    := NVL(c1.tarf_cd, v_tarf_cd);
          v_loc_risk1      	:= NVL(c1.loc_risk1, v_loc_risk1);
          v_loc_risk2  		:= NVL(c1.loc_risk2, v_loc_risk2);
          v_loc_risk3 		:= NVL(c1.loc_risk3, v_loc_risk3);
          v_front 		    := NVL(c1.front, v_front);
          v_rear 		    := NVL(c1.rear, v_rear);
          v_left  		    := NVL(c1.left, v_left);
          v_right 		    := NVL(c1.right, v_right);
          v_occupancy_cd   	:= NVL(c1.occupancy_cd, v_occupancy_cd);
          v_occupancy_remarks	    := NVL(c1.occupancy_remarks, v_occupancy_remarks);
          v_construction_cd 	    := NVL(c1.construction_cd, v_construction_cd); 
          v_construction_remarks    := NVL(c1.construction_remarks, v_construction_remarks);
          v_risk_cd         := NVL(C1.risk_cd,v_risk_cd);
          --v_risk_desc := NVL(C1.risk_desc,v_risk_desc); -- jess 06092010 Comment out by Marlo 07162010
          /* Added by Marlo 
          ** 06172010
          ** To populate separately the risk description. 
          ** To populate fire details even though the policy has no risk*/
          FOR i IN (SELECT risk_desc 
                      FROM giis_risks
                     WHERE block_id = v_block_id
                       AND risk_cd = v_risk_cd)
          LOOP
            v_risk_desc := i.risk_desc;
          END LOOP;
        END LOOP;

        ------------------------------
        --get info from backward endt.
        ------------------------------
        FOR c2 IN (
          SELECT c.item_desc,c.item_desc2,d.assignee, c.currency_cd, e.currency_desc, d.fr_item_type, d.district_no,
                 d.block_no, d.block_id, d.eq_zone, d.typhoon_zone, d.flood_zone, d.tariff_zone, d.tarf_cd,
                 d.loc_risk1, d.loc_risk2, d.loc_risk3, d.front, d.rear, d.left, d.right, d.occupancy_cd,
                 d.occupancy_remarks, d.construction_cd, d.construction_remarks, c.currency_rt,
                 item_title, d.risk_cd--,f.risk_desc -- jess 06092010 add risk_desc Comment out by Marlo 07162010
          FROM gipi_polbasic b, gipi_item c, gipi_fireitem d, giis_currency e--, giis_risks f -- jess 06092010 add giis_risks Comment out by Marlo 07162010
          WHERE --:control.claim_id = :global.claim_id AND 
                p_line_cd = b.line_cd 
            AND p_subline_cd = b.subline_cd 
            AND p_pol_iss_cd = b.iss_cd 
            AND c.item_no = p_item_no 
            AND p_issue_yy = b.issue_yy 
            AND p_pol_seq_no = b.pol_seq_no 
            AND p_renew_no = b.renew_no 
            AND b.policy_id = c.policy_id 
            AND c.currency_cd = e.main_currency_cd 
            AND c.policy_id = d.policy_id 
            AND c.item_no = d.item_no
            --AND d.block_id = f.block_id -- jess 06092010 Comment out by Marlo 07162010
            --AND d.risk_cd = f.risk_cd -- jess 06092010 Comment out by Marlo 07162010
            AND NVL(b.back_stat,5) = 2
            AND b.pol_flag in ('1','2','3','4','X') --kenneth SR4855 10072015
            AND endt_seq_no > v_max_endt_seq_no
            AND trunc(DECODE(TRUNC(NVL(c.from_date,b.eff_date)),TRUNC(b.incept_date), NVL(C.from_date,p_pol_eff_date), NVL(C.from_date,b.eff_date) )) 
                <= p_loss_date 
            AND TRUNC(DECODE(NVL(c.to_date,NVL(b.endt_expiry_date, b.expiry_date)),
                b.expiry_date, NVL(c.to_date,p_expiry_date), NVL(c.to_date,b.endt_expiry_date)))  
                >= p_loss_date
          ORDER BY endt_seq_no ASC) 
        LOOP
          v_item_desc       := NVL(c2.item_desc,v_item_desc);
          v_item_desc2      := NVL(c2.item_desc2,v_item_desc2);
          v_assignee 		:= NVL(c2.assignee, v_assignee);
          v_currency_cd 	:= NVL(c2.currency_cd, v_currency_cd);
          v_currency_desc	:= NVL(c2.currency_desc, v_currency_desc);
          v_currency_rt 	:= NVL(c2.currency_rt, v_currency_rt);
          v_fr_item_type 	:= NVL(c2.fr_item_type, v_fr_item_type);
          v_item_title 	    := NVL(c2.item_title, v_item_title);
          v_district_no 	:= NVL(c2.district_no, v_district_no);
          v_block_no   		:= NVL(c2.block_no, v_block_no);  
          v_block_id 		:= NVL(c2.block_id, v_block_id);
          v_eq_zone  		:= NVL(c2.eq_zone, v_eq_zone);
          v_typhoon_zone  	:= NVL(c2.typhoon_zone, v_typhoon_zone);
          v_flood_zone  	:= NVL(c2.flood_zone, v_flood_zone);
          v_tariff_zone 	:= NVL(c2.tariff_zone, v_tariff_zone);
          v_tarf_cd		    := NVL(c2.tarf_cd, v_tarf_cd);
          v_loc_risk1      	:= NVL(c2.loc_risk1, v_loc_risk1);
          v_loc_risk2  		:= NVL(c2.loc_risk2, v_loc_risk2);
          v_loc_risk3 		:= NVL(c2.loc_risk3, v_loc_risk3);
          v_front 		    := NVL(c2.front, v_front);
          v_rear 		    := NVL(c2.rear, v_rear);
          v_left  		    := NVL(c2.left, v_left);
          v_right 		    := NVL(c2.right, v_right);
          v_occupancy_cd   	:= NVL(c2.occupancy_cd, v_occupancy_cd);
          v_occupancy_remarks	    := NVL(c2.occupancy_remarks, v_occupancy_remarks);
          v_construction_cd 	    := NVL(c2.construction_cd, v_construction_cd); 
          v_construction_remarks    := NVL(c2.construction_remarks, v_construction_remarks);
          v_risk_cd         := NVL(C2.risk_cd,v_risk_cd);  
          --v_risk_desc := NVL(C2.risk_desc,v_risk_desc); -- jess 06092010 Comment out by Marlo 07162010
          /* Added by Marlo 
          ** 06172010
          ** To populate separately the risk description. 
          ** To populate fire details even though the policy has no risk*/
          FOR i IN (SELECT risk_desc 
                      FROM giis_risks
                     WHERE block_id = v_block_id
                       AND risk_cd = v_risk_cd)
          LOOP
            v_risk_desc := i.risk_desc;
          END LOOP;
        END LOOP;

      c014.item_no              := p_item_no;
      c014.currency_cd 	        := v_currency_cd;	
      c014.item_title 	        := v_item_title;	
      c014.district_no	        := v_district_no;	
      c014.eq_zone 	            := v_eq_zone;  	
      c014.tarf_cd		        := v_tarf_cd;
      c014.block_no 	        := v_block_no; 		
      c014.block_id	            := v_block_id; 	
      c014.fr_item_type 	    := v_fr_item_type;	
      c014.loc_risk1	        := v_loc_risk1;      	
      c014.loc_risk2	        := v_loc_risk2;  		
      c014.loc_risk3	        := v_loc_risk3;
      c014.tariff_zone 	        := v_tariff_zone;	
      c014.typhoon_zone         := v_typhoon_zone;  
      c014.construction_cd      := v_construction_cd; 	
      c014.construction_remarks := v_construction_remarks;
      c014.front		        := v_front; 	
      c014.right		        := v_right;
      c014.left		            := v_left;
      c014.rear		            := v_rear;	
      c014.occupancy_cd	        := v_occupancy_cd;   	
      c014.occupancy_remarks    := v_occupancy_remarks;
      c014.flood_zone	        := v_flood_zone;	
      c014.assignee 	        := v_assignee;	
      c014.currency_rate 	    := v_currency_rt;
      c014.risk_cd              :=  v_risk_cd;
      c014.risk_desc            := v_risk_desc;
      c014.item_desc	        := v_item_desc;
      c014.item_desc2	        := v_item_desc2;
      c014.dsp_currency_desc    := v_currency_desc;	
      
      FOR i IN (SELECT FR_ITM_TP_DS
                  FROM GIIS_FI_ITEM_TYPE
                 WHERE FR_ITEM_TYPE = c014.fr_item_type) 
      LOOP
        c014.dsp_item_type := i.fr_itm_tp_ds;
      END LOOP;
    END;
        
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 09.01.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : Get the gicl_fire_dtls per claim number 
   */  
    FUNCTION get_gicl_fire_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE)
    RETURN gicl_fire_dtl_tab PIPELINED IS
      c014            gicl_fire_dtl_type;
    BEGIN
    	GICL_FIRE_DTL_PKG.extract_fire_data(p_line_cd, p_subline_cd, p_pol_iss_cd, 
                          p_issue_yy, p_pol_seq_no, p_renew_no, 
                          p_pol_eff_date, p_expiry_date, p_loss_date, 
                          p_item_no, c014);
                          
        GICL_FIRE_DTL_PKG.c014_detail_chk(c014);
        
        PIPE ROW(c014);                                         
    RETURN;
    END;
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 09.02.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : validate item no. 
   */     
    PROCEDURE validate_gicl_fire_dtl(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_incept_date           gipi_polbasic.incept_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE,
        p_claim_id              gicl_fire_dtl.claim_id%TYPE,
        p_from                  VARCHAR2,
        p_to                    VARCHAR2,
        c014                OUT GICL_FIRE_DTL_PKG.gicl_fire_dtl_cur,
        p_item_exist        OUT NUMBER,
        p_override_fl       OUT VARCHAR2,
        p_tloss_fl          OUT VARCHAR2,
        p_item_exist2       OUT VARCHAR2
        ) IS
    BEGIN
        SELECT gicl_fire_dtl_pkg.check_fire_item_no(p_claim_id,p_item_no, p_from, p_to) 
          INTO p_item_exist2
          FROM dual;
    
        SELECT Giac_Validate_User_Fn(giis_users_pkg.app_user, 'TL', 'GICLS015')
          INTO p_override_fl
          FROM dual;
        
        SELECT gicl_fire_dtl_pkg.check_existing_item(   --kenneth SR4855 10072015
			    p_line_cd, p_subline_cd, p_pol_iss_cd, 
				p_issue_yy, p_pol_seq_no, p_renew_no, 
				p_pol_eff_date, p_expiry_date, p_loss_date,
                p_item_no
				) 
          INTO p_item_exist      
		  FROM dual;
    
        SELECT Check_Total_Loss_Settlement2(
                    0, NULL, p_item_no, 
                    p_line_cd, p_subline_cd, p_pol_iss_cd,
                    p_issue_yy, p_pol_seq_no, p_renew_no, 
                    p_loss_date, p_pol_eff_date, p_expiry_date)
          INTO p_tloss_fl          
          FROM dual;           

        OPEN c014 FOR
            SELECT * 
              FROM TABLE(GICL_FIRE_DTL_PKG.get_gicl_fire_dtl(
                            p_line_cd, p_subline_cd, p_pol_iss_cd, 
                            p_issue_yy, p_pol_seq_no, p_renew_no,
                            p_pol_eff_date, p_expiry_date, p_loss_date, 
                            p_incept_date, p_item_no)
                        );
    END;
            
    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.12.2011   
   **  Reference By : (GICLS025 - Claims Fire Item Information)
   **  Description  : check item_no if exist
   */
    FUNCTION check_fire_item_no (
        p_claim_id        gicl_fire_dtl.claim_id%TYPE,
        p_item_no         gicl_fire_dtl.item_no%TYPE,
        p_start_row       VARCHAR2,
        p_end_row         VARCHAR2
    ) 
    RETURN VARCHAR2 IS
        v_exist   VARCHAR2 (1);
    BEGIN
        BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE
                                   (gicl_fire_dtl_pkg.get_gicl_fire_dtl(p_claim_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND item_no = p_item_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_exist := 'N';
        END;
        RETURN v_exist;
    END;
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 09.15.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  delete record in gicl_fire_dtl 
   */  
    PROCEDURE del_gicl_fire_dtl(
        p_claim_id      gicl_fire_dtl.claim_id%TYPE,
        p_item_no       gicl_fire_dtl.item_no%TYPE
        ) IS
    BEGIN
        DELETE FROM gicl_fire_dtl
         WHERE claim_id = p_claim_id 
           AND item_no  = p_item_no;
    END;
      
    /*
    **  Created by   :  Jerome Orio
    **  Date Created :  09.16.2011   
    **  Reference By : (GICLS025 - Claims Fire Item Information)
    **  Description  : insert/update records in gicl_fire_dtl table 
    */    
    PROCEDURE set_gicl_fire_dtl(
        p_claim_id              gicl_fire_dtl.claim_id%TYPE,
        p_item_no               gicl_fire_dtl.item_no%TYPE,
        p_currency_cd           gicl_fire_dtl.currency_cd%TYPE,
        p_user_id               gicl_fire_dtl.user_id%TYPE,
        p_last_update           gicl_fire_dtl.last_update%TYPE,
        p_item_title            gicl_fire_dtl.item_title%TYPE,
        p_district_no           gicl_fire_dtl.district_no%TYPE,
        p_eq_zone               gicl_fire_dtl.eq_zone%TYPE,
        p_tarf_cd               gicl_fire_dtl.tarf_cd%TYPE,
        p_block_no              gicl_fire_dtl.block_no%TYPE,
        p_block_id              gicl_fire_dtl.block_id%TYPE,
        p_fr_item_type          gicl_fire_dtl.fr_item_type%TYPE,
        p_loc_risk1             gicl_fire_dtl.loc_risk1%TYPE,
        p_loc_risk2             gicl_fire_dtl.loc_risk2%TYPE,
        p_loc_risk3             gicl_fire_dtl.loc_risk3%TYPE,
        p_tariff_zone           gicl_fire_dtl.tariff_zone%TYPE,
        p_typhoon_zone          gicl_fire_dtl.typhoon_zone%TYPE,
        p_construction_cd       gicl_fire_dtl.construction_cd%TYPE,
        p_construction_remarks  gicl_fire_dtl.construction_remarks%TYPE,
        p_front                 gicl_fire_dtl.front%TYPE,
        p_right                 gicl_fire_dtl.right%TYPE,
        p_left                  gicl_fire_dtl.left%TYPE,
        p_rear                  gicl_fire_dtl.rear%TYPE,
        p_occupancy_cd          gicl_fire_dtl.occupancy_cd%TYPE,
        p_occupancy_remarks     gicl_fire_dtl.occupancy_remarks%TYPE,
        p_flood_zone            gicl_fire_dtl.flood_zone%TYPE,
        p_assignee              gicl_fire_dtl.assignee%TYPE,
        p_cpi_rec_no            gicl_fire_dtl.cpi_rec_no%TYPE,
        p_cpi_branch_cd         gicl_fire_dtl.cpi_branch_cd%TYPE,
        p_loss_date             gicl_fire_dtl.loss_date%TYPE,
        p_currency_rate         gicl_fire_dtl.currency_rate%TYPE,
        p_risk_cd               gicl_fire_dtl.risk_cd%TYPE
        ) IS
      v_loss_date             gicl_claims.dsp_loss_date%TYPE;
    BEGIN
        FOR date IN (SELECT dsp_loss_date
		               FROM gicl_claims
		              WHERE claim_id = p_claim_id) LOOP
          v_loss_date := date.dsp_loss_date;
        END LOOP;
    
        MERGE INTO gicl_fire_dtl
             USING dual
                ON (claim_id = p_claim_id
               AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (claim_id, item_no, currency_cd, user_id, 
                    last_update, item_title, district_no, eq_zone, 
                    tarf_cd, block_no, block_id, fr_item_type, 
                    loc_risk1, loc_risk2, loc_risk3, tariff_zone, 
                    typhoon_zone, construction_cd, construction_remarks, front, 
                    right, left, rear, occupancy_cd, 
                    occupancy_remarks, flood_zone, assignee, cpi_rec_no, 
                    cpi_branch_cd, loss_date, currency_rate, risk_cd)
            VALUES (p_claim_id, p_item_no,p_currency_cd, giis_users_pkg.app_user, 
                    sysdate, p_item_title, p_district_no, p_eq_zone, 
                    p_tarf_cd, p_block_no, p_block_id, p_fr_item_type, 
                    p_loc_risk1, p_loc_risk2, p_loc_risk3, p_tariff_zone, 
                    p_typhoon_zone, p_construction_cd, p_construction_remarks, p_front, 
                    p_right, p_left, p_rear, p_occupancy_cd, 
                    p_occupancy_remarks, p_flood_zone, p_assignee, p_cpi_rec_no, 
                    p_cpi_branch_cd, v_loss_date, p_currency_rate, p_risk_cd)
        WHEN MATCHED THEN
            UPDATE 
               SET  currency_cd           = p_currency_cd,
                    user_id               = giis_users_pkg.app_user,
                    last_update           = sysdate,
                    item_title            = p_item_title,
                    district_no           = p_district_no,
                    eq_zone               = p_eq_zone,
                    tarf_cd               = p_tarf_cd,
                    block_no              = p_block_no,
                    block_id              = p_block_id,
                    fr_item_type          = p_fr_item_type,
                    loc_risk1             = p_loc_risk1,
                    loc_risk2             = p_loc_risk2,
                    loc_risk3             = p_loc_risk3,
                    tariff_zone           = p_tariff_zone,
                    typhoon_zone          = p_typhoon_zone,
                    construction_cd       = p_construction_cd,
                    construction_remarks  = p_construction_remarks,
                    front                 = p_front,
                    right                 = p_right,
                    left                  = p_left,
                    rear                  = p_rear,
                    occupancy_cd          = p_occupancy_cd,
                    occupancy_remarks     = p_occupancy_remarks,
                    flood_zone            = p_flood_zone,
                    assignee              = p_assignee,
                    cpi_rec_no            = p_cpi_rec_no,
                    cpi_branch_cd         = p_cpi_branch_cd,
                    loss_date             = v_loss_date,
                    currency_rate         = p_currency_rate,
                    risk_cd               = p_risk_cd;                    
    END;
        
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 10.21.2011
   **  Reference By  : (GICLS010 - Basic Information) 
   **  Description   : check if gicl_fire_dtl exist 
   */        
    FUNCTION get_gicl_fire_dtl_exist( 
        p_claim_id          gicl_fire_dtl.claim_id%TYPE
        ) 
    RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_fire_dtl
                 WHERE claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;
    
   --kenneth SR4855 10072015
   FUNCTION get_item_no_list (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                          get_latest_item_title2 (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', '4', 'X')
                      AND TRUNC (DECODE (TRUNC (NVL (b.from_date, eff_date)),
                                         TRUNC (a.incept_date), NVL
                                                               (b.from_date,
                                                                p_pol_eff_date
                                                               ),
                                         NVL (b.from_date, a.eff_date)
                                        )
                                ) <= TRUNC(p_loss_date)
                      AND TRUNC (DECODE (NVL (b.TO_DATE,
                                              NVL (a.endt_expiry_date,
                                                   a.expiry_date
                                                  )
                                             ),
                                         a.expiry_date, NVL (b.TO_DATE,
                                                             p_expiry_date
                                                            ),
                                         NVL (b.TO_DATE, a.endt_expiry_date)
                                        )
                                ) >= TRUNC(p_loss_date)
                      AND a.policy_id = b.policy_id)
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
   --kenneth SR4855 10072015
   FUNCTION check_existing_item (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR h IN
         (SELECT c.item_no
            FROM gipi_item c, gipi_polbasic b
           WHERE                   --:control.claim_id = :global.claim_id AND
                 p_line_cd = b.line_cd
             AND p_subline_cd = b.subline_cd
             AND p_pol_iss_cd = b.iss_cd
             AND p_issue_yy = b.issue_yy
             AND p_pol_seq_no = b.pol_seq_no
             AND p_renew_no = b.renew_no
             AND b.policy_id = c.policy_id
             AND b.pol_flag IN ('1', '2', '3', '4', 'X')
             AND TRUNC (DECODE (TRUNC (b.eff_date),
                                TRUNC (b.incept_date), p_pol_eff_date,
                                b.eff_date
                               )
                       ) <= p_loss_date
             --AND TRUNC(b.eff_date) <= :control.loss_date
             AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                b.expiry_date, p_expiry_date,
                                b.endt_expiry_date
                               )
                       ) >= p_loss_date
             AND c.item_no = p_item_no)
      LOOP
         v_exist := 1;
      END LOOP;

      RETURN v_exist;
   END;
        
END gicl_fire_dtl_pkg;
/


