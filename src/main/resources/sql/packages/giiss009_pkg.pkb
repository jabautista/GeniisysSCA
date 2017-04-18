CREATE OR REPLACE PACKAGE BODY CPI.giiss009_pkg
AS
   FUNCTION get_currency_list
      RETURN giis_currency_rec_tab PIPELINED
   IS
      v_list   giis_currency_rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_currency
                ORDER BY 1 ASC)
      LOOP
         v_list.main_currency_cd := i.main_currency_cd;
         v_list.currency_desc := i.currency_desc;
         v_list.currency_rt := i.currency_rt;
         v_list.short_name := i.short_name;
         v_list.last_update :=
                          TO_CHAR (i.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
         v_list.user_id := i.user_id;
         v_list.remarks := i.remarks;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION validate_delete_currency (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_currency   VARCHAR2 (30) := '0';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wopen_liab
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := '1';

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_collection_dtl
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_direct_prem_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT proc_qtr_no
                  FROM giac_intreaty_qtr_soa
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.proc_qtr_no;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_inwfacul_prem_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_inw_oblig_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_loss_ri_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_inw_oblig_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_loss_ri_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_outward_oblig_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_direct_claim_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT par_id
                  FROM gipi_wlim_liab
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.par_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT par_id
                  FROM gipi_witem
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.par_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT policy_id
                  FROM gipi_open_liab
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.policy_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT policy_id
                  FROM gipi_lim_liab
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.policy_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT policy_id
                  FROM gipi_item
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.policy_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT dist_no
                  FROM giri_wdistfrps
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.dist_no;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT dist_no
                  FROM giri_distfrps
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.dist_no;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_bank_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_chk_disbursement
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_chk_disbursement
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_comm_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_loss_recoveries
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_outfacul_prem_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT proc_year
                  FROM giac_out_treaty_qtr_soa
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.proc_year;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT iss_cd
                  FROM giac_aging_fc_soa_details
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.iss_cd;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_inwfacul_clm_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      FOR i IN (SELECT gacc_tran_id
                  FROM giac_inwfacul_branch_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         v_currency := i.gacc_tran_id;

         IF v_currency IS NOT NULL
         THEN
            RETURN v_currency;
         END IF;
      END LOOP;

      RETURN v_currency;
   END;

   FUNCTION validate_main_currency_cd (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_currency   VARCHAR2 (30) := 'N';
   BEGIN
      FOR i IN (SELECT main_currency_cd
                  FROM giis_currency
                 WHERE main_currency_cd = p_main_currency_cd)
      LOOP
         v_currency := 'Y';
      END LOOP;

      RETURN v_currency;
   END;

   FUNCTION validate_short_name (p_short_name giis_currency.short_name%TYPE)
      RETURN VARCHAR2
   IS
      v_currency   VARCHAR2 (30) := 'N';
   BEGIN
      FOR i IN (SELECT short_name
                  FROM giis_currency
                 WHERE short_name = p_short_name)
      LOOP
         v_currency := 'Y';
      END LOOP;

      RETURN v_currency;
   END;

   FUNCTION validate_currency_desc (
      p_currency_desc   giis_currency.currency_desc%TYPE
   )
      RETURN VARCHAR2
   IS
      v_currency   VARCHAR2 (30) := 'N';
   BEGIN
      FOR i IN (SELECT currency_desc
                  FROM giis_currency
                 WHERE currency_desc = p_currency_desc)
      LOOP
         v_currency := 'Y';
      END LOOP;

      RETURN v_currency;
   END;

   PROCEDURE delete_giis_currency (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_currency
            WHERE main_currency_cd = p_main_currency_cd;

      DELETE FROM giis_currency
            WHERE main_currency_cd = p_main_currency_cd;
   END;

   PROCEDURE set_giis_currency (p_currency giis_currency%ROWTYPE)
   IS
      v_currency   VARCHAR2 (2);
   BEGIN
      SELECT (SELECT '1'
                FROM giis_currency
               WHERE main_currency_cd = p_currency.main_currency_cd)
        INTO v_currency
        FROM DUAL;

      IF v_currency = '1'
      THEN 
         UPDATE giis_currency
            SET currency_desc = p_currency.currency_desc,
                currency_rt = p_currency.currency_rt,
                short_name = p_currency.short_name,
                user_id = p_currency.user_id,
                remarks = p_currency.remarks
          WHERE main_currency_cd = p_currency.main_currency_cd;
      ELSE
         INSERT INTO giis_currency
                     (main_currency_cd, currency_desc,
                      currency_rt, short_name,
                      user_id, remarks
                     )
              VALUES (p_currency.main_currency_cd, p_currency.currency_desc,
                      p_currency.currency_rt, p_currency.short_name,
                      p_currency.user_id, p_currency.remarks
                     );
      END IF;
   END;

   FUNCTION get_all_main_currency_cd
      RETURN giis_currency_rec_tab PIPELINED
   IS
      v_list   giis_currency_rec_type;
   BEGIN
      FOR i IN (SELECT   main_currency_cd
                    FROM giis_currency
                ORDER BY 1 ASC)
      LOOP
         v_list.main_currency_cd := i.main_currency_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_all_short_name
      RETURN giis_currency_rec_tab PIPELINED
   IS
      v_list   giis_currency_rec_type;
   BEGIN
      FOR i IN (SELECT   short_name
                    FROM giis_currency
                ORDER BY 1 ASC)
      LOOP
         v_list.short_name := i.short_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_all_currency_desc
      RETURN giis_currency_rec_tab PIPELINED
   IS
      v_list   giis_currency_rec_type;
   BEGIN
      FOR i IN (SELECT   currency_desc
                    FROM giis_currency
                ORDER BY 1 ASC)
      LOOP
         v_list.currency_desc := i.currency_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_del_rec (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wopen_liab b920
                 WHERE b920.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_WOPEN_LIAB exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_collection_dtl
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_COLLECTION_DTL exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_direct_prem_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_DIRECT_PREM_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_intreaty_qtr_soa
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INTREATY_QTR_SOA exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inwfacul_prem_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INWFACUL_PREM_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inw_oblig_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INW_OBLIG_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_loss_ri_collns
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_LOSS_RI_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_outward_oblig_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_OUTWARD_OBLIG_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_direct_claim_payts
                 WHERE currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_DIRECT_CLAIM_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM gipi_wlim_liab b500
                 WHERE b500.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_WLIM_LIAB exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM gipi_witem b480
                 WHERE b480.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_WITEM exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM gipi_open_liab b910
                 WHERE b910.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_OPEN_LIAB exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM gipi_lim_liab b190
                 WHERE b190.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_LIM_LIAB exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM gipi_item b170
                 WHERE b170.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_ITEM exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giri_wdistfrps d100
                 WHERE d100.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIRI_WDISTFRPS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giri_distfrps d060
                 WHERE d060.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIRI_DISTFRPS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_bank_collns gcba
                 WHERE gcba.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_BANK_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_chk_disbursement gchd
                 WHERE gchd.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_CHK_DISBURSEMENT exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_collection_dtl gicd
                 WHERE gicd.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_COLLECTION_DTL exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_comm_payts gicp
                 WHERE gicp.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_COMM_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_direct_prem_collns gdpc
                 WHERE gdpc.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_DIRECT_PREM_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_intreaty_qtr_soa giqs
                 WHERE giqs.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INTREATY_QTR_SOA exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inwfacul_prem_collns gifc
                 WHERE gifc.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INWFACUL_PREM_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inw_oblig_collns gioc
                 WHERE gioc.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INW_OBLIG_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_loss_recoveries glre
                 WHERE glre.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_LOSS_RECOVERIES exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_loss_ri_collns gcrr
                 WHERE gcrr.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_LOSS_RI_COLLNS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_outfacul_prem_payts gfpp
                 WHERE gfpp.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_OUTFACUL_PREM_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_outward_oblig_payts goop
                 WHERE goop.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_OUTWARD_OBLIG_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_out_treaty_qtr_soa goqs
                 WHERE goqs.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_OUT_TREATY_QTR_SOA exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_aging_fc_soa_details gafd
                 WHERE gafd.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_AGING_FC_SOA_DETAILS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_direct_claim_payts gdcp
                 WHERE gdcp.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_DIRECT_CLAIM_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inwfacul_clm_payts gicl
                 WHERE gicl.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INWFACUL_CLM_PAYTS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inwfacul_branch_collns gibc
                 WHERE gibc.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_INWFACUL_BRANCH_COLLNS exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM giac_dcb_bank_dep gdbd
                 WHERE gdbd.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_DCB_BANK_DEP exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM giac_order_of_payts goop
                 WHERE goop.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_ORDER_OF_PAYTS exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM giac_spoiled_check gsc
                 WHERE gsc.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_SPOILED_CHECK exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM giac_spoiled_or_old gsoo
                 WHERE gsoo.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIAC_SPOILED_OR_OLD exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM gipi_quote_invoice gqi
                 WHERE gqi.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_QUOTE_INVOICE exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM gipi_winvoice gw
                 WHERE gw.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIPI_WINVOICE exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM giri_fac_reciprocity gfr
                 WHERE gfr.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIRI_FAC_RECIPROCITY exists.'
            );
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM giri_trty_reciprocity gtr
                 WHERE gtr.currency_cd = p_main_currency_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CURRENCY while dependent record(s) in GIRI_TRTY_RECIPROCITY exists.'
            );
         EXIT;
      END LOOP;
   END;
END;
/


