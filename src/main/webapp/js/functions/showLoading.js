// show loading image after sending Ajax request
function showLoading(div, message, top){
	$(div).update('<table align="center" style="margin-top: '+top+';"><tr><td style="text-align: center;"><img src="'+contextPath+'/images/misc/loading3.gif" /></td></tr><tr><td style="text-align: center; font-size: 11px;">' + message + '</td></tr></table>');
}