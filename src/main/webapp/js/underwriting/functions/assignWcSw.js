function assignWcSw(){
	var itemNo = $("addItemNo").value;
	var perilCd = $("addPerilCd").value;
	$$("div#row"+itemNo+perilCd+" input[id='wcSw"+perilCd+"']").each(function (r)	{
			r.value = "Y";
		}
	);
}