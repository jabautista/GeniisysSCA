CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_PER_MC_RPL_GICLR275
AS
    /*
    **  Created by        : carlo de guzman SR-5409
    */
      FUNCTION csv_giclr275 (
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_FROM_LDATE      VARCHAR2,
      P_TO_LDATE        VARCHAR2,
      P_AS_OF_LDATE     VARCHAR2, 
      P_MOTCAR_COMP_CD  gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      P_MAKE_CD         gicl_motor_car_dtl.make_cd%TYPE,
      P_MODEL_YEAR      gicl_motor_car_dtl.model_year%TYPE,
      P_LOSS_EXP_CD     VARCHAR2,
      P_USER_ID         VARCHAR2
    )
       RETURN GICLR275_details_tab PIPELINED
    AS
       v_rec   GICLR275_details_type;
    BEGIN
    
       
       FOR i IN (SELECT DISTINCT a.motcar_comp_cd, a.make_cd, b.car_company, c.make,
                a.model_year, d.loss_exp_cd, d.loss_exp_desc, e.item_no,
                e.hist_seq_no, NVL (f.ded_base_amt, 0) amount, f.user_id,
                f.last_update, g.le_stat_desc,
                   h.line_cd
                || '-'
                || h.subline_cd
                || '-'
                || h.iss_cd
                || '-'
                || LTRIM (TO_CHAR (h.clm_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (h.clm_seq_no, '0000009')) claim_number,
                   h.line_cd
                || '-'
                || h.subline_cd
                || '-'
                || h.pol_iss_cd
                || '-'
                || LTRIM (TO_CHAR (h.issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (h.pol_seq_no, '0000009'))
                || '-'
                || LTRIM (TO_CHAR (h.renew_no, '09')) policy_number,
                i.class_desc, j.payee_last_name, k.assd_name, h.loss_date, k.first_name, k.last_name, k.middle_initial,
                h.clm_file_date, l.clm_stat_desc, m.peril_name
           FROM gicl_motor_car_dtl a,
                giis_mc_car_company b,
                giis_mc_make c,
                giis_loss_exp d,
                gicl_clm_loss_exp e,
                gicl_loss_exp_dtl f,
                gicl_le_stat g,
                gicl_claims h,
                giis_payee_class i,
                giis_payees j,
                giis_assured k,
                giis_clm_stat l,
                giis_peril m
          WHERE a.motcar_comp_cd = b.car_company_cd
            AND a.make_cd = c.make_cd
            AND a.motcar_comp_cd = c.car_company_cd
            AND d.line_cd = 'MC'
            AND d.part_sw = 'Y'
            AND d.loss_exp_type = 'L'
            AND m.peril_cd = e.peril_cd
            AND m.line_cd = f.line_cd
            AND h.clm_stat_cd = l.clm_stat_cd
            AND h.assd_no = k.assd_no
            AND e.payee_cd = j.payee_no
            AND i.payee_class_cd = e.payee_class_cd
            AND e.payee_class_cd = j.payee_class_cd
            AND e.item_stat_cd = g.le_stat_cd
            AND a.claim_id = h.claim_id
            AND a.claim_id = e.claim_id
            AND a.claim_id = f.claim_id
            AND d.loss_exp_cd = f.loss_exp_cd
            AND e.clm_loss_id = f.clm_loss_id
            AND a.motcar_comp_cd = p_motcar_comp_cd
            AND a.make_cd = p_make_cd
            AND NVL (a.model_year, 'NOT SPECIFIED') =
                                          NVL (p_model_year, 'NOT SPECIFIED')
            AND d.loss_exp_cd = p_loss_exp_cd
            AND (   (       TRUNC (h.clm_file_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY')
                        AND TRUNC (h.clm_file_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY')
                     OR TRUNC (h.clm_file_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')
                    )
                 OR (       TRUNC (h.loss_date) >= TO_DATE(p_from_ldate, 'MM-DD-YYYY')
                        AND TRUNC (h.loss_date) <= TO_DATE(p_to_ldate, 'MM-DD-YYYY')
                     OR TRUNC (h.loss_date) <= TO_DATE(p_as_of_ldate, 'MM-DD-YYYY')
                    )
                )
            /*start of condition added by aliza 07/23/2012*/
            AND check_user_per_iss_cd2 (h.line_cd, h.iss_cd, 'GICLS275',p_user_id) = 1
       /*end of condition added by aliza 07/23/2012*/
        ORDER BY  a.motcar_comp_cd, a.make_cd, a.model_year, d.loss_exp_cd
        )

       LOOP
          --v_rec.motcar_comp_cd := i.motcar_comp_cd;
          --v_rec.make_cd := i.make_cd;
          v_rec.car_company := i.motcar_comp_cd || ' - ' ||  i.car_company;
          v_rec.make := i.make_cd || ' - ' || i.make;
          v_rec.model_year := TO_CHAR(TO_DATE(i.model_year, 'YYYY'),'RRRR');
          v_rec.parts := i.loss_exp_cd || ' - ' || i.loss_exp_desc;
          --v_rec.loss_exp_desc := i.loss_exp_desc;
          v_rec.item := i.item_no;
          v_rec.hist_no := i.hist_seq_no;
          v_rec.amount := trim(to_char(i.amount,'999,999,999,990.00')); --modified amount format by carlo rubenecia 04.28.2016 SR 5409
          v_rec.user_id := i.user_id;
          v_rec.last_update := TO_CHAR(i.last_update,'MM-DD-RRRR');
          v_rec.status := i.le_stat_desc;
          v_rec.claim_number := i.claim_number;
          v_rec.policy_number := i.policy_number;
          --v_rec.class_desc := i.class_desc;
          v_rec.payee := i.class_desc || ' - ' || i.payee_last_name;
          --v_rec.assured := i.assd_name;
          v_rec.loss_date := TO_CHAR(i.loss_date,'MM-DD-RRRR');
          v_rec.file_date := TO_CHAR(i.clm_file_date,'MM-DD-RRRR');
          v_rec.claim_status := i.clm_stat_desc;
          v_rec.peril := i.peril_name;
          
          
          IF i.first_name IS NULL
            THEN v_rec.assured := i.assd_name;
            ELSE v_rec.assured := (i.last_name || ', ' || i.first_name || ' ' || i.middle_initial);
            END IF;

          PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;

END CSV_CLM_PER_MC_RPL_GICLR275;
/
