CREATE OR REPLACE PACKAGE CPI.giclr050a_pkg
AS

   TYPE giclr050a_record_type IS RECORD (
      pla_seq_no                   NUMBER (12),
      line                         VARCHAR2 (25),
      pla_no                       VARCHAR2 (15),
      clm_stat_cd                  VARCHAR2 (2),
      in_hou_adj                   VARCHAR2 (8),
      claim_number                 VARCHAR2 (26),
      policy_number                VARCHAR2 (30),
      assured_name                 VARCHAR2 (500),
      claim_id                     NUMBER (12),
      ri_cd                        NUMBER (5),
      line_cd                      VARCHAR2 (2),
      share_type                   VARCHAR2 (1),
      la_yy                        NUMBER (2),
      item_no                      NUMBER (9),
      peril_cd                     NUMBER (5),
      trty_name                    VARCHAR2 (30),
      item                         VARCHAR2 (57),
      p_clm_stat_cd                VARCHAR2 (50),
      p_peril_cd                   NUMBER (5),
      p_claim_id                   NUMBER (12),
      p_la_yy                      NUMBER (2),
      p_pla_seq_no                 NUMBER (12),
      p_ri_cd                      NUMBER (5),
      p_line_cd                    VARCHAR2 (2),
      p_user_id                    VARCHAR2 (40),
      company_addformula           VARCHAR2 (350),
      company_nameformula          VARCHAR2 (200),
      cf_stat_descformula          VARCHAR2 (50),
      cf_peril_snameformula        VARCHAR2 (100),
      cf_reinsurerformula          VARCHAR2 (500),
      cf_shr_loss_res_amtformula   NUMBER (16, 2),
      cf_exp_shr_amtformula        NUMBER (16, 2),
      v_test                       VARCHAR2 (1)
   );

   TYPE giclr050a_record_tab IS TABLE OF giclr050a_record_type;

   FUNCTION get_giclr050a_record (
        p_line_cd VARCHAR2, 
        p_user_id VARCHAR2,
        p_all_users VARCHAR2
   )
      RETURN giclr050a_record_tab PIPELINED;
END;
/


