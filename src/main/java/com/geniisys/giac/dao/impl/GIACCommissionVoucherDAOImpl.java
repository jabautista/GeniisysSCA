package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.giac.dao.GIACCommissionVoucherDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCommissionVoucherDAOImpl implements GIACCommissionVoucherDAO{
	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIACCommissionVoucherDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIACS155CommInvoiceDetails(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS155CommInvoiceDetails", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIACS155CommPayables(
			Map<String, Object> params) throws SQLException {
		
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS155CommPayables", params);
	}
	@Override
	public Map<String, Object> updateGIACS155CommVoucherExt(Map<String, Object> params)
			throws SQLException {
		try {
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");

			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String cvNo = (String) rows.get(0).get("cvNo");
			
			if(cvNo == null) {
				for(Map<String, Object> row : rows){
					row.put("userId", params.get("userId"));
					row.put("intmNo", params.get("intmNo"));
					row.put("fundCd", params.get("fundCd"));
					
					this.getSqlMapClient().update("updateGIACS155CommVoucherExt", row);
					this.getSqlMapClient().executeBatch();
					
					String overridingUser = (String) row.get("overridingUser");
					
					if(overridingUser != null && !overridingUser.isEmpty()){
						if(!overridingUser.equals(row.get("userId"))){
							System.out.println("inserting to overide history");
							this.getSqlMapClient().update("updateGIACS155overrideHist", row);
							this.getSqlMapClient().executeBatch();
						}
					}
				}
			} else {
				rows.get(0).put("userId", params.get("userId"));
				rows.get(0).put("intmNo", params.get("intmNo"));
				rows.get(0).put("fundCd", params.get("fundCd"));
				
				this.getSqlMapClient().update("updateGIACS155CommVoucherExt", rows.get(0));
				this.getSqlMapClient().executeBatch();
				
				for(Map<String, Object> row : rows){
					row.put("userId", params.get("userId"));
					row.put("intmNo", params.get("intmNo"));
					row.put("fundCd", params.get("fundCd"));
					
					String overridingUser = (String) row.get("overridingUser");
					
					if(overridingUser != null && !overridingUser.isEmpty()){
						if(!overridingUser.equals(row.get("userId"))){
							System.out.println("inserting to overide history");
							this.getSqlMapClient().update("updateGIACS155overrideHist", row);
						}
					}
				}
				
				this.getSqlMapClient().executeBatch();
			}
			
			//System.out.println("params before : " + params);
			
			this.getSqlMapClient().update("updateGIACS155checkTaggedRecords", params);
			this.getSqlMapClient().executeBatch();
			
			//System.out.println("params after : " + params);
			
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
			
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public String getGIACS155GrpIssCd(String userId, String repId)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGIACS155GrpIssCd", userId, repId);
	}
	@Override
	public void GIACS155SaveCVNo(Map<String, Object> params)
			throws SQLException {
		try {
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");

			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(Map<String, Object> row : rows){
				row.put("userId", params.get("userId"));
				row.put("intmNo", params.get("intmNo"));
				row.put("fundCd", params.get("fundCd"));
				row.put("cvPref", params.get("cvPref"));
				row.put("cvNo", params.get("cvNo"));
				row.put("cvDate", params.get("cvDate"));
				
				this.getSqlMapClient().update("GIACS155SaveCVNo", row);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public void GIACS155RemoveIncludeTag(String userId) throws SQLException {
		try {

			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("GIACS155RemoveIncludeTag", userId);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void populateBatchCV(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("populateBatchCV", params);
	}
	
	@Override
	public Map<String, Object> getCVSeqNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getCVSeqNo", params);
		return params;
	}
	
	@Override
	public void clearTempTable() throws SQLException {
		this.getSqlMapClient().update("clearTempTable");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGenerateFlag(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving Generate Flag...");
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			for(Map<String, Object> row : setRows){
				this.getSqlMapClient().update("saveCVGenerateFlag", row);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void generateCVNo(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("generateCVNo", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBatchReports() throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchCVReports");
	}
	
	@Override
	public void tagAll(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("tagAllCVRecords", params);
	}
	
	@Override
	public void untagAll() throws SQLException {
		this.getSqlMapClient().update("untagAllCVRecords");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> updateTags(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Updating tags...");
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			for(Map<String, Object> row : setRows){
				row.put("fundCd", params.get("fundCd"));
				row.put("userId", params.get("userId"));
				this.getSqlMapClient().update("updateCVTags", row);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("getCVSeqNo", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public String checkPolicyStatus(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getBatchCVStatus", params);
	}
	
	// AFP SR-18481 : shan 05.21.2015
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getGIACS251FundList() throws SQLException{
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getGIACS251FundList");
	}
	
	public BigDecimal getCommDueTotal(Map<String, Object> params) throws SQLException{
		return (BigDecimal) this.sqlMapClient.queryForObject("getCommDueTotal", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommDueListByParam(Map<String, Object> params) throws SQLException{
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getCommDueListByParam", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> generateCVNoCommDue(Map<String, Object> params) throws SQLException{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			Integer cvNo = Integer.parseInt(params.get("cvNo").toString());
			Integer maxCVNo = cvNo;
			for(Map<String, Object> row : setRows){
				row.put("cvPref", params.get("cvPref"));
				row.put("cvNo", cvNo);
				maxCVNo = cvNo;
				log.info("Generating CV No..." + row.toString());			
				this.getSqlMapClient().update("generateCVNoCommDue", row);
				cvNo += 1;
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();

			params.put("maxCVNo", maxCVNo);
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public void updateCommDueCVToNull(Map<String, Object> params) throws SQLException{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			for(Map<String, Object> row : rows){
				System.out.println("Updating comm due CV to null :: " + row.toString());			
				this.getSqlMapClient().update("updateCommDueCVToNull", row);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCommDueDtlTotals(Map<String, Object> params) throws SQLException{
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getCommDueDtlTotals", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> updateCommDueTags(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Updating tags...");
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			for(Map<String, Object> row : setRows){
				row.put("fundCd", params.get("fundCd"));
				row.put("userId", params.get("userId"));
				row.put("toRevert", params.get("toRevert"));
				System.out.println("Updating Comm Due Tags: " + row.toString());
				
				if (params.get("toRevert").equals("Y")){
					this.getSqlMapClient().update("updateCommDueCVToNull", row);
				}
				this.getSqlMapClient().update("updateCommDueTags", row);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("getCVSeqNo", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	public Integer getNullCommDueCount(String bankFileNo) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("getNullCommDueCount", bankFileNo);
	}
	// AFP SR-18481 : shan 05.21.2015
	
	// bonok :: 1.16.2017 :: RSIC SR 23713
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getTotalForPrintedCV(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getTotalForPrintedCV", params);
	}
}
