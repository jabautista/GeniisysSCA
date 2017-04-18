package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISEventModule;
import com.geniisys.giis.dao.GIISEventModuleDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISEventModuleDAOImpl implements GIISEventModuleDAO{
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String getGiiss168SelectedModules(String eventCd)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGiiss168SelectedModules", eventCd);
	}

	@Override
	public void saveGiiss168(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss014");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			/*@SuppressWarnings("unchecked")
			List<GIISIndustry> delList = (List<GIISIndustry>) params.get("delRows");
			for(GIISIndustry d: delList){
				this.sqlMapClient.update("delIndustry", String.valueOf(d.getIndustryCd()));
			}
			this.sqlMapClient.executeBatch();*/
			
			@SuppressWarnings("unchecked")
			List<GIISEventModule> setList = (List<GIISEventModule>) params.get("setRowsEventModules");
			for(GIISEventModule s: setList){
				this.sqlMapClient.update("saveGiiss168EventModules", s);
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
	public String getGiiss168SelectedPassingUsers(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGiiss168SelectedPassingUsers", params);
	}

	@Override
	public String getGiiss168SelectedReceivingUsers(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGiiss168SelectedReceivingUsers", params);
	}

	@Override
	public void saveGiiss168UserList(Map<String, Object> params) throws SQLException, Exception {
		System.out.println("DAOI - saveGiiss168UserList");
		try {			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> delReceivingUserList = (List<Map<String, Object>>) params.get("delReceivingUserList");
			
			for(int x = 0; x < delReceivingUserList.size(); x++){
				System.out.println("delete receiving user " + x);
				System.out.println(delReceivingUserList.get(x));
				this.getSqlMapClient().update("deleteGiiss168ReceivingUsers", delReceivingUserList.get(x).get("eventUserMod"));
				this.getSqlMapClient().executeBatch();
			}			
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> passingUserList = (List<Map<String, Object>>) params.get("passingUserList");
			
			for(int x = 0; x < passingUserList.size(); x++){
				System.out.println("passing user " + x);
				System.out.println(passingUserList.get(x));
				this.getSqlMapClient().update("setGiiss168PassingUsers", passingUserList.get(x));
				this.getSqlMapClient().executeBatch();
				
				System.out.println("event user mod : ");
				System.out.println(passingUserList.get(x).get("eventUserMod"));
			}
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> receivingUserList = (List<Map<String, Object>>) params.get("receivingUserList");
			
			for(int x = 0; x < receivingUserList.size(); x++){
				System.out.println("receiving user " + x);
				System.out.println(receivingUserList.get(x));
				this.getSqlMapClient().update("setGiiss168ReceivingUsers", receivingUserList.get(x));
				this.getSqlMapClient().executeBatch();
				
				System.out.println("event user mod : ");
				System.out.println(receivingUserList.get(x).get("eventUserMod"));
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {			
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;			
		} catch (Exception e) {			
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;			
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void valDelGiiss168PassingUsers(Map<String, Object> params)
			throws SQLException {
		System.out.println("valDelGiiss168PassingUsers");
		System.out.println(params);
		this.sqlMapClient.update("valDelGiiss168PassingUsers", params);
	}

}
