/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Feb 24, 2012
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;

import com.geniisys.gicl.dao.GICLClaimReserveDAO;
import com.geniisys.gicl.entity.GICLClaimReserve;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.entity.GICLClmResHist;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLClaimReserveDAOImpl implements GICLClaimReserveDAO {
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLClaimReserveDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimReserveDAO#getClaimReserveInitValues(java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getClaimReserveInitValues(Map<String, Object> pars)
			throws SQLException {
		log.info("getClaimReserveInitValues");
		Integer claimId = (Integer)pars.get("claimId");
		Integer itemNo = (Integer)pars.get("itemNo");
		
		Map<String, Object> params = new HashMap<String, Object>();
		log.info("get claim reserve init values:");
		boolean proceed = true;
		String message = "";
		String callModule = "";
		try{
			GICLClaimReserve claimReserve = null;
			try{
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("claimId", claimId);
				p.put("itemNo", itemNo);
				System.out.println("1111");
				log.info("CALLING getGICLClaimReserveGICLS024(claimId=" + claimId + ",itemNo=" + itemNo + ")");
				
				claimReserve = (GICLClaimReserve) sqlMapClient.queryForObject("getGICLClaimReserveGICLS024", p);
				
				if(claimReserve == null){
					claimReserve = new GICLClaimReserve();
				}
				
			}catch (SQLException e) {
				log.error("ERROR: " + e.getMessage());
				e.printStackTrace();
			}
			
			params.put("claimId", claimId);
			//**** WILL CAUSE ERROR WHEN claimReserve is null or more than 1 result
			params.put("itemNo", claimReserve.getItemNo());
			params.put("perilCd", claimReserve.getPerilCd());
			params.put("groupedItemNo", claimReserve.getGroupedItemNo());
			params.put("lineCdAc", new String(""));		params.put("lineCdCa", new String(""));		params.put("claimNumber", new String(""));
			params.put("policyNumber", new String(""));	params.put("lineCd", new String(""));		params.put("dspLossDate", new Date());		params.put("lossDate", new Date());
			params.put("assuredName", new String(""));	params.put("lossCategory", new String(""));	params.put("sublineCd", new String(""));	params.put("polIssCd", new String(""));
			params.put("issueYy", new Integer(0));		params.put("polSeqNo", new Integer(0));		params.put("renewNo", new Integer(0));		params.put("issCd", new String(""));
			params.put("polEffDate", new Date());		params.put("expiryDate", null);		params.put("clmFileDate", new Date());		params.put("clmStatDesc", new String(""));
			params.put("catastrophicCd", new Integer(0));	params.put("claimYy", new Integer(0)); params.put("exists", "N");
			params.put("showReserveHistory", "Y");
			params.put("showPaymentHistory", "Y");
			
			sqlMapClient.update("getClaimReserveInitValues1", params);
			GICLClaims c = GICLClaims.makeClaim(params);
			params.put("claimReserve", claimReserve);
			//c.displayDetailsInConsole();
			
			if(params.get("expiryDate")==null){
				Map<String, Object> subParam = new HashMap<String, Object>();
				subParam.put("lineCd", params.get("lineCd"));
				subParam.put("sublineCd", params.get("sublineCd"));
				subParam.put("issCd", params.get("issCd"));
				subParam.put("issueYy", params.get("issueYy"));
				subParam.put("polSeqNo", params.get("polSeqNo"));
				subParam.put("renewNo", params.get("renewNo"));
				subParam.put("lossDate", params.get("lossDate"));
				subParam.put("nbtExpiryDate", params.get("nbtExpiryDate"));
				sqlMapClient.update("extractExpiryGICLS02", subParam);
				if(subParam.get("nbtExpiryDate")!=null){
					params.put("expiryDate", subParam.get("nbtExpiryDate"));
				}
			}
			
			if(params.get("exists") != null){ // VALIDATE EXISTING DIST
				if(params.get("exists").toString().equals("Y")){
					log.info("do validate existing dist");
					Map<String, Object> subParam = new HashMap<String, Object>();
					subParam.put("lineCd", params.get("lineCd"));
					subParam.put("sublineCd", params.get("sublineCd"));
					subParam.put("issCd", params.get("issCd"));
					subParam.put("issueYy", params.get("issueYy"));
					subParam.put("polSeqNo", params.get("polSeqNo"));
					subParam.put("renewNo", params.get("renewNo"));
					subParam.put("proceed", new String(""));
					subParam.put("message", new String(""));
					subParam.put("callModule", new String(""));
					sqlMapClient.update("validateExistingDistGICLS024", subParam);
					if(subParam.get("proceed").toString().equalsIgnoreCase("N")){
						proceed = false;
						message = subParam.get("message") != null ? subParam.get("message").toString() : "";
						callModule = subParam.get("callModule") != null ? subParam.get("callModule").toString() : "";
						
						System.out.println("PROCEED: " + proceed);
						System.out.println("message: " + message);
						System.out.println("callModule: " + callModule);
					}else{
						System.out.println("proceed TRUE - " + subParam.get("proceed").toString());
					}
				}
			}
			
			if(c.getLossResAmount() == null || c.getLossResAmount().compareTo(new BigDecimal(0)) == 0){
				log.info("enable redist...");
				params.put("enableRedistributeBtn", false);
			}else{
				log.info("disable redist...");
				params.put("enableRedistributeBtn", true);
			}
			
			if(params.get("showReserveHistory").toString().equals("Y")){
				log.info("enableReserveHistory T");
				params.put("enableReserveHistory", true);
			}else{
				log.info("enableReserveHistory F");
				params.put("enableReserveHistory", false);
			}
			
			GICLClmResHist giclClmResHist = null;
			{	Map<String, Object> subPar = new HashMap<String, Object>();
				subPar.put("claimId", claimId);
				subPar.put("lineCd", params.get("lineCd"));
				
				@SuppressWarnings("unchecked")
				List<GICLClmResHist> resHistList = (List<GICLClmResHist>) sqlMapClient.queryForList("getGiclClmResHist", subPar);
				if(resHistList!=null){
					
					for(GICLClmResHist hi: resHistList){
						hi.displayValuesInConsole();
					}
					
					log.info("reslist size: " + resHistList.size());
					if(resHistList.size()!=0){
						giclClmResHist = resHistList.get(resHistList.size()-1); // GET LAST INDEX --- MAY NEED CHANGING
						if(giclClmResHist!=null){
							giclClmResHist.displayValuesInConsole();
						}else{
							
						}
					}
					params.put("giclClmResHist", giclClmResHist);
				}
			}
			params.put("claims", c);
		}catch (Exception e) {
			System.out.println("exception: " + e.getMessage());
			e.printStackTrace();
		}
		System.out.println("contd");
		return params;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimReserveDAO#getClaimReserve(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GICLClaimReserve getClaimReserve(Integer claimId, Integer itemNo, Integer perilCd)
			throws SQLException {
		log.info("get claim reserve: claimId=" + claimId + ", itemNo=" + itemNo);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", claimId);
		params.put("itemNo", itemNo);
		params.put("perilCd", perilCd);

		GICLClaimReserve reserve = (GICLClaimReserve)this.sqlMapClient.queryForObject("getGICLClaimReserveGICLS024", params);
		
		if(reserve == null){
			reserve = new GICLClaimReserve();
		}

		return reserve;
	}

	@Override
	public void getPreValidationParams(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getPreValidationParams", params);
	}

	@Override
	public void updateStatus(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("gicls024UpdateStatus", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAvailmentTotals(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getAvailmentTotals", params);
	}

	@Override
	public Map<String, Object> checkUWDist(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gicls024CheckUWDist", params);
		log.info("checkUWDist result: "+params);
		return params;
	}

	@Override
	public String redistributeReserve(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try{
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//added claim reserve saving and post forms commit - irwin
			GICLClaimReserve newReserve = new GICLClaimReserve((HashMap<String, Object>)params);
			this.getSqlMapClient().update("saveClaimReserve", newReserve);
			this.getSqlMapClient().executeBatch();
			
			log.info("redistribute Reserve DAO - "+params);
			
			log.info("creating new reserve...");
			this.getSqlMapClient().update("createNewReserve", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Updating claim dist tag...");
			this.getSqlMapClient().update("updateClaimDistTag", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Validating redistribution..."+params);
			this.getSqlMapClient().update("redistributeReserve", params);
			this.getSqlMapClient().executeBatch();
			
			// post_forms_commit
			getSqlMapClient().update("gicls024PostFormsCommit", params);
			getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("commitRedistribution result: "+params);
			message = (String) params.get("message");
			
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public Map<String, Object> checkLossRsrv(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkLossRsrv", params);
		return params;
	}

	@Override
	public String gicls024OverrideExpense(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gicls024OverrideExpense", params);
		log.info("gicls024OverrideExpense result: "+params);
		return (String) params.get("message");
	}

	@Override
	public void createOverrideRequest(Map<String, Object> params)
			throws SQLException {
		try{
			log.info("Creating override request for GICLS024...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("createOverrideRequestGICLS024", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimReserveDAO#saveClaimReserve(java.util.Map)
	 */
	@Override
	public String saveClaimReserve(Map<String, Object> params)
			throws SQLException {
		log.info("save claim reserve");
		String message = "Saving successful.";
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
		/*	this.sqlMapClient.update("createNewReserve", params);
			GICLClaimReserve newReserve = new GICLClaimReserve((HashMap<String, Object>)params);
			this.getSqlMapClient().update("saveClaimReserve", newReserve);*/
			//modified by irwin - 6.21.2012
			
			GICLClaimReserve newReserve = new GICLClaimReserve((HashMap<String, Object>)params);
			this.getSqlMapClient().update("saveClaimReserve", newReserve);
			this.getSqlMapClient().executeBatch();
			System.out.println("recordStatus==="+params.get("recordStatus"));  // ante test
			System.out.println("vRedistSw: "+params.get("vRedistSw"));
			if(params.get("vRedistSw").equals("Y")){ //Will insert new distribution or redistribute 
				log.info("creating new reserve...");
				this.getSqlMapClient().update("createNewReserve", params);
				this.getSqlMapClient().executeBatch();
				System.out.println("createNewReserve: "+params);
				
				log.info("Updating claim dist tag...");
				this.getSqlMapClient().update("updateClaimDistTag", params);
				this.getSqlMapClient().executeBatch();
				System.out.println("updateClaimDistTag: "+params);
				
				log.info("Validating redistribution..."+params);
				this.getSqlMapClient().update("redistributeReserve", params);
				this.getSqlMapClient().executeBatch();
				
				message = (String) params.get("message");
				log.info(message);
			}else{ // robert 9.6.2012  Will insert new distribution
				log.info("creating new reserve2...");
				this.getSqlMapClient().update("createNewReserve", params);
				this.getSqlMapClient().executeBatch();
				System.out.println("createNewReserve: "+params);
			}
			Map<String, Object> resHistParams = new HashMap<String, Object>();
			resHistParams.put("userId", params.get("userId"));
			resHistParams.put("claimId", params.get("claimId"));
			//resHistParams.put("clmResHistId", params.get("histSeqNo"));  // ante 9.24.2013
			resHistParams.put("histSeqNo", params.get("histSeqNo"));       // ante 9.24.2013
			resHistParams.put("bookingMonth", params.get("bookingMonth"));
			resHistParams.put("bookingYear", params.get("bookingYear"));
			resHistParams.put("remarks", params.get("remarks"));
			resHistParams.put("itemNo", params.get("itemNo"));    // ante 9.24.2013
			resHistParams.put("perilCd", params.get("perilCd"));  // ante 9.24.2013
			this.getSqlMapClient().update("updateResHistGICLS024", resHistParams);
			this.getSqlMapClient().executeBatch();
			
			// post_forms_commit
			getSqlMapClient().update("gicls024PostFormsCommit", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			//message = "SUCCESS";
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimReserveDAO#postFormsCommit(java.util.Map)
	 */
	@Override
	public void executeGICLS024PostFormsCommit(Map<String, Object> params) throws SQLException {
		log.info("executeGICLS024PostFormsCommit");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			this.sqlMapClient.update("gicls024PostFormsCommit", params);
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> gicls024ChckLossRsrv(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gicls024ChckLossRsrv", params);
		log.info("gicls024ChckLossRsrv result: "+params);
		return params;
	}

	@Override
	public String chckBkngDteExist(Integer claimId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("chckBkngDteExist", claimId);
	}

	@Override
	public String gicls024OverrideCount(Integer claimId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("gicls024OverrideCount", claimId);
	}

	@Override
	public String checkIfExistGiclClmReserve(Integer claimId)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkIfExistGiclClmReserve", claimId);
	}

	@Override
	public Map<String, Object> validateExistingDistGICLS024(
			Map<String, Object> params) throws SQLException {
		Integer claimId = Integer.parseInt((String) ("".equals(params.get("claimId")) || params.get("claimId") == null? "0" : params.get("claimId")));
		String isExist = this.checkIfExistGiclClmReserve(claimId);
		
		if(isExist.equals("N")){
			this.getSqlMapClient().update("validateExistingDistGICLS024", params);
		}
		
		return params;
	}
	
	@Override
	@SuppressWarnings({ "unchecked" })
	public HashMap<String, Object> redistributeReserveGICLS038(
			HashMap<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			List<Map<String, Object>> outRows = new ArrayList<Map<String, Object>>();
			
			for (Map<String, Object> list : rows){
				System.out.println("Redistribution Reserve List : " + list);
				String lossDate = (String) list.get("lossDate");
				String distDate = (String) params.get("dateToday");
				String clmFileDate = (String) list.get("clmFileDate");
				params.put("claimId", list.get("claimId"));
				params.put("lossDate", df.parse(lossDate));
				params.put("itemNo", list.get("itemNo"));
				params.put("perilCd", list.get("perilCd"));
				params.put("groupedItemNo", list.get("groupedItemNo"));
				params.put("lossReserve", list.get("lossReserve"));
				params.put("expenseReserve", list.get("expenseReserve"));
				params.put("currencyCd", list.get("currencyCd"));
				params.put("convertRate", list.get("convertRate"));
				params.put("distDate", df.parseObject(distDate));
				params.put("catastrophicCd", list.get("catastrophicCd"));
				params.put("clmFileDate", df.parseObject(clmFileDate));
				System.out.println("Redistribution Reserve Parameters : " + params);
				this.getSqlMapClient().update("redistributeReserveGICLS038", params);
				Map<String, Object> tempMap = new HashMap<String, Object>();
				tempMap.put("pMessage", params.get("pMessage"));
				outRows.add(tempMap);
			}
			
			params.put("rows", new JSONArray());
			for (Object o: outRows) {
				if (o instanceof Map && o != null) {
					params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(outRows)));
				}else{
					params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(outRows)));
				}
				break;
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	@Override
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> redistributeLossExpenseGICLS038(
			HashMap<String, Object> params) throws SQLException {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			List<Map<String, Object>> outRows = new ArrayList<Map<String, Object>>();
			
			for (Map<String, Object> list : rows){
				System.out.println("Redistribution Loss/Expense List : " + list);
				String lossDate = (String) list.get("lossDate");
				String effDate = (String) list.get("effDate");
				String expiryDate = (String) list.get("expiryDate");
				String distDate = (String) params.get("dateToday");
				params.put("claimId", list.get("claimId"));
				params.put("clmLossId", list.get("clmLossId"));
				params.put("distRg", list.get("distRg"));
				params.put("itemNo", list.get("itemNo"));
				params.put("perilCd", list.get("perilCd"));
				params.put("groupedItemNo", list.get("groupedItemNo"));
				params.put("lossDate", sdf.parse(lossDate));
				params.put("effDate", sdf.parse(effDate));
				params.put("expiryDate", sdf.parse(expiryDate));
				params.put("lineCd", list.get("lineCd"));
				params.put("sublineCd", list.get("sublineCd"));
				params.put("polIssCd", list.get("polIssCd"));
				params.put("issueYy", list.get("issueYy"));
				params.put("polSeqNo", list.get("polSeqNo"));
				params.put("renewNo", list.get("renewNo"));
				params.put("distDate", sdf.parse(distDate));
				params.put("payeeCd", list.get("payeeCd"));
				params.put("histSeqNo", list.get("histSeqNo"));
				params.put("payeeType", list.get("payeeType"));
				params.put("catastrophicCd", list.get("catastrophicCd"));
				
				System.out.println("Redistribution Loss/Expense Parameters : " + params);
				this.getSqlMapClient().update("redistributeLossExpenseGICLS038", params);
				Map<String, Object> tempMap = new HashMap<String, Object>();
				tempMap.put("pMessage", params.get("pMessage"));
				outRows.add(tempMap);
			}
			
			params.put("rows", new JSONArray());
			for (Object o: outRows) {
				if (o instanceof Map && o != null) {
					params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(outRows)));
				}else{
					params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(outRows)));
				}
				break;
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
		}catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return params ;
	}

	@Override
	public void createOverrideBasicInfo(Map<String, Object> params) throws SQLException {
		try{
			log.info("Creating override request for Basic Info...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("createOverrideRequestBasicInfo", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}	
	}
}