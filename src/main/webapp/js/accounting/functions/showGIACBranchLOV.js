/**
 * Shows GIAC Branches
 * @author andrew robes
 * @date 03.22.2012
 * @param onSelectFunction
 */	
function showGIACBranchLOV(onSelectFunction){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action : "getGIACBranchLOV",
						gfunFundCd : objACGlobal.fundCd,
						moduleId :  "GIACS037",
						page : 1},
		title: "Branches",
		width: 460,
		height: 300,
		columnModel : [
						{
							id : "branchCd",
							title: "Code",
							width: '100px',
							filterOption: true
						},
						{
							id : "branchName",
							title: "Branch",
							width: '325px'
						}
					],
		draggable: true,
		onSelect: function(row){
			onSelectFunction(row);
		}
	  });
}