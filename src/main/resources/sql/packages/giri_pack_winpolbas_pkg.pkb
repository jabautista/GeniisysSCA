CREATE OR REPLACE PACKAGE BODY CPI.giri_pack_winpolbas_pkg
AS
   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-12-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  : copy_pack_pol_winpolbas program unit
   */
   PROCEDURE copy_pack_pol_winpolbas (
      p_pack_par_id       gipi_parlist.pack_par_id%TYPE,
      p_pack_policy_id    gipi_pack_polgenin.pack_policy_id%TYPE)
   IS
   BEGIN
      INSERT INTO giri_pack_inpolbas (pack_accept_no,
                                      pack_policy_id,
                                      ri_policy_no,
                                      ri_endt_no,
                                      ri_binder_no,
                                      ri_cd,
                                      writer_cd,
                                      accept_date,
                                      offer_date,
                                      accept_by,
                                      orig_tsi_amt,
                                      orig_prem_amt,
                                      remarks,
                                      ref_accept_no)
         SELECT pack_accept_no,
                p_pack_policy_id,
                ri_policy_no,
                ri_endt_no,
                ri_binder_no,
                ri_cd,
                writer_cd,
                accept_date,
                offer_date,
                accept_by,
                orig_tsi_amt,
                orig_prem_amt,
                remarks,
                ref_accept_no
           FROM giri_pack_winpolbas
          WHERE pack_par_id = p_pack_par_id;
   END;

   PROCEDURE copy_pack_pol_winpolbas (
      p_pack_par_id       gipi_parlist.pack_par_id%TYPE,
      p_pack_policy_id    gipi_pack_polgenin.pack_policy_id%TYPE,
      p_iss_cd            gipi_parlist.iss_cd%TYPE)
   IS
      v_issue_ri   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR a IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'ISS_CD_RI')
      LOOP
         v_issue_ri := a.param_value_v;
         EXIT;
      END LOOP;

      IF p_iss_cd = v_issue_ri
      THEN
         giri_pack_winpolbas_pkg.copy_pack_pol_winpolbas (p_pack_par_id,
                                                          p_pack_policy_id);
      END IF;
   END;

   /*
   **  Created by   : Jerome Orio
   **  Date Created : 07-13-2011
   **  Reference By : (GIPIS055a - POST PACKAGE PAR)
   **  Description  :
   */
   PROCEDURE del_giri_pack_winpolbas (
      p_pack_par_id giri_pack_winpolbas.pack_par_id%TYPE)
   IS
   BEGIN
      DELETE FROM giri_pack_winpolbas
            WHERE pack_par_id = p_pack_par_id;
   END;

   /*
 **  Created by   : Irwin Tabisora
 **  Date Created : 6.1.2012
 **  Reference By : GIRIS005a
 **  Description  :
 */
   PROCEDURE save_pack_winpolbas (
      p_giri_pack_winpolbas IN giri_pack_winpolbas%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giri_pack_winpolbas
           USING DUAL
              ON (    pack_par_id = p_giri_pack_winpolbas.pack_par_id
                  AND pack_accept_no = p_giri_pack_winpolbas.pack_accept_no)
      WHEN NOT MATCHED
      THEN
         INSERT     (pack_par_id,
                     pack_accept_no,
                     ri_cd,
                     accept_date,
                     ri_policy_no,
                     ri_endt_no,
                     ri_binder_no,
                     writer_cd,
                     offer_date,
                     accept_by,
                     orig_tsi_amt,
                     orig_prem_amt,
                     remarks,
                     ref_accept_no)
             VALUES (p_giri_pack_winpolbas.pack_par_id,
                     p_giri_pack_winpolbas.pack_accept_no,
                     p_giri_pack_winpolbas.ri_cd,
                     p_giri_pack_winpolbas.accept_date,
                     p_giri_pack_winpolbas.ri_policy_no,
                     p_giri_pack_winpolbas.ri_endt_no,
                     p_giri_pack_winpolbas.ri_binder_no,
                     p_giri_pack_winpolbas.writer_cd,
                     p_giri_pack_winpolbas.offer_date,
                     p_giri_pack_winpolbas.accept_by,
                     p_giri_pack_winpolbas.orig_tsi_amt,
                     p_giri_pack_winpolbas.orig_prem_amt,
                     p_giri_pack_winpolbas.remarks,
                     p_giri_pack_winpolbas.ref_accept_no)
      WHEN MATCHED
      THEN
         UPDATE SET ri_cd = p_giri_pack_winpolbas.ri_cd,
                    accept_date = p_giri_pack_winpolbas.accept_date,
                    ri_policy_no = p_giri_pack_winpolbas.ri_policy_no,
                    ri_endt_no = p_giri_pack_winpolbas.ri_endt_no,
                    ri_binder_no = p_giri_pack_winpolbas.ri_binder_no,
                    writer_cd = p_giri_pack_winpolbas.writer_cd,
                    offer_date = p_giri_pack_winpolbas.offer_date,
                    accept_by = p_giri_pack_winpolbas.accept_by,
                    orig_tsi_amt = p_giri_pack_winpolbas.orig_tsi_amt,
                    orig_prem_amt = p_giri_pack_winpolbas.orig_prem_amt,
                    remarks = p_giri_pack_winpolbas.remarks,
                    ref_accept_no = p_giri_pack_winpolbas.ref_accept_no;
   END;

    /*
**  Created by   : Irwin Tabisora
**  Date Created : 6.1.2012
**  Reference By : GIRIS005a
**  Description  : GIRI_WINPOLBAS POST INSERT
*/
   PROCEDURE giris005a_post_insert (
      p_pack_par_id gipi_parlist.pack_par_id%TYPE)
   IS
      v_accept_no   giri_winpolbas.accept_no%TYPE;
   BEGIN
      FOR c1
         IN (SELECT par_id
               FROM gipi_wpack_line_subline
              WHERE     pack_par_id = p_pack_par_id
                    AND NOT EXISTS
                           (SELECT 1
                              FROM giri_winpolbas z
                             WHERE z.par_id = gipi_wpack_line_subline.par_id))
      LOOP
         BEGIN
            SELECT winpolbas_accept_no_s.NEXTVAL INTO v_accept_no FROM DUAL;
         END;

         INSERT INTO giri_winpolbas (accept_no,
                                     par_id,
                                     ri_cd,
                                     accept_date,
                                     ri_policy_no,
                                     ri_endt_no,
                                     ri_binder_no,
                                     writer_cd,
                                     offer_date,
                                     accept_by,
                                     orig_tsi_amt,
                                     orig_prem_amt,
                                     remarks,
                                     ref_accept_no,
                                     pack_par_id,
                                     pack_accept_no)
            SELECT v_accept_no,
                   c1.par_id,
                   ri_cd,
                   accept_date,
                   ri_policy_no,
                   ri_endt_no,
                   ri_binder_no,
                   writer_cd,
                   offer_date,
                   accept_by,
                   orig_tsi_amt,
                   orig_prem_amt,
                   remarks,
                   ref_accept_no,
                   pack_par_id,
                   pack_accept_no
              FROM giri_pack_winpolbas
             WHERE pack_par_id = p_pack_par_id;
      END LOOP;
   END;

   PROCEDURE giris005a_post_update (
      p_pack_par_id      giri_winpolbas.par_id%TYPE,
      p_ri_cd            giri_winpolbas.ri_cd%TYPE,
      p_accept_date      giri_winpolbas.accept_date%TYPE,
      p_ri_policy_no     giri_winpolbas.ri_policy_no%TYPE,
      p_ri_endt_no       giri_winpolbas.ri_endt_no%TYPE,
      p_ri_binder_no     giri_winpolbas.ri_binder_no%TYPE,
      p_writer_cd        giri_winpolbas.writer_cd%TYPE,
      p_offer_date       giri_winpolbas.accept_date%TYPE,
      p_accept_by        giri_winpolbas.accept_by%TYPE,
      p_orig_tsi_amt     giri_winpolbas.orig_tsi_amt%TYPE,
      p_orig_prem_amt    giri_winpolbas.orig_prem_amt%TYPE,
      p_remarks          giri_winpolbas.remarks%TYPE,
      p_ref_accept_no    giri_winpolbas.ref_accept_no%TYPE)
   IS
   BEGIN
      UPDATE giri_winpolbas
         SET ri_cd = p_ri_cd,
             accept_date = p_accept_date,
             ri_policy_no = p_ri_policy_no,
             ri_endt_no = p_ri_endt_no,
             ri_binder_no = p_ri_binder_no,
             writer_cd = p_writer_cd,
             offer_date = p_offer_date,
             accept_by = p_accept_by,
             orig_tsi_amt = p_orig_tsi_amt,
             orig_prem_amt = p_orig_prem_amt,
             remarks = p_remarks,
             ref_accept_no = p_ref_accept_no
       WHERE pack_par_id = p_pack_par_id;
   END;


   FUNCTION get_giri_pack_winpolbas (
      p_pack_par_id giri_pack_winpolbas.pack_par_id%TYPE)
      RETURN giri_pack_winpolbas_tab
      PIPELINED
   IS
      v_winpol   giri_pack_winpolbas_type;
   BEGIN
      FOR i IN (SELECT 1 ROWCOUNT,
                       pack_par_id,
                       pack_accept_no,
                       ri_cd,
                       accept_date,
                       ri_policy_no,
                       ri_endt_no,
                       ri_binder_no,
                       writer_cd,
                       offer_date,
                       accept_by,
                       orig_tsi_amt,
                       orig_prem_amt,
                       remarks,
                       ref_accept_no
                  FROM giri_pack_winpolbas
                 WHERE pack_par_id = p_pack_par_id)
      LOOP
         v_winpol.pack_par_id := i.pack_par_id;
         v_winpol.pack_accept_no := i.pack_accept_no;
         v_winpol.ri_cd := i.ri_cd;
         v_winpol.accept_date := TO_CHAR (i.accept_date, 'MM/DD/YYYY');
         v_winpol.ri_policy_no := i.ri_policy_no;
         v_winpol.ri_endt_no := i.ri_endt_no;
         v_winpol.ri_binder_no := i.ri_binder_no;
         v_winpol.writer_cd := i.writer_cd;
         v_winpol.offer_date := TO_CHAR (i.offer_date, 'MM/DD/YYYY');
         v_winpol.accept_by := i.accept_by;
         v_winpol.orig_tsi_amt := i.orig_tsi_amt;
         v_winpol.orig_prem_amt := i.orig_prem_amt;
         v_winpol.remarks := i.remarks;
         v_winpol.ref_accept_no := i.ref_accept_no;
         v_winpol.ri_sname :=
            GIIS_REINSURER_PKG.get_insurer_sname (i.writer_cd);
         v_winpol.ri_sname2 := GIIS_REINSURER_PKG.get_insurer_sname (i.ri_cd);
		 pipe row(v_winpol);
      END LOOP;
   END;
END giri_pack_winpolbas_pkg;
/


