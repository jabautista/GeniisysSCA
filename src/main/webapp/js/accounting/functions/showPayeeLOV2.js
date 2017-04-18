/**
 * Shows LOV for Payee 
 * @author Niknok Orio 
 * @date   06.04.2012
 */
function showPayeeLOV2(moduleId, payeeClassCd, filterText){
	try{
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : 	  "getPayeesLOV",
							page : 		  1,
							payeeClassCd: payeeClassCd,
							filterText:	filterText == null ? "%" : filterText
			},
			title: "",
			width: 700,
			height: 386,
			filterText:	filterText == null ? "%" : filterText,
			autoSelectOneRecord: true,
			columnModel:[	
			             	{
								id : 'payeeNo',
								title: 'Payee',
								width : '99px',
								align: 'right',
								titleAlign: 'right'
							},
							{
								id : 'payeeLastName',
								title: 'Last Name',
							    width: '194px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'payeeFirstName',
								title: 'First Name',
							    width: '193px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'payeeMiddleName',
								title: 'Middle Name',
							    width: '193px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'nbtPayeeName',
								title: '',
							    width: '0px',
							    visible:false
							}
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GIACS016"){
					$("txtPayeeCd").value = formatNumberDigits(Number(row.payeeNo),12);
					$("txtPayee").value = unescapeHTML2(row.nbtPayeeName);
					$("txtPayeeCd").focus();
					$("txtPayeeCd").setAttribute("lastValidValue", formatNumberDigits(Number(row.payeeNo),12));
				}else if (moduleId == "GIACS002"){ //jeffDojello Enhancement SR-1069 11.05.2013
					$("txtPayeeNo").value = formatNumberDigits(Number(row.payeeNo),12);
					$("txtPayeeName").value = unescapeHTML2(row.nbtPayeeName);
					$("txtPayeeNo").focus();
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS016"){
	  				$("txtPayeeCd").focus();
	  				$("txtPayeeCd").value = $("txtPayeeCd").readAttribute("lastValidValue");
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showPayeeLOV2",e);
	}
}