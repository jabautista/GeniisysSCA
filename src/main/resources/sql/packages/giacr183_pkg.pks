CREATE OR REPLACE PACKAGE CPI.giacr183_pkg
AS
   TYPE giacr183_type IS RECORD (
      cf_company                  VARCHAR2 (150),
      cf_company_address          VARCHAR2 (500),
      cf_from_date                VARCHAR2 (50),
      cf_to_date                  VARCHAR2 (50),
      cf_cut_off_date             VARCHAR2 (50),
      ri_cd                       giis_reinsurer.ri_cd%TYPE,
      ri_name                     giis_reinsurer.ri_name%TYPE,
      net_amount                  NUMBER (20, 2),
      total_net_amount_per_line   NUMBER (20, 2),
      line_name                   giis_line.line_name%TYPE,
      RUN_TIME                    VARCHAR (2000) -- dren 06.17.2015 SR 0003851: Modify runtime to display properly in Excel
   );

   TYPE giacr183_tab IS TABLE OF giacr183_type;

   FUNCTION get_giacr183_details (
      p_ri_cd          giac_due_from_ext.ri_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_cut_off_date   DATE
   )
      RETURN giacr183_tab PIPELINED;

   FUNCTION get_giacr183_summary (
      p_ri_cd          giac_due_from_ext.ri_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_cut_off_date   DATE
   )
      RETURN giacr183_tab PIPELINED;
END;
/


