CREATE OR REPLACE PACKAGE CPI.populate_giclr070_pkg
AS
    TYPE populate_giclr070_type IS RECORD (
        eval_no             VARCHAR2(100),
        policy_no           VARCHAR2(136),
        loss_date           gicl_claims.loss_date%TYPE,
        assd_no             gicl_claims.assd_no%TYPE,
        claim_id            gicl_claims.claim_id%TYPE,
        item_No             gicl_mc_evaluation.item_no%TYPE,
        eval_id             gicl_mc_evaluation.eval_id%TYPE,
        subline_cd          gicl_mc_evaluation.subline_cd%TYPE,
        iss_cd              gicl_mc_evaluation.iss_cd%TYPE,
        plate_no            gicl_mc_evaluation.plate_no%TYPE,
        tp_sw               gicl_mc_evaluation.tp_sw%TYPE,
        cso_id              gicl_mc_evaluation.cso_id%TYPE,
        eval_date           gicl_mc_evaluation.eval_date%TYPE,
        inspect_date        gicl_mc_evaluation.inspect_date%TYPE,
        inspect_place       gicl_mc_evaluation.inspect_place%TYPE,
        vat                 gicl_eval_vat.vat_amt%TYPE,
        deductible          gicl_mc_evaluation.deductible%TYPE,
        depreciation        gicl_mc_evaluation.depreciation%TYPE,
        remarks             gicl_mc_evaluation.remarks%TYPE,
        assd_name           giis_assured.assd_name%TYPE,
        eval_name           giis_users.user_name%TYPE,
        tp_name             VARCHAR2(265),
        vehicle             VARCHAR2(300),
        sum_nof             NUMBER,
        sum_ded_amt         NUMBER,
        sum_discount_amt    NUMBER,
        ded_rt              gicl_eval_dep_dtl.ded_rt%TYPE,
        sum_dep_ded_amt     NUMBER
    );
    TYPE populate_giclr070_tab IS TABLE OF populate_giclr070_type;
    
    FUNCTION populate_giclr070 (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE
    ) RETURN populate_giclr070_tab PIPELINED;
    
    TYPE populate_scope_type IS RECORD (
        scope               VARCHAR2(30),
        replace             VARCHAR2(20),
        repair              VARCHAR2(20),
        rec1                NUMBER,
        item_no             NUMBER,
        flag                NUMBER
    );
    TYPE populate_scope_tab IS TABLE OF populate_scope_type;
    
    FUNCTION populate_scope (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
        p_update_sw     VARCHAR2
    ) RETURN populate_scope_tab PIPELINED;
    
    TYPE populate_vat_type IS RECORD (
        replace_vat         NUMBER,
        repair_vat          NUMBER
    );
    TYPE populate_vat_tab IS TABLE OF populate_vat_type;
    
    FUNCTION populate_vat (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
        p_update_sw     VARCHAR2
      ) RETURN populate_vat_tab PIPELINED;
      
    TYPE populate_repair_type IS RECORD (
        repair_cd           VARCHAR2(8),
        loss_exp_desc       giis_loss_exp.loss_exp_desc%TYPE,
        item_no             gicl_repair_lps_dtl.item_no%TYPE
    );
    TYPE populate_repair_tab IS TABLE OF populate_repair_type;
    
    FUNCTION populate_repair (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
        p_update_sw     VARCHAR2
      ) RETURN populate_repair_tab PIPELINED;
    
END populate_giclr070_pkg;
/


