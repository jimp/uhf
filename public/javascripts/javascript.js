// function to get page size
function getPageSize() {
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {
        xScroll = document.body.scrollWidth;
        yScroll = window.innerHeight + window.scrollMaxY;
    } else {
        if (document.body.scrollHeight > document.body.offsetHeight) {
            xScroll = document.body.scrollWidth;
            yScroll = document.body.scrollHeight;
        } else {
            xScroll = document.body.offsetWidth;
            yScroll = document.body.offsetHeight;
        }
    }
    var windowWidth, windowHeight;
    if (self.innerHeight) {
        windowWidth = self.innerWidth;
        windowHeight = self.innerHeight;
    } else {
        if (document.documentElement &&
            document.documentElement.clientHeight) {
            windowWidth = document.documentElement.clientWidth;
            windowHeight = document.documentElement.clientHeight;
        } else {
            if (document.body) {
                windowWidth = document.body.clientWidth;
                windowHeight = document.body.clientHeight;
            }
        }
    }
    if (yScroll < windowHeight) {
        pageHeight = windowHeight;
    } else {
        pageHeight = yScroll;
    }
    if (xScroll < windowWidth) {
        pageWidth = windowWidth;
    } else {
        pageWidth = xScroll;
    }
    arrayPageSize = new Array(pageWidth, pageHeight, windowWidth, windowHeight);
    return arrayPageSize;
}

// show modal function
function showModal () {
	var PageSize = getPageSize();
	var Body = document.body;
	var ModalElement = document.createElement('div');
	ModalElement.setAttribute('id','ModalOverlay');
	Body.insertBefore(ModalElement,Body.firstChild);			
	ModalElement.style.height = PageSize[1] + 'px';
	return true;
}

// get enlarged content
//function showFig(num) {
function showFig(text) {
			
	// show MOdal
	showModal();
	
	var PageSize = getPageSize();
	var Body = document.body;
	var Dialog = document.createElement('div');
	Dialog.setAttribute('id','Dialog');
	var CloseContainer = document.createElement('div');
	CloseContainer.className = 'closecontainer';
	var Close = document.createElement('div');
	Close.className = 'close';
	CloseContainer.appendChild(Close);
	var Content = document.createElement('div');
	Content.className = 'DialogContent';
	
	// switch
	//text = '<div id="Jdiv">';

	//click = "new Ajax.Updater(\'Jdiv\', \'/ajax/popup2\', {asynchronous:true, evalScripts:true}); return false;"
	//click = 'alert("Wow"); return false;'

	//text = text + '<img src="\\images\\pixel.png" onload="' + click + '"></div>';
	/*
	var text = "";
	switch(num)
	{
	  case "1":
			text = "<span>Example:</span> Lorem ipsum dolor sit adapiscing eli consectetuer vernascium est hic donastis. Lorem ipsum dolor sit adapiscing elit consectetuer. Lorem ipsum dolor sit adapiscing elit consectetuer vernascium est hic donastis.";
		  break;
		case "2":
		  text = "<div class=\"imagecontainer\"><img src=\"images/content_actions_image1.gif\" height=\"240\" width=\"500\" border=\"0\" alt=\"\" /></div><span>Figure 1:</span> Lorem ipsum dolor sit.";
		  break;
	}
	*/

	// append
	Content.innerHTML = text;
	Dialog.appendChild(Content);
	Dialog.appendChild(CloseContainer);
	Dialog.style.visibility = 'hidden';
	Body.appendChild(Dialog);
	var offset = window.pageYOffset || document.documentElement.scrollTop || 0;
	Dialog.style.top = ((PageSize[3] / 2) - (Dialog.offsetHeight / 2)) + offset + 'px';
	Dialog.style.left = ((PageSize[0] / 2) - (Dialog.offsetWidth / 2)) + 'px';						
	Dialog.style.visibility = 'visible';
	
	// remove
	Close.onclick = function () {
		var Body = document.body;
		var Modal = document.getElementById('ModalOverlay');
		var Dialog = document.getElementById('Dialog');		
		Body.removeChild(Modal);
		Body.removeChild(Dialog);		
	}
	
	//kill
	void(0);
}