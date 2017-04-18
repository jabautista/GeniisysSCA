CREATE OR REPLACE PACKAGE cpi.csv_big_clms
AS
   /* Modified by Aliza Garza 02.17.2016 SR 5362
   ** Based from CSV printing on CS
   ** This is changed because of the new PIPE syntax required for GenWeb (using one hash key 'REC')
   */
   TYPE giclr220_rec_type IS RECORD (
      rec               VARCHAR2(32767)
   );

   TYPE giclr220_type IS TABLE OF giclr220_rec_type;

   FUNCTION csv_giclr220 (
      p_session_id   NUMBER,
      p_loss_exp     VARCHAR2,
      p_amt          VARCHAR2
   )
      RETURN giclr220_type PIPELINED;
END;
/