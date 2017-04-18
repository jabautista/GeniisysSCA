function prepareJsonAsParameter(obj) {
	//var tempObj = JSON.stringify(obj).replace('"[', "[").replace(']"', "]").replace(/\\/g, "");	// mark jm 10.12.2010 added replace call
	//var tempObj = JSON.stringify(obj).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\\\n");
	//var tempObj = JSON.stringify(obj).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\n"); // replaced by: nica 06.17.2011 - to handle line feed
	var tempObj = JSON.stringify(obj).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\t/g, " ").replace(/\\/g, "").replace(/&#10/g,"\\n"); // to handle (tab) \t Kenneth 10.28.2014
	return tempObj;
}