//RENEWAL CERTIFICATE
function checkIfShowRenewalCertificate(){
	if (!(parseFloat($F("renewNo")) > 0)){
		$("docType").childElements().each(function (o) {
			if (o.value == "RENEWAL CERTIFICATE" || o.value == "RENEWAL"){ // Nica 05.22.2012 - added condition o.value == "RENEWAL"
				//o.hide();
				hideOption(o);
			}
		});
	}
}