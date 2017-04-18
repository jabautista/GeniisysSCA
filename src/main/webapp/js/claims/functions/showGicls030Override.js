function showGicls030Override(moduleId, functionCode, onOk, onCancel){
	Override.show({
		moduleId : moduleId,
		functionCode : functionCode,
	    title: "Override User",
	    draggable: true,
	    onOk: function(userId, result){
	    	onOk(this, userId, result);
	    },
	    onCancel : function () {
	    	onCancel();
	    },
	    onShow:	function(){$("txtOverrideUserName").focus();}
	});	
}