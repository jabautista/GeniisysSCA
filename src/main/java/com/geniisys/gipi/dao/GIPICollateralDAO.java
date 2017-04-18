package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.gipi.entity.GIPICollateral;

public interface GIPICollateralDAO {
	
		List<GIPICollateral> getCollateralList(HashMap<String, Object> params) throws SQLException;
		List<GIISCollateralType> getCollType() throws SQLException;
		void delCollateralPar(Integer parId, Integer collId, String collVal, String recdate ) throws SQLException;
		void addCollateralPar(Integer parId, Integer collId, String collVal, String recDate) throws SQLException;
		void deleteCollateral(Integer parId, Integer rowNum) throws SQLException;
		void updateCollateralPar(Integer parId, Integer collId, String collVal, String recDate,
				Integer parId2, Integer collId2, String collVal2, String recDate2) throws SQLException;
}