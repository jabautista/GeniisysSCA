DROP PROCEDURE CPI.VALIDATE_PERIL_NAME;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_PERIL_NAME(p_par_id    IN GIPI_PARLIST.par_id%TYPE,
	   	  		  								p_item_no	IN GIPI_WITEM.item_no%TYPE,
												p_peril_cd	IN GIIS_PERIL.peril_cd%TYPE,
												p_prem_amt	IN GIPI_WITMPERL.prem_amt%TYPE,
												p_comp_rem  IN GIPI_WITMPERL.comp_rem%TYPE,
												v_prem_rt      OUT GIPI_WITMPERL.prem_rt%TYPE,
											    v_tsi_amt      OUT GIPI_WITMPERL.tsi_amt%TYPE,
											    v_prem_amt     OUT GIPI_WITMPERL.prem_amt%TYPE,
											    v_ann_tsi_amt  OUT GIPI_WITMPERL.ann_tsi_amt%TYPE,
											    v_ann_prem_amt OUT GIPI_WITMPERL.ann_prem_amt%TYPE,
												p_ri_comm_rate OUT GIPI_WITMPERL.ri_comm_rate%TYPE,
												p_ri_comm_amt  OUT GIPI_WITMPERL.ri_comm_amt%TYPE) 
  IS
--BEGIN
--IF variables.v_perilcd_sw = 2 THEN --added by gmi
/* CGFK$CLR_DEPS_OVF */
/* Clear dependent items, if this item is null. */
--DECLARE
  p_line    	    GIIS_LINE.line_cd%TYPE;
  p_subline 		GIPI_WITEM.pack_subline_cd%TYPE;
  v_iss_cd			GIPI_PARLIST.iss_cd%TYPE;
  v_pack_pol_flag	GIIS_LINE.pack_pol_flag%TYPE;
  v_line_cd			GIPI_PARLIST.line_cd%TYPE;
  v_subline_cd		GIPI_WPOLBAS.subline_cd%TYPE;
  v_pack_line_cd	GIPI_WITEM.pack_line_cd%TYPE;
  v_pack_subline_cd	GIPI_WITEM.pack_subline_cd%TYPE;
  v_iss_cd_ri		GIIS_PARAMETERS.param_value_v%TYPE;
  v_param_name1		GIIS_PARAMETERS.param_value_v%TYPE;
  sho_lov   		BOOLEAN;
  
BEGIN
  v_prem_rt      := 0;
  v_tsi_amt      := 0;
  v_prem_amt     := 0;
  v_ann_tsi_amt  := 0;
  v_ann_prem_amt := 0;
  p_ri_comm_rate := 0;
  p_ri_comm_amt  := 0;
  BEGIN
    SELECT pack_pol_flag, line_cd, subline_cd, iss_cd
	  INTO v_pack_pol_flag, v_line_cd, v_subline_cd, v_iss_cd
	  FROM TABLE(GIPI_PARLIST_PKG.get_gipi_parlist(p_par_id));
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;
  
  BEGIN
    SELECT pack_line_cd, pack_subline_cd
	  INTO v_pack_line_cd, v_pack_subline_cd
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id
	   AND item_no = p_item_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;
  
  IF v_pack_pol_flag = 'Y' THEN
       p_line    := v_pack_line_cd;
       p_subline := v_pack_subline_cd;
  ELSE
       p_line    := v_line_cd;
       p_subline := v_subline_cd;
  END IF;
  
  BEGIN
    SELECT param_value_v
      INTO v_iss_cd_ri
      FROM giis_parameters
     WHERE param_name = 'ISS_CD_RI';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;
  
  BEGIN
    SELECT param_name  
	  INTO v_param_name1
	  FROM giis_parameters
     WHERE param_value_v = 'RI'
       AND param_name    = v_iss_cd;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  IF (v_param_name1 = v_iss_cd_ri) THEN 
    DECLARE
    CURSOR a IS 
          SELECT   ri_comm_rt
            FROM   giis_peril
           WHERE   line_cd  =  p_line
             AND   peril_cd =  p_peril_cd;
	  BEGIN
	     OPEN A;
	    FETCH A
	     INTO p_ri_comm_rate;
	     IF sql%found THEN
	        p_ri_comm_amt  :=  (NVL(p_ri_comm_rate,0) * NVL(p_prem_amt,0)) / 100;
	     END IF;
	    CLOSE A;
	  END;
  END IF;

--BETH 101598 upon changing to new peril do the neccesarry changes
--            that is setting prem_amt  to null

/*IF :system.record_status  not in ('NEW','QUERY') and
   :control.nbt_perl_cd is not null and
   :control.nbt_perl_cd != :b490.peril_cd then
   :parameter.commit_sw := 'Y';  --BETH enable deletion of records in bill and distribution table
   :b490.nbt_prem_amt     :=  :b490.prem_amt;
   :b490.nbt_prem_rt      :=  :b490.prem_rt;
   :b490.nbt_tsi_amt      :=  :b490.tsi_amt;
   :b490.prem_rt          :=  NULL;
   :b490.tsi_amt          :=  NULL;
   :b490.prem_amt    	  :=  NULL;
   :parameter.validate_sw :=  'Y';
    compute_tsi(:b490.tsi_amt,:b490.prem_rt,:b490.ann_tsi_amt,:b490.ann_prem_amt,
                  :b480.tsi_amt,:b480.prem_amt,:b480.ann_tsi_amt,
                  :b480.ann_prem_amt,:b240.prov_prem_pct,:b240.prov_prem_tag);
   :parameter.validate_sw :=  'N';
   :b490.nbt_tsi_amt      :=  NULL;
END IF;*/


  /*IF ((:b490.dum_peril_cd)!=(p_peril_cd)) THEN 
    --deletion_process;
    v_prem_rt     :=  0;
    v_tsi_amt     :=  0;
    v_prem_amt    :=  0;
    v_ann_tsi_amt :=  0;
    v_ann_prem_amt:=  0;
  END IF;*/
  
  IF NVL(v_tsi_amt, 0)  = 0 AND
     NVL(v_prem_amt, 0) = 0 AND
     v_iss_cd != v_iss_cd_ri AND   --BETH 020399
     p_comp_rem IS NULL     THEN
     FOR c1 IN (SELECT a.tarf_rate
                  FROM gipi_wfireitm B370, giis_tariff a
                 WHERE a.tarf_cd    = B370.tarf_cd
                   AND B370.item_no = p_item_no
                   AND B370.par_id  = p_par_id)
     LOOP
       v_prem_rt := NVL(c1.tarf_rate, 0);
/* BETH 102198 Prem rt will only be bypass if it is greater than 0 */
       --IF :b490.prem_rt > 0 THEN
          --SET_ITEM_PROPERTY('b490.dsp_peril_name', NEXT_NAVIGATION_ITEM, 'TSI_AMT');
       --END IF;
       EXIT;
     END LOOP;
  END IF;
  IF NVL(v_tsi_amt, 0)  = 0 AND
     NVL(v_prem_amt, 0) = 0 AND
     NVL(v_prem_rt,0) = 0  AND 
     v_iss_cd != v_iss_cd_ri AND   --BETH 020399
     p_comp_rem IS NULL     THEN
     FOR c1 IN (SELECT a.default_rate
                  FROM giis_peril a
                 WHERE NVL(default_tag , 'N') = 'Y'
                   AND peril_cd = p_peril_cd
                   AND line_cd = v_line_cd )
     LOOP
       v_prem_rt := NVL(c1.default_rate, 0);
/* BETH 102198 Prem rt will only be bypass if it is greater than 0 */
       --IF :b490.prem_rt > 0 THEN
          --SET_ITEM_PROPERTY('b490.dsp_peril_name', NEXT_NAVIGATION_ITEM, 'TSI_AMT');
       --END IF;
       EXIT;
     END LOOP;
  END IF;


  
  /*--BETH For automatic population of warranties 
   DECLARE
     alert_id              ALERT;
     alert_but             NUMBER;
   BEGIN
   --IF :system.record_status IN('INSERT','CHANGED') THEN	
	   FOR A IN (SELECT '1'
	               FROM giis_peril_clauses a
	              WHERE a.line_cd  = v_line_cd
	                AND a.peril_cd = p_peril_cd
	                AND NOT EXISTS (SELECT '1'
	                                  FROM gipi_wpolwc b
	                                 WHERE par_id = p_par_id
	                                   AND b.line_cd = a.line_cd
	                                   AND b.wc_cd   = a.main_wc_cd))
	   LOOP
	     alert_id   := FIND_ALERT('WC_ALERT');
	     alert_but  := SHOW_ALERT(ALERT_ID);
	     IF alert_but = ALERT_BUTTON1 THEN    	                                 
	        :b490.wc_sw := 'Y';
	     END IF;
	     EXIT;
	   END LOOP;  
	 --END IF;
   END;*/
                
/* beth  081898 
** if line cd is MC and peril_cd is CTPL assign default TSI amount
** this amount will be derived from giis_parameters(ctpl_peril_tsi)
*/  
/* Loth 053199
** Do not assign a default TSI amount if the issuing source is RI 
*/
/* IF :B240.iss_cd != variables.iss_cd_ri THEN
   IF :B490.LINE_CD = variables.line_motor AND :B490.PERIL_CD = variables.ctpl_cd
       and (:B490.tsi_amt is null OR :B490.tsi_amt = 0)
       and :system.record_status != 'QUERY' THEN
      BEGIN
           SELECT param_value_n
             INTO :B490.tsi_amt
             FROM giis_parameters
            WHERE param_name = 'CTPL_PERIL_TSI';
     :b490.nbt_tsi_amt := 0;
     :b490.nbt_prem_rt := 0;
     :b490.nbt_prem_amt := 0;
     --beth 01-25-2000 compute for the amounts
     compute_tsi(:b490.tsi_amt,:b490.prem_rt,:b490.ann_tsi_amt,:b490.ann_prem_amt,
                 :b480.tsi_amt,:b480.prem_amt,:b480.ann_tsi_amt,
                 :b480.ann_prem_amt,:b240.prov_prem_pct,:b240.prov_prem_tag);
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
                MSG_ALERT('No TSI Amount in Giis_Parameters','I', false);
                RAISE FORM_TRIGGER_FAILURE;    
           WHEN TOO_MANY_ROWS THEN
                MSG_ALERT('Too Many TSI Amount in Giis_Parameters','I', false);
                RAISE FORM_TRIGGER_FAILURE;
     END;
   END IF;
 END IF;     
END;*/
--END IF;
--ramon, january 31, 2008
--check to see if the PAR has an existing deductible with deductible type = 'T'  
--VALIDATE_DED;
END VALIDATE_PERIL_NAME;
/


