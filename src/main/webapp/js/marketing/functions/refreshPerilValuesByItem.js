/** to refresh peril values by item selected 
 * @author irwin
 * @return
 */
function refreshPerilValuesByItem(){
	//removeAllOptions($("peril"));
	var itemNo = $F("item");
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	var itemNo =$F("item");
	var num = 9;
	$("peril").options.add(opt);
	$$("div[name='row1']").each(
		function (row)	{	
			var iNo =row.down("input", 0).value;	
			if(itemNo == iNo){
				var perilCd = new Array(row.down("input", 1).value);
				var perilName = new Array(row.down("input", 8).value);
				var pAmt = new Array(row.down("input", 3).value);
				var opt = document.createElement("option");
				opt.value = perilCd;
				opt.text = perilName;
				$("peril").options.add(opt);
			}
		}
	);
};