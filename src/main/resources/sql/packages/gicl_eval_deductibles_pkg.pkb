CREATE OR REPLACE PACKAGE BODY CPI.GICL_EVAL_DEDUCTIBLES_PKG
AS
   PROCEDURE update_old_eval_deductibles (
      p_payee_type_cd       gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd            gicl_eval_vat.payee_cd%TYPE,
      p_var_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_var_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_eval_id             gicl_eval_vat.eval_id%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_eval_deductibles
         SET payee_type_cd = p_payee_type_cd,
             payee_cd = p_payee_cd
       WHERE eval_id = p_eval_id
         AND payee_type_cd = p_var_payee_type_cd
         AND payee_cd = p_var_payee_cd;
   END;

   PROCEDURE del_eval_deductibles (
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE
   )
   IS
   BEGIN
      DELETE      gicl_eval_deductibles
            WHERE payee_type_cd = p_payee_type_cd AND payee_cd = payee_cd;
   END;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.10.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Gets list of GICL_EVAL_DEDUCTIBLES 
    **                  records for the given eval_id 
    */ 
    FUNCTION get_gicl_eval_deductibles_list(p_eval_id   GICL_EVAL_DEDUCTIBLES.eval_id%TYPE)
    RETURN gicl_eval_deductibles_tab PIPELINED AS

    eval_ded gicl_eval_deductibles_type;

    BEGIN
        FOR i IN (SELECT a.eval_id,      a.ded_cd,       a.subline_cd, 
                         a.no_of_unit,   a.ded_base_amt, a.ded_amt, 
                         a.ded_rt,       a.ded_text,     a.payee_type_cd, 
                         a.payee_cd,     a.net_tag,      a.user_id,          
                         a.last_update 
                    FROM GICL_EVAL_DEDUCTIBLES a
                    WHERE eval_id = p_eval_id)
        LOOP
        
            eval_ded.eval_id        := i.eval_id;
            eval_ded.ded_cd         := i.ded_cd;
            eval_ded.subline_cd     := i.subline_cd;
            eval_ded.no_of_unit     := i.no_of_unit;
            eval_ded.ded_base_amt   := i.ded_base_amt;
            eval_ded.ded_amt        := i.ded_amt;
            eval_ded.ded_rt         := i.ded_rt;
            eval_ded.ded_text       := i.ded_text;
            eval_ded.payee_type_cd  := i.payee_type_cd;
            eval_ded.payee_cd       := i.payee_cd;
            eval_ded.net_tag        := i.net_tag;
            eval_ded.user_id        := i.user_id;
            eval_ded.last_update    := i.last_update;
            
            BEGIN
        
                SELECT loss_exp_desc
                  INTO eval_ded.dsp_exp_desc
                  FROM GIIS_LOSS_EXP
                 WHERE 1=1
                   AND line_cd = 'MC'
                   AND loss_Exp_type = 'L'
                   AND comp_sw = '-' 
                   AND loss_exp_cd = RTRIM(LTRIM(i.ded_cd));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
                WHEN TOO_MANY_ROWS THEN
                   NULL;
            END;
            
            BEGIN
                /*company*/
               IF i.payee_type_cd IS NOT NULL AND i.payee_cd IS NOT NULL THEN
                    BEGIN 
                        SELECT c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,','||c.payee_first_name)||
                               DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name||'.') payee_name
                          INTO eval_ded.dsp_company_desc
                          FROM GIIS_PAYEES c
                         WHERE c.payee_class_cd = i.payee_type_cd
                           AND c.payee_no       = i.payee_cd;
                         
                    EXCEPTION
                        WHEN no_data_found THEN
                         eval_ded.dsp_company_desc := NULL;
                        WHEN too_many_rows THEN
                         eval_ded.dsp_company_desc := NULL;
                    END;
               ELSE
                    eval_ded.dsp_company_desc := NULL;
               END IF;
            END;
            
            PIPE ROW(eval_ded);
        
        END LOOP get_gicl_eval_deductibles_list;
    END;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.13.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Insert / Update GICL_EVAL_DEDUCTIBLES records 
    **                   
    */ 

    PROCEDURE set_gicl_eval_deductibles
    (p_eval_id        IN  GICL_EVAL_DEDUCTIBLES.eval_id%TYPE,
     p_ded_cd         IN  GICL_EVAL_DEDUCTIBLES.ded_cd%TYPE,
     p_subline_cd     IN  GICL_EVAL_DEDUCTIBLES.subline_cd%TYPE,
     p_no_of_unit     IN  GICL_EVAL_DEDUCTIBLES.no_of_unit%TYPE,
     p_ded_base_amt   IN  GICL_EVAL_DEDUCTIBLES.ded_base_amt%TYPE,
     p_ded_amt        IN  GICL_EVAL_DEDUCTIBLES.ded_amt%TYPE,
     p_ded_rate       IN  GICL_EVAL_DEDUCTIBLES.ded_rt%TYPE,
     p_ded_text       IN  GICL_EVAL_DEDUCTIBLES.ded_text%TYPE,
     p_payee_type_cd  IN  GICL_EVAL_DEDUCTIBLES.payee_type_cd%TYPE,
     p_payee_cd       IN  GICL_EVAL_DEDUCTIBLES.payee_cd%TYPE,
     p_net_tag        IN  GICL_EVAL_DEDUCTIBLES.net_tag%TYPE,
     p_user_id        IN  GICL_EVAL_DEDUCTIBLES.user_id%TYPE) AS
     
    BEGIN
        MERGE INTO GICL_EVAL_DEDUCTIBLES
        USING dual ON (eval_id = p_eval_id
                   AND ded_cd = p_ded_cd
                   AND payee_type_cd = p_payee_type_cd
                   AND payee_cd = p_payee_cd)
                   
        WHEN NOT MATCHED THEN
            INSERT (eval_id,         ded_cd,     subline_cd,     no_of_unit,
                    ded_base_amt,    ded_amt,    ded_rt,         ded_text,
                    payee_type_cd,   payee_cd,   net_tag,        user_id, 
                    last_update)
            VALUES (p_eval_id,       p_ded_cd,   p_subline_cd,   p_no_of_unit,
                    p_ded_base_amt,  p_ded_amt,  p_ded_rate,     p_ded_text,
                    p_payee_type_cd, p_payee_cd, p_net_tag,      p_user_id, 
                    SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET
                   subline_cd    = p_subline_cd,
                   no_of_unit    = p_no_of_unit,
                   ded_base_amt  = p_ded_base_amt,
                   ded_amt       = p_ded_amt,
                   ded_rt        = p_ded_rate,
                   ded_text      = p_ded_text,
                   net_tag       = p_net_tag,
                   user_id       = p_user_id,
                   last_update   = SYSDATE;
               
    END set_gicl_eval_deductibles;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.13.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Insert GICL_EVAL_DEDUCTIBLES record 
    **                   
    */ 

    PROCEDURE insert_gicl_eval_deductibles
    (p_eval_id        IN  GICL_EVAL_DEDUCTIBLES.eval_id%TYPE,
     p_ded_cd         IN  GICL_EVAL_DEDUCTIBLES.ded_cd%TYPE,
     p_subline_cd     IN  GICL_EVAL_DEDUCTIBLES.subline_cd%TYPE,
     p_no_of_unit     IN  GICL_EVAL_DEDUCTIBLES.no_of_unit%TYPE,
     p_ded_base_amt   IN  GICL_EVAL_DEDUCTIBLES.ded_base_amt%TYPE,
     p_ded_amt        IN  GICL_EVAL_DEDUCTIBLES.ded_amt%TYPE,
     p_ded_rate       IN  GICL_EVAL_DEDUCTIBLES.ded_rt%TYPE,
     p_ded_text       IN  GICL_EVAL_DEDUCTIBLES.ded_text%TYPE,
     p_payee_type_cd  IN  GICL_EVAL_DEDUCTIBLES.payee_type_cd%TYPE,
     p_payee_cd       IN  GICL_EVAL_DEDUCTIBLES.payee_cd%TYPE,
     p_net_tag        IN  GICL_EVAL_DEDUCTIBLES.net_tag%TYPE,
     p_user_id        IN  GICL_EVAL_DEDUCTIBLES.user_id%TYPE) AS
         
    BEGIN
        
        INSERT INTO GICL_EVAL_DEDUCTIBLES
            (eval_id,        ded_cd,     subline_cd,     no_of_unit,
            ded_base_amt,    ded_amt,    ded_rt,         ded_text,
            payee_type_cd,   payee_cd,   net_tag,        user_id, 
            last_update)
        VALUES 
            (p_eval_id,      p_ded_cd,   p_subline_cd,   p_no_of_unit,
            p_ded_base_amt,  p_ded_amt,  p_ded_rate,     p_ded_text,
            p_payee_type_cd, p_payee_cd, p_net_tag,      p_user_id, 
            SYSDATE);
                   
    END insert_gicl_eval_deductibles;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.13.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Delete GICL_EVAL_DEDUCTIBLES records 
    **                   
    */ 

    PROCEDURE delete_gicl_eval_deductibles
    (p_eval_id       IN  GICL_EVAL_DEDUCTIBLES.eval_id%TYPE,
     p_ded_cd        IN  GICL_EVAL_DEDUCTIBLES.ded_cd%TYPE,
     p_subline_cd    IN  GICL_EVAL_DEDUCTIBLES.subline_cd%TYPE,
     p_no_of_unit    IN  GICL_EVAL_DEDUCTIBLES.no_of_unit%TYPE,
     p_ded_base_amt  IN  GICL_EVAL_DEDUCTIBLES.ded_base_amt%TYPE,
     p_ded_amt       IN  GICL_EVAL_DEDUCTIBLES.ded_amt%TYPE,
     p_ded_rate      IN  GICL_EVAL_DEDUCTIBLES.ded_rt%TYPE,
     p_payee_type_cd IN  GICL_EVAL_DEDUCTIBLES.payee_type_cd%TYPE,
     p_payee_cd      IN  GICL_EVAL_DEDUCTIBLES.payee_cd%TYPE) AS
     
    BEGIN

         DELETE FROM GICL_EVAL_DEDUCTIBLES
             WHERE eval_id = p_eval_id
               AND ded_cd  = p_ded_cd
               AND NVL(subline_cd, '*') = NVL(p_subline_cd,'*')
               AND NVL(no_of_unit, 0)   = NVL(p_no_of_unit, 0)
               AND NVL(ded_base_amt, 0) = NVL(p_ded_base_amt, 0)
               AND NVL(ded_amt,0) = NVL(p_ded_amt, 0)
               AND NVL(ded_rt, 0) = NVL(p_ded_rate, 0)
               AND payee_type_cd  = p_payee_type_cd
               AND payee_cd       = p_payee_cd;

    END delete_gicl_eval_deductibles;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.13.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Updates the deductible column of GICL_MC_EVALUATION table 
    **                  with the summation of ded_amt from GICL_EVAL_DEDUCTIBLES 
    */ 

    PROCEDURE update_deductible_of_mc_eval
    (p_eval_id    IN  GICL_EVAL_DEDUCTIBLES.eval_id%TYPE) AS

        summa GICL_MC_EVALUATION.deductible%TYPE;

    BEGIN

        SELECT NVL(SUM(ded_amt),0)
          INTO summa
          FROM GICL_EVAL_DEDUCTIBLES
         WHERE eval_id = p_eval_id;
    		  
         	  
         UPDATE GICL_MC_EVALUATION
            SET deductible = summa
          WHERE eval_id = p_eval_id;

    END update_deductible_of_mc_eval;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.13.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Apply deductibles for MC Evaluation Report 
    **                   
    */ 

    PROCEDURE apply_eval_deductibles
    (p_eval_id          IN   GICL_MC_EVALUATION.eval_id%TYPE,
     p_ded_no_of_acc    IN   GICL_EVAL_DEDUCTIBLES.no_of_unit%TYPE,
     p_payee_type_cd    IN   GICL_EVAL_DEDUCTIBLES.payee_type_cd%TYPE,
     p_payee_cd         IN   GICL_EVAL_DEDUCTIBLES.payee_cd%TYPE,
     p_base_amt         IN   GICL_EVAL_DEDUCTIBLES.ded_base_amt%TYPE,
     p_pol_line_cd      IN   GICL_CLAIMS.line_cd%TYPE,
     p_pol_subline_cd   IN   GICL_CLAIMS.subline_cd%TYPE,
     p_pol_iss_cd       IN   GICL_CLAIMS.pol_iss_cd%TYPE,
     p_pol_issue_yy     IN   GICL_CLAIMS.issue_yy%TYPE,
     p_pol_seq_no       IN   GICL_CLAIMS.pol_seq_no%TYPE,
     p_pol_renew_no     IN   GICL_CLAIMS.renew_no%TYPE,
     p_loss_date        IN   GICL_CLAIMS.loss_date%TYPE,
     p_item_no          IN   GICL_MC_EVALUATION.item_no%TYPE,
     p_peril_cd         IN   GICL_MC_EVALUATION.peril_cd%TYPE) AS
     
    BEGIN
        FOR i IN(SELECT a.loss_exp_cd, a.loss_exp_desc, 0 amount, a.subline_cd, 
                       NVL(a.deductible_rate, 0) deductible_rate, 
                       NVL(a.comp_sw, '+') comp_sw 
                 FROM GIIS_LOSS_EXP a 
                WHERE a.loss_exp_type = 'L'
                  AND a.line_cd       = 'MC' 
                  AND a.comp_sw       = '-' 
                  AND a.subline_cd IS NULL
                UNION
                /*policy deductibles amt*/
                SELECT a.loss_exp_cd, a.loss_exp_desc, - SUM(b.deductible_amt) amount, 
                       a.subline_cd, 0 deductible_rate, NVL(a.comp_sw, '-') comp_sw 
                  FROM GIIS_LOSS_EXP a, GIPI_DEDUCTIBLES b, GIPI_POLBASIC c 
                 WHERE a.line_cd        = c.line_cd 
                   AND a.line_cd        = b.ded_line_cd 
                   AND a.subline_cd     = b.ded_subline_cd 
                   AND a.loss_exp_cd    = b.ded_deductible_cd 
                   AND a.loss_exp_type  = 'L' 
                   AND a.line_cd        = 'MC' 
                   AND a.subline_cd     = p_pol_subline_cd 
                   AND b.policy_id      = c.policy_id 
                   AND c.line_cd        = 'MC' 
                   AND c.subline_cd     = p_pol_subline_cd 
                   AND c.iss_cd         = p_pol_iss_cd 
                   AND c.issue_yy       = p_pol_issue_yy 
                   AND c.pol_seq_no     = p_pol_seq_no 
                   AND c.renew_no       = p_pol_renew_no 
                   AND c.expiry_date   >= p_loss_date 
                   AND c.pol_flag IN ('1','2','3','X') 
                   AND b.item_no        = p_item_no 
                   AND b.peril_cd IN (p_peril_cd, 0) 
                   AND NVL(b.deductible_amt,0) <> 0  
                GROUP BY a.subline_cd , a.loss_exp_cd, a.loss_exp_desc, nvl(a.comp_sw, '-')
                UNION
                /*policy deductibles rate*/
                SELECT a.loss_exp_cd, a.loss_exp_desc,  - (c.ann_tsi_amt * (NVL(b.deductible_rt, 0)/100)) amount, 
                       a.subline_cd, NVL(b.deductible_rt, 0) deductible_rate, NVL(a.comp_sw, '-') comp_sw 
                  FROM GIIS_LOSS_EXP a, GIPI_DEDUCTIBLES b, GIPI_POLBASIC c 
                 WHERE a.line_cd       = c.line_cd 
                   AND a.line_cd       = b.ded_line_cd 
                   AND a.subline_cd    = b.ded_subline_cd 
                   AND a.loss_exp_cd   = b.ded_deductible_cd 
                   AND a.loss_exp_type = 'L' 
                   AND a.line_cd       = 'MC'
                   AND a.subline_cd    =  p_pol_subline_cd 
                   AND b.policy_id     =  c.policy_id 
                   AND c.line_cd       = 'MC' 
                   AND c.subline_cd    =  p_pol_subline_cd 
                   AND c.iss_cd        =  p_pol_iss_cd 
                   AND c.issue_yy      =  p_pol_issue_yy 
                   AND c.pol_seq_no    =  p_pol_seq_no 
                   AND c.renew_no      =  p_pol_renew_no 
                   AND c.expiry_date  >=  p_loss_date 
                   AND c.pol_flag IN ('1','2','3','X') 
                   AND b.item_no       =  p_item_no 
                   AND b.peril_cd IN ( p_peril_cd, 0) 
                   AND NVL(b.deductible_rt,0) > 0)
         LOOP
            INSERT INTO GICL_EVAL_DEDUCTIBLES
                (eval_id,   ded_cd,         subline_cd,     no_of_unit,     ded_amt, 
                 ded_rt,    payee_type_cd,  payee_cd,       ded_base_amt)
            VALUES
                (p_eval_id,         i.loss_exp_cd,    p_pol_subline_cd, p_ded_no_of_acc, TO_NUMBER(i.amount)*TO_NUMBER(p_ded_no_of_acc), 
                 i.deductible_rate, p_payee_type_cd,  p_payee_cd,       p_base_amt);
         END LOOP;
    END;

END;
/


