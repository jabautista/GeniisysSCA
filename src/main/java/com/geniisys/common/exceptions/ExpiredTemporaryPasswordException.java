package com.geniisys.common.exceptions;

public class ExpiredTemporaryPasswordException extends Exception{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public ExpiredTemporaryPasswordException (String message) {
		super(message);
	}

}
