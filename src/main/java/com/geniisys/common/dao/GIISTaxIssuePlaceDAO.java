package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISTaxIssuePlaceDAO {
	void saveGiiss028TaxPlace(Map<String, Object> params) throws SQLException;
	void valDeleteTaxPlaceRec(Map<String, Object> params) throws SQLException;
}
