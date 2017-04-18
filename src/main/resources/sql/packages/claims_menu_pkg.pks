CREATE OR REPLACE PACKAGE CPI.claims_menu_pkg
IS
   TYPE gicls_menu_type IS RECORD (
      basic_information                VARCHAR2 (1),
      item_information                 VARCHAR2 (1),
      reserve                          VARCHAR2 (1),
      lossexpense_history              VARCHAR2 (1),
      generate_advice                  VARCHAR2 (1),
      loss_recovery                    VARCHAR2 (1),
      reports                          VARCHAR2 (1),
      --Sub Menu's
      recovery_information             VARCHAR2 (1),
      recovery_distribution            VARCHAR2 (1),
      generate_recovery_acct_entries   VARCHAR2 (1),
      claim_reserve                    VARCHAR2 (1),
      pla                              VARCHAR2 (1),
      plr                              VARCHAR2 (1),
      sub_generate_advice              VARCHAR2 (1),
      generate_fla                     VARCHAR2 (1),
      generate_loa                     VARCHAR2 (1),
      generate_cash_settlement         VARCHAR2 (1)
   );

   TYPE gicls_menu_tab IS TABLE OF gicls_menu_type;

   FUNCTION items (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_line_cd    IN   giis_line.line_cd%TYPE
   ) RETURN gicls_menu_tab PIPELINED;

   PROCEDURE manipulate_menu (
        p_claim_id   IN   gicl_claims.claim_id%TYPE,
        p_line_cd    IN   giis_line.line_cd%TYPE
        );

   PROCEDURE manipulate_menu_dtl (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_item_no    IN   gipi_item.item_no%TYPE,
      p_peril_cd   IN   giis_peril.peril_cd%TYPE
   );

   PROCEDURE manipulate_menu_hist (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_line_cd    IN   giis_line.line_cd%TYPE
   );
   
   FUNCTION enable_menus (
        p_claim_id   IN   gicl_claims.claim_id%TYPE,
        p_param   varchar2
   ) RETURN gicls_menu_tab PIPELINED;
END;
/


