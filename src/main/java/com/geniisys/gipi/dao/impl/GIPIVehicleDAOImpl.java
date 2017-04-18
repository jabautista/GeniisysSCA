package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIVehicleDAO;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIVehicleDAOImpl implements GIPIVehicleDAO{

	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIPARListDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#getMotorCars(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIVehicle> getMotorCars(HashMap<String,Object> params) throws SQLException {
		return  this.getSqlMapClient().queryForList("getMotorCars",params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#getVehicleInfo(java.util.HashMap)
	 */
	@Override
	public GIPIVehicle getVehicleInfo(HashMap<String, Object> params) throws SQLException {
		return (GIPIVehicle) this.getSqlMapClient().queryForObject("getVehicleInfo",params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#getMotorCoCList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getMotorCoCList(
			HashMap<String, Object> params) throws SQLException {
		List<Map<String, Object>> params1 = this.getSqlMapClient().queryForList("getMotorCoc", params);
		return params1;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#updateVehiclesGIPIS091(java.util.List)
	 */
	@Override
	public void updateVehiclesGIPIS091(List<Map<String, Object>> vehicles) throws SQLException {
		try {
			//List<Map<String, Object>> vehicles = (List<Map<String, Object>>) params.get("setVehicles");
			Debug.print("update vehicles >> "+vehicles);
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating gipi_vehicle...");
			for(Map<String, Object> sv: vehicles) {
				this.getSqlMapClient().update("updateVehiclesGIPIS091", sv);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#checkExistingCOCSerial(java.util.Map)
	 */
	@Override
	public String checkExistingCOCSerial(Map<String, Object> params)
			throws SQLException {
		log.info("Checking if COC Serial No. is not unique...");
		Debug.print("checkExistingCOCSerial - "+params);
		return (String) this.getSqlMapClient().queryForObject("checkExistingCOCSerial", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#getPlateDtl(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPlateDtl(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPlateDtlLOV", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#getMotorDtl(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getMotorDtl(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getMotorDtlLOV", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIVehicleDAO#getSerialDtl(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getSerialDtl(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getSerialDtlLOV", params);
	}
	
	/**
	 * @author rey
	 * @date 08.18.2011
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIVehicle> getCarrierListDAO(HashMap<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getCarrierList",params);
	}

	@Override
	public GIPIVehicle getMotcarItemDtls(Map<String, Object> params)
			throws SQLException {
		return (GIPIVehicle) this.getSqlMapClient().queryForObject("getMotcarItemDtls",params);
	}

	@Override
	public Map<String, Object> validateGipis192Make(Map<String, Object> params)
			throws SQLException {
		sqlMapClient.update("validateGipis192Make", params);
		return params;
	}

	@Override
	public Map<String, Object> validateGipis192Company(
			Map<String, Object> params) throws SQLException {
		sqlMapClient.update("validateGipis192Company", params);
		return params;
	}
	
	public Map<String, Object> getGipis193VehicleItemTotals(Map<String, Object> params) throws SQLException{
		log.info("Getting GIPIS193 totals :" + params.toString());
		this.sqlMapClient.update("getGipis193VehicleItemTotals", params);
		
		return params;
	}
}
