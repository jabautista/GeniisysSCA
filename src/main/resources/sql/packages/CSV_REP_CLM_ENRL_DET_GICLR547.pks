CREATE OR REPLACE PACKAGE CPI.CSV_REP_CLM_ENRL_DET_GICLR547 AS

/*
   **  Created by   :  Bernadette B. Quitain
   **  Date Created : 03.31.2016
   **  Modified by:   Herbert DR. Tagudin
   **  Date Modified : 04.05.2016  (SR 5403)
   **  Reference By : GICLR547_PKG
   **  Remarks      : Reported Claims Per Enrollee - Detailed
   */   
     TYPE giclr547_rec_type IS RECORD (
        enrollee                gicl_accident_dtl.grouped_item_title%TYPE,
        claim_number            VARCHAR2(50),        
        policy_number           VARCHAR2(50),     
        intermediary_cedant     VARCHAR2(1000), 
        eff_date                VARCHAR2(24),
        loss_date               VARCHAR2(24),
        file_date               VARCHAR2(24),
        status                  giis_clm_stat.clm_stat_desc%TYPE, 
        peril                   giis_peril.peril_name%TYPE,    
        claim_amount_type       VARCHAR2(50),
        claim_amount            VARCHAR2(50),
        retention               VARCHAR2(50),
        proportional_treaty     VARCHAR2(50),
        nonproportional_treaty  VARCHAR2(50), 
        facultative             VARCHAR2(50)
    );
    
    TYPE giclr547_tab IS TABLE OF giclr547_rec_type;
    
    TYPE giclr547_loss_rec_type IS RECORD (
        enrollee                gicl_accident_dtl.grouped_item_title%TYPE,
        claim_number            VARCHAR2(50),        
        policy_number           VARCHAR2(50),     
        intermediary_cedant     VARCHAR2(1000), 
        eff_date                VARCHAR2(24),
        loss_date               VARCHAR2(24),
        file_date               VARCHAR2(24),
        status                  giis_clm_stat.clm_stat_desc%TYPE, 
        peril                   giis_peril.peril_name%TYPE,    
        loss_amount             VARCHAR2(50),
        retention               VARCHAR2(50),
        proportional_treaty     VARCHAR2(50),
        nonproportional_treaty  VARCHAR2(50), 
        facultative             VARCHAR2(50)  
    );
    
    TYPE giclr547_loss_tab IS TABLE OF giclr547_loss_rec_type;
    
    
    TYPE giclr547_exp_rec_type IS RECORD (
        enrollee                gicl_accident_dtl.grouped_item_title%TYPE,
        claim_number            VARCHAR2(50),        
        policy_number           VARCHAR2(50),     
        intermediary_cedant     VARCHAR2(1000), 
        eff_date                VARCHAR2(24),
        loss_date               VARCHAR2(24),
        file_date               VARCHAR2(24),
        status                  giis_clm_stat.clm_stat_desc%TYPE, 
        peril                   giis_peril.peril_name%TYPE,    
        expense_amount          VARCHAR2(50),   
        retention               VARCHAR2(50),
        proportional_treaty     VARCHAR2(50),
        nonproportional_treaty  VARCHAR2(50), 
        facultative             VARCHAR2(50)
    );
    
    TYPE giclr547_exp_tab IS TABLE OF giclr547_exp_rec_type;
    
    
    FUNCTION csv_giclr547_both (
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_user_id            VARCHAR2      
    )
    RETURN giclr547_tab PIPELINED;
    
    FUNCTION csv_giclr547_expenses (
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_user_id            VARCHAR2      
    )
    RETURN giclr547_exp_tab PIPELINED;
    
    FUNCTION csv_giclr547_loss (
        p_start_dt           VARCHAR2,
        p_end_dt             VARCHAR2,
        p_grouped_item_title VARCHAR2,
        p_control_cd         VARCHAR2,
        p_control_type_cd    gicl_accident_dtl.control_type_cd%TYPE,
        p_user_id            VARCHAR2      
    )
    RETURN giclr547_loss_tab PIPELINED;                       
END;
/
