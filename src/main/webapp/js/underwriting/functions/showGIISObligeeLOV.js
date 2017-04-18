/**
 * Shows obligee list
 * @author shan
 * @date 03.25.2014
 * 
 */
function showGIISObligeeLOV(action, onOkFunction){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : action,
				page : 1},
			title : "List of Obligees",
			width : 435,
			height : 390,
			columnModel : [
			        {
			        	id: "obligeeNo",
			        	title: "Obligee No",
			        	width: '0px',
			        	visible: false
			        },
					{	id : "obligeeName",
						title : "Obligee Name",
						width : '415px'
					}],
			draggable : true,
			onSelect : onOkFunction
		});		
	} catch (e){
		showErrorMessage("showGIISObligeeLOV", e);
	}
}