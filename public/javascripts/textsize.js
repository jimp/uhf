var sizeid = 'Normal';

function TextSize(size)
{
	var bodysizes = {'Normal':14,'Large':16,'Largest':18};
	var fontsize = bodysizes[size];
	document.body.style.fontSize = fontsize+'px';
	var active = document.getElementById(size);
	var parent = document.getElementById('TextSize');
	var links = parent.getElementsByTagName('a');
	for(var i = 0; i<links.length; i++) 
	{
		links[i].className = null;
	}
		
	active.className = 'active';
	sizeid = size;
}

window.onload = function()
{
	var ca = document.cookie.split('=');
	if(ca[1])
	{
		TextSize(ca[1]);
	}
}	

window.onunload = function()
{
	document.cookie = 'size='+sizeid;
}