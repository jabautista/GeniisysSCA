/**
 * Trims unecessary spaces after the text
 * @param 
 * @return
 */
function rtrim(s)
{	var r=s.length -1;
	while(r > 0 && s[r] == ' ')
	{	r-=1;	}
	return s.substring(0, r+1);
}