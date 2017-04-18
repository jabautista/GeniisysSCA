package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIWVesAccumulation;

public interface GIPIWVesAccumulationDAO {
	List<GIPIWVesAccumulation> getGIPIWVesAccumulation(Integer parId) throws SQLException;
}
