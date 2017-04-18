package com.geniisys.giuw.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giuw.entity.GIUWWPerilds;

public interface GIUWWPerildsDAO {
	
	List<GIUWWPerilds> getGiuwWperildsForDistFinal (Map<String, Object> params)throws SQLException;

	/**
	 * Checks if dist exists in giuw_wperilds and giuw_wperilds_dtl. used in POST-QUERY of GIUW_POL_DIST block
	 * @param distNo
	 * @return
	 * @throws SQLException
	 */
	String isExistGiuwWPerildsGIUWS012(Integer distNo) throws SQLException;
}
