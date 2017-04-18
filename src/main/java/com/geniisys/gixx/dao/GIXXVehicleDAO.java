package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXVehicle;

public interface GIXXVehicleDAO {
	
	//public List<GIXXVehicle> getGIXXCargoCarrierTG (Map<String, Object> params) throws SQLException;
	public GIXXVehicle getGIXXVehicleInfo(Map<String, Object> params) throws SQLException;

}
