//belle 10.05.2011 convert exponential numbers
function cnvrtPremAmt(premAmt){
	try{
		var cnvrtdPremAmt = null;
		String.prototype.expandExponential = function(){//v1.0
		    return this.replace(/^([+-])?(\d+).?(\d*)[eE]([-+]?\d+)$/, function(x, s, n, f, c){
		        var l = +c < 0, i = n.length + +c, x = (l ? n : f).length,
		        c = ((c = Math.abs(c)) >= x ? c - x + l : 0),
		        z = (new Array(c + 1)).join("0"), r = n + f;
		        return s + (l ? r = z + r : r += z).substr(0, i += l ? z.length : 0) + (i < r.length ? "." + r.substr(i) : "");
		    });
		};
		
		cnvrtdPremAmt = premAmt.toString().expandExponential();
		
		return cnvrtdPremAmt;
	} catch (e) {
		showErrorMessage("showResult", e);
	}
}