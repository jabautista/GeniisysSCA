CREATE OR REPLACE PACKAGE CPI.Cr_Bill_Dist AS
/* 051796  CALIGAEN    -  created create_winvoice based on NIIS
**         WPANGANIBAN -  created create_invoice based on the above procedure
**         MBISMARK    -  revise create_winvoice based on the needed information
** 031298  MBISMARK    -  created create_bill_dist that combines create_winvoice
**                        and create_distribution
*/
   p_incept_date      GIPI_WPOLBAS.incept_date%TYPE;
   p_assd_name        GIIS_ASSURED.assd_name%TYPE;
   p_tax_amt          GIPI_WINVOICE.tax_amt%TYPE  := 0;
   comm_amt_per_grp   GIPI_WINVOICE.ri_comm_amt%TYPE := 0;
   tax_amt_per_peril  GIPI_WINVOICE.tax_amt%TYPE  := 0;
   tax_amt_per_group1 GIPI_WINVOICE.tax_amt%TYPE  := 0;
   tax_amt_per_group2 GIPI_WINVOICE.tax_amt%TYPE  := 0;
   prev_item_grp      GIPI_WINVOICE.item_grp%TYPE;
   prev_currency_cd   GIPI_WINVOICE.currency_cd%TYPE;
   prev_currency_rt   GIPI_WINVOICE.currency_rt%TYPE;
   prem_amt_per_peril GIPI_WINVOICE.prem_amt%TYPE := 0;
   prem_amt_per_group GIPI_WINVOICE.prem_amt%TYPE := 0;
   v_tsi_amt          GIPI_WITEM.tsi_amt%TYPE;
   v_prem_amt         GIPI_WITEM.prem_amt%TYPE;
   v_ann_tsi_amt      GIPI_WITEM.ann_tsi_amt%TYPE;
   p_alert            VARCHAR2(1) := 'N';  -- no ind
   PROCEDURE GET_EFF_DATE(p_par_id NUMBER);
   PROCEDURE Delete_Bill(p_par_id NUMBER);
   PROCEDURE Get_Assd_Name(p_par_id NUMBER,p_line_cd VARCHAR2);
   PROCEDURE GET_TAX(p_line_cd VARCHAR2,p_iss_cd VARCHAR2,p_incept_date DATE);
   PROCEDURE INS_WINV(p_par_id NUMBER);
   PROCEDURE GET_TAX2(p_line_cd VARCHAR2,p_iss_cd VARCHAR2,
                      p_peril_cd NUMBER,p_par_id NUMBER);
   PROCEDURE GET_GROUPING(p_par_id NUMBER,p_line_cd VARCHAR2,p_iss_cd VARCHAR2);
   PROCEDURE WINVPERL(p_par_id  NUMBER,p_peril_cd NUMBER,p_item_grp NUMBER,
              p_tsi_amt NUMBER,p_prem_amt NUMBER,p_ri_comm_amt NUMBER,
              p_ri_comm_rt NUMBER);
   PROCEDURE PERIL(p_par_id NUMBER,p_line_cd NUMBER,p_iss_cd VARCHAR2);
   PROCEDURE GET_TSI(p_par_id NUMBER);
   FUNCTION CHANGE_DIST(p_dist_no NUMBER) RETURN VARCHAR2;
   PROCEDURE DELETE_DIST(p_dist_no NUMBER,p_par_id NUMBER);
   PROCEDURE DISTRIBUTE(p_par_id NUMBER,p_dist_no NUMBER);
END;
/


