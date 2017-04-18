CREATE OR REPLACE PACKAGE CPI.GIACS278_PKG AS
    
    TYPE acc_list_ri_loss_recov_type IS RECORD (
        claim_id     gicl_claims.claim_id%TYPE,
        fla_number     VARCHAR2(100),
        claim_number   VARCHAR2(100),
        payee_type   gicl_advs_fla_type.payee_type%TYPE,
        exp_shr_amt  gicl_advs_fla_type.exp_shr_amt%TYPE,
        print_sw     gicl_advs_fla.print_sw%TYPE,
        grp_seq_no   gicl_advs_fla.grp_seq_no%TYPE,
        fla_id       gicl_advs_fla.fla_id%TYPE,
        line_cd      gicl_advs_fla.line_cd%TYPE,
        ri_cd        gicl_advs_fla.ri_cd%TYPE,
        la_yy        gicl_advs_fla.la_yy%TYPE,
        fla_seq_no   gicl_advs_fla.fla_seq_no%TYPE,
        share_type   gicl_advs_fla.share_type%TYPE,
        adv_fla_id   gicl_advs_fla.adv_fla_id%TYPE,
        loss_shr_amt gicl_advs_fla_type.loss_shr_amt%TYPE,
        exp_shr_amt2 gicl_advs_fla_type.exp_shr_amt%TYPE,
        policy_number  VARCHAR2(100),           
	    assured_name gicl_claims.assured_name%TYPE 
        
                  
    );
    
    TYPE acc_list_ri_loss_recov_tab IS TABLE OF acc_list_ri_loss_recov_type;
        
    FUNCTION get_list_ri_loss_rec(
        P_LINE_CD       gicl_claims.line_cd%TYPE,
        P_RI_CD         gicl_claims.ri_cd%TYPE
    )RETURN acc_list_ri_loss_recov_tab PIPELINED;
    
    
    TYPE acc_list_ri_loss_overlay_type IS RECORD (
        tran_id             giac_acctrans.tran_id%TYPE,
        tran_date           giac_acctrans.tran_date%TYPE,
        tran_class          giac_acctrans.tran_class%TYPE,
        jv_pref_suff        giac_acctrans.jv_pref_suff%TYPE,
        jv_no               giac_acctrans.jv_no%TYPE,
        tran_year           giac_acctrans.tran_year%TYPE,
        tran_month          giac_acctrans.tran_month%TYPE,
        tran_seq_no         giac_acctrans.tran_seq_no%TYPE,
        collection_amt      giac_loss_ri_collns.collection_amt%TYPE,
        e150_line_cd        giac_loss_ri_collns.e150_line_cd%TYPE,
        e150_la_yy          giac_loss_ri_collns.e150_la_yy%TYPE,
        e150_fla_seq_no     giac_loss_ri_collns.e150_fla_seq_no%TYPE,
        tran_flag           giac_acctrans.tran_flag%TYPE,
        ref_no              VARCHAR2(100)
    );
    TYPE acc_list_ri_loss_overlay_tab IS TABLE OF acc_list_ri_loss_overlay_type;
    
    FUNCTION get_list_ri_loss_ol_rec(
        P_LINE_CD       giac_loss_ri_collns.e150_line_cd%TYPE,
        P_LA_YY         giac_loss_ri_collns.e150_la_yy%TYPE,
        P_FLA_SEQ_NO    giac_loss_ri_collns.e150_fla_seq_no%TYPE
    )RETURN acc_list_ri_loss_overlay_tab PIPELINED; 
    
    --added by john dolon 7.30.2013
    TYPE ri_list_type IS RECORD(
        ri_cd      giis_reinsurer.ri_cd%TYPE,
        ri_name    giis_reinsurer.ri_name%TYPE
    );
    
    TYPE ri_list_tab IS TABLE OF ri_list_type;
    
    FUNCTION get_ri_list(p_ri_cd VARCHAR2)
    RETURN ri_list_tab PIPELINED;
    
    TYPE line_list_type IS RECORD (
    line_cd         giis_line.line_cd%TYPE,
    line_name       giis_line.line_name%TYPE
    );
   
    TYPE line_list_tab IS TABLE OF line_list_type;
    
    FUNCTION get_line_list(p_line_cd VARCHAR2)
    RETURN line_list_tab PIPELINED;
END;
/


