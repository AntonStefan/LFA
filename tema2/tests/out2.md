How to Structure a LaTeX Document -- from https://en.wikibooks.org/wiki/LaTeX/simple.tex
===========
         In this article, I shall discuss some of the fundamental topics in producing a structured document.  This document itself does not go into much depth, but is instead the output of an example of how to implement structure. Its  LaTeX{} source, when in used with [http://www.comp.leeds.ac.uk/andyr/misc/latex/latextutorial2.html](my tutorial) provides all the relevant information.  
Introduction
-----------
 This small document is designed to illustrate how easy it is to create a well structured document within  LaTeX cite{lamport94}.  You should quickly be able to see how the article looks very professional, despite the content being far from academic.  Titles, section headings, justified text, text formatting etc., is all there, and you would be surprised when you see just how little markup was required to get this output.
Structure
-----------
 One of the great advantages of  LaTeX{} is that all it needs to know is the structure of a document, and then it will take care of the layout and presentation itself.  So, here we shall begin looking at how exactly you tell  LaTeX{} what it needs to know about your document.
Top Matter
-----------
 The first thing you normally have is a title of the document, as well as information about the author and date of publication.  In  LaTeX{} terms, this is all generally referred to as _top matter_.
Article Information
-----------

   - `title` _title_ - The title of the article.	
   -  `date` - The date. Use:		
   - `date today` - to get the			date that the document is typeset.			
   -  `date date` - for a  			specific date.		


Author Information
-----------
 The basic article class only provides the one command:
   - `author` - The author of the document.
 It is common to not only include the author name, but to insert new lines after and add things such as address and email details.  For a slightly more logical approach, use the AMS article class (`amsart`) and you have the following extracommands:
   - `address` - The author's address.  Use	the new line command for	line breaks.	
   -  `thanks` - Where you put any acknowledgments.	
   -  `email` - The author's email address.	
   -  `urladdr` - The URL for the author's web page.

Sectioning Commands
-----------
 The commands for inserting sections are fairly intuitive.  Of course, certain commands are appropriate to different document classes. For example, a book has chapters but a article doesn't. 	 	 	 	 	 	 		 		Command & Level                                        		`part` _part_ & -1 \\		`chapter` _chapter_ & 0 \\		`section` _section_ & 1 \\		`subsection` _subsection_ & 2 \\		\hline	\end{tabular_\end{center_Numbering of the sections is performed automatically by \LaTeX{_, so don'tbother adding them explicitly, just insert the heading you want betweenthe curly braces.  If you don't want sections number, then add an asterisk (*) after thesection command, but before the first curly brace, e.g., _A Title Without Numbers_.
> Leslie Lamport 
> LaTeX: A Document Preparation System. 
> Addison Wesley, Massachusetts, 
> 2nd Edition, 
> 1994. 

     