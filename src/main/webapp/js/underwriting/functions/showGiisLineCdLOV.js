function showGiisLineCdLOV(moduleId){
	try{
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiisLineLOV",
				page :	1 
			},
			title: "",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "lineCd",
								title: "Line Code",
								width: '80px'
							},
							{	id : "lineName",
								title: "Line Name",
								width: '310px'
							}
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GIUTS007"){
					$("lineCdSearch").value = unescapeHTML2(row.lineCd);
	  				$("lineCdSearch").focus();
	  			}
			}
		});
	}catch(e){
		showErrorMessage("showGiisLineCdLOV",e);
	}
}