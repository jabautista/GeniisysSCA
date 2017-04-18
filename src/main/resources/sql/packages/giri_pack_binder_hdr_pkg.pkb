CREATE OR REPLACE PACKAGE BODY CPI.GIRI_PACK_BINDER_HDR_PKG
AS

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  01.11.2012
    **  Reference By : (GIRIS053A - Generate Package Binders)
    **  Description  :  Gets the list of binders for Package
    */
    FUNCTION get_giri_pack_binder_hdr(
        p_pack_policy_id        giri_pack_binder_hdr.pack_policy_id%TYPE
    )
    RETURN giri_pack_binder_hdr_tab PIPELINED IS
        v_list      giri_pack_binder_hdr_type;
    BEGIN
        FOR i IN(SELECT pack_policy_id, pack_binder_id, ri_cd, ri_tsi_amt,
                        ri_prem_amt, ri_shr_pct, ri_comm_rt, ri_comm_amt,
                        prem_tax, ri_prem_vat, ri_comm_vat, ri_wholding_vat,
                        reverse_tag,  user_id, last_update, currency_cd,
                        currency_rt, tsi_amt, binder_date,  prem_amt,
                        line_cd, binder_yy, binder_seq_no, accept_by, accept_date,
                        as_no, attention, remarks
                   FROM giri_pack_binder_hdr
                  WHERE pack_binder_id IN (SELECT DISTINCT pack_binder_id
                                             FROM giri_frps_ri x
                                            WHERE EXISTS (SELECT 1
                                                            FROM giri_distfrps b
                                                           WHERE b.dist_no IN (SELECT y.dist_no dist_no
                                                                                 FROM giuw_pol_dist y, gipi_polbasic z
                                                                                WHERE y.policy_id = z.policy_id
                                                                                  AND y.dist_flag NOT IN(4,5)
                                                                                  AND z.pack_policy_id = p_pack_policy_id)
                                                             AND b.line_cd     = x.line_cd
                                                             AND b.frps_yy     = x.frps_yy
                                                             AND b.frps_seq_no = x.frps_seq_no)))
        LOOP
            v_list.line_cd              := i.line_cd;
            v_list.binder_yy            := i.binder_yy;
            v_list.binder_seq_no        := i.binder_seq_no;
            v_list.accept_by            := i.accept_by;
            v_list.accept_date          := i.accept_date;
            v_list.as_no                := i.as_no;
            v_list.attention            := i.attention;
            v_list.remarks              := i.remarks;
            v_list.pack_policy_id       := i.pack_policy_id;
            v_list.pack_binder_id       := i.pack_binder_id;
            v_list.ri_cd                := i.ri_cd;
            v_list.ri_tsi_amt           := i.ri_tsi_amt;
            v_list.ri_prem_amt          := i.ri_prem_amt;
            v_list.ri_shr_pct           := i.ri_shr_pct;
            v_list.ri_comm_rt           := i.ri_comm_rt;
            v_list.ri_comm_amt          := i.ri_comm_amt;
            v_list.prem_tax             := i.prem_tax;
            v_list.ri_prem_vat          := i.ri_prem_vat;
            v_list.ri_comm_vat          := i.ri_comm_vat;
            v_list.ri_wholding_vat      := i.ri_wholding_vat;
            v_list.reverse_tag          := i.reverse_tag;
            v_list.user_id              := i.user_id;
            v_list.last_update          := i.last_update;
            v_list.currency_cd          := i.currency_cd;
            v_list.currency_rt          := i.currency_rt;
            v_list.tsi_amt              := i.tsi_amt;
            v_list.binder_date          := i.binder_date;
            v_list.prem_amt             := i.prem_amt;
            v_list.dsp_pack_binder_no   := i.line_cd ||' - '||TO_CHAR(i.binder_yy,'09')||' - '||TO_CHAR(i.binder_seq_no,'09999');
            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  01.18.2012
    **  Reference By : (GIRIS053A - Generate Package Binders)
    **  Description  :  Insert binders for Package
    */
    PROCEDURE set_giri_pack_binder_hdr(
        p_pack_policy_id          giri_pack_binder_hdr.pack_policy_id%TYPE,
        p_pack_binder_id          giri_pack_binder_hdr.pack_binder_id%TYPE,
        p_line_cd                 giri_pack_binder_hdr.line_cd%TYPE,
        p_binder_yy               giri_pack_binder_hdr.binder_yy%TYPE,
        p_binder_seq_no           giri_pack_binder_hdr.binder_seq_no%TYPE,
        p_ri_cd                   giri_pack_binder_hdr.ri_cd%TYPE,
        p_ri_tsi_amt              giri_pack_binder_hdr.ri_tsi_amt%TYPE,
        p_ri_prem_amt             giri_pack_binder_hdr.ri_prem_amt%TYPE,
        p_ri_shr_pct              giri_pack_binder_hdr.ri_shr_pct%TYPE,
        p_ri_comm_rt              giri_pack_binder_hdr.ri_comm_rt%TYPE,
        p_ri_comm_amt             giri_pack_binder_hdr.ri_comm_amt%TYPE,
        p_prem_tax                giri_pack_binder_hdr.prem_tax%TYPE,
        p_ri_prem_vat             giri_pack_binder_hdr.ri_prem_vat%TYPE,
        p_ri_comm_vat             giri_pack_binder_hdr.ri_comm_vat%TYPE,
        p_ri_wholding_vat         giri_pack_binder_hdr.ri_wholding_vat%TYPE,
        p_reverse_tag             giri_pack_binder_hdr.reverse_tag%TYPE,
        p_accept_by               giri_pack_binder_hdr.accept_by%TYPE,
        p_accept_date             giri_pack_binder_hdr.accept_date%TYPE,
        p_attention               giri_pack_binder_hdr.attention%TYPE,
        p_remarks                 giri_pack_binder_hdr.remarks%TYPE,
        p_user_id                 giri_pack_binder_hdr.user_id%TYPE,
        p_last_update             giri_pack_binder_hdr.last_update%TYPE,
        p_currency_cd             giri_pack_binder_hdr.currency_cd%TYPE,
        p_currency_rt             giri_pack_binder_hdr.currency_rt%TYPE,
        p_tsi_amt                 giri_pack_binder_hdr.tsi_amt%TYPE,
        p_binder_date             giri_pack_binder_hdr.binder_date%TYPE,
        p_as_no                   giri_pack_binder_hdr.as_no%TYPE,
        p_prem_amt                giri_pack_binder_hdr.prem_amt%TYPE
    ) IS
    BEGIN
        MERGE INTO giri_pack_binder_hdr
             USING dual
                ON (pack_policy_id = p_pack_policy_id
               AND pack_binder_id = p_pack_binder_id
               AND line_cd = p_line_cd
               AND binder_yy = p_binder_yy
               AND binder_seq_no = p_binder_seq_no
               AND ri_cd = p_ri_cd)
        WHEN NOT MATCHED THEN
            INSERT (pack_policy_id, pack_binder_id, line_cd,
                    binder_yy, binder_seq_no, ri_cd,
                    ri_tsi_amt, ri_prem_amt, ri_shr_pct,
                    ri_comm_rt, ri_comm_amt, prem_tax,
                    ri_prem_vat, ri_comm_vat, ri_wholding_vat,
                    reverse_tag, accept_by, accept_date,
                    attention, remarks, user_id,
                    last_update, currency_cd, currency_rt,
                    tsi_amt, binder_date, as_no,
                    prem_amt)
            VALUES (p_pack_policy_id, p_pack_binder_id, p_line_cd,
                    p_binder_yy, p_binder_seq_no, p_ri_cd,
                    p_ri_tsi_amt, p_ri_prem_amt, p_ri_shr_pct,
                    p_ri_comm_rt, p_ri_comm_amt, p_prem_tax,
                    p_ri_prem_vat, p_ri_comm_vat, p_ri_wholding_vat,
                    p_reverse_tag, p_accept_by, p_accept_date,
                    p_attention, p_remarks, giis_users_pkg.app_user,
                    SYSDATE, p_currency_cd, p_currency_rt,
                    p_tsi_amt, p_binder_date, p_as_no,
                    p_prem_amt)
        WHEN MATCHED THEN
            UPDATE
               SET accept_by = p_accept_by,
                   accept_date = p_accept_date,
                   as_no = p_as_no,
                   attention = p_attention,
                   remarks = p_remarks;
    END;

END;
/


