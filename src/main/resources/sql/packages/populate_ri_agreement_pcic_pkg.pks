CREATE OR REPLACE PACKAGE CPI.populate_ri_agreement_pcic_pkg AS
  TYPE ri_agreement_pcic_type IS RECORD (
    ri_prem_amt       giri_binder.ri_prem_amt%TYPE,
    ri_prem_vat       giri_binder.ri_prem_vat%TYPE,
    ri_comm_amt       giri_binder.ri_comm_amt%TYPE,
    ri_comm_vat       giri_binder.ri_comm_vat%TYPE,
    binder_date       giri_binder.binder_date%TYPE,
    reinsurer_address varchar2(32767),
    ri_name           giis_reinsurer.ri_name%TYPE,
    bond_type         giis_subline.subline_name%TYPE,
    currency          giis_currency.short_name%TYPE,
    ri_tsi_amt        gipi_item.tsi_amt%TYPE,
    assd_name         giis_assured.assd_name%TYPE,
    obligee_name      giis_obligee.obligee_name%TYPE,
    duration          varchar2(32767),
    tsi_amt           gipi_item.tsi_amt%TYPE,
    incept_date       gipi_polbasic.incept_date%TYPE,
    designation       varchar2(32767),
    signatory         varchar2(32767),
    total             varchar2(32767),
    currency_desc     varchar2(32767),
    policy            varchar2(32767),
    policy_no         varchar2(32767),
    net               number,
    bond              varchar2(32767),
    vdate             varchar2(32767),
    vmonth_year       varchar2(32767),
    vtsi_amt          varchar2(32767)
  );
    
  TYPE ri_agreement_pcic_tab IS TABLE OF ri_agreement_pcic_type;
    
    FUNCTION populate_ri_agreement_pcic(
    p_fnl_binder_id         giri_binder.fnl_binder_id%TYPE
  )
    RETURN ri_agreement_pcic_tab PIPELINED;
               
END populate_ri_agreement_pcic_pkg;
/


