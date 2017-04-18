package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISPerilClauses;
import com.geniisys.common.entity.GIISPerilTariff;
import com.geniisys.giis.dao.GIISPerilMaintenanceDAO;
import com.geniisys.giis.entity.GIISPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPerilMaintenanceDAOImpl implements GIISPerilMaintenanceDAO {
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String savePeril(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		List<GIISPeril> setRows = (List<GIISPeril>) allParams.get("setRows");
		List<GIISPeril> delRows = (List<GIISPeril>) allParams.get("delRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIISPeril del : delRows){
				this.sqlMapClient.delete("deleteInPerilMaintenance", del);
			}
			for(GIISPeril set : setRows){	
				set.setStrRiCommRt(set.getRiCommRt().toPlainString()); //added by robert 01.03.2014
				this.sqlMapClient.insert("setPerilMaintenance", set);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validateDeletePeril(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("validateDeletePeril2", param);
	}

	@Override
	public String perilIsExist(Map<String, Object> param) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateAddPeril", param);
	}
	
	@Override
	public String validatePerilSname(Map<String, Object> param) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validatePerilSname", param);
	}

	@Override
	public String validatePerilName(Map<String, Object> param) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validatePerilName", param);
	}
	
	//For Tariff
	@SuppressWarnings("unchecked")
	public String saveTariff(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		List<GIISPerilTariff> setRows = (List<GIISPerilTariff>) allParams.get("setRows");
		List<GIISPerilTariff> delRows = (List<GIISPerilTariff>) allParams.get("delRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIISPerilTariff del : delRows){
				this.sqlMapClient.delete("deleteTariff", del);
			}
			for(GIISPerilTariff set : setRows){
				this.sqlMapClient.delete("setTariff", set);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@Override
	public String validateDeleteTariff(Map<String, Object> param) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateDeleteTariff", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveWarrCla(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		List<GIISPerilClauses> setRows = (List<GIISPerilClauses>) allParams.get("setRows");
		List<GIISPerilClauses> delRows = (List<GIISPerilClauses>) allParams.get("delRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIISPerilClauses del : delRows){
				this.sqlMapClient.delete("deleteWarrCla", del);
			}
			for(GIISPerilClauses set : setRows){
				this.sqlMapClient.delete("setWarrCla", set);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validateDefaultTsi(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("validateDefaultTsi", param);
	}

	@Override
	public String getSublineCdName(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("getSublineCdName", param);
	}

	@Override
	public String getBasicPerilCdName(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("getBasicPerilCdName", param);
	}

	@Override
	public String getZoneNameFiName(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("getZoneNameFiName", param);
	}

	@Override
	public String getZoneNameMcName(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("getZoneNameMcName", param);
	}

	@Override
	public String checkAvailableWarrcla(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("checkAvailableWarrcla", param);
	}

	@Override
	public String validateSublineName(Map<String, Object> param)
			throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("validateSublineName", param);
	}

	@Override
	public String validateFiList(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("validateFiList", param);
	}

	@Override
	public String validateMcList(Map<String, Object> param) throws SQLException {
		return  (String) this.sqlMapClient.queryForObject("validateMcList", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllGIISPerilGIISS003(String lineCd)
			throws SQLException {		
		return this.sqlMapClient.queryForList("getAllGIISPerilGIISS003", lineCd);
	}
}
