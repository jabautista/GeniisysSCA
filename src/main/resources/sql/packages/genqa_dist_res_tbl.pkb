CREATE OR REPLACE PACKAGE BODY CPI.genqa_dist_res_tbl
AS
   /* ***************************************************************************************************************************************
        -- checking of null/not null  dist_spct1  % - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_chk_ntnll_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED
   IS
      row_witemds_dtl   giuw_witemds_dtl%ROWTYPE;

      CURSOR get_witemds_dtl
      IS
         SELECT *
           FROM giuw_witemds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_witemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_witemdsdtl;

   FUNCTION f_chk_ntnll_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED
   IS
      row_witemperilds_dtl   giuw_witemperilds_dtl%ROWTYPE;

      CURSOR get_witemperilds_dtl
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_witemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_witmprldsdtl;

   FUNCTION f_chk_ntnll_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED
   IS
      row_wperilds_dtl   giuw_wperilds_dtl%ROWTYPE;

      CURSOR get_wperilds_dtl
      IS
         SELECT *
           FROM giuw_wperilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_wperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_wperildsdtl;

   FUNCTION f_chk_ntnll_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED
   IS
      row_wpolicyds_dtl   giuw_wpolicyds_dtl%ROWTYPE;

      CURSOR get_wpolicyds_dtl
      IS
         SELECT *
           FROM giuw_wpolicyds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_wpolicyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_wpoldsdtl;

   FUNCTION f_chk_null_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED
   IS
      row_witemds_dtl   giuw_witemds_dtl%ROWTYPE;

      CURSOR get_witemds_dtl
      IS
         SELECT *
           FROM giuw_witemds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_witemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_witemdsdtl;

   FUNCTION f_chk_null_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED
   IS
      row_witemperilds_dtl   giuw_witemperilds_dtl%ROWTYPE;

      CURSOR get_witemperilds_dtl
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_witemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_witmprldsdtl;

   FUNCTION f_chk_null_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED
   IS
      row_wperilds_dtl   giuw_wperilds_dtl%ROWTYPE;

      CURSOR get_wperilds_dtl
      IS
         SELECT *
           FROM giuw_wperilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_wperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_wperildsdtl;

   FUNCTION f_chk_null_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED
   IS
      row_wpolicyds_dtl   giuw_wpolicyds_dtl%ROWTYPE;

      CURSOR get_wpolicyds_dtl
      IS
         SELECT *
           FROM giuw_wpolicyds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_wpolicyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_wpoldsdtl;

   /* ***************************************************************************************************************************************
        -- checking of null/not null  dist_spct1  % - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_chk_ntnll_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED
   IS
      row_itemds_dtl   giuw_itemds_dtl%ROWTYPE;

      CURSOR get_itemds_dtl
      IS
         SELECT *
           FROM giuw_itemds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_itemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_f_itemdsdtl;

   FUNCTION f_chk_ntnll_spct1_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED
   IS
      row_itemperilds_dtl   giuw_itemperilds_dtl%ROWTYPE;

      CURSOR get_itemperilds_dtl
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_itemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_f_itmpldsdtl;

   FUNCTION f_chk_ntnll_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED
   IS
      row_perilds_dtl   giuw_perilds_dtl%ROWTYPE;

      CURSOR get_perilds_dtl
      IS
         SELECT *
           FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_perilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_f_perildsdtl;

   FUNCTION f_chk_ntnll_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED
   IS
      row_policyds_dtl   giuw_policyds_dtl%ROWTYPE;

      CURSOR get_policyds_dtl
      IS
         SELECT *
           FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL;
   BEGIN
      FOR dist IN get_policyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_ntnll_spct1_f_poldsdtl;

   FUNCTION f_chk_null_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED
   IS
      row_itemds_dtl   giuw_itemds_dtl%ROWTYPE;

      CURSOR get_itemds_dtl
      IS
         SELECT *
           FROM giuw_itemds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_itemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_f_itemdsdtl;

   FUNCTION f_chk_null_spct1_f_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED
   IS
      row_itemperilds_dtl   giuw_itemperilds_dtl%ROWTYPE;

      CURSOR get_itemperilds_dtl
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_itemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_f_itmprldsdtl;

   FUNCTION f_chk_null_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED
   IS
      row_perilds_dtl   giuw_perilds_dtl%ROWTYPE;

      CURSOR get_perilds_dtl
      IS
         SELECT *
           FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_perilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_f_perildsdtl;

   FUNCTION f_chk_null_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED
   IS
      row_policyds_dtl   giuw_policyds_dtl%ROWTYPE;

      CURSOR get_policyds_dtl
      IS
         SELECT *
           FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no AND dist_spct1 IS NULL;
   BEGIN
      FOR dist IN get_policyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_null_spct1_f_poldsdtl;

   /* ***************************************************************************************************************************************
   -- checking of existence of working  distribution records
************************************************************************************************************************************** */
   FUNCTION f_chk_exists_witemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds PIPELINED
   IS
      row_witemds   giuw_witemds%ROWTYPE;

      CURSOR get_witemds
      IS
         SELECT *
           FROM giuw_witemds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_witemds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_witemds;

   FUNCTION f_chk_exists_witemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED
   IS
      row_witemds_dtl   giuw_witemds_dtl%ROWTYPE;

      CURSOR get_witemds_dtl
      IS
         SELECT *
           FROM giuw_witemds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_witemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_witemds_dtl;

   FUNCTION f_chk_exists_witemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds PIPELINED
   IS
      row_witemperilds   giuw_witemperilds%ROWTYPE;

      CURSOR get_witemperilds
      IS
         SELECT *
           FROM giuw_witemperilds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_witemperilds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_witemperilds;

   FUNCTION f_chk_exists_witemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED
   IS
      row_witemperilds_dtl   giuw_witemperilds_dtl%ROWTYPE;

      CURSOR get_witemperilds_dtl
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_witemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_witemperilds_dtl;

   FUNCTION f_chk_exists_wperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds PIPELINED
   IS
      row_wperilds   giuw_wperilds%ROWTYPE;

      CURSOR get_wperilds
      IS
         SELECT *
           FROM giuw_wperilds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_wperilds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_wperilds;

   FUNCTION f_chk_exists_wperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED
   IS
      row_wperilds_dtl   giuw_wperilds_dtl%ROWTYPE;

      CURSOR get_wperilds_dtl
      IS
         SELECT *
           FROM giuw_wperilds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_wperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_wperilds_dtl;

   FUNCTION f_chk_exists_wpolicyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds PIPELINED
   IS
      row_wpolicyds   giuw_wpolicyds%ROWTYPE;

      CURSOR get_wpolicyds
      IS
         SELECT *
           FROM giuw_wpolicyds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_wpolicyds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_wpolicyds;

   FUNCTION f_chk_exists_wpolicyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED
   IS
      row_wpolicyds_dtl   giuw_wpolicyds_dtl%ROWTYPE;

      CURSOR get_wpolicyds_dtl
      IS
         SELECT *
           FROM giuw_wpolicyds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_wpolicyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_wpolicyds_dtl;

   /* ***************************************************************************************************************************************
   -- checking of existence of final  distribution records
************************************************************************************************************************************** */
   FUNCTION f_chk_exists_f_itemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds PIPELINED
   IS
      row_itemds   giuw_itemds%ROWTYPE;

      CURSOR get_itemds
      IS
         SELECT *
           FROM giuw_itemds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_itemds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_itemds;

   FUNCTION f_chk_exists_f_itemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED
   IS
      row_itemds_dtl   giuw_itemds_dtl%ROWTYPE;

      CURSOR get_itemds_dtl
      IS
         SELECT *
           FROM giuw_itemds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_itemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_itemds_dtl;

   FUNCTION f_chk_exists_f_itemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds PIPELINED
   IS
      row_itemperilds   giuw_itemperilds%ROWTYPE;

      CURSOR get_itemperilds
      IS
         SELECT *
           FROM giuw_itemperilds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_itemperilds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_itemperilds;

   FUNCTION f_chk_exists_f_itemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED
   IS
      row_itemperilds_dtl   giuw_itemperilds_dtl%ROWTYPE;

      CURSOR get_itemperilds_dtl
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_itemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_itemperilds_dtl;

   FUNCTION f_chk_exists_f_perilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds PIPELINED
   IS
      row_perilds   giuw_perilds%ROWTYPE;

      CURSOR get_perilds
      IS
         SELECT *
           FROM giuw_perilds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_perilds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_perilds;

   FUNCTION f_chk_exists_f_perilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED
   IS
      row_perilds_dtl   giuw_perilds_dtl%ROWTYPE;

      CURSOR get_perilds_dtl
      IS
         SELECT *
           FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_perilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_perilds_dtl;

   FUNCTION f_chk_exists_f_policyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds PIPELINED
   IS
      row_policyds   giuw_policyds%ROWTYPE;

      CURSOR get_policyds
      IS
         SELECT *
           FROM giuw_policyds
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_policyds
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_policyds;

   FUNCTION f_chk_exists_f_policyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED
   IS
      row_policyds_dtl   giuw_policyds_dtl%ROWTYPE;

      CURSOR get_policyds_dtl
      IS
         SELECT *
           FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_policyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_f_policyds_dtl;

   FUNCTION f_chk_exists_wfrps01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wdistfrps PIPELINED
   IS
      CURSOR get_frps
      IS
         SELECT x.*
           FROM giri_wdistfrps x
          WHERE NOT EXISTS (
                   SELECT 1
                     FROM giuw_policyds_dtl y
                    WHERE y.dist_no = x.dist_no
                      AND y.dist_seq_no = x.dist_seq_no
                      AND y.share_cd = 999)
            AND x.dist_no = p_dist_no;
   BEGIN
      FOR dist IN get_frps
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_wfrps01;

   FUNCTION f_chk_exists_wfrps02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN exists_policyds_dtl PIPELINED
   IS
      CURSOR get_poldtl
      IS
         SELECT x.*
           FROM giuw_policyds_dtl x
          WHERE NOT EXISTS (
                   SELECT 1
                     FROM giri_wdistfrps y
                    WHERE y.dist_no = x.dist_no
                      AND y.dist_seq_no = x.dist_seq_no)
            AND x.dist_no = p_dist_no
            AND x.share_cd = 999;
   BEGIN
      FOR dist IN get_poldtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_chk_exists_wfrps02;

   /* ***************************************************************************************************************************************
   --  comparison of working and final distribution records
************************************************************************************************************************************** */
   FUNCTION f_val_witemdsdtl_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemdtl_type PIPELINED
   IS
      v_itemdtl   f_itemdtl_rec_type;
   BEGIN
      FOR dist IN (SELECT *
                     FROM (SELECT dist_no, dist_seq_no, item_no, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_itemds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, item_no, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_witemds_dtl
                            WHERE dist_no = p_dist_no) x
                   UNION
                   SELECT *
                     FROM (SELECT dist_no, dist_seq_no, item_no, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_witemds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, item_no, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_itemds_dtl
                            WHERE dist_no = p_dist_no))
      LOOP
         v_itemdtl.dist_no := dist.dist_no;
         v_itemdtl.dist_seq_no := dist.dist_seq_no;
         v_itemdtl.item_no := dist.item_no;
         v_itemdtl.line_cd := dist.line_cd;
         v_itemdtl.share_cd := dist.share_cd;
         v_itemdtl.dist_spct := dist.dist_spct;
         v_itemdtl.dist_spct1 := dist.dist_spct1;
         v_itemdtl.dist_tsi := dist.dist_tsi;
         v_itemdtl.dist_prem := dist.dist_prem;
         v_itemdtl.ann_dist_spct := dist.ann_dist_spct;
         v_itemdtl.ann_dist_tsi := dist.ann_dist_tsi;
         v_itemdtl.dist_grp := dist.dist_grp;
         PIPE ROW (v_itemdtl);
      END LOOP;
   END f_val_witemdsdtl_f_itemdsdtl;

   FUNCTION f_val_witmpldsdtl_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemperildtl_type PIPELINED
   IS
      v_itemperildtl   f_itemperildtl_rec_type;
   BEGIN
      FOR dist IN (SELECT *
                     FROM (SELECT dist_no, dist_seq_no, item_no, peril_cd,
                                  line_cd, share_cd, dist_tsi, dist_prem,
                                  dist_spct, dist_spct1, ann_dist_spct,
                                  ann_dist_tsi, dist_grp
                             FROM giuw_itemperilds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, item_no, peril_cd,
                                  line_cd, share_cd, dist_tsi, dist_prem,
                                  dist_spct, dist_spct1, ann_dist_spct,
                                  ann_dist_tsi, dist_grp
                             FROM giuw_witemperilds_dtl
                            WHERE dist_no = p_dist_no)
                   UNION
                   SELECT *
                     FROM (SELECT dist_no, dist_seq_no, item_no, peril_cd,
                                  line_cd, share_cd, dist_tsi, dist_prem,
                                  dist_spct, dist_spct1, ann_dist_spct,
                                  ann_dist_tsi, dist_grp
                             FROM giuw_witemperilds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, item_no, peril_cd,
                                  line_cd, share_cd, dist_tsi, dist_prem,
                                  dist_spct, dist_spct1, ann_dist_spct,
                                  ann_dist_tsi, dist_grp
                             FROM giuw_itemperilds_dtl
                            WHERE dist_no = p_dist_no))
      LOOP
         v_itemperildtl.dist_no := dist.dist_no;
         v_itemperildtl.dist_seq_no := dist.dist_seq_no;
         v_itemperildtl.item_no := dist.item_no;
         v_itemperildtl.peril_cd := dist.peril_cd;
         v_itemperildtl.line_cd := dist.line_cd;
         v_itemperildtl.share_cd := dist.share_cd;
         v_itemperildtl.dist_spct := dist.dist_spct;
         v_itemperildtl.dist_spct1 := dist.dist_spct1;
         v_itemperildtl.dist_tsi := dist.dist_tsi;
         v_itemperildtl.dist_prem := dist.dist_prem;
         v_itemperildtl.ann_dist_spct := dist.ann_dist_spct;
         v_itemperildtl.ann_dist_tsi := dist.ann_dist_tsi;
         v_itemperildtl.dist_grp := dist.dist_grp;
         PIPE ROW (v_itemperildtl);
      END LOOP;
   END f_val_witmpldsdtl_f_itmpldsdtl;

   FUNCTION f_val_wperildsdtl_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_perildtl_type PIPELINED
   IS
      v_perildtl   f_perildtl_rec_type;
   BEGIN
      FOR dist IN (SELECT *
                     FROM (SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_perilds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_wperilds_dtl
                            WHERE dist_no = p_dist_no)
                   UNION
                   SELECT *
                     FROM (SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_wperilds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                  share_cd, dist_tsi, dist_prem, dist_spct,
                                  dist_spct1, ann_dist_spct, ann_dist_tsi,
                                  dist_grp
                             FROM giuw_perilds_dtl
                            WHERE dist_no = p_dist_no))
      LOOP
         v_perildtl.dist_no := dist.dist_no;
         v_perildtl.dist_seq_no := dist.dist_seq_no;
         v_perildtl.peril_cd := dist.peril_cd;
         v_perildtl.line_cd := dist.line_cd;
         v_perildtl.share_cd := dist.share_cd;
         v_perildtl.dist_tsi := dist.dist_tsi;
         v_perildtl.dist_prem := dist.dist_prem;
         v_perildtl.dist_spct := dist.dist_spct;
         v_perildtl.dist_spct1 := dist.dist_spct1;
         v_perildtl.ann_dist_spct := dist.ann_dist_spct;
         v_perildtl.ann_dist_tsi := dist.ann_dist_tsi;
         v_perildtl.dist_grp := dist.dist_grp;
         PIPE ROW (v_perildtl);
      END LOOP;
   END f_val_wperildsdtl_f_perildsdtl;

   FUNCTION f_val_wpoldsdtl_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_poldtl_type PIPELINED
   IS
      v_poldtl   f_poldtl_rec_type;
   BEGIN
      FOR dist IN (SELECT *
                     FROM (SELECT dist_no, dist_seq_no, line_cd, share_cd,
                                  dist_tsi, dist_prem, dist_spct, dist_spct1,
                                  ann_dist_spct, ann_dist_tsi, dist_grp
                             FROM giuw_policyds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, line_cd, share_cd,
                                  dist_tsi, dist_prem, dist_spct, dist_spct1,
                                  ann_dist_spct, ann_dist_tsi, dist_grp
                             FROM giuw_wpolicyds_dtl
                            WHERE dist_no = p_dist_no) x
                   UNION
                   SELECT *
                     FROM (SELECT dist_no, dist_seq_no, line_cd, share_cd,
                                  dist_tsi, dist_prem, dist_spct, dist_spct1,
                                  ann_dist_spct, ann_dist_tsi, dist_grp
                             FROM giuw_wpolicyds_dtl
                            WHERE dist_no = p_dist_no
                           MINUS
                           SELECT dist_no, dist_seq_no, line_cd, share_cd,
                                  dist_tsi, dist_prem, dist_spct, dist_spct1,
                                  ann_dist_spct, ann_dist_tsi, dist_grp
                             FROM giuw_policyds_dtl
                            WHERE dist_no = p_dist_no))
      LOOP
         v_poldtl.dist_no := dist.dist_no;
         v_poldtl.dist_seq_no := dist.dist_seq_no;
         v_poldtl.line_cd := dist.line_cd;
         v_poldtl.share_cd := dist.share_cd;
         v_poldtl.dist_tsi := dist.dist_tsi;
         v_poldtl.dist_prem := dist.dist_prem;
         v_poldtl.dist_spct := dist.dist_spct;
         v_poldtl.dist_spct1 := dist.dist_spct1;
         v_poldtl.ann_dist_spct := dist.ann_dist_spct;
         v_poldtl.ann_dist_tsi := dist.ann_dist_tsi;
         v_poldtl.dist_grp := dist.dist_grp;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_wpoldsdtl_f_poldsdtl;

   /* ***************************************************************************************************************************************
        -- checking of share % - rounded off to nine decimal places - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_dtl_rndoff9_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemds_dtl PIPELINED
   IS
      row_witemds_dtl   giuw_witemds_dtl%ROWTYPE;

      CURSOR get_witemds_dtl
      IS
         SELECT *
           FROM giuw_witemds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_witemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_witemdtl;

   FUNCTION f_val_dtl_rndoff9_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED
   IS
      row_witemperilds_dtl   giuw_witemperilds_dtl%ROWTYPE;

      CURSOR get_witemperilds_dtl
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_witemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_witmprldtl;

   FUNCTION f_val_dtl_rndoff9_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wperilds_dtl PIPELINED
   IS
      row_wperilds_dtl   giuw_wperilds_dtl%ROWTYPE;

      CURSOR get_wperilds_dtl
      IS
         SELECT *
           FROM giuw_wperilds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_wperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_wperildtl;

   FUNCTION f_val_dtl_rndoff9_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_wpolicyds_dtl PIPELINED
   IS
      row_wpolicyds_dtl   giuw_wpolicyds_dtl%ROWTYPE;

      CURSOR get_wpolicyds_dtl
      IS
         SELECT *
           FROM giuw_wpolicyds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_wpolicyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_wpoldtl;

   /* ***************************************************************************************************************************************
        -- checking of share % - rounded off to nine decimal places - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_dtl_rndoff9_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemds_dtl PIPELINED
   IS
      row_itemds_dtl   giuw_itemds_dtl%ROWTYPE;

      CURSOR get_itemds_dtl
      IS
         SELECT *
           FROM giuw_itemds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_itemds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_f_itemdtl;

   FUNCTION f_val_dtl_rndoff9_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED
   IS
      row_itemperilds_dtl   giuw_itemperilds_dtl%ROWTYPE;

      CURSOR get_itemperilds_dtl
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_itemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_f_itmprldtl;

   FUNCTION f_val_dtl_rndoff9_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED
   IS
      row_perilds_dtl   giuw_perilds_dtl%ROWTYPE;

      CURSOR get_perilds_dtl
      IS
         SELECT *
           FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_perilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_f_perildtl;

   FUNCTION f_val_dtl_rndoff9_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED
   IS
      row_policyds_dtl   giuw_policyds_dtl%ROWTYPE;

      CURSOR get_policyds_dtl
      IS
         SELECT *
           FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no
            AND (   ROUND (NVL (dist_spct, 0), 9) <> NVL (dist_spct, 0)
                 OR ROUND (NVL (dist_spct1, 0), 9) <> NVL (dist_spct1, 0)
                );
   BEGIN
      FOR dist IN get_policyds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_val_dtl_rndoff9_f_poldtl;

   /* ***************************************************************************************************************************************
   -- checking of zero share % - working distribution tables
************************************************************************************************************************************** */

   /* ***************************************************************************************************************************************
   -- checking of zero share % - final distribution tables
************************************************************************************************************************************** */
   FUNCTION f_chk_btsp_zerospct_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemdtl_type PIPELINED
   IS
      v_itemdtl   f_itemdtl_rec_type;
   BEGIN
      IF p_action = 'P'
      THEN
         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT dist_no, dist_seq_no, item_no, line_cd,
                                share_cd, dist_spct, dist_spct1, dist_tsi,
                                dist_prem, ann_dist_spct, ann_dist_tsi,
                                dist_grp
                           FROM giuw_itemds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_itemdtl.dist_no := dist.dist_no;
               v_itemdtl.dist_seq_no := dist.dist_seq_no;
               v_itemdtl.item_no := dist.item_no;
               v_itemdtl.line_cd := dist.line_cd;
               v_itemdtl.share_cd := dist.share_cd;
               v_itemdtl.dist_spct := dist.dist_spct;
               v_itemdtl.dist_spct1 := dist.dist_spct1;
               v_itemdtl.dist_tsi := dist.dist_tsi;
               v_itemdtl.dist_prem := dist.dist_prem;
               v_itemdtl.ann_dist_spct := dist.ann_dist_spct;
               v_itemdtl.ann_dist_tsi := dist.ann_dist_tsi;
               v_itemdtl.dist_grp := dist.dist_grp;
               PIPE ROW (v_itemdtl);
            END LOOP;

            RETURN;
         ELSE
            FOR dist IN (SELECT dist_no, dist_seq_no, item_no, line_cd,
                                share_cd, dist_spct, dist_spct1, dist_tsi,
                                dist_prem, ann_dist_spct, ann_dist_tsi,
                                dist_grp
                           FROM giuw_itemds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_spct = 0
                            AND dist_spct1 = 0)
            LOOP
               v_itemdtl.dist_no := dist.dist_no;
               v_itemdtl.dist_seq_no := dist.dist_seq_no;
               v_itemdtl.item_no := dist.item_no;
               v_itemdtl.line_cd := dist.line_cd;
               v_itemdtl.share_cd := dist.share_cd;
               v_itemdtl.dist_spct := dist.dist_spct;
               v_itemdtl.dist_spct1 := dist.dist_spct1;
               v_itemdtl.dist_tsi := dist.dist_tsi;
               v_itemdtl.dist_prem := dist.dist_prem;
               v_itemdtl.ann_dist_spct := dist.ann_dist_spct;
               v_itemdtl.ann_dist_tsi := dist.ann_dist_tsi;
               v_itemdtl.dist_grp := dist.dist_grp;
               PIPE ROW (v_itemdtl);
            END LOOP;

            RETURN;
         END IF;
      END IF;
   END f_chk_btsp_zerospct_f_itemdtl;

   FUNCTION f_chk_btsp_zerospct_f_itmpldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_itemperildtl_type PIPELINED
   IS
      v_itemperildtl   f_itemperildtl_rec_type;
   BEGIN
      IF p_action = 'P'
      THEN
         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT dist_no, dist_seq_no, item_no, line_cd,
                                peril_cd, share_cd, dist_spct, dist_spct1,
                                dist_tsi, dist_prem, ann_dist_spct,
                                ann_dist_tsi, dist_grp
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_itemperildtl.dist_no := dist.dist_no;
               v_itemperildtl.dist_seq_no := dist.dist_seq_no;
               v_itemperildtl.item_no := dist.item_no;
               v_itemperildtl.peril_cd := dist.peril_cd;
               v_itemperildtl.line_cd := dist.line_cd;
               v_itemperildtl.share_cd := dist.share_cd;
               v_itemperildtl.dist_spct := dist.dist_spct;
               v_itemperildtl.dist_spct1 := dist.dist_spct1;
               v_itemperildtl.dist_tsi := dist.dist_tsi;
               v_itemperildtl.dist_prem := dist.dist_prem;
               v_itemperildtl.ann_dist_spct := dist.ann_dist_spct;
               v_itemperildtl.ann_dist_tsi := dist.ann_dist_tsi;
               v_itemperildtl.dist_grp := dist.dist_grp;
               PIPE ROW (v_itemperildtl);
            END LOOP;
         ELSE
            FOR dist IN (SELECT dist_no, dist_seq_no, item_no, line_cd,
                                peril_cd, share_cd, dist_spct, dist_spct1,
                                dist_tsi, dist_prem, ann_dist_spct,
                                ann_dist_tsi, dist_grp
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_spct = 0
                            AND dist_spct1 = 0)
            LOOP
               v_itemperildtl.dist_no := dist.dist_no;
               v_itemperildtl.dist_seq_no := dist.dist_seq_no;
               v_itemperildtl.item_no := dist.item_no;
               v_itemperildtl.peril_cd := dist.peril_cd;
               v_itemperildtl.line_cd := dist.line_cd;
               v_itemperildtl.share_cd := dist.share_cd;
               v_itemperildtl.dist_spct := dist.dist_spct;
               v_itemperildtl.dist_spct1 := dist.dist_spct1;
               v_itemperildtl.dist_tsi := dist.dist_tsi;
               v_itemperildtl.dist_prem := dist.dist_prem;
               v_itemperildtl.ann_dist_spct := dist.ann_dist_spct;
               v_itemperildtl.ann_dist_tsi := dist.ann_dist_tsi;
               v_itemperildtl.dist_grp := dist.dist_grp;
               PIPE ROW (v_itemperildtl);
            END LOOP;
         END IF;
      END IF;
   END f_chk_btsp_zerospct_f_itmpldtl;

   FUNCTION f_chk_btsp_zerospct_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_perilds_dtl PIPELINED
   IS
      row_perilds_dtl   giuw_perilds_dtl%ROWTYPE;

      CURSOR get_perilds_dtl
      IS
         SELECT *
           FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct = 0;

      CURSOR get_perilds_dtl2
      IS
         SELECT *
           FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no AND dist_spct = 0 AND dist_spct1 = 0;
   BEGIN
      IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         FOR dist IN get_perilds_dtl
         LOOP
            PIPE ROW (dist);
         END LOOP;
      ELSE
         FOR dist IN get_perilds_dtl2
         LOOP
            PIPE ROW (dist);
         END LOOP;
      END IF;
   END f_chk_btsp_zerospct_f_perildtl;

   FUNCTION f_chk_btsp_zerospct_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_policyds_dtl PIPELINED
   IS
      row_policyds_dtl   giuw_policyds_dtl%ROWTYPE;

      CURSOR get_policyds_dtl
      IS
         SELECT *
           FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no AND dist_spct = 0;

      CURSOR get_policyds_dtl2
      IS
         SELECT *
           FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no AND dist_spct = 0 AND dist_spct1 = 0;
   BEGIN
      IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         FOR dist IN get_policyds_dtl
         LOOP
            PIPE ROW (dist);
         END LOOP;
      ELSE
         FOR dist IN get_policyds_dtl2
         LOOP
            PIPE ROW (dist);
         END LOOP;
      END IF;
   END f_chk_btsp_zerospct_f_poldtl;

/* ***************************************************************************************************************************************
     -- queries on working distribution tables   (amount )
  ************************************************************************************************************************************** */
   FUNCTION f_val_witemds_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemdtl_disc_amt_type PIPELINED
   IS
      v_itemdtl   itemdtl_disc_amt_rec_type;
   BEGIN
      IF p_action = 'S'
      THEN
         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_witemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_witemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.item_no = c.item_no(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_witemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_witemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.item_no = a.item_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_itemdtl.dist_no := discrep.dist_no;
            v_itemdtl.dist_seq_no := discrep.dist_seq_no;
            v_itemdtl.item_no := discrep.item_no;
            v_itemdtl.tsi_amt := discrep.itemds_tsi;
            v_itemdtl.dist_tsi := discrep.itemds_dtl_tsi;
            v_itemdtl.prem_amt := discrep.itemds_prem;
            v_itemdtl.dist_prem := discrep.itemds_dtl_prem;
            v_itemdtl.diff_tsi := discrep.diff_tsi;
            v_itemdtl.diff_prem := discrep.diff_prem;
            PIPE ROW (v_itemdtl);
         END LOOP;
      END IF;
   END f_val_witemds_witemdsdtl;

   FUNCTION f_val_wpolds_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldtl_disc_amt_type PIPELINED
   IS
      v_pol_dtl   poldtl_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_wpolicyds a,
                             (SELECT   b.dist_no, b.dist_seq_no,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_wpolicyds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no) c
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = c.dist_no(+)
                         AND a.dist_seq_no = c.dist_seq_no(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT c.dist_no, c.dist_seq_no, a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_wpolicyds a,
                             (SELECT   b.dist_no, b.dist_seq_no,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_wpolicyds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no) c
                       WHERE 1 = 1
                         AND c.dist_no = p_dist_no
                         AND c.dist_no = a.dist_no(+)
                         AND c.dist_seq_no = a.dist_seq_no(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_pol_dtl.dist_no := discrep.dist_no;
         v_pol_dtl.dist_seq_no := discrep.dist_seq_no;
         v_pol_dtl.tsi_amt := discrep.tsi_amt;
         v_pol_dtl.dist_tsi := discrep.dist_tsi;
         v_pol_dtl.prem_amt := discrep.prem_amt;
         v_pol_dtl.dist_prem := discrep.dist_prem;
         v_pol_dtl.diff_tsi := discrep.tsi_amt;
         v_pol_dtl.diff_prem := discrep.prem_amt;
         PIPE ROW (v_pol_dtl);
      END LOOP;
   END f_val_wpolds_wpoldsdtl;

   FUNCTION f_val_wperilds_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN perildtl_disc_amt_type PIPELINED
   IS
      v_perildtl   perildtl_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd, a.tsi_amt,
                             c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_wperilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_wperilds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no, b.peril_cd) c
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = c.dist_no(+)
                         AND a.dist_seq_no = c.dist_seq_no(+)
                         AND a.peril_cd = c.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT c.dist_no, c.dist_seq_no, c.peril_cd, a.tsi_amt,
                             c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_wperilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_wperilds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no, b.peril_cd) c
                       WHERE 1 = 1
                         AND c.dist_no = p_dist_no
                         AND c.dist_no = a.dist_no(+)
                         AND c.dist_seq_no = a.dist_seq_no(+)
                         AND c.peril_cd = a.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_perildtl.dist_no := discrep.dist_no;
         v_perildtl.dist_seq_no := discrep.dist_seq_no;
         v_perildtl.peril_cd := discrep.peril_cd;
         v_perildtl.tsi_amt := discrep.tsi_amt;
         v_perildtl.dist_tsi := discrep.dist_tsi;
         v_perildtl.prem_amt := discrep.prem_amt;
         v_perildtl.dist_prem := discrep.dist_prem;
         v_perildtl.diff_tsi := discrep.tsi_amt;
         v_perildtl.diff_prem := discrep.prem_amt;
         PIPE ROW (v_perildtl);
      END LOOP;
   END f_val_wperilds_wperildsdtl;

   FUNCTION f_val_witmprlds_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemperildtl_disc_amt_type PIPELINED
   IS
      v_itmperil   itemperildtl_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                             a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_witemperilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                       b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_witemperilds_dtl b
                              GROUP BY b.dist_no,
                                       b.dist_seq_no,
                                       b.item_no,
                                       b.peril_cd) c
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = c.dist_no(+)
                         AND a.dist_seq_no = c.dist_seq_no(+)
                         AND a.item_no = c.item_no(+)
                         AND a.peril_cd = c.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT c.dist_no, c.dist_seq_no, c.item_no, c.peril_cd,
                             a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_witemperilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                       b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_witemperilds_dtl b
                              GROUP BY b.dist_no,
                                       b.dist_seq_no,
                                       b.item_no,
                                       b.peril_cd) c
                       WHERE 1 = 1
                         AND c.dist_no = p_dist_no
                         AND c.dist_no = a.dist_no(+)
                         AND c.dist_seq_no = a.dist_seq_no(+)
                         AND c.item_no = a.item_no(+)
                         AND c.peril_cd = a.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_itmperil.dist_no := discrep.dist_no;
         v_itmperil.dist_seq_no := discrep.dist_seq_no;
         v_itmperil.item_no := discrep.item_no;
         v_itmperil.peril_cd := discrep.peril_cd;
         v_itmperil.tsi_amt := discrep.tsi_amt;
         v_itmperil.dist_tsi := discrep.dist_tsi;
         v_itmperil.prem_amt := discrep.prem_amt;
         v_itmperil.dist_prem := discrep.dist_prem;
         v_itmperil.diff_tsi := discrep.tsi_amt;
         v_itmperil.diff_prem := discrep.prem_amt;
         PIPE ROW (v_itmperil);
      END LOOP;
   END f_val_witmprlds_witmprldsdtl;

   FUNCTION f_val_witmprldtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_itm_disc_amt_type PIPELINED
   IS
      v_itm_itmperil   itmperil_itm_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.share_cd,
                             a.dist_tsi itmperil_tsi, b.dist_tsi item_tsi,
                             a.dist_prem itmperil_prem,
                             b.dist_prem item_prem,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, item_no,
                                       share_cd,
                                       SUM (DECODE (y.peril_type,
                                                    'B', dist_tsi,
                                                    0
                                                   )
                                           ) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_witemperilds_dtl x, giis_peril y
                                 WHERE x.line_cd = y.line_cd
                                   AND x.peril_cd = y.peril_cd
                              GROUP BY dist_no, dist_seq_no, item_no,
                                       share_cd) a,
                             giuw_witemds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.item_no = b.item_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             )
                      UNION
                      SELECT b.dist_no, b.dist_seq_no, b.item_no, b.share_cd,
                             a.dist_tsi tsi_itmperil, b.dist_tsi tsi_item,
                             a.dist_prem prem_itmperil, b.dist_prem prem_item,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, item_no,
                                       share_cd,
                                       SUM (DECODE (y.peril_type,
                                                    'B', dist_tsi,
                                                    0
                                                   )
                                           ) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_witemperilds_dtl x, giis_peril y
                                 WHERE x.line_cd = y.line_cd
                                   AND x.peril_cd = y.peril_cd
                              GROUP BY dist_no, dist_seq_no, item_no,
                                       share_cd) a,
                             giuw_witemds_dtl b
                       WHERE a.dist_no(+) = b.dist_no
                         AND a.dist_seq_no(+) = b.dist_seq_no
                         AND a.item_no(+) = b.item_no
                         AND a.share_cd(+) = b.share_cd
                         AND b.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             ))
      LOOP
         v_itm_itmperil.dist_no := discrep.dist_no;
         v_itm_itmperil.dist_seq_no := discrep.dist_seq_no;
         v_itm_itmperil.item_no := discrep.item_no;
         v_itm_itmperil.share_cd := discrep.share_cd;
         v_itm_itmperil.item_tsi := discrep.item_tsi;
         v_itm_itmperil.itmperil_tsi := discrep.itmperil_tsi;
         v_itm_itmperil.item_prem := discrep.item_prem;
         v_itm_itmperil.itmperil_prem := discrep.itmperil_prem;
         v_itm_itmperil.diff_tsi := discrep.diff_tsi;
         v_itm_itmperil.diff_prem := discrep.diff_prem;
         PIPE ROW (v_itm_itmperil);
      END LOOP;
   END f_val_witmprldtl_witemdsdtl;

   FUNCTION f_val_witmprldtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_disc_type PIPELINED
   IS
      v_perildtl   itmperil_peril_disc_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                             a.share_cd, a.dist_tsi tsi_itmperil,
                             b.dist_tsi tsi_peril, a.dist_prem prem_itmperil,
                             b.dist_prem prem_peril,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                       share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_witemperilds_dtl
                              GROUP BY dist_no,
                                       dist_seq_no,
                                       peril_cd,
                                       share_cd) a,
                             giuw_wperilds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.peril_cd = b.peril_cd(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             )
                      UNION
                      SELECT b.dist_no, b.dist_seq_no, b.peril_cd, b.share_cd,
                             a.dist_tsi tsi_itmperil, b.dist_tsi tsi_peril,
                             a.dist_prem prem_itmperil,
                             b.dist_prem prem_peril,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                       share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_witemperilds_dtl
                              GROUP BY dist_no,
                                       dist_seq_no,
                                       peril_cd,
                                       share_cd) a,
                             giuw_wperilds_dtl b
                       WHERE a.dist_no(+) = b.dist_no
                         AND a.dist_seq_no(+) = b.dist_seq_no
                         AND a.peril_cd(+) = b.peril_cd
                         AND a.share_cd(+) = b.share_cd
                         AND b.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             ))
      LOOP
         v_perildtl.dist_no := discrep.dist_no;
         v_perildtl.dist_seq_no := discrep.dist_seq_no;
         v_perildtl.peril_cd := discrep.peril_cd;
         v_perildtl.share_cd := discrep.share_cd;
         v_perildtl.peril_tsi := discrep.tsi_peril;
         v_perildtl.itmperil_tsi := discrep.tsi_itmperil;
         v_perildtl.peril_prem := discrep.prem_peril;
         v_perildtl.itmperil_prem := discrep.prem_itmperil;
         v_perildtl.diff_tsi := discrep.diff_tsi;
         v_perildtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_perildtl);
      END LOOP;
   END f_val_witmprldtl_wperildsdtl;

   FUNCTION f_val_wpoldsdtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED
   IS
      v_poldtl   pol_oth_disc_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                             a.dist_tsi policy_dtl_tsi,
                             b.dist_tsi itemdtl_tsi,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                             a.dist_prem policy_dtl_prem,
                             b.dist_prem itemdtl_prem,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM giuw_wpolicyds_dtl a,
                             (SELECT   dist_no, dist_seq_no, share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_witemds_dtl x
                              GROUP BY dist_no, dist_seq_no, share_cd) b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                             a.dist_tsi policy_dtl_tsi,
                             b.dist_tsi itemdtl_tsi,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                             a.dist_prem policy_dtl_prem,
                             b.dist_prem itemdtl_prem,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM giuw_wpolicyds_dtl a,
                             (SELECT   dist_no, dist_seq_no, share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_witemds_dtl x
                              GROUP BY dist_no, dist_seq_no, share_cd) b
                       WHERE a.dist_no(+) = b.dist_no
                         AND a.dist_seq_no(+) = b.dist_seq_no
                         AND a.share_cd(+) = b.share_cd
                         AND b.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_poldtl.dist_no := discrep.dist_no;
         v_poldtl.dist_seq_no := discrep.dist_seq_no;
         v_poldtl.share_cd := discrep.share_cd;
         v_poldtl.policy_tsi := discrep.policy_dtl_tsi;
         v_poldtl.oth_tsi := discrep.itemdtl_tsi;
         v_poldtl.policy_prem := discrep.policy_dtl_prem;
         v_poldtl.oth_prem := discrep.itemdtl_prem;
         v_poldtl.diff_tsi := discrep.diff_tsi;
         v_poldtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_wpoldsdtl_witemdsdtl;

   FUNCTION f_val_wpoldsdtl_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED
   IS
      v_poldtl   pol_oth_disc_rec_type;
   BEGIN
      FOR discrep IN
         (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_wpolicyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type,
                                             'B', x.dist_tsi,
                                             0
                                            ),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_witemperilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY dist_no, dist_seq_no, share_cd) b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.share_cd = b.share_cd(+)
             AND a.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 )
          UNION
          SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_wpolicyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type,
                                             'B', x.dist_tsi,
                                             0
                                            ),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_witemperilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY dist_no, dist_seq_no, share_cd) b
           WHERE a.dist_no(+) = b.dist_no
             AND a.dist_seq_no(+) = b.dist_seq_no
             AND a.share_cd(+) = b.share_cd
             AND b.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 ))
      LOOP
         v_poldtl.dist_no := discrep.dist_no;
         v_poldtl.dist_seq_no := discrep.dist_seq_no;
         v_poldtl.share_cd := discrep.share_cd;
         v_poldtl.policy_tsi := discrep.policydtl_tsi;
         v_poldtl.oth_tsi := discrep.itemperildtl_tsi;
         v_poldtl.policy_prem := discrep.policydtl_prem;
         v_poldtl.oth_prem := discrep.itemperildtl_prem;
         v_poldtl.diff_tsi := discrep.diff_tsi;
         v_poldtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_wpoldsdtl_witmprldsdtl;

   FUNCTION f_val_wpoldsdtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED
   IS
      v_poldtl   pol_oth_disc_rec_type;
   BEGIN
      FOR discrep IN
         (SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_wpolicyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type, 'B', dist_tsi, 0),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_wperilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
           WHERE a.dist_no(+) = b.dist_no
             AND a.dist_seq_no(+) = b.dist_seq_no
             AND a.share_cd(+) = b.share_cd
             AND b.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 )
          UNION
          SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_wpolicyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type, 'B', dist_tsi, 0),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_wperilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.share_cd = b.share_cd(+)
             AND a.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 ))
      LOOP
         v_poldtl.dist_no := discrep.dist_no;
         v_poldtl.dist_seq_no := discrep.dist_seq_no;
         v_poldtl.share_cd := discrep.share_cd;
         v_poldtl.policy_tsi := discrep.policydtl_tsi;
         v_poldtl.oth_tsi := discrep.perildtl_tsi;
         v_poldtl.policy_prem := discrep.policydtl_prem;
         v_poldtl.oth_prem := discrep.perildtl_prem;
         v_poldtl.diff_tsi := discrep.diff_tsi;
         v_poldtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_wpoldsdtl_wperildsdtl;

/* ***************************************************************************************************************************************
     --  queries  on final distribution tables   (amount )
  ************************************************************************************************************************************** */
   FUNCTION f_val_f_itemds_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemdtl_disc_amt_type PIPELINED
   IS
      v_itemdtl   itemdtl_disc_amt_rec_type;
   BEGIN
      IF p_action = 'S'
      THEN
         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_itemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_itemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.item_no = c.item_no(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_itemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_itemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.item_no = a.item_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_itemdtl.dist_no := discrep.dist_no;
            v_itemdtl.dist_seq_no := discrep.dist_seq_no;
            v_itemdtl.item_no := discrep.item_no;
            v_itemdtl.tsi_amt := discrep.itemds_tsi;
            v_itemdtl.dist_tsi := discrep.itemds_dtl_tsi;
            v_itemdtl.prem_amt := discrep.itemds_prem;
            v_itemdtl.dist_prem := discrep.itemds_dtl_prem;
            v_itemdtl.diff_tsi := discrep.diff_tsi;
            v_itemdtl.diff_prem := discrep.diff_prem;
            PIPE ROW (v_itemdtl);
         END LOOP;
      END IF;
   END f_val_f_itemds_itemdsdtl;

   FUNCTION f_val_f_itmprlds_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itemperildtl_disc_amt_type PIPELINED
   IS
      v_itmperil   itemperildtl_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                             a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_itemperilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                       b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_itemperilds_dtl b
                              GROUP BY b.dist_no,
                                       b.dist_seq_no,
                                       b.item_no,
                                       b.peril_cd) c
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = c.dist_no(+)
                         AND a.dist_seq_no = c.dist_seq_no(+)
                         AND a.item_no = c.item_no(+)
                         AND a.peril_cd = c.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT c.dist_no, c.dist_seq_no, c.item_no, c.peril_cd,
                             a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_itemperilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                       b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_itemperilds_dtl b
                              GROUP BY b.dist_no,
                                       b.dist_seq_no,
                                       b.item_no,
                                       b.peril_cd) c
                       WHERE 1 = 1
                         AND c.dist_no = p_dist_no
                         AND c.dist_no = a.dist_no(+)
                         AND c.dist_seq_no = a.dist_seq_no(+)
                         AND c.item_no = a.item_no(+)
                         AND c.peril_cd = a.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_itmperil.dist_no := discrep.dist_no;
         v_itmperil.dist_seq_no := discrep.dist_seq_no;
         v_itmperil.item_no := discrep.item_no;
         v_itmperil.peril_cd := discrep.peril_cd;
         v_itmperil.tsi_amt := discrep.tsi_amt;
         v_itmperil.dist_tsi := discrep.dist_tsi;
         v_itmperil.prem_amt := discrep.prem_amt;
         v_itmperil.dist_prem := discrep.dist_prem;
         v_itmperil.diff_tsi := discrep.tsi_amt;
         v_itmperil.diff_prem := discrep.prem_amt;
         PIPE ROW (v_itmperil);
      END LOOP;
   END f_val_f_itmprlds_itmprldsdtl;

   FUNCTION f_val_f_itmprldtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_itm_disc_amt_type PIPELINED
   IS
      v_itm_itmperil   itmperil_itm_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.share_cd,
                             a.dist_tsi tsi_itmperil, b.dist_tsi tsi_item,
                             a.dist_prem prem_itmperil,
                             b.dist_prem prem_item,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, item_no,
                                       share_cd,
                                       SUM (DECODE (y.peril_type,
                                                    'B', dist_tsi,
                                                    0
                                                   )
                                           ) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_itemperilds_dtl x, giis_peril y
                                 WHERE x.line_cd = y.line_cd
                                   AND x.peril_cd = y.peril_cd
                              GROUP BY dist_no, dist_seq_no, item_no,
                                       share_cd) a,
                             giuw_itemds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.item_no = b.item_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             )
                      UNION
                      SELECT b.dist_no, b.dist_seq_no, b.item_no, b.share_cd,
                             a.dist_tsi tsi_itmperil, b.dist_tsi tsi_item,
                             a.dist_prem prem_itmperil, b.dist_prem prem_item,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, item_no,
                                       share_cd,
                                       SUM (DECODE (y.peril_type,
                                                    'B', dist_tsi,
                                                    0
                                                   )
                                           ) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_itemperilds_dtl x, giis_peril y
                                 WHERE x.line_cd = y.line_cd
                                   AND x.peril_cd = y.peril_cd
                              GROUP BY dist_no, dist_seq_no, item_no,
                                       share_cd) a,
                             giuw_itemds_dtl b
                       WHERE a.dist_no(+) = b.dist_no
                         AND a.dist_seq_no(+) = b.dist_seq_no
                         AND a.item_no(+) = b.item_no
                         AND a.share_cd(+) = b.share_cd
                         AND b.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             ))
      LOOP
         v_itm_itmperil.dist_no := discrep.dist_no;
         v_itm_itmperil.dist_seq_no := discrep.dist_seq_no;
         v_itm_itmperil.item_no := discrep.item_no;
         v_itm_itmperil.share_cd := discrep.share_cd;
         v_itm_itmperil.item_tsi := discrep.tsi_item;
         v_itm_itmperil.itmperil_tsi := discrep.tsi_itmperil;
         v_itm_itmperil.item_prem := discrep.prem_item;
         v_itm_itmperil.itmperil_prem := discrep.prem_itmperil;
         v_itm_itmperil.diff_tsi := discrep.diff_tsi;
         v_itm_itmperil.diff_prem := discrep.diff_prem;
         PIPE ROW (v_itm_itmperil);
      END LOOP;
   END f_val_f_itmprldtl_itemdsdtl;

   FUNCTION f_val_f_itmprldtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_disc_type PIPELINED
   IS
      v_perildtl   itmperil_peril_disc_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                             a.share_cd, a.dist_tsi tsi_itmperil,
                             b.dist_tsi tsi_peril, a.dist_prem prem_itmperil,
                             b.dist_prem prem_peril,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                       share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_itemperilds_dtl
                              GROUP BY dist_no,
                                       dist_seq_no,
                                       peril_cd,
                                       share_cd) a,
                             giuw_perilds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.peril_cd = b.peril_cd(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             )
                      UNION
                      SELECT b.dist_no, b.dist_seq_no, b.peril_cd, b.share_cd,
                             a.dist_tsi tsi_itmperil, b.dist_tsi tsi_peril,
                             a.dist_prem prem_itmperil,
                             b.dist_prem prem_peril,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                       share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_itemperilds_dtl
                              GROUP BY dist_no,
                                       dist_seq_no,
                                       peril_cd,
                                       share_cd) a,
                             giuw_perilds_dtl b
                       WHERE a.dist_no(+) = b.dist_no
                         AND a.dist_seq_no(+) = b.dist_seq_no
                         AND a.peril_cd(+) = b.peril_cd
                         AND a.share_cd(+) = b.share_cd
                         AND b.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             ))
      LOOP
         v_perildtl.dist_no := discrep.dist_no;
         v_perildtl.dist_seq_no := discrep.dist_seq_no;
         v_perildtl.peril_cd := discrep.peril_cd;
         v_perildtl.share_cd := discrep.share_cd;
         v_perildtl.peril_tsi := discrep.tsi_peril;
         v_perildtl.itmperil_tsi := discrep.tsi_itmperil;
         v_perildtl.peril_prem := discrep.prem_peril;
         v_perildtl.itmperil_prem := discrep.prem_itmperil;
         v_perildtl.diff_tsi := discrep.diff_tsi;
         v_perildtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_perildtl);
      END LOOP;
   END f_val_f_itmprldtl_perildsdtl;

   FUNCTION f_val_f_perilds_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN perildtl_disc_amt_type PIPELINED
   IS
      v_perildtl   perildtl_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd, a.tsi_amt,
                             c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_perilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_perilds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no, b.peril_cd) c
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = c.dist_no(+)
                         AND a.dist_seq_no = c.dist_seq_no(+)
                         AND a.peril_cd = c.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT c.dist_no, c.dist_seq_no, c.peril_cd, a.tsi_amt,
                             c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_perilds a,
                             (SELECT   b.dist_no, b.dist_seq_no, b.peril_cd,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_perilds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no, b.peril_cd) c
                       WHERE 1 = 1
                         AND c.dist_no = p_dist_no
                         AND c.dist_no = a.dist_no(+)
                         AND c.dist_seq_no = a.dist_seq_no(+)
                         AND c.peril_cd = a.peril_cd(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_perildtl.dist_no := discrep.dist_no;
         v_perildtl.dist_seq_no := discrep.dist_seq_no;
         v_perildtl.peril_cd := discrep.peril_cd;
         v_perildtl.tsi_amt := discrep.tsi_amt;
         v_perildtl.dist_tsi := discrep.dist_tsi;
         v_perildtl.prem_amt := discrep.prem_amt;
         v_perildtl.dist_prem := discrep.dist_prem;
         v_perildtl.diff_tsi := discrep.tsi_amt;
         v_perildtl.diff_prem := discrep.prem_amt;
         PIPE ROW (v_perildtl);
      END LOOP;
   END f_val_f_perilds_perildsdtl;

   FUNCTION f_val_f_polds_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldtl_disc_amt_type PIPELINED
   IS
      v_pol_dtl   poldtl_disc_amt_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_policyds a,
                             (SELECT   b.dist_no, b.dist_seq_no,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_policyds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no) c
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = c.dist_no(+)
                         AND a.dist_seq_no = c.dist_seq_no(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT c.dist_no, c.dist_seq_no, a.tsi_amt, c.dist_tsi,
                             NVL (a.tsi_amt, 0)
                             - NVL (c.dist_tsi, 0) diff_tsi, a.prem_amt,
                             c.dist_prem,
                               NVL (a.prem_amt, 0)
                             - NVL (c.dist_prem, 0) diff_prem
                        FROM giuw_policyds a,
                             (SELECT   b.dist_no, b.dist_seq_no,
                                       SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (b.dist_prem, 0)) dist_prem
                                  FROM giuw_policyds_dtl b
                              GROUP BY b.dist_no, b.dist_seq_no) c
                       WHERE 1 = 1
                         AND c.dist_no = p_dist_no
                         AND c.dist_no = a.dist_no(+)
                         AND c.dist_seq_no = a.dist_seq_no(+)
                         AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) != 0
                              OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_pol_dtl.dist_no := discrep.dist_no;
         v_pol_dtl.dist_seq_no := discrep.dist_seq_no;
         v_pol_dtl.tsi_amt := discrep.tsi_amt;
         v_pol_dtl.dist_tsi := discrep.dist_tsi;
         v_pol_dtl.prem_amt := discrep.prem_amt;
         v_pol_dtl.dist_prem := discrep.dist_prem;
         v_pol_dtl.diff_tsi := discrep.tsi_amt;
         v_pol_dtl.diff_prem := discrep.prem_amt;
         PIPE ROW (v_pol_dtl);
      END LOOP;
   END f_val_f_polds_poldsdtl;

   FUNCTION f_val_f_poldsdtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED
   IS
      v_poldtl   pol_oth_disc_rec_type;
   BEGIN
      FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                             a.dist_tsi policy_dtl_tsi,
                             b.dist_tsi itemdtl_tsi,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                             a.dist_prem policy_dtl_prem,
                             b.dist_prem itemdtl_prem,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM giuw_policyds_dtl a,
                             (SELECT   dist_no, dist_seq_no, share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_itemds_dtl x
                              GROUP BY dist_no, dist_seq_no, share_cd) b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) !=
                                                                             0
                             )
                      UNION
                      SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                             a.dist_tsi policy_dtl_tsi,
                             b.dist_tsi itemdtl_tsi,
                               NVL (a.dist_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                             a.dist_prem policy_dtl_prem,
                             b.dist_prem itemdtl_prem,
                               NVL (a.dist_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem
                        FROM giuw_policyds_dtl a,
                             (SELECT   dist_no, dist_seq_no, share_cd,
                                       SUM (NVL (dist_tsi, 0)) dist_tsi,
                                       SUM (NVL (dist_prem, 0)) dist_prem
                                  FROM giuw_itemds_dtl x
                              GROUP BY dist_no, dist_seq_no, share_cd) b
                       WHERE a.dist_no(+) = b.dist_no
                         AND a.dist_seq_no(+) = b.dist_seq_no
                         AND a.share_cd(+) = b.share_cd
                         AND b.dist_no = p_dist_no
                         AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                              OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) !=
                                                                             0
                             ))
      LOOP
         v_poldtl.dist_no := discrep.dist_no;
         v_poldtl.dist_seq_no := discrep.dist_seq_no;
         v_poldtl.share_cd := discrep.share_cd;
         v_poldtl.policy_tsi := discrep.policy_dtl_tsi;
         v_poldtl.oth_tsi := discrep.itemdtl_tsi;
         v_poldtl.policy_prem := discrep.policy_dtl_prem;
         v_poldtl.oth_prem := discrep.itemdtl_prem;
         v_poldtl.diff_tsi := discrep.diff_tsi;
         v_poldtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_f_poldsdtl_itemdsdtl;

   FUNCTION f_val_f_poldsdtl_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED
   IS
      v_poldtl   pol_oth_disc_rec_type;
   BEGIN
      FOR discrep IN
         (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_policyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type,
                                             'B', x.dist_tsi,
                                             0
                                            ),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_itemperilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY dist_no, dist_seq_no, share_cd) b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.share_cd = b.share_cd(+)
             AND a.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 )
          UNION
          SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_policyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type,
                                             'B', x.dist_tsi,
                                             0
                                            ),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_itemperilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY dist_no, dist_seq_no, share_cd) b
           WHERE a.dist_no(+) = b.dist_no
             AND a.dist_seq_no(+) = b.dist_seq_no
             AND a.share_cd(+) = b.share_cd
             AND b.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 ))
      LOOP
         v_poldtl.dist_no := discrep.dist_no;
         v_poldtl.dist_seq_no := discrep.dist_seq_no;
         v_poldtl.share_cd := discrep.share_cd;
         v_poldtl.policy_tsi := discrep.policydtl_tsi;
         v_poldtl.oth_tsi := discrep.itemperildtl_tsi;
         v_poldtl.policy_prem := discrep.policydtl_prem;
         v_poldtl.oth_prem := discrep.itemperildtl_prem;
         v_poldtl.diff_tsi := discrep.diff_tsi;
         v_poldtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_f_poldsdtl_itmprldsdtl;

   FUNCTION f_val_f_poldsdtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pol_oth_disc_type PIPELINED
   IS
      v_poldtl   pol_oth_disc_rec_type;
   BEGIN
      FOR discrep IN
         (SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_policyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type, 'B', dist_tsi, 0),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_perilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
           WHERE a.dist_no(+) = b.dist_no
             AND a.dist_seq_no(+) = b.dist_seq_no
             AND a.share_cd(+) = b.share_cd
             AND b.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 )
          UNION
          SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                 a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                 NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                 NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM giuw_policyds_dtl a,
                 (SELECT   dist_no, dist_seq_no, share_cd,
                           SUM (NVL (DECODE (y.peril_type, 'B', dist_tsi, 0),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (dist_prem, 0)) dist_prem
                      FROM giuw_perilds_dtl x, giis_peril y
                     WHERE x.line_cd = y.line_cd AND x.peril_cd = y.peril_cd
                  GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.share_cd = b.share_cd(+)
             AND a.dist_no = p_dist_no
             AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                  OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                 ))
      LOOP
         v_poldtl.dist_no := discrep.dist_no;
         v_poldtl.dist_seq_no := discrep.dist_seq_no;
         v_poldtl.share_cd := discrep.share_cd;
         v_poldtl.policy_tsi := discrep.policydtl_tsi;
         v_poldtl.oth_tsi := discrep.perildtl_tsi;
         v_poldtl.policy_prem := discrep.policydtl_prem;
         v_poldtl.oth_prem := discrep.perildtl_prem;
         v_poldtl.diff_tsi := discrep.diff_tsi;
         v_poldtl.diff_prem := discrep.diff_prem;
         PIPE ROW (v_poldtl);
      END LOOP;
   END f_val_f_poldsdtl_perildsdtl;

   FUNCTION f_val_f_perildsdtl_wdstfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN perildtl_frps_disc_type PIPELINED
   IS
      perilfrps   perildtl_frps_disc_rec_type;
   BEGIN
      FOR dist IN
         (SELECT x.dist_no, x.dist_seq_no, y.line_cd, y.frps_yy,
                 y.frps_seq_no, x.dist_tsi perilds_facul_tsi,
                 x.dist_prem perilds_facul_prem, y.tot_fac_tsi,
                 y.tot_fac_prem,
                 NVL (x.dist_tsi, 0) - NVL (y.tot_fac_tsi, 0) diff_tsi,
                 NVL (x.dist_prem, 0) - NVL (y.tot_fac_prem, 0) diff_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           SUM (NVL (DECODE (c.peril_type,
                                             'B', NVL (a.dist_tsi, 0),
                                             0
                                            ),
                                     0
                                    )
                               ) dist_tsi,
                           SUM (NVL (a.dist_prem, 0)) dist_prem
                      FROM giuw_perilds_dtl a, giis_peril c
                     WHERE 1 = 1
                       AND a.dist_no = p_dist_no
                       AND a.share_cd = 999
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd
                  GROUP BY a.dist_no, a.dist_seq_no) x,
                 giri_wdistfrps y
           WHERE x.dist_no = p_dist_no
             AND x.dist_no = y.dist_no(+)
             AND x.dist_seq_no = y.dist_seq_no(+)
             AND (   (NVL (x.dist_tsi, 0) - NVL (y.tot_fac_tsi, 0) <> 0)
                  OR (NVL (x.dist_prem, 0) - NVL (y.tot_fac_prem, 0) <> 0)
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.line_cd, y.frps_yy,
                 y.frps_seq_no, NULL perilds_facul_tsi,
                 NULL perilds_facul_prem, y.tot_fac_tsi, y.tot_fac_prem,
                 0 - NVL (y.tot_fac_tsi, 0) diff_tsi,
                 0 - NVL (y.tot_fac_prem, 0) diff_prem
            FROM giri_wdistfrps y
           WHERE y.dist_no = p_dist_no
             AND NOT EXISTS (
                    SELECT 1
                      FROM giuw_perilds_dtl p
                     WHERE p.dist_no = y.dist_no
                       AND p.dist_seq_no = y.dist_seq_no
                       AND p.share_cd = 999))
      LOOP
         perilfrps.dist_no := dist.dist_no;
         perilfrps.dist_seq_no := dist.dist_seq_no;
         perilfrps.line_cd := dist.line_cd;
         perilfrps.frps_yy := dist.frps_yy;
         perilfrps.frps_seq_no := dist.frps_seq_no;
         perilfrps.dist_tsi := dist.perilds_facul_tsi;
         perilfrps.dist_prem := dist.perilds_facul_prem;
         perilfrps.tot_fac_tsi := dist.tot_fac_tsi;
         perilfrps.tot_fac_prem := dist.tot_fac_prem;
         perilfrps.diff_tsi := dist.diff_tsi;
         perilfrps.diff_prem := dist.diff_prem;
         PIPE ROW (perilfrps);
      END LOOP;
   END f_val_f_perildsdtl_wdstfrps;

   FUNCTION f_val_f_poldsdtl_wdistfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldtl_frps_disc_type PIPELINED
   IS
      polfrps   poldtl_frps_disc_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.line_cd, a.frps_yy,
                          a.frps_seq_no, a.tot_fac_tsi, b.dist_tsi,
                          a.tot_fac_prem, b.dist_prem, a.tot_fac_spct,
                          b.dist_spct, a.tot_fac_spct2, b.dist_spct1,
                            NVL (a.tot_fac_tsi, 0)
                          - NVL (b.dist_tsi, 0) diff_tsi,
                            NVL (a.tot_fac_prem, 0)
                          - NVL (b.dist_prem, 0) diff_prem,
                            NVL (b.dist_spct, 0)
                          - NVL (a.tot_fac_spct, 0) diff_spct,
                            NVL (b.dist_spct1, 0)
                          - NVL (a.tot_fac_spct2, 0) diff_spct1
                     FROM giri_wdistfrps a, giuw_policyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no(+)
                      AND b.dist_seq_no = a.dist_seq_no(+)
                      AND b.share_cd(+) = 999
                      AND (   (NVL (a.tot_fac_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              )
                           OR (NVL (a.tot_fac_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                              )
                           OR (NVL (b.dist_spct, 0) - NVL (a.tot_fac_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (b.dist_spct1, 0)
                               - NVL (a.tot_fac_spct2, 0) <> 0
                              )
                          )
                   UNION
                   SELECT a.dist_no, a.dist_seq_no, a.line_cd, a.frps_yy,
                          a.frps_seq_no, a.tot_fac_tsi, b.dist_tsi,
                          a.tot_fac_prem, b.dist_prem, a.tot_fac_spct,
                          b.dist_spct, a.tot_fac_spct2, b.dist_spct1,
                            NVL (a.tot_fac_tsi, 0)
                          - NVL (b.dist_tsi, 0) diff_tsi,
                            NVL (a.tot_fac_prem, 0)
                          - NVL (b.dist_prem, 0) diff_prem,
                            NVL (b.dist_spct, 0)
                          - NVL (a.tot_fac_spct, 0) diff_spct,
                            NVL (b.dist_spct1, 0)
                          - NVL (a.tot_fac_spct2, 0) diff_spct1
                     FROM giri_wdistfrps a, giuw_policyds_dtl b
                    WHERE 1 = 1
                      AND a.dist_no = p_dist_no
                      AND a.dist_no = b.dist_no(+)
                      AND a.dist_seq_no = b.dist_seq_no(+)
                      AND b.share_cd(+) = 999
                      AND (   (NVL (a.tot_fac_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                              )
                           OR (NVL (a.tot_fac_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                              )
                           OR (NVL (b.dist_spct, 0) - NVL (a.tot_fac_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (b.dist_spct1, 0)
                               - NVL (a.tot_fac_spct2, 0) <> 0
                              )
                          ))
      LOOP
         polfrps.dist_no := dist.dist_no;
         polfrps.dist_seq_no := dist.dist_seq_no;
         polfrps.line_cd := dist.line_cd;
         polfrps.frps_yy := dist.frps_yy;
         polfrps.frps_seq_no := dist.frps_seq_no;
         polfrps.dist_spct := dist.dist_spct;
         polfrps.dist_spct1 := dist.dist_spct1;
         polfrps.tot_fac_spct := dist.tot_fac_spct;
         polfrps.tot_fac_spct2 := dist.tot_fac_spct2;
         polfrps.diff_tsi := dist.diff_tsi;
         polfrps.diff_prem := dist.diff_prem;
         polfrps.diff_spct := dist.diff_spct;
         polfrps.diff_spct1 := dist.diff_spct1;
         PIPE ROW (polfrps);
      END LOOP;
   END f_val_f_poldsdtl_wdistfrps;

   /* ***************************************************************************************************************************************
        --- validating existence of distribution tables - one risk - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vcorsk_wpoldtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED
   IS
      politem_shr   f_politem_rec_type;
   BEGIN
      FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no, x.share_cd,
                             x.dist_spct, x.dist_spct1
                        FROM giuw_wpolicyds_dtl x, giuw_witemds w
                       WHERE x.dist_no = p_dist_no
                         AND x.dist_no = w.dist_no
                         AND x.dist_seq_no = w.dist_seq_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_witemds_dtl y
                                 WHERE y.dist_no = x.dist_no
                                   AND y.dist_seq_no = x.dist_seq_no
                                   AND y.line_cd = x.line_cd
                                   AND y.share_cd = x.share_cd
                                   AND y.item_no = w.item_no))
      LOOP
         politem_shr.dist_no := curdist.dist_no;
         politem_shr.dist_seq_no := curdist.dist_seq_no;
         politem_shr.item_no := curdist.item_no;
         politem_shr.share_cd := curdist.share_cd;
         politem_shr.dist_spct := curdist.dist_spct;
         politem_shr.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (politem_shr);
      END LOOP;
   END f_vcorsk_wpoldtl_witemdtl01;

   FUNCTION f_vcorsk_wpoldtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED
   IS
      politem_shr   f_politem_rec_type;
   BEGIN
      FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.share_cd,
                             a.dist_spct, a.dist_spct1
                        FROM giuw_witemds_dtl a, giuw_wpolicyds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_wpolicyds_dtl x
                                 WHERE x.dist_no = a.dist_no
                                   AND x.dist_seq_no = a.dist_seq_no
                                   AND x.share_cd = a.share_cd))
      LOOP
         politem_shr.dist_no := curdist.dist_no;
         politem_shr.dist_seq_no := curdist.dist_seq_no;
         politem_shr.item_no := curdist.item_no;
         politem_shr.share_cd := curdist.share_cd;
         politem_shr.dist_spct := curdist.dist_spct;
         politem_shr.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (politem_shr);
      END LOOP;
   END f_vcorsk_wpoldtl_witemdtl02;

   FUNCTION f_vcorsk_wpoldtl_witmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED
   IS
      itmperil   f_politemperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no, w.peril_cd,
                             x.share_cd, x.dist_spct, x.dist_spct1
                        FROM giuw_wpolicyds_dtl x, giuw_witemperilds w
                       WHERE x.dist_no = p_dist_no
                         AND x.dist_no = w.dist_no
                         AND x.dist_seq_no = w.dist_seq_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_witemperilds_dtl y
                                 WHERE y.dist_no = x.dist_no
                                   AND y.dist_seq_no = x.dist_seq_no
                                   AND y.line_cd = x.line_cd
                                   AND y.share_cd = x.share_cd
                                   AND y.item_no = w.item_no
                                   AND y.peril_cd = w.peril_cd))
      LOOP
         itmperil.dist_no := curdist.dist_no;
         itmperil.dist_seq_no := curdist.dist_seq_no;
         itmperil.item_no := curdist.item_no;
         itmperil.peril_cd := curdist.peril_cd;
         itmperil.share_cd := curdist.share_cd;
         itmperil.dist_spct := curdist.dist_spct;
         itmperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (itmperil);
      END LOOP;
   END f_vcorsk_wpoldtl_witmprldtl01;

   FUNCTION f_vcorsk_wpoldtl_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED
   IS
      itmperil   f_politemperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                             a.share_cd, a.dist_spct, a.dist_spct1
                        FROM giuw_witemperilds_dtl a, giuw_wpolicyds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_wpolicyds_dtl x
                                 WHERE x.dist_no = a.dist_no
                                   AND x.dist_seq_no = a.dist_seq_no
                                   AND x.share_cd = a.share_cd))
      LOOP
         itmperil.dist_no := curdist.dist_no;
         itmperil.dist_seq_no := curdist.dist_seq_no;
         itmperil.item_no := curdist.item_no;
         itmperil.peril_cd := curdist.peril_cd;
         itmperil.share_cd := curdist.share_cd;
         itmperil.dist_spct := curdist.dist_spct;
         itmperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (itmperil);
      END LOOP;
   END f_vcorsk_wpoldtl_witmprldtl02;

   FUNCTION f_vcorsk_wpoldtl_wperildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED
   IS
      polperil   f_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.peril_cd,
                             x.share_cd, x.dist_spct, x.dist_spct1
                        FROM giuw_wpolicyds_dtl x, giuw_wperilds w
                       WHERE x.dist_no = p_dist_no
                         AND x.dist_no = w.dist_no
                         AND x.dist_seq_no = w.dist_seq_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_wperilds_dtl y
                                 WHERE y.dist_no = x.dist_no
                                   AND y.dist_seq_no = x.dist_seq_no
                                   AND y.share_cd = x.share_cd
                                   AND y.line_cd = w.line_cd
                                   AND y.peril_cd = w.peril_cd))
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.peril_cd := curdist.peril_cd;
         polperil.share_cd := curdist.share_cd;
         polperil.dist_spct := curdist.dist_spct;
         polperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (polperil);
      END LOOP;
   END f_vcorsk_wpoldtl_wperildtl01;

   FUNCTION f_vcorsk_wpoldtl_wperildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED
   IS
      polperil   f_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                             a.share_cd, a.dist_spct, a.dist_spct1
                        FROM giuw_wperilds_dtl a, giuw_wpolicyds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_wpolicyds_dtl x
                                 WHERE x.dist_no = a.dist_no
                                   AND x.dist_seq_no = a.dist_seq_no
                                   AND x.share_cd = a.share_cd))
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.peril_cd := curdist.peril_cd;
         polperil.share_cd := curdist.share_cd;
         polperil.dist_spct := curdist.dist_spct;
         polperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (polperil);
      END LOOP;
   END f_vcorsk_wpoldtl_wperildtl02;

/* ***************************************************************************************************************************************
       --- validating existence of distribution tables - one risk - final  distribution tables
    ************************************************************************************************************************************** */
   FUNCTION f_vcorsk_poldtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED
   IS
      politem_shr   f_politem_rec_type;
   BEGIN
      FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no, x.share_cd,
                             x.dist_spct, x.dist_spct1
                        FROM giuw_policyds_dtl x, giuw_itemds w
                       WHERE x.dist_no = p_dist_no
                         AND x.dist_no = w.dist_no
                         AND x.dist_seq_no = w.dist_seq_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_itemds_dtl y
                                 WHERE y.dist_no = x.dist_no
                                   AND y.dist_seq_no = x.dist_seq_no
                                   AND y.line_cd = x.line_cd
                                   AND y.share_cd = x.share_cd
                                   AND y.item_no = w.item_no))
      LOOP
         politem_shr.dist_no := curdist.dist_no;
         politem_shr.dist_seq_no := curdist.dist_seq_no;
         politem_shr.item_no := curdist.item_no;
         politem_shr.share_cd := curdist.share_cd;
         politem_shr.dist_spct := curdist.dist_spct;
         politem_shr.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (politem_shr);
      END LOOP;
   END f_vcorsk_poldtl_f_itemdtl01;

   FUNCTION f_vcorsk_poldtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politem_type PIPELINED
   IS
      politem_shr   f_politem_rec_type;
   BEGIN
      FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.share_cd,
                             a.dist_spct, a.dist_spct1
                        FROM giuw_itemds_dtl a, giuw_policyds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_policyds_dtl x
                                 WHERE x.dist_no = a.dist_no
                                   AND x.dist_seq_no = a.dist_seq_no
                                   AND x.share_cd = a.share_cd))
      LOOP
         politem_shr.dist_no := curdist.dist_no;
         politem_shr.dist_seq_no := curdist.dist_seq_no;
         politem_shr.item_no := curdist.item_no;
         politem_shr.share_cd := curdist.share_cd;
         politem_shr.dist_spct := curdist.dist_spct;
         politem_shr.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (politem_shr);
      END LOOP;
   END f_vcorsk_poldtl_f_itemdtl02;

   FUNCTION f_vcorsk_poldtl_f_itmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED
   IS
      itmperil   f_politemperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no, w.peril_cd,
                             x.share_cd, x.dist_spct, x.dist_spct1
                        FROM giuw_policyds_dtl x, giuw_itemperilds w
                       WHERE x.dist_no = p_dist_no
                         AND x.dist_no = w.dist_no
                         AND x.dist_seq_no = w.dist_seq_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_itemperilds_dtl y
                                 WHERE y.dist_no = x.dist_no
                                   AND y.dist_seq_no = x.dist_seq_no
                                   AND y.line_cd = x.line_cd
                                   AND y.share_cd = x.share_cd
                                   AND y.item_no = w.item_no
                                   AND y.peril_cd = w.peril_cd))
      LOOP
         itmperil.dist_no := curdist.dist_no;
         itmperil.dist_seq_no := curdist.dist_seq_no;
         itmperil.item_no := curdist.item_no;
         itmperil.peril_cd := curdist.peril_cd;
         itmperil.share_cd := curdist.share_cd;
         itmperil.dist_spct := curdist.dist_spct;
         itmperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (itmperil);
      END LOOP;
   END f_vcorsk_poldtl_f_itmprldtl01;

   FUNCTION f_vcorsk_poldtl_f_itmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_politemperil_type PIPELINED
   IS
      itmperil   f_politemperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                             a.share_cd, a.dist_spct, a.dist_spct1
                        FROM giuw_itemperilds_dtl a, giuw_policyds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_policyds_dtl x
                                 WHERE x.dist_no = a.dist_no
                                   AND x.dist_seq_no = a.dist_seq_no
                                   AND x.share_cd = a.share_cd))
      LOOP
         itmperil.dist_no := curdist.dist_no;
         itmperil.dist_seq_no := curdist.dist_seq_no;
         itmperil.item_no := curdist.item_no;
         itmperil.peril_cd := curdist.peril_cd;
         itmperil.share_cd := curdist.share_cd;
         itmperil.dist_spct := curdist.dist_spct;
         itmperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (itmperil);
      END LOOP;
   END f_vcorsk_poldtl_f_itmprldtl02;

   FUNCTION f_vcorsk_poldtl_f_perildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED
   IS
      polperil   f_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.peril_cd,
                             x.share_cd, x.dist_spct, x.dist_spct1
                        FROM giuw_policyds_dtl x, giuw_perilds w
                       WHERE x.dist_no = p_dist_no
                         AND x.dist_no = w.dist_no
                         AND x.dist_seq_no = w.dist_seq_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_perilds_dtl y
                                 WHERE y.dist_no = x.dist_no
                                   AND y.dist_seq_no = x.dist_seq_no
                                   AND y.share_cd = x.share_cd
                                   AND y.line_cd = w.line_cd
                                   AND y.peril_cd = w.peril_cd))
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.peril_cd := curdist.peril_cd;
         polperil.share_cd := curdist.share_cd;
         polperil.dist_spct := curdist.dist_spct;
         polperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (polperil);
      END LOOP;
   END f_vcorsk_poldtl_f_perildtl01;

   FUNCTION f_vcorsk_poldtl_f_perildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN f_polperil_type PIPELINED
   IS
      polperil   f_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                             a.share_cd, a.dist_spct, a.dist_spct1
                        FROM giuw_perilds_dtl a, giuw_policyds_dtl b
                       WHERE a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND a.share_cd = b.share_cd(+)
                         AND a.dist_no = p_dist_no
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giuw_policyds_dtl x
                                 WHERE x.dist_no = a.dist_no
                                   AND x.dist_seq_no = a.dist_seq_no
                                   AND x.share_cd = a.share_cd))
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.peril_cd := curdist.peril_cd;
         polperil.share_cd := curdist.share_cd;
         polperil.dist_spct := curdist.dist_spct;
         polperil.dist_spct1 := curdist.dist_spct1;
         PIPE ROW (polperil);
      END LOOP;
   END f_vcorsk_poldtl_f_perildtl02;

/* ***************************************************************************************************************************************
        --- validating existence of distribution tables - PERIL DISTRIBUTION  - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vpdist_wperildtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED
   IS
      pdist_item   pdist_item_rec_type;
   BEGIN
      FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.item_no,
                               bb.share_cd
                          FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                b.item_no, a.share_cd,
                                                c.trty_name
                                           FROM giuw_wperilds_dtl a,
                                                giuw_witemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd) bb,
                               giuw_witemds cc
                         WHERE bb.dist_no = p_dist_no
                           AND bb.dist_no = cc.dist_no(+)
                           AND bb.dist_seq_no = cc.dist_seq_no(+)
                           AND bb.item_no = cc.item_no(+)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giuw_witemds_dtl pp
                                   WHERE pp.dist_no = bb.dist_no
                                     AND pp.dist_seq_no = bb.dist_seq_no
                                     AND pp.item_no = bb.item_no
                                     AND pp.share_cd = bb.share_cd)
                      ORDER BY bb.item_no, bb.share_cd)
      LOOP
         pdist_item.dist_no := curdist.dist_no;
         pdist_item.dist_seq_no := curdist.dist_seq_no;
         pdist_item.item_no := curdist.item_no;
         pdist_item.share_cd := curdist.share_cd;
         PIPE ROW (pdist_item);
      END LOOP;
   END f_vpdist_wperildtl_witemdtl01;

   FUNCTION f_vpdist_wperildtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED
   IS
      pdist_item   pdist_item_rec_type;
   BEGIN
      FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.item_no,
                             xx.share_cd
                        FROM giuw_witemds_dtl xx,
                             (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                              b.item_no, a.share_cd,
                                              c.trty_name
                                         FROM giuw_wperilds_dtl a,
                                              giuw_witemperilds b,
                                              giis_dist_share c
                                        WHERE a.dist_no = p_dist_no
                                          AND a.line_cd = c.line_cd
                                          AND a.share_cd = c.share_cd
                                          AND a.dist_no = b.dist_no
                                          AND a.dist_seq_no = b.dist_seq_no
                                          AND a.peril_cd = b.peril_cd) yy
                       WHERE xx.dist_no = p_dist_no
                         AND xx.dist_no = yy.dist_no(+)
                         AND xx.dist_seq_no = yy.dist_seq_no(+)
                         AND xx.item_no = yy.item_no(+)
                         AND xx.share_cd = yy.share_cd(+)
                         AND NOT EXISTS (
                                SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                b.item_no, a.share_cd,
                                                c.trty_name
                                           FROM giuw_wperilds_dtl a,
                                                giuw_witemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd
                                            AND b.dist_no = xx.dist_no
                                            AND b.dist_seq_no = xx.dist_seq_no
                                            AND b.item_no = xx.item_no
                                            AND b.peril_cd = a.peril_cd
                                            AND a.share_cd = xx.share_cd))
      LOOP
         pdist_item.dist_no := curdist.dist_no;
         pdist_item.dist_seq_no := curdist.dist_seq_no;
         pdist_item.item_no := curdist.item_no;
         pdist_item.share_cd := curdist.share_cd;
         PIPE ROW (pdist_item);
      END LOOP;
   END f_vpdist_wperildtl_witemdtl02;

   FUNCTION f_vpdist_wperildtl_witmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED
   IS
      politemperil   pdist_itemperil_rec_type;
   BEGIN
      FOR cur IN (SELECT a.dist_no, a.dist_seq_no, b.item_no, a.peril_cd,
                         a.share_cd, c.trty_name
                    FROM giuw_wperilds_dtl a,
                         giuw_witemperilds b,
                         giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.line_cd = c.line_cd
                     AND a.share_cd = c.share_cd
                     AND a.dist_no = b.dist_no(+)
                     AND a.dist_seq_no = b.dist_seq_no(+)
                     AND a.peril_cd = b.peril_cd(+)
                     AND NOT EXISTS (
                            SELECT 1
                              FROM giuw_witemperilds_dtl x
                             WHERE x.dist_no = a.dist_no
                               AND x.dist_seq_no = a.dist_seq_no
                               AND x.item_no = b.item_no
                               AND x.peril_cd = b.peril_cd
                               AND x.share_cd = a.share_cd))
      LOOP
         politemperil.dist_no := cur.dist_no;
         politemperil.dist_seq_no := cur.dist_seq_no;
         politemperil.item_no := cur.item_no;
         politemperil.peril_cd := cur.peril_cd;
         politemperil.share_cd := cur.share_cd;
         PIPE ROW (politemperil);
      END LOOP;
   END f_vpdist_wperildtl_witmpldtl01;

   FUNCTION f_vpdist_wperildtl_witmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED
   IS
      politemperil   pdist_itemperil_rec_type;
   BEGIN
      FOR cur IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                         a.share_cd, a.dist_spct, a.dist_spct1
                    FROM giuw_witemperilds_dtl a, giuw_wperilds_dtl b
                   WHERE a.dist_no = b.dist_no(+)
                     AND a.dist_seq_no = b.dist_seq_no(+)
                     AND a.share_cd = b.share_cd(+)
                     AND a.peril_cd = b.peril_cd(+)
                     AND a.dist_no = p_dist_no
                     AND NOT EXISTS (
                            SELECT 1
                              FROM giuw_wperilds_dtl x
                             WHERE x.dist_no = a.dist_no
                               AND x.dist_seq_no = a.dist_seq_no
                               AND x.peril_cd = a.peril_cd
                               AND x.share_cd = a.share_cd))
      LOOP
         politemperil.dist_no := cur.dist_no;
         politemperil.dist_seq_no := cur.dist_seq_no;
         politemperil.item_no := cur.item_no;
         politemperil.peril_cd := cur.peril_cd;
         politemperil.share_cd := cur.share_cd;
         PIPE ROW (politemperil);
      END LOOP;
   END f_vpdist_wperildtl_witmpldtl02;

   FUNCTION f_vpdist_wperildtl_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED
   IS
      polperil   pdist_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.share_cd
                          FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                a.share_cd, c.trty_name
                                           FROM giuw_wperilds_dtl a,
                                                giuw_witemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd) bb,
                               giuw_wpolicyds cc
                         WHERE bb.dist_no = p_dist_no
                           AND bb.dist_no = cc.dist_no(+)
                           AND bb.dist_seq_no = cc.dist_seq_no(+)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giuw_wpolicyds_dtl pp
                                   WHERE pp.dist_no = bb.dist_no
                                     AND pp.dist_seq_no = bb.dist_seq_no
                                     AND pp.share_cd = bb.share_cd)
                      ORDER BY bb.dist_seq_no, bb.share_cd)
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.share_cd := curdist.share_cd;
         PIPE ROW (polperil);
      END LOOP;
   END f_vpdist_wperildtl_wpoldtl01;

   FUNCTION f_vpdist_wperildtl_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED
   IS
      polperil   pdist_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.share_cd
                        FROM giuw_wpolicyds_dtl xx,
                             (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                              a.share_cd, c.trty_name
                                         FROM giuw_wperilds_dtl a,
                                              giuw_witemperilds b,
                                              giis_dist_share c
                                        WHERE a.dist_no = p_dist_no
                                          AND a.line_cd = c.line_cd
                                          AND a.share_cd = c.share_cd
                                          AND a.dist_no = b.dist_no
                                          AND a.dist_seq_no = b.dist_seq_no
                                          AND a.peril_cd = b.peril_cd) yy
                       WHERE xx.dist_no = p_dist_no
                         AND xx.dist_no = yy.dist_no(+)
                         AND xx.dist_seq_no = yy.dist_seq_no(+)
                         AND xx.share_cd = yy.share_cd(+)
                         AND NOT EXISTS (
                                SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                b.item_no, a.share_cd,
                                                c.trty_name
                                           FROM giuw_wperilds_dtl a,
                                                giuw_witemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd
                                            AND b.dist_no = xx.dist_no
                                            AND b.dist_seq_no = xx.dist_seq_no
                                            AND b.peril_cd = a.peril_cd
                                            AND a.share_cd = xx.share_cd))
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.share_cd := curdist.share_cd;
         PIPE ROW (polperil);
      END LOOP;
   END f_vpdist_wperildtl_wpoldtl02;

/* ***************************************************************************************************************************************
        --- validating existence of distribution tables - PERIL DISTRIBUTION  - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vpdist_perildtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED
   IS
      pdist_item   pdist_item_rec_type;
   BEGIN
      FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.item_no,
                               bb.share_cd
                          FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                b.item_no, a.share_cd,
                                                c.trty_name
                                           FROM giuw_perilds_dtl a,
                                                giuw_itemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd) bb,
                               giuw_itemds cc
                         WHERE bb.dist_no = p_dist_no
                           AND bb.dist_no = cc.dist_no(+)
                           AND bb.dist_seq_no = cc.dist_seq_no(+)
                           AND bb.item_no = cc.item_no(+)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giuw_itemds_dtl pp
                                   WHERE pp.dist_no = bb.dist_no
                                     AND pp.dist_seq_no = bb.dist_seq_no
                                     AND pp.item_no = bb.item_no
                                     AND pp.share_cd = bb.share_cd)
                      ORDER BY bb.item_no, bb.share_cd)
      LOOP
         pdist_item.dist_no := curdist.dist_no;
         pdist_item.dist_seq_no := curdist.dist_seq_no;
         pdist_item.item_no := curdist.item_no;
         pdist_item.share_cd := curdist.share_cd;
         PIPE ROW (pdist_item);
      END LOOP;
   END f_vpdist_perildtl_f_itemdtl01;

   FUNCTION f_vpdist_perildtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_item_type PIPELINED
   IS
      pdist_item   pdist_item_rec_type;
   BEGIN
      FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.item_no,
                             xx.share_cd
                        FROM giuw_itemds_dtl xx,
                             (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                              b.item_no, a.share_cd,
                                              c.trty_name
                                         FROM giuw_perilds_dtl a,
                                              giuw_itemperilds b,
                                              giis_dist_share c
                                        WHERE a.dist_no = p_dist_no
                                          AND a.line_cd = c.line_cd
                                          AND a.share_cd = c.share_cd
                                          AND a.dist_no = b.dist_no
                                          AND a.dist_seq_no = b.dist_seq_no
                                          AND a.peril_cd = b.peril_cd) yy
                       WHERE xx.dist_no = p_dist_no
                         AND xx.dist_no = yy.dist_no(+)
                         AND xx.dist_seq_no = yy.dist_seq_no(+)
                         AND xx.item_no = yy.item_no(+)
                         AND xx.share_cd = yy.share_cd(+)
                         AND NOT EXISTS (
                                SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                b.item_no, a.share_cd,
                                                c.trty_name
                                           FROM giuw_perilds_dtl a,
                                                giuw_itemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd
                                            AND b.dist_no = xx.dist_no
                                            AND b.dist_seq_no = xx.dist_seq_no
                                            AND b.item_no = xx.item_no
                                            AND b.peril_cd = a.peril_cd
                                            AND a.share_cd = xx.share_cd))
      LOOP
         pdist_item.dist_no := curdist.dist_no;
         pdist_item.dist_seq_no := curdist.dist_seq_no;
         pdist_item.item_no := curdist.item_no;
         pdist_item.share_cd := curdist.share_cd;
         PIPE ROW (pdist_item);
      END LOOP;
   END f_vpdist_perildtl_f_itemdtl02;

   FUNCTION f_vpdist_perildtl_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED
   IS
      politemperil   pdist_itemperil_rec_type;
   BEGIN
      FOR cur IN (SELECT a.dist_no, a.dist_seq_no, b.item_no, a.peril_cd,
                         a.share_cd, c.trty_name
                    FROM giuw_perilds_dtl a,
                         giuw_itemperilds b,
                         giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.line_cd = c.line_cd
                     AND a.share_cd = c.share_cd
                     AND a.dist_no = b.dist_no(+)
                     AND a.dist_seq_no = b.dist_seq_no(+)
                     AND a.peril_cd = b.peril_cd(+)
                     AND NOT EXISTS (
                            SELECT 1
                              FROM giuw_itemperilds_dtl x
                             WHERE x.dist_no = a.dist_no
                               AND x.dist_seq_no = a.dist_seq_no
                               AND x.item_no = b.item_no
                               AND x.peril_cd = b.peril_cd
                               AND x.share_cd = a.share_cd))
      LOOP
         politemperil.dist_no := cur.dist_no;
         politemperil.dist_seq_no := cur.dist_seq_no;
         politemperil.item_no := cur.item_no;
         politemperil.peril_cd := cur.peril_cd;
         politemperil.share_cd := cur.share_cd;
         PIPE ROW (politemperil);
      END LOOP;
   END f_vpdist_perildtl_f_itmpldtl01;

   FUNCTION f_vpdist_perildtl_f_itmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_itemperil_type PIPELINED
   IS
      politemperil   pdist_itemperil_rec_type;
   BEGIN
      FOR cur IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                         a.share_cd, a.dist_spct, a.dist_spct1
                    FROM giuw_itemperilds_dtl a, giuw_perilds_dtl b
                   WHERE a.dist_no = b.dist_no(+)
                     AND a.dist_seq_no = b.dist_seq_no(+)
                     AND a.share_cd = b.share_cd(+)
                     AND a.peril_cd = b.peril_cd(+)
                     AND a.dist_no = p_dist_no
                     AND NOT EXISTS (
                            SELECT 1
                              FROM giuw_perilds_dtl x
                             WHERE x.dist_no = a.dist_no
                               AND x.dist_seq_no = a.dist_seq_no
                               AND x.peril_cd = a.peril_cd
                               AND x.share_cd = a.share_cd))
      LOOP
         politemperil.dist_no := cur.dist_no;
         politemperil.dist_seq_no := cur.dist_seq_no;
         politemperil.item_no := cur.item_no;
         politemperil.peril_cd := cur.peril_cd;
         politemperil.share_cd := cur.share_cd;
         PIPE ROW (politemperil);
      END LOOP;
   END f_vpdist_perildtl_f_itmpldtl02;

   FUNCTION f_vpdist_perildtl_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED
   IS
      polperil   pdist_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.share_cd
                          FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                a.share_cd, c.trty_name
                                           FROM giuw_perilds_dtl a,
                                                giuw_itemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd) bb,
                               giuw_policyds cc
                         WHERE bb.dist_no = p_dist_no
                           AND bb.dist_no = cc.dist_no(+)
                           AND bb.dist_seq_no = cc.dist_seq_no(+)
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giuw_policyds_dtl pp
                                   WHERE pp.dist_no = bb.dist_no
                                     AND pp.dist_seq_no = bb.dist_seq_no
                                     AND pp.share_cd = bb.share_cd)
                      ORDER BY bb.dist_seq_no, bb.share_cd)
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.share_cd := curdist.share_cd;
         PIPE ROW (polperil);
      END LOOP;
   END f_vpdist_perildtl_f_poldtl01;

   FUNCTION f_vpdist_perildtl_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_polperil_type PIPELINED
   IS
      polperil   pdist_polperil_rec_type;
   BEGIN
      FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.share_cd
                        FROM giuw_policyds_dtl xx,
                             (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                              a.share_cd, c.trty_name
                                         FROM giuw_perilds_dtl a,
                                              giuw_itemperilds b,
                                              giis_dist_share c
                                        WHERE a.dist_no = p_dist_no
                                          AND a.line_cd = c.line_cd
                                          AND a.share_cd = c.share_cd
                                          AND a.dist_no = b.dist_no
                                          AND a.dist_seq_no = b.dist_seq_no
                                          AND a.peril_cd = b.peril_cd) yy
                       WHERE xx.dist_no = p_dist_no
                         AND xx.dist_no = yy.dist_no(+)
                         AND xx.dist_seq_no = yy.dist_seq_no(+)
                         AND xx.share_cd = yy.share_cd(+)
                         AND NOT EXISTS (
                                SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                b.item_no, a.share_cd,
                                                c.trty_name
                                           FROM giuw_perilds_dtl a,
                                                giuw_itemperilds b,
                                                giis_dist_share c
                                          WHERE a.dist_no = p_dist_no
                                            AND a.line_cd = c.line_cd
                                            AND a.share_cd = c.share_cd
                                            AND a.dist_no = b.dist_no
                                            AND a.dist_seq_no = b.dist_seq_no
                                            AND a.peril_cd = b.peril_cd
                                            AND b.dist_no = xx.dist_no
                                            AND b.dist_seq_no = xx.dist_seq_no
                                            AND b.peril_cd = a.peril_cd
                                            AND a.share_cd = xx.share_cd))
      LOOP
         polperil.dist_no := curdist.dist_no;
         polperil.dist_seq_no := curdist.dist_seq_no;
         polperil.share_cd := curdist.share_cd;
         PIPE ROW (polperil);
      END LOOP;
   END f_vpdist_perildtl_f_poldtl02;

/* ***************************************************************************************************************************************
        --- validating consistency of share % in One Risk Distribution - Working Distribution
     ************************************************************************************************************************************** */
   FUNCTION f_valconst_shr_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itemdtl_type PIPELINED
   IS
      orsk_item   diff_orsk_itemdtl_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                          b.dist_spct pol_dist_spct,
                          b.dist_spct1 pol_dist_spct1,
                          a.dist_spct item_dist_spct,
                          a.dist_spct1 item_dist_spct1,
                            NVL (b.dist_spct, 0)
                          - NVL (a.dist_spct, 0) diff_spct,
                            NVL (b.dist_spct1, 0)
                          - NVL (a.dist_spct1, 0) diff_spct1
                     FROM giuw_witemds_dtl a, giuw_wpolicyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.share_cd = a.share_cd
                      AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <>
                                                                             0
                              )
                          ))
      LOOP
         orsk_item.dist_no := dist.dist_no;
         orsk_item.dist_seq_no := dist.dist_seq_no;
         orsk_item.item_no := dist.item_no;
         orsk_item.share_cd := dist.share_cd;
         orsk_item.pol_dist_spct := dist.pol_dist_spct;
         orsk_item.pol_dist_spct1 := dist.pol_dist_spct1;
         orsk_item.item_dist_spct := dist.item_dist_spct;
         orsk_item.item_dist_spct1 := dist.item_dist_spct1;
         orsk_item.diff_spct := dist.diff_spct;
         orsk_item.diff_spct1 := dist.diff_spct1;
         PIPE ROW (orsk_item);
      END LOOP;
   END f_valconst_shr_witemdtl;

   FUNCTION f_valconst_shr_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itmpldtl_type PIPELINED
   IS
      orisk_itmperil   diff_orsk_itmpldtl_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                          b.dist_spct pol_dist_spct,
                          b.dist_spct1 pol_dist_spct1,
                          a.dist_spct itmperil_dist_spct,
                          a.dist_spct1 itmperil_dist_spct1,
                            NVL (a.dist_spct, 0)
                          - NVL (b.dist_spct, 0) diff_spct,
                            NVL (a.dist_spct1, 0)
                          - NVL (b.dist_spct1, 0) diff_spct1
                     FROM giuw_witemperilds_dtl a, giuw_wpolicyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.share_cd = a.share_cd
                      AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <>
                                                                             0
                              )
                          ))
      LOOP
         orisk_itmperil.dist_no := dist.dist_no;
         orisk_itmperil.dist_seq_no := dist.dist_seq_no;
         orisk_itmperil.item_no := dist.item_no;
         orisk_itmperil.share_cd := dist.share_cd;
         orisk_itmperil.pol_dist_spct := dist.pol_dist_spct;
         orisk_itmperil.pol_dist_spct1 := dist.pol_dist_spct1;
         orisk_itmperil.itmperil_dist_spct := dist.itmperil_dist_spct;
         orisk_itmperil.itmperil_dist_spct1 := dist.itmperil_dist_spct1;
         orisk_itmperil.diff_spct := dist.diff_spct;
         orisk_itmperil.diff_spct1 := dist.diff_spct1;
         PIPE ROW (orisk_itmperil);
      END LOOP;
   END f_valconst_shr_witmprldtl;

   FUNCTION f_valconst_shr_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_peril_type PIPELINED
   IS
      perildtl   diff_orsk_peril_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.peril_cd, b.share_cd,
                          b.dist_spct pol_dist_spct,
                          b.dist_spct1 pol_dist_spct1,
                          a.dist_spct peril_dist_spct,
                          a.dist_spct1 peril_dist_spct1,
                            NVL (a.dist_spct, 0)
                          - NVL (b.dist_spct, 0) diff_spct,
                            NVL (a.dist_spct1, 0)
                          - NVL (b.dist_spct1, 0) diff_spct1
                     FROM giuw_wperilds_dtl a, giuw_wpolicyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.share_cd = a.share_cd
                      AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <>
                                                                             0
                              )
                          ))
      LOOP
         perildtl.dist_no := dist.dist_no;
         perildtl.dist_seq_no := dist.dist_seq_no;
         perildtl.peril_cd := dist.peril_cd;
         perildtl.share_cd := dist.share_cd;
         perildtl.pol_dist_spct := dist.pol_dist_spct;
         perildtl.pol_dist_spct1 := dist.pol_dist_spct1;
         perildtl.peril_dist_spct := dist.peril_dist_spct;
         perildtl.peril_dist_spct1 := dist.peril_dist_spct1;
         perildtl.diff_spct := dist.diff_spct;
         perildtl.diff_spct1 := dist.diff_spct1;
         PIPE ROW (perildtl);
      END LOOP;
   END;

/* ***************************************************************************************************************************************
        --- validating consistency of share % in One Risk Distribution - Final Distribution Table
     ************************************************************************************************************************************** */
   FUNCTION f_valconst_shr_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itemdtl_type PIPELINED
   IS
      orsk_item   diff_orsk_itemdtl_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                          b.dist_spct pol_dist_spct,
                          b.dist_spct1 pol_dist_spct1,
                          a.dist_spct item_dist_spct,
                          a.dist_spct1 item_dist_spct1,
                            NVL (b.dist_spct, 0)
                          - NVL (a.dist_spct, 0) diff_spct,
                            NVL (b.dist_spct1, 0)
                          - NVL (a.dist_spct1, 0) diff_spct1
                     FROM giuw_itemds_dtl a, giuw_policyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.share_cd = a.share_cd
                      AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <>
                                                                             0
                              )
                          ))
      LOOP
         orsk_item.dist_no := dist.dist_no;
         orsk_item.dist_seq_no := dist.dist_seq_no;
         orsk_item.item_no := dist.item_no;
         orsk_item.share_cd := dist.share_cd;
         orsk_item.pol_dist_spct := dist.pol_dist_spct;
         orsk_item.pol_dist_spct1 := dist.pol_dist_spct1;
         orsk_item.item_dist_spct := dist.item_dist_spct;
         orsk_item.item_dist_spct1 := dist.item_dist_spct1;
         orsk_item.diff_spct := dist.diff_spct;
         orsk_item.diff_spct1 := dist.diff_spct1;
         PIPE ROW (orsk_item);
      END LOOP;
   END f_valconst_shr_f_itemdtl;

   FUNCTION f_valconst_shr_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_itmpldtl_type PIPELINED
   IS
      orisk_itmperil   diff_orsk_itmpldtl_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                          b.dist_spct pol_dist_spct,
                          b.dist_spct1 pol_dist_spct1,
                          a.dist_spct itmperil_dist_spct,
                          a.dist_spct1 itmperil_dist_spct1,
                            NVL (a.dist_spct, 0)
                          - NVL (b.dist_spct, 0) diff_spct,
                            NVL (a.dist_spct1, 0)
                          - NVL (b.dist_spct1, 0) diff_spct1
                     FROM giuw_itemperilds_dtl a, giuw_policyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.share_cd = a.share_cd
                      AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <>
                                                                             0
                              )
                          ))
      LOOP
         orisk_itmperil.dist_no := dist.dist_no;
         orisk_itmperil.dist_seq_no := dist.dist_seq_no;
         orisk_itmperil.item_no := dist.item_no;
         orisk_itmperil.share_cd := dist.share_cd;
         orisk_itmperil.pol_dist_spct := dist.pol_dist_spct;
         orisk_itmperil.pol_dist_spct1 := dist.pol_dist_spct1;
         orisk_itmperil.itmperil_dist_spct := dist.itmperil_dist_spct;
         orisk_itmperil.itmperil_dist_spct1 := dist.itmperil_dist_spct1;
         orisk_itmperil.diff_spct := dist.diff_spct;
         orisk_itmperil.diff_spct1 := dist.diff_spct1;
         PIPE ROW (orisk_itmperil);
      END LOOP;
   END f_valconst_shr_f_itmprldtl;

   FUNCTION f_valconst_shr_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN diff_orsk_peril_type PIPELINED
   IS
      perildtl   diff_orsk_peril_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.peril_cd, b.share_cd,
                          b.dist_spct pol_dist_spct,
                          b.dist_spct1 pol_dist_spct1,
                          a.dist_spct peril_dist_spct,
                          a.dist_spct1 peril_dist_spct1,
                            NVL (a.dist_spct, 0)
                          - NVL (b.dist_spct, 0) diff_spct,
                            NVL (a.dist_spct1, 0)
                          - NVL (b.dist_spct1, 0) diff_spct1
                     FROM giuw_perilds_dtl a, giuw_policyds_dtl b
                    WHERE 1 = 1
                      AND b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.share_cd = a.share_cd
                      AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                              )
                           OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <>
                                                                             0
                              )
                          ))
      LOOP
         perildtl.dist_no := dist.dist_no;
         perildtl.dist_seq_no := dist.dist_seq_no;
         perildtl.peril_cd := dist.peril_cd;
         perildtl.share_cd := dist.share_cd;
         perildtl.pol_dist_spct := dist.pol_dist_spct;
         perildtl.pol_dist_spct1 := dist.pol_dist_spct1;
         perildtl.peril_dist_spct := dist.peril_dist_spct;
         perildtl.peril_dist_spct1 := dist.peril_dist_spct1;
         perildtl.diff_spct := dist.diff_spct;
         perildtl.diff_spct1 := dist.diff_spct1;
         PIPE ROW (perildtl);
      END LOOP;
   END f_valconst_shr_f_perildtl;

/* ***************************************************************************************************************************************
        --- validating the amounts stored in Dist Tables if based on ITEMPERILDS_DTL --> working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_compt_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_type PIPELINED
   IS
      itmperil   itmperil_peril_rec_type;
   BEGIN
      FOR dist IN (SELECT x.dist_no, x.dist_seq_no, x.peril_cd, x.share_cd,
                          w.trty_name, x.computed_tsi itmperil_dist_tsi,
                          x.computed_prem itmperil_dist_prem,
                          y.dist_tsi peril_dist_tsi,
                          y.dist_prem peril_dist_prem,
                            NVL (x.computed_tsi, 0)
                          - NVL (y.dist_tsi, 0) diff_tsi,
                            NVL (x.computed_prem, 0)
                          - NVL (y.dist_prem, 0) diff_prem
                     FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                    a.peril_cd, a.share_cd,
                                    SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                    SUM (NVL (a.dist_prem, 0)) computed_prem
                               FROM giuw_witemperilds_dtl a, giis_peril b
                              WHERE a.line_cd = b.line_cd
                                AND a.peril_cd = b.peril_cd
                                AND a.dist_no = p_dist_no
                           GROUP BY a.line_cd,
                                    a.dist_no,
                                    a.dist_seq_no,
                                    a.peril_cd,
                                    a.share_cd) x,
                          giuw_wperilds_dtl y,
                          giis_dist_share w
                    WHERE 1 = 1
                      AND x.dist_no = p_dist_no
                      AND x.line_cd = w.line_cd
                      AND x.share_cd = w.share_cd
                      AND x.dist_no = y.dist_no(+)
                      AND x.dist_seq_no = y.dist_seq_no(+)
                      AND x.peril_cd = y.peril_cd(+)
                      AND x.share_cd = y.share_cd(+)
                      AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                           OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <>
                                                                             0
                          )
                   UNION
                   SELECT y.dist_no, y.dist_seq_no, y.peril_cd, y.share_cd,
                          w.trty_name, x.computed_tsi itmperil_dist_tsi,
                          x.computed_prem itmperil_dist_prem,
                          y.dist_tsi item_dist_tsi,
                          y.dist_prem item_dist_prem,
                            NVL (x.computed_tsi, 0)
                          - NVL (y.dist_tsi, 0) diff_tsi,
                            NVL (x.computed_prem, 0)
                          - NVL (y.dist_prem, 0) diff_prem
                     FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                    a.peril_cd, a.share_cd,
                                    SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                    SUM (NVL (a.dist_prem, 0)) computed_prem
                               FROM giuw_witemperilds_dtl a, giis_peril b
                              WHERE a.line_cd = b.line_cd
                                AND a.peril_cd = b.peril_cd
                                AND a.dist_no = p_dist_no
                           GROUP BY a.line_cd,
                                    a.dist_no,
                                    a.dist_seq_no,
                                    a.peril_cd,
                                    a.share_cd) x,
                          giuw_wperilds_dtl y,
                          giis_dist_share w
                    WHERE 1 = 1
                      AND y.dist_no = p_dist_no
                      AND y.line_cd = w.line_cd
                      AND y.share_cd = w.share_cd
                      AND y.dist_no = x.dist_no(+)
                      AND y.dist_seq_no = x.dist_seq_no(+)
                      AND y.peril_cd = x.peril_cd(+)
                      AND y.share_cd = x.share_cd(+)
                      AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                           OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <>
                                                                             0
                          ))
      LOOP
         itmperil.dist_no := dist.dist_no;
         itmperil.dist_seq_no := dist.dist_seq_no;
         itmperil.peril_cd := dist.peril_cd;
         itmperil.share_cd := dist.share_cd;
         itmperil.trty_name := dist.trty_name;
         itmperil.itmperil_tsi := dist.itmperil_dist_tsi;
         itmperil.itmperil_prem := dist.itmperil_dist_prem;
         itmperil.peril_tsi := dist.peril_dist_tsi;
         itmperil.peril_prem := dist.peril_dist_prem;
         itmperil.diff_tsi := dist.diff_tsi;
         itmperil.diff_prem := dist.diff_prem;
         PIPE ROW (itmperil);
      END LOOP;
   END f_val_compt_wperildtl;

   FUNCTION f_val_compt_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_policy_type PIPELINED
   IS
      politmperil   itmperil_policy_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, b.share_cd, c.trty_name,
                          a.dist_tsi policy_tsi, a.dist_prem policy_prem,
                          b.dist_tsi itmperil_tsi, b.dist_prem itmperil_prem,
                          NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                            NVL (a.dist_prem, 0)
                          - NVL (b.dist_prem, 0) diff_prem
                     FROM giuw_wpolicyds_dtl a,
                          (SELECT   x.line_cd, x.dist_no, x.dist_seq_no,
                                    x.share_cd,
                                    SUM (DECODE (y.peril_type,
                                                 'B', NVL (x.dist_tsi, 0),
                                                 0
                                                )
                                        ) dist_tsi,
                                    SUM (NVL (x.dist_prem, 0)) dist_prem
                               FROM giuw_witemperilds_dtl x, giis_peril y
                              WHERE x.line_cd = y.line_cd
                                AND x.peril_cd = y.peril_cd
                                AND x.dist_no = p_dist_no
                           GROUP BY x.line_cd,
                                    x.dist_no,
                                    x.dist_seq_no,
                                    x.share_cd) b,
                          giis_dist_share c
                    WHERE b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no(+)
                      AND b.dist_seq_no = a.dist_seq_no(+)
                      AND b.share_cd = a.share_cd(+)
                      AND b.line_cd = c.line_cd(+)
                      AND b.share_cd = c.share_cd(+)
                      AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                           OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                          )
                   UNION
                   SELECT a.dist_no, a.dist_seq_no, a.share_cd, c.trty_name,
                          a.dist_tsi pol_dist_tsi, a.dist_prem pol_dist_prem,
                          b.dist_tsi itmperl_dist_tsi,
                          b.dist_prem itmperl_dist_prem,
                          NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                            NVL (a.dist_prem, 0)
                          - NVL (b.dist_prem, 0) diff_prem
                     FROM giuw_wpolicyds_dtl a,
                          (SELECT   x.line_cd, x.dist_no, x.dist_seq_no,
                                    x.share_cd,
                                    SUM (DECODE (y.peril_type,
                                                 'B', NVL (x.dist_tsi, 0),
                                                 0
                                                )
                                        ) dist_tsi,
                                    SUM (NVL (x.dist_prem, 0)) dist_prem
                               FROM giuw_witemperilds_dtl x, giis_peril y
                              WHERE x.line_cd = y.line_cd
                                AND x.peril_cd = y.peril_cd
                                AND x.dist_no = p_dist_no
                           GROUP BY x.line_cd,
                                    x.dist_no,
                                    x.dist_seq_no,
                                    x.share_cd) b,
                          giis_dist_share c
                    WHERE a.dist_no = p_dist_no
                      AND a.dist_no = b.dist_no(+)
                      AND a.dist_seq_no = b.dist_seq_no(+)
                      AND a.share_cd = b.share_cd(+)
                      AND a.line_cd = c.line_cd(+)
                      AND a.share_cd = c.share_cd(+)
                      AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                           OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                          ))
      LOOP
         politmperil.dist_no := dist.dist_no;
         politmperil.dist_seq_no := dist.dist_seq_no;
         politmperil.share_cd := dist.share_cd;
         politmperil.trty_name := dist.trty_name;
         politmperil.itmperil_tsi := dist.itmperil_tsi;
         politmperil.itmperil_prem := dist.itmperil_prem;
         politmperil.policy_tsi := dist.policy_tsi;
         politmperil.policy_prem := dist.policy_prem;
         politmperil.diff_tsi := dist.diff_tsi;
         politmperil.diff_prem := dist.diff_prem;
         PIPE ROW (politmperil);
      END LOOP;
   END f_val_compt_wpoldtl;

   FUNCTION f_val_compt_wtemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_item_type PIPELINED
   IS
      item_itmperil   itmperil_item_rec_type;
   BEGIN
      FOR dist IN
         (SELECT x.dist_no, x.dist_seq_no, x.item_no, x.share_cd,
                 w.trty_name, x.computed_tsi itmperil_tsi,
                 x.computed_prem itmperil_prem, y.dist_tsi item_tsi,
                 y.dist_prem item_prem,
                 NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                 NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
            FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                           a.share_cd,
                           SUM (DECODE (b.peril_type,
                                        'B', NVL (a.dist_tsi, 0),
                                        0
                                       )
                               ) computed_tsi,
                           SUM (NVL (a.dist_prem, 0)) computed_prem
                      FROM giuw_witemperilds_dtl a, giis_peril b
                     WHERE a.line_cd = b.line_cd
                       AND a.peril_cd = b.peril_cd
                       AND a.dist_no = p_dist_no
                  GROUP BY a.line_cd,
                           a.dist_no,
                           a.dist_seq_no,
                           a.item_no,
                           a.share_cd) x,
                 giuw_witemds_dtl y,
                 giis_dist_share w
           WHERE 1 = 1
             AND x.line_cd = w.line_cd
             AND x.share_cd = w.share_cd
             AND x.dist_no = p_dist_no
             AND x.dist_no = y.dist_no(+)
             AND x.dist_seq_no = y.dist_seq_no(+)
             AND x.item_no = y.item_no(+)
             AND x.share_cd = y.share_cd(+)
             AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                  OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.share_cd, w.trty_name,
                 x.computed_tsi, x.computed_prem, y.dist_tsi, y.dist_prem,
                 NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                 NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
            FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                           a.share_cd,
                           SUM (DECODE (b.peril_type,
                                        'B', NVL (a.dist_tsi, 0),
                                        0
                                       )
                               ) computed_tsi,
                           SUM (NVL (a.dist_prem, 0)) computed_prem
                      FROM giuw_witemperilds_dtl a, giis_peril b
                     WHERE a.line_cd = b.line_cd
                       AND a.peril_cd = b.peril_cd
                       AND a.dist_no = p_dist_no
                  GROUP BY a.line_cd,
                           a.dist_no,
                           a.dist_seq_no,
                           a.item_no,
                           a.share_cd) x,
                 giuw_witemds_dtl y,
                 giis_dist_share w
           WHERE 1 = 1
             AND y.dist_no = p_dist_no
             AND y.line_cd = w.line_cd
             AND y.share_cd = w.share_cd
             AND y.dist_no = x.dist_no(+)
             AND y.dist_seq_no = x.dist_seq_no(+)
             AND y.item_no = x.item_no(+)
             AND y.share_cd = x.share_cd(+)
             AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                  OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                 ))
      LOOP
         item_itmperil.dist_no := dist.dist_no;
         item_itmperil.dist_seq_no := dist.dist_seq_no;
         item_itmperil.item_no := dist.item_no;
         item_itmperil.share_cd := dist.share_cd;
         item_itmperil.trty_name := dist.trty_name;
         item_itmperil.itmperil_tsi := dist.itmperil_tsi;
         item_itmperil.itmperil_prem := dist.itmperil_prem;
         item_itmperil.item_tsi := dist.item_tsi;
         item_itmperil.item_prem := dist.item_prem;
         item_itmperil.diff_tsi := dist.diff_tsi;
         item_itmperil.diff_prem := dist.diff_prem;
         PIPE ROW (item_itmperil);
      END LOOP;
   END f_val_compt_wtemdtl;

/* ***************************************************************************************************************************************
        --- validating the amounts stored in Dist Tables if based on ITEMPERILDS_DTL --> final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_val_compt_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_item_type PIPELINED
   IS
      item_itmperil   itmperil_item_rec_type;
   BEGIN
      FOR dist IN
         (SELECT x.dist_no, x.dist_seq_no, x.item_no, x.share_cd,
                 w.trty_name, x.computed_tsi itmperil_tsi,
                 x.computed_prem itmperil_prem, y.dist_tsi item_tsi,
                 y.dist_prem item_prem,
                 NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                 NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
            FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                           a.share_cd,
                           SUM (DECODE (b.peril_type,
                                        'B', NVL (a.dist_tsi, 0),
                                        0
                                       )
                               ) computed_tsi,
                           SUM (NVL (a.dist_prem, 0)) computed_prem
                      FROM giuw_itemperilds_dtl a, giis_peril b
                     WHERE a.line_cd = b.line_cd
                       AND a.peril_cd = b.peril_cd
                       AND a.dist_no = p_dist_no
                  GROUP BY a.line_cd,
                           a.dist_no,
                           a.dist_seq_no,
                           a.item_no,
                           a.share_cd) x,
                 giuw_itemds_dtl y,
                 giis_dist_share w
           WHERE 1 = 1
             AND x.line_cd = w.line_cd
             AND x.share_cd = w.share_cd
             AND x.dist_no = p_dist_no
             AND x.dist_no = y.dist_no(+)
             AND x.dist_seq_no = y.dist_seq_no(+)
             AND x.item_no = y.item_no(+)
             AND x.share_cd = y.share_cd(+)
             AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                  OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.share_cd, w.trty_name,
                 x.computed_tsi, x.computed_prem, y.dist_tsi, y.dist_prem,
                 NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                 NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
            FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                           a.share_cd,
                           SUM (DECODE (b.peril_type,
                                        'B', NVL (a.dist_tsi, 0),
                                        0
                                       )
                               ) computed_tsi,
                           SUM (NVL (a.dist_prem, 0)) computed_prem
                      FROM giuw_itemperilds_dtl a, giis_peril b
                     WHERE a.line_cd = b.line_cd
                       AND a.peril_cd = b.peril_cd
                       AND a.dist_no = p_dist_no
                  GROUP BY a.line_cd,
                           a.dist_no,
                           a.dist_seq_no,
                           a.item_no,
                           a.share_cd) x,
                 giuw_itemds_dtl y,
                 giis_dist_share w
           WHERE 1 = 1
             AND y.dist_no = p_dist_no
             AND y.line_cd = w.line_cd
             AND y.share_cd = w.share_cd
             AND y.dist_no = x.dist_no(+)
             AND y.dist_seq_no = x.dist_seq_no(+)
             AND y.item_no = x.item_no(+)
             AND y.share_cd = x.share_cd(+)
             AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                  OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                 ))
      LOOP
         item_itmperil.dist_no := dist.dist_no;
         item_itmperil.dist_seq_no := dist.dist_seq_no;
         item_itmperil.item_no := dist.item_no;
         item_itmperil.share_cd := dist.share_cd;
         item_itmperil.trty_name := dist.trty_name;
         item_itmperil.itmperil_tsi := dist.itmperil_tsi;
         item_itmperil.itmperil_prem := dist.itmperil_prem;
         item_itmperil.item_tsi := dist.item_tsi;
         item_itmperil.item_prem := dist.item_prem;
         item_itmperil.diff_tsi := dist.diff_tsi;
         item_itmperil.diff_prem := dist.diff_prem;
         PIPE ROW (item_itmperil);
      END LOOP;
   END f_val_compt_f_itemdtl;

   FUNCTION f_val_compt_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_peril_type PIPELINED
   IS
      itmperil   itmperil_peril_rec_type;
   BEGIN
      FOR dist IN (SELECT x.dist_no, x.dist_seq_no, x.peril_cd, x.share_cd,
                          w.trty_name, x.computed_tsi itmperil_dist_tsi,
                          x.computed_prem itmperil_dist_prem,
                          y.dist_tsi peril_dist_tsi,
                          y.dist_prem peril_dist_prem,
                            NVL (x.computed_tsi, 0)
                          - NVL (y.dist_tsi, 0) diff_tsi,
                            NVL (x.computed_prem, 0)
                          - NVL (y.dist_prem, 0) diff_prem
                     FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                    a.peril_cd, a.share_cd,
                                    SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                    SUM (NVL (a.dist_prem, 0)) computed_prem
                               FROM giuw_itemperilds_dtl a, giis_peril b
                              WHERE a.line_cd = b.line_cd
                                AND a.peril_cd = b.peril_cd
                                AND a.dist_no = p_dist_no
                           GROUP BY a.line_cd,
                                    a.dist_no,
                                    a.dist_seq_no,
                                    a.peril_cd,
                                    a.share_cd) x,
                          giuw_perilds_dtl y,
                          giis_dist_share w
                    WHERE 1 = 1
                      AND x.dist_no = p_dist_no
                      AND x.line_cd = w.line_cd
                      AND x.share_cd = w.share_cd
                      AND x.dist_no = y.dist_no(+)
                      AND x.dist_seq_no = y.dist_seq_no(+)
                      AND x.peril_cd = y.peril_cd(+)
                      AND x.share_cd = y.share_cd(+)
                      AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                           OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <>
                                                                             0
                          )
                   UNION
                   SELECT y.dist_no, y.dist_seq_no, y.peril_cd, y.share_cd,
                          w.trty_name, x.computed_tsi itmperil_dist_tsi,
                          x.computed_prem itmperil_dist_prem,
                          y.dist_tsi item_dist_tsi,
                          y.dist_prem item_dist_prem,
                            NVL (x.computed_tsi, 0)
                          - NVL (y.dist_tsi, 0) diff_tsi,
                            NVL (x.computed_prem, 0)
                          - NVL (y.dist_prem, 0) diff_prem
                     FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                    a.peril_cd, a.share_cd,
                                    SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                    SUM (NVL (a.dist_prem, 0)) computed_prem
                               FROM giuw_itemperilds_dtl a, giis_peril b
                              WHERE a.line_cd = b.line_cd
                                AND a.peril_cd = b.peril_cd
                                AND a.dist_no = p_dist_no
                           GROUP BY a.line_cd,
                                    a.dist_no,
                                    a.dist_seq_no,
                                    a.peril_cd,
                                    a.share_cd) x,
                          giuw_perilds_dtl y,
                          giis_dist_share w
                    WHERE 1 = 1
                      AND y.dist_no = p_dist_no
                      AND y.line_cd = w.line_cd
                      AND y.share_cd = w.share_cd
                      AND y.dist_no = x.dist_no(+)
                      AND y.dist_seq_no = x.dist_seq_no(+)
                      AND y.peril_cd = x.peril_cd(+)
                      AND y.share_cd = x.share_cd(+)
                      AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                           OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <>
                                                                             0
                          ))
      LOOP
         itmperil.dist_no := dist.dist_no;
         itmperil.dist_seq_no := dist.dist_seq_no;
         itmperil.peril_cd := dist.peril_cd;
         itmperil.share_cd := dist.share_cd;
         itmperil.trty_name := dist.trty_name;
         itmperil.itmperil_tsi := dist.itmperil_dist_tsi;
         itmperil.itmperil_prem := dist.itmperil_dist_prem;
         itmperil.peril_tsi := dist.peril_dist_tsi;
         itmperil.peril_prem := dist.peril_dist_prem;
         itmperil.diff_tsi := dist.diff_tsi;
         itmperil.diff_prem := dist.diff_prem;
         PIPE ROW (itmperil);
      END LOOP;
   END f_val_compt_f_perildtl;

   FUNCTION f_val_compt_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_policy_type PIPELINED
   IS
      politmperil   itmperil_policy_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, b.share_cd, c.trty_name,
                          a.dist_tsi policy_tsi, a.dist_prem policy_prem,
                          b.dist_tsi itmperil_tsi, b.dist_prem itmperil_prem,
                          NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                            NVL (a.dist_prem, 0)
                          - NVL (b.dist_prem, 0) diff_prem
                     FROM giuw_policyds_dtl a,
                          (SELECT   x.line_cd, x.dist_no, x.dist_seq_no,
                                    x.share_cd,
                                    SUM (DECODE (y.peril_type,
                                                 'B', NVL (x.dist_tsi, 0),
                                                 0
                                                )
                                        ) dist_tsi,
                                    SUM (NVL (x.dist_prem, 0)) dist_prem
                               FROM giuw_itemperilds_dtl x, giis_peril y
                              WHERE x.line_cd = y.line_cd
                                AND x.peril_cd = y.peril_cd
                                AND x.dist_no = p_dist_no
                           GROUP BY x.line_cd,
                                    x.dist_no,
                                    x.dist_seq_no,
                                    x.share_cd) b,
                          giis_dist_share c
                    WHERE b.dist_no = p_dist_no
                      AND b.dist_no = a.dist_no(+)
                      AND b.dist_seq_no = a.dist_seq_no(+)
                      AND b.share_cd = a.share_cd(+)
                      AND b.line_cd = c.line_cd(+)
                      AND b.share_cd = c.share_cd(+)
                      AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                           OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                          )
                   UNION
                   SELECT a.dist_no, a.dist_seq_no, a.share_cd, c.trty_name,
                          a.dist_tsi pol_dist_tsi, a.dist_prem pol_dist_prem,
                          b.dist_tsi itmperl_dist_tsi,
                          b.dist_prem itmperl_dist_prem,
                          NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                            NVL (a.dist_prem, 0)
                          - NVL (b.dist_prem, 0) diff_prem
                     FROM giuw_policyds_dtl a,
                          (SELECT   x.line_cd, x.dist_no, x.dist_seq_no,
                                    x.share_cd,
                                    SUM (DECODE (y.peril_type,
                                                 'B', NVL (x.dist_tsi, 0),
                                                 0
                                                )
                                        ) dist_tsi,
                                    SUM (NVL (x.dist_prem, 0)) dist_prem
                               FROM giuw_itemperilds_dtl x, giis_peril y
                              WHERE x.line_cd = y.line_cd
                                AND x.peril_cd = y.peril_cd
                                AND x.dist_no = p_dist_no
                           GROUP BY x.line_cd,
                                    x.dist_no,
                                    x.dist_seq_no,
                                    x.share_cd) b,
                          giis_dist_share c
                    WHERE a.dist_no = p_dist_no
                      AND a.dist_no = b.dist_no(+)
                      AND a.dist_seq_no = b.dist_seq_no(+)
                      AND a.share_cd = b.share_cd(+)
                      AND a.line_cd = c.line_cd(+)
                      AND a.share_cd = c.share_cd(+)
                      AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                           OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                          ))
      LOOP
         politmperil.dist_no := dist.dist_no;
         politmperil.dist_seq_no := dist.dist_seq_no;
         politmperil.share_cd := dist.share_cd;
         politmperil.trty_name := dist.trty_name;
         politmperil.itmperil_tsi := dist.itmperil_tsi;
         politmperil.itmperil_prem := dist.itmperil_prem;
         politmperil.policy_tsi := dist.policy_tsi;
         politmperil.policy_prem := dist.policy_prem;
         politmperil.diff_tsi := dist.diff_tsi;
         politmperil.diff_prem := dist.diff_prem;
         PIPE ROW (politmperil);
      END LOOP;
   END f_val_compt_f_poldtl;

/* ***************************************************************************************************************************************
        --- validating the stored amounts in the distribution table against manual computation - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_orsk_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_comp_type PIPELINED
   IS
      itmperil_comp   itmperil_comp_rec_type;
      v_tol_discrep   giuw_pol_dist.tsi_amt%TYPE   := 0.05;
   BEGIN
      FOR cur IN
         (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd, a.share_cd,
                 a.dist_spct pol_dist_spct, a.dist_spct1 pol_dist_spct1,
                 a.computed_tsi, a.computed_prem,
                 b.dist_spct itmperil_dist_spct,
                 b.dist_spct1 itmperil_dist_spct1,
                 b.dist_tsi itmperil_dist_tsi,
                 b.dist_prem itmperil_dist_prem,
                 NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) diff_dist_spct,
                 NVL (a.dist_spct1, 0)
                 - NVL (b.dist_spct1, 0) diff_dist_spct1,
                 NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                         x.share_cd, x.dist_spct, x.dist_spct1,
                         ROUND (  NVL (y.tsi_amt, 0)
                                * ROUND (NVL (x.dist_spct, 0), 9)
                                / 100,
                                2
                               ) computed_tsi,
                         (ROUND (  NVL (y.prem_amt, 0)
                                 * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                   'Y', NVL (x.dist_spct1, 0),
                                                   NVL (x.dist_spct, 0)
                                                  )
                                          ),
                                          9
                                         )
                                 / 100,
                                 2
                                )
                         ) computed_prem
                    FROM giuw_wpolicyds_dtl x, giuw_witemperilds y
                   WHERE x.dist_no = p_dist_no
                     AND x.dist_no = y.dist_no
                     AND x.dist_seq_no = y.dist_seq_no) a,
                 giuw_witemperilds_dtl b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.item_no = b.item_no(+)
             AND a.peril_cd = b.peril_cd(+)
             AND a.share_cd = b.share_cd(+)
             AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <> 0)
                  OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <> 0)
                  OR (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                     )
                  OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                     )
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd, y.share_cd,
                 0 pol_distspct, 0 pol_distspct1, 0 computed_tsi,
                 0 computed_prem, y.dist_spct itmperil_distspct,
                 y.dist_spct1 itmperil_distspct1, y.dist_tsi itmperil_disttsi,
                 y.dist_prem itmperil_distprem,
                 0 - NVL (y.dist_spct, 0) diff_dist_spct,
                 0 - NVL (y.dist_spct1, 0) diff_dist_spct1,
                 0 - NVL (y.dist_tsi, 0) diff_tsi,
                 0 - NVL (y.dist_prem, 0) diff_prem
            FROM giuw_wpolicyds_dtl x, giuw_witemperilds_dtl y
           WHERE y.dist_no = p_dist_no
             AND x.dist_no(+) = y.dist_no
             AND x.dist_seq_no(+) = y.dist_seq_no
             AND x.share_cd(+) = y.share_cd
             AND NOT EXISTS (
                    SELECT 1
                      FROM giuw_wpolicyds_dtl p
                     WHERE p.dist_no = y.dist_no
                       AND p.dist_seq_no = y.dist_seq_no
                       AND p.share_cd = y.share_cd))
      LOOP
         itmperil_comp.dist_no := cur.dist_no;
         itmperil_comp.dist_seq_no := cur.dist_seq_no;
         itmperil_comp.item_no := cur.item_no;
         itmperil_comp.perl_cd := cur.peril_cd;
         itmperil_comp.share_cd := cur.share_cd;
         itmperil_comp.pol_dist_spct := cur.pol_dist_spct;
         itmperil_comp.pol_dist_spct1 := cur.pol_dist_spct1;
         itmperil_comp.computed_tsi := cur.computed_tsi;
         itmperil_comp.computed_prem := cur.computed_prem;
         itmperil_comp.itmperil_dist_spct := cur.itmperil_dist_spct;
         itmperil_comp.itmperil_dist_spct1 := cur.itmperil_dist_spct1;
         itmperil_comp.itmperil_dist_tsi := cur.itmperil_dist_tsi;
         itmperil_comp.itmperil_dist_prem := cur.itmperil_dist_prem;
         itmperil_comp.diff_dist_spct := cur.diff_dist_spct;
         itmperil_comp.diff_dist_spct1 := cur.diff_dist_spct1;
         itmperil_comp.diff_tsi := cur.diff_tsi;
         itmperil_comp.diff_prem := cur.diff_prem;
         PIPE ROW (itmperil_comp);
      END LOOP;
   END f_valcnt_orsk_witmprldtl;

   FUNCTION f_valcnt_orsk_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN policyc_comp_type PIPELINED
   IS
      policyc_comp    policyc_comp_rec_type;
      v_tol_discrep   giuw_pol_dist.tsi_amt%TYPE   := 1;
   BEGIN
      FOR dist IN
         (SELECT a.dist_no, a.dist_seq_no, c.trty_name, c.share_cd,
                 b.dist_spct, b.dist_tsi, b.dist_prem,
                 ROUND (  NVL (a.tsi_amt, 0)
                        * ROUND (NVL (b.dist_spct, 0), 9)
                        / 100,
                        2
                       ) computed_tsi,
                 ROUND
                     (  NVL (a.prem_amt, 0)
                      * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                        'Y', NVL (b.dist_spct1, 0),
                                        NVL (b.dist_spct, 0)
                                       )
                               ),
                               9
                              )
                      / 100,
                      2
                     ) computed_prem,
                   NVL (b.dist_tsi, 0)
                 - ROUND (  NVL (a.tsi_amt, 0)
                          * ROUND (NVL (b.dist_spct, 0), 9)
                          / 100,
                          2
                         ) diff_tsi,
                   NVL (b.dist_prem, 0)
                 - ROUND (  NVL (a.prem_amt, 0)
                          * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                            'Y', NVL (b.dist_spct1, 0),
                                            NVL (b.dist_spct, 0)
                                           )
                                   ),
                                   9
                                  )
                          / 100,
                          2
                         ) diff_prem,
                   NVL (b.dist_spct, 0)
                 - ROUND (NVL (b.dist_spct, 0), 9) diff_spct,
                   NVL (b.dist_spct1, 0)
                 - ROUND (NVL (b.dist_spct1, 0), 9) diff_spct1
            FROM giuw_wpolicyds a, giuw_wpolicyds_dtl b, giis_dist_share c
           WHERE a.dist_no = b.dist_no
             AND a.dist_seq_no = b.dist_seq_no
             AND b.line_cd = c.line_cd
             AND b.share_cd = c.share_cd
             AND a.dist_no = p_dist_no
             AND (   (NVL (b.dist_spct, 0) - ROUND (NVL (b.dist_spct, 0), 9) <>
                                                                             0
                     )
                  OR (NVL (b.dist_spct1, 0) - ROUND (NVL (b.dist_spct1, 0), 9) <>
                                                                             0
                     )
                  OR (ABS (  NVL (b.dist_tsi, 0)
                           - ROUND (  NVL (a.tsi_amt, 0)
                                    * ROUND (NVL (b.dist_spct, 0), 9)
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                  OR (ABS (  NVL (b.dist_prem, 0)
                           - ROUND (  NVL (a.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (b.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (b.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                 ))
      LOOP
         policyc_comp.dist_no := dist.dist_no;
         policyc_comp.dist_seq_no := dist.dist_seq_no;
         policyc_comp.share_cd := dist.share_cd;
         policyc_comp.trty_name := dist.trty_name;
         policyc_comp.dist_spct := dist.dist_spct;
         policyc_comp.dist_tsi := dist.dist_tsi;
         policyc_comp.dist_prem := dist.dist_prem;
         policyc_comp.computed_tsi := dist.computed_tsi;
         policyc_comp.computed_prem := dist.computed_prem;
         policyc_comp.diff_tsi := dist.diff_tsi;
         policyc_comp.diff_prem := dist.diff_prem;
         policyc_comp.diff_spct := dist.diff_spct;
         policyc_comp.diff_spct1 := dist.diff_spct1;
         PIPE ROW (policyc_comp);
      END LOOP;
   END f_valcnt_orsk_wpoldtl;

/* ***************************************************************************************************************************************
        --- validating the stored amounts in the distribution table against manual computation -  final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_orsk_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_comp_type PIPELINED
   IS
      itmperil_comp   itmperil_comp_rec_type;
      v_tol_discrep   giuw_pol_dist.tsi_amt%TYPE   := 0.05;
   BEGIN
      FOR cur IN
         (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd, a.share_cd,
                 a.dist_spct pol_dist_spct, a.dist_spct1 pol_dist_spct1,
                 a.computed_tsi, a.computed_prem,
                 b.dist_spct itmperil_dist_spct,
                 b.dist_spct1 itmperil_dist_spct1,
                 b.dist_tsi itmperil_dist_tsi,
                 b.dist_prem itmperil_dist_prem,
                 NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) diff_dist_spct,
                 NVL (a.dist_spct1, 0)
                 - NVL (b.dist_spct1, 0) diff_dist_spct1,
                 NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                         x.share_cd, x.dist_spct, x.dist_spct1,
                         ROUND (  NVL (y.tsi_amt, 0)
                                * ROUND (NVL (x.dist_spct, 0), 9)
                                / 100,
                                2
                               ) computed_tsi,
                         (ROUND (  NVL (y.prem_amt, 0)
                                 * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                   'Y', NVL (x.dist_spct1, 0),
                                                   NVL (x.dist_spct, 0)
                                                  )
                                          ),
                                          9
                                         )
                                 / 100,
                                 2
                                )
                         ) computed_prem
                    FROM giuw_policyds_dtl x, giuw_itemperilds y
                   WHERE x.dist_no = p_dist_no
                     AND x.dist_no = y.dist_no
                     AND x.dist_seq_no = y.dist_seq_no) a,
                 giuw_itemperilds_dtl b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.item_no = b.item_no(+)
             AND a.peril_cd = b.peril_cd(+)
             AND a.share_cd = b.share_cd(+)
             AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <> 0)
                  OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <> 0)
                  OR (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                     )
                  OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                     )
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd, y.share_cd,
                 0 pol_distspct, 0 pol_distspct1, 0 computed_tsi,
                 0 computed_prem, y.dist_spct itmperil_distspct,
                 y.dist_spct1 itmperil_distspct1, y.dist_tsi itmperil_disttsi,
                 y.dist_prem itmperil_distprem,
                 0 - NVL (y.dist_spct, 0) diff_dist_spct,
                 0 - NVL (y.dist_spct1, 0) diff_dist_spct1,
                 0 - NVL (y.dist_tsi, 0) diff_tsi,
                 0 - NVL (y.dist_prem, 0) diff_prem
            FROM giuw_policyds_dtl x, giuw_itemperilds_dtl y
           WHERE y.dist_no = p_dist_no
             AND x.dist_no(+) = y.dist_no
             AND x.dist_seq_no(+) = y.dist_seq_no
             AND x.share_cd(+) = y.share_cd
             AND NOT EXISTS (
                    SELECT 1
                      FROM giuw_policyds_dtl p
                     WHERE p.dist_no = y.dist_no
                       AND p.dist_seq_no = y.dist_seq_no
                       AND p.share_cd = y.share_cd))
      LOOP
         itmperil_comp.dist_no := cur.dist_no;
         itmperil_comp.dist_seq_no := cur.dist_seq_no;
         itmperil_comp.item_no := cur.item_no;
         itmperil_comp.perl_cd := cur.peril_cd;
         itmperil_comp.share_cd := cur.share_cd;
         itmperil_comp.pol_dist_spct := cur.pol_dist_spct;
         itmperil_comp.pol_dist_spct1 := cur.pol_dist_spct1;
         itmperil_comp.computed_tsi := cur.computed_tsi;
         itmperil_comp.computed_prem := cur.computed_prem;
         itmperil_comp.itmperil_dist_spct := cur.itmperil_dist_spct;
         itmperil_comp.itmperil_dist_spct1 := cur.itmperil_dist_spct1;
         itmperil_comp.itmperil_dist_tsi := cur.itmperil_dist_tsi;
         itmperil_comp.itmperil_dist_prem := cur.itmperil_dist_prem;
         itmperil_comp.diff_dist_spct := cur.diff_dist_spct;
         itmperil_comp.diff_dist_spct1 := cur.diff_dist_spct1;
         itmperil_comp.diff_tsi := cur.diff_tsi;
         itmperil_comp.diff_prem := cur.diff_prem;
         PIPE ROW (itmperil_comp);
      END LOOP;
   END f_valcnt_orsk_f_itmprldtl;

   FUNCTION f_valcnt_orsk_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN policyc_comp_type PIPELINED
   IS
      policyc_comp    policyc_comp_rec_type;
      v_tol_discrep   giuw_pol_dist.tsi_amt%TYPE   := 1;
   BEGIN
      FOR dist IN
         (SELECT a.dist_no, a.dist_seq_no, c.trty_name, c.share_cd,
                 b.dist_spct, b.dist_tsi, b.dist_prem,
                 ROUND (  NVL (a.tsi_amt, 0)
                        * ROUND (NVL (b.dist_spct, 0), 9)
                        / 100,
                        2
                       ) computed_tsi,
                 ROUND
                     (  NVL (a.prem_amt, 0)
                      * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                        'Y', NVL (b.dist_spct1, 0),
                                        NVL (b.dist_spct, 0)
                                       )
                               ),
                               9
                              )
                      / 100,
                      2
                     ) computed_prem,
                   NVL (b.dist_tsi, 0)
                 - ROUND (  NVL (a.tsi_amt, 0)
                          * ROUND (NVL (b.dist_spct, 0), 9)
                          / 100,
                          2
                         ) diff_tsi,
                   NVL (b.dist_prem, 0)
                 - ROUND (  NVL (a.prem_amt, 0)
                          * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                            'Y', NVL (b.dist_spct1, 0),
                                            NVL (b.dist_spct, 0)
                                           )
                                   ),
                                   9
                                  )
                          / 100,
                          2
                         ) diff_prem,
                   NVL (b.dist_spct, 0)
                 - ROUND (NVL (b.dist_spct, 0), 9) diff_spct,
                   NVL (b.dist_spct1, 0)
                 - ROUND (NVL (b.dist_spct1, 0), 9) diff_spct1
            FROM giuw_policyds a, giuw_policyds_dtl b, giis_dist_share c
           WHERE a.dist_no = b.dist_no
             AND a.dist_seq_no = b.dist_seq_no
             AND b.line_cd = c.line_cd
             AND b.share_cd = c.share_cd
             AND a.dist_no = p_dist_no
             AND (   (NVL (b.dist_spct, 0) - ROUND (NVL (b.dist_spct, 0), 9) <>
                                                                             0
                     )
                  OR (NVL (b.dist_spct1, 0) - ROUND (NVL (b.dist_spct1, 0), 9) <>
                                                                             0
                     )
                  OR (ABS (  NVL (b.dist_tsi, 0)
                           - ROUND (  NVL (a.tsi_amt, 0)
                                    * ROUND (NVL (b.dist_spct, 0), 9)
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                  OR (ABS (  NVL (b.dist_prem, 0)
                           - ROUND (  NVL (a.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (b.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (b.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                 ))
      LOOP
         policyc_comp.dist_no := dist.dist_no;
         policyc_comp.dist_seq_no := dist.dist_seq_no;
         policyc_comp.share_cd := dist.share_cd;
         policyc_comp.trty_name := dist.trty_name;
         policyc_comp.dist_spct := dist.dist_spct;
         policyc_comp.dist_tsi := dist.dist_tsi;
         policyc_comp.dist_prem := dist.dist_prem;
         policyc_comp.computed_tsi := dist.computed_tsi;
         policyc_comp.computed_prem := dist.computed_prem;
         policyc_comp.diff_tsi := dist.diff_tsi;
         policyc_comp.diff_prem := dist.diff_prem;
         policyc_comp.diff_spct := dist.diff_spct;
         policyc_comp.diff_spct1 := dist.diff_spct1;
         PIPE ROW (policyc_comp);
      END LOOP;
   END f_valcnt_orsk_f_poldtl;

   FUNCTION f_valcnt_pdist_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN itmperil_comp_perild_type PIPELINED
   IS
      comp_perildist   itmperil_comp_perild_rec_type;
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE    := 0.05;
   BEGIN
      FOR cur IN
         (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd, a.share_cd,
                 a.dist_spct peril_dist_spct, a.dist_spct1 peril_dist_spct1,
                 a.computed_tsi, a.computed_prem,
                 b.dist_spct itmperil_dist_spct,
                 b.dist_spct1 itmperil_dist_spct1,
                 b.dist_tsi itmperil_dist_tsi,
                 b.dist_prem itmperil_dist_prem,
                 NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) diff_dist_spct,
                 NVL (a.dist_spct1, 0)
                 - NVL (b.dist_spct1, 0) diff_dist_spct1,
                 NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                         x.share_cd, x.dist_spct, x.dist_spct1,
                         ROUND (  NVL (y.tsi_amt, 0)
                                * ROUND (NVL (x.dist_spct, 0), 9)
                                / 100,
                                2
                               ) computed_tsi,
                         (ROUND (  NVL (y.prem_amt, 0)
                                 * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                   'Y', NVL (x.dist_spct1, 0),
                                                   NVL (x.dist_spct, 0)
                                                  )
                                          ),
                                          9
                                         )
                                 / 100,
                                 2
                                )
                         ) computed_prem
                    FROM giuw_perilds_dtl x, giuw_itemperilds y
                   WHERE x.dist_no = p_dist_no
                     AND x.dist_no = y.dist_no
                     AND x.dist_seq_no = y.dist_seq_no
                     AND x.peril_cd = y.peril_cd) a,
                 giuw_itemperilds_dtl b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.item_no = b.item_no(+)
             AND a.peril_cd = b.peril_cd(+)
             AND a.share_cd = b.share_cd(+)
             AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <> 0)
                  OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <> 0)
                  OR (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                     )
                  OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                     )
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd, y.share_cd,
                 0 pol_distspct, 0 pol_distspct1, 0 computed_tsi,
                 0 computed_prem, y.dist_spct itmperil_distspct,
                 y.dist_spct1 itmperil_distspct1, y.dist_tsi itmperil_disttsi,
                 y.dist_prem itmperil_distprem,
                 0 - NVL (y.dist_spct, 0) diff_dist_spct,
                 0 - NVL (y.dist_spct1, 0) diff_dist_spct1,
                 0 - NVL (y.dist_tsi, 0) diff_tsi,
                 0 - NVL (y.dist_prem, 0) diff_prem
            FROM giuw_perilds_dtl x, giuw_itemperilds_dtl y
           WHERE y.dist_no = p_dist_no
             AND x.dist_no(+) = y.dist_no
             AND x.dist_seq_no(+) = y.dist_seq_no
             AND x.share_cd(+) = y.share_cd
             AND x.peril_cd(+) = y.peril_cd
             AND NOT EXISTS (
                    SELECT 1
                      FROM giuw_perilds_dtl p
                     WHERE p.dist_no = y.dist_no
                       AND p.dist_seq_no = y.dist_seq_no
                       AND p.share_cd = y.share_cd
                       AND p.peril_cd = y.peril_cd))
      LOOP
         comp_perildist.dist_no := cur.dist_no;
         comp_perildist.dist_seq_no := cur.dist_seq_no;
         comp_perildist.item_no := cur.item_no;
         comp_perildist.peril_cd := cur.peril_cd;
         comp_perildist.share_cd := cur.share_cd;
         comp_perildist.itmperil_dist_spct := cur.itmperil_dist_spct;
         comp_perildist.itmperil_dist_spct1 := cur.itmperil_dist_spct1;
         comp_perildist.peril_dist_spct := cur.peril_dist_spct;
         comp_perildist.peril_dist_spct1 := cur.peril_dist_spct1;
         comp_perildist.itmperil_dist_tsi := cur.itmperil_dist_tsi;
         comp_perildist.itmperil_dist_prem := cur.itmperil_dist_prem;
         comp_perildist.computed_tsi := cur.computed_tsi;
         comp_perildist.computed_prem := cur.computed_prem;
         comp_perildist.diff_dist_spct := cur.diff_dist_spct;
         comp_perildist.diff_dist_spct1 := cur.diff_dist_spct1;
         comp_perildist.diff_dist_tsi := cur.diff_tsi;
         comp_perildist.diff_dist_prem := cur.diff_prem;
         PIPE ROW (comp_perildist);
      END LOOP;
   END f_valcnt_pdist_f_itmprldtl;

/* ***************************************************************************************************************************************
        -- validating the computed share% of dist  tables (policyds / itemds ) - PERIL DISTRIBUTION - working distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vcomp_shr_witmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type PIPELINED
   IS
      itemcomp   pdist_comp_shr_itm_rec_type;
   BEGIN
      FOR curdist IN
         (SELECT p.dist_no, p.dist_seq_no, p.item_no, p.share_cd,
                 p.trty_name, p.computed_dist_spct, p.item_spct, p.diff_spct
            FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                         c.trty_name,
                         DECODE
                            (a.tsi_amt,
                             0, (DECODE (a.prem_amt,
                                         0, 0,
                                         ROUND ((  NVL (b.dist_prem, 0)
                                                 / a.prem_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                              ),
                             ROUND ((NVL (b.dist_tsi, 0) / a.tsi_amt * 100),
                                    9)
                            ) computed_dist_spct,
                         b.dist_spct item_spct,
                         TO_CHAR
                            (  (DECODE (a.tsi_amt,
                                        0, (DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  )
                                         ),
                                        ROUND ((  NVL (b.dist_tsi, 0)
                                                / a.tsi_amt
                                                * 100
                                               ),
                                               9
                                              )
                                       )
                               )
                             - NVL (b.dist_spct, 0)
                            ) diff_spct
                    FROM giuw_witemds a, giuw_witemds_dtl b,
                         giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.item_no = b.item_no
                     AND b.line_cd = c.line_cd
                     AND b.share_cd = c.share_cd) p
           WHERE p.diff_spct <> '0')
      LOOP
         itemcomp.dist_no := curdist.dist_no;
         itemcomp.dist_seq_no := curdist.dist_seq_no;
         itemcomp.item_no := curdist.item_no;
         itemcomp.share_cd := curdist.share_cd;
         itemcomp.trty_name := curdist.trty_name;
         itemcomp.computed_dist_spct := curdist.computed_dist_spct;
         itemcomp.item_dist_spct := curdist.item_spct;
         itemcomp.diff_spct := curdist.diff_spct;
         PIPE ROW (itemcomp);
      END LOOP;
   END f_vcomp_shr_witmdtl01;

   FUNCTION f_vcomp_shr_witmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type2 PIPELINED
   IS
      itemcomp   pdist_comp_shr_itm_rec_type2;
   BEGIN
      FOR curdist IN
         (SELECT p.dist_no, p.dist_seq_no, p.item_no, p.share_cd,
                 p.trty_name, p.computed_dist_spct1, p.item_spct1,
                 p.diff_spct1
            FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                         c.trty_name,
                         DECODE
                            (a.prem_amt,
                             0, (DECODE (a.tsi_amt,
                                         0, 0,
                                         ROUND ((  NVL (b.dist_tsi, 0)
                                                 / a.tsi_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                              ),
                             ROUND ((NVL (b.dist_prem, 0) / a.prem_amt * 100),
                                    9
                                   )
                            ) computed_dist_spct1,
                         b.dist_spct1 item_spct1,
                         TO_CHAR
                            (  (DECODE (a.prem_amt,
                                        0, (DECODE (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                         ),
                                        ROUND ((  NVL (b.dist_prem, 0)
                                                / a.prem_amt
                                                * 100
                                               ),
                                               9
                                              )
                                       )
                               )
                             - NVL (b.dist_spct1, 0)
                            ) diff_spct1
                    FROM giuw_witemds a, giuw_witemds_dtl b,
                         giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.item_no = b.item_no
                     AND b.line_cd = c.line_cd
                     AND b.share_cd = c.share_cd) p
           WHERE p.diff_spct1 <> '0')
      LOOP
         itemcomp.dist_no := curdist.dist_no;
         itemcomp.dist_seq_no := curdist.dist_seq_no;
         itemcomp.item_no := curdist.item_no;
         itemcomp.share_cd := curdist.share_cd;
         itemcomp.trty_name := curdist.trty_name;
         itemcomp.computed_dist_spct1 := curdist.computed_dist_spct1;
         itemcomp.item_dist_spct1 := curdist.item_spct1;
         itemcomp.diff_spct1 := curdist.diff_spct1;
         PIPE ROW (itemcomp);
      END LOOP;
   END f_vcomp_shr_witmdtl02;

   FUNCTION f_vcomp_shr_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type PIPELINED
   IS
      polshr   pdist_comp_shr_pol_rec_type;
   BEGIN
      FOR poldtl IN
         (SELECT p.dist_no, p.dist_seq_no, p.share_cd,
                 p.trty_name share_name, p.computed_dist_spct,
                 p.pol_dist_spct, p.diff_spct
            FROM (SELECT   a.dist_no, a.dist_seq_no, b.share_cd, c.trty_name,
                           DECODE
                              (a.tsi_amt,
                               0, DECODE (a.prem_amt,
                                          0, 0,
                                          ROUND ((  NVL (b.dist_prem, 0)
                                                  / a.prem_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         ),
                               ROUND ((NVL (b.dist_tsi, 0) / a.tsi_amt * 100),
                                      9
                                     )
                              ) computed_dist_spct,
                           b.dist_spct pol_dist_spct,
                           TO_CHAR
                              (  (DECODE (a.tsi_amt,
                                          0, DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  ),
                                          ROUND ((  NVL (b.dist_tsi, 0)
                                                  / a.tsi_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         )
                                 )
                               - b.dist_spct
                              ) diff_spct
                      FROM giuw_wpolicyds a,
                           giuw_wpolicyds_dtl b,
                           giis_dist_share c
                     WHERE a.dist_no = p_dist_no
                       AND a.dist_no = b.dist_no
                       AND a.dist_seq_no = b.dist_seq_no
                       AND b.line_cd = c.line_cd
                       AND b.share_cd = c.share_cd
                  ORDER BY a.dist_no, a.dist_seq_no, b.share_cd) p
           WHERE p.diff_spct <> '0')
      LOOP
         polshr.dist_no := poldtl.dist_no;
         polshr.dist_seq_no := poldtl.dist_seq_no;
         polshr.share_cd := poldtl.share_cd;
         polshr.trty_name := poldtl.share_name;
         polshr.computed_dist_spct := poldtl.computed_dist_spct;
         polshr.pol_dist_spct := poldtl.pol_dist_spct;
         polshr.diff_spct := poldtl.diff_spct;
         PIPE ROW (polshr);
      END LOOP;
   END f_vcomp_shr_wpoldtl01;

   FUNCTION f_vcomp_shr_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type2 PIPELINED
   IS
      polshr   pdist_comp_shr_pol_rec_type2;
   BEGIN
      FOR poldtl IN
         (SELECT p.dist_no, p.dist_seq_no, p.share_cd, p.trty_name,
                 p.computed_dist_spct1, p.pol_dist_spct1, p.diff_spct1
            FROM (SELECT a.dist_no, a.dist_seq_no, b.share_cd, c.trty_name,
                         DECODE
                            (a.prem_amt,
                             0, (DECODE (a.tsi_amt,
                                         0, 0,
                                         ROUND ((  NVL (b.dist_tsi, 0)
                                                 / a.tsi_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                              ),
                             ROUND ((NVL (b.dist_prem, 0) / a.prem_amt * 100),
                                    9
                                   )
                            ) computed_dist_spct1,
                         b.dist_spct1 pol_dist_spct1,
                         TO_CHAR
                            (  (DECODE (a.prem_amt,
                                        0, (DECODE (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                         ),
                                        ROUND ((  NVL (b.dist_prem, 0)
                                                / a.prem_amt
                                                * 100
                                               ),
                                               9
                                              )
                                       )
                               )
                             - NVL (b.dist_spct1, 0)
                            ) diff_spct1
                    FROM giuw_wpolicyds a,
                         giuw_wpolicyds_dtl b,
                         giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND b.line_cd = c.line_cd
                     AND b.share_cd = c.share_cd) p
           WHERE p.diff_spct1 <> '0')
      LOOP
         polshr.dist_no := poldtl.dist_no;
         polshr.dist_seq_no := poldtl.dist_seq_no;
         polshr.share_cd := poldtl.share_cd;
         polshr.trty_name := poldtl.trty_name;
         polshr.computed_dist_spct1 := poldtl.computed_dist_spct1;
         polshr.pol_dist_spct1 := poldtl.pol_dist_spct1;
         polshr.diff_spct1 := poldtl.diff_spct1;
         PIPE ROW (polshr);
      END LOOP;
   END f_vcomp_shr_wpoldtl02;

/* ***************************************************************************************************************************************
        -- validating the computed share% of dist  tables (policyds / itemds ) - PERIL DISTRIBUTION - final distribution tables
     ************************************************************************************************************************************** */
   FUNCTION f_vcomp_shr_f_itmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type PIPELINED
   IS
      itemcomp   pdist_comp_shr_itm_rec_type;
   BEGIN
      FOR curdist IN
         (SELECT p.dist_no, p.dist_seq_no, p.item_no, p.share_cd,
                 p.trty_name, p.computed_dist_spct, p.item_spct, p.diff_spct
            FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                         c.trty_name,
                         DECODE
                            (a.tsi_amt,
                             0, (DECODE (a.prem_amt,
                                         0, 0,
                                         ROUND ((  NVL (b.dist_prem, 0)
                                                 / a.prem_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                              ),
                             ROUND ((NVL (b.dist_tsi, 0) / a.tsi_amt * 100),
                                    9)
                            ) computed_dist_spct,
                         b.dist_spct item_spct,
                         TO_CHAR
                            (  (DECODE (a.tsi_amt,
                                        0, (DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  )
                                         ),
                                        ROUND ((  NVL (b.dist_tsi, 0)
                                                / a.tsi_amt
                                                * 100
                                               ),
                                               9
                                              )
                                       )
                               )
                             - NVL (b.dist_spct, 0)
                            ) diff_spct
                    FROM giuw_itemds a, giuw_itemds_dtl b, giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.item_no = b.item_no
                     AND b.line_cd = c.line_cd
                     AND b.share_cd = c.share_cd) p
           WHERE p.diff_spct <> '0')
      LOOP
         itemcomp.dist_no := curdist.dist_no;
         itemcomp.dist_seq_no := curdist.dist_seq_no;
         itemcomp.item_no := curdist.item_no;
         itemcomp.share_cd := curdist.share_cd;
         itemcomp.trty_name := curdist.trty_name;
         itemcomp.computed_dist_spct := curdist.computed_dist_spct;
         itemcomp.item_dist_spct := curdist.item_spct;
         itemcomp.diff_spct := curdist.diff_spct;
         PIPE ROW (itemcomp);
      END LOOP;
   END f_vcomp_shr_f_itmdtl01;

   FUNCTION f_vcomp_shr_f_itmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_itm_type2 PIPELINED
   IS
      itemcomp   pdist_comp_shr_itm_rec_type2;
   BEGIN
      FOR curdist IN
         (SELECT p.dist_no, p.dist_seq_no, p.item_no, p.share_cd,
                 p.trty_name, p.computed_dist_spct1, p.item_spct1,
                 p.diff_spct1
            FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                         c.trty_name,
                         DECODE
                            (a.prem_amt,
                             0, (DECODE (a.tsi_amt,
                                         0, 0,
                                         ROUND ((  NVL (b.dist_tsi, 0)
                                                 / a.tsi_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                              ),
                             ROUND ((NVL (b.dist_prem, 0) / a.prem_amt * 100),
                                    9
                                   )
                            ) computed_dist_spct1,
                         b.dist_spct1 item_spct1,
                         TO_CHAR
                            (  (DECODE (a.prem_amt,
                                        0, (DECODE (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                         ),
                                        ROUND ((  NVL (b.dist_prem, 0)
                                                / a.prem_amt
                                                * 100
                                               ),
                                               9
                                              )
                                       )
                               )
                             - NVL (b.dist_spct1, 0)
                            ) diff_spct1
                    FROM giuw_itemds a, giuw_itemds_dtl b, giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.item_no = b.item_no
                     AND b.line_cd = c.line_cd
                     AND b.share_cd = c.share_cd) p
           WHERE p.diff_spct1 <> '0')
      LOOP
         itemcomp.dist_no := curdist.dist_no;
         itemcomp.dist_seq_no := curdist.dist_seq_no;
         itemcomp.item_no := curdist.item_no;
         itemcomp.share_cd := curdist.share_cd;
         itemcomp.trty_name := curdist.trty_name;
         itemcomp.computed_dist_spct1 := curdist.computed_dist_spct1;
         itemcomp.item_dist_spct1 := curdist.item_spct1;
         itemcomp.diff_spct1 := curdist.diff_spct1;
         PIPE ROW (itemcomp);
      END LOOP;
   END f_vcomp_shr_f_itmdtl02;

   FUNCTION f_vcomp_shr_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type PIPELINED
   IS
      polshr   pdist_comp_shr_pol_rec_type;
   BEGIN
      FOR poldtl IN
         (SELECT p.dist_no, p.dist_seq_no, p.share_cd,
                 p.trty_name share_name, p.computed_dist_spct,
                 p.pol_dist_spct, p.diff_spct
            FROM (SELECT   a.dist_no, a.dist_seq_no, b.share_cd, c.trty_name,
                           DECODE
                              (a.tsi_amt,
                               0, DECODE (a.prem_amt,
                                          0, 0,
                                          ROUND ((  NVL (b.dist_prem, 0)
                                                  / a.prem_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         ),
                               ROUND ((NVL (b.dist_tsi, 0) / a.tsi_amt * 100),
                                      9
                                     )
                              ) computed_dist_spct,
                           b.dist_spct pol_dist_spct,
                           TO_CHAR
                              (  (DECODE (a.tsi_amt,
                                          0, DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  ),
                                          ROUND ((  NVL (b.dist_tsi, 0)
                                                  / a.tsi_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         )
                                 )
                               - b.dist_spct
                              ) diff_spct
                      FROM giuw_policyds a,
                           giuw_policyds_dtl b,
                           giis_dist_share c
                     WHERE a.dist_no = p_dist_no
                       AND a.dist_no = b.dist_no
                       AND a.dist_seq_no = b.dist_seq_no
                       AND b.line_cd = c.line_cd
                       AND b.share_cd = c.share_cd
                  ORDER BY a.dist_no, a.dist_seq_no, b.share_cd) p
           WHERE p.diff_spct <> '0')
      LOOP
         polshr.dist_no := poldtl.dist_no;
         polshr.dist_seq_no := poldtl.dist_seq_no;
         polshr.share_cd := poldtl.share_cd;
         polshr.trty_name := poldtl.share_name;
         polshr.computed_dist_spct := poldtl.computed_dist_spct;
         polshr.pol_dist_spct := poldtl.pol_dist_spct;
         polshr.diff_spct := poldtl.diff_spct;
         PIPE ROW (polshr);
      END LOOP;
   END f_vcomp_shr_f_poldtl01;

   FUNCTION f_vcomp_shr_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pdist_comp_shr_pol_type2 PIPELINED
   IS
      polshr   pdist_comp_shr_pol_rec_type2;
   BEGIN
      FOR poldtl IN
         (SELECT p.dist_no, p.dist_seq_no, p.share_cd, p.trty_name,
                 p.computed_dist_spct1, p.pol_dist_spct1, p.diff_spct1
            FROM (SELECT a.dist_no, a.dist_seq_no, b.share_cd, c.trty_name,
                         DECODE
                            (a.prem_amt,
                             0, (DECODE (a.tsi_amt,
                                         0, 0,
                                         ROUND ((  NVL (b.dist_tsi, 0)
                                                 / a.tsi_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                              ),
                             ROUND ((NVL (b.dist_prem, 0) / a.prem_amt * 100),
                                    9
                                   )
                            ) computed_dist_spct1,
                         b.dist_spct1 pol_dist_spct1,
                         TO_CHAR
                            (  (DECODE (a.prem_amt,
                                        0, (DECODE (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                         ),
                                        ROUND ((  NVL (b.dist_prem, 0)
                                                / a.prem_amt
                                                * 100
                                               ),
                                               9
                                              )
                                       )
                               )
                             - NVL (b.dist_spct1, 0)
                            ) diff_spct1
                    FROM giuw_policyds a,
                         giuw_policyds_dtl b,
                         giis_dist_share c
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND b.line_cd = c.line_cd
                     AND b.share_cd = c.share_cd) p
           WHERE p.diff_spct1 <> '0')
      LOOP
         polshr.dist_no := poldtl.dist_no;
         polshr.dist_seq_no := poldtl.dist_seq_no;
         polshr.share_cd := poldtl.share_cd;
         polshr.trty_name := poldtl.trty_name;
         polshr.computed_dist_spct1 := poldtl.computed_dist_spct1;
         polshr.pol_dist_spct1 := poldtl.pol_dist_spct1;
         polshr.diff_spct1 := poldtl.diff_spct1;
         PIPE ROW (polshr);
      END LOOP;
   END f_vcomp_shr_f_poldtl02;

   /* ***************************************************************************************************************************************
          -- validation of distribution amounts (TSI/Prem) - Peril Distribution - Working Distribution Tables
       ************************************************************************************************************************************** */
   FUNCTION f_valcnt_pdist_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_perildtl_type PIPELINED
   IS
      vperil_dtl      pcomp_perildtl_rec_type;
      v_tol_discrep   giuw_pol_dist.tsi_amt%TYPE   := 1;
   BEGIN
      FOR dist IN
         (SELECT a.dist_no, a.dist_seq_no, a.peril_cd, c.trty_name,
                 c.share_cd, b.dist_spct, b.dist_tsi, b.dist_prem,
                 ROUND (  NVL (a.tsi_amt, 0)
                        * ROUND (NVL (b.dist_spct, 0), 9)
                        / 100,
                        2
                       ) computed_tsi,
                 ROUND
                     (  NVL (a.prem_amt, 0)
                      * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                        'Y', NVL (b.dist_spct1, 0),
                                        NVL (b.dist_spct, 0)
                                       )
                               ),
                               9
                              )
                      / 100,
                      2
                     ) computed_prem,
                   NVL (b.dist_tsi, 0)
                 - ROUND (  NVL (a.tsi_amt, 0)
                          * ROUND (NVL (b.dist_spct, 0), 9)
                          / 100,
                          2
                         ) diff_tsi,
                   NVL (b.dist_prem, 0)
                 - ROUND (  NVL (a.prem_amt, 0)
                          * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                            'Y', NVL (b.dist_spct1, 0),
                                            NVL (b.dist_spct, 0)
                                           )
                                   ),
                                   9
                                  )
                          / 100,
                          2
                         ) diff_prem
            FROM giuw_wperilds a, giuw_wperilds_dtl b, giis_dist_share c
           WHERE 1 = 1
             AND a.dist_no = p_dist_no
             AND a.dist_no = b.dist_no
             AND a.dist_seq_no = b.dist_seq_no
             AND a.peril_cd = b.peril_cd
             AND b.line_cd = c.line_cd
             AND b.share_cd = c.share_cd
             AND (   (ABS (  NVL (b.dist_tsi, 0)
                           - ROUND (  NVL (a.tsi_amt, 0)
                                    * ROUND (NVL (b.dist_spct, 0), 9)
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                  OR (ABS (  NVL (b.dist_prem, 0)
                           - ROUND (  NVL (a.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (b.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (b.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                 ))
      LOOP
         vperil_dtl.dist_no := dist.dist_no;
         vperil_dtl.dist_seq_no := dist.dist_seq_no;
         vperil_dtl.peril_cd := dist.peril_cd;
         vperil_dtl.trty_name := dist.trty_name;
         vperil_dtl.dist_spct := dist.dist_spct;
         vperil_dtl.dist_tsi := dist.dist_tsi;
         vperil_dtl.dist_prem := dist.dist_prem;
         vperil_dtl.computed_tsi := dist.computed_tsi;
         vperil_dtl.computed_prem := dist.computed_prem;
         vperil_dtl.diff_tsi := dist.diff_tsi;
         vperil_dtl.diff_prem := dist.diff_prem;
         PIPE ROW (vperil_dtl);
      END LOOP;
   END f_valcnt_pdist_wperildtl;

   FUNCTION f_valcnt_pdist_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_itmperildtl_type PIPELINED
   IS
      pcomp_itmperil   pcomp_itmperildtl_rec_type;
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE   := 0.05;
   BEGIN
      FOR cur IN
         (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd, a.share_cd,
                 a.dist_spct peril_dist_spct, a.dist_spct1 peril_dist_spct1,
                 a.computed_tsi, a.computed_prem,
                 b.dist_spct itmperil_dist_spct,
                 b.dist_spct1 itmperil_dist_spct1,
                 b.dist_tsi itmperil_dist_tsi,
                 b.dist_prem itmperil_dist_prem,
                 NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                         x.share_cd, x.dist_spct, x.dist_spct1,
                         ROUND (  NVL (y.tsi_amt, 0)
                                * ROUND (NVL (x.dist_spct, 0), 9)
                                / 100,
                                2
                               ) computed_tsi,
                         (ROUND (  NVL (y.prem_amt, 0)
                                 * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                   'Y', NVL (x.dist_spct1, 0),
                                                   NVL (x.dist_spct, 0)
                                                  )
                                          ),
                                          9
                                         )
                                 / 100,
                                 2
                                )
                         ) computed_prem
                    FROM giuw_wperilds_dtl x, giuw_witemperilds y
                   WHERE x.dist_no = p_dist_no
                     AND x.dist_no = y.dist_no
                     AND x.dist_seq_no = y.dist_seq_no
                     AND x.peril_cd = y.peril_cd) a,
                 giuw_witemperilds_dtl b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.item_no = b.item_no(+)
             AND a.peril_cd = b.peril_cd(+)
             AND a.share_cd = b.share_cd(+)
             AND (   (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                     )
                  OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                     )
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd, y.share_cd,
                 0 pol_distspct, 0 pol_distspct1, 0 computed_tsi,
                 0 computed_prem, y.dist_spct itmperil_distspct,
                 y.dist_spct1 itmperil_distspct1, y.dist_tsi itmperil_disttsi,
                 y.dist_prem itmperil_distprem,
                 0 - NVL (y.dist_tsi, 0) diff_tsi,
                 0 - NVL (y.dist_prem, 0) diff_prem
            FROM giuw_wperilds_dtl x, giuw_witemperilds_dtl y
           WHERE y.dist_no = p_dist_no
             AND x.dist_no(+) = y.dist_no
             AND x.dist_seq_no(+) = y.dist_seq_no
             AND x.share_cd(+) = y.share_cd
             AND x.peril_cd(+) = y.peril_cd
             AND NOT EXISTS (
                    SELECT 1
                      FROM giuw_wperilds_dtl p
                     WHERE p.dist_no = y.dist_no
                       AND p.dist_seq_no = y.dist_seq_no
                       AND p.share_cd = y.share_cd
                       AND p.peril_cd = y.peril_cd))
      LOOP
         pcomp_itmperil.dist_no := cur.dist_no;
         pcomp_itmperil.dist_seq_no := cur.dist_seq_no;
         pcomp_itmperil.item_no := cur.item_no;
         pcomp_itmperil.peril_cd := cur.peril_cd;
         pcomp_itmperil.share_cd := cur.share_cd;
         pcomp_itmperil.peril_dist_spct := cur.peril_dist_spct;
         pcomp_itmperil.peril_dist_spct1 := cur.peril_dist_spct1;
         pcomp_itmperil.itmperil_dist_spct := cur.itmperil_dist_spct;
         pcomp_itmperil.itmperil_dist_spct1 := cur.itmperil_dist_spct1;
         pcomp_itmperil.computed_tsi := cur.computed_tsi;
         pcomp_itmperil.computed_prem := cur.computed_prem;
         pcomp_itmperil.itmperil_dist_tsi := cur.itmperil_dist_tsi;
         pcomp_itmperil.itmperil_dist_prem := cur.itmperil_dist_prem;
         pcomp_itmperil.diff_tsi := cur.diff_tsi;
         pcomp_itmperil.diff_prem := cur.diff_prem;
         PIPE ROW (pcomp_itmperil);
      END LOOP;
   END f_valcnt_pdist_witmprldtl;

/* ***************************************************************************************************************************************
        -- validation of distribution amounts (TSI/Prem) - Peril Distribution - Final Distribution Tables
     ************************************************************************************************************************************** */
   FUNCTION f_valcnt_pdist_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_perildtl_type PIPELINED
   IS
      vperil_dtl      pcomp_perildtl_rec_type;
      v_tol_discrep   giuw_pol_dist.tsi_amt%TYPE   := 1;
   BEGIN
      FOR dist IN
         (SELECT a.dist_no, a.dist_seq_no, a.peril_cd, c.trty_name,
                 c.share_cd, b.dist_spct, b.dist_tsi, b.dist_prem,
                 ROUND (  NVL (a.tsi_amt, 0)
                        * ROUND (NVL (b.dist_spct, 0), 9)
                        / 100,
                        2
                       ) computed_tsi,
                 ROUND
                     (  NVL (a.prem_amt, 0)
                      * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                        'Y', NVL (b.dist_spct1, 0),
                                        NVL (b.dist_spct, 0)
                                       )
                               ),
                               9
                              )
                      / 100,
                      2
                     ) computed_prem,
                   NVL (b.dist_tsi, 0)
                 - ROUND (  NVL (a.tsi_amt, 0)
                          * ROUND (NVL (b.dist_spct, 0), 9)
                          / 100,
                          2
                         ) diff_tsi,
                   NVL (b.dist_prem, 0)
                 - ROUND (  NVL (a.prem_amt, 0)
                          * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                            'Y', NVL (b.dist_spct1, 0),
                                            NVL (b.dist_spct, 0)
                                           )
                                   ),
                                   9
                                  )
                          / 100,
                          2
                         ) diff_prem
            FROM giuw_perilds a, giuw_perilds_dtl b, giis_dist_share c
           WHERE 1 = 1
             AND a.dist_no = p_dist_no
             AND a.dist_no = b.dist_no
             AND a.dist_seq_no = b.dist_seq_no
             AND a.peril_cd = b.peril_cd
             AND b.line_cd = c.line_cd
             AND b.share_cd = c.share_cd
             AND (   (ABS (  NVL (b.dist_tsi, 0)
                           - ROUND (  NVL (a.tsi_amt, 0)
                                    * ROUND (NVL (b.dist_spct, 0), 9)
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                  OR (ABS (  NVL (b.dist_prem, 0)
                           - ROUND (  NVL (a.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (b.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (b.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                          ) > v_tol_discrep
                     )
                 ))
      LOOP
         vperil_dtl.dist_no := dist.dist_no;
         vperil_dtl.dist_seq_no := dist.dist_seq_no;
         vperil_dtl.peril_cd := dist.peril_cd;
         vperil_dtl.trty_name := dist.trty_name;
         vperil_dtl.dist_spct := dist.dist_spct;
         vperil_dtl.dist_tsi := dist.dist_tsi;
         vperil_dtl.dist_prem := dist.dist_prem;
         vperil_dtl.computed_tsi := dist.computed_tsi;
         vperil_dtl.computed_prem := dist.computed_prem;
         vperil_dtl.diff_tsi := dist.diff_tsi;
         vperil_dtl.diff_prem := dist.diff_prem;
         PIPE ROW (vperil_dtl);
      END LOOP;
   END f_valcnt_pdist_f_perildtl;

   FUNCTION f_valcnt_pdist_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pcomp_itmperildtl_type PIPELINED
   IS
      pcomp_itmperil   pcomp_itmperildtl_rec_type;
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE   := 0.05;
   BEGIN
      FOR cur IN
         (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd, a.share_cd,
                 a.dist_spct peril_dist_spct, a.dist_spct1 peril_dist_spct1,
                 a.computed_tsi, a.computed_prem,
                 b.dist_spct itmperil_dist_spct,
                 b.dist_spct1 itmperil_dist_spct1,
                 b.dist_tsi itmperil_dist_tsi,
                 b.dist_prem itmperil_dist_prem,
                 NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                 NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
            FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                         x.share_cd, x.dist_spct, x.dist_spct1,
                         ROUND (  NVL (y.tsi_amt, 0)
                                * ROUND (NVL (x.dist_spct, 0), 9)
                                / 100,
                                2
                               ) computed_tsi,
                         (ROUND (  NVL (y.prem_amt, 0)
                                 * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                   'Y', NVL (x.dist_spct1, 0),
                                                   NVL (x.dist_spct, 0)
                                                  )
                                          ),
                                          9
                                         )
                                 / 100,
                                 2
                                )
                         ) computed_prem
                    FROM giuw_perilds_dtl x, giuw_itemperilds y
                   WHERE x.dist_no = p_dist_no
                     AND x.dist_no = y.dist_no
                     AND x.dist_seq_no = y.dist_seq_no
                     AND x.peril_cd = y.peril_cd) a,
                 giuw_itemperilds_dtl b
           WHERE a.dist_no = b.dist_no(+)
             AND a.dist_seq_no = b.dist_seq_no(+)
             AND a.item_no = b.item_no(+)
             AND a.peril_cd = b.peril_cd(+)
             AND a.share_cd = b.share_cd(+)
             AND (   (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                     )
                  OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                     )
                 )
          UNION
          SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd, y.share_cd,
                 0 pol_distspct, 0 pol_distspct1, 0 computed_tsi,
                 0 computed_prem, y.dist_spct itmperil_distspct,
                 y.dist_spct1 itmperil_distspct1, y.dist_tsi itmperil_disttsi,
                 y.dist_prem itmperil_distprem,
                 0 - NVL (y.dist_tsi, 0) diff_tsi,
                 0 - NVL (y.dist_prem, 0) diff_prem
            FROM giuw_perilds_dtl x, giuw_itemperilds_dtl y
           WHERE y.dist_no = p_dist_no
             AND x.dist_no(+) = y.dist_no
             AND x.dist_seq_no(+) = y.dist_seq_no
             AND x.share_cd(+) = y.share_cd
             AND x.peril_cd(+) = y.peril_cd
             AND NOT EXISTS (
                    SELECT 1
                      FROM giuw_perilds_dtl p
                     WHERE p.dist_no = y.dist_no
                       AND p.dist_seq_no = y.dist_seq_no
                       AND p.share_cd = y.share_cd
                       AND p.peril_cd = y.peril_cd))
      LOOP
         pcomp_itmperil.dist_no := cur.dist_no;
         pcomp_itmperil.dist_seq_no := cur.dist_seq_no;
         pcomp_itmperil.item_no := cur.item_no;
         pcomp_itmperil.peril_cd := cur.peril_cd;
         pcomp_itmperil.share_cd := cur.share_cd;
         pcomp_itmperil.peril_dist_spct := cur.peril_dist_spct;
         pcomp_itmperil.peril_dist_spct1 := cur.peril_dist_spct1;
         pcomp_itmperil.itmperil_dist_spct := cur.itmperil_dist_spct;
         pcomp_itmperil.itmperil_dist_spct1 := cur.itmperil_dist_spct1;
         pcomp_itmperil.computed_tsi := cur.computed_tsi;
         pcomp_itmperil.computed_prem := cur.computed_prem;
         pcomp_itmperil.itmperil_dist_tsi := cur.itmperil_dist_tsi;
         pcomp_itmperil.itmperil_dist_prem := cur.itmperil_dist_prem;
         pcomp_itmperil.diff_tsi := cur.diff_tsi;
         pcomp_itmperil.diff_prem := cur.diff_prem;
         PIPE ROW (pcomp_itmperil);
      END LOOP;
   END f_valcnt_pdist_f_itmprldtl;

   /* ***************************************************************************************************************************************
--  checking of zero share % but non-zero amounts
  ************************************************************************************************************************************** */
   FUNCTION f_valcnt_nzroprem_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED
   IS
      row_itemperilds_dtl   giuw_itemperilds_dtl%ROWTYPE;

      CURSOR get_itemperilds_dtl1
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no
            AND dist_prem <> 0
            AND NVL (dist_spct, 0) = 0;

      CURSOR get_itemperilds_dtl2
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no
            AND dist_prem <> 0
            AND NVL (dist_spct1, 0) = 0;
   BEGIN
      IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         FOR dist IN get_itemperilds_dtl1
         LOOP
            PIPE ROW (dist);
         END LOOP;
      ELSE
         FOR dist IN get_itemperilds_dtl2
         LOOP
            PIPE ROW (dist);
         END LOOP;
      END IF;
   END f_valcnt_nzroprem_f_itmpldtl01;

   FUNCTION f_valcnt_nzroprem_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED
   IS
      row_witemperilds_dtl   giuw_witemperilds_dtl%ROWTYPE;

      CURSOR get_witemperilds_dtl1
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no
            AND dist_prem <> 0
            AND NVL (dist_spct, 0) = 0;

      CURSOR get_witemperilds_dtl2
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no
            AND dist_prem <> 0
            AND NVL (dist_spct1, 0) = 0;
   BEGIN
      IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         FOR dist IN get_witemperilds_dtl1
         LOOP
            PIPE ROW (dist);
         END LOOP;
      ELSE
         FOR dist IN get_witemperilds_dtl2
         LOOP
            PIPE ROW (dist);
         END LOOP;
      END IF;
   END f_valcnt_nzroprem_witmprldtl02;

   FUNCTION f_valcnt_nzrotsi_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_itemperilds_dtl PIPELINED
   IS
      row_itemperilds_dtl   giuw_itemperilds_dtl%ROWTYPE;

      CURSOR get_itemperilds_dtl
      IS
         SELECT *
           FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no AND dist_tsi <> 0 AND dist_spct = 0;
   BEGIN
      FOR dist IN get_itemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_valcnt_nzrotsi_f_itmprldtl;

   FUNCTION f_valcnt_nzrotsi_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN pexists_witemperilds_dtl PIPELINED
   IS
      row_witemperilds_dtl   giuw_witemperilds_dtl%ROWTYPE;

      CURSOR get_witemperilds_dtl
      IS
         SELECT *
           FROM giuw_witemperilds_dtl
          WHERE dist_no = p_dist_no AND dist_tsi <> 0 AND dist_spct = 0;
   BEGIN
      FOR dist IN get_witemperilds_dtl
      LOOP
         PIPE ROW (dist);
      END LOOP;
   END f_valcnt_nzrotsi_witmprldtl;

       /* ***************************************************************************************************************************************
--  checking of giuw_pol_dist
  ************************************************************************************************************************************** */
   FUNCTION f_val_pol_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN poldist_type PIPELINED
   IS
      poldist   poldist_rec_type;
   BEGIN
      FOR dist IN (SELECT dist_no, policy_id, par_id, dist_flag, post_flag,
                          auto_dist, special_dist_sw, item_grp,
                          takeup_seq_no
                     FROM giuw_pol_dist
                    WHERE dist_no = p_dist_no)
      LOOP
         poldist.dist_no := dist.dist_no;
         poldist.policy_id := dist.policy_id;
         poldist.par_id := dist.par_id;
         poldist.dist_flag := dist.dist_flag;
         poldist.post_flag := dist.post_flag;
         poldist.auto_dist := dist.auto_dist;
         poldist.special_dist_sw := dist.special_dist_sw;
         poldist.item_grp := dist.item_grp;
         poldist.takeup_seq_no := dist.takeup_seq_no;
         PIPE ROW (poldist);
      END LOOP;
   END;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Working Distribution Tables
** ==================================================================================================================================*/
   FUNCTION f_valcnt_sign_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN sign_itmperil_type PIPELINED
   IS
      itmperil   sign_itmperil_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, b.item_no, b.peril_cd,
                          a.share_cd, b.tsi_amt itmperil_tsi_amt,
                          a.dist_tsi itmperil_dist_tsi,
                          b.prem_amt itmperil_prem_amt,
                          a.dist_prem itmperil_dist_prem
                     FROM giuw_witemperilds_dtl a, giuw_witemperilds b
                    WHERE a.dist_no = p_dist_no
                      AND a.dist_no = b.dist_no
                      AND a.dist_seq_no = b.dist_seq_no
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND (  ( SIGN (a.dist_tsi) <> SIGN (b.tsi_amt)  and a.dist_tsi <> 0 )  -- jhing 07.03.2014 added restriction on zero amount
                           OR ( SIGN (a.dist_prem) <> SIGN (b.prem_amt) and a.dist_prem <> 0 )   -- jhing 07.03.2014 added restriction on zero amount
                          ))
      LOOP
         itmperil.dist_no := dist.dist_no;
         itmperil.dist_seq_no := dist.dist_seq_no;
         itmperil.item_no := dist.item_no;
         itmperil.peril_cd := dist.peril_cd;
         itmperil.share_cd := dist.share_cd;
         itmperil.itmperil_tsi_amt := dist.itmperil_tsi_amt;
         itmperil.itmperil_dist_tsi := dist.itmperil_dist_tsi;
         itmperil.itmperil_prem_amt := dist.itmperil_prem_amt;
         itmperil.itmperil_dist_prem := dist.itmperil_dist_prem;
         PIPE ROW (itmperil);
      END LOOP;
   END;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Final Distribution Tables
** ==================================================================================================================================*/
   FUNCTION f_valcnt_sign_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN sign_itmperil_type PIPELINED
   IS
      itmperil   sign_itmperil_rec_type;
   BEGIN
      FOR dist IN (SELECT b.dist_no, b.dist_seq_no, b.item_no, b.peril_cd,
                          a.share_cd, b.tsi_amt itmperil_tsi_amt,
                          a.dist_tsi itmperil_dist_tsi,
                          b.prem_amt itmperil_prem_amt,
                          a.dist_prem itmperil_dist_prem
                     FROM giuw_itemperilds_dtl a, giuw_itemperilds b
                    WHERE a.dist_no = p_dist_no
                      AND a.dist_no = b.dist_no
                      AND a.dist_seq_no = b.dist_seq_no
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND (    ( SIGN (a.dist_tsi) <> SIGN (b.tsi_amt) and a.dist_tsi <> 0 )  -- jhing 07.03.2014 added restriction on zero amount
                           OR ( SIGN (a.dist_prem) <> SIGN (b.prem_amt) and a.dist_prem <> 0 )   -- jhing 07.03.2014 added restriction on zero amount
                          ))
      LOOP
         itmperil.dist_no := dist.dist_no;
         itmperil.dist_seq_no := dist.dist_seq_no;
         itmperil.item_no := dist.item_no;
         itmperil.peril_cd := dist.peril_cd;
         itmperil.share_cd := dist.share_cd;
         itmperil.itmperil_tsi_amt := dist.itmperil_tsi_amt;
         itmperil.itmperil_dist_tsi := dist.itmperil_dist_tsi;
         itmperil.itmperil_prem_amt := dist.itmperil_prem_amt;
         itmperil.itmperil_dist_prem := dist.itmperil_dist_prem;
         PIPE ROW (itmperil);
      END LOOP;
   END;

      /* ===================================================================================================================================
   **  Dist Validation - Validating if there exists working binder tables
   ** ==================================================================================================================================*/
   FUNCTION f_wrkngbndr_wfrps_ri (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wfrps_ri_type PIPELINED
   IS
      wfrps_ri   wfrps_ri_rec_type;
   BEGIN
      FOR bndr IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                          pre_binder_id
                     FROM giri_wfrps_ri
                    WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no))
      LOOP
         wfrps_ri.line_cd := bndr.line_cd;
         wfrps_ri.frps_yy := bndr.frps_yy;
         wfrps_ri.frps_seq_no := bndr.frps_seq_no;
         wfrps_ri.ri_seq_no := bndr.ri_seq_no;
         wfrps_ri.ri_cd := bndr.ri_cd;
         wfrps_ri.pre_binder_id := bndr.pre_binder_id;
         PIPE ROW (wfrps_ri);
      END LOOP;
   END f_wrkngbndr_wfrps_ri;

   FUNCTION f_wrkngbndr_wfrperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wfrperil_type PIPELINED
   IS
      wfrperil   wfrperil_rec_type;
   BEGIN
      FOR bndr IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                          peril_cd
                     FROM giri_wfrperil
                    WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no))
      LOOP
         wfrperil.line_cd := bndr.line_cd;
         wfrperil.frps_yy := bndr.frps_yy;
         wfrperil.frps_seq_no := bndr.frps_seq_no;
         wfrperil.ri_seq_no := bndr.ri_seq_no;
         wfrperil.ri_cd := bndr.ri_cd;
         wfrperil.peril_cd := bndr.peril_cd;
         PIPE ROW (wfrperil);
      END LOOP;
   END f_wrkngbndr_wfrperil;

   FUNCTION f_wrkngbndr_wbinderperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wbinder_peril_type PIPELINED
   IS
      wbinder_peril   wbinder_peril_rec_type;
   BEGIN
      FOR bndr IN
         (SELECT pre_binder_id, peril_seq_no
            FROM giri_wbinder_peril
           WHERE pre_binder_id IN (
                    SELECT pre_binder_id
                      FROM giri_wfrps_ri
                     WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no)))
      LOOP
         wbinder_peril.pre_binder_id := bndr.pre_binder_id;
         wbinder_peril.peril_seq_no := bndr.peril_seq_no;
         PIPE ROW (wbinder_peril);
      END LOOP;
   END f_wrkngbndr_wbinderperil;

   FUNCTION f_wrkngbndr_wbinder (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wbinder_type PIPELINED
   IS
      wbinder   wbinder_rec_type;
   BEGIN
      FOR bndr IN
         (SELECT pre_binder_id, line_cd, binder_yy, binder_seq_no, ri_cd
            FROM giri_wbinder
           WHERE pre_binder_id IN (
                    SELECT pre_binder_id
                      FROM giri_wfrps_ri
                     WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no)))
      LOOP
         wbinder.pre_binder_id := bndr.pre_binder_id;
         wbinder.line_cd := bndr.line_cd;
         wbinder.binder_yy := bndr.binder_yy;
         wbinder.binder_seq_no := bndr.binder_seq_no;
         wbinder.ri_cd := bndr.ri_cd;
         PIPE ROW (wbinder);
      END LOOP;
   END f_wrkngbndr_wbinder;

   FUNCTION f_wrkngbndr_wfrps_peril_grp (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
      RETURN wfrps_peril_grp_type PIPELINED
   IS
      wfrps_grp   wfrps_peril_grp_rec_type;
   BEGIN
      FOR bndr IN (SELECT line_cd, frps_yy, frps_seq_no, peril_seq_no,
                          peril_cd
                     FROM giri_wfrps_peril_grp
                    WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no))
      LOOP
         wfrps_grp.line_cd := bndr.line_cd;
         wfrps_grp.frps_yy := bndr.frps_yy;
         wfrps_grp.frps_seq_no := bndr.frps_seq_no;
         wfrps_grp.peril_seq_no := bndr.peril_seq_no;
         wfrps_grp.peril_cd := bndr.peril_cd;
         PIPE ROW (wfrps_grp);
      END LOOP;
   END f_wrkngbndr_wfrps_peril_grp;
-- &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
END genqa_dist_res_tbl;
/

DROP PACKAGE BODY CPI.GENQA_DIST_RES_TBL;


