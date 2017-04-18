package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWBankSchedule;

public interface GIPIWBankScheduleService {
	
	List<GIPIWBankSchedule> getGIPIWBankScheduleList(Integer parId)	throws SQLException;
	boolean saveGIPIWBankScheduleChanges(String parameter) throws SQLException, JSONException, ParseException;
	
}
