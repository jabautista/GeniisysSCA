/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.controllers.GIPIPARListController;
import com.geniisys.gipi.dao.GIPIPARListDAO;
import com.geniisys.gipi.dao.GIPIQuoteDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.exceptions.PostedRIExistingException;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.giri.dao.GIRIWInPolbasDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;


/**
 * The Class GIPIPARListDAOImpl.
 */
public class GIPIPARListDAOImpl implements GIPIPARListDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private GIPIQuoteDAO gipiQuoteDAO;
	
	private GIRIWInPolbasDAO giriWInPolbasDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPARListDAOImpl.class);

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	public GIPIQuoteDAO getGipiQuoteDAO() {
		return gipiQuoteDAO;
	}

	public void setGipiQuoteDAO(GIPIQuoteDAO gipiQuoteDAO) {
		this.gipiQuoteDAO = gipiQuoteDAO;
	}
	
	public GIRIWInPolbasDAO getGiriWInPolbasDAO() {
		return giriWInPolbasDAO;
	}

	public void setGiriWInPolbasDAO(GIRIWInPolbasDAO giriWInPolbasDAO) {
		this.giriWInPolbasDAO = giriWInPolbasDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#saveGIPIPAR(com.geniisys.gipi.entity.GIPIPARList)
	 */
	@Override
	public void saveGIPIPAR(GIPIPARList gipipar) throws SQLException {
		try {
			log.info("Saving PAR at DAO...");
			log.info("parId: "+gipipar.getParId());
			log.info("lineCd: "+gipipar.getLineCd());
			log.info("issCd: "+gipipar.getIssCd());
			log.info("parYy: "+gipipar.getParYy());
			log.info("parSeqNo: "+gipipar.getParSeqNo());
			log.info("quoteSeqNo: "+gipipar.getQuoteSeqNo());
			log.info("parType: "+gipipar.getParType());
			log.info("assignSw: "+gipipar.getAssignSw());
			log.info("parStatus: "+gipipar.getParStatus());
			log.info("quoteId: "+gipipar.getQuoteId());
			log.info("assuredNo: "+gipipar.getAssdNo());
			log.info("address1: "+gipipar.getAddress1());
			log.info("remarks: "+gipipar.getRemarks());
			
			this.getSqlMapClient().queryForObject("saveGIPIPAR", gipipar);
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", gipipar.getParId());
			params.put("address1", gipipar.getAddress1());
			params.put("address2", gipipar.getAddress2());
			params.put("address3", gipipar.getAddress3());
			this.getSqlMapClient().queryForObject("updateAddress", params);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} 
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#getGIPIPARDetails(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GIPIPARList getGIPIPARDetails(Integer parId, Integer packParId)
			throws SQLException {
		log.info("Getting PAR informations for PAR ID "+parId);
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("parId", parId);
		params.put("packParId", packParId);
		GIPIPARList par = (GIPIPARList) this.getSqlMapClient().queryForObject("getGIPIPARDetails", params);
		//System.out.println(par.getParId());
		//log.info("Detains for PAR ID "+par.getParId()+" successfully obtained...");
		return par;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#getGIPIPARDetails(java.lang.Integer)
	 */
	@Override
	public GIPIPARList getGIPIPARDetails(Integer parId)
			throws SQLException {
		log.info("Getting PAR informations for PAR ID "+parId);
		GIPIPARList par = (GIPIPARList) this.getSqlMapClient().queryForObject("getGIPIPARDetailsFromParId", parId);
		log.info("PAR details successfully obtained...");
		return par;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#getNewParId()
	 */
	@Override
	public Integer getNewParId() throws SQLException {
		log.info("Obtaining new PAR ID...");
		GIPIPARList par = (GIPIPARList) this.getSqlMapClient().queryForObject("getNewParId");
		log.info("New PAR ID: "+par.getParId());
		return par.getParId();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#getGipiParList(java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getGipiParList(String lineCd, String keyword, String userId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("keyword", keyword);
		params.put("userId", userId);
		log.info("PARAMS: " + params);
		return this.getSqlMapClient().queryForList("getGipiParList", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#checkParQuote(java.lang.Integer)
	 */
	@Override
	public String checkParQuote(Integer parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkParQuote", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#updateStatusFromQuote(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void updateStatusFromQuote(Integer quoteId, Integer parStatus)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("parStatus", parStatus);
		this.getSqlMapClient().queryForObject("updateStatusFromQuote", params);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#insertParHist(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public void insertParHist(Integer parId, String userId, String entrySource,
			String parstatCd) throws SQLException {
		log.info("Inserting PAR history info...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("userId", userId);
		params.put("entrySource", entrySource);
		params.put("parstatCd", parstatCd);
		this.getSqlMapClient().queryForObject("insertPARHist", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#deleteBill(java.lang.Integer)
	 */
	@Override
	public void deleteBill(Integer parId) throws SQLException {
		log.info("Deleting PAR bill records for "+parId+" ...");
		//Map<String, Object> params = new HashMap<String, Object>();
		//params.put("parId", parId);
		log.info("2");
		try{
			this.getSqlMapClient().queryForObject("deleteBillsDetails", parId);
			log.info("Bill records deleted.");
		} catch (Exception e) {
			log.info(e);
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#setParStatusToWithPeril(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void setParStatusToWithPeril(Integer parId, Integer packParId)
			throws SQLException {
		log.info("Setting new PAR status...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("packParId", packParId);
		this.getSqlMapClient().queryForObject("setParStatusToWithPeril", params);
		log.info("Completed.");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#setParStatusToWithPeril(java.lang.Integer)
	 */
	@Override
	public void setParStatusToWithPeril(Integer parId) throws SQLException {
		log.info("Setting new PAR status...");
		this.getSqlMapClient().queryForObject("setParStatusToWithPeril1", parId);
		log.info("Completed.");
	}

	@Override
	public void updatePARStatus(Integer parId, Integer parStatus)
			throws SQLException {
		log.info("Updating PAR status to "+parStatus+"...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("parStatus", parStatus);
		this.getSqlMapClient().queryForObject("updatePARStatus", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getEndtParList(String lineCd, String keyword, String userId)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("keyword", keyword);
		params.put("userId", userId);
		log.info("PARAMS: " + params);
		return this.getSqlMapClient().queryForList("getEndtParList", params);
		
	}

	@Override
	public String getParNo(Integer parId) throws SQLException {		
		return (String) this.getSqlMapClient().queryForObject("getParNo", parId);
	}
	
	public String getParNo2(Integer policyId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getParNo2", policyId);
	}

	/* copy related methods*/
	
	@SuppressWarnings("unchecked")
	@Override
	//public void copyParList(Map<String, Object> parameters) throws SQLException, Exception {
	public String copyParList(Map<String, Object> parameters) throws SQLException, Exception {
		Map<String, Object> params = parameters;
		String newParNo = "";
		String parId = params.get("parId").toString();
		String lineCd = params.get("lineCd").toString();
		Map<String, Object> status = (Map<String, Object>) GIPIPARListController.status.get(parId);//new HashMap<String, Object>();
		try {
			log.info("Started copying "+parId+" information...");
			this.updateStatusMap(parId, status);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Debug.print("Before params: " + params);
			this.getSqlMapClient().insert("copyParList", params);
			Debug.print("After params: " + params);
			
			String menulineCd = params.get("menuLine") == null ? "" : params.get("menuLine").toString();
			
			status.put("message", "Copying basic information...");
			log.info("Copying basic information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPolBas", params);
					
			status.put("message", "Copying general information...");
			log.info("Copying general information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPolGenin", params);
			
			status.put("message", "Copying open policy information...");
			log.info("Copying open policy information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWOpenPolicy", params);
			
			status.put("message", "Copying limit of liability information...");
			log.info("Copying limit of liability information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWLimLiab", params);
			
			status.put("message", "Copying casualty personnel information...");
			log.info("Copying casualty personnel information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPackLineSubline", params);
			
			status.put("message", "Copying item information...");
			log.info("Copying item information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWItem", params);
			
			status.put("message", "Copying item peril information...");
			log.info("Copying item peril information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWItmPerl", params);
			
			status.put("message", "Copying invoice information...");
			log.info("Copying invoice information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWInvoice", params);
			
			status.put("message", "Copying invoice peril information...");
			log.info("Copying invoice peril information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWInvPerl", params);
			
			status.put("message", "Copying installment information...");
			log.info("Copying installment information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWInstallment", params);
			
			status.put("message", "Copying invoice tax information...");
			log.info("Copying invoice tax information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWInvTax", params);
			
			status.put("message", "Copying policy discount info...");
			log.info("Copying policy discount info...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPolBasDiscount", params);
			
			status.put("message", "Copying policy discount info...");
			log.info("Copying policy discount info...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWItemDiscount", params);
			
			status.put("message", "Copying peril discount information...");
			log.info("Copying peril discount information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPerilDiscount", params);
			
			status.put("message", "Copying item peril information...");
			log.info("Copying item peril information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyCoIns", params);
			
			status.put("message", "Copying endorsement text information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWEndtText", params);
			
			status.put("message", "Copying commission invoice information...");
			log.info("Copying commission invoice information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWCommInvoices", params);
			
			status.put("message", "Copying commission invoice peril information...");
			log.info("Copying commission invoice peril information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWCommInvPerils", params);
			
			status.put("message", "Copying Mortgagee information...");
			log.info("Copying Mortgagee information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWMortgagee", params);
			
			status.put("message", "Copying Original Commission Invoice information...");
			log.info("Copying Original Commission Invoice information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigCommInvoice", params);
			
			status.put("message", "Copying Original Commission Invoice Peril information...");
			log.info("Copying Original Commission Invoice Peril information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigCommInvPeril", params);
			
			status.put("message", "Copying Original Invoice information...");
			log.info("Copying Original Invoice information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigInvoice", params);
			
			status.put("message", "Copying original invoice peril info ...");
			log.info("Copying original invoice peril info ...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigInvPeril", params);
			
			status.put("message", "Copying original invoice tax info...");
			log.info("Copying original invoice tax info...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigInvTax", params);
			
			status.put("message", "Copying original item peril info...");
			log.info("Copying original item peril info...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigItmPeril", params);
			
/*			status.put("message", "Copying original item peril info...");
			log.info("Copying original item peril info...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyOrigItmPeril", params);*/
			
			if("FI".equals(lineCd) || "FI".equals(menulineCd)) {
				status.put("message", "Copying fire item information...");
				log.info("Copying fire item information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWFireItm", params);
			} else if ("MC".equals(lineCd) || "MC".equals(menulineCd)) {
				status.put("message", "Copying vehicle information...");
				log.info("Copying vehicle information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWVehicle", params);
				
				status.put("message", "Copying motor car accessory information...");
				log.info("Copying motor car accessory information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWMcacc", params);
			} else if ("AC".equals(lineCd) || "AC".equals(menulineCd)) {
				status.put("message", "Copying accident item information...");
				log.info("Copying accident item information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWAccidentItem", params);
				
				status.put("message", "Copying beneficiary information...");
				log.info("Copying beneficiary information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWBeneficiary", params);
				
				status.put("message", "Copying casualty personnel information...");
				log.info("Copying casualty personnel information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWGroupedItems", params);
				
				status.put("message", "Copying beneficiary information...");
				log.info("Copying beneficiary information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWGrpItemsBeneficiary", params);
			} else if ("MH".equals(lineCd) || "MC".equals(menulineCd)) {
				status.put("message", "Copying item vessel information...");
				log.info("Copying item vessel information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWItemVes", params);
			} else if ("MN".equals(lineCd) || "MN".equals(menulineCd)) {
				status.put("message", "Copying cargo item information...");
				log.info("Copying cargo item information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWCargo", params);
				
				status.put("message", "Copying vessel air information...");
				log.info("Copying vessel air information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWVesAir", params);
				
				status.put("message", "Copying vessel accumulation information...");
				log.info("Copying vessel accumulation information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWVesAccumulation", params);
				
				status.put("message", "Copying open liability information...");
				log.info("Copying open liability information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWOpenLiab", params);
				
				status.put("message", "Copying open policy cargo information...");
				log.info("Copying open policy cargo information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWOpenCargo", params);
				
				status.put("message", "Copying open policy peril information...");
				log.info("Copying open policy peril information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWOpenPeril", params);
			} else if ("CA".equals(lineCd) || "CA".equals(menulineCd)) {
				status.put("message", "Copying casualty item information...");
				log.info("Copying casualty item information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWCasualtyItem", params);
				
				status.put("message", "Copying casualty personnel information...");
				log.info("Copying casualty personnel information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWCasualtyPersonnel", params);
				
				status.put("message", "Copying casualty grouped items information...");
				log.info("Copying casualty grouped items information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWGroupedItems", params);
				
/*				status.put("message", "Copying casualty grouped items information...");
				log.info("Copying casualty grouped items information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWGroupedItems", params);*/
				
				status.put("message", "Copying casualty beneficiary information...");
				log.info("Copying casualty beneficiary information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWGrpItemsBeneficiary", params);
				
				status.put("message", "Copying bank schedule information...");
				log.info("Copying bank schedule information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWBankSchedule", params);
			} else if ("EN".equals(lineCd) || "EN".equals(menulineCd)) {
				status.put("message", "Copying engineering basic information...");
				log.info("Copying engineering basic information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWEnggBasic", params);
				
				status.put("message", "Copying location information...");
				log.info("Copying location information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWLocation", params);
				
				status.put("message", "Copying principal information...");
				log.info("Copying principal information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWPrincipal", params);
			} else if ("SU".equals(lineCd) || "SU".equals(menulineCd)) {
				status.put("message", "Copying bond basic information...");
				log.info("Copying bond basic information...");
				this.updateStatusMap(parId, status);
				StringBuilder sb = new StringBuilder();
				sb.append(params.get("endtText01")== null ? "" : params.get("endtText01").toString());
				sb.append(params.get("endtText02")== null ? "" : params.get("endtText02").toString());
				sb.append(params.get("endtText03")== null ? "" : params.get("endtText03").toString());
				sb.append(params.get("endtText04")== null ? "" : params.get("endtText04").toString());
				sb.append(params.get("endtText05")== null ? "" : params.get("endtText05").toString());
				sb.append(params.get("endtText06")== null ? "" : params.get("endtText06").toString());
				sb.append(params.get("endtText07")== null ? "" : params.get("endtText07").toString());
				sb.append(params.get("endtText08")== null ? "" : params.get("endtText08").toString());
				sb.append(params.get("endtText09")== null ? "" : params.get("endtText09").toString());
				sb.append(params.get("endtText10")== null ? "" : params.get("endtText10").toString());
				sb.append(params.get("endtText11")== null ? "" : params.get("endtText11").toString());
				sb.append(params.get("endtText12")== null ? "" : params.get("endtText12").toString());
				sb.append(params.get("endtText13")== null ? "" : params.get("endtText13").toString());
				sb.append(params.get("endtText14")== null ? "" : params.get("endtText14").toString());
				sb.append(params.get("endtText15")== null ? "" : params.get("endtText15").toString());
				sb.append(params.get("endtText16")== null ? "" : params.get("endtText16").toString());
				sb.append(params.get("endtText17")== null ? "" : params.get("endtText17").toString());
				params.put("pLong", sb.toString());
				this.getSqlMapClient().update("copyWBondBasic", params);
				
				status.put("message", "Copying cosignatory information...");
				log.info("Copying cosignatory information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWCoSignatory", params);
			} else if ("AV".equals(lineCd) || "AV".equals(menulineCd)) {
				status.put("message", "Copying aviation item information...");
				log.info("Copying aviation item information...");
				this.updateStatusMap(parId, status);
				this.getSqlMapClient().update("copyWAviationItem", params);
			}
			
			status.put("message", "Copying warranties and clauses information...");
			log.info("Copying warranties and clauses information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPolWc", params);
			
			status.put("message", "Copying policy distribution...");
			log.info("Copying policy distribution...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWPolDist", params);
			
			status.put("message", "Copying deductibles information...");
			log.info("Copying deductibles information...");
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().update("copyWDeductibles", params);
			
			//int itemCount = (Integer) this.getSqlMapClient().queryForObject("getWItemCount", parId);
			
			Map<String, Object> isExistMapWItmperl = new HashMap<String, Object>();
			isExistMapWItmperl.put("parId", parId);
			isExistMapWItmperl.put("exist", "");
			
			this.getSqlMapClient().queryForObject("isExistWItmperl", isExistMapWItmperl);
			
			String isExistWItmperl = (String) isExistMapWItmperl.get("exist");
			
			//for (int i=1; i<=itemCount; i++) { // replaced by: nica 04.14.2011
			if(isExistWItmperl.equals("1")){
				if ("N".equals(params.get("openFlag").toString())) {
					status.put("message", "Creating invoice information...");
					log.info("Creating invoice information...");
					this.updateStatusMap(parId, status);
					this.getSqlMapClient().update("createWInvoiceForCopyPar", params);
					
					status.put("message", "Creating distribution information...");
					log.info("Creating distribution information...");
					this.updateStatusMap(parId, status);
					this.getSqlMapClient().update("crBillDistGetTsi", params);
				} else {
					Map<String, Object> newParams = new HashMap<String, Object>();
					newParams.put("parId", Integer.parseInt(params.get("newParId").toString()));
					newParams.put("parStatus", 6);
					this.getSqlMapClient().update("updatePARStatus", newParams);
				}
			}
			
			status.put("message", "Saving all changes...");
			log.info("Saving all changes...");
			this.updateStatusMap(parId, status);
			System.out.println("Copy ------ " + parId +" to "+ params.get("newParId"));
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			status.put("message", "Successfully copied PAR...");
			log.info("Successfully copied PAR...");
			this.updateStatusMap(parId, status);
			
			newParNo = getParNo((Integer) params.get("newParId"));
			System.out.println("Copied par no to " + newParNo);
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			status.put("message", "ERROR - " + e.getCause());
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			status.put("message", "ERROR - " + e.getCause());
			this.updateStatusMap(parId, status);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return newParNo;
	}
	
	private void updateStatusMap(String parId, Map<String, Object> status) {
		GIPIPARListController.status.put(parId, status);
	}

	@Override
	public void deletePar(Map<String, Object> params) throws SQLException, Exception {
		int parId = (Integer) params.get("parId");
		String lineCd = params.get("lineCd").toString();
		//String menuLineCd = params.get("menuLineCd").toString();
		String menuLineCd = params.get("lineCd").toString();
		String user = params.get("userId").toString();
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("deleteParHist", params);
			
			this.getSqlMapClient().delete("deleteWPolWc", parId);
			
			if ("FI".equals(lineCd) || "FI".equals(menuLineCd)) {
				this.getSqlMapClient().delete("deleteFireWorkfile", parId);
				this.getSqlMapClient().update("resetInspReportStatus", params); //marco - 08.05.2014
			} else if ("MC".equals(lineCd) || "MC".equals(menuLineCd)) {
				this.getSqlMapClient().delete("deleteMotorcarWorkfile", parId);
			} else if ("AC".equals(lineCd) || "AC".equals(menuLineCd)) {
				this.getSqlMapClient().delete("deleteAccidentWorkfile", parId);
			} else if ("MH".equals(lineCd) || "MH".equals(menuLineCd)) {
				//this.getSqlMapClient().delete("deleteHullWorkfile", parId);
				this.getSqlMapClient().delete("deleteCargoWorkfile", parId);
			} else if ("MN".equals(lineCd) || "MN".equals(menuLineCd)) {
				//this.getSqlMapClient().delete("deleteCargoWorkfile", parId);
				this.getSqlMapClient().delete("deleteHullWorkfile", parId);
			} else if ("CA".equals(lineCd) || "CA".equals(menuLineCd)) {
				this.getSqlMapClient().delete("deleteCasualtyWorkfile", parId);
			} else if ("EN".equals(lineCd) || "EN".equals(menuLineCd)) {
				this.getSqlMapClient().delete("deleteEngineeringWorkfile", parId);
			} else if ("SU".equals(lineCd) || "SU".equals(params.get("menuLineCd").toString())) {
				this.getSqlMapClient().delete("deleteBondsWorkfile", parId);
			} else if ("AV".equals(lineCd) || "AV".equals(menuLineCd)) {
				this.getSqlMapClient().delete("deleteAviationWorkfile", parId);
			}
			
			this.getSqlMapClient().delete("deleteByPackPolFlag", parId);
			
			//this.getSqlMapClient().delete("deleteExpiry", parId);
	
			this.getSqlMapClient().delete("deleteParDistribution", parId);
	
			this.getSqlMapClient().delete("deleteOthWorkfile", parId);
			
			this.getSqlMapClient().delete("deleteWPolnRep", parId);
			
			this.getSqlMapClient().delete("deleteWPolBas", parId);
			
			this.getSqlMapClient().delete("deleteWorkFlowRec", this.prepareParamsForDeleteWorkFlowRec("PAR-Policy (ready for posting)","GIPIS085", user, params.get("parId").toString()));
			
			this.getSqlMapClient().delete("deleteWorkFlowRec", this.prepareParamsForDeleteWorkFlowRec("Facultative Placement","GIUWS003", user, params.get("parId").toString()));
			
			this.getSqlMapClient().delete("deleteWorkFlowRec", this.prepareParamsForDeleteWorkFlowRec("Facultative Placement","GIUWS004", user, params.get("parId").toString()));
			
			// get par items attachments
			List<String> attachments = this.getSqlMapClient().queryForList("getParAttachments", parId);
			
			// delete attachment record
			this.getSqlMapClient().delete("delParAttachments", parId);
			
			// delete attachments
			FileUtil.deleteFiles(attachments);
			
			params.put("parStatus", 99);
			this.getSqlMapClient().update("updatePARStatus", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Successfully deleted PAR...");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/**
	 * 
	 */
	@Override
	public void setPackageMenu(Integer packParId) throws SQLException {
		log.info("Updating package details...");
		this.getSqlMapClient().queryForObject("setPackageMenu1", packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#saveParCreationPageChanges(java.util.Map)
	 */
	@Override
	public Map<String, Object> saveParCreationPageChanges(
			Map<String, Object> params) throws SQLException, Exception {
		GIPIPARList preparedPAR = (GIPIPARList) params.get("preparedPAR");
		String fromQuote = (String) params.get("fromQuote");
		String hasGIPIWPolBasDetails = (String) params.get("fromQuote");
		Integer quoteId = 0;
		Integer assdNo = 0;
		String issCd = "";
		String lineCd = "";
		
		Integer parId = preparedPAR.getParId();
		if (0 == parId){
			parId = this.getNewParId();
			preparedPAR.setParId(parId);
		}
		
		log.info("fromQuote: "+fromQuote);
		if ("Y".equals(fromQuote)){
			quoteId = (Integer) params.get("quoteId");
			assdNo = (Integer) params.get("assdNo");
			issCd = (String) params.get("issCd");
			lineCd = (String) params.get("lineCd");
			
			Map<String, Object> updateQuoteParams = new HashMap<String, Object>();
			updateQuoteParams.put("quoteId", preparedPAR.getQuoteId());
			updateQuoteParams.put("assdNo", preparedPAR.getAssdNo()); //assdNo);
			updateQuoteParams.put("issCd", preparedPAR.getIssCd()); //issCd);
			updateQuoteParams.put("lineCd", preparedPAR.getLineCd()); //lineCd);
			updateQuoteParams.put("userId", preparedPAR.getUserId());
			System.out.println("USER ID:::::::"+preparedPAR.getUserId());
			this.getGipiQuoteDAO().saveQuoteToParUpdates(updateQuoteParams);			
		}
		this.saveGIPIPAR(preparedPAR);
		
		if ("Y".equals(fromQuote)){
			//if ("N".equals(hasGIPIWPolBasDetails)){
				Map<String, Object> insertPolbasicParams = new HashMap<String, Object>();
				String userId = (String) params.get("userId");
				insertPolbasicParams.put("quoteId", preparedPAR.getQuoteId()); // quoteId);
				insertPolbasicParams.put("assdNo", preparedPAR.getAssdNo()); //assdNo);
				insertPolbasicParams.put("issCd", preparedPAR.getIssCd()); // issCd);
				insertPolbasicParams.put("lineCd", preparedPAR.getLineCd()); // lineCd);
				insertPolbasicParams.put("userId", preparedPAR.getUserId()); // userId);
				insertPolbasicParams.put("parId", parId);
				insertPolbasicParams.put("message", "");
				insertPolbasicParams.put("underwriter", userId);
				
				//this.getSqlMapClient().update("insertGipiWPolbasicDetailsForPAR", params);
				System.out.println("ASSD NO::::::"+ preparedPAR.getAssdNo());
				System.out.println("PARID ------------------------>"+parId);
				log.info("Inserting Quotation to PAR...");
				this.getSqlMapClient().update("insertQuoteToPAR", insertPolbasicParams);
			//}
		}
		
		GIPIPARList savedPAR = this.getGIPIPARDetails(parId);
		params.put("savedPAR", savedPAR);
		return params;
	}

	@Override
	public void returnPARToQuotation(int quoteId) throws SQLException {
		log.info("Returning PAR into quote for id "+quoteId+"...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.updateStatusFromQuote(quoteId, 99);
			this.getGipiQuoteDAO().updateStatusFromPar(quoteId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Successfully returned quote...");
		} catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPARListDAO#cancelPar(java.util.Map)
	 */
	@Override
	public void cancelPar(Map<String, Object> params) throws SQLException,
			Exception {
//		int parId = (Integer) params.get("parId");
		//String lineCd = params.get("lineCd").toString();
		//String menuLineCd = params.get("lineCd").toString();
		String user = params.get("userId").toString();
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			params.put("parStatus", 98);
			this.getSqlMapClient().update("updatePARStatus", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().delete("deleteWorkFlowRec", this.prepareParamsForDeleteWorkFlowRec("PAR-Policy (ready for posting)","GIPIS085", user, params.get("parId").toString()));
			this.getSqlMapClient().delete("deleteWorkFlowRec", this.prepareParamsForDeleteWorkFlowRec("Facultative Placement","GIUWS003", user, params.get("parId").toString()));
			this.getSqlMapClient().delete("deleteWorkFlowRec", this.prepareParamsForDeleteWorkFlowRec("Facultative Placement","GIUWS004", user, params.get("parId").toString()));
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().insert("saveCancelledRecToParHist", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Successfully cancelled PAR...");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getGipiParListing(HashMap<String, Object> params)
			throws SQLException {
		List<GIPIPARList> parList = new ArrayList<GIPIPARList>();
		if(params.get("parType").equals("P")){
			System.out.println("params : "+params.get("issCd"));
			parList = this.getSqlMapClient().queryForList("getGipiParListTableGrid", params);
		}else if(params.get("parType").equals("E")){
			parList = this.getSqlMapClient().queryForList("getEndtGipiParListTableGrid", params);
		}
		return parList;
	}

	@Override
	public Map<String, Object> checkRITablesBeforePARDeletion(Integer parId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		this.sqlMapClient.update("checkRIBeforePARDeletion", params);
		return params;
	}
	
	private HashMap<String, Object> prepareParamsForDeleteWorkFlowRec(String eventDesc, String moduleId, String user, String colValue){
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("eventDesc", eventDesc);
		params.put("moduleId", moduleId);
		params.put("user", user);
		params.put("colValue", colValue);
		return params;
	}

	@Override
	public void updateParRemarks(List<GIPIPARList> updatedRows)
			throws SQLException {
		if(updatedRows != null){
			log.info("Updated rows: " + updatedRows);
			for(GIPIPARList par : updatedRows){
				log.info("Updated remarks for parId: " + par.getParId());
				this.getSqlMapClient().update("updateParRemarks", par);
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getPackItemParList(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPackItemParList", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getAllPackItemParList(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getAllPackItemParList", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getParAssuredList(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getParAssuredList", params);
	}	
	
	public String checkParlistDependency(Integer inspNo)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkParlistDependency", inspNo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveInitialAcceptance(Map<String, Object> params, int mode)
			throws SQLException {
		Integer parId = 0;
		GIPIPARList gipiPar = (GIPIPARList) params.get("preparedPar");
		Debug.print(gipiPar);
		parId = gipiPar.getParId();		
		if(mode==0) {
			if(parId == 0) {
				parId = this.getNewParId();
				gipiPar.setParId(parId);
			}
			
			this.saveGIPIPAR(gipiPar);
		}
		
		//GIRIWInPolbas winpolbas = (GIRIWInPolbas) params.get("setWInPolbas");
		Map<String, Object> winpolbas = (Map<String, Object>) params.get("setWInPolbas");
		
		if(winpolbas != null) {
			/*if(winpolbas.getParId() == 0) {
				winpolbas.setParId(parId);
			}*/
			if(0 == (Integer) winpolbas.get("parId") && mode == 0) {
				System.out.println("Assign new par id for WInpolbas - "+parId);
				winpolbas.put("parId", parId);
			}
			this.getGiriWInPolbasDAO().saveGIRIWInPolbas(winpolbas);
		}
		params.put("savedPAR", this.getGIPIPARDetails(parId));
		params.put("savedWInPolbas", this.getGiriWInPolbasDAO().getGIRIWInPolbasForPAR(parId));
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getPackPolicyList(Integer packParId)
			throws SQLException {
		return this.sqlMapClient.queryForList("getPackPolicyList", packParId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getParEndorsementTypeList(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getPolicyPerEndorsementType", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPARList> getParListGIPIS031A(Integer packParId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getParlistByPackParId", packParId);
	}

	@Override
	public Integer generateParIdGiuts008a() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("generateParIdGiuts008a");
	}

	@Override
	public Map<String, Object> insertParListGiuts008a(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().insert("insertParListGiuts008a", params);
		return null;
	}
	
	public Map<String, Object> copyParToParGiuts007(Map<String, Object> params)
			throws SQLException {
		String newParNo = "";
		Debug.print("Before params: " + params);
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().update("copyParToParGiuts007", params);
			newParNo = (String) params.get("newParNo");
			System.out.println("newParNo  "+newParNo);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			if(e.getErrorCode() == 20001){
				throw new PostedRIExistingException(e.getCause().getMessage());
			}else{
				throw new SQLException(e.getCause());
			}
		} finally {
			this.sqlMapClient.endTransaction();
			
		}
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIPARList> getParStatusGiuts007(HashMap<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("parCheckStatusGiuts007", params);
	}

	@Override
	public String getSharePercentageGipis085(Integer parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getSharePercentageGipis085", parId);
	}

	@Override
	public Integer whenNewFormInstGipis017B(Integer parId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("whenNewFormInstGipis017B", parId);
	}

	@Override
	public String checkForPostedBinder(Integer parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		return (String) this.sqlMapClient.queryForObject("checkForPostedBinder", params);
	}

	@Override
	public String checkIfInvoiceExistsRI(Integer parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		return (String) this.sqlMapClient.queryForObject("checkIfInvoiceExistsRI", params);
	}

	@Override
	public void recreateWInvoiceGiris005(Integer parId) throws SQLException {
		this.getSqlMapClient().update("recreateWInvoiceGiris005", parId);
		this.getSqlMapClient().executeBatch();	
	}
	
	@Override
	public Map<String, Object> checkAllowCancel(Integer parId) //added edgar 02/16/2015
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		this.sqlMapClient.update("checkAllowCancel", params);
		return params;
	}
}
