package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIRiskLossProfileDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIRiskLossProfileDAOImpl implements GIPIRiskLossProfileDAO{

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	private Map<String, Object> convertJSONObjectToMap (JSONObject rec) throws JSONException {
		Map<String, Object> m = new HashMap<String, Object>();
		Iterator<String> keys = rec.keys();
		//System.out.println("**********");
		while(keys.hasNext()){
			String key = keys.next();
			String val = rec.getString(key).equals("null") ? "" : rec.getString(key);				
			//System.out.println(key + " : " + val);
			m.put(key, val);
		}
		
		return m;
	}

	@Override
	public void saveGIPIS902(Map<String, Object> params) throws SQLException,
			JSONException {
		JSONArray setParamRows = (JSONArray) params.get("setParamRows");
		JSONArray delParamRows = (JSONArray) params.get("delParamRows");
		JSONArray setRangeRows = (JSONArray) params.get("setRangeRows");
		JSONArray delRangeRows = (JSONArray) params.get("delRangeRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();				
			
			if(params.get("type").equals("update")){
				if(delParamRows.length() > 0){
					Map <String, Object> m = convertJSONObjectToMap(delParamRows.getJSONObject(0));
					m.put("type", "UPDATE");
					m.put("userId", params.get("userId"));					
					this.getSqlMapClient().update("deleteGIPIS902", m);
				}
				
				if(setParamRows.length() > 0)
					this.getSqlMapClient().update("updateGIPIS902", convertJSONObjectToMap(setParamRows.getJSONObject(0)));
				
				this.getSqlMapClient().executeBatch();
			} else {
				Map<String, Object> deleteMap = new HashMap<String, Object>();
				deleteMap.put("lineCd", setParamRows.getJSONObject(0).getString("lineCd"));
				deleteMap.put("sublineCd", setParamRows.getJSONObject(0).getString("sublineCd"));
				deleteMap.put("allLineTag", setParamRows.getJSONObject(0).getString("allLineTag"));
				deleteMap.put("userId", params.get("userId"));
				this.getSqlMapClient().update("deleteGIPIS902", deleteMap);
				this.getSqlMapClient().executeBatch();
				
				for(int i = 0; i < setRangeRows.length(); i++){
					JSONObject rec = setRangeRows.getJSONObject(i);
					System.out.println(i + " - " + convertJSONObjectToMap(rec));
					this.getSqlMapClient().update("saveGIPIS902", convertJSONObjectToMap(rec));
					this.getSqlMapClient().executeBatch();
				}
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public void extractGIPIS902(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(params.get("allLineTag").equals("R")){
				this.getSqlMapClient().update("gipis902ExtractRiskProfileItem", params);
				this.getSqlMapClient().executeBatch();
			} else {
				this.getSqlMapClient().update("gipis902ExtractRiskProfile", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().update("gipis902LossProfileExtractLossAmt", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
}
