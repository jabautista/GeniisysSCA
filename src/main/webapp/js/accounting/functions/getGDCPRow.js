function getGDCPRow(dcpObject){
	try {
		var dcpRow = new Element("div");
		
		var dcpSequence = "";
		
		if($F("txtAdviceSequence") == "" || $F("txtAdviceSequence") == null){
			dcpSequence = dcpObject.adviceSequenceNumber;
		}else{
			dcpSequence = $F("txtAdviceSequence");
		}
		
		// check the source of function call if it's from load or from create
		// if from load, use object, else use textField
		
		dcpRow.setAttribute("id", 	"dcpRow" + dcpSequence);
		dcpRow.setAttribute("name", "dcpRow");
		dcpRow.setAttribute("class", "tableRow");
		
		var payeeShrt = "";
		
		if(dcpObject.payeeType == "L"){
			payeeShrt = "Loss";
		}else if(dcpObject.payeeType == "E"){
			payeeShrt = "Expense";
		}
		
		//var ashortName = dcpObject.assuredName.substr(0,9);
		var perilSname = dcpObject.perilSname; 
		dcpRow.update(
				'<label style="text-align: center; width: 90px;" title="' + dcpObject.transactionType + '">' + dcpObject.transactionType + '</label>' +
				'<label style="text-align: center; width: 135px;" title="' + dcpObject.adviceNumber + '">' + dcpSequence + '</label>' + 
			    '<label style="text-align: center; width: 110px;" title="' + dcpObject.payee + '">' + payeeShrt + '</label>' +
			    '<label style="text-align: center; width: 60px;" title="' + dcpObject.perilSname + '">' + perilSname + '</label>' +
			    //'<label style="text-align: center; width: 5%;" title="' + dcpObject.perilCode + '">' + dcpObject.assuredName + '</label>' +
			    '<label style="text-align: right; width: 120px;">' + formatCurrency(dcpObject.disbursementAmount) + '</label>' +
			    '<label style="text-align: right;  width: 120px;">' + formatCurrency(dcpObject.inputVatAmount) + '</label>' + 
			    '<label style="text-align: right;  width: 120px;">' + formatCurrency(dcpObject.withholdingTaxAmount) + '</label>' + 
			    '<label style="text-align: right;  width: 135px;">' + formatCurrency(dcpObject.netDisbursementAmount) + '</label>');
		loadRowMouseOverMouseOutObserver(dcpRow);

		dcpRow.observe("click", function(){
			dcpRow.toggleClassName("selectedRow");
			if(dcpRow.hasClassName("selectedRow")){
				$$("div[name='dcpRow']").each(function(anotherRow){
					if(dcpRow.id != anotherRow.id){
						anotherRow.removeClassName("selectedRow");
					}else{
						var postFix = dcpRow.id.substr(6);
						var found = false;
						var obj = null;
						for(var i = 0 ; i < dcpJsonObjectList.length; i++){
							if(dcpJsonObjectList[i].id == postFix){
								found = true;
								obj = dcpJsonObjectList[i];
								$break;
							}
						}
						if(found){
							populateGDCPForm(obj);
						}
					}
				});
				
			}else{
				populateGDCPForm(null);
			}
		});
		return dcpRow;
	} catch(e) {
		showErrorMessage("getGDCPRow", e);
	}
}