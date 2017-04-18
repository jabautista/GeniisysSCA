package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.exceptions.LossExpDistException;

public interface GICLLossExpDsDAO {
	Map<String, Object> checkXOL(Map<String, Object> params) throws SQLException;
	String distributeLossExpHistory(Map<String, Object> params) throws SQLException, Exception;
	String redistributeLossExpHistory(Map<String, Object> params) throws SQLException, Exception;
	String negateLossExpenseHistory(Map<String, Object> params) throws SQLException, Exception;
	String checkDeductibles(Map<String, Object> params) throws SQLException, Exception, LossExpDistException;
}
