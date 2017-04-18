/**
 * Shows LOV for Currency 
 * @author Niknok Orio 
 * @date   03.13.2012
 */
function showClmItemCurrencyLOV(moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getGiclClmItemCurrencyLOV",
							//notIn : 	notIn,
							claimId:	objCLMGlobal.claimId,
							page : 		1 
			},
			title: "List of Currency",
			width: 835,
			height: 386,
			columnModel:[	
			             	{	id : "mainCurrencyCd",
								title: "Currency Cd",
								width: '85px',
								type: 'number',
								titleAlign: 'right',
				        		align: 'right',
								renderer: function (value){
		    						return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
		    					}
							},
							{	id : "currencyDesc",
								title: "Currency Description",
								width: '260px'
							},
							{	id : "currencyRt",
								title: "Currency Rate",
				        		align: 'right',
								width: '95px',
								type: 'number',
								geniisysClass: 'rate',
					            deciRate: 9
							},
							{	id : "itemNo",
								title: "Item No.",
								width: '70px',
								type: 'number',
				        		align: 'right'
							},
							{	id : "itemTitle",
								title: "Item Description",
								width:'304px' 
							}
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtCurrencyCd").value = formatNumberDigits(row.mainCurrencyCd,2);
					$("txtDspCurrencyDesc").value = unescapeHTML2(row.currencyDesc);
					$("txtConvertRate").value = formatToNthDecimal(nvl(row.currencyRt,""),9);
					$("txtCurrencyCd").focus();
				}
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmItemCurrencyLOV",e);
	}
}