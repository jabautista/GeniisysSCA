CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_recovery_pkg
AS
    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  12.13.2010 
    **  Reference By : GICLS250 - Claims Listing Per Policy
    **  Description :  getting recovery details 
    */
    FUNCTION get_gicl_clm_recovery(
        p_claim_id          gicl_clm_recovery.claim_id%TYPE,
        p_recovery_id       gicl_clm_recovery.recovery_id%TYPE
        )
    RETURN gicl_clm_recovery_tab PIPELINED IS
      v_list            gicl_clm_recovery_type;
    BEGIN
        FOR i IN (SELECT a.recovery_id, a.claim_id, a.line_cd,        
                         a.rec_year, a.rec_seq_no, a.rec_type_cd,         
                         a.recoverable_amt, a.recovered_amt, a.tp_item_desc,        
                         a.plate_no, a.currency_cd, a.convert_rate,        
                         a.lawyer_class_cd, a.lawyer_cd, a.cpi_rec_no,          
                         a.cpi_branch_cd, a.user_id, a.last_update, 
                         a.cancel_tag, a.iss_cd, a.rec_file_date,
                         a.demand_letter_date, a.demand_letter_date2, a.demand_letter_date3, 
                         a.tp_driver_name, a.tp_drvr_add, a.tp_plate_no,         
                         a.case_no, a.court
                    FROM gicl_clm_recovery a   
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = NVL(p_recovery_id, a.recovery_id)
                   ORDER BY line_cd,  rec_year, rec_seq_no)
        LOOP
            v_list.recovery_id                 := i.recovery_id;
            v_list.claim_id                    := i.claim_id;
            v_list.line_cd                     := i.line_cd;
            v_list.rec_year                    := i.rec_year;
            v_list.rec_seq_no                  := i.rec_seq_no;
            v_list.rec_type_cd                 := i.rec_type_cd;
            v_list.recoverable_amt             := i.recoverable_amt;
            v_list.recovered_amt               := i.recovered_amt;
            v_list.tp_item_desc                := i.tp_item_desc;
            v_list.plate_no                    := i.plate_no;
            v_list.currency_cd                 := i.currency_cd;
            v_list.convert_rate                := i.convert_rate;
            v_list.lawyer_class_cd             := i.lawyer_class_cd;
            v_list.lawyer_cd                   := i.lawyer_cd;
            v_list.cpi_rec_no                  := i.cpi_rec_no;
            v_list.cpi_branch_cd               := i.cpi_branch_cd;
            v_list.user_id                     := i.user_id;
            v_list.last_update                 := i.last_update;
            v_list.cancel_tag                  := i.cancel_tag;
            v_list.iss_cd                      := i.iss_cd;
            v_list.rec_file_date               := i.rec_file_date;
            v_list.demand_letter_date          := i.demand_letter_date;
            v_list.demand_letter_date2         := i.demand_letter_date2;
            v_list.demand_letter_date3         := i.demand_letter_date3;
            v_list.tp_driver_name              := i.tp_driver_name;
            v_list.tp_drvr_add                 := i.tp_drvr_add;
            v_list.tp_plate_no                 := i.tp_plate_no;
            v_list.case_no                     := i.case_no;
            v_list.court                       := i.court;
            
            BEGIN
              SELECT payee_first_name||' '||
                     payee_middle_name ||' '||payee_last_name
                INTO v_list.dsp_lawyer_name
                FROM giis_payees
               WHERE payee_no = i.lawyer_cd
                 AND payee_class_cd = i.lawyer_class_cd;
            EXCEPTION
              WHEN OTHERS THEN
                v_list.dsp_lawyer_name := NULL;    
            END;

            IF i.cancel_tag IS NULL THEN
              v_list.dsp_rec_stat_desc := 'IN PROGRESS';
            ELSIF i.cancel_tag = 'CD' THEN
              v_list.dsp_rec_stat_desc := 'CLOSED';
            ELSIF i.cancel_tag = 'CC' THEN
              v_list.dsp_rec_stat_desc := 'CANCELLED';
            ELSIF i.cancel_tag = 'WO' THEN
              v_list.dsp_rec_stat_desc := 'WRITTEN OFF';
            END IF;	

            PIPE ROW(v_list);
        END LOOP;          
      RETURN;      
    END;       

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.08.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  
    */
    PROCEDURE populate_module_variables(
        v_closed_cd         OUT giis_parameters.param_value_v%TYPE,
        v_cancel_cd         OUT giis_parameters.param_value_v%TYPE,
        v_writeoff_cd       OUT giis_parameters.param_value_v%TYPE,
        v_reopen_cd         OUT giis_parameters.param_value_v%TYPE,
        v_msg_alert         OUT VARCHAR2
        ) IS
    BEGIN
      v_msg_alert := NULL; 
    
      BEGIN
        SELECT param_value_v
          INTO v_closed_cd 
          FROM giis_parameters
         WHERE param_name = 'CLOSE_REC_STAT';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_msg_alert := 'No record found in giis_paramaters for CLOSE_REC_STAT parameter.';
          RETURN;
        WHEN TOO_MANY_ROWS THEN
          v_msg_alert := 'Too many records found in giis_paramaters for CLOSE_REC_STAT parameter.';
          RETURN;    	
      END;
      BEGIN
        SELECT param_value_v
          INTO v_cancel_cd 
          FROM giis_parameters
         WHERE param_name = 'CANCEL_REC_STAT';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_msg_alert := 'No record found in giis_paramaters for CANCEL_REC_STAT parameter.';
          RETURN;
        WHEN TOO_MANY_ROWS THEN
          v_msg_alert := 'Too many records found in giis_paramaters for CANCEL_REC_STAT parameter.';
          RETURN;    	
      END;
      BEGIN
        SELECT param_value_v
          INTO v_writeoff_cd 
          FROM giis_parameters
         WHERE param_name = 'WRITE_OFF_REC_STAT';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_msg_alert := 'No record found in giis_paramaters for WRITE_OFF_REC_STAT parameter.';
          RETURN;
        WHEN TOO_MANY_ROWS THEN
          v_msg_alert := 'Too many records found in giis_paramaters for WRITE_OFF_REC_STAT parameter.';
          RETURN;    	
      END;
      --glyza 09.29.08
      BEGIN
        SELECT param_value_v
          INTO v_reopen_cd 
          FROM giis_parameters
         WHERE param_name = 'REOPEN_REC_STAT';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_msg_alert := 'No record found in giis_paramaters for REOPEN_REC_STAT parameter.';
          RETURN;
        WHEN TOO_MANY_ROWS THEN
          v_msg_alert := 'Too many records found in giis_paramaters for REOPEN_REC_STAT parameter.';
          RETURN;    	
      END;
    END;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.08.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  getting recovery details 
    */
    FUNCTION get_gicl_clm_recovery(
        p_claim_id          gicl_clm_recovery.claim_id%TYPE
        )
    RETURN gicl_clm_recovery_tab PIPELINED IS
      v_list            gicl_clm_recovery_type;
      v_closed_cd       giis_parameters.param_value_v%TYPE;
      v_cancel_cd       giis_parameters.param_value_v%TYPE;
      v_writeoff_cd     giis_parameters.param_value_v%TYPE;
      v_reopen_cd       giis_parameters.param_value_v%TYPE;
      v_msg_alert       VARCHAR2(32000) := NULL;
	  v_plate_num		gicl_motor_car_dtl.plate_no%type;
	  
    BEGIN
        FOR i IN (SELECT a.recovery_id, a.claim_id, a.line_cd,        
                         a.rec_year, a.rec_seq_no, a.rec_type_cd,         
                         a.recoverable_amt, a.recovered_amt, a.tp_item_desc,        
                         a.plate_no, a.currency_cd, a.convert_rate,        
                         a.lawyer_class_cd, a.lawyer_cd, a.cpi_rec_no,          
                         a.cpi_branch_cd, a.user_id, a.last_update, 
                         a.cancel_tag, a.iss_cd, a.rec_file_date,
                         a.demand_letter_date, a.demand_letter_date2, a.demand_letter_date3, 
                         a.tp_driver_name, a.tp_drvr_add, a.tp_plate_no,         
                         a.case_no, a.court
                    FROM gicl_clm_recovery a   
                   WHERE a.claim_id = p_claim_id
                     AND a.cancel_tag IS NULL
                   ORDER BY line_cd,  rec_year, rec_seq_no)
        LOOP
            v_list.recovery_id                 := i.recovery_id;
            v_list.claim_id                    := i.claim_id;
            v_list.line_cd                     := i.line_cd;
            v_list.rec_year                    := i.rec_year;
            v_list.rec_seq_no                  := i.rec_seq_no;
            v_list.rec_type_cd                 := i.rec_type_cd;
            v_list.recoverable_amt             := i.recoverable_amt;
            v_list.recovered_amt               := i.recovered_amt;
            v_list.tp_item_desc                := i.tp_item_desc;
            v_list.plate_no                    := i.plate_no;
            v_list.currency_cd                 := i.currency_cd;
            v_list.convert_rate                := i.convert_rate;
            v_list.lawyer_class_cd             := i.lawyer_class_cd;
            v_list.lawyer_cd                   := i.lawyer_cd;
            v_list.cpi_rec_no                  := i.cpi_rec_no;
            v_list.cpi_branch_cd               := i.cpi_branch_cd;
            v_list.user_id                     := i.user_id;
            v_list.last_update                 := i.last_update;
            v_list.cancel_tag                  := i.cancel_tag;
            v_list.iss_cd                      := i.iss_cd;
            v_list.rec_file_date               := i.rec_file_date;
            v_list.demand_letter_date          := i.demand_letter_date;
            v_list.demand_letter_date2         := i.demand_letter_date2;
            v_list.demand_letter_date3         := i.demand_letter_date3;
            v_list.tp_driver_name              := i.tp_driver_name;
            v_list.tp_drvr_add                 := i.tp_drvr_add;
            v_list.tp_plate_no                 := i.tp_plate_no;
            v_list.case_no                     := i.case_no;
            v_list.court                       := i.court;
			
			-- added by: Nica 08.16.2012 to retrieved plate number from  
			-- GICL_MOTOR_CAR_DTL if plate_no from gicl_clm_recovery is null
			
            v_plate_num := NULL;
			
			FOR y IN (SELECT plate_no 
	   				    FROM gicl_motor_car_dtl
	  		  		  WHERE claim_id = p_claim_id)
			  LOOP
				v_plate_num := y.plate_no;
				EXIT;
			  END LOOP;
			
			IF v_plate_num IS NOT NULL AND i.plate_no IS NULL THEN
				v_list.plate_no := v_plate_num;
			END IF;
			-- end here
            
            BEGIN
              SELECT rec_type_desc
                INTO v_list.dsp_rec_type_desc
                FROM giis_recovery_type
               WHERE rec_type_cd = i.rec_type_cd;
            EXCEPTION
            WHEN OTHERS THEN
              v_list.dsp_rec_type_desc := NULL;
            END;
            
            BEGIN
              SELECT payee_last_name||', '||payee_first_name||' '||
                     payee_middle_name 
                INTO v_list.dsp_lawyer_name
                FROM giis_payees
               WHERE payee_no = i.lawyer_cd
                 AND payee_class_cd = i.lawyer_class_cd;
            EXCEPTION
              WHEN OTHERS THEN
                v_list.dsp_lawyer_name := NULL;    
            END;

            BEGIN
              SELECT currency_desc 
                INTO v_list.dsp_currency_desc
                FROM giis_currency
               WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
              WHEN OTHERS THEN
                v_list.dsp_currency_desc := NULL;
            END;

            gicl_clm_recovery_pkg.populate_module_variables(
                    v_closed_cd,
                    v_cancel_cd,
                    v_writeoff_cd,
                    v_reopen_cd,
                    v_msg_alert
                    );
            v_list.msg_alert := v_msg_alert;
            
            -- check first if recovery already has valid payments
            v_list.dsp_check_valid := NULL;
            FOR valid_payt IN (SELECT '1'
                                 FROM gicl_recovery_payt
                                WHERE claim_id = p_claim_id
                                  AND recovery_id = i.recovery_id
                                  AND NVL(cancel_tag ,'N') = 'N') 
            LOOP
              v_list.dsp_check_valid := '1';
              EXIT;
            END LOOP;
            
            -- check first if recovery already has valid payments
            v_list.dsp_check_all := NULL;
            FOR all_payt IN (SELECT '1'
                               FROM gicl_recovery_payt
                              WHERE claim_id = p_claim_id
                                AND recovery_id = i.recovery_id)
            LOOP
              v_list.dsp_check_all := '1';
              EXIT;
            END LOOP;            
            
            IF i.cancel_tag IS NULL THEN 
              BEGIN
                 SELECT UPPER(rec_stat_desc)
                 INTO v_list.dsp_rec_stat_desc
                 FROM giis_recovery_status a
                    WHERE EXISTS (SELECT 1
                                    FROM gicl_rec_hist
                                   WHERE recovery_id = i.recovery_id
                                     AND rec_stat_cd = a.rec_stat_cd
                                     AND rec_hist_no = (SELECT MAX(rec_hist_no)
                                                          FROM gicl_rec_hist 
                                                         WHERE recovery_id = i.recovery_id));
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   v_list.dsp_rec_stat_desc := 'IN PROGRESS';
              END; 
            ELSIF i.cancel_tag = v_closed_cd THEN
              v_list.dsp_rec_stat_desc := 'CLOSED';
            ELSIF i.cancel_tag = v_cancel_cd THEN
              v_list.dsp_rec_stat_desc := 'CANCELLED';
            ELSIF i.cancel_tag = v_writeoff_cd THEN
              v_list.dsp_rec_stat_desc := 'WRITTEN OFF';
            END IF;
            
            PIPE ROW(v_list);
        END LOOP;          
      RETURN;      
    END;   

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.21.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  gen_rec_seq_no program unit 
    */
    FUNCTION gen_rec_seq_no(
        p_line_cd IN gicl_clm_recovery.line_cd%TYPE,
        p_rec_year IN gicl_clm_recovery.rec_year%TYPE,
        p_iss_cd IN gicl_clm_recovery.iss_cd%TYPE
        ) 
    RETURN NUMBER IS
      v_rec_seq_no    gicl_clm_recovery.rec_seq_no%TYPE default 0;
    BEGIN
      BEGIN 
        SELECT NVL (MAX (rec_seq_no), 0) + 1
          INTO v_rec_seq_no
          FROM gicl_clm_recovery
         WHERE rec_year = p_rec_year 
           AND line_cd = p_line_cd 
           AND iss_cd = p_iss_cd; 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_rec_seq_no := 1;
      END;
      RETURN v_rec_seq_no; 
    END;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.21.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  gen_rec_id program unit 
    */
    FUNCTION gen_rec_id RETURN NUMBER IS
      v_rec_id    gicl_clm_recovery.recovery_id%TYPE;
    BEGIN
      BEGIN  
        FOR REC in (SELECT clm_recovery_id_s.NEXTVAL recovery_id
                      FROM DUAL)  
        LOOP
          v_rec_id := REC.recovery_id;
          FOR ID in (SELECT '1'
                       FROM gicl_clm_recovery
                      WHERE recovery_id = v_rec_id)
          LOOP
            v_rec_id := NULL;
          END LOOP; 
          IF v_rec_id IS NOT NULL THEN
            EXIT;
          END IF;
        END LOOP;     
        RETURN v_rec_id;
      END;
    RETURN NULL; 
    END;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.21.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  gen_rec_hist_no program unit 
    */
    FUNCTION gen_rec_hist_no(p_rec_id IN gicl_rec_hist.recovery_id%TYPE) 
    RETURN NUMBER IS
      v_rec_hist_no   gicl_rec_hist.rec_hist_no%TYPE;
    BEGIN
      BEGIN
        SELECT NVL(MAX(NVL(rec_hist_no,0)),0) + 1
          INTO v_rec_hist_no
          FROM gicl_rec_hist
         WHERE recovery_id = p_rec_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_rec_hist_no := 1;
      END;
      RETURN v_rec_hist_no;
    END;

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.21.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  part of save_recoverable2 program unit 
    */
    PROCEDURE save_recoverable(
        p_line_cd         IN   gicl_clm_recovery.line_cd%TYPE,
        p_iss_cd          IN   gicl_clm_recovery.iss_cd%TYPE,
        p_rec_year        OUT  gicl_clm_recovery.rec_year%TYPE,
        p_rec_seq_no      OUT  gicl_clm_recovery.rec_seq_no%TYPE,
        p_recovery_id     OUT  gicl_clm_recovery.recovery_id%TYPE,
        p_rec_file_date   OUT  gicl_clm_recovery.rec_file_date%TYPE
        ) IS
      v_rec_hist_no  NUMBER;    
    BEGIN
        p_rec_year      := TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'));
        p_rec_seq_no    := gicl_clm_recovery_pkg.gen_rec_seq_no(p_line_cd,p_rec_year,p_iss_cd);
        p_recovery_id   := gicl_clm_recovery_pkg.gen_rec_id;
        p_rec_file_date := SYSDATE; 
        v_rec_hist_no   := gicl_clm_recovery_pkg.gen_rec_hist_no(p_recovery_id);
        
        INSERT INTO GICL_REC_HIST 
				  (recovery_id, rec_hist_no, rec_stat_cd, user_id, last_update)
           VALUES (p_recovery_id, v_rec_hist_no, 'IP', giis_users_pkg.app_user, SYSDATE); --editted by steven 11/26/2012, it causes an ORA-01843: not a valid month; to_char(SYSDATE,'DD-MON-RRRR')
           
    END;    

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.21.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  part of save_recoverable2 program unit 
    */
    PROCEDURE save_recoverable2(
        p_chk_choose            VARCHAR2,
        p_item_no               gicl_clm_recovery_dtl.item_no%TYPE,
        p_peril_cd              gicl_clm_recovery_dtl.peril_cd%TYPE,
        p_nbt_paid_amt          gicl_clm_recovery_dtl.recoverable_amt%TYPE,
        p_clm_loss_id           gicl_clm_recovery_dtl.clm_loss_id%TYPE,
        p_recovery_id           gicl_clm_recovery_dtl.recovery_id%TYPE,
        p_claim_id              gicl_clm_recovery_dtl.claim_id%TYPE,
        p_rec_amt           OUT gicl_clm_recovery_dtl.recoverable_amt%TYPE
        ) IS
      v_exist        VARCHAR2(1) := 'N';
      v_exist1       VARCHAR2(1) := 'N';    
    BEGIN
       IF p_chk_choose = 'Y' THEN
         IF p_recovery_id IS NOT NULL THEN
            FOR rec IN (SELECT '1'
                          FROM gicl_clm_recovery_dtl
                         WHERE recovery_id = p_recovery_id
                           AND claim_id    = p_claim_id
                           AND item_no     = p_item_no
                           AND peril_cd    = p_peril_cd)
            LOOP
              v_exist := 'Y';   
              EXIT;
            END LOOP;
         END IF;
         p_rec_amt := nvl(p_rec_amt,0) + p_nbt_paid_amt;
         IF v_exist = 'N' THEN
            INSERT INTO gicl_clm_recovery_dtl 
                   (recovery_id, 			     claim_id,  		 				clm_loss_id, 
                    item_no,     			     peril_cd,  		 				recoverable_amt, 
                    user_id,     		   		 last_update,						res_type) --added by steven 1/15/2013 "res_type" with the value of "X" as confirmed to mam jen. base on SR 0011279
            VALUES (p_recovery_id, 		         p_claim_id, 				        p_clm_loss_id, 
                    p_item_no,                   p_peril_cd,                        p_nbt_paid_amt, 
                    giis_users_pkg.app_user,     to_date(to_char(SYSDATE,'DD-MON-RRRR'),'DD-MON-RRRR'),		'X'); --editted by steven 11/26/2012, it causes an ORA-01843: not a valid month; to_char(SYSDATE,'DD-MON-RRRR')
         ELSE --v_exist = 'Y'
            /* add update statement to update the value of 
            ** recoverable amout of table gicl_clm_recovery_dtl
            ** glyza 10.06.08
            */
              UPDATE gicl_clm_recovery_dtl
               SET recoverable_amt = p_nbt_paid_amt, 
                   user_id         = giis_users_pkg.app_user, 
                   --last_update     = to_char(SYSDATE,'DD-MON-RRRR') replaced by robert 05.27.2013 sr 13135
				   last_update     = to_date(to_char(SYSDATE,'DD-MON-RRRR'),'DD-MON-RRRR')
             WHERE claim_id    = p_claim_id
               AND recovery_id = p_recovery_id
               AND item_no     = p_item_no
               AND peril_cd    = p_peril_cd;
            v_exist := 'N';
         END IF; --v_exist
       ELSE --chk_choose = 'N'
         FOR rec IN (SELECT '1'
                       FROM gicl_clm_recovery_dtl
                      WHERE recovery_id = p_recovery_id
                        AND claim_id    = p_claim_id
                        AND item_no     = p_item_no
                        AND peril_cd    = p_peril_cd)
         LOOP
           v_exist1 := 'Y';        
           EXIT;
         END LOOP;

         IF v_exist1 = 'Y' THEN
            DELETE 
              FROM gicl_clm_recovery_dtl 
             WHERE recovery_id  = p_recovery_id
               AND claim_id     = p_claim_id
               AND item_no      = p_item_no
               AND peril_cd     = p_peril_cd;
            v_exist1 := 'N';
         END IF;
       END IF;    
    END;    

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.21.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  Insert/Update record on gicl_clm_recovery 
    */
    PROCEDURE set_gicl_clm_recovery(
        p_recovery_id                 gicl_clm_recovery.recovery_id%TYPE,
        p_claim_id                    gicl_clm_recovery.claim_id%TYPE,
        p_line_cd                     gicl_clm_recovery.line_cd%TYPE,
        p_rec_year                    gicl_clm_recovery.rec_year%TYPE,
        p_rec_seq_no                  gicl_clm_recovery.rec_seq_no%TYPE,
        p_rec_type_cd                 gicl_clm_recovery.rec_type_cd%TYPE,
        p_recoverable_amt             gicl_clm_recovery.recoverable_amt%TYPE,
        p_recovered_amt               gicl_clm_recovery.recovered_amt%TYPE,
        p_tp_item_desc                gicl_clm_recovery.tp_item_desc%TYPE,
        p_plate_no                    gicl_clm_recovery.plate_no%TYPE,
        p_currency_cd                 gicl_clm_recovery.currency_cd%TYPE,
        p_convert_rate                gicl_clm_recovery.convert_rate%TYPE,
        p_lawyer_class_cd             gicl_clm_recovery.lawyer_class_cd%TYPE,
        p_lawyer_cd                   gicl_clm_recovery.lawyer_cd%TYPE,
        p_cpi_rec_no                  gicl_clm_recovery.cpi_rec_no%TYPE,
        p_cpi_branch_cd               gicl_clm_recovery.cpi_branch_cd%TYPE,
        p_user_id                     gicl_clm_recovery.user_id%TYPE,
        p_last_update                 gicl_clm_recovery.last_update%TYPE,
        p_cancel_tag                  gicl_clm_recovery.cancel_tag%TYPE,
        p_iss_cd                      gicl_clm_recovery.iss_cd%TYPE,
        p_rec_file_date               gicl_clm_recovery.rec_file_date%TYPE,
        p_demand_letter_date          gicl_clm_recovery.demand_letter_date%TYPE,
        p_demand_letter_date2         gicl_clm_recovery.demand_letter_date2%TYPE,
        p_demand_letter_date3         gicl_clm_recovery.demand_letter_date3%TYPE,
        p_tp_driver_name              gicl_clm_recovery.tp_driver_name%TYPE,
        p_tp_drvr_add                 gicl_clm_recovery.tp_drvr_add%TYPE,
        p_tp_plate_no                 gicl_clm_recovery.tp_plate_no%TYPE,
        p_case_no                     gicl_clm_recovery.case_no%TYPE,
        p_court                       gicl_clm_recovery.court%TYPE
        ) IS
    BEGIN
        MERGE INTO gicl_clm_recovery
             USING DUAL
                ON (claim_id = p_claim_id
               AND  recovery_id = p_recovery_id) 
        WHEN NOT MATCHED THEN
            INSERT (recovery_id, claim_id, line_cd,        
                    rec_year, rec_seq_no, rec_type_cd,         
                    recoverable_amt, recovered_amt, tp_item_desc,        
                    plate_no, currency_cd, convert_rate,        
                    lawyer_class_cd, lawyer_cd, cpi_rec_no,          
                    cpi_branch_cd, user_id, last_update, 
                    cancel_tag, iss_cd, rec_file_date,
                    demand_letter_date, demand_letter_date2, demand_letter_date3, 
                    tp_driver_name, tp_drvr_add, tp_plate_no,         
                    case_no, court)
            VALUES (p_recovery_id, p_claim_id, p_line_cd,        
                    p_rec_year, p_rec_seq_no, p_rec_type_cd,         
                    p_recoverable_amt, p_recovered_amt, p_tp_item_desc,        
                    p_plate_no, p_currency_cd, p_convert_rate,        
                    p_lawyer_class_cd, p_lawyer_cd, p_cpi_rec_no,          
                    p_cpi_branch_cd, giis_users_pkg.app_user, SYSDATE, 
                    p_cancel_tag, p_iss_cd, p_rec_file_date,
                    p_demand_letter_date, p_demand_letter_date2, p_demand_letter_date3, 
                    p_tp_driver_name, p_tp_drvr_add, p_tp_plate_no,         
                    p_case_no, p_court)
        WHEN MATCHED THEN
            UPDATE SET      
                    line_cd                     = p_line_cd,
                    rec_year                    = p_rec_year,
                    rec_seq_no                  = p_rec_seq_no,
                    rec_type_cd                 = p_rec_type_cd,
                    recoverable_amt             = p_recoverable_amt,
                    recovered_amt               = p_recovered_amt,
                    tp_item_desc                = p_tp_item_desc,
                    plate_no                    = p_plate_no,
                    currency_cd                 = p_currency_cd,
                    convert_rate                = p_convert_rate,
                    lawyer_class_cd             = p_lawyer_class_cd,
                    lawyer_cd                   = p_lawyer_cd,
                    cpi_rec_no                  = p_cpi_rec_no,
                    cpi_branch_cd               = p_cpi_branch_cd,
                    user_id                     = giis_users_pkg.app_user,
                    last_update                 = SYSDATE,
                    cancel_tag                  = p_cancel_tag,
                    iss_cd                      = p_iss_cd,
                    rec_file_date               = p_rec_file_date,
                    demand_letter_date          = p_demand_letter_date,
                    demand_letter_date2         = p_demand_letter_date2,
                    demand_letter_date3         = p_demand_letter_date3,
                    tp_driver_name              = p_tp_driver_name,
                    tp_drvr_add                 = p_tp_drvr_add,
                    tp_plate_no                 = p_tp_plate_no,
                    case_no                     = p_case_no,
                    court                       = p_court;
    END;    

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  04.04.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  for validation in write off, close and cancel recovery button 
    */
    PROCEDURE check_recovery_recovered_amt(
        p_claim_id               IN gicl_clm_recovery.claim_id%TYPE,
        p_recovery_id            IN gicl_clm_recovery.recovery_id%TYPE,
        p_count1                OUT NUMBER,
        p_count2                OUT NUMBER,
        p_count3                OUT NUMBER
        ) IS
    BEGIN
        --for write off, close and cancel recovery 
        SELECT COUNT (*) ctr
          INTO p_count1
		  FROM gicl_recovery_payt b
		 WHERE b.claim_id = p_claim_id
		   AND b.recovery_id = p_recovery_id
		   AND NVL (b.cancel_tag, 'N') = 'N';
           
        --for write off and cancel recovery    
	    SELECT COUNT (recovery_id) c_recov
          INTO p_count2
          FROM gicl_clm_recovery a
         WHERE a.claim_id = p_claim_id
           AND a.cancel_tag IS NULL
           AND NOT EXISTS (SELECT '1' 
                             FROM gicl_recovery_payt b
                            WHERE b.claim_id = a.claim_id
                              AND b.recovery_id = a.recovery_id
                              AND NVL(b.cancel_tag,'N') = 'N');
                              
        --for close recovery                       
	    SELECT count(recovery_id) c_recov
          INTO p_count3
          FROM gicl_clm_recovery a
         WHERE a.claim_id = p_claim_id
           AND a.cancel_tag IS NULL
           AND EXISTS (SELECT '1' 
                         FROM gicl_recovery_payt b
                        WHERE b.claim_id = a.claim_id
                          AND b.recovery_id = a.recovery_id
                          AND NVL(b.cancel_tag,'N') = 'N');                              
    END;    

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  04.04.2012 
    **  Reference By :  GICLS025 - Recovery Information 
    **  Description :   Write off recovery 
    */
    PROCEDURE write_off_recovery(
        p_claim_id              gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
        al_button               VARCHAR2
        ) IS
      v_process_curr     VARCHAR2(1) := 'Y';    
      v_hist_no          gicl_rec_hist.rec_hist_no%TYPE;
      v_writeoff_cd      giis_parameters.param_value_v%TYPE;
    BEGIN
      SELECT giisp.v('WRITE_OFF_REC_STAT')
        INTO v_writeoff_cd 
        FROM dual;
    
      FOR i IN (SELECT count(*) ctr
                  FROM gicl_recovery_payt b
                 WHERE b.claim_id = p_claim_id
                   AND b.recovery_id = p_recovery_id
                   AND NVL(b.cancel_tag,'N') = 'N')
      LOOP
        IF i.ctr = 0 THEN 
            FOR b IN ( 
                SELECT count(recovery_id) c_recov
                    FROM gicl_clm_recovery a
                 WHERE a.claim_id = p_claim_id
                 AND a.cancel_tag IS NULL
                 AND NOT EXISTS (SELECT '1' 
                                     FROM gicl_recovery_payt b
                                    WHERE b.claim_id = a.claim_id
                                        AND b.recovery_id = a.recovery_id
                                        AND NVL(b.cancel_tag,'N') = 'N'))
            LOOP
              IF b.c_recov > 1 THEN     
                IF al_button = 'Y' THEN  
                    v_process_curr := 'N'; 
                    FOR chk_rec IN (
                        SELECT recovery_id
                            FROM gicl_clm_recovery a
                         WHERE a.claim_id = p_claim_id
                         AND NOT EXISTS (SELECT '1' 
                                             FROM gicl_recovery_payt b
                                            WHERE b.claim_id = a.claim_id
                                                AND b.recovery_id = a.recovery_id
                                                AND NVL(b.cancel_tag,'N') = 'N')) 
                    LOOP
                        UPDATE gicl_clm_recovery
                           SET cancel_tag = v_writeoff_cd
                         WHERE claim_id = p_claim_id
                           AND recovery_id = chk_rec.recovery_id;
                                   
                        v_hist_no := 0;  
                                               
                        FOR get_max_hist IN (
                            SELECT MAX(rec_hist_no) hist_no
                            FROM gicl_rec_hist
                         WHERE recovery_id = chk_rec.recovery_id) 
                        LOOP
                          v_hist_no := get_max_hist.hist_no;
                        END LOOP;
                    INSERT INTO gicl_rec_hist
                                (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
                         VALUES 
                                (chk_rec.recovery_id,v_hist_no + 1, v_writeoff_cd,giis_users_pkg.app_user,sysdate);               
                  END LOOP;
                           
                END IF;
              END IF;
            END LOOP;
                    
            IF v_process_curr = 'Y' THEN
              UPDATE gicl_clm_recovery
                 SET cancel_tag = v_writeoff_cd
               WHERE claim_id = p_claim_id
                 AND recovery_id = p_recovery_id;
                        
              v_hist_no := 0;    
                                  
              FOR get_max_hist IN (
                  SELECT MAX(rec_hist_no) hist_no
                     FROM gicl_rec_hist
                    WHERE recovery_id = p_recovery_id) 
              LOOP
                v_hist_no := NVL(get_max_hist.hist_no,0);
              END LOOP;
                     
             INSERT INTO gicl_rec_hist
                        (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
                  VALUES 
                        (p_recovery_id,v_hist_no + 1,v_writeoff_cd,giis_users_pkg.app_user,sysdate);   
            END IF; 
        END IF;
      END LOOP;    
    END;    

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  04.04.2012 
    **  Reference By :  GICLS025 - Recovery Information 
    **  Description :   Cancel recovery 
    */
    PROCEDURE cancel_recovery(
        p_claim_id              gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
        al_button               VARCHAR2
        ) IS
      v_process_curr     VARCHAR2(1) := 'Y';    
      v_hist_no          gicl_rec_hist.rec_hist_no%TYPE;
      v_cancel_cd        giis_parameters.param_value_v%TYPE;
    BEGIN
      SELECT giisp.v('CANCEL_REC_STAT')
        INTO v_cancel_cd 
        FROM dual;
    
      FOR i IN (SELECT count(*) ctr
                  FROM gicl_recovery_payt b
                 WHERE b.claim_id = p_claim_id
                   AND b.recovery_id = p_recovery_id
                   AND NVL(b.cancel_tag,'N') = 'N')
      LOOP
        IF i.ctr = 0 THEN  
            FOR b IN ( 
                  SELECT count(recovery_id) c_recov
                    FROM gicl_clm_recovery a
                   WHERE a.claim_id = p_claim_id
                     AND a.cancel_tag IS NULL
                     AND NOT EXISTS (SELECT '1' 
                                       FROM gicl_recovery_payt b
                                      WHERE b.claim_id = a.claim_id
                                        AND b.recovery_id = a.recovery_id
                                        AND NVL(b.cancel_tag,'N') = 'N'))
            LOOP
              IF b.c_recov > 1 THEN       
                 IF al_button = 'Y' THEN
                      v_process_curr := 'N'; 
                      FOR chk_rec IN (
                          SELECT recovery_id
                              FROM gicl_clm_recovery a
                             WHERE a.claim_id = p_claim_id
                             AND NOT EXISTS (SELECT '1' 
                                                 FROM gicl_recovery_payt b
                                              WHERE b.claim_id = a.claim_id
                                                  AND b.recovery_id = a.recovery_id
                                                  AND NVL(b.cancel_tag,'N') = 'N')) 
                      LOOP
                          UPDATE gicl_clm_recovery
                             SET cancel_tag = v_cancel_cd
                             WHERE claim_id = p_claim_id
                             AND recovery_id = chk_rec.recovery_id;
                                             
                          v_hist_no := 0;   
                                                        
                          FOR get_max_hist IN (
                              SELECT MAX(rec_hist_no) hist_no
                              FROM gicl_rec_hist
                             WHERE recovery_id = chk_rec.recovery_id) 
                          LOOP
                              v_hist_no := get_max_hist.hist_no;
                          END LOOP;
                                          
                          INSERT INTO gicl_rec_hist
                              (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
                          VALUES 
                              (chk_rec.recovery_id,v_hist_no + 1,v_cancel_cd,giis_users_pkg.app_user,sysdate);               
                      END LOOP; 
                   END IF;
                  END IF;
              END LOOP;
                              
              IF v_process_curr = 'Y' THEN
                 UPDATE gicl_clm_recovery
                    SET cancel_tag = v_cancel_cd
                  WHERE claim_id = p_claim_id
                    AND recovery_id = p_recovery_id;
                                  
                 v_hist_no := 0;    
                                              
                 FOR get_max_hist IN (
                     SELECT MAX(rec_hist_no) hist_no
                       FROM gicl_rec_hist
                      WHERE recovery_id = p_recovery_id) 
                 LOOP
                   v_hist_no := nvl(get_max_hist.hist_no,0);
                 END LOOP;
                                 
                 INSERT INTO gicl_rec_hist
                            (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
                      VALUES 
                            (p_recovery_id,v_hist_no + 1,v_cancel_cd ,giis_users_pkg.app_user,sysdate);    
              END IF;  
        END IF;	
      END LOOP;     
    END;    

   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  04.04.2012 
    **  Reference By :  GICLS025 - Recovery Information 
    **  Description :   Close recovery 
    */
    PROCEDURE close_recovery(
        p_claim_id              gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id           gicl_recovery_payt.recovery_id%TYPE,
        al_button               VARCHAR2
        ) IS
      v_process_curr     VARCHAR2(1) := 'Y';    
      v_hist_no          gicl_rec_hist.rec_hist_no%TYPE;
      v_close_cd         giis_parameters.param_value_v%TYPE;
    BEGIN
        SELECT giisp.v('CLOSE_REC_STAT')
          INTO v_close_cd 
          FROM dual;
          
      FOR i IN (SELECT count(*) ctr
                  FROM gicl_recovery_payt b
                 WHERE b.claim_id = p_claim_id
                   AND b.recovery_id = p_recovery_id
                   AND NVL(b.cancel_tag,'N') = 'N')
      LOOP               
        IF i.ctr >=1 THEN 
            FOR b IN ( 
                SELECT count(recovery_id) c_recov
                FROM gicl_clm_recovery a
                 WHERE a.claim_id = p_claim_id
                 AND a.cancel_tag IS NULL
                 AND EXISTS (SELECT '1' 
                                 FROM gicl_recovery_payt b
                              WHERE b.claim_id = a.claim_id
                                    AND b.recovery_id = a.recovery_id
                                    AND NVL(b.cancel_tag,'N') = 'N'))
            LOOP
               IF b.c_recov > 1 THEN       
                 IF al_button = 'Y' THEN
                    v_process_curr := 'N'; 
                        FOR chk_rec IN (
                            SELECT recovery_id
                              FROM gicl_clm_recovery a
                             WHERE a.claim_id = p_claim_id
                               AND EXISTS (SELECT '1' 
                                             FROM gicl_recovery_payt b
                                            WHERE b.claim_id = a.claim_id
                                              AND b.recovery_id = a.recovery_id
                                              AND NVL(b.cancel_tag,'N') = 'N')) 
                        LOOP
                            UPDATE gicl_clm_recovery
                               SET cancel_tag = v_close_cd
                             WHERE claim_id = p_claim_id
                               AND recovery_id = chk_rec.recovery_id;
                                 
                            v_hist_no := 0;   
                                              
                            FOR get_max_hist IN (
                                SELECT MAX(rec_hist_no) hist_no
                                  FROM gicl_rec_hist
                                 WHERE recovery_id = chk_rec.recovery_id) 
                            LOOP
                                v_hist_no := get_max_hist.hist_no;
                            END LOOP;
                                
                            INSERT INTO gicl_rec_hist
                                        (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
                                 VALUES 
                                        (chk_rec.recovery_id,v_hist_no + 1,v_close_cd,giis_users_pkg.app_user,sysdate);               
                        END LOOP;
                 END IF;
               END IF;
            END LOOP;
      
            IF v_process_curr = 'Y' THEN
                 UPDATE gicl_clm_recovery
                    SET cancel_tag = v_close_cd
                  WHERE claim_id = p_claim_id
                    AND recovery_id = p_recovery_id;
                        
                 v_hist_no := 0;    
                                  
                 FOR get_max_hist IN (
                     SELECT MAX(rec_hist_no) hist_no
                       FROM gicl_rec_hist
                      WHERE recovery_id = p_recovery_id) 
                 LOOP
                   v_hist_no := NVL(get_max_hist.hist_no,0);
                 END LOOP;
                     
                 INSERT INTO gicl_rec_hist
                            (recovery_id,rec_hist_no,rec_stat_cd,user_id,last_update)
                      VALUES 
                            (p_recovery_id,v_hist_no + 1,v_close_cd,giis_users_pkg.app_user,sysdate);   
            END IF; 	 	
        END IF;
      END LOOP;	
    END;

/*
**  Created by   :  Belle Bebing
**  Date Created :  04.17.2012
**  Reference By : GICLS054 - Recovery Distribution
**  Description :  get recovery details
*/
FUNCTION get_recovery_dist_info(p_claim_id       gicl_clm_recovery.claim_id%TYPE)
  RETURN gicl_clm_recovery_dist_tab PIPELINED IS
    rec       gicl_clm_recovery_dist_type;
    BEGIN
        FOR i IN (SELECT recovery_id, claim_id, recovery_payt_id, payor_class_cd, payor_cd,
                         recovered_amt, acct_tran_id, tran_date, cancel_tag, cancel_date, entry_tag,
                         dist_sw, acct_tran_id2, tran_date2, stat_sw, recovery_acct_id
                    FROM GICL_RECOVERY_PAYT
                   WHERE claim_id = p_claim_id
                     AND NVL(cancel_tag,'N') = 'N')
        LOOP
            rec.recovery_id         := i.recovery_id;
            rec.claim_id            := i.claim_id;            
            rec.recovery_payt_id    := i.recovery_payt_id;
            rec.payor_class_cd      := i.payor_class_cd;
            rec.payor_cd            := i.payor_cd;
            rec.recovered_amt       := i.recovered_amt;
            rec.acct_tran_id        := i.acct_tran_id;
            rec.tran_date           := i.tran_date;
            rec.cancel_tag          := i.cancel_tag;
            rec.cancel_date         := i.cancel_date;
            rec.entry_tag           := i.entry_tag;
            rec.dist_sw             := NVL(i.dist_sw, 'N');
            rec.acct_tran_id2       := i.acct_tran_id2;
            rec.tran_date2          := i.tran_date2;
            rec.stat_sw             := NVL(i.stat_sw, 'N');
			rec.recovery_acct_id	:= i.recovery_acct_id;
            
            FOR m IN (SELECT line_cd, iss_cd, rec_year, rec_seq_no
                      FROM gicl_clm_recovery
                     WHERE recovery_id = i.recovery_id)
            LOOP 
                rec.dsp_line_cd  := m.line_cd;
                rec.dsp_iss_cd   := m.iss_cd;
                rec.dsp_rec_year := m.rec_year;  
                rec.dsp_rec_seq_no := m.rec_seq_no;
            END LOOP; 
            
            BEGIN
                FOR t IN (SELECT tran_class, TO_CHAR(tran_class_no,'0999999999') tran_class_no
                        FROM giac_acctrans
                       WHERE tran_id = i.acct_tran_id)
                LOOP 
                    IF t.tran_class = 'COL' THEN
                        FOR c IN (SELECT or_pref_suf||'-'||TO_CHAR(or_no,'0999999999') or_no 
                                    FROM giac_order_of_payts
                                   WHERE gacc_tran_id = i.acct_tran_id)
                        LOOP
                            rec.dsp_ref_no := c.or_no;
                        END LOOP; 
                    ELSIF t.tran_class = 'DV' THEN
                        FOR r IN (SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no,'099999') request_no
                                    FROM giac_payt_requests a, giac_payt_requests_dtl b
                                   WHERE a.ref_id = b.gprq_ref_id
                                     AND b.tran_id = i.acct_tran_id)
                        LOOP 
                            rec.dsp_ref_no := r.request_no;
                            FOR d IN(SELECT dv_pref||'-'||TO_CHAR(dv_no,'0999999999') dv_no
                                       FROM giac_disb_vouchers
                                       WHERE gacc_tran_id = i.acct_tran_id)
                            LOOP
                                rec.dsp_ref_no := d.dv_no;
                            END LOOP;
                        END LOOP; 
                    ELSIF t.tran_class = 'JV' THEN
                     rec.dsp_ref_no := t.tran_class||'-'||t.tran_class_no; 
                    END IF;
                END LOOP;
            END;
            
            FOR p IN(SELECT DECODE(payee_first_name, NULL, payee_last_name,
                                   payee_last_name||', '||
                                   payee_first_name||' '||
                                   payee_middle_name) payor
                       FROM giis_payees
                      WHERE payee_class_cd = i.payor_class_cd
                        AND payee_no = i.payor_cd)
            LOOP 
                rec.dsp_payor_name := p.payor; 
            END LOOP;
            
            BEGIN
               SELECT pol_eff_date, expiry_date, loss_date
                 INTO rec.pol_eff_date, rec.expiry_date, rec.loss_date
                 FROM gicl_claims
                WHERE claim_id = p_claim_id; 
            END;
            
          PIPE ROW(rec);
        END LOOP;
    
    END;    
    
    /*
    **  Created by   :  Andrew Robes
    **  Date Created :  07.06.2012
    **  Reference By : GICLS025 - Loss Recovery
    **  Description :  Procedure to update demand letter dates upon printing of reports
    */
    PROCEDURE update_demand_letter_dates(   
      p_claim_id            gicl_clm_recovery.claim_id%TYPE,
      p_recovery_id         gicl_clm_recovery.recovery_id%TYPE,
      p_demand_letter_date  VARCHAR2,
      p_demand_letter_date2 VARCHAR2,
      p_demand_letter_date3 VARCHAR2
    ) IS
    BEGIN
      UPDATE GICL_CLM_RECOVERY
         SET demand_letter_date = TO_DATE(p_demand_letter_date, 'MM-DD-YYYY'),
             demand_letter_date2 = TO_DATE(p_demand_letter_date2, 'MM-DD-YYYY'),
             demand_letter_date3 = TO_DATE(p_demand_letter_date3, 'MM-DD-YYYY')
       WHERE claim_id = p_claim_id
         AND recovery_id = p_recovery_id;  
    END; 
	
	/*
    **  Created by   :  Marco Paolo Rebong
    **  Date Created :  08.29.2012
    **  Reference By :  GICLS025 - Recovery Information 
    **  Description :   set variables on load
    */
	FUNCTION get_gicls025_variables(
		p_claim_id			GICL_CLM_RECOVERY.claim_id%TYPE
	)
	  RETURN gicls025_variables_tab PIPELINED AS
	  	v_vars				gicls025_variables_type;
	BEGIN
		BEGIN
			SELECT param_value_v
			  INTO v_vars.assd_class_cd
      		  FROM GIAC_PARAMETERS
     		 WHERE param_name like 'ASSD_CLASS_CD';
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_vars.assd_class_cd := NULL;
		END;
		
		BEGIN
			SELECT a.assd_no, a.assd_name
			  INTO v_vars.assd_no, v_vars.assd_name
      		  FROM GIIS_ASSURED a, 
           		   GICL_CLAIMS b
     		 WHERE b.claim_id = p_claim_id
     	       AND a.assd_no = b.assd_no;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				v_vars.assd_no := NULL;
				v_vars.assd_name := NULL;
		END;
		
		FOR y IN (SELECT plate_no 
				    FROM gicl_motor_car_dtl
				   WHERE claim_id = p_claim_id)
		LOOP
			v_vars.plate_no := y.plate_no;
			EXIT;
		END LOOP;
		
		PIPE ROW(v_vars);
	END;
	
	/*
    **  Created by   :  Veronica V. Raymundo 
    **  Date Created :  04.04.2013 
    **  Reference By :  GICLS260 - Claim Information 
    **  Description  :  Get loss recovery details for GICLS260  
    */
    FUNCTION get_gicl_clm_recovery_2(
        p_claim_id          gicl_clm_recovery.claim_id%TYPE)
    RETURN gicl_clm_recovery_tab PIPELINED IS
      v_list            gicl_clm_recovery_type;
      v_plate_num		gicl_motor_car_dtl.plate_no%type;
	  
    BEGIN
        FOR i IN (SELECT a.recovery_id, a.claim_id, a.line_cd,        
                         a.rec_year, a.rec_seq_no, a.rec_type_cd,         
                         a.recoverable_amt, a.recovered_amt, a.tp_item_desc,        
                         a.plate_no, a.currency_cd, a.convert_rate,        
                         a.lawyer_class_cd, a.lawyer_cd, a.cpi_rec_no,          
                         a.cpi_branch_cd, a.user_id, a.last_update, 
                         a.cancel_tag, a.iss_cd, a.rec_file_date,
                         a.demand_letter_date, a.demand_letter_date2, a.demand_letter_date3, 
                         a.tp_driver_name, a.tp_drvr_add, a.tp_plate_no,         
                         a.case_no, a.court
                    FROM gicl_clm_recovery a   
                   WHERE a.claim_id = p_claim_id
                   ORDER BY line_cd,  rec_year, rec_seq_no)
        LOOP
            v_list.recovery_id                 := i.recovery_id;
            v_list.claim_id                    := i.claim_id;
            v_list.line_cd                     := i.line_cd;
            v_list.rec_year                    := i.rec_year;
            v_list.rec_seq_no                  := i.rec_seq_no;
            v_list.rec_type_cd                 := i.rec_type_cd;
            v_list.recoverable_amt             := i.recoverable_amt;
            v_list.recovered_amt               := i.recovered_amt;
            v_list.tp_item_desc                := i.tp_item_desc;
            v_list.plate_no                    := i.plate_no;
            v_list.currency_cd                 := i.currency_cd;
            v_list.convert_rate                := i.convert_rate;
            v_list.lawyer_class_cd             := i.lawyer_class_cd;
            v_list.lawyer_cd                   := i.lawyer_cd;
            v_list.cpi_rec_no                  := i.cpi_rec_no;
            v_list.cpi_branch_cd               := i.cpi_branch_cd;
            v_list.user_id                     := i.user_id;
            v_list.last_update                 := i.last_update;
            v_list.cancel_tag                  := i.cancel_tag;
            v_list.iss_cd                      := i.iss_cd;
            v_list.rec_file_date               := i.rec_file_date;
            v_list.demand_letter_date          := i.demand_letter_date;
            v_list.demand_letter_date2         := i.demand_letter_date2;
            v_list.demand_letter_date3         := i.demand_letter_date3;
            v_list.tp_driver_name              := i.tp_driver_name;
            v_list.tp_drvr_add                 := i.tp_drvr_add;
            v_list.tp_plate_no                 := i.tp_plate_no;
            v_list.case_no                     := i.case_no;
            v_list.court                       := i.court;
			
            v_plate_num := NULL;
			
			FOR y IN (SELECT plate_no 
	   				    FROM gicl_motor_car_dtl
	  		  		  WHERE claim_id = p_claim_id)
			LOOP
				v_plate_num := y.plate_no;
				EXIT;
			END LOOP;
			
			IF v_plate_num IS NOT NULL AND i.plate_no IS NULL THEN
				v_list.plate_no := v_plate_num;
			END IF;
            
            BEGIN
              SELECT rec_type_desc
                INTO v_list.dsp_rec_type_desc
                FROM giis_recovery_type
               WHERE rec_type_cd = i.rec_type_cd;
            EXCEPTION
            WHEN OTHERS THEN
              v_list.dsp_rec_type_desc := NULL;
            END;
            
            BEGIN
              SELECT payee_last_name||', '||payee_first_name||' '||
                     payee_middle_name 
                INTO v_list.dsp_lawyer_name
                FROM giis_payees
               WHERE payee_no = i.lawyer_cd
                 AND payee_class_cd = i.lawyer_class_cd;
            EXCEPTION
              WHEN OTHERS THEN
                v_list.dsp_lawyer_name := NULL;    
            END;

            BEGIN
              SELECT currency_desc 
                INTO v_list.dsp_currency_desc
                FROM giis_currency
               WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
              WHEN OTHERS THEN
                v_list.dsp_currency_desc := NULL;
            END;
            
            -- check first if recovery already has valid payments
            v_list.dsp_check_valid := NULL;
            FOR valid_payt IN (SELECT '1'
                                 FROM gicl_recovery_payt
                                WHERE claim_id = p_claim_id
                                  AND recovery_id = i.recovery_id
                                  AND NVL(cancel_tag ,'N') = 'N') 
            LOOP
              v_list.dsp_check_valid := '1';
              EXIT;
            END LOOP;
            
            -- check first if recovery already has valid payments
            v_list.dsp_check_all := NULL;
            FOR all_payt IN (SELECT '1'
                               FROM gicl_recovery_payt
                              WHERE claim_id = p_claim_id
                                AND recovery_id = i.recovery_id)
            LOOP
              v_list.dsp_check_all := '1';
              EXIT;
            END LOOP;            
            
            PIPE ROW(v_list);
        END LOOP;          
      RETURN;      
    END;
    
END gicl_clm_recovery_pkg;
/


