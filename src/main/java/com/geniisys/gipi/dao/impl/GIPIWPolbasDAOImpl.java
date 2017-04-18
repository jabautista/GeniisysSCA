/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.jdbc.datasource.DataSourceUtils;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.dao.GIPIWPolbasDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.entity.GIPIRefNoHist;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.entity.GIPIWPicture;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.geniisys.gipi.exceptions.InvalidBasicInfoDataException;
import com.geniisys.gipi.exceptions.RecreatingWInvoiceException;
import com.geniisys.giuw.dao.GIUWPolDistDAO;
import com.geniisys.giuw.dao.impl.GIUWPolDistDAOImpl;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIPIWPolbasDAOImpl.
 */
public class GIPIWPolbasDAOImpl implements GIPIWPolbasDAO{
	
	private Logger log = Logger.getLogger(GIPIWPolbasDAOImpl.class);	
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;

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
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#getGipiWPolbas(int)
	 */
	@Override
	public GIPIWPolbas getGipiWPolbas(int parId) throws SQLException {
		log.info("DAO - Getting polbas details for parId - "+parId);
		GIPIWPolbas pol = (GIPIWPolbas) this.getSqlMapClient().queryForObject("getGipiWPolbas", parId);
		log.info("DAO - GIPIWPolbas for " + pol.getParId() + " retrieved...");
		return pol;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#getGipiWPolbasDefault(int)
	 */
	@Override
	public GIPIWPolbas getGipiWPolbasDefault(int parId) throws SQLException {
		return (GIPIWPolbas) this.getSqlMapClient().queryForObject("getGipiWPolbasDefault", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#saveGipiWPolbas(com.geniisys.gipi.entity.GIPIWPolbas)
	 */
	@Override
	public void saveGipiWPolbas(GIPIWPolbas gipiWPolbas) throws SQLException {
		log.info("Saving GIPI_WPOLBAS record for parId - "+gipiWPolbas.getParId());
		this.sqlMapClient.insert("saveGipiWPolbas", gipiWPolbas);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateSubline(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String validateSubline(Integer parId, String lineCd, String sublineCd,
			String paramSublineCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		params.put("paramSublineCd", paramSublineCd);
		return this.sqlMapClient.queryForObject("validateSubline", params).toString();
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateAssdName(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void validateAssdName(Integer parId, String lineCd, String issCd)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		this.sqlMapClient.update("validateAssdName", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateBookingDate(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String validateBookingDate(Integer bookingYear,
			String bookingMth, String issueDate, String inceptDate)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("bookingYear", bookingYear.toString());
		params.put("bookingMth", bookingMth);
		params.put("issueDate", issueDate.toString());
		params.put("inceptDate", inceptDate.toString());
		return this.sqlMapClient.queryForObject("validateBookingDate", params).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateTakeupTerm(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> validateTakeupTerm(Integer parId, String lineCd,
			String issCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		System.out.println("validateTakeupTerm::: "+params);
		this.sqlMapClient.update("validateTakeupTerm", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateCoInsurance(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public String validateCoInsurance(Integer parId, Integer coInsurance)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("coInsurance", coInsurance.toString());
		return this.sqlMapClient.queryForObject("validateCoInsurance", params).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateCoInsurance2(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void validateCoInsurance2(Integer parId, Integer coInsurance)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("coInsurance", coInsurance.toString());
		this.sqlMapClient.update("validateCoInsurance2",params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#deleteBill(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void deleteBill(Integer parId, Integer coInsurance)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("coInsurance", coInsurance.toString());
		this.sqlMapClient.update("deleteBill", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#insertParHist(java.lang.Integer, java.lang.String)
	 */
	@Override
	public void insertParHist(Integer parId, String userId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("userId", userId);
		this.sqlMapClient.update("insertParHist", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#postFormsCommitD(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void postFormsCommitD(Integer parId, Integer assdNo)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("assdNo", assdNo.toString());
		this.sqlMapClient.update("postFormsCommitD", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#updateParStatus(java.lang.Integer)
	 */
	@Override
	public void updateParStatus(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("updateParStatus", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWPolbas", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#getGipiWpolbasCommon(int)
	 */
	@Override
	public GIPIWPolbas getGipiWpolbasCommon(int parId) throws SQLException {
		System.out.println("PAR ID: " + parId);
		return (GIPIWPolbas) this.getSqlMapClient().queryForObject("getGipiWpolbasCommon", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#createWinvoice(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void createWinvoice(Integer parId, String lineCd, String issCd)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		this.sqlMapClient.update("createWinvoice", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateRefPolNo(java.lang.Integer, java.lang.String)
	 */
	@Override
	public String validateRefPolNo(Integer parId, String refPolNo)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("refPolNo", refPolNo);
		return this.sqlMapClient.queryForObject("validateRefPolNo", params).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#newFormInst(java.lang.String)
	 */
	@Override
	public Map<String, String> newFormInst(String issCd,String lineCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("issCd", issCd);
		params.put("lineCd", lineCd);
		this.sqlMapClient.queryForObject("newFormInst", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#getIssueYy(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> getIssueYy(String bookingMth,String bookingYear, String doi,
			String issueDate) throws SQLException {
			Map<String, String> params = new HashMap<String, String>();
			params.put("bookingMth", bookingMth);
			params.put("bookingYear", bookingYear);
			params.put("doi", doi);
			params.put("issueDate", issueDate);
			log.info("--------------------->" + params);			
			this.sqlMapClient.queryForObject("getIssueYy", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#validateExpiryDate(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> validateExpiryDate(Integer parId, String doe)
			throws SQLException {
			Map<String, String> params = new HashMap<String, String>();
			params.put("parId", parId.toString());
			params.put("doe", doe);
			this.sqlMapClient.queryForObject("validateExpiryDate", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#postFormsCommitA(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public Map<String, String> postFormsCommitA(Integer parId,
			Integer coInsurance, String dateSw) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("coInsurance", coInsurance.toString());
		params.put("dateSw", dateSw);
		this.sqlMapClient.queryForObject("postFormsCommitA", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#updatepolDist(java.lang.String, java.lang.Integer, java.lang.String)
	 */
	@Override
	public void updatepolDist(String effDate, Integer parId, String longTermDist)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("effDate", effDate);
		params.put("parId", parId.toString());
		params.put("longTermDist", longTermDist);
		this.sqlMapClient.update("updatePolDist", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#commit()
	 */
	@Override
	public void commit() throws SQLException {
		this.getSqlMapClient().setUserConnection(DataSourceUtils.getConnection(this.getSqlMapClient().getDataSource()));
		//this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.sqlMapClient.update("commit");		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#preFormsCommitA(java.lang.Integer)
	 */
	@Override
	public Map<String, String> preFormsCommitA(Integer parId)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.queryForObject("preFormsCommitA", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#preFormsCommitB(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> preFormsCommitB(String opLineCd,
			String opSublineCd, String opIssCd, String opIssueYy,
			String opPolSeqNo, String opRenewNo, String effDate, String doe)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", opLineCd);
		params.put("opSublineCd", opSublineCd);
		params.put("opIssCd", opIssCd);
		params.put("opIssueYy", opIssueYy);
		params.put("opPolSeqNo", opPolSeqNo);
		params.put("opRenewNo", opRenewNo);
		params.put("effDate", effDate);
		params.put("doe", doe);
		this.sqlMapClient.queryForObject("preFormsCommitB", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#preFormsCommitC(java.lang.Integer)
	 */
	@Override
	public void preFormsCommitC(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("preFormsCommitC", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#preFormsCommitG(java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@Override
	public void preFormsCommitG(Integer bookingYear, String bookingMth,
			Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("bookingYear", bookingYear.toString());
		params.put("bookingMth", bookingMth);
		params.put("parId", parId.toString());
		this.sqlMapClient.update("preFormsCommitG", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#preUpdateB540A(java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> preUpdateB540A(String sublineCd, String refPolNo)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("sublineCd", sublineCd);
		params.put("refPolNo", refPolNo);
		this.sqlMapClient.update("preUpdateB540A", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> saveGipiWPolbasForEndtBond2(Map<String, Object> params)
			throws SQLException {
		Map<String, Object> paramsResult = new HashMap<String, Object>();
		paramsResult.put("message", "SUCCESS");
		log.info("CAO calling saveGipiWPolbasForEndtBond");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
			GIPIWPolbas polbas = (GIPIWPolbas) params.get("gipiWPolbas");
			GIPIWEndtText endtText = (GIPIWEndtText) params.get("gipiWEndtText");
			System.out.println("testing :::: " + endtText.getEndtText01());
			
			GIPIWPolGenin polGenin = (GIPIWPolGenin) params.get("gipiWPolGenin");
			JSONObject variables = new JSONObject(params.get("variables").toString());
			
			System.out.println("testing againg :::: " + polGenin.getGenInfo01());
			
			System.out.println("variables ::::: " + variables.toString());

			log.info("Saving record on GIPI_PARLIST...");
			//gipiParList.setParStatus(6);//post insert 10.6.11
			Map<String, Object> isExistWPolbasMap = new HashMap<String, Object>();
			isExistWPolbasMap.put("parId", gipiParList.getParId().toString());
			this.getSqlMapClient().update("isExistWPolbas", isExistWPolbasMap);
			
			// added by: Nica 08.23.2012 to update par_status to 6 if gipi_wpolbas does not exist
			if((isExistWPolbasMap.get("exist").toString()).equals("0")){
				log.info("Post insert - gipi_wpolbas does not exist.");
				gipiParList.setParStatus(6); // post insert
			}else{
				log.info("Record already exist in gipi_wpolbas where par_id ="+ gipiParList.getParId());
				gipiParList.setParStatus(Integer.parseInt(variables.getString("parStatus")));
			}
			
			this.getSqlMapClient().update("saveGipiParListFromEndt", gipiParList);
			
			log.info("Inserting policy general info for endt bond...");
			this.getSqlMapClient().update("saveGipiWPolGenin", polGenin);
			
			log.info("Inserting endorsement text for endt bond...");
			this.getSqlMapClient().update("saveGipiWEndtTextFromEndt", endtText);
			
			log.info("Inserting gipiWPolbas for endt bond...");
			this.getSqlMapClient().insert("saveGipiWpolbasEndtBond", polbas);
			
			Map<String, Object> wpolbasParams = new HashMap<String, Object>();
			wpolbasParams.put("parId", polbas.getParId());
			wpolbasParams.put("bondSeqNo", polbas.getBondSeqNo());
			this.getSqlMapClient().update("updateGipis165", wpolbasParams);
			
			this.getSqlMapClient().executeBatch();
			
			if ("Y".equals(variables.getString("checkboxChgSw"))) {
				/*if ("Y".equals(variables.getString("endtCancellationFlag")) || "Y".equals(variables.getString("coiCancellationFlag"))){
					block for endorsement cancellation
					this.getSqlMapClient().queryForObject("gipis031DeleteOtherInfo", polbas.getParId());
					
					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("parId", polbas.getParId());
					paramMap.put("lineCd", polbas.getLineCd());
					paramMap.put("sublineCd", polbas.getSublineCd());
					paramMap.put("issCd", polbas.getIssCd());
					paramMap.put("issueYy", polbas.getIssueYy());
					paramMap.put("polSeqNo", polbas.getPolSeqNo());
					paramMap.put("renewNo", polbas.getRenewNo());
					paramMap.put("effDate", polbas.getEffDate());
					paramMap.put("coInsuranceSw", polbas.getCoInsuranceSw());
					
					this.getSqlMapClient().queryForObject("gipis031DeleteRecords", paramMap);
				}else if ("N".equals(variables.getString("endtCancellationFlag")) || "N".equals(variables.getString("coiCancellationFlag"))){
					function for revert cancellation
					Map<String, Object> cancelParams = new HashMap<String, Object>();
					
					cancelParams = loadPolicyNoToMap(polbas.getLineCd(), polbas.getSublineCd(), polbas.getIssCd(),
							polbas.getIssueYy(), polbas.getPolSeqNo(), Integer.parseInt(polbas.getRenewNo()));
					cancelParams.put("parId", polbas.getParId());
					cancelParams.put("effDate", polbas.getEffDate());
					cancelParams.put("coInsuranceSw", polbas.getCoInsuranceSw());	
					
					this.getSqlMapClient().queryForObject("revertFlatCancellation", params);
				}*/
				if(variables.getString("cancelledFlatFlag").equals("Y")){
					log.info("deleteOtherInfoGipis165...");
					this.getSqlMapClient().queryForObject("deleteOtherInfoGipis165", polbas.getParId());
					this.getSqlMapClient().executeBatch();
					
					log.info("deleteRecordsGipis165...");
					this.getSqlMapClient().queryForObject("deleteRecordsGipis165", polbas.getParId());
					this.getSqlMapClient().executeBatch();
				}
			}
			
			//added function from saveEndtBasicInfo for changed policy number...
			System.out.println("DELETE INVOICES::: "+variables.getString("varPolChangedSw"));
			if("Y".equals(variables.getString("varPolChangedSw"))){
				/*Map<String, Object> deleteAllTableMap = new HashMap<String, Object>();
				deleteAllTableMap = loadPolicyNoToMap(polbas.getLineCd(), polbas.getSublineCd(), polbas.getIssCd(),
						polbas.getIssueYy(), polbas.getPolSeqNo(), Integer.parseInt(polbas.getRenewNo()));
				deleteAllTableMap.put("effDate", polbas.getEffDate());	
				System.out.println("DELETING TABLES: "+deleteAllTableMap);
				deleteAllTables(deleteAllTableMap);*/
				this.getSqlMapClient().delete("gipis165DeleteAllTables", polbas.getParId());
				this.getSqlMapClient().executeBatch();
			}
			
			//added by robert GENQA SR 4825 08.04.15
			if("Y".equals(variables.getString("deleteBillSw"))){
				log.info("Deleting Bill related tables...");
				Map<String, Object> parameter = new HashMap<String, Object>();
				parameter = loadPolicyNoToMap(polbas); //added by robert SR 4828 08.26.15
				parameter.put("effDate", polbas.getEffDate()); //added by robert SR 4828 08.26.15
				parameter.put("parId", polbas.getParId()); //added by robert SR 4828 08.26.15
				this.getSqlMapClient().queryForObject("gipis031DeleteAllTables", parameter); //added by robert SR 4828 08.26.15
				this.getSqlMapClient().executeBatch();
			}
			//end robert GENQA SR 4825 08.04.15
			
			List<GIPIWPolnrep> polnrepList = (List<GIPIWPolnrep>) params.get("gipiWPolnrep");
			String polFlag = polbas.getPolFlag();
			if (!"[]".equals(polnrepList.toString())){
				if (polFlag.equals("2") || polFlag.equals("3")) {
					Map<String, Object> wpolnrepParams = new HashMap<String, Object>();
					for (GIPIWPolnrep polnrep : polnrepList){
						wpolnrepParams.put("parId", polnrep.getParId());
						wpolnrepParams.put("oldPolicyId", polnrep.getOldPolicyId());
						wpolnrepParams.put("polFlag", polFlag);
						wpolnrepParams.put("userid", polnrep.getUserId());
						
						log.info("Inserting gipiWPolnrep...");
						this.getSqlMapClient().update("saveWPolnrep", wpolnrepParams);
						log.info("gipiWPolnrep inserted...");
					}
				}
			}

			log.info("Inserting gipiWPolbas for endt bond...");
			this.getSqlMapClient().insert("saveGipiWpolbasEndtBond", polbas);
			preFormsCommitG(Integer.parseInt(polbas.getBookingYear()), polbas.getBookingMth(), polbas.getParId()); //belle 07.18.2012
			//added by robert GENQA SR 4828 08.26.15
			this.getSqlMapClient().executeBatch();
			if ("Y".equals(polbas.getBondAutoPrem())) {
				log.info("Auto computing bond premium...");
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("userid", polbas.getUserId());
				parameters.put("parId", polbas.getParId());
				this.getSqlMapClient().update("autoComputeBondPrem", parameters);
				log.info("Bond premium auto computed...");
			}
			//end robert GENQA SR 4828 08.26.15
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (com.geniisys.gipi.exceptions.InvalidBasicInfoDataException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		log.info("Done saving saveGipiWPolbasForEndtBond details...");
		
		return paramsResult;
	}
	
	@Override
	public Map<String, Object> saveGipiWPolbasForBond(Map<String, Object> params)
			throws SQLException, RecreatingWInvoiceException {
		String message = "SUCCESS";
		Map<String, Object> paramsResult = new HashMap<String, Object>();
		paramsResult.put("message", message);
		log.info("DAO calling saveGipiWPolbasForBond...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
			
			Map<String, String> paramsIn = new HashMap<String, String>();
			Integer parId = gipiWPolbas.getParId();
			paramsIn.put("parId", parId.toString());
			
			
			
			Map<String, Object> wpolassdNameParams = new HashMap<String, Object>();
			wpolassdNameParams.put("parId",gipiWPolbas.getParId());
			wpolassdNameParams.put("assdNo",gipiWPolbas.getAssdNo());
			this.getSqlMapClient().update("changeParStatus",wpolassdNameParams); //Rey 11-07-2011 added to return par status to 2 when assured is changed
			
			
			String deleteWPolnrep = (String) params.get("deleteWPolnrep");
			if (deleteWPolnrep.equals("Y")) {
				log.info("Deleting gipiWPolnrep...");
				this.getSqlMapClient().delete("deleteWPolnreps", gipiWPolbas.getParId());
				log.info("gipiWPolnrep deleted.");
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			String validatedBookingDate = (String) params.get("validatedBookingDate");
			if ("Y".equals(validatedBookingDate)) {
				log.info("Validating booking date...");
				validateBookingDate(Integer.parseInt(gipiWPolbas.getBookingYear()), gipiWPolbas.getBookingMth(), sdf.format(gipiWPolbas.getIssueDate()), sdf.format(gipiWPolbas.getInceptDate()));
				/*message = validateBookingDate(Integer.parseInt(gipiWPolbas.getBookingYear()), gipiWPolbas.getBookingMth(), sdf.format(gipiWPolbas.getIssueDate()), sdf.format(gipiWPolbas.getInceptDate()));
				paramsResult.put("message", message);
				if (!"SUCCESS".equals(message)){
					throw new InvalidBasicInfoDataException(message);
				}*/
			}
			
			GIPIWPolnrep wpolnrep = (GIPIWPolnrep) params.get("gipiWPolnrep");
			String polFlag = (String) params.get("polFlag");
			if (polFlag.equals("2") || polFlag.equals("3")) {
				Map<String, Object> wpolnrepParams = new HashMap<String, Object>();
				wpolnrepParams.put("parId", wpolnrep.getParId());
				wpolnrepParams.put("oldPolicyId", wpolnrep.getOldPolicyId().toString());
				wpolnrepParams.put("polFlag", polFlag);
				wpolnrepParams.put("userId", wpolnrep.getUserId());
			
				log.info("Inserting gipiWPolnrep...");
				this.getSqlMapClient().update("saveWPolnrep", wpolnrepParams);
				log.info("gipiWPolnrep inserted.");
			}
			
			String deleteBillSw = (String) params.get("deleteBillSw");
			if (deleteBillSw.equals("Y")) {
				log.info("Deleting Bill related tables...");
				this.getSqlMapClient().update("deleteBillRelatedTables", paramsIn);
			}
			
			//Apollo 11.03.2014
			String deleteCommInvoice = (String) params.get("deleteCommInvoice");
			if("Y".equals(deleteCommInvoice)){
				log.info("Deleting Commission Invoice...");
				this.getSqlMapClient().update("delCommInvoiceRelatedRecs", gipiWPolbas.getParId());
				this.getSqlMapClient().executeBatch();
			}
			
			String deleteWorkingDistSw = (String) params.get("deleteWorkingDistSw");	// shan 10.14.2014
			if (deleteWorkingDistSw.equals("Y")) {
				@SuppressWarnings("unchecked")
				List<GIUWPolDist> giuwPolDist = (List<GIUWPolDist>) params.get("giuwPolDistList");
				Iterator<GIUWPolDist> iter = giuwPolDist.iterator();
				
				while(iter.hasNext()){
					GIUWPolDist g = iter.next();

					Map<String, Object> p = new HashMap<String, Object>();
					p.put("userId", params.get("userId"));
					p.put("distNo", g.getDistNo());
					log.info("Deleting Working Distribution related tables..."+p.toString());
					this.getSqlMapClient().update("delDistWorkingTables", p);
					this.getSqlMapClient().update("delDistWPolicyWItemDs", p);
				}
			}			
			
			log.info("Inserting gipiWPolbas for bond...");
			this.getSqlMapClient().insert("saveGipiWPolbas2", gipiWPolbas);
			log.info("gipiWPolbas for bond inserted.");
			this.getSqlMapClient().executeBatch();
			String validateAssdName = (String) params.get("validateAssdName");
			String assdName = (String) params.get("assdName");
			if (validateAssdName.equals("Y")) {
				Map<String, Object> paramsAssd = new HashMap<String, Object>();
				paramsAssd.put("parId", parId.toString());
				paramsAssd.put("lineCd", gipiWPolbas.getLineCd());
				paramsAssd.put("assdNo", gipiWPolbas.getAssdNo());
				paramsAssd.put("assdName", assdName);
				this.getSqlMapClient().update("validateAssdNameGipis017", paramsAssd);
			}
			this.getSqlMapClient().executeBatch();
			postFormsCommitD(gipiWPolbas.getParId(), Integer.parseInt(gipiWPolbas.getAssdNo()));
			
			//nieko 06232016, SR 22536 KB 3599
			log.info("Updating expiry date in GIUW_POL_DIST...");
			validateExpiryDate(gipiWPolbas.getParId(), sdf.format(gipiWPolbas.getExpiryDate()));
			//nieko 06232016 end
			
			String mortgCd = (String) params.get("mortgCd");
			if (!mortgCd.equals("")) {
				Map<String, Object> paramsDel = new HashMap<String, Object>();
				paramsDel.put("parId", parId);
				paramsDel.put("itemNo", 1);
				this.getSqlMapClient().delete("deleteGIPIParMortItem", paramsDel);
				
				GIPIParMortgagee m = new GIPIParMortgagee();
				m.setParId(parId);
				m.setIssCd(gipiWPolbas.getIssCd());
				m.setMortgCd(mortgCd);
				m.setItemNo(1);
				m.setUserId(gipiWPolbas.getUserId());
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
			}
			preFormsCommitG(Integer.parseInt(gipiWPolbas.getBookingYear()), gipiWPolbas.getBookingMth(), gipiWPolbas.getParId()); //belle 07.18.2012
			this.getSqlMapClient().executeBatch();
			String deleteSw = (String) params.get("deleteSw");
			if (deleteSw.equals("Y")) {
				log.info("Recreating winvoice...");
				Map<String, String> paramsWInvoice = new HashMap<String, String>();
				paramsWInvoice.put("parId", parId.toString());
				paramsWInvoice.put("lineCd", gipiWPolbas.getLineCd());
				paramsWInvoice.put("issCd", gipiWPolbas.getIssCd());
				this.sqlMapClient.update("validateTakeupTerm", paramsWInvoice);
				message = paramsWInvoice.get("msgAlert");
				paramsResult.put("message", message);
				if (!message.equals("SUCCESS")){
					throw new RecreatingWInvoiceException(message);
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().update("PostFormsCommitGipis017", paramsIn);
			paramsResult.put("bankRefNo", gipiWPolbas.getBankRefNo());
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (com.geniisys.gipi.exceptions.InvalidBasicInfoDataException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (com.geniisys.gipi.exceptions.RecreatingWInvoiceException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		log.info("Done saving saveGipiWPolbasForBond details...");
		return paramsResult;
	}

	@Override
	public Map<String, Object> validateEndtInceptExpiryDate(Map<String, Object> params)
			throws SQLException {			
		this.sqlMapClient.queryForObject("validateEndtInceptExpiryDate", params);
		return params;		
	}

	@Override
	public Map<String, Object> validateEndtEffDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("validateEndtEffDate", params);
		return params;
	}

	@Override
	public int checkForPendingClaims(Map<String, Object> params)
			throws SQLException {
		log.info("Checking for pending claims ...");
		return (Integer) this.getSqlMapClient().queryForObject("checkForPendingClaims", params);
	}

	@Override
	public BigDecimal checkPolicyPayment(Map<String, Object> params)
			throws SQLException {
		log.info("Checking policy payment ...");
		return (BigDecimal) this.getSqlMapClient().queryForObject("checkPolicyPayment", params);
	}

	@Override
	public Map<String, Object> checkEndtForItemAndPeril(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.queryForList("checkEndtForItemAndPeril", params);
		return params;
	}

	@Override
	public Map<String, Object> checkForPolFlagInterruption(
			Map<String, Object> params) throws SQLException {
		this.sqlMapClient.queryForObject("checkForPolFlagInterruption", params);
		return params;
	}

	@Override
	public Map<String, Object> executeCheckPolFlagProcedures(
			Map<String, Object> params) throws SQLException {		
		this.getSqlMapClient().queryForObject("executeCheckPolFlagProcedures", params);		
		return params;
	}

	@Override
	public Map<String, Object> executeUncheckPolFlagProcedures(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().setUserConnection(DataSourceUtils.getConnection(this.getSqlMapClient().getDataSource()));
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().queryForObject("executeUncheckPolFlagProcedures", params);
		
		/*try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().queryForObject("executeUncheckPolFlagProcedures", params);
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}*/
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#updateGipiWpolbasEndt(int, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.math.BigDecimal, java.lang.String)
	 */
	@Override
	public String updateGipiWpolbasEndt(int parId, String lineCd, String negateItem,
			String prorateFlag, String compSw, String endtExpiryDate,
			String effDate, BigDecimal shortRtPercent, String expiryDate) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("negateItem", negateItem.trim().length() == 0 ? null : negateItem);
		params.put("prorateFlag", prorateFlag.trim().length() == 0 ? null : prorateFlag);
		params.put("compSw", compSw.trim().length() == 0 ? null : compSw);
		params.put("endtExpiryDate", endtExpiryDate.trim().length() == 0 ? null : endtExpiryDate);
		params.put("effDate", effDate.trim().length() == 0 ? null : effDate);
		params.put("shortRtPercent", shortRtPercent);
		params.put("expiryDate", expiryDate.trim().length() == 0 ? null : expiryDate);
		
		this.getSqlMapClient().update("updateGipiWpolbasEndt" + lineCd, params);
		log.info("message : " + params.get("message"));
		return (String)params.get("message");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#checkForProrateFlagInterruption(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkForProrateFlagInterruption(
			Map<String, Object> params) throws SQLException {		
		this.getSqlMapClient().setUserConnection(DataSourceUtils.getConnection(this.getSqlMapClient().getDataSource()));
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().queryForObject("checkForProrateFlagInterruption", params);		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#executeCheckProrateFlagProcedures(java.util.Map)
	 */
	@Override
	public Map<String, Object> executeCheckProrateFlagProcedures(
			Map<String, Object> params) throws SQLException {				
		//this.getSqlMapClient().setUserConnection(DataSourceUtils.getConnection(this.getSqlMapClient().getDataSource()));
		//this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);		
		this.getSqlMapClient().queryForObject("executeCheckProrateFlagProcedures", params);		
		return params;
	}	

	@Override
	public Map<String, Object> validateEndtExpDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("validateEndtExpiryDate", params);
		return params;
	}

	@Override
	public Map<String, Object> validateEndtIssueDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("validateEndtIssueDate", params);
		return params;
	}

	@Override
	public Map<String, Object> gipis031NewFormInstance(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("gipis031NewFormInstance", params);
		return params;
	}

	@Override
	public Map<String, Object> validateBeforeSave(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("validateBeforeSave", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveEndtBasicInfo(Map<String, Object> params)
		throws SQLException {
	Map<String, Object> resultMap = new HashMap<String, Object>();
	String message = "SUCCESS";

	log.info("Saving endorsement basic information...");
	try{
		GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
		GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
		GIPIWPolGenin gipiWPolGenin = (GIPIWPolGenin) params.get("gipiWPolGenin");
		GIPIWEndtText gipiWEndtText = (GIPIWEndtText) params.get("gipiWEndtText");
		
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		Map<String, Object> pars = (Map<String, Object>) params.get("pars");
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		
		//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yy HH:mm:ss");			
		
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();
		
		// save records to tables (endt basic info)
		log.info("Saving record on GIPI_PARLIST...");
		this.getSqlMapClient().insert("saveGipiParListFromEndt", gipiParList);
		log.info("Saving record on GIPI_WPOLBAS...");			
		this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);			
		log.info("Saving record on GIPI_WPOLGENIN...");
		this.getSqlMapClient().insert("saveGipiWPolGeninFromEndt", gipiWPolGenin);
		log.info("Saving record on GIPI_WENDTTEXT...");
		this.getSqlMapClient().insert("saveGipiWEndtTextFromEndt", gipiWEndtText);		
		
		// mortgagee
		updateMortgageeRecords(params);
		
		// deductibles
		updateDeductibleRecords(params);
		
		this.getSqlMapClient().executeBatch();
		
		//if policy no. changed
		if("Y".equals((String) vars.get("varPolChangedSw"))){
			// parameter map for delete_all_table
			Map<String, Object> deleteAllTableMap = new HashMap<String, Object>();
			deleteAllTableMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
					gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
			deleteAllTableMap.put("effDate", gipiWPolbas.getEffDate());	
			deleteAllTables(deleteAllTableMap);
			this.getSqlMapClient().executeBatch();
		}
		
		// this is for endorse_tax procedure
		if("Y".equals(others.get("clickEndorseTax").toString())){
			System.out.println("endorse tax in"+others.get("clickEndorseTax").toString());
			if("Y".equals(gipiWEndtText.getEndtTax())){ //if("Y".equals(others.get("b360EndtTax").toString())){
				System.out.println("b360Endt Tax in :"+gipiWEndtText.getEndtTax());
				if("Y".equals(others.get("nbtPolFlag").toString()) || "Y".equals(others.get("prorateSw"))){
					message = "Endorsement of tax is not available for cancelling endorsement.";
					gipiWEndtText.setEndtTax("N");
					throw new SQLException();
				}
				
				pars.put("parEndtTaxSw", "Y");
				
				// check witem table
				if("Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItemWithRecFlag", gipiWPolbas.getParId()).toString())){
					pars.put("parEndtTaxSw", "X");
				}
				
				if("Y".equals(this.getSqlMapClient().queryForObject("endtCheckRecordInItemPeril", gipiWPolbas.getParId()).toString())){
					pars.put("parEndtTaxSw", "N");
					gipiWEndtText.setEndtTax("N");
					System.out.println("Endorse Tax - Cannot be tagged as endorsement of tax if there are existing perils");
					// raise form trigger
				}
			}else{
				pars.put("parEndtTaxSw", "X");
				System.out.println("parId: "+gipiWPolbas.getParId());
				this.getSqlMapClient().delete("deleteRecordsForEndtTax", gipiWPolbas.getParId());
				System.out.println("Endorse Tax - Records related to endorse tax are deleted.");
			}				
		}
		
		// this is for pol_flag procedure
		if("Y".equals(others.get("clickCancelledFlat").toString())){
			if("Y".equals(others.get("urlParNbtPolFlag").toString())){
				if(Integer.parseInt(gipiWPolbas.getRenewNo()) != 0){
					others.put("nbtPolFlag", "N");
					System.out.println("Cancelled(Flat) - Renewed policy cannot be cancelled");
					// raise form trigger
				}else{
					Map<String, Object> genericMap = new HashMap<String, Object>();
					
					if("Y".equals(gipiWEndtText.getEndtTax())){
						others.put("nbtPolFlag", "N");
						System.out.println("Cancelled(Flat) - Endorsement Tax");
						// raise form trigger
					}
					// check for pending claims						
					genericMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
							gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));						
					
					System.out.println("Generic Map test - "+genericMap);
					
					if((Integer)this.getSqlMapClient().queryForObject("checkForPendingClaims", genericMap) > 0){
						gipiWPolbas.setPolFlag("1");
						others.put("nbtPolFlag", "N");
						System.out.println("Cancelled(Flat) - The policy has pending claims, cannot cancel policy");
						// raise form trigger
					}
					// check for policy payment
					/*if(new BigDecimal("0.00").compareTo((BigDecimal) this.getSqlMapClient().queryForObject("checkPolicyPayment", genericMap)) > 0){
						System.out.println("Cancelled(Flat) - Payments have been made to the policy/endorsement to be cancelled");
						// raise form trigger
					}*/ //commented by d.alcantara, causes error in endt ri, cancelled flat
					
					// clears map after use
					genericMap.clear();
					
					// check booking month
					if(gipiWPolbas.getBookingMth().isEmpty() | gipiWPolbas.getBookingYear().isEmpty()){
						gipiWPolbas.setPolFlag("1");
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
					
					genericMap.put("gipiParList", gipiParList);
					genericMap.put("gipiWPolbas", gipiWPolbas);
					genericMap.put("vars", vars);
					genericMap.put("others", others);
					genericMap.put("cancelType", "Flat");
					
					genericMap = processNegatingRecords(genericMap);
					
					// update affected objects
					gipiParList = (GIPIPARList) genericMap.get("gipiParList");
					gipiWPolbas = (GIPIWPolbas) genericMap.get("gipiWPolbas");
					vars = (Map<String, Object>) genericMap.get("vars");
					others = (Map<String, Object>) genericMap.get("others");						
					
					genericMap = null;
				}
			}else{
				// revert cancellation
				others.put("globalCancellationType", null);
				
				// deleting records affects gipiWPolbas so we need to update it
				gipiWPolbas = deleteRecords(gipiWPolbas);					
				gipiParList.setParStatus(3);
				gipiWPolbas.setProrateFlag("2");
				others.put("prorateSw", "N");
				gipiWPolbas.setPolFlag("1");
				gipiWPolbas.setEffDate(sdfWithTime.parse(vars.get("varOldEffDate").toString()));					
				gipiWPolbas.setCancelType(null);
				vars.put("varCnclldFlatFlag", "N");					
			}
		}
		
		// this is for prorate_flag procedure
		if("Y".equals(others.get("clickCancelled").toString())){
			if("Y".equals(others.get("urlParProrateSw").toString())){
				if(Integer.parseInt(gipiWPolbas.getRenewNo()) != 0){
					others.put("nbtPolFlag", "N");
					System.out.println("Cancelled - Renewed policy cannot be cancelled");
					// raise form trigger
				}else{
					Map<String, Object> genericMap = new HashMap<String, Object>();
					
					if("Y".equals(gipiWEndtText.getEndtTax())){
						others.put("prorateSw", "N");
						System.out.println("Cancelled(Flat) - Prorate Cancellation is not allowed for endorsement of tax");
						// raise form trigger
					}
					// check for pending claims
					genericMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
							gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
					
					if((Integer)this.getSqlMapClient().queryForObject("checkForPendingClaims", genericMap) > 0){
						gipiWPolbas.setPolFlag("1");
						others.put("prorateSw", "N");
						System.out.println("Cancelled - The policy has pending claims, cannot cancel policy");
						// raise form trigger
					}
					// check for policy payment
					System.out.println("TEST GENERIC MAP - "+genericMap);
					
					/*if(new BigDecimal("0.00").compareTo((BigDecimal) this.getSqlMapClient().queryForObject("checkPolicyPayment", genericMap)) > 0){
						System.out.println("Cancelled - Payments have been made to the policy/endorsement to be cancelled");
						// raise form trigger
					}*/
					// check booking month
					if(gipiWPolbas.getBookingMth().isEmpty() | gipiWPolbas.getBookingYear().isEmpty()){
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
					gipiWPolbas = deleteRecords(gipiWPolbas);
					
					gipiWPolbas.setPolFlag("4");						
					gipiWPolbas.setProrateFlag("1");
					gipiWPolbas.setCompSw("N");
					gipiWPolbas.setCancelType("2");
					others.put("nbtPolFlag", "N");
					others.put("prorateSw", "Y");
					others.put("endtCancellation", "N");
					others.put("coiCancellation", "N");
					pars.put("parProrateCancelSw", "Y");
					vars.put("varCnclldFlag", "Y");
					
					genericMap = null;
				}
			}else{
				// deleting records affects gipiWPolbas so we need to update it
				gipiWPolbas = deleteRecords(gipiWPolbas);
				
				gipiParList.setParStatus(3);
				gipiWPolbas.setProrateFlag("2");
				others.put("prorateSw", "N");
				gipiWPolbas.setPolFlag("1");					
				gipiWPolbas.setCancelType(null);
				vars.put("varCnclldFlag", "N");
			}
		}
		
		// this is for endt_cancellation and coi_cancellation procedure
		if("Y".equals(others.get("clickEndtCancellation").toString()) 
				| "Y".equals(others.get("clickCoiCancellation").toString())){
			if("Y".equals(others.get("urlParEndtCancellation").toString()) | 
					"Y".equals(others.get("urlParCoiCancellation").toString())){
				Map<String, Object> genericMap = new HashMap<String, Object>();
				String cancelType = "";
				
				if("Y".equals(others.get("urlParEndtCancellation").toString())){
					cancelType = "Endt";
				}else if("Y".equals(others.get("urlParCoiCancellation").toString())){
					cancelType = "Coi";
				}
				
				// check for pending claims						
				genericMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
						gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));						
				
				if((Integer)this.getSqlMapClient().queryForObject("checkForPendingClaims", genericMap) > 0){
					gipiWPolbas.setPolFlag("1");
					others.put("nbtPolFlag", "N");
					System.out.println(cancelType + " - The policy has pending claims, cannot cancel policy");
					// raise form trigger
				}
				// check for policy payment
				if(new BigDecimal("0.00").compareTo((BigDecimal) this.getSqlMapClient().queryForObject("checkPolicyPayment", genericMap)) > 0){
					System.out.println(cancelType + " - Payments have been made to the policy/endorsement to be cancelled");
					// raise form trigger
				}
				
				// clears map after use
				genericMap.clear();
				
				// check booking month
				if(gipiWPolbas.getBookingMth().isEmpty() | gipiWPolbas.getBookingYear().isEmpty()){
					gipiWPolbas.setPolFlag("1");
					System.out.println(cancelType + " - Booking month and year is needed before performing cancellation");
					// raise form trigger
				}
				
				genericMap.put("gipiParList", gipiParList);
				genericMap.put("gipiWPolbas", gipiWPolbas);
				genericMap.put("vars", vars);
				genericMap.put("others", others);
				genericMap.put("cancelType", cancelType);
				
				genericMap = processNegatingRecords(genericMap);
				
				// update affected objects
				gipiParList = (GIPIPARList) genericMap.get("gipiParList");
				gipiWPolbas = (GIPIWPolbas) genericMap.get("gipiWPolbas");
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
					genericMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
							gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
					genericMap.put("parId", gipiWPolbas.getParId());
					genericMap.put("packPolFlag", gipiWPolbas.getPackPolFlag());
					genericMap.put("cancelType", gipiWPolbas.getCancelType());
					genericMap.put("effDate", String.format("%tD", gipiWPolbas.getEffDate()));
					genericMap.put("policyId", "".equals((String)pars.get("parCancelPolId")) ? "" :Integer.parseInt((String)pars.get("parCancelPolId")));
					
					this.getSqlMapClient().queryForObject("processEndtCancellation", genericMap);
					
					if((String) genericMap.get("msgAlert") != null){
						System.out.println("Process Endt Cancellation - Message is not null");
					}else{
						// update gipiWPolbas due to process_endt_cancellation
						gipiParList.setParStatus(5);
						gipiWPolbas.setEffDate(sdfWithTime.parse((String) genericMap.get("effDate")));
						gipiWPolbas.setEndtExpiryDate(sdfWithTime.parse((String) genericMap.get("endtExpiryDate")));
						gipiWPolbas.setExpiryDate(sdfWithTime.parse((String) genericMap.get("expiryDate")));
						gipiWPolbas.setTsiAmt(new BigDecimal(genericMap.get("tsiAmt").toString()));
						gipiWPolbas.setPremAmt(new BigDecimal(genericMap.get("premAmt").toString()));
						gipiWPolbas.setAnnTsiAmt(new BigDecimal(genericMap.get("annTsiAmt").toString()));
						gipiWPolbas.setAnnPremAmt(new BigDecimal(genericMap.get("annPremAmt").toString()));
						gipiWPolbas.setProrateFlag((String) genericMap.get("prorateFlag"));
						gipiWPolbas.setProvPremPct((String) genericMap.get("provPremPct"));
						gipiWPolbas.setProvPremTag((String) genericMap.get("provPremTag"));
						gipiWPolbas.setShortRtPercent((String) genericMap.get("shortRtPercent"));
						gipiWPolbas.setCompSw((String) genericMap.get("compSw"));
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
				gipiWPolbas = deleteRecords(gipiWPolbas);
				
				gipiParList.setParStatus(3);
				gipiWPolbas.setProrateFlag("2");
				others.put("prorateSw", "N");
				gipiWPolbas.setPolFlag("1");
				gipiWPolbas.setEffDate(sdfWithTime.parse(vars.get("varOldEffDate").toString()));
				gipiWPolbas.setCancelType(null);
				vars.put("varCnclldFlatFlag", "N");
				pars.put("parCancelPolId", null);
				others.put("globalCancellationType", null);					
			}
		}			
		System.out.println("ParInsWinvoice : " + pars.get("parInsWinvoice"));			
		// create winvoice
		if("Y".equals((String) pars.get("parInsWinvoice"))){
			Map<String, Object> genericMap = new HashMap<String, Object>();
			genericMap.put("parId", gipiWPolbas.getParId());
			genericMap.put("lineCd", gipiWPolbas.getLineCd());
			genericMap.put("issCd", gipiWPolbas.getIssCd());
			this.getSqlMapClient().queryForObject("createWinvoice1", genericMap);
			
			if((String) genericMap.get("msgAlert") != null){
				// raise form trigger
				System.out.println("Error on creating winvoice");
			}
			
			genericMap = null;
		}
		
		// validate-before-commit on forms
		if("N".equals((String) others.get("urlParNbtPolFlag")) && "N".equals((String) others.get("urlParProrateSw"))){
			if("N".equals((String) vars.get("varPolChangedSw"))){
				String itemPerilExist = others.get("recExistsInGipiWItmperl").toString();
				//System.out.println(String.format("%tD", vars.get("varOldInceptDate")));					
				
				// parameter map for check_item_date
				Map<String, Object> checkItemDateMap = new HashMap<String, Object>();
				checkItemDateMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
						gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
				
				// parameter map for delete_all_table
				Map<String, Object> deleteAllTableMap = new HashMap<String, Object>();
				deleteAllTableMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
						gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
				deleteAllTableMap.put("effDate", gipiWPolbas.getEffDate());					
				
				// parameter map for delete_bill
				Map<String, Object> deleteBillMap = new HashMap<String, Object>();
				deleteBillMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
						gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
				deleteBillMap.put("parId", gipiWPolbas.getParId());
				deleteBillMap.put("effDate", gipiWPolbas.getEffDate());
				deleteBillMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
				deleteBillMap.put("gipiWPolbas", gipiWPolbas);
				
				Date oldInceptDate = vars.get("varOldInceptDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldInceptDate").toString());
				Date oldExpiryDate = vars.get("varOldExpiryDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldExpiryDate").toString());
				System.out.println("VAR OLD EFF DATE::::" + vars.get("varOldEffDate") + ":::::");
				Date oldEffDate = vars.get("varOldEffDate").toString().equals("") ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldEffDate").toString());
				Date oldEndtExpDate = vars.get("varOldEndtExpiryDate").toString().isEmpty() ? Calendar.getInstance().getTime() : sdfWithTime.parse(vars.get("varOldEndtExpiryDate").toString());
				
				//System.out.println("Incept: " + gipiWPolbas.getInceptDate().toString() + " - " + oldInceptDate.toString());
				//System.out.println("Expiry: " + gipiWPolbas.getExpiryDate().toString() + " - " + oldExpiryDate.toString());
				//System.out.println("Eff: " + gipiWPolbas.getEffDate().toString() + " - " + oldEffDate);
				//System.out.println("Endt: " + gipiWPolbas.getEndtExpiryDate().toString() + " - " + oldEndtExpDate.toString());					
				
				if(gipiWPolbas.getInceptDate().compareTo(oldInceptDate) != 0){
					// !(String.format("%tD", gipiWPolbas.getInceptDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldInceptDate").toString()))))
					System.out.println("Incept dates are not equal");
					checkItemDates(checkItemDateMap, gipiWPolbas.getEffDate());
					vars.put("varOldInceptDate", gipiWPolbas.getInceptDate());
					pars = updateParameters(pars, gipiWEndtText.getEndtTax());					
				}else if(gipiWPolbas.getExpiryDate().compareTo(oldExpiryDate)!= 0){
					// !(String.format("%tD", gipiWPolbas.getExpiryDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldExpiryDate").toString()))))
					System.out.println("Expiry dates are not equal");
					checkItemDates(checkItemDateMap, gipiWPolbas.getEffDate());
					vars.put("varOldExpiryDate", gipiWPolbas.getExpiryDate());
					pars = updateParameters(pars, gipiWEndtText.getEndtTax());
				}else if((gipiWPolbas.getEffDate().compareTo(oldEffDate) != 0) 
						&& !(gipiWPolbas.getPolFlag().equals("4"))){
					// !(String.format("%tD", gipiWPolbas.getEffDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldEffDate").toString())))) && !(gipiWPolbas.getPolFlag().equals("4"))
					System.out.println("Effectivity dates are not equal");											
					vars.put("varOldEffDate", gipiWPolbas.getEffDate());						
					deleteAllTables(deleteAllTableMap);
					pars = updateParameters(pars, gipiWEndtText.getEndtTax());
					System.out.println("Eff Date: " + gipiWPolbas.getEffDate());
					System.out.println("Endt Exp: " + gipiWPolbas.getEndtExpiryDate());
				}else if(gipiWPolbas.getEndtExpiryDate().compareTo(oldEndtExpDate) != 0){
					// !(String.format("%tD", gipiWPolbas.getEndtExpiryDate()).equals(String.format("%tD", sdfWithTime.parse(vars.get("varOldEndtExpiryDate").toString()))))
					System.out.println("Endt Expiry dates are not equal");
					vars.put("varOldEndtExpiryDate", gipiWPolbas.getEndtExpiryDate());
					deleteAllTableMap.put("effDate", gipiWPolbas.getEffDate());
					deleteAllTables(deleteAllTableMap);
					pars = updateParameters(pars, gipiWEndtText.getEndtTax());
				}else if(!(gipiWPolbas.getProvPremTag().equals(vars.get("varOldProvPremTag").toString())) && "Y".equals(itemPerilExist)){
					System.out.println("Prov prem tags are not equal");
					vars.put("varOldProvPremTag", gipiWPolbas.getProvPremTag());						
					gipiWPolbas = deleteBill(deleteBillMap);
				}else if("Y".equals(vars.get("varProrateSw").toString()) && "Y".equals(itemPerilExist)){
					System.out.println("Prorate flags are not equal");
					gipiWPolbas = deleteBill(deleteBillMap);
				}else if(!(new BigDecimal(others.get("shortRatePercent").toString()).compareTo(new BigDecimal(vars.get("varOldShortRtPercent").toString())) == 0) && "Y".equals(itemPerilExist)){						
					System.out.println("Short rate percents are not equal");
					System.out.println("SRP: " + others.get("shortRatePercent").toString() + " Old: " + vars.get("varOldShortRtPercent").toString());
					vars.put("varOldShortRtPercent", others.get("shortRatePercent").toString());
					gipiWPolbas = deleteBill(deleteBillMap);
				}
				checkItemDateMap = null;
				deleteAllTableMap = null;
				deleteBillMap = null;
			}
		}
		
		// check par status in database
		if((Integer)this.getSqlMapClient().queryForObject("gipis031GetParStatus", gipiParList.getParId()) == 10){
			// raise form trigger
			System.out.println("Cannot save changes, par_id has been posted to a different endorsement");
		}
		
		if(gipiWPolbas.getBookingMth().isEmpty() | gipiWPolbas.getBookingYear().isEmpty()){
			// raise form trigger
			System.out.println("There is no value for booking date. Please enter the date.");
		}
		
		if(!(gipiWPolbas.getEffDate() != null) | !(gipiWPolbas.getEndtExpiryDate() != null)){
			// raise form trigger
			System.out.println("Eff Date: " + gipiWPolbas.getEffDate());
			System.out.println("Endt Exp: " + gipiWPolbas.getEndtExpiryDate());
			System.out.println("Cannot proceed, endorsement effectivity date / endorsement expiry_date must not be null.");
		}
		
		if("Y".equals((String) others.get("prorateSw")) && "Y".equals((String) pars.get("parProrateCancelSw"))){
			// delete other info
			this.getSqlMapClient().queryForObject("gipis031DeleteOtherInfo", gipiWPolbas.getParId());
			
			// delete records
			Map<String, Object> genericMap = new HashMap<String, Object>();
			genericMap.put("parId", gipiWPolbas.getParId());
			genericMap.put("effDate", gipiWPolbas.getEffDate());
			genericMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
			
			this.getSqlMapClient().queryForObject("gipis031DeleteRecords", genericMap);
			
			if((String) genericMap.get("msgAlert") != null){					
				// raise form trigger
				System.out.println("Delete Records - Message is not null");
			}else{					
				gipiWPolbas.setAnnTsiAmt(genericMap.get("annTsiAmt") != null ? new BigDecimal(genericMap.get("annTsiAmt").toString().replaceAll(",", "")) : null);
				gipiWPolbas.setAnnPremAmt(genericMap.get("annPremAmt") != null ? new BigDecimal(genericMap.get("annPremAmt").toString().replaceAll(",", "")) : null);
			}
			
			// clears map
			genericMap.clear();
			
			// create negated records prorate				
			genericMap = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
					gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
			genericMap.put("parId", gipiWPolbas.getParId());
			genericMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
			genericMap.put("packPolFlag", gipiWPolbas.getPackPolFlag());
			genericMap.put("prorateFlag", gipiWPolbas.getProrateFlag());
			genericMap.put("compSw", gipiWPolbas.getCompSw());
			genericMap.put("shortRtPercent", new BigDecimal(others.get("shortRatePercent").toString()));
			genericMap.put("effDate", gipiWPolbas.getEffDate());
			
			System.out.println("Par Id for negation: "+genericMap.get("parId"));
			System.out.println("Par Id for negation: "+gipiWPolbas.getParId());
			this.getSqlMapClient().queryForObject("gipis031CreateNegatedRecordsProrate", genericMap);
			
			if((String) genericMap.get("msgAlert") != null){
				// raise form trigger
				System.out.println("Create Negated Records Prorate - Message is not null");
			}else{
				// update objects
				System.out.println("Dumaan ba sya dito?");
				vars.put("varExpiryDate", genericMap.get("varExpiryDate"));
				vars.put("varInceptDate", genericMap.get("varInceptDate"));
				gipiWPolbas.setInceptDate(sdfWithTime.parse(genericMap.get("inceptDate").toString()));
				gipiWPolbas.setExpiryDate(sdfWithTime.parse(genericMap.get("expiryDate").toString()));
				gipiWPolbas.setEndtExpiryDate(sdfWithTime.parse(genericMap.get("endtExpiryDate").toString()));
				gipiWPolbas.setTsiAmt(new BigDecimal(genericMap.get("tsiAmt").toString()));
				gipiWPolbas.setPremAmt(new BigDecimal(genericMap.get("premAmt").toString()));
				gipiWPolbas.setAnnTsiAmt(new BigDecimal(genericMap.get("annTsiAmt").toString()));
				gipiWPolbas.setAnnPremAmt(new BigDecimal(genericMap.get("annPremAmt").toString()));
			}
			
			pars.put("parPolFlag", "Y");
			pars.put("parProrateCancelSw", "N");
			others.put("nbtPolFlag", "N");
			gipiParList.setParStatus(5);				
		}
		
		if("Y".equals((String)others.get("urlParProrateSw")) | "Y".equals((String)others.get("urlParNbtPolFlag"))){
			gipiWPolbas.setPolFlag("4");				
		}else if("N".equals((String)others.get("urlParProrateSw")) && "N".equals((String)others.get("urlParNbtPolFlag"))){
			if("Y".equals((String)others.get("urlParEndtCancellation")) | "Y".equals((String)others.get("urlParCoiCancellation"))){
				gipiWPolbas.setPolFlag("1");
				gipiWPolbas.setProrateFlag("2");
			}else{
				gipiWPolbas.setPolFlag("1");
			}
			others.put("nbtPolFlag", "N");
		}			
		
		// insert a record to gipi_parhist
		Map<String, Object> genericMap = new HashMap<String, Object>();
		genericMap.put("parId", gipiParList.getParId());
		genericMap.put("userId", gipiParList.getUserId());
		
		this.getSqlMapClient().queryForObject("gipis031InsertParhist", genericMap);
		
		// clears map
		genericMap.clear();
		
		// update par status
		genericMap.put("parId", gipiWPolbas.getParId());
		genericMap.put("polFlag", gipiWPolbas.getPolFlag());
		genericMap.put("endtTaxSw", pars.get("parEndtTaxSw"));
		this.getSqlMapClient().queryForObject("gipis031UpdateParStatus", genericMap);
		System.out.println("UPDATE PAR STATUS PARAM MAP ::"+genericMap);
		
		gipiParList.setParStatus(genericMap.get("parStatus") == null ? gipiParList.getParStatus() :Integer.parseInt(genericMap.get("parStatus").toString()));
		pars.put("parInsWinvoice", genericMap.get("parInsWinvoice"));			
		preFormsCommitG(Integer.parseInt(gipiWPolbas.getBookingYear()), gipiWPolbas.getBookingMth(), gipiWPolbas.getParId()); //belle 07.17.2012
		/*
		// save records to tables (endt basic info)
		log.info("Saving record on GIPI_PARLIST...");
		this.getSqlMapClient().insert("saveGipiParListFromEndt", gipiParList);
		log.info("Saving record on GIPI_WPOLBAS...");			
		this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);			
		log.info("Saving record on GIPI_WPOLGENIN...");
		this.getSqlMapClient().insert("saveGipiWPolGeninFromEndt", gipiWPolGenin);
		log.info("Saving record on GIPI_WENDTTEXT...");
		this.getSqlMapClient().insert("saveGipiWEndtTextFromEndt", gipiWEndtText);		
		
		// mortgagee
		updateMortgageeRecords(params);
		
		// deductibles
		updateDeductibleRecords(params);
		*/
		/*			
		//Set mapSet = keyCommitMap.entrySet();
		//Iterator mapIterator = mapSet.iterator();
		//
		//while(mapIterator.hasNext()){
		//	Map.Entry<String, Object> entry = (Map.Entry<String, Object>) mapIterator.next();					
		//	//System.out.println("Map - " + entry.getKey() + "=" + entry.getValue());
		//}	
		*/
		log.info("Saving record on GIPI_WPOLBAS...");			
		this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);
		
		this.getSqlMapClient().executeBatch();
		this.getSqlMapClient().getCurrentConnection().commit();
	} catch (Exception e) {
		e.printStackTrace();
		log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		this.getSqlMapClient().getCurrentConnection().rollback();
		throw new SQLException();
	} finally {
		this.getSqlMapClient().endTransaction();
	}
	resultMap.put("message", message);
	return resultMap;
	}


	@Override
	public String checkOldBondNoExist(Map<String, String> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkOldBondNoExist", params);
	}

	@Override
	public Map<String, Object> gipis031KeyCommit(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("gipis031KeyCommit", params);
		return params;
	}

	@Override
	public String validateRenewalDuration(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateRenewalDuration", params);
	}

	@Override
	public Map<String, Object> searchForPolicy(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("searchForPolicy", params);
		return params;
	}

	@Override
	public Map<String, Object> checkClaims(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkClaims", params);
		return params;
	}

	@Override
	public Map<String, Object> checkEnteredPolicyNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkEnteredPolicyNo", params);
		return params;
	}

	@Override
	public Map<String, Object> checkPolicyForSpoilage(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkPolicyForSpoilage", params);
		return params;
	}

	@Override
	public String preGetAmounts(Map<String, Object> params) throws SQLException {		
		return (String) this.getSqlMapClient().queryForObject("preGetAmounts", params);
	}

	@Override
	public Map<String, Object> createNegatedRecordsCoi(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling createNegatedRecordsCoi...");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().update("createNegatedRecordsCoi", params);
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
	public Map<String, Object> createNegatedRecordsEndt(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling createNegatedRecordsEndt...");

		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().update("createNegatedRecordsEndt", params);
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
	public Map<String, Object> createNegatedRecordsFlat(
			Map<String, Object> params) throws SQLException {		
		log.info("DAO calling createNegatedRecordsFlat...");

		try{
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
		
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving record on GIPI_WPOLBAS...");			
			this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);
			
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("createNegatedRecordsFlat", params);
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
	public String checkPolicyForAffectingEndtToCancel(Map<String, Object> params)
			throws SQLException {
		log.info("DAO calling checkPolicyForAffectingEndtToCancel...");
		return (String) this.getSqlMapClient().queryForObject("checkPolicyForAffectingEndtToCancel", params);
	}

	@Override
	public String endtCheckRecordInItemPeril(Integer parId) throws SQLException {
		log.info("DAO calling endtCheckRecordInItemPeril...");
		return (String) this.getSqlMapClient().queryForObject("endtCheckRecordInItemPeril", parId);
	}

	@Override
	public String endtCheckRecordInItem(Integer parId) throws SQLException {
		log.info("DAO calling endtCheckRecordInItem...");
		return this.getSqlMapClient().queryForObject("endtCheckRecordInItem", parId).toString();
	}

	@Override
	public Map<String, Object> insertGipiWPolbasicDetailsForPAR(Map<String, Object> params)
			throws SQLException {
		log.info("Inserting to GIPI_WPOLBAS table...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().update("insertGipiWPolbasicDetailsForPAR", params);
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

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRecordsForCoiCancellation(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling getRecordsForCoiCancellation...");		
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getRecordsForCoiCancellation", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRecordsForEndtCancellation(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling getRecordsForEndtCancellation...");		
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getRecordsForEndtCancellation", params);
	}

	@Override
	public Map<String, Object> processEndtCancellation(
			Map<String, Object> params) throws SQLException {		
		log.info("DAO calling processEndtCancellation...");
		try{
			//robert 10.31.2012
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> genericMap = new HashMap<String, Object>();
			
			log.info("Inserting/Updating record on GIPI_WPOLBAS...");			
			this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);
			this.getSqlMapClient().executeBatch();

			log.info("Performing cancellation - " + params.get("cancellationType") + " Type (gipis031EndtCoiCancellationTagged) ...");
			genericMap.put("cancelType", params.get("cancellationType"));
			genericMap.put("parId", params.get("parId"));
			this.getSqlMapClient().queryForObject("gipis031EndtCoiCancellationTagged", genericMap);
			this.getSqlMapClient().executeBatch();
			
			System.out.println(params.get("parId"));
			log.info(params.get("parId"));
			this.getSqlMapClient().update("processEndtCancellation", params);
			//this.getSqlMapClient().getCurrentConnection().rollback(); 
			this.getSqlMapClient().executeBatch(); //robert 10.24.2012
			this.getSqlMapClient().getCurrentConnection().commit(); //robert 10.24.2012
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
	public Map<String, Object> getRecordsForService(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("getRecordsForService", params);
		return params;
	}

	@Override
	public Map<String, Object> checkPolicyNoForEndt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("checkPolicyNoForEndt", params);
		return params;
	}

	@Override
	public void deleteRecordsForEndtTax(int parId) throws SQLException {
		// 		
	}
	
	private Map<String, Object> loadPolicyNoToMap(String lineCd, String sublineCd, String issCd,
			int issueYy, int polSeqNo, int renewNo){
		
		/*	Created by 	: mark jm 07.21.2010
		 * 	Description	: Returns a HashMap containing the policy_no
		 */
		
		Map<String, Object> policyNoMap = new HashMap<String, Object>();
		
		policyNoMap.put("lineCd", lineCd);
		policyNoMap.put("sublineCd", sublineCd);
		policyNoMap.put("issCd", issCd);
		policyNoMap.put("issueYy", issueYy);
		policyNoMap.put("polSeqNo", polSeqNo);
		policyNoMap.put("renewNo", renewNo);
		
		return policyNoMap;
	}
	
	private Map<String, Object> loadPolicyNoToMap(GIPIWPolbas gipiWPolbas){
		
		/*	Created by 	: mark jm 01.12.2012
		 * 	Description	: Returns a HashMap containing the policy_no
		 */
		
		Map<String, Object> policyNoMap = new HashMap<String, Object>();
		
		policyNoMap.put("lineCd", gipiWPolbas.getLineCd());
		policyNoMap.put("sublineCd", gipiWPolbas.getSublineCd());
		policyNoMap.put("issCd", gipiWPolbas.getIssCd());
		policyNoMap.put("issueYy", gipiWPolbas.getIssueYy());
		policyNoMap.put("polSeqNo", gipiWPolbas.getPolSeqNo());
		policyNoMap.put("renewNo", Integer.parseInt(gipiWPolbas.getRenewNo()));
		
		return policyNoMap;
	}
	
	private GIPIWPolbas deleteRecords(GIPIWPolbas gipiWPolbas) throws SQLException{
		
		/*	Created by 	: mark jm 07.21.2010
		 * 	Description	: Delete records related to endorsement's par_id		 
		 */
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
				gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
		params.put("parId", gipiWPolbas.getParId());
		params.put("effDate", gipiWPolbas.getEffDate());
		params.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());		
		
		this.getSqlMapClient().queryForObject("revertFlatCancellation", params);		
		
		if((String) params.get("msgAlert") != null){
			System.out.println("Revert Flat Cancellation - Message is not null");
		}else{
			gipiWPolbas.setAnnTsiAmt(params.get("annTsiAmt") != null ? 
					new BigDecimal(params.get("annTsiAmt").toString()) : new BigDecimal("0.00"));
			gipiWPolbas.setAnnPremAmt(params.get("annPremAmt") != null ? 
					new BigDecimal(params.get("annPremAmt").toString()) : new BigDecimal("0.00"));
		}		
		
		return gipiWPolbas;
	}
	
	private Map<String, Object> createNegatedRecords(GIPIPARList gipiParList, GIPIWPolbas gipiWPolbas, 
			Map<String, Object> vars, Map<String, Object> others, String cancellationType) throws SQLException{
		
		/*	Created by 	: mark jm 07.21.2010
		 * 	Description	: Create the negated records based on cancellation type
		 * 				: and return changes to affected records
		 */
		
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yy HH:mm:ss");
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		String procedureName = "";
		
		if("Flat".equals(cancellationType)){
			procedureName = "createNegatedRecordsFlat";
		}else if("Endt".equals(cancellationType)){
			procedureName = "createNegatedRecordsEndt";
		}else if("Coi".equals(cancellationType)){
			procedureName = "createNegatedRecordsCoi";
		}
		
		params = loadPolicyNoToMap(gipiWPolbas.getLineCd(), gipiWPolbas.getSublineCd(), gipiWPolbas.getIssCd(),
				gipiWPolbas.getIssueYy(), gipiWPolbas.getPolSeqNo(), Integer.parseInt(gipiWPolbas.getRenewNo()));
		params.put("parId", gipiWPolbas.getParId());						
		params.put("effDate", gipiWPolbas.getEffDate());		
		params.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
		params.put("packPolFlag", gipiWPolbas.getPackPolFlag());
		params.put("effDate", others.get("endtEffDate"));
		
		this.getSqlMapClient().queryForObject(procedureName, params);		
		
		// apply changes to records due to procedure call		
		if((String) params.get("msgAlert") != null){
			System.out.println(cancellationType + " - Message Alert is not null");
			// raise form trigger
		}else{			
			try {
				gipiParList.setParStatus(Integer.parseInt(params.get("parStatus").toString()));														
				gipiWPolbas.setTsiAmt(new BigDecimal(params.get("tsiAmt").toString()));
				gipiWPolbas.setPremAmt(new BigDecimal(params.get("premAmt").toString()));
				gipiWPolbas.setAnnTsiAmt(new BigDecimal(params.get("annTsiAmt").toString()));
				gipiWPolbas.setAnnPremAmt(new BigDecimal(params.get("annPremAmt").toString()));
				
				if((String) params.get("effDate") != null){
					gipiWPolbas.setEffDate(sdfWithTime.parse(params.get("effDate").toString()));
				}
				
				if((String) params.get("inceptDate") != null){
					gipiWPolbas.setInceptDate(sdfWithTime.parse(params.get("inceptDate").toString()));
				}
				
				if((String) params.get("expiryDate") != null){
					gipiWPolbas.setExpiryDate(sdfWithTime.parse(params.get("expiryDate").toString()));
				}
				
				if((String) params.get("endtExpiryDate") != null){
					gipiWPolbas.setEndtExpiryDate(sdfWithTime.parse(params.get("endtExpiryDate").toString()));
				}
				
				vars.put("varExpiryDate", params.get("varExpiryDate").toString());
				
				resultMap.put("gipiParList", gipiParList);
				resultMap.put("gipiWPolbas", gipiWPolbas);
				resultMap.put("vars", vars);
			} catch (ParseException e) {					
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
		}		
		
		return resultMap;
	}
	
	@SuppressWarnings("unchecked")
	private Map<String, Object> processNegatingRecords(Map<String, Object> params) throws SQLException {
		/*	Created by 	: mark jm 07.23.2010
		 * 	Description	: Returns a HashMap containing newly updated objects
		 * 				: affected by the procedure call
		 */
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
		GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");		
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		
		// deleting records affects gipiWPolbas so we need to update it
		gipiWPolbas = deleteRecords(gipiWPolbas);
		
		// create negated records flat						
		paramMap = createNegatedRecords(gipiParList, gipiWPolbas, vars, others, (String) params.get("cancelType"));
		
		// update affected objects
		gipiParList = (GIPIPARList) paramMap.get("gipiParList");
		gipiWPolbas = (GIPIWPolbas) paramMap.get("gipiWPolbas");
		vars = (Map<String, Object>) paramMap.get("vars");
		
		gipiWPolbas.setProrateFlag("2");
		
		if("Flat".equals((String) params.get("cancelType"))){
			gipiWPolbas.setCompSw(null);
			gipiWPolbas.setPolFlag("4");
			gipiWPolbas.setCancelType("1");
			others.put("nbtPolFlag", "Y");
			others.put("prorateSw", "N");
			others.put("coiCancellation", "N");
			others.put("endtCancellation", "N");
			vars.put("varCnclldFlatFlag", "N");
		}else if("Endt".equals((String) params.get("cancelType")) | "Coi".equals((String) params.get("cancelType"))){
			gipiWPolbas.setCompSw("N");
			gipiWPolbas.setPolFlag("1");		
			
			if("Endt".equals((String) params.get("cancelType"))){
				gipiWPolbas.setCancelType("3");
				others.put("endtCancellation", "Y");
				others.put("coiCancellation", "N");
			}else if("Coi".equals((String) params.get("cancelType"))){
				gipiWPolbas.setCancelType("4");
				others.put("endtCancellation", "N");
				others.put("coiCancellation", "Y");
			}
			
			others.put("nbtPolFlag", "N");
			others.put("prorateSw", "N");			
			vars.put("varCnclldFlatFlag", "Y");
		}
		
		resultMap.put("gipiParList", gipiParList);
		resultMap.put("gipiWPolbas", gipiWPolbas);
		resultMap.put("vars", vars);
		resultMap.put("others", others);
		
		return resultMap;
	}

	@Override
	public String getEndtText(int parId) throws SQLException {		
		return (String) this.getSqlMapClient().queryForObject("gipis031GetEndtText", parId);
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
	
	private GIPIWPolbas deleteBill(Map<String, Object> params) throws SQLException {
		
		/*	Created by 	: mark jm 07.28.2010
		 * 	Description	: Delete bill-related records by executing the following procedure		
		 */
		
		GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
		params.remove("gipiWPolbas");
		
		this.getSqlMapClient().queryForObject("gipis031DeleteBill", params);
		if((String) params.get("msgAlert") != null){
			// raise form trigger failure
			System.out.println("Delete Bill - Message is not null");
		}else{
			gipiWPolbas.setAnnTsiAmt(new BigDecimal((String) params.get("annTsiAmt")));
			gipiWPolbas.setAnnPremAmt(new BigDecimal((String) params.get("annPremAmt")));
		}
		
		return gipiWPolbas;
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
		
		/*
		Map<String, Object> insertMortgagee = (Map<String, Object>) params.get("insMortgagee");
		Map<String, Object> deleteMortgagee = (Map<String, Object>) params.get("delMortgagee");
		
		log.info("Saving record on GIPI_WMORTGAGEE...");
		
		if(insertMortgagee != null){
			String[] itemNos	= (String[]) insertMortgagee.get("insMortgItemNos");
			String[] amounts	= (String[]) insertMortgagee.get("insMortgCds");
			String[] mortgCds	= (String[]) insertMortgagee.get("insMortgAmts");
			
			int parId = (Integer) insertMortgagee.get("parId");
			String issCd = (String) insertMortgagee.get("issCd");
			
			if(itemNos != null){				
				for(int i=0; i < itemNos.length; i++){
					this.getSqlMapClient().insert("setGIPIParMortgagee", 
						new GIPIParMortgagee(
							parId, issCd, Integer.parseInt(itemNos[i].toString()),
							mortgCds[i],
							new BigDecimal(amounts[i].replaceAll(",", "")),
							null, null,
							insertMortgagee.get("userId").toString()));					
				}
			}
		}
		
		if(deleteMortgagee != null){
			String[] itemNos	= (String[]) deleteMortgagee.get("delMortgItemNos");				
			String[] mortgCds	= (String[]) deleteMortgagee.get("delMortgCds");
			
			int parId = (Integer) deleteMortgagee.get("parId");			
			
			if(itemNos != null){
				Map<String, Object> deleteMap = new HashMap<String, Object>();
				for(int i=0; i < itemNos.length; i++){
					deleteMap.put("parId", parId);
					deleteMap.put("itemNo", Integer.parseInt(itemNos[i].toString()));
					deleteMap.put("mortgCd", mortgCds[i]);
					
					this.getSqlMapClient().delete("delGIPIParMortgagee", deleteMap);					
					
				}
			}
		}
		*/
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

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> savePARBasicInfo(Map<String, Object> params)
			throws SQLException, InvalidBasicInfoDataException{
		String message = "SUCCESS";
		Map<String, Object> paramsResult = new HashMap<String, Object>();
		paramsResult.put("message", message);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving Basic Info.");
			
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			GIPIWPolbas wpolbas = (GIPIWPolbas) params.get("gipiWpolbas"); 
			GIPIWPolGenin wpolGenin = (GIPIWPolGenin) params.get("gipiWPolGenin");
			Map<String, Object> wpolnrepMap = (Map<String, Object>) params.get("gipiWPolnrepMap"); //andrew - 09.17.2010 - added for saving of policy renewal/replacement detail
			//Map<String, Object> wdeductibleMap = (Map<String, Object>) params.get("gipiWDeductibleMap"); //andrew - 09.20.2010 - added for saving of deductible details
			String openPolicySw = (String) params.get("openPolicySw");
			String validatedBookingDate = (String) params.get("validatedBookingDate");
			String deleteWPolnrep = (String) params.get("deleteWPolnrep");
			String paramAssuredNo = (String) params.get("paramAssuredNo");
			String deleteCoIns = (String) params.get("deleteCoIns");
			String deleteBillSw = (String) params.get("deleteBillSw");
			String deleteAllTables = (String) params.get("deleteAllTables");
			String deleteCommInvoice = (String) params.get("deleteCommInvoice");
			String validatedIssuePlace = (String) params.get("validatedIssuePlace");
			String deleteSw = (String) params.get("deleteSw");
			String precommitDelTab = (String) params.get("precommitDelTab");
			
			// deductibles
			List<GIPIWDeductible> insDeductibles	= (List<GIPIWDeductible>) params.get("setDeductibles");
			List<GIPIWDeductible> delDeductibles	= (List<GIPIWDeductible>) params.get("delDeductibles");

			//pre-update
			if ("Y".equals(deleteAllTables)){
				log.info("New subline cd - Deleting All Tables...");
				Integer parId = wpolbas.getParId();
				this.sqlMapClient.delete("deleteAllTablesGIPIS002", parId);
			}
			log.info("Getting refOpenPolNo.");
			Map<String, String> refOpenPolNo = new HashMap<String, String>();
			refOpenPolNo = preUpdateB540A(wpolbas.getSublineCd(), wpolbas.getRefPolNo());
			String refOpenPolNoTemp = refOpenPolNo.get("refOpenPolNo");
			if (refOpenPolNoTemp != null && refOpenPolNoTemp != "") { //added by steven 9/21/2012
				wpolbas.setRefOpenPolNo((String) refOpenPolNo.get("refOpenPolNo"));
			}
			//end pre-update
			this.getSqlMapClient().executeBatch();
			if ("Y".equals(openPolicySw)) {
				log.info("Checking GIPI_WOPEN_POLICY if exist...");
				Map<String, String> op = new HashMap<String, String>();
				op = preFormsCommitA(wpolbas.getParId());
				String opExist = (String) op.get("exist");
				String opLineCd = (String) op.get("lineCd");
				String opSublineCd = (String) op.get("opSublineCd");
				String opIssCd = (String) op.get("opIssCd");
				String opIssueYy = (String) op.get("opIssueYy");
				String opPolSeqNo = (String) op.get("opPolSeqNo");
				String opRenewNo = (String) op.get("opRenewNo");
				if("Y".equals(opExist)){
					Map<String, String> op2 = new HashMap<String, String>();
					op2 = preFormsCommitB(opLineCd, opSublineCd, opIssCd, opIssueYy, opPolSeqNo, opRenewNo, sdf.format(wpolbas.getInceptDate()), sdf.format(wpolbas.getExpiryDate())); 
					message = (String) op2.get("msgAlert"); 
					paramsResult.put("message", message);
					if (!"SUCCESS".equals(message)){
						throw new InvalidBasicInfoDataException(message);
					}
				}
			}else{
				log.info("Deleting GIPI_WOPEN_POLICY...");
				preFormsCommitC(wpolbas.getParId());
			}
			this.getSqlMapClient().executeBatch();
			
			if ("Y".equals(validatedBookingDate)) {
				log.info("Validating booking date...");
				validateBookingDate(Integer.parseInt(wpolbas.getBookingYear()), wpolbas.getBookingMth(), sdf.format(wpolbas.getIssueDate()), sdf.format(wpolbas.getInceptDate()));
				/*message = validateBookingDate(Integer.parseInt(wpolbas.getBookingYear()), wpolbas.getBookingMth(), sdf.format(wpolbas.getIssueDate()), sdf.format(wpolbas.getInceptDate()));
				paramsResult.put("message", message);
				if (!"SUCCESS".equals(message)){
					throw new InvalidBasicInfoDataException(message);
				}*/
			}
			this.getSqlMapClient().executeBatch();
			if ("SUCCESS".equals(message)){
				if ("Y".equals(precommitDelTab)){
					this.getSqlMapClient().delete("precommitDelTabGIPIS002", wpolbas.getParId());
				}
				preFormsCommitG(Integer.parseInt(wpolbas.getBookingYear()), wpolbas.getBookingMth(), wpolbas.getParId());
				if ("Y".equals(deleteWPolnrep)) {
					log.info("Deleting Gipi_WPolnrep...");
					this.getSqlMapClient().delete("deleteWPolnreps", wpolbas.getParId());
				}				
				// andrew - 09.17.2010 - added for saving of renewal/replacement details 
				if ("2".equals(wpolbas.getPolFlag()) || "3".equals(wpolbas.getPolFlag())){
					String[] delOldPolicyIds = (String[]) wpolnrepMap.get("delOldPolicyIds");
					String[] insOldPolicyIds = (String[]) wpolnrepMap.get("insOldPolicyIds");
					this.deleteGIPIWPolnreps(wpolbas.getParId(), delOldPolicyIds);
					this.insertGIPIWPolnreps(wpolbas.getParId(), insOldPolicyIds, wpolbas.getPolFlag(), wpolbas.getUserId());
				}
				
				// andrew - 09.20.2010 - added for saving of deductible details
				//System.out.println(wdeductibleMap);
				//Map<String, Object> insWDeductibleMap = (Map<String, Object>) wdeductibleMap.get("insParams"); 
				//Map<String, Object> delWDeductibleMap = (Map<String, Object>) wdeductibleMap.get("delParams");
				//this.deleteGIPIWDeductibles(delWDeductibleMap, wpolbas.getParId(), wpolbas.getLineCd(), wpolbas.getSublineCd());
				//this.insertGIPIWDeductibles(insWDeductibleMap, wpolbas.getParId(), wpolbas.getLineCd(), wpolbas.getSublineCd(), wpolbas.getUserId());								
				//this.getSqlMapClient().executeBatch();
				if (!wpolbas.getAssdNo().equals(paramAssuredNo)){
					log.info("Validating Assured Name...");
					validateAssdName(wpolbas.getParId(), wpolbas.getLineCd(), wpolbas.getIssCd());
				}
				this.getSqlMapClient().executeBatch();
				if ("Y".equals(deleteCoIns)){
					log.info("Validating co-insurance");
					validateCoInsurance2(wpolbas.getParId(), Integer.parseInt(wpolbas.getCoInsuranceSw()));
				}
				this.getSqlMapClient().executeBatch();
				/*if ("Y".equals(deleteBillSw)){
					log.info("Deleting bill...");
					deleteBill(wpolbas.getParId(), Integer.parseInt(wpolbas.getCoInsuranceSw()));
				}
				this.getSqlMapClient().executeBatch();*///commented out edgar relocated below 02/04/2015
				
				log.info("Updating expiry date in GIUW_POL_DIST...");
				validateExpiryDate(wpolbas.getParId(), sdf.format(wpolbas.getExpiryDate()));
				log.info("Saving GIPI_WPOLBAS...");
				saveGipiWPolbas(wpolbas);
				
				this.getSqlMapClient().executeBatch();
				
				//Apollo 10.03.2014
				if("Y".equals(deleteCommInvoice)){
					log.info("Deleting Commission Invoice...");
					this.getSqlMapClient().update("delCommInvoiceRelatedRecs", wpolbas.getParId());
					this.getSqlMapClient().executeBatch();
				}
				
				//apollo cruz 09.22.2014 - transferred creating of invoice after saving of gipiwpolbas
				if ("Y".equals(validatedIssuePlace)){
					log.info("Creating winvoice...");
					createWinvoice(wpolbas.getParId(), wpolbas.getLineCd(), wpolbas.getIssCd());
				}
				this.getSqlMapClient().executeBatch();
				
				if ("Y".equals(wpolbas.getPackPolFlag())){
					log.info("Post-insert b540 block trigger populate package.");
					Map<String, Object> populatePackageParams = new HashMap<String, Object>();
					populatePackageParams.put("parId", wpolbas.getParId());
					populatePackageParams.put("lineCd", wpolbas.getLineCd());
					this.getSqlMapClient().insert("populatePackage", populatePackageParams);
				}
				if (("".equals(wpolGenin.getDspInitialInfo())) && ("".equals(wpolGenin.getDspGenInfo()))){
					log.info("Deleting Gipi_WPolGenin...");
					this.sqlMapClient.delete("deleteGipiWPolGenin", wpolbas.getParId());
				} else {
					log.info("Saving GIPI_WPOLGENIN...");
					this.getSqlMapClient().insert("saveGipiWPolGenin", wpolGenin);
				}
				this.getSqlMapClient().executeBatch();
				log.info("Saving PAR hist...");
				insertParHist(wpolbas.getParId(), wpolbas.getUserId());
				log.info("Updating PAR status...");
				updateParStatus(wpolbas.getParId());
				
				Map<String, String> postFormA = new HashMap<String, String>();
				postFormA = postFormsCommitA(wpolbas.getParId(), Integer.parseInt(wpolbas.getCoInsuranceSw()), (String) params.get("dateSw"));
				this.getSqlMapClient().executeBatch();
				String longTermDist = (String) postFormA.get("longTermDist");
				if ("Y".equals(deleteSw)){
					log.info("Creating Long Term distribution...");
					Map<String, String> pars = new HashMap<String, String>();
					pars = validateTakeupTerm(wpolbas.getParId(), wpolbas.getLineCd(), wpolbas.getIssCd());
					message = (String) pars.get("msgAlert");
					paramsResult.put("message", message);
					if (!"SUCCESS".equals(message)){
						throw new InvalidBasicInfoDataException(message);
					}
				}
				this.getSqlMapClient().executeBatch();
				if ("Y".equals(deleteBillSw)){ //relocated codes from above edgar 02/04/2015
					log.info("Deleting bill...");
					deleteBill(wpolbas.getParId(), Integer.parseInt(wpolbas.getCoInsuranceSw()));
				}
				this.getSqlMapClient().executeBatch();
				postFormsCommitD(wpolbas.getParId(), Integer.parseInt(wpolbas.getAssdNo()));
				updatepolDist(sdf.format(wpolbas.getInceptDate()), wpolbas.getParId(), longTermDist);
				this.getSqlMapClient().executeBatch();
				// insert, update, delete mortgagee
				if((params.get("mortgageeInsList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeInsList")).size() > 0) || 
					(params.get("mortgageeDelList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeDelList")).size() > 0)){				
					updateMortgageeRecords(params);
				}				
				this.getSqlMapClient().executeBatch();
				
				// GIPI_WDEDUCTIBLES (delete)
				for(GIPIWDeductible ded : delDeductibles){
					log.info("Deleting record on gipi_wdeductibles ...");
					this.getSqlMapClient().delete("delGipiWDeductible2", ded);
				}
				
				// GIPI_WDEDUCTIBLES (insert/update)
				for(GIPIWDeductible ded : insDeductibles){
					log.info("Inserting/Updating record on gipi_wdeductibles ...");
					this.getSqlMapClient().insert("saveWDeductible", ded);
				}
				this.getSqlMapClient().executeBatch();
				
				//insert open policy details
				if ("Y".equals(params.get("openPolicySw"))){
					log.info("Inserting open policy details...");
					Map<String, Object> opParams = (Map<String, Object>) params.get("opParams");
					
					this.getSqlMapClient().queryForObject("saveOpenPolicy1", opParams);
					
					String openPolicyChanged = (String) params.get("openPolicyChanged");
					System.out.println("openPolicyChanged: "+openPolicyChanged);
					if ("Y".equals(openPolicyChanged)){
						log.info("Inserting policy details for parId "+opParams.get("parId"));
						this.getSqlMapClient().queryForObject("saveOpenPolicy2", opParams);
						this.getSqlMapClient().queryForObject("saveOpenPolicyDetails", opParams);
					}
				}

				message = "SUCCESS";
				paramsResult.put("message", message);
				paramsResult.put("bankRefNo", wpolbas.getBankRefNo());
				paramsResult.put("gipiWPolbas", wpolbas);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (com.geniisys.gipi.exceptions.InvalidBasicInfoDataException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (SQLException e) {
			log.info("Error while saving Basic Info.");
			//e.printStackTrace();
			//log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException(); //andrew - 09.17.2010 - causing null error
			//throw e; 
			//modified error message to be shown by robert 09.13.2013
			if(e.getErrorCode() > 20000){
				message = this.extractSqlExceptionMessage2(e);
				ExceptionHandler.logException(e);
			} else {
				message = "SQL Exception occured while saving...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of saving Basic Info.");
			paramsResult.put("message", message);
		}
		return paramsResult;
	}
	
	// andrew - 09.17.2010 - added for deleting of renewal/replacement details
	private void deleteGIPIWPolnreps (int parId, String[] delOldPolicyIds) throws SQLException{
		if (delOldPolicyIds != null){
			for(String delOldPolicyId: delOldPolicyIds){
				log.info("DAO - Deleting GIPIWPolnrep... : PAR_ID : " + parId + " : OLD_POLICY_ID : " + delOldPolicyId);
				Map<String, Object> delWPolnrepParams = new HashMap<String, Object>();
				delWPolnrepParams.put("parId", parId);
				delWPolnrepParams.put("oldPolicyId", delOldPolicyId);
				this.getSqlMapClient().delete("deleteWPolnrep", delWPolnrepParams);						
			}
			
			log.info("DAO - " + delOldPolicyIds.length + " GIPIWPolnrep deleted.");	
		}
	}
	
	// andrew - 09.17.2010 - added for saving of renewal/replacement details
	private void insertGIPIWPolnreps (int parId, String[] insOldPolicyIds, String polFlag, String userId) throws SQLException{
		if (insOldPolicyIds != null){
			for(String insOldPolicyId: insOldPolicyIds){
				log.info("DAO - Inserting GIPIWPolnrep... : PAR_ID : " + parId + " : OLD_POLICY_ID : " + insOldPolicyId);
				Map<String, Object> insWPolnrepParams = new HashMap<String, Object>();
				insWPolnrepParams.put("parId", parId);
				insWPolnrepParams.put("oldPolicyId", insOldPolicyId);
				insWPolnrepParams.put("polFlag", polFlag);
				insWPolnrepParams.put("userId", userId);
				this.getSqlMapClient().delete("saveWPolnrep", insWPolnrepParams);
			}
			log.info("DAO - " + insOldPolicyIds.length + " GIPIWPolnrep inserted.");
		}
	}	

	@Override
	public String getPolicyNoForEndt(Integer parId) throws SQLException {
		log.info("Getting Policy No...");
		String polNo = (String) this.getSqlMapClient().queryForObject("getPolicyNoForEndt", parId);
		log.info("Policy No: " + polNo + "retrieved...");
		return polNo;
	}

	@Override
	public Map<String, Object> updateGipiWPolbasEndt(Map<String, Object> params)
			throws SQLException {
		log.info("Updating gipi_wpolbas ...");
		System.out.println(params);
		this.getSqlMapClient().queryForObject("updateGipiWPolbasEndt", params);
		System.out.println(params);
		return params;
	}

	@Override
	public String iisExistWItem(Integer parId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("isExistGIPIWitem", parId);
	}

	@Override
	public Map<String, Object> getFixedFlag(Map<String, Object> params)	throws SQLException {		
		this.sqlMapClient.queryForObject("getFixedFlag", params);
		return params;
	}

	@Override
	public Map<String, Object> getFixedFlagGIPIS017B(Map<String, Object> params)	throws SQLException {		
		this.sqlMapClient.queryForObject("getFixedFlagGIPIS017B", params);
		return params;
	}
	
	@Override
	public Map<String, Object> genBankDetails(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("generateBankRefNo", params);
		return params;
	}

	@Override
	public String validateAcctIssCd(String nbtAcctIssCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateAcctIssCd", nbtAcctIssCd);
	}

	@Override
	public String validateBranchCd(HashMap<String, String> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateBranchCd", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIRefNoHist> getBankRefNoList(HashMap<String, Object> params)
			throws SQLException {
		if(params.get("isPack").equals("Y")){
			return this.sqlMapClient.queryForList("getBankRefNoListingForPack", params);
		}else{
			return this.sqlMapClient.queryForList("getBankRefNoListing", params);
		}
	}

	@Override
	public String validateBankRefNo(HashMap<String, String> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateBankRefNo", params);
	}

	@Override
	public Map<String, Object> coInsurance(Integer parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		this.sqlMapClient.update("coInsuranceGIPIS002", params);
		return params;
	}

	@Override
	public Map<String, Object> getEndtRiskTag(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getEndtRiskTag", params);
		return params;
	}

	@Override
	public Map<String, Object> searchForEditedPolicy(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("searchForEditedPolicy", params);
		return params;
	}

	public String checkPaidPolicy(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkPaidPolicy", params);
	}
	
	public Integer checkAvailableEndt(Map<String, Object> params)
		throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkAvailableEndt", params);
	}
	
	public GIPIWPolbas getEndtBancassuranceDtl(Integer parId) throws SQLException {
		return (GIPIWPolbas) this.getSqlMapClient().queryForObject("getEndtBancassuranceDtl", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDAO#getWpolbasParIdByPolFlag(java.lang.String, java.lang.Integer)
	 */
	@Override
	public Integer getWpolbasParIdByPolFlag(String polFlag, Integer parId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("polFlag", polFlag);
		params.put("parId", parId);
		return (Integer)this.getSqlMapClient().queryForObject("getWpolbasParIdByPolFlag", params);
	}
	
	public Map<String, Object> validateEffDateB5401(Map<String, Object> params)
		throws SQLException {
		this.getSqlMapClient().update("validateEffDateB5401", params);
		log.info("validateEffDateB5401 - "+params);
		return params;
	}

	@Override
	public Map<String, Object> getCoverNoteDetails(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getCoverNoteDetails", params);
		Debug.print("Cover Note Details: " + params);
		return params;
	}

	@Override
	public void updateCoverNoteDetails(Map<String, Object> params)
			throws Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			
			if(params.get("updCNDetailsSw").equals("Y")){
				log.info("Updating gipi_wpolbas cover note details...");
				this.getSqlMapClient().update("updateCoverNoteDetails", params);
				this.getSqlMapClient().executeBatch();
			}
			
			log.info("Updating gipi_wpolbas cover note printed sw...");
			this.getSqlMapClient().update("updateCoverNotePrintedSw", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e; 
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e; 
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public GIPIWPolbas updateBookingDates(GIPIWPolbas polbas)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		/*params.put("issueDate", df.format(polbas.getIssueDate()));
		params.put("inceptDate", df.format(polbas.getInceptDate()));*/
		params.put("issueDate", polbas.getIssueDate());
		params.put("inceptDate", polbas.getInceptDate());
		log.info("Getting booking dates - "+params);
		this.getSqlMapClient().update("getBookingDateGIPIS165", params);
		log.info("Retrieved booking dates - "+params);
		polbas.setBookingMth((String) (params.get("bookingMonth")==null ? "" : params.get("bookingMonth")));
		polbas.setBookingYear((String) (params.get("bookingYear")==null ? "" : params.get("bookingYear")));
		return polbas;
	}	

	@Override
	public Map<String, Object> searchForPolicy1(Map<String, Object> params)
			throws SQLException {
		log.info("Searching for policy ...");
		this.getSqlMapClient().update("searchForPolicy1", params);
		return params;
	}

	@Override
	public Map<String, Object> gipis031NewFormInstance1(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS031 New Form Instance variables ...");
		this.getSqlMapClient().queryForObject("gipis031NewFormInstance1", params);
		return params;
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate01(
			Map<String, Object> params) throws SQLException {
		log.info("Validating effectivity date (Part 1) ...");
		this.getSqlMapClient().queryForObject("gipis031ValidateEffDate01", params);
		return params;
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate02(
			Map<String, Object> params) throws SQLException {
		log.info("Validating effectivity date (Part 2) ...");
		//this.getSqlMapClient().queryForObject("gipis031ValidateEffDate02", params); -- replaced by: Nica 08.30.2012
		this.getSqlMapClient().queryForObject("gipis031ValidateEffDate02Revised", params);
		return params;
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate03(
			Map<String, Object> params) throws SQLException {
		log.info("Validating effectivity date (Part 3) ...");
		//this.getSqlMapClient().queryForObject("gipis031ValidateEffDate03", params); -- replaced by: Nica 08.30.2012
		this.getSqlMapClient().queryForObject("gipis031ValidateEffDate03Revised", params);
		return params;
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate04(
			Map<String, Object> params) throws SQLException {
		log.info("Validating effectivity date (Part 4) ...");
		this.getSqlMapClient().queryForObject("gipis031ValidateEffDate04", params);
		return params;
	}	

	@Override
	public Map<String, Object> gipis031ValidateEndtExpiryDate(
			Map<String, Object> params) throws SQLException {
		log.info("Validating endt expiry date ...");
		this.getSqlMapClient().queryForObject("gipis031ValidateEndtExpiryDate", params);		
		return params;
	}	

	@Override
	public Map<String, Object> gipis031ValidateInceptDate01(
			Map<String, Object> params) throws SQLException {
		log.info("Validating incept date (Part 1) ...");
		this.getSqlMapClient().queryForObject("gipis031ValidateInceptDate01", params);		
		return params;
	}

	@Override
	public Map<String, Object> gipis031ValidateInceptDate02(
			Map<String, Object> params) throws SQLException {
		log.info("Validating incept date (Part 2) ...");
		this.getSqlMapClient().queryForObject("gipis031ValidateInceptDate02", params);		
		return params;
	}
	
	

	@Override
	public Map<String, Object> gipis031ValidateExpiryDate01(
			Map<String, Object> params) throws SQLException {
		//log.info("Validating expiry date ...");
		//this.getSqlMapClient().queryForObject("gipis031ValidateExpiryDate01", params);
		this.getSqlMapClient().update("gipis031ValidateExpiryDate01", params); // replaced by: Nica 06.27.2012
		log.info("After Params: "+params);
		return params;
	}	

	@Override
	public Map<String, Object> gipis031ValidateIssueDate01(
			Map<String, Object> params) throws SQLException {
		log.info("Validating issue date ...");
		this.getSqlMapClient().queryForObject("gipis031ValidateIssueDate01", params);		
		return params;
	}

	@Override
	public Map<String, Object> gipis031GetBookingDate(Map<String, Object> params)
			throws SQLException {
		log.info("Getting booking date (GIPIS031) ...");
		this.getSqlMapClient().queryForObject("gipis031GetBookingDate", params);
		return params;
	}	

	@Override
	public String gipis031CheckNewRenewals(Map<String, Object> params)
			throws SQLException {
		log.info("Checking new renewals ...");		
		return (String) this.getSqlMapClient().queryForObject("gipis031CheckNewRenewals", params);
	}
	
	

	@SuppressWarnings("finally")
	@Override
	public Map<String, Object> gipis031EndtCoiCancellationTagged(
			Map<String, Object> params) throws SQLException, JSONException, ParseException {
		try{
			log.info("Endt/Coi Cancellation was tagged ...");
			
			Map<String, Object> genericMap = new HashMap<String, Object>();
			
			GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Inserting/Updating record on GIPI_WPOLBAS...");			
			this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);
			this.getSqlMapClient().executeBatch();
			
			log.info("Performing cancellation - " + params.get("cancelType") + " Type (gipis031EndtCoiCancellationTagged) ...");
			genericMap.put("cancelType", params.get("cancelType"));
			genericMap.put("parId", params.get("parId"));
			this.getSqlMapClient().queryForObject("gipis031EndtCoiCancellationTagged", genericMap);
			this.getSqlMapClient().executeBatch();
			
			params.put("itemCount", (Integer) this.getSqlMapClient().queryForObject("getWItemCount", gipiWPolbas.getParId()));
			params.put("perilCount", (Integer) this.getSqlMapClient().queryForObject("getGIPIWItmperlCount", gipiWPolbas.getParId()));
			
			this.getSqlMapClient().getCurrentConnection().rollback();
			//this.getSqlMapClient().getCurrentConnection().commit(); //robert 10.24.2012
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
			return params;
		}		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveEndtBasicInfo01(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		try{
			log.info("Saving endt basic info ...");
			String userId = (String) params.get("userId");
			GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
			GIPIWPolGenin gipiWPolGenin = (GIPIWPolGenin) params.get("gipiWPolGenin");
			GIPIWEndtText gipiWEndtText = (GIPIWEndtText) params.get("gipiWEndtText");
			GIPIWEndtText oldGIPIWEndtText = new GIPIWEndtText(); // record from database before updating
			
			
			gipiWEndtText.setUserId(userId);
			gipiWPolGenin.setUserId(userId);
			
			JSONObject vars = (JSONObject) params.get("variables");
			JSONObject pars = (JSONObject) params.get("parameters");
			
			// mortgagees
			List<GIPIParMortgagee> insMortgagees		= (List<GIPIParMortgagee>) params.get("setMortgagees");
			List<Map<String, Object>> delMortgagees		= (List<Map<String, Object>>) params.get("delMortgagees");			
						
			// deductibles
			List<GIPIWDeductible> insDeductibles		= (List<GIPIWDeductible>) params.get("setDeductibles");
			List<GIPIWDeductible> delDeductibles		= (List<GIPIWDeductible>) params.get("delDeductibles");
			
			Map<String, Object> genericMap = new HashMap<String, Object>();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// get the record of gipi_wendttext from the database first
			oldGIPIWEndtText = (GIPIWEndtText) this.getSqlMapClient().queryForObject("getGIPIWEndttext", gipiWPolbas.getParId());
			
			// save records to tables (endt basic info)	
			
			// set industry_cd first before saving gipi_wpolbas
			//gipiWPolbas.setIndustryCd(String.valueOf((Integer) this.getSqlMapClient().queryForObject("getIndustryCd", Integer.parseInt(gipiWPolbas.getAssdNo())))); --robert
			
			// save records to tables (endt basic info)
			log.info("Saving record on GIPI_PARLIST...");
			this.getSqlMapClient().insert("saveGipiParListFromEndt", gipiParList);
			System.out.println("before save :"+gipiWPolbas.getEffDate());
			log.info("Saving record on GIPI_WPOLBAS...");			
			this.getSqlMapClient().insert("saveGipiWPolbasFromEndt", gipiWPolbas);			
			System.out.println("after save :"+gipiWPolbas.getEffDate());
			log.info("Saving record on GIPI_WPOLGENIN...");			
			this.getSqlMapClient().insert("saveGipiWPolGeninFromEndt", gipiWPolGenin);
			
			log.info("Saving record on GIPI_WENDTTEXT...");			
			this.getSqlMapClient().insert("saveGipiWEndtTextFromEndt", gipiWEndtText);
			
			// GIPI_WMORTGAGEE (delete)
			for(Map<String, Object> delMap : delMortgagees){
				log.info("Deleting record on gipi_wmortgagee ...");
				this.getSqlMapClient().delete("delGIPIParMortgagee", delMap);
			}
			
			// GIPI_WMORTGAGEE (insert/update)
			for(GIPIParMortgagee m : insMortgagees){
				log.info("Inserting/Updating record on gipi_wmortgagee ...");
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
			}			
			
			// GIPI_WDEDUCTIBLES (delete)
			for(GIPIWDeductible ded : delDeductibles){
				log.info("Deleting record on gipi_wdeductibles ...");
				this.getSqlMapClient().delete("delGipiWDeductible2", ded);
			}
			
			// GIPI_WDEDUCTIBLES (insert/update)
			for(GIPIWDeductible ded : insDeductibles){
				log.info("Inserting/Updating record on gipi_wdeductibles ...");
				this.getSqlMapClient().insert("saveWDeductible", ded);			
			}
			
			this.getSqlMapClient().executeBatch();
			
			//if policy no. has been changed, all related tables must be deleted - Nica 05.06.2013
			if("Y".equals(vars.getString("varPolChangedSw"))){
				genericMap.clear();
				genericMap = loadPolicyNoToMap(gipiWPolbas);
				genericMap.put("effDate", gipiWPolbas.getEffDate());
				genericMap.put("parId", gipiWPolbas.getParId());
				log.info("Policy no. has been changed, deleting all related tables: "+genericMap);
				this.getSqlMapClient().queryForObject("gipis031DeleteAllTables", genericMap);
				this.getSqlMapClient().executeBatch();
			}
			
			
			// based on trigger hierarchy			
			// nbtPolFlag/prorateSw is checked
			if("1".equals(gipiWPolbas.getCancelType()) || "2".equals(gipiWPolbas.getCancelType())){
				genericMap.clear();
				genericMap.put("parId", gipiWPolbas.getParId());
				
				if("1".equals(gipiWPolbas.getCancelType())){
					log.info("Performing cancellation - Cancelled Flat Type (gipis031PolFlagProrateFlagTagged) ..."+gipiWPolbas.getCancelType());
					genericMap.put("cancelType", "POL_FLAG");	
				}else if("2".equals(gipiWPolbas.getCancelType())){
					log.info("Performing cancellation - Cancelled Type (gipis031PolFlagProrateFlagTagged) ..."+gipiWPolbas.getCancelType());
					genericMap.put("cancelType", "PRORATE");
					genericMap.put("compSw", gipiWPolbas.getCompSw()); //Added by Jerome Bautista 10.15.2015 SR 20567
				}				
							
				this.getSqlMapClient().queryForObject("gipis031PolFlagProrateFlagTagged", genericMap);
				this.getSqlMapClient().executeBatch();
				// Added by Jomar Diago 01072012
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			    genericMap.clear();
			    genericMap.put("parId", gipiWPolbas.getParId());
			    genericMap.put("effDate", df.format(gipiWPolbas.getEffDate()));
			    genericMap.put("endtExpiryDate", df.format(gipiWPolbas.getEndtExpiryDate())); //robert 01.14.2013
			    getSqlMapClient().update("updateGipiwpolbasEffDate", genericMap);
			    getSqlMapClient().executeBatch();
			// endt/coi cancellation is checked
			}
			
			else if("3".equals(gipiWPolbas.getCancelType()) || "4".equals(gipiWPolbas.getCancelType())){
				genericMap.clear();
				genericMap.put("parId", gipiWPolbas.getParId());
				
				if("3".equals(gipiWPolbas.getCancelType())){
					log.info("Performing cancellation - Endt Cancellation Type (gipis031EndtCoiCancellationTagged) ...");
					//genericMap.put("cancelType", "POL_FLAG");	
					genericMap.put("cancelType", "ENDT");	//robert 9.28.2012
				}else if("4".equals(gipiWPolbas.getCancelType())){
					log.info("Performing cancellation - Coi Cancellation Type (gipis031EndtCoiCancellationTagged) ...");
					//genericMap.put("cancelType", "PRORATE");
					genericMap.put("cancelType", "COI");	//robert 9.28.2012
				}				
				this.getSqlMapClient().queryForObject("gipis031EndtCoiCancellationTagged", genericMap);
				this.getSqlMapClient().executeBatch();
				
				//commented out by robert 10.24.2012
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
				genericMap.clear();
				genericMap = loadPolicyNoToMap(gipiWPolbas);
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("policyId", gipiWPolbas.getCancelledEndtId());
				genericMap.put("packPolFlag", gipiWPolbas.getPackPolFlag());
				genericMap.put("cancelType", gipiWPolbas.getCancelType());
				genericMap.put("effDate", df.format(gipiWPolbas.getEffDate()));
				this.getSqlMapClient().update("processEndtCancellation", genericMap);
				this.getSqlMapClient().executeBatch();
			}
			
			//pre-commit
			if("Y".equals(pars.getString("paramDeleteAllTables"))){
				log.info("Deleting all tables (gipis031DeleteAllTables) ...");
				genericMap.clear();
				genericMap = loadPolicyNoToMap(gipiWPolbas);
				genericMap.put("effDate", gipiWPolbas.getEffDate());
				genericMap.put("parId", gipiWPolbas.getParId());
				//this.getSqlMapClient().queryForObject("gipis031DeleteAllTables", params); // replaced by: Nica 05.04.2013
				this.getSqlMapClient().queryForObject("gipis031DeleteAllTables", genericMap);
				this.getSqlMapClient().executeBatch();
			}
			
			if("Y".equals(pars.getString("paramDeleteBill"))){
				log.info("Deleting bill (gipis031DeleteBill) ...");
				genericMap.clear();
				genericMap = loadPolicyNoToMap(gipiWPolbas);
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("effDate", gipiWPolbas.getEffDate());
				genericMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
				//this.getSqlMapClient().queryForObject("gipis031DeleteBill", params); // replaced by: Nica 05.04.2013
				this.getSqlMapClient().queryForObject("gipis031DeleteBill", genericMap);
				this.getSqlMapClient().executeBatch();
			}
			
			if("Y".equals(pars.getString("paramRevertFlatCancellation"))){				
				log.info("Deleting other info (gipis031DeleteOtherInfo) - RevertFlatCancellation ...");
				this.getSqlMapClient().queryForObject("gipis031DeleteOtherInfo", gipiWPolbas.getParId());
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting records (gipis031DeleteRecords01) - RevertFlatCancellation  ...");
				genericMap.clear();
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("lineCd", gipiWPolbas.getLineCd());
				genericMap.put("effDate", gipiWPolbas.getEffDate());
				genericMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
				this.getSqlMapClient().queryForObject("gipis031DeleteRecords01", genericMap);				
				this.getSqlMapClient().executeBatch();
			}			
			
			if("Y".equals(pars.getString("paramCreateNegatedRecordsProrate"))){
				log.info("Creating Negated Records Prorate (gipis031CreateNegatedRecordsProrate) ...");
				
				log.info("Deleting other info (gipis031DeleteOtherInfo) - RevertFlatCancellation ...");
				this.getSqlMapClient().queryForObject("gipis031DeleteOtherInfo", gipiWPolbas.getParId());
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting records (gipis031DeleteRecords01) - RevertFlatCancellation  ...");
				genericMap.clear();
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("lineCd", gipiWPolbas.getLineCd());
				genericMap.put("effDate", gipiWPolbas.getEffDate());
				genericMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
				this.getSqlMapClient().queryForObject("gipis031DeleteRecords01", genericMap);				
				this.getSqlMapClient().executeBatch();
				
				genericMap.clear();
				genericMap = loadPolicyNoToMap(gipiWPolbas);
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("coInsuranceSw", gipiWPolbas.getCoInsuranceSw());
				genericMap.put("packPolFlag", gipiWPolbas.getPackPolFlag());
				genericMap.put("prorateFlag", gipiWPolbas.getProrateFlag());
				genericMap.put("compSw", gipiWPolbas.getCompSw());
				genericMap.put("shortRtPercent", gipiWPolbas.getShortRtPercent());
				genericMap.put("effDate", gipiWPolbas.getEffDate());
				genericMap.put("inceptDate", gipiWPolbas.getInceptDate()); //Added by Jerome 11.22.2016 SR 23307
				
				
				this.getSqlMapClient().queryForObject("gipis031CreateNegatedRecordsProrate", genericMap);
				this.getSqlMapClient().executeBatch();
				
				genericMap.put("userId", userId);
				this.getSqlMapClient().update("updateWpolbasPremTsiAmts", genericMap); // added by: Nica 09.13.2012 - solution to SR 10685
				this.getSqlMapClient().executeBatch();
			}
			
			if("Y".equals(pars.getString("paramInsertParHist"))){
				log.info("Inserting record to parhist (gipis031InsertParhist) ...");
				genericMap.clear();
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("userId", gipiWPolbas.getUserId());
				this.getSqlMapClient().queryForObject("gipis031InsertParhist", genericMap);
				this.getSqlMapClient().executeBatch();
			}
			
			//robert
			if("Y".equals(pars.getString("assuredChange"))){
				log.info("Updating Change in Assured...");
				genericMap.clear();
				genericMap.put("parId", gipiParList.getParId());
				genericMap.put("lineCd", gipiParList.getLineCd());
				genericMap.put("issCd", gipiParList.getIssCd());
				this.getSqlMapClient().update("updateChangeInAssd", genericMap);
				this.getSqlMapClient().executeBatch();
			}
			
			if(oldGIPIWEndtText != null){
				String oldEndtTax = oldGIPIWEndtText.getEndtTax() != null ? oldGIPIWEndtText.getEndtTax() : "N";
				String newEndtTax = gipiWEndtText.getEndtTax() != null ? gipiWEndtText.getEndtTax() : "N";
				
				if(!(oldEndtTax.equals(newEndtTax))){
					log.info("Deleting record on gipi_winstallment ...");
					this.getSqlMapClient().delete("deleteGIPIWinstallment2", gipiWPolbas.getParId());
					
					log.info("Deleting record on gipi_wcomm_inv_perils ...");
					this.getSqlMapClient().delete("deleteGIPIWCommInvPerilsByParId", gipiWPolbas.getParId());
					
					log.info("Deleting record on gipi_wcomm_invoices ...");
					this.getSqlMapClient().delete("deleteGIPIWCommInvoicesByParId", gipiWPolbas.getParId());
					
					log.info("Deleting record on gipi_winvperl ...");
					this.getSqlMapClient().delete("delGIPIWInvPerl", gipiWPolbas.getParId());
					
					log.info("Deleting record on gipi_winvtax ...");
					this.getSqlMapClient().delete("deleteAllGIPIWinvTax", gipiWPolbas.getParId());
					
					log.info("Deleting record on gipi_wpackage_inv_tax ...");
					this.getSqlMapClient().delete("deleteGIPIWPackageInvTaxByParId", gipiWPolbas.getParId());
					
					log.info("Deleting record on gipi_winvoice ...");
					this.getSqlMapClient().delete("delGIPIWInvoice", gipiWPolbas.getParId());
				}		
			}
			
			// key-commit
			if("Y".equals(pars.getString("paramCreateWinvoice"))){
				log.info("Creating winvoice (createWinvoice1) ...");
				genericMap.clear();
				genericMap.put("policyId", 0);
				genericMap.put("polIdN", 0);
				genericMap.put("oldParId", 0);
				genericMap.put("parId", gipiWPolbas.getParId());
				genericMap.put("lineCd", gipiWPolbas.getLineCd());
				genericMap.put("issCd", gipiWPolbas.getIssCd());				
				if("Y".equals(pars.getString("paramEndtTaxSw"))){	//Gzelle 04172015 -  to avoid ORA-1400 when EndtTax is tagged
					log.info("Creating winvoice with paramEndtTaxSw: "+pars.getString("paramEndtTaxSw"));
					this.getSqlMapClient().queryForObject("createWinvoice1", genericMap);
				} else {
					this.getSqlMapClient().queryForObject("createWInvoice", genericMap);
				}
				//this.getSqlMapClient().queryForObject("createWInvoice1", genericMap); 
				//this.getSqlMapClient().queryForObject("createWInvoice", genericMap); //apollo cruz 03.30.2015 - used this function instead of the commented code above
				this.getSqlMapClient().executeBatch();
			}				
			
			// update par status
			log.info("Updating par status (gipis031UpdateParStatus) ...");
			genericMap.clear();
			genericMap.put("parId", gipiWPolbas.getParId());
			genericMap.put("polFlag", gipiWPolbas.getPolFlag());
			genericMap.put("endtTaxSw", pars.get("paramEndtTaxSw"));
			this.getSqlMapClient().queryForObject("gipis031UpdateParStatus", genericMap);
			System.out.println("dulo save :"+gipiWPolbas.getEffDate());
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
	}

	@Override
	public Map<String, Object> getBookingDateGIPIS002(Map<String, Object> params)
			throws SQLException {
		System.out.println("Retrieving gipis002 booking date: "+params);
		this.getSqlMapClient().queryForObject("gipis002GetBookingDate", params);
		System.out.println("Booking Dates retrieved: "+params);
		return params;
	}
	
	@Override
	public Map<String, Object> processEndtCancellationGipis165(
			Map<String, Object> params) throws SQLException {		
		log.info("DAO calling processEndtCancellation...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			log.info("Process Endt Cancellation Par ID: "+params.get("parId"));
			this.getSqlMapClient().update("processEndtCancellationGipis165", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
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
	
	private String extractSqlExceptionMessage2(SQLException e){
		String message = null;
		String cause = e.getCause().toString();
		String[] causeLines = cause.split("ORA");
		message = causeLines[1].substring(8, causeLines[1].length());		
		return message;
	}
	
	public String checkParPostedBinder(Integer parId) throws SQLException{
		log.info("checkParPostedBinder of parId : " + parId);
		return (String) this.sqlMapClient.queryForObject("checkParPostedBinder", parId);
	}

	@Override
	public String validatePolNo(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validatePolNo", params);
	}
	//added by robert GENQA SR 4828 08.26.15
	@Override
	public String getBondAutoPrem(Integer parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getBondAutoPrem", parId);
	}
	//end robert GENQA SR 4828 08.26.15
	
	//jmm SR-22834
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateAssdNoRiCd(Map<String, Object> params)
			throws SQLException, JSONException {
		System.out.println("paramDAo "+params);
		
		return (Map<String, Object>) this.sqlMapClient.queryForObject("validateAssdNoRiCd", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> validatePackAssdNoRiCd(Map<String, Object> params) throws SQLException, JSONException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("validatePackAssdNoRiCd", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIQuotePictures> getAttachmentList(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getAttachmentList3", params);
	}
	
	public void saveAttachments(List<GIPIWPicture> newAttachments) throws SQLException {
		for (GIPIWPicture attachment : newAttachments) {
			this.sqlMapClient.insert("saveAttachment", attachment);
		}
	}
}
