CREATE OR REPLACE PACKAGE BODY CPI.GIUTS007_PKG

AS
/*  created by: rmanalad
**  date created : 6/21/2012
**  reference : GIUTS007 module 
*/

 PROCEDURE copy_parlist(
        p_in_par_id   IN        gipi_parlist.par_id%TYPE,
        p_in_user_id  IN        gipi_parlist.underwriter%TYPE,
        p_in_iss_cd   IN        gipi_parlist.iss_cd%TYPE,
        p_copy_par_id IN OUT    gipi_parlist.par_id%TYPE,
        p_in_var_line_cd IN     gipi_parlist.line_cd%TYPE
   ) IS  
  v_line_cd             gipi_parlist.line_cd%TYPE;
  v_iss_cd              gipi_parlist.iss_cd%TYPE;
  v_par_yy              gipi_parlist.par_yy%TYPE;
  v_par_seq_no          gipi_parlist.par_seq_no%TYPE; 
  v_quote_seq_no        gipi_parlist.quote_seq_no%TYPE;
  v_par_type            gipi_parlist.par_type%TYPE;
  v_assd_no             gipi_parlist.assd_no%TYPE;
  v_remarks             gipi_parlist.remarks%TYPE;
  v_underwriter         gipi_parlist.underwriter%TYPE;
  v_assign_sw           gipi_parlist.assign_sw%TYPE;
  v_address1            gipi_parlist.address1%TYPE;
  v_address2            gipi_parlist.address2%TYPE;
  v_address3            gipi_parlist.address3%TYPE;
--  v_load_tag          gipi_parlist.load_tag%TYPE;
  v_par_status          gipi_parlist.par_status%TYPE;
--  v_quote_id          gipi_parlist.quote_id%TYPE;
  v_copy_par_id         gipi_parlist.par_id%TYPE;
  p_par_id              gipi_parlist.par_id%TYPE;
  p_line_cd             gipi_parlist.line_cd%TYPE;
  p_iss_cd              gipi_parlist.iss_cd%TYPE;
  p_par_yy              gipi_parlist.par_yy%TYPE;
  p_par_seq_no          gipi_parlist.par_seq_no%TYPE;
  p_quote_seq_no        gipi_parlist.quote_seq_no%TYPE;
  p_par_type            gipi_parlist.par_type%TYPE;
  p_assd_no             gipi_parlist.assd_no%TYPE;
  p_remarks             gipi_parlist.remarks%TYPE;
  p_underwriter         gipi_parlist.underwriter%TYPE;
  p_assign_sw           gipi_parlist.assign_sw%TYPE;
  p_address1            gipi_parlist.address1%TYPE;
  p_address2            gipi_parlist.address2%TYPE;
  p_address3            gipi_parlist.address3%TYPE; 
  p_load_tag            gipi_parlist.load_tag%TYPE;
  p_par_status          gipi_parlist.par_status%TYPE;

 BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying PAR List info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_parlist start ======='); 
  
  BEGIN
    SELECT parlist_par_id_s.nextval
      INTO v_copy_par_id 
      FROM DUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        raise_application_error('-20001', 'Cannot generate new PAR ID.');
--        BELL;
--        MESSAGE('Cannot generate new PAR ID.',ACKNOWLEDGE);
--        RAISE FORM_TRIGGER_FAILURE;
  END;
    p_copy_par_id := v_copy_par_id;

  BEGIN
      --beth 101800 load tag = 'U'
      --     load tag is use to determine how does a par is created
    SELECT line_cd,iss_cd,par_yy,par_seq_no,quote_seq_no,par_type,assd_no,
           underwriter,assign_sw,remarks,par_status,address1,address2,address3
           --,load_tag,quote_id
      INTO v_line_cd,v_iss_cd,v_par_yy,v_par_seq_no,v_quote_seq_no,v_par_type,
             v_assd_no,v_underwriter,v_assign_sw,v_remarks,v_par_status,v_address1,
             v_address2,v_address3
             --,v_load_tag,v_quote_id
      FROM gipi_parlist
    WHERE par_id = p_in_par_id;
 
    SELECT v_copy_par_id,line_cd,iss_cd,TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2)),
             par_seq_no,quote_seq_no,par_type,assd_no, p_in_user_id,'Y',remarks, 
             DECODE(par_status,6,5,98,old_par_status,par_status)  /*12/17/98 BETH update par status if 6 to 5*/ -- aron 050907 update par status if 98 to old_par_status 
             par_status,address1,address2,address3, 'U'
             --load_tag,quote_id
      INTO p_par_id,p_line_cd,p_iss_cd,p_par_yy,p_par_seq_no,p_quote_seq_no,p_par_type,
             p_assd_no,p_underwriter,p_assign_sw,p_remarks,p_par_status,p_address1,
             p_address2,p_address3,p_load_tag
      FROM gipi_parlist
    WHERE par_id = p_in_par_id;
 
    INSERT INTO gipi_parlist
          (par_id,line_cd,iss_cd,par_yy,par_seq_no,quote_seq_no,par_type,assd_no,
             underwriter,assign_sw,remarks,par_status,address1,address2,address3,
             load_tag)
             --,quote_id)
    VALUES (p_par_id,p_line_cd,p_in_iss_cd,p_par_yy,p_par_seq_no,p_quote_seq_no,p_par_type,
             p_assd_no,p_underwriter,p_assign_sw,p_remarks,p_par_status,p_address1,
             p_address2,p_address3,p_load_tag); 
  END;
  cpi.GIUTS007_PKG.copy_par(p_in_par_id,v_copy_par_id,p_line_cd,p_in_user_id,p_in_iss_cd,p_in_var_line_cd);
  --CLEAR_MESSAGE;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        NULL;
      --MESSAGE('There is no existing record.');
 END;
 

PROCEDURE copy_par(
       p_in_par_id          gipi_parlist.par_id%TYPE,
       p_in_copy_par_id     gipi_parlist.par_id%TYPE,
       p_in_line_cd         gipi_parlist.line_cd%TYPE,
       p_in_user_id         gipi_parlist.underwriter%TYPE,
       p_in_iss_cd          gipi_parlist.iss_cd%TYPE,
       p_in_var_line_cd     gipi_parlist.line_cd%TYPE
) IS
BEGIN
  DECLARE
    v_pack_pol_flag         giis_line.pack_pol_flag%TYPE;
    v_pack_line_cd          gipi_witem.pack_line_cd%TYPE;
    v_pack_subline_cd       gipi_witem.pack_subline_cd%TYPE;
    v_item_grp              gipi_witem.item_grp%TYPE;
    v_item_no               gipi_witem.item_no%TYPE;
    
    v_copy_fire_cd          gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_motor_cd         gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_accident_cd      gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_hull_cd          gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_cargo_cd         gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_casualty_cd      gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_engrng_cd        gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_surety_cd        gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    v_copy_aviation_cd      gipi_pack_line_subline.pack_line_cd%TYPE  := ' ';
    
    v_b2401_line_cd         gipi_parlist.line_cd%TYPE;
    v_b2401_iss_cd          gipi_parlist.iss_cd%TYPE;
    v_b2401_par_yy          gipi_parlist.par_yy%TYPE;
    v_b2401_par_seq_no      gipi_parlist.par_seq_no%TYPE;
    v_b2401_quote_seq_no    gipi_parlist.quote_seq_no%TYPE;
    v_b2401_par_id          gipi_parlist.par_id%TYPE;
    
    v_copy_long             gipi_wpolgenin.gen_info%TYPE;
    v_copy_gen01            gipi_wpolgenin.gen_info01%TYPE;
    v_copy_gen02            gipi_wpolgenin.gen_info02%TYPE;
    v_copy_gen03            gipi_wpolgenin.gen_info03%TYPE;
    v_copy_gen04            gipi_wpolgenin.gen_info04%TYPE;
    v_copy_gen05            gipi_wpolgenin.gen_info05%TYPE;
    v_copy_gen06            gipi_wpolgenin.gen_info06%TYPE;
    v_copy_gen07            gipi_wpolgenin.gen_info07%TYPE;
    v_copy_gen08            gipi_wpolgenin.gen_info08%TYPE;
    v_copy_gen09            gipi_wpolgenin.gen_info09%TYPE;
    v_copy_gen10            gipi_wpolgenin.gen_info10%TYPE;
    v_copy_gen11            gipi_wpolgenin.gen_info11%TYPE;
    v_copy_gen12            gipi_wpolgenin.gen_info12%TYPE;
    v_copy_gen13            gipi_wpolgenin.gen_info13%TYPE;
    v_copy_gen14            gipi_wpolgenin.gen_info14%TYPE;
    v_copy_gen15            gipi_wpolgenin.gen_info15%TYPE;
    v_copy_gen16            gipi_wpolgenin.gen_info16%TYPE;
    v_copy_gen17            gipi_wpolgenin.gen_info17%TYPE;
    
    v_line_cd               giis_line.line_cd%TYPE;
    v_menu_line_cd          giis_line.menu_line_cd%TYPE;
    

    
    cursor cur_flag  is
                   SELECT pack_line_cd,pack_subline_cd,item_grp,item_no
                     FROM gipi_witem
                    WHERE par_id = p_in_par_id
                 ORDER BY item_grp;
  v_open_flag         VARCHAR2(1) := 'N';
BEGIN
  /* BETH 011399 get op_flag to determine if the policy
  **             is an open policy or not
  */
  
      /* Formatted on 7/5/2012 3:14:28 PM (QP5 v5.115.810.9015) */
  read_into_copypar(v_copy_fire_cd,         v_copy_motor_cd,
                    v_copy_accident_cd,     v_copy_hull_cd,
                    v_copy_cargo_cd,        v_copy_casualty_cd,
                    v_copy_engrng_cd,       v_copy_surety_cd,
                    v_copy_aviation_cd);
DBMS_OUTPUT.PUT_LINE('====== copy_par start =======');
--  v_line_cd := p_in_var_line_cd; commented out by gab 09.24.2015
    v_line_cd := p_in_line_cd; -- added by gab 09.24.2015
  FOR SUBLINE IN (SELECT subline_cd
                    FROM gipi_wpolbas
                   WHERE par_id = p_in_par_id)
    LOOP
      FOR FLAG IN(SELECT op_flag
                    FROM giis_subline
                   WHERE line_cd     = p_in_line_cd
                     AND subline_cd  = subline.subline_cd) 
      LOOP
           v_open_flag := flag.op_flag;
           EXIT;
      END LOOP; 
      EXIT;
   END LOOP;

  BEGIN
  SELECT line_cd,iss_cd,par_yy,par_seq_no,quote_seq_no,par_id
    INTO v_b2401_line_cd,v_b2401_iss_cd,v_b2401_par_yy,v_b2401_par_seq_no,
         v_b2401_quote_seq_no,v_b2401_par_id
    FROM gipi_parlist
   WHERE par_id = p_in_par_id;
  END;

  copy_wpolbas(p_in_par_id,p_in_copy_par_id,p_in_user_id,p_in_iss_cd,v_b2401_iss_cd);

  copy_wmortgagee(p_in_iss_cd,p_in_par_id,p_in_copy_par_id);
  copy_wpolicy_deductibles(p_in_par_id, p_in_copy_par_id);
  copy_wpolgenin(p_in_par_id,
                 p_in_copy_par_id,
                 v_copy_long,
                 v_copy_gen01,
                 v_copy_gen02,
                 v_copy_gen03,
                 v_copy_gen04,
                 v_copy_gen05,
                 v_copy_gen06,
                 v_copy_gen07,
                 v_copy_gen08,
                 v_copy_gen09,
                 v_copy_gen10,
                 v_copy_gen11,
                 v_copy_gen12,
                 v_copy_gen13,
                 v_copy_gen14,
                 v_copy_gen15,
                 v_copy_gen16,
                 v_copy_gen17
                );
  --beth 10192000 info for policy renewal/replacement should be unique
  --     per policy so this should not be copied    
  --copy_wpolnrep;
  copy_wopen_policy(p_in_par_id,p_in_copy_par_id);
  copy_wlim_liab(p_in_par_id,p_in_copy_par_id);
  --grace 10/06/2000
  --requested by ms. rose
  --copy_orig_comm_invoice;
  --copy_orig_comm_inv_peril;
  copy_orig_invoice(p_in_par_id,p_in_copy_par_id);
  copy_orig_invperl(p_in_par_id,p_in_copy_par_id);
  copy_orig_inv_tax(p_in_par_id,p_in_copy_par_id);
  copy_orig_itmperil(p_in_par_id,p_in_copy_par_id);
  -- longterm --
  copy_winvoice(p_in_par_id,p_in_copy_par_id);
  copy_winvperl(p_in_par_id,p_in_copy_par_id);
  copy_winstallment(p_in_par_id,p_in_copy_par_id);
  copy_winv_tax(p_in_par_id,p_in_copy_par_id);
-- Commented by loth table has been dropped
--  copy_wperiltax(v_item_grp);
  copy_wendttext(v_copy_long,p_in_par_id,p_in_copy_par_id);
  --grace 10/06/2000
  --requested by ms. rose
  --copy_wcomm_invoices(v_item_grp);
  --copy_wcomm_inv_perils(v_item_grp);
  
    SELECT pack_pol_flag
      INTO v_pack_pol_flag
      FROM giis_line
     WHERE line_cd = p_in_line_cd;

 IF v_pack_pol_flag = 'Y' THEN
          copy_wpack_line_subline(p_in_par_id,p_in_copy_par_id);
 END IF;
 FOR var_flag IN cur_flag LOOP
      v_pack_line_cd := var_flag.pack_line_cd;
      v_pack_subline_cd := var_flag.pack_subline_cd;  
      v_item_grp  := var_flag.item_grp;
      v_item_no   := var_flag.item_no;
   
   FOR v IN (SELECT menu_line_cd
               FROM giis_line
              WHERE line_cd = v_line_cd) LOOP    -- replace  variable.v_line_cd
     v_menu_line_cd := v.menu_line_cd;          -- replace   variable.v_menu_line_cd
     EXIT;
   END LOOP;                   
   DBMS_OUTPUT.PUT_LINE('v_pack_pol_flag ='|| v_pack_pol_flag);
   IF v_pack_pol_flag = 'Y' THEN
      copy_witem_pack(p_in_par_id,p_in_copy_par_id,v_item_grp,v_item_no);
      copy_wline(v_item_no,
                 v_item_grp,
                 v_pack_line_cd,
                 v_pack_subline_cd,
                 p_in_par_id,
                 p_in_copy_par_id,
                 v_copy_fire_cd,      
                 v_copy_motor_cd,
                 v_copy_accident_cd,  
                 v_copy_hull_cd, 
                 v_copy_cargo_cd,     
                 v_copy_casualty_cd,  
                 v_copy_engrng_cd,    
                 v_copy_surety_cd,    
                 v_copy_aviation_cd
                 );
   ELSE
   DBMS_OUTPUT.PUT_LINE('v_line_cd ='|| v_line_cd);
   DBMS_OUTPUT.PUT_LINE('v_copy_surety_cd ='|| v_copy_surety_cd);
   
       
     IF /*:b2402.line_cd*/v_line_cd != v_copy_surety_cd THEN   -- replace
        DBMS_OUTPUT.PUT_LINE('v_item_no ='|| v_item_no);
        copy_witem(v_item_no,p_in_par_id,p_in_copy_par_id);
        copy_witmperl(v_item_no,p_in_par_id,p_in_copy_par_id, p_in_line_cd);
     END IF;
     
      IF /*:b2402.line_cd*/v_line_cd = v_copy_fire_cd OR   -- replace
         v_menu_line_cd = 'FI' THEN  
         copy_wfireitm(v_item_no,p_in_par_id,p_in_copy_par_id);
     
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_motor_cd OR   -- replace
         v_menu_line_cd = 'MC' THEN
         copy_wvehicle(v_item_no,p_in_par_id,p_in_copy_par_id);
         copy_wmcacc(v_item_no,p_in_par_id,p_in_copy_par_id);
     
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_accident_cd OR  -- replace
         v_menu_line_cd = 'AC' THEN
         copy_waccident_item(v_item_no,p_in_par_id,p_in_copy_par_id);
         copy_wbeneficiary(v_item_no,p_in_par_id,p_in_copy_par_id);
     
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_hull_cd OR   -- replace
         v_menu_line_cd = 'MH' THEN
         copy_witem_ves(v_item_no,p_in_par_id,p_in_copy_par_id);
     
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_cargo_cd OR   -- replace
         v_menu_line_cd = 'MN' THEN
         copy_wcargo(v_item_no,p_in_par_id,p_in_copy_par_id);
         copy_wves_accumulation(v_item_no,p_in_par_id,p_in_copy_par_id);
     
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_casualty_cd OR   --replace
         v_menu_line_cd = 'CA' THEN
-- Commented by Loth 081699 table has been dropped
--         copy_wbank_blanket(v_item_no);
         copy_wcasualty_item(v_item_no,p_in_par_id,p_in_copy_par_id);
         copy_wcasualty_personnel(v_item_no,p_in_par_id,p_in_copy_par_id);
--         copy_wperil_section(v_item_no,v_pack_line_cd,v_pack_subline_cd);
      
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_engrng_cd OR   --replace
         v_menu_line_cd = 'EN' THEN
         copy_wlocation(v_item_no,p_in_par_id,p_in_copy_par_id);
      
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_surety_cd OR--replace edited by gab 09.24.2015
         v_menu_line_cd = 'SU' THEN -- added by gab 09.24.2015 
         copy_witmperl(v_item_no,p_in_par_id,p_in_copy_par_id,p_in_line_cd); 
      
      ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_aviation_cd OR   --replace
         v_menu_line_cd = 'AV' THEN
         copy_waviation_item(v_item_no,p_in_par_id,p_in_copy_par_id);
      
      END IF;
   END IF;
   
   copy_wgrouped_items(v_item_no,p_in_par_id,p_in_copy_par_id);
   copy_wpictures(v_item_no,p_in_par_id,p_in_copy_par_id);
   copy_wdeductibles(v_item_no,p_in_par_id,p_in_copy_par_id);
 END LOOP;    
     DBMS_OUTPUT.PUT_LINE('v_open_flag ='||v_open_flag);
  IF v_open_flag = 'Y' AND (v_line_cd != v_copy_cargo_cd OR   --replace
         v_menu_line_cd != 'MN') THEN
         DBMS_OUTPUT.PUT_LINE('*******HERE 1************');
         copy_wopen_liab(p_in_par_id,p_in_copy_par_id);
         copy_wopen_peril(v_line_cd,p_in_par_id,p_in_copy_par_id);
  END IF;   
      DBMS_OUTPUT.PUT_LINE('v_line_cd ='||v_line_cd);
      DBMS_OUTPUT.PUT_LINE('v_copy_cargo_cd ='||v_copy_cargo_cd);
      DBMS_OUTPUT.PUT_LINE('v_menu_line_cd ='||v_menu_line_cd);
      DBMS_OUTPUT.PUT_LINE('v_pack_pol_flag ='||v_pack_pol_flag);
  IF /*:b2402.line_cd*/(v_line_cd = v_copy_cargo_cd OR   -- replace
      v_menu_line_cd = 'MN') OR 
      v_pack_pol_flag = 'Y' THEN
      DBMS_OUTPUT.PUT_LINE('*******HERE 2************');
      copy_wves_air(p_in_par_id,p_in_copy_par_id);
      copy_wopen_liab(p_in_par_id,p_in_copy_par_id);
      copy_wopen_cargo(p_in_par_id,p_in_copy_par_id);
      copy_wopen_peril(v_pack_line_cd,p_in_par_id,p_in_copy_par_id);
      copy_wcargo_carrier(p_in_user_id,p_in_par_id,p_in_copy_par_id);
      
  ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_engrng_cd OR   --replace
      v_menu_line_cd = 'EN' OR
      v_pack_pol_flag = 'Y' THEN
      copy_wengg_basic(p_in_par_id,p_in_copy_par_id);
      copy_wprincipal(p_in_par_id,p_in_copy_par_id);
      
  ELSIF /*:b2402.line_cd*/v_line_cd = v_copy_surety_cd OR   --replace
      v_pack_pol_flag = 'Y'  THEN
      copy_wbond_basic(p_in_par_id,p_in_copy_par_id);
      copy_wcosigntry(p_in_par_id,p_in_copy_par_id);
      
  END IF;
-- Commented by Loth 081699 table has been dropped
--  copy_wgroup_item;
--  copy_wgroup_peril;
  copy_wpolwc(p_in_par_id,p_in_copy_par_id);
  copy_pol_dist(p_in_par_id,p_in_user_id,p_in_iss_cd,p_in_copy_par_id);
  copy_wperil_discount(v_item_no,p_in_par_id,p_in_copy_par_id);
  copy_co_ins(p_in_par_id,p_in_copy_par_id);   --BETH 020699
  
   FOR A IN (SELECT 1
              FROM gipi_witmperl
             WHERE par_id = p_in_copy_par_id) LOOP  -- replace
     
    IF v_open_flag = 'N' THEN
--       message('Creating invoice information...', NO_ACKNOWLEDGE);
        DBMS_OUTPUT.PUT_LINE('*******before CREATE_WINVOICE************');
       CREATE_WINVOICE(0,0, 0, p_in_copy_par_id, p_in_line_cd, p_in_iss_cd);
       DBMS_OUTPUT.PUT_LINE('*******before CR_BILL_DIST************');
--       message('Creating distribution information...', NO_ACKNOWLEDGE);
       CR_BILL_DIST.GET_TSI(p_in_copy_par_id);
    ELSE 
       -- BETH 111399 update par status for open policy so that it will bw ready for posting
       UPDATE gipi_parlist
          SET par_status = 6
        WHERE par_id = p_in_copy_par_id;
    END IF;
    EXIT;
  END LOOP;
END;
DBMS_OUTPUT.PUT_LINE('*******ENF OF COPY_PAR************');
END; 
 
 

PROCEDURE copy_co_ins (
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE 
    ) IS
       
    CURSOR A1 IS
        SELECT co_ri_cd, co_ri_shr_pct,    
               co_ri_prem_amt, co_ri_tsi_amt     
          FROM gipi_co_insurer
         WHERE par_id  = p_par_id;

    CURSOR A IS
        SELECT tsi_amt,prem_amt
          FROM gipi_main_co_ins
         WHERE par_id  = p_par_id;

    CURSOR c IS
        SELECT SYSDATE, USER
          FROM sys.dual;
          
    v_user          gipi_co_insurer.user_id%TYPE;     
    v_date          gipi_co_insurer.last_update%TYPE;
    
    BEGIN
    DBMS_OUTPUT.PUT_LINE('====== copy_co_ins start =======');
      BEGIN
        OPEN c;
        FETCH c
         INTO v_date, v_user;
        IF c%NOTFOUND THEN
          NULL;
          --msg_alert('No row in table SYS.DUAL','F',TRUE);
        END IF;
        CLOSE c;
      EXCEPTION
       WHEN OTHERS THEN
         null;  -- ante
       -- cgte$other_exceptions;
      END;
      
      BEGIN
        --CLEAR_MESSAGE;
        --MESSAGE('Copying item peril information ...',NO_ACKNOWLEDGE);
        --SYNCHRONIZE;
        FOR A1 IN A LOOP
           INSERT INTO gipi_main_co_ins
              (par_id, tsi_amt, prem_amt,
              user_id, last_update)
          VALUES (p_copy_par_id,A1.tsi_amt,A1.prem_amt,
              v_user, v_date);
          IF SQL%NOTFOUND THEN
            EXIT;
          END IF;
        END LOOP;
        --CLEAR_MESSAGE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
        NULL; 
      END;

      BEGIN
        --CLEAR_MESSAGE;
        --SYNCHRONIZE;
        FOR A3 IN A1 LOOP
            INSERT INTO gipi_co_insurer
                (par_id,          co_ri_cd,       co_ri_shr_pct,    
                co_ri_prem_amt,   co_ri_tsi_amt,   user_id,       
                last_update)
            VALUES (p_copy_par_id,      A3.co_ri_cd,        A3.co_ri_shr_pct,    
                A3.co_ri_prem_amt,      A3.co_ri_tsi_amt,   v_user,
                v_date);
            IF SQL%NOTFOUND THEN
                EXIT;
            END IF;
        END LOOP;
        --CLEAR_MESSAGE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            NULL; 
        END;
        
    END;
    
    PROCEDURE copy_orig_comm_inv (
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  ) IS
  
  CURSOR comm_cur IS 
  SELECT intrmdry_intm_no, item_grp, premium_amt, share_percentage,
         commission_amt, wholding_tax, policy_id, iss_cd, prem_seq_no       
  FROM gipi_orig_comm_invoice
  WHERE par_id = p_par_id;
 
  v_intrmdry_intm_no   gipi_orig_comm_invoice.intrmdry_intm_no%TYPE;
  v_item_grp           gipi_orig_comm_invoice.item_grp%TYPE;
  v_premium_amt        gipi_orig_comm_invoice.premium_amt%TYPE;
  v_share_percentage   gipi_orig_comm_invoice.share_percentage%TYPE;
  v_commission_amt     gipi_orig_comm_invoice.commission_amt%TYPE;
  v_wholding_tax       gipi_orig_comm_invoice.wholding_tax%TYPE;
  v_policy_id          gipi_orig_comm_invoice.policy_id%TYPE;
  v_iss_cd             gipi_orig_comm_invoice.iss_cd%TYPE;
  v_prem_seq_no        gipi_orig_comm_invoice.prem_seq_no%TYPE;  
  
  BEGIN
   --CLEAR_MESSAGE;
   --MESSAGE('Copying Original Commission Invoice information ...',NO_ACKNOWLEDGE);
   --SYNCHRONIZE;
   DBMS_OUTPUT.PUT_LINE('====== copy_orig_comm_inv start ======='); 
   OPEN comm_cur;
    LOOP
     FETCH comm_cur
     INTO v_intrmdry_intm_no, v_item_grp, v_premium_amt, v_share_percentage,
          v_commission_amt, v_wholding_tax, v_policy_id, v_iss_cd, v_prem_seq_no;
     EXIT WHEN comm_cur%NOTFOUND;
     INSERT INTO gipi_orig_comm_invoice
           (par_id, intrmdry_intm_no, item_grp, premium_amt, share_percentage,
            commission_amt, wholding_tax, policy_id, iss_cd, prem_seq_no) 
     VALUES (p_copy_par_id, v_intrmdry_intm_no, v_item_grp, v_premium_amt, v_share_percentage,
            v_commission_amt, v_wholding_tax, v_policy_id, v_iss_cd, v_prem_seq_no);
    END LOOP;
  --CLEAR_MESSAGE;
  CLOSE comm_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  
  
  PROCEDURE copy_orig_cominv_per(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  ) IS
  
   CURSOR inv_cur IS 
      SELECT intrmdry_intm_no, item_grp, peril_cd, premium_amt, policy_id, iss_cd,
             prem_seq_no, commission_amt, commission_rt, wholding_tax       
        FROM gipi_orig_comm_inv_peril
       WHERE par_id = p_par_id;
    v_intrmdry_intm_no   gipi_orig_comm_inv_peril.intrmdry_intm_no%TYPE;
    v_item_grp           gipi_orig_comm_inv_peril.item_grp%TYPE;
    v_peril_cd           gipi_orig_comm_inv_peril.peril_cd%TYPE;
    v_premium_amt        gipi_orig_comm_inv_peril.premium_amt%TYPE;
    v_policy_id          gipi_orig_comm_inv_peril.policy_id%TYPE;
    v_iss_cd             gipi_orig_comm_inv_peril.iss_cd%TYPE;
    v_prem_seq_no        gipi_orig_comm_inv_peril.prem_seq_no%TYPE;
    v_commission_amt     gipi_orig_comm_inv_peril.commission_amt%TYPE;
    v_commission_rt      gipi_orig_comm_inv_peril.commission_rt%TYPE;
    v_wholding_tax       gipi_orig_comm_inv_peril.wholding_tax%TYPE; 
    BEGIN
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Original Commission Invoice Peril information ...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_orig_cominv_per start ======='); 
    OPEN inv_cur;
    LOOP
        FETCH inv_cur
        INTO v_intrmdry_intm_no, v_item_grp, v_peril_cd, v_premium_amt, v_policy_id, v_iss_cd,
              v_prem_seq_no, v_commission_amt, v_commission_rt, v_wholding_tax; 
        EXIT WHEN inv_cur%NOTFOUND;
        INSERT INTO gipi_orig_comm_inv_peril
           (par_id, intrmdry_intm_no, item_grp, peril_cd, premium_amt, policy_id, iss_cd,
            prem_seq_no, commission_amt, commission_rt, wholding_tax ) 
        VALUES (p_copy_par_id, v_intrmdry_intm_no, v_item_grp, v_peril_cd, v_premium_amt, 
            v_policy_id, v_iss_cd, v_prem_seq_no, v_commission_amt, v_commission_rt, 
            v_wholding_tax);
    END LOOP;
  --CLEAR_MESSAGE;
    CLOSE inv_cur;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        NULL;
END;

  PROCEDURE copy_orig_invoice(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  ) IS
   CURSOR orig_inv_cur IS 
    SELECT item_grp, policy_id, iss_cd, prem_seq_no, prem_amt, tax_amt, other_charges,
           ref_inv_no, policy_currency, property, insured, ri_comm_amt, currency_cd,
           currency_rt, remarks        
      FROM gipi_orig_invoice
     WHERE par_id = p_par_id;

  v_item_grp           gipi_orig_invoice.item_grp%TYPE;
  v_policy_id          gipi_orig_invoice.policy_id%TYPE;
  v_iss_cd             gipi_orig_invoice.iss_cd%TYPE; 
  v_prem_seq_no        gipi_orig_invoice.prem_seq_no%TYPE;
  v_prem_amt           gipi_orig_invoice.prem_amt%TYPE;
  v_tax_amt            gipi_orig_invoice.tax_amt%TYPE;
  v_other_charges      gipi_orig_invoice.other_charges%TYPE; 
  v_ref_inv_no         gipi_orig_invoice.ref_inv_no%TYPE;
  v_policy_currency    gipi_orig_invoice.policy_currency%TYPE;
  v_property           gipi_orig_invoice.property%TYPE;
  v_insured            gipi_orig_invoice.insured%TYPE;
  v_ri_comm_amt        gipi_orig_invoice.ri_comm_amt%TYPE;
  v_currency_cd        gipi_orig_invoice.currency_cd%TYPE;  
  v_currency_rt        gipi_orig_invoice.currency_rt%TYPE;
  v_remarks            gipi_orig_invoice.remarks%TYPE;
  
 BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying Original Invoice Peril information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;

DBMS_OUTPUT.PUT_LINE('====== copy_orig_invoice start ======='); 
    OPEN orig_inv_cur;
    LOOP
      FETCH orig_inv_cur
      INTO v_item_grp, v_policy_id, v_iss_cd, v_prem_seq_no, v_prem_amt, v_tax_amt, 
         v_other_charges, v_ref_inv_no, v_policy_currency, v_property, v_insured, 
         v_ri_comm_amt, v_currency_cd, v_currency_rt, v_remarks;
      EXIT WHEN orig_inv_cur%NOTFOUND;
      INSERT INTO gipi_orig_invoice
            (par_id, item_grp, policy_id, iss_cd, prem_seq_no, prem_amt, tax_amt, 
            other_charges, ref_inv_no, policy_currency, property, insured, ri_comm_amt, 
            currency_cd, currency_rt, remarks ) 
      VALUES (p_copy_par_id, v_item_grp, v_policy_id, v_iss_cd, v_prem_seq_no, v_prem_amt,
            v_tax_amt, v_other_charges, v_ref_inv_no, v_policy_currency, v_property, 
            v_insured, v_ri_comm_amt, v_currency_cd, v_currency_rt, v_remarks);
    END LOOP;
--  CLEAR_MESSAGE;
    CLOSE orig_inv_cur;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      NULL;
 END;


  PROCEDURE copy_orig_invperl(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  ) IS
   CURSOR orig_invperl_cur IS 
   SELECT item_grp,
          peril_cd,
          tsi_amt,
          prem_amt,
          policy_id,
          ri_comm_amt,
          ri_comm_rt
     FROM gipi_orig_invperl
    WHERE par_id = p_par_id;
     

   v_item_grp         gipi_orig_invperl.item_grp%TYPE;
   v_peril_cd         gipi_orig_invperl.peril_cd%TYPE;
   v_tsi_amt          gipi_orig_invperl.tsi_amt%TYPE;
   v_prem_amt         gipi_orig_invperl.prem_amt%TYPE;
   v_policy_id        gipi_orig_invperl.policy_id%TYPE;
   v_ri_comm_amt      gipi_orig_invperl.ri_comm_amt%TYPE;
   v_ri_comm_rt       gipi_orig_invperl.ri_comm_rt%TYPE;
  

  BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying original invoice peril info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_par start ======='); 
   OPEN orig_invperl_cur;
   LOOP
    FETCH orig_invperl_cur
     INTO v_item_grp,
      v_peril_cd,
      v_tsi_amt,
      v_prem_amt,
      v_policy_id,
      v_ri_comm_amt,
      v_ri_comm_rt;
     EXIT WHEN orig_invperl_cur%NOTFOUND;
    INSERT INTO gipi_orig_invperl
      (par_id, item_grp, peril_cd, tsi_amt, prem_amt,
      policy_id, ri_comm_amt, ri_comm_rt) 
   VALUES 
      (p_copy_par_id, v_item_grp, v_peril_cd, v_tsi_amt,v_prem_amt, 
      v_policy_id, v_ri_comm_amt, v_ri_comm_rt);
   END LOOP;
   CLOSE orig_invperl_cur;
--  CLEAR_MESSAGE;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
  END;
  
  
  PROCEDURE copy_orig_inv_tax(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  ) IS
   CURSOR orig_invtax_cur IS 
   SELECT item_grp,               
          tax_cd,
          line_cd,
          tax_allocation,
          fixed_tax_allocation,
          policy_id,
          iss_cd,
          tax_amt,
          tax_id,
          rate
     FROM gipi_orig_inv_tax
    WHERE par_id = p_par_id;
     

    v_item_grp              gipi_orig_inv_tax.item_grp%TYPE;
    v_tax_cd                gipi_orig_inv_tax.tax_cd%TYPE;
    v_line_cd               gipi_orig_inv_tax.line_cd%TYPE;
    v_tax_allocation        gipi_orig_inv_tax.tax_allocation%TYPE;
    v_fixed_tax_allocation  gipi_orig_inv_tax.fixed_tax_allocation%TYPE;
    v_policy_id             gipi_orig_inv_tax.policy_id%TYPE;
    v_iss_cd                gipi_orig_inv_tax.iss_cd%TYPE;
    v_tax_amt               gipi_orig_inv_tax.tax_amt%TYPE;
    v_tax_id                gipi_orig_inv_tax.tax_id%TYPE;  
    v_rate                  gipi_orig_inv_tax.rate%TYPE;

  BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying original invoice tax info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_orig_inv_tax start ======='); 
   OPEN orig_invtax_cur;
   LOOP
     FETCH orig_invtax_cur
      INTO v_item_grp,v_tax_cd,v_line_cd,v_tax_allocation,v_fixed_tax_allocation,
           v_policy_id,v_iss_cd,v_tax_amt,v_tax_id,v_rate;
     EXIT WHEN orig_invtax_cur%NOTFOUND;
   INSERT INTO gipi_orig_inv_tax
          (par_id,item_grp,tax_cd,line_cd,tax_allocation,fixed_tax_allocation,
          policy_id,iss_cd,tax_amt,tax_id,rate) 
          
   VALUES (p_copy_par_id, v_item_grp,v_tax_cd,v_line_cd,v_tax_allocation,
          v_fixed_tax_allocation,v_policy_id,v_iss_cd,v_tax_amt,v_tax_id,v_rate);
          
   END LOOP;
    CLOSE orig_invtax_cur;
--  CLEAR_MESSAGE;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  
  PROCEDURE copy_orig_itmperil(
        p_par_id gipi_parlist.par_id%TYPE,
        p_copy_par_id gipi_parlist.par_id%TYPE    
  )IS
  
  CURSOR orig_itmperil_cur IS 
  SELECT  item_no,line_cd,peril_cd,rec_flag,policy_id,prem_rt,prem_amt,tsi_amt,
          ann_prem_amt,ann_tsi_amt,comp_rem,discount_sw,ri_comm_rate,ri_comm_amt,
          surcharge_sw
    FROM gipi_orig_itmperil
   WHERE par_id = p_par_id;
     

  v_item_no             gipi_orig_itmperil.item_no%TYPE;
  v_line_cd             gipi_orig_itmperil.line_cd%TYPE;
  v_peril_cd            gipi_orig_itmperil.peril_cd%TYPE;
  v_rec_flag            gipi_orig_itmperil.rec_flag%TYPE;
  v_policy_id           gipi_orig_itmperil.policy_id%TYPE;
  v_prem_rt             gipi_orig_itmperil.prem_rt%TYPE;
  v_prem_amt            gipi_orig_itmperil.prem_amt%TYPE;
  v_tsi_amt             gipi_orig_itmperil.tsi_amt%TYPE;
  v_ann_prem_amt        gipi_orig_itmperil.ann_prem_amt%TYPE;
  v_ann_tsi_amt         gipi_orig_itmperil.ann_tsi_amt%TYPE;
  v_comp_rem            gipi_orig_itmperil.comp_rem%TYPE;  
  v_discount_sw         gipi_orig_itmperil.discount_sw%TYPE;
  v_ri_comm_rate        gipi_orig_itmperil.ri_comm_rate%TYPE;
  v_ri_comm_amt         gipi_orig_itmperil.ri_comm_amt%TYPE;
  v_surcharge_sw        gipi_orig_itmperil.surcharge_sw%TYPE;

 BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying original item peril info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_orig_itmperil start ======='); 
  OPEN orig_itmperil_cur;
  LOOP
    FETCH orig_itmperil_cur
     INTO v_item_no,         v_line_cd,        v_peril_cd,
          v_rec_flag,        v_policy_id,      v_prem_rt,
          v_prem_amt,        v_tsi_amt,        v_ann_prem_amt,
          v_ann_tsi_amt,     v_comp_rem,       v_discount_sw,
          v_ri_comm_rate,    v_ri_comm_amt,    v_surcharge_sw;
     EXIT WHEN orig_itmperil_cur%NOTFOUND;
   INSERT INTO gipi_orig_itmperil
         (par_id,item_no,    line_cd,          peril_cd,
          rec_flag,          policy_id,        prem_rt,
          prem_amt,          tsi_amt,          ann_prem_amt,
          ann_tsi_amt,       comp_rem,         discount_sw,
          ri_comm_rate,      ri_comm_amt,      surcharge_sw) 
   VALUES (p_copy_par_id,    v_item_no,        v_line_cd,     v_peril_cd,
          v_rec_flag,        v_policy_id,      v_prem_rt,
          v_prem_amt,        v_tsi_amt,        v_ann_prem_amt,
          v_ann_tsi_amt,     v_comp_rem,       v_discount_sw,
          v_ri_comm_rate,    v_ri_comm_amt,    v_surcharge_sw);
  END LOOP;
  CLOSE orig_itmperil_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
 END;
 
 
  PROCEDURE copy_pol_dist(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_iss_cd        gipi_parlist.iss_cd%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE  
  )IS
  CURSOR pol_dist_cur IS
  SELECT endt_type,tsi_amt,prem_amt,ann_tsi_amt,redist_flag,dist_type,
         item_posted_sw,ex_loss_sw,batch_id,post_flag
         ,item_grp,takeup_seq_no /* ** 12/20/2010 bhev added columns ** */ 
    FROM giuw_pol_dist
   WHERE par_id = p_in_par_id;

  v_endt_type              giuw_pol_dist.endt_type%TYPE;
  v_tsi_amt                giuw_pol_dist.tsi_amt%TYPE;
  v_prem_amt               giuw_pol_dist.prem_amt%TYPE;
  v_ann_tsi_amt            giuw_pol_dist.ann_tsi_amt%TYPE;
  v_redist_flag            giuw_pol_dist.redist_flag%TYPE;
  v_dist_type              giuw_pol_dist.dist_type%TYPE;
  v_item_posted_sw         giuw_pol_dist.item_posted_sw%TYPE;
  v_ex_loss_sw             giuw_pol_dist.ex_loss_sw%TYPE;
  v_batch_id               giuw_pol_dist.batch_id%TYPE;
  v_post_flag              giuw_pol_dist.post_flag%TYPE;
  v_dist_no                giuw_pol_dist.dist_no%TYPE;
  -- longterm --
  p_no_of_takeup           GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
  p_yearly_tag             GIIS_TAKEUP_TERM.yearly_tag%TYPE;
  p_takeup_term            GIPI_WPOLBAS.takeup_term%TYPE;
  p_eff_date               GIPI_WPOLBAS.eff_date%TYPE;
  p_expiry_date            GIPI_WPOLBAS.expiry_date%TYPE;
  p_endt_type              GIPI_WPOLBAS.endt_type%TYPE;
  p_policy_id              GIPI_POLBASIC.policy_id%TYPE;                              

  v_policy_days            NUMBER:=0;
  v_no_of_payment          NUMBER:=1;
  v_duration_frm           DATE;
  v_duration_to            DATE;              
  v_days_interval          NUMBER:=0;
 BEGIN
    
--  CLEAR_MESSAGE;
--  MESSAGE('Copying policy distribution info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_pol_dist start ======='); 
  
     SELECT eff_date,
            expiry_date, 
            endt_type,
            takeup_term
       INTO p_eff_date,
            p_expiry_date,
            p_endt_type,
            p_takeup_term
       FROM gipi_wpolbas
      WHERE par_id  =  p_in_copy_par_id;
          
         IF TRUNC(p_expiry_date - p_eff_date) = 31 THEN
           v_policy_days      := 30;
         ELSE
           v_policy_days      := TRUNC(p_expiry_date - p_eff_date);
         END IF;
         
         FOR b1 IN (SELECT no_of_takeup, yearly_tag
                          FROM giis_takeup_term
                       WHERE takeup_term = p_takeup_term)
         LOOP
             p_no_of_takeup := b1.no_of_takeup;
           p_yearly_tag   := b1.yearly_tag;
         END LOOP;
         
         IF p_yearly_tag = 'Y' THEN
             IF TRUNC((v_policy_days)/365,2) * p_no_of_takeup >
                 TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) THEN
                 v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) + 1;
             ELSE
                 v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup);
             END IF;
         ELSE
             IF v_policy_days < p_no_of_takeup THEN
                 v_no_of_payment := v_policy_days;
             ELSE
                 v_no_of_payment := p_no_of_takeup;
             END IF;
         END IF;
         
         IF v_no_of_payment < 1 THEN
             v_no_of_payment := 1;
         END IF;
        
        v_days_interval := ROUND(v_policy_days/v_no_of_payment);         
  
  FOR v IN pol_dist_cur LOOP
      BEGIN
        SELECT pol_dist_dist_no_s.nextval
          INTO v_dist_no
          FROM sys.dual;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
            --CGTE$OTHER_EXCEPTIONS;
      END;      
        
      IF v_duration_frm IS NULL THEN
           v_duration_frm := TRUNC(p_eff_date);                                             
        ELSE
           v_duration_frm := TRUNC(v_duration_frm + v_days_interval);                           
        END IF;
        v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
        
      INSERT INTO giuw_pol_dist
         (dist_no,          par_id,          policy_id,     endt_type,      tsi_amt,        prem_amt,     ann_tsi_amt,
          dist_flag,        redist_flag,     eff_date,      expiry_date,    negate_date,    dist_type,
          item_posted_sw,   ex_loss_sw,      acct_ent_date, acct_neg_date,  create_date,
          user_id,          last_upd_date,   batch_id,      post_flag,      item_grp,       takeup_seq_no)
    VALUES (v_dist_no,      p_in_copy_par_id,NULL,          v.endt_type,    v.tsi_amt,      v.prem_amt,   v.ann_tsi_amt,
          '1',              v.redist_flag,   v_duration_frm,v_duration_to,/*SYSDATE,(SYSDATE + 365)longterm comment*/  NULL,v.dist_type,
          v.item_posted_sw, v.ex_loss_sw,    NULL,          NULL,           SYSDATE,            
          USER,             SYSDATE,         v.batch_id,    v.post_flag,    v.item_grp,     v.takeup_seq_no);  
    
  END LOOP;
  /*CLOSE pol_dist_cur;*/
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
 END;
  

  PROCEDURE copy_waccident_item (
      p_item_no IN       gipi_item.item_no%TYPE,
      p_in_par_id        gipi_parlist.par_id%TYPE,
      p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR accident_item_cur IS 
  SELECT item_no,date_of_birth,age,civil_status,position_cd,monthly_salary,
           salary_grade,no_of_persons,destination,height,weight,sex,ac_class_cd,
           group_print_sw, level_cd, parent_level_cd -- mod1 start/end           
    FROM gipi_waccident_item
   WHERE par_id  = p_in_par_id
     AND item_no = p_item_no;

  v_item_no             gipi_waccident_item.item_no%TYPE;
  v_date_of_birth       gipi_waccident_item.date_of_birth%TYPE;
  v_age                 gipi_waccident_item.age%TYPE;
  v_civil_status        gipi_waccident_item.civil_status%TYPE;
  v_position_cd         gipi_waccident_item.position_cd%TYPE;
  v_monthly_salary      gipi_waccident_item.monthly_salary%TYPE;
  v_salary_grade        gipi_waccident_item.salary_grade%TYPE;
  v_no_of_persons       gipi_waccident_item.no_of_persons%TYPE;
  v_destination         gipi_waccident_item.destination%TYPE;
  v_height              gipi_waccident_item.height%TYPE;
  v_weight              gipi_waccident_item.weight%TYPE;
  v_sex                 gipi_waccident_item.sex%TYPE;
  v_ac_class_cd         gipi_waccident_item.ac_class_cd%TYPE;
  v_group_print_sw      gipi_waccident_item.group_print_sw%TYPE;
  v_level_cd            gipi_waccident_item.level_cd%TYPE; -- mod1 start
  v_parent_level_cd     gipi_waccident_item.parent_level_cd%TYPE; -- mod1 end

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying accident item info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
 DBMS_OUTPUT.PUT_LINE('====== copy_waccident_item start ======='); 
  OPEN accident_item_cur;
  LOOP
    FETCH accident_item_cur
     INTO v_item_no,v_date_of_birth,v_age,v_civil_status,v_position_cd,
          v_monthly_salary,v_salary_grade,v_no_of_persons,v_destination,
          v_height,v_weight,v_sex,v_ac_class_cd,v_group_print_sw, v_level_cd, --mod1 start
          v_parent_level_cd; -- mod1 end
  EXIT WHEN accident_item_cur%NOTFOUND;
  INSERT INTO gipi_waccident_item
          (par_id,item_no,date_of_birth,age,civil_status,position_cd,
          monthly_salary,salary_grade,no_of_persons,destination,height,
          weight,sex,ac_class_cd,group_print_sw, level_cd, parent_level_cd) -- mod1 start/end
   VALUES (p_in_copy_par_id,v_item_no,v_date_of_birth,v_age,v_civil_status,
          v_position_cd,v_monthly_salary,v_salary_grade,v_no_of_persons,
          v_destination,v_height,v_weight,v_sex,v_ac_class_cd,v_group_print_sw,
          v_level_cd, v_parent_level_cd); -- mod1 start/end
  END LOOP;
  CLOSE accident_item_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;



PROCEDURE copy_waviation_item (
      p_item_no IN       gipi_item.item_no%TYPE,
      p_in_par_id        gipi_parlist.par_id%TYPE,
      p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR aviation_item_cur IS 
  SELECT item_no,vessel_cd,total_fly_time,qualification,purpose,geog_limit,
         deduct_text,rec_flag,fixed_wing,rotor,prev_util_hrs,est_util_hrs
    FROM gipi_waviation_item
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no         gipi_waviation_item.item_no%TYPE;
  v_vessel_cd       gipi_waviation_item.vessel_cd%TYPE;
  v_tot_fly_time    gipi_waviation_item.total_fly_time%TYPE;
  v_qualification   gipi_waviation_item.qualification%TYPE;
  v_purpose         gipi_waviation_item.purpose%TYPE;
  v_geog_limit      gipi_waviation_item.geog_limit%TYPE;
  v_deduct_text     gipi_waviation_item.deduct_text%TYPE;
  v_rec_flag        gipi_waviation_item.rec_flag%TYPE;
  v_fixed_wing      gipi_waviation_item.fixed_wing%TYPE;
  v_rotor           gipi_waviation_item.rotor%TYPE;
  v_prev_util_hrs   gipi_waviation_item.prev_util_hrs%TYPE;
  v_est_util_hrs    gipi_waviation_item.est_util_hrs%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying aviation item info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_waviation_item start ======='); 
  OPEN aviation_item_cur;
  LOOP
    FETCH aviation_item_cur
     INTO v_item_no,        v_vessel_cd,    v_tot_fly_time,   v_qualification,
          v_purpose,        v_geog_limit,   v_deduct_text,    v_rec_flag,
          v_fixed_wing,     v_rotor,        v_prev_util_hrs,  v_est_util_hrs;
     EXIT WHEN aviation_item_cur%NOTFOUND;
   INSERT INTO gipi_waviation_item
         (par_id,           item_no,        vessel_cd,        total_fly_time,
          qualification,    purpose,        geog_limit,       deduct_text,
          rec_flag,         fixed_wing,     rotor,            prev_util_hrs,
          est_util_hrs)
   VALUES (p_in_copy_par_id,v_item_no,      v_vessel_cd,      v_tot_fly_time,
          v_qualification,  v_purpose,      v_geog_limit,     v_deduct_text,
          v_rec_flag,       v_fixed_wing,   v_rotor,          v_prev_util_hrs,
          v_est_util_hrs);
  END LOOP;
  CLOSE aviation_item_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wbeneficiary(
      p_item_no IN       gipi_item.item_no%TYPE,
      p_in_par_id        gipi_parlist.par_id%TYPE,
      p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR beneficiary_cur IS
  SELECT item_no,beneficiary_no,beneficiary_name,relation,beneficiary_addr,delete_sw,remarks, 
             adult_sw, age, civil_status, date_of_birth, position_cd, sex -- mod1 start/end
    FROM gipi_wbeneficiary
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no            gipi_wbeneficiary.item_no%TYPE;
  v_benef_name         gipi_wbeneficiary.beneficiary_name%TYPE;
  v_relation           gipi_wbeneficiary.relation%TYPE;
  v_benef_addr         gipi_wbeneficiary.beneficiary_addr%TYPE;
  v_beneficiary_no     gipi_wbeneficiary.beneficiary_no%TYPE;
  v_delete_sw          gipi_wbeneficiary.delete_sw%TYPE;
  v_remarks            gipi_wbeneficiary.remarks%TYPE;
  v_adult_sw           gipi_wbeneficiary.adult_sw%TYPE;        -- mod1 start
  v_age                gipi_wbeneficiary.age%TYPE;
  v_civil_status       gipi_wbeneficiary.civil_status%TYPE;
  v_date_of_birth      gipi_wbeneficiary.date_of_birth%TYPE;
  v_position_cd        gipi_wbeneficiary.position_cd%TYPE;
  v_sex                gipi_wbeneficiary.sex%TYPE;                  -- mod1 end
 
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying beneficiary info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wbeneficiary start ======='); 
  OPEN beneficiary_cur;
  LOOP
    FETCH beneficiary_cur
     INTO v_item_no,v_beneficiary_no,v_benef_name,v_relation,v_benef_addr,
          v_delete_sw, v_remarks, v_adult_sw, v_age, v_civil_status, v_date_of_birth, -- mod1 start
          v_position_cd, v_sex; -- mod1 end
     EXIT WHEN beneficiary_cur%NOTFOUND;
     
   INSERT INTO gipi_wbeneficiary
          (par_id,item_no,beneficiary_name,relation,beneficiary_addr,
           beneficiary_no,delete_sw, remarks, adult_sw, age, civil_status, -- mod1 start
           date_of_birth, position_cd, sex) -- mod1 end
               
   VALUES (p_in_copy_par_id,v_item_no,v_benef_name,v_relation,v_benef_addr,
           v_beneficiary_no,v_delete_sw, v_remarks, v_adult_sw, v_age, v_civil_status, -- mod1 start
           v_date_of_birth, v_position_cd, v_sex); -- mod1 end
  END LOOP;
  CLOSE beneficiary_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wbond_basic(
      p_in_par_id        gipi_parlist.par_id%TYPE,
      p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  
  v_obligee_no          gipi_wbond_basic.obligee_no%TYPE;
  v_prin_id             gipi_wbond_basic.prin_id%TYPE;
  v_coll_flag           gipi_wbond_basic.coll_flag%TYPE;
  v_clause_type         gipi_wbond_basic.clause_type%TYPE;
  v_val_period_unit     gipi_wbond_basic.val_period_unit%TYPE;
  v_val_period          gipi_wbond_basic.val_period%TYPE;
  v_np_no               gipi_wbond_basic.np_no%TYPE;
  v_contract_dtl        gipi_wbond_basic.contract_dtl%TYPE;
  v_contract_date       gipi_wbond_basic.contract_date%TYPE;
  v_co_prin_sw          gipi_wbond_basic.co_prin_sw%TYPE;
  v_waiver_limit        gipi_wbond_basic.waiver_limit%TYPE;
  v_indemnity_text      gipi_wbond_basic.indemnity_text%TYPE;
  v_bond_dtl            gipi_wbond_basic.bond_dtl%TYPE;
  v_endt_eff_date       gipi_wbond_basic.endt_eff_date%TYPE;
  v_remarks             gipi_wbond_basic.remarks%TYPE;
  v_copy_long           gipi_wbond_basic.bond_dtl%TYPE; --rmanalad 6/25/2012
  v_civil_case_no       GIPI_WBOND_BASIC.CIVIL_CASE_NO%TYPE;
  v_plaintiff_dtl       GIPI_WBOND_BASIC.PLAINTIFF_DTL%TYPE;
  v_defendant_dtl       GIPI_WBOND_BASIC.DEFENDANT_DTL%TYPE;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying bond basic info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wbond_basic start ======='); 
  
  SELECT obligee_no,            prin_id,                coll_flag,
         clause_type,           val_period_unit,        val_period,
         np_no,                 contract_dtl,           contract_date,
         co_prin_sw,            waiver_limit,           indemnity_text,
         bond_dtl,              endt_eff_date,          remarks,
         civil_case_no,         plaintiff_dtl,          defendant_dtl
    INTO v_obligee_no,          v_prin_id,              v_coll_flag,
         v_clause_type,         v_val_period_unit,      v_val_period,
         v_np_no,               v_contract_dtl,         v_contract_date,
         v_co_prin_sw,          v_waiver_limit,         v_indemnity_text,
         v_copy_long,           v_endt_eff_date,        v_remarks,
         v_civil_case_no,       v_plaintiff_dtl,        v_defendant_dtl
    FROM gipi_wbond_basic
   WHERE par_id = p_in_par_id; /* input*/
   
  INSERT INTO gipi_wbond_basic
         (par_id,               obligee_no,             prin_id,
          coll_flag,            clause_type,            val_period_unit,      
          val_period,           np_no,                  contract_dtl,     
          contract_date,        co_prin_sw,             waiver_limit,           
          indemnity_text,       bond_dtl,               endt_eff_date,          
          remarks,              civil_case_no,          plaintiff_dtl,
          defendant_dtl)
  VALUES (p_in_copy_par_id,     v_obligee_no,           v_prin_id,
          v_coll_flag,          v_clause_type,          v_val_period_unit,
          v_val_period,         v_np_no,                v_contract_dtl,
          v_contract_date,      v_co_prin_sw,           v_waiver_limit,
          v_indemnity_text,     v_copy_long,            v_endt_eff_date,
          v_remarks,            v_civil_case_no,        v_plaintiff_dtl,
          v_defendant_dtl);
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wcargo (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  ) IS
  CURSOR cargo_cur IS
  SELECT item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,rec_flag,origin,destn,
         etd,eta,cargo_type,deduct_text,pack_method,tranship_origin,
         tranship_destination,print_tag,voyage_no,lc_no, cpi_rec_no, cpi_branch_cd, -- mod1 start/end
         invoice_value, markup_rate, inv_curr_cd, inv_curr_rt
    FROM gipi_wcargo
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no              gipi_wcargo.item_no%TYPE;
  v_vessel_cd            gipi_wcargo.vessel_cd%TYPE;
  v_geog_cd              gipi_wcargo.geog_cd%TYPE;
  v_cargo_class_cd       gipi_wcargo.cargo_class_cd%TYPE;
  v_bl_awb               gipi_wcargo.bl_awb%TYPE;
  v_rec_flag             gipi_wcargo.rec_flag%TYPE;
  v_origin               gipi_wcargo.origin%TYPE;
  v_destn                gipi_wcargo.destn%TYPE;
  v_etd                  gipi_wcargo.etd%TYPE;
  v_eta                  gipi_wcargo.eta%TYPE;
  v_cargo_type           gipi_wcargo.cargo_type%TYPE;
  v_deduct_text          gipi_wcargo.deduct_text%TYPE;
  v_pack_method          gipi_wcargo.pack_method%TYPE;
  v_tranship_origin      gipi_wcargo.tranship_origin%TYPE;
  v_tranship_dest        gipi_wcargo.tranship_destination%TYPE;
  v_print_tag            gipi_wcargo.print_tag%TYPE;
  v_voyage_no            gipi_wcargo.voyage_no%TYPE; 
  v_lc_no                gipi_wcargo.lc_no%TYPE; 
  v_cpi_rec_no           gipi_wcargo.cpi_rec_no%TYPE;
  v_cpi_branch_cd        gipi_wcargo.cpi_branch_cd%TYPE;
  v_invoice_value        GIPI_WCARGO.INVOICE_VALUE%TYPE;
  v_markup_rate          GIPI_WCARGO.MARKUP_RATE%TYPE;
  v_inv_curr_cd          GIPI_WCARGO.INV_CURR_CD%TYPE;
  v_inv_curr_rt          GIPI_WCARGO.INV_CURR_RT%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying cargo info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wcargo start ======='); 
  
  OPEN cargo_cur;
  LOOP
    FETCH cargo_cur
     INTO v_item_no,            v_vessel_cd,            v_geog_cd,
          v_cargo_class_cd,     v_bl_awb,               v_rec_flag,
          v_origin,             v_destn,                v_etd,
          v_eta,                v_cargo_type,           v_deduct_text,
          v_pack_method,        v_tranship_origin,      v_tranship_dest,
          v_print_tag,          v_voyage_no,            v_lc_no,
          v_cpi_rec_no,         v_cpi_branch_cd,        v_invoice_value,
          v_markup_rate,        v_inv_curr_cd,          v_inv_curr_rt;
     EXIT WHEN cargo_cur%NOTFOUND;
    INSERT INTO gipi_wcargo
         (par_id,               item_no,                vessel_cd,
          geog_cd,              cargo_class_cd,         bl_awb,
          rec_flag,             origin,                 destn,
          etd,                  eta,                    cargo_type,
          deduct_text,          pack_method,            tranship_origin,
          tranship_destination, print_tag,              voyage_no,
          lc_no,                cpi_rec_no,             cpi_branch_cd,
          invoice_value,        markup_rate,            inv_curr_cd,
          inv_curr_rt)
    VALUES 
         (p_in_copy_par_id,     v_item_no,              v_vessel_cd,
         v_geog_cd,             v_cargo_class_cd,       v_bl_awb,
         v_rec_flag,            v_origin,               v_destn,
         SYSDATE,               (SYSDATE + 365),        v_cargo_type,
         v_deduct_text,         v_pack_method,          v_tranship_origin,
         v_tranship_dest,       v_print_tag,            v_voyage_no,
         v_lc_no,               v_cpi_rec_no,           v_cpi_branch_cd,
         v_invoice_value,       v_markup_rate,          v_inv_curr_cd,
         v_inv_curr_rt);
  END LOOP;
  CLOSE cargo_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

  
PROCEDURE COPY_WCARGO_CARRIER(
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  
  )IS
  CURSOR cargo_carrier IS
  SELECT item_no,   vessel_cd,      voy_limit,      vessel_limit_of_liab, 
         eta,       etd,            origin,         destn, 
         delete_sw 
    FROM gipi_wcargo_carrier
   WHERE par_id  = p_in_par_id;

  v_item_no             gipi_wcargo_carrier.item_no%TYPE;
  v_vessel_cd           gipi_wcargo_carrier.vessel_cd%TYPE;
  v_voy_limit           gipi_wcargo_carrier.voy_limit%TYPE;
  v_vessel_loliab       gipi_wcargo_carrier.vessel_limit_of_liab%TYPE;
  v_eta                 gipi_wcargo_carrier.eta%TYPE;
  v_etd                 gipi_wcargo_carrier.etd%TYPE;
  v_origin              gipi_wcargo_carrier.origin%TYPE;
  v_destn               gipi_wcargo_carrier.destn%TYPE;
  v_delete_sw           gipi_wcargo_carrier.delete_sw%TYPE;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying cargo carrier information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== COPY_WCARGO_CARRIER start ======='); 
  OPEN cargo_carrier;
  LOOP
    FETCH cargo_carrier
     INTO v_item_no,        v_vessel_cd,        v_voy_limit,        
          v_vessel_loliab,  v_eta,              v_etd, 
          v_origin,         v_destn,            v_delete_sw;
     EXIT WHEN cargo_carrier%NOTFOUND;
    INSERT INTO gipi_wcargo_carrier
         (par_id,           item_no,            vessel_cd,
         voy_limit,         vessel_limit_of_liab,eta, 
         etd,               origin,             destn, 
         delete_sw,         last_update,        user_id) 
    VALUES 
         (p_in_copy_par_id, v_item_no,          v_vessel_cd,
         v_voy_limit,       v_vessel_loliab,    v_eta,v_etd, 
         v_origin,          v_destn,            v_delete_sw, 
         sysdate,           p_in_user_id); 
  END LOOP;
  CLOSE cargo_carrier;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL; 
END;    
    

PROCEDURE copy_wcasualty_item (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  ) IS
  CURSOR casualty_item_cur IS
  SELECT item_no,               section_line_cd,        
         section_subline_cd,    section_or_hazard_cd,
         property_no_type,      capacity_cd,property_no,
         location,              conveyance_info,
         limit_of_liability,    interest_on_premises,
         section_or_hazard_info, location_cd
    FROM gipi_wcasualty_item
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no                 gipi_wcasualty_item.item_no%TYPE;
  v_section_line_cd         gipi_wcasualty_item.section_line_cd%TYPE;
  v_section_subline_cd      gipi_wcasualty_item.section_subline_cd%TYPE;
  v_section_or_hazard_cd    gipi_wcasualty_item.section_or_hazard_cd%TYPE;
  v_property_no_type        gipi_wcasualty_item.property_no_type%TYPE;
  v_capacity_cd             gipi_wcasualty_item.capacity_cd%TYPE;
  v_property_no             gipi_wcasualty_item.property_no%TYPE;
  v_location                gipi_wcasualty_item.location%TYPE;
  v_conveyance_info         gipi_wcasualty_item.conveyance_info%TYPE;
  v_limit_of_liability      gipi_wcasualty_item.limit_of_liability%TYPE;
  v_interest_on_premises    gipi_wcasualty_item.interest_on_premises%TYPE;
  v_section_or_hazard_info  gipi_wcasualty_item.section_or_hazard_info%TYPE;
  v_location_cd             gipi_wcasualty_item.location_cd%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying casualty item info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wcasualty_item start ======='); 
  
  OPEN casualty_item_cur;
  LOOP
    FETCH casualty_item_cur
     INTO v_item_no,              v_section_line_cd,        v_section_subline_cd,
          v_section_or_hazard_cd, v_property_no_type,       v_capacity_cd,
          v_property_no,          v_location,               v_conveyance_info,
          v_limit_of_liability,   v_interest_on_premises,   v_section_or_hazard_info, v_location_cd;
     EXIT WHEN casualty_item_cur%NOTFOUND;
   INSERT INTO gipi_wcasualty_item
         (par_id,                 item_no,                  section_line_cd,
          section_subline_cd,     section_or_hazard_cd,     property_no_type,
          capacity_cd,            property_no,              location,
          conveyance_info,        limit_of_liability,       interest_on_premises,
          section_or_hazard_info,   location_cd)
   VALUES(p_in_copy_par_id,       v_item_no,                v_section_line_cd,
          v_section_subline_cd,   v_section_or_hazard_cd,   v_property_no_type,       
          v_capacity_cd,          v_property_no,            v_location,
          v_conveyance_info,      v_limit_of_liability,     v_interest_on_premises,   
          v_section_or_hazard_info, v_location_cd);
  END LOOP;
  CLOSE casualty_item_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

   
PROCEDURE COPY_WCASUALTY_PERSONNEL (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR cas_per_cur IS
  SELECT item_no ,personnel_no, name,
         include_tag, capacity_cd, amount_covered,
         remarks, delete_sw
    FROM gipi_wcasualty_personnel
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;
  
  v_item_no            gipi_wcasualty_personnel.item_no%TYPE;
  v_personnel_no       gipi_wcasualty_personnel.personnel_no%TYPE;
  v_name               gipi_wcasualty_personnel.name%TYPE;
  v_include_tag        gipi_wcasualty_personnel.include_tag%TYPE;
  v_capacity_cd        gipi_wcasualty_personnel.capacity_cd%TYPE;
  v_amount_covered     gipi_wcasualty_personnel.amount_covered%TYPE;
  v_remarks            gipi_wcasualty_personnel.remarks%TYPE;
  v_delete_sw          gipi_wcasualty_personnel.delete_sw%TYPE; -- mod1 start/end

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying casualty personnel information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== COPY_WCASUALTY_PERSONNEL start ======='); 
  
  OPEN cas_per_cur;
  LOOP
    FETCH cas_per_cur
     INTO v_item_no ,    v_personnel_no,    v_name,
          v_include_tag, v_capacity_cd,     v_amount_covered,
          v_remarks,     v_delete_sw;
     EXIT WHEN cas_per_cur%NOTFOUND;
    INSERT INTO gipi_wcasualty_personnel
         (par_id,           item_no,        personnel_no, 
          name,             include_tag,    capacity_cd,    
          amount_covered,   remarks,        delete_sw)
    VALUES(p_in_copy_par_id,v_item_no,      v_personnel_no, 
          v_name,           v_include_tag,  v_capacity_cd, 
          v_amount_covered, v_remarks,      v_delete_sw);
  END LOOP;
  CLOSE cas_per_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
END;


PROCEDURE copy_wcomm_invoices (
        p_item_grp         gipi_item.item_grp%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR comm_invoices_cur IS
  SELECT item_grp,
         intrmdry_intm_no,
         share_percentage,
         premium_amt,
         commission_amt,
         wholding_tax,
         bond_rate,
         parent_intm_no,
         default_intm
    FROM gipi_wcomm_invoices
   WHERE par_id = p_in_par_id;

  v_item_grp               gipi_wcomm_invoices.item_grp%TYPE;
  v_intrmdry_intm_no       gipi_wcomm_invoices.intrmdry_intm_no%TYPE;
  v_share_percentage       gipi_wcomm_invoices.share_percentage%TYPE;
  v_premium_amt            gipi_wcomm_invoices.premium_amt%TYPE;
  v_commission_amt         gipi_wcomm_invoices.commission_amt%TYPE;
  v_wholding_tax           gipi_wcomm_invoices.wholding_tax%TYPE;
  v_bond_rate              gipi_wcomm_invoices.bond_rate%TYPE;
  v_parent_intm_no         gipi_wcomm_invoices.parent_intm_no%TYPE;
  v_default_intm           gipi_wcomm_invoices.default_intm%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying comm invoices info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wcomm_invoices start ======='); 
  
  OPEN comm_invoices_cur;
  LOOP
    FETCH comm_invoices_cur
     INTO v_item_grp,           v_intrmdry_intm_no,     v_share_percentage,
          v_premium_amt,        v_commission_amt,       v_wholding_tax,
          v_bond_rate,          v_parent_intm_no,       v_default_intm;
     EXIT WHEN comm_invoices_cur%NOTFOUND;
    INSERT INTO gipi_wcomm_invoices
         (par_id,               item_grp,               intrmdry_intm_no,
          share_percentage,     premium_amt,            commission_amt,
          wholding_tax,         bond_rate,              parent_intm_no,
          default_intm)
        VALUES 
         (p_in_copy_par_id,     v_item_grp,             v_intrmdry_intm_no,
          v_share_percentage,   v_premium_amt,          v_commission_amt,
          v_wholding_tax,       v_bond_rate,            v_parent_intm_no,
          v_default_intm);
  END LOOP;
  CLOSE comm_invoices_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wcomm_inv_perils (
        p_item_grp         gipi_item.item_grp%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR comm_invperl_cur IS
  SELECT item_grp,      intrmdry_intm_no,       peril_cd,
         premium_amt,   commission_amt,         wholding_tax,
         commission_rt
    FROM gipi_wcomm_inv_perils
   WHERE par_id = p_in_par_id;

  v_item_grp            gipi_wcomm_inv_perils.item_grp%TYPE;
  v_intrmdry_intm_no    gipi_wcomm_inv_perils.intrmdry_intm_no%TYPE;
  v_peril_cd            gipi_wcomm_inv_perils.peril_cd%TYPE;
  v_premium_amt         gipi_wcomm_inv_perils.premium_amt%TYPE;
  v_commission_amt      gipi_wcomm_inv_perils.commission_amt%TYPE;
  v_wholding_tax        gipi_wcomm_inv_perils.wholding_tax%TYPE;
  v_commission_rt       gipi_wcomm_inv_perils.commission_rt%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying comm invoice peril info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wcomm_inv_perils start ======='); 
  
  OPEN comm_invperl_cur;
  LOOP
    FETCH comm_invperl_cur
     INTO v_item_grp,           v_intrmdry_intm_no,     v_peril_cd,
          v_premium_amt,        v_commission_amt,       v_wholding_tax,
          v_commission_rt;
     EXIT WHEN comm_invperl_cur%NOTFOUND;
    INSERT INTO gipi_wcomm_inv_perils
         (par_id,               item_grp,               intrmdry_intm_no,
          peril_cd,             premium_amt,            commission_amt,
          wholding_tax,         commission_rt)
    VALUES 
         (p_in_copy_par_id,     v_item_grp,             v_intrmdry_intm_no,
          v_peril_cd,           NVL(v_premium_amt,0),   NVL(v_commission_amt,0),
          NVL(v_wholding_tax,0),NVL(v_commission_rt,0));
  END LOOP;
  CLOSE comm_invperl_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wcosigntry(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR cosigntry_cur IS
  SELECT cosign_id,assd_no,indem_flag,bonds_ri_flag,bonds_flag
    FROM gipi_wcosigntry
   WHERE par_id = p_in_par_id;

  v_prin_id         gipi_wcosigntry.cosign_id%TYPE;
  v_assd_no         gipi_wcosigntry.assd_no%TYPE;
  v_indem_flag      gipi_wcosigntry.indem_flag%TYPE;
  v_bonds_ri_flag   gipi_wcosigntry.bonds_ri_flag%TYPE;
  v_bonds_flag      gipi_wcosigntry.bonds_flag%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying cosignatory info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wcosigntry start ======='); 
  OPEN cosigntry_cur;
  LOOP
    FETCH cosigntry_cur
     INTO v_prin_id,        v_assd_no,      v_indem_flag,
          v_bonds_ri_flag,  v_bonds_flag;
     EXIT WHEN cosigntry_cur%NOTFOUND;
   INSERT INTO gipi_wcosigntry
         (par_id,           cosign_id,          assd_no,
          indem_flag,       bonds_ri_flag,      bonds_flag)
   VALUES 
         (p_in_copy_par_id, v_prin_id,          v_assd_no,
         v_indem_flag,      v_bonds_ri_flag,    v_bonds_flag);
  END LOOP;
  CLOSE cosigntry_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wdeductibles (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
  CURSOR deductibles_cur IS
  SELECT ded_line_cd,               ded_subline_cd,
         item_no,                   ded_deductible_cd,
         deductible_text,           deductible_amt,
         deductible_rt,             peril_cd
    FROM gipi_wdeductibles
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;
   
  v_ded_line_cd             gipi_wdeductibles.ded_line_cd%TYPE;
  v_ded_subline_cd          gipi_wdeductibles.ded_subline_cd%TYPE;
  v_item_no                 gipi_wdeductibles.item_no%TYPE;
  v_ded_deduct_cd           gipi_wdeductibles.ded_deductible_cd%TYPE;
  v_deduct_amt              gipi_wdeductibles.deductible_amt%TYPE;    
  v_deductible_rt           gipi_wdeductibles.deductible_rt%TYPE;
  v_peril_cd                gipi_wdeductibles.peril_cd%TYPE;
  v_copy_long               gipi_wbond_basic.bond_dtl%TYPE; --rmanalad 6/25/2012

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying deductibles info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wdeductibles start ======='); 
  OPEN deductibles_cur;
  LOOP
    FETCH deductibles_cur
     INTO v_ded_line_cd,        v_ded_subline_cd,       v_item_no,
          v_ded_deduct_cd,      v_copy_long,            v_deduct_amt,
          v_deductible_rt,      v_peril_cd;
     EXIT WHEN deductibles_cur%NOTFOUND; 
   INSERT INTO gipi_wdeductibles
         (par_id,               ded_line_cd,            ded_subline_cd,
          item_no,              ded_deductible_cd,      deductible_text,
          deductible_amt,       deductible_rt,          peril_cd)
   VALUES(p_in_copy_par_id,     v_ded_line_cd,          v_ded_subline_cd,
          v_item_no,            v_ded_deduct_cd,        v_copy_long,
          v_deduct_amt,         v_deductible_rt,        v_peril_cd);
  END LOOP;
--  CLEAR_MESSAGE;
  CLOSE deductibles_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;   
END;      

 PROCEDURE copy_wpolicy_deductibles(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )
  AS
    CURSOR deductibles_cur IS
        SELECT     a.item_no,           a.peril_cd,         a.ded_line_cd,
                   a.ded_subline_cd,    a.aggregate_sw,      a.ceiling_sw,       a.deductible_rt,     
                   a.ded_deductible_cd, a.deductible_amt,    a.deductible_text,  a.min_amt,          
                   a.max_amt,           a.range_sw
              FROM GIPI_WDEDUCTIBLES    a
                  ,GIIS_DEDUCTIBLE_DESC b
                  ,GIPI_WPOLBAS         c
             WHERE a.par_id             = p_in_par_id
               AND a.ded_line_cd        = b.line_cd
               AND a.ded_subline_cd     = b.subline_cd
               AND a.ded_deductible_cd  = b.deductible_cd
               AND a.par_id             = c.par_id
               AND a.item_no            = 0
               AND a.peril_cd           = 0
             ORDER BY a.item_no, a.peril_cd, b.deductible_title;
             
      v_ded_line_cd             gipi_wdeductibles.ded_line_cd%TYPE;
      v_ded_subline_cd          gipi_wdeductibles.ded_subline_cd%TYPE;
      v_item_no                 gipi_wdeductibles.item_no%TYPE;
      v_ded_deduct_cd           gipi_wdeductibles.ded_deductible_cd%TYPE;
      v_deduct_amt              gipi_wdeductibles.deductible_amt%TYPE;    
      v_deductible_rt           gipi_wdeductibles.deductible_rt%TYPE;
      v_peril_cd                gipi_wdeductibles.peril_cd%TYPE;
      v_deductible_text         GIPI_WDEDUCTIBLES.DEDUCTIBLE_TEXT%TYPE;
      v_aggregate_sw            GIPI_WDEDUCTIBLES.AGGREGATE_SW%TYPE;
      v_ceiling_sw              GIPI_WDEDUCTIBLES.CEILING_SW%TYPE;
      v_range_sw                GIPI_WDEDUCTIBLES.RANGE_SW%TYPE;
      v_min_amt                 GIPI_WDEDUCTIBLES.MIN_AMT%TYPE;
      v_max_amt                 GIPI_WDEDUCTIBLES.MAX_AMT%TYPE;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('====== copy_wpolicy_deductibles start ======='); 
      OPEN deductibles_cur;
      LOOP
        FETCH deductibles_cur
         INTO v_item_no,        v_peril_cd,         v_ded_line_cd,      v_ded_subline_cd,
              v_aggregate_sw,   v_ceiling_sw,       v_deductible_rt,    v_ded_deduct_cd,  
              v_deduct_amt,     v_deductible_text,  v_min_amt,          v_max_amt,
              v_range_sw;
         EXIT WHEN deductibles_cur%NOTFOUND; 
         
       INSERT INTO gipi_wdeductibles
             (par_id,               ded_line_cd,            ded_subline_cd,
              item_no,              ded_deductible_cd,      deductible_text,
              deductible_amt,       deductible_rt,          peril_cd,
              aggregate_sw,         ceiling_sw,             range_sw,
              min_amt,              max_amt)
       VALUES(p_in_copy_par_id,     v_ded_line_cd,          v_ded_subline_cd,
              v_item_no,            v_ded_deduct_cd,        v_deductible_text,
              v_deduct_amt,         v_deductible_rt,        v_peril_cd,
              v_aggregate_sw,       v_ceiling_sw,           v_range_sw,
              v_min_amt,            v_max_amt);
      END LOOP;
    --  CLEAR_MESSAGE;
      CLOSE deductibles_cur;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;  
  END copy_wpolicy_deductibles;


PROCEDURE copy_wendttext(
        p_copy_long         IN OUT  gipi_wendttext.endt_tax%TYPE,
        p_in_par_id         IN      gipi_parlist.par_id%TYPE,
        p_in_copy_par_id    IN      gipi_parlist.par_id%TYPE 
  ) IS
  v_endt_tax                   gipi_wendttext.endt_tax%TYPE;
  v_endt_text01                gipi_wendttext.endt_text01%TYPE;                
  v_endt_text02                gipi_wendttext.endt_text02%TYPE;
  v_endt_text03                gipi_wendttext.endt_text03%TYPE;
  v_endt_text04                gipi_wendttext.endt_text04%TYPE;
  v_endt_text05                gipi_wendttext.endt_text05%TYPE;
  v_endt_text06                gipi_wendttext.endt_text06%TYPE;
  v_endt_text07                gipi_wendttext.endt_text07%TYPE;
  v_endt_text08                gipi_wendttext.endt_text08%TYPE;
  v_endt_text09                gipi_wendttext.endt_text09%TYPE;
  v_endt_text10                gipi_wendttext.endt_text10%TYPE;
  v_endt_text11                gipi_wendttext.endt_text11%TYPE;
  v_endt_text12                gipi_wendttext.endt_text12%TYPE;
  v_endt_text13                gipi_wendttext.endt_text13%TYPE;
  v_endt_text14                gipi_wendttext.endt_text14%TYPE;
  v_endt_text15                gipi_wendttext.endt_text15%TYPE;
  v_endt_text16                gipi_wendttext.endt_text16%TYPE;
  v_endt_text17                gipi_wendttext.endt_text17%TYPE;
  v_endt_cd                    gipi_wendttext.endt_cd%TYPE;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying endorsement text info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wendttext start ======='); 
  SELECT endt_text, endt_tax, endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,endt_text06,
         endt_text07,endt_text08,endt_text09,endt_text10,endt_text11,endt_text12,endt_text13,endt_text14,endt_text15,
         endt_text16, endt_text17, endt_cd
    INTO p_copy_long, v_endt_tax, v_endt_text01,v_endt_text02,v_endt_text03,v_endt_text04,v_endt_text05,v_endt_text06,
         v_endt_text07,v_endt_text08,v_endt_text09,v_endt_text10,v_endt_text11,v_endt_text12,v_endt_text13,v_endt_text14,
         v_endt_text15,v_endt_text16,v_endt_text17,v_endt_cd
    FROM gipi_wendttext
   WHERE par_id = p_in_par_id;
   
  INSERT INTO gipi_wendttext
        (par_id,endt_text, endt_tax,endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,
         endt_text06,endt_text07,endt_text08,endt_text09,endt_text10,endt_text11,endt_text12,
         endt_text13,endt_text14,endt_text15,endt_text16, endt_text17, endt_cd, user_id,
         last_update)
  VALUES(p_in_copy_par_id, SUBSTR(p_copy_long,1,250), v_endt_tax, v_endt_text01, v_endt_text02, 
         v_endt_text03, v_endt_text04, v_endt_text05, v_endt_text06, v_endt_text07, 
         v_endt_text08, v_endt_text09, v_endt_text10, v_endt_text11, v_endt_text12, v_endt_text13, 
         v_endt_text14, v_endt_text15, v_endt_text16, v_endt_text17, v_endt_cd, user, sysdate);
--  CLEAR_MESSAGE;
  EXCEPTION 
    WHEN  NO_DATA_FOUND THEN
      NULL; 
END;


PROCEDURE copy_wengg_basic ( 
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE     
  )IS
  v_con_title           gipi_wengg_basic.contract_proj_buss_title%TYPE;
  v_site_loc            gipi_wengg_basic.site_location%TYPE;
  v_c_start_date        gipi_wengg_basic.construct_start_date%TYPE;
  v_c_end_date          gipi_wengg_basic.construct_end_date%TYPE;
  v_m_start_date        gipi_wengg_basic.maintain_start_date%TYPE;
  v_m_end_date          gipi_wengg_basic.maintain_end_date%TYPE;
  v_weeks_test          gipi_wengg_basic.weeks_test%TYPE;
  v_time_excess         gipi_wengg_basic.time_excess%TYPE;
  v_mbi_policy_no       gipi_wengg_basic.mbi_policy_no%TYPE;
  v_infonum             gipi_wengg_basic.engg_basic_infonum%TYPE;
  v_testing_start_date  gipi_wengg_basic.testing_start_date%TYPE;
  v_testing_end_date    gipi_wengg_basic.testing_end_date%TYPE;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying engineering basic info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wengg_basic start ======='); 
  SELECT contract_proj_buss_title,  engg_basic_infonum,         site_location,
         construct_start_date,      construct_end_date,         maintain_start_date,
         maintain_end_date,         weeks_test,                 time_excess,
         mbi_policy_no,             testing_start_date,         testing_end_date
         
    INTO v_con_title,               v_infonum,                  v_site_loc,
         v_c_start_date,            v_c_end_date,               v_m_start_date,
         v_m_end_date,              v_weeks_test,               v_time_excess,
         v_mbi_policy_no,           v_testing_start_date,       v_testing_end_date
    FROM gipi_wengg_basic
   WHERE par_id = p_in_par_id;
  INSERT INTO gipi_wengg_basic
        (par_id,                    contract_proj_buss_title,   engg_basic_infonum,
         site_location,             construct_start_date,       construct_end_date,
         maintain_start_date,       maintain_end_date,          weeks_test,
         time_excess,               mbi_policy_no,              testing_start_date,
         testing_end_date)
  VALUES
        (p_in_copy_par_id,          v_con_title,                v_infonum,
         v_site_loc,                v_c_start_date,             v_c_end_date,
         v_m_start_date,            v_m_end_date,               v_weeks_test,
         v_time_excess,             v_mbi_policy_no,            v_testing_start_date,
         v_testing_end_date);
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wfireitm (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR fireitm_cur IS
  SELECT item_no, district_no, eq_zone, tarf_cd, block_no, fr_item_type, loc_risk1,
         loc_risk2, loc_risk3, tariff_zone, typhoon_zone, construction_cd, 
         construction_remarks, front, right, left, rear, occupancy_cd, 
         occupancy_remarks, flood_zone,
         assignee, block_id, risk_cd, latitude, longitude   
    FROM gipi_wfireitm 
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no                  gipi_wfireitm.item_no%TYPE;
  v_dist_no                  gipi_wfireitm.district_no%TYPE;
  v_eq_zone                  gipi_wfireitm.eq_zone%TYPE;
  v_tarf_cd                  gipi_wfireitm.tarf_cd%TYPE;
  v_block_no                 gipi_wfireitm.block_no%TYPE;
  v_fr_item_type             gipi_wfireitm.fr_item_type%TYPE;
  v_loc_risk1                gipi_wfireitm.loc_risk1%TYPE;
  v_loc_risk2                gipi_wfireitm.loc_risk2%TYPE;
  v_loc_risk3                gipi_wfireitm.loc_risk3%TYPE;
  v_tariff_zone              gipi_wfireitm.tariff_zone%TYPE;
  v_typhoon_zone             gipi_wfireitm.typhoon_zone%TYPE;
  v_construction_cd          gipi_wfireitm.construction_cd%TYPE;
  v_construction_remarks     gipi_wfireitm.construction_remarks%TYPE;
  v_front                    gipi_wfireitm.front%TYPE;
  v_right                    gipi_wfireitm.right%TYPE;
  v_left                     gipi_wfireitm.left%TYPE;
  v_rear                     gipi_wfireitm.rear%TYPE;
  v_occupancy_cd             gipi_wfireitm.occupancy_cd%TYPE;
  v_occupancy_remarks        gipi_wfireitm.occupancy_remarks%TYPE;
  v_flood_zone               gipi_wfireitm.flood_zone%TYPE;
  v_assignee                 gipi_wfireitm.assignee%TYPE;
  v_block_id                 gipi_wfireitm.block_id%TYPE;
  v_risk_cd                  gipi_wfireitm.risk_cd%TYPE;
  v_latitude                 gipi_wfireitm.latitude%TYPE; --Added by Jerome 11.14.2016 SR 5749
  v_longitude                gipi_wfireitm.longitude%TYPE; --Added by Jerome 11.14.2016 SR 5749

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying fire item info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wfireitm start ======='); 
  OPEN fireitm_cur;
  LOOP
    FETCH fireitm_cur    
     INTO v_item_no, v_dist_no, v_eq_zone, v_tarf_cd, v_block_no, v_fr_item_type,
          v_loc_risk1, v_loc_risk2, v_loc_risk3, v_tariff_zone, v_typhoon_zone,
          v_construction_cd, v_construction_remarks, v_front, v_right, v_left,
          v_rear, v_occupancy_cd, v_occupancy_remarks, v_flood_zone, v_assignee, 
          v_block_id, v_risk_cd, v_latitude, v_longitude;
     EXIT WHEN fireitm_cur%NOTFOUND;
     
   INSERT INTO gipi_wfireitm
         (par_id, item_no,  district_no, eq_zone, tarf_cd, block_no, fr_item_type,
          loc_risk1, loc_risk2, loc_risk3, tariff_zone, typhoon_zone, construction_cd,
          construction_remarks, front, right, left, rear, occupancy_cd, 
          occupancy_remarks, flood_zone, assignee, block_id, risk_cd, latitude, longitude)
          
   VALUES(p_in_copy_par_id, v_item_no, v_dist_no, v_eq_zone, v_tarf_cd, v_block_no,
          v_fr_item_type, v_loc_risk1, v_loc_risk2, v_loc_risk3, v_tariff_zone,
          v_typhoon_zone, v_construction_cd, v_construction_remarks, v_front,
          v_right, v_left, v_rear, v_occupancy_cd, v_occupancy_remarks, v_flood_zone,
          v_assignee, v_block_id, v_risk_cd, v_latitude, v_longitude);
  END LOOP;
  CLOSE fireitm_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

     
PROCEDURE copy_wgrouped_items (
    p_item_no          gipi_item.item_no%TYPE,
    p_in_par_id        gipi_parlist.par_id%TYPE,
    p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
  CURSOR grpd_itm_cur IS
  SELECT item_no ,grouped_item_no, grouped_item_title,
         include_tag, amount_covered, remarks, line_cd, subline_cd,
         sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
         group_cd, delete_sw, from_date, to_date, payt_terms, pack_ben_cd,
         ann_tsi_amt, ann_prem_amt, control_cd, control_type_cd, tsi_amt, prem_amt,
         principal_cd
    FROM gipi_wgrouped_items
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;
  
  v_item_no              gipi_wgrouped_items.item_no%TYPE;
  v_grouped_item_no      gipi_wgrouped_items.grouped_item_no%TYPE;
  v_grouped_item_title   gipi_wgrouped_items.grouped_item_title%TYPE;
  v_include_tag          gipi_wgrouped_items.include_tag%TYPE;
  v_amount_covered       gipi_wgrouped_items.amount_covered%TYPE;
  v_remarks              gipi_wgrouped_items.remarks%TYPE;
  v_line_cd              gipi_wgrouped_items.line_cd%TYPE;
  v_subline_cd           gipi_wgrouped_items.subline_cd%TYPE;
  v_sex                  gipi_wgrouped_items.sex%TYPE;
  v_position_cd          gipi_wgrouped_items.position_cd%TYPE;
  v_civil_status         gipi_wgrouped_items.civil_status%TYPE;
  v_date_of_birth        gipi_wgrouped_items.date_of_birth%TYPE;
  v_age                  gipi_wgrouped_items.age%TYPE;
  v_salary               gipi_wgrouped_items.salary%TYPE;
  v_salary_grade         gipi_wgrouped_items.salary_grade%TYPE;
  v_group_cd             gipi_wgrouped_items.group_cd%TYPE;
  v_delete_sw            gipi_wgrouped_items.delete_sw%TYPE;
  v_from_date            gipi_wgrouped_items.from_date%TYPE;
  v_to_date              gipi_wgrouped_items.to_date%TYPE;
  v_payt_terms           gipi_wgrouped_items.payt_terms%TYPE;
  v_pack_ben_cd          gipi_wgrouped_items.pack_ben_cd%TYPE;
  v_ann_tsi_amt          gipi_wgrouped_items.ann_tsi_amt%TYPE;
  v_ann_prem_amt         gipi_wgrouped_items.ann_prem_amt%TYPE;
  v_control_cd           gipi_wgrouped_items.control_cd%TYPE;
  v_control_type_cd      gipi_wgrouped_items.control_type_cd%TYPE;
  v_tsi_amt              gipi_wgrouped_items.tsi_amt%TYPE;
  v_prem_amt             gipi_wgrouped_items.prem_amt%TYPE;
  v_principal_cd         gipi_wgrouped_items.principal_cd%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying grouped item information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
 DBMS_OUTPUT.PUT_LINE('====== copy_wgrouped_items start ======='); 
  
  OPEN grpd_itm_cur;
  LOOP
    FETCH grpd_itm_cur
     INTO v_item_no ,           v_grouped_item_no,          v_grouped_item_title,
          v_include_tag,        v_amount_covered,           v_remarks, 
          v_line_cd,            v_subline_cd,               v_sex,
          v_position_cd,        v_civil_status,             v_date_of_birth,
          v_age,                v_salary,                   v_salary_grade,
          v_group_cd,           v_delete_sw,                v_from_date, 
          v_to_date,            v_payt_terms,               v_pack_ben_cd, 
          v_ann_tsi_amt,        v_ann_prem_amt,             v_control_cd, 
          v_control_type_cd,    v_tsi_amt,                  v_prem_amt, 
          v_principal_cd; 
     EXIT WHEN grpd_itm_cur%NOTFOUND;
    INSERT INTO gipi_wgrouped_items
          (par_id,         item_no ,        grouped_item_no,   grouped_item_title,
           include_tag,    amount_covered,  remarks,           line_cd, 
           subline_cd,     sex,             position_cd,       civil_status,
           date_of_birth,  age,             salary,            salary_grade,
           group_cd,       delete_sw,       from_date,         to_date, 
           payt_terms,     pack_ben_cd,     ann_tsi_amt,       ann_prem_amt, 
           control_cd,     control_type_cd, tsi_amt,           prem_amt,
           principal_cd)                                                                                                 
    VALUES(p_in_copy_par_id,v_item_no ,     v_grouped_item_no, v_grouped_item_title,
           v_include_tag,  v_amount_covered,v_remarks,         v_line_cd, 
           v_subline_cd,   v_sex,           v_position_cd,     v_civil_status,
           v_date_of_birth,v_age,           v_salary,          v_salary_grade,
           v_group_cd,     v_delete_sw,     v_from_date,       v_to_date, 
           v_payt_terms,   v_pack_ben_cd,   v_ann_tsi_amt,     v_ann_prem_amt, 
           v_control_cd,   v_control_type_cd,v_tsi_amt,        v_prem_amt, 
           v_principal_cd); 
           
           copy_wgrp_items_beneficiary(v_item_no, v_grouped_item_no,p_in_par_id,p_in_copy_par_id); 
           copy_witmperil_beneficiary(v_item_no, v_grouped_item_no, p_in_par_id,p_in_copy_par_id);  
           copy_witmperl_grouped(v_item_no, v_grouped_item_no,p_in_par_id,p_in_copy_par_id);   
  END LOOP;
  CLOSE grpd_itm_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
END;


PROCEDURE copy_wgrp_items_beneficiary (
        p_item_no          gipi_item.item_no%TYPE,
        p_grouped_item_no  gipi_grp_items_beneficiary.grouped_item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR grpd_itm_cur IS
  SELECT item_no ,grouped_item_no, beneficiary_no, beneficiary_name,
         beneficiary_addr, relation, date_of_birth, age, civil_status,
         sex
    FROM gipi_wgrp_items_beneficiary
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no
     AND grouped_item_no = p_grouped_item_no;
  
  v_item_no              gipi_wgrp_items_beneficiary.item_no%TYPE;
  v_grouped_item_no      gipi_wgrp_items_beneficiary.grouped_item_no%TYPE;
  v_beneficiary_no       gipi_wgrp_items_beneficiary.beneficiary_no%TYPE;
  v_beneficiary_name     gipi_wgrp_items_beneficiary.beneficiary_name%TYPE;
  v_beneficiary_addr     gipi_wgrp_items_beneficiary.beneficiary_addr%TYPE;
  v_relation             gipi_wgrp_items_beneficiary.relation%TYPE;
  v_sex                  gipi_wgrp_items_beneficiary.sex%TYPE;
  v_civil_status         gipi_wgrp_items_beneficiary.civil_status%TYPE;
  v_date_of_birth        gipi_wgrp_items_beneficiary.date_of_birth%TYPE;
  v_age                  gipi_wgrp_items_beneficiary.age%TYPE;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying grouped items beneficary information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  
  DBMS_OUTPUT.PUT_LINE('====== copy_wgrp_items_beneficiary start ======='); 
  OPEN grpd_itm_cur;
  LOOP
    FETCH grpd_itm_cur
     INTO v_item_no ,         v_grouped_item_no,  v_beneficiary_no,
          v_beneficiary_name, v_beneficiary_addr, v_relation,  v_date_of_birth,
          v_age,              v_civil_status,     v_sex;
     EXIT WHEN grpd_itm_cur%NOTFOUND;
     
    INSERT INTO gipi_wgrp_items_beneficiary
         (par_id,             item_no ,           grouped_item_no,    beneficiary_no,
          beneficiary_name,   beneficiary_addr,   relation,           date_of_birth,
          age,                civil_status,       sex)
          
    VALUES(p_in_copy_par_id,  v_item_no ,         v_grouped_item_no,  v_beneficiary_no,
          v_beneficiary_name, v_beneficiary_addr, v_relation,         v_date_of_birth,
          v_age,              v_civil_status,     v_sex);
  END LOOP;
  CLOSE grpd_itm_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
END; 

PROCEDURE copy_winstallment(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE

  )IS
  CURSOR installment_cur IS
  SELECT item_grp,inst_no,share_pct,
         prem_amt,tax_amt,due_date,
         TAKEUP_SEQ_NO
    FROM gipi_winstallment
   WHERE par_id = p_in_par_id;

v_count          NUMBER;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying installment info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_winstallment start ======='); 
   FOR installment_var IN installment_cur LOOP
   INSERT INTO gipi_winstallment
          (par_id,                      item_grp,   
           inst_no,                     share_pct,
           prem_amt,                    tax_amt,    
           due_date,                    TAKEUP_SEQ_NO)
           
   VALUES (p_in_copy_par_id,            installment_var.item_grp,
           installment_var.inst_no,     installment_var.share_pct,
           installment_var.prem_amt,    installment_var.tax_amt,
           installment_var.due_date,    installment_var.TAKEUP_SEQ_NO);
  END LOOP;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_winvoice(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  )IS
  CURSOR invoice_cur IS
  SELECT item_grp,payt_terms,prem_seq_no,prem_amt,tax_amt,property,insured,
         due_date,notarial_fee,ri_comm_amt,currency_cd,currency_rt,remarks,
         other_charges,bond_rate,bond_tsi_amt,ref_inv_no,policy_currency,
         pay_type,card_name,card_no,approval_cd,expiry_date, ri_comm_vat,
         MULTI_BOOKING_MM, MULTI_BOOKING_YY, NO_OF_TAKEUP, DIST_FLAG, CHANGED_TAG, TAKEUP_SEQ_NO
    FROM gipi_winvoice
   WHERE par_id = p_in_par_id;

  v_item_grp            gipi_winvoice.item_grp%TYPE;
  v_payt_terms          gipi_winvoice.payt_terms%TYPE;
  v_prem_seq_no         gipi_winvoice.prem_seq_no%TYPE;
  v_prem_amt            gipi_winvoice.prem_amt%TYPE;
  v_tax_amt             gipi_winvoice.tax_amt%TYPE;
  v_property            gipi_winvoice.property%TYPE;
  v_insured             gipi_winvoice.insured%TYPE;
  v_due_date            gipi_winvoice.due_date%TYPE;
  v_notarial_fee        gipi_winvoice.notarial_fee%TYPE;
  v_ri_comm_amt         gipi_winvoice.ri_comm_amt%TYPE;
  v_currency_cd         gipi_winvoice.currency_cd%TYPE;
  v_currency_rt         gipi_winvoice.currency_rt%TYPE;
  v_remarks             gipi_winvoice.remarks%TYPE;
  v_other_charges       gipi_winvoice.other_charges%TYPE;
  v_bond_rate           gipi_winvoice.bond_rate%TYPE;
  v_bond_tsi_amt        gipi_winvoice.bond_tsi_amt%TYPE;
  v_ref_inv_no          gipi_winvoice.ref_inv_no%TYPE;
  v_policy_currency     gipi_winvoice.policy_currency%TYPE;
  v_pay_type            gipi_winvoice.pay_type%TYPE;
  v_card_name           gipi_winvoice.card_name%TYPE;
  v_card_no             gipi_winvoice.card_no%TYPE;
  v_approval_cd         gipi_winvoice.approval_cd%TYPE;
  v_expiry_date         gipi_winvoice.expiry_date%TYPE;
  v_ri_comm_vat         gipi_winvoice.ri_comm_vat%TYPE;
  v_MULTI_BOOKING_MM    gipi_invoice.MULTI_BOOKING_MM%TYPE;
  v_MULTI_BOOKING_YY    gipi_invoice.MULTI_BOOKING_YY%TYPE;
  v_NO_OF_TAKEUP        gipi_invoice.NO_OF_TAKEUP%TYPE;
  v_DIST_FLAG           gipi_invoice.DIST_FLAG%TYPE;
  v_CHANGED_TAG         gipi_invoice.CHANGED_TAG%TYPE;
  v_TAKEUP_SEQ_NO       gipi_invoice.TAKEUP_SEQ_NO%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying invoice info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_winvoice start ======='); 
  OPEN invoice_cur;
  LOOP
    FETCH invoice_cur
     INTO v_item_grp,       v_payt_terms,       v_prem_seq_no,
          v_prem_amt,       v_tax_amt,          v_property,
          v_insured,        v_due_date,         v_notarial_fee,
          v_ri_comm_amt,    v_currency_cd,      v_currency_rt,
          v_remarks,        v_other_charges,    v_bond_rate,
          v_bond_tsi_amt,   v_ref_inv_no,       v_policy_currency,
          v_pay_type,       v_card_name,        v_card_no,
          v_approval_cd,    v_expiry_date,      v_ri_comm_vat,
          v_MULTI_BOOKING_MM,v_MULTI_BOOKING_YY,v_NO_OF_TAKEUP,
          v_DIST_FLAG,       v_CHANGED_TAG,     v_TAKEUP_SEQ_NO; 
     EXIT WHEN invoice_cur%NOTFOUND;
   INSERT INTO gipi_winvoice
          (par_id,        item_grp,       payt_terms,    prem_seq_no,      prem_amt,
           tax_amt,       property,       insured,       due_date,         notarial_fee,
           ri_comm_amt,   currency_cd,    currency_rt,   remarks,          other_charges,
           bond_rate,     bond_tsi_amt,   ref_inv_no,    policy_currency,  pay_type,
           card_name,     card_no,        approval_cd,   expiry_date,      ri_comm_vat,
           MULTI_BOOKING_MM, MULTI_BOOKING_YY, NO_OF_TAKEUP, DIST_FLAG, CHANGED_TAG, TAKEUP_SEQ_NO)
   VALUES (p_in_copy_par_id,v_item_grp,   v_payt_terms,  v_prem_seq_no,     v_prem_amt,
           v_tax_amt,     v_property,     v_insured,     SYSDATE,           v_notarial_fee,
           v_ri_comm_amt, v_currency_cd,  v_currency_rt, v_remarks,         v_other_charges,
           v_bond_rate,   v_bond_tsi_amt, v_ref_inv_no,  v_policy_currency, v_pay_type,
           v_card_name,   v_card_no,      v_approval_cd, v_expiry_date,     v_ri_comm_vat,
           v_MULTI_BOOKING_MM, v_MULTI_BOOKING_YY, v_NO_OF_TAKEUP, v_DIST_FLAG, v_CHANGED_TAG, v_TAKEUP_SEQ_NO);
  END LOOP;
  CLOSE invoice_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN DUP_VAL_ON_INDEX THEN
      NULL;
END;     

PROCEDURE copy_winvperl(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE) 
  IS
  CURSOR invperl_cur IS
  SELECT peril_cd,      item_grp,       tsi_amt,
         prem_amt,      ri_comm_amt,    ri_comm_rt,
         TAKEUP_SEQ_NO
    FROM gipi_winvperl
   WHERE par_id = p_in_par_id;

  v_peril_cd        gipi_winvperl.peril_cd%TYPE;
  v_item_grp        gipi_winvperl.item_grp%TYPE;
  v_tsi_amt         gipi_winvperl.tsi_amt%TYPE;
  v_prem_amt        gipi_winvperl.prem_amt%TYPE;
  v_ri_comm_amt     gipi_winvperl.ri_comm_amt%TYPE;
  v_ri_comm_rt      gipi_winvperl.ri_comm_rt%TYPE;
  v_TAKEUP_SEQ_NO   gipi_winvperl.takeup_seq_no%TYPE;
v_count        NUMBER;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying invoice peril info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_winvperl start ======='); 
  OPEN invperl_cur;
  LOOP
    FETCH invperl_cur
     INTO v_peril_cd,       v_item_grp,     v_tsi_amt,
          v_prem_amt,       v_ri_comm_amt,  v_ri_comm_rt,
          v_TAKEUP_SEQ_NO;

     EXIT WHEN invperl_cur%NOTFOUND;
     
   INSERT INTO gipi_winvperl
          (par_id,          peril_cd,       item_grp,
           tsi_amt,         prem_amt,       ri_comm_amt,
           ri_comm_rt,      TAKEUP_SEQ_NO)
           
   VALUES (p_in_copy_par_id,v_peril_cd,     v_item_grp,
           v_tsi_amt,       v_prem_amt,     v_ri_comm_amt,
           v_ri_comm_rt,    v_TAKEUP_SEQ_NO);
  END LOOP;
  CLOSE invperl_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_winv_tax(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
  CURSOR inv_tax_cur IS
  SELECT item_grp,
     tax_cd,
     line_cd,
     iss_cd,
     tax_amt,
     tax_id,
     tax_allocation,
     fixed_tax_allocation,
     rate,
     TAKEUP_SEQ_NO
    FROM gipi_winv_tax
   WHERE par_id = p_in_par_id;

  v_item_grp                gipi_winv_tax.item_grp%TYPE;
  v_tax_cd                  gipi_winv_tax.tax_cd%TYPE;
  v_line_cd                 gipi_winv_tax.line_cd%TYPE;
  v_iss_cd                  gipi_winv_tax.iss_cd%TYPE;
  v_tax_amt                 gipi_winv_tax.tax_amt%TYPE;
  v_tax_id                  gipi_winv_tax.tax_id%TYPE;
  v_tax_allocation          gipi_winv_tax.tax_allocation%TYPE;
  v_fixed_tax_allocation    gipi_winv_tax.fixed_tax_allocation%TYPE;
  v_rate                    gipi_winv_tax.rate%TYPE; 
  v_TAKEUP_SEQ_NO           gipi_winv_tax.takeup_seq_no%TYPE;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying invoice tax info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_winv_tax start ======='); 
  OPEN inv_tax_cur;
  LOOP
    FETCH inv_tax_cur
     INTO v_item_grp,
      v_tax_cd,
      v_line_cd,
      v_iss_cd,
      v_tax_amt,
      v_tax_id,
      v_tax_allocation,
      v_fixed_tax_allocation,
      v_rate,
      -- longterm --
      v_TAKEUP_SEQ_NO;
     EXIT WHEN inv_tax_cur%NOTFOUND; 
   INSERT INTO gipi_winv_tax
     (par_id,
      item_grp,
      tax_cd,
      line_cd,
      iss_cd,
      tax_amt,
      tax_id,
      tax_allocation,
      fixed_tax_allocation,
      rate,
      TAKEUP_SEQ_NO)
   VALUES (p_in_copy_par_id,
      v_item_grp,
      v_tax_cd,
      v_line_cd,
      v_iss_cd,
      v_tax_amt,
      v_tax_id,
      v_tax_allocation,
      v_fixed_tax_allocation,
      v_rate,
      v_TAKEUP_SEQ_NO);
  END LOOP;
  CLOSE inv_tax_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_witem (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  ) IS
  CURSOR item_cur IS
  SELECT item_no,item_grp,item_title,item_desc,tsi_amt,prem_amt,ann_tsi_amt,
         ann_prem_amt, rec_flag,currency_cd,currency_rt,group_cd,from_date,
         to_date,pack_line_cd,pack_subline_cd,discount_sw,coverage_cd,item_desc2,
         other_info,surcharge_sw,region_cd,changed_tag, prorate_flag, comp_sw, 
         short_rt_percent,pack_ben_cd, payt_terms, risk_no, risk_item_no
    FROM gipi_witem
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no              gipi_witem.item_no%TYPE;
  v_item_grp             gipi_witem.item_grp%TYPE;
  v_item_title           gipi_witem.item_title%TYPE;
  v_item_desc            gipi_witem.item_desc%TYPE;
  v_tsi_amt              gipi_witem.tsi_amt%TYPE;
  v_prem_amt             gipi_witem.prem_amt%TYPE;
  v_ann_prem_amt         gipi_witem.ann_prem_amt%TYPE;
  v_ann_tsi_amt          gipi_witem.ann_tsi_amt%TYPE;
  v_rec_flag             gipi_witem.rec_flag%TYPE;
  v_currency_cd          gipi_witem.currency_cd%TYPE;
  v_currency_rt          gipi_witem.currency_rt%TYPE;
  v_group_cd             gipi_witem.group_cd%TYPE;
  v_from_date            gipi_witem.from_date%TYPE;
  v_to_date              gipi_witem.to_date%TYPE;
  v_pack_line_cd         gipi_witem.pack_line_cd%TYPE;
  v_pack_subline_cd      gipi_witem.pack_subline_cd%TYPE;
  v_discount_sw          gipi_witem.discount_sw%TYPE;
  v_coverage_cd          gipi_witem.coverage_cd%TYPE;  
  v_item_desc2           gipi_witem.item_desc2%TYPE;
  v_other_info           gipi_witem.other_info%TYPE;
  v_surcharge_sw         gipi_witem.surcharge_sw%TYPE;
  v_region_cd            gipi_witem.region_cd%TYPE;
  v_changed_tag          gipi_witem.changed_tag%TYPE;
  v_prorate_flag         gipi_witem.prorate_flag%TYPE;
  v_comp_sw              gipi_witem.comp_sw%TYPE; 
  v_short_rt_percent     gipi_witem.short_rt_percent%TYPE; 
  v_pack_ben_cd          gipi_witem.pack_ben_cd%TYPE; 
  v_payt_terms           gipi_witem.payt_terms%TYPE; 
  v_risk_no              gipi_witem.risk_no%TYPE; 
  v_risk_item_no         gipi_witem.risk_item_no%TYPE; 
  

BEGIN
--    CLEAR_MESSAGE;
--  MESSAGE('Copying item info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_witem start ======='); 
  OPEN item_cur;
  LOOP
    FETCH item_cur
     INTO v_item_no,            v_item_grp,             v_item_title,
          v_item_desc,          v_tsi_amt,              v_prem_amt,
          v_ann_tsi_amt,        v_ann_prem_amt,         v_rec_flag,
          v_currency_cd,        v_currency_rt,          v_group_cd,
          v_from_date,          v_to_date,              v_pack_line_cd,
          v_pack_subline_cd,    v_discount_sw,          v_coverage_cd,
          v_item_desc2,         v_other_info,           v_surcharge_sw,
          v_region_cd,          v_changed_tag,          v_prorate_flag,
          v_comp_sw,            v_short_rt_percent,     v_pack_ben_cd,
          v_payt_terms,         v_risk_no,              v_risk_item_no;
     EXIT WHEN item_cur%NOTFOUND;
   INSERT INTO gipi_witem
         (par_id,               item_no,                item_grp,      
          item_title,           item_desc,              tsi_amt,
          prem_amt,             ann_tsi_amt,            ann_prem_amt,
          rec_flag,             currency_cd,            currency_rt,
          group_cd,             from_date,              to_date,
          pack_line_cd,         pack_subline_cd,        discount_sw,
          coverage_cd,          item_desc2,             other_info,
          surcharge_sw,         region_cd,              changed_tag,
          prorate_flag,         comp_sw,                short_rt_percent,   
          pack_ben_cd,          payt_terms,             risk_no,                      
          risk_item_no)
   VALUES (p_in_copy_par_id,    v_item_no,              v_item_grp,
          v_item_title,         v_item_desc,            v_tsi_amt,
          v_prem_amt,           v_ann_tsi_amt,          v_ann_prem_amt, 
          v_rec_flag,           v_currency_cd,          v_currency_rt,
          v_group_cd,           v_from_date,            v_to_date,
          v_pack_line_cd,       v_pack_subline_cd,      v_discount_sw,
          v_coverage_cd,        v_item_desc2,           v_other_info,
          v_surcharge_sw,       v_region_cd,            v_changed_tag,
          v_prorate_flag,       v_comp_sw,              v_short_rt_percent,
          v_pack_ben_cd,        v_payt_terms,           v_risk_no,
          v_risk_item_no);
  END LOOP;
  CLOSE item_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
     NULL;
END;



PROCEDURE copy_witemds(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  )IS
  CURSOR itemds_cur IS
  SELECT dist_seq_no,
         item_no,
         tsi_amt,
         prem_amt,
         ann_tsi_amt
    FROM giuw_witemds
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id);

  v_dist_seq_no         giuw_witemds.dist_seq_no%TYPE;
  v_item_no             giuw_witemds.item_no%TYPE;
  v_tsi_amt             giuw_witemds.tsi_amt%TYPE;
  v_prem_amt            giuw_witemds.prem_amt%TYPE;
  v_ann_tsi_amt         giuw_witemds.ann_tsi_amt%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy item distribution info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witemds start ======='); 
  OPEN itemds_cur;
  LOOP
    FETCH itemds_cur
     INTO v_dist_seq_no,
          v_item_no,
          v_tsi_amt,
          v_prem_amt,
          v_ann_tsi_amt;
     EXIT WHEN itemds_cur%NOTFOUND;
     INSERT INTO giuw_witemds
       (dist_no,
        dist_seq_no,
        item_no,
        tsi_amt,
        prem_amt,
        ann_tsi_amt)
     VALUES 
       (p_copy_dist_no,
        v_dist_seq_no,
        v_item_no,
        v_tsi_amt,
        v_prem_amt,
        v_ann_tsi_amt);
  END LOOP;
  CLOSE itemds_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_witemds_dtl(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  ) IS
  CURSOR itemds_dtl_cur IS
  SELECT dist_seq_no,item_no,line_cd,share_cd,dist_spct,
         dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp,dist_spct1
    FROM giuw_witemds_dtl
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id)
     AND item_no = (SELECT item_no
                      FROM giuw_witemds
                     WHERE dist_no = (SELECT dist_no
                                        FROM giuw_pol_dist
                                       WHERE par_id = p_in_par_id));

  v_dist_seq_no         giuw_witemds_dtl.dist_seq_no%TYPE;
  v_item_no             giuw_witemds_dtl.item_no%TYPE;
  v_line_cd             giuw_witemds_dtl.line_cd%TYPE;
  v_share_cd            giuw_witemds_dtl.share_cd%TYPE;
  v_dist_spct           giuw_witemds_dtl.dist_spct%TYPE;
  v_dist_tsi            giuw_witemds_dtl.dist_tsi%TYPE;
  v_dist_prem           giuw_witemds_dtl.dist_prem%TYPE;
  v_ann_dist_spct       giuw_witemds_dtl.ann_dist_spct%TYPE;
  v_ann_dist_tsi        giuw_witemds_dtl.ann_dist_tsi%TYPE;
  v_dist_grp            giuw_witemds_dtl.dist_grp%TYPE;
  v_dist_spct1          giuw_witemds_dtl.dist_spct1%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy item distribution details info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witemds_dtl start ======='); 
  OPEN itemds_dtl_cur;
  LOOP
    FETCH itemds_dtl_cur
     INTO v_dist_seq_no,v_item_no,v_line_cd,v_share_cd,v_dist_spct,
          v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp,v_dist_spct1;
     EXIT WHEN itemds_dtl_cur%NOTFOUND;
    INSERT INTO giuw_witemds_dtl
           (dist_no,            dist_seq_no,            item_no,
            line_cd,            share_cd,               dist_spct,
            dist_tsi,           dist_prem,              ann_dist_spct,
            ann_dist_tsi,       dist_grp,               dist_spct1
           )
    VALUES (p_copy_dist_no,     v_dist_seq_no,          v_item_no,
            v_line_cd,          v_share_cd,             v_dist_spct,
            v_dist_tsi,         v_dist_prem,            v_ann_dist_spct,    
            v_ann_dist_tsi,     v_dist_grp,             v_dist_spct1);
  END LOOP;
  CLOSE itemds_dtl_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END; 

PROCEDURE copy_witemperilds(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  ) IS
  CURSOR itemperilds_cur IS
  SELECT dist_seq_no,item_no,peril_cd,line_cd,tsi_amt,prem_amt,ann_tsi_amt
    FROM giuw_witemperilds
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id);

  v_dist_seq_no         giuw_witemperilds.dist_seq_no%TYPE;
  v_item_no             giuw_witemperilds.item_no%TYPE;
  v_peril_cd            giuw_witemperilds.peril_cd%TYPE;
  v_line_cd             giuw_witemperilds.line_cd%TYPE;
  v_tsi_amt             giuw_witemperilds.tsi_amt%TYPE;
  v_prem_amt            giuw_witemperilds.prem_amt%TYPE;
  v_ann_tsi_amt         giuw_witemperilds.ann_tsi_amt%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy item-peril distribution info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witemperilds start ======='); 
  OPEN itemperilds_cur;
  LOOP
    FETCH itemperilds_cur
     INTO v_dist_seq_no,    v_item_no,      v_peril_cd,
          v_line_cd,        v_tsi_amt,      v_prem_amt,
          v_ann_tsi_amt;
     EXIT WHEN itemperilds_cur%NOTFOUND;
     
    INSERT INTO giuw_witemperilds
           (dist_no,        dist_seq_no,    item_no,    peril_cd,
            line_cd,        tsi_amt,        prem_amt,   ann_tsi_amt)
            
    VALUES (p_copy_dist_no, v_dist_seq_no,  v_item_no,  v_peril_cd,
            v_line_cd,      v_tsi_amt,      v_prem_amt, v_ann_tsi_amt);
  END LOOP;
  CLOSE itemperilds_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_witemperilds_dtl(
        p_copy_dist_no     giuw_witemds.dist_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE
  ) IS
  CURSOR itemperilds_dtl_cur IS
  SELECT dist_seq_no,item_no,line_cd,peril_cd,share_cd,dist_spct,
         dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp,dist_spct1
    FROM giuw_witemperilds_dtl
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id)
     AND item_no = (SELECT item_no
                      FROM giuw_witemperilds
                     WHERE dist_no = (SELECT dist_no
                                        FROM giuw_pol_dist
                                       WHERE par_id = p_in_par_id))
     AND peril_cd = (SELECT peril_cd
                      FROM giuw_witemperilds
                     WHERE dist_no = (SELECT dist_no
                                        FROM giuw_pol_dist
                                       WHERE par_id = p_in_par_id));

  v_dist_seq_no         giuw_witemperilds_dtl.dist_seq_no%TYPE;
  v_item_no             giuw_witemperilds_dtl.item_no%TYPE;
  v_line_cd             giuw_witemperilds_dtl.line_cd%TYPE;
  v_peril_cd            giuw_witemperilds_dtl.peril_cd%TYPE;
  v_share_cd            giuw_witemperilds_dtl.share_cd%TYPE;
  v_dist_spct           giuw_witemperilds_dtl.dist_spct%TYPE;
  v_dist_tsi            giuw_witemperilds_dtl.dist_tsi%TYPE;
  v_dist_prem           giuw_witemperilds_dtl.dist_prem%TYPE;
  v_ann_dist_spct       giuw_witemperilds_dtl.ann_dist_spct%TYPE;
  v_ann_dist_tsi        giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
  v_dist_grp            giuw_witemperilds_dtl.dist_grp%TYPE;
  v_dist_spct1          giuw_witemperilds_dtl.dist_spct1%TYPE;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy item-peril distribution details info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witemperilds_dtl start ======='); 
  OPEN itemperilds_dtl_cur;
  LOOP
    FETCH itemperilds_dtl_cur
     INTO v_dist_seq_no,v_item_no,v_line_cd,v_peril_cd,v_share_cd,v_dist_spct,
          v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp,v_dist_spct1;
          
     EXIT WHEN itemperilds_dtl_cur%NOTFOUND;
     
    INSERT INTO giuw_witemperilds_dtl
           (dist_no,            dist_seq_no,            item_no,
            line_cd,            peril_cd,               share_cd,
            dist_spct,          dist_tsi,               dist_prem,
            ann_dist_spct,      ann_dist_tsi,           dist_grp,
            dist_spct1)
    VALUES (p_copy_dist_no,     v_dist_seq_no,          v_item_no,
            v_line_cd,          v_peril_cd,             v_share_cd,
            v_dist_spct,        v_dist_tsi,             v_dist_prem,
            v_ann_dist_spct,    v_ann_dist_tsi,         v_dist_grp,
            v_dist_spct1);
  END LOOP;
  CLOSE itemperilds_dtl_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_witem_discount(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  ) IS
  CURSOR discount_cur IS
  SELECT line_cd,       subline_cd,      sequence,        item_no,
         disc_rt,       disc_amt,        net_gross_tag,   orig_prem_amt, 
         net_prem_amt,  last_update,     remarks,         surcharge_rt,  
         surcharge_amt     
    FROM gipi_witem_discount
   WHERE par_id = p_in_par_id;

  v_line_cd             gipi_wperil_discount.line_cd%TYPE;
  v_item_no             gipi_wperil_discount.item_no%TYPE;
  v_sequence            gipi_wperil_discount.sequence%TYPE;
  v_disc_rt             gipi_wperil_discount.disc_rt%TYPE;
  v_disc_amt            gipi_wperil_discount.disc_amt%TYPE;
  v_net_gross_tag       gipi_wperil_discount.net_gross_tag%TYPE;
  v_subline_cd          gipi_wperil_discount.subline_cd%TYPE;
  v_orig_prem_amt       gipi_wpolbas_discount.orig_prem_amt%TYPE;
  v_net_prem_amt        gipi_wperil_discount.net_prem_amt%TYPE;
  v_last_update         gipi_wperil_discount.last_update%TYPE;
  v_remarks             gipi_wperil_discount.remarks%TYPE;
  v_surcharge_rt        gipi_wperil_discount.surcharge_rt%TYPE;
  v_surcharge_amt       gipi_wperil_discount.surcharge_amt%TYPE;
    
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying policy discount info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witem_discount start ======='); 
  OPEN discount_cur;
  LOOP
    FETCH discount_cur
     INTO v_line_cd,         v_subline_cd,     v_sequence,          v_item_no, 
          v_disc_rt,         v_disc_amt,       v_net_gross_tag,     v_orig_prem_amt,   
          v_net_prem_amt,    v_last_update,    v_remarks,           v_surcharge_rt,    
          v_surcharge_amt;
     EXIT WHEN discount_cur%NOTFOUND;
    INSERT INTO gipi_witem_discount
         (par_id,           line_cd,        subline_cd,         sequence,         
          item_no,          disc_rt,        disc_amt,           net_gross_tag,      
          orig_prem_amt,    net_prem_amt,   last_update,        remarks,
          surcharge_rt,     surcharge_amt 
         )
    VALUES 
         (p_in_copy_par_id, v_line_cd,      v_subline_cd,       v_sequence,      
          v_item_no,        v_disc_rt,      v_disc_amt,         v_net_gross_tag, 
          v_orig_prem_amt,  v_net_prem_amt, v_last_update,      v_remarks,
          v_surcharge_rt,   v_surcharge_amt );
  END LOOP;
  CLOSE discount_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_witem_pack (
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE,
        p_item_grp         gipi_witem.item_grp%TYPE,
        p_item_no          gipi_witem.item_no%TYPE
  ) IS
  CURSOR item_cur IS
  SELECT item_no,item_grp,item_title,item_desc,tsi_amt,prem_amt,ann_prem_amt,
         ann_tsi_amt,rec_flag,currency_cd,currency_rt,group_cd,from_date,
         to_date,pack_line_cd,pack_subline_cd,discount_sw,item_desc2,coverage_cd,
         other_info,surcharge_sw, region_cd, changed_tag, prorate_flag, comp_sw, --mod1 start
         short_rt_percent,pack_ben_cd, payt_terms, risk_no, risk_item_no -- mod1 end
    FROM gipi_witem
   WHERE par_id = p_in_par_id
     AND item_grp = p_item_grp
     AND item_no = p_item_no;

  v_item_no                     gipi_witem.item_no%TYPE;
  v_item_grp                    gipi_witem.item_grp%TYPE;
  v_item_title                  gipi_witem.item_title%TYPE;
  v_item_desc                   gipi_witem.item_desc%TYPE;
  v_tsi_amt                     gipi_witem.tsi_amt%TYPE;
  v_prem_amt                    gipi_witem.prem_amt%TYPE;
  v_ann_prem_amt                gipi_witem.ann_prem_amt%TYPE;
  v_ann_tsi_amt                 gipi_witem.ann_tsi_amt%TYPE;
  v_rec_flag                    gipi_witem.rec_flag%TYPE;
  v_currency_cd                 gipi_witem.currency_cd%TYPE;
  v_currency_rt                 gipi_witem.currency_rt%TYPE;
  v_group_cd                    gipi_witem.group_cd%TYPE;
  v_from_date                   gipi_witem.from_date%TYPE;
  v_to_date                     gipi_witem.to_date%TYPE;
  v_pack_line_cd                gipi_witem.pack_line_cd%TYPE;
  v_pack_subline_cd             gipi_witem.pack_subline_cd%TYPE;
  v_discount_sw                 gipi_witem.discount_sw%TYPE;
  v_item_desc2                  gipi_witem.item_desc2%TYPE;
  v_coverage_cd                 gipi_witem.coverage_cd%TYPE;
  v_other_info                  gipi_witem.other_info%TYPE;
  v_surcharge_sw                gipi_witem.surcharge_sw%TYPE;
  v_region_cd                   gipi_witem.region_cd%TYPE;
  v_changed_tag                 gipi_witem.changed_tag%TYPE;
  v_prorate_flag                gipi_witem.prorate_flag%TYPE;
  v_comp_sw                     gipi_witem.comp_sw%TYPE;
  v_short_rt_percent            gipi_witem.short_rt_percent%TYPE;
  v_pack_ben_cd                 gipi_witem.pack_ben_cd%TYPE;
  v_payt_terms                  gipi_witem.payt_terms%TYPE;
  v_risk_no                     gipi_witem.risk_no%TYPE;
  v_risk_item_no                gipi_witem.risk_item_no%TYPE;
 
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying item info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_witem_pack start ======='); 
  OPEN item_cur;
  LOOP
    FETCH item_cur
     INTO v_item_no,                v_item_grp,             v_item_title,
          v_item_desc,              v_tsi_amt,              v_prem_amt,
          v_ann_tsi_amt,            v_ann_prem_amt,         v_rec_flag,
          v_currency_cd,            v_currency_rt,          v_group_cd,
          v_from_date,              v_to_date,              v_pack_line_cd,
          v_pack_subline_cd,        v_discount_sw,          v_item_desc2,
          v_coverage_cd,            v_other_info,           v_surcharge_sw, 
          v_region_cd,              v_changed_tag,          v_prorate_flag,
          v_comp_sw,                v_short_rt_percent,     v_pack_ben_cd, 
          v_payt_terms,             v_risk_no,              v_risk_item_no;  
     EXIT WHEN item_cur%NOTFOUND;
   INSERT INTO gipi_witem
         (par_id,                   item_no,                item_grp,           
          item_title,               item_desc,              tsi_amt,          
          prem_amt,                 ann_tsi_amt,            ann_prem_amt,       
          rec_flag,                 currency_cd,            currency_rt,        
          group_cd,                 from_date,              to_date,                  
          pack_line_cd,             pack_subline_cd,        discount_sw,          
          item_desc2,               coverage_cd,            other_info,       
          surcharge_sw,             region_cd,              changed_tag,             
          prorate_flag,             comp_sw,                short_rt_percent, 
          pack_ben_cd,              payt_terms,             risk_no,                     
          risk_item_no
         )        
   VALUES 
         (p_in_copy_par_id,         v_item_no,              v_item_grp,       
          v_item_title,             v_item_desc,            v_tsi_amt,        
          v_prem_amt,               v_ann_tsi_amt,          v_ann_prem_amt,      
          v_rec_flag,               v_currency_cd,          v_currency_rt,      
          v_group_cd,               v_from_date,            v_to_date,              
          v_pack_line_cd,           v_pack_subline_cd,      v_discount_sw,    
          v_item_desc2,             v_coverage_cd,          v_other_info,     
          v_surcharge_sw,           v_region_cd,            v_changed_tag,         
          v_prorate_flag,           v_comp_sw,              v_short_rt_percent, 
          v_pack_ben_cd,            v_payt_terms,           v_risk_no,                 
          v_risk_item_no
         );    
  END LOOP;
  CLOSE item_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
     NULL;
END;


PROCEDURE copy_witem_ves( 
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE 
  ) IS
  CURSOR item_ves_cur IS
  SELECT item_no,vessel_cd,geog_limit,rec_flag,deduct_text,dry_date,dry_place
    FROM gipi_witem_ves
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no         gipi_witem_ves.item_no%TYPE;
  v_vessel_cd       gipi_witem_ves.vessel_cd%TYPE;
  v_geog_limit      gipi_witem_ves.geog_limit%TYPE;
  v_rec_flag        gipi_witem_ves.rec_flag%TYPE;
  v_deduct_text     gipi_witem_ves.deduct_text%TYPE;
  v_dry_date        gipi_witem_ves.dry_date%TYPE;
  v_dry_place       gipi_witem_ves.dry_place%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying item vessel info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witem_ves start ======='); 
  OPEN item_ves_cur;
  LOOP
    FETCH item_ves_cur
     INTO v_item_no,v_vessel_cd,v_geog_limit,
          v_rec_flag,v_deduct_text,v_dry_date,v_dry_place;
     EXIT WHEN item_ves_cur%NOTFOUND;
   INSERT INTO gipi_witem_ves
          (par_id,          item_no,        vessel_cd,      geog_limit,
           rec_flag,        deduct_text,    dry_date,       dry_place)
           
   VALUES (p_in_copy_par_id,v_item_no,      v_vessel_cd,    v_geog_limit,
           v_rec_flag,      v_deduct_text,  v_dry_date,     v_dry_place);
  END LOOP;
  CLOSE item_ves_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_witmperil_beneficiary (
        p_item_no          gipi_witmperl_beneficiary.item_no%TYPE,
        p_gitem_no         gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS                                    
  v_item_no                 gipi_witmperl_beneficiary.item_no%TYPE;
  v_grouped_item_no         gipi_witmperl_beneficiary.grouped_item_no%TYPE;
  v_beneficiary_no          gipi_witmperl_beneficiary.beneficiary_no%TYPE;
  v_line_cd                 gipi_witmperl_beneficiary.line_cd%TYPE;
  v_peril_cd                gipi_witmperl_beneficiary.peril_cd%TYPE;
  v_rec_flag                gipi_witmperl_beneficiary.rec_flag%TYPE;
  v_prem_rt                 gipi_witmperl_beneficiary.prem_rt%TYPE;
  v_tsi_amt                 gipi_witmperl_beneficiary.tsi_amt%TYPE;
  v_prem_amt                gipi_witmperl_beneficiary.prem_amt%TYPE;
  v_ann_tsi_amt             gipi_witmperl_beneficiary.ann_tsi_amt%TYPE;
  v_ann_prem_amt            gipi_witmperl_beneficiary.ann_prem_amt%TYPE;  

  CURSOR witmperil_ben_cur IS
  SELECT item_no,       grouped_item_no,        beneficiary_no,
         line_cd,       peril_cd,               rec_flag,
         prem_rt,       tsi_amt,                prem_amt,
         ann_tsi_amt,   ann_prem_amt         
    FROM gipi_witmperl_beneficiary
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no
     AND grouped_item_no = p_gitem_no;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying item peril beneficiary information...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_witmperil_beneficiary start ======='); 
  
  OPEN witmperil_ben_cur;
  LOOP
    FETCH witmperil_ben_cur
     INTO v_item_no,        v_grouped_item_no,      v_beneficiary_no,
          v_line_cd,        v_peril_cd,             v_rec_flag,
          v_prem_rt,        v_tsi_amt,              v_prem_amt,
          v_ann_tsi_amt,    v_ann_prem_amt;

     EXIT WHEN witmperil_ben_cur%NOTFOUND;

    INSERT INTO gipi_witmperl_beneficiary
         (par_id,           item_no,                grouped_item_no, 
          beneficiary_no,   line_cd,                peril_cd,
          rec_flag,         prem_rt,                tsi_amt,
          prem_amt,         ann_tsi_amt,            ann_prem_amt
         )
    VALUES
        (p_in_copy_par_id,  v_item_no,              v_grouped_item_no, 
         v_beneficiary_no,  v_line_cd,              v_peril_cd,
         v_rec_flag,        v_prem_rt,              v_tsi_amt,
         v_prem_amt,        v_ann_tsi_amt,          v_ann_prem_amt);
  END LOOP;
  CLOSE witmperil_ben_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
END;


PROCEDURE copy_witmperl  (
        p_item_no          gipi_item.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE,
        p_in_line_cd       gipi_parlist.line_cd%TYPE
  
  ) IS
  CURSOR itmperl_cur IS
  SELECT item_no,line_cd,peril_cd,tarf_cd,prem_rt,tsi_amt,
         prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,
         discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,
         surcharge_sw, no_of_days, base_amt, aggregate_sw
    FROM gipi_witmperl
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no             gipi_witmperl.item_no%TYPE;
  v_line_cd             gipi_witmperl.line_cd%TYPE;
  v_peril_cd            gipi_witmperl.peril_cd%TYPE;
  v_tarf_cd             gipi_witmperl.tarf_cd%TYPE;
  v_prem_rt             gipi_witmperl.prem_rt%TYPE;
  v_tsi_amt             gipi_witmperl.tsi_amt%TYPE;
  v_prem_amt            gipi_witmperl.prem_amt%TYPE;
  v_ann_tsi_amt         gipi_witmperl.ann_tsi_amt%TYPE;
  v_ann_prem_amt        gipi_witmperl.ann_prem_amt%TYPE;
  v_rec_flag            gipi_witmperl.rec_flag%TYPE;  
  v_comp_rem            gipi_witmperl.comp_rem%TYPE;
  v_discount_sw         gipi_witmperl.discount_sw%TYPE;
  v_ri_comm_rate        gipi_witmperl.ri_comm_rate%TYPE;
  v_ri_comm_amt         gipi_witmperl.ri_comm_amt%TYPE;
  v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
  v_prt_flag            gipi_witmperl.prt_flag%TYPE;
  v_surcharge_sw        gipi_witmperl.surcharge_sw%TYPE;
  v_no_of_days          gipi_witmperl.no_of_days%TYPE;
  v_base_amt            gipi_witmperl.base_amt%TYPE;
  v_aggregate_sw        gipi_witmperl.aggregate_sw%TYPE;
  
BEGIN
  IF p_in_line_cd = 'SU' THEN
--     CLEAR_MESSAGE;
--     MESSAGE('Copying item peril info ...',NO_ACKNOWLEDGE);
--     SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witmperl start ======='); 
     SELECT subline_cd
       INTO v_subline_cd
       FROM gipi_wpolbas
      WHERE par_id = p_in_par_id;
     
     SELECT peril_cd
       INTO v_peril_cd
       FROM giis_peril
      WHERE line_cd     = 'SU' 
        AND peril_sname = v_subline_cd;
     
     INSERT INTO gipi_witmperl(par_id,item_no,line_cd,peril_cd,discount_sw,surcharge_sw)
     VALUES (p_in_copy_par_id,1,'SU',v_peril_cd,'N','N');
--     CLEAR_MESSAGE;
  ELSE
--     CLEAR_MESSAGE;
--     MESSAGE('Copying item peril info ...',NO_ACKNOWLEDGE);
--     SYNCHRONIZE;
     
     OPEN itmperl_cur;
     LOOP
       FETCH itmperl_cur
        INTO v_item_no,v_line_cd,v_peril_cd,v_tarf_cd,v_prem_rt,
             v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,v_rec_flag,
             v_comp_rem,v_discount_sw,v_ri_comm_rate,v_ri_comm_amt,v_prt_flag,
             v_surcharge_sw, v_no_of_days, v_base_amt, v_aggregate_sw;
        EXIT WHEN itmperl_cur%NOTFOUND;
       INSERT INTO gipi_witmperl
              (par_id,item_no,line_cd,peril_cd,tarf_cd,prem_rt,
               tsi_amt,prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,
               comp_rem,discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,
               surcharge_sw, no_of_days, base_amt, aggregate_sw)
       VALUES (p_in_copy_par_id,v_item_no,v_line_cd,v_peril_cd,v_tarf_cd,v_prem_rt,
               v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,v_rec_flag,
               v_comp_rem,v_discount_sw,v_ri_comm_rate,v_ri_comm_amt,v_prt_flag,
               v_surcharge_sw, v_no_of_days, v_base_amt, v_aggregate_sw);
     END LOOP;
     CLOSE itmperl_cur;
--     CLEAR_MESSAGE;
  END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_witmperl_grouped (
        p_item_no          gipi_witmperl_beneficiary.item_no%TYPE,
        p_gitem_no         gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS                                    
  v_item_no              gipi_witmperl_grouped.item_no%TYPE;
  v_grouped_item_no      gipi_witmperl_grouped.grouped_item_no%TYPE;
  v_line_cd              gipi_witmperl_grouped.line_cd%TYPE;
  v_peril_cd             gipi_witmperl_grouped.peril_cd%TYPE;
  v_rec_flag             gipi_witmperl_grouped.rec_flag%TYPE;
  v_no_of_days           gipi_witmperl_grouped.no_of_days%TYPE;
  v_prem_rt              gipi_witmperl_grouped.prem_rt%TYPE;
  v_tsi_amt              gipi_witmperl_grouped.tsi_amt%TYPE;
  v_prem_amt             gipi_witmperl_grouped.prem_amt%TYPE;
  v_ann_tsi_amt          gipi_witmperl_grouped.ann_tsi_amt%TYPE;
  v_ann_prem_amt         gipi_witmperl_grouped.ann_prem_amt%TYPE;  
  v_aggregate_sw         gipi_witmperl_grouped.aggregate_sw%TYPE;
  v_base_amt             gipi_witmperl_grouped.base_amt%TYPE;
  v_ri_comm_rate         gipi_witmperl_grouped.ri_comm_rate%TYPE;
  v_ri_comm_amt          gipi_witmperl_grouped.ri_comm_amt%TYPE;

  CURSOR witmperil_grp_cur IS
  SELECT item_no,
               grouped_item_no,
               line_cd,
               peril_cd,
               rec_flag,
               no_of_days,
               prem_rt,
               tsi_amt,
               prem_amt,
               ann_tsi_amt,
               ann_prem_amt,
               aggregate_sw,
               base_amt,
               ri_comm_rate,
               ri_comm_amt
    FROM gipi_witmperl_grouped
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no
     AND grouped_item_no = p_gitem_no;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying item peril group information...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_witmperl_grouped start ======='); 
  
  OPEN witmperil_grp_cur;
  LOOP
    FETCH witmperil_grp_cur
     INTO v_item_no,        v_grouped_item_no,          v_line_cd,
          v_peril_cd,       v_rec_flag,                 v_no_of_days,
          v_prem_rt,        v_tsi_amt,                  v_prem_amt,
          v_ann_tsi_amt,    v_ann_prem_amt,             v_aggregate_sw,
          v_base_amt,       v_ri_comm_rate,             v_ri_comm_amt;
     
     EXIT WHEN witmperil_grp_cur%NOTFOUND;
    
    INSERT INTO gipi_witmperl_grouped
            (par_id,            item_no,            grouped_item_no,
            line_cd,            peril_cd,           rec_flag,
            no_of_days,         prem_rt,            tsi_amt,
            prem_amt,           ann_tsi_amt,        ann_prem_amt,
            aggregate_sw,       base_amt,           ri_comm_rate,
            ri_comm_amt)
    VALUES (p_in_copy_par_id,   v_item_no,          v_grouped_item_no, 
            v_line_cd,          v_peril_cd,         v_rec_flag,
            v_no_of_days,       v_prem_rt,          v_tsi_amt,
            v_prem_amt,         v_ann_tsi_amt,      v_ann_prem_amt,
            v_aggregate_sw,     v_base_amt,         v_ri_comm_rate,
            v_ri_comm_amt);
  END LOOP;
  CLOSE witmperil_grp_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
END;

PROCEDURE copy_witmperl_pack (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_line_cd       gipi_parlist.line_cd%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
  CURSOR itmperl_cur IS
  SELECT item_no,line_cd,peril_cd,tarf_cd,prem_rt,tsi_amt,
         prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,
         discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,surcharge_sw, as_charge_sw, -- mod1 start
         no_of_days, base_amt, aggregate_sw         --mod1 end
    FROM gipi_witmperl
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no                 gipi_witmperl.item_no%TYPE;
  v_line_cd                 gipi_witmperl.line_cd%TYPE;
  v_peril_cd                gipi_witmperl.peril_cd%TYPE;
  v_tarf_cd                 gipi_witmperl.tarf_cd%TYPE;
  v_prem_rt                 gipi_witmperl.prem_rt%TYPE;
  v_tsi_amt                 gipi_witmperl.tsi_amt%TYPE;
  v_prem_amt                gipi_witmperl.prem_amt%TYPE;
  v_ann_tsi_amt             gipi_witmperl.ann_tsi_amt%TYPE;
  v_ann_prem_amt            gipi_witmperl.ann_prem_amt%TYPE;
  v_rec_flag                gipi_witmperl.rec_flag%TYPE;  
  v_comp_rem                gipi_witmperl.comp_rem%TYPE;
  v_discount_sw             gipi_witmperl.discount_sw%TYPE;
  v_ri_comm_rate            gipi_witmperl.ri_comm_rate%TYPE;
  v_ri_comm_amt             gipi_witmperl.ri_comm_amt%TYPE;
  v_subline_cd              gipi_wpolbas.subline_cd%TYPE;
  v_prt_flag                gipi_witmperl.prt_flag%TYPE;
  v_surcharge_sw            gipi_witmperl.surcharge_sw%TYPE;      
  v_as_charge_sw            gipi_witmperl.as_charge_sw%TYPE;      
  v_no_of_days              gipi_witmperl.no_of_days%TYPE;      
  v_base_amt                gipi_witmperl.base_amt%TYPE;      
  v_aggregate_sw            gipi_witmperl.aggregate_sw%TYPE;      
  
BEGIN
  IF p_in_line_cd = 'SU' THEN
--     CLEAR_MESSAGE;
--     MESSAGE('Copying item peril info ...',NO_ACKNOWLEDGE);
--     SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_witmperl_pack start ======='); 
     
     SELECT subline_cd
       INTO v_subline_cd
       FROM gipi_wpolbas
      WHERE par_id = p_in_par_id;
     SELECT peril_cd
       INTO v_peril_cd
       FROM giis_peril
      WHERE line_cd     = 'SU' 
        AND peril_sname = v_subline_cd;
     INSERT INTO gipi_witmperl(par_id,item_no,line_cd,peril_cd,discount_sw,prt_flag,surcharge_sw)
     VALUES (p_in_par_id,1,'SU',v_peril_cd,'N',v_prt_flag,'N');
--     CLEAR_MESSAGE;
  ELSE
--     CLEAR_MESSAGE;
--     MESSAGE('Copying item peril info ...',NO_ACKNOWLEDGE);
--     SYNCHRONIZE;
     OPEN itmperl_cur;
     LOOP
       FETCH itmperl_cur
        INTO v_item_no,             v_line_cd,              v_peril_cd,
             v_tarf_cd,v_prem_rt,   v_tsi_amt,              v_prem_amt,
             v_ann_tsi_amt,         v_ann_prem_amt,         v_rec_flag,
             v_comp_rem,            v_discount_sw,          v_ri_comm_rate,
             v_ri_comm_amt,         v_prt_flag,             v_surcharge_sw,     
             v_as_charge_sw,        v_no_of_days,           v_base_amt,
             v_aggregate_sw;
        
        EXIT WHEN itmperl_cur%NOTFOUND;
       
       INSERT INTO gipi_witmperl
              (par_id,              item_no,                line_cd,
              peril_cd,             tarf_cd,                prem_rt,        
              tsi_amt,              prem_amt,               ann_tsi_amt,            
              ann_prem_amt,         rec_flag,               comp_rem,               
              discount_sw,          ri_comm_rate,           ri_comm_amt,            
              prt_flag,             surcharge_sw,           as_charge_sw,           
              no_of_days,           base_amt,               aggregate_sw) 
              
       VALUES (p_in_copy_par_id,    v_item_no,              v_line_cd,
               v_peril_cd,          v_tarf_cd,              v_prem_rt,
               v_tsi_amt,           v_prem_amt,             v_ann_tsi_amt,
               v_ann_prem_amt,      v_rec_flag,             v_comp_rem,
               v_discount_sw,       v_ri_comm_rate,         v_ri_comm_amt,
               v_prt_flag,          v_surcharge_sw,         v_as_charge_sw,
               v_no_of_days,        v_base_amt,             v_aggregate_sw); 
     END LOOP;
     CLOSE itmperl_cur;
--     CLEAR_MESSAGE;
  END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wlim_liab(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE ) IS
  CURSOR lim_liab_cur IS
  SELECT line_cd,liab_cd,limit_liability,currency_cd,currency_rt
    FROM gipi_wlim_liab
   WHERE par_id  = p_in_par_id;

  v_line_cd         gipi_wlim_liab.line_cd%TYPE;
  v_liab_cd         gipi_wlim_liab.liab_cd%TYPE;
  v_limit_liab      gipi_wlim_liab.limit_liability%TYPE;
  v_currency_cd     gipi_wlim_liab.currency_cd%TYPE;
  v_currency_rt     gipi_wlim_liab.currency_rt%TYPE; 

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying limit liability info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wlim_liab start ======='); 
  OPEN  lim_liab_cur;
  LOOP
    FETCH lim_liab_cur
     INTO v_line_cd,    v_liab_cd,  v_limit_liab,   v_currency_cd,  v_currency_rt;
     EXIT WHEN lim_liab_cur%NOTFOUND;
     
    INSERT INTO gipi_wlim_liab
           (par_id,             line_cd,            liab_cd,    
            limit_liability,    currency_cd,        currency_rt)
    VALUES (p_in_copy_par_id,   v_line_cd,          v_liab_cd,
            v_limit_liab,       v_currency_cd,      v_currency_rt);
  END LOOP;
  CLOSE lim_liab_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wline (
        p_item_no           gipi_item.item_no%TYPE,
        p_item_grp          gipi_item.item_grp%TYPE,
        p_pack_line_cd      gipi_pack_line_subline.pack_line_cd%TYPE,
        p_pack_subline_cd   gipi_pack_line_subline.pack_subline_cd%TYPE,
        p_in_par_id         gipi_parlist.par_id%TYPE,
        p_in_copy_par_id    gipi_parlist.par_id%TYPE,
        
        p_copy_fire_cd      gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_motor_cd     gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_accident_cd  gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_hull_cd      gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_cargo_cd     gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_casualty_cd  gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_engrng_cd    gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_surety_cd    gipi_pack_line_subline.pack_line_cd%TYPE,
        p_copy_aviation_cd  gipi_pack_line_subline.pack_line_cd%TYPE
        
) IS
BEGIN

DBMS_OUTPUT.PUT_LINE('====== copy_wline start ======='); 
  IF p_pack_line_cd != 'SU' THEN
     copy_witmperl_pack(p_item_no,p_pack_line_cd,p_in_par_id,p_in_copy_par_id);
  END IF;

    IF p_pack_line_cd = p_copy_fire_cd THEN
     copy_wfireitm(p_item_no,p_in_par_id,p_in_copy_par_id);
  ELSIF p_pack_line_cd = p_copy_motor_cd THEN
     copy_wvehicle(p_item_no,p_in_par_id,p_in_copy_par_id);
     copy_wmcacc(p_item_no,p_in_par_id,p_in_copy_par_id);
     
  ELSIF p_pack_line_cd = p_copy_accident_cd THEN
     copy_waccident_item(p_item_no,p_in_par_id,p_in_copy_par_id);
     copy_wbeneficiary(p_item_no,p_in_par_id,p_in_copy_par_id);
     
  ELSIF p_pack_line_cd = p_copy_hull_cd THEN
     copy_witem_ves(p_item_no,p_in_par_id,p_in_copy_par_id);
     
  ELSIF p_pack_line_cd = p_copy_cargo_cd THEN
     copy_wcargo(p_item_no,p_in_par_id,p_in_copy_par_id);
     copy_wves_accumulation(p_item_no,p_in_par_id,p_in_copy_par_id);
     
  ELSIF p_pack_line_cd = p_copy_casualty_cd THEN
     copy_wcasualty_item(p_item_no,p_in_par_id,p_in_copy_par_id);
     copy_wcasualty_personnel(p_item_no,p_in_par_id,p_in_copy_par_id);
     
  ELSIF p_pack_line_cd = p_copy_engrng_cd THEN
     copy_wlocation(p_item_no,p_in_par_id,p_in_copy_par_id);
     
  ELSIF p_pack_line_cd = p_copy_surety_cd THEN
     copy_witmperl(p_item_no,p_in_par_id,p_in_copy_par_id,p_pack_line_cd);
     
  ELSIF p_pack_line_cd = p_copy_aviation_cd THEN
     copy_waviation_item(p_item_no,p_in_par_id,p_in_copy_par_id);
  END IF;

END;


PROCEDURE copy_wvehicle (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
  CURSOR vehicle_cur IS
  SELECT item_no,make,mot_type,color,plate_no,repair_lim,serial_no,motor_no,
         coc_seq_no,coc_type,assignee,model_year,coc_issue_date,coc_yy,towing,
         est_value,subline_type_cd,no_of_pass,subline_cd,acquired_from,mv_file_no,
         tariff_zone,ctv_tag,car_company_cd,color_cd,basic_color_cd,series_cd,
         make_cd,type_of_body_cd,unladen_wt,origin,destination, coc_serial_no, coc_atcn,
         motor_coverage, mv_type, mv_prem_type, tax_type 
    FROM gipi_wvehicle
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no                 gipi_wvehicle.item_no%TYPE;
  v_make                    gipi_wvehicle.make%TYPE;
  v_mot_type                gipi_wvehicle.mot_type%TYPE;
  v_color                   gipi_wvehicle.color%TYPE;
  v_plate_no                gipi_wvehicle.plate_no%TYPE;
  v_repair_lim              gipi_wvehicle.repair_lim%TYPE;
  v_serial_no               gipi_wvehicle.serial_no%TYPE;
  v_motor_no                gipi_wvehicle.motor_no%TYPE;
  v_coc_seq_no              gipi_wvehicle.coc_seq_no%TYPE;
  v_coc_type                gipi_wvehicle.coc_type%TYPE;
  v_assignee                gipi_wvehicle.assignee%TYPE;
  v_model_year              gipi_wvehicle.model_year%TYPE;
  v_coc_issue_date          gipi_wvehicle.coc_issue_date%TYPE;
  v_coc_yy                  gipi_wvehicle.coc_yy%TYPE;
  v_towing                  gipi_wvehicle.towing%TYPE;
  v_est_value               gipi_wvehicle.est_value%TYPE;
  v_subline_type_cd         gipi_wvehicle.subline_type_cd%TYPE;
  v_no_of_pass              gipi_wvehicle.no_of_pass%TYPE;
  v_subline_cd              gipi_wvehicle.subline_cd%TYPE;
  v_acquired_from           gipi_wvehicle.acquired_from%TYPE;
  v_mv_file_no              gipi_wvehicle.mv_file_no%TYPE;
  v_tariff_zone             gipi_wvehicle.tariff_zone%TYPE; 
  v_ctv_tag                 gipi_wvehicle.ctv_tag%TYPE;
  v_car_company_cd          gipi_wvehicle.car_company_cd%TYPE;
  v_color_cd                gipi_wvehicle.color_cd%TYPE;
  v_basic_color_cd          gipi_wvehicle.basic_color_cd%TYPE;
  v_series_cd               gipi_wvehicle.series_cd%TYPE;
  v_make_cd                 gipi_wvehicle.make_cd%TYPE;
  v_type_of_body_cd         gipi_wvehicle.type_of_body_cd%TYPE;
  v_unladen_wt              gipi_wvehicle.unladen_wt%TYPE;
  v_origin                  gipi_wvehicle.origin%TYPE;         
  v_destination             gipi_wvehicle.destination%TYPE;            
  v_coc_serial_no           gipi_wvehicle.coc_serial_no%TYPE;
  v_coc_actn                gipi_wvehicle.coc_atcn%TYPE;            
  v_motor_coverage          gipi_wvehicle.motor_coverage%TYPE;
  v_mv_type                 gipi_wvehicle.mv_type%TYPE;
  v_mv_prem_type            gipi_wvehicle.mv_prem_type%TYPE;
  v_tax_type                gipi_wvehicle.tax_type%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying vehicle info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wvehicle start ======='); 
  OPEN vehicle_cur;
  LOOP
    FETCH vehicle_cur
     INTO v_item_no,            v_make,             v_mot_type,
          v_color,              v_plate_no,         v_repair_lim,
          v_serial_no,          v_motor_no,         v_coc_seq_no,
          v_coc_type,           v_assignee,         v_model_year,
          v_coc_issue_date,     v_coc_yy,           v_towing,
          v_est_value,          v_subline_type_cd,  v_no_of_pass,
          v_subline_cd,         v_acquired_from,    v_mv_file_no,
          v_tariff_zone,        v_ctv_tag,          v_car_company_cd,
          v_color_cd,           v_basic_color_cd,   v_series_cd,
          v_make_cd,            v_type_of_body_cd,  v_unladen_wt,
          v_origin,             v_destination,      v_coc_serial_no,             
          v_coc_actn,           v_motor_coverage,   v_mv_type, 
          v_mv_prem_type, 		v_tax_type;     
          
    EXIT WHEN vehicle_cur%NOTFOUND;
    
    INSERT INTO gipi_wvehicle
           (par_id,             item_no,            make,
            mot_type,           color,              plate_no,
            repair_lim,         serial_no,          motor_no,
            coc_seq_no,         coc_type,           assignee,
            model_year,         coc_issue_date,     coc_yy,
            towing,             est_value,          subline_type_cd,
            no_of_pass,         subline_cd,         acquired_from,
            mv_file_no,         tariff_zone,        ctv_tag,
            car_company_cd,     color_cd,           basic_color_cd,
            series_cd,          make_cd,            type_of_body_cd,
            unladen_wt,         origin,             destination, 
            coc_serial_no,      coc_atcn,           motor_coverage,
            mv_type,            mv_prem_type, 		tax_type
           )
    VALUES (p_in_copy_par_id,   v_item_no,          v_make,
            v_mot_type,         v_color,            v_plate_no,
            v_repair_lim,       v_serial_no,        v_motor_no,
            v_coc_seq_no,       v_coc_type,         v_assignee,
            v_model_year,       v_coc_issue_date,   v_coc_yy,
            v_towing,           v_est_value,        v_subline_type_cd,
            v_no_of_pass,       v_subline_cd,       v_acquired_from,
            v_mv_file_no,       v_tariff_zone,      v_ctv_tag,
            v_car_company_cd,   v_color_cd,         v_basic_color_cd,
            v_series_cd,        v_make_cd,          v_type_of_body_cd,
            v_unladen_wt,       v_origin,           v_destination, 
            v_coc_serial_no,    v_coc_actn,         v_motor_coverage,
            v_mv_type,          v_mv_prem_type,		v_tax_type
            );
  END LOOP;
  CLOSE vehicle_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wmcacc (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR mcacc_cur IS
  SELECT item_no,accessory_cd,acc_amt, user_id, last_update, delete_sw 
    FROM gipi_wmcacc
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no             gipi_wmcacc.item_no%TYPE;
  v_accessory_cd        gipi_wmcacc.accessory_cd%TYPE;
  v_acc_amt             gipi_wmcacc.acc_amt%TYPE;
  v_user_id             gipi_wmcacc.user_id%TYPE;
  v_last_update         gipi_wmcacc.last_update%TYPE;
  v_delete_sw           gipi_wmcacc.delete_sw%TYPE;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying mc accessory info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wmcacc start ======='); 
  OPEN mcacc_cur;
  LOOP
    FETCH mcacc_cur
     INTO v_item_no, v_accessory_cd, v_acc_amt, v_user_id, v_last_update, v_delete_sw;
     EXIT WHEN mcacc_cur%NOTFOUND;
    INSERT INTO gipi_wmcacc
           (par_id,             item_no,            accessory_cd,       
           acc_amt,             user_id,            last_update,        
           delete_sw)
    VALUES (p_in_copy_par_id,   v_item_no,          v_accessory_cd,
            v_acc_amt,          v_user_id,          v_last_update,
            v_delete_sw);
  END LOOP;
  CLOSE mcacc_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wves_accumulation (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR ves_accumulation_cur IS
  SELECT vessel_cd,item_no,eta,etd,tsi_amt,rec_flag,eff_date
    FROM gipi_wves_accumulation
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_vessel_cd       gipi_wves_accumulation.vessel_cd%TYPE;
  v_item_no         gipi_wves_accumulation.item_no%TYPE;
  v_eta             gipi_wves_accumulation.eta%TYPE;
  v_etd             gipi_wves_accumulation.etd%TYPE;
  v_tsi_amt         gipi_wves_accumulation.tsi_amt%TYPE;
  v_rec_flag        gipi_wves_accumulation.rec_flag%TYPE;
  v_eff_date        gipi_wves_accumulation.eff_date%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying vessel accumulation info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wves_accumulation start ======='); 
  OPEN ves_accumulation_cur;
  LOOP
    FETCH ves_accumulation_cur
     INTO v_vessel_cd,v_item_no,v_eta,v_etd,v_tsi_amt,v_rec_flag,v_eff_date;
     EXIT WHEN ves_accumulation_cur%NOTFOUND;
     
    INSERT INTO gipi_wves_accumulation
            (par_id,            vessel_cd,          item_no,
            eta,                etd,                tsi_amt,
            rec_flag,           eff_date)
    VALUES 
            (p_in_copy_par_id,  v_vessel_cd,        v_item_no,          
            SYSDATE,            (SYSDATE + 365),    v_tsi_amt,          
            v_rec_flag,         v_eff_date);
  END LOOP;
  CLOSE ves_accumulation_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wlocation (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR location_cur IS
  SELECT item_no,region_cd,province_cd
    FROM gipi_wlocation
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;

  v_item_no                gipi_wlocation.item_no%TYPE;
  v_region_cd              gipi_wlocation.region_cd%TYPE;
  v_province_cd            gipi_wlocation.province_cd%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying location info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wlocation start ======='); 
  OPEN location_cur;
  LOOP
    FETCH location_cur
     INTO v_item_no,v_region_cd,v_province_cd;
     EXIT WHEN location_cur%NOTFOUND;
    INSERT INTO gipi_wlocation
           (par_id,             item_no,        region_cd,          province_cd)
    VALUES (p_in_copy_par_id,   v_item_no,      v_region_cd,        v_province_cd);
  END LOOP;
  CLOSE location_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wmortgagee(
        p_iss_cd           gipi_wmortgagee.iss_cd%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR mort_cur IS
  SELECT  ISS_CD, MORTG_CD, ITEM_NO, AMOUNT, REMARKS, USER_ID, 
          LAST_UPDATE, DELETE_SW
    FROM gipi_wmortgagee
   WHERE par_id  = p_in_par_id
     AND iss_cd = p_iss_cd;

 V_PAR_ID           GIPI_WMORTGAGEE.ISS_CD%TYPE; 
 V_ISS_CD           GIPI_WMORTGAGEE.ISS_CD%TYPE;      
 V_MORTG_CD         GIPI_WMORTGAGEE.MORTG_CD%TYPE;  
 V_ITEM_NO          GIPI_WMORTGAGEE.ITEM_NO%TYPE;  
 V_AMOUNT           GIPI_WMORTGAGEE.AMOUNT%TYPE;  
 V_REMARKS          GIPI_WMORTGAGEE.REMARKS%TYPE;
 V_USER_ID          GIPI_WMORTGAGEE.USER_ID%TYPE;
 V_LAST_UPDATE      GIPI_WMORTGAGEE.LAST_UPDATE%TYPE;  
 V_DELETE_SW        GIPI_WMORTGAGEE.DELETE_SW%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying Mortgagee information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wmortgagee start =======');   

  OPEN mort_cur;
  LOOP
    FETCH mort_cur
     INTO V_ISS_CD,         V_MORTG_CD,         V_ITEM_NO, 
          V_AMOUNT,         V_REMARKS,          V_USER_ID, 
          V_LAST_UPDATE,    V_DELETE_SW;        
          
    EXIT WHEN mort_cur%NOTFOUND;
    
    INSERT INTO gipi_wmortgagee
         (PAR_ID,           ISS_CD,             MORTG_CD,           
          ITEM_NO,          AMOUNT,             REMARKS,    
          USER_ID,          LAST_UPDATE,        DELETE_SW
         )
    VALUES 
         (p_in_copy_par_id, V_ISS_CD,           V_MORTG_CD, 
          V_ITEM_NO,        V_AMOUNT,           V_REMARKS,
          V_USER_ID,        V_LAST_UPDATE,      V_DELETE_SW);
  END LOOP;
  CLOSE mort_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL; 
END;

PROCEDURE copy_wopen_cargo(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR open_cargo_cur IS
  SELECT geog_cd,cargo_class_cd,rec_flag
    FROM gipi_wopen_cargo
   WHERE par_id = p_in_par_id;

  v_geog_cd               gipi_wopen_cargo.geog_cd%TYPE;
  v_cargo_class_cd        gipi_wopen_cargo.cargo_class_cd%TYPE;
  v_rec_flag              gipi_wopen_cargo.rec_flag%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying open cargo info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wopen_cargo start ======='); 
  OPEN open_cargo_cur;
  LOOP
    FETCH open_cargo_cur
     INTO v_geog_cd,v_cargo_class_cd,v_rec_flag;
     EXIT WHEN open_cargo_cur%NOTFOUND;
    INSERT INTO gipi_wopen_cargo(par_id,geog_cd,cargo_class_cd,rec_flag)
    VALUES (p_in_copy_par_id,v_geog_cd,v_cargo_class_cd,v_rec_flag);
  END LOOP;
  CLOSE open_cargo_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wopen_liab(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR open_liab_cur IS
  SELECT geog_cd,limit_liability,currency_cd,currency_rt,voy_limit,rec_flag,
         prem_tag,with_invoice_tag, multi_geog_tag
    FROM gipi_wopen_liab
   WHERE par_id = p_in_par_id;

  v_geog_cd              gipi_wopen_liab.geog_cd%TYPE;
  v_limit_liability      gipi_wopen_liab.limit_liability%TYPE;
  v_currency_cd          gipi_wopen_liab.currency_rt%TYPE;
  v_currency_rt          gipi_wopen_liab.currency_rt%TYPE;
  v_voy_limit            gipi_wopen_liab.voy_limit%TYPE;
  v_rec_flag             gipi_wopen_liab.rec_flag%TYPE;
  v_prem_tag             gipi_wopen_liab.prem_tag%TYPE;
  v_with_invoice_tag     gipi_wopen_liab.with_invoice_tag%TYPE;
  v_multi_geog_tag       gipi_wopen_liab.multi_geog_tag%TYPE;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying open liability info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wopen_liab start ======='); 
  OPEN open_liab_cur;
  LOOP
    FETCH open_liab_cur
     INTO v_geog_cd,
          v_limit_liability,
          v_currency_cd,
          v_currency_rt,
          v_voy_limit,
          v_rec_flag,
          v_prem_tag,
          v_with_invoice_tag,
          v_multi_geog_tag;
     EXIT WHEN open_liab_cur%NOTFOUND;
    INSERT INTO gipi_wopen_liab
           (par_id,             geog_cd,            limit_liability,
            currency_cd,        currency_rt,        voy_limit,
            rec_flag,           prem_tag,           with_invoice_tag,
            multi_geog_tag)
    VALUES (p_in_copy_par_id,   v_geog_cd,          v_limit_liability,
            v_currency_cd,      v_currency_rt,      v_voy_limit,
            v_rec_flag,         v_prem_tag,         v_with_invoice_tag,
            v_multi_geog_tag);
  END LOOP;
  CLOSE open_liab_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;
    
PROCEDURE copy_wopen_peril (
        p_pack_line_cd     gipi_pack_line_subline.pack_line_cd%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR open_peril_cur IS
  SELECT geog_cd,line_cd,peril_cd,rec_flag,prem_rate,remarks,with_invoice_tag
    FROM gipi_wopen_peril
   WHERE par_id = p_in_par_id;

  v_geog_cd             gipi_wopen_peril.geog_cd%TYPE;
  v_line_cd             gipi_wopen_peril.line_cd%TYPE;
  v_peril_cd            gipi_wopen_peril.peril_cd%TYPE;
  v_rec_flag            gipi_wopen_peril.rec_flag%TYPE;
  v_prem_rate           gipi_wopen_peril.prem_rate%TYPE;
  v_remarks             gipi_wopen_peril.remarks%TYPE;
  v_with_invoice_tag    gipi_wopen_peril.with_invoice_tag%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying open peril info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wopen_peril start ======='); 
  OPEN open_peril_cur;
  LOOP
    FETCH open_peril_cur
     INTO v_geog_cd,
      v_line_cd,
      v_peril_cd,
      v_rec_flag,
      v_prem_rate,
      v_remarks,
      v_with_invoice_tag;
     EXIT WHEN open_peril_cur%NOTFOUND;
    INSERT INTO gipi_wopen_peril
     (par_id,
      geog_cd,
      line_cd,
      peril_cd,
      rec_flag,
      prem_rate,
      remarks,
      with_invoice_tag)
    VALUES (p_in_copy_par_id,
      v_geog_cd,
      v_line_cd,
      v_peril_cd,
      v_rec_flag,
      v_prem_rate,
      v_remarks,
      v_with_invoice_tag);
  END LOOP;
  CLOSE open_peril_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wopen_policy(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR open_policy_cur IS
  SELECT line_cd,op_subline_cd,op_iss_cd,op_pol_seqno,decltn_no,op_issue_yy,
         eff_date, op_renew_no
    FROM gipi_wopen_policy
   WHERE par_id = p_in_par_id;

  v_line_cd             gipi_wopen_policy.line_cd%TYPE;      
  v_op_subline_cd       gipi_wopen_policy.op_subline_cd%TYPE;
  v_op_iss_cd           gipi_wopen_policy.op_iss_cd%TYPE;
  v_op_polseqno         gipi_wopen_policy.op_pol_seqno%TYPE;
  v_decltn_no           gipi_wopen_policy.decltn_no%TYPE;
  v_op_issue_yy         gipi_wopen_policy.op_issue_yy%TYPE;
  v_eff_date            gipi_wopen_policy.eff_date%TYPE;
  v_op_renew_no         gipi_wopen_policy.op_renew_no%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying open policy info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('====== copy_wopen_policy start =======');
  
  OPEN open_policy_cur;
  LOOP
    FETCH open_policy_cur
     INTO v_line_cd,            v_op_subline_cd,        v_op_iss_cd,
          v_op_polseqno,        v_decltn_no,            v_op_issue_yy,
          v_eff_date,           v_op_renew_no;
     EXIT WHEN open_policy_cur%NOTFOUND;
    INSERT INTO gipi_wopen_policy
           (par_id,             line_cd,                op_subline_cd,
           op_iss_cd,           op_pol_seqno,           decltn_no,  
           op_issue_yy,         eff_date,               op_renew_no)
           
    VALUES (p_in_copy_par_id,   v_line_cd,              v_op_subline_cd,    
           v_op_iss_cd,         v_op_polseqno,          v_decltn_no,
           v_op_issue_yy,       v_eff_date,             v_op_renew_no);
  END LOOP;
  CLOSE open_policy_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wpack_line_subline(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR pack_line_subline_cur IS
  SELECT pack_line_cd, pack_subline_cd,
         line_cd, remarks, item_tag, pack_par_id
    FROM gipi_wpack_line_subline
   WHERE par_id = p_in_par_id;
  
  v_pack_line_cd         gipi_wpack_line_subline.pack_line_cd%TYPE;
  v_pack_subline_cd      gipi_wpack_line_subline.pack_subline_cd%TYPE;
  v_line_cd              gipi_wpack_line_subline.line_cd%TYPE;
  v_remarks              gipi_wpack_line_subline.remarks%TYPE;
  v_item_tag             gipi_wpack_line_subline.item_tag%TYPE;
  v_pack_par_id          gipi_wpack_line_subline.pack_par_id%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying casualty personnel information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wpack_line_subline start ======='); 

  OPEN pack_line_subline_cur;
  LOOP
    FETCH pack_line_subline_cur
     INTO v_pack_line_cd, v_pack_subline_cd,
          v_line_cd, v_remarks, v_item_tag, v_pack_par_id;
     EXIT WHEN pack_line_subline_cur%NOTFOUND;
    INSERT INTO gipi_wpack_line_subline
          (par_id,              pack_line_cd,           pack_subline_cd,
           line_cd,             remarks,                item_tag, 
           pack_par_id)
    VALUES(p_in_copy_par_id,    v_pack_line_cd,         v_pack_subline_cd,
           v_line_cd,           v_remarks,              v_item_tag,
           v_pack_par_id);
  END LOOP;
  CLOSE pack_line_subline_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
  WHEN DUP_VAL_ON_INDEX THEN
     NULL;
END;


PROCEDURE copy_wperilds(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR perilds_cur IS
  SELECT dist_seq_no,peril_cd,line_cd,tsi_amt,prem_amt,ann_tsi_amt,dist_flag
    FROM giuw_wperilds
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id);

  v_dist_seq_no         giuw_wperilds.dist_seq_no%TYPE;
  v_peril_cd            giuw_wperilds.peril_cd%TYPE;
  v_line_cd             giuw_wperilds.line_cd%TYPE;
  v_tsi_amt             giuw_wperilds.tsi_amt%TYPE;
  v_prem_amt            giuw_wperilds.prem_amt%TYPE;
  v_ann_tsi_amt         giuw_wperilds.ann_tsi_amt%TYPE;
  v_dist_flag           giuw_wperilds.dist_flag%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy peril distribution info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wperilds start ======='); 
  OPEN perilds_cur;
  LOOP
    FETCH perilds_cur
     INTO v_dist_seq_no,v_peril_cd,v_line_cd,
          v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_dist_flag;
     EXIT WHEN perilds_cur%NOTFOUND;
    INSERT INTO giuw_wperilds
           (dist_no,            dist_seq_no,            peril_cd,
            line_cd,            tsi_amt,                prem_amt,
            ann_tsi_amt,        dist_flag)
    VALUES (p_in_copy_par_id,   v_dist_seq_no,          v_peril_cd,
            v_line_cd,          v_tsi_amt,              v_prem_amt,
            v_ann_tsi_amt,      v_dist_flag);
  END LOOP;
  CLOSE perilds_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wperilds_dtl(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_copy_dist_no     giuw_wperilds.dist_no%TYPE
  ) IS
  CURSOR perilds_dtl_cur IS
  SELECT dist_seq_no,line_cd,peril_cd,share_cd,dist_spct,
         dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp,dist_spct1
    FROM giuw_wperilds_dtl
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id)
     AND peril_cd = (SELECT peril_cd
                       FROM giuw_wperilds
                      WHERE dist_no = (SELECT dist_no
                                         FROM giuw_pol_dist
                                        WHERE par_id = p_in_par_id));

  v_dist_seq_no     giuw_wperilds_dtl.dist_seq_no%TYPE;
  v_line_cd         giuw_wperilds_dtl.line_cd%TYPE;
  v_peril_cd        giuw_wperilds_dtl.peril_cd%TYPE;
  v_share_cd        giuw_wperilds_dtl.share_cd%TYPE;
  v_dist_spct       giuw_wperilds_dtl.dist_spct%TYPE;
  v_dist_tsi        giuw_wperilds_dtl.dist_tsi%TYPE;
  v_dist_prem       giuw_wperilds_dtl.dist_prem%TYPE;
  v_ann_dist_spct   giuw_wperilds_dtl.ann_dist_spct%TYPE;
  v_ann_dist_tsi    giuw_wperilds_dtl.ann_dist_tsi%TYPE;
  v_dist_grp        giuw_wperilds_dtl.dist_grp%TYPE;
  v_dist_spct1      giuw_wperilds_dtl.dist_spct1%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy peril distribution details info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wperilds_dtl start ======='); 
  OPEN perilds_dtl_cur;
  LOOP
    FETCH perilds_dtl_cur
     INTO v_dist_seq_no,v_line_cd,v_peril_cd,v_share_cd,v_dist_spct,
          v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp,v_dist_spct1;
     EXIT WHEN perilds_dtl_cur%NOTFOUND;
    INSERT INTO giuw_wperilds_dtl
           (dist_no,dist_seq_no,line_cd,peril_cd,share_cd,dist_spct,
            dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp,dist_spct1)
    VALUES (p_copy_dist_no,v_dist_seq_no,v_line_cd,v_peril_cd,v_share_cd,v_dist_spct,
            v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp,v_dist_spct1);
  END LOOP;
  CLOSE perilds_dtl_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
   WHEN TOO_MANY_ROWS THEN
   null;
--      MSG_ALERT('TOO MANY ROWS', 'I', TRUE);
END;



PROCEDURE copy_wperil_discount (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR peril_discount_cur IS
  SELECT item_no,                       line_cd,                      peril_cd,
         sequence,                      disc_rt,                      disc_amt,
         net_gross_tag,                 discount_tag,                 level_tag,
         subline_cd,                    orig_peril_prem_amt,
         net_prem_amt,                  last_update,     
         remarks,                       orig_peril_ann_prem_amt, 
         orig_pol_ann_prem_amt,         orig_item_ann_prem_amt,
         surcharge_rt,                  surcharge_amt
    FROM gipi_wperil_discount
   WHERE par_id = p_in_par_id;

  v_item_no                   gipi_wperil_discount.item_no%TYPE;
  v_line_cd                   gipi_wperil_discount.line_cd%TYPE;
  v_peril_cd                  gipi_wperil_discount.peril_cd%TYPE;
  v_sequence                  gipi_wperil_discount.sequence%TYPE;
  v_disc_rt                   gipi_wperil_discount.disc_rt%TYPE;
  v_disc_amt                  gipi_wperil_discount.disc_amt%TYPE;
  v_net_gross_tag             gipi_wperil_discount.net_gross_tag%TYPE;
  v_discount_tag              gipi_wperil_discount.discount_tag%TYPE;
  v_level_tag                 gipi_wperil_discount.level_tag%TYPE;
  v_subline_cd                gipi_wperil_discount.subline_cd%TYPE;
  v_orig_peril_prem_amt       gipi_wperil_discount.orig_peril_prem_amt%TYPE;
  v_net_prem_amt              gipi_wperil_discount.net_prem_amt%TYPE;
  v_last_update               gipi_wperil_discount.last_update%TYPE;
  v_remarks                   gipi_wperil_discount.remarks%TYPE;
  v_orig_peril_ann_prem_amt   gipi_wperil_discount.orig_peril_ann_prem_amt%TYPE;
  v_orig_pol_ann_prem_amt     gipi_wperil_discount.orig_pol_ann_prem_amt%TYPE;
  v_orig_item_ann_prem_amt    gipi_wperil_discount.orig_item_ann_prem_amt%TYPE;
  v_surcharge_rt              gipi_wperil_discount.surcharge_rt%TYPE;
  v_surcharge_amt             gipi_wperil_discount.surcharge_amt%TYPE;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying peril discount info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wperil_discount start ======='); 
  copy_wpolbas_discount(p_in_par_id, p_in_copy_par_id);
  copy_witem_discount(p_in_par_id, p_in_copy_par_id);  
  OPEN peril_discount_cur;
  LOOP
    FETCH peril_discount_cur
     INTO v_item_no,                v_line_cd,                  v_peril_cd,
          v_sequence,               v_disc_rt,                  v_disc_amt,
          v_net_gross_tag,          v_discount_tag,             v_level_tag,
          v_subline_cd,             v_orig_peril_prem_amt,
          v_net_prem_amt,           v_last_update,         
          v_remarks,                v_orig_peril_ann_prem_amt,  
          v_orig_pol_ann_prem_amt,  v_orig_item_ann_prem_amt,   
          v_surcharge_rt,           v_surcharge_amt;
     EXIT WHEN peril_discount_cur%NOTFOUND;
    INSERT INTO gipi_wperil_discount
         (par_id,                   item_no,              line_cd,
          peril_cd,                 sequence,             disc_rt,
          disc_amt,                 net_gross_tag,        discount_tag,
          level_tag,                subline_cd,           orig_peril_prem_amt,
          net_prem_amt,             last_update,          remarks,
          orig_peril_ann_prem_amt,  orig_pol_ann_prem_amt,
          orig_item_ann_prem_amt,
          surcharge_rt,      surcharge_amt  )
    VALUES (p_in_copy_par_id,       v_item_no,            v_line_cd,
            v_peril_cd,             v_sequence,           v_disc_rt,
            v_disc_amt,             v_net_gross_tag,      v_discount_tag,
            v_level_tag,            v_subline_cd,         v_orig_peril_prem_amt,
            v_net_prem_amt,         v_last_update,        v_remarks,
            v_orig_peril_ann_prem_amt,    v_orig_pol_ann_prem_amt,
            v_orig_item_ann_prem_amt,
            v_surcharge_rt,  v_surcharge_amt  );
  END LOOP;
  CLOSE peril_discount_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wpictures (
        p_item_no          gipi_witem.item_no%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
                                      
  v_item_no                 gipi_wpictures.item_no%TYPE;
  v_file_name               gipi_wpictures.file_name%TYPE;
  v_file_type               gipi_wpictures.file_type%TYPE;
  v_file_ext                gipi_wpictures.file_ext%TYPE;
  v_remarks                 gipi_wpictures.remarks%TYPE;
  v_user_id                 gipi_wpictures.user_id%TYPE;
  v_last_update             gipi_wpictures.last_update%TYPE;
  
  CURSOR wpicture_cur IS
  SELECT item_no,
               file_name,
               file_type,
               file_ext,
               remarks,
               user_id,
               last_update
    FROM gipi_wpictures
   WHERE par_id = p_in_par_id
     AND item_no = p_item_no;
       
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying picture information...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
 DBMS_OUTPUT.PUT_LINE('====== copy_wpictures start ======='); 
  
  OPEN wpicture_cur;
  LOOP
    FETCH wpicture_cur
     INTO v_item_no,
          v_file_name,
          v_file_type,
          v_file_ext,
          v_remarks,
          v_user_id,
          v_last_update;
     EXIT WHEN wpicture_cur%NOTFOUND;
    INSERT INTO gipi_wpictures
         (par_id,
          item_no,
          file_name,
          file_type,
          file_ext,
          remarks,
          user_id,
          last_update)
    VALUES
         (p_in_copy_par_id,
         v_item_no,
         v_file_name,
         v_file_type,
         v_file_ext,
         v_remarks,
         v_user_id,
         v_last_update);
  END LOOP;
  CLOSE wpicture_cur;
--  CLEAR_MESSAGE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     NULL;
END;



PROCEDURE COPY_WPOLBAS_DISCOUNT(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR discount_cur IS
  SELECT line_cd,           subline_cd,         sequence,
         disc_rt,           disc_amt,           net_gross_tag,
         orig_prem_amt,     net_prem_amt,       last_update,     
         remarks,           surcharge_rt,       surcharge_amt         
    FROM gipi_wpolbas_discount
   WHERE par_id = p_in_par_id;

  v_line_cd             gipi_wperil_discount.line_cd%TYPE;
  v_sequence            gipi_wperil_discount.sequence%TYPE;
  v_disc_rt             gipi_wperil_discount.disc_rt%TYPE;
  v_disc_amt            gipi_wperil_discount.disc_amt%TYPE;
  v_net_gross_tag       gipi_wperil_discount.net_gross_tag%TYPE;
  v_subline_cd          gipi_wperil_discount.subline_cd%TYPE;
  v_orig_prem_amt       gipi_wpolbas_discount.orig_prem_amt%TYPE;
  v_net_prem_amt        gipi_wperil_discount.net_prem_amt%TYPE;
  v_last_update         gipi_wperil_discount.last_update%TYPE;
  v_remarks             gipi_wperil_discount.remarks%TYPE;
  v_surcharge_rt        gipi_wperil_discount.surcharge_rt%TYPE;
  v_surcharge_amt       gipi_wperil_discount.surcharge_amt%TYPE;
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying policy discount info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== COPY_WPOLBAS_DISCOUNT start ======='); 
  OPEN discount_cur;
  LOOP
    FETCH discount_cur
     INTO v_line_cd,        v_subline_cd,       v_sequence,           
          v_disc_rt,        v_disc_amt,         v_net_gross_tag,
          v_orig_prem_amt,  v_net_prem_amt,     v_last_update,      
          v_remarks,        v_surcharge_rt,     v_surcharge_amt;
     EXIT WHEN discount_cur%NOTFOUND;
    INSERT INTO gipi_wpolbas_discount
         (par_id,           line_cd,            subline_cd,            
          sequence,         disc_rt,            disc_amt,         
          net_gross_tag,    orig_prem_amt,      net_prem_amt,   
          last_update,      remarks,            surcharge_rt,     
          surcharge_amt)
    VALUES 
         (p_in_copy_par_id, v_line_cd,          v_subline_cd,    
         v_sequence,        v_disc_rt,          v_disc_amt,     
         v_net_gross_tag,   v_orig_prem_amt,    v_net_prem_amt, 
         v_last_update,     v_remarks,          v_surcharge_rt, 
         v_surcharge_amt);
  END LOOP;
  CLOSE discount_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wpolgenin(
        p_in_par_id       IN    gipi_parlist.par_id%TYPE,
        p_in_copy_par_id  IN    gipi_parlist.par_id%TYPE,
        p_copy_long       OUT   gipi_wpolgenin.gen_info%TYPE,
        p_copy_gen01      OUT   gipi_wpolgenin.gen_info01%TYPE,
        p_copy_gen02      OUT   gipi_wpolgenin.gen_info02%TYPE,
        p_copy_gen03      OUT   gipi_wpolgenin.gen_info03%TYPE,
        p_copy_gen04      OUT   gipi_wpolgenin.gen_info04%TYPE,
        p_copy_gen05      OUT   gipi_wpolgenin.gen_info05%TYPE,
        p_copy_gen06      OUT   gipi_wpolgenin.gen_info06%TYPE,
        p_copy_gen07      OUT   gipi_wpolgenin.gen_info07%TYPE,
        p_copy_gen08      OUT   gipi_wpolgenin.gen_info08%TYPE,
        p_copy_gen09      OUT   gipi_wpolgenin.gen_info09%TYPE,
        p_copy_gen10      OUT   gipi_wpolgenin.gen_info10%TYPE,
        p_copy_gen11      OUT   gipi_wpolgenin.gen_info11%TYPE,
        p_copy_gen12      OUT   gipi_wpolgenin.gen_info12%TYPE,
        p_copy_gen13      OUT   gipi_wpolgenin.gen_info13%TYPE,
        p_copy_gen14      OUT   gipi_wpolgenin.gen_info14%TYPE,
        p_copy_gen15      OUT   gipi_wpolgenin.gen_info15%TYPE,
        p_copy_gen16      OUT   gipi_wpolgenin.gen_info16%TYPE,
        p_copy_gen17      OUT   gipi_wpolgenin.gen_info17%TYPE
        
        
  ) IS
  v_first_info          gipi_wpolgenin.first_info%TYPE;
  v_agreed_tag          gipi_wpolgenin.agreed_tag%TYPE;            --mod1 start
  v_genin_info_cd       gipi_wpolgenin.genin_info_cd%TYPE;
  v_initial_info01      gipi_wpolgenin.initial_info01%TYPE;
  v_initial_info02      gipi_wpolgenin.initial_info02%TYPE;
  v_initial_info03      gipi_wpolgenin.initial_info03%TYPE;
  v_initial_info04      gipi_wpolgenin.initial_info04%TYPE;
  v_initial_info05      gipi_wpolgenin.initial_info05%TYPE;
  v_initial_info06      gipi_wpolgenin.initial_info06%TYPE;
  v_initial_info07      gipi_wpolgenin.initial_info07%TYPE;
  v_initial_info08      gipi_wpolgenin.initial_info08%TYPE;
  v_initial_info09      gipi_wpolgenin.initial_info09%TYPE;
  v_initial_info10      gipi_wpolgenin.initial_info10%TYPE;
  v_initial_info11      gipi_wpolgenin.initial_info11%TYPE;
  v_initial_info12      gipi_wpolgenin.initial_info12%TYPE;
  v_initial_info13      gipi_wpolgenin.initial_info13%TYPE;
  v_initial_info14      gipi_wpolgenin.initial_info14%TYPE;
  v_initial_info15      gipi_wpolgenin.initial_info15%TYPE;
  v_initial_info16      gipi_wpolgenin.initial_info16%TYPE;
  v_initial_info17      gipi_wpolgenin.initial_info17%TYPE;    --mod1 end
  
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying general info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;

DBMS_OUTPUT.PUT_LINE('====== copy_wpolgenin start =======');
  SELECT gen_info,   gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, 
         gen_info06, gen_info07, gen_info08, gen_info09, gen_info10, gen_info11, 
         gen_info12, gen_info13, gen_info14, gen_info15, gen_info16, gen_info17, 
         first_info, agreed_tag, genin_info_cd, initial_info01, initial_info02, 
         initial_info03, initial_info04, initial_info05, initial_info06, 
         initial_info07, initial_info08, initial_info09, initial_info10, 
         initial_info11, initial_info12, initial_info13, initial_info14, 
         initial_info15, initial_info16, initial_info17                   
    INTO p_copy_long,  p_copy_gen01, p_copy_gen02, p_copy_gen03, p_copy_gen04, 
         p_copy_gen05, p_copy_gen06, p_copy_gen07, p_copy_gen08, p_copy_gen09, 
         p_copy_gen10, p_copy_gen11, p_copy_gen12, p_copy_gen13, p_copy_gen14, 
         p_copy_gen15, p_copy_gen16, p_copy_gen17, v_first_info, v_agreed_tag, 
         v_genin_info_cd,  v_initial_info01, v_initial_info02, v_initial_info03, 
         v_initial_info04, v_initial_info05, v_initial_info06, v_initial_info07, 
         v_initial_info08, v_initial_info09, v_initial_info10, v_initial_info11, 
         v_initial_info12, v_initial_info13, v_initial_info14, v_initial_info15, 
         v_initial_info16, v_initial_info17     
    FROM gipi_wpolgenin
   WHERE par_id = p_in_par_id;
  INSERT INTO gipi_wpolgenin(par_id, gen_info, gen_info01, gen_info02, gen_info03, 
         gen_info04, gen_info05, gen_info06, gen_info07, gen_info08, gen_info09, 
         gen_info10, gen_info11, gen_info12, gen_info13, gen_info14, gen_info15, 
         gen_info16, gen_info17, first_info, user_id, last_update, agreed_tag, 
         genin_info_cd, initial_info01, initial_info02,  initial_info03, 
         initial_info04, initial_info05, initial_info06, initial_info07, 
         initial_info08, initial_info09, initial_info10, initial_info11, 
         initial_info12, initial_info13, initial_info14, initial_info15, 
         initial_info16, initial_info17) 
  VALUES (p_in_copy_par_id, p_copy_long, p_copy_gen01, p_copy_gen02, p_copy_gen03, 
         p_copy_gen04, p_copy_gen05, p_copy_gen06, p_copy_gen07, p_copy_gen08,
         p_copy_gen09, p_copy_gen10, p_copy_gen11, p_copy_gen12, p_copy_gen13, 
         p_copy_gen14, p_copy_gen15, p_copy_gen16, p_copy_gen17, v_first_info,
         USER, SYSDATE, v_agreed_tag, v_genin_info_cd, v_initial_info01,
         v_initial_info02, v_initial_info03, v_initial_info04, v_initial_info05, 
         v_initial_info06,v_initial_info07,  v_initial_info08, v_initial_info09, 
         v_initial_info10, v_initial_info11, v_initial_info12, v_initial_info13, 
         v_initial_info14, v_initial_info15, v_initial_info16, v_initial_info17);
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL; 
END;


PROCEDURE copy_wpolicyds(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_copy_dist_no     giuw_wpolicyds.dist_no%TYPE
  ) IS
  CURSOR policyds_cur IS
  SELECT dist_seq_no,
         dist_flag,
         tsi_amt,
         prem_amt,                                  
         ann_tsi_amt,
         item_grp
    FROM giuw_wpolicyds
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id);

  v_dist_seq_no     giuw_wpolicyds.dist_seq_no%TYPE;
  v_dist_flag       giuw_wpolicyds.dist_flag%TYPE;
  v_tsi_amt         giuw_wpolicyds.tsi_amt%TYPE;
  v_prem_amt        giuw_wpolicyds.prem_amt%TYPE;
  v_ann_tsi_amt     giuw_wpolicyds.ann_tsi_amt%TYPE;
  v_item_grp        giuw_wpolicyds.item_grp%TYPE;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy policy distribution info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wpolicyds start ======='); 
  OPEN policyds_cur;
  LOOP
    FETCH policyds_cur
     INTO v_dist_seq_no,
          v_dist_flag,
          v_tsi_amt,
          v_prem_amt,
          v_ann_tsi_amt,
          v_item_grp;
     EXIT WHEN policyds_cur%NOTFOUND;
     INSERT INTO giuw_wpolicyds
       (dist_no,
        dist_seq_no,
        dist_flag,
        tsi_amt,
        prem_amt,
        ann_tsi_amt,
        item_grp)
     VALUES 
       (p_copy_dist_no,
        v_dist_seq_no,
        v_dist_flag,
        v_tsi_amt,
        v_prem_amt,
        v_ann_tsi_amt,
        v_item_grp);
  END LOOP;
  CLOSE policyds_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wpolicyds_dtl(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_copy_dist_no     giuw_wpolicyds.dist_no%TYPE
  ) IS
  CURSOR policyds_dtl_cur IS
  SELECT dist_seq_no,line_cd,share_cd,dist_spct,dist_tsi,
         dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp, dist_spct1
    FROM giuw_wpolicyds_dtl
   WHERE dist_no = (SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE par_id = p_in_par_id);

  v_dist_seq_no     giuw_wpolicyds_dtl.dist_seq_no%TYPE;
  v_line_cd         giuw_wpolicyds_dtl.line_cd%TYPE;
  v_share_cd        giuw_wpolicyds_dtl.share_cd%TYPE;
  v_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
  v_dist_tsi        giuw_wpolicyds_dtl.dist_tsi%TYPE;
  v_dist_prem       giuw_wpolicyds_dtl.dist_prem%TYPE;
  v_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
  v_ann_dist_tsi    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
  v_dist_grp        giuw_wpolicyds_dtl.dist_grp%TYPE;
  v_dist_spct1      giuw_wpolicyds_dtl.dist_spct1%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copy policy distribution details info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wpolicyds_dtl start ======='); 
  OPEN policyds_dtl_cur;
  LOOP
    FETCH policyds_dtl_cur
     INTO v_dist_seq_no,v_line_cd,v_share_cd,v_dist_spct,v_dist_tsi,
          v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp,v_dist_spct1;
     EXIT WHEN policyds_dtl_cur%NOTFOUND;
    INSERT INTO giuw_wpolicyds_dtl
           (dist_no,            dist_seq_no,            line_cd,
            share_cd,           dist_spct,              dist_tsi,
            dist_prem,          ann_dist_spct,          ann_dist_tsi,
            dist_grp,           dist_spct1)
    VALUES (p_copy_dist_no,     v_dist_seq_no,          v_line_cd,
            v_share_cd,         v_dist_spct,            v_dist_tsi,
            v_dist_prem,        v_ann_dist_spct,        v_ann_dist_tsi,     
            v_dist_grp,         v_dist_spct1);
  END LOOP;
  CLOSE policyds_dtl_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_wpolnrep(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR polnrep_cur IS
  SELECT old_policy_id,new_policy_id,rec_flag,ren_rep_sw, expiry_yy, expiry_mm 
    FROM gipi_wpolnrep
   WHERE par_id = p_in_par_id;

  v_old_policy_id    gipi_wpolnrep.old_policy_id%TYPE;
  v_new_policy_id    gipi_wpolnrep.new_policy_id%TYPE;
  v_rec_flag         gipi_wpolnrep.rec_flag%TYPE;
  v_ren_rep_sw       gipi_wpolnrep.ren_rep_sw%TYPE;
  v_expiry_yy        gipi_wpolnrep.expiry_yy%TYPE;
  v_expiry_mm        gipi_wpolnrep.expiry_mm%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying pol ren/rep info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  
DBMS_OUTPUT.PUT_LINE('====== copy_wpolnrep start ======='); 
  OPEN polnrep_cur;
  LOOP
    FETCH polnrep_cur
     INTO v_old_policy_id,v_new_policy_id,v_rec_flag,v_ren_rep_sw, v_expiry_yy, v_expiry_mm;
     EXIT WHEN polnrep_cur%NOTFOUND;
    INSERT INTO gipi_wpolnrep
           (par_id,old_policy_id,new_policy_id,
            rec_flag,ren_rep_sw, user_id, last_update, expiry_yy, expiry_mm) 
    VALUES (p_in_copy_par_id,v_old_policy_id,v_new_policy_id,
            v_rec_flag,v_ren_rep_sw, user, sysdate, v_expiry_yy, v_expiry_mm); 
  END LOOP;
  CLOSE polnrep_cur;
--  CLEAR_MESSAGE;
  EXCEPTION 
    WHEN  NO_DATA_FOUND THEN
      NULL; 
END;


PROCEDURE copy_wpolwc(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  )IS
  CURSOR polwc_cur IS
  SELECT line_cd,wc_cd,swc_seq_no,print_seq_no,wc_title,wc_remarks,
         wc_text01,wc_text02,wc_text03,wc_text04,wc_text05,wc_text06,
         wc_text07,wc_text08,wc_text09,wc_text10,wc_text11,wc_text12,
         wc_text13,wc_text14,wc_text15,wc_text16,wc_text17,
         rec_flag,print_sw,change_tag, wc_title2 
    FROM gipi_wpolwc
   WHERE par_id = p_in_par_id;
  v_line_cd             gipi_wpolwc.line_cd%TYPE;
  v_wc_cd               gipi_wpolwc.wc_cd%TYPE;
  v_swc_seq_no          gipi_wpolwc.swc_seq_no%TYPE;
  v_print_seq_no        gipi_wpolwc.print_seq_no%TYPE;
  v_wc_title            gipi_wpolwc.wc_title%TYPE;
  v_wc_remarks          gipi_wpolwc.wc_remarks%TYPE;
  v_rec_flag            gipi_wpolwc.rec_flag%TYPE;
  v_wc_text01           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text02           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text03           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text04           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text05           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text06           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text07           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text08           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text09           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text10           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text11           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text12           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text13           gipi_wpolwc.wc_text01%TYPE;
  v_wc_text14           gipi_wpolwc.wc_text14%TYPE;
  v_wc_text15           gipi_wpolwc.wc_text15%TYPE;
  v_wc_text16           gipi_wpolwc.wc_text16%TYPE;
  v_wc_text17           gipi_wpolwc.wc_text17%TYPE;
  v_print_sw            gipi_wpolwc.print_sw%TYPE;
  v_change_tag          gipi_wpolwc.change_tag%TYPE;
  v_wc_title2           gipi_wpolwc.wc_title2%TYPE;            
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying warranties and clauses info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
 DBMS_OUTPUT.PUT_LINE('====== copy_wpolwc start ======='); 
  OPEN polwc_cur;
  LOOP
    FETCH polwc_cur
     INTO v_line_cd,v_wc_cd,v_swc_seq_no,v_print_seq_no,
          v_wc_title,v_wc_remarks,
          v_wc_text01,v_wc_text02,v_wc_text03,v_wc_text04,v_wc_text05,v_wc_text06,
          v_wc_text07,v_wc_text08,v_wc_text09,v_wc_text10,v_wc_text11,v_wc_text12,
          v_wc_text13,v_wc_text14,v_wc_text15,v_wc_text16,v_wc_text17,
          v_rec_flag,v_print_sw,v_change_tag, v_wc_title2;
     EXIT WHEN polwc_cur%NOTFOUND;
    INSERT INTO gipi_wpolwc
          (par_id,line_cd,wc_cd,swc_seq_no,print_seq_no,
           wc_title,wc_remarks,
           wc_text01,wc_text02,wc_text03,wc_text04,wc_text05,wc_text06,
           wc_text07,wc_text08,wc_text09,wc_text10,wc_text11,wc_text12,
           wc_text13,wc_text14,wc_text15,wc_text16,wc_text17, 
           rec_flag,print_sw,change_tag, wc_title2)
    VALUES (p_in_copy_par_id,v_line_cd,v_wc_cd,v_swc_seq_no,v_print_seq_no,
            v_wc_title,v_wc_remarks,
            v_wc_text01,v_wc_text02,v_wc_text03,v_wc_text04,v_wc_text05,v_wc_text06,
            v_wc_text07,v_wc_text08,v_wc_text09,v_wc_text10,v_wc_text11,v_wc_text12,
            v_wc_text13,v_wc_text14,v_wc_text15,v_wc_text16,v_wc_text17,            
            v_rec_flag,v_print_sw,v_change_tag, v_wc_title2);
  END LOOP;
  CLOSE polwc_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wprincipal(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR principal_cur IS
  SELECT principal_cd,subcon_sw, engg_basic_infonum
    FROM gipi_wprincipal
   WHERE par_id = p_in_par_id;

  v_principal_cd            gipi_wprincipal.principal_cd%TYPE;
  v_engg_basic_infonum      gipi_wprincipal.engg_basic_infonum%TYPE;
  v_subcon_sw               gipi_wprincipal.subcon_sw%TYPE;
    
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying principal info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wprincipal start ======='); 
  OPEN principal_cur;
  LOOP
    FETCH principal_cur
     INTO v_principal_cd,v_subcon_sw,v_engg_basic_infonum;
     EXIT WHEN principal_cur%NOTFOUND;
    INSERT INTO gipi_wprincipal(par_id,principal_cd,subcon_sw,engg_basic_infonum)
    VALUES (p_in_copy_par_id,v_principal_cd,v_subcon_sw,v_engg_basic_infonum);
  END LOOP;
  CLOSE principal_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_wves_air(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE
  ) IS
  CURSOR ves_air_cur IS
  SELECT vessel_cd,vescon,voy_limit,rec_flag
    FROM gipi_wves_air
   WHERE par_id = p_in_par_id;

  v_vessel_cd          gipi_wves_air.vessel_cd%TYPE;
  v_vescon             gipi_wves_air.vescon%TYPE;
  v_voy_limit          gipi_wves_air.voy_limit%TYPE;
  v_rec_flag           gipi_wves_air.rec_flag%TYPE;

BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying vessel air info ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
DBMS_OUTPUT.PUT_LINE('====== copy_wves_air start ======='); 
  OPEN ves_air_cur;
  LOOP
    FETCH ves_air_cur
     INTO v_vessel_cd,v_vescon,v_voy_limit,v_rec_flag;
     EXIT WHEN ves_air_cur%NOTFOUND;
    INSERT INTO gipi_wves_air(par_id,vessel_cd,vescon,voy_limit,rec_flag)
    VALUES (p_in_copy_par_id,v_vessel_cd,v_vescon,v_voy_limit,v_rec_flag);
  END LOOP;
  CLOSE ves_air_cur;
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;



PROCEDURE copy_wpolbas(
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE,
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_iss_cd        gipi_parlist.iss_cd%TYPE,
        p_in_iss_cd2       gipi_parlist.iss_cd%TYPE
  ) IS
  v_line_cd                 gipi_wpolbas.line_cd%TYPE;
  v_iss_cd                  gipi_wpolbas.iss_cd%TYPE;
  v_subline_cd              gipi_wpolbas.subline_cd%TYPE;
  v_issue_yy                gipi_wpolbas.issue_yy%TYPE;
  v_pol_seq_no              gipi_wpolbas.pol_seq_no%TYPE;
  v_endt_iss_cd             gipi_wpolbas.endt_iss_cd%TYPE;
  v_endt_yy                 gipi_wpolbas.endt_yy%TYPE;
  v_endt_seq_no             gipi_wpolbas.endt_seq_no%TYPE;
  v_renew_no                gipi_wpolbas.renew_no%TYPE;
  v_endt_type               gipi_wpolbas.endt_type%TYPE;
  v_incept_date             gipi_wpolbas.incept_date%TYPE;
  v_expiry_date             gipi_wpolbas.expiry_date%TYPE;
  v_eff_date                gipi_wpolbas.eff_date%TYPE;
  v_issue_date              gipi_wpolbas.issue_date%TYPE;
  v_pol_flag                gipi_wpolbas.pol_flag%TYPE;
  v_foreign_acc_sw          gipi_wpolbas.foreign_acc_sw%TYPE;
  v_assd_no                 gipi_wpolbas.assd_no%TYPE;
  v_designation             gipi_wpolbas.designation%TYPE;
  v_address1                gipi_wpolbas.address1%TYPE;
  v_address2                gipi_wpolbas.address2%TYPE;
  v_address3                gipi_wpolbas.address3%TYPE;
  v_mortg_name              gipi_wpolbas.mortg_name%TYPE; 
  v_tsi_amt                 gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt                gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt             gipi_wpolbas.ann_tsi_amt%TYPE;
  v_ann_prem_amt            gipi_wpolbas.ann_prem_amt%TYPE;
  v_invoice_sw              gipi_wpolbas.invoice_sw%TYPE;
  v_pool_pol_no             gipi_wpolbas.pool_pol_no%TYPE;
  v_user_id                 gipi_wpolbas.user_id%TYPE;
  v_quotation_printed_sw    gipi_wpolbas.quotation_printed_sw%TYPE;    
  v_covernote_printed_sw    gipi_wpolbas.covernote_printed_sw%TYPE;
  v_orig_policy_id          gipi_wpolbas.orig_policy_id%TYPE;
  v_endt_expiry_date        gipi_wpolbas.endt_expiry_date%TYPE;
  v_no_of_items             gipi_wpolbas.no_of_items%TYPE;
  v_subline_type_cd         gipi_wpolbas.subline_type_cd%TYPE;
  v_auto_renew_flag         gipi_wpolbas.auto_renew_flag%TYPE;
  v_prorate_flag            gipi_wpolbas.prorate_flag%TYPE;
  v_short_rt_percent        gipi_wpolbas.short_rt_percent%TYPE;
  v_prov_prem_tag           gipi_wpolbas.prov_prem_tag%TYPE;
  v_type_cd                 gipi_wpolbas.type_cd%TYPE;
  v_acct_of_cd              gipi_wpolbas.acct_of_cd%TYPE;
  v_prov_prem_pct           gipi_wpolbas.prov_prem_pct%TYPE;
  v_same_polno_sw           gipi_wpolbas.same_polno_sw%TYPE;
  v_pack_pol_flag           gipi_wpolbas.pack_pol_flag%TYPE;
  v_expiry_tag              gipi_wpolbas.expiry_tag%TYPE;
  v_prem_warr_tag           gipi_wpolbas.prem_warr_tag%TYPE;  
  v_ref_pol_no              gipi_wpolbas.ref_pol_no%TYPE;  
  v_ref_open_pol_no         gipi_wpolbas.ref_open_pol_no%TYPE;  
  v_reg_policy_sw           gipi_wpolbas.reg_policy_sw%TYPE;  
  v_co_insurance_sw         gipi_wpolbas.co_insurance_sw%TYPE;  
  v_discount_sw             gipi_wpolbas.discount_sw%TYPE;  
  v_fleet_print_tag         gipi_wpolbas.fleet_print_tag%TYPE;
  v_incept_tag              gipi_wpolbas.incept_tag%TYPE;
  v_comp_sw                 gipi_wpolbas.comp_sw%TYPE;
  v_manual_renew_no         gipi_wpolbas.manual_renew_no%TYPE;                   
  v_with_tariff_sw          gipi_wpolbas.with_tariff_sw%TYPE; 
  v_place_cd                gipi_wpolbas.place_cd%TYPE;
  v_surcharge_sw            gipi_wpolbas.surcharge_sw%TYPE;
  v_validate_tag            gipi_wpolbas.validate_tag%TYPE;
  v_industry_cd             gipi_wpolbas.industry_cd%TYPE;
  v_region_cd               gipi_wpolbas.region_cd%TYPE;
  v_cred_branch             gipi_wpolbas.cred_branch%TYPE;
  v_booking_mth             gipi_wpolbas.booking_mth%TYPE;
  v_booking_year            gipi_wpolbas.booking_year%TYPE;
  var_vdate                 giis_parameters.param_value_n%TYPE;
  v_endt_expiry_tag         gipi_wpolbas.endt_expiry_tag%TYPE;
  v_cover_nt_printed_date   gipi_wpolbas.cover_nt_printed_date%TYPE;
  v_cover_nt_printed_cnt    gipi_wpolbas.cover_nt_printed_cnt%TYPE;
  v_back_stat               gipi_wpolbas.back_stat%TYPE;
  v_qd_flag                 gipi_wpolbas.qd_flag%TYPE;
  v_acct_of_cd_sw           gipi_wpolbas.acct_of_cd_sw%TYPE;
  v_old_assd_no             gipi_wpolbas.old_assd_no%TYPE;
  v_cancel_date             gipi_wpolbas.cancel_date%TYPE;
  v_label_tag               gipi_wpolbas.label_tag%TYPE;
  v_old_address1            gipi_wpolbas.old_address1%TYPE;
  v_old_address2            gipi_wpolbas.old_address2%TYPE;
  v_old_address3            gipi_wpolbas.old_address3%TYPE;
  v_risk_tag                gipi_wpolbas.risk_tag%TYPE;
  v_pack_par_id             gipi_wpolbas.pack_par_id%TYPE;
  v_survey_agent_cd         gipi_wpolbas.survey_agent_cd%TYPE;
  v_settling_agent_cd       gipi_wpolbas.settling_agent_cd%TYPE;
  v_plan_cd                 gipi_wpolbas.plan_cd%TYPE; --added by gab 09.22.2015
  v_plan_sw                 gipi_wpolbas.plan_sw%TYPE; --added by gab 09.22.2015
  
    -- longterm --
  v_prem_warr_days          gipi_wpolbas.prem_warr_days%TYPE;
  v_takeup_term             gipi_wpolbas.takeup_term%TYPE;
  v_policy_days             NUMBER;
BEGIN
--  CLEAR_MESSAGE;
--  MESSAGE('Copying basic information ...',NO_ACKNOWLEDGE);
--  SYNCHRONIZE;
  DBMS_OUTPUT.PUT_LINE('copy_wpolbas'); 
  
  SELECT  line_cd, iss_cd,subline_cd, issue_yy, pol_seq_no,        
          endt_iss_cd, endt_yy, endt_seq_no, renew_no, endt_type,
          incept_date, expiry_date,  issue_date, eff_date,
          pol_flag, foreign_acc_sw, assd_no, designation,
          address1, address2, address3, decode(p_in_iss_cd,p_in_iss_cd2,mortg_name,null) mortg_name,
          tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,   
          invoice_sw, pool_pol_no, quotation_printed_sw,
          covernote_printed_sw, orig_policy_id, endt_expiry_date,  
          no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
          short_rt_percent,prov_prem_tag, type_cd, acct_of_cd,   
          prov_prem_pct, same_polno_sw, pack_pol_flag, expiry_tag,
          prem_warr_tag, ref_pol_no,
          ref_open_pol_no,reg_policy_sw,co_insurance_sw, discount_sw,
          fleet_print_tag, incept_tag, comp_sw, manual_renew_no, with_tariff_sw,
          place_cd, surcharge_sw, validate_tag, industry_cd, region_cd, cred_branch, 
          endt_expiry_tag, cover_nt_printed_date, cover_nt_printed_cnt, back_stat,
          qd_flag, acct_of_cd_sw, old_assd_no, cancel_date, label_tag, old_address1, 
          old_address2, old_address3, risk_tag, pack_par_id, survey_agent_cd, 
          settling_agent_cd, PREM_WARR_DAYS, TAKEUP_TERM
          , plan_cd, plan_sw -- added by gab 09.22.2015
    INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no,        
          v_endt_iss_cd, v_endt_yy, v_endt_seq_no, v_renew_no, v_endt_type,
          v_incept_date,v_expiry_date,v_issue_date, v_eff_date,
          v_pol_flag, v_foreign_acc_sw, v_assd_no, v_designation,
          v_address1, v_address2, v_address3, v_mortg_name,
          v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,   
          v_invoice_sw, v_pool_pol_no, v_quotation_printed_sw, v_covernote_printed_sw, 
          v_orig_policy_id, v_endt_expiry_date,  
          v_no_of_items, v_subline_type_cd, v_auto_renew_flag, v_prorate_flag,
          v_short_rt_percent,v_prov_prem_tag, v_type_cd, v_acct_of_cd,   
          v_prov_prem_pct, v_same_polno_sw, v_pack_pol_flag, v_expiry_tag,
          v_prem_warr_tag, v_ref_pol_no,
          v_ref_open_pol_no,v_reg_policy_sw,v_co_insurance_sw, v_discount_sw,
          v_fleet_print_tag, v_incept_tag, v_comp_sw, v_manual_renew_no, v_with_tariff_sw, 
          v_place_cd, v_surcharge_sw, v_validate_tag, v_industry_cd, v_region_cd, 
          v_cred_branch, v_endt_expiry_tag, v_cover_nt_printed_date, v_cover_nt_printed_cnt,
          v_back_stat, v_qd_flag, v_acct_of_cd_sw, v_old_assd_no, v_cancel_date, v_label_tag, 
          v_old_address1, v_old_address2, v_old_address3, v_risk_tag, v_pack_par_id, 
          v_survey_agent_cd, v_settling_agent_cd,
          v_PREM_WARR_DAYS, v_TAKEUP_TERM
          , v_plan_cd, v_plan_sw -- added by gab 09.22.2015
          
    FROM gipi_wpolbas
   WHERE par_id  = p_in_par_id;
   
  IF TRUNC(v_expiry_date - v_incept_date) = 31 THEN
    v_policy_days      := 30;
  ELSE
         v_policy_days      := TRUNC(v_expiry_date - v_incept_date);
  END IF; 
  --Added by iRiS BorDey 04.28.03
  --To initialize booking month and booking year.           
  --Modified by Grace 05.08.03
  --Add checking of parameter for the basis of booking date
  FOR C IN (SELECT param_value_n
                          FROM giac_parameters
                         WHERE param_name = 'PROD_TAKE_UP')
  LOOP
       var_vdate := c.param_value_n;
    END LOOP;                        
  IF var_vdate > 3 THEN
        null;
       --msg_alert('The parameter value ('||to_char(var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.', 'I', FALSE);
       --exit_form;        
  END IF;        
  IF var_vdate = 1 OR
         (var_vdate = 3 AND v_issue_date > v_incept_date) THEN
         FOR C IN (SELECT booking_year,
                                  to_char(to_date('01-'||substr(booking_mth,1, 3)||booking_year, 'DD-MONYYYY'), 'MM'), booking_mth
                      FROM giis_booking_month
                  WHERE (nvl(booked_tag, 'N') != 'Y')
                    AND (booking_year > to_number(to_char(v_issue_date, 'YYYY'))
                          OR (booking_year = to_number(to_char(v_issue_date, 'YYYY'))
                         AND to_number(to_char(to_date('01-'||substr(booking_mth,1, 3)||booking_year, 'DD-MONYYYY'), 'MM'))>= to_number(to_char(v_issue_date, 'MM'))))
                  ORDER BY 1, 2 ) LOOP
         v_booking_year := to_number(c.booking_year);       
         v_booking_mth  := c.booking_mth;              
         EXIT;
       END LOOP;                     
  ELSIF var_vdate = 2 OR
     (var_vdate = 3 AND v_issue_date <= v_incept_date) THEN
         FOR C IN (SELECT booking_year, 
                                    to_char(to_date('01-'||substr(booking_mth,1, 3)|| 
                                    booking_year, 'DD-MON-RRRR'), 'MM'), booking_mth
                   FROM giis_booking_month
                  WHERE (nvl(booked_tag, 'N') <> 'Y')
                    AND (booking_year > to_number(to_char(v_incept_date, 'YYYY'))
                     OR (booking_year = to_number(to_char(v_incept_date, 'YYYY'))
                       AND to_number(to_char(to_date('01-'||substr(booking_mth,1, 3)|| 
                           booking_year, 'DD-MON-RRRR'), 'MM'))>= to_number(to_char(v_incept_date, 'MM'))))
                  ORDER BY 1, 2 ) LOOP
         v_booking_year := to_number(c.booking_year);       
         v_booking_mth  := c.booking_mth;              
         EXIT;
       END LOOP;                     
  END IF; 
  INSERT INTO gipi_wpolbas
         (par_id, line_cd, iss_cd,subline_cd, issue_yy, pol_seq_no,        
          endt_iss_cd,endt_yy, endt_seq_no, renew_no, endt_type,
          incept_date, expiry_date, eff_date, issue_date, booking_year, booking_mth,
          pol_flag, foreign_acc_sw, assd_no, designation,
          address1, address2, address3, mortg_name,
          tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,   
          invoice_sw, pool_pol_no, user_id, quotation_printed_sw,covernote_printed_sw,
          orig_policy_id, endt_expiry_date,  
          no_of_items, subline_type_cd, auto_renew_flag,prorate_flag,
          short_rt_percent,prov_prem_tag, type_cd, acct_of_cd,   
          prov_prem_pct, same_polno_sw, pack_pol_flag,  expiry_tag,
          prem_warr_tag, --ref_pol_no,
          ref_open_pol_no,reg_policy_sw,co_insurance_sw, discount_sw,
          fleet_print_tag, incept_tag, comp_sw, manual_renew_no, with_tariff_sw, 
          place_cd, surcharge_sw, validate_tag, industry_cd, region_cd, cred_branch, 
          endt_expiry_tag, cover_nt_printed_date, cover_nt_printed_cnt, back_stat, qd_flag, --mod1 start
          acct_of_cd_sw, old_assd_no, cancel_date, label_tag, old_address1, old_address2, 
          old_address3, risk_tag, pack_par_id, survey_agent_cd, settling_agent_cd,--mod1 end
          plan_cd, plan_sw, -- added by gab 09.22.2015
          -- longterm --
          prem_warr_days, takeup_term
          )        
  VALUES (p_in_copy_par_id,  v_line_cd, v_iss_cd, v_subline_cd, /*v_issue_yy*/TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'YYYY'),3,2)), v_pol_seq_no,        
         v_endt_iss_cd, v_endt_yy, v_endt_seq_no, v_renew_no, v_endt_type,        
         sysdate,/*add_months(sysdate,12) longterm comment*/sysdate + v_policy_days,sysdate,sysdate, v_booking_year, v_booking_mth,
         '1', v_foreign_acc_sw, v_assd_no, v_designation,
         v_address1, v_address2, v_address3, v_mortg_name,
         v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,   
         v_invoice_sw, v_pool_pol_no,p_in_user_id,'N','N',
         v_orig_policy_id, v_endt_expiry_date,  
         v_no_of_items, v_subline_type_cd, v_auto_renew_flag, v_prorate_flag,
         v_short_rt_percent,v_prov_prem_tag, v_type_cd, v_acct_of_cd,   
         v_prov_prem_pct, v_same_polno_sw, v_pack_pol_flag, v_expiry_tag,
         v_prem_warr_tag, --v_ref_pol_no,
         v_ref_open_pol_no,v_reg_policy_sw,v_co_insurance_sw, v_discount_sw,
         v_fleet_print_tag, v_incept_tag, v_comp_sw, v_manual_renew_no, 
         v_with_tariff_sw, v_place_cd, v_surcharge_sw, v_validate_tag, v_industry_cd, 
         v_region_cd, v_cred_branch, v_endt_expiry_tag, v_cover_nt_printed_date,  -- mod1 start
         v_cover_nt_printed_cnt, v_back_stat, v_qd_flag, v_acct_of_cd_sw, v_old_assd_no, 
         v_cancel_date, v_label_tag, v_old_address1, v_old_address2, v_old_address3, 
         v_risk_tag, v_pack_par_id, v_survey_agent_cd, v_settling_agent_cd,            --mod1 end
         v_plan_cd, v_plan_sw, -- added by gab 09.22.2015
         -- longterm --
         v_prem_warr_days, v_takeup_term);
--  CLEAR_MESSAGE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL; 
END;


FUNCTION get_lov_giuts007 (
            p_line_cd       gipi_parlist.line_cd%TYPE,
            p_iss_cd        gipi_parlist.iss_cd%TYPE,
            p_par_yy        gipi_parlist.par_yy%TYPE
   )
    RETURN par_list_lov_giuts007_tab PIPELINED 
    IS
    v_rec    par_list_lov_giuts007_type;
   BEGIN
      FOR i IN(SELECT line_cd, iss_cd, par_yy, par_seq_no 
                 FROM gipi_parlist
                WHERE line_cd = NVL(p_line_cd, line_cd)
                  AND iss_cd = NVL(p_iss_cd, iss_cd)
                  AND par_yy = NVL(p_par_yy, par_yy) 
                  AND pack_par_id IS NULL   --added by jeffdojello 04.24.2013 to exclude par under a package. SR-12782 Note No. 30969
                  AND par_status /*!=*/NOT IN(10,98,99) -- added by gab 09.04.2015, modified by pjsantos 11/8/2016,posted, deleted and cancelled par's should not be included GENQA 5819.
                  AND par_type != 'E' -- added by gab 09.04.2015
             ORDER BY 1,2,3,4    
      )
      LOOP
        v_rec.line_cd       := i.line_cd;
        v_rec.iss_cd        := i.iss_cd;
        v_rec.par_yy        := i.par_yy;
        v_rec.par_seq_no    := i.par_seq_no;
        PIPE ROW(v_rec);
      END LOOP;  
   
   END;

    FUNCTION get_par_status (
        p_line_cd       GIPI_PARLIST.line_cd%TYPE,
        p_iss_cd        GIPI_PARLIST.iss_cd%TYPE,
        p_par_yy        GIPI_PARLIST.par_yy%TYPE,
        p_par_seq_no    GIPI_PARLIST.par_seq_no%TYPE,
        p_quote_seq_no  GIPI_PARLIST.quote_seq_no%TYPE
        
   ) RETURN gipi_parlist_tab PIPELINED IS
   p_par   gipi_parlist_type;
   v_is_pack  VARCHAR2(2); --jeffdojello 04.24.2013
   BEGIN
   FOR i IN (SELECT 
                    par_id,
                    par_status,
                    par_type,
                    NVL(pack_par_id, 0) pack_par_id --jeffdojello 04.24.2013
               FROM gipi_parlist
              WHERE line_cd      = p_line_cd 
                AND iss_cd       = p_iss_cd
                AND par_yy       = p_par_yy 
                AND par_seq_no   = p_par_seq_no
                AND quote_seq_no = p_quote_seq_no
        ) 
        LOOP
           --added by jeffdojello 04.24.2013 to check if par is under a package.
           IF i.pack_par_id = 0 THEN
            v_is_pack := 'N';
           ELSE
            v_is_pack := 'Y';
           END IF;
           --
           p_par.par_id         := i.par_id;
           p_par.par_status     := i.par_status;
           p_par.par_type       := i.par_type;
           p_par.is_pack        := v_is_pack;  --added by jeffdojello 04.24.2013 to check if par is under a package. SR-12782 Note No. 30969
           
           PIPE ROW(p_par);
        END LOOP;
        
   END; 
   
   PROCEDURE copy_par_to_par(
        p_in_par_id      IN gipi_parlist.par_id%TYPE,
        p_in_user_id     IN gipi_parlist.underwriter%TYPE,
        p_in_iss_cd_2    IN gipi_parlist.iss_cd%TYPE,
        p_in_var_line_cd IN gipi_parlist.line_cd%TYPE,
        p_out_new_par    OUT VARCHAR2,
        p_out_old_par    OUT VARCHAR2
   )
   IS
   v_line_cd        gipi_parlist.line_cd%TYPE;
   v_iss_cd         gipi_parlist.iss_cd%TYPE;
   v_par_yy         gipi_parlist.par_yy%TYPE; 
   v_par_seq_no     gipi_parlist.par_seq_no%TYPE;
   v_quote_seq_no   gipi_parlist.quote_seq_no%TYPE;
   v_new_par        VARCHAR2(1000);
   v_old_par        VARCHAR2(1000);
   v_copy_par_id    gipi_parlist.par_id%TYPE;
   
   v_line_cd_old    gipi_parlist.line_cd%TYPE;
   v_iss_cd_old     gipi_parlist.iss_cd%TYPE;
   v_par_yy_old     gipi_parlist.par_yy%TYPE; 
   v_par_seq_no_old gipi_parlist.par_seq_no%TYPE;
   v_quote_seq_no_o gipi_parlist.quote_seq_no%TYPE;
   
   BEGIN
   
    copy_parlist(p_in_par_id, p_in_user_id, p_in_iss_cd_2, v_copy_par_id, p_in_var_line_cd);
    DBMS_OUTPUT.PUT_LINE('copy_wpolbas'); 
    update_parhist(p_in_user_id, p_in_par_id, v_copy_par_id);
    
    UPDATE gipi_parlist
        SET iss_cd = p_in_iss_cd_2,
            par_yy = TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2))
      WHERE par_id = v_copy_par_id;
    COMMIT;
    
    SELECT line_cd,
           iss_cd,
           par_yy,
           par_seq_no,
           quote_seq_no
      INTO v_line_cd_old,
           v_iss_cd_old,
           v_par_yy_old,
           v_par_seq_no_old,
           v_quote_seq_no_o
      FROM gipi_parlist
     WHERE par_id = p_in_par_id; 
    
    SELECT line_cd,
           iss_cd,
           par_yy,
           par_seq_no,
           quote_seq_no
      INTO v_line_cd,
           v_iss_cd,
           v_par_yy,
           v_par_seq_no,
           v_quote_seq_no
      FROM gipi_parlist
     WHERE par_id = v_copy_par_id;
     --WHERE par_id = p_in_par_id;
     
      IF v_par_yy <  10 THEN
         v_new_par :=(v_line_cd|| ' - ' || v_iss_cd || ' - 0' ||
           TO_CHAR(v_par_yy) || ' - '|| LTRIM(TO_CHAR(v_par_seq_no,'099999')) ||
           ' - ' || LTRIM(TO_CHAR(v_quote_seq_no,'09')));

      ELSE            
         v_new_par :=(v_line_cd|| ' - ' || v_iss_cd || ' - ' ||
           TO_CHAR(v_par_yy) || ' - '|| LTRIM(TO_CHAR(v_par_seq_no,'099999')) ||
           ' - ' || LTRIM(TO_CHAR(v_quote_seq_no,'09')));

      END IF;            
       
      IF v_par_yy < 10 THEN            
         v_old_par := (v_line_cd_old|| ' - ' || v_iss_cd_old || ' - 0' ||
           TO_CHAR(v_par_yy_old) || ' - '|| LTRIM(TO_CHAR(v_par_seq_no_old,'099999')) ||
           ' - ' || LTRIM(TO_CHAR(v_quote_seq_no_o,'09'))) ;
   
      ELSE
         v_old_par := (v_line_cd_old|| ' - ' || v_iss_cd_old || ' - ' ||
           TO_CHAR(v_par_yy_old) || ' - '|| LTRIM(TO_CHAR(v_par_seq_no_old,'099999')) ||
           ' - ' || LTRIM(TO_CHAR(v_quote_seq_no_o,'09'))) ;

      END IF;
      p_out_new_par := v_new_par;
      p_out_old_par := v_old_par;
      
   END;
   
  PROCEDURE update_parhist(
        p_in_user_id       gipi_parlist.underwriter%TYPE,
        p_in_par_id        gipi_parlist.par_id%TYPE,
        p_in_copy_par_id   gipi_parlist.par_id%TYPE) 
  IS
  
    CURSOR parhist_cur IS
    SELECT user_id,parstat_date,entry_source,parstat_cd
      FROM gipi_parhist
     WHERE par_id = p_in_par_id;

    v_parstat_date	    DATE;
    v_date_cgu          DATE;  --added rmanalad 8/9/2012
    v_user_id		    gipi_parhist.user_id%TYPE;
    v_entry_source	    gipi_parhist.entry_source%TYPE;
    v_parstat_cd		gipi_parhist.parstat_cd%TYPE;

   BEGIN   
   DBMS_OUTPUT.PUT_LINE('********update_parhist***********'); 
--    CLEAR_MESSAGE;
--    MESSAGE('Updating PAR history ...',NO_ACKNOWLEDGE);
--    SYNCHRONIZE;
    OPEN parhist_cur;
    v_date_cgu := SYSDATE;
    LOOP
    FETCH parhist_cur
      INTO v_user_id,v_parstat_date,v_entry_source,v_parstat_cd;
      EXIT WHEN parhist_cur%NOTFOUND;
        IF v_parstat_cd = '3' THEN
        
          IF v_parstat_date = SYSDATE THEN
             v_date_cgu := SYSDATE + (1/1440);
             INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
             VALUES (p_in_copy_par_id, p_in_user_id,v_date_cgu,'DB','1');
          ELSE
             INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
             VALUES (p_in_copy_par_id,p_in_user_id,v_date_cgu,'DB','1');
          END IF; 
          
        ELSIF
            v_parstat_cd = '1' OR
            v_parstat_cd = '2' THEN
            INSERT INTO gipi_parhist(par_id,user_id,parstat_date,entry_source,parstat_cd)
            VALUES (p_in_copy_par_id,v_user_id,v_parstat_date,'DB','1');
        END IF;
    END LOOP;  
    CLOSE parhist_cur;
--    CLEAR_MESSAGE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        NULL;
  END;


 FUNCTION ck_user_per_ln_giuts007(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
  RETURN NUMBER IS
    v_line_access NUMBER(1) := 0;
 BEGIN
  
  FOR a IN (
  SELECT c.access_tag
    FROM GIIS_USERS a
        , GIIS_USER_GRP_LINE b
        , GIIS_USER_GRP_MODULES c
   WHERE a.user_grp  = b.user_grp
     AND a.user_grp  = c.user_grp
     AND a.user_id   = p_user_id
     AND b.iss_cd    = NVL(p_iss_cd,b.iss_cd)
     AND b.line_cd   = NVL(p_line_cd, b.line_cd)
     AND b.tran_cd   = c.tran_cd
     AND c.module_id = p_module_id) 
  LOOP
    v_line_access := a.access_tag;
   EXIT;
  END LOOP;
  
  IF v_line_access = 1 THEN
    RETURN 1;
  ELSIF v_line_access = 2 THEN
    RETURN 0;
  END IF;
  
  FOR a IN (
  SELECT c.access_tag
    FROM GIIS_USERS a
        , GIIS_USER_LINE b
        , GIIS_USER_MODULES c
   WHERE a.user_id  = b.userid
     AND a.user_id  = c.userid
     AND a.user_id   = p_user_id
     AND b.iss_cd    = NVL(p_iss_cd,b.iss_cd)
     AND b.line_cd   = NVL(p_line_cd, b.line_cd)
     AND b.tran_cd   = c.tran_cd
     AND c.module_id = p_module_id) 
  LOOP
    v_line_access := a.access_tag;
    EXIT;
 
  END LOOP;
  
  IF v_line_access = 1 THEN
    RETURN 1;
  ELSIF v_line_access = 2 THEN
    RETURN 0;
  END IF;
  
  RETURN 0;
 END;


  FUNCTION get_line_cd_per_line(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
  RETURN VARCHAR2 IS
    status        NUMBER(1);
    v_line_cd     VARCHAR2(2);
    v_menu_line   giis_line.menu_line_cd%TYPE;
  BEGIN
    status := ck_user_per_ln_giuts007(p_line_cd, p_iss_cd, p_module_id, p_user_id);
    --status := 0;
    IF status = 0 THEN 
        --raise_application_error('-20001', 'You are not authorized to use this line.');
        v_line_cd := '99';
    ELSE
        IF p_line_cd IS NOT NULL THEN
  	        SELECT menu_line_cd
    	      INTO v_menu_line
   	 	      FROM giis_line
   	         WHERE line_cd = p_line_cd;
  
  	        IF v_menu_line IS NOT NULL THEN
  		        v_line_cd := v_menu_line;
 	        ELSE
  		        v_line_cd := p_line_cd;
  	        END IF;   
        END IF;
	END IF;	   
    RETURN v_line_cd;      
  END;
  
  PROCEDURE read_into_copypar(
    p_copy_fire_cd      IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_motor_cd     IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_accident_cd  IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_hull_cd      IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_cargo_cd     IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_casualty_cd  IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_engrng_cd    IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_surety_cd    IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE,
    p_copy_aviation_cd  IN OUT    gipi_pack_line_subline.pack_line_cd%TYPE
  
  ) IS
  

  BEGIN
    p_copy_fire_cd     := null;
    p_copy_motor_cd    := null;
    p_copy_accident_cd := null;
    p_copy_hull_cd     := null;
    p_copy_cargo_cd    := null;
    p_copy_casualty_cd := null; 
    p_copy_engrng_cd   := null;
    p_copy_surety_cd   := null;
    p_copy_aviation_cd := null;


  SELECT param_value_v INTO p_copy_fire_cd
    FROM giis_parameters  	         
   WHERE param_name = 'LINE_CODE_FI';
  SELECT param_value_v INTO p_copy_motor_cd
    FROM giis_parameters	         
   WHERE param_name = 'LINE_CODE_MC';
  SELECT param_value_v INTO p_copy_accident_cd
    FROM giis_parameters	 
   WHERE param_name = 'LINE_CODE_AC';
  SELECT param_value_v INTO p_copy_hull_cd
    FROM giis_parameters	
   WHERE param_name = 'LINE_CODE_MH';
  SELECT param_value_v INTO p_copy_cargo_cd
    FROM giis_parameters	 
   WHERE param_name = 'LINE_CODE_MN';
  SELECT param_value_v INTO p_copy_casualty_cd
    FROM giis_parameters	        
   WHERE param_name = 'LINE_CODE_CA';	
  SELECT param_value_v INTO p_copy_engrng_cd
    FROM giis_parameters	 
   WHERE param_name = 'LINE_CODE_EN';
  SELECT param_value_v INTO p_copy_surety_cd
    FROM giis_parameters 
   WHERE param_name = 'LINE_CODE_SU';
  SELECT param_value_v INTO p_copy_aviation_cd
    FROM giis_parameters 
   WHERE param_name = 'LINE_CODE_AV';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error('-20001', 'No parameter record found. Please report error to CSD.');
  END;

  FUNCTION check_isscdex_per_user(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
  RETURN VARCHAR2 IS
    v_exist        VARCHAR2(1);
  BEGIN
    v_exist := 'N';
    IF Check_User_Per_Iss_Cd_giuts007(p_line_cd,p_iss_cd,p_module_id, p_user_id)=1 THEN 
    	  v_exist := 'Y';
    END IF;
    RETURN  v_exist;

  END;
  
  FUNCTION Check_User_Per_Iss_Cd_giuts007 (
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
  RETURN NUMBER IS
  v_iss_cd_access NUMBER(1) := 0;
 BEGIN
  
  FOR a IN (
    SELECT c.access_tag
      FROM GIIS_USERS a,
           GIIS_USER_GRP_DTL b,
           GIIS_USER_GRP_MODULES c
     WHERE a.user_grp  = b.user_grp
       AND a.user_grp  = c.user_grp
       AND a.user_id   = p_user_id
       AND b.iss_cd    = NVL(p_iss_cd, b.iss_cd)
       AND b.tran_cd   = c.tran_cd
       AND c.module_id = p_module_id
       AND EXISTS (SELECT 1
                     FROM GIIS_USER_GRP_LINE
                    WHERE user_grp = b.user_grp
                      AND iss_cd   = b.iss_cd
                      AND tran_cd  = c.tran_cd
                      AND line_cd  = NVL(p_line_cd,line_cd))) 
  LOOP
    v_iss_cd_access := a.access_tag;
    EXIT; 
  END LOOP;
  IF v_iss_cd_access = 1 THEN
     RETURN 1;
  ELSIF v_iss_cd_access = 2 THEN
     RETURN 0;
  END IF;
  
  FOR a IN (
    SELECT c.access_tag
      FROM GIIS_USERS a,
           GIIS_USER_ISS_CD b,
           GIIS_USER_MODULES c
     WHERE a.user_id  = b.userid
       AND a.user_id  = c.userid
       AND a.user_id   = p_user_id
       AND b.iss_cd    = NVL(p_iss_cd, b.iss_cd)
       AND b.tran_cd   = c.tran_cd
       AND c.module_id = p_module_id
       AND EXISTS (SELECT 1
                     FROM GIIS_USER_LINE
                    WHERE userid = b.userid
                      AND iss_cd = b.iss_cd
                      AND tran_cd  = c.tran_cd
                      AND line_cd  = NVL(p_line_cd,line_cd))) 
  LOOP
    v_iss_cd_access := a.access_tag;
    EXIT;
  END LOOP;
  IF v_iss_cd_access = 1 THEN
     RETURN 1;
  ELSIF v_iss_cd_access = 2 THEN
     RETURN 0;
  END IF;
  RETURN 0;
  END;
  
  FUNCTION get_line_cd_lov(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
    RETURN line_cd_lov_giuts007_tab PIPELINED 
  IS
  v_rec    line_cd_lov_giuts007_type;
  BEGIN
  FOR i IN (SELECT line_cd, line_name 
              FROM giis_line
             WHERE line_cd = DECODE(ck_user_per_ln_giuts007
                            (line_cd,p_iss_cd,p_module_id,p_user_id),1,line_cd,NULL)
               AND pack_pol_flag = 'N' -- bonok :: 11.19.2013 :: SR 591 :: retrieve only non-package lines
   )
    LOOP
        v_rec.line_cd           := i.line_cd;
        v_rec.line_name         := i.line_name;
        PIPE ROW(v_rec);
    END LOOP;
    
  END;
  
  
  FUNCTION get_iss_cd_lov(
    p_line_cd   VARCHAR2, 
    p_iss_cd    VARCHAR2,
    p_module_id VARCHAR2, 
    p_user_id   VARCHAR2)
    RETURN iss_cd_lov_giuts007_tab PIPELINED 
  IS
  v_rec    iss_cd_lov_giuts007_type;
  BEGIN
  FOR i IN (SELECT iss_cd, iss_name 
              FROM giis_issource
             WHERE iss_cd = DECODE(Check_User_Per_Iss_Cd_giuts007
                            (p_line_cd,iss_cd,p_module_id,p_user_id),1,iss_cd,NULL)
   )
    LOOP
        v_rec.iss_cd           := i.iss_cd;
        v_rec.iss_name         := i.iss_name;
        PIPE ROW(v_rec);
    END LOOP;
    
  END;
  
END GIUTS007_PKG;
/


