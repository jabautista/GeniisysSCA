package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIMortgagee;

public interface GIPIMortgageeDAO {
	
	List<GIPIMortgagee> getMortgageeList(HashMap<String,Object> params) throws SQLException;
	
	List<GIPIMortgagee> getItemMortgagees(HashMap<String,Object> params) throws SQLException;
	
	BigDecimal getPerItemAmount(Map<String, Object> params) throws SQLException; //kenneth SR 5483 05.26.2016
	
	String getPerItemMortgName(Map<String, Object> params) throws SQLException; //Mark SR 5483,2743,3708 09.07.2016
}
