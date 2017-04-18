/**
Shows list of Policy Numbers for GIAC Premium Deposit
* @author emsy bolaños
* @date 06.13.2012
* @module GIACS026
*/
function showGIISCurrencyLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action   : "getGiisCurrencyLOV",
				moduleId : "GIACS026",
					page : 1
			},
			title: "Search Currency",
			width: 440,
			height: 400,
			columnModel: [
	 			{
					id : 'mainCurrencyCd',
					title: 'Code',
					width : '80px',
					align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'currencyDesc',
					title: 'Description',
				    width: '210px',
				    align: 'left'
				},
				{
					id : 'currencyRt',
					title: 'Rate',
				    width: '100px',
				    align: 'right',
				    titleAlign: 'right',
				    geniisysClass: 'money',
					geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
					maxlength: 30
				},
				{
					id : 'shortName',
				    width: '0px',
				    visible: false
				}
			],
			draggable: true,
			onSelect: function(row) {
				if(row != undefined){
					$("txtCurrencyCd").value = row.mainCurrencyCd;
					$("txtDspCurrencyDesc").value = row.currencyDesc;
					$("txtConvertRate").value = row.currencyRt;

					if ($F("dfltCurrencyCd") == $F("txtCurrencyCd")) {
						$("txtConvertRate").readOnly = true;
					} else {
						$("txtConvertRate").readOnly = false;
					}
					$("txtForeignCurrAmt").value  = formatCurrency(parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / parseFloat(row.currencyRt));
				}
			},
			onCancel: function(){
	  			$("txtCurrencyCd").focus();
	  		}
		});
	}catch(e){
		showErrorMessage("showGIISCurrencyLOV",e);
	}
}