package com.geniisys.gipi.dao;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWBankSchedule;

public interface GIPIWBankScheduleDAO {
	
	List<GIPIWBankSchedule> getGIPIWBankScheduleList(Integer parId) throws SQLException;
	boolean saveGIPIWBankScheduleChanges(Map<String, Object> params) throws SQLException;
	//boolean insertGIPIWBankSchedule(Map<String, Object> params) throws SQLException;
	//boolean deleteGIPIWBankSchedule(Map<String, Object> params) throws SQLException;
	
}
