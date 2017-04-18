DROP VIEW CPI.GIPI_FIRESTAT_EXTRACT_DTL_VW;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_firestat_extract_dtl_vw (zone_type,
                                                               zone_type_desc,
                                                               zone_no,
                                                               zone_desc,
                                                               zone_grp,
                                                               zone_grp_desc,
                                                               eq_zone_type,
                                                               policy_no,
                                                               policy_id,
                                                               line_cd,
                                                               subline_cd,
                                                               iss_cd,
                                                               issue_yy,
                                                               pol_seq_no,
                                                               renew_no,
                                                               item_no,
                                                               block_id,
                                                               risk_cd,
                                                               occupancy_cd,
                                                               occupancy_desc,
                                                               fr_item_type,
                                                               fi_item_grp,
                                                               fi_item_grp_desc,
                                                               tariff_cd,
                                                               tarf_cd,
                                                               peril_cd,
                                                               dist_no,
                                                               dist_seq_no,
                                                               share_cd,
                                                               share_type,
                                                               dist_share_name,
                                                               acct_trty_type,
                                                               acct_trty_type_sname,
                                                               acct_trty_type_lname,
                                                               share_tsi_amt,
                                                               share_prem_amt,
                                                               user_id,
                                                               extract_dt,
                                                               as_of_sw,
                                                               as_of_date,
                                                               date_from,
                                                               date_to,
                                                               assd_no,
                                                               flood_zone,
                                                               typhoon_zone,
                                                               eq_zone,
                                                               param_date
                                                              )
AS
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, zone_ref.zone_desc, zone_ref.zone_grp,
          zone_ref.zone_grp_desc, firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT a.flood_zone zone_no, a.flood_zone_desc zone_desc,
                  a.zone_grp, b.rv_meaning zone_grp_desc
             FROM giis_flood_zone a, cg_ref_codes b
            WHERE b.rv_domain = 'ZONE_GROUP'
              AND a.zone_grp = b.rv_low_value(+)
              AND a.zone_grp IS NOT NULL
           UNION
           SELECT a.flood_zone zone_no, a.flood_zone_desc zone_desc,
                  a.zone_grp, NULL
             FROM giis_flood_zone a
            WHERE a.zone_grp IS NULL) zone_ref,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'FLOOD'               /* for flood zone type */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
      AND firestat.flood_zone = zone_ref.zone_no(+)
   UNION
/* query firestat records for TYPHOON ZONE TYPE which is zone_type = 2 */
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, zone_ref.zone_desc, zone_ref.zone_grp,
          zone_ref.zone_grp_desc, firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT a.typhoon_zone zone_no, a.typhoon_zone_desc zone_desc,
                  a.zone_grp, b.rv_meaning zone_grp_desc
             FROM giis_typhoon_zone a, cg_ref_codes b
            WHERE b.rv_domain = 'ZONE_GROUP'
              AND a.zone_grp = b.rv_low_value(+)
              AND a.zone_grp IS NOT NULL
           UNION
           SELECT a.typhoon_zone zone_no, a.typhoon_zone_desc zone_desc,
                  a.zone_grp, NULL
             FROM giis_typhoon_zone a
            WHERE a.zone_grp IS NULL) zone_ref,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'TYPHOON'                /* for typhoon zone */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
      AND firestat.typhoon_zone = zone_ref.zone_no(+)
/* query firestat records for EARTHQUAKE  ZONE TYPE which is zone_type = 3 */
   UNION
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, zone_ref.zone_desc, zone_ref.zone_grp,
          zone_ref.zone_grp_desc, firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT a.eq_zone zone_no, a.eq_desc zone_desc, a.zone_grp,
                  b.rv_meaning zone_grp_desc
             FROM giis_eqzone a, cg_ref_codes b
            WHERE b.rv_domain = 'ZONE_GROUP'
              AND a.zone_grp = b.rv_low_value(+)
              AND a.zone_grp IS NOT NULL
           UNION
           SELECT a.eq_zone zone_no, a.eq_desc zone_desc, a.zone_grp, NULL
             FROM giis_eqzone a
            WHERE a.zone_grp IS NULL) zone_ref,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'EARTHQUAKE'          /* for earthquake zone */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
      AND firestat.eq_zone = zone_ref.zone_no(+)
/* query firestat records for FIRE ZONE TYPE which is zone_type = 4 */
   UNION
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, NULL zone_desc, NULL zone_grp, NULL zone_grp_desc,
          firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'FIRE'                      /* for fire zone */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
   UNION
/* query firestat records for TYPHOON AND FLOOD ZONE TYPE which is zone_type = 5, when typhoon zone is not null
   zone no for this zone type is equal to the typhoon zone if the typhoon zone is not null, otherwise equal to the flood
   zone */
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, zone_ref.zone_desc, zone_ref.zone_grp,
          zone_ref.zone_grp_desc, firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT a.typhoon_zone zone_no, a.typhoon_zone_desc zone_desc,
                  a.zone_grp, b.rv_meaning zone_grp_desc
             FROM giis_typhoon_zone a, cg_ref_codes b
            WHERE b.rv_domain = 'ZONE_GROUP'
              AND a.zone_grp = b.rv_low_value(+)
              AND a.zone_grp IS NOT NULL
           UNION
           SELECT a.typhoon_zone zone_no, a.typhoon_zone_desc zone_desc,
                  a.zone_grp, NULL
             FROM giis_typhoon_zone a
            WHERE a.zone_grp IS NULL) zone_ref,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'TYPHOON AND FLOOD' /* for typhoon and flood */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
      AND firestat.typhoon_zone = zone_ref.zone_no(+)
      AND firestat.typhoon_zone IS NOT NULL
   UNION
/* query firestat records for TYPHOON AND FLOOD ZONE TYPE which is zone_type = 5, when typhoon zone is  null
   but flood zone is not null. zone no for this zone type is equal to the typhoon zone if the typhoon zone is not null,
   otherwise equal to the flood zone */
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, zone_ref.zone_desc, zone_ref.zone_grp,
          zone_ref.zone_grp_desc, firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT a.flood_zone zone_no, a.flood_zone_desc zone_desc,
                  a.zone_grp, b.rv_meaning zone_grp_desc
             FROM giis_flood_zone a, cg_ref_codes b
            WHERE b.rv_domain = 'ZONE_GROUP'
              AND a.zone_grp = b.rv_low_value(+)
              AND a.zone_grp IS NOT NULL
           UNION
           SELECT a.flood_zone zone_no, a.flood_zone_desc zone_desc,
                  a.zone_grp, NULL
             FROM giis_flood_zone a
            WHERE a.zone_grp IS NULL) zone_ref,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'TYPHOON AND FLOOD' /* for typhoon and flood */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
      AND firestat.flood_zone = zone_ref.zone_no(+)
      AND firestat.typhoon_zone IS NULL
      AND firestat.flood_zone IS NOT NULL
   UNION
/* query firestat records for TYPHOON AND FLOOD ZONE TYPE which is zone_type = 5, when typhoon and flood zone is  null */
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc,
          firestat.zone_no, NULL zone_desc, NULL zone_grp, NULL zone_grp_desc,
          firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NOT NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND cg_code.rv_meaning = 'TYPHOON AND FLOOD' /* for typhoon and flood */
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+)
      AND firestat.typhoon_zone IS NULL
      AND flood_zone IS NULL
   UNION
/* query firestat records for all zone types with null zone_no */
   SELECT firestat.zone_type, cg_code.rv_meaning zone_type_desc, NULL zone_no,
          NULL zone_desc, NULL zone_grp, NULL zone_grp_desc,
          firestat.eq_zone_type,
          (   firestat.line_cd
           || '-'
           || firestat.subline_cd
           || '-'
           || firestat.iss_cd
           || '-'
           || LTRIM (TO_CHAR (firestat.issue_yy, '09'))
           || '-'
           || LTRIM (TO_CHAR (firestat.pol_seq_no, '0999999'))
           || '-'
           || LTRIM (TO_CHAR (firestat.renew_no, '09'))
          ) policy_no,
          firestat.policy_id, firestat.line_cd, firestat.subline_cd,
          firestat.iss_cd, firestat.issue_yy, firestat.pol_seq_no,
          firestat.renew_no, firestat.item_no, firestat.block_id,
          firestat.risk_cd, firestat.occupancy_cd, occ.occupancy_desc,
          firestat.fr_item_type, firestat.fi_item_grp,
          bldg_type.fi_item_grp_desc, firestat.tariff_cd, firestat.tarf_cd,
          firestat.peril_cd, firestat.dist_no, firestat.dist_seq_no,
          firestat.share_cd, dshare.share_type,
          dshare.trty_name dist_share_name, dshare.acct_trty_type,
          catrty.trty_sname acct_trty_type_sname,
          catrty.trty_lname acct_trty_type_lname,
          NVL (firestat.share_tsi_amt, 0) share_tsi_amt,
          NVL (firestat.share_prem_amt, 0) share_prem_amt, firestat.user_id,
          firestat.extract_dt, firestat.as_of_sw, firestat.as_of_date,
          firestat.date_from, firestat.date_to, firestat.assd_no,
          firestat.flood_zone, firestat.typhoon_zone, firestat.eq_zone,
          firestat.param_date
     FROM gipi_firestat_extract_dtl firestat,
          giis_fire_occupancy occ,
          giis_dist_share dshare,
          giis_ca_trty_type catrty,
          cg_ref_codes cg_code,
          (SELECT q1.rv_low_value fi_item_grp, q1.rv_meaning fi_item_grp_desc
             FROM cg_ref_codes q1
            WHERE q1.rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP') bldg_type,
          (SELECT q2.rv_low_value trty_type_cd, q2.rv_meaning trty_type_desc
             FROM cg_ref_codes q2
            WHERE q2.rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD') catrty_type
    WHERE 1 = 1
      AND firestat.zone_no IS NULL
      AND firestat.peril_cd IS NOT NULL
      /* only consider extraction from latest module */
      AND firestat.line_cd = dshare.line_cd
      AND firestat.share_cd = dshare.share_cd
      AND firestat.zone_type = cg_code.rv_low_value
      AND cg_code.rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
      AND dshare.acct_trty_type = catrty.ca_trty_type(+)
      AND catrty.trty_type_cd = catrty_type.trty_type_cd(+)
      AND firestat.fi_item_grp = bldg_type.fi_item_grp(+)
      AND firestat.occupancy_cd = occ.occupancy_cd(+);


