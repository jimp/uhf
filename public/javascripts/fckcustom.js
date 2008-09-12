// CHANGE FOR APPS HOSTED IN SUBDIRECTORY
FCKRelativePath = '';

// DON'T CHANGE THESE
FCKConfig.LinkBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Connector='+FCKRelativePath+'/fckeditor/command';
FCKConfig.ImageBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Image&Connector='+FCKRelativePath+'/fckeditor/command';
FCKConfig.FlashBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Flash&Connector='+FCKRelativePath+'/fckeditor/command';

FCKConfig.LinkUploadURL = FCKRelativePath+'/fckeditor/upload';
FCKConfig.ImageUploadURL = FCKRelativePath+'/fckeditor/upload?Type=Image';
FCKConfig.FlashUploadURL = FCKRelativePath+'/fckeditor/upload?Type=Flash';
FCKConfig.FileUploadURL = FCKRelativePath+'/fckeditor/upload?Type=File';
FCKConfig.MediaUploadURL = FCKRelativePath+'/fckeditor/upload?Type=Media';
FCKConfig.AllowQueryStringDebug = false;
FCKConfig.SpellChecker = 'SpellerPages';

// ONLY CHANGE BELOW HERE
FCKConfig.SkinPath = FCKConfig.BasePath + 'skins/office2003/';
//Changed to screen.css on Noahs request
//FCKConfig.EditorAreaCSS = '/stylesheets/wysiwyg.css' ;
FCKConfig.EditorAreaCSS = '/stylesheets/screen.css' ;
FCKConfig.FontFormats	= 'p;h1;h2;h3;h4;h5;h6;div;pre;address;' ;

FCKConfig.ToolbarSets["Simple"] = [
	['Source','-','-','Templates'],
	['Cut','Copy','Paste','PasteWord','-','Print','SpellCheck'],
	['Undo','Redo','-','Find','Replace','-','SelectAll'],
	'/',
	['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink'],
	'/',
	['Image','Table','Rule','Smiley'],
	['FontName','FontSize'],
	['TextColor','BGColor'],
	['-','About']
] ;

FCKConfig.ToolbarSets["Jasper"] = [
  ['PasteWord','Bold','Italic','Underline','StrikeThrough','OrderedList','UnorderedList','Outdent','Indent','JustifyLeft','JustifyCenter','JustifyRight','JustifyFull','Image','Link','Unlink','Templates'],
  ['FontFormat','Source'],
  ['Style','FitWindow']
] ;