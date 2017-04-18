/**
 * Shows deductibles lov
 * 
 * @author andrew
 * @date 05.02.2011
 */
function showDeductibleLOV(lineCd, sublineCd, dedLevel, notIn) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISDeductibleLOV",
				lineCd : lineCd,
				sublineCd : sublineCd,
				notIn : notIn,
				page : 1
			},
			title : "Deductibles",
			width : 660,
			height : 320,
			columnModel : [ {
				id : "deductibleCd",
				title : "Code",
				width : '80px',
				renderer: function(value){   //added by jeffdojello 12.05.2013
				       var str = value;
				       var dedCd = str.replace("slash", "/");
         		   return  dedCd;}
			}, {
				id : "deductibleTitle",
				title : "Title",
				width : '220px'
			}, {
				id : "deductibleTypeDesc",
				title : "Type",
				width : '150px'
			}, {
				id : "deductibleRate",
				title : "Rate",
				width : '100px',
				align : 'right',
				geniisysClass : 'money'
			}, {
				id : "deductibleAmt",
				title : "Amount",
				width : '100px',
				align : 'right',
				geniisysClass : 'money'
			}, ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					onDeductibleSelected(row, dedLevel);
					$("deductibleText" + dedLevel).setAttribute("changed",
							"changed");
					// fireEvent($("deductibleText"+dedLevel), "change");
					changeTag = 1;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showDeductibleLOV", e);
	}
}