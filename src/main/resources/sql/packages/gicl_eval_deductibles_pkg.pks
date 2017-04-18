CREATE OR REPLACE PACKAGE CPI.gicl_eval_deductibles_pkg
AS

   TYPE gicl_eval_deductibles_type IS RECORD (
        eval_id             GICL_EVAL_DEDUCTIBLES.eval_id%TYPE,        
        ded_cd              GICL_EVAL_DEDUCTIBLES.ded_cd%TYPE,
        dsp_exp_desc        GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        subline_cd          GICL_EVAL_DEDUCTIBLES.subline_cd%TYPE,
        no_of_unit          GICL_EVAL_DEDUCTIBLES.no_of_unit%TYPE,
        ded_base_amt        GICL_EVAL_DEDUCTIBLES.ded_base_amt%TYPE,
        ded_amt             GICL_EVAL_DEDUCTIBLES.ded_amt%TYPE,
        ded_rt              GICL_EVAL_DEDUCTIBLES.ded_rt%TYPE,
        ded_text            GICL_EVAL_DEDUCTIBLES.ded_text%TYPE,
        payee_type_cd       GICL_EVAL_DEDUCTIBLES.payee_type_cd%TYPE,
        payee_cd            GICL_EVAL_DEDUCTIBLES.payee_cd%TYPE,
        dsp_company_desc    VARCHAR2(500),
        net_tag             GICL_EVAL_DEDUCTIBLES.net_tag%TYPE,
        user_id             GICL_EVAL_DEDUCTIBLES.user_id%TYPE,
        last_update         GICL_EVAL_DEDUCTIBLES.last_update%TYPE
    );

    TYPE gicl_eval_deductibles_tab IS TABLE OF gicl_eval_deductibles_type;
    
   PROCEDURE update_old_eval_deductibles (
      p_payee_type_cd       gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd            gicl_eval_vat.payee_cd%TYPE,
      p_var_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_var_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_eval_id             gicl_eval_vat.eval_id%TYPE
   );
   
   PROCEDURE del_eval_deductibles( p_payee_type_cd       gicl_eval_vat.payee_type_cd%TYPE,
                                   p_payee_cd            gicl_eval_vat.payee_cd%TYPE);
                                   
   FUNCTION get_gicl_eval_deductibles_list(p_eval_id   GICL_EVAL_DEDUCTIBLES.eval_id%TYPE)
    RETURN gicl_eval_deductibles_tab PIPELINED;
    
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
     p_user_id        IN  GICL_EVAL_DEDUCTIBLES.user_id%TYPE);
     
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
     p_user_id        IN  GICL_EVAL_DEDUCTIBLES.user_id%TYPE);
     
   PROCEDURE delete_gicl_eval_deductibles
    (p_eval_id       IN  GICL_EVAL_DEDUCTIBLES.eval_id%TYPE,
     p_ded_cd        IN  GICL_EVAL_DEDUCTIBLES.ded_cd%TYPE,
     p_subline_cd    IN  GICL_EVAL_DEDUCTIBLES.subline_cd%TYPE,
     p_no_of_unit    IN  GICL_EVAL_DEDUCTIBLES.no_of_unit%TYPE,
     p_ded_base_amt  IN  GICL_EVAL_DEDUCTIBLES.ded_base_amt%TYPE,
     p_ded_amt       IN  GICL_EVAL_DEDUCTIBLES.ded_amt%TYPE,
     p_ded_rate      IN  GICL_EVAL_DEDUCTIBLES.ded_rt%TYPE,
     p_payee_type_cd IN  GICL_EVAL_DEDUCTIBLES.payee_type_cd%TYPE,
     p_payee_cd      IN  GICL_EVAL_DEDUCTIBLES.payee_cd%TYPE);
     
   PROCEDURE update_deductible_of_mc_eval
    (p_eval_id    IN  GICL_EVAL_DEDUCTIBLES.eval_id%TYPE);
    
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
     p_peril_cd         IN   GICL_MC_EVALUATION.peril_cd%TYPE);
         
END;
/


