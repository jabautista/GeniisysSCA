/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;



/**
 * The Class NullChecker.
 * 
 * @author Mildred Dychinco
 * 
 * To change the template for this generated type comment go to
 */
public class NullChecker 
{
    
    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param strDefault the str default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static String ifNull(String strValue, String strDefault) 
    {

        if (strValue == null)
            return strDefault;
        else
            return strValue;

    }

    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param dblDefault the dbl default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static double ifNull(String strValue, double dblDefault) 
    {
        if (strValue != null) return Double.parseDouble(strValue);
        else return dblDefault;
    }

    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param intDefault the int default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static int ifNull(String strValue, int intDefault) 
    {
        if (strValue != null) return Integer.parseInt(strValue);
        else return intDefault;
    }

    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param longDefault the long default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static long ifNull(String strValue, long longDefault) 
    {
        if (strValue != null) return Long.parseLong(strValue);
        else return longDefault;
    }


    /**
     * <p> Returns strValue if it isn't '', otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param strDefault the str default
     * 
     * @return strValue if it's not blank, strDefault otherwise
     */
    public static String ifBlank(String strValue, String strDefault) 
    {

        if (strValue.equals(""))
            return strDefault;
        else
            return strValue;

    }

    /**
     * <p> Returns strValue if it isn't null nor blank, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param strDefault the str default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static String ifNullOrBlank(String strValue, String strDefault) 
    {

        if (strValue == null || strValue.trim().equals(""))
            return strDefault;
        else
            return strValue;

    }

    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param strDefault the str default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static Object ifNull(String strValue, Object strDefault) 
    {

        if (strValue == null)
            return strDefault;
        else
            return strValue;

    }

    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param strDefault the str default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static String ifNull(Object strValue, String strDefault) 
    {
        
        if (strValue == null)     
            return strDefault;
        else  
            return strValue.toString();
        
    }
    
    /**
     * <p> Returns strValue if it isn't null, otherwise, it returns strDefault.
     * 
     * @param strValue the str value
     * @param strDefault the str default
     * 
     * @return strValue if it's not null, strDefault otherwise
     */
    public static int ifNull(Object strValue, int strDefault) 
    {
        
        if (strValue == null)
            return strDefault;
        else   
            return Integer.parseInt(strValue.toString());
        
    }
    

    /**
     * <p> Returns true if it isn't null, otherwise, it returns false.  <br>
     * 
     * @param strValue the str value
     * 
     * @return  true - if strValue is not null
     * false - if strValue is null
     */
    public static boolean ifNull(String strValue) 
    {
        if (strValue == null)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    /**
     * If null.
     * 
     * @param object the object
     * 
     * @return true, if successful
     */
    public static boolean ifNull(Object object) 
    {
        if (object == null)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    /**
     * <p> Returns true if the input is null or blank, otherwise, it returns false.  <br>
     * 
     * @param strValue the str value
     * 
     * @return true - if strValue null or blank
     * false - if strValue is not null and not blank
     */
    public static boolean ifNullOrBlank(String strValue) 
    {
        if (strValue == null || strValue.equals(""))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /**
     * <p>Returns defaultVal as double if input is null.
     * 
     * @param input - the value to be tested
     * @param defaultVal - the value to be returned if input is null
     * <p>
     * 
     * @return the double
     * 
     * @author Mildred B Dychinco
     */
    public static double ifNullDouble(double input, double defaultVal) 
    {
        try 
        {
            return input;
        } 
        catch (NullPointerException npe) 
        {
            return defaultVal;
        } 
        catch (Exception e) 
        {
            return defaultVal;
        }
    }
    
    /**
     * <p>Returns defaultVal as int if input is null.
     * 
     * @param input - the value to be tested
     * @param defaultVal - the value to be returned if input is null
     * <p>
     * 
     * @return the int
     * 
     * @author Mildred B Dychinco
     */
    public static int ifNullInteger(int input, int defaultVal) 
    {
        try 
        {
            return input;
        } 
        catch (NullPointerException npe) 
        {
            return defaultVal;
        } 
        catch (Exception e) 
        {
            return defaultVal;
        }
    }

    /**
     * <p>Returns defaultVal as int if input is null or not int.
     * 
     * @param input - the value to be tested
     * @param defaultVal - the value to be returned if input is null
     * <p>
     * 
     * @return the int
     * 
     * @author PJ Ramores
     */
    public static int ifNullInteger(String input, int defaultVal) 
    {
        try 
        {
            return Integer.parseInt(input.toString());
        } 
        catch (NullPointerException npe) 
        {
            return defaultVal;
        } 
        catch (NumberFormatException nfe) 
        {
            return defaultVal;
        }
    }
    
    
    /**
     * The main method.
     * 
     * @param args the arguments
     */
    public static void main(String args[])  
    {
        System.out.println(NullChecker.ifNullDouble(123.4,5));
    }
    
    /**
     * <p> Returns true if the input is null or blank or 0, otherwise, it returns false.  <br>
     * 
     * @param strValue the str value
     * 
     * @return true - if strValue null or blank
     * false - if strValue is not null and not blank
     */
    public static boolean isNullOrBlankOrZero(String strValue) 
    {
        if (strValue == null || strValue.equals("") ||  strValue.equals("0"))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}//End of class
