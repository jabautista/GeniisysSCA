CREATE OR REPLACE PACKAGE BODY CPI.giri_wfrps_ri_pkg
AS
   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.17.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Contains the Insert / Update / Delete procedure of the table
   */
   PROCEDURE del_giri_wfrps_ri (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
   IS
   BEGIN
      DELETE      giri_wfrps_ri
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;
   END del_giri_wfrps_ri;

   PROCEDURE del_giri_wfrps_ri_1 (
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
   IS
   BEGIN
      DELETE      giri_wfrps_ri
            WHERE frps_yy = p_frps_yy AND frps_seq_no = p_frps_seq_no;
   END del_giri_wfrps_ri_1;

   PROCEDURE del_giri_wfrps_ri_2 (
        p_line_cd       giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE,
        p_ri_seq_no     giri_wfrps_ri.ri_seq_no%TYPE
        ) IS
   BEGIN
      DELETE giri_wfrps_ri
       WHERE line_cd = p_line_cd
         AND frps_yy = p_frps_yy
         AND frps_seq_no = p_frps_seq_no
         AND ri_seq_no = p_ri_seq_no;
   END del_giri_wfrps_ri_2;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 06.23.2011
   **  Reference By     : (GIRIS001- Create RI Placement)
   **  Description   : Count records in giri_wfrps_ri table
   */
   FUNCTION count_giri_wfrps_ri (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      count_rec   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO count_rec
        FROM giri_wfrps_ri
       WHERE line_cd = p_line_cd
         AND frps_yy = p_frps_yy
         AND frps_seq_no = p_frps_seq_no;

      RETURN count_rec;
   END;

   /*
   **  Created by       : D.Alcantara
   **  Date Created     : 06.27.2011
   **  Reference By     : (GIRIS002- Enter RI Acceptance)
   **  Description      : Retrieves giri_wfrps_ri records
   */
   FUNCTION get_giri_wfrps_ri (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
      RETURN giri_wfrps_ri_tab PIPELINED
   IS
      v_wfrps_ri   giri_wfrps_ri_type;
   BEGIN
      FOR i IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                       pre_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                       ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt,
                       prem_tax, bndr_remarks1, bndr_remarks2, bndr_remarks3,
                       remarks, ri_as_no, ri_accept_by, ri_accept_date,
                       ri_shr_pct2, ri_prem_vat, ri_comm_vat, address1,
                       address2, address3
                  FROM giri_wfrps_ri
                 WHERE line_cd = p_line_cd
                   AND frps_yy = p_frps_yy
                   AND frps_seq_no = p_frps_seq_no
                   AND NVL (delete_sw, 'N') = 'N'
                   AND NVL (reverse_sw, 'N') = 'N')
      LOOP
         v_wfrps_ri.line_cd := i.line_cd;
         v_wfrps_ri.frps_yy := i.frps_yy;
         v_wfrps_ri.frps_seq_no := i.frps_seq_no;
         v_wfrps_ri.ri_seq_no := i.ri_seq_no;
         v_wfrps_ri.ri_cd := i.ri_cd;
         v_wfrps_ri.pre_binder_id := i.pre_binder_id;
         v_wfrps_ri.ri_shr_pct := i.ri_shr_pct;
         v_wfrps_ri.ri_tsi_amt := i.ri_tsi_amt;
         v_wfrps_ri.ri_prem_amt := i.ri_prem_amt;
         v_wfrps_ri.ann_ri_s_amt := i.ann_ri_s_amt;
         v_wfrps_ri.ann_ri_pct := i.ann_ri_pct;
         v_wfrps_ri.ri_comm_rt := i.ri_comm_rt;
         v_wfrps_ri.ri_comm_amt := i.ri_comm_amt;
         v_wfrps_ri.prem_tax := i.prem_tax;
         v_wfrps_ri.bndr_remarks1 := i.bndr_remarks1;
         v_wfrps_ri.bndr_remarks2 := i.bndr_remarks2;
         v_wfrps_ri.bndr_remarks3 := i.bndr_remarks3;
         v_wfrps_ri.remarks := i.remarks;
         v_wfrps_ri.ri_as_no := i.ri_as_no;
         v_wfrps_ri.ri_accept_by := i.ri_accept_by;
         v_wfrps_ri.ri_accept_date := i.ri_accept_date;
         v_wfrps_ri.ri_shr_pct2 := i.ri_shr_pct;
         v_wfrps_ri.ri_prem_vat := i.ri_prem_vat;
         v_wfrps_ri.ri_comm_vat := i.ri_comm_vat;
         v_wfrps_ri.address1 := i.address1;
         v_wfrps_ri.address2 := i.address2;
         v_wfrps_ri.address3 := i.address3;

         FOR j IN (SELECT giis_reinsurer.ri_sname, giis_reinsurer.ri_name, giis_reinsurer.local_foreign_sw
                     FROM giis_reinsurer giis_reinsurer
                    WHERE giis_reinsurer.ri_cd = i.ri_cd)
         LOOP
            v_wfrps_ri.ri_sname := j.ri_sname;
            v_wfrps_ri.ri_name := j.ri_name;
            v_wfrps_ri.local_foreign_sw := j.local_foreign_sw;
         END LOOP;
         
         v_wfrps_ri.net_due := NVL(i.ri_prem_amt, 0) - NVL(i.prem_tax, 0) -
                NVL(i.ri_comm_amt,0) + NVL(i.ri_prem_vat,0) - NVL(i.ri_comm_vat,0);
         
         v_wfrps_ri.dsp_fnl_binder_id := null; -- bonok :: 10.17.2012
                
         FOR k IN (SELECT fnl_binder_id
                       FROM giri_frps_ri
                      WHERE fnl_binder_id = i.pre_binder_id)
         LOOP
            v_wfrps_ri.dsp_fnl_binder_id := k.fnl_binder_id;
            --EXIT; bonok :: 10.17.2012
         END LOOP;
         
         PIPE ROW (v_wfrps_ri);
      END LOOP;
   END get_giri_wfrps_ri;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 06.28.2011
   **  Reference By     : (GIRIS001- Create RI Placement)
   **  Description      : Retrieves the giri_wfrps_ri records
   */
   FUNCTION get_giri_wfrps_ri2 (
        p_line_cd       giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
        ) RETURN giri_wfrps_ri_tab PIPELINED
   IS
      v_wfrps_ri   giri_wfrps_ri_type;
   BEGIN
      FOR i IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                       pre_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                       ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt,
                       prem_tax, other_charges, renew_sw, reverse_sw,
                       facoblig_sw, bndr_remarks1, bndr_remarks2,
                       bndr_remarks3, delete_sw, remarks, last_update,
                       ri_as_no, ri_accept_by, ri_accept_date, ri_shr_pct2,
                       ri_prem_vat, ri_comm_vat, address1, address2,
                       address3, prem_warr_days, prem_warr_tag, arc_ext_data
                  FROM giri_wfrps_ri
                 WHERE line_cd = p_line_cd
                   AND frps_yy = p_frps_yy
                   AND frps_seq_no = p_frps_seq_no
                   AND NVL (delete_sw, 'N') = 'N'
                   AND NVL (reverse_sw, 'N') = 'N')
      LOOP
         v_wfrps_ri.line_cd         := i.line_cd;
         v_wfrps_ri.frps_yy         := i.frps_yy;
         v_wfrps_ri.frps_seq_no     := i.frps_seq_no;
         v_wfrps_ri.ri_seq_no       := i.ri_seq_no;
         v_wfrps_ri.ri_cd           := i.ri_cd;
         v_wfrps_ri.pre_binder_id   := i.pre_binder_id;
         v_wfrps_ri.ri_shr_pct      := i.ri_shr_pct;
         v_wfrps_ri.ri_tsi_amt      := i.ri_tsi_amt;
         v_wfrps_ri.ri_prem_amt     := i.ri_prem_amt;
         v_wfrps_ri.ann_ri_s_amt    := i.ann_ri_s_amt;
         v_wfrps_ri.ann_ri_pct      := i.ann_ri_pct;
         v_wfrps_ri.ri_comm_rt      := i.ri_comm_rt;
         v_wfrps_ri.ri_comm_amt     := i.ri_comm_amt;
         v_wfrps_ri.prem_tax        := i.prem_tax;
         v_wfrps_ri.other_charges   := i.other_charges;
         v_wfrps_ri.renew_sw        := i.renew_sw;
         v_wfrps_ri.reverse_sw      := i.reverse_sw;
         v_wfrps_ri.facoblig_sw     := i.facoblig_sw;
         v_wfrps_ri.bndr_remarks1   := i.bndr_remarks1;
         v_wfrps_ri.bndr_remarks2   := i.bndr_remarks2;
         v_wfrps_ri.bndr_remarks3   := i.bndr_remarks3;
         v_wfrps_ri.delete_sw       := i.delete_sw;
         v_wfrps_ri.remarks         := i.remarks;
         v_wfrps_ri.last_update     := i.last_update;
         v_wfrps_ri.ri_as_no        := i.ri_as_no;
         v_wfrps_ri.ri_accept_by    := i.ri_accept_by;
         v_wfrps_ri.ri_accept_date  := i.ri_accept_date;
         v_wfrps_ri.ri_shr_pct2     := i.ri_shr_pct2;
         v_wfrps_ri.ri_prem_vat     := i.ri_prem_vat;
         v_wfrps_ri.ri_comm_vat     := i.ri_comm_vat;
         v_wfrps_ri.address1        := i.address1;
         v_wfrps_ri.address2        := i.address2;
         v_wfrps_ri.address3        := i.address3;
         v_wfrps_ri.prem_warr_days  := i.prem_warr_days;
         v_wfrps_ri.prem_warr_tag   := i.prem_warr_tag;
         v_wfrps_ri.arc_ext_data    := i.arc_ext_data;

         IF v_wfrps_ri.ri_shr_pct IS NOT NULL
            AND v_wfrps_ri.ri_shr_pct2 IS NULL
         THEN
            v_wfrps_ri.ri_shr_pct2 := v_wfrps_ri.ri_shr_pct;
         END IF;

         SELECT COUNT (fnl_binder_id)
           INTO v_wfrps_ri.giri_frps_ri_ctr
           FROM giri_frps_ri
          WHERE fnl_binder_id = v_wfrps_ri.pre_binder_id;

         FOR j IN (SELECT giis_reinsurer.ri_sname, giis_reinsurer.ri_name
                     FROM giis_reinsurer giis_reinsurer
                    WHERE giis_reinsurer.ri_cd = i.ri_cd)
         LOOP
            v_wfrps_ri.ri_sname := j.ri_sname;
            v_wfrps_ri.ri_name  := j.ri_name;
         END LOOP;

         IF v_wfrps_ri.total_ri_shr_pct IS NULL
            AND v_wfrps_ri.total_ri_tsi_amt IS NULL
            AND v_wfrps_ri.total_ri_shr_pct2 IS NULL
            AND v_wfrps_ri.total_ri_prem_amt IS NULL
         THEN
           giri_wfrps_ri_pkg.get_giri_wfrps_ri2_totals(p_line_cd, p_frps_yy, p_frps_seq_no, v_wfrps_ri.total_ri_shr_pct, v_wfrps_ri.total_ri_tsi_amt, v_wfrps_ri.total_ri_shr_pct2, v_wfrps_ri.total_ri_prem_amt);
         END IF;

         PIPE ROW (v_wfrps_ri);
      END LOOP;
   END get_giri_wfrps_ri2;
 
    /*
     **  Created by       : Andrew Robes
     **  Date Created     : 01.02.2012
     **  Reference By     : (GIRIS001 - Create RI Placement)
     **  Description      : retrieves the total amounts display
     */

    PROCEDURE get_giri_wfrps_ri2_totals(
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE,
      p_total_ri_shr_pct  OUT NUMBER,
      p_total_ri_tsi_amt  OUT NUMBER,
      p_total_ri_shr_pct2    OUT NUMBER,
      p_total_ri_prem_amt OUT NUMBER
    ) IS
    BEGIN
        SELECT SUM(ri_shr_pct) total_ri_shr_pct, SUM(ri_tsi_amt) total_ri_tsi_amt, --SUM(ri_shr_pct2) total_ri_shr_pct2, replaced by: Nica 02.06.2013 
               SUM(NVL(ri_shr_pct2, ri_shr_pct)), SUM(ri_prem_amt) total_ri_prem_amt
          INTO p_total_ri_shr_pct, p_total_ri_tsi_amt, p_total_ri_shr_pct2, p_total_ri_prem_amt
          FROM giri_wfrps_ri
         WHERE line_cd = p_line_cd
           AND frps_yy = p_frps_yy
           AND frps_seq_no = p_frps_seq_no
           AND NVL (delete_sw, 'N') = 'N'
           AND NVL (reverse_sw, 'N') = 'N';
    END get_giri_wfrps_ri2_totals;

    /*
     **  Created by       : Anthony Santos
     **  Date Created     : 06.29.2011
     **  Reference By     : (GIRIS026- Post FRPS
     **
     */
   PROCEDURE delete_records_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no       giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_dist_seq_no   giri_distfrps_wdistfrps_v.dist_seq_no%TYPE
   )
   IS
      CURSOR tmp_area
      IS
         SELECT pre_binder_id
           FROM giri_wfrps_ri
          WHERE line_cd = p_line_cd
            AND frps_yy = p_frps_yy
            AND frps_seq_no = p_frps_seq_no;
   BEGIN
      --:gauge.file := 'Deleting records from giri_wbinder.';
      --vbx_counter;
      FOR c1_rec IN tmp_area
      LOOP
         DELETE FROM giri_wbinder_peril
               WHERE pre_binder_id = c1_rec.pre_binder_id;

         DELETE FROM giri_wbinder
               WHERE pre_binder_id = c1_rec.pre_binder_id;
      END LOOP;

      --:gauge.file := 'Deleting records from giri_wfrperil.';
      --vbx_counter;
      DELETE FROM giri_wfrperil
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;

      --:gauge.file := 'Deleting records from giri_wfrps_ri.';
      --vbx_counter;
      DELETE FROM giri_wfrps_ri
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;

      --:gauge.file := 'Deleting records from giri_wfrps_peril_grp.';
      --vbx_counter;
      DELETE FROM giri_wfrps_peril_grp
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;

      --:gauge.file := 'Deleting records from giri_wdistfrps.';
      --vbx_counter;
      DELETE FROM giri_wdistfrps
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;

      --:gauge.file := 'Deleting records from giuw_wperilds_dtl.';
      --vbx_counter;
      DELETE FROM giuw_wperilds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_wperilds.';
      --vbx_counter;
      DELETE FROM giuw_wperilds
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_witemperilds_dtl.';
      DELETE FROM giuw_witemperilds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_witemperilds.';
      DELETE FROM giuw_witemperilds
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_witemds_dtl.';
      --vbx_counter;
      DELETE FROM giuw_witemds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_witemds.';
      --vbx_counter;
      DELETE FROM giuw_witemds
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_wpolicyds_dtl.';
      --vbx_counter;
      DELETE FROM giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      --:gauge.file := 'Deleting records from giuw_wpolicyds.';
      --vbx_counter;
      DELETE FROM giuw_wpolicyds
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;
   END delete_records_giris026;
   
     /*
     **  Created by       : Jerome Orio 
     **  Date Created     : 06.30.2011
     **  Reference By     : (GIRIS001- Create RI Placement) 
     **
     */   
   PROCEDURE get_warr_days(
        p_line_cd           IN  giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy           IN  giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no       IN  giri_wfrps_ri.frps_seq_no%TYPE,
        p_prem_warr_tag        OUT gipi_polbasic.prem_warr_tag%type,
        p_prem_warr_days    OUT gipi_polbasic.prem_warr_days%type
        ) IS
   BEGIN
     FOR a IN (SELECT b.line_cd, b.frps_yy, b.frps_seq_no, b.dist_no, c.par_id
                 FROM giri_wdistfrps b, giuw_pol_dist c
                WHERE 1 = 1
                  AND b.dist_no = c.dist_no
                  AND b.line_cd = p_line_cd
                  AND b.frps_yy = p_frps_yy
                  AND b.frps_seq_no = p_frps_seq_no)
     LOOP
        FOR b IN
            (SELECT prem_warr_days,prem_warr_tag
               FROM gipi_wpolbas
              WHERE par_id = a.par_id
              UNION
               SELECT prem_warr_days,prem_warr_tag
               FROM gipi_polbasic
              WHERE par_id = a.par_id)
        LOOP
            p_prem_warr_tag        :=b.prem_warr_tag;
            p_prem_warr_days    :=b.prem_warr_days;
        END LOOP;
     END LOOP;    
   END;
   
     /*
     **  Created by       : D.Alcantara
     **  Date Created     : 07.01.2011
     **  Reference By     : (GIRIS001- Create RI Placement) 
     **
     */  
   PROCEDURE update_wfrps_ri (
      p_line_cd            giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy            giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no        giri_wfrps_ri.frps_seq_no%TYPE,
      p_ri_seq_no          giri_wfrps_ri.ri_seq_no%TYPE,
      p_ri_cd              giri_wfrps_ri.ri_cd%TYPE,
      p_address1           giri_wfrps_ri.address1%TYPE,
      p_address2           giri_wfrps_ri.address2%TYPE,
      p_address3           giri_wfrps_ri.address3%TYPE,
      p_remarks            giri_wfrps_ri.remarks%TYPE,
      p_bndr_remarks1      giri_wfrps_ri.bndr_remarks1%TYPE,
      p_bndr_remarks2      giri_wfrps_ri.bndr_remarks2%TYPE,
      p_bndr_remarks3      giri_wfrps_ri.bndr_remarks3%TYPE,
      p_ri_accept_by       giri_wfrps_ri.ri_accept_by%TYPE,
      p_ri_as_no           giri_wfrps_ri.ri_as_no%TYPE,
      p_ri_accept_date     giri_wfrps_ri.ri_accept_date%TYPE,
      p_ri_shr_pct         giri_wfrps_ri.ri_shr_pct%TYPE,
      p_ri_prem_amt        giri_wfrps_ri.ri_prem_amt%TYPE, 
      p_ri_tsi_amt         giri_wfrps_ri.ri_tsi_amt%TYPE,
      p_ri_comm_amt        giri_wfrps_ri.ri_comm_amt%TYPE,
      p_ri_comm_rt         giri_wfrps_ri.ri_comm_rt%TYPE,
      p_ri_prem_vat        giri_wfrps_ri.ri_prem_vat%TYPE,
      p_ri_comm_vat        giri_wfrps_ri.ri_comm_vat%TYPE,
      p_prem_tax           giri_wfrps_ri.prem_tax%TYPE
   ) IS
   BEGIN
      UPDATE giri_wfrps_ri
         SET  address1          = p_address1,
              address2          = p_address2,
              address3          = p_address3,
              remarks           = p_remarks,
              bndr_remarks1     = p_bndr_remarks1,
              bndr_remarks2     = p_bndr_remarks2,
              bndr_remarks3     = p_bndr_remarks3,
              ri_accept_by      = p_ri_accept_by,
              ri_as_no          = p_ri_as_no,
              ri_accept_date    = p_ri_accept_date,
              
              ri_shr_pct        = p_ri_shr_pct,
              ri_prem_amt       = p_ri_prem_amt,
              ri_tsi_amt        = p_ri_tsi_amt,
              ri_comm_amt       = p_ri_comm_amt,
              ri_comm_rt        = p_ri_comm_rt,
              ri_prem_vat       = p_ri_prem_vat,
              ri_comm_vat       = p_ri_comm_vat,
              prem_tax          = p_prem_tax,
              
              last_update       = SYSDATE
        WHERE line_cd           = p_line_cd AND
              frps_yy           = p_frps_yy AND
              frps_seq_no       = p_frps_seq_no AND
              ri_seq_no         = p_ri_seq_no AND
              ri_cd             = p_ri_cd;
   END update_wfrps_ri;
        
     /*
     **  Created by       : Jerome Orio 
     **  Date Created     : 07.05.2011
     **  Reference By     : (GIRIS001- Create RI Placement) 
     **  Description      : to adjust the value of ri_prem_vat , ADJUST_PREM_VAT program unit 
     */ 
    PROCEDURE ADJUST_PREM_VAT(
        p_prem_vat          IN OUT NUMBER,
        p_ri_cd             IN NUMBER,
        p_line_cd           IN gipi_parlist.line_cd%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2
        ) IS
      v_par_id          gipi_parlist.par_id%TYPE;
      v_par_status      gipi_parlist.par_status%TYPE;
      v_booking         DATE;
      v_pol_flag        gipi_polbasic.pol_flag%TYPE;
      v_prem_vat        VARCHAR2(1):='N';
      v_acrpv            giis_parameters.param_value_v%TYPE;
      v_cpvf            giis_parameters.param_value_v%TYPE;
      v_loc_sw            giis_reinsurer.local_foreign_sw%TYPE;
      v_ri_iss_cd       giis_issource.iss_cd%TYPE;  -- added by aaron 021209
    BEGIN
        
        FOR x IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'ISS_CD_RI')
        LOOP
            v_ri_iss_cd := x.param_value_v;
          EXIT;
        END LOOP;           
        
        
        --added by rose b.(06302008)--       
        BEGIN
        SELECT param_value_v
          INTO v_acrpv
          FROM giis_parameters
             WHERE PARAM_NAME = 'AUTO_COMPUTE_RI_PREM_VAT';
        EXCEPTION
            WHEN no_data_found THEN
                v_acrpv:= 'N';
        END;
        /*added by VJ 071808*/
        BEGIN
        SELECT param_value_v
          INTO v_cpvf
          FROM giis_parameters
             WHERE PARAM_NAME = 'COMPUTE_PREM_VAT_FOREIGN';
        EXCEPTION
            WHEN no_data_found THEN
                v_cpvf:= 'N';
        END;
        BEGIN
        SELECT local_foreign_sw
          INTO v_loc_sw
          FROM giis_reinsurer
             WHERE ri_cd = p_ri_cd;
        EXCEPTION
            WHEN no_data_found THEN
                v_loc_sw:= 'L';
        END;    
        /*end VJ*/
      FOR c1 IN (SELECT par_id, par_status
                   FROM gipi_parlist
                  WHERE line_cd = p_line_cd
                    AND iss_cd = p_iss_cd
                    AND par_yy = p_par_yy
                    AND par_seq_no = p_par_seq_no)
      LOOP
        v_par_id := c1.par_id;
        v_par_status := c1.par_status;
      END LOOP;        
        IF v_par_status = 10 THEN
                FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                             FROM gipi_polbasic
                            WHERE par_id = v_par_id)
                LOOP
                    v_booking := TO_DATE(c1.booking_mth||'/'||c1.booking_year,'MONTH/YYYY');
                    v_pol_flag := c1.pol_flag;
                END LOOP;                      
        ELSE
            FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                     FROM gipi_wpolbas
                    WHERE par_id = v_par_id)
            LOOP
                v_booking := TO_DATE(c1.booking_mth||'/'||c1.booking_year,'MONTH/YYYY');
                v_pol_flag := c1.pol_flag;
            END LOOP;        
        END IF;


      
     IF p_iss_cd = v_ri_iss_cd AND v_cpvf = 'Y' AND v_loc_sw != 'L' THEN  -- inward aron 021209        
          p_prem_vat := p_prem_vat;
     ELSE

          
      IF v_pol_flag = '4' THEN
        FOR c1 IN (SELECT policy_id
                     FROM gipi_polbasic
                    WHERE line_cd = p_line_cd 
                      AND subline_cd = p_subline_cd 
                      AND iss_cd = p_iss_cd 
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND endt_seq_no = 0)
        LOOP
            FOR c2 IN (SELECT 1
                                         FROM GIRI_BINDER d, GIRI_FRPS_RI C, GIRI_DISTFRPS b, GIUW_POL_DIST a
                                        WHERE d.fnl_binder_id = C.fnl_binder_id
                                          AND d.reverse_date IS NULL                                      
                                          AND d.ri_cd = p_ri_cd
                                          AND d.ri_prem_vat IS NOT NULL
                                          AND C.line_cd = b.line_cd
                                          AND C.frps_yy = b.frps_yy
                                          AND C.frps_seq_no = b.frps_seq_no
                                          AND b.dist_no = a.dist_no
                                          AND a.policy_id = c1.policy_id) 
            LOOP
                v_prem_vat := 'Y';
            END LOOP;                
        END LOOP;      
        IF v_prem_vat = 'N' THEN
            p_prem_vat := 0;
        ELSE    
            --p_prem_vat := p_prem_vat;--comment by VJ 052808 replaced by conditions below. to correct seici issue. :)
            /*VJ 071808 modified conditions in order to handle PNGs setup with taxes*/
                IF v_acrpv = 'Y' THEN
                    IF v_cpvf = 'N' THEN /*v_loc_sw = 'L' THEN  
                        p_prem_vat := p_prem_vat; */ --**replaced by jason 8/1/2008: check param values first befroe checking if the RI is Local Or Foreign
                        
                        --for local clients
                        p_prem_vat := 0;
                    ELSE 
                        --for foreign clients
                        IF v_loc_sw = 'L' THEN --v_cpvf = 'Y' THEN  --**replaced by jason 8/1/2008
                            p_prem_vat := p_prem_vat;
                        ELSE
                            p_prem_vat := 0;
                        END IF;
                    END IF;
                ELSIF v_acrpv = 'N' THEN
                    IF v_booking >= TO_DATE('APRIL/2007','MONTH/YYYY') THEN
                    p_prem_vat := 0; 
                ELSE             
                        IF v_cpvf = 'N' THEN  --v_loc_sw = 'L' THEN  --replaced by jason 8/1/2008
                                p_prem_vat := 0;
                        ELSE
                            IF v_loc_sw = 'L' THEN  --v_cpvf = 'Y' THEN  --replaced by jason 8/1/2008
                                --p_prem_vat := p_prem_vat;  
                                p_prem_vat := 0;  -- jason 8/1/2008: prem vat should be zero since auto compute is set to 'N'
                            ELSE
                                p_prem_vat := 0;
                            END IF;
                        END IF;
                END IF;
                END IF;
        END IF;--V_PREM_VAT = 'Y'
      ELSE -- if pol flag <> 4
                IF v_acrpv = 'Y' THEN
                    IF v_cpvf = 'N' THEN /*v_loc_sw = 'L' THEN  
                        p_prem_vat := p_prem_vat; */ --**replaced by jason 8/1/2008: check param values first befroe checking if the RI is Local Or Foreign
                        
                        --for local clients
                        p_prem_vat := 0;
                    ELSE 
                        --for foreign clients
                        IF v_loc_sw = 'L' THEN --v_cpvf = 'Y' THEN  --**replaced by jason 8/1/2008
                            p_prem_vat := p_prem_vat;
                        ELSE
                            p_prem_vat := 0;
                        END IF;
                    END IF;
                ELSIF v_acrpv = 'N' THEN
                    IF v_booking >= TO_DATE('APRIL/2007','MONTH/YYYY') THEN
                    p_prem_vat := 0; 
                ELSE             
                        IF v_cpvf = 'N' THEN  --v_loc_sw = 'L' THEN  --replaced by jason 8/1/2008
                                p_prem_vat := 0;
                        ELSE
                            IF v_loc_sw = 'L' THEN  --v_cpvf = 'Y' THEN  --replaced by jason 8/1/2008
                                --p_prem_vat := p_prem_vat;  
                                p_prem_vat := 0;  -- jason 8/1/2008: prem vat should be zero since auto compute is set to 'N'
                            ELSE
                                p_prem_vat := 0;
                            END IF;
                        END IF;
                END IF;
                END IF;        
        END IF;
    END IF; 
    END;
           
    /*
     **  Created by       : Jerome Orio 
     **  Date Created     : 07.05.2011
     **  Reference By     : (GIRIS001- Create RI Placement) 
     **  Description      : COMPUTE_RI_PREM_AMT program unit 
     */ 
    PROCEDURE COMPUTE_RI_PREM_AMT(
        p_ri_prem_vat       IN OUT NUMBER,
        p_ri_cd             IN NUMBER,
        p_line_cd           IN gipi_parlist.line_cd%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_ri_shr_pct        IN NUMBER,
        p_ri_shr_pct2       IN OUT NUMBER,
        p_tot_fac_spct2     IN NUMBER,
        p_tot_fac_prem      IN  NUMBER,
        p_ri_prem_amt       OUT NUMBER
        ) IS
      v_input_vat    NUMBER;
    BEGIN
      FOR A IN (SELECT input_vat_rate
                  FROM giis_reinsurer
                 WHERE ri_cd = p_ri_cd)
      LOOP
        v_input_vat := a.input_vat_rate/100;
        EXIT;
      END LOOP;

        IF p_ri_shr_pct2 IS NULL THEN
             p_ri_shr_pct2 := p_ri_shr_pct;
        END IF;     
        --issa09.28.2007 added IF condition to prevent ora-01476 if dist is 100% facul for tsi, but prem = 0
      IF p_tot_fac_spct2 = 0 THEN
        p_ri_prem_amt := 0;
      ELSE
        --p_ri_prem_amt := round((p_ri_shr_pct2/p_tot_fac_spct2) * NVL(p_tot_fac_prem,0), 2); -- bonok :: 06.21.2013
        p_ri_prem_amt := (p_ri_shr_pct2/p_tot_fac_spct2) * NVL(p_tot_fac_prem,0); 
      END IF;
        
      --p_ri_prem_vat := round((p_ri_prem_amt * v_input_vat),2); -- bonok :: 06.21.2013
      p_ri_prem_vat := p_ri_prem_amt * v_input_vat;
      ADJUST_PREM_VAT(p_ri_prem_vat,     p_ri_cd, 
                      p_line_cd,         p_iss_cd,
                      p_par_yy,          p_par_seq_no,
                      p_subline_cd,      p_issue_yy,
                      p_pol_seq_no,      p_renew_no); 
    END;
   
     /*
     **  Created by       : Jerome Orio 
     **  Date Created     : 07.05.2011
     **  Reference By     : (GIRIS001- Create RI Placement) 
     **  Description      : 
     */ 
    PROCEDURE compute_ri_prem_vat1(
        p_ri_prem_vat       IN OUT NUMBER,
        p_ri_cd             IN NUMBER,
        p_line_cd           IN gipi_parlist.line_cd%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_var2_prem         IN NUMBER
        ) IS
    BEGIN
        p_ri_prem_vat := (Giis_Reinsurer_Pkg.get_input_vat_rt(p_ri_cd)/100) * round(p_var2_prem,2);
        ADJUST_PREM_VAT(p_ri_prem_vat,     p_ri_cd, 
                      p_line_cd,         p_iss_cd,
                      p_par_yy,          p_par_seq_no,
                      p_subline_cd,      p_issue_yy,
                      p_pol_seq_no,      p_renew_no); 
    END;
   
   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 07.07.2011
   **  Reference By     : (GIRIS001- Create RI Placement)
   **  Description      : save giri_wfrps_ri records
   */   
    PROCEDURE set_giri_wfrps_ri(
        p_line_cd            giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy            giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no        giri_wfrps_ri.frps_seq_no%TYPE,
        p_ri_seq_no          giri_wfrps_ri.ri_seq_no%TYPE,
        p_ri_cd              giri_wfrps_ri.ri_cd%TYPE,
        p_orig_ri_cd         giri_wfrps_ri.ri_cd%TYPE,
        p_pre_binder_id      giri_wfrps_ri.pre_binder_id%TYPE,
        p_ri_shr_pct         giri_wfrps_ri.ri_shr_pct%TYPE,
        p_ri_tsi_amt         giri_wfrps_ri.ri_tsi_amt%TYPE,
        p_ri_prem_amt        giri_wfrps_ri.ri_prem_amt%TYPE,
        p_ann_ri_s_amt       giri_wfrps_ri.ann_ri_s_amt%TYPE,
        p_ann_ri_pct         giri_wfrps_ri.ann_ri_pct%TYPE,
        p_ri_comm_rt         giri_wfrps_ri.ri_comm_rt%TYPE,
        p_ri_comm_amt        giri_wfrps_ri.ri_comm_amt%TYPE,
        p_prem_tax           giri_wfrps_ri.prem_tax%TYPE,
        p_other_charges      giri_wfrps_ri.other_charges%TYPE,
        p_renew_sw           giri_wfrps_ri.renew_sw%TYPE,
        p_reverse_sw         giri_wfrps_ri.reverse_sw%TYPE,
        p_facoblig_sw        giri_wfrps_ri.facoblig_sw%TYPE,
        p_bndr_remarks1      giri_wfrps_ri.bndr_remarks1%TYPE,
        p_bndr_remarks2      giri_wfrps_ri.bndr_remarks2%TYPE,
        p_bndr_remarks3      giri_wfrps_ri.bndr_remarks3%TYPE,
        p_delete_sw          giri_wfrps_ri.delete_sw%TYPE,
        p_remarks            giri_wfrps_ri.remarks%TYPE,
        p_last_update        giri_wfrps_ri.last_update%TYPE,
        p_ri_as_no           giri_wfrps_ri.ri_as_no%TYPE,
        p_ri_accept_by       giri_wfrps_ri.ri_accept_by%TYPE,
        p_ri_accept_date     giri_wfrps_ri.ri_accept_date%TYPE,
        p_ri_shr_pct2        giri_wfrps_ri.ri_shr_pct2%TYPE,
        p_ri_prem_vat        giri_wfrps_ri.ri_prem_vat%TYPE,
        p_ri_comm_vat        giri_wfrps_ri.ri_comm_vat%TYPE,
        p_address1           giri_wfrps_ri.address1%TYPE,
        p_address2           giri_wfrps_ri.address2%TYPE,
        p_address3           giri_wfrps_ri.address3%TYPE,
        p_prem_warr_days     giri_wfrps_ri.prem_warr_days%TYPE,
        p_prem_warr_tag      giri_wfrps_ri.prem_warr_tag%TYPE,
        p_arc_ext_data       giri_wfrps_ri.arc_ext_data%TYPE
        ) IS   
    BEGIN
        MERGE INTO giri_wfrps_ri 
             USING dual
             ON (line_cd = p_line_cd
             AND frps_yy = p_frps_yy
             AND frps_seq_no = p_frps_seq_no
             AND ri_seq_no = p_ri_seq_no
             AND ri_cd = p_orig_ri_cd)
        WHEN NOT MATCHED THEN
            INSERT (line_cd, frps_yy, frps_seq_no, ri_seq_no,
                    ri_cd, pre_binder_id, ri_shr_pct, ri_tsi_amt, 
                    ri_prem_amt, ann_ri_s_amt, ann_ri_pct, ri_comm_rt, 
                    ri_comm_amt, prem_tax, other_charges, renew_sw, 
                    reverse_sw, facoblig_sw, bndr_remarks1, bndr_remarks2,
                    bndr_remarks3, delete_sw, remarks, last_update,
                    ri_as_no, ri_accept_by, ri_accept_date, ri_shr_pct2,
                    ri_prem_vat, ri_comm_vat, address1, address2,
                    address3, prem_warr_days, prem_warr_tag, arc_ext_data)
            VALUES (p_line_cd, p_frps_yy, p_frps_seq_no, p_ri_seq_no,
                    p_ri_cd, p_pre_binder_id, p_ri_shr_pct, p_ri_tsi_amt, 
                    p_ri_prem_amt, p_ann_ri_s_amt, p_ann_ri_pct, p_ri_comm_rt, 
                    p_ri_comm_amt, p_prem_tax, p_other_charges, p_renew_sw, 
                    p_reverse_sw, p_facoblig_sw, p_bndr_remarks1, p_bndr_remarks2,
                    p_bndr_remarks3, p_delete_sw, p_remarks, sysdate,
                    p_ri_as_no, p_ri_accept_by, p_ri_accept_date, p_ri_shr_pct2,
                    p_ri_prem_vat, p_ri_comm_vat, p_address1, p_address2,
                    p_address3, p_prem_warr_days, p_prem_warr_tag, p_arc_ext_data)     
        WHEN MATCHED THEN
            UPDATE SET --ri_cd            = p_ri_cd, 
                    pre_binder_id       = p_pre_binder_id, 
                    ri_shr_pct          = p_ri_shr_pct, 
                    ri_tsi_amt          = p_ri_tsi_amt, 
                    ri_prem_amt         = p_ri_prem_amt, 
                    ann_ri_s_amt        = p_ann_ri_s_amt, 
                    ann_ri_pct          = p_ann_ri_pct, 
                    ri_comm_rt          = p_ri_comm_rt, 
                    ri_comm_amt         = p_ri_comm_amt, 
                    prem_tax            = p_prem_tax, 
                    other_charges       = p_other_charges, 
                    renew_sw            = p_renew_sw, 
                    reverse_sw          = p_reverse_sw, 
                    facoblig_sw         = p_facoblig_sw, 
                    bndr_remarks1       = p_bndr_remarks1, 
                    bndr_remarks2       = p_bndr_remarks2,
                    bndr_remarks3       = p_bndr_remarks3, 
                    delete_sw           = p_delete_sw, 
                    remarks             = p_remarks, 
                    last_update         = sysdate,
                    ri_as_no            = p_ri_as_no, 
                    ri_accept_by        = p_ri_accept_by, 
                    ri_accept_date      = p_ri_accept_date, 
                    ri_shr_pct2         = p_ri_shr_pct2,
                    ri_prem_vat         = p_ri_prem_vat, 
                    ri_comm_vat         = p_ri_comm_vat, 
                    address1            = p_address1, 
                    address2            = p_address2,
                    address3            = p_address3, 
                    prem_warr_days      = p_prem_warr_days, 
                    prem_warr_tag       = p_prem_warr_tag, 
                    arc_ext_data        = p_arc_ext_data;               
    END;    
        
    /*
   **  Created by       : Jerome Orio
   **  Date Created     : 07.07.2011
   **  Reference By     : (GIRIS001- Create RI Placement)
   **  Description      : get_ri_seq_no program unit 
   */         
    PROCEDURE get_ri_seq_no(
        p_line_cd           IN giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy           IN giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no       IN giri_wfrps_ri.frps_seq_no%TYPE,
        p_max_ri_seq_no     OUT NUMBER
        ) IS
       v_master    giri_frps_ri.frps_seq_no%TYPE;
       v_working   giri_wfrps_ri.frps_seq_no%TYPE;
    BEGIN  
      BEGIN   
         SELECT MAX(ri_seq_no)+1 
           INTO v_master
           FROM giri_frps_ri
          WHERE line_cd     = p_line_cd
            AND frps_yy     = p_frps_yy
            AND frps_seq_no = p_frps_seq_no;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
      END;
      BEGIN
          SELECT MAX(ri_seq_no)+1
            INTO v_working
            FROM giri_wfrps_ri
           WHERE line_cd     = p_line_cd
             AND frps_yy     = p_frps_yy
             AND frps_seq_no = p_frps_seq_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
      IF v_master IS NULL THEN
        IF v_working IS NULL THEN
          p_max_ri_seq_no := 1;
        ELSE
          p_max_ri_seq_no := v_working;
        END IF;
      ELSE
        IF v_working IS NOT NULL THEN
          IF v_master > v_working THEN
            p_max_ri_seq_no := v_master;
          ELSE
            p_max_ri_seq_no := v_working;     
          END IF;
        ELSE
          p_max_ri_seq_no := v_master;
        END IF;
      END IF;
    END;  
   
    PROCEDURE UPDATE_PREM_TAX(
        p_ri_cd             IN giis_reinsurer.ri_cd%TYPE,
        p_ri_prem_amt       IN giri_wfrps_ri.ri_prem_amt%TYPE,
        p_prem_tax          OUT giri_wfrps_ri.prem_tax%TYPE
        ) IS
      v_tax        giis_parameters.param_value_n%type;
      v_cpvf  giis_parameters.param_value_v%type;  --jason 05152009
      local_foreign_reinsurer giis_reinsurer.local_foreign_sw%type;
    BEGIN
      BEGIN
          SELECT param_value_n
            INTO v_tax
            FROM giis_parameters 
           WHERE param_name like 'RI PREMIUM TAX';
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
            INSERT INTO giis_parameters
              (param_type, param_name, param_value_n)
            VALUES
              ('N', 'RI PREMIUM TAX', 0);
            v_tax :=0;    
      END;
      
      BEGIN
        SELECT param_value_v
          INTO v_cpvf
          FROM giis_parameters
             WHERE PARAM_NAME = 'COMPUTE_PREM_VAT_FOREIGN';
        EXCEPTION
            WHEN no_data_found THEN
                v_cpvf:= 'N';
        END;
      
      IF v_cpvf = 'Y' THEN  
        FOR r IN (SELECT local_foreign_sw 
                    FROM giis_reinsurer
                   WHERE ri_cd = p_ri_cd)
        LOOP 
            local_foreign_reinsurer := r.local_foreign_sw;
        END LOOP;
       
        IF local_foreign_reinsurer = 'L' THEN
            v_tax:=0;
        END IF;
      ELSE
        v_tax:=0;
      END IF;      
      p_prem_tax := (v_tax/100) * p_ri_prem_amt;
    END;   
   
   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 07.07.2011
   **  Reference By     : (GIRIS001- Create RI Placement)
   **  Description      : pre-insert d120 block 
   */     
    PROCEDURE pre_ins_giris001(
        p_line_cd           IN giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy           IN giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no       IN giri_wfrps_ri.frps_seq_no%TYPE,
        p_dist_no           IN giuw_pol_dist.dist_no%TYPE,
        p_ri_cd             IN giis_reinsurer.ri_cd%TYPE,
        p_ri_prem_amt       IN giri_wfrps_ri.ri_prem_amt%TYPE,
        p_prem_tax          OUT giri_wfrps_ri.prem_tax%TYPE,
        p_ri_seq_no         OUT NUMBER,
        p_binder_id         IN OUT NUMBER,
        p_renew_sw          OUT VARCHAR2
        ) IS
    BEGIN
       IF p_binder_id IS NULL THEN
           SELECT binder_id_s.NEXTVAL
             INTO p_binder_id
             FROM dual;
       END IF;
       BEGIN
          SELECT renew_flag 
            INTO p_renew_sw
            FROM gipi_polbasic T1
                ,giuw_pol_dist T2
           WHERE T1.policy_id = T2.policy_id
             AND T2.dist_no   = p_dist_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
       END;  
         
       UPDATE_PREM_TAX(p_ri_cd, p_ri_prem_amt, p_prem_tax);
        
       get_ri_seq_no(p_line_cd,     p_frps_yy, 
                     p_frps_seq_no, p_ri_seq_no);
    END;

   /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : UPDATE_RI_COMM program unit  
   */ 
    PROCEDURE UPDATE_RI_COMM(
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            gipi_parlist.iss_cd%TYPE,
        p_ri_seq_no         GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_reused_binder varchar2      
        ) IS
      v_input_vat_rt     GIIS_REINSURER.input_vat_rate%TYPE;
      param_value_v      GIIS_PARAMETERS.param_value_v%TYPE:='N';--added JEROME.O 07182008
      v_ri_cd            GIIS_ISSOURCE.iss_cd%TYPE;  -- aron 021209
      v_count_perl             NUMBER;  -- lemuel 11/25/2009
      v_perl_cd                     NUMBER;  -- lemuel 11/25/2009
      
      
      CURSOR tmp_area IS
        --SELECT a.ri_cd, SUM(a.ri_comm_amt) ri_comm_amt, local_foreign_sw, param_value_n 
        -- bonok :: 06.07.2013 :: recomputed ri_comm_amt to prevent getting a value that is rounded off 
        --                        to be able to compute for the exact ri_comm_rt 
        SELECT a.ri_cd, SUM(a.ri_prem_amt * (a.ri_comm_rt/100)) ri_comm_amt, local_foreign_sw, param_value_n, SUM(a.ri_prem_amt) ri_prem_amt--ADDED BY ROBERT :: 06.18.2013
          FROM GIRI_WFRPERIL a, GIIS_REINSURER b, GIIS_PARAMETERS c
         WHERE line_cd     = NVL(p_line_cd,line_cd)
           AND frps_yy     = NVL(p_frps_yy, frps_yy)
           AND frps_seq_no = NVL(p_frps_seq_no, frps_seq_no)
           AND a.ri_cd(+) = b.RI_CD
           AND c.param_name ='RI PREMIUM TAX'
      GROUP BY line_cd, frps_yy, frps_seq_no, a.ri_cd, local_foreign_sw, param_value_n;



    BEGIN

        FOR count_perl IN (SELECT COUNT(*) COUNT
                                                 FROM GIRI_WFRPERIL
                                                WHERE line_cd = p_line_cd
                                            AND frps_yy     = p_frps_yy
                                            AND frps_seq_no = p_frps_seq_no
                                            AND ri_seq_no = p_ri_seq_no)
      LOOP
        v_count_perl := count_perl.COUNT;
      END LOOP;

      
      FOR x IN (SELECT param_value_v
                          FROM GIIS_PARAMETERS
                         WHERE param_name = 'ISS_CD_RI')
      LOOP
        v_ri_cd := x.param_value_v;
        EXIT;
      END LOOP;
      
      
      IF v_count_perl = 1 THEN
        SELECT PERIL_CD 
          INTO v_perl_cd
         FROM GIRI_WFRPERIL
           WHERE line_cd = p_line_cd
           AND frps_yy     = p_frps_yy
           AND frps_seq_no = p_frps_seq_no
           AND ri_seq_no = p_ri_seq_no;
      END IF;
      
      
      FOR c1_rec IN tmp_area LOOP
            v_input_vat_rt := Giis_Reinsurer_Pkg.get_input_vat_rt(c1_rec.ri_cd)/100;
            /*
            IF c1_rec.local_foreign_sw != 'L' then        --L.D.G. 07-14-2008
            UPDATE giri_wfrps_ri
            SET ri_comm_amt = c1_rec.ri_comm_amt,
                ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2)
          WHERE line_cd     = :v100.line_cd
            AND frps_yy     = :v100.frps_yy
            AND frps_seq_no = :v100.frps_seq_no
            AND ri_cd       = c1_rec.ri_cd
            AND ri_prem_amt != 0;
            
        ELSE
            UPDATE giri_wfrps_ri
            SET ri_comm_amt = c1_rec.ri_comm_amt,
                ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                prem_tax = 0
          WHERE line_cd     = :v100.line_cd
            AND frps_yy     = :v100.frps_yy
            AND frps_seq_no = :v100.frps_seq_no
            AND ri_cd       = c1_rec.ri_cd
            AND ri_prem_amt != 0;
        END IF;                                                                        --L.D.G. 07-14-2008
            */
              
            --modify by JEROME.O 07182008
            --RI_PREM_VAT and RI_COMM_VAT will be ZERO(0) IF param_value_v = 'Y' WHERE PARAM_NAME = 'COMPUTE_PREM_VAT_FOREIGN'
                /*modified by VJ --RI_PREM_VAT and RI_COMM_VAT will NOT be ZERO(0) IF param_value_v = 'Y' WHERE PARAM_NAME = 'COMPUTE_PREM_VAT_FOREIGN'*/
            FOR r IN (SELECT param_value_v,param_name FROM GIIS_PARAMETERS
                                     WHERE PARAM_NAME = 'COMPUTE_PREM_VAT_FOREIGN')      
                LOOP 
                    param_value_v := r.param_value_v;
                END LOOP;

        
        
        
        IF v_ri_cd <> p_iss_cd THEN  -- outward 
        
        
        IF c1_rec.local_foreign_sw <> 'L' THEN   ----- foreign reinsurer aaron 021209    
            --IF param_value_v = 'Y' THEN --editted by MJ for consolidation 01022013
            IF param_value_v = 'Y' OR P_REUSED_BINDER = 'Y' THEN 
                --MSG_ALERT('FOR-Y','I',FALSE);
                IF v_count_perl > 1 THEN   ----- count of peril  lemuel 11/25/2009
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/c1_rec.ri_prem_amt)*100, --ROBERT :: 06.18.2013
                     ri_comm_vat = 0, -- aaron 021209
                     --prem_tax = 0 --replaced by jason 05152009
                     prem_tax = ROUND(c1_rec.ri_prem_amt * (c1_rec.param_value_n / 100),2)  --jason 05152009 --ROBERT :: 06.18.2013
                     --ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt <> 0;
                ELSE
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                   ri_comm_rt  = (SELECT ri_comm_rt
                                                             FROM GIIS_PERIL
                                                                WHERE line_cd =p_line_cd
                                                                AND PERIL_CD = v_perl_cd),--(c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = 0, -- aaron 021209
                     --prem_tax = 0 --replaced by jason 05152009
                     prem_tax = ROUND(c1_rec.ri_prem_amt * (c1_rec.param_value_n / 100),2)  --jason 05152009 --ROBERT :: 06.18.2013
                     --ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND (reverse_sw != 'N' OR reverse_sw is null OR reverse_sw = '') --added by steven
                 AND ri_prem_amt <> 0;
           END IF;
                /*UPDATE giri_wfrps_ri   LEMUEL GIL COMMENT
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = 0, -- aaron 021209
                     --prem_tax = 0 --replaced by jason 05152009
                     prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2)  --jason 05152009
                     --ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = :v100.line_cd
                 AND frps_yy     = :v100.frps_yy
                 AND frps_seq_no = :v100.frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt != 0;*/
            ELSIF param_value_v = 'N' THEN
                --IF v_count_perl > 1 THEN    ----- count of peril  lemuel 11/25/2009
                IF v_count_perl > 1 OR P_REUSED_BINDER = 'Y' THEN    --editted by MJ for consolidation 01022013
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/c1_rec.ri_prem_amt)*100, --ROBERT :: 06.18.2013
                     --ri_comm_vat = 0,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt, --aaron 021209
                     prem_tax = 0
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt <> 0;
                ELSE
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (SELECT ri_comm_rt
                                                             FROM GIIS_PERIL
                                                                WHERE line_cd =p_line_cd
                                                                AND PERIL_CD = v_perl_cd),--ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                         --ri_comm_vat = 0,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt, --aaron 021209
                     prem_tax = 0
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                  AND (reverse_sw != 'N' OR reverse_sw is null OR reverse_sw = '') --added by steven
                 AND ri_prem_amt <> 0;
             END IF;
                  /*UPDATE giri_wfrps_ri  LEMUEL GIL COMMENT
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     --ri_comm_vat = 0,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt, --aaron 021209
                     prem_tax = 0
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = :v100.line_cd
                 AND frps_yy     = :v100.frps_yy
                 AND frps_seq_no = :v100.frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt != 0;*/
           END IF; 
            
        ELSE   -- local reinsurer 
             
            -- modified by aaron 021209, for local reinsurer, comm vat is not zero for both compute_prem_vat_foreign = Y and N
                --MSG_ALERT('FOR-Y','I',FALSE);
                --IF v_count_perl > 1 THEN   ----- count of peril  lemuel 11/25/2009
                IF v_count_perl > 1 OR P_REUSED_BINDER = 'Y' THEN --editted by MJ for consolidation 01022013
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/c1_rec.ri_prem_amt)*100, --ROBERT :: 06.18.2013
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2)
                     prem_tax = 0
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt <> 0;
                ELSE
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (SELECT ri_comm_rt
                                                             FROM GIIS_PERIL
                                                                WHERE line_cd =p_line_cd
                                                                AND PERIL_CD = v_perl_cd),--ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2)
                     prem_tax = 0
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                  AND (reverse_sw != 'N' OR reverse_sw is null OR reverse_sw = '') --added by steven
                 AND ri_prem_amt <> 0;
                END IF;
                
                /*UPDATE giri_wfrps_ri   LEMUEL COMMENT
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2)
                     prem_tax = 0
               WHERE line_cd     = :v100.line_cd
                 AND frps_yy     = :v100.frps_yy
                 AND frps_seq_no = :v100.frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt != 0;*/

        END IF;
        
        /*    
                --MSG_ALERT('LOCAL','I',FALSE);
            UPDATE giri_wfrps_ri
            SET ri_comm_amt = c1_rec.ri_comm_amt,
                ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                ri_comm_vat = 0,
                prem_tax = 0
          WHERE line_cd     = :v100.line_cd
            AND frps_yy     = :v100.frps_yy
            AND frps_seq_no = :v100.frps_seq_no
            AND ri_cd       = c1_rec.ri_cd
            AND ri_prem_amt != 0;
        END IF;    
        
        */
        
        ELSE  -- inward
            
            IF c1_rec.local_foreign_sw <> 'L' THEN   ----- foreign reinsurer aaron 021209    
            IF param_value_v = 'Y' THEN 
                --MSG_ALERT('FOR-Y','I',FALSE);
                --IF v_count_perl > 1 THEN    ----- count of peril  lemuel 11/25/2009
                IF v_count_perl > 1 OR P_REUSED_BINDER = 'Y' THEN --editted by MJ for consolidation 01022013
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/c1_rec.ri_prem_amt)*100, --ROBERT :: 06.18.2013
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                     prem_tax = 0
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) -- aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt <> 0;
                ELSE
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                   ri_comm_rt  = (SELECT ri_comm_rt
                                                             FROM GIIS_PERIL
                                                                WHERE line_cd =p_line_cd
                                                                AND PERIL_CD = v_perl_cd),--ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                         ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                     prem_tax = 0
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) -- aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                  AND (reverse_sw != 'N' OR reverse_sw is null OR reverse_sw = '') --added by steven
                 AND ri_prem_amt <> 0;
                END IF;
                
                /*UPDATE giri_wfrps_ri  LEMUEL COMMENT
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                     prem_tax = 0
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) -- aaron
               WHERE line_cd     = :v100.line_cd
                 AND frps_yy     = :v100.frps_yy
                 AND frps_seq_no = :v100.frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt != 0;*/
          ELSIF param_value_v = 'N' THEN
                   
                  --IF v_count_perl > 1 THEN        ----- count of peril  lemuel 11/25/2009
                  IF v_count_perl > 1 OR P_REUSED_BINDER = 'Y' THEN --editted by MJ for consolidation 01022013
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/c1_rec.ri_prem_amt)*100, --ROBERT :: 06.18.2013
                     ri_comm_vat = 0,
                     prem_tax = 0
                     --prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt <> 0;
                  ELSE
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                   ri_comm_rt  = (SELECT ri_comm_rt
                                                             FROM GIIS_PERIL
                                                                WHERE line_cd =p_line_cd
                                                                AND PERIL_CD = v_perl_cd),--ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                         ri_comm_vat = 0,
                     prem_tax = 0
                     --prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                  AND (reverse_sw != 'N' OR reverse_sw is null OR reverse_sw = '') --added by steven
                 AND ri_prem_amt <> 0;
                  END IF;
                   
                  /*UPDATE giri_wfrps_ri    LEMUEL COMMENT
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = 0,
                     prem_tax = 0
                     --prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = :v100.line_cd
                 AND frps_yy     = :v100.frps_yy
                 AND frps_seq_no = :v100.frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt != 0;*/
           END IF; 
            
        ELSE   -- local reinsurer 
             
             --IF v_count_perl > 1 THEN        ----- count of peril  lemuel 11/25/2009
             IF v_count_perl > 1 OR P_REUSED_BINDER = 'Y' THEN --editted by MJ for consolidation 01022013
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/c1_rec.ri_prem_amt)*100, --ROBERT :: 06.18.2013
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                     prem_tax = 0 -- aaron
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt <> 0;
             ELSE
                    UPDATE GIRI_WFRPS_RI
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (SELECT ri_comm_rt
                                                             FROM GIIS_PERIL
                                                                WHERE line_cd =p_line_cd
                                                                AND PERIL_CD = v_perl_cd),--ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                     prem_tax = 0 -- aaron
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                  AND (reverse_sw != 'N' OR reverse_sw is null OR reverse_sw = '') --added by steven
                 AND ri_prem_amt <> 0;
             END IF;
             
            -- modified by aaron 021209, for local reinsurer, comm vat is not zero for both compute_prem_vat_foreign = Y and N
                --MSG_ALERT('FOR-Y','I',FALSE);
                /*UPDATE giri_wfrps_ri   LEMUEL COMMENT
                 SET ri_comm_amt = c1_rec.ri_comm_amt,
                     ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100,
                     ri_comm_vat = c1_rec.ri_comm_amt * v_input_vat_rt,
                     prem_tax = 0 -- aaron
                    -- prem_tax = round(ri_prem_amt * (c1_rec.param_value_n / 100),2) --aaron
               WHERE line_cd     = :v100.line_cd
                 AND frps_yy     = :v100.frps_yy
                 AND frps_seq_no = :v100.frps_seq_no
                 AND ri_cd       = c1_rec.ri_cd
                 AND ri_prem_amt != 0;*/

        END IF;
        END IF;    
        
        
            END LOOP;
            --COMMIT;
        --JEROME.O 07182008
        --LEMUEL GIL 11252009 
    END;

   /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : post-form-commit trigger 
   */ 
    PROCEDURE post_form_commit_giris001(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_tot_fac_spct      IN GIRI_DISTFRPS.tot_fac_spct%TYPE,
        p_ri_flag           IN VARCHAR2
        ) IS
    BEGIN
        GIRI_WFRPS_PERIL_GRP_pkg.del_giri_wfrps_peril_grp(p_line_cd, p_frps_yy, p_frps_seq_no);
        GIRI_WFRPS_PERIL_GRP_PKG.POPULATE_WFRGROUP(p_dist_no, p_dist_seq_no, p_line_cd, p_frps_yy, p_frps_seq_no);
        giri_wfrperil_pkg.del_giri_wfrperil(p_line_cd, p_frps_yy, p_frps_seq_no);
        
        IF p_ri_flag = '3' THEN
--            GIRI_WFRPERIL_PKG.CREATE_WFRPERIL_R(
--                    p_dist_no, p_dist_seq_no, p_line_cd,
--                    p_frps_yy, p_frps_seq_no, p_iss_cd,
--                    p_par_yy, p_par_seq_no, p_subline_cd,
--                    p_issue_yy, p_pol_seq_no, p_renew_no,
--                    p_tot_fac_spct);   
            -- bonok :: 09.25.2014 :: applied new procedure
            giri_wfrperil_pkg.create_wfrperil_r_giris001(p_dist_no, p_line_cd, p_frps_yy, p_frps_seq_no, p_iss_cd, p_tot_fac_spct);
        ELSE
--            GIRI_WFRPERIL_PKG.CREATE_WFRPERIL_M(
--                    p_dist_no, p_dist_seq_no, p_line_cd,
--                    p_frps_yy, p_frps_seq_no, p_iss_cd,
--                    p_par_yy, p_par_seq_no, p_subline_cd,
--                    p_issue_yy, p_pol_seq_no, p_renew_no,
--                    p_tot_fac_spct);    
                    
            -- bonok :: 09.25.2014 :: applied new procedure
            giri_wfrperil_pkg.create_wfrperil_m_giris001(p_dist_no, p_line_cd, p_frps_yy, p_frps_seq_no, p_iss_cd, p_tot_fac_spct);  
        END IF;
        
      binder_adjust_web_pkg.offset_adjustment_pkg(p_line_cd, p_frps_yy, p_frps_seq_no); -- bonok :: 09.25.2014
    END; 
    
    
     /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Copy data from GIRI_FRPS_RI to GIRI_WFRPS_RI
     **                     for records not tagged for reversal.
     */
    PROCEDURE copy_frps_ri(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_fnl_binder_id IN giri_frps_ri.fnl_binder_id%TYPE
    ) 
    IS
      CURSOR frps_ri IS
        SELECT line_cd, frps_yy, frps_seq_no,
               ri_seq_no, ri_cd, fnl_binder_id,
               ri_shr_pct, ri_tsi_amt, ri_prem_amt,
               ann_ri_s_amt, ann_ri_pct,
               ri_comm_rt, ri_comm_amt, prem_tax,
               renew_sw, reverse_sw, facoblig_sw,
               bndr_remarks1, bndr_remarks2,
               bndr_remarks3, remarks,
               delete_sw, last_update,
               --added other columns by j.diago
               other_charges, revrs_bndr_print_date, master_bndr_id,
       		   cpi_rec_no, cpi_branch_cd, bndr_printed_cnt, revrs_bndr_printed_cnt,
       		   ri_as_no, ri_accept_by, ri_accept_date, ri_shr_pct2, ri_prem_vat,
       		   ri_comm_vat, ri_wholding_vat, address1, address2, address3,
       		   prem_warr_days, prem_warr_tag, pack_binder_id
          FROM giri_frps_ri a
         WHERE a.line_cd       = p_line_cd
           AND a.frps_yy       = p_frps_yy
           AND a.frps_seq_no   = p_frps_seq_no
           AND a.fnl_binder_id = p_fnl_binder_id;
    BEGIN
      FOR c1_rec IN frps_ri LOOP
        INSERT INTO giri_wfrps_ri
            (line_cd, frps_yy, frps_seq_no,
             ri_seq_no, ri_cd, pre_binder_id,
             ri_shr_pct, ri_tsi_amt, ri_prem_amt,
             ann_ri_s_amt, ann_ri_pct,
             ri_comm_rt, ri_comm_amt, prem_tax,
             renew_sw, reverse_sw, facoblig_sw,
             bndr_remarks1, bndr_remarks2,
             bndr_remarks3, remarks,
             delete_sw, last_update,
             other_charges, ri_as_no, ri_accept_by, ri_accept_date, ri_shr_pct2, ri_prem_vat,
       	     ri_comm_vat, address1, address2, address3,
       	     prem_warr_days, prem_warr_tag)
          VALUES
            (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
             c1_rec.ri_seq_no, c1_rec.ri_cd, c1_rec.fnl_binder_id,
             c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt,
             c1_rec.ann_ri_s_amt, c1_rec.ann_ri_pct,
             c1_rec.ri_comm_rt, c1_rec.ri_comm_amt, c1_rec.prem_tax,
             c1_rec.renew_sw, c1_rec.reverse_sw, c1_rec.facoblig_sw,
             c1_rec.bndr_remarks1, c1_rec.bndr_remarks2,
             c1_rec.bndr_remarks3, c1_rec.remarks,
             c1_rec.delete_sw, SYSDATE,
             c1_rec.other_charges, c1_rec.ri_as_no, c1_rec.ri_accept_by, 
             c1_rec.ri_accept_date, c1_rec.ri_shr_pct2, c1_rec.ri_prem_vat,
       	     c1_rec.ri_comm_vat, c1_rec.address1, c1_rec.address2, c1_rec.address3,
       	     c1_rec.prem_warr_days, c1_rec.prem_warr_tag);
      END LOOP;
    END copy_frps_ri;
    
    /*
    **  Created by       : Emman 
    **  Date Created     : 08.17.2011 
    **  Reference By     : (GIUTS021 - Redistribution) 
    **  Description      : CREATE_WFRPERIL_R program unit
    **                     populates giri_wfrperil after records are inserted in giri_wfrps_ri
    */ 
    PROCEDURE UPDATE_RI_COMM_GIUTS021(v_line_cd     IN giri_distfrps.line_cd%TYPE,
                             v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                             v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
    IS
      CURSOR tmp_area IS
        SELECT ri_cd, SUM(ri_comm_amt) ri_comm_amt
          FROM giri_wfrperil
         WHERE line_cd     = v_line_cd
           AND frps_yy     = v_frps_yy
           AND frps_seq_no = v_frps_seq_no
      GROUP BY line_cd, frps_yy, frps_seq_no, ri_cd;
    BEGIN
      FOR c1_rec IN tmp_area LOOP
         UPDATE giri_wfrps_ri
            SET ri_comm_amt = c1_rec.ri_comm_amt
               ,ri_comm_rt  = (c1_rec.ri_comm_amt/ri_prem_amt)*100
          WHERE line_cd     = v_line_cd
            AND frps_yy     = v_frps_yy
            AND frps_seq_no = v_frps_seq_no
            AND ri_cd       = c1_rec.ri_cd
            AND ri_prem_amt != 0;
      END LOOP;
    END UPDATE_RI_COMM_GIUTS021;
    
    PROCEDURE get_tsi_prem_amt (
      p_dist_no             giuw_perilds_dtl.dist_no%TYPE,
      p_dist_seq_no         giuw_perilds_dtl.dist_seq_no%TYPE,
      p_peril_cd            giuw_perilds_dtl.peril_cd%TYPE,
      prem_amt        OUT   giuw_perilds_dtl.dist_prem%TYPE,
      tsi_amt         OUT   giuw_perilds_dtl.dist_tsi%TYPE
   ) is
        
    begin
        SELECT dist_prem, dist_tsi
    INTO prem_amt, tsi_amt
        FROM giuw_perilds_dtl
       WHERE dist_no     = p_dist_no
         AND dist_seq_no = p_dist_seq_no
         AND peril_cd    = p_peril_cd
         AND share_cd    = 999;       
    end;  
END giri_wfrps_ri_pkg;
/


