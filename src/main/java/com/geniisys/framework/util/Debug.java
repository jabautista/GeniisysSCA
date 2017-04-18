/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;



/**
 * The Class Debug.
 */
public class Debug
{
    
    /**
     * Prints the.
     * 
     * @param msg the msg
     */
    public static final void print(String msg) 
    {

    	
        if (debuggingOn) 
        {
           System.out.println("Debug: "  + new java.util.Date() + prefix + msg);
        }
    }

        /**
         * Print out double parameter.
         * 
         * @param msg double parameter
         */
    public static final void print(double msg) 
    {

        if (debuggingOn) 
        {
           System.out.println("Debug: "   + new java.util.Date() + prefix + msg);
        }
    }

        /**
         * Print out int parameter.
         * 
         * @param msg int parameter
         */
    public static final void print(int msg) 
    {

        if (debuggingOn) 
        {
           System.out.println("Debug: "   + new java.util.Date() + prefix + msg);
        }
    }

        /**
         * Print out object parameter.
         * 
         * @param object object parameter
         */
    public static final void print(Object object) 
    {

        if (debuggingOn) 
        {
           System.out.println("Debug: "   + new java.util.Date() + prefix + object);
        }
    }

        /**
         * Print out string and object parameters.
         * 
         * @param msg string parameter
         * @param object object parameter
         */
    public static final void print(String msg, Object object) 
    {

        if (debuggingOn) 
        {
           System.out.println("Debug: "   + new java.util.Date() + prefix + msg);
           System.out.println("       " + object.getClass().getName());
        }
    }


    /** The Constant debuggingOn. */
    public static final boolean debuggingOn = true;
    
    /** The Constant prefix. */
    public static final String prefix = " : TRACE : CPI : ";

}//End of class
