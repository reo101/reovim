" Vim syntax file
" Based on vim8.1 javascript syntax file http://www.fleiner.com/vim/syntax/javascript.vim
" Language:	Circom
" Original:	Claudio Fleiner <claudio@fleiner.com>
" Maintainer:	Eduard Sanou <eduard@iden3.io>
" Maintainer:	Pavel Atanasov <pavel.atanasov2001@gmail.com>

if !exists("main_syntax")
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'circom'
elseif exists("b:current_syntax") && b:current_syntax == "circom"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn keyword circomCommentTodo      TODO FIXME XXX TBD contained
syn match   circomLineComment      "\/\/.*" contains=@Spell,circomCommentTodo
syn match   circomCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  circomComment	       start="/\*"  end="\*/" contains=@Spell,circomCommentTodo
syn match   circomSpecial	       "\\\d\d\d\|\\."
syn region  circomStringD	       start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=circomSpecial,@htmlPreproc
syn region  circomStringS	       start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=circomSpecial,@htmlPreproc
syn region  circomStringT	       start=+`+  skip=+\\\\\|\\`+  end=+`+	contains=circomSpecial,circomEmbed,@htmlPreproc

syn region  circomEmbed	       start=+${+  end=+}+	contains=@circomEmbededExpr

syn match   circomSpecialCharacter "'\\.'"
syn match   circomNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  circomRegexpString     start=+[,(=+]\s*/[^/*]+ms=e-1,me=e-1 skip=+\\\\\|\\/+ end=+/[gimuys]\{0,2\}\s*$+ end=+/[gimuys]\{0,2\}\s*[+;.,)\]}]+me=e-1 end=+/[gimuys]\{0,2\}\s\+\/+me=e-1 contains=@htmlPreproc,circomComment oneline

syn keyword circomConditional	if else
syn keyword circomRepeat		while for do
syn match circomOpSymbols "=\{1,3}\|!==\|!=\|<--\|<==\|<\|>\|>=\|<=\|++\|+=\|--\|-="
" syn keyword circomType		signal
syn keyword circomStatement		return with
syn keyword circomBoolean		true false
syn keyword circomNull		null undefined
syn keyword circomIdentifier	arguments this var let
syn keyword circomLabel		case default
syn keyword circomMessage		alert confirm prompt status
syn keyword circomGlobal		self window top parent
syn keyword circomMember		document event location 
syn keyword circomReserved		abstract boolean byte char class const debugger double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile input output component signal
syn keyword circomInput input nextgroup=circomInputName skipwhite
syn keyword circomOutput output nextgroup=circomInputName skipwhite
syn match circomInputName '\i\+' contained

syn cluster  circomEmbededExpr	contains=circomBoolean,circomNull,circomIdentifier,circomStringD,circomStringS,circomStringT

syn keyword circomFunction	function
syn keyword circomTemplate	template
syn match circomFuncCall /\<\K\k*\ze\s*(/

syn match	circomBraces	   "[{}\[\]]"
syn match	circomParens	   "[()]"

syn sync fromstart
syn sync maxlines=100

if main_syntax == "circom"
  syn sync ccomment circomComment
endif

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link circomComment		Comment
hi def link circomLineComment		Comment
hi def link circomCommentTodo		Todo
hi def link circomSpecial		Special
hi def link circomStringS		String
hi def link circomStringD		String
hi def link circomStringT		String
hi def link circomCharacter		Character
hi def link circomSpecialCharacter	circomSpecial
hi def link circomNumber		Number
hi def link circomConditional		Conditional
hi def link circomRepeat		Repeat
hi def link circomOpSymbols		Operator
hi def link circomType			Type
hi def link circomStatement		Statement
hi def link circomFuncCall		Function
hi def link circomFunction		Identifier
hi def link circomTemplate		Identifier
hi def link circomBraces		Function
hi def link circomParens		Function
hi def link circomError		Error
hi def link javaScrParenError		circomError
hi def link circomNull			Keyword
hi def link circomBoolean		Boolean
hi def link circomRegexpString		String
hi def link circomInput 		Keyword
hi def link circomOutput		Keyword
hi def link circomInputName		Special

hi def link circomIdentifier		Identifier
hi def link circomLabel		Label
hi def link circomMessage		Keyword
hi def link circomGlobal		Keyword
hi def link circomMember		Keyword
hi def link circomReserved		Keyword
hi def link circomDebug		Debug
hi def link circomConstant		Label
hi def link circomEmbed		Special

let b:current_syntax = "circom"
if main_syntax == 'circom'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save
