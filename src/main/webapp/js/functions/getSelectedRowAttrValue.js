//created by: Jerome Orio
//get the id of the record
//parameter: 
//rowName: name of the rows
//return: attribute value
function getSelectedRowAttrValue(rowName, attr){
	var attrValue = "";
	$$('div[name="'+rowName+'"]').each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			attrValue = row.readAttribute(attr);
		}
	});
	return attrValue;
}