package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACWholdingTaxesDAO {

	/**
	 * Executes WHEN-VALIDATE-ITEM trigger of WHTAX_CODE in GIACS022 
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs022WhtaxCode(Map<String, Object> params) throws SQLException;
	String validateItemNo (Map<String, Object> params) throws SQLException;
	void saveGiacs318(Map<String, Object> params) throws SQLException;
	void valDeleteWhtax(Integer whtaxId) throws SQLException;
}
