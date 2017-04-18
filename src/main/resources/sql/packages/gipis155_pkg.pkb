CREATE OR REPLACE PACKAGE BODY CPI.GIPIS155_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   09.26.2013
     ** Referenced By:  GIPIS155 - UPDATE POLICY DISTRICT/ BLOCK/ EQ ZONE/ FLOOD ZONE/ TYPHOON ZONE/ TARIFF ZONE
     **/
     
    FUNCTION get_fireitem_listing(
        p_policy_id             VARCHAR2
    ) RETURN fireitem_tab PIPELINED
    AS
        TYPE cur_type IS REF CURSOR;
        
        rec         fireitem_type;
        custom      cur_type;
        v_query     VARCHAR2(1500);
    BEGIN                  
        FOR i IN (SELECT policy_id, item_no, block_id, district_no, block_no, eq_zone, flood_zone,
                         typhoon_zone, tarf_cd, tariff_zone, risk_cd, user_id, 
                         TO_CHAR(last_update, 'MM-DD-RRRR HH:MI:SS') last_update
                    FROM GIPI_FIREITEM
                   WHERE policy_id = p_policy_id)
        LOOP
             rec.policy_id      := i.policy_id;
             rec.item_no        := i.item_no;
             rec.block_id       := i.block_id;
             rec.district_no    := i.district_no;
             rec.block_no       := i.block_no;
             rec.eq_zone        := i.eq_zone;
             rec.flood_zone     := i.flood_zone;
             rec.typhoon_zone   := i.typhoon_zone;
             rec.tarf_cd        := i.tarf_cd;
             rec.tariff_zone    := i.tariff_zone;
             rec.risk_cd        := i.risk_cd;
             rec.user_id        := i.user_id;
             rec.last_update    := i.last_update;
                  
            /*** POST-QUERY ***/  
            FOR C1 IN (	SELECT a070.province_cd, a070.district_no, a070.district_desc, a070.block_no,
                             a070.city_cd,     a070.city,        a070.block_desc
                          FROM giis_block a070 
                         WHERE a070.block_id = rec.block_id)
            LOOP
                rec.province_cd := C1.province_cd;
                rec.city := C1.city;
                rec.nb_district_no := C1.district_no;
                rec.nb_block_no := C1.block_no;
                rec.district_desc := C1.district_desc;
                rec.block_desc := C1.block_desc;
                rec.city_cd := C1.city_cd;
              --get value for province description
                FOR C2 IN (SELECT a080.province_desc
                               FROM giis_province a080
                            WHERE a080.province_cd = c1.province_cd)
                LOOP
                    rec.province_desc := c2.province_desc;
                END LOOP;			
            END LOOP;  
            
            --
            FOR C3 IN (SELECT a400.eq_desc
                         FROM giis_eqzone a400
                        WHERE a400.eq_zone = rec.eq_zone)
            LOOP
                rec.eq_zone_desc := c3.eq_desc;
            END LOOP;
            --
            FOR C4 IN (SELECT a1240.flood_zone_desc
                         FROM giis_flood_zone a1240
                        WHERE a1240.flood_zone = rec.flood_zone)
            LOOP
                rec.flood_zone_desc := c4.flood_zone_desc;
            END LOOP;
            --			
            FOR C5 IN (SELECT a1120.typhoon_zone_desc
                         FROM giis_typhoon_zone a1120
                        WHERE a1120.typhoon_zone = rec.typhoon_zone)
            LOOP
                rec.typhoon_zone_desc := c5.typhoon_zone_desc;
            END LOOP;
            --
            FOR C6 IN (SELECT a945.tariff_zone_desc
                         FROM giis_tariff_zone a945
                        WHERE a945.tariff_zone = rec.tariff_zone)
            LOOP
                rec.tariff_zone_desc := c6.tariff_zone_desc;
            END LOOP;
            --
            FOR C7 IN (SELECT a1569.tarf_desc
                         FROM giis_tariff a1569
                        WHERE a1569.tarf_cd = rec.tarf_cd)
            LOOP
                rec.tarf_desc := c7.tarf_desc;
            END LOOP;	
            --
            FOR risks IN (SELECT risk_desc
                      FROM giis_risks
                     WHERE block_id = rec.block_id
                       AND risk_cd  = rec.risk_cd)LOOP
                rec.risk_desc := risks.risk_desc;
                EXIT;
            END LOOP;                        
            
            PIPE ROW(rec);
        END LOOP;
    END get_fireitem_listing;
    
    
    FUNCTION get_tarf_hist_listing(
        p_policy_id     gipi_tarf_hist.POLICY_ID%type,
        p_item_no       gipi_tarf_hist.ITEM_NO%type,
        p_block_id      gipi_tarf_hist.BLOCK_ID%type
    ) RETURN tarf_hist_tab PIPELINED
    AS
        rec     tarf_hist_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_TARF_HIST
                   WHERE policy_id = p_policy_id
                     AND item_no   = p_item_no
                     AND block_id  = p_block_id)
        LOOP
            rec.policy_id       := i.policy_id;
            rec.block_id        := i.block_id;
            rec.item_no         := i.item_no;
            rec.old_tarf_cd     := i.old_tarf_cd;
            rec.new_tarf_cd     := i.new_tarf_cd;
            rec.user_id         := i.user_id;
            rec.last_update     := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
            rec.arc_ext_data    := i.arc_ext_data;
            
            PIPE ROW(rec);
        END LOOP;
    END get_tarf_hist_listing;

END GIPIS155_PKG;
/


