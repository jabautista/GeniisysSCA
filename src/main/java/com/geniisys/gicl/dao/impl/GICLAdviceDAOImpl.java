/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 9, 2010
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.controllers.GICLAdviceController;
import com.geniisys.gicl.dao.GICLAdviceDAO;
import com.geniisys.gicl.entity.GICLAdvice;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLAdviceDAOImpl implements GICLAdviceDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLAdviceDAOImpl.class);	
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLAdviceDAO#getGICLAdvice(java.lang.Integer)
	 */
	@Override
	public GICLAdvice getGICLAdvice(Integer adviceId) throws SQLException{
		log.info("Retrieving GICLAdvice [adviceId="+ adviceId +"]");
		return (GICLAdvice)this.getSqlMapClient().queryForObject("getAdviceByAdviceId", adviceId);
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void gicls032NewFormInstance(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().update("gicls032NewFormInstance", params);
		} catch (SQLException e){
			ExceptionHandler.logException(e);
			throw e;			
		}
	}

	@Override
	public void gicls032EnableDisableButtons(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gicls032EnableDisableButtons", params);
	}
	
	public void gicls032CancelAdvice(Map<String, Object> params) throws SQLException{
		this.getSqlMapClient().update("gicls032CancelAdvice", params);
	}

	@Override
	public void gicls032GenerateAdvice(Map<String, Object> params)
			throws SQLException {
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			
			this.sqlMapClient.update("gicls032CheckSetResAmount", params);
			this.sqlMapClient.update("gicls032ValRange", params);
			this.sqlMapClient.update("gicls032GenerateAdviceProc", params);
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void gicls032GenerateAcc(Map<String, Object> params)
			throws SQLException {
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			GICLAdviceController.percentStatus = 0;
			GICLAdviceController.genAccMessage = "";
			GICLAdviceController.comment = "Please wait...";
			GICLAdviceController.file = "Request is going on.";	
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> recList = this.sqlMapClient.queryForList("getGenAccClmLossExp", params);						
			int segment = percentCounter(recList.size(), Double.parseDouble(params.get("progressBarLength").toString()));
			
			for(Map<String, Object> rec: recList){
				if(rec.get("payeeCd") != null && rec.get("payeeClassCd") != null){
					GICLAdviceController.file = "Adding records in PAYMENT_REQUEST.";
					this.sqlMapClient.update("gicls032InsertIntoGiacPaytRequests", params);
					
					GICLAdviceController.percentStatus += segment;
					GICLAdviceController.file = "Adding records in ACCTRANS.";
					this.sqlMapClient.update("gicls032InsertIntoAccTrans", params);
					System.out.println("REF ID :" + params.get("refId"));
					System.out.println("TRAN ID :" + params.get("tranId"));
					
					GICLAdviceController.percentStatus += segment;
					GICLAdviceController.file = "Adding records in PAYMENT_REQUEST_DETAILS.";
					params.put("payeeCd", rec.get("payeeCd"));
					params.put("payeeClassCd", rec.get("payeeClassCd"));
					params.put("payeeAmount", rec.get("payeeAmount"));
					this.sqlMapClient.update("gicls032InsertIntoGrqd", params);
					
					this.sqlMapClient.update("valClmLossExpTax", params);
					System.out.println("COUNT : " + params.get("count"));
					GICLAdviceController.percentStatus += segment;
					if(Integer.parseInt(params.get("count").toString()) > 0){
						this.sqlMapClient.update("gicls032InsertIntoTaxesWheld", params);
					}
					
					GICLAdviceController.percentStatus += segment;
					GICLAdviceController.file = "Adding records in DIRECT_CLAIM_PAYMENTS.";
					this.sqlMapClient.update("gicls032InsertIntoGdcp", params);
					
					GICLAdviceController.percentStatus += segment;
					GICLAdviceController.file = "Creating accounting entries.";
					this.sqlMapClient.update("gicls032ReverseTakeupHist", params);
					this.sqlMapClient.update("gicls032AegInsUpdtGiacAcctEntries", params);
				} else {
					GICLAdviceController.genAccMessage = "Payee not found in this record.";
					return;
				}
			}
			
			GICLAdviceController.percentStatus = 100;
			GICLAdviceController.comment = "Processing complete.";
			GICLAdviceController.file = "Claim Settlement Request completed.";			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			ExceptionHandler.logException(e);
			GICLAdviceController.genAccMessage = ExceptionHandler.extractSqlExceptionMessage(e);			
			this.sqlMapClient.getCurrentConnection().rollback();
			//throw e;		
		} finally {			
			this.sqlMapClient.endTransaction();
		}
	}	
	
	private int percentCounter(double recSize, double progressBarLength){		
		return (int) (((progressBarLength/(6*recSize))/progressBarLength)*100);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void gicls032SaveRemarks(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<Map<String, Object>> adviceList = (List<Map<String, Object>>) params.get("setRows");
			for(Map<String, Object> advice: adviceList){
				advice.put("appUser", params.get("appUser"));
				log.info("Updating remarks of advice: " + advice.get("adviceId"));
				advice.put("remarks", StringFormatter.unescapeHtmlJava((String) (advice.get("remarks").equals(null)?"":advice.get("remarks")))); //added by christian 04/15/2013
				this.sqlMapClient.update("gicls032UpdateAdviceRemarks", advice);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void gicls032CreateOverrideRequest(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			
			this.sqlMapClient.update("gicls032CreateOverrideRequest", params);
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void gicls032ApproveCsr(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);			
			System.out.println("params APPROVE: "+ params);
			this.sqlMapClient.update("gicls032ApproveCsr", params);
			
			if(params.get("overrideSw") != null && params.get("overrideSw").toString().equals("Y")){
				this.sqlMapClient.update("deleteWorkflowRec", params);
			}
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}		
	}

	@Override
	public Integer gicls032CheckRequestExist(Map<String, Object> params)
			throws SQLException {		
		return (Integer) this.sqlMapClient.queryForObject("gicls032CheckRequestExists", params);
	}
	
	@Override
	public String checkGeneratedFla(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGeneratedFla", params);
	}

	@Override
	public void gicls032CheckTsi(Map<String, Object> params)
			throws SQLException {			
		System.out.println("CHECK TSI PARAMS : " + params);
		this.sqlMapClient.update("gicls032CheckTsi", params);	
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGICLS260Advice(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGICLS260Advice", params);
	}
}