CREATE OR REPLACE PACKAGE CPI.GIACS296_PKG
AS

    PROCEDURE extract_records(
        p_as_of_date    IN  DATE,
        p_cut_off_date  IN  DATE,
        p_ri_cd         IN  GIRI_BINDER.RI_CD%type,
        p_line_cd       IN  GIRI_BINDER.LINE_CD%type,
        p_user          IN  GIAC_OUTFACUL_SOA_EXT.USER_ID%type,
        p_count         OUT NUMBER      -- SR-3876, 3879 : shan 08.27.2015 
    );
    
END GIACS296_PKG;
/


