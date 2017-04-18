/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.exceptions
	File Name: BatchException.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 21, 2011
	Description: 
*/


package com.geniisys.gicl.exceptions;

public class BatchException extends RuntimeException{
	private static final long serialVersionUID = 7624572396640629899L;
	public BatchException(String msg){
		super(msg);
	}
}
