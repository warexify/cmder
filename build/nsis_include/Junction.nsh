;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HOW TO USE?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; !include "junction.nsh"
; 
; ; checks if target is hard link 
; ${IsHardLink} "${Path}" ${outVar} 
; ; checks if target is a soft link (symbolic link or junction) 
; ${IsSoftLink} "${Path}" ${outVar} 
; ; checks if target is either a hard link or a soft link 
; ${IsLink} "${Path}" ${outVar} 
; 
; ; creates a hard link (file only, must be on the same volume, and target must exist) 
; ${CreateHardLink} "${Junction}" "${Target}" ${outVar} 
; ; creates a symbolic link for a file (Vista+, target doesn't need to exist and can be anywhere) 
; ${CreateSymbolicLinkFile} "${Junction}" "${Target}" ${outVar} 
; ; tries to create a symbolic link first and when it fails, then it tries to create a hard link (files only) 
; ${CreateLinkFile} "${Junction}" "${Target}" ${outVar} 
; 
; ; creates a symbolic link for a folder (Vista+, target doesn't need to exist) 
; ${CreateSymbolicLinkFolder} "${Junction}" "${Target}" ${outVar} 
; ; creates a junction (folders only, path must be absolute and target should exist) 
; ${CreateJunction} "${Junction}" "${Target}" ${outVar} 
; ; tries to create symbolic link first and when it fails, then it tries to create a junctions (directories only) 
; ${CreateLinkFolder} "${Junction}" "${Target}" ${outVar} 
; 
; ; checks if a folder is a junction or a symbolic link, and if it is, it deletes it 
; ${DeleteLinkFolder} "${Path}" ${outVar} 
; ; checks if a file is a symbolic link or a hard link, and if it is, it deletes it 
; ${DeleteLinkFile} "${Path}" ${outVar} 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!ifndef JUNCTION_INCLUDED 
!define JUNCTION_INCLUDED 

; misc 
!define CreateParentFolder "!insertmacro CreateParentFolder" 

!macro CreateParentFolder Path 
  Push $1   
  ${GetParent} "${Path}" $1 
  CreateDirectory "$1" 
  Pop $1 
!macroend 

; info 
!define IsLink "!insertmacro IsLink" 
!define IsSoftLink "!insertmacro IsSoftLink" 
!define IsHardLink "!insertmacro IsHardLink" 

Function IsSoftLink 
  Exch $0 
  ${GetFileAttributes} "$0" "REPARSE_POINT" $0 

  ${If} $0 != "1" 
    StrCpy $0 "0" 
  ${EndIf} 
  Exch $0 
FunctionEnd 

!macro IsSoftLink Path outVar 
  Push "${Path}" 
  Call IsSoftLink 
  Pop ${outVar} 
!macroend 

Function IsHardLink 
  Exch $1 
  System::Call "kernel32::CreateFileW(w `$1`, i 0x40000000, i 0, i 0, i 3, i 0, i 0) i .r0" 
   
  ${If} $0 = "-1" 
    StrCpy $0 "0" 
    goto is_hard_link_end   
  ${EndIf} 
     
  System::Call "*(&i256 0) i. r1"        
  System::Call "kernel32::GetFileInformationByHandle(i r0, i r1) i .s" 
  System::Call "kernel32::CloseHandle(i r0) i.r0" 
  Pop $0 
   
  ${If} $0 == "0" 
    goto is_hard_link_end   
  ${EndIf}   
   
  System::Call "*$1(&i40 0, &i4 .r0)" 
   
  ${If} $0 != "0" 
    IntOp $0 $0 - 1   
  ${EndIf}     

  is_hard_link_end: 
  Pop $1 
FunctionEnd 

!macro IsHardLink Path outVar 
  Push $0 
  Push "${Path}" 
  Call IsHardLink 
  Exch $0 
  Pop ${outVar} 
!macroend 

!macro IsLink Path outVar 
  ${IsSoftLink} "${Path}" ${outVar} 

  ${If} ${outVar} == 0 
    ${IsHardLink} "${Path}" ${outVar} 
  ${EndIf}  
!macroend 

; files 
!define CreateHardLink "!insertmacro CreateHardLink" 
!define CreateSymbolicLinkFile "!insertmacro CreateSymbolicLinkFile" 
!define CreateLinkFile "!insertmacro CreateLinkFile" 
!define DeleteLinkFile "!insertmacro DeleteLinkFile" 

!macro CreateSymbolicLinkFile Junction Target outVar 
  ${CreateParentFolder} "${Junction}" 
  System::Call "kernel32::CreateSymbolicLinkW(w `${Junction}`, w `${Target}`, i 0) i .s" 
  Pop ${outVar} 
   
  ${If} ${outVar} == "error" 
    StrCpy ${outVar} "0" 
  ${EndIf} 
!macroend 

!macro CreateHardLink Junction Target outVar 
  ${CreateParentFolder} "${Junction}" 
  System::Call "kernel32::CreateHardLinkW(w `${Junction}`, w `${Target}`, i 0) i .s" 
   
  Pop ${outVar} 
   
  ${If} ${outVar} == 0   
    StrCpy ${outVar} "1" 
  ${Else} 
    StrCpy ${outVar} "0" 
  ${EndIf}   
!macroend 

!macro CreateLinkFile Junction Target outVar 
  ${CreateSymbolicLinkFile} "${Junction}" "${Target}" ${outVar} 
   
  ${If} ${outVar} == 0   
    ${CreateHardLink} "${Junction}" "${Target}" ${outVar}     
  ${EndIf} 
!macroend 

!macro DeleteLinkFile Path outVar 
  ${IsLink} "${Path}" ${outVar} 

  ${If} ${outVar} != 0 
    SetFileAttributes "${Path}" "NORMAL" 
    System::Call "kernel32::DeleteFileW(w `${Path}`) i.s" 
    Pop ${outVar} 
  ${EndIf} 
!macroend 

; folders 
!define CreateJunction "!insertmacro CreateJunction" 
!define CreateSymbolicLinkFolder "!insertmacro CreateSymbolicLinkFolder" 
!define CreateLinkFolder "!insertmacro CreateLinkFolder" 
!define DeleteLinkFolder "!insertmacro DeleteLinkFolder" 

Function CreateJunction 
  Exch $4 
  Exch 
  Exch $5 
  Push $1 
  Push $2 
  Push $3 
  Push $6 
  CreateDirectory "$5" 
  System::Call "kernel32::CreateFileW(w `$5`, i 0x40000000, i 0, i 0, i 3, i 0x02200000, i 0) i .r6" 

  ${If} $0 = "-1" 
    StrCpy $0 "0" 
    RMDir "$5"  
    goto create_junction_end   
  ${EndIf} 
   
  CreateDirectory "$4"  ; Windows XP requires that the destination exists 
  StrCpy $4 "\??\$4" 
  StrLen $0 $4 
  IntOp $0 $0 * 2   
  IntOp $1 $0 + 2 
  IntOp $2 $1 + 10 
  IntOp $3 $1 + 18 
  System::Call "*(i 0xA0000003, &i4 $2, &i2 0, &i2 $0, &i2 $1, &i2 0, &w$1 `$4`, &i2 0)i.r2" 
  System::Call "kernel32::DeviceIoControl(i r6, i 0x900A4, i r2, i r3, i 0, i 0, *i r4r4, i 0) i.r0" 
  System::Call "kernel32::CloseHandle(i r6) i.r1" 

  ${If} $0 == "0" 
    RMDir "$5"   
  ${EndIf} 
   
  create_junction_end: 
  Pop $6 
  Pop $3 
  Pop $2 
  Pop $1 
  Pop $5 
  Pop $4         
FunctionEnd 

!macro CreateJunction Junction Target outVar 
  Push $0 
  Push "${Junction}" 
  Push "${Target}" 
  Call CreateJunction 
  Exch $0 
  Pop ${outVar} 
!macroend 

!macro CreateSymbolicLinkFolder Junction Target outVar 
  ${CreateParentFolder} "${Junction}" 
  System::Call "kernel32::CreateSymbolicLinkW(w `${Junction}`, w `${Target}`, i 1) i .s" 
  Pop ${outVar} 
   
  ${If} ${outVar} == "error" 
    StrCpy ${outVar} "0" 
  ${EndIf} 
!macroend 

!macro CreateLinkFolder Junction Target outVar 
  ${CreateSymbolicLinkFolder} "${Junction}" "${Target}" ${outVar} 
   
  ${If} ${outVar} == 0 
    ${CreateJunction} "${Junction}" "${Target}" ${outVar}     
  ${EndIf}   
!macroend 

!macro DeleteLinkFolder Path outVar 
  ${IsSoftLink} "${Path}" ${outVar}  
   
  ${If} ${outVar} != 0 
    SetFileAttributes "${Path}" "NORMAL" 
    System::Call "kernel32::RemoveDirectoryW(w `${Path}`) i.s" 
    Pop ${outVar} 
  ${EndIf} 
!macroend 

; turn off NSIS warnings 
Section "-JunctionRemoveWarnings" 
  Return 
  Call CreateJunction 
  Call IsHardLink 
  Call IsSoftLink 
SectionEnd 

!endif  