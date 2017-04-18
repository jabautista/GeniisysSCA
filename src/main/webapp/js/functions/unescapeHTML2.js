/**
 * @author andrew robes
 * @date 02.16.2011
 * @description unescapes HTML tags and replaces single and double quotes html components with single and double quotes literal
 * @param str - string to be unescaped
 * added unescape tag for vertical bar 10.09.2013
 */
function unescapeHTML2(str){
	if(nvl(str,null) != null){
		//return str.stripTags().replace(/&#38;/g,'&').replace(/&#241;/g, "\u00f1").replace(/&#209;/g, "\u00D1").replace(/&#60;/g,'<').replace(/&#62;/g,'>').replace(/&#039;/g, "'").replace(/&#34;/g, "\"");		
		//return str.stripTags().replace(/&#38;/g,'&').replace(/&#241;/g, "\u00f1").replace(/&#209;/g, "\u00D1").replace(/&#60;/g,'<').replace(/&#62;/g,'>').replace(/&#039;/g, "'").replace(/&#34;/g, "\"").replace(/&#8629;/g, "\n"); // bonok :: 02.06.2013 :: added handling of \
		//return str.stripTags().replace(/&#38;/g,'&').replace(/&#241;/g, "\u00f1").replace(/&#209;/g, "\u00D1").replace(/&#60;/g,'<').replace(/&#62;/g,'>').replace(/&#039;/g, "'").replace(/&#34;/g, "\"").replace(/&#8629;/g, "\n").replace(/&#92;/g, "\\").replace(/&#09;/g, "\t");
		//return str.stripTags().replace(/&#241;/g, "\u00f1").replace(/&#209;/g, "\u00D1").replace(/&#60;/g,'<').replace(/&#62;/g,'>').replace(/&#039;/g, "'").replace(/&#34;/g, "\"").replace(/&#8629;/g, "\n").replace(/&#92;/g, "\\").replace(/&#09;/g, "\t").replace(/&#38;/g,'&').replace(/&#124;/g, "\|"); add & - Gzelle 02022015 
		return str.stripTags().replace(/&#38;/g,'&').replace(/&#241;/g, "\u00f1").replace(/&#209;/g, "\u00D1").replace(/&#60;/g,'<').replace(/&#62;/g,'>').replace(/&#039;/g, "'").replace(/&#34;/g, "\"").replace(/&#8629;/g, "\n").replace(/&#92;/g, "\\").replace(/&#09;/g, "\t").replace(/&#124;/g, "\|").replace(/&#38;/g,'&').replace(/&amp;/g,'&'); // modified by Kenneth 12.5.2014 // added &amp; jet FEB-01-2017
	} else {
		return "";
	}
}