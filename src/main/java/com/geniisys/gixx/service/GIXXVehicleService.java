package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXVehicle;

public interface GIXXVehicleService {

	//public Map<String, Object> getGIXXCargoCarrierTG(Map<String, Object> params) throws SQLException;
	public GIXXVehicle getGIXXVehicleInfo(Map<String, Object> params) throws SQLException;
}
