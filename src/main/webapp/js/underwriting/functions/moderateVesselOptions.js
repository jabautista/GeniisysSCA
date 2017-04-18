/*	Created by	: Bryan Joseph G. Abuluyan 12.07.2010
 * 	Description	: hides vessels in the vesselCd list that are already existent in GIPI_WITEM table
 * 	Parameters	: 
 */
function moderateVesselOptions(){
	//show all
	$("vesselCd").childElements().each(function(o){
		o.show();
	});

	//hide existing
	/*$("vesselCd").childElements().each(function(o){
		$$("input[name='detailVesselCd']").each(function(ves){
			if (ves.value == o.value){
				o.hide();
			}
		});
	});*/

	//hide existing for newly-added or updated item
	/*$("vesselCd").childElements().each(function(o){
		$$("input[name='vesVesselCd']").each(function(ves){
			if (ves.value == o.value){
				o.hide();
			}
		});
	});*/

	//JSON implementation
	$("vesselCd").childElements().each(function(o){
		for (var i=0; i<objEndtMHItems.length; i++){
			if ((objEndtMHItems[i].vesselCd == o.value)
					&& (objEndtMHItems[i].recordStatus != -1)){
				hideOption(o);
			}
		}
	});
}