CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Item_Dtls AS

  FUNCTION get_gipi_quote_mc (p_quote_id      GIPI_QUOTE.quote_id%TYPE,
                              p_item_no       GIPI_QUOTE_ITEM.item_no%TYPE)
    RETURN gipi_quote_mc_tab PIPELINED  IS
	
	v_gipi_quote_mc      gipi_quote_mc_type;
    v_default_tow        GIPI_QUOTE_ITEM_MC.towing%TYPE;
      
    
  BEGIN  
            
    FOR i IN (
      SELECT A.quote_id,                                    A.item_no,               A.plate_no,              A.motor_no,  
             A.serial_no,                                   A.subline_type_cd,       A.mot_type,              A.car_company_cd,
			 DECODE (A.coc_yy, '', (SELECT SUBSTR(TO_CHAR(quotation_yy), 3, 2)
                                      FROM gipi_quote
                                     WHERE quote_id = p_quote_id),
                                0, (SELECT SUBSTR(TO_CHAR(quotation_yy), 3, 2)
                                      FROM gipi_quote
                                     WHERE quote_id = p_quote_id),
                         A.coc_yy) coc_yy,                                     
             DECODE (A.subline_cd, 'LTO', 'LTO', 'NLTO') coc_type,  
			 (NVL(SUM(G.deductible_amt) OVER (PARTITION BY A.item_no),0)) + NVL(A.towing,0) repair_lim,   
			 A.color,                                       A.model_year,            A.make,   			      A.est_value,   
			 DECODE (A.towing,0, (SELECT param_value_n
                                    FROM giis_parameters
                                   WHERE param_name LIKE '%TOWING %'    -- added space to retrieve single towing limit
                                     AND param_name LIKE DECODE(A.subline_cd, NULL, '', '%' || A.subline_cd|| '%' )),
                             '', (SELECT param_value_n
                                    FROM giis_parameters
                                   WHERE param_name LIKE '%TOWING %'    -- added space to retrieve single towing limit
                                     AND param_name LIKE  DECODE(A.subline_cd, NULL, '', '%' || A.subline_cd|| '%' )),
                              A.towing) towing,
             A.coc_seq_no,                                  A.coc_serial_no,         A.coc_atcn,              A.assignee,
             A.no_of_pass, 			                        A.tariff_zone, 		     A.coc_issue_date,        A.mv_file_no,            
             A.acquired_from, 	                            A.ctv_tag,               A.type_of_body_cd,       A.unladen_wt,            
             A.make_cd,        	                            A.series_cd,             A.basic_color_cd,        A.color_cd,              
             A.origin,                                      A.destination,           A.user_id,               A.last_update, 		                        
             A.subline_cd,                                  b.subline_type_desc,     c.car_company,           d.basic_color, 
             E.type_of_body,                                f.engine_series,                               
             NVL((SUM(G.deductible_amt) OVER (PARTITION BY A.item_no)),0) deductible_amt                    
        FROM GIPI_QUOTE_ITEM_MC A,
             GIIS_MC_SUBLINE_TYPE b,
      	     GIIS_MC_CAR_COMPANY c,
      	     GIIS_MC_COLOR d,
      	     GIIS_TYPE_OF_BODY E,
      	     GIIS_MC_ENG_SERIES f,
			 GIPI_QUOTE_DEDUCTIBLES G  
       WHERE A.quote_id          = p_quote_id
	     AND A.item_no           = NVL(p_item_no, A.item_no)
	     AND A.subline_cd        = b.subline_cd(+)
         AND A.subline_type_cd   = b.subline_type_cd(+)
         AND A.car_company_cd    = c.car_company_cd(+)
         AND A.basic_color_cd    = d.basic_color_cd(+)
         AND A.color_cd          = d.color_cd(+)
         AND A.type_of_body_cd   = E.type_of_body_cd(+)
         AND A.make_cd           = f.make_cd(+) 
         AND A.series_cd         = f.series_cd(+)
         AND A.car_company_cd    = f.car_company_cd(+)
		 AND A.quote_id          = G.quote_id(+)
		 AND A.item_no           = G.item_no(+))
    
    
    LOOP
	  v_gipi_quote_mc.quote_id 	  		:= i.quote_id;                
 	  v_gipi_quote_mc.item_no           := i.item_no;     
	  v_gipi_quote_mc.plate_no          := i.plate_no;     
	  v_gipi_quote_mc.motor_no          := i.motor_no;     
      v_gipi_quote_mc.serial_no         := i.serial_no;     
      v_gipi_quote_mc.subline_type_cd   := i.subline_type_cd;     
      v_gipi_quote_mc.mot_type          := NVL(i.mot_type,0);--i.mot_type;     
      v_gipi_quote_mc.car_company_cd    := i.car_company_cd;     
      v_gipi_quote_mc.coc_yy            := TO_NUMBER(i.coc_yy);     
      v_gipi_quote_mc.coc_seq_no        := i.coc_seq_no;     
      v_gipi_quote_mc.coc_serial_no     := i.coc_serial_no;     
      v_gipi_quote_mc.coc_type          := i.coc_type;     
      v_gipi_quote_mc.repair_lim        := i.repair_lim;     
      v_gipi_quote_mc.color             := i.color;     
      v_gipi_quote_mc.model_year        := i.model_year;     
      v_gipi_quote_mc.make              := i.make;     
      v_gipi_quote_mc.est_value         := i.est_value;     
      v_gipi_quote_mc.towing            := i.towing;   
      v_gipi_quote_mc.assignee          := i.assignee;     
      v_gipi_quote_mc.no_of_pass        := i.no_of_pass;     
      v_gipi_quote_mc.tariff_zone       := i.tariff_zone;     
      v_gipi_quote_mc.coc_issue_date    := i.coc_issue_date;     
      v_gipi_quote_mc.mv_file_no        := i.mv_file_no;     
      v_gipi_quote_mc.acquired_from     := i.acquired_from;     
      v_gipi_quote_mc.ctv_tag           := i.ctv_tag;     
      v_gipi_quote_mc.type_of_body_cd   := i.type_of_body_cd;     
      v_gipi_quote_mc.unladen_wt        := i.unladen_wt;     
      v_gipi_quote_mc.make_cd           := i.make_cd;     
      v_gipi_quote_mc.series_cd         := i.series_cd;     
      v_gipi_quote_mc.basic_color_cd    := i.basic_color_cd;     
      v_gipi_quote_mc.color_cd          := i.color_cd;     
      v_gipi_quote_mc.origin            := i.origin;     
      v_gipi_quote_mc.destination       := i.destination;     
      v_gipi_quote_mc.coc_atcn          := i.coc_atcn;     
      v_gipi_quote_mc.user_id           := i.user_id;     
      v_gipi_quote_mc.last_update       := i.last_update;     
      v_gipi_quote_mc.subline_cd        := i.subline_cd;     
	  v_gipi_quote_mc.subline_type_desc := i.subline_type_desc;
	  v_gipi_quote_mc.car_company		:= i.car_company;
	  v_gipi_quote_mc.basic_color		:= i.basic_color;
	  v_gipi_quote_mc.type_of_body		:= i.type_of_body;
	  v_gipi_quote_mc.engine_series		:= i.engine_series;
  	  v_gipi_quote_mc.deductible_amt	:= i.deductible_amt;   
      
      PIPE ROW (v_gipi_quote_mc);
    END LOOP;
	RETURN;  
 END get_gipi_quote_mc;
 
 
 FUNCTION get_all_gipi_quote_mc (p_quote_id      GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_mc_tab PIPELINED  IS
	
	v_gipi_quote_mc      gipi_quote_mc_type;
    
  BEGIN  
    FOR i IN (
      SELECT A.quote_id,                                    A.item_no,               A.plate_no,              A.motor_no,  
             A.serial_no,                                   A.subline_type_cd,       A.mot_type,              A.car_company_cd,
			 A.coc_yy,                                      A.coc_seq_no,            A.coc_serial_no,         A.coc_type,  
			 (NVL(SUM(G.deductible_amt) OVER (PARTITION BY A.item_no),0)) + NVL(A.towing,0) repair_lim,   
			 A.color,                                       A.model_year,            A.make,   			      A.est_value,   
			 A.towing,                                      A.assignee,              A.no_of_pass, 			  A.tariff_zone,
			 A.coc_issue_date,                              A.mv_file_no,            A.acquired_from, 	      A.ctv_tag,   
			 A.type_of_body_cd,                             A.unladen_wt,            A.make_cd,        	      A.series_cd,
			 A.basic_color_cd,                              A.color_cd,              A.origin,                A.destination, 
			 A.coc_atcn,                                    A.user_id,               A.last_update, 		  A.subline_cd,   
			 b.subline_type_desc,                           c.car_company,           d.basic_color,  		  E.type_of_body,  
			 f.engine_series,                               NVL((SUM(G.deductible_amt) OVER (PARTITION BY A.item_no)),0) deductible_amt                    
        FROM GIPI_QUOTE_ITEM_MC A,
             GIIS_MC_SUBLINE_TYPE b,
      	     GIIS_MC_CAR_COMPANY c,
      	     GIIS_MC_COLOR d,
      	     GIIS_TYPE_OF_BODY E,
      	     GIIS_MC_ENG_SERIES f,
			 GIPI_QUOTE_DEDUCTIBLES G  
       WHERE A.quote_id          = p_quote_id
	     AND A.subline_cd        = b.subline_cd(+)
         AND A.subline_type_cd   = b.subline_type_cd(+)
         AND A.car_company_cd    = c.car_company_cd(+)
         AND A.basic_color_cd    = d.basic_color_cd(+)
         AND A.color_cd          = d.color_cd(+)
         AND A.type_of_body_cd   = E.type_of_body_cd(+)
         AND A.make_cd           = f.make_cd(+) 
         AND A.series_cd         = f.series_cd(+)
         AND A.car_company_cd    = f.car_company_cd(+)
		 AND A.quote_id          = G.quote_id(+)
		 AND A.item_no           = G.item_no(+))
    LOOP
	  v_gipi_quote_mc.quote_id 	  		:= i.quote_id;                
 	  v_gipi_quote_mc.item_no           := i.item_no;     
	  v_gipi_quote_mc.plate_no          := i.plate_no;     
	  v_gipi_quote_mc.motor_no          := i.motor_no;     
      v_gipi_quote_mc.serial_no         := i.serial_no;     
      v_gipi_quote_mc.subline_type_cd   := i.subline_type_cd;     
      v_gipi_quote_mc.mot_type          := NVL(i.mot_type,0);--i.mot_type;     
      v_gipi_quote_mc.car_company_cd    := i.car_company_cd;     
      v_gipi_quote_mc.coc_yy            := i.coc_yy;     
      v_gipi_quote_mc.coc_seq_no        := i.coc_seq_no;     
      v_gipi_quote_mc.coc_serial_no     := i.coc_serial_no;     
      v_gipi_quote_mc.coc_type          := i.coc_type;     
      v_gipi_quote_mc.repair_lim        := i.repair_lim;     
      v_gipi_quote_mc.color             := i.color;     
      v_gipi_quote_mc.model_year        := i.model_year;     
      v_gipi_quote_mc.make              := i.make;     
      v_gipi_quote_mc.est_value         := i.est_value;     
      v_gipi_quote_mc.towing            := i.towing;     
      v_gipi_quote_mc.assignee          := i.assignee;     
      v_gipi_quote_mc.no_of_pass        := i.no_of_pass;     
      v_gipi_quote_mc.tariff_zone       := i.tariff_zone;     
      v_gipi_quote_mc.coc_issue_date    := i.coc_issue_date;     
      v_gipi_quote_mc.mv_file_no        := i.mv_file_no;     
      v_gipi_quote_mc.acquired_from     := i.acquired_from;     
      v_gipi_quote_mc.ctv_tag           := i.ctv_tag;     
      v_gipi_quote_mc.type_of_body_cd   := i.type_of_body_cd;     
      v_gipi_quote_mc.unladen_wt        := i.unladen_wt;     
      v_gipi_quote_mc.make_cd           := i.make_cd;     
      v_gipi_quote_mc.series_cd         := i.series_cd;     
      v_gipi_quote_mc.basic_color_cd    := i.basic_color_cd;     
      v_gipi_quote_mc.color_cd          := i.color_cd;     
      v_gipi_quote_mc.origin            := i.origin;     
      v_gipi_quote_mc.destination       := i.destination;     
      v_gipi_quote_mc.coc_atcn          := i.coc_atcn;     
      v_gipi_quote_mc.user_id           := i.user_id;     
      v_gipi_quote_mc.last_update       := i.last_update;     
      v_gipi_quote_mc.subline_cd        := i.subline_cd;     
	  v_gipi_quote_mc.subline_type_desc := i.subline_type_desc;
	  v_gipi_quote_mc.car_company		:= i.car_company;
	  v_gipi_quote_mc.basic_color		:= i.basic_color;
	  v_gipi_quote_mc.type_of_body		:= i.type_of_body;
	  v_gipi_quote_mc.engine_series		:= i.engine_series;
  	  v_gipi_quote_mc.deductible_amt	:= i.deductible_amt;                 
      PIPE ROW (v_gipi_quote_mc);
    END LOOP;
	RETURN;  
  END get_all_gipi_quote_mc;
  
  
  PROCEDURE set_gipi_quote_mc (p_quote_item_mc            GIPI_QUOTE_ITEM_MC%ROWTYPE)

  IS
    v_subline_cd         GIPI_QUOTE.subline_cd%TYPE;
    
  BEGIN

    FOR sub IN (
      SELECT subline_cd
        FROM gipi_quote
       WHERE quote_id = p_quote_item_mc.quote_id)
    LOOP      
      v_subline_cd := sub.subline_cd;
      EXIT;
    END LOOP;        
    
	   
	MERGE INTO GIPI_QUOTE_ITEM_MC
     USING dual ON (quote_id = p_quote_item_mc.quote_id
	                AND item_no = p_quote_item_mc.item_no)
     WHEN NOT MATCHED THEN
         INSERT ( quote_id,          item_no,           plate_no,              
		 		  motor_no,          serial_no,         subline_type_cd,   
				  mot_type,          car_company_cd,    coc_yy,
				  coc_seq_no,        coc_serial_no,     coc_type,
				  repair_lim,        color,             model_year,            
				  make,              est_value,         towing,    
				  assignee,          no_of_pass,        tariff_zone,
				  coc_issue_date,    mv_file_no,        acquired_from,
				  ctv_tag,           type_of_body_cd,   unladen_wt,
				  make_cd,           series_cd,         basic_color_cd,         
             	  color_cd,          origin,            destination,
				  coc_atcn,          user_id,           last_update,
				  subline_cd)
		 VALUES ( p_quote_item_mc.quote_id,          p_quote_item_mc.item_no,           p_quote_item_mc.plate_no,              
		 		  p_quote_item_mc.motor_no,          p_quote_item_mc.serial_no,         p_quote_item_mc.subline_type_cd,   
				  p_quote_item_mc.mot_type,          p_quote_item_mc.car_company_cd,    p_quote_item_mc.coc_yy,
				  p_quote_item_mc.coc_seq_no,        p_quote_item_mc.coc_serial_no,     p_quote_item_mc.coc_type,
				  p_quote_item_mc.repair_lim,        p_quote_item_mc.color,             p_quote_item_mc.model_year,            
				  p_quote_item_mc.make,              p_quote_item_mc.est_value,         p_quote_item_mc.towing,    
				  p_quote_item_mc.assignee,          p_quote_item_mc.no_of_pass,        p_quote_item_mc.tariff_zone,
				  p_quote_item_mc.coc_issue_date,    p_quote_item_mc.mv_file_no,        p_quote_item_mc.acquired_from,
				  p_quote_item_mc.ctv_tag,           p_quote_item_mc.type_of_body_cd,   p_quote_item_mc.unladen_wt,
				  p_quote_item_mc.make_cd,           p_quote_item_mc.series_cd,         p_quote_item_mc.basic_color_cd,         
             	  p_quote_item_mc.color_cd,          p_quote_item_mc.origin,            p_quote_item_mc.destination,
				  p_quote_item_mc.coc_atcn,          p_quote_item_mc.user_id,           p_quote_item_mc.last_update,
				  v_subline_cd)
     WHEN MATCHED THEN
         UPDATE SET   plate_no          = p_quote_item_mc.plate_no,     
                      motor_no          = p_quote_item_mc.motor_no,     
                      serial_no         = p_quote_item_mc.serial_no,     
                      subline_type_cd   = p_quote_item_mc.subline_type_cd,     
                      mot_type          = p_quote_item_mc.mot_type,     
                      car_company_cd    = p_quote_item_mc.car_company_cd,     
                      coc_yy            = p_quote_item_mc.coc_yy,     
                      coc_seq_no        = p_quote_item_mc.coc_seq_no,     
                      coc_serial_no     = p_quote_item_mc.coc_serial_no,     
                      coc_type          = p_quote_item_mc.coc_type,     
                      repair_lim        = p_quote_item_mc.repair_lim,     
                      color             = p_quote_item_mc.color,     
                      model_year        = p_quote_item_mc.model_year,     
                      make              = p_quote_item_mc.make,     
                      est_value         = p_quote_item_mc.est_value,     
                      towing            = p_quote_item_mc.towing,     
                      assignee          = p_quote_item_mc.assignee,     
                      no_of_pass        = p_quote_item_mc.no_of_pass,     
                      tariff_zone       = p_quote_item_mc.tariff_zone,     
					  coc_issue_date    = p_quote_item_mc.coc_issue_date,     
                      mv_file_no        = p_quote_item_mc.mv_file_no,     
                      acquired_from     = p_quote_item_mc.acquired_from,     
                      ctv_tag           = p_quote_item_mc.ctv_tag,     
                      type_of_body_cd   = p_quote_item_mc.type_of_body_cd,     
                      unladen_wt        = p_quote_item_mc.unladen_wt,     
                      make_cd           = p_quote_item_mc.make_cd,  
                      series_cd         = p_quote_item_mc.series_cd,     
                      basic_color_cd    = p_quote_item_mc.basic_color_cd,     
                      color_cd          = p_quote_item_mc.color_cd,     
                      origin            = p_quote_item_mc.origin,   
                      destination       = p_quote_item_mc.destination,     
                      coc_atcn          = p_quote_item_mc.coc_atcn,  
                      user_id           = p_quote_item_mc.user_id,    
                      last_update       = p_quote_item_mc.last_update,     
                      subline_cd        = p_quote_item_mc.subline_cd;    
--*    COMMIT;    
  END set_gipi_quote_mc;
 
  
  PROCEDURE del_gipi_quote_mc (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_ITEM_MC
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_mc; 
  
  PROCEDURE del_all_addinfo_mc (p_quote_id    GIPI_QUOTE.quote_id%TYPE) IS
  
  BEGIN
  
    DELETE FROM GIPI_QUOTE_ITEM_MC
        WHERE quote_id = p_quote_id;
--*        COMMIT;
  END del_all_addinfo_mc;      
  
  FUNCTION get_all_serial_no_mc 
    RETURN serial_no_mc_tab PIPELINED IS
    
    v_serial_no serial_no_mc_type;
    
  BEGIN
    FOR i IN(
        SELECT DISTINCT serial_no
          FROM GIPI_QUOTE_ITEM_MC
          ORDER BY serial_no)
          
    LOOP
      v_serial_no.serial_no := i.serial_no;
      PIPE ROW(v_serial_no);
    END LOOP;  
    
  END get_all_serial_no_mc ;
  
  
  FUNCTION get_all_motor_no_mc
    RETURN motor_no_mc_tab PIPELINED  IS
	
	v_motor_no      motor_no_mc_type;
    
  BEGIN
   FOR i IN(
    SELECT DISTINCT motor_no
      FROM GIPI_QUOTE_ITEM_MC
      ORDER BY motor_no)
   LOOP
     v_motor_no.motor_no := i.motor_no;
     PIPE ROW(v_motor_no);
   END LOOP; 
   
  END get_all_motor_no_mc;  
  
  FUNCTION get_all_plate_no_mc
    RETURN plate_no_mc_tab PIPELINED  IS
	
	v_plate_no      plate_no_mc_type;
    
  BEGIN
   FOR i IN(
    SELECT DISTINCT plate_no
      FROM GIPI_QUOTE_ITEM_MC
      ORDER BY plate_no)
   LOOP
     v_plate_no.plate_no := i.plate_no;
     PIPE ROW(v_plate_no);
   END LOOP; 
   
  END get_all_plate_no_mc;  
  
  FUNCTION get_all_coc_no_mc
    RETURN coc_no_mc_tab PIPELINED IS
    
    v_coc_no    coc_no_mc_type;
    
  BEGIN
    FOR i IN(
     SELECT DISTINCT A.coc_serial_no, 
       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.quotation_yy||'-'||b.quotation_no||'-'||b.proposal_no quote_no
        FROM GIPI_QUOTE_ITEM_MC A, gipi_quote b
        WHERE b.line_cd = 'MC' 
        AND b.quote_id = A.quote_id 
        AND A.coc_serial_no IS NOT NULL
        ORDER BY COC_SERIAL_NO)
    LOOP
      v_coc_no.coc_serial_no := i.coc_serial_no;
      v_coc_no.quote_no      := i.quote_no;
      PIPE ROW(v_coc_no);
    END LOOP;
    
    /* old query. quote no was added with coc no
    SELECT DISTINCT coc_serial_no
        FROM GIPI_QUOTE_ITEM_MC
        ORDER BY COC_SERIAL_NO
    */
  END get_all_coc_no_mc;      
  
  FUNCTION get_gipi_quote_fi (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_fi_tab PIPELINED IS
	
	v_gipi_quote_fi      gipi_quote_fi_type;
    
  BEGIN  
    FOR i IN (
		SELECT A.quote_id,         A.item_no,           A.assignee, 	        A.fr_item_type,
			   l.fr_itm_tp_ds,	   A.block_id,			d.province_desc,  d.province_cd,   	A.district_no,  	    
			   A.block_no,		   c.block_desc,		A.risk_cd, 				b.risk_desc,          		   		    	 
			   A.eq_zone,		   f.eq_desc,  		    A.typhoon_zone,			h.typhoon_zone_desc,
			   A.flood_zone, 	   i.flood_zone_desc,  	A.tarf_cd,				A.tariff_zone,
			   E.tariff_zone_desc, A.construction_cd,	j.construction_desc, 	A.construction_remarks, 
			   A.user_id,		   A.last_update, 	   	A.loc_risk1,    	    A.loc_risk2,
			   A.loc_risk3,		   A.front,			   	A.RIGHT, 	   	    	A.LEFT,		  		    
			   A.rear,			   A.occupancy_cd,		K.occupancy_desc,   	A.occupancy_remarks,
			   c.city_cd,		   c.city,              A.date_from,            A.date_to
		  FROM GIPI_QUOTE_FI_ITEM A,     
		  	   GIIS_RISKS b,          
			   GIIS_BLOCK c,        
			   GIIS_PROVINCE d, 
		  	   GIIS_TARIFF_ZONE E,       
			   GIIS_EQZONE f,         
			   GIIS_TYPHOON_ZONE h, 
			   GIIS_FLOOD_ZONE i,
			   GIIS_FIRE_CONSTRUCTION j, 
			   GIIS_FIRE_OCCUPANCY K, 
			   GIIS_FI_ITEM_TYPE l  
		 WHERE A.quote_id        = p_quote_id
		   AND A.item_no   	  	 = p_item_no
		   AND A.block_id  	  	 = b.block_id (+)
		   AND A.risk_cd   	  	 = b.risk_cd (+)
		   AND A.block_id  	  	 = c.block_id (+)
		   AND c.province_cd  	 = d.province_cd (+)
		   AND A.block_no 	  	 = c.block_no (+)
		   AND A.eq_zone 	  	 = f.eq_zone (+)
		   AND A.typhoon_zone 	 = h.typhoon_zone (+)
		   AND A.flood_zone	  	 = i.flood_zone (+)
		   AND A.tariff_zone     = E.tariff_zone (+)
		   AND A.construction_cd = j.construction_cd (+)
		   AND A.occupancy_cd	 = K.occupancy_cd (+)
		   AND A.fr_item_type	 = l.fr_item_type (+))
    LOOP
		v_gipi_quote_fi.quote_id              := i.quote_id;
	 	v_gipi_quote_fi.item_no           	  := i.item_no;
	 	v_gipi_quote_fi.assignee              := i.assignee;
	 	v_gipi_quote_fi.fr_item_type		  := i.fr_item_type;		
	 	v_gipi_quote_fi.fr_itm_tp_ds		  := i.fr_itm_tp_ds;
	 	v_gipi_quote_fi.block_id			  := NVL(i.block_id,0);-- rencela: NVL prevents nullpointer exception in java		 
	 	v_gipi_quote_fi.province_desc		  := i.province_desc;
        v_gipi_quote_fi.province_cd		  := i.province_cd;
	 	v_gipi_quote_fi.district_no		  	  := i.district_no;
	 	v_gipi_quote_fi.block_no			  := i.block_no;
	 	v_gipi_quote_fi.block_desc			  := i.block_desc;
	 	v_gipi_quote_fi.risk_cd				  := i.risk_cd;
	 	v_gipi_quote_fi.risk_desc			  := i.risk_desc;              
	 	v_gipi_quote_fi.eq_zone				  := i.eq_zone;
	 	v_gipi_quote_fi.eq_desc			  	  := i.eq_desc;         
	 	v_gipi_quote_fi.typhoon_zone		  := i.typhoon_zone;
	 	v_gipi_quote_fi.typhoon_zone_desc	  := i.typhoon_zone_desc;
	 	v_gipi_quote_fi.flood_zone			  := i.flood_zone;
	 	v_gipi_quote_fi.flood_zone_desc	  	  := i.flood_zone_desc;
	 	v_gipi_quote_fi.tarf_cd			  	  := i.tarf_cd;
	 	v_gipi_quote_fi.tariff_zone			  := i.tariff_zone;
	 	v_gipi_quote_fi.tariff_zone_desc	  := i.tariff_zone_desc;
	 	v_gipi_quote_fi.construction_cd       := i.construction_cd;
	 	v_gipi_quote_fi.construction_desc     := i.construction_desc;
	 	v_gipi_quote_fi.construction_remarks  := i.construction_remarks;
	 	v_gipi_quote_fi.user_id			  	  := i.user_id;
	 	v_gipi_quote_fi.last_update		  	  := i.last_update;
	 	v_gipi_quote_fi.front				  := i.front;
	 	v_gipi_quote_fi.RIGHT				  := i.RIGHT;
	 	v_gipi_quote_fi.LEFT			      := i.LEFT;             
	 	v_gipi_quote_fi.rear			      := i.rear;
	 	v_gipi_quote_fi.loc_risk1			  := i.loc_risk1;
	 	v_gipi_quote_fi.loc_risk2			  := i.loc_risk2;
	 	v_gipi_quote_fi.loc_risk3			  := i.loc_risk3;       
	 	v_gipi_quote_fi.occupancy_cd		  := i.occupancy_cd;
	 	v_gipi_quote_fi.occupancy_desc		  := i.occupancy_desc;	       
	 	v_gipi_quote_fi.occupancy_remarks	  := i.occupancy_remarks;
    	v_gipi_quote_fi.city_cd				  := i.city_cd;
		v_gipi_quote_fi.city				  := i.city;
        v_gipi_quote_fi.date_from			  := i.date_from;
        v_gipi_quote_fi.date_to				  := i.date_to;
	  PIPE ROW (v_gipi_quote_fi);
    END LOOP;
	RETURN;  
  END get_gipi_quote_fi;


  PROCEDURE set_gipi_quote_fi (
     v_quote_id                IN  GIPI_QUOTE_FI_ITEM.quote_id%TYPE,
	 v_item_no           	   IN  GIPI_QUOTE_FI_ITEM.item_no%TYPE,
	 v_assignee                IN  GIPI_QUOTE_FI_ITEM.assignee%TYPE,
	 v_fr_item_type			   IN  GIPI_QUOTE_FI_ITEM.fr_item_type%TYPE,
	 v_block_id				   IN  GIPI_QUOTE_FI_ITEM.block_id%TYPE,
	 v_district_no		  	   IN  GIPI_QUOTE_FI_ITEM.district_no%TYPE,
	 v_block_no		  	 	   IN  GIPI_QUOTE_FI_ITEM.block_no%TYPE,	 
	 v_risk_cd				   IN  GIPI_QUOTE_FI_ITEM.risk_cd%TYPE,           
	 v_eq_zone				   IN  GIPI_QUOTE_FI_ITEM.eq_zone%TYPE,
	 v_typhoon_zone		  	   IN  GIPI_QUOTE_FI_ITEM.typhoon_zone%TYPE,	         
	 v_flood_zone		  	   IN  GIPI_QUOTE_FI_ITEM.flood_zone%TYPE,	 
	 v_tarf_cd			  	   IN  GIPI_QUOTE_FI_ITEM.tarf_cd%TYPE,
	 v_tariff_zone		  	   IN  GIPI_QUOTE_FI_ITEM.tariff_zone%TYPE,
	 v_construction_cd	  	   IN  GIPI_QUOTE_FI_ITEM.construction_cd%TYPE,
	 v_construction_remarks    IN  GIPI_QUOTE_FI_ITEM.construction_remarks%TYPE,
	 v_user_id			  	   IN  GIPI_QUOTE_FI_ITEM.user_id%TYPE,
	 v_last_update		  	   IN  GIPI_QUOTE_FI_ITEM.last_update%TYPE,
	 v_front				   IN  GIPI_QUOTE_FI_ITEM.front%TYPE,
	 v_right				   IN  GIPI_QUOTE_FI_ITEM.RIGHT%TYPE,
	 v_left			      	   IN  GIPI_QUOTE_FI_ITEM.LEFT%TYPE,             
	 v_rear			      	   IN  GIPI_QUOTE_FI_ITEM.rear%TYPE,
	 v_loc_risk1			   IN  GIPI_QUOTE_FI_ITEM.loc_risk1%TYPE,
	 v_loc_risk2			   IN  GIPI_QUOTE_FI_ITEM.loc_risk2%TYPE,
	 v_loc_risk3			   IN  GIPI_QUOTE_FI_ITEM.loc_risk3%TYPE,       
	 v_occupancy_cd		  	   IN  GIPI_QUOTE_FI_ITEM.occupancy_cd%TYPE,       
	 v_occupancy_remarks	   IN  GIPI_QUOTE_FI_ITEM.occupancy_remarks%TYPE,
     v_date_from        	   IN  GIPI_QUOTE_FI_ITEM.date_from%TYPE,
     v_date_to          	   IN  GIPI_QUOTE_FI_ITEM.date_to%TYPE,
     v_latitude                IN  GIPI_QUOTE_FI_ITEM.latitude%TYPE, --Added by MarkS 02/09/2017 SR5918
     v_longitude               IN  GIPI_QUOTE_FI_ITEM.longitude%TYPE --Added by MarkS 02/09/2017 SR5918
     )
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_FI_ITEM
     USING dual ON (quote_id    = v_quote_id
	                AND item_no = v_item_no)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,      item_no, 		    assignee,     			fr_item_type,
		 		  block_id,      district_no,  	    block_no,				risk_cd,          		   		    	 
			   	  eq_zone,  	 typhoon_zone,      flood_zone,  			tarf_cd, 
			   	  tariff_zone,   construction_cd,   construction_remarks,   loc_risk1,
				  loc_risk2,   	 loc_risk3,  	    front,			    	RIGHT,
				  LEFT,		  	 rear,    	  	    occupancy_cd,     		occupancy_remarks,
                  date_from,     date_to,           latitude,               longitude --Added by MarkS 02/09/2017 SR5918
                   )
		 VALUES ( v_quote_id,    v_item_no, 		v_assignee, 	        v_fr_item_type,
		 		  v_block_id,    v_district_no,   	v_block_no,			 	v_risk_cd,          		   		    	 
			   	  v_eq_zone,     v_typhoon_zone, 	v_flood_zone,  	 	 	v_tarf_cd, 
			   	  v_tariff_zone, v_construction_cd, v_construction_remarks, v_loc_risk1,
				  v_loc_risk2,   v_loc_risk3,    	v_front,			    v_right,
				  v_left,		 v_rear,    	  	v_occupancy_cd,     	v_occupancy_remarks,
                  v_date_from,   v_date_to,         v_latitude,              v_longitude --Added by MarkS 02/09/2017 SR5918
                  )
     WHEN MATCHED THEN
         UPDATE SET assignee              = v_assignee,
					fr_item_type		  = v_fr_item_type,	 
	 				block_id		  	  = v_block_id,
	 				district_no		  	  = v_district_no,
	 				block_no			  = v_block_no,
	 				risk_cd			  	  = v_risk_cd,              
	 				eq_zone			  	  = v_eq_zone,         
	 				typhoon_zone	  	  = v_typhoon_zone,
	 				flood_zone	  	  	  = v_flood_zone,
	 				tarf_cd			  	  = v_tarf_cd,
	 				tariff_zone	  		  = v_tariff_zone,
	 				construction_cd       = v_construction_cd,
	 				construction_remarks  = v_construction_remarks,
	 				front				  = v_front,
	 				RIGHT				  = v_right,
	 				LEFT			      = v_left,             
	 				rear			      = v_rear,
	 				loc_risk1			  = v_loc_risk1,
	 				loc_risk2			  = v_loc_risk2,
	 				loc_risk3			  = v_loc_risk3,       
	 				occupancy_cd		  = v_occupancy_cd,	       
	 				occupancy_remarks	  = v_occupancy_remarks,
                    date_from             = v_date_from,
                    date_to               = v_date_to,
                    latitude              = v_latitude, --Added by MarkS 02/09/2017 SR5918
                    longitude             = v_longitude;--Added by MarkS 02/09/2017 SR5918    
    --COMMIT;    
  END set_gipi_quote_fi;
  
  PROCEDURE del_gipi_quote_fi (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_FI_ITEM
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_fi;   

  PROCEDURE del_all_addinfo_fi (p_quote_id    GIPI_QUOTE.quote_id%TYPE) IS
  
  BEGIN
  
    DELETE FROM GIPI_QUOTE_FI_ITEM
        WHERE quote_id = p_quote_id;
--*        COMMIT;
  END del_all_addinfo_fi;

  FUNCTION get_gipi_quote_ac (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_ac_tab PIPELINED IS
	
	v_gipi_quote_ac      gipi_quote_ac_type;
    
  BEGIN  
    FOR i IN (
		SELECT A.quote_id,      A.item_no,      A.no_of_persons,  A.position_cd, 
			   b.position, 		A.destination,  A.monthly_salary, A.salary_grade,
			   A.date_of_birth, A.civil_status, A.Age, 			  A.weight, 
			   A.height, A.sex, A.user_id, 		A.last_update  							   
		  FROM GIPI_QUOTE_AC_ITEM A, 
		  	   GIIS_POSITION b
		 WHERE A.quote_id    = p_quote_id
		   AND A.item_no	 = p_item_no
		   AND A.position_cd = b.position_cd (+))
    LOOP
		v_gipi_quote_ac.quote_id          := i.quote_id;
		v_gipi_quote_ac.item_no           := i.item_no;
		v_gipi_quote_ac.position_cd		  := i.position_cd;
		v_gipi_quote_ac.position		  := i.position;			 
		v_gipi_quote_ac.destination		  := i.destination;
		v_gipi_quote_ac.monthly_salary	  := i.monthly_salary;
		v_gipi_quote_ac.salary_grade	  := i.salary_grade;
		v_gipi_quote_ac.date_of_birth	  := i.date_of_birth;	 
		v_gipi_quote_ac.civil_status	  := i.civil_status;       
		v_gipi_quote_ac.Age				  := i.Age;
		v_gipi_quote_ac.weight			  := i.weight;	         
		v_gipi_quote_ac.height			  := i.height;	 
		v_gipi_quote_ac.sex				  := i.sex;
		v_gipi_quote_ac.no_of_persons	  := i.no_of_persons;
		v_gipi_quote_ac.user_id			  := i.user_id;
		v_gipi_quote_ac.last_update		  := i.last_update;
	 PIPE ROW (v_gipi_quote_ac);
    END LOOP;
	RETURN;  
  END get_gipi_quote_ac;

  
  PROCEDURE set_gipi_quote_ac (
     v_quote_id              IN  GIPI_QUOTE_AC_ITEM.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_AC_ITEM.item_no%TYPE,
	 v_no_of_persons		 IN  GIPI_QUOTE_AC_ITEM.no_of_persons%TYPE,
	 v_position_cd		  	 IN  GIPI_QUOTE_AC_ITEM.position_cd%TYPE,	 
	 v_destination			 IN  GIPI_QUOTE_AC_ITEM.destination%TYPE,
	 v_monthly_salary		 IN  GIPI_QUOTE_AC_ITEM.monthly_salary%TYPE,
	 v_salary_grade		  	 IN  GIPI_QUOTE_AC_ITEM.salary_grade%TYPE,
	 v_date_of_birth	  	 IN  GIPI_QUOTE_AC_ITEM.date_of_birth%TYPE,	 
	 v_civil_status			 IN  GIPI_QUOTE_AC_ITEM.civil_status%TYPE,       
	 v_age					 IN  GIPI_QUOTE_AC_ITEM.Age%TYPE,
	 v_weight				 IN  GIPI_QUOTE_AC_ITEM.weight%TYPE,	         
	 v_height				 IN  GIPI_QUOTE_AC_ITEM.height%TYPE,	 
	 v_sex					 IN  GIPI_QUOTE_AC_ITEM.sex%TYPE)
	 
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_AC_ITEM
     USING dual ON (quote_id    = v_quote_id
	                AND item_no = v_item_no)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,        item_no,       	  no_of_persons,  	 position_cd, 
			   	  destination,     monthly_salary,    salary_grade,      date_of_birth, 
				  civil_status,    Age,				  weight,   	     height, 
				  sex)
		 VALUES ( v_quote_id,      v_item_no, 		  v_no_of_persons,   v_position_cd, 
			   	  v_destination,   v_monthly_salary,  v_salary_grade,    v_date_of_birth, 
				  v_civil_status,  v_age, 			  v_weight,   	     v_height, 
				  v_sex)
     WHEN MATCHED THEN
         UPDATE SET no_of_persons	  = v_no_of_persons,
		 			position_cd		  = v_position_cd,	 
					destination		  = v_destination,
					monthly_salary	  = v_monthly_salary,
					salary_grade	  = v_salary_grade,
					date_of_birth	  = v_date_of_birth,	 
					civil_status	  = v_civil_status,       
					Age				  = v_age,
					weight			  = v_weight,	         
					height			  = v_height,	 
					sex				  = v_sex;
					    
--*    COMMIT;    
  END set_gipi_quote_ac;
  
  PROCEDURE del_gipi_quote_ac (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_AC_ITEM
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_ac;     
  
  
  FUNCTION get_gipi_quote_mn (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_mn_tab PIPELINED IS
	
	v_gipi_quote_mn      gipi_quote_mn_type;
    
  BEGIN  
    FOR i IN (
		  SELECT A.quote_id,        A.item_no,              A.geog_cd,        b.geog_desc,	 
		  		 A.vessel_cd, 		c.vessel_name, 			A.cargo_class_cd, d.cargo_class_desc,
				 A.cargo_type, 		E.cargo_type_desc, 		A.pack_method, 	  A.bl_awb, 
				 A.tranship_origin, A.tranship_destination, A.voyage_no, 	  A.lc_no, 
				 A.etd, 			A.eta, 					A.print_tag, 	  f.rv_meaning print_tag_desc, 
				 A.origin,			A.destn, 				A.user_id, 		  A.last_update 
		    FROM GIPI_QUOTE_CARGO A, 
				 GIIS_GEOG_CLASS b,
				 GIIS_VESSEL c,
				 GIIS_CARGO_CLASS d,
				 GIIS_CARGO_TYPE E,
				 CG_REF_CODES f
		   WHERE A.quote_id       = p_quote_id
		     AND A.item_no   	  = p_item_no
			 AND A.geog_cd	 	  = b.geog_cd (+)
			 AND A.vessel_cd 	  = c.vessel_cd (+)
			 AND A.cargo_class_cd = d.cargo_class_cd (+)
			 AND A.cargo_type	  = E.cargo_type (+)
			 AND A.print_tag	  = f.rv_low_value (+)
			 AND f.rv_domain	  = 'GIPI_WCARGO.PRINT_TAG')
    LOOP
		v_gipi_quote_mn.quote_id                := i.quote_id;
		v_gipi_quote_mn.item_no           	  	:= i.item_no;
		v_gipi_quote_mn.geog_cd				 	:= i.geog_cd;
		v_gipi_quote_mn.geog_desc				:= i.geog_desc;	 
		v_gipi_quote_mn.vessel_cd				:= i.vessel_cd;
		v_gipi_quote_mn.vessel_name			 	:= i.vessel_name;	 
		v_gipi_quote_mn.cargo_class_cd		  	:= i.cargo_class_cd;
		v_gipi_quote_mn.cargo_class_desc	  	:= i.cargo_class_desc;	 
		v_gipi_quote_mn.cargo_type				:= i.cargo_type;
		v_gipi_quote_mn.cargo_type_desc			:= i.cargo_type_desc;	 
		v_gipi_quote_mn.pack_method	  	 	 	:= i.pack_method;	 
		v_gipi_quote_mn.bl_awb					:= i.bl_awb;       
		v_gipi_quote_mn.tranship_origin		 	:= i.tranship_origin;
		v_gipi_quote_mn.tranship_destination	:= i.tranship_destination;	         
		v_gipi_quote_mn.voyage_no				:= i.voyage_no;	 
		v_gipi_quote_mn.lc_no					:= i.lc_no;
		v_gipi_quote_mn.etd					 	:= i.etd;
		v_gipi_quote_mn.eta					 	:= i.eta;
		v_gipi_quote_mn.print_tag				:= i.print_tag;	 	 	 
		v_gipi_quote_mn.print_tag_desc			:= i.print_tag_desc; --- comments made by angelo
		v_gipi_quote_mn.origin					:= i.origin;
		v_gipi_quote_mn.destn					:= i.destn;	 
		v_gipi_quote_mn.user_id				 	:= i.user_id;
		v_gipi_quote_mn.last_update		  	 	:= i.last_update;
	 PIPE ROW (v_gipi_quote_mn);
    END LOOP;
	RETURN;  
  END get_gipi_quote_mn;

  
  PROCEDURE set_gipi_quote_mn (
  	 v_quote_id              IN  GIPI_QUOTE_CARGO.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_CARGO.item_no%TYPE,
	 v_geog_cd				 IN  GIPI_QUOTE_CARGO.geog_cd%TYPE,	 
	 v_vessel_cd			 IN  GIPI_QUOTE_CARGO.vessel_cd%TYPE,
	 v_cargo_class_cd		 IN  GIPI_QUOTE_CARGO.cargo_class_cd%TYPE,
	 v_cargo_type			 IN  GIPI_QUOTE_CARGO.cargo_type%TYPE,
	 v_pack_method	  	 	 IN  GIPI_QUOTE_CARGO.pack_method%TYPE,	 
	 v_bl_awb				 IN  GIPI_QUOTE_CARGO.bl_awb%TYPE,       
	 v_tranship_origin		 IN  GIPI_QUOTE_CARGO.tranship_origin%TYPE,
	 v_tranship_destination	 IN  GIPI_QUOTE_CARGO.tranship_destination%TYPE,	         
	 v_voyage_no			 IN  GIPI_QUOTE_CARGO.voyage_no%TYPE,	 
	 v_lc_no				 IN  GIPI_QUOTE_CARGO.lc_no%TYPE,
	 v_etd					 IN  GIPI_QUOTE_CARGO.etd%TYPE,
	 v_eta					 IN  GIPI_QUOTE_CARGO.eta%TYPE,
	 v_print_tag			 IN  GIPI_QUOTE_CARGO.print_tag%TYPE,	 	 	 
	 v_origin				 IN  GIPI_QUOTE_CARGO.origin%TYPE,
	 v_destn				 IN  GIPI_QUOTE_CARGO.destn%TYPE)	 
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_CARGO
     USING dual ON (quote_id    = v_quote_id
	                AND item_no = v_item_no)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,          item_no,                geog_cd,	    vessel_cd,
	 			  cargo_class_cd,	 cargo_type, 		 	 pack_method, 	bl_awb, 
				  tranship_origin, 	 tranship_destination, 	 voyage_no, 	lc_no, 
				  etd, 				 eta, 					 print_tag,	    origin,
				  destn )
		 VALUES ( v_quote_id,        v_item_no,              v_geog_cd, 	v_vessel_cd,
		 		  v_cargo_class_cd,  v_cargo_type, 	 		 v_pack_method, v_bl_awb,
				  v_tranship_origin, v_tranship_destination, v_voyage_no, 	v_lc_no,
				  v_etd, 			 v_eta, 				 v_print_tag, 	v_origin,
				  v_destn )
     WHEN MATCHED THEN
         UPDATE SET geog_cd				     = v_geog_cd,	 
					vessel_cd			 	 = v_vessel_cd,
					cargo_class_cd		 	 = v_cargo_class_cd,
					cargo_type			 	 = v_cargo_type,
					pack_method	  	 	 	 = v_pack_method,	 
					bl_awb				 	 = v_bl_awb,       
					tranship_origin		 	 = v_tranship_origin,
					tranship_destination	 = v_tranship_destination,	         
					voyage_no			 	 = v_voyage_no,	 
					lc_no				 	 = v_lc_no,
					etd					 	 = v_etd,
					eta					 	 = v_eta,
					print_tag			 	 = v_print_tag,	 	 	 
					origin				 	 = v_origin,
					destn				 	 = v_destn;
					    
--*    COMMIT;    
  END set_gipi_quote_mn;
  
  PROCEDURE del_gipi_quote_mn (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_CARGO
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_mn;  


  FUNCTION get_gipi_quote_ca (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_ca_tab PIPELINED IS
	
	v_gipi_quote_ca      gipi_quote_ca_type;
    
  BEGIN  
    FOR i IN (
		SELECT A.quote_id,                A.item_no,              A.LOCATION, 			    A.section_or_hazard_cd, 
			   b.section_or_hazard_title, A.capacity_cd, 		  c.position, 				A.limit_of_liability, 
	   		   A.section_line_cd,         A.section_subline_cd,   A.property_no_type, 		A.property_no, 
	   		   A.conveyance_info, 		  A.interest_on_premises, A.section_or_hazard_info, A.user_id, 
	   		   A.last_update
		  FROM GIPI_QUOTE_CA_ITEM A,
  	   	  	   GIIS_SECTION_OR_HAZARD b,
	   		   GIIS_POSITION c,
			   GIPI_QUOTE d
	     WHERE A.quote_id = p_quote_id
		   AND A.item_no  = p_item_no  
		 --  AND NVL(a.section_line_cd, d.line_cd) = b.section_line_cd 
   		 --  AND NVL(a.section_subline_cd,d.subline_cd) = b.section_subline_cd
		   AND A.quote_id = d.quote_id
		   AND A.section_or_hazard_cd = b.section_or_hazard_cd(+)
		   AND A.capacity_cd = c.position_cd(+) )
    LOOP
 	 	v_gipi_quote_ca.quote_id                 := i.quote_id;
	 	v_gipi_quote_ca.item_no           	  	 := i.item_no;
	 	v_gipi_quote_ca.LOCATION				 := i.LOCATION;
	 	v_gipi_quote_ca.section_or_hazard_cd	 := i.section_or_hazard_cd;
	 	v_gipi_quote_ca.section_or_hazard_title  := i.section_or_hazard_title;	 	 
	 	v_gipi_quote_ca.capacity_cd			     := i.capacity_cd;
	 	v_gipi_quote_ca.position				 := i.position;	 
	 	v_gipi_quote_ca.limit_of_liability		 := i.limit_of_liability;	 
	 	v_gipi_quote_ca.section_line_cd	  	 	 := i.section_line_cd;
	 	v_gipi_quote_ca.section_subline_cd		 := i.section_subline_cd;
	 	v_gipi_quote_ca.property_no_type  	 	 := i.property_no_type;	 
	 	v_gipi_quote_ca.property_no			  	 := i.property_no;       
	 	v_gipi_quote_ca.conveyance_info			 := i.conveyance_info;
	 	v_gipi_quote_ca.interest_on_premises	 := i.interest_on_premises;	         
	 	v_gipi_quote_ca.section_or_hazard_info   := i.section_or_hazard_info;	 
	 	v_gipi_quote_ca.user_id				 	 := i.user_id;
	 	v_gipi_quote_ca.last_update		  	 	 := i.last_update;
	 PIPE ROW (v_gipi_quote_ca);
    END LOOP;
	RETURN;  
  END get_gipi_quote_ca;

  
  PROCEDURE set_gipi_quote_ca (
  	 v_quote_id                IN  GIPI_QUOTE_CA_ITEM.quote_id%TYPE,
	 v_item_no           	   IN  GIPI_QUOTE_CA_ITEM.item_no%TYPE,
	 v_location				   IN  GIPI_QUOTE_CA_ITEM.LOCATION%TYPE,
	 v_section_or_hazard_cd	   IN  GIPI_QUOTE_CA_ITEM.section_or_hazard_cd%TYPE,	 
	 v_capacity_cd			   IN  GIPI_QUOTE_CA_ITEM.capacity_cd%TYPE,
	 v_limit_of_liability	   IN  GIPI_QUOTE_CA_ITEM.limit_of_liability%TYPE,	 
	 v_section_line_cd	  	   IN  GIPI_QUOTE_CA_ITEM.section_line_cd%TYPE,
	 v_section_subline_cd	   IN  GIPI_QUOTE_CA_ITEM.section_subline_cd%TYPE,
	 v_property_no_type  	   IN  GIPI_QUOTE_CA_ITEM.property_no_type%TYPE,	 
	 v_property_no			   IN  GIPI_QUOTE_CA_ITEM.property_no%TYPE,       
	 v_conveyance_info		   IN  GIPI_QUOTE_CA_ITEM.conveyance_info%TYPE,
	 v_interest_on_premises	   IN  GIPI_QUOTE_CA_ITEM.interest_on_premises%TYPE,	         
	 v_section_or_hazard_info  IN  GIPI_QUOTE_CA_ITEM.section_or_hazard_info%TYPE)	 
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_CA_ITEM
     USING dual ON (quote_id    = v_quote_id
	                AND item_no = v_item_no)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,                item_no,              LOCATION, 		    section_or_hazard_cd, 
		 	   	  capacity_cd, 		   	   limit_of_liability, 	 section_line_cd,  	section_subline_cd,   
				  property_no_type, 	   property_no,  		 conveyance_info,	interest_on_premises, 
				  section_or_hazard_info )
		 VALUES ( v_quote_id,              v_item_no,            v_location, 		v_section_or_hazard_cd, 
		 	   	  v_capacity_cd, 	  	   v_limit_of_liability, v_section_line_cd, v_section_subline_cd,   
				  v_property_no_type, 	   v_property_no,	   	 v_conveyance_info, v_interest_on_premises, 
				  v_section_or_hazard_info )
     WHEN MATCHED THEN
         UPDATE SET LOCATION			   = v_location,
					section_or_hazard_cd   = v_section_or_hazard_cd,	 
					capacity_cd			   = v_capacity_cd,
					limit_of_liability	   = v_limit_of_liability,	 
					section_line_cd	  	   = v_section_line_cd,
					section_subline_cd	   = v_section_subline_cd,
					property_no_type  	   = v_property_no_type,	 
					property_no			   = v_property_no,       
					conveyance_info		   = v_conveyance_info,
					interest_on_premises   = v_interest_on_premises,	         
					section_or_hazard_info = v_section_or_hazard_info;
					    
--*    COMMIT;    
  END set_gipi_quote_ca;
  
  PROCEDURE del_gipi_quote_ca (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_CA_ITEM
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_ca;
  
  
  FUNCTION get_gipi_quote_en (p_quote_id            GIPI_QUOTE.quote_id%TYPE,
                              p_engg_basic_infonum  GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE )    RETURN gipi_quote_en_tab PIPELINED IS
	
	v_gipi_quote_en      gipi_quote_en_type;
    
  BEGIN  
    FOR i IN (
		SELECT DISTINCT quote_id,             engg_basic_infonum, contract_proj_buss_title, site_location,
			   construct_start_date, construct_end_date, maintain_start_date, 	   maintain_end_date,	 
	   		   testing_start_date, 	 testing_end_date, 	 weeks_test, 			   time_excess,       
	   		   mbi_policy_no, 		 user_id, 			 last_update 
		  FROM GIPI_QUOTE_EN_ITEM
		 WHERE quote_id = p_quote_id
		   AND engg_basic_infonum = p_engg_basic_infonum)
    LOOP
		v_gipi_quote_en.quote_id                 := i.quote_id;
	 	v_gipi_quote_en.engg_basic_infonum	  	 := i.engg_basic_infonum;
	 	v_gipi_quote_en.contract_proj_buss_title := i.contract_proj_buss_title;
	 	v_gipi_quote_en.site_location			 := i.site_location;
	 	v_gipi_quote_en.construct_start_date	 := i.construct_start_date;	 	 
	 	v_gipi_quote_en.construct_end_date	   	 := i.construct_end_date;
	 	v_gipi_quote_en.maintain_start_date	   	 := i.maintain_start_date;	 
	 	v_gipi_quote_en.maintain_end_date		 := i.maintain_end_date;	 
	 	v_gipi_quote_en.testing_start_date	  	 := i.testing_start_date;
	 	v_gipi_quote_en.testing_end_date		 := i.testing_end_date;
	 	v_gipi_quote_en.weeks_test				 := i.weeks_test;	 
	 	v_gipi_quote_en.time_excess			   	 := i.time_excess;       
	 	v_gipi_quote_en.mbi_policy_no			 := i.mbi_policy_no;
	 	v_gipi_quote_en.user_id				   	 := i.user_id;
	 	v_gipi_quote_en.last_update		  	   	 := i.last_update;
	 PIPE ROW (v_gipi_quote_en);
    END LOOP;
	RETURN;  
  END get_gipi_quote_en;

  FUNCTION get_gipi_quote_en2 (p_quote_id            GIPI_QUOTE.quote_id%TYPE)    
    
    RETURN gipi_quote_en_tab PIPELINED IS
	
	v_gipi_quote_en      gipi_quote_en_type;
    
  BEGIN  
    FOR i IN (
		SELECT DISTINCT quote_id,    engg_basic_infonum, contract_proj_buss_title, site_location,
			   construct_start_date, construct_end_date, maintain_start_date, 	   maintain_end_date,	 
	   		   testing_start_date, 	 testing_end_date, 	 weeks_test, 			   time_excess,       
	   		   mbi_policy_no, 		 user_id, 			 last_update 
		  FROM GIPI_QUOTE_EN_ITEM
		 WHERE quote_id = p_quote_id)
    
    LOOP
		v_gipi_quote_en.quote_id                 := i.quote_id;
	 	v_gipi_quote_en.engg_basic_infonum	  	 := i.engg_basic_infonum;
	 	v_gipi_quote_en.contract_proj_buss_title := i.contract_proj_buss_title;
	 	v_gipi_quote_en.site_location			 := i.site_location;
	 	v_gipi_quote_en.construct_start_date	 := i.construct_start_date;	 	 
	 	v_gipi_quote_en.construct_end_date	   	 := i.construct_end_date;
	 	v_gipi_quote_en.maintain_start_date	   	 := i.maintain_start_date;	 
	 	v_gipi_quote_en.maintain_end_date		 := i.maintain_end_date;	 
	 	v_gipi_quote_en.testing_start_date	  	 := i.testing_start_date;
	 	v_gipi_quote_en.testing_end_date		 := i.testing_end_date;
	 	v_gipi_quote_en.weeks_test				 := i.weeks_test;	 
	 	v_gipi_quote_en.time_excess			   	 := i.time_excess;       
	 	v_gipi_quote_en.mbi_policy_no			 := i.mbi_policy_no;
	 	v_gipi_quote_en.user_id				   	 := i.user_id;
	 	v_gipi_quote_en.last_update		  	   	 := i.last_update;
	 PIPE ROW (v_gipi_quote_en);
     
     RETURN;
     
    END LOOP;
	  
  END get_gipi_quote_en2;

  PROCEDURE set_gipi_quote_en (
  	 v_quote_id                  IN  GIPI_QUOTE_EN_ITEM.quote_id%TYPE,
	 v_engg_basic_infonum	  	 IN  GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE,
	 v_contract_proj_buss_title  IN  GIPI_QUOTE_EN_ITEM.contract_proj_buss_title%TYPE,
	 v_site_location			 IN  GIPI_QUOTE_EN_ITEM.site_location%TYPE,
	 v_construct_start_date	   	 IN  GIPI_QUOTE_EN_ITEM.construct_start_date%TYPE,	 	 
	 v_construct_end_date	   	 IN  GIPI_QUOTE_EN_ITEM.construct_end_date%TYPE,
	 v_maintain_start_date	   	 IN  GIPI_QUOTE_EN_ITEM.maintain_start_date%TYPE,	 
	 v_maintain_end_date		 IN  GIPI_QUOTE_EN_ITEM.maintain_end_date%TYPE,	 
	 v_testing_start_date	  	 IN  GIPI_QUOTE_EN_ITEM.testing_start_date%TYPE,
	 v_testing_end_date		   	 IN  GIPI_QUOTE_EN_ITEM.testing_end_date%TYPE,
	 v_weeks_test				 IN  GIPI_QUOTE_EN_ITEM.weeks_test%TYPE,	 
	 v_time_excess			   	 IN  GIPI_QUOTE_EN_ITEM.time_excess%TYPE,       
	 v_mbi_policy_no			 IN  GIPI_QUOTE_EN_ITEM.mbi_policy_no%TYPE)	 
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_EN_ITEM
     USING dual ON (quote_id    = v_quote_id
	                AND engg_basic_infonum = v_engg_basic_infonum)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,               engg_basic_infonum, 	contract_proj_buss_title, 	site_location,
			   	  construct_start_date,   construct_end_date,	maintain_start_date, 	  	maintain_end_date,	 
	   		   	  testing_start_date, 	  testing_end_date, 	weeks_test, 			  	time_excess,       
	   		   	  mbi_policy_no)
		 VALUES ( v_quote_id,             v_engg_basic_infonum, v_contract_proj_buss_title, v_site_location,
			   	  v_construct_start_date, v_construct_end_date, v_maintain_start_date, 	  	v_maintain_end_date,	 
	   		   	  v_testing_start_date,   v_testing_end_date, 	v_weeks_test, 			  	v_time_excess,       
	   		   	  v_mbi_policy_no )
     WHEN MATCHED THEN
         UPDATE SET contract_proj_buss_title   = v_contract_proj_buss_title,
	 				site_location			   = v_site_location,
	 				construct_start_date	   = v_construct_start_date,	 	 
	 				construct_end_date	   	   = v_construct_end_date,
	 				maintain_start_date	   	   = v_maintain_start_date,	 
	 				maintain_end_date		   = v_maintain_end_date,	 
	 				testing_start_date	  	   = v_testing_start_date,
	 				testing_end_date		   = v_testing_end_date,
	 				weeks_test				   = v_weeks_test,	 
	 				time_excess			   	   = v_time_excess,       
	 				mbi_policy_no			   = v_mbi_policy_no; 
					    
--*    COMMIT;    
  END set_gipi_quote_en;
  
  PROCEDURE del_gipi_quote_en (p_quote_id            GIPI_QUOTE.quote_id%TYPE,
                               p_engg_basic_infonum  GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_EN_ITEM
     WHERE quote_id = p_quote_id
	   AND engg_basic_infonum = p_engg_basic_infonum; 	 
--*	COMMIT; 

  END del_gipi_quote_en;
  
  
  PROCEDURE del_gipi_quote_en2 (p_quote_id            GIPI_QUOTE.quote_id%TYPE) 
  
  IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_EN_ITEM
     WHERE quote_id = p_quote_id;	 

  END del_gipi_quote_en2;
  

  FUNCTION get_gipi_quote_mh (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_mh_tab PIPELINED IS
	
	v_gipi_quote_mh      gipi_quote_mh_type;
    
  BEGIN  
    FOR i IN (
		SELECT A.quote_id,     A.item_no,         A.geog_limit,    A.dry_place, 
	   		   A.dry_date, 	   A.rec_flag, 	      A.deduct_text,   A.vessel_cd, 
	   		   b.vessel_name,  b.vessel_old_name, c.vestype_desc,  b.propel_sw, 	  
	   		   d.hull_desc,    b.gross_ton, 	  b.year_built,    E.vess_class_desc, 
	   		   b.reg_owner,    b.reg_place, 	  b.no_crew,       b.net_ton,
	   		   b.deadweight,   b.crew_nat, 		  b.vessel_length, b.vessel_breadth,  
	   		   b.vessel_depth, A.user_id, 		  A.last_update
	      FROM GIPI_QUOTE_MH_ITEM A,
  	   	  	   GIIS_VESSEL b,
	  		   GIIS_VESTYPE c,
	   		   GIIS_HULL_TYPE d,
	   		   GIIS_VESS_CLASS E
	     WHERE A.quote_id = p_quote_id
		   AND A.item_no = p_item_no
		   AND b.vessel_flag = 'V' 
		   AND c.vestype_cd = b.vestype_cd
		   AND d.hull_type_cd = b.hull_type_cd 
		   AND E.vess_class_cd = b.vess_class_cd
		   AND A.vessel_cd = b.vessel_cd (+))
    LOOP
		v_gipi_quote_mh.quote_id            := i.quote_id;
	 	v_gipi_quote_mh.item_no           	:= i.item_no;
	 	v_gipi_quote_mh.geog_limit			:= i.geog_limit;
	 	v_gipi_quote_mh.dry_place			:= i.dry_place;
	 	v_gipi_quote_mh.dry_date			:= i.dry_date;	 
	 	v_gipi_quote_mh.rec_flag			:= i.rec_flag;
	 	v_gipi_quote_mh.deduct_text			:= i.deduct_text;	 	 
	 	v_gipi_quote_mh.vessel_cd			:= i.vessel_cd;
	 	v_gipi_quote_mh.vessel_name		 	:= i.vessel_name;
	 	v_gipi_quote_mh.vessel_old_name		:= i.vessel_old_name;
	 	v_gipi_quote_mh.vestype_desc	 	:= i.vestype_desc;
	 	v_gipi_quote_mh.propel_sw			:= i.propel_sw;
	 	v_gipi_quote_mh.hull_desc			:= i.hull_desc;
	 	v_gipi_quote_mh.gross_ton			:= i.gross_ton;
	 	v_gipi_quote_mh.year_built			:= i.year_built;
	 	v_gipi_quote_mh.ves_class_desc		:= i.vess_class_desc;
	 	v_gipi_quote_mh.reg_owner			:= i.reg_owner;
	 	v_gipi_quote_mh.reg_place			:= i.reg_place;
	 	v_gipi_quote_mh.no_crew				:= i.no_crew;	 	 	 	 	 	 	 	 	 	 
	 	v_gipi_quote_mh.net_ton				:= i.net_ton;
	 	v_gipi_quote_mh.deadweight		 	:= i.deadweight;	 
	 	v_gipi_quote_mh.crew_nat			:= i.crew_nat;
	 	v_gipi_quote_mh.vessel_length		:= i.vessel_length;	 
	 	v_gipi_quote_mh.vessel_breadth		:= i.vessel_breadth;
	 	v_gipi_quote_mh.vessel_depth		:= i.vessel_depth;	 	 
	 	v_gipi_quote_mh.user_id				:= i.user_id;
	 	v_gipi_quote_mh.last_update		  	:= i.last_update;
	 PIPE ROW (v_gipi_quote_mh);
    END LOOP;
	RETURN;  
  END get_gipi_quote_mh;

  
  PROCEDURE set_gipi_quote_mh (
  	 v_quote_id              IN  GIPI_QUOTE_MH_ITEM.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_MH_ITEM.item_no%TYPE,
	 v_geog_limit			 IN  GIPI_QUOTE_MH_ITEM.geog_limit%TYPE,
	 v_dry_place			 IN  GIPI_QUOTE_MH_ITEM.dry_place%TYPE,
	 v_dry_date				 IN  GIPI_QUOTE_MH_ITEM.dry_date%TYPE,	 
	 v_rec_flag				 IN  GIPI_QUOTE_MH_ITEM.rec_flag%TYPE,
	 v_deduct_text			 IN  GIPI_QUOTE_MH_ITEM.deduct_text%TYPE,	 	 
	 v_vessel_cd			 IN  GIPI_QUOTE_MH_ITEM.vessel_cd%TYPE )	 
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_MH_ITEM
     USING dual ON (quote_id    = v_quote_id
	                AND item_no = v_item_no)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,   item_no,    geog_limit,    dry_place, 
	   		      dry_date,   rec_flag,   deduct_text, 	 vessel_cd )
		 VALUES ( v_quote_id, v_item_no,  v_geog_limit,  v_dry_place, 
	   		      v_dry_date, v_rec_flag, v_deduct_text, v_vessel_cd )
     WHEN MATCHED THEN
         UPDATE SET geog_limit	  = v_geog_limit,
	 				dry_place	  = v_dry_place,
	 				dry_date	  = v_dry_date,	 
	 				rec_flag	  = v_rec_flag,
	 				deduct_text	  = v_deduct_text,	 	 
	 				vessel_cd	  = v_vessel_cd; 
					    
--*    COMMIT;    
  END set_gipi_quote_mh;
  
  PROCEDURE del_gipi_quote_mh (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_MH_ITEM
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_mh;  
  

  FUNCTION get_gipi_quote_av (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_av_tab PIPELINED IS
	
	v_gipi_quote_av      gipi_quote_av_type;
    
  BEGIN  
    FOR i IN (
		SELECT A.quote_id,     A.item_no,        A.vessel_cd,     A.rec_flag, 
		 	   A.fixed_wing,   A.rotor, 		 b.vessel_name,   b.rpc_no, 
			   c.air_desc, 	   A.purpose, 		 A.deduct_text,   A.prev_util_hrs, 
			   A.est_util_hrs, A.total_fly_time, A.qualification, A.geog_limit, 
			   A.user_id, 	   A.last_update
	      FROM GIPI_QUOTE_AV_ITEM A,
  	   	  	   GIIS_VESSEL b,
	  		   GIIS_AIR_TYPE c
	     WHERE A.quote_id = p_quote_id
		   AND A.item_no = p_item_no
		   AND b.vessel_flag (+) = 'A' 
           AND A.vessel_cd = b.vessel_cd (+)
		   AND c.air_type_cd (+) = b.air_type_cd)
    LOOP
		v_gipi_quote_av.quote_id        := i.quote_id;
	 	v_gipi_quote_av.item_no         := i.item_no;
	 	v_gipi_quote_av.vessel_cd		:= i.vessel_cd;
	 	v_gipi_quote_av.rec_flag		:= i.rec_flag;
	 	v_gipi_quote_av.fixed_wing		:= i.fixed_wing;
	 	v_gipi_quote_av.rotor			:= i.rotor;	 
	 	v_gipi_quote_av.vessel_name		:= i.vessel_name;
	 	v_gipi_quote_av.rpc_no			:= i.rpc_no;
	 	v_gipi_quote_av.air_desc	 	:= i.air_desc;	 
	 	v_gipi_quote_av.purpose			:= i.purpose;
	 	v_gipi_quote_av.deduct_text		:= i.deduct_text;
	 	v_gipi_quote_av.prev_util_hrs	:= i.prev_util_hrs;
	 	v_gipi_quote_av.est_util_hrs	:= i.est_util_hrs;
	 	v_gipi_quote_av.total_fly_time	:= i.total_fly_time;	 	 	 	 	 
	 	v_gipi_quote_av.qualification	:= i.qualification;
	 	v_gipi_quote_av.geog_limit		:= i.geog_limit;	 
	 	v_gipi_quote_av.user_id			:= i.user_id;
	 	v_gipi_quote_av.last_update		:= i.last_update;
	 PIPE ROW (v_gipi_quote_av);
    END LOOP;
	RETURN;  
  END get_gipi_quote_av;

  
  PROCEDURE set_gipi_quote_av (
  	 v_quote_id              IN  GIPI_QUOTE_AV_ITEM.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_AV_ITEM.item_no%TYPE,
	 v_vessel_cd			 IN  GIPI_QUOTE_AV_ITEM.vessel_cd%TYPE,
	 v_rec_flag				 IN  GIPI_QUOTE_AV_ITEM.rec_flag%TYPE,
	 v_fixed_wing			 IN  GIPI_QUOTE_AV_ITEM.fixed_wing%TYPE,
	 v_rotor				 IN  GIPI_QUOTE_AV_ITEM.rotor%TYPE,	 
	 v_purpose				 IN  GIPI_QUOTE_AV_ITEM.purpose%TYPE,
	 v_deduct_text			 IN  GIPI_QUOTE_AV_ITEM.deduct_text%TYPE,
	 v_prev_util_hrs		 IN  GIPI_QUOTE_AV_ITEM.prev_util_hrs%TYPE,
	 v_est_util_hrs			 IN  GIPI_QUOTE_AV_ITEM.est_util_hrs%TYPE,
	 v_total_fly_time		 IN  GIPI_QUOTE_AV_ITEM.total_fly_time%TYPE,	 	 	 	 	 
	 v_qualification		 IN  GIPI_QUOTE_AV_ITEM.qualification%TYPE,
	 v_geog_limit			 IN  GIPI_QUOTE_AV_ITEM.geog_limit%TYPE)	 
  IS
    
  BEGIN
	   
	MERGE INTO GIPI_QUOTE_AV_ITEM
     USING dual ON (quote_id    = v_quote_id
	                AND item_no = v_item_no)
     WHEN NOT MATCHED THEN 
         INSERT ( quote_id,        item_no,        vessel_cd,        rec_flag, 
		 	   	  fixed_wing,      rotor, 		   purpose, 		 deduct_text,   
				  prev_util_hrs,   est_util_hrs,   total_fly_time, 	 qualification, 
				  geog_limit )
		 VALUES ( v_quote_id,      v_item_no,      v_vessel_cd,      v_rec_flag, 
		 	   	  v_fixed_wing,    v_rotor, 	   v_purpose, 		 v_deduct_text,
				  v_prev_util_hrs, v_est_util_hrs, v_total_fly_time, v_qualification, 
				  v_geog_limit )
     WHEN MATCHED THEN
         UPDATE SET vessel_cd		= v_vessel_cd,
					rec_flag		= v_rec_flag,
	 				fixed_wing		= v_fixed_wing,
	 				rotor			= v_rotor,	 
	 				purpose			= v_purpose,
	 				deduct_text		= v_deduct_text,
	 				prev_util_hrs	= v_prev_util_hrs,
	 				est_util_hrs	= v_est_util_hrs,
	 				total_fly_time	= v_total_fly_time,	 	 	 	 	 
	 				qualification	= v_qualification,
	 				geog_limit		= v_geog_limit; 
					    
--*    COMMIT;    
  END set_gipi_quote_av;
  
  PROCEDURE del_gipi_quote_av (p_quote_id    GIPI_QUOTE.quote_id%TYPE,
                               p_item_no     GIPI_QUOTE_ITEM.item_no%TYPE) IS
  
  BEGIN
    
	DELETE FROM GIPI_QUOTE_AV_ITEM
     WHERE quote_id = p_quote_id
	   AND item_no  = p_item_no; 	 
--*	COMMIT; 

  END del_gipi_quote_av;  
  
    FUNCTION get_all_gipi_quote_mh (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_mh_tab PIPELINED IS
	
	v_gipi_quote_mh      gipi_quote_mh_type;
    
  BEGIN  
    FOR i IN (
		SELECT A.quote_id,     A.item_no,         A.geog_limit,    A.dry_place, 
	   		   A.dry_date, 	   A.rec_flag, 	      A.deduct_text,   A.vessel_cd, 
	   		   b.vessel_name,  b.vessel_old_name, c.vestype_desc,  b.propel_sw, 	  
	   		   d.hull_desc,    b.gross_ton, 	  b.year_built,    E.vess_class_desc, 
	   		   b.reg_owner,    b.reg_place, 	  b.no_crew,       b.net_ton,
	   		   b.deadweight,   b.crew_nat, 		  b.vessel_length, b.vessel_breadth,  
	   		   b.vessel_depth, A.user_id, 		  A.last_update
	      FROM GIPI_QUOTE_MH_ITEM A,
  	   	  	   GIIS_VESSEL b,
	  		   GIIS_VESTYPE c,
	   		   GIIS_HULL_TYPE d,
	   		   GIIS_VESS_CLASS E
	     WHERE A.quote_id = p_quote_id
		   --AND A.item_no = p_item_no
		   AND b.vessel_flag = 'V' 
		   AND c.vestype_cd = b.vestype_cd 
		   AND d.hull_type_cd = b.hull_type_cd 
		   AND E.vess_class_cd = b.vess_class_cd
		   AND A.vessel_cd = b.vessel_cd (+))
    LOOP
		v_gipi_quote_mh.quote_id            := i.quote_id;
	 	v_gipi_quote_mh.item_no           	:= i.item_no;
	 	v_gipi_quote_mh.geog_limit			:= i.geog_limit;
	 	v_gipi_quote_mh.dry_place			:= i.dry_place;
	 	v_gipi_quote_mh.dry_date			:= i.dry_date;	 
	 	v_gipi_quote_mh.rec_flag			:= i.rec_flag;
	 	v_gipi_quote_mh.deduct_text			:= i.deduct_text;	 	 
	 	v_gipi_quote_mh.vessel_cd			:= i.vessel_cd;
	 	v_gipi_quote_mh.vessel_name		 	:= i.vessel_name;
	 	v_gipi_quote_mh.vessel_old_name		:= i.vessel_old_name;
	 	v_gipi_quote_mh.vestype_desc	 	:= i.vestype_desc;
	 	v_gipi_quote_mh.propel_sw			:= i.propel_sw;
	 	v_gipi_quote_mh.hull_desc			:= i.hull_desc;
	 	v_gipi_quote_mh.gross_ton			:= i.gross_ton;
	 	v_gipi_quote_mh.year_built			:= i.year_built;
	 	v_gipi_quote_mh.ves_class_desc		:= i.vess_class_desc;
	 	v_gipi_quote_mh.reg_owner			:= i.reg_owner;
	 	v_gipi_quote_mh.reg_place			:= i.reg_place;
	 	v_gipi_quote_mh.no_crew				:= i.no_crew;	 	 	 	 	 	 	 	 	 	 
	 	v_gipi_quote_mh.net_ton				:= i.net_ton;
	 	v_gipi_quote_mh.deadweight		 	:= i.deadweight;	 
	 	v_gipi_quote_mh.crew_nat			:= i.crew_nat;
	 	v_gipi_quote_mh.vessel_length		:= i.vessel_length;	 
	 	v_gipi_quote_mh.vessel_breadth		:= i.vessel_breadth;
	 	v_gipi_quote_mh.vessel_depth		:= i.vessel_depth;	 	 
	 	v_gipi_quote_mh.user_id				:= i.user_id;
	 	v_gipi_quote_mh.last_update		  	:= i.last_update;
	 PIPE ROW (v_gipi_quote_mh);
    END LOOP;
	RETURN;  
  END get_all_gipi_quote_mh;
  
    FUNCTION get_gipi_quote_fi2 (p_quote_id   gipi_quote_fi_item.quote_id%TYPE,
                                 p_item_no    gipi_quote_fi_item.item_no%TYPE)
       RETURN gipi_quote_fi_item_tab PIPELINED
    IS
       v_gipi_quote_fi   gipi_quote_fi_item_type;
    BEGIN
       FOR i IN (SELECT assignee, block_id, risk_cd, tarf_cd,
                        construction_remarks, front, RIGHT, LEFT, rear,
                        occupancy_remarks, quote_id, item_no, user_id, loc_risk1,
                        loc_risk2, loc_risk3, last_update, block_no, district_no,
                        eq_zone, fr_item_type, typhoon_zone, flood_zone,
                        construction_cd, occupancy_cd, tariff_zone,
                        latitude,longitude --Added by MarkS 02/08/2017 SR5918
                   FROM gipi_quote_fi_item
                  WHERE quote_id = p_quote_id 
                    AND item_no = p_item_no)
       LOOP
          v_gipi_quote_fi.assignee := i.assignee;
          v_gipi_quote_fi.block_id := i.block_id;
          v_gipi_quote_fi.risk_cd := i.risk_cd;
          v_gipi_quote_fi.tarf_cd := i.tarf_cd;
          v_gipi_quote_fi.construction_remarks := i.construction_remarks;
          v_gipi_quote_fi.front := i.front;
          v_gipi_quote_fi.RIGHT := i.RIGHT;
          v_gipi_quote_fi.LEFT := i.LEFT;
          v_gipi_quote_fi.rear := i.rear;
          v_gipi_quote_fi.occupancy_remarks := i.occupancy_remarks;
          v_gipi_quote_fi.item_no := i.item_no;
          v_gipi_quote_fi.user_id := i.user_id;
          v_gipi_quote_fi.loc_risk1 := i.loc_risk1;
          v_gipi_quote_fi.loc_risk2 := i.loc_risk2;
          v_gipi_quote_fi.loc_risk3 := i.loc_risk3;
          v_gipi_quote_fi.last_update := i.last_update;
          v_gipi_quote_fi.block_no := i.block_no;
          v_gipi_quote_fi.district_no := i.district_no;
          v_gipi_quote_fi.eq_zone := i.eq_zone;
          v_gipi_quote_fi.fr_item_type := i.fr_item_type;
          v_gipi_quote_fi.typhoon_zone := i.typhoon_zone;
          v_gipi_quote_fi.flood_zone := i.flood_zone;
          v_gipi_quote_fi.construction_cd := i.construction_cd;
          v_gipi_quote_fi.occupancy_cd := i.occupancy_cd;
          v_gipi_quote_fi.tariff_zone := i.tariff_zone;
          v_gipi_quote_fi.latitude := i.latitude;
          v_gipi_quote_fi.longitude := i.longitude;
            
          FOR a IN (SELECT b.province_desc province
                      FROM giis_block a, giis_province b
                     WHERE a.province_cd = b.province_cd
                       AND a.block_id = i.block_id)
          LOOP
             v_gipi_quote_fi.dsp_province := a.province;
             EXIT;
          END LOOP;

          FOR b IN (SELECT city, block_desc, district_desc, district_no
                      FROM giis_block
                     WHERE block_id = i.block_id)
          LOOP
             v_gipi_quote_fi.dsp_city := b.city;
             v_gipi_quote_fi.dsp_block_no := b.block_desc;
             v_gipi_quote_fi.dsp_district_desc := b.district_desc;
             EXIT;
          END LOOP;

          FOR a6 IN (SELECT fr_itm_tp_ds, fr_item_type
                       FROM giis_fi_item_type
                      WHERE fr_item_type = i.fr_item_type)
          LOOP
             v_gipi_quote_fi.dsp_fr_item_type := a6.fr_itm_tp_ds;
          END LOOP;

          FOR a7 IN (SELECT construction_desc, construction_cd
                       FROM giis_fire_construction
                      WHERE construction_cd = i.construction_cd)
          LOOP
             v_gipi_quote_fi.dsp_construction_cd := a7.construction_desc;
          END LOOP;

          FOR a8 IN (SELECT occupancy_desc, occupancy_cd
                       FROM giis_fire_occupancy
                      WHERE occupancy_cd = i.occupancy_cd)
          LOOP
             v_gipi_quote_fi.dsp_occupancy_cd := a8.occupancy_desc;
          END LOOP;

          FOR a9 IN (SELECT risk_cd, risk_desc
                       FROM giis_risks
                      WHERE block_id = i.block_id)
          LOOP
             v_gipi_quote_fi.dsp_risk := a9.risk_desc;
          END LOOP;

          FOR rec IN (SELECT date_from, date_to
                        FROM gipi_quote_item
                       WHERE quote_id = p_quote_id AND item_no = p_item_no)
          LOOP
             v_gipi_quote_fi.nbt_from_dt := rec.date_from;
             v_gipi_quote_fi.nbt_to_dt := rec.date_to;
          END LOOP;

          FOR a1 IN (SELECT tariff_zone_desc tariff_desc
                       FROM giis_tariff_zone
                      WHERE tariff_zone = v_gipi_quote_fi.tariff_zone)
          LOOP
             v_gipi_quote_fi.dsp_tariff_zone := a1.tariff_desc;
          END LOOP;

          FOR a2 IN (SELECT eq_desc
                       FROM giis_eqzone
                      WHERE eq_zone = v_gipi_quote_fi.eq_zone)
          LOOP
             v_gipi_quote_fi.dsp_eq_zone := a2.eq_desc;
          END LOOP;

          FOR a3 IN (SELECT typhoon_zone_desc typhoon_desc
                       FROM giis_typhoon_zone
                      WHERE typhoon_zone = i.typhoon_zone)
          LOOP
             v_gipi_quote_fi.dsp_typhoon_zone := a3.typhoon_desc;
          END LOOP;

          FOR a4 IN (SELECT flood_zone_desc flood_desc
                       FROM giis_flood_zone
                      WHERE flood_zone = i.flood_zone)
          LOOP
             v_gipi_quote_fi.dsp_flood_zone := a4.flood_desc;
          END LOOP;

          PIPE ROW (v_gipi_quote_fi);
       END LOOP;

       RETURN;
    END get_gipi_quote_fi2;
    
    FUNCTION get_gipi_quote_mc2 (
       p_quote_id   gipi_quote_item_mc.quote_id%TYPE,
       p_item_no    gipi_quote_item_mc.item_no%TYPE
    )
       RETURN gipi_quote_mc_item_tab PIPELINED
    IS
       v_gipi_quote_mc   gipi_quote_mc_item_type;
    BEGIN
       FOR i IN (SELECT quote_id, item_no, assignee, acquired_from, origin,
                        destination, plate_no, model_year, mv_file_no,
                        no_of_pass, basic_color_cd, color, towing, repair_lim,
                        coc_type, coc_serial_no, coc_yy, ctv_tag,
                        type_of_body_cd, car_company_cd, make, series_cd,
                        mot_type, unladen_wt, serial_no, subline_type_cd,
                        motor_no, est_value, tariff_zone, coc_issue_date,
                        make_cd, color_cd, coc_atcn, coc_seq_no, subline_cd
                   FROM gipi_quote_item_mc
                  WHERE quote_id = p_quote_id AND item_no = p_item_no)
       LOOP
          v_gipi_quote_mc.quote_id := i.quote_id;
          v_gipi_quote_mc.item_no := i.item_no;
          v_gipi_quote_mc.assignee := i.assignee;
          v_gipi_quote_mc.acquired_from := i.acquired_from;
          v_gipi_quote_mc.origin := i.origin;
          v_gipi_quote_mc.destination := i.destination;
          v_gipi_quote_mc.plate_no := i.plate_no;
          v_gipi_quote_mc.model_year := i.model_year;
          v_gipi_quote_mc.mv_file_no := i.mv_file_no;
          v_gipi_quote_mc.no_of_pass := i.no_of_pass;
          v_gipi_quote_mc.basic_color_cd := i.basic_color_cd;
          v_gipi_quote_mc.color := i.color;
          v_gipi_quote_mc.towing := i.towing;
          v_gipi_quote_mc.repair_lim := i.repair_lim;
          v_gipi_quote_mc.coc_type := i.coc_type;
          v_gipi_quote_mc.coc_serial_no := i.coc_serial_no;
          v_gipi_quote_mc.coc_yy := i.coc_yy;
          v_gipi_quote_mc.ctv_tag := i.ctv_tag;
          v_gipi_quote_mc.type_of_body_cd := i.type_of_body_cd;
          v_gipi_quote_mc.car_company_cd := i.car_company_cd;
          v_gipi_quote_mc.make := i.make;
          v_gipi_quote_mc.series_cd := i.series_cd;
          v_gipi_quote_mc.mot_type := i.mot_type;
          v_gipi_quote_mc.unladen_wt := i.unladen_wt;
          v_gipi_quote_mc.serial_no := i.serial_no;
          v_gipi_quote_mc.subline_type_cd := i.subline_type_cd;
          v_gipi_quote_mc.motor_no := i.motor_no;
          v_gipi_quote_mc.est_value := i.est_value;
          v_gipi_quote_mc.tariff_zone := i.tariff_zone;
          v_gipi_quote_mc.coc_issue_date := i.coc_issue_date;
          v_gipi_quote_mc.make_cd := i.make_cd;
          v_gipi_quote_mc.color_cd := i.color_cd;
          v_gipi_quote_mc.coc_atcn := i.coc_atcn;
          v_gipi_quote_mc.coc_seq_no := i.coc_seq_no;
          v_gipi_quote_mc.subline_cd := i.subline_cd;

          FOR rec IN (SELECT basic_color, basic_color_cd
                        FROM giis_mc_color
                       WHERE basic_color_cd = i.basic_color_cd)
          LOOP
             v_gipi_quote_mc.dsp_basic_color := rec.basic_color;
          END LOOP;

          FOR rec1 IN (SELECT type_of_body_cd, type_of_body
                         FROM giis_type_of_body
                        WHERE type_of_body_cd = i.type_of_body_cd)
          LOOP
             v_gipi_quote_mc.dsp_type_of_body_cd := rec1.type_of_body;
          END LOOP;

          FOR rec2 IN (SELECT car_company, car_company_cd
                         FROM giis_mc_car_company
                        WHERE car_company_cd = i.car_company_cd)
          LOOP
             v_gipi_quote_mc.dsp_car_company_cd := rec2.car_company;
          END LOOP;

          FOR rec3 IN (SELECT engine_series, series_cd
                         FROM giis_mc_eng_series
                        WHERE series_cd = i.series_cd
                          AND make_cd = i.make_cd
                          AND car_company_cd = i.car_company_cd)
          LOOP
             v_gipi_quote_mc.dsp_engine_series := rec3.engine_series;
          END LOOP;

          FOR rec4 IN (SELECT motor_type_desc, type_cd
                         FROM giis_motortype
                        WHERE type_cd = i.mot_type
                          AND subline_cd = i.subline_cd)
          LOOP
             v_gipi_quote_mc.dsp_mot_type := rec4.motor_type_desc;
          END LOOP;

          FOR rec5 IN (SELECT subline_type_desc, subline_type_cd
                         FROM giis_mc_subline_type
                        WHERE subline_type_cd = i.subline_type_cd
                          AND subline_cd = i.subline_cd)
          LOOP
             v_gipi_quote_mc.dsp_subline_type_cd := rec5.subline_type_desc;
          END LOOP;

          BEGIN
            SELECT SUM (deductible_amt)
              INTO v_gipi_quote_mc.dsp_deductibles
              FROM gipi_quote_deductibles
             WHERE quote_id = i.quote_id
               AND item_no = i.item_no;
            
            v_gipi_quote_mc.dsp_repair_lim := v_gipi_quote_mc.towing + v_gipi_quote_mc.dsp_deductibles;
          END;

          PIPE ROW (v_gipi_quote_mc);
       END LOOP;

       RETURN;
    END get_gipi_quote_mc2;
    
    FUNCTION get_gipi_quote_mn2 (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_mn_tab PIPELINED IS
	v_gipi_quote_mn      gipi_quote_mn_type;
    
  BEGIN  
    FOR i IN (
		  SELECT A.quote_id,        A.item_no,              A.geog_cd,         
		  		 A.vessel_cd,		A.cargo_class_cd,       A.cargo_type, 		
                 A.pack_method, 	A.bl_awb,               A.tranship_origin, 
                 A.tranship_destination, A.voyage_no, 	    A.lc_no, 
				 A.etd, 			A.eta, 					A.print_tag, 	 
				 A.origin,			A.destn, 				A.user_id, 		  A.last_update 
		    FROM GIPI_QUOTE_CARGO A
		   WHERE A.quote_id       = p_quote_id
		     AND A.item_no   	  = p_item_no)
    LOOP
		v_gipi_quote_mn.quote_id                := i.quote_id;
		v_gipi_quote_mn.item_no           	  	:= i.item_no;
		v_gipi_quote_mn.geog_cd				 	:= i.geog_cd;
		v_gipi_quote_mn.vessel_cd				:= i.vessel_cd;
		v_gipi_quote_mn.cargo_class_cd		  	:= i.cargo_class_cd; 
		v_gipi_quote_mn.cargo_type				:= i.cargo_type; 
		v_gipi_quote_mn.pack_method	  	 	 	:= i.pack_method;	 
		v_gipi_quote_mn.bl_awb					:= i.bl_awb;       
		v_gipi_quote_mn.tranship_origin		 	:= i.tranship_origin;
		v_gipi_quote_mn.tranship_destination	:= i.tranship_destination;	         
		v_gipi_quote_mn.voyage_no				:= i.voyage_no;	 
		v_gipi_quote_mn.lc_no					:= i.lc_no;
		v_gipi_quote_mn.etd					 	:= i.etd;
		v_gipi_quote_mn.eta					 	:= i.eta;
		v_gipi_quote_mn.print_tag				:= i.print_tag;	 	 	 
		v_gipi_quote_mn.origin					:= i.origin;
		v_gipi_quote_mn.destn					:= i.destn;	 
		v_gipi_quote_mn.user_id				 	:= i.user_id;
		v_gipi_quote_mn.last_update		  	 	:= i.last_update;
        
        FOR rec IN(select geog_desc, geog_cd
                 from giis_geog_class 
                 WHERE geog_cd = i.geog_cd)
        LOOP
          v_gipi_quote_mn.geog_desc := rec.geog_desc;
        END LOOP;
         
        FOR rec1 IN(select vessel_name , vessel_cd
                 from giis_vessel 
                 WHERE vessel_cd = i.vessel_cd)
        LOOP
          v_gipi_quote_mn.vessel_name := rec1.vessel_name;
        END LOOP;
          
        FOR rec2 IN(select cargo_type, cargo_type_desc 
                 from giis_cargo_type 
                 where cargo_type = i.cargo_type)
        LOOP
          v_gipi_quote_mn.cargo_type_desc := rec2.cargo_type_desc;
        END LOOP;
         
        FOR q IN (SELECT rv_meaning
                            FROM cg_ref_codes
                             WHERE rv_domain = 'GIPI_WCARGO.PRINT_TAG'
                             AND rv_low_value = to_char(i.print_tag))
        LOOP
          v_gipi_quote_mn.print_tag_desc := q.rv_meaning;
        END LOOP;
               
        FOR s IN (SELECT cargo_class_desc  
                  FROM giis_cargo_class
                             WHERE cargo_class_cd = i.cargo_class_cd)
        LOOP
            v_gipi_quote_mn.cargo_class_desc := s.cargo_class_desc;
        END LOOP;
        
	 PIPE ROW (v_gipi_quote_mn);
    END LOOP;
	RETURN;  
  END get_gipi_quote_mn2;
  
END Gipi_Quote_Item_Dtls;
/


