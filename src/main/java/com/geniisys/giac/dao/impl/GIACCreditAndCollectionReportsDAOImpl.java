package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACCreditAndCollectionReportsDAO;
import com.geniisys.giac.entity.GIACSoaRepExt;
import com.geniisys.giac.entity.GIACSoaRepExtParam;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCreditAndCollectionReportsDAOImpl implements GIACCreditAndCollectionReportsDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACCreditAndCollectionReportsDAOImpl.class);
	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIACSoaRepExtParam getDefualtSOAParams(Map<String, Object> params) throws SQLException, Exception {
		//Map<String, Object> params1 = new HashMap<String, Object>();
		//params1.putAll(params);
		GIACSoaRepExtParam params1 = new GIACSoaRepExtParam();
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Getting default SOA params...");
			params1 = (GIACSoaRepExtParam) this.getSqlMapClient().queryForObject("getDefaultSOAParams", params.get("userId"));		
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Getting default SOA params done.");
			this.getSqlMapClient().endTransaction();
		}
		return params1;
	}

	@Override
	public GIACSoaRepExtParam getExtractDate(Map<String, Object> params) throws SQLException, Exception {
		GIACSoaRepExtParam params1 = new GIACSoaRepExtParam();
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Getting extract dates...");
			params1 = (GIACSoaRepExtParam) this.getSqlMapClient().queryForObject("getExtractDate", params);		
			System.out.println("params returned: " + params1);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Getting extract dates done.");
			this.getSqlMapClient().endTransaction();
		}
		return params1;
	}

	//@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getSOARepDtls(Map<String, Object> params) throws SQLException, Exception {
		System.out.println("params passed: " + params);
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Extracting details...");
			this.getSqlMapClient().queryForObject("extractSOARepDtls", params);		
			System.out.println("params returned: " + params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Extracting details done.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String breakdownTaxPayments(Map<String, Object> params) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Initializing tax breakdown procedure...");
			this.getSqlMapClient().queryForObject("breakdownTaxes", params);		
			System.out.println("message returned: " + params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Tax extraction finished.");
			this.getSqlMapClient().endTransaction();
		}
		
		return (String) params.get("message");
	}

	@Override
	public GIACSoaRepExtParam setDefaultDates(Map<String, Object> params) throws SQLException {
		GIACSoaRepExtParam soaParams = new GIACSoaRepExtParam();
		
		log.info("Setting default dates...");
		soaParams = (GIACSoaRepExtParam) this.getSqlMapClient().queryForObject("setDefaultDates", params);
		log.info("Setting default dates done.");
		
		return soaParams;
	}

	@Override
	public String getSOARemarks() throws SQLException {
		log.info("Retrieving SOA Remarks...");
		return (String) this.getSqlMapClient().queryForObject("getSOARemarks");		
	}

	@Override
	//public String saveCollectionLetterParams(Map<String, Object> allParams) throws SQLException, Exception {
	public List<GIACSoaRepExt> saveCollectionLetterParams(Map<String, Object> allParams) throws SQLException, Exception {
		//String message = "SUCCESS";
		List<GIACSoaRepExt> letterToPrintList = new ArrayList<GIACSoaRepExt>();
		
		@SuppressWarnings("unchecked")
		List<GIACSoaRepExt> setRows = (List<GIACSoaRepExt>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DAO - Start of saving collection letter parameters...");
			
			for(GIACSoaRepExt set : setRows) {
				log.info("INSERTING: " + set.getIssCd() +" - "+set.getPremSeqNo()+" - "+set.getInstNo()+" - "+set.getBalanceAmtDue());
				Map<String, Object> ins = new HashMap<String, Object>();
				ins.put("issCd", set.getIssCd());
				ins.put("premSeqNo", set.getPremSeqNo());
				ins.put("instNo", set.getInstNo());
				ins.put("balanceAmtDue", set.getBalanceAmtDue());
				ins.put("collLetNo", null);
				ins.put("userId", set.getUserId());
				this.getSqlMapClient().insert("saveCollectionLetterParams", ins);		
				set.setCollLetNo((Integer) ins.get("collLetNo"));
				System.out.println("collLetNo returned: "+set.getCollLetNo());	
				letterToPrintList.add(set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of saving collection letter parameters.");
			this.getSqlMapClient().endTransaction();
		}
		
		return letterToPrintList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACSoaRepExt> selectAllRecords(Map<String, Object> params) throws SQLException {
		System.out.println("params: "+params);
		String action = (String) params.get("ACTION");
		return this.getSqlMapClient().queryForList(action, params);
	}

	@Override
	public String processIntmOrAssd(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("processIntmOrAssd", params);
	}

	@Override
	public List<GIACSoaRepExt> fetchParameters(Map<String, Object> allParams) throws SQLException {
		//return this.getSqlMapClient().queryForList("fetchReprintCollnLetParams", allParams);
		List<GIACSoaRepExt> letterToPrintList = new ArrayList<GIACSoaRepExt>();
		/*
		@SuppressWarnings("unchecked")
		List<GIACSoaRepExt> setRows = (List<GIACSoaRepExt>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DAO - Start of fetching collection letter parameters...");
			
			for(GIACSoaRepExt set : setRows) {
				log.info("INSERTING: " + set.getIssCd() +" - "+set.getPremSeqNo()+" - "+set.getInstNo()+" - "+set.getBalanceAmtDue());
				Map<String, Object> ins = new HashMap<String, Object>();
				ins.put("issCd", set.getIssCd());
				ins.put("premSeqNo", set.getPremSeqNo());
				ins.put("instNo", set.getInstNo());
				ins.put("userId", set.getUserId());
				this.getSqlMapClient().queryForList("fetchReprintCollnLetParams", ins);		
				set.setCollLetNo((Integer) ins.get("collLetNo"));
					
				letterToPrintList.add(set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of fetching collection letter parameters.");
			this.getSqlMapClient().endTransaction();
		}*/
		
		@SuppressWarnings("unchecked")
		List<GIACSoaRepExt> setRows = (List<GIACSoaRepExt>) allParams.get("setRows");
		for(GIACSoaRepExt set : setRows) {
			letterToPrintList.add(set);
		}
		
		return letterToPrintList;
	}

	@Override
	public String checkUserDate(String userId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkUserData", userId);
	}

	//added by kenneth L. for aging of collections 07.02.2013
	@Override
	public String extractAgingOfCollections(String userId) throws SQLException {
		String message = "Extracting Aging of Collections";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of extract aging collections...");
			this.getSqlMapClient().delete("extractAgingOfCollections", userId);
			this.getSqlMapClient().executeBatch();

			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	//added by kenneth L. for aging of collections 07.02.2013
	@Override
	public String inserToAgingExt(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("extracting aging of collections");
			this.getSqlMapClient().insert("inserToAgingExt", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("message");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String giacs329ValidateDateParams(Map<String, Object> params)
			throws SQLException {
		log.info("Validating As of date: "+params.get("asOfDate"));
		System.out.println(getSqlMapClient().queryForObject("giacs329ValidateDateParams",params));
		return (String) getSqlMapClient().queryForObject("giacs329ValidateDateParams",params);
	}

	@Override
	public Map<String, Object> extractGIACS329(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting records for GIACS329. Parameters:" + params.toString());
			this.getSqlMapClient().insert("extractGIACS329", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
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

	@Override
	public void checkExistingReport(String reportId) throws SQLException, Exception {
		try {
			
			log.info("Checking " +reportId+" in GIIS_REPORTS...");
			this.getSqlMapClient().queryForObject("checkExistingReport", reportId);
			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally{
			log.info("Checking " +reportId+ " in GIIS_REPORTS done.");
			this.getSqlMapClient().endTransaction();
		}		
	}

	//@SuppressWarnings("unchecked")
	@Override
	//public List<GIACSoaRepExt> processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception {
	public String processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception {
		//List<GIACSoaRepExt> processedList = new ArrayList<GIACSoaRepExt>();
		String label = params.get("viewType").equals("A") ? "assured" : "intermediary";
		String isExisting = "";
		
		try {
			log.info("Processing " + label +"...");
			//processedList = this.getSqlMapClient().queryForList("processIntmOrAssd2", params);
			isExisting = (String) this.getSqlMapClient().queryForObject("processIntmOrAssd2", params);
			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally{
			log.info("Processing "+label+" done.");
			this.getSqlMapClient().endTransaction();
		}	
		//return processedList;
		return isExisting;
	}

	@Override
	public String giacs480ValidateDateParams(Map<String, Object> params)
			throws SQLException {
		log.info("Validating As of date: "+params.get("asOfDate"));
		System.out.println(getSqlMapClient().queryForObject("giacs480ValidateDateParams",params));
		return (String) getSqlMapClient().queryForObject("giacs480ValidateDateParams",params);
	}

	@Override
	public Map<String, Object> extractGIACS480(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting records for GIACS480. Parameters:" + params.toString());
			this.getSqlMapClient().insert("extractGIACS480", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
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
	public Map<String, Object> whenNewFormInstanceGIACS329(GIISUser userId)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGIACS329", userId);
	}

	@Override
	public Map<String, Object> getLastExtractParam(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("getLastExtractParam", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstanceGIACS480(GIISUser userId)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGIACS480", userId);
	}

	public String checkUserChildRecords(Map<String, Object> params) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("checkUserChildRecords", params);
	}
	
	public Integer addToCollection(Map<String, Object> params) throws SQLException{		
		return (Integer) this.getSqlMapClient().queryForObject("addToCollection", params);
	}
	
	public String getCollElement(Integer index) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("getCollElement", index);
	}
	
	public void deleteCollElement(Integer index) throws SQLException{
		this.getSqlMapClient().update("deleteCollElement", index);
	}
}
