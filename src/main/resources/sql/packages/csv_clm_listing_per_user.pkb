CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_LISTING_PER_USER AS
/* Created by   : Cherrie
** Date created : 12.07.2012
** Description  : used in printing CSV File for Claim Listing per User.
*/
    FUNCTION CSV_GICLR271 ( p_as_of_date    DATE,
                            p_from_date     DATE,
                            p_to_date       DATE,
                            p_search_type   VARCHAR2,
                            p_in_hou_adj    gicl_claims.in_hou_adj%TYPE
                          ) RETURN giclr271_type PIPELINED
    IS
        v_giclr271          giclr271_rec_type;
        v_prev_policy_no    VARCHAR2(30);
        v_prev_assured      gicl_claims.assured_name%TYPE;
        v_policy_no         VARCHAR2(30);
        v_assured           gicl_claims.assured_name%TYPE;
        v_tot_loss_res      NUMBER(16,2):=0;
        v_tot_loss_paid     NUMBER(16,2):=0;
        v_tot_exp_res       NUMBER(16,2):=0;
        v_tot_exp_paid      NUMBER(16,2):=0;

    BEGIN
        FOR rec IN (   SELECT   a.in_hou_adj, a.assured_name,
                                a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.pol_iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.issue_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                             || '-'
                             || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                                a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.clm_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                             TO_CHAR(a.dsp_loss_date,'MM-DD-RRRR') dsp_loss_date,
                             TO_CHAR(a.clm_file_date,'MM-DD-RRRR') clm_file_date,
                             TO_CHAR(a.entry_date,'MM-DD-RRRR') entry_date,
                             b.clm_stat_desc,
                             NVL (a.loss_res_amt, 0) loss_res_amt,
                             NVL (a.exp_res_amt, 0) exp_res_amt,
                             NVL (a.loss_pd_amt, 0) loss_pd_amt, NVL (a.exp_pd_amt, 0) exp_pd_amt,
                             a.loss_dtls
                        FROM gicl_claims a, giis_clm_stat b
                       WHERE a.clm_stat_cd = b.clm_stat_cd
                         AND a.in_hou_adj = p_in_hou_adj
                         AND check_user_per_line (line_cd, iss_cd, 'GICLS271') = 1
                         AND (DECODE(p_search_type,
                                     '1', TRUNC(a.clm_file_date),
                                     '2', TRUNC(a.loss_date),
                                     '3', TRUNC(a.entry_date)
                                     ) BETWEEN (p_from_date) AND (p_to_date)
                              OR
                              DECODE(p_search_type,
                                     '1', TRUNC(a.clm_file_date),
                                     '2', TRUNC(a.loss_date),
                                     '3', TRUNC(a.entry_date)
                                     ) <= p_as_of_date)
                    ORDER BY a.in_hou_adj, a.assured_name)
        LOOP

            v_policy_no := rec.policy_no;
            v_assured   := rec.assured_name;

            IF v_prev_policy_no = v_policy_no AND v_prev_assured = v_assured THEN
                v_policy_no := NULL;
                v_assured := NULL;
            ELSE
                v_prev_policy_no := v_policy_no;
                v_prev_assured := v_assured;
            END IF;

            --grand total computation
            v_tot_loss_res      := v_tot_loss_res + rec.loss_res_amt;
            v_tot_loss_paid     := v_tot_loss_paid + rec.loss_pd_amt;
            v_tot_exp_res       := v_tot_exp_res + rec.exp_res_amt;
            v_tot_exp_paid      := v_tot_exp_paid + rec.exp_pd_amt;

            v_giclr271.assured_name := v_assured;
            v_giclr271.policy_number := v_policy_no;
            v_giclr271.claim_number := rec.claim_no;
            v_giclr271.dsp_loss_date := rec.dsp_loss_date;
            v_giclr271.clm_file_date := rec.clm_file_date;
            v_giclr271.clm_stat_desc := rec.clm_stat_desc;
            v_giclr271.loss_res_amt := rec.loss_res_amt;
            v_giclr271.exp_res_amt := rec.exp_res_amt;
            v_giclr271.loss_pd_amt := rec.loss_pd_amt;
            v_giclr271.exp_pd_amt := rec.exp_pd_amt;
            v_giclr271.entry_date := rec.entry_date;
            v_giclr271.loss_dtls := rec.loss_dtls;
            PIPE ROW(v_giclr271);

        END LOOP;

        --printing of white space
        --printing of gran total
        v_giclr271.assured_name := NULL;
        v_giclr271.policy_number := NULL;
        v_giclr271.claim_number := NULL;
        v_giclr271.dsp_loss_date := NULL;
        v_giclr271.clm_file_date := NULL;
        v_giclr271.clm_stat_desc := NULL;
        v_giclr271.loss_res_amt := NULL;
        v_giclr271.exp_res_amt := NULL;
        v_giclr271.loss_pd_amt := NULL;
        v_giclr271.exp_pd_amt := NULL;
        v_giclr271.entry_date := NULL;
        v_giclr271.loss_dtls := NULL;
        PIPE ROW(v_giclr271);

        --printing of gran total
        v_giclr271.assured_name := NULL;
        v_giclr271.policy_number := NULL;
        v_giclr271.claim_number := NULL;
        v_giclr271.dsp_loss_date := NULL;
        v_giclr271.clm_file_date := NULL;
        v_giclr271.clm_stat_desc := NULL;
        v_giclr271.loss_res_amt := v_tot_loss_res;
        v_giclr271.exp_res_amt := v_tot_exp_res;
        v_giclr271.loss_pd_amt := v_tot_loss_paid;
        v_giclr271.exp_pd_amt := v_tot_exp_paid;
        v_giclr271.entry_date := NULL;
        v_giclr271.loss_dtls := 'Totals Per Claim Processor:';
        PIPE ROW(v_giclr271);

        RETURN;
    END CSV_GICLR271;
END CSV_CLM_LISTING_PER_USER;
/


