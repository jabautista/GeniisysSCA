function prepareJsonAsParameter2(obj) {
	var tempObj = JSON.stringify(obj).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\t/g, "&#09").replace(/\\/g, "").replace(/&#10/g,"\\n").replace(/&#09/g,"\\t"); 
	return tempObj;
}