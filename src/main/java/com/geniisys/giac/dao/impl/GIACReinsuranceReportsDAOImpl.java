package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISDistShare;
import com.geniisys.giac.dao.GIACReinsuranceReportsDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACReinsuranceReportsDAOImpl implements GIACReinsuranceReportsDAO{
	
	private static Logger log = Logger.getLogger(GIACReinsuranceReportsDAO.class);
	
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	// -gzelle 06.19.2013
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getDates(String userId) throws SQLException {
		log.info("Getting from and to dates in giac_assumed_ri_ext");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs171Dates", userId);
	}

	// -gzelle 06.18.2013
	@Override
	public String extractToTable(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			log.info("Start of Extraction of records..");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting records for " + params);
			this.getSqlMapClient().insert("extractToTable", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("msg");
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
	public String giacs181ValidateBeforeExtract(Map<String, Object> params)
			throws SQLException {
		log.info("Validating from date: "+params.get("fromDate") + " and to date: " + params.get("toDate"));
		return (String) getSqlMapClient().queryForObject("giacs181ValidateBeforeExtract",params);
	}

	@Override
	public Map<String, Object> giacs181ExtractToTable(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting record on GIACS181. Parameters:" + params.toString());
			this.getSqlMapClient().insert("giacs181ExtractToTable", params);
			
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
	public String giacs182ValidateDateParams(Map<String, Object> params)
			throws SQLException {
		log.info("Validating from date: "+params.get("fromDate") + " and to date: " + params.get("toDate") + " and cut off date: " + params.get("cutOffDate"));
		System.out.println(getSqlMapClient().queryForObject("giacs182ValidateDateParams",params));
		return (String) getSqlMapClient().queryForObject("giacs182ValidateDateParams",params);
	}

	@Override
	public Map<String, Object> extractGIACS182(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting record for GIACS182. Parameters:" + params.toString());
			this.getSqlMapClient().insert("extractGIACS182", params);
			
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
	public String giacs183ValidateBeforeExtract(Map<String, Object> params)
			throws SQLException {
		log.info("Validating...");
		log.info("Parameters: " +params);
		return (String) getSqlMapClient().queryForObject("giacs183ValidateBeforeExtract",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> giacs183GetDate(String userId) throws SQLException {
		return (Map<String, Object>) getSqlMapClient().queryForObject("giacs183GetDate",userId);
	}

	@Override
	public Map<String, Object> giacs183ExtractToTable(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting record on GIACS183. Parameters:" + params);
			this.getSqlMapClient().insert("giacs183ExtractToTable", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("main_loop procedure on GIACS183. Parameters:" + params);
			this.getSqlMapClient().insert("giacs183MainLoop", params);
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
	
	/*GIACS136
	**Gzelle 07.01.2013*/	
	@Override
	public String validateIfExisting(Map<String, Object> params) throws SQLException {
		log.info("Validating extract parameters...");
		return (String) getSqlMapClient().queryForObject("validateIfExisting",params);
	}

	@Override
	public String validateBeforeExtract(Map<String, Object> params) throws SQLException {
		return (String) getSqlMapClient().queryForObject("validateBeforeInsert",params);
	}

	@Override
	public void deletePrevExtractedRecords(Map<String, Object> params) throws SQLException {
		try {
			log.info("Start of delete..");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting Previously extracted records for: " + params);
			this.getSqlMapClient().delete("deleteExtractedRecords",params);
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
	}

	@Override
	public String extractRecordsToTable(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			log.info("Start of extraction of records..");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting records for: " + params);
			System.out.println(params.get("quarter"));
			this.getSqlMapClient().insert("extractRecordsToTable",params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("msg");
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}	
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPrevParams(String userId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs136Params", userId);
	}

	@Override
	public Map <String, Object> extractGIACS296(Map<String, Object> params)throws SQLException {
		/*edited by MarkS optimization 1/31/2017*/
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Extracting GIACS296 records.... ");
			this.sqlMapClient.update("extractGIACS296", params);
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
		return params;
		
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getExtractDateGIACS296(String userId) throws SQLException{
		log.info("Fetching extract date for GIACS296 .... ");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getExtractDateGIACS296", userId);
	}
	
	public Integer getExtractCountGIACS296(String userId) throws SQLException{
		log.info("Fetching extract count for GIACS296 .... ");
		return (Integer) this.getSqlMapClient().queryForObject("getExtractCountGIACS296", userId);
	}

	@Override
	public Map<String, Object> getGIACS279InitialValues(Map<String, Object> params) throws SQLException {
		log.info("Fetching GIACS279 initial values...");
		this.sqlMapClient.update("getGIACS279InitialValues", params);
		return params;
	}
	/*--start Gzelle 09222015 SR18792--*/ 
	@Override	/*09232015*/ 
	public Map<String, Object> valExtractPrint(Map<String, Object> params) throws SQLException { 
		log.info("Validating parameters..."); 
		this.sqlMapClient.update("valExtractPrint", params); 
		return params; 
	} 
	/*--end Gzelle 09222015 SR18792--*/ 

	@Override
	public Map<String, Object> giacs279ExtractTable(Map<String, Object> params) throws SQLException {
		log.info("Extracting GIACS279...");
		this.sqlMapClient.update("giacs279ExtractTable", params);
		return params;
	}

	@Override
	public Map<String, Object> checkGIACS279Dates(String btn, String userId) throws SQLException {
		log.info("Getting GIACS279 dates...");		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("btn", btn);
		this.sqlMapClient.update("checkGIACS279Dates", params);
		
		return params ;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> checkGiacs274PrevExt(Map<String, Object> params) throws SQLException{
		log.info("Checking GIACS274 previously extracted data..");		 
		this.sqlMapClient.update("checkGiacs274PrevExt", params);
		return params;
	}
	
	public String validateGiacs274BranchCd(String branchCd) throws SQLException{
		log.info("Validating Branch Cd...");
		return (String) this.sqlMapClient.queryForObject("validateGIACS274BranchCd", branchCd);
	}
	
	public Map<String, Object> extractGiacs274(Map<String, Object> params) throws SQLException{
		log.info("Extracting records for GIACS274..." + params.toString());
		this.sqlMapClient.update("extractGiacs274", params);
		return params;
	}

	@Override
	public String extractSOAFaculRi(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting records: " + params);
			this.getSqlMapClient().delete("deleteSOAFaculRi",params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Extracting records: " + params);
			this.getSqlMapClient().insert("extractSOAFaculRi",params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("msg");
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

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getLastExtractSOAFaculRi(String userId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getLastExtractSOAFaculRi", userId);
	}
	
	//giacs276 added by john dolon 8.28.2013
	public Map<String, Object> extractGiacs276(Map<String, Object> params) throws SQLException{
		log.info("Extracting records for GIACS276...");
		System.out.println(params);
		this.sqlMapClient.update("extractGiacs276", params);
		return params;
	}
	@Override	/*start-Gzelle 09222015 SR18792*/ 
	public Map<String, Object> getGiacs276InitialValues(Map<String, Object> params) throws SQLException { 
		log.info("Fetching Giacs276 initial values..."); 
		this.sqlMapClient.update("getGiacs276InitialValues", params); 
		return params; 
	}			/*end-Gzelle 09222015 SR18792*/ 

	@Override
	public Map<String, Object> checkForPrevExtract(Map<String, Object> params) throws SQLException {
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Checking for previously extracted data (and extraction)...");
			this.getSqlMapClient().update("checkForGiacs220PrevExtract", params);
			this.getSqlMapClient().executeBatch();
			log.info("Checking for previously extracted data (and extraction) done.");
			System.out.println("updated params: "+params);
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	@Override
	public Map<String, Object> deleteAndExtract(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting previously extracted records...");
			this.getSqlMapClient().delete("deletePrevExtract", params);
			this.getSqlMapClient().executeBatch();
			log.info("Deleting previously extracted records done.");
			
			System.out.println("params after delete: "+params);
			log.info("Extracting records...");
			this.getSqlMapClient().update("pgExtractAll", params);
			this.getSqlMapClient().executeBatch();
			log.info("Extracting records done.");
			System.out.println("params after extract: "+params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	@Override
	public String computeTaggedRecords(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		@SuppressWarnings("unchecked")
		List<GIISDistShare> setRows = (List<GIISDistShare>) allParams.get("setRows");
		String userId = (String) allParams.get("userId");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Computing for ending balance...");
			
			for(GIISDistShare set : setRows) {
				System.out.println("Computing for: lineCd=" + set.getLineCd()+"\ttreatyYy=" + set.getTreatyYy()+"\tshareCd=" + set.getShareCd()+"\triCd=" + set.getRiCd() +"\tyear="+set.getYear()+"\tqtr=" +set.getQtr());
				set.setUserId(userId);
				this.getSqlMapClient().update("pgCompute", set);
			}
			log.info("Computing for ending balance done.");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
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
	public String postTaggedRecords(Map<String, Object> allParams) throws SQLException, Exception {
		String message = "SUCCESS";
		
		@SuppressWarnings("unchecked")
		List<GIISDistShare> setRows = (List<GIISDistShare>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Posting...");
			
			for(GIISDistShare set : setRows) {
				Map<String, Object> set1 = new HashMap<String, Object>();
				set1.put("lineCd", set.getLineCd());
				set1.put("treatyYy", set.getTreatyYy());
				set1.put("shareCd", set.getShareCd());
				set1.put("riCd", set.getRiCd());
				set1.put("year", set.getYear());
				set1.put("qtr", set.getQtr());
				this.getSqlMapClient().update("pgPost", set1);
				log.info("Posted: "+set1);
			}
			log.info("Posting done.");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
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
		
		return message;
	}

	@Override
	public Map<String, Object> checkBeforeView(Map<String, Object> params) throws SQLException {
		
		log.info("Checking for treaty quarter summary...");
		this.getSqlMapClient().update("checkBeforeView", params);
		log.info("Checking for treaty quarter summary done.");
		System.out.println("params returned: "+params);
		
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getTreatyQuarterSummary(Map<String, Object> params) throws SQLException {
		log.info("Getting Treaty Quarter Summary...");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs220TreatyQtrSummary", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getTreatyCashAcct(Map<String, Object> params) throws SQLException {
		log.info("Getting trreaty cash account information...");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs220TreatyCashAcct", params);		
	}

	@Override
	public String saveTreatyStatement(Map<String, Object> params)throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving treaty statement...");
			this.getSqlMapClient().update("saveGiacs220TreatyStatement", params);
			log.info("Saving treaty statement done.");
			
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

	@Override
	public String saveTreatyCashAcct(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving treaty cash account...");
			this.getSqlMapClient().update("saveGiacs220TreatyCashAcct", params);
			log.info("Saving treaty cash account done.");
			
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

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIACS182Variables(String userId)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS182Variables", userId);
	}

}
