CREATE OR REPLACE PACKAGE CPI.GIRIS016_PKG AS

    TYPE binder_type IS RECORD(
        fnl_binder_id           GIRI_BINDER.fnl_binder_id%TYPE,
        line_cd                 GIRI_BINDER.line_cd%TYPE,
        binder_seq_no           GIRI_BINDER.binder_seq_no%TYPE,
        binder_yy               GIRI_BINDER.binder_yy%TYPE,
        ri_sname                GIIS_REINSURER.ri_sname%TYPE,
        pol_line_cd             GIPI_POLBASIC.line_cd%TYPE,
        subline_cd              GIPI_POLBASIC.subline_cd%TYPE,
        iss_cd                  GIPI_POLBASIC.iss_cd%TYPE,
        issue_yy                GIPI_POLBASIC.issue_yy%TYPE,
        pol_seq_no              GIPI_POLBASIC.pol_seq_no%TYPE,
        renew_no                GIPI_POLBASIC.renew_no%TYPE,
        endt_iss_cd             GIPI_POLBASIC.endt_iss_cd%TYPE,
        endt_yy                 GIPI_POLBASIC.endt_yy%TYPE,
        endt_seq_no             GIPI_POLBASIC.endt_seq_no%TYPE,
        assd_name               GIIS_ASSURED.assd_name%TYPE,
        tsi_amt                 GIPI_POLBASIC.tsi_amt%TYPE,
        ri_tsi_amt              GIRI_BINDER.ri_tsi_amt%TYPE,
        ri_prem_amt             GIRI_BINDER.ri_prem_amt%TYPE,
        ri_prem_vat             GIRI_BINDER.ri_prem_vat%TYPE,
        prem_tax                GIRI_BINDER.prem_tax%TYPE,
        net_due_ri              NUMBER(16, 2),
        binder_date             VARCHAR2(20),
        reverse_date            VARCHAR2(20),
        frps_yy                 GIRI_DISTFRPS.frps_yy%TYPE,
        frps_seq_no             GIRI_DISTFRPS.frps_seq_no%TYPE,
        currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
        currency_rt             GIIS_CURRENCY.currency_rt%TYPE,
        prem_amt                GIPI_POLBASIC.prem_amt%TYPE,
        ri_shr_pct              GIRI_BINDER.ri_shr_pct%TYPE,
        ri_comm_amt             GIRI_BINDER.ri_comm_amt%TYPE,
        ri_comm_vat             GIRI_BINDER.ri_comm_vat%TYPE,
        ri_wholding_vat         GIRI_BINDER.ri_wholding_vat%TYPE,
        ri_comm_rt              GIRI_BINDER.ri_comm_rt%TYPE,
        remarks                 GIRI_BINDER_POLBASIC_V.remarks%TYPE,
        bndr_remarks1           GIRI_BINDER_POLBASIC_V.bndr_remarks1%TYPE,
        bndr_remarks2           GIRI_BINDER_POLBASIC_V.bndr_remarks2%TYPE,
        bndr_remarks3           GIRI_BINDER_POLBASIC_V.bndr_remarks3%TYPE,
        ri_accept_by            GIRI_BINDER_POLBASIC_V.ri_accept_by%TYPE,
        ri_as_no                GIRI_BINDER_POLBASIC_V.ri_as_no%TYPE,
        ri_accept_date          VARCHAR2(20),
        binder_number           VARCHAR2(50),
        policy_number           VARCHAR2(50)
    );
    TYPE binder_tab IS TABLE OF binder_type;
    
    TYPE binder_peril_type IS RECORD(
        rownum_                 NUMBER, --Daniel Marasigan SR 5941 03.06.2017
        count_                  NUMBER, --Daniel Marasigan SR 5941 03.06.2017
        fnl_binder_id           GIRI_BINDER_PERIL.fnl_binder_id%TYPE,
        peril_seq_no            GIRI_BINDER_PERIL.peril_seq_no%TYPE,
        ri_prem_amt             GIRI_BINDER_PERIL.ri_prem_amt%TYPE,
        ri_tsi_amt              GIRI_BINDER_PERIL.ri_tsi_amt%TYPE,
        ri_comm_amt             GIRI_BINDER_PERIL.ri_comm_amt%TYPE,
        ri_shr_pct              GIRI_BINDER_PERIL.ri_shr_pct%TYPE,
        peril_name              GIRI_FRPS_PERIL_GRP.peril_title%TYPE
    );
    TYPE binder_peril_tab IS TABLE OF binder_peril_type;
    
    FUNCTION get_binders(
        p_line_cd               GIRI_BINDER.line_cd%TYPE,
        p_binder_yy             GIRI_BINDER.binder_yy%TYPE,
        p_binder_seq_no         GIRI_BINDER.binder_seq_no%TYPE,
        p_module_id             GIIS_MODULES.module_id%TYPE,
        p_user_id               GIIS_USERS.user_id%TYPE
    )
      RETURN binder_tab PIPELINED;
    
    --modified by Daniel Marasigan SR 5941 03.06.2017  
    FUNCTION get_binder_perils(
        p_fnl_binder_id         GIRI_BINDER_PERIL.fnl_binder_id%TYPE,
        p_filter_peril_name     VARCHAR2,
        p_filter_ri_shr_pct     NUMBER,
        p_filter_ri_tsi_amt     NUMBER,
        p_filter_ri_comm_amt    NUMBER,
        p_filter_ri_prem_amt    NUMBER,
        p_from                  NUMBER,
        p_to                    NUMBER,
        p_asc_desc_flag         VARCHAR2,
        p_sort_column           VARCHAR2
    )
      RETURN binder_peril_tab PIPELINED;

   TYPE policy_no_type IS RECORD (
      fnl_binder_id     giri_binder.fnl_binder_id%TYPE,
      line_cd           giri_binder.line_cd%TYPE,
      binder_seq_no     giri_binder.binder_seq_no%TYPE,
      binder_yy         giri_binder.binder_yy%TYPE,
      ri_sname          giis_reinsurer.ri_sname%TYPE,
      pol_line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      tsi_amt           gipi_polbasic.tsi_amt%TYPE,
      ri_tsi_amt        giri_binder.ri_tsi_amt%TYPE,
      ri_prem_amt       giri_binder.ri_prem_amt%TYPE,
      ri_prem_vat       giri_binder.ri_prem_vat%TYPE,
      prem_tax          giri_binder.prem_tax%TYPE,
      net_due_ri        NUMBER (16, 2),
      binder_date       VARCHAR2 (20),
      reverse_date      VARCHAR2 (20),
      frps_yy           giri_distfrps.frps_yy%TYPE,
      frps_seq_no       giri_distfrps.frps_seq_no%TYPE,
      currency_desc     giis_currency.currency_desc%TYPE,
      currency_rt       giis_currency.currency_rt%TYPE,
      prem_amt          gipi_polbasic.prem_amt%TYPE,
      ri_shr_pct        giri_binder.ri_shr_pct%TYPE,
      ri_comm_amt       giri_binder.ri_comm_amt%TYPE,
      ri_comm_vat       giri_binder.ri_comm_vat%TYPE,
      ri_wholding_vat   giri_binder.ri_wholding_vat%TYPE,
      ri_comm_rt        giri_binder.ri_comm_rt%TYPE,
      remarks           giri_binder_polbasic_v.remarks%TYPE,
      bndr_remarks1     giri_binder_polbasic_v.bndr_remarks1%TYPE,
      bndr_remarks2     giri_binder_polbasic_v.bndr_remarks2%TYPE,
      bndr_remarks3     giri_binder_polbasic_v.bndr_remarks3%TYPE,
      ri_accept_by      giri_binder_polbasic_v.ri_accept_by%TYPE,
      ri_as_no          giri_binder_polbasic_v.ri_as_no%TYPE,
      ri_accept_date    VARCHAR2 (20),
      binder_number     VARCHAR2 (50),
      policy_number     VARCHAR2 (50),
      endt_number       VARCHAR2 (50)
   );

   TYPE policy_no_tab IS TABLE OF policy_no_type;

   FUNCTION get_policy_no_lov (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no       VARCHAR2,
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN policy_no_tab PIPELINED;
END GIRIS016_PKG;
/