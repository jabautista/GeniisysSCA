function unescapeInspectionReport(str){ //added by steven 11/27/2012 ->customize unescapeHTML2,para palitan ung double quote ng ganito \\\"
	if(nvl(str,null) != null){
		return str.stripTags().replace(/&#38;/g,'&').replace(/&#241;/g, "\u00f1").replace(/&#209;/g, "\u00D1").replace(/&#60;/g,'<').replace(/&#62;/g,'>').replace(/&#039;/g, "'").replace(/&#34;/g, "\\\\\\\"").replace(/&#8629;/g, "\n");
	} else {
		return "";
	}
}