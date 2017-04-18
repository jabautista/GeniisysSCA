CREATE OR REPLACE PACKAGE CPI.GIISS031_PKG
AS
   TYPE rec_type IS RECORD (
      line_cd           giis_trty_panel.line_cd%TYPE,        
      trty_seq_no       giis_trty_panel.trty_seq_no%TYPE,    
      trty_yy           giis_trty_panel.trty_yy%TYPE,        
      ri_cd             giis_trty_panel.ri_cd%TYPE,          
      prnt_ri_cd        giis_trty_panel.prnt_ri_cd%TYPE,     
      trty_shr_pct      giis_trty_panel.trty_shr_pct%TYPE,   
      trty_shr_amt      giis_trty_panel.trty_shr_amt%TYPE,   
      ccall_limit       giis_trty_panel.ccall_limit%TYPE,    
      whtax_rt          giis_trty_panel.whtax_rt%TYPE,       
      broker_pct        giis_trty_panel.broker_pct%TYPE,     
      broker            giis_trty_panel.broker%TYPE,         
      prem_res          giis_trty_panel.prem_res%TYPE,       
      int_on_prem_res   giis_trty_panel.int_on_prem_res%TYPE,
      ri_comm_rt        giis_trty_panel.ri_comm_rt%TYPE,     
      prof_rt           giis_trty_panel.prof_rt%TYPE,        
      funds_held_pct    giis_trty_panel.funds_held_pct%TYPE,
      prnt_ri_name      giis_reinsurer.ri_name%TYPE,
      remarks           giis_trty_panel.remarks%TYPE,
      user_id           giis_trty_panel.user_id%TYPE,
      ri_sname          giis_reinsurer.ri_sname%TYPE, 
      ri_name           giis_reinsurer.ri_name%TYPE,
      ri_type           giis_reinsurer_type.ri_type%TYPE,     
      ri_base           VARCHAR2(20),    
      ri_type_desc      giis_reinsurer_type.ri_type_desc%TYPE,
      last_update       VARCHAR2(40),
      int_tax_rt        giis_trty_panel.int_tax_rt%TYPE --benjo 08.03.2016 SR-5512
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
        p_line_cd       VARCHAR2,
        p_trty_yy       VARCHAR2,
        p_share_cd      VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_trty_panel%ROWTYPE);

   PROCEDURE del_rec (p_rec giis_trty_panel%ROWTYPE);

   PROCEDURE val_add_rec(
      p_line_cd           giis_trty_panel.line_cd%TYPE,        
      p_trty_seq_no       giis_trty_panel.trty_seq_no%TYPE,    
      p_trty_yy           giis_trty_panel.trty_yy%TYPE,        
      p_ri_cd             giis_trty_panel.ri_cd%TYPE      
    );
   
   TYPE trty_rec_type IS RECORD (
      line_cd              GIIS_DIST_SHARE.line_cd%TYPE,          
      share_cd             GIIS_DIST_SHARE.share_cd%TYPE,         
      trty_yy              GIIS_DIST_SHARE.trty_yy%TYPE,          
      old_trty_seq_no      GIIS_DIST_SHARE.old_trty_seq_no%TYPE,  
      trty_limit           GIIS_DIST_SHARE.trty_limit%TYPE,       
      trty_name            GIIS_DIST_SHARE.trty_name%TYPE,        
      prtfolio_sw          GIIS_DIST_SHARE.prtfolio_sw%TYPE,      
      eff_date             GIIS_DIST_SHARE.eff_date%TYPE,         
      expiry_date          GIIS_DIST_SHARE.expiry_date%TYPE,      
      acct_trty_type       GIIS_DIST_SHARE.acct_trty_type%TYPE,   
      tot_shr_pct          GIIS_DIST_SHARE.tot_shr_pct%TYPE,      
      profcomp_type        GIIS_DIST_SHARE.profcomp_type%TYPE,    
      no_of_lines          GIIS_DIST_SHARE.no_of_lines%TYPE,      
      inxs_amt             GIIS_DIST_SHARE.inxs_amt%TYPE,         
      exc_loss_rt          GIIS_DIST_SHARE.exc_loss_rt%TYPE,      
      est_prem_inc         GIIS_DIST_SHARE.est_prem_inc%TYPE,     
      underlying           GIIS_DIST_SHARE.underlying%TYPE,       
      ccall_limit          GIIS_DIST_SHARE.ccall_limit%TYPE,      
      dep_prem             GIIS_DIST_SHARE.dep_prem%TYPE,         
      share_type           GIIS_DIST_SHARE.share_type%TYPE,       
      loss_prtfolio_pct    GIIS_DIST_SHARE.loss_prtfolio_pct%TYPE,
      prem_prtfolio_pct    GIIS_DIST_SHARE.prem_prtfolio_pct%TYPE,
      funds_held_pct       GIIS_DIST_SHARE.funds_held_pct%TYPE,   
      user_id              GIIS_DIST_SHARE.user_id%TYPE,          
      last_update          GIIS_DIST_SHARE.last_update%TYPE,
      remarks              GIIS_DIST_SHARE.remarks%TYPE,
      dsp_trty_no          VARCHAR2(20),
      dsp_acct_type        VARCHAR2(15),
      dsp_profcomp_type    VARCHAR2(25)
   );
   
   TYPE trty_rec_tab IS TABLE OF trty_rec_type;
   
   FUNCTION get_trty_rec_list (
        p_line_cd       VARCHAR2,
        p_share_cd      VARCHAR2
   )
   RETURN trty_rec_tab PIPELINED;
   
   PROCEDURE update_treaty (
       p_line_cd            VARCHAR2, 
       p_share_cd           VARCHAR2, 
       p_trty_limit         VARCHAR2,
       p_trty_name          VARCHAR2,
       p_eff_date           VARCHAR2,
       p_expiry_date        VARCHAR2,
       p_funds_held_pct     VARCHAR2,
       p_loss_prtfolio_pct  VARCHAR2,
       p_prem_prtfolio_pct  VARCHAR2,
       p_prtfolio_sw        VARCHAR2,
       p_acct_trty_type     VARCHAR2,
       p_profcomp_type      VARCHAR2,
       p_old_trty_seq_no    VARCHAR2,
       p_user               VARCHAR2
   );
   
   TYPE acct_trty_type IS RECORD (
      ca_trty_type      giis_ca_trty_type.ca_trty_type%TYPE,
      trty_sname        giis_ca_trty_type.trty_sname%TYPE,
      trty_lname        giis_ca_trty_type.trty_lname%TYPE
   ); 

   TYPE acct_trty_tab IS TABLE OF acct_trty_type;

   FUNCTION get_acct_trty_list(
      p_search VARCHAR2
   )
      RETURN acct_trty_tab PIPELINED;
      
   TYPE prof_comm_type IS RECORD (
      lcf_tag      giis_prof_com_type.lcf_tag%TYPE,
      lcf_desc     giis_prof_com_type.lcf_desc%TYPE
   ); 

   TYPE prof_comm_tab IS TABLE OF prof_comm_type;

   FUNCTION get_prof_comm_list(
        p_search    VARCHAR2
   )
      RETURN prof_comm_tab PIPELINED;
      
   PROCEDURE validate_acct_trty(
      p_trty_name     IN OUT VARCHAR2, 
      p_trty_type     IN OUT VARCHAR2
   );
   
   PROCEDURE validate_prof_comm(
      p_lcf_desc     IN OUT VARCHAR2, 
      p_lcf_tag      IN OUT VARCHAR2
   );
   
   TYPE reinsurer_type IS RECORD (
      ri_cd                 giis_reinsurer.ri_cd%TYPE,
      dsp_ri_sname          giis_reinsurer.ri_sname%TYPE,
      dsp_ri_name           giis_reinsurer.ri_name%TYPE,
      dsp_ri_type           giis_reinsurer.ri_type%TYPE,
      dsp_ri_type_desc      giis_reinsurer_type.ri_type_desc%TYPE,
      dsp_local_foreign_sw  VARCHAR2(20)
   ); 

   TYPE reinsurer_tab IS TABLE OF reinsurer_type;

   FUNCTION get_reinsurer_list(
      p_search  VARCHAR2
   )
      RETURN reinsurer_tab PIPELINED;
      
   TYPE parent_ri_type IS RECORD (
      ri_cd             giis_reinsurer.ri_cd%TYPE,
      ri_sname          giis_reinsurer.ri_sname%TYPE
   ); 

   TYPE parent_ri_tab IS TABLE OF parent_ri_type;

   FUNCTION get_parent_ri_list(
      p_search  VARCHAR2
   ) 
      RETURN parent_ri_tab PIPELINED;
      
   PROCEDURE validate_reinsurer(
      p_dsp_ri_sname             IN OUT VARCHAR2, 
      p_ri_cd                       OUT VARCHAR2,
      p_dsp_ri_name                 OUT VARCHAR2,
      p_dsp_ri_type                 OUT VARCHAR2,
      p_dsp_ri_type_desc            OUT VARCHAR2,    
      p_dsp_local_foreign_sw        OUT VARCHAR2
   );
   
   PROCEDURE validate_parent_ri(
      p_prnt_sname     IN OUT VARCHAR2, 
      p_prnt_ri           OUT VARCHAR2
   );
   
   TYPE non_prop_trty_type IS RECORD(
        xol_id          GIIS_XOL.xol_id%TYPE,     
        line_cd         GIIS_XOL.line_cd%TYPE,      
        xol_yy          GIIS_XOL.xol_yy%TYPE,       
        xol_seq_no      GIIS_XOL.xol_seq_no%TYPE,   
        xol_trty_name   GIIS_XOL.xol_trty_name%TYPE,
        user_id         GIIS_XOL.user_id%TYPE,   
        last_update     GIIS_XOL.last_update%TYPE
   );
   
   TYPE non_prop_trty_tab IS TABLE OF non_prop_trty_type;
   
   FUNCTION get_non_prop_trty_list(
        p_xol_id    VARCHAR2
   )
      RETURN non_prop_trty_tab PIPELINED;
   
   TYPE np_trty_rec_type IS RECORD(
       line_cd              GIIS_DIST_SHARE.line_cd%TYPE,             
       share_cd             GIIS_DIST_SHARE.share_cd%TYPE,            
       layer_no             GIIS_DIST_SHARE.layer_no%TYPE,            
       trty_name            GIIS_DIST_SHARE.trty_name%TYPE,           
       xol_allowed_amount   GIIS_DIST_SHARE.xol_allowed_amount%TYPE,
       xol_aggregate_sum    GIIS_DIST_SHARE.xol_aggregate_sum%TYPE,   
       reinstatement_limit  GIIS_DIST_SHARE.reinstatement_limit%TYPE, 
       eff_date             GIIS_DIST_SHARE.eff_date%TYPE,            
       expiry_date          GIIS_DIST_SHARE.expiry_date%TYPE,         
       xol_reserve_amount   GIIS_DIST_SHARE.xol_reserve_amount%TYPE,  
       xol_allocated_amount GIIS_DIST_SHARE.xol_allocated_amount%TYPE,
       xol_prem_mindep      GIIS_DIST_SHARE.xol_prem_mindep%TYPE,     
       xol_prem_rate        GIIS_DIST_SHARE.xol_prem_rate%TYPE,       
       acct_trty_type       GIIS_DIST_SHARE.acct_trty_type%TYPE,      
       prtfolio_sw          GIIS_DIST_SHARE.prtfolio_sw%TYPE,         
       xol_id               GIIS_DIST_SHARE.xol_id%TYPE,              
       xol_ded              GIIS_DIST_SHARE.xol_ded%TYPE,             
       trty_yy              GIIS_DIST_SHARE.trty_yy%TYPE,             
       trty_sw              GIIS_DIST_SHARE.trty_sw%TYPE,             
       share_type           GIIS_DIST_SHARE.share_type%TYPE,
       xol_base_amount      GIIS_DIST_SHARE.xol_base_amount%TYPE,
       remarks              GIIS_DIST_SHARE.remarks%TYPE             
   );
   
   TYPE np_trty_rec_tab IS TABLE OF np_trty_rec_type;
   
   FUNCTION get_np_trty_rec_list (
        p_line_cd       VARCHAR2,
        p_trty_yy       VARCHAR2,
        p_xol_id        VARCHAR2
   )
   RETURN np_trty_rec_tab PIPELINED;
   
   PROCEDURE set_np_rec (p_rec giis_dist_share%ROWTYPE);

   PROCEDURE del_np_rec (p_rec giis_dist_share%ROWTYPE);
   
   PROCEDURE validate_trty_name(
      p_trty_name     IN     VARCHAR2, 
      p_line_cd       IN     VARCHAR2,
      p_share_type    IN     VARCHAR2
   );
   
   PROCEDURE validate_old_trty_seq(
      p_line_cd           IN     VARCHAR2, 
      p_old_trty_seq      IN     VARCHAR2,
      p_share_cd          IN     VARCHAR2,
      p_share_type        IN     VARCHAR2,
      p_acct_trty_type    IN     VARCHAR
   );
   
   PROCEDURE recompute_trty_panel(
      p_line_cd         IN  VARCHAR2,
      p_trty_yy         IN  VARCHAR2,
      p_trty_seq_no     IN  VARCHAR2,
      p_new_trty_limit  IN  NUMBER
   );
   
   PROCEDURE val_add_np_rec (
      p_xol_id            giis_dist_share.xol_id%TYPE,
      p_layer_no          giis_dist_share.layer_no%TYPE      
   );
   
   PROCEDURE set_np_rec (p_rec giis_trty_panel%ROWTYPE);
   
   PROCEDURE val_del_rec_prop(
        p_line_cd       giis_trty_panel.line_cd%TYPE,    
        p_trty_seq_no   giis_trty_panel.trty_seq_no%TYPE,
        p_trty_yy       giis_trty_panel.trty_yy%TYPE,    
        p_ri_cd         giis_trty_panel.ri_cd%TYPE      
   );
   
   PROCEDURE val_del_rec_np_dist(
        p_line_cd       giis_dist_share.line_cd%TYPE,    
        p_share_cd      giis_dist_share.share_cd%TYPE
   );

END;
/


