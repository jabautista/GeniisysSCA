package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIBondBasic;


public interface GIPIBondBasicDAO {

	List<GIPIBondBasic> getBondPolicyData(Map<String, Object> params) throws SQLException;

}
