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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.dao.GIPIQuoteDAO;
import com.geniisys.gipi.entity.GIPIInspData;
import com.geniisys.gipi.entity.GIPIQuotation;
import com.geniisys.gipi.entity.GIPIQuote;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.util.FileUtil;

/**
 * The Class GIPIQuoteDAOImpl.
 */
public class GIPIQuoteDAOImpl implements GIPIQuoteDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIQuoteDAOImpl.class);

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

	// GIPIQuotation Listing
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getGIPIQuotationList(java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuote> getGIPIQuotationList(String userId, String lineCd) {
		List<GIPIQuote> list = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("lineCd", lineCd);
		try {
			list = getSqlMapClient().queryForList("getGIPIQuotationListing",param);
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return list;
	}

	// insert details for GIPI Quote
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#saveGIPIQuoteDetails(com.geniisys.gipi.entity.GIPIQuote)
	 */
	public void saveGIPIQuoteDetails(GIPIQuote gipiQuote) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
		
			BigDecimal alteredShortRate = gipiQuote.getShortRatePercent();
//	README: **********DO NOT ERASE*********************************************************		
//			 THE ADDITIONAL "1" SOLVES THE #E-9 INCONSISTENCY DURING IBATIS CONVERSION 
//			 it prevents ibatis from translating 0.000000000 to decimal notation (0E-9)
//			 ex:	------------ CASE 1 -----------------
//					-start--> 	value = 0.000000000   
//					-ibatis-> 	value = 0E-9   
//			      -sql----> 	ERROR
//					------------ CASE 2 -----------------
//			      -start--> 	value = 1.000000000	  
//					-ibatis->  	value = 1 			(did not convert to decimal notation)
//					-sql----> 	value = #1# -1 		(before executing SELECT)
//					-sql---->   value = 0 			(while executing SELECT)
//					-sql---->   SUCCESS

			alteredShortRate = alteredShortRate.add(new BigDecimal("1.0000")).setScale(9, BigDecimal.ROUND_HALF_UP);
			gipiQuote.setShortRatePercent(alteredShortRate);			
			//this.getSqlMapClient().insert("saveGIPIQuote", gipiQuote); replaced by: Nica 07.17.2012
			this.getSqlMapClient().insert("saveGIPIQuote2", gipiQuote); 
		
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(SQLException e){
			ExceptionHandler.logException(e);
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			ExceptionHandler.logException(e);
			this.sqlMapClient.getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
			System.out.println("Quotation has been successfully saved.");
		}
	
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getQuotationDetailsByQuoteId(int)
	 */
	public GIPIQuote getQuotationDetailsByQuoteId(int quoteId) throws SQLException {
		log.info("GETTING QUOTATION INFORMATION OF QUOTE ID: "+quoteId);
		return (GIPIQuote) getSqlMapClient().queryForObject("getQuotationDetailsByQuoteId", quoteId);
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#delete(com.seer.framework.util.Entity)
	 */
	@Override
	public void delete(GIPIQuote object){
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#findAll()
	 */
	@Override
	public List<GIPIQuote> findAll(){
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#findById(java.lang.Object)
	 */
	@Override
	public GIPIQuote findById(Object id){
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#save(com.seer.framework.util.Entity)
	 */
	@Override
	public void save(GIPIQuote object) {
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getQuoteIdByParams(com.geniisys.gipi.entity.GIPIQuote)
	 */
	@Override
	public GIPIQuote getQuoteIdByParams(GIPIQuote gipiQuote) throws SQLException {
		return (GIPIQuote) this.getSqlMapClient().queryForObject("getQuoteIdByParams", gipiQuote);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#deleteQuotation(int)
	 */
	@Override
	public void deleteQuotation(int quoteId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DELETING QUOTATION : "+quoteId);
			
			this.getSqlMapClient().delete("deleteQuotation", quoteId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
			
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#denyQuotation(int)
	 */
	@Override
	public void denyQuotation(int quoteId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DENYING QUOTATION : "+quoteId);
			this.getSqlMapClient().update("denyQuotation", quoteId);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}		
	}
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#copyQuotation(int)
	 */
	@Override
	public void copyQuotation(GIPIQuote quote) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("COPYING QUOTATION : "+quote.getQuoteId());
			
			this.getSqlMapClient().queryForObject("copyQuotation", quote);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#duplicateQuotation(int)
	 */
	@Override
	public void duplicateQuotation(GIPIQuote quote) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DUPLICATING QUOTATION : "+quote.getQuoteId());
			this.getSqlMapClient().queryForObject("duplicateQuotation", quote);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getQuoteIdSequence()
	 */
	@Override
	public GIPIQuote getQuoteIdSequence() throws SQLException {
		return (GIPIQuote) this.getSqlMapClient().queryForObject("getQuoteIdSequence");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getFilterQuoteListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getFilterQuoteListing(Map<String, Object> params)
			throws SQLException {

		log.info("GETTING QUOTATION LIST..");
		return this.getSqlMapClient().queryForList("getFilterQuoteListing", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getCopiedQuoteId(int)
	 */
	@Override
	public Integer getCopiedQuoteId(int quoteId) throws SQLException {
		return ((GIPIQuote) this.getSqlMapClient().queryForObject("getCopiedQuoteId", quoteId)).getQuoteId();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#reassignQuotation(java.util.Map)
	 */
	@Override
	public void reassignQuotation(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("reassignQuotation", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getQuoteListStatus(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotation> getQuoteListStatus(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getQuoteListStatus", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getQuoteListFromIssCd(java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotation> getQuoteListFromIssCd(String issCd, String lineCd, String userId, String keyWord)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("issCd", issCd);
		param.put("lineCd", lineCd);
		param.put("keyWord", keyWord);
		param.put("userId", userId);
		return this.getSqlMapClient().queryForList("getQuoteListFromIssCd", param);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#saveQuoteToParUpdates(java.util.Map)
	 */
	@Override
	public void saveQuoteToParUpdates(Map<String, Object> params)
			throws SQLException {
		log.info("Updating quote for PAR creation...");
		log.info("quoteId: "+	params.get("quoteId"));
		log.info("assdNo: "	+	params.get("assdNo"));
		log.info("lineCd: "	+	params.get("lineCd"));
		log.info("issCd: "	+	params.get("issCd"));
		
		this.getSqlMapClient().queryForObject("saveQuoteToParUpdates", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#updateStatus(java.util.Map)
	 */
	@Override
	public void updateStatus(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("updateStatus", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#updateQuotePremAmt(int, java.math.BigDecimal)
	 */
	@Override
	public void updateQuotePremAmt(int quoteId, BigDecimal premAmt)	throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", quoteId);
		param.put("premAmt", premAmt);
		this.getSqlMapClient().queryForObject("updateQuotePremAmt", param);
		
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getDistinctReasonCds()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getDistinctReasonCds() throws SQLException {
		return this.getSqlMapClient().queryForList("getReasonCds");
	}
	
	//updates the status of a quotation when returned from PAR
	/*
	 * 
	 */
	@Override
	public void updateStatusFromPar(int quoteId) throws SQLException {
		log.info("Setting NEW status for quote_id "+quoteId);
		this.getSqlMapClient().update("updateStatusReturnFromPAR", quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#updateReasonCd(java.util.Map)
	 */
	@Override
	public void updateReasonCd(Map<String, Object> params) throws SQLException {
		log.info("Updating reasonCd for quoteId - "+params.get("quoteId"));
		this.getSqlMapClient().update("updateReason", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getExistMessage(java.util.Map)
	 */
	@Override
	public String getExistMessage(Map<String, Object> params)
			throws SQLException {
		
		log.info("Validating assured name "+params.get("assdName")+" for lineCd "+params.get("lineCd")+"...");
		String result = (String) this.getSqlMapClient().queryForObject("getExistMessage", params);
		log.info("RESULT: "+result);
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDAO#getExistingQuotesPolsListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getExistingQuotesPolsListing(Map<String, Object> params)
			throws SQLException {
		log.info("Getting list of existing policies and quotations for assured name "+params.get("assdName"));
		return (List<GIPIQuote>) this.getSqlMapClient().queryForList("getExistingQuotesPolsListing", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkAssdName(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkAssdName", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getGIPIQuoteListing(
			HashMap<String, Object> params) throws SQLException, JSONException {
		List<GIPIQuote>  quoteListing = new ArrayList<GIPIQuote>();
		quoteListing = this.getSqlMapClient().queryForList("getGIPIQuoteListing2", params);		
		return quoteListing;
	}

	@Override
	public void reassignQuotation2(List<GIPIQuote> quoteList)
			throws SQLException {
		log.info("Reassigning quotation ...");
		
		try{			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> paramMap = null;

			//String remarksHolder = "";
			//int count = 1;
			for(GIPIQuote quote : quoteList){
				paramMap = new HashMap<String, Object>();
				/*if(count == 1){
					if(quote.getRemarks() != null){
						remarksHolder = quote.getRemarks();
					}
					count++;
				}*/ //marco - 09.20.2013 - removed block
				paramMap.put("userId", quote.getUserId());
				paramMap.put("quoteId", quote.getQuoteId());
				paramMap.put("remarks", quote.getRemarks());
								
				this.getSqlMapClient().update("reassignQuotation", paramMap);
			}
			//count = 1;
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();			
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{			
			this.getSqlMapClient().endTransaction();
		}
		
		log.info("Reassigning quotation done!");		
	}
	
	public void reassignPackageQuotation (List<GIPIQuote> quoteList) throws SQLException{
		log.info("Reassigning package quotation ...");
		
		try{			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> paramMap = null;

			//String remarksHolder = "";
			//int count = 1;
			for(GIPIQuote quote : quoteList){
				paramMap = new HashMap<String, Object>();
				/*if(count == 1){
					if(quote.getRemarks() != null){
						remarksHolder = quote.getRemarks();
					}
					count++;
				}*/ //marco - 09.20.2013 - removed block
				paramMap.put("userId", quote.getUserId());
				paramMap.put("quoteId", quote.getQuoteId());
				paramMap.put("remarks", quote.getRemarks());
				paramMap.put("packQuoteId", quote.getPackQuoteId());
								
				this.getSqlMapClient().update("reassignPackageQuotation", paramMap);
			}
			//count = 1;
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();			
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{			
			this.getSqlMapClient().endTransaction();
		}
		
		log.info("Reassigning package quotation done!");
	}

	@SuppressWarnings("unchecked")
	public List<GIPIQuote> getQuotationByPackQuoteId(Map<String, Object>params)
			throws SQLException {
		log.info("GETTING QUOTATIONS FOR PACK QUOTE ID: "+params.get("packQuoteId"));
		log.info("USER ID:"+params.get("userId"));
		return this.getSqlMapClient().queryForList("getQuotationByPackQuoteId", params);
	}

	public void savePackLineSubline(Map<String, Object> params)
			throws SQLException, JSONException{
		Integer packQuoteId = (Integer) params.get("packQuoteId");
		log.info("SAVING PACK LINE/SUBLINE QUOTATIONS FOR PACK QUOTE ID: "+packQuoteId);
		String parameter = (String) params.get("parameter");
		JSONObject objParameters = new JSONObject(parameter);
		//System.out.println(parameter);
		//System.out.println(objParameters);
		log.info("PREPARING QUOTATIONS FOR DELETE..");
		List<GIPIQuote> quotationsForDelete = this.preparePackQuotationsFordelete(new JSONArray(objParameters.getString("delRows")));
		log.info("PREPARING QUOTATIONS FOR INSERT..");
		List<GIPIQuote> quotationsForInsert = this.preparePackQuotationsForInsert(new JSONArray(objParameters.getString("addRows")));
		
		log.info("DELETING QUOTATIONs..");
		for (GIPIQuote gipiQuote : quotationsForDelete) {
			
			// get quotation item attachments
			List <GIPIQuotePictures> attachments = this.getAttachmentByQuote(gipiQuote.getQuoteId().toString());
			List<String> files = new ArrayList<String>();
			for (GIPIQuotePictures attachment : attachments) {
				files.add(attachment.getFileName());
			}
			
			log.info("DELETING QUOTE ID:"+gipiQuote.getQuoteId());
			this.deleteQuotation(gipiQuote.getQuoteId());
			
			// delete quotation item attachments
			FileUtil.deleteFiles(files);
		}
		
		log.info("INSERTING NEW PACK QUOTATIONS..");
		for (GIPIQuote gipiQuote : quotationsForInsert) {
			log.info("ISERTING NEW QUOTATION ID:"+gipiQuote.getQuoteId());
			System.out.println(gipiQuote.getQuotationNo());
			this.getSqlMapClient().insert("saveGIPIQuote", gipiQuote);
		}
		
		
	}
	
	private List<GIPIQuote> preparePackQuotationsFordelete(JSONArray delRows)throws SQLException, JSONException{
		List<GIPIQuote> packQuotationList = new ArrayList<GIPIQuote>();
		GIPIQuote packQuotation= null;
		
		for (int i = 0; i < delRows.length(); i++) {
			packQuotation = new GIPIQuote();
			//packQuotation.setPackQuoteId(delRows.getJSONObject(i).getInt("packQuoteId"));
			packQuotation.setQuoteId(delRows.getJSONObject(i).getInt("quoteId"));
			//packQuotation.setLineCd(delRows.getJSONObject(i).getString("lineCd"));
			//adds to list;
			packQuotationList.add(packQuotation);
		}
		return packQuotationList;
	}
	
	private List<GIPIQuote> preparePackQuotationsForInsert(JSONArray addRows)throws SQLException, JSONException{
		List<GIPIQuote> packQuotationList = new ArrayList<GIPIQuote>();
		GIPIQuote packQuotation= null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		for (int i = 0; i < addRows.length(); i++) {
			packQuotation = this.getQuoteIdSequence();//this sets the quote id
			log.info("generated quoteId:+"+packQuotation.getQuoteId());
			packQuotation.setPackQuoteId(Integer.parseInt(addRows.getJSONObject(i).getString("packQuoteId")));
			packQuotation.setLineCd(addRows.getJSONObject(i).getString("lineName"));
			packQuotation.setSublineCd(addRows.getJSONObject(i).getString("sublineName"));
			packQuotation.setIssCd(addRows.getJSONObject(i).getString("issName"));
			packQuotation.setCredBranch(addRows.getJSONObject(i).getString("credBranch"));
			packQuotation.setQuotationNo(addRows.getJSONObject(i).isNull("quotationNo") ? 0 : addRows.getJSONObject(i).getInt("quotationNo"));
			packQuotation.setQuotationYy(addRows.getJSONObject(i).getInt("quotationYy"));
			packQuotation.setProposalNo(addRows.getJSONObject(i).getInt("proposalNo"));
			packQuotation.setUserId(addRows.getJSONObject(i).getString("userId"));
			packQuotation.setAssdName(addRows.getJSONObject(i).isNull("assdName") ? "" : addRows.getJSONObject(i).getString("assdName"));
			packQuotation.setAssdNo(addRows.getJSONObject(i).isNull("assdNo") ? null : addRows.getJSONObject(i).getInt("assdNo"));
			packQuotation.setAddress1(addRows.getJSONObject(i).isNull("address1") ?"" : addRows.getJSONObject(i).getString("address1"));
			packQuotation.setAddress2(addRows.getJSONObject(i).isNull("address2") ? "" :addRows.getJSONObject(i).getString("address2"));
			packQuotation.setAddress3(addRows.getJSONObject(i).isNull("address3") ? "" :addRows.getJSONObject(i).getString("address3"));
			packQuotation.setAcctOfCd(addRows.getJSONObject(i).isNull("acctOfCd") ? null : addRows.getJSONObject(i).getInt("acctOfCd"));
			packQuotation.setStatus("");
			packQuotation.setUnderwriter(addRows.getJSONObject(i).getString("underwriter"));
			packQuotation.setInceptTag(addRows.getJSONObject(i).isNull("inceptTag") ? "N" : addRows.getJSONObject(i).getString("inceptTag"));
			packQuotation.setExpiryTag(addRows.getJSONObject(i).isNull("expiryTag") ? "N" : addRows.getJSONObject(i).getString("expiryTag"));
			packQuotation.setHeader(addRows.getJSONObject(i).isNull("header") ? "" : addRows.getJSONObject(i).getString("header"));
			packQuotation.setFooter(addRows.getJSONObject(i).isNull("footer") ? "" :addRows.getJSONObject(i).getString("footer"));
			packQuotation.setRemarks(addRows.getJSONObject(i).isNull("remarks") ? "" : addRows.getJSONObject(i).getString("remarks"));
			packQuotation.setReasonCd(addRows.getJSONObject(i).isNull("reasonCd") ? null : addRows.getJSONObject(i).getInt("reasonCd"));
			packQuotation.setCompSw(addRows.getJSONObject(i).getString("compSw"));
			packQuotation.setProrateFlag(addRows.getJSONObject(i).isNull("prorateFlag") ? null : addRows.getJSONObject(i).getString("prorateFlag"));
			packQuotation.setPackPolFlag("Y");
			packQuotation.setBankRefNo(addRows.getJSONObject(i).getString("bankRefNo"));
			
			BigDecimal shorts = new BigDecimal((addRows.getJSONObject(i).isNull("shortRatePercent") || addRows.getJSONObject(i).getString("shortRatePercent").equals("")) ? "0" : addRows.getJSONObject(i).getString("shortRatePercent"));
			
			// DO NOT REMOVE THE 1.0 ADDED HERE, IT WILL BE CANCELLED OUT IN THE ORACLE STATEMENT IN IBATIS
			shorts = shorts.add(new BigDecimal("1.000000000")).setScale(9, BigDecimal.ROUND_HALF_UP); 
			// ERRONEOUS DATA WILL BE ENTERED TO THE DATABASE IF THIS CODE IS DELETED 
			
//			README: **********DO NOT ERASE*********************************************************		
//			 THE ADDITIONAL "1" SOLVES THE #E-9 INCONSISTENCY DURING IBATIS CONVERSION 
//			 it prevents ibatis from translating 0.000000000 to decimal notation (0E-9)
//			 ex:	------------ CASE 1 -----------------
//					-start--> 	value = 0.000000000   
//					-ibatis-> 	value = 0E-9   
//			      -sql----> 	ERROR
//					------------ CASE 2 -----------------
//			      -start--> 	value = 1.000000000	  
//					-ibatis->  	value = 1 			(did not convert to decimal notation)
//					-sql----> 	value = #1# -1 		(before executing SELECT)
//					-sql---->   value = 0 			(while executing SELECT)
//					-sql---->   SUCCESS
			shorts.add(new BigDecimal("1.0000")).setScale(9, BigDecimal.ROUND_HALF_UP);
			packQuotation.setShortRatePercent(shorts);
			log.info("SHORT RATE PERCENT: " + packQuotation.getShortRatePercent());
			
			try {			
				packQuotation.setExpiryDate(sdf.parse(addRows.getJSONObject(i).getString("expiryDate")));
				packQuotation.setInceptDate(sdf.parse(addRows.getJSONObject(i).getString("inceptDate")));
			
				packQuotation.setValidDate((addRows.getJSONObject(i).getString("validDate")== null || addRows.getJSONObject(i).getString("validDate").equals("")) ? null : sdf.parse(addRows.getJSONObject(i).getString("validDate")));
				packQuotation.setAcceptDt((addRows.getJSONObject(i).getString("acceptDate")== null || addRows.getJSONObject(i).getString("acceptDate").equals("")) ? null : sdf.parse(addRows.getJSONObject(i).getString("acceptDate")));
			
			} catch (ParseException e1) {			
				e1.printStackTrace();
			}
			
			//adds to list;
			packQuotationList.add(packQuotation);
		}
		
		return packQuotationList;
	}

	@Override
	public String checkIfGIPIQuoteItemExsist(int quoteId) throws SQLException {
		log.info("CHECKING IF GIPI QUOTE ITEM EXIST: "+quoteId);
		Integer result = (Integer) this.getSqlMapClient().queryForObject("checkIfGIPIQuoteItemExsist",quoteId);
		String result1 ="N";
		if (result != null) {
			result1 = "Y";
		}
		log.info("RESULT: "+result1);
		return result1;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getGipiPackQuoteList(Integer packQuoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiPackQuoteList", packQuoteId);
	}

	@Override
	public void saveQuoteInspectionDetails(Map<String, Object> params)
			throws SQLException {
		try{			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("SAVING QUOTE INSPECTION DETAILS FOR QUOTE ID: "+params.get("quoteId"));
			this.getSqlMapClient().insert("saveQuoteInspectionDetails", params);
			
			this.getSqlMapClient().executeBatch();
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
	public Map<String, Object> generateQuoteBankRefNo(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("GENERATING BANK REF NO FOR QUOTE ID: "+params.get("quoteId"));
			
			this.getSqlMapClient().update("generateQuoteBankRefNo",params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getIncludedLinesOfPackQuote(Integer packQuoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getIncludedLinesOfPackQuote", packQuoteId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getPackQuoteListForCarrierInfo(Integer packQuoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPackQuoteListForCarrierInfo", packQuoteId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getPackQuoteListForENInfo(Integer packQuoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPackQuoteListForENInfo", packQuoteId);
	}
	
	
	
	/**
	 * @author rey
	 * @date 07-06-2011
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotation> getQuotationListStatus( 
			Map<String, Object> params) throws SQLException, JSONException {
		List<GIPIQuotation> quotationList=new ArrayList<GIPIQuotation>();
		//quotationList=this.getSqlMapClient().queryForList("getQuoteListStatusTableGrid", params); replaced by irwin 
		quotationList=this.getSqlMapClient().queryForList("getQuotationStatusList", params);
		
		return quotationList;
	}

	@Override
	public Integer copyQuotation2(Map<String, Object> params)
			throws SQLException, Exception {
		
		Integer newQuoteId;
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start Copying Quotation with quote_id="+params.get("quoteId"));
			
			this.getSqlMapClient().update("copyQuotation2", params);
			this.getSqlMapClient().executeBatch();
			newQuoteId = (Integer) params.get("newQuoteId");
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Successfully copied to quote_id="+params.get("newQuoteId"));
			
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
		}finally {
			this.getSqlMapClient().endTransaction();
			log.info("End Copying Quotation");
		}
		return newQuoteId;
	}

	@Override
	public Integer duplicateQuotation2(Map<String, Object> params)
			throws SQLException, Exception {
Integer newQuoteId;
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start Duplicating Quotation with quote_id="+params.get("quoteId"));
			
			this.getSqlMapClient().update("duplicateQuotation2", params);
			this.getSqlMapClient().executeBatch();
			newQuoteId = (Integer) params.get("newQuoteId");
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Successfully duplicated to quote_id="+params.get("newQuoteId"));
			
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
		}finally {
			this.getSqlMapClient().endTransaction();
			log.info("End Duplicating Quotation");
		}
		return newQuoteId;
	}

	@Override
	public com.geniisys.quote.entity.GIPIQuote getQuotationInfoByQuoteId(
			Integer quoteId) throws SQLException {
		log.info("GETTING QUOTATION INFORMATION OF QUOTE ID: "+quoteId);
		return (com.geniisys.quote.entity.GIPIQuote) this.getSqlMapClient().queryForObject("getQuotationInfoByQuoteId", quoteId);
	}

	@Override
	public Integer checkIfInspExists(Integer assdNo) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkIfInspExists", assdNo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuote> getReassignQuoteListing(Map<String, Object> params)
			throws SQLException {
		List<GIPIQuote>  quoteListing = new ArrayList<GIPIQuote>();
		quoteListing = this.getSqlMapClient().queryForList("getReassignQuoteListing", params);		
		return quoteListing;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveQuoteInspectionDetails2(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIInspData> inspDataList = this.getSqlMapClient().queryForList("getInspectionRep", params);
			String appUser = (String) params.get("appUser");
			for(GIPIInspData insp : inspDataList){
				Map<String, Object> inspParams = new HashMap<String, Object>();
				inspParams.put("quoteId", params.get("quoteId"));
				inspParams.put("appUser", appUser);
				inspParams.put("inspNo", insp.getInspNo());
				inspParams.put("itemNo", insp.getItemNo());
				
				String isItemExist = (String) this.getSqlMapClient().queryForObject("isExistQuoteItem", inspParams);
				if(!(isItemExist.equals("Y"))){
					this.getSqlMapClient().insert("saveQuoteInspectionDetails2", inspParams);
					this.getSqlMapClient().executeBatch();
				}				
			}
			message = "SUCCESS"; 
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public void deleteQuotation2(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DELETING QUOTATION : "+params.get("quoteId"));
			
			this.getSqlMapClient().delete("deleteQuotation2", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIQuotePictures> getAttachmentByQuote(String quoteId) throws SQLException {
		return this.getSqlMapClient().queryForList("getAttachmentByQuote", quoteId);
	}
	
	public void updateFileName2(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("updateFileName2", params);
	}
} 