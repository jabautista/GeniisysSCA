CREATE OR REPLACE PACKAGE CPI.EXTRACT_LOSS_PROFILE AS
/* BY: PAU
   DATE: 28NOV06
   REMARKS: COMPILATION OF LOSS EXTRACT PROCEDURES
*/
PROCEDURE get_loss_ext (p_loss_sw  IN VARCHAR2,
     p_loss_fr  IN DATE,
   p_loss_to  IN DATE,
   p_line_cd  IN VARCHAR2,
   p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext2 (p_pol_sw  IN VARCHAR2,
           p_date_fr  IN DATE,
    p_date_to  IN DATE,
    p_line_cd  IN VARCHAR2,
    p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext3 (p_loss_sw  IN VARCHAR2,
      p_loss_fr  IN DATE,
                   p_loss_to  IN DATE,
    p_line_cd  IN VARCHAR2,
    p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext_peril (p_loss_sw  IN VARCHAR2,
           p_loss_fr   IN DATE,
         p_loss_to   IN DATE,
         p_line_cd   IN VARCHAR2,
                p_subline   IN VARCHAR2);
PROCEDURE get_loss_ext2_peril (p_pol_sw  IN VARCHAR2,
                 p_date_fr  IN DATE,
          p_date_to  IN DATE,
          p_line_cd  IN VARCHAR2,
          p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext3_peril (p_loss_sw  IN VARCHAR2,
                  p_loss_fr  IN DATE,
                         p_loss_to  IN DATE,
          p_line_cd  IN VARCHAR2,
                 p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext_fire (p_loss_sw  IN VARCHAR2,
                             p_loss_fr   IN DATE,
                             p_loss_to   IN DATE,
                             p_line_cd   IN VARCHAR2,
                             p_subline   IN VARCHAR2);
PROCEDURE get_loss_ext2_fire (p_pol_sw  IN VARCHAR2,
                p_date_fr  IN DATE,
         p_date_to  IN DATE,
         p_line_cd  IN VARCHAR2,
         p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext3_fire (p_loss_sw  IN VARCHAR2,
                 p_loss_fr  IN DATE,
                        p_loss_to  IN DATE,
         p_line_cd  IN VARCHAR2,
         p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext_motor (p_loss_sw  IN VARCHAR2,
                              p_loss_fr   IN DATE,
                              p_loss_to   IN DATE,
                              p_line_cd   IN VARCHAR2,
                              p_subline   IN VARCHAR2);
PROCEDURE get_loss_ext2_motor (p_pol_sw  IN VARCHAR2,
                 p_date_fr  IN DATE,
          p_date_to  IN DATE,
          p_line_cd  IN VARCHAR2,
          p_subline  IN VARCHAR2);
PROCEDURE get_loss_ext3_motor (p_loss_sw  IN VARCHAR2,
                  p_loss_fr  IN DATE,
                         p_loss_to  IN DATE,
          p_line_cd  IN VARCHAR2,
                               p_subline  IN VARCHAR2);
END EXTRACT_LOSS_PROFILE;
/


