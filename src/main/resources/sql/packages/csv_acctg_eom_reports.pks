CREATE OR REPLACE PACKAGE CPI.Csv_Acctg_EOM_reports
AS
   TYPE tdr_rec_type
   IS
   RECORD (
     policy_no      VARCHAR2(50),
     incept_date    gipi_polbasic.incept_date%TYPE,
     expiry_date    gipi_polbasic.expiry_date%TYPE,
     tsi_amt        gipi_polbasic.tsi_amt%TYPE,
     total_prem     gipi_polbasic.prem_amt%TYPE,
     vat_amt        NUMBER (18, 2),
     prem_tax       NUMBER (18, 2),
     fst            NUMBER (18, 2),
     lgt            NUMBER (18, 2),
     docstamps      NUMBER (18, 2),
     other_tax      NUMBER (18,2) := 0,
     total_tax      NUMBER (18, 2)
     );

   TYPE tdr_type IS TABLE OF tdr_rec_type;

FUNCTION GIACR101_PROD_REG_WITH_TAX_DTL(p_parameter     NUMBER,
                                        p_date          DATE,
                                        p_date2         DATE,
                                        p_iss_cd        VARCHAR2,
                                        p_line_cd       VARCHAR2,
                                        p_subline_cd    VARCHAR2)
   RETURN tdr_type
   PIPELINED;


/* Vondanix 04/19/13
** For report GIACR101 (PRODUCTION REGISTER)
*/
END;
/


