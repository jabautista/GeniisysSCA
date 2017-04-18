package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISPayees;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACInputVat;
import com.geniisys.giac.entity.GIACSlLists;

public interface GIACInputVatDAO {

	List<GIACInputVat> getGiacInputVat(HashMap<String, String> params) throws SQLException;
	List<GIISPayees> getPayeeList(HashMap<String, Object> params) throws SQLException;
	List<GIACSlLists> getSlNameList(HashMap<String, Object> params) throws SQLException;
	List<GIACChartOfAccts> getAcctCodeList(HashMap<String, Object> params) throws SQLException;
	GIACChartOfAccts validateAcctCode(HashMap<String, String> params) throws SQLException;
	String saveInputVat(Map<String, Object> params) throws SQLException;
}
