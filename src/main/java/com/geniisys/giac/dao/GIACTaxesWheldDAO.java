package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACTaxesWheld;

public interface GIACTaxesWheldDAO {

	/**
	 * Gets the GIAC_TAXES_WHELD records of specified tran id
	 * @param gaccTranId The gacc tran Id.
	 * @return
	 * @throws SQLException
	 */
	List<GIACTaxesWheld> getGiacTaxesWheld(Integer gaccTranId) throws SQLException;
	
	/**
	 * Saves GIAC Taxes Wheld records and performs post-forms-commit of GIACS022
	 * @param setTaxesWheldList
	 * @param delTaxesWheldList
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String saveGIACTaxesWheld(List<GIACTaxesWheld> setTaxesWheldList, List<GIACTaxesWheld> delTaxesWheldList, Map<String, Object> params) throws SQLException;

	String saveBir2307History(Map<String, Object> params) throws SQLException;//Added by pjsantos 12/27/2016, GENQA 5898
}
