CREATE OR REPLACE PACKAGE BODY CPI.GIPIS211_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   10.02.2013
     ** Referenced By:  GIPIS211 - Listing of Motorcar Policies/PARs
     **/

    FUNCTION get_motorcar_pol_par_listing(
        p_global_par_id         VARCHAR2,
        p_global_line_cd        GIPI_PARLIST.line_cd%type,
        p_user_id               VARCHAR2
    ) RETURN mc_pol_par_tab PIPELINED
    AS
        TYPE cur_type IS REF CURSOR;
        
        rec         mc_pol_par_type;
        custom      cur_type;
        v_query     varchar2(32767);
    BEGIN
        v_query := 'SELECT a.par_id, a.line_cd, a.iss_cd, a.par_yy, a.par_seq_no, a.quote_seq_no, a.par_status,  
                           a.assd_no, b.assd_name, c.incept_date, c.expiry_date, a.underwriter
                      FROM GIPI_PARLIST a, GIIS_ASSURED b, GIPI_WPOLBAS c ';
        
        IF p_global_par_id IS NOT NULL AND p_global_line_cd IS NOT NULL THEN
            v_query := v_query || ' WHERE  a.par_id = c.par_id 
                                           AND a.assd_no = b.assd_no 
                                           AND UPPER(a.line_cd) ='''|| UPPER(p_global_line_cd) 
                                           ||''' AND TO_CHAR(A.PAR_ID) = ''' ||  p_global_par_id || ''' 
                                    ORDER BY a.par_id';
        ELSE
            v_query := v_query ||  ' WHERE a.par_id = c.par_id
                                           AND a.assd_no = b.assd_no
                                           AND a.line_cd = ''MC''
                                           /*Added by Joanne, 06052012 For user access/security */
                                           AND check_user_per_line2(a.line_cd,a.iss_cd, ''GIPIS211'', ''' || p_user_id || ''') = 1
                                           AND check_user_per_iss_cd2(a.line_cd,a.iss_cd, ''GIPIS211'', ''' || p_user_id || ''') = 1 
                                     ORDER BY a.par_id';            
        END IF;
        
                                 
        OPEN custom FOR v_query;
        
        LOOP
            FETCH custom
             INTO rec.par_id, rec.line_cd, rec.iss_cd, rec.par_yy, rec.par_seq_no, rec.quote_seq_no, rec.par_status,  
                  rec.assd_no, rec.assd_name, rec.incept_date, rec.expiry_date, rec.underwriter;
            
            rec.par_number := rec.line_cd || '-' || rec.iss_cd || '-' || LTRIM(TO_CHAR(rec.par_yy,'09')) 
							   || '-' || LTRIM(TO_CHAR(rec.par_seq_no,'0999999')) || '-' || LTRIM(TO_CHAR(rec.quote_seq_no,'09'));
                                          
            rec.nbt_par_no := rec.line_cd || '-' || rec.iss_cd || '-' || LTRIM(TO_CHAR(rec.par_yy,'09')) 
							   || '-' || LTRIM(TO_CHAR(rec.par_seq_no,'0999999'));
        
            EXIT WHEN custom%NOTFOUND;
            
            PIPE ROW(rec);
        END LOOP;
                        
    END get_motorcar_pol_par_listing;
    
    
    FUNCTION get_motorcar_vehicle_listing(
        p_par_id        GIPI_WVEHICLE.PAR_ID%type,
        p_par_status    GIPI_PARLIST.par_status%type
    ) RETURN vehicle_tab PIPELINED
    AS
        rec     vehicle_type;
    BEGIN
        FOR i IN (SELECT par_id, item_no, plate_no, serial_no, motor_no 
                    FROM gipi_wvehicle
                   WHERE par_id = p_par_id)
        LOOP
            rec.par_id      := i.par_id;
            rec.item_no     := i.item_no;
            rec.plate_no    := i.plate_no;
            rec.serial_no   := i.serial_no;
            rec.motor_no    := i.motor_no;
            
            FOR x in (SELECT a.item_no, a.item_title
								FROM gipi_witem a
						 	 WHERE a.par_id = i.par_id
						 	 	 AND a.item_no = i.item_no) 
            LOOP
			    rec.item_desc := x.item_title;
		    END LOOP;
        
            BEGIN
                SELECT line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
                  INTO rec.nbt_line_cd, rec.nbt_iss_cd, rec.nbt_par_yy, rec.nbt_par_seq_no, rec.nbt_quote_seq_no
                  FROM gipi_parlist
                WHERE par_id = i.par_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.nbt_line_cd         := null;
                    rec.nbt_iss_cd          := null;
                    rec.nbt_par_yy          := null;
                    rec.nbt_par_seq_no      := null;
                    rec.nbt_quote_seq_no    := null;
            END;
            
            IF p_par_status = 10 THEN
                BEGIN
                    SELECT policy_id
                      INTO rec.nbt_policy_id
                      FROM gipi_polbasic
                     WHERE par_id = i.par_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        rec.nbt_policy_id   := null;
                END;  
            END IF;
            
            PIPE ROW(rec);
        END LOOP;
        
    END get_motorcar_vehicle_listing;
    
    
    FUNCTION get_motorcar_vehicle_items(
        p_nbt_line_cd       GIPI_PARLIST.line_cd%type,
        p_nbt_plate_no      GIPI_WVEHICLE.PLATE_NO%type,
        p_nbt_serial_no     GIPI_WVEHICLE.SERIAL_NO%type,
        p_nbt_motor_no      GIPI_WVEHICLE.MOTOR_NO%type
    ) RETURN vehicle_items_tab PIPELINED
    AS
        rec     vehicle_items_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM  (  SELECT NULL par_id, b.policy_id, b.line_cd, NULL par_no, 
                                    b.line_cd || '-' || b.subline_cd || '-' || b.iss_cd || '-' || LTRIM(TO_CHAR(b.issue_yy,'09')) 
                                        || '-' || LTRIM(TO_CHAR(b.pol_seq_no,'0999999')) || '-' || LTRIM(TO_CHAR(b.renew_no,'09')) 
                                        || DECODE(NVL(b.endt_seq_no,0),0,'','/' || b.endt_iss_cd || '-' || LTRIM(TO_CHAR(b.endt_yy,'09')) 
                                        || '-' || LTRIM(b.endt_seq_no,'9999999')) Policy_no, 
                                    c.assd_name, a.plate_no, a.serial_no, a.motor_no, b.incept_date, b.expiry_date, 
                                    NVL(d.tsi_amt,0) tsi, NVL(d.prem_amt,0) prem 
                               FROM gipi_vehicle a, 
                                    gipi_polbasic b, 
                                    giis_assured c, 
                                    gipi_item d 
                              WHERE a.policy_id = b.policy_id 
                                AND b.policy_id = d.policy_id 
                                AND a.policy_id = d.policy_id 
                                AND a.item_no = d.item_no 
                                AND b.assd_no = c.assd_no 
                              UNION ALL 
                             SELECT a.par_id, NULL policy_id, b.line_cd, 
                                    b.line_cd || '-' || b.iss_cd || '-' || LTRIM(TO_CHAR(b.par_yy,'09')) || '-' || LTRIM(TO_CHAR(b.par_seq_no,'0999999')) 
                                        || '-' || LTRIM(TO_CHAR(b.quote_seq_no,'09')) par_no, 
                                    NULL policy_no, c.assd_name, a.plate_no, a.serial_no, a.motor_no, NULL incept_date, NULL expiry_date, 
                                    NULL tsi, NULL prem 
                               FROM gipi_wvehicle a, 
                                    gipi_parlist b, 
                                    giis_assured c 
                              WHERE a.par_id = b.par_id 
                                AND b.assd_no = c.assd_no)
                   WHERE line_cd = p_nbt_line_cd
                     AND (plate_no = p_nbt_plate_no
                          OR serial_no = p_nbt_serial_no
                          OR motor_no = p_nbt_motor_no))
        LOOP
            rec.par_id      := i.par_id;
            rec.par_no      := i.par_no;
            rec.line_cd     := i.line_cd;
            rec.policy_id   := i.policy_id;
            rec.policy_no   := i.policy_no;
            rec.assd_name   := i.assd_name;
            rec.plate_no    := i.plate_no;
            rec.serial_no   := i.serial_no;
            rec.motor_no    := i.motor_no;
            rec.incept_date := i.incept_date;
            rec.expiry_date := i.expiry_date;
            rec.tsi         := i.tsi;
            rec.prem        := i.prem;
            
            rec.prem_collns := null;
            rec.claims_pd   := null;
            
            FOR y in (SELECT NVL(SUM(premium_amt),0) prem, NVL(SUM(losses_paid),0) losses
							FROM gipi_polbasic a, gipi_item c, giac_direct_prem_collns d, 
									 gicl_clm_res_hist e, gipi_invoice f, gicl_claims g
						 WHERE a.policy_id = f.policy_id
							 AND a.policy_id = c.policy_id
						 	 AND f.prem_seq_no = d.b140_prem_seq_no
							 AND f.iss_cd = d.b140_iss_cd
						 	 AND a.line_cd = g.line_cd
							 AND a.subline_cd = g.subline_cd
							 AND a.iss_cd = g.iss_cd
							 AND a.issue_yy = g.issue_yy
							 AND a.pol_seq_no = g.pol_seq_no
							 AND a.renew_no = g.renew_no
						 	 AND g.claim_id = e.claim_id
							 AND c.item_no = e.item_no
							 AND a.policy_id = i.policy_id) 
            LOOP
                IF i.policy_id IS NOT NULL THEN
                    rec.prem_collns := y.prem;
                    rec.claims_pd   := y.losses;
                END IF;					
            END LOOP;	       
            
            PIPE ROW(rec); 
        
        END LOOP;
        
    END get_motorcar_vehicle_items;

END GIPIS211_PKG;
/


