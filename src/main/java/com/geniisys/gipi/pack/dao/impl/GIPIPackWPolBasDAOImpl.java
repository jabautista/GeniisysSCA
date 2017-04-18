package com.geniisys.gipi.pack.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.entity.GIPIPackWEndtText;
import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;
import com.geniisys.gipi.pack.entity.GIPIPackWPolGenin;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPackWPolBasDAOImpl implements GIPIPackWPolBasDAO {
	
	private SqlMapClient sqlMapClient;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIPIPackWPolBasDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public GIPIPackWPolBas getGIPIPackWPolBas(int packParId)
			throws SQLException {
		return (GIPIPackWPolBas) this.getSqlMapClient().queryForObject("getGIPIPackWPolBas", packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#executeGipis031ANewFormInstance(java.util.Map)
	 */
	@Override
	public void executeGipis031ANewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("executeGipis031ANewFormInstance", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#executeGipis031AGetAcctOfCd(java.util.Map)
	 */
	@Override
	public void executeGipis031AGetAcctOfCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getAcctOfCd", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#checkPolicyNoForPackEndt(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkPolicyNoForPackEndt(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("checkPolicyNoForPackEndt", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#getEndtPackBasicInfoRecs(java.util.Map)
	 */
	@Override
	public void getEndtPackBasicInfoRecs(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getEndtPackBasicInfoRecs", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#searchForPolicy(java.util.Map)
	 */
	@Override
	public void searchForPolicy(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("searchForPackPolicy", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#saveEndtBasicInfo(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveEndtBasicInfo(Map<String, Object> params)
			throws SQLException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String message = "SUCCESS";
		
		log.info("Saving endorsement basic information...");
		
		try {
			GIPIPackPARList gipiPackParList = (GIPIPackPARList)params.get("gipiPackParList");
			GIPIPackWPolBas gipiPackWPolbas = (GIPIPackWPolBas)params.get("gipiPackWPolbas");
			GIPIPackWPolGenin gipiPackWPolGenin = (GIPIPackWPolGenin)params.get("gipiPackWPolGenin");
			GIPIPackWEndtText gipiPackWEndtText = (GIPIPackWEndtText)params.get("gipiPackWEndtText");
			List<GIPIPARList> gipiParlist = (List<GIPIPARList>) params.get("gipiParList");
			Map<String, Object> vars = (Map<String, Object>) params.get("vars");
			Map<String, Object> pars = (Map<String, Object>) params.get("pars");
			Map<String, Object> others = (Map<String, Object>) params.get("others");
			
			//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yy HH:mm:ss");			
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			if("Y".equals((String) vars.get("varPolChangedSw"))){
				Map<String, Object> delAllTablesParam = new HashMap<String, Object>();
				delAllTablesParam.put("packParId", gipiPackWPolbas.getParId());
				delAllTablesParam.put("lineCd", gipiPackWPolbas.getLineCd());
				delAllTablesParam.put("sublineCd", gipiPackWPolbas.getSublineCd());
				delAllTablesParam.put("issCd", gipiPackWPolbas.getIssCd());
				delAllTablesParam.put("issueYy", gipiPackWPolbas.getIssueYy());
				delAllTablesParam.put("polSeqNo", gipiPackWPolbas.getPolSeqNo());
				delAllTablesParam.put("renewNo", gipiPackWPolbas.getRenewNo());
				delAllTablesParam.put("effDate", gipiPackWPolbas.getStrEffDate());
				
				this.getSqlMapClient().update("deleteAllTablesPack", delAllTablesParam);
			}
			
			// this is for endorse_tax procedure
			if("Y".equals(others.get("clickEndorseTax").toString())){
				if("Y".equals(others.get("b360EndtTax").toString())){
					if("Y".equals(others.get("nbtPolFlag").toString()) || "Y".equals(others.get("prorateSw"))){
						message = "Endorsement of tax is not available for cancelling endorsement.";
						gipiPackWEndtText.setEndtTax("N");
						throw new SQLException();
					}
					
					pars.put("parEndtTaxSw", "Y");
					
					// check witem table
					if("Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItemWithRecFlag", gipiPackWPolbas.getParId()).toString())){
						pars.put("parEndtTaxSw", "X");
					}
					
					//if("Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItemPeril", gipiPackWPolbas.getParId()).toString())){ changed by reymon 04222013
					if("Y".equals(this.getSqlMapClient().queryForObject("packEndtCheckRecordInItemPeril", gipiPackWPolbas.getParId()).toString())){
						pars.put("parEndtTaxSw", "N");
						gipiPackWEndtText.setEndtTax("N");
						System.out.println("Endorse Tax - Cannot be tagged as endorsement of tax if there are existing perils");
						// raise form trigger
					}
				} else{
					pars.put("parEndtTaxSw", "X");
					this.getSqlMapClient().delete("deleteRecordsForEndtTax", gipiPackWPolbas.getParId());
					System.out.println("Endorse Tax - Records related to endorse tax are deleted.");
				}
			}
			// this is for pol_flag procedure
			if("Y".equals(others.get("clickCancelledFlat").toString())){
				if("Y".equals(others.get("nbtPolFlag").toString())){
					System.out.println(params.get("renewExist"));
					if (params.get("renewExist").equals("Y")) {   // nante 12.4.2013
					//if(gipiPackWPolbas.getRenewNo() != 0){      // commented by: nante 12.4.2013
						others.put("nbtPolFlag", "N");
						System.out.println("Cancelled(Flat) - Renewed policy cannot be cancelled");
						// raise form trigger
					}else{
						Map<String, Object> genericMap = new HashMap<String, Object>();
						if("Y".equals(gipiPackWEndtText.getEndtTax())){
							others.put("nbtPolFlag", "N");
							System.out.println("Cancelled(Flat) - Endorsement Tax");
							// raise form trigger
						}
						// check for pending claims
						genericMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
								gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(),gipiPackWPolbas.getRenewNo());						
						
						if((Integer)this.getSqlMapClient().queryForObject("checkPendingClaimsForPack", genericMap) > 0){
							gipiPackWPolbas.setPolFlag("1");
							others.put("nbtPolFlag", "N");
							System.out.println("Cancelled(Flat) - The policy has pending claims, cannot cancel policy");
							// raise form trigger
						}
						// check for policy payment
						if(new BigDecimal("0.00").compareTo((BigDecimal) this.getSqlMapClient().queryForObject("checkPackPolicyPayment", genericMap)) > 0){
							System.out.println("Cancelled(Flat) - Payments have been made to the policy/endorsement to be cancelled");
							// raise form trigger
						}
						
						// clears map after use
						genericMap.clear();
						
						// check booking month
						if(gipiPackWPolbas.getBookingMth().isEmpty() | ((gipiPackWPolbas.getBookingYear() == null ? "" : gipiPackWPolbas.getBookingYear().toString()).isEmpty())){
							gipiPackWPolbas.setPolFlag("1");
							System.out.println("Cancelled(Flat) - Booking month and year is needed before performing cancellation");
							// raise form trigger
						}
						
						// check item and item_peril
						// this validation is handled at user interface
						/*if("Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItem", gipiWPolbas.getParId())) |
							"Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItemPeril", gipiWPolbas.getParId()).toString()) |
							!(String.format("%tF",gipiWPolbas.getInceptDate()).equals(String.format("%tF", gipiWPolbas.getEffDate())))  ){
							System.out.println("Cancelled(Flat) - InceptDate: " + String.format("%tF",gipiWPolbas.getInceptDate()) + " EffDate: " + String.format("%tF", gipiWPolbas.getEffDate()) + " - Raised Form Trigger Here");
						}*/
						
						// added by: Nica 12.09.2011 - to save gipi_wpolbas first before flat cancelling endt
						this.getSqlMapClient().insert("saveGipiPackWPolbasFromEndt", gipiPackWPolbas); 
						this.getSqlMapClient().executeBatch();
						
						Map<String, Object> wpolbasMap = new HashMap<String, Object>();
						
						wpolbasMap.clear();
						wpolbasMap.put("packParId", gipiPackWPolbas.getParId());
						wpolbasMap.put("appUser", gipiPackWPolbas.getUserId());
						this.getSqlMapClient().update("postInsertPackLineSubline", wpolbasMap);
						this.getSqlMapClient().executeBatch();
						
						// -- end Nica
						
						genericMap.put("gipiPackParList", gipiPackParList);
						genericMap.put("gipiPackWPolbas", gipiPackWPolbas);
						genericMap.put("vars", vars);
						genericMap.put("others", others);
						genericMap.put("cancelType", "Flat");
						
						genericMap = processNegatingRecords(genericMap);
						
						// update affected objects
						gipiPackParList = (GIPIPackPARList) genericMap.get("gipiPackParList");
						gipiPackWPolbas = (GIPIPackWPolBas) genericMap.get("gipiPackWPolbas");
						vars = (Map<String, Object>) genericMap.get("vars");
						others = (Map<String, Object>) genericMap.get("others");						
						
						genericMap = null;
					}
				} else{
					// revert cancellation
					others.put("globalCancellationType", null);
					
					// deleting records affects gipiWPolbas so we need to update it
					gipiPackWPolbas = deleteRecords(gipiPackWPolbas);					
					gipiPackParList.setParStatus(3);
					gipiPackWPolbas.setProrateFlag("2");
					others.put("prorateSw", "N");
					gipiPackWPolbas.setPolFlag("1");
					gipiPackWPolbas.setEffDate(sdfWithTime.parse(vars.get("varOldEffDate").toString()));					
					gipiPackWPolbas.setCancelType(null);
					vars.put("varCnclldFlatFlag", "N");					
				}
			}
			
			// this is for prorate_flag procedure
			System.out.println("renew no:::"+gipiPackWPolbas.getRenewNo());
			if("Y".equals(others.get("clickCancelled").toString())){
				if("Y".equals(others.get("prorateSw").toString())){
					/* removed by robert 02.24.2014
					 * if(gipiPackWPolbas.getRenewNo() != 0){
						others.put("nbtPolFlag", "N");
						System.out.println("Cancelled - Renewed policy cannot be cancelled");
						// raise form trigger
					}else{*/
						Map<String, Object> genericMap = new HashMap<String, Object>();
						
						if("Y".equals(gipiPackWEndtText.getEndtTax())){
							others.put("prorateSw", "N");
							System.out.println("Cancelled(Flat) - Prorate Cancellation is not allowed for endorsement of tax");
							// raise form trigger
						}
						// check for pending claims
						genericMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
								gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
						
						if((Integer)this.getSqlMapClient().queryForObject("checkPendingClaimsForPack", genericMap) > 0){
							gipiPackWPolbas.setPolFlag("1");
							others.put("prorateSw", "N");
							System.out.println("Cancelled - The policy has pending claims, cannot cancel policy");
							// raise form trigger
						}
						// check for policy payment
						if(new BigDecimal("0.00").compareTo((BigDecimal) this.getSqlMapClient().queryForObject("checkPackPolicyPayment", genericMap)) > 0){
							System.out.println("Cancelled - Payments have been made to the policy/endorsement to be cancelled");
							// raise form trigger
						}
						// check booking month
						if(gipiPackWPolbas.getBookingMth().isEmpty() | ((gipiPackWPolbas.getBookingYear() == null ? "" : gipiPackWPolbas.getBookingYear().toString()).isEmpty())){
							others.put("nbtPolFlag", "N");
							others.put("prorateSw", "N");
							System.out.println("Cancelled - Booking month and year is needed before performing cancellation");
							// raise form trigger
						}
						// check item and item_peril
						// this validation is handled at user interface
						/*if("Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItem", gipiWPolbas.getParId())) |
							"Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItemPeril", gipiWPolbas.getParId()).toString()) |
							!(String.format("%tF",gipiWPolbas.getInceptDate()).equals(String.format("%tF", gipiWPolbas.getEffDate())))  ){
							System.out.println("Cancelled(Flat) - InceptDate: " + String.format("%tF",gipiWPolbas.getInceptDate()) + " EffDate: " + String.format("%tF", gipiWPolbas.getEffDate()) + " - Raised Form Trigger Here");
						}*/
						
						// clears map after use
						genericMap.clear();
						
						// deleting records affects gipiWPolbas so we need to update it
						gipiPackWPolbas = deleteRecords(gipiPackWPolbas);
						
						gipiPackWPolbas.setPolFlag("4");						
						gipiPackWPolbas.setProrateFlag("1");
						gipiPackWPolbas.setCompSw("N");
						gipiPackWPolbas.setCancelType("2");
						others.put("nbtPolFlag", "N");
						others.put("prorateSw", "Y");
						others.put("endtCancellation", "N");
						others.put("coiCancellation", "N");
						pars.put("parProrateCancelSw", "Y");
						vars.put("varCnclldFlag", "Y");
						
						genericMap = null;
					//}
				}else{
					// deleting records affects gipiWPolbas so we need to update it
					gipiPackWPolbas = deleteRecords(gipiPackWPolbas);
					
					gipiPackParList.setParStatus(3);
					gipiPackWPolbas.setProrateFlag("2");
					others.put("prorateSw", "N");
					gipiPackWPolbas.setPolFlag("1");					
					gipiPackWPolbas.setCancelType(null);
					vars.put("varCnclldFlag", "N");
				}
				
				// this is for endt_cancellation and coi_cancellation procedure
				if("Y".equals(others.get("clickEndtCancellation").toString()) 
						| "Y".equals(others.get("clickCoiCancellation").toString())){
					if("Y".equals(others.get("endtCancellation").toString()) | 
							"Y".equals(others.get("coiCancellation").toString())){
						Map<String, Object> genericMap = new HashMap<String, Object>();
						String cancelType = "";
						
						if("Y".equals(others.get("endtCancellation").toString())){
							cancelType = "Endt";
						}else if("Y".equals(others.get("coiCancellation").toString())){
							cancelType = "Coi";
						}
						
						// check for pending claims						
						genericMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
								gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());						
						
						if((Integer)this.getSqlMapClient().queryForObject("checkPendingClaimsForPack", genericMap) > 0){
							gipiPackWPolbas.setPolFlag("1");
							others.put("nbtPolFlag", "N");
							System.out.println(cancelType + " - The policy has pending claims, cannot cancel policy");
							// raise form trigger
						}
						// check for policy payment
						if(new BigDecimal("0.00").compareTo((BigDecimal) this.getSqlMapClient().queryForObject("checkPackPolicyPayment", genericMap)) > 0){
							System.out.println(cancelType + " - Payments have been made to the policy/endorsement to be cancelled");
							// raise form trigger
						}
						
						// clears map after use
						genericMap.clear();
						
						// check booking month
						if(gipiPackWPolbas.getBookingMth().isEmpty() | ((gipiPackWPolbas.getBookingYear() == null ? "" : gipiPackWPolbas.getBookingYear().toString()).isEmpty())){
							gipiPackWPolbas.setPolFlag("1");
							System.out.println(cancelType + " - Booking month and year is needed before performing cancellation");
							// raise form trigger
						}
						//added by robert GENQA 4844 09.02.15
						this.getSqlMapClient().insert("saveGipiPackWPolbasFromEndt", gipiPackWPolbas); 
						this.getSqlMapClient().executeBatch();
						Map<String, Object> wpolbasMap = new HashMap<String, Object>();
						wpolbasMap.put("packParId", gipiPackWPolbas.getParId());
						wpolbasMap.put("appUser", gipiPackWPolbas.getUserId());
						this.getSqlMapClient().update("postInsertPackLineSubline", wpolbasMap);
						this.getSqlMapClient().executeBatch();		
						genericMap.put("packParId", gipiPackWEndtText.getPackParId());
						genericMap.put("assdNo", gipiPackParList.getAssdNo());			
						log.info("Updating assd_no in gipi_parlist ...");
						this.getSqlMapClient().update("updateAssdNo", genericMap);
						genericMap.clear();
						//end robert GENQA 4844 09.02.15
						genericMap.put("gipiParList", gipiPackParList);
						genericMap.put("gipiWPolbas", gipiPackWPolbas);
						genericMap.put("vars", vars);
						genericMap.put("others", others);
						genericMap.put("cancelType", cancelType);
						genericMap.put("gipiPackParList", gipiPackParList); //added by robert GENQA 4844 09.02.15
						genericMap.put("gipiPackWPolbas", gipiPackWPolbas); //added by robert GENQA 4844 09.02.15
						genericMap = processNegatingRecords(genericMap);
						
						// update affected objects
						gipiPackParList = (GIPIPackPARList) genericMap.get("gipiParList");
						gipiPackWPolbas = (GIPIPackWPolBas) genericMap.get("gipiWPolbas");
						vars = (Map<String, Object>) genericMap.get("vars");
						others = (Map<String, Object>) genericMap.get("others");
						
						// clears map after use
						genericMap.clear();
						
						// process endt cancellation
						if((String) pars.get("parCancelPolId") != null){
							// String.format(format, value) lets you modify a string to a certain format
							// %tD - MM/DD/YYYY
							// %tr - HH:MM:SS
							// %tF - YYYY-MM-DD
							// link: http://137.166.68.100/java-doc/api/java/util/Formatter.html
							//System.out.println("Qwe Eff Date: " + String.format("%tF", gipiWPolbas.getEffDate()) + " " + String.format("%tr", gipiWPolbas.getEffDate()));
							genericMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
									gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
							genericMap.put("parId", gipiPackWPolbas.getParId());
							genericMap.put("packPolFlag", gipiPackWPolbas.getPackPolFlag());
							//genericMap.put("cancelType", gipiPackWPolbas.getCancelType());
							genericMap.put("effDate", String.format("%tD", gipiPackWPolbas.getEffDate()));
							genericMap.put("policyId", Integer.parseInt((String)pars.get("parCancelPolId")));
							
							this.getSqlMapClient().queryForObject("processPackEndtCancellation", genericMap);
							//this.getSqlMapClient().queryForObject("processEndtCancellation", genericMap);
							if((String) genericMap.get("msgAlert") != null){
								System.out.println("Process Endt Cancellation - Message is not null");
							}else{
								// update gipiWPolbas due to process_endt_cancellation
								gipiPackParList.setParStatus(5);
								gipiPackWPolbas.setEffDate(sdfWithTime.parse((String) genericMap.get("effDate")));
								gipiPackWPolbas.setEndtExpiryDate(sdfWithTime.parse((String) genericMap.get("endtExpiryDate")));
								gipiPackWPolbas.setExpiryDate(sdfWithTime.parse((String) genericMap.get("expiryDate")));
								gipiPackWPolbas.setTsiAmt(new BigDecimal(genericMap.get("tsiAmt").toString()));
								gipiPackWPolbas.setPremAmt(new BigDecimal(genericMap.get("premAmt").toString()));
								gipiPackWPolbas.setAnnTsiAmt(new BigDecimal(genericMap.get("annTsiAmt").toString()));
								gipiPackWPolbas.setAnnPremAmt(new BigDecimal(genericMap.get("annPremAmt").toString()));
								gipiPackWPolbas.setProrateFlag((String) genericMap.get("prorateFlag"));
								gipiPackWPolbas.setProvPremPct(genericMap.get("provPremPct") == null ? null : (genericMap.get("provPremPct").toString().isEmpty() ? null : new BigDecimal(genericMap.get("provPremPct").toString())));
								gipiPackWPolbas.setProvPremTag((String) genericMap.get("provPremTag"));
								gipiPackWPolbas.setShortRtPercent(genericMap.get("shortRtPercent") == null ? null : (genericMap.get("shortRtPercent").toString().isEmpty() ? null : new BigDecimal(genericMap.get("shortRtPercent").toString())));
								gipiPackWPolbas.setCompSw((String) genericMap.get("compSw"));
								vars.put("varOldEndtExpiryDate", (String) genericMap.get("endtExpiryDate"));
								vars.put("varOldDateExp", (String) genericMap.get("endtExpiryDate"));
								vars.put("varOldDateEff", (String) genericMap.get("effDate"));
								vars.put("varOldExpiryDate", (String) genericMap.get("endtExpiryDate"));							
								vars.put("varOldInceptDate", (String) vars.get("varOldInceptDate"));
								vars.put("varOldEffDate", (String) genericMap.get("effDate"));							
							}						
						}else{
							// hindi dapat pumunta dito ang execution
							// kapag naka-check ung endt or coi, laging may laman dapat
							// ang parCancelPolId, dahil kapag walang laman ito
							// hindi dapat maexecute ang buong procedure na ito
							// :)
							System.out.println("Process Endt Cancellation - Policy Id is null");
						}
						
						genericMap = null;
					}else{
						// revert cancellation
						
						// deleting records affects gipiWPolbas so we need to update it
						gipiPackWPolbas = deleteRecords(gipiPackWPolbas);
						
						gipiPackParList.setParStatus(3);
						gipiPackWPolbas.setProrateFlag("2");
						others.put("prorateSw", "N");
						gipiPackWPolbas.setPolFlag("1");
						gipiPackWPolbas.setEffDate(sdfWithTime.parse(vars.get("varOldEffDate").toString()));
						gipiPackWPolbas.setCancelType(null);
						vars.put("varCnclldFlatFlag", "N");
						pars.put("parCancelPolId", null);
						others.put("globalCancellationType", null);					
					}
				}
			}
			
			//create winvoice loc
			
			// validate-before-commit on forms
			if("N".equals((String) others.get("nbtPolFlag")) && "N".equals((String) others.get("prorateSw"))){
				if("N".equals((String) vars.get("varPolChangedSw"))){
					String itemPerilExist = others.get("recExistsInGipiWItmperl").toString();
					//System.out.println(String.format("%tD", vars.get("varOldInceptDate")));					
					
					// parameter map for check_item_date
					Map<String, Object> checkItemDateMap = new HashMap<String, Object>();
					checkItemDateMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
							gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(),gipiPackWPolbas.getRenewNo());
					
					// parameter map for delete_all_table
					Map<String, Object> deleteAllTableMap = new HashMap<String, Object>();
					deleteAllTableMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
							gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
					deleteAllTableMap.put("effDate", gipiPackWPolbas.getEffDate());					
					
					// parameter map for delete_bill
					Map<String, Object> deleteBillMap = new HashMap<String, Object>();
					deleteBillMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
							gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
					deleteBillMap.put("parId", gipiPackWPolbas.getParId());
					deleteBillMap.put("effDate", gipiPackWPolbas.getEffDate());
					deleteBillMap.put("coInsuranceSw", gipiPackWPolbas.getCoInsuranceSw());
					deleteBillMap.put("gipiWPolbas", gipiPackWPolbas);
					
					Date oldInceptDate = vars.get("varOldInceptDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldInceptDate").toString());
					Date oldExpiryDate = vars.get("varOldExpiryDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldExpiryDate").toString());
					Date oldEffDate = vars.get("varOldEffDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldEffDate").toString());
					Date oldEndtExpDate = vars.get("varOldEndtExpiryDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldEndtExpiryDate").toString());
					
					//System.out.println("Incept: " + gipiWPolbas.getInceptDate().toString() + " - " + oldInceptDate.toString());
					//System.out.println("Expiry: " + gipiWPolbas.getExpiryDate().toString() + " - " + oldExpiryDate.toString());
					//System.out.println("Eff: " + gipiWPolbas.getEffDate().toString() + " - " + oldEffDate);
					//System.out.println("Endt: " + gipiWPolbas.getEndtExpiryDate().toString() + " - " + oldEndtExpDate.toString());					
					
					if(gipiPackWPolbas.getInceptDate().compareTo(oldInceptDate) != 0){
						// !(String.format("%tD", gipiWPolbas.getInceptDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldInceptDate").toString()))))
						System.out.println("Incept dates are not equal");
						checkItemDates(checkItemDateMap, gipiPackWPolbas.getEffDate());
						vars.put("varOldInceptDate", gipiPackWPolbas.getInceptDate());
						pars = updateParameters(pars, gipiPackWEndtText.getEndtTax());					
					}else if(gipiPackWPolbas.getExpiryDate().compareTo(oldExpiryDate)!= 0){
						// !(String.format("%tD", gipiWPolbas.getExpiryDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldExpiryDate").toString()))))
						System.out.println("Expiry dates are not equal");
						checkItemDates(checkItemDateMap, gipiPackWPolbas.getEffDate());
						vars.put("varOldExpiryDate", gipiPackWPolbas.getExpiryDate());
						pars = updateParameters(pars, gipiPackWEndtText.getEndtTax());
					}else if (gipiPackWPolbas.getEffDate() != null) {
						if((gipiPackWPolbas.getEffDate().compareTo(oldEffDate) != 0) && !(gipiPackWPolbas.getPolFlag().equals("4"))){
						
							// !(String.format("%tD", gipiWPolbas.getEffDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldEffDate").toString())))) && !(gipiWPolbas.getPolFlag().equals("4"))
							System.out.println("Effectivity dates are not equal");											
							vars.put("varOldEffDate", gipiPackWPolbas.getEffDate());						
							deleteAllTables(deleteAllTableMap);
							pars = updateParameters(pars, gipiPackWEndtText.getEndtTax());
							System.out.println("Eff Date: " + gipiPackWPolbas.getEffDate());
							System.out.println("Endt Exp: " + gipiPackWPolbas.getEndtExpiryDate());
						}
					} else if (gipiPackWPolbas.getEndtExpiryDate() != null) {
						if(gipiPackWPolbas.getEndtExpiryDate().compareTo(oldEndtExpDate) != 0){
							// !(String.format("%tD", gipiWPolbas.getEndtExpiryDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldEndtExpiryDate").toString()))))
							System.out.println("Endt Expiry dates are not equal");
							vars.put("varOldEndtExpiryDate", gipiPackWPolbas.getEndtExpiryDate());
							deleteAllTableMap.put("effDate", gipiPackWPolbas.getEffDate());
							deleteAllTables(deleteAllTableMap);
							pars = updateParameters(pars, gipiPackWEndtText.getEndtTax());
						}
					}else if(!(gipiPackWPolbas.getProvPremTag().equals(vars.get("varOldProvPremTag").toString())) && "Y".equals(itemPerilExist)){
						System.out.println("Prov prem tags are not equal");
						vars.put("varOldProvPremTag", gipiPackWPolbas.getProvPremTag());						
						gipiPackWPolbas = deleteBill(deleteBillMap);
					}else if("Y".equals(vars.get("varProrateSw").toString()) && "Y".equals(itemPerilExist)){
						System.out.println("Prorate flags are not equal");
						gipiPackWPolbas = deleteBill(deleteBillMap);
					}else if(!(new BigDecimal(others.get("shortRatePercent").toString()).compareTo(new BigDecimal(vars.get("varOldShortRtPercent").toString())) == 0) && "Y".equals(itemPerilExist)){						
						System.out.println("Short rate percents are not equal");
						System.out.println("SRP: " + others.get("shortRatePercent").toString() + " Old: " + vars.get("varOldShortRtPercent").toString());
						vars.put("varOldShortRtPercent", others.get("shortRatePercent").toString());
						gipiPackWPolbas = deleteBill(deleteBillMap);
					}
					checkItemDateMap = null;
					deleteAllTableMap = null;
					deleteBillMap = null;
				}
			}
			
			// check par status in database
			if((Integer)this.getSqlMapClient().queryForObject("gipis031AGetParStatus", gipiPackParList.getParId()) == 10){
				// raise form trigger
				System.out.println("Cannot save changes, par_id has been posted to a different endorsement");
			}
			
			if(gipiPackWPolbas.getBookingMth().isEmpty() | ((gipiPackWPolbas.getBookingYear() == null ? "" : gipiPackWPolbas.getBookingYear().toString()).isEmpty())){
				// raise form trigger
				System.out.println("There is no value for booking date. Please enter the date.");
			}
			
			if(!(gipiPackWPolbas.getEffDate() != null) | !(gipiPackWPolbas.getEndtExpiryDate() != null)){
				// raise form trigger
				System.out.println("Eff Date: " + gipiPackWPolbas.getEffDate());
				System.out.println("Endt Exp: " + gipiPackWPolbas.getEndtExpiryDate());
				System.out.println("Cannot proceed, endorsement effectivity date / endorsement expiry_date must not be null.");
			}
			
			if("Y".equals((String) others.get("prorateSw")) && "Y".equals((String) pars.get("parProrateCancelSw"))){
				// delete other info
				/*this.getSqlMapClient().queryForObject("gipis031DeleteOtherInfo", gipiPackWPolbas.getParId());
				
				// delete records
				Map<String, Object> genericMap = new HashMap<String, Object>();
				genericMap.put("parId", gipiPackWPolbas.getParId());
				genericMap.put("effDate", gipiPackWPolbas.getEffDate());
				genericMap.put("coInsuranceSw", gipiPackWPolbas.getCoInsuranceSw());
				
				this.getSqlMapClient().queryForObject("gipis031DeleteRecords", genericMap);
				
				if((String) genericMap.get("msgAlert") != null){					
					// raise form trigger
					System.out.println("Delete Records - Message is not null");
				}else{					
					gipiPackWPolbas.setAnnTsiAmt(new BigDecimal((String) genericMap.get("annTsiAmt")));
					gipiPackWPolbas.setAnnPremAmt(new BigDecimal((String) genericMap.get("annPremAmt")));
				}
				
				// clears map
				//genericMap.clear();*/ // commented by: Nica 11.16.2011 since this part is already handled in create_negated_records_prorate
				
				// added by: Nica 11.18.2011 - to save gipi_wpolbas first before cancelling endt
				
				this.getSqlMapClient().insert("saveGipiPackWPolbasFromEndt", gipiPackWPolbas); 
				this.getSqlMapClient().executeBatch();
				
				Map<String, Object> wpolbasMap = new HashMap<String, Object>();
				
				wpolbasMap.clear();
				wpolbasMap.put("packParId", gipiPackWPolbas.getParId());
				wpolbasMap.put("appUser", gipiPackWPolbas.getUserId());
				this.getSqlMapClient().update("postInsertPackLineSubline", wpolbasMap);
				this.getSqlMapClient().executeBatch();
				
				// -- end Nica
				
				Map<String, Object> genericMap = new HashMap<String, Object>();
				
				// create negated records prorate				
				genericMap = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
						gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
				genericMap.put("parId", gipiPackWPolbas.getParId());
				genericMap.put("coInsuranceSw", gipiPackWPolbas.getCoInsuranceSw());
				genericMap.put("packPolFlag", gipiPackWPolbas.getPackPolFlag());
				genericMap.put("prorateFlag", gipiPackWPolbas.getProrateFlag());
				genericMap.put("compSw", gipiPackWPolbas.getCompSw());
				System.out.println("test shortrate amount: "+others.get("shortRatePercent").toString());
				genericMap.put("shortRtPercent", "".equals(others.get("shortRatePercent").toString()) ? null : new BigDecimal(others.get("shortRatePercent").toString()));
				//genericMap.put("shortRtPercent", others.get("shortRatePercent").toString() == "" ? null : new BigDecimal(others.get("shortRatePercent").toString()));
				genericMap.put("effDate", gipiPackWPolbas.getEffDate());
				
				this.getSqlMapClient().queryForObject("packEndtCreateNegatedRecordsProrate", genericMap);
				
				if((String) genericMap.get("msgAlert") != null){
					// raise form trigger
					System.out.println("Create Negated Records Prorate - Message is not null");
				}else{
					// update objects
					System.out.println("Dumaan ba sya dito?");
					vars.put("varExpiryDate", genericMap.get("varExpiryDate"));
					vars.put("varInceptDate", genericMap.get("varInceptDate"));
					gipiPackWPolbas.setInceptDate(sdfWithTime.parse(genericMap.get("inceptDate").toString()));
					gipiPackWPolbas.setExpiryDate(sdfWithTime.parse(genericMap.get("expiryDate").toString()));
					gipiPackWPolbas.setEndtExpiryDate(sdfWithTime.parse(genericMap.get("endtExpiryDate").toString()));
					gipiPackWPolbas.setTsiAmt(new BigDecimal(genericMap.get("tsiAmt").toString()));
					gipiPackWPolbas.setPremAmt(new BigDecimal(genericMap.get("premAmt").toString()));
					gipiPackWPolbas.setAnnTsiAmt(new BigDecimal(genericMap.get("annTsiAmt").toString()));
					gipiPackWPolbas.setAnnPremAmt(new BigDecimal(genericMap.get("annPremAmt").toString()));
				}
				
				pars.put("parPolFlag", "Y");
				pars.put("parProrateCancelSw", "N");
				others.put("nbtPolFlag", "N");
				gipiPackParList.setParStatus(5);				
			}
			
			if("Y".equals((String)others.get("prorateSw")) | "Y".equals((String)others.get("nbtPolFlag"))){
				gipiPackWPolbas.setPolFlag("4");				
			}else if("N".equals((String)others.get("prorateSw")) && "N".equals((String)others.get("nbtPolFlag"))){
				if("Y".equals((String)others.get("endtCancellation")) | "Y".equals((String)others.get("coiCancellation"))){
					gipiPackWPolbas.setPolFlag("1");
					gipiPackWPolbas.setProrateFlag("2");
				}else{
					gipiPackWPolbas.setPolFlag("1");
				}
				others.put("nbtPolFlag", "N");
			}
			
			// insert a record to gipi_parhist
			Map<String, Object> genericMap = new HashMap<String, Object>();
			genericMap.put("parId", gipiPackParList.getParId());
			genericMap.put("userId", gipiPackParList.getUserId());
			
			this.getSqlMapClient().queryForObject("gipis031AInsertParhist", genericMap);
			
			// clears map
			genericMap.clear();
			
			// update par status
			genericMap.put("parId", gipiPackWPolbas.getParId());
			genericMap.put("polFlag", gipiPackWPolbas.getPolFlag());
			genericMap.put("endtTaxSw", pars.get("parEndtTaxSw"));
			genericMap.put("vEndt", pars.get("parVendt"));
			this.getSqlMapClient().queryForObject("gipis031AUpdateParStatus", genericMap);
			
			gipiPackParList.setParStatus(genericMap.get("parStatus") == null ? gipiPackParList.getParStatus() :Integer.parseInt(genericMap.get("parStatus").toString()));
			pars.put("parInsWinvoice", genericMap.get("parInsWinvoice"));

			System.out.println("gipis031AUpdateParStatus param map : " + genericMap);
			//gipiPackParList.setParStatus(Integer.parseInt(genericMap.get("parStatus").toString()));			
			// andrew - 09.02.2011 - modified assigning of value=			
			gipiPackParList.setParStatus((genericMap.get("parStatus") != null ? Integer.parseInt(genericMap.get("parStatus").toString()) : 2));
			pars.put("parInsWinvoice", genericMap.get("parInsWinvoice"));
			
			preCommitGIPIS002AInvoice(gipiPackWPolbas.getBookingYear(), gipiPackWPolbas.getBookingMth(), gipiPackWPolbas.getParId()); //belle 07.17.2012 
			
			// save records to tables (endt basic info)
			log.info("Saving record on GIPI_PACK_PARLIST...");
			this.getSqlMapClient().insert("saveGipiPackParListFromEndt", gipiPackParList);			
			
			log.info("Saving record on GIPI_PACK_WPOLBAS...");			
			this.getSqlMapClient().insert("saveGipiPackWPolbasFromEndt", gipiPackWPolbas);			
			log.info("Saving record on GIPI_PACK_WPOLGENIN...");
			this.getSqlMapClient().insert("saveGipiPackWPolGeninFromEndt", gipiPackWPolGenin);
			log.info("Saving record on GIPI_PACK_WENDTTEXT...");
			this.getSqlMapClient().insert("saveGipiPackWEndtTextFromEndt", gipiPackWEndtText);
			
			// GIPI_PACK_WENDTTEXT post-insert-item trigger
			this.getSqlMapClient().update("gipis031AGipiPackWEndtTextPostInsert", gipiPackWEndtText.getPackParId());
			
			// GIPI_PACK_WPOLGENIN post-insert-item trigger
			this.getSqlMapClient().update("gipis031AGipiPackWPolGeninPostInsert", gipiPackWPolGenin.getParId());
			
			// mortgagee
			updateMortgageeRecords(params);
			
			// deductibles
			updateDeductibleRecords(params);
			
			this.getSqlMapClient().executeBatch();
			
			genericMap.clear();		
			genericMap.put("packParId", gipiPackWEndtText.getPackParId());
			genericMap.put("assdNo", gipiPackParList.getAssdNo());			
			log.info("Updating assd_no in gipi_parlist ...");
			this.getSqlMapClient().update("updateAssdNo", genericMap); // mark jm 11.02.2011 update the assd_no in gipi_parlist
			
			genericMap.clear();
			genericMap.put("packParId", gipiPackWPolbas.getParId());
			genericMap.put("appUser", gipiPackWPolbas.getUserId());
			this.getSqlMapClient().update("postInsertPackLineSubline", genericMap); // andrew - 09.15.2011
			
			this.getSqlMapClient().executeBatch();
			

			// create winvoice  - moved here by d.alcantara, 02.07.2012
			if("Y".equals((String) pars.get("parInsWinvoice"))){
				Map<String, Object> winvoiceMap = null;
				/*genericMap.put("parId", gipiPackWPolbas.getPackParId());
				genericMap.put("lineCd", gipiPackWPolbas.getLineCd());
				genericMap.put("issCd", gipiPackWPolbas.getIssCd());
				this.getSqlMapClient().queryForObject("createPackWinvoice1", genericMap);
				if((String) genericMap.get("msgAlert") != null){
					// raise form trigger
					System.out.println("Error on creating winvoice");
				}*/
				for(GIPIPARList par: gipiParlist) {
					winvoiceMap = new HashMap<String, Object>();
					winvoiceMap.put("parId", par.getParId());
					winvoiceMap.put("lineCd", par.getLineCd());
					winvoiceMap.put("issCd", par.getIssCd());
					System.out.println("createPackWinvoice1 PARAMS::: "+winvoiceMap);
					this.getSqlMapClient().queryForObject("createPackWinvoice1", winvoiceMap);
					winvoiceMap = null;
				}
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		resultMap.put("message", message);
		return resultMap;
	}

	private Map<String, Object> loadPolicyNoToMap(String lineCd, String sublineCd, String issCd,
			int issueYy, int polSeqNo, int renewNo){
		Map<String, Object> policyNoMap = new HashMap<String, Object>();
		
		policyNoMap.put("lineCd", lineCd);
		policyNoMap.put("sublineCd", sublineCd);
		policyNoMap.put("issCd", issCd);
		policyNoMap.put("issueYy", issueYy);
		policyNoMap.put("polSeqNo", polSeqNo);
		policyNoMap.put("renewNo", renewNo);
		
		return policyNoMap;
	}
	
	@SuppressWarnings("unchecked")
	private Map<String, Object> processNegatingRecords(Map<String, Object> params) throws SQLException {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		GIPIPackPARList gipiPackParList = (GIPIPackPARList)params.get("gipiPackParList");
		GIPIPackWPolBas gipiPackWPolbas = (GIPIPackWPolBas)params.get("gipiPackWPolbas");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");		
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		
		// deleting records affects gipiWPolbas so we need to update it
		gipiPackWPolbas = deleteRecords(gipiPackWPolbas);
		
		// create negated records flat
		paramMap = createNegatedRecords(gipiPackParList, gipiPackWPolbas, vars, others, (String) params.get("cancelType"));
		
		// update affected objects
		gipiPackParList = (GIPIPackPARList) paramMap.get("gipiParList");
		gipiPackWPolbas = (GIPIPackWPolBas) paramMap.get("gipiWPolbas");
		vars = (Map<String, Object>) paramMap.get("vars");
		
		gipiPackWPolbas.setProrateFlag("2");
		
		if("Flat".equals((String) params.get("cancelType"))){
			gipiPackWPolbas.setCompSw(null);
			gipiPackWPolbas.setPolFlag("4");
			gipiPackWPolbas.setCancelType("1");
			others.put("nbtPolFlag", "Y");
			others.put("prorateSw", "N");
			others.put("coiCancellation", "N");
			others.put("endtCancellation", "N");
			vars.put("varCnclldFlatFlag", "N");
		}else if("Endt".equals((String) params.get("cancelType")) | "Coi".equals((String) params.get("cancelType"))){
			gipiPackWPolbas.setCompSw("N");
			gipiPackWPolbas.setPolFlag("1");		
			
			if("Endt".equals((String) params.get("cancelType"))){
				gipiPackWPolbas.setCancelType("3");
				others.put("endtCancellation", "Y");
				others.put("coiCancellation", "N");
				resultMap.put("gipiParList", gipiPackParList); //added by robert GENQA 4844 09.02.15
				resultMap.put("gipiWPolbas", gipiPackWPolbas); //added by robert GENQA 4844 09.02.15
			}else if("Coi".equals((String) params.get("cancelType"))){
				gipiPackWPolbas.setCancelType("4");
				others.put("endtCancellation", "N");
				others.put("coiCancellation", "Y");
			}
			
			others.put("nbtPolFlag", "N");
			others.put("prorateSw", "N");			
			vars.put("varCnclldFlatFlag", "Y");
		}
		
		resultMap.put("gipiPackParList", gipiPackParList);
		resultMap.put("gipiPackWPolbas", gipiPackWPolbas);
		resultMap.put("vars", vars);
		resultMap.put("others", others);
		
		return resultMap;
	}
	
	private GIPIPackWPolBas deleteRecords(GIPIPackWPolBas gipiPackWPolbas) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
				gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
		params.put("parId", gipiPackWPolbas.getParId());
		params.put("effDate", gipiPackWPolbas.getEffDate());
		params.put("coInsuranceSw", gipiPackWPolbas.getCoInsuranceSw());		
		
		this.getSqlMapClient().queryForObject("packEndtRevertFlatCancellation", params);		
		
		if((String) params.get("msgAlert") != null){
			System.out.println("Revert Flat Cancellation - Message is not null");
		}else{
			// sets the tsi_amt and the prem_amt to 0 again if the cancellation was reverted - irwin 10.29.2012
			gipiPackWPolbas.setTsiAmt(new BigDecimal("0"));
			gipiPackWPolbas.setPremAmt(new BigDecimal("0"));
			
			gipiPackWPolbas.setAnnTsiAmt(params.get("annTsiAmt") != null ? 
					new BigDecimal(params.get("annTsiAmt").toString()) : new BigDecimal("0.00"));
			gipiPackWPolbas.setAnnPremAmt(params.get("annPremAmt") != null ? 
					new BigDecimal(params.get("annPremAmt").toString()) : new BigDecimal("0.00"));
			
			//reverting amounts of sub policies
			log.info("reverting amounts of subpolicies for pack par: "+gipiPackWPolbas.getParId());
			this.getSqlMapClient().update("cancellationUpdateAmounts", gipiPackWPolbas.getParId());
			this.getSqlMapClient().executeBatch();
		}		
		
		return gipiPackWPolbas;
	}
	
	private Map<String, Object> createNegatedRecords(GIPIPackPARList gipiPackParList, GIPIPackWPolBas gipiPackWPolbas, 
			Map<String, Object> vars, Map<String, Object> others, String cancellationType) throws SQLException{
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yy HH:mm:ss");
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		String procedureName = "";
		if("Flat".equals(cancellationType)){
			//procedureName = "createNegatedRecordsFlat"; replaced by: Nica 11.15.2011
			procedureName = "createNegatedRecordsFlatForPackEndt";
		}else if("Endt".equals(cancellationType)){
			procedureName = "createNegatedRecordsFlatForPackEndt"; //"createNegatedRecordsEndt"; replaced by robert SR 4844 09.03.15
		}else if("Coi".equals(cancellationType)){
			procedureName = "createNegatedRecordsCoi";
		}
		
		params = loadPolicyNoToMap(gipiPackWPolbas.getLineCd(), gipiPackWPolbas.getSublineCd(), gipiPackWPolbas.getIssCd(),
				gipiPackWPolbas.getIssueYy(), gipiPackWPolbas.getPolSeqNo(), gipiPackWPolbas.getRenewNo());
		params.put("parId", gipiPackWPolbas.getParId());						
		params.put("effDate", gipiPackWPolbas.getEffDate());		
		params.put("coInsuranceSw", gipiPackWPolbas.getCoInsuranceSw());
		params.put("packPolFlag", gipiPackWPolbas.getPackPolFlag());
		params.put("effDate", others.get("endtEffDate"));
		
		this.getSqlMapClient().queryForObject(procedureName, params);		
		
		// apply changes to records due to procedure call		
		if((String) params.get("msgAlert") != null){
			System.out.println(cancellationType + " - Message Alert is not null");
			// raise form trigger
		}else{			
			try {
				gipiPackParList.setParStatus(Integer.parseInt(params.get("parStatus").toString()));														
				gipiPackWPolbas.setTsiAmt(new BigDecimal(params.get("tsiAmt").toString()));
				gipiPackWPolbas.setPremAmt(new BigDecimal(params.get("premAmt").toString()));
				gipiPackWPolbas.setAnnTsiAmt(new BigDecimal(params.get("annTsiAmt").toString()));
				gipiPackWPolbas.setAnnPremAmt(new BigDecimal(params.get("annPremAmt").toString()));
				
				if((String) params.get("effDate") != null){
					gipiPackWPolbas.setEffDate(sdfWithTime.parse(params.get("effDate").toString()));
				}
				
				if((String) params.get("inceptDate") != null){
					gipiPackWPolbas.setInceptDate(sdfWithTime.parse(params.get("inceptDate").toString()));
				}
				
				if((String) params.get("expiryDate") != null){
					gipiPackWPolbas.setExpiryDate(sdfWithTime.parse(params.get("expiryDate").toString()));
				}
				
				if((String) params.get("endtExpiryDate") != null){
					gipiPackWPolbas.setEndtExpiryDate(sdfWithTime.parse(params.get("endtExpiryDate").toString()));
				}
				
				vars.put("varExpiryDate", params.get("varExpiryDate").toString());
				
				resultMap.put("gipiParList", gipiPackParList);
				resultMap.put("gipiWPolbas", gipiPackWPolbas);
				resultMap.put("vars", vars);
			} catch (ParseException e) {					
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
		}		
		
		return resultMap;
	}
	
	private void checkItemDates(Map<String, Object> params, Date effDate) throws SQLException {
		
		/*	Created by 	: mark jm 07.28.2010
		 * 	Description	: Check if record exist by executing the procedure below		
		 */
		
		this.getSqlMapClient().queryForObject("checkItemDates", params);
		
		if("Y".equals((String) params.get("recordExist"))){
			// raise form trigger
			System.out.println("Check Item Dates - Record exist!");
		}else{
			params.put("effDate", effDate);
			deleteAllTables(params);			
		}
	}
	
	private void deleteAllTables(Map<String, Object> params) throws SQLException {
		
		/*	Created by 	: mark jm 07.28.2010
		 * 	Description	: Delete affected records		
		 */
		
		this.getSqlMapClient().queryForObject("gipis031DeleteAllTables", params);
		if((String) params.get("msgAlert") != null){
			// raise form trigger
			System.out.println("Delete All Tables - Message is not null");
		}
	}
	
	private GIPIPackWPolBas deleteBill(Map<String, Object> params) throws SQLException {
		
		/*	Created by 	: mark jm 07.28.2010
		 * 	Description	: Delete bill-related records by executing the following procedure		
		 */
		
		GIPIPackWPolBas gipiPackWPolbas = (GIPIPackWPolBas) params.get("gipiWPolbas");
		params.remove("gipiWPolbas");
		
		this.getSqlMapClient().queryForObject("gipis031DeleteBill", params);
		if((String) params.get("msgAlert") != null){
			// raise form trigger failure
			System.out.println("Delete Bill - Message is not null");
		}else{
			gipiPackWPolbas.setAnnTsiAmt(new BigDecimal((String) params.get("annTsiAmt")));
			gipiPackWPolbas.setAnnPremAmt(new BigDecimal((String) params.get("annPremAmt")));
		}
		
		return gipiPackWPolbas;
	}
	
	private Map<String, Object> updateParameters(Map<String, Object> pars, String endtTax) throws SQLException {
		
		/*	Created by 	: mark jm 07.28.2010
		 * 	Description	: Return new values for HashMap object due to previous call to a procedure		
		 */
		
		pars.put("parEndtTaxSw", "X");
		if("Y".equals(endtTax)){
			pars.put("parEndtTaxSw", "Y");
			pars.put("parVendt", "Y");
		}		
		return pars;
	}
	
	@SuppressWarnings("unchecked")
	private void updateMortgageeRecords(Map<String, Object> params) throws SQLException {
		
		/*	Created by 	: mark jm 08.05.2010
		 * 	Description	: Insert/Update/Delete records on GIPI_WMORTGAGEE		
		 */
		
		if(params.get("mortgageeDelList") != null && ((List<Map<String, Object>>) params.get("mortgageeDelList")).size() > 0){			
			for(Map<String, Object> m : (List<Map<String, Object>>) params.get("mortgageeDelList")){				
				log.info("Item - (parId=" + m.get("parId") + ", itemNo=" + m.get("itemNo") + ", mortgCd=" + m.get("mortgCd") + ") - Deleting record in gipi_wmortgagee ...");
				this.getSqlMapClient().delete("delGIPIParMortgagee", m);
			}			
		}
		
		if(params.get("mortgageeInsList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeInsList")).size() > 0){
			for(GIPIParMortgagee m : (List<GIPIParMortgagee>) params.get("mortgageeInsList")){
				log.info("Item - (parId=" + m.getParId() + ", itemNo=" + m.getItemNo() + ", mortgCd=" + m.getMortgCd() + ") - Inserting record to gipi_wmortgagee ...");
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private void updateDeductibleRecords(Map<String, Object> params) throws SQLException {
		
		/*	Created by 	: mark jm 08.06.2010		 
		 * 	Description	: Insert/Update/Delete records on GIPI_WDEDUCTIBLES
		 */
		
		Map<String, Object> insertDeductibles = (Map<String, Object>) params.get("insDeductibles");
		Map<String, Object> deleteDeductibles = (Map<String, Object>) params.get("delDeductibles");
		
		log.info("Saving record on GIPI_WDEDUCTIBLES...");
		
		if(insertDeductibles != null){
			String[] itemNos			= (String[]) insertDeductibles.get("insDedItemNos");
			String[] perilCds 		 	= (String[]) insertDeductibles.get("insDedPerilCds");
			String[] deductibleCds 	 	= (String[]) insertDeductibles.get("insDedDedCds");
			String[] deductibleAmts  	= (String[]) insertDeductibles.get("insDedDedAmts");
			String[] deductibleRts 	 	= (String[]) insertDeductibles.get("insDedDedRts");
			String[] deductibleTexts 	= (String[]) insertDeductibles.get("insDedDedTexts");
			String[] aggregateSws 	 	= (String[]) insertDeductibles.get("insDedAggSws");
			String[] ceilingSws 	 	= (String[]) insertDeductibles.get("insDedCeilSws");			
			
			for(int i=0; i < itemNos.length; i++){
				GIPIWDeductible gipiWDeductible = new GIPIWDeductible();
				
				gipiWDeductible.setParId((Integer) insertDeductibles.get("parId"));
				gipiWDeductible.setDedLineCd((String) insertDeductibles.get("dedLineCd"));
				gipiWDeductible.setDedSublineCd((String) insertDeductibles.get("dedSublineCd"));
				gipiWDeductible.setUserId((String) insertDeductibles.get("userId"));
				gipiWDeductible.setItemNo(Integer.parseInt(itemNos[i]));
				gipiWDeductible.setPerilCd(Integer.parseInt(perilCds[i]));
				gipiWDeductible.setDedDeductibleCd(deductibleCds[i]);
				gipiWDeductible.setDeductibleAmount(deductibleAmts[i] != null && !(deductibleAmts[i].isEmpty()) ? new BigDecimal(deductibleAmts[i].replaceAll(",", "")) : null);
				gipiWDeductible.setDeductibleRate(deductibleRts[i] != null && !(deductibleRts[i].isEmpty()) ? new BigDecimal(deductibleRts[i].replaceAll(",", "")) : null);
				gipiWDeductible.setDeductibleText(deductibleTexts[i]);
				gipiWDeductible.setAggregateSw(aggregateSws[i] != null ? aggregateSws[i] : "N");
				gipiWDeductible.setCeilingSw(ceilingSws[i] != null ? ceilingSws[i] : "N");				
				System.out.println("Ded Cd: " + deductibleCds[i]);
				this.getSqlMapClient().insert("saveWDeductible",gipiWDeductible);
			}
		}
		
		if(deleteDeductibles != null){
			String[] itemNos			= (String[]) deleteDeductibles.get("delDedItemNos");			
			String[] deductibleCds 	 	= (String[]) deleteDeductibles.get("delDedDedCds");
			
			for(int i=0; i < itemNos.length; i++){
				Map<String, Object> deleteMap = new HashMap<String, Object>();
				deleteMap.put("parId", (Integer) deleteDeductibles.get("parId"));
				deleteMap.put("itemNo", Integer.parseInt(itemNos[i]));
				deleteMap.put("dedDeductibleCd", deductibleCds[i]);
				System.out.println("Ded Cd: " + deductibleCds[i]);
				this.getSqlMapClient().delete("delGipiWDeductibles", deleteMap);
			}
		}
	}

	@Override
	public Map<String, String> newFormInst(String lineCd, String issCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		this.sqlMapClient.queryForObject("newFormInstGIPIS002A", params);
		return params;
	}

	@Override
	public Map<String, String> isPackWPolbasExist(Integer packParId)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("packParId", packParId.toString());
		this.sqlMapClient.queryForObject("isExistPackWPolbas", params);
		return params;
	}

	@Override
	public GIPIPackWPolBas getGipiPackWPolbasDefaultValues(Integer packParId)
			throws SQLException {
		return (GIPIPackWPolBas) this.getSqlMapClient().queryForObject("getGipiPackWPolbasDefault", packParId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> savePackPARBasicInfo(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		Map<String, Object> paramsResult = new HashMap<String, Object>();
		paramsResult.put("message", message);
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
				log.info("Start of saving Basic Information for Package PAR...");
				
				GIPIPackWPolBas gipiPackWPolbas = (GIPIPackWPolBas) params.get("gipiPackWPolbas");
				GIPIPackWPolGenin gipiPackWPolGenin =  (GIPIPackWPolGenin) params.get("gipiPackWPolGenin");
				Map<String, Object> gipiPackWPolnrepMap = (Map<String, Object>) params.get("gipiPackWPolnrepMap");
				String deleteWPolnrep = (String) params.get("deleteWPolnrep");
				//String deleteCoIns = (String) params.get("deleteCoIns");
				String deleteBillSw = (String) params.get("deleteBillSw");
				String deleteAllTables = (String) params.get("deleteAllTables");
				String validatedIssuePlace = (String) params.get("validatedIssuePlace");
				//String deleteSw = (String) params.get("deleteSw");
				String deleteSwForAssdNo = (String) params.get("deleteSwForAssdNo");
				Integer packParId = gipiPackWPolbas.getParId();
				String precommitDelTab = (String) params.get("precommitDelTab");
				String createInvoiceSw = "";
				
				Map<String, String> recExistMap = new HashMap<String, String>();
				recExistMap = this.isPackWPolbasExist(packParId);
				String isPackWPolbasExist = (String) recExistMap.get("exist");
				
				
				if("Y".equals(deleteAllTables)){
					log.info("New subline_cd - Deleting all tables...");
					this.getSqlMapClient().delete("deleteAllTablesForPack", packParId);
				}
				
				if("Y".equals(deleteSwForAssdNo)){
					log.info("Assured No. is changed - recreating invoice and deleting corresponding data on group information...");
					Map<String, Object> changeAssdParamsMap = new HashMap<String, Object>();
					changeAssdParamsMap.put("packParId", packParId);
					changeAssdParamsMap.put("assdNo", gipiPackWPolbas.getAssdNo());
					this.getSqlMapClient().update("changeAssdNoGIPIS002A", changeAssdParamsMap);
				}
				if ("Y".equals(validatedIssuePlace)){
					log.info("Issue place is changed - recreating invoice...");
					createInvoiceSw = "Y";
				}
			this.getSqlMapClient().executeBatch();
			
			/* pre-commit - to delete update records when preCommitDelTab = "Y"
			 * (inception date is modified and prorate_flag != original prorate_flag)
			 */				
			this.getSqlMapClient().startBatch();
				if("Y".equals(precommitDelTab)){
					this.getSqlMapClient().delete("preCommitGIPIS002A", packParId);
					createInvoiceSw = "Y"; 
				}
				preCommitGIPIS002AInvoice(gipiPackWPolbas.getBookingYear(), gipiPackWPolbas.getBookingMth(), gipiPackWPolbas.getParId()); //belle 07.17.2012  
			this.getSqlMapClient().executeBatch();
			// end pre-commit
			
			// key-commit
			this.getSqlMapClient().startBatch();
				if("Y".equals(deleteWPolnrep)){
					log.info("Deleting GIPI_PACK_WPOLNREP records for pack_par_id: " + packParId);
					this.getSqlMapClient().delete("deletePackWPolnreps", packParId);
				}
				if("2".equals(gipiPackWPolbas.getPolFlag()) || "3".equals(gipiPackWPolbas.getPolFlag())){
					String[] delOldPolicyIds = (String[]) gipiPackWPolnrepMap.get("delOldPolicyIds");
					String[] insOldPolicyIds = (String[]) gipiPackWPolnrepMap.get("insOldPolicyIds");
					this.deleteGIPIPackWPolnreps(packParId, delOldPolicyIds);
					this.insertGIPIPackWPolnreps(packParId, insOldPolicyIds, gipiPackWPolbas.getPolFlag(), gipiPackWPolbas.getUserId());
				}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
				if("Y".equals(deleteBillSw)){
					log.info("Deleting Bill...");
					Map<String, Object> delBillMap = new HashMap<String, Object>();
					delBillMap.put("packParId", packParId);
					delBillMap.put("coInsurance", gipiPackWPolbas.getCoInsuranceSw());
					this.getSqlMapClient().delete("deleteBillForPackPAR", delBillMap);
				}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
				log.info("Saving GIPI_PACK_WPOLBAS for pack_par_id: " + packParId);
				Debug.print(gipiPackWPolbas.getIssueDate());
				System.out.println(gipiPackWPolbas.getTakeupTerm());
				this.getSqlMapClient().insert("saveGipiPackWPolbas", gipiPackWPolbas);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
				if("1".equals(isPackWPolbasExist)){
					log.info("POST-UPDATE - Updating record/s in gipi_wpolbas...");
					//this.getSqlMapClient().update("postUpdateB540GIPIS002A", gipiPackWPolbas);
					this.getSqlMapClient().update("postUpdateB540GIPIS002ARevised", packParId);
				}else{
					log.info("POST-INSERT - Inserting record/s in gipi_wpolbas...");
					this.getSqlMapClient().update("postInsertB540GIPIS002A", packParId);
				}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
				Map<String, Object> isPackWPolGeninExistMap = new HashMap<String, Object>();
				isPackWPolGeninExistMap.put("packParId", packParId.toString());
				this.getSqlMapClient().queryForObject("isExistGipiPackWPolGenin", isPackWPolGeninExistMap);
				String isPackWPolGeninExist = (String) isPackWPolGeninExistMap.get("exist");
				
				if("".equals(gipiPackWPolGenin.getDspInitialInfo()) && ("".equals(gipiPackWPolGenin.getDspGenInfo()))){
					//log.info("Deleting GIPI_Pack_WPolGenin record...");
					//this.getSqlMapClient().delete("deleteGipiPackWPolGenin", packParId);
					if("1".equals(isPackWPolGeninExist)){
						log.info("Saving GIPI_Pack_WPolGenin record...");
						this.getSqlMapClient().insert("saveGipiPackWPolGenin", gipiPackWPolGenin);
					}
				}else{
					log.info("Saving GIPI_Pack_WPolGenin record...");
					this.getSqlMapClient().insert("saveGipiPackWPolGenin", gipiPackWPolGenin);
				}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
				if("0".equals(isPackWPolGeninExist)){
					log.info("B550_POST_INSERT - Inserting record/s in gipi_wpolgenin...");
					this.getSqlMapClient().update("postInsertB550GIPIS002A", packParId);
				}else{ // added by: Nica 2.28.2013 - to update the GIPI_WPOLGENIN records of the sub-PARs
					log.info("Updating record/s in gipi_wpolgenin...");
					this.getSqlMapClient().update("postUpdateB550GIPIS002A", packParId);
				}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
				// insert, update, delete mortgagee
				if((params.get("mortgageeInsList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeInsList")).size() > 0) || 
					(params.get("mortgageeDelList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeDelList")).size() > 0)){				
					updateMortgageeRecords(params);
				}
			this.getSqlMapClient().executeBatch();
			// end key-commit
			
			// post-form-commit
			this.getSqlMapClient().startBatch();
				log.info("Saving PAR Hist...");
				Map<String, Object> parHistMap = new HashMap<String, Object>();
				parHistMap.put("packParId", packParId);
				parHistMap.put("userId", gipiPackWPolbas.getUserId());
				parHistMap.put("entrySource", "");
				parHistMap.put("parStatCd", "3");
				this.getSqlMapClient().insert("insertPackParHist", parHistMap);
				
				log.info("Updating PAR status...");
				this.getSqlMapClient().update("updatePackParStatusGIPIS002A", packParId);
				
				log.info("Updating GIUW_POL_DIST...");
				Map<String, Object> polDistMap = new HashMap<String, Object>();
				polDistMap.put("packParId", packParId);
				polDistMap.put("effDate", gipiPackWPolbas.getEffDate() == null ? gipiPackWPolbas.getInceptDate() : gipiPackWPolbas.getEffDate());
				polDistMap.put("expiryDate", gipiPackWPolbas.getExpiryDate());
				this.getSqlMapClient().update("updatePolDistGIPIS002A", polDistMap);
				
				log.info("Updating assd_no in GIPI_PACK_PARLIST...");
				Map<String, Object> assdParamMap = new HashMap<String, Object>();
				assdParamMap.put("packParId", packParId);
				assdParamMap.put("assdNo", gipiPackWPolbas.getAssdNo());
				this.getSqlMapClient().update("updateGipiPackParListAssdNo", assdParamMap);
				
				// recreates invoice
				if(createInvoiceSw.equals("Y")){
					log.info("Recreating invoice...");
					this.getSqlMapClient().update("postFormCommitGIPIS002A", packParId);
				}
			this.getSqlMapClient().executeBatch();
			// end of postFormCommit
			
			//insert individual polnrep here
			this.getSqlMapClient().startBatch();
				if("2".equals(gipiPackWPolbas.getPolFlag()) || "3".equals(gipiPackWPolbas.getPolFlag())){
					String[] insOldPolicyIds = (String[]) gipiPackWPolnrepMap.get("insOldPolicyIds");
					if(insOldPolicyIds != null){
						for(int i=0; i<insOldPolicyIds.length; i++) {
							String polNRep = insOldPolicyIds[i];
							Map<String, Object> polnRepMap = new HashMap<String, Object>();
							polnRepMap.put("userId", gipiPackWPolbas.getUserId());
							polnRepMap.put("packParId", packParId);
							polnRepMap.put("oldPackPolicyId", polNRep);
							System.out.println("setWpolnRepForPack: "+polnRepMap);
							this.getSqlMapClient().update("setWpolnRepForPack", polnRepMap);
						}
					}
				}
			this.getSqlMapClient().executeBatch();
			//
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("End of saving Basic Info for Package PAR...");
		}catch(SQLException e){
			log.info("Error while Saving Package PAR Basic Info.");
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e; 
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return paramsResult;
	}

	@Override
	public Map<String, Object> checkPackParExistingTables(Integer packParId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", packParId.toString());
		this.getSqlMapClient().queryForObject("getPackTableExist", params);
		return params;
	}
	
	private void deleteGIPIPackWPolnreps (Integer packParId, String[] delOldPolicyIds) throws SQLException{
		if(delOldPolicyIds != null){
			for(String delOldPolicyId: delOldPolicyIds){
				log.info("Deleting GIPIPackWPolnrep with Pack_Par_id: " + packParId + " and old_pack_policy_id: " + delOldPolicyId);
				Map<String, Object> delPackWPolnrepParams = new HashMap<String, Object>();
				delPackWPolnrepParams.put("packParId", packParId);
				delPackWPolnrepParams.put("oldPackPolicyId", delOldPolicyId);
				this.getSqlMapClient().delete("deletePackWPolnrep", delPackWPolnrepParams);
			}
			log.info(delOldPolicyIds.length + " records deleted in GIPI_PACK_WPOLNREP.");
		}
	}
	
	private void insertGIPIPackWPolnreps (Integer packParId, String[] insOldPolicyIds, String polFlag, String userId) throws SQLException{
		if(insOldPolicyIds != null){
			for(String insOldPolicyId : insOldPolicyIds){
				log.info("Inserting GIPIPackWPolnrep with Pack_Par_id : " + packParId + " and old_pack_policy_id: " + insOldPolicyId);
				Map<String, Object> insPackWPolnrepParams = new HashMap<String, Object>();
				insPackWPolnrepParams.put("packParId", packParId);
				insPackWPolnrepParams.put("oldPackPolicyId", insOldPolicyId);
				insPackWPolnrepParams.put("polFlag", polFlag);
				insPackWPolnrepParams.put("userId", userId);
				this.getSqlMapClient().insert("savePackWPolnrep", insPackWPolnrepParams);
			}
			log.info(insOldPolicyIds.length + " records inserted in GIPIPackWPolnrep.");
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#checkPolicyForAffectingEndtToCancel(java.util.Map)
	 */
	@Override
	public String checkPolicyForAffectingEndtToCancel(Map<String, Object> params)
			throws SQLException {
		log.info("DAO calling checkPolicyForAffectingEndtToCancel...");
		return (String) this.getSqlMapClient().queryForObject("checkPolicyForAffectingPackEndtToCancel", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#checkIfExistingInGipiWitmperl(java.lang.Integer)
	 */
	@Override
	public String checkIfExistingInGipiWitmperl(Integer parId)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkPackParIfExistingInGipiWitmperl", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#checkIfExistingInGipiWitem(java.lang.Integer)
	 */
	@Override
	public String checkIfExistingInGipiWitem(Integer parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkPackParIfExistingInGipiWitem", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#getRecordsForPackEndtCancellation(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRecordsForPackEndtCancellation(
			Map<String, Object> params) throws SQLException {
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getRecordsForPackEndtCancellation", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#checkPackEndtForItemAndPeril(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkPackEndtForItemAndPeril(
			Map<String, Object> params) throws SQLException {
		this.sqlMapClient.queryForList("checkPackEndtForItemAndPeril", params);
		return params;
	}


	@Override
	public Map<String, Object> generateBankRefNoForPack(
			Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().update("generateBankRefNoForPack", params);
			log.info("Bank Reference No. successfully generated for pack_par_id: " + params.get("packParId"));
		}catch(SQLException e){
			log.info("Error while generating bank reference No.");
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#preGetAmountsForPackEndt(java.util.Map)
	 */
	@Override
	public String preGetAmountsForPackEndt(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("preGetAmountsForPackEndt", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#createNegatedRecordsFlat(java.util.Map)
	 */
	@Override
	public Map<String, Object> createNegatedRecordsFlat(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling createNegatedRecordsFlat...");

		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().update("createNegatedRecordsFlatForPackEndt", params);
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	@Override
	public String validatePackRefPolNo(Integer packParId, String refPolNo)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("packParId", packParId.toString());
		params.put("refPolNo", refPolNo);
		return this.sqlMapClient.queryForObject("validatePackRefPolNo", params).toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO#validatePackEndtEffDate(java.util.Map)
	 */
	@Override
	public Map<String, Object> validatePackEndtEffDate(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("validatePackEndtEffDate", params);
		return params;
	}
	
	//belle 07.17.2012 updates gipi_winvoice when booking date was changed in basic info.	
	@Override
	public void preCommitGIPIS002AInvoice(Integer bookingYear,
			String bookingMth, Integer parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", parId);
		params.put("bookingYear", bookingYear);
		params.put("bookingMth", bookingMth);
		this.sqlMapClient.update("preCommitGIPIS002AInvoice", params);
	}

	@Override
	public Map<String, Object> processPackEndtCancellation(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling processPackEndtCancellation...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			log.info("params: "+params);
			this.getSqlMapClient().update("processPackEndtCancellation", params);
			this.getSqlMapClient().getCurrentConnection().rollback(); 
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
	@Override
	public Map<String, Object> searchForEditedPackPolicy(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("searchForPackPolicy", params);
		return params;
	}	
}
