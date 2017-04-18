/**
Shows list of Payee Class List
* @author s. ramirez
* @date 06.08.2012
* @module GIACS022
*/
function showWhtaxCodeLOV(gaccBranchCd){
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {action : "getWhtaxCodeLOV",
						 gaccBranchCd: gaccBranchCd
						},
		title: "Tax Code List",
		width: 630,
		height: 380,
		columnModel: [
 			{
				id : 'gibrBranchCd',
				title: 'Branch Code',
				width : '80px',
				sortable:false,
				align: 'left'
			},
			{
				id : 'whtaxCode',
				title: 'Tax Code',
			    width: '70px',
			    align: 'right'
			},
			{
				id : 'birTaxCd',
				title: 'BIR Tax Code',
			    width: '150px',
			    align: 'left'
			},
			{
				id : 'percentRate',
				title: 'Rate',
			    width: '70px',
			    align: 'right'
			},
			{
				id : 'whtaxDesc',
				title: 'Withholding Tax',
			    width: '250px',
			    align: 'left'
			}
		],
		draggable: true,
		onSelect: function(row) {
			$("txtWhtaxCode").value=unescapeHTML2(row.whtaxDesc);
			$("hiddenWhtaxCode").value=row.whtaxCode;
			$("txtBirTaxCd").value = row.birTaxCd;
			$("txtPercentRate").value = row.percentRate == null ? "0.000" : row.percentRate+".000";
			$("txtSlName").clear();
			$("txtIncomeAmt").clear();
			$("txtWholdingTaxAmt").clear();
			objAC.hidObjGIACS022.validateWhtax();
			objAC.hidObjGIACS022.validatePercentRate();
		}
	});
}