CREATE OR REPLACE PACKAGE BODY CPI.GIUTS008A_PKG
 	/*
    **  Created by        : bonok
    **  Date Created      : 02.11.2013
    **  Reference By      : GIUTS008A - COPY PACKAGE POLICY TO PAR
    */
AS
	FUNCTION validate_line_cd(
		p_line_cd	giis_line.line_cd%TYPE,
		p_iss_cd	giis_issource.iss_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE --added by reymon 05042013
	)
		RETURN VARCHAR2
	AS
		v_message	VARCHAR2(100) := 'SUCCESS';
		v_exist		VARCHAR2(1) := 'N';
	BEGIN
		FOR B IN (SELECT line_cd 
     				FROM giis_line
     			   WHERE line_cd = p_line_cd
                     AND pack_pol_flag = 'Y') --added by reymon 05042013 to validate if line code is for package
		LOOP
     		v_exist := 'Y';
     	END LOOP;
		
		IF v_exist = 'N' THEN
			v_message := 'Line code entered is not valid.'; 
			RETURN v_message;
		ELSE
			--IF check_user_per_line(p_line_cd, p_iss_cd, 'GIUTS008A') != 1 THEN commented and changed by reymon 05042013
            IF check_user_per_line2(p_line_cd, p_iss_cd, 'GIUTS008A', p_user_id) != 1 THEN
				v_message := 'You are not authorized to use this line.';
				RETURN v_message;
			END IF;
		END IF;
		
		RETURN v_message;
	END validate_line_cd;
	
	FUNCTION validate_iss_cd(
		p_line_cd	giis_line.line_cd%TYPE,
		p_iss_cd	giis_issource.iss_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE --added by reymon 05072013
	)
		RETURN VARCHAR2
	AS
		v_exist    	VARCHAR2(1) := 'N';
		v_message	VARCHAR2(100) := 'SUCCESS';
	BEGIN
		FOR B IN (SELECT iss_cd
					FROM giis_issource
				   WHERE iss_cd = p_iss_cd) 
		LOOP         
	        v_exist := 'Y';
        END LOOP;           

        IF v_exist = 'N' THEN
           v_message := 'Issue Code entered is not valid.';
		   RETURN v_message; 
        ELSE
			--IF check_user_per_iss_cd(null, p_iss_cd, 'GIUTS008A') != 1 THEN
            IF check_user_per_iss_cd2(null, p_iss_cd, 'GIUTS008A', p_user_id) != 1 THEN
				v_message := 'Issue Code entered is not allowed for the current user.';
				RETURN v_message;
			END IF;
		END IF;
		
		RETURN v_message;	
	END validate_iss_cd;
	
	PROCEDURE copy_pack_policy_giuts008a(
		p_line_cd		   IN  gipi_polbasic.line_cd%TYPE,
		p_subline_cd	   IN  gipi_polbasic.subline_cd%TYPE,
		p_iss_cd		   IN  gipi_polbasic.iss_cd%TYPE,
        p_par_iss_cd	   IN  gipi_polbasic.iss_cd%TYPE,
		p_issue_yy		   IN  gipi_polbasic.issue_yy%TYPE,
		p_pol_seq_no	   IN  gipi_polbasic.pol_seq_no%TYPE,
		p_renew_no		   IN  gipi_polbasic.renew_no%TYPE,
		p_endt_iss_cd	   IN  gipi_polbasic.endt_iss_cd%TYPE,
		p_endt_yy		   IN  gipi_polbasic.endt_yy%TYPE,
		p_endt_seq_no	   IN  gipi_polbasic.endt_seq_no%TYPE,
        p_user_id          IN  gipi_polbasic.user_id%TYPE,
        v_par_par_seq_no   OUT gipi_pack_parlist.par_seq_no%TYPE,
        v_par_quote_seq_no OUT gipi_pack_parlist.quote_seq_no%TYPE
	) AS
		v_open_flag			 VARCHAR2(1);
        v_menu_line 	     giis_line.menu_line_cd%TYPE;
        v_policy_id          gipi_polbasic.policy_id%TYPE; 
		v_pack_policy_id	 gipi_polbasic.pack_policy_id%TYPE;
        v_parameter_par_type gipi_pack_parlist.par_type%TYPE;
        v_item_exists        VARCHAR2(1) := 'N';
        
        -- copy data block
        v_copy_pack_par_id   gipi_parlist.pack_par_id%TYPE; -- :copy.pack_par_id
        v_copy_par_id        gipi_parlist.par_id%TYPE; -- :copy.par_id
        v_copy_v_long        gipi_polgenin.gen_info%TYPE; -- :copy.v_long
        
        -- from variables spec
        v_variables_line_ac      giis_parameters.param_value_v%TYPE;
        v_variables_line_av      giis_parameters.param_value_v%TYPE;
        v_variables_line_en      giis_parameters.param_value_v%TYPE;
        v_variables_line_mc      giis_parameters.param_value_v%TYPE;
        v_variables_line_fi      giis_parameters.param_value_v%TYPE;
        v_variables_line_ca      giis_parameters.param_value_v%TYPE;
        v_variables_line_mh      giis_parameters.param_value_v%TYPE;
        v_variables_line_mn      giis_parameters.param_value_v%TYPE;
        v_variables_line_su      giis_parameters.param_value_v%TYPE;
        v_variables_subline_mop  giis_parameters.param_value_v%TYPE;
        
        v_variables_v_line_cd    giis_line.line_cd%TYPE; -- variables.v_line_cd
        v_variables_line_cd      giis_line.line_cd%TYPE; -- variables.policy_nbt_line_cd
        v_variables_subline_cd   gipi_polbasic.subline_cd%TYPE; -- variables.policy_nbt_subline_cd
        v_variables_iss_cd       gipi_polbasic.iss_cd%TYPE := NULL; -- variables.policy_nbt_iss_cd
        v_variables_issue_yy     gipi_polbasic.issue_yy%TYPE; -- variables.policy_nbt_issue_yy
        v_variables_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE; -- variables.policy_nbt_pol_seq_no
        v_variables_renew_no     gipi_polbasic.renew_no%TYPE; -- variables.policy_nbt_renew_no
        v_variables_menu_line_cd giis_line.menu_line_cd%TYPE; -- variables.v_menu_line_cd
	BEGIN
        GIIS_USERS_PKG.app_user := p_user_id; -- marco - 04.30.2013
    
        get_param_value_v(v_variables_line_ac, v_variables_line_av, v_variables_line_en, v_variables_line_mc, v_variables_line_fi, 
                          v_variables_line_ca, v_variables_line_mh, v_variables_line_mn, v_variables_line_su, v_variables_subline_mop);
    
		FOR FLAG IN(SELECT op_flag
                	  FROM giis_subline
               		 WHERE line_cd     = p_line_cd
                 	   AND subline_cd  = p_subline_cd)
		LOOP
			v_open_flag := flag.op_flag;
			EXIT;
  		END LOOP;
		
		IF p_endt_seq_no > 0 THEN
			check_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_endt_iss_cd, p_endt_yy, p_endt_seq_no);
			SELECT pack_policy_id
			  INTO v_pack_policy_id
         	  FROM gipi_pack_polbasic
        	 WHERE line_cd     = p_line_cd
          	   AND subline_cd  = p_subline_cd
          	   AND iss_cd      = p_iss_cd
          	   AND issue_yy    = p_issue_yy
          	   AND pol_seq_no  = p_pol_seq_no
          	   AND renew_no    = p_renew_no
          	   AND endt_iss_cd = p_endt_iss_cd
          	   AND endt_yy     = p_endt_yy
          	   AND endt_seq_no = p_endt_seq_no;
		ELSE 
			check_policy(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
			SELECT pack_policy_id
			  INTO v_pack_policy_id
			  FROM gipi_pack_polbasic
			 WHERE line_cd     = p_line_cd
			   AND subline_cd  = p_subline_cd
			   AND iss_cd      = p_iss_cd
			   AND issue_yy    = p_issue_yy
			   AND pol_seq_no  = p_pol_seq_no
			   AND renew_no    = p_renew_no
			   AND endt_seq_no = 0;
    	END IF;
        
        -- COPY_PACK start
        insert_into_pack_parlist(v_pack_policy_id, p_user_id, p_par_iss_cd, v_copy_pack_par_id, v_parameter_par_type);
        insert_into_pack_parhist(v_copy_pack_par_id, p_user_id);
        
        SELECT par_seq_no, quote_seq_no -- from COPY_PACK
          INTO v_par_par_seq_no, v_par_quote_seq_no -- :par.par_seq_no, :par.quote_seq_no
          FROM gipi_pack_parlist
         WHERE pack_par_id = v_copy_pack_par_id;  
         
        copy_pack_polbasic(v_pack_policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_par_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_variables_iss_cd, v_copy_pack_par_id, p_user_id);
        copy_pack_polgenin(v_pack_policy_id, v_copy_pack_par_id, p_user_id);
        copy_pack_polwc(v_pack_policy_id, v_copy_pack_par_id);
        copy_pack_endttext(v_pack_policy_id, v_copy_pack_par_id, p_user_id);
        -- COPY_PACK end
        
        FOR c1 IN (SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM gipi_polbasic
                    WHERE pack_policy_id = v_pack_policy_id)
        LOOP  
            v_policy_id := c1.policy_id;   
            v_variables_line_cd := c1.line_cd;
            v_variables_subline_cd := c1.subline_cd;
            v_variables_iss_cd := c1.iss_cd;
            v_variables_issue_yy := c1.issue_yy;
            v_variables_pol_seq_no := c1.pol_seq_no;
            v_variables_renew_no := c1.renew_no; 
            
            BEGIN 
		        SELECT menu_line_cd
		          INTO v_menu_line
		          FROM giis_line
		         WHERE line_cd = v_variables_line_cd;
		    END;
		    
            IF v_menu_line IS NOT NULL THEN
                v_variables_v_line_cd := v_menu_line;
            ELSE
                v_variables_v_line_cd := v_variables_line_cd;
		    END IF;
            
            insert_into_parlist(v_policy_id, v_copy_par_id, p_user_id, v_copy_pack_par_id, v_parameter_par_type, p_par_iss_cd);
            insert_into_parhist(v_copy_par_id, p_user_id);
            copy_polbasic(v_policy_id, v_variables_line_cd, v_variables_subline_cd, v_variables_iss_cd, v_variables_issue_yy,
                          v_variables_pol_seq_no, v_variables_renew_no, p_iss_cd, v_copy_pack_par_id, v_copy_par_id, p_user_id); 
            copy_mortgagee(v_policy_id, p_par_iss_cd, v_copy_par_id);  
            copy_polgenin(v_policy_id, v_copy_v_long, v_copy_par_id, p_user_id);
            copy_polwc(v_policy_id, v_copy_par_id);
            copy_endttext(v_policy_id, v_copy_v_long, v_copy_par_id, p_user_id);
            
            FOR a IN (SELECT menu_line_cd
                        FROM giis_line
                       WHERE line_cd = v_variables_line_cd)
            LOOP
                v_variables_menu_line_cd := a.menu_line_cd;
                EXIT;
            END LOOP;
            
            copy_pack_line_subline(v_policy_id, v_copy_par_id, v_copy_pack_par_id);
            
            IF (v_variables_v_line_cd != v_variables_line_mn OR v_variables_menu_line_cd != 'MN') 
                AND v_variables_subline_cd != v_variables_subline_mop THEN
                IF v_variables_v_line_cd != v_variables_line_ac OR v_variables_menu_line_cd != 'AC' THEN
                    copy_lim_liab(v_policy_id, v_copy_par_id);
                END IF;
                
                copy_item(v_policy_id, v_parameter_par_type, v_variables_line_cd, v_variables_subline_cd, v_variables_iss_cd,
		                  v_variables_issue_yy, v_variables_pol_seq_no, v_variables_renew_no, v_copy_par_id);
                          
                IF v_parameter_par_type = 'P' THEN  
                    copy_itmperil(v_policy_id, v_copy_par_id);
                    copy_peril_discount(v_policy_id, v_copy_par_id);
                    copy_item_discount(v_policy_id, v_copy_par_id);
                    copy_polbas_discount(v_policy_id, v_copy_par_id);
                END IF;
            END IF;
            
            IF v_variables_v_line_cd = v_variables_line_ac OR v_variables_menu_line_cd = 'AC' THEN
                copy_beneficiary(v_policy_id, v_copy_par_id);
                copy_accident_item(v_policy_id, v_copy_par_id);
            ELSIF v_variables_v_line_cd = v_variables_line_ca OR v_variables_menu_line_cd = 'CA' THEN
                copy_casualty_item(v_policy_id, v_copy_par_id);
                copy_casualty_personnel(v_policy_id, v_copy_par_id);
            ELSIF v_variables_v_line_cd = v_variables_line_en OR v_variables_menu_line_cd = 'EN' THEN
                copy_engg_basic(v_policy_id, v_copy_par_id);
                copy_location(v_policy_id, v_copy_par_id);
                copy_principal(v_policy_id, v_copy_par_id);
            ELSIF v_variables_v_line_cd = v_variables_line_fi OR v_variables_menu_line_cd = 'FI' THEN
                copy_fire(v_policy_id, v_copy_par_id);
            ELSIF v_variables_v_line_cd = v_variables_line_mc OR v_variables_menu_line_cd = 'MC' THEN
                copy_vehicle(v_policy_id, v_copy_par_id);
                copy_mcacc(v_policy_id, v_copy_par_id);
            ELSIF v_variables_v_line_cd = v_variables_line_su THEN
                copy_bond_basic(v_policy_id, v_copy_v_long, v_copy_par_id);
                copy_cosigntry(v_policy_id, v_copy_par_id);
            ELSIF v_variables_v_line_cd IN (v_variables_line_mh, v_variables_line_mn, v_variables_line_av) OR v_variables_menu_line_cd IN ('MH','MN','AV') THEN
                copy_aviation_cargo_hull(v_policy_id, v_variables_line_cd, v_variables_subline_cd, v_variables_iss_cd, v_variables_issue_yy, v_variables_pol_seq_no, 
                                         v_variables_renew_no, v_copy_par_id, v_parameter_par_type, v_variables_line_mn, v_variables_line_mh, v_variables_line_av, p_user_id);
            END IF;
    
            copy_deductibles(v_policy_id, v_copy_par_id, v_copy_v_long);
            copy_grouped_items(v_policy_id, v_copy_par_id);
            copy_pictures(v_policy_id, v_copy_par_id);
            
            IF v_open_flag = 'Y' AND (v_variables_v_line_cd != v_variables_line_mn OR v_variables_menu_line_cd != 'MN')THEN
                copy_open_liab(v_policy_id, v_copy_par_id);  
                copy_open_peril(v_policy_id, v_copy_par_id);
            END IF;
            
            copy_orig_invoice(v_policy_id, v_copy_par_id);
            copy_orig_invperl(v_policy_id, v_copy_par_id);
            copy_orig_inv_tax(v_policy_id, v_copy_par_id);
            copy_orig_itmperil(v_policy_id, v_copy_par_id);
            copy_co_ins(v_policy_id, v_copy_par_id, p_user_id);
            
            IF v_item_exists = 'N' THEN
    	        copy_invoice_pack(v_policy_id, v_copy_par_id);
            END IF;
            
            --UPDATE_ALL_TABLES start
                --update_gipi_parlist start
            UPDATE gipi_parlist
               SET iss_cd = p_par_iss_cd,
                   par_yy = TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2))
             WHERE par_id = v_copy_par_id; 
                --update_gipi_parlist end
            IF p_endt_iss_cd IS NULL THEN
                --update_gipi_wpolbas
                UPDATE gipi_wpolbas
                   SET iss_cd   = p_par_iss_cd,
                       issue_yy = TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2))
                 WHERE par_id   = v_copy_par_id;
            END IF;                 
            --UPDATE_ALL_TABLES end
            
            FOR rec IN (SELECT 'X'
                          FROM gipi_witmperl
                         WHERE par_id = v_copy_par_id)
            LOOP
                IF v_open_flag = 'N' THEN
                    IF v_parameter_par_type = 'P' THEN
                        create_winvoice(0, 0 , 0, v_copy_par_id, v_variables_line_cd, v_variables_iss_cd);
                        cr_bill_dist.get_tsi(v_copy_par_id);
                     END IF;
                ELSE
                    UPDATE gipi_parlist
                       SET par_status = 6
                     WHERE par_id = v_copy_par_id;
                END IF;
                EXIT;
            END LOOP;   
        END LOOP; -- c1 Loop
        
        --dito na   
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Policy number does not exist.');
    END copy_pack_policy_giuts008a;
    
    PROCEDURE get_param_value_v(
        p_variables_line_ac     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_av     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_en     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_mc     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_fi     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_ca     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_mh     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_mn     OUT giis_parameters.param_value_v%TYPE,
        p_variables_line_su     OUT giis_parameters.param_value_v%TYPE,
        p_variables_subline_mop OUT giis_parameters.param_value_v%TYPE
    ) AS
    BEGIN
        SELECT param_value_v
          INTO p_variables_line_ac
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_AC';
   
        SELECT param_value_v
          INTO p_variables_line_av
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_AV';

        SELECT param_value_v
          INTO p_variables_line_en
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_EN';

        SELECT param_value_v
          INTO p_variables_line_mc
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_MC';

        SELECT param_value_v
          INTO p_variables_line_fi
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_FI';

        SELECT param_value_v
          INTO p_variables_line_ca
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_CA';

        SELECT param_value_v
          INTO p_variables_line_mh
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_MH';

        SELECT param_value_v
          INTO p_variables_line_mn
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_MN';

        SELECT param_value_v
          INTO p_variables_line_su
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_SU';

        SELECT param_value_v
          INTO p_variables_subline_mop
          FROM giis_parameters
         WHERE param_name = 'SUBLINE_MN_MOP';
    END get_param_value_v;
    
    PROCEDURE check_endt(
        p_line_cd        gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        gipi_polbasic.iss_cd%TYPE,
        p_issue_yy        gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no        gipi_polbasic.renew_no%TYPE,
        p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
        p_endt_yy        gipi_polbasic.endt_yy%TYPE,
        p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE
    ) AS
        v_user_id     gipi_wpolbas.user_id%TYPE;
        v_exist       VARCHAR2(1) := 'N';
        v_spld        VARCHAR2(1) := 'N';
        v_spld1       VARCHAR2(1) := 'N';
        v_spld2       VARCHAR2(1) := 'N';
    BEGIN
        FOR tag IN (SELECT spld_flag
                      FROM gipi_polbasic
                       WHERE line_cd     =  p_line_cd
                       AND subline_cd  =  p_subline_cd
                       AND iss_cd      =  p_iss_cd
                       AND issue_yy    =  p_issue_yy
                       AND pol_seq_no  =  p_pol_seq_no
                       AND renew_no    =  p_renew_no
                       AND endt_iss_cd =  p_endt_iss_cd
                       AND endt_yy     =  p_endt_yy
                       AND endt_seq_no =  p_endt_seq_no)
        LOOP
            IF tag.spld_flag = 2 THEN
                v_spld := 'Y';
                EXIT;
            END IF;
        END LOOP;  
        
        FOR spld IN (SELECT spld_flag
                       FROM gipi_polbasic
                       WHERE line_cd     =  p_line_cd
                        AND subline_cd  =  p_subline_cd
                        AND iss_cd      =  p_iss_cd
                        AND issue_yy    =  p_issue_yy
                        AND pol_seq_no  =  p_pol_seq_no
                        AND renew_no    =  p_renew_no
                        AND endt_seq_no = 0)
        LOOP
            IF spld.spld_flag = 2 THEN
                v_spld1 := 'Y';
                EXIT;
            END IF;
        END LOOP;
        
        IF v_spld1 = 'Y' THEN
             RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Policy has been tagged for spoilage. Please do the necessary action before copying to a new par.');
          ELSIF v_spld2 = 'Y' THEN
             RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Endorsement has been spoiled. Cannot copy to a new par.');
          ELSIF v_spld = 'Y' THEN
             RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Endorsement has been tagged for spoilage. Please do the necessary action before copying to a new par.');
        END IF;
        
        FOR endt IN (SELECT user_id
                       FROM gipi_wpolbas
                      WHERE line_cd     =  p_line_cd
                        AND subline_cd  =  p_subline_cd
                        AND iss_cd      =  p_iss_cd
                        AND issue_yy    =  p_issue_yy
                        AND NVL(pol_seq_no, 999999)  = NVL (p_pol_seq_no, 999999)
                        AND renew_no    =  p_renew_no)
        LOOP
            v_exist   := 'Y';
            v_user_id := endt.user_id;
        END LOOP;

        IF v_exist = 'Y' THEN
            IF v_user_id IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Policy is currently being endorsed by ' || v_user_id || ', cannot create another par for endorsement on the same policy at the same time.');
            ELSE
                RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Policy is currently being endorsed, cannot create another par for endorsement on the same policy at the same time.');
            END IF;
        END IF;
        
    END check_endt;
    
    PROCEDURE check_policy(
        p_line_cd        gipi_polbasic.line_cd%TYPE,
        p_subline_cd     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd         gipi_polbasic.iss_cd%TYPE,
        p_issue_yy       gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no       gipi_polbasic.renew_no%TYPE
    ) AS
        v_user_id     gipi_wpolbas.user_id%TYPE;
        v_exist       VARCHAR2(1) := 'N';
        v_spld        VARCHAR2(1) := 'N';
        v_spld1       VARCHAR2(1) := 'N';
        v_spld2       VARCHAR2(1) := 'N';

    BEGIN
        FOR tag IN (SELECT spld_flag
                      FROM gipi_polbasic
                     WHERE line_cd     =  p_line_cd
                       AND subline_cd  =  p_subline_cd
                       AND iss_cd      =  p_iss_cd
                       AND issue_yy    =  p_issue_yy
                       AND pol_seq_no  =  p_pol_seq_no
                       AND renew_no    =  p_renew_no)
        LOOP
            IF tag.spld_flag = 2 THEN
                v_spld := 'Y';
                EXIT;
            END IF;
        END LOOP;  

        IF v_spld2 = 'Y' THEN
            RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Policy has been spoiled. Cannot copy to a new par.');
        ELSIF v_spld = 'Y' THEN
            RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Policy has been tagged for spoilage.  Please do the necessary action before copying to a new par.');
        END IF;
    END check_policy;
    
    PROCEDURE insert_into_pack_parlist(
        p_policy_id          IN  gipi_polbasic.policy_id%TYPE,
        p_user_id            IN  gipi_polbasic.user_id%TYPE,
        p_par_iss_cd         IN  gipi_polbasic.iss_cd%TYPE,
        p_copy_pack_par_id   OUT gipi_parlist.pack_par_id%TYPE,
        p_parameter_par_type OUT gipi_parlist.par_type%TYPE
    ) AS
        v_par_id           gipi_parlist.par_id%TYPE;
        v_line_cd          gipi_parlist.line_cd%TYPE;  
        v_iss_cd           gipi_parlist.iss_cd%TYPE;
        v_par_yy           gipi_parlist.par_yy%TYPE;
        v_quote_seq_no     gipi_parlist.quote_seq_no%TYPE;
        v_par_type         gipi_parlist.par_type%TYPE;
        v_assd_no          gipi_parlist.assd_no%TYPE;
        v_underwriter      gipi_parlist.underwriter%TYPE;
        v_assign_sw        gipi_parlist.assign_sw%TYPE;
        v_par_status       gipi_parlist.par_status%TYPE; 
        v_address1         gipi_parlist.address1%TYPE;
        v_address2         gipi_parlist.address2%TYPE;
        v_address3         gipi_parlist.address3%TYPE;
        v_load_tag         gipi_parlist.load_tag%TYPE;
        
    BEGIN
        BEGIN
            BEGIN
                SELECT gipi_pack_parlist_par_id.nextval
                  INTO p_copy_pack_par_id --:copy.pack_par_id
                  FROM DUAL;            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Cannot generate new PAR ID.');
            END;
        
            FOR par IN (SELECT b.par_type type
                          FROM gipi_pack_polbasic a, gipi_pack_parlist b
                         WHERE a.pack_policy_id = p_policy_id
                           AND a.pack_par_id    = b.pack_par_id) 
            LOOP
                p_parameter_par_type := par.type; --:parameter.par_type
                EXIT;
            END LOOP; 
        
        
              SELECT p_copy_pack_par_id, a.line_cd, a.iss_cd, TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2)),
                   0, b.par_type, b.assd_no, p_user_id, 'Y', 5, b.address1, b.address2, b.address3,'C'
              INTO v_par_id, v_line_cd, v_iss_cd, v_par_yy,
                   v_quote_seq_no, v_par_type, v_assd_no, v_underwriter, v_assign_sw, v_par_status, v_address1, v_address2, v_address3, v_load_tag
              FROM gipi_pack_polbasic a, gipi_pack_parlist b
             WHERE a.pack_policy_id = p_policy_id 
               AND a.pack_par_id    = b.pack_par_id; 
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN 
                RAISE_APPLICATION_ERROR(-20001,'Exception occurred.There is no existing record.');
        END;
        
        INSERT INTO gipi_pack_parlist
                    (pack_par_id, line_cd, iss_cd, par_yy, quote_seq_no, par_type, assd_no, underwriter,
                     assign_sw, par_status, address1, address2, address3)
             VALUES (v_par_id, v_line_cd, p_par_iss_cd, v_par_yy, v_quote_seq_no, v_par_type, v_assd_no, v_underwriter,
                     v_assign_sw, v_par_status, v_address1, v_address2, v_address3); 
        
    END insert_into_pack_parlist;
    
    PROCEDURE insert_into_pack_parhist(
        p_copy_pack_par_id  gipi_parlist.pack_par_id%TYPE,
        p_user_id           gipi_polbasic.user_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gipi_pack_parhist
                    (pack_par_id,user_id, parstat_date, entry_source, parstat_cd)
             VALUES (p_copy_pack_par_id, p_user_id, sysdate, 'DB', '1');
    END insert_into_pack_parhist;
    
    PROCEDURE copy_pack_polbasic(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_line_cd            gipi_polbasic.line_cd%TYPE,
        p_subline_cd         gipi_polbasic.subline_cd%TYPE,
        p_iss_cd             gipi_polbasic.iss_cd%TYPE,
        p_par_iss_cd         gipi_polbasic.iss_cd%TYPE,
        p_issue_yy           gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no           gipi_polbasic.renew_no%TYPE,
        p_variables_iss_cd   gipi_polbasic.iss_cd%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    ) AS
        v_line_cd              gipi_pack_polbasic.line_cd%TYPE; 
        v_subline_cd           gipi_pack_polbasic.subline_cd%TYPE; 
        v_iss_cd               gipi_pack_polbasic.iss_cd%TYPE; 
        v_issue_yy             gipi_pack_polbasic.issue_yy%TYPE; 
        v_pol_seq_no           gipi_pack_polbasic.pol_seq_no%TYPE; 
        v_endt_iss_cd          gipi_pack_polbasic.endt_iss_cd%TYPE;   
        v_endt_yy              gipi_pack_polbasic.endt_yy%TYPE; 
        v_endt_seq_no          gipi_pack_polbasic.endt_seq_no%TYPE; 
        v_renew_no             gipi_pack_polbasic.renew_no%TYPE; 
        v_endt_type            gipi_pack_polbasic.endt_TYPE%TYPE; 
        v_assd_no              gipi_pack_polbasic.assd_no%TYPE; 
        v_designation          gipi_pack_polbasic.designation%TYPE; 
        v_mortg_name           gipi_pack_polbasic.mortg_name%TYPE; 
        v_tsi_amt              gipi_pack_polbasic.tsi_amt%TYPE; 
        v_prem_amt             gipi_pack_polbasic.prem_amt%TYPE; 
        v_ann_tsi_amt          gipi_pack_polbasic.ann_tsi_amt%TYPE; 
        v_ann_prem_amt         gipi_pack_polbasic.ann_prem_amt%TYPE; 
        v_invoice_sw           gipi_pack_polbasic.invoice_sw%TYPE; 
        v_pool_pol_no          gipi_pack_polbasic.pool_pol_no%TYPE; 
        v_address1             gipi_pack_polbasic.address1%TYPE; 
        v_address2             gipi_pack_polbasic.address2%TYPE; 
        v_address3             gipi_pack_polbasic.address3%TYPE; 
        v_orig_policy_id       gipi_pack_polbasic.orig_policy_id%TYPE; 
        v_endt_expiry_date     gipi_pack_polbasic.endt_expiry_date%TYPE; 
        v_no_of_items          gipi_pack_polbasic.no_of_items%TYPE; 
        v_subline_type_cd      gipi_pack_polbasic.subline_type_cd%TYPE; 
        v_auto_renew_flag      gipi_pack_polbasic.auto_renew_flag%TYPE; 
        v_prorate_flag         gipi_pack_polbasic.prorate_flag%TYPE; 
        v_short_rt_percent     gipi_pack_polbasic.short_rt_percent%TYPE; 
        v_prov_prem_tag        gipi_pack_polbasic.prov_prem_tag%TYPE; 
        v_type_cd              gipi_pack_polbasic.type_cd%TYPE; 
        v_acct_of_cd           gipi_pack_polbasic.acct_of_cd%TYPE; 
        v_prov_prem_pct        gipi_pack_polbasic.prov_prem_pct%TYPE; 
        v_pack_pol_flag        gipi_pack_polbasic.pack_pol_flag%TYPE; 
        v_prem_warr_tag        gipi_pack_polbasic.prem_warr_tag%TYPE;
        v_ref_pol_no           gipi_pack_polbasic.ref_pol_no%TYPE;
        v_expiry_date          gipi_pack_polbasic.endt_expiry_date%TYPE;              
        v_incept_date          gipi_pack_polbasic.endt_expiry_date%TYPE; 
        v_discount_sw          gipi_pack_polbasic.discount_sw%TYPE;
        v_reg_policy_sw        gipi_pack_polbasic.reg_policy_sw%TYPE;
        v_co_insurance_sw      gipi_pack_polbasic.co_insurance_sw%TYPE;
        v_ref_open_pol_no      gipi_pack_polbasic.ref_open_pol_no%TYPE;
        v_fleet_print_tag      gipi_pack_polbasic.fleet_print_tag%TYPE;
        v_incept_tag           gipi_pack_polbasic.incept_tag%TYPE;
        v_expiry_tag           gipi_pack_polbasic.expiry_tag%TYPE;
        v_endt_expiry_tag      gipi_pack_polbasic.endt_expiry_tag%TYPE;
        v_foreign_acc_sw       gipi_pack_polbasic.foreign_acc_sw%TYPE;            
        v_comp_sw              gipi_pack_polbasic.comp_sw%TYPE;   
        v_with_tariff_sw       gipi_pack_polbasic.with_tariff_sw%TYPE;
        v_place_cd             gipi_pack_polbasic.place_cd%TYPE;
        v_subline_time         NUMBER;
        v_surcharge_sw         gipi_pack_polbasic.surcharge_sw%TYPE;
        v_region_cd            gipi_pack_polbasic.region_cd%TYPE;    
        v_industry_cd          gipi_pack_polbasic.industry_cd%TYPE;
        v_cred_branch          gipi_pack_polbasic.cred_branch%TYPE;
        v_booking_mth          gipi_wpolbas.booking_mth%TYPE;
        v_booking_year         gipi_wpolbas.booking_year%TYPE;
        var_vdate              giis_parameters.param_value_n%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, endt_iss_cd, endt_yy,
               endt_seq_no, renew_no, invoice_sw, auto_renew_flag,
               prov_prem_tag, pack_pol_flag, reg_policy_sw, co_insurance_sw,
               endt_type, incept_date, expiry_date, expiry_tag, assd_no, designation,
               address1, address2, address3,
               DECODE(p_par_iss_cd, p_variables_iss_cd, mortg_name, NULL) mortg_name,
               tsi_amt, prem_amt, ann_tsi_amt,
               ann_prem_amt, pool_pol_no, foreign_acc_sw, discount_sw, orig_policy_id,
               endt_expiry_date, no_of_items, subline_type_cd, prorate_flag, short_rt_percent,
               type_cd, DECODE(acct_of_cd, 0, NULL, acct_of_cd), prov_prem_pct,
               prem_warr_tag, ref_pol_no, ref_open_pol_no, incept_tag, comp_sw,
               endt_expiry_tag, fleet_print_tag, with_tariff_sw, place_cd,
               surcharge_sw, region_cd, industry_cd, cred_branch
          INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_endt_iss_cd,
               v_endt_yy, v_endt_seq_no, v_renew_no, v_invoice_sw, v_auto_renew_flag,
               v_prov_prem_tag, v_pack_pol_flag, v_reg_policy_sw, v_co_insurance_sw,
               v_endt_type, v_incept_date, v_expiry_date, v_expiry_tag, v_assd_no, v_designation,
               v_address1, v_address2, v_address3,
               v_mortg_name,
               v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
               v_ann_prem_amt, v_pool_pol_no, v_foreign_acc_sw, v_discount_sw, v_orig_policy_id,
               v_endt_expiry_date, v_no_of_items, v_subline_type_cd, v_prorate_flag, v_short_rt_percent,
               v_type_cd, v_acct_of_cd, v_prov_prem_pct,
               v_prem_warr_tag, v_ref_pol_no, v_ref_open_pol_no, v_incept_tag, v_comp_sw,
               v_endt_expiry_tag, v_fleet_print_tag, v_with_tariff_sw, v_place_cd,
               v_surcharge_sw, v_region_cd, v_industry_cd, v_cred_branch  
          FROM gipi_pack_polbasic
         WHERE pack_policy_id = p_policy_id;
         
        FOR A IN (SELECT subline_time
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd) 
        LOOP
            v_subline_time := TO_NUMBER(a.subline_time);               
            EXIT;
        END LOOP;
        
        IF v_endt_seq_no != 0 THEN
            v_endt_seq_no := 0;
            v_address1    := NULL;
            v_address2    := NULL;
            v_address3    := NULL;
            v_assd_no     := NULL;
            v_designation := NULL;
            v_tsi_amt     := 0;
            v_prem_amt    := 0;
            FOR A1 IN (SELECT b250.ann_tsi_amt tsi, b250.ann_prem_amt prem
                         FROM gipi_pack_polbasic b250
                        WHERE b250.line_cd     = p_line_cd
                          AND b250.subline_cd  = p_subline_cd
                          AND b250.iss_cd      = p_iss_cd
                          AND b250.issue_yy    = p_issue_yy
                          AND b250.pol_seq_no  = p_pol_seq_no
                          AND b250.renew_no    = p_renew_no
                          AND b250.pol_flag    IN ('1','2','3') 
                          AND b250.eff_date    = (SELECT MAX(b2501.eff_date)
                                                    FROM gipi_pack_polbasic b2501
                                                   WHERE b2501.line_cd     = p_line_cd
                                                     AND b2501.subline_cd  = p_subline_cd
                                                        AND b2501.iss_cd   = p_iss_cd
                                                     AND b2501.issue_yy    = p_issue_yy
                                                     AND b2501.pol_seq_no  = p_pol_seq_no
                                                     AND b2501.renew_no    = p_renew_no
                                                     AND b2501.pol_flag    IN ('1','2','3'))
                        ORDER BY b250.last_upd_date DESC)
            LOOP
                v_ann_tsi_amt   := A1.tsi;
                v_ann_prem_amt  := A1.prem;
                EXIT;
            END LOOP;        
        ELSE
            v_incept_date := TRUNC(SYSDATE) + (NVL(v_subline_time,0)/86400);
            v_expiry_date := ADD_MONTHS(v_incept_date,12);
            v_pol_seq_no  := NULL;
            v_issue_yy    := TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2));
        END IF;
        
        FOR C IN (SELECT param_value_n
                    FROM giac_parameters
                   WHERE param_name = 'PROD_TAKE_UP')
        LOOP
            var_vdate := c.param_value_n;
        END LOOP;
                                
        IF var_vdate > 3 THEN
            RAISE_APPLICATION_ERROR(-20001,'Exception occurred.The parameter value ('||TO_CHAR(var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.');        
        END IF;
                
        IF var_vdate = 1 OR (var_vdate = 3 AND SYSDATE > v_incept_date) THEN
            FOR C IN (SELECT booking_year,
                              TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth, 1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM'), booking_mth --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013 
                        FROM giis_booking_month
                         WHERE (NVL(booked_tag, 'N') != 'Y')
                           AND (booking_year > TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                                   OR (booking_year = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                                       AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth, 1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM')) >= TO_NUMBER(TO_CHAR(SYSDATE, 'MM')))) --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                         ORDER BY 1, 2)
            LOOP
                v_booking_year := TO_NUMBER(c.booking_year);       
                v_booking_mth  := c.booking_mth;              
                EXIT;
            END LOOP;                     
        ELSIF var_vdate = 2 OR (var_vdate = 3 AND SYSDATE <= v_incept_date) THEN                  
            FOR C IN (SELECT booking_year, TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth, 1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM') aliass, booking_mth --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                          FROM giis_booking_month
                       WHERE (NVL(booked_tag, 'N') <> 'Y')
                         AND (booking_year > to_number(to_char(v_incept_date, 'YYYY'))
                              OR (booking_year = to_number(to_char(v_incept_date, 'YYYY'))
                                  AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth, 1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM')) >= TO_NUMBER(TO_CHAR(v_incept_date, 'MM')))) --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                       ORDER BY 1, 2)
            LOOP
                v_booking_year := TO_NUMBER(c.booking_year);       
                v_booking_mth  := c.booking_mth;              
                EXIT;
            END LOOP;                  
        END IF; 
        
        INSERT INTO gipi_pack_wpolbas
                    (pack_par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, endt_iss_cd,
                     endt_yy, endt_seq_no, renew_no, endt_type, incept_date, expiry_date, booking_year, booking_mth,
                     eff_date, issue_date, pol_flag, assd_no, designation, mortg_name,
                     tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, invoice_sw, pool_pol_no, 
                     user_id, quotation_printed_sw, covernote_printed_sw, address1, address2, 
                     address3, orig_policy_id, endt_expiry_date, no_of_items, subline_type_cd, 
                     auto_renew_flag, prorate_flag, short_rt_percent, prov_prem_tag,
                     type_cd, acct_of_cd, prov_prem_pct, same_polno_sw, pack_pol_flag, 
                     prem_warr_tag, discount_sw, reg_policy_sw, co_insurance_sw, ref_open_pol_no,
                     fleet_print_tag, incept_tag, expiry_tag, endt_expiry_tag, foreign_acc_sw, 
                     comp_sw, with_tariff_sw, place_cd, surcharge_sw, region_cd, industry_cd, cred_branch)
             VALUES (p_copy_pack_par_id, v_line_cd, v_subline_cd, p_par_iss_cd, v_issue_yy, v_pol_seq_no, v_endt_iss_cd,
                     v_endt_yy, v_endt_seq_no, 00, v_endt_type, v_incept_date, v_expiry_date, v_booking_year, v_booking_mth,
                     v_incept_date, SYSDATE, '1', v_assd_no, v_designation, v_mortg_name,
                     v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt, v_invoice_sw, v_pool_pol_no,
                     p_user_id, 'N','N', v_address1, v_address2, 
                     v_address3, v_orig_policy_id, v_endt_expiry_date, v_no_of_items, v_subline_type_cd,
                     v_auto_renew_flag, v_prorate_flag, v_short_rt_percent, v_prov_prem_tag,
                     v_type_cd, v_acct_of_cd, v_prov_prem_pct, 'N', v_pack_pol_flag,
                     v_prem_warr_tag, v_discount_sw, v_reg_policy_sw, v_co_insurance_sw, v_ref_open_pol_no,
                     v_fleet_print_tag, v_incept_tag, v_expiry_tag, v_endt_expiry_tag, v_foreign_acc_sw,
                     NVL(v_comp_sw, 'N'), v_with_tariff_sw, v_place_cd, v_surcharge_sw, v_region_cd, v_industry_cd, v_cred_branch);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_pack_polbasic;
    
    PROCEDURE copy_pack_polgenin(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gipi_pack_wpolgenin
                    (pack_par_id, gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, gen_info06, gen_info07, gen_info08, gen_info09, 
                    gen_info10, gen_info11, gen_info12, gen_info13, gen_info14, gen_info15, gen_info16, gen_info17, genin_info_cd,
                    initial_info01, initial_info02, initial_info03, initial_info04, initial_info05, initial_info06, initial_info07,
                    initial_info08, initial_info09, initial_info10, initial_info11, initial_info12, initial_info13, initial_info14, 
                    initial_info15, initial_info16, initial_info17, user_id, last_update)
             SELECT p_copy_pack_par_id, gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, gen_info06, gen_info07, gen_info08, gen_info09,
                    gen_info10, gen_info11, gen_info12, gen_info13, gen_info14, gen_info15, gen_info16, gen_info17, genin_info_cd,
                    initial_info01, initial_info02, initial_info03, initial_info04, initial_info05, initial_info06, initial_info07,
                    initial_info08, initial_info09, initial_info10, initial_info11, initial_info12, initial_info13, initial_info14, 
                    initial_info15, initial_info16, initial_info17, p_user_id, SYSDATE
               FROM gipi_pack_polgenin
              WHERE pack_policy_id = p_policy_id;         
    END copy_pack_polgenin;      
    
    PROCEDURE copy_pack_polwc(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR polwc_cur IS
        SELECT pack_policy_id, line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title, wc_remarks,
               wc_text01, wc_text02, wc_text03, wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09,
               wc_text10, wc_text11, wc_text12, wc_text13, wc_text14, wc_text15, wc_text16, wc_text17, rec_flag, change_tag
          FROM gipi_pack_polwc
         WHERE pack_policy_id  = p_policy_id;
        
        v_policy_id           gipi_pack_polwc.pack_policy_id%TYPE;
        v_line_cd             gipi_pack_polwc.line_cd%TYPE;
        v_wc_cd               gipi_pack_polwc.wc_cd%TYPE;
        v_swc_seq_no          gipi_pack_polwc.swc_seq_no%TYPE;
        v_print_seq_no        gipi_pack_polwc.print_seq_no%TYPE;
        v_wc_title            gipi_pack_polwc.wc_title%TYPE;
        v_wc_remarks          gipi_pack_polwc.wc_remarks%TYPE;
        v_rec_flag            gipi_pack_polwc.rec_flag%TYPE;
        v_wc_text01           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text02           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text03           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text04           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text05           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text06           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text07           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text08           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text09           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text10           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text11           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text12           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text13           gipi_pack_polwc.wc_text01%TYPE;
        v_wc_text14           gipi_pack_polwc.wc_text14%TYPE;
        v_wc_text15           gipi_pack_polwc.wc_text15%TYPE;
        v_wc_text16           gipi_pack_polwc.wc_text16%TYPE;
        v_wc_text17           gipi_pack_polwc.wc_text17%TYPE;
        v_change_tag          gipi_pack_polwc.change_tag%TYPE;
    BEGIN
        OPEN polwc_cur;
        LOOP
            FETCH polwc_cur
             INTO v_policy_id, v_line_cd, v_wc_cd, v_swc_seq_no, v_print_seq_no, v_wc_title, v_wc_remarks,
                  v_wc_text01, v_wc_text02, v_wc_text03, v_wc_text04, v_wc_text05, v_wc_text06, v_wc_text07, v_wc_text08, v_wc_text09,
                  v_wc_text10, v_wc_text11, v_wc_text12, v_wc_text13, v_wc_text14, v_wc_text15, v_wc_text16, v_wc_text17, v_rec_flag, v_change_tag;
            EXIT WHEN polwc_cur%NOTFOUND;
            
            INSERT INTO gipi_pack_wpolwc
                        (pack_par_id, line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title, wc_remarks, wc_text01, wc_text02,
                        wc_text03, wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09, wc_text10, wc_text11, wc_text12,
                        wc_text13, wc_text14, wc_text15, wc_text16, wc_text17, rec_flag, change_tag)     
                 VALUES (p_copy_pack_par_id, v_line_cd, v_wc_cd, v_swc_seq_no, v_print_seq_no, v_wc_title, v_wc_remarks, v_wc_text01, v_wc_text02,
                        v_wc_text03, v_wc_text04, v_wc_text05, v_wc_text06, v_wc_text07, v_wc_text08, v_wc_text09, v_wc_text10, v_wc_text11, v_wc_text12,
                        v_wc_text13, v_wc_text14, v_wc_text15, v_wc_text16, v_wc_text17, v_rec_flag, v_change_tag);
        END LOOP;
        CLOSE polwc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_pack_polwc;
    
    PROCEDURE copy_pack_endttext(
        p_policy_id          gipi_polbasic.policy_id%TYPE,
        p_copy_pack_par_id   gipi_polbasic.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gipi_pack_wendttext
                    (pack_par_id, endt_tax, endt_text01, endt_text02, endt_text03, endt_text04, endt_text05, endt_text06, endt_text07, 
                    endt_text08, endt_text09, endt_text10, endt_text11, endt_text12, endt_text13, endt_text14, endt_text15, endt_text16, 
                    endt_text17, endt_cd, user_id, last_update)
             SELECT p_copy_pack_par_id, endt_tax, endt_text01, endt_text02, endt_text03, endt_text04, endt_text05, endt_text06, endt_text07, 
                    endt_text08, endt_text09, endt_text10, endt_text11, endt_text12, endt_text13, endt_text14, endt_text15, endt_text16, 
                    endt_text17, endt_cd, p_user_id, SYSDATE
               FROM gipi_endttext
              WHERE EXISTS (SELECT 1
                              FROM gipi_polbasic z
                             WHERE z.policy_id = gipi_endttext.policy_id
                               AND z.policy_id = p_policy_id)
                AND ROWNUM = 1;
    END copy_pack_endttext;
    
    PROCEDURE insert_into_parlist(
        p_policy_id          IN  gipi_polbasic.policy_id%TYPE,
        p_copy_par_id        OUT gipi_parlist.par_id%TYPE,
        p_user_id            IN  gipi_polbasic.user_id%TYPE,
        p_copy_pack_par_id   IN  gipi_polbasic.par_id%TYPE,
        p_parameter_par_type OUT gipi_parlist.par_type%TYPE,
        p_par_iss_cd         IN  gipi_polbasic.iss_cd%TYPE
    ) AS
        v_par_id          gipi_parlist.par_id%TYPE;
        v_line_cd         gipi_parlist.line_cd%TYPE;  
        v_iss_cd          gipi_parlist.iss_cd%TYPE;
        v_par_yy          gipi_parlist.par_yy%TYPE;
        v_quote_seq_no    gipi_parlist.quote_seq_no%TYPE;
        v_par_type        gipi_parlist.par_type%TYPE;
        v_assd_no         gipi_parlist.assd_no%TYPE;
        v_underwriter     gipi_parlist.underwriter%TYPE;
        v_assign_sw       gipi_parlist.assign_sw%TYPE;
        v_par_status      gipi_parlist.par_status%TYPE; 
        v_address1        gipi_parlist.address1%TYPE;
        v_address2        gipi_parlist.address2%TYPE;
        v_address3        gipi_parlist.address3%TYPE;
        v_load_tag        gipi_parlist.load_tag%TYPE; 
    BEGIN
        BEGIN
            SELECT parlist_par_id_s.nextval
              INTO p_copy_par_id -- :copy.par_id
              FROM DUAL;            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001,'Exception occurred.Cannot generate new PAR ID.');
        END;   
        
        BEGIN
  	        SELECT p_copy_par_id, a.line_cd, a.iss_cd, to_number(substr(to_char(sysdate,'MM-DD-YYYY'),9,2)),
                   0, b.par_type, b.assd_no, p_user_id, 'Y', 5, b.address1, b.address2, b.address3, 'C'
              INTO v_par_id, v_line_cd, v_iss_cd, v_par_yy, 
                   v_quote_seq_no, v_par_type, v_assd_no, v_underwriter, v_assign_sw, v_par_status, v_address1, v_address2, v_address3, v_load_tag
              FROM gipi_polbasic a, gipi_parlist b
             WHERE a.policy_id = p_policy_id 
               AND a.par_id    = b.par_id; 
        END;
        
        BEGIN
  	        INSERT INTO gipi_parlist
                        (par_id, line_cd, iss_cd, par_yy, quote_seq_no, par_type, assd_no, underwriter, assign_sw,
                        par_status, address1, address2, address3, load_tag, pack_par_id)
                 VALUES (v_par_id, v_line_cd, p_par_iss_cd, v_par_yy, v_quote_seq_no, v_par_type, v_assd_no, v_underwriter, v_assign_sw,
                        v_par_status, v_address1, v_address2, v_address3, v_load_tag, p_copy_pack_par_id);
        END;      
                
        FOR par IN (SELECT b.par_type type
                      FROM gipi_polbasic a, gipi_parlist b
                     WHERE a.policy_id = p_policy_id
                       AND a.par_id    = b.par_id) 
        LOOP
            p_parameter_par_type := par.type;
            EXIT;
        END LOOP; 
        
    END insert_into_parlist;
    
    PROCEDURE insert_into_parhist(
        p_copy_par_id        gipi_parlist.par_id%TYPE,
        p_user_id            gipi_polbasic.user_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gipi_parhist
                    (par_id, user_id, parstat_date, entry_source, parstat_cd)
             VALUES (p_copy_par_id, p_user_id, SYSDATE, 'DB', '1');
    END insert_into_parhist;
    
    PROCEDURE copy_polbasic(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_variables_line_cd    gipi_polbasic.line_cd%TYPE,
        p_variables_subline_cd gipi_polbasic.subline_cd%TYPE,
        p_variables_iss_cd     gipi_polbasic.iss_cd%TYPE,
        p_variables_issue_yy   gipi_polbasic.issue_yy%TYPE,
        p_variables_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
        p_variables_renew_no   gipi_polbasic.renew_no%TYPE,
        p_par_iss_cd           gipi_polbasic.iss_cd%TYPE,
        p_copy_pack_par_id     gipi_polbasic.par_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    ) AS
        v_line_cd              gipi_polbasic.line_cd%TYPE; 
        v_subline_cd           gipi_polbasic.subline_cd%TYPE; 
        v_iss_cd               gipi_polbasic.iss_cd%TYPE; 
        v_issue_yy             gipi_polbasic.issue_yy%TYPE; 
        v_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE; 
        v_endt_iss_cd          gipi_polbasic.endt_iss_cd%TYPE;   
        v_endt_yy              gipi_polbasic.endt_yy%TYPE; 
        v_endt_seq_no          gipi_polbasic.endt_seq_no%TYPE; 
        v_renew_no             gipi_polbasic.renew_no%TYPE; 
        v_endt_type            gipi_polbasic.endt_type%TYPE; 
        v_assd_no              gipi_polbasic.assd_no%TYPE; 
        v_designation          gipi_polbasic.designation%TYPE; 
        v_mortg_name           gipi_polbasic.mortg_name%TYPE; 
        v_tsi_amt              gipi_polbasic.tsi_amt%TYPE; 
        v_prem_amt             gipi_polbasic.prem_amt%TYPE; 
        v_ann_tsi_amt          gipi_polbasic.ann_tsi_amt%TYPE; 
        v_ann_prem_amt         gipi_polbasic.ann_prem_amt%TYPE; 
        v_invoice_sw           gipi_polbasic.invoice_sw%TYPE; 
        v_pool_pol_no          gipi_polbasic.pool_pol_no%TYPE; 
        v_address1             gipi_polbasic.address1%TYPE; 
        v_address2             gipi_polbasic.address2%TYPE; 
        v_address3             gipi_polbasic.address3%TYPE; 
        v_orig_policy_id       gipi_polbasic.orig_policy_id%TYPE; 
        v_endt_expiry_date     gipi_polbasic.endt_expiry_date%TYPE; 
        v_no_of_items          gipi_polbasic.no_of_items%TYPE; 
        v_subline_type_cd      gipi_polbasic.subline_type_cd%TYPE; 
        v_auto_renew_flag      gipi_polbasic.auto_renew_flag%TYPE; 
        v_prorate_flag         gipi_polbasic.prorate_flag%TYPE; 
        v_short_rt_percent     gipi_polbasic.short_rt_percent%TYPE; 
        v_prov_prem_tag        gipi_polbasic.prov_prem_tag%TYPE; 
        v_type_cd              gipi_polbasic.type_cd%TYPE; 
        v_acct_of_cd           gipi_polbasic.acct_of_cd%TYPE; 
        v_prov_prem_pct        gipi_polbasic.prov_prem_pct%TYPE; 
        v_pack_pol_flag        gipi_polbasic.pack_pol_flag%TYPE; 
        v_prem_warr_tag        gipi_polbasic.prem_warr_tag%TYPE;
        v_ref_pol_no           gipi_polbasic.ref_pol_no%TYPE;
        v_expiry_date          gipi_polbasic.endt_expiry_date%TYPE;              
        v_incept_date          gipi_polbasic.endt_expiry_date%TYPE; 
        v_discount_sw          gipi_polbasic.discount_sw%TYPE;
        v_reg_policy_sw        gipi_polbasic.reg_policy_sw%TYPE;
        v_co_insurance_sw      gipi_polbasic.co_insurance_sw%TYPE;
        v_ref_open_pol_no      gipi_polbasic.ref_open_pol_no%TYPE;
        v_fleet_print_tag      gipi_polbasic.fleet_print_tag%TYPE;
        v_incept_tag           gipi_polbasic.incept_tag%TYPE;
        v_expiry_tag           gipi_polbasic.expiry_tag%TYPE;      
        v_endt_expiry_tag      gipi_polbasic.endt_expiry_tag%TYPE;
        v_foreign_acc_sw       gipi_polbasic.foreign_acc_sw%TYPE;            
        v_comp_sw              gipi_polbasic.comp_sw%TYPE;   
        v_with_tariff_sw       gipi_polbasic.with_tariff_sw%TYPE;
        v_place_cd             gipi_polbasic.place_cd%TYPE;
        v_subline_time         NUMBER;
        v_surcharge_sw         gipi_polbasic.surcharge_sw%TYPE;
        v_region_cd            gipi_polbasic.region_cd%TYPE;    
        v_industry_cd          gipi_polbasic.industry_cd%TYPE;
        v_cred_branch          gipi_polbasic.cred_branch%TYPE;  
        v_booking_mth          gipi_wpolbas.booking_mth%TYPE;
        v_booking_year         gipi_wpolbas.booking_year%TYPE;
        var_vdate              giis_parameters.param_value_n%TYPE;
        v_acct_of_cd_sw        gipi_polbasic.acct_of_cd_sw%TYPE;
        v_back_stat            gipi_polbasic.back_stat%TYPE;    
        v_cancel_date          gipi_polbasic.cancel_date%TYPE;
        v_eff_date             gipi_polbasic.eff_date%TYPE;
        v_issue_date           gipi_polbasic.issue_date%TYPE;    
        v_label_tag            gipi_polbasic.label_tag%TYPE;
        v_manual_renew_no      gipi_polbasic.manual_renew_no%TYPE;
    BEGIN
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, endt_iss_cd, endt_yy,
               endt_seq_no, renew_no, invoice_sw, auto_renew_flag,
               prov_prem_tag, pack_pol_flag, reg_policy_sw, co_insurance_sw,
               endt_type, incept_date, expiry_date, expiry_tag, assd_no, designation,
               address1, address2, address3,
               DECODE(p_par_iss_cd, p_variables_iss_cd, mortg_name, NULL) mortg_name,
               tsi_amt, prem_amt, ann_tsi_amt,
               ann_prem_amt, pool_pol_no, foreign_acc_sw, discount_sw, orig_policy_id,
               endt_expiry_date, no_of_items, subline_type_cd, prorate_flag, short_rt_percent,
               type_cd, DECODE(acct_of_cd, 0, NULL, acct_of_cd), prov_prem_pct,
               prem_warr_tag, ref_pol_no, ref_open_pol_no, incept_tag, comp_sw,
               endt_expiry_tag, fleet_print_tag, with_tariff_sw, place_cd,
               surcharge_sw, region_cd, industry_cd, cred_branch,
               acct_of_cd_sw, back_stat, cancel_date, eff_date, issue_date, label_tag, manual_renew_no
          INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_endt_iss_cd, v_endt_yy,
               v_endt_seq_no, v_renew_no, v_invoice_sw, v_auto_renew_flag,
               v_prov_prem_tag, v_pack_pol_flag, v_reg_policy_sw, v_co_insurance_sw,
               v_endt_type, v_incept_date, v_expiry_date, v_expiry_tag, v_assd_no, v_designation,
               v_address1, v_address2, v_address3,
               v_mortg_name,
               v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
               v_ann_prem_amt, v_pool_pol_no, v_foreign_acc_sw, v_discount_sw, v_orig_policy_id,
               v_endt_expiry_date, v_no_of_items, v_subline_type_cd, v_prorate_flag, v_short_rt_percent,
               v_type_cd, v_acct_of_cd, v_prov_prem_pct,
               v_prem_warr_tag, v_ref_pol_no, v_ref_open_pol_no, v_incept_tag, v_comp_sw,
               v_endt_expiry_tag, v_fleet_print_tag, v_with_tariff_sw, v_place_cd,
               v_surcharge_sw, v_region_cd, v_industry_cd, v_cred_branch,
               v_acct_of_cd_sw, v_back_stat, v_cancel_date, v_eff_date, v_issue_date, v_label_tag, v_manual_renew_no  
          FROM gipi_polbasic
         WHERE policy_id = p_policy_id;
         
        FOR a IN (SELECT subline_time
                    FROM giis_subline 
                   WHERE line_cd = p_variables_line_cd
                     AND subline_cd = p_variables_subline_cd )
        LOOP
            v_subline_time := TO_NUMBER(a.subline_time);               
            EXIT;
        END LOOP; 
        
        IF v_endt_seq_no != 0 THEN
            v_endt_seq_no := 0;
            v_address1    := NULL;
            v_address2    := NULL;
            v_address3    := NULL;
            v_assd_no     := NULL;
            v_designation := NULL;
            v_tsi_amt   := 0;
            v_prem_amt  := 0;
            FOR a1 IN (SELECT b250.ann_tsi_amt tsi, b250.ann_prem_amt prem
                         FROM gipi_polbasic b250 
                        WHERE b250.line_cd     = p_variables_line_cd
                          AND b250.subline_cd  = p_variables_subline_cd
                          AND b250.iss_cd      = p_variables_iss_cd
                          AND b250.issue_yy    = p_variables_issue_yy
                          AND b250.pol_seq_no  = p_variables_pol_seq_no
                          AND b250.renew_no    = p_variables_renew_no
                          AND b250.pol_flag    IN ('1','2','3') 
                          AND b250.eff_date    = (SELECT MAX(b2501.eff_date)
                                                    FROM gipi_polbasic b2501 
                                                   WHERE b250.line_cd     = p_variables_line_cd
                                                     AND b250.subline_cd  = p_variables_subline_cd
                                                     AND b250.iss_cd      = p_variables_iss_cd
                                                     AND b250.issue_yy    = p_variables_issue_yy
                                                     AND b250.pol_seq_no  = p_variables_pol_seq_no
                                                     AND b250.renew_no    = p_variables_renew_no
                                                     AND b2501.pol_flag   IN ('1','2','3'))
                        ORDER BY b250.last_upd_date DESC)
            LOOP
                v_ann_tsi_amt  := A1.tsi;
                v_ann_prem_amt := A1.prem;
                EXIT;
            END LOOP;        
        ELSE
            v_incept_date := TRUNC(SYSDATE) + (NVL(v_subline_time,0)/86400);
            v_expiry_date := ADD_MONTHS(v_incept_date,12);
            v_pol_seq_no  := NULL;
            v_issue_yy    := TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2));
        END IF;
        
        FOR c IN (SELECT param_value_n
                    FROM giac_parameters
                   WHERE param_name = 'PROD_TAKE_UP')
        LOOP
            var_vdate := c.param_value_n;
        END LOOP;
        
        IF var_vdate > 3 THEN
            RAISE_APPLICATION_ERROR(-20001,'Exception occurred.The parameter value ('||TO_CHAR(var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.');        
        END IF;        
  
        IF var_vdate = 1 OR (var_vdate = 3 AND SYSDATE > v_incept_date) THEN
            FOR c IN (SELECT booking_year, TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM'), booking_mth --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                        FROM giis_booking_month
                       WHERE (NVL(booked_tag, 'N') != 'Y')
                         AND (booking_year > TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                              OR (booking_year = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                                  AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM')) >= TO_NUMBER(TO_CHAR(SYSDATE, 'MM')))) --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                       ORDER BY 1, 2)
            LOOP
                v_booking_year := TO_NUMBER(c.booking_year);       
                v_booking_mth  := c.booking_mth;              
                EXIT;
            END LOOP;                     
        ELSIF var_vdate = 2 OR (var_vdate = 3 AND SYSDATE <= v_incept_date) THEN
            FOR c IN (SELECT booking_year, TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM'), booking_mth --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                        FROM giis_booking_month
                       WHERE (NVL(booked_tag, 'N') <> 'Y')
                           AND (booking_year > TO_NUMBER(TO_CHAR(v_incept_date, 'YYYY'))
                                OR (booking_year = TO_NUMBER(TO_CHAR(v_incept_date, 'YYYY'))
                                     AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)||booking_year, 'DD-MONTH-YYYY'), 'MM')) >= TO_NUMBER(TO_CHAR(v_incept_date, 'MM')))) --added 'DD-MONTH-YYYY' to avoid ORA-01858 reymon 05042013
                       ORDER BY 1, 2)
            LOOP
                v_booking_year := TO_NUMBER(c.booking_year);       
                v_booking_mth  := c.booking_mth;              
                EXIT;
            END LOOP;                     
        END IF; 
        
        INSERT INTO gipi_wpolbas
                    (par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, endt_iss_cd,
                    endt_yy, endt_seq_no, renew_no, endt_type, incept_date, expiry_date, booking_year, booking_mth,
                    eff_date, issue_date, pol_flag, assd_no, designation, mortg_name,
                    tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, invoice_sw, pool_pol_no, 
                    user_id, quotation_printed_sw, covernote_printed_sw, address1, address2, 
                    address3, orig_policy_id, endt_expiry_date, no_of_items, subline_type_cd, 
                    auto_renew_flag, prorate_flag, short_rt_percent, prov_prem_tag,
                    type_cd, acct_of_cd, prov_prem_pct, same_polno_sw, pack_pol_flag, 
                    prem_warr_tag, discount_sw, reg_policy_sw, co_insurance_sw, ref_open_pol_no,
                    fleet_print_tag, incept_tag, expiry_tag, endt_expiry_tag, foreign_acc_sw, 
                    comp_sw, with_tariff_sw, place_cd, surcharge_sw, region_cd, industry_cd, cred_branch,
                    acct_of_cd_sw, back_stat, cancel_date, label_tag, manual_renew_no, pack_par_id)
             VALUES (p_copy_par_id, v_line_cd, v_subline_cd, p_par_iss_cd, v_issue_yy, v_pol_seq_no, v_endt_iss_cd,
                    v_endt_yy, v_endt_seq_no, 00, v_endt_type, v_incept_date, v_expiry_date, v_booking_year, v_booking_mth, 
                    v_incept_date, SYSDATE, '1', v_assd_no, v_designation, v_mortg_name,
                    v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt, v_invoice_sw,  v_pool_pol_no,
                    p_user_id, 'N', 'N', v_address1, v_address2,
                    v_address3, v_orig_policy_id, v_endt_expiry_date, v_no_of_items, v_subline_type_cd,
                    v_auto_renew_flag, v_prorate_flag, v_short_rt_percent, v_prov_prem_tag,
                    v_type_cd, v_acct_of_cd, v_prov_prem_pct, 'N', v_pack_pol_flag,
                    v_prem_warr_tag, v_discount_sw, v_reg_policy_sw, v_co_insurance_sw, v_ref_open_pol_no,
                    v_fleet_print_tag, v_incept_tag, v_expiry_tag, v_endt_expiry_tag, v_foreign_acc_sw,
                    NVL(v_comp_sw, 'N'), v_with_tariff_sw, v_place_cd, v_surcharge_sw, v_region_cd, v_industry_cd, v_cred_branch,
                    v_acct_of_cd_sw, v_back_stat, v_cancel_date, v_label_tag, v_manual_renew_no, p_copy_pack_par_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;     
    END copy_polbasic;
    
    PROCEDURE copy_mortgagee(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_par_iss_cd           gipi_polbasic.iss_cd%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR mort_cur IS
        SELECT iss_cd, mortg_cd, item_no, amount, remarks, user_id, last_update, delete_sw          
          FROM gipi_mortgagee
         WHERE policy_id  = p_policy_id     
           AND iss_cd = p_par_iss_cd;
           
        v_policy_id               gipi_mortgagee.policy_id%TYPE; 
        v_iss_cd                  gipi_mortgagee.iss_cd%TYPE;      
        v_mortg_cd                gipi_mortgagee.mortg_cd%TYPE;  
        v_item_no                 gipi_mortgagee.item_no%TYPE;  
        v_amount                  gipi_mortgagee.amount%TYPE;  
        v_remarks                 gipi_mortgagee.remarks%TYPE;
        v_user_id                 gipi_mortgagee.user_id%TYPE;
        v_last_update             gipi_mortgagee.last_update%TYPE;  
        v_delete_sw               gipi_mortgagee.delete_sw%TYPE;
    BEGIN
        OPEN mort_cur;
        LOOP
            FETCH mort_cur
             INTO v_iss_cd, v_mortg_cd, v_item_no, v_amount, v_remarks, v_user_id, v_last_update, v_delete_sw;
            EXIT WHEN mort_cur%NOTFOUND;
             
            INSERT INTO gipi_wmortgagee
                        (par_id, iss_cd, mortg_cd, item_no, amount, remarks, user_id, last_update, delete_sw)
                 VALUES (p_copy_par_id, v_iss_cd, v_mortg_cd, v_item_no, v_amount, v_remarks, v_user_id, v_last_update, v_delete_sw);
        END LOOP;
        CLOSE mort_cur;             
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; 
    END copy_mortgagee;
    
    PROCEDURE copy_polgenin(
        p_policy_id            IN  gipi_polbasic.policy_id%TYPE,
        p_copy_v_long          OUT gipi_polgenin.gen_info%TYPE,
        p_copy_par_id          IN  gipi_polbasic.par_id%TYPE,
        p_user_id              IN  gipi_polbasic.user_id%TYPE
    ) AS
        v_gen01             gipi_polgenin.gen_info01%TYPE;
        v_gen02             gipi_polgenin.gen_info02%TYPE; 
        v_gen03             gipi_polgenin.gen_info03%TYPE;
        v_gen04             gipi_polgenin.gen_info04%TYPE;
        v_gen05             gipi_polgenin.gen_info05%TYPE;
        v_gen06             gipi_polgenin.gen_info06%TYPE;
        v_gen07             gipi_polgenin.gen_info07%TYPE;
        v_gen08             gipi_polgenin.gen_info08%TYPE;
        v_gen09             gipi_polgenin.gen_info09%TYPE;
        v_gen10             gipi_polgenin.gen_info10%TYPE;
        v_gen11             gipi_polgenin.gen_info11%TYPE;
        v_gen12             gipi_polgenin.gen_info12%TYPE;
        v_gen13             gipi_polgenin.gen_info13%TYPE;
        v_gen14             gipi_polgenin.gen_info14%TYPE;
        v_gen15             gipi_polgenin.gen_info15%TYPE;
        v_gen16             gipi_polgenin.gen_info16%TYPE;
        v_gen17             gipi_polgenin.gen_info17%TYPE;
        v_first_info        gipi_polgenin.first_info%TYPE;
        v_agreed_tag        gipi_wpolgenin.agreed_tag%TYPE;        
        v_genin_info_cd     gipi_wpolgenin.genin_info_cd%TYPE;
        v_initial_info01    gipi_wpolgenin.initial_info01%TYPE;
        v_initial_info02    gipi_wpolgenin.initial_info02%TYPE;
        v_initial_info03    gipi_wpolgenin.initial_info03%TYPE;
        v_initial_info04    gipi_wpolgenin.initial_info04%TYPE;
        v_initial_info05    gipi_wpolgenin.initial_info05%TYPE;
        v_initial_info06    gipi_wpolgenin.initial_info06%TYPE;
        v_initial_info07    gipi_wpolgenin.initial_info07%TYPE;
        v_initial_info08    gipi_wpolgenin.initial_info08%TYPE;
        v_initial_info09    gipi_wpolgenin.initial_info09%TYPE;
        v_initial_info10    gipi_wpolgenin.initial_info10%TYPE;
        v_initial_info11    gipi_wpolgenin.initial_info11%TYPE;
        v_initial_info12    gipi_wpolgenin.initial_info12%TYPE;
        v_initial_info13    gipi_wpolgenin.initial_info13%TYPE;
        v_initial_info14    gipi_wpolgenin.initial_info14%TYPE;
        v_initial_info15    gipi_wpolgenin.initial_info15%TYPE;
        v_initial_info16    gipi_wpolgenin.initial_info16%TYPE;
        v_initial_info17    gipi_wpolgenin.initial_info17%TYPE;
    BEGIN
        SELECT gen_info, gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, gen_info06, gen_info07, 
               gen_info08, gen_info09, gen_info10, gen_info11, gen_info12, gen_info13, gen_info14, gen_info15, 
               gen_info16, gen_info17, first_info, agreed_tag, genin_info_cd, initial_info01, initial_info02,
               initial_info03, initial_info04, initial_info05, initial_info06, initial_info07, initial_info08, 
               initial_info09, initial_info10, initial_info11, initial_info12, initial_info13, initial_info14, 
               initial_info15, initial_info16, initial_info17
          INTO p_copy_v_long, v_gen01, v_gen02, v_gen03, v_gen04, v_gen05, v_gen06, v_gen07,
               v_gen08, v_gen09, v_gen10, v_gen11, v_gen12, v_gen13, v_gen14, v_gen15,
               v_gen16, v_gen17, v_first_info, v_agreed_tag, v_genin_info_cd,  v_initial_info01, v_initial_info02,
               v_initial_info03, v_initial_info04, v_initial_info05, v_initial_info06, v_initial_info07, v_initial_info08,
               v_initial_info09, v_initial_info10, v_initial_info11, v_initial_info12, v_initial_info13, v_initial_info14, 
               v_initial_info15, v_initial_info16, v_initial_info17 
          FROM gipi_polgenin
         WHERE policy_id = p_policy_id;
         
        INSERT INTO gipi_wpolgenin
                    (par_id, gen_info, gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, gen_info06, gen_info07,
                    gen_info08, gen_info09, gen_info10, gen_info11, gen_info12, gen_info13, gen_info14, gen_info15,
                    gen_info16, gen_info17, first_info, user_id, last_update, agreed_tag, genin_info_cd, initial_info01, initial_info02,  
                    initial_info03, initial_info04, initial_info05, initial_info06, initial_info07, initial_info08,
                    initial_info09, initial_info10, initial_info11, initial_info12, initial_info13, initial_info14, 
                    initial_info15, initial_info16, initial_info17)
             VALUES (p_copy_par_id, p_copy_v_long, v_gen01, v_gen02, v_gen03, v_gen04, v_gen05, v_gen06, v_gen07,
                    v_gen08, v_gen09, v_gen10, v_gen11, v_gen12, v_gen13, v_gen14, v_gen15,
                    v_gen16, v_gen17, v_first_info, p_user_id, SYSDATE, v_agreed_tag, v_genin_info_cd, v_initial_info01, v_initial_info02, 
                    v_initial_info03, v_initial_info04, v_initial_info05, v_initial_info06, v_initial_info07, v_initial_info08,
                    v_initial_info09, v_initial_info10, v_initial_info11, v_initial_info12, v_initial_info13, v_initial_info14, 
                    v_initial_info15, v_initial_info16, v_initial_info17);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_polgenin;
    
    PROCEDURE copy_polwc(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR polwc_cur IS
        SELECT policy_id, line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title, wc_remarks, wc_text01, wc_text02, wc_text03, 
               wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09, wc_text10, wc_text11, wc_text12, wc_text13, 
               wc_text14, wc_text15, wc_text16, wc_text17, rec_flag, change_tag, wc_title2  
          FROM gipi_polwc
         WHERE policy_id  = p_policy_id;
         
        v_policy_id           gipi_polwc.policy_id%TYPE;
        v_line_cd             gipi_polwc.line_cd%TYPE;
        v_wc_cd               gipi_polwc.wc_cd%TYPE;
        v_swc_seq_no          gipi_polwc.swc_seq_no%TYPE;
        v_print_seq_no        gipi_polwc.print_seq_no%TYPE;
        v_wc_title            gipi_polwc.wc_title%TYPE;
        v_wc_title2           gipi_polwc.wc_title2%TYPE;
        v_wc_remarks          gipi_polwc.wc_remarks%TYPE;
        v_rec_flag            gipi_polwc.rec_flag%TYPE;
        v_wc_text01           gipi_polwc.wc_text01%TYPE;
        v_wc_text02           gipi_polwc.wc_text01%TYPE;
        v_wc_text03           gipi_polwc.wc_text01%TYPE;
        v_wc_text04           gipi_polwc.wc_text01%TYPE;
        v_wc_text05           gipi_polwc.wc_text01%TYPE;
        v_wc_text06           gipi_polwc.wc_text01%TYPE;
        v_wc_text07           gipi_polwc.wc_text01%TYPE;
        v_wc_text08           gipi_polwc.wc_text01%TYPE;
        v_wc_text09           gipi_polwc.wc_text01%TYPE;
        v_wc_text10           gipi_polwc.wc_text01%TYPE;
        v_wc_text11           gipi_polwc.wc_text01%TYPE;
        v_wc_text12           gipi_polwc.wc_text01%TYPE;
        v_wc_text13           gipi_polwc.wc_text01%TYPE;
        v_wc_text14           gipi_polwc.wc_text14%TYPE;
        v_wc_text15           gipi_polwc.wc_text15%TYPE;
        v_wc_text16           gipi_polwc.wc_text16%TYPE;
        v_wc_text17           gipi_polwc.wc_text17%TYPE;
        v_change_tag          gipi_polwc.change_tag%TYPE;
    BEGIN
        OPEN polwc_cur;
        LOOP
            FETCH polwc_cur        
             INTO v_policy_id, v_line_cd, v_wc_cd, v_swc_seq_no, v_print_seq_no, v_wc_title, v_wc_remarks, v_wc_text01, v_wc_text02, v_wc_text03,
                  v_wc_text04, v_wc_text05, v_wc_text06, v_wc_text07, v_wc_text08, v_wc_text09, v_wc_text10, v_wc_text11, v_wc_text12, v_wc_text13,
                  v_wc_text14, v_wc_text15, v_wc_text16, v_wc_text17, v_rec_flag, v_change_tag, v_wc_title2;
            EXIT WHEN polwc_cur%NOTFOUND;

            INSERT INTO gipi_wpolwc
                        (par_id, line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title, wc_remarks, wc_text01, wc_text02, wc_text03,
                        wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09, wc_text10, wc_text11, wc_text12, wc_text13,
                        wc_text14, wc_text15, wc_text16, wc_text17, rec_flag, change_tag, wc_title2)     
                 VALUES (p_copy_par_id, v_line_cd, v_wc_cd, v_swc_seq_no, v_print_seq_no, v_wc_title, v_wc_remarks, v_wc_text01, v_wc_text02, v_wc_text03,
                        v_wc_text04, v_wc_text05, v_wc_text06, v_wc_text07, v_wc_text08, v_wc_text09, v_wc_text10, v_wc_text11, v_wc_text12, v_wc_text13,
                        v_wc_text14, v_wc_text15, v_wc_text16, v_wc_text17, v_rec_flag, v_change_tag, v_wc_title2);
        END LOOP;
        CLOSE polwc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_polwc;
    
    PROCEDURE copy_endttext(
        p_policy_id            IN  gipi_polbasic.policy_id%TYPE,
        p_copy_v_long          OUT gipi_polgenin.gen_info%TYPE,
        p_copy_par_id          IN  gipi_polbasic.par_id%TYPE,
        p_user_id              IN  gipi_polbasic.user_id%TYPE
    ) AS
    BEGIN
        SELECT endt_text
          INTO p_copy_v_long
          FROM gipi_endttext
         WHERE policy_id = p_policy_id;
         
        INSERT INTO gipi_wendttext
                    (par_id, endt_text, user_id, last_update)
             VALUES (p_copy_par_id, p_copy_v_long, p_user_id, SYSDATE);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_endttext;
    
    PROCEDURE copy_pack_line_subline(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_copy_pack_par_id     gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR pack_line_subline_cur IS
        SELECT pack_line_cd, pack_subline_cd, line_cd, remarks
          FROM gipi_pack_line_subline
         WHERE policy_id = p_policy_id;

        v_pack_line_cd         gipi_pack_line_subline.pack_line_cd%TYPE;
        v_pack_subline_cd      gipi_pack_line_subline.pack_subline_cd%TYPE;
        v_line_cd              gipi_pack_line_subline.line_cd%TYPE;
        v_remarks              gipi_pack_line_subline.remarks%TYPE;
    BEGIN
        OPEN pack_line_subline_cur;
        LOOP
            FETCH pack_line_subline_cur
             INTO v_pack_line_cd, v_pack_subline_cd, v_line_cd, v_remarks;
            EXIT WHEN pack_line_subline_cur%NOTFOUND;
         
            INSERT INTO gipi_wpack_line_subline
                        (par_id, pack_line_cd, pack_subline_cd, line_cd, remarks, pack_par_id)
                 VALUES (p_copy_par_id, v_pack_line_cd, v_pack_subline_cd, v_line_cd, v_remarks, p_copy_pack_par_id);
        END LOOP;
        CLOSE pack_line_subline_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
    END copy_pack_line_subline;
    
    PROCEDURE copy_lim_liab(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gipi_wlim_liab
                    (par_id, line_cd, liab_cd, limit_liability, currency_cd, currency_rt)
             SELECT p_copy_par_id, line_cd, liab_cd, limit_liability, currency_cd, currency_rt
               FROM gipi_lim_liab
              WHERE policy_id = p_policy_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_lim_liab;
    
    PROCEDURE copy_item(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_parameter_par_type   gipi_parlist.par_type%TYPE,
        p_variables_line_cd    gipi_polbasic.line_cd%TYPE,
        p_variables_subline_cd gipi_polbasic.subline_cd%TYPE,
        p_variables_iss_cd     gipi_polbasic.iss_cd%TYPE,
        p_variables_issue_yy   gipi_polbasic.issue_yy%TYPE,
        p_variables_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
        p_variables_renew_no   gipi_polbasic.renew_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR item_cur IS
        SELECT item_grp, item_no, item_title, item_desc, item_desc2, tsi_amt, prem_amt, ann_tsi_amt,
               ann_prem_amt, rec_flag, currency_cd, currency_rt, group_cd, from_date, to_date,
               pack_line_cd, pack_subline_cd, discount_sw, other_info, coverage_cd, surcharge_sw,
               region_cd, changed_tag, pack_ben_cd, payt_terms, risk_no, risk_item_no
          FROM gipi_item
         WHERE policy_id = p_policy_id;
        
        v_item_grp                gipi_item.item_grp%TYPE;
        v_item_no                 gipi_item.item_no%TYPE;
        v_item_title              gipi_item.item_title%TYPE;
        v_item_desc               gipi_item.item_desc%TYPE;
        v_item_desc2              gipi_item.item_desc%TYPE;
        v_tsi_amt                 gipi_item.tsi_amt%TYPE;
        v_prem_amt                gipi_item.prem_amt%TYPE;
        v_ann_tsi_amt             gipi_item.ann_tsi_amt%TYPE;
        v_ann_prem_amt            gipi_item.ann_prem_amt%TYPE;
        v_rec_flag                gipi_item.rec_flag%TYPE;
        v_currency_cd             gipi_item.currency_cd%TYPE;
        v_currency_rt             gipi_item.currency_rt%TYPE;
        v_group_cd                gipi_item.group_cd%TYPE;
        v_from_date               gipi_item.from_date%TYPE;
        v_to_date                 gipi_item.to_date%TYPE;
        v_pack_line_cd            gipi_item.pack_line_cd%TYPE;
        v_pack_subline_cd         gipi_item.pack_subline_cd%TYPE;
        v_discount_sw             gipi_item.discount_sw%TYPE;
        v_other_info              gipi_item.other_info%TYPE;
        v_coverage_cd             gipi_item.coverage_cd%TYPE;
        v_surcharge_sw            gipi_item.surcharge_sw%TYPE;
        v_region_cd               gipi_item.region_cd%TYPE;
        v_changed_tag             gipi_item.changed_tag%TYPE;
        v_pack_ben_cd             gipi_item.pack_ben_cd%TYPE;
        v_payt_terms              gipi_item.payt_terms%TYPE;
        v_risk_no                 gipi_item.risk_no%TYPE;
        v_risk_item_no            gipi_item.risk_item_no%TYPE;
        v_exists                  VARCHAR2(1);
    BEGIN
        OPEN item_cur;
        LOOP
            FETCH item_cur
             INTO v_item_grp, v_item_no, v_item_title, v_item_desc, v_item_desc2, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                  v_ann_prem_amt, v_rec_flag, v_currency_cd, v_currency_rt, v_group_cd, v_from_date, v_to_date,
                  v_pack_line_cd, v_pack_subline_cd, v_discount_sw, v_other_info, v_coverage_cd, v_surcharge_sw,
                  v_region_cd, v_changed_tag, v_pack_ben_cd, v_payt_terms, v_risk_no, v_risk_item_no;
            EXIT WHEN item_cur%NOTFOUND;                     
         
            IF p_parameter_par_type = 'E' THEN
                v_tsi_amt   := 0;
                v_prem_amt  := 0;
                FOR a1 IN (SELECT b480.ann_tsi_amt tsi,b480.ann_prem_amt prem
                             FROM gipi_polbasic b250, gipi_item b480
                            WHERE b250.policy_id   = b480.policy_id
                              AND b480.item_no     = v_item_no
                              AND b250.line_cd     = p_variables_line_cd
                              AND b250.subline_cd  = p_variables_subline_cd
                              AND b250.iss_cd      = p_variables_iss_cd
                              AND b250.issue_yy    = p_variables_issue_yy
                              AND b250.pol_seq_no  = p_variables_pol_seq_no
                              AND b250.renew_no    = p_variables_renew_no
                              AND b250.pol_flag    IN ('1','2','3')                       
                            ORDER BY b250.eff_date DESC, b250.endt_seq_no DESC)
                LOOP
                    v_ann_tsi_amt  := a1.tsi;
                    v_ann_prem_amt := a1.prem;
                    EXIT;
                END LOOP;
            END IF;
            
            -- marco - 05.10.2013 - for validation before insert
            v_exists := 'N';
            FOR i IN(SELECT 1
                       FROM GIPI_WITEM
                      WHERE par_id = p_copy_par_id
                        AND item_no = v_item_no)
            LOOP
                v_exists := 'Y';
                EXIT;
            END LOOP;
            
            IF v_exists <> 'Y' THEN
                INSERT INTO gipi_witem
                        (par_id, item_grp, item_no, item_title, item_desc, item_desc2, tsi_amt, prem_amt, ann_tsi_amt,
                        ann_prem_amt, rec_flag, currency_cd, currency_rt, group_cd, from_date, to_date, pack_line_cd,
                        pack_subline_cd, discount_sw, other_info, coverage_cd, surcharge_sw, region_cd, changed_tag,
                        pack_ben_cd, payt_terms, risk_no, risk_item_no)
                 VALUES (p_copy_par_id, v_item_grp, v_item_no, v_item_title, v_item_desc, v_item_desc2, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                        v_ann_prem_amt, v_rec_flag, v_currency_cd, v_currency_rt, v_group_cd, v_from_date, v_to_date, v_pack_line_cd,
                        v_pack_subline_cd, v_discount_sw, v_other_info, v_coverage_cd, v_surcharge_sw, v_region_cd, v_changed_tag,
                        v_pack_ben_cd, v_payt_terms, v_risk_no, v_risk_item_no);
            END IF; 
        END LOOP;
        CLOSE item_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_item;
    
    PROCEDURE copy_itmperil(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR itmperil_cur IS
        SELECT item_no, peril_cd, line_cd, rec_flag, tarf_cd, prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
               comp_rem, discount_sw, ri_comm_rate, ri_comm_amt, surcharge_sw, aggregate_sw, no_of_days, base_amt
          FROM gipi_itmperil
         WHERE policy_id = p_policy_id;
        
        v_item_no               gipi_itmperil.item_no%TYPE;
        v_peril_cd              gipi_itmperil.peril_cd%TYPE;
        v_line_cd               gipi_itmperil.line_cd%TYPE;
        v_rec_flag              gipi_itmperil.rec_flag%TYPE;
        v_tarf_cd               gipi_itmperil.tarf_cd%TYPE;
        v_prem_rt               gipi_itmperil.prem_rt%TYPE;
        v_tsi_amt               gipi_itmperil.tsi_amt%TYPE;
        v_prem_amt              gipi_itmperil.prem_amt%TYPE;
        v_ann_tsi_amt           gipi_itmperil.ann_tsi_amt%TYPE;
        v_ann_prem_amt          gipi_itmperil.ann_prem_amt%TYPE;
        v_comp_rem              gipi_itmperil.comp_rem%TYPE;
        v_discount_sw           gipi_itmperil.discount_sw%TYPE;
        v_ri_comm_rate          gipi_itmperil.ri_comm_rate%TYPE;
        v_ri_comm_amt           gipi_itmperil.ri_comm_amt%TYPE;
        v_surcharge_sw          gipi_itmperil.surcharge_sw%TYPE;
        v_aggregate_sw          gipi_itmperil.aggregate_sw%TYPE;
        v_no_of_days            gipi_itmperil.no_of_days%TYPE;
        v_base_amt              gipi_itmperil.base_amt%TYPE;
        v_exists                VARCHAR2(1);
    BEGIN
        OPEN itmperil_cur;
        LOOP
            FETCH itmperil_cur
             INTO v_item_no, v_peril_cd, v_line_cd, v_rec_flag, v_tarf_cd, v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,
                  v_comp_rem, v_discount_sw, v_ri_comm_rate, v_ri_comm_amt, v_surcharge_sw, v_aggregate_sw, v_no_of_days, v_base_amt;
            EXIT WHEN itmperil_cur%NOTFOUND;
         
            -- marco - 05.10.2013 - for validation before insert
            v_exists := 'N';
            FOR i IN(SELECT 1
                       FROM GIPI_WITMPERL
                      WHERE par_id = p_copy_par_id
                        AND item_no = v_item_no
                        AND line_cd = v_line_cd
                        AND peril_cd = v_peril_cd)
            LOOP
                v_exists := 'Y';
            END LOOP;
            
            IF v_exists <> 'Y' THEN
                INSERT INTO gipi_witmperl
                        (par_id, item_no, line_cd, peril_cd, tarf_cd, prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
                        rec_flag, comp_rem, discount_sw, ri_comm_rate, ri_comm_amt, surcharge_sw, aggregate_sw, no_of_days, base_amt) 
                 VALUES (p_copy_par_id, v_item_no, v_line_cd, v_peril_cd, v_tarf_cd, v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,
                        v_rec_flag, v_comp_rem, v_discount_sw, v_ri_comm_rate, v_ri_comm_amt, v_surcharge_sw, v_aggregate_sw, v_no_of_days, v_base_amt);
            END IF;        
        END LOOP;
        CLOSE itmperil_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_itmperil;
    
    PROCEDURE copy_peril_discount(
        p_policy_id            gipi_peril_discount.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS 
        CURSOR peril_disc_cur IS
        SELECT line_cd, item_no, peril_cd, disc_rt, disc_amt, net_gross_tag, discount_tag, level_tag, subline_cd,
               orig_peril_prem_amt, net_prem_amt, sequence, remarks, last_update, surcharge_rt, surcharge_amt
          FROM gipi_peril_discount
         WHERE policy_id = p_policy_id;
        
        v_line_cd                gipi_peril_discount.line_cd%TYPE;
        v_item_no                gipi_peril_discount.item_no%TYPE;
        v_peril_cd               gipi_peril_discount.peril_cd%TYPE;
        v_disc_rt                gipi_peril_discount.disc_rt%TYPE;
        v_disc_amt               gipi_peril_discount.disc_amt%TYPE;
        v_net_gross_tag          gipi_peril_discount.net_gross_tag%TYPE;
        v_discount_tag           gipi_peril_discount.discount_tag%TYPE;
        v_level_tag              gipi_peril_discount.level_tag%TYPE;
        v_subline_cd             gipi_peril_discount.subline_cd%TYPE;
        v_orig_peril_prem_amt    gipi_peril_discount.orig_peril_prem_amt%TYPE;
        v_net_prem_amt           gipi_peril_discount.net_prem_amt%TYPE;
        v_sequence               gipi_peril_discount.sequence%TYPE;
        v_remarks                gipi_peril_discount.remarks%TYPE;
        v_last_update            gipi_peril_discount.last_update%TYPE;
        v_surcharge_rt           gipi_peril_discount.surcharge_rt%TYPE;
        v_surcharge_amt          gipi_peril_discount.surcharge_amt%TYPE;
    BEGIN
        OPEN peril_disc_cur;
        LOOP
            FETCH peril_disc_cur
             INTO v_line_cd, v_item_no, v_peril_cd, v_disc_rt, v_disc_amt, v_net_gross_tag, v_discount_tag, v_level_tag, v_subline_cd,
                  v_orig_peril_prem_amt, v_net_prem_amt, v_sequence, v_remarks, v_last_update, v_surcharge_rt, v_surcharge_amt;
            EXIT WHEN peril_disc_cur%NOTFOUND;
         
            INSERT INTO gipi_wperil_discount
                        (par_id, item_no, line_cd, peril_cd, disc_rt, disc_amt, net_gross_tag, discount_tag, level_tag, subline_cd,
                        orig_peril_prem_amt, net_prem_amt, sequence, remarks, last_update, surcharge_rt, surcharge_amt)
                 VALUES (p_copy_par_id, v_item_no, v_line_cd, v_peril_cd, v_disc_rt, v_disc_amt, v_net_gross_tag, v_discount_tag, v_level_tag, v_subline_cd,
                        v_orig_peril_prem_amt, v_net_prem_amt, v_sequence, v_remarks, v_last_update, v_surcharge_rt, v_surcharge_amt);
        END LOOP;
        CLOSE peril_disc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_peril_discount;
    
    PROCEDURE copy_item_discount(
        p_policy_id            gipi_peril_discount.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR disc_cur IS
        SELECT line_cd, item_no, disc_rt, disc_amt, net_gross_tag, subline_cd, orig_prem_amt, net_prem_amt,
               sequence, remarks, last_update, surcharge_rt, surcharge_amt
          FROM gipi_item_discount
         WHERE policy_id = p_policy_id;
        v_line_cd                      gipi_peril_discount.line_cd%TYPE;
        v_item_no                      gipi_peril_discount.item_no%TYPE;
        v_disc_rt                      gipi_peril_discount.disc_rt%TYPE;
        v_disc_amt                     gipi_peril_discount.disc_amt%TYPE;
        v_net_gross_tag                gipi_peril_discount.net_gross_tag%TYPE;
        v_subline_cd                   gipi_peril_discount.subline_cd%TYPE;
        v_orig_prem_amt                gipi_polbasic_discount.orig_prem_amt%TYPE;
        v_net_prem_amt                 gipi_peril_discount.net_prem_amt%TYPE;
        v_sequence                     gipi_peril_discount.sequence%TYPE;
        v_remarks                      gipi_peril_discount.remarks%TYPE;
        v_last_update                  gipi_peril_discount.last_update%TYPE;
        v_surcharge_rt                 gipi_peril_discount.surcharge_rt%TYPE;
        v_surcharge_amt                gipi_peril_discount.surcharge_amt%TYPE;    
    BEGIN
        OPEN disc_cur;
        LOOP
            FETCH disc_cur
             INTO v_line_cd, v_item_no, v_disc_rt, v_disc_amt, v_net_gross_tag, v_subline_cd, v_orig_prem_amt, v_net_prem_amt,
                  v_sequence, v_remarks, v_last_update, v_surcharge_rt, v_surcharge_amt;
            EXIT WHEN disc_cur%NOTFOUND;                  
         
            INSERT INTO gipi_witem_discount
                        (par_id, line_cd, item_no, disc_rt, disc_amt, net_gross_tag, subline_cd, orig_prem_amt, net_prem_amt,
                        sequence, remarks, last_update, surcharge_rt, surcharge_amt)
                 VALUES (p_copy_par_id, v_line_cd, v_item_no, v_disc_rt, v_disc_amt, v_net_gross_tag, v_subline_cd, v_orig_prem_amt,v_net_prem_amt,
                        v_sequence, v_remarks, v_last_update, v_surcharge_rt, v_surcharge_amt);
        END LOOP;
        CLOSE disc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_item_discount;
    
     PROCEDURE copy_polbas_discount(
        p_policy_id            gipi_peril_discount.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR disc_cur IS
        SELECT line_cd, disc_rt, disc_amt, net_gross_tag, subline_cd, orig_prem_amt, net_prem_amt,
               sequence, remarks, last_update, surcharge_rt, surcharge_amt
          FROM gipi_polbasic_discount
         WHERE policy_id = p_policy_id;
         
        v_line_cd          gipi_peril_discount.line_cd%TYPE;
        v_disc_rt          gipi_peril_discount.disc_rt%TYPE;
        v_disc_amt         gipi_peril_discount.disc_amt%TYPE;
        v_net_gross_tag    gipi_peril_discount.net_gross_tag%TYPE;
        v_subline_cd       gipi_peril_discount.subline_cd%TYPE;
        v_orig_prem_amt    gipi_polbasic_discount.orig_prem_amt%TYPE;
        v_net_prem_amt     gipi_peril_discount.net_prem_amt%TYPE;
        v_sequence         gipi_peril_discount.sequence%TYPE;
        v_remarks          gipi_peril_discount.remarks%TYPE;
        v_last_update      gipi_peril_discount.last_update%TYPE;
        v_surcharge_rt     gipi_peril_discount.surcharge_rt%TYPE;
        v_surcharge_amt    gipi_peril_discount.surcharge_amt%TYPE;  
    BEGIN
        OPEN disc_cur;
        LOOP
            FETCH disc_cur
             INTO v_line_cd, v_disc_rt, v_disc_amt, v_net_gross_tag, v_subline_cd, v_orig_prem_amt, v_net_prem_amt,
                  v_sequence, v_remarks, v_last_update, v_surcharge_rt, v_surcharge_amt;
            EXIT WHEN disc_cur%NOTFOUND;
         
            INSERT INTO gipi_wpolbas_discount
                        (par_id, line_cd, disc_rt, disc_amt, net_gross_tag, subline_cd, orig_prem_amt, net_prem_amt,
                        sequence, remarks, last_update, surcharge_rt, surcharge_amt)
                 VALUES (p_copy_par_id, v_line_cd, v_disc_rt, v_disc_amt, v_net_gross_tag, v_subline_cd, v_orig_prem_amt,v_net_prem_amt,
                        v_sequence, v_remarks, v_last_update, v_surcharge_rt, v_surcharge_amt);
        END LOOP;
        CLOSE disc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_polbas_discount;
    
    PROCEDURE copy_beneficiary(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR benef_cur IS
        SELECT item_no, beneficiary_no, beneficiary_name, relation, beneficiary_addr, delete_sw, 
               remarks, civil_status, date_of_birth, age, adult_sw, sex, position_cd
          FROM gipi_beneficiary
         WHERE policy_id = p_policy_id;
        
        v_item_no                     gipi_beneficiary.item_no%TYPE;
        v_beneficiary_name            gipi_beneficiary.beneficiary_name%TYPE;
        v_beneficiary_no              gipi_beneficiary.beneficiary_no%TYPE;
        v_relation                    gipi_beneficiary.relation%TYPE;
        v_beneficiary_addr            gipi_beneficiary.beneficiary_addr%TYPE;
        v_delete_sw                   gipi_beneficiary.delete_sw%TYPE;
        v_remarks                     gipi_beneficiary.remarks%TYPE;
        v_civil_status                gipi_beneficiary.civil_status%TYPE;
        v_date_of_birth               gipi_beneficiary.date_of_birth%TYPE;
        v_age                         gipi_beneficiary.age%TYPE;
        v_adult_sw                    gipi_beneficiary.adult_sw%TYPE;
        v_sex                         gipi_beneficiary.sex%TYPE;
        v_position_cd                 gipi_beneficiary.position_cd%TYPE;
    BEGIN
        OPEN benef_cur;
        LOOP
            FETCH benef_cur
             INTO v_item_no, v_beneficiary_no, v_beneficiary_name, v_relation, v_beneficiary_addr, v_delete_sw,
                  v_remarks, v_civil_status, v_date_of_birth, v_age, v_adult_sw, v_sex, v_position_cd;
            EXIT WHEN benef_cur%NOTFOUND;
         
            INSERT INTO gipi_wbeneficiary
                        (par_id, item_no, beneficiary_no, beneficiary_name, relation, beneficiary_addr, delete_sw, 
                        remarks, civil_status, date_of_birth, age, adult_sw, sex, position_cd)
                 VALUES (p_copy_par_id, v_item_no, v_beneficiary_no, v_beneficiary_name, v_relation, v_beneficiary_addr, v_delete_sw,
                        v_remarks, v_civil_status, v_date_of_birth, v_age, v_adult_sw, v_sex, v_position_cd);
        END LOOP;
        CLOSE benef_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_beneficiary;
    
    PROCEDURE copy_accident_item(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR accident_item_cur IS
        SELECT item_no, date_of_birth, age, civil_status, position_cd, monthly_salary, salary_grade, no_of_persons,
               destination, height, weight, sex, ac_class_cd, level_cd, parent_level_cd
          FROM gipi_accident_item
         WHERE policy_id = p_policy_id;
        
        v_item_no             gipi_accident_item.item_no%TYPE;
        v_date_of_birth       gipi_accident_item.date_of_birth%TYPE;
        v_age                 gipi_accident_item.age%TYPE;
        v_civil_status        gipi_accident_item.civil_status%TYPE;
        v_position_cd         gipi_accident_item.position_cd%TYPE;
        v_monthly_salary      gipi_accident_item.monthly_salary%TYPE;
        v_salary_grade        gipi_accident_item.salary_grade%TYPE;
        v_no_of_persons       gipi_accident_item.no_of_persons%TYPE;
        v_destination         gipi_accident_item.destination%TYPE;
        v_height              gipi_accident_item.height%TYPE;
        v_weight              gipi_accident_item.weight%TYPE;
        v_sex                 gipi_accident_item.sex%TYPE;                       
        v_ac_class_cd         gipi_accident_item.ac_class_cd%TYPE;
        v_level_cd            gipi_accident_item.level_cd%TYPE;
        v_parent_level_cd     gipi_accident_item.parent_level_cd%TYPE;
    BEGIN
        OPEN accident_item_cur;
        LOOP
            FETCH accident_item_cur
             INTO v_item_no, v_date_of_birth, v_age, v_civil_status, v_position_cd, v_monthly_salary, v_salary_grade, v_no_of_persons,
                  v_destination, v_height, v_weight, v_sex, v_ac_class_cd, v_level_cd, v_parent_level_cd;
            EXIT WHEN accident_item_cur%NOTFOUND;
         
            INSERT INTO gipi_waccident_item
                        (par_id, item_no, date_of_birth, age, civil_status, position_cd, monthly_salary, salary_grade,
                        no_of_persons, destination, height, weight, sex, ac_class_cd, level_cd, parent_level_cd) 
                 VALUES (p_copy_par_id, v_item_no, v_date_of_birth, v_age, v_civil_status, v_position_cd, v_monthly_salary, v_salary_grade, 
                        v_no_of_persons, v_destination, v_height, v_weight, v_sex, v_ac_class_cd, v_level_cd, v_parent_level_cd);
        END LOOP;
        CLOSE accident_item_cur;                        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_accident_item;
    
    PROCEDURE copy_casualty_item(
        p_policy_id            gipi_casualty_item.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR casualty_item_cur IS
        SELECT item_no, section_line_cd, section_subline_cd, section_or_hazard_cd, capacity_cd, property_no_type, 
               property_no, location, conveyance_info, interest_on_premises, limit_of_liability, section_or_hazard_info
          FROM gipi_casualty_item
         WHERE policy_id = p_policy_id;
        
        v_item_no                  gipi_casualty_item.item_no%TYPE;
        v_section_line_cd          gipi_casualty_item.section_line_cd%TYPE;
        v_section_subline_cd       gipi_casualty_item.section_subline_cd%TYPE;
        v_section_or_hazard_cd     gipi_casualty_item.section_or_hazard_cd%TYPE;
        v_capacity_cd              gipi_casualty_item.capacity_cd%TYPE;
        v_property_no_type         gipi_casualty_item.property_no_type%TYPE;
        v_property_no              gipi_casualty_item.property_no%TYPE;
        v_location                 gipi_casualty_item.location%TYPE;
        v_conveyance_info          gipi_casualty_item.conveyance_info%TYPE;
        v_interest_on_premises     gipi_casualty_item.interest_on_premises%TYPE;
        v_limit_of_liability       gipi_casualty_item.limit_of_liability%TYPE;
        v_section_or_hazard_info   gipi_casualty_item.section_or_hazard_info%TYPE;
    BEGIN
        OPEN casualty_item_cur;
        LOOP
            FETCH casualty_item_cur
             INTO v_item_no, v_section_line_cd, v_section_subline_cd, v_section_or_hazard_cd, v_capacity_cd, v_property_no_type,
                  v_property_no, v_location, v_conveyance_info, v_interest_on_premises, v_limit_of_liability, v_section_or_hazard_info;
            EXIT WHEN casualty_item_cur%NOTFOUND;                  
         
            INSERT INTO gipi_wcasualty_item
                        (par_id, item_no, section_line_cd, section_subline_cd, section_or_hazard_cd, capacity_cd, property_no_type,
                        property_no, location, conveyance_info, interest_on_premises, limit_of_liability, section_or_hazard_info)
                 VALUES (p_copy_par_id, v_item_no, v_section_line_cd, v_section_subline_cd, v_section_or_hazard_cd, v_capacity_cd, v_property_no_type,
                        v_property_no, v_location, v_conveyance_info, v_interest_on_premises, v_limit_of_liability, v_section_or_hazard_info);
        END LOOP;                    
        CLOSE casualty_item_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;         
    END copy_casualty_item;
    
    PROCEDURE copy_casualty_personnel(
        p_policy_id            gipi_casualty_item.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR casualty_prsnl_cur IS
        SELECT item_no, personnel_no, name, include_tag, capacity_cd, amount_covered,remarks
          FROM gipi_casualty_personnel
         WHERE policy_id = p_policy_id;
         
        v_item_no              gipi_casualty_personnel.item_no%TYPE;
        v_personnel_no         gipi_casualty_personnel.personnel_no%TYPE;
        v_name                 gipi_casualty_personnel.name%TYPE;
        v_include_tag          gipi_casualty_personnel.include_tag%TYPE;
        v_capacity_cd          gipi_casualty_personnel.capacity_cd%TYPE;
        v_amount_covered       gipi_casualty_personnel.amount_covered%TYPE;
        v_remarks              gipi_casualty_personnel.remarks%TYPE;
    BEGIN
        OPEN casualty_prsnl_cur;
        LOOP
            FETCH casualty_prsnl_cur
             INTO v_item_no, v_personnel_no, v_name, v_include_tag, v_capacity_cd, v_amount_covered, v_remarks;
            EXIT WHEN casualty_prsnl_cur%NOTFOUND;
            
            INSERT INTO gipi_wcasualty_personnel
                        (par_id, item_no, personnel_no, name, include_tag, capacity_cd, amount_covered, remarks)
                 VALUES (p_copy_par_id, v_item_no, v_personnel_no, v_name, v_include_tag, v_capacity_cd, v_amount_covered, v_remarks);
        END LOOP;
        CLOSE casualty_prsnl_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;    
    END copy_casualty_personnel;
    
    PROCEDURE copy_engg_basic(
        p_policy_id            gipi_engg_basic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        v_engg_basic_infonum        gipi_engg_basic.engg_basic_infonum%TYPE;
        v_contract_proj_buss_title  gipi_engg_basic.contract_proj_buss_title%TYPE;
        v_site_location             gipi_engg_basic.site_location%TYPE;
        v_construct_start_date      gipi_engg_basic.construct_start_date%TYPE;
        v_construct_end_date        gipi_engg_basic.construct_end_date%TYPE;
        v_maintain_start_date       gipi_engg_basic.maintain_start_date%TYPE;
        v_maintain_end_date         gipi_engg_basic.maintain_end_date%TYPE;
        v_testing_start_date        gipi_engg_basic.testing_start_date%TYPE;
        v_testing_end_date          gipi_engg_basic.testing_end_date%TYPE;
        v_weeks_test                gipi_engg_basic.weeks_test%TYPE;
        v_time_excess               gipi_engg_basic.time_excess%TYPE;
        v_mbi_policy_no             gipi_engg_basic.mbi_policy_no%TYPE;
    BEGIN
        SELECT engg_basic_infonum, contract_proj_buss_title, site_location, construct_start_date,  
               construct_end_date, maintain_start_date, maintain_end_date, testing_start_date,
               testing_end_date, weeks_test, time_excess, mbi_policy_no
          INTO v_engg_basic_infonum, v_contract_proj_buss_title, v_site_location, v_construct_start_date,  
               v_construct_end_date, v_maintain_start_date, v_maintain_end_date, v_testing_start_date,
               v_testing_end_date, v_weeks_test, v_time_excess, v_mbi_policy_no
          FROM gipi_engg_basic
         WHERE policy_id = p_policy_id;
         
        INSERT INTO gipi_wengg_basic
                    (par_id, engg_basic_infonum, contract_proj_buss_title, site_location, construct_start_date,
                    construct_end_date, maintain_start_date, maintain_end_date, testing_start_date, 
                    testing_end_date, weeks_test, time_excess, mbi_policy_no)
             VALUES (p_copy_par_id, v_engg_basic_infonum, v_contract_proj_buss_title, v_site_location, v_construct_start_date,  
                    v_construct_end_date, v_maintain_start_date, v_maintain_end_date, v_testing_start_date,
                    v_testing_end_date, v_weeks_test, v_time_excess, v_mbi_policy_no);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_engg_basic;
    
    PROCEDURE copy_location(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR loc_cur IS
        SELECT item_no, region_cd, province_cd
          FROM gipi_location
         WHERE policy_id = p_policy_id;
         
        v_item_no           gipi_location.item_no%TYPE;
        v_region_cd         gipi_location.region_cd%TYPE;
        v_province_cd       gipi_location.province_cd%TYPE;
    BEGIN
        OPEN loc_cur;
        LOOP
            FETCH loc_cur
             INTO v_item_no, v_region_cd, v_province_cd;
            EXIT WHEN loc_cur%NOTFOUND;
         
            INSERT INTO gipi_wlocation
                        (par_id, item_no, region_cd, province_cd)
                 VALUES (p_copy_par_id, v_item_no, v_region_cd, v_province_cd);
        END LOOP;
        CLOSE loc_cur;                 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_location;
    
    PROCEDURE copy_principal(
        p_policy_id            gipi_principal.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR prin_cur IS
        SELECT principal_cd, engg_basic_infonum, subcon_sw          
          FROM gipi_principal
         WHERE policy_id = p_policy_id;
         
        v_principal_cd                gipi_principal.principal_cd%TYPE;
        v_engg_basic_infonum          gipi_principal.engg_basic_infonum%TYPE;
        v_subcon_sw                   gipi_principal.subcon_sw%TYPE;
    BEGIN
        OPEN prin_cur;
        LOOP
            FETCH prin_cur
             INTO v_principal_cd, v_engg_basic_infonum, v_subcon_sw;
            EXIT WHEN prin_cur%NOTFOUND;                                             
         
            INSERT INTO gipi_wprincipal
                        (par_id, principal_cd, engg_basic_infonum, subcon_sw)
                 VALUES (p_copy_par_id, v_principal_cd, v_engg_basic_infonum, v_subcon_sw);
        END LOOP;
        CLOSE prin_cur;                 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_principal;
    
    PROCEDURE copy_fire(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR fire_item IS
        SELECT item_no, district_no, eq_zone, tarf_cd, block_no, fr_item_type, loc_risk1, loc_risk2,
               loc_risk3, tariff_zone, typhoon_zone, construction_cd, front, right, left, rear, occupancy_cd,
               flood_zone, construction_remarks, occupancy_remarks, assignee, block_id, risk_cd, latitude, longitude
          FROM gipi_fireitem
         WHERE policy_id = p_policy_id;
         
        v_item_no            gipi_fireitem.item_no%TYPE; 
        v_district_no        gipi_fireitem.district_no%TYPE;
        v_eq_zone            gipi_fireitem.eq_zone%TYPE;
        v_tarf_cd            gipi_fireitem.tarf_cd%TYPE;
        v_block_no           gipi_fireitem.block_no%TYPE;
        v_fr_item_type       gipi_fireitem.fr_item_type%TYPE;
        v_loc_risk1          gipi_fireitem.loc_risk1%TYPE;
        v_loc_risk2          gipi_fireitem.loc_risk2%TYPE;
        v_loc_risk3          gipi_fireitem.loc_risk3%TYPE;
        v_tariff_zone        gipi_fireitem.tariff_zone%TYPE;
        v_typhoon_zone       gipi_fireitem.typhoon_zone%TYPE;
        v_construction_cd    gipi_fireitem.construction_cd%TYPE;
        v_construction_rem   gipi_fireitem.construction_remarks%TYPE;
        v_front              gipi_fireitem.front%TYPE;
        v_right              gipi_fireitem.right%TYPE;
        v_left               gipi_fireitem.left%TYPE;
        v_rear               gipi_fireitem.rear%TYPE;
        v_occupancy_cd       gipi_fireitem.occupancy_cd%TYPE;
        v_occupancy_rem      gipi_fireitem.occupancy_remarks%TYPE;
        v_flood_zone         gipi_fireitem.flood_zone%TYPE; 
        v_assignee           gipi_fireitem.assignee%TYPE;
        v_block_id           gipi_fireitem.block_id%TYPE;
        v_risk_cd            gipi_fireitem.risk_cd%TYPE;
        v_latitude           gipi_fireitem.latitude%TYPE; -- Added by Jerome 11.15.2016 SR 5749
        v_longitude          gipi_fireitem.longitude%TYPE; -- Added by Jerome 11.15.2016 SR 5749
    BEGIN
        OPEN fire_item;
        LOOP
            FETCH fire_item
             INTO v_item_no, v_district_no, v_eq_zone, v_tarf_cd, v_block_no, v_fr_item_type, v_loc_risk1, v_loc_risk2,
                  v_loc_risk3, v_tariff_zone, v_typhoon_zone, v_construction_cd, v_front, v_right, v_left, v_rear, v_occupancy_cd,
                  v_flood_zone, v_construction_rem, v_occupancy_rem, v_assignee, v_block_id, v_risk_cd, v_latitude, v_longitude;
            EXIT WHEN fire_item%NOTFOUND;                  
         
            INSERT INTO gipi_wfireitm
                        (par_id, item_no, district_no, eq_zone, tarf_cd, block_no, fr_item_type, loc_risk1, loc_risk2,
                        loc_risk3, tariff_zone, typhoon_zone, construction_cd, front, right, left, rear, occupancy_cd,
                        flood_zone, construction_remarks, occupancy_remarks, assignee, block_id, risk_cd, latitude, longitude)
                 VALUES (p_copy_par_id, v_item_no, v_district_no, v_eq_zone, v_tarf_cd, v_block_no, v_fr_item_type, v_loc_risk1, v_loc_risk2,
                        v_loc_risk3, v_tariff_zone, v_typhoon_zone, v_construction_cd, v_front, v_right, v_left, v_rear, v_occupancy_cd,
                        v_flood_zone, v_construction_rem, v_occupancy_rem, v_assignee, v_block_id, v_risk_cd, v_latitude, v_longitude);
        END LOOP;
        CLOSE fire_item;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_fire;
    
    PROCEDURE copy_vehicle(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR vehicle_cur IS
        SELECT item_no, subline_cd, coc_yy, coc_seq_no, coc_type, repair_lim, color, motor_no, model_year,
               make, mot_type, est_value, serial_no, towing, assignee, plate_no, subline_type_cd, no_of_pass,
               tariff_zone, type_of_body_cd, car_company_cd, mv_file_no, acquired_from, ctv_tag, make_cd,
               series_cd, basic_color_cd, color_cd, unladen_wt, origin, destination, coc_serial_no, motor_coverage,
               mv_type, mv_prem_type, tax_type
          FROM gipi_vehicle
         WHERE policy_id = p_policy_id;
         
        v_item_no                 gipi_vehicle.item_no%TYPE;
        v_subline_cd              gipi_vehicle.subline_cd%TYPE;
        v_coc_yy                  gipi_vehicle.coc_yy%TYPE;
        v_coc_seq_no              gipi_vehicle.coc_seq_no%TYPE;
        v_coc_type                gipi_vehicle.coc_type%TYPE;
        v_repair_lim              gipi_vehicle.repair_lim%TYPE;
        v_color                   gipi_vehicle.color%TYPE;
        v_motor_no                gipi_vehicle.motor_no%TYPE;
        v_model_year              gipi_vehicle.model_year%TYPE;
        v_make                    gipi_vehicle.make%TYPE;
        v_mot_type                gipi_vehicle.mot_type%TYPE;
        v_est_value               gipi_vehicle.est_value%TYPE;
        v_serial_no               gipi_vehicle.serial_no%TYPE;
        v_towing                  gipi_vehicle.towing%TYPE;
        v_assignee                gipi_vehicle.assignee%TYPE;
        v_plate_no                gipi_vehicle.plate_no%TYPE;
        v_subline_type_cd         gipi_vehicle.subline_type_cd%TYPE;
        v_no_of_pass              gipi_vehicle.no_of_pass%TYPE;
        v_tariff_zone             gipi_vehicle.tariff_zone%TYPE;
        v_type_of_body_cd         gipi_vehicle.type_of_body_cd%TYPE;
        v_car_company_cd          gipi_vehicle.car_company_cd%TYPE;
        v_mv_file_no              gipi_vehicle.mv_file_no%TYPE;
        v_acquired_from           gipi_vehicle.acquired_from%TYPE;
        v_ctv_tag                 gipi_vehicle.ctv_tag%TYPE;
        v_make_cd                 gipi_vehicle.make_cd%TYPE;
        v_series_cd               gipi_vehicle.series_cd%TYPE;    
        v_basic_color_cd          gipi_vehicle.basic_color_cd%TYPE;
        v_color_cd                gipi_vehicle.color_cd%TYPE;
        v_unladen_wt              gipi_vehicle.unladen_wt%TYPE;
        v_origin                  gipi_vehicle.origin%TYPE;
        v_destination             gipi_vehicle.destination%TYPE;
        v_coc_serial_no           gipi_vehicle.coc_serial_no%TYPE;
        v_deduct                  gipi_deductibles.deductible_amt%TYPE;
        v_motor_coverage          gipi_vehicle.motor_coverage%TYPE;
        v_mv_type				  gipi_vehicle.mv_type%TYPE;
        v_mv_prem_type			  gipi_vehicle.mv_prem_type%TYPE;
        v_tax_type				  gipi_vehicle.tax_type%TYPE;
    BEGIN
        OPEN vehicle_cur;
        LOOP
            FETCH vehicle_cur
             INTO v_item_no, v_subline_cd, v_coc_yy, v_coc_seq_no, v_coc_type, v_repair_lim, v_color, v_motor_no, v_model_year,
                  v_make, v_mot_type, v_est_value, v_serial_no, v_towing, v_assignee, v_plate_no, v_subline_type_cd, v_no_of_pass,
                  v_tariff_zone, v_type_of_body_cd, v_car_company_cd, v_mv_file_no, v_acquired_from, v_ctv_tag, v_make_cd,
                  v_series_cd, v_basic_color_cd, v_color_cd, v_unladen_wt,    v_origin, v_destination, v_coc_serial_no, v_motor_coverage,
                  v_mv_type, v_mv_prem_type, v_tax_type;
            EXIT WHEN vehicle_cur%NOTFOUND;
         
            INSERT INTO gipi_wvehicle 
                        (par_id, item_no, subline_cd, coc_yy, coc_seq_no, coc_type, repair_lim, color, motor_no, model_year,
                        make, mot_type, est_value, serial_no, towing, assignee, plate_no, subline_type_cd, no_of_pass,
                        tariff_zone, type_of_body_cd, car_company_cd, mv_file_no, acquired_from, ctv_tag, make_cd,
                        series_cd, basic_color_cd, color_cd, unladen_wt, origin, destination, coc_serial_no, motor_coverage,
                        mv_type, mv_prem_type, tax_type)
                 VALUES (p_copy_par_id, v_item_no, v_subline_cd, v_coc_yy, v_coc_seq_no, v_coc_type, v_repair_lim, v_color, v_motor_no, v_model_year,
                        v_make, v_mot_type, v_est_value, v_serial_no, v_towing, v_assignee, v_plate_no, v_subline_type_cd, v_no_of_pass,
                        v_tariff_zone, v_type_of_body_cd, v_car_company_cd, v_mv_file_no, v_acquired_from, v_ctv_tag, v_make_cd,
                        v_series_cd, v_basic_color_cd, v_color_cd, v_unladen_wt, v_origin, v_destination, v_coc_serial_no, v_motor_coverage,
                        v_mv_type, v_mv_prem_type, v_tax_type);
        END LOOP;
        CLOSE vehicle_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_vehicle;
    
    PROCEDURE copy_mcacc(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR mcacc_cur IS
        SELECT item_no, accessory_cd, acc_amt, user_id, last_update, delete_sw
          FROM gipi_mcacc
         WHERE policy_id = p_policy_id;
         
        v_item_no               gipi_mcacc.item_no%TYPE;
        v_accessory_cd          gipi_mcacc.accessory_cd%TYPE; 
        v_acc_amt               gipi_mcacc.acc_amt%TYPE; 
        v_user_id               gipi_mcacc.user_id%TYPE;
        v_last_update           gipi_mcacc.last_update%TYPE;
        v_delete_sw                gipi_mcacc.delete_sw%TYPE;
    BEGIN
        OPEN mcacc_cur;
        LOOP
            FETCH mcacc_cur
             INTO v_item_no, v_accessory_cd, v_acc_amt, v_user_id, v_last_update, v_delete_sw;
            EXIT WHEN mcacc_cur%NOTFOUND;
            
            INSERT INTO gipi_wmcacc
                        (par_id, item_no, accessory_cd, acc_amt, user_id, last_update, delete_sw)
                 VALUES (p_copy_par_id, v_item_no,v_accessory_cd,v_acc_amt,v_user_id,v_last_update, v_delete_sw);
        END LOOP;
        CLOSE mcacc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_mcacc;
    
    PROCEDURE copy_bond_basic(
        p_policy_id            IN gipi_polbasic.policy_id%TYPE,
        p_copy_v_long          OUT gipi_polgenin.gen_info%TYPE,
        p_copy_par_id          IN gipi_polbasic.par_id%TYPE
    )AS
    BEGIN
        SELECT bond_dtl
          INTO p_copy_v_long
          FROM gipi_bond_basic
         WHERE policy_id = p_policy_id;
         
        INSERT INTO gipi_wbond_basic
                    (par_id, obligee_no, prin_id, coll_flag, clause_type, val_period_unit, val_period,
                    np_no, contract_dtl, contract_date, co_prin_sw, waiver_limit, indemnity_text,
                    bond_dtl, endt_eff_date, remarks)
             SELECT p_copy_par_id, obligee_no, prin_id, coll_flag, clause_type, val_period_unit, val_period,
                    np_no, contract_dtl, contract_date, co_prin_sw, waiver_limit, indemnity_text, 
                    p_copy_v_long, endt_eff_date, remarks
               FROM gipi_bond_basic
              WHERE policy_id = p_policy_id;
    END;
    
    PROCEDURE copy_cosigntry(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR cosigntry_cur IS
        SELECT cosign_id, assd_no, indem_flag, bonds_flag, bonds_ri_flag
          FROM gipi_cosigntry
         WHERE policy_id = p_policy_id;
  
        v_prin_id          gipi_cosigntry.cosign_id%TYPE;
        v_assd_no          gipi_cosigntry.assd_no%TYPE;
        v_indem_flag       gipi_cosigntry.indem_flag%TYPE;
        v_bonds_flag       gipi_cosigntry.bonds_flag%TYPE;
        v_bonds_ri_flag    gipi_cosigntry.bonds_ri_flag%TYPE;
    BEGIN
        OPEN cosigntry_cur;
        LOOP
            FETCH cosigntry_cur
             INTO v_prin_id,v_assd_no,v_indem_flag,v_bonds_flag,v_bonds_ri_flag;
            EXIT WHEN cosigntry_cur%NOTFOUND;
        
            INSERT INTO gipi_wcosigntry
                        (par_id, cosign_id, assd_no, indem_flag, bonds_flag, bonds_ri_flag)
                 VALUES (p_copy_par_id, v_prin_id, v_assd_no, v_indem_flag, v_bonds_flag, v_bonds_ri_flag);
        END LOOP;
        CLOSE cosigntry_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END;
    
    PROCEDURE copy_aviation_cargo_hull(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_line_cd              gipi_polbasic.line_cd%TYPE,
        p_subline_cd           gipi_polbasic.subline_cd%TYPE,
        p_iss_cd               gipi_polbasic.iss_cd%TYPE,
        p_issue_yy             gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no             gipi_polbasic.renew_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_parameter_par_type   gipi_pack_parlist.par_type%TYPE,
        p_variables_line_mn    giis_parameters.param_value_v%TYPE,
        p_variables_line_mh    giis_parameters.param_value_v%TYPE,
        p_variables_line_av    giis_parameters.param_value_v%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    ) AS
        v_subline_cd        gipi_polbasic.subline_cd%TYPE;
        v_menu_line_cd      giis_line.menu_line_cd%TYPE;
        v_op_flag           giis_subline.op_flag%TYPE := 'N';
    BEGIN
        FOR a IN (SELECT menu_line_cd
                    FROM giis_line
                   WHERE line_cd = p_line_cd)
        LOOP
            v_menu_line_cd := a.menu_line_cd;
            EXIT;
        END LOOP;
        
        IF p_line_cd = p_variables_line_mn OR v_menu_line_cd = 'MN' THEN
            FOR b IN (SELECT b.op_flag op_flag
                        FROM gipi_polbasic a, giis_subline b
                       WHERE a.subline_cd = b.subline_cd
                         AND a.line_cd = b.line_cd
                         AND a.policy_id = p_policy_id)
            LOOP
                v_op_flag := b.op_flag;
                EXIT;
            END LOOP;
                                           
            IF v_op_flag = 'Y' THEN
                copy_item(p_policy_id, p_parameter_par_type, p_line_cd, p_subline_cd, p_iss_cd,
                          p_issue_yy, p_pol_seq_no, p_renew_no, p_copy_par_id);
                copy_itmperil(p_policy_id, p_copy_par_id);                      
                copy_open_liab(p_policy_id, p_copy_par_id);  
                copy_open_cargo(p_policy_id, p_copy_par_id);
                copy_open_peril(p_policy_id, p_copy_par_id);
            ELSE
                copy_item(p_policy_id, p_parameter_par_type, p_line_cd, p_subline_cd, p_iss_cd,
                          p_issue_yy, p_pol_seq_no, p_renew_no, p_copy_par_id); 
                copy_itmperil(p_policy_id, p_copy_par_id);                        
                copy_cargo(p_policy_id, p_copy_par_id, p_user_id);
                copy_item_ves(p_policy_id, p_copy_par_id);   
                copy_ves_air(p_policy_id, p_copy_par_id);
                copy_open_policy(p_policy_id, p_copy_par_id);
                copy_ves_accumulation(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_copy_par_id);
            END IF;
        ELSIF p_line_cd = p_variables_line_mh OR v_menu_line_cd = 'MH' THEN
            copy_item_ves(p_policy_id, p_copy_par_id);   
        ELSIF p_line_cd = p_variables_line_av OR v_menu_line_cd = 'AV' THEN
            copy_aviation_item(p_policy_id, p_copy_par_id);
        END IF;
    END copy_aviation_cargo_hull;
    
    PROCEDURE copy_open_liab(
        p_policy_id            gipi_open_liab.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR open_liab_cur IS
        SELECT geog_cd, rec_flag, limit_liability, currency_cd, currency_rt,
               voy_limit, prem_tag, with_invoice_tag, multi_geog_tag
          FROM gipi_open_liab
         WHERE policy_id = p_policy_id;
        
        v_geog_cd                   gipi_open_liab.geog_cd%TYPE;
        v_limit_liability           gipi_open_liab.limit_liability%TYPE;
        v_currency_cd               gipi_open_liab.currency_cd%TYPE;
        v_currency_rt               gipi_open_liab.currency_rt%TYPE;
        v_voy_limit                 gipi_open_liab.voy_limit%TYPE;
        v_prem_tag                  gipi_open_liab.prem_tag%TYPE;
        v_rec_flag                  gipi_open_liab.rec_flag%TYPE;
        v_with_invoice_tag          gipi_open_liab.with_invoice_tag%TYPE;
        v_multi_geog_tag            gipi_open_liab.multi_geog_tag%TYPE;
    BEGIN
        OPEN open_liab_cur;
        LOOP
            FETCH open_liab_cur
             INTO v_geog_cd, v_rec_flag, v_limit_liability, v_currency_cd, v_currency_rt,
                  v_voy_limit, v_prem_tag, v_with_invoice_tag, v_multi_geog_tag;
            EXIT WHEN open_liab_cur%NOTFOUND;
            
            INSERT INTO gipi_wopen_liab
                        (par_id, geog_cd, rec_flag, limit_liability, currency_cd, currency_rt,
                        voy_limit, prem_tag, with_invoice_tag, multi_geog_tag)
                 VALUES (p_copy_par_id, v_geog_cd, v_rec_flag, v_limit_liability, v_currency_cd,
                        v_currency_rt, v_voy_limit, v_prem_tag, v_with_invoice_tag, v_multi_geog_tag);
        END LOOP;
        CLOSE open_liab_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;                           
    END copy_open_liab;
    
    PROCEDURE copy_open_cargo(
        p_policy_id            gipi_open_cargo.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR open_cur IS
        SELECT geog_cd, cargo_class_cd, rec_flag
          FROM gipi_open_cargo
         WHERE policy_id = p_policy_id;
         
        v_geog_cd              gipi_open_cargo.geog_cd%TYPE;
        v_cargo_class_cd       gipi_open_cargo.cargo_class_cd%TYPE;
        v_rec_flag             gipi_open_cargo.rec_flag%TYPE;
    BEGIN
        OPEN open_cur;
        LOOP
            FETCH open_cur
             INTO v_geog_cd, v_cargo_class_cd, v_rec_flag;
            EXIT WHEN open_cur%NOTFOUND;             
             
            INSERT INTO gipi_wopen_cargo
                        (par_id, geog_cd, cargo_class_cd, rec_flag)
                 VALUES (p_copy_par_id, v_geog_cd, v_cargo_class_cd, v_rec_flag);
        END LOOP;
        CLOSE open_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL; 
    END copy_open_cargo;
    
    PROCEDURE copy_open_peril(
        p_policy_id            gipi_open_peril.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR open_peril_cur IS
        SELECT geog_cd, line_cd, peril_cd, rec_flag, prem_rate, with_invoice_tag, remarks
          FROM gipi_open_peril
         WHERE policy_id = p_policy_id;
         
        v_geog_cd             gipi_open_peril.geog_cd%TYPE;
        v_line_cd             gipi_open_peril.line_cd%TYPE;
        v_peril_cd            gipi_open_peril.peril_cd%TYPE;
        v_rec_flag            gipi_open_peril.rec_flag%TYPE; 
        v_prem_rate           gipi_open_peril.prem_rate%TYPE; 
        v_with_invoice_tag    gipi_open_peril.with_invoice_tag%TYPE;
        v_remarks             gipi_open_peril.remarks%TYPE;
    BEGIN
        OPEN open_peril_cur;
        LOOP
            FETCH open_peril_cur
             INTO v_geog_cd, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rate, v_with_invoice_tag, v_remarks;
            EXIT WHEN open_peril_cur%NOTFOUND;
            
            INSERT INTO gipi_wopen_peril
                        (par_id, geog_cd, line_cd, peril_cd, rec_flag, prem_rate, with_invoice_tag, remarks)
                 VALUES (p_copy_par_id, v_geog_cd, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rate, v_with_invoice_tag, v_remarks);
        END LOOP;
        CLOSE open_peril_cur;                 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL; 
    END copy_open_peril;
    
    PROCEDURE copy_cargo(
        p_policy_id            gipi_cargo.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    ) AS
        CURSOR cargo_cur IS
        SELECT item_no, vessel_cd, geog_cd, cargo_class_cd, voyage_no, bl_awb, rec_flag, origin, destn,
               etd, eta, lc_no, cargo_type, deduct_text, pack_method, tranship_origin, tranship_destination, print_tag
          FROM gipi_cargo
         WHERE policy_id = p_policy_id;
         
        v_item_no             gipi_cargo.item_no%TYPE;
        v_vessel_cd           gipi_cargo.vessel_cd%TYPE;
        v_geog_cd             gipi_cargo.geog_cd%TYPE;
        v_voyage_no           gipi_cargo.voyage_no%TYPE;
        v_lc_no               gipi_cargo.lc_no%TYPE;
        v_cargo_class_cd      gipi_cargo.cargo_class_cd%TYPE;
        v_bl_awb              gipi_cargo.bl_awb%TYPE;
        v_rec_flag            gipi_cargo.rec_flag%TYPE;
        v_origin              gipi_cargo.origin%TYPE;
        v_destn               gipi_cargo.destn%TYPE;
        v_etd                 gipi_cargo.etd%TYPE;
        v_eta                 gipi_cargo.eta%TYPE;
        v_cargo_type          gipi_cargo.cargo_type%TYPE;
        v_deduct_text         gipi_cargo.deduct_text%TYPE;
        v_pack_method         gipi_cargo.pack_method%TYPE;
        v_tranship_origin     gipi_cargo.tranship_origin%TYPE;
        v_tranship_destn      gipi_cargo.tranship_destination%TYPE;
        v_print_tag           gipi_cargo.print_tag%TYPE;
    BEGIN
        OPEN cargo_cur;
        LOOP
            FETCH cargo_cur
             INTO v_item_no, v_vessel_cd, v_geog_cd, v_cargo_class_cd, v_voyage_no, v_bl_awb, v_rec_flag, v_origin, v_destn,
                  v_etd, v_eta, v_lc_no, v_cargo_type, v_deduct_text, v_pack_method, v_tranship_origin, v_tranship_destn, v_print_tag;
            EXIT WHEN cargo_cur%NOTFOUND;
            
            INSERT INTO gipi_wcargo
                        (par_id, item_no, vessel_cd, geog_cd, cargo_class_cd, voyage_no, bl_awb, rec_flag, origin, destn,
                        etd, eta, lc_no, cargo_type, deduct_text, pack_method, tranship_origin, tranship_destination, print_tag)
                 VALUES (p_copy_par_id, v_item_no, v_vessel_cd, v_geog_cd, v_cargo_class_cd, v_voyage_no, v_bl_awb, v_rec_flag, v_origin, v_destn,
                        SYSDATE, (SYSDATE + 365), v_lc_no, v_cargo_type, v_deduct_text, v_pack_method, v_tranship_origin, v_tranship_destn, v_print_tag);
        END LOOP;
        copy_cargo_carrier(p_policy_id, p_copy_par_id, p_user_id);
        CLOSE cargo_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL; 
    END copy_cargo;  
    
    PROCEDURE copy_cargo_carrier(
        p_policy_id            gipi_cargo_carrier.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    ) AS
        CURSOR cargo_cur IS
        SELECT item_no, vessel_cd, voy_limit, vessel_limit_of_liab, eta, etd, origin, destn
          FROM gipi_cargo_carrier
         WHERE policy_id = p_policy_id;

        v_item_no                        gipi_cargo_carrier.item_no%TYPE;
        v_vessel_cd                      gipi_cargo_carrier.vessel_cd%TYPE;
        v_voy_limit                      gipi_cargo_carrier.voy_limit%TYPE;
        v_vessel_limit_of_liab           gipi_cargo_carrier.vessel_limit_of_liab%TYPE;
        v_etd                            gipi_cargo_carrier.etd%TYPE;
        v_eta                            gipi_cargo_carrier.eta%TYPE;
        v_origin                         gipi_cargo_carrier.origin%TYPE;
        v_destn                          gipi_cargo_carrier.destn%TYPE;
    BEGIN
        OPEN cargo_cur;
        LOOP
            FETCH cargo_cur
             INTO v_item_no, v_vessel_cd, v_voy_limit, v_vessel_limit_of_liab, v_eta, v_etd, v_origin, v_destn;
            EXIT WHEN cargo_cur%NOTFOUND;
            
            INSERT INTO gipi_wcargo_carrier
                        (par_id, item_no, vessel_cd, user_id, last_update, voy_limit, vessel_limit_of_liab, eta, etd, origin, destn)
                 VALUES (p_copy_par_id, v_item_no, v_vessel_cd, p_user_id, SYSDATE, v_voy_limit, v_vessel_limit_of_liab, v_eta, v_etd, v_origin, v_destn);     
        END LOOP;
        CLOSE cargo_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_cargo_carrier;
    
    PROCEDURE copy_item_ves(
        p_policy_id            gipi_item_ves.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR item_ves_cur IS
        SELECT item_no, vessel_cd, geog_limit, rec_flag, deduct_text, dry_date, dry_place
          FROM gipi_item_ves
         WHERE policy_id = p_policy_id;
         
        v_item_no           gipi_item_ves.item_no%TYPE;
        v_vessel_cd         gipi_item_ves.vessel_cd%TYPE;
        v_geog_limit        gipi_item_ves.geog_limit%TYPE;
        v_rec_flag          gipi_item_ves.rec_flag%TYPE;
        v_deduct_text       gipi_item_ves.deduct_text%TYPE;
        v_dry_date          gipi_item_ves.dry_date%TYPE;
        v_dry_place         gipi_item_ves.dry_place%TYPE;
    BEGIN
        OPEN item_ves_cur;
        LOOP
            FETCH item_ves_cur
             INTO v_item_no, v_vessel_cd, v_geog_limit, v_rec_flag, v_deduct_text, v_dry_date, v_dry_place;
            EXIT WHEN item_ves_cur%NOTFOUND;
            
            INSERT INTO gipi_witem_ves
                        (par_id, item_no, vessel_cd, geog_limit, rec_flag, deduct_text, dry_date, dry_place)
                 VALUES (p_copy_par_id, v_item_no, v_vessel_cd, v_geog_limit, v_rec_flag, v_deduct_text, v_dry_date, v_dry_place);
        END LOOP;
        CLOSE item_ves_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL; 
    END copy_item_ves;
    
    PROCEDURE copy_ves_air(
        p_policy_id            gipi_ves_air.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR ves_air_cur IS
        SELECT vessel_cd, vescon, voy_limit, rec_flag
          FROM gipi_ves_air
         WHERE policy_id = p_policy_id;
         
        v_vessel_cd           gipi_ves_air.vessel_cd%TYPE;
        v_vescon              gipi_ves_air.vescon%TYPE;
        v_voy_limit           gipi_ves_air.voy_limit%TYPE;
        v_rec_flag            gipi_ves_air.rec_flag%TYPE;
    BEGIN
        OPEN ves_air_cur;
        LOOP
            FETCH ves_air_cur
             INTO v_vessel_cd, v_vescon, v_voy_limit, v_rec_flag;      
            EXIT WHEN ves_air_cur%NOTFOUND;
        
            INSERT INTO gipi_wves_air
                        (par_id, vessel_cd, vescon, voy_limit, rec_flag)
                 VALUES (p_copy_par_id, v_vessel_cd, v_vescon, v_voy_limit, v_rec_flag);
        END LOOP;
        CLOSE ves_air_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL; 
    END copy_ves_air;
    
    PROCEDURE copy_open_policy(
        p_open_policy_id       gipi_open_policy.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
    BEGIN
        INSERT INTO gipi_wopen_policy
                    (par_id, line_cd, op_subline_cd, op_iss_cd, op_pol_seqno, decltn_no, op_issue_yy, eff_date, op_renew_no)
             SELECT p_copy_par_id, line_cd, op_subline_cd, op_iss_cd, op_pol_seqno, decltn_no, op_issue_yy, eff_date, op_renew_no
               FROM gipi_open_policy
              WHERE policy_id = p_open_policy_id;
    END copy_open_policy;
    
    PROCEDURE copy_ves_accumulation(
        p_line_cd              gipi_ves_accumulation.line_cd%TYPE,
        p_subline_cd           gipi_ves_accumulation.subline_cd%TYPE,
        p_iss_cd               gipi_ves_accumulation.iss_cd%TYPE,
        p_issue_yy             gipi_ves_accumulation.issue_yy%TYPE,
        p_pol_seq_no           gipi_ves_accumulation.pol_seq_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR ves_acc_cur IS
        SELECT item_no, vessel_cd, eta, etd, tsi_amt, rec_flag, eff_date
          FROM gipi_ves_accumulation
         WHERE line_cd    = p_line_cd
           AND subline_cd = p_subline_cd
           AND iss_cd     = p_iss_cd
           AND issue_yy   = p_issue_yy
           AND pol_seq_no = p_pol_seq_no;
           
        v_item_no              gipi_ves_accumulation.item_no%TYPE;
        v_vessel_cd            gipi_ves_accumulation.vessel_cd%TYPE;
        v_eta                  gipi_ves_accumulation.eta%TYPE;
        v_etd                  gipi_ves_accumulation.etd%TYPE;
        v_tsi_amt              gipi_ves_accumulation.tsi_amt%TYPE;
        v_rec_flag             gipi_ves_accumulation.rec_flag%TYPE;
        v_eff_date             gipi_ves_accumulation.eff_date%TYPE;
    BEGIN
        OPEN ves_acc_cur;
        LOOP
            FETCH ves_acc_cur
             INTO v_item_no, v_vessel_cd, v_eta, v_etd, v_tsi_amt, v_rec_flag, v_eff_date;
            EXIT WHEN ves_acc_cur%NOTFOUND;
           
            INSERT INTO gipi_wves_accumulation
                        (par_id, item_no, vessel_cd, eta, etd, tsi_amt, rec_flag, eff_date)
                 VALUES (p_copy_par_id, v_item_no, v_vessel_cd, SYSDATE, (SYSDATE + 365), v_tsi_amt, v_rec_flag, v_eff_date);
        END LOOP;
        CLOSE ves_acc_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_ves_accumulation;
    
    PROCEDURE copy_aviation_item(
        p_policy_id            gipi_aviation_item.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR aviation_item_cur IS
        SELECT item_no, vessel_cd, total_fly_time, qualification, purpose, geog_limit, deduct_text,
               rec_flag, fixed_wing, rotor, prev_util_hrs, est_util_hrs
          FROM gipi_aviation_item
         WHERE policy_id = p_policy_id;
        
        v_item_no               gipi_aviation_item.item_no%TYPE;
        v_vessel_cd             gipi_aviation_item.vessel_cd%TYPE;
        v_total_fly_time        gipi_aviation_item.total_fly_time%TYPE;
        v_qualification         gipi_aviation_item.qualification%TYPE;
        v_purpose               gipi_aviation_item.purpose%TYPE;
        v_geog_limit            gipi_aviation_item.geog_limit%TYPE;
        v_deduct_text           gipi_aviation_item.deduct_text%TYPE;
        v_rec_flag              gipi_aviation_item.rec_flag%TYPE;
        v_fixed_wing            gipi_aviation_item.fixed_wing%TYPE;
        v_rotor                 gipi_aviation_item.rotor%TYPE;
        v_prev_util_hrs         gipi_aviation_item.prev_util_hrs%TYPE;
        v_est_util_hrs          gipi_aviation_item.est_util_hrs%TYPE;
    BEGIN
        OPEN aviation_item_cur;
        LOOP
            FETCH aviation_item_cur
             INTO v_item_no, v_vessel_cd, v_total_fly_time, v_qualification, v_purpose, v_geog_limit, v_deduct_text,
                  v_rec_flag, v_fixed_wing, v_rotor, v_prev_util_hrs, v_est_util_hrs;
            EXIT WHEN aviation_item_cur%NOTFOUND;
            
            INSERT INTO gipi_waviation_item
                        (par_id, item_no, vessel_cd, total_fly_time, qualification, purpose, geog_limit, deduct_text,
                        rec_flag, fixed_wing, rotor, prev_util_hrs, est_util_hrs)
                 VALUES (p_copy_par_id, v_item_no, v_vessel_cd, v_total_fly_time, v_qualification, v_purpose, v_geog_limit, v_deduct_text,
                        v_rec_flag, v_fixed_wing, v_rotor, v_prev_util_hrs, v_est_util_hrs);
        END LOOP;
        CLOSE aviation_item_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_aviation_item;
    
    PROCEDURE copy_deductibles(
        p_policy_id            IN  gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          IN  gipi_polbasic.par_id%TYPE,
        p_copy_v_long          OUT gipi_wdeductibles.deductible_text%TYPE
    ) AS
        CURSOR deduct_cur IS
        SELECT item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd, deductible_text, deductible_amt, deductible_rt, peril_cd          
          FROM gipi_deductibles
         WHERE policy_id = p_policy_id;
         
        v_item_no               gipi_deductibles.item_no%TYPE;
        v_ded_line_cd           gipi_deductibles.ded_line_cd%TYPE;
        v_ded_subline_cd        gipi_deductibles.ded_subline_cd%TYPE;
        v_ded_deductible_cd     gipi_deductibles.ded_deductible_cd%TYPE;
        v_deductible_amt        gipi_deductibles.deductible_amt%TYPE;
        v_deductible_rt         gipi_deductibles.deductible_rt%TYPE;
        v_peril_cd              gipi_deductibles.peril_cd%TYPE;
    BEGIN
        OPEN deduct_cur;
        LOOP
            FETCH deduct_cur
             INTO v_item_no, v_ded_line_cd, v_ded_subline_cd, v_ded_deductible_cd, p_copy_v_long, v_deductible_amt, v_deductible_rt, v_peril_cd;
            EXIT WHEN deduct_cur%NOTFOUND;
            
            INSERT INTO    gipi_wdeductibles
                        (par_id, item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd, deductible_text, deductible_amt, deductible_rt, peril_cd)
                 VALUES (p_copy_par_id, v_item_no, v_ded_line_cd, v_ded_subline_cd, v_ded_deductible_cd, p_copy_v_long, v_deductible_amt, v_deductible_rt, v_peril_cd);
        END LOOP;
        CLOSE deduct_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_deductibles;
    
    PROCEDURE copy_grouped_items(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR gitm_cur IS
        SELECT item_no, grouped_item_no, grouped_item_title, include_tag, amount_coverage, remarks, line_cd, subline_cd,
               sex, position_cd, civil_status, date_of_birth, age, salary, salary_grade, group_cd, delete_sw, from_date,
               to_date, payt_terms, pack_ben_cd, ann_tsi_amt, ann_prem_amt, control_cd, control_type_cd,tsi_amt,prem_amt,principal_cd 
          FROM gipi_grouped_items
         WHERE policy_id = p_policy_id;
        
        v_item_no              gipi_wgrouped_items.item_no%TYPE;
        v_grouped_item_no      gipi_wgrouped_items.grouped_item_no%TYPE;
        v_grouped_item_title   gipi_wgrouped_items.grouped_item_title%TYPE;
        v_include_tag          gipi_wgrouped_items.include_tag%TYPE;
        v_amount_covered       gipi_wgrouped_items.amount_covered%TYPE;
        v_remarks              gipi_wgrouped_items.remarks%TYPE;
        v_line_cd              gipi_wgrouped_items.line_cd%TYPE;  
        v_subline_cd           gipi_wgrouped_items.subline_cd%TYPE;
        v_sex                  gipi_wgrouped_items.sex%TYPE;
        v_position_cd          gipi_wgrouped_items.position_cd%TYPE;
        v_civil_status         gipi_wgrouped_items.civil_status%TYPE;
        v_date_of_birth        gipi_wgrouped_items.date_of_birth%TYPE;
        v_age                  gipi_wgrouped_items.age%TYPE;
        v_salary               gipi_wgrouped_items.salary%TYPE;
        v_salary_grade         gipi_wgrouped_items.salary_grade%TYPE;
        v_group_cd             gipi_wgrouped_items.group_cd%TYPE;
        v_delete_sw            gipi_wgrouped_items.delete_sw%TYPE;
        v_from_date            gipi_wgrouped_items.from_date%TYPE;
        v_to_date              gipi_wgrouped_items.to_date%TYPE;
        v_payt_terms           gipi_wgrouped_items.payt_terms%TYPE;
        v_pack_ben_cd          gipi_wgrouped_items.pack_ben_cd%TYPE;
        v_ann_tsi_amt          gipi_wgrouped_items.ann_tsi_amt%TYPE;
        v_ann_prem_amt         gipi_wgrouped_items.ann_prem_amt%TYPE;
        v_control_cd           gipi_wgrouped_items.control_cd%TYPE;
        v_control_type_cd      gipi_wgrouped_items.control_type_cd%TYPE;
        v_tsi_amt              gipi_wgrouped_items.tsi_amt%TYPE;
        v_prem_amt             gipi_wgrouped_items.prem_amt%TYPE;
        v_principal_cd         gipi_wgrouped_items.principal_cd%TYPE;
    BEGIN
        OPEN gitm_cur;
        LOOP
            FETCH gitm_cur    
             INTO v_item_no, v_grouped_item_no, v_grouped_item_title, v_include_tag, v_amount_covered, v_remarks, v_line_cd, v_subline_cd,
                  v_sex, v_position_cd, v_civil_status, v_date_of_birth, v_age, v_salary, v_salary_grade, v_group_cd,  v_delete_sw, v_from_date, 
                  v_to_date, v_payt_terms, v_pack_ben_cd, v_ann_tsi_amt, v_ann_prem_amt, v_control_cd, v_control_type_cd, v_tsi_amt, v_prem_amt, v_principal_cd;
            EXIT WHEN gitm_cur%NOTFOUND;
         
            INSERT INTO gipi_wgrouped_items
                        (par_id, item_no, grouped_item_no, grouped_item_title, include_tag, amount_covered, remarks, line_cd, subline_cd,
                        sex, position_cd, civil_status, date_of_birth, age, salary, salary_grade, group_cd, delete_sw, from_date, to_date,
                        payt_terms, pack_ben_cd, ann_tsi_amt, ann_prem_amt, control_cd, control_type_cd, tsi_amt, prem_amt, principal_cd)
                 VALUES (p_copy_par_id, v_item_no, v_grouped_item_no, v_grouped_item_title, v_include_tag, v_amount_covered, v_remarks, v_line_cd, v_subline_cd,
                        v_sex, v_position_cd, v_civil_status, v_date_of_birth, v_age, v_salary, v_salary_grade, v_group_cd, v_delete_sw, v_from_date, v_to_date,
                        v_payt_terms, v_pack_ben_cd, v_ann_tsi_amt, v_ann_prem_amt, v_control_cd, v_control_type_cd, v_tsi_amt, v_prem_amt, v_principal_cd);
                        
            copy_grp_items_beneficiary(p_policy_id, v_item_no, v_grouped_item_no, p_copy_par_id);
            copy_itmperil_beneficiary(p_policy_id, v_item_no, v_grouped_item_no, p_copy_par_id);
            copy_itmperil_grouped(p_policy_id, v_item_no, v_grouped_item_no, p_copy_par_id);
        END LOOP;
        CLOSE gitm_cur;                    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_grouped_items;
    
    PROCEDURE copy_grp_items_beneficiary(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_item_no              gipi_item.item_no%TYPE,
        p_grouped_item_no      gipi_grp_items_beneficiary.grouped_item_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR grpd_itm_cur IS
        SELECT item_no, grouped_item_no, beneficiary_no, beneficiary_name, beneficiary_addr,
               relation, date_of_birth, age, civil_status, sex
          FROM gipi_grp_items_beneficiary
         WHERE policy_id = p_policy_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
        
        v_item_no              gipi_grp_items_beneficiary.item_no%TYPE;
        v_grouped_item_no      gipi_grp_items_beneficiary.grouped_item_no%TYPE;
        v_beneficiary_no       gipi_grp_items_beneficiary.beneficiary_no%TYPE;
        v_beneficiary_name     gipi_grp_items_beneficiary.beneficiary_name%TYPE;
        v_beneficiary_addr     gipi_grp_items_beneficiary.beneficiary_addr%TYPE;
        v_relation             gipi_grp_items_beneficiary.relation%TYPE;
        v_sex                  gipi_grp_items_beneficiary.sex%TYPE;
        v_civil_status         gipi_grp_items_beneficiary.civil_status%TYPE;
        v_date_of_birth        gipi_grp_items_beneficiary.date_of_birth%TYPE;
        v_age                  gipi_grp_items_beneficiary.age%TYPE;
    BEGIN
        OPEN grpd_itm_cur;
        LOOP
            FETCH grpd_itm_cur
             INTO v_item_no, v_grouped_item_no, v_beneficiary_no, v_beneficiary_name, v_beneficiary_addr,
                  v_relation, v_date_of_birth, v_age, v_civil_status, v_sex;
            EXIT WHEN grpd_itm_cur%NOTFOUND;
           
            INSERT INTO gipi_wgrp_items_beneficiary
                        (par_id, item_no, grouped_item_no, beneficiary_no, beneficiary_name, beneficiary_addr,
                        relation, date_of_birth, age, civil_status, sex)
                 VALUES (p_copy_par_id, v_item_no, v_grouped_item_no, v_beneficiary_no, v_beneficiary_name, v_beneficiary_addr,
                        v_relation, v_date_of_birth, v_age, v_civil_status, v_sex);
        END LOOP;
        CLOSE grpd_itm_cur; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_grp_items_beneficiary;
    
    PROCEDURE copy_itmperil_beneficiary(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_item_no              gipi_item.item_no%TYPE,
        p_grouped_item_no      gipi_grp_items_beneficiary.grouped_item_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR itmperil_ben_cur IS
        SELECT item_no, grouped_item_no, beneficiary_no, line_cd, peril_cd, rec_flag,
                 prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt 
          FROM gipi_itmperil_beneficiary
         WHERE policy_id = p_policy_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
  
        v_item_no              gipi_itmperil_beneficiary.item_no%TYPE;
        v_grouped_item_no      gipi_itmperil_beneficiary.grouped_item_no%TYPE;
        v_beneficiary_no       gipi_itmperil_beneficiary.beneficiary_no%TYPE;
        v_line_cd              gipi_itmperil_beneficiary.line_cd%TYPE;
        v_peril_cd             gipi_itmperil_beneficiary.peril_cd%TYPE;
        v_rec_flag             gipi_itmperil_beneficiary.rec_flag%TYPE;
        v_prem_rt              gipi_itmperil_beneficiary.prem_rt%TYPE;
        v_tsi_amt              gipi_itmperil_beneficiary.tsi_amt%TYPE;
        v_prem_amt             gipi_itmperil_beneficiary.prem_amt%TYPE; 
        v_ann_tsi_amt          gipi_itmperil_beneficiary.ann_tsi_amt%TYPE;
        v_ann_prem_amt         gipi_itmperil_beneficiary.ann_prem_amt%TYPE;  
    BEGIN
        OPEN itmperil_ben_cur;
        LOOP
            FETCH itmperil_ben_cur
             INTO v_item_no, v_grouped_item_no, v_beneficiary_no, v_line_cd, v_peril_cd, v_rec_flag,
                  v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt;
            EXIT WHEN itmperil_ben_cur%NOTFOUND;
    
            INSERT INTO gipi_witmperl_beneficiary
                        (par_id, item_no, grouped_item_no, beneficiary_no, line_cd, peril_cd, rec_flag,
                        prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt)
                 VALUES (p_copy_par_id, v_item_no, v_grouped_item_no, v_beneficiary_no, v_line_cd, v_peril_cd, v_rec_flag,
                            v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt);
        END LOOP;
        CLOSE itmperil_ben_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_itmperil_beneficiary;
    
    PROCEDURE copy_itmperil_grouped(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_item_no              gipi_item.item_no%TYPE,
        p_grouped_item_no      gipi_itmperil_grouped.grouped_item_no%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR itmperil_grouped_cur IS
        SELECT item_no, grouped_item_no, line_cd, peril_cd, rec_flag, prem_rt, tsi_amt, prem_amt, ann_tsi_amt,
               ann_prem_amt, aggregate_sw, base_amt, ri_comm_rate, ri_comm_amt, no_of_days
          FROM gipi_itmperil_grouped
         WHERE policy_id = p_policy_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;

        v_item_no               gipi_itmperil_grouped.item_no%TYPE;
        v_peril_cd              gipi_itmperil_grouped.peril_cd%TYPE;
        v_line_cd               gipi_itmperil_grouped.line_cd%TYPE;
        v_rec_flag              gipi_itmperil_grouped.rec_flag%TYPE;
        v_prem_rt               gipi_itmperil_grouped.prem_rt%TYPE;
        v_tsi_amt               gipi_itmperil_grouped.tsi_amt%TYPE;
        v_prem_amt              gipi_itmperil_grouped.prem_amt%TYPE;
        v_ann_tsi_amt           gipi_itmperil_grouped.ann_tsi_amt%TYPE;
        v_ann_prem_amt          gipi_itmperil_grouped.ann_prem_amt%TYPE;
        v_grouped_item_no       gipi_itmperil_grouped.grouped_item_no%TYPE;
        v_aggregate_sw          gipi_itmperil_grouped.aggregate_sw%TYPE;  
        v_ri_comm_rate          gipi_itmperil_grouped.ri_comm_rate%TYPE;
        v_ri_comm_amt           gipi_itmperil_grouped.ri_comm_amt%TYPE;
        v_base_amt              gipi_itmperil_grouped.base_amt%TYPE;
        v_no_of_days            gipi_itmperil_grouped.no_of_days%TYPE;
    BEGIN
        OPEN itmperil_grouped_cur;
        LOOP
            FETCH itmperil_grouped_cur
             INTO v_item_no, v_grouped_item_no, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,           
                  v_ann_prem_amt, v_aggregate_sw, v_base_amt, v_ri_comm_rate, v_ri_comm_amt, v_no_of_days;
            EXIT WHEN itmperil_grouped_cur%NOTFOUND;
            
            INSERT INTO gipi_witmperl_grouped
                        (par_id, item_no, line_cd, peril_cd, rec_flag, prem_rt, tsi_amt, prem_amt, ann_tsi_amt,
                        ann_prem_amt, grouped_item_no, aggregate_sw, ri_comm_rate, ri_comm_amt, base_amt, no_of_days) 
                 VALUES (p_copy_par_id, v_item_no, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                        v_ann_prem_amt, v_grouped_item_no, v_aggregate_sw, v_ri_comm_rate, v_ri_comm_amt, v_base_amt, v_no_of_days);
        END LOOP;
        CLOSE itmperil_grouped_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_itmperil_grouped;
    
    PROCEDURE copy_pictures(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR picture_cur IS
        SELECT item_no, file_name, file_type, file_ext, remarks, user_id, last_update
          FROM gipi_pictures
         WHERE policy_id = p_policy_id;
                                      
        v_item_no              gipi_pictures.item_no%TYPE;
        v_file_name            gipi_pictures.file_name%TYPE;
        v_file_type            gipi_pictures.file_type%TYPE;
        v_file_ext             gipi_pictures.file_ext%TYPE;
        v_remarks              gipi_pictures.remarks%TYPE;
        v_user_id              gipi_pictures.user_id%TYPE;
        v_last_update          gipi_pictures.last_update%TYPE;
    BEGIN
        OPEN picture_cur;
        LOOP
            FETCH picture_cur
             INTO v_item_no, v_file_name, v_file_type, v_file_ext, v_remarks, v_user_id, v_last_update;
            EXIT WHEN picture_cur%NOTFOUND;
            
            INSERT INTO gipi_wpictures
                        (par_id, item_no, file_name, file_type, file_ext, remarks, user_id, last_update)
                 VALUES (p_copy_par_id, v_item_no, v_file_name, v_file_type, v_file_ext, v_remarks, v_user_id, v_last_update);
        END LOOP;
        CLOSE picture_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_pictures;
    
    PROCEDURE copy_orig_invoice(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE    
    ) AS
        CURSOR orig_inv_cur IS 
        SELECT item_grp, policy_id, iss_cd, prem_seq_no, prem_amt, tax_amt, other_charges, ref_inv_no,
               policy_currency, property, insured, ri_comm_amt, currency_cd, currency_rt, remarks        
          FROM gipi_orig_invoice
         WHERE policy_id = p_policy_id;

        v_item_grp           gipi_orig_invoice.item_grp%TYPE;
        v_policy_id          gipi_orig_invoice.policy_id%TYPE;
        v_iss_cd             gipi_orig_invoice.iss_cd%TYPE; 
        v_prem_seq_no        gipi_orig_invoice.prem_seq_no%TYPE;
        v_prem_amt           gipi_orig_invoice.prem_amt%TYPE;
        v_tax_amt            gipi_orig_invoice.tax_amt%TYPE;
        v_other_charges      gipi_orig_invoice.other_charges%TYPE; 
        v_ref_inv_no         gipi_orig_invoice.ref_inv_no%TYPE;
        v_policy_currency    gipi_orig_invoice.policy_currency%TYPE;
        v_property           gipi_orig_invoice.property%TYPE;
        v_insured            gipi_orig_invoice.insured%TYPE;
        v_ri_comm_amt        gipi_orig_invoice.ri_comm_amt%TYPE;
        v_currency_cd        gipi_orig_invoice.currency_cd%TYPE;  
        v_currency_rt        gipi_orig_invoice.currency_rt%TYPE;
        v_remarks            gipi_orig_invoice.remarks%TYPE;
    BEGIN
        OPEN orig_inv_cur;
        LOOP
            FETCH orig_inv_cur
             INTO v_item_grp, v_policy_id, v_iss_cd, v_prem_seq_no, v_prem_amt, v_tax_amt, v_other_charges, v_ref_inv_no, 
                  v_policy_currency, v_property, v_insured, v_ri_comm_amt, v_currency_cd, v_currency_rt, v_remarks;
            EXIT WHEN orig_inv_cur%NOTFOUND;
            
            INSERT INTO gipi_orig_invoice
                        (par_id, item_grp, iss_cd, prem_seq_no, prem_amt, tax_amt, other_charges, ref_inv_no, 
                        policy_currency, property, insured, ri_comm_amt, currency_cd, currency_rt, remarks) 
                 VALUES (p_copy_par_id, v_item_grp, v_iss_cd, v_prem_seq_no, v_prem_amt, v_tax_amt, v_other_charges, v_ref_inv_no,
                        v_policy_currency, v_property, v_insured, v_ri_comm_amt, v_currency_cd, v_currency_rt, v_remarks);
        END LOOP;
        CLOSE orig_inv_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_orig_invoice;
    
    PROCEDURE copy_orig_invperl(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR orig_invperl_cur IS 
        SELECT item_grp, peril_cd, tsi_amt, prem_amt, ri_comm_amt, ri_comm_rt
          FROM gipi_orig_invperl
         WHERE policy_id = p_policy_id;
     
        v_item_grp              gipi_orig_invperl.item_grp%TYPE;
        v_peril_cd              gipi_orig_invperl.peril_cd%TYPE;
        v_tsi_amt               gipi_orig_invperl.tsi_amt%TYPE;
        v_prem_amt              gipi_orig_invperl.prem_amt%TYPE;
        v_policy_id             gipi_orig_invperl.policy_id%TYPE;
        v_ri_comm_amt           gipi_orig_invperl.ri_comm_amt%TYPE;
        v_ri_comm_rt            gipi_orig_invperl.ri_comm_rt%TYPE;
    BEGIN
        OPEN orig_invperl_cur;
        LOOP
            FETCH orig_invperl_cur
             INTO v_item_grp,v_peril_cd,v_tsi_amt,v_prem_amt,v_ri_comm_amt,v_ri_comm_rt;
            EXIT WHEN orig_invperl_cur%NOTFOUND;
        
            INSERT INTO gipi_orig_invperl
                        (par_id, item_grp, peril_cd, tsi_amt, prem_amt, ri_comm_amt, ri_comm_rt) 
                 VALUES (p_copy_par_id, v_item_grp, v_peril_cd, v_tsi_amt, v_prem_amt, v_ri_comm_amt, v_ri_comm_rt);
        END LOOP;
        CLOSE orig_invperl_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_orig_invperl;
    
    PROCEDURE copy_orig_inv_tax (
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR orig_invtax_cur IS 
        SELECT item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_amt, tax_id,rate
          FROM gipi_orig_inv_tax
         WHERE policy_id = p_policy_id;
     
        v_item_grp                    gipi_orig_inv_tax.item_grp%TYPE;
        v_tax_cd                      gipi_orig_inv_tax.tax_cd%TYPE;
        v_line_cd                     gipi_orig_inv_tax.line_cd%TYPE;
        v_tax_allocation              gipi_orig_inv_tax.tax_allocation%TYPE;
        v_fixed_tax_allocation        gipi_orig_inv_tax.fixed_tax_allocation%TYPE;
        v_policy_id                   gipi_orig_inv_tax.policy_id%TYPE;
        v_iss_cd                      gipi_orig_inv_tax.iss_cd%TYPE;
        v_tax_amt                     gipi_orig_inv_tax.tax_amt%TYPE;
        v_tax_id                      gipi_orig_inv_tax.tax_id%TYPE;  
        v_rate                        gipi_orig_inv_tax.rate%TYPE;
    BEGIN
        OPEN orig_invtax_cur;
        LOOP
            FETCH orig_invtax_cur
             INTO v_item_grp, v_tax_cd, v_line_cd, v_tax_allocation, v_fixed_tax_allocation, v_iss_cd, v_tax_amt, v_tax_id, v_rate;
            EXIT WHEN orig_invtax_cur%NOTFOUND;
   
            INSERT INTO gipi_orig_inv_tax
                        (par_id, item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_amt, tax_id,rate) 
                 VALUES (p_copy_par_id, v_item_grp, v_tax_cd, v_line_cd, v_tax_allocation, v_fixed_tax_allocation, v_iss_cd, v_tax_amt, v_tax_id, v_rate);
        END LOOP;
        CLOSE orig_invtax_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_orig_inv_tax;
    
    PROCEDURE copy_orig_itmperil(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR orig_itmperil_cur IS 
        SELECT item_no, line_cd, peril_cd, rec_flag, prem_rt, prem_amt, tsi_amt, ann_prem_amt,
               ann_tsi_amt, comp_rem, discount_sw, ri_comm_rate, ri_comm_amt, surcharge_sw
          FROM gipi_orig_itmperil
         WHERE policy_id = p_policy_id;
         
        v_item_no           gipi_orig_itmperil.item_no%TYPE;
        v_line_cd           gipi_orig_itmperil.line_cd%TYPE;
        v_peril_cd          gipi_orig_itmperil.peril_cd%TYPE;
        v_rec_flag          gipi_orig_itmperil.rec_flag%TYPE;
        v_policy_id         gipi_orig_itmperil.policy_id%TYPE;
        v_prem_rt           gipi_orig_itmperil.prem_rt%TYPE;
        v_prem_amt          gipi_orig_itmperil.prem_amt%TYPE;
        v_tsi_amt           gipi_orig_itmperil.tsi_amt%TYPE;
        v_ann_prem_amt      gipi_orig_itmperil.ann_prem_amt%TYPE;
        v_ann_tsi_amt       gipi_orig_itmperil.ann_tsi_amt%TYPE;
        v_comp_rem          gipi_orig_itmperil.comp_rem%TYPE;  
        v_discount_sw       gipi_orig_itmperil.discount_sw%TYPE;
        v_ri_comm_rate      gipi_orig_itmperil.ri_comm_rate%TYPE;
        v_ri_comm_amt       gipi_orig_itmperil.ri_comm_amt%TYPE;
        v_surcharge_sw      gipi_orig_itmperil.surcharge_sw%TYPE;
    BEGIN
        OPEN orig_itmperil_cur;
        LOOP
            FETCH orig_itmperil_cur
             INTO v_item_no, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rt, v_prem_amt, v_tsi_amt, v_ann_prem_amt,
                  v_ann_tsi_amt, v_comp_rem, v_discount_sw, v_ri_comm_rate, v_ri_comm_amt, v_surcharge_sw;
            EXIT WHEN orig_itmperil_cur%NOTFOUND;
            
            INSERT INTO gipi_orig_itmperil
                        (par_id, item_no, line_cd, peril_cd, rec_flag, prem_rt, prem_amt, tsi_amt, ann_prem_amt,
                        ann_tsi_amt, comp_rem, discount_sw, ri_comm_rate, ri_comm_amt, surcharge_sw) 
                 VALUES (p_copy_par_id, v_item_no, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rt, v_prem_amt, v_tsi_amt, v_ann_prem_amt,
                        v_ann_tsi_amt, v_comp_rem, v_discount_sw, v_ri_comm_rate, v_ri_comm_amt, v_surcharge_sw);
        END LOOP;
        CLOSE orig_itmperil_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END copy_orig_itmperil;
    
    PROCEDURE copy_co_ins(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE,
        p_user_id              gipi_polbasic.user_id%TYPE
    ) AS
        CURSOR a1 IS
        SELECT co_ri_cd, co_ri_shr_pct, co_ri_prem_amt, co_ri_tsi_amt     
          FROM gipi_co_insurer
         WHERE policy_id  = p_policy_id;
         
        CURSOR a IS
        SELECT tsi_amt, prem_amt
          FROM gipi_main_co_ins
         WHERE policy_id  = p_policy_id;
    BEGIN
        BEGIN
            FOR a1 IN a 
            LOOP
                INSERT INTO gipi_main_co_ins
                            (par_id, tsi_amt, prem_amt, user_id, last_update)
                     VALUES (p_copy_par_id, a1.tsi_amt, a1.prem_amt, p_user_id, SYSDATE);
                IF SQL%NOTFOUND THEN
                    EXIT;
                END IF;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; 
        END;
        
        BEGIN
            FOR a3 IN a1
            LOOP
                INSERT INTO gipi_co_insurer
                            (par_id, co_ri_cd, co_ri_shr_pct, co_ri_prem_amt, co_ri_tsi_amt, user_id, last_update)
                     VALUES (p_copy_par_id, a3.co_ri_cd, a3.co_ri_shr_pct, a3.co_ri_prem_amt, a3.co_ri_tsi_amt, p_user_id, SYSDATE);
                IF SQL%NOTFOUND THEN
                    EXIT;
                END IF;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; 
        END;
    END copy_co_ins;
    
    PROCEDURE copy_invoice_pack(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR invoice_cur IS
        SELECT item_grp, payt_terms, prem_seq_no, prem_amt, tax_amt, property, insured, due_date, iss_cd, ri_comm_amt,
               currency_cd, currency_rt, remarks, other_charges, bond_rate, bond_tsi_amt, takeup_seq_no
          FROM gipi_invoice
         WHERE policy_id  = p_policy_id;

        v_item_grp              gipi_invoice.item_grp%TYPE;
        v_property              gipi_invoice.property%TYPE;
        v_prem_amt              gipi_invoice.prem_amt%TYPE;
        v_tax_amt               gipi_invoice.tax_amt%TYPE;
        v_payt_terms            gipi_invoice.payt_terms%TYPE;
        v_prem_seq_no           gipi_invoice.prem_seq_no%TYPE;
        v_insured               gipi_invoice.insured%TYPE;
        v_due_date              gipi_invoice.due_date%TYPE;
        v_iss_cd                gipi_invoice.iss_cd%TYPE;
        v_ri_comm_amt           gipi_invoice.ri_comm_amt%TYPE;
        v_currency_cd           gipi_invoice.currency_cd%TYPE;
        v_currency_rt           gipi_invoice.currency_rt%TYPE;
        v_remarks               gipi_invoice.remarks%TYPE;
        v_other_charges         gipi_invoice.other_charges%TYPE;
        v_bond_rate             gipi_invoice.bond_rate%TYPE;
        v_bond_tsi_amt          gipi_invoice.bond_tsi_amt%TYPE;
        v_takeup_seq_no         gipi_invoice.takeup_seq_no%TYPE;
    BEGIN
        OPEN invoice_cur;
        LOOP
            FETCH invoice_cur
             INTO v_item_grp, v_payt_terms, v_prem_seq_no, v_prem_amt, v_tax_amt, v_property, v_insured, v_due_date, v_iss_cd, v_ri_comm_amt,
                  v_currency_cd, v_currency_rt, v_remarks, v_other_charges, v_bond_rate, v_bond_tsi_amt, v_takeup_seq_no;
            EXIT WHEN invoice_cur%NOTFOUND;
   
            INSERT INTO gipi_winvoice
                        (par_id, item_grp, payt_terms, prem_amt, tax_amt, property, insured, due_date, ri_comm_amt,
                        currency_cd, currency_rt, remarks, other_charges, bond_rate, bond_tsi_amt, takeup_seq_no) 
                 VALUES (p_copy_par_id, v_item_grp, v_payt_terms, v_prem_amt, v_tax_amt, v_property, v_insured, SYSDATE, v_ri_comm_amt,
                        v_currency_cd, v_currency_rt, v_remarks, v_other_charges, v_bond_rate, v_bond_tsi_amt, NVL(v_takeup_seq_no,1));    
            copy_invperil(v_item_grp, v_prem_seq_no, v_iss_cd, NVL(v_takeup_seq_no,1), p_copy_par_id);
            copy_inv_tax(v_item_grp, v_prem_seq_no, v_iss_cd, NVL(v_takeup_seq_no,1), p_copy_par_id);
            copy_installment(v_item_grp,v_prem_seq_no,v_iss_cd,NVL(v_takeup_seq_no,1), p_copy_par_id);
        END LOOP;
        CLOSE invoice_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
    END copy_invoice_pack;
    
    PROCEDURE copy_invperil(
        p_item_grp             gipi_inv_tax.item_grp%TYPE,
        p_prem_seq_no          gipi_inv_tax.prem_seq_no%TYPE,
        p_iss_cd               gipi_inv_tax.iss_cd%TYPE,
        p_takeup_seq_no        NUMBER,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR invperil_cur IS
        SELECT iss_cd, prem_seq_no, peril_cd, tsi_amt, prem_amt, item_grp, ri_comm_amt, ri_comm_rt
          FROM gipi_invperil
         WHERE item_grp    = p_item_grp
           AND prem_seq_no = p_prem_seq_no
           AND iss_cd      = p_iss_cd;

        v_iss_cd            gipi_invperil.iss_cd%TYPE;
        v_prem_seq_no       gipi_invperil.prem_seq_no%TYPE;
        v_peril_cd          gipi_invperil.peril_cd%TYPE;
        v_tsi_amt           gipi_invperil.tsi_amt%TYPE;
        v_prem_amt          gipi_invperil.prem_amt%TYPE;
        v_item_grp          gipi_invperil.item_grp%TYPE;
        v_ri_comm_amt       gipi_invperil.ri_comm_amt%TYPE;
        v_ri_comm_rt        gipi_invperil.ri_comm_rt%TYPE;
    BEGIN
        OPEN invperil_cur;
        LOOP
            FETCH invperil_cur
             INTO v_iss_cd, v_prem_seq_no, v_peril_cd, v_tsi_amt, v_prem_amt, v_item_grp, v_ri_comm_amt, v_ri_comm_rt;
            EXIT WHEN invperil_cur%NOTFOUND;
   
            INSERT INTO gipi_winvperl
                        (par_id, peril_cd, item_grp, tsi_amt, prem_amt, ri_comm_amt, ri_comm_rt, takeup_seq_no)
                 VALUES (p_copy_par_id, v_peril_cd, v_item_grp, v_tsi_amt, v_prem_amt, v_ri_comm_amt, v_ri_comm_rt, p_takeup_seq_no);
        END LOOP;
        CLOSE invperil_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_invperil; 
    
    PROCEDURE copy_inv_tax(
        p_item_grp             gipi_inv_tax.item_grp%TYPE,
        p_prem_seq_no          gipi_inv_tax.prem_seq_no%TYPE,
        p_iss_cd               gipi_inv_tax.iss_cd%TYPE,
        p_takeup_seq_no        NUMBER,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR inv_tax_cur IS
        SELECT iss_cd, tax_cd, tax_amt, line_cd, item_grp, tax_id, tax_allocation, fixed_tax_allocation, rate
          FROM gipi_inv_tax
         WHERE item_grp    = p_item_grp
           AND prem_seq_no = p_prem_seq_no
           AND iss_cd      = p_iss_cd;

        v_iss_cd                gipi_inv_tax.iss_cd%TYPE;
        v_tax_cd                gipi_inv_tax.tax_cd%TYPE;
        v_tax_amt               gipi_inv_tax.tax_amt%TYPE;
        v_line_cd               gipi_inv_tax.line_cd%TYPE;
        v_item_grp              gipi_inv_tax.item_grp%TYPE;
        v_tax_id                gipi_inv_tax.item_grp%TYPE;
        v_tax_allocation        gipi_inv_tax.tax_allocation%TYPE;
        v_fixed_tax_allocation  gipi_inv_tax.fixed_tax_allocation%TYPE;
        v_rate                  gipi_inv_tax.rate%TYPE;
    BEGIN
        OPEN inv_tax_cur;
        LOOP
            FETCH inv_tax_cur
             INTO v_iss_cd, v_tax_cd, v_tax_amt, v_line_cd, v_item_grp, v_tax_id, v_tax_allocation, v_fixed_tax_allocation, v_rate;
            EXIT WHEN inv_tax_cur%NOTFOUND;
            
            INSERT INTO gipi_winv_tax
                        (par_id, item_grp, tax_cd, line_cd, iss_cd, tax_amt, tax_id, tax_allocation, fixed_tax_allocation, rate, takeup_seq_no)
                 VALUES (p_copy_par_id, v_item_grp, v_tax_cd, v_line_cd, v_iss_cd, v_tax_amt, v_tax_id, v_tax_allocation, v_fixed_tax_allocation, v_rate, p_takeup_seq_no);
        END LOOP;
        CLOSE inv_tax_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            NULL;
    END copy_inv_tax;
    
    PROCEDURE copy_installment(
        p_item_grp             gipi_inv_tax.item_grp%TYPE,
        p_prem_seq_no          gipi_inv_tax.prem_seq_no%TYPE,
        p_iss_cd               gipi_inv_tax.iss_cd%TYPE,
        p_takeup_seq_no        NUMBER,
        p_copy_par_id          gipi_polbasic.par_id%TYPE
    ) AS
        CURSOR installment_cur IS
        SELECT item_grp, inst_no, share_pct, prem_amt, tax_amt 
          FROM gipi_installment
         WHERE item_grp    = p_item_grp
           AND prem_seq_no = p_prem_seq_no
           AND iss_cd      = p_iss_cd;

        v_item_grp       gipi_winstallment.item_grp%TYPE;
        v_inst_no        gipi_winstallment.inst_no%TYPE;
        v_share_pct      gipi_winstallment.share_pct%TYPE;
        v_prem_amt       gipi_winstallment.prem_amt%TYPE;
        v_tax_amt        gipi_winstallment.tax_amt%TYPE;
    BEGIN
        OPEN installment_cur;
        LOOP
            FETCH installment_cur
             INTO v_item_grp, v_inst_no, v_share_pct, v_prem_amt, v_tax_amt;
            EXIT WHEN installment_cur%NOTFOUND;
   
            INSERT INTO gipi_winstallment
                        (par_id, item_grp, inst_no, share_pct, prem_amt, tax_amt, due_date, takeup_seq_no)
                 VALUES (p_copy_par_id, v_item_grp, v_inst_no, v_share_pct, v_prem_amt, v_tax_amt, NULL, p_takeup_seq_no);
        END LOOP;
        CLOSE installment_cur;
    END copy_installment;

END GIUTS008A_PKG;
/


