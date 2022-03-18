" m syntax file
" Language:     dspec config file
" Maintainer:   chiram
" Last Change:  2014/12/05 16:03
" Filenames:    *.dspec
"
" This configuration file is something to modify *** configuration file.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match

syn match Version "\<[0-9][0-9]*\(\.[0-9][0-9]*\)*\>"
syn match SpecialChar "-"
syn match SpecialChar "*"
syn match Mandatory "^PRODUCT_NAME\s*=\s*" nextgroup=Text skipwhite
syn match Mandatory "^VERSION\s*=\s*"
syn match Mandatory "^SHORT_DESC\s*=\s*" nextgroup=Text skipwhite
syn match Mandatory "^LONG_DESC\s*=\s*" nextgroup=Text skipwhite
syn match Mandatory "^CUSTODIAN\s*=\s*" nextgroup=Text skipwhite
syn match Mandatory "^PERM\s*=\s*"
syn match Mandatory "^OWNER\s*=\s*" nextgroup=Text skipwhite
syn match Mandatory "^GROUP\s*=\s*" nextgroup=Text skipwhite

syn match Optional "^PACKAGE_OS_SPECIFIC\s*=" nextgroup=Text skipwhite
syn match Optional "^PACKAGE_OS_VERSIONED\s*=" nextgroup=Text skipwhite

syn match PkgCfg /\<requires\s\+pkg\>/ contained nextgroup=Pkg skipwhite
syn match Pkg /\S\+/ contained

syn match Action "^file\s\+" nextgroup=ActionSpec
syn match Action "^f\s\+" nextgroup=ActionSpec
syn match Action "^configfile\s\+" nextgroup=ActionSpec
syn match Action "^c\s\+" nextgroup=ActionSpec
syn match Action "^patchfile\s\+" nextgroup=ActionSpec
syn match Action "^p\s\+" nextgroup=ActionSpec
syn match Action "^glob\s\+" nextgroup=ActionSpec
syn match Action "^g\s\+" nextgroup=ActionSpec
syn match Action "^dir\s\+" nextgroup=ActionSpec
syn match Action "^d\s\+" nextgroup=ActionSpec
syn match Action "^symlink\s\+" nextgroup=ActionSpec
syn match Action "^s\s\+" nextgroup=ActionSpec
syn match Action "^crontab\s\+" nextgroup=ActionSpec
syn match Action "^fifo\s\+" nextgroup=ActionSpec
syn match Action "^noop\s\+" nextgroup=ActionSpec
syn match Action "^find\s\+" nextgroup=ActionSpec

syn region ActionSpec start=/./ end=/$/ contained contains=Target,Version,SpecialChar

syn region Comment start="^[ \t]*#" end="$"

syn region String start=+'+ end=+'+
syn region String start=+"+ end=+"+
syn region Shell start=+`+ end=+`+
syn match URL "\<http://\S\+" contained
syn region Text start=/[^`]/ end=/$/ contained contains=URL
syn match Target "[^/]\<\(bin\|conf\|doc\|etc\|include\|info\|lib\|libdata\|libexec\|logs\|man\|sbin\|share\|tmp\|var\)/\S\+" contained


" syn match selfCmd "set"
" syn match selfCmd "post-activate"
" syn match selfCmd "bug-product"
" syn match selfCmd "bug-component"
syn match selfCmd "\snil"
syn match selfCmd "^end" nextgroup=ActionSpec
syn match selfCmd ".each\s" nextgroup=ActionSpec
syn match selfCmd ".chomp" nextgroup=ActionSpec

syn match selfOption "\s\-\w\+"

syn match selfRoots "$ROOT"
syn match selfRoots "MAJOR_VERSION"
syn match selfRoots "MINOR_VERSION"
syn match selfRoots "PATCH_VERSION"
syn match selfRoots "BUILD_VERSION"
syn match selfRoots "SRCDIRS"

syn match selfRoots "^package"
syn match selfRoots "^summary"
syn match selfRoots "^description"
syn match selfRoots "^authors"
syn match selfRoots "^changelog"
syn match selfRoots "^section"
syn match selfRoots "^priority"
syn match selfRoots "^architecture"
syn match selfRoots "^license"
syn match selfRoots "^homepage"
syn match selfRoots "^buildtype"
syn match selfRoots "^\<\[default_attributes\|dummy_attributes\|dummy_databags\|dummy_encrypted_databags\|config_generation\]\>\s"

syn match Version "\<[0-9][0-9]*\([\.|\_|\-][0-9][0-9]*\)*\>"


" # ----------------------- #


if version >= 508 || !exists("did_syntax_inits")
  if version < 508
    let did_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink Mandatory Statement
  HiLink URL Statement
  HiLink Special Type
  HiLink Optional Type
  HiLink Action Function
  HiLink PkgCfg Function
  HiLink Comment Comment
  " HiLink Text Comment
  HiLink Target Statement
  " HiLink Pkg Comment
  HiLink String Number
  HiLink Version Number
  HiLink Shell PreProc
  HiLink SpecialChar SpecialChar

  " self setting
  HiLink selfCmd Type
  HiLink selfOption Type
  HiLink selfRoots Statement

  delcommand HiLink
endif

let b:current_syntax = "dspec"
