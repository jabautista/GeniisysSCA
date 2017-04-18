CREATE OR REPLACE PACKAGE CPI.GIPIS173_PKG AS

    
   --------------------------------- ***** USED ***** ---------------------------------
   PROCEDURE get_default_currency(
        p_line_cd       IN          GIPI_WPOLBAS.line_cd%type,
        p_subline_cd    IN          GIPI_WPOLBAS.subline_cd%type,
        p_iss_cd        IN          GIPI_WPOLBAS.iss_cd%type,
        p_issue_yy      IN          GIPI_WPOLBAS.issue_yy%type,
        p_pol_seq_no    IN          GIPI_WPOLBAS.pol_seq_no%type,
        p_renew_no      IN          GIPI_WPOLBAS.renew_no%type,
        p_currency_cd   OUT         GIPI_WOPEN_LIAB.currency_cd%type,
        p_currency_rt   IN OUT      GIPI_WOPEN_LIAB.currency_rt%type,
        p_currency_desc IN OUT      GIIS_CURRENCY.currency_desc%type
   );
   
   ---------------------------
    PROCEDURE del_wopen_liab(
        p_par_id    IN  gipi_wopen_liab.par_id%TYPE,
        p_geog_cd   IN  gipi_wopen_liab.geog_cd%TYPE
    );
    
    -->> Invoked by PROCEDURE del_wopen_liab <<--
    PROCEDURE B920_pre_delete(
        p_par_id    IN  gipi_wopen_liab.par_id%TYPE,
        p_geog_cd   IN  gipi_wopen_liab.geog_cd%TYPE
    );
   ----------------------------
       
    PROCEDURE get_rec_flag(
        p_geog_cd         IN GIPI_WOPEN_LIAB.geog_cd%TYPE,
        p_line_cd         IN GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd      IN GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd          IN GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy        IN GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no      IN GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_peril_cd        IN GIPI_WOPEN_PERIL.peril_cd%type,
        p_rec_flag        IN OUT GIPI_WOPEN_LIAB.rec_flag%TYPE,
        p_message         IN OUT VARCHAR2
    );
    
    
    -------------------
    PROCEDURE post_forms_commit(
        p_wopen_liab IN     GIPI_WOPEN_LIAB%ROWTYPE,
        p_iss_cd     IN     GIPI_WPOLBAS.iss_cd%TYPE,
        p_line_cd    IN     GIPI_WPOLBAS.line_cd%TYPE
    );
    
    -->> Invoked by PROCEDURE post_forms_commit <<--
    PROCEDURE insert_into_gipi_witem(
        p_wopen_liab    IN      GIPI_WOPEN_LIAB%ROWTYPE
    );
    
    -->> Invoked by PROCEDURE post_forms_commit <<--
    PROCEDURE insert_into_gipi_witmperl(
        p_par_id            IN      GIPI_WOPEN_LIAB.par_id%type,
        p_limit_liability   IN      GIPI_WOPEN_LIAB.limit_liability%type,
        p_line_cd           IN      GIPI_WOPEN_PERIL.line_cd%type,
        p_iss_cd            IN      GIPI_WPOLBAS.iss_cd%type
    );
    
    -->> Invoked by PROCEDURE post_forms_commit <<--
    PROCEDURE create_distribution(
        b_par_id    IN      NUMBER,
        p_dist_no   IN      NUMBER
    );
    ------------------- 
   
    PROCEDURE select_item_gipi (
        p_par_id        IN      GIPI_WPOLBAS.PAR_ID%type,
        p_msg_alert     OUT     VARCHAR2
    );
   
END GIPIS173_PKG;
/


