//added by steve 8.14.2013
function showGiisAssuredLov(findText2,id,moduleId){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
							 action   : "getGiisAssuredLov",
							 findText2 : findText2,
							 page : 1
			},
			title: "List of Assured",
			width: 400,
			height: 400,
			columnModel: [
	 			{
					id : 'assdNo',
					title: 'Assured No.',
					width : '100px',
					align: 'left'
				},
				{
					id : 'assdName',
					title: 'Assured Name',
					width : '280px',
					align: 'left'
				}
			],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				if(row != undefined){
					if (moduleId == "GIACS221") {
						$("txtAssuredNo").value = lpad(row.assdNo,6,'0');
						$("txtAssuredName").value = unescapeHTML2(row.assdName);
						enableToolbarButton("btnToolbarEnterQuery");
					} 
				}
			},
			onCancel: function(){
				if (moduleId == "GIACS221") {
					$(id).focus();
				} 
	  		}
		});
	}catch(e){
		showErrorMessage("showGiisAssuredLov",e);
	}
}