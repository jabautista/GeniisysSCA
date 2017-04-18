CREATE OR REPLACE PACKAGE CPI.gicls058_pkg
AS
   TYPE rec_type IS RECORD (
      car_company_cd giis_mc_car_company.car_company_cd%TYPE,
      make_cd        giis_mc_make.make_cd%TYPE,
      loss_exp_cd    giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc  giis_loss_exp.loss_exp_desc%TYPE,
      part_cost_id   gicl_mc_part_cost.part_cost_id%TYPE,
      model_year     gicl_mc_part_cost.model_year%TYPE,
      eff_date_org   VARCHAR2(50),
      orig_amt       gicl_mc_part_cost.orig_amt%TYPE,
      eff_date_surp  VARCHAR2(50),
      surp_amt       gicl_mc_part_cost.surp_amt%TYPE,
      remarks        gicl_mc_part_cost.remarks%TYPE,
      user_id        gicl_mc_part_cost.user_id%TYPE,
      last_update    VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   TYPE car_company_type IS RECORD(
      car_company_cd giis_mc_car_company.car_company_cd%TYPE,
      car_company    giis_mc_car_company.car_company%TYPE
   );
   
   TYPE car_company_tab IS TABLE OF car_company_type;
   
   TYPE make_type IS RECORD(
      make_cd giis_mc_make.make_cd%TYPE,
      make    giis_mc_make.make%TYPE
   );
   
   TYPE make_tab IS TABLE OF make_type;

   TYPE model_year_type IS RECORD(
      model_year gicl_mc_part_cost.model_year%TYPE
   );
   
   TYPE model_year_tab IS TABLE OF model_year_type;  

   TYPE history_type IS RECORD(
      loss_exp_cd   giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc giis_loss_exp.loss_exp_desc%TYPE,
      hist_no       gicl_mc_part_cost_hist.hist_no%TYPE,
      orig_amt      gicl_mc_part_cost_hist.orig_amt%TYPE,
      surp_amt      gicl_mc_part_cost_hist.surp_amt%TYPE,
      entry_date    VARCHAR2(50),
      user_id       gicl_mc_part_cost_hist.user_id%TYPE
   );
   
   TYPE history_tab IS TABLE OF history_type;      

   FUNCTION get_rec_list (
      p_car_company_cd  gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd         gicl_mc_part_cost.make_cd%TYPE,
      p_model_year      gicl_mc_part_cost.model_year%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec gicl_mc_part_cost%ROWTYPE);

   PROCEDURE del_rec (p_part_cost_id gicl_mc_part_cost.part_cost_id%TYPE);
   
   PROCEDURE val_add_rec (
      p_car_company_cd gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd        gicl_mc_part_cost.make_cd%TYPE,
      p_model_year     gicl_mc_part_cost.model_year%TYPE
   );   
   
   FUNCTION get_company_rec_list
      RETURN car_company_tab PIPELINED;
               
   FUNCTION get_make_rec_list(
      p_car_company_cd  giis_mc_make.car_company_cd%TYPE
   )
      RETURN make_tab PIPELINED;
      
   FUNCTION check_model_year(
      p_car_company_cd  gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd         gicl_mc_part_cost.make_cd%TYPE   
   )  
      RETURN VARCHAR2;

   FUNCTION get_model_year_rec_list (
      p_car_company_cd  gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd         gicl_mc_part_cost.make_cd%TYPE
   )
      RETURN model_year_tab PIPELINED;     
       
   FUNCTION get_history_rec_list (
      p_part_cost_id  gicl_mc_part_cost.part_cost_id%TYPE
   )
      RETURN history_tab PIPELINED;
                  
END;
/


