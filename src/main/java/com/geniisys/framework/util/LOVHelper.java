/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.LOVDAO;
import com.geniisys.common.entity.LOV;


/**
 * The Class LOVHelper.
 */
public class LOVHelper {
	
	/** The lov dao. */
	private LOVDAO lovDAO;
	
	/** The log. */
	private Logger log = Logger.getLogger(LOVHelper.class);
	
	/** The Constant LINE_LISTING. */
	public static final int LINE_LISTING = 1;
	
	/** The Constant SUB_LINE_LISTING. */
	public static final int SUB_LINE_LISTING = 2;
	
	/** The Constant BRANCH_SOURCE_LISTING. */
	public static final int BRANCH_SOURCE_LISTING = 3;
	
	/** The Constant REASON_LISTING. */
	public static final int REASON_LISTING = 4;	
	
	/** The Constant ASSURED_LISTING. */
	public static final int ASSURED_LISTING = 5;
	
	/** The Constant CURRENCY_CODES. */
	public static final int CURRENCY_CODES = 6;
	
	/** The Constant PERIL_CODES. */
	public static final int PERIL_CODES = 7;
	
	/** The Constant COVERAGE_CODES. */
	public static final int COVERAGE_CODES = 8;
	
	/** The Constant TAX_LISTING. */
	public static final int TAX_LISTING = 9;
	
	/** The Constant INTM_LISTING. */
	public static final int INTM_LISTING = 10;
	
	/** The Constant WARRANTY_LISTING. */
	public static final int WARRANTY_LISTING = 11;
	
	/** The Constant DEFAULT_CURRENCY. */
	public static final int DEFAULT_CURRENCY = 12;
	
	/** The Constant ITEM_LISTING. */
	public static final int ITEM_LISTING = 13;
	
	/** The Constant PERIL_LISTING. */
	public static final int PERIL_LISTING = 14;
	
	/** The Constant MC_BASIC_COLOR_LISTING. */
	public static final int MC_BASIC_COLOR_LISTING = 15;
	
	/** The Constant MC_COLOR_LISTING. */
	public static final int MC_COLOR_LISTING = 16;
	
	/** The Constant MOTOR_TYPE_LISTING. */
	public static final int MOTOR_TYPE_LISTING = 17;
	
	/** The Constant SUBLINE_TYPE_LISTING. */
	public static final int SUBLINE_TYPE_LISTING = 18;
	
	/** The Constant TYPE_OF_BODY_LISTING. */
	public static final int TYPE_OF_BODY_LISTING = 19;
	
	/** The Constant CAR_COMPANY_LISTING. */
	public static final int CAR_COMPANY_LISTING = 20;
	
	/** The Constant MAKE_LISTING. */
	public static final int MAKE_LISTING = 21;
	
	/** The Constant ENGINE_SERIES_LISTING. */
	public static final int ENGINE_SERIES_LISTING = 22;
	
	/** The Constant MORTGAGEE_LISTING. */
	public static final int MORTGAGEE_LISTING = 23;
	
	/** The Constant DEFAULT_ISS_SOURCE. */
	public static final int DEFAULT_ISS_SOURCE = 24;
	
	/** The Constant DEFAULT_HEADER. */
	public static final int DEFAULT_HEADER = 25;
	
	/** The Constant DEFAULT_FOOTER. */
	public static final int DEFAULT_FOOTER = 26;
	
	/** The Constant EQ_ZONE_LISTING. */
	public static final int EQ_ZONE_LISTING = 27;
	
	/** The Constant TYPHOON_ZONE_LISTING. */
	public static final int TYPHOON_ZONE_LISTING = 28;
	
	/** The Constant FLOOD_ZONE_LISTING. */
	public static final int FLOOD_ZONE_LISTING = 29;
	
	/** The Constant TARIFF_ZONE_LISTING. */
	public static final int TARIFF_ZONE_LISTING = 30;
	
	/** The Constant FIRE_OCCUPANCY_LISTING. */
	public static final int FIRE_OCCUPANCY_LISTING = 31;
	
	/** The Constant PROVINCE_LISTING. */
	public static final int PROVINCE_LISTING = 32;
	
	/** The Constant CITY_LISTING. */
	public static final int CITY_LISTING = 33;
	
	/** The Constant DISTRICT_LISTING. */
	public static final int DISTRICT_LISTING = 34;
	
	/** The Constant BLOCK_LISTING. */
	public static final int BLOCK_LISTING = 35;
	
	/** The Constant RISK_LISTING. */
	public static final int RISK_LISTING = 36;
	
	/** The Constant TARIFF_LISTING. */
	public static final int TARIFF_LISTING = 37;
	
	/** The Constant FIRE_CONSTRUCTION_LISTING. */
	public static final int FIRE_CONSTRUCTION_LISTING = 38;
	
	/** The Constant FIRE_ITEM_TYPE_LISTING. */
	public static final int FIRE_ITEM_TYPE_LISTING = 39;
	
	/** The Constant POSITION_LISTING. */
	public static final int POSITION_LISTING = 40;
	
	/** The Constant INDUSTRY_LISTING. */
	public static final int INDUSTRY_LISTING = 41;
	
	/** The Constant CONTROL_TYPE_LISTING. */
	public static final int CONTROL_TYPE_LISTING = 42;
	
	/** The Constant CG_REF_CODE_LISTING. */
	public static final int CG_REF_CODE_LISTING = 43;
	
	/** The Constant AIRCRAFT_LISTING. */
	public static final int AIRCRAFT_LISTING = 44;
	
	/** The Constant SECTION_OR_HAZARD_LISTING. */
	public static final int SECTION_OR_HAZARD_LISTING = 45;
	
	/** The Constant GEOG_LISTING. */
	public static final int GEOG_LISTING = 46;
	
	/** The Constant QUOTE_VESSEL_LISTING. */
	public static final int QUOTE_VESSEL_LISTING = 47;
	
	/** The Constant CARGO_CLASS_LISTING. */
	public static final int CARGO_CLASS_LISTING = 48;
	
	/** The Constant CARGO_TYPE_LISTING. */
	public static final int CARGO_TYPE_LISTING = 49;
	
	/** The Constant MARINE_HULL_LISTING. */
	public static final int MARINE_HULL_LISTING = 50;
	
	/** The Constant GROUP_LISTING. */
	public static final int GROUP_LISTING = 51;
	
	/** The Constant PAYTERM_LISTING. */
	public static final int PAYTERM_LISTING = 52;
	
	/** The Constant BOOKEDMONTH_LISTING. */
	public static final int BOOKEDMONTH_LISTING = 53;
	
	/** The Constant PAR_LINE_LISTING. */
	public static final int PAR_LINE_LISTING = 54;
	
	/** The Constant PAR_ISSOURCE_LISTING. */
	public static final int PAR_ISSOURCE_LISTING = 55;
	
	/** The Constant POLICY_DEDUCTIBLE. */
	public static final int POLICY_DEDUCTIBLE = 56;
	
	/** The Constant POLICY_STATUS_LISTING. */
	public static final int POLICY_STATUS_LISTING = 57;
	
	/** The Constant POLICY_TYPE_LISTING. */
	public static final int POLICY_TYPE_LISTING = 58;
	
	/** The Constant PLACE_LISTING. */
	public static final int PLACE_LISTING = 59;
	
	/** The Constant RISK_TAG_LISTING. */
	public static final int RISK_TAG_LISTING = 60;
	
	/** The Constant REGION_LISTING. */
	public static final int REGION_LISTING = 61;
	
	/** The Constant TAKEUP_TERM_LISTING. */
	public static final int TAKEUP_TERM_LISTING = 62;
	
	/** The Constant POLICY_TAX_LISTING. */
	public static final int POLICY_TAX_LISTING = 63;
	
	/** The Constant PERIL_SUBLINE_LISTING. */
	public static final int PERIL_SUBLINE_LISTING = 64;
	
	/** The Constant ACCESSORY_LISTING. */
	public static final int ACCESSORY_LISTING = 65;
	
	/** The Constant WITEM_LISTING. */
	public static final int WITEM_LISTING = 66;
	
	/** The Constant WPERIL_LISTING. */
	public static final int WPERIL_LISTING = 67;	
	
	/** The Constant WITEM_DISCOUNT_LISTING. */
	public static final int WITEM_DISCOUNT_LISTING = 68;
	
	/** The Constant ITEM_PERIL_LISTING. */
	public static final int ITEM_PERIL_LISTING = 69;
	
	/** The Constant REQUIRED_DOCS_LISTING. */
	public static final int REQUIRED_DOCS_LISTING = 70;
	
	/** The Constant VESSEL_LISTING. */
	public static final int VESSEL_LISTING = 71;
	
	/** The Constant ALL_GEOG_LISTING. */
	public static final int ALL_GEOG_LISTING = 72;
	
	/** The Constant INTM_LISTING_FILTERED. */
	public static final int INTM_LISTING_FILTERED = 73;
	
	/** The Constant SUB_LINE_SPF_LISTING. */
	public static final int SUB_LINE_SPF_LISTING = 74;
	
	/** The Constant LINE_LISTING2. */
	//public static final int LINE_LISTING2 = 75;
	
	public static final int OBLIGEE_LISTING = 76;
	public static final int PRINCIPAL_SIGNATORY_LISTING = 77;
	public static final int NOTARY_PUBLIC_LISTING 	= 78;
	public static final int BOND_CLAUSE_LISTING 	= 79;
	public static final int COSIGNORS_LISTING 		= 80;
	public static final int GEOG_LISTING1 			= 81;
	public static final int VESSEL_LISTING2 		= 82;
	public static final int VESSEL_CARRIER_LISTING 	= 83;
	public static final int VESSEL_LISTING3 		= 84;
	public static final int VESSEL_LISTING4 		= 85;
	public static final int INTM_LISTING_UNFILTERED = 86;
	public static final int CA_LOCATION_LISTING 	= 87;
	public static final int GROUP_LISTING2 			= 88;
	public static final int PACKAGE_BENEFIT_LISTING = 89;
	public static final int ENDT_PERIL_LISTING 		= 90;
	public static final int	PACK_PAR_LINE_LISTING 	= 91;
	public static final int PERIL_NAME_LISTING 		= 92;
	public static final int PERIL_NAME_LISTING2 	= 93;
	public static final int PERIL_NAME_LISTING3 	= 94;
	public static final int PACKAGE_BENEFIT_DTL_LISTING = 95;
	public static final int PAY_MODE_LISTING 		= 96;
	public static final int CHECK_CLASS_LISTING 	= 97;
	public static final int BANK_LISTING 			= 98;
	public static final int DCB_BANK_LISTING 		= 99;
	public static final int DCB_BANK_ACCTNO_LISTING = 100;
	public static final int PERIL_TARIFF_LISTING 	= 101;
	public static final int CURRENCY_CODES2 		= 102;
	public static final int POLICY_INVOICE_LISTING 	= 103;
	public static final int ALL_RISKS_LISTING 		= 104;
	public static final int MAkE_LISTING_BY_SUBLINE = 105;
	public static final int ALL_ENGINE_SERIES 		= 106;
	public static final int MC_ALL_COLOR 			= 107;
	public static final int TRANSACTION_TYPE 		= 108;
	public static final int ALL_CITY_LISTING 		= 109;
	public static final int ALL_DISTRICT_LISTING 	= 110;
	public static final int ALL_BLOCK_LISTING 		= 111;
	public static final int REINSURER_LISTING 		= 112;
	public static final int REINSURER_LISTING2 		= 113;
	/** Transaction Type in GIACS017 - REncela*/
	public static final int TRANSACTION_TYPE_PARAM 	= 114;
	public static final int ACCTG_ISSUE_CD_LISTING 	= 115;
	public static final int VESSEL_CARRIER_LISTING2 = 116;
	public static final int INST_NO_LISTING 		= 117;
	public static final int ENDT_GEOG_LISTING 		= 118;
	public static final int ENGINE_LISTING_BY_SUBLINE = 119;
	public static final int MAKE_LISTING_BY_SUBLINE1 = 120;
	public static final int CURRENCY_BY_PREMSEQNO 	= 121;
	/** Advice Line Listing in GIACS017 - REncela */
	public static final int ADVICE_LINE_LISTING 	= 122;		
	public static final int TRANS_BASIC_CURR_DTLS 	= 123;
	public static final int PAYEE_CLASS_LISTING 	= 124;
	public static final int PAYEES_LISTING 			= 125;
	public static final int GL_ACCT_LISTING 		= 126;
	public static final int VAT_SL_LISTING 			= 127;
	public static final int SL_LISTING 				= 128;	
	/** The Constant MARINE_HULL_LISTING. */
	public static final int ALL_MARINE_HULL_LISTING = 129;	
	public static final int REASON_LINELISTING 		= 130;	
	public static final int LINE_CODES 				= 131;
	public static final int RECOVERY_PAYOR_LISTING 	= 132;
	public static final int ADVICE_ISSCD_LISTING 	= 133;
	public static final int ADVICE_ISSCD_LISTING2 	= 134;
	public static final int ADVICE_YEAR_LISTING 	= 135;
	public static final int ADVICE_YEAR_LISTING2 	= 136;
	public static final int ADVICE_SEQ_LISTING 		= 137;
	public static final int ADVICE_SEQ_LISTING2 	= 138;
	public static final int CLAIM_LOSS_LISTING 		= 139;
	public static final int CLAIM_LOSS_LISTING2 	= 140;
	public static final int ENDORSEMENT_POLICY_LISTING = 141;
	public static final int OVRIDE_COMM_BILL_NO_LIST_PER_TRAN_TYPE = 142;
	public static final int OVRIDE_COMM_ISS_SOURCE_LISTING 	= 143;
	public static final int DFLT_OVRIDE_COMM_BILL_NO_LIST 	= 144;
	public static final int PARENT_COMM_INV_INTM_LISTING 	= 145;
	public static final int PARENT_COMM_INV_CHLD_INTM_LISTING = 146;
	public static final int CG_REF_CODE_LISTING2 = 147;
	public static final int REINSURER_LISTING3 	 = 148;
	public static final int REINSURER_LISTING4 	 = 149;
	public static final int FACUL_CLAIM_PAYTS_LINE_LISTING2 = 150; // Facul Claim Payts LINE_RG2
	public static final int ADVICE_ISS_CD_LISTING_PER_MODULE = 151; // Facul Claim Payts ISS_RG
	public static final int FACUL_CLAIM_PAYTS_ADVICE_YEAR_LISTING = 152; // Facul Claim Payts ADV_YEAR_RG
	public static final int FACUL_CLAIM_PAYTS_ADVICE_SEQ_NO_LISTING = 153; // Facul Claim Payts ADV_SEQ_NO_RG
	public static final int LINE_LISTING_FOR_PACK_PAR = 154;
	public static final int SURVEY_AGENT_LISTING = 155;
	public static final int SETTLING_AGENT_LISTING = 156;
	public static final int BOND_TAX_CHARGES = 157; 
	public static final int BOOKEDMONTH_LISTING2 = 158; 
	public static final int COMPANY_LISTING = 159;
	public static final int EMPLOYEE_LISTING = 160;
	public static final int ACCT_ISS_CD_LISTING = 161;
	public static final int BANK_REF_NO_LISTING = 162;
	public static final int BANC_TYPE_CD_LISTING = 163;
	public static final int BANC_AREA_CD_LISTING = 164;
	public static final int BANC_BRANCH_CD_LISTING = 165;
	public static final int EN_PRINCIPAL_LISTING = 166;
	public static final int PLAN_CD_LISTING = 167;
	public static final int PERIL_CLAUSES_LISTING = 168;
	public static final int PAYEES_LISTING_BY_CLASS_CD = 169;
	public static final int WHOLDING_TAXES_CODE_LISTING_BY_BRANCH = 170;
	public static final int ACCT_ENTRIES_SL_LISTING = 171;
	public static final int GIBR_GFUN_FUND_LISTING = 172;
	public static final int ACCT_ENTRIES_SL_LISTING2 = 173;
	public static final int QUOTE_PERIL_LISTING = 174;
	public static final int PACK_PAR_ISS_SOURCE_LISTING = 175;
	public static final int CG_REF_CODES_ORDER_BY_VALUE_LISTING = 176;
	public static final int WPERIL_LISTING3 = 177;
	public static final int WPERIL_LISTING4 = 178;
	public static final int CITY_BY_PROVINCE_LISTING = 179;
	public static final int INTERMEDIARY_LISTING = 180;
	public static final int MAKE_BY_SUBLINE_CAR_COMPANY_CD = 181;
	public static final int ENGINE_SERIES_BY_SUBLINE_CAR_MAKE_CD = 182;
	public static final int PACK_LINE_SUBLINE_COVERAGES = 183;
	public static final int MORTGAGEE_LISTING_POLICY = 184;
	public static final int MORTGAGEE_LISTING_ITEM = 185;
	public static final int DIST_SHARE_LISTING = 186;
	public static final int DIST_TREATY_LISTING = 187;
	public static final int DCB_PAY_MODE_LISTING = 188;
	public static final int ALL_TARIFF_ZONE_LISTING = 189;
	public static final int BOOKEDMONTH_LISTING3 = 190;	
	public static final int PRINCIPAL_LISTING = 191;
	public static final int COLLATERAL_TYPE_LISTING =192;
	public static final int COLLATERAL_DESC_LISTING =193;
	public static final int CHECK_CLASS_LISTING2 = 194;
	public static final int RI_SOURCE_LISTING = 195;
	public static final int ALL_MOTOR_TYPE_LISTING = 196;
	public static final int ALL_SUBLINE_TYPE_LISTING = 197;
	public static final int ALL_ISSUE_SOURCE = 198;
	public static final int DIST_SHARE_LISTING2 = 199;
	public static final int DIST_TREATY_LISTING2 = 200;
	public static final int ALL_GIIS_SUBLINE_LIST = 201;
	public static final int ISSUE_SOURCE_BY_CRED_BR_TAG = 202;
	public static final int ALL_LINE_LISTING = 203;
	public static final int POLICY_PACK_INVOICE_LISTING 	= 204; // added for pack
	public static final int PRINTER_LISTING = 205;
	public static final int CA_SECTION_OR_HAZARD_LIST = 206;
	public static final int ISSUING_SOURCE_LISTING = 207;
	public static final int DEFAULT_PACK_HEADER = 208;
	public static final int DIST_TREATY_LISTING3 = 209;
	public static final int PRINTER_LISTING_PER_USER_ACCESS = 210; //added by steven 2.1.2013
	public static final int GET_ISS_CD_BY_CRED_TAG_EXC_RI = 211; //added by christian 03/20/2013
	public static final int METHOD_LISTING = 212; 	//added by Gzelle 05.08.2013
	public static final int REPORT_LISTING = 213; 	//added by Kris 10.02.2013
	public static final int GIPIS050_ISSUING_SOURCE_LISTING = 214; 
	public static final int CODE_LISTING = 215; //added by carlo 04.05.2016 SR 5490
	public static final int MODEL_YEAR_LISTING = 216; //Dren Niebres 08.09.2016 SR-5278
	public static final int BANK_ACCT_LISTING = 217; //Deo [01.12.2017]: SR-22498
	
	/** The packages. */
	private final int[] packages = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,
									40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71, 72, 73, 74,
									75,76,77,78,79,80,81,82,83,84,85,86,87,88,89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102,103, 104,
									105,106,107,108,109,110,111,112,113,114,115,116,117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129,
									130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 
									153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176,
									177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197,198, 199, 200,
									201, 202, 203,204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217}; //*215 added by carlo rubenecia 04.05.2016 SR 5490 //SR-5278 "216" //Deo [01.12.2017]: added 217 (SR-22498)
	
	/** The ref codes. */
	private final int[] refCodes = {};
	
	/** The FRO m_ packages. */
	private final int FROM_PACKAGES  = 1;
	
	/** The FRO m_ re f_ codes. */
	private final int FROM_REF_CODES = 2;
	
	/** The STRIN g_ val. */
	public final int STRING_VAL = 1;
	
	/** The INTEGE r_ val. */
	public final int INTEGER_VAL = 2; 
	
	/** The FLOA t_ val. */
	public final int FLOAT_VAL = 3;
	
	/**
	 * Gets the list.
	 * 
	 * @param lovType the lov type
	 * @return the list
	 */
	public List<LOV> getList(int lovType){
		return getList(lovType, null);
	}
	
	/**
	 * Gets the list.
	 * 
	 * @param lovType the lov type
	 * @param args the args
	 * @return the list
	 */
	public List<LOV> getList(int lovType, String args[]){
		log.info("Getting LOV List Param: " + lovType);
		List<LOV> list = null;
		try {
			int listType = getListType(lovType);
			switch (listType){				
				case FROM_PACKAGES:  list = lovDAO.getListPACKAGES(getDomain(lovType),args); break;
				case FROM_REF_CODES: list = lovDAO.getListREFCODES(getDomain(lovType),args); break;
				default: break; 
			}
		} catch (SQLException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
		}		
		return list; 
	}
	
	/**
	 * Gets the lOV.
	 * 
	 * @param lovType the lov type
	 * @param lovValue the lov value
	 * @param valType the val type
	 * @return the lOV
	 */
	public LOV getLOV(int lovType, String lovValue, int valType){
		List<LOV> list = getList(lovType);
		LOV lovFinal = null;
		for (LOV lov: list){
			if(STRING_VAL == valType){
				if (lovValue.equalsIgnoreCase(lov.getValueString())){
					lovFinal = lov;
					break;
				}
			} if(INTEGER_VAL == valType){
				if (Integer.valueOf(lovValue).intValue()==lov.getValueInteger()){
					lovFinal = lov;
					break;
				}
			} if(FLOAT_VAL == valType){
				if (Float.valueOf(lovValue).floatValue() == lov.getValueFloat()){
					lovFinal = lov;
					break;
				}
			} else {
				break;
			}					
		}		
		return lovFinal;
	}
	
	/**
	 * Gets the domain.
	 * 
	 * @param lovType the lov type
	 * @return the domain
	 */
	private String getDomain(int lovType){
		switch (lovType){
			case 1: return "getLineListing";
			case 2: return "getGIISSublineListingByLineCd";		
			case 3: return "getBranchSourceListing";
			case 4: return "getReasonListingByLineCd";
			case 5: return "getAssuredListing";
			case 6: return "getCurrencyListing";
			case 7: return "getPerilListing";
			case 8: return "getCoverageListing";
			case 9: return "getTaxListing";
			case 10: return "getIntermediaryListing";
			case 11: return "getWarrantyTitleListing";
			case 12: return "getDefaultCurrency";
			case 13: return "getItemListing";
			case 14: return "getPerilListingByQuoteIdByItemNo";
			case 15: return "getGIISMCBasicColor";
			case 16: return "getGIISMCColor";
			case 17: return "getMotorTypeList";
			case 18: return "getSublineTypeList";
			case 19: return "getTypeOfBodyList";
			case 20: return "getCarCompanyList";
			case 21: return "getMakeList";
			case 22: return "getEngineSeriesList";
			case 23: return "getMortgageeListing";
			case 24: return "getDefaultIssSource";
			case 25: return "getDefaultHeader";
			case 26: return "getDefaultFooter";
			case 27: return "getEQZoneListing";
			case 28: return "getTyphoonZoneListing";
			case 29: return "getFloodZoneListing";
			case 30: return "getTariffZoneListing";
			case 31: return "getFireOccupancyListing";
			case 32: return "getProvinceListing";
			case 33: return "getCityByProvinceListing";
			case 34: return "getDistrictByProvinceByCityListing";
			case 35: return "getBlockListing";
			case 36: return "getRiskListing";
			case 37: return "getTariffListing";
			case 38: return "getFireConstructionListing";
			case 39: return "getFireItemTypeListing";
			case 40: return "getPositionListing";
			case 41: return "getIndustryList";
			case 42: return "getControlTypeList";
			case 43: return "getCgRefCodesListing";
			case 44: return "getAircraftListing";
			case 45: return "getSectionHazardListing";
			case 46: return "getGeogListing";
			case 47: return "getQuoteVesselListing";
			case 48: return "getCargoClassListing";
			case 49: return "getCargoTypeListing";
			case 50: return "getMarineHullListing";
			case 51: return "getGroupListing";
			case 52: return "getPayTermList";
			case 53: return "getBookedMonthList";
			case 54: return "getLineListForPARCreation";
			case 55: return "getIssourceListForPARCreation";
			case 56: return "getPolicyDeductible";
			case 57: return "getPolicyStatus";
			case 58: return "getPolicyType";
			case 59: return "getPlace";
			case 60: return "getRiskTagListing";
			case 61: return "getRegionListing";
			case 62: return "getTakeupTermListing";
			case 63: return "getTaxListing3";
			case 64: return "getPerilBySubline";
			case 65: return "getAccessoryListing";
			case 66: return "getWItemListing";
			case 67: return "getWPerilListing";
			case 68: return "getWItemListing2";
			case 69: return "getItemPerilListing";
			case 70: return "getRequiredDocsListing";
			case 71: return "getVesselListing";
			case 72: return "getAllGeogListing";
			case 73: return "getIntermediaryListingFiltered";
			case 74: return "getGIISSublineListingSpfByLineCd";
			case 75: return "getLineListing2";
			case 76: return "getObligeeListing";
			case 77: return "getSignatoryListing";
			case 78: return "getNPListing";
			case 79: return "getBondClauseListing";
			case 80: return "getCosignorListing";
			case 81: return "getGeogListing1";
			case 82: return "getVesselListing2";
			case 83: return "getVesselCarrierListing";
			case 84: return "getVesselListing3";
			case 85: return "getVesselListing4";
			case 86: return "getIntermediaryListingUnfiltered";
			case 87: return "getCaLocationListing";
			case 88: return "getGroupListing2";
			case 89: return "getPackageBenefitListing";
			case 90: return "getPerilNameListing";
			case 91: return "getLineListForPackPARCreation";
			case 92: return "getPerilNameListing2";
			case 93: return "getPerilNameListing3";
			case 94: return "getPerilNameListing4";
			case 95: return "getPackageBenefitDtlListing";
			case 96: return "getPayMode";
			case 97: return "getCheckClass";
			case 98: return "getBankListing";
			case 99: return "getDCBBankListing";
			case 100: return "getDCBBankAcctNoListing";
			case 101: return "getPerilTariffListing";
			case 102: return "getCurrencyListing2";
			case 103: return "getInvoiceNoListingForPolicyPrinting";
			case 104: return "getAllRisksListing";
			case 105: return "getMakeListBySubline";
			case 106: return "getAllEngineSeriesList";
			case 107: return "getGIISMCAllColor";
			case 108: return "getTransactionType";
			case 109: return "getCityListing";
			case 110: return "getDistrictListing";
			case 111: return "getAllBlockListing";
			case 112: return "getReInsurerListing";
			case 113: return "getReInsurerListing2";
			case 114: return "getTransactionType2";
			case 115: return "getAcctgIssCdListing";
			case 116: return "getEndtVesselCarrierListing";
			case 117: return "getInstNoListing";
			case 118: return "getEndtGeogListing";
			case 119: return "getEngineListingBySubline";
			case 120: return "getMakeListBySubline1";
			case 121: return "getCurrencyByPremSeqno";
			case 122: return "getAdviceLineListing";
			case 123: return "getTransBasicCurrDtls";
			case 124: return "getPayeeClassListing";
			case 125: return "getPayeesListing";
			case 126: return "getGlAcctListing";
			case 127: return "getVatSlListing";
			case 128: return "getSlListing";
			case 129: return "getAllMarineHullListing";
			case 130: return "getReasonLineListing";
			case 131: return "getGIISParametersLineCd";
			case 132: return "getRecoveryPayorListing";
			case 133: return "getAdviceIssCdSuggestionList";
			case 134: return "getAdviceIssCdSuggestionList2";
			case 135: return "getAdviceYearSuggestionList";
			case 136: return "getAdviceYearSuggestionList2";
			case 137: return "getAdviceSequenceNoSuggestionList";
			case 138: return "getAdviceSequenceNoSuggestionList2";
			case 139: return "getClaimLossIdSuggestionList";
			case 140: return "getClaimLossIdSuggestionList2";
			case 141: return "getPolicyForEndt";
			case 142: return "getOvrideCommBillNoListPerTranType";
			case 143: return "getOvrideCommIssSourceListing";
			case 144: return "getDfltOvrideCommBillNoListing";
			case 145: return "getParentCommInvIntmListing";
			case 146: return "getParentCommInvChldIntmListing";
			case 147: return "getCgRefCodesListing2";
			case 148: return "getReInsurerListing3";
			case 149: return "getReInsurerListing4";
			case 150: return "getFaculClaimPaytsLineListing2";
			case 151: return "getAdviceIssCdListingPerModule";
			case 152: return "getFaculClaimPaytsAdviceYearListing";
			case 153: return "getFaculClaimPaytsAdviceSeqNoListing";
			case 154: return "getLineListingForPackagePar";
			case 155: return "getSurveyAgentListing";
			case 156: return "getSettlingAgentListing";
			case 157: return "getTakeupTaxChargeListing";
			case 158: return "getBookedMonthList2";
			case 159: return "getCompanyListing";
			case 160: return "getEmployeeListing";
			case 161: return "getAcctIssCdListing";
			case 162: return "getBankRefNoListing";
			case 163: return "getBancTypeCdListing";
			case 164: return "getBancAreaCdListing";
			case 165: return "getBancBranchCdListing";
			case 166: return "getENPrincipalListing";
			case 167: return "getPlanCdListing";
			case 168: return "getPerilClausesListingByLine";
			case 169: return "getPayeesListingByClassCd";
			case 170: return "getWholdingTaxesCodeByBranch";
			case 171: return "getSlListForAcctEntries";
			case 172: return "getGibrGfunFundListing";
			case 173: return "getSlListForAcctEntries2";
			case 174: return "getQuotePerilListing";
			case 175: return "getPackParIssSourceListing";
			case 176: return "getCgRefCodesOrderByLowValueListing";
			case 177: return "getWPerilListing3";
			case 178: return "getWPerilListing4";
			case 179: return "getCityByProvinceCdListing";
			case 180: return "getIntermediaryListingAll";
			case 181: return "getMakeListBySublineCarCompanyCd";
			case 182: return "getEngineSeriesBySublineCarCompanyMakeCd";
			case 183: return "getPackLineSublineCoverages";
			case 184: return "getPolicyMortgageeListing";
			case 185: return "getItemMortgageeListing";
			case 186: return "getDistShareListing";
			case 187: return "getDistTreatyListing";
			case 188: return "getDCBPayMode";
			case 189: return "getAllTariffZoneListing";
			case 190: return "getBookedMonthList3";
			case 191: return "getPrincipalListing";
			case 192: return "getCollateralType";
			case 193: return "getCollateralDesc";
			case 194: return "getCheckClass2";
			case 195: return "getRISourceListing";
			case 196: return "getAllMotorTypeList";
			case 197: return "getAllSublineTypeList";
			case 198: return "getAllIssSource";
			case 199: return "getDistShareListing2";
			case 200: return "getDistTreatyListing2";
			case 201: return "getAllGiisSublineListing";
			case 202: return "getIssourceListByCredBrTag";
			case 203: return "getAllLineListing";
			case 204: return "getPackInvoiceNoListingForPolicyPrinting";
			case 205: return "getPrinterListing";
			case 206: return "getSectionOrHazardList";
			case 207: return "getIssuingSourceList";
			case 208: return "getDefaultPackHeader";
			case 209: return "getDistTreatyListing3";
			case 210: return "getPrinterListingPerUserAccess";
			case 211: return "getIssCdListByCredBrTagExcRi";
			case 212: return "getMethodListing";
			case 213: return "getReportListByPage";
			case 214: return "getGipis050IssuingSourceList";
			case 215: return "getCodeListing";//added by carlo rubenecia 04.05.2016 SR 5490
			case 216: return "getModelYearListing"; //Dren Niebres 08.09.2016 SR-5278		
			case 217: return "getBankAcctListing"; //Deo [01.12.2017]: SR-22498
			default: return null;
		}		
	}
	
	/**
	 * Gets the list type.
	 * 
	 * @param lovType the lov type
	 * @return the list type
	 */
	private int getListType(int lovType) {
		for (int x=0; x<packages.length; x++){
			if (packages[x]==lovType){
				return FROM_PACKAGES;
			}
		}
		for (int x=0; x<refCodes.length; x++){
			if (refCodes[x]==lovType){
				return FROM_REF_CODES;				
			}
		}
		return 0;
	}

	/**
	 * Gets the lov dao.
	 * 
	 * @return the lov dao
	 */
	public LOVDAO getLovDAO() {
		return lovDAO;
	}

	/**
	 * Sets the lov dao.
	 * 
	 * @param lovDAO the new lov dao
	 */
	public void setLovDAO(LOVDAO lovDAO) {
		this.lovDAO = lovDAO;
	}
}