CREATE OR REPLACE PACKAGE CPI.GIUTS008_PKG
AS


TYPE validate_endt_type IS RECORD(
        spld        varchar2(100),
        spld1        varchar2(100),
        spld2       varchar2(100),
        message     varchar2(2000),
        message2    varchar2(2000),
        exist       varchar2(100),    
        user_id     varchar2(100)   
  );
  
  TYPE validate_endt_tab IS TABLE OF   validate_endt_type;
  
PROCEDURE check_endt
(p_line_cd          IN   GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN   GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN   GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN   GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN   GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN   GIPI_POLBASIC.renew_no%TYPE,
 p_nbt_endt_iss_cd  IN   GIPI_POLBASIC.endt_iss_cd%TYPE,
 p_nbt_endt_yy      IN   GIPI_POLBASIC.endt_yy%TYPE,
 p_nbt_endt_seq_no  IN   GIPI_POLBASIC.endt_seq_no%TYPE);
        
TYPE check_policy_type IS RECORD(
        spld        varchar2(100),
        spld1        varchar2(100),
        spld2       varchar2(100),
        message     varchar2(2000),
        message2    varchar2(2000),
        exist       varchar2(100),    
        user_id     varchar2(100)   
  );
  
  TYPE check_policy_tab IS TABLE OF   check_policy_type;
  
PROCEDURE check_policy
(p_line_cd          IN   GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN   GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN   GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN   GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN   GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN   GIPI_POLBASIC.renew_no%TYPE);
                       
PROCEDURE copy_accident_item(p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                              
 PROCEDURE copy_accident_item_pack (p_policy_id IN gipi_polbasic.policy_id%TYPE,
       p_item_no   IN gipi_item.item_no%type,
       p_par_id    IN number);
       
 PROCEDURE copy_item 
 (p_policy_id IN gipi_polbasic.policy_id%type,
 p_line_cd          IN   GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN   GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN   GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN   GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN   GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN   GIPI_POLBASIC.renew_no%TYPE,
 p_par_type         IN   GIPI_PARLIST.par_type%TYPE,
 p_par_id           IN   GIPI_PARLIST.par_id%TYPE);
                     
PROCEDURE copy_polbas_discount (p_policy_id IN  GIPI_PERIL_DISCOUNT.policy_id%TYPE,
                                p_par_id    IN  GIPI_PARLIST.par_id%TYPE);
                                
PROCEDURE copy_itemds (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                       p_dist_no    IN number);
                       
PROCEDURE copy_itemds_dtl (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                           p_dist_no    IN number);
                           
PROCEDURE copy_itemperilds (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                            p_dist_no   IN number);

FUNCTION get_dist_no
    RETURN number;                                                                                                              

PROCEDURE copy_itemperilds_dtl (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                                p_dist_no   IN number);

PROCEDURE copy_item_discount  (p_policy_id   IN  GIPI_PERIL_DISCOUNT.policy_id%TYPE,
                               p_par_id      IN  GIPI_PARLIST.par_id%TYPE);

FUNCTION get_par_id
    RETURN number;
    
PROCEDURE copy_item_pack (p_policy_id       IN gipi_polbasic.policy_id%type,
                          p_item_no         IN gipi_item.item_no%TYPE,
                          p_line_cd         IN varchar2,
                          p_subline_cd      IN varchar2,
                          p_iss_cd          IN varchar2,
                          p_issue_yy        IN number,
                          p_pol_seq_no      IN number,
                          p_renew_no        IN number,
                          p_par_id          IN number);    
       
FUNCTION get_par_type(p_policy_id           number)
 RETURN varchar2;
 
 PROCEDURE copy_item_ves (p1_policy_id IN gipi_item_ves.policy_id%TYPE,
                          p_par_id   IN number);
 
 PROCEDURE copy_item_ves_pack (p1_policy_id IN gipi_item_ves.policy_id%TYPE,
                              p_item_no    IN gipi_item.item_no%type,
                              p_par_id      IN number);
                              
PROCEDURE copy_itmperil (p_policy_id     IN   GIPI_POLBASIC.policy_id%type,
                         p_line_cd       IN   GIPI_POLBASIC.line_cd%TYPE,
                         p_par_id        IN   GIPI_PARLIST.par_id%TYPE);
                         
PROCEDURE copy_itmperil_beneficiary (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_grouped_item_no   IN   gipi_grp_items_beneficiary.grouped_item_no%TYPE,
   p_par_id            IN   number
);


PROCEDURE copy_itmperil_grouped (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_grouped_item_no   IN   gipi_itmperil_grouped.grouped_item_no%TYPE,
   p_par_id            IN   number
);
                  
PROCEDURE copy_itmperil_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_lim_liab (p_policy_id IN GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id    IN GIPI_PARLIST.par_id%TYPE);

PROCEDURE copy_lim_liab_pack (
   p_policy_id      IN   gipi_polbasic.policy_id%TYPE,
   p_pack_line_cd   IN   gipi_item.pack_line_cd%TYPE,
   p_par_id         IN number
);                                     


PROCEDURE copy_aviation_cargo_hull 
   (p_policy_id  IN  GIPI_POLBASIC.policy_id%TYPE,
    p_line_cd    IN  GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd IN  GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     IN  GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy   IN  GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no IN  GIPI_POLBASIC.pol_seq_no%TYPE,
    p_par_id     IN  GIPI_PARLIST.par_id%TYPE,
    p_par_type   IN  GIPI_PARLIST.par_type%TYPE,
    p_renew_no   IN  GIPI_POLBASIC.renew_no%TYPE,
    p_user       IN  GIPI_POLBASIC.user_id%TYPE
    );
                                    
PROCEDURE copy_aviation_cargo_hull_pack (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_pack_line_cd      IN   gipi_pack_line_subline.pack_line_cd%TYPE,
   p_pack_subline_cd   IN   gipi_pack_line_subline.pack_subline_cd%TYPE,
   p_iss_cd            IN   gipi_polbasic.iss_cd%TYPE,
   p_issue_yy          IN   gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no        IN   gipi_polbasic.pol_seq_no%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_par_id            IN   number,
   p_line_cd           IN  varchar2,
   p_subline_cd        IN  varchar2,
   p_renew_no          IN  number
);

PROCEDURE copy_aviation_item (
   p1_policy_id   IN   gipi_aviation_item.policy_id%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_aviation_item_pack (
   p1_policy_id   IN   gipi_aviation_item.policy_id%TYPE,
   p_item_no      IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_beneficiary (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                            p_par_id      IN  GIPI_PARLIST.par_id%TYPE);

PROCEDURE copy_beneficiary_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_bond_basic (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                           p_par_id      IN  GIPI_PARLIST.par_id%TYPE);

PROCEDURE copy_cargo (p_policy_id IN gipi_cargo.policy_id%TYPE,
                p_par_id        IN number,
                p_user          IN varchar2);

PROCEDURE copy_cargo_carrier (
   p_policy_id   IN   gipi_cargo_carrier.policy_id%TYPE,
   p_user_id     IN   giis_users.user_id%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_cargo_pack (
   p_policy_id   IN   gipi_cargo.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_casualty_item (
   p_policy_id   IN   GIPI_CASUALTY_ITEM.policy_id%TYPE,
   p_par_id      IN   GIPI_PARLIST.par_id%TYPE
);

PROCEDURE copy_casualty_item_pack (
   p_policy_id   IN   gipi_casualty_item.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_casualty_personnel (
   p_policy_id   IN   GIPI_CASUALTY_ITEM.policy_id%TYPE,
   p_par_id      IN   GIPI_PARLIST.par_id%TYPE
);

PROCEDURE copy_casualty_personnel_pack (
   p_policy_id   IN   gipi_casualty_item.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_comm_invoice (
   p1_policy_id    IN   gipi_comm_invoice.policy_id%TYPE,
   p_iss_cd        IN   gipi_comm_invoice.iss_cd%TYPE,
   p_prem_seq_no   IN   gipi_comm_invoice.prem_seq_no%TYPE,
   p_item_grp      IN   gipi_invoice.item_grp%TYPE,
   p_par_id         IN number
);

PROCEDURE copy_cosigntry (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE);

PROCEDURE copy_co_ins (p_policy_id   IN  GIUW_POL_DIST.policy_id%TYPE,
                       p_par_id      IN  GIPI_PARLIST.par_id%TYPE,
                       p_user_id     IN  GIPI_POLBASIC.user_id%TYPE);

--PROCEDURE copy_endttext (p_policy_id IN gipi_endttext.policy_id%TYPE) ;

PROCEDURE copy_endttext (p_policy_id IN  GIPI_ENDTTEXT.policy_id%TYPE,
                         p_par_id    IN  GIPI_PARLIST.par_id%TYPE,
                         p_user_id   IN  GIPI_POLBASIC.user_id%TYPE);


PROCEDURE copy_deductibles (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                            p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                            
PROCEDURE copy_engg_basic (p_policy_id   IN  GIPI_ENGG_BASIC.policy_id%TYPE,
                           p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                            
PROCEDURE copy_fire (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                     p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                                    
PROCEDURE copy_fire_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_fireitem.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_grouped_items (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                              p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                
PROCEDURE copy_grp_items_beneficiary (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_grouped_item_no   IN   gipi_grp_items_beneficiary.grouped_item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_inpolbas (p_policy_id IN  GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id    IN  GIPI_PARLIST.par_id%TYPE,
                         p_user_id   IN  GIPI_POLBASIC.user_id%TYPE);
                    
PROCEDURE copy_installment (
   p_item_grp        IN   gipi_inv_tax.item_grp%TYPE,
   p_prem_seq_no     IN   gipi_inv_tax.prem_seq_no%TYPE,
   p_iss_cd          IN   gipi_inv_tax.iss_cd%TYPE,
   p_takeup_seq_no   IN   gipi_winstallment.takeup_seq_no%TYPE,
   p_par_id         IN number
);                

PROCEDURE copy_invoice_pack (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
PROCEDURE copy_invperil (
   p_item_grp        IN   gipi_inv_tax.item_grp%TYPE,
   p_prem_seq_no     IN   gipi_inv_tax.prem_seq_no%TYPE,
   p_iss_cd          IN   gipi_inv_tax.iss_cd%TYPE,
   p_takeup_seq_no   IN   gipi_winv_tax.takeup_seq_no%TYPE,
   p_par_id         IN  number
);

PROCEDURE copy_inv_tax (
   p_item_grp        IN   gipi_inv_tax.item_grp%TYPE,
   p_prem_seq_no     IN   gipi_inv_tax.prem_seq_no%TYPE,
   p_iss_cd          IN   gipi_inv_tax.iss_cd%TYPE,
   p_takeup_seq_no   IN   gipi_winv_tax.takeup_seq_no%TYPE,
   p_par_id         IN number
);
PROCEDURE copy_line (
   v_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   v_pack_line_cd      IN   gipi_item.pack_line_cd%TYPE,
   v_pack_subline_cd   IN   gipi_item.pack_subline_cd%TYPE,
   v_iss_cd            IN   gipi_polbasic.iss_cd%TYPE,
   v_issue_yy          IN   gipi_polbasic.issue_yy%TYPE,
   v_pol_seq_no        IN   gipi_polbasic.pol_seq_no%TYPE,
   v_item_no           IN   gipi_item.item_no%TYPE,
   v_item_grp          IN   gipi_item.item_grp%TYPE,
   p_line_cd           IN   varchar2,
   p_subline_cd        IN   varchar2,
   p_par_type          IN   varchar2,
   p_par_id            IN   number,
   p_iss_cd          IN varchar2,
   p_issue_yy        IN number,
   p_pol_seq_no      IN number,
   p_renew_no        IN number   
);                

PROCEDURE copy_location (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                        
PROCEDURE copy_location_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);

PROCEDURE copy_mcacc (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                      p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
            
PROCEDURE copy_mcacc_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
);             

PROCEDURE copy_mortgagee (p_policy_id   IN GIPI_POLBASIC.policy_id%TYPE,
                          p_par_id      IN GIPI_PARLIST.par_id%TYPE,
                          p_iss_cd      IN GIPI_POLBASIC.user_id%TYPE,
                          p_success     OUT VARCHAR2 --Added by Apollo Cruz 12.16.2014
                         );
                          
PROCEDURE copy_open_cargo (p1_policy_id IN  GIPI_OPEN_CARGO.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                          
PROCEDURE copy_open_liab (p1_policy_id  IN  GIPI_OPEN_LIAB.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
            
PROCEDURE copy_open_peril (p1_policy_id  IN  GIPI_OPEN_PERIL.policy_id%TYPE,
                           p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                    
PROCEDURE copy_open_peril_pack (
   p1_policy_id     IN   gipi_open_peril.policy_id%TYPE,
   p_pack_line_cd   IN   gipi_item.pack_line_cd%TYPE,
   p_par_id         IN number
);

PROCEDURE copy_open_policy (
   p_open_policy_id   IN   gipi_open_policy.policy_id%TYPE,
   p_par_id         IN number
);

PROCEDURE copy_open_policy_pack (
   p_open_policy_id   IN   gipi_open_policy.policy_id%TYPE,
   p_pack_line_cd     IN   gipi_item.pack_line_cd%TYPE,
   p_par_id         IN number
);

PROCEDURE copy_orig_invoice (p_policy_id  IN  GIPI_POLBASIC.policy_id%TYPE,
                            p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
            
PROCEDURE copy_orig_invperl (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE);                                                                                              

PROCEDURE copy_orig_inv_tax (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                
PROCEDURE copy_orig_itmperil (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                              p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
            
PROCEDURE copy_pack_line_subline (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                                  p_par_id      IN  GIPI_PARLIST.par_id%TYPE);

PROCEDURE copy_perilds (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
            p_dist_no       IN number);
            
PROCEDURE copy_perilds_dtl (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                p_dist_no       IN number);
                
PROCEDURE copy_peril_discount (
   p_policy_id   IN  GIPI_PERIL_DISCOUNT.policy_id%TYPE,
   p_par_id      IN  GIPI_PARLIST.par_id%TYPE
);

PROCEDURE copy_peril_discount_pack (
   p_policy_id      IN   gipi_peril_discount.policy_id%TYPE,
   p_pack_line_cd   IN   gipi_item.pack_line_cd%TYPE,
   p_item_no        IN   gipi_item.item_no%TYPE,
   p_par_id         IN number
);

PROCEDURE copy_pictures (
   p_policy_id   IN   GIPI_POLBASIC.policy_id%TYPE,
   p_item_no     IN   GIPI_PICTURES.item_no%TYPE,
   p_par_id      IN   GIPI_PARLIST.par_id%TYPE
);

PROCEDURE copy_polbasic(p_policy_id         IN  GIPI_POLBASIC.policy_id%TYPE,
                        p_iss_cd            IN  GIPI_POLBASIC.iss_cd%TYPE,
                        p_nbt_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
                        p_nbt_line_cd       IN  GIPI_POLBASIC.line_cd%TYPE,
                        p_nbt_subline_cd    IN  GIPI_POLBASIC.subline_cd%TYPE,
                        p_nbt_issue_yy      IN  GIPI_POLBASIC.issue_yy%TYPE,
                        p_nbt_pol_seq_no    IN  GIPI_POLBASIC.pol_seq_no%TYPE,
                        p_nbt_renew_no      IN  GIPI_POLBASIC.renew_no%TYPE,
                        p_par_id            IN  GIPI_PARLIST.par_id%TYPE,
                        p_user              IN  GIPI_POLBASIC.user_id%TYPE);            
            

FUNCTION validate_copypar_line_cd(p_line_cd         varchar2)
    RETURN varchar2;
	
FUNCTION validate_line_cd
	(p_line_cd	giis_line.line_cd%TYPE,
 	 p_iss_cd	giis_issource.iss_cd%TYPE,
     p_user_id	giis_users.user_id%TYPE,
     p_module_id giis_modules.module_id%TYPE)
    RETURN VARCHAR2;          
    
FUNCTION check_op_flag(p_line_cd            varchar2,
                       p_subline_cd         varchar2)
    RETURN varchar2;
    
PROCEDURE insert_into_parlist (p_policy_id IN gipi_polbasic.policy_id%TYPE,
                               p_user       IN varchar2,
                               par_type     OUT varchar2,
                               p_par_id     IN number);  
                               
  TYPE exist_type IS RECORD(
        v_exist1        varchar2(5),
        v_exist        varchar2(5),
        v_message       varchar2(500)       
  );
  
  TYPE exist_tab IS TABLE OF   exist_type;
  
FUNCTION validate_par_is_cd(p_iss_cd           varchar2,
                             p_line_cd         varchar2,
                             p_module_id       varchar2)
      RETURN exist_tab PIPELINED;       
      
PROCEDURE insert_into_parhist(p_par_id          GIPI_PARLIST.par_id%TYPE,
                              p_user_id         GIPI_POLBASIC.user_id%TYPE);
                                             
PROCEDURE copy_polgenin (p_policy_id      IN  GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id         IN  GIPI_PARLIST.par_id%TYPE,
                         p_user_id        IN  GIPI_POLBASIC.user_id%TYPE);
                                                          
PROCEDURE copy_polwc (p_policy_id      IN  GIPI_POLBASIC.policy_id%TYPE,
                      p_par_id         IN  GIPI_PARLIST.par_id%TYPE);

PROCEDURE copy_principal (p_policy_id   IN  GIPI_PRINCIPAL.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                          
PROCEDURE copy_vehicle (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                        p_par_id      IN  GIPI_PARLIST.par_id%TYPE);
                          
PROCEDURE update_gipi_parlist(p_iss_cd   IN   gipi_parlist.iss_cd%TYPE,
                              p_par_id   IN   gipi_parlist.par_id%TYPE);     
                              
PROCEDURE update_gipi_wpolbas2(p_iss_cd   IN  gipi_wpolbas.iss_cd%TYPE,
                              p_par_id   IN  gipi_wpolbas.par_id%TYPE);     
                              
PROCEDURE update_all_tables(p_iss_cd   IN  GIPI_WPOLBAS.iss_cd%TYPE,
                            p_par_id   IN  GIPI_WPOLBAS.par_id%TYPE,
                            p_nbt_endt_iss_cd  IN  GIPI_WPOLBAS.endt_iss_cd%TYPE);     
                            
PROCEDURE copy_vehicle_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id      IN   number
);

TYPE get_main_query_type IS RECORD(
    par_seq_no              number,
    quote_seq_no            number,
    par_id                  number
);
TYPE get_main_query_tab IS TABLE OF get_main_query_type;

PROCEDURE main_query_copy(p_policy_id           IN          number,
                          p_nbt_line_cd         IN          varchar2,
                          p_nbt_subline_cd      IN          varchar2,
                          p_nbt_endt_seq_no     IN          number,
                          p_line_cd             IN          varchar2,
                          p_iss_cd              IN          varchar2,
                          p_issue_yy            IN          number,
                         -- p_pol_seq_no          IN          number,
                          p_renew_no            IN          number,
                          p_nbt_iss_cd          IN          varchar2,
                          p_nbt_issue_yy        IN          number,
                          p_nbt_pol_seq_no      IN          number,
                          p_nbt_renew_no        IN          number,
                          p_nbt_endt_iss_cd     IN          varchar2,
                          p_nbt_endt_yy         IN          number,
                          p_user                IN          varchar2,
                          r_par_seq_no          OUT         number,
                          r_quote_seq_no        OUT         number,
                          par_id                OUT         number,
                          v_message             OUT      varchar2,
                          v_message2            OUT      varchar2,
                          v_message3            OUT      varchar2,
                          v_message4            OUT      varchar2);                                     
                          
PROCEDURE copy_ves_air (p_policy_id IN gipi_ves_air.policy_id%TYPE,
                        p_par_id    IN      number);                                                                                   


PROCEDURE copy_ves_accumulation (
   p_line_cd      IN   gipi_ves_accumulation.line_cd%TYPE,
   p_subline_cd   IN   gipi_ves_accumulation.subline_cd%TYPE,
   p_iss_cd       IN   gipi_ves_accumulation.iss_cd%TYPE,
   p_issue_yy     IN   gipi_ves_accumulation.issue_yy%TYPE,
   p_pol_seq_no   IN   gipi_ves_accumulation.pol_seq_no%TYPE,
   p_par_id       IN   number
);

PROCEDURE copy_ves_accumulation_pack (
   p_line_cd      IN   gipi_ves_accumulation.line_cd%TYPE,
   p_subline_cd   IN   gipi_ves_accumulation.subline_cd%TYPE,
   p_iss_cd       IN   gipi_ves_accumulation.iss_cd%TYPE,
   p_issue_yy     IN   gipi_ves_accumulation.issue_yy%TYPE,
   p_pol_seq_no   IN   gipi_ves_accumulation.pol_seq_no%TYPE,
   p_item_no      IN   gipi_item.item_no%TYPE,
   p_par_id       IN   number
);

FUNCTION get_copypolicy_id(p_line_cd            varchar2,
                           p_subline_cd         varchar2,
                           p_iss_cd             varchar2,
                           p_issue_yy           number,
                           p_pol_seq_no         number,
                           p_renew_no           number)
   RETURN number;



 TYPE main_query_type IS RECORD(
        --COUNTER                     number,
        open_flag                   varchar(10),
        policy_id                   number,
        pol_flag                    varchar(10),
        line_cd                     varchar2(10),
        subline_cd                  varchar2(10),
        iss_cd                      varchar2(10),
        issue_yy                    number,
        pol_seq_no                  number,
        renew_no                    number,
        count                       number,
        pack_pol_flag               varchar2(10),
        pack_line_cd                varchar2(10),
        pack_subline_cd             varchar2(10),
        item_grp                    number,
        item_no                     number,
        item_exist                  varchar2(10),
        iss_cd_ri                   varchar2(10),
        par_type                    varchar2(10),
        par_id                      number,
        message                     varchar2(5000),
        message1                    varchar2(5000),
        message2                    varchar2(5000),
        message3                    varchar2(5000),
        par_seq_no                  number,
        quote_seq_no                number,
        menu_line_cd                varchar2(10),
        long1                       varchar2(1000),        
        subline_mop                 varchar2(10),
        line_ac                     varchar2(10),
        line_av                     varchar2(10),
        line_en                     varchar2(10),
        line_mc                     varchar2(10),
        line_fi                     varchar2(10),
        line_ca                     varchar2(10),
        line_mh                     varchar2(10),
        line_mn                     varchar2(10),
        line_su                     varchar2(10),
        r_par_seq_no                number,
        r_quote_seq_no              number
      );
      
      TYPE main_query_tab IS TABLE OF main_query_type;
      
      
      FUNCTION main_query1(p_policy_id           IN          number,
                     p_nbt_line_cd         IN          varchar2,
                     p_nbt_subline_cd      IN          varchar2,
                     p_nbt_endt_seq_no     IN          number,
                     p_line_cd             IN          varchar2,
                     p_iss_cd              IN          varchar2,
                     p_issue_yy            IN          number,
                     p_renew_no            IN          number,
                     p_nbt_iss_cd          IN          varchar2,
                     p_nbt_issue_yy        IN          number,
                     p_nbt_pol_seq_no      IN          number,
                     p_nbt_renew_no        IN          number,
                     p_nbt_endt_iss_cd     IN          varchar2,
                     p_nbt_endt_yy         IN          number,
                     p_user                IN          varchar2)
        RETURN main_query_tab PIPELINED;    
        
FUNCTION main_query2(p_par_id       number)
        RETURN main_query_tab PIPELINED;        
        
FUNCTION main_query3(
                     p_nbt_line_cd         IN          varchar2
                     )
        RETURN main_query_tab PIPELINED;
        
PROCEDURE main_query4(p_par_id              number,
                      p_nbt_line_cd         varchar2,
                      p_nbt_iss_cd          varchar2,
                      v_open_flag           varchar2,
                      par_type              varchar2);
      -- RETURN main_query_tab PIPELINED;        


FUNCTION cur_query(
                     p_policy_id                   number
                     )
        RETURN main_query_tab PIPELINED  ;
        
FUNCTION get_validation_details(p_policy_id           IN          number,
                     p_nbt_line_cd         IN          varchar2,
                     p_nbt_subline_cd      IN          varchar2,
                     p_nbt_endt_seq_no     IN          number,
                     p_line_cd             IN          varchar2,
                     p_iss_cd              IN          varchar2,
                     p_issue_yy            IN          number,
                     p_renew_no            IN          number,
                     p_nbt_iss_cd          IN          varchar2,
                     p_nbt_issue_yy        IN          number,
                     p_nbt_pol_seq_no      IN          number,
                     p_nbt_renew_no        IN          number,
                     p_nbt_endt_iss_cd     IN          varchar2,
                     p_nbt_endt_yy         IN          number,
                     p_user                IN          varchar2)
        RETURN main_query_tab PIPELINED;


FUNCTION get_validation_policy_details(p_policy_id           IN          number,
                     p_nbt_line_cd         IN          varchar2,
                     p_nbt_subline_cd      IN          varchar2,
                     p_nbt_endt_seq_no     IN          number,
                     p_line_cd             IN          varchar2,
                     p_iss_cd              IN          varchar2,
                     p_issue_yy            IN          number,
                     p_renew_no            IN          number,
                     p_nbt_iss_cd          IN          varchar2,
                     p_nbt_issue_yy        IN          number,
                     p_nbt_pol_seq_no      IN          number,
                     p_nbt_renew_no        IN          number,
                     p_nbt_endt_iss_cd     IN          varchar2,
                     p_nbt_endt_yy         IN          number,
                     p_user                IN          varchar2)
        RETURN main_query_tab PIPELINED;
        
PROCEDURE initialize_copy_variables
(p_nbt_line_cd      IN      GIPI_POLBASIC.line_cd%TYPE,
 p_nbt_subline_cd   IN      GIPI_POLBASIC.subline_cd%TYPE,
 p_menu_line_cd     OUT     GIIS_LINE.menu_line_cd%TYPE,
 p_line_ac          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_av          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_en          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_mc          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_fi          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_mh          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_mn          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_line_su          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_subline_mop      OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_iss_cd_ri        OUT     GIIS_PARAMETERS.param_value_v%TYPE,
 p_open_flag        OUT     GIIS_SUBLINE.op_flag%TYPE,
 p_pack_pol_flag    OUT     GIIS_LINE.pack_pol_flag%TYPE);
 
PROCEDURE check_existing_policy
(p_line_cd          IN OUT  GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN OUT  GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN OUT  GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN OUT  GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN OUT  GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN OUT  GIPI_POLBASIC.renew_no%TYPE,
 p_nbt_endt_iss_cd  IN      GIPI_POLBASIC.endt_iss_cd%TYPE,
 p_nbt_endt_yy      IN      GIPI_POLBASIC.endt_yy%TYPE,
 p_nbt_endt_seq_no  IN      GIPI_POLBASIC.endt_seq_no%TYPE,
 p_policy_id        OUT     GIPI_POLBASIC.policy_id%TYPE,
 p_pol_flag         OUT     GIPI_POLBASIC.pol_flag%TYPE);
        
PROCEDURE insert_into_parlist_2 
(p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
 p_user_id      IN   GIPI_POLBASIC.user_id%TYPE,
 p_par_iss_cd   IN   GIPI_PARLIST.iss_cd%TYPE,                              
 p_par_id       OUT  GIPI_PARLIST.par_id%TYPE,
 p_par_type     OUT  GIPI_PARLIST.par_type%TYPE);
 
 PROCEDURE copy_pack_items
(p_policy_id         IN  GIPI_POLBASIC.policy_id%TYPE,
 p_nbt_line_cd       IN  GIPI_POLBASIC.line_cd%TYPE,
 p_nbt_subline_cd    IN  GIPI_POLBASIC.subline_cd%TYPE,
 p_nbt_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
 p_nbt_issue_yy      IN  GIPI_POLBASIC.issue_yy%TYPE,
 p_nbt_pol_seq_no    IN  GIPI_POLBASIC.pol_seq_no%TYPE,
 p_nbt_renew_no      IN  GIPI_POLBASIC.renew_no%TYPE,
 p_iss_cd            IN  GIPI_POLBASIC.iss_cd%TYPE,
 p_par_id            IN  GIPI_PARLIST.par_id%TYPE,
 p_par_type          IN  GIPI_PARLIST.par_type%TYPE,   
 p_user_id           IN  GIPI_POLBASIC.user_id%TYPE,
 p_item_exists       OUT VARCHAR2);
 
 PROCEDURE update_invoice
 (p_par_id    IN  GIPI_WPOLBAS.par_id%TYPE,
  p_line_cd   IN  GIPI_WPOLBAS.line_cd%TYPE,  
  p_iss_cd    IN  GIPI_WPOLBAS.iss_cd%TYPE,
  p_par_type  IN  GIPI_PARLIST.par_type%TYPE,
  p_open_flag IN  VARCHAR2);


PROCEDURE get_copied_par_details
(p_policy_id     IN   GIPI_POLBASIC.policy_id%TYPE,
 p_par_id        IN   GIPI_PARLIST.par_id%TYPE,
 p_par_yy        OUT  GIPI_PARLIST.quote_seq_no%TYPE,
 p_par_seq_no    OUT  GIPI_PARLIST.par_seq_no%TYPE,
 p_quote_seq_no  OUT  GIPI_PARLIST.quote_seq_no%TYPE,
 p_par_status    OUT  GIPI_PARLIST.par_status%TYPE,
 p_old_policy_no OUT  VARCHAR2,
 p_new_par_no    OUT  VARCHAR2);

END GIUTS008_PKG;
/


