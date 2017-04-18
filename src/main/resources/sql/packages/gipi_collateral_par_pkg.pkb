CREATE OR REPLACE PACKAGE BODY CPI.GIPI_COLLATERAL_PAR_PKG AS

/******************************************************************************
Created By; RManalad    4.26.2011

******************************************************************************/

  PROCEDURE add_coll_par(p_par_id GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date GIPI_COLL_PAR.receive_date%TYPE)
    IS
    BEGIN
        INSERT INTO GIPI_COLL_PAR
                    (par_id,
                     collateral_id,
                     collateral_val,
                     receive_date)
             VALUES (p_par_id,
                     p_coll_id,
                     p_coll_val,
                     p_rec_date);
    END;

PROCEDURE delete_coll_par(p_par_id GIPI_COLL_PAR.par_id%TYPE,
                         p_coll_id GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date GIPI_COLL_PAR.receive_date%TYPE)
    IS
    BEGIN

        DELETE FROM GIPI_COLL_PAR
              WHERE par_id           = p_par_id
                AND collateral_id    = p_coll_id
                AND collateral_val   = p_coll_val
                AND receive_date     = nvl(p_rec_date, '')
                AND (select rownum from GIPI_COLL_PAR
                                  WHERE par_id           = p_par_id
                                    AND collateral_id    = p_coll_id
                                    AND collateral_val   = p_coll_val
                                    AND receive_date     = p_rec_date
                                    AND rownum = 1)= rownum;
    END;

  PROCEDURE update_coll_par(p_par_id GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date GIPI_COLL_PAR.receive_date%TYPE,
                        p_par_id2 GIPI_COLL_PAR.par_id%TYPE,
                        p_coll_id2 GIPI_COLL_PAR.collateral_id%TYPE,
                        p_coll_val2 GIPI_COLL_PAR.collateral_val%TYPE,
                        p_rec_date2 GIPI_COLL_PAR.receive_date%TYPE
                        )
    IS
    BEGIN
        UPDATE  GIPI_COLL_PAR
         SET    par_id = p_par_id, collateral_id= p_coll_id,
                collateral_val =p_coll_val,
                receive_date = p_rec_date
              WHERE par_id           = p_par_id2
                AND collateral_id    = p_coll_id2
                AND collateral_val   = p_coll_val2
                AND receive_date     = p_rec_date2
                AND (select rownum from GIPI_COLL_PAR
                                  WHERE par_id           = p_par_id2
                                    AND collateral_id    = p_coll_id2
                                    AND collateral_val   = p_coll_val2
                                    AND receive_date     = p_rec_date2
                                    AND rownum = 1)= rownum;
    END;

END;
/


