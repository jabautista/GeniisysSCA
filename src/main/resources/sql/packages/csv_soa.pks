CREATE OR REPLACE PACKAGE CPI.csv_soa
AS
--A. FUNCTION CSV_GIAC296--                               --added by jcDY 11.17.2011
   TYPE giacr296_rec_type IS RECORD (
      ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
      line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
      policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
      lprem_amt       giac_outfacul_soa_ext.lprem_amt%TYPE,
      lprem_vat       giac_outfacul_soa_ext.lprem_vat%TYPE,
      lcomm_amt       giac_outfacul_soa_ext.lcomm_amt%TYPE,
      lcomm_vat       giac_outfacul_soa_ext.lcomm_vat%TYPE,
      lwholding_vat   giac_outfacul_soa_ext.lwholding_vat%TYPE,
      lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE
   );

   TYPE giacr296_type IS TABLE OF giacr296_rec_type;

   --END A--

   --B. FUNCTION CSV_GIAC296A--
   TYPE giacr296a_rec_type IS RECORD (
      ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
      line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
      policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
      lprem_amt       giac_outfacul_soa_ext.lprem_amt%TYPE,
      lprem_vat       giac_outfacul_soa_ext.lprem_vat%TYPE,
      lcomm_amt       giac_outfacul_soa_ext.lcomm_amt%TYPE,
      lcomm_vat       giac_outfacul_soa_ext.lcomm_vat%TYPE,
      lwholding_vat   giac_outfacul_soa_ext.lwholding_vat%TYPE,
      lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE,
      policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      column_no       giis_report_aging.column_no%TYPE,
      column_title    giis_report_aging.column_title%TYPE
   );

   TYPE giacr296a_type IS TABLE OF giacr296a_rec_type;

   --END B--

   --C. FUNCTION CSV_GIAC296B--
   TYPE giacr296b_rec_type IS RECORD (
      ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
      line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
      policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
      fprem_amt       giac_outfacul_soa_ext.fprem_amt%TYPE,
      fprem_vat       giac_outfacul_soa_ext.fprem_vat%TYPE,
      fcomm_amt       giac_outfacul_soa_ext.fcomm_amt%TYPE,
      fcomm_vat       giac_outfacul_soa_ext.fcomm_vat%TYPE,
      fwholding_vat   giac_outfacul_soa_ext.fwholding_vat%TYPE,
      fnet_due        giac_outfacul_soa_ext.fnet_due%TYPE,
      currency_cd     giac_outfacul_soa_ext.currency_cd%TYPE,
      currency_rt     giac_outfacul_soa_ext.currency_rt%TYPE,
      currency_desc   giis_currency.currency_desc%TYPE,
      policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE
   );

   TYPE giacr296b_type IS TABLE OF giacr296b_rec_type;

   --END C--

   --D. FUNCTION CSV_GIAC296C--
   TYPE giacr296c_rec_type IS RECORD (
      ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
      line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
      policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
      fprem_amt       giac_outfacul_soa_ext.fprem_amt%TYPE,
      fprem_vat       giac_outfacul_soa_ext.fprem_vat%TYPE,
      fcomm_amt       giac_outfacul_soa_ext.fcomm_amt%TYPE,
      fcomm_vat       giac_outfacul_soa_ext.fcomm_vat%TYPE,
      fwholding_vat   giac_outfacul_soa_ext.fwholding_vat%TYPE,
      fnet_due        giac_outfacul_soa_ext.fnet_due%TYPE,
      currency_cd     giac_outfacul_soa_ext.currency_cd%TYPE,
      currency_rt     giac_outfacul_soa_ext.currency_rt%TYPE,
      currency_desc   giis_currency.currency_desc%TYPE,
      column_no       giis_report_aging.column_no%TYPE,
      column_title    giis_report_aging.column_title%TYPE
   );

   TYPE giacr296c_type IS TABLE OF giacr296c_rec_type;

   --END D--

   --E. FUNCTION CSV_GIAC296D--
   TYPE giacr296d_rec_type IS RECORD (
      ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      ri_name         giac_outfacul_soa_ext.ri_name%TYPE,
      line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      eff_date        giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date    giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no       giac_outfacul_soa_ext.binder_no%TYPE,
      policy_no       giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name       giac_outfacul_soa_ext.assd_name%TYPE,
      lprem_amt       giac_outfacul_soa_ext.lprem_amt%TYPE,
      lprem_vat       giac_outfacul_soa_ext.lprem_vat%TYPE,
      lcomm_amt       giac_outfacul_soa_ext.lcomm_amt%TYPE,
      lcomm_vat       giac_outfacul_soa_ext.lcomm_vat%TYPE,
      lwholding_vat   giac_outfacul_soa_ext.lwholding_vat%TYPE,
      lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE,
      policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      prem_bal        giac_outfacul_soa_ext.prem_bal%TYPE,
      loss_tag        giac_outfacul_soa_ext.loss_tag%TYPE,
      intm_name       giac_outfacul_soa_ext.intm_name%TYPE,
      column_no       giis_report_aging.column_no%TYPE,
      column_title    giis_report_aging.column_title%TYPE
   );

   TYPE giacr296d_type IS TABLE OF giacr296d_rec_type;

   --END E--                                        --added by jcDY 11.17.2011 end

   --F. FUNCTION CSV_GIACR199--
   TYPE giacr199_rec_type IS RECORD (
      branch_name    giis_issource.iss_name%TYPE,
      intm_no        giac_soa_rep_ext.intm_no%TYPE,
      intm_cd        giis_intermediary.ref_intm_cd%TYPE,
      intm_name      giac_soa_rep_ext.intm_name%TYPE,
      address        VARCHAR2 (250),
      col_title      giac_soa_rep_ext.column_title%TYPE,
      policy_no      giac_soa_rep_ext.policy_no%TYPE,
      ref_pol_no     giac_soa_rep_ext.ref_pol_no%TYPE,
      assd_name      giac_soa_rep_ext.assd_name%TYPE,
      bill_no        VARCHAR2 (84),
      expiry_date    giac_soa_rep_ext.expiry_date%TYPE,
      incept_date    giac_soa_rep_ext.incept_date%TYPE,
      due_date       giac_soa_rep_ext.due_date%TYPE,
      no_of_days     giac_soa_rep_ext.no_of_days%TYPE,
      prem_amt       giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_amt        giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt    giac_soa_rep_ext.balance_amt_due%TYPE,
      comm_amt       NUMBER (16, 2),
      wholding_tax   NUMBER (16, 2),
      input_vat_amt  NUMBER (16, 2), --added by Daniel Marasigan SR 22232
      gst   NUMBER (16, 2),--rcd
      net_amt        NUMBER (16, 2)
   );

   TYPE giacr199_type IS TABLE OF giacr199_rec_type;

--END F--

   --added by reymon
   --for giacr193A report
   TYPE giacr193a_rec_type IS RECORD (
      branch_name       giac_branches.branch_name%TYPE,
      intm_desc         giis_intm_type.intm_desc%TYPE,
      intm_no           giac_soa_rep_ext.intm_no%TYPE,
      ref_intm_cd       giis_intermediary.ref_intm_cd%TYPE,
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      intm_address      VARCHAR2 (250),
      column_title      giac_soa_rep_ext.column_title%TYPE,
      line_name         giis_line.line_name%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      bill_no           VARCHAR2 (20),
      incept_date       giac_soa_rep_ext.incept_date%TYPE,
      due_date          giac_soa_rep_ext.due_date%TYPE,
      no_of_days        giac_soa_rep_ext.no_of_days%TYPE,
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      iss_cd            giac_soa_rep_ext.iss_cd%TYPE,
      prem_seq_no       giac_soa_rep_ext.prem_seq_no%TYPE,
      inst_no           giac_soa_rep_ext.inst_no%TYPE,
      user_id           giac_soa_rep_ext.user_id%TYPE
   );

   TYPE giacr193a_type IS TABLE OF giacr193a_rec_type;

/* added by mikel
** 04.08.2013
*/
-- FUNCTION CSV_GIAC190--
   TYPE giacr190_rec_type IS RECORD (
      branch            VARCHAR2(50),
      intermediary      giac_soa_rep_ext.intm_name%TYPE,
      ref_intm          giis_intermediary.ref_intm_cd%TYPE,
      premium           giac_soa_rep_ext.prem_bal_due%TYPE,
      taxes             giac_soa_rep_ext.tax_bal_due%TYPE,
      amount_due        giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no1           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no2           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no3           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no4           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no5           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no6           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no7           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no8           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no9           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no10          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no11          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no12          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no13          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no14          giac_soa_rep_ext.balance_amt_due%TYPE
   );

   TYPE giacr190_type IS TABLE OF giacr190_rec_type;

--END CSV_GIAC190--

   -- FUNCTION CSV_GIAC191--
--mikel 04.18.2013
   TYPE giacr191_rec_type IS RECORD (
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      incept_date       giac_soa_rep_ext.incept_date%TYPE,
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      bill_no           VARCHAR2 (20),
      due_date          giac_soa_rep_ext.due_date%TYPE,
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due       giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no1           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no2           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no3           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no4           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no5           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no6           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no7           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no8           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no9           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no10          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no11          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no12          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no13          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no14          giac_soa_rep_ext.balance_amt_due%TYPE
   );

   TYPE giacr191_type IS TABLE OF giacr191_rec_type;

--END CSV_GIAC191--

   -- FUNCTION CSV_GIAC192--
--mikel 04.18.2013
   TYPE giacr192_rec_type IS RECORD (
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due       giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no1           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no2           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no3           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no4           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no5           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no6           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no7           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no8           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no9           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no10          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no11          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no12          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no13          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no14          giac_soa_rep_ext.balance_amt_due%TYPE
   );

   TYPE giacr192_type IS TABLE OF giacr192_rec_type;

-- FUNCTION CSV_GIACR189--
--vondanix 05/02/2013
/* Modified by Joms Diago 05092013 */
   TYPE giacr189_rec_type IS RECORD (
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      incept_date       giac_soa_rep_ext.incept_date%TYPE,
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      bill_no           VARCHAR2 (20),
      due_date          giac_soa_rep_ext.due_date%TYPE,
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due       giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      /* Start Add by Joms Diago 05092013*/
      col_no1           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no2           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no3           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no4           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no5           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no6           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no7           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no8           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no9           giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no10          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no11          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no12          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no13          giac_soa_rep_ext.balance_amt_due%TYPE,
      col_no14          giac_soa_rep_ext.balance_amt_due%TYPE
      /* End Add by Joms Diago 05092013*/
   /*days_1_to_30      giac_soa_rep_ext.balance_amt_due%TYPE,
   days_31_to_60     giac_soa_rep_ext.balance_amt_due%TYPE,
   days_61_to_90     giac_soa_rep_ext.balance_amt_due%TYPE,
   days_91_to_120    giac_soa_rep_ext.balance_amt_due%TYPE,
   days_121_to_150   giac_soa_rep_ext.balance_amt_due%TYPE,
   days_151_to_180   giac_soa_rep_ext.balance_amt_due%TYPE,
   days_over_181     giac_soa_rep_ext.balance_amt_due%TYPE*/ -- Removed by Joms Diago 05092013
   );

   TYPE giacr189_type IS TABLE OF giacr189_rec_type;
   
   -- FUNCTION CSV_GIACR189--
   /* added by carlo de guzman 3.08.2016*/
   
   TYPE populate_giacr197a_type IS RECORD(
      branch_code           GIAC_SOA_REP_EXT.branch_cd%TYPE,  
      branch_name           VARCHAR2(100),
      assured_no            GIAC_SOA_REP_EXT.assd_no%TYPE,
      assured               GIAC_SOA_REP_EXT.assd_name%TYPE,
      address               VARCHAR2(250),
      column_title          GIAC_SOA_REP_EXT.column_title%TYPE,
      policy_number         GIAC_SOA_REP_EXT.policy_no%TYPE,
      ref_pol_no            GIAC_SOA_REP_EXT.ref_pol_no%TYPE,
      bill_no               VARCHAR2(200),
      incept_date           GIAC_SOA_REP_EXT.incept_date%TYPE,
      due_date              GIAC_SOA_REP_EXT.due_date%TYPE,
      age                   GIAC_SOA_REP_EXT.no_of_days%TYPE,
      premium_balance_due   GIAC_SOA_REP_EXT.prem_bal_due%TYPE,
      tax_balance_due       GIAC_SOA_REP_EXT.tax_bal_due%TYPE,
      documentary_stamps    GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      fire_service_tax      GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      local_government_tax  GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      premium_tax_vat       GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      other_taxes           GIAC_SOA_REP_TAX_EXT.tax_bal_due%TYPE,
      balance_amount_due    GIAC_SOA_REP_EXT.balance_amt_due%TYPE
      
    );
    
    TYPE populate_giacr197a_tab IS TABLE OF populate_giacr197a_type;
    
    FUNCTION csv_giacr197a(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_ASSD_NO         NUMBER,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_TYPE       VARCHAR2,
     P_USER            VARCHAR2
    )
     RETURN populate_giacr197a_tab PIPELINED;

   -- jhing 01.30.2016 added new type GENQA 4099,4100,4103,4102,4101   
   TYPE csv_rec_type IS RECORD (                         
        rec                 VARCHAR2(32767)
    );

   TYPE csv_rec_tab IS TABLE OF csv_rec_type;   

   TYPE giacr296_aging_rec IS RECORD (
            column_no       giis_report_aging.column_no%TYPE,
            column_title    giis_report_aging.column_title%TYPE 
   );
       
   TYPE giacr296_aging_rec_tbl IS TABLE OF giacr296_aging_rec;   

   TYPE dyn_sql_query IS RECORD (
      query1   VARCHAR2 (4000),
      query2   VARCHAR2 (4000),
      query3   VARCHAR2 (4000),
      query4   VARCHAR2 (4000),
      query5   VARCHAR2 (4000),
      query6   VARCHAR2 (4000),
      query7   VARCHAR2 (4000),
      query8   VARCHAR2 (4000)
   );

   TYPE dyn_sql_query_tab IS TABLE OF dyn_sql_query;
   
   -- end of added types jhing 01.30.2016 

   FUNCTION cf_whtaxformula (
      intmd_no      NUMBER,
      branch_cd     VARCHAR2,
      prem_seq_no   NUMBER,
      cut_off       VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION cf_1formula
      RETURN VARCHAR2;

   FUNCTION cf_1formula0034
      RETURN VARCHAR2;

   FUNCTION cf_dateformula
      RETURN DATE;

   FUNCTION cf_1formula0038
      RETURN VARCHAR2;

   FUNCTION cf_1formula0005
      RETURN DATE;

   FUNCTION cf_ref_intm_cdformula (intmd_no giis_intermediary.intm_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_net_amtformula (
      bal_amt_due   NUMBER,
      comm_amt      NUMBER,
      whtax         NUMBER
   )
      RETURN NUMBER;

   FUNCTION cf_1formula0040
      RETURN VARCHAR2;

   FUNCTION cf_intm_addformula (intmd_no giis_intermediary.intm_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_inceptformula (the_prem_seq_no NUMBER, branch_cd VARCHAR2)
      RETURN DATE;

   FUNCTION cf_designationformula
      RETURN CHAR;

   FUNCTION cf_date_tag2formula
      RETURN VARCHAR2;

   FUNCTION cf_date_tagformula
      RETURN VARCHAR2;

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION cf_comm_amtformula (
      intmd_no      NUMBER,
      branch_cd     VARCHAR2,
      cut_off       DATE,
      prem_seq_no   NUMBER
   )
      RETURN NUMBER;

   FUNCTION cf_branch_nameformula (branch_cd giis_issource.iss_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION m_8formattrigger
      RETURN BOOLEAN;

   FUNCTION csv_giacr296 (                          --added by jcDY 11.17.2011
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN giacr296_type PIPELINED;

   FUNCTION csv_giacr296a_old (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN giacr296a_type PIPELINED;
      
      
   -- jhing 01.30.2016 new function will replace code with csv function  GENQA 4099,4100,4103,4102,4101   
   FUNCTION csv_giacr296a_query (       
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN dyn_sql_query_tab PIPELINED;     
      
   FUNCTION csv_giacr296a (       -- jhing 01.30.2016 new function will replace code with csv function  GENQA 4099,4100,4103,4102,4101
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN csv_rec_tab PIPELINED ;        

   FUNCTION csv_giacr296b (
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  -- added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
   )
      RETURN giacr296b_type PIPELINED;

   FUNCTION csv_giacr296c_old (   -- jhing 01.30.2016 will replace code with csv function  GENQA 4099,4100,4103,4102,4101
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2
   )
      RETURN giacr296c_type PIPELINED;
      
   -- jhing 01.30.2016 new function will replace code with csv function  GENQA 4099,4100,4103,4102,4101   
   FUNCTION csv_giacr296c_query (       
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN dyn_sql_query_tab PIPELINED;     
      
   FUNCTION csv_giacr296c (       -- jhing 01.30.2016 new function will replace code with csv function  GENQA 4099,4100,4103,4102,4101
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN csv_rec_tab PIPELINED ;             

   FUNCTION csv_giacr296d_old (  -- jhing will replace this function with a new one which dynamically sets aging as columns-  01.30.2016 GENQA 4099,4100,4103,4102,4101
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_paid           VARCHAR2,
      p_unpaid         VARCHAR2,
      p_partpaid       VARCHAR2
   )
      RETURN giacr296d_type PIPELINED;          
      
   FUNCTION csv_giacr296d_query (  -- jhing 01.30.2016 new function 
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_paid           VARCHAR2,
      p_unpaid         VARCHAR2,
      p_partpaid       VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN dyn_sql_query_tab PIPELINED;   
      
      
   FUNCTION csv_giacr296d (  -- jhing 01.30.2016 new function 
      p_cut_off_date   DATE,
      p_as_of_date     DATE,
      p_ri_cd          NUMBER,
      p_line_cd        VARCHAR2,
      p_paid           VARCHAR2,
      p_unpaid         VARCHAR2,
      p_partpaid       VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN csv_rec_tab PIPELINED ;
            
   FUNCTION get_giacr296_agingCols (
      p_report_id      VARCHAR2,
      p_user_id        VARCHAR2  
   )
      RETURN giacr296_aging_rec_tbl PIPELINED;
                 

--added by reymon
--for giacr193a report
   FUNCTION csv_giacr193a (
      p_bal_amt_due   NUMBER,
      p_user          VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2
   )
      RETURN giacr193a_type PIPELINED;

   FUNCTION csv_giacr199 (
      p_bal_amt_due   NUMBER,
      p_user          VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_cut_off       DATE
   )
      RETURN giacr199_type PIPELINED;

/* added by mikel
** 04.08.2013
*/
   FUNCTION csv_giacr190 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_date          DATE,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr190_type PIPELINED;

--mikel 04.18.2013
   FUNCTION csv_giacr191 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_assd_no       NUMBER,
      p_inc_overdue   VARCHAR2,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr191_type PIPELINED;

--mikel 04.18.2013
   FUNCTION csv_giacr192 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_assd_no       NUMBER,
      p_inc_overdue   VARCHAR2,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr192_type PIPELINED;

   FUNCTION get_bal_per_col_per_title (
      p_col_no        NUMBER,
      p_rep_id        VARCHAR2,
      p_user          VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_intm_no       NUMBER,
      p_assd_no       NUMBER,
      p_inc_overdue   VARCHAR2,
      p_bal_amt_due   NUMBER,
      p_policy_no     VARCHAR2,
      p_bill_no       VARCHAR2
   )                                       --mikel 05.03.2013; added p_bill_no
      RETURN NUMBER;

--mikel 04.17.2013
   FUNCTION get_col_title (p_col_no NUMBER)
      RETURN VARCHAR2;

--vondanix 05/02/2013
   FUNCTION csv_giacr189 (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_intm_no       NUMBER,
      p_intm_type     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_user          VARCHAR2,
      p_rep_id        VARCHAR2
   )
      RETURN giacr189_type PIPELINED;

   FUNCTION get_giacr199_comm_amt (
      p_balance_amt   giac_soa_rep_ext.balance_amt_due%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_inst_no       gipi_installment.inst_no%TYPE,
      p_cut_off       DATE,
      p_user_id       VARCHAR2 -- added by MarkS 5.18.2016 SR-22192
   )
      RETURN NUMBER;

   TYPE v_comm_amt_tab IS TABLE OF giac_comm_payts.comm_amt%TYPE
      INDEX BY BINARY_INTEGER;

   FUNCTION get_gstformula (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_cut_off       DATE
   )
      RETURN NUMBER;

   FUNCTION get_input_vatformula (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_inst_no       gipi_installment.inst_no%TYPE,
      p_cut_off       DATE,
      p_user_id       VARCHAR2 -- added by MarkS 5.18.2016 SR-22192
   )
      RETURN NUMBER;

   TYPE v_invat_amt_tab IS TABLE OF giac_comm_payts.input_vat_amt%TYPE
      INDEX BY BINARY_INTEGER;
END;
/
