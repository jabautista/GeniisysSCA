// formats an integer, accepts comma, no decimal
function formatNumber(num) {
    num = num.toString().replace(/\$|\,/g,'').strip();
    
    if(num == "" || isNaN(num) || num == null || num == undefined){    
    	return "";
    }

    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.5000000000);
    num = Math.floor(num/100).toString();

    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++){
    	num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
    }

    return ((sign)?'':'-') +num; //edit by nok add the num sign
}