DROP VIEW CPI.GIAC_BAE_POL_PARENT_INTM_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_bae_pol_parent_intm_v (intrmdry_intm_no,
                                                             policy_id,
                                                             iss_cd,
                                                             parent_intm_no,
                                                             intm_type,
                                                             acct_intm_cd,
                                                             takeup_seq_no,
                                                             share_percentage
                                                            )
AS
   SELECT DISTINCT a.intrmdry_intm_no, a.policy_id, a.iss_cd,
                   a.parent_intm_no, b.intm_type, c.acct_intm_cd,
                   d.takeup_seq_no                            /*APRIL 061009*/
                                  ,
                   a.share_percentage / 100 share_percentage /*ADREL08272009*/
              FROM gipi_comm_invoice a,
                   giis_intermediary b,
                   giis_intm_type c,
                   gipi_invoice d
             WHERE a.parent_intm_no = b.intm_no
               AND b.intm_type = c.intm_type
               AND a.iss_cd = d.iss_cd
               AND d.prem_seq_no = a.prem_seq_no;


