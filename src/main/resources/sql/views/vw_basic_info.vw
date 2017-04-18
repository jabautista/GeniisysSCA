DROP VIEW CPI.VW_BASIC_INFO;

/* Formatted on 2015/05/15 10:42 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.vw_basic_info (basic_policy_id,
                                                policy_no,
                                                basic_line_cd,
                                                basic_subline_cd,
                                                basic_iss_cd,
                                                basic_issue_yy,
                                                basic_pol_seq_no,
                                                basic_renew_no,
                                                basic_endt_iss_cd,
                                                basic_endt_yy,
                                                basic_endt_seq_no,
                                                line_line_name,
                                                subline_subline_name,
                                                subline_subline_time,
                                                basic_eff_date,
                                                basic_expiry_tag,
                                                basic_expiry_date,
                                                basic_incept_date,
                                                basic_incept_tag,
                                                basic_issue_date,
                                                basic_total_tsi_amt,
                                                basic_prem_amt,
                                                basic_ref_pol_no,
                                                basic_ref_open_pol_no,
                                                basic_pol_flag,
                                                assured_name,
                                                assured_designation,
                                                par_no,
                                                par_assd_no,
                                                address1,
                                                address2,
                                                address3,
                                                agent_intm_no,
                                                agent_ref_intm_cd,
                                                agent_name,
                                                parent_intm_no,
                                                parent_ref_intm_cd,
                                                parent_intm_name,
                                                basic_acct_of_cd,
                                                in_acct_of,
                                                parh_user_id,
                                                parh_par_status,
                                                parh_parstat_date,
                                                CURRENT_USER
                                               )
AS
   SELECT basic.policy_id basic_policy_id,
             basic.line_cd
          || '-'
          || basic.subline_cd
          || '-'
          || basic.iss_cd
          || '-'
          || LPAD (basic.issue_yy, 2, 0)
          || '-'
          || LPAD (basic.pol_seq_no, 7, 0)
          || '-'
          || LPAD (basic.renew_no, 2, 0)
          || DECODE (NVL (basic.endt_seq_no, 0),
                     0, NULL,
                        '/'
                     || basic.endt_iss_cd
                     || '-'
                     || LPAD (basic.endt_yy, 2, 0)
                     || '-'
                     || LPAD (basic.endt_seq_no, 7, 0)
                    ) policy_no,
          basic.line_cd basic_line_cd, basic.subline_cd basic_subline_cd,
          basic.iss_cd basic_iss_cd, basic.issue_yy basic_issue_yy,
          basic.pol_seq_no basic_pol_seq_no, basic.renew_no basic_renew_no,
          basic.endt_iss_cd basic_endt_iss_cd, basic.endt_yy basic_endt_yy,
          basic.endt_seq_no basic_endt_seq_no, line.line_name line_line_name,
          subline.subline_name subline_subline_name,
          subline.subline_time subline_subline_time,
          basic.eff_date basic_eff_date, basic.expiry_tag basic_expiry_tag,
          basic.expiry_date basic_expiry_date,
          basic.incept_date basic_incept_date,
          basic.incept_tag basic_incept_tag,
          basic.issue_date basic_issue_date,
          basic.tsi_amt basic_total_tsi_amt, basic.prem_amt basic_prem_amt,
          basic.ref_pol_no basic_ref_pol_no,
          basic.ref_open_pol_no basic_ref_open_pol_no,
          DECODE (basic.pol_flag,
                  '1', 'NEW POLICY',
                  '2', 'RENEWAL',
                  '3', 'REPLACEMENT POLICY',
                  '4', 'CANCELLED POLICY',
                  '5', 'SPOILED POLICY',
                  'X', 'EXPIRED POLICY',
                  'UNDEFINED POL_FLAG IN REPORT'
                 ) basic_pol_flag,
          LTRIM (NVL2 (assured.assd_name2,
                          assured.designation
                       || ' '
                       || assured.assd_name
                       || ' '
                       || assured.assd_name2,
                       assured.designation || ' ' || assured.assd_name
                      )
                ) assured_name,
          assured.designation assured_designation,
             par.line_cd
          || '-'
          || par.iss_cd
          || '-'
          || LPAD (par.par_yy, 2, 0)
          || '-'
          || LPAD (par.par_seq_no, 7, 0) par_no,
          par.assd_no par_assd_no,
          
          /* IF the par type is an 'ENDORSEMENT' THEN get the address FROM gipi_parlist
          ** ELSE
          **    get the address FROM gipi_polbasic
          */
          DECODE (par.par_type, 'E', par.address1, basic.address1) address1,
          DECODE (par.par_type, 'E', par.address2, basic.address2) address2,
          DECODE (par.par_type, 'E', par.address3, basic.address3) address3,
          NVL2 (AGENT.ref_intm_cd,
                AGENT.intm_no || '(' || AGENT.ref_intm_cd || ')',
                AGENT.intm_no
               ) agent_intm_no,
          AGENT.ref_intm_cd agent_ref_intm_cd, AGENT.intm_name agent_name,
          NVL2 (PARENT.ref_intm_cd,
                AGENT.parent_intm_no || '(' || PARENT.ref_intm_cd || ')',
                AGENT.parent_intm_no
               ) parent_intm_no,
          PARENT.ref_intm_cd parent_ref_intm_cd,
          PARENT.intm_name parent_intm_name,
          basic.acct_of_cd basic_acct_of_cd,
          
          /* if the assured name is null, then get the concatenated full name */
          LTRIM (RTRIM (NVL (acctof.assd_name || ' ' || acctof.assd_name2,
                                acctof.first_name
                             || DECODE (acctof.middle_initial,
                                        NULL, ' ',
                                        acctof.middle_initial || '. '
                                       )
                             || acctof.last_name
                            )
                       )
                ) in_acct_of,
          '**' || parh.user_id || '**' parh_user_id,
          DECODE (parh.parstat_cd,
                  1, 'newly created',
                  2, 'updated par',
                  3, 'with basic information',
                  4, 'with item information',
                  5, 'with peril information',
                  6, 'with bill',
                  10, 'posted',
                  99, 'deleted',
                  'undecoded status'
                 ) parh_par_status,
          parh.parstat_date parh_parstat_date, USER CURRENT_USER
     FROM gipi_polbasic basic,
          giis_line line,
          giis_subline subline,
          giis_assured acctof,
          giis_assured assured,
          gipi_parlist par,
          gipi_parhist parh,
          gipi_comm_invoice cominv,
          giis_intermediary AGENT,
          giis_intermediary PARENT
    WHERE (basic.par_id = par.par_id)
      AND (assured.assd_no = par.assd_no)
      /* account for missing com invoice */
      AND (basic.policy_id = cominv.policy_id(+))
      AND (basic.line_cd = line.line_cd)
      AND (subline.line_cd = line.line_cd)
      AND (basic.subline_cd = subline.subline_cd)
      AND (basic.line_cd = subline.line_cd)
      /* account for missing agent */
      AND (cominv.intrmdry_intm_no = AGENT.intm_no(+))
      /* account for missing parent intermediary */
      AND (AGENT.parent_intm_no = PARENT.intm_no(+))
      /* account for missing in acct of code */
      AND (basic.acct_of_cd = acctof.assd_no(+))
      /* get the user who posted the policy */
      AND (parh.par_id = basic.par_id AND parh.parstat_cd = '10'  /* POSTED */
          );


