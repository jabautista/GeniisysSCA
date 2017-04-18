package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISClmStatDAO;
import com.geniisys.common.entity.GIISClmStat;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISClmStatDAOImpl implements GIISClmStatDAO{
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

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISClmStatDAO#getClmStatDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getClmStatDtls(Map<String, Object> params)
			throws SQLException {
		log.info("get Claim Stat Details");
		return this.getSqlMapClient().queryForList("getClmStatLOV", params);
	}

	@Override
	public String getClmStatDesc(String clmStatCd) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("getClmStatDesc", clmStatCd);
	}
	
	//Claim Status Maintenance
		@Override
		public JSONObject showClaimStatusMaintenance(HttpServletRequest request,
				Map<String, Object> params) throws SQLException, JSONException {
			Map<String, Object> claimStatusTableGrid = TableGridUtil
					.getTableGrid(request, params);
			JSONObject jsonClaimStatus = new JSONObject(claimStatusTableGrid);
			return jsonClaimStatus;
		}

		@SuppressWarnings("unchecked")
		@Override
		public Map<String, Object> saveClaimStatusMaintenance(
				Map<String, Object> params) throws SQLException {
			String message = "SUCCESS";
			List<GIISClmStat> setRows = (List<GIISClmStat>) params.get("setRows");
			List<GIISClmStat> delRows = (List<GIISClmStat>) params.get("delRows");
			try {
				this.getSqlMapClient().startTransaction();
				this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				this.getSqlMapClient().startBatch();
				for(GIISClmStat del : delRows){
					this.sqlMapClient.delete("deleteInClaimStatus", del);
				}
				for(GIISClmStat set : setRows){					
					this.getSqlMapClient().insert("setClaimStatus", set);
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

		@Override
		public Map<String, Object> chkIfValidInput(Map<String, Object> params)
				throws SQLException {
			HashMap<String, Object> param = new HashMap<String, Object>();	
			param.put("txtField", (String) params.get("txtField"));
			param.put("searchString", (String) params.get("searchString"));
			param.put("result", this.sqlMapClient.queryForObject("chkIfValidInput",param));
			return param;
		}

}
