CREATE OR REPLACE PACKAGE CPI.populate_pla_xol_giclr028_pkg AS

    TYPE populate_reports_type IS RECORD (
        wrd_pla_no         VARCHAR2(100),
        wrd_ri_name        VARCHAR2(2000),    
        wrd_ri_add         VARCHAR2(2000),                
        wrd_title          VARCHAR2(50), 
        wrd_header         VARCHAR2(50),
        wrd_begin          VARCHAR2(2000),
        wrd_line           VARCHAR2(100),
        wrd_treaty_name    VARCHAR2(100),
        wrd_assured        VARCHAR2(100),
        wrd_policy_no      VARCHAR2(100),
        wrd_ins_term       VARCHAR2(100),
        wrd_item_tite      VARCHAR2(100),
        wrd_s              VARCHAR2(50),
        wrd_tsi_amt        VARCHAR2(100),
        wrd_trty1          VARCHAR2(100),
        wrd_s1             VARCHAR2(50),
        wrd_dist_amt       VARCHAR2(100),
        wrd_loss_date      VARCHAR2(50),
        wrd_loss_cat       VARCHAR2(500),
        wrd_los_amt        VARCHAR2(100),
        wrd_label6         VARCHAR2(100),
        wrd_label7         VARCHAR2(100),
        word_exp_amt       VARCHAR2(100),
        wrd_total_amt      VARCHAR2(100),
        wrd_s2             VARCHAR2(50),
        wrd_dist_amt2      VARCHAR2(100),
        wrd_xol_desc       VARCHAR2(100),
        wrd_s4             VARCHAR2(50),
        wrd_share_amt      VARCHAR2(100),
        wrd_signatory      VARCHAR2(100),
        wrd_footer         VARCHAR2(100)
    );
   
   TYPE populate_reports_tab IS TABLE OF populate_reports_type;

FUNCTION populate_pla_xol_giclr028_UCPB (
   p_pla_seq_no     GICL_ADVS_PLA.PLA_SEQ_NO%TYPE
   )
    
  RETURN populate_reports_tab PIPELINED;
   
END populate_pla_xol_giclr028_pkg;
/


