/*
 * Date Author Description ========== ===============
 * ============================== 09.02.2011 mark jm lov for motorcar accessory
 */
function showAccessoryLOV(notIn) {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getAccessoryLOV",
						notIn : notIn,
						page : 1
					},
					title : "Accessories",
					width : 400,
					height : 300,
					columnModel : [ {
						id : "accessoryCd",
						title : "Accessory Cd",
						width : '100px'
					}, {
						id : "accessoryDesc",
						title : "Description",
						width : '260px'
					}, {
						id : "accAmt",
						title : "Accessory Amount",
						width : "100px",
						align : 'right',
						geniisysClass : 'money'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("accessoryCd").value = row.accessoryCd;
							$("accessoryDesc").value = unescapeHTML2(row.accessoryDesc);
							$("accessoryAmount").value = formatCurrency(row.accAmt);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showAccessoryLOV", e);
	}
}