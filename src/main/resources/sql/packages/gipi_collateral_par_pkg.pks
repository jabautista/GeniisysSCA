CREATE OR REPLACE PACKAGE CPI.GIPI_COLLATERAL_PAR_PKG AS

/******************************************************************************
Created By; RManald    4.26.2011

******************************************************************************/

  PROCEDURE add_coll_par(p_par_id IN GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id   IN GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val  IN GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date  IN GIPI_COLL_PAR.receive_date%TYPE );
                        
  PROCEDURE delete_coll_par(p_par_id IN GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id   IN GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val  IN GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date  IN GIPI_COLL_PAR.receive_date%TYPE );
                        
  PROCEDURE update_coll_par(p_par_id GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date GIPI_COLL_PAR.receive_date%TYPE,
                        p_par_id2 GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id2 GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val2 GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date2 GIPI_COLL_PAR.receive_date%TYPE
                        );
END;
/


