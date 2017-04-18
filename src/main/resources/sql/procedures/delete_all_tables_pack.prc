DROP PROCEDURE CPI.DELETE_ALL_TABLES_PACK;

CREATE OR REPLACE PROCEDURE CPI.delete_all_tables_pack (
   p_pack_par_id   IN       gipi_pack_wpolbas.pack_par_id%TYPE,
   p_line_cd       IN       gipi_wpolbas.line_cd%TYPE,
   p_subline_cd    IN       gipi_wpolbas.subline_cd%TYPE,
   p_iss_cd        IN       gipi_wpolbas.iss_cd%TYPE,
   p_issue_yy      IN       gipi_wpolbas.issue_yy%TYPE,
   p_pol_seq_no    IN       gipi_wpolbas.pol_seq_no%TYPE,
   p_renew_no      IN       gipi_wpolbas.renew_no%TYPE,
   p_eff_date      IN       gipi_wpolbas.eff_date%TYPE, 
   p_msg_alert     OUT      VARCHAR2
)
AS
/*
   **  Created by    : Mark JM
   **  Date Created  : 07.09.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This procedure is used for deleting records using the given par_id
   */
   v_dist_no        giuw_pol_dist.dist_no%TYPE;
   v_frps_yy        giri_wdistfrps.frps_yy%TYPE;
   v_frps_seq_no    giri_wdistfrps.frps_seq_no%TYPE;
   v_ann_tsi_amt    gipi_wpolbas.ann_tsi_amt%TYPE;
   v_ann_prem_amt   gipi_wpolbas.ann_prem_amt%TYPE;
   v_par_id_1       gipi_polbasic.par_id%TYPE;
BEGIN
   
   FOR c1 IN (SELECT par_id, line_cd, iss_cd
                FROM gipi_parlist
               WHERE pack_par_id = p_pack_par_id)
   LOOP
      v_par_id_1 := c1.par_id;

      DELETE      gipi_wengg_basic
            WHERE par_id = v_par_id_1;
--variables.v_par_id;  --A.R.C. 07.27.2006 -- modified by adrel 12172008 and succeeding variables.v_par_id's

      DELETE      gipi_wprincipal
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wlocation
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_waccident_item
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_waviation_item
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wves_air
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wvehicle
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wmcacc
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wcasualty_item
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wbeneficiary
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wbond_basic
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_witem_ves
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wcargo
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wopen_cargo
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wopen_peril
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wopen_liab
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wlim_liab
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wgrp_items_beneficiary
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wgrouped_items
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wfireitm
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wcosigntry
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wdeductibles
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wcomm_inv_perils
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wcomm_invoices
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wpackage_inv_tax
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_winstallment
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_winvoice
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_winvperl
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_winv_tax
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_witmperl
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_witem
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wperil_discount
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wpolnrep
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wpolwc
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wreqdocs
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      DELETE      gipi_wves_accumulation
            WHERE par_id = v_par_id_1;
                                   --variables.v_par_id;  --A.R.C. 07.27.2006

      BEGIN
         SELECT dist_no
           INTO v_dist_no
           FROM giuw_pol_dist
          WHERE par_id = v_par_id_1;
                                    --variables.v_par_id;  --A.R.C. 07.27.2006

         DELETE      giuw_witemperilds_dtl
               WHERE dist_no = v_dist_no;

         DELETE      giuw_witemperilds
               WHERE dist_no = v_dist_no;

         DELETE      giuw_wperilds_dtl
               WHERE dist_no =  v_dist_no;

         DELETE      giuw_wperilds
               WHERE dist_no =  v_dist_no;

         DELETE      giuw_witemds_dtl
               WHERE dist_no =  v_dist_no;

         DELETE      giuw_witemds
               WHERE dist_no =  v_dist_no;

         BEGIN
            SELECT   frps_yy, frps_seq_no
                INTO v_frps_yy,  v_frps_seq_no
                FROM giri_wdistfrps
               WHERE dist_no =  v_dist_no
            GROUP BY frps_yy, frps_seq_no;

            DELETE      giri_wfrperil
                  WHERE frps_yy =  v_frps_yy AND frps_seq_no =  v_frps_seq_no;

            DELETE      giri_wfrps_ri
                  WHERE frps_yy =  v_frps_yy AND frps_seq_no =  v_frps_seq_no;

            DELETE      giri_wdistfrps
                  WHERE frps_yy =  v_frps_yy AND frps_seq_no =  v_frps_seq_no;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               NULL;
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         DELETE      giuw_wpolicyds_dtl
               WHERE dist_no =  v_dist_no;

         DELETE      giuw_wpolicyds
               WHERE dist_no = v_dist_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      
      Get_Amounts(v_par_id_1, p_line_cd, p_subline_cd, p_iss_cd,
        p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 
        v_ann_tsi_amt, v_ann_prem_amt,    p_msg_alert);
   END LOOP;
--     removed by robert GENQA 4844 09.02.15
--     DELETE FROM gipi_pack_winstallment
--       WHERE  pack_par_id  =  p_pack_par_id;
--     
--     DELETE FROM gipi_pack_winvperl
--       WHERE  pack_par_id  =  p_pack_par_id;
--     
--     DELETE FROM gipi_pack_winv_tax
--       WHERE  pack_par_id  =  p_pack_par_id;
--     
--     DELETE FROM gipi_pack_winvoice
--       WHERE  pack_par_id  =  p_pack_par_id;
--     
--     DELETE FROM gipi_pack_winvperl
--       WHERE  pack_par_id  = p_pack_par_id;
-- 
--     DELETE FROM gipi_pack_wpolnrep
--       WHERE  pack_par_id  = p_pack_par_id;
--  
--     DELETE FROM gipi_pack_wpolwc
--       WHERE  pack_par_id  = p_pack_par_id;
--       
--     DELETE FROM gipi_pack_winstallment
--       WHERE  pack_par_id  =  p_pack_par_id;
--
--     DELETE FROM gipi_wpack_line_subline
--       WHERE  pack_par_id  =  p_pack_par_id;
END;
/


