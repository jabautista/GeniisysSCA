package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISGeninInfoDAO;
import com.geniisys.common.entity.GIISGeninInfo;
import com.geniisys.common.entity.GIISTakeupTerm;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIISGeninInfoDAOImpl implements GIISGeninInfoDAO{

	public SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolGenin> getInitInfoList(HashMap<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getInitialInfoList", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolGenin> getGenInfoList(HashMap<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getGeneralInfoList", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss180(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISGeninInfo> delList = (List<GIISGeninInfo>) params.get("delRows");
			for(GIISGeninInfo d: delList){
				this.sqlMapClient.update("delGeninInfo", d.getGeninInfoCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISGeninInfo> setList = (List<GIISGeninInfo>) params.get("setRows");
			for(GIISGeninInfo s: setList){
				System.out.println("==== " +s.getUserId());
				this.sqlMapClient.update("setGeninInfo", s);
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
	public void valDeleteRec(String geninInfoCd) throws SQLException {
		this.sqlMapClient.update("valDeleteGeninInfo", geninInfoCd);
	}

	@Override
	public void valAddRec(String geninInfoCd) throws SQLException {
		this.sqlMapClient.update("valAddGeninInfo", geninInfoCd);		
	}
	
	public String allowUpdateGiiss180(String geninInfoCd) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("allowUpdateGiiss180", geninInfoCd);
	}
}
