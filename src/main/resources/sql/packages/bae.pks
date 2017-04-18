CREATE OR REPLACE PACKAGE CPI.Bae AS
   /*
     CREATED BY: Michaell
     CREATED ON: 09-30-2002
     REMARKS   :These procedures are the scripts that where being previously run
        in the Batch Accounting Entry Generation modules using the HOST
        command. The scripts where modified to use the BULK COLLECT command.
   */
   PROCEDURE bae1_copy_tax_to_extract(p_prod_date DATE);
   PROCEDURE bae1_copy_to_extract(p_prod_date DATE);
   PROCEDURE bae1_copy_to_extract_reg(p_prod_date DATE);
   PROCEDURE bae1_create_comm(p_prod_date DATE,
                              p_line_dep  NUMBER,
                              p_intm_dep  NUMBER,
                              p_item_no   NUMBER);
   PROCEDURE bae1_create_other_charges(p_prod_date DATE,
                                       p_line_dep  NUMBER,
                                       p_intm_dep  NUMBER,
                                       p_item_no   NUMBER);
   PROCEDURE bae1_create_parent_comm(p_prod_date DATE,
                                     p_line_dep  NUMBER,
                                     p_intm_dep  NUMBER,
                                     p_item_no   NUMBER);
   PROCEDURE bae1_create_premiums(p_prod_date DATE,
                                  p_line_dep  NUMBER,
                                  p_intm_dep  NUMBER,
                                  p_item_no   NUMBER);
   PROCEDURE bae1_create_prem_rec_gross(p_prod_date DATE,
                                        p_line_dep  NUMBER,
                                        p_intm_dep  NUMBER,
                                        p_item_no   NUMBER);
   --added by mikel 06.15.2015; SR 4691 Wtax enhancements, BIR demo findings.                                            
   PROCEDURE bae1_create_wtax   (p_prod_date DATE,
                                 p_line_dep  NUMBER,
                                 p_intm_dep  NUMBER,
                                 p_item_no   NUMBER);
   PROCEDURE bae1_insert_taxes_wheld (p_prod_date   DATE);                                                                    
   PROCEDURE bae1_create_netcomm    (p_prod_date DATE,
                                     p_line_dep  NUMBER,
                                     p_intm_dep  NUMBER,
                                     p_item_no   NUMBER);
   --end mikel 06.15.2015                                                                                                       
   PROCEDURE bae2_copy_to_extract(p_prod_date DATE);
   PROCEDURE bae2_copy_to_extract_reg(p_prod_date DATE);
   PROCEDURE bae2_copy_to_gtc(p_prod_date DATE);
   PROCEDURE bae2_copy_to_gtcd(p_prod_date DATE);
   PROCEDURE bae2_create_prem_ceded_proc(p_prod_date DATE,
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_prem_retroced_proc(p_prod_date DATE,   -- judyann 03292011
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_comm_inc_proc(p_prod_date DATE,
                                       p_line_cd   NUMBER,
                                       p_intm_cd   NUMBER,
                                       p_trty_type NUMBER,
                                       p_item_no   NUMBER);
   PROCEDURE bae2_create_comm_retro_proc(p_prod_date DATE, -- judyann 03292011
                                       p_line_cd   NUMBER,
                                       p_intm_cd   NUMBER,
                                       p_trty_type NUMBER,
                                       p_item_no   NUMBER);
   PROCEDURE bae2_create_due_to_treaty_proc(p_prod_date DATE,
                                       p_line_dep   NUMBER,
                                       p_intm_dep   NUMBER,
                                       p_trty_type  NUMBER,
                                       p_item_no    NUMBER);
   PROCEDURE bae2_create_funds_held_proc(p_prod_date DATE,
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_prem_vat_proc(p_prod_date DATE,--lina
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_comm_vat_proc(p_prod_date DATE,--lina
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_def_cr_wvat_proc(p_prod_date DATE,--lina
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_wvat_pay_proc(p_prod_date DATE,--lina
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
   PROCEDURE bae2_create_prem_tax_proc(p_prod_date DATE,--judyann 07182008
                                         p_line_dep  NUMBER,
                                         p_intm_dep  NUMBER,
                                         p_trty_type NUMBER,
                                         p_item_no   NUMBER);
END; 
/

