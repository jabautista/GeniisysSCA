package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.giac.dao.GIACApdcPaytDtlDAO;
import com.geniisys.giac.entity.GIACApdcPaytDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACApdcPaytDtlDAOImpl implements GIACApdcPaytDtlDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACApdcPaytDtlDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACApdcPaytDtl> getApdcPaytDtlTableGrid(
			Map<String, Object> params) throws SQLException {
		log.info("getApdcPaytDtlTableGrid");
		return this.sqlMapClient.queryForList("getApdcPaytDtlTableGrid", params);
	}
	
	public Map<String, Object> gpdcPremPostQuery(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.queryForObject("gpdcPremPostQuery", params);
		return params;
	}
	
	public String checkGeneratedOR(Integer apdcId) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("checkGeneratedOR", apdcId);
	}
	
	public Integer generatePdcId() throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("generatePdcId");
	}
	@Override
	public Integer getApdcSw(Integer tranId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getApdcSw", tranId);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs091(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACApdcPaytDtl> setList = (List<GIACApdcPaytDtl>) params.get("setRows");
			for(GIACApdcPaytDtl s: setList){
				this.sqlMapClient.update("setDatedChecks", s);
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
	
	public void saveOrParticulars(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("setOrParticulars", params);
			
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
	public Map<String, Object> multipleOR(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs091MultipleOR", params);
		return params;
	}
	
	public Map<String, Object> groupOr(Map<String, Object> params) throws SQLException, JSONException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			JSONArray setList = (JSONArray) params.get("group");
			Map<String, Object> groupOrParams = params;
			groupOrParams.put("pdcId", setList.get(0));
			groupOrParams.put("tranId", "");
			this.sqlMapClient.update("giacs091GroupOr", groupOrParams);
			
			for (int i = 0; i < setList.length(); i++) {
				groupOrParams.put("pdcId", setList.get(i));
				groupOrParams.put("itemNo", i);
				this.sqlMapClient.update("giacs091ProcessGroupOr", groupOrParams);
			}
			
			groupOrParams.put("pdcId", setList.get(0));
			this.sqlMapClient.update("giacs091GroupOrFinal", groupOrParams);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			return groupOrParams;
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> validateDcbNo(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs091GetDcbNo", params);
		return params;
	}
	
	public void createDbcNo(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs091CreateDcbNo", params);
	}
	
	@Override
	public Map<String, Object> giacs091DefaultBank(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs091DefaultBank", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map <String, Object>> getGiacs091Funds(String userId) throws SQLException {
		return (List<Map <String, Object>>) this.sqlMapClient.queryForList("getGiacs091Funds", userId);
	}
	@Override
	public String giacs091ValidateTransactionDate(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs091ValidateTransactionDate", params);
	}
	/*added by MarkS 12.13.2016 SR5881*/
	@Override
	public String giacs091CheckSOABalance(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs091CheckSOABalance", params);
	}
}
