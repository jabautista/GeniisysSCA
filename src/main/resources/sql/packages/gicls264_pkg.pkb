CREATE OR REPLACE PACKAGE BODY CPI.GICLS264_PKG AS

    FUNCTION get_clm_list_per_color (
      p_user_id             GIIS_USERS.user_id%TYPE,
      p_color_cd            GICL_MOTOR_CAR_DTL.color_cd%TYPE,
      p_basic_color_cd      GICL_MOTOR_CAR_DTL.basic_color_cd%TYPE,
      p_search_by           VARCHAR2,
      p_as_of_date          VARCHAR2,
      p_from_date           VARCHAR2,   
      p_to_date             VARCHAR2
    ) 
        RETURN clm_list_per_color_tab PIPELINED
    IS
      v_list clm_list_per_color_type;
      p_line_cd        GIIS_LINE.line_cd%TYPE := NULL;      --set to null; no value is passed as referenced to GICLS264.fmb
      p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE := NULL;
    BEGIN
      FOR i IN (
          SELECT a.claim_id, TO_CHAR(a.item_no, '000000009') item_no, a.item_title, DECODE(a.plate_no, NULL, 'N', 'Y') plate_no,
                 SUM(NVL(b.loss_reserve,0)) loss_reserve, SUM(NVL(b.losses_paid,0)) losses_paid,
                 SUM(NVL(b.expense_reserve,0)) exp_reserve, SUM(NVL(b.expenses_paid,0)) exp_paid,
                   c.line_cd
                || '-'
                || c.subline_cd
                || '-'
                --|| c.iss_cd
                || c.pol_iss_cd
                || '-'
                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                || '-'
                || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                 c.clm_yy, c.clm_seq_no, c.pol_iss_cd, c.assd_no, 
                 c.loss_date, c.clm_file_date, d.assd_name, e.clm_stat_desc
            FROM GICL_MOTOR_CAR_DTL a,
                 GICL_CLM_RESERVE b,
                 GICL_CLAIMS c, 
                 GIIS_ASSURED d,
                 GIIS_CLM_STAT e
           WHERE b.claim_id = a.claim_id
             AND b.item_no = a.item_no
             AND c.claim_id = a.claim_id
             AND c.assd_no  = d.assd_no
             AND c.clm_stat_cd = e.clm_stat_cd 
             AND a.claim_id IN (
                      SELECT claim_id
                        FROM GICL_CLAIMS
                       WHERE CHECK_USER_PER_LINE2 (c.line_cd,	--changed by Gzelle 04.11.2014 p_line_cd,
                                                   c.iss_cd,	--changed by Gzelle 04.11.2014 p_iss_cd,
                                                   'GICLS264',
                                                   p_user_id
                                                  ) = 1
						AND CHECK_USER_PER_ISS_CD2 (c.line_cd,	--added by Gzelle 04.11.2014
                                                   c.iss_cd,
                                                   'GICLS264',
                                                   p_user_id
                                                  ) = 1)             
             AND a.color_cd = p_color_cd
             AND a.basic_color_cd = p_basic_color_cd
             AND ((DECODE (p_search_by,
                           'lossDate', TRUNC(c.loss_date), --added trunc by robert 10.02.2013
                           'claimFileDate', TRUNC(c.clm_file_date)) >= TO_DATE(p_from_date, 'MM-DD-YYYY')) --added trunc by robert 10.02.2013
                   AND (DECODE (p_search_by,
                                'lossDate', TRUNC(c.loss_date), --added trunc by robert 10.02.2013
                                'claimFileDate', TRUNC(c.clm_file_date)) <= TO_DATE(p_to_date, 'MM-DD-YYYY')) --added trunc by robert 10.02.2013
                   OR (DECODE (p_search_by,
                                'lossDate', TRUNC(c.loss_date), --added trunc by robert 10.02.2013
                                'claimFileDate', TRUNC(c.clm_file_date)) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY')) --added trunc by robert 10.02.2013
                 )                                   
        GROUP BY a.claim_id, a.item_no, a.item_title, a.plate_no, c.line_cd, c.clm_yy, c.clm_seq_no, c.pol_iss_cd, c.assd_no, c.renew_no, 
                 c.loss_date, c.clm_file_date, d.assd_name, e.clm_stat_desc, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no                             
        ORDER BY a.item_no, a.item_title                         
      )
      
      LOOP
        v_list.claim_id         := i.claim_id;
        v_list.item_no          := i.item_no;
        v_list.item_title       := i.item_title;
        v_list.plate_no         := i.plate_no;
        v_list.claim_number     := GET_CLAIM_NUMBER(i.claim_id);
        v_list.loss_res_amt     := i.loss_reserve;
        v_list.loss_paid_amt    := i.losses_paid;
        v_list.exp_res_amt      := i.exp_reserve;
        v_list.exp_paid_amt     := i.exp_paid;
        v_list.policy_no        := i.policy_no;
        v_list.assd_name        := i.assd_name;
        v_list.clm_stat_desc    := i.clm_stat_desc;
        v_list.loss_date        := i.loss_date;
        v_list.clm_file_date    := i.clm_file_date;        
        
        IF v_list.tot_loss_res_amt IS NULL 
          AND v_list.tot_loss_paid_amt IS NULL
          AND v_list.tot_exp_res_amt IS NULL
          AND v_list.tot_exp_paid_amt IS NULL 
        THEN
          FOR b IN(
                SELECT SUM(NVL(b.loss_reserve,0)) loss_reserve, SUM(NVL(b.losses_paid,0)) losses_paid,
                       SUM(NVL(b.expense_reserve,0)) exp_reserve, SUM(NVL(b.expenses_paid,0)) exp_paid
                  FROM GICL_MOTOR_CAR_DTL a,
                       GICL_CLM_RESERVE b,
                       GICL_CLAIMS c
                 WHERE b.claim_id = a.claim_id
                   AND b.item_no = a.item_no
                   AND c.claim_id = a.claim_id
                   AND a.claim_id IN (
                          SELECT claim_id
                            FROM GICL_CLAIMS
                           WHERE CHECK_USER_PER_LINE2 (c.line_cd,	--changed by Gzelle 04.11.2014 p_line_cd,
													   c.iss_cd,	--changed by Gzelle 04.11.2014 p_iss_cd,
													   'GICLS264',
													   p_user_id
													  ) = 1
							 AND CHECK_USER_PER_ISS_CD2 (c.line_cd,	--added by Gzelle 04.11.2014
													     c.iss_cd,
													     'GICLS264',
													     p_user_id
													     ) = 1) 
                   AND a.color_cd = p_color_cd
                   AND a.basic_color_cd = p_basic_color_cd
                   AND ((DECODE (p_search_by,
                                 'lossDate', c.loss_date,
                                 'claimFileDate', c.clm_file_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY'))
                         AND (DECODE (p_search_by,
                                      'lossDate', c.loss_date,
                                      'claimFileDate', c.clm_file_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                         OR (DECODE (p_search_by,
                                     'lossDate', c.loss_date,
                                     'claimFileDate', c.clm_file_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                       )                     
                  )
          LOOP
            v_list.tot_loss_res_amt     := NVL(b.loss_reserve,0);
            v_list.tot_loss_paid_amt    := NVL(b.losses_paid,0);
            v_list.tot_exp_res_amt      := NVL(b.exp_reserve,0);
            v_list.tot_exp_paid_amt     := NVL(b.exp_paid,0);
          END LOOP;
         
        END IF;
        
        PIPE ROW(v_list);
        
      END LOOP;
      
      RETURN;
    
    END get_clm_list_per_color;


    FUNCTION validate_color_per_color(
        p_basic_color_cd     GIIS_MC_COLOR.basic_color_cd%TYPE,
        p_color              GIIS_MC_COLOR.color%TYPE
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
      
       BEGIN
       
       SELECT(SELECT 'X'
                FROM GIIS_MC_COLOR
               WHERE basic_color_cd = NVL(p_basic_color_cd, basic_color_cd)
                 AND UPPER(TRIM(color)) LIKE UPPER((NVL(p_color, '%')))
             )
       INTO v_temp_x
       FROM DUAL;
                          
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;                 
            
         END; 
         
    FUNCTION validate_basic_color_per_color(
        p_basic_color    GIIS_MC_COLOR.basic_color%TYPE
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
      
       BEGIN
       
       SELECT(SELECT DISTINCT 'X'
                FROM GIIS_MC_COLOR
               WHERE UPPER(TRIM(basic_color)) LIKE UPPER((NVL(p_basic_color, '%')))
             )
       INTO v_temp_x
       FROM DUAL;
                          
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;                 
         
         END;
            
END;
/


