CREATE OR REPLACE PACKAGE CPI.GICL_REC_ACCT_ENTRIES_PKG AS

    TYPE rec_acct_entries_type IS RECORD (
        recovery_acct_id        GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE, 
        acct_entry_id           GICL_REC_ACCT_ENTRIES.acct_entry_id%TYPE,
        gl_acct_id              GICL_REC_ACCT_ENTRIES.gl_acct_id%TYPE,
        gl_acct_category        GICL_REC_ACCT_ENTRIES.gl_acct_category%TYPE,
        gl_control_acct         GICL_REC_ACCT_ENTRIES.gl_control_acct%TYPE,
        gl_sub_acct_1           GICL_REC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        gl_sub_acct_2           GICL_REC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        gl_sub_acct_3           GICL_REC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        gl_sub_acct_4           GICL_REC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        gl_sub_acct_5           GICL_REC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        gl_sub_acct_6           GICL_REC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        gl_sub_acct_7           GICL_REC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        sl_cd                   GICL_REC_ACCT_ENTRIES.sl_cd%TYPE,
        debit_amt               GICL_REC_ACCT_ENTRIES.debit_amt%TYPE,
        credit_amt              GICL_REC_ACCT_ENTRIES.credit_amt%TYPE,
        generation_type         GICL_REC_ACCT_ENTRIES.generation_type%TYPE,
        sl_type_cd              GICL_REC_ACCT_ENTRIES.sl_type_cd%TYPE,
        sl_source_cd            GICL_REC_ACCT_ENTRIES.sl_source_cd%TYPE,
        remarks                 GICL_REC_ACCT_ENTRIES.remarks%TYPE,

        dsp_gl_acct_cd          VARCHAR2(50),
        dsp_gl_acct_name        GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
        dsp_payor_name          VARCHAR2(300),
        dsp_sl_name             VARCHAR2(300)
    );
    
    TYPE rec_acct_entries_tab IS TABLE OF rec_acct_entries_type;
    
    FUNCTION get_rec_acct_entries_list (
        p_recovery_acct_id      GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE,
        p_payor_cd              GICL_RECOVERY_PAYT.payor_cd%TYPE,
        p_payor_class_cd        GICL_RECOVERY_PAYT.payor_class_cd%TYPE
    ) RETURN rec_acct_entries_tab PIPELINED;
    
    PROCEDURE set_rec_acct_entries (
        p_recovery_acct_id        GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE, 
        p_acct_entry_id           GICL_REC_ACCT_ENTRIES.acct_entry_id%TYPE,
        p_gl_acct_id              GICL_REC_ACCT_ENTRIES.gl_acct_id%TYPE,
        p_gl_acct_category        GICL_REC_ACCT_ENTRIES.gl_acct_category%TYPE,
        p_gl_control_acct         GICL_REC_ACCT_ENTRIES.gl_control_acct%TYPE,
        p_gl_sub_acct_1           GICL_REC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        p_gl_sub_acct_2           GICL_REC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3           GICL_REC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4           GICL_REC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5           GICL_REC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6           GICL_REC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7           GICL_REC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        p_sl_cd                   GICL_REC_ACCT_ENTRIES.sl_cd%TYPE,
        p_debit_amt               GICL_REC_ACCT_ENTRIES.debit_amt%TYPE,
        p_credit_amt              GICL_REC_ACCT_ENTRIES.credit_amt%TYPE,
        p_generation_type         GICL_REC_ACCT_ENTRIES.generation_type%TYPE,
        p_sl_type_cd              GICL_REC_ACCT_ENTRIES.sl_type_cd%TYPE,
        p_sl_source_cd            GICL_REC_ACCT_ENTRIES.sl_source_cd%TYPE,
        p_user_id                 GICL_REC_ACCT_ENTRIES.user_id%TYPE
    );
    
    PROCEDURE del_rec_acct_entries (
        p_recovery_acct_id        GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE, 
        p_acct_entry_id           GICL_REC_ACCT_ENTRIES.acct_entry_id%TYPE
    );
    
    PROCEDURE AEG_InsUpd_AE_GICLS055
        (iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
         iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
         iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
         iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
         iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
         iuae_sl_type_cd	    GIAC_SL_TYPES.sl_type_cd%TYPE,
         p_recovery_acct_id     GICL_RECOVERY_ACCT.recovery_acct_id%TYPE);
         
    PROCEDURE MISC_UW_ENTRIES(
        misc_amt	IN	GIAC_ACCT_ENTRIES.debit_amt%TYPE,
        p_module_id IN	GIAC_MODULES.module_id%TYPE,
        p_gen_type	IN	GIAC_MODULES.generation_type%TYPE,
        p_item_no 	OUT	NUMBER,
        p_mesg		OUT	VARCHAR2);   
        
    PROCEDURE Create_Acct_Entries_GICLS055
      (aeg_sl_cd              IN  GIAC_ACCT_ENTRIES.sl_cd%TYPE,
       aeg_module_id          IN  GIAC_MODULE_ENTRIES.module_id%TYPE,
       aeg_item_no            IN  GIAC_MODULE_ENTRIES.item_no%TYPE,
       aeg_line_cd            IN  GICL_CLM_RECOVERY.line_cd%TYPE,
       aeg_branch_cd          IN  GICL_CLM_RECOVERY.iss_cd%TYPE,
       aeg_trty_type          IN  GIIS_DIST_SHARE.acct_trty_type%TYPE,
       aeg_acct_amt           IN  GICL_RECOVERY_PAYT.recovered_amt%TYPE,
       aeg_gen_type           IN  GIAC_ACCT_ENTRIES.generation_type%TYPE,
       p_recovery_acct_id     IN  GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
       p_ri_sl_type			  IN  GIAC_SL_TYPES.sl_type_cd%type, 
       p_mesg			      OUT VARCHAR2);    
       
    PROCEDURE AEG_Parameters_GICLS055 (
        p_recovery_acct_id IN  GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        p_mesg             OUT VARCHAR2
    );  
	
	PROCEDURE get_ae_amounts_sum (
        p_recovery_acct_id      IN GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE,
        p_debit_amt             OUT NUMBER,
        p_credit_amt            OUT NUMBER
    );
END GICL_REC_ACCT_ENTRIES_PKG;
/


