package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.impl.GIISClmStatDAOImpl;
import com.geniisys.common.entity.GIISClmStat;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLReasonsDAO;
import com.geniisys.gicl.entity.GICLReasons;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLReasonsDAOImpl implements GICLReasonsDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISClmStatDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
		
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public JSONObject showClmStatReasonsMaintenance(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> clmStatReasonsTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonClmStatReasons = new JSONObject(clmStatReasonsTableGrid);
		return jsonClmStatReasons;
	}

	@Override
	public Map<String, Object> validateReasonsInput(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("txtField", (String) params.get("txtField"));
		param.put("inputString", (String) params.get("inputString"));
		param.put("reasonCd", (String) params.get("reasonCd"));
		param.put("clmStatCd", (String) params.get("clmStatCd"));
		param.put("result", this.sqlMapClient.queryForObject("validateReasonsInput",param));
		return param;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmStatReasonsMaintenance(
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		List<GICLReasons> setRows = (List<GICLReasons>) params.get("setRows");
		List<GICLReasons> delRows = (List<GICLReasons>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GICLReasons del : delRows){
				this.sqlMapClient.delete("deleteInClmStatReasons", del);
			}
			for(GICLReasons set : setRows){					
				this.getSqlMapClient().insert("setClmStatReasons", set);
			}				
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);		
		return params;
	}
}
