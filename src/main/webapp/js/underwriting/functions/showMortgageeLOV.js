/*
 * Created by : mark jm 07.21.2011 Description : show mortgagee lov Parameters :
 * parId - parId : itemNo - itemNo : issCd - issCd
 */
// added func param kenneth SR 5483 05.26.2016
function showMortgageeLOV(parId, itemNo, issCd, notIn, func,func1) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getMortgageeLOV",
				parId : parId,
				itemNo : itemNo,
				issCd : issCd,
				notIn : notIn,
				page : 1
			},
			title : "Mortgagees",
			width : 400,
			height : 300,
			columnModel : [ {
				id : "mortgCd",
				title : "Mortgagee Cd",
				width : '100px'
			}, {
				id : "mortgName",
				title : "Mortgagee Name",
				width : '260px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("mortgCd").value = row.mortgCd;
					$("mortgageeName").value = unescapeHTML2(row.mortgName);
					$("chkDeleteSw").checked = row.deleteSw == null ? false : row.deleteSw == "Y" ? true : false; //kenneth SR 5483 05.26.2016
					$("mortgageeAmount").value = formatCurrency(func(row.mortgCd)); //kenneth SR 5483 05.26.2016
					//added by MarkS 9.07.2016 SR-5483,2743,3708
					if (func1(row.mortgCd) == "" || func1(row.mortgCd)== 0 ){
						$("mortgageeAmount").setAttribute("min", '-9999999999999.99');
						$("chkDeleteSw").disabled=true;
					}else{
						$("mortgageeAmount").setAttribute("min", '0');
						$("chkDeleteSw").disabled=false; 
					}
					//END 5483,2743,3708
				}
			}
		});
	} catch (e) {
		showErrorMessage("showMortgageeLOV", e);
	}
}