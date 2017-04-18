package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISReinsurerDAO;
import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.common.entity.GIISReinsurer;
import com.geniisys.fire.entity.GIISFireOccupancy;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISReinsurerDAOImpl implements GIISReinsurerDAO {
	
	/** The SQl Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log */
	private static Logger log = Logger.getLogger(GIISReinsurerDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISReinsurerDAO#getGiisReinsurerList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISReinsurer> getGiisReinsurerList(String keyword) throws SQLException {
		log.info("getGiisReinsurerList(keyword="+ keyword +")");
		return this.getSqlMapClient().queryForList("getGIISReinsurer", keyword);
	}

	@Override
	public String getInputVatRate(String riCd) throws SQLException {
		log.info("Getting vat rate for ricd - "+riCd);
		return (String) this.getSqlMapClient().queryForObject("getInputVatRateGIRIS002", riCd);
	}

	@Override
	public GIISReinsurer getGiisReinsurerByRiCd(Integer riCd)
			throws SQLException {
		return (GIISReinsurer) this.getSqlMapClient().queryForObject("getGIISReinsurerByRiCd", riCd);
	}

	@Override
	public String checkIfBinderExist(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkIfBinderExist",params);
	}

	@Override
	public String getReinsurerName(String riCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getReinsurerName", riCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CGRefCodes> getRIBaseList() throws SQLException {
		return this.sqlMapClient.queryForList("getRIBaseList");
	}

	@Override
	public Map<String, Object> validateGIISS030MobileNo(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("param", (String) params.get("param"));
		param.put("field", (String) params.get("field"));
		param.put("ctype", (String) params.get("ctype"));
		param.put("result", this.sqlMapClient.queryForObject("validateGIISS030MobileNo",param));
		return param;
	}
	
	@Override
	public Map<String, Object> getGIISS030MaxRiCd() throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("riCd", "1");	
		param.put("result", this.sqlMapClient.queryForObject("getGIISS030MaxRiCd",param));
		return param;
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddReinsurer", recId);		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss030(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
						
			List<GIISReinsurer> setList = (List<GIISReinsurer>) params.get("setRows");
			for(GIISReinsurer s: setList){
				this.sqlMapClient.update("setReinsurer", s);
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
}
