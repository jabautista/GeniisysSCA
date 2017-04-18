package com.geniisys.common.exceptions;

public class InvalidLoginException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 563514214575983009L;

	public InvalidLoginException (String message) {
		super(message);
		if(message == null){
			message = "Invalid login credentials.";
		}
	}

}
