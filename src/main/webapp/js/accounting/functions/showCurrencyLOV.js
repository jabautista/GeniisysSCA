/**
 * Shows LOV for Currency 
 * @author Niknok Orio 
 * @date   06.04.2012
 */
function showCurrencyLOV(moduleId){
	try{
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : 	  "getGiisCurrencyLOV",
							page : 		  1, 
			},
			title: "",
			width: 420,
			height: 386,
			columnModel:[	
							{
								id : 'shortName',
								title: 'Name',
							    width: '75px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'currencyDesc',
								title: 'Description',
							    width: '205px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'mainCurrencyCd',
								title: 'Currency Code',
								width : '120px',
								align: 'right',
								titleAlign: 'right'
							},
							{
								id : 'currencyRt',
								title: '',
							    align: 'right',
							    titleAlign: 'right',
							    width: '0px',
							    visible:false
							}
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GIACS016"){
					$("txtCurrencyRt").value = formatToNineDecimal(row.currencyRt);
					$("txtDspFshortName").value = unescapeHTML2(row.shortName);
					$("txtCurrencyCd").value = row.mainCurrencyCd;
				}else if(moduleId == "GIACS071"){
					if(row != null){
						$("txtCurrencyRt").value = formatToNineDecimal(row.currencyRt);
						$("txtDspFshortName").value = unescapeHTML2(row.shortName);
						$("txtCurrencyCd").value = row.mainCurrencyCd;										
						$("txtForeignAmount").focus();
						if(objACGlobal.objGIACS071.convertToLocalAmount()){ //added by steven 11.22.2013
							$("txtLocalAmount").focus();
						} else {
							$("txtForeignAmount").focus();
							$("txtLocalAmount").value = "";
						} 
						changeTag = 1;
					} else {
						customShowMessageBox("You must enter a currency.", "I", "txtDspFshortName");
					}
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS016"){
	  				$("txtDspFshortName").focus();
	  			} else if(moduleId == "GIACS071"){
	  				$("txtDspFshortName").focus();
	  				/*if(objGIAC071.prevParams.validCurrSname == "N" || $("txtDspFshortName") == ""){
	  					customShowMessageBox("You must enter a currency.", "I", "txtDspFshortName");
	  				}*/
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showPayeeLOV2",e);
	}
}