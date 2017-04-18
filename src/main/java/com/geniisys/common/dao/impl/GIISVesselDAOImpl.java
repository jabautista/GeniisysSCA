package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISVesselDAO;
import com.geniisys.common.entity.GIISVessel;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIISVesselDAOImpl implements GIISVesselDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss049(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISVessel> delList = (List<GIISVessel>) params.get("delRows");
			for(GIISVessel d: delList){
				this.sqlMapClient.update("delAircraft", StringFormatter.unescapeHTML2(d.getVesselCd()));
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISVessel> setList = (List<GIISVessel>) params.get("setRows");
			for(GIISVessel s: setList){
				this.sqlMapClient.update("setAircraft", s);
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
	public String valDeleteRec(String vesselCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteAircraft", vesselCd);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddAircraft", recId);		
	}
	
	public Map<String, Object> validateAirTypeCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateAirTypeCd", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss050(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISVessel> delList = (List<GIISVessel>) params.get("delRows");
			for(GIISVessel d: delList){
				this.sqlMapClient.update("delInlandVehicle", d.getVesselCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISVessel> setList = (List<GIISVessel>) params.get("setRows");
			for(GIISVessel s: setList){
				this.sqlMapClient.update("setInlandVehicle", s);
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
	public void valDeleteRecGiiss050(String vesselCd) throws SQLException {
		this.sqlMapClient.update("valDeleteInlandVehicle", vesselCd);
	}

	@Override
	public void valAddRecGiiss050(String recId) throws SQLException {
		this.sqlMapClient.update("valAddInlandVehicle", recId);		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss039(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISVessel> delList = (List<GIISVessel>) params.get("delRows");
			for(GIISVessel d: delList){
				this.sqlMapClient.update("delVessel", d.getVesselCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISVessel> setList = (List<GIISVessel>) params.get("setRows");
			for(GIISVessel s: setList){
				this.sqlMapClient.update("setVessel", s);
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
	public void valDeleteRecGiiss039(String vesselCd) throws SQLException {
		this.sqlMapClient.update("valDeleteVessel", vesselCd);
	}

	@Override
	public void valAddRecGiiss039(String vesselCd) throws SQLException {
		this.sqlMapClient.update("valAddVessel", vesselCd);		
	}
}
