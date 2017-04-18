/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import java.sql.SQLException;

import com.ibatis.sqlmap.client.extensions.ParameterSetter;
import com.ibatis.sqlmap.client.extensions.ResultGetter;
import com.ibatis.sqlmap.client.extensions.TypeHandlerCallback;



/**
 * The Class YesNoBoolTypeHandlerCallback.
 */
public class YesNoBoolTypeHandlerCallback implements TypeHandlerCallback{

	/** The Constant YES. */
	private static final String YES = "Y";
	
	/** The Constant NO. */
	private static final String NO = "N";
	
	/** The Constant One. */
	private static final Integer One = 1;
	
	/** The Constant Zero. */
	private static final Integer Zero = 0;
	
	/* (non-Javadoc)
	 * @see com.ibatis.sqlmap.client.extensions.TypeHandlerCallback#getResult(com.ibatis.sqlmap.client.extensions.ResultGetter)
	 */
	public Object getResult(ResultGetter getter) throws SQLException {
		String s = getter.getString();
		if(YES.equalsIgnoreCase(s) || One.equals(s)){
			return new Boolean(true);
		} else if(NO.equalsIgnoreCase(s) || Zero.equals(s)){
			return new Boolean(false);
		} else{
			throw new SQLException("Unexpected value" + s + "found where" + YES +"or"+ NO +"was expected.");
		}	
	}

	/* (non-Javadoc)
	 * @see com.ibatis.sqlmap.client.extensions.TypeHandlerCallback#setParameter(com.ibatis.sqlmap.client.extensions.ParameterSetter, java.lang.Object)
	 */
	public void setParameter(ParameterSetter setter, Object parameter) throws SQLException {
		boolean b = ((Boolean)parameter).booleanValue();
		if(b){
			setter.setString(YES);
		} else {
			setter.setString(NO);
		}
	}

	/* (non-Javadoc)
	 * @see com.ibatis.sqlmap.client.extensions.TypeHandlerCallback#valueOf(java.lang.String)
	 */
	public Object valueOf(String s) {
		if(YES.equalsIgnoreCase(s)){
			return new Boolean(true);
		} else if(NO.equalsIgnoreCase(s)){
			return new Boolean(false);
		} else{
			try {
				throw new SQLException("Unexpected value" + s + "found where" + YES +"or"+ NO +"was expected.");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return s;	
	}

}
