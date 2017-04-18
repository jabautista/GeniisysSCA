package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIWCargoCarrier;

public interface GIPIWCargoCarrierDAO {

	List<GIPIWCargoCarrier> getGipiWCargoCarrier(Integer parId) throws SQLException;
}
