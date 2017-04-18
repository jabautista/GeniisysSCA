CREATE OR REPLACE PACKAGE CPI.Select_Quote_To_Par 
  AS

  PROCEDURE select_quotation   (p_quote_id  NUMBER);

  PROCEDURE create_gipi_wpolbas(p_quote_id  NUMBER,
             p_par_id    NUMBER, 
           p_line_cd   GIIS_LINE.line_cd%TYPE,
           p_iss_cd    VARCHAR2,
           p_assd_no   NUMBER,
           p_user     GIPI_PACK_WPOLBAS.user_id%TYPE,
           p_out       OUT VARCHAR2);

  PROCEDURE create_gipi_wpolbas2(p_quote_id  NUMBER,
             p_par_id    NUMBER,
           p_line_cd   GIIS_LINE.line_cd%TYPE,
           p_iss_cd    VARCHAR2,
           p_assd_no   NUMBER,
           p_user     GIPI_PACK_WPOLBAS.user_id%TYPE,
           p_out       OUT VARCHAR2);

  PROCEDURE create_gipi_witem  (p_quote_id  NUMBER,
             p_par_id    NUMBER);

  PROCEDURE create_item_info   (p_par_id    NUMBER,
             p_quote_id  NUMBER);

  PROCEDURE create_peril_wc    (p_par_id    NUMBER);

  PROCEDURE create_dist_deduct (p_par_id    NUMBER);

  PROCEDURE create_discounts   (p_par_id    NUMBER);

  PROCEDURE INSERT_REMINDER    (p_quote_id  NUMBER,
                                p_par_id    NUMBER);

  PROCEDURE DELETE_WORKFLOW_REC(p_module_id VARCHAR2,
                              p_user       IN VARCHAR2,
                              p_col_value IN VARCHAR2);

END;
/


