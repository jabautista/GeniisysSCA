DROP PROCEDURE CPI.DELETE_ALL_TABLES2;

CREATE OR REPLACE PROCEDURE CPI.DELETE_ALL_TABLES2(
    p_par_id    gipi_parlist.par_id%TYPE
    ) IS
   p_dist_no      giuw_pol_dist.dist_no%TYPE;
   p_frps_yy      giri_wdistfrps.frps_yy%TYPE;
   p_frps_seq_no  giri_wdistfrps.frps_seq_no%TYPE;
BEGIN
    /*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 01.13.2011 
	**  Reference By 	: (GIPIS002 - Basic Information)
	**  Description 	: Deletes all tables when the subline_cd is changed using the given par_id
	*/
    
--
-- Deleting tables related to the line ENGINEERING
--
   DELETE    GIPI_WPRINCIPAL
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WLOCATION
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WENGG_BASIC
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line FIRE
--
   DELETE    GIPI_WFIREITM
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line PERSONAL ACCIDENT
--
   DELETE    GIPI_WACCIDENT_ITEM
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line AVIATION
--
   DELETE    GIPI_WAVIATION_ITEM
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WVES_AIR
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line MISCELLANEOUS 
--
   DELETE    GIPI_WCASUALTY_ITEM
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WBENEFICIARY
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WCASUALTY_PERSONNEL
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WGROUPED_ITEMS
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line MARINE HULL
--
   DELETE    GIPI_WITEM_VES
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line MARINE CARGO
--
   DELETE    GIPI_WCARGO
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line MOTOR CAR
--
   DELETE    GIPI_WVEHICLE
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WMCACC
    WHERE    par_id   =  p_par_id;

--
-- Deleting tables related to the line SURETY
--
   DELETE    GIPI_WBOND_BASIC
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WCOSIGNTRY
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WDEDUCTIBLES
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WENDTTEXT
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WINSTALLMENT
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WINVPERL
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WINV_TAX
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WCOMM_INVOICES
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WPACKAGE_INV_TAX
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WINVOICE
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WITMPERL
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WLIM_LIAB
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WITEM
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WOPEN_CARGO
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WOPEN_LIAB
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WOPEN_PERIL
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WOPEN_POLICY
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WPERIL_DISCOUNT
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WPOLNREP
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WPOLWC
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WREQDOCS
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WVES_ACCUMULATION
    WHERE    par_id   =  p_par_id;

   BEGIN
      SELECT     dist_no
        INTO     p_dist_no
        FROM     giuw_pol_dist
       WHERE     par_id   =  p_par_id;
      DELETE     giuw_witemperilds_dtl
       WHERE     dist_no   =   p_dist_no;
      DELETE     giuw_witemperilds
       WHERE     dist_no   =   p_dist_no;
      DELETE     giuw_wperilds_dtl
       WHERE     dist_no   =   p_dist_no;
      DELETE     giuw_wperilds
       WHERE     dist_no   =   p_dist_no;
      DELETE     giuw_witemds_dtl
       WHERE     dist_no   =   p_dist_no;
      DELETE     giuw_witemds
       WHERE     dist_no   =   p_dist_no;
   BEGIN

      SELECT     frps_yy,   frps_seq_no
        INTO     p_frps_yy, p_frps_seq_no
        FROM     giri_wdistfrps
       WHERE     dist_no  =  p_dist_no
    GROUP BY     frps_yy,   frps_seq_no;
      DELETE     giri_wfrperil
       WHERE     frps_yy     =   p_frps_yy
         AND     frps_seq_no =   p_frps_seq_no;
      DELETE     giri_wfrps_ri
       WHERE     frps_yy     =   p_frps_yy
         AND     frps_seq_no =   p_frps_seq_no;
      DELETE     giri_wdistfrps
       WHERE     frps_yy     =   p_frps_yy
         AND     frps_seq_no =   p_frps_seq_no;
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
          NULL;
       WHEN NO_DATA_FOUND THEN 
          NULL;
   END;

      DELETE     giuw_wpolicyds_dtl
       WHERE     dist_no   =   p_dist_no;

      DELETE     giuw_wpolicyds
       WHERE     dist_no   =   p_dist_no;

      DELETE     giuw_pol_dist
       WHERE     dist_no   =   p_dist_no;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           NULL;
   END;
END;
/


