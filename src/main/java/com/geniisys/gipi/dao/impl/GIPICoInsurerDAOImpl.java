package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPICoInsurerDAO;
import com.geniisys.gipi.entity.GIPICoInsurer;
import com.geniisys.gipi.entity.GIPIMainCoIns;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GIPICoInsurerDAOImpl implements GIPICoInsurerDAO{
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPICoInsurerDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPICoInsurer> getCoInsurerDetails(int parId)
			throws SQLException {
		log.info("Getting list of co-insurers...");
		return this.getSqlMapClient().queryForList("getCoInsurers", parId);
	}

	@Override
	public GIPIMainCoIns getCoInsurerAmts(int parId) throws SQLException {
		log.info("Getting main co ins for parId - "+parId);
		return (GIPIMainCoIns) this.getSqlMapClient().queryForObject("getGIPIMainCoIns", parId);
	}

	@Override
	public Map<String, Object> getCoInsurerSharePct(Integer parId)
			throws SQLException {
		log.info("Getting co_insurer percentage share...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("saveRate", "");
		params.put("dspRate", "");
		Debug.print("Before params: " + params);
		this.getSqlMapClient().queryForObject("getCoInsSharePct", params);
		Debug.print("After params: " + params);
		return params;
	}

	@Override
	public Map<String, Object> getCoInsurerDefaultParams(Map<String, Object> params)
			throws SQLException {
		log.info("Getting GIPIS153 default values...");
		this.getSqlMapClient().queryForObject("getCoInsurerDefaults", params);
		Debug.print("Params obtained: " + params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPICoInsurer> getDefaultCoInsurers(int policyId)
			throws SQLException {
		log.info("Obtaining default co-insureres...");
		return this.getSqlMapClient().queryForList("getDefaultCoInsurers", policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveEnteredcoInsurer(Map<String, Object> params)
			throws SQLException {
		log.info("Saving entered co-insurers...");
		Map<String, Object> params2 = new HashMap<String, Object>();
		try {
			List<GIPICoInsurer> setCoRi			= (List<GIPICoInsurer>) params.get("setRows");
			List<Map<String, Object>> delCoRi	= (List<Map<String, Object>>) params.get("delRows");
			String userId					    = (String) params.get("userId");
			Integer parId						= (Integer) params.get("parId");
			BigDecimal premAmt					= (BigDecimal) params.get("premAmt");
			BigDecimal tsiAmt					= (BigDecimal) params.get("tsiAmt");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(params != null) {
				log.info("Saving record to gipi_main_co_ins...");
				Map<String, Object> mainCoInsMap = new HashMap<String, Object>();
				mainCoInsMap.put("parId", params.get("parId"));
				mainCoInsMap.put("premAmt", params.get("premAmt"));
				mainCoInsMap.put("tsiAmt", params.get("tsiAmt"));
				mainCoInsMap.put("userId", params.get("userId"));
				this.getSqlMapClient().insert("saveGipiMainCoIns", mainCoInsMap);
			}
			
			this.getSqlMapClient().executeBatch();
			
			if(delCoRi.size() > 0) {
				log.info("Deleting records from gipi_co_insurers...");
				for(Map<String, Object> del : delCoRi) {
					this.getSqlMapClient().delete("delGIPICoInsurers", del);
				}
			}
			this.getSqlMapClient().executeBatch();
			
			if(setCoRi.size() > 0) {
				log.info("Saving records to gipi_co_insurers...");
				for(GIPICoInsurer ci : setCoRi) {
					this.getSqlMapClient().update("saveGIPICoInsurers", ci);
				}
			}
			this.getSqlMapClient().executeBatch();
			
			//map for post forms commit
			params2.put("userId", userId);
			params2.put("parId", parId);
			params2.put("tsiAmt", tsiAmt);
			params2.put("premAmt", premAmt);
			System.out.println("postFormCommitGIPIS153: "+params2);
			this.getSqlMapClient().queryForObject("postFormCommitGIPIS153", params2);
			this.getSqlMapClient().executeBatch();
			
			System.out.println("populateInsurerOrigTab: "+params);
			this.getSqlMapClient().update("populateInsurerOrigTab", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params2;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPICoInsurer> getCoInsurers(HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getPolicyCoInsurers",params);
	}

	@Override
	public String checkCoInsurerAccess(Integer parId) throws SQLException {
		System.out.println("checkCoInsurerAccess - "+parId);
		return (String) this.getSqlMapClient().queryForObject("checkCoInsurerAccess", parId);
	}

	@Override
	public void processDefaultEndtCoIns(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("processDefaultInsurer", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("processDefaultLead", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	

}
