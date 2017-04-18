/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.exceptions;


/**
 * The Class UseridAlreadyTakenException.
 */
public class UseridAlreadyTakenException extends Exception {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/**
	 * Instantiates a new userid already taken exception.
	 * 
	 * @param message the message
	 */
	public UseridAlreadyTakenException(String message) {
		super(message);
	}

}
