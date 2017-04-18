package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.dao.GIRIGenerateRIReportsDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;
import common.Logger;

public class GIRIGenerateRIReportsDAOImpl implements GIRIGenerateRIReportsDAO{

	private Logger log = Logger.getLogger(GIRIGenerateRIReportsDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#getDefaultCurrency()
	 */
	@Override
	public int getDefaultCurrency() throws SQLException {
		log.info("GETTING DEFAULT CURRENCY...");
		int defaultCurr = (Integer) this.getSqlMapClient().queryForObject("getDefaultCurrencyGIRIS051");
		log.info("default currency is : " + defaultCurr);
		return defaultCurr;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#validateBndRnwl(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateBndRnwl(Map<String, Object> params) throws SQLException {
		log.info("Start validating bond renewal....");
		Debug.print("before: " + params);
		this.getSqlMapClient().queryForObject("validateBndRnwl", params);
		Debug.print("after: " + params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#checkRiReportsBinderRecords(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkRiReportsBinderRecord(Map<String, Object> params) throws SQLException {
		log.info("Start checking RI binder records...");
		Debug.print("before: " + params);
		this.getSqlMapClient().queryForObject("checkBinderRecords", params);
		Debug.print("after: " + params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#checkRiReportsBinderReplaced(java.util.Map)
	 */
	@Override
	public int checkRiReportsBinderReplaced(Map<String, Object> params) throws SQLException {
		log.info("Checking RI Binder Replaced...");
		return (Integer) this.getSqlMapClient().queryForObject("checkBinderReplaced", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#checkRiReportsBinderNegated(java.util.Map)
	 */
	@Override
	public int checkRiReportsBinderNegated(Map<String, Object> params) throws SQLException {
		log.info("Checking RI Binder Negated...");
		return (Integer) this.getSqlMapClient().queryForObject("checkBinderNegated", params);
	}

	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#updateGIRIBinder(java.util.Map)
	 */	 
	@Override
	public Map<String, Object> updateGIRIBinder(Map<String, Object> params) throws SQLException {
		log.info("Updating GIRI Binder...");
		log.info("params before: " + params);
		this.getSqlMapClient().update("updateGIRIBinder", params);
		log.info("params after: " + params);
		return params;		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#updateGIRIGroupBinder(java.util.Map)
	 */
	@Override
	public Map<String, Object> updateGIRIGroupBinder(Map<String, Object> params) throws SQLException {
		log.info("Updating GIRI Binder...");
		this.getSqlMapClient().update("updateGIRIGroupBinder", params);
		return params;	
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#insertBinderPerilPrintHist(java.util.Map)
	 */
	@Override
	public void insertBinderPerilPrintHist(Map<String, Object> params)throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> perils = (List<Map<String, Object>>) params.get("perils");
			for (Map<String, Object> p: perils){
				log.info("fnlBinderId: " + p.get("fnlBinderId") + " changeFlg: " + p.get("changeFlg"));
				if ("Y".equals(p.get("changeFlg"))){
					log.info("Adding Binder Peril Print History with fnlBinderID: " + p.get("fnlBinderId"));
					this.getSqlMapClient().insert("addBinderPerilPrintHist", p);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIGenerateRIReportsDAO#getGIRIR121FnlBinderId(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIRIR121FnlBinderId(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getGIRIR121FnlBinderId", params);
		return params;
	}

	@Override
	public Integer getReinsurerCd(String riName) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getReinsurerCd", riName);
	}

	@Override
	public String checkOARPrintDate(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkOARPrintDate", params);
	}

	@Override
	public void updateOARPrintDate(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("updateOARPrintDate", params);
	}

	@Override
	public Map<String, Object> validateRiSname(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateRiSname", params);
		return params;
	}

	@Override
	public void deleteGiixInwTran(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().delete("deleteGiixInwTran", params);
	}

	@Override
	public Integer getExtractInwTran(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("getExtractInwTran", params);
		System.out.println(params.toString());
		
		return (Integer) params.get("extractId");
	}

	@Override
	public String validateRiTypeDesc(String riTypeDesc) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateRiTypeDesc", riTypeDesc);
	}

	@Override
	public Integer getReciprocityRiCd(Map<String, Object> params) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getReciprocityRiCd", params);
	}

	@Override
	public Map<String, Object> extractReciprocity(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("extractReciprocity", params);
		return params;
	}
	
	@Override
	public Integer getExtractedReciprocity(Map<String, Object> params) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getExtractedReciprocity", params);
	}

	@Override
	public String updateAprem(Map<String, Object> params) throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateAprem", params);
			if (params.get("msg") == "" || params.get("msg") == null){
				message = "No Data Extracted.";
			}else{
				message = "Extraction Process Done.";
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Extraction Process Done." ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;			
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public void updateCprem(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateCprem", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> getReciprocityDetails1(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getReciprocityDetails1", params);
		return params;
	}

	@Override
	public Map<String, Object> getReciprocityDetails2(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getReciprocityDetails2", params);
		return params;
	}
	
	@Override
	public Map<String, Object> getReciprocityInitialValues(Map<String, Object> params) throws SQLException {
		log.info("getReciprocityInitialValues...");
		this.getSqlMapClient().update("getReciprocityInitialValues", params);
		return params;
	}
}
