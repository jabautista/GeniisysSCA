CREATE OR REPLACE PACKAGE BODY CPI.gicls275_pkg
AS
   FUNCTION get_mcreplacementpart_lov_list ( -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
      p_search_string VARCHAR2,      
      p_car_make      VARCHAR2,
      p_model_year    VARCHAR2,
      p_car_part      VARCHAR2       
   ) -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End
      RETURN get_mcreplacementpart_lov_tab PIPELINED
   IS
      v_list   get_mcreplacementpart_lov_type;
   BEGIN
      FOR i IN (
                SELECT DISTINCT a.motcar_comp_cd car_cd, b.car_company car_company
                  FROM gicl_motor_car_dtl a, giis_mc_car_company b, giis_mc_make c, giis_loss_exp d, gicl_loss_exp_dtl e -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Company LOV. - Start
                 WHERE a.motcar_comp_cd = b.car_company_cd
                   AND UPPER(b.car_company) LIKE NVL(UPPER(p_search_string),'%')
                   AND a.make_cd = c.make_cd 
                   AND a.motcar_comp_cd = c.car_company_cd
                   AND c.make LIKE NVL(p_car_make,'%')
                   AND a.model_year LIKE NVL(p_model_year,'%')
                   AND d.line_cd = 'MC'
                   AND d.part_sw = 'Y'
                   AND d.loss_exp_type = 'L'
                   AND a.claim_id = e.claim_id
                   AND d.loss_exp_cd = e.loss_exp_cd
                   AND d.loss_exp_desc LIKE NVL(p_car_part,'%')                
                 ORDER BY a.motcar_comp_cd
               ) -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Company LOV. - End
      LOOP
         v_list.car_company := i.car_company;
         v_list.car_company_cd := i.car_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_mcreplacementpart_lov_list;

   FUNCTION get_mcreplacementmake_lov_list (
      p_search_string   VARCHAR2,
      p_car_company     VARCHAR2, -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
      p_model_year      VARCHAR2,
      p_car_part        VARCHAR2 -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End     
   )
      RETURN get_mcreplacementmake_lov_tab PIPELINED
   IS
      v_list   get_mcreplacementmake_lov_type;
   BEGIN
      /*FOR i IN (SELECT DISTINCT a.make_cd make_cd, c.make make
                           FROM gicl_motor_car_dtl a,
                                giis_mc_car_company b,
                                giis_mc_make c,
                                giis_loss_exp d
                          WHERE a.motcar_comp_cd = b.car_company_cd
                            AND a.make_cd = c.make_cd
                            AND a.motcar_comp_cd = c.car_company_cd
                            AND d.line_cd = 'MC'
                            AND d.part_sw = 'Y'
                            AND d.loss_exp_type = 'L'
                            AND c.make LIKE NVL(p_search_string,'%')
                            AND b.car_company LIKE NVL(p_car_company,'%')
                       ORDER BY a.make_cd
                       )*/
      FOR i IN (
                SELECT DISTINCT  a.make_cd, a.make
                  FROM giis_mc_make a, gicl_motor_car_dtl b, giis_mc_car_company c, giis_loss_exp d, gicl_loss_exp_dtl e -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Make LOV. - Start
                 WHERE b.make_cd = a.make_cd
                   AND b.motcar_comp_cd = a.car_company_cd
                   AND (b.make_cd LIKE NVL(p_search_string,'%') 
                        OR b.make_cd IS NULL)
                   AND b.motcar_comp_cd = c.car_company_cd
                   AND c.car_company LIKE NVL(p_car_company,'%')
                   AND b.model_year LIKE NVL(p_model_year,'%')
                   AND d.line_cd = 'MC'
                   AND d.part_sw = 'Y'
                   AND d.loss_exp_type = 'L'     
                   AND b.claim_id = e.claim_id
                   AND d.loss_exp_cd = e.loss_exp_cd
                   AND d.loss_exp_desc LIKE NVL(p_car_part,'%') -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Make LOV. - End
                 ORDER BY make_cd   
                )
      LOOP
         v_list.make_cd := i.make_cd;
         v_list.make := i.make;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_mcreplacementmake_lov_list;

   FUNCTION get_mcreplacementyr_lov_list (
      p_search_string   VARCHAR2,
      p_make            VARCHAR2,
      p_car_company     VARCHAR2, -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
      p_car_part        VARCHAR2 -- Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End    
   )
      RETURN get_mcreplacementyr_lov_tab PIPELINED
   IS
      v_list   get_mcreplacementyr_lov_type;
   BEGIN
      FOR i IN (
                SELECT DISTINCT a.model_year myear
                  FROM gicl_motor_car_dtl a,
                       giis_mc_car_company b,
                       giis_mc_make c,
                       giis_loss_exp d, -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Model Yr LOV. - Start
                       gicl_loss_exp_dtl e
                 WHERE a.motcar_comp_cd = b.car_company_cd
                   AND a.make_cd = c.make_cd
                   AND a.motcar_comp_cd = c.car_company_cd
                   AND d.line_cd = 'MC'
                   AND d.part_sw = 'Y'
                   AND d.loss_exp_type = 'L'
                   AND a.model_year LIKE NVL(p_search_string,'%') 
                   AND c.make LIKE NVL(p_make,'%')
                   AND b.car_company LIKE NVL(p_car_company,'%')
                   AND a.claim_id = e.claim_id                   
                   AND d.loss_exp_cd = e.loss_exp_cd
                   AND d.loss_exp_desc LIKE NVL(p_car_part,'%')   
              ORDER BY a.model_year -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Model Yr LOV. - End           
              )
      LOOP
         v_list.model_year := i.myear;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_mcreplacementyr_lov_list;

   FUNCTION get_replacementparts_lov_list (
      p_search_string   VARCHAR2,
      p_make            VARCHAR2,
      p_car_company     VARCHAR2,
      p_model_year      VARCHAR2
   )
      RETURN get_replacementparts_lov_tab PIPELINED
   IS
      v_list   get_replacementparts_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT d.loss_exp_cd cd, d.loss_exp_desc descr
                           FROM gicl_motor_car_dtl a,
                                giis_mc_car_company b,
                                giis_mc_make c,
                                giis_loss_exp d, -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Parts LOV. - Start
                                gicl_loss_exp_dtl e -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Parts LOV. - End
                          WHERE a.motcar_comp_cd = b.car_company_cd
                            AND a.make_cd = c.make_cd
                            AND a.motcar_comp_cd = c.car_company_cd
                            AND d.line_cd = 'MC'
                            AND d.part_sw = 'Y'
                            AND d.loss_exp_type = 'L'
                            AND a.claim_id = e.claim_id -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Parts LOV. - Start 
                            AND d.loss_exp_cd = e.loss_exp_cd -- Dren 10.12.2015 SR-SIT : 0004920 - Updated Query for Parts LOV. - End            
                            AND d.loss_exp_desc LIKE NVL(p_search_string,'%')
                            AND a.model_year LIKE NVL(p_model_year,'%')
                            AND c.make LIKE NVL(p_make,'%')
                            AND b.car_company LIKE NVL(p_car_company,'%')
                       ORDER BY d.loss_exp_cd
                       )
      LOOP
         v_list.loss_exp_desc := i.descr;
         v_list.loss_exp_cd := i.cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_replacementparts_lov_list;

   FUNCTION get_mcreplacement_details (
      p_car_company_cd   NUMBER,
      p_make_cd          NUMBER,
      p_model_year       NUMBER,
      p_loss_exp_cd      VARCHAR2,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by        VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2
   )
      RETURN get_mcreplacement_details_tab PIPELINED
   IS
      v_list   get_mcreplacement_details_type;
   BEGIN
    IF p_model_year IS NOT NULL THEN
      FOR i IN
         (SELECT a.claim_id, NVL (a.model_year, 'NOT SPECIFIED') model_year,
                 a.motcar_comp_cd, a.make_cd, b.loss_exp_cd, b.clm_loss_id,
                 b.ded_base_amt, c.item_no, c.peril_cd, c.payee_cd,
                 c.payee_class_cd, c.hist_seq_no, c.item_stat_cd,
                 d.le_stat_desc, b.dtl_amt, b.user_id, b.last_update,
                 e.class_desc, f.payee_last_name, g.peril_name,
                    h.line_cd
                 || '-'
                 || h.subline_cd
                 || '-'
                 || h.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (h.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (h.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (h.renew_no, '09')) policy_no,
                 h.clm_yy, h.clm_seq_no, h.pol_iss_cd, h.assd_no,
                 h.loss_date, h.clm_file_date, j.assd_name, k.clm_stat_desc
            FROM gicl_motor_car_dtl a,
                 gicl_loss_exp_dtl b,
                 gicl_clm_loss_exp c,
                 gicl_le_stat d,
                 giis_payee_class e,
                 giis_payees f,
                 giis_peril g,
                 gicl_claims h,
                 giis_assured j,
                 giis_clm_stat k
           WHERE a.claim_id = b.claim_id
             AND a.claim_id = h.claim_id
             AND a.claim_id = c.claim_id
             AND h.assd_no = j.assd_no
             AND h.clm_stat_cd = k.clm_stat_cd
             AND b.clm_loss_id = c.clm_loss_id
             AND c.item_stat_cd = d.le_stat_cd
             AND e.payee_class_cd = c.payee_class_cd
             AND e.payee_class_cd = f.payee_class_cd
             AND f.payee_no = c.payee_cd
             AND b.line_cd = g.line_cd
             AND c.peril_cd = g.peril_cd
             AND a.motcar_comp_cd = p_car_company_cd
             AND a.make_cd = p_make_cd
             AND a.model_year = p_model_year
             AND b.loss_exp_cd = p_loss_exp_cd
             AND check_user_per_iss_cd2 ('MC', h.iss_cd, 'GICLS275', p_user_id) = 1
             AND a.claim_id IN (
                    SELECT DISTINCT claim_id
                               FROM gicl_claims
                              WHERE check_user_per_line2 (line_cd,  iss_cd, 'GICLS275', p_user_id ) = 1)
             AND ((DECODE (p_search_by, 'lossDate', h.loss_date, 'claimFileDate', h.clm_file_date ) >= TO_DATE (p_from_date, 'MM-DD-YYYY'))
             AND (DECODE (p_search_by, 'lossDate', h.loss_date, 'claimFileDate', h.clm_file_date ) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
             OR (DECODE (p_search_by,'lossDate', h.loss_date, 'claimFileDate', h.clm_file_date ) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.peril_name := i.peril_name;
         v_list.class_desc := i.class_desc;
         v_list.payee_last_name := i.payee_last_name;
         v_list.hist_seq_no := i.hist_seq_no;
         v_list.le_stat_desc := i.le_stat_desc;
         v_list.dtl_amt := i.dtl_amt;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR(i.last_update,'MM-DD-yyyy');
         v_list.claim_number := get_claim_number (i.claim_id);
         v_list.policy_no := i.policy_no;
         v_list.assd_name := i.assd_name;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.clm_loss_id := i.clm_loss_id;
         v_list.loss_exp_cd := i.loss_exp_cd;
         PIPE ROW (v_list);
      END LOOP;
    
    ELSE
        FOR i IN
         (SELECT a.claim_id, NVL (a.model_year, 'NOT SPECIFIED') model_year,
                 a.motcar_comp_cd, a.make_cd, b.loss_exp_cd, b.clm_loss_id,
                 b.ded_base_amt, c.item_no, c.peril_cd, c.payee_cd,
                 c.payee_class_cd, c.hist_seq_no, c.item_stat_cd,
                 d.le_stat_desc, b.dtl_amt, b.user_id, b.last_update,
                 e.class_desc, f.payee_last_name, g.peril_name,
                    h.line_cd
                 || '-'
                 || h.subline_cd
                 || '-'
                 || h.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (h.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (h.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (h.renew_no, '09')) policy_no,
                 h.clm_yy, h.clm_seq_no, h.pol_iss_cd, h.assd_no,
                 h.loss_date, h.clm_file_date, j.assd_name, k.clm_stat_desc
            FROM gicl_motor_car_dtl a,
                 gicl_loss_exp_dtl b,
                 gicl_clm_loss_exp c,
                 gicl_le_stat d,
                 giis_payee_class e,
                 giis_payees f,
                 giis_peril g,
                 gicl_claims h,
                 giis_assured j,
                 giis_clm_stat k
           WHERE a.claim_id = b.claim_id
             AND a.claim_id = h.claim_id
             AND a.claim_id = c.claim_id
             AND h.assd_no = j.assd_no
             AND h.clm_stat_cd = k.clm_stat_cd
             AND b.clm_loss_id = c.clm_loss_id
             AND c.item_stat_cd = d.le_stat_cd
             AND e.payee_class_cd = c.payee_class_cd
             AND e.payee_class_cd = f.payee_class_cd
             AND f.payee_no = c.payee_cd
             AND b.line_cd = g.line_cd
             AND c.peril_cd = g.peril_cd
             AND a.motcar_comp_cd = p_car_company_cd
             AND a.make_cd = p_make_cd
             AND b.loss_exp_cd = p_loss_exp_cd
             AND check_user_per_iss_cd2 ('MC', h.iss_cd, 'GICLS275', p_user_id) = 1
             AND a.claim_id IN (
                    SELECT DISTINCT claim_id
                               FROM gicl_claims
                              WHERE check_user_per_line2 (line_cd,  iss_cd, 'GICLS275', p_user_id ) = 1)
             AND ((DECODE (p_search_by, 'lossDate', h.loss_date, 'claimFileDate', h.clm_file_date ) >= TO_DATE (p_from_date, 'MM-DD-YYYY'))
             AND (DECODE (p_search_by, 'lossDate', h.loss_date, 'claimFileDate', h.clm_file_date ) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
             OR (DECODE (p_search_by,'lossDate', h.loss_date, 'claimFileDate', h.clm_file_date ) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.peril_name := i.peril_name;
         v_list.class_desc := i.class_desc;
         v_list.payee_last_name := i.payee_last_name;
         v_list.hist_seq_no := i.hist_seq_no;
         v_list.le_stat_desc := i.le_stat_desc;
         v_list.dtl_amt := i.dtl_amt;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR(i.last_update,'MM-DD-yyyy');
         v_list.claim_number := get_claim_number (i.claim_id);
         v_list.policy_no := i.policy_no;
         v_list.assd_name := i.assd_name;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.clm_loss_id := i.clm_loss_id;
         v_list.loss_exp_cd := i.loss_exp_cd;
         PIPE ROW (v_list);
      END LOOP;
    
      
    END IF;

      RETURN;
   END get_mcreplacement_details;

   FUNCTION get_loss_dtls (
      p_claim_id      VARCHAR2,
      p_clm_loss_id   VARCHAR2,
      p_loss_exp_cd   VARCHAR2
   )
      RETURN get_loss_details_tab PIPELINED
   IS
      v_list      get_loss_details_type;
      v_ded_amt   gicl_loss_exp_ded_dtl.ded_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_loss_exp_dtl
                 WHERE claim_id = p_claim_id
                   AND clm_loss_id = p_clm_loss_id
                   AND loss_exp_cd = p_loss_exp_cd)
      LOOP
         v_list.loss_exp_cd := i.loss_exp_cd;
         v_list.line_cd := i.line_cd;
         v_list.no_of_units := i.no_of_units;

         BEGIN
            FOR a IN (SELECT loss_exp_desc
                        FROM giis_loss_exp
                       WHERE line_cd = i.line_cd
                         AND loss_exp_cd = i.loss_exp_cd
                         AND subline_cd IS NULL)
            LOOP
               v_list.dsp_exp_desc := a.loss_exp_desc;
            END LOOP;
         END;

         BEGIN
            FOR ded IN (SELECT SUM (ded_amt) amt
                          FROM gicl_loss_exp_ded_dtl
                         WHERE claim_id = i.claim_id
                           AND clm_loss_id = i.clm_loss_id
                           AND ded_cd = i.loss_exp_cd)
            LOOP
               v_ded_amt := ded.amt;
               v_list.nbt_net_amt := i.dtl_amt + v_ded_amt;
            END LOOP;

            IF     v_list.nbt_net_amt IS NULL
               AND i.dtl_amt IS NOT NULL
               AND v_ded_amt IS NULL
            THEN
               v_list.nbt_net_amt := 0;
            END IF;

            v_list.nbt_base_amt := NVL (i.ded_base_amt, '0');
            v_list.dtl_amt := NVL (i.dtl_amt, '0');

            BEGIN
               SELECT SUM (NVL (dtl_amt, 0)), NVL(SUM (i.dtl_amt + v_ded_amt),0)
                 INTO v_list.tot_dtl_amt, v_list.tot_net_amt
                 FROM gicl_loss_exp_dtl
                WHERE claim_id = p_claim_id
                  AND clm_loss_id = p_clm_loss_id
                  AND loss_exp_cd = p_loss_exp_cd;
            END;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END;
END;
/


