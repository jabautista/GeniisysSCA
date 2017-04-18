CREATE OR REPLACE PACKAGE CPI.csv_clm_per_payee
AS
/* Created by   : Edison
** Date created : 08.15.2012
** Description  : This will be used in printing the file directly to CSV.*/
   TYPE giclr259_rec_type IS RECORD (
      claim_no      VARCHAR2 (100),
      policy_no     VARCHAR2 (100),
      assd_name     giis_assured.assd_name%TYPE,
      loss_date     DATE,
      item_title    VARCHAR (200),
      peril         VARCHAR2 (50),
      advice_no     gicl_advice.advice_id%TYPE,
      hist_seq_no   gicl_clm_res_hist.hist_seq_no%TYPE,
      paid_amt      gicl_advice.paid_amt%TYPE,
      net_amt       gicl_advice.net_amt%TYPE,
      advise_amt    gicl_advice.advise_amt%TYPE
   );

   TYPE giclr259_type IS TABLE OF giclr259_rec_type;

   FUNCTION csv_giclr259 (
      p_payee_no         IN   NUMBER,
      p_payee_class_cd   IN   NUMBER,
      p_from_date        IN   DATE,
      p_to_date          IN   DATE,
      p_as_of_date       IN   DATE,
      p_from_ldate       IN   DATE,
      p_to_ldate         IN   DATE,
      p_as_of_ldate      IN   DATE
   )
      RETURN giclr259_type PIPELINED; --Edison 08.15.2012
END;
/

DROP PACKAGE CPI.CSV_CLM_PER_PAYEE;
