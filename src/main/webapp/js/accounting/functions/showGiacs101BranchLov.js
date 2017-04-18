function showGiacs101BranchLov(findText2,id,moduleId){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
							 action   : "getGiacs101BranchLOV",
							 findText2 : findText2,
							 moduleId : moduleId,
							 page : 1
			},
			title: "Lists of Branches",
			width: 400,
			height: 380,
			columnModel: [
				{
					id : 'branchCd',
					title: 'Branch Code',
					width : '100px',
					align: 'right'
				},
				{
					id : 'branchName',
					title: 'Branch Name',
				    width: '250px',
				    align: 'left'
				}
			],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				if(row != undefined){
					if (moduleId == 'GIACS101') {
						$("txtBranchCd").value = row.branchCd;
						$("txtBranchName").value = unescapeHTML2(row.branchName);
					}
				}
			},
			onCancel: function(){
	  			$(id).focus();
	  		}
		});
	}catch(e){
		showErrorMessage("showGiacs101BranchLov",e);
	}
}