/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import java.text.SimpleDateFormat;

import org.apache.log4j.Logger;




/**
 * The Class DBSequenceUtil.
 */
public class DBSequenceUtil extends IbatisDAOAdapter
{
    
    /** The log. */
    protected static Logger log = Logger.getLogger(DBSequenceUtil.class);
    
    /** The db type. */
    private String dbType = "ORACLE"; 
    
	/**
	 * Gets the db type.
	 * 
	 * @return the db type
	 */
	public String getDbType() {
		return dbType;
	}

	/**
	 * Sets the db type.
	 * 
	 * @param dbType the new db type
	 */
	public void setDbType(String dbType) {
		this.dbType = dbType;
	}

	/**
	 * Gets the next seq no.
	 * 
	 * @param seqName the seq name
	 * 
	 * @return the next seq no
	 */
	public String getNextSeqNo(String seqName)
	{
	   String seqNo = (String)getSqlMapClientTemplate().queryForObject("getDBSequence"+dbType, seqName);
		return seqNo;
	}
	
	/**
	 * Gets the next seq no per branch.
	 * 
	 * @param seqName the seq name
	 * @param branch the branch
	 * 
	 * @return the next seq no per branch
	 */
	public String getNextSeqNoPerBranch(String seqName, String branch)
	{
	    String seqNo = (String)getSqlMapClientTemplate().queryForObject("getDBSequence"+dbType, seqName);
		SimpleDateFormat sdf=new SimpleDateFormat("yyMMdd");
		String dateString=sdf.format(new java.util.Date());
		return branch+dateString+seqNo;			
	}
	
	/**
	 * Gets the next seq no per machine.
	 * 
	 * @param seqName the seq name
	 * @param machine the machine
	 * 
	 * @return the next seq no per machine
	 */
	public String getNextSeqNoPerMachine(String seqName, String machine)
	{
	    String seqNo = (String)getSqlMapClientTemplate().queryForObject("getDBSequence"+dbType, seqName);
		return machine+seqNo;			
	}
} 

