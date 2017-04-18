CREATE OR REPLACE PACKAGE CPI.giacr019_pkg
AS
   TYPE giacr019_type IS RECORD (
      with_vat            VARCHAR2 (1),
      non_vat             VARCHAR2 (1),
      company_name        VARCHAR2 (100),
      company_add         giac_parameters.param_value_v%TYPE,
      exist               VARCHAR2 (1),
      tran_id             giac_payt_requests_dtl.tran_id%TYPE,
      request_date        giac_payt_requests.request_date%TYPE,
      request_no          VARCHAR (500),
      a180_ri_cd          giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      ri_name             giis_reinsurer.ri_name%TYPE,
      binder_no           VARCHAR (500),
      disbursement_amt    giac_outfacul_prem_payts.disbursement_amt%TYPE,
      net_due             NUMBER (20, 2),
      convert_rate        giac_outfacul_prem_payts.convert_rate%TYPE,
      foreign_curr_amt    giac_outfacul_prem_payts.foreign_curr_amt%TYPE,
      ri_prem_amt         giri_binder.ri_prem_amt%TYPE,
      ri_prem_vat         giri_binder.ri_prem_vat%TYPE,
      ri_comm_amt         giri_binder.ri_comm_amt%TYPE,
      ri_comm_vat         giri_binder.ri_comm_vat%TYPE,
      ri_wholding_vat     giri_binder.ri_wholding_vat%TYPE,
      policy_no           VARCHAR (100),
      assd_name           giis_assured.assd_name%TYPE,
      prem_amt            giac_outfacul_prem_payts.prem_amt%TYPE,
      prem_vat            giac_outfacul_prem_payts.prem_vat%TYPE,
      comm_amt            giac_outfacul_prem_payts.comm_amt%TYPE,
      comm_vat            giac_outfacul_prem_payts.comm_vat%TYPE,
      wholding_vat        giac_outfacul_prem_payts.wholding_vat%TYPE,
      binder_no1          VARCHAR (500),
      disbursement_amt1   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      net_due1            NUMBER (20, 2),
      convert_rate1       giac_outfacul_prem_payts.convert_rate%TYPE,
      foreign_curr_amt1   giac_outfacul_prem_payts.foreign_curr_amt%TYPE,
      ri_prem_amt1        giri_binder.ri_prem_amt%TYPE,
      ri_prem_vat1        giri_binder.ri_prem_vat%TYPE,
      ri_comm_amt1        giri_binder.ri_comm_amt%TYPE,
      ri_comm_vat1        giri_binder.ri_comm_vat%TYPE,
      ri_wholding_vat1    giri_binder.ri_wholding_vat%TYPE,
      policy_no1          VARCHAR (100),
      assd_name1          giis_assured.assd_name%TYPE,
      prem_amt1           giac_outfacul_prem_payts.prem_amt%TYPE,
      prem_vat1           giac_outfacul_prem_payts.prem_vat%TYPE,
      comm_amt1           giac_outfacul_prem_payts.comm_amt%TYPE,
      comm_vat1           giac_outfacul_prem_payts.comm_vat%TYPE,
      wholding_vat1       giac_outfacul_prem_payts.wholding_vat%TYPE
   );

   TYPE giacr019_tab IS TABLE OF giacr019_type;

   FUNCTION populate_giacr019 (p_gacc_tran_id giac_acctrans.tran_id%TYPE)
      RETURN giacr019_tab PIPELINED;
END giacr019_pkg;
/


