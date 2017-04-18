/*
 * Created by	: Jerome Orio
 * Date			: January 27, 2011
 * Description 	: Initialize pre-text attribute
 * Parameters	:  
 */
function initializePreTextAttribute(){
	$$("input[type='text'], input[type='hidden'], select").each(function (m) {
		m.observe("focus", function ()	{
			if (m.id.toUpperCase().include("DATE")) return;
			m.setAttribute("pre-text", m.value);
		});
		m.setAttribute("pre-text", m.value);
	});	
}