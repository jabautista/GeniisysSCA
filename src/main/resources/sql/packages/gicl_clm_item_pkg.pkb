CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_item_pkg
AS

   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 08.19.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : post-insert in claim item info 
   */  
    PROCEDURE upd_gicl_clm_item(
        p_item_desc             gicl_clm_item.item_desc%TYPE,
        p_item_desc2            gicl_clm_item.item_desc2%TYPE,
        p_claim_id              gicl_clm_item.claim_id%TYPE,
        p_item_no               gicl_clm_item.item_no%TYPE
        ) IS
    BEGIN
        UPDATE gicl_clm_item
           SET item_desc = p_item_desc,
               item_desc2 = p_item_desc2
         WHERE claim_id = p_claim_id 
           AND item_no = p_item_no;
    END;
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 10.10.2011
   **  Reference By  : (GICLS010 - Basic Information) 
   **  Description   : check if gicl_clm_item exist 
   */        
    FUNCTION get_gicl_clm_item_exist( 
        p_claim_id          gicl_clm_item.claim_id%TYPE
        ) 
    RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_clm_item
                 WHERE claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;    

   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 10.26.2011
   **  Reference By  : (GICLS010 - Basic Information) 
   **  Description   : delete corresponding detail records in tables depending on the line of the claim  
   */  
    PROCEDURE clear_item_peril(
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
        p_msg_alert     OUT VARCHAR2
        ) IS
      v_linecdac        giis_line.line_cd%TYPE;
      v_linecdav        giis_line.line_cd%TYPE;
      v_linecdmn        giis_line.line_cd%TYPE;
      v_linecdca        giis_line.line_cd%TYPE;
      v_linecden        giis_line.line_cd%TYPE;
      v_linecdfi        giis_line.line_cd%TYPE;
      v_linecdmh        giis_line.line_cd%TYPE;
      v_linecdmd        giis_line.line_cd%TYPE;
      v_linecdmc        giis_line.line_cd%TYPE;
      v_del_line        giis_line.line_cd%TYPE;
      PROCEDURE get_param_value_v(
        p_param_name    IN  giis_parameters.param_name%TYPE,
        p_param_value   OUT giis_parameters.param_value_v%TYPE,
        p_msg_alert     OUT VARCHAR2
        )IS
      BEGIN
          FOR get_value IN(
            SELECT param_value_v
              FROM giis_parameters
             WHERE param_name = p_param_name)
          LOOP
            p_param_value := get_value.param_value_v;
          END LOOP;
          IF p_param_value IS NULL THEN
             p_msg_alert := 'Parameter ' ||p_param_name|| ' is not existing in table giis_parameters.';--,'I',TRUE);   
          END IF;
      END;
    BEGIN
      -- first delete peril records
      DELETE FROM gicl_item_peril
       WHERE claim_id = p_claim_id;

      --get value for line code parameters
      get_param_value_v(  'LINE_CODE_AC', v_linecdac, p_msg_alert);
      get_param_value_v(  'LINE_CODE_AV', v_linecdav, p_msg_alert);
      get_param_value_v(  'LINE_CODE_MN', v_linecdmn, p_msg_alert);
      get_param_value_v(  'LINE_CODE_CA', v_linecdca, p_msg_alert);
      get_param_value_v(  'LINE_CODE_EN', v_linecden, p_msg_alert);
      get_param_value_v(  'LINE_CODE_FI', v_linecdfi, p_msg_alert);
      get_param_value_v(  'LINE_CODE_MH', v_linecdmh, p_msg_alert);
      get_param_value_v(  'LINE_CODE_MD', v_linecdmd, p_msg_alert);
      get_param_value_v(  'LINE_CODE_MC', v_linecdmc, p_msg_alert);

      --get menu line cd for line
      FOR get_line IN(
        SELECT NVL(menu_line_cd, line_cd) line_cd
          FROM giis_line
         WHERE line_cd = p_line_cd)
      LOOP     
        v_del_line := get_line.line_cd;
      END LOOP;
     
      --delete corresponding detail record depending on the line code
      IF v_del_line = v_linecdac THEN
         DELETE FROM gicl_accident_dtl
               WHERE claim_id = p_claim_id;
         DELETE FROM gicl_beneficiary_dtl
               WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdav THEN
         DELETE FROM gicl_aviation_dtl
               WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdmn THEN
         DELETE FROM gicl_cargo_dtl
               WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdca THEN
         DELETE FROM gicl_casualty_dtl
           WHERE claim_id = p_claim_id;
         DELETE FROM gicl_casualty_personnel
           WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecden THEN
         DELETE FROM gicl_engineering_dtl
               WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdfi THEN
         DELETE FROM gicl_fire_dtl
           WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdmh THEN      
         DELETE FROM gicl_hull_dtl
               WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdmd THEN
         DELETE FROM gicl_medical_dtl
           WHERE claim_id = p_claim_id;
         DELETE FROM gicl_mi_other_dtls
               WHERE claim_id = p_claim_id;
      ELSIF v_del_line = v_linecdmc THEN
         DELETE FROM gicl_motor_car_dtl
           WHERE claim_id = p_claim_id;
      ELSE
         DELETE FROM gicl_clm_item
           WHERE claim_id = p_claim_id;
      END IF;
      
      UPDATE  gicl_clm_polbas
      SET     loss_date = p_dsp_loss_date
      WHERE      claim_id = p_claim_id;
     
    END;

    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.13.2012  
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  getting currency  LOV 
    */
    FUNCTION get_currency_list(p_claim_id      gicl_clm_item.claim_id%TYPE)
    RETURN currency_tab PIPELINED IS
      v_list        currency_type;
    BEGIN
        FOR i IN (SELECT a.main_currency_cd, 
                         a.currency_desc, 
                         a.currency_rt, 
                         b.item_no, 
                         b.item_title 
                    FROM giis_currency a, 
                         gicl_clm_item b 
                   WHERE a.main_currency_cd = b.currency_cd 
                     AND b.claim_id = p_claim_id 
                ORDER BY currency_desc)
        LOOP
            v_list.main_currency_cd     := i.main_currency_cd;
            v_list.currency_desc        := i.currency_desc;
            v_list.currency_rt          := i.currency_rt;
            v_list.item_no              := i.item_no;
            v_list.item_title           := i.item_title;
        PIPE ROW(v_list);  
        END LOOP;
      RETURN;    
    END;    
    
    FUNCTION get_gicl_clm_item(
        p_claim_id      gicl_claims.claim_id%TYPE
    )RETURN gicl_clm_item_tab PIPELINED IS
        v_list gicl_clm_item_type;
    BEGIN 
        FOR i IN (
            SELECT * 
              FROM gicl_clm_item
             WHERE claim_id = p_claim_id
        )LOOP
            v_list.claim_id     := i.claim_id;
            v_list.item_no      := i.item_no;
            v_list.currency_cd  := i.currency_cd;
            v_list.user_id      := i.user_id;
            v_list.last_update  := i.last_update;
            v_list.item_title   := i.item_title;
            v_list.loss_date    := i.loss_date;
            v_list.cpi_rec_no   := i.cpi_rec_no;
            v_list.cpi_branch_cd:= i.cpi_branch_cd;
            v_list.other_info   := i.other_info;
            v_list.currency_rate:= i.currency_rate;
            v_list.clm_currency_cd      := i.clm_currency_cd;
            v_list.clm_currency_rate    := i.clm_currency_rate;
            v_list.grouped_item_no      := i.grouped_item_no;
            v_list.item_desc    := i.item_desc;
            v_list.item_desc2   := i.item_desc2;
            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    FUNCTION get_gicl_clm_item_gicls260(
        p_claim_id      gicl_claims.claim_id%TYPE
    ) RETURN gicl_clm_item_gicls260_tab PIPELINED IS
        v_list gicl_clm_item_gicls260_type;
    BEGIN 
        FOR i IN (SELECT * 
                    FROM gicl_clm_item
                   WHERE claim_id = p_claim_id)
        LOOP
            v_list.item_no      := i.item_no;
            v_list.item_title   := i.item_title;
            v_list.other_info   := i.other_info;
            v_list.currency_cd  := i.currency_cd;
            v_list.currency_rate:= i.currency_rate;
            v_list.loss_date    := TO_CHAR(i.loss_date, 'MM-DD-YYYY HH:MI AM'); -- i.loss_date; shan 04.15.2014
       
            FOR j IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = i.currency_cd)
            LOOP
                v_list.dsp_currency_desc := j.currency_desc;
            END LOOP;
            
            SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist(i.item_no, i.claim_id)
              INTO v_list.gicl_item_peril_exist
              FROM dual;
      
            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

END gicl_clm_item_pkg;
/


