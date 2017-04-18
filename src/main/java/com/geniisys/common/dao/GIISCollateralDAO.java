package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.common.entity.GIISCollateral;
import com.geniisys.common.entity.GIISCollateralType;

public interface GIISCollateralDAO {
	List<GIISCollateral> getCollateralList(HashMap<String, Object> params) throws SQLException;
	List<GIISCollateralType> getCollType() throws SQLException;
	void delCollateralPar(Integer parId, Integer collId, Integer collVal, String recdate ) throws SQLException;
	void addCollateralPar(Integer parId, Integer collId, Integer collVal, String recDate) throws SQLException;
}
