CREATE OR REPLACE PACKAGE CPI.pack_quote_to_par
AS
PROCEDURE create_parlist_wpack (p_pack_quote_id   NUMBER, 
                          p_line_cd    giis_line.line_cd%TYPE,
        p_pack_par_id   NUMBER,
        p_iss_cd    gipi_parlist.iss_cd%TYPE,
        p_assd_no    gipi_parlist.assd_no%TYPE);
PROCEDURE create_pack_wpolbas  (p_pack_quote_id         NUMBER,
             p_pack_par_id           NUMBER,
             p_assd_no    NUMBER,
             p_line_cd    giis_line.line_cd%TYPE,
           p_iss_cd    gipi_parlist.iss_cd%TYPE,
           p_issue_date      gipi_wpolbas.issue_date%TYPE,
           p_user     gipi_pack_wpolbas.user_id%TYPE,
           p_booking_mth   gipi_wpolbas.booking_mth%TYPE,
           p_booking_yr   gipi_wpolbas.booking_year%TYPE);
PROCEDURE create_item_info     (p_pack_par_id          NUMBER, 
                   p_pack_quote_id      NUMBER);
PROCEDURE create_discounts     (p_pack_par_id           NUMBER);
PROCEDURE create_peril_wc      (p_pack_par_id           NUMBER);
PROCEDURE create_dist_ded      (p_pack_par_id           NUMBER);
PROCEDURE return_to_quote      (p_pack_quote_id         NUMBER,
                                p_pack_par_id           NUMBER);
PROCEDURE create_wmortgagee (p_pack_quote_id NUMBER, p_pack_par_id NUMBER);                 
END;
/


