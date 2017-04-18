CREATE OR REPLACE PACKAGE BODY CPI.GICLS202_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.13.2013
    **  Reference By      : GICLS202 - BORDEREAUX AND CLAIMS REGISTER
    **
    */
AS
   FUNCTION when_new_form_gicls202
   RETURN when_new_form_gicls202_tab PIPELINED AS
      res             when_new_form_gicls202_type;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO res.ri_iss_cd
           FROM giac_parameters
          WHERE param_name = 'RI_ISS_CD';
      EXCEPTION  
         WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#I#RI issue code is not found in GIAC_PARAMETERS table.');
      END;

      BEGIN
         SELECT param_value_v
           INTO res.clm_loss_payee_type
           FROM giac_parameters
          WHERE param_name LIKE 'CLM_LOSS_PAYEE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#E#CLM_LOSS_PAYEE_TYPE parameter does not exist in GIAC_PARAMETERS.  Please contact your system administrator.');     
      END;

      BEGIN
         SELECT param_value_v
           INTO res.clm_exp_payee_type
           FROM giac_parameters
          WHERE param_name like 'CLM_EXP_PAYEE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#E#CLM_EXP_PAYEE_TYPE parameter does not exist in GIAC_PARAMETERS.  Please contact your system administrator.');      
      END;    
        
      res.impl_sw := giisp.v('IMPLEMENTATION_SW');
        
      PIPE ROW(res);
   END when_new_form_gicls202; 
    
    FUNCTION when_new_block_e010(
        p_user_id           gicl_res_brdrx_extr.user_id%TYPE
    ) RETURN when_new_block_e010_tab PIPELINED IS
        res                 when_new_block_e010_type;
        v_to_date           gicl_res_brdrx_extr.to_date%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(extr_type,1), 			        NVL(brdrx_type,1), 			NVL(ol_Date_opt,1), 		        NVL(brdrx_rep_type,1),
                   NVL(res_tag,0),				        NVL(pd_date_opt,1),			NVL(intm_tag,0),			        NVL(iss_cd_tag,1),
                   NVL(line_cd_tag,1),			        NVL(loss_cat_tag,0),		TO_CHAR(from_date,'mm-dd-yyyy'),    to_date,
                   NVL(branch_opt,1),			        NVL(reg_date_opt,1),		NVL(net_rcvry_tag,'N'),		        TO_CHAR(rcvry_from_date,'mm-dd-yyyy'),
                   TO_CHAR(rcvry_to_date,'mm-dd-yyyy'),	NVL(enrollee_tag, 0),		NVL(policy_tag, 0),
                   NVL(line_cd_tag,1),			        NVL(iss_cd_tag,1),		      NVL(intm_tag,0) --display parameters of Claim Register by MAC 11/26/2013.
              INTO res.rep_name,				res.brdrx_type, 			res.brdrx_date_option,      res.brdrx_option,
                   res.dsp_gross_tag,			res.paid_date_option,       res.per_intermediary,       res.per_issource,
                   res.per_line_subline,	    res.per_loss_cat, 		    res.dsp_from_date, 		    v_to_date,
                   res.branch_option, 		    res.reg_button, 			res.net_rcvry_chkbx, 	    res.dsp_rcvry_from_date,
                   res.dsp_rcvry_to_date,       res.per_enrollee,			res.per_policy,
                   res.per_line,					 res.per_iss,					 res.per_buss --display parameters of Claim Register by MAC 11/26/2013.	              
              FROM gicl_res_brdrx_extr
             WHERE user_id = p_user_id
               AND rownum = 1;
            
            SELECT line_cd, subline_cd, iss_cd, peril_cd, intm_no, loss_cat_cd, enrollee, control_type, TO_CHAR(as_of_date, 'mm-dd-yyyy'),
                   control_number, pol_line_cd, pol_subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, per_buss, per_issource, per_line_subline,
                   per_policy, per_enrollee, per_line, per_branch, per_intm, per_loss_cat
              INTO res.line_cd, res.subline_cd, res.iss_cd, res.peril_cd, res.intm_no, res.loss_cat_cd, res.enrollee, res.control_type, res.as_of_date,
                   res.control_number, res.pol_line_cd, res.pol_subline_cd, res.pol_iss_cd, res.issue_yy, res.pol_seq_no, res.renew_no, res.per_buss_param, res.per_issource_param, res.per_line_subline_param,
                   res.per_policy_param, res.per_enrollee_param, res.per_line_param, res.per_branch_param, res.per_intm_param, res.per_loss_cat_param 
              FROM gicl_res_brdrx_extr_param
             WHERE user_id = p_user_id; 
               
            IF res.dsp_from_date IS NULL THEN
                res.date_option := 2;
                res.dsp_as_of_date := TO_CHAR(v_to_date,'mm-dd-yyyy');
            ELSE
                res.date_option := 1;
                res.dsp_to_date := TO_CHAR(v_to_date,'mm-dd-yyyy');
            END IF;
        
        EXCEPTION
		    WHEN NO_DATA_FOUND THEN
		        res.date_option := 1;
		        res.dsp_rcvry_from_date := NULL;
                res.dsp_rcvry_to_date   := NULL;
        END;
        
        PIPE ROW(res);
    END when_new_block_e010;
    
    PROCEDURE get_policy_number_gicls202(
        p_user_id           IN  gicl_res_brdrx_extr.user_id%TYPE, 
        p_dsp_line_cd2      OUT gicl_res_brdrx_extr.line_cd%TYPE,
        p_dsp_subline_cd2   OUT gicl_res_brdrx_extr.subline_cd%TYPE,
        p_dsp_iss_cd2       OUT gicl_res_brdrx_extr.iss_cd%TYPE,
        p_dsp_issue_yy      OUT gicl_res_brdrx_extr.issue_yy%TYPE,
        p_dsp_pol_seq_no    OUT gicl_res_brdrx_extr.pol_seq_no%TYPE,
        p_dsp_renew_no      OUT gicl_res_brdrx_extr.renew_no%TYPE,
        p_too_many_rows     OUT VARCHAR2
    ) IS
    BEGIN
        p_too_many_rows := 'N';
    
        SELECT DISTINCT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no
          INTO p_dsp_line_cd2, p_dsp_subline_cd2, p_dsp_iss_cd2, p_dsp_issue_yy, p_dsp_pol_seq_no, p_dsp_renew_no
          FROM gicl_res_brdrx_extr
         WHERE user_id = p_user_id;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_dsp_line_cd2 := NULL;
            p_dsp_subline_cd2 := NULL;
            p_dsp_iss_cd2 := NULL;
            p_dsp_issue_yy := NULL;
            p_dsp_pol_seq_no := NULL;
            p_dsp_renew_no := NULL;
            p_too_many_rows := 'Y';
    END get_policy_number_gicls202;
    
    FUNCTION get_session_id
    RETURN NUMBER IS
        v_session_id        gicl_res_brdrx_extr.session_id%TYPE;
    BEGIN
        FOR s IN (SELECT brdrx_session_id_s.NEXTVAL session_id
                    FROM dual)
        LOOP
            v_session_id := s.session_id;
            EXIT;
        END LOOP;
        
        RETURN v_session_id;	
    END;   
    
    FUNCTION get_gicl_res_brdrx_extr_count(
        p_session_id        gicl_res_brdrx_extr.session_id%TYPE
    ) RETURN NUMBER IS
        v_count             NUMBER;
    BEGIN
        BEGIN
            SELECT COUNT(*)
              INTO v_count
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_count := 0;
        END;
             
        RETURN v_count;
    END get_gicl_res_brdrx_extr_count;
    
    PROCEDURE delete_data_gicls202(
        p_user_id           giis_users.user_id%TYPE  
    )IS
    BEGIN
        DELETE FROM gicl_res_brdrx_rids_extr 
              WHERE user_id = p_user_id;
   
        DELETE FROM gicl_res_brdrx_ds_extr
              WHERE user_id = p_user_id;
   
        DELETE FROM gicl_res_brdrx_extr
              WHERE user_id = p_user_id;
    END delete_data_gicls202;
    
    PROCEDURE delete_rcvry_data_gicls202 IS
    BEGIN
        DELETE FROM gicl_rcvry_brdrx_rids_extr;
  
        DELETE FROM gicl_rcvry_brdrx_ds_extr;

        DELETE FROM gicl_rcvry_brdrx_extr;
    END delete_rcvry_data_gicls202;
    
    PROCEDURE reset_record_id(
        p_brdrx_record_id         IN OUT gicl_res_brdrx_extr.brdrx_record_id%TYPE,
        p_brdrx_ds_record_id      IN OUT gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE, 
        p_brdrx_rids_record_id    IN OUT gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE
    ) IS
    BEGIN
        p_brdrx_record_id         := 0; 
        p_brdrx_ds_record_id      := 0; 
        p_brdrx_rids_record_id    := 0;
    END;
    
    PROCEDURE extract_gicls202(
        p_user_id           IN giis_users.user_id%TYPE,
        p_branch_option     IN NUMBER,
        p_brdrx_date_option IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_date_option       IN NUMBER,
        p_dsp_as_of_date    IN DATE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd2      IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd2   IN gicl_claims.subline_cd%TYPE,
        p_dsp_iss_cd2       IN gicl_claims.iss_cd%TYPE,
        p_dsp_issue_yy      IN gicl_claims.issue_yy%TYPE,
        p_dsp_pol_seq_no    IN gicl_claims.pol_seq_no%TYPE,
        p_dsp_renew_no      IN gicl_claims.renew_no%TYPE,
        p_dsp_gross_tag     IN NUMBER,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE, 
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_dsp_enrollee      IN gicl_accident_dtl.grouped_item_title%TYPE,
        p_dsp_control_type  IN gicl_accident_dtl.control_type_cd%TYPE,
        p_dsp_control_number IN gicl_accident_dtl.control_cd%TYPE,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_enrollee      IN NUMBER, 
        p_per_intermediary  IN NUMBER,
        p_per_issource      IN NUMBER,
        p_per_line_subline  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_per_policy        IN NUMBER,
        p_reg_button        IN NUMBER,
        p_rep_name          IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_count             OUT NUMBER,
        p_impl_sw           OUT giis_parameters.param_value_v%TYPE
    ) IS
        v_session_id              gicl_res_brdrx_extr.session_id%TYPE;
        v_brdrx_record_id         gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
        v_brdrx_ds_record_id      gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE; 
        v_brdrx_rids_record_id    gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
        v_exist                   VARCHAR2(1);
        v_postexist               VARCHAR2(1);
        v_posted                  VARCHAR2(1);
    BEGIN
        delete_data_gicls202(p_user_id);
        delete_rcvry_data_gicls202;
        
        v_session_id := get_session_id;
        
        IF p_rep_name = 1 THEN -- radio bordereaux
            IF p_brdrx_type = 1 THEN -- radio outstanding
                IF p_date_option = 1 THEN -- radio from to date
                    IF p_brdrx_option =  1 THEN -- radio loss
                        IF p_per_buss = 1 THEN -- check per business source
                            reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);

                            erli_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,p_dsp_peril_cd,
                                                p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_loss_cat,
                                                p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                            
                            IF p_dsp_intm_no IS NULL THEN
                                erli_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                    p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,v_brdrx_record_id,
                                                    p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_issource,
                                                    p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                            END IF;
                            
                            erli_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id); 
                        ELSIF p_per_buss = 0 THEN
                            reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                            
                            erl_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_peril_cd,
                                            p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_rep_name,p_brdrx_type,
                                            p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,
                                            p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                            
                            erl_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,v_brdrx_ds_record_id,p_dsp_gross_tag,v_brdrx_rids_record_id);
                        END IF; 
                    ELSIF p_brdrx_option =  2 THEN --radio expense
                        IF p_per_buss = 1 THEN -- check per business source
                            reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                        
                            erei_extract_direct(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,p_ri_iss_cd,p_dsp_peril_cd,p_dsp_intm_no,p_dsp_line_cd,
                                                p_dsp_subline_cd,p_dsp_iss_cd,p_per_issource,p_per_line_subline,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,
                                                p_brdrx_type,p_brdrx_date_option,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_loss_cat,p_branch_option,
                                                p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                            IF p_dsp_intm_no IS NULL THEN
                                erei_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_per_issource,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,
                                                    p_dsp_to_date,p_dsp_line_cd,p_dsp_subline_cd,p_dsp_iss_cd,p_dsp_peril_cd,v_brdrx_record_id,
                                                    p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_loss_cat,
                                                    p_branch_option,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                            END IF;                                                
                            
                            erei_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                        ELSIF p_per_buss = 0 THEN
                            reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                        
                            ere_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_peril_cd,p_brdrx_date_option,
                                            p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,
                                            p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                            
                            ere_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                        END IF;
                    ELSIF p_brdrx_option =  3 THEN --radio loss+expense
                        IF p_per_buss = 1 THEN -- check per business source
                            reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);    
                        
                            erlei_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,p_dsp_peril_cd,
                                                 p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                 v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_loss_cat,
                                                 p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                            IF p_dsp_intm_no IS NULL THEN
                                erlei_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                     p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,v_brdrx_record_id,
                                                     p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_issource,
                                                     p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                            END IF;
                            
                            erlei_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                        ELSIF p_per_buss = 0 THEN
                            reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                        
                            erle_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_peril_cd,
                                             p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_rep_name,p_brdrx_type,
                                             p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,
                                             p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);                                                                                
                            
                            erle_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                        END IF;
                    END IF; --p_brdrx_option
                ELSIF p_date_option = 2 THEN -- radio as of date
                    IF p_brdrx_date_option = 3 THEN -- radio booking month
                        BEGIN
                            SELECT DISTINCT 'x' 
                              INTO v_exist
                              FROM gicl_take_up_hist a, giac_acctrans b
                             WHERE a.acct_tran_id = b.tran_id 
                               AND a.iss_cd = b.gibr_branch_cd
                               AND a.iss_cd = NVL(p_dsp_iss_cd,a.iss_cd)  
                               AND TRUNC(b.tran_date) = p_dsp_as_of_date
                               AND b.tran_flag <> 'D';
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                v_exist := NULL;
                        END;      
                        
                        IF v_exist IS NOT NULL THEN
              	            v_posted := 'N'; 
                            BEGIN
                                SELECT DISTINCT 'x' 
                                  INTO v_postexist
                                  FROM gicl_take_up_hist a, giac_acctrans b
                                 WHERE a.acct_tran_id = b.tran_id 
                                   AND a.iss_cd = b.gibr_branch_cd
                                   AND a.iss_cd = NVL(p_dsp_iss_cd,a.iss_cd)  
                                   AND TRUNC(b.posting_date) = p_dsp_as_of_date;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    v_postexist := NULL;
                            END;
                            
                            IF v_postexist IS NOT NULL THEN
                                v_posted := 'Y'; 
                            END IF;
                            
                            IF p_per_buss = 1 THEN -- check per business source
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                
                                ertui_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                  p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,
                                                  p_dsp_iss_cd,p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,
                                                  p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,
                                                  v_posted,v_brdrx_record_id);
                                                  
                                ertui_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id,v_posted);
                            ELSIF p_per_buss = 0 THEN                            
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                
                                ertu_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                 p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                 p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,
                                                 p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_posted,v_brdrx_record_id);
                                                 
                                ertu_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,v_posted,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                                
                            END IF;
                        ELSE -- v_exist
                            IF p_brdrx_option =  1 THEN -- loss
                                IF p_per_buss = 1 THEN -- check per business source
                                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                    erlia_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                                         p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,
                                                         p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,
                                                         p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,
                                                         p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
        
                                    IF p_dsp_intm_no IS NULL THEN
                                        erlia_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,
                                                             p_dsp_to_date,p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                             p_dsp_peril_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,
                                                             p_paid_date_option,p_per_buss,p_per_issource,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,
                                                             p_dsp_rcvry_from_date,p_dsp_rcvry_to_date); 
                                    END IF;
                                    
                                    erlia_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,p_dsp_gross_tag,
                                                               v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                                ELSIF p_per_buss = 0 THEN
                                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                
                                    erla_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                     p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                     p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,
                                                     p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                                     
                                    erla_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                                END IF; -- p_per_buss
                            ELSIF p_brdrx_option = 2 THEN -- expense
                                IF p_per_buss = 1 THEN -- check per business source
                                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                    ereia_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                                         p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,
                                                         p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,
                                                         p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                                         
                                    IF p_dsp_intm_no IS NULL THEN
                                        ereia_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                             p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,v_brdrx_record_id,
                                                             p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_issource,
                                                             p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                    END IF;   
                                    
                                    ereia_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);   
                                ELSIF p_per_buss = 0 THEN
                                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                    erea_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                     p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                     p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,
                                                     p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                                     
                                    erea_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                                END IF;
                            ELSIF p_brdrx_option = 3 THEN -- loss+expense
                                IF p_per_buss = 1 THEN -- check per business source
                                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                    erleia_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                                          p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,
                                                          p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,
                                                          p_brdrx_option,p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                                          
                                    IF p_dsp_intm_no IS NULL THEN
                                        erleia_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                              p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,
                                                              v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,
                                                              p_per_buss,p_per_issource,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                    END IF;
                                    
                                    erleia_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                                ELSIF p_per_buss = 0 THEN
                                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                    erlea_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                      p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                      p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,
                                                      p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                                      
                                    erlea_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                                END IF;
                            END IF; -- p_brdrx_option
                        END IF; -- v_exist 
                    ELSE -- IF p_brdrx_date_option = 3 THEN -- radio booking month --                    
                        IF p_brdrx_option =  1 THEN -- loss
                            IF p_per_buss = 1 THEN -- check per business source
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                erlia_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                                     p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,
                                                     p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,
                                                     p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,
                                                     p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
        
                                IF p_dsp_intm_no IS NULL THEN
                                    erlia_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,
                                                         p_dsp_to_date,p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                         p_dsp_peril_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,
                                                         p_paid_date_option,p_per_buss,p_per_issource,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,
                                                         p_dsp_rcvry_from_date,p_dsp_rcvry_to_date); 
                                END IF;
                                    
                                erlia_extract_distribution(p_user_id,v_session_id,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,p_dsp_gross_tag,
                                                           v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                            ELSIF p_per_buss = 0 THEN
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                
                                erla_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                 p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                 p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,
                                                 p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                                     
                                erla_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                            END IF; -- p_per_buss
                        ELSIF p_brdrx_option = 2 THEN -- expense                       
                            IF p_per_buss = 1 THEN -- check per business source
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                ereia_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                                     p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,
                                                     p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,
                                                     p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                                         
                                IF p_dsp_intm_no IS NULL THEN
                                    ereia_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                         p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,v_brdrx_record_id,
                                                         p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_issource,
                                                         p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                END IF;   
                                    
                                ereia_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                            ELSIF p_per_buss = 0 THEN
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                erea_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                 p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                 p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,
                                                 p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                                     
                                erea_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                            END IF; -- p_per_buss
                        ELSIF p_brdrx_option = 3 THEN -- loss+expense                            
                            IF p_per_buss = 1 THEN -- check per business source
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                erleia_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                                      p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,
                                                      p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,
                                                      p_brdrx_option,p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                                          
                                IF p_dsp_intm_no IS NULL THEN
                                    erleia_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                          p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,
                                                          v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,
                                                          p_per_buss,p_per_issource,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                END IF;
                                    
                                erleia_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                            ELSIF p_per_buss = 0 THEN
                                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                                    
                                erlea_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                  p_dsp_peril_cd,p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,
                                                  p_rep_name,p_brdrx_type,p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,
                                                  p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                                                      
                                erlea_extract_distribution(p_user_id,v_session_id,p_dsp_as_of_date,p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                            END IF; -- p_per_buss
                        END IF; -- p_brdrx_option
                    END IF; -- p_brdrx_date_option
                END IF; --p_date_option
            ELSIF p_brdrx_type = 2 THEN -- IF p_brdrx_type = 1 THEN -- radio outstanding :: Losses Paid                       
                IF p_per_policy = 0 AND p_per_enrollee = 0 THEN
                    IF p_per_buss = 1 THEN -- check per business source
                        reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                        
                        epli_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,
                                            p_dsp_as_of_date,p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,
                                            p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,
                                            p_brdrx_option,p_paid_date_option,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                            
                        IF p_dsp_intm_no IS NULL THEN
                            epli_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,
                                                p_dsp_as_of_date,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,
                                                v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,
                                                p_per_buss,p_per_issource,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                        END IF;
                        
                        epli_extract_distribution(p_user_id,v_session_id,p_brdrx_option,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                                  p_dsp_gross_tag,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                    ELSIF p_per_buss = 0 THEN
                        reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                        
                        epl_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,p_dsp_peril_cd,
                                        p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_rep_name,p_brdrx_type,
                                        p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,
                                        p_dsp_rcvry_to_date,v_brdrx_record_id);
                        
                        epl_extract_distribution(p_user_id,v_session_id,p_brdrx_option,p_dsp_from_date,
                                                 p_dsp_to_date,p_dsp_as_of_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                    END IF; -- p_per_buss
                ELSIF p_per_policy = 1 THEN 
                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                    
                    eplp_extract_all(p_user_id,v_session_id,p_brdrx_option,p_paid_date_option,p_dsp_from_date,p_dsp_to_date,p_dsp_line_cd2,
                                     p_dsp_subline_cd2,p_dsp_iss_cd2,p_dsp_issue_yy,p_dsp_pol_seq_no,p_dsp_renew_no,v_brdrx_record_id);
                    
                    eplp_extract_distribution(p_user_id,v_session_id,p_brdrx_option,p_dsp_from_date,p_dsp_to_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                ELSIF p_per_enrollee = 1 THEN --dito
                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                    
                    eple_extract_all(p_user_id,v_session_id,p_brdrx_option,p_paid_date_option,p_dsp_from_date,p_dsp_to_date,p_dsp_enrollee,
                                     p_dsp_control_type,p_dsp_control_number,v_brdrx_record_id);
                                                         
                    eple_extract_distribution(p_user_id,v_session_id,p_brdrx_option,p_dsp_from_date,p_dsp_to_date,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
                END IF; -- p_per_policy AND p_per_enrollee
            END IF; --p_brdx_type
            
            IF p_net_rcvry_chkbx = 'Y' THEN
                extract_brdrx_rcvry(v_session_id,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id,v_brdrx_ds_record_id,v_brdrx_rids_record_id);
            END IF;
        ELSIF p_rep_name = 2 THEN -- claims register
            IF p_per_intermediary = 1 THEN
                reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                
                edr_extract_direct(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_per_buss,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                   p_dsp_peril_cd,p_dsp_intm_no,p_ri_iss_cd,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,
                                   p_dsp_iss_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,p_brdrx_type,p_brdrx_option,p_paid_date_option,
                                   p_per_loss_cat,p_reg_button,p_dsp_loss_cat_cd,p_clm_exp_payee_type,p_clm_loss_payee_type,
                                   p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
                                   
                edr_extract_inward(p_user_id,v_session_id,p_per_line_subline,p_ri_iss_cd,p_brdrx_date_option,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,
                                   p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_dsp_peril_cd,v_brdrx_record_id,p_dsp_gross_tag,p_rep_name,
                                   p_brdrx_type,p_brdrx_option,p_paid_date_option,p_per_buss,p_per_issource,p_per_loss_cat,p_reg_button,p_dsp_loss_cat_cd,
                                   p_clm_exp_payee_type,p_clm_loss_payee_type,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date);
            ELSIF p_per_intermediary = 0 THEN
                IF p_dsp_intm_no IS NOT NULL THEN
                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                    
                    ecri_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,p_dsp_peril_cd,
                                     p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_rep_name,p_brdrx_type,
                                     p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,p_ri_iss_cd,p_clm_exp_payee_type,
                                     p_clm_loss_payee_type,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date,v_brdrx_record_id);
                ELSE
                    reset_record_id(v_brdrx_record_id, v_brdrx_ds_record_id, v_brdrx_rids_record_id);
                    
                    ecr_extract_all(p_user_id,v_session_id,p_per_issource,p_per_line_subline,p_dsp_from_date,p_dsp_to_date,p_dsp_as_of_date,p_dsp_peril_cd,
                                    p_dsp_intm_no,p_brdrx_date_option,p_dsp_line_cd,p_dsp_subline_cd,p_branch_option,p_dsp_iss_cd,p_rep_name,p_brdrx_type,
                                    p_brdrx_option,p_dsp_gross_tag,p_paid_date_option,p_per_buss,p_per_loss_cat,p_reg_button,p_ri_iss_cd,p_dsp_loss_cat_cd,
                                    p_clm_exp_payee_type,p_clm_loss_payee_type,p_net_rcvry_chkbx,p_dsp_rcvry_from_date,p_dsp_rcvry_to_date, v_brdrx_record_id);
                END IF;
            END IF;                    
        END IF; --p_rep_name
        
        p_impl_sw := giisp.v('IMPLEMENTATION_SW');
        p_count := get_gicl_res_brdrx_extr_count(v_session_id);
    END extract_gicls202;
    
    /*erli = EXTRACT_RESERVE_LOSS_INTM start*/
    PROCEDURE erli_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        v_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_intm_no           giis_intermediary.intm_no%TYPE;
        v_iss_cd            giis_issource.iss_cd%TYPE;
        v_subline_cd        giis_subline.subline_cd%TYPE;
    BEGIN
        FOR i IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, 
                         c.intm_no, c.shr_intm_pct, (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                         (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))*c.shr_intm_pct/100) loss_reserve,
                         (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))*c.shr_intm_pct/100) losses_paid,
                         d.line_cd, d.subline_cd, d.iss_cd, 
                         TO_NUMBER(TO_CHAR(d.loss_date,'YYYY')) loss_year,
                         d.assd_no, (d.line_cd||'-'||d.subline_cd||'-'||d.iss_cd||'-'||LTRIM(TO_CHAR(d.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(d.clm_seq_no,'0999999'))) claim_no,
                         (d.line_cd||'-'||d.subline_cd||'-'||d.pol_iss_cd||'-'||LTRIM(TO_CHAR(d.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(d.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(d.renew_no,'09'))) policy_no,
                         d.dsp_loss_date, d.loss_date, d.clm_file_date, d.pol_eff_date, d.expiry_date,
                         a.grouped_item_no, a.clm_res_hist_id
                    FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                   WHERE a.peril_cd = b.peril_cd
                     AND a.item_no  = b.item_no
                     AND a.claim_id = b.claim_id
                     AND b.claim_id = c.claim_id 
                     AND b.item_no  = c.item_no 
                     AND b.peril_cd = c.peril_cd 
                     AND b.claim_id = d.claim_id
                     AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                     AND TRUNC(NVL(a.date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date                             
                     AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                     AND TRUNC(DECODE(close_flag,'WD',b.close_date,'DN',b.close_date,'CC',b.close_date,
                                                 'DC',b.close_date,'CP',b.close_date, p_dsp_to_date + 1)) > p_dsp_to_date
                     AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                     AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                     AND d.pol_iss_cd <> p_ri_iss_cd
                     AND DECODE(p_brdrx_date_option,'1',TRUNC(d.dsp_loss_date),'2',TRUNC(d.clm_file_date))
                         BETWEEN p_dsp_from_date AND p_dsp_to_date
                     AND d.line_cd    = NVL(p_dsp_line_cd,d.line_cd)
                     AND d.subline_cd = NVL(p_dsp_subline_cd,d.subline_cd)
                     AND DECODE(p_branch_option,'1',d.iss_cd,'2',d.pol_iss_cd) 
                         = NVL(p_dsp_iss_cd,DECODE(p_branch_option,'1',d.iss_cd,'2',d.pol_iss_cd))
                   GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                            c.intm_no, c.shr_intm_pct, NVL(a.convert_rate,1),
                            d.line_cd, d.subline_cd, d.iss_cd, d.loss_date, d.assd_no, d.clm_yy, d.clm_seq_no,
                            d.pol_iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no,
                            d.dsp_loss_date, d.loss_date, d.clm_file_date, d.pol_eff_date, d.expiry_date,
                            a.grouped_item_no, a.clm_res_hist_id
                  HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)*c.shr_intm_pct/100)- 
                          SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)*c.shr_intm_pct/100)) <> 0
                   ORDER BY b.claim_id)
        LOOP
            v_intm_no := get_parent_intm_gicls202(i.intm_no);
            
             IF p_iss_break = '1' THEN
                v_iss_cd := i.iss_cd;
            ELSIF p_iss_break = '0' THEN
                v_iss_cd := 'DI';
            END IF;
            
            IF p_subline_break = '1' THEN
                v_subline_cd := i.subline_cd;
            ELSIF p_subline_break = '0' THEN
                v_subline_cd := '0';
            END IF;
            
            v_brdrx_record_id := v_brdrx_record_id + 1;
            
            IF p_dsp_gross_tag = 1 THEN
                INSERT INTO gicl_res_brdrx_extr 
                           (session_id,         brdrx_record_id,    claim_id,               iss_cd,                 buss_source,        line_cd,
                            subline_cd,         loss_year,          assd_no,                claim_no,               policy_no,          loss_date,
                            clm_file_date,      item_no,            peril_cd,               loss_cat_cd,            incept_date,        expiry_date,
                            tsi_amt,            intm_no,            loss_reserve,           user_id,                last_update,        extr_type,		
                            brdrx_type,         ol_date_opt,	    brdrx_rep_type,         res_tag,		        pd_date_opt,        intm_tag,
                            iss_cd_tag,         line_cd_tag,	    loss_cat_tag,           from_date,		        to_date,            branch_opt,
                            reg_date_opt,       net_rcvry_tag,	    rcvry_from_date,        rcvry_to_date,	        grouped_item_no,    clm_res_hist_id)    
                     VALUES(p_session_id,       v_brdrx_record_id,  i.claim_id,             v_iss_cd,               v_intm_no,          i.line_cd,
                            v_subline_cd,       i.loss_year,        i.assd_no,              i.claim_no,             i.policy_no,        i.dsp_loss_date, 
                            i.clm_file_date,    i.item_no,          i.peril_cd,             i.loss_cat_cd,          i.pol_eff_date,     i.expiry_date, 
                            i.tsi_amt,          i.intm_no,          i.loss_reserve, 	    p_user_id,              SYSDATE,            p_rep_name,
                            p_brdrx_type,       p_brdrx_date_option,p_brdrx_option,         p_dsp_gross_tag,	    p_paid_date_option, p_per_buss,	
                            p_iss_break,        p_subline_break,	p_per_loss_cat,         p_dsp_from_date,	    p_dsp_to_date,      p_branch_option,
                            p_reg_button,       p_net_rcvry_chkbx,	p_dsp_rcvry_from_date,  p_dsp_rcvry_to_date,    i.grouped_item_no,  i.clm_res_hist_id);
            ELSE
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,         brdrx_record_id,    claim_id,               iss_cd,                 buss_source,        line_cd,
                            subline_cd,         loss_year,          assd_no,                claim_no,               policy_no,          loss_date,
                            clm_file_date,      item_no,            peril_cd,               loss_cat_cd,            incept_date,        expiry_date,
                            tsi_amt,            intm_no,            loss_reserve,           losses_paid, 			user_id,		    last_update,
                            extr_type,			brdrx_type,         ol_date_opt,		    brdrx_rep_type,         res_tag,			pd_date_opt,
                            intm_tag,		    iss_cd_tag,         line_cd_tag,		    loss_cat_tag,           from_date,			to_date,
                            branch_opt,			reg_date_opt,       net_rcvry_tag,	        rcvry_from_date,        rcvry_to_date,	    grouped_item_no, 
                            clm_res_hist_id) 
                     VALUES(p_session_id,       v_brdrx_record_id,  i.claim_id,             v_iss_cd,               v_intm_no,          i.line_cd,
                            v_subline_cd,       i.loss_year,        i.assd_no,              i.claim_no,             i.policy_no,        i.dsp_loss_date, 
                            i.clm_file_date,    i.item_no,          i.peril_cd,             i.loss_cat_cd,          i.pol_eff_date,     i.expiry_date, 
                            i.tsi_amt,          i.intm_no,          i.loss_reserve,         i.losses_paid,          p_user_id, 			SYSDATE,
                            p_rep_name,		    p_brdrx_type,       p_brdrx_date_option,    p_brdrx_option,         p_dsp_gross_tag,    p_paid_date_option,
                            p_per_buss,	        p_iss_break,        p_subline_break,	    p_per_loss_cat,         p_dsp_from_date,    p_dsp_to_date,
                            p_branch_option,	p_reg_button,       p_net_rcvry_chkbx,	    p_dsp_rcvry_from_date,  p_dsp_rcvry_to_date,i.grouped_item_no,
                            i.clm_res_hist_id);               
            END IF;        
        END LOOP;
    END erli_extract_direct;
    
    FUNCTION get_parent_intm_gicls202(
        p_intrmdry_intm_no  giis_intermediary.intm_no%TYPE
    ) RETURN NUMBER IS
        v_intm_no           giis_intermediary.intm_no%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(a.parent_intm_no,a.intm_no)
              INTO v_intm_no
              FROM giis_intermediary a
             WHERE LEVEL = (SELECT MAX(LEVEL)
                              FROM giis_intermediary b
                           CONNECT BY PRIOR b.parent_intm_no = b.intm_no
                               AND lic_tag                   = 'N'
                             START WITH b.intm_no            = p_intrmdry_intm_no
                               AND lic_tag                   = 'N')
           CONNECT BY PRIOR a.parent_intm_no                 = a.intm_no 
             START WITH a.intm_no = p_intrmdry_intm_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_intm_no  := p_intrmdry_intm_no;
            WHEN OTHERS THEN    
                NULL;
        END;
        RETURN v_intm_no; 
    END get_parent_intm_gicls202;
    
    PROCEDURE erli_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd        giis_subline.subline_cd%TYPE;
        v_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd 
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd = p_ri_iss_cd   
                              AND DECODE(p_brdrx_date_option,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) 
                                  = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd)) 
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a,gicl_item_peril b,gicl_claims d
                                 WHERE a.peril_cd = b.peril_cd
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = d.claim_id
                                   AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(date_paid,p_dsp_to_date)) 
                                       BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date), p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag,'WD',b.close_date,'DN',b.close_date,'CC',b.close_date,'DC',b.close_date,
                                                               'CP',b.close_date, p_dsp_to_date + 1)) > p_dsp_to_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                          a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0)
            LOOP
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                
                v_brdrx_record_id := v_brdrx_record_id + 1; 
                
                IF p_dsp_gross_tag = 1 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,            loss_reserve,
                                user_id,	        last_update,
                                extr_type,		    brdrx_type,
                                ol_date_opt,	    brdrx_rep_type,
                                res_tag,		    pd_date_opt,
                                intm_tag,		    iss_cd_tag,
                                line_cd_tag,	    loss_cat_tag,
                                from_date,		    to_date,
                                branch_opt,		    reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,      grouped_item_no,    
                                clm_res_hist_id) 
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      claims_rec.iss_cd,
                                claims_rec.ri_cd,         claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,  reserve_rec.loss_reserve,
                                p_user_id, 			      SYSDATE,
                                p_rep_name,			      p_brdrx_type,
                                p_brdrx_date_option,      p_brdrx_option,
                                p_dsp_gross_tag,		  p_paid_date_option,
                                p_per_buss,	              p_iss_break,
                                p_subline_break,	      p_per_loss_cat,
                                p_dsp_from_date,		  p_dsp_to_date,
                                p_branch_option,	      p_reg_button,
                                p_net_rcvry_chkbx,	      p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,      reserve_rec.grouped_item_no, 
                                reserve_rec.clm_res_hist_id);
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,            loss_reserve,
                                losses_paid,        user_id,
                                last_update,        extr_type,
                                brdrx_type,         ol_date_opt,
                                brdrx_rep_type,     res_tag,
                                pd_date_opt,        intm_tag,
                                iss_cd_tag,         line_cd_tag,
                                loss_cat_tag,       from_date,			 
                                to_date,            branch_opt,			 
                                reg_date_opt,       net_rcvry_tag,	 
                                rcvry_from_date,    rcvry_to_date,	
                                grouped_item_no,    clm_res_hist_id)  
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            claims_rec.iss_cd,
                                claims_rec.ri_cd,               claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,        reserve_rec.loss_reserve, 
                                reserve_rec.losses_paid,        p_user_id, 										 
                                SYSDATE,                        p_rep_name,					 
                                p_brdrx_type,                   p_brdrx_date_option, 
                                p_brdrx_option,                 p_dsp_gross_tag,		 
                                p_paid_date_option,             p_per_buss,	 
                                p_iss_break,                    p_subline_break,	 
                                p_per_loss_cat,                 p_dsp_from_date,		 
                                p_dsp_to_date,                  p_branch_option,	   
                                p_reg_button,                   p_net_rcvry_chkbx,	 
                                p_dsp_rcvry_from_date,          p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);                  
                END IF;
            END LOOP;
        END LOOP;
    END erli_extract_inward;
    
    PROCEDURE erli_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id; 
    
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id  = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.expense_reserve* a.shr_pct/100) expense_reserve,
                                          (brdrx_extr_rec.expenses_paid* a.shr_pct/100) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no  = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd = brdrx_extr_rec.peril_cd
                                      AND a.item_no  = brdrx_extr_rec.item_no
                                      AND a.claim_id = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            expense_reserve,    expenses_paid, 
                            user_id,            last_update)
                     VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                            brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                            brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                            brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                            brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                            reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid,
                            p_user_id,                      SYSDATE);
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct_real/100) expense_reserve,
                                                (reserve_ds_rec.expenses_paid * a.shr_ri_pct_real/100) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                expense_reserve,      expenses_paid,
                                user_id,              last_update)
                         VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid,
                                p_user_id,                        SYSDATE);
                END LOOP;                                              
            END LOOP;
        END LOOP;
    END erli_extract_distribution;
    /*erli = EXTRACT_RESERVE_LOSS_INTM end*/
    
    /*erl = EXTRACT_RESERVE_LOSS start*/
    PROCEDURE erl_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source            gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd            giis_issource.iss_cd%TYPE;
        v_subline_cd        giis_subline.subline_cd%TYPE;
        v_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_source := 0;
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
      			                   (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                   SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                   SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
			                       c.line_cd, c.subline_cd, c.iss_cd, 
		                           TO_NUMBER(TO_CHAR(c.loss_date,'YYYY')) loss_year,
		                           c.assd_no, (c.line_cd||'-'||c.subline_cd||'-'||c.iss_cd||'-'||
		                           LTRIM(TO_CHAR(c.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(c.clm_seq_no,'0999999'))) claim_no,
		                           (c.line_cd||'-'||c.subline_cd||'-'||c.pol_iss_cd||'-'||LTRIM(TO_CHAR(c.issue_yy,'09'))||'-'||
		                           LTRIM(TO_CHAR(c.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(c.renew_no,'09'))) policy_no,
                                   c.dsp_loss_date, c.loss_date, c.clm_file_date, c.pol_eff_date, c.expiry_date,b.grouped_item_no,
                                   a.clm_res_hist_id
                              FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                             WHERE a.claim_id = b.claim_id
                               AND a.item_no  = b.item_no
                               AND a.peril_cd = b.peril_cd
                               AND b.claim_id = c.claim_id
                               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                               AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                               AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                               AND TRUNC(DECODE(close_flag,'WD',b.close_date,'DN',b.close_date,'CC',b.close_date,
                                                           'DC',b.close_date,'CP',b.close_date, p_dsp_to_date + 1)) > p_dsp_to_date
                               AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)                               
                               AND DECODE(p_brdrx_date_option,1,TRUNC(c.loss_date),2,TRUNC(c.clm_file_date))
                                   BETWEEN p_dsp_from_date AND p_dsp_to_date
                               AND c.line_cd    = NVL(p_dsp_line_cd,c.line_cd)
                               AND c.subline_cd = NVL(p_dsp_subline_cd,c.subline_cd)
                               AND DECODE(p_branch_option,1,c.iss_cd,2,c.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,c.iss_cd,2,c.pol_iss_cd))
                             GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                   c.line_cd, c.subline_cd, c.iss_cd, c.loss_date, c.assd_no, c.clm_yy, c.clm_seq_no,
                                   c.pol_iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no,
                                   c.dsp_loss_date, c.loss_date, c.clm_file_date, c.pol_eff_date, c.expiry_date,b.grouped_item_no,
                                   a.clm_res_hist_id
                            HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                    SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0
                             ORDER BY a.claim_id)
        LOOP
            BEGIN
                IF p_iss_break = 1 THEN
                   v_iss_cd := reserve_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                   v_iss_cd := '0';
                END IF;
                
                IF p_subline_break = 1 THEN
                   v_subline_cd := reserve_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                   v_subline_cd := '0';
                END IF;  
                            
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id, 
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       loss_reserve, 			 
                                user_id,       last_update,
                                extr_type,	   brdrx_type,
                                ol_date_opt,   brdrx_rep_type,
                                res_tag,	   pd_date_opt,
                                intm_tag,	   iss_cd_tag,
                                line_cd_tag,   loss_cat_tag,
                                from_date,	   to_date,
                                branch_opt,	   reg_date_opt,
                                net_rcvry_tag, rcvry_from_date,
                                rcvry_to_date, grouped_item_no,
                                clm_res_hist_id)
                         VALUES(p_session_id,               v_brdrx_record_id,
                                reserve_rec.claim_id,       v_iss_cd,
                                v_source,                   reserve_rec.line_cd,
                                v_subline_cd,               reserve_rec.loss_year,
                                reserve_rec.assd_no,        reserve_rec.claim_no,
                                reserve_rec.policy_no,      reserve_rec.dsp_loss_date,
                                reserve_rec.clm_file_date,  reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                reserve_rec.pol_eff_date,   reserve_rec.expiry_date,
                                reserve_rec.ann_tsi_amt,    reserve_rec.loss_reserve, 					
                                p_user_id,                  SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,        reserve_rec.grouped_item_no,
                                reserve_rec.clm_res_hist_id); 
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       loss_reserve,  
                                losses_paid,   user_id,				
                                last_update,   
                                extr_type,		brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,  grouped_item_no,
                                clm_res_hist_id)  
                         VALUES(p_session_id,               v_brdrx_record_id,
                                reserve_rec.claim_id,       v_iss_cd,
                                v_source,                   reserve_rec.line_cd,
                                v_subline_cd,               reserve_rec.loss_year,
                                reserve_rec.assd_no,        reserve_rec.claim_no,
                                reserve_rec.policy_no,      reserve_rec.dsp_loss_date,
                                reserve_rec.clm_file_date,  reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                reserve_rec.pol_eff_date,   reserve_rec.expiry_date,
                                reserve_rec.ann_tsi_amt,    reserve_rec.loss_reserve, 
                                reserve_rec.losses_paid,    p_user_id, 										 
                                SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,        reserve_rec.grouped_item_no,
                                reserve_rec.clm_res_hist_id);  
                END IF;
            END;
        END LOOP;
    END erl_extract_all;
    
    PROCEDURE erl_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE; 
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;  
    
	    FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.losses_paid
                                 FROM gicl_res_brdrx_extr a, gicl_clm_res_hist b, gicl_claims c
                                WHERE session_id  = p_session_id
                                  AND a.claim_id = b.claim_id
                                  AND a.claim_id = c.claim_id
                                  AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                GROUP BY a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                         a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                         a.loss_cat_cd, a.loss_reserve, a.losses_paid)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                          SUM(DECODE(b.dist_sw,'Y',NVL(b.loss_reserve,0)*a.shr_pct/100,0)
             			                      * NVL(b.convert_rate,1)) loss_reserve, 
                                          SUM(DECODE(b.dist_sw,NULL,NVL(b.losses_paid,0)*a.shr_pct/100,0)
             			                      * NVL(b.convert_rate,1)) losses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no  = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd = brdrx_extr_rec.peril_cd
                                      AND a.item_no  = brdrx_extr_rec.item_no
                                      AND a.claim_id = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN 
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                loss_reserve,       
                                user_id,            last_update)
                         VALUES(p_session_id,              brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,      brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,     brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,    brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,  brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,   brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no, reserve_ds_rec.shr_pct,
                                reserve_ds_rec.loss_reserve, 
                                p_user_id,          SYSDATE);
                ELSE
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,         
                                loss_reserve,       losses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,        brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_ds_rec.shr_pct,         
                                reserve_ds_rec.loss_reserve, reserve_ds_rec.losses_paid, 
                                p_user_id,                   SYSDATE);                
                END IF;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                SUM(DECODE(b.dist_sw,'Y',NVL(b.loss_reserve,0)*a.shr_ri_pct/100,0)
             			                            * NVL(b.convert_rate,1)) loss_reserve,
                                                SUM(DECODE(b.dist_sw,NULL,NVL(b.losses_paid,0)*a.shr_ri_pct/100,0)
             			                            * NVL(b.convert_rate,1)) losses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    IF p_dsp_gross_tag = 1 THEN
                       INSERT INTO gicl_res_brdrx_rids_extr 
                                  (session_id,           brdrx_ds_record_id,
                                   brdrx_rids_record_id, claim_id,
                                   iss_cd,               buss_source,
                                   line_cd,              subline_cd,
                                   loss_year,            item_no,
                                   peril_cd,             loss_cat_cd,
                                   grp_seq_no,           ri_cd,
                                   prnt_ri_cd,           shr_ri_pct,
                                   loss_reserve,         user_id, 
                                   last_update)
                            VALUES(p_session_id,                    v_brdrx_ds_record_id,
                                   v_brdrx_rids_record_id,          brdrx_extr_rec.claim_id,
                                   brdrx_extr_rec.iss_cd,           brdrx_extr_rec.buss_source,
                                   brdrx_extr_rec.line_cd,          brdrx_extr_rec.subline_cd,
                                   brdrx_extr_rec.loss_year,        brdrx_extr_rec.item_no,
                                   brdrx_extr_rec.peril_cd,         brdrx_extr_rec.loss_cat_cd, 
                                   reserve_ds_rec.grp_seq_no,       reserve_rids_rec.ri_cd,
                                   reserve_rids_rec.prnt_ri_cd,     reserve_rids_rec.shr_ri_pct_real,
                                   reserve_rids_rec.loss_reserve,   p_user_id, 
                                   SYSDATE);
                    ELSE 
                       INSERT INTO gicl_res_brdrx_rids_extr 
                                  (session_id,           brdrx_ds_record_id,
                                   brdrx_rids_record_id, claim_id,
                                   iss_cd,               buss_source,
                                   line_cd,              subline_cd,
                                   loss_year,            item_no,
                                   peril_cd,             loss_cat_cd,
                                   grp_seq_no,           ri_cd,
                                   prnt_ri_cd,           shr_ri_pct,
                                   loss_reserve,         losses_paid, 
                                   user_id,              last_update)
                            VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                   v_brdrx_rids_record_id,        brdrx_extr_rec.claim_id,
                                   brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                   brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                   brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                   brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                   reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                   reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                   reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid, 
                                   p_user_id,                     SYSDATE);
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;
    END erl_extract_distribution;
    /*erl = EXTRACT_RESERVE_LOSS end*/
    
    /*erei = EXTRACT_RESERVE_EXP_INTM start*/
    PROCEDURE erei_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_date_option IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_branch_option     IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE;
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd <> p_ri_iss_cd
                              AND DECODE(p_brdrx_date_option,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) 
                                         = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))                              
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                           ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       c.intm_no, c.shr_intm_pct, (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                       (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))
                                            *c.shr_intm_pct/100) expense_reserve,
                                       (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))
                                            *c.shr_intm_pct/100) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                                 WHERE a.peril_cd = b.peril_cd
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = c.claim_id 
                                   AND b.item_no  = c.item_no 
                                   AND b.peril_cd = c.peril_cd 
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = d.claim_id
                                   AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(a.date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                 AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                 AND TRUNC(DECODE(close_flag2,'WD',close_date2,'DN',close_date2,'CC',close_date2,
                                                              'DC',close_date2,'CP',close_date2,p_dsp_to_date + 1)) > p_dsp_to_date
                                 AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                               GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                                        c.intm_no, c.shr_intm_pct, NVL(a.convert_rate,1),
                                        a.grouped_item_no, a.clm_res_hist_id
                              HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)*c.shr_intm_pct/100)- 
                                      SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)*c.shr_intm_pct/100)) <> 0)
            LOOP
                v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
                
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := 'DI';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;              
                
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN    
                    INSERT INTO gicl_res_brdrx_extr 
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        intm_no,  
                                expense_reserve,user_id,
                                last_update,
                                extr_type,	    brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,	
                                grouped_item_no,clm_res_hist_id)   
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_intm_no,                claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,      reserve_rec.intm_no,
                                reserve_rec.expense_reserve,p_user_id, 
                                SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id
                              );
                END IF;
            END LOOP;
        END LOOP;
        
        p_brdrx_record_id := v_brdrx_record_id;
    END erei_extract_direct;
    
    PROCEDURE erei_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_iss_break         IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_branch_option     IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd        giis_subline.subline_cd%TYPE;
        v_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE;
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd 
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd = p_ri_iss_cd
                              AND DECODE(p_brdrx_date_option,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) 
                                  = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd)) 
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.peril_cd = b.peril_cd
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag2,'WD',close_date2,'DN',close_date2,'CC',close_date2,
                                                                'DC',close_date2,'CP',close_date2, p_dsp_to_date + 1)) > p_dsp_to_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                          a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0)
            LOOP
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF; 
                
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN   
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        expense_reserve,
                                user_id,		last_update,
                                extr_type,		brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,	
                                grouped_item_no,clm_res_hist_id) 
                         VALUES(p_session_id,               v_brdrx_record_id,
                                claims_rec.claim_id,        claims_rec.iss_cd,
                                claims_rec.ri_cd,           claims_rec.line_cd,
                                v_subline_cd,               claims_rec.loss_year,
                                claims_rec.assd_no,         claims_rec.claim_no,
                                claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,   reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,    claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,    reserve_rec.expense_reserve,
                                p_user_id, 				    SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id); 
                ELSE        
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,  
                                expense_reserve,    expenses_paid,
                                user_id,  			last_update,
                                extr_type,			brdrx_type,
                                ol_date_opt,		brdrx_rep_type,
                                res_tag,			pd_date_opt,
                                intm_tag,			iss_cd_tag,
                                line_cd_tag,		loss_cat_tag,
                                from_date,			to_date,
                                branch_opt,			reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,	
                                grouped_item_no,    clm_res_hist_id)
                         VALUES(p_session_id,               v_brdrx_record_id,
                                claims_rec.claim_id,        claims_rec.iss_cd,
                                claims_rec.ri_cd,           claims_rec.line_cd,
                                v_subline_cd,               claims_rec.loss_year,
                                claims_rec.assd_no,         claims_rec.claim_no,
                                claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,   reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,    claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,
                                reserve_rec.expense_reserve,reserve_rec.expenses_paid,
                                p_user_id, 					SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);                  
                END IF;    
            END LOOP;
        END LOOP;
    END erei_extract_inward;
    
    PROCEDURE erei_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,        
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE; 
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id  = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.expense_reserve* a.shr_pct/100) expense_reserve,
                                          (brdrx_extr_rec.expenses_paid* a.shr_pct/100) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd = brdrx_extr_rec.peril_cd
                                      AND a.item_no = brdrx_extr_rec.item_no
                                      AND a.claim_id = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            expense_reserve,    expenses_paid, 
                            user_id,            last_update)
                     VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                            brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                            brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                            brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                            brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                            reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid,
                            p_user_id,                      SYSDATE);
                            
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct_real/100) expense_reserve,
                                                (reserve_ds_rec.expenses_paid * a.shr_ri_pct_real/100) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                expense_reserve,      expenses_paid,
                                user_id,              last_update)
                         VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid,
                                p_user_id,                        SYSDATE);                    
                END LOOP;
            END LOOP;
        END LOOP;
    END erei_extract_distribution;   
    /*erei = EXTRACT_RESERVE_EXP_INTM end*/
    
    /*ere = EXTRACT_RESERVE_EXP start*/
    PROCEDURE ere_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE;
    BEGIN
        v_source := 0; 
        v_brdrx_record_id := p_brdrx_record_id;
        
		FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                   (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                   SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                   SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                   c.line_cd, c.subline_cd, c.iss_cd, 
                                   TO_NUMBER(TO_CHAR(c.loss_date,'YYYY')) loss_year,
                                   c.assd_no, (c.line_cd||'-'||c.subline_cd||'-'||c.iss_cd||'-'||
                                   LTRIM(TO_CHAR(c.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(c.clm_seq_no,'0999999'))) claim_no,
                                   (c.line_cd||'-'||c.subline_cd||'-'||c.pol_iss_cd||'-'||LTRIM(TO_CHAR(c.issue_yy,'09'))||'-'||
                                   LTRIM(TO_CHAR(c.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(c.renew_no,'09'))) policy_no,
                                   c.dsp_loss_date, c.loss_date, c.clm_file_date, c.pol_eff_date, c.expiry_date,
                                   a.grouped_item_no, a.clm_res_hist_id
                              FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                             WHERE a.claim_id = b.claim_id
                               AND a.item_no  = b.item_no
                               AND a.peril_cd = b.peril_cd      
                               AND a.claim_id = c.claim_id 
                               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                               AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                               AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date 		 		      
                               AND TRUNC(DECODE(close_flag2,'WD',close_date2,'DN',close_date2,'CC',close_date2,
                                                            'DC',close_date2,'CP',close_date2, p_dsp_to_date + 1)) > p_dsp_to_date 
                               AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                               AND c.clm_stat_cd NOT IN ('CC','CD','DN','WD')
                               AND DECODE(p_brdrx_date_option,1,TRUNC(c.dsp_loss_date),2,TRUNC(c.clm_file_date))
                                   BETWEEN p_dsp_from_date AND p_dsp_to_date
                               AND c.line_cd    = NVL(p_dsp_line_cd,c.line_cd)
                               AND c.subline_cd = NVL(p_dsp_subline_cd,c.subline_cd)
                               AND DECODE(p_branch_option,1,c.iss_cd,2,c.pol_iss_cd) 
                                   = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,c.iss_cd,2,c.pol_iss_cd)) 
                             GROUP BY a.claim_id , a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                   c.line_cd, c.subline_cd, c.iss_cd, c.loss_date, c.assd_no, c.clm_yy, c.clm_seq_no,
                                   c.pol_iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no,
                                   c.dsp_loss_date, c.loss_date, c.clm_file_date, c.pol_eff_date, c.expiry_date,
                                   a.grouped_item_no, a.clm_res_hist_id
                            HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                    SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0
                             ORDER BY a.claim_id)
        LOOP
            IF p_iss_break = 1 THEN
                v_iss_cd := reserve_rec.iss_cd;
            ELSIF p_iss_break = 0 THEN
                v_iss_cd := '0';
            END IF;
            
            IF p_subline_break = 1 THEN
                v_subline_cd := reserve_rec.subline_cd;
            ELSIF p_subline_break = 0 THEN
                v_subline_cd := '0';
            END IF;              
            
            v_brdrx_record_id := v_brdrx_record_id + 1;
            
            IF p_dsp_gross_tag = 1 THEN
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,		    brdrx_record_id, 
                            claim_id,      	    iss_cd,
                            buss_source,   	    line_cd,
                            subline_cd,    	    loss_year,
                            assd_no,       	    claim_no,
                            policy_no,     	    loss_date,
                            clm_file_date, 	    item_no,
                            peril_cd,      	    loss_cat_cd,
                            incept_date,   	    expiry_date,
                            tsi_amt,       	   
                            expense_reserve,    user_id,
                      	    last_update,		extr_type, 
                      		brdrx_type,			ol_date_opt,
                      		brdrx_rep_type,		res_tag,
                      		pd_date_opt,		intm_tag,
                      		iss_cd_tag,			line_cd_tag,
                      		loss_cat_tag,		from_date,
                      		to_date,			branch_opt,
                      		reg_date_opt,		net_rcvry_tag,
                      		rcvry_from_date,	rcvry_to_date,
                      		grouped_item_no,    clm_res_hist_id) 
                    VALUES (p_session_id,		v_brdrx_record_id,
                            reserve_rec.claim_id,      		v_iss_cd,
                            v_source,                 		reserve_rec.line_cd,
                            v_subline_cd,             		reserve_rec.loss_year,
                            reserve_rec.assd_no,       		reserve_rec.claim_no,
                            reserve_rec.policy_no,     		reserve_rec.dsp_loss_date,
                            reserve_rec.clm_file_date, 		reserve_rec.item_no,
                            reserve_rec.peril_cd,     		reserve_rec.loss_cat_cd,
                            reserve_rec.pol_eff_date,  		reserve_rec.expiry_date,
                            reserve_rec.ann_tsi_amt,  		
                            reserve_rec.expense_reserve,    p_user_id, 
                      	    SYSDATE,						p_rep_name,
                      	    p_brdrx_type,					p_brdrx_date_option,
                      	    p_brdrx_option,					p_dsp_gross_tag,
                      	    p_paid_date_option,				p_per_buss,
                      	    p_iss_break,					p_subline_break,
                      	    p_per_loss_cat,					p_dsp_from_date,
                      	    p_dsp_to_date,					p_branch_option,
                      	    p_reg_button,					p_net_rcvry_chkbx,
                      	    p_dsp_rcvry_from_date,		    p_dsp_rcvry_to_date,
                      	    reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);
                ELSE      
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,		    brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,           
                                expense_reserve,    expenses_paid, 			 
                                user_id,            last_update, 
                                extr_type, 				 
                      	        brdrx_type,			ol_date_opt,
                      		    brdrx_rep_type,		res_tag,
                      		    pd_date_opt,		intm_tag,
                      		    iss_cd_tag,			line_cd_tag,
                      		    loss_cat_tag,		from_date,
                      		    to_date,			branch_opt,
                      		    reg_date_opt,		net_rcvry_tag,
                      		    rcvry_from_date,	rcvry_to_date,
                      		    grouped_item_no,    clm_res_hist_id)
                        VALUES (p_session_id,					v_brdrx_record_id,
                                reserve_rec.claim_id,         	v_iss_cd,
                                v_source,                    	reserve_rec.line_cd,
                                v_subline_cd,                	reserve_rec.loss_year,
                                reserve_rec.assd_no,          	reserve_rec.claim_no,
                                reserve_rec.policy_no,        	reserve_rec.dsp_loss_date,
                                reserve_rec.clm_file_date,    	reserve_rec.item_no,
                                reserve_rec.peril_cd,        	reserve_rec.loss_cat_cd,
                                reserve_rec.pol_eff_date,     	reserve_rec.expiry_date,
                                reserve_rec.ann_tsi_amt,     	
                                reserve_rec.expense_reserve, 	reserve_rec.expenses_paid, 					
                                p_user_id,                      SYSDATE,
                                p_rep_name,
                      	        p_brdrx_type,					p_brdrx_date_option,
                      	        p_brdrx_option,					p_dsp_gross_tag,
                      	        p_paid_date_option,				p_per_buss,
                      	        p_iss_break,					p_subline_break,
                      	        p_per_loss_cat,					p_dsp_from_date,
                      	        p_dsp_to_date,					p_branch_option,
                      	        p_reg_button,					p_net_rcvry_chkbx,
                      	        p_dsp_rcvry_from_date,		    p_dsp_rcvry_to_date,
                      	        reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);
          END IF;
        END LOOP;
    END ere_extract_all;
    
    PROCEDURE ere_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_gross_tag     IN NUMBER,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE; 
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                      a.grp_seq_no, a.shr_pct,
                                      SUM(DECODE(b.dist_sw,'Y',NVL(b.expense_reserve,0)*a.shr_pct/100,0)) expense_reserve,
                                      SUM(DECODE(b.dist_sw,NULL,NVL(b.expenses_paid,0)*a.shr_pct/100,0)) expenses_paid,
                                      c.brdrx_record_id, c.iss_cd, c.buss_source,
                                      c.line_cd, c.subline_cd, c.loss_year, c.item_no, c.peril_cd,
                                      c.loss_cat_cd
                                 FROM gicl_clm_res_hist b, gicl_reserve_ds a,
                                      (SELECT c.brdrx_record_id, c.claim_id, c.iss_cd, c.buss_source,
                                              c.line_cd, c.subline_cd, c.loss_year, c.item_no, c.peril_cd,
                                              c.loss_cat_cd
                                         FROM gicl_res_brdrx_extr c
                                        WHERE session_id = p_session_id) c
                                WHERE a.claim_id = b.claim_id
                                  AND a.item_no = b.item_no 
                                  AND a.peril_cd = b.peril_cd
                                  AND b.peril_cd = c.peril_cd
                                  AND b.item_no = c.item_no
                                  AND b.claim_id = c.claim_id
                                  AND NVL(a.negate_tag,'N')  = 'N'
                                  AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                  AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                         c.brdrx_record_id, c.iss_cd, c.buss_source,
                                         c.line_cd, c.subline_cd, c.loss_year, c.item_no, c.peril_cd,
                                         c.loss_cat_cd)
        LOOP
            v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
            IF p_dsp_gross_tag = 1 THEN 
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            expense_reserve,    user_id, 
                            last_update)
                     VALUES(p_session_id,                   reserve_ds_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,           reserve_ds_rec.claim_id,
                            reserve_ds_rec.iss_cd,          reserve_ds_rec.buss_source,
                            reserve_ds_rec.line_cd,         reserve_ds_rec.subline_cd,
                            reserve_ds_rec.loss_year,       reserve_ds_rec.item_no,
                            reserve_ds_rec.peril_cd,        reserve_ds_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                            reserve_ds_rec.expense_reserve, p_user_id,
                            SYSDATE);
            ELSE
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,         
                            expense_reserve,    expenses_paid,
                            user_id,            last_update)
                     VALUES(p_session_id,                   reserve_ds_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,           reserve_ds_rec.claim_id,
                            reserve_ds_rec.iss_cd,          reserve_ds_rec.buss_source,
                            reserve_ds_rec.line_cd,         reserve_ds_rec.subline_cd,
                            reserve_ds_rec.loss_year,       reserve_ds_rec.item_no,
                            reserve_ds_rec.peril_cd,        reserve_ds_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,         
                            reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid,
                            p_user_id,                      SYSDATE);
            END IF; 
            
            FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                            SUM(DECODE(b.dist_sw,'Y',NVL(b.expense_reserve,0)*a.shr_ri_pct/100,0)) expense_reserve,
                                            SUM(DECODE(b.dist_sw,NULL,NVL(b.expenses_paid,0)*a.shr_ri_pct/100,0)) expenses_paid
                                       FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                      WHERE a.claim_id = b.claim_id
                                        AND a.item_no = b.item_no
                                        AND a.peril_cd = b.peril_cd
                                        AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                        AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                        AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                        AND a.claim_id        = reserve_ds_rec.claim_id
                                        AND a.claim_id = c.claim_id
                                        AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                        AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                        AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                      GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real) 
            LOOP
                v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                IF p_dsp_gross_tag = 1 THEN
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                expense_reserve,      user_id,
                                last_update)
                         VALUES(p_session_id,                    v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,          reserve_ds_rec.claim_id,
                                reserve_ds_rec.iss_cd,           reserve_ds_rec.buss_source,
                                reserve_ds_rec.line_cd,          reserve_ds_rec.subline_cd,
                                reserve_ds_rec.loss_year,        reserve_ds_rec.item_no,
                                reserve_ds_rec.peril_cd,         reserve_ds_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,       reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,     reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.expense_reserve,p_user_id, 
                                SYSDATE);
                ELSE 
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                expense_reserve,      expenses_paid,
                                user_id,              last_update)
                         VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,           reserve_ds_rec.claim_id,
                                reserve_ds_rec.iss_cd,            reserve_ds_rec.buss_source,
                                reserve_ds_rec.line_cd,           reserve_ds_rec.subline_cd,
                                reserve_ds_rec.loss_year,         reserve_ds_rec.item_no,
                                reserve_ds_rec.peril_cd,          reserve_ds_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid,
                                p_user_id,                        SYSDATE);
                END IF;
            END LOOP;
        END LOOP;
    END ere_extract_distribution;
    /*ere = EXTRACT_RESERVE_EXP end*/
	
    /*erlei = EXTRACT_RESERVE_LOSS_EXP_INTM start*/
    PROCEDURE erlei_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        v_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
    BEGIN
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd <> p_ri_iss_cd
                              AND DECODE(p_brdrx_date_option,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            --loss_reserve
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       c.intm_no, c.shr_intm_pct, (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                       (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))*c.shr_intm_pct/100) loss_reserve,
                                       (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))*c.shr_intm_pct/100) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                                 WHERE a.peril_cd = b.peril_cd
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = c.claim_id 
                                   AND b.item_no  = c.item_no 
                                   AND b.peril_cd = c.peril_cd 
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = d.claim_id
                                   AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(a.date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date                                            
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag,'WD',b.close_date,'DN',b.close_date,'CC',b.close_date,
                                                               'DC',b.close_date,'CP',b.close_date, p_dsp_to_date + 1)) > p_dsp_to_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                   AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                                       c.intm_no, c.shr_intm_pct, NVL(a.convert_rate, 1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)*c.shr_intm_pct/100)- 
                                        SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)*c.shr_intm_pct/100)) <> 0)
            LOOP
                v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
                
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := 'DI';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                              
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN    
                    INSERT INTO gicl_res_brdrx_extr 
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        intm_no,  
                                loss_reserve,   user_id,
                                last_update,
                                extr_type,		brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,clm_res_hist_id)
                         VALUES(p_session_id,               v_brdrx_record_id,
                                claims_rec.claim_id,        v_iss_cd,
                                v_intm_no,                  claims_rec.line_cd,
                                v_subline_cd,               claims_rec.loss_year,
                                claims_rec.assd_no,         claims_rec.claim_no,
                                claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,   reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,    claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,        reserve_rec.intm_no,
                                reserve_rec.loss_reserve,   p_user_id, 
                                SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        intm_no,  
                                loss_reserve,   losses_paid, 			 
                                user_id,        last_update,
                                extr_type,		brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,clm_res_hist_id) 
                         VALUES(p_session_id,               v_brdrx_record_id,
                                claims_rec.claim_id,        v_iss_cd,
                                v_intm_no,                  claims_rec.line_cd,
                                v_subline_cd,               claims_rec.loss_year,
                                claims_rec.assd_no,         claims_rec.claim_no,
                                claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,   reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,    claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,        reserve_rec.intm_no,
                                reserve_rec.loss_reserve,   reserve_rec.losses_paid,
                                p_user_id, 				    SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                END IF;
            END LOOP;
            
            --expense_reserve
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       c.intm_no, c.shr_intm_pct,
                                       (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                       (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))*c.shr_intm_pct/100) expense_reserve,
                                       (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))*c.shr_intm_pct/100) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                                 WHERE a.peril_cd = b.peril_cd
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = c.claim_id 
                                   AND b.item_no  = c.item_no 
                                   AND b.peril_cd = c.peril_cd 
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = d.claim_id
                                   AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(a.date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag2,'WD',close_date2,'DN',close_date2,'CC',close_date2,
                                                                'DC',close_date2,'CP',close_date2, p_dsp_to_date + 1)) > p_dsp_to_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                   AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                                       c.intm_no, c.shr_intm_pct, NVL(a.convert_rate,1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)*c.shr_intm_pct/100)- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)*c.shr_intm_pct/100)) <> 0)
            LOOP
                v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
                
                IF p_iss_break = 1 THEN
                   v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                   v_iss_cd := 'DI';
                END IF;
                
                IF p_subline_break = 1 THEN
                   v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                   v_subline_cd := '0';
                END IF;              
                
                v_brdrx_record_id := v_brdrx_record_id + 1;
        
                IF p_dsp_gross_tag = 1 THEN    
                    INSERT INTO gicl_res_brdrx_extr 
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        intm_no,  
                                expense_reserve,user_id,
                                last_update,
                                extr_type,		brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,clm_res_hist_id) 
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            v_iss_cd,
                                v_intm_no,                      claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,            reserve_rec.intm_no,
                                reserve_rec.expense_reserve,    p_user_id, 
                                SYSDATE,
                                p_rep_name,					    p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,		        p_paid_date_option,
                                p_per_buss,	                    p_iss_break,
                                p_subline_break,	            p_per_loss_cat,
                                p_dsp_from_date,		        p_dsp_to_date,
                                p_branch_option,	            p_reg_button,
                                p_net_rcvry_chkbx,	            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,            intm_no,  
                                expense_reserve,    expenses_paid,
                                user_id, 			last_update,
                                extr_type,			brdrx_type,
                                ol_date_opt,		brdrx_rep_type,
                                res_tag,			pd_date_opt,
                                intm_tag,			iss_cd_tag,
                                line_cd_tag,		loss_cat_tag,
                                from_date,			to_date,
                                branch_opt,			reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id)   
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            v_iss_cd,
                                v_intm_no,                      claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,            reserve_rec.intm_no,
                                reserve_rec.expense_reserve,    reserve_rec.expenses_paid,
                                p_user_id, 					    SYSDATE,
                                p_rep_name,					    p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,		        p_paid_date_option,
                                p_per_buss,	                    p_iss_break,
                                p_subline_break,	            p_per_loss_cat,
                                p_dsp_from_date,		        p_dsp_to_date,
                                p_branch_option,	            p_reg_button,
                                p_net_rcvry_chkbx,	            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);  
                        END IF;
            END LOOP;
        END LOOP;
    END erlei_extract_direct;
    
    PROCEDURE erlei_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd        giis_subline.subline_cd%TYPE;
        v_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd 
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd = p_ri_iss_cd
                              AND DECODE(p_brdrx_date_option,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            --loss_reserve
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
      			                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.peril_cd = b.peril_cd  
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date                                            
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag,'WD',b.close_date,'DN',b.close_date,'CC',b.close_date,
                                                               'DC',b.close_date,'CP',b.close_date, p_dsp_to_date + 1)) > p_dsp_to_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0)
            LOOP
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                 
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN   
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,            loss_reserve,
                                user_id,			last_update,
                                extr_type,			brdrx_type,
                                ol_date_opt,		brdrx_rep_type,
                                res_tag,			pd_date_opt,
                                intm_tag,			iss_cd_tag,
                                line_cd_tag,		loss_cat_tag,
                                from_date,			to_date,
                                branch_opt,			reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id) 
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            claims_rec.iss_cd,
                                claims_rec.ri_cd,               claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,        reserve_rec.loss_reserve,
                                p_user_id,						SYSDATE,
                                p_rep_name,					    p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,		        p_paid_date_option,
                                p_per_buss,	                    p_iss_break,
                                p_subline_break,	            p_per_loss_cat,
                                p_dsp_from_date,		        p_dsp_to_date,
                                p_branch_option,	            p_reg_button,
                                p_net_rcvry_chkbx,	            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);  
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,  
                                loss_reserve,       losses_paid,
                                user_id,			last_update,
                                extr_type,			brdrx_type,
                                ol_date_opt,		brdrx_rep_type,
                                res_tag,			pd_date_opt,
                                intm_tag,			iss_cd_tag,
                                line_cd_tag,		loss_cat_tag,
                                from_date,			to_date,
                                branch_opt,			reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id) 
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            claims_rec.iss_cd,
                                claims_rec.ri_cd,               claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,
                                reserve_rec.loss_reserve,       reserve_rec.losses_paid,
                                p_user_id, 						SYSDATE,
                                p_rep_name,					    p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,		        p_paid_date_option,
                                p_per_buss,	                    p_iss_break,
                                p_subline_break,	            p_per_loss_cat,
                                p_dsp_from_date,		        p_dsp_to_date,
                                p_branch_option,	            p_reg_button,
                                p_net_rcvry_chkbx,	            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);  
                END IF;   
            END LOOP;
            
            --expense_reserve
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, 
      			                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.peril_cd = b.peril_cd
                                   AND a.item_no  = b.item_no
                                   AND a.claim_id = b.claim_id
                                   AND b.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag2,'WD',close_date2,'DN',close_date2,'CC',close_date2,
                                                                'DC',close_date2,'CP',close_date2, p_dsp_to_date + 1)) > p_dsp_to_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0)
            LOOP
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                 
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN   
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,            expense_reserve,
                                user_id,			last_update,
                                extr_type,			brdrx_type,
                                ol_date_opt,		brdrx_rep_type,
                                res_tag,			pd_date_opt,
                                intm_tag,			iss_cd_tag,
                                line_cd_tag,		loss_cat_tag,
                                from_date,			to_date,
                                branch_opt,			reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,            clm_res_hist_id)
                         VALUES(p_session_id,               v_brdrx_record_id,
                                claims_rec.claim_id,        claims_rec.iss_cd,
                                claims_rec.ri_cd,           claims_rec.line_cd,
                                v_subline_cd,               claims_rec.loss_year,
                                claims_rec.assd_no,         claims_rec.claim_no,
                                claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,   reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,    claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,    reserve_rec.expense_reserve,
                                p_user_id, 					SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,  
                                expense_reserve,    expenses_paid, 
                                user_id,			last_update,                                               
                                extr_type,			brdrx_type,
                                ol_date_opt,		brdrx_rep_type,
                                res_tag,			pd_date_opt,
                                intm_tag,			iss_cd_tag,
                                line_cd_tag,		loss_cat_tag,
                                from_date,			to_date,
                                branch_opt,			reg_date_opt,
                                net_rcvry_tag,	    rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id) 
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            claims_rec.iss_cd,
                                claims_rec.ri_cd,               claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,
                                reserve_rec.expense_reserve,    reserve_rec.expenses_paid,
                                p_user_id, 						SYSDATE,
                                p_rep_name,					    p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,		        p_paid_date_option,
                                p_per_buss,	                    p_iss_break,
                                p_subline_break,	            p_per_loss_cat,
                                p_dsp_from_date,		        p_dsp_to_date,
                                p_branch_option,	            p_reg_button,
                                p_net_rcvry_chkbx,	            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);  
                END IF;  
            END LOOP;
        END LOOP;
    END erlei_extract_inward;
    
    PROCEDURE erlei_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id; 
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.losses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.loss_reserve * a.shr_pct/100) loss_reserve,
                                          (brdrx_extr_rec.losses_paid * a.shr_pct/100) losses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd = brdrx_extr_rec.peril_cd
                                      AND a.item_no = brdrx_extr_rec.item_no
                                      AND a.claim_id = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            loss_reserve,       losses_paid,
                            user_id,			last_update)  
                     VALUES(p_session_id,                brdrx_extr_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,        brdrx_extr_rec.claim_id,
                            brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                            brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                            brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                            brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no,   reserve_ds_rec.shr_pct,
                            reserve_ds_rec.loss_reserve, reserve_ds_rec.losses_paid,
                            p_user_id,					 SYSDATE);
                            
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.loss_reserve * a.shr_ri_pct_real/100) loss_reserve,
                                                (reserve_ds_rec.losses_paid * a.shr_ri_pct_real/100) losses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id --Edison 05.18.2012
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                loss_reserve,         losses_paid,
                                user_id,			  last_update) 
                         VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,        brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid,
                                p_user_id, 	                   SYSDATE);
                END LOOP; 
            END LOOP;
        END LOOP;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id  = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.expense_reserve * a.shr_pct/100) expense_reserve,
                                          (brdrx_extr_rec.expenses_paid * a.shr_pct/100) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            expense_reserve,    expenses_paid,
                            user_id,			last_update)    
                     VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                            brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                            brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                            brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                            brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                            reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid,
                            p_user_id, 						SYSDATE);  
                            
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct_real/100) expense_reserve,
                                                (reserve_ds_rec.expenses_paid * a.shr_ri_pct_real/100) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                            AND TO_DATE(NVL(booking_month,TO_CHAR(p_dsp_to_date,'FMMONTH'))||' 01, '||
                                                NVL(TO_CHAR(booking_year,'0999'),TO_CHAR(p_dsp_to_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_to_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real, NVL(b.convert_rate, 1))
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                expense_reserve,      expenses_paid,
                                user_id,			  last_update)   
                         VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid,
                                p_user_id,						  SYSDATE); 
                END LOOP;
            END LOOP;
        END LOOP;
    END erlei_extract_distribution;
    /*erlei = EXTRACT_RESERVE_LOSS_EXP_INTM end*/
    
    /*erle = EXTRACT_RESERVE_LOSS_EXP start*/
    PROCEDURE erle_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source            gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd            giis_issource.iss_cd%TYPE;
        v_subline_cd        giis_subline.subline_cd%TYPE;
        v_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE 1 = 1 
                              AND DECODE(p_brdrx_date_option,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            v_source := 0;
            
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.claim_id = b.claim_id
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id  
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                   AND TRUNC(DECODE(close_flag,'WD',b.close_date,'DN',b.close_date,'CC',b.close_date,
                                                               'DC',b.close_date,'CP',b.close_date, p_dsp_to_date + 1)) > p_dsp_to_date 
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate, 1),
                                       a.grouped_item_no, a.clm_res_hist_id --added by MAC 10/28/2011
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                        SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0)
            LOOP
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := '0';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                              
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id, 
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,
                                loss_reserve,  user_id,
                                last_update,
                                extr_type,	   brdrx_type,
                                ol_date_opt,   brdrx_rep_type,
                                res_tag,	   pd_date_opt,
                                intm_tag,	   iss_cd_tag,
                                line_cd_tag,   loss_cat_tag,
                                from_date,	   to_date,
                                branch_opt,	   reg_date_opt,
                                net_rcvry_tag, rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,clm_res_hist_id)
                         VALUES(p_session_id,               v_brdrx_record_id,
                                claims_rec.claim_id,        v_iss_cd,
                                v_source,                   claims_rec.line_cd,
                                v_subline_cd,               claims_rec.loss_year,
                                claims_rec.assd_no,         claims_rec.claim_no,
                                claims_rec.policy_no,       claims_rec.dsp_loss_date,
                                claims_rec.clm_file_date,   reserve_rec.item_no,
                                reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,    claims_rec.expiry_date,
                                reserve_rec.ann_tsi_amt,  
                                reserve_rec.loss_reserve, 	p_user_id, 
                                SYSDATE,
                                p_rep_name,					p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,		    p_paid_date_option,
                                p_per_buss,	                p_iss_break,
                                p_subline_break,	        p_per_loss_cat,
                                p_dsp_from_date,		    p_dsp_to_date,
                                p_branch_option,	        p_reg_button,
                                p_net_rcvry_chkbx,	        p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id); 
                ELSE      
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,       
                                loss_reserve,   losses_paid,
                                user_id,		last_update,
                                extr_type,		brdrx_type,
                                ol_date_opt,	brdrx_rep_type,
                                res_tag,		pd_date_opt,
                                intm_tag,		iss_cd_tag,
                                line_cd_tag,	loss_cat_tag,
                                from_date,		to_date,
                                branch_opt,		reg_date_opt,
                                net_rcvry_tag,	rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,clm_res_hist_id) 
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            v_iss_cd,
                                v_source,                       claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,  
                                reserve_rec.loss_reserve,       reserve_rec.losses_paid,
                                p_user_id, 						SYSDATE,
                                p_rep_name,					    p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,                p_paid_date_option,
                                p_per_buss,                        p_iss_break,
                                p_subline_break,                p_per_loss_cat,
                                p_dsp_from_date,                p_dsp_to_date,
                                p_branch_option,                p_reg_button,
                                p_net_rcvry_chkbx,                p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);  
                END IF;
            END LOOP;
            
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.claim_id = b.claim_id
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id  
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date                        
                                   AND TRUNC(DECODE(close_flag2,'WD',close_date2,'DN',close_date2,'CC',close_date2,
                                                                'DC',close_date2,'CP',close_date2, p_dsp_to_date + 1)) > p_dsp_to_date 
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id , a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate,1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                        SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0)
            LOOP
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := '0';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                              
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id, 
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,       
                                expense_reserve,     user_id,
                                last_update,                                                    
                                extr_type,            brdrx_type,
                                ol_date_opt,        brdrx_rep_type,
                                res_tag,            pd_date_opt,
                                intm_tag,            iss_cd_tag,
                                line_cd_tag,        loss_cat_tag,
                                from_date,            to_date,
                                branch_opt,            reg_date_opt,
                                net_rcvry_tag,        rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id)     
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            v_iss_cd,
                                v_source,                       claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date,
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date,
                                reserve_rec.ann_tsi_amt,  
                                reserve_rec.expense_reserve,     p_user_id, 
                                sysdate,
                                p_rep_name,                        p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,                p_paid_date_option,
                                p_per_buss,                        p_iss_break,
                                p_subline_break,                p_per_loss_cat,
                                p_dsp_from_date,                p_dsp_to_date,
                                p_branch_option,                p_reg_button,
                                p_net_rcvry_chkbx,                p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);  
                ELSE      
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,         brdrx_record_id,
                                claim_id,           iss_cd,
                                buss_source,        line_cd,
                                subline_cd,         loss_year,
                                assd_no,            claim_no,
                                policy_no,          loss_date,
                                clm_file_date,      item_no,
                                peril_cd,           loss_cat_cd,
                                incept_date,        expiry_date,
                                tsi_amt,           
                                expense_reserve,    expenses_paid,
                                user_id,            last_update,
                                extr_type,            brdrx_type,
                                ol_date_opt,        brdrx_rep_type,
                                res_tag,            pd_date_opt,
                                intm_tag,            iss_cd_tag,
                                line_cd_tag,        loss_cat_tag,
                                from_date,            to_date,
                                branch_opt,            reg_date_opt,
                                net_rcvry_tag,        rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id)     
                         VALUES(p_session_id,                   v_brdrx_record_id,
                                claims_rec.claim_id,            v_iss_cd,
                                v_source,                       claims_rec.line_cd,
                                v_subline_cd,                   claims_rec.loss_year,
                                claims_rec.assd_no,             claims_rec.claim_no,
                                claims_rec.policy_no,           claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,       reserve_rec.item_no,
                                reserve_rec.peril_cd,           reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,        claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,     
                                reserve_rec.expense_reserve,    reserve_rec.expenses_paid,
                                p_user_id,                         SYSDATE,
                                p_rep_name,                        p_brdrx_type,
                                p_brdrx_date_option,            p_brdrx_option,
                                p_dsp_gross_tag,                p_paid_date_option,
                                p_per_buss,                        p_iss_break,
                                p_subline_break,                p_per_loss_cat,
                                p_dsp_from_date,                p_dsp_to_date,
                                p_branch_option,                p_reg_button,
                                p_net_rcvry_chkbx,                p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,    reserve_rec.clm_res_hist_id);
            END IF;
            END LOOP;
        END LOOP;
    END erle_extract_all;
    
    PROCEDURE erle_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id; 
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.losses_paid, a.clm_res_hist_id
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id  = p_session_id
                                  AND expense_reserve IS NULL
                                  AND expenses_paid IS NULL)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                          SUM(DECODE(b.dist_sw,'Y',NVL(b.loss_reserve,0)*a.shr_pct/100,0)) loss_reserve,
                                          SUM(DECODE(b.dist_sw,NULL,NVL(b.losses_paid,0)*a.shr_pct/100,0)) losses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd = brdrx_extr_rec.peril_cd
                                      AND a.item_no = brdrx_extr_rec.item_no
                                      AND a.claim_id = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND a.clm_res_hist_id = brdrx_extr_rec.clm_res_hist_id
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN 
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                loss_reserve,       user_id,            last_update)
                             VALUES(p_session_id,               brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                                reserve_ds_rec.loss_reserve,    p_user_id,                               SYSDATE);
                ELSE
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,         
                                loss_reserve,       losses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,        brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_ds_rec.shr_pct,         
                                reserve_ds_rec.loss_reserve, reserve_ds_rec.losses_paid, 
                                p_user_id,                   SYSDATE);
                END IF; 
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                SUM(DECODE(b.dist_sw,'Y',NVL(b.loss_reserve,0)*a.shr_ri_pct/100,0)) loss_reserve,
                                                SUM(DECODE(b.dist_sw,NULL,NVL(b.losses_paid,0)*a.shr_ri_pct/100,0)) losses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date  
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    
                    IF p_dsp_gross_tag = 1 THEN
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    loss_reserve,         user_id, 
                                    last_update)
                             VALUES(p_session_id,                   v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,         brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,      reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,    reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.loss_reserve,  p_user_id,
                                    SYSDATE);
                    ELSE 
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    loss_reserve,         losses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,        brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid, 
                                    p_user_id,                     SYSDATE);
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id  = p_session_id
                                  AND loss_reserve IS NULL
                                  AND losses_paid IS NULL)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                          SUM(DECODE(b.dist_sw,'Y',NVL(b.expense_reserve,0)*a.shr_pct/100,0)) expense_reserve,
                                          SUM(DECODE(b.dist_sw,NULL,NVL(b.expenses_paid,0)*a.shr_pct/100,0)) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date           
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN 
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                expense_reserve,    user_id, 
                                last_update)
                         VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                                reserve_ds_rec.expense_reserve, p_user_id, 
                                SYSDATE);
                ELSE
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,         
                                expense_reserve,    expenses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,         
                                reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid, 
                                p_user_id,                      SYSDATE);
                END IF; 
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                SUM(DECODE(b.dist_sw,'Y',NVL(b.expense_reserve,0)*a.shr_ri_pct/100,0)) expense_reserve,
                                                SUM(DECODE(b.dist_sw,NULL,NVL(b.expenses_paid,0)*a.shr_ri_pct/100,0)) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no      = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no     = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id        = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_to_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
            
                    IF p_dsp_gross_tag = 1 THEN
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                expense_reserve,      user_id, 
                                last_update)
                         VALUES(p_session_id,                       v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,             brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,              brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,             brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,           brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,            brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,          reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,        reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.expense_reserve,   p_user_id, 
                                SYSDATE);
                    ELSE 
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    expense_reserve,      expenses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid, 
                                    p_user_id,                        SYSDATE);
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;
    END erle_extract_distribution;
    /*erle = EXTRACT_RESERVE_LOSS_EXP end*/   
    
    /*ertui = EXTRACT_RESERVE_TAKE_UP_INTM start*/
    PROCEDURE ertui_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_posted            IN VARCHAR2,
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_intm_no                   giis_intermediary.intm_no%TYPE;  
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE 1 = 1  
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                         c.intm_no, c.shr_intm_pct, (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt, 
                                         DECODE(p_brdrx_option,1,d.os_loss*c.shr_intm_pct/100,
                                                               2,d.os_expense*c.shr_intm_pct/100,NULL) os_claims,
                                         DECODE(p_brdrx_option,1,d.os_loss*c.shr_intm_pct/100,3,d.os_loss*c.shr_intm_pct/100,NULL) os_loss,
                                         DECODE(p_brdrx_option,1,d.os_expense*c.shr_intm_pct/100,3,d.os_expense*c.shr_intm_pct/100,NULL) os_exp,                            
                                         a.grouped_item_no, a.clm_res_hist_id
                                    FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_take_up_hist d, giac_acctrans e, gicl_claims f
                                   WHERE a.claim_id            = b.claim_id 
                                     AND a.item_no             = b.item_no
                                     AND a.peril_cd            = b.peril_cd
                                     AND b.claim_id            = c.claim_id 
                                     AND b.item_no             = c.item_no 
                                     AND b.peril_cd            = c.peril_cd             
                                     AND a.claim_id            = claims_rec.claim_id 
                                     AND a.claim_id            = d.claim_id
                                     AND a.clm_res_hist_id     = d.clm_res_hist_id
                                     AND d.acct_tran_id        = e.tran_id  
                                     AND a.claim_id            = f.claim_id
                                     AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                                     AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                         NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                     AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                                     AND e.tran_flag = DECODE(p_posted,'Y','P','C') 
                                     AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)                                      
                                     AND DECODE(3,1,d.os_loss,2,d.os_expense,3, NVL(d.os_loss, 0) + NVL(d.os_expense, 0), null) > 0)
            LOOP
                v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
                
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := '0';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                              
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_brdrx_option = 1 THEN -- radio loss
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       intm_no, 
                                loss_reserve,  user_id,
                                last_update,
                                extr_type,             brdrx_type,
                                ol_date_opt,         brdrx_rep_type,
                                res_tag,             pd_date_opt,
                                intm_tag,             iss_cd_tag,
                                line_cd_tag,         loss_cat_tag,
                                from_date,             to_date,
                                branch_opt,             reg_date_opt,
                                net_rcvry_tag,         rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,     clm_res_hist_id)   
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_intm_no,                claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,      reserve_rec.intm_no,
                                reserve_rec.os_claims,       p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                ELSIF p_brdrx_option = 2 THEN -- radio expense
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        intm_no, 
                                expense_reserve,user_id,
                                last_update,                                                
                                extr_type,             brdrx_type,
                                ol_date_opt,         brdrx_rep_type,
                                res_tag,             pd_date_opt,
                                intm_tag,             iss_cd_tag,
                                line_cd_tag,         loss_cat_tag,
                                from_date,             to_date,
                                branch_opt,             reg_date_opt,
                                net_rcvry_tag,         rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,     clm_res_hist_id)   
                         VALUES(p_session_id,            v_brdrx_record_id,
                                claims_rec.claim_id,     v_iss_cd,
                                v_intm_no,               claims_rec.line_cd,
                                v_subline_cd,            claims_rec.loss_year,
                                claims_rec.assd_no,      claims_rec.claim_no,
                                claims_rec.policy_no,    claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,reserve_rec.item_no,
                                reserve_rec.peril_cd,    reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date, claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,     reserve_rec.intm_no,
                                reserve_rec.os_claims,      p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                ELSIF p_brdrx_option = 3 THEN -- radio loss+expense
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       intm_no, 
                                loss_reserve,  expense_reserve, 
                                user_id,       last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)   
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_intm_no,                claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.tsi_amt,      reserve_rec.intm_no,
                                reserve_rec.os_loss,      reserve_rec.os_exp,      
                                p_user_id,                SYSDATE, 
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                END IF; -- p_brdrx_option
            END LOOP;
        END LOOP;
    END ertui_extract_all;
    
    PROCEDURE ertui_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER,
        p_posted            IN VARCHAR2
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
    
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.expense_reserve
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.loss_reserve * a.shr_pct/100) loss_reserve,
                                          (brdrx_extr_rec.expense_reserve * a.shr_pct/100) expense_reserve
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_take_up_hist d, giac_acctrans e, gicl_claims c   
                                    WHERE a.claim_id            = b.claim_id
                                      AND a.clm_res_hist_id     = b.clm_res_hist_id
                                      AND a.claim_id            = d.claim_id
                                      AND a.clm_res_hist_id     = d.clm_res_hist_id
                                      AND a.peril_cd            = brdrx_extr_rec.peril_cd
                                      AND a.item_no             = brdrx_extr_rec.item_no
                                      AND a.claim_id            = brdrx_extr_rec.claim_id
                                      AND d.acct_tran_id        = e.tran_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND TO_DATE(NVL(b.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                          NVL(TO_CHAR(b.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                      AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                                      AND e.tran_flag = DECODE(p_posted,'Y','P','C'))
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            loss_reserve,       
                            expense_reserve, 
                            user_id,            last_update)
                     VALUES(p_session_id,              brdrx_extr_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,      brdrx_extr_rec.claim_id,
                            brdrx_extr_rec.iss_cd,     brdrx_extr_rec.buss_source,
                            brdrx_extr_rec.line_cd,    brdrx_extr_rec.subline_cd,
                            brdrx_extr_rec.loss_year,  brdrx_extr_rec.item_no,
                            brdrx_extr_rec.peril_cd,   brdrx_extr_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no, reserve_ds_rec.shr_pct,
                            NVL(reserve_ds_rec.loss_reserve,0),
                            NVL(reserve_ds_rec.expense_reserve,0), 
                            p_user_id,                 SYSDATE);
                            
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.loss_reserve * a.shr_ri_pct_real/100) loss_reserve,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct_real/100) expense_reserve
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_take_up_hist d, giac_acctrans e, gicl_claims c     
                                          WHERE a.claim_id            = b.claim_id
                                            AND a.clm_res_hist_id     = b.clm_res_hist_id
                                            AND a.claim_id            = d.claim_id
                                            AND a.clm_res_hist_id     = d.clm_res_hist_id  
                                            AND a.grp_seq_no          = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no         = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id     = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id            = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND d.acct_tran_id = e.tran_id
                                            AND TO_DATE(NVL(b.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                                NVL(TO_CHAR(b.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                            AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                                            AND e.tran_flag = DECODE(p_posted,'Y','P','C'))
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                loss_reserve,         
                                expense_reserve, 
                                user_id,              last_update)
                         VALUES(p_session_id,                v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,      brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd, reserve_rids_rec.shr_ri_pct,
                                NVL(reserve_rids_rec.loss_reserve,0),
                                NVL(reserve_rids_rec.expense_reserve,0), 
                                p_user_id,                   SYSDATE);
                END LOOP;
            END LOOP;
        END LOOP;    
    END ertui_extract_distribution;               
    /*ertui = EXTRACT_RESERVE_TAKE_UP_INTM end*/
    
    /*ertu = EXTRACT_RESERVE_TAKE_UP start*/
    PROCEDURE ertu_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_posted            IN VARCHAR2,
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE 1 = 1  
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))         
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            v_source := 0; 
            
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       d.os_loss os_loss, d.os_expense os_exp,
                                       a.grouped_item_no, a.clm_res_hist_id --added by MAC 10/28/2011
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_take_up_hist d, giac_acctrans e, gicl_claims c
                                 WHERE a.claim_id            = b.claim_id 
                                   AND a.item_no             = b.item_no
                                   AND a.peril_cd            = b.peril_cd
                                   AND a.claim_id            = claims_rec.claim_id
                                   AND a.claim_id            = d.claim_id
                                   AND a.clm_res_hist_id     = d.clm_res_hist_id
                                   AND d.acct_tran_id        = e.tran_id  
                                   AND a.claim_id = c.claim_id --Edison 05.18.2012
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                                   AND e.tran_flag = DECODE(p_posted,'Y','P','C') 
                                   AND DECODE(p_brdrx_option,1,d.os_loss,2,d.os_expense,(nvl(d.os_loss,0)+nvl(d.os_expense,0))) > 0)
            LOOP
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := '0';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                              
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_brdrx_option = 1 THEN -- radio loss
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       
                                loss_reserve,  user_id,
                                last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_source,                 claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,  
                                reserve_rec.os_loss,       p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                ELSIF p_brdrx_option = 2 THEN -- radio loss
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,       
                                expense_reserve,user_id,
                                last_update,
                                extr_type,            brdrx_type,
                                ol_date_opt,        brdrx_rep_type,
                                res_tag,            pd_date_opt,
                                intm_tag,            iss_cd_tag,
                                line_cd_tag,        loss_cat_tag,
                                from_date,            to_date,
                                branch_opt,            reg_date_opt,
                                net_rcvry_tag,        rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no,    clm_res_hist_id)   
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_source,                 claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,  
                                reserve_rec.os_exp,       p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                ELSIF p_brdrx_option = 3 THEN -- loss+expense
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,     brdrx_record_id,
                                claim_id,       iss_cd,
                                buss_source,    line_cd,
                                subline_cd,     loss_year,
                                assd_no,        claim_no,
                                policy_no,      loss_date,
                                clm_file_date,  item_no,
                                peril_cd,       loss_cat_cd,
                                incept_date,    expiry_date,
                                tsi_amt,        loss_reserve,
                                expense_reserve,user_id,
                                last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)   
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_source,                 claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                reserve_rec.ann_tsi_amt,  reserve_rec.os_loss,
                                reserve_rec.os_exp,       p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                END IF; -- p_brdrx_option
            END LOOP;
        END LOOP;                            
    END ertu_extract_all;
    
    PROCEDURE ertu_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_posted            IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
    
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.expense_reserve
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          ((NVL(d.os_loss,0)*a.shr_pct/100)) loss_reserve,
                                          ((NVL(d.os_expense,0)*a.shr_pct/100)) expense_reserve
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_take_up_hist d, giac_acctrans e, gicl_claims c    
                                    WHERE a.claim_id            = b.claim_id
                                      AND a.clm_res_hist_id     = b.clm_res_hist_id
                                      AND a.claim_id            = d.claim_id
                                      AND a.clm_res_hist_id     = d.clm_res_hist_id
                                      AND a.peril_cd            = brdrx_extr_rec.peril_cd
                                      AND a.item_no             = brdrx_extr_rec.item_no
                                      AND a.claim_id            = brdrx_extr_rec.claim_id
                                      AND d.acct_tran_id        = e.tran_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND TO_DATE(NVL(b.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                          NVL(TO_CHAR(b.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                      AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                                      AND e.tran_flag = DECODE(p_posted,'Y','P','C'))
            LOOP
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            loss_reserve,       expense_reserve, 
                            user_id,            last_update)
                     VALUES(p_session_id,              brdrx_extr_rec.brdrx_record_id,
                            v_brdrx_ds_record_id,      brdrx_extr_rec.claim_id,
                            brdrx_extr_rec.iss_cd,     brdrx_extr_rec.buss_source,
                            brdrx_extr_rec.line_cd,    brdrx_extr_rec.subline_cd,
                            brdrx_extr_rec.loss_year,  brdrx_extr_rec.item_no,
                            brdrx_extr_rec.peril_cd,   brdrx_extr_rec.loss_cat_cd, 
                            reserve_ds_rec.grp_seq_no, reserve_ds_rec.shr_pct,
                            NVL(reserve_ds_rec.loss_reserve,0),
                            NVL(reserve_ds_rec.expense_reserve,0), 
                            p_user_id,                 SYSDATE);
                            
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct,
                                                ((NVL(d.os_loss,0)*a.shr_ri_pct/100)) loss_reserve,
                                                ((NVL(d.os_expense,0)*a.shr_ri_pct/100)) expense_reserve
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_take_up_hist d, giac_acctrans e, gicl_claims c  
                                          WHERE a.claim_id            = b.claim_id
                                            AND a.clm_res_hist_id     = b.clm_res_hist_id
                                            AND a.claim_id            = d.claim_id
                                            AND a.clm_res_hist_id     = d.clm_res_hist_id  
                                            AND a.grp_seq_no          = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no         = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id     = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id            = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND d.acct_tran_id = e.tran_id
                                            AND TO_DATE(NVL(b.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                                NVL(TO_CHAR(b.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                            AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                                            AND e.tran_flag = DECODE(p_posted,'Y','P','C'))
                LOOP
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                loss_reserve,         
                                expense_reserve, 
                                user_id,              last_update)
                         VALUES(p_session_id,                v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,      brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd, reserve_rids_rec.shr_ri_pct,
                                NVL(reserve_rids_rec.loss_reserve,0),
                                NVL(reserve_rids_rec.expense_reserve,0), 
                                p_user_id,                   SYSDATE);
                END LOOP;
            END LOOP;
        END LOOP;
    END ertu_extract_distribution;
    /*ertu = EXTRACT_RESERVE_TAKE_UP end*/
    
    /*erlia = EXTRACT_RESERVE_LOSS_INTM_ALL start*/
    PROCEDURE erlia_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE;
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, c.intm_no, c.shr_intm_pct,
                                   (b.ann_tsi_amt * c.shr_intm_pct  / 100  * NVL(a.convert_rate,1) ) tsi_amt,
                                   (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1) * NVL(a.loss_reserve,0) ,0)) * c.shr_intm_pct  / 100 ) loss_reserve,
                                   (SUM(DECODE(a.dist_sw, NULL , NVL(a.convert_rate,1) * NVL(a.losses_paid,0) ,0)) * c.shr_intm_pct  / 100 ) losses_paid,
                                   d.line_cd, d.subline_cd, d.iss_cd, 
                                     TO_NUMBER(TO_CHAR(d.loss_date,'YYYY')) loss_year,
                                     d.assd_no, (d.line_cd||'-'||d.subline_cd||'-'||d.iss_cd||'-'||LTRIM(TO_CHAR(d.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(d.clm_seq_no,'0999999'))) claim_no,
                                     (d.line_cd||'-'||d.subline_cd||'-'||d.pol_iss_cd||'-'||LTRIM(TO_CHAR(d.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(d.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(d.renew_no,'09'))) policy_no,
                                     d.dsp_loss_date, d.loss_date, d.clm_file_date, d.pol_eff_date, d.expiry_date, a.grouped_item_no, a.clm_res_hist_id
                              FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                             WHERE a.claim_id = b.claim_id  
                               AND a.item_no = b.item_no  
                               AND a.peril_cd = b.peril_cd  
                               AND b.claim_id = c.claim_id  
                               AND b.item_no = c.item_no  
                               AND b.peril_cd = c.peril_cd  
                               AND c.claim_id = d.claim_id
                                AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH')) || ' 01, '  || NVL(TO_CHAR(a.booking_year,'0999'),
                                               TO_CHAR(p_dsp_as_of_date,'YYYY')) ,
                                           'FMMONTH DD, YYYY') <= p_dsp_as_of_date  
                                AND TRUNC(NVL(a.date_paid, p_dsp_as_of_date)) <= p_dsp_as_of_date  
                                AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),TO_DATE(p_dsp_as_of_date) + 1 ) > p_dsp_as_of_date  
                                AND TRUNC(NVL(b.close_date, TO_DATE(p_dsp_as_of_date) + 1 )) > p_dsp_as_of_date  
                                AND b.peril_cd = NVL(p_dsp_peril_cd, b.peril_cd)  
                                AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)  
                                AND d.pol_iss_cd  <> p_ri_iss_cd
                                AND d.clm_stat_cd NOT IN ('CC','CD','DN','WD')
                               AND TRUNC(d.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,d.dsp_loss_date),d.dsp_loss_date)) 
                                AND TRUNC(d.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,d.clm_file_date),d.clm_file_date)) 
                                AND d.line_cd = NVL(p_dsp_line_cd,d.line_cd)
                                AND d.subline_cd = NVL(p_dsp_subline_cd,d.subline_cd)
                                AND DECODE(p_branch_option,1,d.iss_cd,2,d.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,d.iss_cd,2,d.pol_iss_cd))
                             GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, c.intm_no, c.shr_intm_pct,
                                     NVL(a.convert_rate,1),d.line_cd, d.subline_cd, d.iss_cd, d.loss_date, d.assd_no, d.clm_yy, d.clm_seq_no, d.pol_iss_cd,
                                     d.issue_yy, d.pol_seq_no, d.renew_no, d.dsp_loss_date, d.loss_date, d.clm_file_date, d.pol_eff_date, d.expiry_date,
                                     a.grouped_item_no, a.clm_res_hist_id
                            HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate, 1) * NVL(a.loss_reserve,0) ,0) * c.shr_intm_pct  / 100 ) - 
                                   SUM(DECODE(a.dist_sw, NULL ,NVL(a.convert_rate,1) * NVL(a.losses_paid,0) ,0) * c.shr_intm_pct  / 100 ) ) != 0
                             ORDER BY a.claim_id)
        LOOP
            v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
            
            IF p_iss_break = 1 THEN
                v_iss_cd := reserve_rec.iss_cd;
            ELSIF p_iss_break = 0 THEN
                v_iss_cd := 'DI';
            END IF;
        
            IF p_subline_break = 1 THEN
                v_subline_cd := reserve_rec.subline_cd;
            ELSIF p_subline_break = 0 THEN
                v_subline_cd := '0';
            END IF;
                          
            v_brdrx_record_id := v_brdrx_record_id + 1;
            
            IF p_dsp_gross_tag = 1 THEN 
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,    brdrx_record_id,
                            claim_id,      iss_cd,
                            buss_source,   line_cd,
                            subline_cd,    loss_year,
                            assd_no,       claim_no,
                            policy_no,     loss_date,
                            clm_file_date, item_no,
                            peril_cd,      loss_cat_cd,
                            incept_date,   expiry_date,
                            tsi_amt,       intm_no,
                            loss_reserve,  user_id,
                            last_update,                        
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id)
                     VALUES(p_session_id,               v_brdrx_record_id,
                            reserve_rec.claim_id,       v_iss_cd,
                            v_intm_no,                  reserve_rec.line_cd,
                            v_subline_cd,               reserve_rec.loss_year,
                            reserve_rec.assd_no,        reserve_rec.claim_no,
                            reserve_rec.policy_no,      reserve_rec.dsp_loss_date, 
                            reserve_rec.clm_file_date,  reserve_rec.item_no,
                            reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                            reserve_rec.pol_eff_date,   reserve_rec.expiry_date,
                            reserve_rec.tsi_amt,        reserve_rec.intm_no,
                            reserve_rec.loss_reserve,   p_user_id, 
                            SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
            ELSE
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,    brdrx_record_id,
                            claim_id,      iss_cd,
                            buss_source,   line_cd,
                            subline_cd,    loss_year,
                            assd_no,       claim_no,
                            policy_no,     loss_date,
                            clm_file_date, item_no,
                            peril_cd,      loss_cat_cd,
                            incept_date,   expiry_date,
                            tsi_amt,       intm_no,
                            loss_reserve,  losses_paid,
                            user_id,       last_update,
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id)
                     VALUES(p_session_id,               v_brdrx_record_id,
                            reserve_rec.claim_id,       v_iss_cd,
                            v_intm_no,                  reserve_rec.line_cd,
                            v_subline_cd,               reserve_rec.loss_year,
                            reserve_rec.assd_no,        reserve_rec.claim_no,
                            reserve_rec.policy_no,      reserve_rec.dsp_loss_date, 
                            reserve_rec.clm_file_date,  reserve_rec.item_no,
                            reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                            reserve_rec.pol_eff_date,   reserve_rec.expiry_date,
                            reserve_rec.tsi_amt,        reserve_rec.intm_no,
                            reserve_rec.loss_reserve,   reserve_rec.losses_paid,
                            p_user_id,                     SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
            END IF;
        END LOOP;
        
        p_brdrx_record_id := v_brdrx_record_id;
    END erlia_extract_direct;
    
    PROCEDURE erlia_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd  = p_ri_iss_cd
                              AND TRUNC(a.dsp_loss_date) <= 
                                  (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                              AND TRUNC(a.clm_file_date) <= 
                                  (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd)) 
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                       NVL(a.convert_rate,1), a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0)
            LOOP
                BEGIN
                    IF p_subline_break = 1 THEN
                        v_subline_cd := claims_rec.subline_cd;
                    ELSIF p_subline_break = 0 THEN
                        v_subline_cd := '0';
                    END IF; 
              
                    v_brdrx_record_id := v_brdrx_record_id + 1;
          
                    IF p_dsp_gross_tag = 1 THEN 
                          INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       loss_reserve,
                                    user_id,       last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id) 
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, reserve_rec.item_no,
                                    reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    reserve_rec.ann_tsi_amt,  reserve_rec.loss_reserve,
                                    p_user_id,                   SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);   
                    ELSE
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt, 
                                    loss_reserve,   losses_paid,
                                    user_id,        last_update,
                                    extr_type,        brdrx_type,
                                    ol_date_opt,    brdrx_rep_type,
                                    res_tag,        pd_date_opt,
                                    intm_tag,        iss_cd_tag,
                                    line_cd_tag,    loss_cat_tag,
                                    from_date,        to_date,
                                    branch_opt,        reg_date_opt,
                                    net_rcvry_tag,    rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no,clm_res_hist_id) 
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, reserve_rec.item_no,
                                    reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date,
                                    reserve_rec.ann_tsi_amt,
                                    reserve_rec.loss_reserve, reserve_rec.losses_paid,
                                    p_user_id,                   SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id); 
                    END IF;          
                END;
            END LOOP;
        END LOOP;
    END erlia_extract_inward;
    
    PROCEDURE erlia_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS 
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.losses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.loss_reserve * a.shr_pct/100) loss_reserve,
                                          (brdrx_extr_rec.losses_paid * a.shr_pct/100) losses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd = brdrx_extr_rec.peril_cd
                                      AND a.item_no  = brdrx_extr_rec.item_no
                                      AND a.claim_id = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                BEGIN
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                loss_reserve,       losses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,        brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_ds_rec.shr_pct,
                                reserve_ds_rec.loss_reserve, reserve_ds_rec.losses_paid, 
                                p_user_id,                   SYSDATE);
                END;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.loss_reserve * a.shr_ri_pct_real/100) loss_reserve,
                                                (reserve_ds_rec.losses_paid * a.shr_ri_pct_real/100) losses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.claim_id = c.claim_id --Edison 05.18.2012
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
                                            AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id             = reserve_ds_rec.claim_id
                                            AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    BEGIN
                        v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    loss_reserve,         losses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,        brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid, 
                                    p_user_id,                     SYSDATE);
                    END;   
                END LOOP;
            END LOOP;
        END LOOP;
    END erlia_extract_distribution; 
    /*erlia = EXTRACT_RESERVE_LOSS_INTM_ALL end*/
    
    /*erla = EXTRACT_RESERVE_LOSS_ALL start*/
    PROCEDURE erla_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        v_source := 0;
        
        IF p_dsp_gross_tag = 1 THEN
            INSERT INTO gicl_res_brdrx_extr (session_id, brdrx_record_id, claim_id, iss_cd, buss_source, line_cd,
                                             subline_cd, loss_year, assd_no, claim_no, policy_no, loss_date, 
                                             clm_file_date, item_no, peril_cd, loss_cat_cd, incept_date, expiry_date,
                                             tsi_amt, loss_reserve,
                                             user_id,             last_update,
                                             extr_type,            brdrx_type,
                                             ol_date_opt,        brdrx_rep_type,
                                             res_tag,            pd_date_opt,
                                             intm_tag,            iss_cd_tag,
                                             line_cd_tag,        loss_cat_tag,
                                             from_date,            to_date,
                                             branch_opt,        reg_date_opt,
                                             net_rcvry_tag,        rcvry_from_date,
                                             rcvry_to_date,
                                             grouped_item_no,   clm_res_hist_id)
                                      SELECT p_session_id, ROWNUM brdrx_record_id, a.claim_id, DECODE(p_iss_break,1,a.iss_cd,0,'0') iss_cd, v_source, a.line_cd,  
                                             DECODE(p_subline_break,1,a.subline_cd,0,'0') subline_cd, TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year, a.assd_no, 
                                             (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                             (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                              a.dsp_loss_date, a.clm_file_date, c.item_no, c.peril_cd, c.loss_cat_cd, a.pol_eff_date, a.expiry_date,
                                              c.ann_tsi_amt, c.loss_reserve,
                                             p_user_id,                SYSDATE,
                                             p_rep_name,            p_brdrx_type,
                                             p_brdrx_date_option,   p_brdrx_option,
                                             p_dsp_gross_tag,        p_paid_date_option,
                                             p_per_buss,            p_iss_break,
                                             p_subline_break,        p_per_loss_cat,
                                             p_dsp_from_date,        NVL(p_dsp_to_date,p_dsp_as_of_date),
                                             p_branch_option,        p_reg_button,
                                             p_net_rcvry_chkbx,        p_dsp_rcvry_from_date,
                                             p_dsp_rcvry_to_date,
                                             c.grouped_item_no,     c.clm_res_hist_id
                                        FROM gicl_claims a, (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                                                    (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                                                    SUM(DECODE(a.dist_sw,'Y',nvl(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                                                    SUM(DECODE(a.dist_sw,NULL,nvl(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                                                    a.grouped_item_no, a.clm_res_hist_id
                                                               FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                                              WHERE a.claim_id = b.claim_id 
                                                                AND a.item_no  = b.item_no
                                                                AND a.peril_cd = b.peril_cd
                                                                AND a.claim_id = c.claim_id
                                                                AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                                                AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                                                AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                                                AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                                                AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                                                AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                                              GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                                                    a.grouped_item_no, a.clm_res_hist_id
                                                             HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0) c 
                                       WHERE 1 = 1
                                         AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                                         AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                                         AND a.line_cd = NVL(p_dsp_line_cd,a.line_cd)
                                         AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                                         AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))  
                                         AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                         AND a.claim_id = c.claim_id;
        ELSE
            INSERT INTO gicl_res_brdrx_extr (session_id, brdrx_record_id, claim_id, iss_cd, buss_source, line_cd,
                                             subline_cd, loss_year, assd_no, claim_no, policy_no, loss_date, 
                                             clm_file_date, item_no, peril_cd, loss_cat_cd, incept_date, expiry_date,
                                             tsi_amt, loss_reserve, losses_paid, user_id, last_update,
                                             extr_type,            brdrx_type,
                                             ol_date_opt,        brdrx_rep_type,
                                             res_tag,            pd_date_opt,
                                             intm_tag,            iss_cd_tag,
                                             line_cd_tag,        loss_cat_tag,
                                             from_date,            to_date,
                                             branch_opt,        reg_date_opt,
                                             net_rcvry_tag,        rcvry_from_date,
                                             rcvry_to_date,
                                             grouped_item_no,   clm_res_hist_id) 
                                      SELECT p_session_id, ROWNUM brdrx_record_id, a.claim_id, DECODE(p_iss_break,1,a.iss_cd,0,'0') iss_cd,v_source, a.line_cd,  
                                             DECODE(p_subline_break,1,a.subline_cd,0,'0') subline_cd, TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year, 
                                             a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                            (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                             a.dsp_loss_date, a.clm_file_date, c.item_no, c.peril_cd, c.loss_cat_cd, a.pol_eff_date, a.expiry_date,
                                             c.ann_tsi_amt, c.loss_reserve, c.losses_paid, p_user_id, SYSDATE, 
                                             p_rep_name,            p_brdrx_type,
                                             p_brdrx_date_option,   p_brdrx_option,
                                             p_dsp_gross_tag,        p_paid_date_option,
                                             p_per_buss,            p_iss_break,
                                             p_subline_break,        p_per_loss_cat,
                                             p_dsp_from_date,        NVL(p_dsp_to_date,p_dsp_as_of_date),
                                             p_branch_option,        p_reg_button,
                                             p_net_rcvry_chkbx,        p_dsp_rcvry_from_date,
                                             p_dsp_rcvry_to_date,
                                             c.grouped_item_no,     c.clm_res_hist_id
                                        FROM gicl_claims a, (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                                                                    b.ann_tsi_amt ann_tsi_amt, 
                                                                    SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                                                    SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                                                    a.grouped_item_no, a.clm_res_hist_id 
                                                               FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c 
                                                              WHERE a.claim_id = b.claim_id 
                                                                AND a.item_no  = b.item_no
                                                                AND a.peril_cd = b.peril_cd
                                                                AND a.claim_id = c.claim_id
                                                                AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                                                AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                                                AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                                                AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                                                AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                                                AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                                              GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                                                    a.grouped_item_no, a.clm_res_hist_id                                                                       
                                                             HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                                                     SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0) c  
                                       WHERE 1 = 1 
                                         AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                                         AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                                         AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                                         AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                                         AND a.claim_id = c.claim_id
                                         AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                         AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd));
        END IF;
        
        SELECT MAX(brdrx_record_id) 
          INTO p_brdrx_record_id  
          FROM gicl_res_brdrx_extr;
    END erla_extract_all;
    
    PROCEDURE erla_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
    
        FOR reserve_ds_rec IN (SELECT c.brdrx_record_id, c.claim_id, c.iss_cd, c.buss_source, c.line_cd, c.subline_cd, c.loss_year,
                                      c.item_no, c.peril_cd, c.loss_cat_cd, a.grp_seq_no, a.shr_pct,
                                      SUM(DECODE(b.dist_sw,'Y',NVL(b.convert_rate,1)*(NVL(b.loss_reserve,0)*a.shr_pct/100),0)) loss_reserve,
                                      SUM(DECODE(b.dist_sw,NULL,NVL(b.convert_rate,1)*(NVL(b.losses_paid,0)*a.shr_pct/100),0)) losses_paid,
                                      a.clm_res_hist_id, a.clm_dist_no 
                                 FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_res_brdrx_extr c
                                WHERE session_id = p_session_id
                                  AND a.peril_cd = c.peril_cd
                                  AND a.item_no  = c.item_no
                                  AND a.claim_id = c.claim_id
                                  AND a.claim_id = b.claim_id
                                  AND a.item_no  = b.item_no 
                                  AND a.peril_cd = b.peril_cd
                                  AND NVL(a.negate_tag,'N') <> 'Y'
                                  AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                  AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                                      c.brdrx_record_id, c.claim_id, c.iss_cd, c.buss_source, c.line_cd, c.subline_cd, c.loss_year,
                                      c.item_no, c.peril_cd, c.loss_cat_cd)
        LOOP
            BEGIN
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                IF p_dsp_gross_tag = 1 THEN 
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                loss_reserve,       user_id, 
                                last_update)
                         VALUES(p_session_id,               reserve_ds_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,       reserve_ds_rec.claim_id,
                                reserve_ds_rec.iss_cd,      reserve_ds_rec.buss_source,
                                reserve_ds_rec.line_cd,     reserve_ds_rec.subline_cd,
                                reserve_ds_rec.loss_year,   reserve_ds_rec.item_no,
                                reserve_ds_rec.peril_cd,    reserve_ds_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,  reserve_ds_rec.shr_pct,
                                reserve_ds_rec.loss_reserve,p_user_id, 
                                SYSDATE);
                ELSE
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id, 
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,         
                                loss_reserve,       losses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                reserve_ds_rec.brdrx_record_id, v_brdrx_ds_record_id,
                                reserve_ds_rec.claim_id,     reserve_ds_rec.iss_cd,          reserve_ds_rec.buss_source,
                                reserve_ds_rec.line_cd,      reserve_ds_rec.subline_cd,      reserve_ds_rec.loss_year,
                                reserve_ds_rec.item_no,      reserve_ds_rec.peril_cd,        reserve_ds_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_ds_rec.shr_pct,         
                                reserve_ds_rec.loss_reserve, reserve_ds_rec.losses_paid, p_user_id, SYSDATE);
                END IF; 
            END;
            
            FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                            SUM(DECODE(b.dist_sw,'Y',nvl(b.convert_rate,1)*(NVL(b.loss_reserve,0)*a.shr_ri_pct/100),0)) loss_reserve,
                                            SUM(DECODE(b.dist_sw,NULL,nvl(b.convert_rate,1)*(NVL(b.losses_paid,0)*a.shr_ri_pct/100),0)) losses_paid
                                       FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                      WHERE a.claim_id = b.claim_id
                                        AND a.item_no = b.item_no
                                        AND a.peril_cd = b.peril_cd
                                        AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                        AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                        AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                        AND a.claim_id             = reserve_ds_rec.claim_id
                                        AND a.claim_id = c.claim_id
                                        AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                        AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                        AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                      GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
            LOOP
                BEGIN
                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                    IF p_dsp_gross_tag = 1 THEN
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    loss_reserve,         user_id, 
                                    last_update)
                             VALUES(p_session_id,                   v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,         reserve_ds_rec.claim_id,
                                    reserve_ds_rec.iss_cd,          reserve_ds_rec.buss_source,
                                    reserve_ds_rec.line_cd,         reserve_ds_rec.subline_cd,
                                    reserve_ds_rec.loss_year,       reserve_ds_rec.item_no,
                                    reserve_ds_rec.peril_cd,        reserve_ds_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,      reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,    reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.loss_reserve,  p_user_id, 
                                    SYSDATE);
                    ELSE 
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    loss_reserve,         losses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,        reserve_ds_rec.claim_id,
                                    reserve_ds_rec.iss_cd,         reserve_ds_rec.buss_source,
                                    reserve_ds_rec.line_cd,        reserve_ds_rec.subline_cd,
                                    reserve_ds_rec.loss_year,      reserve_ds_rec.item_no,
                                    reserve_ds_rec.peril_cd,       reserve_ds_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid, 
                                    p_user_id,                     SYSDATE);
                    END IF;
                END;   
            END LOOP;
        END LOOP;
    END erla_extract_distribution;
    /*erla = EXTRACT_RESERVE_LOSS_ALL end*/
    
    /*ereia = EXTRACT_RESERVE_EXP_INTM_ALL start*/
    PROCEDURE ereia_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                   c.intm_no, c.shr_intm_pct,
                                   (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                   (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))*c.shr_intm_pct/100) expense_reserve,
                                   (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))*c.shr_intm_pct/100) expenses_paid,
                                   d.line_cd, d.subline_cd, d.iss_cd, 
                                   TO_NUMBER(TO_CHAR(d.loss_date,'YYYY')) loss_year,
                                   d.assd_no, (d.line_cd||'-'||d.subline_cd||'-'||d.iss_cd||'-'||
                                   LTRIM(TO_CHAR(d.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(d.clm_seq_no,'0999999'))) claim_no,
                                   (d.line_cd||'-'||d.subline_cd||'-'||d.pol_iss_cd||'-'||LTRIM(TO_CHAR(d.issue_yy,'09'))||'-'||
                                   LTRIM(TO_CHAR(d.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(d.renew_no,'09'))) policy_no,
                                   d.dsp_loss_date, d.loss_date, d.clm_file_date, d.pol_eff_date, d.expiry_date,
                                   a.grouped_item_no, a.clm_res_hist_id
                              FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d 
                             WHERE a.claim_id = b.claim_id 
                               AND a.item_no  = b.item_no
                               AND a.peril_cd = b.peril_cd
                               AND b.claim_id = c.claim_id 
                               AND b.item_no  = c.item_no 
                               AND b.peril_cd = c.peril_cd     
                               AND a.claim_id = d.claim_id
                               AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                               AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                   NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                               AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                               AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                               AND TRUNC(NVL(b.close_date2, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                               AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                               AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                               AND d.pol_iss_cd  <> p_ri_iss_cd
                               AND d.clm_stat_cd NOT IN ('CC','CD','DN','WD')
                               AND TRUNC(d.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,d.dsp_loss_date),d.dsp_loss_date)) 
                               AND TRUNC(d.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,d.clm_file_date),d.clm_file_date)) 
                               AND d.line_cd    = NVL(p_dsp_line_cd,d.line_cd)
                               AND d.subline_cd = NVL(p_dsp_subline_cd,d.subline_cd)
                               AND DECODE(p_branch_option,1,d.iss_cd,2,d.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,d.iss_cd,2,d.pol_iss_cd))
                             GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                   c.intm_no, c.shr_intm_pct, NVL(a.convert_rate,1),
                                   d.line_cd, d.subline_cd, d.iss_cd, d.loss_date, d.assd_no, d.clm_yy, d.clm_seq_no,
                                   d.pol_iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no,
                                   d.dsp_loss_date, d.loss_date, d.clm_file_date, d.pol_eff_date, d.expiry_date,
                                   a.grouped_item_no, a.clm_res_hist_id
                            HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)*c.shr_intm_pct/100)- 
                                   SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)*c.shr_intm_pct/100)) <> 0
                             ORDER BY a.claim_id)
        LOOP
            v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
            
            IF p_iss_break = 1 THEN
                v_iss_cd := reserve_rec.iss_cd;
            ELSIF p_iss_break = 0 THEN
                v_iss_cd := 'DI';
            END IF;
            
            IF p_subline_break = 1 THEN
                v_subline_cd := reserve_rec.subline_cd;
            ELSIF p_subline_break = 0 THEN
                v_subline_cd := '0';
            END IF;              
        
            v_brdrx_record_id := v_brdrx_record_id + 1;
            
            IF p_dsp_gross_tag = 1 THEN 
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,    brdrx_record_id,
                            claim_id,      iss_cd,
                            buss_source,   line_cd,
                            subline_cd,    loss_year,
                            assd_no,       claim_no,
                            policy_no,     loss_date,
                            clm_file_date, item_no,
                            peril_cd,      loss_cat_cd,
                            incept_date,   expiry_date,
                            tsi_amt,       intm_no,
                            expense_reserve,user_id,
                            last_update,
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id)
                     VALUES(p_session_id,               v_brdrx_record_id,
                            reserve_rec.claim_id,       v_iss_cd,
                            v_intm_no,                  reserve_rec.line_cd,
                            v_subline_cd,               reserve_rec.loss_year,
                            reserve_rec.assd_no,        reserve_rec.claim_no,
                            reserve_rec.policy_no,      reserve_rec.dsp_loss_date, 
                            reserve_rec.clm_file_date,  reserve_rec.item_no,
                            reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                            reserve_rec.pol_eff_date,   reserve_rec.expiry_date,
                            reserve_rec.tsi_amt,        reserve_rec.intm_no,
                            reserve_rec.expense_reserve,p_user_id, 
                            SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
            ELSE
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,      brdrx_record_id,
                            claim_id,        iss_cd,
                            buss_source,     line_cd,
                            subline_cd,      loss_year,
                            assd_no,         claim_no,
                            policy_no,       loss_date,
                            clm_file_date,   item_no,
                            peril_cd,        loss_cat_cd,
                            incept_date,     expiry_date,
                            tsi_amt,         intm_no,
                            expense_reserve, expenses_paid,
                            user_id,          last_update,
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id) 
                     VALUES(p_session_id,               v_brdrx_record_id,
                            reserve_rec.claim_id,       v_iss_cd,
                            v_intm_no,                  reserve_rec.line_cd,
                            v_subline_cd,               reserve_rec.loss_year,
                            reserve_rec.assd_no,        reserve_rec.claim_no,
                            reserve_rec.policy_no,      reserve_rec.dsp_loss_date, 
                            reserve_rec.clm_file_date,  reserve_rec.item_no,
                            reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                            reserve_rec.pol_eff_date,   reserve_rec.expiry_date,
                            reserve_rec.tsi_amt,        reserve_rec.intm_no,
                            reserve_rec.expense_reserve,reserve_rec.expenses_paid,
                            p_user_id,                     SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id); 
            END IF;
        END LOOP;   
        
        p_brdrx_record_id := v_brdrx_record_id;                          
    END ereia_extract_direct;
    
    PROCEDURE ereia_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd  = p_ri_iss_cd
                              AND TRUNC(a.dsp_loss_date) <= 
                                  (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                              AND TRUNC(a.clm_file_date) <= 
                                  (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd)) 
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date2, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate, 1),
                                       a.grouped_item_no, a.clm_res_hist_id --added by MAC 10/28/2011    
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0)
            LOOP
                BEGIN
                    IF p_subline_break = 1 THEN
                        v_subline_cd := claims_rec.subline_cd;
                    ELSIF p_subline_break = 0 THEN
                        v_subline_cd := '0';
                    END IF; 
                    
                    v_brdrx_record_id := v_brdrx_record_id + 1;
          
                    IF p_dsp_gross_tag = 1 THEN 
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       expense_reserve,
                                    user_id,       last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id)  
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, reserve_rec.item_no,
                                    reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    reserve_rec.ann_tsi_amt,  reserve_rec.expense_reserve,
                                    p_user_id,                  SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                    ELSE
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,     brdrx_record_id,
                                    claim_id,       iss_cd,
                                    buss_source,    line_cd,
                                    subline_cd,     loss_year,
                                    assd_no,        claim_no,
                                    policy_no,      loss_date,
                                    clm_file_date,  item_no,
                                    peril_cd,       loss_cat_cd,
                                    incept_date,    expiry_date,
                                    tsi_amt, 
                                    expense_reserve,expenses_paid,
                                    user_id,         last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,               v_brdrx_record_id,
                                    claims_rec.claim_id,        claims_rec.iss_cd,
                                    claims_rec.ri_cd,           claims_rec.line_cd,
                                    v_subline_cd,               claims_rec.loss_year,
                                    claims_rec.assd_no,         claims_rec.claim_no,
                                    claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date,   reserve_rec.item_no,
                                    reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,    claims_rec.expiry_date,
                                    reserve_rec.ann_tsi_amt,
                                    reserve_rec.expense_reserve,reserve_rec.expenses_paid,
                                    p_user_id,                    SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                    END IF;          
                END;
            END LOOP;
        END LOOP;
    END ereia_extract_inward;
    
    PROCEDURE ereia_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.expense_reserve * a.shr_pct/100) expense_reserve,
                                          (brdrx_extr_rec.expenses_paid * a.shr_pct/100) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                BEGIN
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                expense_reserve,    expenses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                  brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,          brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,     reserve_ds_rec.shr_pct,
                                reserve_ds_rec.expense_reserve,reserve_ds_rec.expenses_paid, 
                                p_user_id,                     SYSDATE);
                END;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct_real/100) expense_reserve,
                                                (reserve_ds_rec.expenses_paid * a.shr_ri_pct_real/100) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id             = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    BEGIN
                        v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                        
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    expense_reserve,      expenses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid, 
                                    p_user_id,                        SYSDATE);
                    END;
                END LOOP;
            END LOOP;
        END LOOP;
    END ereia_extract_distribution;
    /*ereia = EXTRACT_RESERVE_EXP_INTM_ALL end*/
    
    /*erea = EXTRACT_RESERVE_EXP_ALL start*/
    PROCEDURE erea_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE 1 =1 
                              AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                              AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd)) 
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            v_source := 0; 
            
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date2, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                                a.grouped_item_no, a.clm_res_hist_id 
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0)
            LOOP
                BEGIN
                    IF p_iss_break = 1 THEN
                        v_iss_cd := claims_rec.iss_cd;
                    ELSIF p_iss_break = 0 THEN
                        v_iss_cd := '0';
                    END IF;
                    
                    IF p_subline_break = 1 THEN
                        v_subline_cd := claims_rec.subline_cd;
                    ELSIF p_subline_break = 0 THEN
                        v_subline_cd := '0';
                    END IF;
                                  
                    v_brdrx_record_id := v_brdrx_record_id + 1;
                    
                    IF p_dsp_gross_tag = 1 THEN
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,        
                                    expense_reserve,user_id,
                                    last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,               v_brdrx_record_id,
                                    claims_rec.claim_id,        v_iss_cd,
                                    v_source,                   claims_rec.line_cd,
                                    v_subline_cd,               claims_rec.loss_year,
                                    claims_rec.assd_no,         claims_rec.claim_no,
                                    claims_rec.policy_no,       claims_rec.dsp_loss_date,
                                    claims_rec.clm_file_date,   reserve_rec.item_no,
                                    reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,    claims_rec.expiry_date,
                                    reserve_rec.ann_tsi_amt,  
                                    reserve_rec.expense_reserve,p_user_id, 
                                      SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                    ELSE      
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,       brdrx_record_id,
                                    claim_id,         iss_cd,
                                    buss_source,      line_cd,
                                    subline_cd,       loss_year,
                                    assd_no,          claim_no,
                                    policy_no,        loss_date,
                                    clm_file_date,    item_no,
                                    peril_cd,         loss_cat_cd,
                                    incept_date,      expiry_date,
                                    tsi_amt,           
                                    expense_reserve,  expenses_paid,              
                                    user_id,           last_update,
                                    extr_type,          brdrx_type,
                                    ol_date_opt,      brdrx_rep_type,
                                    res_tag,          pd_date_opt,
                                    intm_tag,          iss_cd_tag,
                                    line_cd_tag,      loss_cat_tag,
                                    from_date,          to_date,
                                    branch_opt,          reg_date_opt,
                                    net_rcvry_tag,      rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no,  clm_res_hist_id)
                             VALUES(p_session_id,                v_brdrx_record_id,
                                    claims_rec.claim_id,         v_iss_cd,
                                    v_source,                    claims_rec.line_cd,
                                    v_subline_cd,                claims_rec.loss_year,
                                    claims_rec.assd_no,          claims_rec.claim_no,
                                    claims_rec.policy_no,        claims_rec.dsp_loss_date,
                                    claims_rec.clm_file_date,    reserve_rec.item_no,
                                    reserve_rec.peril_cd,        reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,     claims_rec.expiry_date,
                                    reserve_rec.ann_tsi_amt,     
                                    reserve_rec.expense_reserve, reserve_rec.expenses_paid,
                                    p_user_id,                      SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                    END IF;
                END;
            END LOOP;
        END LOOP;
    END erea_extract_all;
    
    PROCEDURE erea_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN NUMBER,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.expense_reserve * a.shr_pct/100) expense_reserve,
                                          (brdrx_extr_rec.expenses_paid * a.shr_pct/100) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                BEGIN
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                    
                    IF p_dsp_gross_tag = 1 THEN 
                        INSERT INTO gicl_res_brdrx_ds_extr
                                   (session_id,         brdrx_record_id,
                                    brdrx_ds_record_id, claim_id,
                                    iss_cd,             buss_source,
                                    line_cd,            subline_cd,
                                    loss_year,          item_no,
                                    peril_cd,           loss_cat_cd,
                                    grp_seq_no,         shr_pct,
                                    expense_reserve,    user_id, 
                                    last_update)
                             VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id,
                                    v_brdrx_ds_record_id,           brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,       brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,
                                    reserve_ds_rec.expense_reserve, p_user_id, 
                                    SYSDATE);
                    ELSE
                        INSERT INTO gicl_res_brdrx_ds_extr
                                   (session_id,         brdrx_record_id,
                                    brdrx_ds_record_id, claim_id, 
                                    iss_cd,             buss_source,
                                    line_cd,            subline_cd,
                                    loss_year,          item_no,
                                    peril_cd,           loss_cat_cd,
                                    grp_seq_no,         shr_pct,         
                                    expense_reserve,    expenses_paid, 
                                    user_id,            last_update)
                             VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id, v_brdrx_ds_record_id,
                                    brdrx_extr_rec.claim_id,        brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,      brdrx_extr_rec.loss_year,
                                    brdrx_extr_rec.item_no,         brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,         
                                    reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid, 
                                    p_user_id,                      SYSDATE);
                    END IF; 
                END;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct/100) expense_reserve,
                                                (reserve_ds_rec.expenses_paid * a.shr_ri_pct/100) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id             = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date 
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    BEGIN
                        v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                        
                        IF p_dsp_gross_tag = 1 THEN
                            INSERT INTO gicl_res_brdrx_rids_extr 
                                       (session_id,           brdrx_ds_record_id,
                                        brdrx_rids_record_id, claim_id,
                                        iss_cd,               buss_source,
                                        line_cd,              subline_cd,
                                        loss_year,            item_no,
                                        peril_cd,             loss_cat_cd,
                                        grp_seq_no,           ri_cd,
                                        prnt_ri_cd,           shr_ri_pct,
                                        expense_reserve,      user_id, 
                                        last_update)
                                 VALUES(p_session_id,                       v_brdrx_ds_record_id,
                                        v_brdrx_rids_record_id,             brdrx_extr_rec.claim_id,
                                        brdrx_extr_rec.iss_cd,              brdrx_extr_rec.buss_source,
                                        brdrx_extr_rec.line_cd,             brdrx_extr_rec.subline_cd,
                                        brdrx_extr_rec.loss_year,           brdrx_extr_rec.item_no,
                                        brdrx_extr_rec.peril_cd,            brdrx_extr_rec.loss_cat_cd, 
                                        reserve_ds_rec.grp_seq_no,          reserve_rids_rec.ri_cd,
                                        reserve_rids_rec.prnt_ri_cd,        reserve_rids_rec.shr_ri_pct_real,
                                        reserve_rids_rec.expense_reserve,   p_user_id, 
                                        SYSDATE);
                        ELSE 
                            INSERT INTO gicl_res_brdrx_rids_extr 
                                       (session_id,           brdrx_ds_record_id,
                                        brdrx_rids_record_id, claim_id,
                                        iss_cd,               buss_source,
                                        line_cd,              subline_cd,
                                        loss_year,            item_no,
                                        peril_cd,             loss_cat_cd,
                                        grp_seq_no,           ri_cd,
                                        prnt_ri_cd,           shr_ri_pct,
                                        expense_reserve,      expenses_paid, 
                                        user_id,              last_update)
                                 VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                        v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                        brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                        brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                        brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                        brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                        reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                        reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                        reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid, 
                                        p_user_id,                        SYSDATE);
                        END IF;
                    END;
                END LOOP;
            END LOOP;
        END LOOP;
    END erea_extract_distribution;
    /*erea = EXTRACT_RESERVE_EXP_ALL end*/
    
    /*erleia = EXTRACT_RESERVE_LOSSEXPINTMALL start*/
    PROCEDURE erleia_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd  <> p_ri_iss_cd
                              AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                              AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                       c.intm_no, c.shr_intm_pct,
                                       (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                       (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))*c.shr_intm_pct/100) loss_reserve,
                                       (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))*c.shr_intm_pct/100) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND b.claim_id = c.claim_id 
                                   AND b.item_no  = c.item_no 
                                   AND b.peril_cd = c.peril_cd     
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = d.claim_id
                                   AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                   AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                       c.intm_no, c.shr_intm_pct, NVL(a.convert_rate,1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)*c.shr_intm_pct/100)- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)*c.shr_intm_pct/100)) <> 0)
            LOOP
                v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
        
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := 'DI';
                END IF;
                
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;
                              
                v_brdrx_record_id := v_brdrx_record_id + 1;
        
                IF p_dsp_gross_tag = 1 THEN 
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       intm_no,
                                loss_reserve,  user_id, 
                                last_update,                                
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_intm_no,                claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date,
                                reserve_rec.tsi_amt,      reserve_rec.intm_no,
                                reserve_rec.loss_reserve, p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       intm_no,
                                loss_reserve,  losses_paid, 
                                user_id,       last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_intm_no,                claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date,
                                reserve_rec.tsi_amt,      reserve_rec.intm_no,
                                reserve_rec.loss_reserve, reserve_rec.losses_paid, 
                                p_user_id,                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                END IF; 
            END LOOP;
            
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                       c.intm_no, c.shr_intm_pct,
                                       (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                       (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))*c.shr_intm_pct/100) expense_reserve,
                                       (SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))*c.shr_intm_pct/100) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, gicl_claims d
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND b.claim_id = c.claim_id 
                                   AND b.item_no  = c.item_no 
                                   AND b.peril_cd = c.peril_cd     
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = d.claim_id
                                   AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date2, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                   AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt,
                                       c.intm_no, c.shr_intm_pct, NVL(a.convert_rate,1),
                                       a.grouped_item_no, a.clm_res_hist_id --added by MAC 10/28/2011
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)*c.shr_intm_pct/100)- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)*c.shr_intm_pct/100)) <> 0)
            LOOP
                v_intm_no := get_parent_intm_gicls202(reserve_rec.intm_no);
                
                IF p_iss_break = 1 THEN
                    v_iss_cd := claims_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := 'DI';
                END IF;
        
                IF p_subline_break = 1 THEN
                    v_subline_cd := claims_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;              
        
                v_brdrx_record_id := v_brdrx_record_id + 1;
        
                IF p_dsp_gross_tag = 1 THEN 
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id,
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no,
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       intm_no,
                                expense_reserve, 
                                user_id,       last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)
                         VALUES(p_session_id,             v_brdrx_record_id,
                                claims_rec.claim_id,      v_iss_cd,
                                v_intm_no,                claims_rec.line_cd,
                                v_subline_cd,             claims_rec.loss_year,
                                claims_rec.assd_no,       claims_rec.claim_no,
                                claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date, reserve_rec.item_no,
                                reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,  claims_rec.expiry_date,
                                reserve_rec.tsi_amt,      reserve_rec.intm_no,
                                reserve_rec.expense_reserve, 
                                p_user_id,                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,      brdrx_record_id,
                                claim_id,        iss_cd,
                                buss_source,     line_cd,
                                subline_cd,      loss_year,
                                assd_no,         claim_no,
                                policy_no,       loss_date,
                                clm_file_date,   item_no,
                                peril_cd,        loss_cat_cd,
                                incept_date,     expiry_date,
                                tsi_amt,         intm_no,
                                expense_reserve, expenses_paid, 
                                user_id,         last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,    
                                grouped_item_no, clm_res_hist_id)
                         VALUES(p_session_id,                v_brdrx_record_id,
                                claims_rec.claim_id,         v_iss_cd,
                                v_intm_no,                   claims_rec.line_cd,
                                v_subline_cd,                claims_rec.loss_year,
                                claims_rec.assd_no,          claims_rec.claim_no,
                                claims_rec.policy_no,        claims_rec.dsp_loss_date, 
                                claims_rec.clm_file_date,    reserve_rec.item_no,
                                reserve_rec.peril_cd,        reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,     claims_rec.expiry_date,
                                reserve_rec.tsi_amt,         reserve_rec.intm_no,
                                reserve_rec.expense_reserve, reserve_rec.expenses_paid, 
                                p_user_id,                   SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                END IF; 
            END LOOP;
        END LOOP;
        
        p_brdrx_record_id := v_brdrx_record_id;
    END erleia_extract_direct;
    
    PROCEDURE erleia_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, 
                                  TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd  = p_ri_iss_cd
                              AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                              AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c 
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate, 1),
                                       a.grouped_item_no, a.clm_res_hist_id
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0)
            LOOP
                BEGIN
                    IF p_subline_break = 1 THEN
                        v_subline_cd := claims_rec.subline_cd;
                    ELSIF p_subline_break = 0 THEN
                        v_subline_cd := '0';
                    END IF; 
          
                    v_brdrx_record_id := v_brdrx_record_id + 1;
                    
                    IF p_dsp_gross_tag = 1 THEN 
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       loss_reserve, 
                                    user_id,       last_update,                                  
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,    
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, reserve_rec.item_no,
                                    reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    reserve_rec.ann_tsi_amt,  reserve_rec.loss_reserve, 
                                    p_user_id,                SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                    ELSE
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt, 
                                    loss_reserve,  losses_paid, 
                                    user_id,       last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, reserve_rec.item_no,
                                    reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date,
                                    reserve_rec.ann_tsi_amt,
                                    reserve_rec.loss_reserve, reserve_rec.losses_paid, 
                                    p_user_id,                SYSDATE,             
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                    END IF;          
                END;
            END LOOP;
            
            FOR reserve_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                                       SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.claim_id = b.claim_id 
                                   AND a.item_no  = b.item_no
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = claims_rec.claim_id
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||
                                       NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                   AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                   AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                   AND TRUNC(NVL(b.close_date2, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                   AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                 GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate, 1),
                                       a.grouped_item_no, a.clm_res_hist_id    
                                HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                       SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0)
            LOOP
                BEGIN
                    IF p_subline_break = 1 THEN
                        v_subline_cd := claims_rec.subline_cd;
                    ELSIF p_subline_break = 0 THEN
                        v_subline_cd := '0';
                    END IF;
                     
                    v_brdrx_record_id := v_brdrx_record_id + 1;
                    
                    IF p_dsp_gross_tag = 1 THEN 
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       expense_reserve, 
                                    user_id,       last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,    
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, reserve_rec.item_no,
                                    reserve_rec.peril_cd,     reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    reserve_rec.ann_tsi_amt,  reserve_rec.expense_reserve, 
                                    p_user_id,                SYSDATE,                             
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            nvl(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                    ELSE
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt, 
                                    expense_reserve,expenses_paid, 
                                    user_id,        last_update,                                               
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,    
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,               v_brdrx_record_id,
                                    claims_rec.claim_id,        claims_rec.iss_cd,
                                    claims_rec.ri_cd,           claims_rec.line_cd,
                                    v_subline_cd,               claims_rec.loss_year,
                                    claims_rec.assd_no,         claims_rec.claim_no,
                                    claims_rec.policy_no,       claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date,   reserve_rec.item_no,
                                    reserve_rec.peril_cd,       reserve_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,    claims_rec.expiry_date,
                                    reserve_rec.ann_tsi_amt,
                                    reserve_rec.expense_reserve,reserve_rec.expenses_paid, 
                                    p_user_id,                  SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);
                    END IF;          
                END;
            END LOOP;
        END LOOP;
    END erleia_extract_inward;
    
    PROCEDURE erleia_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.losses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.loss_reserve * a.shr_pct/100) loss_reserve,
                                          (brdrx_extr_rec.losses_paid * a.shr_pct/100) losses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                BEGIN                    
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                loss_reserve,       losses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,        brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,   reserve_ds_rec.shr_pct,
                                reserve_ds_rec.loss_reserve, reserve_ds_rec.losses_paid, 
                                p_user_id,                   SYSDATE);
                END;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.loss_reserve * a.shr_ri_pct_real/100) loss_reserve,
                                                (reserve_ds_rec.losses_paid * a.shr_ri_pct_real/100) losses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id             = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1 
                                            AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    BEGIN
                        v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                        
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    loss_reserve,         losses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,        brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid, 
                                    p_user_id,                     SYSDATE);
                    END;  
                END LOOP;
            END LOOP;
        END LOOP;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.expense_reserve, a.expenses_paid
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id
                                  AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          (brdrx_extr_rec.expense_reserve * a.shr_pct/100) expense_reserve,
                                          (brdrx_extr_rec.expenses_paid * a.shr_pct/100) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND NVL(a.negate_tag,'N')  = 'N'
                                      AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                BEGIN
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                    INSERT INTO gicl_res_brdrx_ds_extr
                               (session_id,         brdrx_record_id,
                                brdrx_ds_record_id, claim_id,
                                iss_cd,             buss_source,
                                line_cd,            subline_cd,
                                loss_year,          item_no,
                                peril_cd,           loss_cat_cd,
                                grp_seq_no,         shr_pct,
                                expense_reserve,    expenses_paid, 
                                user_id,            last_update)
                         VALUES(p_session_id,                  brdrx_extr_rec.brdrx_record_id,
                                v_brdrx_ds_record_id,          brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                reserve_ds_rec.grp_seq_no,     reserve_ds_rec.shr_pct,
                                reserve_ds_rec.expense_reserve,reserve_ds_rec.expenses_paid, 
                                p_user_id,                     SYSDATE);
                END;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                (reserve_ds_rec.expense_reserve * a.shr_ri_pct_real/100) expense_reserve,
                                                (reserve_ds_rec.expenses_paid * a.shr_ri_pct_real/100) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id             = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    BEGIN
                        v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
                        
                        INSERT INTO gicl_res_brdrx_rids_extr 
                                   (session_id,           brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,               buss_source,
                                    line_cd,              subline_cd,
                                    loss_year,            item_no,
                                    peril_cd,             loss_cat_cd,
                                    grp_seq_no,           ri_cd,
                                    prnt_ri_cd,           shr_ri_pct,
                                    expense_reserve,      expenses_paid, 
                                    user_id,              last_update)
                             VALUES(p_session_id,                     v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id,           brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,            brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,           brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,         brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,          brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,        reserve_rids_rec.ri_cd,
                                    reserve_rids_rec.prnt_ri_cd,      reserve_rids_rec.shr_ri_pct_real,
                                    reserve_rids_rec.expense_reserve, reserve_rids_rec.expenses_paid, 
                                    p_user_id,                        SYSDATE);
                    END; 
                END LOOP;
            END LOOP;
        END LOOP;
    END erleia_extract_distribution;
    /*erleia = EXTRACT_RESERVE_LOSSEXPINTMALL end*/
    
    /*erlea = EXTRACT_RESERVE_LOSS_EXP_ALL start*/
    PROCEDURE erlea_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
    BEGIN
        v_source := 0;
        
        IF p_dsp_gross_tag = 1 THEN
            INSERT INTO gicl_res_brdrx_extr (session_id, brdrx_record_id, claim_id, iss_cd, buss_source, line_cd,
                                             subline_cd, loss_year, assd_no, claim_no, policy_no, loss_date, 
                                             clm_file_date, item_no, peril_cd, loss_cat_cd, incept_date, expiry_date,
                                             tsi_amt, loss_reserve, user_id, last_update,   
                                             extr_type,            brdrx_type,
                                             ol_date_opt,        brdrx_rep_type,
                                             res_tag,            pd_date_opt,
                                             intm_tag,            iss_cd_tag,
                                             line_cd_tag,        loss_cat_tag,
                                             from_date,            to_date,
                                             branch_opt,        reg_date_opt,
                                             net_rcvry_tag,        rcvry_from_date,
                                             rcvry_to_date,
                                             grouped_item_no,   clm_res_hist_id)
                                      SELECT p_session_id, ROWNUM brdrx_record_id, a.claim_id, DECODE(p_iss_break,1,a.iss_cd,0,'0') iss_cd, v_source, a.line_cd,  
                                             DECODE(p_subline_break,1,a.subline_cd,0,'0') subline_cd, TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year, a.assd_no, 
                                             (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                             (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                             a.dsp_loss_date, a.clm_file_date, c.item_no, c.peril_cd, c.loss_cat_cd, a.pol_eff_date, a.expiry_date,
                                             c.ann_tsi_amt, c.loss_reserve, p_user_id, SYSDATE,
                                             p_rep_name,         p_brdrx_type,
                                             p_brdrx_date_option,p_brdrx_option,
                                             p_dsp_gross_tag,     p_paid_date_option,
                                             p_per_buss,         p_iss_break,
                                             p_subline_break,    p_per_loss_cat,
                                             p_dsp_from_date,     nvl(p_dsp_to_date,p_dsp_as_of_date),
                                             p_branch_option,     p_reg_button,
                                             p_net_rcvry_chkbx,     p_dsp_rcvry_from_date,
                                             p_dsp_rcvry_to_date,
                                             c.grouped_item_no,  c.clm_res_hist_id
                                        FROM gicl_claims a, (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                                                    (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                                                                    SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                                                    SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                                                    a.grouped_item_no, a.clm_res_hist_id
                                                               FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                                              WHERE a.claim_id = b.claim_id 
                                                                AND a.item_no  = b.item_no
                                                                AND a.peril_cd = b.peril_cd
                                                                AND a.claim_id = c.claim_id
                                                                AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                                                AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                                                AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                                                AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                                                AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                                                AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                                              GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate, 1),
                                                                    a.grouped_item_no, a.clm_res_hist_id
                                                             HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0) c 
                                       WHERE 1 = 1
                                         AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                                         AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                                         AND a.line_cd = NVL(p_dsp_line_cd,a.line_cd)
                                         AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                                         AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                                         AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                         AND a.claim_id = c.claim_id;
        ELSE
            INSERT INTO gicl_res_brdrx_extr (session_id, brdrx_record_id, claim_id, iss_cd, buss_source, line_cd,
                                             subline_cd, loss_year, assd_no, claim_no, policy_no, loss_date, 
                                             clm_file_date, item_no, peril_cd, loss_cat_cd, incept_date, expiry_date,
                                             tsi_amt, loss_reserve, losses_paid,
                                             expense_reserve, expenses_paid,
                                             user_id, last_update,  
                                             extr_type,         brdrx_type,
                                             ol_date_opt,     brdrx_rep_type,
                                             res_tag,         pd_date_opt,
                                             intm_tag,         iss_cd_tag,
                                             line_cd_tag,     loss_cat_tag,
                                             from_date,         to_date,
                                             branch_opt,     reg_date_opt,
                                             net_rcvry_tag,     rcvry_from_date,
                                             rcvry_to_date,
                                             grouped_item_no,clm_res_hist_id) 
                                      SELECT p_session_id, ROWNUM brdrx_record_id, a.claim_id, DECODE(p_iss_break,1,a.iss_cd,0,'0') iss_cd,v_source, a.line_cd,  
                                             DECODE(p_subline_break,1,a.subline_cd,0,'0') subline_cd, TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year, 
                                             a.assd_no, (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                             (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                             a.dsp_loss_date, a.clm_file_date, c.item_no, c.peril_cd, c.loss_cat_cd, a.pol_eff_date, a.expiry_date,
                                             c.ann_tsi_amt, c.loss_reserve, c.losses_paid, 
                                             c.expense_reserve, c.expenses_paid,
                                             p_user_id, SYSDATE,
                                             p_rep_name,                     p_brdrx_type,
                                             p_brdrx_date_option,p_brdrx_option,
                                             p_dsp_gross_tag,     p_paid_date_option,
                                             p_per_buss,         p_iss_break,
                                             p_subline_break,    p_per_loss_cat,
                                             p_dsp_from_date,     NVL(p_dsp_to_date,p_dsp_as_of_date),
                                             p_branch_option,     p_reg_button,
                                             p_net_rcvry_chkbx,     p_dsp_rcvry_from_date,
                                             p_dsp_rcvry_to_date,
                                             c.grouped_item_no,  c.clm_res_hist_id
                                        FROM gicl_claims a, (SELECT a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, 
                                                                    (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                                                    SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0)) loss_reserve,
                                                                    SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0)) losses_paid,
                                                                    SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0)) expense_reserve,
                                                                    SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0)) expenses_paid,
                                                                    a.grouped_item_no, a.clm_res_hist_id
                                                               FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                                              WHERE a.claim_id = b.claim_id 
                                                                AND a.item_no  = b.item_no
                                                                AND a.peril_cd = b.peril_cd
                                                                AND a.claim_id = c.claim_id
                                                                AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                                                AND TO_DATE(NVL(a.booking_month,TO_CHAR(p_dsp_as_of_date,'FMMONTH'))||' 01, '||NVL(TO_CHAR(a.booking_year,'0999'),TO_CHAR(p_dsp_as_of_date,'YYYY')),'FMMONTH DD, YYYY') <= p_dsp_as_of_date
                                                                AND TRUNC(NVL(a.date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                                                AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                                                AND TRUNC(NVL(b.close_date, p_dsp_as_of_date + 1)) > p_dsp_as_of_date
                                                                AND b.peril_cd = NVL(p_dsp_peril_cd,b.peril_cd)
                                                              GROUP BY a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, NVL(a.convert_rate, 1),
                                                                    a.grouped_item_no, a.clm_res_hist_id
                                                             HAVING (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.loss_reserve,0),0))- 
                                                                     SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.losses_paid,0),0))) <> 0
                                                                 OR (SUM(DECODE(a.dist_sw,'Y',NVL(a.convert_rate,1)*NVL(a.expense_reserve,0),0))- 
                                                                     SUM(DECODE(a.dist_sw,NULL,NVL(a.convert_rate,1)*NVL(a.expenses_paid,0),0))) <> 0) c
                                       WHERE 1 = 1
                                         AND TRUNC(a.dsp_loss_date) <= (DECODE(p_brdrx_date_option,1,NVL(p_dsp_as_of_date,a.dsp_loss_date),a.dsp_loss_date)) 
                                         AND TRUNC(a.clm_file_date) <= (DECODE(p_brdrx_date_option,2,NVL(p_dsp_as_of_date,a.clm_file_date),a.clm_file_date)) 
                                         AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                                         AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                                         AND a.claim_id = c.claim_id
                                         AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                         AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd));
        END IF;
        
        SELECT MAX(brdrx_record_id) 
          INTO p_brdrx_record_id  
          FROM gicl_res_brdrx_extr;
    END erlea_extract_all;
    
    PROCEDURE erlea_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR brdrx_extr_rec IN (SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source, 
                                      a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                                      a.loss_cat_cd, a.loss_reserve, a.losses_paid, a.clm_res_hist_id
                                 FROM gicl_res_brdrx_extr a
                                WHERE session_id = p_session_id)
        LOOP
            FOR reserve_ds_rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.clm_dist_no,
                                          a.grp_seq_no, a.shr_pct,
                                          SUM(DECODE(b.dist_sw,'Y',NVL(b.loss_reserve,0)*a.shr_pct/100,0)) loss_reserve,
                                          SUM(DECODE(b.dist_sw,NULL,NVL(b.losses_paid,0)*a.shr_pct/100,0)) losses_paid,
                                          SUM(DECODE(b.dist_sw,'Y',NVL(b.expense_reserve,0)*a.shr_pct/100,0)) expense_reserve,
                                          SUM(DECODE(b.dist_sw,NULL,NVL(b.expenses_paid,0)*a.shr_pct/100,0)) expenses_paid
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds a, gicl_claims c
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no 
                                      AND a.peril_cd = b.peril_cd
                                      AND a.peril_cd             = brdrx_extr_rec.peril_cd
                                      AND a.item_no              = brdrx_extr_rec.item_no
                                      AND a.claim_id             = brdrx_extr_rec.claim_id
                                      AND a.claim_id = c.claim_id
                                      AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                      AND a.clm_res_hist_id             = brdrx_extr_rec.clm_res_hist_id
                                      AND NVL(a.negate_tag,'N') <> 'Y'
                                      AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                      AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                    GROUP BY a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct)
            LOOP
                BEGIN
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                    IF p_dsp_gross_tag = 1 THEN 
                        INSERT INTO gicl_res_brdrx_ds_extr
                                   (session_id,         brdrx_record_id,
                                    brdrx_ds_record_id, claim_id,
                                    iss_cd,             buss_source,
                                    line_cd,            subline_cd,
                                    loss_year,          item_no,
                                    peril_cd,           loss_cat_cd,
                                    grp_seq_no,         shr_pct,
                                    loss_reserve,       expense_reserve,
                                    user_id,            last_update)
                             VALUES(p_session_id,               brdrx_extr_rec.brdrx_record_id,
                                    v_brdrx_ds_record_id,       brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,      brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,     brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,   brdrx_extr_rec.item_no,
                                    brdrx_extr_rec.peril_cd,    brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,  reserve_ds_rec.shr_pct,
                                    reserve_ds_rec.loss_reserve,reserve_ds_rec.expense_reserve,
                                    p_user_id,                  SYSDATE);
                    ELSE
                        INSERT INTO gicl_res_brdrx_ds_extr
                                   (session_id,         brdrx_record_id,
                                    brdrx_ds_record_id, claim_id, 
                                    iss_cd,             buss_source,
                                    line_cd,            subline_cd,
                                    loss_year,          item_no,
                                    peril_cd,           loss_cat_cd,
                                    grp_seq_no,         shr_pct,         
                                    loss_reserve,       losses_paid, 
                                    expense_reserve,    expenses_paid,
                                    user_id,            last_update)
                             VALUES(p_session_id,                   brdrx_extr_rec.brdrx_record_id, v_brdrx_ds_record_id,
                                    brdrx_extr_rec.claim_id,        brdrx_extr_rec.iss_cd,          brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,         brdrx_extr_rec.subline_cd,      brdrx_extr_rec.loss_year,
                                    brdrx_extr_rec.item_no,         brdrx_extr_rec.peril_cd,        brdrx_extr_rec.loss_cat_cd, 
                                    reserve_ds_rec.grp_seq_no,      reserve_ds_rec.shr_pct,         
                                    reserve_ds_rec.loss_reserve,    reserve_ds_rec.losses_paid, 
                                    reserve_ds_rec.expense_reserve, reserve_ds_rec.expenses_paid,
                                    p_user_id,                      SYSDATE);
                    END IF; 
                END;
                
                FOR reserve_rids_rec IN (SELECT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                                                SUM(DECODE(b.dist_sw,'Y',NVL(b.loss_reserve,0)*a.shr_ri_pct/100,0)) loss_reserve,
                                                SUM(DECODE(b.dist_sw,NULL,NVL(b.losses_paid,0)*a.shr_ri_pct/100,0)) losses_paid,
                                                SUM(DECODE(b.dist_sw,'Y',NVL(b.expense_reserve,0)*a.shr_ri_pct/100,0)) expense_reserve,
                                                SUM(DECODE(b.dist_sw,NULL,NVL(b.expenses_paid,0)*a.shr_ri_pct/100,0)) expenses_paid
                                           FROM gicl_clm_res_hist b, gicl_reserve_rids a, gicl_claims c
                                          WHERE a.claim_id = b.claim_id
                                            AND a.item_no = b.item_no
                                            AND a.peril_cd = b.peril_cd
                                            AND a.grp_seq_no           = reserve_ds_rec.grp_seq_no
                                            AND a.clm_dist_no          = reserve_ds_rec.clm_dist_no
                                            AND a.clm_res_hist_id      = reserve_ds_rec.clm_res_hist_id
                                            AND a.claim_id             = reserve_ds_rec.claim_id
                                            AND a.claim_id = c.claim_id
                                            AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                            AND TRUNC(NVL(date_paid,p_dsp_as_of_date)) <= p_dsp_as_of_date
                                            AND DECODE(b.cancel_tag,'Y',TRUNC(b.cancel_date),p_dsp_as_of_date + 1) > p_dsp_as_of_date
                                          GROUP BY a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real)
                LOOP
                    BEGIN
                        v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;
            
                        IF p_dsp_gross_tag = 1 THEN
                            INSERT INTO gicl_res_brdrx_rids_extr 
                                       (session_id,           brdrx_ds_record_id,
                                        brdrx_rids_record_id, claim_id,
                                        iss_cd,               buss_source,
                                        line_cd,              subline_cd,
                                        loss_year,            item_no,
                                        peril_cd,             loss_cat_cd,
                                        grp_seq_no,           ri_cd,
                                        prnt_ri_cd,           shr_ri_pct,
                                        loss_reserve,         expense_reserve,
                                        user_id,              last_update)
                                 VALUES(p_session_id,                v_brdrx_ds_record_id,
                                        v_brdrx_rids_record_id,      brdrx_extr_rec.claim_id,
                                        brdrx_extr_rec.iss_cd,       brdrx_extr_rec.buss_source,
                                        brdrx_extr_rec.line_cd,      brdrx_extr_rec.subline_cd,
                                        brdrx_extr_rec.loss_year,    brdrx_extr_rec.item_no,
                                        brdrx_extr_rec.peril_cd,     brdrx_extr_rec.loss_cat_cd, 
                                        reserve_ds_rec.grp_seq_no,   reserve_rids_rec.ri_cd,
                                        reserve_rids_rec.prnt_ri_cd, reserve_rids_rec.shr_ri_pct_real,
                                        reserve_rids_rec.loss_reserve,reserve_rids_rec.expense_reserve, 
                                        p_user_id,                    SYSDATE);
                        ELSE 
                            INSERT INTO gicl_res_brdrx_rids_extr 
                                       (session_id,           brdrx_ds_record_id,
                                        brdrx_rids_record_id, claim_id,
                                        iss_cd,               buss_source,
                                        line_cd,              subline_cd,
                                        loss_year,            item_no,
                                        peril_cd,             loss_cat_cd,
                                        grp_seq_no,           ri_cd,
                                        prnt_ri_cd,           shr_ri_pct,
                                        loss_reserve,         losses_paid,
                                        expense_reserve,      expenses_paid, 
                                        user_id, last_update)
                                 VALUES(p_session_id,                  v_brdrx_ds_record_id,
                                        v_brdrx_rids_record_id,        brdrx_extr_rec.claim_id,
                                        brdrx_extr_rec.iss_cd,         brdrx_extr_rec.buss_source,
                                        brdrx_extr_rec.line_cd,        brdrx_extr_rec.subline_cd,
                                        brdrx_extr_rec.loss_year,      brdrx_extr_rec.item_no,
                                        brdrx_extr_rec.peril_cd,       brdrx_extr_rec.loss_cat_cd, 
                                        reserve_ds_rec.grp_seq_no,     reserve_rids_rec.ri_cd,
                                        reserve_rids_rec.prnt_ri_cd,   reserve_rids_rec.shr_ri_pct_real,
                                        reserve_rids_rec.loss_reserve, reserve_rids_rec.losses_paid, 
                                        reserve_rids_rec.expense_reserve,reserve_rids_rec.expenses_paid,
                                        p_user_id,                       SYSDATE);
                        END IF;
                    END;   
                END LOOP;
            END LOOP;
        END LOOP;
    END erlea_extract_distribution;
    /*erlea = EXTRACT_RESERVE_LOSS_EXP_ALL end*/
    
    /*epli = EXTRACT_PAID_LE_INTM start*/
    PROCEDURE epli_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE   
    ) IS
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_losses_paid               gicl_clm_res_hist.losses_paid%TYPE;
        v_expenses_paid             gicl_clm_res_hist.expenses_paid%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR paid_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,  
                                c.intm_no, c.shr_intm_pct,
                                (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt,
                                DECODE(p_brdrx_option,1,SUM(a.losses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100,
                                                      2,SUM(a.expenses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100,NULL) claims_paid,
                                (SUM(a.losses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100) losspaid,
                                (SUM(a.expenses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100) expensepaid,
                                a.clm_loss_id, a.dist_no,
                                f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                                f.pol_seq_no, f.renew_no, TO_NUMBER(TO_CHAR(f.loss_date,'YYYY')) loss_year,
                                f.assd_no,(f.line_cd||'-'||f.subline_cd||'-'||f.iss_cd||'-'||
                                LTRIM(TO_CHAR(f.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(f.clm_seq_no,'0999999'))) claim_no,
                                (f.line_cd||'-'||f.subline_cd||'-'||f.pol_iss_cd||'-'||LTRIM(TO_CHAR(f.issue_yy,'09'))||'-'||
                                LTRIM(TO_CHAR(f.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(f.renew_no,'09'))) policy_no,
                                f.dsp_loss_date, f.clm_file_date, f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                           FROM gicl_item_peril b, gicl_intm_itmperil c,
                                gicl_clm_res_hist a, giac_acctrans d, gicl_claims f
                          WHERE a.peril_cd   = b.peril_cd
                            AND a.item_no    = b.item_no
                            AND a.claim_id   = b.claim_id
                            AND b.claim_id   = c.claim_id 
                            AND a.item_no    = c.item_no 
                            AND b.peril_cd   = c.peril_cd  
                            AND a.tran_id    = d.tran_id
                            AND b.claim_id   = f.claim_id
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                            AND a.tran_id IS NOT NULL
                            AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                            AND DECODE(p_paid_date_option,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                                BETWEEN p_dsp_from_date AND p_dsp_to_date
                            AND d.tran_flag <> 'D' 
                            AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                            AND f.pol_iss_cd <> p_ri_iss_cd
                            AND f.clm_stat_cd NOT IN ('WD','DN','CC')
                            AND f.line_cd     = NVL(p_dsp_line_cd,f.line_cd)
                            AND f.subline_cd  = NVL(p_dsp_subline_cd,f.subline_cd)
                            AND DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd))
                          GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                                c.intm_no, c.shr_intm_pct, a.clm_loss_id,a.dist_no, NVL(a.convert_rate,1),
                                f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                                f.pol_seq_no, f.renew_no, f.loss_date, f.assd_no, f.clm_yy, f.clm_seq_no,
                                f.pol_iss_cd, f.dsp_loss_date, f.clm_file_date, f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                         UNION
                         SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, 
                                c.intm_no, c.shr_intm_pct,
                                (b.ann_tsi_amt*c.shr_intm_pct/100 * NVL(a.convert_rate, 1)) tsi_amt, 
                                DECODE(p_brdrx_option,1,-SUM(a.losses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100,
                                                      2,-SUM(a.expenses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100,NULL) claims_paid,
                                (-SUM(a.losses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100) losspaid, 
                                (-SUM(a.expenses_paid * NVL(a.convert_rate, 1))*c.shr_intm_pct/100) expensepaid,
                                a.clm_loss_id, a.dist_no,
                                f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                                f.pol_seq_no, f.renew_no, TO_NUMBER(TO_CHAR(f.loss_date,'YYYY')) loss_year,
                                f.assd_no,(f.line_cd||'-'||f.subline_cd||'-'||f.iss_cd||'-'||
                                LTRIM(TO_CHAR(f.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(f.clm_seq_no,'0999999'))) claim_no,
                                (f.line_cd||'-'||f.subline_cd||'-'||f.pol_iss_cd||'-'||LTRIM(TO_CHAR(f.issue_yy,'09'))||'-'||
                                LTRIM(TO_CHAR(f.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(f.renew_no,'09'))) policy_no,
                                f.dsp_loss_date, f.clm_file_date, f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                           FROM gicl_item_peril b, gicl_intm_itmperil c,
                                gicl_clm_res_hist a, giac_acctrans d, giac_reversals e, gicl_claims f
                          WHERE a.peril_cd   = b.peril_cd
                            AND a.item_no    = b.item_no
                            AND a.claim_id   = b.claim_id
                            AND b.claim_id   = c.claim_id 
                            AND a.item_no    = c.item_no 
                            AND b.peril_cd   = c.peril_cd   
                            AND a.tran_id    = e.gacc_tran_id
                            AND d.tran_id    = e.reversing_tran_id  
                            AND b.claim_id   = f.claim_id
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                            AND a.tran_id IS NOT NULL
                            AND TRUNC(a.date_paid) < p_dsp_from_date
                            AND TRUNC(d.posting_date) BETWEEN p_dsp_from_date AND p_dsp_to_date
                            AND c.intm_no = NVL(p_dsp_intm_no,c.intm_no)
                            AND f.pol_iss_cd <> p_ri_iss_cd
                            AND f.clm_stat_cd NOT IN ('WD','DN','CC')
                            AND f.line_cd     = NVL(p_dsp_line_cd,f.line_cd)
                            AND f.subline_cd  = NVL(p_dsp_subline_cd,f.subline_cd)
                            AND DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd))
                          GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, 
                                c.intm_no, c.shr_intm_pct, a.clm_loss_id,a.dist_no, NVL(a.convert_rate,1),
                                f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                                 f.pol_seq_no, f.renew_no, f.loss_date, f.assd_no, f.clm_yy, f.clm_seq_no,
                                f.pol_iss_cd, f.dsp_loss_date, f.clm_file_date, f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                          ORDER BY 1)
        LOOP
            v_intm_no := get_parent_intm_gicls202(paid_rec.intm_no);
            
            IF p_brdrx_option = 1 THEN
                v_losses_paid := paid_rec.claims_paid;
                v_expenses_paid := 0;
            ELSIF p_brdrx_option = 2 THEN  
                v_losses_paid := 0;
                v_expenses_paid := paid_rec.claims_paid;
            ELSIF p_brdrx_option = 3 THEN
                v_losses_paid := paid_rec.losspaid;
                v_expenses_paid := paid_rec.expensepaid;
            END IF;
             
            IF p_iss_break = 1 THEN
                v_iss_cd := paid_rec.iss_cd;
            ELSIF p_iss_break = 0 THEN
                v_iss_cd := 'DI';
            END IF;
            
            IF p_subline_break = 1 THEN
                v_subline_cd := paid_rec.subline_cd;
            ELSIF p_subline_break = 0 THEN
                v_subline_cd := '0';
            END IF;
                          
            v_brdrx_record_id := v_brdrx_record_id + 1;
            
            IF p_brdrx_option = 1 THEN -- loss
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,    brdrx_record_id, 
                            claim_id,      iss_cd,
                            buss_source,   line_cd,
                            subline_cd,    loss_year,
                            assd_no,       claim_no,
                            policy_no,     loss_date,
                            clm_file_date, item_no,
                            peril_cd,      loss_cat_cd,
                            incept_date,   expiry_date,
                            tsi_amt,       intm_no,       
                            clm_loss_id,   losses_paid,
                            dist_no,        user_id,
                            last_update,
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id) 
                     VALUES(p_session_id,           v_brdrx_record_id,
                            paid_rec.claim_id,      v_iss_cd,
                            v_intm_no,              paid_rec.line_cd,
                            v_subline_cd,           paid_rec.loss_year, 
                            paid_rec.assd_no,       paid_rec.claim_no,
                            paid_rec.policy_no,     paid_rec.dsp_loss_date, 
                            paid_rec.clm_file_date, paid_rec.item_no,
                            paid_rec.peril_cd,      paid_rec.loss_cat_cd,
                            paid_rec.pol_eff_date,  paid_rec.expiry_date, 
                            paid_rec.tsi_amt,       paid_rec.intm_no,
                            paid_rec.clm_loss_id,   v_losses_paid,
                            paid_rec.dist_no,         p_user_id, 
                            SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id);
            ELSIF p_brdrx_option = 2 THEN -- expense
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,    brdrx_record_id, 
                            claim_id,      iss_cd,
                            buss_source,   line_cd,
                            subline_cd,    loss_year,
                            assd_no,       claim_no,
                            policy_no,     loss_date,
                            clm_file_date, item_no,
                            peril_cd,      loss_cat_cd,
                            incept_date,   expiry_date,
                            tsi_amt,       intm_no,       
                            clm_loss_id,   expenses_paid,
                            dist_no,        user_id,
                            last_update,           
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id) 
                     VALUES(p_session_id,           v_brdrx_record_id,
                            paid_rec.claim_id,      v_iss_cd,
                            v_intm_no,              paid_rec.line_cd,
                            v_subline_cd,           paid_rec.loss_year, 
                            paid_rec.assd_no,       paid_rec.claim_no,
                            paid_rec.policy_no,     paid_rec.dsp_loss_date, 
                            paid_rec.clm_file_date, paid_rec.item_no,
                            paid_rec.peril_cd,      paid_rec.loss_cat_cd,
                            paid_rec.pol_eff_date,  paid_rec.expiry_date, 
                            paid_rec.tsi_amt,       paid_rec.intm_no,
                            paid_rec.clm_loss_id,   v_expenses_paid,
                            paid_rec.dist_no,         p_user_id, 
                            SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id);  
            ELSIF p_brdrx_option = 3 THEN -- loss+expense
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,    brdrx_record_id, 
                            claim_id,      iss_cd,
                            buss_source,   line_cd,
                            subline_cd,    loss_year,
                            assd_no,       claim_no,
                            policy_no,     loss_date,
                            clm_file_date, item_no,
                            peril_cd,      loss_cat_cd,
                            incept_date,   expiry_date,
                            tsi_amt,       intm_no,       
                            clm_loss_id,   
                            losses_paid,   expenses_paid,
                            dist_no,        user_id,
                            last_update,
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id) 
                     VALUES(p_session_id,           v_brdrx_record_id,
                            paid_rec.claim_id,      v_iss_cd,
                            v_intm_no,              paid_rec.line_cd,
                            v_subline_cd,           paid_rec.loss_year, 
                            paid_rec.assd_no,       paid_rec.claim_no,
                            paid_rec.policy_no,     paid_rec.dsp_loss_date, 
                            paid_rec.clm_file_date, paid_rec.item_no,
                            paid_rec.peril_cd,      paid_rec.loss_cat_cd,
                            paid_rec.pol_eff_date,  paid_rec.expiry_date, 
                            paid_rec.tsi_amt,       paid_rec.intm_no,
                            paid_rec.clm_loss_id,     
                            v_losses_paid,             v_expenses_paid,
                            paid_rec.dist_no,         p_user_id, 
                            SYSDATE,
                            p_rep_name,                    p_brdrx_type,
                            p_brdrx_date_option,        p_brdrx_option,
                            p_dsp_gross_tag,            p_paid_date_option,
                            p_per_buss,                    p_iss_break,
                            p_subline_break,            p_per_loss_cat,
                            p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,            p_reg_button,
                            p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id); 
            END IF;
        END LOOP;
        
        p_brdrx_record_id := v_brdrx_record_id;
    END epli_extract_direct;
    
    PROCEDURE epli_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                                  a.pol_seq_no, a.renew_no, TO_NUMBER(TO_CHAR(a.loss_date,'YYYY')) loss_year,
                                  a.assd_no,(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.dsp_loss_date, a.loss_date, a.clm_file_date, a.pol_eff_date, a.expiry_date, a.ri_cd 
                             FROM gicl_claims a
                            WHERE a.pol_iss_cd = p_ri_iss_cd
                              AND a.subline_cd = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND a.line_cd    = NVL(p_dsp_line_cd,a.line_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                            ORDER BY a.claim_id)
        LOOP
            FOR paid_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                    (b.ann_tsi_amt * NVL(a.convert_rate,1)) ann_tsi_amt,
                                    DECODE(p_brdrx_option,1,SUM(a.losses_paid) * NVL(a.convert_rate,1),
                                                          2,SUM(a.expenses_paid) * NVL(a.convert_rate,1),NULL) claims_paid,
                                    SUM(a.losses_paid) * NVL(a.convert_rate,1) losspaid, 
                                    SUM(a.expenses_paid) * NVL(a.convert_rate,1) expensepaid,
                                    a.clm_loss_id, a.dist_no,
                                    a.grouped_item_no, a.clm_res_hist_id                                       
                               FROM gicl_item_peril b, gicl_clm_res_hist a, 
                                    giac_acctrans d,
                                    gicl_claims c
                              WHERE a.peril_cd   = b.peril_cd
                                AND a.item_no    = b.item_no
                                AND a.claim_id   = b.claim_id
                                AND a.tran_id    = d.tran_id
                                AND b.claim_id   = claims_rec.claim_id
                                AND a.claim_id   = c.claim_id
                                AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                AND a.tran_id IS NOT NULL
                                AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1) > p_dsp_to_date
                                AND DECODE(p_paid_date_option,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                                    BETWEEN p_dsp_from_date AND p_dsp_to_date
                                AND d.tran_flag <> 'D'
                              GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, a.clm_loss_id, a.dist_no,
                                    NVL(a.convert_rate,1), a.grouped_item_no, a.clm_res_hist_id)
            LOOP
                BEGIN
                    IF p_subline_break = 1 THEN
                        v_subline_cd := claims_rec.subline_cd;
                    ELSIF p_subline_break = 0 THEN
                        v_subline_cd := '0';
                    END IF;
                     
                    v_brdrx_record_id := v_brdrx_record_id + 1;
                    
                    IF p_brdrx_option = 1 THEN -- loss
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       
                                    clm_loss_id,   losses_paid,
                                    dist_no,        user_id,
                                    last_update,
                                    extr_type,       brdrx_type,
                                    ol_date_opt,   brdrx_rep_type,
                                    res_tag,       pd_date_opt,
                                    intm_tag,       iss_cd_tag,
                                    line_cd_tag,   loss_cat_tag,
                                    from_date,       to_date,
                                    branch_opt,       reg_date_opt,
                                    net_rcvry_tag, rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id) 
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, paid_rec.item_no,
                                    paid_rec.peril_cd,        paid_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    paid_rec.ann_tsi_amt,     
                                    paid_rec.clm_loss_id,     paid_rec.claims_paid,
                                    paid_rec.dist_no,           p_user_id, 
                                    SYSDATE,
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            nvl(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id);  
                    ELSIF p_brdrx_option = 2 THEN -- expense
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       
                                    clm_loss_id,   expenses_paid,
                                    dist_no,        user_id,
                                    last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, paid_rec.item_no,
                                    paid_rec.peril_cd,        paid_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    paid_rec.ann_tsi_amt,     
                                    paid_rec.clm_loss_id,     paid_rec.claims_paid,
                                    paid_rec.dist_no,           p_user_id, 
                                    SYSDATE, 
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id);  
                    ELSIF p_brdrx_option = 3 THEN -- loss+expense
                        INSERT INTO gicl_res_brdrx_extr
                                   (session_id,    brdrx_record_id,
                                    claim_id,      iss_cd,
                                    buss_source,   line_cd,
                                    subline_cd,    loss_year,
                                    assd_no,       claim_no,
                                    policy_no,     loss_date,
                                    clm_file_date, item_no,
                                    peril_cd,      loss_cat_cd,
                                    incept_date,   expiry_date,
                                    tsi_amt,       
                                    clm_loss_id,   
                                    losses_paid,   expenses_paid,
                                    dist_no,       user_id,
                                    last_update,
                                    extr_type,         brdrx_type,
                                    ol_date_opt,     brdrx_rep_type,
                                    res_tag,         pd_date_opt,
                                    intm_tag,         iss_cd_tag,
                                    line_cd_tag,     loss_cat_tag,
                                    from_date,         to_date,
                                    branch_opt,         reg_date_opt,
                                    net_rcvry_tag,     rcvry_from_date,
                                    rcvry_to_date,
                                    grouped_item_no, clm_res_hist_id)
                             VALUES(p_session_id,             v_brdrx_record_id,
                                    claims_rec.claim_id,      claims_rec.iss_cd,
                                    claims_rec.ri_cd,         claims_rec.line_cd,
                                    v_subline_cd,             claims_rec.loss_year,
                                    claims_rec.assd_no,       claims_rec.claim_no,
                                    claims_rec.policy_no,     claims_rec.dsp_loss_date, 
                                    claims_rec.clm_file_date, paid_rec.item_no,
                                    paid_rec.peril_cd,        paid_rec.loss_cat_cd,
                                    claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                    paid_rec.ann_tsi_amt,     
                                    paid_rec.clm_loss_id,     
                                    paid_rec.losspaid,          paid_rec.expensepaid,
                                    paid_rec.dist_no,           p_user_id, 
                                    SYSDATE, 
                                    p_rep_name,                    p_brdrx_type,
                                    p_brdrx_date_option,        p_brdrx_option,
                                    p_dsp_gross_tag,            p_paid_date_option,
                                    p_per_buss,                    p_iss_break,
                                    p_subline_break,            p_per_loss_cat,
                                    p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                    p_branch_option,            p_reg_button,
                                    p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                    p_dsp_rcvry_to_date,
                                    paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id);  
                    END IF;
                END;
            END LOOP;
        END LOOP;
    END epli_extract_inward;
    
    PROCEDURE epli_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_option      IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_gross_tag     IN VARCHAR2,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR paid_ds_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id,
                                   a.grp_seq_no, a.shr_loss_exp_pct, d.intm_no,
                                   DECODE(get_payee_type(b.claim_id,b.clm_loss_id),'L',DECODE(p_brdrx_option,1,(SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1))*NVL(d.shr_intm_pct,100)/100),
                                                                                                             3,(SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1))*NVL(d.shr_intm_pct,100)/100),NULL),0) losses_paid,
                                   DECODE(get_payee_type(b.claim_id,b.clm_loss_id),'E',DECODE(p_brdrx_option,2,(SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1))*NVL(d.shr_intm_pct,100)/100),
                                                                                                             3,(SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1))*NVL(d.shr_intm_pct,100)/100),NULL),0) expenses_paid,
                                   a.clm_dist_no,
                                   c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd, c.subline_cd,
                                   c.loss_year, c.loss_cat_cd,
                                   c.losses_paid brdrx_extr_losses_paid, c.expenses_paid brdrx_extr_expenses_paid
                              FROM gicl_loss_exp_ds a, gicl_res_brdrx_extr c, gicl_intm_itmperil d, gicl_clm_res_hist b
                             WHERE c.session_id = p_session_id
                               AND a.claim_id             = c.claim_id
                               AND a.item_no              = c.item_no
                               AND a.peril_cd             = c.peril_cd
                               AND a.clm_dist_no          = c.dist_no
                               AND a.clm_loss_id          = c.clm_loss_id
                               AND a.claim_id             = b.claim_id
                               AND a.clm_loss_id          = b.clm_loss_id
                               AND NVL(d.intm_no,'000')   = NVL(c.intm_no,'000')
                               AND c.claim_id             = d.claim_id 
                               AND c.item_no              = d.item_no
                               AND c.peril_cd             = d.peril_cd
                               AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_dsp_from_date) AND TRUNC(p_dsp_to_date)
                                    OR b.cancel_date IS NULL)
                             GROUP BY a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id,
                                   a.grp_seq_no, a.shr_loss_exp_pct, d.intm_no, a.clm_dist_no,
                                   get_payee_type(b.claim_id,b.clm_loss_id),
                                   c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd, c.subline_cd,
                                   c.loss_year, c.loss_cat_cd,
                                   c.losses_paid, c.expenses_paid, d.shr_intm_pct)
        LOOP
            BEGIN  
                v_brdrx_ds_record_id  := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id, 
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            losses_paid,        expenses_paid, 
                            user_id,            last_update)
                     VALUES(p_session_id,           paid_ds_rec.brdrx_record_id, 
                            v_brdrx_ds_record_id,   paid_ds_rec.claim_id, 
                            paid_ds_rec.iss_cd,     paid_ds_rec.buss_source,
                            paid_ds_rec.line_cd,    paid_ds_rec.subline_cd,
                            paid_ds_rec.loss_year,  paid_ds_rec.item_no,
                            paid_ds_rec.peril_cd,   paid_ds_rec.loss_cat_cd, 
                            paid_ds_rec.grp_seq_no, paid_ds_rec.shr_loss_exp_pct,
                            paid_ds_rec.losses_paid,paid_ds_rec.expenses_paid, 
                            p_user_id,              SYSDATE);
            END;
            
            FOR paid_rids_rec IN (SELECT a.claim_id, a.ri_cd, a.prnt_ri_cd, g.intm_no, 
                                         a.shr_loss_exp_ri_pct shr_ri_pct_real,
                                         DECODE(p_brdrx_option,1,(SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100),
                                                               3,(SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100),NULL) losses_paid,
                                         DECODE(p_brdrx_option,2,(SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100),
                                                               3,(SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100),NULL) expenses_paid
                                    FROM gicl_clm_loss_exp c, gicl_loss_exp_ds b, gicl_loss_exp_rids a,
                                         gicl_clm_res_hist e, gicl_intm_itmperil g, gicl_claims f 
                                   WHERE c.claim_id             = b.claim_id
                                     AND c.clm_loss_id          = b.clm_loss_id
                                     AND c.claim_id             = e.claim_id
                                     AND c.item_no              = e.item_no
                                     AND c.peril_cd             = e.peril_cd  
                                     AND c.clm_loss_id          = e.clm_loss_id
                                     AND b.claim_id             = a.claim_id
                                     AND b.clm_loss_id          = a.clm_loss_id
                                     AND b.grp_seq_no           = a.grp_seq_no
                                     AND e.claim_id             = g.claim_id (+)
                                     AND e.item_no              = g.item_no (+)
                                     AND e.peril_cd             = g.peril_cd (+)
                                     AND a.claim_id             = paid_ds_rec.claim_id
                                     AND a.item_no              = paid_ds_rec.item_no
                                     AND a.peril_cd             = paid_ds_rec.peril_cd     
                                     AND a.clm_loss_id          = paid_ds_rec.clm_loss_id
                                     AND a.clm_dist_no          = paid_ds_rec.clm_dist_no    
                                     AND a.grp_seq_no           = paid_ds_rec.grp_seq_no
                                     AND NVL(g.intm_no,'000')   = NVL(paid_ds_rec.intm_no,'000') 
                                     AND b.clm_dist_no = e.dist_no
                                     AND e.tran_id IS NOT NULL
                                     AND get_payee_type(e.claim_id, e.clm_loss_id) = DECODE(p_brdrx_option,1,'L',2,'E') 
                                     AND a.claim_id = f.claim_id
                                     AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                                     AND (TRUNC(e.cancel_date) NOT BETWEEN TRUNC(p_dsp_from_date) AND TRUNC(p_dsp_to_date)
                                          OR e.cancel_date IS NULL)
                                   GROUP BY a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct, 
                                            g.intm_no, g.shr_intm_pct
                                  UNION
                                  SELECT a.claim_id, a.ri_cd, a.prnt_ri_cd, g.intm_no, 
                                         a.shr_loss_exp_ri_pct shr_ri_pct_real,
                                         DECODE(p_brdrx_option,1,-((SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100)),
                                                               3,-((SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100)),NULL) losses_paid,
                                         DECODE(p_brdrx_option,2,-((SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100)),
                                                               3,-((SUM(a.shr_le_ri_net_amt* NVL(e.convert_rate, 1))*g.shr_intm_pct/100)),NULL) expenses_paid
                                    FROM gicl_clm_loss_exp c, gicl_loss_exp_ds b, gicl_loss_exp_rids a,
                                         gicl_clm_res_hist e, gicl_intm_itmperil g, giac_acctrans d, giac_reversals f, gicl_claims h
                                   WHERE c.claim_id             = b.claim_id
                                     AND c.clm_loss_id          = b.clm_loss_id
                                     AND c.claim_id             = e.claim_id
                                     AND c.item_no              = e.item_no
                                     AND c.peril_cd             = e.peril_cd  
                                     AND c.clm_loss_id          = e.clm_loss_id     
                                     AND b.claim_id             = a.claim_id
                                     AND b.clm_loss_id          = a.clm_loss_id
                                     AND b.clm_dist_no          = a.clm_dist_no
                                     AND b.grp_seq_no           = a.grp_seq_no
                                     AND e.claim_id             = g.claim_id (+)
                                     AND e.item_no              = g.item_no (+)
                                     AND e.peril_cd             = g.peril_cd (+)   
                                     AND a.claim_id             = paid_ds_rec.claim_id
                                     AND a.clm_loss_id          = paid_ds_rec.clm_loss_id
                                     AND a.clm_dist_no          = paid_ds_rec.clm_dist_no    
                                     AND a.grp_seq_no           = paid_ds_rec.grp_seq_no
                                     AND NVL(g.intm_no,'000')   = NVL(paid_ds_rec.intm_no,'000') 
                                     AND b.clm_dist_no = e.dist_no
                                     AND e.tran_id IS NOT NULL
                                     AND e.tran_id              = f.gacc_tran_id 
                                     AND d.tran_id              = f.reversing_tran_id 
                                     AND TRUNC(e.date_paid) < p_dsp_from_date
                                     AND TRUNC(d.posting_date) BETWEEN p_dsp_from_date AND p_dsp_to_date
                                     AND get_payee_type(e.claim_id, e.clm_loss_id) = DECODE(p_brdrx_option,1,'L',2,'E')
                                     AND a.claim_id = h.claim_id
                                     AND check_user_per_iss_cd (h.line_cd, h.iss_cd, 'GICLS202') = 1
                                     AND (TRUNC(e.cancel_date) NOT BETWEEN TRUNC(p_dsp_from_date) AND TRUNC(p_dsp_to_date)
                                          OR e.cancel_date IS NULL)
                                   GROUP BY a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct,
                                            g.intm_no, g.shr_intm_pct)
            LOOP
                BEGIN
                
                    v_brdrx_rids_record_id  := v_brdrx_rids_record_id + 1;
                
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id, 
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                losses_paid,          expenses_paid, 
                                user_id,              last_update)
                         VALUES(p_session_id,               v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,     paid_ds_rec.claim_id,
                                paid_ds_rec.iss_cd,         paid_ds_rec.buss_source,
                                paid_ds_rec.line_cd,        paid_ds_rec.subline_cd,
                                paid_ds_rec.loss_year,      paid_ds_rec.item_no,
                                paid_ds_rec.peril_cd,       paid_ds_rec.loss_cat_cd, 
                                paid_ds_rec.grp_seq_no,     paid_rids_rec.ri_cd,
                                paid_rids_rec.prnt_ri_cd,   paid_rids_rec.shr_ri_pct_real,
                                paid_rids_rec.losses_paid,  paid_rids_rec.expenses_paid, 
                                p_user_id,                  SYSDATE);
                END;
            END LOOP;
        END LOOP; 
    END epli_extract_distribution;
    /*epli = EXTRACT_PAID_LE_INTM end*/
    
    /*epl = EXTRACT_PAID_LE start*/
    PROCEDURE epl_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN OUT NUMBER
    ) IS
        v_source                    gicl_res_brdrx_extr.buss_source%TYPE;
        v_iss_cd                    giis_issource.iss_cd%TYPE;
        v_subline_cd                giis_subline.subline_cd%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        v_source := 0;
        
        FOR paid_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                (b.ann_tsi_amt * NVL(a.convert_rate,1) ) ann_tsi_amt,
                                DECODE(p_brdrx_option,1,SUM(a.losses_paid) * NVL(a.convert_rate,1),2,SUM(a.expenses_paid) * NVL(a.convert_rate,1) , NULL) claims_paid,
                                SUM(a.losses_paid) * NVL(a.convert_rate,1)  losspaid,
                                SUM(a.expenses_paid) * NVL(a.convert_rate,1)  expensepaid,
                                a.clm_loss_id, a.dist_no,
                                f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy, f.pol_seq_no,
                                f.renew_no, TO_NUMBER(TO_CHAR(f.loss_date,'YYYY')) loss_year,
                                f.assd_no,
                                (f.line_cd || '-'  || f.subline_cd  || '-'  || f.iss_cd  || '-'  || 
                                LTRIM(TO_CHAR(f.clm_yy,'09'))  || '-'  || LTRIM(TO_CHAR(f.clm_seq_no,
                                '0999999')) ) claim_no,(f.line_cd || '-'  || f.subline_cd  || '-'  || 
                                f.pol_iss_cd  || '-'  || LTRIM(TO_CHAR(f.issue_yy,'09'))  || '-'  || 
                                LTRIM(TO_CHAR(f.pol_seq_no,'0999999'))  || '-'  || LTRIM(TO_CHAR(f.renew_no,
                                '09')) ) policy_no,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                           FROM gicl_item_peril b, gicl_clm_res_hist a, giac_acctrans d, gicl_claims f
                          WHERE a.peril_cd = b.peril_cd  
                            AND a.item_no = b.item_no  
                            AND a.claim_id = b.claim_id  
                            AND a.tran_id = d.tran_id  
                            AND b.claim_id = f.claim_id  
                            AND a.tran_id IS NOT NULL   
                            AND DECODE(a.cancel_tag,'Y',TRUNC(a.cancel_date),p_dsp_to_date + 1 ) > p_dsp_to_date  
                            AND DECODE(p_paid_date_option,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date  
                            AND d.tran_flag != 'D'  
                            AND EXISTS (SELECT 'X' FROM gicl_claims g
                                         WHERE g.claim_id = f.claim_id
                                           AND f.line_cd = NVL(p_dsp_line_cd,f.line_cd)  
                                           AND f.subline_cd = NVL(p_dsp_subline_cd,f.subline_cd)  
                                           AND DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd)))
                            AND clm_stat_cd NOT IN ('WD','DN','CC')
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                          GROUP BY b.claim_id, b.item_no, b.peril_cd,
                                b.loss_cat_cd, b.ann_tsi_amt, a.clm_loss_id, a.dist_no, NVL(a.convert_rate,1),
                                f.claim_id, f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy, f.pol_seq_no,
                                f.renew_no, f.loss_date, f.assd_no, f.clm_yy, f.clm_seq_no, f.pol_iss_cd,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                         UNION
                         SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                (b.ann_tsi_amt * NVL(a.convert_rate,1) ) ann_tsi_amt,
                                DECODE(p_brdrx_option,1,- (SUM(a.losses_paid) * NVL(a.convert_rate,1) ) ,2,- (SUM(a.expenses_paid) * NVL(a.convert_rate,1) ), NULL) claims_paid,
                                - SUM(a.losses_paid)  * NVL(a.convert_rate,1) losspaid,
                                - SUM(a.expenses_paid)  * NVL(a.convert_rate,1)  expensepaid,
                                a.clm_loss_id, a.dist_no,
                                f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy, f.pol_seq_no,
                                f.renew_no, TO_NUMBER(TO_CHAR(f.loss_date,'YYYY')) loss_year,
                                f.assd_no,
                                (f.line_cd || '-'  || f.subline_cd  || '-'  || f.iss_cd  || '-'  || 
                                LTRIM(TO_CHAR(f.clm_yy,'09'))  || '-'  || LTRIM(TO_CHAR(f.clm_seq_no,
                                '0999999')) ) claim_no,(f.line_cd || '-'  || f.subline_cd  || '-'  || 
                                f.pol_iss_cd  || '-'  || LTRIM(TO_CHAR(f.issue_yy,'09'))  || '-'  || 
                                LTRIM(TO_CHAR(f.pol_seq_no,'0999999'))  || '-'  || LTRIM(TO_CHAR(f.renew_no,
                                '09')) ) policy_no,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id 
                           FROM gicl_item_peril b, gicl_clm_res_hist a, giac_acctrans d, giac_reversals e, gicl_claims f
                          WHERE a.peril_cd = b.peril_cd  
                            AND a.item_no = b.item_no  
                            AND a.claim_id = b.claim_id  
                            AND a.tran_id = e.gacc_tran_id  
                            AND d.tran_id = e.reversing_tran_id  
                            AND b.claim_id = f.claim_id 
                            AND a.tran_id IS NOT NULL   
                            AND TRUNC(a.date_paid) < p_dsp_from_date  
                            AND TRUNC(d.posting_date) BETWEEN p_dsp_from_date AND p_dsp_to_date
                            AND EXISTS (SELECT 'X' FROM gicl_claims g
                                         WHERE g.claim_id = f.claim_id
                                           AND f.line_cd = NVL(p_dsp_line_cd,f.line_cd)  
                                           AND f.subline_cd = NVL(p_dsp_subline_cd,f.subline_cd)  
                                           AND DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,f.iss_cd,2,f.pol_iss_cd)))
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1                                  
                            AND clm_stat_cd NOT IN ('WD','DN','CC')
                          GROUP BY b.claim_id, b.item_no,
                                b.peril_cd, b.loss_cat_cd, b.ann_tsi_amt, a.clm_loss_id, a.dist_no,
                                NVL(a.convert_rate,1),
                                f.claim_id, f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy, f.pol_seq_no,
                                f.renew_no, f.loss_date, f.assd_no, f.clm_yy, f.clm_seq_no, f.pol_iss_cd,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date,
                                a.grouped_item_no, a.clm_res_hist_id
                          ORDER BY 1)
        LOOP
            BEGIN
                IF p_iss_break = 1 THEN
                    v_iss_cd := paid_rec.iss_cd;
                ELSIF p_iss_break = 0 THEN
                    v_iss_cd := '0';
                END IF;
          
                IF p_subline_break = 1 THEN
                    v_subline_cd := paid_rec.subline_cd;
                ELSIF p_subline_break = 0 THEN
                    v_subline_cd := '0';
                END IF;              
                
                v_brdrx_record_id := v_brdrx_record_id + 1;
          
                IF p_brdrx_option = 1 THEN -- loss
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id, 
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no, 
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       
                                clm_loss_id,   losses_paid,
                                dist_no,        user_id,
                                last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)         
                         VALUES(p_session_id,           v_brdrx_record_id,
                                paid_rec.claim_id,      v_iss_cd,
                                v_source,               paid_rec.line_cd,
                                v_subline_cd,           paid_rec.loss_year,
                                paid_rec.assd_no,       paid_rec.claim_no,
                                paid_rec.policy_no,     paid_rec.dsp_loss_date,
                                paid_rec.clm_file_date, paid_rec.item_no,
                                paid_rec.peril_cd,      paid_rec.loss_cat_cd,
                                paid_rec.pol_eff_date,  paid_rec.expiry_date,
                                paid_rec.ann_tsi_amt,   
                                paid_rec.clm_loss_id,   paid_rec.claims_paid,
                                paid_rec.dist_no,         p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id); 
                ELSIF p_brdrx_option = 2 THEN -- expense
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id, 
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no, 
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       
                                clm_loss_id,   expenses_paid,
                                dist_no,        user_id,
                                last_update,                                                 
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)    
                         VALUES(p_session_id,           v_brdrx_record_id,
                                paid_rec.claim_id,      v_iss_cd,
                                v_source,               paid_rec.line_cd,
                                v_subline_cd,           paid_rec.loss_year,
                                paid_rec.assd_no,       paid_rec.claim_no,
                                paid_rec.policy_no,     paid_rec.dsp_loss_date,
                                paid_rec.clm_file_date, paid_rec.item_no,
                                paid_rec.peril_cd,      paid_rec.loss_cat_cd,
                                paid_rec.pol_eff_date,  paid_rec.expiry_date,
                                paid_rec.ann_tsi_amt,   
                                paid_rec.clm_loss_id,   paid_rec.claims_paid,
                                paid_rec.dist_no,         p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id); 
                ELSIF p_brdrx_option = 3 THEN -- loss+expense
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,    brdrx_record_id, 
                                claim_id,      iss_cd,
                                buss_source,   line_cd,
                                subline_cd,    loss_year,
                                assd_no,       claim_no,
                                policy_no,     loss_date,
                                clm_file_date, item_no, 
                                peril_cd,      loss_cat_cd,
                                incept_date,   expiry_date,
                                tsi_amt,       
                                clm_loss_id,   
                                losses_paid,   expenses_paid,
                                dist_no,        user_id,
                                last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)    
                         VALUES(p_session_id,           v_brdrx_record_id,
                                paid_rec.claim_id,      v_iss_cd,
                                v_source,               paid_rec.line_cd,
                                v_subline_cd,           paid_rec.loss_year,
                                paid_rec.assd_no,       paid_rec.claim_no,
                                paid_rec.policy_no,     paid_rec.dsp_loss_date,
                                paid_rec.clm_file_date, paid_rec.item_no,
                                paid_rec.peril_cd,      paid_rec.loss_cat_cd,
                                paid_rec.pol_eff_date,  paid_rec.expiry_date,
                                paid_rec.ann_tsi_amt,   
                                paid_rec.clm_loss_id,     
                                paid_rec.losspaid,        paid_rec.expensepaid,
                                paid_rec.dist_no,         p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                paid_rec.grouped_item_no,   paid_rec.clm_res_hist_id);
                END IF;
            END;
        END LOOP;
    END epl_extract_all;
    
    PROCEDURE epl_extract_distribution(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_option      IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR paid_ds_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id,
                                   a.grp_seq_no, a.shr_loss_exp_pct,
                                   DECODE(get_payee_type(b.claim_id, b.clm_loss_id),'L',DECODE(p_brdrx_option,1,SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1)),
                                                                                                              3,SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1)),NULL),0) losses_paid,
                                   DECODE(get_payee_type(b.claim_id, b.clm_loss_id),'E',DECODE(p_brdrx_option,2,SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1)),
                                                                                                              3,SUM(a.shr_le_net_amt * NVL(b.convert_rate, 1)),NULL),0) expenses_paid,
                                   a.clm_dist_no, c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd, c.subline_cd, c.loss_year, c.loss_cat_cd,
                                   c.losses_paid brdrx_extr_losses_paid, c.expenses_paid brdrx_extr_expenses_paid
                              FROM gicl_loss_exp_ds a, gicl_res_brdrx_extr c, gicl_clm_res_hist b
                             WHERE c.session_id           = p_session_id
                               AND a.claim_id             = c.claim_id
                               AND a.item_no              = c.item_no
                               AND a.peril_cd             = c.peril_cd
                               AND a.clm_dist_no          = c.dist_no
                               AND a.clm_loss_id          = c.clm_loss_id
                               AND a.claim_id             = b.claim_id
                               AND a.clm_loss_id          = b.clm_loss_id
                               AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_dsp_from_date) AND TRUNC(p_dsp_to_date)
                                     OR b.cancel_date IS NULL)
                             GROUP BY a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id,
                                   a.grp_seq_no, a.shr_loss_exp_pct,a.clm_dist_no,
                                   get_payee_type(b.claim_id, b.clm_loss_id),
                                   c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd, c.subline_cd,
                                   c.loss_year, c.loss_cat_cd,
                                   c.losses_paid, c.expenses_paid)
        LOOP
            BEGIN  
                IF SIGN(NVL(paid_ds_rec.brdrx_extr_losses_paid,0)) <> 1 AND SIGN(NVL(paid_ds_rec.losses_paid,0)) = 1 THEN
                     paid_ds_rec.losses_paid := -paid_ds_rec.losses_paid;
                END IF;
          
                IF SIGN(NVL(paid_ds_rec.brdrx_extr_expenses_paid,0)) <> 1 AND SIGN(NVL(paid_ds_rec.expenses_paid,0)) = 1 THEN
                     paid_ds_rec.expenses_paid := -paid_ds_rec.expenses_paid;
                 END IF;
            
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id,         brdrx_record_id, 
                            brdrx_ds_record_id, claim_id,
                            iss_cd,             buss_source,
                            line_cd,            subline_cd,
                            loss_year,          item_no,
                            peril_cd,           loss_cat_cd,
                            grp_seq_no,         shr_pct,
                            losses_paid,        expenses_paid, 
                            user_id,            last_update)
                     VALUES(p_session_id,                paid_ds_rec.brdrx_record_id, 
                            v_brdrx_ds_record_id,        paid_ds_rec.claim_id, 
                            paid_ds_rec.iss_cd,          paid_ds_rec.buss_source,
                            paid_ds_rec.line_cd,         paid_ds_rec.subline_cd,
                            paid_ds_rec.loss_year,       paid_ds_rec.item_no,
                            paid_ds_rec.peril_cd,        paid_ds_rec.loss_cat_cd, 
                            paid_ds_rec.grp_seq_no,      paid_ds_rec.shr_loss_exp_pct,   
                            paid_ds_rec.losses_paid,     paid_ds_rec.expenses_paid, 
                            p_user_id,                   SYSDATE);
            END;
            
            FOR paid_rids_rec IN (SELECT a.claim_id, a.ri_cd, a.prnt_ri_cd,
                                         a.shr_loss_exp_ri_pct shr_ri_pct_real,
                                         DECODE(p_brdrx_option,1,SUM(a.shr_le_ri_net_amt* NVL(b.convert_rate, 1)),
                                                               3,SUM(a.shr_le_ri_net_amt* NVL(b.convert_rate, 1)), NULL) losses_paid,
                                         DECODE(p_brdrx_option,2,SUM(a.shr_le_ri_net_amt* NVL(b.convert_rate, 1)),
                                                               3,SUM(a.shr_le_ri_net_amt* NVL(b.convert_rate, 1)),NULL) expenses_paid
                                    FROM gicl_loss_exp_rids a, gicl_clm_res_hist b, gicl_claims c
                                   WHERE a.claim_id             = paid_ds_rec.claim_id
                                     AND a.item_no              = paid_ds_rec.item_no
                                     AND a.peril_cd             = paid_ds_rec.peril_cd
                                     AND a.clm_loss_id          = paid_ds_rec.clm_loss_id 
                                     AND a.clm_dist_no          = paid_ds_rec.clm_dist_no
                                     AND a.grp_seq_no           = paid_ds_rec.grp_seq_no         
                                     AND a.claim_id                = b.claim_id
                                     AND a.clm_loss_id = b.clm_loss_id
                                     AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                     AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_dsp_from_date) AND TRUNC(p_dsp_to_date)
                                          OR b.cancel_date IS NULL)
                                   GROUP BY a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct)
            LOOP
                BEGIN
                    IF SIGN(NVL(paid_ds_rec.losses_paid,0)) <> 1 AND SIGN(NVL(paid_rids_rec.losses_paid,0)) = 1 THEN
                         paid_rids_rec.losses_paid:= -paid_rids_rec.losses_paid;
                    END IF;
                    
                    IF SIGN(NVL(paid_ds_rec.expenses_paid,0)) <> 1 AND SIGN(NVL(paid_rids_rec.expenses_paid,0)) = 1 THEN
                         paid_rids_rec.expenses_paid := -paid_rids_rec.expenses_paid;
                    END IF;      
            
                    v_brdrx_rids_record_id  := v_brdrx_rids_record_id + 1;
            
                    INSERT INTO gicl_res_brdrx_rids_extr 
                               (session_id,           brdrx_ds_record_id, 
                                brdrx_rids_record_id, claim_id,
                                iss_cd,               buss_source,
                                line_cd,              subline_cd,
                                loss_year,            item_no,
                                peril_cd,             loss_cat_cd,
                                grp_seq_no,           ri_cd,
                                prnt_ri_cd,           shr_ri_pct,
                                losses_paid,          expenses_paid, 
                                user_id,              last_update)
                         VALUES(p_session_id,                   v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id,         paid_ds_rec.claim_id,
                                paid_ds_rec.iss_cd,             paid_ds_rec.buss_source,
                                paid_ds_rec.line_cd,            paid_ds_rec.subline_cd, 
                                paid_ds_rec.loss_year,          paid_ds_rec.item_no,
                                paid_ds_rec.peril_cd,           paid_ds_rec.loss_cat_cd, 
                                paid_ds_rec.grp_seq_no,         paid_rids_rec.ri_cd,
                                paid_rids_rec.prnt_ri_cd,       paid_rids_rec.shr_ri_pct_real,
                                paid_rids_rec.losses_paid,      paid_rids_rec.expenses_paid, 
                                p_user_id,                      SYSDATE);
                END;  
            END LOOP;
        END LOOP;
    END epl_extract_distribution;
    /*epl = EXTRACT_PAID_LE end*/
    
    PROCEDURE extract_brdrx_rcvry(
        p_session_id                IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_dsp_rcvry_from_date       IN DATE,
        p_dsp_rcvry_to_date         IN DATE,
        p_rcvry_brdrx_rec_id        IN gicl_rcvry_brdrx_extr.rcvry_brdrx_record_id%TYPE,
        p_rcvry_brdrx_ds_rec_id     IN gicl_rcvry_brdrx_ds_extr.rcvry_brdrx_ds_record_id%TYPE,
        p_rcvry_brdrx_rids_rec_id   IN gicl_rcvry_brdrx_rids_extr.rcvry_brdrx_rids_record_id%TYPE
    ) IS
        v_rcvry_brdrx_rec_id       gicl_rcvry_brdrx_extr.rcvry_brdrx_record_id%TYPE;
        v_rcvry_brdrx_ds_rec_id    gicl_rcvry_brdrx_ds_extr.rcvry_brdrx_ds_record_id%TYPE;
        v_rcvry_brdrx_rids_rec_id  gicl_rcvry_brdrx_rids_extr.rcvry_brdrx_rids_record_id%TYPE;
        v_shr_rcvry_amt_ds         gicl_recovery_ds.shr_recovery_amt%TYPE;
        v_shr_rcvry_amt_rids       gicl_recovery_rids.shr_ri_recovery_amt%TYPE;
    BEGIN
        v_rcvry_brdrx_rec_id := p_rcvry_brdrx_rec_id;
        v_rcvry_brdrx_ds_rec_id := p_rcvry_brdrx_ds_rec_id;
        v_rcvry_brdrx_rids_rec_id := p_rcvry_brdrx_rids_rec_id;
    
        FOR rcvry IN (SELECT a.claim_id, a.line_cd, d.subline_cd, a.iss_cd, b.recovery_id, b.recovery_payt_id, 
                             SUM(NVL(b.recovered_amt,0) * (NVL(c.recoverable_amt,0) / get_rec_amt(c.recovery_id))) recovered_amt, 
                             c.item_no, c.peril_cd, b.tran_date, b.acct_tran_id, e.payee_type
                        FROM gicl_clm_recovery a, gicl_recovery_payt b, gicl_clm_recovery_dtl c, gicl_claims d, gicl_clm_loss_exp e
                       WHERE NVL(b.cancel_tag, 'N') = 'N' 
                         AND a.claim_id = b.claim_id 
                         AND b.claim_id = c.claim_id 
                         AND a.recovery_id = b.recovery_id 
                         AND b.recovery_id = c.recovery_id 
                         AND b.claim_id IN (SELECT claim_id 
                                              FROM gicl_res_brdrx_extr)
                         AND b.claim_id = d.claim_id 
                         AND TRUNC(b.tran_date) BETWEEN p_dsp_rcvry_from_date AND p_dsp_rcvry_to_date
                         AND c.claim_id = e.claim_id
                         AND c.clm_loss_id = e.clm_loss_id
                         AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
                       GROUP BY b.recovery_id, b.recovery_payt_id, a.claim_id, 
                             a.line_cd, d.subline_cd, a. iss_cd, 
                             c.item_no, c.peril_cd, b.tran_date,
                             b.acct_tran_id, e.payee_type)
        LOOP
            v_rcvry_brdrx_rec_id := NVL(v_rcvry_brdrx_rec_id, 0) + 1;
    
            INSERT INTO gicl_rcvry_brdrx_extr (session_id, rcvry_brdrx_record_id, claim_id,
                                               recovery_id, recovery_payt_id, line_cd,
                                               subline_cd, iss_cd, rcvry_pd_date, item_no,
                                               peril_cd, recovered_amt, acct_tran_id, payee_type)
                                       VALUES (p_session_id, v_rcvry_brdrx_rec_id, rcvry.claim_id,
                                               rcvry.recovery_id, rcvry.recovery_payt_id, rcvry.line_cd,
                                               rcvry.subline_cd, rcvry.iss_cd, rcvry.tran_date, rcvry.item_no,
                                               rcvry.peril_cd, rcvry.recovered_amt, rcvry.acct_tran_id, rcvry.payee_type);
        END LOOP;
        
        BEGIN
            SELECT MAX(rcvry_brdrx_ds_record_id)
              INTO v_rcvry_brdrx_ds_rec_id
              FROM gicl_rcvry_brdrx_ds_extr;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rcvry_brdrx_ds_rec_id := 0;
        END;
        
        FOR rcvry_ds1_a IN (SELECT a.rcvry_brdrx_record_id, a.claim_id,
                                   a.recovery_id, a.recovery_payt_id, a.line_cd,
                                   a.subline_cd, a.iss_cd, a.item_no,
                                   a.peril_cd, a.recovered_amt, a.acct_tran_id, a.payee_type
                              FROM gicl_rcvry_brdrx_extr a
                             WHERE a.session_id = p_session_id
                               AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1 --Edison 05.18.2012
                               AND a.recovery_id IN (SELECT b.recovery_id
                                                       FROM gicl_recovery_ds b
                                                      WHERE b.recovery_id = a.recovery_id  
                                                        AND b.recovery_payt_id= a.recovery_payt_id
                                                        AND NVL(b.negate_tag, 'N') = 'N'))
        LOOP
            FOR rcvry_ds1_b IN (SELECT a.rec_dist_no, a.dist_year, a.grp_seq_no, a.share_type, a.share_pct
                                  FROM gicl_recovery_ds a, gicl_clm_recovery b, gicl_claims c
                                 WHERE a.recovery_id = rcvry_ds1_a.recovery_id
                                   AND a.recovery_payt_id = rcvry_ds1_a.recovery_payt_id
                                   AND b.recovery_id = a.recovery_id                              
                                   AND b.claim_id = c.claim_id                                    
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND NVL(a.negate_tag, 'N') = 'N')
            LOOP
                v_rcvry_brdrx_ds_rec_id := NVL(v_rcvry_brdrx_ds_rec_id, 0) + 1;
                v_shr_rcvry_amt_ds      := (rcvry_ds1_b.share_pct * NVL(rcvry_ds1_a.recovered_amt, 0))/100;
      
                INSERT INTO gicl_rcvry_brdrx_ds_extr (session_id, rcvry_brdrx_record_id, rcvry_brdrx_ds_record_id,
                                                      claim_id, recovery_id, recovery_payt_id,
                                                      line_cd, subline_cd, iss_cd,
                                                      item_no, peril_cd, recovered_amt,
                                                      rec_dist_no, dist_year, grp_seq_no,
                                                      share_type, share_pct, shr_recovery_amt,
                                                      acct_tran_id, payee_type)
                                              VALUES (p_session_id, rcvry_ds1_a.rcvry_brdrx_record_id, v_rcvry_brdrx_ds_rec_id,
                                                      rcvry_ds1_a.claim_id, rcvry_ds1_a.recovery_id, rcvry_ds1_a.recovery_payt_id,
                                                      rcvry_ds1_a.line_cd, rcvry_ds1_a.subline_cd, rcvry_ds1_a.iss_cd,
                                                      rcvry_ds1_a.item_no, rcvry_ds1_a.peril_cd, rcvry_ds1_a.recovered_amt,
                                                      rcvry_ds1_b.rec_dist_no, rcvry_ds1_b.dist_year, rcvry_ds1_b.grp_seq_no,
                                                      rcvry_ds1_b.share_type, rcvry_ds1_b.share_pct, v_shr_rcvry_amt_ds,
                                                      rcvry_ds1_a.acct_tran_id, rcvry_ds1_a.payee_type);
            END LOOP;
        END LOOP;
        
        FOR rcvry_rids_a IN (SELECT a.rcvry_brdrx_ds_record_id, a.claim_id,
                                    a.recovery_id, a.recovery_payt_id, a.line_cd,
                                    a.subline_cd, a.iss_cd, a.item_no,
                                    a.peril_cd, a.rec_dist_no, a.dist_year,
                                    a.grp_seq_no, a.share_type, a.acct_tran_id,
                                    a.shr_recovery_amt, a.share_pct, a.payee_type
                               FROM gicl_rcvry_brdrx_ds_extr a
                              WHERE a.session_id = p_session_id
                                AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                AND a.recovery_id IN (SELECT b.recovery_id
                                                        FROM gicl_recovery_rids b
                                                       WHERE b.recovery_id = a.recovery_id
                                                         AND b.recovery_payt_id = a.recovery_payt_id
                                                         AND b.line_cd = a.line_cd
                                                         AND b.grp_seq_no = a.grp_seq_no
                                                         AND NVL(b.negate_tag, 'N') = 'N'))
        LOOP
            FOR rcvry_rids_b IN (SELECT a.share_type, a.ri_cd, a.share_ri_pct
                                   FROM gicl_recovery_rids a, gicl_clm_recovery b, gicl_claims c  
                                    WHERE a.recovery_id = rcvry_rids_a.recovery_id
                                    AND a.recovery_payt_id = rcvry_rids_a.recovery_payt_id
                                    AND a.line_cd = rcvry_rids_a.line_cd
                                    AND a.grp_seq_no = rcvry_rids_a.grp_seq_no
                                    AND NVL(a.negate_tag, 'N') = 'N'
                                    AND a.recovery_id = b.recovery_id
                                    AND b.claim_id = c.claim_id
                                    AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1)                    
            LOOP
                v_rcvry_brdrx_rids_rec_id := NVL(v_rcvry_brdrx_rids_rec_id, 0) + 1;
                v_shr_rcvry_amt_rids      := (rcvry_rids_b.share_ri_pct/rcvry_rids_a.share_pct) * NVL(rcvry_rids_a.shr_recovery_amt, 0);

                INSERT INTO gicl_rcvry_brdrx_rids_extr (session_id, rcvry_brdrx_ds_record_id, rcvry_brdrx_rids_record_id,
                                                        claim_id, recovery_id, recovery_payt_id,
                                                        line_cd, subline_cd, iss_cd,
                                                        item_no, peril_cd, rec_dist_no,
                                                        dist_year, grp_seq_no, share_type,
                                                        ri_cd, share_ri_pct, shr_ri_recovery_amt,
                                                        acct_tran_id, payee_type)
                                                VALUES (p_session_id, rcvry_rids_a.rcvry_brdrx_ds_record_id, v_rcvry_brdrx_rids_rec_id,
                                                        rcvry_rids_a.claim_id, rcvry_rids_a.recovery_id, rcvry_rids_a.recovery_payt_id,
                                                        rcvry_rids_a.line_cd, rcvry_rids_a.subline_cd, rcvry_rids_a.iss_cd,
                                                        rcvry_rids_a.item_no, rcvry_rids_a.peril_cd, rcvry_rids_a.rec_dist_no,
                                                        rcvry_rids_a.dist_year, rcvry_rids_a.grp_seq_no, rcvry_rids_b.share_type,
                                                        rcvry_rids_b.ri_cd, rcvry_rids_b.share_ri_pct, v_shr_rcvry_amt_rids,
                                                        rcvry_rids_a.acct_tran_id, rcvry_rids_a.payee_type);
            END LOOP;
        END LOOP;
        
        BEGIN
            SELECT MAX(rcvry_brdrx_ds_record_id)
              INTO v_rcvry_brdrx_ds_rec_id
              FROM gicl_rcvry_brdrx_ds_extr;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rcvry_brdrx_ds_rec_id := 0;
        END;
        
        FOR rcvry_ds2 IN (SELECT rcvry_brdrx_record_id, claim_id,
                                 recovery_id, recovery_payt_id, line_cd,
                                 subline_cd, iss_cd, item_no,
                                 peril_cd, recovered_amt, NULL rec_dist_no, 
                                 TO_NUMBER(TO_CHAR(rcvry_pd_date, 'RRRR')) dist_year, giisp.n('NET_RETENTION') grp_seq_no,
                                 '1' share_type, 100 share_pct, recovered_amt shr_recovery_amt,
                                 acct_tran_id, payee_type
                            FROM gicl_rcvry_brdrx_extr
                           WHERE claim_id NOT IN (SELECT claim_id
                                                    FROM gicl_rcvry_brdrx_ds_extr)
                             AND session_id = p_session_id
                             AND check_user_per_iss_cd (line_cd, iss_cd, 'GICLS202') = 1)
        LOOP
            v_rcvry_brdrx_ds_rec_id := NVL(v_rcvry_brdrx_ds_rec_id, 0) + 1;
            
            INSERT INTO gicl_rcvry_brdrx_ds_extr (session_id, rcvry_brdrx_record_id, rcvry_brdrx_ds_record_id,
                                                  claim_id, recovery_id, recovery_payt_id,
                                                  line_cd, subline_cd, iss_cd,
                                                  item_no, peril_cd, recovered_amt,
                                                  rec_dist_no, dist_year, grp_seq_no,
                                                  share_type, share_pct, shr_recovery_amt,
                                                  acct_tran_id, payee_type)
                                          VALUES (p_session_id, rcvry_ds2.rcvry_brdrx_record_id, v_rcvry_brdrx_ds_rec_id,
                                                  rcvry_ds2.claim_id, rcvry_ds2.recovery_id, rcvry_ds2.recovery_payt_id,
                                                  rcvry_ds2.line_cd, rcvry_ds2.subline_cd, rcvry_ds2.iss_cd,
                                                  rcvry_ds2.item_no, rcvry_ds2.peril_cd, rcvry_ds2.recovered_amt,
                                                  rcvry_ds2.rec_dist_no, rcvry_ds2.dist_year, rcvry_ds2.grp_seq_no,
                                                  rcvry_ds2.share_type, rcvry_ds2.share_pct, rcvry_ds2.shr_recovery_amt,
                                                  rcvry_ds2.acct_tran_id, rcvry_ds2.payee_type);
        END LOOP;
        
        FOR bs IN (SELECT session_id, claim_id, item_no, peril_cd, buss_source
                     FROM gicl_res_brdrx_extr
                    WHERE claim_id IN (SELECT claim_id
                                         FROM gicl_rcvry_brdrx_extr)
                                          AND check_user_per_iss_cd (line_cd,iss_cd, 'GICLS202') = 1)
        LOOP
            UPDATE gicl_rcvry_brdrx_extr
               SET buss_source = bs.buss_source
             WHERE session_id = bs.session_id
               AND claim_id = bs.claim_id
               AND item_no = bs.item_no
               AND peril_cd = bs.peril_cd;

            UPDATE gicl_rcvry_brdrx_ds_extr
               SET buss_source = bs.buss_source
             WHERE session_id = bs.session_id
               AND claim_id = bs.claim_id
               AND item_no = bs.item_no
               AND peril_cd = bs.peril_cd;

            UPDATE gicl_rcvry_brdrx_rids_extr
               SET buss_source = bs.buss_source
             WHERE session_id = bs.session_id
               AND claim_id = bs.claim_id
               AND item_no = bs.item_no
               AND peril_cd = bs.peril_cd;
        END LOOP;
    END extract_brdrx_rcvry;
    
    /*edr - EXTRACT_DATA_REG start*/
    PROCEDURE edr_extract_direct(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_per_buss          IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_brdrx_record_id   IN OUT NUMBER,
        p_dsp_gross_tag     IN VARCHAR2,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_tot_prem_amt              gipi_itmperil.prem_amt%TYPE;
        v_intm_no                   giis_intermediary.intm_no%TYPE;
        v_exp_paid                  gicl_clm_res_hist.expenses_paid%TYPE;
        v_loss_paid                 gicl_clm_res_hist.losses_paid%TYPE;
        v_tsi_amt                   gipi_itmperil.tsi_amt%TYPE :=0;
        v_loss_res_amt              gicl_clm_res_hist.loss_reserve%TYPE;
        v_loss_pd_amt               gicl_clm_res_hist.losses_paid%TYPE;
        v_exp_res_amt               gicl_clm_res_hist.expense_reserve%TYPE;
        v_exp_pd_amt                gicl_clm_res_hist.expenses_paid%TYPE;
        v_prem_amt                  gipi_itmperil.prem_amt%TYPE;
        v_ann_tsi_amt               gipi_itmperil.tsi_amt%TYPE;  
        v_intm_type                 giis_intermediary.intm_type%TYPE;
        v_brdrx_record_id           gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')) loss_year, a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd,
                                  SUM(NVL(d.recovered_amt*d.convert_rate,0)) converted_recovered_amt
                             FROM gicl_claims a, gicl_clm_recovery d
                            WHERE 1 = 1
                              AND a.pol_iss_cd  <> p_ri_iss_cd
                              AND d.claim_id(+)  = a.claim_id
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                              AND a.claim_id    >= 0
                              AND DECODE(p_reg_button,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd     = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd  = nvl(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) 
                                  = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND a.loss_cat_cd = NVL(p_dsp_loss_cat_cd,a.loss_cat_cd)
                            GROUP BY a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')), a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))), 
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'09'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))),
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd , a.loss_cat_cd
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, NVL(a.convert_rate,1) convert_rate,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(NVL(a.convert_rate,1)*NVL(a.loss_reserve,0)) loss_reserve,
                                       SUM(NVL(a.convert_rate,1)*NVL(a.expense_reserve,0)) expense_reserve,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.peril_cd             = b.peril_cd
                                   AND a.item_no              = b.item_no
                                   AND a.claim_id             = b.claim_id
                                   AND NVL(a.dist_sw,'N')     = 'Y'
                                   AND b.claim_id             = claims_rec.claim_id
                                   AND a.claim_id            >= 0
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       NVL(a.convert_rate,1), b.ann_tsi_amt,
                                       a.grouped_item_no, a.clm_res_hist_id)
            LOOP
                v_loss_paid := edr_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_loss_payee_type);
                v_exp_paid := edr_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_exp_payee_type);
                
                FOR policies_rec IN (SELECT a.claim_id, b.policy_id
                                       FROM gicl_claims a, gipi_polbasic b, giuw_pol_dist c
                                      WHERE a.renew_no    = b.renew_no
                                        AND a.pol_seq_no  = b.pol_seq_no
                                        AND a.issue_yy    = b.issue_yy
                                        AND a.pol_iss_cd  = b.iss_cd
                                        AND a.subline_cd  = b.subline_cd
                                        AND a.line_cd     = b.line_cd
                                        AND a.loss_date  >= b.eff_date
                                        AND a.loss_date  <= nvl(b.endt_expiry_date,b.expiry_date)     
                                        AND b.policy_id   = c.policy_id                               
                                        AND c.dist_flag   = '3'
                                        AND a.claim_id    = claims_rec.claim_id
                                        AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                        AND EXISTS (SELECT '*'
                                                      FROM gipi_itmperil 
                                                     WHERE policy_id = b.policy_id
                                                       AND item_no   = reserve_rec.item_no
                                                       AND peril_cd  = reserve_rec.peril_cd)
                                      ORDER BY a.claim_id, b.policy_id)
                LOOP
                    v_tot_prem_amt := edr_get_tot_prem_amt(policies_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd);
                    v_tsi_amt := edr_get_tsi_amt(policies_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd);
                    
                    FOR invoice_rec IN (SELECT d.policy_id, d.iss_cd, d.prem_seq_no, SUM(b.prem_amt) prem_amt
                                          FROM gipi_polbasic a, gipi_itmperil b, gipi_item c, gipi_invoice d
                                         WHERE a.policy_id = c.policy_id 
                                           AND c.item_no   = b.item_no
                                           AND c.policy_id = b.policy_id
                                           AND c.item_grp  = d.item_grp
                                           AND c.policy_id = d.policy_id 
                                           AND a.policy_id = policies_rec.policy_id
                                           AND b.item_no   = reserve_rec.item_no
                                           AND b.peril_cd  = reserve_rec.peril_cd
                                           AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                         GROUP BY d.policy_id, d.item_grp, d.iss_cd, d.prem_seq_no)
                    LOOP
                        FOR intermediary_rec IN (SELECT a.intrmdry_intm_no, a.share_percentage
                                                   FROM gipi_comm_invoice a
                                                  WHERE a.prem_seq_no = invoice_rec.prem_seq_no
                                                    AND a.iss_cd      = invoice_rec.iss_cd
                                                    AND a.policy_id   = invoice_rec.policy_id)
                        LOOP
                            v_intm_no := edr_get_parent_intm(intermediary_rec.intrmdry_intm_no);
                            
                            IF v_intm_no IS NOT NULL THEN
                                BEGIN
                                    SELECT intm_type
                                      INTO v_intm_type
                                      FROM giis_intermediary
                                     WHERE intm_no = v_intm_no;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        v_intm_type := null;
                                END;
                            END IF;
                            
                            v_loss_res_amt := (intermediary_rec.share_percentage/100*reserve_rec.loss_reserve);
                            v_exp_res_amt  := (intermediary_rec.share_percentage/100*reserve_rec.expense_reserve);  
                            v_loss_pd_amt  := (intermediary_rec.share_percentage/100*v_loss_paid);
                            v_exp_pd_amt   := (intermediary_rec.share_percentage/100*v_exp_paid);  
                            v_prem_amt     := (intermediary_rec.share_percentage/100*v_tot_prem_amt);
                            v_ann_tsi_amt  := (intermediary_rec.share_percentage/100*v_tsi_amt);
                            
                            BEGIN
                                UPDATE gicl_res_brdrx_extr
                                   SET loss_reserve     = v_loss_res_amt,
                                       losses_paid     = v_loss_pd_amt,
                                       expense_reserve = v_exp_res_amt,
                                       expenses_paid   = v_exp_pd_amt,
                                       tsi_amt         = v_ann_tsi_amt,
                                       prem_amt        = v_prem_amt
                                 WHERE peril_cd     = reserve_rec.peril_cd
                                   AND item_no      = reserve_rec.item_no
                                   AND buss_source  = v_intm_no
                                   AND iss_cd       = claims_rec.iss_cd
                                   AND claim_id     = claims_rec.claim_id
                                   AND session_id   = p_session_id;
                
                                IF SQL%NOTFOUND THEN
                                    v_brdrx_record_id  := v_brdrx_record_id + 1;
                  
                                    INSERT INTO gicl_res_brdrx_extr
                                               (session_id,      brdrx_record_id,
                                                claim_id,        iss_cd,
                                                buss_source,     line_cd,
                                                subline_cd,      loss_year,
                                                assd_no,         claim_no,
                                                policy_no,       loss_date,
                                                clm_file_date,   item_no,
                                                peril_cd,        loss_cat_cd,
                                                incept_date,     expiry_date,
                                                loss_reserve,    losses_paid,
                                                expense_reserve, expenses_paid,
                                                tsi_amt,         clm_stat_cd,
                                                prem_amt,        recovered_amt,
                                                intm_type,          user_id,
                                                last_update, 
                                                extr_type,         brdrx_type,
                                                ol_date_opt,     brdrx_rep_type,
                                                res_tag,         pd_date_opt,
                                                intm_tag,         iss_cd_tag,
                                                line_cd_tag,     loss_cat_tag,
                                                from_date,         to_date,
                                                branch_opt,         reg_date_opt,
                                                net_rcvry_tag,     rcvry_from_date,
                                                rcvry_to_date,
                                                grouped_item_no, clm_res_hist_id)             
                                         VALUES(p_session_id,             v_brdrx_record_id,
                                                claims_rec.claim_id,      claims_rec.iss_cd,
                                                v_intm_no,                claims_rec.line_cd,
                                                claims_rec.subline_cd,    claims_rec.loss_year,
                                                claims_rec.assd_no,       claims_rec.claim_no,
                                                claims_rec.policy_no,     claims_rec.dsp_loss_date,
                                                claims_rec.clm_file_date, reserve_rec.item_no,
                                                reserve_rec.peril_cd,     claims_rec.loss_cat_cd,
                                                claims_rec.pol_eff_date,  claims_rec.expiry_date, 
                                                v_loss_res_amt,           v_loss_pd_amt,
                                                v_exp_res_amt,            v_exp_pd_amt, 
                                                v_ann_tsi_amt,            claims_rec.clm_stat_cd,
                                                v_prem_amt,               claims_rec.converted_recovered_amt,
                                                v_intm_type,              p_user_id,
                                                SYSDATE,
                                                p_rep_name,                    p_brdrx_type,
                                                p_brdrx_date_option,        p_brdrx_option,
                                                p_dsp_gross_tag,            p_paid_date_option,
                                                p_per_buss,                    p_iss_break,
                                                p_subline_break,            p_per_loss_cat,
                                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                                p_branch_option,            p_reg_button,
                                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                                p_dsp_rcvry_to_date,
                                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);   
                                END IF;
                            END;
                        END LOOP;
                    END LOOP;                                         
                END LOOP;                                      
            END LOOP;
        END LOOP; 
        
        p_brdrx_record_id := v_brdrx_record_id;                           
    END edr_extract_direct;
    
    FUNCTION edr_get_paid_le_amt(
        p_claim_id   IN gicl_claims.claim_id%type,
        p_item_no    IN gicl_clm_loss_exp.item_no%type,
        p_peril_cd   IN gicl_clm_loss_exp.peril_cd%type,
        p_payee_type IN gicl_clm_loss_exp.payee_type%type
    ) RETURN NUMBER IS
        v_paid_le_amt          gicl_loss_exp_ds.shr_le_net_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(NVL(b.net_amt,0))
              INTO v_paid_le_amt 
              FROM gicl_item_peril a, gicl_clm_loss_exp b, gicl_claims c
             WHERE a.peril_cd   = b.peril_cd
               AND a.item_no    = b.item_no 
               AND a.claim_id   = b.claim_id
               AND a.claim_id   = p_claim_id
               AND a.item_no    = p_item_no
               AND a.peril_cd   = p_peril_cd
               AND b.payee_type = p_payee_type
               AND a.claim_id   = c.claim_id
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND b.tran_id IS NOT NULL;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_paid_le_amt := 0;
        END;
        RETURN (NVL(v_paid_le_amt,0));
    END edr_get_paid_le_amt;
    
    FUNCTION edr_get_tsi_amt(
        p_claim_id   gicl_claims.claim_id%TYPE,
        p_item_no    gicl_item_peril.item_no%TYPE,
        p_peril_cd   gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER IS
    v_tsi_amt        gipi_itmperil.tsi_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(b.tsi_amt)
              INTO v_tsi_amt
              FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
             WHERE b.peril_cd    = p_peril_cd
               AND b.item_no     = p_item_no
               AND b.policy_id   = a.policy_id
               AND c.loss_date  >= a.eff_date
               AND c.loss_date  <= nvl(a.endt_expiry_date,a.expiry_date)
               AND a.policy_id   = d.policy_id
               AND d.dist_flag   = '3'     
               AND a.line_cd     = c.line_cd 
               AND a.subline_cd  = c.subline_cd
               AND a.iss_cd      = c.pol_iss_cd
               AND a.issue_yy    = c.issue_yy
               AND a.pol_seq_no  = c.pol_seq_no
               AND a.renew_no    = c.renew_no
               AND c.claim_id    = p_claim_id
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tsi_amt := 0;
        END;    
        RETURN (v_tsi_amt);
  END edr_get_tsi_amt;
    
    FUNCTION edr_get_tot_prem_amt(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no  IN gicl_item_peril.item_no%TYPE,
        p_peril_cd IN gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER IS
        v_tot_prem_amt          gipi_itmperil.prem_amt%TYPE;
    BEGIN
        BEGIN
            SELECT SUM(b.prem_amt)
              INTO v_tot_prem_amt
              FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
             WHERE b.peril_cd    = p_peril_cd
               AND b.item_no     = p_item_no
               AND b.policy_id   = a.policy_id
               AND c.loss_date  >= a.eff_date
               AND c.loss_date  <= NVL(a.endt_expiry_date,a.expiry_date)
               AND a.policy_id   = d.policy_id
               AND d.dist_flag   = '3'     
               AND a.line_cd     = c.line_cd 
               AND a.subline_cd  = c.subline_cd
               AND a.iss_cd      = c.pol_iss_cd
               AND a.issue_yy    = c.issue_yy
               AND a.pol_seq_no  = c.pol_seq_no
               AND a.renew_no    = c.renew_no
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND c.claim_id    = p_claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tot_prem_amt := 0;
        END;  
        RETURN (v_tot_prem_amt);
    END edr_get_tot_prem_amt; 
    
    FUNCTION edr_get_parent_intm(
        p_intrmdry_intm_no IN giis_intermediary.intm_no%TYPE
    ) RETURN NUMBER IS
        v_intm_no              giis_intermediary.intm_no%type;
    BEGIN
        BEGIN
            SELECT intm_no
              INTO v_intm_no
              FROM giis_intermediary
             WHERE lic_tag = 'Y'
               AND intm_no = p_intrmdry_intm_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT NVL(a.parent_intm_no, a.intm_no)
                      INTO v_intm_no
                      FROM giis_intermediary a
                     WHERE level = (SELECT MAX(level)
                                      FROM giis_intermediary b
                                   CONNECT BY PRIOR b.parent_intm_no = b.intm_no 
                                       AND b.lic_tag = 'N'
                                     START WITH b.intm_no = p_intrmdry_intm_no)
                   CONNECT BY PRIOR a.parent_intm_no = a.intm_no
                     START WITH a.intm_no = p_intrmdry_intm_no;
                EXCEPTION
                    WHEN OTHERS THEN    
                        v_intm_no := null;
                END;
        END;
        RETURN v_intm_no; 
    END edr_get_parent_intm;
    
    PROCEDURE edr_extract_inward(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_subline_break     IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_brdrx_record_id   IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_iss_break         IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date IN DATE,
        p_dsp_rcvry_to_date IN DATE
    ) IS
        v_policy_id_tsi_amt         gipi_itmperil.tsi_amt%TYPE;
        v_tsi_amt                   gipi_itmperil.tsi_amt%TYPE := 0;
        v_policy_id_prem_amt        gipi_itmperil.prem_amt%TYPE;
        v_prem_amt                  gipi_itmperil.prem_amt%TYPE := 0;
        v_expenses_paid             gicl_clm_res_hist.expenses_paid%TYPE;
        v_losses_paid               gicl_clm_res_hist.losses_paid%TYPE;
        v_brdrx_record_id       gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')) loss_year, a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd, a.ri_cd, d.recovered_amt,
                                  SUM(NVL(d.recovered_amt*d.convert_rate,0)) converted_recovered_amt
                             FROM gicl_claims a, gicl_clm_recovery d
                            WHERE 1 = 1
                              AND a.pol_iss_cd   = p_ri_iss_cd
                              AND d.claim_id(+)  = a.claim_id
                              AND a.claim_id    >= 0
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                              AND TRUNC(a.dsp_loss_date) 
                                  BETWEEN (DECODE(p_reg_button,1,NVL(p_dsp_from_date,TO_DATE('01-JAN','DD-MON')),a.dsp_loss_date))
                                      AND (DECODE(p_reg_button,1,NVL(p_dsp_to_date,SYSDATE),a.dsp_loss_date))
                              AND TRUNC(a.clm_file_date) 
                                  BETWEEN (DECODE(p_reg_button,2,NVL(p_dsp_from_date,TO_DATE('01-JAN','DD-MON')),a.clm_file_date))
                                      AND (DECODE(p_reg_button,2,NVL(p_dsp_to_date,SYSDATE),a.clm_file_date))
                              AND a.line_cd      = NVL(p_dsp_line_cd, a.line_cd)
                              AND a.subline_cd   = NVL(p_dsp_subline_cd, a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))
                              AND a.loss_cat_cd = NVL(p_dsp_loss_cat_cd,a.loss_cat_cd)
                            GROUP BY a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')), a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                  LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))),
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'09'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))),
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd, a.ri_cd, d.recovered_amt
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.item_no, b.peril_cd, b.loss_cat_cd, NVL(a.convert_rate,1) convert_rate,
                                       SUM(NVL(a.convert_rate,1)*NVL(a.loss_reserve,0)) loss_reserve,
                                       SUM(NVL(a.convert_rate,1)*NVL(a.expense_reserve,0)) expense_reserve,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.peril_cd             = b.peril_cd
                                   AND a.item_no              = b.item_no
                                   AND a.claim_id             = b.claim_id
                                   AND NVL(a.dist_sw,'N')     = 'Y'
                                   AND b.claim_id             = claims_rec.claim_id
                                   AND a.claim_id            >= 0
                                   AND a.claim_id = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       NVL(a.convert_rate,1), a.grouped_item_no, a.clm_res_hist_id)
            LOOP
                v_losses_paid := edr_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_loss_payee_type);
                v_expenses_paid := edr_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_exp_payee_type);
                
                FOR policies_rec IN (SELECT a.claim_id, b.policy_id
                                       FROM gicl_claims a, gipi_polbasic b, giuw_pol_dist c
                                      WHERE a.renew_no    = b.renew_no
                                        AND a.pol_seq_no  = b.pol_seq_no
                                        AND a.issue_yy    = b.issue_yy
                                        AND a.pol_iss_cd  = b.iss_cd
                                        AND a.subline_cd  = b.subline_cd
                                        AND a.line_cd     = b.line_cd
                                        AND a.loss_date  >= b.eff_date
                                        AND a.loss_date  <= NVL(b.endt_expiry_date,b.expiry_date)
                                        AND b.policy_id   = c.policy_id
                                        AND c.dist_flag   = '3'
                                        AND a.claim_id    = claims_rec.claim_id
                                        AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                                        AND EXISTS (SELECT '*'
                                                      FROM gipi_itmperil 
                                                     WHERE policy_id = b.policy_id
                                                       AND item_no   = reserve_rec.item_no
                                                       AND peril_cd  = reserve_rec.peril_cd)
                                      ORDER BY a.claim_id, b.policy_id)
                LOOP
                    v_policy_id_tsi_amt := edr_get_tsi_amt(policies_rec.policy_id, reserve_rec.item_no, reserve_rec.peril_cd);          
                    v_tsi_amt := v_tsi_amt + v_policy_id_tsi_amt;
                    v_policy_id_prem_amt := edr_get_ri_prem_amt(policies_rec.policy_id, reserve_rec.item_no, reserve_rec.peril_cd);          
                    v_prem_amt := v_prem_amt + v_policy_id_prem_amt;
                END LOOP;
                
                BEGIN
                    v_brdrx_record_id  := v_brdrx_record_id + 1;
                    
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,      brdrx_record_id,
                                claim_id,        iss_cd,
                                buss_source,     line_cd,
                                subline_cd,      loss_year,
                                assd_no,         claim_no,
                                policy_no,       loss_date,
                                clm_file_date,   item_no,
                                peril_cd,        loss_cat_cd,
                                incept_date,     expiry_date,
                                loss_reserve,    losses_paid,
                                expense_reserve, expenses_paid,
                                tsi_amt,         clm_stat_cd,
                                prem_amt,        recovered_amt,
                                intm_type,          user_id,
                                last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)              
                         VALUES(p_session_id,                 v_brdrx_record_id,
                                claims_rec.claim_id,          claims_rec.iss_cd,
                                claims_rec.ri_cd,             claims_rec.line_cd,
                                claims_rec.subline_cd,        claims_rec.loss_year,
                                claims_rec.assd_no,           claims_rec.claim_no,
                                claims_rec.policy_no,         claims_rec.dsp_loss_date,
                                claims_rec.clm_file_date,     reserve_rec.item_no,
                                reserve_rec.peril_cd,         claims_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,      claims_rec.expiry_date, 
                                reserve_rec.loss_reserve,     v_losses_paid,
                                reserve_rec.expense_reserve,  v_expenses_paid,  
                                v_tsi_amt,                    claims_rec.clm_stat_cd,
                                v_prem_amt,                   claims_rec.converted_recovered_amt,
                                p_ri_iss_cd,                   p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);           
                END;
                v_tsi_amt := 0;
                v_prem_amt := 0;
            END LOOP;
        END LOOP;
    END edr_extract_inward;
    
    FUNCTION edr_get_ri_prem_amt(
        p_policy_id  gipi_polbasic.policy_id%TYPE,
        p_item_no    gipi_itmperil.item_no%TYPE,
        p_peril_cd   gipi_itmperil.peril_cd%TYPE
    ) RETURN NUMBER IS
        v_prem_amt             gipi_itmperil.prem_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(a.prem_amt)
              INTO v_prem_amt
              FROM gipi_itmperil a, gipi_polbasic b
             WHERE a.peril_cd  = p_peril_cd
               AND a.item_no   = p_item_no
               AND a.policy_id = p_policy_id
               AND a.policy_id = b.policy_id
               AND check_user_per_iss_cd (b.line_cd, b.iss_cd, 'GICLS202') = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_prem_amt := 0;
        END;    
        RETURN (v_prem_amt);
    END edr_get_ri_prem_amt;
    /*edr - EXTRACT_DATA_REG end*/ 
    
    /*ecri - EXTRACT_CLM_REG_INTM start*/
    PROCEDURE ecri_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN NUMBER
    ) IS
        v_tsi_amt                     gipi_itmperil.tsi_amt%type;        
        v_prem_amt                    gipi_itmperil.prem_amt%type;        
        v_losses_paid                 gicl_clm_res_hist.losses_paid%type;
        v_expenses_paid               gicl_clm_res_hist.expenses_paid%type;
        v_brdrx_record_id             gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')) loss_year, a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd, SUM(NVL(d.recovered_amt*d.convert_rate,0)) converted_recovered_amt
                             FROM gicl_claims a, gicl_clm_recovery d
                            WHERE 1 = 1
                              AND a.pol_iss_cd  <> p_ri_iss_cd
                              AND d.claim_id(+)  = a.claim_id
                              AND a.claim_id    >= 0
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                              AND DECODE(p_reg_button,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd     = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd  = nvl(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))          
                            GROUP BY a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')), a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))), 
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'09'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))),
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                       NVL(a.convert_rate,1) convert_rate, d.intm_no,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(NVL(a.convert_rate,1)*NVL(a.loss_reserve,0)) loss_reserve,
                                       SUM(NVL(a.convert_rate,1)*NVL(a.expense_reserve,0)) expense_reserve,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil d, gicl_claims c
                                 WHERE a.peril_cd             = b.peril_cd
                                   AND a.item_no              = b.item_no 
                                   AND a.claim_id             = b.claim_id
                                   AND NVL(a.dist_sw,'N')     = 'Y'
                                   AND b.claim_id             = claims_rec.claim_id
                                   AND b.claim_id             = d.claim_id (+)
                                   AND b.item_no              = d.item_no (+)
                                   AND b.peril_cd             = d.peril_cd (+)
                                   AND d.intm_no              = p_dsp_intm_no
                                   AND b.claim_id            >= 0   
                                   AND a.claim_id             = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1      
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd, 
                                       NVL(a.convert_rate,1), d.intm_no, b.ann_tsi_amt,
                                       a.grouped_item_no, a.clm_res_hist_id)
            LOOP
                v_tsi_amt := ecri_get_tsi_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd); 
                v_prem_amt := ecri_get_tot_prem_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd);
                v_losses_paid := ecri_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_loss_payee_type);
                v_expenses_paid := ecri_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_exp_payee_type);
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                INSERT INTO gicl_res_brdrx_extr
                           (session_id,      brdrx_record_id,
                            claim_id,        iss_cd,
                            buss_source,     line_cd,
                            subline_cd,      loss_year,
                            assd_no,         claim_no,
                            policy_no,       loss_date,
                            clm_file_date,   item_no,
                            peril_cd,        loss_cat_cd,
                            incept_date,     expiry_date,
                            loss_reserve,    losses_paid,
                            expense_reserve, expenses_paid,
                            tsi_amt,         clm_stat_cd,
                            prem_amt,        recovered_amt,
                            user_id,         last_update,
                            extr_type,         brdrx_type,
                            ol_date_opt,     brdrx_rep_type,
                            res_tag,         pd_date_opt,
                            intm_tag,         iss_cd_tag,
                            line_cd_tag,     loss_cat_tag,
                            from_date,         to_date,
                            branch_opt,         reg_date_opt,
                            net_rcvry_tag,     rcvry_from_date,
                            rcvry_to_date,
                            grouped_item_no, clm_res_hist_id)
                     VALUES(p_session_id,                v_brdrx_record_id,
                            claims_rec.claim_id,         claims_rec.iss_cd,
                            reserve_rec.intm_no,         claims_rec.line_cd,
                            claims_rec.subline_cd,       claims_rec.loss_year,
                            claims_rec.assd_no,          claims_rec.claim_no,
                            claims_rec.policy_no,        claims_rec.dsp_loss_date,
                            claims_rec.clm_file_date,    reserve_rec.item_no,
                            reserve_rec.peril_cd,        claims_rec.loss_cat_cd,
                            claims_rec.pol_eff_date,     claims_rec.expiry_date, 
                            reserve_rec.loss_reserve,    v_losses_paid,
                            reserve_rec.expense_reserve, v_expenses_paid,
                            v_tsi_amt,                   claims_rec.clm_stat_cd,
                            v_prem_amt,                  claims_rec.converted_recovered_amt, 
                            p_user_id,                   SYSDATE,
                            p_rep_name,                     p_brdrx_type,
                            p_brdrx_date_option,         p_brdrx_option,
                            p_dsp_gross_tag,             p_paid_date_option,
                            p_per_buss,                     p_iss_break,
                            p_subline_break,             p_per_loss_cat,
                            p_dsp_from_date,             NVL(p_dsp_to_date,p_dsp_as_of_date),
                            p_branch_option,             p_reg_button,
                            p_net_rcvry_chkbx,             p_dsp_rcvry_from_date,
                            p_dsp_rcvry_to_date,
                            reserve_rec.grouped_item_no, reserve_rec.clm_res_hist_id);
            END LOOP;
        END LOOP;
    END ecri_extract_all;
    
    FUNCTION ecri_get_tsi_amt(
        p_claim_id   gicl_claims.claim_id%TYPE,
        p_item_no    gicl_item_peril.item_no%TYPE,
        p_peril_cd   gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER IS
        v_tsi_amt          gipi_itmperil.tsi_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(b.tsi_amt)
              INTO v_tsi_amt
              FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
             WHERE b.peril_cd    = p_peril_cd
               AND b.item_no     = p_item_no
               AND b.policy_id   = a.policy_id
               AND c.loss_date  >= a.eff_date
               AND c.loss_date  <= nvl(a.endt_expiry_date,a.expiry_date)
               AND a.policy_id   = d.policy_id
               AND d.dist_flag   = '3'     
               AND a.line_cd     = c.line_cd 
               AND a.subline_cd  = c.subline_cd
               AND a.iss_cd      = c.pol_iss_cd
               AND a.issue_yy    = c.issue_yy
               AND a.pol_seq_no  = c.pol_seq_no
               AND a.renew_no    = c.renew_no
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND c.claim_id    = p_claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tsi_amt := 0;
        END;    
        RETURN (v_tsi_amt);
    END ecri_get_tsi_amt;
    
    FUNCTION ecri_get_tot_prem_amt(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no  IN gicl_item_peril.item_no%TYPE,
        p_peril_cd IN gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER IS
        v_tot_prem_amt          gipi_itmperil.prem_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(b.prem_amt) tot_prem_amt
              INTO v_tot_prem_amt
              FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
             WHERE b.peril_cd    = p_peril_cd
               AND b.item_no     = p_item_no
               AND b.policy_id   = a.policy_id
               AND c.loss_date  >= a.eff_date
               AND c.loss_date  <= nvl(a.endt_expiry_date,a.expiry_date)
               AND a.policy_id   = d.policy_id
               AND d.dist_flag   = '3'     
               AND a.line_cd     = c.line_cd 
               AND a.subline_cd  = c.subline_cd
               AND a.iss_cd      = c.pol_iss_cd
               AND a.issue_yy    = c.issue_yy
               AND a.pol_seq_no  = c.pol_seq_no
               AND a.renew_no    = c.renew_no
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND c.claim_id    = p_claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tot_prem_amt := 0;
        END;  
        RETURN (v_tot_prem_amt);
  END ecri_get_tot_prem_amt;

    FUNCTION ecri_get_paid_le_amt(
        p_claim_id   IN gicl_claims.claim_id%type,
        p_item_no    IN gicl_clm_loss_exp.item_no%type,
        p_peril_cd   IN gicl_clm_loss_exp.peril_cd%type,
        p_payee_type IN gicl_clm_loss_exp.payee_type%type
    ) RETURN NUMBER IS
        v_paid_le_amt          gicl_loss_exp_ds.shr_le_net_amt%type;
    BEGIN
        BEGIN 
            SELECT SUM(NVL(b.net_amt,0))
              INTO v_paid_LE_amt 
              FROM gicl_item_peril a, gicl_clm_loss_exp b, gicl_claims c
             WHERE a.peril_cd   = b.peril_cd
               AND a.item_no    = b.item_no 
               AND a.claim_id   = b.claim_id
               AND a.claim_id   = p_claim_id
               AND a.item_no    = p_item_no
               AND a.peril_cd   = p_peril_cd
               AND b.payee_type = p_payee_type
               AND a.claim_id   = c.claim_id
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND b.tran_id IS NOT NULL;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_paid_le_amt := 0;
        END;
        RETURN (NVL(v_paid_LE_amt,0));
    END ecri_get_paid_le_amt;
    /*ecri - EXTRACT_CLM_REG_INTM end*/  
    
    /*ecri - EXTRACT_CLM_REG start*/  
    PROCEDURE ecr_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_iss_break         IN NUMBER,
        p_subline_break     IN NUMBER,
        p_dsp_from_date     IN DATE,
        p_dsp_to_date       IN DATE,
        p_dsp_as_of_date    IN DATE,
        p_dsp_peril_cd      IN gicl_item_peril.peril_cd%TYPE,
        p_dsp_intm_no       IN gicl_intm_itmperil.intm_no%TYPE,
        p_brdrx_date_option IN NUMBER,
        p_dsp_line_cd       IN gicl_claims.line_cd%TYPE,
        p_dsp_subline_cd    IN gicl_claims.subline_cd%TYPE,
        p_branch_option     IN NUMBER,
        p_dsp_iss_cd        IN gicl_claims.iss_cd%TYPE,
        p_rep_name          IN NUMBER,
        p_brdrx_type        IN NUMBER,
        p_brdrx_option      IN NUMBER,
        p_dsp_gross_tag     IN NUMBER,
        p_paid_date_option  IN NUMBER,
        p_per_buss          IN NUMBER,
        p_per_loss_cat      IN NUMBER,
        p_reg_button        IN NUMBER,
        p_ri_iss_cd         IN gicl_claims.pol_iss_cd%TYPE,
        p_dsp_loss_cat_cd   IN gicl_claims.loss_cat_cd%TYPE,
        p_clm_exp_payee_type IN VARCHAR2,
        p_clm_loss_payee_type IN VARCHAR2,
        p_net_rcvry_chkbx   IN VARCHAR2,
        p_dsp_rcvry_from_date   IN DATE,
        p_dsp_rcvry_to_date IN DATE,        
        p_brdrx_record_id   IN NUMBER
    ) IS
        v_tsi_amt                     gipi_itmperil.tsi_amt%type;        
        v_prem_amt                    gipi_itmperil.prem_amt%type;        
        v_losses_paid                 gicl_clm_res_hist.losses_paid%type;
        v_expenses_paid               gicl_clm_res_hist.expenses_paid%type;
        v_brdrx_record_id             gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR claims_rec IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')) loss_year, a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))) claim_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd, a.ri_cd,
                                  SUM(NVL(d.recovered_amt*d.convert_rate,0)) converted_recovered_amt
                             FROM gicl_claims a, gicl_clm_recovery d
                            WHERE 1 = 1
                              AND d.claim_id(+)  = a.claim_id
                              AND a.claim_id    >= 0
                              AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202') = 1
                              AND DECODE(p_reg_button,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
                                  BETWEEN p_dsp_from_date AND p_dsp_to_date
                              AND a.line_cd     = NVL(p_dsp_line_cd,a.line_cd)
                              AND a.subline_cd  = NVL(p_dsp_subline_cd,a.subline_cd)
                              AND DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd) = NVL(p_dsp_iss_cd,DECODE(p_branch_option,1,a.iss_cd,2,a.pol_iss_cd))                   
                            GROUP BY a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')), a.assd_no,
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.clm_seq_no,'0999999'))), 
                                  (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
                                  LTRIM(TO_CHAR(a.pol_seq_no,'09'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))),
                                  a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
                                  a.clm_stat_cd, a.loss_cat_cd, a.ri_cd
                            ORDER BY a.claim_id)
        LOOP
            FOR reserve_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                       NVL(a.convert_rate,1) convert_rate,
                                       (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt, 
                                       SUM(NVL(a.convert_rate,1)*NVL(a.loss_reserve,0)) loss_reserve,
                                       SUM(NVL(a.convert_rate,1)*NVL(a.expense_reserve,0)) expense_reserve,
                                       a.grouped_item_no, a.clm_res_hist_id
                                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c
                                 WHERE a.peril_cd             = b.peril_cd
                                   AND a.item_no              = b.item_no
                                   AND a.claim_id             = b.claim_id
                                   AND NVL(a.dist_sw,'N')     = 'Y'
                                   AND b.claim_id             = claims_rec.claim_id
                                   AND b.claim_id            >= 0
                                   AND a.claim_id             = c.claim_id
                                   AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                   AND b.loss_cat_cd          = NVL(p_dsp_loss_cat_cd, b.loss_cat_cd)
                                 GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                       NVL(a.convert_rate,1), b.ann_tsi_amt, a.grouped_item_no, a.clm_res_hist_id)
            LOOP
                v_tsi_amt := ecr_get_tsi_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd); 
                v_prem_amt := ecr_get_tot_prem_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd);
                v_losses_paid := ecr_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_loss_payee_type);
                v_expenses_paid := ecr_get_paid_le_amt(claims_rec.claim_id, reserve_rec.item_no, reserve_rec.peril_cd, p_clm_exp_payee_type);
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_dsp_iss_cd = p_ri_iss_cd THEN 
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,      brdrx_record_id,
                                claim_id,        iss_cd,
                                buss_source,     line_cd,
                                subline_cd,      loss_year,
                                assd_no,         claim_no,
                                policy_no,       loss_date,
                                clm_file_date,   item_no,
                                peril_cd,        loss_cat_cd,
                                incept_date,     expiry_date,
                                loss_reserve,    losses_paid,
                                expense_reserve, expenses_paid,
                                tsi_amt,         clm_stat_cd,
                                prem_amt,        recovered_amt,
                                intm_type,          user_id,
                                last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)  
                         VALUES(p_session_id,                v_brdrx_record_id,
                                claims_rec.claim_id,         claims_rec.iss_cd,
                                claims_rec.ri_cd,            claims_rec.line_cd,
                                claims_rec.subline_cd,       claims_rec.loss_year,
                                claims_rec.assd_no,          claims_rec.claim_no,
                                claims_rec.policy_no,        claims_rec.dsp_loss_date,
                                claims_rec.clm_file_date,    reserve_rec.item_no,
                                reserve_rec.peril_cd,        claims_rec.loss_cat_cd,   --reserve_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,     claims_rec.expiry_date, 
                                reserve_rec.loss_reserve,    v_losses_paid,
                                reserve_rec.expense_reserve, v_expenses_paid,
                                v_tsi_amt,                   claims_rec.clm_stat_cd,
                                v_prem_amt,                  claims_rec.converted_recovered_amt,
                                p_ri_iss_cd,                  p_user_id, 
                                SYSDATE,
                                p_rep_name,                    p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                ELSE
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id,      brdrx_record_id,
                                claim_id,        iss_cd,
                                buss_source,     line_cd,
                                subline_cd,      loss_year,
                                assd_no,         claim_no,
                                policy_no,       loss_date,
                                clm_file_date,   item_no,
                                peril_cd,        loss_cat_cd,
                                incept_date,     expiry_date,
                                loss_reserve,    losses_paid,
                                expense_reserve, expenses_paid,
                                tsi_amt,         clm_stat_cd,
                                prem_amt,        recovered_amt,
                                user_id,         last_update,
                                extr_type,         brdrx_type,
                                ol_date_opt,     brdrx_rep_type,
                                res_tag,         pd_date_opt,
                                intm_tag,         iss_cd_tag,
                                line_cd_tag,     loss_cat_tag,
                                from_date,         to_date,
                                branch_opt,         reg_date_opt,
                                net_rcvry_tag,     rcvry_from_date,
                                rcvry_to_date,
                                grouped_item_no, clm_res_hist_id)
                         VALUES(p_session_id,                v_brdrx_record_id,
                                claims_rec.claim_id,         claims_rec.iss_cd,
                                NULL,                        claims_rec.line_cd,
                                claims_rec.subline_cd,       claims_rec.loss_year,
                                claims_rec.assd_no,          claims_rec.claim_no,
                                claims_rec.policy_no,        claims_rec.dsp_loss_date,
                                claims_rec.clm_file_date,    reserve_rec.item_no,
                                reserve_rec.peril_cd,        claims_rec.loss_cat_cd,
                                claims_rec.pol_eff_date,     claims_rec.expiry_date, 
                                reserve_rec.loss_reserve,    v_losses_paid,
                                reserve_rec.expense_reserve, v_expenses_paid,
                                v_tsi_amt,                   claims_rec.clm_stat_cd,
                                v_prem_amt,                  claims_rec.converted_recovered_amt,
                                p_user_id,                      SYSDATE,
                                p_rep_name,                     p_brdrx_type,
                                p_brdrx_date_option,        p_brdrx_option,
                                p_dsp_gross_tag,            p_paid_date_option,
                                p_per_buss,                    p_iss_break,
                                p_subline_break,            p_per_loss_cat,
                                p_dsp_from_date,            NVL(p_dsp_to_date,p_dsp_as_of_date),
                                p_branch_option,            p_reg_button,
                                p_net_rcvry_chkbx,            p_dsp_rcvry_from_date,
                                p_dsp_rcvry_to_date,
                                reserve_rec.grouped_item_no,reserve_rec.clm_res_hist_id);  
                END IF;  
            END LOOP;
        END LOOP;
    END ecr_extract_all;
    
    FUNCTION ecr_get_tsi_amt(
        p_claim_id   gicl_claims.claim_id%TYPE,
        p_item_no    gicl_item_peril.item_no%TYPE,
        p_peril_cd   gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER IS
        v_tsi_amt          gipi_itmperil.tsi_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(b.tsi_amt)
              INTO v_tsi_amt
              FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
             WHERE b.peril_cd    = p_peril_cd
               AND b.item_no     = p_item_no
               AND b.policy_id   = a.policy_id
               AND c.loss_date  >= a.eff_date
               AND c.loss_date  <= NVL(a.endt_expiry_date,a.expiry_date)
               AND a.policy_id   = d.policy_id
               AND d.dist_flag   = '3'     
               AND a.line_cd     = c.line_cd 
               AND a.subline_cd  = c.subline_cd
               AND a.iss_cd      = c.pol_iss_cd
               AND a.issue_yy    = c.issue_yy
               AND a.pol_seq_no  = c.pol_seq_no
               AND a.renew_no    = c.renew_no
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND c.claim_id    = p_claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tsi_amt := 0;
        END;    
        RETURN (v_tsi_amt);
    END ecr_get_tsi_amt;
    
    FUNCTION ecr_get_tot_prem_amt(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no  IN gicl_item_peril.item_no%TYPE,
        p_peril_cd IN gicl_item_peril.peril_cd%TYPE
    ) RETURN NUMBER IS
        v_tot_prem_amt          gipi_itmperil.prem_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(b.prem_amt) tot_prem_amt
              INTO v_tot_prem_amt
              FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
             WHERE b.peril_cd    = p_peril_cd
               AND b.item_no     = p_item_no
               AND b.policy_id   = a.policy_id
               AND c.loss_date  >= a.eff_date
               AND c.loss_date  <= NVL(a.endt_expiry_date,a.expiry_date)
               AND a.policy_id   = d.policy_id
               AND d.dist_flag   = '3'     
               AND a.line_cd     = c.line_cd 
               AND a.subline_cd  = c.subline_cd
               AND a.iss_cd      = c.pol_iss_cd
               AND a.issue_yy    = c.issue_yy
               AND a.pol_seq_no  = c.pol_seq_no
               AND a.renew_no    = c.renew_no
               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
               AND c.claim_id    = p_claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_tot_prem_amt := 0;
        END;  
        RETURN (v_tot_prem_amt);
    END ecr_get_tot_prem_amt;
    
    FUNCTION ecr_get_paid_le_amt(
        p_claim_id   IN gicl_claims.claim_id%TYPE,
        p_item_no    IN gicl_clm_loss_exp.item_no%TYPE,
        p_peril_cd   IN gicl_clm_loss_exp.peril_cd%TYPE,
        p_payee_type IN gicl_clm_loss_exp.payee_type%TYPE
    ) RETURN NUMBER IS
        v_paid_le_amt          gicl_loss_exp_ds.shr_le_net_amt%type;
    BEGIN
        BEGIN
            SELECT SUM(NVL(b.net_amt,0)*NVL(c.convert_rate,1))
              INTO v_paid_LE_amt 
              FROM gicl_item_peril a, gicl_clm_loss_exp b, gicl_advice c, gicl_claims d
             WHERE a.peril_cd   = b.peril_cd
               AND a.item_no    = b.item_no 
               AND a.claim_id   = b.claim_id
               AND b.claim_id   = c.claim_id
               AND b.advice_id  = c.advice_id
               AND a.claim_id   = p_claim_id
               AND a.item_no    = p_item_no
               AND a.peril_cd   = p_peril_cd
               AND b.payee_type = p_payee_type
               AND a.claim_id   = d.claim_id
               AND check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202') = 1
               AND b.tran_id IS NOT NULL;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_paid_le_amt := 0;
        END;
        RETURN (NVL(v_paid_le_amt,0));
    END ecr_get_paid_le_amt;
    /*ecr - EXTRACT_CLM_REG end*/
    
    /*eplp - EXTRACT_PAID_LE_POLICY start*/
    PROCEDURE eplp_extract_all(
        p_user_id           IN giis_users.user_id%TYPE,
        p_session_id        IN gicl_res_brdrx_extr.session_id%TYPE,
        p_brdrx_rep_type    IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_pd_date_opt       IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
        p_from_date         IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date           IN gicl_res_brdrx_extr.TO_DATE%TYPE,
        p_line_cd           IN gicl_claims.line_cd%TYPE,
        p_subline_cd        IN gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd        IN gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy          IN gicl_claims.issue_yy%TYPE,
        p_pol_seq_no        IN gicl_claims.pol_seq_no%TYPE,
        p_renew_no          IN gicl_claims.renew_no%TYPE,
        p_brdrx_record_id   IN NUMBER
    ) IS
        v_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE;
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
    
        FOR paid_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                (b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                                DECODE (p_brdrx_rep_type,1, SUM (a.losses_paid) * NVL (a.convert_rate, 1),
                                                         2, SUM (a.expenses_paid) * NVL (a.convert_rate, 1),NULL) claims_paid,
                                SUM (a.losses_paid) * NVL (a.convert_rate, 1) losspaid,
                                SUM (a.expenses_paid) * NVL (a.convert_rate, 1) expensepaid,
                                a.clm_loss_id, a.dist_no, f.line_cd, f.subline_cd,
                                f.iss_cd, f.issue_yy, f.pol_seq_no, f.renew_no,
                                TO_NUMBER (TO_CHAR (f.loss_date, 'YYYY')) loss_year,
                                f.assd_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_seq_no, '0999999'))
                                ) claim_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.pol_iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.renew_no, '09'))
                                ) policy_no,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date, f.pol_iss_cd
                           FROM gicl_item_peril b,
                                gicl_clm_res_hist a,
                                giac_acctrans d,
                                gicl_claims f
                          WHERE a.peril_cd = b.peril_cd
                            AND a.item_no = b.item_no
                            AND a.claim_id = b.claim_id
                            AND a.tran_id = d.tran_id
                            AND b.claim_id = f.claim_id
                            AND a.tran_id IS NOT NULL
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                            AND DECODE (a.cancel_tag,'Y', TRUNC (a.cancel_date),p_to_date + 1) > p_to_date
                            AND DECODE (p_pd_date_opt,1, TRUNC (a.date_paid),
                                                      2, TRUNC (d.posting_date)) BETWEEN p_from_date AND p_to_date
                            AND d.tran_flag != 'D'
                            AND f.line_cd = NVL (p_line_cd, f.line_cd)
                            AND f.subline_cd = NVL (p_subline_cd, f.subline_cd)
                            AND f.pol_iss_cd = NVL (p_pol_iss_cd, f.pol_iss_cd)
                            AND f.issue_yy = NVL (p_issue_yy, f.issue_yy)
                            AND f.pol_seq_no = NVL (p_pol_seq_no, f.pol_seq_no)
                            AND f.renew_no = NVL (p_renew_no, f.renew_no)
                            AND clm_stat_cd NOT IN ('WD', 'DN', 'CC')
                            AND DECODE (p_brdrx_rep_type,1, NVL (a.losses_paid, 0),
                                                         2, NVL (a.expenses_paid, 0),1) > 0
                            AND (TRUNC(a.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                                 OR a.cancel_date IS NULL)
                          GROUP BY b.claim_id,
                                b.item_no,
                                b.peril_cd,
                                b.loss_cat_cd,
                                b.ann_tsi_amt,
                                a.clm_loss_id,
                                a.dist_no,
                                NVL (a.convert_rate, 1),
                                f.claim_id,
                                f.line_cd,
                                f.subline_cd,
                                f.iss_cd,
                                f.issue_yy,
                                f.pol_seq_no,
                                f.renew_no,
                                f.loss_date,
                                f.assd_no,
                                f.clm_yy,
                                f.clm_seq_no,
                                f.pol_iss_cd,
                                f.dsp_loss_date,
                                f.loss_date,
                                f.clm_file_date,
                                f.pol_eff_date,
                                f.expiry_date
                         UNION  
                         SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                (b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                                DECODE (p_brdrx_rep_type,1, - (SUM (a.losses_paid) * NVL (a.convert_rate, 1)),
                                                         2, - (SUM (a.expenses_paid) * NVL (a.convert_rate, 1)),NULL) claims_paid,
                                -SUM (a.losses_paid) * NVL (a.convert_rate, 1) losspaid,
                                -SUM (a.expenses_paid) * NVL (a.convert_rate, 1) expensepaid, a.clm_loss_id,
                                a.dist_no, f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                                f.pol_seq_no, f.renew_no,
                                TO_NUMBER (TO_CHAR (f.loss_date, 'YYYY')) loss_year,
                                f.assd_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_seq_no, '0999999'))
                                ) claim_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.pol_iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.renew_no, '09'))
                                ) policy_no,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date, f.pol_iss_cd
                           FROM gicl_item_peril b,
                                gicl_clm_res_hist a,
                                giac_acctrans d,
                                giac_reversals e,
                                gicl_claims f
                          WHERE a.peril_cd = b.peril_cd
                            AND a.item_no = b.item_no
                            AND a.claim_id = b.claim_id
                            AND a.tran_id = e.gacc_tran_id
                            AND d.tran_id = e.reversing_tran_id
                            AND b.claim_id = f.claim_id
                            AND a.tran_id IS NOT NULL
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                            AND TRUNC (a.date_paid) < p_from_date 
                            AND f.line_cd = NVL (p_line_cd, f.line_cd)
                            AND f.subline_cd = NVL (p_subline_cd, f.subline_cd)
                            AND f.pol_iss_cd = NVL (p_pol_iss_cd, f.pol_iss_cd)
                            AND f.issue_yy = NVL (p_issue_yy, f.issue_yy)
                            AND f.pol_seq_no = NVL (p_pol_seq_no, f.pol_seq_no)
                            AND f.renew_no = NVL (p_renew_no, f.renew_no)
                            AND clm_stat_cd NOT IN ('WD', 'DN', 'CC')
                            AND DECODE (p_pd_date_opt,1,TRUNC(a.cancel_date),
                                                      2,TRUNC(d.posting_date)) BETWEEN p_from_date AND p_to_date
                            AND (cancel_tag <> 'N' AND cancel_tag IS NOT NULL)
                   GROUP BY b.claim_id,
                            b.item_no,
                            b.peril_cd,
                            b.loss_cat_cd,
                            b.ann_tsi_amt,
                            a.clm_loss_id,
                            a.dist_no,
                            NVL (a.convert_rate, 1),
                            f.claim_id,
                            f.line_cd,
                            f.subline_cd,
                            f.iss_cd,
                            f.issue_yy,
                            f.pol_seq_no,
                            f.renew_no,
                            f.loss_date,
                            f.assd_no,
                            f.clm_yy,
                            f.clm_seq_no,
                            f.pol_iss_cd,
                            f.dsp_loss_date,
                            f.loss_date,
                            f.clm_file_date,
                            f.pol_eff_date,
                            f.expiry_date
                      ORDER BY 1)
        LOOP
            BEGIN
                v_brdrx_record_id := v_brdrx_record_id + 1;

                IF p_brdrx_rep_type = 1 AND ABS(paid_rec.losspaid) > 0 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id,
                                claim_id, iss_cd,
                                line_cd, subline_cd,
                                loss_year, assd_no,
                                claim_no, policy_no,
                                loss_date, clm_file_date,
                                item_no, peril_cd,
                                loss_cat_cd, incept_date,
                                expiry_date, tsi_amt,
                                clm_loss_id, losses_paid,
                                dist_no, user_id, last_update, extr_type,
                                brdrx_type, brdrx_rep_type, pd_date_opt,
                                from_date, TO_DATE, pol_iss_cd,
                                issue_yy, pol_seq_no,
                                renew_no, policy_tag
                               )
                        VALUES (p_session_id, v_brdrx_record_id,
                                paid_rec.claim_id, paid_rec.iss_cd,
                                paid_rec.line_cd, paid_rec.subline_cd,
                                paid_rec.loss_year, paid_rec.assd_no,
                                paid_rec.claim_no, paid_rec.policy_no,
                                paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                                paid_rec.item_no, paid_rec.peril_cd,
                                paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                                paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                                paid_rec.clm_loss_id, paid_rec.claims_paid,
                                paid_rec.dist_no, p_user_id, SYSDATE, 1,
                                2, p_brdrx_rep_type, p_pd_date_opt,
                                p_from_date, p_to_date, paid_rec.pol_iss_cd,
                                paid_rec.issue_yy, paid_rec.pol_seq_no,
                                paid_rec.renew_no, 1
                               );
                ELSIF p_brdrx_rep_type = 2 AND ABS(paid_rec.expensepaid) > 0 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id,
                                claim_id, iss_cd,
                                line_cd, subline_cd,
                                loss_year, assd_no,
                                claim_no, policy_no,
                                loss_date, clm_file_date,
                                item_no, peril_cd,
                                loss_cat_cd, incept_date,
                                expiry_date, tsi_amt,
                                clm_loss_id, expenses_paid,
                                dist_no, user_id, last_update, extr_type,
                                brdrx_type, brdrx_rep_type, pd_date_opt,
                                from_date, TO_DATE, pol_iss_cd,
                                issue_yy, pol_seq_no,
                                renew_no, policy_tag
                               )
                        VALUES (p_session_id, v_brdrx_record_id,
                                paid_rec.claim_id, paid_rec.iss_cd,
                                paid_rec.line_cd, paid_rec.subline_cd,
                                paid_rec.loss_year, paid_rec.assd_no,
                                paid_rec.claim_no, paid_rec.policy_no,
                                paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                                paid_rec.item_no, paid_rec.peril_cd,
                                paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                                paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                                paid_rec.clm_loss_id, paid_rec.claims_paid,
                                paid_rec.dist_no, p_user_id, SYSDATE, 1,
                                2, p_brdrx_rep_type, p_pd_date_opt,
                                p_from_date, p_to_date, paid_rec.pol_iss_cd,
                                paid_rec.issue_yy, paid_rec.pol_seq_no,
                                paid_rec.renew_no, 1
                               );
                ELSIF p_brdrx_rep_type = 3 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id,
                                claim_id, iss_cd,
                                line_cd, subline_cd,
                                loss_year, assd_no,
                                claim_no, policy_no,
                                loss_date, clm_file_date,
                                item_no, peril_cd,
                                loss_cat_cd, incept_date,
                                expiry_date, tsi_amt,
                                clm_loss_id, losses_paid,
                                expenses_paid, dist_no, user_id,
                                last_update, extr_type, brdrx_type,
                                brdrx_rep_type, pd_date_opt, from_date,
                                to_date, pol_iss_cd,
                                issue_yy, pol_seq_no,
                                renew_no, policy_tag
                               )
                        VALUES (p_session_id, v_brdrx_record_id,
                                paid_rec.claim_id, paid_rec.iss_cd,
                                paid_rec.line_cd, paid_rec.subline_cd,
                                paid_rec.loss_year, paid_rec.assd_no,
                                paid_rec.claim_no, paid_rec.policy_no,
                                paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                                paid_rec.item_no, paid_rec.peril_cd,
                                paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                                paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                                paid_rec.clm_loss_id, paid_rec.losspaid,
                                paid_rec.expensepaid, paid_rec.dist_no, p_user_id,
                                SYSDATE, 1, 2,
                                p_brdrx_rep_type, p_pd_date_opt, p_from_date,
                                p_to_date, paid_rec.pol_iss_cd,
                                paid_rec.issue_yy, paid_rec.pol_seq_no,
                                paid_rec.renew_no, 1
                               );
                END IF;
            END;
        END LOOP;
    END eplp_extract_all;
    
    PROCEDURE eplp_extract_distribution(
        p_user_id               IN giis_users.user_id%TYPE,        
        p_session_id            IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_rep_type        IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_from_date             IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date               IN gicl_res_brdrx_extr.to_date%TYPE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR paid_ds_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id, a.grp_seq_no, a.shr_loss_exp_pct,         
                                   DECODE(get_payee_type(b.claim_id, b.clm_loss_id),'L', DECODE (p_brdrx_rep_type,1, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),
                                                                                                                  3, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),NULL),0) losses_paid,
                                   DECODE(get_payee_type(b.claim_id, b.clm_loss_id),'E', DECODE (p_brdrx_rep_type,2, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),
                                                                                                                  3, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),NULL),0) expenses_paid,         
                                   a.clm_dist_no, c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd,
                                   c.subline_cd, c.loss_year, c.loss_cat_cd,
                                   c.losses_paid brdrx_extr_losses_paid,
                                   c.expenses_paid brdrx_extr_expenses_paid
                              FROM gicl_loss_exp_ds a, gicl_clm_res_hist b, gicl_res_brdrx_extr c
                             WHERE c.session_id = p_session_id
                               AND a.claim_id = c.claim_id
                               AND a.item_no = c.item_no
                               AND a.peril_cd = c.peril_cd
                               AND a.clm_dist_no = c.dist_no
                               AND a.clm_loss_id = c.clm_loss_id
                               AND a.claim_id = b.claim_id
                               AND a.clm_loss_id = b.clm_loss_id
                               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                               AND DECODE (b.cancel_tag,'Y', TRUNC (b.cancel_date),p_to_date + 1) > p_to_date
                               AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                                    OR b.cancel_date IS NULL)
                          GROUP BY a.claim_id,
                                   a.item_no,
                                   a.peril_cd,
                                   a.clm_loss_id,
                                   a.grp_seq_no,
                                   a.shr_loss_exp_pct,
                                   a.clm_dist_no,
                                   get_payee_type (b.claim_id, b.clm_loss_id),
                                   c.brdrx_record_id,
                                   c.iss_cd,
                                   c.buss_source,
                                   c.line_cd,
                                   c.subline_cd,
                                   c.loss_year,
                                   c.loss_cat_cd,
                                   c.losses_paid,
                                   c.expenses_paid)
        LOOP
            BEGIN
                IF SIGN (NVL (paid_ds_rec.brdrx_extr_losses_paid, 0)) <> 1 AND SIGN (NVL (paid_ds_rec.losses_paid, 0)) = 1 THEN
                    paid_ds_rec.losses_paid := -paid_ds_rec.losses_paid;
                END IF;

                IF SIGN (NVL (paid_ds_rec.brdrx_extr_expenses_paid, 0)) <> 1 AND SIGN (NVL (paid_ds_rec.expenses_paid, 0)) = 1 THEN
                    paid_ds_rec.expenses_paid := -paid_ds_rec.expenses_paid;
                END IF;

                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id, brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd, buss_source,
                            line_cd, subline_cd,
                            loss_year, item_no,
                            peril_cd, loss_cat_cd,
                            grp_seq_no,
                            shr_pct,
                            losses_paid, expenses_paid,
                            user_id, last_update
                           )
                    VALUES (p_session_id, paid_ds_rec.brdrx_record_id,
                            v_brdrx_ds_record_id, paid_ds_rec.claim_id,
                            paid_ds_rec.iss_cd, paid_ds_rec.buss_source,
                            paid_ds_rec.line_cd, paid_ds_rec.subline_cd,
                            paid_ds_rec.loss_year, paid_ds_rec.item_no,
                            paid_ds_rec.peril_cd, paid_ds_rec.loss_cat_cd,
                            paid_ds_rec.grp_seq_no,
                            paid_ds_rec.shr_loss_exp_pct,
                            paid_ds_rec.losses_paid, paid_ds_rec.expenses_paid,
                            p_user_id, SYSDATE
                           );
            END;
            
            FOR paid_rids_rec IN (SELECT a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct shr_ri_pct_real,         
                                         DECODE (p_brdrx_rep_type,1, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),
                                                                  3, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),NULL) losses_paid,
                                         DECODE (p_brdrx_rep_type,2, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),
                                                                  3, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),NULL) expenses_paid
                                    FROM gicl_loss_exp_rids a, gicl_clm_res_hist b, gicl_claims c
                                   WHERE a.claim_id = paid_ds_rec.claim_id
                                     AND a.item_no = paid_ds_rec.item_no
                                     AND a.peril_cd = paid_ds_rec.peril_cd
                                     AND a.clm_loss_id = paid_ds_rec.clm_loss_id
                                     AND a.clm_dist_no = paid_ds_rec.clm_dist_no
                                     AND a.grp_seq_no = paid_ds_rec.grp_seq_no
                                     AND a.claim_id = b.claim_id
                                     AND a.clm_loss_id = b.clm_loss_id
                                     AND a.claim_id = c.claim_id
                                     AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                     AND DECODE (b.cancel_tag,'Y', TRUNC (b.cancel_date),p_to_date + 1) > p_to_date
                                     AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                                          OR b.cancel_date IS NULL)
                                GROUP BY a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct)
            LOOP
                BEGIN
                    IF SIGN (NVL (paid_ds_rec.losses_paid, 0)) <> 1 AND SIGN (NVL (paid_rids_rec.losses_paid, 0)) = 1 THEN
                        paid_rids_rec.losses_paid := -paid_rids_rec.losses_paid;
                    END IF;

                    IF SIGN (NVL (paid_ds_rec.expenses_paid, 0)) <> 1 AND SIGN (NVL (paid_rids_rec.expenses_paid, 0)) = 1 THEN
                        paid_rids_rec.expenses_paid := -paid_rids_rec.expenses_paid;
                    END IF;

                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

                    INSERT INTO gicl_res_brdrx_rids_extr
                               (session_id, brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd, buss_source,
                                line_cd, subline_cd,
                                loss_year, item_no,
                                peril_cd, loss_cat_cd,
                                grp_seq_no, ri_cd,
                                prnt_ri_cd,
                                shr_ri_pct,
                                losses_paid,
                                expenses_paid, user_id, last_update
                               )
                        VALUES (p_session_id, v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id, paid_ds_rec.claim_id,
                                paid_ds_rec.iss_cd, paid_ds_rec.buss_source,
                                paid_ds_rec.line_cd, paid_ds_rec.subline_cd,
                                paid_ds_rec.loss_year, paid_ds_rec.item_no,
                                paid_ds_rec.peril_cd, paid_ds_rec.loss_cat_cd,
                                paid_ds_rec.grp_seq_no, paid_rids_rec.ri_cd,
                                paid_rids_rec.prnt_ri_cd,
                                paid_rids_rec.shr_ri_pct_real,
                                paid_rids_rec.losses_paid,
                                paid_rids_rec.expenses_paid, p_user_id, SYSDATE
                               );
                END;
            END LOOP;
        END LOOP;
    END eplp_extract_distribution;
    /*eplp - EXTRACT_PAID_LE_POLICY end*/
    
    /*eple - EXTRACT_PAID_LE_ENROLLEE start*/
    PROCEDURE eple_extract_all(
        p_user_id               IN giis_users.user_id%TYPE, 
        p_session_id            IN gicl_res_brdrx_extr.session_id%TYPE,
        p_brdrx_rep_type        IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_pd_date_opt           IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
        p_from_date             IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date               IN gicl_res_brdrx_extr.to_date%TYPE,
        p_enrollee              IN gicl_accident_dtl.grouped_item_title%TYPE,
        p_control_type          IN gicl_accident_dtl.control_type_cd%TYPE,
        p_control_number        IN gicl_accident_dtl.control_cd%TYPE,
        p_brdrx_record_id       IN NUMBER
    ) IS
        v_brdrx_record_id       gicl_res_brdrx_extr.brdrx_record_id%TYPE; 
    BEGIN
        v_brdrx_record_id := p_brdrx_record_id;
        
        FOR paid_rec IN (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                                (b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                                DECODE (p_brdrx_rep_type,1, SUM (a.losses_paid) * NVL (a.convert_rate, 1),
                                                         2, SUM (a.expenses_paid) * NVL (a.convert_rate, 1),NULL) claims_paid,
                                SUM (a.losses_paid) * NVL (a.convert_rate, 1) losspaid,
                                SUM (a.expenses_paid) * NVL (a.convert_rate, 1) expensepaid,
                                a.clm_loss_id, a.dist_no, f.line_cd, f.subline_cd,
                                f.iss_cd, f.issue_yy, f.pol_seq_no, f.renew_no,
                                TO_NUMBER (TO_CHAR (f.loss_date, 'YYYY')) loss_year,f.assd_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_seq_no, '0999999'))
                                ) claim_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.pol_iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.renew_no, '09'))
                                ) policy_no,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date, g.grouped_item_title,
                                g.control_cd, g.control_type_cd
                           FROM gicl_item_peril b,gicl_clm_res_hist a,giac_acctrans d,gicl_claims f,gicl_accident_dtl g
                          WHERE a.peril_cd = b.peril_cd
                            AND a.item_no = b.item_no
                            AND a.claim_id = b.claim_id
                            AND a.tran_id = d.tran_id
                            AND b.claim_id = f.claim_id
                            AND a.tran_id IS NOT NULL
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                            AND DECODE (a.cancel_tag,'Y', TRUNC (a.cancel_date),p_to_date + 1) > p_to_date
                            AND DECODE (p_pd_date_opt,1, TRUNC (a.date_paid),
                                                      2, TRUNC (d.posting_date)) BETWEEN p_from_date AND p_to_date
                            AND d.tran_flag != 'D'
                            AND DECODE (p_brdrx_rep_type,1, NVL (a.losses_paid, 0),
                                                         2, NVL (a.expenses_paid, 0),1) > 0
                            AND g.grouped_item_title IS NOT NULL
                            AND g.grouped_item_title = NVL (p_enrollee, g.grouped_item_title)
                            AND NVL (g.control_type_cd, 0) = NVL (p_control_type, NVL (g.control_type_cd, 0))
                            AND NVL (g.control_cd, 0) = NVL (p_control_number, NVL (g.control_cd, 0))
                            AND a.claim_id = g.claim_id
                            AND a.item_no = g.item_no
                            AND a.grouped_item_no = g.grouped_item_no
                            AND (TRUNC(a.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                                 OR a.cancel_date IS NULL)
                          GROUP BY b.claim_id,
                                b.item_no,
                                b.peril_cd,
                                b.loss_cat_cd,
                                b.ann_tsi_amt,
                                a.clm_loss_id,
                                a.dist_no,
                                NVL (a.convert_rate, 1),
                                f.claim_id,
                                f.line_cd,
                                f.subline_cd,
                                f.iss_cd,
                                f.issue_yy,
                                f.pol_seq_no,
                                f.renew_no,
                                f.loss_date,
                                f.assd_no,
                                f.clm_yy,
                                f.clm_seq_no,
                                f.pol_iss_cd,
                                f.dsp_loss_date,
                                f.loss_date,
                                f.clm_file_date,
                                f.pol_eff_date,
                                f.expiry_date,
                                g.grouped_item_title,
                                g.control_cd,
                                g.control_type_cd
                         UNION
                         SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,(b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                                DECODE (p_brdrx_rep_type,1, - (SUM (a.losses_paid) * NVL (a.convert_rate, 1)),
                                                         2, - (SUM (a.expenses_paid) * NVL (a.convert_rate, 1)),NULL) claims_paid,
                                -SUM (a.losses_paid) * NVL (a.convert_rate, 1) losspaid,
                                -SUM (a.expenses_paid) * NVL (a.convert_rate, 1) expensepaid, a.clm_loss_id,
                                a.dist_no, f.line_cd, f.subline_cd, f.iss_cd, f.issue_yy,
                                f.pol_seq_no, f.renew_no,
                                TO_NUMBER (TO_CHAR (f.loss_date, 'YYYY')) loss_year,
                                f.assd_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.clm_seq_no, '0999999'))
                                ) claim_no,
                                (   f.line_cd
                                 || '-'
                                 || f.subline_cd
                                 || '-'
                                 || f.pol_iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (f.issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (f.renew_no, '09'))
                                ) policy_no,
                                f.dsp_loss_date, f.loss_date, f.clm_file_date,
                                f.pol_eff_date, f.expiry_date, g.grouped_item_title,
                                g.control_cd, g.control_type_cd
                           FROM gicl_item_peril b,gicl_clm_res_hist a,giac_acctrans d,giac_reversals e,gicl_claims f,gicl_accident_dtl g
                          WHERE a.peril_cd = b.peril_cd
                            AND a.item_no = b.item_no
                            AND a.claim_id = b.claim_id
                            AND a.tran_id = e.gacc_tran_id
                            AND d.tran_id = e.reversing_tran_id
                            AND b.claim_id = f.claim_id
                            AND check_user_per_iss_cd (f.line_cd, f.iss_cd, 'GICLS202') = 1
                            AND a.tran_id IS NOT NULL
                            AND TRUNC (a.date_paid) < p_from_date 
                            AND g.grouped_item_title IS NOT NULL
                            AND a.claim_id = g.claim_id
                            AND a.item_no = g.item_no
                            AND a.grouped_item_no = g.grouped_item_no
                            AND g.grouped_item_title = NVL (p_enrollee, g.grouped_item_title)
                            AND NVL (g.control_type_cd, 0) = NVL (p_control_type, NVL (g.control_type_cd, 0))
                            AND NVL (g.control_cd, 0) = NVL (p_control_number, NVL (g.control_cd, 0))
                            AND clm_stat_cd NOT IN ('WD', 'DN', 'CC')
                            AND DECODE (p_pd_date_opt,1,  TRUNC(a.cancel_date),
                                                      2, TRUNC (d.posting_date)) BETWEEN p_from_date AND p_to_date
                            AND (cancel_tag <> 'N' and cancel_tag is not null)
                          GROUP BY b.claim_id,
                                b.item_no,
                                b.peril_cd,
                                b.loss_cat_cd,
                                b.ann_tsi_amt,
                                a.clm_loss_id,
                                a.dist_no,
                                NVL (a.convert_rate, 1),
                                f.claim_id,
                                f.line_cd,
                                f.subline_cd,
                                f.iss_cd,
                                f.issue_yy,
                                f.pol_seq_no,
                                f.renew_no,
                                f.loss_date,
                                f.assd_no,
                                f.clm_yy,
                                f.clm_seq_no,
                                f.pol_iss_cd,
                                f.dsp_loss_date,
                                f.loss_date,
                                f.clm_file_date,
                                f.pol_eff_date,
                                f.expiry_date,
                                g.grouped_item_title,
                                g.control_cd,
                                g.control_type_cd
                          ORDER BY 1)
        LOOP
            BEGIN
                v_brdrx_record_id := v_brdrx_record_id + 1;
                
                IF p_brdrx_rep_type = 1 AND ABS(paid_rec.losspaid) > 0 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id,
                                claim_id, iss_cd,
                                line_cd, subline_cd,
                                loss_year, assd_no,
                                claim_no, policy_no,
                                loss_date, clm_file_date,
                                item_no, peril_cd,
                                loss_cat_cd, incept_date,
                                expiry_date, tsi_amt,
                                clm_loss_id, losses_paid,
                                dist_no, user_id, last_update, extr_type,
                                brdrx_type, brdrx_rep_type, pd_date_opt,
                                from_date, TO_DATE,
                                enrollee,
                                control_type, control_number, enrollee_tag
                               )
                        VALUES (p_session_id, v_brdrx_record_id,
                                paid_rec.claim_id, paid_rec.iss_cd,
                                paid_rec.line_cd, paid_rec.subline_cd,
                                paid_rec.loss_year, paid_rec.assd_no,
                                paid_rec.claim_no, paid_rec.policy_no,
                                paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                                paid_rec.item_no, paid_rec.peril_cd,
                                paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                                paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                                paid_rec.clm_loss_id, paid_rec.claims_paid,
                                paid_rec.dist_no, p_user_id, SYSDATE, 1,
                                2, p_brdrx_rep_type, p_pd_date_opt,
                                p_from_date, p_to_date,
                                paid_rec.grouped_item_title,
                                paid_rec.control_type_cd, paid_rec.control_cd, 1
                               );
                ELSIF p_brdrx_rep_type = 2 AND ABS(paid_rec.expensepaid) > 0 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id,
                                claim_id, iss_cd,
                                line_cd, subline_cd,
                                loss_year, assd_no,
                                claim_no, policy_no,
                                loss_date, clm_file_date,
                                item_no, peril_cd,
                                loss_cat_cd, incept_date,
                                expiry_date, tsi_amt,
                                clm_loss_id, expenses_paid,
                                dist_no, user_id, last_update, extr_type,
                                brdrx_type, brdrx_rep_type, pd_date_opt,
                                from_date, TO_DATE,
                                enrollee,
                                control_type, control_number, enrollee_tag
                               )
                        VALUES (p_session_id, v_brdrx_record_id,
                                paid_rec.claim_id, paid_rec.iss_cd,
                                paid_rec.line_cd, paid_rec.subline_cd,
                                paid_rec.loss_year, paid_rec.assd_no,
                                paid_rec.claim_no, paid_rec.policy_no,
                                paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                                paid_rec.item_no, paid_rec.peril_cd,
                                paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                                paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                                paid_rec.clm_loss_id, paid_rec.claims_paid,
                                paid_rec.dist_no, p_user_id, SYSDATE, 1,
                                2, p_brdrx_rep_type, p_pd_date_opt,
                                p_from_date, p_to_date,
                                paid_rec.grouped_item_title,
                                paid_rec.control_type_cd, paid_rec.control_cd, 1
                               );
                ELSIF p_brdrx_rep_type = 3 THEN
                    INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id,
                                claim_id, iss_cd,
                                line_cd, subline_cd,
                                loss_year, assd_no,
                                claim_no, policy_no,
                                loss_date, clm_file_date,
                                item_no, peril_cd,
                                loss_cat_cd, incept_date,
                                expiry_date, tsi_amt,
                                clm_loss_id, losses_paid,
                                expenses_paid, dist_no, user_id,
                                last_update, extr_type, brdrx_type,
                                brdrx_rep_type, pd_date_opt, from_date,
                                TO_DATE, enrollee,
                                control_type, control_number, enrollee_tag
                               )
                        VALUES (p_session_id, v_brdrx_record_id,
                                paid_rec.claim_id, paid_rec.iss_cd,
                                paid_rec.line_cd, paid_rec.subline_cd,
                                paid_rec.loss_year, paid_rec.assd_no,
                                paid_rec.claim_no, paid_rec.policy_no,
                                paid_rec.dsp_loss_date, paid_rec.clm_file_date,
                                paid_rec.item_no, paid_rec.peril_cd,
                                paid_rec.loss_cat_cd, paid_rec.pol_eff_date,
                                paid_rec.expiry_date, paid_rec.ann_tsi_amt,
                                paid_rec.clm_loss_id, paid_rec.losspaid,
                                paid_rec.expensepaid, paid_rec.dist_no, p_user_id,
                                SYSDATE, 1, 2,
                                p_brdrx_rep_type, p_pd_date_opt, p_from_date,
                                p_to_date, paid_rec.grouped_item_title,
                                paid_rec.control_type_cd, paid_rec.control_cd, 1
                               );
                END IF;
            END;
        END LOOP;
    END eple_extract_all;
    
    PROCEDURE eple_extract_distribution(
        p_user_id               IN giis_users.user_id%TYPE,
        p_session_id            IN gicl_res_brdrx_ds_extr.session_id%TYPE,
        p_brdrx_rep_type        IN gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
        p_from_date             IN gicl_res_brdrx_extr.from_date%TYPE,
        p_to_date               IN gicl_res_brdrx_extr.to_date%TYPE,
        p_brdrx_ds_record_id    IN NUMBER,
        p_brdrx_rids_record_id  IN NUMBER
    ) IS
        v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
        v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
    BEGIN
        v_brdrx_ds_record_id := p_brdrx_ds_record_id;
        v_brdrx_rids_record_id := p_brdrx_rids_record_id;
        
        FOR paid_ds_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.clm_loss_id, a.grp_seq_no, a.shr_loss_exp_pct,         
                                   DECODE(get_payee_type (b.claim_id, b.clm_loss_id),'L', DECODE (p_brdrx_rep_type,1, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),
                                                                                                                   3, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),NULL),0) losses_paid,
                                   DECODE(get_payee_type (b.claim_id, b.clm_loss_id),'E', DECODE (p_brdrx_rep_type,2, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),
                                                                                                                   3, SUM (  a.shr_le_net_amt * NVL (b.convert_rate,1)),NULL),0) expenses_paid,         
                                   a.clm_dist_no, c.brdrx_record_id, c.iss_cd, c.buss_source, c.line_cd,
                                   c.subline_cd, c.loss_year, c.loss_cat_cd,
                                   c.losses_paid brdrx_extr_losses_paid,
                                   c.expenses_paid brdrx_extr_expenses_paid
                              FROM gicl_loss_exp_ds a, gicl_clm_res_hist b, gicl_res_brdrx_extr c
                             WHERE c.session_id = p_session_id
                               AND a.claim_id = c.claim_id
                               AND a.item_no = c.item_no
                               AND a.peril_cd = c.peril_cd
                               AND a.clm_dist_no = c.dist_no
                               AND a.clm_loss_id = c.clm_loss_id
                               AND a.claim_id = b.claim_id
                               AND a.clm_loss_id = b.clm_loss_id
                               AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                               AND DECODE (b.cancel_tag,'Y', TRUNC (b.cancel_date),p_to_date + 1) > p_to_date
                               AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                                    OR b.cancel_date IS NULL)
                             GROUP BY a.claim_id,
                                   a.item_no,
                                   a.peril_cd,
                                   a.clm_loss_id,
                                   a.grp_seq_no,
                                   a.shr_loss_exp_pct,
                                   a.clm_dist_no,
                                   get_payee_type (b.claim_id, b.clm_loss_id),
                                   c.brdrx_record_id,
                                   c.iss_cd,
                                   c.buss_source,
                                   c.line_cd,
                                   c.subline_cd,
                                   c.loss_year,
                                   c.loss_cat_cd,
                                   c.losses_paid,
                                   c.expenses_paid)
        LOOP
            BEGIN
                IF SIGN (NVL (paid_ds_rec.brdrx_extr_losses_paid, 0)) <> 1 AND SIGN (NVL (paid_ds_rec.losses_paid, 0)) = 1 THEN
                    paid_ds_rec.losses_paid := -paid_ds_rec.losses_paid;
                END IF;

                IF SIGN (NVL (paid_ds_rec.brdrx_extr_expenses_paid, 0)) <> 1 AND SIGN (NVL (paid_ds_rec.expenses_paid, 0)) = 1 THEN
                    paid_ds_rec.expenses_paid := -paid_ds_rec.expenses_paid;
                END IF;

                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

                INSERT INTO gicl_res_brdrx_ds_extr
                           (session_id, brdrx_record_id,
                            brdrx_ds_record_id, claim_id,
                            iss_cd, buss_source,
                            line_cd, subline_cd,
                            loss_year, item_no,
                            peril_cd, loss_cat_cd,
                            grp_seq_no,
                            shr_pct,
                            losses_paid, expenses_paid,
                            user_id, last_update)
                    VALUES (p_session_id, paid_ds_rec.brdrx_record_id,
                            v_brdrx_ds_record_id, paid_ds_rec.claim_id,
                            paid_ds_rec.iss_cd, paid_ds_rec.buss_source,
                            paid_ds_rec.line_cd, paid_ds_rec.subline_cd,
                            paid_ds_rec.loss_year, paid_ds_rec.item_no,
                            paid_ds_rec.peril_cd, paid_ds_rec.loss_cat_cd,
                            paid_ds_rec.grp_seq_no,
                            paid_ds_rec.shr_loss_exp_pct,
                            paid_ds_rec.losses_paid, paid_ds_rec.expenses_paid,
                            p_user_id, SYSDATE);
            END;
            
            FOR paid_rids_rec IN (SELECT a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct shr_ri_pct_real,                 
                                         DECODE (p_brdrx_rep_type,1, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),
                                                                  3, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),NULL) losses_paid,
                                         DECODE (p_brdrx_rep_type,2, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),
                                                                  3, SUM (  a.shr_le_ri_net_amt * NVL (b.convert_rate, 1)),NULL) expenses_paid
                                    FROM gicl_loss_exp_rids a, gicl_clm_res_hist b, gicl_claims c
                                   WHERE a.claim_id = paid_ds_rec.claim_id
                                     AND a.item_no = paid_ds_rec.item_no
                                     AND a.peril_cd = paid_ds_rec.peril_cd
                                     AND a.clm_loss_id = paid_ds_rec.clm_loss_id
                                     AND a.clm_dist_no = paid_ds_rec.clm_dist_no
                                     AND a.grp_seq_no = paid_ds_rec.grp_seq_no
                                     AND a.claim_id = b.claim_id
                                     AND a.clm_loss_id = b.clm_loss_id
                                     AND a.claim_id = c.claim_id
                                     AND check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202') = 1
                                     AND DECODE (b.cancel_tag,'Y', TRUNC (b.cancel_date),p_to_date + 1) > p_to_date
                                     AND (TRUNC(b.cancel_date) NOT BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                                          OR b.cancel_date IS NULL)
                                   GROUP BY a.claim_id, a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct)
            LOOP
                BEGIN
                    IF SIGN (NVL (paid_ds_rec.losses_paid, 0)) <> 1 AND SIGN (NVL (paid_rids_rec.losses_paid, 0)) = 1 THEN
                        paid_rids_rec.losses_paid := -paid_rids_rec.losses_paid;
                    END IF;

                    IF SIGN (NVL (paid_ds_rec.expenses_paid, 0)) <> 1 AND SIGN (NVL (paid_rids_rec.expenses_paid, 0)) = 1 THEN
                        paid_rids_rec.expenses_paid := -paid_rids_rec.expenses_paid;
                    END IF;

                    v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

                    INSERT INTO gicl_res_brdrx_rids_extr
                               (session_id, brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd, buss_source,
                                line_cd, subline_cd,
                                loss_year, item_no,
                                peril_cd, loss_cat_cd,
                                grp_seq_no, ri_cd,
                                prnt_ri_cd,
                                shr_ri_pct,
                                losses_paid,
                                expenses_paid, user_id, last_update
                               )
                        VALUES (p_session_id, v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id, paid_ds_rec.claim_id,
                                paid_ds_rec.iss_cd, paid_ds_rec.buss_source,
                                paid_ds_rec.line_cd, paid_ds_rec.subline_cd,
                                paid_ds_rec.loss_year, paid_ds_rec.item_no,
                                paid_ds_rec.peril_cd, paid_ds_rec.loss_cat_cd,
                                paid_ds_rec.grp_seq_no, paid_rids_rec.ri_cd,
                                paid_rids_rec.prnt_ri_cd,
                                paid_rids_rec.shr_ri_pct_real,
                                paid_rids_rec.losses_paid,
                                paid_rids_rec.expenses_paid, p_user_id, SYSDATE
                               );
                END;
            END LOOP;
        END LOOP;
        
    END eple_extract_distribution;
    /*eple - EXTRACT_PAID_LE_ENROLLEE end*/
    
    FUNCTION validate_line_cd2_gicls202(
        p_dsp_line_cd2      IN giis_subline.line_cd%TYPE,
        p_dsp_iss_cd2       IN giis_issource.iss_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_line_cd           giis_line.line_cd%TYPE;
    BEGIN
        SELECT line_cd 
          INTO v_line_cd 
          FROM giis_line a
         WHERE check_user_per_iss_cd (a.line_cd, NVL(p_dsp_iss_cd2,NULL), 'GICLS202') = 1
           AND line_cd = p_dsp_line_cd2;
         
        RETURN v_line_cd;
    END validate_line_cd2_gicls202;
    
    FUNCTION validate_subline_cd2_gicls202(
        p_dsp_line_cd2      IN giis_subline.line_cd%TYPE,
        p_dsp_subline_cd2   IN giis_subline.subline_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_subline_cd        giis_subline.subline_cd%TYPE;
    BEGIN
        SELECT subline_cd
          INTO v_subline_cd
          FROM giis_subline
         WHERE line_cd = p_dsp_line_cd2
           AND subline_cd = p_dsp_subline_cd2;
           
        RETURN v_subline_cd;
    END validate_subline_cd2_gicls202;
    
    FUNCTION validate_iss_cd2_gicls202(
        p_dsp_line_cd2      IN giis_subline.line_cd%TYPE,
        p_dsp_iss_cd2       IN giis_issource.iss_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_iss_cd            giis_issource.iss_cd%TYPE;
    BEGIN
        SELECT iss_cd 
          INTO v_iss_cd
          FROM giis_issource a
         WHERE check_user_per_iss_cd (NVL(p_dsp_line_cd2,NULL), a.iss_cd, 'GICLS202') = 1
           AND iss_cd = p_dsp_iss_cd2;
           
        RETURN v_iss_cd;
    END validate_iss_cd2_gicls202;
    
    FUNCTION validate_line_cd_gicls202(
        p_dsp_line_cd       IN giis_line.line_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_line_name         giis_line.line_name%TYPE;
    BEGIN
        SELECT line_name
          INTO v_line_name
          FROM giis_line
         WHERE line_cd = p_dsp_line_cd;
         
        RETURN v_line_name;
    END validate_line_cd_gicls202;
    
    FUNCTION validate_subline_cd_gicls202(
        p_dsp_line_cd       IN giis_subline.line_cd%TYPE,
        p_dsp_subline_cd    IN giis_subline.subline_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_subline_name  giis_subline.subline_name%TYPE;
    BEGIN
        SELECT subline_name
          INTO v_subline_name
          FROM giis_subline
         WHERE line_cd = p_dsp_line_cd
           AND subline_cd = p_dsp_subline_cd;
           
        RETURN v_subline_name;
    END validate_subline_cd_gicls202;
    
    FUNCTION validate_iss_cd_gicls202(
        p_dsp_iss_cd        IN giis_issource.iss_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_iss_name          giis_issource.iss_name%TYPE;
    BEGIN
        SELECT iss_name
          INTO v_iss_name
          FROM giis_issource
         WHERE iss_cd = p_dsp_iss_cd;
         
        RETURN v_iss_name;
    END validate_iss_cd_gicls202;
    
    FUNCTION validate_loss_cat_cd_gicls202(
        p_dsp_line_cd       IN giis_line.line_cd%TYPE,
        p_dsp_loss_cat_cd   IN giis_loss_ctgry.loss_cat_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE;
    BEGIN
        SELECT loss_cat_des
          INTO v_loss_cat_des
          FROM giis_loss_ctgry
         WHERE line_cd = p_dsp_line_cd
           AND loss_cat_cd = p_dsp_loss_cat_cd;
           
        RETURN v_loss_cat_des;
    END validate_loss_cat_cd_gicls202;
    
    FUNCTION validate_peril_cd_gicls202(
        p_dsp_line_cd       IN giis_line.line_cd%TYPE,
        p_dsp_peril_cd      IN giis_peril.peril_cd%TYPE
    ) RETURN VARCHAR2 IS
        v_peril_name        giis_peril.peril_name%TYPE;
    BEGIN
        SELECT peril_name
          INTO v_peril_name
          FROM giis_peril
         WHERE line_cd = p_dsp_line_cd
           AND peril_cd = p_dsp_peril_cd;
           
        RETURN v_peril_name;
    END validate_peril_cd_gicls202;
    
    FUNCTION validate_intm_no_gicls202(
        p_dsp_intm_no       IN giis_intermediary.intm_no%TYPE        
    ) RETURN VARCHAR2 IS
        v_intm_name         giis_intermediary.intm_name%TYPE;
    BEGIN
        SELECT intm_name
          INTO v_intm_name
          FROM giis_intermediary
         WHERE intm_no = p_dsp_intm_no;
         
        RETURN v_intm_name;                 
    END validate_intm_no_gicls202;
    
    FUNCTION validate_cntrl_typ_cd_gicls202(
        p_dsp_control_type_cd   IN giis_control_type.control_type_cd%TYPE        
    ) RETURN VARCHAR2 IS
        v_control_type_desc     giis_control_type.control_type_desc%TYPE;
    BEGIN
        SELECT control_type_desc
          INTO v_control_type_desc
          FROM giis_control_type
         WHERE control_type_cd = p_dsp_control_type_cd;
           
        RETURN v_control_type_desc;
    END validate_cntrl_typ_cd_gicls202;
    
    FUNCTION get_line_cd_gicls202_lov(
        p_dsp_iss_cd        giis_issource.iss_cd%TYPE,
        p_dsp_iss_cd2       giis_issource.iss_cd%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE
    ) RETURN line_listing_tab PIPELINED IS
        res                 line_listing_type;
        v_iss_cd            giis_issource.iss_cd%TYPE;
    BEGIN
        v_iss_cd := NVL(p_dsp_iss_cd, p_dsp_iss_cd2);
    
        FOR i IN (SELECT line_cd, line_name 
                    FROM giis_line a
                   WHERE check_user_per_iss_cd2 (a.line_cd, NVL(v_iss_cd,NULL), p_module_id, p_user_id) = 1 
                   ORDER BY line_cd, line_name)
        LOOP
            res.line_cd := i.line_cd;
            res.line_name := i.line_name;
            
            PIPE ROW(res);
        END LOOP;
    END get_line_cd_gicls202_lov;
    
    FUNCTION get_subline_cd2_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE,
        p_dsp_line_cd2      giis_line.line_cd%TYPE,
        p_per_policy        NUMBER   
    ) RETURN subline_listing_tab PIPELINED IS
        res                 subline_listing_type;
    BEGIN
        FOR i IN (SELECT subline_cd, subline_name 
                    FROM giis_subline 
                   WHERE line_cd = DECODE(p_per_policy, 1, NVL(p_dsp_line_cd2, line_cd), NVL(p_dsp_line_cd, line_cd))  
                   ORDER BY subline_cd, subline_name)
        LOOP
            res.subline_cd := i.subline_cd;
            res.subline_name := i.subline_name;
            
            PIPE ROW(res);
        END LOOP;
    END get_subline_cd2_gicls202_lov;
    
    FUNCTION get_iss_cd2_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE,
        p_dsp_line_cd2      giis_line.line_cd%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE
    ) RETURN issource_listing_tab PIPELINED IS
        res                 issource_listing_type;
        v_line_cd           giis_line.line_cd%TYPE;
    BEGIN
        v_line_cd := NVL(p_dsp_line_cd, p_dsp_line_cd2);
    
        FOR i IN (SELECT iss_cd, iss_name 
                    FROM giis_issource a
                   WHERE check_user_per_iss_cd2 (NVL(v_line_cd,NULL), a.iss_cd, p_module_id, p_user_id) = 1
                   ORDER BY iss_cd, iss_name)
        LOOP
            res.iss_cd := i.iss_cd;
            res.iss_name := i.iss_name;
            
            PIPE ROW(res);
        END LOOP;
    END get_iss_cd2_gicls202_lov;
    
    FUNCTION get_peril_cd_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE
    ) RETURN peril_listing_tab PIPELINED IS
        res                 peril_listing_type;
    BEGIN
        FOR i IN (SELECT peril_cd, peril_name 
                    FROM giis_peril 
                   WHERE line_cd = NVL(p_dsp_line_cd, line_cd) 
                   ORDER BY peril_cd, peril_name)
        LOOP
            res.peril_cd := i.peril_cd;
            res.peril_name := i.peril_name;
            
            PIPE ROW(res);
        END LOOP;
    END get_peril_cd_gicls202_lov;
    
    FUNCTION get_loss_cat_cd_gicls202_lov(
        p_dsp_line_cd       giis_line.line_cd%TYPE
    ) RETURN loss_cat_listing_tab PIPELINED IS
        res                 loss_cat_listing_type;
    BEGIN
        FOR i IN (SELECT loss_cat_cd, loss_cat_des
                    FROM giis_loss_ctgry 
                   WHERE line_cd = NVL(p_dsp_line_cd, line_cd) 
                   ORDER BY loss_cat_cd, loss_cat_des)
        LOOP
            res.loss_cat_cd := i.loss_cat_cd;
            res.loss_cat_desc := i.loss_cat_des;
            
            PIPE ROW(res);
        END LOOP;
    END get_loss_cat_cd_gicls202_lov;
    
    FUNCTION get_intm_no_gicls202_lov
    RETURN intm_listing_tab PIPELINED IS
        res                 intm_listing_type;
    BEGIN
        FOR i IN (SELECT intm_no, intm_name 
                    FROM giis_intermediary 
                   ORDER BY intm_no)
        LOOP
            res.intm_no := i.intm_no;
            res.intm_name := i.intm_name;
            
            PIPE ROW(res);
        END LOOP;
    END get_intm_no_gicls202_lov;
    
    FUNCTION get_cntrl_type_cd_gicls202_lov
    RETURN control_type_cd_listing_tab PIPELINED IS
        res                 control_type_cd_listing_type;
    BEGIN
        FOR i IN (SELECT control_type_cd, control_type_desc 
                    FROM giis_control_type 
                   ORDER BY control_type_cd)
        LOOP
            res.control_type_cd := i.control_type_cd;
            res.control_type_desc := i.control_type_desc;
            
            PIPE ROW(res);
        END LOOP;
    END get_cntrl_type_cd_gicls202_lov;
    
   FUNCTION get_enrollee_lov
   RETURN enrollee_tab PIPELINED AS
      v_list            enrollee_type;
   BEGIN
      FOR i IN (SELECT DISTINCT grouped_item_title
                  FROM gicl_accident_dtl
                 WHERE grouped_item_title IS NOT NULL
                 ORDER BY 1)
      LOOP
         v_list.grouped_item_title := i.grouped_item_title;
         
         PIPE ROW(v_list);
      END LOOP;
   END; 
    
    PROCEDURE print_gicls202(
        p_user_id           IN  gicl_res_brdrx_extr.user_id%TYPE,
        p_rep_name          IN  gicl_res_brdrx_extr.extr_type%TYPE,
        p_session_id        OUT gicl_res_brdrx_extr.session_id%TYPE,
        p_message           OUT VARCHAR2,
        p_exist             OUT VARCHAR2
    ) IS
        v_session_id        gicl_res_brdrx_extr.session_id%TYPE;
        v_ext_date          gicl_res_brdrx_extr.last_update%TYPE;
    BEGIN
        FOR I IN (SELECT MAX(CAST(session_id AS INT)) session_id --Jerome 05052015. Added CAST function to convert the data to INT to get 
                      FROM gicl_res_brdrx_extr                   --the correct max value.
                   WHERE user_id = p_user_id)
        LOOP
              v_session_id := NVL(i.session_id, 0);
        END LOOP;
        
        IF v_session_id > 0 THEN
            SELECT max(last_update)
              INTO v_ext_date
              FROM gicl_res_brdrx_extr 
             WHERE session_id = v_session_id;

--            IF TO_DATE(TO_CHAR(v_ext_date,'MM-DD-YYYY'), 'MM-DD-YYYY') <> TO_DATE(TO_CHAR(SYSDATE, 'MM-DD-YYYY'), 'MM-DD-YYYY') THEN
--                p_message := 'Last extraction was made ' || INITCAP(TO_CHAR(v_ext_date,'fmmonth dd, yyyy')) || '. Print records from last extraction?';
--            END IF;
        ELSE
            --p_message := 'User has not run extraction yet, please perform extraction before printing.';
            p_message := 'Please extract records first.';
        END IF;
        
        p_exist := NULL;
        
        IF p_rep_name = 1 THEN
            FOR i IN (SELECT DISTINCT 'X' x
                        FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                       WHERE a.line_cd = b.line_cd
                         AND a.grp_seq_no = b.share_cd
                         AND share_type = giacp.v('XOL_TRTY_SHARE_TYPE'))
            LOOP
                p_exist := i.x;
            END LOOP;
        END IF;
        
        p_session_id := v_session_id;
    END print_gicls202;
    
    PROCEDURE extract_gicls202_web( p_user_id               gicl_res_brdrx_extr.user_id%TYPE,
                                    p_rep_name              gicl_res_brdrx_extr.extr_type%TYPE,     -- (1-Bordereaux or 2-Claims Register)
                                    p_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE,    -- (1-Outstanding or 2-Losses Paid)
                                    p_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE,   -- (1-Loss Date, 2-Claim File Date, 3-Booking Month)
                                    p_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE,-- (1-Loss, 2-Expense, 3-Loss+Expense)
                                    p_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE,       -- Reserve Tag (1 or 0)
                                    p_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE,   -- (1-Tran Date or 2-Posting Date)
                                    p_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Business Source (1 or 0) - under Bordereaux option
                                    p_per_issource          gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Issue Source (1 or 0) - under Bordereaux option
                                    p_per_line_subline      gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Bordereaux option
                                    p_per_policy            NUMBER,                                 -- Per Policy (1 or 0)- under Bordereaux option
                                    p_per_enrollee          NUMBER,                                 -- Per Enrollee (1 or 0)- under Bordereaux option
                                    p_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE,   -- Per Line/Subline (1 or 0) - under Claims Register option
                                    p_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE,    -- Per Branch (1 or 0) - under Claims Register option
                                    p_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE,      -- Per Intermediary (1 or 0) - under Claims Register option
                                    p_per_loss_cat          gicl_res_brdrx_extr.loss_cat_tag%TYPE,  -- Per Loss Category (1 or 2) - under Claims Register option
                                    p_dsp_from_date         gicl_res_brdrx_extr.from_date%TYPE,     -- By Period From Date  
                                    p_dsp_to_date           gicl_res_brdrx_extr.to_date%TYPE,       -- By Period To Date
                                    p_dsp_as_of_date        gicl_res_brdrx_extr.to_date%TYPE,       -- As of Date
                                    p_branch_option         gicl_res_brdrx_extr.branch_opt%TYPE,    -- Branch Parameter (1-Claim Iss Cd or 2-Policy Iss Cd)
                                    p_reg_button            gicl_res_brdrx_extr.reg_date_opt%TYPE,  -- (1-Loss Date or 2-Claim File Date)
                                    p_net_rcvry_chkbx       gicl_res_brdrx_extr.net_rcvry_tag%TYPE, -- Net of Recovery (Y or N)
                                    p_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE,-- Net of Recovery From Date
                                    p_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE, -- Net of Recovery To Date
                                    p_date_option           NUMBER,                                 -- (1-By Period or 2-As Of)
                                    p_dsp_line_cd           gicl_res_brdrx_extr.line_cd%TYPE,       -- Line
                                    p_dsp_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE,    -- Subline
                                    p_dsp_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,        -- Branch
                                    p_dsp_loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE,   -- Loss Category (Claims Register option only)
                                    p_dsp_peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE,      -- Peril
                                    p_dsp_intm_no           gicl_res_brdrx_extr.intm_no%TYPE,       -- Intermediary Number
                                    p_dsp_line_cd2          gicl_res_brdrx_extr.line_cd%TYPE,       -- Line Code (Per Policy option only)
                                    p_dsp_subline_cd2       gicl_res_brdrx_extr.subline_cd%TYPE,    -- Subline Code (Per Policy option only)
                                    p_dsp_iss_cd2           gicl_res_brdrx_extr.iss_cd%TYPE,        -- Issue Code (Per Policy option only)
                                    p_issue_yy              gicl_res_brdrx_extr.pol_iss_cd%TYPE,    -- Issue Year (Per Policy option only)
                                    p_pol_seq_no            gicl_res_brdrx_extr.pol_seq_no%TYPE,    -- Policy Sequence Number (Per Policy option only)
                                    p_renew_no              gicl_res_brdrx_extr.renew_no%TYPE,      -- Renew Number (Per Policy option only)
                                    p_dsp_enrollee          gicl_res_brdrx_extr.enrollee%TYPE,      -- Enrollee Number (Per Enrollee option only)
                                    p_dsp_control_type      gicl_res_brdrx_extr.control_type%TYPE,  -- Control Type (Per Enrollee option only)
                                    p_dsp_control_number    gicl_res_brdrx_extr.control_number%TYPE,-- Control Number (Per Enrollee option only)
                                    p_count             OUT NUMBER
                                   ) AS
      v_user_id               gicl_res_brdrx_extr.user_id%TYPE;
      v_session_id            gicl_res_brdrx_extr.session_id%TYPE;
      v_rep_name              gicl_res_brdrx_extr.extr_type%TYPE;     -- (1-Bordereaux or 2-Claims Register)
      v_brdrx_type            gicl_res_brdrx_extr.brdrx_type%TYPE;    -- (1-Outstanding or 2-Losses Paid)
      v_brdrx_date_option     gicl_res_brdrx_extr.ol_date_opt%TYPE;   -- (1-Loss Date; 2-Claim File Date; 3-Booking Month)
      v_brdrx_option          gicl_res_brdrx_extr.brdrx_rep_type%TYPE;-- (1-Loss; 2-Expense; 3-Loss+Expense)
      v_dsp_gross_tag         gicl_res_brdrx_extr.res_tag%TYPE;       -- Reserve Tag (1 or 0)
      v_paid_date_option      gicl_res_brdrx_extr.pd_date_opt%TYPE;   -- (1-Tran Date or 2-Posting Date)
      v_per_intermediary      gicl_res_brdrx_extr.intm_tag%TYPE;      -- Per Business Source (1 or 0) - under Bordereaux option
      v_iss_break             gicl_res_brdrx_extr.iss_cd_tag%TYPE;    -- Per Issue Source (1 or 0) - under Bordereaux option
      v_subline_break         gicl_res_brdrx_extr.line_cd_tag%TYPE;   -- Per Line/Subline (1 or 0) - under Bordereaux option
      v_per_policy            NUMBER;                                 -- Per Policy (1 or 0)- under Bordereaux option
      v_per_enrollee          NUMBER;                                 -- Per Enrollee (1 or 0)- under Bordereaux option
      v_per_line              gicl_res_brdrx_extr.line_cd_tag%TYPE;   -- Per Line/Subline (1 or 0) - under Claims Register option
      v_per_iss               gicl_res_brdrx_extr.iss_cd_tag%TYPE;    -- Per Branch (1 or 0) - under Claims Register option
      v_per_buss              gicl_res_brdrx_extr.intm_tag%TYPE;      -- Per Intermediary (1 or 0) - under Claims Register option
      v_per_loss_cat          gicl_res_brdrx_extr.loss_cat_tag%TYPE;  -- Per Loss Category (1 or 2) - under Claims Register option
      v_dsp_from_date         gicl_res_brdrx_extr.from_date%TYPE;     -- By Period From Date  
      v_dsp_to_date           gicl_res_brdrx_extr.to_date%TYPE;       -- By Period To Date
      v_dsp_as_of_date        gicl_res_brdrx_extr.to_date%TYPE;       -- As of Date
      v_branch_option         gicl_res_brdrx_extr.branch_opt%TYPE;    -- Branch Parameter (1-Claim Iss Cd or 2-Policy Iss Cd)
      v_reg_button            gicl_res_brdrx_extr.reg_date_opt%TYPE;  -- (1-Loss Date or 2-Claim File Date)
      v_net_rcvry_chkbx       gicl_res_brdrx_extr.net_rcvry_tag%TYPE; -- (Y or N)
      v_dsp_rcvry_from_date   gicl_res_brdrx_extr.rcvry_from_date%TYPE;-- Net of Recovery From Date
      v_dsp_rcvry_to_date     gicl_res_brdrx_extr.rcvry_to_date%TYPE; -- Net of Recovery To Date
      v_date_option           NUMBER;                                 -- (1-By Period or 2-As Of)
      v_dsp_line_cd           gicl_res_brdrx_extr.line_cd%TYPE;       -- Line
      v_dsp_subline_cd        gicl_res_brdrx_extr.subline_cd%TYPE;    -- Subline
      v_dsp_iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE;        -- Branch
      v_dsp_loss_cat_cd       gicl_res_brdrx_extr.loss_cat_cd%TYPE;    -- Loss Category (Claims Register option only)
      v_dsp_peril_cd          gicl_res_brdrx_extr.peril_cd%TYPE;      -- Peril
      v_dsp_intm_no           gicl_res_brdrx_extr.intm_no%TYPE;       -- Intermediary Number
      v_dsp_line_cd2          gicl_res_brdrx_extr.line_cd%TYPE;       -- Line Code (Per Policy Option only)
      v_dsp_subline_cd2       gicl_res_brdrx_extr.subline_cd%TYPE;    -- Subline Code (Per Policy Option only)
      v_dsp_iss_cd2           gicl_res_brdrx_extr.iss_cd%TYPE;        -- Issue Code (Per Policy Option only)
      v_issue_yy              gicl_res_brdrx_extr.pol_iss_cd%TYPE;    -- Issue Year (Per Policy Option only)
      v_pol_seq_no            gicl_res_brdrx_extr.pol_seq_no%TYPE;    -- Policy Sequence Number (Per Policy Option only)
      v_renew_no              gicl_res_brdrx_extr.renew_no%TYPE;      -- Renew Number (Per Policy Option only)
      v_dsp_enrollee          gicl_res_brdrx_extr.enrollee%TYPE;      -- Enrollee Number (Per Enrollee option only)
      v_dsp_control_type      gicl_res_brdrx_extr.control_type%TYPE;  -- Control Type (Per Enrollee option only)
      v_dsp_control_number    gicl_res_brdrx_extr.control_number%TYPE; -- Control Number (Per Enrollee option only)
      v_brdrx_record_id       gicl_res_brdrx_extr.brdrx_record_id%TYPE;
      v_brdrx_ds_record_id    gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE;
      v_brdrx_rids_record_id  gicl_res_brdrx_rids_extr.brdrx_rids_record_id%TYPE;
      
      CURSOR claims_rec (
          p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
          p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
          p_iss_break           NUMBER,
          p_subline_break       NUMBER,
          p_dsp_gross_tag       gicl_res_brdrx_extr.res_tag%TYPE,
          p_brdrx_type          gicl_res_brdrx_extr.brdrx_type%TYPE,
          p_paid_date_option    gicl_res_brdrx_extr.pd_date_opt%TYPE,
          p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
          p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
          p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
          p_dsp_from_date       gicl_res_brdrx_extr.from_date%TYPE,
          p_dsp_to_date         gicl_res_brdrx_extr.to_date%TYPE,
          p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
          p_date_option         NUMBER,
          p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
          p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
          p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
          p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
          p_per_intermediary    gicl_res_brdrx_extr.intm_tag%TYPE, 
          p_per_policy          NUMBER,
          p_per_enrollee        NUMBER,
          p_dsp_line_cd2        gicl_res_brdrx_extr.line_cd%TYPE,  
          p_dsp_subline_cd2     gicl_res_brdrx_extr.subline_cd%TYPE, 
          p_dsp_iss_cd2         gicl_res_brdrx_extr.iss_cd%TYPE,  
          p_issue_yy            gicl_res_brdrx_extr.pol_iss_cd%TYPE, 
          p_pol_seq_no          gicl_res_brdrx_extr.pol_seq_no%TYPE,
          p_renew_no            gicl_res_brdrx_extr.renew_no%TYPE,
          p_dsp_enrollee        gicl_res_brdrx_extr.enrollee%TYPE,
          p_dsp_control_type    gicl_res_brdrx_extr.control_type%TYPE, 
          p_dsp_control_number  gicl_res_brdrx_extr.control_number%TYPE
       )
       IS
          SELECT p_session_id session_id, a.claim_id,
                 DECODE (p_iss_break, 1, a.iss_cd, 0, '0') iss_cd, 
                 --return RI Code if per intermediary else return 0
                 DECODE(p_per_intermediary, 1, a.ri_cd, 0) buss_source, a.line_cd,
                 DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                 TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year, a.assd_no,
                 get_claim_number (a.claim_id) claim_no,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                 ) policy_no,
                 a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                 c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                 a.expiry_date, c.ann_tsi_amt tsi_amt, 
                 DECODE(p_brdrx_option, 2, 0, c.loss_reserve) loss_reserve, --return zero loss reserve if extraction is only for Expense
                 DECODE(p_brdrx_option, 2, 0, DECODE(p_dsp_gross_tag, 1, 0, c.losses_paid)) losses_paid, --return zero losses paid if Reserve tag is tagged and if extraction is only for Expense
                 DECODE(p_brdrx_option, 1, 0, c.expense_reserve) expense_reserve, --return zero expense reserve if extraction is only for Loss
                 DECODE(p_brdrx_option, 1, 0, DECODE(p_dsp_gross_tag, 1, 0, c.expenses_paid)) expenses_paid, --return zero expenses paid if Reserve tag is tagged and if extraction is only for Loss
                 NVL(p_user_id, USER) user_id,
                 SYSDATE last_update, c.grouped_item_no, c.clm_res_hist_id, 
                 DECODE(p_per_policy, 1, a.pol_iss_cd, DECODE(p_per_enrollee, 1, a.pol_iss_cd, NULL)) pol_iss_cd, 
                 DECODE(p_per_policy, 1, a.issue_yy, DECODE(p_per_enrollee, 1, a.issue_yy, NULL)) issue_yy,
                 DECODE(p_per_policy, 1, a.pol_seq_no, DECODE(p_per_enrollee, 1, a.pol_seq_no, NULL)) pol_seq_no,
                 DECODE(p_per_policy, 1, a.renew_no, DECODE(p_per_enrollee, 1, a.renew_no, NULL)) renew_no,
                 c.grouped_item_title, c.control_cd, c.control_type_cd, z.ref_pol_no
            FROM gicl_claims a,
                 gipi_polbasic z,
                 (SELECT   a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                           (b.ann_tsi_amt * NVL (g.currency_rate, 1)) ann_tsi_amt, --user currency rate in table GICL_CLM_ITEM in converting TSI by MAC 09/12/2013.
                           /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0))) loss_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) losses_paid,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0))) expense_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) expenses_paid,
                           */
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0))) loss_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) losses_paid,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0))) expense_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) expenses_paid,
                           a.grouped_item_no, f.clm_res_hist_id,
                           DECODE(p_per_enrollee, 1, e.grouped_item_title, NULL) grouped_item_title,
                           DECODE(p_per_enrollee, 1, e.control_cd, NULL) control_cd,
                           DECODE(p_per_enrollee, 1, e.control_type_cd, NULL) control_type_cd
                      FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, 
                           (SELECT tran_id, tran_flag, posting_date
                              FROM giac_acctrans
                             WHERE p_brdrx_type = 2
                               AND tran_flag != 'D') d, --retrieve records from table giac_acctrans if Losses Paid is selected by MAC 06/11/2013.
                           (SELECT claim_id, item_no, grouped_item_no, grouped_item_title, control_type_cd, control_cd
                              FROM gicl_accident_dtl
                             WHERE p_per_enrollee = 1) e, --retrieve records from table gicl_accident_dtl if Per Enrollee is selected by MAC 06/11/2013.
                           (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no
                              FROM gicl_reserve_ds
                             WHERE NVL (negate_tag, 'N') <> 'Y'
                               AND p_brdrx_type != 2
                             UNION 
                            SELECT DISTINCT claim_id, item_no, peril_cd, NULL clm_res_hist_id, grouped_item_no
                              FROM gicl_loss_exp_ds
                             WHERE p_brdrx_type = 2) f,
                             gicl_clm_item g --added table to get convert rate of TSI amount instead of using convert rate in gicl_clm_res_hist by MAC 09/12/2013
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.claim_id = c.claim_id
                       AND DECODE(p_user_id, NULL, check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202'), --security in CS version
                                                   check_user_per_iss_cd2 (c.line_cd, c.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
                       AND ((DECODE(p_brdrx_date_option, 3, TO_DATE (   NVL (a.booking_month, TO_CHAR (p_dsp_as_of_date, 'FMMONTH')) --limit condition for Booking Month parameter only
                                    || ' 01, '
                                    || NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_dsp_as_of_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                   ), p_dsp_as_of_date) <= p_dsp_as_of_date) OR DECODE(p_dsp_as_of_date, NULL, 1, 0) = 1) --always return true if As Of date parameter is null
                       AND (((TRUNC (NVL (a.date_paid, p_dsp_as_of_date)) <= p_dsp_as_of_date AND p_date_option = 2) OR --condition in checking Date Paid if parameter date is As Of
                            (TRUNC ( DECODE (p_paid_date_option, 1, a.date_paid, 2, d.posting_date, NVL (a.date_paid, p_dsp_to_date)) ) BETWEEN p_dsp_from_date AND p_dsp_to_date AND p_date_option = 1)) --condition in checking Date Paid (Outstanding) or Tran Date/Posting Date (Losses Paid) if parameter date is By Period
                           --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                            OR (DECODE(GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1 AND p_brdrx_type = 2))
                       AND (DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), 
                                                        --if record is already cancelled, check if cancellation happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                                                        DECODE(p_date_option, 1, (p_dsp_to_date + 1), 2, (p_dsp_as_of_date + 1))) > 
                                                        DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)
                            --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                            OR (DECODE(GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1 AND p_brdrx_type = 2))
                       --check if Close Date or Close Date2 happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                       /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                       AND (DECODE(p_brdrx_option, 2, 1, CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1
                            OR DECODE(p_brdrx_option, 1, 1, CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1)
                       */
                       AND (DECODE(p_brdrx_option, 2, 1, CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1
                            OR DECODE(p_brdrx_option, 1, 1, CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1)
                       AND b.peril_cd = NVL (p_dsp_peril_cd, b.peril_cd)
                       AND ((a.tran_id IS NOT NULL AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1) --tran id should not be null if based on Losses Paid option else return true
                       AND ((a.tran_id = d.tran_id AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1)
                       AND a.tran_id = d.tran_id (+)
                       --AND ((d.tran_flag != 'D' AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1) --tran_flag should not be 'D' if based on Losses Paid option else return true
                       --if Per Policy
                       AND ((c.line_cd = NVL(p_dsp_line_cd2, c.line_cd) AND p_per_policy = 1) OR DECODE(p_per_policy, 0, 1, 0) = 1)
                       AND ((c.subline_cd = NVL(p_dsp_subline_cd2, c.subline_cd) AND p_per_policy = 1) OR DECODE(p_per_policy, 0, 1, 0) = 1)
                       AND ((c.pol_iss_cd = NVL(p_dsp_iss_cd2, c.pol_iss_cd) AND p_per_policy = 1) OR DECODE(p_per_policy, 0, 1, 0) = 1)
                       AND ((c.issue_yy = NVL(p_issue_yy, c.issue_yy) AND p_per_policy = 1) OR DECODE(p_per_policy, 0, 1, 0) = 1)
                       AND ((c.pol_seq_no = NVL(p_pol_seq_no, c.pol_seq_no) AND p_per_policy = 1) OR DECODE(p_per_policy, 0, 1, 0) = 1)
                       AND ((c.renew_no = NVL(p_renew_no, c.renew_no) AND p_per_policy = 1) OR DECODE(p_per_policy, 0, 1, 0) = 1)
                       --if Per Enrollee
                       AND a.claim_id = e.claim_id (+)
                       AND a.item_no = e.item_no (+)
                       AND a.grouped_item_no = e.grouped_item_no (+)
                       AND ((e.grouped_item_title IS NOT NULL AND p_per_enrollee = 1) OR DECODE(p_per_enrollee, 0, 1, 0) = 1)
                       AND ((e.grouped_item_title = NVL (p_dsp_enrollee, e.grouped_item_title) AND p_per_enrollee = 1) OR DECODE(p_per_enrollee, 0, 1, 0) = 1)
                       AND ((NVL (e.control_type_cd, 0) = NVL (p_dsp_control_type, NVL (e.control_type_cd, 0)) AND p_per_enrollee = 1) OR DECODE(p_per_enrollee, 0, 1, 0) = 1)
                       AND ((NVL (e.control_cd, 0) = NVL (p_dsp_control_number, NVL (e.control_cd, 0)) AND p_per_enrollee = 1) OR DECODE(p_per_enrollee, 0, 1, 0) = 1)
                       AND a.claim_id = f.claim_id
                       AND a.item_no = f.item_no
                       AND a.peril_cd = f.peril_cd
                       AND a.grouped_item_no = f.grouped_item_no
                       AND b.claim_id = g.claim_id
                       AND b.item_no = g.item_no
                  GROUP BY a.claim_id,
                           a.item_no,
                           a.peril_cd,
                           b.loss_cat_cd,
                           b.ann_tsi_amt,
                           NVL (g.currency_rate, 1),
                           a.grouped_item_no,
                           f.clm_res_hist_id,
                           DECODE(p_per_enrollee, 1, e.grouped_item_title, NULL),
                           DECODE(p_per_enrollee, 1, e.control_cd, NULL),
                           DECODE(p_per_enrollee, 1, e.control_type_cd, NULL)) c
           WHERE 1 = 1
             --if parameter is per intermediary, select only records which policy issue code is equal to RI else retrieve all
             AND z.line_cd (+) = a.line_cd
             AND z.subline_cd (+) = a.subline_cd
             AND z.iss_cd (+) = a.pol_iss_cd
             AND z.issue_yy (+) = a.issue_yy
             AND z.pol_seq_no (+) = a.pol_seq_no
             AND z.renew_no (+) = a.renew_no
             AND z.endt_seq_no (+) = 0
             AND DECODE(p_per_intermediary, 1, a.pol_iss_cd, NVL(giacp.v('RI_ISS_CD'), 1)) = NVL(giacp.v('RI_ISS_CD'), 1)
             AND ( (DECODE(p_brdrx_date_option, 1, TRUNC(a.dsp_loss_date), 2, TRUNC(a.clm_file_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date AND p_date_option = 1) OR --check if Loss Date or Claim file date is between From and To Date parameters
                   (DECODE(p_brdrx_date_option, 1, TRUNC(a.dsp_loss_date), 2, TRUNC(a.clm_file_date)) <= p_dsp_as_of_date AND p_date_option = 2) OR --check if Loss Date or Claim file date is less than or equal As Of Date parameter
                   (DECODE(p_brdrx_date_option, 3, 1, NULL, 1, 0) = 1) ) --always return true if extraction is based on Booking Month or Losses Paid
             AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
             AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
             AND a.claim_id = c.claim_id
             AND DECODE(p_user_id, NULL, check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202'), --security in CS version
                                         check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
             AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_dsp_iss_cd, DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
             AND (((DECODE(p_brdrx_option, 2, 0, c.loss_reserve) - DECODE(p_brdrx_option, 2, 0, DECODE(p_dsp_gross_tag, 1, 0, c.losses_paid)) > 0 OR
                 DECODE(p_brdrx_option, 1, 0, c.expense_reserve) - DECODE(p_brdrx_option, 1, 0, DECODE(p_dsp_gross_tag, 1, 0, c.expenses_paid)) > 0) 
                 AND p_brdrx_type = 1) --for Outstanding
                 OR
                 ((DECODE(p_brdrx_option, 2, 0, c.losses_paid) != 0 OR 
                 DECODE(p_brdrx_option, 1, 0, c.expenses_paid) != 0)
                 AND p_brdrx_type = 2)); --for Losses Paid

       --getting outstanding amounts per intermediary of Direct
       CURSOR claims_intm (
          p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
          p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
          p_iss_break           NUMBER,
          p_subline_break       NUMBER,
          p_dsp_gross_tag       gicl_res_brdrx_extr.res_tag%TYPE,
          p_brdrx_type          gicl_res_brdrx_extr.brdrx_type%TYPE,
          p_paid_date_option    gicl_res_brdrx_extr.pd_date_opt%TYPE,
          p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
          p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
          p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
          p_dsp_from_date       gicl_res_brdrx_extr.from_date%TYPE,
          p_dsp_to_date         gicl_res_brdrx_extr.to_date%TYPE,
          p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
          p_date_option         NUMBER,
          p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
          p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
          p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
          p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
          p_dsp_intm_no         gicl_res_brdrx_extr.intm_no%TYPE
       )
       IS
          SELECT p_session_id session_id, a.claim_id,
                 DECODE (p_iss_break, 1, a.iss_cd, 0, 'DI') iss_cd, 
                 --return parent intermediary number if per intermediary
                 get_parent_intm(c.intm_no) buss_source, a.line_cd,
                 DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                 TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year, a.assd_no,
                 get_claim_number (a.claim_id) claim_no,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                 ) policy_no,
                 a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                 c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                 a.expiry_date, c.ann_tsi_amt tsi_amt, c.intm_no,
                 DECODE(p_brdrx_option, 2, 0, c.loss_reserve) loss_reserve, --return zero loss reserve if extraction is only for Expense
                 DECODE(p_brdrx_option, 2, 0, DECODE(p_dsp_gross_tag, 1, 0, c.losses_paid)) losses_paid, --return zero losses paid if Reserve tag is tagged and if extraction is only for Expense
                 DECODE(p_brdrx_option, 1, 0, c.expense_reserve) expense_reserve, --return zero expense reserve if extraction is only for Loss
                 DECODE(p_brdrx_option, 1, 0, DECODE(p_dsp_gross_tag, 1, 0, c.expenses_paid)) expenses_paid, --return zero expenses paid if Reserve tag is tagged and if extraction is only for Loss
                 NVL(p_user_id, USER) user_id,
                 SYSDATE last_update, c.grouped_item_no, c.clm_res_hist_id, z.ref_pol_no
            FROM gicl_claims a,
                 gipi_polbasic z,
                 (SELECT   a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, d.intm_no,  NVL(d.shr_intm_pct,100),
                           (b.ann_tsi_amt *  NVL(d.shr_intm_pct,100)/100 * NVL (g.currency_rate, 1)) ann_tsi_amt, --user currency rate in table GICL_CLM_ITEM in converting TSI by MAC 09/12/2013.
                           /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100) loss_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) *  NVL(d.shr_intm_pct,100)/100 * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) losses_paid,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) *  NVL(d.shr_intm_pct,100)/100) expense_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) *  NVL(d.shr_intm_pct,100)/100 * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) expenses_paid,
                           */
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100) loss_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) *  NVL(d.shr_intm_pct,100)/100 * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) losses_paid,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) *  NVL(d.shr_intm_pct,100)/100) expense_reserve,
                           SUM (DECODE(CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date))), 0, 0, --return zero if not valid
                                  DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) *  NVL(d.shr_intm_pct,100)/100 * GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option)) expenses_paid,
                           a.grouped_item_no, f.clm_res_hist_id
                      FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, gicl_intm_itmperil d, 
                           (SELECT tran_id, tran_flag, posting_date
                              FROM giac_acctrans
                             WHERE p_brdrx_type = 2
                               AND tran_flag != 'D') e, --retrieve records from table giac_acctrans if Losses Paid is selected by MAC 06/11/2013.
                           (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no
                              FROM gicl_reserve_ds
                             WHERE NVL (negate_tag, 'N') <> 'Y'
                               AND p_brdrx_type != 2
                             UNION 
                            SELECT DISTINCT claim_id, item_no, peril_cd, NULL clm_res_hist_id, grouped_item_no
                              FROM gicl_loss_exp_ds
                             WHERE p_brdrx_type = 2) f,
                             gicl_clm_item g --added table to get convert rate of TSI amount instead of using convert rate in gicl_clm_res_hist by MAC 09/12/2013  
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.claim_id = c.claim_id
                       AND b.claim_id = d.claim_id (+)
                       AND b.item_no = d.item_no (+)
                       AND b.peril_cd = d.peril_cd (+)
                       AND DECODE(p_user_id, NULL, check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202'), --security in CS version
                                                   check_user_per_iss_cd2 (c.line_cd, c.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
                       AND ((DECODE(p_brdrx_date_option, 3, TO_DATE (   NVL (a.booking_month, TO_CHAR (p_dsp_as_of_date, 'FMMONTH')) --limit condition for Booking Month parameter only
                                    || ' 01, '
                                    || NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_dsp_as_of_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                   ), p_dsp_as_of_date) <= p_dsp_as_of_date) OR DECODE(p_dsp_as_of_date, NULL, 1, 0) = 1) --always return true if As Of date parameter is null
                       AND (((TRUNC (NVL (a.date_paid, p_dsp_as_of_date)) <= p_dsp_as_of_date AND p_date_option = 2) OR --condition in checking Date Paid if parameter date is As Of
                            (TRUNC ( DECODE (p_paid_date_option, 1, a.date_paid, 2, e.posting_date, NVL (a.date_paid, p_dsp_to_date)) ) BETWEEN p_dsp_from_date AND p_dsp_to_date AND p_date_option = 1)) --condition in checking Date Paid (Outstanding) or Tran Date/Posting Date (Losses Paid) if parameter date is By Period
                            --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                            OR (DECODE(GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1 AND p_brdrx_type = 2))
                       AND (DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), 
                                                        --if record is already cancelled, check if cancellation happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                                                        DECODE(p_date_option, 1, (p_dsp_to_date + 1), 2, (p_dsp_as_of_date + 1))) > 
                                                        DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)
                            --check reversal if Losses Paid option is selected and if tran id exists in table giac_reversals
                            OR (DECODE(GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1 AND p_brdrx_type = 2))
                       --check if Close Date or Close Date2 happens before To Date (p_date_option=1) or As Of Date(p_date_option=2)
                       /*replaced to exclude claim which peril status is already closed, cancelled, withdrawn, or denied in extracting Outstanding by MAC 08/16/2013.
                           AND (DECODE(p_brdrx_option, 2, 1, CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1
                           OR DECODE(p_brdrx_option, 1, 1, CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_date_option, 1, SYSDATE, 2, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1)
                       */
                       AND (DECODE(p_brdrx_option, 2, 1, CHECK_CLOSE_DATE1(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1
                           OR DECODE(p_brdrx_option, 1, 1, CHECK_CLOSE_DATE2(p_brdrx_type, a.claim_id, a.item_no, a.peril_cd, DECODE(p_brdrx_type, 1, SYSDATE, DECODE(p_date_option, 1, p_dsp_to_date, 2, p_dsp_as_of_date)))) = 1)
                       AND b.peril_cd = NVL (p_dsp_peril_cd, b.peril_cd)
                       AND DECODE(p_dsp_intm_no, NULL, 1, d.intm_no) = NVL(p_dsp_intm_no, 1)
                       AND ((a.tran_id IS NOT NULL AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1) --tran id should not be null if based on Losses Paid option else return true
                       AND ((a.tran_id = e.tran_id AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1)
                       --AND ((e.tran_flag != 'D' AND p_brdrx_type = 2) OR DECODE(p_brdrx_type, 1, 1, 0) = 1) --tran_flag should not be 'D' if based on Losses Paid option else return true
                       AND a.tran_id = e.tran_id (+)
                       AND a.claim_id = f.claim_id
                       AND a.item_no = f.item_no
                       AND a.peril_cd = f.peril_cd
                       AND a.grouped_item_no = f.grouped_item_no
                       AND b.claim_id = g.claim_id
                       AND b.item_no = g.item_no
                  GROUP BY a.claim_id,
                           a.item_no,
                           a.peril_cd,
                           b.loss_cat_cd,
                           d.intm_no, 
                            NVL(d.shr_intm_pct,100),
                           b.ann_tsi_amt,
                           NVL (g.currency_rate, 1),
                           a.grouped_item_no,
                           f.clm_res_hist_id) c
           WHERE 1 = 1
             --select all records which policy issue code is not equal to RI
             AND z.line_cd (+) = a.line_cd
             AND z.subline_cd (+) = a.subline_cd
             AND z.iss_cd (+) = a.pol_iss_cd
             AND z.issue_yy (+) = a.issue_yy
             AND z.pol_seq_no (+) = a.pol_seq_no
             AND z.renew_no (+) = a.renew_no
             AND z.endt_seq_no (+) = 0
             AND a.pol_iss_cd  != NVL(giacp.v('RI_ISS_CD'), 1) 
             AND ( (DECODE(p_brdrx_date_option, 1, TRUNC(a.dsp_loss_date), 2, TRUNC(a.clm_file_date)) BETWEEN p_dsp_from_date AND p_dsp_to_date AND p_date_option = 1) OR --check if Loss Date or Claim file date is between From and To Date parameters
                   (DECODE(p_brdrx_date_option, 1, TRUNC(a.dsp_loss_date), 2, TRUNC(a.clm_file_date)) <= p_dsp_as_of_date AND p_date_option = 2) OR --check if Loss Date or Claim file date is less than or equal As Of Date parameter
                   (DECODE(p_brdrx_date_option, 3, 1, NULL, 1, 0) = 1) ) --always return true if extraction is based on Booking Month or Losses Paid
             AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
             AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
             AND a.claim_id = c.claim_id
             AND DECODE(p_user_id, NULL, check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202'), --security in CS version
                                         check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
             AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_dsp_iss_cd, DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
             AND (((DECODE(p_brdrx_option, 2, 0, c.loss_reserve) - DECODE(p_brdrx_option, 2, 0, DECODE(p_dsp_gross_tag, 1, 0, c.losses_paid)) > 0 OR
                 DECODE(p_brdrx_option, 1, 0, c.expense_reserve) - DECODE(p_brdrx_option, 1, 0, DECODE(p_dsp_gross_tag, 1, 0, c.expenses_paid)) > 0) 
                 AND p_brdrx_type = 1) --for Outstanding
                 OR
                 ((DECODE(p_brdrx_option, 2, 0, c.losses_paid) != 0 OR 
                 DECODE(p_brdrx_option, 1, 0, c.expenses_paid) != 0)
                 AND p_brdrx_type = 2)); --for Losses Paid

       --getting outstanding amounts based on Batch OS
       CURSOR claims_take_up (
          p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
          p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
          p_iss_break           NUMBER,
          p_subline_break       NUMBER,
          p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
          p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
          p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
          p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
          p_date_option         NUMBER,
          p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
          p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
          p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
          p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
          p_posted              VARCHAR2,
          p_per_intermediary    gicl_res_brdrx_extr.intm_tag%TYPE --added parameter by MAC 06/08/2013.
       )
       IS
          SELECT p_session_id session_id, a.claim_id,
                 DECODE (p_iss_break, 1, a.iss_cd, 0, '0') iss_cd, 
                 --return RI Code if per intermediary else return 0
                 0 buss_source, a.line_cd,
                 DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                 TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year, a.assd_no,
                 get_claim_number (a.claim_id) claim_no,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                 ) policy_no,
                 a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                 c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                 a.expiry_date, c.ann_tsi_amt tsi_amt, 
                 DECODE(p_brdrx_option, 2, 0, c.os_loss) os_loss, --return zero os loss if extraction is only for Expense
                 DECODE(p_brdrx_option, 1, 0, c.os_expense) os_exp, --return zero os expense if extraction is only for Loss
                 NVL(p_user_id, USER) user_id,
                 SYSDATE last_update, c.grouped_item_no, c.clm_res_hist_id, z.ref_pol_no
            FROM gicl_claims a,
                 gipi_polbasic z,
                 (SELECT   a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd,
                           (b.ann_tsi_amt * NVL (a.convert_rate, 1)) ann_tsi_amt,
                           d.os_loss, d.os_expense,
                           a.grouped_item_no, a.clm_res_hist_id
                      FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, gicl_take_up_hist d, giac_acctrans e
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.claim_id = c.claim_id
                       AND a.claim_id = d.claim_id
                       AND a.clm_res_hist_id     = d.clm_res_hist_id
                       AND d.acct_tran_id        = e.tran_id  
                       AND DECODE(p_user_id, NULL, check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202'), --security in CS version
                                                   check_user_per_iss_cd2 (c.line_cd, c.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
                       AND DECODE(p_brdrx_date_option, 3, TO_DATE (   NVL (a.booking_month, TO_CHAR (p_dsp_as_of_date, 'FMMONTH')) --limit condition for Booking Month parameter only
                                    || ' 01, '
                                    || NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_dsp_as_of_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                   ), p_dsp_as_of_date) <= p_dsp_as_of_date
                       AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                       AND e.tran_flag = DECODE(p_posted,'Y','P','C') 
                       AND DECODE(p_brdrx_option,1,d.os_loss,2,d.os_expense,(NVL(d.os_loss,0)+ NVL(d.os_expense,0))) > 0) c
           WHERE 
             --if parameter is per intermediary, select only records which policy issue code is equal to RI else retrieve all by MAC 06/08/2013.
             DECODE(p_per_intermediary, 1, a.pol_iss_cd, NVL(giacp.v('RI_ISS_CD'), 1)) = NVL(giacp.v('RI_ISS_CD'), 1)
             AND z.line_cd (+) = a.line_cd
             AND z.subline_cd (+) = a.subline_cd
             AND z.iss_cd (+) = a.pol_iss_cd
             AND z.issue_yy (+) = a.issue_yy
             AND z.pol_seq_no (+) = a.pol_seq_no
             AND z.renew_no (+) = a.renew_no
             AND z.endt_seq_no (+) = 0
             AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
             AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
             AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
             AND a.claim_id = c.claim_id
             AND DECODE(p_user_id, NULL, check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202'), --security in CS version
                                         check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
             AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_dsp_iss_cd, DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1));

        --getting outstanding amounts per intermediary based on Batch OS
       CURSOR claims_take_up_intm (
          p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
          p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
          p_iss_break           NUMBER,
          p_subline_break       NUMBER,
          p_brdrx_date_option   gicl_res_brdrx_extr.ol_date_opt%TYPE,
          p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
          p_brdrx_option        gicl_res_brdrx_extr.brdrx_rep_type%TYPE,
          p_dsp_as_of_date      gicl_res_brdrx_extr.TO_DATE%TYPE,
          p_date_option         NUMBER,
          p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
          p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
          p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
          p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
          p_dsp_intm_no         gicl_res_brdrx_extr.intm_no%TYPE,
          p_posted              VARCHAR2
       )
       IS
          SELECT p_session_id session_id, a.claim_id,
                 DECODE (p_iss_break, 1, a.iss_cd, 0, '0') iss_cd, 
                 --return parent intermediary number
                 get_parent_intm(c.intm_no) buss_source, a.line_cd,
                 DECODE (p_subline_break, 1, a.subline_cd, 0, '0') subline_cd,
                 TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) loss_year, a.assd_no,
                 get_claim_number (a.claim_id) claim_no,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                 ) policy_no,
                 a.dsp_loss_date loss_date, a.clm_file_date, c.item_no,
                 c.peril_cd, c.loss_cat_cd, a.pol_eff_date incept_date,
                 a.expiry_date, c.ann_tsi_amt tsi_amt, c.intm_no,
                 DECODE(p_brdrx_option, 2, 0, c.os_loss) os_loss, --return zero os loss if extraction is only for Expense
                 DECODE(p_brdrx_option, 1, 0, c.os_expense) os_exp, --return zero os expense if extraction is only for Loss
                 NVL(p_user_id, USER) user_id,
                 SYSDATE last_update, c.grouped_item_no, c.clm_res_hist_id, z.ref_pol_no
            FROM gicl_claims a,
                 gipi_polbasic z,
                 (SELECT   a.claim_id, a.item_no, a.peril_cd, b.loss_cat_cd, f.intm_no, NVL(f.shr_intm_pct,100),
                           (b.ann_tsi_amt * NVL(f.shr_intm_pct,100) * NVL (a.convert_rate, 1)) ann_tsi_amt,
                           (d.os_loss * NVL(f.shr_intm_pct,100)/100) os_loss, 
                           (d.os_expense * NVL(f.shr_intm_pct,100)/100) os_expense,
                           a.grouped_item_no, a.clm_res_hist_id
                      FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, gicl_take_up_hist d, giac_acctrans e, gicl_intm_itmperil f
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.claim_id = c.claim_id
                       AND a.claim_id = d.claim_id
                       AND a.clm_res_hist_id     = d.clm_res_hist_id
                       AND d.acct_tran_id        = e.tran_id  
                       AND b.claim_id = f.claim_id (+)
                       AND b.item_no = f.item_no (+)
                       AND b.peril_cd = f.peril_cd (+)
                       AND DECODE(p_user_id, NULL, check_user_per_iss_cd (c.line_cd, c.iss_cd, 'GICLS202'), --security in CS version
                                                   check_user_per_iss_cd2 (c.line_cd, c.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
                       AND DECODE(p_brdrx_date_option, 3, TO_DATE (   NVL (a.booking_month, TO_CHAR (p_dsp_as_of_date, 'FMMONTH')) --limit condition for Booking Month parameter only
                                    || ' 01, '
                                    || NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_dsp_as_of_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                   ), p_dsp_as_of_date) <= p_dsp_as_of_date
                       AND DECODE(p_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_dsp_as_of_date
                       AND e.tran_flag = DECODE(p_posted,'Y','P','C') 
                       AND DECODE(p_dsp_intm_no, NULL, 1, f.intm_no) = NVL(p_dsp_intm_no, 1)
                       AND DECODE(p_brdrx_option,1,d.os_loss,2,d.os_expense,(NVL(d.os_loss,0)+ NVL(d.os_expense,0))) > 0) c
           WHERE 
             --iselect all records which policy issue code is not equal to RI by MAC 06/08/2013.
             a.pol_iss_cd  != NVL(giacp.v('RI_ISS_CD'), 1)
             AND z.line_cd (+) = a.line_cd
             AND z.subline_cd (+) = a.subline_cd
             AND z.iss_cd (+) = a.pol_iss_cd
             AND z.issue_yy (+) = a.issue_yy
             AND z.pol_seq_no (+) = a.pol_seq_no
             AND z.renew_no (+) = a.renew_no
             AND z.endt_seq_no (+) = 0
             AND a.line_cd = NVL (p_dsp_line_cd, a.line_cd)
             AND a.subline_cd = NVL (p_dsp_subline_cd, a.subline_cd)
             AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
             AND a.claim_id = c.claim_id
             AND DECODE(p_user_id, NULL, check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202'), --security in CS version
                                         check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
             AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_dsp_iss_cd, DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1));
       
      --getting claims register of Direct and Inward
      CURSOR claims_reg (
          p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
          p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
          p_per_line            gicl_res_brdrx_extr.line_cd_tag%TYPE,
          p_per_iss             gicl_res_brdrx_extr.iss_cd_tag%TYPE, 
          p_per_buss            gicl_res_brdrx_extr.intm_tag%TYPE, 
          p_per_loss_cat        gicl_res_brdrx_extr.loss_cat_tag%TYPE,
          p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
          p_dsp_from_date       gicl_res_brdrx_extr.from_date%TYPE,
          p_dsp_to_date         gicl_res_brdrx_extr.to_date%TYPE,
          p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
          p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
          p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
          p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
          p_per_intermediary    gicl_res_brdrx_extr.intm_tag%TYPE, 
          p_reg_button          gicl_res_brdrx_extr.reg_date_opt%TYPE,
          p_dsp_loss_cat_cd     gicl_res_brdrx_extr.loss_cat_cd%TYPE,
          p_dsp_intm_no         gicl_res_brdrx_extr.intm_no%TYPE
       )
       IS
      SELECT p_session_id session_id,  
             a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
             a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')) loss_year, a.assd_no,
             get_claim_number(a.claim_id) claim_no,
             (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
             LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
             a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
             a.clm_stat_cd, a.loss_cat_cd, a.ri_cd,
             b.converted_recovered_amt, GET_TOT_PREM_AMT(a.claim_id, c.item_no, c.peril_cd) prem_amt,
             c.item_no, c.peril_cd, c.ann_tsi_amt, c.loss_reserve, c.losses_paid,
             c.expense_reserve, c.expenses_paid, c.grouped_item_no, c.clm_res_hist_id, 
             DECODE(a.pol_iss_cd, giacp.v('RI_ISS_CD'), giacp.v('RI_ISS_CD'), NULL) intm_type,
             DECODE(a.pol_iss_cd, giacp.v('RI_ISS_CD'), a.ri_cd, NULL) buss_source,
             NVL(p_user_id, USER) user_id, SYSDATE last_update, z.ref_pol_no
        FROM gicl_claims a, 
             gipi_polbasic z, 
             (SELECT claim_id, SUM(NVL(recovered_amt * convert_rate,0)) converted_recovered_amt 
                FROM gicl_clm_recovery
               GROUP BY claim_id) b,
             (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                     NVL(a.convert_rate,1) convert_rate,
                     (b.ann_tsi_amt * NVL(a.convert_rate, 1)) ann_tsi_amt,
                     SUM (DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) loss_reserve,
                     SUM (DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) losses_paid,
                     SUM (DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) expense_reserve,
                     SUM (DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) expenses_paid,
                     a.grouped_item_no, c.clm_res_hist_id 
                FROM gicl_clm_res_hist a, gicl_item_peril b,
                     (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no
                        FROM gicl_reserve_ds
                       WHERE NVL (negate_tag, 'N') <> 'Y') c
               WHERE a.peril_cd             = b.peril_cd
                 AND a.item_no              = b.item_no
                 AND a.claim_id             = b.claim_id
                 AND NVL(a.dist_sw,'Y')     = 'Y'
                 AND b.loss_cat_cd          = NVL(p_dsp_loss_cat_cd, b.loss_cat_cd) 
                 AND a.claim_id = c.claim_id
                 AND a.item_no = c.item_no
                 AND a.peril_cd = c.peril_cd
                 AND a.grouped_item_no = c.grouped_item_no
               GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                        NVL(a.convert_rate,1), b.ann_tsi_amt, a.grouped_item_no, c.clm_res_hist_id) c
       WHERE 1 = 1
         AND z.line_cd (+) = a.line_cd
         AND z.subline_cd (+) = a.subline_cd
         AND z.iss_cd (+) = a.pol_iss_cd
         AND z.issue_yy (+) = a.issue_yy
         AND z.pol_seq_no (+) = a.pol_seq_no
         AND z.renew_no (+) = a.renew_no
         AND z.endt_seq_no (+) = 0       
         AND b.claim_id (+)  = a.claim_id
         AND a.claim_id = c.claim_id
         --if parameter is per intermediary, select only records which policy issue code is equal to RI else retrieve all
         AND DECODE(p_per_buss, 1, a.pol_iss_cd, NVL(giacp.v('RI_ISS_CD'), 1)) = NVL(giacp.v('RI_ISS_CD'), 1)
         AND DECODE(p_user_id, NULL, check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202'), --security in CS version
                                     check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
         AND DECODE(p_reg_button,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
             BETWEEN p_dsp_from_date AND p_dsp_to_date
         AND a.line_cd     = NVL(p_dsp_line_cd,a.line_cd)
         AND a.subline_cd  = NVL(p_dsp_subline_cd, a.subline_cd)
         AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
         AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_dsp_iss_cd, DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
       ORDER BY a.claim_id;
             
      --getting claims register per intermediary of Direct
      CURSOR claims_reg_intm (
          p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
          p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
          p_per_line            gicl_res_brdrx_extr.line_cd_tag%TYPE,
          p_per_iss             gicl_res_brdrx_extr.iss_cd_tag%TYPE, 
          p_per_buss            gicl_res_brdrx_extr.intm_tag%TYPE, 
          p_per_loss_cat        gicl_res_brdrx_extr.loss_cat_tag%TYPE,
          p_branch_option       gicl_res_brdrx_extr.branch_opt%TYPE,
          p_dsp_from_date       gicl_res_brdrx_extr.from_date%TYPE,
          p_dsp_to_date         gicl_res_brdrx_extr.to_date%TYPE,
          p_dsp_line_cd         gicl_res_brdrx_extr.line_cd%TYPE,
          p_dsp_subline_cd      gicl_res_brdrx_extr.subline_cd%TYPE,
          p_dsp_iss_cd          gicl_res_brdrx_extr.iss_cd%TYPE,
          p_dsp_peril_cd        gicl_res_brdrx_extr.peril_cd%TYPE,
          p_per_intermediary    gicl_res_brdrx_extr.intm_tag%TYPE, 
          p_reg_button          gicl_res_brdrx_extr.reg_date_opt%TYPE,
          p_dsp_loss_cat_cd     gicl_res_brdrx_extr.loss_cat_cd%TYPE,
          p_dsp_intm_no         gicl_res_brdrx_extr.intm_no%TYPE
       )
       IS
      SELECT p_session_id session_id, 
             a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
             a.renew_no, a.iss_cd, TO_NUMBER(TO_CHAR(a.loss_date,'yyyy')) loss_year, a.assd_no,
             get_claim_number(a.claim_id) claim_no,
             (a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||
             LTRIM(TO_CHAR(a.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09'))) policy_no,
             a.clm_file_date, a.dsp_loss_date, a.loss_date, a.pol_eff_date, a.expiry_date, 
             a.clm_stat_cd, a.loss_cat_cd, a.ri_cd,
             b.converted_recovered_amt * c.shr_intm_pct/100 converted_recovered_amt, 
             GET_TOT_PREM_AMT(a.claim_id, c.item_no, c.peril_cd) * c.shr_intm_pct/100 prem_amt,
             c.item_no, c.peril_cd, c.ann_tsi_amt, 
             c.loss_reserve, c.losses_paid,
             c.expense_reserve, c.expenses_paid, c.grouped_item_no, c.clm_res_hist_id, 
             GET_INTM_TYPE(GET_PARENT_INTM(c.intm_no)) intm_type, 
             GET_PARENT_INTM(c.intm_no) buss_source,
             NVL(p_user_id, USER) user_id, SYSDATE last_update, c.intm_no, z.ref_pol_no
        FROM gicl_claims a, 
             gipi_polbasic z,
             (SELECT claim_id, SUM(NVL(recovered_amt * convert_rate,0)) converted_recovered_amt 
                FROM gicl_clm_recovery
               GROUP BY claim_id) b,
             (SELECT b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                     NVL(a.convert_rate,1) convert_rate,
                     (b.ann_tsi_amt * NVL(c.shr_intm_pct,100) * NVL(a.convert_rate, 1)) ann_tsi_amt, NVL(c.intm_no, 0) intm_no, NVL(c.shr_intm_pct,100) shr_intm_pct,
                     SUM (DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) * NVL(c.shr_intm_pct,100)/100 loss_reserve,
                     SUM (DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * NVL(c.shr_intm_pct,100)/100 losses_paid,
                     SUM (DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) * NVL(c.shr_intm_pct,100)/100 expense_reserve,
                     SUM (DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * NVL(c.shr_intm_pct,100)/100 expenses_paid,
                     a.grouped_item_no, d.clm_res_hist_id 
                FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_intm_itmperil c, 
                     (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no
                        FROM gicl_reserve_ds
                       WHERE NVL (negate_tag, 'N') <> 'Y') d
               WHERE a.peril_cd             = b.peril_cd
                 AND a.item_no              = b.item_no
                 AND a.claim_id             = b.claim_id
                 AND NVL(a.dist_sw,'Y')     = 'Y'
                 AND b.loss_cat_cd          = NVL(p_dsp_loss_cat_cd, b.loss_cat_cd) 
                 AND b.claim_id             = c.claim_id (+)
                 AND b.item_no              = c.item_no (+)
                 AND b.peril_cd             = c.peril_cd (+)
                 AND DECODE(p_dsp_intm_no, NULL, 1, c.intm_no) = NVL(p_dsp_intm_no, 1)
                 AND a.claim_id = d.claim_id 
                 AND a.item_no = d.item_no
                 AND a.peril_cd = d.peril_cd
                 AND a.grouped_item_no = d.grouped_item_no
               GROUP BY b.claim_id, b.item_no, b.peril_cd, b.loss_cat_cd,
                        NVL(a.convert_rate,1), b.ann_tsi_amt, NVL(c.intm_no, 0), NVL(c.shr_intm_pct,100), a.grouped_item_no, d.clm_res_hist_id) c
       WHERE 1 = 1
         AND z.line_cd (+) = a.line_cd
         AND z.subline_cd (+) = a.subline_cd
         AND z.iss_cd (+) = a.pol_iss_cd
         AND z.issue_yy (+) = a.issue_yy
         AND z.pol_seq_no (+) = a.pol_seq_no
         AND z.renew_no (+) = a.renew_no
         AND z.endt_seq_no (+) = 0       
         AND b.claim_id (+)  = a.claim_id
         AND a.claim_id = c.claim_id
         AND DECODE(p_user_id, NULL, check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS202'), --security in CS version
                                     check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
         AND DECODE(p_reg_button,1,TRUNC(a.dsp_loss_date),2,TRUNC(a.clm_file_date))
             BETWEEN p_dsp_from_date AND p_dsp_to_date
         AND a.line_cd     = NVL(p_dsp_line_cd,a.line_cd)
         AND a.subline_cd  = NVL(p_dsp_subline_cd, a.subline_cd)
         AND c.peril_cd = NVL (p_dsp_peril_cd, c.peril_cd)
         AND a.pol_iss_cd != giacp.v('RI_ISS_CD')
         AND DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_dsp_iss_cd, DECODE (p_branch_option, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
       ORDER BY a.claim_id;
       
       CURSOR claims_rcvry (
                  p_user_id             gicl_res_brdrx_extr.user_id%TYPE,
                  p_session_id          gicl_res_brdrx_extr.session_id%TYPE,
                  p_dsp_rcvry_from_date gicl_res_brdrx_extr.rcvry_from_date%TYPE,
                  p_dsp_rcvry_to_date   gicl_res_brdrx_extr.rcvry_to_date%TYPE
       ) IS
         SELECT p_session_id session_id, ROWNUM rcvry_brdrx_record_id, 
                a.claim_id, a.line_cd, d.subline_cd, a.iss_cd, b.recovery_id, b.recovery_payt_id, 
                SUM(NVL(b.recovered_amt,0) * (NVL(c.recoverable_amt,0) / Get_Rec_Amt(c.recovery_id))) recovered_amt, 
                c.item_no, c.peril_cd, b.tran_date, b.acct_tran_id, e.payee_type
           FROM gicl_clm_recovery a, gicl_recovery_payt b, gicl_clm_recovery_dtl c,
                gicl_claims d, gicl_clm_loss_exp e
          WHERE NVL(b.cancel_tag, 'N') = 'N' 
            AND a.claim_id = b.claim_id 
            AND b.claim_id = c.claim_id 
            AND a.recovery_id = b.recovery_id 
            AND b.recovery_id = c.recovery_id 
            AND b.claim_id IN (SELECT claim_id 
                                 FROM gicl_res_brdrx_extr
                                WHERE session_id = p_session_id)
            AND b.claim_id = d.claim_id 
            AND TRUNC(b.tran_date) BETWEEN p_dsp_rcvry_from_date AND p_dsp_rcvry_to_date
            AND c.claim_id = e.claim_id
            AND c.clm_loss_id = e.clm_loss_id
            AND DECODE(p_user_id, NULL, check_user_per_iss_cd (d.line_cd, d.iss_cd, 'GICLS202'), --security in CS version
                                        check_user_per_iss_cd2 (d.line_cd, d.iss_cd, 'GICLS202', p_user_id)) = 1 --security in Web version
          GROUP BY p_session_id, ROWNUM, b.recovery_id, b.recovery_payt_id, a.claim_id, 
                a.line_cd, d.subline_cd, a. iss_cd, 
                c.item_no, c.peril_cd, b.tran_date,
                b.acct_tran_id, e.payee_type;
       
      v_exist      VARCHAR2(1);
      v_postexist  VARCHAR2(1);
      v_posted     VARCHAR2(1);
      
      -- EXTRACT DISTRIBUTION
      CURSOR loss_brdrx_extr (p_brdrx_extr_session_id   IN   gicl_res_brdrx_ds_extr.session_id%TYPE)
       IS
          SELECT a.brdrx_record_id, a.claim_id, a.iss_cd, a.buss_source,
                 a.line_cd, a.subline_cd, a.loss_year, a.item_no, a.peril_cd,
                 a.loss_cat_cd, a.grouped_item_no, a.clm_res_hist_id,
                 a.loss_reserve, a.expense_reserve, 
                 a.losses_paid, a.expenses_paid
            FROM gicl_res_brdrx_extr a
           WHERE session_id = p_brdrx_extr_session_id;

       CURSOR loss_reserve_ds (
          p_reserve_ds_claim_id          IN   gicl_reserve_ds.claim_id%TYPE,
          p_reserve_ds_item_no           IN   gicl_reserve_ds.item_no%TYPE,
          p_reserve_ds_peril_cd          IN   gicl_reserve_ds.peril_cd%TYPE,
          p_reserve_ds_grouped_item_no   IN   gicl_res_brdrx_extr.grouped_item_no%TYPE,
          p_reserve_ds_clm_res_hist_id   IN   gicl_res_brdrx_extr.clm_res_hist_id%TYPE,
          p_loss_reserve                 IN   gicl_res_brdrx_extr.loss_reserve%TYPE,
          p_expense_reserve              IN   gicl_res_brdrx_extr.expense_reserve%TYPE,
          p_losses_paid                  IN   gicl_res_brdrx_extr.losses_paid%TYPE,
          p_expenses_paid                IN   gicl_res_brdrx_extr.expenses_paid%TYPE
       )
       IS
          SELECT   DISTINCT a.claim_id, a.clm_res_hist_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct,
                   (p_loss_reserve * a.shr_pct / 100) loss_reserve,
                   (p_losses_paid * a.shr_pct / 100) losses_paid,
                   (p_expense_reserve * a.shr_pct / 100) expense_reserve, 
                   (p_expenses_paid * a.shr_pct / 100) expenses_paid 
              FROM gicl_reserve_ds a
             WHERE a.peril_cd = p_reserve_ds_peril_cd
               AND a.item_no = p_reserve_ds_item_no
               AND a.claim_id = p_reserve_ds_claim_id
               AND a.grouped_item_no = p_reserve_ds_grouped_item_no
               AND a.clm_res_hist_id = p_reserve_ds_clm_res_hist_id;

       CURSOR loss_reserve_rids (
          p_reserve_rids_claim_id          IN   gicl_reserve_rids.claim_id%TYPE,
          p_reserve_rids_clm_res_hist_id   IN   gicl_reserve_rids.clm_res_hist_id%TYPE,
          p_reserve_rids_clm_dist_no       IN   gicl_reserve_rids.clm_dist_no%TYPE,
          p_reserve_rids_grp_seq_no        IN   gicl_reserve_rids.grp_seq_no%TYPE,
          p_loss_reserve                   IN   gicl_res_brdrx_extr.loss_reserve%TYPE,
          p_expense_reserve                IN   gicl_res_brdrx_extr.expense_reserve%TYPE,
          p_losses_paid                    IN   gicl_res_brdrx_extr.losses_paid%TYPE,
          p_expenses_paid                  IN   gicl_res_brdrx_extr.expenses_paid%TYPE
       )
       IS
          SELECT   DISTINCT a.ri_cd, a.prnt_ri_cd, a.shr_ri_pct, a.shr_ri_pct_real,
                   (p_loss_reserve * a.shr_ri_pct_real / 100) loss_reserve,
                   (p_losses_paid * a.shr_ri_pct_real / 100) losses_paid,
                   (p_expense_reserve * a.shr_ri_pct_real / 100) expense_reserve, 
                   (p_expenses_paid * a.shr_ri_pct_real / 100) expenses_paid 
              FROM gicl_reserve_rids a
             WHERE a.grp_seq_no = p_reserve_rids_grp_seq_no
               AND a.clm_dist_no = p_reserve_rids_clm_dist_no
               AND a.clm_res_hist_id = p_reserve_rids_clm_res_hist_id
               AND a.claim_id = p_reserve_rids_claim_id;
        
        --get all distributed recoveries only       
        CURSOR rcvry_dist (p_rcvry_session_id   IN   gicl_rcvry_brdrx_extr.session_id%TYPE)
        IS
            SELECT a.rcvry_brdrx_record_id, a.claim_id,
                   a.recovery_id, a.recovery_payt_id, a.line_cd,
                   a.subline_cd, a.iss_cd, a.item_no,
                   a.peril_cd, a.recovered_amt, a.acct_tran_id,
                   a.payee_type
              FROM gicl_rcvry_brdrx_extr a
             WHERE a.session_id = p_rcvry_session_id
               AND a.recovery_id IN (SELECT b.recovery_id
                                       FROM gicl_recovery_ds b
                                      WHERE b.recovery_id = a.recovery_id  
                                        AND b.recovery_payt_id= b.recovery_payt_id
                                        AND NVL(b.negate_tag, 'N') = 'N');
        
        --get all undistributed recoveries only  
        CURSOR rcvry_undist (p_rcvry_session_id   IN   gicl_rcvry_brdrx_extr.session_id%TYPE)
        IS
            SELECT a.rcvry_brdrx_record_id, a.claim_id,
                   a.recovery_id, a.recovery_payt_id, a.line_cd,
                   a.subline_cd, a.iss_cd, a.item_no,
                   a.peril_cd, a.recovered_amt, NULL rec_dist_no, 
                   TO_NUMBER(TO_CHAR(rcvry_pd_date, 'RRRR')) dist_year, 
                   giisp.n('NET_RETENTION') grp_seq_no,
                   '1' share_type, 100 share_pct, recovered_amt shr_recovery_amt,
                   a.acct_tran_id, a.payee_type
              FROM gicl_rcvry_brdrx_extr a
             WHERE a.session_id = p_rcvry_session_id
               AND a.recovery_id NOT IN (SELECT recovery_id
                                           FROM gicl_rcvry_brdrx_ds_extr
                                          WHERE session_id = p_rcvry_session_id);
          
       --added cursor for distribution of losses paid per grp_seq_no by MAC 09/11/2013.    
       CURSOR losses_paid_ds (
          p_paid_ds_claim_id          IN   gicl_reserve_ds.claim_id%TYPE,
          p_paid_ds_item_no           IN   gicl_reserve_ds.item_no%TYPE,
          p_paid_ds_peril_cd          IN   gicl_reserve_ds.peril_cd%TYPE,
          p_paid_ds_grouped_item_no   IN   gicl_res_brdrx_extr.grouped_item_no%TYPE,
          p_paid_date_option          IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
          p_dsp_from_date             IN   gicl_res_brdrx_extr.from_date%TYPE,
          p_dsp_to_date               IN   gicl_res_brdrx_extr.to_date%TYPE  
       )
       IS
          SELECT b.claim_id, b.grp_seq_no, b.shr_loss_exp_pct shr_pct, a.clm_res_hist_id,
               ROUND
                  (DECODE (c.payee_type,
                           'L', ABS( NVL (shr_le_adv_amt, 0) )
                            * NVL (e.orig_curr_rate, e.convert_rate)
                            * SIGN (a.losses_paid)
                            * gicls202_pkg.get_reversal
                                                                  (a.tran_id,
                                                                   p_dsp_from_date,
                                                                   p_dsp_to_date,
                                                                   p_paid_date_option
                                                                  ),
                           0
                          ),
                   2
                  ) losses_paid,
               ROUND
                  (DECODE (c.payee_type,
                           'E', ABS( NVL (shr_le_adv_amt, 0) )
                            * NVL (e.orig_curr_rate, e.convert_rate)
                            * SIGN (a.expenses_paid)
                            * gicls202_pkg.get_reversal
                                                                  (a.tran_id,
                                                                   p_dsp_from_date,
                                                                   p_dsp_to_date,
                                                                   p_paid_date_option
                                                                  ),
                           0
                          ),
                   2
                  ) expenses_paid
          FROM gicl_clm_res_hist a,
               gicl_loss_exp_ds b,
               gicl_clm_loss_exp c,
               giac_acctrans d,
               gicl_advice e
         WHERE a.dist_sw IS NULL
           AND gicls202_pkg.get_reversal (a.tran_id,
                                                     p_dsp_from_date,
                                                     p_dsp_to_date,
                                                     p_paid_date_option
                                                    ) != 0
           AND a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.dist_no = b.clm_dist_no
           AND b.claim_id = c.claim_id
           AND b.clm_loss_id = c.clm_loss_id
           AND a.tran_id = d.tran_id
           AND a.advice_id = e.advice_id
           AND c.claim_id = p_paid_ds_claim_id
           AND c.item_no = p_paid_ds_item_no
           AND c.peril_cd = p_paid_ds_peril_cd
           AND c.grouped_item_no = p_paid_ds_grouped_item_no
           AND (   DECODE (p_paid_date_option,
                           1, TRUNC (d.tran_date),
                           2, TRUNC (d.posting_date)
                          ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                OR DECODE (gicls202_pkg.get_reversal (a.tran_id,
                                                                 p_dsp_from_date,
                                                                 p_dsp_to_date,
                                                                 p_paid_date_option
                                                                ),
                           1, 0,
                           1
                          ) = 1
               )
           AND (   DECODE (a.cancel_tag,
                           'Y', TRUNC (a.cancel_date),
                           p_dsp_to_date + 1
                          ) > p_dsp_to_date
                OR DECODE (gicls202_pkg.get_reversal (a.tran_id,
                                                                 p_dsp_from_date,
                                                                 p_dsp_to_date,
                                                                 p_paid_date_option
                                                                ),
                           1, 0,
                           1
                          ) = 1
               );  
       
       --added cursor for distribution of losses paid per RI by MAC 09/11/2013.    
       CURSOR losses_paid_rids (
          p_paid_rids_claim_id           IN   gicl_reserve_ds.claim_id%TYPE,
          p_paid_rids_clm_res_hist_id    IN   gicl_res_brdrx_extr.clm_res_hist_id%TYPE,
          p_paid_rids_grp_seq_no         IN   gicl_loss_exp_rids.grp_seq_no%TYPE,
          p_paid_date_option             IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
          p_dsp_from_date                IN   gicl_res_brdrx_extr.from_date%TYPE,
          p_dsp_to_date                  IN   gicl_res_brdrx_extr.to_date%TYPE  
       )
       IS
          SELECT a.ri_cd, a.prnt_ri_cd, a.shr_loss_exp_ri_pct shr_ri_pct,
               ROUND
                  (DECODE (b.payee_type,
                           'L', ABS( NVL (shr_le_ri_adv_amt, 0) )
                            * NVL (d.orig_curr_rate, d.convert_rate)
                            * SIGN (c.losses_paid)
                            * gicls202_pkg.get_reversal (c.tran_id,
                                                                    p_dsp_from_date,
                                                                    p_dsp_to_date,
                                                                    p_paid_date_option
                                                                   ),
                           0
                          ),
                   2
                  ) losses_paid,
               ROUND
                  (DECODE (b.payee_type,
                           'E', ABS( NVL (shr_le_ri_adv_amt, 0) )
                            * NVL (d.orig_curr_rate, d.convert_rate)
                            * SIGN (c.expenses_paid)
                            * gicls202_pkg.get_reversal (c.tran_id,
                                                                    p_dsp_from_date,
                                                                    p_dsp_to_date,
                                                                    p_paid_date_option
                                                                   ),
                           0
                          ),
                   2
                  ) expenses_paid
          FROM gicl_loss_exp_rids a,
               gicl_clm_loss_exp b,
               gicl_clm_res_hist c,
               gicl_advice d
         WHERE a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.claim_id = c.claim_id
           AND a.clm_loss_id = c.clm_loss_id
           AND a.clm_dist_no = c.dist_no
           AND c.advice_id = d.advice_id
           AND a.grp_seq_no = p_paid_rids_grp_seq_no
           AND a.claim_id = p_paid_rids_claim_id
           AND c.clm_res_hist_id = p_paid_rids_clm_res_hist_id;
        
       v_rcvry_brdrx_ds_rec_id    gicl_rcvry_brdrx_ds_extr.rcvry_brdrx_ds_record_id%TYPE;
       v_rcvry_brdrx_rids_rec_id  gicl_rcvry_brdrx_rids_extr.rcvry_brdrx_rids_record_id%TYPE;
   BEGIN
      v_user_id               := NULL;
      v_session_id            := NULL;
      v_rep_name              := NULL;
      v_brdrx_type            := NULL;
      v_brdrx_date_option     := NULL;
      v_brdrx_option          := NULL;
      v_dsp_gross_tag         := NULL;
      v_paid_date_option      := NULL;
      v_per_intermediary      := NULL;
      v_iss_break             := NULL;
      v_subline_break         := NULL;
      v_per_policy            := NULL;
      v_per_enrollee          := NULL;
      v_per_line              := NULL;
      v_per_iss               := NULL;
      v_per_buss              := NULL;
      v_per_loss_cat          := NULL;
      v_dsp_from_date         := NULL;
      v_dsp_to_date           := NULL;
      v_dsp_as_of_date        := NULL;
      v_branch_option         := NULL;
      v_reg_button            := NULL;
      v_net_rcvry_chkbx       := NULL;
      v_dsp_rcvry_from_date   := NULL;
      v_dsp_rcvry_to_date     := NULL;
      v_date_option           := NULL;
      v_dsp_line_cd           := NULL;
      v_dsp_subline_cd        := NULL;
      v_dsp_iss_cd            := NULL;
      v_dsp_loss_cat_cd       := NULL;
      v_dsp_peril_cd          := NULL;
      v_dsp_intm_no           := NULL;
      v_dsp_line_cd2          := NULL;
      v_dsp_subline_cd2       := NULL;
      v_dsp_iss_cd2           := NULL;
      v_issue_yy              := NULL;
      v_pol_seq_no            := NULL;
      v_renew_no              := NULL;
      v_dsp_enrollee          := NULL;
      v_dsp_control_type      := NULL;
      v_dsp_control_number    := NULL;
      v_brdrx_ds_record_id    := NULL;
      v_brdrx_rids_record_id  := NULL;
      v_posted                := NULL;

      v_user_id               := p_user_id;
      v_rep_name              := p_rep_name;
      v_dsp_from_date         := p_dsp_from_date;
      v_dsp_to_date           := p_dsp_to_date;
      v_branch_option         := p_branch_option;
      v_date_option           := p_date_option;
      v_dsp_line_cd           := p_dsp_line_cd;
      v_dsp_subline_cd        := p_dsp_subline_cd;
      v_dsp_iss_cd            := p_dsp_iss_cd;
      v_dsp_peril_cd          := p_dsp_peril_cd;
      v_net_rcvry_chkbx       := 'N';
      v_brdrx_record_id       := 0;
      v_brdrx_ds_record_id    := 0;
      v_brdrx_rids_record_id  := 0;        
    
      IF v_rep_name = 1 THEN --Bordereaux option
         v_brdrx_type            := p_brdrx_type;
         v_brdrx_option          := p_brdrx_option;
         v_per_intermediary      := p_per_intermediary;
         v_iss_break             := p_per_issource;
         v_subline_break         := p_per_line_subline;
         v_net_rcvry_chkbx       := p_net_rcvry_chkbx;
         v_dsp_rcvry_from_date   := p_dsp_rcvry_from_date;
         v_dsp_rcvry_to_date     := p_dsp_rcvry_to_date;
         v_dsp_gross_tag         := 0;
         v_per_policy            := 0;
         v_per_enrollee          := 0;

         IF v_brdrx_type = 1 THEN --Outstanding option
            v_brdrx_date_option := p_brdrx_date_option;
            v_dsp_gross_tag     := p_dsp_gross_tag;
            v_dsp_as_of_date    := p_dsp_as_of_date;
         ELSIF v_brdrx_type = 2 THEN --Losses Paid option
            v_paid_date_option  := p_paid_date_option;
            v_per_policy        := p_per_policy;
            v_per_enrollee      := p_per_enrollee;
            IF v_per_policy = 1 THEN --Per Policy checkbox
               v_dsp_line_cd2          := p_dsp_line_cd2;
               v_dsp_subline_cd2       := p_dsp_subline_cd2;
               v_dsp_iss_cd2           := p_dsp_iss_cd2;
               v_issue_yy              := p_issue_yy;
               v_pol_seq_no            := p_pol_seq_no;
               v_renew_no              := p_renew_no;
               v_branch_option         := NULL;
               v_net_rcvry_chkbx       := 'N';
               v_dsp_rcvry_from_date   := NULL;
               v_dsp_rcvry_to_date     := NULL;
               v_iss_break             := 0;
               v_subline_break         := 0;
               v_per_intermediary      := 0;
            ELSIF v_per_enrollee = 1 THEN
               v_dsp_enrollee          := p_dsp_enrollee;
               v_dsp_control_type      := p_dsp_control_type;
               v_dsp_control_number    := p_dsp_control_number;
               v_branch_option         := NULL;
               v_net_rcvry_chkbx       := 'N';
               v_dsp_rcvry_from_date   := NULL;
               v_dsp_rcvry_to_date     := NULL;
               v_iss_break             := 0;
               v_subline_break         := 0;
               v_per_intermediary      := 0;
            END IF;
         END IF;
        
         IF p_per_intermediary = 1 THEN
            v_dsp_intm_no           := p_dsp_intm_no;
         END IF;
      ELSIF v_rep_name = 2 THEN --Claim Register option
         v_reg_button        := p_reg_button;
         v_per_line          := p_per_line;
         v_per_iss           := p_per_iss;
         v_per_buss          := p_per_buss;
         v_per_loss_cat      := p_per_loss_cat;
         v_dsp_loss_cat_cd   := p_dsp_loss_cat_cd;
        
         IF v_per_buss = 1 THEN
            v_dsp_intm_no   := p_dsp_intm_no;
         END IF;
      END IF;
      
      delete_data_gicls202(p_user_id);
      delete_rcvry_data_gicls202;
      v_session_id := get_session_id;
      
      IF v_rep_name = 1 THEN--if Bordereaux
         IF v_brdrx_type = 1 AND v_date_option = 2 THEN --if Outstanding and As Of
            BEGIN
                 SELECT DISTINCT 'x' 
                   INTO v_exist
                   FROM gicl_take_up_hist a, giac_acctrans b
                  WHERE a.acct_tran_id = b.tran_id 
                    AND a.iss_cd = b.gibr_branch_cd
                    AND a.iss_cd = NVL(v_dsp_iss_cd,a.iss_cd)  
                    AND TRUNC(b.tran_date) = v_dsp_as_of_date
                    AND b.tran_flag <> 'D';
                                
                  v_posted := 'N';  
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 v_exist := NULL;
            END;     
         END IF;
                    
         IF v_exist IS NOT NULL THEN --if already taken up
            BEGIN
                SELECT DISTINCT 'x' 
                  INTO v_postexist
                  FROM gicl_take_up_hist a, giac_acctrans b
                 WHERE a.acct_tran_id = b.tran_id 
                   AND a.iss_cd = b.gibr_branch_cd
                   AND a.iss_cd = NVL(v_dsp_iss_cd,a.iss_cd)  
                   AND TRUNC(b.tran_date) = v_dsp_as_of_date  
                   AND TRUNC(b.posting_date) = v_dsp_as_of_date;
                               
                   v_posted := 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_postexist := NULL;
            END;
                        
            IF v_per_intermediary = 1 OR v_dsp_intm_no IS NOT NULL THEN --if per intermediary and if Intermediary Number is not null
                FOR rec IN claims_take_up_intm (v_user_id,
                                          v_session_id,
                                          v_iss_break,
                                          v_subline_break,
                                          v_brdrx_date_option,
                                          v_branch_option,
                                          v_brdrx_option,
                                          v_dsp_as_of_date,
                                          v_date_option,
                                          v_dsp_line_cd,
                                          v_dsp_subline_cd,
                                          v_dsp_iss_cd,
                                          v_dsp_peril_cd,
                                          v_dsp_intm_no,
                                          v_posted
                                     )
                LOOP
                   v_brdrx_record_id := v_brdrx_record_id + 1;
                   INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id, claim_id,
                                iss_cd, buss_source, line_cd, subline_cd,
                                loss_year, assd_no, claim_no, policy_no,
                                loss_date, clm_file_date, item_no,
                                peril_cd, loss_cat_cd, incept_date, expiry_date, 
                                tsi_amt, intm_no, loss_reserve, expense_reserve, 
                                user_id, last_update, extr_type, brdrx_type,
                                ol_date_opt, brdrx_rep_type, res_tag,
                                pd_date_opt, intm_tag, iss_cd_tag,
                                line_cd_tag, loss_cat_tag, from_date,
                                TO_DATE, branch_opt,
                                reg_date_opt, net_rcvry_tag, rcvry_from_date,
                                rcvry_to_date, grouped_item_no,
                                clm_res_hist_id, ref_pol_no
                               )
                        VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                                rec.iss_cd, rec.buss_source, rec.line_cd, rec.subline_cd,
                                rec.loss_year, rec.assd_no, rec.claim_no, rec.policy_no,
                                rec.loss_date, rec.clm_file_date, rec.item_no,
                                rec.peril_cd, rec.loss_cat_cd, rec.incept_date, rec.expiry_date, 
                                rec.tsi_amt, rec.intm_no, rec.os_loss, rec.os_exp,
                                rec.user_id, rec.last_update, v_rep_name, v_brdrx_type,
                                v_brdrx_date_option, v_brdrx_option, v_dsp_gross_tag,
                                v_paid_date_option, v_per_intermediary, v_iss_break,
                                v_subline_break, v_per_loss_cat, v_dsp_from_date,
                                NVL (v_dsp_to_date, v_dsp_as_of_date), v_branch_option,
                                v_reg_button, v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                                v_dsp_rcvry_to_date, rec.grouped_item_no,
                                rec.clm_res_hist_id, rec.ref_pol_no
                               );
                END LOOP;
            END IF;
                        
            IF v_dsp_intm_no IS NULL THEN 
                FOR rec IN claims_take_up (v_user_id,
                                          v_session_id,
                                          v_iss_break,
                                          v_subline_break,
                                          v_brdrx_date_option,
                                          v_branch_option,
                                          v_brdrx_option,
                                          v_dsp_as_of_date,
                                          v_date_option,
                                          v_dsp_line_cd,
                                          v_dsp_subline_cd,
                                          v_dsp_iss_cd,
                                          v_dsp_peril_cd,
                                          v_posted,
                                          v_per_intermediary
                                     )
                LOOP
                   v_brdrx_record_id := v_brdrx_record_id + 1;
                   INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id, claim_id,
                                iss_cd, buss_source, line_cd, subline_cd,
                                loss_year, assd_no, claim_no, policy_no,
                                loss_date, clm_file_date, item_no,
                                peril_cd, loss_cat_cd, incept_date,
                                expiry_date, tsi_amt, loss_reserve, expense_reserve, 
                                user_id, last_update, extr_type, brdrx_type,
                                ol_date_opt, brdrx_rep_type, res_tag,
                                pd_date_opt, intm_tag, iss_cd_tag,
                                line_cd_tag, loss_cat_tag, from_date,
                                TO_DATE, branch_opt,
                                reg_date_opt, net_rcvry_tag, rcvry_from_date,
                                rcvry_to_date, grouped_item_no,
                                clm_res_hist_id, ref_pol_no
                               )
                        VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                                rec.iss_cd, rec.buss_source, rec.line_cd, rec.subline_cd,
                                rec.loss_year, rec.assd_no, rec.claim_no, rec.policy_no,
                                rec.loss_date, rec.clm_file_date, rec.item_no,
                                rec.peril_cd, rec.loss_cat_cd, rec.incept_date,
                                rec.expiry_date, rec.tsi_amt, rec.os_loss, rec.os_exp,
                                rec.user_id, rec.last_update, v_rep_name, v_brdrx_type,
                                v_brdrx_date_option, v_brdrx_option, v_dsp_gross_tag,
                                v_paid_date_option, v_per_intermediary, v_iss_break,
                                v_subline_break, v_per_loss_cat, v_dsp_from_date,
                                NVL (v_dsp_to_date, v_dsp_as_of_date), v_branch_option,
                                v_reg_button, v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                                v_dsp_rcvry_to_date, rec.grouped_item_no,
                                rec.clm_res_hist_id, rec.ref_pol_no
                               );
                END LOOP;
            END IF;
         ELSE --not taken up
            IF v_per_intermediary = 1 OR v_dsp_intm_no IS NOT NULL THEN --use cursor claims_intm in inserting records in gicl_res_brdrx_extr if per intermediary (Direct only) or if Intermediary Number is not null 
                FOR rec IN claims_intm (v_user_id,
                                  v_session_id,
                                  v_iss_break,
                                  v_subline_break,
                                  v_dsp_gross_tag,
                                  v_brdrx_type,
                                  v_paid_date_option,
                                  v_brdrx_date_option,
                                  v_branch_option,
                                  v_brdrx_option,
                                  v_dsp_from_date,
                                  v_dsp_to_date,
                                  v_dsp_as_of_date,
                                  v_date_option,
                                  v_dsp_line_cd,
                                  v_dsp_subline_cd,
                                  v_dsp_iss_cd,
                                  v_dsp_peril_cd,
                                  v_dsp_intm_no
                                 )
                LOOP
                   v_brdrx_record_id := v_brdrx_record_id + 1;
                   INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id, claim_id,
                                iss_cd, buss_source, line_cd, subline_cd,
                                loss_year, assd_no, claim_no, policy_no,
                                loss_date, clm_file_date, item_no,
                                peril_cd, loss_cat_cd, incept_date,
                                expiry_date, tsi_amt, intm_no, loss_reserve,
                                losses_paid, expense_reserve, expenses_paid,
                                user_id, last_update, extr_type, brdrx_type,
                                ol_date_opt, brdrx_rep_type, res_tag,
                                pd_date_opt, intm_tag, iss_cd_tag,
                                line_cd_tag, loss_cat_tag, from_date,
                                TO_DATE, branch_opt,
                                reg_date_opt, net_rcvry_tag, rcvry_from_date,
                                rcvry_to_date, grouped_item_no, clm_res_hist_id, ref_pol_no
                               )
                        VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                                rec.iss_cd, rec.buss_source, rec.line_cd, rec.subline_cd,
                                rec.loss_year, rec.assd_no, rec.claim_no, rec.policy_no,
                                rec.loss_date, rec.clm_file_date, rec.item_no,
                                rec.peril_cd, rec.loss_cat_cd, rec.incept_date,
                                rec.expiry_date, rec.tsi_amt, rec.intm_no, rec.loss_reserve,
                                rec.losses_paid, rec.expense_reserve, rec.expenses_paid,
                                rec.user_id, rec.last_update, v_rep_name, v_brdrx_type,
                                v_brdrx_date_option, v_brdrx_option, v_dsp_gross_tag,
                                v_paid_date_option, v_per_intermediary, v_iss_break,
                                v_subline_break, v_per_loss_cat, v_dsp_from_date,
                                NVL (v_dsp_to_date, v_dsp_as_of_date), v_branch_option,
                                v_reg_button, v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                                v_dsp_rcvry_to_date, rec.grouped_item_no, rec.clm_res_hist_id, rec.ref_pol_no
                               );
                END LOOP; 
                        
            END IF;
                        
            IF v_dsp_intm_no IS NULL THEN 
                --use cursor claims_rec in inserting records in gicl_res_brdrx_extr both per intermediary (Inward only) and not per intermediary
                FOR rec IN claims_rec (v_user_id,
                                      v_session_id,
                                      v_iss_break,
                                      v_subline_break,
                                      v_dsp_gross_tag,
                                      v_brdrx_type,
                                      v_paid_date_option,
                                      v_brdrx_date_option,
                                      v_branch_option,
                                      v_brdrx_option,
                                      v_dsp_from_date,
                                      v_dsp_to_date,
                                      v_dsp_as_of_date,
                                      v_date_option,
                                      v_dsp_line_cd,
                                      v_dsp_subline_cd,
                                      v_dsp_iss_cd,
                                      v_dsp_peril_cd,
                                      v_per_intermediary,
                                      v_per_policy,
                                      v_per_enrollee,
                                      v_dsp_line_cd2,  
                                      v_dsp_subline_cd2, 
                                      v_dsp_iss_cd2,  
                                      v_issue_yy, 
                                      v_pol_seq_no,
                                      v_renew_no,
                                      v_dsp_enrollee,
                                      v_dsp_control_type,
                                      v_dsp_control_number
                                     )
                LOOP
                   v_brdrx_record_id := v_brdrx_record_id + 1;
                   INSERT INTO gicl_res_brdrx_extr
                               (session_id, brdrx_record_id, claim_id,
                                iss_cd, buss_source, line_cd, subline_cd,
                                loss_year, assd_no, claim_no, policy_no,
                                loss_date, clm_file_date, item_no,
                                peril_cd, loss_cat_cd, incept_date,
                                expiry_date, tsi_amt, loss_reserve,
                                losses_paid, expense_reserve, expenses_paid,
                                user_id, last_update, extr_type, brdrx_type,
                                ol_date_opt, brdrx_rep_type, res_tag,
                                pd_date_opt, intm_tag, iss_cd_tag,
                                line_cd_tag, loss_cat_tag, from_date,
                                TO_DATE, branch_opt,
                                reg_date_opt, net_rcvry_tag, rcvry_from_date,
                                rcvry_to_date, grouped_item_no, clm_res_hist_id,
                                pol_iss_cd, issue_yy, pol_seq_no,
                                renew_no, enrollee, control_type, 
                                control_number, policy_tag, enrollee_tag, ref_pol_no
                               )
                        VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                                rec.iss_cd, rec.buss_source, rec.line_cd, rec.subline_cd,
                                rec.loss_year, rec.assd_no, rec.claim_no, rec.policy_no,
                                rec.loss_date, rec.clm_file_date, rec.item_no,
                                rec.peril_cd, rec.loss_cat_cd, rec.incept_date,
                                rec.expiry_date, rec.tsi_amt, rec.loss_reserve,
                                rec.losses_paid, rec.expense_reserve, rec.expenses_paid,
                                rec.user_id, rec.last_update, v_rep_name, v_brdrx_type,
                                v_brdrx_date_option, v_brdrx_option, v_dsp_gross_tag,
                                v_paid_date_option, v_per_intermediary, v_iss_break,
                                v_subline_break, v_per_loss_cat, v_dsp_from_date,
                                NVL (v_dsp_to_date, v_dsp_as_of_date), v_branch_option,
                                v_reg_button, v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                                v_dsp_rcvry_to_date, rec.grouped_item_no, rec.clm_res_hist_id,
                                rec.pol_iss_cd, rec.issue_yy, rec.pol_seq_no,
                                rec.renew_no, rec.grouped_item_title, rec.control_type_cd,
                                rec.control_cd, v_per_policy, v_per_enrollee, rec.ref_pol_no
                               );
                END LOOP;
            END IF;
         END IF;
                    
         IF v_net_rcvry_chkbx = 'Y' THEN
             FOR rcvry IN claims_rcvry(v_user_id,
                                       v_session_id,
                                       v_dsp_rcvry_from_date,
                                       v_dsp_rcvry_to_date)
             LOOP
                 INSERT INTO gicl_rcvry_brdrx_extr (session_id, rcvry_brdrx_record_id, claim_id,
                                    recovery_id, recovery_payt_id, line_cd,
                                    subline_cd, iss_cd, rcvry_pd_date, item_no,
                                    peril_cd, recovered_amt, acct_tran_id, payee_type)
                            VALUES (rcvry.session_id, rcvry.rcvry_brdrx_record_id, rcvry.claim_id,
                                    rcvry.recovery_id, rcvry.recovery_payt_id, rcvry.line_cd,
                                    rcvry.subline_cd, rcvry.iss_cd, rcvry.tran_date, rcvry.item_no,
                                    rcvry.peril_cd, rcvry.recovered_amt, rcvry.acct_tran_id, rcvry.payee_type);
             END LOOP;
         END IF;
       ELSIF v_rep_name = 2 THEN --if Claims Register
         IF v_per_buss = 1 OR v_dsp_intm_no IS NOT NULL THEN 
             FOR rec IN claims_reg_intm (v_user_id,
                               v_session_id,
                               v_per_line,
                               v_per_iss,
                               v_per_buss, 
                               v_per_loss_cat,
                               v_branch_option,
                               v_dsp_from_date,
                               v_dsp_to_date,
                               v_dsp_line_cd,
                               v_dsp_subline_cd,
                               v_dsp_iss_cd,
                               v_dsp_peril_cd,
                               v_per_intermediary,
                               v_reg_button,
                               v_dsp_loss_cat_cd,
                               v_dsp_intm_no
                               )
             LOOP
                 v_brdrx_record_id := v_brdrx_record_id + 1;
                 INSERT INTO gicl_res_brdrx_extr
                       (session_id, brdrx_record_id, claim_id,
                        iss_cd, buss_source, line_cd, subline_cd,
                        loss_year, assd_no, claim_no, policy_no,
                        loss_date, clm_file_date, item_no,
                        peril_cd, loss_cat_cd, incept_date,
                        expiry_date, tsi_amt, loss_reserve,
                        losses_paid, expense_reserve, expenses_paid,
                        user_id, last_update, extr_type, brdrx_type,
                        ol_date_opt, brdrx_rep_type, res_tag,
                        pd_date_opt, intm_tag, iss_cd_tag,
                        line_cd_tag, loss_cat_tag, from_date,
                        TO_DATE, branch_opt,
                        reg_date_opt, net_rcvry_tag, rcvry_from_date,
                        rcvry_to_date, grouped_item_no, clm_res_hist_id,
                        prem_amt, clm_stat_cd, recovered_amt, intm_type, ref_pol_no
                       )
                VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                        rec.iss_cd, rec.buss_source, rec.line_cd, rec.subline_cd,
                        rec.loss_year, rec.assd_no, rec.claim_no, rec.policy_no,
                        rec.loss_date, rec.clm_file_date, rec.item_no,
                        rec.peril_cd, rec.loss_cat_cd, rec.pol_eff_date,
                        rec.expiry_date, rec.ann_tsi_amt, rec.loss_reserve,
                        rec.losses_paid, rec.expense_reserve, rec.expenses_paid,
                        rec.user_id, rec.last_update, v_rep_name, v_brdrx_type,
                        v_brdrx_date_option, v_brdrx_option, v_dsp_gross_tag,
                        v_paid_date_option, v_per_intermediary, v_iss_break,
                        v_subline_break, v_per_loss_cat, v_dsp_from_date,
                        NVL (v_dsp_to_date, v_dsp_as_of_date), v_branch_option,
                        v_reg_button, v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                        v_dsp_rcvry_to_date, rec.grouped_item_no, rec.clm_res_hist_id,
                        rec.prem_amt, rec.clm_stat_cd, rec.converted_recovered_amt,
                        rec.intm_type, rec.ref_pol_no
                       );
                END LOOP;
         END IF;
                    
         IF v_dsp_intm_no IS NULL THEN 
            FOR rec IN claims_reg (v_user_id,
                                   v_session_id,
                                   v_per_line,
                                   v_per_iss,
                                   v_per_buss, 
                                   v_per_loss_cat,
                                   v_branch_option,
                                   v_dsp_from_date,
                                   v_dsp_to_date,
                                   v_dsp_line_cd,
                                   v_dsp_subline_cd,
                                   v_dsp_iss_cd,
                                   v_dsp_peril_cd,
                                   v_per_intermediary,
                                   v_reg_button,
                                   v_dsp_loss_cat_cd,
                                   v_dsp_intm_no
                                   )
            LOOP
               v_brdrx_record_id := v_brdrx_record_id + 1;
               INSERT INTO gicl_res_brdrx_extr
                           (session_id, brdrx_record_id, claim_id,
                            iss_cd, buss_source, line_cd, subline_cd,
                            loss_year, assd_no, claim_no, policy_no,
                            loss_date, clm_file_date, item_no,
                            peril_cd, loss_cat_cd, incept_date,
                            expiry_date, tsi_amt, loss_reserve,
                            losses_paid, expense_reserve, expenses_paid,
                            user_id, last_update, extr_type, brdrx_type,
                            ol_date_opt, brdrx_rep_type, res_tag,
                            pd_date_opt, intm_tag, iss_cd_tag,
                            line_cd_tag, loss_cat_tag, from_date,
                            TO_DATE, branch_opt,
                            reg_date_opt, net_rcvry_tag, rcvry_from_date,
                            rcvry_to_date, grouped_item_no, clm_res_hist_id,
                            prem_amt, clm_stat_cd, recovered_amt, intm_type, ref_pol_no
                           )
                    VALUES (rec.session_id, v_brdrx_record_id, rec.claim_id,
                            rec.iss_cd, rec.buss_source, rec.line_cd, rec.subline_cd,
                            rec.loss_year, rec.assd_no, rec.claim_no, rec.policy_no,
                            rec.loss_date, rec.clm_file_date, rec.item_no,
                            rec.peril_cd, rec.loss_cat_cd, rec.pol_eff_date,
                            rec.expiry_date, rec.ann_tsi_amt, rec.loss_reserve,
                            rec.losses_paid, rec.expense_reserve, rec.expenses_paid,
                            rec.user_id, rec.last_update, v_rep_name, v_brdrx_type,
                            v_brdrx_date_option, v_brdrx_option, v_dsp_gross_tag,
                            v_paid_date_option, v_per_intermediary, v_iss_break,
                            v_subline_break, v_per_loss_cat, v_dsp_from_date,
                            NVL (v_dsp_to_date, v_dsp_as_of_date), v_branch_option,
                            v_reg_button, v_net_rcvry_chkbx, v_dsp_rcvry_from_date,
                            v_dsp_rcvry_to_date, rec.grouped_item_no, rec.clm_res_hist_id,
                            rec.prem_amt, rec.clm_stat_cd, rec.converted_recovered_amt,
                            rec.intm_type, rec.ref_pol_no
                           );
            END LOOP;
         END IF;
      END IF;
       
      -- EXTRACT DISTRIBUTION
      FOR brdrx_extr_rec IN loss_brdrx_extr (v_session_id)
       LOOP
           IF v_rep_name = 1 AND v_brdrx_type = 2 THEN --for Bordereaux - Losses Paid by MAC 09/11/2013.
              FOR paid_ds_rec IN losses_paid_ds (brdrx_extr_rec.claim_id,
                                                 brdrx_extr_rec.item_no,
                                                 brdrx_extr_rec.peril_cd,
                                                 brdrx_extr_rec.grouped_item_no,
                                                 v_paid_date_option,
                                                 v_dsp_from_date,
                                                 v_dsp_to_date)
              LOOP
                 BEGIN
                    v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

                    INSERT INTO gicl_res_brdrx_ds_extr
                                (session_id, brdrx_record_id,
                                 brdrx_ds_record_id, claim_id,
                                 iss_cd, buss_source,
                                 line_cd, subline_cd,
                                 loss_year, item_no,
                                 peril_cd,
                                 loss_cat_cd,
                                 grp_seq_no, shr_pct,
                                 loss_reserve,
                                 losses_paid, 
                                 expense_reserve,
                                 expenses_paid,
                                 user_id, last_update
                                )
                         VALUES (v_session_id, brdrx_extr_rec.brdrx_record_id,
                                 v_brdrx_ds_record_id, brdrx_extr_rec.claim_id,
                                 brdrx_extr_rec.iss_cd, brdrx_extr_rec.buss_source,
                                 brdrx_extr_rec.line_cd, brdrx_extr_rec.subline_cd,
                                 brdrx_extr_rec.loss_year, brdrx_extr_rec.item_no,
                                 brdrx_extr_rec.peril_cd,
                                 brdrx_extr_rec.loss_cat_cd,
                                 paid_ds_rec.grp_seq_no, paid_ds_rec.shr_pct,
                                 0,
                                 paid_ds_rec.losses_paid,
                                 0, 
                                 paid_ds_rec.expenses_paid,
                                 NVL(v_user_id, USER), SYSDATE
                                );
                 END;

                 FOR paid_rids_rec IN losses_paid_rids (paid_ds_rec.claim_id,
                                                        paid_ds_rec.clm_res_hist_id,
                                                        paid_ds_rec.grp_seq_no,
                                                        v_paid_date_option,
                                                        v_dsp_from_date,
                                                        v_dsp_to_date)
                 LOOP
                    BEGIN
                       v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

                       INSERT INTO gicl_res_brdrx_rids_extr
                                   (session_id, brdrx_ds_record_id,
                                    brdrx_rids_record_id, claim_id,
                                    iss_cd,
                                    buss_source,
                                    line_cd,
                                    subline_cd,
                                    loss_year,
                                    item_no, peril_cd,
                                    loss_cat_cd,
                                    grp_seq_no,
                                    ri_cd,
                                    prnt_ri_cd,
                                    shr_ri_pct,
                                    loss_reserve,
                                    losses_paid,
                                    expense_reserve,
                                    expenses_paid,
                                    user_id, last_update
                                   )
                            VALUES (v_session_id, v_brdrx_ds_record_id,
                                    v_brdrx_rids_record_id, brdrx_extr_rec.claim_id,
                                    brdrx_extr_rec.iss_cd,
                                    brdrx_extr_rec.buss_source,
                                    brdrx_extr_rec.line_cd,
                                    brdrx_extr_rec.subline_cd,
                                    brdrx_extr_rec.loss_year,
                                    brdrx_extr_rec.item_no, brdrx_extr_rec.peril_cd,
                                    brdrx_extr_rec.loss_cat_cd,
                                    paid_ds_rec.grp_seq_no,
                                    paid_rids_rec.ri_cd,
                                    paid_rids_rec.prnt_ri_cd,
                                    paid_rids_rec.shr_ri_pct,
                                    0,
                                    paid_rids_rec.losses_paid,
                                    0, 
                                    paid_rids_rec.expenses_paid,
                                    NVL(v_user_id, USER), SYSDATE
                                   );
                    END;
                 END LOOP;
              END LOOP;
                
           ELSE --not Losses Paid
          FOR reserve_ds_rec IN loss_reserve_ds (brdrx_extr_rec.claim_id,
                                                 brdrx_extr_rec.item_no,
                                                 brdrx_extr_rec.peril_cd,
                                                 brdrx_extr_rec.grouped_item_no,
                                                 brdrx_extr_rec.clm_res_hist_id,
                                                 brdrx_extr_rec.loss_reserve,
                                                 brdrx_extr_rec.expense_reserve,
                                                 brdrx_extr_rec.losses_paid,
                                                 brdrx_extr_rec.expenses_paid
                                                 )
          LOOP
             BEGIN
                v_brdrx_ds_record_id := v_brdrx_ds_record_id + 1;

                INSERT INTO gicl_res_brdrx_ds_extr
                            (session_id, brdrx_record_id,
                             brdrx_ds_record_id, claim_id,
                             iss_cd, buss_source,
                             line_cd, subline_cd,
                             loss_year, item_no,
                             peril_cd,
                             loss_cat_cd,
                             grp_seq_no, shr_pct,
                             loss_reserve,
                             losses_paid, 
                             expense_reserve,
                             expenses_paid,
                             user_id, last_update
                            )
                     VALUES (v_session_id, brdrx_extr_rec.brdrx_record_id,
                             v_brdrx_ds_record_id, brdrx_extr_rec.claim_id,
                             brdrx_extr_rec.iss_cd, brdrx_extr_rec.buss_source,
                             brdrx_extr_rec.line_cd, brdrx_extr_rec.subline_cd,
                             brdrx_extr_rec.loss_year, brdrx_extr_rec.item_no,
                             brdrx_extr_rec.peril_cd,
                             brdrx_extr_rec.loss_cat_cd,
                             reserve_ds_rec.grp_seq_no, reserve_ds_rec.shr_pct,
                             reserve_ds_rec.loss_reserve,
                             reserve_ds_rec.losses_paid,
                             reserve_ds_rec.expense_reserve, 
                             reserve_ds_rec.expenses_paid,
                             NVL(v_user_id, USER), SYSDATE
                            );
             END;

             FOR reserve_rids_rec IN
                loss_reserve_rids (reserve_ds_rec.claim_id,
                                   reserve_ds_rec.clm_res_hist_id,
                                   reserve_ds_rec.clm_dist_no,
                                   reserve_ds_rec.grp_seq_no,
                                   reserve_ds_rec.loss_reserve,
                                   reserve_ds_rec.expense_reserve,
                                   reserve_ds_rec.losses_paid,
                                   reserve_ds_rec.expenses_paid)
             LOOP
                BEGIN
                   v_brdrx_rids_record_id := v_brdrx_rids_record_id + 1;

                   INSERT INTO gicl_res_brdrx_rids_extr
                               (session_id, brdrx_ds_record_id,
                                brdrx_rids_record_id, claim_id,
                                iss_cd,
                                buss_source,
                                line_cd,
                                subline_cd,
                                loss_year,
                                item_no, peril_cd,
                                loss_cat_cd,
                                grp_seq_no,
                                ri_cd,
                                prnt_ri_cd,
                                shr_ri_pct,
                                loss_reserve,
                                losses_paid,
                                expense_reserve,
                                expenses_paid,
                                user_id, last_update
                               )
                        VALUES (v_session_id, v_brdrx_ds_record_id,
                                v_brdrx_rids_record_id, brdrx_extr_rec.claim_id,
                                brdrx_extr_rec.iss_cd,
                                brdrx_extr_rec.buss_source,
                                brdrx_extr_rec.line_cd,
                                brdrx_extr_rec.subline_cd,
                                brdrx_extr_rec.loss_year,
                                brdrx_extr_rec.item_no, brdrx_extr_rec.peril_cd,
                                brdrx_extr_rec.loss_cat_cd,
                                reserve_ds_rec.grp_seq_no,
                                reserve_rids_rec.ri_cd,
                                reserve_rids_rec.prnt_ri_cd,
                                reserve_rids_rec.shr_ri_pct_real,
                                reserve_rids_rec.loss_reserve,
                                reserve_rids_rec.losses_paid,
                                reserve_rids_rec.expense_reserve, 
                                reserve_rids_rec.expenses_paid,
                                NVL(v_user_id, USER), SYSDATE
                               );
                END;
             END LOOP;
          END LOOP;
           END IF;
       END LOOP;
       
       --distribution details of recoveries
       IF v_net_rcvry_chkbx = 'Y' THEN
          BEGIN
            SELECT MAX(rcvry_brdrx_ds_record_id)
              INTO v_rcvry_brdrx_ds_rec_id
              FROM gicl_rcvry_brdrx_ds_extr;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_rcvry_brdrx_ds_rec_id := 0;
          END;
          
          --distributed recoveries
          FOR rcvry_ds1_a IN rcvry_dist(v_session_id)
          LOOP
            FOR rcvry_ds1_b IN
              (SELECT a.rec_dist_no, a.dist_year, a.grp_seq_no,
                      a.share_type, a.share_pct,
                      (a.share_pct * NVL(rcvry_ds1_a.recovered_amt, 0))/100 shr_rcvry_amt_ds
                 FROM gicl_recovery_ds a
                WHERE a.recovery_id = rcvry_ds1_a.recovery_id
                  AND a.recovery_payt_id = rcvry_ds1_a.recovery_payt_id
                  AND NVL(a.negate_tag, 'N') = 'N')
            LOOP
              v_rcvry_brdrx_ds_rec_id := NVL(v_rcvry_brdrx_ds_rec_id, 0) + 1;
              
              INSERT INTO gicl_rcvry_brdrx_ds_extr (session_id, rcvry_brdrx_record_id, rcvry_brdrx_ds_record_id,
                                                    claim_id, recovery_id, recovery_payt_id,
                                                    line_cd, subline_cd, iss_cd,
                                                    item_no, peril_cd, recovered_amt,
                                                    rec_dist_no, dist_year, grp_seq_no,
                                                    share_type, share_pct, shr_recovery_amt,
                                                    acct_tran_id, payee_type)
                                            VALUES (v_session_id, rcvry_ds1_a.rcvry_brdrx_record_id, v_rcvry_brdrx_ds_rec_id,
                                                    rcvry_ds1_a.claim_id, rcvry_ds1_a.recovery_id, rcvry_ds1_a.recovery_payt_id,
                                                    rcvry_ds1_a.line_cd, rcvry_ds1_a.subline_cd, rcvry_ds1_a.iss_cd,
                                                    rcvry_ds1_a.item_no, rcvry_ds1_a.peril_cd, rcvry_ds1_a.recovered_amt,
                                                    rcvry_ds1_b.rec_dist_no, rcvry_ds1_b.dist_year, rcvry_ds1_b.grp_seq_no,
                                                    rcvry_ds1_b.share_type, rcvry_ds1_b.share_pct, rcvry_ds1_b.shr_rcvry_amt_ds,
                                                    rcvry_ds1_a.acct_tran_id, rcvry_ds1_a.payee_type);
                                                    
                --RI distribution details
                   FOR rcvry_rids_b IN
                  (SELECT a.share_type, a.ri_cd, a.share_ri_pct,
                          (a.share_ri_pct/rcvry_ds1_b.share_pct * rcvry_ds1_b.shr_rcvry_amt_ds) shr_rcvry_amt_rids
                     FROM gicl_recovery_rids a
                    WHERE a.recovery_id = rcvry_ds1_a.recovery_id
                      AND a.recovery_payt_id = rcvry_ds1_a.recovery_payt_id
                      AND a.rec_dist_no = rcvry_ds1_b.rec_dist_no
                      AND a.grp_seq_no = rcvry_ds1_b.grp_seq_no
                      AND NVL(a.negate_tag, 'N') = 'N')                
                LOOP
                    v_rcvry_brdrx_rids_rec_id := NVL(v_rcvry_brdrx_rids_rec_id, 0) + 1;
                    
                     INSERT INTO gicl_rcvry_brdrx_rids_extr (session_id, rcvry_brdrx_ds_record_id, rcvry_brdrx_rids_record_id,
                                              claim_id, recovery_id, recovery_payt_id,
                                              line_cd, subline_cd, iss_cd,
                                              item_no, peril_cd, rec_dist_no,
                                              dist_year, grp_seq_no, share_type,
                                              ri_cd, share_ri_pct, shr_ri_recovery_amt,
                                              acct_tran_id, payee_type)
                                      VALUES (v_session_id, v_rcvry_brdrx_ds_rec_id, v_rcvry_brdrx_rids_rec_id,
                                              rcvry_ds1_a.claim_id, rcvry_ds1_a.recovery_id, rcvry_ds1_a.recovery_payt_id,
                                              rcvry_ds1_a.line_cd, rcvry_ds1_a.subline_cd, rcvry_ds1_a.iss_cd,
                                              rcvry_ds1_a.item_no, rcvry_ds1_a.peril_cd, rcvry_ds1_b.rec_dist_no,
                                              rcvry_ds1_b.dist_year, rcvry_ds1_b.grp_seq_no, rcvry_ds1_b.share_type,
                                              rcvry_rids_b.ri_cd, rcvry_rids_b.share_ri_pct, rcvry_rids_b.shr_rcvry_amt_rids,
                                              rcvry_ds1_a.acct_tran_id, rcvry_ds1_a.payee_type);
                END LOOP;
            END LOOP;
          END LOOP;
          
          --undistributed recoveries
          FOR rcvry_ds2 IN rcvry_undist(v_session_id)
          LOOP
              v_rcvry_brdrx_ds_rec_id := NVL(v_rcvry_brdrx_ds_rec_id, 0) + 1;
              
              INSERT INTO gicl_rcvry_brdrx_ds_extr (session_id, rcvry_brdrx_record_id, rcvry_brdrx_ds_record_id,
                                                    claim_id, recovery_id, recovery_payt_id,
                                                    line_cd, subline_cd, iss_cd,
                                                    item_no, peril_cd, recovered_amt,
                                                    rec_dist_no, dist_year, grp_seq_no,
                                                    share_type, share_pct, shr_recovery_amt,
                                                    acct_tran_id, payee_type)
                                            VALUES (v_session_id, rcvry_ds2.rcvry_brdrx_record_id, v_rcvry_brdrx_ds_rec_id,
                                                    rcvry_ds2.claim_id, rcvry_ds2.recovery_id, rcvry_ds2.recovery_payt_id,
                                                    rcvry_ds2.line_cd, rcvry_ds2.subline_cd, rcvry_ds2.iss_cd,
                                                    rcvry_ds2.item_no, rcvry_ds2.peril_cd, rcvry_ds2.recovered_amt,
                                                    rcvry_ds2.rec_dist_no, rcvry_ds2.dist_year, rcvry_ds2.grp_seq_no,
                                                    rcvry_ds2.share_type, rcvry_ds2.share_pct, rcvry_ds2.shr_recovery_amt,
                                                    rcvry_ds2.acct_tran_id, rcvry_ds2.payee_type);
          END LOOP;
         
            -- update buss_source column in all recovery brdrx tables
            FOR bs IN
            (SELECT DISTINCT session_id, claim_id, item_no, peril_cd, buss_source
               FROM gicl_res_brdrx_extr
              WHERE claim_id IN (SELECT claim_id
                                   FROM gicl_rcvry_brdrx_extr
                                  WHERE session_id = v_session_id)
                AND session_id = v_session_id)
            LOOP
                UPDATE gicl_rcvry_brdrx_extr
                   SET buss_source = bs.buss_source
                 WHERE session_id = bs.session_id
                   AND claim_id = bs.claim_id
                   AND item_no = bs.item_no
                   AND peril_cd = bs.peril_cd;

                UPDATE gicl_rcvry_brdrx_ds_extr
                   SET buss_source = bs.buss_source
                 WHERE session_id = bs.session_id
                   AND claim_id = bs.claim_id
                   AND item_no = bs.item_no
                   AND peril_cd = bs.peril_cd;

                UPDATE gicl_rcvry_brdrx_rids_extr
                   SET buss_source = bs.buss_source
                 WHERE session_id = bs.session_id
                   AND claim_id = bs.claim_id
                   AND item_no = bs.item_no
                   AND peril_cd = bs.peril_cd;
            END LOOP;
            
       END IF;
       
      BEGIN
         SELECT COUNT (*)
           INTO p_count
           FROM gicl_res_brdrx_extr
          WHERE session_id = v_session_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_count := 0;
      END;

      IF p_count > 0 THEN
         MERGE INTO gicl_res_brdrx_extr_param
         USING DUAL ON (user_id = p_user_id)
            WHEN NOT MATCHED THEN
               INSERT(line_cd, subline_cd, iss_cd, peril_cd, intm_no, loss_cat_cd, enrollee, control_type, control_number,
                      pol_line_cd, pol_subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, as_of_date, per_buss, per_issource,
                      per_line_subline, per_policy, per_enrollee, per_line, per_branch, per_intm, per_loss_cat, user_id)
               VALUES(p_dsp_line_cd, p_dsp_subline_cd, p_dsp_iss_cd, p_dsp_peril_cd, p_dsp_intm_no, p_dsp_loss_cat_cd, p_dsp_enrollee, p_dsp_control_type, p_dsp_control_number,
                      p_dsp_line_cd2, p_dsp_subline_cd2, p_dsp_iss_cd2, p_issue_yy, p_pol_seq_no, p_renew_no, p_dsp_as_of_date, p_per_intermediary, p_per_issource,
                      p_per_line_subline, p_per_policy, p_per_enrollee, p_per_line, p_per_iss, p_per_buss, p_per_loss_cat, p_user_id)
            WHEN MATCHED THEN
               UPDATE
                  SET line_cd = p_dsp_line_cd,
                      subline_cd = p_dsp_subline_cd,
                      iss_cd = p_dsp_iss_cd,
                      peril_cd = p_dsp_peril_cd, 
                      intm_no = p_dsp_intm_no, 
                      loss_cat_cd = p_dsp_loss_cat_cd, 
                      enrollee = p_dsp_enrollee, 
                      control_type = p_dsp_control_type, 
                      control_number = p_dsp_control_number,
                      pol_line_cd = p_dsp_line_cd2, 
                      pol_subline_cd = p_dsp_subline_cd2, 
                      pol_iss_cd = p_dsp_iss_cd2, 
                      issue_yy = p_issue_yy, 
                      pol_seq_no = p_pol_seq_no, 
                      renew_no = p_renew_no,
                      as_of_date = p_dsp_as_of_date,
                      per_buss = p_per_intermediary, 
                      per_issource = p_per_issource,
                      per_line_subline = p_per_line_subline, 
                      per_policy = p_per_policy, 
                      per_enrollee = p_per_enrollee, 
                      per_line = p_per_line, 
                      per_branch = p_per_iss, 
                      per_intm = p_per_buss, 
                      per_loss_cat = p_per_loss_cat;
      ELSE
         DELETE FROM gicl_res_brdrx_extr_param
          WHERE user_id = p_user_id;
      END IF;
   END;
   
   FUNCTION GET_PARENT_INTM(p_intrmdry_intm_no IN giis_intermediary.intm_no%TYPE) RETURN NUMBER IS
         v_intm_no              giis_intermediary.intm_no%TYPE;
    BEGIN
        BEGIN
           SELECT NVL(a.parent_intm_no,a.intm_no)
             INTO v_intm_no
             FROM giis_intermediary a
            WHERE LEVEL = (SELECT MAX(LEVEL)
                             FROM giis_intermediary b
                          CONNECT BY PRIOR b.parent_intm_no = b.intm_no
                              AND lic_tag        = 'N'
                            START WITH b.intm_no = p_intrmdry_intm_no
                              AND lic_tag        = 'N')
          CONNECT BY PRIOR a.parent_intm_no      = a.intm_no 
            START WITH a.intm_no = p_intrmdry_intm_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_intm_no := p_intrmdry_intm_no;
          WHEN OTHERS THEN    
            NULL;
        END;
        RETURN v_intm_no; 
    END GET_PARENT_INTM;
    
    FUNCTION GET_TOT_PREM_AMT(p_claim_id IN gicl_claims.claim_id%type,
                              p_item_no  IN gicl_item_peril.item_no%type,
                              p_peril_cd IN gicl_item_peril.peril_cd%type)
                            RETURN NUMBER IS
    v_tot_prem_amt          gipi_itmperil.prem_amt%type;
    BEGIN
        BEGIN
          SELECT SUM(b.prem_amt) tot_prem_amt
            INTO v_tot_prem_amt
            FROM gipi_polbasic a, gipi_itmperil b, gicl_claims c, giuw_pol_dist d
           WHERE b.peril_cd    = p_peril_cd
             AND b.item_no     = p_item_no
             AND b.policy_id   = a.policy_id
             AND c.loss_date  >= a.eff_date
             AND c.loss_date  <= NVL(a.endt_expiry_date,a.expiry_date)
             AND a.policy_id   = d.policy_id
             AND d.dist_flag   = '3'     
             AND a.line_cd     = c.line_cd 
             AND a.subline_cd  = c.subline_cd
             AND a.iss_cd      = c.pol_iss_cd
             AND a.issue_yy    = c.issue_yy
             AND a.pol_seq_no  = c.pol_seq_no
             AND a.renew_no    = c.renew_no
             AND c.claim_id    = p_claim_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_tot_prem_amt := 0;
        END;  
    RETURN (v_tot_prem_amt);
  END GET_TOT_PREM_AMT;
  
  FUNCTION CHECK_CLOSE_DATE1(p_brdrx_type IN NUMBER,
                             p_claim_id IN gicl_claims.claim_id%type,
                             p_item_no  IN gicl_item_peril.item_no%type,
                             p_peril_cd IN gicl_item_peril.peril_cd%type,
                             p_date     IN DATE)
         RETURN NUMBER IS
     v_valid NUMBER(1):= 0;
  BEGIN
     FOR i IN (SELECT 1
                 FROM gicl_item_peril a
                WHERE a.claim_id = p_claim_id
                  AND a.item_no = p_item_no
                  AND a.peril_cd = p_peril_cd
                  AND (((a.close_date > p_date OR a.close_date IS NULL) AND p_brdrx_type = 1) OR p_brdrx_type = 2)
                      --(DECODE(a.close_flag, 'WD', a.close_date, 'DN', a.close_date, p_date + 1) > p_date AND p_brdrx_type = 2))
                      --exclude record if CLOSE_DATE of invalid peril status is later than parameter date used in extracting Losses Paid by MAC 08/16/2013.
                      --exclude checking of close_flag if extracting Losses Paid by MAC 08/28/2013.
                      --(DECODE(a.close_flag, 'AP', p_date + 1, 'CP', p_date + 1, 'CC', p_date + 1, a.close_date) > p_date AND p_brdrx_type = 2))
              )
     LOOP
        v_valid := 1;
     END LOOP;
     RETURN (v_valid);
  END CHECK_CLOSE_DATE1;
    
  FUNCTION CHECK_CLOSE_DATE2(p_brdrx_type IN NUMBER,
                             p_claim_id IN gicl_claims.claim_id%type,
                             p_item_no  IN gicl_item_peril.item_no%type,
                             p_peril_cd IN gicl_item_peril.peril_cd%type,
                             p_date     IN DATE)
         RETURN NUMBER IS
     v_valid NUMBER(1):= 0;
  BEGIN
     FOR i IN (SELECT 1
                 FROM gicl_item_peril a
                WHERE a.claim_id = p_claim_id
                  AND a.item_no = p_item_no
                  AND a.peril_cd = p_peril_cd
                  AND (((a.close_date2 > p_date OR a.close_date2 IS NULL) AND p_brdrx_type = 1) OR p_brdrx_type = 2)
                      --(DECODE(a.close_flag2, 'WD', a.close_date2, 'DN', a.close_date2, p_date + 1) > p_date AND p_brdrx_type = 2))
                      --exclude record if CLOSE_DATE of invalid peril status is later than parameter date used in extracting Losses Paid by MAC 08/16/2013.
                      --exclude checking of close_flag2 if extracting Losses Paid by MAC 08/28/2013.
                      --(DECODE(a.close_flag2, 'AP', p_date + 1, 'CP', p_date + 1, 'CC', p_date + 1, a.close_date2) > p_date AND p_brdrx_type = 2))
              )
     LOOP
        v_valid := 1;
     END LOOP;
     RETURN (v_valid);
  END CHECK_CLOSE_DATE2;
  
  FUNCTION GET_REVERSAL(p_tran_id           IN gicl_clm_res_hist.tran_id%TYPE,
                        p_from_date         IN DATE,
                        p_to_date           IN DATE,
                        p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE)     
        RETURN NUMBER IS
     v_multiplier NUMBER(1) := 1;
  BEGIN
     IF p_paid_date_option IS NULL THEN
        RETURN (v_multiplier);
     END IF;
     /*comment out by MAC 07/17/2013
     FOR i IN (SELECT gacc_tran_id
                 FROM giac_reversals 
                WHERE gacc_tran_id = p_tran_id)
     LOOP
        FOR ii IN (SELECT DISTINCT DECODE(p_paid_date_option, 1, TRUNC(date_paid), 2, TRUNC(posting_date)) date_paid, TRUNC(cancel_date) cancel_date
                     FROM gicl_clm_res_hist a, giac_acctrans b
                    WHERE cancel_tag = 'Y'
                      AND a.tran_id = i.gacc_tran_id
                      AND a.tran_id = b.tran_id)
        LOOP
            IF (ii.cancel_date <= p_to_date) AND (ii.date_paid BETWEEN p_from_date AND p_to_date) THEN
                v_multiplier := 0; --return 0 amount if cancellation happens on or before TO date parameter and payment happens between parameter date
            ELSIF (ii.cancel_date BETWEEN p_from_date AND p_to_date) AND (ii.date_paid < p_from_date) THEN
                v_multiplier := -1; --return negative amount if payment happens before FROM date parameter
            END IF;
        END LOOP;
     END LOOP;*/
     
     --return negative amount if posting date or tran date of reversal is between parameter date by MAC 07/17/2013.
     FOR i IN ( SELECT DISTINCT 1
                  FROM giac_reversals a, giac_acctrans b
                 WHERE a.reversing_tran_id = b.tran_id 
                   AND a.gacc_tran_id = p_tran_id
                   AND DECODE(p_paid_date_option, 1, TRUNC(tran_date), 2, TRUNC(posting_date)) BETWEEN p_from_date AND p_to_date)
     LOOP
        v_multiplier := -1; 
        FOR ii IN (SELECT 1
                     FROM gicl_clm_res_hist a, giac_acctrans b
                    WHERE a.tran_id = b.tran_id
                      AND a.tran_id = p_tran_id
                      AND DECODE(p_paid_date_option, 1, TRUNC(tran_date), 2, TRUNC(posting_date)) BETWEEN p_from_date AND p_to_date)
        LOOP
            --Return zero if Date Paid and Reversal is included in extraction. Changes is only applied if Based on Tran Date by MAC 08/16/2013.
            --IF p_paid_date_option = 1 THEN comment out by MAC 09/10/2013
                v_multiplier := 0; 
            --END IF;
        END LOOP;
     END LOOP;
     RETURN (v_multiplier);
  END GET_REVERSAL;
    
  FUNCTION GET_VOUCHER_CHECK_NO(p_claim_id            IN gicl_clm_res_hist.claim_id%TYPE,
                                  p_item_no           IN gicl_clm_res_hist.item_no%TYPE,
                                  p_peril_cd          IN gicl_clm_res_hist.peril_cd%TYPE,
                                  p_grouped_item_no   IN gicl_clm_res_hist.grouped_item_no%TYPE,
                                  p_dsp_from_date     IN DATE,
                                  p_dsp_to_date       IN DATE,
                                  p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
                                  p_payee_type        IN VARCHAR)     
        RETURN VARCHAR IS
    var_dv_no   VARCHAR2(4000);
  BEGIN
    FOR i IN (  SELECT a.tran_id, DECODE(c.gacc_tran_id, NULL, NULL, ' /'||c.check_pref_suf||'-'||LPAD(c.check_no,10,0)) check_no, 
                       TO_CHAR(NVL(a.cancel_date, SYSDATE),'MM/DD/YYYY') cancel_date
                  FROM gicl_clm_res_hist a, giac_acctrans b, giac_chk_disbursement c
                 WHERE a.claim_id = p_claim_id
                   AND a.item_no = NVL(p_item_no, a.item_no)
                   AND a.peril_cd = NVL(p_peril_cd, a.peril_cd)
                   AND a.grouped_item_no = NVL(p_grouped_item_no, a.grouped_item_no)
                   AND a.tran_id IS NOT NULL
                   AND a.tran_id = b.tran_id
                   AND a.tran_id = c.gacc_tran_id (+)
                   AND b.tran_flag != 'D'
                   AND (TRUNC( DECODE( p_paid_date_option, 1, a.date_paid, 2, b.posting_date ) ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                       OR DECODE(GICLS202_PKG.GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1)
                   AND (DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), (p_dsp_to_date + 1)) > p_dsp_to_date
                       OR DECODE(GICLS202_PKG.GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1)
                   AND DECODE (p_payee_type, 'L', NVL(a.losses_paid,0), 'E', NVL(a.expenses_paid,0)) <> 0 )
    LOOP  
         IF GICLS202_PKG.GET_REVERSAL(i.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option) <> 1 THEN
            IF var_dv_no IS NULL THEN
                var_dv_no := get_ref_no(i.tran_id)||i.check_no||' cancelled '||i.cancel_date;
            ELSE
                var_dv_no := var_dv_no || chr(10) || get_ref_no(i.tran_id)||i.check_no||' cancelled '||i.cancel_date;
            END IF;
         ELSE
            IF var_dv_no IS NULL THEN
                var_dv_no := get_ref_no(i.tran_id)||i.check_no;
            ELSE
                var_dv_no := var_dv_no || chr(10) || get_ref_no(i.tran_id)||i.check_no;
            END IF;
         END IF;
    END LOOP;
    RETURN(var_dv_no);
  END GET_VOUCHER_CHECK_NO;
  
  FUNCTION GET_GICLR209_DTL(p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
                            p_dsp_from_date     IN DATE,
                            p_dsp_to_date       IN DATE,
                            p_paid_date_option  IN gicl_res_brdrx_extr.pd_date_opt%TYPE,
                            p_payee_type        IN VARCHAR,
                            p_type              IN VARCHAR)     
        RETURN VARCHAR IS
    var_dv_no   VARCHAR2(4000);
  BEGIN
    FOR i IN (  SELECT a.tran_id, DECODE(c.gacc_tran_id, NULL, NULL, c.check_pref_suf||'-'||LPAD(c.check_no,10,0)) check_no, 
                       TO_CHAR(NVL(a.cancel_date, SYSDATE),'MM-DD-YYYY') cancel_date,
                       TO_CHAR(a.date_paid, 'MM-DD-YYYY') tran_date
                  FROM gicl_clm_res_hist a, giac_acctrans b, giac_chk_disbursement c
                 WHERE a.claim_id = p_claim_id
                   AND a.tran_id IS NOT NULL
                   AND a.tran_id = b.tran_id
                   AND a.tran_id = c.gacc_tran_id (+)
                   AND b.tran_flag != 'D'
                   AND (TRUNC( DECODE( p_paid_date_option, 1, a.date_paid, 2, b.posting_date ) ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                       OR DECODE(GICLS202_PKG.GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1)
                   AND (DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), (p_dsp_to_date + 1)) > p_dsp_to_date
                       OR DECODE(GICLS202_PKG.GET_REVERSAL(a.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option), 1, 0, 1) = 1)
                   AND DECODE (p_payee_type, 'L', NVL(a.losses_paid,0), 'E', NVL(a.expenses_paid,0)) <> 0 )
    LOOP  
        IF (p_type = 'CHECK_NO' AND i.check_no IS NOT NULL) OR (p_type = 'TRAN_DATE' AND i.tran_date IS NOT NULL) OR (p_type = 'ITEM_STAT_CD') THEN
           IF p_type = 'CHECK_NO' THEN
             IF GICLS202_PKG.GET_REVERSAL(i.tran_id, p_dsp_from_date, p_dsp_to_date, p_paid_date_option) <> 1 THEN
                IF var_dv_no IS NULL THEN
                    var_dv_no := i.check_no||' cancelled '||i.cancel_date;
                ELSE
                    var_dv_no := var_dv_no || chr(10) || i.check_no||' cancelled '||i.cancel_date;
                END IF;
             ELSE
                IF var_dv_no IS NULL THEN
                    var_dv_no := i.check_no;
                ELSE
                    var_dv_no := var_dv_no || chr(10) || i.check_no;
                END IF;
             END IF;
           ELSIF p_type = 'TRAN_DATE' THEN
             IF var_dv_no IS NULL THEN
                 var_dv_no := i.tran_date;
             ELSE
                 var_dv_no := var_dv_no || chr(10) || i.tran_date;
             END IF;
           ELSIF p_type = 'ITEM_STAT_CD' THEN
             FOR ii IN (SELECT item_stat_cd
                          FROM gicl_clm_loss_exp
                         WHERE payee_type = p_payee_type
                           AND tran_id = i.tran_id)
             LOOP
                IF var_dv_no IS NULL THEN
                    var_dv_no := ii.item_stat_cd;
                ELSE
                    var_dv_no := var_dv_no || chr(10) || ii.item_stat_cd;
                END IF;
             END LOOP;              
           END IF;
        END IF;
    END LOOP;
    RETURN(var_dv_no);
  END GET_GICLR209_DTL;            
END GICLS202_PKG;
/
