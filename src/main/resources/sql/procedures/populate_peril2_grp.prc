CREATE OR REPLACE PROCEDURE CPI.POPULATE_PERIL2_GRP (
    v_item_no           NUMBER,
    v_grouped_item_no   NUMBER,
    p_old_pol_id        gipi_pack_polbasic.pack_policy_id%TYPE,
    p_new_par_id        gipi_wopen_policy.par_id%TYPE
) 
IS
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  item_exist         VARCHAR2(1) := 'N'; 
  v_row              NUMBER;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  v_peril_cd         gipi_witmperl_grouped.peril_cd%TYPE;
  v_line_cd          gipi_witmperl_grouped.line_cd%TYPE;  
  v_prem_rt          gipi_witmperl_grouped.prem_rt%TYPE;
  v_tsi_amt          gipi_witmperl_grouped.tsi_amt%TYPE;
  v_prem_amt         gipi_witmperl_grouped.prem_amt%TYPE;  
  
    v_no_of_days       gipi_witmperl_grouped.no_of_days%TYPE;  
    v_ann_tsi_amt      gipi_witmperl_grouped.ann_tsi_amt%TYPE;  
    v_ann_prem_amt     gipi_witmperl_grouped.ann_prem_amt%TYPE;  
    v_aggregate_sw     gipi_witmperl_grouped.aggregate_sw%TYPE;  
    v_base_amt         gipi_witmperl_grouped.base_amt%TYPE;  
    v_ri_comm_rate     gipi_witmperl_grouped.ri_comm_rate%TYPE; 
    v_ri_comm_amt      gipi_witmperl_grouped.ri_comm_amt%TYPE;
    
  expire_sw          VARCHAR2(1) := 'N';
  perl_exist         VARCHAR2(1) := 'N';
  v_dep_pct          NUMBER(3,2) := Giisp.n('MC_DEP_PCT')/100;
  v_auto_comp_dep    giis_parameters.param_value_v%TYPE := Giisp.v('AUTO_COMPUTE_MC_DEP');
  v_round_off        giis_parameters.param_value_n%TYPE; -- added by: Nica 1.18.2014
  
BEGIN  
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_PERIL2_GRP program unit 
  */      
    /** get data from giex_itmperil else from gipi_itmperil **/
  
  IF NVL(v_auto_comp_dep, 'N') = 'Y' THEN
	  	  BEGIN
			SELECT DECODE (param_value_n,
						 10, -1,
						 100, -2,
						 1000, -3,
						 10000, -4,
						 100000, -5,
						 1000000, -6,
						 9
						)
				INTO v_round_off
				FROM giis_parameters
			   WHERE param_name = 'ROUND_OFF_PLACE';
		  EXCEPTION
			  WHEN NO_DATA_FOUND
			  THEN
				 v_round_off := 9;
		  END; -- added by: Nica 01.18.2014
	END IF;
	
  FOR PERIL IN (
    SELECT peril_cd, line_cd
      FROM giex_itmperil_grouped
     WHERE item_no   = v_item_no
       AND grouped_item_no   = v_grouped_item_no
       AND policy_id = p_old_pol_id)
  LOOP  
    IF item_exist = 'N' THEN                 
       expire_sw := 'N';
       FOR EX IN (
         SELECT ann_prem_amt prem_amt,      tsi_amt,
                prem_rt,       
                NVL(ann_tsi_amt, tsi_amt) ann_tsi_amt,
                NVL(ann_prem_amt, prem_amt) ann_prem_amt,
                no_of_days,
                aggregate_sw,       
                base_amt,
                ri_comm_rate, 
                ri_comm_amt
           FROM giex_itmperil_grouped
          WHERE item_no   = v_item_no
            AND grouped_item_no   = v_grouped_item_no
            AND peril_cd  = peril.peril_cd
            AND policy_id = p_old_pol_id)
       LOOP
         v_peril_cd         := peril.peril_cd;
         v_line_cd          := peril.line_cd;
         v_prem_amt         := ex.prem_amt;
         v_tsi_amt          := ex.tsi_amt;
         v_ann_prem_amt     := ex.ann_prem_amt;
         v_ann_tsi_amt      := ex.ann_tsi_amt;         
         v_prem_rt          := ex.prem_rt;
         
         v_no_of_days       := ex.no_of_days;         
         v_aggregate_sw     := ex.aggregate_sw;
         v_base_amt         := ex.base_amt;                    
         v_ri_comm_rate     := ex.ri_comm_rate;            
         v_ri_comm_amt      := ex.ri_comm_amt;
         expire_sw          := 'Y';
       END LOOP;
       /** tsi already depreciated if exists in giex_itemperil **/
       IF NVL(v_tsi_amt,0) > 0  THEN
          --CLEAR_MESSAGE;
          --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
          --SYNCHRONIZE;    
              INSERT INTO gipi_witmperl_grouped (
                      par_id,             item_no,          grouped_item_no, 
                      line_cd,            peril_cd,         rec_flag, 
                      no_of_days,         prem_rt,          tsi_amt, 
                      prem_amt,           ann_tsi_amt,      ann_prem_amt, 
                      aggregate_sw,       base_amt,         ri_comm_rate, 
                      ri_comm_amt)
             VALUES(p_new_par_id, v_item_no,        v_grouped_item_no, 
                      v_line_cd,          v_peril_cd,       'A', 
                      v_no_of_days,       v_prem_rt,        v_tsi_amt, 
                      v_prem_amt,         v_ann_tsi_amt,    v_ann_prem_amt, 
                      v_aggregate_sw,     v_base_amt,       v_ri_comm_rate, 
                      v_ri_comm_amt);
          v_peril_cd := NULL;
          v_line_cd  := NULL;
          v_prem_amt := NULL;
          v_tsi_amt  := NULL;              
          v_prem_rt  := NULL;
          
          v_no_of_days    := NULL;
          v_ann_tsi_amt   := NULL;
          v_ann_prem_amt  := NULL;
          v_aggregate_sw  := NULL;
          v_base_amt      := NULL;
          v_ri_comm_rate  := NULL;
          v_ri_comm_amt   := NULL;
       END IF;                     
    END IF;                        
  END LOOP;
  item_exist := 'Y';  
  FOR DATA IN (
    SELECT peril_cd,      ann_prem_amt prem_amt,        tsi_amt,
           prem_rt,       line_cd,           
           NVL(ann_tsi_amt, tsi_amt) ann_tsi_amt,
           NVL(ann_prem_amt, prem_amt) ann_prem_amt,
           no_of_days,
           aggregate_sw,       
           base_amt,
           ri_comm_rate, 
           ri_comm_amt
      FROM gipi_itmperil_grouped
     WHERE item_no   = v_item_no
       AND grouped_item_no   = v_grouped_item_no
       AND policy_id = p_old_pol_id) 
  LOOP
    IF expire_sw = 'N' THEN 
       perl_exist         := 'N';
       v_peril_cd         := data.peril_cd;
       v_line_cd          := data.line_cd;
       v_prem_amt         := data.prem_amt;
       v_tsi_amt          := data.tsi_amt;
       v_ann_prem_amt     := data.ann_prem_amt;
       v_ann_tsi_amt      := data.ann_tsi_amt;       
       v_prem_rt          := data.prem_rt;       
       v_no_of_days       := data.no_of_days;
       v_aggregate_sw     := data.aggregate_sw;
       v_base_amt         := data.base_amt;                    
       v_ri_comm_rate     := data.ri_comm_rate;            
       v_ri_comm_amt      := data.ri_comm_amt;          
    END IF;
    IF NVL(v_tsi_amt,0) > 0  THEN
       --CLEAR_MESSAGE;
       --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
       --SYNCHRONIZE;    
       FOR perl IN (
         SELECT 1
             FROM gipi_witmperl_grouped
            WHERE item_no  = v_item_no
                AND grouped_item_no   = v_grouped_item_no
              AND peril_cd = v_peril_cd
              AND par_id   = p_new_par_id)
         LOOP    
           perl_exist := 'Y';
           EXIT;
         END LOOP;
       
       /*FOR a IN (
            SELECT '1'                
                     FROM giex_dep_perl b
                    WHERE b.line_cd  = v_line_cd
                      AND b.peril_cd = v_peril_cd
                      AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
                      --AND b.line_cd = Giisp.v('LINE_CODE_MC'))
             LOOP            
                 v_tsi_amt      := v_tsi_amt - (v_tsi_amt*v_dep_pct);
                 v_ann_tsi_amt  := v_tsi_amt;                 
             END LOOP;*/
         
         /*FOR a IN (SELECT NVL (rate, 0) rate
				  FROM giex_dep_perl
				 WHERE line_cd = v_line_cd
				   AND peril_cd = v_peril_cd
				   AND NVL(v_auto_comp_dep, 'N') = 'Y')
		 LOOP
			IF a.rate <> 0 THEN 
				 v_tsi_amt :=
					ROUND ((  v_tsi_amt
							- (v_tsi_amt * (a.rate / 100))
						   ),
						   v_round_off
						  );
			     v_ann_tsi_amt  := v_tsi_amt;
			END IF;          
		 END LOOP;*/ --benjo 11.23.2016 SR-5621 comment out
         
       compute_depreciation_amounts (p_old_pol_id, v_item_no, v_line_cd, v_peril_cd, v_tsi_amt); --benjo 11.23.2016 SR-5621
             
             v_prem_amt     := ROUND((v_tsi_amt * (v_prem_rt/100)),2);
             v_ann_prem_amt := v_prem_amt;          
       IF perl_exist = 'N' THEN
             INSERT INTO gipi_witmperl_grouped (
                      par_id,             item_no,          grouped_item_no, 
                      line_cd,            peril_cd,         rec_flag, 
                      no_of_days,         prem_rt,          tsi_amt, 
                      prem_amt,           ann_tsi_amt,      ann_prem_amt, 
                      aggregate_sw,       base_amt,         ri_comm_rate, 
                      ri_comm_amt)
             VALUES(p_new_par_id, v_item_no,        v_grouped_item_no, 
                      v_line_cd,          v_peril_cd,       'A', 
                      v_no_of_days,       v_prem_rt,        v_tsi_amt, 
                      v_prem_amt,         v_ann_tsi_amt,    v_ann_prem_amt, 
                      v_aggregate_sw,     v_base_amt,       v_ri_comm_rate, 
                      v_ri_comm_amt);
       END IF;
       v_peril_cd             := NULL;
       v_line_cd              := NULL;
       v_prem_amt             := NULL;
       v_tsi_amt              := NULL;              
       v_prem_rt              := NULL;
       v_no_of_days           := NULL;
       v_ann_tsi_amt          := NULL;
       v_ann_prem_amt         := NULL;
       v_aggregate_sw         := NULL;
       v_base_amt             := NULL;
       v_ri_comm_rate         := NULL;
       v_ri_comm_amt          := NULL;
    END IF;                     
  END LOOP;    
END;
/


