/**
 * Shows LOV for Line Cd 
 * @author Niknok Orio 
 * @date   06.06.2012
 */
function showGiisLineLOV(moduleId){
	try{
		LOV.show({
			controller: "AccountingLOVController",
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
				if (moduleId == "GIACS016"){
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
	  				$("txtLineCd").focus();
	  				if($F("varYyTag") == "Y"){ // added by irwin 
	  					enableInputField("txtDocYear");
	  				}else{
	  					disableInputField("txtDocYear");
	  				}
	  				
	  				if($F("varMmTag") == "Y"){ // added by irwin 
	  					enableInputField("txtDocMm");
	  				}else{
	  					disableInputField("txtDocMm");
	  				}
	  				
	  				
	  			}
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS016"){
	  				$("txtLineCd").focus();
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showGiisLineLOV",e);
	}
}