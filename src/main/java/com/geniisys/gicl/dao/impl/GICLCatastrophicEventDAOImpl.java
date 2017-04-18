package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLCatastrophicEventDAO;
import com.geniisys.gicl.entity.GICLCatDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLCatastrophicEventDAOImpl implements GICLCatastrophicEventDAO {
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GICLCatastrophicEventDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> validateGicls057Line(Map<String, Object> params)
			throws SQLException {
		sqlMapClient.update("validateGicls057Line", params);
		return params;
	}

	@Override
	public Map<String, Object> validateGicls057Catastrophy(
			Map<String, Object> params) throws SQLException {
		sqlMapClient.update("validateGicls057Cat", params);
		return params;
	}

	@Override
	public Map<String, Object> validateGicls057Branch(Map<String, Object> params)
			throws SQLException {
		sqlMapClient.update("validateGicls057Branch", params);
		return params;
	}

	@Override
	public Map<String, Object> getUserParams(Map<String, Object> params) throws SQLException {
		log.info("Retrieving user params...");
		this.getSqlMapClient().update("getUserParamsForGicls200", params);
		log.info("Retrieving user params done.\nUser Params: " + params);
		return params;
	}

	@Override
	public Integer extractOsPdPerCat(Map<String, Object> params) throws SQLException {
		// Step 1
		log.info("Getting next value of session Id...");
		Integer nextSessionId = (Integer) this.getSqlMapClient().queryForObject("getOsPdPerCatSessionIdNextVal");
		log.info("Next session Id: "+ nextSessionId);
		
		// Step 2
		log.info("Deleting data from extract tables...");
		String appUser = (String) params.get("appUser");
		this.getSqlMapClient().update("deleteDataFromExtractOsPdPerCat", appUser);
		log.info("Deleting data from extract tables done.");
		
		// Step 3
		log.info("Resetting record id and extracting data...");
		params.put("sessionId", nextSessionId);
		System.out.println("params for rest and extract records: "+params);
		this.getSqlMapClient().update("resetAndExtractAllRecords", params);
		log.info("Resetting record id and extracting data done.");
		
		// Step 4
		System.out.println("params for extract distribution: "+params);
		log.info("Extracting distribution...");
		this.getSqlMapClient().update("extractDistribution", params);
		log.info("Extracting distribution done.");
		
		// Step 5
		log.info("Checking for extracted records...");
		System.out.println("params for checking the extracted records: "+params);
		Integer recordCount = (Integer) this.getSqlMapClient().queryForObject("checkForExtractedOsPdClmRec", params.get("sessionId"));
		log.info("Number of extracted records: "+recordCount);
		
		if(recordCount > 0 ){
			log.info("Extraction finished.");
		} else {
			log.info("No records have been extracted.");			
		}
		return recordCount;
	}

	@Override
	public Map<String, Object> valExtOsPdClmRecBefPrint(Map<String, Object> params) throws SQLException {
		log.info("Validating extracted records before printing...");
		this.getSqlMapClient().update("valExtOsPdClmRecBefPrint", params);
		System.out.println("returned params: "+params);
		log.info("Validation done.");
		return params;
	}

	@Override
	public void gicls056UpdateDetails(List<Map<String, Object>> list) throws SQLException, Exception {
		try {
			
			//List<String> recList = (List<String>) params.get("recList");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(int i = 0; i < list.size(); i++){
				Map<String, Object> map;
				map = (Map<String, Object>) list.get(i);
				
				System.out.println(map);
				
				this.getSqlMapClient().update("gicls056UpdateDetails", map);
				this.getSqlMapClient().executeBatch();
			}
			
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
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls056(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLCatDtl> delList = (List<GICLCatDtl>) params.get("delRows");
			for(GICLCatDtl d: delList){
				System.out.println("deleting : " + d.getCatCd());
				this.sqlMapClient.update("gilcs056DelRec", String.valueOf(d.getCatCd()));
			}
			this.sqlMapClient.executeBatch();
			
			System.out.println("saveGicls056 DAO");
			
			List<GICLCatDtl> setList = (List<GICLCatDtl>) params.get("setRows");
			for(GICLCatDtl s: setList){
				this.sqlMapClient.update("saveGicls056", s);
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
	public String gicls056ValDelete(String catCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("gicls056ValDelete", catCd);
	}

	@Override
	public void gicls056UpdateDetailsAll(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("gicls056UpdateDetailsAll", params);
			
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
	public void gicls056RemoveAll(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("gicls056RemoveAll", params);
			
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
	public void gicls056ValAddRec(Map<String, Object> params)
			throws SQLException {
		sqlMapClient.update("gicls056ValAddRec", params);
	}

	@Override
	public String gicls056GetClaimNos(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("gicls056GetClaimNos", params);
	}

	@Override
	public String gicls056GetClaimNosList(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("gicls056GetClaimNosList", params);
	}

	@Override
	public String gicls056GetClaimNosListFi(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("gicls056GetClaimNosListFi", params);
	}

	@Override
	public Map<String, Object> gicls056GetDspAmt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gicls056GetDspAmt", params);
		return params;
	}

}
