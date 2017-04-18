/**
 * Shows Recoverable Details 
 * @author Niknok Orio 
 * @date   03.15.2012
 */
function showClmRecoverableDetails(claimId, lineCd, recoveryId, moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getRecoverableDetailsLOV",
							//notIn : 	notIn,
							claimId: 	claimId,
							lineCd: 	lineCd,
							recoveryId: recoveryId,
							page : 		1 
			},
			title: "Recoverable Amount",
			width: 705,
			height: 386,
			hideColumnChildTitle: true,
			filterVersion: "2",
			columnModel:[	
				{	id : "chkChoose",
					title: '&#160;',
		            altTitle: '&#160;',
		            titleAlign: 'center',
		            width: 22,
		            maxlength: 1, 
		            sortable: false, 
				   	hideSelectAllBox: true,
				   	otherValue: false,
				   	editor: new MyTableGrid.CellCheckbox({ 
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
				   	}),	
					editable: true
				},
			    {
					id: 'itemNo itemTitle',
					title: 'Item',
					width : '207px',
					children : [
			            {
			                id : 'itemNo',
			                title: 'Item No.',
			                width : 50,
			                align: 'right',
			                filterOption: true,
			                filterOptionType: 'integer',
			                editable: false 		
			            }, 
			            {
			                id : 'itemTitle', 
			                title: 'Item Title',
			                width : 157,
			                filterOption: true, 
			                editable: false
			            } 
					]
				},
				{
					id: 'perilCd perilSname',
					title: 'Peril',
					width : '207px',
					children : [
			            {
			                id : 'perilCd',
			                title: 'Peril Code',
			                width : 50,
			                align: 'right',
			                filterOption: true,
			                filterOptionType: 'integer',
			                editable: false 		
			            }, 
			            {
			                id : 'perilSname', 
			                title: 'Peril Name',
			                width : 157,
			                filterOption: true, 
			                editable: false
			            } 
					]
				},	
				{	id : "nbtAnnTsiAmt",
					title: "TSI Amount",
					width: '120px',
					align: 'right',
					geniisysClass: 'money',
					filterOption: true,
	                filterOptionType: 'number'
				},	
				{	id : "nbtPaidAmt",
					title: "Recoverable",
					width: '120px',
					align: 'right',
					geniisysClass: 'money',
					filterOption: true,
	                filterOptionType: 'number',
	                editable: true,
	                maxlength: 17,
	                geniisysMinValue: '-9999999999999.99',
					geniisysMaxValue: '100000000000000.00',
					geniisysErrorMsg: 'Field must be form of 999,999,999,990.00',    
					editor: new MyTableGrid.CellInput({
		            	validate: function(value, input){
		            		if (value < 0){
		            			showMessageBox('Recoverable amount should not be less than 0.', 'I');
		            			return false;
		            		}
		            		if (nvl(value,null) == null){
		            			showMessageBox('Recoverable amount should not be null.', 'I');
		            			return false;
		            		}
		            		return true;
		            	}
					})
				},
				{	id : "lossReserve",
					title: "",
					width: '0',
					visible: false
				},
				{	id : "clmLossId",
					title: "",
					width: '0',
					visible: false
				}
			],
			draggable: true,
			/*onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtRecoverableAmt").value = nvl(row.nbtPaidAmt,"") == "" ? "0.00" :formatCurrency(row.nbtPaidAmt);
					$("txtRecoverableAmt2").value = nvl(row.nbtPaidAmt,"") == "" ? "0.00" :formatCurrency(row.nbtPaidAmt);
					$("txtRecoverableAmt2").focus();
				}
			},*/
			/*added new option onSelect2*/
			onSelect2: function(self){
				if (moduleId == "GICLS025"){
					var ctr = 0;
					for (var i=0; i<tbgLOV.rows.length; i++){
						var divCtrId = tbgLOV.rows[i][tbgLOV.getColumnIndex('divCtrId')];
						var tag	= tbgLOV.rows[i][tbgLOV.getColumnIndex('chkChoose')];
						var nbtPaidAmt	= tbgLOV.rows[i][tbgLOV.getColumnIndex('nbtPaidAmt')];
						var nbtPaidAmtOrig	= tbgLOV.geniisysRows[i].nbtPaidAmt;
						if (tag == "Y" || nbtPaidAmt != nbtPaidAmtOrig){
							ctr++;
							showConfirmBox("", "Would you like to continue saving?", "Yes", "No", 
									function(){
										objCLM.recoveryDetailsLOV = tbgLOV.getAllRows();
										$("txtRecoverableAmt").value = nvl(nbtPaidAmt,"") == "" ? "0.00" :formatCurrency(nbtPaidAmt);
										$("txtRecoverableAmt2").value = nvl(nbtPaidAmt,"") == "" ? "0.00" :formatCurrency(nbtPaidAmt);
										$("txtRecoverableAmt2").focus();
										fireEvent($("btnAdd"), "click");
										self.close();
									}, 
									function(){
										self.close();
									}, 
									1);
							//throw $break;  //remove by steven 11/06/2012
							break;		//added by steven 11/06/2012
						}	
					}
					if (ctr == 0){
						self.close();
					}
				}	
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmRecoverableDetails",e);
	}
}	