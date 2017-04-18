package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISUserIssCd;
import com.geniisys.common.entity.GIISUserLine;
import com.geniisys.common.entity.GIISUserModules;
import com.geniisys.common.entity.GIISUserTran;
import com.geniisys.giis.dao.GIISUserDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISUserDAOImpl implements GIISUserDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss040(Map<String, Object> params) throws Exception {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISUser> delList = (List<GIISUser>) params.get("delRows");
			for(GIISUser d: delList){
				//this.sqlMapClient.update("delUser", d.getUserId()); removed by jdiago 06.17.2014
				this.sqlMapClient.update("delUser", d.getMaintainUserId()); // added by jdiago 06.17.2014
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISUser> setList = (List<GIISUser>) params.get("setRows");
			for(GIISUser s: setList){
				this.sqlMapClient.update("setUser", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	@Override
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteUser", recId);
	}
	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddUser", recId);		
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss040Tran(Map<String, Object> params)
			throws Exception {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			String appUser = (String) params.get("appUser");
			List<GIISUserTran> delTranList = (List<GIISUserTran>) params.get("delTranRows");
			for(GIISUserTran d: delTranList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("gutUserId", params.get("gutUserId"));
				delParams.put("tranCd", d.getTranCd());
				System.out.println(delParams);
				this.sqlMapClient.delete("delGiiss040UserTran", delParams);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISUserTran> setList = (List<GIISUserTran>) params.get("setTranRows");
			for(GIISUserTran s: setList){
				s.setAppUser(appUser);
				this.sqlMapClient.update("setGiiss040UserTran", s);
			}
			
			List<GIISUserIssCd> delIssList = (List<GIISUserIssCd>) params.get("delIssRows");
			for(GIISUserIssCd d: delIssList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("gutUserId", params.get("gutUserId"));
				delParams.put("tranCd", d.getTranCd());
				delParams.put("issCd", d.getIssCd());
				System.out.println(delParams);
				this.sqlMapClient.delete("delGiiss040UserIss", delParams);
			}
			this.sqlMapClient.executeBatch();
			
			/*List<Map<String, Object>> setIssList = (List<Map<String, Object>>) params.get("setIssRows");
			for(Map<String, Object> s: setIssList){
				this.sqlMapClient.update("setGiiss040UserIss", s);
			}*/
			
			List<GIISUserIssCd> setIssList = (List<GIISUserIssCd>) params.get("setIssRows");
			for(GIISUserIssCd s: setIssList){
				s.setAppUser(appUser);
				this.sqlMapClient.update("setGiiss040UserIss", s);
			}
			
			List<GIISUserLine> delLineList = (List<GIISUserLine>) params.get("delLineRows");
			for(GIISUserLine d: delLineList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("gutUserId", params.get("gutUserId"));
				delParams.put("tranCd", d.getTranCd());
				delParams.put("issCd", d.getIssCd());
				delParams.put("lineCd", d.getLineCd());
				System.out.println(delParams);
				this.sqlMapClient.delete("delGiiss040UserLine", delParams);
			}
			this.sqlMapClient.executeBatch();
			
			/*List<Map<String, Object>> setLineList = (List<Map<String, Object>>) params.get("setLineRows");
			for(Map<String, Object> s: setLineList){
				this.sqlMapClient.update("setGiiss040UserLine", s);
			}*/
			
			List<GIISUserLine> setLineList = (List<GIISUserLine>) params.get("setLineRows");
			for(GIISUserLine s: setLineList){
				s.setAppUser(appUser);
				this.sqlMapClient.update("setGiiss040UserLine", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} catch(Exception e) {
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss040UserModules(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			String appUser = (String) params.get("appUser");
			//List<Map<String, Object>> setList = (List<Map<String, Object>>) params.get("setRows");
			List<GIISUserModules> setList = (List<GIISUserModules>) params.get("setRows");
			for(GIISUserModules s: setList){
				//s.put("appUser", appUser);
				s.setAppUser(appUser);
				this.sqlMapClient.update("setGiiss040UserModule", s);
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
	public void checkAllUserModule(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("checkAllUserModule", params);
			
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
	public void uncheckAllUserModule(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("uncheckAllUserModule", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISISSource> includeAllIssCodes() throws SQLException {
		List<GIISISSource> list = this.sqlMapClient.queryForList("includeAllIssCodes");
		return list;
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> includeAllLineCodes() throws SQLException {
		List<GIISLine> list = this.sqlMapClient.queryForList("includeAllLineCodes");
		return list;
	}
	@Override
	public Map<String, Object> whenNewFormInstance() throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		this.sqlMapClient.update("giiss040WhenNewFormInstance", params);
		
		return params;
	}
	@Override
	public void valDeleteRecTran1(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecTran1", params);
	}
	@Override
	public void valDeleteRecTran1Line(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valDeleteRecTran1Line", params);
	}
	@Override
	public GIISUser getUserDetails(String userId) throws SQLException {
		GIISUser user = (GIISUser) this.sqlMapClient.queryForObject("getUserDetails", userId);
		return user;
	}
}
