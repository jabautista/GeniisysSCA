/** refresh the list of ITEM LOV in deductible depending on the items 
 * @author irwin
 * @return
 */
function refreshItemValues(){
	var opt = document.createElement("option");
	opt.value = "";
	$("item").options.add(opt);
	$$("div[name='row']").each(
		function (row)	{
			var opt = document.createElement("option");
			var word = new Array(row.down("input", 0).value);
			var word2 = new Array(row.down("input", 1).value);
			opt.value = word;
			opt.text = word2;
			$("item").options.add(opt);
		}
	);
};