CREATE OR REPLACE PACKAGE CPI.giacr222pcic_pkg
AS
   TYPE giacr222_pcic_record_type IS RECORD (
      ri_name              VARCHAR2 (50),
      trty_name            VARCHAR2 (30),
      period1              VARCHAR2 (100),
      proc_qtr             VARCHAR2 (1),
      proc_year            VARCHAR2 (4),
      commission_amt       NUMBER (12, 2),
      commission_sum_amt   NUMBER (12, 2),
      peril_name           VARCHAR2 (20),
      retain_amt           NUMBER (12, 2),
      tax_amt              NUMBER (12, 2),
      company              VARCHAR2 (100),
      address              VARCHAR2 (100)
   );

   TYPE giacr222_pcic_record_tab IS TABLE OF giacr222_pcic_record_type;

   FUNCTION get_giacr222_pcic_records (p_line_cd VARCHAR2, p_proc_qtr VARCHAR2, p_proc_year VARCHAR2, p_ri_cd VARCHAR2, p_share_cd VARCHAR2, p_trty_yy VARCHAR2)
      RETURN giacr222_pcic_record_tab PIPELINED;

   TYPE giacr222_pcic_peril_name_type IS RECORD (
      peril_name           VARCHAR2 (20),
      commission_amt       NUMBER (12, 2),
      commission_sum_amt   NUMBER (12, 2),
      ri_name              VARCHAR2 (50),
      trty_name            VARCHAR2 (30),
      retain_amt           NUMBER (12, 2),
      tax_amt              NUMBER (12, 2),
      proc_qtr             NUMBER (1),
      company              VARCHAR2 (100),
      address              VARCHAR2 (100),
      period1              VARCHAR2 (100),
      proc_year            NUMBER (4),
      v_count              NUMBER,
      v_dummy_retain_amt   NUMBER (12, 2)
   );

   TYPE giacr222_pcic_peril_name_tab IS TABLE OF giacr222_pcic_peril_name_type;

   FUNCTION get_giacr222_pcic_peril_name (p_line_cd VARCHAR2, p_proc_qtr VARCHAR2, p_proc_year VARCHAR2, p_ri_cd VARCHAR2, p_share_cd VARCHAR2, p_trty_yy VARCHAR2, p_trty_name VARCHAR2, p_ri_name VARCHAR2)
      RETURN giacr222_pcic_peril_name_tab PIPELINED;
      
END;
/


