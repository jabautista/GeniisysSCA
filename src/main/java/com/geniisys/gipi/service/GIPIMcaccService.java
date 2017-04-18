package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface GIPIMcaccService {

	HashMap<String, Object> getVehicleAccessories (HashMap<String,Object> params) throws SQLException;
}
