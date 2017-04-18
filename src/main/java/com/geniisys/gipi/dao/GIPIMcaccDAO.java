package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIMcacc;

public interface GIPIMcaccDAO {
	
	List<GIPIMcacc> getVehicleAccessories(HashMap<String,Object> params) throws SQLException;

}
