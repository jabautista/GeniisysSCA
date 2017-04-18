//format percent rates up to 9 decimal places
// mark jm 10.17.2011 validate first the parameter before using any function
function formatToNineDecimal(num)	{	
	if (num == null | num == undefined | isNaN(num)) {
		return "";
	}else if(num.toString() == ""){
		return "";
	}
	
	num = num.toString().replace(/\$|\,/g,'');
	return parseFloat(num).toFixed(9);
}