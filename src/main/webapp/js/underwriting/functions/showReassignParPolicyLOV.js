/**
 * Shows Reassign Par Policy
 * 
 * @author Steven Ramirez
 * @date 06.26.2012
 */
function showReassignParPolicyLOV(lineCd, issCd) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getReassignParPolicyLOV",
			lineCd : lineCd,
			issCd : issCd
		},
		title : "Valid Values for Underwriter",
		width : 400,
		height : 410,
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false,
			editor : 'checkbox'
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : 'userId',
			title : 'Underwriter',
			align : 'left',
			width : '140px'
		}, {
			id : 'userGrp',
			title : 'User Grp.',
			align : 'right',
			width : '70px'
		}, {
			id : 'userName',
			title : 'User Name',
			align : 'left',
			width : '150px'
		} ],
		draggable : true,
		onSelect : function(row) {
			objUW.hidObjGIPIS051.vUnderwriter = row.userId;
			objUW.hidObjGIPIS051.updateReassignParPolicy();
		}
	});
}