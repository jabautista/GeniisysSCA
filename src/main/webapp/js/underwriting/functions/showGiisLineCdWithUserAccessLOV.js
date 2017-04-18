function showGiisLineCdWithUserAccessLOV(moduleId){ //added by steven 5/30/2013
	try{
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS062LineLOV",
				moduleId: moduleId,
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
				if (moduleId == "GIISS062"){
	  				$("lineCd").value =unescapeHTML2(row.lineCd);
	  				$("txtLineName").value =unescapeHTML2(row.lineName);
	  				$("txtPerilName").clear();
	  			}
			}
		});
	}catch(e){
		showErrorMessage("showGiisLineCdWithUserAccessLOV",e);
	}
}